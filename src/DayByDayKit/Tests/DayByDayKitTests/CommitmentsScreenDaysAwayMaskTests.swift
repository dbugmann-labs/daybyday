import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private let januaryFirst = date(2026, 1, 1)
private let monday12 = date(2026, 10, 12)
private let everyDay = Schedule.weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])
private let gymSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])

private struct Places {
    let roster: URL
    let record: URL
    let oneOffs: URL

    init() {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        roster = directory.appendingPathComponent("roster.json")
        record = directory.appendingPathComponent("record.json")
        oneOffs = directory.appendingPathComponent("one-offs.json")
    }
}

private func commitment(
    _ name: String, _ schedule: Schedule = everyDay, keptFrom: CalendarDate = januaryFirst
) -> Commitment {
    Commitment(name: name, schedule: schedule, keptFrom: keptFrom, kind: .tick)!
}

private func nails() -> Commitment {
    commitment(
        "Nails", .everyNDays(DayInterval(days: 4)!, from: date(2026, 10, 1)),
        keptFrom: date(2026, 10, 1))
}

private func takeOn(_ commitments: [Commitment], at places: Places) throws {
    let store = try RosterStore(at: places.roster)
    for commitment in commitments {
        try store.add(commitment)
    }
}

@MainActor
private func screen(_ places: Places, asOf day: CalendarDate = monday12) -> CommitmentsScreen {
    CommitmentsScreen(
        asOf: day, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
}

@MainActor
private func rows(on day: CalendarDate, at places: Places) -> [DayView.Row] {
    DayScreen(
        startingFrom: [], asOf: day, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs
    ).dayView.rows
}

private func isDue(_ name: String, on day: CalendarDate, in roster: Roster) -> Bool {
    roster.groups(on: day).flatMap(\.commitments).contains {
        $0.name == name && $0.isDue(on: day)
    }
}

private func roster(at places: Places) throws -> Roster {
    try RosterStore(at: places.roster).roster
}

@MainActor
@Test("days away said, changed and removed leave the eras of the commitments they are over as they were")
func daysAwaySaidChangedAndRemovedLeaveTheErasOfTheCommitmentsTheyAreOverAsTheyWere() throws {
    let places = Places()
    let gym = commitment("Gym", gymSchedule)
    let nails = nails()
    try takeOn([gym, nails], at: places)
    let commitments = screen(places)

    func erasAreAsTheyWere() throws {
        let kept = try roster(at: places)
        let gymEras = kept.eras(of: gym)
        #expect(gymEras.count == 1)
        #expect(gymEras.map(\.keptFrom) == [januaryFirst])
        #expect(gymEras.map(\.rhythmInWords) == ["Mon, Wed, Sat"])
        let nailsEras = kept.eras(of: nails)
        #expect(nailsEras.count == 1)
        #expect(nailsEras.map(\.keptFrom) == [date(2026, 10, 1)])
        #expect(nailsEras.map(\.rhythmInWords) == ["Every 4 days"])
        #expect(kept.stopped.isEmpty)
        #expect(kept.commitments.map(\.name) == ["Gym", "Nails"])
    }

    let said = commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, nails])
    #expect(said == nil)
    try erasAreAsTheyWere()

    let changed = commitments.changeDaysAway(
        try #require(commitments.daysAway.first), named: "Mallorca", from: date(2026, 10, 13),
        through: date(2026, 10, 20), over: [gym])
    #expect(changed == nil)
    try erasAreAsTheyWere()

    commitments.askToRemove(try #require(commitments.daysAway.first))
    let removed = commitments.confirmRemovingDaysAway()
    #expect(removed == nil)
    #expect(commitments.daysAway.isEmpty)
    try erasAreAsTheyWere()
}

@MainActor
@Test("a day holding a record under days away keeps its row through every later change of them")
func aDayHoldingARecordUnderDaysAwayKeepsItsRowThroughEveryLaterChangeOfThem() throws {
    let places = Places()
    let creatine = commitment("Creatine")
    let magnesium = commitment("Magnesium")
    try takeOn([creatine, magnesium], at: places)
    try RecordStore(at: places.record).add(Tick(creatine, on: monday12)!)
    let monday = screen(places)
    #expect(
        monday.sayDaysAway(
            named: "", from: monday12, through: date(2026, 10, 14), over: [creatine, magnesium])
            == nil)
    let tuesday = screen(places, asOf: date(2026, 10, 13))

    let later = tuesday.changeDaysAway(
        try #require(tuesday.daysAway.first), named: "", from: monday12,
        through: date(2026, 10, 16), over: [creatine, magnesium])
    let earlier = tuesday.changeDaysAway(
        try #require(tuesday.daysAway.first), named: "", from: date(2026, 10, 11),
        through: date(2026, 10, 16), over: [creatine, magnesium])

    #expect(later == nil)
    #expect(earlier == nil)
    #expect(rows(on: monday12, at: places).map(\.name) == ["Creatine"])
    #expect(rows(on: monday12, at: places).map(\.isKept) == [true])
    #expect(rows(on: date(2026, 10, 11), at: places).isEmpty)
    #expect(rows(on: date(2026, 10, 15), at: places).isEmpty)
    #expect(rows(on: date(2026, 10, 17), at: places).map(\.name) == ["Creatine", "Magnesium"])
}

@MainActor
@Test(
    "an every-N-days count begins again on the day after each days away over it, and runs on unbroken once those days away are removed"
)
func anEveryNDaysCountBeginsAgainOnTheDayAfterEachDaysAwayOverItAndRunsOnUnbrokenOnceThoseDaysAwayAreRemoved()
    throws
{
    let places = Places()
    let nails = nails()
    try takeOn([nails], at: places)
    let commitments = screen(places)

    let lisbon = commitments.sayDaysAway(
        named: "Lisbon", from: date(2026, 10, 13), through: date(2026, 10, 14), over: [nails])
    let mallorca = commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 20), through: date(2026, 10, 21), over: [nails])

    #expect(lisbon == nil)
    #expect(mallorca == nil)
    var kept = try roster(at: places)
    for due in [9, 15, 19, 22, 26] { #expect(isDue("Nails", on: date(2026, 10, due), in: kept)) }
    for notDue in [13, 17, 23, 25] { #expect(!isDue("Nails", on: date(2026, 10, notDue), in: kept)) }

    let lisbonDays = try #require(commitments.daysAway.first { $0.title == "Lisbon" })
    commitments.askToRemove(lisbonDays)
    #expect(commitments.confirmRemovingDaysAway() == nil)
    kept = try roster(at: places)
    for due in [13, 17, 22, 26] { #expect(isDue("Nails", on: date(2026, 10, due), in: kept)) }
    for notDue in [15, 19] { #expect(!isDue("Nails", on: date(2026, 10, notDue), in: kept)) }
}
