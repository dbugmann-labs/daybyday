import Testing
import DayByDayKit

@Test("a roster that has been given no commitment holds none")
func aRosterThatHasBeenGivenNoCommitmentHoldsNone() {
    let roster = Roster()

    #expect(roster.commitments.isEmpty)
}

@Test("a roster reads its commitments back in the order they were added")
func aRosterReadsItsCommitmentsBackInTheOrderTheyWereAdded() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)

    #expect(roster.commitments == [waterPlants, gym, journaling])
}

@Test("a roster does not order its commitments by the day they are kept from")
func aRosterDoesNotOrderItsCommitmentsByTheDayTheyAreKeptFrom() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(
        name: "Gym", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 3, day: 1)!)!
    let run = Commitment(
        name: "Run", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(run)

    #expect(roster.commitments == [gym, run])
}

@Test("two rosters holding the same commitments in the same order are the same roster")
func twoRostersHoldingTheSameCommitmentsInTheSameOrderAreTheSameRoster() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    var first = Roster()
    _ = first.add(gym)
    _ = first.add(run)

    var second = Roster()
    _ = second.add(gym)
    _ = second.add(run)

    #expect(first == second)
}

@Test("two rosters holding the same commitments in a different order are different rosters")
func twoRostersHoldingTheSameCommitmentsInADifferentOrderAreDifferentRosters() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    var first = Roster()
    _ = first.add(gym)
    _ = first.add(run)

    var second = Roster()
    _ = second.add(run)
    _ = second.add(gym)

    #expect(first != second)
}

@Test("adding to a copy of a roster leaves the roster it was copied from unchanged")
func addingToACopyOfARosterLeavesTheRosterItWasCopiedFromUnchanged() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    var original = Roster()
    _ = original.add(gym)

    var copy = original
    _ = copy.add(run)

    #expect(copy.commitments == [gym, run])
    #expect(original.commitments == [gym])
    #expect(copy != original)
}

@Test("a roster holds a commitment kept from the last supported date like any other")
func aRosterHoldsACommitmentKeptFromTheLastSupportedDateLikeAnyOther() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(
        name: "Gym", schedule: schedule,
        keptFrom: CalendarDate(year: 9999, month: 12, day: 31)!)!
    let run = Commitment(
        name: "Run", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(run)

    #expect(roster.commitments == [gym, run])
}

@Test("adding a commitment a roster does not hold places it after the ones already there and says it was added")
func addingACommitmentARosterDoesNotHoldPlacesItAfterTheOnesAlreadyThereAndSaysItWasAdded() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)

    let added = roster.add(run)

    #expect(added)
    #expect(roster.commitments == [gym, run])
}

@Test("adding a commitment a roster already holds says it was not added and leaves the roster as it was")
func addingACommitmentARosterAlreadyHoldsSaysItWasNotAddedAndLeavesTheRosterAsItWas() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymAgain = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)

    let added = roster.add(gymAgain)

    var expected = Roster()
    _ = expected.add(gym)

    #expect(!added)
    #expect(roster.commitments == [gym])
    #expect(roster == expected)
}

@Test("a refused commitment does not move the one already held")
func aRefusedCommitmentDoesNotMoveTheOneAlreadyHeld() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let gymAgain = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(run)
    _ = roster.add(journaling)
    _ = roster.add(gymAgain)

    #expect(roster.commitments == [gym, run, journaling])
}

@Test("two commitments alike in name but on different schedules are both held")
func twoCommitmentsAlikeInNameButOnDifferentSchedulesAreBothHeld() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gymMonWedSat = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let gymTueThu = Commitment(
        name: "Gym", schedule: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gymMonWedSat)

    let added = roster.add(gymTueThu)

    #expect(added)
    #expect(roster.commitments == [gymMonWedSat, gymTueThu])
}

@Test("two commitments alike in name and schedule but kept from different days are both held")
func twoCommitmentsAlikeInNameAndScheduleButKeptFromDifferentDaysAreBothHeld() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let firstDay = Commitment(
        name: "Gym", schedule: schedule, keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let secondDay = Commitment(
        name: "Gym", schedule: schedule, keptFrom: CalendarDate(year: 2026, month: 1, day: 2)!)!

    var roster = Roster()
    _ = roster.add(firstDay)

    let added = roster.add(secondDay)

    #expect(added)
    #expect(roster.commitments == [firstDay, secondDay])
}

@Test("two names differing only by a space at the end are different commitments and both are held")
func twoNamesDifferingOnlyByASpaceAtTheEndAreDifferentCommitmentsAndBothAreHeld() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymWithTrailingSpace = Commitment(name: "Gym ", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)

    let added = roster.add(gymWithTrailingSpace)

    #expect(added)
    #expect(roster.commitments.map(\.name) == ["Gym", "Gym "])
}

@Test("offering a commitment the roster has stopped keeping takes it up again")
func offeringACommitmentTheRosterHasStoppedKeepingTakesItUpAgain() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymAgain = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let takenUp = roster.add(gymAgain)

    #expect(takenUp)
    #expect(roster.commitments == [gymAgain])

    var neverStopped = Roster()
    _ = neverStopped.add(gym)
    #expect(roster == neverStopped)
}

@Test("a commitment taken up again keeps the place it was taken on in")
func aCommitmentTakenUpAgainKeepsThePlaceItWasTakenOnIn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let gymAgain = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let takenUp = roster.add(gymAgain)

    #expect(takenUp)
    #expect(roster.commitments == [waterPlants, gymAgain, journaling])
}

@Test("stopping a commitment a roster keeps says so and takes it out of the commitments read back")
func stoppingACommitmentARosterKeepsSaysSoAndTakesItOutOfTheCommitmentsReadBack() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)

    let stopped = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(stopped)
    #expect(roster.commitments.isEmpty)
}

@Test("stopping one commitment leaves the others where they were")
func stoppingOneCommitmentLeavesTheOthersWhereTheyWere() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)

    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(roster.commitments == [waterPlants, journaling])
}

@Test("stopping a commitment a roster does not hold says it was not stopped and leaves the roster as it was")
func stoppingACommitmentARosterDoesNotHoldSaysItWasNotStoppedAndLeavesTheRosterAsItWas() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)

    let stopped = roster.retire(run, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(!stopped)

    var neverAsked = Roster()
    _ = neverAsked.add(gym)
    #expect(roster == neverAsked)
}

@Test("stopping a commitment already stopped says it was not stopped and keeps the day first given")
func stoppingACommitmentAlreadyStoppedSaysItWasNotStoppedAndKeepsTheDayFirstGiven() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let stoppedAgain = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 2, day: 28)!)

    #expect(!stoppedAgain)

    var askedOnce = Roster()
    _ = askedOnce.add(gym)
    _ = askedOnce.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    #expect(roster == askedOnce)
}

@Test("a commitment taken up again can be stopped again, on a new day")
func aCommitmentTakenUpAgainCanBeStoppedAgainOnANewDay() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymAgain = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    _ = roster.add(gymAgain)

    let stopped = roster.retire(gymAgain, keptUntil: CalendarDate(year: 2026, month: 2, day: 28)!)

    #expect(stopped)
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 2, day: 28)!) == [gymAgain])
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 3, day: 1)!).isEmpty)
}

@Test("a commitment kept until a day before the day it is kept from is accepted")
func aCommitmentKeptUntilADayBeforeTheDayItIsKeptFromIsAccepted() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(
        name: "Gym", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 3, day: 1)!)!

    var roster = Roster()
    _ = roster.add(gym)

    let stopped = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 1)!)

    #expect(stopped)
    #expect(roster.commitments.isEmpty)
}

@Test("two rosters differing only in the day one commitment was kept until are different rosters")
func twoRostersDifferingOnlyInTheDayOneCommitmentWasKeptUntilAreDifferentRosters() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var stoppedInJanuary = Roster()
    _ = stoppedInJanuary.add(gym)
    _ = stoppedInJanuary.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    var stoppedInFebruary = Roster()
    _ = stoppedInFebruary.add(gym)
    _ = stoppedInFebruary.retire(gym, keptUntil: CalendarDate(year: 2026, month: 2, day: 28)!)

    #expect(stoppedInJanuary != stoppedInFebruary)

    var stoppedInJanuaryAgain = Roster()
    _ = stoppedInJanuaryAgain.add(gym)
    _ = stoppedInJanuaryAgain.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(stoppedInJanuaryAgain == stoppedInJanuary)
}

@Test("stopping a commitment on a copy of a roster leaves the roster it was copied from unchanged")
func stoppingACommitmentOnACopyOfARosterLeavesTheRosterItWasCopiedFromUnchanged() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var original = Roster()
    _ = original.add(gym)

    var copy = original
    _ = copy.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(copy.commitments.isEmpty)
    #expect(original.commitments == [gym])
    #expect(original != copy)
}

@Test("a roster answers with every commitment it keeps, in the order they were taken on")
func aRosterAnswersWithEveryCommitmentItKeepsInTheOrderTheyWereTakenOn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)

    let answer = roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(answer == [waterPlants, gym])
}

@Test("a stopped commitment is in the answer on the day it was kept until and out of it on the next day")
func aStoppedCommitmentIsInTheAnswerOnTheDayItWasKeptUntilAndOutOfItOnTheNextDay() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!) == [gym])
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 2, day: 1)!).isEmpty)
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 3, day: 1)!).isEmpty)
}

@Test("a stopped commitment keeps its place in the answer for a date it was still kept on")
func aStoppedCommitmentKeepsItsPlaceInTheAnswerForADateItWasStillKeptOn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let onKeptUntilDay = roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!)
    let onTheNextDay = roster.commitments(on: CalendarDate(year: 2026, month: 2, day: 1)!)

    #expect(onKeptUntilDay == [waterPlants, gym, journaling])
    #expect(onTheNextDay == [waterPlants, journaling])
}

@Test("taking a commitment up again puts it back in the answer for the dates between")
func takingACommitmentUpAgainPutsItBackInTheAnswerForTheDatesBetween() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymAgain = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    _ = roster.add(gymAgain)

    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!) == [gymAgain])
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 2, day: 1)!) == [gymAgain])
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 3, day: 1)!) == [gymAgain])
}

@Test("stopping a commitment leaves every earlier date answering as it did")
func stoppingACommitmentLeavesEveryEarlierDateAnsweringAsItDid() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let dates = [
        CalendarDate(year: 2026, month: 1, day: 1)!,
        CalendarDate(year: 2026, month: 1, day: 2)!,
        CalendarDate(year: 1583, month: 1, day: 1)!,
    ]

    var roster = Roster()
    _ = roster.add(gym)
    let before = dates.map { roster.commitments(on: $0) }

    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    let after = dates.map { roster.commitments(on: $0) }

    #expect(before == after)
    #expect(after.allSatisfy { $0 == [gym] })
}

@Test("a commitment kept from a later date is in the answer for a date before it")
func aCommitmentKeptFromALaterDateIsInTheAnswerForADateBeforeIt() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(
        name: "Gym", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 3, day: 1)!)!

    var roster = Roster()
    _ = roster.add(gym)

    let answer = roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 1)!)

    #expect(answer == [gym])
}

@Test("a roster that holds nothing answers with nothing on every date")
func aRosterThatHoldsNothingAnswersWithNothingOnEveryDate() {
    let roster = Roster()
    let dates = [
        CalendarDate(year: 1583, month: 1, day: 1)!,
        CalendarDate(year: 2026, month: 1, day: 1)!,
        CalendarDate(year: 9999, month: 12, day: 31)!,
    ]

    let answers = dates.map { roster.commitments(on: $0) }

    #expect(answers.allSatisfy { $0.isEmpty })
}

@Test("two commitments alike in every way but the kind their days take are both held")
func twoCommitmentsAlikeInEveryWayButTheKindTheirDaysTakeAreBothHeld() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let number = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let note = Commitment(name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .note)!

    var roster = Roster()
    _ = roster.add(number)

    let added = roster.add(note)

    #expect(added)
    #expect(roster.commitments == [number, note])

    let addedAgain = roster.add(number)

    #expect(!addedAgain)
}

@Test("removing a commitment a roster keeps says so and records the day it was kept until")
func removingACommitmentARosterKeepsSaysSoAndRecordsTheDayItWasKeptUntil() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)

    let removed = roster.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(removed)
    #expect(roster.commitments.isEmpty)
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!) == [gym])
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 2, day: 1)!).isEmpty)
}

@Test("removing a commitment a roster has stopped keeping keeps the day it was already kept until")
func removingACommitmentARosterHasStoppedKeepingKeepsTheDayItWasAlreadyKeptUntil() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let removed = roster.remove(gym, keptUntil: CalendarDate(year: 2026, month: 2, day: 28)!)

    #expect(removed)
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!) == [gym])
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 2, day: 1)!).isEmpty)
}

@Test("removing one commitment leaves every other where it was")
func removingOneCommitmentLeavesEveryOtherWhereItWas() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)

    _ = roster.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(roster.commitments == [waterPlants, journaling])
    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!)
            == [waterPlants, gym, journaling])
}

@Test("removing a commitment a roster does not hold says it was not removed and leaves the roster as it was")
func removingACommitmentARosterDoesNotHoldSaysItWasNotRemovedAndLeavesTheRosterAsItWas() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)

    let removed = roster.remove(run, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(!removed)

    var neverAsked = Roster()
    _ = neverAsked.add(gym)
    #expect(roster == neverAsked)
}

@Test("removing a commitment already removed says it was not removed and keeps the day first given")
func removingACommitmentAlreadyRemovedSaysItWasNotRemovedAndKeepsTheDayFirstGiven() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let removedAgain = roster.remove(gym, keptUntil: CalendarDate(year: 2026, month: 2, day: 28)!)

    #expect(!removedAgain)

    var askedOnce = Roster()
    _ = askedOnce.add(gym)
    _ = askedOnce.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    #expect(roster == askedOnce)
}

@Test("a commitment removed as of the first supported date and one as of the last are both accepted")
func aCommitmentRemovedAsOfTheFirstSupportedDateAndOneAsOfTheLastAreBothAccepted() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(
        name: "Gym", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 3, day: 1)!)!
    let run = Commitment(
        name: "Run", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 3, day: 1)!)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(run)

    let gymRemoved = roster.remove(gym, keptUntil: CalendarDate(year: 1583, month: 1, day: 1)!)
    let runRemoved = roster.remove(run, keptUntil: CalendarDate(year: 9999, month: 12, day: 31)!)

    #expect(gymRemoved)
    #expect(runRemoved)
    #expect(roster.commitments(on: CalendarDate(year: 1583, month: 1, day: 1)!) == [gym, run])
    #expect(roster.commitments(on: CalendarDate(year: 1583, month: 1, day: 2)!) == [run])
}

@Test("a removed commitment answers whether it is due on a date exactly as it did before")
func aRemovedCommitmentAnswersWhetherItIsDueOnADateExactlyAsItDidBefore() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let answer = roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!)
    let removedGym = answer.first!

    #expect(removedGym.isDue(on: CalendarDate(year: 2026, month: 1, day: 5)!))
    #expect(!removedGym.isDue(on: CalendarDate(year: 2026, month: 1, day: 6)!))
    #expect(removedGym.name == "Gym")
    #expect(removedGym == gym)
}

@Test("removing a commitment on a copy of a roster leaves the roster it was copied from unchanged")
func removingACommitmentOnACopyOfARosterLeavesTheRosterItWasCopiedFromUnchanged() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var original = Roster()
    _ = original.add(gym)

    var copy = original
    _ = copy.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(copy.commitments.isEmpty)
    #expect(original.commitments == [gym])
    #expect(original != copy)
}

@Test("two rosters differing only in whether a commitment has been removed are different rosters")
func twoRostersDifferingOnlyInWhetherACommitmentHasBeenRemovedAreDifferentRosters() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var stopped = Roster()
    _ = stopped.add(gym)
    _ = stopped.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    var removed = Roster()
    _ = removed.add(gym)
    _ = removed.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(stopped != removed)

    var removedAgain = Roster()
    _ = removedAgain.add(gym)
    _ = removedAgain.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(removedAgain == removed)
}

@Test("a roster that has removed every commitment it holds is not a roster holding nothing")
func aRosterThatHasRemovedEveryCommitmentItHoldsIsNotARosterHoldingNothing() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(journaling)
    _ = roster.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    _ = roster.remove(journaling, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(roster != Roster())
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!) == [gym, journaling])
    #expect(roster.commitments.isEmpty)
}

@Test("offering a commitment the roster has removed takes it up again, in the place it was taken on in")
func offeringACommitmentTheRosterHasRemovedTakesItUpAgainInThePlaceItWasTakenOnIn() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let gymAgain = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)
    _ = roster.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let takenUp = roster.add(gymAgain)

    #expect(takenUp)
    #expect(roster.commitments == [waterPlants, gymAgain, journaling])

    var neverRemoved = Roster()
    _ = neverRemoved.add(waterPlants)
    _ = neverRemoved.add(gym)
    _ = neverRemoved.add(journaling)
    #expect(roster == neverRemoved)
}

@Test("a commitment taken up again after being removed is kept on every date again")
func aCommitmentTakenUpAgainAfterBeingRemovedIsKeptOnEveryDateAgain() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymAgain = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    _ = roster.add(gymAgain)

    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!) == [gymAgain])
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 2, day: 1)!) == [gymAgain])
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 3, day: 1)!) == [gymAgain])
    #expect(roster.commitments == [gymAgain])
}

@Test("stopping a commitment a roster has removed says it was not stopped and keeps the day it was kept until")
func stoppingACommitmentARosterHasRemovedSaysItWasNotStoppedAndKeepsTheDayItWasKeptUntil() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let stopped = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 2, day: 28)!)

    #expect(!stopped)

    var removedOnce = Roster()
    _ = removedOnce.add(gym)
    _ = removedOnce.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    #expect(roster == removedOnce)
}

@Test("a removed commitment is in the answer on the day it was kept until and out of it on the next day")
func aRemovedCommitmentIsInTheAnswerOnTheDayItWasKeptUntilAndOutOfItOnTheNextDay() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)
    _ = roster.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!)
            == [waterPlants, gym, journaling])
    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 2, day: 1)!)
            == [waterPlants, journaling])
    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 3, day: 1)!)
            == [waterPlants, journaling])
}

@Test("removing a commitment leaves every earlier date answering as it did")
func removingACommitmentLeavesEveryEarlierDateAnsweringAsItDid() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let dates = [
        CalendarDate(year: 2026, month: 1, day: 1)!,
        CalendarDate(year: 2026, month: 1, day: 2)!,
        CalendarDate(year: 1583, month: 1, day: 1)!,
    ]

    var roster = Roster()
    _ = roster.add(gym)
    let before = dates.map { roster.commitments(on: $0) }

    _ = roster.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    let after = dates.map { roster.commitments(on: $0) }

    #expect(before == after)
    #expect(after.allSatisfy { $0 == [gym] })
}

@Test("moving a commitment to the front puts it before every commitment the roster is keeping")
func movingACommitmentToTheFrontPutsItBeforeEveryCommitmentTheRosterIsKeeping() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)

    let moved = roster.move(journaling, toOffset: 0)

    #expect(moved)
    #expect(roster.commitments == [journaling, waterPlants, gym])
}

@Test("moving a commitment to the end puts it after every commitment the roster is keeping")
func movingACommitmentToTheEndPutsItAfterEveryCommitmentTheRosterIsKeeping() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)

    let moved = roster.move(waterPlants, toOffset: 3)

    #expect(moved)
    #expect(roster.commitments == [gym, journaling, waterPlants])
}

@Test("an offset is counted over the commitments the roster is keeping as they stand before the move")
func anOffsetIsCountedOverTheCommitmentsTheRosterIsKeepingAsTheyStandBeforeTheMove() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)
    _ = roster.move(waterPlants, toOffset: 2)

    #expect(roster.commitments == [gym, waterPlants, journaling])

    var alike = Roster()
    _ = alike.add(waterPlants)
    _ = alike.add(gym)
    _ = alike.add(journaling)
    _ = alike.move(waterPlants, toOffset: 3)

    #expect(alike.commitments == [gym, journaling, waterPlants])
}

@Test("a stopped commitment between the two places is passed rather than pushed")
func aStoppedCommitmentBetweenTheTwoPlacesIsPassedRatherThanPushed() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let reading = Commitment(name: "Reading", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)
    _ = roster.add(reading)
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let moved = roster.move(waterPlants, toOffset: 2)

    #expect(moved)
    #expect(roster.commitments == [journaling, waterPlants, reading])
    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!)
            == [gym, journaling, waterPlants, reading])

    var removedInstead = Roster()
    _ = removedInstead.add(waterPlants)
    _ = removedInstead.add(gym)
    _ = removedInstead.add(journaling)
    _ = removedInstead.add(reading)
    _ = removedInstead.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    _ = removedInstead.move(waterPlants, toOffset: 2)

    #expect(
        removedInstead.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!)
            == [gym, journaling, waterPlants, reading])
}

@Test("an offset of nothing at all puts a commitment before the first one kept and not before a stopped one")
func anOffsetOfNothingAtAllPutsACommitmentBeforeTheFirstOneKeptAndNotBeforeAStoppedOne() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)
    _ = roster.retire(waterPlants, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let moved = roster.move(journaling, toOffset: 0)

    #expect(moved)
    #expect(roster.commitments == [journaling, gym])
    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!)
            == [waterPlants, journaling, gym])
}

@Test("two offsets leave a commitment where it already is, and both are accepted")
func twoOffsetsLeaveACommitmentWhereItAlreadyIsAndBothAreAccepted() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    func neverAsked() -> Roster {
        var roster = Roster()
        _ = roster.add(waterPlants)
        _ = roster.add(gym)
        _ = roster.add(journaling)
        return roster
    }

    var atItsOwnOffset = neverAsked()
    let movedAtItsOwnOffset = atItsOwnOffset.move(gym, toOffset: 1)

    var atOffsetJustAfter = neverAsked()
    let movedAtOffsetJustAfter = atOffsetJustAfter.move(gym, toOffset: 2)

    #expect(movedAtItsOwnOffset)
    #expect(movedAtOffsetJustAfter)
    #expect(atItsOwnOffset.commitments == [waterPlants, gym, journaling])
    #expect(atOffsetJustAfter.commitments == [waterPlants, gym, journaling])
    #expect(atItsOwnOffset == neverAsked())
    #expect(atOffsetJustAfter == neverAsked())
}

@Test(
    "the offset just after a commitment's own passes nothing, with a stopped or removed commitment lying between"
)
func theOffsetJustAfterACommitmentsOwnPassesNothingWithAStoppedOrRemovedCommitmentLyingBetween() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let reading = Commitment(name: "Reading", schedule: schedule, keptFrom: keptFrom)!

    func neverAsked(removingJournaling: Bool) -> Roster {
        var roster = Roster()
        _ = roster.add(waterPlants)
        _ = roster.add(gym)
        _ = roster.add(journaling)
        _ = roster.add(reading)
        if removingJournaling {
            _ = roster.remove(journaling, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
        } else {
            _ = roster.retire(journaling, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
        }
        return roster
    }

    // "Gym" is kept second among the commitments kept — "Water plants", "Gym", "Reading" — with
    // "Journaling" stopped or removed and lying between it and "Reading", the one that follows it.
    // Offset 2 names "Reading", the offset just after "Gym"'s own, so this is a no-op: nothing
    // passes "Journaling", stopped or removed alike.
    var withStopped = neverAsked(removingJournaling: false)
    let movedWithStopped = withStopped.move(gym, toOffset: 2)

    #expect(movedWithStopped)
    #expect(withStopped == neverAsked(removingJournaling: false))

    var withRemoved = neverAsked(removingJournaling: true)
    let movedWithRemoved = withRemoved.move(gym, toOffset: 2)

    #expect(movedWithRemoved)
    #expect(withRemoved == neverAsked(removingJournaling: true))
}

@Test("a roster keeping one commitment accepts both the offsets it has")
func aRosterKeepingOneCommitmentAcceptsBothTheOffsetsItHas() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    func neverAsked() -> Roster {
        var roster = Roster()
        _ = roster.add(gym)
        return roster
    }

    var atOffsetZero = neverAsked()
    let movedAtOffsetZero = atOffsetZero.move(gym, toOffset: 0)

    var atOffsetOne = neverAsked()
    let movedAtOffsetOne = atOffsetOne.move(gym, toOffset: 1)

    #expect(movedAtOffsetZero)
    #expect(movedAtOffsetOne)
    #expect(atOffsetZero == neverAsked())
    #expect(atOffsetOne == neverAsked())

    var atOffsetTwo = neverAsked()
    let movedAtOffsetTwo = atOffsetTwo.move(gym, toOffset: 2)

    #expect(!movedAtOffsetTwo)
}

@Test("moving a commitment the roster is not keeping says it was not moved and leaves the roster as it was")
func movingACommitmentTheRosterIsNotKeepingSaysItWasNotMovedAndLeavesTheRosterAsItWas() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    func neverAsked() -> Roster {
        var roster = Roster()
        _ = roster.add(waterPlants)
        _ = roster.add(gym)
        _ = roster.add(journaling)
        _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
        _ = roster.remove(journaling, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
        return roster
    }

    var roster = neverAsked()
    let movedGym = roster.move(gym, toOffset: 0)

    #expect(!movedGym)
    #expect(roster == neverAsked())

    var alsoJournaling = neverAsked()
    let movedJournaling = alsoJournaling.move(journaling, toOffset: 0)

    var alsoRun = neverAsked()
    let movedRun = alsoRun.move(run, toOffset: 0)

    #expect(!movedJournaling)
    #expect(alsoJournaling == neverAsked())
    #expect(!movedRun)
    #expect(alsoRun == neverAsked())
}

@Test("an offset below zero and one above the number of commitments kept are both refused")
func anOffsetBelowZeroAndOneAboveTheNumberOfCommitmentsKeptAreBothRefused() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    func neverAsked() -> Roster {
        var roster = Roster()
        _ = roster.add(waterPlants)
        _ = roster.add(gym)
        return roster
    }

    var roster = neverAsked()
    let movedBelowZero = roster.move(gym, toOffset: -1)

    #expect(!movedBelowZero)
    #expect(roster == neverAsked())

    var alsoAbove = neverAsked()
    let movedAboveTheCount = alsoAbove.move(gym, toOffset: 3)

    #expect(!movedAboveTheCount)
    #expect(alsoAbove == neverAsked())
}

@Test("moving a commitment moves no day and changes no commitment")
func movingACommitmentMovesNoDayAndChangesNoCommitment() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let waterPlants = Commitment(
        name: "Water plants", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let gym = Commitment(
        name: "Gym", schedule: schedule, keptFrom: CalendarDate(year: 2026, month: 3, day: 1)!)!
    let journaling = Commitment(
        name: "Journaling", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 6, day: 1)!)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)
    _ = roster.retire(waterPlants, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let moved = roster.move(journaling, toOffset: 0)
    let onNextDay = roster.commitments(on: CalendarDate(year: 2026, month: 2, day: 1)!)

    #expect(moved)
    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!)
            == [waterPlants, journaling, gym])
    #expect(onNextDay == [journaling, gym])

    let gymFromRoster = onNextDay.first { $0.name == "Gym" }!
    #expect(gymFromRoster.isDue(on: CalendarDate(year: 2026, month: 3, day: 2)!))
    #expect(!gymFromRoster.isDue(on: CalendarDate(year: 2026, month: 3, day: 3)!))
}

@Test("moving a commitment on a copy of a roster leaves the roster it was copied from unchanged")
func movingACommitmentOnACopyOfARosterLeavesTheRosterItWasCopiedFromUnchanged() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var original = Roster()
    _ = original.add(waterPlants)
    _ = original.add(gym)

    var copy = original
    _ = copy.move(gym, toOffset: 0)

    #expect(copy.commitments == [gym, waterPlants])
    #expect(original.commitments == [waterPlants, gym])
    #expect(original != copy)
}

@Test("a commitment moved and then stopped is taken up again in the place it was moved to")
func aCommitmentMovedAndThenStoppedIsTakenUpAgainInThePlaceItWasMovedTo() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let journalingAgain = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)
    _ = roster.move(journaling, toOffset: 0)
    _ = roster.retire(journaling, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let takenUp = roster.add(journalingAgain)

    #expect(takenUp)
    #expect(roster.commitments == [journalingAgain, waterPlants, gym])
}

@Test("a roster answers about a date in the order it was moved into")
func aRosterAnswersAboutADateInTheOrderItWasMovedInto() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    _ = roster.move(journaling, toOffset: 0)

    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!)
            == [journaling, waterPlants, gym])
    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 2, day: 1)!)
            == [journaling, waterPlants])
}

@Test("removing a commitment that has been moved keeps it in the place it was moved to")
func removingACommitmentThatHasBeenMovedKeepsItInThePlaceItWasMovedTo() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)
    _ = roster.move(journaling, toOffset: 0)

    let removed = roster.remove(journaling, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(removed)
    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!)
            == [journaling, waterPlants, gym])
    #expect(roster.commitments == [waterPlants, gym])
}
