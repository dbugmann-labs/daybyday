import Foundation

/// A roster kept at a place, across the app being closed and opened again. See
/// `openspec/specs/commitment/spec.md` for the behaviour contract and this change's `design.md`
/// § *The seam* for why the surface is shaped this way.
public final class RosterStore {
    private let place: URL

    /// Opens the roster store kept at `place`, reading what is there. A place where nothing has
    /// been kept opens holding nothing; a place holding something that cannot be read throws. A
    /// document before `RosterDocument.identityIntroducedInVersion` is folded once, as
    /// `design.md` § *Migration* describes; a later one is read as it stands.
    public init(at place: URL) throws {
        self.place = place

        guard FileManager.default.fileExists(atPath: place.path) else {
            self.roster = Roster()
            self.fold = [:]
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
        guard let document = try? JSONDecoder().decode(RosterDocument.self, from: data),
            Self.shapeAgrees(with: document)
        else {
            throw RosterStoreError.notAStore(at: place)
        }

        if document.version < RosterDocument.identityIntroducedInVersion {
            guard let fold = document.folded() else {
                throw RosterStoreError.notAStore(at: place)
            }
            self.roster = fold.roster
            self.fold = fold.identities
        } else {
            guard let formed = document.formRoster() else {
                throw RosterStoreError.notAStore(at: place)
            }
            self.roster = formed
            self.fold = [:]
        }
    }

    /// Forms the roster `document` holds — folded once where it predates
    /// `identityIntroducedInVersion`, read as it stands otherwise, per `design.md` § *Migration* —
    /// or `nil` where its shape disagrees with its own declared form or it could not be formed.
    /// Shared with `CopyDocument.read`'s own per-store reading, which has no use for a fold's
    /// identities and so is not the one place `init(at:)` needs them from.
    static func formed(from document: RosterDocument) -> Roster? {
        guard Self.shapeAgrees(with: document) else {
            return nil
        }
        if document.version < RosterDocument.identityIntroducedInVersion {
            return document.folded()?.roster
        }
        return document.formRoster()
    }

    /// Whether every entry's shape agrees with what `document.version` declares it should carry,
    /// per `design.md` § *The form on disk*: `removed` present on every entry between the form
    /// that introduced it and the form that retired it, and absent at every other form — checked
    /// against `removalIntroducedInVersion` and `removalRetiredInVersion`, not `currentVersion`,
    /// so a later form raising `currentVersion` alone cannot silently move which forms this check
    /// accepts. `category` and `identity` are each checked the same way, against their own
    /// introduced-at constant. The document's own top-level `emptied` is checked the same way
    /// too, against `emptiedIntroducedInVersion` — present exactly at the forms that carry it —
    /// and, where present, MUST NOT say the roster was emptied while an entry is still in it: a
    /// roster that says it was emptied and yet holds a commitment could not have been written by
    /// this app, `design.md` § *A roster store that cannot be read is refused rather than
    /// emptied*. The one place `init(at:)` reads a decoded document into this store's own shape,
    /// shared with `CopyDocument.read`'s own per-store reading — `openspec/changes/
    /// restore-from-a-copy/design.md` § *Reading a copy: the envelope decides, and a later
    /// version outranks damage*.
    private static func shapeAgrees(with document: RosterDocument) -> Bool {
        guard document.version >= 1 else {
            return false
        }
        let entriesAgree = document.commitments.allSatisfy {
            ($0.removed != nil)
                == (document.version >= RosterDocument.removalIntroducedInVersion
                    && document.version < RosterDocument.removalRetiredInVersion)
                && $0.categoryKeyPresent
                    == (document.version >= RosterDocument.categoryIntroducedInVersion)
                && $0.commitment.identityKeyPresent
                    == (document.version >= RosterDocument.identityIntroducedInVersion)
        }
        let emptiedKeyAgrees =
            (document.emptied != nil)
            == (document.version >= RosterDocument.emptiedIntroducedInVersion)
        let emptiedConsistent = document.emptied != true || document.commitments.isEmpty
        return entriesAgree && emptiedKeyAgrees && emptiedConsistent
    }

    /// Exactly what is kept at `place`.
    public private(set) var roster: Roster

    /// The mapping the fold made while opening this store — each stored commitment record's
    /// identity, or `nil` where the fold dropped it — or empty where nothing at `place` needed
    /// folding. `design.md` § *The seam* and § *Migration*.
    public private(set) var fold: [CommitmentRecord: Commitment.Identity?]

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

    /// Kept at `place` before this returns. Answers what `Roster.delete` answers — `false`,
    /// without throwing and without writing, when the roster does not hold `commitment` — one it
    /// does not hold at all, one already deleted included.
    @discardableResult
    public func delete(_ commitment: Commitment) throws -> Bool {
        var nextRoster = roster
        guard nextRoster.delete(commitment) else {
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

    /// Kept at `place` before this returns, unless the move left the roster exactly as it was.
    /// Answers what `Roster.move(group:toOffset:)` answers — `true` even for a move that
    /// changed nothing, and `false`, without throwing and without writing, when `category` —
    /// normalized — names no group this roster is keeping under a category, or `offset` is
    /// outside the groups it is keeping under one.
    @discardableResult
    public func move(group category: String?, toOffset offset: Int) throws -> Bool {
        var nextRoster = roster
        guard nextRoster.move(group: category, toOffset: offset) else {
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

    /// Kept at `place` before this returns, unless renaming `commitment` left the roster exactly
    /// as it was. Answers what `Roster.rename` answers — `false`, without throwing and without
    /// writing, when the roster does not hold `commitment` or `name` is already held by another.
    /// Whether anything changed is judged by the name itself, not `nextRoster != roster`: equality
    /// is the identity now, so two rosters differing in name alone compare equal, and `Roster.rename`
    /// rebuilds every matching entry whether or not `name` is the one it already carries.
    @discardableResult
    public func rename(_ commitment: Commitment, to name: String) throws -> Bool {
        var nextRoster = roster
        guard nextRoster.rename(commitment, to: name) else {
            return false
        }
        let alreadyNamed = roster.entries.contains {
            $0.commitment.identity == commitment.identity && $0.commitment.name == name
        }
        if !alreadyNamed {
            try write(nextRoster)
        }

        roster = nextRoster
        return true
    }

    /// Kept at `place` before this returns. Answers what `Roster.put(era:on:keptUntil:under:)`
    /// answers — `false`, without throwing and without writing, when the roster is not currently
    /// keeping `commitment`, or when `era` does not carry its identity, its name or the sort of
    /// its kind.
    @discardableResult
    public func put(
        era: Commitment, on commitment: Commitment, keptUntil date: CalendarDate,
        under category: String?
    ) throws -> Bool {
        var nextRoster = roster
        guard nextRoster.put(era: era, on: commitment, keptUntil: date, under: category) else {
            return false
        }
        try write(nextRoster)

        roster = nextRoster
        return true
    }

    /// Kept at `place` before this returns, unless changing `commitment` for itself left the
    /// roster exactly as it was. Answers what `Roster.change` answers — `true` even where
    /// nothing changed, and `false`, without throwing and without writing, when the roster does
    /// not hold `commitment`, or when `changed` is a commitment it already holds. Whether
    /// anything changed is judged by `rostersMatchInEveryField`, not `nextRoster != roster`:
    /// `Roster`'s equality is the identity alone, the same reason `rename`'s own doc comment
    /// gives, and cannot be trusted to notice an era whose schedule, kept-from day or kind
    /// changed while its identity did not.
    @discardableResult
    public func change(_ commitment: Commitment, to changed: Commitment, under category: String?)
        throws -> Bool
    {
        var nextRoster = roster
        guard nextRoster.change(commitment, to: changed, under: category) else {
            return false
        }
        if !rostersMatchInEveryField(nextRoster, roster) {
            try write(nextRoster)
        }

        roster = nextRoster
        return true
    }

    /// Kept at `place` in one write, replacing the whole roster with `nextRoster`. For a caller
    /// that must apply more than one `Roster` mutation as a single act — a rename, a day-move and
    /// a new era put on, say — building the combined value first and handing it here keeps them
    /// from ever being kept as separate writes, where a place that goes unwritable partway
    /// through could leave one half kept and the rest refused. Always writes: unlike `rename`'s
    /// own "whether anything changed is judged by the name itself, not `nextRoster != roster`"
    /// (`RosterStore.rename`'s own doc comment), a caller here has already judged for itself that
    /// something changed, and `Roster`'s equality — identity alone — cannot be trusted to agree
    /// when a rename or a day-move is the only thing that did, since neither touches an entry's
    /// identity, its `keptUntil` or its category, the only fields two `Roster` values are
    /// compared on beyond an entry's very presence.
    @discardableResult
    func replace(with nextRoster: Roster) throws -> Bool {
        try write(nextRoster)

        roster = nextRoster
        return true
    }

    /// Whether `lhs` and `rhs` hold the same eras in the same places — every part of each entry,
    /// not only its commitment's identity, which is all `Roster.==` compares. `change`'s own doc
    /// comment is why: an era's schedule, kept-from day and kind can differ while its identity
    /// does not, and `Roster`'s equality, inherited from `Commitment.==`, would call the two
    /// rosters the same.
    private func rostersMatchInEveryField(_ lhs: Roster, _ rhs: Roster) -> Bool {
        guard lhs.entries.count == rhs.entries.count else { return false }
        return zip(lhs.entries, rhs.entries).allSatisfy { a, b in
            a.commitment.identity == b.commitment.identity && a.commitment.name == b.commitment.name
                && a.commitment.schedule == b.commitment.schedule
                && a.commitment.keptFrom == b.commitment.keptFrom
                && a.commitment.kind == b.commitment.kind && a.keptUntil == b.keptUntil
                && a.category == b.category
        }
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
