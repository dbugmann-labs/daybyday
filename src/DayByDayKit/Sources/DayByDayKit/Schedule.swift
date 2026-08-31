public enum Schedule: Hashable, Sendable {
    case weekdays(Set<Weekday>)
    case dayOfMonth(DayOfMonth)
    case everyNDays(DayInterval, from: CalendarDate)

    public func isDue(on date: CalendarDate) -> Bool {
        switch self {
        case .weekdays(let weekdays):
            return weekdays.contains(date.weekday)
        case .dayOfMonth(let dayOfMonth):
            let scheduledDay = min(dayOfMonth.day, date.daysInMonth)
            return date.day == scheduledDay
        case .everyNDays(let interval, from: let start):
            let count = start.days(until: date)
            guard count >= 0 else {
                return false
            }
            return count % interval.days == 0
        }
    }
}
