import Foundation

/// A history kept at a place, across the app being closed and opened again. See
/// `openspec/specs/record/spec.md` for the behaviour contract and this change's `design.md` for
/// why the seam is shaped this way.
public final class RecordStore {
    private let place: URL

    /// Opens the store kept at `place`, reading what is there. A place where nothing has been
    /// kept opens empty; a place holding something that cannot be read as a store throws.
    public init(at place: URL) throws {
        self.place = place

        guard FileManager.default.fileExists(atPath: place.path) else {
            self.history = History()
            return
        }

        let data = try Data(contentsOf: place)

        guard let envelope = try? JSONDecoder().decode(RecordDocumentEnvelope.self, from: data) else {
            throw RecordStoreError.notAStore(at: place)
        }
        guard (1...RecordDocument.currentVersion).contains(envelope.version) else {
            if envelope.version > RecordDocument.currentVersion {
                throw RecordStoreError.laterForm(at: place, version: envelope.version)
            }
            throw RecordStoreError.notAStore(at: place)
        }
        guard let document = try? JSONDecoder().decode(RecordDocument.self, from: data),
            let formed = Self.formed(from: document)
        else {
            throw RecordStoreError.notAStore(at: place)
        }

        self.history = formed
    }

    /// Whether `document`'s shape agrees with its own declared form, per `design.md` § *Each
    /// form is read as the shape that form has*: the `numbers`, `notes` and `additions` fields
    /// are each present at the form that introduced them and at every form since, so their
    /// presence must agree with the declared version in both directions. Checked against each
    /// field's own `...IntroducedInVersion` constant, not `currentVersion` — judged against the
    /// form each part was first written at, never against whichever form happens to be the newest.
    /// `identity`, on every record's commitment across all four kinds, is checked the same way.
    private static func shapeMatchesItsForm(_ document: RecordDocument) -> Bool {
        guard
            (document.numbers != nil)
                == (document.version >= RecordDocument.numbersIntroducedInVersion),
            (document.notes != nil)
                == (document.version >= RecordDocument.notesIntroducedInVersion),
            (document.additions != nil)
                == (document.version >= RecordDocument.additionsIntroducedInVersion),
            (document.declines != nil)
                == (document.version >= RecordDocument.declinesIntroducedInVersion)
        else {
            return false
        }

        let identityExpected = document.version >= RecordDocument.identityIntroducedInVersion
        // A shift kept beside a record belongs to the forms since it was introduced; where it is
        // present is a record's own business, so only a form before it is judged here.
        let shiftsPossible = document.version >= RecordDocument.shiftsIntroducedInVersion
        let shiftedToPossible = document.version >= RecordDocument.shiftedToIntroducedInVersion
        func agrees(_ commitment: CommitmentRecord) -> Bool {
            commitment.identityKeyPresent == identityExpected
                && (shiftsPossible || commitment.shiftedFrom == nil)
                && (shiftedToPossible || commitment.shiftedTo == nil)
        }
        return document.ticks.allSatisfy { agrees($0.commitment) }
            && (document.numbers ?? []).allSatisfy { agrees($0.commitment) }
            && (document.notes ?? []).allSatisfy { agrees($0.commitment) }
            && (document.additions ?? []).allSatisfy { agrees($0.commitment) }
            && (document.declines ?? []).allSatisfy { agrees($0.commitment) }
    }

    /// Forms the history `document` holds — `nil` where its shape disagrees with its own declared
    /// form, where any one record fails to form, or where a decline sits beside another record of
    /// its commitment on its day, which a history never holds. The one place `init(at:)` reads a
    /// decoded document, shared with `CopyDocument.read`'s own per-store reading — `openspec/
    /// changes/restore-from-a-copy/design.md` § *Reading a copy: the envelope decides, and a later
    /// version outranks damage* — so a copy's nested record is judged by exactly the rule a
    /// store's own place is.
    static func formed(from document: RecordDocument) -> History? {
        guard document.version >= 1, shapeMatchesItsForm(document), let ticks = document.formTicks(),
            let formedNumbers = document.formNumbers(), let formedNotes = document.formNotes(),
            let formedAdditions = document.formAdditions(),
            let formedDeclines = document.formDeclines()
        else {
            return nil
        }

        var history = History()
        for tick in ticks {
            history.add(tick)
        }
        for number in formedNumbers {
            history.add(number)
        }
        for note in formedNotes {
            history.add(note)
        }
        for addition in formedAdditions {
            history.add(addition)
        }
        for decline in formedDeclines {
            guard !history.holdsARecord(of: decline.commitment, on: decline.date) else {
                return nil
            }
            history.add(decline)
        }

        return history
    }

    /// Every tick and every number added and not since taken back — exactly what is kept at
    /// `place`.
    public private(set) var history: History

    /// Kept at `place` before this returns; on failure throws and leaves `history` as it was.
    public func add(_ tick: Tick) throws {
        try keep { $0.add(tick) }
    }

    public func remove(_ tick: Tick) throws {
        try keep { $0.remove(tick) }
    }

    /// Kept at `place` before this returns; on failure throws and leaves `history` as it was.
    public func add(_ decline: Decline) throws {
        try keep { $0.add(decline) }
    }

    public func removeDecline(for commitment: Commitment, on date: CalendarDate) throws {
        try keep { $0.removeDecline(for: commitment, on: date) }
    }

    /// Kept at `place` before this returns; on failure throws and leaves `history` as it was.
    public func add(_ number: Number) throws {
        try keep { $0.add(number) }
    }

    public func removeNumber(for commitment: Commitment, on date: CalendarDate) throws {
        try keep { $0.removeNumber(for: commitment, on: date) }
    }

    /// Kept at `place` before this returns; on failure throws and leaves `history` as it was.
    public func add(_ note: Note) throws {
        try keep { $0.add(note) }
    }

    public func removeNote(for commitment: Commitment, on date: CalendarDate) throws {
        try keep { $0.removeNote(for: commitment, on: date) }
    }

    /// Kept at `place` before this returns; on failure throws and leaves `history` as it was.
    public func add(_ addition: Addition) throws {
        try keep { $0.add(addition) }
    }

    public func removeLastAddition(for commitment: Commitment, on date: CalendarDate) throws {
        try keep { $0.removeLastAddition(for: commitment, on: date) }
    }

    /// Forms the next history by `change`, writes everything that history holds, and only then
    /// takes it — so a record that replaced another leaves nothing of it at the place, whichever
    /// of the five kinds either was (`design.md` § *The store writes what its history holds*).
    /// Writes nothing where `change` leaves the history as it was.
    private func keep(_ change: (inout History) -> Void) throws {
        var nextHistory = history
        change(&nextHistory)
        guard nextHistory != history else {
            return
        }
        try write(nextHistory)

        history = nextHistory
    }

    /// Gives every record `fold` names an identity that identity, drops every record it maps to
    /// `nil`, and writes only where something moved. Answers whether anything moved. `design.md`
    /// § *The seam* and § *Migration*.
    @discardableResult
    public func settle(_ fold: [CommitmentRecord: Commitment.Identity?]) throws -> Bool {
        var nextHistory = history
        guard nextHistory.settle(fold) else {
            return false
        }

        try write(nextHistory)

        history = nextHistory

        return true
    }

    /// Erases, at `place`, every record held of a commitment whose identity is in `identities` —
    /// writing nothing where none of them holds a record. Answers whether anything was erased.
    /// The one primitive a single commitment's whole-or-nothing deletion and the upgrade's
    /// migration erasure both use, one identity or many alike. `design.md` § *The seam*.
    @discardableResult
    public func erase(_ identities: Set<Commitment.Identity>) throws -> Bool {
        var nextHistory = history
        guard nextHistory.erase(identities) else {
            return false
        }

        try write(nextHistory)

        history = nextHistory

        return true
    }

    /// Kept at `place` in one write, replacing the whole record with `nextHistory` — the one way
    /// to put the record place back exactly as it was after an erasure a later refusal must undo.
    /// Package-internal: `CommitmentsScreen.confirmDeleting()` is the one caller, on a roster
    /// refusal that follows a kept erasure — `design.md` § *Deletion writes the record place first
    /// and puts it back*.
    @discardableResult
    func replace(with nextHistory: History) throws -> Bool {
        try write(nextHistory)

        history = nextHistory

        return true
    }

    /// Carries every record held of `commitment` over to `changed`, kept at `place` before this
    /// returns. `false` is the history's own refusal, reported without an error and without a
    /// write; a place that could not be written throws, as every other change does. See
    /// `openspec/specs/record/spec.md` § *A store carries every record of one commitment over to
    /// another, at its place*.
    @discardableResult
    public func carryOver(_ commitment: Commitment, to changed: Commitment) throws -> Bool {
        try carryOver(commitment, to: changed) { nextHistory in
            nextHistory.carryOver(commitment, to: changed)
        }
    }

    /// Carries every record of `orphan` back to `source`, kept at `place` before this returns —
    /// refuses only where a record would land on a day `source` already holds a record on,
    /// `design.md` § *Carrying back refuses only on a shared day*. Package-internal:
    /// `SaveInProgress` is the only caller, to undo a torn save and to carry an orphaned record
    /// back to its one possible source.
    @discardableResult
    func carryBack(_ orphan: Commitment, to source: Commitment) throws -> Bool {
        try carryOver(orphan, to: source) { nextHistory in
            nextHistory.carryBack(orphan, to: source)
        }
    }

    /// The act `carryOver` and `carryBack` perform: ask `historyCarryOver` to carry `history`
    /// itself over — the one place each one's own refusal rules are judged — then write the
    /// history that came of it, only where it changed anything.
    private func carryOver(
        _ commitment: Commitment, to changed: Commitment,
        historyCarryOver: (inout History) -> Bool
    ) throws -> Bool {
        var nextHistory = history
        guard historyCarryOver(&nextHistory) else {
            return false
        }
        guard nextHistory != history else {
            return true
        }

        try write(nextHistory)

        history = nextHistory

        return true
    }

    /// Writes everything `nextHistory` holds as the whole document, in the byte-stable form
    /// `design.md` § *The form on disk* fixes: `.sortedKeys` so a keyed container's keys do not
    /// follow Foundation's per-process hash order, on top of `RecordDocument`'s own stable order,
    /// so two equal histories always produce byte-identical files.
    private func write(_ nextHistory: History) throws {
        let parts = nextHistory.recordDocumentParts()
        let document = RecordDocument(
            ticks: parts.ticks, numbers: parts.numbers, notes: parts.notes,
            additions: parts.additions, declines: parts.declines)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]

        do {
            let data = try encoder.encode(document)
            try FileManager.default.createDirectory(
                at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
            try data.write(to: place, options: .atomic)
        } catch {
            throw RecordStoreError.cannotWrite(at: place)
        }
    }
}

public enum RecordStoreError: Error, Equatable, Sendable {
    /// What is at `place` is not a store this app can read: it holds what could not be a tick or
    /// a number, a number its commitment would refuse, or a shape that disagrees with its
    /// declared form.
    case notAStore(at: URL)
    /// A store in a form later than this app writes; `version` is the form found.
    case laterForm(at: URL, version: Int)
    /// The change could not be kept at `place`; nothing was held.
    case cannotWrite(at: URL)
}
