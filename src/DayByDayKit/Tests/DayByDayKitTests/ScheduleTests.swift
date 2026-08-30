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

@Test("the twenty-ninth of February in a leap year is a calendar date")
func theTwentyNinthOfFebruaryInALeapYearIsACalendarDate() {
    let date = CalendarDate(year: 2028, month: 2, day: 29)

    #expect(date != nil)
}

@Test("a month outside the twelve is not a calendar date")
func aMonthOutsideTheTwelveIsNotACalendarDate() {
    let date = CalendarDate(year: 2026, month: 13, day: 1)

    #expect(date == nil)
    #expect(date != CalendarDate(year: 2027, month: 1, day: 1))
}

// The following are hardening tests, not acceptance tests: they pin a defect fix rather than
// a delta scenario, so they are named descriptively instead of after a `#### Scenario:` title.

@Test("a month of Int.max is refused rather than read back as unset")
func aMonthOfIntMaxIsRefusedRatherThanReadBackAsUnset() {
    // `DateComponents.month` reads back `nil` for exactly `Int.max`, which would otherwise
    // let this under-specified date round-trip through `isValidDate(in:)`.
    let date = CalendarDate(year: 2026, month: Int.max, day: 1)

    #expect(date == nil)
}

@Test("a year of Int.max is refused rather than read back as unset")
func aYearOfIntMaxIsRefusedRatherThanReadBackAsUnset() {
    let date = CalendarDate(year: Int.max, month: 1, day: 1)

    #expect(date == nil)
}

@Test("a day of Int.max is refused rather than read back as unset")
func aDayOfIntMaxIsRefusedRatherThanReadBackAsUnset() {
    let date = CalendarDate(year: 2026, month: 1, day: Int.max)

    #expect(date == nil)
}

@Test("a date before the Gregorian calendar's adoption is not a calendar date")
func aDateBeforeTheGregorianCalendarsAdoptionIsNotACalendarDate() {
    // `Calendar(identifier: .gregorian)` is a hybrid that still applies the Julian calendar
    // before 1582-10-15, so an earlier date would otherwise form with the wrong weekday.
    let date = CalendarDate(year: 1500, month: 1, day: 1)

    #expect(date == nil)
}

@Test("the first day of the first full Gregorian year is a calendar date")
func theFirstDayOfTheFirstFullGregorianYearIsACalendarDate() {
    let date = CalendarDate(year: 1583, month: 1, day: 1)

    #expect(date != nil)
}

@Test("a year past the upper bound is not a calendar date")
func aYearPastTheUpperBoundIsNotACalendarDate() {
    let date = CalendarDate(year: 10000, month: 1, day: 1)

    #expect(date == nil)
}
