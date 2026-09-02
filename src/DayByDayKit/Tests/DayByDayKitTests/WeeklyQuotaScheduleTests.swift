import Testing
import DayByDayKit

@Test("a weekly quota is due on every date of a week")
func aWeeklyQuotaIsDueOnEveryDateOfAWeek() {
    let schedule = Schedule.weeklyQuota(WeeklyQuota(timesPerWeek: 3)!)
    let dates = [
        CalendarDate(year: 2026, month: 8, day: 31)!,
        CalendarDate(year: 2026, month: 9, day: 1)!,
        CalendarDate(year: 2026, month: 9, day: 2)!,
        CalendarDate(year: 2026, month: 9, day: 3)!,
        CalendarDate(year: 2026, month: 9, day: 4)!,
        CalendarDate(year: 2026, month: 9, day: 5)!,
        CalendarDate(year: 2026, month: 9, day: 6)!,
    ]

    for date in dates {
        #expect(schedule.isDue(on: date))
    }
}
