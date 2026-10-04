import Foundation
import Testing

@testable import DayByDayKit

private let monday = CalendarDate(year: 2026, month: 8, day: 31)!

/// A fresh directory of its own, not created until something writes into it.
private func freshDirectory() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
}

/// A fresh happening place under a directory of its own.
private func freshHappeningPlace() -> URL {
    freshDirectory().appendingPathComponent("happenings.json")
}

/// A fresh roster place and record place, one directory, as `DayScreenTests` does.
private func freshRosterAndRecordPlaces() -> (roster: URL, record: URL) {
    let directory = freshDirectory()
    return (
        directory.appendingPathComponent("roster.json"),
        directory.appendingPathComponent("record.json")
    )
}

/// A happening place whose directory is an ordinary file, so nothing can be written there.
private func blockedHappeningPlace() throws -> URL {
    let directory = freshDirectory()
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    return blocker.appendingPathComponent("happenings.json")
}

private let allWeekdays: Schedule = .weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])

@MainActor
@Test(
    "the happening place is a file of the app's own under Application Support, the same every time"
)
func theHappeningPlaceIsAFileOfTheAppsOwnUnderApplicationSupportTheSameEveryTime() {
    let first = DayScreen.happeningPlace
    let second = DayScreen.happeningPlace
    #expect(first == second)

    let applicationSupport = FileManager.default.urls(
        for: .applicationSupportDirectory, in: .userDomainMask)[0]
    #expect(first.path.hasPrefix(applicationSupport.path))
    let containingDirectory = first.deletingLastPathComponent()
    #expect(containingDirectory != applicationSupport)
    #expect(containingDirectory.path.hasPrefix(applicationSupport.path))

    let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    #expect(!first.path.hasPrefix(caches.path))
    #expect(!first.path.hasPrefix(FileManager.default.temporaryDirectory.path))

    let places: Set<URL> = [
        DayScreen.happeningPlace, DayScreen.recordPlace, DayScreen.rosterPlace,
        DayScreen.oneOffPlace, DayScreen.birthdayPlace,
    ]
    #expect(places.count == 5)
}

@MainActor
@Test("a commitments screen given no happening place keeps its happenings beside its record place")
func aCommitmentsScreenGivenNoHappeningPlaceKeepsItsHappeningsBesideItsRecordPlace() throws {
    let places = freshRosterAndRecordPlaces()
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.makeHappening(named: "Kopfweh")

    #expect(refusal == nil)
    let beside = places.record.deletingLastPathComponent()
        .appendingPathComponent("happenings.json")
    #expect(try HappeningStore(at: beside).happenings.all.map(\.name) == ["Kopfweh"])
}

@MainActor
@Test(
    "a commitments screen lists the happenings at its happening place in the order they were made")
func aCommitmentsScreenListsTheHappeningsAtItsHappeningPlaceInTheOrderTheyWereMade() throws {
    let place = freshHappeningPlace()
    let store = try HappeningStore(at: place)
    try store.add(try #require(Happening(name: "Augenmigräne")))
    try store.add(try #require(Happening(name: "Kopfweh")))
    let places = freshRosterAndRecordPlaces()

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: place)

    #expect(screen.happenings.map(\.name) == ["Augenmigräne", "Kopfweh"])
    #expect(screen.happeningState == .kept)

    let empty = freshHappeningPlace()
    let other = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: empty)
    #expect(other.happenings.isEmpty)
    #expect(other.happeningState == .kept)
    #expect(!FileManager.default.fileExists(atPath: empty.path))
}

@MainActor
@Test("a happening made through a commitments screen is listed last and kept at its place")
func aHappeningMadeThroughACommitmentsScreenIsListedLastAndKeptAtItsPlace() throws {
    let place = freshHappeningPlace()
    try HappeningStore(at: place).add(try #require(Happening(name: "Augenmigräne")))
    let places = freshRosterAndRecordPlaces()
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: place)

    let refusal = screen.makeHappening(named: " Kopfweh ")

    #expect(refusal == nil)
    #expect(screen.happenings.map(\.name) == ["Augenmigräne", "Kopfweh"])
    let reopened = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: place)
    #expect(reopened.happenings.map(\.name) == ["Augenmigräne", "Kopfweh"])
}

@MainActor
@Test("a commitments screen refuses a happening whose name a listed one has, naming the listed one")
func aCommitmentsScreenRefusesAHappeningWhoseNameAListedOneHasNamingTheListedOne() throws {
    let place = freshHappeningPlace()
    try HappeningStore(at: place).add(try #require(Happening(name: "Kopfweh")))
    let places = freshRosterAndRecordPlaces()
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: place)
    let kept = try Data(contentsOf: place)

    let refusal = screen.makeHappening(named: "kopfweh")

    #expect(refusal == .nameAlreadyInUse("Kopfweh"))
    #expect(screen.happeningRefusal == .nameAlreadyInUse("Kopfweh"))
    #expect(screen.happenings.map(\.name) == ["Kopfweh"])
    #expect(try Data(contentsOf: place) == kept)
    #expect(screen.makeHappening(named: "   ") == .namesNothing)
}

@MainActor
@Test("a happening the happening place cannot take is refused as not kept")
func aHappeningTheHappeningPlaceCannotTakeIsRefusedAsNotKept() throws {
    let places = freshRosterAndRecordPlaces()
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: try blockedHappeningPlace())

    let refusal = screen.makeHappening(named: "Kopfweh")

    #expect(refusal == .notKept)
    #expect(screen.happenings.isEmpty)
}

/// A clock that answers a later minute each time it is asked, starting from `first`.
@MainActor
private func laterMinuteEachTime(from first: Moment) -> @Sendable () -> Moment? {
    final class Counter: @unchecked Sendable {
        var minutesAsked = 0
    }
    let counter = Counter()
    return {
        let moment = Moment(
            on: first.day, hour: first.hour, minute: first.minute + counter.minutesAsked)!
        counter.minutesAsked += 1
        return moment
    }
}

@MainActor
@Test("making and renaming a happening leaves the other places as they were")
func makingAndRenamingAHappeningLeavesTheOtherPlacesAsTheyWere() throws {
    let directory = freshDirectory()
    let rosterPlace = directory.appendingPathComponent("roster.json")
    let recordPlace = directory.appendingPathComponent("record.json")
    let oneOffPlace = directory.appendingPathComponent("one-offs.json")
    let birthdayPlace = directory.appendingPathComponent("birthday-ticks.json")
    let happeningPlace = directory.appendingPathComponent("happenings.json")
    let gym = try #require(
        Commitment(
            name: "Gym", schedule: allWeekdays, keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!
        ))
    try RosterStore(at: rosterPlace).add(gym)

    let copyPlace = CopyPlace(
        at: freshDirectory().appendingPathComponent("copy-place.json"),
        keepingRecordAt: recordPlace, keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace,
        keepingBirthdayTicksAt: birthdayPlace,
        asking: laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!))
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace,
        keepingOneOffsAt: oneOffPlace, keepingBirthdayTicksAt: birthdayPlace,
        keepingHappeningsAt: happeningPlace, copyingTo: copyPlace)
    screen.givenAsCopyPlace(freshDirectory())
    let rosterBytes = try Data(contentsOf: rosterPlace)

    let made = screen.makeHappening(named: "Kopfweh")
    let kopfweh = try #require(screen.happenings.first)
    let renamed = screen.rename(kopfweh, to: "Spannungskopfweh")

    #expect(made == nil)
    #expect(renamed == nil)
    #expect(screen.happenings.map(\.name) == ["Spannungskopfweh"])
    #expect(try Data(contentsOf: rosterPlace) == rosterBytes)
    #expect(!FileManager.default.fileExists(atPath: recordPlace.path))
    #expect(!FileManager.default.fileExists(atPath: oneOffPlace.path))
    #expect(!FileManager.default.fileExists(atPath: birthdayPlace.path))
}

@MainActor
@Test("a happening renamed through a commitments screen keeps its place in the list")
func aHappeningRenamedThroughACommitmentsScreenKeepsItsPlaceInTheList() throws {
    let place = freshHappeningPlace()
    let store = try HappeningStore(at: place)
    try store.add(try #require(Happening(name: "Augenmigräne")))
    let kopfweh = try #require(Happening(name: "Kopfweh"))
    try store.add(kopfweh)
    let places = freshRosterAndRecordPlaces()
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: place)

    let refusal = screen.rename(kopfweh, to: "Spannungskopfweh")

    #expect(refusal == nil)
    #expect(screen.happenings.map(\.name) == ["Augenmigräne", "Spannungskopfweh"])
    #expect(screen.happenings[1] == kopfweh)
    let reopened = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: place)
    #expect(reopened.happenings.map(\.name) == ["Augenmigräne", "Spannungskopfweh"])
}

@MainActor
@Test(
    "a commitments screen refuses a rename onto a name another listed happening has, naming that one"
)
func aCommitmentsScreenRefusesARenameOntoANameAnotherListedHappeningHasNamingThatOne() throws {
    let place = freshHappeningPlace()
    let store = try HappeningStore(at: place)
    try store.add(try #require(Happening(name: "Augenmigräne")))
    let kopfweh = try #require(Happening(name: "Kopfweh"))
    try store.add(kopfweh)
    let places = freshRosterAndRecordPlaces()
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: place)
    let kept = try Data(contentsOf: place)

    let onto = screen.rename(kopfweh, to: "AUGENMIGRÄNE")

    #expect(onto == .nameAlreadyInUse("Augenmigräne"))
    #expect(screen.happeningRefusal == .nameAlreadyInUse("Augenmigräne"))
    #expect(try Data(contentsOf: place) == kept)
    #expect(screen.rename(kopfweh, to: "") == .namesNothing)
    #expect(screen.rename(kopfweh, to: "kopfweh") == nil)
    #expect(screen.happenings.map(\.name) == ["Augenmigräne", "kopfweh"])
}

@MainActor
@Test("a rename to the name a happening already has, or of one not listed, asks for no change")
func aRenameToTheNameAHappeningAlreadyHasOrOfOneNotListedAsksForNoChange() throws {
    let place = freshHappeningPlace()
    let kopfweh = try #require(Happening(name: "Kopfweh"))
    try HappeningStore(at: place).add(kopfweh)
    let places = freshRosterAndRecordPlaces()
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: place)
    let kept = try Data(contentsOf: place)

    #expect(screen.makeHappening(named: "") == .namesNothing)
    let same = screen.rename(kopfweh, to: " Kopfweh ")

    #expect(same == nil)
    #expect(try Data(contentsOf: place) == kept)
    #expect(screen.happeningRefusal == .namesNothing)

    let unlisted = try #require(Happening(name: "Schlecht geschlafen"))
    let notListed = screen.rename(unlisted, to: "Migräne")
    #expect(notListed == nil)
    #expect(try Data(contentsOf: place) == kept)
    #expect(screen.happeningRefusal == .namesNothing)
    #expect(screen.happenings.map(\.name) == ["Kopfweh"])
}

@MainActor
@Test(
    "what a commitments screen tells about a happening ends when its name is edited, the sheet closes or the app is shown"
)
func whatACommitmentsScreenTellsAboutAHappeningEndsWhenItsNameIsEditedTheSheetClosesOrTheAppIsShown()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: freshHappeningPlace())

    screen.makeHappening(named: "")
    #expect(screen.happeningRefusal == .namesNothing)
    screen.happeningNameEdited()
    #expect(screen.happeningRefusal == nil)

    screen.makeHappening(named: "")
    screen.happeningSheetClosed()
    #expect(screen.happeningRefusal == nil)

    screen.makeHappening(named: "")
    screen.shown(asOf: monday)
    #expect(screen.happeningRefusal == nil)

    screen.makeHappening(named: "")
    screen.makeHappening(named: "Kopfweh")
    #expect(screen.happeningRefusal == nil)
}

@MainActor
@Test("what a commitments screen tells about a happening is held apart from a commitment's refusal")
func whatACommitmentsScreenTellsAboutAHappeningIsHeldApartFromACommitmentsRefusal() throws {
    let places = freshRosterAndRecordPlaces()
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: freshHappeningPlace())
    let everyDay: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let blank = screen.define(name: "   ", on: everyDay, keptFrom: monday, under: nil)
    #expect(blank == .namesNothing)

    let made = screen.makeHappening(named: "Kopfweh")

    #expect(made == nil)
    #expect(screen.refusedChange == .defining(.namesNothing))
    #expect(screen.sheetRefusal == .init(field: .name, refusal: .namesNothing))

    screen.makeHappening(named: "")
    let gym = screen.define(name: "Gym", on: everyDay, keptFrom: monday, under: nil)

    #expect(gym == nil)
    #expect(screen.happeningRefusal == .namesNothing)
}

/// Writes `bytes` at `place`, creating its directory.
private func write(_ bytes: Data, at place: URL) throws {
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try bytes.write(to: place)
}

@MainActor
@Test(
    "a commitments screen that cannot read its happening place lists none and leaves the place as it was"
)
func aCommitmentsScreenThatCannotReadItsHappeningPlaceListsNoneAndLeavesThePlaceAsItWas() throws {
    let places = freshRosterAndRecordPlaces()
    let gym = try #require(
        Commitment(
            name: "Gym", schedule: allWeekdays, keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!
        ))
    try RosterStore(at: places.roster).add(gym)
    let happeningPlace = freshHappeningPlace()
    let bytes = Data("not a happening store".utf8)
    try write(bytes, at: happeningPlace)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: happeningPlace)
    let made = screen.makeHappening(named: "Kopfweh")

    #expect(screen.happenings.isEmpty)
    #expect(screen.happeningState == .notKept)
    #expect(made == .notKept)
    #expect(screen.makeHappening(named: "  ") == .notKept)
    #expect(try Data(contentsOf: happeningPlace) == bytes)
    #expect(screen.kept.map(\.name) == ["Gym"])
    let run = screen.define(
        name: "Run", on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
        keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!, under: nil)
    #expect(run == nil)
}

@MainActor
@Test("a happening place written by a later version makes a commitments screen that says so")
func aHappeningPlaceWrittenByALaterVersionMakesACommitmentsScreenThatSaysSo() throws {
    let places = freshRosterAndRecordPlaces()
    let happeningPlace = freshHappeningPlace()
    let bytes = Data(#"{"version": \#(HappeningDocument.currentVersion + 1), "happenings": []}"#.utf8)
    try write(bytes, at: happeningPlace)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: happeningPlace)

    #expect(screen.happenings.isEmpty)
    #expect(screen.happeningState == .writtenByALaterVersion)
    #expect(try Data(contentsOf: happeningPlace) == bytes)
}

@MainActor
@Test(
    "a commitments screen that could not read its happening place reads it again when the app is shown"
)
func aCommitmentsScreenThatCouldNotReadItsHappeningPlaceReadsItAgainWhenTheAppIsShown() throws {
    let places = freshRosterAndRecordPlaces()
    let happeningPlace = freshHappeningPlace()
    try write(Data("not a happening store".utf8), at: happeningPlace)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: happeningPlace)

    try FileManager.default.removeItem(at: happeningPlace)
    try HappeningStore(at: happeningPlace).add(try #require(Happening(name: "Kopfweh")))
    screen.shown(asOf: monday)

    #expect(screen.happenings.map(\.name) == ["Kopfweh"])
    #expect(screen.happeningState == .kept)
}

@MainActor
@Test("a commitments screen that cannot read its roster still makes and renames happenings")
func aCommitmentsScreenThatCannotReadItsRosterStillMakesAndRenamesHappenings() throws {
    let places = freshRosterAndRecordPlaces()
    try write(Data("not a roster store".utf8), at: places.roster)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: freshHappeningPlace())

    #expect(screen.happeningState == .kept)
    #expect(screen.makeHappening(named: "Kopfweh") == nil)
    let kopfweh = try #require(screen.happenings.first)
    #expect(screen.rename(kopfweh, to: "Spannungskopfweh") == nil)
    #expect(screen.happenings.map(\.name) == ["Spannungskopfweh"])
}
