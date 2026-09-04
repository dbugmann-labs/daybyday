import Foundation
import Testing
import DayByDayKit

/// A fresh roster place under one fresh temporary directory — a UUID names the directory, and
/// the file sits one level under it, so the directory itself does not exist until something
/// creates it. This URL is "the same place" a screen is opened at twice.
private func freshRosterPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("roster.json")
}

@MainActor
@Test("a commitments screen lists the commitments its roster keeps, in the order they were taken on")
func aCommitmentsScreenListsTheCommitmentsItsRosterKeepsInTheOrderTheyWereTakenOn() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.map(\.name) == ["Water plants", "Gym", "Journaling"])
    #expect(screen.rosterState == .kept)
}

@MainActor
@Test("a commitments screen does not list a commitment its roster has stopped keeping")
func aCommitmentsScreenDoesNotListACommitmentItsRosterHasStoppedKeeping() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.map(\.name) == ["Journaling"])
    #expect(!screen.kept.map(\.name).contains("Gym"))
}

@MainActor
@Test("two commitments alike in name and not in rhythm are two entries a person cannot tell apart")
func twoCommitmentsAlikeInNameAndNotInRhythmAreTwoEntriesAPersonCannotTellApart() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let vitaminsMondayWednesday = Commitment(
        name: "Vitamins", schedule: .weekdays([.monday, .wednesday]), keptFrom: keptFrom)!
    let vitaminsTuesdayThursday = Commitment(
        name: "Vitamins", schedule: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(vitaminsMondayWednesday)
    try rosterStore.add(vitaminsTuesdayThursday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.map(\.name) == ["Vitamins", "Vitamins"])

    screen.askToStopKeeping(screen.kept[0])
    screen.confirmStopKeeping()

    #expect(screen.kept.map(\.name) == ["Vitamins"])
}

@MainActor
@Test("a commitments screen opened on a roster that holds nothing lists nothing and takes nothing on")
func aCommitmentsScreenOpenedOnARosterThatHoldsNothingListsNothingAndTakesNothingOn() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.isEmpty)
    #expect(screen.stopped.isEmpty)
    #expect(screen.rosterState == .kept)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a commitments screen lists what its roster has stopped keeping, in the order they were taken on")
func aCommitmentsScreenListsWhatItsRosterHasStoppedKeepingInTheOrderTheyWereTakenOn() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.retire(journaling, keptUntil: sunday)
    try rosterStore.retire(waterPlants, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.stopped.map(\.name) == ["Water plants", "Journaling"])
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitments screen whose roster has stopped nothing lists nothing as stopped")
func aCommitmentsScreenWhoseRosterHasStoppedNothingListsNothingAsStopped() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.stopped.isEmpty)
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitment a commitments screen keeps is not among what it has stopped")
func aCommitmentACommitmentsScreenKeepsIsNotAmongWhatItHasStopped() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let inBoth = Set(screen.kept).intersection(screen.stopped)
    #expect(inBoth.isEmpty)
    #expect(screen.kept.map(\.name) == ["Journaling"])
    #expect(screen.stopped.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitment defined through a commitments screen is kept at the roster place before either list says so")
func aCommitmentDefinedThroughACommitmentsScreenIsKeptAtTheRosterPlaceBeforeEitherListSaysSo() throws {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "Gym", on: .weekdays([.monday, .wednesday, .saturday]), keptFrom: monday)

    let rosterStore = try RosterStore(at: rosterPlace)
    #expect(rosterStore.roster.commitments.map(\.name) == ["Gym"])
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(refusal == nil)
}

@MainActor
@Test("a commitment defined through a commitments screen is last in what it keeps")
func aCommitmentDefinedThroughACommitmentsScreenIsLastInWhatItKeeps() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(
        name: "Journaling",
        on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: monday)

    #expect(screen.kept.map(\.name) == ["Water plants", "Gym", "Journaling"])
}

@MainActor
@Test("a commitment defined on each of the four rhythms is read back on the schedule that rhythm names")
func aCommitmentDefinedOnEachOfTheFourRhythmsIsReadBackOnTheScheduleThatRhythmNames() throws {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(
        name: "Gym", on: .weekdays([.monday, .wednesday, .saturday]), keptFrom: monday)
    _ = screen.define(
        name: "Finances", on: .dayOfMonth(DayOfMonth(day: 25)!), keptFrom: monday)
    _ = screen.define(
        name: "Contact lenses", on: .everyNDays(DayInterval(days: 14)!), keptFrom: monday)
    _ = screen.define(
        name: "Reading", on: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: monday)

    let rosterStore = try RosterStore(at: rosterPlace)
    let expected = [
        Commitment(
            name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: monday)!,
        Commitment(
            name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 25)!), keptFrom: monday)!,
        Commitment(
            name: "Contact lenses", schedule: .everyNDays(DayInterval(days: 14)!, from: monday),
            keptFrom: monday)!,
        Commitment(
            name: "Reading", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!),
            keptFrom: monday)!,
    ]
    #expect(rosterStore.roster.commitments == expected)
}

@MainActor
@Test("a commitment defined on an interval rhythm counts from the day it is kept from")
func aCommitmentDefinedOnAnIntervalRhythmCountsFromTheDayItIsKeptFrom() throws {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesdayFirstJuly = CalendarDate(year: 2026, month: 7, day: 1)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(
        name: "Contact lenses", on: .everyNDays(DayInterval(days: 14)!),
        keptFrom: wednesdayFirstJuly)

    let rosterStore = try RosterStore(at: rosterPlace)
    let commitment = rosterStore.roster.commitments[0]

    let fifteenthJuly = CalendarDate(year: 2026, month: 7, day: 15)!
    let secondJuly = CalendarDate(year: 2026, month: 7, day: 2)!
    let thirtiethJune = CalendarDate(year: 2026, month: 6, day: 30)!

    #expect(commitment.isDue(on: wednesdayFirstJuly))
    #expect(commitment.isDue(on: fifteenthJuly))
    #expect(!commitment.isDue(on: secondJuly))
    #expect(!commitment.isDue(on: thirtiethJune))
}

@MainActor
@Test("a commitments screen offers the day it was handed as the day to keep a commitment from")
func aCommitmentsScreenOffersTheDayItWasHandedAsTheDayToKeepACommitmentFrom() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.dayToKeepFrom == monday)
}

@MainActor
@Test("a commitments screen accepts a day to keep from that has not arrived and one long past")
func aCommitmentsScreenAcceptsADayToKeepFromThatHasNotArrivedAndOneLongPast() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let farFuture = CalendarDate(year: 9999, month: 12, day: 31)!
    let farPast = CalendarDate(year: 1583, month: 1, day: 1)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let gymRefusal = screen.define(name: "Gym", on: daily, keptFrom: farFuture)
    let journalingRefusal = screen.define(name: "Journaling", on: daily, keptFrom: farPast)

    #expect(gymRefusal == nil)
    #expect(journalingRefusal == nil)
    #expect(screen.kept.map(\.name) == ["Gym", "Journaling"])
}

@MainActor
@Test("a commitments screen refuses a commitment named with nothing but blank space")
func aCommitmentsScreenRefusesACommitmentNamedWithNothingButBlankSpace() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "   ", on: daily, keptFrom: monday)

    #expect(refusal == .namesNothing)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a commitments screen refuses a weekday set with no days in it")
func aCommitmentsScreenRefusesAWeekdaySetWithNoDaysInIt() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "Gym", on: .weekdays([]), keptFrom: monday)

    #expect(refusal == .dueOnNoDay)
    #expect(refusal != .namesNothing)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@Test("a weekday set with no days in it is still a schedule the rule engine accepts")
func aWeekdaySetWithNoDaysInItIsStillAScheduleTheRuleEngineAccepts() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let commitment = Commitment(name: "Gym", schedule: .weekdays([]), keptFrom: keptFrom)

    let dates = [
        CalendarDate(year: 2026, month: 1, day: 1)!,
        CalendarDate(year: 2026, month: 1, day: 2)!,
        CalendarDate(year: 2026, month: 1, day: 3)!,
        CalendarDate(year: 2026, month: 1, day: 4)!,
        CalendarDate(year: 2026, month: 1, day: 5)!,
        CalendarDate(year: 2026, month: 1, day: 6)!,
        CalendarDate(year: 2026, month: 1, day: 7)!,
        CalendarDate(year: 2026, month: 1, day: 8)!,
    ]

    #expect(commitment != nil)
    for date in dates {
        #expect(commitment?.isDue(on: date) == false)
    }
}

@MainActor
@Test("a commitments screen refuses nothing else about a name")
func aCommitmentsScreenRefusesNothingElseAboutAName() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let xRefusal = screen.define(name: "x", on: daily, keptFrom: monday)
    let gymRefusal = screen.define(name: " Gym ", on: daily, keptFrom: monday)
    let emojiRefusal = screen.define(name: "Gym 🏋️", on: daily, keptFrom: monday)

    #expect(xRefusal == nil)
    #expect(gymRefusal == nil)
    #expect(emojiRefusal == nil)
    #expect(screen.kept.map(\.name) == ["x", " Gym ", "Gym 🏋️"])
}

@MainActor
@Test("a commitments screen refuses a commitment its roster is already keeping")
func aCommitmentsScreenRefusesACommitmentItsRosterIsAlreadyKeeping() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesAfterOpen = try Data(contentsOf: rosterPlace)

    let refusal = screen.define(
        name: "Gym", on: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)

    #expect(refusal == .alreadyKept)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpen)
}

@MainActor
@Test("a commitments screen that could not keep a new commitment says the roster could not be written")
func aCommitmentsScreenThatCouldNotKeepANewCommitmentSaysTheRosterCouldNotBeWritten() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    let rosterPlace = blocker.appendingPathComponent("roster.json")
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "Gym", on: daily, keptFrom: monday)

    #expect(refusal == .notKept)
    #expect(refusal != .alreadyKept)
    #expect(screen.kept.isEmpty)
}

@MainActor
@Test("defining a commitment a commitments screen has stopped keeping takes it up again in the place it was taken on in")
func definingACommitmentACommitmentsScreenHasStoppedKeepingTakesItUpAgainInThePlaceItWasTakenOnIn()
    throws
{
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "Gym", on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
        keptFrom: keptFrom)

    #expect(refusal == nil)
    #expect(screen.kept.map(\.name) == ["Water plants", "Gym", "Journaling"])
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a commitment a commitments screen refuses as already kept is not taken on a second time")
func aCommitmentACommitmentsScreenRefusesAsAlreadyKeptIsNotTakenOnASecondTime() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let firstRefusal = screen.define(
        name: "Gym",
        on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
        keptFrom: keptFrom)
    let secondRefusal = screen.define(
        name: "Gym",
        on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
        keptFrom: keptFrom)

    #expect(firstRefusal == .alreadyKept)
    #expect(secondRefusal == .alreadyKept)

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments.count == 1)
}

@MainActor
@Test("asking a commitments screen to stop keeping a commitment changes nothing until it is confirmed")
func askingACommitmentsScreenToStopKeepingACommitmentChangesNothingUntilItIsConfirmed() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesAfterOpen = try Data(contentsOf: rosterPlace)

    screen.askToStopKeeping(gym)

    #expect(screen.awaitingConfirmation == gym)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpen)
}

@MainActor
@Test("a stop a commitments screen has been asked for and then cancelled changes nothing")
func aStopACommitmentsScreenHasBeenAskedForAndThenCancelledChangesNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesAfterOpen = try Data(contentsOf: rosterPlace)

    screen.askToStopKeeping(gym)
    screen.cancelStopKeeping()

    #expect(screen.awaitingConfirmation == nil)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpen)
}

@MainActor
@Test("a commitments screen asked to stop a second commitment awaits confirmation of that one only")
func aCommitmentsScreenAskedToStopASecondCommitmentAwaitsConfirmationOfThatOneOnly() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    screen.askToStopKeeping(gym)
    screen.askToStopKeeping(journaling)
    screen.confirmStopKeeping()

    #expect(screen.stopped.map(\.name) == ["Journaling"])
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitment stopped through a commitments screen is kept until the day the screen was handed")
func aCommitmentStoppedThroughACommitmentsScreenIsKeptUntilTheDayTheScreenWasHanded() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    screen.askToStopKeeping(gym)
    screen.confirmStopKeeping()

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments(on: monday).map(\.name) == ["Gym"])
    #expect(laterStore.roster.commitments(on: tuesday).isEmpty)
}

@MainActor
@Test("a commitment stopped through a commitments screen moves from what it keeps to what it has stopped")
func aCommitmentStoppedThroughACommitmentsScreenMovesFromWhatItKeepsToWhatItHasStopped() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    screen.askToStopKeeping(gym)
    screen.confirmStopKeeping()

    #expect(screen.kept.map(\.name) == ["Water plants", "Journaling"])
    #expect(screen.stopped.map(\.name) == ["Gym"])
    #expect(screen.awaitingConfirmation == nil)
}

@MainActor
@Test("a commitments screen asked to stop keeping a commitment it does not keep does nothing")
func aCommitmentsScreenAskedToStopKeepingACommitmentItDoesNotKeepDoesNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    screen.askToStopKeeping(gym)
    let refusal = screen.confirmStopKeeping()

    #expect(refusal == nil)
    #expect(screen.awaitingConfirmation == nil)
    #expect(screen.stopped.map(\.name) == ["Gym"])

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments(on: sunday).map(\.name) == ["Gym"])
    #expect(laterStore.roster.commitments(on: monday).isEmpty)
}

@MainActor
@Test("a stop a commitments screen could not keep leaves both its lists as they were")
func aStopACommitmentsScreenCouldNotKeepLeavesBothItsListsAsTheyWere() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    screen.askToStopKeeping(gym)
    let refusal = screen.confirmStopKeeping()

    #expect(refusal == .notKept)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
}
