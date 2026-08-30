public enum Schedule: Hashable, Sendable {
    case weekdays(Set<Weekday>)

    public func isDue(on date: CalendarDate) -> Bool {
        fatalError("not implemented")
    }
}
