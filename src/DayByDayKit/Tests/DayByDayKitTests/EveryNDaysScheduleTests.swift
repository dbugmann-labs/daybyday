import Testing
import DayByDayKit

@Test("a schedule is due on its start date")
func aScheduleIsDueOnItsStartDate() {
    let start = CalendarDate(year: 2026, month: 8, day: 31)!
    let schedule = Schedule.everyNDays(DayInterval(days: 3)!, from: start)

    #expect(schedule.isDue(on: start))
}
