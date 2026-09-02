public struct History: Hashable, Sendable {
    private var ticks: Set<Tick>

    public init() {
        ticks = []
    }

    public mutating func add(_ tick: Tick) {
        ticks.insert(tick)
    }

    public mutating func remove(_ tick: Tick) {
        ticks.remove(tick)
    }

    /// Re-forms a tick from `commitment` and `date` rather than testing `ticks` for one built
    /// directly, because `Tick` exposes neither part to build one from. That re-forming asks
    /// `Schedule.isDue(on:)` again, but not as a second, independent check: a tick can only be
    /// a member of `ticks` if its own formation already passed that same guard, and an equal
    /// `commitment` answers `isDue(on:)` the same way every time, so the answer here still
    /// comes from what `ticks` holds.
    public func isKept(_ commitment: Commitment, on date: CalendarDate) -> Bool {
        guard let tick = Tick(commitment, on: date) else {
            return false
        }

        return ticks.contains(tick)
    }
}
