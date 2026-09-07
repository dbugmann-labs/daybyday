import Foundation
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

    #expect(schedule.isDue(on: monday))
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

    #expect(schedule.isDue(on: beforeFloor))
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

@Test("a tick taken back leaves the commitment not kept on that date")
func aTickTakenBackLeavesTheCommitmentNotKeptOnThatDate() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tick = Tick(commitment, on: monday)!

    var history = History()
    history.add(tick)
    history.remove(tick)

    #expect(!history.isKept(commitment, on: monday))
}

@Test("taking back a tick leaves the same commitment's ticks on other dates standing")
func takingBackATickLeavesTheSameCommitmentsTicksOnOtherDatesStanding() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let saturday = CalendarDate(year: 2026, month: 9, day: 5)!
    let onMonday = Tick(commitment, on: monday)!
    let onSaturday = Tick(commitment, on: saturday)!

    var history = History()
    history.add(onMonday)
    history.add(onSaturday)
    history.remove(onMonday)

    #expect(history.isKept(commitment, on: saturday))
    #expect(!history.isKept(commitment, on: monday))
}

@Test("taking back a tick leaves another commitment's tick on the same date standing")
func takingBackATickLeavesAnotherCommitmentsTickOnTheSameDateStanding() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gymTick = Tick(gym, on: monday)!
    let runTick = Tick(run, on: monday)!

    var history = History()
    history.add(gymTick)
    history.add(runTick)
    history.remove(gymTick)

    #expect(history.isKept(run, on: monday))
    #expect(!history.isKept(gym, on: monday))
}

@Test("taking back a tick the history does not hold leaves it unchanged")
func takingBackATickTheHistoryDoesNotHoldLeavesItUnchanged() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let saturday = CalendarDate(year: 2026, month: 9, day: 5)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let onSaturday = Tick(commitment, on: saturday)!
    let onMonday = Tick(commitment, on: monday)!

    var before = History()
    before.add(onSaturday)

    var after = before
    after.remove(onMonday)

    #expect(after == before)
    #expect(after.isKept(commitment, on: saturday))
}

@Test("a history ticked and then unticked is the same as one never ticked")
func aHistoryTickedAndThenUntickedIsTheSameAsOneNeverTicked() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tick = Tick(commitment, on: monday)!

    var tickedThenUnticked = History()
    tickedThenUnticked.add(tick)
    tickedThenUnticked.remove(tick)

    #expect(tickedThenUnticked == History())
}

@Test("a commitment whose kind is not a tick takes no tick on a date it is due on")
func aCommitmentWhoseKindIsNotATickTakesNoTickOnADateItIsDueOn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let target = Commitment.Target(120)!

    let numberNoRange = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!
    let numberWithRange = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let note = Commitment(name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let total = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .total(target: target))!
    let tickKind = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .tick)!

    #expect(Tick(numberNoRange, on: monday) == nil)
    #expect(Tick(numberWithRange, on: monday) == nil)
    #expect(Tick(note, on: monday) == nil)
    #expect(Tick(total, on: monday) == nil)
    #expect(Tick(tickKind, on: monday) != nil)
}

@Test("a commitment whose kind is not a tick was not kept on a date it is due on")
func aCommitmentWhoseKindIsNotATickWasNotKeptOnADateItIsDueOn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let number = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!
    let tickKind = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .tick)!

    let history = History()
    var withTickKindTick = History()
    withTickKindTick.add(Tick(tickKind, on: monday)!)

    #expect(!history.isKept(number, on: monday))
    #expect(!withTickKindTick.isKept(number, on: monday))
}

@Test("a number is recorded for a number commitment on a date it is due on")
func aNumberIsRecordedForANumberCommitmentOnADateItIsDueOn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let withRange = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let noRange = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!

    #expect(Number(70.5, for: withRange, on: monday) != nil)
    #expect(Number(70.5, for: noRange, on: monday) != nil)
}

@Test("a number commitment takes no number on a date it is not due on")
func aNumberCommitmentTakesNoNumberOnADateItIsNotDueOn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!

    let laterFloor = CalendarDate(year: 2026, month: 9, day: 2)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let beforeFloor = Commitment(
        name: "Weight", schedule: schedule, keptFrom: laterFloor, kind: .number(range: nil))!

    let noWeekday = Commitment(
        name: "Weight", schedule: Schedule.weekdays([]), keptFrom: keptFrom,
        kind: .number(range: nil))!
    let week = [
        CalendarDate(year: 2026, month: 8, day: 31)!,
        CalendarDate(year: 2026, month: 9, day: 1)!,
        CalendarDate(year: 2026, month: 9, day: 2)!,
        CalendarDate(year: 2026, month: 9, day: 3)!,
        CalendarDate(year: 2026, month: 9, day: 4)!,
        CalendarDate(year: 2026, month: 9, day: 5)!,
        CalendarDate(year: 2026, month: 9, day: 6)!,
    ]

    #expect(Number(70.5, for: commitment, on: tuesday) == nil)
    #expect(schedule.isDue(on: monday))
    #expect(Number(70.5, for: beforeFloor, on: monday) == nil)
    for date in week {
        #expect(Number(70.5, for: noWeekday, on: date) == nil)
    }
}

@Test("a commitment whose kind is not a number takes no number on a date it is due on")
func aCommitmentWhoseKindIsNotANumberTakesNoNumberOnADateItIsDueOn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let target = Commitment.Target(120)!

    let tickKind = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let note = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let total = Commitment(
        name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .total(target: target))!
    let numberKind = Commitment(
        name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!

    #expect(Number(70.5, for: tickKind, on: monday) == nil)
    #expect(Number(70.5, for: note, on: monday) == nil)
    #expect(Number(70.5, for: total, on: monday) == nil)
    #expect(Number(70.5, for: numberKind, on: monday) != nil)
}

@Test("a number outside the commitment's range is not recorded")
func aNumberOutsideTheCommitmentsRangeIsNotRecorded() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!

    #expect(Number(300, for: commitment, on: monday) == nil)
    #expect(Number(39.9, for: commitment, on: monday) == nil)
    #expect(Number(70.5, for: commitment, on: monday) != nil)
}

@Test("a number at either end of the commitment's range is recorded")
func aNumberAtEitherEndOfTheCommitmentsRangeIsRecorded() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let singleValueRange = Commitment.Range(lowest: 100, highest: 100)!
    let singleValueCommitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom,
        kind: .number(range: singleValueRange))!

    #expect(Number(40, for: commitment, on: monday) != nil)
    #expect(Number(150, for: commitment, on: monday) != nil)
    #expect(Number(100, for: singleValueCommitment, on: monday) != nil)
}

@Test("a number between two whole numbers is recorded on a range of whole numbers")
func aNumberBetweenTwoWholeNumbersIsRecordedOnARangeOfWholeNumbers() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let range = Commitment.Range(lowest: 1, highest: 10)!
    let commitment = Commitment(
        name: "Mood", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!

    let number = Number(5.5, for: commitment, on: monday)
    let five = Number(5, for: commitment, on: monday)
    let six = Number(6, for: commitment, on: monday)

    #expect(number != nil)
    #expect(number != five)
    #expect(number != six)
}

@Test("a number commitment with no range takes any number")
func aNumberCommitmentWithNoRangeTakesAnyNumber() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!
    let veryLarge = Decimal(string: "98765432109876543210.5")!
    let veryLargeRounded = Decimal(string: "98765432109876543211")!
    let values: [Decimal] = [-12.75, 0, 0.000001, veryLarge]

    for value in values {
        #expect(Number(value, for: commitment, on: monday) != nil)
    }

    #expect(Number(-12.75, for: commitment, on: monday) != Number(-13, for: commitment, on: monday))
    #expect(Number(0.000001, for: commitment, on: monday) != Number(0, for: commitment, on: monday))
    #expect(
        Number(veryLarge, for: commitment, on: monday)
            != Number(veryLargeRounded, for: commitment, on: monday))
}

@Test("a value that is not a number is not recorded")
func aValueThatIsNotANumberIsNotRecorded() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let noRange = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let withRange = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!

    #expect(Number(Decimal.nan, for: noRange, on: monday) == nil)
    #expect(Number(Decimal.nan, for: withRange, on: monday) == nil)
}

@Test("two numbers are the same exactly when their commitment, date and number all are")
func twoNumbersAreTheSameExactlyWhenTheirCommitmentDateAndNumberAllAre() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!
    let otherCommitment = Commitment(
        name: "Weight before breakfast", schedule: schedule, keptFrom: keptFrom,
        kind: .number(range: nil))!

    let first = Number(70.5, for: commitment, on: monday)!
    let second = Number(70.5, for: commitment, on: monday)!
    let differentNumber = Number(71, for: commitment, on: monday)!
    let differentDate = Number(70.5, for: commitment, on: wednesday)!
    let differentCommitment = Number(70.5, for: otherCommitment, on: monday)!

    #expect(first == second)
    #expect(first != differentNumber)
    #expect(second != differentNumber)
    #expect(first != differentDate)
    #expect(first != differentCommitment)
}
