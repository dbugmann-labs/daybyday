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

@Test("a schedule listing no weekday is due on none of seven consecutive dates")
func aScheduleListingNoWeekdayIsDueOnNoneOfSevenConsecutiveDates() {
    let schedule = Schedule.weekdays([])
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
        #expect(!schedule.isDue(on: date))
    }
}

@Test("a Sunday-only schedule is due on Sunday and not on Saturday")
func aSundayOnlyScheduleIsDueOnSundayAndNotOnSaturday() {
    let schedule = Schedule.weekdays([.sunday])
    let sunday = CalendarDate(year: 2026, month: 9, day: 6)!
    let saturday = CalendarDate(year: 2026, month: 9, day: 5)!

    #expect(schedule.isDue(on: sunday))
    #expect(!schedule.isDue(on: saturday))
}

@Test("a leap day is placed on its Gregorian weekday")
func aLeapDayIsPlacedOnItsGregorianWeekday() {
    let leapDay = CalendarDate(year: 2028, month: 2, day: 29)!
    let tuesdaySchedule = Schedule.weekdays([.tuesday])
    let mondaySchedule = Schedule.weekdays([.monday])

    #expect(tuesdaySchedule.isDue(on: leapDay))
    #expect(!mondaySchedule.isDue(on: leapDay))
}

@Test("the first day of a year is placed on its Gregorian weekday")
func theFirstDayOfAYearIsPlacedOnItsGregorianWeekday() {
    let schedule = Schedule.weekdays([.friday])
    let newYearsDay = CalendarDate(year: 2027, month: 1, day: 1)!
    let newYearsEve = CalendarDate(year: 2026, month: 12, day: 31)!

    #expect(schedule.isDue(on: newYearsDay))
    #expect(!schedule.isDue(on: newYearsEve))
}

@Test("a day beyond the end of its month is not a calendar date")
func aDayBeyondTheEndOfItsMonthIsNotACalendarDate() {
    let date = CalendarDate(year: 2026, month: 2, day: 30)

    #expect(date == nil)
    #expect(date != CalendarDate(year: 2026, month: 3, day: 2))
}

@Test("the twenty-ninth of February in a common year is not a calendar date")
func theTwentyNinthOfFebruaryInACommonYearIsNotACalendarDate() {
    let date = CalendarDate(year: 2027, month: 2, day: 29)

    #expect(date == nil)
}
