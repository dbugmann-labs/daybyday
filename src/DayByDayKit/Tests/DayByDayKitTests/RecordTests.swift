import Testing
import DayByDayKit

@Test("a tick is formed for a commitment on a date it is due on")
func aTickIsFormedForACommitmentOnADateItIsDueOn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let tick = Tick(commitment, on: monday)

    #expect(tick != nil)
}

@Test("a commitment takes no tick on a date it is not due on")
func aCommitmentTakesNoTickOnADateItIsNotDueOn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let tick = Tick(commitment, on: tuesday)

    #expect(tick == nil)
}

@Test("a commitment takes no tick on a date before the day it is kept from")
func aCommitmentTakesNoTickOnADateBeforeTheDayItIsKeptFrom() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 9, day: 2)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let beforeFloor = Tick(commitment, on: monday)
    let onFloor = Tick(commitment, on: keptFrom)

    #expect(beforeFloor == nil)
    #expect(onFloor != nil)
}

@Test("a commitment on a schedule due on no date takes no tick on any date")
func aCommitmentOnAScheduleDueOnNoDateTakesNoTickOnAnyDate() {
    let schedule = Schedule.weekdays([])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

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
        #expect(Tick(commitment, on: date) == nil)
    }
}

@Test("a tick is formed on the last day of a month too short for the scheduled day")
func aTickIsFormedOnTheLastDayOfAMonthTooShortForTheScheduledDay() {
    let schedule = Schedule.dayOfMonth(DayOfMonth(day: 31)!)
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Finances", schedule: schedule, keptFrom: keptFrom)!
    let lastDayOfFebruary = CalendarDate(year: 2027, month: 2, day: 28)!
    let firstOfMarch = CalendarDate(year: 2027, month: 3, day: 1)!

    #expect(Tick(commitment, on: lastDayOfFebruary) != nil)
    #expect(Tick(commitment, on: firstOfMarch) == nil)
}

@Test("an interval landing before the day it is kept from takes no tick and the first landing after it does")
func anIntervalLandingBeforeTheDayItIsKeptFromTakesNoTickAndTheFirstLandingAfterItDoes() {
    let start = CalendarDate(year: 2026, month: 8, day: 25)!
    let schedule = Schedule.everyNDays(DayInterval(days: 3)!, from: start)
    let keptFrom = CalendarDate(year: 2026, month: 9, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let beforeFloor = CalendarDate(year: 2026, month: 8, day: 28)!
    let afterFloor = CalendarDate(year: 2026, month: 9, day: 3)!

    #expect(Tick(commitment, on: beforeFloor) == nil)
    #expect(Tick(commitment, on: afterFloor) != nil)
}

@Test("a tick is formed on a due date in the first supported year and in the last")
func aTickIsFormedOnADueDateInTheFirstSupportedYearAndInTheLast() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 1583, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let firstYear = CalendarDate(year: 1583, month: 1, day: 3)!
    let lastYear = CalendarDate(year: 9999, month: 12, day: 27)!

    #expect(Tick(commitment, on: firstYear) != nil)
    #expect(Tick(commitment, on: lastYear) != nil)
}

@Test("two ticks alike in commitment and date are the same tick")
func twoTicksAlikeInCommitmentAndDateAreTheSameTick() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let first = Tick(commitment, on: monday)!
    let second = Tick(commitment, on: monday)!

    #expect(first == second)
}

@Test("two ticks of the same commitment on different dates are different ticks")
func twoTicksOfTheSameCommitmentOnDifferentDatesAreDifferentTicks() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!

    let onMonday = Tick(commitment, on: monday)!
    let onWednesday = Tick(commitment, on: wednesday)!

    #expect(onMonday != onWednesday)
}

@Test("two ticks of different commitments on the same date are different ticks")
func twoTicksOfDifferentCommitmentsOnTheSameDateAreDifferentTicks() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let gymTick = Tick(gym, on: monday)!
    let runTick = Tick(run, on: monday)!

    #expect(gymTick != runTick)
}

@Test("an empty history has kept nothing")
func anEmptyHistoryHasKeptNothing() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let history = History()

    #expect(!history.isKept(commitment, on: monday))
}

@Test("a commitment ticked on a date was kept on that date")
func aCommitmentTickedOnADateWasKeptOnThatDate() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tick = Tick(commitment, on: monday)!

    var history = History()
    history.add(tick)

    #expect(history.isKept(commitment, on: monday))
}

@Test("a commitment ticked on one date was not kept on another date it is due on")
func aCommitmentTickedOnOneDateWasNotKeptOnAnotherDateItIsDueOn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let tick = Tick(commitment, on: monday)!

    var history = History()
    history.add(tick)

    #expect(!history.isKept(commitment, on: wednesday))
}

@Test("a tick of one commitment does not keep another on the same date")
func aTickOfOneCommitmentDoesNotKeepAnotherOnTheSameDate() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tick = Tick(gym, on: monday)!

    var history = History()
    history.add(tick)

    #expect(!history.isKept(run, on: monday))
    #expect(history.isKept(gym, on: monday))
}

@Test("a commitment was not kept on a date it is not due on")
func aCommitmentWasNotKeptOnADateItIsNotDueOn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!
    let tick = Tick(commitment, on: monday)!

    var history = History()
    history.add(tick)

    #expect(!history.isKept(commitment, on: tuesday))
}

@Test("a history answers each date on its own across a week")
func aHistoryAnswersEachDateOnItsOwnAcrossAWeek() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let saturday = CalendarDate(year: 2026, month: 9, day: 5)!

    var history = History()
    history.add(Tick(commitment, on: monday)!)
    history.add(Tick(commitment, on: saturday)!)

    let week = [
        CalendarDate(year: 2026, month: 8, day: 31)!,
        CalendarDate(year: 2026, month: 9, day: 1)!,
        CalendarDate(year: 2026, month: 9, day: 2)!,
        CalendarDate(year: 2026, month: 9, day: 3)!,
        CalendarDate(year: 2026, month: 9, day: 4)!,
        CalendarDate(year: 2026, month: 9, day: 5)!,
        CalendarDate(year: 2026, month: 9, day: 6)!,
    ]

    let keptDates = week.filter { history.isKept(commitment, on: $0) }

    #expect(keptDates == [monday, saturday])
}

@Test("adding a tick the history already holds leaves it unchanged")
func addingATickTheHistoryAlreadyHoldsLeavesItUnchanged() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tick = Tick(commitment, on: monday)!

    var addedOnce = History()
    addedOnce.add(tick)

    var addedTwice = History()
    addedTwice.add(tick)
    addedTwice.add(tick)

    #expect(addedTwice == addedOnce)
}

@Test("two histories holding the same ticks are the same history")
func twoHistoriesHoldingTheSameTicksAreTheSameHistory() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let onMonday = Tick(commitment, on: monday)!
    let onWednesday = Tick(commitment, on: wednesday)!

    var first = History()
    first.add(onMonday)
    first.add(onWednesday)

    var second = History()
    second.add(onWednesday)
    second.add(onMonday)

    #expect(first == second)
}
