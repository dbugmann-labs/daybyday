/// The four shapes a commitments screen offers, each carrying nothing the calendar does not
/// supply. Deliberately not a `Schedule`: an interval rhythm has no start date, because the day a
/// commitment is kept from is it. The three numeric cases carry the number a person gave, not a
/// value already judged — a rhythm is what was said, and `CommitmentsScreen.define` is the one
/// place that judges it.
public enum Rhythm: Hashable, Sendable {
    case weekdays(Set<Weekday>)
    case dayOfMonth(Int)
    case everyNDays(Int)
    case weeklyQuota(Int)

    /// The schedule this rhythm names when kept from `keptFrom` — an interval rhythm's start
    /// date is `keptFrom` and nothing else. Answers `nil` exactly when `DayOfMonth`,
    /// `DayInterval` or `WeeklyQuota` refuses the number this rhythm carries.
    func schedule(keptFrom: CalendarDate) -> Schedule? {
        switch self {
        case .weekdays(let weekdays):
            return .weekdays(weekdays)
        case .dayOfMonth(let day):
            guard let dayOfMonth = DayOfMonth(day: day) else {
                return nil
            }
            return .dayOfMonth(dayOfMonth)
        case .everyNDays(let days):
            guard let interval = DayInterval(days: days) else {
                return nil
            }
            return .everyNDays(interval, from: keptFrom)
        case .weeklyQuota(let timesPerWeek):
            guard let weeklyQuota = WeeklyQuota(timesPerWeek: timesPerWeek) else {
                return nil
            }
            return .weeklyQuota(weeklyQuota)
        }
    }
}
