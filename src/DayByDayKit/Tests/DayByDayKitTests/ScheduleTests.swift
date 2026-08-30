import Testing
import DayByDayKit

@Test("a date on a listed weekday is due")
func aDateOnAListedWeekdayIsDue() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let date = CalendarDate(year: 2026, month: 8, day: 31)!

    #expect(schedule.isDue(on: date))
}
