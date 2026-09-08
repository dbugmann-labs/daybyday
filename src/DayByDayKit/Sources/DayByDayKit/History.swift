import Foundation

public struct History: Hashable, Sendable {
    private var ticks: Set<Tick>
    private var numbers: [RecordedDay: Decimal]
    private var notes: [RecordedDay: String]
    private var additions: [RecordedDay: [Decimal]]

    public init() {
        ticks = []
        numbers = [:]
        notes = [:]
        additions = [:]
    }

    public mutating func add(_ tick: Tick) {
        ticks.insert(tick)
    }

    public mutating func remove(_ tick: Tick) {
        ticks.remove(tick)
    }

    public mutating func add(_ number: Number) {
        numbers[RecordedDay(commitment: number.commitment, date: number.date)] = number.number
    }

    public mutating func removeNumber(for commitment: Commitment, on date: CalendarDate) {
        numbers[RecordedDay(commitment: commitment, date: date)] = nil
    }

    /// Re-forms a tick from `commitment` and `date` rather than testing `ticks` for one built
    /// directly, because `Tick` exposes neither part to build one from. That re-forming asks
    /// `Schedule.isDue(on:)` again, but not as a second, independent check: a tick can only be
    /// a member of `ticks` if its own formation already passed that same guard, and an equal
    /// `commitment` answers `isDue(on:)` the same way every time, so the answer here still
    /// comes from what `ticks` holds.
    ///
    /// A commitment is kept by a tick, by a number or by a note, whichever its kind can produce:
    /// a tick keeps its day by being there, and every number and every note does too, whatever
    /// either holds. A total is kept when the day's sum has reached its commitment's target —
    /// the comparison is the sum against the target, in that order, never the reverse.
    public func isKept(_ commitment: Commitment, on date: CalendarDate) -> Bool {
        if let tick = Tick(commitment, on: date), ticks.contains(tick) {
            return true
        }

        if case .total(let target) = commitment.kind {
            return total(for: commitment, on: date) >= target.amount
        }

        let day = RecordedDay(commitment: commitment, date: date)
        return numbers[day] != nil || notes[day] != nil
    }

    public func number(for commitment: Commitment, on date: CalendarDate) -> Decimal? {
        numbers[RecordedDay(commitment: commitment, date: date)]
    }

    public mutating func add(_ note: Note) {
        notes[RecordedDay(commitment: note.commitment, date: note.date)] = note.text
    }

    public mutating func removeNote(for commitment: Commitment, on date: CalendarDate) {
        notes[RecordedDay(commitment: commitment, date: date)] = nil
    }

    public func note(for commitment: Commitment, on date: CalendarDate) -> String? {
        notes[RecordedDay(commitment: commitment, date: date)]
    }

    /// What that day has added: the sum of the additions it holds, and zero where it holds
    /// none — for every commitment, on every date, whatever its kind.
    public func total(for commitment: Commitment, on date: CalendarDate) -> Decimal {
        let day = RecordedDay(commitment: commitment, date: date)
        return (additions[day] ?? []).reduce(0, +)
    }

    /// Appends to the day `addition` is for. A day holds many, in the order they were made, and
    /// a second addition alike in every way to the first is held beside it.
    public mutating func add(_ addition: Addition) {
        let day = RecordedDay(commitment: addition.commitment, date: addition.date)
        additions[day, default: []].append(addition.amount)
    }
}
