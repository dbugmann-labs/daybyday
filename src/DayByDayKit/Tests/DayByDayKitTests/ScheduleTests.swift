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

@Test("a schedule listing every weekday is due on seven consecutive dates")
func aScheduleListingEveryWeekdayIsDueOnSevenConsecutiveDates() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
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
