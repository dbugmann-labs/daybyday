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
