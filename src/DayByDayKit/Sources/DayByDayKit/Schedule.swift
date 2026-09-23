public enum Schedule: Hashable, Sendable {
    case weekdays(Set<Weekday>)
    case dayOfMonth(DayOfMonth)
    case everyNDays(DayInterval, from: CalendarDate)
    case weeklyQuota(WeeklyQuota)

    /// The rhythm this schedule runs on, in words. See
    /// `docs/adr/1034-a-schedule-says-its-rhythm-in-words.md`.
    public var inWords: String {
        switch self {
        case .weekdays(let weekdays):
            return ScheduleWords.weekdays(weekdays)
        case .dayOfMonth(let dayOfMonth):
            return ScheduleWords.dayOfMonth(dayOfMonth.day)
        case .everyNDays(let interval, from: _):
            return ScheduleWords.everyNDays(interval.days)
        case .weeklyQuota(let weeklyQuota):
            return ScheduleWords.weeklyQuota(weeklyQuota.timesPerWeek)
        }
    }

    /// The rhythm this schedule runs on, in words, given a count — a weekly quota said given one
    /// says it before its words, as given and judging none; every other shape says its plain
    /// words. See `docs/adr/1034-a-schedule-says-its-rhythm-in-words.md`.
    public func inWords(given count: Int) -> String {
        switch self {
        case .weeklyQuota(let weeklyQuota):
            return ScheduleWords.weeklyQuota(weeklyQuota.timesPerWeek, given: count)
        case .weekdays, .dayOfMonth, .everyNDays:
            return inWords
        }
    }

    /// The rhythm this schedule runs on, in words, given a count and what a week owes — a weekly
    /// quota said given both says the count, a slash, and what the week owes in place of its own
    /// number of times; every other shape says its plain words and ignores both numbers. See
    /// `openspec/changes/stop-and-resume-as-eras/design.md` § *One week rule, in one place*.
    public func inWords(given count: Int, owing owed: Int) -> String {
        switch self {
        case .weeklyQuota:
            return ScheduleWords.weeklyQuota(given: count, owing: owed)
        case .weekdays, .dayOfMonth, .everyNDays:
            return inWords
        }
    }

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
        case .weeklyQuota:
            return true
        }
    }
}
