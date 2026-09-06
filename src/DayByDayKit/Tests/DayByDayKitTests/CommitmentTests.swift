import Foundation
import Testing
import DayByDayKit

@Test("a commitment reads back the name it was given")
func aCommitmentReadsBackTheNameItWasGiven() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)

    #expect(commitment?.name == "Gym")
}

@Test("two commitments alike in name, schedule and kept-from day are the same commitment")
func twoCommitmentsAlikeInNameScheduleAndKeptFromDayAreTheSameCommitment() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let first = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let second = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    #expect(first == second)
}

@Test("two commitments differing only in name are different commitments")
func twoCommitmentsDifferingOnlyInNameAreDifferentCommitments() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)

    #expect(gym != run)
}

@Test("two commitments differing only in schedule are different commitments")
func twoCommitmentsDifferingOnlyInScheduleAreDifferentCommitments() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let onMonday = Commitment(name: "Gym", schedule: .weekdays([.monday]), keptFrom: keptFrom)
    let onTuesday = Commitment(name: "Gym", schedule: .weekdays([.tuesday]), keptFrom: keptFrom)

    #expect(onMonday != onTuesday)
}

@Test("two commitments differing only in the day they are kept from are different commitments")
func twoCommitmentsDifferingOnlyInTheDayTheyAreKeptFromAreDifferentCommitments() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])

    let keptFromFirst = Commitment(
        name: "Gym", schedule: schedule, keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)
    let keptFromSecond = Commitment(
        name: "Gym", schedule: schedule, keptFrom: CalendarDate(year: 2026, month: 1, day: 2)!)

    #expect(keptFromFirst != keptFromSecond)
}

@Test("an empty name is not a commitment")
func anEmptyNameIsNotACommitment() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let commitment = Commitment(name: "", schedule: schedule, keptFrom: keptFrom)

    #expect(commitment == nil)
}

@Test("a name of only whitespace is not a commitment")
func aNameOfOnlyWhitespaceIsNotACommitment() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let threeSpaces = Commitment(name: "   ", schedule: schedule, keptFrom: keptFrom)
    let tabThenNewline = Commitment(name: "\t\n", schedule: schedule, keptFrom: keptFrom)

    #expect(threeSpaces == nil)
    #expect(tabThenNewline == nil)
}

@Test("a name with a space at each end is stored exactly as given")
func aNameWithASpaceAtEachEndIsStoredExactlyAsGiven() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let padded = Commitment(name: " Gym ", schedule: schedule, keptFrom: keptFrom)
    let unpadded = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)

    #expect(padded?.name == " Gym ")
    #expect(padded != unpadded)
}

@Test("a name of a single emoji is a commitment")
func aNameOfASingleEmojiIsACommitment() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let commitment = Commitment(name: "🏋️", schedule: schedule, keptFrom: keptFrom)

    #expect(commitment?.name == "🏋️")
}

@Test("a commitment on a weekday-set schedule is due on a listed weekday and not on another")
func aCommitmentOnAWeekdaySetScheduleIsDueOnAListedWeekdayAndNotOnAnother() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    #expect(commitment.isDue(on: monday))
    #expect(!commitment.isDue(on: tuesday))
}

@Test("a commitment on a day-of-month schedule is due on the last day of a month too short for its day")
func aCommitmentOnADayOfMonthScheduleIsDueOnTheLastDayOfAMonthTooShortForItsDay() {
    let schedule = Schedule.dayOfMonth(DayOfMonth(day: 31)!)
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Finances", schedule: schedule, keptFrom: keptFrom)!

    let lastDayOfFebruary = CalendarDate(year: 2027, month: 2, day: 28)!
    let firstOfMarch = CalendarDate(year: 2027, month: 3, day: 1)!

    #expect(commitment.isDue(on: lastDayOfFebruary))
    #expect(!commitment.isDue(on: firstOfMarch))
}

@Test("a commitment on an every-N-days schedule is due on its start date and not on the day before it")
func aCommitmentOnAnEveryNDaysScheduleIsDueOnItsStartDateAndNotOnTheDayBeforeIt() {
    let start = CalendarDate(year: 2026, month: 8, day: 25)!
    let schedule = Schedule.everyNDays(DayInterval(days: 14)!, from: start)
    let commitment = Commitment(name: "Contact lenses", schedule: schedule, keptFrom: start)!

    let dayBefore = CalendarDate(year: 2026, month: 8, day: 24)!

    #expect(commitment.isDue(on: start))
    #expect(!commitment.isDue(on: dayBefore))
}

@Test("two commitments with different names and the same schedule are due on the same dates")
func twoCommitmentsWithDifferentNamesAndTheSameScheduleAreDueOnTheSameDates() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

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
        #expect(gym.isDue(on: date) == run.isDue(on: date))
    }
    #expect(dates.filter { gym.isDue(on: $0) } == [
        CalendarDate(year: 2026, month: 8, day: 31)!,
        CalendarDate(year: 2026, month: 9, day: 2)!,
        CalendarDate(year: 2026, month: 9, day: 5)!,
    ])
}

@Test("a commitment on a schedule that is due on no date is never due")
func aCommitmentOnAScheduleThatIsDueOnNoDateIsNeverDue() {
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
        #expect(!commitment.isDue(on: date))
    }
}

@Test("a commitment is not due on a date before the day it is kept from")
func aCommitmentIsNotDueOnADateBeforeTheDayItIsKeptFrom() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 9, day: 2)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    #expect(!commitment.isDue(on: monday))
    #expect(commitment.isDue(on: keptFrom))
}

@Test("a commitment is due on the day it is kept from when its schedule is due that day")
func aCommitmentIsDueOnTheDayItIsKeptFromWhenItsScheduleIsDueThatDay() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 8, day: 31)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    #expect(commitment.isDue(on: keptFrom))
}

@Test("a commitment is not due on the day it is kept from when its schedule is not due that day")
func aCommitmentIsNotDueOnTheDayItIsKeptFromWhenItsScheduleIsNotDueThatDay() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 9, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!

    #expect(!commitment.isDue(on: keptFrom))
    #expect(commitment.isDue(on: wednesday))
}

@Test("a commitment is due on none of the dates in the month before it is kept from")
func aCommitmentIsDueOnNoneOfTheDatesInTheMonthBeforeItIsKeptFrom() {
    let schedule = Schedule.dayOfMonth(DayOfMonth(day: 25)!)
    let keptFrom = CalendarDate(year: 2026, month: 9, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    let august = (1...31).map { CalendarDate(year: 2026, month: 8, day: $0)! }

    for date in august {
        #expect(!commitment.isDue(on: date))
    }
    #expect(commitment.isDue(on: CalendarDate(year: 2026, month: 9, day: 25)!))
}

@Test("an every-N-days occurrence before the day it is kept from is not due")
func anEveryNDaysOccurrenceBeforeTheDayItIsKeptFromIsNotDue() {
    let start = CalendarDate(year: 2026, month: 8, day: 25)!
    let schedule = Schedule.everyNDays(DayInterval(days: 3)!, from: start)
    let keptFrom = CalendarDate(year: 2026, month: 9, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    let firstLandingBeforeFloor = CalendarDate(year: 2026, month: 8, day: 28)!
    let nextLandingBeforeFloor = CalendarDate(year: 2026, month: 8, day: 31)!
    let firstLandingOnOrAfterFloor = CalendarDate(year: 2026, month: 9, day: 3)!

    #expect(!commitment.isDue(on: firstLandingBeforeFloor))
    #expect(!commitment.isDue(on: nextLandingBeforeFloor))
    #expect(commitment.isDue(on: firstLandingOnOrAfterFloor))
}

@Test("a commitment reads back the kind it was given")
func aCommitmentReadsBackTheKindItWasGiven() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))

    #expect(commitment?.kind == .number(range: nil))
}

@Test("a commitment of each of the four kinds is formed and reads its kind back")
func aCommitmentOfEachOfTheFourKindsIsFormedAndReadsItsKindBack() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let target = Commitment.Target(120)!

    let tick = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)
    let number = Commitment(
        name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))
    let note = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .note)
    let total = Commitment(
        name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .total(target: target))

    #expect(tick?.kind == .tick)
    #expect(number?.kind == .number(range: nil))
    #expect(note?.kind == .note)
    #expect(total?.kind == .total(target: target))
    #expect(target.amount == 120)
}

@Test("a commitment formed without a kind is of the plain kind")
func aCommitmentFormedWithoutAKindIsOfThePlainKind() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let withoutKind = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)
    let withTickNamed = Commitment(
        name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)

    #expect(withoutKind?.kind == .tick)
    #expect(withoutKind == withTickNamed)
}

@Test("a commitment's kind does not change whether it is due")
func aCommitmentsKindDoesNotChangeWhetherItIsDue() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!

    let tick = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let number = Commitment(
        name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!

    let due = CalendarDate(year: 2026, month: 8, day: 31)!
    let notDue = CalendarDate(year: 2026, month: 9, day: 1)!

    #expect(tick.isDue(on: due))
    #expect(number.isDue(on: due))
    #expect(!tick.isDue(on: notDue))
    #expect(!number.isDue(on: notDue))
}

@Test("a number commitment declares a range and reads it back")
func aNumberCommitmentDeclaresARangeAndReadsItBack() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 1, highest: 10)!

    let commitment = Commitment(
        name: "Mood", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))

    #expect(commitment?.kind == .number(range: range))
    guard case .number(range: let readBack?) = commitment?.kind else {
        Issue.record("expected a number commitment with a range")
        return
    }
    #expect(readBack.lowest == 1)
    #expect(readBack.highest == 10)
}

@Test("a range whose lowest is above its highest is not a range")
func aRangeWhoseLowestIsAboveItsHighestIsNotARange() {
    let backwards = Commitment.Range(lowest: 10, highest: 1)
    let forwards = Commitment.Range(lowest: 1, highest: 10)

    #expect(backwards == nil)
    #expect(forwards?.lowest == 1)
    #expect(forwards?.highest == 10)
}

@Test("a range whose lowest and highest are equal is a range")
func aRangeWhoseLowestAndHighestAreEqualIsARange() {
    let sameValue = Commitment.Range(lowest: 7, highest: 7)
    let negativeToZero = Commitment.Range(lowest: -40.5, highest: 0)

    #expect(sameValue != nil)
    #expect(negativeToZero != nil)
}

@Test("a range end that is not a number is not a range")
func aRangeEndThatIsNotANumberIsNotARange() {
    let lowestNotANumber = Commitment.Range(lowest: Decimal.nan, highest: 5)
    let highestNotANumber = Commitment.Range(lowest: 5, highest: Decimal.nan)

    #expect(lowestNotANumber == nil)
    #expect(highestNotANumber == nil)
}

@Test("a total commitment declares a target and reads it back")
func aTotalCommitmentDeclaresATargetAndReadsItBack() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let target = Commitment.Target(120)!

    let commitment = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom, kind: .total(target: target))

    #expect(commitment?.kind == .total(target: target))
    guard case .total(target: let readBack) = commitment?.kind else {
        Issue.record("expected a total commitment with a target")
        return
    }
    #expect(readBack.amount == 120)
}

@Test("a target with a decimal fraction is a target")
func aTargetWithADecimalFractionIsATarget() {
    let half = Commitment.Target(0.5)
    let almostTwenty = Commitment.Target(119.95)

    #expect(half?.amount == 0.5)
    #expect(almostTwenty?.amount == 119.95)
}

@Test("a target of zero and a target below zero are not targets")
func aTargetOfZeroAndATargetBelowZeroAreNotTargets() {
    let zero = Commitment.Target(0)
    let negative = Commitment.Target(-1)
    let tiny = Commitment.Target(0.0001)

    #expect(zero == nil)
    #expect(negative == nil)
    #expect(tiny != nil)
}

@Test("a target that is not a number is not a target")
func aTargetThatIsNotANumberIsNotATarget() {
    let notANumber = Commitment.Target(Decimal.nan)

    #expect(notANumber == nil)
}

@Test("two commitments differing only in the kind their days take are different commitments")
func twoCommitmentsDifferingOnlyInTheKindTheirDaysTakeAreDifferentCommitments() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let tick = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)
    let note = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .note)

    #expect(tick != note)
}

@Test("two number commitments differing only in their range are different commitments")
func twoNumberCommitmentsDifferingOnlyInTheirRangeAreDifferentCommitments() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range40to150 = Commitment.Range(lowest: 40, highest: 150)!
    let range40to200 = Commitment.Range(lowest: 40, highest: 200)!

    let withRange = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range40to150))
    let withNoRange = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))
    let withWiderRange = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range40to200))

    #expect(withRange != withNoRange)
    #expect(withRange != withWiderRange)
}
