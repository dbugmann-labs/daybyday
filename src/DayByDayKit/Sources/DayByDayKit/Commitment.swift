public struct Commitment: Hashable, Sendable {
    public let name: String
    let schedule: Schedule
    let keptFrom: CalendarDate
    public let kind: Kind

    public init?(name: String, schedule: Schedule, keptFrom: CalendarDate, kind: Kind = .tick) {
        guard !name.allSatisfy(\.isWhitespace) else {
            return nil
        }

        self.name = name
        self.schedule = schedule
        self.keptFrom = keptFrom
        self.kind = kind
    }

    public func isDue(on date: CalendarDate) -> Bool {
        guard keptFrom.days(until: date) >= 0 else {
            return false
        }

        return schedule.isDue(on: date)
    }
}
