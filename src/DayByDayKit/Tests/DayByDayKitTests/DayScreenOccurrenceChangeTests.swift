import Foundation
import Testing

@testable import DayByDayKit

private let friday = CalendarDate(year: 2026, month: 10, day: 2)!
private let thursday = CalendarDate(year: 2026, month: 10, day: 1)!
private let wednesday = CalendarDate(year: 2026, month: 9, day: 30)!
private let saturday = CalendarDate(year: 2026, month: 10, day: 3)!

private func freshDirectory() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
}

private func freshHappeningPlace() -> URL {
    freshDirectory().appendingPathComponent("happenings.json")
}

private func moment(_ day: CalendarDate, _ hour: Int, _ minute: Int) -> Moment {
    Moment(on: day, hour: hour, minute: minute)!
}

private func time(_ hour: Int, _ minute: Int) -> TimeOfDay {
    TimeOfDay(hour: hour, minute: minute)!
}

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

@discardableResult
private func makeHappenings(_ names: [String], at place: URL) throws -> [Happening] {
    let store = try HappeningStore(at: place)
    return try names.map { name in
        let happening = try #require(Happening(name: name))
        try store.add(happening)
        return happening
    }
}

/// A day screen of no commitments at all as of `today`, its happening place `happeningPlace`
/// and everything else under a directory of its own.
@MainActor
private func dayScreen(
    asOf today: CalendarDate = friday, keepingHappeningsAt happeningPlace: URL,
    keepingCopiesAt copyPlace: URL? = nil, keepingRosterAt rosterPlace: URL? = nil
) -> DayScreen {
    let directory = freshDirectory()
    return DayScreen(
        startingFrom: [], asOf: today, keepingRecordAt: directory.appendingPathComponent("record.json"),
        keepingRosterAt: rosterPlace ?? directory.appendingPathComponent("roster.json"),
        keepingOneOffsAt: directory.appendingPathComponent("one-offs.json"),
        keepingHappeningsAt: happeningPlace)
}

@MainActor
@Test("a happening row's occurrences are answered in the row's order, each with its time and its note")
func aHappeningRowsOccurrencesAreAnsweredInTheRowsOrderEachWithItsTimeAndItsNote() throws {
    let place = freshHappeningPlace()
    let kopfweh = try makeHappenings(["Kopfweh"], at: place)[0]
    let screen = dayScreen(keepingHappeningsAt: place)
    let now = moment(friday, 18, 52)

    screen.note(kopfweh, at: nil, saying: "Schwindel", asOf: now)
    screen.note(kopfweh, at: time(18, 40), saying: "", asOf: now)
    screen.note(kopfweh, at: time(9, 10), saying: "Hinter dem Auge", asOf: now)
    screen.note(kopfweh, at: time(9, 10), saying: "links", asOf: now)

    let row = try #require(screen.dayView.happeningRows.first)
    let answered = screen.occurrences(of: row)
    #expect(
        answered == [
            Occurrence(of: kopfweh, on: friday, at: time(9, 10), saying: "Hinter dem Auge"),
            Occurrence(of: kopfweh, on: friday, at: time(9, 10), saying: "links"),
            Occurrence(of: kopfweh, on: friday, at: time(18, 40), saying: nil),
            Occurrence(of: kopfweh, on: friday, at: nil, saying: "Schwindel"),
        ])
    #expect(answered.map(\.timeInWords) == ["09:10", "09:10", "18:40", "no time"])
}

@MainActor
@Test("a happening row's occurrences are those of the day the screen is showing")
func aHappeningRowsOccurrencesAreThoseOfTheDayTheScreenIsShowing() throws {
    let place = freshHappeningPlace()
    let kopfweh = try makeHappenings(["Kopfweh"], at: place)[0]
    let directory = freshDirectory()
    let roster = directory.appendingPathComponent("roster.json")
    let record = directory.appendingPathComponent("record.json")
    let screen = DayScreen(
        startingFrom: [], asOf: friday, keepingRecordAt: record, keepingRosterAt: roster,
        keepingOneOffsAt: directory.appendingPathComponent("one-offs.json"),
        keepingHappeningsAt: place)
    let now = moment(friday, 18, 52)

    screen.note(kopfweh, at: time(9, 10), saying: "", asOf: now)
    show(thursday, on: screen)
    screen.note(kopfweh, at: time(7, 0), saying: "", asOf: now)
    show(friday, on: screen)

    let row = try #require(screen.dayView.happeningRows.first)
    #expect(screen.occurrences(of: row).map(\.time) == [time(9, 10)])
    show(thursday, on: screen)
    #expect(screen.occurrences(of: row).map(\.time) == [time(7, 0)])
    show(wednesday, on: screen)
    #expect(screen.occurrences(of: row).isEmpty)

    let commitments = CommitmentsScreen(
        asOf: friday, keepingRosterAt: roster, keepingRecordAt: record, keepingHappeningsAt: place)
    #expect(commitments.rename(kopfweh, to: "Spannungskopfweh") == nil)
    screen.returnedTo(from: commitments)
    show(friday, on: screen)
    #expect(screen.occurrences(of: row).isEmpty)
}

@MainActor
@Test("an occurrence changed through a day screen is kept at the happening place and drawn on the day")
func anOccurrenceChangedThroughADayScreenIsKeptAtTheHappeningPlaceAndDrawnOnTheDay() throws {
    let place = freshHappeningPlace()
    let kopfweh = try makeHappenings(["Kopfweh"], at: place)[0]
    let screen = dayScreen(keepingHappeningsAt: place)
    let now = moment(friday, 18, 52)
    screen.note(kopfweh, at: time(9, 10), saying: "links", asOf: now)
    screen.note(kopfweh, at: time(18, 40), saying: "", asOf: now)
    let first = Occurrence(of: kopfweh, on: friday, at: time(9, 10), saying: "links")

    let refusal = screen.change(first, to: time(7, 30), saying: "  rechts  ", asOf: now)

    #expect(refusal == nil)
    #expect(screen.dayView.happeningRows.map(\.name) == ["Kopfweh"])
    #expect(screen.dayView.happeningRows.map(\.timesInWords) == ["07:30, 18:40"])
    let stored = try HappeningStore(at: place).happenings.occurrences
    #expect(
        stored == [
            Occurrence(of: kopfweh, on: friday, at: time(7, 30), saying: "rechts"),
            Occurrence(of: kopfweh, on: friday, at: time(18, 40), saying: nil),
        ])
    #expect(stored[0].note == "rechts")

    let again = screen.change(stored[0], to: nil, saying: "   ", asOf: now)
    #expect(again == nil)
    #expect(
        try HappeningStore(at: place).happenings.occurrences[0]
            == Occurrence(of: kopfweh, on: friday, at: nil, saying: nil))
    #expect(screen.dayView.happeningRows.map(\.timesInWords) == ["18:40, no time"])
}

/// Makes the directory holding `place` unwritable until the returned closure is run.
private func makeUnwritable(_ place: URL) throws -> () -> Void {
    let directory = place.deletingLastPathComponent()
    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
    return {
        try? FileManager.default.setAttributes(
            [.posixPermissions: 0o700], ofItemAtPath: directory.path)
    }
}

@MainActor
@Test("a change to the time and note an occurrence holds asks for no change")
func aChangeToTheTimeAndNoteAnOccurrenceHoldsAsksForNoChange() throws {
    let place = freshHappeningPlace()
    let kopfweh = try makeHappenings(["Kopfweh"], at: place)[0]
    let screen = dayScreen(keepingHappeningsAt: place)
    let now = moment(friday, 18, 52)
    screen.note(kopfweh, at: time(9, 10), saying: "links", asOf: now)
    let kept = try Data(contentsOf: place)
    let restore = try makeUnwritable(place)
    defer { restore() }

    let refusal = screen.change(
        Occurrence(of: kopfweh, on: friday, at: time(9, 10), saying: "links"), to: time(9, 10),
        saying: "links ", asOf: now)

    #expect(refusal == nil)
    #expect(try Data(contentsOf: place) == kept)
    #expect(screen.dayView.happeningRows.map(\.name) == ["Kopfweh"])
    #expect(screen.dayView.happeningRows.map(\.timesInWords) == ["09:10"])
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
@Test("changing or taking back an occurrence writes no copy, leaves the other places as they were and ends a notice")
func changingOrTakingBackAnOccurrenceWritesNoCopyLeavesTheOtherPlacesAsTheyWereAndEndsANotice() throws {
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
    let now = moment(friday, 14, 40)
    screen.note(kopfweh, at: time(14, 0), saying: "", asOf: now)
    screen.note(kopfweh, at: time(14, 5), saying: "", asOf: now)
    #expect(copyPlace.lastCopy == moment(friday, 14, 32))

    let changed = screen.change(
        Occurrence(of: kopfweh, on: friday, at: time(14, 0), saying: nil), to: time(14, 10),
        saying: "", asOf: now)
    let takenBack = screen.takeBack(Occurrence(of: kopfweh, on: friday, at: time(14, 5), saying: nil))

    #expect(changed == nil)
    #expect(takenBack == nil)
    #expect(copyPlace.lastCopy == moment(friday, 14, 32))
    #expect(try Data(contentsOf: rosterPlace) == rosterBytes)
    #expect(!FileManager.default.fileExists(atPath: recordPlace.path))
    #expect(!FileManager.default.fileExists(atPath: oneOffPlace.path))
    #expect(!FileManager.default.fileExists(atPath: birthdayPlace.path))

    let blocked = freshDirectory()
    try FileManager.default.createDirectory(at: blocked, withIntermediateDirectories: true)
    let blocker = blocked.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    let ticking = DayScreen(
        startingFrom: [], asOf: friday, keepingRecordAt: blocker.appendingPathComponent("record.json"),
        keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace,
        keepingHappeningsAt: happeningPlace)
    let row = try #require(ticking.dayView.rows.first { $0.name == "Gym" })
    ticking.note(kopfweh, at: time(9, 0), saying: "", asOf: now)
    #expect(throws: (any Error).self) { try ticking.tick(row) }
    #expect(ticking.notice != nil)
    let change = ticking.change(
        Occurrence(of: kopfweh, on: friday, at: time(9, 0), saying: nil), to: time(9, 5), saying: "",
        asOf: now)
    #expect(change == nil)
    #expect(ticking.notice == nil)

    #expect(throws: (any Error).self) { try ticking.tick(row) }
    #expect(ticking.notice != nil)
    let back = ticking.takeBack(Occurrence(of: kopfweh, on: friday, at: time(9, 5), saying: nil))
    #expect(back == nil)
    #expect(ticking.notice == nil)
}

@MainActor
@Test("an occurrence taken back through a day screen is gone from the place and from the row")
func anOccurrenceTakenBackThroughADayScreenIsGoneFromThePlaceAndFromTheRow() throws {
    let place = freshHappeningPlace()
    let kopfweh = try makeHappenings(["Kopfweh"], at: place)[0]
    let screen = dayScreen(keepingHappeningsAt: place)
    let now = moment(friday, 18, 52)
    screen.note(kopfweh, at: time(18, 40), saying: "", asOf: now)
    screen.note(kopfweh, at: time(9, 10), saying: "", asOf: now)
    screen.note(kopfweh, at: time(18, 40), saying: "", asOf: now)
    let at1840 = Occurrence(of: kopfweh, on: friday, at: time(18, 40), saying: nil)
    let at0910 = Occurrence(of: kopfweh, on: friday, at: time(9, 10), saying: nil)

    #expect(screen.takeBack(at1840) == nil)

    #expect(screen.dayView.happeningRows.map(\.name) == ["Kopfweh"])
    #expect(screen.dayView.happeningRows.map(\.timesInWords) == ["09:10, 18:40"])
    #expect(try HappeningStore(at: place).happenings.occurrences == [at0910, at1840])

    #expect(screen.takeBack(at0910) == nil)
    #expect(screen.takeBack(at1840) == nil)
    #expect(screen.dayView.happeningRows.isEmpty)
    #expect(screen.happenings.map(\.name) == ["Kopfweh"])
    #expect(screen.offersNotingAHappening)

    show(wednesday, on: screen)
    screen.note(kopfweh, at: nil, saying: "", asOf: now)
    #expect(screen.takeBack(Occurrence(of: kopfweh, on: wednesday, at: nil, saying: nil)) == nil)
    #expect(screen.dayView.happeningRows.isEmpty)
}

@MainActor
@Test("a change to a time later than now is refused as not yet come")
func aChangeToATimeLaterThanNowIsRefusedAsNotYetCome() throws {
    let place = freshHappeningPlace()
    let kopfweh = try makeHappenings(["Kopfweh"], at: place)[0]
    let ahead = Occurrence(of: kopfweh, on: saturday, at: nil, saying: nil)
    try HappeningStore(at: place).note(ahead)
    let screen = dayScreen(keepingHappeningsAt: place)
    let now = moment(friday, 18, 52)
    screen.note(kopfweh, at: time(9, 10), saying: "", asOf: now)
    let held = Occurrence(of: kopfweh, on: friday, at: time(9, 10), saying: nil)

    #expect(screen.change(held, to: time(18, 53), saying: "", asOf: now) == .notYetCome)
    #expect(
        try HappeningStore(at: place).happenings.occurrences.contains(held))
    #expect(screen.dayView.happeningRows.map(\.timesInWords) == ["09:10"])
    #expect(screen.change(held, to: time(18, 52), saying: "", asOf: now) == nil)

    show(wednesday, on: screen)
    screen.note(kopfweh, at: nil, saying: "", asOf: now)
    let past = Occurrence(of: kopfweh, on: wednesday, at: nil, saying: nil)
    #expect(screen.change(past, to: time(23, 59), saying: "", asOf: now) == nil)

    show(saturday, on: screen)
    #expect(screen.change(ahead, to: nil, saying: "x", asOf: now) == .notYetCome)

    show(friday, on: screen)
    #expect(screen.change(ahead, to: nil, saying: "x", asOf: now) == .notYetCome)
}

@MainActor
@Test("a change or a take-back the happening place cannot take is refused as not kept")
func aChangeOrATakeBackTheHappeningPlaceCannotTakeIsRefusedAsNotKept() throws {
    let place = freshHappeningPlace()
    let kopfweh = try makeHappenings(["Kopfweh"], at: place)[0]
    let screen = dayScreen(keepingHappeningsAt: place)
    let now = moment(friday, 18, 52)
    screen.note(kopfweh, at: time(9, 10), saying: "", asOf: now)
    let held = Occurrence(of: kopfweh, on: friday, at: time(9, 10), saying: nil)
    do {
        let restore = try makeUnwritable(place)
        defer { restore() }
        #expect(screen.change(held, to: time(10, 0), saying: "", asOf: now) == .notKept)
        #expect(screen.takeBack(held) == .notKept)
    }
    #expect(screen.dayView.happeningRows.map(\.timesInWords) == ["09:10"])

    let kept = try Data(contentsOf: place)
    let never = Occurrence(of: kopfweh, on: friday, at: time(11, 11), saying: nil)
    #expect(screen.change(never, to: time(11, 12), saying: "", asOf: now) == .notKept)
    #expect(screen.takeBack(never) == .notKept)
    #expect(try Data(contentsOf: place) == kept)

    let garbagePlace = freshHappeningPlace()
    try FileManager.default.createDirectory(
        at: garbagePlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let garbage = Data("not a happening store".utf8)
    try garbage.write(to: garbagePlace)
    let broken = dayScreen(keepingHappeningsAt: garbagePlace)
    #expect(broken.change(held, to: time(10, 0), saying: "", asOf: now) == .notKept)
    #expect(broken.takeBack(held) == .notKept)
    #expect(try Data(contentsOf: garbagePlace) == garbage)
}
