import Testing
import DayByDayKit

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
