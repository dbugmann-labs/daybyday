import Foundation

/// A history kept at a place, across the app being closed and opened again. See
/// `openspec/specs/record/spec.md` for the behaviour contract and this change's `design.md` for
/// why the seam is shaped this way.
public final class RecordStore {
    private let place: URL

    /// Mirrors exactly what `history` holds. `History` keeps its own ticks and numbers private by
    /// design (see `RecordDocument.swift`), so the store keeps these alongside it — the one thing
    /// a write needs that `history` itself cannot give back out.
    private var ticks: Set<Tick>
    private var numbers: [RecordedDay: Decimal]

    /// Opens the store kept at `place`, reading what is there. A place where nothing has been
    /// kept opens empty; a place holding something that cannot be read as a store throws.
    public init(at place: URL) throws {
        self.place = place

        guard FileManager.default.fileExists(atPath: place.path) else {
            self.ticks = []
            self.numbers = [:]
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
        guard let document = try? JSONDecoder().decode(RecordDocument.self, from: data) else {
            throw RecordStoreError.notAStore(at: place)
        }
        // Each form is read as the shape that form has, per `design.md` § *Each form is read as
        // the shape that form has*: the `numbers` field is present at the form that introduced it
        // and at every form since, so its presence must agree with the declared version in both
        // directions. Checked against `numbersIntroducedInVersion`, not `currentVersion` — the two
        // agree today only because form 3 is both, and a later form raising `currentVersion` alone
        // must not move which forms this check accepts.
        guard (document.numbers != nil)
            == (document.version >= RecordDocument.numbersIntroducedInVersion)
        else {
            throw RecordStoreError.notAStore(at: place)
        }
        guard let ticks = document.formTicks(), let formedNumbers = document.formNumbers() else {
            throw RecordStoreError.notAStore(at: place)
        }

        self.ticks = ticks
        var history = History()
        for tick in ticks {
            history.add(tick)
        }
        var numbers: [RecordedDay: Decimal] = [:]
        for number in formedNumbers {
            numbers[RecordedDay(commitment: number.commitment, date: number.date)] = number.number
            history.add(number)
        }
        self.numbers = numbers
        self.history = history
    }

    /// Every tick and every number added and not since taken back — exactly what is kept at
    /// `place`.
    public private(set) var history: History

    /// Kept at `place` before this returns; on failure throws and leaves `history` as it was.
    public func add(_ tick: Tick) throws {
        var nextTicks = ticks
        nextTicks.insert(tick)
        try write(nextTicks, numbers)

        ticks = nextTicks
        history.add(tick)
    }

    public func remove(_ tick: Tick) throws {
        var nextTicks = ticks
        nextTicks.remove(tick)
        try write(nextTicks, numbers)

        ticks = nextTicks
        history.remove(tick)
    }

    /// Kept at `place` before this returns; on failure throws and leaves `history` as it was.
    public func add(_ number: Number) throws {
        var nextNumbers = numbers
        nextNumbers[RecordedDay(commitment: number.commitment, date: number.date)] = number.number
        try write(ticks, nextNumbers)

        numbers = nextNumbers
        history.add(number)
    }

    public func removeNumber(for commitment: Commitment, on date: CalendarDate) throws {
        var nextNumbers = numbers
        nextNumbers[RecordedDay(commitment: commitment, date: date)] = nil
        try write(ticks, nextNumbers)

        numbers = nextNumbers
        history.removeNumber(for: commitment, on: date)
    }

    /// Writes `nextTicks` and `nextNumbers` as the whole document, in the byte-stable form
    /// `design.md` § *The form on disk* fixes: `.sortedKeys` so a keyed container's keys do not
    /// follow Foundation's per-process hash order, on top of `RecordDocument`'s own stable order,
    /// so two equal sets of ticks and numbers always produce byte-identical files.
    private func write(_ nextTicks: Set<Tick>, _ nextNumbers: [RecordedDay: Decimal]) throws {
        let document = RecordDocument(nextTicks, nextNumbers)
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
