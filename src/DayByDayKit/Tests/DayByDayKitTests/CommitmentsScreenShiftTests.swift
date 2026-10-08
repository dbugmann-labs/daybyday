import Foundation
import Testing
@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private func freshPlaces() -> (roster: URL, record: URL) {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    return (
        directory.appendingPathComponent("roster.json"),
        directory.appendingPathComponent("record.json")
    )
}

private let gymSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])

/// "Gym" on Monday, Wednesday and Saturday kept from 1 January 2026, taken on at `places.roster`
/// with its due day on `day` shifted there to `other`.
private func gymShifted(
    at places: (roster: URL, record: URL), from day: CalendarDate, to other: CalendarDate,
    named name: String = "Gym", kind: Commitment.Kind = .tick
) throws -> Commitment {
    let gym = Commitment(name: name, schedule: gymSchedule, keptFrom: date(2026, 1, 1), kind: kind)!
    let store = try RosterStore(at: places.roster)
    try store.add(gym)
    try store.shift(gym, from: day, to: other)
    return gym
}

private func bytes(_ place: URL) -> Data? {
    try? Data(contentsOf: place)
}

@MainActor
@Test("a rhythm change is refused while a shift has a day after the day handed")
func aRhythmChangeIsRefusedWhileAShiftHasADayAfterTheDayHanded() throws {
    let places = freshPlaces()
    let gym = try gymShifted(at: places, from: date(2026, 8, 31), to: date(2026, 9, 3))
    let screen = CommitmentsScreen(
        asOf: date(2026, 9, 1), keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let rosterBytes = bytes(places.roster)
    let recordBytes = bytes(places.record)

    let refusal = screen.change(
        gym, toName: "Gym", on: .weekdays([.tuesday, .thursday]), keptFrom: date(2026, 1, 1),
        under: nil)

    #expect(refusal == .shiftedDayAhead)
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(field: .rhythm, refusal: .shiftedDayAhead))
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(bytes(places.roster) == rosterBytes)
    #expect(bytes(places.record) == recordBytes)

    let other = freshPlaces()
    let otherGym = try gymShifted(at: other, from: date(2026, 9, 5), to: date(2026, 9, 4))
    let otherScreen = CommitmentsScreen(
        asOf: date(2026, 9, 4), keepingRosterAt: other.roster, keepingRecordAt: other.record)

    let otherRefusal = otherScreen.change(
        otherGym, toName: "Gym", on: .weekdays([.tuesday, .thursday]), keptFrom: date(2026, 1, 1),
        under: nil)

    #expect(otherRefusal == .shiftedDayAhead)
}

@MainActor
@Test("a range or a target change is refused while a shift has a day after the day handed")
func aRangeOrATargetChangeIsRefusedWhileAShiftHasADayAfterTheDayHanded() throws {
    let places = freshPlaces()
    let weight = try gymShifted(
        at: places, from: date(2026, 8, 31), to: date(2026, 9, 3), named: "Weight",
        kind: .number(range: Commitment.Range(lowest: 40, highest: 150)))
    let screen = CommitmentsScreen(
        asOf: date(2026, 9, 1), keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let rangeRefusal = screen.change(
        weight, toName: "Weight", on: .weekdays([.monday, .wednesday, .saturday]),
        keptFrom: date(2026, 1, 1), under: nil, lowest: "40", highest: "200")

    #expect(rangeRefusal == .shiftedDayAhead)
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(field: .range, refusal: .shiftedDayAhead))

    let totalPlaces = freshPlaces()
    let protein = try gymShifted(
        at: totalPlaces, from: date(2026, 8, 31), to: date(2026, 9, 3), named: "Protein",
        kind: .total(target: Commitment.Target(120)!))
    let totalScreen = CommitmentsScreen(
        asOf: date(2026, 9, 1), keepingRosterAt: totalPlaces.roster,
        keepingRecordAt: totalPlaces.record)

    let targetRefusal = totalScreen.change(
        protein, toName: "Protein", on: .weekdays([.monday, .wednesday, .saturday]),
        keptFrom: date(2026, 1, 1), under: nil, target: "150")

    #expect(targetRefusal == .shiftedDayAhead)
    #expect(
        totalScreen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(field: .target, refusal: .shiftedDayAhead))
}

@MainActor
@Test("a move of the day kept from is refused while a shift has a day after the day handed")
func aMoveOfTheDayKeptFromIsRefusedWhileAShiftHasADayAfterTheDayHanded() throws {
    let places = freshPlaces()
    let gym = try gymShifted(at: places, from: date(2026, 8, 31), to: date(2026, 9, 3))
    let screen = CommitmentsScreen(
        asOf: date(2026, 9, 1), keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Gym", on: .weekdays([.monday, .wednesday, .saturday]),
        keptFrom: date(2026, 2, 1), under: nil)

    #expect(refusal == .shiftedDayAhead)
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(field: .keptFrom, refusal: .shiftedDayAhead))
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.whatItIsMadeOf(gym)?.keptFrom == date(2026, 1, 1))
}

@MainActor
@Test("a stop is refused while a shift has a day after the day handed")
func aStopIsRefusedWhileAShiftHasADayAfterTheDayHanded() throws {
    let places = freshPlaces()
    let gym = try gymShifted(at: places, from: date(2026, 8, 31), to: date(2026, 9, 3))
    let screen = CommitmentsScreen(
        asOf: date(2026, 9, 1), keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let rosterBytes = bytes(places.roster)

    screen.askToStopKeeping(gym)
    let refusal = screen.confirmStopKeeping()

    #expect(refusal == .shiftedDayAhead)
    #expect(screen.refusedChange == .stopping(gym, .shiftedDayAhead))
    #expect(screen.refusedChange != .stopping(gym, .notKept))
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.isEmpty)
    #expect(bytes(places.roster) == rosterBytes)
}

@MainActor
@Test("a rename and a category are not refused while a shift has a day after the day handed")
func aRenameAndACategoryAreNotRefusedWhileAShiftHasADayAfterTheDayHanded() throws {
    let places = freshPlaces()
    let gym = try gymShifted(at: places, from: date(2026, 8, 31), to: date(2026, 9, 3))
    let screen = CommitmentsScreen(
        asOf: date(2026, 9, 1), keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        gym, toName: "Lifting", on: .weekdays([.monday, .wednesday, .saturday]),
        keptFrom: date(2026, 1, 1), under: "Sport")

    #expect(refusal == nil)
    let reopened = try RosterStore(at: places.roster)
    let lifting = try #require(reopened.roster.commitments.first)
    #expect(lifting.name == "Lifting")
    #expect(lifting.isDue(on: date(2026, 9, 3)))
    #expect(!lifting.isDue(on: date(2026, 8, 31)))
}
