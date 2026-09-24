import Foundation
import Testing

@testable import DayByDayKit

/// A fake calendar: `handed` is what `reading` answers, `shouldThrow` makes every ask fail, and
/// `asks` counts and records each span it was asked for — a test fills it, fails it and counts
/// its asks. Mirrors `BirthdaySwitchTests.swift`'s own `FakePhone`.
@MainActor
private final class FakeCalendar {
    var handed: [Birthday]
    var shouldThrow: Bool

    private(set) var asks: [(first: CalendarDate, last: CalendarDate)] = []

    init(handing handed: [Birthday] = [], shouldThrow: Bool = false) {
        self.handed = handed
        self.shouldThrow = shouldThrow
    }

    func read(first: CalendarDate, last: CalendarDate) throws -> [Birthday] {
        asks.append((first, last))
        guard !shouldThrow else {
            throw Failure.cannotRead
        }
        return handed
    }

    enum Failure: Error, Equatable {
        case cannotRead
    }
}

/// A `BirthdayCalendar` reading `fake`, collating by plain `<` unless `collatingWith` says
/// otherwise — most scenarios below hold at most one birthday a day, where no collation is ever
/// consulted, so the default is never exercised except by the ordering scenario, which supplies
/// its own.
@MainActor
private func fakeCalendar(
    _ fake: FakeCalendar, collatingWith collate: @escaping (String, String) -> Bool = { $0 < $1 }
) -> BirthdayCalendar {
    BirthdayCalendar(reading: { first, last in try fake.read(first: first, last: last) },
        collating: collate)
}

/// A fresh place for a birthday switch to keep its own state at, mirroring
/// `BirthdaySwitchTests.swift`'s own `freshSwitchPlace()`.
private func freshSwitchPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("birthday-switch.json")
}

/// A birthday switch that reads `access` whenever asked, and asks nothing of its own — a test
/// turns it on or off directly, and the phone's access never changes mid-test unless the test
/// itself mutates `access` on the object this closure captures.
@MainActor
private final class ControllablePhone {
    var access: CalendarAccess
    init(access: CalendarAccess) { self.access = access }
}

@MainActor
private func birthdaySwitch(readingAccessOf phone: ControllablePhone) -> BirthdaySwitch {
    BirthdaySwitch(
        at: freshSwitchPlace(), readingAccess: { phone.access }, askingForAccess: {})
}

/// A birthday switch already on, its phone always giving full access. `design.md`'s scenarios
/// mostly need nothing more controllable than this.
@MainActor
private func onSwitch() async -> BirthdaySwitch {
    let phone = ControllablePhone(access: .full)
    let switchUnderTest = birthdaySwitch(readingAccessOf: phone)
    await switchUnderTest.turnOn()
    return switchUnderTest
}

/// A birthday switch that is off — the phone was never asked, exactly as `BirthdaySwitchTests
/// .swift`'s own `.notAsked` fixture opens.
@MainActor
private func offSwitch() -> BirthdaySwitch {
    let phone = ControllablePhone(access: .notAsked)
    return birthdaySwitch(readingAccessOf: phone)
}

/// Three ordinary places, plus a birthday place beneath an existing ordinary file so nothing can
/// be written there — `RecordStore.write`'s own `.cannotWrite`, mirrored here for
/// `BirthdayStore.write`. Mirrors `DayScreenTests.swift`'s own `blockerPlaces()`.
private func placesWithAnUnwritableBirthdayPlace() throws -> (
    record: URL, roster: URL, oneOff: URL, birthday: URL
) {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    return (
        directory.appendingPathComponent("record.json"),
        directory.appendingPathComponent("roster.json"),
        directory.appendingPathComponent("one-offs.json"),
        blocker.appendingPathComponent("birthday-ticks.json")
    )
}

/// Four fresh places under one fresh temporary directory — a record, a roster, a one-off and a
/// birthday-ticks file, none of which exists until something writes to it — so every scenario's
/// "four places where nothing has been kept" is independent and needs no teardown. Mirrors
/// `DayScreenTests.swift`'s own `freshPlaces()`/`freshOneOffPlace()`, folded into one.
private func freshFourPlaces() -> (record: URL, roster: URL, oneOff: URL, birthday: URL) {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    return (
        directory.appendingPathComponent("record.json"),
        directory.appendingPathComponent("roster.json"),
        directory.appendingPathComponent("one-offs.json"),
        directory.appendingPathComponent("birthday-ticks.json")
    )
}

/// A fresh pair of places under one fresh temporary directory where the record cannot be
/// written, the birthday place normal: a blocker ordinary file, not a directory, sits beneath
/// the record path, so any write through it fails. Mirrors `DayScreenTests.swift`'s own
/// `blockerPlaces()`, widened to this file's four places.
private func placesWithAnUnwritableRecordPlace() throws -> (
    record: URL, roster: URL, oneOff: URL, birthday: URL
) {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    return (
        blocker.appendingPathComponent("record.json"),
        directory.appendingPathComponent("roster.json"),
        directory.appendingPathComponent("one-offs.json"),
        directory.appendingPathComponent("birthday-ticks.json")
    )
}

/// Four places under one fresh temporary directory where neither the record nor the birthday
/// place can be written — each its own blocker ordinary file, not a directory, so a write
/// through either fails — and the roster and one-off places are ordinary, writable places.
private func placesWithUnwritableRecordAndBirthday() throws -> (
    record: URL, roster: URL, oneOff: URL, birthday: URL
) {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let recordBlocker = directory.appendingPathComponent("record-blocker")
    try Data().write(to: recordBlocker)
    let birthdayBlocker = directory.appendingPathComponent("birthday-blocker")
    try Data().write(to: birthdayBlocker)
    return (
        recordBlocker.appendingPathComponent("record.json"),
        directory.appendingPathComponent("roster.json"),
        directory.appendingPathComponent("one-offs.json"),
        birthdayBlocker.appendingPathComponent("birthday-ticks.json")
    )
}

/// A fresh path for a one-off place nothing has been kept at, under its own fresh temporary
/// directory. Mirrors `DayScreenTests.swift`'s own `freshOneOffPlace()`, file-scoped there.
private func freshOneOffPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("one-offs.json")
}

/// Makes `directory` read-only, so a file already inside it still reads but a write inside it
/// fails. Mirrors `DayScreenTests.swift`'s own `makeReadOnly(_:)`, file-scoped there. Every
/// caller must pair this with `makeWritable(_:)` before returning, including on its failure
/// path.
private func makeReadOnly(_ directory: URL) throws {
    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
}

/// Undoes `makeReadOnly(_:)`, restoring `directory` to a place that can be written to again.
private func makeWritable(_ directory: URL) throws {
    try FileManager.default.setAttributes([.posixPermissions: 0o700], ofItemAtPath: directory.path)
}

@MainActor
@Test(
    "a day screen with birthdays on draws the birthdays falling on its day in a group headed Birthdays"
)
func aDayScreenWithBirthdaysOnDrawsTheBirthdaysFallingOnItsDayInAGroupHeadedBirthdays() async {
    let places = freshFourPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let january21 = CalendarDate(year: 2026, month: 1, day: 21)!
    let kate = Birthday(
        contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!
    let john = Birthday(
        contact: "john", words: "John Appleseed's 46th Birthday", day: january21)!
    let calendar = FakeCalendar(handing: [kate, john])
    let birthdaySwitch = await onSwitch()

    let screen = DayScreen(
        startingFrom: [journaling], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOff,
        keepingBirthdayTicksAt: places.birthday, readingBirthdaysFrom: fakeCalendar(calendar),
        whileOn: birthdaySwitch)

    #expect(screen.dayView.birthdayGroup?.heading == "Birthdays")
    #expect(screen.dayView.birthdayGroup?.rows.map(\.words) == ["Kate Bell's 48th Birthday"])
    #expect(screen.dayView.birthdayGroup?.rows.map(\.isTicked) == [false])

    #expect(screen.dayView.groups.count == 1)
    #expect(screen.dayView.groups[0].category == nil)
    #expect(screen.dayView.groups[0].rows.map(\.name) == ["Journaling"])

    #expect(
        screen.nextDayView?.birthdayGroup?.rows.map(\.words) == ["John Appleseed's 46th Birthday"]
    )
    #expect(screen.previousDayView?.birthdayGroup == nil)
}

@MainActor
@Test(
    "a birthday row says the calendar's words exactly, and empty words make a row that says nothing and still ticks"
)
func aBirthdayRowSaysTheCalendarsWordsExactlyAndEmptyWordsMakeARowThatSaysNothingAndStillTicks()
    async throws
{
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let emptyPlaces = freshFourPlaces()
    let kateEmpty = Birthday(contact: "kate", words: "", day: january20)!
    let emptyCalendar = FakeCalendar(handing: [kateEmpty])

    let emptyScreen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: emptyPlaces.record,
        keepingRosterAt: emptyPlaces.roster, keepingOneOffsAt: emptyPlaces.oneOff,
        keepingBirthdayTicksAt: emptyPlaces.birthday,
        readingBirthdaysFrom: fakeCalendar(emptyCalendar), whileOn: await onSwitch())
    try emptyScreen.tick(emptyScreen.dayView.birthdayGroup!.rows[0])

    #expect(emptyScreen.dayView.birthdayGroup?.rows.map(\.words) == [""])
    #expect(emptyScreen.dayView.birthdayGroup?.rows.map(\.isTicked) == [true])

    let paddedPlaces = freshFourPlaces()
    let katePadded = Birthday(
        contact: "kate", words: " Kate Bell's 48th Birthday ", day: january20)!
    let paddedCalendar = FakeCalendar(handing: [katePadded])

    let paddedScreen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: paddedPlaces.record,
        keepingRosterAt: paddedPlaces.roster, keepingOneOffsAt: paddedPlaces.oneOff,
        keepingBirthdayTicksAt: paddedPlaces.birthday,
        readingBirthdaysFrom: fakeCalendar(paddedCalendar), whileOn: await onSwitch())

    #expect(paddedScreen.dayView.birthdayGroup?.rows.map(\.words) == [" Kate Bell's 48th Birthday "])
}

@MainActor
@Test("a birthday row offers its tick on its day and on any day after it, and none before")
func aBirthdayRowOffersItsTickOnItsDayAndOnAnyDayAfterItAndNoneBefore() async {
    let places = freshFourPlaces()
    let january19 = CalendarDate(year: 2026, month: 1, day: 19)!
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let january21 = CalendarDate(year: 2026, month: 1, day: 21)!
    let january20TenYearsLater = CalendarDate(year: 2036, month: 1, day: 20)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!
    let john = Birthday(contact: "john", words: "John Appleseed's 46th Birthday", day: january21)!
    let calendar = FakeCalendar(handing: [kate, john])

    let screen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOff,
        keepingBirthdayTicksAt: places.birthday, readingBirthdaysFrom: fakeCalendar(calendar),
        whileOn: await onSwitch())
    let row = screen.dayView.birthdayGroup!.rows[0]

    #expect(row.offersTick(asOf: january20))
    #expect(row.offersTick(asOf: january20TenYearsLater))
    #expect(!row.offersTick(asOf: january19))

    let nextRow = screen.nextDayView!.birthdayGroup!.rows[0]
    #expect(!nextRow.offersTick(asOf: january20))
    #expect(nextRow.offersTick(asOf: january21))
}

@MainActor
@Test("two birthday rows are the same row exactly when their birthdays and their ticks agree")
func twoBirthdayRowsAreTheSameRowExactlyWhenTheirBirthdaysAndTheirTicksAgree() async throws {
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!

    let firstPlaces = freshFourPlaces()
    let firstScreen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: firstPlaces.record,
        keepingRosterAt: firstPlaces.roster, keepingOneOffsAt: firstPlaces.oneOff,
        keepingBirthdayTicksAt: firstPlaces.birthday,
        readingBirthdaysFrom: fakeCalendar(FakeCalendar(handing: [kate])),
        whileOn: await onSwitch())

    let secondPlaces = freshFourPlaces()
    let secondScreen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: secondPlaces.record,
        keepingRosterAt: secondPlaces.roster, keepingOneOffsAt: secondPlaces.oneOff,
        keepingBirthdayTicksAt: secondPlaces.birthday,
        readingBirthdaysFrom: fakeCalendar(FakeCalendar(handing: [kate])),
        whileOn: await onSwitch())

    #expect(firstScreen.dayView.birthdayGroup!.rows[0] == secondScreen.dayView.birthdayGroup!.rows[0])
    #expect(firstScreen.dayView == secondScreen.dayView)

    try secondScreen.tick(secondScreen.dayView.birthdayGroup!.rows[0])

    #expect(firstScreen.dayView.birthdayGroup!.rows[0] != secondScreen.dayView.birthdayGroup!.rows[0])
    #expect(firstScreen.dayView != secondScreen.dayView)

    let kateSmith = Birthday(contact: "kate", words: "Kate Smith's 48th Birthday", day: january20)!
    let thirdPlaces = freshFourPlaces()
    let thirdScreen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: thirdPlaces.record,
        keepingRosterAt: thirdPlaces.roster, keepingOneOffsAt: thirdPlaces.oneOff,
        keepingBirthdayTicksAt: thirdPlaces.birthday,
        readingBirthdaysFrom: fakeCalendar(FakeCalendar(handing: [kateSmith])),
        whileOn: await onSwitch())

    #expect(thirdScreen.dayView.birthdayGroup!.rows[0] != firstScreen.dayView.birthdayGroup!.rows[0])
}

/// Alphabetical order with capitals and small letters alike — case-insensitive `<` — the
/// collation scenario 3.5 hands its calendar.
private func caseInsensitiveBefore(_ words: String, _ before: String) -> Bool {
    words.lowercased() < before.lowercased()
}

@MainActor
@Test(
    "a day's birthdays are drawn in the order their words are collated in, whatever order the calendar hands them"
)
func aDaysBirthdaysAreDrawnInTheOrderTheirWordsAreCollatedInWhateverOrderTheCalendarHandsThem()
    async throws
{
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let zoe = Birthday(contact: "zoe", words: "Zoe Adams's Birthday", day: january20)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!
    let anna = Birthday(contact: "anna", words: "anna Haro's Birthday", day: january20)!

    let places = freshFourPlaces()
    let calendar = FakeCalendar(handing: [zoe, kate, anna])
    let screen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOff,
        keepingBirthdayTicksAt: places.birthday,
        readingBirthdaysFrom: fakeCalendar(calendar, collatingWith: caseInsensitiveBefore),
        whileOn: await onSwitch())

    #expect(
        screen.dayView.birthdayGroup?.rows.map(\.words) == [
            "anna Haro's Birthday", "Kate Bell's 48th Birthday", "Zoe Adams's Birthday",
        ])

    let reversePlaces = freshFourPlaces()
    let reverseCalendar = FakeCalendar(handing: [zoe, kate, anna])
    let reverseScreen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: reversePlaces.record,
        keepingRosterAt: reversePlaces.roster, keepingOneOffsAt: reversePlaces.oneOff,
        keepingBirthdayTicksAt: reversePlaces.birthday,
        readingBirthdaysFrom: fakeCalendar(
            reverseCalendar, collatingWith: { words, before in caseInsensitiveBefore(before, words) }
        ), whileOn: await onSwitch())

    #expect(
        reverseScreen.dayView.birthdayGroup?.rows.map(\.words) == [
            "Zoe Adams's Birthday", "Kate Bell's 48th Birthday", "anna Haro's Birthday",
        ])

    let sam2 = Birthday(contact: "sam-2", words: "Sam's Birthday", day: january20)!
    let sam1 = Birthday(contact: "sam-1", words: "Sam's Birthday", day: january20)!
    let tiePlaces = freshFourPlaces()
    let tieCalendar = FakeCalendar(handing: [sam2, sam1])
    let tieScreen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: tiePlaces.record,
        keepingRosterAt: tiePlaces.roster, keepingOneOffsAt: tiePlaces.oneOff,
        keepingBirthdayTicksAt: tiePlaces.birthday,
        readingBirthdaysFrom: fakeCalendar(tieCalendar, collatingWith: caseInsensitiveBefore),
        whileOn: await onSwitch())

    try tieScreen.tick(tieScreen.dayView.birthdayGroup!.rows[0])
    let tickedStore = try BirthdayStore(at: tiePlaces.birthday)
    #expect(tickedStore.ticks.isTicked(sam1))
    #expect(!tickedStore.ticks.isTicked(sam2))
}

@MainActor
@Test("a day screen with birthdays off asks the calendar nothing and draws no Birthdays group")
func aDayScreenWithBirthdaysOffAsksTheCalendarNothingAndDrawsNoBirthdaysGroup() async throws {
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!

    let places = freshFourPlaces()
    try FileManager.default.createDirectory(
        at: places.birthday.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what birthday ticks are written as".utf8).write(to: places.birthday)
    let calendar = FakeCalendar(handing: [kate])

    let screen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOff,
        keepingBirthdayTicksAt: places.birthday, readingBirthdaysFrom: fakeCalendar(calendar),
        whileOn: offSwitch())

    #expect(screen.dayView.birthdayGroup == nil)
    #expect(screen.previousDayView?.birthdayGroup == nil)
    #expect(screen.nextDayView?.birthdayGroup == nil)
    #expect(screen.birthdayState == .off)
    #expect(calendar.asks.isEmpty)

    let switchOnlyPlaces = freshFourPlaces()
    let switchOnlyScreen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: switchOnlyPlaces.record,
        keepingRosterAt: switchOnlyPlaces.roster, keepingOneOffsAt: switchOnlyPlaces.oneOff,
        keepingBirthdayTicksAt: switchOnlyPlaces.birthday, readingBirthdaysFrom: nil,
        whileOn: await onSwitch())
    #expect(switchOnlyScreen.birthdayState == .off)

    let calendarOnlyPlaces = freshFourPlaces()
    let calendarOnlyScreen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: calendarOnlyPlaces.record,
        keepingRosterAt: calendarOnlyPlaces.roster, keepingOneOffsAt: calendarOnlyPlaces.oneOff,
        keepingBirthdayTicksAt: calendarOnlyPlaces.birthday,
        readingBirthdaysFrom: fakeCalendar(FakeCalendar(handing: [kate])), whileOn: nil)
    #expect(calendarOnlyScreen.birthdayState == .off)
}

@MainActor
@Test("a birthday switch turned on while a day screen is left is followed when it is returned to")
func aBirthdaySwitchTurnedOnWhileADayScreenIsLeftIsFollowedWhenItIsReturnedTo() async {
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!
    let calendar = FakeCalendar(handing: [kate])
    let phone = ControllablePhone(access: .full)
    let theSwitch = birthdaySwitch(readingAccessOf: phone)

    let places = freshFourPlaces()
    let screen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOff,
        keepingBirthdayTicksAt: places.birthday, readingBirthdaysFrom: fakeCalendar(calendar),
        whileOn: theSwitch)
    #expect(screen.dayView.birthdayGroup == nil)

    await theSwitch.turnOn()
    screen.returnedTo()

    #expect(screen.dayView.birthdayGroup?.rows.map(\.words) == ["Kate Bell's 48th Birthday"])
    #expect(screen.birthdayState == .on)

    theSwitch.turnOff()
    screen.returnedTo()

    #expect(screen.dayView.birthdayGroup == nil)
    #expect(screen.birthdayState == .off)
}

@MainActor
@Test(
    "a day screen shown again after the phone withdraws calendar access says birthdays are off and asks the calendar nothing"
)
func aDayScreenShownAgainAfterThePhoneWithdrawsCalendarAccessSaysBirthdaysAreOffAndAsksTheCalendarNothing()
    async
{
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!
    let calendar = FakeCalendar(handing: [kate])
    let phone = ControllablePhone(access: .full)
    let theSwitch = birthdaySwitch(readingAccessOf: phone)
    await theSwitch.turnOn()

    let places = freshFourPlaces()
    let screen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOff,
        keepingBirthdayTicksAt: places.birthday, readingBirthdaysFrom: fakeCalendar(calendar),
        whileOn: theSwitch)
    #expect(screen.dayView.birthdayGroup?.rows.map(\.words) == ["Kate Bell's 48th Birthday"])
    #expect(calendar.asks.count == 1)

    phone.access = .denied
    screen.shown(asOf: january20)

    #expect(screen.dayView.birthdayGroup == nil)
    // "does not say birthdays could not be read": `.off` is the answer, never `.calendarUnreadable`.
    #expect(screen.birthdayState == .off)
    #expect(!theSwitch.isOn)
    #expect(calendar.asks.count == 1)
}

@MainActor
@Test(
    "a day screen asks the calendar once for the day it shows and the day either side, and never to say either"
)
func aDayScreenAsksTheCalendarOnceForTheDayItShowsAndTheDayEitherSideAndNeverToSayEither() async {
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let january23 = CalendarDate(year: 2026, month: 1, day: 23)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: january23)!
    let calendar = FakeCalendar(handing: [kate])

    let places = freshFourPlaces()
    let screen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOff,
        keepingBirthdayTicksAt: places.birthday, readingBirthdaysFrom: fakeCalendar(calendar),
        whileOn: await onSwitch())

    _ = screen.previousDayView
    _ = screen.nextDayView
    screen.showNextDay()

    #expect(calendar.asks.count == 2)
    let january19 = CalendarDate(year: 2026, month: 1, day: 19)!
    let january21 = CalendarDate(year: 2026, month: 1, day: 21)!
    let january22 = CalendarDate(year: 2026, month: 1, day: 22)!
    #expect(calendar.asks[0].first == january19)
    #expect(calendar.asks[0].last == january21)
    #expect(calendar.asks[1].first == january20)
    #expect(calendar.asks[1].last == january22)

    #expect(screen.dayView.birthdayGroup == nil)
    #expect(screen.nextDayView?.birthdayGroup == nil)

    let lastSupported = CalendarDate(year: 9999, month: 12, day: 31)!
    let lastSupportedPlaces = freshFourPlaces()
    let lastSupportedCalendar = FakeCalendar()
    _ = DayScreen(
        startingFrom: [], asOf: lastSupported, keepingRecordAt: lastSupportedPlaces.record,
        keepingRosterAt: lastSupportedPlaces.roster, keepingOneOffsAt: lastSupportedPlaces.oneOff,
        keepingBirthdayTicksAt: lastSupportedPlaces.birthday,
        readingBirthdaysFrom: fakeCalendar(lastSupportedCalendar), whileOn: await onSwitch())

    #expect(lastSupportedCalendar.asks.count == 1)
    #expect(lastSupportedCalendar.asks[0].first == CalendarDate(year: 9999, month: 12, day: 30)!)
    #expect(lastSupportedCalendar.asks[0].last == lastSupported)

    let firstSupported = CalendarDate(year: 1583, month: 1, day: 1)!
    let firstSupportedPlaces = freshFourPlaces()
    let firstSupportedCalendar = FakeCalendar()
    _ = DayScreen(
        startingFrom: [], asOf: firstSupported, keepingRecordAt: firstSupportedPlaces.record,
        keepingRosterAt: firstSupportedPlaces.roster,
        keepingOneOffsAt: firstSupportedPlaces.oneOff,
        keepingBirthdayTicksAt: firstSupportedPlaces.birthday,
        readingBirthdaysFrom: fakeCalendar(firstSupportedCalendar), whileOn: await onSwitch())

    #expect(firstSupportedCalendar.asks.count == 1)
    #expect(firstSupportedCalendar.asks[0].first == firstSupported)
    #expect(firstSupportedCalendar.asks[0].last == CalendarDate(year: 1583, month: 1, day: 2)!)
}

@MainActor
@Test("a day screen whose calendar cannot be read draws no Birthdays group and says birthdays could not be read")
func aDayScreenWhoseCalendarCannotBeReadDrawsNoBirthdaysGroupAndSaysBirthdaysCouldNotBeRead() async throws {
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!

    let places = freshFourPlaces()
    try FileManager.default.createDirectory(
        at: places.birthday.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what birthday ticks are written as".utf8).write(to: places.birthday)
    let calendar = FakeCalendar(shouldThrow: true)

    let screen = DayScreen(
        startingFrom: [journaling], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOff,
        keepingBirthdayTicksAt: places.birthday, readingBirthdaysFrom: fakeCalendar(calendar),
        whileOn: await onSwitch())

    #expect(screen.dayView.rows.map(\.name) == ["Journaling"])
    #expect(screen.dayView.birthdayGroup == nil)
    #expect(screen.previousDayView?.birthdayGroup == nil)
    #expect(screen.nextDayView?.birthdayGroup == nil)
    #expect(screen.birthdayState == .calendarUnreadable)
    #expect(screen.recordState == .kept)
    #expect(screen.rosterState == .kept)
    #expect(screen.oneOffState == .kept)

    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!
    calendar.shouldThrow = false
    calendar.handed = [kate]
    screen.returnedTo()

    #expect(screen.dayView.birthdayGroup?.rows.map(\.words) == ["Kate Bell's 48th Birthday"])
    #expect(screen.birthdayState == .ticksUnreadable)
}

@MainActor
@Test(
    "the place a day screen keeps its birthday ticks is a file of the app's own under Application Support, the same every time"
)
func thePlaceADayScreenKeepsItsBirthdayTicksIsAFileOfTheAppsOwnUnderApplicationSupportTheSameEveryTime() {
    let first = DayScreen.birthdayPlace
    let second = DayScreen.birthdayPlace
    #expect(first == second)

    let applicationSupport = FileManager.default.urls(
        for: .applicationSupportDirectory, in: .userDomainMask)[0]
    #expect(first.path.hasPrefix(applicationSupport.path))
    let containingDirectory = first.deletingLastPathComponent()
    #expect(containingDirectory != applicationSupport)
    #expect(containingDirectory.path.hasPrefix(applicationSupport.path))

    let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    let temporary = FileManager.default.temporaryDirectory
    #expect(!first.path.hasPrefix(caches.path))
    #expect(!first.path.hasPrefix(temporary.path))
}

@MainActor
@Test("the place a day screen keeps its birthday ticks is none of its other places")
func thePlaceADayScreenKeepsItsBirthdayTicksIsNoneOfItsOtherPlaces() {
    let places: Set<URL> = [
        DayScreen.birthdayPlace, DayScreen.recordPlace, DayScreen.rosterPlace,
        DayScreen.oneOffPlace, BirthdaySwitch.place,
    ]
    #expect(places.count == 5)
}

@MainActor
@Test(
    "a day screen reads its birthday place again when shown and not when returned to or moved"
)
func aDayScreenReadsItsBirthdayPlaceAgainWhenShownAndNotWhenReturnedToOrMoved() async throws {
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!
    let calendar = FakeCalendar(handing: [kate])

    let places = freshFourPlaces()
    let screen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOff,
        keepingBirthdayTicksAt: places.birthday, readingBirthdaysFrom: fakeCalendar(calendar),
        whileOn: await onSwitch())
    #expect(screen.dayView.birthdayGroup?.rows.map(\.isTicked) == [false])

    try BirthdayStore(at: places.birthday).tick(kate)

    screen.returnedTo()
    #expect(screen.dayView.birthdayGroup?.rows.map(\.isTicked) == [false])

    screen.showNextDay()
    screen.showPreviousDay()
    #expect(screen.dayView.birthdayGroup?.rows.map(\.isTicked) == [false])

    screen.shown(asOf: january20)
    #expect(screen.dayView.birthdayGroup?.rows.map(\.isTicked) == [true])

    let neverTickedPlaces = freshFourPlaces()
    _ = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: neverTickedPlaces.record,
        keepingRosterAt: neverTickedPlaces.roster, keepingOneOffsAt: neverTickedPlaces.oneOff,
        keepingBirthdayTicksAt: neverTickedPlaces.birthday,
        readingBirthdaysFrom: fakeCalendar(FakeCalendar(handing: [kate])), whileOn: await onSwitch())
    #expect(!FileManager.default.fileExists(atPath: neverTickedPlaces.birthday.path))
}

@MainActor
@Test(
    "a day screen whose birthday place cannot be read draws its birthdays unticked and keeps no tick"
)
func aDayScreenWhoseBirthdayPlaceCannotBeReadDrawsItsBirthdaysUntickedAndKeepsNoTick() async throws
{
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!

    let places = freshFourPlaces()
    try FileManager.default.createDirectory(
        at: places.birthday.deletingLastPathComponent(), withIntermediateDirectories: true)
    let garbage = Data("not what birthday ticks are written as".utf8)
    try garbage.write(to: places.birthday)

    let screen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOff,
        keepingBirthdayTicksAt: places.birthday,
        readingBirthdaysFrom: fakeCalendar(FakeCalendar(handing: [kate])),
        whileOn: await onSwitch())

    try screen.tick(screen.dayView.birthdayGroup!.rows[0])

    #expect(screen.notice == nil)
    #expect(screen.dayView.birthdayGroup?.rows.map(\.words) == ["Kate Bell's 48th Birthday"])
    #expect(screen.dayView.birthdayGroup?.rows.map(\.isTicked) == [false])
    #expect(screen.birthdayState == .ticksUnreadable)
    #expect(screen.recordState == .kept)
    #expect(screen.rosterState == .kept)
    #expect(screen.oneOffState == .kept)
    #expect(try Data(contentsOf: places.birthday) == garbage)

    let directoryPlaces = freshFourPlaces()
    try FileManager.default.createDirectory(
        at: directoryPlaces.birthday, withIntermediateDirectories: true)
    let directoryScreen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: directoryPlaces.record,
        keepingRosterAt: directoryPlaces.roster, keepingOneOffsAt: directoryPlaces.oneOff,
        keepingBirthdayTicksAt: directoryPlaces.birthday,
        readingBirthdaysFrom: fakeCalendar(FakeCalendar(handing: [kate])),
        whileOn: await onSwitch())
    #expect(directoryScreen.birthdayState == .ticksUnreadable)
    var isDirectory: ObjCBool = false
    #expect(
        FileManager.default.fileExists(atPath: directoryPlaces.birthday.path, isDirectory: &isDirectory)
    )
    #expect(isDirectory.boolValue)
    #expect(
        try FileManager.default.contentsOfDirectory(atPath: directoryPlaces.birthday.path).isEmpty)
}

@MainActor
@Test(
    "birthday ticks written in a later form make a day screen that says they are from a later version"
)
func birthdayTicksWrittenInALaterFormMakeADayScreenThatSaysTheyAreFromALaterVersion() async throws {
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!

    let places = freshFourPlaces()
    try FileManager.default.createDirectory(
        at: places.birthday.deletingLastPathComponent(), withIntermediateDirectories: true)
    let laterForm = Data(#"{"version": 2, "ticks": []}"#.utf8)
    try laterForm.write(to: places.birthday)

    let screen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOff,
        keepingBirthdayTicksAt: places.birthday,
        readingBirthdaysFrom: fakeCalendar(FakeCalendar(handing: [kate])), whileOn: await onSwitch())

    #expect(screen.birthdayState == .ticksWrittenByALaterVersion)
    #expect(screen.dayView.birthdayGroup?.rows.map(\.isTicked) == [false])
    #expect(try Data(contentsOf: places.birthday) == laterForm)
}

@MainActor
@Test("ticking a birthday row keeps its tick, and ticking it again takes the tick back")
func tickingABirthdayRowKeepsItsTickAndTickingItAgainTakesTheTickBack() async throws {
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!

    let places = freshFourPlaces()
    let screen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOff,
        keepingBirthdayTicksAt: places.birthday,
        readingBirthdaysFrom: fakeCalendar(FakeCalendar(handing: [kate])),
        whileOn: await onSwitch())

    try screen.tick(screen.dayView.birthdayGroup!.rows[0])

    #expect(screen.dayView.birthdayGroup?.rows.map(\.isTicked) == [true])
    #expect(try BirthdayStore(at: places.birthday).ticks.isTicked(kate))
    #expect(!FileManager.default.fileExists(atPath: places.record.path))
    #expect(!FileManager.default.fileExists(atPath: places.roster.path))
    #expect(!FileManager.default.fileExists(atPath: places.oneOff.path))

    try screen.tick(screen.dayView.birthdayGroup!.rows[0])

    #expect(screen.dayView.birthdayGroup?.rows.map(\.isTicked) == [false])
    #expect(!(try BirthdayStore(at: places.birthday).ticks.isTicked(kate)))
}

@MainActor
@Test("a birthday row on a past day is ticked against its own day, not the today")
func aBirthdayRowOnAPastDayIsTickedAgainstItsOwnDayNotTheToday() async throws {
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let august29 = CalendarDate(year: 2025, month: 8, day: 29)!
    let keptFrom = CalendarDate(year: 2020, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let anna = Birthday(contact: "anna", words: "Anna Haro's 40th Birthday", day: august29)!

    let places = freshFourPlaces()
    let screen = DayScreen(
        startingFrom: [journaling], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOff,
        keepingBirthdayTicksAt: places.birthday,
        readingBirthdaysFrom: fakeCalendar(FakeCalendar(handing: [anna])),
        whileOn: await onSwitch())
    screen.showDay(august29)

    try screen.tick(screen.dayView.birthdayGroup!.rows[0])

    #expect(screen.dayView.birthdayGroup?.rows.map(\.isTicked) == [true])

    let store = try BirthdayStore(at: places.birthday)
    #expect(store.ticks.isTicked(anna))
    #expect(!store.ticks.isTicked(Birthday(contact: "anna", words: "", day: january20)!))
}

@MainActor
@Test("a birthday tick that cannot be kept is refused and leaves the day view as it was")
func aBirthdayTickThatCannotBeKeptIsRefusedAndLeavesTheDayViewAsItWas() async throws {
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!
    let places = try placesWithAnUnwritableBirthdayPlace()

    let screen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOff,
        keepingBirthdayTicksAt: places.birthday,
        readingBirthdaysFrom: fakeCalendar(FakeCalendar(handing: [kate])),
        whileOn: await onSwitch())

    #expect(throws: BirthdayStoreError.cannotWrite(at: places.birthday)) {
        try screen.tick(screen.dayView.birthdayGroup!.rows[0])
    }

    #expect(screen.dayView.birthdayGroup?.rows.map(\.isTicked) == [false])
    #expect(!FileManager.default.fileExists(atPath: places.birthday.path))
}

@MainActor
@Test(
    "ticking a birthday row that the day view does not hold or that offers no tick changes nothing"
)
func tickingABirthdayRowThatTheDayViewDoesNotHoldOrThatOffersNoTickChangesNothing() async throws {
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let january21 = CalendarDate(year: 2026, month: 1, day: 21)!
    let john = Birthday(contact: "john", words: "John Appleseed's 46th Birthday", day: january21)!

    let places = freshFourPlaces()
    let screen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOff,
        keepingBirthdayTicksAt: places.birthday,
        readingBirthdaysFrom: fakeCalendar(FakeCalendar(handing: [john])),
        whileOn: await onSwitch())

    let nextDayRow = screen.nextDayView!.birthdayGroup!.rows[0]
    try screen.tick(nextDayRow)

    #expect(screen.notice == nil)
    #expect(screen.dayView.birthdayGroup == nil)
    #expect(!FileManager.default.fileExists(atPath: places.birthday.path))

    screen.showNextDay()
    let ownRow = screen.dayView.birthdayGroup!.rows[0]
    #expect(!ownRow.offersTick(asOf: january20))

    try screen.tick(ownRow)

    #expect(screen.notice == nil)
    #expect(screen.dayView.birthdayGroup?.rows.map(\.isTicked) == [false])
    #expect(!FileManager.default.fileExists(atPath: places.birthday.path))
}

@MainActor
@Test("a refused birthday tick is told on its row and ends what was told on a commitment row")
func aRefusedBirthdayTickIsToldOnItsRowAndEndsWhatWasToldOnACommitmentRow() async throws {
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!

    let places = try placesWithUnwritableRecordAndBirthday()
    let screen = DayScreen(
        startingFrom: [journaling], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOff,
        keepingBirthdayTicksAt: places.birthday,
        readingBirthdaysFrom: fakeCalendar(FakeCalendar(handing: [kate])),
        whileOn: await onSwitch())

    #expect(throws: (any Error).self) {
        try screen.tick(screen.dayView.rows[0])
    }

    let birthdayRow = screen.dayView.birthdayGroup!.rows[0]
    #expect(throws: BirthdayStoreError.cannotWrite(at: places.birthday)) {
        try screen.tick(birthdayRow)
    }

    #expect(screen.notice?.birthdayRow == birthdayRow)
    #expect(screen.notice?.cause == nil)
    #expect(screen.notice?.row == nil)
    #expect(screen.birthdayState == .on)
}

@MainActor
@Test("a refused commitment or one-off tick ends what was told on a birthday row")
func aRefusedCommitmentOrOneOffTickEndsWhatWasToldOnABirthdayRow() async throws {
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!

    let oneOffPlace = freshOneOffPlace()
    let oneOffStore = try OneOffStore(at: oneOffPlace)
    try oneOffStore.add(OneOff(name: "Call mum", date: january20)!)
    let oneOffDirectory = oneOffPlace.deletingLastPathComponent()
    try makeReadOnly(oneOffDirectory)
    defer { try? makeWritable(oneOffDirectory) }

    let places = try placesWithUnwritableRecordAndBirthday()
    let screen = DayScreen(
        startingFrom: [journaling], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: oneOffPlace,
        keepingBirthdayTicksAt: places.birthday,
        readingBirthdaysFrom: fakeCalendar(FakeCalendar(handing: [kate])),
        whileOn: await onSwitch())

    #expect(throws: BirthdayStoreError.cannotWrite(at: places.birthday)) {
        try screen.tick(screen.dayView.birthdayGroup!.rows[0])
    }

    #expect(throws: (any Error).self) {
        try screen.tick(screen.dayView.rows[0])
    }

    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.birthdayRow == nil)

    #expect(throws: BirthdayStoreError.cannotWrite(at: places.birthday)) {
        try screen.tick(screen.dayView.birthdayGroup!.rows[0])
    }

    #expect(throws: (any Error).self) {
        try screen.tick(screen.dayView.oneOffGroup!.rows[0])
    }

    #expect(screen.notice?.oneOffRow == screen.dayView.oneOffGroup?.rows[0])
    #expect(screen.notice?.birthdayRow == nil)
}

@MainActor
@Test(
    "what a day screen tells on a row ends when a birthday tick is kept"
)
func whatADayScreenTellsOnARowEndsWhenABirthdayTickIsKept() async throws {
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!

    let places = try placesWithAnUnwritableRecordPlace()
    let screen = DayScreen(
        startingFrom: [journaling], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOff,
        keepingBirthdayTicksAt: places.birthday,
        readingBirthdaysFrom: fakeCalendar(FakeCalendar(handing: [kate])),
        whileOn: await onSwitch())

    #expect(throws: (any Error).self) {
        try screen.tick(screen.dayView.rows[0])
    }

    try screen.tick(screen.dayView.birthdayGroup!.rows[0])

    #expect(screen.dayView.birthdayGroup?.rows.map(\.isTicked) == [true])
    #expect(screen.notice == nil)
}

@MainActor
@Test("what a day screen tells on a birthday row ends when a commitment tick is kept")
func whatADayScreenTellsOnABirthdayRowEndsWhenACommitmentTickIsKept() async throws {
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!

    let places = try placesWithAnUnwritableBirthdayPlace()
    let screen = DayScreen(
        startingFrom: [journaling], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOff,
        keepingBirthdayTicksAt: places.birthday,
        readingBirthdaysFrom: fakeCalendar(FakeCalendar(handing: [kate])),
        whileOn: await onSwitch())

    #expect(throws: BirthdayStoreError.cannotWrite(at: places.birthday)) {
        try screen.tick(screen.dayView.birthdayGroup!.rows[0])
    }

    try screen.tick(screen.dayView.rows[0])

    #expect(screen.dayView.rows[0].isKept)
    #expect(screen.notice == nil)
}

@MainActor
@Test("a day screen returned to after a restore draws the birthday ticks the copy holds")
func aDayScreenReturnedToAfterARestoreDrawsTheBirthdayTicksTheCopyHolds() async throws {
    let january20 = CalendarDate(year: 2026, month: 1, day: 20)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: january20)!
    let places = freshFourPlaces()
    let calendar = fakeCalendar(FakeCalendar(handing: [kate]))
    let birthdaySwitch = await onSwitch()

    let dayScreen = DayScreen(
        startingFrom: [], asOf: january20, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOff,
        keepingBirthdayTicksAt: places.birthday, readingBirthdaysFrom: calendar,
        whileOn: birthdaySwitch)
    let commitmentsScreen = CommitmentsScreen(
        asOf: january20, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOff, keepingBirthdayTicksAt: places.birthday)

    let copyResult = commitmentsScreen.makeACopy(
        asOf: Moment(on: january20, hour: 14, minute: 32)!,
        writingInto: FileManager.default.temporaryDirectory.appendingPathComponent(
            UUID().uuidString, isDirectory: true))
    guard case .success(let copyURL) = copyResult else {
        Issue.record("expected a copy to be made")
        return
    }

    try dayScreen.tick(dayScreen.dayView.birthdayGroup!.rows.first { $0.birthday == kate }!)

    #expect(commitmentsScreen.askToRestore(from: copyURL) == nil)
    #expect(commitmentsScreen.confirmRestoring() == nil)

    dayScreen.returnedTo(from: commitmentsScreen)

    #expect(dayScreen.dayView.birthdayGroup?.rows.map(\.isTicked) == [false])

    try dayScreen.tick(dayScreen.dayView.birthdayGroup!.rows.first { $0.birthday == kate }!)

    #expect(dayScreen.dayView.birthdayGroup?.rows.map(\.isTicked) == [true])
    #expect(try BirthdayStore(at: places.birthday).ticks.isTicked(kate))
}
