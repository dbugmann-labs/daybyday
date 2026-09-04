/// The four shapes a commitments screen offers, each carrying nothing the calendar does not
/// supply. Deliberately not a `Schedule`: an interval rhythm has no start date, because the day a
/// commitment is kept from is it.
public enum Rhythm: Hashable, Sendable {
    case weekdays(Set<Weekday>)
    case dayOfMonth(DayOfMonth)
    case everyNDays(DayInterval)
    case weeklyQuota(WeeklyQuota)

    /// The schedule this rhythm names when kept from `keptFrom` — an interval rhythm's start
    /// date is `keptFrom` and nothing else.
    func schedule(keptFrom: CalendarDate) -> Schedule {
        fatalError("not implemented")
    }
}
