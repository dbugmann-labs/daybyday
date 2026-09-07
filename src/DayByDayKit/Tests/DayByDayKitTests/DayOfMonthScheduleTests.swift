import Testing
import DayByDayKit

@Test("a day-of-month schedule says its day as an ordinal")
func aDayOfMonthScheduleSaysItsDayAsAnOrdinal() {
    let schedule = Schedule.dayOfMonth(DayOfMonth(day: 25)!)

    #expect(schedule.inWords == "The 25th")
}

@Test("the eleventh, twelfth and thirteenth are said with th and not with st, nd and rd")
func theEleventhTwelfthAndThirteenthAreSaidWithThAndNotWithStNdAndRd() {
    let eleventh = Schedule.dayOfMonth(DayOfMonth(day: 11)!)
    let twelfth = Schedule.dayOfMonth(DayOfMonth(day: 12)!)
    let thirteenth = Schedule.dayOfMonth(DayOfMonth(day: 13)!)
    let twentyFirst = Schedule.dayOfMonth(DayOfMonth(day: 21)!)
    let twentySecond = Schedule.dayOfMonth(DayOfMonth(day: 22)!)
    let twentyThird = Schedule.dayOfMonth(DayOfMonth(day: 23)!)

    #expect(eleventh.inWords == "The 11th")
    #expect(twelfth.inWords == "The 12th")
    #expect(thirteenth.inWords == "The 13th")
    #expect(twentyFirst.inWords == "The 21st")
    #expect(twentySecond.inWords == "The 22nd")
    #expect(twentyThird.inWords == "The 23rd")
}

@Test("every day of the month from the first to the thirty-first is said as its own ordinal")
func everyDayOfTheMonthFromTheFirstToTheThirtyFirstIsSaidAsItsOwnOrdinal() {
    let schedules = (1...31).map { Schedule.dayOfMonth(DayOfMonth(day: $0)!) }

    #expect(schedules.map(\.inWords) == [
        "The 1st", "The 2nd", "The 3rd", "The 4th", "The 5th", "The 6th", "The 7th",
        "The 8th", "The 9th", "The 10th", "The 11th", "The 12th", "The 13th", "The 14th",
        "The 15th", "The 16th", "The 17th", "The 18th", "The 19th", "The 20th", "The 21st",
        "The 22nd", "The 23rd", "The 24th", "The 25th", "The 26th", "The 27th", "The 28th",
        "The 29th", "The 30th", "The 31st",
    ])
}

@Test("a day-of-month schedule does not say the clamp onto a short month")
func aDayOfMonthScheduleDoesNotSayTheClampOntoAShortMonth() {
    let schedule = Schedule.dayOfMonth(DayOfMonth(day: 31)!)

    #expect(schedule.inWords == "The 31st")
}

@Test("a date on the scheduled day of the month is due")
func aDateOnTheScheduledDayOfTheMonthIsDue() {
    let schedule = Schedule.dayOfMonth(DayOfMonth(day: 25)!)
    let date = CalendarDate(year: 2026, month: 9, day: 25)!

    #expect(schedule.isDue(on: date))
}

@Test("a date on another day of the same month is not due")
func aDateOnAnotherDayOfTheSameMonthIsNotDue() {
    let schedule = Schedule.dayOfMonth(DayOfMonth(day: 25)!)
    let dayBefore = CalendarDate(year: 2026, month: 9, day: 24)!
    let dayAfter = CalendarDate(year: 2026, month: 9, day: 26)!

    #expect(!schedule.isDue(on: dayBefore))
    #expect(!schedule.isDue(on: dayAfter))
}

@Test("a day-of-month schedule is due on exactly one date across a whole month")
func aDayOfMonthScheduleIsDueOnExactlyOneDateAcrossAWholeMonth() {
    let schedule = Schedule.dayOfMonth(DayOfMonth(day: 25)!)
    let dates = (1...30).map { CalendarDate(year: 2026, month: 9, day: $0)! }

    let dueDates = dates.filter { schedule.isDue(on: $0) }

    #expect(dueDates == [CalendarDate(year: 2026, month: 9, day: 25)!])
}

@Test("a schedule on the first is due on the first of a month and not on the last day of the month before")
func aScheduleOnTheFirstIsDueOnTheFirstOfAMonthAndNotOnTheLastDayOfTheMonthBefore() {
    let schedule = Schedule.dayOfMonth(DayOfMonth(day: 1)!)
    let firstOfSeptember = CalendarDate(year: 2026, month: 9, day: 1)!
    let lastOfAugust = CalendarDate(year: 2026, month: 8, day: 31)!

    #expect(schedule.isDue(on: firstOfSeptember))
    #expect(!schedule.isDue(on: lastOfAugust))
}

@Test("a schedule on the thirty-first is due on the last day of a thirty-day month")
func aScheduleOnTheThirtyFirstIsDueOnTheLastDayOfAThirtyDayMonth() {
    let schedule = Schedule.dayOfMonth(DayOfMonth(day: 31)!)
    let lastOfSeptember = CalendarDate(year: 2026, month: 9, day: 30)!
    let dayBefore = CalendarDate(year: 2026, month: 9, day: 29)!

    #expect(schedule.isDue(on: lastOfSeptember))
    #expect(!schedule.isDue(on: dayBefore))
}

@Test("a schedule on the thirty-first is due on the last day of a common February")
func aScheduleOnTheThirtyFirstIsDueOnTheLastDayOfACommonFebruary() {
    let schedule = Schedule.dayOfMonth(DayOfMonth(day: 31)!)
    let lastOfFebruary = CalendarDate(year: 2027, month: 2, day: 28)!
    let firstOfMarch = CalendarDate(year: 2027, month: 3, day: 1)!

    #expect(schedule.isDue(on: lastOfFebruary))
    #expect(!schedule.isDue(on: firstOfMarch))
}

@Test("a schedule on the thirty-first is due on the leap day of a leap February")
func aScheduleOnTheThirtyFirstIsDueOnTheLeapDayOfALeapFebruary() {
    let schedule = Schedule.dayOfMonth(DayOfMonth(day: 31)!)
    let leapDay = CalendarDate(year: 2028, month: 2, day: 29)!
    let dayBefore = CalendarDate(year: 2028, month: 2, day: 28)!

    #expect(schedule.isDue(on: leapDay))
    #expect(!schedule.isDue(on: dayBefore))
}

@Test("a schedule on the twenty-ninth is due on the last day of a common February")
func aScheduleOnTheTwentyNinthIsDueOnTheLastDayOfACommonFebruary() {
    let schedule = Schedule.dayOfMonth(DayOfMonth(day: 29)!)
    let lastOfFebruary = CalendarDate(year: 2027, month: 2, day: 28)!

    #expect(schedule.isDue(on: lastOfFebruary))
}

@Test("a schedule on the thirty-first is not moved in a month that has a thirty-first")
func aScheduleOnTheThirtyFirstIsNotMovedInAMonthThatHasAThirtyFirst() {
    let schedule = Schedule.dayOfMonth(DayOfMonth(day: 31)!)
    let thirtyFirstOfAugust = CalendarDate(year: 2026, month: 8, day: 31)!
    let thirtiethOfAugust = CalendarDate(year: 2026, month: 8, day: 30)!

    #expect(schedule.isDue(on: thirtyFirstOfAugust))
    #expect(!schedule.isDue(on: thirtiethOfAugust))
}

@Test("a day of the month past the thirty-first is not a day of the month")
func aDayOfTheMonthPastTheThirtyFirstIsNotADayOfTheMonth() {
    let dayOfMonth = DayOfMonth(day: 32)

    #expect(dayOfMonth == nil)
}

@Test("a day of the month below the first is not a day of the month")
func aDayOfTheMonthBelowTheFirstIsNotADayOfTheMonth() {
    let zero = DayOfMonth(day: 0)
    let negativeOne = DayOfMonth(day: -1)

    #expect(zero == nil)
    #expect(negativeOne == nil)
}

@Test("the thirty-first is a day of the month")
func theThirtyFirstIsADayOfTheMonth() {
    let schedule = Schedule.dayOfMonth(DayOfMonth(day: 31)!)
    let thirtyFirstOfAugust = CalendarDate(year: 2026, month: 8, day: 31)!
    let firstOfAugust = CalendarDate(year: 2026, month: 8, day: 1)!

    #expect(schedule.isDue(on: thirtyFirstOfAugust))
    #expect(!schedule.isDue(on: firstOfAugust))
}
