import Testing
import DayByDayKit

@Test("a date on the scheduled day of the month is due")
func aDateOnTheScheduledDayOfTheMonthIsDue() {
    let schedule = Schedule.dayOfMonth(DayOfMonth(day: 25)!)
    let date = CalendarDate(year: 2026, month: 9, day: 25)!

    #expect(schedule.isDue(on: date))
}
