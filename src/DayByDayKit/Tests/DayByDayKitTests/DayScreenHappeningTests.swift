import Foundation
import Testing

@testable import DayByDayKit

private let friday = CalendarDate(year: 2026, month: 10, day: 2)!
private let wednesday = CalendarDate(year: 2026, month: 9, day: 30)!
private let saturday = CalendarDate(year: 2026, month: 10, day: 3)!

/// A fresh directory of its own, not created until something writes into it.
private func freshDirectory() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
}

private func freshHappeningPlace() -> URL {
    freshDirectory().appendingPathComponent("happenings.json")
}

/// A record place and a roster place under one fresh directory.
private func freshRosterAndRecordPlaces() -> (roster: URL, record: URL) {
    let directory = freshDirectory()
    return (
        directory.appendingPathComponent("roster.json"),
        directory.appendingPathComponent("record.json")
    )
}

private func write(_ bytes: Data, at place: URL) throws {
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try bytes.write(to: place)
}

/// Moves `screen` to `day` a day at a time: `showDay` reaches no day before a roster's earliest,
/// and a screen of no commitments at all has none.
@MainActor
private func show(_ day: CalendarDate, on screen: DayScreen) {
    while screen.dayView.date != day {
        let before = screen.dayView.date
        if before.days(until: day) > 0 {
            screen.showNextDay()
        } else {
            screen.showPreviousDay()
        }
    }
}

/// Happenings made in order at `place`, answered in the order made.
@discardableResult
private func makeHappenings(_ names: [String], at place: URL) throws -> [Happening] {
    let store = try HappeningStore(at: place)
    return try names.map { name in
        let happening = try #require(Happening(name: name))
        try store.add(happening)
        return happening
    }
}

private func moment(_ day: CalendarDate, _ hour: Int, _ minute: Int) -> Moment {
    Moment(on: day, hour: hour, minute: minute)!
}

private func time(_ hour: Int, _ minute: Int) -> TimeOfDay {
    TimeOfDay(hour: hour, minute: minute)!
}

/// A day screen of no commitments at all as of `today`, its happening place `happeningPlace`
/// and everything else under a directory of its own.
@MainActor
private func dayScreen(
    asOf today: CalendarDate = friday, keepingHappeningsAt happeningPlace: URL
) -> DayScreen {
    let places = freshRosterAndRecordPlaces()
    return DayScreen(
        startingFrom: [], asOf: today, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.roster.deletingLastPathComponent().appendingPathComponent(
            "one-offs.json"),
        keepingHappeningsAt: happeningPlace)
}

@MainActor
@Test("a day screen lists the happenings beside its record place in the order they were made")
func aDayScreenListsTheHappeningsBesideItsRecordPlaceInTheOrderTheyWereMade() throws {
    let places = freshRosterAndRecordPlaces()
    let beside = places.record.deletingLastPathComponent()
        .appendingPathComponent("happenings.json")
    try makeHappenings(["Augenmigräne", "Kopfweh"], at: beside)
    let before = try Data(contentsOf: beside)

    let screen = DayScreen(
        startingFrom: [], asOf: friday, keepingRecordAt: places.record, keepingRosterAt: places.roster)

    #expect(screen.happenings.map(\.name) == ["Augenmigräne", "Kopfweh"])
    #expect(screen.happeningState == .kept)
    #expect(try Data(contentsOf: beside) == before)

    let other = freshRosterAndRecordPlaces()
    let bare = DayScreen(
        startingFrom: [], asOf: friday, keepingRecordAt: other.record, keepingRosterAt: other.roster)
    #expect(bare.happenings.isEmpty)
    #expect(bare.happeningState == .kept)
    #expect(
        !FileManager.default.fileExists(
            atPath: other.record.deletingLastPathComponent()
                .appendingPathComponent("happenings.json").path))
}

@MainActor
@Test("a day screen returned to or shown again reads its happening place afresh")
func aDayScreenReturnedToOrShownAgainReadsItsHappeningPlaceAfresh() throws {
    let place = freshHappeningPlace()
    let places = freshRosterAndRecordPlaces()
    let screen = DayScreen(
        startingFrom: [], asOf: friday, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingHappeningsAt: place)
    #expect(screen.happenings.isEmpty)

    let commitments = CommitmentsScreen(
        asOf: friday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: place)
    #expect(commitments.makeHappening(named: "Kopfweh") == nil)
    screen.returnedTo(from: commitments)

    #expect(screen.happenings.map(\.name) == ["Kopfweh"])

    try write(Data("not a happening store".utf8), at: place)
    screen.shown(asOf: friday)

    #expect(screen.happenings.isEmpty)
    #expect(screen.happeningState == .notKept)
}

@MainActor
@Test("a day screen offers noting a happening on today and a past day, and not on a later day")
func aDayScreenOffersNotingAHappeningOnTodayAndAPastDayAndNotOnALaterDay() throws {
    let place = freshHappeningPlace()
    try makeHappenings(["Kopfweh"], at: place)
    let screen = dayScreen(keepingHappeningsAt: place)

    #expect(screen.offersNotingAHappening)

    show(wednesday, on: screen)
    #expect(screen.offersNotingAHappening)

    show(saturday, on: screen)
    #expect(!screen.offersNotingAHappening)
}

@MainActor
@Test("a day screen that lists no happening offers no noting, whatever its other places hold")
func aDayScreenThatListsNoHappeningOffersNoNotingWhateverItsOtherPlacesHold() throws {
    let empty = dayScreen(keepingHappeningsAt: freshHappeningPlace())
    #expect(!empty.offersNotingAHappening)

    let place = freshHappeningPlace()
    try makeHappenings(["Kopfweh"], at: place)
    let places = freshRosterAndRecordPlaces()
    let directory = places.record.deletingLastPathComponent()
    let oneOffPlace = directory.appendingPathComponent("one-offs.json")
    try write(Data("not a record".utf8), at: places.record)
    try write(Data("not one-offs".utf8), at: oneOffPlace)
    let screen = DayScreen(
        startingFrom: [], asOf: friday, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: oneOffPlace, keepingHappeningsAt: place)

    #expect(screen.recordState == .unreadable)
    #expect(screen.oneOffState == .unreadable)
    #expect(screen.offersNotingAHappening)
}

@MainActor
@Test("an occurrence's time starts at now on today and at none on a past day")
func anOccurrencesTimeStartsAtNowOnTodayAndAtNoneOnAPastDay() throws {
    let place = freshHappeningPlace()
    try makeHappenings(["Kopfweh"], at: place)
    let screen = dayScreen(keepingHappeningsAt: place)
    let now = moment(friday, 18, 52)

    #expect(screen.startingTime(asOf: now) == time(18, 52))

    show(wednesday, on: screen)
    #expect(screen.startingTime(asOf: now) == nil)

    let other = dayScreen(keepingHappeningsAt: place)
    #expect(other.startingTime(asOf: moment(saturday, 0, 10)) == nil)
}

@MainActor
@Test("an occurrence noted on today is kept at the happening place and drawn on the day")
func anOccurrenceNotedOnTodayIsKeptAtTheHappeningPlaceAndDrawnOnTheDay() throws {
    let place = freshHappeningPlace()
    let kopfweh = try makeHappenings(["Kopfweh"], at: place)[0]
    let screen = dayScreen(keepingHappeningsAt: place)
    let now = moment(friday, 18, 52)

    let refusal = screen.note(
        kopfweh, at: time(18, 40), saying: "  Hinter dem Auge\nlinks  ", asOf: now)

    #expect(refusal == nil)
    #expect(screen.dayView.happeningRows == [.init(name: "Kopfweh", timesInWords: "18:40")])
    let store = try HappeningStore(at: place)
    #expect(store.happenings.occurrences.count == 1)
    #expect(store.happenings.occurrences[0].happening == kopfweh.identity)
    #expect(store.happenings.occurrences[0].day == friday)
    #expect(store.happenings.occurrences[0].time == time(18, 40))
    #expect(store.happenings.occurrences[0].note == "Hinter dem Auge\nlinks")

    let again = screen.note(kopfweh, at: time(18, 40), saying: "", asOf: now)

    #expect(again == nil)
    #expect(try HappeningStore(at: place).happenings.occurrences.count == 2)
    #expect(screen.dayView.happeningRows == [.init(name: "Kopfweh", timesInWords: "18:40, 18:40")])
}

@MainActor
@Test("an occurrence noted with no time holds its day alone, on a past day and on today")
func anOccurrenceNotedWithNoTimeHoldsItsDayAloneOnAPastDayAndOnToday() throws {
    let place = freshHappeningPlace()
    let kopfweh = try makeHappenings(["Kopfweh"], at: place)[0]
    let screen = dayScreen(keepingHappeningsAt: place)
    let now = moment(friday, 18, 52)
    show(wednesday, on: screen)

    let refusal = screen.note(kopfweh, at: nil, saying: "   ", asOf: now)

    #expect(refusal == nil)
    let occurrences = try HappeningStore(at: place).happenings.occurrences
    #expect(occurrences.count == 1)
    #expect(occurrences[0].day == wednesday)
    #expect(occurrences[0].time == nil)
    #expect(occurrences[0].note == nil)
    #expect(screen.dayView.happeningRows == [.init(name: "Kopfweh", timesInWords: "no time")])

    show(friday, on: screen)
    #expect(screen.note(kopfweh, at: nil, saying: "", asOf: now) == nil)
}

@MainActor
@Test("noting an occurrence writes no copy, leaves the other places as they were and ends a notice")
func notingAnOccurrenceWritesNoCopyLeavesTheOtherPlacesAsTheyWereAndEndsANotice() throws {
    let directory = freshDirectory()
    let rosterPlace = directory.appendingPathComponent("roster.json")
    let recordPlace = directory.appendingPathComponent("record.json")
    let oneOffPlace = directory.appendingPathComponent("one-offs.json")
    let birthdayPlace = directory.appendingPathComponent("birthday-ticks.json")
    let happeningPlace = directory.appendingPathComponent("happenings.json")
    let gym = try #require(
        Commitment(
            name: "Gym",
            schedule: .weekdays([
                .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
            ]),
            keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!))
    try RosterStore(at: rosterPlace).add(gym)
    let kopfweh = try makeHappenings(["Kopfweh"], at: happeningPlace)[0]

    let copyPlace = CopyPlace(
        at: freshDirectory().appendingPathComponent("copy-place.json"),
        keepingRecordAt: recordPlace, keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace,
        keepingBirthdayTicksAt: birthdayPlace,
        asking: laterMinuteEachTime(from: moment(friday, 14, 32)))
    let screen = DayScreen(
        startingFrom: [], asOf: friday, keepingRecordAt: recordPlace, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace, keepingBirthdayTicksAt: birthdayPlace,
        keepingHappeningsAt: happeningPlace, copyingTo: copyPlace)
    copyPlace.set(to: freshDirectory())
    let rosterBytes = try Data(contentsOf: rosterPlace)
    #expect(copyPlace.lastCopy == moment(friday, 14, 32))

    let refusal = screen.note(kopfweh, at: time(14, 0), saying: "", asOf: moment(friday, 14, 40))

    #expect(refusal == nil)
    #expect(copyPlace.lastCopy == moment(friday, 14, 32))
    #expect(try Data(contentsOf: rosterPlace) == rosterBytes)
    #expect(!FileManager.default.fileExists(atPath: recordPlace.path))
    #expect(!FileManager.default.fileExists(atPath: oneOffPlace.path))
    #expect(!FileManager.default.fileExists(atPath: birthdayPlace.path))

    // A notice from a tick refused at a record place nothing can be written at ends on noting.
    let blocked = freshDirectory()
    try FileManager.default.createDirectory(at: blocked, withIntermediateDirectories: true)
    let blocker = blocked.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    let ticking = DayScreen(
        startingFrom: [], asOf: friday, keepingRecordAt: blocker.appendingPathComponent("record.json"),
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace,
        keepingHappeningsAt: happeningPlace)
    let row = try #require(ticking.dayView.rows.first { $0.name == "Gym" })
    #expect(throws: (any Error).self) { try ticking.tick(row) }
    #expect(ticking.notice != nil)

    #expect(ticking.note(kopfweh, at: time(9, 0), saying: "", asOf: moment(friday, 14, 40)) == nil)
    #expect(ticking.notice == nil)
}

@MainActor
@Test("an occurrence at a time later than now, or on a day that has not come, is refused as not yet come")
func anOccurrenceAtATimeLaterThanNowOrOnADayThatHasNotComeIsRefusedAsNotYetCome() throws {
    let place = freshHappeningPlace()
    let kopfweh = try makeHappenings(["Kopfweh"], at: place)[0]
    let screen = dayScreen(keepingHappeningsAt: place)
    let now = moment(friday, 18, 52)

    let refusal = screen.note(kopfweh, at: time(18, 53), saying: "", asOf: now)

    #expect(refusal == .notYetCome)
    #expect(try HappeningStore(at: place).happenings.occurrences.isEmpty)
    #expect(screen.dayView.happeningRows.isEmpty)
    #expect(screen.note(kopfweh, at: time(18, 52), saying: "", asOf: now) == nil)

    show(saturday, on: screen)
    #expect(screen.note(kopfweh, at: nil, saying: "", asOf: now) == .notYetCome)
}

@MainActor
@Test("an occurrence the happening place cannot take is refused as not kept")
func anOccurrenceTheHappeningPlaceCannotTakeIsRefusedAsNotKept() throws {
    let place = freshHappeningPlace()
    let kopfweh = try makeHappenings(["Kopfweh"], at: place)[0]
    let screen = dayScreen(keepingHappeningsAt: place)
    let directory = place.deletingLastPathComponent()
    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
    defer {
        try? FileManager.default.setAttributes(
            [.posixPermissions: 0o700], ofItemAtPath: directory.path)
    }

    let refusal = screen.note(kopfweh, at: time(9, 10), saying: "", asOf: moment(friday, 18, 52))

    #expect(refusal == .notKept)
    #expect(screen.dayView.happeningRows.isEmpty)

    try FileManager.default.setAttributes([.posixPermissions: 0o700], ofItemAtPath: directory.path)
    let stranger = try #require(Happening(name: "Schlecht geschlafen"))
    let kept = try Data(contentsOf: place)
    #expect(
        screen.note(stranger, at: time(9, 10), saying: "", asOf: moment(friday, 18, 52)) == .notKept)
    #expect(try Data(contentsOf: place) == kept)
}

@MainActor
@Test("a happening row says its times earliest first, then each occurrence with no time")
func aHappeningRowSaysItsTimesEarliestFirstThenEachOccurrenceWithNoTime() throws {
    let place = freshHappeningPlace()
    let kopfweh = try makeHappenings(["Kopfweh"], at: place)[0]
    let screen = dayScreen(keepingHappeningsAt: place)
    let now = moment(friday, 18, 52)

    screen.note(kopfweh, at: nil, saying: "", asOf: now)
    screen.note(kopfweh, at: time(18, 40), saying: "", asOf: now)
    screen.note(kopfweh, at: time(9, 10), saying: "", asOf: now)

    #expect(
        screen.dayView.happeningRows == [.init(name: "Kopfweh", timesInWords: "09:10, 18:40, no time")])
}

@MainActor
@Test("a day view holds rows only for the happenings that came, in the order they were made")
func aDayViewHoldsRowsOnlyForTheHappeningsThatCameInTheOrderTheyWereMade() throws {
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Augenmigräne", "Kopfweh", "Schlecht geschlafen"], at: place)
    let screen = dayScreen(keepingHappeningsAt: place)
    let now = moment(friday, 18, 52)

    screen.note(made[1], at: time(9, 10), saying: "", asOf: now)
    screen.note(made[0], at: nil, saying: "", asOf: now)

    #expect(
        screen.dayView.happeningRows == [
            .init(name: "Augenmigräne", timesInWords: "no time"),
            .init(name: "Kopfweh", timesInWords: "09:10"),
        ])
    #expect(screen.previousDayView?.happeningRows.isEmpty == true)
    show(saturday, on: screen)
    #expect(screen.previousDayView?.happeningRows.count == 2)

    let places = freshRosterAndRecordPlaces()
    let commitments = CommitmentsScreen(
        asOf: friday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: place)
    #expect(commitments.rename(made[1], to: "Spannungskopfweh") == nil)
    show(friday, on: screen)
    screen.returnedTo(from: commitments)

    #expect(screen.dayView.happeningRows.map(\.name) == ["Augenmigräne", "Spannungskopfweh"])
}

@MainActor
@Test("a day screen that cannot read its happening place lists none and leaves the place as it was")
func aDayScreenThatCannotReadItsHappeningPlaceListsNoneAndLeavesThePlaceAsItWas() throws {
    let places = freshRosterAndRecordPlaces()
    let gym = try #require(
        Commitment(
            name: "Gym",
            schedule: .weekdays([
                .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
            ]),
            keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!))
    try RosterStore(at: places.roster).add(gym)
    let place = freshHappeningPlace()
    let bytes = Data("not a happening store".utf8)
    try write(bytes, at: place)

    let screen = DayScreen(
        startingFrom: [], asOf: friday, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingHappeningsAt: place)

    #expect(screen.happenings.isEmpty)
    #expect(screen.happeningState == .notKept)
    #expect(!screen.offersNotingAHappening)
    #expect(screen.dayView.rows.map(\.name) == ["Gym"])
    #expect(screen.dayView.happeningRows.isEmpty)
    #expect(screen.recordState == .kept)
    #expect(screen.rosterState == .kept)
    #expect(screen.oneOffState == .kept)
    #expect(!screen.saysACopyCanBeRestored)
    #expect(try Data(contentsOf: place) == bytes)
}

@MainActor
@Test("a happening place written by a later version makes a day screen that says so")
func aHappeningPlaceWrittenByALaterVersionMakesADayScreenThatSaysSo() throws {
    let place = freshHappeningPlace()
    let bytes = Data(#"{"version": \#(HappeningDocument.currentVersion + 1), "happenings": []}"#.utf8)
    try write(bytes, at: place)

    let screen = dayScreen(keepingHappeningsAt: place)

    #expect(screen.happenings.isEmpty)
    #expect(screen.happeningState == .writtenByALaterVersion)
    #expect(!screen.offersNotingAHappening)
    #expect(try Data(contentsOf: place) == bytes)
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
