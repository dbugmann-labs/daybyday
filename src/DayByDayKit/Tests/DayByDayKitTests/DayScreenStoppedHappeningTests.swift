import Foundation
import Testing

@testable import DayByDayKit

private let friday = CalendarDate(year: 2026, month: 10, day: 2)!
private let thursday = CalendarDate(year: 2026, month: 10, day: 1)!
private let wednesday = CalendarDate(year: 2026, month: 9, day: 30)!

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
        if screen.dayView.date.days(until: day) > 0 {
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

/// A day screen of no commitments at all as of `today`, with a roster place and record place of
/// its own beside a directory of its own, and its happenings at `happeningPlace`.
@MainActor
private func dayScreen(asOf today: CalendarDate = friday, keepingHappeningsAt happeningPlace: URL)
    -> (screen: DayScreen, roster: URL, record: URL)
{
    let directory = freshDirectory()
    let record = directory.appendingPathComponent("record.json")
    let roster = directory.appendingPathComponent("roster.json")
    return (
        DayScreen(
            startingFrom: [], asOf: today, keepingRecordAt: record, keepingRosterAt: roster,
            keepingOneOffsAt: directory.appendingPathComponent("one-offs.json"),
            keepingHappeningsAt: happeningPlace),
        roster, record
    )
}

@MainActor
@Test(
    "a stopped happening's row is still drawn on the days it came, and its occurrences are changed and taken back"
)
func aStoppedHappeningsRowIsStillDrawnOnTheDaysItCameAndItsOccurrencesAreChangedAndTakenBack()
    throws
{
    let place = freshHappeningPlace()
    let kopfweh = try makeHappenings(["Kopfweh"], at: place)[0]
    let store = try HappeningStore(at: place)
    let morning = Occurrence(of: kopfweh, on: wednesday, at: time(9, 10), saying: nil)
    let evening = Occurrence(of: kopfweh, on: wednesday, at: time(18, 40), saying: nil)
    try store.note(morning)
    try store.note(evening)
    try store.stop(kopfweh)
    let screen = dayScreen(keepingHappeningsAt: place).screen
    show(wednesday, on: screen)
    let now = moment(friday, 18, 52)

    let row = try #require(screen.dayView.happeningRows.first)
    #expect(screen.dayView.happeningRows.count == 1)
    #expect(row.name == "Kopfweh")
    #expect(row.timesInWords == "09:10, 18:40")
    #expect(screen.occurrences(of: row) == [morning, evening])

    let changed = screen.change(morning, to: time(8, 0), saying: "links", asOf: now)
    #expect(changed == nil)
    #expect(screen.dayView.happeningRows.map(\.timesInWords) == ["08:00, 18:40"])
    let takenBack = screen.takeBack(evening)
    #expect(takenBack == nil)
    #expect(screen.dayView.happeningRows.map(\.timesInWords) == ["08:00"])

    let reopened = try HappeningStore(at: place)
    #expect(reopened.happenings.isStopped(kopfweh))
    #expect(
        reopened.happenings.occurrences
            == [Occurrence(of: kopfweh, on: wednesday, at: time(8, 0), saying: "links")])
}

@MainActor
@Test("noting a stopped happening through a day screen is refused as not kept")
func notingAStoppedHappeningThroughADayScreenIsRefusedAsNotKept() throws {
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Augenmigräne", "Kopfweh"], at: place)
    try HappeningStore(at: place).stop(made[1])
    let screen = dayScreen(keepingHappeningsAt: place).screen
    let now = moment(friday, 18, 52)

    let refusal = screen.note(made[1], at: time(9, 10), saying: "", asOf: now)

    #expect(refusal == .notKept)
    #expect(try HappeningStore(at: place).happenings.occurrences.isEmpty)
    #expect(screen.dayView.happeningRows.isEmpty)
    #expect(screen.note(made[0], at: time(9, 10), saying: "", asOf: now) == nil)
}

@MainActor
@Test("a happening deleted through a commitments screen has no row on the days it came")
func aHappeningDeletedThroughACommitmentsScreenHasNoRowOnTheDaysItCame() throws {
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Augenmigräne", "Kopfweh"], at: place)
    let made2 = dayScreen(keepingHappeningsAt: place)
    let screen = made2.screen
    let now = moment(friday, 18, 52)
    screen.note(made[1], at: time(9, 10), saying: "", asOf: now)
    screen.note(made[0], at: nil, saying: "", asOf: now)
    let gone = Occurrence(of: made[1], on: friday, at: time(9, 10), saying: nil)

    let commitments = CommitmentsScreen(
        asOf: friday, keepingRosterAt: made2.roster, keepingRecordAt: made2.record,
        keepingHappeningsAt: place)
    commitments.askToDelete(made[1])
    commitments.happeningNameTypedBack = "Kopfweh"
    #expect(commitments.confirmDeletingHappening() == nil)
    screen.returnedTo(from: commitments)

    #expect(screen.happenings.map(\.name) == ["Augenmigräne"])
    #expect(screen.dayView.happeningRows.map(\.name) == ["Augenmigräne"])
    #expect(screen.dayView.happeningRows.map(\.timesInWords) == ["no time"])
    #expect(screen.takeBack(gone) == .notKept)
}

@MainActor
@Test("a day screen lists no stopped happening, and lists one resumed in its place")
func aDayScreenListsNoStoppedHappeningAndListsOneResumedInItsPlace() throws {
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Augenmigräne", "Kopfweh", "Schlecht geschlafen"], at: place)
    try HappeningStore(at: place).stop(made[1])
    let opened = dayScreen(keepingHappeningsAt: place)
    let screen = opened.screen

    #expect(screen.happenings.map(\.name) == ["Augenmigräne", "Schlecht geschlafen"])
    #expect(screen.happeningState == .kept)

    let commitments = CommitmentsScreen(
        asOf: friday, keepingRosterAt: opened.roster, keepingRecordAt: opened.record,
        keepingHappeningsAt: place)
    #expect(commitments.resume(made[1]) == nil)
    screen.returnedTo(from: commitments)
    #expect(screen.happenings.map(\.name) == ["Augenmigräne", "Kopfweh", "Schlecht geschlafen"])

    let onlyStopped = freshHappeningPlace()
    let alone = try makeHappenings(["Kopfweh"], at: onlyStopped)[0]
    try HappeningStore(at: onlyStopped).stop(alone)
    let none = dayScreen(keepingHappeningsAt: onlyStopped).screen
    #expect(none.happenings.isEmpty)
    #expect(none.happeningState == .kept)
    #expect(!none.offersNotingAHappening)
    show(wednesday, on: none)
    #expect(!none.offersNotingAHappening)
}
