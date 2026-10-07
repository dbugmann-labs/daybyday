import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private let januaryFirst = date(2026, 1, 1)
private let monday = date(2026, 8, 31)
private let tuesday = date(2026, 9, 1)
private let gymSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])

private struct Places {
    let record: URL
    let roster: URL
    let oneOffs: URL

    init() {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        record = directory.appendingPathComponent("record.json")
        roster = directory.appendingPathComponent("roster.json")
        oneOffs = directory.appendingPathComponent("one-offs.json")
    }
}

private func gym(
    _ name: String = "Gym", schedule: Schedule = gymSchedule, kind: Commitment.Kind = .tick
) -> Commitment {
    Commitment(name: name, schedule: schedule, keptFrom: januaryFirst, kind: kind)!
}

/// Takes `commitments` on at `places.roster`, in order, and shifts each one's due day on `from` to
/// `to`.
private func roster(
    of commitments: [Commitment], at places: Places, shifting from: CalendarDate? = nil,
    to: CalendarDate? = nil
) throws {
    let store = try RosterStore(at: places.roster)
    for commitment in commitments {
        try store.add(commitment)
        if let from, let to {
            try store.shift(commitment, from: from, to: to)
        }
    }
}

@MainActor
private func screen(asOf today: CalendarDate, at places: Places) -> DayScreen {
    DayScreen(
        startingFrom: [], asOf: today, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOffs)
}

@MainActor
@Test("a row of a day a shift took a due day from offers nothing, whatever its kind")
func aRowOfADayAShiftTookADueDayFromOffersNothingWhateverItsKind() throws {
    let places = Places()
    try roster(
        of: [
            gym("Gym"),
            gym("Weight", kind: .number(range: Commitment.Range(lowest: 40, highest: 150)!)),
            gym("Journal", kind: .note),
            gym("Protein", kind: .total(target: Commitment.Target(120)!)),
        ], at: places, shifting: monday, to: tuesday)
    let day = screen(asOf: tuesday, at: places)

    day.showPreviousDay()

    #expect(day.dayView.rows.map(\.name) == ["Gym", "Weight", "Journal", "Protein"])
    for row in day.dayView.rows {
        #expect(!row.isKept)
        #expect(row.tick(asOf: tuesday) == nil)
        #expect(row.numberEntry(asOf: tuesday) == nil)
        #expect(row.noteEntry(asOf: tuesday) == nil)
        #expect(row.totalEntry(asOf: tuesday) == nil)
        #expect(!row.offersTakeBackLast(asOf: tuesday))
        #expect(!row.offersAnything(asOf: tuesday))
        #expect(day.shiftDays(for: row).isEmpty)
    }
}

@Test("a group holding only a row a shift took a due day from is still drawn")
func aGroupHoldingOnlyARowAShiftTookADueDayFromIsStillDrawn() {
    var held = Roster()
    let sportGym = gym()
    _ = held.add(sportGym, under: "Sport")
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: januaryFirst)!
    _ = held.add(journaling)
    _ = held.shift(sportGym, from: monday, to: tuesday)

    let view = DayView(of: held.groups, on: monday, in: History())

    #expect(view.groups.map(\.category) == ["Sport", nil])
    #expect(view.groups[0].rows.map(\.name) == ["Gym"])
    #expect(view.groups[0].rows[0].rhythmInWords == "to Tue")
}

@MainActor
@Test("a row of a day a shift took its due day from is a different row from the one that day held before")
func aRowOfADayAShiftTookItsDueDayFromIsADifferentRowFromTheOneThatDayHeldBefore() throws {
    let places = Places()
    let day = DayScreen(
        startingFrom: [gym()], asOf: monday, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOffs)
    let held = day.dayView.rows[0]

    try day.shift(held, to: tuesday)

    #expect(day.dayView.rows.first { $0.name == "Gym" } != held)

    day.showNextDay()
    try day.shift(day.dayView.rows.first { $0.name == "Gym" }!, to: monday)
    day.showPreviousDay()

    #expect(day.dayView.rows.first { $0.name == "Gym" } == held)
}

@MainActor
@Test("a row says where a shifted due day came from, and the row of the day it left says where it went")
func aRowSaysWhereAShiftedDueDayCameFromAndTheRowOfTheDayItLeftSaysWhereItWent() throws {
    let places = Places()
    try roster(of: [gym()], at: places, shifting: monday, to: tuesday)
    let day = screen(asOf: tuesday, at: places)

    #expect(day.dayView.rows.map(\.rhythmInWords) == ["from Mon"])
    #expect(day.previousDayView?.rows.map(\.rhythmInWords) == ["to Tue"])
    day.showNextDay()
    #expect(day.dayView.rows.map(\.rhythmInWords) == ["Mon, Wed, Sat"])

    let other = Places()
    let finances = Commitment(
        name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 1)!), keptFrom: januaryFirst)!
    try roster(of: [finances], at: other, shifting: tuesday, to: monday)
    let month = screen(asOf: monday, at: other)

    #expect(month.dayView.rows.map(\.rhythmInWords) == ["from Tue"])
    #expect(month.nextDayView?.rows.map(\.rhythmInWords) == ["to Mon"])
}

private func bytes(_ places: Places) -> [Data?] {
    [places.record, places.roster, places.oneOffs].map { try? Data(contentsOf: $0) }
}

private func said(_ days: [DayScreen.ShiftDay]) -> [String] {
    days.map { "\($0.date.year)-\($0.date.month)-\($0.date.day) \($0.words)" }
}

@MainActor
@Test("a day screen offers a row the free days of its week, Monday first, each said as its weekday")
func aDayScreenOffersARowTheFreeDaysOfItsWeekMondayFirstEachSaidAsItsWeekday() {
    let places = Places()
    let day = DayScreen(
        startingFrom: [gym()], asOf: date(2026, 9, 2), keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOffs)
    let opened = bytes(places)
    let expected = [
        "2026-9-1 Tue", "2026-9-3 Thu", "2026-9-4 Fri", "2026-9-6 Sun",
    ]

    day.showPreviousDay()
    day.showPreviousDay()

    #expect(said(day.shiftDays(for: day.dayView.rows[0])) == expected)

    day.showDay(date(2026, 9, 5))

    #expect(said(day.shiftDays(for: day.dayView.rows[0])) == expected)
    #expect(bytes(places) == opened)
}

@MainActor
@Test("a day screen offers a row a shift put its due day on the free days of its week and the day it came from")
func aDayScreenOffersARowAShiftPutItsDueDayOnTheFreeDaysOfItsWeekAndTheDayItCameFrom() throws {
    let places = Places()
    try roster(of: [gym()], at: places, shifting: monday, to: date(2026, 9, 3))
    let day = screen(asOf: date(2026, 9, 3), at: places)

    #expect(
        said(day.shiftDays(for: day.dayView.rows[0]))
            == ["2026-8-31 Mon", "2026-9-1 Tue", "2026-9-4 Fri", "2026-9-6 Sun"])
}

@MainActor
@Test("a day screen offers no day to shift a row whose day holds a record")
func aDayScreenOffersNoDayToShiftARowWhoseDayHoldsARecord() throws {
    let places = Places()
    let day = DayScreen(
        startingFrom: [gym()], asOf: monday, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOffs)

    try day.tick(day.dayView.rows[0])

    #expect(day.shiftDays(for: day.dayView.rows[0]).isEmpty)

    try day.tick(day.dayView.rows[0])

    #expect(
        said(day.shiftDays(for: day.dayView.rows[0]))
            == ["2026-9-1 Tue", "2026-9-3 Thu", "2026-9-4 Fri", "2026-9-6 Sun"])

    let totals = Places()
    let protein = gym("Protein", kind: .total(target: Commitment.Target(120)!))
    try RecordStore(at: totals.record).add(Addition(35, for: protein, on: monday)!)
    let total = DayScreen(
        startingFrom: [protein], asOf: monday, keepingRecordAt: totals.record,
        keepingRosterAt: totals.roster, keepingOneOffsAt: totals.oneOffs)

    #expect(!total.dayView.rows[0].isKept)
    #expect(total.shiftDays(for: total.dayView.rows[0]).isEmpty)
}

@MainActor
@Test("a day screen offers no day to shift a row where it is not keeping its record, nor a row of a day either side")
func aDayScreenOffersNoDayToShiftARowWhereItIsNotKeepingItsRecordNorARowOfADayEitherSide() throws {
    let places = Places()
    try FileManager.default.createDirectory(
        at: places.record.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a record is written as".utf8).write(to: places.record)
    let unreadable = DayScreen(
        startingFrom: [gym()], asOf: monday, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOffs)

    #expect(unreadable.dayView.rows.count == 1)
    #expect(unreadable.shiftDays(for: unreadable.dayView.rows[0]).isEmpty)

    let others = Places()
    let run = gym("Run", schedule: .weekdays([.tuesday, .thursday]))
    let neighbour = DayScreen(
        startingFrom: [run], asOf: monday, keepingRecordAt: others.record,
        keepingRosterAt: others.roster, keepingOneOffsAt: others.oneOffs)

    #expect(neighbour.dayView.rows.isEmpty)
    let after = try #require(neighbour.nextDayView?.rows.first)
    #expect(neighbour.shiftDays(for: after).isEmpty)
}
