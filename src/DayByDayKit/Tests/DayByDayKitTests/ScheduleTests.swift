import Testing
import DayByDayKit

@Test("a weekday-set schedule says its weekdays as three-letter names")
func aWeekdaySetScheduleSaysItsWeekdaysAsThreeLetterNames() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])

    #expect(schedule.inWords == "Mon, Wed, Sat")
}

@Test("a weekday-set schedule says its weekdays in week order from Monday")
func aWeekdaySetScheduleSaysItsWeekdaysInWeekOrderFromMonday() {
    let firstSchedule = Schedule.weekdays([.saturday, .monday, .wednesday])
    let secondSchedule = Schedule.weekdays([.sunday, .monday])

    #expect(firstSchedule.inWords == "Mon, Wed, Sat")
    #expect(secondSchedule.inWords == "Mon, Sun")
}

@Test("every weekday is said by its own three-letter name")
func everyWeekdayIsSaidByItsOwnThreeLetterName() {
    let schedules: [Schedule] = [
        .weekdays([.monday]),
        .weekdays([.tuesday]),
        .weekdays([.wednesday]),
        .weekdays([.thursday]),
        .weekdays([.friday]),
        .weekdays([.saturday]),
        .weekdays([.sunday]),
    ]

    #expect(schedules.map(\.inWords) == [
        "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun",
    ])
}

@Test("a weekday set listing every weekday is said as every day")
func aWeekdaySetListingEveryWeekdayIsSaidAsEveryDay() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    #expect(schedule.inWords == "Every day")
}

@Test("a weekday set listing no weekday is said as no day")
func aWeekdaySetListingNoWeekdayIsSaidAsNoDay() {
    let schedule = Schedule.weekdays([])

    #expect(schedule.inWords == "No day")
}

@Test("each of the four schedule shapes says the rhythm it runs on in words")
func eachOfTheFourScheduleShapesSaysTheRhythmItRunsOnInWords() {
    let start = CalendarDate(year: 2026, month: 8, day: 31)!
    let weekdaySchedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let dayOfMonthSchedule = Schedule.dayOfMonth(DayOfMonth(day: 25)!)
    let intervalSchedule = Schedule.everyNDays(DayInterval(days: 14)!, from: start)
    let quotaSchedule = Schedule.weeklyQuota(WeeklyQuota(timesPerWeek: 3)!)

    #expect(weekdaySchedule.inWords == "Mon, Wed, Sat")
    #expect(dayOfMonthSchedule.inWords == "The 25th")
    #expect(intervalSchedule.inWords == "Every 14 days")
    #expect(quotaSchedule.inWords == "3x a week")
}

@Test("two schedules that name the same rhythm say the same words")
func twoSchedulesThatNameTheSameRhythmSayTheSameWords() {
    let start = CalendarDate(year: 2026, month: 8, day: 31)!
    let weekdaySchedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let intervalSchedule = Schedule.everyNDays(DayInterval(days: 1)!, from: start)

    #expect(weekdaySchedule.inWords == "Every day")
    #expect(intervalSchedule.inWords == "Every day")
}

@Test("a number is said in digits with no grouping separator")
func aNumberIsSaidInDigitsWithNoGroupingSeparator() {
    let start = CalendarDate(year: 2026, month: 8, day: 31)!
    let schedule = Schedule.everyNDays(DayInterval(days: 1000)!, from: start)

    #expect(schedule.inWords == "Every 1000 days")
}

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

@Test("a month of the largest representable integer is not a calendar date")
func aMonthOfIntMaxIsRefusedRatherThanReadBackAsUnset() {
    // `DateComponents.month` reads back `nil` for exactly `Int.max`, which would otherwise
    // let this under-specified date round-trip through `isValidDate(in:)`.
    let date = CalendarDate(year: 2026, month: Int.max, day: 1)

    #expect(date == nil)
}

@Test("a year of the largest representable integer is not a calendar date")
func aYearOfIntMaxIsRefusedRatherThanReadBackAsUnset() {
    let date = CalendarDate(year: Int.max, month: 1, day: 1)

    #expect(date == nil)
}

@Test("a day of the largest representable integer is not a calendar date")
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

@Test("the last day before the first full Gregorian year is not a calendar date")
func theLastDayBeforeTheFirstFullGregorianYearIsNotACalendarDate() {
    // The guard is year-granular, so the whole of 1582 is refused, including after the
    // 15 October reform. Without this, the pinned pair either side of the lower bound is
    // 1500 refused and 1583 accepted, and a guard mistyped as `1581...` would satisfy both.
    let date = CalendarDate(year: 1582, month: 12, day: 31)

    #expect(date == nil)
}

@Test("the last day of the last supported year is a calendar date")
func theLastDayOfTheLastSupportedYearIsACalendarDate() {
    let date = CalendarDate(year: 9999, month: 12, day: 31)

    #expect(date != nil)
}

@Test("the first day of the first full Gregorian year is a calendar date")
func theFirstDayOfTheFirstFullGregorianYearIsACalendarDate() {
    let date = CalendarDate(year: 1583, month: 1, day: 1)

    #expect(date != nil)
}

@Test("a year past the last supported year is not a calendar date")
func aYearPastTheUpperBoundIsNotACalendarDate() {
    let date = CalendarDate(year: 10000, month: 1, day: 1)

    #expect(date == nil)
}

@Test("a calendar date gives back the three numbers it was formed from")
func aCalendarDateGivesBackTheThreeNumbersItWasFormedFrom() {
    let date = CalendarDate(year: 2026, month: 8, day: 31)!

    #expect(date.year == 2026)
    #expect(date.month == 8)
    #expect(date.day == 31)
}

@Test("a calendar date gives back its month and its day the way round they were offered")
func aCalendarDateGivesBackItsMonthAndItsDayTheWayRoundTheyWereOffered() {
    let firstOfDecember = CalendarDate(year: 2026, month: 12, day: 1)!
    let twelfthOfJanuary = CalendarDate(year: 2026, month: 1, day: 12)!

    #expect(firstOfDecember.month == 12)
    #expect(firstOfDecember.day == 1)
    #expect(twelfthOfJanuary.month == 1)
    #expect(twelfthOfJanuary.day == 12)
}

@Test("a calendar date at each end of the supported years gives back that year")
func aCalendarDateAtEachEndOfTheSupportedYearsGivesBackThatYear() {
    let firstSupportedDay = CalendarDate(year: 1583, month: 1, day: 1)!
    let lastSupportedDay = CalendarDate(year: 9999, month: 12, day: 31)!

    #expect(firstSupportedDay.year == 1583)
    #expect(firstSupportedDay.month == 1)
    #expect(firstSupportedDay.day == 1)
    #expect(lastSupportedDay.year == 9999)
    #expect(lastSupportedDay.month == 12)
    #expect(lastSupportedDay.day == 31)
}

@Test("a calendar date formed again from what it gives back is the same date")
func aCalendarDateFormedAgainFromWhatItGivesBackIsTheSameDate() {
    let leapDay = CalendarDate(year: 2028, month: 2, day: 29)!

    let roundTripped = CalendarDate(year: leapDay.year, month: leapDay.month, day: leapDay.day)

    #expect(roundTripped != nil)
    #expect(roundTripped == leapDay)
}
