public struct Commitment: Hashable, Sendable {
    public let name: String
    let schedule: Schedule
    let keptFrom: CalendarDate

    public init?(name: String, schedule: Schedule, keptFrom: CalendarDate) {
        self.name = name
        self.schedule = schedule
        self.keptFrom = keptFrom
    }

    public func isDue(on date: CalendarDate) -> Bool {
        fatalError("not implemented")
    }
}
