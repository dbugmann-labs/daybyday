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
        name: "Gym", on: .weekdays([.monday, .wednesday, .saturday]), keptFrom: monday, under: nil)

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
        ]), keptFrom: monday, under: nil)

    #expect(screen.kept.map(\.name) == ["Water plants", "Gym", "Journaling"])
}

@MainActor
@Test("a commitment defined on each of the four rhythms is read back on the schedule that rhythm names")
func aCommitmentDefinedOnEachOfTheFourRhythmsIsReadBackOnTheScheduleThatRhythmNames() throws {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(
        name: "Gym", on: .weekdays([.monday, .wednesday, .saturday]), keptFrom: monday, under: nil)
    _ = screen.define(
        name: "Finances", on: .dayOfMonth(25), keptFrom: monday, under: nil)
    _ = screen.define(
        name: "Contact lenses", on: .everyNDays(14), keptFrom: monday, under: nil)
    _ = screen.define(
        name: "Reading", on: .weeklyQuota(3), keptFrom: monday, under: nil)

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
        keptFrom: wednesdayFirstJuly, under: nil)

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

    let gymRefusal = screen.define(name: "Gym", on: daily, keptFrom: farFuture, under: nil)
    let journalingRefusal = screen.define(name: "Journaling", on: daily, keptFrom: farPast, under: nil)

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

    let refusal = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)

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

    let refusal = screen.define(name: "Gym", on: .weekdays([]), keptFrom: monday, under: nil)

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

    let xRefusal = screen.define(name: "x", on: daily, keptFrom: monday, under: nil)
    let gymRefusal = screen.define(name: " Gym ", on: daily, keptFrom: monday, under: nil)
    let emojiRefusal = screen.define(name: "Gym 🏋️", on: daily, keptFrom: monday, under: nil)

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
        name: "Gym", on: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom, under: nil)

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

    let refusal = screen.define(name: "Gym", on: daily, keptFrom: monday, under: nil)

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
        keptFrom: keptFrom, under: nil)

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
        keptFrom: keptFrom, under: nil)
    let secondRefusal = screen.define(
        name: "Gym",
        on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
        keptFrom: keptFrom, under: nil)

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

    let zerothRefusal = screen.define(name: "Finances", on: .dayOfMonth(0), keptFrom: monday, under: nil)
    let thirtySecondRefusal = screen.define(name: "Finances", on: .dayOfMonth(32), keptFrom: monday, under: nil)

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

    let zeroRefusal = screen.define(name: "Contact lenses", on: .everyNDays(0), keptFrom: monday, under: nil)
    let negativeRefusal = screen.define(name: "Contact lenses", on: .everyNDays(-7), keptFrom: monday, under: nil)

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

    let zeroRefusal = screen.define(name: "Reading", on: .weeklyQuota(0), keptFrom: monday, under: nil)
    let eightRefusal = screen.define(name: "Reading", on: .weeklyQuota(8), keptFrom: monday, under: nil)

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

    let financesRefusal = screen.define(name: "Finances", on: .dayOfMonth(32), keptFrom: monday, under: nil)
    let blankRefusal = screen.define(name: "   ", on: .weekdays(allWeekdays), keptFrom: monday, under: nil)
    let gymRefusal = screen.define(name: "Gym", on: .weekdays([]), keptFrom: monday, under: nil)

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

    let rentRefusal = screen.define(name: "Rent", on: .dayOfMonth(1), keptFrom: monday, under: nil)
    let financesRefusal = screen.define(name: "Finances", on: .dayOfMonth(31), keptFrom: monday, under: nil)
    let shaveRefusal = screen.define(name: "Shave", on: .everyNDays(1), keptFrom: monday, under: nil)
    let longRunRefusal = screen.define(name: "Long run", on: .weeklyQuota(1), keptFrom: monday, under: nil)
    let stepsRefusal = screen.define(name: "Steps", on: .weeklyQuota(7), keptFrom: monday, under: nil)

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
    let refusal = screen.define(name: "Journaling", on: daily, keptFrom: monday, under: nil)

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
    try Data(#"{"version": 5, "commitments": []}"#.utf8).write(to: rosterPlace)
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

    let refusal = screen.define(name: "Gym", on: daily, keptFrom: monday, under: nil)
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

    let refusal = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)

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

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)

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

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)
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

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)
    #expect(screen.refusedChange != nil)

    let journalingRefusal = screen.define(name: "Journaling", on: allWeekdays, keptFrom: monday, under: nil)

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

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)
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

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)
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

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)

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

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)

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

    let refusal = screen.define(name: "Gym", on: allWeekdays, keptFrom: monday, under: nil)
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
        ]), keptFrom: keptFrom, under: nil)

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

    let defineRefusal = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)
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
    _ = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)

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
    _ = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)

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
    try rosterStore.move(journaling, toOffset: 0, under: nil)

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
    let moved = screen.move(journaling, toOffset: 0, under: nil)

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

    let moved = screen.move(gym, toOffset: 0, under: nil)

    #expect(moved == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.rosterState == .notKept)
    #expect(try Data(contentsOf: rosterPlace) == originalBytes)
}

@MainActor
@Test("a commitments screen holds a refused move against the commitment it was asked to move")
func aCommitmentsScreenHoldsARefusedMoveAgainstTheCommitmentItWasAskedToMove() throws {
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

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    let refusal = screen.move(journaling, toOffset: 0, under: nil)

    #expect(refusal == .notKept)
    #expect(screen.refusedChange == .moving(journaling, .notKept))
    #expect(screen.kept.map(\.name) == ["Gym", "Journaling"])
}

@MainActor
@Test("a commitments screen holds nothing against a move that asks for no change at all")
func aCommitmentsScreenHoldsNothingAgainstAMoveThatAsksForNoChangeAtAll() throws {
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
    let movedNeverTakenOn = screen.move(journaling, toOffset: 0, under: nil)
    let movedOutsideTheList = screen.move(gym, toOffset: 2, under: nil)

    #expect(movedNeverTakenOn == nil)
    #expect(movedOutsideTheList == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("what a commitments screen holds about a refused change ends when a move is kept")
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenAMoveIsKept() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)

    let refusal = screen.move(journaling, toOffset: 0, under: nil)

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.kept.map(\.name) == ["Journaling", "Gym"])
}

@MainActor
@Test("what a commitments screen holds about a refused change stands when a move drops a commitment where it already is")
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenAMoveDropsACommitmentWhereItAlreadyIs()
    throws
{
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)

    let refusal = screen.move(journaling, toOffset: 2, under: nil)

    #expect(refusal == nil)
    #expect(screen.refusedChange == .defining(.namesNothing))
    #expect(screen.kept.map(\.name) == ["Gym", "Journaling"])
}

@MainActor
@Test("a commitment moved through a commitments screen is where it was dropped, and is kept there")
func aCommitmentMovedThroughACommitmentsScreenIsWhereItWasDroppedAndIsKeptThere() throws {
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
    let refusal = screen.move(journaling, toOffset: 0, under: nil)

    #expect(refusal == nil)
    #expect(screen.kept.map(\.name) == ["Journaling", "Water plants", "Gym"])

    let later = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(later.kept.map(\.name) == ["Journaling", "Water plants", "Gym"])
}

@MainActor
@Test("an offset a commitments screen is given is counted over what it keeps before the move")
func anOffsetACommitmentsScreenIsGivenIsCountedOverWhatItKeepsBeforeTheMove() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    func neverMoved() throws -> CommitmentsScreen {
        let rosterPlace = freshRosterPlace()
        let rosterStore = try RosterStore(at: rosterPlace)
        try rosterStore.add(waterPlants)
        try rosterStore.add(gym)
        try rosterStore.add(journaling)
        return CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    }

    let atOffsetTwo = try neverMoved()
    _ = atOffsetTwo.move(waterPlants, toOffset: 2, under: nil)

    let atOffsetThree = try neverMoved()
    _ = atOffsetThree.move(waterPlants, toOffset: 3, under: nil)

    #expect(atOffsetTwo.kept.map(\.name) == ["Gym", "Water plants", "Journaling"])
    #expect(atOffsetThree.kept.map(\.name) == ["Gym", "Journaling", "Water plants"])
}

@MainActor
@Test("a commitments screen asked to move a commitment it has stopped does nothing and says nothing")
func aCommitmentsScreenAskedToMoveACommitmentItHasStoppedDoesNothingAndSaysNothing() throws {
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
    let refusal = screen.move(gym, toOffset: 0, under: nil)

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.kept.map(\.name) == ["Journaling"])
    #expect(screen.stopped.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitments screen asked to move a commitment on neither of its lists does nothing and says nothing")
func aCommitmentsScreenAskedToMoveACommitmentOnNeitherOfItsListsDoesNothingAndSaysNothing() throws {
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
    let refusal = screen.move(journaling, toOffset: 0, under: nil)

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitments screen given an offset the list it keeps does not have does nothing and says nothing")
func aCommitmentsScreenGivenAnOffsetTheListItKeepsDoesNotHaveDoesNothingAndSaysNothing() throws {
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
    let movedPastTheEnd = screen.move(gym, toOffset: 3, under: nil)

    #expect(movedPastTheEnd == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.kept.map(\.name) == ["Gym", "Journaling"])

    let movedBelowZero = screen.move(gym, toOffset: -1, under: nil)

    #expect(movedBelowZero == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.kept.map(\.name) == ["Gym", "Journaling"])
}

@MainActor
@Test("a move a commitments screen could not keep leaves both its lists as they were")
func aMoveACommitmentsScreenCouldNotKeepLeavesBothItsListsAsTheyWere() throws {
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

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    let refusal = screen.move(journaling, toOffset: 0, under: nil)

    #expect(refusal == .notKept)
    #expect(screen.kept.map(\.name) == ["Gym", "Journaling"])
    #expect(screen.stopped == [])
}

@MainActor
@Test("a move that drops a commitment where it already is changes nothing and refuses nothing")
func aMoveThatDropsACommitmentWhereItAlreadyIsChangesNothingAndRefusesNothing() throws {
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
    let bytesBeforeMove = try Data(contentsOf: rosterPlace)

    let refusal = screen.move(journaling, toOffset: 2, under: nil)

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.kept.map(\.name) == ["Gym", "Journaling"])
    #expect(try Data(contentsOf: rosterPlace) == bytesBeforeMove)
}

@MainActor
@Test("a commitments screen shown again lists what it keeps in the order it was moved into")
func aCommitmentsScreenShownAgainListsWhatItKeepsInTheOrderItWasMovedInto() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.move(journaling, toOffset: 0, under: nil)
    screen.shown(asOf: tuesday)

    #expect(screen.kept.map(\.name) == ["Journaling", "Water plants", "Gym"])
}

@MainActor
@Test("a commitment moved and then stopped through a commitments screen keeps the place it was moved to")
func aCommitmentMovedAndThenStoppedThroughACommitmentsScreenKeepsThePlaceItWasMovedTo() throws {
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

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.move(journaling, toOffset: 0, under: nil)
    screen.askToStopKeeping(journaling)
    screen.confirmStopKeeping()

    #expect(screen.kept.map(\.name) == ["Water plants", "Gym"])
    #expect(screen.stopped.map(\.name) == ["Journaling"])

    let later = try RosterStore(at: rosterPlace)

    #expect(later.roster.commitments(on: sunday) == [journaling, waterPlants, gym])
}

@MainActor
@Test("a commitments screen draws what it keeps in groups, one per category")
func aCommitmentsScreenDrawsWhatItKeepsInGroupsOnePerCategory() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let finances = Commitment(name: "Finances", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.add(magnesium)
    try rosterStore.add(finances)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(magnesium, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: nil, commitments: [finances]),
            ])
    #expect(screen.kept == [creatine, magnesium, gym, finances])
}

@MainActor
@Test("a group sits where its first commitment sits in the order the person set")
func aGroupSitsWhereItsFirstCommitmentSitsInTheOrderThePersonSet() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.add(magnesium)
    try rosterStore.put(gym, under: "Sport")
    try rosterStore.put(magnesium, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let groups = screen.keptGroups

    #expect(
        groups
            == [
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: "Supplements", commitments: [magnesium]),
                Roster.Group(category: nil, commitments: [creatine]),
            ])
    #expect(groups.map(\.category) != groups.map(\.category).sorted { ($0 ?? "") < ($1 ?? "") })
}

@MainActor
@Test("a commitments screen whose commitments are none of them under a category draws one group")
func aCommitmentsScreenWhoseCommitmentsAreNoneOfThemUnderACategoryDrawsOneGroup() throws {
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

    #expect(
        screen.keptGroups
            == [Roster.Group(category: nil, commitments: [waterPlants, gym, journaling])])
}

@MainActor
@Test("a commitment given a category is drawn in that group and returns when the category is taken off")
func aCommitmentGivenACategoryIsDrawnInThatGroupAndReturnsWhenTheCategoryIsTakenOff() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.add(magnesium)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.put(magnesium, under: "Supplements")

    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [magnesium]),
                Roster.Group(category: nil, commitments: [creatine, gym]),
            ])

    _ = screen.put(magnesium, under: nil)

    #expect(
        screen.keptGroups
            == [Roster.Group(category: nil, commitments: [creatine, gym, magnesium])])
}

@MainActor
@Test("what a commitments screen has stopped is one flat list whatever categories its commitments are under")
func whatACommitmentsScreenHasStoppedIsOneFlatListWhateverCategoriesItsCommitmentsAreUnder() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.add(magnesium)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(magnesium, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")
    try rosterStore.retire(creatine, keptUntil: sunday)
    try rosterStore.retire(gym, keptUntil: sunday)
    try rosterStore.retire(magnesium, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.stopped.map(\.name) == ["Creatine", "Gym", "Magnesium"])
    #expect(screen.keptGroups.isEmpty)
}

@MainActor
@Test("a stopped commitment taken up again is drawn in the group of the category it was under")
func aStoppedCommitmentTakenUpAgainIsDrawnInTheGroupOfTheCategoryItWasUnder() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.retire(creatine, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.keepAgain(creatine)

    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a commitment is put under a category through a commitments screen and kept at the roster place")
func aCommitmentIsPutUnderACategoryThroughACommitmentsScreenAndKeptAtTheRosterPlace() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.put(creatine, under: "Supplements")

    #expect(refusal == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])

    let later = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(
        later.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
}

@MainActor
@Test("a category taken off through a commitments screen draws its commitment among the ones under none")
func aCategoryTakenOffThroughACommitmentsScreenDrawsItsCommitmentAmongTheOnesUnderNone() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.put(creatine, under: "   ")

    #expect(refusal == nil)
    #expect(
        screen.keptGroups == [Roster.Group(category: nil, commitments: [creatine, gym])])
}

@MainActor
@Test("a commitments screen asked to put a commitment it does not keep under a category does nothing and says nothing")
func aCommitmentsScreenAskedToPutACommitmentItDoesNotKeepUnderACategoryDoesNothingAndSaysNothing()
    throws
{
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.retire(creatine, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.put(creatine, under: "Supplements")

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.keptGroups == [Roster.Group(category: nil, commitments: [gym])])
    #expect(screen.stopped.map(\.name) == ["Creatine"])

    let neverTakenOn = screen.put(journaling, under: "Supplements")

    #expect(neverTakenOn == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.keptGroups == [Roster.Group(category: nil, commitments: [gym])])
}

@MainActor
@Test("a category change a commitments screen could not keep leaves both its lists as they were")
func aCategoryChangeACommitmentsScreenCouldNotKeepLeavesBothItsListsAsTheyWere() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    let refusal = screen.put(creatine, under: "Supplements")

    #expect(refusal == .notKept)
    #expect(screen.keptGroups == [Roster.Group(category: nil, commitments: [creatine, gym])])
    #expect(screen.stopped.isEmpty)
    #expect(screen.categoriesInUse.isEmpty)
}

@MainActor
@Test("a commitments screen offers the categories the commitments it keeps are under, each once")
func aCommitmentsScreenOffersTheCategoriesTheCommitmentsItKeepsAreUnderEachOnce() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let finances = Commitment(name: "Finances", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.add(magnesium)
    try rosterStore.add(finances)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(magnesium, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.categoriesInUse == ["Supplements", "Sport"])
    #expect(screen.categoriesInUse.filter { $0 == "Supplements" }.count == 1)
}

@MainActor
@Test("a commitments screen keeping nothing under a category offers none")
func aCommitmentsScreenKeepingNothingUnderACategoryOffersNone() throws {
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

    #expect(screen.categoriesInUse.isEmpty)
    #expect(
        screen.keptGroups == [Roster.Group(category: nil, commitments: [gym, journaling])])
}

@MainActor
@Test("a commitments screen offers no category that only a commitment it has stopped is under")
func aCommitmentsScreenOffersNoCategoryThatOnlyACommitmentItHasStoppedIsUnder() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.retire(creatine, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.categoriesInUse.isEmpty)

    _ = screen.keepAgain(creatine)

    #expect(screen.categoriesInUse == ["Supplements"])
}

@MainActor
@Test("a category no longer under any commitment kept is no longer offered")
func aCategoryNoLongerUnderAnyCommitmentKeptIsNoLongerOffered() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.put(creatine, under: "Morning")

    #expect(screen.categoriesInUse == ["Morning"])
    #expect(!screen.categoriesInUse.contains("Supplements"))
}

@MainActor
@Test("a commitments screen does not fold the case of a category it is given")
func aCommitmentsScreenDoesNotFoldTheCaseOfACategoryItIsGiven() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(magnesium)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.put(creatine, under: "Supplements")
    _ = screen.put(magnesium, under: "supplements")

    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "supplements", commitments: [magnesium]),
            ])
    #expect(screen.categoriesInUse == ["Supplements", "supplements"])
}

@MainActor
@Test("a commitment defined under a category is drawn in that category's group and kept under it")
func aCommitmentDefinedUnderACategoryIsDrawnInThatCategorysGroupAndKeptUnderIt() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.define(
        name: "Creatine", on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]), keptFrom: monday, under: "Supplements")

    #expect(refusal == nil)
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: monday)!
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])

    let later = try RosterStore(at: rosterPlace)
    #expect(
        later.roster.groups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
}

@MainActor
@Test("a commitment defined under a category of nothing but blank space is under none and is not refused")
func aCommitmentDefinedUnderACategoryOfNothingButBlankSpaceIsUnderNoneAndIsNotRefused() throws {
    let rosterPlace = freshRosterPlace()
    let daily: Schedule = .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday])
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.define(
        name: "Gym", on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]), keptFrom: monday, under: "   ")

    #expect(refusal == nil)
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: monday)!
    #expect(screen.keptGroups == [Roster.Group(category: nil, commitments: [gym])])

    let secondRefusal = screen.define(
        name: "Journaling", on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]), keptFrom: monday, under: "")

    #expect(secondRefusal == nil)
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: monday)!
    #expect(
        screen.keptGroups == [Roster.Group(category: nil, commitments: [gym, journaling])])
}

@MainActor
@Test("a commitment defined again after being removed takes the category the form carried")
func aCommitmentDefinedAgainAfterBeingRemovedTakesTheCategoryTheFormCarried() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterPlace = freshRosterPlace()
    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.remove(creatine, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.define(
        name: "Creatine", on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]), keptFrom: keptFrom, under: "Morning")

    #expect(refusal == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Morning", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])

    let uncategorisedRosterPlace = freshRosterPlace()
    let uncategorisedStore = try RosterStore(at: uncategorisedRosterPlace)
    try uncategorisedStore.add(creatine)
    try uncategorisedStore.add(gym)
    try uncategorisedStore.put(creatine, under: "Supplements")
    try uncategorisedStore.remove(creatine, keptUntil: sunday)

    let uncategorisedScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: uncategorisedRosterPlace)
    _ = uncategorisedScreen.define(
        name: "Creatine", on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]), keptFrom: keptFrom, under: nil)

    #expect(
        uncategorisedScreen.keptGroups
            == [Roster.Group(category: nil, commitments: [creatine, gym])])
}

@MainActor
@Test("a category is kept exactly as it was typed on the form")
func aCategoryIsKeptExactlyAsItWasTypedOnTheForm() throws {
    let rosterPlace = freshRosterPlace()
    let daily: Schedule = .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday])
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let creatineRefusal = screen.define(
        name: "Creatine", on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]), keptFrom: monday, under: " Supplements ")
    let magnesiumRefusal = screen.define(
        name: "Magnesium", on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]), keptFrom: monday, under: "Supplements")

    #expect(creatineRefusal == nil)
    #expect(magnesiumRefusal == nil)
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: monday)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: monday)!
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: " Supplements ", commitments: [creatine]),
                Roster.Group(category: "Supplements", commitments: [magnesium]),
            ])
}

@MainActor
@Test("a commitments screen holds a refused category change against the commitment it was asked about")
func aCommitmentsScreenHoldsARefusedCategoryChangeAgainstTheCommitmentItWasAskedAbout() throws {
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

    let refusal = screen.put(gym, under: "Sport")

    #expect(refusal == .notKept)
    #expect(screen.refusedChange == .categorising(gym, .notKept))
    #expect(screen.keptGroups == [Roster.Group(category: nil, commitments: [gym])])
}

@MainActor
@Test("a commitments screen holds nothing against a category change that asks for no change at all")
func aCommitmentsScreenHoldsNothingAgainstACategoryChangeThatAsksForNoChangeAtAll() throws {
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
    let defineRefusal = screen.define(
        name: "   ", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: monday, under: nil)

    #expect(defineRefusal == .namesNothing)

    let categoryRefusal = screen.put(journaling, under: "Sport")

    #expect(categoryRefusal == nil)
    #expect(screen.refusedChange == .defining(.namesNothing))
    #expect(screen.keptGroups == [Roster.Group(category: nil, commitments: [gym])])
}

@MainActor
@Test("a commitments screen that cannot read its roster does nothing when it is asked to put a commitment under a category")
func aCommitmentsScreenThatCannotReadItsRosterDoesNothingWhenItIsAskedToPutACommitmentUnderACategory()
    throws
{
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

    let refusal = screen.put(gym, under: "Sport")

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.rosterState == .notKept)
    #expect(screen.keptGroups.isEmpty)
    #expect(screen.categoriesInUse.isEmpty)
    #expect(try Data(contentsOf: rosterPlace) == originalBytes)
}

@MainActor
@Test("an offset a commitments screen is given is counted over the group a drop landed in and not over the roster's own order")
func anOffsetACommitmentsScreenIsGivenIsCountedOverTheGroupADropLandedInAndNotOverTheRostersOwnOrder()
    throws
{
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    func freshScreen() throws -> (screen: CommitmentsScreen, place: URL) {
        let rosterPlace = freshRosterPlace()
        let rosterStore = try RosterStore(at: rosterPlace)
        try rosterStore.add(gym)
        try rosterStore.add(creatine)
        try rosterStore.add(magnesium)
        try rosterStore.put(creatine, under: "Supplements")
        try rosterStore.put(magnesium, under: "Supplements")
        return (CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace), rosterPlace)
    }

    let (screen, rosterPlace) = try freshScreen()
    let refusal = screen.move(gym, toOffset: 1, under: "Supplements")

    #expect(refusal == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(
                    category: "Supplements", commitments: [creatine, gym, magnesium])
            ])

    let later = try RosterStore(at: rosterPlace)
    #expect(
        later.roster.groups
            == [
                Roster.Group(
                    category: "Supplements", commitments: [creatine, gym, magnesium])
            ])

    let (alikeScreen, _) = try freshScreen()
    let alikeRefusal = alikeScreen.move(gym, toOffset: 3, under: "Supplements")

    #expect(alikeRefusal == nil)
    #expect(
        alikeScreen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
}

@MainActor
@Test("a commitment dropped among another group's entries is put under that group's category")
func aCommitmentDroppedAmongAnotherGroupsEntriesIsPutUnderThatGroupsCategory() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(magnesium)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(magnesium, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.move(gym, toOffset: 1, under: "Supplements")

    #expect(refusal == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(
                    category: "Supplements", commitments: [creatine, gym, magnesium])
            ])
}

@MainActor
@Test("a commitment dropped among the entries under no category has its category taken off")
func aCommitmentDroppedAmongTheEntriesUnderNoCategoryHasItsCategoryTakenOff() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.put(creatine, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.move(creatine, toOffset: 2, under: nil)

    #expect(refusal == nil)
    #expect(
        screen.keptGroups
            == [Roster.Group(category: nil, commitments: [gym, journaling, creatine])])
}

@MainActor
@Test("a drop where a commitment is already drawn changes neither its place nor its category")
func aDropWhereACommitmentIsAlreadyDrawnChangesNeitherItsPlaceNorItsCategory() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesBeforeMove = try Data(contentsOf: rosterPlace)

    let refusal = screen.move(creatine, toOffset: 1, under: "Supplements")

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])

    let secondRefusal = screen.move(creatine, toOffset: 0, under: "Supplements")

    #expect(secondRefusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
    #expect(try Data(contentsOf: rosterPlace) == bytesBeforeMove)
}

@MainActor
@Test("a commitment dropped after the last entry of a group is drawn at the end of that group")
func aCommitmentDroppedAfterTheLastEntryOfAGroupIsDrawnAtTheEndOfThatGroup() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(magnesium)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(magnesium, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")
    try rosterStore.put(journaling, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.move(journaling, toOffset: 2, under: "Supplements")

    #expect(refusal == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(
                    category: "Supplements", commitments: [creatine, magnesium, journaling]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
    #expect(screen.keptGroups.first { $0.category == "Sport" }?.commitments == [gym])
}

@MainActor
@Test("a commitments screen asked to move a commitment into a group it draws none of does nothing and says nothing")
func aCommitmentsScreenAskedToMoveACommitmentIntoAGroupItDrawsNoneOfDoesNothingAndSaysNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(gym, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesBeforeMove = try Data(contentsOf: rosterPlace)

    let refusal = screen.move(gym, toOffset: 0, under: nil)

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [Roster.Group(category: "Supplements", commitments: [creatine, gym])])

    let secondRefusal = screen.move(gym, toOffset: 0, under: "Sport")

    #expect(secondRefusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [Roster.Group(category: "Supplements", commitments: [creatine, gym])])
    #expect(try Data(contentsOf: rosterPlace) == bytesBeforeMove)
}

@MainActor
@Test("moving a group's only entry into another group leaves one heading fewer")
func movingAGroupsOnlyEntryIntoAnotherGroupLeavesOneHeadingFewer() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.move(gym, toOffset: 0, under: "Supplements")

    #expect(refusal == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [gym, creatine]),
                Roster.Group(category: nil, commitments: [journaling]),
            ])
    #expect(!screen.keptGroups.contains { $0.category == "Sport" })
}

@MainActor
@Test("what a commitments screen holds about a refused change ends when a category change is kept")
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenACategoryChangeIsKept() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)

    let refusal = screen.put(gym, under: "Sport")

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.keptGroups == [Roster.Group(category: "Sport", commitments: [gym])])
}

@MainActor
@Test("what a commitments screen holds about a refused change stands when a category change puts a commitment under the category it is already under")
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenACategoryChangePutsACommitmentUnderTheCategoryItIsAlreadyUnder()
    throws
{
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)

    let refusal = screen.put(gym, under: "Sport")

    #expect(refusal == nil)
    #expect(screen.refusedChange == .defining(.namesNothing))
}

@MainActor
@Test("a group moved through a commitments screen is drawn where it was moved to, and is kept there")
func aGroupMovedThroughACommitmentsScreenIsDrawnWhereItWasMovedToAndIsKeptThere() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(creatine)
    try rosterStore.add(magnesium)
    try rosterStore.put(gym, under: "Sport")
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(magnesium, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.move(group: "Supplements", toOffset: 0)

    #expect(refusal == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])

    let later = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(
        later.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
}

@MainActor
@Test("an offset a commitments screen is given for a group is counted over the groups it draws that are under a category")
func anOffsetACommitmentsScreenIsGivenForAGroupIsCountedOverTheGroupsItDrawsThatAreUnderACategory()
    throws
{
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let finances = Commitment(name: "Finances", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    func neverMoved() throws -> CommitmentsScreen {
        let rosterPlace = freshRosterPlace()
        let rosterStore = try RosterStore(at: rosterPlace)
        try rosterStore.add(waterPlants)
        try rosterStore.add(gym)
        try rosterStore.add(creatine)
        try rosterStore.add(finances)
        try rosterStore.put(gym, under: "Sport")
        try rosterStore.put(creatine, under: "Supplements")
        try rosterStore.put(finances, under: "Money")
        return CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    }

    let atTheCount = try neverMoved()
    let movedAtTheCount = atTheCount.move(group: "Sport", toOffset: 3)

    #expect(movedAtTheCount == nil)
    #expect(
        atTheCount.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "Money", commitments: [finances]),
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: nil, commitments: [waterPlants]),
            ])

    let pastTheCount = try neverMoved()
    let keptGroupsBeforeMove = pastTheCount.keptGroups
    let movedPastTheCount = pastTheCount.move(group: "Sport", toOffset: 4)

    #expect(movedPastTheCount == nil)
    #expect(pastTheCount.keptGroups == keptGroupsBeforeMove)
}

@MainActor
@Test("a group moved through a commitments screen carries the commitments it has stopped with it")
func aGroupMovedThroughACommitmentsScreenCarriesTheCommitmentsItHasStoppedWithIt() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(magnesium)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(magnesium, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")
    try rosterStore.put(journaling, under: "Sport")
    try rosterStore.retire(creatine, keptUntil: sunday)
    try rosterStore.retire(journaling, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.move(group: "Supplements", toOffset: 2)

    #expect(refusal == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: "Supplements", commitments: [magnesium]),
            ])
    #expect(screen.stopped == [journaling, creatine])

    let later = try RosterStore(at: rosterPlace)

    #expect(
        later.roster.groups(on: sunday)
            == [
                Roster.Group(category: "Sport", commitments: [gym, journaling]),
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
            ])
}

@MainActor
@Test("a commitments screen asked to move the group of the commitments under no category does nothing and says nothing")
func aCommitmentsScreenAskedToMoveTheGroupOfTheCommitmentsUnderNoCategoryDoesNothingAndSaysNothing()
    throws
{
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesBeforeMove = try Data(contentsOf: rosterPlace)

    let movedNilCategory = screen.move(group: nil, toOffset: 0)

    #expect(movedNilCategory == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])

    let movedBlankCategory = screen.move(group: "   ", toOffset: 0)

    #expect(movedBlankCategory == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
    #expect(try Data(contentsOf: rosterPlace) == bytesBeforeMove)
}

@MainActor
@Test("a commitments screen asked to move a group it draws none of does nothing and says nothing")
func aCommitmentsScreenAskedToMoveAGroupItDrawsNoneOfDoesNothingAndSaysNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesBeforeMove = try Data(contentsOf: rosterPlace)

    let movedStoppedOnly = screen.move(group: "Sport", toOffset: 0)

    #expect(movedStoppedOnly == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.keptGroups == [Roster.Group(category: "Supplements", commitments: [creatine])])
    #expect(screen.stopped == [gym])

    let movedNothing = screen.move(group: "Evening", toOffset: 0)

    #expect(movedNothing == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.keptGroups == [Roster.Group(category: "Supplements", commitments: [creatine])])
    #expect(screen.stopped == [gym])
    #expect(try Data(contentsOf: rosterPlace) == bytesBeforeMove)
}

@MainActor
@Test("a commitments screen given an offset the groups it draws do not have does nothing and says nothing")
func aCommitmentsScreenGivenAnOffsetTheGroupsItDrawsDoNotHaveDoesNothingAndSaysNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesBeforeMove = try Data(contentsOf: rosterPlace)

    let movedPastTheEnd = screen.move(group: "Sport", toOffset: 3)

    #expect(movedPastTheEnd == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])

    let movedBelowZero = screen.move(group: "Sport", toOffset: -1)

    #expect(movedBelowZero == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
    #expect(try Data(contentsOf: rosterPlace) == bytesBeforeMove)
}

@MainActor
@Test("a group move a commitments screen could not keep leaves both its lists as they were")
func aGroupMoveACommitmentsScreenCouldNotKeepLeavesBothItsListsAsTheyWere() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    let refusal = screen.move(group: "Sport", toOffset: 0)

    #expect(refusal == .notKept)
    #expect(screen.refusedChange == .movingGroup("Sport", .notKept))
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
    #expect(screen.stopped == [])
}

@MainActor
@Test("a group move that leaves a group where it is drawn changes nothing and refuses nothing")
func aGroupMoveThatLeavesAGroupWhereItIsDrawnChangesNothingAndRefusesNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.add(magnesium)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(magnesium, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesBeforeMove = try Data(contentsOf: rosterPlace)

    let movedAtItsOwnOffset = screen.move(group: "Supplements", toOffset: 0)

    #expect(movedAtItsOwnOffset == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])

    let movedAtOffsetJustAfter = screen.move(group: "Supplements", toOffset: 1)

    #expect(movedAtOffsetJustAfter == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
    #expect(try Data(contentsOf: rosterPlace) == bytesBeforeMove)
}

@MainActor
@Test("a commitments screen shown again draws its groups in the order they were moved into")
func aCommitmentsScreenShownAgainDrawsItsGroupsInTheOrderTheyWereMovedInto() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(creatine)
    try rosterStore.put(gym, under: "Sport")
    try rosterStore.put(creatine, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.move(group: "Supplements", toOffset: 0)
    screen.shown(asOf: tuesday)

    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
}

@MainActor
@Test("a commitments screen holds a refused group move against the category it was asked to move")
func aCommitmentsScreenHoldsARefusedGroupMoveAgainstTheCategoryItWasAskedToMove() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    let refusal = screen.move(group: "Sport", toOffset: 0)

    #expect(refusal == .notKept)
    #expect(screen.refusedChange == .movingGroup("Sport", .notKept))
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
}

@MainActor
@Test("a commitments screen holds nothing against a group move that asks for no change at all")
func aCommitmentsScreenHoldsNothingAgainstAGroupMoveThatAsksForNoChangeAtAll() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let movedNoSuchGroup = screen.move(group: "Sport", toOffset: 0)
    let movedNilCategory = screen.move(group: nil, toOffset: 0)
    let movedOutsideTheGroups = screen.move(group: "Supplements", toOffset: 2)

    #expect(movedNoSuchGroup == nil)
    #expect(movedNilCategory == nil)
    #expect(movedOutsideTheGroups == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
}

@MainActor
@Test("what a commitments screen holds about a refused change ends when a group move is kept")
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenAGroupMoveIsKept() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)

    let refusal = screen.move(group: "Sport", toOffset: 0)

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
}

@MainActor
@Test("what a commitments screen holds about a refused change stands when a group move leaves a group where it is")
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenAGroupMoveLeavesAGroupWhereItIs() throws
{
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)

    let refusal = screen.move(group: "Supplements", toOffset: 0)

    #expect(refusal == nil)
    #expect(screen.refusedChange == .defining(.namesNothing))
}
