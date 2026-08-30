public enum Schedule: Hashable, Sendable {
    case weekdays(Set<Weekday>)
    case dayOfMonth(DayOfMonth)

    public func isDue(on date: CalendarDate) -> Bool {
        switch self {
        case .weekdays(let weekdays):
            return weekdays.contains(date.weekday)
        case .dayOfMonth(let dayOfMonth):
            let scheduledDay = min(dayOfMonth.day, date.daysInMonth)
            return date.day == scheduledDay
        }
    }
}
