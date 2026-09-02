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

    public func isKept(_ commitment: Commitment, on date: CalendarDate) -> Bool {
        guard let tick = Tick(commitment, on: date) else {
            return false
        }

        return ticks.contains(tick)
    }
}
