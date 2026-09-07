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
@Test("an entry says the rhythm its commitment runs on, whichever of the four shapes it is")
func anEntrySaysTheRhythmItsCommitmentRunsOnWhicheverOfTheFourShapesItIs() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let finances = Commitment(
        name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 25)!), keptFrom: keptFrom)!
    let contactLenses = Commitment(
        name: "Contact lenses",
        schedule: .everyNDays(DayInterval(days: 14)!, from: keptFrom), keptFrom: keptFrom)!
    let reading = Commitment(
        name: "Reading", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(finances)
    try rosterStore.add(contactLenses)
    try rosterStore.add(reading)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.map(\.name) == ["Gym", "Finances", "Contact lenses", "Reading"])
    #expect(screen.kept.map(\.rhythmInWords) == [
        "Mon, Wed, Sat", "The 25th", "Every 14 days", "3x a week",
    ])
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
@Test("two commitments alike in name and not in rhythm are told apart by the rhythm their entries say")
func twoCommitmentsAlikeInNameAndNotInRhythmAreToldApartByTheRhythmTheirEntriesSay() throws {
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
    #expect(screen.kept.map(\.rhythmInWords) == ["Mon, Wed", "Tue, Thu"])

    screen.askToStopKeeping(screen.kept[0])
    screen.confirmStopKeeping()

    #expect(screen.kept.map(\.name) == ["Vitamins"])
    #expect(screen.kept.map(\.rhythmInWords) == ["Tue, Thu"])
}

@MainActor
@Test("two commitments alike in name and in rhythm are two entries that say the same thing")
func twoCommitmentsAlikeInNameAndInRhythmAreTwoEntriesThatSayTheSameThing() throws {
    let rosterPlace = freshRosterPlace()
    let januaryFirst = CalendarDate(year: 2026, month: 1, day: 1)!
    let juneFirst = CalendarDate(year: 2026, month: 6, day: 1)!
    let vitaminsFromJanuary = Commitment(
        name: "Vitamins", schedule: .weekdays([.monday, .wednesday]), keptFrom: januaryFirst)!
    let vitaminsFromJune = Commitment(
        name: "Vitamins", schedule: .weekdays([.monday, .wednesday]), keptFrom: juneFirst)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(vitaminsFromJanuary)
    try rosterStore.add(vitaminsFromJune)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.map(\.name) == ["Vitamins", "Vitamins"])
    #expect(screen.kept.map(\.rhythmInWords) == ["Mon, Wed", "Mon, Wed"])
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
@Test("a stopped entry says the rhythm its commitment runs on, as a kept entry does")
func aStoppedEntrySaysTheRhythmItsCommitmentRunsOnAsAKeptEntryDoes() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let vitaminsMondayWednesday = Commitment(
        name: "Vitamins", schedule: .weekdays([.monday, .wednesday]), keptFrom: keptFrom)!
    let vitaminsThreeAWeek = Commitment(
        name: "Vitamins", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(vitaminsMondayWednesday)
    try rosterStore.add(vitaminsThreeAWeek)
    try rosterStore.retire(vitaminsMondayWednesday, keptUntil: sunday)
    try rosterStore.retire(vitaminsThreeAWeek, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.stopped.map(\.name) == ["Vitamins", "Vitamins"])
    #expect(screen.stopped.map(\.rhythmInWords) == ["Mon, Wed", "3x a week"])
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
        name: "Finances", on: .dayOfMonth(25), keptFrom: monday)
    _ = screen.define(
        name: "Contact lenses", on: .everyNDays(14), keptFrom: monday)
    _ = screen.define(
        name: "Reading", on: .weeklyQuota(3), keptFrom: monday)

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
        name: "Contact lenses", on: .everyNDays(14),
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
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    screen.askToStopKeeping(gym)
    screen.confirmStopKeeping()

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments(on: sunday).map(\.name) == ["Gym"])
    #expect(laterStore.roster.commitments(on: monday).isEmpty)
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
    #expect(screen.awaitingConfirmation == nil)
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

@MainActor
@Test("a commitment taken up again through a commitments screen moves from what it has stopped to what it keeps")
func aCommitmentTakenUpAgainThroughACommitmentsScreenMovesFromWhatItHasStoppedToWhatItKeeps() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    screen.keepAgain(gym)

    #expect(screen.kept.map(\.name) == ["Gym", "Journaling"])
    #expect(screen.stopped.isEmpty)

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments(on: tuesday).map(\.name).contains("Gym"))
}

@MainActor
@Test("a commitment taken up again through a commitments screen is in the place it was taken on in")
func aCommitmentTakenUpAgainThroughACommitmentsScreenIsInThePlaceItWasTakenOnIn() throws {
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
    try rosterStore.retire(waterPlants, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    screen.keepAgain(waterPlants)

    #expect(screen.kept.map(\.name) == ["Water plants", "Gym", "Journaling"])
}

@MainActor
@Test("taking a commitment up again through a commitments screen asks for no confirmation")
func takingACommitmentUpAgainThroughACommitmentsScreenAsksForNoConfirmation() throws {
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

    #expect(screen.awaitingConfirmation == nil)
    screen.keepAgain(gym)
    #expect(screen.awaitingConfirmation == nil)

    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitments screen asked to take up again a commitment it has not stopped does nothing")
func aCommitmentsScreenAskedToTakeUpAgainACommitmentItHasNotStoppedDoesNothing() throws {
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

    let refusal = screen.keepAgain(gym)

    #expect(refusal == nil)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpen)
}

/// Not a delta scenario — a unit test below the seam, added at G7 review because the scenario
/// above cannot tell `keepAgain`'s own guard apart from `RosterStore.add`'s: "Gym" there is
/// already kept, so `add` would refuse it as a duplicate whether or not the guard exists. A
/// commitment the roster has never held at all is refused only by the guard, so this is the input
/// that actually exercises it — without it, `keepAgain` would reach `rosterStore.add` and take on
/// a commitment nobody asked for.
@MainActor
@Test("a commitments screen asked to take up again a commitment it has never held does nothing")
func aCommitmentsScreenAskedToTakeUpAgainACommitmentItHasNeverHeldDoesNothing() throws {
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

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesAfterOpen = try Data(contentsOf: rosterPlace)

    let refusal = screen.keepAgain(journaling)

    #expect(refusal == nil)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpen)
}

@MainActor
@Test("a commitments screen refuses a day of the month that is not one of the thirty-one")
func aCommitmentsScreenRefusesADayOfTheMonthThatIsNotOneOfTheThirtyOne() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let zerothRefusal = screen.define(name: "Finances", on: .dayOfMonth(0), keptFrom: monday)
    let thirtySecondRefusal = screen.define(name: "Finances", on: .dayOfMonth(32), keptFrom: monday)

    #expect(zerothRefusal == .rhythmOutOfRange)
    #expect(thirtySecondRefusal == .rhythmOutOfRange)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a commitments screen refuses an interval of fewer than one day")
func aCommitmentsScreenRefusesAnIntervalOfFewerThanOneDay() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let zeroRefusal = screen.define(name: "Contact lenses", on: .everyNDays(0), keptFrom: monday)
    let negativeRefusal = screen.define(name: "Contact lenses", on: .everyNDays(-7), keptFrom: monday)

    #expect(zeroRefusal == .rhythmOutOfRange)
    #expect(negativeRefusal == .rhythmOutOfRange)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a commitments screen refuses a weekly quota outside one to seven")
func aCommitmentsScreenRefusesAWeeklyQuotaOutsideOneToSeven() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let zeroRefusal = screen.define(name: "Reading", on: .weeklyQuota(0), keptFrom: monday)
    let eightRefusal = screen.define(name: "Reading", on: .weeklyQuota(8), keptFrom: monday)

    #expect(zeroRefusal == .rhythmOutOfRange)
    #expect(eightRefusal == .rhythmOutOfRange)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a rhythm number a commitments screen refuses is told apart from its other refusals")
func aRhythmNumberACommitmentsScreenRefusesIsToldApartFromItsOtherRefusals() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Set<Weekday> = [
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ]

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let financesRefusal = screen.define(name: "Finances", on: .dayOfMonth(32), keptFrom: monday)
    let blankRefusal = screen.define(name: "   ", on: .weekdays(allWeekdays), keptFrom: monday)
    let gymRefusal = screen.define(name: "Gym", on: .weekdays([]), keptFrom: monday)

    #expect(financesRefusal == .rhythmOutOfRange)
    #expect(blankRefusal == .namesNothing)
    #expect(gymRefusal == .dueOnNoDay)
    #expect(financesRefusal != blankRefusal)
    #expect(financesRefusal != gymRefusal)
    #expect(blankRefusal != gymRefusal)
}

@MainActor
@Test("a commitments screen accepts the number at each end of what a rhythm allows")
func aCommitmentsScreenAcceptsTheNumberAtEachEndOfWhatARhythmAllows() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let rentRefusal = screen.define(name: "Rent", on: .dayOfMonth(1), keptFrom: monday)
    let financesRefusal = screen.define(name: "Finances", on: .dayOfMonth(31), keptFrom: monday)
    let shaveRefusal = screen.define(name: "Shave", on: .everyNDays(1), keptFrom: monday)
    let longRunRefusal = screen.define(name: "Long run", on: .weeklyQuota(1), keptFrom: monday)
    let stepsRefusal = screen.define(name: "Steps", on: .weeklyQuota(7), keptFrom: monday)

    #expect(rentRefusal == nil)
    #expect(financesRefusal == nil)
    #expect(shaveRefusal == nil)
    #expect(longRunRefusal == nil)
    #expect(stepsRefusal == nil)
    #expect(screen.kept.map(\.name) == ["Rent", "Finances", "Shave", "Long run", "Steps"])
}

@MainActor
@Test("a commitments screen keeps its roster at the place a day screen keeps its")
func aCommitmentsScreenKeepsItsRosterAtThePlaceADayScreenKeepsIts() {
    #expect(CommitmentsScreen.rosterPlace == DayScreen.rosterPlace)
}

@MainActor
@Test("a commitment defined through a commitments screen is held by a day screen opened afterwards at the same place")
func aCommitmentDefinedThroughACommitmentsScreenIsHeldByADayScreenOpenedAfterwardsAtTheSamePlace() throws {
    let rosterPlace = freshRosterPlace()
    let recordPlace = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("record.json")
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.define(name: "Journaling", on: daily, keptFrom: monday)

    #expect(refusal == nil)

    let dayScreen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: recordPlace, keepingRosterAt: rosterPlace)

    #expect(dayScreen.dayView.rows.map(\.name) == ["Journaling"])
}

@MainActor
@Test("a commitments screen shown again reads its roster again")
func aCommitmentsScreenShownAgainReadsItsRosterAgain() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.isEmpty)

    let other = try RosterStore(at: rosterPlace)
    try other.add(gym)

    screen.shown(asOf: monday)

    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitments screen shown again on a later day stops a commitment as of that later day")
func aCommitmentsScreenShownAgainOnALaterDayStopsACommitmentAsOfThatLaterDay() throws {
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

    screen.shown(asOf: tuesday)

    screen.askToStopKeeping(gym)
    screen.confirmStopKeeping()

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments(on: monday).map(\.name) == ["Gym"])
    #expect(screen.dayToKeepFrom == tuesday)
}

@MainActor
@Test("a commitments screen that cannot read its roster lists nothing and says it is not keeping one")
func aCommitmentsScreenThatCannotReadItsRosterListsNothingAndSaysItIsNotKeepingOne() throws {
    let rosterPlace = freshRosterPlace()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a roster is written as".utf8).write(to: rosterPlace)
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.isEmpty)
    #expect(screen.stopped.isEmpty)
    #expect(screen.rosterState == .notKept)
}

@MainActor
@Test("a roster written in a later form than this app knows makes a commitments screen that says the roster is from a later version")
func aRosterWrittenInALaterFormThanThisAppKnowsMakesACommitmentsScreenThatSaysTheRosterIsFromALaterVersion()
    throws
{
    let rosterPlace = freshRosterPlace()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"version": 4, "commitments": []}"#.utf8).write(to: rosterPlace)
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.rosterState == .writtenByALaterVersion)
    #expect(screen.rosterState != .notKept)
    #expect(screen.kept.isEmpty)
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a commitments screen that cannot read its roster refuses a new commitment and leaves what is at the place as it was")
func aCommitmentsScreenThatCannotReadItsRosterRefusesANewCommitmentAndLeavesWhatIsAtThePlaceAsItWas()
    throws
{
    let rosterPlace = freshRosterPlace()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let originalBytes = Data("not what a roster is written as".utf8)
    try originalBytes.write(to: rosterPlace)
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: .weekdays([.monday]), keptFrom: monday)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "Gym", on: daily, keptFrom: monday)
    #expect(refusal == .notKept)

    screen.askToStopKeeping(journaling)
    let stopRefusal = screen.confirmStopKeeping()

    #expect(stopRefusal == nil)
    #expect(screen.awaitingConfirmation == nil)
    #expect(try Data(contentsOf: rosterPlace) == originalBytes)
}

@MainActor
@Test("a commitments screen that could not read its roster starts keeping one when it is shown again and the roster can be read")
func aCommitmentsScreenThatCouldNotReadItsRosterStartsKeepingOneWhenItIsShownAgainAndTheRosterCanBeRead()
    throws
{
    let rosterPlace = freshRosterPlace()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a roster is written as".utf8).write(to: rosterPlace)
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: rosterPlace)
    let recovered = try RosterStore(at: rosterPlace)
    try recovered.add(gym)

    screen.shown(asOf: monday)

    #expect(screen.rosterState == .kept)
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitments screen holds a refused definition against defining a commitment")
func aCommitmentsScreenHoldsARefusedDefinitionAgainstDefiningACommitment() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "   ", on: allWeekdays, keptFrom: monday)

    #expect(refusal == .namesNothing)
    #expect(screen.refusedChange == .defining(.namesNothing))
}

@MainActor
@Test("a commitments screen holds a refused stop against the commitment it was asked to stop")
func aCommitmentsScreenHoldsARefusedStopAgainstTheCommitmentItWasAskedToStop() throws {
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
    #expect(screen.refusedChange == .stopping(gym, .notKept))
}

@MainActor
@Test(
    "a commitments screen holds a refused take-up-again against the commitment it was asked to take up again"
)
func aCommitmentsScreenHoldsARefusedTakeUpAgainAgainstTheCommitmentItWasAskedToTakeUpAgain() throws {
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

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    let refusal = screen.keepAgain(gym)

    #expect(refusal == .notKept)
    #expect(screen.refusedChange == .keepingAgain(gym, .notKept))
}

@MainActor
@Test("a commitments screen refused twice holds only the change it was asked for last")
func aCommitmentsScreenRefusedTwiceHoldsOnlyTheChangeItWasAskedForLast() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday)

    screen.askToStopKeeping(gym)
    let stopRefusal = screen.confirmStopKeeping()

    #expect(stopRefusal == .notKept)
    #expect(screen.refusedChange == .stopping(gym, .notKept))
    #expect(screen.refusedChange != .defining(.namesNothing))
}

@MainActor
@Test("a commitments screen that has been asked for no change holds no refused change")
func aCommitmentsScreenThatHasBeenAskedForNoChangeHoldsNoRefusedChange() throws {
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

    #expect(screen.refusedChange == nil)
}

@MainActor
@Test("a commitments screen holds nothing against a call that changes nothing at all")
func aCommitmentsScreenHoldsNothingAgainstACallThatChangesNothingAtAll() throws {
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

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    screen.askToStopKeeping(journaling)
    let stopRefusal = screen.confirmStopKeeping()
    let keepAgainRefusal = screen.keepAgain(gym)

    #expect(stopRefusal == nil)
    #expect(keepAgainRefusal == nil)
    #expect(screen.refusedChange == nil)
}

@MainActor
@Test("what a commitments screen holds about a refused change ends when the app is shown again")
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenTheAppIsShownAgain() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday)
    #expect(screen.refusedChange != nil)

    screen.shown(asOf: monday)

    #expect(screen.refusedChange == nil)
    #expect(screen.rosterState == .kept)
}

@MainActor
@Test(
    "what a commitments screen holds about a refused change ends when the app is shown again where the roster then cannot be read"
)
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenTheAppIsShownAgainWhereTheRosterThenCannotBeRead()
    throws
{
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
    let stopRefusal = screen.confirmStopKeeping()
    #expect(stopRefusal == .notKept)
    #expect(screen.refusedChange != nil)

    screen.shown(asOf: monday)

    #expect(screen.refusedChange == nil)
    #expect(screen.rosterState == .notKept)
}

@MainActor
@Test("what a commitments screen holds about a refused change ends when a commitment is defined and kept")
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenACommitmentIsDefinedAndKept() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday)
    #expect(screen.refusedChange != nil)

    let journalingRefusal = screen.define(name: "Journaling", on: allWeekdays, keptFrom: monday)

    #expect(journalingRefusal == nil)
    #expect(screen.refusedChange == nil)
}

@MainActor
@Test("what a commitments screen holds about a refused change ends when a stop is kept")
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenAStopIsKept() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday)
    #expect(screen.refusedChange != nil)

    screen.askToStopKeeping(gym)
    let stopRefusal = screen.confirmStopKeeping()

    #expect(stopRefusal == nil)
    #expect(screen.refusedChange == nil)
}

@MainActor
@Test(
    "what a commitments screen holds about a refused change ends when a commitment is taken up again and kept"
)
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenACommitmentIsTakenUpAgainAndKept() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday)
    #expect(screen.refusedChange != nil)

    let keepAgainRefusal = screen.keepAgain(gym)

    #expect(keepAgainRefusal == nil)
    #expect(screen.refusedChange == nil)
}

@MainActor
@Test("what a commitments screen holds about a refused change stands when a call changes nothing at all")
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenACallChangesNothingAtAll() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday)

    let secondKeepAgainRefusal = screen.keepAgain(gym)
    let secondStopRefusal = screen.confirmStopKeeping()

    #expect(secondKeepAgainRefusal == nil)
    #expect(secondStopRefusal == nil)
    #expect(screen.refusedChange == .defining(.namesNothing))
}

@MainActor
@Test("what a commitments screen holds about a refused change stands when a stop is asked for and cancelled")
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenAStopIsAskedForAndCancelled() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday)

    screen.askToStopKeeping(gym)
    screen.cancelStopKeeping()

    #expect(screen.refusedChange == .defining(.namesNothing))
    #expect(screen.awaitingConfirmation == nil)
}

@Test("a rhythm being built is said in the words the schedule it names says")
func aRhythmBeingBuiltIsSaidInTheWordsTheScheduleItNamesSays() {
    let weekdayRhythm: Rhythm = .weekdays([.monday, .wednesday, .saturday])
    let dayOfMonthRhythm: Rhythm = .dayOfMonth(25)
    let intervalRhythm: Rhythm = .everyNDays(14)
    let weeklyQuotaRhythm: Rhythm = .weeklyQuota(3)

    #expect(weekdayRhythm.inWords == "Mon, Wed, Sat")
    #expect(dayOfMonthRhythm.inWords == "The 25th")
    #expect(intervalRhythm.inWords == "Every 14 days")
    #expect(weeklyQuotaRhythm.inWords == "3x a week")
}

@Test("an interval rhythm is said without a day to keep the commitment from")
func anIntervalRhythmIsSaidWithoutADayToKeepTheCommitmentFrom() {
    let rhythm: Rhythm = .everyNDays(14)
    let januaryFirst = CalendarDate(year: 2026, month: 1, day: 1)!
    let augustThirtyFirst = CalendarDate(year: 2026, month: 8, day: 31)!
    let scheduleFromJanuary = Schedule.everyNDays(DayInterval(days: 14)!, from: januaryFirst)
    let scheduleFromAugust = Schedule.everyNDays(DayInterval(days: 14)!, from: augustThirtyFirst)

    #expect(rhythm.inWords == "Every 14 days")
    #expect(rhythm.inWords == scheduleFromJanuary.inWords)
    #expect(rhythm.inWords == scheduleFromAugust.inWords)
}

@Test("a weekday-set rhythm with no days in it is said as no day")
func aWeekdaySetRhythmWithNoDaysInItIsSaidAsNoDay() {
    let rhythm: Rhythm = .weekdays([])

    #expect(rhythm.inWords == "No day")
}

@Test("a rhythm carrying a number the calendar will not take is said as nothing")
func aRhythmCarryingANumberTheCalendarWillNotTakeIsSaidAsNothing() {
    let thirtySecond: Rhythm = .dayOfMonth(32)
    let zeroth: Rhythm = .dayOfMonth(0)
    let noInterval: Rhythm = .everyNDays(0)
    let eightAWeek: Rhythm = .weeklyQuota(8)

    #expect(thirtySecond.inWords == nil)
    #expect(zeroth.inWords == nil)
    #expect(noInterval.inWords == nil)
    #expect(eightAWeek.inWords == nil)
    #expect(thirtySecond.inWords != "The 31st")
    #expect(noInterval.inWords != "Every 1 day")
    #expect(eightAWeek.inWords != "7x a week")
}

@Test("a rhythm carrying the number at each end of what it allows is said in words")
func aRhythmCarryingTheNumberAtEachEndOfWhatItAllowsIsSaidInWords() {
    let firstOfMonth: Rhythm = .dayOfMonth(1)
    let thirtyFirst: Rhythm = .dayOfMonth(31)
    let oneDayInterval: Rhythm = .everyNDays(1)
    let onceAWeek: Rhythm = .weeklyQuota(1)
    let sevenAWeek: Rhythm = .weeklyQuota(7)

    #expect(firstOfMonth.inWords == "The 1st")
    #expect(thirtyFirst.inWords == "The 31st")
    #expect(oneDayInterval.inWords == "Every day")
    #expect(onceAWeek.inWords == "1x a week")
    #expect(sevenAWeek.inWords == "7x a week")
}

@MainActor
@Test("a commitment defined and stopped on one day through a commitments screen is kept on no day at all")
func aCommitmentDefinedAndStoppedOnOneDayThroughACommitmentsScreenIsKeptOnNoDayAtAll() throws {
    let rosterPlace = freshRosterPlace()
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "Gym", on: allWeekdays, keptFrom: monday)
    #expect(refusal == nil)
    let gym = try #require(screen.kept.first)

    screen.askToStopKeeping(gym)
    screen.confirmStopKeeping()

    #expect(screen.kept.isEmpty)
    #expect(screen.stopped.map(\.name) == ["Gym"])

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments(on: monday).isEmpty)
    #expect(laterStore.roster.commitments(on: sunday).map(\.name) == ["Gym"])
    #expect(!gym.isDue(on: sunday))
}

@MainActor
@Test("a commitments screen handed the first supported date stops a commitment as of that day")
func aCommitmentsScreenHandedTheFirstSupportedDateStopsACommitmentAsOfThatDay() throws {
    let rosterPlace = freshRosterPlace()
    let firstSupported = CalendarDate(year: 1583, month: 1, day: 1)!
    let secondSupported = CalendarDate(year: 1583, month: 1, day: 2)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: firstSupported)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: firstSupported, keepingRosterAt: rosterPlace)

    screen.askToStopKeeping(gym)
    let refusal = screen.confirmStopKeeping()

    #expect(refusal == nil)
    #expect(screen.stopped.map(\.name) == ["Gym"])

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments(on: firstSupported).map(\.name) == ["Gym"])
    #expect(laterStore.roster.commitments(on: secondSupported).isEmpty)
}

@MainActor
@Test("asking a commitments screen to remove a commitment changes nothing until it is confirmed")
func askingACommitmentsScreenToRemoveACommitmentChangesNothingUntilItIsConfirmed() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    let bytesAfterOpening = try Data(contentsOf: rosterPlace)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    screen.askToRemove(gym)

    #expect(screen.awaitingRemoval == gym)
    #expect(screen.nameTypedBack == "")
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpening)
}

@MainActor
@Test("a commitments screen says a name typed back matches only when it is the commitment's name")
func aCommitmentsScreenSaysANameTypedBackMatchesOnlyWhenItIsTheCommitmentsName() throws {
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
    screen.askToRemove(gym)

    screen.nameTypedBack = "G"
    #expect(!screen.nameTypedBackMatches)
    screen.nameTypedBack = "Gy"
    #expect(!screen.nameTypedBackMatches)
    screen.nameTypedBack = "Gym"
    #expect(screen.nameTypedBackMatches)
    screen.nameTypedBack = "Gymm"
    #expect(!screen.nameTypedBackMatches)
}

@MainActor
@Test("a name typed back with blank space at either end matches, and one differing in case does not")
func aNameTypedBackWithBlankSpaceAtEitherEndMatchesAndOneDifferingInCaseDoesNot() throws {
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
    screen.askToRemove(gym)

    screen.nameTypedBack = "  Gym  "
    #expect(screen.nameTypedBackMatches)
    screen.nameTypedBack = "gym"
    #expect(!screen.nameTypedBackMatches)
    screen.nameTypedBack = "GYM"
    #expect(!screen.nameTypedBackMatches)
}

@MainActor
@Test("a name typed back differing in blank space inside the name does not match")
func aNameTypedBackDifferingInBlankSpaceInsideTheNameDoesNotMatch() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(waterPlants)

    screen.nameTypedBack = "Water  plants"
    #expect(!screen.nameTypedBackMatches)
    screen.nameTypedBack = "Waterplants"
    #expect(!screen.nameTypedBackMatches)
    screen.nameTypedBack = "Water plants"
    #expect(screen.nameTypedBackMatches)
}

@MainActor
@Test("a commitment whose name ends in a space is removed by typing the name without it")
func aCommitmentWhoseNameEndsInASpaceIsRemovedByTypingTheNameWithoutIt() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gymWithTrailingSpace = Commitment(name: "Gym ", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gymWithTrailingSpace)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gymWithTrailingSpace)
    screen.nameTypedBack = "Gym"

    #expect(screen.nameTypedBackMatches)

    let refusal = screen.confirmRemoving()

    #expect(refusal == nil)
    #expect(screen.kept.isEmpty)
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a commitment whose name ends in a newline is removed by typing the name without it")
func aCommitmentWhoseNameEndsInANewlineIsRemovedByTypingTheNameWithoutIt() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gymWithTrailingNewline = Commitment(name: "Gym\n", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gymWithTrailingNewline)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gymWithTrailingNewline)
    screen.nameTypedBack = "Gym"

    #expect(screen.nameTypedBackMatches)

    let refusal = screen.confirmRemoving()

    #expect(refusal == nil)
    #expect(screen.kept.isEmpty)
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a removal confirmed on a name that does not match changes nothing and refuses nothing")
func aRemovalConfirmedOnANameThatDoesNotMatchChangesNothingAndRefusesNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    let bytesAfterOpening = try Data(contentsOf: rosterPlace)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gym)
    screen.nameTypedBack = "gym"

    let refusal = screen.confirmRemoving()

    #expect(refusal == nil)
    #expect(screen.awaitingRemoval == gym)
    #expect(screen.nameTypedBack == "gym")
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpening)
}

@MainActor
@Test("a removal confirmed with nothing awaiting removal changes nothing")
func aRemovalConfirmedWithNothingAwaitingRemovalChangesNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    let bytesAfterOpening = try Data(contentsOf: rosterPlace)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.confirmRemoving()

    #expect(refusal == nil)
    #expect(screen.awaitingRemoval == nil)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpening)
}

@MainActor
@Test("a kept commitment removed through a commitments screen is kept until the day before the one the screen was handed")
func aKeptCommitmentRemovedThroughACommitmentsScreenIsKeptUntilTheDayBeforeTheOneTheScreenWasHanded()
    throws
{
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"
    screen.confirmRemoving()

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments(on: sunday).map(\.name) == ["Gym"])
    #expect(laterStore.roster.commitments(on: monday).isEmpty)
    #expect(laterStore.roster.commitments(on: tuesday).isEmpty)
}

@MainActor
@Test("a stopped commitment removed through a commitments screen keeps the day it was already kept until")
func aStoppedCommitmentRemovedThroughACommitmentsScreenKeepsTheDayItWasAlreadyKeptUntil() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let stoppedAt = CalendarDate(year: 2026, month: 8, day: 23)!
    let dayAfterStopped = CalendarDate(year: 2026, month: 8, day: 24)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.retire(gym, keptUntil: stoppedAt)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"
    screen.confirmRemoving()

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments(on: stoppedAt).map(\.name) == ["Gym"])
    #expect(laterStore.roster.commitments(on: dayAfterStopped).isEmpty)
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a commitment removed through a commitments screen is in neither of its lists")
func aCommitmentRemovedThroughACommitmentsScreenIsInNeitherOfItsLists() throws {
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
    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"
    screen.confirmRemoving()

    #expect(screen.kept.map(\.name) == ["Water plants", "Journaling"])
    #expect(screen.stopped.isEmpty)
    #expect(screen.awaitingRemoval == nil)
    #expect(screen.nameTypedBack == "")
}

@MainActor
@Test("a removal a commitments screen has been asked for and then cancelled changes nothing")
func aRemovalACommitmentsScreenHasBeenAskedForAndThenCancelledChangesNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    let bytesAfterOpening = try Data(contentsOf: rosterPlace)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"

    screen.cancelRemoving()

    #expect(screen.awaitingRemoval == nil)
    #expect(screen.nameTypedBack == "")
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpening)
}

@MainActor
@Test("a commitments screen asked to remove a second commitment awaits removal of that one only")
func aCommitmentsScreenAskedToRemoveASecondCommitmentAwaitsRemovalOfThatOneOnly() throws {
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
    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"

    screen.askToRemove(journaling)

    #expect(screen.awaitingRemoval == journaling)
    #expect(screen.nameTypedBack == "")

    let refusal = screen.confirmRemoving()
    #expect(refusal == nil)
    #expect(screen.awaitingRemoval == journaling)
    #expect(screen.kept.map(\.name) == ["Gym", "Journaling"])
}

@MainActor
@Test("a commitments screen asked to remove a commitment on neither of its lists does nothing")
func aCommitmentsScreenAskedToRemoveACommitmentOnNeitherOfItsListsDoesNothing() throws {
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

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(journaling)

    #expect(screen.awaitingRemoval == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a removal a commitments screen could not keep leaves both its lists as they were")
func aRemovalACommitmentsScreenCouldNotKeepLeavesBothItsListsAsTheyWere() throws {
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
    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    let refusal = screen.confirmRemoving()

    #expect(refusal == .notKept)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("asking a commitments screen to remove a commitment leaves no stop awaiting confirmation")
func askingACommitmentsScreenToRemoveACommitmentLeavesNoStopAwaitingConfirmation() throws {
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
    screen.askToStopKeeping(gym)

    screen.askToRemove(gym)

    #expect(screen.awaitingConfirmation == nil)
    #expect(screen.awaitingRemoval == gym)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("asking a commitments screen to stop keeping a commitment leaves nothing awaiting removal")
func askingACommitmentsScreenToStopKeepingACommitmentLeavesNothingAwaitingRemoval() throws {
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
    screen.askToRemove(gym)

    screen.askToStopKeeping(gym)

    #expect(screen.awaitingRemoval == nil)
    #expect(screen.awaitingConfirmation == gym)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a commitments screen shown again leaves nothing awaiting removal and nothing typed back")
func aCommitmentsScreenShownAgainLeavesNothingAwaitingRemovalAndNothingTypedBack() throws {
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
    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"

    screen.shown(asOf: tuesday)

    #expect(screen.awaitingRemoval == nil)
    #expect(screen.nameTypedBack == "")
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitments screen handed the first supported date removes a kept commitment as of that day")
func aCommitmentsScreenHandedTheFirstSupportedDateRemovesAKeptCommitmentAsOfThatDay() throws {
    let rosterPlace = freshRosterPlace()
    let firstSupported = CalendarDate(year: 1583, month: 1, day: 1)!
    let secondSupported = CalendarDate(year: 1583, month: 1, day: 2)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: firstSupported)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: firstSupported, keepingRosterAt: rosterPlace)
    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"
    let refusal = screen.confirmRemoving()

    #expect(refusal == nil)
    #expect(!screen.kept.contains(gym))
    #expect(!screen.stopped.contains(gym))

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments(on: firstSupported).map(\.name) == ["Gym"])
    #expect(laterStore.roster.commitments(on: secondSupported).isEmpty)
}

@MainActor
@Test("a commitments screen lists a commitment its roster has removed in neither of its lists")
func aCommitmentsScreenListsACommitmentItsRosterHasRemovedInNeitherOfItsLists() throws {
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
    try rosterStore.remove(gym, keptUntil: sunday)
    try rosterStore.retire(journaling, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.map(\.name) == ["Water plants"])
    #expect(screen.stopped.map(\.name) == ["Journaling"])
    #expect(!screen.kept.contains(gym))
    #expect(!screen.stopped.contains(gym))
}

@MainActor
@Test("removing one of two entries alike in name removes the one it was asked about")
func removingOneOfTwoEntriesAlikeInNameRemovesTheOneItWasAskedAbout() throws {
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
    screen.askToRemove(vitaminsTuesdayThursday)
    screen.nameTypedBack = "Vitamins"
    screen.confirmRemoving()

    #expect(screen.kept.map(\.name) == ["Vitamins"])
    #expect(screen.kept.map(\.rhythmInWords) == ["Mon, Wed"])
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a commitment defined again after being removed is taken up again in the place it was taken on in")
func aCommitmentDefinedAgainAfterBeingRemovedIsTakenUpAgainInThePlaceItWasTakenOnIn() throws {
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
    try rosterStore.remove(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "Gym",
        on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)

    #expect(refusal == nil)
    #expect(screen.kept.map(\.name) == ["Water plants", "Gym", "Journaling"])
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a commitments screen that cannot read its roster does nothing when it is asked to remove a commitment")
func aCommitmentsScreenThatCannotReadItsRosterDoesNothingWhenItIsAskedToRemoveACommitment() throws {
    let rosterPlace = freshRosterPlace()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let originalBytes = Data("not what a roster is written as".utf8)
    try originalBytes.write(to: rosterPlace)
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    screen.askToRemove(gym)

    #expect(screen.awaitingRemoval == nil)
    #expect(screen.refusedChange == nil)
    #expect(try Data(contentsOf: rosterPlace) == originalBytes)
}

@MainActor
@Test("a commitments screen holds a refused removal against the commitment it was asked to remove")
func aCommitmentsScreenHoldsARefusedRemovalAgainstTheCommitmentItWasAskedToRemove() throws {
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
    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    let refusal = screen.confirmRemoving()

    #expect(refusal == .notKept)
    #expect(screen.refusedChange == .removing(gym, .notKept))
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitments screen holds nothing against a removal confirmed on a name that does not match")
func aCommitmentsScreenHoldsNothingAgainstARemovalConfirmedOnANameThatDoesNotMatch() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(
        name: "Gym",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let defineRefusal = screen.define(name: "   ", on: daily, keptFrom: monday)
    #expect(defineRefusal == .namesNothing)

    screen.askToRemove(gym)
    screen.nameTypedBack = "Gymm"

    let refusal = screen.confirmRemoving()

    #expect(refusal == nil)
    #expect(screen.refusedChange == .defining(.namesNothing))
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.awaitingRemoval == gym)
}

@MainActor
@Test("what a commitments screen holds about a refused change ends when a removal is kept")
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenARemovalIsKept() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(
        name: "Gym",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.define(name: "   ", on: daily, keptFrom: monday)

    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"
    let refusal = screen.confirmRemoving()

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(!screen.kept.contains(gym))
    #expect(!screen.stopped.contains(gym))
}

@MainActor
@Test("what a commitments screen holds about a refused change stands when a removal is asked for and cancelled")
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenARemovalIsAskedForAndCancelled() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(
        name: "Gym",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.define(name: "   ", on: daily, keptFrom: monday)

    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"
    screen.cancelRemoving()

    #expect(screen.refusedChange == .defining(.namesNothing))
    #expect(screen.awaitingRemoval == nil)
    #expect(screen.nameTypedBack == "")
}

@MainActor
@Test("what a commitments screen has stopped is in the order its roster holds them")
func whatACommitmentsScreenHasStoppedIsInTheOrderItsRosterHoldsThem() throws {
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
    try rosterStore.move(journaling, toOffset: 0)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToStopKeeping(journaling)
    screen.confirmStopKeeping()
    screen.askToStopKeeping(waterPlants)
    screen.confirmStopKeeping()

    #expect(screen.stopped.map(\.name) == ["Journaling", "Water plants"])
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("moving a commitment leaves a stop awaiting confirmation exactly as it was")
func movingACommitmentLeavesAStopAwaitingConfirmationExactlyAsItWas() throws {
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
    let moved = screen.move(journaling, toOffset: 0)

    #expect(moved == nil)
    #expect(screen.awaitingConfirmation == gym)
    #expect(screen.kept.map(\.name) == ["Journaling", "Gym"])

    screen.confirmStopKeeping()

    #expect(screen.kept.map(\.name) == ["Journaling"])
}

@MainActor
@Test("a commitments screen that cannot read its roster does nothing when it is asked to move a commitment")
func aCommitmentsScreenThatCannotReadItsRosterDoesNothingWhenItIsAskedToMoveACommitment() throws {
    let rosterPlace = freshRosterPlace()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let originalBytes = Data("not what a roster is written as".utf8)
    try originalBytes.write(to: rosterPlace)
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let moved = screen.move(gym, toOffset: 0)

    #expect(moved == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.rosterState == .notKept)
    #expect(try Data(contentsOf: rosterPlace) == originalBytes)
}
