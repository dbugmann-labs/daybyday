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
