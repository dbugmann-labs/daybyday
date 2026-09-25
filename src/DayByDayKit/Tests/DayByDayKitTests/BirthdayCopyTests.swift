import Foundation
import Testing

@testable import DayByDayKit

/// A fresh roster place, record place, one-off place and birthday place, four sibling files
/// under one fresh temporary directory — mirrors `RestoreTests.swift`'s own `freshThreePlaces()`,
/// widened to the fourth place this Story carries. Nothing is created until something writes to
/// one of the four.
private func freshFourPlaces() -> (roster: URL, record: URL, oneOffs: URL, birthday: URL) {
    let base = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    return (
        base.appendingPathComponent("roster.json"),
        base.appendingPathComponent("record.json"),
        base.appendingPathComponent("one-offs.json"),
        base.appendingPathComponent("birthday-ticks.json")
    )
}

/// A fresh directory of its own for a copy or a take-out to be written into — not created until
/// something writes into it.
private func freshCopyDirectory() -> URL {
    FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
}

/// A fresh place for a picked `.daybyday` file, named `name`, under a directory of its own.
private func freshPickedFile(named name: String = "DayByDay 2026-08-31 14.32.daybyday") -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent(name)
}

private let allWeekdays: Schedule = .weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])

private let kate = Birthday(
    contact: "kate", words: "Kate Bell's 48th Birthday",
    day: CalendarDate(year: 2026, month: 9, day: 25)!)!

private let john = Birthday(
    contact: "john", words: "John Appleseed's 40th Birthday",
    day: CalendarDate(year: 2026, month: 9, day: 26)!)!

/// A fresh place of its own for a copy place to keep its own state at — distinct from the
/// directory a copy is written into, and from the four places a copy holds. Mirrors
/// `CopyPlaceTests.swift`'s own `freshCopyPlaceState()`.
private func freshCopyPlaceState() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("copy-place.json")
}

/// A clock that answers a later minute each time it is asked, starting from `first` — mirrors
/// `CopyPlaceTests.swift`'s own `laterMinuteEachTime(from:)`.
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

/// A `BirthdayCalendar` that always hands `birthdays`, collating by plain `<` — mirrors
/// `DayScreenBirthdayTests.swift`'s own `fakeCalendar`, simplified to what this file needs.
private func fixedCalendar(handing birthdays: [Birthday]) -> BirthdayCalendar {
    BirthdayCalendar(reading: { _, _ in birthdays }, collating: { $0 < $1 })
}

/// A `BirthdayCalendar` that always throws when asked to read.
private func fixedThrowingCalendar() -> BirthdayCalendar {
    struct Failure: Error {}
    return BirthdayCalendar(
        reading: { _, _ in throw Failure() }, collating: { $0 < $1 })
}

/// A fresh place for a birthday switch to keep its own state at, mirroring
/// `DayScreenBirthdayTests.swift`'s own `freshSwitchPlace()`.
private func freshSwitchPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("birthday-switch.json")
}

/// A birthday switch already on, its phone always giving full access — mirrors
/// `DayScreenBirthdayTests.swift`'s own `onSwitch()`.
@MainActor
private func onSwitch() async -> BirthdaySwitch {
    let switchUnderTest = BirthdaySwitch(
        at: freshSwitchPlace(), readingAccess: { .full }, askingForAccess: {})
    await switchUnderTest.turnOn()
    return switchUnderTest
}

/// A path that cannot be written: `blocker` is an ordinary file, not a directory, and `name`
/// sits beneath it, so any write through it fails — mirrors `RestoreTests.swift`'s own
/// `blockedPlace(named:)`.
private func blockedPlace(named name: String) throws -> URL {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    return blocker.appendingPathComponent(name)
}

/// Makes `directory` read-only, so a write to a file already inside it fails while the file
/// itself still reads — mirrors `CommitmentsScreenTests.swift`'s own helper of the same name.
/// Every caller must pair this with `makeWritable(_:)`, including on its failure path.
private func makeReadOnly(_ directory: URL) throws {
    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
}

/// Undoes `makeReadOnly(_:)`, restoring `directory` to one that can be written to again.
private func makeWritable(_ directory: URL) throws {
    try FileManager.default.setAttributes([.posixPermissions: 0o700], ofItemAtPath: directory.path)
}

/// `copy`, written exactly as a copy was written before copies held birthday ticks: form 1,
/// nothing named `birthdayTicks` at all — derived from the current, form-2 encoding of `copy`
/// (which always holds no ticks unless `copy.birthdayTicks` says otherwise) by dropping that key
/// and lowering `version`, rather than hand-typing a roster's own JSON shape.
private func form1CopyBytes(_ copy: Copy) throws -> Data {
    let document = CopyDocument(copy)
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys]
    let data = try encoder.encode(document)

    var object = try JSONSerialization.jsonObject(with: data) as! [String: Any]
    object["version"] = 1
    object.removeValue(forKey: "birthdayTicks")
    return try JSONSerialization.data(withJSONObject: object, options: [.sortedKeys])
}

/// A minimal but valid `.daybyday` file's bytes at form 2, with every piece overridable so a
/// test can corrupt exactly the one it is about — mirrors `RestoreTests.swift`'s own `copyJSON`,
/// widened with the fourth store this Story adds. `birthdayTicks` is `nil` to omit the key
/// entirely, as opposed to present but malformed.
private func copyJSON(
    version: Int = CopyDocument.currentVersion,
    moment: String = """
        {"day":{"year":2026,"month":8,"day":31},"hour":14,"minute":32}
        """,
    record: String = """
        {"version":1,"ticks":[]}
        """,
    roster: String = """
        {"version":1,"commitments":[]}
        """,
    oneOffs: String = """
        {"version":1,"oneOffs":[]}
        """,
    birthdayTicks: String? = """
        {"version":1,"ticks":[]}
        """
) -> Data {
    var fields = [
        "\"version\":\(version)", "\"moment\":\(moment)", "\"record\":\(record)",
        "\"roster\":\(roster)", "\"oneOffs\":\(oneOffs)",
    ]
    if let birthdayTicks { fields.append("\"birthdayTicks\":\(birthdayTicks)") }
    return Data("{\(fields.joined(separator: ","))}".utf8)
}

@MainActor
@Test(
    "a copy holds the birthday ticks the birthday place holds, and none where nothing has been kept there"
)
func aCopyHoldsTheBirthdayTicksTheBirthdayPlaceHoldsAndNoneWhereNothingHasBeenKeptThere() throws {
    let places = freshFourPlaces()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let birthdayStore = try BirthdayStore(at: places.birthday)
    try birthdayStore.tick(kate)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday)

    let birthdayBytesBefore = try Data(contentsOf: places.birthday)

    let result = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())

    guard case .success(let url) = result else {
        Issue.record("expected a copy to be made")
        return
    }
    let copy = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: url)).formCopy())

    #expect(copy.birthdayTicks.isTicked(kate))
    #expect(copy.birthdayTicks.keys.count == 1)
    #expect(try Data(contentsOf: places.birthday) == birthdayBytesBefore)

    // A copy asked for the same way where nothing has been kept at the birthday place.
    let emptyPlaces = freshFourPlaces()
    let emptyScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: emptyPlaces.roster, keepingRecordAt: emptyPlaces.record,
        keepingOneOffsAt: emptyPlaces.oneOffs, keepingBirthdayTicksAt: emptyPlaces.birthday)
    let emptyDirectory = freshCopyDirectory()

    let emptyResult = emptyScreen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: emptyDirectory)

    guard case .success(let emptyURL) = emptyResult else {
        Issue.record("expected a copy to be made")
        return
    }
    let emptyCopy = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: emptyURL)).formCopy())

    #expect(emptyCopy.birthdayTicks.keys.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: emptyPlaces.birthday.path))
}

@MainActor
@Test(
    "a copy is refused whole where the birthday ticks cannot be read, naming them only where the other three stores read"
)
func aCopyIsRefusedWholeWhereTheBirthdayTicksCannotBeReadNamingThemOnlyWhereTheOtherThreeStoresRead()
    throws
{
    let places = freshFourPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!

    try RosterStore(at: places.roster).add(gym)
    try Data("not what birthday ticks are written as".utf8).write(to: places.birthday)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday)
    let directory = freshCopyDirectory()

    let result = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: directory)

    guard case .failure(let refusal) = result else {
        Issue.record("expected a copy to be refused")
        return
    }
    #expect(refusal == .storeCouldNotBeRead)
    if case .makingACopy(let store, _) = screen.refusedChange {
        #expect(store == .birthdayTicks)
    } else {
        Issue.record("expected a refused copy naming the birthday ticks")
    }
    #expect(!FileManager.default.fileExists(atPath: directory.path))
    #expect(
        try Data(contentsOf: places.birthday)
            == Data("not what birthday ticks are written as".utf8))

    // Birthday ticks written by a later version.
    let laterPlaces = freshFourPlaces()
    try RosterStore(at: laterPlaces.roster).add(gym)
    try Data(#"{"version": \#(BirthdayDocument.currentVersion + 1), "ticks": []}"#.utf8)
        .write(to: laterPlaces.birthday)
    let laterScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: laterPlaces.roster, keepingRecordAt: laterPlaces.record,
        keepingOneOffsAt: laterPlaces.oneOffs, keepingBirthdayTicksAt: laterPlaces.birthday)

    let laterResult = laterScreen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
    guard case .failure(let laterRefusal) = laterResult else {
        Issue.record("expected a copy to be refused")
        return
    }
    #expect(laterRefusal == .storeWrittenByALaterVersion)
    if case .makingACopy(let store, _) = laterScreen.refusedChange {
        #expect(store == .birthdayTicks)
    } else {
        Issue.record("expected a refused copy naming the birthday ticks")
    }

    // The one-off place is also unreadable: the one-offs outrank the birthday ticks.
    let bothPlaces = freshFourPlaces()
    try RosterStore(at: bothPlaces.roster).add(gym)
    try Data("not what birthday ticks are written as".utf8).write(to: bothPlaces.birthday)
    try Data("not a one-off holder".utf8).write(to: bothPlaces.oneOffs)
    let bothScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: bothPlaces.roster, keepingRecordAt: bothPlaces.record,
        keepingOneOffsAt: bothPlaces.oneOffs, keepingBirthdayTicksAt: bothPlaces.birthday)

    let bothResult = bothScreen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
    guard case .failure(let bothRefusal) = bothResult else {
        Issue.record("expected a copy to be refused")
        return
    }
    #expect(bothRefusal == .storeCouldNotBeRead)
    if case .makingACopy(let store, _) = bothScreen.refusedChange {
        #expect(store == .oneOffs)
    } else {
        Issue.record("expected a refused copy naming the one-offs")
    }
}

@MainActor
@Test(
    "a commitments screen that cannot erase a removed commitment's records and cannot read the birthday ticks names the roster and the birthday ticks, dropping neither"
)
func aCommitmentsScreenThatCannotEraseARemovedCommitmentsRecordsAndCannotReadTheBirthdayTicksNamesTheRosterAndTheBirthdayTicksDroppingNeither()
    throws
{
    // `readPlaces` rebuilds `storesNotRead` by hand once the erase the migration owes at open
    // fails — `CommitmentsScreenTests.swift`'s own fixture for that failure, widened with a
    // birthday place that cannot be read either, to catch the birthday-ticks entry that rebuild
    // dropped (G7 review finding 1).
    let places = freshFourPlaces()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!

    try FileManager.default.createDirectory(
        at: places.roster.deletingLastPathComponent(), withIntermediateDirectories: true)
    let rosterBytes = Data(
        """
        {
          "version": 5,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"] },
                "identity": "11111111-1111-1111-1111-111111111111"
              },
              "keptUntil": { "year": 2026, "month": 8, "day": 30 },
              "removed": true,
              "category": null
            },
            {
              "commitment": {
                "name": "Lifting",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"] },
                "identity": "22222222-2222-2222-2222-222222222222"
              },
              "removed": false,
              "category": null
            }
          ]
        }
        """.utf8)
    try rosterBytes.write(to: places.roster)

    let gym = Commitment(
        identity: Commitment.Identity("11111111-1111-1111-1111-111111111111")!,
        name: "Gym",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!, kind: .tick)!

    let recordDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let recordPlace = recordDirectory.appendingPathComponent("record.json")
    let recordStore = try RecordStore(at: recordPlace)
    try recordStore.add(Tick(gym, on: august3rd)!)

    try makeReadOnly(recordDirectory)
    defer { try? makeWritable(recordDirectory) }

    try Data("not what birthday ticks are written as".utf8).write(to: places.birthday)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: recordPlace,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday)

    #expect(
        screen.storesNotRead == [
            CommitmentsScreen.StoreNotRead(store: .roster, cause: .couldNotBeRead),
            CommitmentsScreen.StoreNotRead(store: .birthdayTicks, cause: .couldNotBeRead),
        ])
}

@MainActor
@Test(
    "a change kept where the birthday ticks cannot be read is kept, and the stop names the birthday ticks"
)
func aChangeKeptWhereTheBirthdayTicksCannotBeReadIsKeptAndTheStopNamesTheBirthdayTicks() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let places = freshFourPlaces()
    try RosterStore(at: places.roster).add(gym)

    let clock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday, asking: clock)
    let commitmentsScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday,
        copyingTo: copyPlace)
    let directory = freshCopyDirectory()
    commitmentsScreen.givenAsCopyPlace(directory)

    let dayScreen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday,
        copyingTo: copyPlace)

    // What is at the birthday place is made a run of bytes that is not what birthday ticks are
    // written as only now — after the day screen is opened, matching the scenario's own order
    // (G7 review finding 5).
    try FileManager.default.createDirectory(
        at: places.birthday.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what birthday ticks are written as".utf8).write(to: places.birthday)

    try dayScreen.tick(dayScreen.dayView.rows.first { $0.name == "Gym" }!)

    #expect(dayScreen.notice == nil)
    #expect(try RecordStore(at: places.record).history.isKept(gym, on: monday))
    #expect(
        copyPlace.stopped
            == CopyPlace.Stopped(
                stop: .storeCouldNotBeRead(.birthdayTicks),
                since: Moment(on: monday, hour: 14, minute: 33)!))

    // Birthday ticks written by a later version stop with that cause instead.
    let laterPlaces = freshFourPlaces()
    try RosterStore(at: laterPlaces.roster).add(gym)
    let laterClock = laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!)
    let laterCopyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: laterPlaces.record,
        keepingRosterAt: laterPlaces.roster, keepingOneOffsAt: laterPlaces.oneOffs,
        keepingBirthdayTicksAt: laterPlaces.birthday, asking: laterClock)
    let laterCommitmentsScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: laterPlaces.roster, keepingRecordAt: laterPlaces.record,
        keepingOneOffsAt: laterPlaces.oneOffs, keepingBirthdayTicksAt: laterPlaces.birthday,
        copyingTo: laterCopyPlace)
    laterCommitmentsScreen.givenAsCopyPlace(freshCopyDirectory())

    try FileManager.default.createDirectory(
        at: laterPlaces.birthday.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"version": \#(BirthdayDocument.currentVersion + 1), "ticks": []}"#.utf8)
        .write(to: laterPlaces.birthday)

    let laterDayScreen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: laterPlaces.record,
        keepingRosterAt: laterPlaces.roster, keepingOneOffsAt: laterPlaces.oneOffs,
        keepingBirthdayTicksAt: laterPlaces.birthday, copyingTo: laterCopyPlace)

    try laterDayScreen.tick(laterDayScreen.dayView.rows.first { $0.name == "Gym" }!)

    #expect(
        laterCopyPlace.stopped
            == CopyPlace.Stopped(
                stop: .storeWrittenByALaterVersion(.birthdayTicks),
                since: Moment(on: monday, hour: 14, minute: 33)!))
}

@MainActor
@Test(
    "a day screen, a commitments screen and a copy place given no birthday place keep their birthday ticks at the same place"
)
func aDayScreenACommitmentsScreenAndACopyPlaceGivenNoBirthdayPlaceKeepTheirBirthdayTicksAtTheSamePlace()
    async throws
{
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let base = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let recordPlace = base.appendingPathComponent("record.json")
    let rosterPlace = base.appendingPathComponent("roster.json")
    let oneOffPlace = base.appendingPathComponent("one-offs.json")

    let kateBirthday = Birthday(
        contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!
    let calendar = fixedCalendar(handing: [kateBirthday])
    let birthdaySwitch = await onSwitch()

    let clock = laterMinuteEachTime(from: Moment(on: january20, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: recordPlace, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace, asking: clock)

    let dayScreen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: recordPlace,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace,
        readingBirthdaysFrom: calendar, whileOn: birthdaySwitch, copyingTo: copyPlace)
    let commitmentsScreen = CommitmentsScreen(
        asOf: january20, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace,
        keepingOneOffsAt: oneOffPlace, copyingTo: copyPlace)

    let directory = freshCopyDirectory()
    commitmentsScreen.givenAsCopyPlace(directory)

    try dayScreen.tick(dayScreen.dayView.birthdayGroup!.rows.first { $0.birthday == kateBirthday }!)

    let copyAtDirectory = try #require(
        JSONDecoder().decode(
            CopyDocument.self, from: Data(contentsOf: directory.appendingPathComponent("DayByDay.daybyday"))
        ).formCopy())
    #expect(copyAtDirectory.birthdayTicks.isTicked(kateBirthday))

    let throughCommitmentsScreen = commitmentsScreen.makeACopy(
        asOf: Moment(on: january20, hour: 14, minute: 40)!, writingInto: freshCopyDirectory())
    guard case .success(let url) = throughCommitmentsScreen else {
        Issue.record("expected a copy to be made")
        return
    }
    let copyThroughCommitmentsScreen = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: url)).formCopy())
    #expect(copyThroughCommitmentsScreen.birthdayTicks.isTicked(kateBirthday))

    #expect(DayScreen.birthdayPlace(besideRecordAt: DayScreen.recordPlace) == DayScreen.birthdayPlace)
}

@MainActor
@Test(
    "a copy made before copies held birthday ticks is read as holding none, and restoring it leaves the birthday place holding none"
)
func aCopyMadeBeforeCopiesHeldBirthdayTicksIsReadAsHoldingNoneAndRestoringItLeavesTheBirthdayPlaceHoldingNone()
    throws
{
    let places = freshFourPlaces()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!

    let birthdayStore = try BirthdayStore(at: places.birthday)
    try birthdayStore.tick(kate)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday)

    var roster = Roster()
    _ = roster.add(gym)
    let form1Copy = Copy(
        moment: Moment(on: monday, hour: 9, minute: 7)!, history: History(), roster: roster,
        oneOffs: OneOffs())
    let file = freshPickedFile()
    try FileManager.default.createDirectory(
        at: file.deletingLastPathComponent(), withIntermediateDirectories: true)
    try form1CopyBytes(form1Copy).write(to: file)

    let askRefusal = screen.askToRestore(from: file)
    #expect(askRefusal == nil)
    #expect(screen.awaitingRestore?.copy == CommitmentsScreen.Counts(kept: 1, stopped: 0, oneOffs: 0))

    let confirmRefusal = screen.confirmRestoring()
    #expect(confirmRefusal == nil)
    #expect(try BirthdayStore(at: places.birthday).ticks.keys.isEmpty)
    #expect(screen.kept.map(\.name) == ["Gym"])

    let afterCopy = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
    guard case .success(let url) = afterCopy else {
        Issue.record("expected a copy to be made")
        return
    }
    let redecoded = try JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: url))
    #expect(redecoded.version > 1)
}

@MainActor
@Test(
    "a copy whose birthday ticks do not read is refused as a damaged copy, and one whose birthday ticks are of a later form as a copy from a later version"
)
func aCopyWhoseBirthdayTicksDoNotReadIsRefusedAsADamagedCopyAndOneWhoseBirthdayTicksAreOfALaterFormAsACopyFromALaterVersion()
    throws
{
    let places = freshFourPlaces()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    func expectDamaged(_ data: Data) throws {
        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday)
        let file = freshPickedFile()
        try FileManager.default.createDirectory(
            at: file.deletingLastPathComponent(), withIntermediateDirectories: true)
        try data.write(to: file)

        let refusal = screen.askToRestore(from: file)

        #expect(refusal == .damagedCopy)
        #expect(screen.awaitingRestore == nil)
    }

    // A copy made through the screen, its birthday ticks then taken out of it entirely.
    let copyScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday)
    let madeResult = copyScreen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
    guard case .success(let madeURL) = madeResult else {
        Issue.record("expected a copy to be made")
        return
    }
    var object =
        try JSONSerialization.jsonObject(with: Data(contentsOf: madeURL)) as! [String: Any]
    object.removeValue(forKey: "birthdayTicks")
    try expectDamaged(try JSONSerialization.data(withJSONObject: object, options: [.sortedKeys]))

    // Two ticks alike in contact and day.
    try expectDamaged(
        copyJSON(
            birthdayTicks: """
                {"version":1,"ticks":[
                    {"contact":"kate","day":{"year":2026,"month":9,"day":25}},
                    {"contact":"kate","day":{"year":2026,"month":9,"day":25}}
                ]}
                """))

    // A contact of blank space alone.
    try expectDamaged(
        copyJSON(
            birthdayTicks: """
                {"version":1,"ticks":[{"contact":"   ","day":{"year":2026,"month":9,"day":25}}]}
                """))

    func expectFromALaterVersion(_ data: Data) throws {
        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday)
        let file = freshPickedFile()
        try FileManager.default.createDirectory(
            at: file.deletingLastPathComponent(), withIntermediateDirectories: true)
        try data.write(to: file)

        let refusal = screen.askToRestore(from: file)

        #expect(refusal == .copyFromALaterVersion)
        #expect(screen.awaitingRestore == nil)
    }

    // The birthday ticks say a form one later than the birthday store writes.
    try expectFromALaterVersion(
        copyJSON(
            birthdayTicks: "{\"version\":\(BirthdayDocument.currentVersion + 1),\"ticks\":[]}"))

    // The same, beside a roster that lacks a field its form always writes.
    try expectFromALaterVersion(
        copyJSON(
            roster: "{\"version\":1}",
            birthdayTicks: "{\"version\":\(BirthdayDocument.currentVersion + 1),\"ticks\":[]}"))
}

@MainActor
@Test(
    "a commitments screen asked to restore counts no birthday tick, and says the phone's birthday ticks cannot be read only where they cannot"
)
func aCommitmentsScreenAskedToRestoreCountsNoBirthdayTickAndSaysThePhonesBirthdayTicksCannotBeReadOnlyWhereTheyCannot()
    throws
{
    let places = freshFourPlaces()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let birthdayStore = try BirthdayStore(at: places.birthday)
    try birthdayStore.tick(kate)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday)

    let madeResult = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
    guard case .success(let url) = madeResult else {
        Issue.record("expected a copy to be made")
        return
    }

    try birthdayStore.tick(john)
    let birthdayBytesBefore = try Data(contentsOf: places.birthday)

    let askRefusal = screen.askToRestore(from: url)
    #expect(askRefusal == nil)
    let awaitingRestore = try #require(screen.awaitingRestore)
    #expect(awaitingRestore.copy == CommitmentsScreen.Counts(kept: 0, stopped: 0, oneOffs: 0))
    #expect(awaitingRestore.phone == CommitmentsScreen.Counts(kept: 0, stopped: 0, oneOffs: 0))
    #expect(awaitingRestore.unreadable.isEmpty)
    #expect(try Data(contentsOf: places.birthday) == birthdayBytesBefore)

    // The phone's birthday ticks cannot be read.
    try Data("not what birthday ticks are written as".utf8).write(to: places.birthday)
    let screenUnreadable = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday)
    let unreadableRefusal = screenUnreadable.askToRestore(from: url)
    #expect(unreadableRefusal == nil)
    let unreadableAwaiting = try #require(screenUnreadable.awaitingRestore)
    #expect(unreadableAwaiting.unreadable == [.birthdayTicks])
    #expect(unreadableAwaiting.phone == CommitmentsScreen.Counts(kept: 0, stopped: 0, oneOffs: 0))

    // The phone's birthday ticks are of a later form.
    try Data(#"{"version": \#(BirthdayDocument.currentVersion + 1), "ticks": []}"#.utf8)
        .write(to: places.birthday)
    let screenLater = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday)
    let laterRefusal = screenLater.askToRestore(from: url)
    #expect(laterRefusal == nil)
    let laterAwaiting = try #require(screenLater.awaitingRestore)
    #expect(laterAwaiting.unreadable == [.birthdayTicks])
    #expect(laterAwaiting.phone == CommitmentsScreen.Counts(kept: 0, stopped: 0, oneOffs: 0))
}

@MainActor
@Test(
    "a restore confirmed makes the birthday place hold the copy's birthday ticks, and the ticks there are gone"
)
func aRestoreConfirmedMakesTheBirthdayPlaceHoldTheCopysBirthdayTicksAndTheTicksThereAreGone()
    throws
{
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    // The bytes a birthday store writes for ticks holding only kate's birthday — the expected
    // content at the birthday place once the restore is confirmed.
    let referencePlace = freshFourPlaces().birthday
    try BirthdayStore(at: referencePlace).tick(kate)
    let expectedBytes = try Data(contentsOf: referencePlace)

    func expectRestoredContent(_ seedBirthdayPlace: (URL) throws -> Void) throws {
        let places = freshFourPlaces()
        let birthdayStore = try BirthdayStore(at: places.birthday)
        try birthdayStore.tick(kate)

        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday)
        let madeResult = screen.makeACopy(
            asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
        guard case .success(let url) = madeResult else {
            Issue.record("expected a copy to be made")
            return
        }

        try seedBirthdayPlace(places.birthday)

        #expect(screen.askToRestore(from: url) == nil)
        #expect(screen.confirmRestoring() == nil)

        #expect(try Data(contentsOf: places.birthday) == expectedBytes)
    }

    // Kate's tick taken back, john's ticked in its place — a merge would keep john's too.
    try expectRestoredContent { birthdayPlace in
        let store = try BirthdayStore(at: birthdayPlace)
        try store.takeBack(kate)
        try store.tick(john)
    }

    // The birthday place holds a run of bytes that is not what birthday ticks are written as.
    try expectRestoredContent { birthdayPlace in
        try Data("not what birthday ticks are written as".utf8).write(to: birthdayPlace)
    }
}

@MainActor
@Test(
    "a restore refused where the birthday place cannot be written leaves the four places as they were"
)
func aRestoreRefusedWhereTheBirthdayPlaceCannotBeWrittenLeavesTheFourPlacesAsTheyWere() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!

    let base = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let rosterPlace = base.appendingPathComponent("roster.json")
    let recordPlace = base.appendingPathComponent("record.json")
    let oneOffPlace = base.appendingPathComponent("one-offs.json")
    let birthdayPlace = try blockedPlace(named: "birthday-ticks.json")

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: recordPlace)
    try recordStore.add(Tick(gym, on: sunday)!)
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(
        OneOff(name: "Book dentist", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace,
        keepingOneOffsAt: oneOffPlace, keepingBirthdayTicksAt: birthdayPlace)

    let rosterBytesBefore = try Data(contentsOf: rosterPlace)
    let recordBytesBefore = try Data(contentsOf: recordPlace)
    let oneOffBytesBefore = try Data(contentsOf: oneOffPlace)

    // A copy holding a commitment "Journaling" and kate's birthday ticked.
    let sourcePlaces = freshFourPlaces()
    try RosterStore(at: sourcePlaces.roster).add(
        Commitment(name: "Journaling", schedule: allWeekdays, keptFrom: keptFrom)!)
    try BirthdayStore(at: sourcePlaces.birthday).tick(kate)
    let sourceScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: sourcePlaces.roster, keepingRecordAt: sourcePlaces.record,
        keepingOneOffsAt: sourcePlaces.oneOffs, keepingBirthdayTicksAt: sourcePlaces.birthday)
    let madeResult = sourceScreen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
    guard case .success(let copyURL) = madeResult else {
        Issue.record("expected a copy to be made")
        return
    }

    #expect(screen.askToRestore(from: copyURL) == nil)
    let refusal = screen.confirmRestoring()

    #expect(refusal == .notKept)
    #expect(try Data(contentsOf: recordPlace) == recordBytesBefore)
    #expect(try Data(contentsOf: rosterPlace) == rosterBytesBefore)
    #expect(try Data(contentsOf: oneOffPlace) == oneOffBytesBefore)
    #expect(!FileManager.default.fileExists(atPath: birthdayPlace.path))
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.copyRestored == nil)
    #expect(screen.awaitingRestore == nil)
}

@MainActor
@Test(
    "a restore stopped before it was whole is undone at the birthday place when the places are next opened"
)
func aRestoreStoppedBeforeItWasWholeIsUndoneAtTheBirthdayPlaceWhenThePlacesAreNextOpened() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!

    let places = freshFourPlaces()
    try RosterStore(at: places.roster).add(gym)
    try BirthdayStore(at: places.birthday).tick(kate)

    let rosterBytesBefore = try Data(contentsOf: places.roster)
    let recordExistsBefore = FileManager.default.fileExists(atPath: places.record.path)
    let oneOffsExistsBefore = FileManager.default.fileExists(atPath: places.oneOffs.path)
    let birthdayBytesBefore = try Data(contentsOf: places.birthday)

    var journalingRoster = Roster()
    _ = journalingRoster.add(
        Commitment(name: "Journaling", schedule: allWeekdays, keptFrom: keptFrom)!)
    var johnTicks = BirthdayTicks()
    _ = johnTicks.tick(john)
    let copy = Copy(
        moment: Moment(on: monday, hour: 9, minute: 0)!, history: History(),
        roster: journalingRoster, oneOffs: OneOffs(), birthdayTicks: johnTicks)

    // Left having written all four places, the restore in progress it left still standing —
    // `stoppingAfter: 4` completes every write and leaves the file behind, the same seam
    // `RestoreTests.swift` uses for a torn restore stopped at three.
    try RestoreInProgress.restore(
        copy, recordAt: places.record, rosterAt: places.roster, oneOffsAt: places.oneOffs,
        birthdayTicksAt: places.birthday, stoppingAfter: 4)

    #expect(
        FileManager.default.fileExists(
            atPath: RestoreInProgress.place(besideRecordAt: places.record).path))

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday)

    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(try Data(contentsOf: places.roster) == rosterBytesBefore)
    #expect(FileManager.default.fileExists(atPath: places.record.path) == recordExistsBefore)
    #expect(FileManager.default.fileExists(atPath: places.oneOffs.path) == oneOffsExistsBefore)
    #expect(try Data(contentsOf: places.birthday) == birthdayBytesBefore)
    #expect(
        !FileManager.default.fileExists(
            atPath: RestoreInProgress.place(besideRecordAt: places.record).path))

    // A restore in progress kept in the form it had before restores wrote the birthday place —
    // no `birthdayTicks` snapshot at all — leaves the birthday place as it stands.
    let elsePlaces = freshFourPlaces()
    try RosterStore(at: elsePlaces.roster).add(gym)
    try BirthdayStore(at: elsePlaces.birthday).tick(kate)
    let elseBirthdayBytesBefore = try Data(contentsOf: elsePlaces.birthday)
    let elseRosterBytesBefore = try Data(contentsOf: elsePlaces.roster)

    let oldFormSnapshot = RestoreInProgress(
        record: nil, roster: try Data(contentsOf: elsePlaces.roster), oneOffs: nil,
        saveInProgress: nil, birthdayTicks: nil)
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys]
    let oldFormPlace = RestoreInProgress.place(besideRecordAt: elsePlaces.record)
    try FileManager.default.createDirectory(
        at: oldFormPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try encoder.encode(oldFormSnapshot).write(to: oldFormPlace)

    // Change the roster so the undo has something to notice putting back.
    try RosterStore(at: elsePlaces.roster).add(
        Commitment(name: "Journaling", schedule: allWeekdays, keptFrom: keptFrom)!)

    let elseScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: elsePlaces.roster, keepingRecordAt: elsePlaces.record,
        keepingOneOffsAt: elsePlaces.oneOffs, keepingBirthdayTicksAt: elsePlaces.birthday)

    #expect(elseScreen.kept.map(\.name) == ["Gym"])
    #expect(try Data(contentsOf: elsePlaces.roster) == elseRosterBytesBefore)
    #expect(try Data(contentsOf: elsePlaces.birthday) == elseBirthdayBytesBefore)
    #expect(!FileManager.default.fileExists(atPath: oldFormPlace.path))
}

@MainActor
@Test("a birthday tick kept on a day screen writes a copy at the copy place holding that tick")
func aBirthdayTickKeptOnADayScreenWritesACopyAtTheCopyPlaceHoldingThatTick() async throws {
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let places = freshFourPlaces()
    let kateJan20 = Birthday(
        contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!

    let calendar = fixedCalendar(handing: [kateJan20])
    let birthdaySwitch = await onSwitch()

    let clock = laterMinuteEachTime(from: Moment(on: january20, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday, asking: clock)
    let commitmentsScreen = CommitmentsScreen(
        asOf: january20, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday,
        copyingTo: copyPlace)
    let directory = freshCopyDirectory()
    commitmentsScreen.givenAsCopyPlace(directory)

    let dayScreen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOffs,
        keepingBirthdayTicksAt: places.birthday, readingBirthdaysFrom: calendar,
        whileOn: birthdaySwitch, copyingTo: copyPlace)

    let row = dayScreen.dayView.birthdayGroup!.rows.first { $0.birthday == kateJan20 }!
    try dayScreen.tick(row)

    let file = directory.appendingPathComponent("DayByDay.daybyday")
    let firstCopy = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: file)).formCopy())
    #expect(firstCopy.moment == Moment(on: january20, hour: 14, minute: 33)!)
    #expect(firstCopy.birthdayTicks.isTicked(kateJan20))

    try dayScreen.tick(dayScreen.dayView.birthdayGroup!.rows.first { $0.birthday == kateJan20 }!)

    let secondCopy = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: file)).formCopy())
    #expect(secondCopy.moment == Moment(on: january20, hour: 14, minute: 34)!)
    #expect(secondCopy.birthdayTicks.keys.isEmpty)
}

@MainActor
@Test(
    "a birthday tick refused, or asked of a row that offers none, writes no copy at the copy place"
)
func aBirthdayTickRefusedOrAskedOfARowThatOffersNoneWritesNoCopyAtTheCopyPlace() async throws {
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let kateJan20 = Birthday(
        contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!

    let base = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let recordPlace = base.appendingPathComponent("record.json")
    let rosterPlace = base.appendingPathComponent("roster.json")
    let oneOffPlace = base.appendingPathComponent("one-offs.json")
    let birthdayPlace = try blockedPlace(named: "birthday-ticks.json")

    let calendar = fixedCalendar(handing: [kateJan20])
    let birthdaySwitch = await onSwitch()

    let clock = laterMinuteEachTime(from: Moment(on: january20, hour: 14, minute: 32)!)
    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: recordPlace, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace, keepingBirthdayTicksAt: birthdayPlace, asking: clock)
    let commitmentsScreen = CommitmentsScreen(
        asOf: january20, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace,
        keepingOneOffsAt: oneOffPlace, keepingBirthdayTicksAt: birthdayPlace, copyingTo: copyPlace)
    commitmentsScreen.givenAsCopyPlace(freshCopyDirectory())

    #expect(copyPlace.lastCopy == Moment(on: january20, hour: 14, minute: 32)!)

    let dayScreen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: recordPlace,
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace,
        keepingBirthdayTicksAt: birthdayPlace, readingBirthdaysFrom: calendar,
        whileOn: birthdaySwitch, copyingTo: copyPlace)

    let row = dayScreen.dayView.birthdayGroup!.rows.first { $0.birthday == kateJan20 }!
    var threw = false
    do {
        try dayScreen.tick(row)
    } catch {
        threw = true
    }
    #expect(threw)

    #expect(copyPlace.lastCopy == Moment(on: january20, hour: 14, minute: 32)!)
    #expect(copyPlace.stopped == nil)

    // A second day screen, its birthday place writable this time, and a calendar holding john's
    // birthday the day after — a row that never offers a tick as of the screen's own today.
    let secondBase = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let secondRecordPlace = secondBase.appendingPathComponent("record.json")
    let secondRosterPlace = secondBase.appendingPathComponent("roster.json")
    let secondOneOffPlace = secondBase.appendingPathComponent("one-offs.json")
    let secondBirthdayPlace = secondBase.appendingPathComponent("birthday-ticks.json")

    let january21 = CalendarDate(year: 2026, month: 1, day: 21)!
    let johnJan21 = Birthday(
        contact: "john", words: "John Appleseed's 40th Birthday", day: january21)!
    let secondCalendar = fixedCalendar(handing: [johnJan21])
    let secondSwitch = await onSwitch()

    let secondClock = laterMinuteEachTime(from: Moment(on: january20, hour: 14, minute: 32)!)
    let secondCopyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: secondRecordPlace,
        keepingRosterAt: secondRosterPlace, keepingOneOffsAt: secondOneOffPlace,
        keepingBirthdayTicksAt: secondBirthdayPlace, asking: secondClock)
    let secondCommitmentsScreen = CommitmentsScreen(
        asOf: january20, keepingRosterAt: secondRosterPlace, keepingRecordAt: secondRecordPlace,
        keepingOneOffsAt: secondOneOffPlace, keepingBirthdayTicksAt: secondBirthdayPlace,
        copyingTo: secondCopyPlace)
    secondCommitmentsScreen.givenAsCopyPlace(freshCopyDirectory())

    let secondDayScreen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: secondRecordPlace,
        keepingRosterAt: secondRosterPlace, keepingOneOffsAt: secondOneOffPlace,
        keepingBirthdayTicksAt: secondBirthdayPlace, readingBirthdaysFrom: secondCalendar,
        whileOn: secondSwitch, copyingTo: secondCopyPlace)

    let dayAfterRow = secondDayScreen.nextDayView!.birthdayGroup!.rows.first {
        $0.birthday == johnJan21
    }!
    try secondDayScreen.tick(dayAfterRow)
    #expect(secondCopyPlace.lastCopy == Moment(on: january20, hour: 14, minute: 32)!)

    secondDayScreen.showNextDay()
    try secondDayScreen.tick(dayAfterRow)
    #expect(secondCopyPlace.lastCopy == Moment(on: january20, hour: 14, minute: 32)!)
}

@MainActor
@Test("a take-out hands out the file at the birthday place byte-for-byte under the name it lies under")
func aTakeOutHandsOutTheFileAtTheBirthdayPlaceByteForByteUnderTheNameItLiesUnder() throws {
    let places = freshFourPlaces()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    try BirthdayStore(at: places.birthday).tick(kate)
    try Data("not a record".utf8).write(to: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday)
    let directory = freshCopyDirectory()

    let result = screen.takeOut(writingInto: directory)

    guard case .success(let urls) = result else {
        Issue.record("expected a take-out to be made")
        return
    }
    #expect(urls.map(\.lastPathComponent).sorted() == ["birthday-ticks.json", "record.json"])
    let birthdayURL = try #require(urls.first { $0.lastPathComponent == "birthday-ticks.json" })
    #expect(try Data(contentsOf: birthdayURL) == Data(contentsOf: places.birthday))
}

@MainActor
@Test(
    "a commitments screen offers a take-out over birthday ticks that cannot be read, naming them after the one-offs"
)
func aCommitmentsScreenOffersATakeOutOverBirthdayTicksThatCannotBeReadNamingThemAfterTheOneOffs()
    throws
{
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let places = freshFourPlaces()
    try FileManager.default.createDirectory(
        at: places.birthday.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what birthday ticks are written as".utf8).write(to: places.birthday)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday)

    #expect(screen.offersATakeOut)
    #expect(
        screen.storesNotRead
            == [CommitmentsScreen.StoreNotRead(store: .birthdayTicks, cause: .couldNotBeRead)])

    let bothPlaces = freshFourPlaces()
    try FileManager.default.createDirectory(
        at: bothPlaces.birthday.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what birthday ticks are written as".utf8).write(to: bothPlaces.birthday)
    try Data("not a one-off holder".utf8).write(to: bothPlaces.oneOffs)
    let bothScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: bothPlaces.roster, keepingRecordAt: bothPlaces.record,
        keepingOneOffsAt: bothPlaces.oneOffs, keepingBirthdayTicksAt: bothPlaces.birthday)

    #expect(bothScreen.offersATakeOut)
    #expect(
        bothScreen.storesNotRead
            == [
                CommitmentsScreen.StoreNotRead(store: .oneOffs, cause: .couldNotBeRead),
                CommitmentsScreen.StoreNotRead(store: .birthdayTicks, cause: .couldNotBeRead),
            ])

    let laterPlaces = freshFourPlaces()
    try FileManager.default.createDirectory(
        at: laterPlaces.birthday.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"version": \#(BirthdayDocument.currentVersion + 1), "ticks": []}"#.utf8)
        .write(to: laterPlaces.birthday)
    let laterScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: laterPlaces.roster, keepingRecordAt: laterPlaces.record,
        keepingOneOffsAt: laterPlaces.oneOffs, keepingBirthdayTicksAt: laterPlaces.birthday)

    #expect(laterScreen.offersATakeOut)
    #expect(
        laterScreen.storesNotRead
            == [
                CommitmentsScreen.StoreNotRead(
                    store: .birthdayTicks, cause: .writtenByALaterVersion)
            ])
}

@MainActor
@Test(
    "a commitments screen holding a restore in progress it could not undo names the birthday ticks only where they cannot be read"
)
func aCommitmentsScreenHoldingARestoreInProgressItCouldNotUndoNamesTheBirthdayTicksOnlyWhereTheyCannotBeRead()
    throws
{
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!

    let places = freshFourPlaces()
    try RosterStore(at: places.roster).add(gym)
    try BirthdayStore(at: places.birthday).tick(kate)
    try Data("not a restore in progress".utf8)
        .write(to: RestoreInProgress.place(besideRecordAt: places.record))

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday)

    #expect(screen.offersATakeOut)
    #expect(
        screen.storesNotRead
            == [
                CommitmentsScreen.StoreNotRead(store: .record, cause: .couldNotBeRead),
                CommitmentsScreen.StoreNotRead(store: .roster, cause: .couldNotBeRead),
                CommitmentsScreen.StoreNotRead(store: .oneOffs, cause: .couldNotBeRead),
            ])

    let unreadablePlaces = freshFourPlaces()
    try RosterStore(at: unreadablePlaces.roster).add(gym)
    try Data("not what birthday ticks are written as".utf8).write(to: unreadablePlaces.birthday)
    try Data("not a restore in progress".utf8)
        .write(to: RestoreInProgress.place(besideRecordAt: unreadablePlaces.record))

    let unreadableScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: unreadablePlaces.roster,
        keepingRecordAt: unreadablePlaces.record, keepingOneOffsAt: unreadablePlaces.oneOffs,
        keepingBirthdayTicksAt: unreadablePlaces.birthday)

    #expect(unreadableScreen.offersATakeOut)
    #expect(
        unreadableScreen.storesNotRead
            == [
                CommitmentsScreen.StoreNotRead(store: .record, cause: .couldNotBeRead),
                CommitmentsScreen.StoreNotRead(store: .roster, cause: .couldNotBeRead),
                CommitmentsScreen.StoreNotRead(store: .oneOffs, cause: .couldNotBeRead),
                CommitmentsScreen.StoreNotRead(store: .birthdayTicks, cause: .couldNotBeRead),
            ])
}

@MainActor
@Test(
    "a commitments screen asked for a take-out answers the birthday ticks' file after the one-offs' and before a save in progress"
)
func aCommitmentsScreenAskedForATakeOutAnswersTheBirthdayTicksFileAfterTheOneOffsAndBeforeASaveInProgress()
    throws
{
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!

    let places = freshFourPlaces()
    try RosterStore(at: places.roster).add(gym)
    try OneOffStore(at: places.oneOffs).add(
        OneOff(name: "Book dentist", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)
    try BirthdayStore(at: places.birthday).tick(kate)
    try Data("not a save in progress".utf8)
        .write(to: SaveInProgress.place(besideRecordAt: places.record))

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday)

    let directory = freshCopyDirectory()
    let result = screen.takeOut(writingInto: directory)

    guard case .success(let urls) = result else {
        Issue.record("expected a take-out to be made")
        return
    }
    #expect(
        urls.map(\.lastPathComponent)
            == ["roster.json", "one-offs.json", "birthday-ticks.json", "save-in-progress.json"])
    let parent = try #require(urls.first).deletingLastPathComponent()
    let contents = try FileManager.default.contentsOfDirectory(atPath: parent.path)
    #expect(Set(contents) == Set(urls.map(\.lastPathComponent)))
}

@MainActor
@Test(
    "a take-out refused over the birthday place names the birthday ticks and hands out none of the others"
)
func aTakeOutRefusedOverTheBirthdayPlaceNamesTheBirthdayTicksAndHandsOutNoneOfTheOthers() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!

    let places = freshFourPlaces()
    try RosterStore(at: places.roster).add(gym)
    let rosterBytes = try Data(contentsOf: places.roster)
    try FileManager.default.createDirectory(
        at: places.birthday, withIntermediateDirectories: true)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday)
    #expect(screen.offersATakeOut)

    let directory = freshCopyDirectory()
    let result = screen.takeOut(writingInto: directory)

    guard case .failure(let refusal) = result else {
        Issue.record("expected a take-out to be refused")
        return
    }
    #expect(refusal == .storeCouldNotBeRead)
    #expect(screen.refusedChange == .takingOut(.birthdayTicks, .storeCouldNotBeRead))
    if FileManager.default.fileExists(atPath: directory.path) {
        #expect(try FileManager.default.contentsOfDirectory(atPath: directory.path).isEmpty)
    }
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    var isDirectory: ObjCBool = false
    #expect(FileManager.default.fileExists(atPath: places.birthday.path, isDirectory: &isDirectory))
    #expect(isDirectory.boolValue)
}

@MainActor
@Test(
    "a day screen that says its birthday ticks could not be read says a copy can be restored, and says nothing of it while birthdays are off"
)
func aDayScreenThatSaysItsBirthdayTicksCouldNotBeReadSaysACopyCanBeRestoredAndSaysNothingOfItWhileBirthdaysAreOff()
    async throws
{
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let kateJan20 = Birthday(
        contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!
    let calendar = fixedCalendar(handing: [kateJan20])

    let places = freshFourPlaces()
    try FileManager.default.createDirectory(
        at: places.birthday.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what birthday ticks are written as".utf8).write(to: places.birthday)

    let birthdaySwitch = await onSwitch()
    let screen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOffs,
        keepingBirthdayTicksAt: places.birthday, readingBirthdaysFrom: calendar,
        whileOn: birthdaySwitch)

    #expect(screen.birthdayState == .ticksUnreadable)
    #expect(screen.saysACopyCanBeRestored)

    // The record place is also unreadable: said once and no more (asserted implicitly — there is
    // exactly one flag, `saysACopyCanBeRestored`, and it is already `true`).
    let bothPlaces = freshFourPlaces()
    try FileManager.default.createDirectory(
        at: bothPlaces.birthday.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what birthday ticks are written as".utf8).write(to: bothPlaces.birthday)
    try Data("not a record".utf8).write(to: bothPlaces.record)
    let bothSwitch = await onSwitch()
    let bothScreen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: bothPlaces.record,
        keepingRosterAt: bothPlaces.roster, keepingOneOffsAt: bothPlaces.oneOffs,
        keepingBirthdayTicksAt: bothPlaces.birthday, readingBirthdaysFrom: calendar,
        whileOn: bothSwitch)
    #expect(bothScreen.saysACopyCanBeRestored)

    // Birthdays off: says nothing about restoring a copy.
    let offPlaces = freshFourPlaces()
    try FileManager.default.createDirectory(
        at: offPlaces.birthday.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what birthday ticks are written as".utf8).write(to: offPlaces.birthday)
    let offScreen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: offPlaces.record,
        keepingRosterAt: offPlaces.roster, keepingOneOffsAt: offPlaces.oneOffs,
        keepingBirthdayTicksAt: offPlaces.birthday)
    #expect(offScreen.birthdayState == .off)
    #expect(!offScreen.saysACopyCanBeRestored)

    // The calendar cannot be read: says nothing about restoring a copy. Opened the same way as
    // the cases above — its birthday place also a run of bytes that is not what birthday ticks
    // are written as (G7 review finding 3).
    let unreadableCalendarPlaces = freshFourPlaces()
    try FileManager.default.createDirectory(
        at: unreadableCalendarPlaces.birthday.deletingLastPathComponent(),
        withIntermediateDirectories: true)
    try Data("not what birthday ticks are written as".utf8).write(to: unreadableCalendarPlaces.birthday)
    let throwingCalendar = fixedThrowingCalendar()
    let throwingSwitch = await onSwitch()
    let unreadableCalendarScreen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: unreadableCalendarPlaces.record,
        keepingRosterAt: unreadableCalendarPlaces.roster,
        keepingOneOffsAt: unreadableCalendarPlaces.oneOffs,
        keepingBirthdayTicksAt: unreadableCalendarPlaces.birthday,
        readingBirthdaysFrom: throwingCalendar, whileOn: throwingSwitch)
    #expect(unreadableCalendarScreen.birthdayState == .calendarUnreadable)
    #expect(!unreadableCalendarScreen.saysACopyCanBeRestored)

    // The birthday place holds birthday ticks written in a form one later than this app writes.
    let laterPlaces = freshFourPlaces()
    try FileManager.default.createDirectory(
        at: laterPlaces.birthday.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"version": \#(BirthdayDocument.currentVersion + 1), "ticks": []}"#.utf8)
        .write(to: laterPlaces.birthday)
    let laterSwitch = await onSwitch()
    let laterScreen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: laterPlaces.record,
        keepingRosterAt: laterPlaces.roster, keepingOneOffsAt: laterPlaces.oneOffs,
        keepingBirthdayTicksAt: laterPlaces.birthday, readingBirthdaysFrom: calendar,
        whileOn: laterSwitch)
    #expect(laterScreen.birthdayState == .ticksWrittenByALaterVersion)
    #expect(!laterScreen.saysACopyCanBeRestored)
}
