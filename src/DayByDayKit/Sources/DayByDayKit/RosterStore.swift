import Foundation

/// A roster kept at a place, across the app being closed and opened again. See
/// `openspec/specs/commitment/spec.md` for the behaviour contract and this change's `design.md`
/// § *The seam* for why the surface is shaped this way.
public final class RosterStore {
    private let place: URL

    /// Opens the roster store kept at `place`, reading what is there. A place where nothing has
    /// been kept opens holding nothing; a place holding something that cannot be read throws.
    public init(at place: URL) throws {
        self.place = place

        guard FileManager.default.fileExists(atPath: place.path) else {
            self.roster = Roster()
            return
        }

        let data = try Data(contentsOf: place)

        guard let envelope = try? JSONDecoder().decode(RosterDocumentEnvelope.self, from: data)
        else {
            throw RosterStoreError.notAStore(at: place)
        }
        guard (1...RosterDocument.currentVersion).contains(envelope.version) else {
            if envelope.version > RosterDocument.currentVersion {
                throw RosterStoreError.laterForm(at: place, version: envelope.version)
            }
            throw RosterStoreError.notAStore(at: place)
        }
        guard let document = try? JSONDecoder().decode(RosterDocument.self, from: data) else {
            throw RosterStoreError.notAStore(at: place)
        }
        // Each form is read as the shape that form has, per `design.md` § *The form on disk*:
        // the `removed` field is present on every entry at the form that introduced it and at
        // every form since, so its presence must agree with the declared version in both
        // directions. Checked against `removalIntroducedInVersion`, not `currentVersion` — the
        // two agree today only because form 3 is both, and a later form raising `currentVersion`
        // alone must not move which forms this check accepts. `category` is checked the same
        // way, against `categoryIntroducedInVersion`.
        guard
            document.commitments.allSatisfy({
                ($0.removed != nil) == (document.version >= RosterDocument.removalIntroducedInVersion)
                    && $0.categoryKeyPresent
                        == (document.version >= RosterDocument.categoryIntroducedInVersion)
            })
        else {
            throw RosterStoreError.notAStore(at: place)
        }
        guard let roster = document.formRoster() else {
            throw RosterStoreError.notAStore(at: place)
        }

        self.roster = roster
    }

    /// Exactly what is kept at `place`.
    public private(set) var roster: Roster

    /// Kept at `place` before this returns. Answers what `Roster.add` answers — `false`, without
    /// throwing and without writing, when the roster is already keeping `commitment`.
    @discardableResult
    public func add(_ commitment: Commitment) throws -> Bool {
        var nextRoster = roster
        guard nextRoster.add(commitment) else {
            return false
        }
        try write(nextRoster)

        roster = nextRoster
        return true
    }

    /// Kept at `place` before this returns. Answers what `Roster.add(_:under:)` answers —
    /// `false`, without throwing and without writing, when the roster is already keeping
    /// `commitment`.
    @discardableResult
    public func add(_ commitment: Commitment, under category: String?) throws -> Bool {
        var nextRoster = roster
        guard nextRoster.add(commitment, under: category) else {
            return false
        }
        try write(nextRoster)

        roster = nextRoster
        return true
    }

    /// Writes `nextRoster` as the whole document, in the byte-stable form `design.md` § *The
    /// form on disk* fixes: `.sortedKeys` so a keyed container's keys do not follow Foundation's
    /// per-process hash order, on top of the roster's own order, which is never sorted.
    private func write(_ nextRoster: Roster) throws {
        let document = RosterDocument(nextRoster)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let data = try encoder.encode(document)

        do {
            try FileManager.default.createDirectory(
                at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
            try data.write(to: place, options: .atomic)
        } catch {
            throw RosterStoreError.cannotWrite(at: place)
        }
    }

    /// Kept at `place` before this returns. Answers what `Roster.retire` answers — `false`,
    /// without throwing and without writing, when the roster does not hold `commitment` or has
    /// already stopped keeping it.
    @discardableResult
    public func retire(_ commitment: Commitment, keptUntil date: CalendarDate) throws -> Bool {
        var nextRoster = roster
        guard nextRoster.retire(commitment, keptUntil: date) else {
            return false
        }
        try write(nextRoster)

        roster = nextRoster
        return true
    }

    /// Kept at `place` before this returns. Answers what `Roster.remove` answers — `false`,
    /// without throwing and without writing, when the roster does not hold `commitment` or has
    /// already removed it.
    @discardableResult
    public func remove(_ commitment: Commitment, keptUntil date: CalendarDate) throws -> Bool {
        var nextRoster = roster
        guard nextRoster.remove(commitment, keptUntil: date) else {
            return false
        }
        try write(nextRoster)

        roster = nextRoster
        return true
    }

    /// Kept at `place` before this returns, unless the move left the roster exactly as it was.
    /// Answers what `Roster.move` answers — `true` even for a move that changed nothing, and
    /// `false`, without throwing and without writing, when the roster is not keeping
    /// `commitment` or `offset` is outside the commitments it is keeping. A store keeps what a
    /// change made, and a no-op made nothing, so this is the one call that can answer `true`
    /// without writing.
    @discardableResult
    public func move(_ commitment: Commitment, toOffset offset: Int, under category: String?)
        throws -> Bool
    {
        var nextRoster = roster
        guard nextRoster.move(commitment, toOffset: offset, under: category) else {
            return false
        }
        if nextRoster != roster {
            try write(nextRoster)
        }

        roster = nextRoster
        return true
    }

    /// Kept at `place` before this returns, unless putting `commitment` under `category` left
    /// the roster exactly as it was. Answers what `Roster.put` answers — `true` even where
    /// nothing changed, and `false`, without throwing and without writing, when the roster is
    /// not currently keeping `commitment`.
    @discardableResult
    public func put(_ commitment: Commitment, under category: String?) throws -> Bool {
        var nextRoster = roster
        guard nextRoster.put(commitment, under: category) else {
            return false
        }
        if nextRoster != roster {
            try write(nextRoster)
        }

        roster = nextRoster
        return true
    }
}

public enum RosterStoreError: Error, Equatable, Sendable {
    /// What is at `place` is not a store this app can read, or holds what could not be a roster.
    case notAStore(at: URL)
    /// A store in a form later than this app writes; `version` is the form found.
    case laterForm(at: URL, version: Int)
    /// The change could not be kept at `place`; nothing was held.
    case cannotWrite(at: URL)
}
