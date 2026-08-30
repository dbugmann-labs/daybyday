import Testing
import DayByDayKit

@Test("a date on a listed weekday is due")
func aDateOnAListedWeekdayIsDue() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let date = CalendarDate(year: 2026, month: 8, day: 31)!

    #expect(schedule.isDue(on: date))
}

@Test("a date on an unlisted weekday is not due")
func aDateOnAnUnlistedWeekdayIsNotDue() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let date = CalendarDate(year: 2026, month: 9, day: 1)!

    #expect(!schedule.isDue(on: date))
}
