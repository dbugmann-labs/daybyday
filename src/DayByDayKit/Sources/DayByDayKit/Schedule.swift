public enum Schedule: Hashable, Sendable {
    case weekdays(Set<Weekday>)

    public func isDue(on date: CalendarDate) -> Bool {
        switch self {
        case .weekdays(let weekdays):
            return weekdays.contains(date.weekday)
        }
    }
}
