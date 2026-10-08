import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

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

private let augustSixth = date(2026, 8, 6)

private func nails() -> Commitment {
    Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: augustSixth),
        keptFrom: augustSixth)!
}

@MainActor
private func screen(
    of commitments: [Commitment], asOf today: CalendarDate, at places: Places
) -> DayScreen {
    DayScreen(
        startingFrom: commitments, asOf: today, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOffs)
}

@MainActor
@Test("a day screen offers an every-N-days row the days between its due days either side, each said with its date")
func aDayScreenOffersAnEveryNDaysRowTheDaysBetweenItsDueDaysEitherSideEachSaidWithItsDate() {
    let day = screen(of: [nails()], asOf: date(2026, 8, 31), at: Places())
    day.showPreviousDay()

    let offered = day.shiftDays(for: day.dayView.rows[0])

    #expect(
        offered.map(\.date) == [
            date(2026, 8, 27), date(2026, 8, 28), date(2026, 8, 29), date(2026, 8, 31),
            date(2026, 9, 1), date(2026, 9, 2),
        ])
    #expect(
        offered.map(\.words) == [
            "Thu 27 Aug", "Fri 28 Aug", "Sat 29 Aug", "Mon 31 Aug", "Tue 1 Sep", "Wed 2 Sep",
        ])

    let lenses = Commitment(
        name: "Contact lenses",
        schedule: .everyNDays(DayInterval(days: 14)!, from: date(2026, 8, 25)),
        keptFrom: date(2026, 8, 25))!
    let other = screen(of: [lenses], asOf: date(2026, 9, 8), at: Places())
    let lensDays = other.shiftDays(for: other.dayView.rows[0])
    #expect(lensDays.count == 26)
    #expect(lensDays.first?.words == "Wed 26 Aug")
    #expect(lensDays.last?.words == "Mon 21 Sep")
}

/// A roster place holding "Nails" with its due day on Sunday 30 August 2026 shifted to Monday 31
/// August 2026.
private func shiftedNails(at places: Places) throws -> Commitment {
    let store = try RosterStore(at: places.roster)
    let held = nails()
    try store.add(held)
    try store.shift(held, from: date(2026, 8, 30), to: date(2026, 8, 31))
    return held
}

@MainActor
@Test("a day screen offers an every-N-days row a shift put its due day on the days of the day it came from, that day included")
func aDayScreenOffersAnEveryNDaysRowAShiftPutItsDueDayOnTheDaysOfTheDayItCameFromThatDayIncluded() throws {
    let places = Places()
    _ = try shiftedNails(at: places)
    let day = screen(of: [], asOf: date(2026, 8, 31), at: places)

    let offered = day.shiftDays(for: day.dayView.rows[0])

    #expect(
        offered.map(\.words) == [
            "Thu 27 Aug", "Fri 28 Aug", "Sat 29 Aug", "Sun 30 Aug", "Tue 1 Sep", "Wed 2 Sep",
        ])
}

@MainActor
@Test("a day screen offers no day to shift an every-N-days row while a later day holds a record of it")
func aDayScreenOffersNoDayToShiftAnEveryNDaysRowWhileALaterDayHoldsARecordOfIt() throws {
    let places = Places()
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]),
        keptFrom: date(2026, 1, 1))!
    let day = screen(of: [nails(), gym], asOf: date(2026, 9, 3), at: places)

    try day.tick(day.dayView.rows.first { $0.name == "Nails" }!)
    day.showPreviousDay()
    try day.tick(day.dayView.rows.first { $0.name == "Gym" }!)
    day.showPreviousDay()
    day.showPreviousDay()
    day.showPreviousDay()

    #expect(day.dayView.rows.map(\.name) == ["Nails"])
    #expect(day.shiftDays(for: day.dayView.rows[0]).isEmpty)

    day.showNextDay()

    let gymRow = try #require(day.dayView.rows.first { $0.name == "Gym" })
    #expect(
        day.shiftDays(for: gymRow).map(\.date) == [
            date(2026, 9, 1), date(2026, 9, 3), date(2026, 9, 4), date(2026, 9, 6),
        ])
}

@MainActor
@Test("an every-N-days row shifted through a day screen runs its count on from the day it landed")
func anEveryNDaysRowShiftedThroughADayScreenRunsItsCountOnFromTheDayItLanded() throws {
    let places = Places()
    let day = screen(of: [nails()], asOf: date(2026, 8, 31), at: places)
    day.showPreviousDay()

    try day.shift(day.dayView.rows[0], to: date(2026, 8, 31))

    #expect(day.dayView.rows.map(\.name) == ["Nails"])
    #expect(!day.dayView.rows[0].offersAnything(asOf: date(2026, 8, 31)))
    day.showNextDay()
    #expect(day.dayView.rows[0].tick(asOf: date(2026, 8, 31)) != nil)
    for _ in 0..<3 { day.showNextDay() }
    #expect(day.dayView.rows.isEmpty)
    day.showNextDay()
    #expect(day.dayView.rows.map(\.name) == ["Nails"])
    #expect(day.dayView.rows.map(\.rhythmInWords) == ["Every 4 days"])

    let reopened = try RosterStore(at: places.roster)
    let kept = reopened.roster.commitments[0]
    #expect(kept.isDue(on: date(2026, 8, 31)))
    #expect(!kept.isDue(on: date(2026, 8, 30)))
}

@MainActor
@Test("an every-N-days row says where its shifted due day came from, and the row of the day it left where it went, each by weekday and date")
func anEveryNDaysRowSaysWhereItsShiftedDueDayCameFromAndTheRowOfTheDayItLeftWhereItWent() throws {
    let places = Places()
    _ = try shiftedNails(at: places)
    let day = screen(of: [], asOf: date(2026, 8, 31), at: places)

    #expect(day.dayView.rows.map(\.rhythmInWords) == ["from Sun 30 Aug"])
    #expect(day.previousDayView?.rows.map(\.rhythmInWords) == ["to Mon 31 Aug"])
}
