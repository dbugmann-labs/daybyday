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

@Test("two rosters differing only in the category one commitment is under are different rosters")
func twoRostersDifferingOnlyInTheCategoryOneCommitmentIsUnderAreDifferentRosters() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    var first = Roster()
    _ = first.add(gym)
    _ = first.add(run)
    _ = first.put(gym, under: "Sport")

    var second = Roster()
    _ = second.add(gym)
    _ = second.add(run)

    var third = Roster()
    _ = third.add(gym)
    _ = third.add(run)
    _ = third.put(gym, under: "Sport")

    #expect(first != second)
    #expect(third == first)
}

@Test("a roster holding two eras of one commitment reads back one commitment it is keeping")
func aRosterHoldingTwoErasOfOneCommitmentReadsBackOneCommitmentItIsKeeping() {
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]),
        keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let newEra = Commitment(
        era: gym, schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!, kind: .tick)!

    var roster = Roster()
    _ = roster.add(gym)

    let put = roster.put(
        era: newEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!,
        under: nil)

    #expect(put)
    #expect(roster.commitments == [newEra])
    #expect(roster.stopped.isEmpty)
    #expect(roster.eras(of: gym) == [newEra, gym])
}

@Test("a roster says a commitment's day kept from as its earliest era's and its rhythm as its newest era's")
func aRosterSaysACommitmentsDayKeptFromAsItsEarliestErasAndItsRhythmAsItsNewestErasRhythm() {
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]),
        keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let secondEra = Commitment(
        era: gym, schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!, kind: .tick)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.put(
        era: secondEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!,
        under: nil)

    #expect(roster.keptFrom(of: gym) == CalendarDate(year: 2026, month: 1, day: 1)!)
    #expect(roster.eras(of: gym).first?.rhythmInWords == "Tue, Thu")

    let thirdEra = Commitment(
        era: gym, schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!),
        keptFrom: CalendarDate(year: 2026, month: 10, day: 1)!, kind: .tick)!
    _ = roster.put(
        era: thirdEra, on: secondEra, keptUntil: CalendarDate(year: 2026, month: 9, day: 30)!,
        under: nil)

    #expect(roster.keptFrom(of: gym) == CalendarDate(year: 2026, month: 1, day: 1)!)
    #expect(roster.eras(of: gym).first?.rhythmInWords == "3x a week")
}

@Test("a roster answers a date with the era of a commitment that holds that day")
func aRosterAnswersADateWithTheEraOfACommitmentThatHoldsThatDay() {
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]),
        keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let newEra = Commitment(
        era: gym, schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!, kind: .tick)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.put(
        era: newEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!,
        under: nil)

    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 8, day: 31)!) == [newEra, gym])
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 9, day: 1)!) == [newEra])
}

@Test("an earlier era of a stopped commitment is in neither what a roster keeps nor what it has stopped")
func anEarlierEraOfAStoppedCommitmentIsInNeitherWhatARosterKeepsNorWhatItHasStopped() {
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]),
        keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let newEra = Commitment(
        era: gym, schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!, kind: .tick)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.put(
        era: newEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!,
        under: nil)
    _ = roster.retire(newEra, keptUntil: CalendarDate(year: 2026, month: 9, day: 30)!)

    #expect(roster.commitments.isEmpty)
    #expect(roster.stopped == [newEra])
    #expect(roster.eras(of: gym) == [newEra, gym])
}

@Test("a roster holding eras of two commitments keeps each commitment's eras together")
func aRosterHoldingErasOfTwoCommitmentsKeepsEachCommitmentsErasTogether() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let gymNewEra = Commitment(
        era: gym, schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!, kind: .tick)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(run)
    _ = roster.put(
        era: gymNewEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!,
        under: nil)

    #expect(roster.commitments == [gymNewEra, run])
    #expect(roster.eras(of: gymNewEra) == [gymNewEra, gym])
    #expect(roster.eras(of: run) == [run])
}

@Test("a new era put on a commitment lands in that commitment's place rather than after every commitment already there")
func aNewEraPutOnACommitmentLandsInThatCommitmentsPlaceRatherThanAfterEveryCommitmentAlreadyThere() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let gymNewEra = Commitment(
        era: gym, schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!, kind: .tick)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)
    _ = roster.put(
        era: gymNewEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!,
        under: nil)

    #expect(roster.commitments == [waterPlants, gymNewEra, journaling])

    let reading = Commitment(name: "Reading", schedule: schedule, keptFrom: keptFrom)!
    _ = roster.add(reading)

    #expect(roster.commitments.last == reading)
}

@Test("stopping a commitment with two eras records the day against its newest")
func stoppingACommitmentWithTwoErasRecordsTheDayAgainstItsNewest() {
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]),
        keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let newEra = Commitment(
        era: gym, schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 3, day: 1)!, kind: .tick)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.put(
        era: newEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 2, day: 28)!,
        under: nil)

    let stopped = roster.retire(newEra, keptUntil: CalendarDate(year: 2026, month: 3, day: 31)!)

    #expect(stopped)
    #expect(roster.commitments.isEmpty)
    #expect(roster.stopped == [newEra])
    #expect(roster.eras(of: gym).count == 2)
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 3, day: 31)!) == [newEra])
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 4, day: 1)!).isEmpty)
}

@Test("renaming a commitment writes the new name on every era of it")
func renamingACommitmentWritesTheNewNameOnEveryEraOfIt() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let newEra = Commitment(
        era: gym, schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!, kind: .tick)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.put(
        era: newEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!,
        under: nil)

    let renamed = roster.rename(gym, to: "Lifting")

    #expect(renamed)
    let eras = roster.eras(of: gym)
    #expect(eras.count == 2)
    #expect(eras.map(\.name) == ["Lifting", "Lifting"])
    #expect(eras[0].rhythmInWords == "Tue, Thu")
    #expect(eras[1].rhythmInWords == "Mon, Wed, Sat")
    #expect(roster.keptFrom(of: gym) == keptFrom)
    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 8, day: 31)!).map(\.rhythmInWords)
            == ["Tue, Thu", "Mon, Wed, Sat"])
    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 9, day: 1)!).map(\.rhythmInWords)
            == ["Tue, Thu"])
}

@Test("a renamed commitment keeps its place, its category and its state")
func aRenamedCommitmentKeepsItsPlaceItsCategoryAndItsState() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym, under: "Sport")
    _ = roster.add(journaling)
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let renamed = roster.rename(gym, to: "Lifting")

    #expect(renamed)
    #expect(roster.commitments.map(\.name) == ["Water plants", "Journaling"])
    #expect(roster.stopped.map(\.name) == ["Lifting"])

    _ = roster.add(gym)

    #expect(roster.commitments.map(\.name) == ["Water plants", "Lifting", "Journaling"])
    let liftingGroup = roster.groups.first { $0.commitments.contains { $0.name == "Lifting" } }
    #expect(liftingGroup?.category == "Sport")
}

@Test("renaming a commitment a roster does not hold is refused and leaves the roster as it was")
func renamingACommitmentARosterDoesNotHoldIsRefusedAndLeavesTheRosterAsItWas() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)

    let renamed = roster.rename(run, to: "Lifting")

    #expect(!renamed)

    var neverAsked = Roster()
    _ = neverAsked.add(gym)
    #expect(roster == neverAsked)
}

@Test("renaming a commitment to a name another commitment already has is refused")
func renamingACommitmentToANameAnotherCommitmentAlreadyHasIsRefused() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(run)

    let renamed = roster.rename(gym, to: "Run")

    #expect(!renamed)

    var neverAsked = Roster()
    _ = neverAsked.add(gym)
    _ = neverAsked.add(run)
    #expect(roster == neverAsked)

    var stoppedRun = Roster()
    _ = stoppedRun.add(gym)
    _ = stoppedRun.add(run)
    _ = stoppedRun.retire(run, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    let stoppedRenamed = stoppedRun.rename(gym, to: "Run")
    #expect(!stoppedRenamed)

    var removedRun = Roster()
    _ = removedRun.add(gym)
    _ = removedRun.add(run)
    _ = removedRun.remove(run, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    let removedRenamed = removedRun.rename(gym, to: "Run")
    #expect(removedRenamed)
}

@Test("renaming a commitment to the name it already has changes nothing and is not refused")
func renamingACommitmentToTheNameItAlreadyHasChangesNothingAndIsNotRefused() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)

    let renamed = roster.rename(gym, to: "Gym")

    #expect(renamed)

    var neverAsked = Roster()
    _ = neverAsked.add(gym)
    #expect(roster == neverAsked)

    var upperCased = Roster()
    _ = upperCased.add(gym)
    let upperCasedRenamed = upperCased.rename(gym, to: "GYM")
    #expect(upperCasedRenamed)
    #expect(upperCased.commitments.map(\.name) == ["GYM"])
}

@Test("renaming a commitment on a copy of a roster leaves the roster it was copied from unchanged")
func renamingACommitmentOnACopyOfARosterLeavesTheRosterItWasCopiedFromUnchanged() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var original = Roster()
    _ = original.add(gym)

    var copy = original
    _ = copy.rename(gym, to: "Lifting")

    // `Roster ==` cannot tell these two apart — `Commitment: Hashable` compares identities
    // alone, `design.md` § *Equality is the identity, and an era is an entry* — so what each
    // reads back is the proof that the copy's rename never reached the original.
    #expect(copy.commitments.map(\.name) == ["Lifting"])
    #expect(original.commitments.map(\.name) == ["Gym"])
}

@Test("a new era takes the place the commitment held and becomes its newest")
func aNewEraTakesThePlaceTheCommitmentHeldAndBecomesItsNewest() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let newEra = Commitment(
        era: gym, schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!, kind: .tick)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)

    let put = roster.put(
        era: newEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!,
        under: nil)

    #expect(put)
    #expect(roster.commitments == [waterPlants, newEra, journaling])
    #expect(roster.commitments.map(\.rhythmInWords) == ["Mon, Wed, Sat", "Tue, Thu", "Mon, Wed, Sat"])
    #expect(roster.keptFrom(of: gym) == keptFrom)
}

@Test("the era a new one gives way to carries the day it was kept until and sits behind it")
func theEraANewOneGivesWayToCarriesTheDayItWasKeptUntilAndSitsBehindIt() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let newEra = Commitment(
        era: gym, schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!, kind: .tick)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.put(
        era: newEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!,
        under: nil)

    #expect(roster.eras(of: gym).map(\.rhythmInWords) == ["Tue, Thu", "Mon, Wed, Sat"])
    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 8, day: 31)!).map(\.rhythmInWords)
            == ["Tue, Thu", "Mon, Wed, Sat"])
    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 9, day: 1)!).map(\.rhythmInWords)
            == ["Tue, Thu"])
}

@Test("a commitment a new era is put on is put under the category it was offered under")
func aCommitmentANewEraIsPutOnIsPutUnderTheCategoryItWasOfferedUnder() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let newEra = Commitment(
        era: gym, schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!, kind: .tick)!

    var roster = Roster()
    _ = roster.add(gym, under: "Sport")
    _ = roster.put(
        era: newEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!,
        under: "Morning")

    #expect(roster.groups.count == 1)
    #expect(roster.groups.first?.category == "Morning")
    #expect(roster.groups.first?.commitments.map(\.rhythmInWords) == ["Tue, Thu"])
    #expect(roster.eras(of: gym).allSatisfy { era in
        roster.groups.contains { $0.category == "Morning" && $0.commitments.contains(era) }
    })
}

@Test("putting an era on a commitment a roster is not keeping is refused")
func puttingAnEraOnACommitmentARosterIsNotKeepingIsRefused() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let newEra = Commitment(
        era: gym, schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!, kind: .tick)!
    let untouched = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let untouchedNewEra = Commitment(
        era: untouched, schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!, kind: .tick)!

    var stoppedRoster = Roster()
    _ = stoppedRoster.add(gym)
    _ = stoppedRoster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    let neverAsked = stoppedRoster

    let put = stoppedRoster.put(
        era: newEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!,
        under: nil)

    #expect(!put)
    #expect(stoppedRoster == neverAsked)

    var removedRoster = Roster()
    _ = removedRoster.add(gym)
    _ = removedRoster.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    let removedPut = removedRoster.put(
        era: newEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!,
        under: nil)
    #expect(!removedPut)

    var neverHeldRoster = Roster()
    let neverHeldPut = neverHeldRoster.put(
        era: untouchedNewEra, on: untouched, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!,
        under: nil)
    #expect(!neverHeldPut)
}

@Test("putting an era that is not of that commitment on it is refused")
func puttingAnEraThatIsNotOfThatCommitmentOnItIsRefused() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let unrelatedEra = Commitment(name: "Gym", schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!)!

    var roster = Roster()
    _ = roster.add(gym)
    let neverAsked = roster

    let putUnrelated = roster.put(
        era: unrelatedEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!,
        under: nil)
    #expect(!putUnrelated)
    #expect(roster == neverAsked)

    var withLifting = Roster()
    _ = withLifting.add(gym)
    _ = withLifting.rename(gym, to: "Lifting")
    // `wrongNamedEra` carries `gym`'s original name "Gym", not the roster's current "Lifting" —
    // an era whose name does not match the commitment it is offered to.
    let wrongNamedEra = Commitment(
        era: gym, schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!, kind: .tick)!
    let putWrongName = withLifting.put(
        era: wrongNamedEra, on: withLifting.eras(of: gym).first!,
        keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!, under: nil)
    #expect(!putWrongName)

    let noteEra = Commitment(
        name: "Gym", schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!, kind: .note)!
    var otherKindRoster = Roster()
    _ = otherKindRoster.add(gym)
    let putOtherKind = otherKindRoster.put(
        era: noteEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!, under: nil)
    #expect(!putOtherKind)
}

@Test("an era put on as of a day before the day the era it gives way to is kept from leaves it holding no day")
func anEraPutOnAsOfADayBeforeTheDayTheEraItGivesWayToIsKeptFromLeavesItHoldingNoDay() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let newEra = Commitment(
        era: gym, schedule: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom, kind: .tick)!

    var roster = Roster()
    _ = roster.add(gym)

    let put = roster.put(
        era: newEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 2, day: 28)!, under: nil)

    #expect(put)
    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 2, day: 28)!).map(\.rhythmInWords)
            == ["Tue, Thu", "Mon, Wed, Sat"])
    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 3, day: 1)!).map(\.rhythmInWords)
            == ["Tue, Thu"])
}

@Test("an era put on as of the first supported date and one as of the last are both accepted")
func anEraPutOnAsOfTheFirstSupportedDateAndOneAsOfTheLastAreBothAccepted() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let gymNewEra = Commitment(
        era: gym, schedule: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom, kind: .tick)!
    let runNewEra = Commitment(
        era: run, schedule: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom, kind: .tick)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(run)

    let putFirst = roster.put(
        era: gymNewEra, on: gym, keptUntil: CalendarDate(year: 1583, month: 1, day: 1)!, under: nil)
    let putLast = roster.put(
        era: runNewEra, on: run, keptUntil: CalendarDate(year: 9999, month: 12, day: 31)!, under: nil)

    #expect(putFirst)
    #expect(putLast)
    #expect(
        roster.commitments(on: CalendarDate(year: 1583, month: 1, day: 1)!).count == 4)
    #expect(
        roster.commitments(on: CalendarDate(year: 1583, month: 1, day: 2)!).map(\.rhythmInWords)
            == ["Tue, Thu", "Tue, Thu", "Mon, Wed, Sat"])
}

@Test("a third era put on a commitment leaves it one commitment with three eras")
func aThirdEraPutOnACommitmentLeavesItOneCommitmentWithThreeEras() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let secondEra = Commitment(
        era: gym, schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 2, day: 1)!, kind: .tick)!
    let thirdEra = Commitment(
        era: gym, schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!),
        keptFrom: CalendarDate(year: 2026, month: 3, day: 1)!, kind: .tick)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.put(
        era: secondEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!, under: nil)
    _ = roster.put(
        era: thirdEra, on: secondEra, keptUntil: CalendarDate(year: 2026, month: 2, day: 28)!,
        under: nil)

    #expect(roster.commitments.count == 1)
    #expect(roster.commitments.first?.rhythmInWords == "3x a week")
    #expect(roster.eras(of: gym).count == 3)
    #expect(roster.keptFrom(of: gym) == keptFrom)
}

@Test("putting an era on a copy of a roster leaves the roster it was copied from unchanged")
func puttingAnEraOnACopyOfARosterLeavesTheRosterItWasCopiedFromUnchanged() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let newEra = Commitment(
        era: gym, schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!, kind: .tick)!

    var original = Roster()
    _ = original.add(gym)

    var copy = original
    _ = copy.put(
        era: newEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!, under: nil)

    #expect(copy.commitments.map(\.rhythmInWords) == ["Tue, Thu"])
    #expect(copy.eras(of: gym).count == 2)
    #expect(original.commitments.map(\.rhythmInWords) == ["Mon, Wed, Sat"])
    #expect(original.eras(of: gym).count == 1)
}

@Test("changing an era puts the result in the place the one it replaced held")
func changingAnEraPutsTheResultInThePlaceTheOneItReplacedHeld() {
    let keptFrom = CalendarDate(year: 2026, month: 8, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let changedEra = Commitment(
        era: gym, schedule: schedule, keptFrom: CalendarDate(year: 2026, month: 6, day: 1)!,
        kind: .tick)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)

    let changed = roster.change(gym, to: changedEra, under: nil)

    #expect(changed)
    #expect(roster.commitments == [waterPlants, changedEra, journaling])
    #expect(roster.keptFrom(of: gym) == CalendarDate(year: 2026, month: 6, day: 1)!)
}

@Test("changing the earliest era of a commitment with two leaves the newer one alone")
func changingTheEarliestEraOfACommitmentWithTwoLeavesTheNewerOneAlone() {
    let keptFrom = CalendarDate(year: 2026, month: 8, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let newerEra = Commitment(
        era: gym, schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!, kind: .tick)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.put(
        era: newerEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!,
        under: nil)

    let earlierEra = roster.eras(of: gym).last!
    let changedEarlierEra = Commitment(
        era: gym, schedule: schedule, keptFrom: CalendarDate(year: 2026, month: 6, day: 1)!,
        kind: .tick)!

    let changed = roster.change(earlierEra, to: changedEarlierEra, under: nil)

    #expect(changed)
    #expect(roster.keptFrom(of: gym) == CalendarDate(year: 2026, month: 6, day: 1)!)
    #expect(roster.commitments.first?.rhythmInWords == "Tue, Thu")
    #expect(roster.eras(of: gym).count == 2)
}

@Test("changing an era for one of another commitment is refused")
func changingAnEraForOneOfAnotherCommitmentIsRefused() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let anotherGym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    let neverAsked = roster

    let changed = roster.change(gym, to: anotherGym, under: nil)

    #expect(!changed)
    #expect(roster == neverAsked)

    // The one public way to a value carrying `gym`'s identity but a different name: rename it on
    // a roster of its own, and read that era back.
    var helperRoster = Roster()
    _ = helperRoster.add(gym)
    _ = helperRoster.rename(gym, to: "Lifting")
    let liftingNamedEra = helperRoster.eras(of: gym).first!

    var liftingRoster = Roster()
    _ = liftingRoster.add(gym)
    let liftingChanged = liftingRoster.change(gym, to: liftingNamedEra, under: nil)
    #expect(!liftingChanged)

    var noteRoster = Roster()
    _ = noteRoster.add(gym)
    let noteEra = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let noteChanged = noteRoster.change(gym, to: noteEra, under: nil)
    #expect(!noteChanged)
}

@Test("changing an era a roster does not hold is refused and leaves the roster as it was")
func changingAnEraARosterDoesNotHoldIsRefusedAndLeavesTheRosterAsItWas() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let runChanged = Commitment(
        era: run, schedule: schedule, keptFrom: CalendarDate(year: 2026, month: 2, day: 1)!,
        kind: .tick)!

    var roster = Roster()
    _ = roster.add(gym)
    let neverAsked = roster

    let changed = roster.change(run, to: runChanged, under: nil)

    #expect(!changed)
    #expect(roster == neverAsked)
}

@Test("changing an era of a stopped commitment leaves it stopped, on the day it was kept until")
func changingAnEraOfAStoppedCommitmentLeavesItStoppedOnTheDayItWasKeptUntil() {
    let keptFrom = CalendarDate(year: 2026, month: 8, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let changedEra = Commitment(
        era: gym, schedule: schedule, keptFrom: CalendarDate(year: 2026, month: 6, day: 1)!,
        kind: .tick)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!)

    let changed = roster.change(gym, to: changedEra, under: nil)

    #expect(changed)
    #expect(roster.commitments.isEmpty)
    #expect(roster.stopped == [changedEra])
    #expect(roster.keptFrom(of: gym) == CalendarDate(year: 2026, month: 6, day: 1)!)
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 8, day: 31)!) == [changedEra])
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 9, day: 1)!).isEmpty)
}

@Test("changing an era for itself under a different category puts its commitment under that category")
func changingAnEraForItselfUnderADifferentCategoryPutsItsCommitmentUnderThatCategory() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym, under: "Sport")
    _ = roster.add(journaling, under: nil)

    let changed = roster.change(gym, to: gym, under: "Morning")

    #expect(changed)
    #expect(roster.groups.count == 2)
    #expect(roster.groups[0].category == "Morning")
    #expect(roster.groups[0].commitments == [gym])
    #expect(roster.groups[1].category == nil)
    #expect(roster.groups[1].commitments == [journaling])
}

@Test("changing an era on a copy of a roster leaves the roster it was copied from unchanged")
func changingAnEraOnACopyOfARosterLeavesTheRosterItWasCopiedFromUnchanged() {
    let keptFrom = CalendarDate(year: 2026, month: 8, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let changedEra = Commitment(
        era: gym, schedule: schedule, keptFrom: CalendarDate(year: 2026, month: 6, day: 1)!,
        kind: .tick)!

    var original = Roster()
    _ = original.add(gym)

    var copy = original
    _ = copy.change(gym, to: changedEra, under: nil)

    #expect(copy.keptFrom(of: gym) == CalendarDate(year: 2026, month: 6, day: 1)!)
    #expect(original.keptFrom(of: gym) == keptFrom)
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

@Test("adding a commitment whose name a roster already keeps says it was not added and leaves the roster as it was")
func addingACommitmentWhoseNameARosterAlreadyKeepsSaysItWasNotAddedAndLeavesTheRosterAsItWas() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let secondGym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)

    let added = roster.add(secondGym)

    var expected = Roster()
    _ = expected.add(gym)

    #expect(!added)
    #expect(roster.commitments == [gym])
    #expect(roster == expected)
}

@Test("a commitment whose name a roster already keeps is refused whatever else differs")
func aCommitmentWhoseNameARosterAlreadyKeepsIsRefusedWhateverElseDiffers() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .tick)!
    let secondGym = Commitment(
        name: "Gym", schedule: .weekdays([.tuesday, .thursday]),
        keptFrom: CalendarDate(year: 2026, month: 1, day: 2)!, kind: .note)!

    var roster = Roster()
    _ = roster.add(gym)

    let added = roster.add(secondGym)

    #expect(!added)
    #expect(roster.commitments.count == 1)
}

@Test("a commitment whose name a roster has stopped keeping already has is refused")
func aCommitmentWhoseNameARosterHasStoppedKeepingAlreadyHasIsRefused() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let secondGym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let added = roster.add(secondGym)

    #expect(!added)
    #expect(roster.commitments.isEmpty)
    #expect(roster.stopped.map(\.name) == ["Gym"])
}

@Test("a name a roster has only removed a commitment under is free")
func aNameARosterHasOnlyRemovedACommitmentUnderIsFree() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let secondGym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let added = roster.add(secondGym)

    #expect(added)
    #expect(roster.commitments == [secondGym])
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!).count == 2)
}

@Test("two names differing only in the case of a letter are one name and the second is refused")
func twoNamesDifferingOnlyInTheCaseOfALetterAreOneNameAndTheSecondIsRefused() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let lowercase = Commitment(name: "gym", schedule: schedule, keptFrom: keptFrom)!
    let uppercase = Commitment(name: "GYM", schedule: schedule, keptFrom: keptFrom)!
    let padded = Commitment(name: " Gym ", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)

    let addedLowercase = roster.add(lowercase)
    let addedUppercase = roster.add(uppercase)
    let addedPadded = roster.add(padded)

    #expect(!addedLowercase)
    #expect(!addedUppercase)
    #expect(!addedPadded)
    #expect(roster.commitments.map(\.name) == ["Gym"])
}

@Test("two names differing by blank space inside them are two names and both are held")
func twoNamesDifferingByBlankSpaceInsideThemAreTwoNamesAndBothAreHeld() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let noSpace = Commitment(name: "Waterplants", schedule: schedule, keptFrom: keptFrom)!
    let doubleSpace = Commitment(name: "Water  plants", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)

    let addedNoSpace = roster.add(noSpace)
    let addedDoubleSpace = roster.add(doubleSpace)

    #expect(addedNoSpace)
    #expect(addedDoubleSpace)
    #expect(roster.commitments.map(\.name) == ["Water plants", "Waterplants", "Water  plants"])
}

@Test("a commitment offered again as itself where the roster has stopped keeping it takes it up again")
func aCommitmentOfferedAgainAsItselfWhereTheRosterHasStoppedKeepingItTakesItUpAgain() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let takenUp = roster.add(gym)

    #expect(takenUp)
    #expect(roster.commitments == [gym])

    var neverStopped = Roster()
    _ = neverStopped.add(gym)
    #expect(roster == neverStopped)
}

@Test("a commitment offered again as itself is taken up again in the place it was taken on in")
func aCommitmentOfferedAgainAsItselfIsTakenUpAgainInThePlaceItWasTakenOnIn() {
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

    let takenUp = roster.add(gym)

    #expect(takenUp)
    #expect(roster.commitments == [waterPlants, gym, journaling])
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

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    _ = roster.add(gym)

    let stopped = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 2, day: 28)!)

    #expect(stopped)
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 2, day: 28)!) == [gym])
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

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    _ = roster.add(gym)

    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!) == [gym])
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 2, day: 1)!) == [gym])
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 3, day: 1)!) == [gym])
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
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 2, day: 1)!).isEmpty)
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

@Test("a commitment offered again as itself where the roster has removed it takes it up again")
func aCommitmentOfferedAgainAsItselfWhereTheRosterHasRemovedItTakesItUpAgain() {
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

    let takenUp = roster.add(gym)

    #expect(takenUp)
    #expect(roster.commitments == [waterPlants, gym, journaling])
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!).contains(gym))
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 2, day: 1)!).contains(gym))
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 3, day: 1)!).contains(gym))
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
    #expect(roster.commitments(on: CalendarDate(year: 2026, month: 2, day: 1)!).isEmpty)
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

    let moved = roster.move(journaling, toOffset: 0, under: nil)

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

    let moved = roster.move(waterPlants, toOffset: 3, under: nil)

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
    _ = roster.move(waterPlants, toOffset: 2, under: nil)

    #expect(roster.commitments == [gym, waterPlants, journaling])

    var alike = Roster()
    _ = alike.add(waterPlants)
    _ = alike.add(gym)
    _ = alike.add(journaling)
    _ = alike.move(waterPlants, toOffset: 3, under: nil)

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

    let moved = roster.move(waterPlants, toOffset: 2, under: nil)

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
    _ = removedInstead.move(waterPlants, toOffset: 2, under: nil)

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

    let moved = roster.move(journaling, toOffset: 0, under: nil)

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
    let movedAtItsOwnOffset = atItsOwnOffset.move(gym, toOffset: 1, under: nil)

    var atOffsetJustAfter = neverAsked()
    let movedAtOffsetJustAfter = atOffsetJustAfter.move(gym, toOffset: 2, under: nil)

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
    let movedWithStopped = withStopped.move(gym, toOffset: 2, under: nil)

    #expect(movedWithStopped)
    #expect(withStopped == neverAsked(removingJournaling: false))

    var withRemoved = neverAsked(removingJournaling: true)
    let movedWithRemoved = withRemoved.move(gym, toOffset: 2, under: nil)

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
    let movedAtOffsetZero = atOffsetZero.move(gym, toOffset: 0, under: nil)

    var atOffsetOne = neverAsked()
    let movedAtOffsetOne = atOffsetOne.move(gym, toOffset: 1, under: nil)

    #expect(movedAtOffsetZero)
    #expect(movedAtOffsetOne)
    #expect(atOffsetZero == neverAsked())
    #expect(atOffsetOne == neverAsked())

    var atOffsetTwo = neverAsked()
    let movedAtOffsetTwo = atOffsetTwo.move(gym, toOffset: 2, under: nil)

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
    let movedGym = roster.move(gym, toOffset: 0, under: nil)

    #expect(!movedGym)
    #expect(roster == neverAsked())

    var alsoJournaling = neverAsked()
    let movedJournaling = alsoJournaling.move(journaling, toOffset: 0, under: nil)

    var alsoRun = neverAsked()
    let movedRun = alsoRun.move(run, toOffset: 0, under: nil)

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
    let movedBelowZero = roster.move(gym, toOffset: -1, under: nil)

    #expect(!movedBelowZero)
    #expect(roster == neverAsked())

    var alsoAbove = neverAsked()
    let movedAboveTheCount = alsoAbove.move(gym, toOffset: 3, under: nil)

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

    let moved = roster.move(journaling, toOffset: 0, under: nil)
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
    _ = copy.move(gym, toOffset: 0, under: nil)

    #expect(copy.commitments == [gym, waterPlants])
    #expect(original.commitments == [waterPlants, gym])
    #expect(original != copy)
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
    _ = roster.move(journaling, toOffset: 0, under: nil)

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
    _ = roster.move(journaling, toOffset: 0, under: nil)

    let removed = roster.remove(journaling, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(removed)
    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!)
            == [journaling, waterPlants, gym])
    #expect(roster.commitments == [waterPlants, gym])
}

@Test("a commitment a roster is keeping is put under the category it was given")
func aCommitmentARosterIsKeepingIsPutUnderTheCategoryItWasGiven() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(creatine)
    _ = roster.add(gym)

    let put = roster.put(creatine, under: "Supplements")

    #expect(put)
    #expect(
        roster.groups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
}

@Test("a roster none of whose commitments is under a category reads back one group")
func aRosterNoneOfWhoseCommitmentsIsUnderACategoryReadsBackOneGroup() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)

    #expect(
        roster.groups
            == [Roster.Group(category: nil, commitments: [waterPlants, gym, journaling])])
}

@Test("a category of nothing but blank space puts a commitment under none, and is not refused")
func aCategoryOfNothingButBlankSpacePutsACommitmentUnderNoneAndIsNotRefused() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(creatine)
    _ = roster.put(creatine, under: "Supplements")

    let put = roster.put(creatine, under: "   ")

    #expect(put)
    #expect(roster.groups == [Roster.Group(category: nil, commitments: [creatine])])

    var emptied = Roster()
    _ = emptied.add(creatine)
    _ = emptied.put(creatine, under: "Supplements")
    _ = emptied.put(creatine, under: "")

    #expect(emptied.groups == [Roster.Group(category: nil, commitments: [creatine])])
}

@Test("a category is held exactly as it was given, blank space at its ends and all")
func aCategoryIsHeldExactlyAsItWasGivenBlankSpaceAtItsEndsAndAll() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(creatine)
    _ = roster.add(magnesium)
    _ = roster.put(creatine, under: " Supplements ")
    _ = roster.put(magnesium, under: "Supplements")

    #expect(
        roster.groups
            == [
                Roster.Group(category: " Supplements ", commitments: [creatine]),
                Roster.Group(category: "Supplements", commitments: [magnesium]),
            ])

    var bothSame = Roster()
    _ = bothSame.add(creatine)
    _ = bothSame.add(magnesium)
    _ = bothSame.put(creatine, under: " Supplements ")
    _ = bothSame.put(magnesium, under: " Supplements ")

    #expect(
        bothSame.groups
            == [Roster.Group(category: " Supplements ", commitments: [creatine, magnesium])])
}

@Test("putting a commitment under the category it is already under is accepted and changes nothing")
func puttingACommitmentUnderTheCategoryItIsAlreadyUnderIsAcceptedAndChangesNothing() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!

    var onceRoster = Roster()
    _ = onceRoster.add(creatine)
    _ = onceRoster.put(creatine, under: "Supplements")

    var twiceRoster = onceRoster
    let put = twiceRoster.put(creatine, under: "Supplements")

    #expect(put)
    #expect(twiceRoster == onceRoster)
}

@Test("putting a commitment the roster is not keeping under a category is refused")
func puttingACommitmentTheRosterIsNotKeepingUnderACategoryIsRefused() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(creatine)
    _ = roster.add(gym)
    _ = roster.add(journaling)
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    _ = roster.remove(journaling, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let neverAsked = roster

    let stoppedPut = roster.put(gym, under: "Sport")
    let removedPut = roster.put(journaling, under: "Sport")
    let neverHeldPut = roster.put(run, under: "Sport")

    #expect(!stoppedPut)
    #expect(!removedPut)
    #expect(!neverHeldPut)
    #expect(roster == neverAsked)
}

@Test("a commitment the roster has stopped keeping is still under the category it was under")
func aCommitmentTheRosterHasStoppedKeepingIsStillUnderTheCategoryItWasUnder() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(creatine)
    _ = roster.add(gym)
    _ = roster.put(creatine, under: "Supplements")
    _ = roster.retire(creatine, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    _ = roster.add(creatine)

    #expect(
        roster.groups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])

    var neverStopped = Roster()
    _ = neverStopped.add(creatine)
    _ = neverStopped.add(gym)
    _ = neverStopped.put(creatine, under: "Supplements")

    #expect(roster == neverStopped)
}

@Test("putting a commitment under a category changes no day, no commitment and no order")
func puttingACommitmentUnderACategoryChangesNoDayNoCommitmentAndNoOrder() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let creatine = Commitment(
        name: "Creatine", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let gym = Commitment(
        name: "Gym", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 3, day: 1)!)!
    let journaling = Commitment(
        name: "Journaling", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 6, day: 1)!)!

    var roster = Roster()
    _ = roster.add(creatine)
    _ = roster.add(gym)
    _ = roster.add(journaling)
    _ = roster.retire(creatine, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    _ = roster.put(journaling, under: "Evening")

    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!).contains(creatine))
    #expect(
        !roster.commitments(on: CalendarDate(year: 2026, month: 2, day: 1)!).contains(creatine))

    // Each of the three reads back exactly the commitment it was given — an equal value,
    // day it is kept from included — and "Gym" answers due on its own schedule unmoved.
    // Read "Gym" back out of the roster rather than off the local value, so a `put` that
    // dropped or altered it would be caught here.
    let keptGym = roster.commitments.first { $0.name == "Gym" }
    #expect(keptGym?.isDue(on: CalendarDate(year: 2026, month: 3, day: 2)!) == true)
    #expect(keptGym?.isDue(on: CalendarDate(year: 2026, month: 3, day: 3)!) == false)

    #expect(roster.commitments == [gym, journaling])
}

@Test("putting a commitment under a category on a copy of a roster leaves the roster it was copied from unchanged")
func puttingACommitmentUnderACategoryOnACopyOfARosterLeavesTheRosterItWasCopiedFromUnchanged() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var original = Roster()
    _ = original.add(creatine)
    _ = original.add(gym)

    var copy = original
    _ = copy.put(creatine, under: "Supplements")

    #expect(
        copy.groups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
    #expect(original.groups == [Roster.Group(category: nil, commitments: [creatine, gym])])
    #expect(original != copy)
}

@Test("a roster that has been given no commitment reads back no groups at all")
func aRosterThatHasBeenGivenNoCommitmentReadsBackNoGroupsAtAll() {
    let roster = Roster()

    #expect(roster.groups.isEmpty)

    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(
        name: "Gym", schedule: schedule, keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!

    var stoppedRoster = Roster()
    _ = stoppedRoster.add(gym)
    _ = stoppedRoster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(stoppedRoster.groups.isEmpty)
}

@Test("a group sits where its first commitment sits in the order the roster holds them")
func aGroupSitsWhereItsFirstCommitmentSitsInTheOrderTheRosterHoldsThem() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: schedule, keptFrom: keptFrom)!
    let finances = Commitment(name: "Finances", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(creatine)
    _ = roster.add(gym)
    _ = roster.add(magnesium)
    _ = roster.add(finances)
    _ = roster.put(creatine, under: "Supplements")
    _ = roster.put(magnesium, under: "Supplements")
    _ = roster.put(gym, under: "Sport")

    let groups = roster.groups

    #expect(
        groups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: nil, commitments: [finances]),
            ])
    #expect(groups.map(\.category) != groups.map(\.category).sorted { ($0 ?? "") < ($1 ?? "") })
}

@Test("the commitments under no category come last however early the first of them sits")
func theCommitmentsUnderNoCategoryComeLastHoweverEarlyTheFirstOfThemSits() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let finances = Commitment(name: "Finances", schedule: schedule, keptFrom: keptFrom)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(finances)
    _ = roster.add(creatine)
    _ = roster.add(gym)
    _ = roster.put(creatine, under: "Supplements")
    _ = roster.put(gym, under: "Sport")

    #expect(
        roster.groups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: nil, commitments: [finances]),
            ])

    var financesCategorised = roster
    _ = financesCategorised.put(finances, under: "Supplements")

    #expect(
        financesCategorised.groups
            == [
                Roster.Group(category: "Supplements", commitments: [finances, creatine]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
}

@Test("a category whose last commitment is put under another is no longer a group")
func aCategoryWhoseLastCommitmentIsPutUnderAnotherIsNoLongerAGroup() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(creatine)
    _ = roster.add(gym)
    _ = roster.put(gym, under: "Sport")
    _ = roster.put(gym, under: "Supplements")

    let groups = roster.groups

    #expect(
        groups
            == [
                Roster.Group(category: "Supplements", commitments: [gym]),
                Roster.Group(category: nil, commitments: [creatine]),
            ])
    #expect(!groups.contains { $0.category == "Sport" })
}

@Test("reading in groups and reading flat answer with the same commitments in different orders")
func readingInGroupsAndReadingFlatAnswerWithTheSameCommitmentsInDifferentOrders() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(creatine)
    _ = roster.add(gym)
    _ = roster.add(magnesium)
    _ = roster.put(creatine, under: "Supplements")
    _ = roster.put(magnesium, under: "Supplements")

    #expect(roster.commitments == [creatine, gym, magnesium])
    #expect(
        roster.groups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
}

@Test("a roster answers about a date in groups, with what it had not stopped keeping on it")
func aRosterAnswersAboutADateInGroupsWithWhatItHadNotStoppedKeepingOnIt() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(creatine)
    _ = roster.add(gym)
    _ = roster.add(journaling)
    _ = roster.put(creatine, under: "Supplements")
    _ = roster.put(gym, under: "Sport")
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(
        roster.groups(on: CalendarDate(year: 2026, month: 1, day: 31)!)
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: nil, commitments: [journaling]),
            ])
    #expect(
        roster.groups(on: CalendarDate(year: 2026, month: 2, day: 1)!)
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [journaling]),
            ])
}

@Test("a removed commitment is in the groups a roster answers a date with, under its category")
func aRemovedCommitmentIsInTheGroupsARosterAnswersADateWithUnderItsCategory() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(creatine)
    _ = roster.add(gym)
    _ = roster.put(gym, under: "Sport")
    _ = roster.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(
        roster.groups(on: CalendarDate(year: 2026, month: 1, day: 31)!)
            == [
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: nil, commitments: [creatine]),
            ])
    #expect(
        roster.groups(on: CalendarDate(year: 2026, month: 2, day: 1)!)
            == [Roster.Group(category: nil, commitments: [creatine])])
}

@Test("a commitment a roster does not hold is added under the category it was offered under")
func aCommitmentARosterDoesNotHoldIsAddedUnderTheCategoryItWasOfferedUnder() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    let addedCreatine = roster.add(creatine, under: "Supplements")
    let addedGym = roster.add(gym, under: nil)
    let addedJournaling = roster.add(journaling)

    #expect(addedCreatine)
    #expect(addedGym)
    #expect(addedJournaling)
    #expect(
        roster.groups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym, journaling]),
            ])
}

@Test("a commitment offered again with no category said keeps the category it was under")
func aCommitmentOfferedAgainWithNoCategorySaidKeepsTheCategoryItWasUnder() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(creatine, under: "Supplements")
    _ = roster.retire(creatine, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let takenUpAgain = roster.add(creatine)

    #expect(takenUpAgain)
    #expect(roster.groups == [Roster.Group(category: "Supplements", commitments: [creatine])])
}

@Test("a commitment taken up again is put under the category it was offered under")
func aCommitmentTakenUpAgainIsPutUnderTheCategoryItWasOfferedUnder() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(creatine, under: "Supplements")
    _ = roster.retire(creatine, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let takenUpAgain = roster.add(creatine, under: "Morning")

    #expect(takenUpAgain)
    #expect(roster.groups == [Roster.Group(category: "Morning", commitments: [creatine])])

    var takenUpUnderNone = Roster()
    _ = takenUpUnderNone.add(creatine, under: "Supplements")
    _ = takenUpUnderNone.retire(creatine, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    _ = takenUpUnderNone.add(creatine, under: nil)

    #expect(
        takenUpUnderNone.groups == [Roster.Group(category: nil, commitments: [creatine])])
}

@Test("a commitment a roster is already keeping is refused whatever category it is offered under")
func aCommitmentARosterIsAlreadyKeepingIsRefusedWhateverCategoryItIsOfferedUnder() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(creatine, under: "Supplements")
    let onceOnly = roster

    let refused = roster.add(creatine, under: "Morning")

    #expect(!refused)
    #expect(roster.groups == [Roster.Group(category: "Supplements", commitments: [creatine])])
    #expect(roster == onceOnly)
}

@Test("a move puts a commitment under the category it was moved under")
func aMovePutsACommitmentUnderTheCategoryItWasMovedUnder() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(waterPlants)
    _ = roster.add(gym)
    _ = roster.add(journaling)

    let moved = roster.move(journaling, toOffset: 0, under: "Sport")

    #expect(moved)
    #expect(
        roster.groups
            == [
                Roster.Group(category: "Sport", commitments: [journaling]),
                Roster.Group(category: nil, commitments: [waterPlants, gym]),
            ])
}

@Test("a move under no category takes a commitment's category off")
func aMoveUnderNoCategoryTakesACommitmentsCategoryOff() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(journaling)
    _ = roster.put(gym, under: "Sport")

    let moved = roster.move(gym, toOffset: 2, under: nil)

    #expect(moved)
    #expect(
        roster.groups == [Roster.Group(category: nil, commitments: [journaling, gym])])
}

@Test("a move to the place a commitment already has still puts it under the category it was moved under")
func aMoveToThePlaceACommitmentAlreadyHasStillPutsItUnderTheCategoryItWasMovedUnder() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(journaling)
    let neverAsked = roster

    let moved = roster.move(gym, toOffset: 0, under: "Sport")

    #expect(moved)
    #expect(
        roster.groups
            == [
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: nil, commitments: [journaling]),
            ])
    #expect(roster != neverAsked)
}

@Test("a refused move puts a commitment under no category at all")
func aRefusedMovePutsACommitmentUnderNoCategoryAtAll() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(journaling)
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    let neverAsked = roster

    let movedGym = roster.move(gym, toOffset: 0, under: "Sport")

    #expect(!movedGym)
    #expect(roster == neverAsked)

    let movedJournaling = roster.move(journaling, toOffset: -1, under: "Sport")

    #expect(!movedJournaling)
    #expect(roster == neverAsked)
}

@Test("moving a group to the front draws it before every other group under a category")
func movingAGroupToTheFrontDrawsItBeforeEveryOtherGroupUnderACategory() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(creatine)
    _ = roster.add(magnesium)
    _ = roster.put(gym, under: "Sport")
    _ = roster.put(creatine, under: "Supplements")
    _ = roster.put(magnesium, under: "Supplements")

    let moved = roster.move(group: "Supplements", toOffset: 0)

    #expect(moved)
    #expect(
        roster.groups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
    #expect(roster.commitments == [creatine, magnesium, gym])
}

@Test(
    "moving a group to the end draws it after every other group under a category and before the commitments under none"
)
func movingAGroupToTheEndDrawsItAfterEveryOtherGroupUnderACategoryAndBeforeTheCommitmentsUnderNone()
{
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let finances = Commitment(name: "Finances", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(creatine)
    _ = roster.add(gym)
    _ = roster.add(finances)
    _ = roster.put(creatine, under: "Supplements")
    _ = roster.put(gym, under: "Sport")

    let moved = roster.move(group: "Supplements", toOffset: 2)

    #expect(moved)
    #expect(
        roster.groups
            == [
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [finances]),
            ])
    #expect(roster.commitments == [gym, creatine, finances])
}

@Test("an offset for a group is counted over the groups the roster is keeping that are under a category")
func anOffsetForAGroupIsCountedOverTheGroupsTheRosterIsKeepingThatAreUnderACategory() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let finances = Commitment(name: "Finances", schedule: schedule, keptFrom: keptFrom)!

    func neverAsked() -> Roster {
        var roster = Roster()
        _ = roster.add(waterPlants)
        _ = roster.add(gym)
        _ = roster.add(creatine)
        _ = roster.add(finances)
        _ = roster.put(gym, under: "Sport")
        _ = roster.put(creatine, under: "Supplements")
        _ = roster.put(finances, under: "Money")
        return roster
    }

    var beforeSupplements = neverAsked()
    let movedBeforeSupplements = beforeSupplements.move(group: "Money", toOffset: 1)

    #expect(movedBeforeSupplements)
    #expect(
        beforeSupplements.groups
            == [
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: "Money", commitments: [finances]),
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [waterPlants]),
            ])

    var afterEveryGroup = neverAsked()
    let movedAfterEveryGroup = afterEveryGroup.move(group: "Sport", toOffset: 3)

    #expect(movedAfterEveryGroup)
    #expect(
        afterEveryGroup.groups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "Money", commitments: [finances]),
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: nil, commitments: [waterPlants]),
            ])
}

@Test("a group's stopped and removed commitments travel with it")
func aGroupsStoppedAndRemovedCommitmentsTravelWithIt() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let thirtyFirstOfJanuary = CalendarDate(year: 2026, month: 1, day: 31)!

    var stopped = Roster()
    _ = stopped.add(creatine)
    _ = stopped.add(magnesium)
    _ = stopped.add(gym)
    _ = stopped.add(journaling)
    _ = stopped.put(creatine, under: "Supplements")
    _ = stopped.put(magnesium, under: "Supplements")
    _ = stopped.put(gym, under: "Sport")
    _ = stopped.put(journaling, under: "Sport")
    _ = stopped.retire(creatine, keptUntil: thirtyFirstOfJanuary)

    let movedStopped = stopped.move(group: "Supplements", toOffset: 2)

    #expect(movedStopped)
    #expect(
        stopped.groups
            == [
                Roster.Group(category: "Sport", commitments: [gym, journaling]),
                Roster.Group(category: "Supplements", commitments: [magnesium]),
            ])
    #expect(
        stopped.groups(on: thirtyFirstOfJanuary)
            == [
                Roster.Group(category: "Sport", commitments: [gym, journaling]),
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
            ])

    var removed = Roster()
    _ = removed.add(creatine)
    _ = removed.add(magnesium)
    _ = removed.add(gym)
    _ = removed.add(journaling)
    _ = removed.put(creatine, under: "Supplements")
    _ = removed.put(magnesium, under: "Supplements")
    _ = removed.put(gym, under: "Sport")
    _ = removed.put(journaling, under: "Sport")
    _ = removed.remove(creatine, keptUntil: thirtyFirstOfJanuary)

    let movedRemoved = removed.move(group: "Supplements", toOffset: 2)

    #expect(movedRemoved)
    #expect(
        removed.groups(on: thirtyFirstOfJanuary)
            == [
                Roster.Group(category: "Sport", commitments: [gym, journaling]),
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
            ])
}

@Test("a group's commitments are gathered into one block, keeping their order against each other")
func aGroupsCommitmentsAreGatheredIntoOneBlockKeepingTheirOrderAgainstEachOther() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(creatine)
    _ = roster.add(gym)
    _ = roster.add(magnesium)
    _ = roster.put(creatine, under: "Supplements")
    _ = roster.put(magnesium, under: "Supplements")
    _ = roster.put(gym, under: "Sport")

    let moved = roster.move(group: "Supplements", toOffset: 2)

    #expect(moved)
    #expect(roster.commitments == [gym, creatine, magnesium])
    #expect(
        roster.groups
            == [
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
            ])
}

@Test("two offsets leave a group where it is, and both are accepted")
func twoOffsetsLeaveAGroupWhereItIsAndBothAreAccepted() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: schedule, keptFrom: keptFrom)!

    func neverAsked() -> Roster {
        var roster = Roster()
        _ = roster.add(creatine)
        _ = roster.add(gym)
        _ = roster.add(magnesium)
        _ = roster.put(creatine, under: "Supplements")
        _ = roster.put(magnesium, under: "Supplements")
        _ = roster.put(gym, under: "Sport")
        return roster
    }

    var atItsOwnOffset = neverAsked()
    let movedAtItsOwnOffset = atItsOwnOffset.move(group: "Supplements", toOffset: 0)

    var atOffsetJustAfter = neverAsked()
    let movedAtOffsetJustAfter = atOffsetJustAfter.move(group: "Supplements", toOffset: 1)

    #expect(movedAtItsOwnOffset)
    #expect(movedAtOffsetJustAfter)
    #expect(atItsOwnOffset == neverAsked())
    #expect(atOffsetJustAfter == neverAsked())
    #expect(atItsOwnOffset.commitments == [creatine, gym, magnesium])
    #expect(
        atItsOwnOffset.groups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
    #expect(atOffsetJustAfter.groups == atItsOwnOffset.groups)
}

@Test("moving the group of the commitments under no category is refused")
func movingTheGroupOfTheCommitmentsUnderNoCategoryIsRefused() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    func neverAsked() -> Roster {
        var roster = Roster()
        _ = roster.add(creatine)
        _ = roster.add(gym)
        _ = roster.put(creatine, under: "Supplements")
        return roster
    }

    var roster = neverAsked()
    let movedNilCategory = roster.move(group: nil, toOffset: 0)

    #expect(!movedNilCategory)
    #expect(roster == neverAsked())

    var blank = neverAsked()
    let movedBlankCategory = blank.move(group: "   ", toOffset: 0)

    #expect(!movedBlankCategory)
    #expect(blank == neverAsked())
}

@Test("moving a group no commitment the roster is keeping is under is refused")
func movingAGroupNoCommitmentTheRosterIsKeepingIsUnderIsRefused() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let thirtyFirstOfJanuary = CalendarDate(year: 2026, month: 1, day: 31)!

    func neverAsked() -> Roster {
        var roster = Roster()
        _ = roster.add(creatine)
        _ = roster.add(gym)
        _ = roster.add(journaling)
        _ = roster.put(creatine, under: "Supplements")
        _ = roster.put(gym, under: "Sport")
        _ = roster.put(journaling, under: "Money")
        _ = roster.retire(gym, keptUntil: thirtyFirstOfJanuary)
        _ = roster.remove(journaling, keptUntil: thirtyFirstOfJanuary)
        return roster
    }

    var stoppedOnly = neverAsked()
    let movedStoppedOnly = stoppedOnly.move(group: "Sport", toOffset: 0)

    #expect(!movedStoppedOnly)
    #expect(stoppedOnly == neverAsked())

    var removedOnly = neverAsked()
    let movedRemovedOnly = removedOnly.move(group: "Money", toOffset: 0)

    var nothing = neverAsked()
    let movedNothing = nothing.move(group: "Evening", toOffset: 0)

    #expect(!movedRemovedOnly)
    #expect(removedOnly == neverAsked())
    #expect(!movedNothing)
    #expect(nothing == neverAsked())
}

@Test("an offset below zero and one above the number of groups under a category are both refused for a group")
func anOffsetBelowZeroAndOneAboveTheNumberOfGroupsUnderACategoryAreBothRefusedForAGroup() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let finances = Commitment(name: "Finances", schedule: schedule, keptFrom: keptFrom)!

    func neverAsked() -> Roster {
        var roster = Roster()
        _ = roster.add(creatine)
        _ = roster.add(gym)
        _ = roster.add(finances)
        _ = roster.put(creatine, under: "Supplements")
        _ = roster.put(gym, under: "Sport")
        return roster
    }

    var belowZero = neverAsked()
    let movedBelowZero = belowZero.move(group: "Sport", toOffset: -1)

    #expect(!movedBelowZero)
    #expect(belowZero == neverAsked())

    var aboveTheCount = neverAsked()
    let movedAboveTheCount = aboveTheCount.move(group: "Sport", toOffset: 3)

    #expect(!movedAboveTheCount)
    #expect(aboveTheCount == neverAsked())
    #expect(aboveTheCount.groups.count == 3)
}

@Test("moving a group moves no day and changes no commitment")
func movingAGroupMovesNoDayAndChangesNoCommitment() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let creatine = Commitment(
        name: "Creatine", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let gym = Commitment(
        name: "Gym", schedule: schedule, keptFrom: CalendarDate(year: 2026, month: 3, day: 1)!)!
    let journaling = Commitment(
        name: "Journaling", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 6, day: 1)!)!

    var roster = Roster()
    _ = roster.add(creatine)
    _ = roster.add(gym)
    _ = roster.add(journaling)
    _ = roster.put(creatine, under: "Supplements")
    _ = roster.put(gym, under: "Sport")
    _ = roster.retire(journaling, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let moved = roster.move(group: "Sport", toOffset: 0)

    #expect(moved)
    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!)
            == [gym, creatine, journaling])
    #expect(
        roster.commitments(on: CalendarDate(year: 2026, month: 2, day: 1)!) == [gym, creatine])

    let gymFromRoster = roster.commitments.first { $0.name == "Gym" }!
    #expect(gymFromRoster.isDue(on: CalendarDate(year: 2026, month: 3, day: 2)!))
    #expect(!gymFromRoster.isDue(on: CalendarDate(year: 2026, month: 3, day: 3)!))
    #expect(
        roster.groups
            == [
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: "Supplements", commitments: [creatine]),
            ])
}

@Test("moving a group on a copy of a roster leaves the roster it was copied from unchanged")
func movingAGroupOnACopyOfARosterLeavesTheRosterItWasCopiedFromUnchanged() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var original = Roster()
    _ = original.add(creatine)
    _ = original.add(gym)
    _ = original.put(creatine, under: "Supplements")
    _ = original.put(gym, under: "Sport")

    var copy = original
    let moved = copy.move(group: "Sport", toOffset: 0)

    #expect(moved)
    #expect(
        copy.groups
            == [
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: "Supplements", commitments: [creatine]),
            ])
    #expect(
        original.groups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
    #expect(original != copy)
}

@Test("a group is put before the first commitment the roster is keeping under the group at the offset")
func aGroupIsPutBeforeTheFirstCommitmentTheRosterIsKeepingUnderTheGroupAtTheOffset() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let finances = Commitment(name: "Finances", schedule: schedule, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let thirtyFirstOfJanuary = CalendarDate(year: 2026, month: 1, day: 31)!

    var roster = Roster()
    _ = roster.add(creatine)
    _ = roster.add(finances)
    _ = roster.add(magnesium)
    _ = roster.add(gym)
    _ = roster.put(creatine, under: "Supplements")
    _ = roster.put(magnesium, under: "Supplements")
    _ = roster.put(finances, under: "Money")
    _ = roster.put(gym, under: "Sport")
    _ = roster.retire(creatine, keptUntil: thirtyFirstOfJanuary)

    let moved = roster.move(group: "Sport", toOffset: 1)

    #expect(moved)
    #expect(
        roster.groups
            == [
                Roster.Group(category: "Money", commitments: [finances]),
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: "Supplements", commitments: [magnesium]),
            ])
    #expect(
        roster.commitments(on: thirtyFirstOfJanuary)
            == [creatine, finances, gym, magnesium])
}

@Test("a group placed against a kept commitment is read in a different order on a date before a stop")
func aGroupPlacedAgainstAKeptCommitmentIsReadInADifferentOrderOnADateBeforeAStop() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: schedule, keptFrom: keptFrom)!
    let vitaminD = Commitment(name: "Vitamin D", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let thirtyFirstOfJanuary = CalendarDate(year: 2026, month: 1, day: 31)!

    var roster = Roster()
    _ = roster.add(creatine)
    _ = roster.add(magnesium)
    _ = roster.add(vitaminD)
    _ = roster.add(gym)
    _ = roster.put(creatine, under: "Supplements")
    _ = roster.put(magnesium, under: "Supplements")
    _ = roster.put(vitaminD, under: "Supplements")
    _ = roster.put(gym, under: "Sport")
    _ = roster.retire(creatine, keptUntil: thirtyFirstOfJanuary)

    let moved = roster.move(group: "Sport", toOffset: 0)

    #expect(moved)
    #expect(
        roster.groups
            == [
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: "Supplements", commitments: [magnesium, vitaminD]),
            ])
    #expect(
        roster.groups(on: thirtyFirstOfJanuary)
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium, vitaminD]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
    #expect(
        roster.commitments(on: thirtyFirstOfJanuary)
            == [creatine, gym, magnesium, vitaminD])
}

@Test("a roster keeping one group under a category accepts both the offsets it has")
func aRosterKeepingOneGroupUnderACategoryAcceptsBothTheOffsetsItHas() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    func neverAsked() -> Roster {
        var roster = Roster()
        _ = roster.add(creatine)
        _ = roster.add(gym)
        _ = roster.put(creatine, under: "Supplements")
        return roster
    }

    var atOffsetZero = neverAsked()
    let movedAtOffsetZero = atOffsetZero.move(group: "Supplements", toOffset: 0)

    var atOffsetOne = neverAsked()
    let movedAtOffsetOne = atOffsetOne.move(group: "Supplements", toOffset: 1)

    #expect(movedAtOffsetZero)
    #expect(movedAtOffsetOne)
    #expect(atOffsetZero == neverAsked())
    #expect(atOffsetOne == neverAsked())

    var atOffsetTwo = neverAsked()
    let movedAtOffsetTwo = atOffsetTwo.move(group: "Supplements", toOffset: 2)

    #expect(!movedAtOffsetTwo)
}

@Test("a roster holding no commitments answers no earliest day anything it holds is kept from")
func aRosterHoldingNoCommitmentsAnswersNoEarliestDayAnythingItHoldsIsKeptFrom() {
    let roster = Roster()

    #expect(roster.earliestKeptFrom == nil)
}

@Test("a roster answers the earliest day among the commitments it holds")
func aRosterAnswersTheEarliestDayAmongTheCommitmentsItHolds() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(
        name: "Gym", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 3, day: 1)!)!
    let run = Commitment(
        name: "Run", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let journaling = Commitment(
        name: "Journaling", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 2, day: 1)!)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(run)
    _ = roster.add(journaling)

    var otherOrder = Roster()
    _ = otherOrder.add(journaling)
    _ = otherOrder.add(run)
    _ = otherOrder.add(gym)

    #expect(roster.earliestKeptFrom == CalendarDate(year: 2026, month: 1, day: 1))
    #expect(otherOrder.earliestKeptFrom == CalendarDate(year: 2026, month: 1, day: 1))
}

@Test("a roster counts a commitment it has stopped keeping in the earliest day anything it holds is kept from")
func aRosterCountsACommitmentItHasStoppedKeepingInTheEarliestDayAnythingItHoldsIsKeptFrom() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(
        name: "Gym", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let run = Commitment(
        name: "Run", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 3, day: 1)!)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(run)
    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(roster.earliestKeptFrom == CalendarDate(year: 2026, month: 1, day: 1))
    #expect(roster.commitments == [run])
}

@Test("the earliest day anything a roster holds is kept from falls when a commitment kept from an earlier day is taken on")
func theEarliestDayAnythingARosterHoldsIsKeptFromFallsWhenACommitmentKeptFromAnEarlierDayIsTakenOn() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(
        name: "Gym", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 3, day: 1)!)!
    let run = Commitment(
        name: "Run", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let journaling = Commitment(
        name: "Journaling", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 6, day: 1)!)!

    var roster = Roster()
    _ = roster.add(gym)
    let firstAnswer = roster.earliestKeptFrom

    _ = roster.add(run)
    let secondAnswer = roster.earliestKeptFrom

    _ = roster.add(journaling)

    #expect(firstAnswer == CalendarDate(year: 2026, month: 3, day: 1))
    #expect(secondAnswer == CalendarDate(year: 2026, month: 1, day: 1))
    #expect(roster.earliestKeptFrom == CalendarDate(year: 2026, month: 1, day: 1))
}

@Test("a roster answers the day a commitment is kept from and not a day it is due")
func aRosterAnswersTheDayACommitmentIsKeptFromAndNotADayItIsDue() {
    let schedule = Schedule.weekdays([.monday])
    let keptFrom = CalendarDate(year: 2026, month: 2, day: 1)!  // a Sunday
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    _ = roster.add(gym)

    #expect(roster.earliestKeptFrom == keptFrom)
    #expect(!gym.isDue(on: keptFrom))
    #expect(gym.isDue(on: CalendarDate(year: 2026, month: 2, day: 2)!))
}

@Test("a roster answers the first supported date where a commitment it holds is kept from it")
func aRosterAnswersTheFirstSupportedDateWhereACommitmentItHoldsIsKeptFromIt() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(
        name: "Gym", schedule: schedule,
        keptFrom: CalendarDate(year: 9999, month: 12, day: 31)!)!
    let run = Commitment(
        name: "Run", schedule: schedule,
        keptFrom: CalendarDate(year: 1583, month: 1, day: 1)!)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(run)

    #expect(roster.earliestKeptFrom == CalendarDate(year: 1583, month: 1, day: 1))
}

@Test("a roster counts a commitment it has removed in the earliest day anything it holds is kept from")
func aRosterCountsACommitmentItHasRemovedInTheEarliestDayAnythingItHoldsIsKeptFrom() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(
        name: "Gym", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let run = Commitment(
        name: "Run", schedule: schedule,
        keptFrom: CalendarDate(year: 2026, month: 3, day: 1)!)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(run)
    _ = roster.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    #expect(roster.earliestKeptFrom == CalendarDate(year: 2026, month: 1, day: 1))
    #expect(roster.commitments == [run])
}

@Test("a roster takes on a commitment on a schedule due on no day")
func aRosterTakesOnACommitmentOnAScheduleDueOnNoDay() {
    let dueOnNoDay = Schedule.weekdays([])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: dueOnNoDay, keptFrom: keptFrom)!

    var roster = Roster()
    let added = roster.add(commitment)

    #expect(added)
    #expect(roster.commitments == [commitment])
}

@Test("a roster takes on a commitment offered under a category of nothing but blank space, under none")
func aRosterTakesOnACommitmentOfferedUnderACategoryOfNothingButBlankSpaceUnderNone() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!

    var roster = Roster()
    let added = roster.add(creatine, under: "   ")

    #expect(added)
    #expect(roster.groups == [Roster.Group(category: nil, commitments: [creatine])])
}

@Test("a superseded commitment is still under the category it was under")
func aSupersededCommitmentIsStillUnderTheCategoryItWasUnder() {
    let originalSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let newSchedule = Schedule.weekdays([.tuesday, .thursday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let newKeptFrom = CalendarDate(year: 2026, month: 9, day: 1)!
    let gym = Commitment(name: "Gym", schedule: originalSchedule, keptFrom: keptFrom)!
    let newGym = Commitment(name: "Gym", schedule: newSchedule, keptFrom: newKeptFrom)!
    let thirtyFirstOfAugust = CalendarDate(year: 2026, month: 8, day: 31)!

    var roster = Roster()
    _ = roster.add(gym, under: "Sport")
    _ = roster.supersede(gym, with: newGym, keptUntil: thirtyFirstOfAugust, under: "Morning")

    #expect(
        roster.groups(on: thirtyFirstOfAugust)
            == [
                Roster.Group(category: "Morning", commitments: [newGym]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
}

@Test(
    "a roster that had stopped keeping or removed everything it holds before a date reads back no groups on that date"
)
func aRosterThatHadStoppedKeepingOrRemovedEverythingItHoldsBeforeADateReadsBackNoGroupsOnThatDate() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gymKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let runKeptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: gymKeptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: runKeptFrom)!
    let stoppedAndRemovedOn = CalendarDate(year: 2026, month: 1, day: 31)!
    let askedAbout = CalendarDate(year: 2026, month: 2, day: 1)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(run)
    _ = roster.retire(gym, keptUntil: stoppedAndRemovedOn)
    _ = roster.remove(run, keptUntil: stoppedAndRemovedOn)

    #expect(roster.groups(on: askedAbout).isEmpty)
}

@Test("a roster answers in groups about a date before the day a commitment it holds is kept from")
func aRosterAnswersInGroupsAboutADateBeforeTheDayACommitmentItHoldsIsKeptFrom() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let beforeKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    var roster = Roster()
    _ = roster.add(journaling)

    #expect(
        roster.groups(on: beforeKeptFrom) == [Roster.Group(category: nil, commitments: [journaling])]
    )
}

@Test(
    "a group moved to the end is put after the last commitment under the last group, one the roster has stopped keeping included"
)
func aGroupMovedToTheEndIsPutAfterTheLastCommitmentUnderTheLastGroupOneTheRosterHasStoppedKeepingIncluded()
{
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let stoppedOn = CalendarDate(year: 2026, month: 1, day: 31)!

    var roster = Roster()
    _ = roster.add(creatine)
    _ = roster.put(creatine, under: "Supplements")
    _ = roster.add(gym)
    _ = roster.put(gym, under: "Sport")
    _ = roster.add(journaling)
    _ = roster.put(journaling, under: "Sport")
    _ = roster.retire(journaling, keptUntil: stoppedOn)

    let moved = roster.move(group: "Supplements", toOffset: 2)

    #expect(moved)
    #expect(roster.commitments(on: stoppedOn) == [gym, journaling, creatine])
}

@Test(
    "an offset for a group counts no category only a commitment the roster has stopped keeping is under"
)
func anOffsetForAGroupCountsNoCategoryOnlyACommitmentTheRosterHasStoppedKeepingIsUnder() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let finances = Commitment(name: "Finances", schedule: schedule, keptFrom: keptFrom)!
    let stoppedOn = CalendarDate(year: 2026, month: 1, day: 31)!

    var roster = Roster()
    _ = roster.add(creatine)
    _ = roster.put(creatine, under: "Supplements")
    _ = roster.add(gym)
    _ = roster.put(gym, under: "Sport")
    _ = roster.add(finances)
    _ = roster.put(finances, under: "Money")
    _ = roster.retire(gym, keptUntil: stoppedOn)

    let moved = roster.move(group: "Supplements", toOffset: 2)

    #expect(moved)
    #expect(
        roster.groups
            == [
                Roster.Group(category: "Money", commitments: [finances]),
                Roster.Group(category: "Supplements", commitments: [creatine]),
            ])

    let refused = roster.move(group: "Money", toOffset: 3)

    #expect(!refused)
}

@Test(
    "taking a commitment up again leaves the earliest day anything a roster holds is kept from as it was"
)
func takingACommitmentUpAgainLeavesTheEarliestDayAnythingARosterHoldsIsKeptFromAsItWas() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let earlierKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let laterKeptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: earlierKeptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: laterKeptFrom)!

    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(run)
    let firstAsk = roster.earliestKeptFrom

    _ = roster.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    let secondAsk = roster.earliestKeptFrom

    _ = roster.add(gym)
    let thirdAsk = roster.earliestKeptFrom

    #expect(firstAsk == earlierKeptFrom)
    #expect(secondAsk == earlierKeptFrom)
    #expect(thirdAsk == earlierKeptFrom)
}

@Test("a roster answers the earliest day whatever kind the commitment kept from it takes")
func aRosterAnswersTheEarliestDayWhateverKindTheCommitmentKeptFromItTakes() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let earliest = CalendarDate(year: 2026, month: 1, day: 1)!
    let later = CalendarDate(year: 2026, month: 3, day: 1)!
    let tick = Commitment(name: "Gym", schedule: schedule, keptFrom: later)!
    let note = Commitment(name: "Journal", schedule: schedule, keptFrom: earliest, kind: .note)!

    var roster = Roster()
    _ = roster.add(tick)
    _ = roster.add(note)

    #expect(roster.earliestKeptFrom == earliest)
}

@Test("a roster answers the earliest day whatever category the commitment kept from it is under")
func aRosterAnswersTheEarliestDayWhateverCategoryTheCommitmentKeptFromItIsUnder() {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let earliest = CalendarDate(year: 2026, month: 1, day: 1)!
    let later = CalendarDate(year: 2026, month: 3, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: later)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: earliest)!

    var roster = Roster()
    _ = roster.add(gym, under: nil)
    _ = roster.add(creatine, under: "Supplements")

    #expect(roster.earliestKeptFrom == earliest)
}

@Test("a commitment kept until the first supported date is accepted")
func aCommitmentKeptUntilTheFirstSupportedDateIsAccepted() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let firstSupportedDate = CalendarDate(year: 1583, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: firstSupportedDate)!

    var roster = Roster()
    _ = roster.add(gym)

    let stopped = roster.retire(gym, keptUntil: firstSupportedDate)

    #expect(stopped)
    #expect(roster.commitments(on: firstSupportedDate) == [gym])
    #expect(roster.commitments(on: CalendarDate(year: 1583, month: 1, day: 2)!).isEmpty)
}
