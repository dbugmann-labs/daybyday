import Foundation
import Testing

@testable import DayByDayKit

/// A fresh roster place under one fresh temporary directory — a UUID names the directory, and
/// the file sits one level under it, so the directory itself does not exist until something
/// creates it. This URL is "the same place" a screen is opened at twice.
private func freshRosterPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("roster.json")
}

/// A fresh pair of places under one fresh temporary directory — a roster file and a record file
/// beside it — for the scenarios that drive `CommitmentsScreen.change`, which takes a record
/// place for the first time. Mirrors `DayScreenTests`'s `freshPlaces()`.
private func freshRosterAndRecordPlaces() -> (roster: URL, record: URL) {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    return (
        directory.appendingPathComponent("roster.json"),
        directory.appendingPathComponent("record.json")
    )
}

/// A fresh path for a one-off place nothing has been kept at, under its own fresh temporary
/// directory — mirrors `DayScreenTests`'s own `freshOneOffPlace()`, for the two `makeACopy`
/// scenarios in § 5 that need a third place beside the roster and the record.
private func freshOneOffPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("one-offs.json")
}

/// Sets the user-immutable flag on the file at `place`: it still reads, but a rename or removal
/// of it — `chflags uchg` at the shell, `FileAttributeKey.immutable` through `FileManager` —
/// fails with `NSCocoaErrorDomain 513`, unlike `makeReadOnly(_:)` in `DayScreenTests.swift`, which
/// denies an entire directory and so also denies writing any *other* file inside it. Every caller
/// must pair this with `makeMutable(_:)` before returning, including on its failure path, or the
/// file is left impossible to remove behind it.
private func makeImmutable(_ place: URL) throws {
    try FileManager.default.setAttributes([.immutable: true], ofItemAtPath: place.path)
}

/// Undoes `makeImmutable(_:)`, restoring `place` to a file that can be renamed or removed again.
private func makeMutable(_ place: URL) throws {
    try FileManager.default.setAttributes([.immutable: false], ofItemAtPath: place.path)
}

/// Bytes for a record place at the form this app reads (version 5), holding `ticksJSON` — the raw
/// JSON array literal for the `ticks` key's value — alongside the `numbers`, `notes` and
/// `additions` keys `RecordStore.init(at:)`'s shape guard requires at that version
/// (`RecordDocument.swift`'s three `...IntroducedInVersion` constants). Laid out with different
/// key order and spacing than a store's own `.sortedKeys` encoding ever produces, so a spurious
/// write that changed nothing observable would still change the place's bytes, and a byte check
/// against it would see it. A place seeded with anything less than this shape opens as
/// `.notAStore`, which makes such a byte check compare a file nothing could write.
private func seededRecordBytes(ticks ticksJSON: String) -> Data {
    Data(
        """
        {
          "version": 5,
          "ticks": \(ticksJSON),
          "numbers": [],
          "notes": [],
          "additions": []
        }
        """.utf8)
}

@MainActor
@Test("a commitments screen lists the commitments its roster keeps, in the order they were taken on")
func aCommitmentsScreenListsTheCommitmentsItsRosterKeepsInTheOrderTheyWereTakenOn() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.map(\.name) == ["Water plants", "Gym", "Journaling"])
    #expect(screen.rosterState == .kept)
}

@MainActor
@Test("an entry says the rhythm its commitment runs on, whichever of the four shapes it is")
func anEntrySaysTheRhythmItsCommitmentRunsOnWhicheverOfTheFourShapesItIs() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let finances = Commitment(
        name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 25)!), keptFrom: keptFrom)!
    let contactLenses = Commitment(
        name: "Contact lenses",
        schedule: .everyNDays(DayInterval(days: 14)!, from: keptFrom), keptFrom: keptFrom)!
    let reading = Commitment(
        name: "Reading", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(finances)
    try rosterStore.add(contactLenses)
    try rosterStore.add(reading)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.map(\.name) == ["Gym", "Finances", "Contact lenses", "Reading"])
    #expect(screen.kept.map(\.rhythmInWords) == [
        "Mon, Wed, Sat", "The 25th", "Every 14 days", "3x a week",
    ])
}

@MainActor
@Test("a commitments screen does not list a commitment its roster has stopped keeping")
func aCommitmentsScreenDoesNotListACommitmentItsRosterHasStoppedKeeping() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.map(\.name) == ["Journaling"])
    #expect(!screen.kept.map(\.name).contains("Gym"))
}

@MainActor
@Test("two commitments alike in name and not in rhythm are told apart by the rhythm their entries say")
func twoCommitmentsAlikeInNameAndNotInRhythmAreToldApartByTheRhythmTheirEntriesSay() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let vitaminsMondayWednesday = Commitment(
        name: "Vitamins", schedule: .weekdays([.monday, .wednesday]), keptFrom: keptFrom)!
    let vitaminsTuesdayThursday = Commitment(
        name: "Vitamins", schedule: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(vitaminsMondayWednesday)
    try rosterStore.add(vitaminsTuesdayThursday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.map(\.name) == ["Vitamins", "Vitamins"])
    #expect(screen.kept.map(\.rhythmInWords) == ["Mon, Wed", "Tue, Thu"])

    screen.askToStopKeeping(screen.kept[0])
    screen.confirmStopKeeping()

    #expect(screen.kept.map(\.name) == ["Vitamins"])
    #expect(screen.kept.map(\.rhythmInWords) == ["Tue, Thu"])
}

@MainActor
@Test("two commitments alike in name and in rhythm are two entries that say the same thing")
func twoCommitmentsAlikeInNameAndInRhythmAreTwoEntriesThatSayTheSameThing() throws {
    let rosterPlace = freshRosterPlace()
    let januaryFirst = CalendarDate(year: 2026, month: 1, day: 1)!
    let juneFirst = CalendarDate(year: 2026, month: 6, day: 1)!
    let vitaminsFromJanuary = Commitment(
        name: "Vitamins", schedule: .weekdays([.monday, .wednesday]), keptFrom: januaryFirst)!
    let vitaminsFromJune = Commitment(
        name: "Vitamins", schedule: .weekdays([.monday, .wednesday]), keptFrom: juneFirst)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(vitaminsFromJanuary)
    try rosterStore.add(vitaminsFromJune)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.map(\.name) == ["Vitamins", "Vitamins"])
    #expect(screen.kept.map(\.rhythmInWords) == ["Mon, Wed", "Mon, Wed"])
}

@MainActor
@Test("a commitments screen opened on a roster that holds nothing lists nothing and takes nothing on")
func aCommitmentsScreenOpenedOnARosterThatHoldsNothingListsNothingAndTakesNothingOn() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.isEmpty)
    #expect(screen.keptGroups.isEmpty)
    #expect(screen.stopped.isEmpty)
    #expect(screen.rosterState == .kept)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a commitments screen lists what its roster has stopped keeping, in the order they were taken on")
func aCommitmentsScreenListsWhatItsRosterHasStoppedKeepingInTheOrderTheyWereTakenOn() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.retire(journaling, keptUntil: sunday)
    try rosterStore.retire(waterPlants, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.stopped.map(\.name) == ["Water plants", "Journaling"])
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a stopped entry says the rhythm its commitment runs on, as a kept entry does")
func aStoppedEntrySaysTheRhythmItsCommitmentRunsOnAsAKeptEntryDoes() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let vitaminsMondayWednesday = Commitment(
        name: "Vitamins", schedule: .weekdays([.monday, .wednesday]), keptFrom: keptFrom)!
    let vitaminsThreeAWeek = Commitment(
        name: "Vitamins", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(vitaminsMondayWednesday)
    try rosterStore.add(vitaminsThreeAWeek)
    try rosterStore.retire(vitaminsMondayWednesday, keptUntil: sunday)
    try rosterStore.retire(vitaminsThreeAWeek, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.stopped.map(\.name) == ["Vitamins", "Vitamins"])
    #expect(screen.stopped.map(\.rhythmInWords) == ["Mon, Wed", "3x a week"])
}

@MainActor
@Test("a commitments screen whose roster has stopped nothing lists nothing as stopped")
func aCommitmentsScreenWhoseRosterHasStoppedNothingListsNothingAsStopped() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.stopped.isEmpty)
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitment a commitments screen keeps is not among what it has stopped")
func aCommitmentACommitmentsScreenKeepsIsNotAmongWhatItHasStopped() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let inBoth = Set(screen.kept).intersection(screen.stopped)
    #expect(inBoth.isEmpty)
    #expect(screen.kept.map(\.name) == ["Journaling"])
    #expect(screen.stopped.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitment defined through a commitments screen is kept at the roster place before either list says so")
func aCommitmentDefinedThroughACommitmentsScreenIsKeptAtTheRosterPlaceBeforeEitherListSaysSo() throws {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "Gym", on: .weekdays([.monday, .wednesday, .saturday]), keptFrom: monday, under: nil)

    let rosterStore = try RosterStore(at: rosterPlace)
    #expect(rosterStore.roster.commitments.map(\.name) == ["Gym"])
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(refusal == nil)
}

@MainActor
@Test("a commitment defined through a commitments screen is last in what it keeps")
func aCommitmentDefinedThroughACommitmentsScreenIsLastInWhatItKeeps() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(
        name: "Journaling",
        on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: monday, under: nil)

    #expect(screen.kept.map(\.name) == ["Water plants", "Gym", "Journaling"])
}

@MainActor
@Test("a commitment defined on each of the four rhythms is read back on the schedule that rhythm names")
func aCommitmentDefinedOnEachOfTheFourRhythmsIsReadBackOnTheScheduleThatRhythmNames() throws {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(
        name: "Gym", on: .weekdays([.monday, .wednesday, .saturday]), keptFrom: monday, under: nil)
    _ = screen.define(
        name: "Finances", on: .dayOfMonth(25), keptFrom: monday, under: nil)
    _ = screen.define(
        name: "Contact lenses", on: .everyNDays(14), keptFrom: monday, under: nil)
    _ = screen.define(
        name: "Reading", on: .weeklyQuota(3), keptFrom: monday, under: nil)

    let rosterStore = try RosterStore(at: rosterPlace)
    let expected = [
        Commitment(
            name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: monday)!,
        Commitment(
            name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 25)!), keptFrom: monday)!,
        Commitment(
            name: "Contact lenses", schedule: .everyNDays(DayInterval(days: 14)!, from: monday),
            keptFrom: monday)!,
        Commitment(
            name: "Reading", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!),
            keptFrom: monday)!,
    ]
    #expect(rosterStore.roster.commitments == expected)
}

@MainActor
@Test("a commitment of each of the four kinds is defined through a commitments screen and kept with that kind")
func aCommitmentOfEachOfTheFourKindsIsDefinedThroughACommitmentsScreenAndKeptWithThatKind() throws {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let dailySchedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let tickRefusal = screen.define(
        name: "Gym", on: dailyRhythm, keptFrom: monday, under: nil, kind: .tick)
    let numberRefusal = screen.define(
        name: "Mood", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number,
        lowest: "1", highest: "10")
    let noteRefusal = screen.define(
        name: "Journal", on: dailyRhythm, keptFrom: monday, under: nil, kind: .note)
    let totalRefusal = screen.define(
        name: "Protein", on: dailyRhythm, keptFrom: monday, under: nil, kind: .total, target: "120")

    #expect(tickRefusal == nil)
    #expect(numberRefusal == nil)
    #expect(noteRefusal == nil)
    #expect(totalRefusal == nil)

    let rosterStore = try RosterStore(at: rosterPlace)
    let expected = [
        Commitment(name: "Gym", schedule: dailySchedule, keptFrom: monday, kind: .tick)!,
        Commitment(
            name: "Mood", schedule: dailySchedule, keptFrom: monday,
            kind: .number(range: Commitment.Range(lowest: 1, highest: 10)))!,
        Commitment(name: "Journal", schedule: dailySchedule, keptFrom: monday, kind: .note)!,
        Commitment(
            name: "Protein", schedule: dailySchedule, keptFrom: monday,
            kind: .total(target: Commitment.Target(120)!))!,
    ]
    #expect(rosterStore.roster.commitments == expected)
}

@MainActor
@Test("a commitment of the number kind defined with both range fields blank carries no range")
func aCommitmentOfTheNumberKindDefinedWithBothRangeFieldsBlankCarriesNoRange() throws {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "Weight", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number,
        lowest: "", highest: "")

    #expect(refusal == nil)

    let rosterStore = try RosterStore(at: rosterPlace)
    #expect(rosterStore.roster.commitments.map(\.kind) == [.number(range: nil)])

    let blankSpaceRosterPlace = freshRosterPlace()
    let blankSpaceScreen = CommitmentsScreen(asOf: monday, keepingRosterAt: blankSpaceRosterPlace)
    _ = blankSpaceScreen.define(
        name: "Weight", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number,
        lowest: "   ", highest: "  ")

    let blankSpaceRosterStore = try RosterStore(at: blankSpaceRosterPlace)
    #expect(blankSpaceRosterStore.roster.commitments.map(\.kind) == [.number(range: nil)])
}

@MainActor
@Test("a range end and a target are read as a number entry reads a number")
func aRangeEndAndATargetAreReadAsANumberEntryReadsANumber() throws {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let temperatureRefusal = screen.define(
        name: "Temperature", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number,
        lowest: " -40,5 ", highest: "150.00")
    let doseRefusal = screen.define(
        name: "Dose", on: dailyRhythm, keptFrom: monday, under: nil, kind: .total, target: "0,5")

    #expect(temperatureRefusal == nil)
    #expect(doseRefusal == nil)

    let rosterStore = try RosterStore(at: rosterPlace)
    #expect(
        rosterStore.roster.commitments.map(\.kind) == [
            .number(range: Commitment.Range(lowest: -40.5, highest: 150)),
            .total(target: Commitment.Target(0.5)!),
        ])
}

@MainActor
@Test("a range typed on a kind with no room for one is ignored rather than refused")
func aRangeTypedOnAKindWithNoRoomForOneIsIgnoredRatherThanRefused() throws {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let journalRefusal = screen.define(
        name: "Journal", on: dailyRhythm, keptFrom: monday, under: nil, kind: .note,
        lowest: "10", highest: "1")
    let proteinRefusal = screen.define(
        name: "Protein", on: dailyRhythm, keptFrom: monday, under: nil, kind: .total,
        lowest: "not a number", target: "120")

    #expect(journalRefusal == nil)
    #expect(proteinRefusal == nil)

    let rosterStore = try RosterStore(at: rosterPlace)
    #expect(
        rosterStore.roster.commitments.map(\.kind) == [.note, .total(target: Commitment.Target(120)!)])

    let tickRosterPlace = freshRosterPlace()
    let tickScreen = CommitmentsScreen(asOf: monday, keepingRosterAt: tickRosterPlace)
    let gymRefusal = tickScreen.define(
        name: "Gym", on: dailyRhythm, keptFrom: monday, under: nil, kind: .tick,
        lowest: "10", highest: "1")

    #expect(gymRefusal == nil)

    let tickRosterStore = try RosterStore(at: tickRosterPlace)
    #expect(tickRosterStore.roster.commitments.map(\.kind) == [.tick])
}

@MainActor
@Test("a target typed on a kind with no room for one is ignored rather than refused")
func aTargetTypedOnAKindWithNoRoomForOneIsIgnoredRatherThanRefused() throws {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "Mood", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number,
        lowest: "1", highest: "10", target: "0")

    #expect(refusal == nil)

    let rosterStore = try RosterStore(at: rosterPlace)
    #expect(
        rosterStore.roster.commitments.map(\.kind)
            == [.number(range: Commitment.Range(lowest: 1, highest: 10))])
}

@MainActor
@Test("a commitment alike in every way but the kind it takes is not one a commitments screen already keeps")
func aCommitmentAlikeInEveryWayButTheKindItTakesIsNotOneACommitmentsScreenAlreadyKeeps() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let tickWeight = Commitment(name: "Weight", schedule: daily, keptFrom: keptFrom, kind: .tick)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(tickWeight)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.define(
        name: "Weight", on: dailyRhythm, keptFrom: keptFrom, under: nil, kind: .number)

    #expect(refusal == nil)
    #expect(screen.kept.map(\.name) == ["Weight", "Weight"])

    let stoppedRosterPlace = freshRosterPlace()
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let stoppedRosterStore = try RosterStore(at: stoppedRosterPlace)
    try stoppedRosterStore.add(tickWeight)
    try stoppedRosterStore.retire(tickWeight, keptUntil: sunday)

    let stoppedScreen = CommitmentsScreen(asOf: monday, keepingRosterAt: stoppedRosterPlace)
    let secondRefusal = stoppedScreen.define(
        name: "Weight", on: dailyRhythm, keptFrom: keptFrom, under: nil, kind: .number)

    #expect(secondRefusal == nil)
    #expect(stoppedScreen.kept.map(\.name) == ["Weight"])
    #expect(stoppedScreen.kept.map(\.kind) == [.number(range: nil)])
    #expect(stoppedScreen.stopped.map(\.name) == ["Weight"])
    #expect(stoppedScreen.stopped.map(\.kind) == [.tick])
}

@MainActor
@Test("a commitments screen refuses a range end that is not a number")
func aCommitmentsScreenRefusesARangeEndThatIsNotANumber() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "Mood", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number,
        lowest: "one", highest: "10")
    let secondRefusal = screen.define(
        name: "Mood", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number,
        lowest: "1", highest: "1e2")

    #expect(refusal == .rangeIsNotARange)
    #expect(secondRefusal == .rangeIsNotARange)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a commitments screen refuses a range with one end typed and the other blank")
func aCommitmentsScreenRefusesARangeWithOneEndTypedAndTheOtherBlank() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "Weight", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number,
        lowest: "40", highest: "")
    let secondRefusal = screen.define(
        name: "Weight", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number,
        lowest: "  ", highest: "150")

    #expect(refusal == .rangeIsNotARange)
    #expect(secondRefusal == .rangeIsNotARange)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a commitments screen refuses a target that is not a number")
func aCommitmentsScreenRefusesATargetThatIsNotANumber() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "Protein", on: dailyRhythm, keptFrom: monday, under: nil, kind: .total,
        target: "120g")

    #expect(refusal == .targetIsNotATarget)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a commitments screen refuses a target that is not above zero")
func aCommitmentsScreenRefusesATargetThatIsNotAboveZero() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "Protein", on: dailyRhythm, keptFrom: monday, under: nil, kind: .total, target: "0")
    let secondRefusal = screen.define(
        name: "Protein", on: dailyRhythm, keptFrom: monday, under: nil, kind: .total, target: "-1")

    #expect(refusal == .targetIsNotATarget)
    #expect(secondRefusal == .targetIsNotATarget)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a commitments screen refuses a total with nothing in its target field")
func aCommitmentsScreenRefusesATotalWithNothingInItsTargetField() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "Protein", on: dailyRhythm, keptFrom: monday, under: nil, kind: .total, target: "")
    let secondRefusal = screen.define(
        name: "Protein", on: dailyRhythm, keptFrom: monday, under: nil, kind: .total,
        target: "   ")

    #expect(refusal == .targetIsNotATarget)
    #expect(secondRefusal == .targetIsNotATarget)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a range end and a target of more than thirty-eight significant digits are not numbers")
func aRangeEndAndATargetOfMoreThanThirtyEightSignificantDigitsAreNotNumbers() throws {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let fortyDigits = "1" + String(repeating: "9", count: 39)
    let thirtyEightDigits = "1" + String(repeating: "9", count: 37)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let moodRefusal = screen.define(
        name: "Mood", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number,
        lowest: "1", highest: fortyDigits)
    let proteinRefusal = screen.define(
        name: "Protein", on: dailyRhythm, keptFrom: monday, under: nil, kind: .total,
        target: fortyDigits)

    #expect(moodRefusal == .rangeIsNotARange)
    #expect(proteinRefusal == .targetIsNotATarget)

    let acceptedRefusal = screen.define(
        name: "Mood", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number,
        lowest: "1", highest: thirtyEightDigits)

    #expect(acceptedRefusal == nil)
    #expect(screen.kept.map(\.name) == ["Mood"])
}

@MainActor
@Test("a commitments screen accepts a range of one value, and one whose ends are negative and zero")
func aCommitmentsScreenAcceptsARangeOfOneValueAndOneWhoseEndsAreNegativeAndZero() throws {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let dosesRefusal = screen.define(
        name: "Doses", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number,
        lowest: "7", highest: "7")
    let weightChangeRefusal = screen.define(
        name: "Weight change", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number,
        lowest: "-40.5", highest: "0")

    #expect(dosesRefusal == nil)
    #expect(weightChangeRefusal == nil)

    let rosterStore = try RosterStore(at: rosterPlace)
    #expect(
        rosterStore.roster.commitments.map(\.kind) == [
            .number(range: Commitment.Range(lowest: 7, highest: 7)),
            .number(range: Commitment.Range(lowest: -40.5, highest: 0)),
        ])
}

@MainActor
@Test("a commitments screen accepts a target with a decimal fraction, below one")
func aCommitmentsScreenAcceptsATargetWithADecimalFractionBelowOne() throws {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let doseRefusal = screen.define(
        name: "Dose", on: dailyRhythm, keptFrom: monday, under: nil, kind: .total, target: "0.5")
    let vitaminDRefusal = screen.define(
        name: "Vitamin D", on: dailyRhythm, keptFrom: monday, under: nil, kind: .total,
        target: "0.0001")

    #expect(doseRefusal == nil)
    #expect(vitaminDRefusal == nil)

    let rosterStore = try RosterStore(at: rosterPlace)
    #expect(
        rosterStore.roster.commitments.map(\.kind) == [
            .total(target: Commitment.Target(0.5)!),
            .total(target: Commitment.Target(0.0001)!),
        ])
}

@MainActor
@Test("a range a commitments screen refuses is told apart from a target and from its other refusals")
func aRangeACommitmentsScreenRefusesIsToldApartFromATargetAndFromItsOtherRefusals() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let moodRefusal = screen.define(
        name: "Mood", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number,
        lowest: "10", highest: "1")
    let proteinRefusal = screen.define(
        name: "Protein", on: dailyRhythm, keptFrom: monday, under: nil, kind: .total, target: "0")
    let blankRefusal = screen.define(
        name: "   ", on: dailyRhythm, keptFrom: monday, under: nil, kind: .tick)
    let financesRefusal = screen.define(
        name: "Finances", on: .dayOfMonth(32), keptFrom: monday, under: nil, kind: .tick)

    #expect(moodRefusal == .rangeIsNotARange)
    #expect(proteinRefusal == .targetIsNotATarget)
    #expect(blankRefusal == .namesNothing)
    #expect(financesRefusal == .rhythmOutOfRange)
    #expect(moodRefusal != proteinRefusal)
    #expect(moodRefusal != blankRefusal)
    #expect(moodRefusal != financesRefusal)
    #expect(proteinRefusal != blankRefusal)
    #expect(proteinRefusal != financesRefusal)
    #expect(blankRefusal != financesRefusal)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a commitments screen holds a refused range against defining a commitment")
func aCommitmentsScreenHoldsARefusedRangeAgainstDefiningACommitment() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(
        name: "Mood", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number,
        lowest: "10", highest: "1")

    #expect(screen.refusedChange == .defining(.rangeIsNotARange))

    _ = screen.define(
        name: "Protein", on: dailyRhythm, keptFrom: monday, under: nil, kind: .total, target: "0")

    #expect(screen.refusedChange == .defining(.targetIsNotATarget))
}

@MainActor
@Test("a commitment defined on an interval rhythm counts from the day it is kept from")
func aCommitmentDefinedOnAnIntervalRhythmCountsFromTheDayItIsKeptFrom() throws {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesdayFirstJuly = CalendarDate(year: 2026, month: 7, day: 1)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(
        name: "Contact lenses", on: .everyNDays(14),
        keptFrom: wednesdayFirstJuly, under: nil)

    let rosterStore = try RosterStore(at: rosterPlace)
    let commitment = rosterStore.roster.commitments[0]

    let fifteenthJuly = CalendarDate(year: 2026, month: 7, day: 15)!
    let secondJuly = CalendarDate(year: 2026, month: 7, day: 2)!
    let thirtiethJune = CalendarDate(year: 2026, month: 6, day: 30)!

    #expect(commitment.isDue(on: wednesdayFirstJuly))
    #expect(commitment.isDue(on: fifteenthJuly))
    #expect(!commitment.isDue(on: secondJuly))
    #expect(!commitment.isDue(on: thirtiethJune))
}

@MainActor
@Test("a commitments screen offers the day it was handed as the day to keep a commitment from")
func aCommitmentsScreenOffersTheDayItWasHandedAsTheDayToKeepACommitmentFrom() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.dayToKeepFrom == monday)
}

@MainActor
@Test("a commitments screen offers the tick kind for a new commitment")
func aCommitmentsScreenOffersTheTickKindForANewCommitment() throws {
    let emptyRosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let emptyScreen = CommitmentsScreen(asOf: monday, keepingRosterAt: emptyRosterPlace)

    #expect(emptyScreen.kindToOffer == .tick)

    let totalRosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let target = Commitment.Target(120)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: target))!
    let totalRosterStore = try RosterStore(at: totalRosterPlace)
    try totalRosterStore.add(protein)

    let totalScreen = CommitmentsScreen(asOf: monday, keepingRosterAt: totalRosterPlace)

    #expect(totalScreen.kindToOffer == .tick)
}

@MainActor
@Test("a commitments screen accepts a day to keep from that has not arrived and one long past")
func aCommitmentsScreenAcceptsADayToKeepFromThatHasNotArrivedAndOneLongPast() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let farFuture = CalendarDate(year: 9999, month: 12, day: 31)!
    let farPast = CalendarDate(year: 1583, month: 1, day: 1)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let gymRefusal = screen.define(name: "Gym", on: daily, keptFrom: farFuture, under: nil)
    let journalingRefusal = screen.define(name: "Journaling", on: daily, keptFrom: farPast, under: nil)

    #expect(gymRefusal == nil)
    #expect(journalingRefusal == nil)
    #expect(screen.kept.map(\.name) == ["Gym", "Journaling"])
}

@MainActor
@Test("a commitments screen refuses a commitment named with nothing but blank space")
func aCommitmentsScreenRefusesACommitmentNamedWithNothingButBlankSpace() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)

    #expect(refusal == .namesNothing)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a commitments screen refuses a weekday set with no days in it")
func aCommitmentsScreenRefusesAWeekdaySetWithNoDaysInIt() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "Gym", on: .weekdays([]), keptFrom: monday, under: nil)

    #expect(refusal == .dueOnNoDay)
    #expect(refusal != .namesNothing)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@Test("a weekday set with no days in it is still a schedule the rule engine accepts")
func aWeekdaySetWithNoDaysInItIsStillAScheduleTheRuleEngineAccepts() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let commitment = Commitment(name: "Gym", schedule: .weekdays([]), keptFrom: keptFrom)

    let dates = [
        CalendarDate(year: 2026, month: 1, day: 1)!,
        CalendarDate(year: 2026, month: 1, day: 2)!,
        CalendarDate(year: 2026, month: 1, day: 3)!,
        CalendarDate(year: 2026, month: 1, day: 4)!,
        CalendarDate(year: 2026, month: 1, day: 5)!,
        CalendarDate(year: 2026, month: 1, day: 6)!,
        CalendarDate(year: 2026, month: 1, day: 7)!,
        CalendarDate(year: 2026, month: 1, day: 8)!,
    ]

    #expect(commitment != nil)
    for date in dates {
        #expect(commitment?.isDue(on: date) == false)
    }
}

@MainActor
@Test("a commitments screen refuses nothing else about a name")
func aCommitmentsScreenRefusesNothingElseAboutAName() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let xRefusal = screen.define(name: "x", on: daily, keptFrom: monday, under: nil)
    let gymRefusal = screen.define(name: " Gym ", on: daily, keptFrom: monday, under: nil)
    let emojiRefusal = screen.define(name: "Gym 🏋️", on: daily, keptFrom: monday, under: nil)

    #expect(xRefusal == nil)
    #expect(gymRefusal == nil)
    #expect(emojiRefusal == nil)
    #expect(screen.kept.map(\.name) == ["x", " Gym ", "Gym 🏋️"])
}

@MainActor
@Test("a commitments screen refuses a commitment its roster is already keeping")
func aCommitmentsScreenRefusesACommitmentItsRosterIsAlreadyKeeping() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesAfterOpen = try Data(contentsOf: rosterPlace)

    let refusal = screen.define(
        name: "Gym", on: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom, under: nil)

    #expect(refusal == .alreadyKept)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpen)
}

@MainActor
@Test("a commitments screen that could not keep a new commitment says the roster could not be written")
func aCommitmentsScreenThatCouldNotKeepANewCommitmentSaysTheRosterCouldNotBeWritten() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    let rosterPlace = blocker.appendingPathComponent("roster.json")
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "Gym", on: daily, keptFrom: monday, under: nil)

    #expect(refusal == .notKept)
    #expect(refusal != .alreadyKept)
    #expect(screen.kept.isEmpty)
}

@MainActor
@Test("defining a commitment a commitments screen has stopped keeping takes it up again in the place it was taken on in")
func definingACommitmentACommitmentsScreenHasStoppedKeepingTakesItUpAgainInThePlaceItWasTakenOnIn()
    throws
{
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "Gym", on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
        keptFrom: keptFrom, under: nil)

    #expect(refusal == nil)
    #expect(screen.kept.map(\.name) == ["Water plants", "Gym", "Journaling"])
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a commitment a commitments screen refuses as already kept is not taken on a second time")
func aCommitmentACommitmentsScreenRefusesAsAlreadyKeptIsNotTakenOnASecondTime() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let firstRefusal = screen.define(
        name: "Gym",
        on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
        keptFrom: keptFrom, under: nil)
    let secondRefusal = screen.define(
        name: "Gym",
        on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
        keptFrom: keptFrom, under: nil)

    #expect(firstRefusal == .alreadyKept)
    #expect(secondRefusal == .alreadyKept)

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments.count == 1)
}

@MainActor
@Test("asking a commitments screen to stop keeping a commitment changes nothing until it is confirmed")
func askingACommitmentsScreenToStopKeepingACommitmentChangesNothingUntilItIsConfirmed() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesAfterOpen = try Data(contentsOf: rosterPlace)

    screen.askToStopKeeping(gym)

    #expect(screen.awaitingConfirmation == gym)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpen)
}

@MainActor
@Test("a stop a commitments screen has been asked for and then cancelled changes nothing")
func aStopACommitmentsScreenHasBeenAskedForAndThenCancelledChangesNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesAfterOpen = try Data(contentsOf: rosterPlace)

    screen.askToStopKeeping(gym)
    screen.cancelStopKeeping()

    #expect(screen.awaitingConfirmation == nil)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpen)
}

@MainActor
@Test("a commitments screen asked to stop a second commitment awaits confirmation of that one only")
func aCommitmentsScreenAskedToStopASecondCommitmentAwaitsConfirmationOfThatOneOnly() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    screen.askToStopKeeping(gym)
    screen.askToStopKeeping(journaling)
    screen.confirmStopKeeping()

    #expect(screen.stopped.map(\.name) == ["Journaling"])
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitment stopped through a commitments screen is kept until the day before the one the screen was handed")
func aCommitmentStoppedThroughACommitmentsScreenIsKeptUntilTheDayBeforeTheOneTheScreenWasHanded()
    throws
{
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    screen.askToStopKeeping(gym)
    screen.confirmStopKeeping()

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments(on: sunday).map(\.name) == ["Gym"])
    #expect(laterStore.roster.commitments(on: monday).isEmpty)
    #expect(laterStore.roster.commitments(on: tuesday).isEmpty)
}

@MainActor
@Test("a commitment stopped through a commitments screen moves from what it keeps to what it has stopped")
func aCommitmentStoppedThroughACommitmentsScreenMovesFromWhatItKeepsToWhatItHasStopped() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    screen.askToStopKeeping(gym)
    screen.confirmStopKeeping()

    #expect(screen.kept.map(\.name) == ["Water plants", "Journaling"])
    #expect(screen.stopped.map(\.name) == ["Gym"])
    #expect(screen.awaitingConfirmation == nil)
}

@MainActor
@Test("a commitments screen asked to stop keeping a commitment it does not keep does nothing")
func aCommitmentsScreenAskedToStopKeepingACommitmentItDoesNotKeepDoesNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    screen.askToStopKeeping(gym)
    #expect(screen.awaitingConfirmation == nil)
    let refusal = screen.confirmStopKeeping()

    #expect(refusal == nil)
    #expect(screen.awaitingConfirmation == nil)
    #expect(screen.stopped.map(\.name) == ["Gym"])

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments(on: sunday).map(\.name) == ["Gym"])
    #expect(laterStore.roster.commitments(on: monday).isEmpty)
}

@MainActor
@Test("a stop a commitments screen could not keep leaves both its lists as they were")
func aStopACommitmentsScreenCouldNotKeepLeavesBothItsListsAsTheyWere() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    screen.askToStopKeeping(gym)
    let refusal = screen.confirmStopKeeping()

    #expect(refusal == .notKept)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a commitment taken up again through a commitments screen moves from what it has stopped to what it keeps")
func aCommitmentTakenUpAgainThroughACommitmentsScreenMovesFromWhatItHasStoppedToWhatItKeeps() throws {
    // The fixture takes "Journaling" on first and "Gym" second, so "Gym"'s own place among the
    // kept ones is index 1, not index 0 — a mutant that took it up again by removing the entry
    // and inserting it at index 0 would read back the same order as a version added first ever
    // does, and this scenario would never redden. `design.md` § *Strengthened in place, and the
    // three proven by mutation*.
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(journaling)
    try rosterStore.add(gym)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    screen.keepAgain(gym)

    #expect(screen.kept.map(\.name) == ["Journaling", "Gym"])
    #expect(screen.stopped.isEmpty)

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments(on: tuesday).map(\.name).contains("Gym"))
}

@MainActor
@Test("taking a commitment up again through a commitments screen asks for no confirmation")
func takingACommitmentUpAgainThroughACommitmentsScreenAsksForNoConfirmation() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.awaitingConfirmation == nil)
    screen.keepAgain(gym)
    #expect(screen.awaitingConfirmation == nil)

    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitments screen asked to take up again a commitment it has not stopped does nothing")
func aCommitmentsScreenAskedToTakeUpAgainACommitmentItHasNotStoppedDoesNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesAfterOpen = try Data(contentsOf: rosterPlace)

    let refusal = screen.keepAgain(gym)

    #expect(refusal == nil)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpen)
}

/// Not a delta scenario — a unit test below the seam, added at G7 review because the scenario
/// above cannot tell `keepAgain`'s own guard apart from `RosterStore.add`'s: "Gym" there is
/// already kept, so `add` would refuse it as a duplicate whether or not the guard exists. A
/// commitment the roster has never held at all is refused only by the guard, so this is the input
/// that actually exercises it — without it, `keepAgain` would reach `rosterStore.add` and take on
/// a commitment nobody asked for.
@MainActor
@Test("a commitments screen asked to take up again a commitment it has never held does nothing")
func aCommitmentsScreenAskedToTakeUpAgainACommitmentItHasNeverHeldDoesNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesAfterOpen = try Data(contentsOf: rosterPlace)

    let refusal = screen.keepAgain(journaling)

    #expect(refusal == nil)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpen)
}

@MainActor
@Test("a commitments screen refuses a day of the month that is not one of the thirty-one")
func aCommitmentsScreenRefusesADayOfTheMonthThatIsNotOneOfTheThirtyOne() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let zerothRefusal = screen.define(name: "Finances", on: .dayOfMonth(0), keptFrom: monday, under: nil)
    let thirtySecondRefusal = screen.define(name: "Finances", on: .dayOfMonth(32), keptFrom: monday, under: nil)

    #expect(zerothRefusal == .rhythmOutOfRange)
    #expect(thirtySecondRefusal == .rhythmOutOfRange)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a commitments screen refuses an interval of fewer than one day")
func aCommitmentsScreenRefusesAnIntervalOfFewerThanOneDay() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let zeroRefusal = screen.define(name: "Contact lenses", on: .everyNDays(0), keptFrom: monday, under: nil)
    let negativeRefusal = screen.define(name: "Contact lenses", on: .everyNDays(-7), keptFrom: monday, under: nil)

    #expect(zeroRefusal == .rhythmOutOfRange)
    #expect(negativeRefusal == .rhythmOutOfRange)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a commitments screen refuses a weekly quota outside one to seven")
func aCommitmentsScreenRefusesAWeeklyQuotaOutsideOneToSeven() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let zeroRefusal = screen.define(name: "Reading", on: .weeklyQuota(0), keptFrom: monday, under: nil)
    let eightRefusal = screen.define(name: "Reading", on: .weeklyQuota(8), keptFrom: monday, under: nil)

    #expect(zeroRefusal == .rhythmOutOfRange)
    #expect(eightRefusal == .rhythmOutOfRange)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a rhythm number a commitments screen refuses is told apart from its other refusals")
func aRhythmNumberACommitmentsScreenRefusesIsToldApartFromItsOtherRefusals() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Set<Weekday> = [
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ]

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let financesRefusal = screen.define(name: "Finances", on: .dayOfMonth(32), keptFrom: monday, under: nil)
    let blankRefusal = screen.define(name: "   ", on: .weekdays(allWeekdays), keptFrom: monday, under: nil)
    let gymRefusal = screen.define(name: "Gym", on: .weekdays([]), keptFrom: monday, under: nil)

    #expect(financesRefusal == .rhythmOutOfRange)
    #expect(blankRefusal == .namesNothing)
    #expect(gymRefusal == .dueOnNoDay)
    #expect(financesRefusal != blankRefusal)
    #expect(financesRefusal != gymRefusal)
    #expect(blankRefusal != gymRefusal)
}

@MainActor
@Test("a commitments screen accepts the number at each end of what a rhythm allows")
func aCommitmentsScreenAcceptsTheNumberAtEachEndOfWhatARhythmAllows() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let rentRefusal = screen.define(name: "Rent", on: .dayOfMonth(1), keptFrom: monday, under: nil)
    let financesRefusal = screen.define(name: "Finances", on: .dayOfMonth(31), keptFrom: monday, under: nil)
    let shaveRefusal = screen.define(name: "Shave", on: .everyNDays(1), keptFrom: monday, under: nil)
    let longRunRefusal = screen.define(name: "Long run", on: .weeklyQuota(1), keptFrom: monday, under: nil)
    let stepsRefusal = screen.define(name: "Steps", on: .weeklyQuota(7), keptFrom: monday, under: nil)

    #expect(rentRefusal == nil)
    #expect(financesRefusal == nil)
    #expect(shaveRefusal == nil)
    #expect(longRunRefusal == nil)
    #expect(stepsRefusal == nil)
    #expect(screen.kept.map(\.name) == ["Rent", "Finances", "Shave", "Long run", "Steps"])
}

@MainActor
@Test("a commitments screen keeps its roster at the place a day screen keeps its")
func aCommitmentsScreenKeepsItsRosterAtThePlaceADayScreenKeepsIts() {
    #expect(CommitmentsScreen.rosterPlace == DayScreen.rosterPlace)

    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let screen = CommitmentsScreen(asOf: monday)

    #expect(screen.place == DayScreen.rosterPlace)
}

@MainActor
@Test("a commitment defined through a commitments screen is held by a day screen opened afterwards at the same place")
func aCommitmentDefinedThroughACommitmentsScreenIsHeldByADayScreenOpenedAfterwardsAtTheSamePlace() throws {
    let rosterPlace = freshRosterPlace()
    let recordPlace = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("record.json")
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.define(name: "Journaling", on: daily, keptFrom: monday, under: nil)

    #expect(refusal == nil)

    let dayScreen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: recordPlace, keepingRosterAt: rosterPlace)

    #expect(dayScreen.dayView.rows.map(\.name) == ["Journaling"])
}

@MainActor
@Test("a commitments screen shown again reads its roster again")
func aCommitmentsScreenShownAgainReadsItsRosterAgain() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.isEmpty)

    let other = try RosterStore(at: rosterPlace)
    try other.add(gym)

    screen.shown(asOf: monday)

    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitments screen shown again on a later day stops a commitment as of that later day")
func aCommitmentsScreenShownAgainOnALaterDayStopsACommitmentAsOfThatLaterDay() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    screen.shown(asOf: tuesday)

    screen.askToStopKeeping(gym)
    screen.confirmStopKeeping()

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments(on: monday).map(\.name) == ["Gym"])
    #expect(screen.dayToKeepFrom == tuesday)
}

@MainActor
@Test("a commitments screen that cannot read its roster lists nothing and says it is not keeping one")
func aCommitmentsScreenThatCannotReadItsRosterListsNothingAndSaysItIsNotKeepingOne() throws {
    let rosterPlace = freshRosterPlace()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a roster is written as".utf8).write(to: rosterPlace)
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.isEmpty)
    #expect(screen.stopped.isEmpty)
    #expect(screen.rosterState == .notKept)
}

@MainActor
@Test("a roster written in a later form than this app knows makes a commitments screen that says the roster is from a later version")
func aRosterWrittenInALaterFormThanThisAppKnowsMakesACommitmentsScreenThatSaysTheRosterIsFromALaterVersion()
    throws
{
    let rosterPlace = freshRosterPlace()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"version": 5, "commitments": []}"#.utf8).write(to: rosterPlace)
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.rosterState == .writtenByALaterVersion)
    #expect(screen.rosterState != .notKept)
    #expect(screen.kept.isEmpty)
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a commitments screen that cannot read its roster refuses a new commitment and leaves what is at the place as it was")
func aCommitmentsScreenThatCannotReadItsRosterRefusesANewCommitmentAndLeavesWhatIsAtThePlaceAsItWas()
    throws
{
    let rosterPlace = freshRosterPlace()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let originalBytes = Data("not what a roster is written as".utf8)
    try originalBytes.write(to: rosterPlace)
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let journaling = Commitment(name: "Journaling", schedule: .weekdays([.monday]), keptFrom: monday)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "Gym", on: daily, keptFrom: monday, under: nil)
    #expect(refusal == .notKept)

    screen.askToStopKeeping(journaling)
    let stopRefusal = screen.confirmStopKeeping()

    #expect(stopRefusal == nil)
    #expect(screen.awaitingConfirmation == nil)
    #expect(try Data(contentsOf: rosterPlace) == originalBytes)
}

@MainActor
@Test("a commitments screen that could not read its roster starts keeping one when it is shown again and the roster can be read")
func aCommitmentsScreenThatCouldNotReadItsRosterStartsKeepingOneWhenItIsShownAgainAndTheRosterCanBeRead()
    throws
{
    let rosterPlace = freshRosterPlace()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a roster is written as".utf8).write(to: rosterPlace)
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: rosterPlace)
    let recovered = try RosterStore(at: rosterPlace)
    try recovered.add(gym)

    screen.shown(asOf: monday)

    #expect(screen.rosterState == .kept)
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitments screen holds a refused definition against defining a commitment")
func aCommitmentsScreenHoldsARefusedDefinitionAgainstDefiningACommitment() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)

    #expect(refusal == .namesNothing)
    #expect(screen.refusedChange == .defining(.namesNothing))
}

@MainActor
@Test(
    "a commitments screen holds a refused take-up-again against the commitment it was asked to take up again"
)
func aCommitmentsScreenHoldsARefusedTakeUpAgainAgainstTheCommitmentItWasAskedToTakeUpAgain() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    let refusal = screen.keepAgain(gym)

    #expect(refusal == .notKept)
    #expect(screen.refusedChange == .keepingAgain(gym, .notKept))
}

@MainActor
@Test("a commitments screen refused twice holds only the change it was asked for last")
func aCommitmentsScreenRefusedTwiceHoldsOnlyTheChangeItWasAskedForLast() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)

    screen.askToStopKeeping(gym)
    let stopRefusal = screen.confirmStopKeeping()

    #expect(stopRefusal == .notKept)
    #expect(screen.refusedChange == .stopping(gym, .notKept))
    #expect(screen.refusedChange != .defining(.namesNothing))
}

@MainActor
@Test("a commitments screen holds nothing against a call that changes nothing at all")
func aCommitmentsScreenHoldsNothingAgainstACallThatChangesNothingAtAll() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    screen.askToStopKeeping(journaling)
    let stopRefusal = screen.confirmStopKeeping()
    let keepAgainRefusal = screen.keepAgain(gym)

    #expect(stopRefusal == nil)
    #expect(keepAgainRefusal == nil)
    #expect(screen.refusedChange == nil)
}

@MainActor
@Test("what a commitments screen holds about a refused change ends when the app is shown again")
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenTheAppIsShownAgain() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)
    #expect(screen.refusedChange != nil)

    screen.shown(asOf: monday)

    #expect(screen.refusedChange == nil)
    #expect(screen.rosterState == .kept)
}

@MainActor
@Test(
    "what a commitments screen holds about a refused change ends when the app is shown again where the roster then cannot be read"
)
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenTheAppIsShownAgainWhereTheRosterThenCannotBeRead()
    throws
{
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    screen.askToStopKeeping(gym)
    let stopRefusal = screen.confirmStopKeeping()
    #expect(stopRefusal == .notKept)
    #expect(screen.refusedChange != nil)

    screen.shown(asOf: monday)

    #expect(screen.refusedChange == nil)
    #expect(screen.rosterState == .notKept)
}

@MainActor
@Test("what a commitments screen holds about a refused change ends when a commitment is defined and kept")
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenACommitmentIsDefinedAndKept() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)
    #expect(screen.refusedChange != nil)

    let journalingRefusal = screen.define(name: "Journaling", on: allWeekdays, keptFrom: monday, under: nil)

    #expect(journalingRefusal == nil)
    #expect(screen.refusedChange == nil)
}

@MainActor
@Test("what a commitments screen holds about a refused change ends when a stop is kept")
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenAStopIsKept() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)
    #expect(screen.refusedChange != nil)

    screen.askToStopKeeping(gym)
    let stopRefusal = screen.confirmStopKeeping()

    #expect(stopRefusal == nil)
    #expect(screen.refusedChange == nil)
}

@MainActor
@Test(
    "what a commitments screen holds about a refused change ends when a commitment is taken up again and kept"
)
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenACommitmentIsTakenUpAgainAndKept() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)
    #expect(screen.refusedChange != nil)

    let keepAgainRefusal = screen.keepAgain(gym)

    #expect(keepAgainRefusal == nil)
    #expect(screen.refusedChange == nil)
}

@MainActor
@Test("what a commitments screen holds about a refused change stands when a call changes nothing at all")
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenACallChangesNothingAtAll() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)

    let secondKeepAgainRefusal = screen.keepAgain(gym)
    let secondStopRefusal = screen.confirmStopKeeping()

    #expect(secondKeepAgainRefusal == nil)
    #expect(secondStopRefusal == nil)
    #expect(screen.refusedChange == .defining(.namesNothing))
}

@MainActor
@Test("what a commitments screen holds about a refused change stands when a stop is asked for and cancelled")
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenAStopIsAskedForAndCancelled() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)

    screen.askToStopKeeping(gym)
    screen.cancelStopKeeping()

    #expect(screen.refusedChange == .defining(.namesNothing))
    #expect(screen.awaitingConfirmation == nil)
}

@MainActor
@Test("a commitment defined and stopped on one day through a commitments screen is kept on no day at all")
func aCommitmentDefinedAndStoppedOnOneDayThroughACommitmentsScreenIsKeptOnNoDayAtAll() throws {
    let rosterPlace = freshRosterPlace()
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "Gym", on: allWeekdays, keptFrom: monday, under: nil)
    #expect(refusal == nil)
    let gym = try #require(screen.kept.first)

    screen.askToStopKeeping(gym)
    screen.confirmStopKeeping()

    #expect(screen.kept.isEmpty)
    #expect(screen.stopped.map(\.name) == ["Gym"])

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments(on: monday).isEmpty)
    #expect(laterStore.roster.commitments(on: sunday).map(\.name) == ["Gym"])
    #expect(!gym.isDue(on: sunday))
}

@MainActor
@Test("a commitments screen handed the first supported date stops a commitment as of that day")
func aCommitmentsScreenHandedTheFirstSupportedDateStopsACommitmentAsOfThatDay() throws {
    let rosterPlace = freshRosterPlace()
    let firstSupported = CalendarDate(year: 1583, month: 1, day: 1)!
    let secondSupported = CalendarDate(year: 1583, month: 1, day: 2)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: firstSupported)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: firstSupported, keepingRosterAt: rosterPlace)

    screen.askToStopKeeping(gym)
    let refusal = screen.confirmStopKeeping()

    #expect(refusal == nil)
    #expect(screen.stopped.map(\.name) == ["Gym"])

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments(on: firstSupported).map(\.name) == ["Gym"])
    #expect(laterStore.roster.commitments(on: secondSupported).isEmpty)
}

@MainActor
@Test("asking a commitments screen to remove a commitment changes nothing until it is confirmed")
func askingACommitmentsScreenToRemoveACommitmentChangesNothingUntilItIsConfirmed() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    let bytesAfterOpening = try Data(contentsOf: rosterPlace)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    screen.askToRemove(gym)

    #expect(screen.awaitingRemoval == gym)
    #expect(screen.nameTypedBack == "")
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpening)
}

@MainActor
@Test("a commitments screen says a name typed back matches only when it is the commitment's name")
func aCommitmentsScreenSaysANameTypedBackMatchesOnlyWhenItIsTheCommitmentsName() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gym)

    screen.nameTypedBack = "G"
    #expect(!screen.nameTypedBackMatches)
    screen.nameTypedBack = "Gy"
    #expect(!screen.nameTypedBackMatches)
    screen.nameTypedBack = "Gym"
    #expect(screen.nameTypedBackMatches)
    screen.nameTypedBack = "Gymm"
    #expect(!screen.nameTypedBackMatches)
}

@MainActor
@Test("a name typed back with blank space at either end matches, and one differing in case does not")
func aNameTypedBackWithBlankSpaceAtEitherEndMatchesAndOneDifferingInCaseDoesNot() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gym)

    screen.nameTypedBack = "  Gym  "
    #expect(screen.nameTypedBackMatches)
    screen.nameTypedBack = "gym"
    #expect(!screen.nameTypedBackMatches)
    screen.nameTypedBack = "GYM"
    #expect(!screen.nameTypedBackMatches)
}

@MainActor
@Test("a name typed back differing in blank space inside the name does not match")
func aNameTypedBackDifferingInBlankSpaceInsideTheNameDoesNotMatch() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(waterPlants)

    screen.nameTypedBack = "Water  plants"
    #expect(!screen.nameTypedBackMatches)
    screen.nameTypedBack = "Waterplants"
    #expect(!screen.nameTypedBackMatches)
    screen.nameTypedBack = "Water plants"
    #expect(screen.nameTypedBackMatches)
}

@MainActor
@Test("a commitment whose name ends in a space is removed by typing the name without it")
func aCommitmentWhoseNameEndsInASpaceIsRemovedByTypingTheNameWithoutIt() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gymWithTrailingSpace = Commitment(name: "Gym ", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gymWithTrailingSpace)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gymWithTrailingSpace)
    screen.nameTypedBack = "Gym"

    #expect(screen.nameTypedBackMatches)

    let refusal = screen.confirmRemoving()

    #expect(refusal == nil)
    #expect(screen.kept.isEmpty)
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a commitment whose name ends in a newline is removed by typing the name without it")
func aCommitmentWhoseNameEndsInANewlineIsRemovedByTypingTheNameWithoutIt() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gymWithTrailingNewline = Commitment(name: "Gym\n", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gymWithTrailingNewline)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gymWithTrailingNewline)
    screen.nameTypedBack = "Gym"

    #expect(screen.nameTypedBackMatches)

    let refusal = screen.confirmRemoving()

    #expect(refusal == nil)
    #expect(screen.kept.isEmpty)
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a removal confirmed on a name that does not match changes nothing and refuses nothing")
func aRemovalConfirmedOnANameThatDoesNotMatchChangesNothingAndRefusesNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    let bytesAfterOpening = try Data(contentsOf: rosterPlace)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gym)
    screen.nameTypedBack = "gym"

    let refusal = screen.confirmRemoving()

    #expect(refusal == nil)
    #expect(screen.awaitingRemoval == gym)
    #expect(screen.nameTypedBack == "gym")
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpening)
}

@MainActor
@Test("a removal confirmed with nothing awaiting removal changes nothing")
func aRemovalConfirmedWithNothingAwaitingRemovalChangesNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    let bytesAfterOpening = try Data(contentsOf: rosterPlace)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.confirmRemoving()

    #expect(refusal == nil)
    #expect(screen.awaitingRemoval == nil)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpening)
}

@MainActor
@Test("a kept commitment removed through a commitments screen is kept until the day before the one the screen was handed")
func aKeptCommitmentRemovedThroughACommitmentsScreenIsKeptUntilTheDayBeforeTheOneTheScreenWasHanded()
    throws
{
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"
    screen.confirmRemoving()

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments(on: sunday).map(\.name) == ["Gym"])
    #expect(laterStore.roster.commitments(on: monday).isEmpty)
    #expect(laterStore.roster.commitments(on: tuesday).isEmpty)
}

@MainActor
@Test("a stopped commitment removed through a commitments screen keeps the day it was already kept until")
func aStoppedCommitmentRemovedThroughACommitmentsScreenKeepsTheDayItWasAlreadyKeptUntil() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let stoppedAt = CalendarDate(year: 2026, month: 8, day: 23)!
    let dayAfterStopped = CalendarDate(year: 2026, month: 8, day: 24)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.retire(gym, keptUntil: stoppedAt)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"
    screen.confirmRemoving()

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments(on: stoppedAt).map(\.name) == ["Gym"])
    #expect(laterStore.roster.commitments(on: dayAfterStopped).isEmpty)
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a commitment removed through a commitments screen is in neither of its lists")
func aCommitmentRemovedThroughACommitmentsScreenIsInNeitherOfItsLists() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"
    screen.confirmRemoving()

    #expect(screen.kept.map(\.name) == ["Water plants", "Journaling"])
    #expect(screen.stopped.isEmpty)
    #expect(screen.awaitingRemoval == nil)
    #expect(screen.nameTypedBack == "")
}

@MainActor
@Test("a removal a commitments screen has been asked for and then cancelled changes nothing")
func aRemovalACommitmentsScreenHasBeenAskedForAndThenCancelledChangesNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    let bytesAfterOpening = try Data(contentsOf: rosterPlace)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"

    screen.cancelRemoving()

    #expect(screen.awaitingRemoval == nil)
    #expect(screen.nameTypedBack == "")
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
    #expect(try Data(contentsOf: rosterPlace) == bytesAfterOpening)
}

@MainActor
@Test("a commitments screen asked to remove a second commitment awaits removal of that one only")
func aCommitmentsScreenAskedToRemoveASecondCommitmentAwaitsRemovalOfThatOneOnly() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"

    screen.askToRemove(journaling)

    #expect(screen.awaitingRemoval == journaling)
    #expect(screen.nameTypedBack == "")

    let refusal = screen.confirmRemoving()
    #expect(refusal == nil)
    #expect(screen.awaitingRemoval == journaling)
    #expect(screen.kept.map(\.name) == ["Gym", "Journaling"])
}

@MainActor
@Test("a commitments screen asked to remove a commitment on neither of its lists does nothing")
func aCommitmentsScreenAskedToRemoveACommitmentOnNeitherOfItsListsDoesNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(journaling)

    #expect(screen.awaitingRemoval == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a removal a commitments screen could not keep leaves both its lists as they were")
func aRemovalACommitmentsScreenCouldNotKeepLeavesBothItsListsAsTheyWere() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    let refusal = screen.confirmRemoving()

    #expect(refusal == .notKept)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("asking a commitments screen to remove a commitment leaves no stop awaiting confirmation")
func askingACommitmentsScreenToRemoveACommitmentLeavesNoStopAwaitingConfirmation() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToStopKeeping(gym)

    screen.askToRemove(gym)

    #expect(screen.awaitingConfirmation == nil)
    #expect(screen.awaitingRemoval == gym)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("asking a commitments screen to stop keeping a commitment leaves nothing awaiting removal")
func askingACommitmentsScreenToStopKeepingACommitmentLeavesNothingAwaitingRemoval() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gym)

    screen.askToStopKeeping(gym)

    #expect(screen.awaitingRemoval == nil)
    #expect(screen.awaitingConfirmation == gym)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a commitments screen shown again leaves nothing awaiting removal and nothing typed back")
func aCommitmentsScreenShownAgainLeavesNothingAwaitingRemovalAndNothingTypedBack() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"

    screen.shown(asOf: tuesday)

    #expect(screen.awaitingRemoval == nil)
    #expect(screen.nameTypedBack == "")
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitments screen handed the first supported date removes a kept commitment as of that day")
func aCommitmentsScreenHandedTheFirstSupportedDateRemovesAKeptCommitmentAsOfThatDay() throws {
    let rosterPlace = freshRosterPlace()
    let firstSupported = CalendarDate(year: 1583, month: 1, day: 1)!
    let secondSupported = CalendarDate(year: 1583, month: 1, day: 2)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: firstSupported)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: firstSupported, keepingRosterAt: rosterPlace)
    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"
    let refusal = screen.confirmRemoving()

    #expect(refusal == nil)
    #expect(!screen.kept.contains(gym))
    #expect(!screen.stopped.contains(gym))

    let laterStore = try RosterStore(at: rosterPlace)
    #expect(laterStore.roster.commitments(on: firstSupported).map(\.name) == ["Gym"])
    #expect(laterStore.roster.commitments(on: secondSupported).isEmpty)
}

@MainActor
@Test("a commitments screen lists a commitment its roster has removed in neither of its lists")
func aCommitmentsScreenListsACommitmentItsRosterHasRemovedInNeitherOfItsLists() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.remove(gym, keptUntil: sunday)
    try rosterStore.retire(journaling, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.map(\.name) == ["Water plants"])
    #expect(screen.stopped.map(\.name) == ["Journaling"])
    #expect(!screen.kept.contains(gym))
    #expect(!screen.stopped.contains(gym))
}

@MainActor
@Test("removing one of two entries alike in name removes the one it was asked about")
func removingOneOfTwoEntriesAlikeInNameRemovesTheOneItWasAskedAbout() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let vitaminsMondayWednesday = Commitment(
        name: "Vitamins", schedule: .weekdays([.monday, .wednesday]), keptFrom: keptFrom)!
    let vitaminsTuesdayThursday = Commitment(
        name: "Vitamins", schedule: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(vitaminsMondayWednesday)
    try rosterStore.add(vitaminsTuesdayThursday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(vitaminsTuesdayThursday)
    screen.nameTypedBack = "Vitamins"
    screen.confirmRemoving()

    #expect(screen.kept.map(\.name) == ["Vitamins"])
    #expect(screen.kept.map(\.rhythmInWords) == ["Mon, Wed"])
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a commitment defined again after being removed is taken up again in the place it was taken on in")
func aCommitmentDefinedAgainAfterBeingRemovedIsTakenUpAgainInThePlaceItWasTakenOnIn() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.remove(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "Gym",
        on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(refusal == nil)
    #expect(screen.kept.map(\.name) == ["Water plants", "Gym", "Journaling"])
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a commitments screen that cannot read its roster does nothing when it is asked to remove a commitment")
func aCommitmentsScreenThatCannotReadItsRosterDoesNothingWhenItIsAskedToRemoveACommitment() throws {
    let rosterPlace = freshRosterPlace()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let originalBytes = Data("not what a roster is written as".utf8)
    try originalBytes.write(to: rosterPlace)
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    screen.askToRemove(gym)

    #expect(screen.awaitingRemoval == nil)
    #expect(screen.refusedChange == nil)
    #expect(try Data(contentsOf: rosterPlace) == originalBytes)
}

@MainActor
@Test("a commitments screen holds a refused removal against the commitment it was asked to remove")
func aCommitmentsScreenHoldsARefusedRemovalAgainstTheCommitmentItWasAskedToRemove() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    let refusal = screen.confirmRemoving()

    #expect(refusal == .notKept)
    #expect(screen.refusedChange == .removing(gym, .notKept))
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitments screen holds nothing against a removal confirmed on a name that does not match")
func aCommitmentsScreenHoldsNothingAgainstARemovalConfirmedOnANameThatDoesNotMatch() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(
        name: "Gym",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let defineRefusal = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)
    #expect(defineRefusal == .namesNothing)

    screen.askToRemove(gym)
    screen.nameTypedBack = "Gymm"

    let refusal = screen.confirmRemoving()

    #expect(refusal == nil)
    #expect(screen.refusedChange == .defining(.namesNothing))
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.awaitingRemoval == gym)
}

@MainActor
@Test("what a commitments screen holds about a refused change ends when a removal is kept")
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenARemovalIsKept() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(
        name: "Gym",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)

    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"
    let refusal = screen.confirmRemoving()

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(!screen.kept.contains(gym))
    #expect(!screen.stopped.contains(gym))
}

@MainActor
@Test("what a commitments screen holds about a refused change stands when a removal is asked for and cancelled")
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenARemovalIsAskedForAndCancelled() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(
        name: "Gym",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)

    screen.askToRemove(gym)
    screen.nameTypedBack = "Gym"
    screen.cancelRemoving()

    #expect(screen.refusedChange == .defining(.namesNothing))
    #expect(screen.awaitingRemoval == nil)
    #expect(screen.nameTypedBack == "")
}

@MainActor
@Test("what a commitments screen has stopped is in the order its roster holds them")
func whatACommitmentsScreenHasStoppedIsInTheOrderItsRosterHoldsThem() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.move(journaling, toOffset: 0, under: nil)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToStopKeeping(journaling)
    screen.confirmStopKeeping()
    screen.askToStopKeeping(waterPlants)
    screen.confirmStopKeeping()

    #expect(screen.stopped.map(\.name) == ["Journaling", "Water plants"])
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("moving a commitment leaves a stop awaiting confirmation exactly as it was")
func movingACommitmentLeavesAStopAwaitingConfirmationExactlyAsItWas() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToStopKeeping(gym)
    let moved = screen.move(journaling, toOffset: 0, under: nil)

    #expect(moved == nil)
    #expect(screen.awaitingConfirmation == gym)
    #expect(screen.kept.map(\.name) == ["Journaling", "Gym"])

    screen.confirmStopKeeping()

    #expect(screen.kept.map(\.name) == ["Journaling"])
}

@MainActor
@Test("a commitments screen that cannot read its roster does nothing when it is asked to move a commitment")
func aCommitmentsScreenThatCannotReadItsRosterDoesNothingWhenItIsAskedToMoveACommitment() throws {
    let rosterPlace = freshRosterPlace()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let originalBytes = Data("not what a roster is written as".utf8)
    try originalBytes.write(to: rosterPlace)
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let moved = screen.move(gym, toOffset: 0, under: nil)

    #expect(moved == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.rosterState == .notKept)
    #expect(try Data(contentsOf: rosterPlace) == originalBytes)
}

@MainActor
@Test("a commitments screen holds a refused move against the commitment it was asked to move")
func aCommitmentsScreenHoldsARefusedMoveAgainstTheCommitmentItWasAskedToMove() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    let refusal = screen.move(journaling, toOffset: 0, under: nil)

    #expect(refusal == .notKept)
    #expect(screen.refusedChange == .moving(journaling, .notKept))
    #expect(screen.kept.map(\.name) == ["Gym", "Journaling"])
}

@MainActor
@Test("a commitments screen holds nothing against a move that asks for no change at all")
func aCommitmentsScreenHoldsNothingAgainstAMoveThatAsksForNoChangeAtAll() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let movedNeverTakenOn = screen.move(journaling, toOffset: 0, under: nil)
    let movedOutsideTheList = screen.move(gym, toOffset: 2, under: nil)

    #expect(movedNeverTakenOn == nil)
    #expect(movedOutsideTheList == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("what a commitments screen holds about a refused change ends when a move is kept")
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenAMoveIsKept() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)

    let refusal = screen.move(journaling, toOffset: 0, under: nil)

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.kept.map(\.name) == ["Journaling", "Gym"])
}

@MainActor
@Test("what a commitments screen holds about a refused change stands when a move drops a commitment where it already is")
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenAMoveDropsACommitmentWhereItAlreadyIs()
    throws
{
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)

    let refusal = screen.move(journaling, toOffset: 2, under: nil)

    #expect(refusal == nil)
    #expect(screen.refusedChange == .defining(.namesNothing))
    #expect(screen.kept.map(\.name) == ["Gym", "Journaling"])
}

@MainActor
@Test("a commitment moved through a commitments screen is where it was dropped, and is kept there")
func aCommitmentMovedThroughACommitmentsScreenIsWhereItWasDroppedAndIsKeptThere() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.move(journaling, toOffset: 0, under: nil)

    #expect(refusal == nil)
    #expect(screen.kept.map(\.name) == ["Journaling", "Water plants", "Gym"])

    let later = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(later.kept.map(\.name) == ["Journaling", "Water plants", "Gym"])
}

@MainActor
@Test("an offset a commitments screen is given is counted over what it keeps before the move")
func anOffsetACommitmentsScreenIsGivenIsCountedOverWhatItKeepsBeforeTheMove() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    func neverMoved() throws -> CommitmentsScreen {
        let rosterPlace = freshRosterPlace()
        let rosterStore = try RosterStore(at: rosterPlace)
        try rosterStore.add(waterPlants)
        try rosterStore.add(gym)
        try rosterStore.add(journaling)
        return CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    }

    let atOffsetTwo = try neverMoved()
    _ = atOffsetTwo.move(waterPlants, toOffset: 2, under: nil)

    let atOffsetThree = try neverMoved()
    _ = atOffsetThree.move(waterPlants, toOffset: 3, under: nil)

    #expect(atOffsetTwo.kept.map(\.name) == ["Gym", "Water plants", "Journaling"])
    #expect(atOffsetThree.kept.map(\.name) == ["Gym", "Journaling", "Water plants"])
}

@MainActor
@Test("a commitments screen asked to move a commitment it has stopped does nothing and says nothing")
func aCommitmentsScreenAskedToMoveACommitmentItHasStoppedDoesNothingAndSaysNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.move(gym, toOffset: 0, under: nil)

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.kept.map(\.name) == ["Journaling"])
    #expect(screen.stopped.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitments screen asked to move a commitment on neither of its lists does nothing and says nothing")
func aCommitmentsScreenAskedToMoveACommitmentOnNeitherOfItsListsDoesNothingAndSaysNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.move(journaling, toOffset: 0, under: nil)

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitments screen given an offset the list it keeps does not have does nothing and says nothing")
func aCommitmentsScreenGivenAnOffsetTheListItKeepsDoesNotHaveDoesNothingAndSaysNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let movedPastTheEnd = screen.move(gym, toOffset: 3, under: nil)

    #expect(movedPastTheEnd == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.kept.map(\.name) == ["Gym", "Journaling"])

    let movedBelowZero = screen.move(gym, toOffset: -1, under: nil)

    #expect(movedBelowZero == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.kept.map(\.name) == ["Gym", "Journaling"])
}

@MainActor
@Test("a move a commitments screen could not keep leaves both its lists as they were")
func aMoveACommitmentsScreenCouldNotKeepLeavesBothItsListsAsTheyWere() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    let refusal = screen.move(journaling, toOffset: 0, under: nil)

    #expect(refusal == .notKept)
    #expect(screen.kept.map(\.name) == ["Gym", "Journaling"])
    #expect(screen.stopped == [])
}

@MainActor
@Test("a move that drops a commitment where it already is changes nothing and refuses nothing")
func aMoveThatDropsACommitmentWhereItAlreadyIsChangesNothingAndRefusesNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesBeforeMove = try Data(contentsOf: rosterPlace)

    let refusal = screen.move(journaling, toOffset: 2, under: nil)

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.kept.map(\.name) == ["Gym", "Journaling"])
    #expect(try Data(contentsOf: rosterPlace) == bytesBeforeMove)
}

@MainActor
@Test("a commitments screen shown again lists what it keeps in the order it was moved into")
func aCommitmentsScreenShownAgainListsWhatItKeepsInTheOrderItWasMovedInto() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.move(journaling, toOffset: 0, under: nil)
    screen.shown(asOf: tuesday)

    #expect(screen.kept.map(\.name) == ["Journaling", "Water plants", "Gym"])
}

@MainActor
@Test("a commitment moved and then stopped through a commitments screen keeps the place it was moved to")
func aCommitmentMovedAndThenStoppedThroughACommitmentsScreenKeepsThePlaceItWasMovedTo() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.move(journaling, toOffset: 0, under: nil)
    screen.askToStopKeeping(journaling)
    screen.confirmStopKeeping()

    #expect(screen.kept.map(\.name) == ["Water plants", "Gym"])
    #expect(screen.stopped.map(\.name) == ["Journaling"])

    let later = try RosterStore(at: rosterPlace)

    #expect(later.roster.commitments(on: sunday) == [journaling, waterPlants, gym])
}

@MainActor
@Test("a commitments screen draws what it keeps in groups, one per category")
func aCommitmentsScreenDrawsWhatItKeepsInGroupsOnePerCategory() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let finances = Commitment(name: "Finances", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.add(magnesium)
    try rosterStore.add(finances)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(magnesium, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: nil, commitments: [finances]),
            ])
    #expect(screen.kept == [creatine, magnesium, gym, finances])
}

@MainActor
@Test("a group sits where its first commitment sits in the order the person set")
func aGroupSitsWhereItsFirstCommitmentSitsInTheOrderThePersonSet() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.add(magnesium)
    try rosterStore.put(gym, under: "Sport")
    try rosterStore.put(magnesium, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let groups = screen.keptGroups

    #expect(
        groups
            == [
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: "Supplements", commitments: [magnesium]),
                Roster.Group(category: nil, commitments: [creatine]),
            ])
    #expect(groups.map(\.category) != groups.map(\.category).sorted { ($0 ?? "") < ($1 ?? "") })
}

@MainActor
@Test("a commitments screen whose commitments are none of them under a category draws one group")
func aCommitmentsScreenWhoseCommitmentsAreNoneOfThemUnderACategoryDrawsOneGroup() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(
        screen.keptGroups
            == [Roster.Group(category: nil, commitments: [waterPlants, gym, journaling])])
}

@MainActor
@Test("a commitment given a category is drawn in that group and returns when the category is taken off")
func aCommitmentGivenACategoryIsDrawnInThatGroupAndReturnsWhenTheCategoryIsTakenOff() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.add(magnesium)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.change(
        magnesium, toName: "Magnesium", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: "Supplements")

    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [magnesium]),
                Roster.Group(category: nil, commitments: [creatine, gym]),
            ])

    _ = screen.change(
        magnesium, toName: "Magnesium", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(
        screen.keptGroups
            == [Roster.Group(category: nil, commitments: [creatine, gym, magnesium])])
}

@MainActor
@Test("what a commitments screen has stopped is one flat list whatever categories its commitments are under")
func whatACommitmentsScreenHasStoppedIsOneFlatListWhateverCategoriesItsCommitmentsAreUnder() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.add(magnesium)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(magnesium, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")
    try rosterStore.retire(creatine, keptUntil: sunday)
    try rosterStore.retire(gym, keptUntil: sunday)
    try rosterStore.retire(magnesium, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.stopped.map(\.name) == ["Creatine", "Gym", "Magnesium"])
    #expect(screen.keptGroups.isEmpty)
}

@MainActor
@Test("a stopped commitment taken up again is drawn in the group of the category it was under")
func aStoppedCommitmentTakenUpAgainIsDrawnInTheGroupOfTheCategoryItWasUnder() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.retire(creatine, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.keepAgain(creatine)

    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a commitments screen offers the categories the commitments it keeps are under, each once")
func aCommitmentsScreenOffersTheCategoriesTheCommitmentsItKeepsAreUnderEachOnce() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let finances = Commitment(name: "Finances", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.add(magnesium)
    try rosterStore.add(finances)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(magnesium, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.categoriesInUse == ["Supplements", "Sport"])
    #expect(screen.categoriesInUse.filter { $0 == "Supplements" }.count == 1)
}

@MainActor
@Test("a commitments screen keeping nothing under a category offers none")
func aCommitmentsScreenKeepingNothingUnderACategoryOffersNone() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.categoriesInUse.isEmpty)
    #expect(
        screen.keptGroups == [Roster.Group(category: nil, commitments: [gym, journaling])])
}

@MainActor
@Test("a commitments screen offers no category that only a commitment it has stopped is under")
func aCommitmentsScreenOffersNoCategoryThatOnlyACommitmentItHasStoppedIsUnder() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.retire(creatine, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.categoriesInUse.isEmpty)

    _ = screen.keepAgain(creatine)

    #expect(screen.categoriesInUse == ["Supplements"])
}

@MainActor
@Test("a category no longer under any commitment kept is no longer offered")
func aCategoryNoLongerUnderAnyCommitmentKeptIsNoLongerOffered() throws {
    let rosterPlace = freshRosterPlace()
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
    try rosterStore.put(creatine, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.change(
        creatine, toName: "Creatine", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: "Morning")

    #expect(screen.categoriesInUse == ["Morning"])
    #expect(!screen.categoriesInUse.contains("Supplements"))
}

@MainActor
@Test("a commitments screen does not fold the case of a category it is given")
func aCommitmentsScreenDoesNotFoldTheCaseOfACategoryItIsGiven() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(magnesium)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.change(
        creatine, toName: "Creatine", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: "Supplements")
    _ = screen.change(
        magnesium, toName: "Magnesium", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: "supplements")

    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "supplements", commitments: [magnesium]),
            ])
    #expect(screen.categoriesInUse == ["Supplements", "supplements"])
}

@MainActor
@Test("a commitment defined under a category is drawn in that category's group and kept under it")
func aCommitmentDefinedUnderACategoryIsDrawnInThatCategorysGroupAndKeptUnderIt() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.define(
        name: "Creatine", on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]), keptFrom: monday, under: "Supplements")

    #expect(refusal == nil)
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: monday)!
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])

    let later = try RosterStore(at: rosterPlace)
    #expect(
        later.roster.groups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
}

@MainActor
@Test("a commitment defined under a category of nothing but blank space is under none and is not refused")
func aCommitmentDefinedUnderACategoryOfNothingButBlankSpaceIsUnderNoneAndIsNotRefused() throws {
    let rosterPlace = freshRosterPlace()
    let daily: Schedule = .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday])
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.define(
        name: "Gym", on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]), keptFrom: monday, under: "   ")

    #expect(refusal == nil)
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: monday)!
    #expect(screen.keptGroups == [Roster.Group(category: nil, commitments: [gym])])

    let secondRefusal = screen.define(
        name: "Journaling", on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]), keptFrom: monday, under: "")

    #expect(secondRefusal == nil)
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: monday)!
    #expect(
        screen.keptGroups == [Roster.Group(category: nil, commitments: [gym, journaling])])
}

@MainActor
@Test("a commitment defined again after being removed takes the category the form carried")
func aCommitmentDefinedAgainAfterBeingRemovedTakesTheCategoryTheFormCarried() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterPlace = freshRosterPlace()
    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.remove(creatine, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.define(
        name: "Creatine", on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]), keptFrom: keptFrom, under: "Morning")

    #expect(refusal == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Morning", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])

    let uncategorisedRosterPlace = freshRosterPlace()
    let uncategorisedStore = try RosterStore(at: uncategorisedRosterPlace)
    try uncategorisedStore.add(creatine)
    try uncategorisedStore.add(gym)
    try uncategorisedStore.put(creatine, under: "Supplements")
    try uncategorisedStore.remove(creatine, keptUntil: sunday)

    let uncategorisedScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: uncategorisedRosterPlace)
    _ = uncategorisedScreen.define(
        name: "Creatine", on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]), keptFrom: keptFrom, under: nil)

    #expect(
        uncategorisedScreen.keptGroups
            == [Roster.Group(category: nil, commitments: [creatine, gym])])
}

@MainActor
@Test("a category is kept exactly as it was typed on the form")
func aCategoryIsKeptExactlyAsItWasTypedOnTheForm() throws {
    let rosterPlace = freshRosterPlace()
    let daily: Schedule = .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday])
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let creatineRefusal = screen.define(
        name: "Creatine", on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]), keptFrom: monday, under: " Supplements ")
    let magnesiumRefusal = screen.define(
        name: "Magnesium", on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]), keptFrom: monday, under: "Supplements")

    #expect(creatineRefusal == nil)
    #expect(magnesiumRefusal == nil)
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: monday)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: monday)!
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: " Supplements ", commitments: [creatine]),
                Roster.Group(category: "Supplements", commitments: [magnesium]),
            ])
}

@MainActor
@Test("a commitments screen holds a refused category change against the commitment it was asked about")
func aCommitmentsScreenHoldsARefusedCategoryChangeAgainstTheCommitmentItWasAskedAbout() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    let refusal = screen.change(
        gym, toName: "Gym", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: "Sport")

    #expect(refusal == .notKept)
    #expect(screen.refusedChange == .changing(gym, .notKept))
    #expect(screen.keptGroups == [Roster.Group(category: nil, commitments: [gym])])
}

@MainActor
@Test("a commitments screen holds nothing against a category change that asks for no change at all")
func aCommitmentsScreenHoldsNothingAgainstACategoryChangeThatAsksForNoChangeAtAll() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let defineRefusal = screen.define(
        name: "   ", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: monday, under: nil)

    #expect(defineRefusal == .namesNothing)

    let categoryRefusal = screen.change(
        gym, toName: "Gym", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: "Sport")

    #expect(categoryRefusal == nil)
    #expect(screen.refusedChange == .defining(.namesNothing))
    #expect(screen.keptGroups == [Roster.Group(category: "Sport", commitments: [gym])])
}

@MainActor
@Test("a commitments screen that cannot read its roster does nothing when it is asked to put a commitment under a category")
func aCommitmentsScreenThatCannotReadItsRosterDoesNothingWhenItIsAskedToPutACommitmentUnderACategory()
    throws
{
    let rosterPlace = freshRosterPlace()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let originalBytes = Data("not what a roster is written as".utf8)
    try originalBytes.write(to: rosterPlace)
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.change(
        gym, toName: "Gym", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: "Sport")

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.rosterState == .notKept)
    #expect(screen.keptGroups.isEmpty)
    #expect(screen.categoriesInUse.isEmpty)
    #expect(try Data(contentsOf: rosterPlace) == originalBytes)
}

@MainActor
@Test("an offset a commitments screen is given is counted over the group a drop landed in and not over the roster's own order")
func anOffsetACommitmentsScreenIsGivenIsCountedOverTheGroupADropLandedInAndNotOverTheRostersOwnOrder()
    throws
{
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    func freshScreen() throws -> (screen: CommitmentsScreen, place: URL) {
        let rosterPlace = freshRosterPlace()
        let rosterStore = try RosterStore(at: rosterPlace)
        try rosterStore.add(gym)
        try rosterStore.add(creatine)
        try rosterStore.add(magnesium)
        try rosterStore.put(creatine, under: "Supplements")
        try rosterStore.put(magnesium, under: "Supplements")
        return (CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace), rosterPlace)
    }

    let (screen, rosterPlace) = try freshScreen()
    let refusal = screen.move(gym, toOffset: 1, under: "Supplements")

    #expect(refusal == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(
                    category: "Supplements", commitments: [creatine, gym, magnesium])
            ])

    let later = try RosterStore(at: rosterPlace)
    #expect(
        later.roster.groups
            == [
                Roster.Group(
                    category: "Supplements", commitments: [creatine, gym, magnesium])
            ])

    let (alikeScreen, _) = try freshScreen()
    let alikeRefusal = alikeScreen.move(gym, toOffset: 3, under: "Supplements")

    #expect(alikeRefusal == nil)
    #expect(
        alikeScreen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
}

@MainActor
@Test("a commitment dropped among the entries under no category has its category taken off")
func aCommitmentDroppedAmongTheEntriesUnderNoCategoryHasItsCategoryTakenOff() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.put(creatine, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.move(creatine, toOffset: 2, under: nil)

    #expect(refusal == nil)
    #expect(
        screen.keptGroups
            == [Roster.Group(category: nil, commitments: [gym, journaling, creatine])])
}

@MainActor
@Test("a drop where a commitment is already drawn changes neither its place nor its category")
func aDropWhereACommitmentIsAlreadyDrawnChangesNeitherItsPlaceNorItsCategory() throws {
    let rosterPlace = freshRosterPlace()
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
    try rosterStore.put(creatine, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesBeforeMove = try Data(contentsOf: rosterPlace)

    let refusal = screen.move(creatine, toOffset: 1, under: "Supplements")

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])

    let secondRefusal = screen.move(creatine, toOffset: 0, under: "Supplements")

    #expect(secondRefusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
    #expect(try Data(contentsOf: rosterPlace) == bytesBeforeMove)
}

@MainActor
@Test("a commitment dropped after the last entry of a group is drawn at the end of that group")
func aCommitmentDroppedAfterTheLastEntryOfAGroupIsDrawnAtTheEndOfThatGroup() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(magnesium)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(magnesium, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")
    try rosterStore.put(journaling, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.move(journaling, toOffset: 2, under: "Supplements")

    #expect(refusal == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(
                    category: "Supplements", commitments: [creatine, magnesium, journaling]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
    #expect(screen.keptGroups.first { $0.category == "Sport" }?.commitments == [gym])
}

@MainActor
@Test("a commitments screen asked to move a commitment into a group it draws none of does nothing and says nothing")
func aCommitmentsScreenAskedToMoveACommitmentIntoAGroupItDrawsNoneOfDoesNothingAndSaysNothing() throws {
    let rosterPlace = freshRosterPlace()
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
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(gym, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesBeforeMove = try Data(contentsOf: rosterPlace)

    let refusal = screen.move(gym, toOffset: 0, under: nil)

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [Roster.Group(category: "Supplements", commitments: [creatine, gym])])

    let secondRefusal = screen.move(gym, toOffset: 0, under: "Sport")

    #expect(secondRefusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [Roster.Group(category: "Supplements", commitments: [creatine, gym])])
    #expect(try Data(contentsOf: rosterPlace) == bytesBeforeMove)
}

@MainActor
@Test("moving a group's only entry into another group leaves one heading fewer")
func movingAGroupsOnlyEntryIntoAnotherGroupLeavesOneHeadingFewer() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.move(gym, toOffset: 0, under: "Supplements")

    #expect(refusal == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [gym, creatine]),
                Roster.Group(category: nil, commitments: [journaling]),
            ])
    #expect(!screen.keptGroups.contains { $0.category == "Sport" })
}

@MainActor
@Test("what a commitments screen holds about a refused change ends when a category change is kept")
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenACategoryChangeIsKept() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)

    let refusal = screen.change(gym, toName: "Gym", on: daily, keptFrom: keptFrom, under: "Sport")

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.keptGroups == [Roster.Group(category: "Sport", commitments: [gym])])
}

@MainActor
@Test("what a commitments screen holds about a refused change stands when a category change puts a commitment under the category it is already under")
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenACategoryChangePutsACommitmentUnderTheCategoryItIsAlreadyUnder()
    throws
{
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)

    let refusal = screen.change(gym, toName: "Gym", on: daily, keptFrom: keptFrom, under: "Sport")

    #expect(refusal == nil)
    #expect(screen.refusedChange == .defining(.namesNothing))
}

@MainActor
@Test("a group moved through a commitments screen is drawn where it was moved to, and is kept there")
func aGroupMovedThroughACommitmentsScreenIsDrawnWhereItWasMovedToAndIsKeptThere() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(creatine)
    try rosterStore.add(magnesium)
    try rosterStore.put(gym, under: "Sport")
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(magnesium, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.move(group: "Supplements", toOffset: 0)

    #expect(refusal == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])

    let later = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(
        later.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
}

@MainActor
@Test("an offset a commitments screen is given for a group is counted over the groups it draws that are under a category")
func anOffsetACommitmentsScreenIsGivenForAGroupIsCountedOverTheGroupsItDrawsThatAreUnderACategory()
    throws
{
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let waterPlants = Commitment(name: "Water plants", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let finances = Commitment(name: "Finances", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    func neverMoved() throws -> CommitmentsScreen {
        let rosterPlace = freshRosterPlace()
        let rosterStore = try RosterStore(at: rosterPlace)
        try rosterStore.add(waterPlants)
        try rosterStore.add(gym)
        try rosterStore.add(creatine)
        try rosterStore.add(finances)
        try rosterStore.put(gym, under: "Sport")
        try rosterStore.put(creatine, under: "Supplements")
        try rosterStore.put(finances, under: "Money")
        return CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    }

    let atTheCount = try neverMoved()
    let movedAtTheCount = atTheCount.move(group: "Sport", toOffset: 3)

    #expect(movedAtTheCount == nil)
    #expect(
        atTheCount.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "Money", commitments: [finances]),
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: nil, commitments: [waterPlants]),
            ])

    let pastTheCount = try neverMoved()
    let keptGroupsBeforeMove = pastTheCount.keptGroups
    let movedPastTheCount = pastTheCount.move(group: "Sport", toOffset: 4)

    #expect(movedPastTheCount == nil)
    #expect(pastTheCount.keptGroups == keptGroupsBeforeMove)
}

@MainActor
@Test("a group moved through a commitments screen carries the commitments it has stopped with it")
func aGroupMovedThroughACommitmentsScreenCarriesTheCommitmentsItHasStoppedWithIt() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(magnesium)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(magnesium, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")
    try rosterStore.put(journaling, under: "Sport")
    try rosterStore.retire(creatine, keptUntil: sunday)
    try rosterStore.retire(journaling, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.move(group: "Supplements", toOffset: 2)

    #expect(refusal == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: "Supplements", commitments: [magnesium]),
            ])
    #expect(screen.stopped == [journaling, creatine])

    let later = try RosterStore(at: rosterPlace)

    #expect(
        later.roster.groups(on: sunday)
            == [
                Roster.Group(category: "Sport", commitments: [gym, journaling]),
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
            ])
}

@MainActor
@Test("a commitments screen asked to move the group of the commitments under no category does nothing and says nothing")
func aCommitmentsScreenAskedToMoveTheGroupOfTheCommitmentsUnderNoCategoryDoesNothingAndSaysNothing()
    throws
{
    let rosterPlace = freshRosterPlace()
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
    try rosterStore.put(creatine, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesBeforeMove = try Data(contentsOf: rosterPlace)

    let movedNilCategory = screen.move(group: nil, toOffset: 0)

    #expect(movedNilCategory == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])

    let movedBlankCategory = screen.move(group: "   ", toOffset: 0)

    #expect(movedBlankCategory == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
    #expect(try Data(contentsOf: rosterPlace) == bytesBeforeMove)
}

@MainActor
@Test("a commitments screen asked to move a group it draws none of does nothing and says nothing")
func aCommitmentsScreenAskedToMoveAGroupItDrawsNoneOfDoesNothingAndSaysNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesBeforeMove = try Data(contentsOf: rosterPlace)

    let movedStoppedOnly = screen.move(group: "Sport", toOffset: 0)

    #expect(movedStoppedOnly == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.keptGroups == [Roster.Group(category: "Supplements", commitments: [creatine])])
    #expect(screen.stopped == [gym])

    let movedNothing = screen.move(group: "Evening", toOffset: 0)

    #expect(movedNothing == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.keptGroups == [Roster.Group(category: "Supplements", commitments: [creatine])])
    #expect(screen.stopped == [gym])
    #expect(try Data(contentsOf: rosterPlace) == bytesBeforeMove)
}

@MainActor
@Test("a commitments screen given an offset the groups it draws do not have does nothing and says nothing")
func aCommitmentsScreenGivenAnOffsetTheGroupsItDrawsDoNotHaveDoesNothingAndSaysNothing() throws {
    let rosterPlace = freshRosterPlace()
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
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesBeforeMove = try Data(contentsOf: rosterPlace)

    let movedPastTheEnd = screen.move(group: "Sport", toOffset: 3)

    #expect(movedPastTheEnd == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])

    let movedBelowZero = screen.move(group: "Sport", toOffset: -1)

    #expect(movedBelowZero == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
    #expect(try Data(contentsOf: rosterPlace) == bytesBeforeMove)
}

@MainActor
@Test("a group move a commitments screen could not keep leaves both its lists as they were")
func aGroupMoveACommitmentsScreenCouldNotKeepLeavesBothItsListsAsTheyWere() throws {
    let rosterPlace = freshRosterPlace()
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
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    let refusal = screen.move(group: "Sport", toOffset: 0)

    #expect(refusal == .notKept)
    #expect(screen.refusedChange == .movingGroup("Sport", .notKept))
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
    #expect(screen.stopped == [])
}

@MainActor
@Test("a group move that leaves a group where it is drawn changes nothing and refuses nothing")
func aGroupMoveThatLeavesAGroupWhereItIsDrawnChangesNothingAndRefusesNothing() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.add(magnesium)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(magnesium, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let bytesBeforeMove = try Data(contentsOf: rosterPlace)

    let movedAtItsOwnOffset = screen.move(group: "Supplements", toOffset: 0)

    #expect(movedAtItsOwnOffset == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])

    let movedAtOffsetJustAfter = screen.move(group: "Supplements", toOffset: 1)

    #expect(movedAtOffsetJustAfter == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
    #expect(try Data(contentsOf: rosterPlace) == bytesBeforeMove)
}

@MainActor
@Test("a group moved above one whose first commitment is stopped is drawn where the person put it")
func aGroupMovedAboveOneWhoseFirstCommitmentIsStoppedIsDrawnWhereThePersonPutIt() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(magnesium)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(magnesium, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")
    try rosterStore.retire(creatine, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.move(group: "Sport", toOffset: 0)

    #expect(refusal == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Sport", commitments: [gym]),
                Roster.Group(category: "Supplements", commitments: [magnesium]),
            ])
    #expect(screen.stopped == [creatine])

    let later = try RosterStore(at: rosterPlace)

    #expect(
        later.roster.groups(on: sunday)
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
}

@MainActor
@Test("a commitments screen shown again draws its groups in the order they were moved into")
func aCommitmentsScreenShownAgainDrawsItsGroupsInTheOrderTheyWereMovedInto() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(creatine)
    try rosterStore.put(gym, under: "Sport")
    try rosterStore.put(creatine, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.move(group: "Supplements", toOffset: 0)
    screen.shown(asOf: tuesday)

    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
}

@MainActor
@Test("a commitments screen holds a refused group move against the category it was asked to move")
func aCommitmentsScreenHoldsARefusedGroupMoveAgainstTheCategoryItWasAskedToMove() throws {
    let rosterPlace = freshRosterPlace()
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
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    let refusal = screen.move(group: "Sport", toOffset: 0)

    #expect(refusal == .notKept)
    #expect(screen.refusedChange == .movingGroup("Sport", .notKept))
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
}

@MainActor
@Test("a commitments screen holds nothing against a group move that asks for no change at all")
func aCommitmentsScreenHoldsNothingAgainstAGroupMoveThatAsksForNoChangeAtAll() throws {
    let rosterPlace = freshRosterPlace()
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
    try rosterStore.put(creatine, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let movedNoSuchGroup = screen.move(group: "Sport", toOffset: 0)
    let movedNilCategory = screen.move(group: nil, toOffset: 0)
    let movedOutsideTheGroups = screen.move(group: "Supplements", toOffset: 2)

    #expect(movedNoSuchGroup == nil)
    #expect(movedNilCategory == nil)
    #expect(movedOutsideTheGroups == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
}

@MainActor
@Test("what a commitments screen holds about a refused change ends when a group move is kept")
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenAGroupMoveIsKept() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)

    let refusal = screen.move(group: "Sport", toOffset: 0)

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
}

@MainActor
@Test("what a commitments screen holds about a refused change stands when a group move leaves a group where it is")
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenAGroupMoveLeavesAGroupWhereItIs() throws
{
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.put(gym, under: "Sport")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    _ = screen.define(name: "   ", on: daily, keptFrom: monday, under: nil)

    let refusal = screen.move(group: "Supplements", toOffset: 0)

    #expect(refusal == nil)
    #expect(screen.refusedChange == .defining(.namesNothing))
}

@MainActor
@Test("a commitments screen says what a commitment it keeps is made of, on each of the four rhythms")
func aCommitmentsScreenSaysWhatACommitmentItKeepsIsMadeOfOnEachOfTheFourRhythms() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let finances = Commitment(
        name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 25)!), keptFrom: keptFrom)!
    let contactLenses = Commitment(
        name: "Contact lenses",
        schedule: .everyNDays(DayInterval(days: 14)!, from: keptFrom), keptFrom: keptFrom)!
    let reading = Commitment(
        name: "Reading", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(finances)
    try rosterStore.add(contactLenses)
    try rosterStore.add(reading)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let gymMadeOf = screen.whatItIsMadeOf(gym)
    let financesMadeOf = screen.whatItIsMadeOf(finances)
    let contactLensesMadeOf = screen.whatItIsMadeOf(contactLenses)
    let readingMadeOf = screen.whatItIsMadeOf(reading)

    #expect(gymMadeOf?.rhythm == .weekdays([.monday, .wednesday, .saturday]))
    #expect(financesMadeOf?.rhythm == .dayOfMonth(25))
    #expect(contactLensesMadeOf?.rhythm == .everyNDays(14))
    #expect(readingMadeOf?.rhythm == .weeklyQuota(3))

    for madeOf in [gymMadeOf, financesMadeOf, contactLensesMadeOf, readingMadeOf] {
        #expect(madeOf?.keptFrom == keptFrom)
    }
    #expect(gymMadeOf?.name == "Gym")
    #expect(financesMadeOf?.name == "Finances")
    #expect(contactLensesMadeOf?.name == "Contact lenses")
    #expect(readingMadeOf?.name == "Reading")
}

@MainActor
@Test("a commitments screen says the category a commitment it keeps is under")
func aCommitmentsScreenSaysTheCategoryACommitmentItKeepsIsUnder() throws {
    let rosterPlace = freshRosterPlace()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.whatItIsMadeOf(creatine)?.category == "Supplements")
    #expect(screen.whatItIsMadeOf(gym)?.category == nil)
}

@MainActor
@Test("a commitments screen says a stopped commitment's rhythm and day kept from cannot be changed")
func aCommitmentsScreenSaysAStoppedCommitmentsRhythmAndDayKeptFromCannotBeChanged() throws {
    let rosterPlace = freshRosterPlace()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.whatItIsMadeOf(gym)?.canChangeRhythmAndKeptFrom == false)
    #expect(screen.whatItIsMadeOf(journaling)?.canChangeRhythmAndKeptFrom == true)
}

@MainActor
@Test("a commitments screen says nothing about a commitment on neither of its lists")
func aCommitmentsScreenSaysNothingAboutACommitmentOnNeitherOfItsLists() throws {
    let rosterPlace = freshRosterPlace()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.remove(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.whatItIsMadeOf(gym) == nil)
    #expect(screen.whatItIsMadeOf(run) == nil)
}

@MainActor
@Test("a commitments screen says the kind a commitment it keeps takes, with what that kind carries")
func aCommitmentsScreenSaysTheKindACommitmentItKeepsTakesWithWhatThatKindCarries() throws {
    let rosterPlace = freshRosterPlace()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let mood = Commitment(
        name: "Mood", schedule: schedule, keptFrom: keptFrom,
        kind: .number(range: Commitment.Range(lowest: 1, highest: 10)))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(mood)
    try rosterStore.add(journal)
    try rosterStore.add(protein)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.whatItIsMadeOf(gym)?.kind == .tick)
    #expect(
        screen.whatItIsMadeOf(mood)?.kind
            == .number(range: Commitment.Range(lowest: 1, highest: 10)))
    #expect(screen.whatItIsMadeOf(journal)?.kind == .note)
    #expect(screen.whatItIsMadeOf(protein)?.kind == .total(target: Commitment.Target(120)!))
}

@MainActor
@Test("a commitments screen says a number commitment carrying no range takes the number kind and no range")
func aCommitmentsScreenSaysANumberCommitmentCarryingNoRangeTakesTheNumberKindAndNoRange() throws {
    let rosterPlace = freshRosterPlace()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(weight)
    try rosterStore.add(gym)
    try rosterStore.retire(weight, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.whatItIsMadeOf(weight)?.kind == .number(range: nil))
    #expect(screen.whatItIsMadeOf(weight)?.canChangeRhythmAndKeptFrom == false)
}

@MainActor
@Test("a commitment renamed through a commitments screen is drawn under its new name, in the place it held")
func aCommitmentRenamedThroughACommitmentsScreenIsDrawnUnderItsNewNameInThePlaceItHeld() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(waterPlants)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym 🏋️",
        on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(refusal == nil)
    #expect(screen.kept.map(\.name) == ["Water plants", "Gym 🏋️", "Journaling"])

    let laterRosterStore = try RosterStore(at: places.roster)
    #expect(laterRosterStore.roster.commitments.map(\.name) == ["Water plants", "Gym 🏋️", "Journaling"])
    // Renamed in place, not superseded: a day before today still finds only these three — a
    // supersession would leave a fourth, removed twin visible on that day.
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    #expect(laterRosterStore.roster.commitments(on: sunday).count == 3)
}

@MainActor
@Test("every record of a commitment renamed through a commitments screen is carried over to the new name")
func everyRecordOfACommitmentRenamedThroughACommitmentsScreenIsCarriedOverToTheNewName() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: august3rd)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym 🏋️",
        on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(refusal == nil)

    let laterRecordStore = try RecordStore(at: places.record)
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: schedule, keptFrom: keptFrom)!
    #expect(laterRecordStore.history.isKept(gymEmoji, on: august3rd))
    #expect(!laterRecordStore.history.isKept(gym, on: august3rd))

    // Renamed in place, not superseded: a day before today still finds only the one commitment
    // — a supersession would leave a second, removed twin visible on that day.
    let laterRosterStore = try RosterStore(at: places.roster)
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    #expect(laterRosterStore.roster.commitments(on: sunday).count == 1)
}

@MainActor
@Test("a commitment whose rhythm is changed through a commitments screen is kept until yesterday and the new one is taken on today")
func aCommitmentWhoseRhythmIsChangedThroughACommitmentsScreenIsKeptUntilYesterdayAndTheNewOneIsTakenOnToday()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let originalSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: originalSchedule, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym", on: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom, under: nil)

    #expect(refusal == nil)
    #expect(screen.kept.count == 1)
    #expect(screen.kept.first?.name == "Gym")
    #expect(screen.kept.first?.rhythmInWords == "Tue, Thu")
    #expect(screen.stopped.isEmpty)

    let laterRosterStore = try RosterStore(at: places.roster)
    let oldGym = Commitment(name: "Gym", schedule: originalSchedule, keptFrom: keptFrom)!
    let newGym = Commitment(
        name: "Gym", schedule: .weekdays([.tuesday, .thursday]), keptFrom: monday)!
    #expect(laterRosterStore.roster.commitments(on: sunday) == [newGym, oldGym])
    #expect(laterRosterStore.roster.commitments(on: monday) == [newGym])
}

@MainActor
@Test("a rhythm changed through a commitments screen leaves every record already made standing")
func aRhythmChangedThroughACommitmentsScreenLeavesEveryRecordAlreadyMadeStanding() throws {
    let places = freshRosterAndRecordPlaces()
    let originalSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: originalSchedule, keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: august3rd)!)
    let recordBytes = try Data(contentsOf: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym", on: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom, under: nil)

    #expect(refusal == nil)

    let laterRecordStore = try RecordStore(at: places.record)
    #expect(laterRecordStore.history.isKept(gym, on: august3rd))
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test("a name and a rhythm changed in one save put the new name on the superseded commitment")
func aNameAndARhythmChangedInOneSavePutTheNewNameOnTheSupersededCommitment() throws {
    let places = freshRosterAndRecordPlaces()
    let originalSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: originalSchedule, keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: august3rd)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym 🏋️", on: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom, under: nil)

    #expect(refusal == nil)

    let supersededGym = Commitment(name: "Gym 🏋️", schedule: originalSchedule, keptFrom: keptFrom)!
    let newGym = Commitment(
        name: "Gym 🏋️", schedule: .weekdays([.tuesday, .thursday]), keptFrom: monday)!

    let laterRosterStore = try RosterStore(at: places.roster)
    #expect(laterRosterStore.roster.commitments(on: sunday) == [newGym, supersededGym])

    #expect(screen.kept.count == 1)
    #expect(screen.kept.first?.name == "Gym 🏋️")
    #expect(screen.kept.first?.rhythmInWords == "Tue, Thu")

    let laterRecordStore = try RecordStore(at: places.record)
    #expect(laterRecordStore.history.isKept(supersededGym, on: august3rd))
}

@MainActor
@Test("the day a commitment is kept from is moved earlier through a commitments screen and the days it opens become due")
func theDayACommitmentIsKeptFromIsMovedEarlierThroughACommitmentsScreenAndTheDaysItOpensBecomeDue()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let originalKeptFrom = CalendarDate(year: 2026, month: 8, day: 1)!
    let newKeptFrom = CalendarDate(year: 2026, month: 6, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: originalKeptFrom)!
    let june1st = CalendarDate(year: 2026, month: 6, day: 1)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: newKeptFrom, under: nil)

    #expect(refusal == nil)

    let laterRosterStore = try RosterStore(at: places.roster)
    let changed = laterRosterStore.roster.commitments.first
    #expect(changed?.isDue(on: june1st) == true)
    #expect(changed?.isDue(on: august3rd) == true)
}

@MainActor
@Test("moving the day a commitment is kept from past a day it has a record on is refused")
func movingTheDayACommitmentIsKeptFromPastADayItHasARecordOnIsRefused() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 6, day: 1)!
    let newKeptFrom = CalendarDate(year: 2026, month: 9, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: august3rd)!)
    let rosterBytes = try Data(contentsOf: places.roster)
    let recordBytes = try Data(contentsOf: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(gym, toName: "Gym", on: .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ]), keptFrom: newKeptFrom, under: nil)

    #expect(refusal == .wouldLeaveARecordedDayNotDue)
    #expect(screen.kept.count == 1)
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test("the day an interval commitment is kept from is moved earlier and every day it is due on moves with it")
func theDayAnIntervalCommitmentIsKeptFromIsMovedEarlierAndEveryDayItIsDueOnMovesWithIt() throws {
    let places = freshRosterAndRecordPlaces()
    let july1st = CalendarDate(year: 2026, month: 7, day: 1)!
    let june29th = CalendarDate(year: 2026, month: 6, day: 29)!
    let july13th = CalendarDate(year: 2026, month: 7, day: 13)!
    let contactLenses = Commitment(
        name: "Contact lenses", schedule: .everyNDays(DayInterval(days: 14)!, from: july1st),
        keptFrom: july1st)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(contactLenses)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        contactLenses, toName: "Contact lenses", on: .everyNDays(14), keptFrom: june29th, under: nil)

    #expect(refusal == nil)

    let laterRosterStore = try RosterStore(at: places.roster)
    let changed = laterRosterStore.roster.commitments.first
    #expect(changed?.isDue(on: june29th) == true)
    #expect(changed?.isDue(on: july13th) == true)
    #expect(changed?.isDue(on: july1st) == false)
}

@MainActor
@Test("moving the day an interval commitment is kept from off a day it has a record on is refused")
func movingTheDayAnIntervalCommitmentIsKeptFromOffADayItHasARecordOnIsRefused() throws {
    let places = freshRosterAndRecordPlaces()
    let july1st = CalendarDate(year: 2026, month: 7, day: 1)!
    let june29th = CalendarDate(year: 2026, month: 6, day: 29)!
    let july15th = CalendarDate(year: 2026, month: 7, day: 15)!
    let contactLenses = Commitment(
        name: "Contact lenses", schedule: .everyNDays(DayInterval(days: 14)!, from: july1st),
        keptFrom: july1st)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(contactLenses)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(contactLenses, on: july15th)!)
    let rosterBytes = try Data(contentsOf: places.roster)
    let recordBytes = try Data(contentsOf: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        contactLenses, toName: "Contact lenses", on: .everyNDays(14), keptFrom: june29th, under: nil)

    #expect(refusal == .wouldLeaveARecordedDayNotDue)
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test("an interval commitment's day kept from moved earlier by a whole number of intervals leaves every recorded day due")
func anIntervalCommitmentsDayKeptFromMovedEarlierByAWholeNumberOfIntervalsLeavesEveryRecordedDayDue()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let july1st = CalendarDate(year: 2026, month: 7, day: 1)!
    let june17th = CalendarDate(year: 2026, month: 6, day: 17)!
    let july15th = CalendarDate(year: 2026, month: 7, day: 15)!
    let contactLenses = Commitment(
        name: "Contact lenses", schedule: .everyNDays(DayInterval(days: 14)!, from: july1st),
        keptFrom: july1st)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(contactLenses)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(contactLenses, on: july15th)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        contactLenses, toName: "Contact lenses", on: .everyNDays(14), keptFrom: june17th, under: nil)

    #expect(refusal == nil)

    let laterRosterStore = try RosterStore(at: places.roster)
    let changed = laterRosterStore.roster.commitments.first
    #expect(changed?.isDue(on: june17th) == true)
    #expect(changed?.isDue(on: july15th) == true)

    let newContactLenses = Commitment(
        name: "Contact lenses", schedule: .everyNDays(DayInterval(days: 14)!, from: june17th),
        keptFrom: june17th)!
    let laterRecordStore = try RecordStore(at: places.record)
    #expect(laterRecordStore.history.isKept(newContactLenses, on: july15th))
    #expect(!laterRecordStore.history.isKept(contactLenses, on: july15th))
}

@MainActor
@Test("a change whose result the roster already holds is refused, whichever state it holds it in")
func aChangeWhoseResultTheRosterAlreadyHoldsIsRefusedWhicheverStateItHoldsItIn() throws {
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let keptPlaces = freshRosterAndRecordPlaces()
    let keptRosterStore = try RosterStore(at: keptPlaces.roster)
    try keptRosterStore.add(gym)
    try keptRosterStore.add(run)
    let keptScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: keptPlaces.roster, keepingRecordAt: keptPlaces.record)
    let keptRefusal = keptScreen.change(gym, toName: "Run", on: .weekdays(
        [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]), keptFrom: keptFrom,
        under: nil)

    #expect(keptRefusal == .alreadyKept)
    #expect(keptScreen.kept.map(\.name) == ["Gym", "Run"])

    let stoppedPlaces = freshRosterAndRecordPlaces()
    let stoppedRosterStore = try RosterStore(at: stoppedPlaces.roster)
    try stoppedRosterStore.add(gym)
    try stoppedRosterStore.add(run)
    try stoppedRosterStore.retire(run, keptUntil: sunday)
    let stoppedScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: stoppedPlaces.roster, keepingRecordAt: stoppedPlaces.record)
    let stoppedRefusal = stoppedScreen.change(gym, toName: "Run", on: .weekdays(
        [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]), keptFrom: keptFrom,
        under: nil)

    #expect(stoppedRefusal == .alreadyKept)

    let removedPlaces = freshRosterAndRecordPlaces()
    let removedRosterStore = try RosterStore(at: removedPlaces.roster)
    try removedRosterStore.add(gym)
    try removedRosterStore.add(run)
    try removedRosterStore.remove(run, keptUntil: sunday)
    let removedScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: removedPlaces.roster, keepingRecordAt: removedPlaces.record)
    let removedRefusal = removedScreen.change(gym, toName: "Run", on: .weekdays(
        [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]), keptFrom: keptFrom,
        under: nil)

    #expect(removedRefusal == .alreadyKept)
}

@MainActor
@Test("a change that names what is already there changes nothing and refuses nothing")
func aChangeThatNamesWhatIsAlreadyThereChangesNothingAndRefusesNothing() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym, under: "Sport")
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: august3rd)!)
    let rosterBytes = try Data(contentsOf: places.roster)
    let recordBytes = try Data(contentsOf: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: "Sport")

    #expect(refusal == nil)
    #expect(screen.keptGroups == [Roster.Group(category: "Sport", commitments: [gym])])
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test("a stopped commitment renamed through a commitments screen stays stopped, on the day it was kept until")
func aStoppedCommitmentRenamedThroughACommitmentsScreenStaysStoppedOnTheDayItWasKeptUntil() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym 🏋️", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(refusal == nil)
    #expect(screen.stopped.map(\.name) == ["Gym 🏋️"])
    #expect(screen.kept.map(\.name) == ["Journaling"])

    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: schedule, keptFrom: keptFrom)!
    let laterRosterStore = try RosterStore(at: places.roster)
    #expect(laterRosterStore.roster.commitments(on: sunday) == [gymEmoji, journaling])
    #expect(laterRosterStore.roster.commitments(on: monday) == [journaling])
}

@MainActor
@Test("changing the rhythm or the day kept from of a stopped commitment is refused")
func changingTheRhythmOrTheDayKeptFromOfAStoppedCommitmentIsRefused() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let june1st = CalendarDate(year: 2026, month: 6, day: 1)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let rhythmRefusal = screen.change(
        gym, toName: "Gym", on: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom, under: nil)

    #expect(rhythmRefusal == .stoppedCommitmentCannotChangeRhythm)

    let keptFromRefusal = screen.change(
        gym, toName: "Gym", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: june1st, under: nil)

    #expect(keptFromRefusal == .stoppedCommitmentCannotChangeRhythm)
    #expect(screen.stopped.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitments screen asked to change a commitment on neither of its lists does nothing and says nothing")
func aCommitmentsScreenAskedToChangeACommitmentOnNeitherOfItsListsDoesNothingAndSaysNothing() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.remove(gym, keptUntil: sunday)
    let rosterBytes = try Data(contentsOf: places.roster)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym 🏋️", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(refusal == nil)
    #expect(screen.kept.map(\.name) == ["Journaling"])
    #expect(screen.stopped.isEmpty)
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
}

@MainActor
@Test("a change a commitments screen could not keep leaves both places as they were")
func aChangeACommitmentsScreenCouldNotKeepLeavesBothPlacesAsTheyWere() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let rosterPlace = directory.appendingPathComponent("roster.json")
    let recordPlace = directory.appendingPathComponent("record.json")
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace)

    try FileManager.default.removeItem(at: directory)
    try Data().write(to: directory)

    let refusal = screen.change(
        gym, toName: "Gym 🏋️", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(refusal == .notKept)
    #expect(refusal != .alreadyKept)
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a change refuses a name that says nothing, a rhythm due on no day and a rhythm number the calendar will not take")
func aChangeRefusesANameThatSaysNothingARhythmDueOnNoDayAndARhythmNumberTheCalendarWillNotTake()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let namesNothingRefusal = screen.change(
        gym, toName: "   ", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)
    let dueOnNoDayRefusal = screen.change(gym, toName: "Gym", on: .weekdays([]), keptFrom: keptFrom, under: nil)
    let rhythmOutOfRangeRefusal = screen.change(
        gym, toName: "Gym", on: .dayOfMonth(32), keptFrom: keptFrom, under: nil)

    #expect(namesNothingRefusal == .namesNothing)
    #expect(dueOnNoDayRefusal == .dueOnNoDay)
    #expect(rhythmOutOfRangeRefusal == .rhythmOutOfRange)
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitment of the number kind changed through a commitments screen keeps the kind its days take")
func aCommitmentOfTheNumberKindChangedThroughACommitmentsScreenKeepsTheKindItsDaysTake() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(weight)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        weight, toName: "Bodyweight", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(refusal == nil)

    let laterRosterStore = try RosterStore(at: places.roster)
    #expect(laterRosterStore.roster.commitments.first?.kind == .number(range: range))
}

@MainActor
@Test("a rhythm changed on the first date the calendar supports supersedes as of that day itself")
func aRhythmChangedOnTheFirstDateTheCalendarSupportsSupersedesAsOfThatDayItself() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let firstSupportedDate = CalendarDate(year: 1583, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: firstSupportedDate)!
    let secondSupportedDate = CalendarDate(year: 1583, month: 1, day: 2)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(
        asOf: firstSupportedDate, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym", on: .weekdays([.tuesday, .thursday]), keptFrom: firstSupportedDate,
        under: nil)

    #expect(refusal == nil)

    let laterRosterStore = try RosterStore(at: places.roster)
    #expect(laterRosterStore.roster.commitments(on: firstSupportedDate).count == 2)
    #expect(laterRosterStore.roster.commitments(on: secondSupportedDate).count == 1)
}

@MainActor
@Test("a commitments screen holds a refused change against the commitment it was asked to change")
func aCommitmentsScreenHoldsARefusedChangeAgainstTheCommitmentItWasAskedToChange() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.add(run)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Run", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(refusal == .alreadyKept)
    #expect(screen.refusedChange == .changing(gym, .alreadyKept))
}

@MainActor
@Test("a commitments screen holds nothing against a change that asks for no change at all")
func aCommitmentsScreenHoldsNothingAgainstAChangeThatAsksForNoChangeAtAll() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
}

@MainActor
@Test("what a commitments screen holds about a refused change ends when a change to a commitment is kept")
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenAChangeToACommitmentIsKept() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.add(run)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let firstRefusal = screen.change(
        gym, toName: "Run", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)
    #expect(firstRefusal == .alreadyKept)
    #expect(screen.refusedChange == .changing(gym, .alreadyKept))

    let secondRefusal = screen.change(
        gym, toName: "Gym 🏋️", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(secondRefusal == nil)
    #expect(screen.refusedChange == nil)
}

@MainActor
@Test("what a commitments screen holds about a refused change stands when a change names what is already there")
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenAChangeNamesWhatIsAlreadyThere() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.add(run)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let firstRefusal = screen.change(
        gym, toName: "Run", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)
    #expect(firstRefusal == .alreadyKept)
    #expect(screen.refusedChange == .changing(gym, .alreadyKept))

    let secondRefusal = screen.change(
        gym, toName: "Gym", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(secondRefusal == nil)
    #expect(screen.refusedChange == .changing(gym, .alreadyKept))
}

@MainActor
@Test("a category set through a commitments screen's change is kept at the roster place")
func aCategorySetThroughACommitmentsScreensChangeIsKeptAtTheRosterPlace() throws {
    let rosterPlace = freshRosterPlace()
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

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.change(
        creatine, toName: "Creatine", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: "Supplements")

    #expect(refusal == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])

    let later = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(
        later.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
}

@MainActor
@Test("a category taken off through a commitments screen's change draws its commitment among the ones under none")
func aCategoryTakenOffThroughACommitmentsScreensChangeDrawsItsCommitmentAmongTheOnesUnderNone()
    throws
{
    let rosterPlace = freshRosterPlace()
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
    try rosterStore.put(creatine, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.change(
        creatine, toName: "Creatine", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: "   ")

    #expect(refusal == nil)
    #expect(
        screen.keptGroups == [Roster.Group(category: nil, commitments: [creatine, gym])])
}

@MainActor
@Test("a target typed on the tick or the note kind is ignored rather than refused")
func aTargetTypedOnTheTickOrTheNoteKindIsIgnoredRatherThanRefused() throws {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let tickRefusal = screen.define(
        name: "Gym", on: dailyRhythm, keptFrom: monday, under: nil, kind: .tick,
        target: "0")
    let noteRefusal = screen.define(
        name: "Journal", on: dailyRhythm, keptFrom: monday, under: nil, kind: .note, target: "0")

    #expect(tickRefusal == nil)
    #expect(noteRefusal == nil)

    let rosterStore = try RosterStore(at: rosterPlace)
    #expect(rosterStore.roster.commitments.map(\.name) == ["Gym", "Journal"])
    #expect(rosterStore.roster.commitments.map(\.kind) == [.tick, .note])
}

@MainActor
@Test(
    "a range whose two ends each hold a zero-width space alone is refused as not a number rather than taken as blank"
)
func aRangeWhoseTwoEndsEachHoldAZeroWidthSpaceAloneIsRefusedAsNotANumberRatherThanTakenAsBlank() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "Mood", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number,
        lowest: "\u{200B}", highest: "\u{200B}")

    #expect(refusal == .rangeIsNotARange)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a range end holding no digit is refused as not a number")
func aRangeEndHoldingNoDigitIsRefusedAsNotANumber() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "Mood", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number, lowest: "-",
        highest: "10")

    #expect(refusal == .rangeIsNotARange)

    let alikeRefusal = screen.define(
        name: "Mood", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number, lowest: "0",
        highest: ".")

    #expect(alikeRefusal == .rangeIsNotARange)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a range end holding more than one separator is refused as not a number")
func aRangeEndHoldingMoreThanOneSeparatorIsRefusedAsNotANumber() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "Mood", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number,
        lowest: "1.2.3", highest: "10")

    #expect(refusal == .rangeIsNotARange)

    let alikeRefusal = screen.define(
        name: "Mood", on: dailyRhythm, keptFrom: monday, under: nil, kind: .number,
        lowest: "1", highest: "1,5.0")

    #expect(alikeRefusal == .rangeIsNotARange)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a commitment defined again after being stopped takes the category the form carried")
func aCommitmentDefinedAgainAfterBeingStoppedTakesTheCategoryTheFormCarried() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterPlace = freshRosterPlace()
    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.retire(creatine, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.define(
        name: "Creatine",
        on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: "Morning")

    #expect(refusal == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Morning", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
    #expect(screen.stopped.isEmpty)
}

@MainActor
@Test("a commitments screen refuses a commitment whose name is empty")
func aCommitmentsScreenRefusesACommitmentWhoseNameIsEmpty() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "", on: daily, keptFrom: monday, under: nil)

    #expect(refusal == .namesNothing)
    #expect(screen.kept.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: rosterPlace.path))
}

@MainActor
@Test("a commitments screen accepts a name of ten thousand characters")
func aCommitmentsScreenAcceptsANameOfTenThousandCharacters() throws {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let longName = String(repeating: "a", count: 10_000)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: longName, on: daily, keptFrom: monday, under: nil)

    #expect(refusal == nil)
    #expect(screen.kept.map(\.name) == [longName])
}

@MainActor
@Test("a stop confirmed with nothing awaiting confirmation changes nothing")
func aStopConfirmedWithNothingAwaitingConfirmationChangesNothing() throws {
    // Route 1, `design.md` § *Strengthened in place, and the three proven by mutation*: the
    // place is seeded with the roster in a form the store itself would never write, so a
    // mutant that stops the first kept commitment and takes it up again with nothing awaiting
    // — two real writes that leave the same roster — still changes the bytes, even though
    // `RosterStore.write` is byte-stable and would otherwise make that pair of writes invisible
    // against bytes the store wrote itself.
    let rosterPlace = freshRosterPlace()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": {
                  "weekdays": [
                    "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"
                  ]
                }
              },
              "removed": false,
              "category": null
            }
          ]
        }
        """.utf8)
    try bytes.write(to: rosterPlace)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.confirmStopKeeping()

    #expect(refusal == nil)
    #expect(screen.awaitingConfirmation == nil)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
    #expect(try Data(contentsOf: rosterPlace) == bytes)
}

@MainActor
@Test(
    "moving a commitment leaves a removal awaiting confirmation and what has been typed back exactly as they were"
)
func movingACommitmentLeavesARemovalAwaitingConfirmationAndWhatHasBeenTypedBackExactlyAsTheyWere()
    throws
{
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    screen.askToRemove(gym)
    screen.nameTypedBack = "Gy"
    let moved = screen.move(journaling, toOffset: 0, under: nil)

    #expect(moved == nil)
    #expect(screen.awaitingRemoval == gym)
    #expect(screen.nameTypedBack == "Gy")
    #expect(screen.kept.map(\.name) == ["Journaling", "Gym"])
}

@MainActor
@Test("a commitments screen shown again lists what has been stopped at its place since it was opened")
func aCommitmentsScreenShownAgainListsWhatHasBeenStoppedAtItsPlaceSinceItWasOpened() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.stopped.isEmpty)

    let other = try RosterStore(at: rosterPlace)
    try other.retire(gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 30)!)

    screen.shown(asOf: monday)

    #expect(screen.stopped.map(\.name) == ["Gym"])
    #expect(screen.kept.map(\.name) == ["Journaling"])
}

@MainActor
@Test(
    "a commitments screen that cannot read its roster does nothing when it is asked to take a commitment up again"
)
func aCommitmentsScreenThatCannotReadItsRosterDoesNothingWhenItIsAskedToTakeACommitmentUpAgain()
    throws
{
    let rosterPlace = freshRosterPlace()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let originalBytes = Data("not what a roster is written as".utf8)
    try originalBytes.write(to: rosterPlace)
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.keepAgain(gym)

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.rosterState == .notKept)
    #expect(try Data(contentsOf: rosterPlace) == originalBytes)
}

@MainActor
@Test("a commitments screen whose roster holds what could not be a roster says it is not keeping one")
func aCommitmentsScreenWhoseRosterHoldsWhatCouldNotBeARosterSaysItIsNotKeepingOne() throws {
    let rosterPlace = freshRosterPlace()
    try FileManager.default.createDirectory(
        at: rosterPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let gymEntry = """
        {
          "commitment": {
            "name": "Gym",
            "keptFrom": { "year": 2026, "month": 1, "day": 1 },
            "schedule": {
              "weekdays": [
                "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"
              ]
            }
          },
          "removed": false,
          "category": null
        }
        """
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [\(gymEntry), \(gymEntry)]
        }
        """.utf8)
    try bytes.write(to: rosterPlace)
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.isEmpty)
    #expect(screen.stopped.isEmpty)
    #expect(screen.rosterState == .notKept)
}

@MainActor
@Test("what a commitments screen holds about a refused change ends when a change of rhythm is kept")
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenAChangeOfRhythmIsKept() throws {
    let places = freshRosterAndRecordPlaces()
    let originalSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let newRhythm: Rhythm = .weekdays([.tuesday, .thursday])
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: originalSchedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    // The refusal being cleared belongs to an unrelated define, not to "Gym" itself — a clear
    // limited to refusals about the same commitment would pass this test and fail the scenario.
    let firstRefusal = screen.define(name: "   ", on: dailyRhythm, keptFrom: monday, under: nil)
    #expect(firstRefusal == .namesNothing)
    #expect(screen.refusedChange == .defining(.namesNothing))

    let secondRefusal = screen.change(
        gym, toName: "Gym", on: newRhythm, keptFrom: keptFrom, under: nil)

    #expect(secondRefusal == nil)
    #expect(screen.refusedChange == nil)
}

@MainActor
@Test(
    "what a commitments screen holds about a refused change ends when a name and a rhythm changed in one save are kept"
)
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenANameAndARhythmChangedInOneSaveAreKept()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let originalSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let newRhythm: Rhythm = .weekdays([.tuesday, .thursday])
    let dailyRhythm: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: originalSchedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    // The refusal being cleared belongs to an unrelated define, not to "Gym" itself — a clear
    // limited to refusals about the same commitment would pass this test and fail the scenario.
    let firstRefusal = screen.define(name: "   ", on: dailyRhythm, keptFrom: monday, under: nil)
    #expect(firstRefusal == .namesNothing)
    #expect(screen.refusedChange == .defining(.namesNothing))

    let secondRefusal = screen.change(
        gym, toName: "Gym 🏋️", on: newRhythm, keptFrom: keptFrom, under: nil)

    #expect(secondRefusal == nil)
    #expect(screen.refusedChange == nil)
}

@MainActor
@Test(
    "what a commitments screen holds about a refused change ends when a change kept at both places is kept"
)
func whatACommitmentsScreenHoldsAboutARefusedChangeEndsWhenAChangeKeptAtBothPlacesIsKept() throws {
    let places = freshRosterAndRecordPlaces()
    let dailySchedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let dailyRhythm = Rhythm(dailySchedule)
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: dailySchedule, keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: august3rd)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    // The refusal being cleared belongs to an unrelated define, not to "Gym" itself — a clear
    // limited to refusals about the same commitment would pass this test and fail the scenario.
    let firstRefusal = screen.define(name: "   ", on: dailyRhythm, keptFrom: monday, under: nil)
    #expect(firstRefusal == .namesNothing)
    #expect(screen.refusedChange == .defining(.namesNothing))

    let secondRefusal = screen.change(
        gym, toName: "Gym 🏋️", on: dailyRhythm, keptFrom: keptFrom, under: nil)

    #expect(secondRefusal == nil)
    #expect(screen.refusedChange == nil)

    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: dailySchedule, keptFrom: keptFrom)!
    let laterRecordStore = try RecordStore(at: places.record)
    #expect(laterRecordStore.history.isKept(gymEmoji, on: august3rd))
}

@MainActor
@Test("a commitments screen opened has nothing awaiting removal and nothing typed back")
func aCommitmentsScreenOpenedHasNothingAwaitingRemovalAndNothingTypedBack() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.awaitingRemoval == nil)
    #expect(screen.nameTypedBack == "")
    #expect(!screen.nameTypedBackMatches)
}

@MainActor
@Test("a commitments screen says what a commitment it has stopped is made of")
func aCommitmentsScreenSaysWhatACommitmentItHasStoppedIsMadeOf() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.retire(creatine, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let madeOf = screen.whatItIsMadeOf(creatine)

    #expect(madeOf?.name == "Creatine")
    #expect(
        madeOf?.rhythm
            == .weekdays([
                .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
            ]))
    #expect(madeOf?.keptFrom == keptFrom)
    #expect(madeOf?.category == "Supplements")
    #expect(madeOf?.canChangeRhythmAndKeptFrom == false)
}

@MainActor
@Test(
    "a commitment defined under a category differing only in case from one in use is a group of its own"
)
func aCommitmentDefinedUnderACategoryDifferingOnlyInCaseFromOneInUseIsAGroupOfItsOwn() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let daily: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let dailySchedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: dailySchedule, keptFrom: keptFrom)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    _ = try rosterStore.put(creatine, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let refusal = screen.define(name: "Magnesium", on: daily, keptFrom: monday, under: "supplements")

    #expect(refusal == nil)
    let magnesium = Commitment(name: "Magnesium", schedule: dailySchedule, keptFrom: monday)!
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "supplements", commitments: [magnesium]),
            ])
    #expect(screen.categoriesInUse == ["Supplements", "supplements"])
}

@MainActor
@Test("a commitments screen does not drop a commitment into a group whose category differs only in case")
func aCommitmentsScreenDoesNotDropACommitmentIntoAGroupWhoseCategoryDiffersOnlyInCase() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    _ = try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    let moved = screen.move(gym, toOffset: 0, under: "supplements")

    #expect(moved == nil)
    #expect(screen.refusedChange == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
}

@MainActor
@Test(
    "a commitment of the total kind whose rhythm is changed through a commitments screen keeps its kind and its target"
)
func aCommitmentOfTheTotalKindWhoseRhythmIsChangedThroughACommitmentsScreenKeepsItsKindAndItsTarget()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let target = Commitment.Target(120)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom, kind: .total(target: target))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(protein)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        protein, toName: "Protein", on: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom,
        under: nil)

    #expect(refusal == nil)

    let laterRosterStore = try RosterStore(at: places.roster)
    #expect(laterRosterStore.roster.commitments.first?.kind == .total(target: target))
}

@MainActor
@Test(
    "the day a commitment is kept from moved earlier through a commitments screen carries every record over, each day still due"
)
func theDayACommitmentIsKeptFromMovedEarlierThroughACommitmentsScreenCarriesEveryRecordOverEachDayStillDue()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let originalKeptFrom = CalendarDate(year: 2026, month: 8, day: 1)!
    let newKeptFrom = CalendarDate(year: 2026, month: 6, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: originalKeptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: august3rd)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym", on: .weekdays([.monday, .wednesday, .saturday]), keptFrom: newKeptFrom,
        under: nil)

    #expect(refusal == nil)

    let newGym = Commitment(name: "Gym", schedule: schedule, keptFrom: newKeptFrom)!
    let laterRecordStore = try RecordStore(at: places.record)
    #expect(laterRecordStore.history.isKept(newGym, on: august3rd))
    #expect(!laterRecordStore.history.isKept(gym, on: august3rd))
    #expect(newGym.isDue(on: august3rd))
}

@MainActor
@Test("a stopped commitment put under a category through a commitments screen's change stays stopped under it")
func aStoppedCommitmentPutUnderACategoryThroughACommitmentsScreensChangeStaysStoppedUnderIt() throws {
    let places = freshRosterAndRecordPlaces()
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(creatine)
    try rosterStore.add(gym)
    try rosterStore.retire(creatine, keptUntil: sunday)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let refusal = screen.change(
        creatine, toName: "Creatine", on: Rhythm(daily), keptFrom: keptFrom, under: "Supplements")

    #expect(refusal == nil)
    #expect(screen.stopped.map(\.name) == ["Creatine"])
    #expect(screen.whatItIsMadeOf(creatine)?.category == "Supplements")

    screen.keepAgain(creatine)

    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
}

@MainActor
@Test(
    "a name, an earlier day kept from and a rhythm changed in one save put the corrected day on the superseded commitment"
)
func aNameAnEarlierDayKeptFromAndARhythmChangedInOneSavePutTheCorrectedDayOnTheSupersededCommitment()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let originalSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let originalKeptFrom = CalendarDate(year: 2026, month: 8, day: 1)!
    let correctedKeptFrom = CalendarDate(year: 2026, month: 6, day: 1)!
    let gym = Commitment(name: "Gym", schedule: originalSchedule, keptFrom: originalKeptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym 🏋️", on: .weekdays([.tuesday, .thursday]), keptFrom: correctedKeptFrom,
        under: nil)

    #expect(refusal == nil)

    let supersededGym = Commitment(
        name: "Gym 🏋️", schedule: originalSchedule, keptFrom: correctedKeptFrom)!
    // The commitment taken on today has no `keptUntil` at all, so `commitments(on:)` — "the
    // commitments this roster had not stopped keeping on `date`" — answers with it for any
    // date, Sunday included, alongside the superseded one this scenario is about.
    let takenOnToday = Commitment(
        name: "Gym 🏋️", schedule: .weekdays([.tuesday, .thursday]), keptFrom: monday)!
    let laterRosterStore = try RosterStore(at: places.roster)
    #expect(laterRosterStore.roster.commitments(on: sunday) == [takenOnToday, supersededGym])

    #expect(screen.kept.map(\.name) == ["Gym 🏋️"])
    #expect(screen.kept.map(\.rhythmInWords) == ["Tue, Thu"])
}

@MainActor
@Test("a change that carries nothing over writes nothing at the record place")
func aChangeThatCarriesNothingOverWritesNothingAtTheRecordPlace() throws {
    // Route 1, `design.md` § *Strengthened in place, and the three proven by mutation*: the
    // record place is seeded with the current form, laid out with different key order and
    // spacing than a store's own encoding ever produces — so a spurious carry-over that wrote
    // this same tick back, even byte-identical, would still change the place's bytes.
    let places = freshRosterAndRecordPlaces()
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(creatine)

    try FileManager.default.createDirectory(
        at: places.record.deletingLastPathComponent(), withIntermediateDirectories: true)
    let recordBytes = seededRecordBytes(
        ticks: """
            [
              {
                "commitment": {
                  "name": "Creatine",
                  "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                  "schedule": {
                    "weekdays": [
                      "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"
                    ]
                  }
                },
                "date": { "year": 2026, "month": 8, "day": 3 }
              }
            ]
            """)
    try recordBytes.write(to: places.record)

    // The shape guard in `RecordStore.init(at:)` requires `numbers`, `notes` and `additions` to
    // be present at version 5 (`RecordDocument.swift`'s three `...IntroducedInVersion`
    // constants); confirming the seeded bytes actually open as a store is what makes the byte
    // check below mean anything — a place nothing could open would make it pass for free.
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let recordBytesBeforeChange = try Data(contentsOf: places.record)

    let refusal = screen.change(
        creatine, toName: "Creatine", on: Rhythm(daily), keptFrom: keptFrom, under: "Supplements")

    #expect(refusal == nil)
    #expect(try Data(contentsOf: places.record) == recordBytesBeforeChange)
}

@MainActor
@Test("a change of rhythm through a commitments screen puts the new commitment under the category it was given")
func aChangeOfRhythmThroughACommitmentsScreenPutsTheNewCommitmentUnderTheCategoryItWasGiven() throws {
    let places = freshRosterAndRecordPlaces()
    let originalSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: originalSchedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym, under: "Sport")

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let refusal = screen.change(
        gym, toName: "Gym", on: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom,
        under: "Morning")

    #expect(refusal == nil)
    let newGym = Commitment(
        name: "Gym", schedule: .weekdays([.tuesday, .thursday]), keptFrom: monday)!
    #expect(screen.keptGroups == [Roster.Group(category: "Morning", commitments: [newGym])])
    #expect(screen.kept.map(\.rhythmInWords) == ["Tue, Thu"])
}

@MainActor
@Test(
    "a name and a rhythm changed in one save through a commitments screen put the new commitment under the category given"
)
func aNameAndARhythmChangedInOneSaveThroughACommitmentsScreenPutTheNewCommitmentUnderTheCategoryGiven()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let originalSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: originalSchedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym, under: "Sport")

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let refusal = screen.change(
        gym, toName: "Gym 🏋️", on: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom,
        under: "Morning")

    #expect(refusal == nil)
    let newGym = Commitment(
        name: "Gym 🏋️", schedule: .weekdays([.tuesday, .thursday]), keptFrom: monday)!
    #expect(screen.keptGroups == [Roster.Group(category: "Morning", commitments: [newGym])])
    #expect(screen.kept.map(\.rhythmInWords) == ["Tue, Thu"])
}

@MainActor
@Test(
    "a change a commitments screen could not carry over at the record place is refused as a place that could not be written"
)
func aChangeACommitmentsScreenCouldNotCarryOverAtTheRecordPlaceIsRefusedAsAPlaceThatCouldNotBeWritten()
    throws
{
    let rosterDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let rosterPlace = rosterDirectory.appendingPathComponent("roster.json")
    let recordDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let recordPlace = recordDirectory.appendingPathComponent("record.json")
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: recordPlace)
    try recordStore.add(Tick(gym, on: august3rd)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace)

    try FileManager.default.removeItem(at: recordDirectory)
    try Data().write(to: recordDirectory)

    let refusal = screen.change(
        gym, toName: "Gym 🏋️",
        on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(refusal == .notKept)
    #expect(screen.refusedChange == .changing(gym, .notKept))
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test(
    "a change a commitments screen could not carry over at the record place leaves the roster place as it was"
)
func aChangeACommitmentsScreenCouldNotCarryOverAtTheRecordPlaceLeavesTheRosterPlaceAsItWas() throws {
    let rosterDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let rosterPlace = rosterDirectory.appendingPathComponent("roster.json")
    let recordDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let recordPlace = recordDirectory.appendingPathComponent("record.json")
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: recordPlace)
    try recordStore.add(Tick(gym, on: august3rd)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace)
    let rosterBytesBefore = try Data(contentsOf: rosterPlace)

    try FileManager.default.removeItem(at: recordDirectory)
    try Data().write(to: recordDirectory)

    let refusal = screen.change(
        gym, toName: "Gym 🏋️",
        on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(refusal == .notKept)
    #expect(try Data(contentsOf: rosterPlace) == rosterBytesBefore)
}

@MainActor
@Test(
    "a change refused at the roster place after its records were carried over leaves the record place as it was"
)
func aChangeRefusedAtTheRosterPlaceAfterItsRecordsWereCarriedOverLeavesTheRecordPlaceAsItWas() throws {
    let rosterDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let rosterPlace = rosterDirectory.appendingPathComponent("roster.json")
    let recordDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let recordPlace = recordDirectory.appendingPathComponent("record.json")
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: recordPlace)
    try recordStore.add(Tick(gym, on: august3rd)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace)

    let recordBytesBeforeChange = try Data(contentsOf: recordPlace)

    try FileManager.default.removeItem(at: rosterDirectory)
    try Data().write(to: rosterDirectory)

    let refusal = screen.change(
        gym, toName: "Gym 🏋️", on: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        under: nil)

    #expect(refusal == .notKept)
    #expect(try Data(contentsOf: recordPlace) == recordBytesBeforeChange)
}

@MainActor
@Test(
    "a name and a rhythm changed in one save and refused at the roster place leave the record place as it was"
)
func aNameAndARhythmChangedInOneSaveAndRefusedAtTheRosterPlaceLeaveTheRecordPlaceAsItWas() throws {
    let rosterDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let rosterPlace = rosterDirectory.appendingPathComponent("roster.json")
    let recordDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let recordPlace = recordDirectory.appendingPathComponent("record.json")
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: recordPlace)
    try recordStore.add(Tick(gym, on: august3rd)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace)

    let recordBytesBeforeChange = try Data(contentsOf: recordPlace)

    try FileManager.default.removeItem(at: rosterDirectory)
    try Data().write(to: rosterDirectory)

    let refusal = screen.change(
        gym, toName: "Gym 🏋️", on: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom, under: nil)

    #expect(refusal == .notKept)
    #expect(try Data(contentsOf: recordPlace) == recordBytesBeforeChange)
}

@MainActor
@Test("a change of rhythm whose result the roster already holds is refused as a commitment already kept")
func aChangeOfRhythmWhoseResultTheRosterAlreadyHoldsIsRefusedAsACommitmentAlreadyKept() throws {
    let places = freshRosterAndRecordPlaces()
    let originalSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let newSchedule = Schedule.weekdays([.tuesday, .thursday])
    let newRhythm: Rhythm = .weekdays([.tuesday, .thursday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: originalSchedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let twin = Commitment(name: "Gym", schedule: newSchedule, keptFrom: monday)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.add(twin)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let refusal = screen.change(gym, toName: "Gym", on: newRhythm, keptFrom: keptFrom, under: nil)

    #expect(refusal == .alreadyKept)
    #expect(screen.kept.map(\.name) == ["Gym", "Gym"])
    #expect(screen.kept.map(\.rhythmInWords) == ["Mon, Wed, Sat", "Tue, Thu"])
}

@MainActor
@Test(
    "a name and a rhythm changed in one save whose result the roster already holds are refused as a commitment already kept"
)
func aNameAndARhythmChangedInOneSaveWhoseResultTheRosterAlreadyHoldsAreRefusedAsACommitmentAlreadyKept()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let originalSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let newRhythm: Rhythm = .weekdays([.tuesday, .thursday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: originalSchedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: originalSchedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.add(run)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let refusal = screen.change(
        gym, toName: "Run", on: newRhythm, keptFrom: keptFrom, under: nil)

    #expect(refusal == .alreadyKept)
    #expect(screen.kept.map(\.name) == ["Gym", "Run"])
    #expect(screen.kept.map(\.rhythmInWords) == ["Mon, Wed, Sat", "Mon, Wed, Sat"])
}

@MainActor
@Test(
    "a name, a later day kept from and a rhythm changed in one save past a day recorded on is refused"
)
func aNameALaterDayKeptFromAndARhythmChangedInOneSavePastADayRecordedOnIsRefused() throws {
    let places = freshRosterAndRecordPlaces()
    let originalSchedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 6, day: 1)!
    let laterKeptFrom = CalendarDate(year: 2026, month: 9, day: 1)!
    let gym = Commitment(name: "Gym", schedule: originalSchedule, keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: august3rd)!)
    let rosterBytes = try Data(contentsOf: places.roster)
    let recordBytes = try Data(contentsOf: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym 🏋️", on: .weekdays([.tuesday, .thursday]), keptFrom: laterKeptFrom,
        under: nil)

    #expect(refusal == .wouldLeaveARecordedDayNotDue)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test("a change of rhythm a commitments screen could not keep leaves both its lists as they were")
func aChangeOfRhythmACommitmentsScreenCouldNotKeepLeavesBothItsListsAsTheyWere() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let originalSchedule: Schedule = .weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(name: "Gym", schedule: originalSchedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    try FileManager.default.removeItem(at: places.roster)
    try FileManager.default.createDirectory(at: places.roster, withIntermediateDirectories: true)

    let refusal = screen.change(
        gym, toName: "Gym", on: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom, under: nil)

    #expect(refusal == .notKept)
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.kept.map(\.rhythmInWords) == ["Mon, Wed, Sat"])
    #expect(screen.stopped.isEmpty)
    #expect(screen.refusedChange == .changing(gym, .notKept))
}

@MainActor
@Test("a take-up-again a commitments screen could not keep leaves both its lists as they were")
func aTakeUpAgainACommitmentsScreenCouldNotKeepLeavesBothItsListsAsTheyWere() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    let refusal = screen.keepAgain(gym)

    #expect(refusal == .notKept)
    #expect(screen.kept.map(\.name) == ["Journaling"])
    #expect(screen.stopped.map(\.name) == ["Gym"])
}

/// A commitments screen with a standing refused change (an empty-name define) and a roster
/// holding "Gym" under "Sport" and "Journaling" — stopped as of Sunday 30 August 2026 — under no
/// category, opened as of Monday 31 August 2026. The nine tests below ask a different act this
/// screen cannot reach — a commitment or a group neither list draws, or a call with nothing to
/// act on — and check only that the refused change from the empty-name define, and both lists,
/// stand exactly where this leaves them.
@MainActor
private func screenWithAStandingRefusalAndAStoppedJournaling() throws -> (
    screen: CommitmentsScreen, gym: Commitment, journaling: Commitment, dailySchedule: Schedule,
    keptFrom: CalendarDate, allWeekdays: Rhythm
) {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym, under: "Sport")
    try rosterStore.add(journaling, under: nil)
    try rosterStore.retire(journaling, keptUntil: sunday)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    _ = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)

    return (screen, gym, journaling, daily, keptFrom, allWeekdays)
}

/// The THEN every test below shares: the refused change from the empty-name define still
/// stands, and both lists are exactly what `screenWithAStandingRefusalAndAStoppedJournaling()`
/// left them — "Gym" under "Sport", and "Journaling" stopped.
@MainActor
private func expectStandingRefusalAndStoppedJournaling(on screen: CommitmentsScreen, gym: Commitment) {
    #expect(screen.refusedChange == .defining(.namesNothing))
    #expect(screen.keptGroups == [Roster.Group(category: "Sport", commitments: [gym])])
    #expect(screen.stopped.map(\.name) == ["Journaling"])
}

@MainActor
@Test(
    "what a commitments screen holds about a refused change stands when a stop is asked about a commitment it does not keep"
)
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenAStopIsAskedAboutACommitmentItDoesNotKeep()
    throws
{
    let (screen, gym, journaling, _, _, _) = try screenWithAStandingRefusalAndAStoppedJournaling()

    screen.askToStopKeeping(journaling)

    #expect(screen.awaitingConfirmation == nil)
    expectStandingRefusalAndStoppedJournaling(on: screen, gym: gym)
}

@MainActor
@Test(
    "what a commitments screen holds about a refused change stands when a removal is asked about a commitment on neither of its lists"
)
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenARemovalIsAskedAboutACommitmentOnNeitherOfItsLists()
    throws
{
    let (screen, gym, _, dailySchedule, keptFrom, _) =
        try screenWithAStandingRefusalAndAStoppedJournaling()
    let run = Commitment(name: "Run", schedule: dailySchedule, keptFrom: keptFrom)!

    screen.askToRemove(run)

    #expect(screen.awaitingRemoval == nil)
    expectStandingRefusalAndStoppedJournaling(on: screen, gym: gym)
}

@MainActor
@Test(
    "what a commitments screen holds about a refused change stands when a removal is confirmed with nothing awaiting removal"
)
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenARemovalIsConfirmedWithNothingAwaitingRemoval()
    throws
{
    let (screen, gym, _, _, _, _) = try screenWithAStandingRefusalAndAStoppedJournaling()

    let refusal = screen.confirmRemoving()

    #expect(refusal == nil)
    expectStandingRefusalAndStoppedJournaling(on: screen, gym: gym)
}

@MainActor
@Test(
    "what a commitments screen holds about a refused change stands when a move is asked about a commitment it does not keep"
)
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenAMoveIsAskedAboutACommitmentItDoesNotKeep()
    throws
{
    let (screen, gym, journaling, _, _, _) = try screenWithAStandingRefusalAndAStoppedJournaling()

    let moved = screen.move(journaling, toOffset: 0, under: nil)

    #expect(moved == nil)
    expectStandingRefusalAndStoppedJournaling(on: screen, gym: gym)
}

@MainActor
@Test(
    "what a commitments screen holds about a refused change stands when a commitment is dropped in a group it draws none of"
)
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenACommitmentIsDroppedInAGroupItDrawsNoneOf()
    throws
{
    let (screen, gym, _, _, _, _) = try screenWithAStandingRefusalAndAStoppedJournaling()

    let moved = screen.move(gym, toOffset: 0, under: "Evening")

    #expect(moved == nil)
    expectStandingRefusalAndStoppedJournaling(on: screen, gym: gym)
}

@MainActor
@Test(
    "what a commitments screen holds about a refused change stands when a commitment is dropped at an offset its group does not have"
)
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenACommitmentIsDroppedAtAnOffsetItsGroupDoesNotHave()
    throws
{
    let (screen, gym, _, _, _, _) = try screenWithAStandingRefusalAndAStoppedJournaling()

    let moved = screen.move(gym, toOffset: 2, under: "Sport")

    #expect(moved == nil)
    expectStandingRefusalAndStoppedJournaling(on: screen, gym: gym)
}

@MainActor
@Test(
    "what a commitments screen holds about a refused change stands when a group it draws none of is moved"
)
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenAGroupItDrawsNoneOfIsMoved() throws {
    let (screen, gym, _, _, _, _) = try screenWithAStandingRefusalAndAStoppedJournaling()

    let movedNoCategory = screen.move(group: nil, toOffset: 0)
    let movedEvening = screen.move(group: "Evening", toOffset: 0)

    #expect(movedNoCategory == nil)
    #expect(movedEvening == nil)
    expectStandingRefusalAndStoppedJournaling(on: screen, gym: gym)
}

@MainActor
@Test(
    "what a commitments screen holds about a refused change stands when a group is moved to an offset its groups do not have"
)
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenAGroupIsMovedToAnOffsetItsGroupsDoNotHave()
    throws
{
    let (screen, gym, _, _, _, _) = try screenWithAStandingRefusalAndAStoppedJournaling()

    let moved = screen.move(group: "Sport", toOffset: 2)

    #expect(moved == nil)
    expectStandingRefusalAndStoppedJournaling(on: screen, gym: gym)
}

@MainActor
@Test(
    "what a commitments screen holds about a refused change stands when a change is asked about a commitment on neither of its lists"
)
func whatACommitmentsScreenHoldsAboutARefusedChangeStandsWhenAChangeIsAskedAboutACommitmentOnNeitherOfItsLists()
    throws
{
    let (screen, gym, _, dailySchedule, keptFrom, allWeekdays) =
        try screenWithAStandingRefusalAndAStoppedJournaling()
    let run = Commitment(name: "Run", schedule: dailySchedule, keptFrom: keptFrom)!

    let changeRefusal = screen.change(
        run, toName: "Running", on: allWeekdays, keptFrom: keptFrom, under: nil)

    #expect(changeRefusal == nil)
    expectStandingRefusalAndStoppedJournaling(on: screen, gym: gym)
}

@MainActor
@Test(
    "a group whose first commitment is moved into another group is drawn where its next commitment sits"
)
func aGroupWhoseFirstCommitmentIsMovedIntoAnotherGroupIsDrawnWhereItsNextCommitmentSits() throws {
    let rosterPlace = freshRosterPlace()
    let schedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    _ = try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.add(gym)
    _ = try rosterStore.put(gym, under: "Sport")
    try rosterStore.add(magnesium)
    _ = try rosterStore.put(magnesium, under: "Supplements")

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])

    let moved = screen.move(creatine, toOffset: 1, under: "Sport")

    #expect(moved == nil)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Sport", commitments: [gym, creatine]),
                Roster.Group(category: "Supplements", commitments: [magnesium]),
            ])
}

@MainActor
@Test(
    "a commitments screen does not list a commitment its roster has stopped keeping as of a day after the one the screen was handed"
)
func aCommitmentsScreenDoesNotListACommitmentItsRosterHasStoppedKeepingAsOfADayAfterTheOneTheScreenWasHanded()
    throws
{
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.retire(gym, keptUntil: tuesday)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.kept.map(\.name) == ["Journaling"])
    #expect(screen.stopped.map(\.name) == ["Gym"])
}

@MainActor
@Test(
    "a move a commitments screen could not keep leaves the commitment under the category it was already under"
)
func aMoveACommitmentsScreenCouldNotKeepLeavesTheCommitmentUnderTheCategoryItWasAlreadyUnder() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(creatine)
    _ = try rosterStore.put(creatine, under: "Supplements")
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    try FileManager.default.removeItem(at: rosterPlace)
    try FileManager.default.createDirectory(at: rosterPlace, withIntermediateDirectories: true)

    let refusal = screen.move(gym, toOffset: 0, under: "Supplements")

    #expect(refusal == .notKept)
    #expect(
        screen.keptGroups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
}

@MainActor
@Test(
    "an interval commitment whose start differs from the day it is kept from is renamed and every day recorded on stays due"
)
func anIntervalCommitmentWhoseStartDiffersFromTheDayItIsKeptFromIsRenamedAndEveryDayRecordedOnStaysDue()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let august8th = CalendarDate(year: 2026, month: 8, day: 8)!
    let august10th = CalendarDate(year: 2026, month: 8, day: 10)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(nails)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(nails, on: august10th)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        nails, toName: "Nails 💅", on: .everyNDays(4), keptFrom: august4th, under: nil)

    #expect(refusal == nil)

    let laterRosterStore = try RosterStore(at: places.roster)
    let changed = laterRosterStore.roster.commitments.first
    #expect(changed?.isDue(on: august6th) == true)
    #expect(changed?.isDue(on: august10th) == true)
    #expect(changed?.isDue(on: august8th) == false)

    let nailsEmoji = Commitment(
        name: "Nails 💅", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!
    let laterRecordStore = try RecordStore(at: places.record)
    #expect(laterRecordStore.history.isKept(nailsEmoji, on: august10th))
}

@MainActor
@Test(
    "an interval commitment whose start differs from the day it is kept from is put under a category without touching the record place"
)
func anIntervalCommitmentWhoseStartDiffersFromTheDayItIsKeptFromIsPutUnderACategoryWithoutTouchingTheRecordPlace()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let august10th = CalendarDate(year: 2026, month: 8, day: 10)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(nails)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(nails, on: august10th)!)
    let recordBytes = try Data(contentsOf: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        nails, toName: "Nails", on: .everyNDays(4), keptFrom: august4th, under: "Care")

    #expect(refusal == nil)
    #expect(screen.keptGroups == [Roster.Group(category: "Care", commitments: [nails])])
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test(
    "an interval commitment whose start differs from the day it is kept from saved unchanged changes nothing"
)
func anIntervalCommitmentWhoseStartDiffersFromTheDayItIsKeptFromSavedUnchangedChangesNothing() throws {
    let places = freshRosterAndRecordPlaces()
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let august10th = CalendarDate(year: 2026, month: 8, day: 10)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(nails)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(nails, on: august10th)!)
    let rosterBytes = try Data(contentsOf: places.roster)
    let recordBytes = try Data(contentsOf: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        nails, toName: "Nails", on: .everyNDays(4), keptFrom: august4th, under: nil)

    #expect(refusal == nil)
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test(
    "an interval commitment whose start differs from the day it is kept from is renamed on a new rhythm and the superseded one keeps its start"
)
func anIntervalCommitmentWhoseStartDiffersFromTheDayItIsKeptFromIsRenamedOnANewRhythmAndTheSupersededOneKeepsItsStart()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let august10th = CalendarDate(year: 2026, month: 8, day: 10)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(nails)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(nails, on: august10th)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        nails, toName: "Nails 💅", on: .weekdays([.sunday]), keptFrom: august4th, under: nil)

    #expect(refusal == nil)

    let supersededNails = Commitment(
        name: "Nails 💅", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!
    let newNails = Commitment(name: "Nails 💅", schedule: .weekdays([.sunday]), keptFrom: monday)!

    let laterRosterStore = try RosterStore(at: places.roster)
    #expect(laterRosterStore.roster.commitments(on: august30th) == [newNails, supersededNails])

    let laterRecordStore = try RecordStore(at: places.record)
    #expect(laterRecordStore.history.isKept(supersededNails, on: august10th))
}

@MainActor
@Test(
    "moving the day an interval commitment is kept from moves its start to that day even where the two had differed"
)
func movingTheDayAnIntervalCommitmentIsKeptFromMovesItsStartToThatDayEvenWhereTheTwoHadDiffered()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let august7th = CalendarDate(year: 2026, month: 8, day: 7)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(nails)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        nails, toName: "Nails", on: .everyNDays(4), keptFrom: august3rd, under: nil)

    #expect(refusal == nil)

    let laterRosterStore = try RosterStore(at: places.roster)
    let changed = laterRosterStore.roster.commitments.first
    #expect(changed?.isDue(on: august3rd) == true)
    #expect(changed?.isDue(on: august7th) == true)
    #expect(changed?.isDue(on: august6th) == false)
}

@MainActor
@Test(
    "moving the day a commitment is kept from onto a commitment whose records are already kept is refused for that cause"
)
func movingTheDayACommitmentIsKeptFromOntoACommitmentWhoseRecordsAreAlreadyKeptIsRefusedForThatCause()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let august8th = CalendarDate(year: 2026, month: 8, day: 8)!
    let august9th = CalendarDate(year: 2026, month: 8, day: 9)!
    let august10th = CalendarDate(year: 2026, month: 8, day: 10)!
    let august12th = CalendarDate(year: 2026, month: 8, day: 12)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let reading = Commitment(
        name: "Reading", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!),
        keptFrom: august10th)!
    let readingKeptFromAugust8th = Commitment(
        name: "Reading", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: august8th)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(reading)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(reading, on: august12th)!)
    try recordStore.add(Tick(readingKeptFromAugust8th, on: august9th)!)
    let rosterBytes = try Data(contentsOf: places.roster)
    let recordBytes = try Data(contentsOf: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        reading, toName: "Reading", on: .weeklyQuota(3), keptFrom: august8th, under: nil)

    #expect(refusal == .recordsAlreadyExist)
    #expect(screen.kept.map(\.name) == ["Reading"])
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test("renaming a commitment with no records onto a commitment whose records are already kept is refused")
func renamingACommitmentWithNoRecordsOntoACommitmentWhoseRecordsAreAlreadyKeptIsRefused() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: schedule, keptFrom: keptFrom)!
    // A second possible source for the stray "Gym 🏋️" tick below, alike to it in every way but
    // name — with only "Gym" as a candidate, reading the places would carry the tick back before
    // the rename is ever asked for, and this scenario would no longer have anything to refuse.
    // `tasks.md` § 4.1.
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.add(run)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gymEmoji, on: august3rd)!)
    let rosterBytes = try Data(contentsOf: places.roster)
    let recordBytes = try Data(contentsOf: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym 🏋️", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(refusal == .recordsAlreadyExist)
    #expect(screen.kept.map(\.name) == ["Gym", "Run"])
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test(
    "a name and a rhythm changed in one save onto a commitment whose records are already kept are refused for that cause"
)
func aNameAndARhythmChangedInOneSaveOntoACommitmentWhoseRecordsAreAlreadyKeptAreRefusedForThatCause()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let originalSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: originalSchedule, keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: originalSchedule, keptFrom: keptFrom)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: august3rd)!)
    // The stray "Gym 🏋️" tick shares "Gym"'s own day: with a day of its own, carrying it back to
    // its one possible source ("Gym", same rhythm) would succeed when the places are read, and
    // this scenario would no longer have records already kept to refuse against. `tasks.md` § 4.2.
    try recordStore.add(Tick(gymEmoji, on: august3rd)!)
    let rosterBytes = try Data(contentsOf: places.roster)
    let recordBytes = try Data(contentsOf: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym 🏋️", on: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom, under: nil)

    #expect(refusal == .recordsAlreadyExist)
    #expect(screen.kept.count == 1)
    #expect(screen.kept.first?.name == "Gym")
    #expect(screen.kept.first?.rhythmInWords == "Mon, Wed, Sat")
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test(
    "a change that would leave a recorded day not due and meets records already kept is refused as leaving a recorded day not due"
)
func aChangeThatWouldLeaveARecordedDayNotDueAndMeetsRecordsAlreadyKeptIsRefusedAsLeavingARecordedDayNotDue()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let june1st = CalendarDate(year: 2026, month: 6, day: 1)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let august5th = CalendarDate(year: 2026, month: 8, day: 5)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: june1st)!
    let gymKeptFromAugust4th = Commitment(name: "Gym", schedule: schedule, keptFrom: august4th)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: august3rd)!)
    // "Gym" also holds a tick on the stray tick's own day: with a day of its own, carrying the
    // stray back to its one possible source ("Gym", kept-from aside) would succeed when the
    // places are read, and this scenario would no longer have records already kept to meet.
    // `tasks.md` § 4.3.
    try recordStore.add(Tick(gym, on: august5th)!)
    try recordStore.add(Tick(gymKeptFromAugust4th, on: august5th)!)
    let rosterBytes = try Data(contentsOf: places.roster)
    let recordBytes = try Data(contentsOf: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: august4th, under: nil)

    #expect(refusal == .wouldLeaveARecordedDayNotDue)
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test(
    "an interval commitment restarted from today is kept until yesterday and runs on from today under its name, interval and category"
)
func anIntervalCommitmentRestartedFromTodayIsKeptUntilYesterdayAndRunsOnFromTodayUnderItsNameIntervalAndCategory()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let august10th = CalendarDate(year: 2026, month: 8, day: 10)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!
    let restartedNails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: monday), keptFrom: monday)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(nails, under: "Care")
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(nails, on: august10th)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let recordBytesAfterOpen = try Data(contentsOf: places.record)

    let refusal = screen.restart(nails, from: monday)

    #expect(refusal == nil)
    #expect(screen.keptGroups == [Roster.Group(category: "Care", commitments: [restartedNails])])
    #expect(screen.kept.map(\.rhythmInWords) == ["Every 4 days"])

    let rosterStoreAfterwards = try RosterStore(at: places.roster)
    #expect(rosterStoreAfterwards.roster.commitments(on: august30th) == [restartedNails, nails])
    #expect(rosterStoreAfterwards.roster.commitments(on: monday) == [restartedNails])

    #expect(try Data(contentsOf: places.record) == recordBytesAfterOpen)
}

@MainActor
@Test(
    "restarting an interval commitment carries every record on or after the day it restarts from onto the restarted commitment"
)
func restartingAnIntervalCommitmentCarriesEveryRecordOnOrAfterTheDayItRestartsFromOntoTheRestartedCommitment()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let august1st = CalendarDate(year: 2026, month: 8, day: 1)!
    let august2nd = CalendarDate(year: 2026, month: 8, day: 2)!
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let august10th = CalendarDate(year: 2026, month: 8, day: 10)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august1st)!
    let restartedNails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august2nd),
        keptFrom: august2nd)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(nails)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(nails, on: august6th)!)
    try recordStore.add(Tick(nails, on: august10th)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.restart(nails, from: august2nd)

    #expect(refusal == nil)

    let recordStoreAfterwards = try RecordStore(at: places.record)
    #expect(recordStoreAfterwards.history.isKept(restartedNails, on: august6th))
    #expect(recordStoreAfterwards.history.isKept(restartedNails, on: august10th))
    #expect(!recordStoreAfterwards.history.isKept(nails, on: august6th))
    #expect(!recordStoreAfterwards.history.isKept(nails, on: august10th))
}

@MainActor
@Test(
    "an interval commitment restarted from the day it is kept from is kept on no date before the restart"
)
func anIntervalCommitmentRestartedFromTheDayItIsKeptFromIsKeptOnNoDateBeforeTheRestart() throws {
    let places = freshRosterAndRecordPlaces()
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let august8th = CalendarDate(year: 2026, month: 8, day: 8)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!
    let restartedNails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august4th),
        keptFrom: august4th)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(nails)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.restart(nails, from: august4th)

    #expect(refusal == nil)

    let rosterStoreAfterwards = try RosterStore(at: places.roster)
    let restartedCommitment = try #require(rosterStoreAfterwards.roster.commitments(on: august4th).first)
    #expect(restartedCommitment.isDue(on: august4th))
    #expect(restartedCommitment.isDue(on: august8th))
    #expect(!restartedCommitment.isDue(on: august6th))
    #expect(rosterStoreAfterwards.roster.commitments(on: august4th) == [restartedNails])
}

@MainActor
@Test(
    "an interval commitment restarted through a commitments screen draws one row on a day screen on either side of the restart"
)
func anIntervalCommitmentRestartedThroughACommitmentsScreenDrawsOneRowOnADayScreenOnEitherSideOfTheRestart()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let september3rd = CalendarDate(year: 2026, month: 9, day: 3)!
    let september4th = CalendarDate(year: 2026, month: 9, day: 4)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(nails)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.restart(nails, from: monday)

    #expect(refusal == nil)

    let sundayScreen = DayScreen(
        startingFrom: [], asOf: august30th, keepingRecordAt: places.record,
        keepingRosterAt: places.roster)
    #expect(sundayScreen.dayView.rows.map(\.name) == ["Nails"])

    let mondayScreen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: places.record,
        keepingRosterAt: places.roster)
    #expect(mondayScreen.dayView.rows.map(\.name) == ["Nails"])

    let fridayScreen = DayScreen(
        startingFrom: [], asOf: september4th, keepingRecordAt: places.record,
        keepingRosterAt: places.roster)
    #expect(fridayScreen.dayView.rows.map(\.name) == ["Nails"])

    let thursdayScreen = DayScreen(
        startingFrom: [], asOf: september3rd, keepingRecordAt: places.record,
        keepingRosterAt: places.roster)
    #expect(thursdayScreen.dayView.rows.isEmpty)
}

@MainActor
@Test(
    "a restart from a day after today, a day before the day kept from, or a day the rhythm is already due on is refused, each told apart"
)
func aRestartFromADayAfterTodayADayBeforeTheDayKeptFromOrADayTheRhythmIsAlreadyDueOnIsRefusedEachToldApart()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let september1st = CalendarDate(year: 2026, month: 9, day: 1)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(nails)
    let rosterBytes = try Data(contentsOf: places.roster)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let afterTodayRefusal = screen.restart(nails, from: september1st)
    let beforeKeptFromRefusal = screen.restart(nails, from: august3rd)
    let alreadyDueRefusal = screen.restart(nails, from: august30th)

    #expect(afterTodayRefusal == .restartDayIsAfterToday)
    #expect(beforeKeptFromRefusal == .restartDayIsBeforeKeptFrom)
    #expect(alreadyDueRefusal == .alreadyDueOnRestartDay)
    #expect(screen.kept.map(\.name) == ["Nails"])
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    #expect(!FileManager.default.fileExists(atPath: places.record.path))
}

@MainActor
@Test("a restart that would leave a day recorded on after it not due is refused")
func aRestartThatWouldLeaveADayRecordedOnAfterItNotDueIsRefused() throws {
    let places = freshRosterAndRecordPlaces()
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let august29th = CalendarDate(year: 2026, month: 8, day: 29)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(nails)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(nails, on: august30th)!)
    let rosterBytes = try Data(contentsOf: places.roster)
    let recordBytes = try Data(contentsOf: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.restart(nails, from: august29th)

    #expect(refusal == .wouldLeaveARecordedDayNotDue)
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test("a restart onto a commitment whose records are already kept is refused for that cause")
func aRestartOntoACommitmentWhoseRecordsAreAlreadyKeptIsRefusedForThatCause() throws {
    let places = freshRosterAndRecordPlaces()
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!
    let strayRestartedNails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: monday), keptFrom: monday)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(nails)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(strayRestartedNails, on: monday)!)
    let rosterBytes = try Data(contentsOf: places.roster)
    let recordBytes = try Data(contentsOf: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.restart(nails, from: monday)

    #expect(refusal == .recordsAlreadyExist)
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test("a restart whose result the roster already holds is refused as a commitment already kept")
func aRestartWhoseResultTheRosterAlreadyHoldsIsRefusedAsACommitmentAlreadyKept() throws {
    let places = freshRosterAndRecordPlaces()
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!
    let secondNails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: monday), keptFrom: monday)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(nails)
    try rosterStore.add(secondNails)
    try rosterStore.remove(secondNails, keptUntil: august30th)
    let rosterBytes = try Data(contentsOf: places.roster)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.restart(nails, from: monday)

    #expect(refusal == .alreadyKept)
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
}

@MainActor
@Test(
    "a restart refused at the roster place after its records were carried over leaves the record place as it was"
)
func aRestartRefusedAtTheRosterPlaceAfterItsRecordsWereCarriedOverLeavesTheRecordPlaceAsItWas() throws {
    let rosterDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let rosterPlace = rosterDirectory.appendingPathComponent("roster.json")
    let recordDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let recordPlace = recordDirectory.appendingPathComponent("record.json")
    let august1st = CalendarDate(year: 2026, month: 8, day: 1)!
    let august2nd = CalendarDate(year: 2026, month: 8, day: 2)!
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let august10th = CalendarDate(year: 2026, month: 8, day: 10)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august1st)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(nails)
    let recordStore = try RecordStore(at: recordPlace)
    try recordStore.add(Tick(nails, on: august6th)!)
    try recordStore.add(Tick(nails, on: august10th)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace)

    let recordBytesBeforeRestart = try Data(contentsOf: recordPlace)

    try FileManager.default.removeItem(at: rosterDirectory)
    try Data().write(to: rosterDirectory)

    let refusal = screen.restart(nails, from: august2nd)

    #expect(refusal == .notKept)
    #expect(try Data(contentsOf: recordPlace) == recordBytesBeforeRestart)
    #expect(screen.kept.map(\.name) == ["Nails"])
    #expect(screen.refusedChange == .restarting(nails, .notKept))
}

@MainActor
@Test(
    "a restart a commitments screen could not carry over at the record place leaves the roster place as it was"
)
func aRestartACommitmentsScreenCouldNotCarryOverAtTheRecordPlaceLeavesTheRosterPlaceAsItWas() throws {
    let rosterDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let rosterPlace = rosterDirectory.appendingPathComponent("roster.json")
    let recordDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let recordPlace = recordDirectory.appendingPathComponent("record.json")
    let august1st = CalendarDate(year: 2026, month: 8, day: 1)!
    let august2nd = CalendarDate(year: 2026, month: 8, day: 2)!
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august1st)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(nails)
    let recordStore = try RecordStore(at: recordPlace)
    try recordStore.add(Tick(nails, on: august6th)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace)

    let rosterBytesBeforeRestart = try Data(contentsOf: rosterPlace)

    try FileManager.default.removeItem(at: recordDirectory)
    try Data().write(to: recordDirectory)

    let refusal = screen.restart(nails, from: august2nd)

    #expect(refusal == .notKept)
    #expect(try Data(contentsOf: rosterPlace) == rosterBytesBeforeRestart)
}

@MainActor
@Test("a commitments screen says only a kept interval commitment can be restarted")
func aCommitmentsScreenSaysOnlyAKeptIntervalCommitmentCanBeRestarted() throws {
    let rosterPlace = freshRosterPlace()
    let january1st = CalendarDate(year: 2026, month: 1, day: 1)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: january1st),
        keptFrom: january1st)!
    let lenses = Commitment(
        name: "Lenses", schedule: .everyNDays(DayInterval(days: 4)!, from: january1st),
        keptFrom: january1st)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: january1st)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(nails)
    try rosterStore.add(lenses)
    try rosterStore.add(gym)
    try rosterStore.retire(lenses, keptUntil: august30th)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    #expect(screen.whatItIsMadeOf(nails)?.canRestart == true)
    #expect(screen.whatItIsMadeOf(lenses)?.canRestart == false)
    #expect(screen.whatItIsMadeOf(gym)?.canRestart == false)
    #expect(screen.dayToKeepFrom == monday)
}

@MainActor
@Test("a restart asked of a commitment that cannot be restarted does nothing and says nothing")
func aRestartAskedOfACommitmentThatCannotBeRestartedDoesNothingAndSaysNothing() throws {
    let places = freshRosterAndRecordPlaces()
    let january1st = CalendarDate(year: 2026, month: 1, day: 1)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let lenses = Commitment(
        name: "Lenses", schedule: .everyNDays(DayInterval(days: 4)!, from: january1st),
        keptFrom: january1st)!
    let pool = Commitment(
        name: "Pool", schedule: .everyNDays(DayInterval(days: 4)!, from: january1st),
        keptFrom: january1st)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: january1st)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(lenses)
    try rosterStore.add(pool)
    try rosterStore.add(gym)
    try rosterStore.retire(lenses, keptUntil: august30th)
    try rosterStore.remove(pool, keptUntil: august30th)
    let rosterBytes = try Data(contentsOf: places.roster)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let lensesRefusal = screen.restart(lenses, from: monday)
    let poolRefusal = screen.restart(pool, from: monday)
    let gymRefusal = screen.restart(gym, from: monday)

    #expect(lensesRefusal == nil)
    #expect(poolRefusal == nil)
    #expect(gymRefusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    #expect(!FileManager.default.fileExists(atPath: places.record.path))
}

@MainActor
@Test("a change that carries records leaves no save in progress once it is kept")
func aChangeThatCarriesRecordsLeavesNoSaveInProgressOnceItIsKept() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: august3rd)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym 🏋️", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(refusal == nil)
    #expect(
        !FileManager.default.fileExists(
            atPath: SaveInProgress.place(besideRecordAt: places.record).path))
}

@MainActor
@Test(
    "a change that carries no record is kept where nothing beside the record place can be written"
)
func aChangeThatCarriesNoRecordIsKeptWhereNothingBesideTheRecordPlaceCanBeWritten() throws {
    let rosterDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let rosterPlace = rosterDirectory.appendingPathComponent("roster.json")
    let recordDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let recordPlace = recordDirectory.appendingPathComponent("record.json")
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(run)
    let recordStore = try RecordStore(at: recordPlace)
    try recordStore.add(Tick(gym, on: august3rd)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace)

    try FileManager.default.removeItem(at: recordDirectory)
    try Data().write(to: recordDirectory)

    let gymRefusal = screen.change(
        gym, toName: "Gym", on: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom, under: nil)
    let runRefusal = screen.change(
        run, toName: "Running", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(gymRefusal == nil)
    #expect(runRefusal == nil)
    #expect(screen.kept.map(\.name) == ["Gym", "Running"])
    #expect(screen.kept.map(\.rhythmInWords) == ["Tue, Thu", "Every day"])
}

@MainActor
@Test(
    "a change refused at the roster place after carrying its records leaves no save in progress and a roster still kept"
)
func aChangeRefusedAtTheRosterPlaceAfterCarryingItsRecordsLeavesNoSaveInProgressAndARosterStillKept()
    throws
{
    let rosterDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let rosterPlace = rosterDirectory.appendingPathComponent("roster.json")
    let recordDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let recordPlace = recordDirectory.appendingPathComponent("record.json")
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: recordPlace)
    try recordStore.add(Tick(gym, on: august3rd)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace)

    try FileManager.default.removeItem(at: rosterDirectory)
    try Data().write(to: rosterDirectory)

    let refusal = screen.change(
        gym, toName: "Gym 🏋️", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(refusal == .notKept)
    #expect(
        !FileManager.default.fileExists(
            atPath: SaveInProgress.place(besideRecordAt: recordPlace).path))
    #expect(screen.rosterState == .kept)
    #expect(screen.kept.map(\.name) == ["Gym"])
}

/// Unit test beside 3.3's own, which only checks the roster and whether the save in progress
/// file exists: neither catches this screen going on to write a stale copy of its own record
/// mirror back over a correction `SaveInProgress.undoTornSave` already made at the record place
/// through a second, disjoint `RecordStore` — a regression from `main`, where the undo ran
/// through this screen's own `recordStore`. Proven by a *second* change through the same screen,
/// after the first is refused and undone: only a write that reaches the record place again can
/// show whether this screen's own copy was ever brought back into step.
@MainActor
@Test(
    "a change kept after an earlier undone torn save does not write this screen's stale record mirror back over the correction"
)
func aChangeKeptAfterAnEarlierUndoneTornSaveDoesNotWriteThisScreensStaleRecordMirrorBackOverTheCorrection()
    throws
{
    let rosterDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let rosterPlace = rosterDirectory.appendingPathComponent("roster.json")
    let recordDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let recordPlace = recordDirectory.appendingPathComponent("record.json")
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let running = Commitment(name: "Running", schedule: schedule, keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.add(run)
    let recordStore = try RecordStore(at: recordPlace)
    try recordStore.add(Tick(gym, on: august3rd)!)
    try recordStore.add(Tick(run, on: august4th)!)
    let rosterBytes = try Data(contentsOf: rosterPlace)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace)

    try FileManager.default.removeItem(at: rosterDirectory)
    try Data().write(to: rosterDirectory)

    let firstRefusal = screen.change(
        gym, toName: "Gym 🏋️", on: Rhythm(schedule), keptFrom: keptFrom, under: nil)
    #expect(firstRefusal == .notKept)

    try FileManager.default.removeItem(at: rosterDirectory)
    try FileManager.default.createDirectory(at: rosterDirectory, withIntermediateDirectories: true)
    try rosterBytes.write(to: rosterPlace)

    let secondRefusal = screen.change(
        run, toName: "Running", on: Rhythm(schedule), keptFrom: keptFrom, under: nil)
    #expect(secondRefusal == nil)

    let laterRecordStore = try RecordStore(at: recordPlace)
    #expect(laterRecordStore.history.isKept(gym, on: august3rd))
    #expect(!laterRecordStore.history.isKept(gymEmoji, on: august3rd))
    #expect(laterRecordStore.history.isKept(running, on: august4th))
}

/// Companion to the test above: where the undo itself cannot be completed — a fresh read of the
/// roster place, made by `SaveInProgress.undoTornSave` independently of this screen's own
/// already-open `RosterStore`, throws — this screen SHALL from then on hold a torn save it
/// cannot undo, `openspec/specs/commitment/spec.md` § *A change that carries records leaves a
/// save in progress until its roster place is written*. Before this fix the `Bool`
/// `undoTornSave` answers was thrown away, so `rosterState` stayed `.kept` and the lists stayed
/// drawn.
@MainActor
@Test(
    "a change refused at the roster place holds a torn save it cannot undo where the undo itself fails"
)
func aChangeRefusedAtTheRosterPlaceHoldsATornSaveItCannotUndoWhereTheUndoItselfFails() throws {
    let rosterDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let rosterPlace = rosterDirectory.appendingPathComponent("roster.json")
    let recordDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let recordPlace = recordDirectory.appendingPathComponent("record.json")
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: recordPlace)
    try recordStore.add(Tick(gym, on: august3rd)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace)

    // What is at the roster place stops being a roster at all — a fresh `RosterStore(at:)` reads
    // this and throws — and the directory then stops taking writes too, so the change's own
    // write to the roster place still fails as scenario 3.3 needs, but the screen's own
    // already-open `RosterStore`, read before either of these, is untouched.
    try Data("not a roster".utf8).write(to: rosterPlace)
    try FileManager.default.setAttributes(
        [.posixPermissions: 0o500], ofItemAtPath: rosterDirectory.path)
    defer {
        try? FileManager.default.setAttributes(
            [.posixPermissions: 0o700], ofItemAtPath: rosterDirectory.path)
    }

    let refusal = screen.change(
        gym, toName: "Gym 🏋️", on: Rhythm(schedule), keptFrom: keptFrom, under: nil)

    #expect(refusal == .notKept)
    #expect(screen.rosterState == .notKept)
    #expect(screen.kept.isEmpty)
    #expect(screen.stopped.isEmpty)
    #expect(
        FileManager.default.fileExists(
            atPath: SaveInProgress.place(besideRecordAt: recordPlace).path))
}

/// The same requirement as the test above, on the success path rather than the roster's own
/// write failing: `undoTornSaveMadeDuringThisChange()` already clears `self.rosterStore`,
/// `rosterState`, `self.recordStore` and every list when the undo it runs fails — the test above
/// proves that. What it did not prove is that the three call sites *after a roster write that
/// landed* — `change`'s same-rhythm path, its both-changed path, and `restart` — stop there too:
/// each fell straight through to `refreshLists(from: rosterStore)`, `rosterStore` being the
/// `guard let rosterStore` bound at the top of this call, still set and still reflecting the
/// write, which redrew the lists from the very roster this screen can no longer answer for.
///
/// Reproduced without a new seam. `commitment` carries no record, so this call's own
/// `keepSaveInProgressIfCarrying` has nothing to carry and never touches the save-in-progress
/// place — `hasRecords` false, `design.md` § *The save in progress lives beside the record place,
/// not at a place of its own* — which leaves the place free to plant a save in progress at
/// directly, once the screen has already opened clean, naming the very commitment this call's own
/// roster write is about to write under. `makeImmutable(_:)` then stops
/// `SaveInProgress.undoTornSave`'s own `takeAway` from removing it once that write lands and the
/// undo finds the roster already holding what the file names: reading it still succeeds, so the
/// undo reaches that check at all, and only the removal fails, matching "taking the save in
/// progress away … fails" once the roster write has landed rather than "re-reading it" failing.
@MainActor
@Test(
    "a change kept at the roster place holds a torn save it cannot undo where taking it away fails"
)
func aChangeKeptAtTheRosterPlaceHoldsATornSaveItCannotUndoWhereTakingItAwayFails() throws {
    let rosterDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let rosterPlace = rosterDirectory.appendingPathComponent("roster.json")
    let recordDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let recordPlace = recordDirectory.appendingPathComponent("record.json")
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace)
    #expect(screen.kept == [gym])

    let saveInProgressPlace = SaveInProgress.place(besideRecordAt: recordPlace)
    try SaveInProgress(carriedFrom: gym, to: gymEmoji).keep(at: saveInProgressPlace)
    try makeImmutable(saveInProgressPlace)
    defer { try? makeMutable(saveInProgressPlace) }

    let refusal = screen.change(
        gym, toName: "Gym 🏋️", on: Rhythm(schedule), keptFrom: keptFrom, under: nil)

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.rosterState == .notKept)
    #expect(screen.kept.isEmpty)
    #expect(screen.keptGroups.isEmpty)
    #expect(screen.stopped.isEmpty)
    #expect(FileManager.default.fileExists(atPath: saveInProgressPlace.path))

    let laterRosterStore = try RosterStore(at: rosterPlace)
    #expect(laterRosterStore.roster.entries.map(\.commitment) == [gymEmoji])
}

/// Companion to the test above, covering the second of the three calls after a roster write that
/// landed, named in the older test's docstring above: the branch taken when both the name and the
/// rhythm change in one save, which lands its own roster write — a rename onto `carryTarget`
/// then a supersession onto `finalNewCommitment`, both applied to one in-memory `Roster` before
/// it is replaced — before reaching its own `undoTornSaveMadeDuringThisChange()` guard.
/// Reproduced the same way as the test above: `gym` carries no record, so this call's own
/// `keepSaveInProgressIfCarrying` never touches the save-in-progress place, leaving it free to
/// plant a save in progress at directly, naming the commitment the roster write below is about
/// to carry `gym` to.
@MainActor
@Test(
    "a change with a new name and rhythm kept at the roster place holds a torn save it cannot undo where taking it away fails"
)
func aChangeWithANewNameAndRhythmKeptAtTheRosterPlaceHoldsATornSaveItCannotUndoWhereTakingItAwayFails()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let originalSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: originalSchedule, keptFrom: keptFrom)!
    let carryTarget = Commitment(name: "Gym 🏋️", schedule: originalSchedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    #expect(screen.kept == [gym])

    let saveInProgressPlace = SaveInProgress.place(besideRecordAt: places.record)
    try SaveInProgress(carriedFrom: gym, to: carryTarget).keep(at: saveInProgressPlace)
    try makeImmutable(saveInProgressPlace)
    defer { try? makeMutable(saveInProgressPlace) }

    let refusal = screen.change(
        gym, toName: "Gym 🏋️", on: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom, under: nil)

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.rosterState == .notKept)
    #expect(screen.kept.isEmpty)
    #expect(screen.keptGroups.isEmpty)
    #expect(screen.stopped.isEmpty)
    #expect(FileManager.default.fileExists(atPath: saveInProgressPlace.path))

    let laterRosterStore = try RosterStore(at: places.roster)
    let newGym = Commitment(
        name: "Gym 🏋️", schedule: .weekdays([.tuesday, .thursday]), keptFrom: monday)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    #expect(laterRosterStore.roster.commitments(on: sunday) == [newGym, carryTarget])
}

/// Companion to the two tests above, covering the third of the three calls after a roster write
/// that landed, named in the older test's docstring above: `restart`'s own guard. Reproduced the
/// same way: `nails` carries no record on or after the day it restarts from, so this call's own
/// `keepSaveInProgressIfCarrying` never touches the save-in-progress place, leaving it free to
/// plant a save in progress at directly, naming the restarted commitment the roster write below
/// is about to carry `nails` to.
@MainActor
@Test(
    "a restart kept at the roster place holds a torn save it cannot undo where taking it away fails"
)
func aRestartKeptAtTheRosterPlaceHoldsATornSaveItCannotUndoWhereTakingItAwayFails() throws {
    let places = freshRosterAndRecordPlaces()
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!
    let restartedNails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: monday), keptFrom: monday)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(nails)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    #expect(screen.kept == [nails])

    let saveInProgressPlace = SaveInProgress.place(besideRecordAt: places.record)
    try SaveInProgress(carriedFrom: nails, to: restartedNails).keep(at: saveInProgressPlace)
    try makeImmutable(saveInProgressPlace)
    defer { try? makeMutable(saveInProgressPlace) }

    let refusal = screen.restart(nails, from: monday)

    #expect(refusal == nil)
    #expect(screen.refusedChange == nil)
    #expect(screen.rosterState == .notKept)
    #expect(screen.kept.isEmpty)
    #expect(screen.keptGroups.isEmpty)
    #expect(screen.stopped.isEmpty)
    #expect(FileManager.default.fileExists(atPath: saveInProgressPlace.path))

    let laterRosterStore = try RosterStore(at: places.roster)
    #expect(laterRosterStore.roster.commitments(on: august30th) == [restartedNails, nails])
}

@MainActor
@Test("a rename torn between its two places is undone when a commitments screen is opened")
func aRenameTornBetweenItsTwoPlacesIsUndoneWhenACommitmentsScreenIsOpened() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: schedule, keptFrom: keptFrom)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gymEmoji, on: august3rd)!)
    try SaveInProgress(carriedFrom: gym, to: gymEmoji).keep(
        at: SaveInProgress.place(besideRecordAt: places.record))

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    #expect(screen.kept.map(\.name) == ["Gym"])

    let laterRecordStore = try RecordStore(at: places.record)
    #expect(laterRecordStore.history.isKept(gym, on: august3rd))
    #expect(!laterRecordStore.history.isKept(gymEmoji, on: august3rd))
    #expect(
        !FileManager.default.fileExists(
            atPath: SaveInProgress.place(besideRecordAt: places.record).path))
    #expect(!screen.recordsBelongToNoCommitment)
}

@MainActor
@Test("a save in progress for a save its roster took is taken away and nothing else is written")
func aSaveInProgressForASaveItsRosterTookIsTakenAwayAndNothingElseIsWritten() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: schedule, keptFrom: keptFrom)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gymEmoji)
    try rosterStore.remove(gymEmoji, keptUntil: august30th)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gymEmoji, on: august3rd)!)
    try SaveInProgress(carriedFrom: gym, to: gymEmoji).keep(
        at: SaveInProgress.place(besideRecordAt: places.record))

    let rosterBytes = try Data(contentsOf: places.roster)
    let recordBytes = try Data(contentsOf: places.record)

    _ = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    #expect(
        !FileManager.default.fileExists(
            atPath: SaveInProgress.place(besideRecordAt: places.record).path))
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test("a commitments screen opened on a save in progress it cannot read lists nothing and defines nothing")
func aCommitmentsScreenOpenedOnASaveInProgressItCannotReadListsNothingAndDefinesNothing() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let saveInProgressPlace = SaveInProgress.place(besideRecordAt: places.record)
    try FileManager.default.createDirectory(
        at: saveInProgressPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a save in progress".utf8).write(to: saveInProgressPlace)

    let rosterBytes = try Data(contentsOf: places.roster)
    let saveInProgressBytes = try Data(contentsOf: saveInProgressPlace)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.define(
        name: "Run", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(refusal == .notKept)
    #expect(screen.rosterState == .notKept)
    #expect(screen.kept.isEmpty)
    #expect(screen.stopped.isEmpty)
    #expect(!screen.recordsBelongToNoCommitment)
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    #expect(try Data(contentsOf: saveInProgressPlace) == saveInProgressBytes)
}

@MainActor
@Test("an orphaned record with one possible source is carried back to it when a commitments screen is opened")
func anOrphanedRecordWithOnePossibleSourceIsCarriedBackToItWhenACommitmentsScreenIsOpened() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gymSchedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: gymSchedule, keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: gymSchedule, keptFrom: keptFrom)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.add(run)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gymEmoji, on: august3rd)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let laterRecordStore = try RecordStore(at: places.record)
    #expect(laterRecordStore.history.isKept(gym, on: august3rd))
    #expect(!laterRecordStore.history.isKept(gymEmoji, on: august3rd))
    #expect(!screen.recordsBelongToNoCommitment)
}

@MainActor
@Test("an orphaned record with two possible sources stays where it is and is said")
func anOrphanedRecordWithTwoPossibleSourcesStaysWhereItIsAndIsSaid() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: schedule, keptFrom: keptFrom)!
    let creatin = Commitment(name: "Creatin", schedule: schedule, keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(creatine)
    try rosterStore.add(magnesium)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(creatin, on: august3rd)!)
    let recordBytes = try Data(contentsOf: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    #expect(screen.recordsBelongToNoCommitment)
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test("an orphaned record that would land on a day its source already holds moves none of its records")
func anOrphanedRecordThatWouldLandOnADayItsSourceAlreadyHoldsMovesNoneOfItsRecords() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: schedule, keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: august3rd)!)
    try recordStore.add(Tick(gymEmoji, on: august3rd)!)
    try recordStore.add(Tick(gymEmoji, on: august4th)!)
    let recordBytes = try Data(contentsOf: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    #expect(screen.recordsBelongToNoCommitment)
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test("two orphaned commitments with the same one possible source both stay where they are")
func twoOrphanedCommitmentsWithTheSameOnePossibleSourceBothStayWhereTheyAre() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: schedule, keptFrom: keptFrom)!
    let gym2 = Commitment(name: "Gym 2", schedule: schedule, keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gymEmoji, on: august3rd)!)
    try recordStore.add(Tick(gym2, on: august4th)!)
    let recordBytes = try Data(contentsOf: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    #expect(screen.recordsBelongToNoCommitment)
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test("a commitments screen stops saying records belong to no commitment once their commitment is taken on")
func aCommitmentsScreenStopsSayingRecordsBelongToNoCommitmentOnceTheirCommitmentIsTakenOn() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let gymEmoji = Commitment(
        name: "Gym 🏋️", schedule: .weekdays([.tuesday, .thursday]), keptFrom: august4th)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gymEmoji, on: august4th)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    #expect(screen.recordsBelongToNoCommitment)

    let otherRosterStore = try RosterStore(at: places.roster)
    try otherRosterStore.add(gymEmoji)

    screen.shown(asOf: monday)

    #expect(!screen.recordsBelongToNoCommitment)
}

@MainActor
@Test("a commitments screen that cannot read its record does not say records belong to no commitment")
func aCommitmentsScreenThatCannotReadItsRecordDoesNotSayRecordsBelongToNoCommitment() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try FileManager.default.createDirectory(
        at: places.record.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a record is written as".utf8).write(to: places.record)
    let recordBytes = try Data(contentsOf: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    #expect(!screen.recordsBelongToNoCommitment)
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test(
    "a commitments screen holds a refused copy against making a copy, naming the store that could not be read"
)
func aCommitmentsScreenHoldsARefusedCopyAgainstMakingACopyNamingTheStoreThatCouldNotBeRead() throws {
    let places = freshRosterAndRecordPlaces()
    let oneOffPlace = freshOneOffPlace()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let moment = try #require(Moment(on: monday, hour: 14, minute: 32))

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: oneOffPlace)

    try FileManager.default.createDirectory(
        at: places.record.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a record is written as".utf8).write(to: places.record)

    let unreadableRecordResult = screen.makeACopy(
        asOf: moment,
        writingInto: FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true))

    guard case .failure(let refusal) = unreadableRecordResult else {
        Issue.record("expected a copy to be refused")
        return
    }
    #expect(refusal == .storeCouldNotBeRead)
    #expect(screen.refusedChange == .makingACopy(.record, .storeCouldNotBeRead))

    // A copy asked for at a readable record place but written into a directory that cannot be
    // written to is held against making a copy naming no store, as a place that could not be
    // written. Removing the corrupted file leaves the record place holding nothing — readable,
    // trivially.
    try FileManager.default.removeItem(at: places.record)

    let unwritableDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(
        at: unwritableDirectory, withIntermediateDirectories: true)
    try FileManager.default.setAttributes(
        [.posixPermissions: 0o500], ofItemAtPath: unwritableDirectory.path)
    defer {
        try? FileManager.default.setAttributes(
            [.posixPermissions: 0o700], ofItemAtPath: unwritableDirectory.path)
    }

    let unwritableResult = screen.makeACopy(asOf: moment, writingInto: unwritableDirectory)

    guard case .failure(let secondRefusal) = unwritableResult else {
        Issue.record("expected a copy to be refused")
        return
    }
    #expect(secondRefusal == .notKept)
    #expect(screen.refusedChange == .makingACopy(nil, .notKept))
}

@MainActor
@Test("a copy made does not end what a commitments screen holds about a refused change")
func aCopyMadeDoesNotEndWhatACommitmentsScreenHoldsAboutARefusedChange() throws {
    let places = freshRosterAndRecordPlaces()
    let oneOffPlace = freshOneOffPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let moment = try #require(Moment(on: monday, hour: 14, minute: 32))

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: oneOffPlace)

    let blankNameRefusal = screen.define(
        name: "   ", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: monday, under: nil)
    #expect(blankNameRefusal == .namesNothing)
    #expect(screen.refusedChange == .defining(.namesNothing))

    let result = screen.makeACopy(
        asOf: moment,
        writingInto: FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true))

    guard case .success = result else {
        Issue.record("expected a copy to be made")
        return
    }
    #expect(screen.refusedChange == .defining(.namesNothing))
}

@MainActor
@Test("an orphaned record with no possible source stays where it is and is said")
func anOrphanedRecordWithNoPossibleSourceStaysWhereItIsAndIsSaid() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let gymEmoji = Commitment(
        name: "Gym 🏋️", schedule: .weekdays([.tuesday, .thursday]), keptFrom: august4th)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gymEmoji, on: august4th)!)
    let recordBytes = try Data(contentsOf: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    #expect(screen.recordsBelongToNoCommitment)
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test("a refusal that a name says nothing is about the name field")
func aRefusalThatANameSaysNothingIsAboutTheNameField() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)

    #expect(refusal == .namesNothing)
    #expect(screen.sheetRefusal == CommitmentsScreen.SheetRefusal(field: .name, refusal: .namesNothing))
    #expect(screen.refusedChange == .defining(.namesNothing))
}

@MainActor
@Test("a refusal that a rhythm is due on no day is about the rhythm field")
func aRefusalThatARhythmIsDueOnNoDayIsAboutTheRhythmField() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "Gym", on: .weekdays([]), keptFrom: monday, under: nil)

    #expect(refusal == .dueOnNoDay)
    #expect(
        screen.sheetRefusal == CommitmentsScreen.SheetRefusal(field: .rhythm, refusal: .dueOnNoDay))
}

@MainActor
@Test("a refusal that the calendar will not take a rhythm's number is about the rhythm field")
func aRefusalThatTheCalendarWillNotTakeARhythmsNumberIsAboutTheRhythmField() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let lensesRefusal = screen.define(
        name: "Contact lenses", on: .everyNDays(0), keptFrom: monday, under: nil)
    let financesRefusal = screen.define(
        name: "Finances", on: .dayOfMonth(32), keptFrom: monday, under: nil)

    #expect(lensesRefusal == .rhythmOutOfRange)
    #expect(financesRefusal == .rhythmOutOfRange)
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(field: .rhythm, refusal: .rhythmOutOfRange))
}

@MainActor
@Test("a refusal that a range is not a range is about the range field")
func aRefusalThatARangeIsNotARangeIsAboutTheRangeField() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "Mood", on: allWeekdays, keptFrom: monday, under: nil, kind: .number, lowest: "10",
        highest: "1")

    #expect(refusal == .rangeIsNotARange)
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(field: .range, refusal: .rangeIsNotARange))
}

@MainActor
@Test("a refusal that a target is not a target is about the target field")
func aRefusalThatATargetIsNotATargetIsAboutTheTargetField() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "Water", on: allWeekdays, keptFrom: monday, under: nil, kind: .total, target: "0")

    #expect(refusal == .targetIsNotATarget)
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(field: .target, refusal: .targetIsNotATarget))
}

@MainActor
@Test("a refusal that a commitment is already kept is about the whole change and no field")
func aRefusalThatACommitmentIsAlreadyKeptIsAboutTheWholeChangeAndNoField() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let allWeekdays: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "Gym", on: Rhythm(allWeekdays), keptFrom: keptFrom, under: nil)

    #expect(refusal == .alreadyKept)
    #expect(
        screen.sheetRefusal == CommitmentsScreen.SheetRefusal(field: nil, refusal: .alreadyKept))
}

@MainActor
@Test("a refusal that a roster could not be written is about the whole change and no field")
func aRefusalThatARosterCouldNotBeWrittenIsAboutTheWholeChangeAndNoField() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    let rosterPlace = blocker.appendingPathComponent("roster.json")
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "Journaling", on: allWeekdays, keptFrom: monday, under: nil)

    #expect(refusal == .notKept)
    #expect(screen.sheetRefusal == CommitmentsScreen.SheetRefusal(field: nil, refusal: .notKept))
}

@MainActor
@Test(
    "a refusal that records are already kept under the commitment a change would produce is about the whole change"
)
func aRefusalThatRecordsAreAlreadyKeptUnderTheCommitmentAChangeWouldProduceIsAboutTheWholeChange()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.add(run)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gymEmoji, on: august3rd)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym 🏋️", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)

    #expect(refusal == .recordsAlreadyExist)
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(field: nil, refusal: .recordsAlreadyExist))
}

@MainActor
@Test("a restart refused for the day it was asked from is about the restart day field")
func aRestartRefusedForTheDayItWasAskedFromIsAboutTheRestartDayField() throws {
    let places = freshRosterAndRecordPlaces()
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let september1st = CalendarDate(year: 2026, month: 9, day: 1)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(nails)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.restart(nails, from: august3rd)

    #expect(refusal == .restartDayIsBeforeKeptFrom)
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(field: .restartDay, refusal: .restartDayIsBeforeKeptFrom))

    let afterTodayRefusal = screen.restart(nails, from: september1st)
    #expect(afterTodayRefusal == .restartDayIsAfterToday)
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(field: .restartDay, refusal: .restartDayIsAfterToday))

    let alreadyDueRefusal = screen.restart(nails, from: august30th)
    #expect(alreadyDueRefusal == .alreadyDueOnRestartDay)
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(field: .restartDay, refusal: .alreadyDueOnRestartDay))
}

@MainActor
@Test("a restart refused as a commitment already kept is about the restart day field")
func aRestartRefusedAsACommitmentAlreadyKeptIsAboutTheRestartDayField() throws {
    let places = freshRosterAndRecordPlaces()
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!
    let secondNails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: monday), keptFrom: monday)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(nails)
    try rosterStore.add(secondNails)
    try rosterStore.remove(secondNails, keptUntil: august30th)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.restart(nails, from: monday)

    #expect(refusal == .alreadyKept)
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(field: .restartDay, refusal: .alreadyKept))
}

@MainActor
@Test("a restart refused for records already kept or a day recorded on is about the restart day field")
func aRestartRefusedForRecordsAlreadyKeptOrADayRecordedOnIsAboutTheRestartDayField() throws {
    let places = freshRosterAndRecordPlaces()
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!
    let strayRestartedNails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: monday), keptFrom: monday)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(nails)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(strayRestartedNails, on: monday)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.restart(nails, from: monday)

    #expect(refusal == .recordsAlreadyExist)
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(field: .restartDay, refusal: .recordsAlreadyExist))

    let otherPlaces = freshRosterAndRecordPlaces()
    let august29th = CalendarDate(year: 2026, month: 8, day: 29)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let otherNails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!

    let otherRosterStore = try RosterStore(at: otherPlaces.roster)
    try otherRosterStore.add(otherNails)
    let otherRecordStore = try RecordStore(at: otherPlaces.record)
    try otherRecordStore.add(Tick(otherNails, on: august30th)!)

    let otherScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: otherPlaces.roster, keepingRecordAt: otherPlaces.record)

    let otherRefusal = otherScreen.restart(otherNails, from: august29th)

    #expect(otherRefusal == .wouldLeaveARecordedDayNotDue)
    #expect(
        otherScreen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(
                field: .restartDay, refusal: .wouldLeaveARecordedDayNotDue))
}

@MainActor
@Test("a restart refused by a place that could not be written is about the whole change")
func aRestartRefusedByAPlaceThatCouldNotBeWrittenIsAboutTheWholeChange() throws {
    let rosterDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let rosterPlace = rosterDirectory.appendingPathComponent("roster.json")
    let recordDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let recordPlace = recordDirectory.appendingPathComponent("record.json")
    let august1st = CalendarDate(year: 2026, month: 8, day: 1)!
    let august2nd = CalendarDate(year: 2026, month: 8, day: 2)!
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let august10th = CalendarDate(year: 2026, month: 8, day: 10)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august1st)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(nails)
    let recordStore = try RecordStore(at: recordPlace)
    try recordStore.add(Tick(nails, on: august6th)!)
    try recordStore.add(Tick(nails, on: august10th)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace)

    try FileManager.default.removeItem(at: rosterDirectory)
    try Data().write(to: rosterDirectory)

    let refusal = screen.restart(nails, from: august2nd)

    #expect(refusal == .notKept)
    #expect(screen.sheetRefusal == CommitmentsScreen.SheetRefusal(field: nil, refusal: .notKept))
}

@MainActor
@Test("a day recorded on that a change would leave not due is about the day-kept-from field")
func aDayRecordedOnThatAChangeWouldLeaveNotDueIsAboutTheDayKeptFromField() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 6, day: 1)!
    let newKeptFrom = CalendarDate(year: 2026, month: 8, day: 4)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let august5th = CalendarDate(year: 2026, month: 8, day: 5)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: august3rd)!)
    try recordStore.add(Tick(gym, on: august5th)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: newKeptFrom, under: nil)

    #expect(refusal == .wouldLeaveARecordedDayNotDue)
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(
                field: .keptFrom, refusal: .wouldLeaveARecordedDayNotDue))
}

@MainActor
@Test(
    "a change a stopped commitment does not take is about the rhythm field where only the rhythm differs"
)
func aChangeAStoppedCommitmentDoesNotTakeIsAboutTheRhythmFieldWhereOnlyTheRhythmDiffers() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym", on: .weekdays([.tuesday, .thursday]), keptFrom: keptFrom, under: nil)

    #expect(refusal == .stoppedCommitmentCannotChangeRhythm)
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(
                field: .rhythm, refusal: .stoppedCommitmentCannotChangeRhythm))
}

@MainActor
@Test(
    "a change a stopped commitment does not take is about the day-kept-from field where only that day differs"
)
func aChangeAStoppedCommitmentDoesNotTakeIsAboutTheDayKeptFromFieldWhereOnlyThatDayDiffers() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let january5th = CalendarDate(year: 2026, month: 1, day: 5)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym", on: Rhythm(schedule), keptFrom: january5th, under: nil)

    #expect(refusal == .stoppedCommitmentCannotChangeRhythm)
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(
                field: .keptFrom, refusal: .stoppedCommitmentCannotChangeRhythm))
}

@MainActor
@Test("a refusal is about the whole change where both the rhythm and the day kept from differ")
func aRefusalIsAboutTheWholeChangeWhereBothTheRhythmAndTheDayKeptFromDiffer() throws {
    let places = freshRosterAndRecordPlaces()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let january5th = CalendarDate(year: 2026, month: 1, day: 5)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.retire(gym, keptUntil: sunday)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym", on: .weekdays([.tuesday, .thursday]), keptFrom: january5th, under: nil)

    #expect(refusal == .stoppedCommitmentCannotChangeRhythm)
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(
                field: nil, refusal: .stoppedCommitmentCannotChangeRhythm))
}

@MainActor
@Test("what a commitments screen tells on its sheet ends when the field it is about is edited")
func whatACommitmentsScreenTellsOnItsSheetEndsWhenTheFieldItIsAboutIsEdited() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)
    #expect(refusal == .namesNothing)

    screen.sheetFieldEdited(.name)

    #expect(screen.sheetRefusal == nil)
    #expect(screen.refusedChange == .defining(.namesNothing))
}

@MainActor
@Test("what a commitments screen tells on its sheet stands when another field is edited")
func whatACommitmentsScreenTellsOnItsSheetStandsWhenAnotherFieldIsEdited() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)
    #expect(refusal == .namesNothing)

    screen.sheetFieldEdited(.rhythm)
    screen.sheetFieldEdited(.keptFrom)
    screen.sheetFieldEdited(.range)
    screen.sheetFieldEdited(.target)
    screen.sheetFieldEdited(.restartDay)

    #expect(
        screen.sheetRefusal == CommitmentsScreen.SheetRefusal(field: .name, refusal: .namesNothing))
}

@MainActor
@Test("what a commitments screen tells at the foot of its sheet stands when a field is edited")
func whatACommitmentsScreenTellsAtTheFootOfItsSheetStandsWhenAFieldIsEdited() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let allWeekdays: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "Gym", on: Rhythm(allWeekdays), keptFrom: keptFrom, under: nil)
    #expect(refusal == .alreadyKept)

    screen.sheetFieldEdited(.name)

    #expect(
        screen.sheetRefusal == CommitmentsScreen.SheetRefusal(field: nil, refusal: .alreadyKept))
}

@MainActor
@Test("what a commitments screen tells on its sheet ends when the sheet is closed")
func whatACommitmentsScreenTellsOnItsSheetEndsWhenTheSheetIsClosed() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let allWeekdays: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(
        name: "   ", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: monday, under: nil)
    #expect(refusal == .namesNothing)

    screen.sheetClosed()

    #expect(screen.sheetRefusal == nil)

    let otherRosterPlace = freshRosterPlace()
    let otherRosterStore = try RosterStore(at: otherRosterPlace)
    try otherRosterStore.add(gym)
    let otherScreen = CommitmentsScreen(asOf: monday, keepingRosterAt: otherRosterPlace)

    let otherRefusal = otherScreen.define(
        name: "Gym", on: Rhythm(allWeekdays), keptFrom: keptFrom, under: nil)
    #expect(otherRefusal == .alreadyKept)

    otherScreen.sheetClosed()

    #expect(otherScreen.sheetRefusal == nil)
}

@MainActor
@Test("a refused restart replaces what a refused save told on a commitments screen's sheet")
func aRefusedRestartReplacesWhatARefusedSaveToldOnACommitmentsScreensSheet() throws {
    let places = freshRosterAndRecordPlaces()
    let august4th = CalendarDate(year: 2026, month: 8, day: 4)!
    let august6th = CalendarDate(year: 2026, month: 8, day: 6)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(nails)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let defineRefusal = screen.define(
        name: "   ", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: monday, under: nil)
    #expect(defineRefusal == .namesNothing)

    let restartRefusal = screen.restart(nails, from: august3rd)
    #expect(restartRefusal == .restartDayIsBeforeKeptFrom)

    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(field: .restartDay, refusal: .restartDayIsBeforeKeptFrom))

    let otherPlaces = freshRosterAndRecordPlaces()
    let otherNails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: august6th),
        keptFrom: august4th)!
    let otherRosterStore = try RosterStore(at: otherPlaces.roster)
    try otherRosterStore.add(otherNails)

    let otherScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: otherPlaces.roster, keepingRecordAt: otherPlaces.record)

    let otherRestartRefusal = otherScreen.restart(otherNails, from: august3rd)
    #expect(otherRestartRefusal == .restartDayIsBeforeKeptFrom)

    let otherDefineRefusal = otherScreen.define(
        name: "   ", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: monday, under: nil)
    #expect(otherDefineRefusal == .namesNothing)

    #expect(
        otherScreen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(field: .name, refusal: .namesNothing))
}

@MainActor
@Test("what a commitments screen tells on its sheet ends when an ask is kept")
func whatACommitmentsScreenTellsOnItsSheetEndsWhenAnAskIsKept() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)
    #expect(refusal == .namesNothing)

    let keptRefusal = screen.define(name: "Journaling", on: allWeekdays, keptFrom: monday, under: nil)

    #expect(keptRefusal == nil)
    #expect(screen.sheetRefusal == nil)
}

@MainActor
@Test("what a commitments screen tells on its sheet ends when the app is shown again")
func whatACommitmentsScreenTellsOnItsSheetEndsWhenTheAppIsShownAgain() {
    let rosterPlace = freshRosterPlace()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let allWeekdays: Rhythm = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let refusal = screen.define(name: "   ", on: allWeekdays, keptFrom: monday, under: nil)
    #expect(refusal == .namesNothing)

    screen.shown(asOf: monday)

    #expect(screen.sheetRefusal == nil)
}

@MainActor
@Test("what a commitments screen tells on its sheet stands when a call asks for no change at all")
func whatACommitmentsScreenTellsOnItsSheetStandsWhenACallAsksForNoChangeAtAll() throws {
    let rosterPlace = freshRosterPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let allWeekdays: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: rosterPlace)

    let defineRefusal = screen.define(
        name: "   ", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: monday, under: nil)
    #expect(defineRefusal == .namesNothing)

    let changeRefusal = screen.change(
        gym, toName: "Gym", on: Rhythm(allWeekdays), keptFrom: keptFrom, under: nil)

    #expect(changeRefusal == nil)
    #expect(
        screen.sheetRefusal == CommitmentsScreen.SheetRefusal(field: .name, refusal: .namesNothing))
}
