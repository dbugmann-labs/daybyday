import Foundation
import Testing
import DayByDayKit

/// A fresh place under the temporary directory, one per test, so tests are independent and need
/// no teardown: a UUID names the directory, and the record file sits one level under it, so the
/// directory itself does not exist until something creates it. Mirrors `RecordStoreTests`'s
/// `freshPlace()`.
private func freshPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("record.json")
}

@MainActor
@Test("a day screen opened where nothing has been kept holds the day view of that day with nothing kept")
func aDayScreenOpenedWhereNothingHasBeenKeptHoldsTheDayViewOfThatDayWithNothingKept() {
    let place = freshPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.tuesday, .thursday, .sunday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(of: [gym, run], asOf: monday, keeping: place)

    #expect(screen.dayView.rows.map(\.name) == ["Gym"])
    #expect(!screen.dayView.rows[0].isKept)
}

@MainActor
@Test("a day screen opened where a tick was kept holds a day view that says the commitment is kept")
func aDayScreenOpenedWhereATickWasKeptHoldsADayViewThatSaysTheCommitmentIsKept() throws {
    let place = freshPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tick = Tick(gym, on: monday)!

    let store = try RecordStore(at: place)
    try store.add(tick)

    let screen = DayScreen(of: [gym], asOf: monday, keeping: place)

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

    let onFirstSupported = DayScreen(of: [gym], asOf: firstSupported, keeping: freshPlace())
    let onLastSupported = DayScreen(of: [gym], asOf: lastSupported, keeping: freshPlace())

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
    let place = freshPlace()
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

    let screen = DayScreen(of: [gym, journaling], asOf: monday, keeping: place)

    var expectedHistory = History()
    expectedHistory.add(gymTick)
    let expected = DayView(of: [gym, journaling], on: monday, in: expectedHistory)

    #expect(screen.dayView == expected)
}

@MainActor
@Test("ticking a row that says its commitment is not kept makes the day screen say it is kept")
func tickingARowThatSaysItsCommitmentIsNotKeptMakesTheDayScreenSayItIsKept() throws {
    let place = freshPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(of: [gym], asOf: monday, keeping: place)
    let row = screen.dayView.rows[0]

    try screen.tick(row)

    #expect(screen.dayView.rows[0].isKept)
}

@MainActor
@Test("ticking a row that says its commitment is kept takes the tick back")
func tickingARowThatSaysItsCommitmentIsKeptTakesTheTickBack() throws {
    let place = freshPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(of: [gym], asOf: monday, keeping: place)
    let opened = screen.dayView
    try screen.tick(screen.dayView.rows[0])
    try screen.tick(screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.dayView == opened)
}

@MainActor
@Test("a tick made on a day screen is held by a day screen opened afterwards at the same place")
func aTickMadeOnADayScreenIsHeldByADayScreenOpenedAfterwardsAtTheSamePlace() throws {
    let place = freshPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let first = DayScreen(of: [gym], asOf: monday, keeping: place)
    try first.tick(first.dayView.rows[0])

    let second = DayScreen(of: [gym], asOf: monday, keeping: place)

    #expect(second.dayView.rows[0].isKept)
}

@MainActor
@Test(
    "a tick taken back on a day screen is not held by a day screen opened afterwards at the same place"
)
func aTickTakenBackOnADayScreenIsNotHeldByADayScreenOpenedAfterwardsAtTheSamePlace() throws {
    let place = freshPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let first = DayScreen(of: [gym], asOf: monday, keeping: place)
    try first.tick(first.dayView.rows[0])
    try first.tick(first.dayView.rows[0])

    let second = DayScreen(of: [gym], asOf: monday, keeping: place)

    #expect(!second.dayView.rows[0].isKept)
}

@MainActor
@Test("ticking one row leaves the other rows of the day as they were")
func tickingOneRowLeavesTheOtherRowsOfTheDayAsTheyWere() throws {
    let place = freshPlace()
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

    let screen = DayScreen(of: [gym, journaling, supplements], asOf: monday, keeping: place)
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

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(of: [gym], asOf: monday, keeping: place)

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(screen.dayView.rows[0])
    }
    #expect(!screen.dayView.rows[0].isKept)

    let later = DayScreen(of: [gym], asOf: monday, keeping: place)
    #expect(!later.dayView.rows[0].isKept)
}

@MainActor
@Test("a row the day screen's day view does not hold changes nothing")
func aRowTheDayScreensDayViewDoesNotHoldChangesNothing() throws {
    let place = freshPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!

    let mondayScreen = DayScreen(of: [gym], asOf: monday, keeping: place)
    let wednesdayScreen = DayScreen(of: [gym], asOf: wednesday, keeping: place)

    try mondayScreen.tick(wednesdayScreen.dayView.rows[0])

    #expect(!mondayScreen.dayView.rows[0].isKept)

    let laterOnWednesday = DayScreen(of: [gym], asOf: wednesday, keeping: place)
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
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a record".utf8).write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.tuesday, .thursday, .sunday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(of: [gym, run], asOf: monday, keeping: place)

    #expect(screen.dayView.rows.map(\.name) == ["Gym"])
    #expect(!screen.dayView.rows[0].isKept)
}

@MainActor
@Test(
    "a day screen opened where the record cannot be read says it is not keeping one and gives no further reason"
)
func aDayScreenOpenedWhereTheRecordCannotBeReadSaysItIsNotKeepingOneAndGivesNoFurtherReason() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a record".utf8).write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(of: [gym], asOf: monday, keeping: place)

    #expect(screen.recordState == .unreadable)
}

@MainActor
@Test(
    "a record written in a later form than this app knows makes a day screen that says the record is from a later version"
)
func aRecordWrittenInALaterFormThanThisAppKnowsMakesADayScreenThatSaysTheRecordIsFromALaterVersion()
    throws
{
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"version": 2, "ticks": []}"#.utf8).write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(of: [gym], asOf: monday, keeping: place)

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

    let emptyPlace = freshPlace()
    let empty = DayScreen(of: [gym], asOf: monday, keeping: emptyPlace)
    #expect(empty.recordState == .kept)

    let tickedPlace = freshPlace()
    let store = try RecordStore(at: tickedPlace)
    try store.add(Tick(gym, on: monday)!)
    let ticked = DayScreen(of: [gym], asOf: monday, keeping: tickedPlace)
    #expect(ticked.recordState == .kept)
}

@MainActor
@Test("ticking a row on a day screen that is not keeping a record changes nothing and keeps nothing")
func tickingARowOnADayScreenThatIsNotKeepingARecordChangesNothingAndKeepsNothing() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a record".utf8).write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(of: [gym], asOf: monday, keeping: place)

    try screen.tick(screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.recordState == .unreadable)
}

@MainActor
@Test("a day screen opened where the record cannot be read leaves what is at the place as it was")
func aDayScreenOpenedWhereTheRecordCannotBeReadLeavesWhatIsAtThePlaceAsItWas() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data("not a record".utf8)
    try bytes.write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(of: [gym], asOf: monday, keeping: place)
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
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(#"{"version": 2, "ticks": []}"#.utf8)
    try bytes.write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(of: [gym], asOf: monday, keeping: place)
    try screen.tick(screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.recordState == .writtenByALaterVersion)
    #expect(try Data(contentsOf: place) == bytes)
}

@MainActor
@Test("a day screen shown again on a later day holds that day's day view")
func aDayScreenShownAgainOnALaterDayHoldsThatDaysDayView() {
    let place = freshPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.tuesday, .thursday, .sunday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let screen = DayScreen(of: [gym, run], asOf: monday, keeping: place)
    screen.shown(asOf: tuesday)

    #expect(screen.dayView.rows.map(\.name) == ["Run"])
}

@MainActor
@Test("a day screen shown again on the day it is already on holds that day's day view")
func aDayScreenShownAgainOnTheDayItIsAlreadyOnHoldsThatDaysDayView() {
    let place = freshPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(of: [gym], asOf: monday, keeping: place)
    let opened = screen.dayView
    screen.shown(asOf: monday)

    #expect(screen.dayView == opened)
}

@MainActor
@Test("a day screen shown again reads the record again")
func aDayScreenShownAgainReadsTheRecordAgain() throws {
    let place = freshPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(of: [gym], asOf: monday, keeping: place)
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
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a record".utf8).write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(of: [gym], asOf: monday, keeping: place)

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
    let place = freshPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(of: [gym], asOf: monday, keeping: place)
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
    let place = freshPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(of: [gym], asOf: monday, keeping: place)
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
    let place = freshPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let thursday = CalendarDate(year: 2026, month: 9, day: 3)!

    let screen = DayScreen(of: [journaling], asOf: thursday, keeping: place)

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

    let onFirstSupported = DayScreen(of: [firstJournaling], asOf: firstSupported, keeping: freshPlace())

    #expect(onFirstSupported.title == "Today · Monday 3 January 1583")

    let lastJournaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: firstKeptFrom)!
    let lastSupported = CalendarDate(year: 9999, month: 12, day: 27)!

    let onLastSupported = DayScreen(of: [lastJournaling], asOf: lastSupported, keeping: freshPlace())

    #expect(onLastSupported.title == "Today · Monday 27 December 9999")
}

@MainActor
@Test("a day screen says the day its own day view says, asked as of the day it was handed")
func aDayScreenSaysTheDayItsOwnDayViewSaysAskedAsOfTheDayItWasHanded() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(of: [gym], asOf: monday, keeping: freshPlace())

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

    let screen = DayScreen(of: [journaling], asOf: monday, keeping: freshPlace())
    screen.shown(asOf: tuesday)

    #expect(screen.title == "Today · Tuesday 1 September 2026")
}

@MainActor
@Test("a day screen that cannot read its record still says the day")
func aDayScreenThatCannotReadItsRecordStillSaysTheDay() throws {
    let place = freshPlace()
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

    let screen = DayScreen(of: [journaling], asOf: monday, keeping: place)

    #expect(screen.recordState == .unreadable)
    #expect(screen.title == "Today · Monday 31 August 2026")
}

@MainActor
@Test("a day screen says the same day after a tick is made on it")
func aDayScreenSaysTheSameDayAfterATickIsMadeOnIt() throws {
    let place = freshPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(of: [gym], asOf: monday, keeping: place)
    try screen.tick(screen.dayView.rows[0])

    #expect(screen.title == "Today · Monday 31 August 2026")
}

@MainActor
@Test("a day screen does not change day when a tick is made on it")
func aDayScreenDoesNotChangeDayWhenATickIsMadeOnIt() throws {
    let place = freshPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.tuesday, .thursday, .sunday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(of: [gym, run], asOf: monday, keeping: place)
    try screen.tick(screen.dayView.rows[0])

    var expectedHistory = History()
    expectedHistory.add(Tick(gym, on: monday)!)
    let expected = DayView(of: [gym, run], on: monday, in: expectedHistory)

    #expect(screen.dayView == expected)
}
