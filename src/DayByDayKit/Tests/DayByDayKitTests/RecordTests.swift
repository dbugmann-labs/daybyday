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

@Test("a history that has taken no number has no number for a commitment on a day")
func aHistoryThatHasTakenNoNumberHasNoNumberForACommitmentOnADay() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!

    let history = History()

    #expect(history.number(for: commitment, on: monday) == nil)
}

@Test("a number added to a history is the number that commitment has on that day")
func aNumberAddedToAHistoryIsTheNumberThatCommitmentHasOnThatDay() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let number = Number(70.5, for: commitment, on: monday)!

    var history = History()
    history.add(number)

    #expect(history.number(for: commitment, on: monday) == 70.5)
}

@Test("a number of one commitment is not the number of another on the same date")
func aNumberOfOneCommitmentIsNotTheNumberOfAnotherOnTheSameDate() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!
    let mood = Commitment(
        name: "Mood", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!

    var history = History()
    history.add(Number(70.5, for: weight, on: monday)!)
    history.add(Number(8, for: mood, on: monday)!)

    #expect(history.number(for: weight, on: monday) == 70.5)
    #expect(history.number(for: mood, on: monday) == 8)
}

@Test("a number entered again on the same day replaces the one before it")
func aNumberEnteredAgainOnTheSameDayReplacesTheOneBeforeIt() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!

    var enteredTwice = History()
    enteredTwice.add(Number(70.5, for: commitment, on: monday)!)
    enteredTwice.add(Number(71.2, for: commitment, on: monday)!)

    var enteredOnceAtTheLaterValue = History()
    enteredOnceAtTheLaterValue.add(Number(71.2, for: commitment, on: monday)!)

    #expect(enteredTwice.number(for: commitment, on: monday) == 71.2)
    #expect(enteredTwice == enteredOnceAtTheLaterValue)
}

@Test("a history has no number for a commitment whose kind is not a number")
func aHistoryHasNoNumberForACommitmentWhoseKindIsNotANumber() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!
    let target = Commitment.Target(120)!

    let tickKind = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let note = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let total = Commitment(
        name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .total(target: target))!
    let numberKind = Commitment(
        name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!

    var history = History()
    history.add(Tick(tickKind, on: monday)!)

    #expect(history.number(for: tickKind, on: monday) == nil)
    #expect(history.number(for: note, on: monday) == nil)
    #expect(history.number(for: total, on: monday) == nil)
    #expect(history.number(for: numberKind, on: tuesday) == nil)
}

@Test("a number the commitment refuses leaves the number already on that day standing")
func aNumberTheCommitmentRefusesLeavesTheNumberAlreadyOnThatDayStanding() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!

    var history = History()
    history.add(Number(70.5, for: commitment, on: monday)!)
    let before = history

    let refused = Number(300, for: commitment, on: monday)

    #expect(refused == nil)
    #expect(history.number(for: commitment, on: monday) == 70.5)
    #expect(history == before)
}

@Test("two histories holding the same numbers are the same history")
func twoHistoriesHoldingTheSameNumbersAreTheSameHistory() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let saturday = CalendarDate(year: 2026, month: 9, day: 5)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let onMonday = Number(70.5, for: commitment, on: monday)!
    let onSaturday = Number(71, for: commitment, on: saturday)!

    var first = History()
    first.add(onMonday)
    first.add(onSaturday)

    var second = History()
    second.add(onSaturday)
    second.add(onMonday)

    #expect(first == second)
}

@Test("a number on one date is not the number on another date the same commitment is due on")
func aNumberOnOneDateIsNotTheNumberOnAnotherDateTheSameCommitmentIsDueOn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!

    var history = History()
    history.add(Number(70.5, for: commitment, on: monday)!)

    #expect(history.number(for: commitment, on: wednesday) == nil)

    history.add(Number(71, for: commitment, on: wednesday)!)

    #expect(history.number(for: commitment, on: monday) == 70.5)
}

@Test("a history holds ticks and numbers side by side and answers each on its own")
func aHistoryHoldsTicksAndNumbersSideBySideAndAnswersEachOnItsOwn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!
    let tick = Tick(gym, on: monday)!
    let number = Number(70.5, for: weight, on: monday)!

    var history = History()
    history.add(tick)
    history.add(number)

    #expect(history.number(for: gym, on: monday) == nil)
    #expect(history.isKept(gym, on: monday))
    #expect(history.number(for: weight, on: monday) == 70.5)
    #expect(history.isKept(weight, on: monday))

    history.remove(tick)

    #expect(history.number(for: weight, on: monday) == 70.5)
}

@Test("a number taken back leaves the day holding no number and the commitment not kept on it")
func aNumberTakenBackLeavesTheDayHoldingNoNumberAndTheCommitmentNotKeptOnIt() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!

    var history = History()
    history.add(Number(70.5, for: commitment, on: monday)!)
    history.removeNumber(for: commitment, on: monday)

    #expect(history.number(for: commitment, on: monday) == nil)
    #expect(!history.isKept(commitment, on: monday))
}

@Test("taking back a number leaves the same commitment's numbers on other days standing")
func takingBackANumberLeavesTheSameCommitmentsNumbersOnOtherDaysStanding() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let saturday = CalendarDate(year: 2026, month: 9, day: 5)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!

    var history = History()
    history.add(Number(70.5, for: commitment, on: monday)!)
    history.add(Number(71, for: commitment, on: saturday)!)
    history.removeNumber(for: commitment, on: monday)

    #expect(history.number(for: commitment, on: saturday) == 71)
    #expect(history.number(for: commitment, on: monday) == nil)
}

@Test("taking back a number leaves another commitment's number on the same day standing")
func takingBackANumberLeavesAnotherCommitmentsNumberOnTheSameDayStanding() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!
    let mood = Commitment(
        name: "Mood", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!

    var history = History()
    history.add(Number(70.5, for: weight, on: monday)!)
    history.add(Number(8, for: mood, on: monday)!)
    history.removeNumber(for: weight, on: monday)

    #expect(history.number(for: mood, on: monday) == 8)
    #expect(history.number(for: weight, on: monday) == nil)
}

@Test("taking back a number where the history holds none leaves it unchanged")
func takingBackANumberWhereTheHistoryHoldsNoneLeavesItUnchanged() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let saturday = CalendarDate(year: 2026, month: 9, day: 5)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let tickKind = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .tick)!

    var history = History()
    history.add(Number(70.5, for: commitment, on: saturday)!)
    let before = history

    history.removeNumber(for: commitment, on: monday)
    #expect(history == before)

    history.removeNumber(for: tickKind, on: saturday)
    #expect(history == before)

    history.removeNumber(for: commitment, on: tuesday)
    #expect(history == before)
}

@Test("a history given a number and then taken back is the same as one never given one")
func aHistoryGivenANumberAndThenTakenBackIsTheSameAsOneNeverGivenOne() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!

    var history = History()
    history.add(Number(70.5, for: commitment, on: monday)!)
    history.removeNumber(for: commitment, on: monday)

    #expect(history == History())
}

@Test("a number commitment with a number recorded on a date was kept on that date")
func aNumberCommitmentWithANumberRecordedOnADateWasKeptOnThatDate() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!

    var history = History()
    history.add(Number(70.5, for: commitment, on: monday)!)

    #expect(history.isKept(commitment, on: monday))
}

@Test("a number commitment due on a date with no number recorded was not kept on it")
func aNumberCommitmentDueOnADateWithNoNumberRecordedWasNotKeptOnIt() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let moodRange = Commitment.Range(lowest: 1, highest: 10)!
    let mood = Commitment(
        name: "Mood", schedule: schedule, keptFrom: keptFrom, kind: .number(range: moodRange))!

    var history = History()
    history.add(Number(70.5, for: weight, on: monday)!)

    #expect(!history.isKept(weight, on: wednesday))
    #expect(!history.isKept(mood, on: monday))
}

@Test("every number a commitment accepts keeps its day, whatever the number is")
func everyNumberACommitmentAcceptsKeepsItsDayWhateverTheNumberIs() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let noRangeCommitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!

    var lowest = History()
    lowest.add(Number(40, for: commitment, on: monday)!)

    var highest = History()
    highest.add(Number(150, for: commitment, on: monday)!)

    var middle = History()
    middle.add(Number(95, for: commitment, on: monday)!)

    var negative = History()
    negative.add(Number(-12.75, for: noRangeCommitment, on: monday)!)

    #expect(lowest.isKept(commitment, on: monday))
    #expect(highest.isKept(commitment, on: monday))
    #expect(middle.isKept(commitment, on: monday))
    #expect(negative.isKept(noRangeCommitment, on: monday))
}

@Test("a commitment of the note kind and one of the total kind were not kept on a date they are due on")
func aCommitmentOfTheNoteKindAndOneOfTheTotalKindWereNotKeptOnADateTheyAreDueOn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let target = Commitment.Target(120)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom, kind: .total(target: target))!

    var history = History()
    history.add(Tick(gym, on: monday)!)
    history.add(Number(70.5, for: weight, on: monday)!)

    #expect(!history.isKept(journal, on: monday))
    #expect(!history.isKept(protein, on: monday))
}

@Test("a number commitment with a number on a date still takes no tick on it")
func aNumberCommitmentWithANumberOnADateStillTakesNoTickOnIt() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!

    var history = History()
    history.add(Number(70.5, for: commitment, on: monday)!)

    #expect(Tick(commitment, on: monday) == nil)
    #expect(history.number(for: commitment, on: monday) == 70.5)
}

@Test("a note is recorded for a note commitment on a date it is due on")
func aNoteIsRecordedForANoteCommitmentOnADateItIsDueOn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let note = Note("Ran 8k before work. Knee held up.", for: commitment, on: monday)

    #expect(note != nil)
}

@Test("a note commitment takes no note on a date it is not due on")
func aNoteCommitmentTakesNoNoteOnADateItIsNotDueOn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!
    let commitment = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!

    let laterFloor = CalendarDate(year: 2026, month: 9, day: 2)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let beforeFloor = Commitment(
        name: "Journal", schedule: schedule, keptFrom: laterFloor, kind: .note)!

    let noWeekday = Commitment(
        name: "Journal", schedule: Schedule.weekdays([]), keptFrom: keptFrom, kind: .note)!
    let week = [
        CalendarDate(year: 2026, month: 8, day: 31)!,
        CalendarDate(year: 2026, month: 9, day: 1)!,
        CalendarDate(year: 2026, month: 9, day: 2)!,
        CalendarDate(year: 2026, month: 9, day: 3)!,
        CalendarDate(year: 2026, month: 9, day: 4)!,
        CalendarDate(year: 2026, month: 9, day: 5)!,
        CalendarDate(year: 2026, month: 9, day: 6)!,
    ]

    #expect(Note("Ran 8k.", for: commitment, on: tuesday) == nil)
    #expect(schedule.isDue(on: monday))
    #expect(Note("Ran 8k.", for: beforeFloor, on: monday) == nil)
    for date in week {
        #expect(Note("Ran 8k.", for: noWeekday, on: date) == nil)
    }
}

@Test("a commitment whose kind is not a note takes no note on a date it is due on")
func aCommitmentWhoseKindIsNotANoteTakesNoNoteOnADateItIsDueOn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let target = Commitment.Target(120)!

    let tickKind = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let numberNoRange = Commitment(
        name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!
    let numberWithRange = Commitment(
        name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let total = Commitment(
        name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .total(target: target))!
    let noteKind = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .note)!

    #expect(Note("Ran 8k.", for: tickKind, on: monday) == nil)
    #expect(Note("Ran 8k.", for: numberNoRange, on: monday) == nil)
    #expect(Note("Ran 8k.", for: numberWithRange, on: monday) == nil)
    #expect(Note("Ran 8k.", for: total, on: monday) == nil)
    #expect(Note("Ran 8k.", for: noteKind, on: monday) != nil)
}

@Test("a text that says nothing is not a note")
func aTextThatSaysNothingIsNotANote() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let commitment = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!

    #expect(Note("", for: commitment, on: monday) == nil)
    #expect(Note("   ", for: commitment, on: monday) == nil)
    #expect(Note("\n\n\n", for: commitment, on: monday) == nil)
    #expect(Note("\t\n", for: commitment, on: monday) == nil)
    #expect(Note("\u{00A0}", for: commitment, on: monday) == nil)
    #expect(Note("Ran 8k.", for: commitment, on: monday) != nil)
}

@Test("a text holding one character that is not blank space is a note, kept with the blank space around it")
func aTextHoldingOneCharacterThatIsNotBlankSpaceIsANoteKeptWithTheBlankSpaceAroundIt() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let commitment = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!

    let withSpaceAround = Note(" \n x \t ", for: commitment, on: monday)
    let trimmed = Note("x", for: commitment, on: monday)

    #expect(withSpaceAround != nil)
    #expect(withSpaceAround != trimmed)
}

@Test("a note takes any length, any script and a line break")
func aNoteTakesAnyLengthAnyScriptAndALineBreak() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let commitment = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!

    let texts = [
        "Ran 8k before work. Knee held up.",
        String(repeating: "a", count: 100_000),
        "שלום עולם",
        "𐐷 𝔘𝔫𝔦𝔠𝔬𝔡𝔢",
        "🏃",
        "Line one\nLine two\nLine three",
    ]

    for text in texts {
        #expect(Note(text, for: commitment, on: monday) != nil)
    }

    // Each note holds the text it was given, character for character: a note formed from a text
    // differing by exactly one trailing scalar is a different note, at every one of these lengths
    // and scripts.
    for text in texts {
        let note = Note(text, for: commitment, on: monday)!
        let alteredNote = Note(text + "!", for: commitment, on: monday)!
        #expect(note != alteredNote)
    }
}

@Test("two notes are the same exactly when their commitment, date and text all are")
func twoNotesAreTheSameExactlyWhenTheirCommitmentDateAndTextAllAre() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let commitment = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let otherCommitment = Commitment(
        name: "Training journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!

    let first = Note("Ran 8k.", for: commitment, on: monday)!
    let second = Note("Ran 8k.", for: commitment, on: monday)!
    let differentText = Note("Rested.", for: commitment, on: monday)!
    let differentDate = Note("Ran 8k.", for: commitment, on: wednesday)!
    let differentCommitment = Note("Ran 8k.", for: otherCommitment, on: monday)!

    #expect(first == second)
    #expect(first != differentText)
    #expect(first != differentDate)
    #expect(first != differentCommitment)
}

@Test("a history that has taken no note has no note for a commitment on a day")
func aHistoryThatHasTakenNoNoteHasNoNoteForACommitmentOnADay() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let commitment = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!

    let history = History()

    #expect(history.note(for: commitment, on: monday) == nil)
}

@Test("a note added to a history is the note that commitment has on that day")
func aNoteAddedToAHistoryIsTheNoteThatCommitmentHasOnThatDay() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let commitment = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let text = "Ran 8k before work. Knee held up."
    let note = Note(text, for: commitment, on: monday)!

    var history = History()
    history.add(note)

    #expect(history.note(for: commitment, on: monday) == text)
}

@Test("a note on one date is not the note on another date the same commitment is due on")
func aNoteOnOneDateIsNotTheNoteOnAnotherDateTheSameCommitmentIsDueOn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let commitment = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!

    var history = History()
    history.add(Note("Ran 8k.", for: commitment, on: monday)!)

    #expect(history.note(for: commitment, on: wednesday) == nil)

    history.add(Note("Rested.", for: commitment, on: wednesday)!)

    #expect(history.note(for: commitment, on: monday) == "Ran 8k.")
}

@Test("a note of one commitment is not the note of another on the same date")
func aNoteOfOneCommitmentIsNotTheNoteOfAnotherOnTheSameDate() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let sleep = Commitment(name: "Sleep", schedule: schedule, keptFrom: keptFrom, kind: .note)!

    var history = History()
    history.add(Note("Ran 8k.", for: journal, on: monday)!)
    history.add(Note("Slept badly.", for: sleep, on: monday)!)

    #expect(history.note(for: journal, on: monday) == "Ran 8k.")
    #expect(history.note(for: sleep, on: monday) == "Slept badly.")
}

@Test("a note entered again on the same day replaces the one before it")
func aNoteEnteredAgainOnTheSameDayReplacesTheOneBeforeIt() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let commitment = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!

    var enteredTwice = History()
    enteredTwice.add(Note("Ran 8k.", for: commitment, on: monday)!)
    enteredTwice.add(Note("Ran 8k. Knee held up.", for: commitment, on: monday)!)

    var enteredOnceAtTheLaterText = History()
    enteredOnceAtTheLaterText.add(Note("Ran 8k. Knee held up.", for: commitment, on: monday)!)

    #expect(enteredTwice.note(for: commitment, on: monday) == "Ran 8k. Knee held up.")
    #expect(enteredTwice == enteredOnceAtTheLaterText)
}

@Test("a history has no note for a commitment whose kind is not a note")
func aHistoryHasNoNoteForACommitmentWhoseKindIsNotANote() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!
    let target = Commitment.Target(120)!

    let tickKind = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let numberKind = Commitment(
        name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!
    let total = Commitment(
        name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .total(target: target))!
    let noteKind = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .note)!

    var history = History()
    history.add(Tick(tickKind, on: monday)!)

    #expect(history.note(for: tickKind, on: monday) == nil)
    #expect(history.note(for: numberKind, on: monday) == nil)
    #expect(history.note(for: total, on: monday) == nil)
    #expect(history.note(for: noteKind, on: tuesday) == nil)
}

@Test("a text the system refuses leaves the note already on that day standing")
func aTextTheSystemRefusesLeavesTheNoteAlreadyOnThatDayStanding() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let commitment = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!

    var history = History()
    history.add(Note("Ran 8k.", for: commitment, on: monday)!)
    let before = history

    let refused = Note("   ", for: commitment, on: monday)

    #expect(refused == nil)
    #expect(history.note(for: commitment, on: monday) == "Ran 8k.")
    #expect(history == before)
}

@Test("two histories holding the same notes are the same history")
func twoHistoriesHoldingTheSameNotesAreTheSameHistory() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let saturday = CalendarDate(year: 2026, month: 9, day: 5)!
    let commitment = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let onMonday = Note("Ran 8k.", for: commitment, on: monday)!
    let onSaturday = Note("Rested.", for: commitment, on: saturday)!

    var first = History()
    first.add(onMonday)
    first.add(onSaturday)

    var second = History()
    second.add(onSaturday)
    second.add(onMonday)

    #expect(first == second)
}

@Test("a history holds ticks, numbers and notes side by side and answers each on its own")
func aHistoryHoldsTicksNumbersAndNotesSideBySideAndAnswersEachOnItsOwn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let tick = Tick(gym, on: monday)!
    let number = Number(70.5, for: weight, on: monday)!
    let note = Note("Ran 8k.", for: journal, on: monday)!

    var history = History()
    history.add(tick)
    history.add(number)
    history.add(note)

    #expect(history.number(for: gym, on: monday) == nil)
    #expect(history.note(for: gym, on: monday) == nil)
    #expect(history.isKept(gym, on: monday))
    #expect(history.number(for: weight, on: monday) == 70.5)
    #expect(history.note(for: weight, on: monday) == nil)
    #expect(history.isKept(weight, on: monday))
    #expect(history.note(for: journal, on: monday) == "Ran 8k.")
    #expect(history.number(for: journal, on: monday) == nil)
    #expect(history.isKept(journal, on: monday))

    history.remove(tick)

    #expect(history.number(for: weight, on: monday) == 70.5)
    #expect(history.note(for: journal, on: monday) == "Ran 8k.")
}
