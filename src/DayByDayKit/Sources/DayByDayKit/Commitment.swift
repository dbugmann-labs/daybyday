public struct Commitment: Hashable, Sendable {
    public let name: String
    let schedule: Schedule
    let keptFrom: CalendarDate

    public init?(name: String, schedule: Schedule, keptFrom: CalendarDate) {
        guard !name.allSatisfy(\.isWhitespace) else {
            return nil
        }

        self.name = name
        self.schedule = schedule
        self.keptFrom = keptFrom
    }

    public func isDue(on date: CalendarDate) -> Bool {
        guard keptFrom.days(until: date) >= 0 else {
            return false
        }

        return schedule.isDue(on: date)
    }
}
