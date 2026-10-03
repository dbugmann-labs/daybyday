import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private let saturday = date(2026, 10, 3)

private func freshDirectory() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
}

private func freshHappeningPlace() -> URL {
    freshDirectory().appendingPathComponent("happenings.json")
}

private func freshRosterAndRecordPlaces() -> (roster: URL, record: URL) {
    let directory = freshDirectory()
    return (
        directory.appendingPathComponent("roster.json"),
        directory.appendingPathComponent("record.json")
    )
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

private func time(_ hour: Int, _ minute: Int) -> TimeOfDay {
    TimeOfDay(hour: hour, minute: minute)!
}

/// Occurrences noted in order at `place`.
private func note(
    _ happening: Happening, on day: CalendarDate, at time: TimeOfDay? = nil,
    saying note: String? = nil, at place: URL
) throws {
    let store = try HappeningStore(at: place)
    try store.note(Occurrence(of: happening, on: day, at: time, saying: note))
}

@MainActor
private func screen(asOf day: CalendarDate = saturday, at place: URL) -> CommitmentsScreen {
    let places = freshRosterAndRecordPlaces()
    return CommitmentsScreen(
        asOf: day, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: place)
}

@MainActor
@Test(
    "a commitments screen answers a look-back at a happening it lists, by its name as listed"
)
func aCommitmentsScreenAnswersALookBackAtAHappeningItListsByItsNameAsListed() throws {
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Augenmigräne", "Kopfweh"], at: place)
    let kopfweh = made[1]
    let commitments = screen(at: place)

    let lookBack = try #require(commitments.lookBack(at: kopfweh))
    #expect(lookBack.name == "Kopfweh")

    #expect(commitments.rename(kopfweh, to: "Spannungskopfweh") == nil)
    #expect(commitments.lookBack(at: kopfweh)?.name == "Spannungskopfweh")
}

@MainActor
@Test(
    "a commitments screen answers no look-back at a happening it does not list, or while it cannot read its happening place"
)
func aCommitmentsScreenAnswersNoLookBackAtAHappeningItDoesNotListOrWhileItCannotReadItsHappeningPlace()
    throws
{
    let place = freshHappeningPlace()
    try makeHappenings(["Kopfweh"], at: place)
    let commitments = screen(at: place)
    let unlisted = try #require(Happening(name: "Schlecht geschlafen"))

    #expect(commitments.lookBack(at: unlisted) == nil)

    let garbled = freshHappeningPlace()
    try FileManager.default.createDirectory(
        at: garbled.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a happening store".utf8).write(to: garbled)
    let unreadable = screen(at: garbled)
    #expect(unreadable.lookBack(at: unlisted) == nil)
    #expect(unreadable.lookBack(at: try #require(Happening(name: "Kopfweh"))) == nil)
}

@MainActor
@Test(
    "a commitments screen that cannot read its roster or its record still answers a look-back at a happening"
)
func aCommitmentsScreenThatCannotReadItsRosterOrItsRecordStillAnswersALookBackAtAHappening()
    throws
{
    let place = freshHappeningPlace()
    let kopfweh = try makeHappenings(["Kopfweh"], at: place)[0]
    try note(kopfweh, on: date(2026, 10, 2), at: time(18, 40), at: place)
    let places = freshRosterAndRecordPlaces()
    try FileManager.default.createDirectory(
        at: places.roster.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a roster".utf8).write(to: places.roster)
    try Data("not a record".utf8).write(to: places.record)
    let commitments = CommitmentsScreen(
        asOf: saturday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: place)

    let lookBack = try #require(commitments.lookBack(at: kopfweh))

    #expect(lookBack.occurrences.map(\.dayInWords) == ["2 October 2026"])
    #expect(lookBack.occurrences.map(\.timeInWords) == ["18:40"])
}

@MainActor
@Test("asking a commitments screen for a happening's look-back changes nothing and writes nothing")
func askingACommitmentsScreenForAHappeningsLookBackChangesNothingAndWritesNothing() throws {
    let place = freshHappeningPlace()
    let kopfweh = try makeHappenings(["Kopfweh"], at: place)[0]
    try note(kopfweh, on: date(2026, 10, 2), at: time(18, 40), at: place)
    let places = freshRosterAndRecordPlaces()
    let commitments = CommitmentsScreen(
        asOf: saturday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: place)
    #expect(commitments.makeHappening(named: "") == .namesNothing)
    func bytes() -> [Data?] {
        [place, places.roster, places.record].map { try? Data(contentsOf: $0) }
    }
    let before = bytes()

    let first = commitments.lookBack(at: kopfweh)
    let second = commitments.lookBack(at: kopfweh)

    #expect(first != nil)
    #expect(first == second)
    #expect(commitments.happenings.map(\.name) == ["Kopfweh"])
    #expect(commitments.happeningRefusal == .namesNothing)
    #expect(bytes() == before)
}

@MainActor
@Test(
    "a happening's look-back says its own occurrences, newest day first, each with its day, its time and its note"
)
func aHappeningsLookBackSaysItsOwnOccurrencesNewestDayFirstEachWithItsDayItsTimeAndItsNote()
    throws
{
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Augenmigräne", "Kopfweh"], at: place)
    let (augenmigraene, kopfweh) = (made[0], made[1])
    try note(kopfweh, on: date(2026, 8, 28), at: time(7, 15), saying: "Woke up with it.", at: place)
    try note(
        kopfweh, on: date(2026, 10, 2), at: time(18, 40), saying: "Behind the left eye\nthen both",
        at: place)
    try note(augenmigraene, on: date(2026, 10, 1), at: time(9, 0), at: place)
    try note(kopfweh, on: date(2026, 7, 14), at: nil, at: place)
    let commitments = screen(at: place)

    let lookBack = try #require(commitments.lookBack(at: kopfweh))

    #expect(
        lookBack.occurrences == [
            .init(
                dayInWords: "2 October 2026", timeInWords: "18:40",
                note: "Behind the left eye\nthen both"),
            .init(dayInWords: "28 August 2026", timeInWords: "07:15", note: "Woke up with it."),
            .init(dayInWords: "14 July 2026", timeInWords: "no time", note: nil),
        ])
}

@MainActor
@Test("a happening's look-back says a day's latest time first and its occurrences with no time after them")
func aHappeningsLookBackSaysADaysLatestTimeFirstAndItsOccurrencesWithNoTimeAfterThem() throws {
    let place = freshHappeningPlace()
    let kopfweh = try makeHappenings(["Kopfweh"], at: place)[0]
    let day = date(2026, 10, 2)
    try note(kopfweh, on: day, at: nil, saying: "first", at: place)
    try note(kopfweh, on: day, at: time(18, 40), at: place)
    try note(kopfweh, on: day, at: time(9, 10), at: place)
    try note(kopfweh, on: day, at: nil, saying: "second", at: place)
    try note(kopfweh, on: day, at: time(18, 40), saying: "links", at: place)
    let commitments = screen(at: place)

    let lookBack = try #require(commitments.lookBack(at: kopfweh))

    #expect(lookBack.occurrences.map(\.timeInWords) == ["18:40", "18:40", "09:10", "no time", "no time"])
    #expect(lookBack.occurrences.map(\.note) == ["links", nil, nil, "second", "first"])
}

@MainActor
@Test(
    "a happening's look-back counts every occurrence it says and says the day of the earliest"
)
func aHappeningsLookBackCountsEveryOccurrenceItSaysAndSaysTheDayOfTheEarliest() throws {
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Augenmigräne", "Kopfweh"], at: place)
    let (augenmigraene, kopfweh) = (made[0], made[1])
    try note(kopfweh, on: date(2026, 8, 28), at: time(7, 15), at: place)
    try note(kopfweh, on: date(2026, 10, 2), at: time(18, 40), at: place)
    try note(augenmigraene, on: date(2026, 10, 1), at: time(9, 0), at: place)
    try note(kopfweh, on: date(2026, 7, 14), at: nil, at: place)
    let commitments = screen(at: place)

    let lookBack = try #require(commitments.lookBack(at: kopfweh))

    #expect(lookBack.countInWords == "3 times")
    #expect(lookBack.sinceInWords == "14 July 2026")
}

@MainActor
@Test("a happening's look-back that says one occurrence counts it in the singular")
func aHappeningsLookBackThatSaysOneOccurrenceCountsItInTheSingular() throws {
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Augenmigräne", "Kopfweh"], at: place)
    let (augenmigraene, kopfweh) = (made[0], made[1])
    try note(kopfweh, on: date(2026, 10, 2), at: time(18, 40), at: place)
    try note(augenmigraene, on: date(2026, 10, 1), at: time(9, 0), at: place)
    let commitments = screen(at: place)

    let lookBack = try #require(commitments.lookBack(at: augenmigraene))

    #expect(lookBack.countInWords == "1 time")
    #expect(lookBack.sinceInWords == "1 October 2026")
}

@MainActor
@Test(
    "a happening's look-back counts each calendar month from the earliest occurrence's through the current one, newest first"
)
func aHappeningsLookBackCountsEachCalendarMonthFromTheEarliestOccurrencesThroughTheCurrentOneNewestFirst()
    throws
{
    let place = freshHappeningPlace()
    let kopfweh = try makeHappenings(["Kopfweh"], at: place)[0]
    try note(kopfweh, on: date(2026, 7, 14), at: time(18, 0), at: place)
    try note(kopfweh, on: date(2026, 8, 12), at: time(9, 0), at: place)
    try note(kopfweh, on: date(2026, 8, 28), at: time(7, 15), at: place)
    try note(kopfweh, on: date(2026, 8, 28), at: nil, at: place)
    try note(kopfweh, on: date(2026, 10, 2), at: time(18, 40), at: place)
    try note(kopfweh, on: date(2026, 10, 2), at: nil, at: place)

    let lookBack = try #require(screen(at: place).lookBack(at: kopfweh))

    #expect(
        lookBack.months == [
            .init(inWords: "October 2026", countInWords: "2 times"),
            .init(inWords: "September 2026", countInWords: "0 times"),
            .init(inWords: "August 2026", countInWords: "3 times"),
            .init(inWords: "July 2026", countInWords: "1 time"),
        ])
    #expect(lookBack.countInWords == "6 times")

    let later = try #require(screen(asOf: date(2026, 11, 15), at: place).lookBack(at: kopfweh))
    #expect(later.months.count == 5)
    #expect(later.months.first == .init(inWords: "November 2026", countInWords: "0 times"))
}

@MainActor
@Test("a happening's look-back runs its months unbroken across the turn of a year")
func aHappeningsLookBackRunsItsMonthsUnbrokenAcrossTheTurnOfAYear() throws {
    let place = freshHappeningPlace()
    let kopfweh = try makeHappenings(["Kopfweh"], at: place)[0]
    try note(kopfweh, on: date(2025, 12, 20), at: nil, at: place)
    try note(kopfweh, on: date(2026, 2, 3), at: nil, at: place)

    let lookBack = try #require(screen(asOf: date(2026, 2, 5), at: place).lookBack(at: kopfweh))

    #expect(
        lookBack.months == [
            .init(inWords: "February 2026", countInWords: "1 time"),
            .init(inWords: "January 2026", countInWords: "0 times"),
            .init(inWords: "December 2025", countInWords: "1 time"),
        ])
}

@MainActor
@Test(
    "a happening's look-back says an occurrence on a day after the one the screen holds, and counts its month"
)
func aHappeningsLookBackSaysAnOccurrenceOnADayAfterTheOneTheScreenHoldsAndCountsItsMonth() throws {
    let place = freshHappeningPlace()
    let kopfweh = try makeHappenings(["Kopfweh"], at: place)[0]
    try note(kopfweh, on: date(2026, 10, 20), at: time(9, 0), at: place)
    try note(kopfweh, on: date(2026, 11, 1), at: time(9, 0), at: place)

    let lookBack = try #require(screen(asOf: date(2026, 10, 31), at: place).lookBack(at: kopfweh))

    #expect(lookBack.occurrences.map(\.dayInWords) == ["1 November 2026", "20 October 2026"])
    #expect(lookBack.countInWords == "2 times")
    #expect(
        lookBack.months == [
            .init(inWords: "November 2026", countInWords: "1 time"),
            .init(inWords: "October 2026", countInWords: "1 time"),
        ])
}

@MainActor
@Test("a happening's look-back with nothing noted says its name and nothing else")
func aHappeningsLookBackWithNothingNotedSaysItsNameAndNothingElse() throws {
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Augenmigräne", "Kopfweh"], at: place)
    let (augenmigraene, kopfweh) = (made[0], made[1])
    try note(augenmigraene, on: date(2026, 10, 1), at: time(9, 0), at: place)

    let lookBack = try #require(screen(at: place).lookBack(at: kopfweh))

    #expect(lookBack.name == "Kopfweh")
    #expect(lookBack.occurrences.isEmpty)
    #expect(lookBack.countInWords == nil)
    #expect(lookBack.months.isEmpty)
    #expect(lookBack.sinceInWords == nil)

    let store = try HappeningStore(at: place)
    let occurrence = Occurrence(of: augenmigraene, on: date(2026, 10, 1), at: time(9, 0), saying: nil)
    #expect(try store.takeBack(occurrence))
    let taken = try #require(screen(at: place).lookBack(at: augenmigraene))
    #expect(taken == HappeningLookBack(
        name: "Augenmigräne", sinceInWords: nil, countInWords: nil, months: [], occurrences: []))
}
