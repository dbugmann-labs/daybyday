import Foundation

public struct History: Hashable, Sendable {
    private var ticks: Set<Tick>
    private var numbers: [RecordedDay: Decimal]

    public init() {
        ticks = []
        numbers = [:]
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
    /// A commitment is kept by a tick or by a number, whichever its kind can produce: a tick
    /// keeps its day by being there, and every number does too, whatever the number is.
    public func isKept(_ commitment: Commitment, on date: CalendarDate) -> Bool {
        if let tick = Tick(commitment, on: date), ticks.contains(tick) {
            return true
        }

        return numbers[RecordedDay(commitment: commitment, date: date)] != nil
    }

    public func number(for commitment: Commitment, on date: CalendarDate) -> Decimal? {
        numbers[RecordedDay(commitment: commitment, date: date)]
    }
}
