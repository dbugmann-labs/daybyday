import Foundation
import Testing
import DayByDayKit

/// A fresh pair of places under one fresh temporary directory — a record file and a roster file
/// beside it — so tests are independent and need no teardown: a UUID names the directory, and
/// the two files sit one level under it, so the directory itself does not exist until something
/// creates it. The two URLs this returns are "the same place" a screen is opened at twice.
private func freshPlaces() -> (record: URL, roster: URL) {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    return (
        directory.appendingPathComponent("record.json"),
        directory.appendingPathComponent("roster.json")
    )
}

@MainActor
@Test("a day screen opened where nothing has been kept holds the day view of that day with nothing kept")
func aDayScreenOpenedWhereNothingHasBeenKeptHoldsTheDayViewOfThatDayWithNothingKept() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.tuesday, .thursday, .sunday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym, run], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    #expect(screen.dayView.rows.map(\.name) == ["Gym"])
    #expect(!screen.dayView.rows[0].isKept)
}

@MainActor
@Test("a day screen opened where a tick was kept holds a day view that says the commitment is kept")
func aDayScreenOpenedWhereATickWasKeptHoldsADayViewThatSaysTheCommitmentIsKept() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tick = Tick(gym, on: monday)!

    let store = try RecordStore(at: place)
    try store.add(tick)

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    #expect(screen.dayView.rows.count == 1)
    #expect(screen.dayView.rows[0].isKept)
}

@MainActor
@Test("a day screen holds the day it was handed rather than the day it really is")
func aDayScreenHoldsTheDayItWasHandedRatherThanTheDayItReallyIs() {
    let keptFrom = CalendarDate(year: 1583, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let firstSupported = CalendarDate(year: 1583, month: 1, day: 3)!
    let lastSupported = CalendarDate(year: 9999, month: 12, day: 27)!

    let onFirstSupportedPlaces = freshPlaces()
    let onFirstSupported = DayScreen(
        startingFrom: [gym], asOf: firstSupported,
        keepingRecordAt: onFirstSupportedPlaces.record,
        keepingRosterAt: onFirstSupportedPlaces.roster)
    let onLastSupportedPlaces = freshPlaces()
    let onLastSupported = DayScreen(
        startingFrom: [gym], asOf: lastSupported,
        keepingRecordAt: onLastSupportedPlaces.record,
        keepingRosterAt: onLastSupportedPlaces.roster)

    #expect(
        onFirstSupported.dayView
            == DayView(of: [gym], on: firstSupported, in: History()))
    #expect(
        onLastSupported.dayView
            == DayView(of: [gym], on: lastSupported, in: History()))
}

@MainActor
@Test(
    "a day screen holds the same day view as one formed directly from the same commitments, day and history"
)
func aDayScreenHoldsTheSameDayViewAsOneFormedDirectlyFromTheSameCommitmentsDayAndHistory() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gymTick = Tick(gym, on: monday)!
    let journalingTick = Tick(journaling, on: monday)!

    let store = try RecordStore(at: place)
    try store.add(gymTick)
    try store.add(journalingTick)
    try store.remove(journalingTick)

    let screen = DayScreen(startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    var expectedHistory = History()
    expectedHistory.add(gymTick)
    let expected = DayView(of: [gym, journaling], on: monday, in: expectedHistory)

    #expect(screen.dayView == expected)
}

@MainActor
@Test("ticking a row that says its commitment is not kept makes the day screen say it is kept")
func tickingARowThatSaysItsCommitmentIsNotKeptMakesTheDayScreenSayItIsKept() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    let row = screen.dayView.rows[0]

    try screen.tick(row)

    #expect(screen.dayView.rows[0].isKept)
}

@MainActor
@Test("ticking a row that says its commitment is kept takes the tick back")
func tickingARowThatSaysItsCommitmentIsKeptTakesTheTickBack() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    let opened = screen.dayView
    try screen.tick(screen.dayView.rows[0])
    try screen.tick(screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.dayView == opened)
}

@MainActor
@Test("a tick made on a day screen is held by a day screen opened afterwards at the same place")
func aTickMadeOnADayScreenIsHeldByADayScreenOpenedAfterwardsAtTheSamePlace() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let first = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    try first.tick(first.dayView.rows[0])

    let second = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    #expect(second.dayView.rows[0].isKept)
}

@MainActor
@Test(
    "a tick taken back on a day screen is not held by a day screen opened afterwards at the same place"
)
func aTickTakenBackOnADayScreenIsNotHeldByADayScreenOpenedAfterwardsAtTheSamePlace() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let first = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    try first.tick(first.dayView.rows[0])
    try first.tick(first.dayView.rows[0])

    let second = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    #expect(!second.dayView.rows[0].isKept)
}

@MainActor
@Test("ticking one row leaves the other rows of the day as they were")
func tickingOneRowLeavesTheOtherRowsOfTheDayAsTheyWere() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let supplements = Commitment(
        name: "Supplements and habits", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym, journaling, supplements], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    try screen.tick(screen.dayView.rows[1])

    #expect(screen.dayView.rows.map(\.name) == ["Gym", "Journaling", "Supplements and habits"])
    #expect(screen.dayView.rows.map(\.isKept) == [false, true, false])
}

@MainActor
@Test("a change that cannot be kept is refused and leaves the day view as it was")
func aChangeThatCannotBeKeptIsRefusedAndLeavesTheDayViewAsItWas() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    let place = blocker.appendingPathComponent("record.json")
    let rosterPlace = directory.appendingPathComponent("roster.json")

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(screen.dayView.rows[0])
    }
    #expect(!screen.dayView.rows[0].isKept)

    let later = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    #expect(!later.dayView.rows[0].isKept)
}

@MainActor
@Test("a row the day screen's day view does not hold changes nothing")
func aRowTheDayScreensDayViewDoesNotHoldChangesNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!

    let mondayScreen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    let wednesdayScreen = DayScreen(startingFrom: [gym], asOf: wednesday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    try mondayScreen.tick(wednesdayScreen.dayView.rows[0])

    #expect(!mondayScreen.dayView.rows[0].isKept)

    let laterOnWednesday = DayScreen(startingFrom: [gym], asOf: wednesday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    #expect(!laterOnWednesday.dayView.rows[0].isKept)
}

@MainActor
@Test("the place a day screen keeps its record is under Application Support, in a directory of the app's own")
func thePlaceADayScreenKeepsItsRecordIsUnderApplicationSupportInADirectoryOfTheAppsOwn() {
    let applicationSupport = FileManager.default.urls(
        for: .applicationSupportDirectory, in: .userDomainMask)[0]

    let place = DayScreen.recordPlace

    #expect(place.path.hasPrefix(applicationSupport.path))
    let containingDirectory = place.deletingLastPathComponent()
    #expect(containingDirectory != applicationSupport)
    #expect(containingDirectory.path.hasPrefix(applicationSupport.path))
}

@MainActor
@Test("the place a day screen keeps its record is neither the caches directory nor the temporary directory")
func thePlaceADayScreenKeepsItsRecordIsNeitherTheCachesDirectoryNorTheTemporaryDirectory() {
    let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    let temporary = FileManager.default.temporaryDirectory

    let place = DayScreen.recordPlace

    #expect(!place.path.hasPrefix(caches.path))
    #expect(!place.path.hasPrefix(temporary.path))
}

@MainActor
@Test("the place a day screen keeps its record is the same place every time it is asked")
func thePlaceADayScreenKeepsItsRecordIsTheSamePlaceEveryTimeItIsAsked() {
    #expect(DayScreen.recordPlace == DayScreen.recordPlace)
}

@MainActor
@Test("a day screen opened where the record cannot be read still holds the day view of that day")
func aDayScreenOpenedWhereTheRecordCannotBeReadStillHoldsTheDayViewOfThatDay() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a record".utf8).write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.tuesday, .thursday, .sunday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym, run], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    #expect(screen.dayView.rows.map(\.name) == ["Gym"])
    #expect(!screen.dayView.rows[0].isKept)
}

@MainActor
@Test(
    "a day screen opened where the record cannot be read says it is not keeping one and gives no further reason"
)
func aDayScreenOpenedWhereTheRecordCannotBeReadSaysItIsNotKeepingOneAndGivesNoFurtherReason() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a record".utf8).write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    #expect(screen.recordState == .unreadable)
}

@MainActor
@Test(
    "a record written in a later form than this app knows makes a day screen that says the record is from a later version"
)
func aRecordWrittenInALaterFormThanThisAppKnowsMakesADayScreenThatSaysTheRecordIsFromALaterVersion()
    throws
{
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"version": 2, "ticks": []}"#.utf8).write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    #expect(screen.recordState == .writtenByALaterVersion)
    #expect(screen.dayView.rows.map(\.name) == ["Gym"])
    #expect(!screen.dayView.rows[0].isKept)
}

@MainActor
@Test("a day screen opened where the record can be read says it is keeping one")
func aDayScreenOpenedWhereTheRecordCanBeReadSaysItIsKeepingOne() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let (emptyPlace, emptyRosterPlace) = freshPlaces()
    let empty = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: emptyPlace, keepingRosterAt: emptyRosterPlace)
    #expect(empty.recordState == .kept)

    let (tickedPlace, tickedRosterPlace) = freshPlaces()
    let store = try RecordStore(at: tickedPlace)
    try store.add(Tick(gym, on: monday)!)
    let ticked = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: tickedPlace, keepingRosterAt: tickedRosterPlace)
    #expect(ticked.recordState == .kept)
}

@MainActor
@Test("ticking a row on a day screen that is not keeping a record changes nothing and keeps nothing")
func tickingARowOnADayScreenThatIsNotKeepingARecordChangesNothingAndKeepsNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a record".utf8).write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    try screen.tick(screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.recordState == .unreadable)
}

@MainActor
@Test("a day screen opened where the record cannot be read leaves what is at the place as it was")
func aDayScreenOpenedWhereTheRecordCannotBeReadLeavesWhatIsAtThePlaceAsItWas() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data("not a record".utf8)
    try bytes.write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    try screen.tick(screen.dayView.rows[0])

    #expect(try Data(contentsOf: place) == bytes)
}

@MainActor
@Test(
    "ticking a row on a day screen holding a record from a later version keeps nothing and leaves the record as it was"
)
func tickingARowOnADayScreenHoldingARecordFromALaterVersionKeepsNothingAndLeavesTheRecordAsItWas()
    throws
{
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(#"{"version": 2, "ticks": []}"#.utf8)
    try bytes.write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    try screen.tick(screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.recordState == .writtenByALaterVersion)
    #expect(try Data(contentsOf: place) == bytes)
}

@MainActor
@Test("a day screen shown again on a later day holds that day's day view")
func aDayScreenShownAgainOnALaterDayHoldsThatDaysDayView() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.tuesday, .thursday, .sunday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let screen = DayScreen(startingFrom: [gym, run], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    screen.shown(asOf: tuesday)

    #expect(screen.dayView.rows.map(\.name) == ["Run"])
}

@MainActor
@Test("a day screen shown again on the day it is already on holds that day's day view")
func aDayScreenShownAgainOnTheDayItIsAlreadyOnHoldsThatDaysDayView() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    let opened = screen.dayView
    screen.shown(asOf: monday)

    #expect(screen.dayView == opened)
}

@MainActor
@Test("a day screen shown again reads the record again")
func aDayScreenShownAgainReadsTheRecordAgain() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    let other = try RecordStore(at: place)
    try other.add(Tick(gym, on: monday)!)

    screen.shown(asOf: monday)

    #expect(screen.dayView.rows[0].isKept)
}

@MainActor
@Test(
    "a day screen that could not read its record starts keeping one when it is shown again and the record can be read"
)
func aDayScreenThatCouldNotReadItsRecordStartsKeepingOneWhenItIsShownAgainAndTheRecordCanBeRead()
    throws
{
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a record".utf8).write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: place)
    let recovered = try RecordStore(at: place)
    try recovered.add(Tick(gym, on: monday)!)

    screen.shown(asOf: monday)

    #expect(screen.recordState == .kept)
    #expect(screen.dayView.rows[0].isKept)
}

@MainActor
@Test(
    "a day screen that was keeping a record stops when it is shown again and the record cannot be read"
)
func aDayScreenThatWasKeepingARecordStopsWhenItIsShownAgainAndTheRecordCannotBeRead() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a record".utf8).write(to: place)

    screen.shown(asOf: monday)

    #expect(screen.recordState == .unreadable)
    #expect(!screen.dayView.rows[0].isKept)
}

@MainActor
@Test("a day screen shown again where the record is from a later version says so")
func aDayScreenShownAgainWhereTheRecordIsFromALaterVersionSaysSo() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"version": 2, "ticks": []}"#.utf8).write(to: place)

    screen.shown(asOf: monday)

    #expect(screen.recordState == .writtenByALaterVersion)
    #expect(!screen.dayView.rows[0].isKept)
}

@MainActor
@Test("a day screen says the day it is showing")
func aDayScreenSaysTheDayItIsShowing() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let thursday = CalendarDate(year: 2026, month: 9, day: 3)!

    let screen = DayScreen(startingFrom: [journaling], asOf: thursday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    #expect(screen.title == "Today · Thursday 3 September 2026")
}

@MainActor
@Test("a day screen says the day it was handed rather than the day it really is")
func aDayScreenSaysTheDayItWasHandedRatherThanTheDayItReallyIs() {
    let firstKeptFrom = CalendarDate(year: 1583, month: 1, day: 1)!
    let firstJournaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: firstKeptFrom)!
    let firstSupported = CalendarDate(year: 1583, month: 1, day: 3)!

    let onFirstSupportedPlaces = freshPlaces()
    let onFirstSupported = DayScreen(
        startingFrom: [firstJournaling], asOf: firstSupported,
        keepingRecordAt: onFirstSupportedPlaces.record,
        keepingRosterAt: onFirstSupportedPlaces.roster)

    #expect(onFirstSupported.title == "Today · Monday 3 January 1583")

    let lastJournaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: firstKeptFrom)!
    let lastSupported = CalendarDate(year: 9999, month: 12, day: 27)!

    let onLastSupportedPlaces = freshPlaces()
    let onLastSupported = DayScreen(
        startingFrom: [lastJournaling], asOf: lastSupported,
        keepingRecordAt: onLastSupportedPlaces.record,
        keepingRosterAt: onLastSupportedPlaces.roster)

    #expect(onLastSupported.title == "Today · Monday 27 December 9999")
}

@MainActor
@Test("a day screen says the day its own day view says, asked as of the day it was handed")
func aDayScreenSaysTheDayItsOwnDayViewSaysAskedAsOfTheDayItWasHanded() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screenPlaces = freshPlaces()
    let screen = DayScreen(
        startingFrom: [gym], asOf: monday,
        keepingRecordAt: screenPlaces.record, keepingRosterAt: screenPlaces.roster)

    #expect(screen.title == screen.dayView.title(asOf: monday))
}

@MainActor
@Test("a day screen shown again on a later day says that day")
func aDayScreenShownAgainOnALaterDaySaysThatDay() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let screenPlaces = freshPlaces()
    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday,
        keepingRecordAt: screenPlaces.record, keepingRosterAt: screenPlaces.roster)
    screen.shown(asOf: tuesday)

    #expect(screen.title == "Today · Tuesday 1 September 2026")
}

@MainActor
@Test("a day screen that cannot read its record still says the day")
func aDayScreenThatCannotReadItsRecordStillSaysTheDay() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a record".utf8).write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    #expect(screen.recordState == .unreadable)
    #expect(screen.title == "Today · Monday 31 August 2026")
}

@MainActor
@Test("a day screen says the same day after a tick is made on it")
func aDayScreenSaysTheSameDayAfterATickIsMadeOnIt() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    try screen.tick(screen.dayView.rows[0])

    #expect(screen.title == "Today · Monday 31 August 2026")
}

@MainActor
@Test("a day screen does not change day when a tick is made on it")
func aDayScreenDoesNotChangeDayWhenATickIsMadeOnIt() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.tuesday, .thursday, .sunday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym, run], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    try screen.tick(screen.dayView.rows[0])

    var expectedHistory = History()
    expectedHistory.add(Tick(gym, on: monday)!)
    let expected = DayView(of: [gym, run], on: monday, in: expectedHistory)

    #expect(screen.dayView == expected)
}

@MainActor
@Test("a day screen moved to the day before shows the previous day")
func aDayScreenMovedToTheDayBeforeShowsThePreviousDay() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!

    let screen = DayScreen(startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    screen.showPreviousDay()

    let expected = DayView(of: [gym, journaling], on: sunday, in: History())
    #expect(screen.dayView == expected)
    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
}

@MainActor
@Test("a day screen moved to the day after shows the next day")
func aDayScreenMovedToTheDayAfterShowsTheNextDay() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let screen = DayScreen(startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    screen.showNextDay()

    let expected = DayView(of: [gym, journaling], on: tuesday, in: History())
    #expect(screen.dayView == expected)
    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
}

@MainActor
@Test("moving a day screen does not change the today it was handed")
func movingADayScreenDoesNotChangeTheTodayItWasHanded() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    screen.showNextDay()

    #expect(screen.title == "Tuesday 1 September 2026")

    screen.showPreviousDay()

    #expect(screen.title == "Today · Monday 31 August 2026")
}

@MainActor
@Test("a day screen moves onto a day that has not arrived and shows it")
func aDayScreenMovesOntoADayThatHasNotArrivedAndShowsIt() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let friday = CalendarDate(year: 2026, month: 9, day: 4)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    for _ in 0..<4 {
        screen.showNextDay()
    }

    let expected = DayView(of: [journaling], on: friday, in: History())
    #expect(screen.dayView == expected)
    #expect(screen.title == "Friday 4 September 2026")
}

@MainActor
@Test("a day screen moves back to a day before every commitment was kept from and shows no rows")
func aDayScreenMovesBackToADayBeforeEveryCommitmentWasKeptFromAndShowsNoRows() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let thursday = CalendarDate(year: 2026, month: 1, day: 1)!

    let screen = DayScreen(startingFrom: [journaling], asOf: thursday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    let opened = screen.dayView
    screen.showPreviousDay()

    #expect(screen.dayView.rows.isEmpty)

    screen.showNextDay()

    #expect(screen.dayView == opened)
}

@MainActor
@Test("moving a day screen does not read the record again")
func movingADayScreenDoesNotReadTheRecordAgain() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    let other = try RecordStore(at: place)
    try other.add(Tick(journaling, on: sunday)!)

    screen.showPreviousDay()

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.recordState == .kept)
}

@MainActor
@Test("moving a day screen away and back shows the day it started from")
func movingADayScreenAwayAndBackShowsTheDayItStartedFrom() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    let opened = screen.dayView

    screen.showNextDay()
    screen.showPreviousDay()

    #expect(screen.dayView == opened)

    screen.showPreviousDay()
    screen.showNextDay()

    #expect(screen.dayView == opened)
}

@MainActor
@Test("a day screen that is not keeping a record moves and goes on saying it is keeping none")
func aDayScreenThatIsNotKeepingARecordMovesAndGoesOnSayingItIsKeepingNone() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a record".utf8).write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    screen.showPreviousDay()

    let expected = DayView(of: [journaling], on: sunday, in: History())
    #expect(screen.dayView == expected)
    #expect(screen.recordState == .unreadable)
}

@MainActor
@Test("a day screen moved into the past goes back to today in one step")
func aDayScreenMovedIntoThePastGoesBackToTodayInOneStep() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    let opened = screen.dayView

    for _ in 0..<3 {
        screen.showPreviousDay()
    }
    screen.showToday()

    #expect(screen.dayView == opened)
    #expect(screen.title == "Today · Monday 31 August 2026")
}

@MainActor
@Test("a day screen moved into the future goes back to today in one step")
func aDayScreenMovedIntoTheFutureGoesBackToTodayInOneStep() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    let opened = screen.dayView

    for _ in 0..<3 {
        screen.showNextDay()
    }
    screen.showToday()

    #expect(screen.dayView == opened)
    #expect(screen.title == "Today · Monday 31 August 2026")
}

@MainActor
@Test("a day screen already showing today is left where it is when it is sent back to today")
func aDayScreenAlreadyShowingTodayIsLeftWhereItIsWhenItIsSentBackToToday() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    let opened = screen.dayView

    screen.showToday()

    #expect(screen.dayView == opened)
    #expect(screen.title == "Today · Monday 31 August 2026")
}

@MainActor
@Test("a day screen goes back to the today it was last handed rather than the day it opened on")
func aDayScreenGoesBackToTheTodayItWasLastHandedRatherThanTheDayItOpenedOn() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    screen.shown(asOf: wednesday)

    screen.showPreviousDay()
    screen.showPreviousDay()
    screen.showToday()

    #expect(screen.title == "Today · Wednesday 2 September 2026")
}

@MainActor
@Test("going back to today does not read the record again")
func goingBackToTodayDoesNotReadTheRecordAgain() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    screen.showPreviousDay()

    let other = try RecordStore(at: place)
    try other.add(Tick(journaling, on: monday)!)

    screen.showToday()

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.recordState == .kept)
}

@MainActor
@Test("a day screen showing the first supported date is unchanged when it is moved to the day before")
func aDayScreenShowingTheFirstSupportedDateIsUnchangedWhenItIsMovedToTheDayBefore() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 1583, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 1583, month: 1, day: 2)!
    let saturday = CalendarDate(year: 1583, month: 1, day: 1)!

    let screen = DayScreen(startingFrom: [journaling], asOf: sunday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    screen.showPreviousDay()
    screen.showPreviousDay()

    let expected = DayView(of: [journaling], on: saturday, in: History())
    #expect(screen.dayView == expected)
    #expect(screen.title == "Saturday 1 January 1583")
    #expect(screen.recordState == .kept)
}

@MainActor
@Test("a day screen showing the last supported date is unchanged when it is moved to the day after")
func aDayScreenShowingTheLastSupportedDateIsUnchangedWhenItIsMovedToTheDayAfter() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 1583, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let thursday = CalendarDate(year: 9999, month: 12, day: 30)!
    let friday = CalendarDate(year: 9999, month: 12, day: 31)!

    let screen = DayScreen(startingFrom: [journaling], asOf: thursday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    screen.showNextDay()
    screen.showNextDay()

    let expected = DayView(of: [journaling], on: friday, in: History())
    #expect(screen.dayView == expected)
    #expect(screen.title == "Friday 31 December 9999")
    #expect(screen.recordState == .kept)
}

@MainActor
@Test("a day screen at either end of the calendar still moves the other way")
func aDayScreenAtEitherEndOfTheCalendarStillMovesTheOtherWay() {
    let (firstPlace, firstRosterPlace) = freshPlaces()
    let (secondPlace, secondRosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 1583, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let firstSupported = CalendarDate(year: 1583, month: 1, day: 1)!
    let lastSupported = CalendarDate(year: 9999, month: 12, day: 31)!

    let first = DayScreen(startingFrom: [journaling], asOf: firstSupported, keepingRecordAt: firstPlace, keepingRosterAt: firstRosterPlace)
    let second = DayScreen(startingFrom: [journaling], asOf: lastSupported, keepingRecordAt: secondPlace, keepingRosterAt: secondRosterPlace)

    first.showPreviousDay()
    first.showNextDay()

    #expect(first.title == "Sunday 2 January 1583")

    second.showNextDay()
    second.showPreviousDay()

    #expect(second.title == "Thursday 30 December 9999")
}

@MainActor
@Test("ticking a row on a day a day screen has moved back to keeps the tick on that day")
func tickingARowOnADayADayScreenHasMovedBackToKeepsTheTickOnThatDay() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    screen.showPreviousDay()
    try screen.tick(screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].isKept)

    let sundayScreen = DayScreen(startingFrom: [journaling], asOf: sunday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    #expect(sundayScreen.dayView.rows[0].isKept)

    let mondayScreen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    #expect(!mondayScreen.dayView.rows[0].isKept)
}

@MainActor
@Test("ticking a row on a day a day screen has moved onto that has not arrived keeps nothing")
func tickingARowOnADayADayScreenHasMovedOntoThatHasNotArrivedKeepsNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    screen.showNextDay()
    try screen.tick(screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)

    let tuesdayScreen = DayScreen(startingFrom: [journaling], asOf: tuesday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    #expect(!tuesdayScreen.dayView.rows[0].isKept)
}

@MainActor
@Test("a day screen moved off today keeps the day it is showing when the app is shown again")
func aDayScreenMovedOffTodayKeepsTheDayItIsShowingWhenTheAppIsShownAgain() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!

    let screen = DayScreen(startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    screen.showPreviousDay()
    screen.shown(asOf: wednesday)

    let expected = DayView(of: [gym, journaling], on: sunday, in: History())
    #expect(screen.dayView == expected)
    #expect(screen.title == "Sunday 30 August 2026")
}

@MainActor
@Test("a day screen moved away and back onto today moves onto the new day when the app is shown again")
func aDayScreenMovedAwayAndBackOntoTodayMovesOntoTheNewDayWhenTheAppIsShownAgain() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!

    let screen = DayScreen(startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    screen.showPreviousDay()
    screen.showNextDay()
    screen.shown(asOf: wednesday)

    let expected = DayView(of: [gym, journaling], on: wednesday, in: History())
    #expect(screen.dayView == expected)
    #expect(screen.title == "Today · Wednesday 2 September 2026")
}

@MainActor
@Test("a day screen sent back to today moves onto the new day when the app is shown again")
func aDayScreenSentBackToTodayMovesOntoTheNewDayWhenTheAppIsShownAgain() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    for _ in 0..<3 {
        screen.showPreviousDay()
    }
    screen.showToday()
    screen.shown(asOf: wednesday)

    #expect(screen.title == "Today · Wednesday 2 September 2026")
}

@MainActor
@Test("a day screen kept on a day that has since arrived offers the tick it refused before")
func aDayScreenKeptOnADayThatHasSinceArrivedOffersTheTickItRefusedBefore() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    screen.showNextDay()
    try screen.tick(screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)

    screen.shown(asOf: tuesday)

    #expect(screen.title == "Today · Tuesday 1 September 2026")

    try screen.tick(screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].isKept)
}

@MainActor
@Test("a day screen moved off today reads its record again when the app is shown again")
func aDayScreenMovedOffTodayReadsItsRecordAgainWhenTheAppIsShownAgain() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    screen.showPreviousDay()

    let other = try RecordStore(at: place)
    try other.add(Tick(journaling, on: sunday)!)

    screen.shown(asOf: monday)

    #expect(screen.dayView.rows[0].isKept)
    #expect(screen.title == "Sunday 30 August 2026")
}

@MainActor
@Test("a day screen moved to another day says that day and does not say Today")
func aDayScreenMovedToAnotherDaySaysThatDayAndDoesNotSayToday() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let thursday = CalendarDate(year: 2026, month: 9, day: 3)!

    let screen = DayScreen(startingFrom: [journaling], asOf: thursday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    screen.showPreviousDay()

    #expect(screen.title == "Wednesday 2 September 2026")

    screen.showPreviousDay()

    #expect(screen.title == "Tuesday 1 September 2026")
}

@MainActor
@Test("a day screen sent back onto today says Today again")
func aDayScreenSentBackOntoTodaySaysTodayAgain() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let thursday = CalendarDate(year: 2026, month: 9, day: 3)!

    let screen = DayScreen(startingFrom: [journaling], asOf: thursday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    screen.showPreviousDay()
    screen.showPreviousDay()
    screen.showToday()

    #expect(screen.title == "Today · Thursday 3 September 2026")
}

@MainActor
@Test("a day screen draws the commitments its roster keeps, in the order they were taken on")
func aDayScreenDrawsTheCommitmentsItsRosterKeepsInTheOrderTheyWereTakenOn() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let supplements = Commitment(
        name: "Supplements and habits", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(journaling)
    try rosterStore.add(supplements)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    #expect(screen.dayView.rows.map(\.name) == ["Journaling", "Supplements and habits"])
    #expect(screen.rosterState == .kept)
}

@MainActor
@Test("a day screen draws a commitment on the day it was kept until and not on the day after it")
func aDayScreenDrawsACommitmentOnTheDayItWasKeptUntilAndNotOnTheDayAfterIt() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(journaling)
    try rosterStore.retire(journaling, keptUntil: sunday)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    #expect(screen.dayView.rows.isEmpty)

    screen.showPreviousDay()

    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
}

@MainActor
@Test("moving a day screen does not read its roster again")
func movingADayScreenDoesNotReadItsRosterAgain() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(journaling)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let other = try RosterStore(at: rosterPlace)
    try other.add(gym)

    screen.showPreviousDay()
    screen.showNextDay()

    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
    #expect(screen.rosterState == .kept)
}

@MainActor
@Test("a tick made on a day screen leaves what is kept at its roster place as it was")
func aTickMadeOnADayScreenLeavesWhatIsKeptAtItsRosterPlaceAsItWas() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace)
    let bytesAfterOpen = try Data(contentsOf: rosterPlace)

    try screen.tick(screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].isKept)
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpen)
}

@MainActor
@Test("a day screen opened where no roster has been kept takes on the commitments it was handed")
func aDayScreenOpenedWhereNoRosterHasBeenKeptTakesOnTheCommitmentsItWasHanded() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace)

    #expect(screen.dayView.rows.map(\.name) == ["Gym", "Journaling"])

    let later = try RosterStore(at: rosterPlace)
    #expect(later.roster.commitments == [gym, journaling])
}

@MainActor
@Test("a day screen opened a second time does not take the commitments on again")
func aDayScreenOpenedASecondTimeDoesNotTakeTheCommitmentsOnAgain() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!

    _ = DayScreen(
        startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace)

    let other = try RosterStore(at: rosterPlace)
    try other.retire(gym, keptUntil: sunday)

    let second = DayScreen(
        startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace)

    #expect(second.dayView.rows.map(\.name) == ["Journaling"])

    let later = try RosterStore(at: rosterPlace)
    var expected = Roster()
    _ = expected.add(gym)
    _ = expected.add(journaling)
    _ = expected.retire(gym, keptUntil: sunday)
    #expect(later.roster == expected)
}

@MainActor
@Test("a day screen opened on a roster whose commitments have all been stopped takes nothing on")
func aDayScreenOpenedOnARosterWhoseCommitmentsHaveAllBeenStoppedTakesNothingOn() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(journaling)
    try rosterStore.retire(journaling, keptUntil: sunday)

    let screen = DayScreen(
        startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    #expect(screen.dayView.rows.isEmpty)

    let later = try RosterStore(at: rosterPlace)
    var expected = Roster()
    _ = expected.add(journaling)
    _ = expected.retire(journaling, keptUntil: sunday)
    #expect(later.roster == expected)
}

@MainActor
@Test(
    "a day screen that cannot read its roster takes nothing on and leaves what is at the place as it was"
)
func aDayScreenThatCannotReadItsRosterTakesNothingOnAndLeavesWhatIsAtThePlaceAsItWas() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data("not what a roster is written as".utf8)
    try bytes.write(to: rosterPlace)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    #expect(try Data(contentsOf: rosterPlace) == bytes)
    #expect(screen.dayView.rows.isEmpty)
}

@MainActor
@Test("a day screen that could not keep the commitments it was handed says it is not keeping a roster")
func aDayScreenThatCouldNotKeepTheCommitmentsItWasHandedSaysItIsNotKeepingARoster() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    let rosterPlace = blocker.appendingPathComponent("roster.json")
    let place = directory.appendingPathComponent("record.json")

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace)

    #expect(screen.rosterState == .notKept)
    #expect(screen.dayView.rows.isEmpty)
    #expect(screen.recordState == .kept)
}

@MainActor
@Test("a day screen shown again on a roster that holds nothing takes the commitments on again")
func aDayScreenShownAgainOnARosterThatHoldsNothingTakesTheCommitmentsOnAgain() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace)

    try Data(#"{"version": 1, "commitments": []}"#.utf8).write(to: rosterPlace)

    screen.shown(asOf: monday)

    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])

    let later = try RosterStore(at: rosterPlace)
    #expect(later.roster.commitments == [journaling])
}

@MainActor
@Test("the place a day screen keeps its roster is under Application Support, in a directory of the app's own")
func thePlaceADayScreenKeepsItsRosterIsUnderApplicationSupportInADirectoryOfTheAppsOwn() {
    let applicationSupport = FileManager.default.urls(
        for: .applicationSupportDirectory, in: .userDomainMask)[0]

    let place = DayScreen.rosterPlace

    #expect(place.path.hasPrefix(applicationSupport.path))
    let containingDirectory = place.deletingLastPathComponent()
    #expect(containingDirectory != applicationSupport)
    #expect(containingDirectory.path.hasPrefix(applicationSupport.path))
}

@MainActor
@Test("the place a day screen keeps its roster is neither the caches directory nor the temporary directory")
func thePlaceADayScreenKeepsItsRosterIsNeitherTheCachesDirectoryNorTheTemporaryDirectory() {
    let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    let temporary = FileManager.default.temporaryDirectory

    let place = DayScreen.rosterPlace

    #expect(!place.path.hasPrefix(caches.path))
    #expect(!place.path.hasPrefix(temporary.path))
}

@MainActor
@Test("the place a day screen keeps its roster is the same place every time it is asked")
func thePlaceADayScreenKeepsItsRosterIsTheSamePlaceEveryTimeItIsAsked() {
    #expect(DayScreen.rosterPlace == DayScreen.rosterPlace)
}

@MainActor
@Test("the place a day screen keeps its roster is not the place it keeps its record")
func thePlaceADayScreenKeepsItsRosterIsNotThePlaceItKeepsItsRecord() {
    #expect(DayScreen.rosterPlace != DayScreen.recordPlace)
}

@MainActor
@Test("a day screen opened where the roster cannot be read holds no rows and says it is not keeping one")
func aDayScreenOpenedWhereTheRosterCannotBeReadHoldsNoRowsAndSaysItIsNotKeepingOne() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a roster is written as".utf8).write(to: rosterPlace)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    #expect(screen.dayView.rows.isEmpty)
    #expect(screen.rosterState == .notKept)
    #expect(screen.rosterState != .writtenByALaterVersion)
}

@MainActor
@Test(
    "a roster written in a later form than this app knows makes a day screen that says the roster is from a later version"
)
func aRosterWrittenInALaterFormThanThisAppKnowsMakesADayScreenThatSaysTheRosterIsFromALaterVersion()
    throws
{
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"version": 2, "commitments": []}"#.utf8).write(to: rosterPlace)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    #expect(screen.rosterState == .writtenByALaterVersion)
    #expect(screen.dayView.rows.isEmpty)
}

@MainActor
@Test("a day screen opened where the roster can be read says it is keeping one")
func aDayScreenOpenedWhereTheRosterCanBeReadSaysItIsKeepingOne() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let (emptyPlace, emptyRosterPlace) = freshPlaces()
    let empty = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: emptyPlace, keepingRosterAt: emptyRosterPlace)
    #expect(empty.rosterState == .kept)

    let (takenOnPlace, takenOnRosterPlace) = freshPlaces()
    let rosterStore = try RosterStore(at: takenOnRosterPlace)
    try rosterStore.add(gym)
    let takenOn = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: takenOnPlace, keepingRosterAt: takenOnRosterPlace)
    #expect(takenOn.rosterState == .kept)
}

@MainActor
@Test("a day screen that cannot read its roster still says the day and goes on keeping its record")
func aDayScreenThatCannotReadItsRosterStillSaysTheDayAndGoesOnKeepingItsRecord() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a roster is written as".utf8).write(to: rosterPlace)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    #expect(screen.title == "Today · Monday 31 August 2026")
    #expect(screen.recordState == .kept)
    #expect(screen.rosterState == .notKept)
}

@MainActor
@Test("a day screen that cannot read its record still draws the commitments its roster keeps")
func aDayScreenThatCannotReadItsRecordStillDrawsTheCommitmentsItsRosterKeeps() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a record is written as".utf8).write(to: place)

    let screen = DayScreen(startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    #expect(screen.dayView.rows.map(\.name) == ["Gym", "Journaling"])
    #expect(!screen.dayView.rows[0].isKept)
    #expect(!screen.dayView.rows[1].isKept)
    #expect(screen.recordState == .unreadable)
}

@MainActor
@Test("a day screen shown again reads its roster again")
func aDayScreenShownAgainReadsItsRosterAgain() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(journaling)

    let screen = DayScreen(startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    let other = try RosterStore(at: rosterPlace)
    try other.add(gym)

    screen.shown(asOf: monday)

    #expect(screen.dayView.rows.map(\.name) == ["Journaling", "Gym"])
}

@MainActor
@Test(
    "a day screen that could not read its roster starts keeping one when it is shown again and the roster can be read"
)
func aDayScreenThatCouldNotReadItsRosterStartsKeepingOneWhenItIsShownAgainAndTheRosterCanBeRead()
    throws
{
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a roster is written as".utf8).write(to: rosterPlace)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: rosterPlace)
    let recovered = try RosterStore(at: rosterPlace)
    try recovered.add(journaling)

    screen.shown(asOf: monday)

    #expect(screen.rosterState == .kept)
    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
}

@MainActor
@Test(
    "a day screen that was keeping a roster stops when it is shown again and the roster cannot be read"
)
func aDayScreenThatWasKeepingARosterStopsWhenItIsShownAgainAndTheRosterCannotBeRead() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace)
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"version": 2, "commitments": []}"#.utf8).write(to: rosterPlace)

    screen.shown(asOf: monday)

    #expect(screen.rosterState == .writtenByALaterVersion)
    #expect(screen.dayView.rows.isEmpty)
}
