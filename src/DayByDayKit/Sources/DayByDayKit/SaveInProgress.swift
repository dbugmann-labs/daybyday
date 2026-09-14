import Foundation

/// A change or a restart that carries records notes, beside the record place, which commitment
/// its records are being carried from and which they are being carried to — kept before either
/// place is written and taken away once the roster place is, so a save killed or refused between
/// the two leaves a durable trace of what it was doing. See `openspec/specs/commitment/spec.md`
/// §§ *A change that carries records leaves a save in progress until its roster place is
/// written* and *Reading the places undoes a torn save as it was*, and this change's `design.md`
/// § *The save in progress lives beside the record place, not at a place of its own* and §
/// *A save finished is told by the roster, not by the file*.
struct SaveInProgress: Equatable, Codable {
    let carriedFrom: Commitment
    let carried: Commitment

    init(carriedFrom source: Commitment, to carried: Commitment) {
        self.carriedFrom = source
        self.carried = carried
    }

    private enum CodingKeys: String, CodingKey {
        case carriedFrom, carried
    }

    /// Read as the same wire shape `RecordDocument` and `RosterDocument` already keep a
    /// commitment in — `CommitmentCoding.swift`'s `CommitmentRecord` — rather than a shape of
    /// its own, so a fifth `Schedule` or `Commitment.Kind` case is still one compile error, not
    /// three.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let carriedFromRecord = try container.decode(CommitmentRecord.self, forKey: .carriedFrom)
        let carriedRecord = try container.decode(CommitmentRecord.self, forKey: .carried)
        guard let carriedFrom = carriedFromRecord.commitment(),
            let carried = carriedRecord.commitment()
        else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "a save in progress names a commitment that could not be formed")
            )
        }
        self.carriedFrom = carriedFrom
        self.carried = carried
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(CommitmentRecord(carriedFrom), forKey: .carriedFrom)
        try container.encode(CommitmentRecord(carried), forKey: .carried)
    }

    /// `save-in-progress.json`, in the same directory as `recordPlace` — beside it rather than at
    /// a place of its own, so no initializer gains a parameter no caller ever chooses.
    static func place(besideRecordAt recordPlace: URL) -> URL {
        recordPlace.deletingLastPathComponent().appendingPathComponent("save-in-progress.json")
    }

    /// Kept at `place` before this returns, in the same byte-stable form every other store
    /// writes: `.sortedKeys` on top of `CodingKeys`' own declared order. Throws, writing nothing,
    /// where `place` could not be written.
    func keep(at place: URL) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let data = try encoder.encode(self)
        try FileManager.default.createDirectory(
            at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
        try data.write(to: place, options: .atomic)
    }

    /// The save in progress kept at `place`, or `nil` where nothing has been kept there. Throws
    /// where what is there cannot be read as one.
    static func read(at place: URL) throws -> SaveInProgress? {
        guard FileManager.default.fileExists(atPath: place.path) else {
            return nil
        }
        let data = try Data(contentsOf: place)
        return try JSONDecoder().decode(SaveInProgress.self, from: data)
    }

    /// Removes the save in progress kept at `place`, doing nothing where none is.
    private static func takeAway(at place: URL) throws {
        guard FileManager.default.fileExists(atPath: place.path) else {
            return
        }
        try FileManager.default.removeItem(at: place)
    }

    /// Undoes a save in progress beside `recordPlace`, exactly as reading the places does: told a
    /// save finished by the roster at `rosterPlace`, not by the file — `design.md` § *A save
    /// finished is told by the roster, not by the file*. Answers `true` where no save in progress
    /// stood, where one stood and the roster already held its carried commitment in any state
    /// (nothing but the file itself is touched), or where one stood and was undone — its records
    /// carried back to the commitment they came from and the file taken away. Answers `false`
    /// where one stands and could not be undone: it could not be read or taken away, either
    /// place could not be read, the record place could not be written, or its records could not
    /// be carried back — `design.md` § *A torn save that cannot be undone reuses two existing
    /// states*. Never partly undoes one: the file is taken away only once the record place holds
    /// the carried-back records, or once the roster is confirmed to already hold what it names.
    static func undoTornSave(recordAt recordPlace: URL, rosterAt rosterPlace: URL) -> Bool {
        let place = Self.place(besideRecordAt: recordPlace)

        let saveInProgress: SaveInProgress?
        do {
            saveInProgress = try read(at: place)
        } catch {
            return false
        }

        guard let saveInProgress else {
            return true
        }

        guard let rosterStore = try? RosterStore(at: rosterPlace) else {
            return false
        }

        if rosterStore.roster.entries.contains(where: { $0.commitment == saveInProgress.carried }) {
            do {
                try takeAway(at: place)
            } catch {
                return false
            }
            return true
        }

        guard let recordStore = try? RecordStore(at: recordPlace) else {
            return false
        }

        do {
            guard try recordStore.carryBack(saveInProgress.carried, to: saveInProgress.carriedFrom)
            else {
                return false
            }
        } catch {
            return false
        }

        do {
            try takeAway(at: place)
        } catch {
            return false
        }
        return true
    }

    /// Carries every commitment `store`'s history holds records of that `roster` holds in no
    /// state back to its one possible source, where it has exactly one that holds no record on
    /// any of the same dates and no other such commitment holds as its own one possible source —
    /// `openspec/specs/commitment/spec.md` § *Reading the places carries an orphaned record back
    /// to its one possible source* and `design.md` § *Two orphans with one source move neither*.
    /// Every other orphan stays where it is. Answers whether `store`'s history still holds any
    /// record of a commitment `roster` holds in no state once this is done — what a commitments
    /// screen needs to say whether records belong to no commitment.
    @discardableResult
    static func carryBackOrphanedRecords(in store: RecordStore, against roster: Roster) -> Bool {
        let known = Set(roster.entries.map(\.commitment))
        let orphans = store.history.commitmentsWithRecords().subtracting(known)

        var candidatesByOrphan: [Commitment: [Commitment]] = [:]
        for orphan in orphans {
            let dates = store.history.datesRecorded(for: orphan)
            candidatesByOrphan[orphan] = roster.entries.map(\.commitment).filter { candidate in
                candidate.kind == orphan.kind && Rhythm(candidate.schedule) == Rhythm(orphan.schedule)
                    && dates.allSatisfy { candidate.isDue(on: $0) }
            }
        }

        var candidateCounts: [Commitment: Int] = [:]
        for candidates in candidatesByOrphan.values where candidates.count == 1 {
            candidateCounts[candidates[0], default: 0] += 1
        }

        var stillOrphaned = false
        for orphan in orphans {
            guard let candidates = candidatesByOrphan[orphan], candidates.count == 1,
                candidateCounts[candidates[0]] == 1,
                (try? store.carryBack(orphan, to: candidates[0])) == true
            else {
                stillOrphaned = true
                continue
            }
        }

        return stillOrphaned
    }
}
