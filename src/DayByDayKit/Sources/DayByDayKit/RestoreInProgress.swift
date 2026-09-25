import Foundation

/// The state a restore keeps beside the record place before it writes anything, and undoes if it
/// stops before it is whole — mirroring `SaveInProgress`'s own place, but spanning all four
/// places rather than two. `openspec/changes/restore-from-a-copy/design.md` § *Whole or nothing,
/// across a stop* (ADR-1056): "Before it writes anything, a restore keeps a restore in progress
/// beside the record place, in one atomic file. It holds the bytes that stood at the three places
/// and at the save-in-progress place, or that nothing stood there. The restore then takes away
/// the save in progress, writes the record, the roster and the one-offs, and takes the file away.
/// If a write fails, it puts the bytes back and takes the file away, and if that fails too the
/// file stays."
struct RestoreInProgress: Codable {
    let record: Data?
    let roster: Data?
    let oneOffs: Data?
    let saveInProgress: Data?
    /// The birthday place's own snapshot — `nil` where this restore in progress was written
    /// before restores wrote the birthday place at all (an older-form file), told apart from a
    /// snapshot of a birthday place that held nothing (`BirthdaySnapshot(bytes: nil)`).
    /// `design.md` § *Migration*.
    let birthdayTicks: BirthdaySnapshot?

    /// Wraps the birthday place's bytes, or that nothing stood there, so the outer `Data?` on
    /// `birthdayTicks` can carry a third meaning — "this restore in progress predates the
    /// birthday place" — without colliding with "the birthday place held nothing".
    struct BirthdaySnapshot: Codable {
        let bytes: Data?
    }

    /// `restore-in-progress.json`, beside `recordPlace` — the same directory `SaveInProgress`
    /// keeps its own file in, so no initializer gains a parameter no caller ever chooses.
    static func place(besideRecordAt recordPlace: URL) -> URL {
        recordPlace.deletingLastPathComponent().appendingPathComponent("restore-in-progress.json")
    }

    /// The bytes at `place`, or `nil` where nothing stands there — never throws: a place this
    /// reads from before writing anything is read on a best-effort basis, and a place that cannot
    /// be read here fails the write that follows instead.
    private static func bytes(at place: URL) -> Data? {
        try? Data(contentsOf: place)
    }

    /// Puts `bytes` at `place`, or takes away whatever is there when `bytes` is `nil` — the one
    /// write both taking a snapshot's contents and rolling one back go through, so "nothing stood
    /// there" and "something stands there" are put back the same way they were read.
    private static func put(_ bytes: Data?, at place: URL) throws {
        guard let bytes else {
            if FileManager.default.fileExists(atPath: place.path) {
                try FileManager.default.removeItem(at: place)
            }
            return
        }
        try FileManager.default.createDirectory(
            at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
        try bytes.write(to: place, options: .atomic)
    }

    /// Restores `copy` at `recordPlace`, `rosterPlace`, `oneOffPlace` and `birthdayPlace`, whole
    /// or nothing: keeps a restore in progress beside `recordPlace` holding what stood at the
    /// four places and at a save in progress, takes the save in progress away, writes the four
    /// places in the forms they write now, and takes the restore in progress away. Throws where
    /// any write fails; the four places and the save in progress are then put back as they were,
    /// and the restore in progress taken away — unless that itself fails, in which case the
    /// restore in progress stands, for `undoTornRestore` to put right when the places are next
    /// opened.
    ///
    /// `stoppingAfter` a number of the four writes — record first, then roster, then one-offs,
    /// then the birthday ticks — stops after that many have happened, leaving the restore in
    /// progress standing and attempting no rollback: the test seam for a restore stopped before
    /// it was whole, on the same footing `SaveInProgress.keep` is for a save torn mid-change.
    /// `stoppingAfter: 4` stops with all four written, the restore in progress still standing —
    /// the crash lands between the last write and the file being taken away.
    static func restore(
        _ copy: Copy, recordAt recordPlace: URL, rosterAt rosterPlace: URL,
        oneOffsAt oneOffPlace: URL, birthdayTicksAt birthdayPlace: URL, stoppingAfter writes: Int? = nil
    ) throws {
        let saveInProgressPlace = SaveInProgress.place(besideRecordAt: recordPlace)
        let restoreInProgressPlace = Self.place(besideRecordAt: recordPlace)

        let snapshot = RestoreInProgress(
            record: bytes(at: recordPlace), roster: bytes(at: rosterPlace),
            oneOffs: bytes(at: oneOffPlace), saveInProgress: bytes(at: saveInProgressPlace),
            birthdayTicks: BirthdaySnapshot(bytes: bytes(at: birthdayPlace)))

        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys]
            let data = try encoder.encode(snapshot)
            try FileManager.default.createDirectory(
                at: restoreInProgressPlace.deletingLastPathComponent(),
                withIntermediateDirectories: true)
            try data.write(to: restoreInProgressPlace, options: .atomic)
        } catch {
            throw RestoreInProgressError.cannotWrite
        }

        let document = CopyDocument(copy)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]

        do {
            try Self.put(nil, at: saveInProgressPlace)

            guard writes != 0 else { return }
            try Self.put(try encoder.encode(document.record), at: recordPlace)

            guard writes != 1 else { return }
            try Self.put(try encoder.encode(document.roster), at: rosterPlace)

            guard writes != 2 else { return }
            try Self.put(try encoder.encode(document.oneOffs), at: oneOffPlace)

            guard writes != 3 else { return }
            try Self.put(try encoder.encode(document.birthdayTicks), at: birthdayPlace)

            guard writes != 4 else { return }
            try Self.put(nil, at: restoreInProgressPlace)
        } catch {
            do {
                try Self.put(snapshot.record, at: recordPlace)
                try Self.put(snapshot.roster, at: rosterPlace)
                try Self.put(snapshot.oneOffs, at: oneOffPlace)
                try Self.put(snapshot.saveInProgress, at: saveInProgressPlace)
                try Self.put(snapshot.birthdayTicks?.bytes, at: birthdayPlace)
                try Self.put(nil, at: restoreInProgressPlace)
            } catch {
                // The restore in progress stands; `undoTornRestore` puts it right when the
                // places are next opened. `design.md` § *Whole or nothing, across a stop*.
            }
            throw RestoreInProgressError.cannotWrite
        }
    }

    /// Undoes a restore in progress beside `recordPlace`, putting back what it holds at
    /// `recordPlace`, `rosterPlace`, `oneOffPlace`, `birthdayPlace` and the save-in-progress
    /// place beside `recordPlace`, then taking the restore in progress away. Answers `true` where
    /// no restore in progress stood, or where one stood and was undone; `false` where one stands
    /// and could not be undone — it could not be read, or putting any place back, or taking the
    /// file away, failed. Never partly undoes one: every place it holds is put back before the
    /// file itself is taken away. A restore in progress kept before restores wrote the birthday
    /// place holds no snapshot of it (`birthdayTicks == nil`) and leaves the birthday place as it
    /// stands. `design.md` § *Migration*.
    static func undoTornRestore(
        recordAt recordPlace: URL, rosterAt rosterPlace: URL, oneOffsAt oneOffPlace: URL,
        birthdayTicksAt birthdayPlace: URL
    ) -> Bool {
        let place = Self.place(besideRecordAt: recordPlace)

        guard FileManager.default.fileExists(atPath: place.path) else {
            return true
        }

        let snapshot: RestoreInProgress
        do {
            let data = try Data(contentsOf: place)
            snapshot = try JSONDecoder().decode(RestoreInProgress.self, from: data)
        } catch {
            return false
        }

        do {
            try Self.put(snapshot.record, at: recordPlace)
            try Self.put(snapshot.roster, at: rosterPlace)
            try Self.put(snapshot.oneOffs, at: oneOffPlace)
            try Self.put(
                snapshot.saveInProgress, at: SaveInProgress.place(besideRecordAt: recordPlace))
            if let birthdaySnapshot = snapshot.birthdayTicks {
                try Self.put(birthdaySnapshot.bytes, at: birthdayPlace)
            }
            try Self.put(nil, at: place)
        } catch {
            return false
        }

        return true
    }
}

enum RestoreInProgressError: Error, Equatable, Sendable {
    case cannotWrite
}
