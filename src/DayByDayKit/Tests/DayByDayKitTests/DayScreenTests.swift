import Foundation
import Testing
@testable import DayByDayKit

/// A fresh path for a one-off place nothing has been kept at, under its own fresh temporary
/// directory. None of the tests below exercise a day screen's one-off place except those in
/// § 5 of `tasks.md`, so passing a fresh one of these at every other `DayScreen(` opening — rather
/// than reusing one across a test's several screens — changes no assertion; it only keeps every
/// opening off the machine's own default place. `design.md` § *The shipped tests pass a one-off
/// place of their own*.
private func freshOneOffPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("one-offs.json")
}

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

/// Makes `directory` read-only: a file inside it still reads, `createDirectory` on it still
/// succeeds, and a write inside it fails with `NSCocoaErrorDomain 513` — which `RecordStore.write`
/// turns into `.cannotWrite`. `design.md` § *Context* proves this end to end on this machine.
/// Every caller must pair this with `makeWritable(_:)` before returning, including on its failure
/// path, or the directory is left unreadable behind it.
private func makeReadOnly(_ directory: URL) throws {
    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
}

/// Undoes `makeReadOnly(_:)`, restoring `directory` to a place that can be written to again.
private func makeWritable(_ directory: URL) throws {
    try FileManager.default.setAttributes([.posixPermissions: 0o700], ofItemAtPath: directory.path)
}

/// A fresh pair of places under one fresh temporary directory where the record cannot be
/// written: `blocker` is an ordinary file, not a directory, and the record path sits beneath
/// it, so any write through it fails and `RecordStore.write` turns that into `.cannotWrite`.
/// The roster path sits beside the blocker, unaffected. A UUID names the directory each call,
/// so tests stay independent.
private func blockerPlaces() throws -> (record: URL, roster: URL) {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    return (
        blocker.appendingPathComponent("record.json"),
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

    let screen = DayScreen(startingFrom: [gym, run], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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
        keepingRosterAt: onFirstSupportedPlaces.roster, keepingOneOffsAt: freshOneOffPlace())
    let onLastSupportedPlaces = freshPlaces()
    let onLastSupported = DayScreen(
        startingFrom: [gym], asOf: lastSupported,
        keepingRecordAt: onLastSupportedPlaces.record,
        keepingRosterAt: onLastSupportedPlaces.roster, keepingOneOffsAt: freshOneOffPlace())

    #expect(
        onFirstSupported.dayView
            == DayView(of: [Roster.Group(category: nil, commitments: [gym])], oneOffs: OneOffs(), asOf: firstSupported, on: firstSupported, in: History()))
    #expect(
        onLastSupported.dayView
            == DayView(of: [Roster.Group(category: nil, commitments: [gym])], oneOffs: OneOffs(), asOf: lastSupported, on: lastSupported, in: History()))
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

    let screen = DayScreen(startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    var expectedHistory = History()
    expectedHistory.add(gymTick)
    let expected = DayView(of: [Roster.Group(category: nil, commitments: [gym, journaling])], oneOffs: OneOffs(), asOf: monday, on: monday, in: expectedHistory)

    #expect(screen.dayView == expected)
}

@MainActor
@Test("ticking a row that says its commitment is kept takes the tick back")
func tickingARowThatSaysItsCommitmentIsKeptTakesTheTickBack() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let opened = screen.dayView
    try screen.tick(screen.dayView.rows[0])
    try screen.tick(screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.dayView == opened)
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

    let first = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try first.tick(first.dayView.rows[0])
    try first.tick(first.dayView.rows[0])

    let second = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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

    let screen = DayScreen(startingFrom: [gym, journaling, supplements], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
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

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(screen.dayView.rows[0])
    }
    #expect(!screen.dayView.rows[0].isKept)

    let later = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
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

    let mondayScreen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let wednesdayScreen = DayScreen(startingFrom: [gym], asOf: wednesday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    try mondayScreen.tick(wednesdayScreen.dayView.rows[0])

    #expect(!mondayScreen.dayView.rows[0].isKept)

    let laterOnWednesday = DayScreen(startingFrom: [gym], asOf: wednesday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
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

    let screen = DayScreen(startingFrom: [gym, run], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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
    try Data(#"{"version": 6, "ticks": []}"#.utf8).write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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
    let empty = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: emptyPlace, keepingRosterAt: emptyRosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(empty.recordState == .kept)

    let (tickedPlace, tickedRosterPlace) = freshPlaces()
    let store = try RecordStore(at: tickedPlace)
    try store.add(Tick(gym, on: monday)!)
    let ticked = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: tickedPlace, keepingRosterAt: tickedRosterPlace, keepingOneOffsAt: freshOneOffPlace())
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

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
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
    let bytes = Data(#"{"version": 6, "ticks": []}"#.utf8)
    try bytes.write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.tick(screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.recordState == .writtenByALaterVersion)
    #expect(try Data(contentsOf: place) == bytes)
}

@MainActor
@Test("a tick made on a day screen that cannot read its record is not kept once the record can be read")
func aTickMadeOnADayScreenThatCannotReadItsRecordIsNotKeptOnceTheRecordCanBeRead() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a record".utf8).write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [gym, run], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let gymRow = screen.dayView.rows.first { $0.name == "Gym" }!
    try screen.tick(gymRow)

    try FileManager.default.removeItem(at: place)

    screen.shown(asOf: monday)

    let runRow = screen.dayView.rows.first { $0.name == "Run" }!
    try screen.tick(runRow)

    #expect(screen.recordState == .kept)
    #expect(!screen.dayView.rows.first { $0.name == "Gym" }!.isKept)
    #expect(screen.dayView.rows.first { $0.name == "Run" }!.isKept)

    let later = DayScreen(
        startingFrom: [gym, run], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(!later.dayView.rows.first { $0.name == "Gym" }!.isKept)
    #expect(later.dayView.rows.first { $0.name == "Run" }!.isKept)
}

@MainActor
@Test("a day screen whose record place cannot be opened for another reason answers as one that cannot read its record")
func aDayScreenWhoseRecordPlaceCannotBeOpenedForAnotherReasonAnswersAsOneThatCannotReadItsRecord()
    throws
{
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(at: place, withIntermediateDirectories: true)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.tick(screen.dayView.rows[0])

    #expect(screen.recordState == .unreadable)
    #expect(screen.recordState != .writtenByALaterVersion)
    #expect(screen.dayView.rows.map(\.name) == ["Gym"])
    #expect(!screen.dayView.rows[0].isKept)

    var isDirectory: ObjCBool = false
    #expect(FileManager.default.fileExists(atPath: place.path, isDirectory: &isDirectory))
    #expect(isDirectory.boolValue)
    #expect(try FileManager.default.contentsOfDirectory(atPath: place.path).isEmpty)
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

    let screen = DayScreen(startingFrom: [gym, run], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
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

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let opened = screen.dayView
    screen.shown(asOf: monday)

    #expect(screen.dayView == opened)
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

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
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

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"version": 6, "ticks": []}"#.utf8).write(to: place)

    screen.shown(asOf: monday)

    #expect(screen.recordState == .writtenByALaterVersion)
    #expect(!screen.dayView.rows[0].isKept)
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
        keepingRosterAt: onFirstSupportedPlaces.roster, keepingOneOffsAt: freshOneOffPlace())

    #expect(onFirstSupported.title == "Mon")

    let lastJournaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: firstKeptFrom)!
    let lastSupported = CalendarDate(year: 9999, month: 12, day: 31)!

    let onLastSupportedPlaces = freshPlaces()
    let onLastSupported = DayScreen(
        startingFrom: [lastJournaling], asOf: lastSupported,
        keepingRecordAt: onLastSupportedPlaces.record,
        keepingRosterAt: onLastSupportedPlaces.roster, keepingOneOffsAt: freshOneOffPlace())

    #expect(onLastSupported.title == "Fri")
}

@MainActor
@Test("a day screen says the day its own day view says")
func aDayScreenSaysTheDayItsOwnDayViewSays() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screenPlaces = freshPlaces()
    let screen = DayScreen(
        startingFrom: [gym], asOf: monday,
        keepingRecordAt: screenPlaces.record, keepingRosterAt: screenPlaces.roster, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.title == "Mon")
    #expect(screen.title == screen.dayView.title)
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
        keepingRecordAt: screenPlaces.record, keepingRosterAt: screenPlaces.roster, keepingOneOffsAt: freshOneOffPlace())
    screen.shown(asOf: tuesday)

    #expect(screen.title == "Tue")
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

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.recordState == .unreadable)
    #expect(screen.title == "Mon")
}

@MainActor
@Test("a day screen says the same day after a tick is made on it")
func aDayScreenSaysTheSameDayAfterATickIsMadeOnIt() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(screen.title == "Mon")
    try screen.tick(screen.dayView.rows[0])

    #expect(screen.title == "Mon")
}

@MainActor
@Test("a day screen says its day the same way whether or not it is showing its today")
func aDayScreenSaysItsDayTheSameWayWhetherOrNotItIsShowingItsToday() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(!screen.offersGoingBackToToday)
    #expect(screen.title == "Mon")

    for _ in 0..<7 {
        screen.showPreviousDay()
    }

    #expect(screen.title == "Mon")
    #expect(screen.offersGoingBackToToday)
}

@MainActor
@Test("a day screen showing a day picked on its day picker says that day")
func aDayScreenShowingADayPickedOnItsDayPickerSaysThatDay() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 6, day: 10)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showDay(wednesday)

    #expect(screen.title == "Wed")
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

    let screen = DayScreen(startingFrom: [gym, run], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.tick(screen.dayView.rows[0])

    var expectedHistory = History()
    expectedHistory.add(Tick(gym, on: monday)!)
    let expected = DayView(of: [Roster.Group(category: nil, commitments: [gym, run])], oneOffs: OneOffs(), asOf: monday, on: monday, in: expectedHistory)

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

    let screen = DayScreen(startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()

    let expected = DayView(of: [Roster.Group(category: nil, commitments: [gym, journaling])], oneOffs: OneOffs(), asOf: sunday, on: sunday, in: History())
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

    let screen = DayScreen(startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showNextDay()

    let expected = DayView(of: [Roster.Group(category: nil, commitments: [gym, journaling])], oneOffs: OneOffs(), asOf: tuesday, on: tuesday, in: History())
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
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showNextDay()

    #expect(screen.dayPickerReach.opensOn == tuesday)
    #expect(screen.offersGoingBackToToday)

    screen.showPreviousDay()

    #expect(screen.dayPickerReach.opensOn == monday)
    #expect(!screen.offersGoingBackToToday)
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

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    for _ in 0..<4 {
        screen.showNextDay()
    }

    let expected = DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: friday, on: friday, in: History())
    #expect(screen.dayView == expected)
    #expect(screen.dayPickerReach.opensOn == friday)
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

    let screen = DayScreen(startingFrom: [journaling], asOf: thursday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
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

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
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

    let screen = DayScreen(startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
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

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()

    let expected = DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: sunday, on: sunday, in: History())
    #expect(screen.dayView == expected)
    #expect(screen.recordState == .unreadable)
}

@MainActor
@Test("a day screen that is not keeping a roster moves and goes on saying why")
func aDayScreenThatIsNotKeepingARosterMovesAndGoesOnSayingWhy() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"version": 5, "commitments": []}"#.utf8).write(to: rosterPlace)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    screen.showPreviousDay()

    #expect(screen.dayView == DayView(of: [Roster.Group(category: nil, commitments: [Commitment]())], oneOffs: OneOffs(), asOf: sunday, on: sunday, in: History()))
    #expect(screen.rosterState == .writtenByALaterVersion)
    #expect(screen.dayView.rows.isEmpty)

    screen.showNextDay()

    #expect(screen.dayView == DayView(of: [Roster.Group(category: nil, commitments: [Commitment]())], oneOffs: OneOffs(), asOf: monday, on: monday, in: History()))
    #expect(screen.rosterState == .writtenByALaterVersion)
    #expect(screen.dayView.rows.isEmpty)
}

@MainActor
@Test("a tick kept on a day screen is still shown after it moves away and back, goes back to today or has that day picked")
func aTickKeptOnADayScreenIsStillShownAfterItMovesAwayAndBackGoesBackToTodayOrHasThatDayPicked()
    throws
{
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.tick(screen.dayView.rows[0])

    screen.showPreviousDay()
    screen.showNextDay()
    #expect(screen.dayView.rows[0].isKept)

    screen.showPreviousDay()
    screen.showToday()
    #expect(screen.dayView.rows[0].isKept)

    screen.showPreviousDay()
    screen.showDay(monday)
    #expect(screen.dayView.rows[0].isKept)
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

    let screen = DayScreen(startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let opened = screen.dayView

    for _ in 0..<3 {
        screen.showPreviousDay()
    }
    screen.showToday()

    #expect(screen.dayView == opened)
    #expect(screen.dayPickerReach.opensOn == monday)
    #expect(!screen.offersGoingBackToToday)
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

    let screen = DayScreen(startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let opened = screen.dayView

    for _ in 0..<3 {
        screen.showNextDay()
    }
    screen.showToday()

    #expect(screen.dayView == opened)
    #expect(screen.dayPickerReach.opensOn == monday)
    #expect(!screen.offersGoingBackToToday)
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

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let opened = screen.dayView

    screen.showToday()

    #expect(screen.dayView == opened)
    #expect(screen.dayPickerReach.opensOn == monday)
    #expect(!screen.offersGoingBackToToday)
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

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.shown(asOf: wednesday)

    screen.showPreviousDay()
    screen.showPreviousDay()
    screen.showToday()

    #expect(screen.dayPickerReach.opensOn == wednesday)
    #expect(!screen.offersGoingBackToToday)
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

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()

    let other = try RecordStore(at: place)
    try other.add(Tick(journaling, on: monday)!)

    screen.showToday()

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.recordState == .kept)
}

@MainActor
@Test("going back to today does not read the roster again")
func goingBackToTodayDoesNotReadTheRosterAgain() throws {
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
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()

    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let other = try RosterStore(at: rosterPlace)
    try other.add(gym)

    screen.showToday()

    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
    #expect(screen.rosterState == .kept)

    let (laterFormPlace, laterFormRosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: laterFormRosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"version": 5, "commitments": []}"#.utf8).write(to: laterFormRosterPlace)

    let laterFormScreen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: laterFormPlace,
        keepingRosterAt: laterFormRosterPlace, keepingOneOffsAt: freshOneOffPlace())
    laterFormScreen.showPreviousDay()

    try FileManager.default.removeItem(at: laterFormRosterPlace)

    laterFormScreen.showToday()

    #expect(laterFormScreen.rosterState == .writtenByALaterVersion)
    #expect(laterFormScreen.dayView.rows.isEmpty)
}

@MainActor
@Test("a day screen sent back to today draws the commitments its roster had not stopped keeping on that today")
func aDayScreenSentBackToTodayDrawsTheCommitmentsItsRosterHadNotStoppedKeepingOnThatToday() throws {
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
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()

    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])

    screen.showToday()

    #expect(screen.dayView.rows.isEmpty)
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

    let screen = DayScreen(startingFrom: [journaling], asOf: sunday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()
    screen.showPreviousDay()

    let expected = DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: saturday, on: saturday, in: History())
    #expect(screen.dayView == expected)
    #expect(screen.dayPickerReach.opensOn == saturday)
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

    let screen = DayScreen(startingFrom: [journaling], asOf: thursday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showNextDay()
    screen.showNextDay()

    let expected = DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: friday, on: friday, in: History())
    #expect(screen.dayView == expected)
    #expect(screen.dayPickerReach.opensOn == friday)
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

    let first = DayScreen(startingFrom: [journaling], asOf: firstSupported, keepingRecordAt: firstPlace, keepingRosterAt: firstRosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let second = DayScreen(startingFrom: [journaling], asOf: lastSupported, keepingRecordAt: secondPlace, keepingRosterAt: secondRosterPlace, keepingOneOffsAt: freshOneOffPlace())

    first.showPreviousDay()
    first.showNextDay()

    #expect(first.dayPickerReach.opensOn == CalendarDate(year: 1583, month: 1, day: 2)!)

    second.showNextDay()
    second.showPreviousDay()

    #expect(second.dayPickerReach.opensOn == CalendarDate(year: 9999, month: 12, day: 30)!)
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

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()
    try screen.tick(screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].isKept)

    let sundayScreen = DayScreen(startingFrom: [journaling], asOf: sunday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(sundayScreen.dayView.rows[0].isKept)

    let mondayScreen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
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

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showNextDay()
    try screen.tick(screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)

    let tuesdayScreen = DayScreen(startingFrom: [journaling], asOf: tuesday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(!tuesdayScreen.dayView.rows[0].isKept)
}

@MainActor
@Test("a tick made on a day screen does not change what it says about its roster")
func aTickMadeOnADayScreenDoesNotChangeWhatItSaysAboutItsRoster() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(screen.rosterState == .kept)

    try FileManager.default.removeItem(at: rosterPlace)
    try Data("not what a roster is written as".utf8).write(to: rosterPlace)

    try screen.tick(screen.dayView.rows[0])

    #expect(screen.rosterState == .kept)
    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
    #expect(screen.dayView.rows[0].isKept)
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

    let screen = DayScreen(startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()
    screen.shown(asOf: wednesday)

    let expected = DayView(of: [Roster.Group(category: nil, commitments: [gym, journaling])], oneOffs: OneOffs(), asOf: sunday, on: sunday, in: History())
    #expect(screen.dayView == expected)
    #expect(screen.dayPickerReach.opensOn == sunday)
    #expect(screen.offersGoingBackToToday)
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

    let screen = DayScreen(startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()
    screen.showNextDay()
    screen.shown(asOf: wednesday)

    let expected = DayView(of: [Roster.Group(category: nil, commitments: [gym, journaling])], oneOffs: OneOffs(), asOf: wednesday, on: wednesday, in: History())
    #expect(screen.dayView == expected)
    #expect(screen.dayPickerReach.opensOn == wednesday)
    #expect(!screen.offersGoingBackToToday)
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

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    for _ in 0..<3 {
        screen.showPreviousDay()
    }
    screen.showToday()
    screen.shown(asOf: wednesday)

    #expect(screen.dayPickerReach.opensOn == wednesday)
    #expect(!screen.offersGoingBackToToday)
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

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showNextDay()
    try screen.tick(screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)

    screen.shown(asOf: tuesday)

    #expect(screen.dayPickerReach.opensOn == tuesday)
    #expect(!screen.offersGoingBackToToday)

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

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()

    let other = try RecordStore(at: place)
    try other.add(Tick(journaling, on: sunday)!)

    screen.shown(asOf: monday)

    #expect(screen.dayView.rows[0].isKept)
    #expect(screen.dayPickerReach.opensOn == sunday)
}

@MainActor
@Test("a day screen moved to another day says that day")
func aDayScreenMovedToAnotherDaySaysThatDay() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let thursday = CalendarDate(year: 2026, month: 9, day: 3)!

    let screen = DayScreen(startingFrom: [journaling], asOf: thursday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()

    #expect(screen.title == "Wed")

    screen.showPreviousDay()

    #expect(screen.title == "Tue")
}

@MainActor
@Test("a day screen sent back onto today says that today's weekday")
func aDayScreenSentBackOntoTodaySaysThatTodaysWeekday() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let thursday = CalendarDate(year: 2026, month: 9, day: 3)!

    let screen = DayScreen(startingFrom: [journaling], asOf: thursday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()
    screen.showPreviousDay()
    screen.showToday()

    #expect(screen.title == "Thu")
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
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
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
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    let other = try RosterStore(at: rosterPlace)
    try other.retire(gym, keptUntil: sunday)

    let second = DayScreen(
        startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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
        startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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
        startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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
@Test("the place a day screen keeps its one-offs is a file of the app's own under Application Support")
func thePlaceADayScreenKeepsItsOneOffsIsAFileOfTheAppsOwnUnderApplicationSupport() {
    let applicationSupport = FileManager.default.urls(
        for: .applicationSupportDirectory, in: .userDomainMask)[0]
    let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    let temporary = FileManager.default.temporaryDirectory

    let place = DayScreen.oneOffPlace

    #expect(place.path.hasPrefix(applicationSupport.path))
    let containingDirectory = place.deletingLastPathComponent()
    #expect(containingDirectory != applicationSupport)
    #expect(containingDirectory.path.hasPrefix(applicationSupport.path))
    #expect(!place.path.hasPrefix(caches.path))
    #expect(!place.path.hasPrefix(temporary.path))
}

@MainActor
@Test("the place a day screen keeps its one-offs is the same place every time it is asked")
func thePlaceADayScreenKeepsItsOneOffsIsTheSamePlaceEveryTimeItIsAsked() {
    #expect(DayScreen.oneOffPlace == DayScreen.oneOffPlace)
}

@MainActor
@Test("the place a day screen keeps its one-offs is neither its record place nor its roster place")
func thePlaceADayScreenKeepsItsOneOffsIsNeitherItsRecordPlaceNorItsRosterPlace() {
    #expect(DayScreen.oneOffPlace != DayScreen.recordPlace)
    #expect(DayScreen.oneOffPlace != DayScreen.rosterPlace)
    #expect(DayScreen.recordPlace != DayScreen.rosterPlace)
}

@MainActor
@Test("a day screen draws the one-offs kept at its one-off place on the today it was handed")
func aDayScreenDrawsTheOneOffsKeptAtItsOneOffPlaceOnTheTodayItWasHanded() throws {
    let (place, rosterPlace) = freshPlaces()
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace)

    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])
    #expect(screen.dayView.oneOffGroup?.rows.first?.lateInWords == "3 days late")
    #expect(screen.oneOffState == .kept)
}

@MainActor
@Test(
    "a day screen moved off today draws no undone late one-off and draws one owed ahead on its date"
)
func aDayScreenMovedOffTodayDrawsNoUndoneLateOneOffAndDrawsOneOwedAheadOnItsDate() throws {
    let (place, rosterPlace) = freshPlaces()
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)
    try oneOffStore.add(
        OneOff(name: "Pay fine", date: CalendarDate(year: 2026, month: 9, day: 30)!)!)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace)
    screen.showPreviousDay()

    #expect(screen.dayView.oneOffGroup?.rows.isEmpty == true)
    #expect(screen.nextDayView?.oneOffGroup?.rows.map(\.name) == ["Call mum"])

    let wednesday = CalendarDate(year: 2026, month: 9, day: 30)!
    screen.showDay(wednesday)

    let payFineRow = screen.dayView.oneOffGroup?.rows.first(where: { $0.name == "Pay fine" })
    #expect(payFineRow?.lateInWords == nil)
    #expect(payFineRow?.offersTick(asOf: monday) == false)
}

@MainActor
@Test("a day screen opened where no one-offs have been kept writes nothing at its one-off place")
func aDayScreenOpenedWhereNoOneOffsHaveBeenKeptWritesNothingAtItsOneOffPlace() {
    let (place, rosterPlace) = freshPlaces()
    let oneOffPlace = freshOneOffPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace)

    #expect(screen.dayView.oneOffGroup?.rows.isEmpty == true)
    #expect(screen.oneOffState == .kept)
    #expect(!FileManager.default.fileExists(atPath: oneOffPlace.path))
}

@MainActor
@Test("a day screen reads its one-off place again when shown and not when returned to")
func aDayScreenReadsItsOneOffPlaceAgainWhenShownAndNotWhenReturnedTo() throws {
    let (place, rosterPlace) = freshPlaces()
    let oneOffPlace = freshOneOffPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace)

    let elsewhere = try OneOffStore(at: oneOffPlace)
    try elsewhere.add(
        OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)

    screen.returnedTo()
    #expect(screen.dayView.oneOffGroup?.rows.isEmpty == true)

    screen.shown(asOf: monday)
    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])
}

@MainActor
@Test("a day screen shown again on a later day draws a one-off that has followed today")
func aDayScreenShownAgainOnALaterDayDrawsAOneOffThatHasFollowedToday() throws {
    let (place, rosterPlace) = freshPlaces()
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)
    let friday = CalendarDate(year: 2026, month: 9, day: 25)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [], asOf: friday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)

    #expect(screen.dayView.oneOffGroup?.rows.first?.lateInWords == nil)

    screen.shown(asOf: monday)

    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])
    #expect(screen.dayView.oneOffGroup?.rows.first?.lateInWords == "3 days late")
}

@MainActor
@Test("a day screen's one-offs do not move the reach of its day picker")
func aDayScreensOneOffsDoNotMoveTheReachOfItsDayPicker() throws {
    let (place, rosterPlace) = freshPlaces()
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Renew passport", date: CalendarDate(year: 2020, month: 1, day: 1)!)!)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace)

    #expect(screen.dayPickerReach.earliest == keptFrom)
    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Renew passport"])
}

@MainActor
@Test("a day screen whose one-off place cannot be read draws its commitments and no One-offs group")
func aDayScreenWhoseOneOffPlaceCannotBeReadDrawsItsCommitmentsAndNoOneOffsGroup() throws {
    let (place, rosterPlace) = freshPlaces()
    let oneOffPlace = freshOneOffPlace()
    try FileManager.default.createDirectory(
        at: oneOffPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data("not one-offs".utf8)
    try bytes.write(to: oneOffPlace)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace)

    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
    #expect(screen.dayView.oneOffGroup == nil)
    #expect(screen.oneOffState == .unreadable)
    #expect(screen.recordState == .kept)
    #expect(screen.rosterState == .kept)
    #expect(try Data(contentsOf: oneOffPlace) == bytes)

    let (directoryPlace, directoryRoster) = freshPlaces()
    let directoryOneOffPlace = freshOneOffPlace()
    try FileManager.default.createDirectory(
        at: directoryOneOffPlace, withIntermediateDirectories: true)

    let directoryScreen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: directoryPlace,
        keepingRosterAt: directoryRoster, keepingOneOffsAt: directoryOneOffPlace)

    #expect(directoryScreen.oneOffState == .unreadable)
    var isDirectory: ObjCBool = false
    #expect(
        FileManager.default.fileExists(atPath: directoryOneOffPlace.path, isDirectory: &isDirectory))
    #expect(isDirectory.boolValue)
    #expect(try FileManager.default.contentsOfDirectory(atPath: directoryOneOffPlace.path).isEmpty)
}

@MainActor
@Test("one-offs written in a later form make a day screen that says they are from a later version")
func oneOffsWrittenInALaterFormMakeADayScreenThatSaysTheyAreFromALaterVersion() throws {
    let (place, rosterPlace) = freshPlaces()
    let oneOffPlace = freshOneOffPlace()
    try FileManager.default.createDirectory(
        at: oneOffPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(#"{"version": 6, "oneOffs": []}"#.utf8)
    try bytes.write(to: oneOffPlace)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace)

    #expect(screen.oneOffState == .writtenByALaterVersion)
    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
    #expect(screen.dayView.oneOffGroup == nil)
    #expect(try Data(contentsOf: oneOffPlace) == bytes)
}

@MainActor
@Test("a day screen that cannot read its record still draws and ticks its one-offs")
func aDayScreenThatCannotReadItsRecordStillDrawsAndTicksItsOneOffs() throws {
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)

    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a record".utf8).write(to: place)

    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)

    try screen.tick(screen.dayView.oneOffGroup!.rows[0])

    #expect(screen.recordState == .unreadable)
    #expect(screen.oneOffState == .kept)
    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])
    #expect(screen.dayView.oneOffGroup?.rows.first?.isDone == true)
}

@MainActor
@Test(
    "a day screen that could not read its one-offs starts keeping them when shown again and they can be read"
)
func aDayScreenThatCouldNotReadItsOneOffsStartsKeepingThemWhenShownAgainAndTheyCanBeRead() throws {
    let (place, rosterPlace) = freshPlaces()
    let oneOffPlace = freshOneOffPlace()
    try FileManager.default.createDirectory(
        at: oneOffPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not one-offs".utf8).write(to: oneOffPlace)

    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)

    #expect(screen.oneOffState == .unreadable)

    try FileManager.default.removeItem(at: oneOffPlace)
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)

    screen.shown(asOf: monday)

    #expect(screen.oneOffState == .kept)
    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])
}

@MainActor
@Test("ticking a late one-off row keeps it done on the today and it says nothing late")
func tickingALateOneOffRowKeepsItDoneOnTheTodayAndItSaysNothingLate() throws {
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)

    let (place, rosterPlace) = freshPlaces()
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)

    try screen.tick(screen.dayView.oneOffGroup!.rows[0])

    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])
    #expect(screen.dayView.oneOffGroup?.rows.first?.isDone == true)
    #expect(screen.dayView.oneOffGroup?.rows.first?.lateInWords == nil)

    let october5 = CalendarDate(year: 2026, month: 10, day: 5)!
    let reopened = try OneOffStore(at: oneOffPlace)
    #expect(
        reopened.oneOffs.standing(on: monday, asOf: october5).map(\.name) == ["Call mum"])

    #expect(!FileManager.default.fileExists(atPath: place.path))
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a one-off tick taken back on a past day leaves that day and stands on today again")
func aOneOffTickTakenBackOnAPastDayLeavesThatDayAndStandsOnTodayAgain() throws {
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(OneOff(name: "Call mum", date: september25)!)
    try oneOffStore.tick(OneOff(name: "Call mum", date: september25)!, on: september25)

    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace)
    screen.showDay(september25)

    try screen.tick(screen.dayView.oneOffGroup!.rows[0])

    #expect(screen.dayView.oneOffGroup?.rows.isEmpty == true)

    screen.showToday()

    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])
    #expect(screen.dayView.oneOffGroup?.rows.first?.isDone == false)
    #expect(screen.dayView.oneOffGroup?.rows.first?.lateInWords == "3 days late")
}

@MainActor
@Test("a one-off tick that cannot be kept is refused and leaves the day view as it was")
func aOneOffTickThatCannotBeKeptIsRefusedAndLeavesTheDayViewAsItWas() throws {
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)

    let (place, rosterPlace) = freshPlaces()
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)

    let directory = oneOffPlace.deletingLastPathComponent()
    try makeReadOnly(directory)
    defer { try? makeWritable(directory) }

    #expect(throws: (any Error).self) {
        try screen.tick(screen.dayView.oneOffGroup!.rows[0])
    }

    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])
    #expect(screen.dayView.oneOffGroup?.rows.first?.isDone == false)

    try makeWritable(directory)
    let reopened = try OneOffStore(at: oneOffPlace)
    #expect(!reopened.oneOffs.isDone(OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!))
}

@MainActor
@Test("ticking a one-off row that the day view does not hold or that offers no tick changes nothing")
func tickingAOneOffRowThatTheDayViewDoesNotHoldOrThatOffersNoTickChangesNothing() throws {
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)
    try oneOffStore.add(
        OneOff(name: "Pay fine", date: CalendarDate(year: 2026, month: 9, day: 29)!)!)
    let bytesBefore = try Data(contentsOf: oneOffPlace)

    let (firstPlace, firstRosterPlace) = freshPlaces()
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let firstScreen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: firstPlace,
        keepingRosterAt: firstRosterPlace, keepingOneOffsAt: oneOffPlace)

    let (secondPlace, secondRosterPlace) = freshPlaces()
    let tuesday = CalendarDate(year: 2026, month: 9, day: 29)!
    let secondScreen = DayScreen(
        startingFrom: [], asOf: tuesday, keepingRecordAt: secondPlace,
        keepingRosterAt: secondRosterPlace, keepingOneOffsAt: oneOffPlace)

    try firstScreen.tick(secondScreen.dayView.oneOffGroup!.rows.first(where: { $0.name == "Call mum" })!)

    firstScreen.showNextDay()
    try firstScreen.tick(firstScreen.dayView.oneOffGroup!.rows.first(where: { $0.name == "Pay fine" })!)

    #expect(firstScreen.dayView.oneOffGroup?.rows.map(\.name) == ["Pay fine"])
    #expect(firstScreen.dayView.oneOffGroup?.rows.first?.isDone == false)

    firstScreen.showToday()
    #expect(firstScreen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])
    #expect(firstScreen.dayView.oneOffGroup?.rows.first?.isDone == false)

    #expect(try Data(contentsOf: oneOffPlace) == bytesBefore)
}

@MainActor
@Test("a refused one-off tick is told on its row and ends what was told on a commitment row")
func aRefusedOneOffTickIsToldOnItsRowAndEndsWhatWasToldOnACommitmentRow() throws {
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)
    let oneOffDirectory = oneOffPlace.deletingLastPathComponent()
    try makeReadOnly(oneOffDirectory)
    defer { try? makeWritable(oneOffDirectory) }

    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace)

    #expect(throws: (any Error).self) {
        try screen.tick(screen.dayView.rows[0])
    }

    #expect(throws: (any Error).self) {
        try screen.tick(screen.dayView.oneOffGroup!.rows[0])
    }

    #expect(screen.notice?.oneOffRow == screen.dayView.oneOffGroup?.rows[0])
    #expect(screen.notice?.cause == nil)
    #expect(screen.notice?.row == nil)
    #expect(screen.oneOffState == .kept)
}

@MainActor
@Test("a refused commitment tick ends what was told on a one-off row")
func aRefusedCommitmentTickEndsWhatWasToldOnAOneOffRow() throws {
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)
    let oneOffDirectory = oneOffPlace.deletingLastPathComponent()
    try makeReadOnly(oneOffDirectory)
    defer { try? makeWritable(oneOffDirectory) }

    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace)

    #expect(throws: (any Error).self) {
        try screen.tick(screen.dayView.oneOffGroup!.rows[0])
    }

    #expect(throws: (any Error).self) {
        try screen.tick(screen.dayView.rows[0])
    }

    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.oneOffRow == nil)
}

@MainActor
@Test("what a day screen tells on a row ends when a one-off tick is kept")
func whatADayScreenTellsOnARowEndsWhenAOneOffTickIsKept() throws {
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)

    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace)

    #expect(throws: (any Error).self) {
        try screen.tick(screen.dayView.rows[0])
    }

    try screen.tick(screen.dayView.oneOffGroup!.rows[0])

    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])
    #expect(screen.dayView.oneOffGroup?.rows.first?.isDone == true)
    #expect(screen.notice == nil)
}

@MainActor
@Test("what a day screen tells on a one-off row ends when a commitment tick is kept")
func whatADayScreenTellsOnAOneOffRowEndsWhenACommitmentTickIsKept() throws {
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)
    let oneOffDirectory = oneOffPlace.deletingLastPathComponent()
    try makeReadOnly(oneOffDirectory)
    defer { try? makeWritable(oneOffDirectory) }

    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace)

    #expect(throws: (any Error).self) {
        try screen.tick(screen.dayView.oneOffGroup!.rows[0])
    }

    try screen.tick(screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].isKept)
    #expect(screen.notice == nil)
}

@MainActor
@Test("what a day screen tells on a one-off row stands when returned to and ends when the app is shown again")
func whatADayScreenTellsOnAOneOffRowStandsWhenReturnedToAndEndsWhenTheAppIsShownAgain() throws {
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)
    let oneOffDirectory = oneOffPlace.deletingLastPathComponent()
    try makeReadOnly(oneOffDirectory)
    defer { try? makeWritable(oneOffDirectory) }

    let (place, rosterPlace) = freshPlaces()
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)

    #expect(throws: (any Error).self) {
        try screen.tick(screen.dayView.oneOffGroup!.rows[0])
    }

    let oneOffRow = screen.dayView.oneOffGroup!.rows[0]
    screen.returnedTo()

    #expect(screen.notice?.oneOffRow == oneOffRow)

    try makeWritable(oneOffDirectory)
    screen.shown(asOf: monday)

    #expect(screen.notice == nil)
}

@MainActor
@Test("a tick on a one-off row a day screen's day view does not hold does not end what is already told")
func aTickOnAOneOffRowADayScreensDayViewDoesNotHoldDoesNotEndWhatIsAlreadyTold() throws {
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 29)!

    let (firstPlace, firstRosterPlace) = try blockerPlaces()
    let firstScreen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: firstPlace,
        keepingRosterAt: firstRosterPlace, keepingOneOffsAt: oneOffPlace)

    let (secondPlace, secondRosterPlace) = freshPlaces()
    let secondScreen = DayScreen(
        startingFrom: [journaling], asOf: tuesday, keepingRecordAt: secondPlace,
        keepingRosterAt: secondRosterPlace, keepingOneOffsAt: oneOffPlace)

    #expect(throws: (any Error).self) {
        try firstScreen.tick(firstScreen.dayView.rows[0])
    }

    try firstScreen.tick(secondScreen.dayView.oneOffGroup!.rows[0])

    #expect(firstScreen.notice?.row == firstScreen.dayView.rows[0])
    #expect(firstScreen.notice?.oneOffRow == nil)
}

@MainActor
@Test("a one-off committed in the one-off entry on today is added not done on today")
func aOneOffCommittedInTheOneOffEntryOnTodayIsAddedNotDoneOnToday() throws {
    let oneOffPlace = freshOneOffPlace()
    let (place, rosterPlace) = freshPlaces()
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)

    try screen.addOneOff(named: "Call mum")

    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])
    #expect(screen.dayView.oneOffGroup?.rows.first?.isDone == false)
    #expect(screen.dayView.oneOffGroup?.rows.first?.lateInWords == nil)

    let october5 = CalendarDate(year: 2026, month: 10, day: 5)!
    let reopened = try OneOffStore(at: oneOffPlace)
    #expect(reopened.oneOffs.standing(on: october5, asOf: october5).map(\.name) == ["Call mum"])

    #expect(!FileManager.default.fileExists(atPath: place.path))
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a one-off committed on a later day is added not done on that day and offers no tick")
func aOneOffCommittedOnALaterDayIsAddedNotDoneOnThatDayAndOffersNoTick() throws {
    let oneOffPlace = freshOneOffPlace()
    let (place, rosterPlace) = freshPlaces()
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)
    screen.showNextDay()

    try screen.addOneOff(named: "Send form")

    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Send form"])
    #expect(screen.dayView.oneOffGroup?.rows.first?.isDone == false)
    #expect(screen.dayView.oneOffGroup?.rows.first?.offersTick(asOf: monday) == false)

    screen.showToday()
    #expect(screen.dayView.oneOffGroup?.rows.isEmpty == true)

    let reopened = try OneOffStore(at: oneOffPlace)
    let sendForm = OneOff(name: "Send form", date: CalendarDate(year: 2026, month: 9, day: 29)!)!
    #expect(reopened.oneOffs.isDone(sendForm) == false)
}

@MainActor
@Test("a one-off committed on a past day is added already done on that day and stays on it")
func aOneOffCommittedOnAPastDayIsAddedAlreadyDoneOnThatDayAndStaysOnIt() throws {
    let oneOffPlace = freshOneOffPlace()
    let (place, rosterPlace) = freshPlaces()
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)
    screen.showPreviousDay()

    try screen.addOneOff(named: "Call mum")

    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])
    #expect(screen.dayView.oneOffGroup?.rows.first?.isDone == true)

    screen.showToday()
    #expect(screen.dayView.oneOffGroup?.rows.isEmpty == true)

    let october5 = CalendarDate(year: 2026, month: 10, day: 5)!
    let reopened = try OneOffStore(at: oneOffPlace)
    let sunday = CalendarDate(year: 2026, month: 9, day: 27)!
    #expect(
        reopened.oneOffs.standing(on: sunday, asOf: october5).map(\.name) == ["Call mum"])
}

@MainActor
@Test("blank space around a name committed in the one-off entry is not part of the one-off added")
func blankSpaceAroundANameCommittedInTheOneOffEntryIsNotPartOfTheOneOffAdded() throws {
    let oneOffPlace = freshOneOffPlace()
    let (place, rosterPlace) = freshPlaces()
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)

    try screen.addOneOff(named: "  Call mum ")

    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])

    let reopened = try OneOffStore(at: oneOffPlace)
    #expect(reopened.oneOffs.standing(on: monday, asOf: monday).map(\.name) == ["Call mum"])
}

@MainActor
@Test("a commit saying nothing in the one-off entry adds nothing and tells nothing")
func aCommitSayingNothingInTheOneOffEntryAddsNothingAndTellsNothing() throws {
    let oneOffPlace = freshOneOffPlace()
    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace)

    #expect(throws: (any Error).self) {
        try screen.tick(screen.dayView.rows[0])
    }

    try screen.addOneOff(named: "")
    try screen.addOneOff(named: "   ")

    #expect(screen.dayView.oneOffGroup?.rows.isEmpty == true)
    #expect(screen.nameRefusal == nil)
    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(!FileManager.default.fileExists(atPath: oneOffPlace.path))
}

@MainActor
@Test("a day screen not keeping one-offs adds nothing whatever is committed in its one-off entry")
func aDayScreenNotKeepingOneOffsAddsNothingWhateverIsCommittedInItsOneOffEntry() throws {
    let oneOffPlace = freshOneOffPlace()
    try FileManager.default.createDirectory(
        at: oneOffPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data("not one-offs".utf8)
    try bytes.write(to: oneOffPlace)

    let (place, rosterPlace) = freshPlaces()
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)

    #expect(throws: Never.self) {
        try screen.addOneOff(named: "Call mum")
    }

    #expect(screen.dayView.oneOffGroup == nil)
    #expect(screen.nameRefusal == nil)
    #expect(try Data(contentsOf: oneOffPlace) == bytes)

    let laterFormPlace = freshOneOffPlace()
    try FileManager.default.createDirectory(
        at: laterFormPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let laterFormBytes = Data(#"{"version": 2, "oneOffs": []}"#.utf8)
    try laterFormBytes.write(to: laterFormPlace)

    let (secondPlace, secondRosterPlace) = freshPlaces()
    let secondScreen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: secondPlace,
        keepingRosterAt: secondRosterPlace, keepingOneOffsAt: laterFormPlace)

    #expect(throws: Never.self) {
        try secondScreen.addOneOff(named: "Call mum")
    }
    #expect(secondScreen.oneOffState == .writtenByALaterVersion)
    #expect(try Data(contentsOf: laterFormPlace) == laterFormBytes)
}

@MainActor
@Test("a one-off added ends what a day screen tells on a row")
func aOneOffAddedEndsWhatADayScreenTellsOnARow() throws {
    let oneOffPlace = freshOneOffPlace()
    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace)

    #expect(throws: (any Error).self) {
        try screen.tick(screen.dayView.rows[0])
    }

    try screen.addOneOff(named: "Call mum")

    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])
    #expect(screen.notice == nil)
}

@MainActor
@Test("an add of a name already held on the day shown is refused and told under the one-off entry")
func anAddOfANameAlreadyHeldOnTheDayShownIsRefusedAndToldUnderTheOneOffEntry() throws {
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(OneOff(name: "Call mum", date: monday)!)

    let (place, rosterPlace) = freshPlaces()
    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)
    let bytesBefore = try Data(contentsOf: oneOffPlace)

    #expect(throws: Never.self) {
        try screen.addOneOff(named: "Call mum ")
    }

    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])
    #expect(screen.nameRefusal?.row == nil)
    #expect(screen.nameRefusal?.cause == "Already on this day")
    #expect(screen.nameRefusal?.text == "Call mum ")
    #expect(try Data(contentsOf: oneOffPlace) == bytesBefore)

    let doneOneOffPlace = freshOneOffPlace()
    let doneStore = try OneOffStore(at: doneOneOffPlace)
    try doneStore.add(OneOff(name: "Call mum", date: monday)!, doneOn: monday)

    let (secondPlace, secondRosterPlace) = freshPlaces()
    let secondScreen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: secondPlace,
        keepingRosterAt: secondRosterPlace, keepingOneOffsAt: doneOneOffPlace)

    #expect(throws: Never.self) {
        try secondScreen.addOneOff(named: "Call mum ")
    }
    #expect(secondScreen.nameRefusal?.cause == "Already on this day")
    #expect(secondScreen.nameRefusal?.text == "Call mum ")
}

@MainActor
@Test("an add is refused on a past day where a one-off of that name owed there now stands on today")
func anAddIsRefusedOnAPastDayWhereAOneOffOfThatNameOwedThereNowStandsOnToday() throws {
    let friday = CalendarDate(year: 2026, month: 9, day: 25)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(OneOff(name: "Call mum", date: friday)!)

    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace)
    screen.showDay(friday)

    try screen.addOneOff(named: "Call mum")

    #expect(screen.nameRefusal?.cause == "Already on this day")
    #expect(screen.dayView.oneOffGroup?.rows.isEmpty == true)

    screen.showToday()
    try screen.addOneOff(named: "Call mum")

    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum", "Call mum"])
    #expect(screen.dayView.oneOffGroup?.rows[0].lateInWords == "3 days late")
    #expect(screen.dayView.oneOffGroup?.rows[1].lateInWords == nil)
}

@MainActor
@Test(
    "an add that cannot be kept is refused with an error and told under the one-off entry beside what is told on a row"
)
func anAddThatCannotBeKeptIsRefusedWithAnErrorAndToldUnderTheOneOffEntryBesideWhatIsToldOnARow()
    throws
{
    let oneOffPlace = freshOneOffPlace()
    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace)

    #expect(throws: (any Error).self) {
        try screen.tick(screen.dayView.rows[0])
    }

    let oneOffDirectory = oneOffPlace.deletingLastPathComponent()
    try FileManager.default.createDirectory(
        at: oneOffDirectory, withIntermediateDirectories: true)
    try makeReadOnly(oneOffDirectory)
    defer { try? makeWritable(oneOffDirectory) }

    #expect(throws: (any Error).self) {
        try screen.addOneOff(named: "Call mum")
    }

    #expect(screen.nameRefusal?.row == nil)
    #expect(screen.nameRefusal?.cause == nil)
    #expect(screen.nameRefusal?.text == "Call mum")
    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.dayView.oneOffGroup?.rows.isEmpty == true)
}

@MainActor
@Test("a rename onto a one-off already held is refused and told under its row, which keeps its name")
func aRenameOntoAOneOffAlreadyHeldIsRefusedAndToldUnderItsRowWhichKeepsItsName() throws {
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(OneOff(name: "Call mum", date: monday)!)
    try oneOffStore.add(OneOff(name: "Ring mum", date: monday)!)

    let (place, rosterPlace) = freshPlaces()
    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)
    let bytesBefore = try Data(contentsOf: oneOffPlace)
    let callMumRow = screen.dayView.oneOffGroup!.rows.first(where: { $0.name == "Call mum" })!

    #expect(throws: Never.self) {
        try screen.rename(callMumRow, to: "Ring mum")
    }

    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum", "Ring mum"])
    #expect(screen.nameRefusal?.row == callMumRow)
    #expect(screen.nameRefusal?.cause == "Already on this day")
    #expect(screen.nameRefusal?.text == "Ring mum")
    #expect(try Data(contentsOf: oneOffPlace) == bytesBefore)
}

@MainActor
@Test("a rename that cannot be kept is refused with an error and told under its row")
func aRenameThatCannotBeKeptIsRefusedWithAnErrorAndToldUnderItsRow() throws {
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)
    let oneOffDirectory = oneOffPlace.deletingLastPathComponent()
    try makeReadOnly(oneOffDirectory)
    defer { try? makeWritable(oneOffDirectory) }

    let (place, rosterPlace) = freshPlaces()
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)
    let row = screen.dayView.oneOffGroup!.rows[0]

    #expect(throws: (any Error).self) {
        try screen.rename(row, to: "Ring mum")
    }

    #expect(screen.nameRefusal?.row == row)
    #expect(screen.nameRefusal?.cause == nil)
    #expect(screen.nameRefusal?.text == "Ring mum")
    #expect(screen.notice == nil)
    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])

    #expect(throws: (any Error).self) {
        try screen.rename(row, to: "   ")
    }

    #expect(screen.nameRefusal?.row == row)
    #expect(screen.nameRefusal?.cause == nil)
    #expect(screen.nameRefusal?.text == "   ")
    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])
}

@MainActor
@Test(
    "what is told under the one-off entry stands when a change is kept on a row or from another field and when returned to"
)
func whatIsToldUnderTheOneOffEntryStandsWhenAChangeIsKeptOnARowOrFromAnotherFieldAndWhenReturnedTo()
    throws
{
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Pay fine", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)
    try oneOffStore.add(OneOff(name: "Call mum", date: monday)!)

    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace)

    try screen.addOneOff(named: "Call mum")
    #expect(screen.nameRefusal?.row == nil)
    #expect(screen.nameRefusal?.cause == "Already on this day")

    try screen.tick(screen.dayView.rows[0])

    let payFineRow = screen.dayView.oneOffGroup!.rows.first(where: { $0.name == "Pay fine" })!
    try screen.rename(payFineRow, to: "Pay the fine")

    screen.returnedTo()

    #expect(screen.nameRefusal?.row == nil)
    #expect(screen.nameRefusal?.cause == "Already on this day")
    #expect(screen.dayView.rows[0].isKept)
    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Pay the fine", "Call mum"])
}

@MainActor
@Test("what is told under a one-off name field ends when its text is edited or a commit from it is kept")
func whatIsToldUnderAOneOffNameFieldEndsWhenItsTextIsEditedOrACommitFromItIsKept() throws {
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(OneOff(name: "Call mum", date: monday)!)

    let (place, rosterPlace) = freshPlaces()
    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)

    try screen.addOneOff(named: "Call mum")
    #expect(screen.nameRefusal != nil)

    screen.oneOffNameEdited()

    #expect(screen.nameRefusal == nil)
    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])

    try screen.addOneOff(named: "Call mum")
    #expect(screen.nameRefusal != nil)

    try screen.addOneOff(named: "Call dad")

    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum", "Call dad"])
    #expect(screen.nameRefusal == nil)
}

@MainActor
@Test(
    "what is told under a one-off name field ends when the day being shown changes and stands when today is sent back to today"
)
func whatIsToldUnderAOneOffNameFieldEndsWhenTheDayBeingShownChangesAndStandsWhenTodayIsSentBackToToday()
    throws
{
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(OneOff(name: "Call mum", date: monday)!)

    let (place, rosterPlace) = freshPlaces()
    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)

    try screen.addOneOff(named: "Call mum")
    screen.showToday()

    #expect(screen.nameRefusal?.cause == "Already on this day")

    screen.showNextDay()
    #expect(screen.nameRefusal == nil)

    let (secondPlace, secondRosterPlace) = freshPlaces()
    let secondOneOffPlace = freshOneOffPlace()
    let secondOneOffStore = try OneOffStore(at: secondOneOffPlace)
    try secondOneOffStore.add(OneOff(name: "Call mum", date: monday)!)
    let secondScreen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: secondPlace,
        keepingRosterAt: secondRosterPlace, keepingOneOffsAt: secondOneOffPlace)

    try secondScreen.addOneOff(named: "Call mum")
    secondScreen.showDay(CalendarDate(year: 2026, month: 9, day: 30)!)

    #expect(secondScreen.nameRefusal == nil)
}

@MainActor
@Test("what is told under a one-off name field ends when the app is shown again")
func whatIsToldUnderAOneOffNameFieldEndsWhenTheAppIsShownAgain() throws {
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(OneOff(name: "Call mum", date: monday)!)

    let (place, rosterPlace) = freshPlaces()
    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)

    try screen.addOneOff(named: "Call mum")
    #expect(screen.nameRefusal != nil)

    screen.shown(asOf: monday)

    #expect(screen.nameRefusal == nil)
    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])
}

@MainActor
@Test(
    "a refusal under one one-off name field replaces what is told under another, and ends when its row is no longer held"
)
func aRefusalUnderOneOneOffNameFieldReplacesWhatIsToldUnderAnotherAndEndsWhenItsRowIsNoLongerHeld()
    throws
{
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(OneOff(name: "Call mum", date: monday)!)
    try oneOffStore.add(OneOff(name: "Ring mum", date: monday)!)

    let (place, rosterPlace) = freshPlaces()
    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)

    try screen.addOneOff(named: "Call mum")
    #expect(screen.nameRefusal?.row == nil)

    let callMumRow = screen.dayView.oneOffGroup!.rows.first(where: { $0.name == "Call mum" })!
    try screen.rename(callMumRow, to: "Ring mum")

    #expect(screen.nameRefusal?.row == callMumRow)
    #expect(screen.nameRefusal?.cause == "Already on this day")

    try screen.tick(callMumRow)

    #expect(screen.nameRefusal == nil)
}

@MainActor
@Test("a one-off renamed from its row on a past day keeps its date and stays done there")
func aOneOffRenamedFromItsRowOnAPastDayKeepsItsDateAndStaysDoneThere() throws {
    let friday = CalendarDate(year: 2026, month: 9, day: 25)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 30)!
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(OneOff(name: "Call mum", date: friday)!)
    try oneOffStore.tick(OneOff(name: "Call mum", date: friday)!, on: friday)
    try oneOffStore.add(OneOff(name: "Send form", date: wednesday)!)

    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace)
    screen.showDay(friday)

    try screen.rename(screen.dayView.oneOffGroup!.rows[0], to: "Ring mum")

    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Ring mum"])
    #expect(screen.dayView.oneOffGroup?.rows.first?.isDone == true)

    let october5 = CalendarDate(year: 2026, month: 10, day: 5)!
    let reopened = try OneOffStore(at: oneOffPlace)
    #expect(
        reopened.oneOffs.standing(on: friday, asOf: october5).map(\.name) == ["Ring mum"])
    #expect(reopened.oneOffs.standingDay(for: OneOff(name: "Call mum", date: friday)!, asOf: october5) == nil)

    screen.showDay(wednesday)
    try screen.rename(screen.dayView.oneOffGroup!.rows[0], to: "Send the form")

    #expect(screen.dayView.oneOffGroup?.rows.first?.offersTick(asOf: monday) == false)
    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Send the form"])
}

@MainActor
@Test("a rename committed with its row's own name changes nothing and writes nothing")
func aRenameCommittedWithItsRowsOwnNameChangesNothingAndWritesNothing() throws {
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(OneOff(name: "Call mum", date: monday)!)

    let (place, rosterPlace) = freshPlaces()
    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)
    let bytesBefore = try Data(contentsOf: oneOffPlace)
    let row = screen.dayView.oneOffGroup!.rows[0]

    #expect(throws: Never.self) {
        try screen.rename(row, to: "Call mum ")
    }

    #expect(screen.nameRefusal == nil)
    #expect(try Data(contentsOf: oneOffPlace) == bytesBefore)
}

@MainActor
@Test("a rename committed saying nothing removes the one-off")
func aRenameCommittedSayingNothingRemovesTheOneOff() throws {
    let friday = CalendarDate(year: 2026, month: 9, day: 25)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(OneOff(name: "Call mum", date: friday)!)
    try oneOffStore.add(OneOff(name: "Call dad", date: monday)!)

    let (place, rosterPlace) = freshPlaces()
    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)
    let callMumRow = screen.dayView.oneOffGroup!.rows.first(where: { $0.name == "Call mum" })!

    try screen.rename(callMumRow, to: "   ")

    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call dad"])
    #expect(screen.nameRefusal == nil)

    let reopened = try OneOffStore(at: oneOffPlace)
    #expect(reopened.oneOffs == {
        var expected = OneOffs()
        _ = expected.add(OneOff(name: "Call dad", date: monday)!)
        return expected
    }())
}

@MainActor
@Test(
    "a one-off removed from its row is held no longer, done or not and whether or not it offers its tick"
)
func aOneOffRemovedFromItsRowIsHeldNoLongerDoneOrNotAndWhetherOrNotItOffersItsTick() throws {
    let friday = CalendarDate(year: 2026, month: 9, day: 25)!
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 30)!
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(OneOff(name: "Call mum", date: friday)!)
    try oneOffStore.add(OneOff(name: "Call dad", date: monday)!)
    try oneOffStore.tick(OneOff(name: "Call dad", date: monday)!, on: monday)
    try oneOffStore.add(OneOff(name: "Pay fine", date: wednesday)!)

    let (place, rosterPlace) = freshPlaces()
    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)

    let callMumRow = screen.dayView.oneOffGroup!.rows.first(where: { $0.name == "Call mum" })!
    try screen.remove(callMumRow)
    let callDadRow = screen.dayView.oneOffGroup!.rows.first(where: { $0.name == "Call dad" })!
    try screen.remove(callDadRow)

    screen.showNextDay()
    screen.showNextDay()

    let payFineRow = screen.dayView.oneOffGroup!.rows.first(where: { $0.name == "Pay fine" })!
    #expect(payFineRow.offersTick(asOf: monday) == false)
    try screen.remove(payFineRow)

    #expect(screen.dayView.oneOffGroup?.rows.isEmpty == true)

    screen.showToday()
    #expect(screen.dayView.oneOffGroup?.rows.isEmpty == true)

    let reopened = try OneOffStore(at: oneOffPlace)
    #expect(reopened.oneOffs == OneOffs())
}

@MainActor
@Test("renaming or removing a one-off row a day screen's day view does not hold changes nothing")
func renamingOrRemovingAOneOffRowADayScreensDayViewDoesNotHoldChangesNothing() throws {
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 29)!
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)
    try oneOffStore.add(OneOff(name: "Pay fine", date: tuesday)!)
    let bytesBefore = try Data(contentsOf: oneOffPlace)

    let (place, rosterPlace) = freshPlaces()
    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)
    let nextRow = screen.nextDayView!.oneOffGroup!.rows[0]

    #expect(throws: Never.self) {
        try screen.rename(nextRow, to: "Pay the fine")
    }
    #expect(throws: Never.self) {
        try screen.remove(nextRow)
    }

    #expect(screen.nextDayView?.oneOffGroup?.rows.map(\.name) == ["Pay fine"])
    #expect(screen.notice == nil)
    #expect(screen.nameRefusal == nil)
    #expect(try Data(contentsOf: oneOffPlace) == bytesBefore)
}

@MainActor
@Test("a one-off removal that cannot be kept is refused with an error and told on its row")
func aOneOffRemovalThatCannotBeKeptIsRefusedWithAnErrorAndToldOnItsRow() throws {
    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)
    let oneOffDirectory = oneOffPlace.deletingLastPathComponent()
    try makeReadOnly(oneOffDirectory)
    defer { try? makeWritable(oneOffDirectory) }

    let (place, rosterPlace) = freshPlaces()
    let monday = CalendarDate(year: 2026, month: 9, day: 28)!
    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace)
    let row = screen.dayView.oneOffGroup!.rows[0]

    #expect(throws: (any Error).self) {
        try screen.remove(row)
    }

    #expect(screen.notice?.oneOffRow == row)
    #expect(screen.notice?.cause == nil)
    #expect(screen.dayView.oneOffGroup?.rows.map(\.name) == ["Call mum"])
    #expect(screen.nameRefusal == nil)
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

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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
    try Data(#"{"version": 5, "commitments": []}"#.utf8).write(to: rosterPlace)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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
    let empty = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: emptyPlace, keepingRosterAt: emptyRosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(empty.rosterState == .kept)

    let (takenOnPlace, takenOnRosterPlace) = freshPlaces()
    let rosterStore = try RosterStore(at: takenOnRosterPlace)
    try rosterStore.add(gym)
    let takenOn = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: takenOnPlace, keepingRosterAt: takenOnRosterPlace, keepingOneOffsAt: freshOneOffPlace())
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

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.title == "Mon")
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

    let screen = DayScreen(startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.dayView.rows.map(\.name) == ["Gym", "Journaling"])
    #expect(!screen.dayView.rows[0].isKept)
    #expect(!screen.dayView.rows[1].isKept)
    #expect(screen.recordState == .unreadable)
    #expect(screen.rosterState == .kept)
}

@MainActor
@Test("a day screen whose roster place cannot be opened for another reason does not say the roster is from a later version")
func aDayScreenWhoseRosterPlaceCannotBeOpenedForAnotherReasonDoesNotSayTheRosterIsFromALaterVersion()
    throws
{
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.rosterState == .notKept)
    #expect(screen.rosterState != .writtenByALaterVersion)
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

    let screen = DayScreen(startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

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

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"version": 5, "commitments": []}"#.utf8).write(to: rosterPlace)

    screen.shown(asOf: monday)

    #expect(screen.rosterState == .writtenByALaterVersion)
    #expect(screen.dayView.rows.isEmpty)
}

@MainActor
@Test("a day screen shown again carries over no reason it gave for not keeping its record or its roster")
func aDayScreenShownAgainCarriesOverNoReasonItGaveForNotKeepingItsRecordOrItsRoster() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"version": 6, "ticks": []}"#.utf8).write(to: place)
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"version": 5, "commitments": []}"#.utf8).write(to: rosterPlace)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(screen.recordState == .writtenByALaterVersion)
    #expect(screen.rosterState == .writtenByALaterVersion)

    try FileManager.default.removeItem(at: place)
    try Data("not what a record is written as".utf8).write(to: place)
    try FileManager.default.removeItem(at: rosterPlace)
    try Data("not what a roster is written as".utf8).write(to: rosterPlace)

    screen.shown(asOf: monday)

    #expect(screen.recordState == .unreadable)
    #expect(screen.rosterState == .notKept)
}

@MainActor
@Test("a commitment taken on at a day screen's roster place is drawn when the screen is returned to")
func aCommitmentTakenOnAtADayScreensRosterPlaceIsDrawnWhenTheScreenIsReturnedTo() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(journaling)

    let screen = DayScreen(startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])

    let other = try RosterStore(at: rosterPlace)
    try other.add(gym)

    screen.returnedTo()

    #expect(screen.dayView.rows.map(\.name) == ["Journaling", "Gym"])
}

@MainActor
@Test("a commitment stopped at a day screen's roster place is not drawn when the screen is returned to")
func aCommitmentStoppedAtADayScreensRosterPlaceIsNotDrawnWhenTheScreenIsReturnedTo() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(journaling)
    try rosterStore.add(gym)

    let screen = DayScreen(startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    let other = try RosterStore(at: rosterPlace)
    try other.retire(gym, keptUntil: sunday)

    screen.returnedTo()

    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
}

@MainActor
@Test("a day screen returned to goes on showing the day it was showing")
func aDayScreenReturnedToGoesOnShowingTheDayItWasShowing() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(journaling)

    let screen = DayScreen(startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()

    screen.returnedTo()

    #expect(screen.dayPickerReach.opensOn == sunday)
    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
}

@MainActor
@Test("a day screen returned to keeps the today it was handed")
func aDayScreenReturnedToKeepsTheTodayItWasHanded() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(journaling)

    let screen = DayScreen(startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    screen.returnedTo()

    #expect(screen.dayPickerReach.opensOn == monday)
    #expect(!screen.offersGoingBackToToday)
}

@MainActor
@Test("a commitment renamed at a day screen's places is drawn under its new name and still kept when the screen is returned to")
func aCommitmentRenamedAtADayScreensPlacesIsDrawnUnderItsNewNameAndStillKeptWhenTheScreenIsReturnedTo()
    throws
{
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: place)
    try recordStore.add(Tick(gym, on: monday)!)

    let screen = DayScreen(startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.recordState == .kept)

    let otherRoster = try RosterStore(at: rosterPlace)
    try otherRoster.change(gym, to: gymEmoji, under: nil)
    let otherRecord = try RecordStore(at: place)
    try otherRecord.carryOver(gym, to: gymEmoji)

    screen.returnedTo()

    #expect(screen.dayView.rows.map(\.name) == ["Gym 🏋️"])
    #expect(screen.dayView.rows.first?.isKept == true)
}

@MainActor
@Test("a day screen returned to does not read its record again")
func aDayScreenReturnedToDoesNotReadItsRecordAgain() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a record".utf8).write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.recordState == .unreadable)

    try FileManager.default.removeItem(at: place)

    screen.returnedTo()

    #expect(screen.recordState == .unreadable)
    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
}

@MainActor
@Test("a day screen that could not read its roster starts keeping one when it is returned to and the roster can be read")
func aDayScreenThatCouldNotReadItsRosterStartsKeepingOneWhenItIsReturnedToAndTheRosterCanBeRead()
    throws
{
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a roster is written as".utf8).write(to: rosterPlace)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    try FileManager.default.removeItem(at: rosterPlace)
    let recovered = try RosterStore(at: rosterPlace)
    try recovered.add(journaling)

    screen.returnedTo()

    #expect(screen.rosterState == .kept)
    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
}

@MainActor
@Test("a day screen returned to on a roster that holds nothing takes the commitments it was handed on again")
func aDayScreenReturnedToOnARosterThatHoldsNothingTakesTheCommitmentsItWasHandedOnAgain() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    try FileManager.default.removeItem(at: rosterPlace)

    screen.returnedTo()

    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])

    let later = try RosterStore(at: rosterPlace)
    #expect(later.roster.commitments == [journaling])
}

@MainActor
@Test("a day screen returned to where its roster cannot be read says so and draws no rows")
func aDayScreenReturnedToWhereItsRosterCannotBeReadSaysSoAndDrawsNoRows() throws {
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
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])

    try FileManager.default.removeItem(at: rosterPlace)
    try Data("not what a roster is written as".utf8).write(to: rosterPlace)

    screen.returnedTo()

    #expect(screen.rosterState == .notKept)
    #expect(screen.dayView.rows.isEmpty)
}

// MARK: - add-refused-tick-notice

@MainActor
@Test("a refused tick is told on the row that was tapped and on no other row")
func aRefusedTickIsToldOnTheRowThatWasTappedAndOnNoOtherRow() throws {
    let (place, rosterPlace) = try blockerPlaces()

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

    let screen = DayScreen(
        startingFrom: [gym, journaling, supplements], asOf: monday,
        keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let secondRow = screen.dayView.rows[1]

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(secondRow)
    }

    #expect(screen.notice?.row == secondRow)
    #expect(screen.notice?.row != screen.dayView.rows[0])
    #expect(screen.notice?.row != screen.dayView.rows[2])
}

@MainActor
@Test("a refused take-back is told on the row that was tapped")
func aRefusedTakeBackIsToldOnTheRowThatWasTapped() throws {
    let (place, rosterPlace) = freshPlaces()
    let directory = place.deletingLastPathComponent()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let seedStore = try RecordStore(at: place)
    try seedStore.add(Tick(gym, on: monday)!)
    let seedRoster = try RosterStore(at: rosterPlace)
    try seedRoster.add(gym)

    try makeReadOnly(directory)
    defer { try? makeWritable(directory) }

    let screen = DayScreen(startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let row = screen.dayView.rows[0]
    #expect(row.isKept)

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(row)
    }

    #expect(screen.notice?.row == row)
    #expect(screen.dayView.rows[0].isKept)
}

@MainActor
@Test("a second refused tap is told on the row tapped last and no longer on the first")
func aSecondRefusedTapIsToldOnTheRowTappedLastAndNoLongerOnTheFirst() throws {
    let (place, rosterPlace) = try blockerPlaces()

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [gym, journaling], asOf: monday,
        keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let firstRow = screen.dayView.rows[0]
    let secondRow = screen.dayView.rows[1]

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(firstRow)
    }
    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(secondRow)
    }

    #expect(screen.notice?.row == secondRow)
    #expect(screen.notice?.row != firstRow)
}

@MainActor
@Test("a refused change does not change what a day screen says about keeping a record")
func aRefusedChangeDoesNotChangeWhatADayScreenSaysAboutKeepingARecord() throws {
    let (place, rosterPlace) = try blockerPlaces()

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let row = screen.dayView.rows[0]

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(row)
    }
    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(row)
    }

    #expect(screen.recordState == .kept)
    #expect(screen.notice?.row == row)
}

@MainActor
@Test("what a day screen tells on a row ends when the app is shown again")
func whatADayScreenTellsOnARowEndsWhenTheAppIsShownAgain() throws {
    let (place, rosterPlace) = try blockerPlaces()

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(screen.dayView.rows[0])
    }

    screen.shown(asOf: monday)

    #expect(screen.notice == nil)
    #expect(!screen.dayView.rows[0].isKept)
}

@MainActor
@Test("what a day screen tells on a row ends when the app is shown again where the record then cannot be read")
func whatADayScreenTellsOnARowEndsWhenTheAppIsShownAgainWhereTheRecordThenCannotBeRead() throws {
    let (place, rosterPlace) = try blockerPlaces()
    let blocker = place.deletingLastPathComponent()

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(screen.dayView.rows[0])
    }

    try FileManager.default.removeItem(at: blocker)
    try FileManager.default.createDirectory(at: blocker, withIntermediateDirectories: true)
    try Data("not what a record is written as".utf8).write(to: place)

    screen.shown(asOf: monday)

    #expect(screen.recordState == .unreadable)
    #expect(screen.notice == nil)
}

@MainActor
@Test("what a day screen tells on a row ends when a change is kept on another row")
func whatADayScreenTellsOnARowEndsWhenAChangeIsKeptOnAnotherRow() throws {
    let (place, rosterPlace) = freshPlaces()
    let directory = place.deletingLastPathComponent()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let seedRoster = try RosterStore(at: rosterPlace)
    try seedRoster.add(gym)
    try seedRoster.add(journaling)

    try makeReadOnly(directory)
    defer { try? makeWritable(directory) }

    let screen = DayScreen(startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let firstRow = screen.dayView.rows[0]

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(firstRow)
    }

    try makeWritable(directory)

    try screen.tick(screen.dayView.rows[1])

    #expect(screen.dayView.rows.map(\.name) == ["Gym", "Journaling"])
    #expect(screen.dayView.rows.map(\.isKept) == [false, true])
    #expect(screen.notice == nil)
}

@MainActor
@Test("what a day screen tells on a row ends when a take-back is kept")
func whatADayScreenTellsOnARowEndsWhenATakeBackIsKept() throws {
    let (place, rosterPlace) = freshPlaces()
    let directory = place.deletingLastPathComponent()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [gym, journaling], asOf: monday,
        keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    try screen.tick(screen.dayView.rows[1])
    #expect(screen.dayView.rows[1].isKept)

    try makeReadOnly(directory)
    defer { try? makeWritable(directory) }

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(screen.dayView.rows[0])
    }

    try makeWritable(directory)

    try screen.tick(screen.dayView.rows[1])

    #expect(!screen.dayView.rows[1].isKept)
    #expect(screen.notice == nil)
}

@MainActor
@Test("what a day screen tells on a row ends when the day screen is moved to the day before")
func whatADayScreenTellsOnARowEndsWhenTheDayScreenIsMovedToTheDayBefore() throws {
    let (place, rosterPlace) = try blockerPlaces()

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(screen.dayView.rows[0])
    }

    screen.showPreviousDay()

    #expect(screen.notice == nil)
    #expect(screen.dayPickerReach.opensOn == sunday)
}

@MainActor
@Test("what a day screen tells on a row ends when the day screen is moved to the day after")
func whatADayScreenTellsOnARowEndsWhenTheDayScreenIsMovedToTheDayAfter() throws {
    let (place, rosterPlace) = try blockerPlaces()

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(screen.dayView.rows[0])
    }

    screen.showNextDay()

    #expect(screen.notice == nil)
    #expect(screen.dayPickerReach.opensOn == tuesday)
}

@MainActor
@Test("what a day screen tells on a row ends when the day screen is sent back to today from another day")
func whatADayScreenTellsOnARowEndsWhenTheDayScreenIsSentBackToTodayFromAnotherDay() throws {
    let (place, rosterPlace) = try blockerPlaces()

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()
    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(screen.dayView.rows[0])
    }

    screen.showToday()

    #expect(screen.notice == nil)
    #expect(screen.dayPickerReach.opensOn == monday)
    #expect(!screen.offersGoingBackToToday)
}

@MainActor
@Test("what a day screen tells on a row stands when a move has nowhere to go")
func whatADayScreenTellsOnARowStandsWhenAMoveHasNowhereToGo() throws {
    let keptFrom = CalendarDate(year: 1583, month: 1, day: 1)!
    let journalingFirst = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let journalingLast = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let firstSupported = CalendarDate(year: 1583, month: 1, day: 1)!
    let lastSupported = CalendarDate(year: 9999, month: 12, day: 31)!

    let firstPlaces = try blockerPlaces()
    let first = DayScreen(
        startingFrom: [journalingFirst], asOf: firstSupported,
        keepingRecordAt: firstPlaces.record, keepingRosterAt: firstPlaces.roster, keepingOneOffsAt: freshOneOffPlace())
    #expect(throws: RecordStoreError.cannotWrite(at: firstPlaces.record)) {
        try first.tick(first.dayView.rows[0])
    }

    let lastPlaces = try blockerPlaces()
    let last = DayScreen(
        startingFrom: [journalingLast], asOf: lastSupported,
        keepingRecordAt: lastPlaces.record, keepingRosterAt: lastPlaces.roster, keepingOneOffsAt: freshOneOffPlace())
    #expect(throws: RecordStoreError.cannotWrite(at: lastPlaces.record)) {
        try last.tick(last.dayView.rows[0])
    }

    first.showPreviousDay()
    last.showNextDay()

    #expect(first.notice?.row == first.dayView.rows[0])
    #expect(last.notice?.row == last.dayView.rows[0])
    #expect(first.dayPickerReach.opensOn == firstSupported)
    #expect(last.dayPickerReach.opensOn == lastSupported)
}

@MainActor
@Test("what a day screen tells on a row stands when a day screen showing today is sent back to today")
func whatADayScreenTellsOnARowStandsWhenADayScreenShowingTodayIsSentBackToToday() throws {
    let (place, rosterPlace) = try blockerPlaces()

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(screen.dayView.rows[0])
    }
    let row = screen.dayView.rows[0]

    screen.showToday()

    #expect(screen.notice?.row == row)
    #expect(screen.dayPickerReach.opensOn == monday)
    #expect(!screen.offersGoingBackToToday)
}

@MainActor
@Test("a tap on a day screen that is not keeping a record is told nothing on the row")
func aTapOnADayScreenThatIsNotKeepingARecordIsToldNothingOnTheRow() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a record is written as".utf8).write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.tick(screen.dayView.rows[0])

    #expect(screen.notice == nil)
    #expect(screen.recordState == .unreadable)
}

@MainActor
@Test("a tap on a day screen holding a record from a later version is told nothing on the row")
func aTapOnADayScreenHoldingARecordFromALaterVersionIsToldNothingOnTheRow() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"version": 6, "ticks": []}"#.utf8).write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.tick(screen.dayView.rows[0])

    #expect(screen.notice == nil)
    #expect(screen.recordState == .writtenByALaterVersion)
}

@MainActor
@Test("a tap on a row for a day that has not arrived is told nothing on the row")
func aTapOnARowForADayThatHasNotArrivedIsToldNothingOnTheRow() throws {
    let (place, rosterPlace) = try blockerPlaces()

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showNextDay()
    try screen.tick(screen.dayView.rows[0])

    #expect(screen.notice == nil)
    #expect(!screen.dayView.rows[0].isKept)

    let laterOnTuesday = DayScreen(
        startingFrom: [journaling], asOf: tuesday,
        keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(!laterOnTuesday.dayView.rows[0].isKept)
}

@MainActor
@Test("a tap on a row a day screen's day view does not hold does not end what is already told")
func aTapOnARowADayScreensDayViewDoesNotHoldDoesNotEndWhatIsAlreadyTold() throws {
    let (place, rosterPlace) = try blockerPlaces()

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!

    let mondayScreen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let wednesdayScreen = DayScreen(startingFrom: [journaling], asOf: wednesday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    let ownRow = mondayScreen.dayView.rows[0]
    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try mondayScreen.tick(ownRow)
    }

    try mondayScreen.tick(wednesdayScreen.dayView.rows[0])

    #expect(mondayScreen.notice?.row == ownRow)
}

@MainActor
@Test("a day screen returned to goes on telling what it was telling on a row")
func aDayScreenReturnedToGoesOnTellingWhatItWasTellingOnARow() throws {
    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let seedRoster = try RosterStore(at: rosterPlace)
    try seedRoster.add(journaling)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let row = screen.dayView.rows[0]

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(row)
    }
    #expect(screen.notice?.row == row)

    screen.returnedTo()

    #expect(screen.notice?.row == row)
    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
}

@MainActor
@Test("a day screen draws a removed commitment on the day it was kept until and not on the day after it")
func aDayScreenDrawsARemovedCommitmentOnTheDayItWasKeptUntilAndNotOnTheDayAfterIt() throws {
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
    try rosterStore.remove(journaling, keptUntil: sunday)

    let recordStore = try RecordStore(at: place)
    try recordStore.add(Tick(journaling, on: sunday)!)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.dayView.rows.isEmpty)

    screen.showPreviousDay()

    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
    #expect(screen.dayView.rows[0].isKept)
}

@MainActor
@Test("a day screen opened on a roster whose commitments have all been removed takes nothing on")
func aDayScreenOpenedOnARosterWhoseCommitmentsHaveAllBeenRemovedTakesNothingOn() throws {
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
    try rosterStore.remove(journaling, keptUntil: sunday)

    let screen = DayScreen(
        startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.dayView.rows.isEmpty)

    let later = try RosterStore(at: rosterPlace)
    var expected = Roster()
    _ = expected.add(journaling)
    _ = expected.remove(journaling, keptUntil: sunday)
    #expect(later.roster == expected)
}

@MainActor
@Test("a day screen draws its rows in the order its roster was moved into")
func aDayScreenDrawsItsRowsInTheOrderItsRosterWasMovedInto() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let supplements = Commitment(
        name: "Supplements and habits", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(journaling)
    try rosterStore.add(supplements)
    try rosterStore.add(gym)
    try rosterStore.move(gym, toOffset: 0, under: nil)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.dayView.rows.map(\.name) == ["Gym", "Journaling", "Supplements and habits"])
    #expect(screen.rosterState == .kept)
}

@MainActor
@Test("a number entered on a day that already holds one replaces it")
func aNumberEnteredOnADayThatAlreadyHoldsOneReplacesIt() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("70.5", on: screen.dayView.rows[0])
    try screen.enter("71.2", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].numberEntry(asOf: monday)?.number == 71.2)

    let later = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(later.dayView.rows[0].numberEntry(asOf: monday)?.number == 71.2)
}

@MainActor
@Test("committing an empty entry takes the number back")
func committingAnEmptyEntryTakesTheNumberBack() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("70.5", on: screen.dayView.rows[0])
    try screen.enter("", on: screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)
    let entry = try #require(screen.dayView.rows[0].numberEntry(asOf: monday))
    #expect(entry.number == nil)

    let later = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(!later.dayView.rows[0].isKept)
    let laterEntry = try #require(later.dayView.rows[0].numberEntry(asOf: monday))
    #expect(laterEntry.number == nil)
}

@MainActor
@Test("committing an empty entry on a day that holds no number leaves the day as it was")
func committingAnEmptyEntryOnADayThatHoldsNoNumberLeavesTheDayAsItWas() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("", on: screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)

    let later = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(!later.dayView.rows[0].isKept)
}

@MainActor
@Test("a number the commitment refuses keeps nothing and leaves the day as it was")
func aNumberTheCommitmentRefusesKeepsNothingAndLeavesTheDayAsItWas() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("70.5", on: screen.dayView.rows[0])
    try screen.enter("300", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].numberEntry(asOf: monday)?.number == 70.5)
    #expect(screen.dayView.rows[0].isKept)

    let later = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(later.dayView.rows[0].numberEntry(asOf: monday)?.number == 70.5)
    #expect(later.dayView.rows[0].isKept)
}

@MainActor
@Test("a number that cannot be kept is refused and leaves the day view as it was")
func aNumberThatCannotBeKeptIsRefusedAndLeavesTheDayViewAsItWas() throws {
    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.enter("70.5", on: screen.dayView.rows[0])
    }
    #expect(!screen.dayView.rows[0].isKept)

    let later = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(!later.dayView.rows[0].isKept)
}

@MainActor
@Test("entering a number on a row the day screen's day view does not hold changes nothing")
func enteringANumberOnARowTheDayScreensDayViewDoesNotHoldChangesNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!

    let mondayScreen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let wednesdayScreen = DayScreen(
        startingFrom: [weight], asOf: wednesday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    try mondayScreen.enter("70.5", on: wednesdayScreen.dayView.rows[0])

    #expect(!mondayScreen.dayView.rows[0].isKept)

    let laterOnWednesday = DayScreen(
        startingFrom: [weight], asOf: wednesday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(!laterOnWednesday.dayView.rows[0].isKept)
}

@MainActor
@Test("committing on a row that offers no number entry changes nothing")
func committingOnARowThatOffersNoNumberEntryChangesNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: daily, keptFrom: keptFrom, kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [gym, weight], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("70.5", on: screen.dayView.rows[0])
    screen.showNextDay()
    try screen.enter("70.5", on: screen.dayView.rows[1])

    #expect(screen.dayView.rows.allSatisfy { !$0.isKept })

    let later = DayScreen(
        startingFrom: [gym, weight], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(later.dayView.rows.allSatisfy { !$0.isKept })
}

@MainActor
@Test("entering a number on a day screen that is not keeping a record changes nothing and keeps nothing")
func enteringANumberOnADayScreenThatIsNotKeepingARecordChangesNothingAndKeepsNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytesBefore = Data("not a record".utf8)
    try bytesBefore.write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    try screen.enter("70.5", on: screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.recordState == .unreadable)
    #expect(try Data(contentsOf: place) == bytesBefore)
}

@MainActor
@Test("entering a number on one row leaves the other rows of the day as they were")
func enteringANumberOnOneRowLeavesTheOtherRowsOfTheDayAsTheyWere() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: daily, keptFrom: keptFrom, kind: .number(range: range))!
    let moodRange = Commitment.Range(lowest: 1, highest: 10)!
    let mood = Commitment(
        name: "Mood", schedule: daily, keptFrom: keptFrom, kind: .number(range: moodRange))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [gym, weight, mood], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("70.5", on: screen.dayView.rows[1])

    #expect(screen.dayView.rows.map(\.name) == ["Gym", "Weight", "Mood"])
    #expect(screen.dayView.rows.map(\.isKept) == [false, true, false])
}

@MainActor
@Test("entering a number on a day a day screen has moved back to keeps it on that day")
func enteringANumberOnADayADayScreenHasMovedBackToKeepsItOnThatDay() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: daily, keptFrom: keptFrom, kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()
    try screen.enter("70.5", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].isKept)

    let laterOnSunday = DayScreen(
        startingFrom: [weight], asOf: sunday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(laterOnSunday.dayView.rows[0].isKept)

    let laterOnMonday = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(!laterOnMonday.dayView.rows[0].isKept)
}

@MainActor
@Test("entering a number writes nothing to the roster's place")
func enteringANumberWritesNothingToTheRostersPlace() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let bytesAfterOpen = try Data(contentsOf: rosterPlace)

    try screen.enter("70.5", on: screen.dayView.rows[0])
    try screen.enter("", on: screen.dayView.rows[0])

    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpen)
    #expect(screen.rosterState == .kept)
}

@MainActor
@Test("committing an empty entry at a place that cannot be written is refused only on a row whose day holds a number")
func committingAnEmptyEntryAtAPlaceThatCannotBeWrittenIsRefusedOnlyOnARowWhoseDayHoldsANumber()
    throws
{
    let (place, rosterPlace) = freshPlaces()
    let directory = place.deletingLastPathComponent()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let weightRange = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: weightRange))!
    let moodRange = Commitment.Range(lowest: 1, highest: 10)!
    let mood = Commitment(
        name: "Mood", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: moodRange))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let seedStore = try RecordStore(at: place)
    try seedStore.add(Number(70.5, for: weight, on: monday)!)
    let seedRoster = try RosterStore(at: rosterPlace)
    try seedRoster.add(weight)
    try seedRoster.add(mood)

    try makeReadOnly(directory)
    defer { try? makeWritable(directory) }

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let weightRow = screen.dayView.rows.first { $0.name == "Weight" }!
    let moodRow = screen.dayView.rows.first { $0.name == "Mood" }!

    try screen.enter("", on: moodRow)
    #expect(screen.notice == nil)

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.enter("", on: weightRow)
    }

    #expect(screen.notice?.row == weightRow)
    #expect(screen.notice?.cause == nil)
    #expect(
        screen.dayView.rows.first { $0.name == "Weight" }!.numberEntry(asOf: monday)?.number
            == 70.5)
}

@MainActor
@Test("a number typed with a full stop is entered exactly as it was typed")
func aNumberTypedWithAFullStopIsEnteredExactlyAsItWasTyped() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: nil))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("70.5", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].numberEntry(asOf: monday)?.number?.description == "70.5")

    try screen.enter("0.000001", on: screen.dayView.rows[0])
    #expect(
        screen.dayView.rows[0].numberEntry(asOf: monday)?.number?.description
            == "0.000001")

    try screen.enter("98765432109876543210.5", on: screen.dayView.rows[0])
    #expect(
        screen.dayView.rows[0].numberEntry(asOf: monday)?.number?.description
            == "98765432109876543210.5")
}

@MainActor
@Test("a number typed with a comma is entered as the same number as one typed with a full stop")
func aNumberTypedWithACommaIsEnteredAsTheSameNumberAsOneTypedWithAFullStop() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("70,5", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].numberEntry(asOf: monday)?.number == 70.5)
}

@MainActor
@Test("a number typed with leading zeros or a trailing separator is entered as the number it says")
func aNumberTypedWithLeadingZerosOrATrailingSeparatorIsEnteredAsTheNumberItSays() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: nil))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("0000070.50", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].numberEntry(asOf: monday)?.number == 70.5)

    try screen.enter("70.", on: screen.dayView.rows[0])
    #expect(screen.dayView.rows[0].numberEntry(asOf: monday)?.number == 70)

    try screen.enter(" 70.5 ", on: screen.dayView.rows[0])
    #expect(screen.dayView.rows[0].numberEntry(asOf: monday)?.number == 70.5)
}

@MainActor
@Test("a negative number is entered where the commitment declares no range")
func aNegativeNumberIsEnteredWhereTheCommitmentDeclaresNoRange() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let balance = Commitment(
        name: "Balance", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: nil))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [balance], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("-12.75", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].numberEntry(asOf: monday)?.number == -12.75)
    #expect(screen.dayView.rows[0].isKept)
}

@MainActor
@Test(
    "an entry committed empty takes the number back, and one holding nothing but space does the same"
)
func anEntryCommittedEmptyTakesTheNumberBackAndOneHoldingNothingButSpaceDoesTheSame() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([.monday, .wednesday, .saturday])
    let weightRange = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: daily, keptFrom: keptFrom, kind: .number(range: weightRange))!
    let moodRange = Commitment.Range(lowest: 1, highest: 10)!
    let mood = Commitment(
        name: "Mood", schedule: daily, keptFrom: keptFrom, kind: .number(range: moodRange))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight, mood], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("70.5", on: screen.dayView.rows[0])
    try screen.enter("8", on: screen.dayView.rows[1])

    try screen.enter("", on: screen.dayView.rows[0])
    try screen.enter("  ", on: screen.dayView.rows[1])

    #expect(screen.dayView.rows.allSatisfy { !$0.isKept })
    let weightEntry = try #require(screen.dayView.rows[0].numberEntry(asOf: monday))
    let moodEntry = try #require(screen.dayView.rows[1].numberEntry(asOf: monday))
    #expect(weightEntry.number == nil)
    #expect(moodEntry.number == nil)
}

@MainActor
@Test("an entry committed with line breaks alone takes the number back")
func anEntryCommittedWithLineBreaksAloneTakesTheNumberBack() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("70.5", on: screen.dayView.rows[0])
    try screen.enter("\n\n\n", on: screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.dayView.rows[0].numberEntry(asOf: monday)?.number == nil)
    #expect(screen.notice == nil)

    try screen.enter("70.5", on: screen.dayView.rows[0])
    try screen.enter("\t\n", on: screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.dayView.rows[0].numberEntry(asOf: monday)?.number == nil)

    let later = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(!later.dayView.rows[0].isKept)
    #expect(later.dayView.rows[0].numberEntry(asOf: monday)?.number == nil)
}

@MainActor
@Test("an entry committed with a zero-width space alone keeps nothing and takes nothing back")
func anEntryCommittedWithAZeroWidthSpaceAloneKeepsNothingAndTakesNothingBack() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("70.5", on: screen.dayView.rows[0])
    try screen.enter("\u{200B}", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].numberEntry(asOf: monday)?.number == 70.5)
    #expect(screen.dayView.rows[0].isKept)
    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.cause == "Not a number")

    let later = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(later.dayView.rows[0].numberEntry(asOf: monday)?.number == 70.5)
    #expect(later.dayView.rows[0].isKept)
}

@MainActor
@Test("a value that is not a number keeps nothing and takes nothing back")
func aValueThatIsNotANumberKeepsNothingAndTakesNothingBack() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: nil))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("70.5", on: screen.dayView.rows[0])

    for notANumber in ["1.2.3", ".", "-", "12abc", "1e3", "7-0", "٧٠"] {
        try screen.enter(notANumber, on: screen.dayView.rows[0])
        #expect(screen.dayView.rows[0].numberEntry(asOf: monday)?.number == 70.5)
    }

    #expect(screen.dayView.rows[0].isKept)

    let later = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(later.dayView.rows[0].numberEntry(asOf: monday)?.number == 70.5)
}

@MainActor
@Test("a number of as many digits as can be kept is entered exactly")
func aNumberOfAsManyDigitsAsCanBeKeptIsEnteredExactly() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: nil))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let thirtyEightNines = String(repeating: "9", count: 38)

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter(thirtyEightNines, on: screen.dayView.rows[0])

    #expect(
        screen.dayView.rows[0].numberEntry(asOf: monday)?.number?.description
            == thirtyEightNines)
    #expect(screen.dayView.rows[0].isKept)

    let later = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(
        later.dayView.rows[0].numberEntry(asOf: monday)?.number?.description
            == thirtyEightNines)
}

@MainActor
@Test("a number too long to be kept exactly keeps nothing and takes nothing back")
func aNumberTooLongToBeKeptExactlyKeepsNothingAndTakesNothingBack() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: nil))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("70.5", on: screen.dayView.rows[0])

    let tooLong = [
        String(repeating: "9", count: 39),
        String(repeating: "1", count: 200),
        "0." + String(repeating: "0", count: 128) + "1",
    ]
    for notANumber in tooLong {
        try screen.enter(notANumber, on: screen.dayView.rows[0])
        #expect(screen.dayView.rows[0].numberEntry(asOf: monday)?.number == 70.5)
    }

    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.cause == "Not a number")
    #expect(screen.dayView.rows[0].isKept)

    let later = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(later.dayView.rows[0].numberEntry(asOf: monday)?.number == 70.5)
}

@MainActor
@Test("a number whose zeros lie outside its significant digits is entered exactly")
func aNumberWhoseZerosLieOutsideItsSignificantDigitsIsEnteredExactly() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: nil))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    let oneFollowedByFiftyZeros = "1" + String(repeating: "0", count: 50)
    try screen.enter(oneFollowedByFiftyZeros, on: screen.dayView.rows[0])
    #expect(
        screen.dayView.rows[0].numberEntry(asOf: monday)?.number?.description
            == oneFollowedByFiftyZeros)

    let oneAtTheFiftyFirstDecimalPlace = "0." + String(repeating: "0", count: 50) + "1"
    try screen.enter(oneAtTheFiftyFirstDecimalPlace, on: screen.dayView.rows[0])
    #expect(
        screen.dayView.rows[0].numberEntry(asOf: monday)?.number?.description
            == oneAtTheFiftyFirstDecimalPlace)

    let thirtyEightNinesFollowedByTenZeros =
        String(repeating: "9", count: 38) + String(repeating: "0", count: 10)
    try screen.enter(thirtyEightNinesFollowedByTenZeros, on: screen.dayView.rows[0])
    #expect(
        screen.dayView.rows[0].numberEntry(asOf: monday)?.number?.description
            == thirtyEightNinesFollowedByTenZeros)
}

@MainActor
@Test("a number too large to hold keeps nothing and takes nothing back")
func aNumberTooLargeToHoldKeepsNothingAndTakesNothingBack() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: nil))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("70.5", on: screen.dayView.rows[0])

    let oneFollowedByTwoHundredZeros = "1" + String(repeating: "0", count: 200)
    try screen.enter(oneFollowedByTwoHundredZeros, on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].numberEntry(asOf: monday)?.number == 70.5)
    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.cause == "Not a number")
    #expect(screen.dayView.rows[0].isKept)
}

@MainActor
@Test("a number with spaces among its digits keeps nothing and takes nothing back")
func aNumberWithSpacesAmongItsDigitsKeepsNothingAndTakesNothingBack() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: nil))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("70.5", on: screen.dayView.rows[0])

    for withSpaces in ["7 0", "1 000", "70. 5"] {
        try screen.enter(withSpaces, on: screen.dayView.rows[0])
        #expect(screen.dayView.rows[0].numberEntry(asOf: monday)?.number == 70.5)
    }

    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.cause == "Not a number")
    #expect(screen.dayView.rows[0].isKept)
}

/// Below `DayScreen`'s public seam (AGENTS.md rule 3 — free-form unit test below the seam, traces
/// to nothing in `specs/day-screen/spec.md`): `Digits.significant(in:)` and the significant-digit
/// count a typed value is read with (`read(_:)`, behind `writtenOut(_:)`) now share one algorithm
/// — G7 review finding 3 on this Story's PR — so this pins the two to agreeing on the value that
/// exposed their drift before the fix: 10^38 holds one significant digit, not thirty-nine.
@MainActor
@Test("Digits.significant(in:) and a typed value's own significant-digit count agree on 10^38")
func digitsSignificantAndATypedValuesOwnSignificantDigitCountAgreeOnTenToTheThirtyEighth() throws {
    let oneFollowedByThirtyEightZeros = "1" + String(repeating: "0", count: 38)
    let decimal = try #require(Decimal(string: oneFollowedByThirtyEightZeros))
    #expect(Digits.significant(in: decimal) == 1)

    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: nil))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter(oneFollowedByThirtyEightZeros, on: screen.dayView.rows[0])

    #expect(
        screen.dayView.rows[0].numberEntry(asOf: monday)?.number?.description
            == oneFollowedByThirtyEightZeros)
    #expect(screen.notice == nil)
}

@MainActor
@Test("a number outside the commitment's range is told on the row, naming the bounds it broke")
func aNumberOutsideTheCommitmentsRangeIsToldOnTheRowNamingTheBoundsItBroke() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([.monday, .wednesday, .saturday])
    let weightRange = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: daily, keptFrom: keptFrom, kind: .number(range: weightRange))!
    let moodRange = Commitment.Range(lowest: 1, highest: 10)!
    let mood = Commitment(
        name: "Mood", schedule: daily, keptFrom: keptFrom, kind: .number(range: moodRange))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight, mood], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("300", on: screen.dayView.rows[0])

    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.cause == "Must be between 40 and 150")

    try screen.enter("0.5", on: screen.dayView.rows[1])

    #expect(screen.notice?.row == screen.dayView.rows[1])
    #expect(screen.notice?.cause == "Must be between 1 and 10")
}

@MainActor
@Test("a number refused by the place is told on the row and names no cause")
func aNumberRefusedByThePlaceIsToldOnTheRowAndNamesNoCause() throws {
    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let enteringScreen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try enteringScreen.enter("70.5", on: enteringScreen.dayView.rows[0])
    }
    #expect(enteringScreen.notice?.row == enteringScreen.dayView.rows[0])
    #expect(enteringScreen.notice?.cause == nil)
}

@MainActor
@Test("a second refused commit is told on the row committed on last and no longer on the first")
func aSecondRefusedCommitIsToldOnTheRowCommittedOnLastAndNoLongerOnTheFirst() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([.monday, .wednesday, .saturday])
    let weightRange = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: daily, keptFrom: keptFrom, kind: .number(range: weightRange))!
    let moodRange = Commitment.Range(lowest: 1, highest: 10)!
    let mood = Commitment(
        name: "Mood", schedule: daily, keptFrom: keptFrom, kind: .number(range: moodRange))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight, mood], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("300", on: screen.dayView.rows[0])
    try screen.enter("1.2.3", on: screen.dayView.rows[1])

    #expect(screen.notice?.row == screen.dayView.rows[1])
    #expect(screen.notice?.cause == "Not a number")
}

@MainActor
@Test("a commit on a row for a day that has not arrived is told nothing on the row")
func aCommitOnARowForADayThatHasNotArrivedIsToldNothingOnTheRow() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: daily, keptFrom: keptFrom, kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showNextDay()
    try screen.enter("300", on: screen.dayView.rows[0])

    #expect(screen.notice == nil)
    #expect(!screen.dayView.rows[0].isKept)
}

@MainActor
@Test(
    "a commit on a row a day screen's day view does not hold is told nothing and does not end what is already told"
)
func aCommitOnARowADayScreensDayViewDoesNotHoldIsToldNothingAndDoesNotEndWhatIsAlreadyTold() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: daily, keptFrom: keptFrom, kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!

    let firstScreen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let secondScreen = DayScreen(
        startingFrom: [weight], asOf: wednesday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    try firstScreen.enter("300", on: firstScreen.dayView.rows[0])
    try firstScreen.enter("1.2.3", on: secondScreen.dayView.rows[0])

    #expect(firstScreen.notice?.row == firstScreen.dayView.rows[0])
    #expect(firstScreen.notice?.cause == "Must be between 40 and 150")
}

@MainActor
@Test("what a day screen tells on a row ends when a number is entered and kept")
func whatADayScreenTellsOnARowEndsWhenANumberIsEnteredAndKept() throws {
    let (place, rosterPlace) = freshPlaces()
    let directory = place.deletingLastPathComponent()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let seedRoster = try RosterStore(at: rosterPlace)
    try seedRoster.add(weight)

    try makeReadOnly(directory)
    defer { try? makeWritable(directory) }

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.enter("70.5", on: screen.dayView.rows[0])
    }

    try makeWritable(directory)

    try screen.enter("70.5", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].isKept)
    #expect(screen.notice == nil)
}

@MainActor
@Test("what a day screen tells on a row ends when a number is taken back and kept")
func whatADayScreenTellsOnARowEndsWhenANumberIsTakenBackAndKept() throws {
    let (place, rosterPlace) = freshPlaces()
    let directory = place.deletingLastPathComponent()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight, journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    try screen.enter("70.5", on: screen.dayView.rows[0])
    #expect(screen.dayView.rows[0].isKept)

    try makeReadOnly(directory)
    defer { try? makeWritable(directory) }

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(screen.dayView.rows[1])
    }

    try makeWritable(directory)

    try screen.enter("", on: screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.notice == nil)
}

@MainActor
@Test("what a day screen tells about a refused value ends when the app is shown again")
func whatADayScreenTellsAboutARefusedValueEndsWhenTheAppIsShownAgain() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("300", on: screen.dayView.rows[0])
    #expect(screen.notice != nil)

    screen.shown(asOf: monday)

    #expect(screen.notice == nil)
    #expect(!screen.dayView.rows[0].isKept)
}

@MainActor
@Test("what a day screen tells about a refused value ends when the day screen is moved to the day before")
func whatADayScreenTellsAboutARefusedValueEndsWhenTheDayScreenIsMovedToTheDayBefore() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: daily, keptFrom: keptFrom, kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("1.2.3", on: screen.dayView.rows[0])
    #expect(screen.notice != nil)

    screen.showPreviousDay()

    #expect(screen.notice == nil)
    #expect(screen.dayPickerReach.opensOn == sunday)
}

@MainActor
@Test("a note entered on a day screen is held by a day screen opened afterwards at the same place")
func aNoteEnteredOnADayScreenIsHeldByADayScreenOpenedAfterwardsAtTheSamePlace() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let first = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try first.enter("Ran 8k before work.", on: first.dayView.rows[0])

    let second = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(second.dayView.rows[0].isKept)
    #expect(second.dayView.rows[0].noteEntry(asOf: monday)?.note == "Ran 8k before work.")
}

@MainActor
@Test("a note entered on a day that already holds one replaces it")
func aNoteEnteredOnADayThatAlreadyHoldsOneReplacesIt() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("Ran 8k.", on: screen.dayView.rows[0])
    try screen.enter("Ran 8k. Knee held up.", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].noteEntry(asOf: monday)?.note == "Ran 8k. Knee held up.")

    let later = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(later.dayView.rows[0].noteEntry(asOf: monday)?.note == "Ran 8k. Knee held up.")
}

@MainActor
@Test("committing an empty note entry takes the note back")
func committingAnEmptyNoteEntryTakesTheNoteBack() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("Ran 8k.", on: screen.dayView.rows[0])
    try screen.enter("", on: screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.dayView.rows[0].noteEntry(asOf: monday)?.note == nil)

    let later = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(!later.dayView.rows[0].isKept)
    #expect(later.dayView.rows[0].noteEntry(asOf: monday)?.note == nil)
}

@MainActor
@Test("committing an empty note entry on a day that holds no note leaves the day as it was")
func committingAnEmptyNoteEntryOnADayThatHoldsNoNoteLeavesTheDayAsItWas() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("", on: screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)

    let later = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(!later.dayView.rows[0].isKept)
}

@MainActor
@Test("a note that cannot be kept is refused and leaves the day view as it was")
func aNoteThatCannotBeKeptIsRefusedAndLeavesTheDayViewAsItWas() throws {
    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.enter("Ran 8k.", on: screen.dayView.rows[0])
    }
    #expect(!screen.dayView.rows[0].isKept)

    let later = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(!later.dayView.rows[0].isKept)
}

@MainActor
@Test("entering a note on a row the day screen's day view does not hold changes nothing")
func enteringANoteOnARowTheDayScreensDayViewDoesNotHoldChangesNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!

    let mondayScreen = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let wednesdayScreen = DayScreen(
        startingFrom: [journal], asOf: wednesday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    try mondayScreen.enter("Ran 8k.", on: wednesdayScreen.dayView.rows[0])

    #expect(!mondayScreen.dayView.rows[0].isKept)

    let laterOnWednesday = DayScreen(
        startingFrom: [journal], asOf: wednesday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(!laterOnWednesday.dayView.rows[0].isKept)
}

@MainActor
@Test("committing on a row that offers no note entry changes nothing")
func committingOnARowThatOffersNoNoteEntryChangesNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom, kind: .tick)!
    let journal = Commitment(name: "Journal", schedule: daily, keptFrom: keptFrom, kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [gym, journal], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let gymRow = screen.dayView.rows.first { $0.name == "Gym" }!
    try screen.enter("Ran 8k.", on: gymRow)

    screen.showNextDay()

    let journalRow = screen.dayView.rows.first { $0.name == "Journal" }!
    try screen.enter("Ran 8k.", on: journalRow)

    #expect(!screen.dayView.rows.contains { $0.isKept })

    let later = DayScreen(
        startingFrom: [gym, journal], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(!later.dayView.rows.contains { $0.isKept })
}

@MainActor
@Test("a commit is read as the entry the row it was made on offers")
func aCommitIsReadAsTheEntryTheRowItWasMadeOnOffers() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight, journal], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("70.5", on: screen.dayView.rows[0])
    try screen.enter("70.5", on: screen.dayView.rows[1])

    #expect(screen.dayView.rows[0].numberEntry(asOf: monday)?.number == 70.5)
    #expect(screen.dayView.rows[1].noteEntry(asOf: monday)?.note == "70.5")
    #expect(screen.dayView.rows[0].isKept)
    #expect(screen.dayView.rows[1].isKept)
}

@MainActor
@Test("entering a note on a day screen that is not keeping a record changes nothing and keeps nothing")
func enteringANoteOnADayScreenThatIsNotKeepingARecordChangesNothingAndKeepsNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytesBefore = Data("not a record".utf8)
    try bytesBefore.write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    try screen.enter("Ran 8k.", on: screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.recordState == .unreadable)
    #expect(try Data(contentsOf: place) == bytesBefore)
}

@MainActor
@Test("entering a note on one row leaves the other rows of the day as they were")
func enteringANoteOnOneRowLeavesTheOtherRowsOfTheDayAsTheyWere() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom, kind: .tick)!
    let journal = Commitment(name: "Journal", schedule: daily, keptFrom: keptFrom, kind: .note)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: daily, keptFrom: keptFrom, kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [gym, journal, weight], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    try screen.enter("Ran 8k.", on: screen.dayView.rows[1])

    #expect(screen.dayView.rows.map(\.name) == ["Gym", "Journal", "Weight"])
    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.dayView.rows[1].isKept)
    #expect(!screen.dayView.rows[2].isKept)
}

@MainActor
@Test("entering a note on a day a day screen has moved back to keeps it on that day")
func enteringANoteOnADayADayScreenHasMovedBackToKeepsItOnThatDay() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journal = Commitment(name: "Journal", schedule: daily, keptFrom: keptFrom, kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!

    let screen = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()
    try screen.enter("Ran 8k.", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].isKept)

    let laterOnSunday = DayScreen(
        startingFrom: [journal], asOf: sunday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(laterOnSunday.dayView.rows[0].isKept)

    let laterOnMonday = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(!laterOnMonday.dayView.rows[0].isKept)
}

@MainActor
@Test("entering a note writes nothing to the roster's place")
func enteringANoteWritesNothingToTheRostersPlace() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let bytesAfterOpen = try Data(contentsOf: rosterPlace)

    try screen.enter("Ran 8k.", on: screen.dayView.rows[0])
    try screen.enter("", on: screen.dayView.rows[0])

    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpen)
    #expect(screen.rosterState == .kept)
}

@MainActor
@Test("a note committed with space around it is kept without that space and unchanged within it")
func aNoteCommittedWithSpaceAroundItIsKeptWithoutThatSpaceAndUnchangedWithinIt() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let committed = "  Ran 8k.\nKnee held up.\n  "

    let screen = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter(committed, on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].noteEntry(asOf: monday)?.note == "Ran 8k.\nKnee held up.")

    let later = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(later.dayView.rows[0].noteEntry(asOf: monday)?.note == "Ran 8k.\nKnee held up.")
}

@MainActor
@Test("a note committed with space inside it keeps every character of that space")
func aNoteCommittedWithSpaceInsideItKeepsEveryCharacterOfThatSpace() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let committed = "Monday\n\n   \tTuesday"

    let screen = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter(committed, on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].noteEntry(asOf: monday)?.note == committed)
}

@MainActor
@Test("an entry committed empty takes the note back, and one holding nothing but blank space does the same")
func anEntryCommittedEmptyTakesTheNoteBackAndOneHoldingNothingButBlankSpaceDoesTheSame() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let sleep = Commitment(name: "Sleep", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journal, sleep], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("Ran 8k.", on: screen.dayView.rows[0])
    try screen.enter("Slept badly.", on: screen.dayView.rows[1])

    try screen.enter("", on: screen.dayView.rows[0])
    try screen.enter("  ", on: screen.dayView.rows[1])

    #expect(!screen.dayView.rows[0].isKept)
    #expect(!screen.dayView.rows[1].isKept)
    #expect(screen.dayView.rows[0].noteEntry(asOf: monday)?.note == nil)
    #expect(screen.dayView.rows[1].noteEntry(asOf: monday)?.note == nil)
}

@MainActor
@Test("an entry committed with line breaks alone takes the note back")
func anEntryCommittedWithLineBreaksAloneTakesTheNoteBack() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("Ran 8k.", on: screen.dayView.rows[0])
    try screen.enter("\n\n\n", on: screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.dayView.rows[0].noteEntry(asOf: monday)?.note == nil)

    try screen.enter("Ran 8k.", on: screen.dayView.rows[0])
    try screen.enter("\t\n", on: screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.dayView.rows[0].noteEntry(asOf: monday)?.note == nil)

    let later = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(!later.dayView.rows[0].isKept)
    #expect(later.dayView.rows[0].noteEntry(asOf: monday)?.note == nil)
}

@MainActor
@Test("a note of one visible character among blank space is written rather than taken back")
func aNoteOfOneVisibleCharacterAmongBlankSpaceIsWrittenRatherThanTakenBack() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("\n  .\t\n", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].isKept)
    #expect(screen.dayView.rows[0].noteEntry(asOf: monday)?.note == ".")
}

@MainActor
@Test("a note of any length, any script and any number of lines is entered whole")
func aNoteOfAnyLengthAnyScriptAndAnyNumberOfLinesIsEnteredWhole() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let texts = [
        String(repeating: "a", count: 100_000),
        "שלום עולם",
        "🏃",
        (1...20).map { "Line \($0)" }.joined(separator: "\n"),
    ]

    let screen = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    for text in texts {
        try screen.enter(text, on: screen.dayView.rows[0])
        #expect(screen.dayView.rows[0].noteEntry(asOf: monday)?.note == text)
        #expect(screen.dayView.rows[0].isKept)
    }

    let later = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(later.dayView.rows[0].noteEntry(asOf: monday)?.note == texts.last)
}

@MainActor
@Test("a note refused by the place is told on the row and names no cause")
func aNoteRefusedByThePlaceIsToldOnTheRowAndNamesNoCause() throws {
    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let enteringScreen = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try enteringScreen.enter("Ran 8k.", on: enteringScreen.dayView.rows[0])
    }
    #expect(enteringScreen.notice?.row == enteringScreen.dayView.rows[0])
    #expect(enteringScreen.notice?.cause == nil)

    let (longPlace, longRosterPlace) = try blockerPlaces()
    let longScreen = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: longPlace,
        keepingRosterAt: longRosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(throws: RecordStoreError.cannotWrite(at: longPlace)) {
        try longScreen.enter(String(repeating: "a", count: 100_000), on: longScreen.dayView.rows[0])
    }
    #expect(longScreen.notice?.row == longScreen.dayView.rows[0])
    #expect(longScreen.notice?.cause == nil)
}

@MainActor
@Test("what a day screen tells on a row ends when a note is written and kept")
func whatADayScreenTellsOnARowEndsWhenANoteIsWrittenAndKept() throws {
    let (place, rosterPlace) = freshPlaces()
    let directory = place.deletingLastPathComponent()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let seedRoster = try RosterStore(at: rosterPlace)
    try seedRoster.add(journal)

    try makeReadOnly(directory)
    defer { try? makeWritable(directory) }

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.enter("Ran 8k.", on: screen.dayView.rows[0])
    }

    try makeWritable(directory)

    try screen.enter("Ran 8k.", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].isKept)
    #expect(screen.notice == nil)
}

@MainActor
@Test("what a day screen tells on a row ends when a note is taken back and kept")
func whatADayScreenTellsOnARowEndsWhenANoteIsTakenBackAndKept() throws {
    let (place, rosterPlace) = freshPlaces()
    let directory = place.deletingLastPathComponent()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let gym = Commitment(
        name: "Gym",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, kind: .tick)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journal, gym], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    try screen.enter("Ran 8k.", on: screen.dayView.rows[0])
    #expect(screen.dayView.rows[0].isKept)

    try makeReadOnly(directory)
    defer { try? makeWritable(directory) }

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(screen.dayView.rows[1])
    }

    try makeWritable(directory)

    try screen.enter("", on: screen.dayView.rows[0])

    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.notice == nil)
}

@MainActor
@Test("a commit on a row that offers no entry at all is told nothing on the row")
func aCommitOnARowThatOffersNoEntryAtAllIsToldNothingOnTheRow() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("Ran 8k.", on: screen.dayView.rows[0])

    #expect(screen.notice == nil)
    #expect(!screen.dayView.rows[0].isKept)

    try screen.enter("30", on: screen.dayView.rows[0])
    try screen.enter("", on: screen.dayView.rows[0])

    #expect(screen.notice == nil)
    #expect(!screen.dayView.rows[0].isKept)
}

@MainActor
@Test("adding on a total row makes the day screen say what the day has added")
func addingOnATotalRowMakesTheDayScreenSayWhatTheDayHasAdded() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("30", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "30 of 120")
    #expect(!screen.dayView.rows[0].isKept)
}

@MainActor
@Test("a day's additions accumulate rather than replace one another")
func aDaysAdditionsAccumulateRatherThanReplaceOneAnother() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("30", on: screen.dayView.rows[0])
    try screen.enter("30", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "60 of 120")

    try screen.enter("45.5", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "105.5 of 120")
}

@MainActor
@Test("an addition past the target keeps the day and says the true sum")
func anAdditionPastTheTargetKeepsTheDayAndSaysTheTrueSum() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("120", on: screen.dayView.rows[0])
    try screen.enter("30", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].isKept)
    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "150 of 120")
}

@MainActor
@Test("an addition that cannot be kept is refused and leaves the day view as it was")
func anAdditionThatCannotBeKeptIsRefusedAndLeavesTheDayViewAsItWas() throws {
    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.enter("30", on: screen.dayView.rows[0])
    }
    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "0 of 120")

    let later = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(later.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "0 of 120")
}

@MainActor
@Test("committing nothing at all in a total entry keeps nothing and takes nothing back")
func committingNothingAtAllInATotalEntryKeepsNothingAndTakesNothingBack() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("30", on: screen.dayView.rows[0])
    try screen.enter("90", on: screen.dayView.rows[0])
    try screen.enter("", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "120 of 120")
    #expect(screen.dayView.rows[0].isKept)

    try screen.enter("  ", on: screen.dayView.rows[0])
    try screen.enter("\n\n\n", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "120 of 120")
    #expect(screen.dayView.rows[0].isKept)

    let later = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(later.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "120 of 120")
    #expect(later.dayView.rows[0].isKept)
}

@MainActor
@Test("adding on a row the day screen's day view does not hold changes nothing")
func addingOnARowTheDayScreensDayViewDoesNotHoldChangesNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!

    let mondayScreen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let wednesdayScreen = DayScreen(
        startingFrom: [protein], asOf: wednesday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    try mondayScreen.enter("30", on: wednesdayScreen.dayView.rows[0])

    #expect(mondayScreen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "0 of 120")

    let laterOnWednesday = DayScreen(
        startingFrom: [protein], asOf: wednesday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(laterOnWednesday.dayView.rows[0].totalEntry(asOf: wednesday)?.soFarOfTarget == "0 of 120")
}

@MainActor
@Test("committing on a row that offers no total entry changes nothing")
func committingOnARowThatOffersNoTotalEntryChangesNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [gym, protein], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("30", on: screen.dayView.rows[0])
    screen.showNextDay()
    try screen.enter("30", on: screen.dayView.rows[1])

    #expect(screen.dayView.rows.allSatisfy { !$0.isKept })

    let later = DayScreen(
        startingFrom: [gym, protein], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(later.dayView.rows.allSatisfy { !$0.isKept })
    #expect(later.dayView.rows[1].totalEntry(asOf: monday)?.soFarOfTarget == "0 of 120")
}

@MainActor
@Test("a commit is read as the entry the row it was made on offers, for all four kinds")
func aCommitIsReadAsTheEntryTheRowItWasMadeOnOffersForAllFourKinds() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [gym, weight, journal, protein], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    for row in screen.dayView.rows {
        try screen.enter("120", on: row)
    }

    #expect(screen.dayView.rows[1].numberEntry(asOf: monday)?.number == 120)
    #expect(screen.dayView.rows[2].noteEntry(asOf: monday)?.note == "120")
    #expect(screen.dayView.rows[3].totalEntry(asOf: monday)?.soFarOfTarget == "120 of 120")
    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.dayView.rows[1].isKept)
    #expect(screen.dayView.rows[2].isKept)
    #expect(screen.dayView.rows[3].isKept)
}

@MainActor
@Test("adding on a day screen that is not keeping a record changes nothing and keeps nothing")
func addingOnADayScreenThatIsNotKeepingARecordChangesNothingAndKeepsNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytesBefore = Data("not a record".utf8)
    try bytesBefore.write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    try screen.enter("30", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "0 of 120")
    #expect(screen.recordState == .unreadable)
    #expect(try Data(contentsOf: place) == bytesBefore)
}

@MainActor
@Test("adding on one row leaves the other rows of the day as they were")
func addingOnOneRowLeavesTheOtherRowsOfTheDayAsTheyWere() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let water = Commitment(
        name: "Water", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(2)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [gym, protein, water], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("120", on: screen.dayView.rows[1])

    #expect(screen.dayView.rows.map(\.name) == ["Gym", "Protein", "Water"])
    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.dayView.rows[1].isKept)
    #expect(!screen.dayView.rows[2].isKept)
    #expect(screen.dayView.rows[2].totalEntry(asOf: monday)?.soFarOfTarget == "0 of 2")
}

@MainActor
@Test("adding on a day a day screen has moved back to keeps it on that day")
func addingOnADayADayScreenHasMovedBackToKeepsItOnThatDay() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let protein = Commitment(
        name: "Protein", schedule: daily, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()
    try screen.enter("120", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].isKept)

    let laterOnSunday = DayScreen(
        startingFrom: [protein], asOf: sunday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(laterOnSunday.dayView.rows[0].isKept)

    let laterOnMonday = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(!laterOnMonday.dayView.rows[0].isKept)
    #expect(laterOnMonday.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "0 of 120")
}

@MainActor
@Test("adding writes nothing to the roster's place")
func addingWritesNothingToTheRostersPlace() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let bytesAfterOpen = try Data(contentsOf: rosterPlace)

    try screen.enter("30", on: screen.dayView.rows[0])
    try screen.enter("", on: screen.dayView.rows[0])

    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpen)
    #expect(screen.rosterState == .kept)
}

@MainActor
@Test("an amount committed with space around it is added")
func anAmountCommittedWithSpaceAroundItIsAdded() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("  30\n", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "30 of 120")
    #expect(screen.notice == nil)
}

@MainActor
@Test("an amount typed with a comma is added as the same amount as one typed with a full stop")
func anAmountTypedWithACommaIsAddedAsTheSameAmountAsOneTypedWithAFullStop() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("45,5", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "45.5 of 120")

    try screen.enter("0000030.50", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "76 of 120")
}

@MainActor
@Test("a value that is not a number committed in a total entry is refused and told on the row")
func aValueThatIsNotANumberCommittedInATotalEntryIsRefusedAndToldOnTheRow() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("30", on: screen.dayView.rows[0])

    for text in ["1.2.3", ".", "-", "12abc", "1e3", "\u{200B}"] {
        try screen.enter(text, on: screen.dayView.rows[0])
        #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "30 of 120")
    }

    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.cause == "Not a number")

    let later = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(later.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "30 of 120")
}

@MainActor
@Test("a commit saying nothing in a total entry changes nothing and tells nothing")
func aCommitSayingNothingInATotalEntryChangesNothingAndTellsNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("30", on: screen.dayView.rows[0])
    try screen.enter("0", on: screen.dayView.rows[0])
    try screen.enter("", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "30 of 120")
    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.cause == "Must be more than 0")

    try screen.enter("\t\n", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "30 of 120")
    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.cause == "Must be more than 0")
}

@MainActor
@Test("an amount of zero or below is refused and told on the row")
func anAmountOfZeroOrBelowIsRefusedAndToldOnTheRow() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("30", on: screen.dayView.rows[0])
    try screen.enter("0", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "30 of 120")
    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.cause == "Must be more than 0")

    for text in ["-30", "-0.000001"] {
        try screen.enter(text, on: screen.dayView.rows[0])
        #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "30 of 120")
        #expect(screen.notice?.cause == "Must be more than 0")
    }

    let later = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(later.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "30 of 120")
}

@MainActor
@Test("an amount that would take the day's sum past what can be kept exactly is refused and told on the row")
func anAmountThatWouldTakeTheDaysSumPastWhatCanBeKeptExactlyIsRefusedAndToldOnTheRow() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let thirtyEightNines = String(repeating: "9", count: 38)

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter(thirtyEightNines, on: screen.dayView.rows[0])
    try screen.enter("0.5", on: screen.dayView.rows[0])

    #expect(
        screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget
            == "\(thirtyEightNines) of 120")
    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.cause == "Too large to add")

    let laterForThirtyEight = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(
        laterForThirtyEight.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget
            == "\(thirtyEightNines) of 120")
}

@MainActor
@Test("an amount that takes the day's sum to a number that can be kept exactly is added")
func anAmountThatTakesTheDaysSumToANumberThatCanBeKeptExactlyIsAdded() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let thirtyEightNines = String(repeating: "9", count: 38)
    let oneFollowedByThirtyEightZeros = "1" + String(repeating: "0", count: 38)

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter(thirtyEightNines, on: screen.dayView.rows[0])
    try screen.enter("1", on: screen.dayView.rows[0])

    #expect(
        screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget
            == "\(oneFollowedByThirtyEightZeros) of 120")
    #expect(screen.notice == nil)

    try screen.enter("0.5", on: screen.dayView.rows[0])

    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.cause == "Too large to add")
    #expect(
        screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget
            == "\(oneFollowedByThirtyEightZeros) of 120")
}

@MainActor
@Test("taking back the last addition on a row leaves the day short by exactly that amount")
func takingBackTheLastAdditionOnARowLeavesTheDayShortByExactlyThatAmount() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("30", on: screen.dayView.rows[0])
    try screen.enter("90", on: screen.dayView.rows[0])
    try screen.takeBackLast(on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "30 of 120")
    #expect(!screen.dayView.rows[0].isKept)
}

@MainActor
@Test("taking back the last addition twice removes the two most recent")
func takingBackTheLastAdditionTwiceRemovesTheTwoMostRecent() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("30", on: screen.dayView.rows[0])
    try screen.enter("45", on: screen.dayView.rows[0])
    try screen.enter("50", on: screen.dayView.rows[0])
    try screen.takeBackLast(on: screen.dayView.rows[0])
    try screen.takeBackLast(on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "30 of 120")
    #expect(screen.dayView.rows[0].offersTakeBackLast(asOf: monday))

    try screen.takeBackLast(on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "0 of 120")
    #expect(!screen.dayView.rows[0].offersTakeBackLast(asOf: monday))
}

@MainActor
@Test("a take-back is held by a day screen opened afterwards at the same place")
func aTakeBackIsHeldByADayScreenOpenedAfterwardsAtTheSamePlace() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let first = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try first.enter("30", on: first.dayView.rows[0])
    try first.enter("90", on: first.dayView.rows[0])
    try first.takeBackLast(on: first.dayView.rows[0])

    let second = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(!second.dayView.rows[0].isKept)
    #expect(second.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "30 of 120")
}

@MainActor
@Test("a take-back that cannot be kept is refused and leaves the day view as it was")
func aTakeBackThatCannotBeKeptIsRefusedAndLeavesTheDayViewAsItWas() throws {
    let (place, rosterPlace) = freshPlaces()
    let directory = place.deletingLastPathComponent()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("30", on: screen.dayView.rows[0])
    try screen.enter("90", on: screen.dayView.rows[0])

    try makeReadOnly(directory)
    defer { try? makeWritable(directory) }

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.takeBackLast(on: screen.dayView.rows[0])
    }

    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "120 of 120")
    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.cause == nil)
}

@MainActor
@Test("taking back on a row that offers no take-back changes nothing")
func takingBackOnARowThatOffersNoTakeBackChangesNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [gym, protein], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.takeBackLast(on: screen.dayView.rows[0])
    try screen.takeBackLast(on: screen.dayView.rows[1])

    #expect(screen.dayView.rows.allSatisfy { !$0.isKept })
    #expect(screen.dayView.rows[1].totalEntry(asOf: monday)?.soFarOfTarget == "0 of 120")
    #expect(screen.notice == nil)
}

@MainActor
@Test("taking back on a row for a day that has not arrived changes nothing")
func takingBackOnARowForADayThatHasNotArrivedChangesNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let protein = Commitment(
        name: "Protein", schedule: daily, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("30", on: screen.dayView.rows[0])
    screen.showNextDay()
    try screen.takeBackLast(on: screen.dayView.rows[0])

    #expect(screen.notice == nil)

    let later = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(later.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "30 of 120")
}

@MainActor
@Test("taking back on a row the day screen's day view does not hold changes nothing")
func takingBackOnARowTheDayScreensDayViewDoesNotHoldChangesNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let protein = Commitment(
        name: "Protein", schedule: daily, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let mondayScreen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let tuesdayScreen = DayScreen(
        startingFrom: [protein], asOf: tuesday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try mondayScreen.enter("30", on: mondayScreen.dayView.rows[0])
    try tuesdayScreen.enter("30", on: tuesdayScreen.dayView.rows[0])

    try mondayScreen.takeBackLast(on: tuesdayScreen.dayView.rows[0])

    let laterOnTuesday = DayScreen(
        startingFrom: [protein], asOf: tuesday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(laterOnTuesday.dayView.rows[0].totalEntry(asOf: tuesday)?.soFarOfTarget == "30 of 120")
}

@MainActor
@Test("taking back on a day screen that is not keeping a record changes nothing and keeps nothing")
func takingBackOnADayScreenThatIsNotKeepingARecordChangesNothingAndKeepsNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytesBefore = Data("not a record".utf8)
    try bytesBefore.write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    try screen.takeBackLast(on: screen.dayView.rows[0])

    #expect(screen.recordState == .unreadable)
    #expect(screen.notice == nil)
    #expect(try Data(contentsOf: place) == bytesBefore)
}

@MainActor
@Test("taking back writes nothing to the roster's place")
func takingBackWritesNothingToTheRostersPlace() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("30", on: screen.dayView.rows[0])
    let bytesAfterAdding = try Data(contentsOf: rosterPlace)

    try screen.takeBackLast(on: screen.dayView.rows[0])

    #expect(try Data(contentsOf: rosterPlace) == bytesAfterAdding)
    #expect(screen.rosterState == .kept)
}

@MainActor
@Test("an amount that is not above zero is told on the row, saying so")
func anAmountThatIsNotAboveZeroIsToldOnTheRowSayingSo() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let water = Commitment(
        name: "Water", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(2)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein, water], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("0", on: screen.dayView.rows[0])

    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.cause == "Must be more than 0")

    try screen.enter("-1", on: screen.dayView.rows[1])

    #expect(screen.notice?.row == screen.dayView.rows[1])
    #expect(screen.notice?.cause == "Must be more than 0")
}

@MainActor
@Test("an amount too large to add to the day is told on the row, saying so")
func anAmountTooLargeToAddToTheDayIsToldOnTheRowSayingSo() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let thirtyEightNines = String(repeating: "9", count: 38)

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter(thirtyEightNines, on: screen.dayView.rows[0])
    try screen.enter("0.5", on: screen.dayView.rows[0])

    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.cause == "Too large to add")
    #expect(screen.notice?.cause != "Not a number")
    #expect(screen.notice?.cause != "Must be more than 0")
}

@MainActor
@Test(
    "a value that is not a number committed in a total entry is told the same thing a number entry tells"
)
func aValueThatIsNotANumberCommittedInATotalEntryIsToldTheSameThingANumberEntryTells() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight, protein], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("1.2.3", on: screen.dayView.rows[0])
    let causeOnNumberRow = screen.notice?.cause

    try screen.enter("1.2.3", on: screen.dayView.rows[1])

    #expect(screen.notice?.row == screen.dayView.rows[1])
    #expect(screen.notice?.cause == "Not a number")
    #expect(screen.notice?.cause == causeOnNumberRow)
}

@MainActor
@Test("an addition refused by the place is told on the row and names no cause")
func anAdditionRefusedByThePlaceIsToldOnTheRowAndNamesNoCause() throws {
    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.enter("30", on: screen.dayView.rows[0])
    }

    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.cause == nil)
}

@MainActor
@Test("what a day screen tells on a row ends when an addition is made and kept")
func whatADayScreenTellsOnARowEndsWhenAnAdditionIsMadeAndKept() throws {
    let (place, rosterPlace) = freshPlaces()
    let directory = place.deletingLastPathComponent()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let seedRoster = try RosterStore(at: rosterPlace)
    try seedRoster.add(protein)

    try makeReadOnly(directory)
    defer { try? makeWritable(directory) }

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.enter("30", on: screen.dayView.rows[0])
    }

    try makeWritable(directory)

    try screen.enter("30", on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "30 of 120")
    #expect(screen.notice == nil)
}

@MainActor
@Test("what a day screen tells on a row ends when a last addition is taken back and kept")
func whatADayScreenTellsOnARowEndsWhenALastAdditionIsTakenBackAndKept() throws {
    let (place, rosterPlace) = freshPlaces()
    let directory = place.deletingLastPathComponent()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let gym = Commitment(
        name: "Gym",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, kind: .tick)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein, gym], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    try screen.enter("30", on: screen.dayView.rows[0])

    try makeReadOnly(directory)
    defer { try? makeWritable(directory) }

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(screen.dayView.rows[1])
    }

    try makeWritable(directory)

    try screen.takeBackLast(on: screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "0 of 120")
    #expect(screen.notice == nil)
}

@MainActor
@Test("a commit saying nothing in a total entry leaves what a day screen is telling standing")
func aCommitSayingNothingInATotalEntryLeavesWhatADayScreenIsTellingStanding() throws {
    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.enter("30", on: screen.dayView.rows[0])
    }

    try screen.enter("", on: screen.dayView.rows[0])

    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.cause == nil)
    #expect(screen.dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "0 of 120")
}

@MainActor
@Test("a commit on a total row on a day screen that is not keeping a record is told nothing on the row")
func aCommitOnATotalRowOnADayScreenThatIsNotKeepingARecordIsToldNothingOnTheRow() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a record".utf8).write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("30", on: screen.dayView.rows[0])

    #expect(screen.notice == nil)
    #expect(screen.recordState == .unreadable)

    try screen.enter("0", on: screen.dayView.rows[0])
    try screen.enter("1.2.3", on: screen.dayView.rows[0])
    try screen.enter("", on: screen.dayView.rows[0])

    #expect(screen.notice == nil)

    try screen.takeBackLast(on: screen.dayView.rows[0])

    #expect(screen.notice == nil)
}

@MainActor
@Test("a commit on a total row for a day that has not arrived is told nothing on the row")
func aCommitOnATotalRowForADayThatHasNotArrivedIsToldNothingOnTheRow() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let protein = Commitment(
        name: "Protein", schedule: daily, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showNextDay()
    try screen.enter("0", on: screen.dayView.rows[0])

    #expect(screen.notice == nil)
    #expect(!screen.dayView.rows[0].isKept)

    try screen.takeBackLast(on: screen.dayView.rows[0])

    #expect(screen.notice == nil)
}

@MainActor
@Test("taking back on a row that offers no take-back is told nothing on the row")
func takingBackOnARowThatOffersNoTakeBackIsToldNothingOnTheRow() throws {
    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [gym, protein], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(screen.dayView.rows[0])
    }

    try screen.takeBackLast(on: screen.dayView.rows[1])

    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.cause == nil)
}

@MainActor
@Test("a commit on a note row for a day that has not arrived is told nothing on the row")
func aCommitOnANoteRowForADayThatHasNotArrivedIsToldNothingOnTheRow() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journal = Commitment(name: "Journal", schedule: daily, keptFrom: keptFrom, kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journal], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showNextDay()
    try screen.enter("Ran 8k.", on: screen.dayView.rows[0])

    #expect(screen.notice == nil)
    #expect(!screen.dayView.rows[0].isKept)
}

@MainActor
@Test("a commit on a day screen holding a record from a later version is told nothing whatever was committed")
func aCommitOnADayScreenHoldingARecordFromALaterVersionIsToldNothingWhateverWasCommitted() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"version": 6, "ticks": []}"#.utf8).write(to: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight, journal, protein], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    try screen.enter("300", on: screen.dayView.rows[0])
    try screen.enter("1.2.3", on: screen.dayView.rows[0])
    try screen.enter("Ran 8k.", on: screen.dayView.rows[1])
    try screen.enter("", on: screen.dayView.rows[1])
    try screen.enter("0", on: screen.dayView.rows[2])

    #expect(screen.notice == nil)
    #expect(screen.recordState == .writtenByALaterVersion)
}

@MainActor
@Test("a day screen draws its rows in the groups its roster puts them in")
func aDayScreenDrawsItsRowsInTheGroupsItsRosterPutsThemIn() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.add(magnesium)
    try rosterStore.add(journaling)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(magnesium, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.dayView.groups.map(\.category) == ["Supplements", "Sport", nil])
    #expect(
        screen.dayView.rows.map(\.name) == ["Creatine", "Magnesium", "Gym", "Journaling"])
    #expect(screen.rosterState == .kept)
}

@MainActor
@Test("a day screen draws a group again after a category is changed at its roster place")
func aDayScreenDrawsAGroupAgainAfterACategoryIsChangedAtItsRosterPlace() throws {
    let (place, rosterPlace) = freshPlaces()
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

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.dayView.groups.map(\.category) == [nil])
    #expect(screen.dayView.rows.map(\.name) == ["Creatine", "Gym"])

    try rosterStore.put(creatine, under: "Supplements")
    screen.shown(asOf: monday)

    #expect(screen.dayView.groups.map(\.category) == ["Supplements", nil])
    #expect(screen.dayView.rows.map(\.name) == ["Creatine", "Gym"])
}

@MainActor
@Test("a day screen draws a removed commitment under a category exactly as it draws a stopped one")
func aDayScreenDrawsARemovedCommitmentUnderACategoryExactlyAsItDrawsAStoppedOne() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let stoppedCreatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let removedCreatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let (stoppedPlace, stoppedRosterPlace) = freshPlaces()
    let stoppedRoster = try RosterStore(at: stoppedRosterPlace)
    try stoppedRoster.add(stoppedCreatine)
    try stoppedRoster.put(stoppedCreatine, under: "Supplements")
    try stoppedRoster.retire(stoppedCreatine, keptUntil: sunday)

    let (removedPlace, removedRosterPlace) = freshPlaces()
    let removedRoster = try RosterStore(at: removedRosterPlace)
    try removedRoster.add(removedCreatine)
    try removedRoster.put(removedCreatine, under: "Supplements")
    try removedRoster.remove(removedCreatine, keptUntil: sunday)

    let stoppedScreen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: stoppedPlace,
        keepingRosterAt: stoppedRosterPlace, keepingOneOffsAt: freshOneOffPlace())
    stoppedScreen.showPreviousDay()

    let removedScreen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: removedPlace,
        keepingRosterAt: removedRosterPlace, keepingOneOffsAt: freshOneOffPlace())
    removedScreen.showPreviousDay()

    #expect(stoppedScreen.dayView == removedScreen.dayView)
    #expect(stoppedScreen.dayView.groups.map(\.category) == ["Supplements"])
    #expect(stoppedScreen.dayView.rows.map(\.name) == ["Creatine"])
}

@MainActor
@Test("a day screen moved into the past offers the way back to today")
func aDayScreenMovedIntoThePastOffersTheWayBackToToday() {
    let (place, rosterPlace) = freshPlaces()
    let (otherPlace, otherRosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()

    #expect(screen.offersGoingBackToToday)

    let other = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: otherPlace, keepingRosterAt: otherRosterPlace, keepingOneOffsAt: freshOneOffPlace())
    for _ in 0..<3 {
        other.showPreviousDay()
    }

    #expect(other.offersGoingBackToToday)
}

@MainActor
@Test("a day screen moved into the future offers the way back to today")
func aDayScreenMovedIntoTheFutureOffersTheWayBackToToday() {
    let (place, rosterPlace) = freshPlaces()
    let (otherPlace, otherRosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showNextDay()

    #expect(screen.offersGoingBackToToday)

    let other = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: otherPlace, keepingRosterAt: otherRosterPlace, keepingOneOffsAt: freshOneOffPlace())
    for _ in 0..<3 {
        other.showNextDay()
    }

    #expect(other.offersGoingBackToToday)
}

@MainActor
@Test("a day screen offers no way back to today once it has gone back")
func aDayScreenOffersNoWayBackToTodayOnceItHasGoneBack() {
    let (place, rosterPlace) = freshPlaces()
    let (otherPlace, otherRosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()
    screen.showPreviousDay()
    screen.showToday()

    #expect(!screen.offersGoingBackToToday)

    let other = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: otherPlace, keepingRosterAt: otherRosterPlace, keepingOneOffsAt: freshOneOffPlace())
    other.showPreviousDay()
    other.showNextDay()

    #expect(!other.offersGoingBackToToday)
}

@MainActor
@Test("going back to today on a day screen that offers no way back leaves it showing that today")
func goingBackToTodayOnADayScreenThatOffersNoWayBackLeavesItShowingThatToday() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(!screen.offersGoingBackToToday)

    screen.showToday()

    #expect(screen.dayPickerReach.opensOn == monday)
    #expect(!screen.offersGoingBackToToday)
}

@MainActor
@Test("a day screen shown again on a later day offers the way back to today from the day it stayed on")
func aDayScreenShownAgainOnALaterDayOffersTheWayBackToTodayFromTheDayItStayedOn() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()
    screen.shown(asOf: wednesday)

    #expect(screen.offersGoingBackToToday)

    screen.showToday()

    #expect(screen.dayPickerReach.opensOn == wednesday)
    #expect(!screen.offersGoingBackToToday)
}

@MainActor
@Test("a day screen showing its today when the app is shown again on a later day offers no way back to today")
func aDayScreenShowingItsTodayWhenTheAppIsShownAgainOnALaterDayOffersNoWayBackToToday() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.shown(asOf: wednesday)

    #expect(!screen.offersGoingBackToToday)
    #expect(screen.dayPickerReach.opensOn == wednesday)
}

@MainActor
@Test("a day screen the day it is showing has caught up with offers no way back to today")
func aDayScreenTheDayItIsShowingHasCaughtUpWithOffersNoWayBackToToday() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showNextDay()
    screen.shown(asOf: tuesday)

    #expect(!screen.offersGoingBackToToday)
    #expect(screen.dayPickerReach.opensOn == tuesday)
}

@MainActor
@Test("a day screen whose move had nowhere to go offers no way back to today")
func aDayScreenWhoseMoveHadNowhereToGoOffersNoWayBackToToday() {
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

    let first = DayScreen(startingFrom: [journaling], asOf: firstSupported, keepingRecordAt: firstPlace, keepingRosterAt: firstRosterPlace, keepingOneOffsAt: freshOneOffPlace())
    first.showPreviousDay()

    let second = DayScreen(startingFrom: [journaling], asOf: lastSupported, keepingRecordAt: secondPlace, keepingRosterAt: secondRosterPlace, keepingOneOffsAt: freshOneOffPlace())
    second.showNextDay()

    #expect(!first.offersGoingBackToToday)
    #expect(!second.offersGoingBackToToday)

    first.showNextDay()

    #expect(first.offersGoingBackToToday)
}

@MainActor
@Test("a day screen that cannot read its record says whether it offers the way back to today like any other")
func aDayScreenThatCannotReadItsRecordSaysWhetherItOffersTheWayBackToTodayLikeAnyOther() throws {
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

    let screen = DayScreen(startingFrom: [journaling], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()

    #expect(screen.offersGoingBackToToday)
    #expect(screen.recordState == .unreadable)

    screen.showToday()

    #expect(!screen.offersGoingBackToToday)
    #expect(screen.recordState == .unreadable)
}

// MARK: - add-day-picker

@MainActor
@Test("a day screen's day picker opens on the day it is showing")
func aDayScreensDayPickerOpensOnTheDayItIsShowing() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.dayPickerReach.opensOn == monday)

    screen.showPreviousDay()

    #expect(screen.dayPickerReach.opensOn == CalendarDate(year: 2026, month: 8, day: 30))

    screen.showNextDay()
    screen.showNextDay()

    #expect(screen.dayPickerReach.opensOn == CalendarDate(year: 2026, month: 9, day: 1))
}

@MainActor
@Test("a day screen's day picker reaches back to the earliest day anything on its roster is kept from")
func aDayScreensDayPickerReachesBackToTheEarliestDayAnythingOnItsRosterIsKeptFrom() throws {
    let (place, rosterPlace) = freshPlaces()
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(
        name: "Gym", schedule: daily, keptFrom: CalendarDate(year: 2026, month: 3, day: 1)!)!
    let run = Commitment(
        name: "Run", schedule: daily, keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let journaling = Commitment(
        name: "Journaling", schedule: daily,
        keptFrom: CalendarDate(year: 2026, month: 2, day: 1)!)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(run)
    try rosterStore.add(journaling)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.dayPickerReach.earliest == CalendarDate(year: 2026, month: 1, day: 1))
    #expect(screen.dayPickerReach.opensOn == monday)
}

@MainActor
@Test("a day screen's day picker reaches back past a commitment its roster has stopped keeping")
func aDayScreensDayPickerReachesBackPastACommitmentItsRosterHasStoppedKeeping() throws {
    let (place, rosterPlace) = freshPlaces()
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(
        name: "Gym", schedule: daily, keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let run = Commitment(
        name: "Run", schedule: daily, keptFrom: CalendarDate(year: 2026, month: 3, day: 1)!)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(run)
    try rosterStore.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.dayPickerReach.earliest == CalendarDate(year: 2026, month: 1, day: 1))
    #expect(screen.dayView.rows.map(\.name) == ["Run"])
}

@MainActor
@Test("a day screen's day picker reaches back to the day it is showing where that is the earlier of the two")
func aDayScreensDayPickerReachesBackToTheDayItIsShowingWhereThatIsTheEarlierOfTheTwo() {
    let (place, rosterPlace) = freshPlaces()
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: CalendarDate(year: 2026, month: 6, day: 1)!)!
    let thursday = CalendarDate(year: 2026, month: 1, day: 1)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: thursday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.dayPickerReach.opensOn == thursday)
    #expect(screen.dayPickerReach.earliest == thursday)

    screen.showPreviousDay()

    let wednesday = CalendarDate(year: 2025, month: 12, day: 31)!
    #expect(screen.dayPickerReach.opensOn == wednesday)
    #expect(screen.dayPickerReach.earliest == wednesday)
}

@MainActor
@Test("a day screen that cannot read its roster reaches back to the today it was handed")
func aDayScreenThatCannotReadItsRosterReachesBackToTheTodayItWasHanded() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a roster is written as".utf8).write(to: rosterPlace)

    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.rosterState == .notKept)
    #expect(screen.dayPickerReach.opensOn == monday)
    #expect(screen.dayPickerReach.earliest == monday)

    screen.showPreviousDay()

    #expect(screen.dayPickerReach.earliest == CalendarDate(year: 2026, month: 8, day: 30))
}

@MainActor
@Test("a day screen that takes on the commitments it was handed reaches back to the earliest of those")
func aDayScreenThatTakesOnTheCommitmentsItWasHandedReachesBackToTheEarliestOfThose() {
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(
        name: "Gym", schedule: daily, keptFrom: CalendarDate(year: 2026, month: 3, day: 1)!)!
    let journaling = Commitment(
        name: "Journaling", schedule: daily,
        keptFrom: CalendarDate(year: 2026, month: 2, day: 1)!)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let (place, rosterPlace) = freshPlaces()
    let screen = DayScreen(
        startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.dayPickerReach.earliest == CalendarDate(year: 2026, month: 2, day: 1))

    let (secondPlace, secondRosterPlace) = freshPlaces()
    let second = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: secondPlace,
        keepingRosterAt: secondRosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(second.dayPickerReach.earliest == monday)
}

@MainActor
@Test("a day screen whose roster stops being readable goes on showing its day and reaches back to it")
func aDayScreenWhoseRosterStopsBeingReadableGoesOnShowingItsDayAndReachesBackToIt() throws {
    let (place, rosterPlace) = freshPlaces()
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: CalendarDate(year: 2020, month: 1, day: 1)!)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(journaling)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    screen.showPreviousDay()

    #expect(screen.dayPickerReach.earliest == CalendarDate(year: 2020, month: 1, day: 1))

    try FileManager.default.removeItem(at: rosterPlace)
    try Data("not what a roster is written as".utf8).write(to: rosterPlace)

    screen.returnedTo()

    #expect(screen.dayPickerReach.opensOn == sunday)
    #expect(screen.dayPickerReach.earliest == sunday)
}

@MainActor
@Test("a day screen that cannot read its record says the reach of its day picker like any other")
func aDayScreenThatCannotReadItsRecordSaysTheReachOfItsDayPickerLikeAnyOther() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a record is written as".utf8).write(to: place)

    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.recordState == .unreadable)
    #expect(screen.dayPickerReach.opensOn == monday)
    #expect(screen.dayPickerReach.earliest == CalendarDate(year: 2026, month: 1, day: 1))
}

@MainActor
@Test("a day screen shown again reads the reach of its day picker off the roster it then reads")
func aDayScreenShownAgainReadsTheReachOfItsDayPickerOffTheRosterItThenReads() throws {
    let (place, rosterPlace) = freshPlaces()
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(
        name: "Journaling", schedule: daily, keptFrom: CalendarDate(year: 2020, month: 1, day: 1)!)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(journaling)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.dayPickerReach.earliest == CalendarDate(year: 2020, month: 1, day: 1))

    let gym = Commitment(
        name: "Gym", schedule: daily, keptFrom: CalendarDate(year: 2010, month: 1, day: 1)!)!
    let other = try RosterStore(at: rosterPlace)
    try other.add(gym)

    screen.shown(asOf: monday)

    #expect(screen.dayPickerReach.earliest == CalendarDate(year: 2010, month: 1, day: 1))
}

@MainActor
@Test("a day screen's day picker reaches back to the first supported date and opens on the last")
func aDayScreensDayPickerReachesBackToTheFirstSupportedDateAndOpensOnTheLast() {
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(
        name: "Journaling", schedule: daily,
        keptFrom: CalendarDate(year: 1583, month: 1, day: 1)!)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let (place, rosterPlace) = freshPlaces()
    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.dayPickerReach.earliest == CalendarDate(year: 1583, month: 1, day: 1))

    let friday = CalendarDate(year: 9999, month: 12, day: 31)!
    let (secondPlace, secondRosterPlace) = freshPlaces()
    let second = DayScreen(
        startingFrom: [journaling], asOf: friday, keepingRecordAt: secondPlace,
        keepingRosterAt: secondRosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(second.dayPickerReach.opensOn == friday)
    #expect(second.dayPickerReach.earliest == CalendarDate(year: 1583, month: 1, day: 1))
}

@MainActor
@Test("a day screen's day picker reaches back to the day a commitment is kept from though nothing is due on that day")
func aDayScreensDayPickerReachesBackToTheDayACommitmentIsKeptFromThoughNothingIsDueOnThatDay() {
    let finances = Commitment(
        name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 25)!),
        keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: CalendarDate(year: 2026, month: 3, day: 1)!)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let (place, rosterPlace) = freshPlaces()
    let screen = DayScreen(
        startingFrom: [finances, journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.dayPickerReach.earliest == CalendarDate(year: 2026, month: 1, day: 1))
    #expect(screen.dayPickerReach.earliest != CalendarDate(year: 2026, month: 1, day: 25))
    #expect(screen.dayPickerReach.earliest != CalendarDate(year: 2026, month: 3, day: 1))
    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
}

@MainActor
@Test("a day screen shows a day picked between the earliest day its picker reaches and the day it was showing")
func aDayScreenShowsADayPickedBetweenTheEarliestDayItsPickerReachesAndTheDayItWasShowing() {
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
    let picked = CalendarDate(year: 2026, month: 6, day: 15)!

    let screen = DayScreen(
        startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    screen.showDay(picked)

    let expected = DayView(of: [Roster.Group(category: nil, commitments: [gym, journaling])], oneOffs: OneOffs(), asOf: picked, on: picked, in: History())
    #expect(screen.dayView == expected)
    #expect(screen.dayPickerReach.opensOn == picked)
}

@MainActor
@Test("a day screen shows a day picked after the today it was handed")
func aDayScreenShowsADayPickedAfterTheTodayItWasHanded() {
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let (place, rosterPlace) = freshPlaces()
    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let christmas = CalendarDate(year: 2026, month: 12, day: 25)!
    screen.showDay(christmas)

    #expect(screen.dayPickerReach.opensOn == christmas)

    let lastSupported = CalendarDate(year: 9999, month: 12, day: 31)!
    let (secondPlace, secondRosterPlace) = freshPlaces()
    let second = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: secondPlace,
        keepingRosterAt: secondRosterPlace, keepingOneOffsAt: freshOneOffPlace())
    second.showDay(lastSupported)

    #expect(second.dayPickerReach.opensOn == lastSupported)
}

@MainActor
@Test("a day screen shows the earliest day its day picker reaches when that day is picked")
func aDayScreenShowsTheEarliestDayItsDayPickerReachesWhenThatDayIsPicked() {
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let thursday = CalendarDate(year: 2026, month: 1, day: 1)!

    let (place, rosterPlace) = freshPlaces()
    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.dayPickerReach.earliest == thursday)

    screen.showDay(thursday)

    #expect(screen.dayPickerReach.opensOn == thursday)
    #expect(screen.dayPickerReach.earliest == thursday)
}

@MainActor
@Test("a day screen is left exactly as it was by a day picked earlier than its day picker reaches")
func aDayScreenIsLeftExactlyAsItWasByADayPickedEarlierThanItsDayPickerReaches() {
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let (place, rosterPlace) = freshPlaces()
    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let dayViewBefore = screen.dayView

    screen.showDay(CalendarDate(year: 2025, month: 12, day: 31)!)

    #expect(!screen.offersGoingBackToToday)
    #expect(screen.dayView == dayViewBefore)
    #expect(screen.dayView != DayView(of: [journaling], on: CalendarDate(year: 2026, month: 1, day: 1)!, in: History()))
    #expect(screen.dayPickerReach.opensOn == monday)
    #expect(screen.dayPickerReach.earliest == CalendarDate(year: 2026, month: 1, day: 1))
}

@MainActor
@Test("a day screen picking the day it is already showing changes nothing")
func aDayScreenPickingTheDayItIsAlreadyShowingChangesNothing() throws {
    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let row = screen.dayView.rows[0]
    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(row)
    }
    let dayViewBefore = screen.dayView

    screen.showDay(monday)

    #expect(screen.dayPickerReach.opensOn == monday)
    #expect(!screen.offersGoingBackToToday)
    #expect(screen.notice?.row == row)
    #expect(screen.dayView == dayViewBefore)
}

@MainActor
@Test("a day screen's day picker reaches back past a commitment its roster has removed")
func aDayScreensDayPickerReachesBackPastACommitmentItsRosterHasRemoved() throws {
    let (place, rosterPlace) = freshPlaces()
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(
        name: "Gym", schedule: daily, keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let run = Commitment(
        name: "Run", schedule: daily, keptFrom: CalendarDate(year: 2026, month: 3, day: 1)!)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(run)
    try rosterStore.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.dayPickerReach.earliest == CalendarDate(year: 2026, month: 1, day: 1))
    #expect(screen.dayView.rows.map(\.name) == ["Run"])
}

@MainActor
@Test("a day screen picking a day draws the commitments its roster had not stopped keeping on that day")
func aDayScreenPickingADayDrawsTheCommitmentsItsRosterHadNotStoppedKeepingOnThatDay() throws {
    let (place, rosterPlace) = freshPlaces()
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.retire(gym, keptUntil: CalendarDate(year: 2026, month: 6, day: 15)!)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    screen.showDay(CalendarDate(year: 2026, month: 6, day: 10)!)

    #expect(screen.dayView.rows.map(\.name) == ["Gym", "Journaling"])

    screen.showDay(CalendarDate(year: 2026, month: 6, day: 20)!)

    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
}

@MainActor
@Test("picking a day on a day screen does not read its roster or its record again")
func pickingADayOnADayScreenDoesNotReadItsRosterOrItsRecordAgain() throws {
    let (place, rosterPlace) = freshPlaces()
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let picked = CalendarDate(year: 2026, month: 6, day: 15)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(journaling)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let recordStateBefore = screen.recordState
    let rosterStateBefore = screen.rosterState

    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let otherRoster = try RosterStore(at: rosterPlace)
    try otherRoster.add(gym)
    let otherRecord = try RecordStore(at: place)
    try otherRecord.add(Tick(journaling, on: picked)!)

    screen.showDay(picked)

    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.recordState == recordStateBefore)
    #expect(screen.rosterState == rosterStateBefore)
}

@MainActor
@Test("picking a day on a day screen does not change the today it was handed")
func pickingADayOnADayScreenDoesNotChangeTheTodayItWasHanded() {
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let picked = CalendarDate(year: 2026, month: 6, day: 15)!

    let (place, rosterPlace) = freshPlaces()
    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    screen.showDay(picked)

    #expect(screen.dayPickerReach.opensOn == picked)
    #expect(screen.offersGoingBackToToday)

    screen.showToday()

    #expect(screen.dayPickerReach.opensOn == monday)
    #expect(!screen.offersGoingBackToToday)
}

@MainActor
@Test("a day screen stops telling what it was telling on a row when a picked day changes the day it is showing")
func aDayScreenStopsTellingWhatItWasTellingOnARowWhenAPickedDayChangesTheDayItIsShowing() throws {
    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let row = screen.dayView.rows[0]
    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(row)
    }
    #expect(screen.notice?.row == row)

    let picked = CalendarDate(year: 2026, month: 6, day: 15)!
    screen.showDay(picked)

    #expect(screen.notice == nil)
    #expect(screen.dayPickerReach.opensOn == picked)
}

@MainActor
@Test("a day screen goes on telling what it was telling on a row when a picked day is earlier than its day picker reaches")
func aDayScreenGoesOnTellingWhatItWasTellingOnARowWhenAPickedDayIsEarlierThanItsDayPickerReaches()
    throws
{
    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [gym], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let row = screen.dayView.rows[0]
    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(row)
    }
    #expect(screen.notice?.row == row)

    screen.showDay(CalendarDate(year: 2025, month: 12, day: 31)!)

    #expect(screen.notice?.row == row)
    #expect(screen.dayPickerReach.opensOn == monday)
}

@MainActor
@Test("a day screen offers the way back to today once a day other than that today is picked")
func aDayScreenOffersTheWayBackToTodayOnceADayOtherThanThatTodayIsPicked() {
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let (place, rosterPlace) = freshPlaces()
    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showDay(CalendarDate(year: 2026, month: 6, day: 15)!)

    #expect(screen.offersGoingBackToToday)

    screen.showDay(monday)

    #expect(!screen.offersGoingBackToToday)

    let (secondPlace, secondRosterPlace) = freshPlaces()
    let second = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: secondPlace,
        keepingRosterAt: secondRosterPlace, keepingOneOffsAt: freshOneOffPlace())
    second.showDay(CalendarDate(year: 2025, month: 12, day: 31)!)

    #expect(!second.offersGoingBackToToday)
}

// MARK: - add-adjacent-day-views

@MainActor
@Test("a day screen says the day view of the day before the one it is showing")
func aDayScreenSaysTheDayViewOfTheDayBeforeTheOneItIsShowing() {
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

    let screen = DayScreen(
        startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    let expected = DayView(of: [Roster.Group(category: nil, commitments: [gym, journaling])], oneOffs: OneOffs(), asOf: sunday, on: sunday, in: History())
    #expect(screen.previousDayView == expected)
    #expect(screen.previousDayView?.rows.map(\.name) == ["Journaling"])
}

@MainActor
@Test("a day screen says the day view of the day after the one it is showing")
func aDayScreenSaysTheDayViewOfTheDayAfterTheOneItIsShowing() {
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

    let screen = DayScreen(
        startingFrom: [gym, journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    let expected = DayView(of: [Roster.Group(category: nil, commitments: [gym, journaling])], oneOffs: OneOffs(), asOf: tuesday, on: tuesday, in: History())
    #expect(screen.nextDayView == expected)
    #expect(screen.nextDayView?.rows.map(\.name) == ["Journaling"])
}

@MainActor
@Test("a day screen says the day one calendar day either side and no day further")
func aDayScreenSaysTheDayOneCalendarDayEitherSideAndNoDayFurther() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 3, day: 1)!
    let saturday = CalendarDate(year: 2026, month: 2, day: 28)!
    let monday = CalendarDate(year: 2026, month: 3, day: 2)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: sunday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.previousDayView == DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: saturday, on: saturday, in: History()))
    #expect(screen.nextDayView == DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: monday, on: monday, in: History()))
}

@MainActor
@Test("saying the day either side of a day screen leaves the day it is showing exactly as it was")
func sayingTheDayEitherSideOfADayScreenLeavesTheDayItIsShowingExactlyAsItWas() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let dayViewWhenOpened = screen.dayView

    _ = screen.previousDayView
    _ = screen.nextDayView

    #expect(screen.dayView == dayViewWhenOpened)
    #expect(screen.dayPickerReach.opensOn == monday)
    #expect(!screen.offersGoingBackToToday)
}

@MainActor
@Test("a day screen moved to another day says the day either side of that day")
func aDayScreenMovedToAnotherDaySaysTheDayEitherSideOfThatDay() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showNextDay()

    #expect(screen.previousDayView == DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: monday, on: monday, in: History()))
    #expect(screen.nextDayView == DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: wednesday, on: wednesday, in: History()))
}

@MainActor
@Test("a day screen sent back to today says the day either side of that today")
func aDayScreenSentBackToTodaySaysTheDayEitherSideOfThatToday() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()
    screen.showPreviousDay()
    screen.showPreviousDay()
    screen.showToday()

    #expect(screen.previousDayView == DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: sunday, on: sunday, in: History()))
    #expect(screen.nextDayView == DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: tuesday, on: tuesday, in: History()))
}

@MainActor
@Test("a day screen showing a day picked on its day picker says the day either side of that day")
func aDayScreenShowingADayPickedOnItsDayPickerSaysTheDayEitherSideOfThatDay() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let friday = CalendarDate(year: 2026, month: 9, day: 25)!
    let thursday = CalendarDate(year: 2026, month: 9, day: 24)!
    let saturday = CalendarDate(year: 2026, month: 9, day: 26)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showDay(friday)

    #expect(screen.previousDayView == DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: thursday, on: thursday, in: History()))
    #expect(screen.nextDayView == DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: saturday, on: saturday, in: History()))
}

@MainActor
@Test("a day screen shown again on a new day says the day either side of that day")
func aDayScreenShownAgainOnANewDaySaysTheDayEitherSideOfThatDay() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!
    let thursday = CalendarDate(year: 2026, month: 9, day: 3)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.shown(asOf: wednesday)

    #expect(screen.previousDayView == DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: tuesday, on: tuesday, in: History()))
    #expect(screen.nextDayView == DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: thursday, on: thursday, in: History()))
}

@MainActor
@Test("a day screen says a day either side drawn from the commitments its roster had not stopped keeping on that day")
func aDayScreenSaysADayEitherSideDrawnFromTheCommitmentsItsRosterHadNotStoppedKeepingOnThatDay() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(journaling)
    try rosterStore.retire(journaling, keptUntil: sunday)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.dayView.rows.isEmpty)
    #expect(screen.previousDayView?.rows.map(\.name) == ["Journaling"])
    #expect(screen.nextDayView?.rows.isEmpty == true)
}

@MainActor
@Test("a day screen says a day either side drawn from the record it already holds")
func aDayScreenSaysADayEitherSideDrawnFromTheRecordItAlreadyHolds() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let store = try RecordStore(at: place)
    try store.add(Tick(journaling, on: tuesday)!)

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.nextDayView?.rows.first?.isKept == true)
    #expect(screen.previousDayView?.rows.first?.isKept == false)
    #expect(!screen.dayView.rows[0].isKept)
}

@MainActor
@Test("saying the day either side of a day screen does not read its record or its roster again")
func sayingTheDayEitherSideOfADayScreenDoesNotReadItsRecordOrItsRosterAgain() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(journaling)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    let gym = Commitment(
        name: "Gym", schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let otherRoster = try RosterStore(at: rosterPlace)
    try otherRoster.add(gym)

    let otherRecord = try RecordStore(at: place)
    try otherRecord.add(Tick(journaling, on: sunday)!)

    #expect(screen.previousDayView?.rows.map(\.name) == ["Journaling"])
    #expect(!(screen.previousDayView?.rows.first?.isKept ?? true))
    #expect(screen.nextDayView?.rows.map(\.name) == ["Journaling"])
    #expect(screen.rosterState == .kept)
    #expect(screen.recordState == .kept)
}

@MainActor
@Test("saying the day either side of a day screen keeps nothing at either place")
func sayingTheDayEitherSideOfADayScreenKeepsNothingAtEitherPlace() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let bytesAfterOpen = try Data(contentsOf: rosterPlace)

    _ = screen.previousDayView
    _ = screen.nextDayView

    #expect(!FileManager.default.fileExists(atPath: place.path))
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpen)
}

@MainActor
@Test("a tick made on the day a day screen is showing leaves the day either side of it as it was")
func aTickMadeOnTheDayADayScreenIsShowingLeavesTheDayEitherSideOfItAsItWas() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    _ = screen.previousDayView
    _ = screen.nextDayView

    try screen.tick(screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].isKept)
    #expect(screen.previousDayView == DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: sunday, on: sunday, in: History()))
    #expect(screen.nextDayView == DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: tuesday, on: tuesday, in: History()))
}

@MainActor
@Test("a day screen that cannot read its record says the day either side of it with nothing kept")
func aDayScreenThatCannotReadItsRecordSaysTheDayEitherSideOfItWithNothingKept() throws {
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
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.previousDayView == DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: sunday, on: sunday, in: History()))
    #expect(screen.nextDayView == DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: tuesday, on: tuesday, in: History()))
    #expect(screen.recordState == .unreadable)
}

@MainActor
@Test("a day screen that cannot read its roster says the day either side of it and neither holds rows")
func aDayScreenThatCannotReadItsRosterSaysTheDayEitherSideOfItAndNeitherHoldsRows() throws {
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a roster is written as".utf8).write(to: rosterPlace)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.previousDayView?.rows.isEmpty == true)
    #expect(screen.nextDayView?.rows.isEmpty == true)
    #expect(screen.rosterState == .notKept)
}

@MainActor
@Test("a day screen goes on telling what it was telling on a row when it is asked the day either side of it")
func aDayScreenGoesOnTellingWhatItWasTellingOnARowWhenItIsAskedTheDayEitherSideOfIt() throws {
    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let row = screen.dayView.rows[0]
    let dayViewWhenOpened = screen.dayView

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try screen.tick(row)
    }
    #expect(screen.notice?.row == row)

    _ = screen.previousDayView
    _ = screen.nextDayView

    #expect(screen.notice?.row == row)
    #expect(screen.dayView == dayViewWhenOpened)
}

@MainActor
@Test("a day screen returned to says the day either side of it from the roster it then holds")
func aDayScreenReturnedToSaysTheDayEitherSideOfItFromTheRosterItThenHolds() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(journaling)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    let other = try RosterStore(at: rosterPlace)
    try other.add(gym)

    screen.returnedTo()

    #expect(screen.previousDayView?.rows.map(\.name) == ["Journaling", "Gym"])
    #expect(screen.nextDayView?.rows.map(\.name) == ["Journaling", "Gym"])
}

@MainActor
@Test("a day screen showing the first supported date says no day view before it and says the day after")
func aDayScreenShowingTheFirstSupportedDateSaysNoDayViewBeforeItAndSaysTheDayAfter() {
    let (place, rosterPlace) = freshPlaces()
    let firstSupported = CalendarDate(year: 1583, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: firstSupported)!
    let dayAfter = CalendarDate(year: 1583, month: 1, day: 2)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: firstSupported, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.previousDayView == nil)
    #expect(screen.nextDayView == DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: dayAfter, on: dayAfter, in: History()))
}

@MainActor
@Test("a day screen showing the last supported date says no day view after it and says the day before")
func aDayScreenShowingTheLastSupportedDateSaysNoDayViewAfterItAndSaysTheDayBefore() {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 1583, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let lastSupported = CalendarDate(year: 9999, month: 12, day: 31)!
    let dayBefore = CalendarDate(year: 9999, month: 12, day: 30)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: lastSupported, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.nextDayView == nil)
    #expect(screen.previousDayView == DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: dayBefore, on: dayBefore, in: History()))
}

@MainActor
@Test("a day screen moved off an end of the calendar says a day view either side of it")
func aDayScreenMovedOffAnEndOfTheCalendarSaysADayViewEitherSideOfIt() {
    let (place, rosterPlace) = freshPlaces()
    let firstSupported = CalendarDate(year: 1583, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: firstSupported)!
    let thirdOfJanuary = CalendarDate(year: 1583, month: 1, day: 3)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: firstSupported, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showNextDay()

    #expect(screen.previousDayView == DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: firstSupported, on: firstSupported, in: History()))
    #expect(screen.nextDayView == DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: thirdOfJanuary, on: thirdOfJanuary, in: History()))
}

@MainActor
@Test("a day screen showing the first supported date says no day view before it whatever its places, its rows and its today")
func aDayScreenShowingTheFirstSupportedDateSaysNoDayViewBeforeItWhateverItsPlacesItsRowsAndItsToday()
    throws
{
    let (place, rosterPlace) = freshPlaces()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a record is written as".utf8).write(to: place)
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a roster is written as".utf8).write(to: rosterPlace)

    let firstSupported = CalendarDate(year: 1583, month: 1, day: 1)!
    let secondOfJanuary = CalendarDate(year: 1583, month: 1, day: 2)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: firstSupported)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: secondOfJanuary, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    screen.showPreviousDay()

    #expect(screen.dayView.rows.isEmpty)
    #expect(screen.previousDayView == nil)
    #expect(screen.nextDayView == DayView(of: [Roster.Group(category: nil, commitments: [Commitment]())], oneOffs: OneOffs(), asOf: secondOfJanuary, on: secondOfJanuary, in: History()))

    screen.showNextDay()

    #expect(screen.previousDayView != nil)
    #expect(screen.nextDayView != nil)
}

@MainActor
@Test("ticking a row a day screen says of the day before changes nothing")
func tickingARowADayScreenSaysOfTheDayBeforeChangesNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let dayViewWhenOpened = screen.dayView
    let bytesWhenOpened = try? Data(contentsOf: place)

    try screen.tick(screen.previousDayView!.rows[0])

    #expect(!(screen.previousDayView?.rows.first?.isKept ?? true))
    #expect(screen.previousDayView == DayView(of: [Roster.Group(category: nil, commitments: [journaling])], oneOffs: OneOffs(), asOf: sunday, on: sunday, in: History()))
    #expect(screen.dayView == dayViewWhenOpened)
    #expect((try? Data(contentsOf: place)) == bytesWhenOpened)
}

@MainActor
@Test("entering a number on a row a day screen says of the day after changes nothing")
func enteringANumberOnARowADayScreenSaysOfTheDayAfterChangesNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [weight], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let dayViewWhenOpened = screen.dayView
    let bytesWhenOpened = try? Data(contentsOf: place)

    try screen.enter("72", on: screen.nextDayView!.rows[0])

    #expect(screen.nextDayView?.rows.first?.numberEntry(asOf: monday)?.number == nil)
    #expect(screen.dayView == dayViewWhenOpened)
    #expect((try? Data(contentsOf: place)) == bytesWhenOpened)
}

@MainActor
@Test("taking back the last addition on a row a day screen says of the day before changes nothing")
func takingBackTheLastAdditionOnARowADayScreenSaysOfTheDayBeforeChangesNothing() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, kind: .total(target: Commitment.Target(120)!))!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [protein], asOf: sunday, keepingRecordAt: place, keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    try screen.enter("30", on: screen.dayView.rows[0])
    screen.showNextDay()
    let bytesBeforeTakeBack = try Data(contentsOf: place)

    try screen.takeBackLast(on: screen.previousDayView!.rows[0])

    #expect(screen.previousDayView?.rows.first?.totalEntry(asOf: monday)?.soFarOfTarget == "30 of 120")
    #expect(try Data(contentsOf: place) == bytesBeforeTakeBack)
}

@MainActor
@Test("a day screen tells nothing on a row of a day either side of the one it is showing")
func aDayScreenTellsNothingOnARowOfADayEitherSideOfTheOneItIsShowing() throws {
    let (place, rosterPlace) = try blockerPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    try screen.tick(screen.previousDayView!.rows[0])

    #expect(screen.notice == nil)
}

@MainActor
@Test(
    "every change asked of a row a day screen says of the day before changes nothing and leaves what it is telling"
)
func everyChangeAskedOfARowADayScreenSaysOfTheDayBeforeChangesNothingAndLeavesWhatItIsTelling()
    throws
{
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom, kind: .tick)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: daily, keptFrom: keptFrom, kind: .number(range: range))!
    let journal = Commitment(name: "Journal", schedule: daily, keptFrom: keptFrom, kind: .note)!
    let protein = Commitment(
        name: "Protein", schedule: daily, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let setup = try RecordStore(at: place)
    try setup.add(Tick(gym, on: sunday)!)
    try setup.add(Number(70.5, for: weight, on: sunday)!)
    try setup.add(Note("Ran 8k.", for: journal, on: sunday)!)
    try setup.add(Addition(30, for: protein, on: sunday)!)

    let screen = DayScreen(
        startingFrom: [gym, weight, journal, protein], asOf: monday, keepingRecordAt: place,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    let bytesAfterOpen = try Data(contentsOf: place)

    try screen.enter("300", on: screen.dayView.rows[1])

    #expect(screen.notice?.row == screen.dayView.rows[1])
    #expect(screen.notice?.cause == "Must be between 40 and 150")

    let dayViewBeforeNeighbourChanges = screen.dayView
    let dayBefore = screen.previousDayView!
    let gymRowBefore = dayBefore.rows[0]
    let weightRowBefore = dayBefore.rows[1]
    let journalRowBefore = dayBefore.rows[2]
    let proteinRowBefore = dayBefore.rows[3]

    try screen.tick(gymRowBefore)
    try screen.enter("", on: weightRowBefore)
    try screen.enter("1.2.3", on: weightRowBefore)
    try screen.enter("Rested.", on: journalRowBefore)
    try screen.enter("", on: journalRowBefore)
    try screen.enter("30", on: proteinRowBefore)
    try screen.enter("0", on: proteinRowBefore)

    #expect(screen.previousDayView == dayBefore)
    #expect(screen.dayView == dayViewBeforeNeighbourChanges)
    #expect(try Data(contentsOf: place) == bytesAfterOpen)
    #expect(screen.notice?.row == screen.dayView.rows[1])
    #expect(screen.notice?.cause == "Must be between 40 and 150")
}

@MainActor
@Test("a restart torn between its two places is undone when a day screen is opened")
func aRestartTornBetweenItsTwoPlacesIsUndoneWhenADayScreenIsOpened() throws {
    let (place, rosterPlace) = freshPlaces()
    let august1st = CalendarDate(year: 2026, month: 8, day: 1)!
    let august2nd = CalendarDate(year: 2026, month: 8, day: 2)!
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let august10th = CalendarDate(year: 2026, month: 8, day: 10)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august1st)!
    let restartedNails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august2nd),
        keptFrom: august2nd)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(nails)
    let recordStore = try RecordStore(at: place)
    try recordStore.add(Tick(restartedNails, on: august6th)!)
    try recordStore.add(Tick(restartedNails, on: august10th)!)
    try SaveInProgress(carriedFrom: nails, to: restartedNails).keep(
        at: SaveInProgress.place(besideRecordAt: place))

    let screen = DayScreen(
        startingFrom: [], asOf: august10th, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.dayView.rows.map(\.name) == ["Nails"])
    #expect(screen.dayView.rows[0].isKept)

    let laterRecordStore = try RecordStore(at: place)
    #expect(laterRecordStore.history.isKept(nails, on: august6th))
    #expect(laterRecordStore.history.isKept(nails, on: august10th))
    #expect(!laterRecordStore.history.isKept(restartedNails, on: august6th))
    #expect(!laterRecordStore.history.isKept(restartedNails, on: august10th))
    #expect(
        !FileManager.default.fileExists(atPath: SaveInProgress.place(besideRecordAt: place).path))
}

@MainActor
@Test("a torn save is undone when a day screen is returned to")
func aTornSaveIsUndoneWhenADayScreenIsReturnedTo() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: freshOneOffPlace())

    let otherRecordStore = try RecordStore(at: place)
    try otherRecordStore.add(Tick(gymEmoji, on: monday)!)
    try SaveInProgress(carriedFrom: gym, to: gymEmoji).keep(
        at: SaveInProgress.place(besideRecordAt: place))

    screen.returnedTo()

    #expect(screen.dayView.rows.map(\.name) == ["Gym"])
    #expect(screen.dayView.rows[0].isKept)

    let laterRecordStore = try RecordStore(at: place)
    #expect(!laterRecordStore.history.isKept(gymEmoji, on: monday))
    #expect(
        !FileManager.default.fileExists(atPath: SaveInProgress.place(besideRecordAt: place).path))
}

@MainActor
@Test("a day screen opened on a torn save it cannot undo draws its rows and keeps no tick")
func aDayScreenOpenedOnATornSaveItCannotUndoDrawsItsRowsAndKeepsNoTick() throws {
    let (place, rosterPlace) = freshPlaces()
    let directory = place.deletingLastPathComponent()
    defer { try? makeWritable(directory) }
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: place)
    try recordStore.add(Tick(gymEmoji, on: monday)!)
    try SaveInProgress(carriedFrom: gym, to: gymEmoji).keep(
        at: SaveInProgress.place(besideRecordAt: place))

    let recordBytes = try Data(contentsOf: place)
    let saveInProgressBytes = try Data(contentsOf: SaveInProgress.place(besideRecordAt: place))

    try makeReadOnly(directory)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: freshOneOffPlace())
    try screen.tick(screen.dayView.rows[0])

    #expect(screen.dayView.rows.map(\.name) == ["Gym"])
    #expect(!screen.dayView.rows[0].isKept)
    #expect(screen.recordState == .unreadable)
    #expect(screen.recordState != .writtenByALaterVersion)
    #expect(try Data(contentsOf: place) == recordBytes)
    #expect(
        try Data(contentsOf: SaveInProgress.place(besideRecordAt: place)) == saveInProgressBytes)
}

/// A torn save that cannot be undone keeps nothing from the record place — including the roster
/// place taking on day one, which `openRoster(at:takingOnIfEmpty:)` can write. Before this fix
/// that write ran before the undo was even checked, so an empty roster place gained day one
/// while the torn save beside an unwritable record place stood. The roster and record here sit
/// in separate directories, unlike `freshPlaces()`, so only the record's directory is made
/// read-only and a write to the roster place would succeed if one were attempted.
@MainActor
@Test(
    "a day screen does not write day one to the roster place while a torn save it cannot undo stands"
)
func aDayScreenDoesNotWriteDayOneToTheRosterPlaceWhileATornSaveItCannotUndoStands() throws {
    let rosterDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let rosterPlace = rosterDirectory.appendingPathComponent("roster.json")
    let recordDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let recordPlace = recordDirectory.appendingPathComponent("record.json")
    try FileManager.default.createDirectory(at: rosterDirectory, withIntermediateDirectories: true)
    defer { try? makeWritable(recordDirectory) }

    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: schedule, keptFrom: keptFrom)!

    let recordStore = try RecordStore(at: recordPlace)
    try recordStore.add(Tick(gymEmoji, on: monday)!)
    try SaveInProgress(carriedFrom: gym, to: gymEmoji).keep(
        at: SaveInProgress.place(besideRecordAt: recordPlace))

    try makeReadOnly(recordDirectory)

    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))

    let screen = DayScreen(
        startingFrom: [gym], asOf: monday, keepingRecordAt: recordPlace,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())

    #expect(screen.recordState == .unreadable)
    #expect(
        FileManager.default.fileExists(
            atPath: SaveInProgress.place(besideRecordAt: recordPlace).path))
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

/// The same requirement as the test above, reached the other way `readRecordAndRoster` is not
/// shared into: `returnedTo()` inlines its own version rather than calling that function, and
/// before this fix wrote day one to the roster place before ever checking the torn save at all —
/// unconditionally, on every call where this screen is keeping a record, not merely when one
/// stands. The screen is opened clean first, with day one already taken on once by `init`, so
/// `returnedTo()` — not `init` — is the call under test; the roster place is then emptied again
/// and a fresh torn save is planted directly, beside an unwritable record directory, so the undo
/// `returnedTo()` runs cannot complete. Reproducing "the roster place is empty" therefore takes
/// deleting what `init` had already written there, not merely never writing it — day one is
/// `screen`'s own `commitments`, handed again on every call that takes it on, so starting from an
/// empty `dayOne` would give `returnedTo()` nothing to write either way and prove nothing.
@MainActor
@Test(
    "a day screen does not write day one to the roster place while a torn save it cannot undo stands, returned to"
)
func aDayScreenDoesNotWriteDayOneToTheRosterPlaceWhileATornSaveItCannotUndoStandsReturnedTo() throws {
    let rosterDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let rosterPlace = rosterDirectory.appendingPathComponent("roster.json")
    let recordDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let recordPlace = recordDirectory.appendingPathComponent("record.json")
    defer { try? makeWritable(recordDirectory) }

    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: schedule, keptFrom: keptFrom)!

    let screen = DayScreen(
        startingFrom: [gym], asOf: monday, keepingRecordAt: recordPlace,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: freshOneOffPlace())
    #expect(screen.recordState == .kept)
    #expect(FileManager.default.fileExists(atPath: rosterPlace.path))

    try FileManager.default.removeItem(at: rosterPlace)

    let otherRecordStore = try RecordStore(at: recordPlace)
    try otherRecordStore.add(Tick(gymEmoji, on: monday)!)
    try SaveInProgress(carriedFrom: gym, to: gymEmoji).keep(
        at: SaveInProgress.place(besideRecordAt: recordPlace))

    try makeReadOnly(recordDirectory)

    screen.returnedTo()

    #expect(screen.recordState == .unreadable)
    #expect(
        FileManager.default.fileExists(
            atPath: SaveInProgress.place(besideRecordAt: recordPlace).path))
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a torn save a day screen could not undo is undone once it is shown again and its places can be written")
func aTornSaveADayScreenCouldNotUndoIsUndoneOnceItIsShownAgainAndItsPlacesCanBeWritten() throws {
    let (place, rosterPlace) = freshPlaces()
    let directory = place.deletingLastPathComponent()
    defer { try? makeWritable(directory) }
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: place)
    try recordStore.add(Tick(gymEmoji, on: monday)!)
    try SaveInProgress(carriedFrom: gym, to: gymEmoji).keep(
        at: SaveInProgress.place(besideRecordAt: place))

    try makeReadOnly(directory)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: freshOneOffPlace())

    try makeWritable(directory)

    screen.shown(asOf: monday)

    #expect(screen.recordState == .kept)
    #expect(screen.dayView.rows.map(\.name) == ["Gym"])
    #expect(screen.dayView.rows[0].isKept)
    #expect(
        !FileManager.default.fileExists(atPath: SaveInProgress.place(besideRecordAt: place).path))
}

@MainActor
@Test(
    "an orphaned record is carried back to a removed commitment beside the records it already holds when a day screen is opened"
)
func anOrphanedRecordIsCarriedBackToARemovedCommitmentBesideTheRecordsItAlreadyHoldsWhenADayScreenIsOpened()
    throws
{
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: schedule, keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.remove(gym, keptUntil: august30th)
    let recordStore = try RecordStore(at: place)
    try recordStore.add(Tick(gym, on: august3rd)!)
    try recordStore.add(Tick(gymEmoji, on: august4th)!)

    _ = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: freshOneOffPlace())

    let laterRecordStore = try RecordStore(at: place)
    #expect(laterRecordStore.history.isKept(gym, on: august3rd))
    #expect(laterRecordStore.history.isKept(gym, on: august4th))
    #expect(!laterRecordStore.history.isKept(gymEmoji, on: august3rd))
    #expect(!laterRecordStore.history.isKept(gymEmoji, on: august4th))
}

@MainActor
@Test("a torn save is undone when a day screen is shown again")
func aTornSaveIsUndoneWhenADayScreenIsShownAgain() throws {
    let (place, rosterPlace) = freshPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: place, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: freshOneOffPlace())

    let otherRecordStore = try RecordStore(at: place)
    try otherRecordStore.add(Tick(gymEmoji, on: monday)!)
    try SaveInProgress(carriedFrom: gym, to: gymEmoji).keep(
        at: SaveInProgress.place(besideRecordAt: place))

    screen.shown(asOf: monday)

    #expect(screen.dayView.rows.map(\.name) == ["Gym"])
    #expect(screen.dayView.rows[0].isKept)
    #expect(
        !FileManager.default.fileExists(atPath: SaveInProgress.place(besideRecordAt: place).path))
}
