import Foundation

public struct History: Hashable, Sendable {
    private var ticks: Set<Tick>
    private var numbers: [RecordedDay: Decimal]
    private var notes: [RecordedDay: String]

    public init() {
        ticks = []
        numbers = [:]
        notes = [:]
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
    /// either holds.
    public func isKept(_ commitment: Commitment, on date: CalendarDate) -> Bool {
        if let tick = Tick(commitment, on: date), ticks.contains(tick) {
            return true
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
}
