import Testing
import DayByDayKit

@Test("a schedule is due on its start date")
func aScheduleIsDueOnItsStartDate() {
    let start = CalendarDate(year: 2026, month: 8, day: 31)!
    let schedule = Schedule.everyNDays(DayInterval(days: 3)!, from: start)

    #expect(schedule.isDue(on: start))
}


@Test("a date one interval after the start date is due")
func aDateOneIntervalAfterTheStartDateIsDue() {
    let start = CalendarDate(year: 2026, month: 8, day: 31)!
    let schedule = Schedule.everyNDays(DayInterval(days: 3)!, from: start)
    let date = CalendarDate(year: 2026, month: 9, day: 3)!

    #expect(schedule.isDue(on: date))
}


@Test("a date between two due dates is not due")
func aDateBetweenTwoDueDatesIsNotDue() {
    let start = CalendarDate(year: 2026, month: 8, day: 31)!
    let schedule = Schedule.everyNDays(DayInterval(days: 3)!, from: start)
    let dayAfter = CalendarDate(year: 2026, month: 9, day: 1)!
    let twoDaysAfter = CalendarDate(year: 2026, month: 9, day: 2)!

    #expect(!schedule.isDue(on: dayAfter))
    #expect(!schedule.isDue(on: twoDaysAfter))
}


@Test("an every-N-days schedule is due on exactly five dates across a fortnight")
func anEveryNDaysScheduleIsDueOnExactlyFiveDatesAcrossAFortnight() {
    let start = CalendarDate(year: 2026, month: 8, day: 31)!
    let schedule = Schedule.everyNDays(DayInterval(days: 3)!, from: start)
    let dates = [
        CalendarDate(year: 2026, month: 8, day: 31)!,
        CalendarDate(year: 2026, month: 9, day: 1)!,
        CalendarDate(year: 2026, month: 9, day: 2)!,
        CalendarDate(year: 2026, month: 9, day: 3)!,
        CalendarDate(year: 2026, month: 9, day: 4)!,
        CalendarDate(year: 2026, month: 9, day: 5)!,
        CalendarDate(year: 2026, month: 9, day: 6)!,
        CalendarDate(year: 2026, month: 9, day: 7)!,
        CalendarDate(year: 2026, month: 9, day: 8)!,
        CalendarDate(year: 2026, month: 9, day: 9)!,
        CalendarDate(year: 2026, month: 9, day: 10)!,
        CalendarDate(year: 2026, month: 9, day: 11)!,
        CalendarDate(year: 2026, month: 9, day: 12)!,
        CalendarDate(year: 2026, month: 9, day: 13)!,
    ]

    let dueDates = dates.filter { schedule.isDue(on: $0) }

    #expect(dueDates == [
        CalendarDate(year: 2026, month: 8, day: 31)!,
        CalendarDate(year: 2026, month: 9, day: 3)!,
        CalendarDate(year: 2026, month: 9, day: 6)!,
        CalendarDate(year: 2026, month: 9, day: 9)!,
        CalendarDate(year: 2026, month: 9, day: 12)!,
    ])
}


@Test("the interval counts across the end of a month")
func theIntervalCountsAcrossTheEndOfAMonth() {
    let start = CalendarDate(year: 2026, month: 8, day: 25)!
    let schedule = Schedule.everyNDays(DayInterval(days: 14)!, from: start)
    let dueDate = CalendarDate(year: 2026, month: 9, day: 8)!
    let notDueDate = CalendarDate(year: 2026, month: 9, day: 25)!

    #expect(schedule.isDue(on: dueDate))
    #expect(!schedule.isDue(on: notDueDate))
}


@Test("the interval counts a leap day as a day")
func theIntervalCountsALeapDayAsADay() {
    let start = CalendarDate(year: 2028, month: 2, day: 26)!
    let schedule = Schedule.everyNDays(DayInterval(days: 3)!, from: start)
    let leapDay = CalendarDate(year: 2028, month: 2, day: 29)!
    let dayAfter = CalendarDate(year: 2028, month: 3, day: 1)!

    #expect(schedule.isDue(on: leapDay))
    #expect(!schedule.isDue(on: dayAfter))
}


@Test("the interval counts across the turn of a year")
func theIntervalCountsAcrossTheTurnOfAYear() {
    let start = CalendarDate(year: 2026, month: 12, day: 28)!
    let schedule = Schedule.everyNDays(DayInterval(days: 7)!, from: start)
    let dueDate = CalendarDate(year: 2027, month: 1, day: 4)!
    let notDueDate = CalendarDate(year: 2027, month: 1, day: 1)!

    #expect(schedule.isDue(on: dueDate))
    #expect(!schedule.isDue(on: notDueDate))
}


@Test("an interval of one day is due on every date")
func anIntervalOfOneDayIsDueOnEveryDate() {
    let start = CalendarDate(year: 2026, month: 8, day: 31)!
    let schedule = Schedule.everyNDays(DayInterval(days: 1)!, from: start)
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
