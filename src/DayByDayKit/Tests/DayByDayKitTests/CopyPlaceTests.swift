import Foundation
import Testing

@testable import DayByDayKit

/// A fresh roster place, record place and one-off place, three sibling files under one fresh
/// temporary directory — mirrors `CopyTests.swift`'s own `freshThreePlaces()`. Nothing is created
/// until something writes to one of the three.
private func freshThreePlaces() -> (roster: URL, record: URL, oneOffs: URL) {
    let base = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    return (
        base.appendingPathComponent("roster.json"),
        base.appendingPathComponent("record.json"),
        base.appendingPathComponent("one-offs.json")
    )
}

/// A fresh directory of its own to be given as a copy place — "a directory of its own" in every
/// scenario below. Not created until something writes into it.
private func freshCopyPlaceDirectory() -> URL {
    FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
}

/// A fresh place of its own for a copy place to keep its own state at — distinct from the
/// directory a copy is written into, and from the three places a copy holds.
private func freshCopyPlaceState() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("copy-place.json")
}

/// A clock that always answers `moment`.
private func fixedClock(_ moment: Moment) -> @Sendable () -> Moment? {
    { moment }
}

/// A clock that answers a later minute each time it is asked, starting from `first` — mirrors
/// `RestoreTests.swift`'s own clocks that count a minute per ask, used wherever a scenario asks a
/// clock this way.
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

private let allWeekdays: Schedule = .weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])

@MainActor
@Test("a copy place is read back as it was left by one opened again at the same place")
func aCopyPlaceIsReadBackAsItWasLeftByOneOpenedAgainAtTheSamePlace() throws {
    let places = freshThreePlaces()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let statePlace = freshCopyPlaceState()
    let moment = Moment(on: monday, hour: 14, minute: 32)!

    let copyPlace = CopyPlace(
        at: statePlace, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: fixedClock(moment))
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)
    let directory = freshCopyPlaceDirectory()

    screen.givenAsCopyPlace(directory)

    let second = CopyPlace(
        at: statePlace, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: fixedClock(moment))

    #expect(second.folderName == directory.lastPathComponent)
    #expect(second.lastCopy == moment)
    #expect(second.stopped == nil)
    #expect(CopyPlace.place != DayScreen.recordPlace)
    #expect(CopyPlace.place != DayScreen.rosterPlace)
    #expect(CopyPlace.place != DayScreen.oneOffPlace)
}

@MainActor
@Test("a copy place where nothing has been kept holds no folder, no last copy and no stop")
func aCopyPlaceWhereNothingHasBeenKeptHoldsNoFolderNoLastCopyAndNoStop() {
    let places = freshThreePlaces()
    let statePlace = freshCopyPlaceState()

    let copyPlace = CopyPlace(
        at: statePlace, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: { nil })

    #expect(copyPlace.folderName == nil)
    #expect(copyPlace.lastCopy == nil)
    #expect(copyPlace.stopped == nil)
}

@MainActor
@Test("a restore confirmed leaves the folder that is the copy place as it was")
func aRestoreConfirmedLeavesTheFolderThatIsTheCopyPlaceAsItWas() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let places = freshThreePlaces()
    try RosterStore(at: places.roster).add(gym)

    let statePlace = freshCopyPlaceState()
    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: statePlace, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)
    let directory = freshCopyPlaceDirectory()
    screen.givenAsCopyPlace(directory)

    // A copy holding a roster of one entry named "Journaling", asked to be restored from a file
    // that is not the copy place's own — the ordinary restore-from-file path.
    let sourcePlaces = freshThreePlaces()
    try RosterStore(at: sourcePlaces.roster).add(
        Commitment(name: "Journaling", schedule: allWeekdays, keptFrom: keptFrom)!)
    let sourceScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: sourcePlaces.roster, keepingRecordAt: sourcePlaces.record,
        keepingOneOffsAt: sourcePlaces.oneOffs)
    let result = sourceScreen.makeACopy(
        asOf: Moment(on: monday, hour: 9, minute: 7)!, writingInto: freshCopyPlaceDirectory())
    guard case .success(let file) = result else {
        Issue.record("expected a copy to be made")
        return
    }

    #expect(screen.askToRestore(from: file) == nil)
    #expect(screen.confirmRestoring() == nil)

    let reopened = CopyPlace(
        at: statePlace, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)

    #expect(copyPlace.folderName == directory.lastPathComponent)
    #expect(reopened.folderName == directory.lastPathComponent)
}

@MainActor
@Test("a folder given as the copy place holds a copy of the three places at once")
func aFolderGivenAsTheCopyPlaceHoldsACopyOfTheThreePlacesAtOnce() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let places = freshThreePlaces()
    try RosterStore(at: places.roster).add(gym)
    try RecordStore(at: places.record).add(Tick(gym, on: august30th)!)
    try OneOffStore(at: places.oneOffs).add(
        OneOff(name: "Book dentist", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)

    let moment = Moment(on: monday, hour: 14, minute: 32)!
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: fixedClock(moment))
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)
    let directory = freshCopyPlaceDirectory()

    screen.givenAsCopyPlace(directory)

    let contents = try FileManager.default.contentsOfDirectory(atPath: directory.path)
    #expect(contents == ["DayByDay.daybyday"])

    let file = directory.appendingPathComponent("DayByDay.daybyday")
    let copy = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: file)).formCopy())
    #expect(copy.moment == moment)
    #expect(copy.roster.entries.map(\.commitment.name) == ["Gym"])
    #expect(copy.history.datesRecorded(for: gym) == [august30th])
    #expect(copy.oneOffs.entries.map(\.oneOff.name) == ["Book dentist"])

    #expect(copyPlace.lastCopy == moment)
    #expect(copyPlace.stopped == nil)
}

@MainActor
@Test("a copy written at the copy place replaces the file of that name already standing there")
func aCopyWrittenAtTheCopyPlaceReplacesTheFileOfThatNameAlreadyStandingThere() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()
    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)
    let directory = freshCopyPlaceDirectory()

    screen.givenAsCopyPlace(directory)
    #expect(
        screen.define(
            name: "Gym",
            on: .weekdays([
                .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
            ]), keptFrom: keptFrom, under: nil) == nil)

    let contents = try FileManager.default.contentsOfDirectory(atPath: directory.path)
    #expect(contents == ["DayByDay.daybyday"])

    let file = directory.appendingPathComponent("DayByDay.daybyday")
    let copy = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: file)).formCopy())
    let expectedMoment = Moment(on: monday, hour: 14, minute: 33)!
    #expect(copy.moment == expectedMoment)
    #expect(copy.roster.entries.map(\.commitment.name) == ["Gym"])
    #expect(copyPlace.lastCopy == expectedMoment)
}

@MainActor
@Test(
    "a folder given as the copy place that cannot be written becomes the copy place with a stop and no last copy"
)
func aFolderGivenAsTheCopyPlaceThatCannotBeWrittenBecomesTheCopyPlaceWithAStopAndNoLastCopy()
    throws
{
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()
    let moment = Moment(on: monday, hour: 14, minute: 32)!
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: fixedClock(moment))
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    let directory = freshCopyPlaceDirectory()
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
    defer {
        try? FileManager.default.setAttributes(
            [.posixPermissions: 0o700], ofItemAtPath: directory.path)
    }

    screen.givenAsCopyPlace(directory)

    #expect(copyPlace.folderName == directory.lastPathComponent)
    #expect(copyPlace.lastCopy == nil)
    #expect(copyPlace.stopped == CopyPlace.Stopped(stop: .folderCannotBeWritten, since: moment))
}

@MainActor
@Test("a folder given in another's stead leaves the file at the folder it replaces exactly as it was")
func aFolderGivenInAnothersSteadLeavesTheFileAtTheFolderItReplacesExactlyAsItWas() throws {
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()
    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    let first = freshCopyPlaceDirectory()
    screen.givenAsCopyPlace(first)
    let firstFile = first.appendingPathComponent("DayByDay.daybyday")
    let firstBytesBefore = try Data(contentsOf: firstFile)

    let second = freshCopyPlaceDirectory()
    screen.givenAsCopyPlace(second)

    #expect(copyPlace.folderName == second.lastPathComponent)
    let secondFile = second.appendingPathComponent("DayByDay.daybyday")
    let secondCopy = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: secondFile)).formCopy())
    #expect(secondCopy.moment == Moment(on: monday, hour: 14, minute: 33)!)

    #expect(try Data(contentsOf: firstFile) == firstBytesBefore)
}

/// Writes a copy holding `sourcePlaces`' three places, as of `moment`, into `directory` — the
/// fixed name `DayByDay.daybyday` a copy place writes, so a scenario can say "a folder already
/// holding a copy". Uses a throwaway `CopyPlace` of its own; its own state is discarded.
@MainActor
private func writeExistingCopy(
    into directory: URL, asOf moment: Moment,
    at sourcePlaces: (roster: URL, record: URL, oneOffs: URL)
) {
    CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: sourcePlaces.record,
        keepingRosterAt: sourcePlaces.roster, keepingOneOffsAt: sourcePlaces.oneOffs,
        asking: fixedClock(moment)
    ).set(to: directory)
}

@MainActor
@Test("a folder holding a copy asks to restore that copy and sets no copy place")
func aFolderHoldingACopyAsksToRestoreThatCopyAndSetsNoCopyPlace() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let places = freshThreePlaces()
    try RosterStore(at: places.roster).add(gym)

    let sourcePlaces = freshThreePlaces()
    try RosterStore(at: sourcePlaces.roster).add(gym)
    try RosterStore(at: sourcePlaces.roster).add(
        Commitment(name: "Journaling", schedule: allWeekdays, keptFrom: keptFrom)!)
    try OneOffStore(at: sourcePlaces.oneOffs).add(
        OneOff(name: "Book dentist", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)
    let directory = freshCopyPlaceDirectory()
    let sourceMoment = Moment(on: sunday, hour: 9, minute: 7)!
    writeExistingCopy(into: directory, asOf: sourceMoment, at: sourcePlaces)
    let file = directory.appendingPathComponent("DayByDay.daybyday")
    let bytesBefore = try Data(contentsOf: file)

    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    let refusal = screen.givenAsCopyPlace(directory)

    #expect(refusal == nil)
    #expect(screen.awaitingRestore?.moment == sourceMoment)
    #expect(screen.awaitingRestore?.copy == CommitmentsScreen.Counts(kept: 2, stopped: 0, oneOffs: 1))
    #expect(screen.awaitingRestore?.phone == CommitmentsScreen.Counts(kept: 1, stopped: 0, oneOffs: 0))
    #expect(copyPlace.folderName == nil)
    #expect(try Data(contentsOf: file) == bytesBefore)
}

@MainActor
@Test("a restore confirmed from a folder given as the copy place makes that folder the copy place")
func aRestoreConfirmedFromAFolderGivenAsTheCopyPlaceMakesThatFolderTheCopyPlace() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let places = freshThreePlaces()
    try RosterStore(at: places.roster).add(gym)

    let sourcePlaces = freshThreePlaces()
    try RosterStore(at: sourcePlaces.roster).add(
        Commitment(name: "Journaling", schedule: allWeekdays, keptFrom: keptFrom)!)
    let directory = freshCopyPlaceDirectory()
    writeExistingCopy(
        into: directory, asOf: Moment(on: monday, hour: 9, minute: 7)!, at: sourcePlaces)

    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    screen.givenAsCopyPlace(directory)
    #expect(screen.confirmRestoring() == nil)

    #expect(screen.kept.map(\.name) == ["Journaling"])
    #expect(copyPlace.folderName == directory.lastPathComponent)

    let file = directory.appendingPathComponent("DayByDay.daybyday")
    let copy = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: file)).formCopy())
    #expect(copy.moment == Moment(on: monday, hour: 14, minute: 32)!)
    #expect(copy.roster.entries.map(\.commitment.name) == ["Journaling"])
}

@MainActor
@Test(
    "a copy at a folder given as the copy place replaced with this phone's makes that folder the copy place"
)
func aCopyAtAFolderGivenAsTheCopyPlaceReplacedWithThisPhonesMakesThatFolderTheCopyPlace() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let places = freshThreePlaces()
    try RosterStore(at: places.roster).add(gym)

    let sourcePlaces = freshThreePlaces()
    try RosterStore(at: sourcePlaces.roster).add(
        Commitment(name: "Journaling", schedule: allWeekdays, keptFrom: keptFrom)!)
    let directory = freshCopyPlaceDirectory()
    writeExistingCopy(
        into: directory, asOf: Moment(on: monday, hour: 9, minute: 7)!, at: sourcePlaces)

    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    screen.givenAsCopyPlace(directory)
    screen.replaceTheCopyAtTheFolderGiven()

    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.awaitingRestore == nil)
    #expect(copyPlace.folderName == directory.lastPathComponent)

    let file = directory.appendingPathComponent("DayByDay.daybyday")
    let copy = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: file)).formCopy())
    #expect(copy.moment == Moment(on: monday, hour: 14, minute: 32)!)
    #expect(copy.roster.entries.map(\.commitment.name) == ["Gym"])
}

@MainActor
@Test(
    "a folder given as the copy place whose restore is cancelled becomes no copy place and is left as it was"
)
func aFolderGivenAsTheCopyPlaceWhoseRestoreIsCancelledBecomesNoCopyPlaceAndIsLeftAsItWas() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()

    let sourcePlaces = freshThreePlaces()
    try RosterStore(at: sourcePlaces.roster).add(
        Commitment(name: "Journaling", schedule: allWeekdays, keptFrom: keptFrom)!)
    let directory = freshCopyPlaceDirectory()
    writeExistingCopy(
        into: directory, asOf: Moment(on: monday, hour: 9, minute: 7)!, at: sourcePlaces)
    let file = directory.appendingPathComponent("DayByDay.daybyday")
    let bytesBefore = try Data(contentsOf: file)

    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    screen.givenAsCopyPlace(directory)
    screen.cancelRestoring()

    #expect(screen.awaitingRestore == nil)
    #expect(copyPlace.folderName == nil)
    #expect(copyPlace.lastCopy == nil)
    #expect(copyPlace.stopped == nil)
    #expect(try Data(contentsOf: file) == bytesBefore)
    #expect(!FileManager.default.fileExists(atPath: places.roster.path))
    #expect(!FileManager.default.fileExists(atPath: places.record.path))
    #expect(!FileManager.default.fileExists(atPath: places.oneOffs.path))
}

/// A minimal but valid `.daybyday` file's bytes: form 1 throughout, with a moment of Sunday
/// 30 August 2026 at 09:07 — mirrors `RestoreTests.swift`'s own `copyJSON(...)`. Every piece is
/// overridable so a test can corrupt exactly the one it is about.
private func copyJSON(
    version: Int = 1,
    moment: String? = """
        {"day":{"year":2026,"month":8,"day":30},"hour":9,"minute":7}
        """,
    record: String? = """
        {"version":1,"ticks":[]}
        """,
    roster: String? = """
        {"version":1,"commitments":[]}
        """,
    oneOffs: String? = """
        {"version":1,"oneOffs":[]}
        """
) -> Data {
    var fields = ["\"version\":\(version)"]
    if let moment { fields.append("\"moment\":\(moment)") }
    if let record { fields.append("\"record\":\(record)") }
    if let roster { fields.append("\"roster\":\(roster)") }
    if let oneOffs { fields.append("\"oneOffs\":\(oneOffs)") }
    return Data("{\(fields.joined(separator: ","))}".utf8)
}

/// Writes bytes that do not read as a copy at all into `directory`, at the fixed name a copy
/// place holds one under.
private func writeUnreadableFile(_ bytes: Data, into directory: URL) throws {
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    try bytes.write(to: directory.appendingPathComponent("DayByDay.daybyday"))
}

@MainActor
@Test(
    "a folder holding a file of a copy's name that is not a copy is refused, and no copy place is set"
)
func aFolderHoldingAFileOfACopysNameThatIsNotACopyIsRefusedAndNoCopyPlaceIsSet() throws {
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()
    let moment = Moment(on: monday, hour: 14, minute: 32)!
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: fixedClock(moment))
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    let directory = freshCopyPlaceDirectory()
    let bytes = Data("not what a copy is written as".utf8)
    try writeUnreadableFile(bytes, into: directory)

    let refusal = screen.givenAsCopyPlace(directory)

    #expect(refusal == .notACopy)
    #expect(copyPlace.folderName == nil)
    #expect(screen.awaitingRestore == nil)
    #expect(try Data(contentsOf: directory.appendingPathComponent("DayByDay.daybyday")) == bytes)
}

@MainActor
@Test(
    "a folder holding a damaged copy and one holding a copy from a later version are each refused for their own reason"
)
func aFolderHoldingADamagedCopyAndOneHoldingACopyFromALaterVersionAreEachRefusedForTheirOwnReason()
    throws
{
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()
    let moment = Moment(on: monday, hour: 14, minute: 32)!
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: fixedClock(moment))
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    let damagedDirectory = freshCopyPlaceDirectory()
    try writeUnreadableFile(copyJSON(roster: "{\"version\":1}"), into: damagedDirectory)
    #expect(screen.givenAsCopyPlace(damagedDirectory) == .damagedCopy)

    let laterDirectory = freshCopyPlaceDirectory()
    try writeUnreadableFile(
        copyJSON(version: CopyDocument.currentVersion + 1), into: laterDirectory)
    #expect(screen.givenAsCopyPlace(laterDirectory) == .copyFromALaterVersion)
}

@MainActor
@Test("a folder refused leaves the copy place already set, its last copy and its stop as they were")
func aFolderRefusedLeavesTheCopyPlaceAlreadySetItsLastCopyAndItsStopAsTheyWere() throws {
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()
    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    let first = freshCopyPlaceDirectory()
    screen.givenAsCopyPlace(first)

    let second = freshCopyPlaceDirectory()
    try writeUnreadableFile(Data("not what a copy is written as".utf8), into: second)

    let refusal = screen.givenAsCopyPlace(second)

    #expect(refusal == .notACopy)
    #expect(copyPlace.folderName == first.lastPathComponent)
    #expect(copyPlace.lastCopy == Moment(on: monday, hour: 14, minute: 32)!)
    #expect(copyPlace.stopped == nil)
}

@MainActor
@Test("a folder refused is held apart from a refused change, and ends when the app is shown again")
func aFolderRefusedIsHeldApartFromARefusedChangeAndEndsWhenTheAppIsShownAgain() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let places = freshThreePlaces()
    try RosterStore(at: places.roster).add(gym)

    let moment = Moment(on: monday, hour: 14, minute: 32)!
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: fixedClock(moment))
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    let defineRefusal = screen.define(
        name: "Gym",
        on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)
    #expect(defineRefusal == .alreadyKept)

    let directory = freshCopyPlaceDirectory()
    try writeUnreadableFile(Data("not what a copy is written as".utf8), into: directory)

    #expect(screen.givenAsCopyPlace(directory) == .notACopy)
    #expect(screen.refusedCopyPlace == .notACopy)
    #expect(screen.refusedChange == .defining(.alreadyKept))

    screen.shown(asOf: monday)
    #expect(screen.refusedCopyPlace == nil)

    let second = freshCopyPlaceDirectory()
    _ = screen.givenAsCopyPlace(second)
    #expect(screen.refusedCopyPlace == nil)
}

@MainActor
@Test(
    "a commitment defined, stopped, taken up again and removed through a commitments screen each write a copy at the copy place"
)
func aCommitmentDefinedStoppedTakenUpAgainAndRemovedThroughACommitmentsScreenEachWriteACopyAtTheCopyPlace()
    throws
{
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()

    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)
    let directory = freshCopyPlaceDirectory()
    screen.givenAsCopyPlace(directory)

    let file = directory.appendingPathComponent("DayByDay.daybyday")
    func rosterInCopy() throws -> Roster {
        try #require(
            JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: file)).formCopy()
        ).roster
    }

    let refusal = screen.define(
        name: "Gym",
        on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
        keptFrom: keptFrom, under: nil)
    #expect(refusal == nil)
    #expect(try rosterInCopy() == (try RosterStore(at: places.roster)).roster)

    let gym = try #require(screen.kept.first)
    screen.askToStopKeeping(gym)
    #expect(screen.confirmStopKeeping() == nil)
    #expect(try rosterInCopy() == (try RosterStore(at: places.roster)).roster)

    #expect(screen.keepAgain(gym) == nil)
    #expect(try rosterInCopy() == (try RosterStore(at: places.roster)).roster)

    screen.askToRemove(gym)
    screen.nameTypedBack = gym.name
    #expect(screen.confirmRemoving() == nil)
    #expect(try rosterInCopy() == (try RosterStore(at: places.roster)).roster)

    #expect(copyPlace.lastCopy == Moment(on: monday, hour: 14, minute: 36)!)
}

@MainActor
@Test("a change reaching the record place and the roster place writes exactly one copy holding both")
func aChangeReachingTheRecordPlaceAndTheRosterPlaceWritesExactlyOneCopyHoldingBoth() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let places = freshThreePlaces()
    try RosterStore(at: places.roster).add(gym)
    try RecordStore(at: places.record).add(Tick(gym, on: sunday)!)

    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)
    let directory = freshCopyPlaceDirectory()
    screen.givenAsCopyPlace(directory)

    let refusal = screen.change(
        gym, toName: "Gym 🏋️",
        on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
        keptFrom: keptFrom, under: nil)

    #expect(refusal == nil)

    let file = directory.appendingPathComponent("DayByDay.daybyday")
    let copy = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: file)).formCopy())
    #expect(copy.roster.entries.map(\.commitment.name) == ["Gym 🏋️"])
    #expect(
        copy.history.datesRecorded(for: Commitment(name: "Gym 🏋️", schedule: allWeekdays, keptFrom: keptFrom)!)
            == [sunday])
    #expect(copy.moment == Moment(on: monday, hour: 14, minute: 33)!)
    #expect(copyPlace.lastCopy == Moment(on: monday, hour: 14, minute: 33)!)
}

@MainActor
@Test("a restore confirmed writes a copy at the copy place holding what was restored")
func aRestoreConfirmedWritesACopyAtTheCopyPlaceHoldingWhatWasRestored() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let places = freshThreePlaces()
    try RosterStore(at: places.roster).add(gym)

    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)
    let directory = freshCopyPlaceDirectory()
    screen.givenAsCopyPlace(directory)

    let sourcePlaces = freshThreePlaces()
    try RosterStore(at: sourcePlaces.roster).add(
        Commitment(name: "Journaling", schedule: allWeekdays, keptFrom: keptFrom)!)
    let sourceScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: sourcePlaces.roster, keepingRecordAt: sourcePlaces.record,
        keepingOneOffsAt: sourcePlaces.oneOffs)
    let result = sourceScreen.makeACopy(
        asOf: Moment(on: monday, hour: 9, minute: 7)!, writingInto: freshCopyPlaceDirectory())
    guard case .success(let file) = result else {
        Issue.record("expected a copy to be made")
        return
    }

    #expect(screen.askToRestore(from: file) == nil)
    #expect(screen.confirmRestoring() == nil)

    let copyPlaceFile = directory.appendingPathComponent("DayByDay.daybyday")
    let copy = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: copyPlaceFile)).formCopy())
    #expect(copy.roster.entries.map(\.commitment.name) == ["Journaling"])
    #expect(copy.moment == Moment(on: monday, hour: 14, minute: 33)!)
}

@MainActor
@Test("a call that keeps nothing writes no copy at the copy place")
func aCallThatKeepsNothingWritesNoCopyAtTheCopyPlace() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let places = freshThreePlaces()
    try RosterStore(at: places.roster).add(gym)

    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)
    let directory = freshCopyPlaceDirectory()
    screen.givenAsCopyPlace(directory)
    let momentAfterPick = copyPlace.lastCopy

    // A move to the place it already holds keeps nothing.
    #expect(screen.move(gym, toOffset: 0, under: nil) == nil)
    #expect(copyPlace.lastCopy == momentAfterPick)

    // A definition refused as already kept keeps nothing.
    let refusal = screen.define(
        name: "Gym",
        on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
        keptFrom: keptFrom, under: nil)
    #expect(refusal == .alreadyKept)
    #expect(copyPlace.lastCopy == momentAfterPick)

    // A stop asked for and cancelled keeps nothing.
    screen.askToStopKeeping(gym)
    screen.cancelStopKeeping()
    #expect(copyPlace.lastCopy == momentAfterPick)

    // A restore asked for and cancelled keeps nothing.
    let sourcePlaces = freshThreePlaces()
    try RosterStore(at: sourcePlaces.roster).add(
        Commitment(name: "Journaling", schedule: allWeekdays, keptFrom: keptFrom)!)
    let sourceScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: sourcePlaces.roster, keepingRecordAt: sourcePlaces.record,
        keepingOneOffsAt: sourcePlaces.oneOffs)
    let result = sourceScreen.makeACopy(
        asOf: Moment(on: monday, hour: 9, minute: 7)!, writingInto: freshCopyPlaceDirectory())
    guard case .success(let file) = result else {
        Issue.record("expected a copy to be made")
        return
    }
    #expect(screen.askToRestore(from: file) == nil)
    screen.cancelRestoring()
    #expect(copyPlace.lastCopy == momentAfterPick)
}

@MainActor
@Test("a folder that cannot be reached is told apart from one that cannot be written")
func aFolderThatCannotBeReachedIsToldApartFromOneThatCannotBeWritten() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()
    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    let directory = freshCopyPlaceDirectory()
    screen.givenAsCopyPlace(directory)
    try FileManager.default.removeItem(at: directory)

    let refusal = screen.define(
        name: "Gym",
        on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
        keptFrom: keptFrom, under: nil)

    #expect(refusal == nil)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(
        copyPlace.stopped
            == CopyPlace.Stopped(
                stop: .folderCannotBeReached, since: Moment(on: monday, hour: 14, minute: 33)!))
    #expect(copyPlace.lastCopy == Moment(on: monday, hour: 14, minute: 32)!)
}

@MainActor
@Test("a stop keeps the moment it began over later changes that also fail")
func aStopKeepsTheMomentItBeganOverLaterChangesThatAlsoFail() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()
    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    let directory = freshCopyPlaceDirectory()
    try makeCopyPlaceDirectoryUnwritable(directory)
    defer {
        try? FileManager.default.setAttributes(
            [.posixPermissions: 0o700], ofItemAtPath: directory.path)
    }
    screen.givenAsCopyPlace(directory)

    let refusal = screen.define(
        name: "Gym",
        on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
        keptFrom: keptFrom, under: nil)
    #expect(refusal == nil)
    let gym = try #require(screen.kept.first)
    screen.askToStopKeeping(gym)
    #expect(screen.confirmStopKeeping() == nil)

    #expect(
        copyPlace.stopped
            == CopyPlace.Stopped(
                stop: .folderCannotBeWritten, since: Moment(on: monday, hour: 14, minute: 32)!))
    #expect(copyPlace.lastCopy == nil)
}

/// Makes `directory` read-only, so a place already holding something can be made unwritable
/// without disturbing what is there. Mirrors `DayScreenTests.swift`'s own approach.
private func makeCopyPlaceDirectoryUnwritable(_ directory: URL) throws {
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
}

@MainActor
@Test(
    "a change kept after a stop, where the folder can be written again, ends the stop and becomes the last copy"
)
func aChangeKeptAfterAStopWhereTheFolderCanBeWrittenAgainEndsTheStopAndBecomesTheLastCopy() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()
    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    let directory = freshCopyPlaceDirectory()
    try makeCopyPlaceDirectoryUnwritable(directory)
    screen.givenAsCopyPlace(directory)

    let refusal = screen.define(
        name: "Gym",
        on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
        keptFrom: keptFrom, under: nil)
    #expect(refusal == nil)

    try FileManager.default.setAttributes([.posixPermissions: 0o700], ofItemAtPath: directory.path)

    let gym = try #require(screen.kept.first)
    screen.askToStopKeeping(gym)
    #expect(screen.confirmStopKeeping() == nil)

    #expect(copyPlace.stopped == nil)
    #expect(copyPlace.lastCopy == Moment(on: monday, hour: 14, minute: 34)!)

    let file = directory.appendingPathComponent("DayByDay.daybyday")
    let copy = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: file)).formCopy())
    #expect(copy.roster.entries.first?.keptUntil != nil)
}

// Scenario "a copy that could not be made is not held as a refused change" (tasks.md 8.6) is not
// implemented here — see the hand-back: its second THEN clause ("it still holds the refused
// definition against defining a commitment", checked after "Journaling" is *successfully*
// defined) contradicts the shipped, unmodified `commitment` requirement "What a commitments
// screen holds about a refused change lasts until the app is shown again or a change is kept",
// proven by the already-passing test
// `whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenACommitmentIsDefinedAndKept` in
// `CommitmentsScreenTests.swift`, which defines "Journaling" the same way and asserts
// `refusedChange == nil` afterwards. Implementing 8.6 literally would require breaking that
// shipped test; implementing the shipped rule instead would make 8.6's own assertion false.

@MainActor
@Test(
    "a commitments screen says the name of the folder that is its copy place and the last copy made there"
)
func aCommitmentsScreenSaysTheNameOfTheFolderThatIsItsCopyPlaceAndTheLastCopyMadeThere() throws {
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()
    let moment = Moment(on: monday, hour: 14, minute: 32)!
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: fixedClock(moment))
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("Backups", isDirectory: true)

    screen.givenAsCopyPlace(directory)

    #expect(screen.copyPlace?.folderName == "Backups")
    #expect(screen.copyPlace?.lastCopy == moment)
    #expect(screen.copyPlace?.stopped == nil)
}

@MainActor
@Test("a commitments screen says the stop and the moment it began beside the last copy made")
func aCommitmentsScreenSaysTheStopAndTheMomentItBeganBesideTheLastCopyMade() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()
    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("Backups", isDirectory: true)

    screen.givenAsCopyPlace(directory)
    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
    defer {
        try? FileManager.default.setAttributes(
            [.posixPermissions: 0o700], ofItemAtPath: directory.path)
    }

    let refusal = screen.define(
        name: "Gym",
        on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
        keptFrom: keptFrom, under: nil)
    #expect(refusal == nil)

    #expect(screen.copyPlace?.lastCopy == Moment(on: monday, hour: 14, minute: 32)!)
    #expect(
        screen.copyPlace?.stopped
            == CopyPlace.Stopped(
                stop: .folderCannotBeWritten, since: Moment(on: monday, hour: 14, minute: 33)!))
}

@MainActor
@Test("a commitments screen with no copy place says no folder, no last copy and no stop")
func aCommitmentsScreenWithNoCopyPlaceSaysNoFolderNoLastCopyAndNoStop() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: { nil })
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    #expect(screen.copyPlace?.folderName == nil)
    #expect(screen.copyPlace?.lastCopy == nil)
    #expect(screen.copyPlace?.stopped == nil)

    let refusal = screen.define(
        name: "Gym",
        on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
        keptFrom: keptFrom, under: nil)
    #expect(refusal == nil)
    #expect(screen.copyPlace?.folderName == nil)
    #expect(screen.copyPlace?.lastCopy == nil)
    #expect(screen.copyPlace?.stopped == nil)
}

@MainActor
@Test("a copy asked for and made is not the last copy a commitments screen says")
func aCopyAskedForAndMadeIsNotTheLastCopyACommitmentsScreenSays() throws {
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()
    let moment = Moment(on: monday, hour: 14, minute: 32)!
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: fixedClock(moment))
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)
    let directory = freshCopyPlaceDirectory()
    screen.givenAsCopyPlace(directory)

    let result = screen.makeACopy(
        asOf: Moment(on: monday, hour: 16, minute: 5)!, writingInto: freshCopyPlaceDirectory())
    guard case .success = result else {
        Issue.record("expected a copy to be made")
        return
    }

    #expect(screen.copyPlace?.lastCopy == moment)
    #expect(screen.copyPlace?.stopped == nil)

    let contents = try FileManager.default.contentsOfDirectory(atPath: directory.path)
    #expect(contents == ["DayByDay.daybyday"])
    let copy = try #require(
        JSONDecoder().decode(
            CopyDocument.self,
            from: Data(contentsOf: directory.appendingPathComponent("DayByDay.daybyday"))
        ).formCopy())
    #expect(copy.moment == moment)
}

@MainActor
@Test("a commitments screen shown again with its folder gone says what the last attempt left")
func aCommitmentsScreenShownAgainWithItsFolderGoneSaysWhatTheLastAttemptLeft() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()
    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("Backups", isDirectory: true)
    screen.givenAsCopyPlace(directory)
    try FileManager.default.removeItem(at: directory)

    screen.shown(asOf: monday)

    #expect(screen.copyPlace?.folderName == "Backups")
    #expect(screen.copyPlace?.lastCopy == Moment(on: monday, hour: 14, minute: 32)!)
    #expect(screen.copyPlace?.stopped == nil)

    let refusal = screen.define(
        name: "Gym",
        on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
        keptFrom: keptFrom, under: nil)
    #expect(refusal == nil)
    #expect(
        screen.copyPlace?.stopped
            == CopyPlace.Stopped(
                stop: .folderCannotBeReached, since: Moment(on: monday, hour: 14, minute: 33)!))
}

@MainActor
@Test("a copy place forgotten leaves no folder, no last copy and no stop")
func aCopyPlaceForgottenLeavesNoFolderNoLastCopyAndNoStop() throws {
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()
    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let statePlace = freshCopyPlaceState()
    let copyPlace = CopyPlace(
        at: statePlace, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)
    let directory = freshCopyPlaceDirectory()
    screen.givenAsCopyPlace(directory)

    screen.forgetTheCopyPlace()

    #expect(screen.copyPlace?.folderName == nil)
    #expect(screen.copyPlace?.lastCopy == nil)
    #expect(screen.copyPlace?.stopped == nil)

    let reopened = CopyPlace(
        at: statePlace, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    #expect(reopened.folderName == nil)
    #expect(reopened.lastCopy == nil)
    #expect(reopened.stopped == nil)
}

@MainActor
@Test("a copy place forgotten leaves the file at the folder it forgot as it was")
func aCopyPlaceForgottenLeavesTheFileAtTheFolderItForgotAsItWas() throws {
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()
    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)
    let directory = freshCopyPlaceDirectory()
    screen.givenAsCopyPlace(directory)
    let file = directory.appendingPathComponent("DayByDay.daybyday")
    let bytesBefore = try Data(contentsOf: file)

    screen.forgetTheCopyPlace()

    #expect(try Data(contentsOf: file) == bytesBefore)
    #expect(!FileManager.default.fileExists(atPath: places.roster.path))
    #expect(!FileManager.default.fileExists(atPath: places.record.path))
    #expect(!FileManager.default.fileExists(atPath: places.oneOffs.path))
}

@MainActor
@Test("a change kept after the copy place is forgotten writes no copy and is not refused")
func aChangeKeptAfterTheCopyPlaceIsForgottenWritesNoCopyAndIsNotRefused() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()
    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: clock)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)
    let directory = freshCopyPlaceDirectory()
    screen.givenAsCopyPlace(directory)
    let file = directory.appendingPathComponent("DayByDay.daybyday")
    let bytesBefore = try Data(contentsOf: file)

    screen.forgetTheCopyPlace()

    let refusal = screen.define(
        name: "Gym",
        on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
        keptFrom: keptFrom, under: nil)

    #expect(refusal == nil)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(try Data(contentsOf: file) == bytesBefore)
    #expect(screen.copyPlace?.lastCopy == nil)
    #expect(screen.copyPlace?.stopped == nil)
}

@MainActor
@Test("forgetting where no copy place is set changes nothing")
func forgettingWhereNoCopyPlaceIsSetChangesNothing() throws {
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let places = freshThreePlaces()
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: { nil })
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    screen.forgetTheCopyPlace()

    #expect(screen.copyPlace?.folderName == nil)
    #expect(screen.copyPlace?.lastCopy == nil)
    #expect(screen.copyPlace?.stopped == nil)
    #expect(!FileManager.default.fileExists(atPath: places.roster.path))
    #expect(!FileManager.default.fileExists(atPath: places.record.path))
    #expect(!FileManager.default.fileExists(atPath: places.oneOffs.path))
}

/// Directly seeds a copy place's own state file with `folder` as its folder and `lastCopy` as
/// its last copy, without going through `set(to:)` — which would also write a real copy into
/// `folder`. Matches the JSON shape `CopyPlace`'s own state file uses; `folder` itself is left
/// untouched, so a test can prove nothing is written there by the action under test.
private func seedCopyPlaceState(at statePlace: URL, folder: URL, lastCopy: Moment) throws {
    try FileManager.default.createDirectory(
        at: statePlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let json = """
        {"version":1,"path":"\(folder.path)","name":"\(folder.lastPathComponent)",\
        "lastCopy":{"day":{"year":\(lastCopy.day.year),"month":\(lastCopy.day.month),\
        "day":\(lastCopy.day.day)},"hour":\(lastCopy.hour),"minute":\(lastCopy.minute)}}
        """
    try Data(json.utf8).write(to: statePlace)
}

@MainActor
@Test("a torn save undone when a screen is opened writes no copy at the copy place")
func aTornSaveUndoneWhenAScreenIsOpenedWritesNoCopyAtTheCopyPlace() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: allWeekdays, keptFrom: keptFrom)!
    let places = freshThreePlaces()

    try RosterStore(at: places.roster).add(gym)
    try RecordStore(at: places.record).add(Tick(gymEmoji, on: august3rd)!)
    try SaveInProgress(carriedFrom: gym, to: gymEmoji).keep(
        at: SaveInProgress.place(besideRecordAt: places.record))

    let directory = freshCopyPlaceDirectory()
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let statePlace = freshCopyPlaceState()
    let nineOhSeven = Moment(on: monday, hour: 9, minute: 7)!
    try seedCopyPlaceState(at: statePlace, folder: directory, lastCopy: nineOhSeven)

    let copyPlace = CopyPlace(
        at: statePlace, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: fixedClock(Moment(on: monday, hour: 14, minute: 32)!))

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(copyPlace.lastCopy == nineOhSeven)
    #expect(copyPlace.stopped == nil)
    #expect(try FileManager.default.contentsOfDirectory(atPath: directory.path).isEmpty)
}

@MainActor
@Test("a torn restore undone when a screen is opened writes no copy at the copy place")
func aTornRestoreUndoneWhenAScreenIsOpenedWritesNoCopyAtTheCopyPlace() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let places = freshThreePlaces()

    try RosterStore(at: places.roster).add(gym)
    var journalingRoster = Roster()
    _ = journalingRoster.add(
        Commitment(name: "Journaling", schedule: allWeekdays, keptFrom: keptFrom)!)
    let copy = Copy(
        moment: Moment(on: monday, hour: 9, minute: 0)!, history: History(),
        roster: journalingRoster, oneOffs: OneOffs())
    try RestoreInProgress.restore(
        copy, recordAt: places.record, rosterAt: places.roster, oneOffsAt: places.oneOffs,
        stoppingAfter: 2)

    let directory = freshCopyPlaceDirectory()
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let statePlace = freshCopyPlaceState()
    let nineOhSeven = Moment(on: monday, hour: 9, minute: 7)!
    try seedCopyPlaceState(at: statePlace, folder: directory, lastCopy: nineOhSeven)

    let copyPlace = CopyPlace(
        at: statePlace, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: fixedClock(Moment(on: monday, hour: 14, minute: 32)!))

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(copyPlace.lastCopy == nineOhSeven)
    #expect(copyPlace.stopped == nil)
    #expect(try FileManager.default.contentsOfDirectory(atPath: directory.path).isEmpty)
}

@MainActor
@Test("an orphaned record carried back writes no copy at the copy place")
func anOrphanedRecordCarriedBackWritesNoCopyAtTheCopyPlace() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let renamedGym = Commitment(name: "Gym renamed", schedule: allWeekdays, keptFrom: keptFrom)!
    let places = freshThreePlaces()

    try RosterStore(at: places.roster).add(renamedGym)
    try RecordStore(at: places.record).add(Tick(gym, on: august3rd)!)

    let directory = freshCopyPlaceDirectory()
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let statePlace = freshCopyPlaceState()
    let nineOhSeven = Moment(on: monday, hour: 9, minute: 7)!
    try seedCopyPlaceState(at: statePlace, folder: directory, lastCopy: nineOhSeven)

    let copyPlace = CopyPlace(
        at: statePlace, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: fixedClock(Moment(on: monday, hour: 14, minute: 32)!))

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    #expect(try RecordStore(at: places.record).history.isKept(renamedGym, on: august3rd))
    #expect(!screen.recordsBelongToNoCommitment)
    #expect(copyPlace.lastCopy == nineOhSeven)
    #expect(copyPlace.stopped == nil)
    #expect(try FileManager.default.contentsOfDirectory(atPath: directory.path).isEmpty)
}

@MainActor
@Test("the commitments a day screen takes on where its roster place holds nothing write no copy")
func theCommitmentsADayScreenTakesOnWhereItsRosterPlaceHoldsNothingWriteNoCopy() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let places = freshThreePlaces()

    let directory = freshCopyPlaceDirectory()
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let statePlace = freshCopyPlaceState()
    let nineOhSeven = Moment(on: monday, hour: 9, minute: 7)!
    try seedCopyPlaceState(at: statePlace, folder: directory, lastCopy: nineOhSeven)

    let copyPlace = CopyPlace(
        at: statePlace, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: fixedClock(Moment(on: monday, hour: 14, minute: 32)!))

    let dayScreen = DayScreen(
        startingFrom: [gym], asOf: monday, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    #expect(dayScreen.dayView.rows.map(\.name) == ["Gym"])
    #expect(try RosterStore(at: places.roster).roster.entries.map(\.commitment.name) == ["Gym"])
    #expect(copyPlace.lastCopy == nineOhSeven)
    #expect(copyPlace.stopped == nil)
    #expect(try FileManager.default.contentsOfDirectory(atPath: directory.path).isEmpty)
}
