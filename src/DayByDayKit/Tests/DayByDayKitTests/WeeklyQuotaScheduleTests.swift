import Testing
import DayByDayKit

@Test("a weekly quota is due on every date of a week")
func aWeeklyQuotaIsDueOnEveryDateOfAWeek() {
    let schedule = Schedule.weeklyQuota(WeeklyQuota(timesPerWeek: 3)!)
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

@Test("a weekly quota is due on the dates either side of a week boundary")
func aWeeklyQuotaIsDueOnTheDatesEitherSideOfAWeekBoundary() {
    let schedule = Schedule.weeklyQuota(WeeklyQuota(timesPerWeek: 3)!)
    let sunday = CalendarDate(year: 2026, month: 9, day: 6)!
    let monday = CalendarDate(year: 2026, month: 9, day: 7)!

    #expect(schedule.isDue(on: sunday))
    #expect(schedule.isDue(on: monday))
}

@Test("a weekly quota is due on a leap day")
func aWeeklyQuotaIsDueOnALeapDay() {
    let schedule = Schedule.weeklyQuota(WeeklyQuota(timesPerWeek: 3)!)
    let leapDay = CalendarDate(year: 2028, month: 2, day: 29)!

    #expect(schedule.isDue(on: leapDay))
}

@Test("a weekly quota is due across the turn of a year")
func aWeeklyQuotaIsDueAcrossTheTurnOfAYear() {
    let schedule = Schedule.weeklyQuota(WeeklyQuota(timesPerWeek: 3)!)
    let newYearsEve = CalendarDate(year: 2026, month: 12, day: 31)!
    let newYearsDay = CalendarDate(year: 2027, month: 1, day: 1)!

    #expect(schedule.isDue(on: newYearsEve))
    #expect(schedule.isDue(on: newYearsDay))
}

@Test("a weekly quota is due on the first and last dates the system forms")
func aWeeklyQuotaIsDueOnTheFirstAndLastDatesTheSystemForms() {
    let schedule = Schedule.weeklyQuota(WeeklyQuota(timesPerWeek: 3)!)
    let firstDate = CalendarDate(year: 1583, month: 1, day: 1)!
    let lastDate = CalendarDate(year: 9999, month: 12, day: 31)!

    #expect(schedule.isDue(on: firstDate))
    #expect(schedule.isDue(on: lastDate))
}

@Test("a weekly quota of one is due on every date of a week")
func aWeeklyQuotaOfOneIsDueOnEveryDateOfAWeek() {
    let schedule = Schedule.weeklyQuota(WeeklyQuota(timesPerWeek: 1)!)
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

@Test("a quota below one time a week is not a weekly quota")
func aQuotaBelowOneTimeAWeekIsNotAWeeklyQuota() {
    let zero = WeeklyQuota(timesPerWeek: 0)
    let negativeOne = WeeklyQuota(timesPerWeek: -1)

    #expect(zero == nil)
    #expect(negativeOne == nil)
}

@Test("a quota of more times a week than the week has days is not a weekly quota")
func aQuotaOfMoreTimesAWeekThanTheWeekHasDaysIsNotAWeeklyQuota() {
    let eight = WeeklyQuota(timesPerWeek: 8)

    #expect(eight == nil)
}

@Test("one time a week is a weekly quota")
func oneTimeAWeekIsAWeeklyQuota() {
    let quota = WeeklyQuota(timesPerWeek: 1)

    #expect(quota != nil)
    #expect(quota != WeeklyQuota(timesPerWeek: 7))
}

@Test("seven times a week is a weekly quota")
func sevenTimesAWeekIsAWeeklyQuota() {
    let quota = WeeklyQuota(timesPerWeek: 7)

    #expect(quota != nil)
    #expect(quota != WeeklyQuota(timesPerWeek: 1))
}
