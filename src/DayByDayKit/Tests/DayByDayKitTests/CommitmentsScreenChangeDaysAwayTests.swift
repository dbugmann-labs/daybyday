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
    _ name: String, _ schedule: Schedule = everyDay, keptFrom: CalendarDate = januaryFirst,
    kind: Commitment.Kind = .tick
) -> Commitment {
    Commitment(name: name, schedule: schedule, keptFrom: keptFrom, kind: kind)!
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

private func isDue(_ name: String, on day: CalendarDate, in roster: Roster) -> Bool {
    roster.groups(on: day).flatMap(\.commitments).contains {
        $0.name == name && $0.isDue(on: day)
    }
}

private func roster(at places: Places) throws -> Roster {
    try RosterStore(at: places.roster).roster
}

@MainActor
@Test("days away renamed keep their days and commitments and stay the same days away")
func daysAwayRenamedKeepTheirDaysAndCommitmentsAndStayTheSameDaysAway() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, run])
    let before = try #require(commitments.daysAway.first)

    let renamed = commitments.changeDaysAway(
        before, named: " Majorca ", from: date(2026, 10, 13), through: date(2026, 10, 18),
        over: [gym, run])

    #expect(renamed == nil)
    let after = try #require(commitments.daysAway.first)
    #expect(commitments.daysAway.count == 1)
    #expect(after.title == "Majorca")
    #expect(after.daysInWords == "Tue 13 Oct – Sun 18 Oct")
    #expect(after.commitments.map(\.name) == ["Gym", "Run"])
    #expect(after == before)

    commitments.changeDaysAway(
        after, named: "  ", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, run])
    #expect(commitments.daysAway.map(\.title) == ["Away"])
    let kept = try roster(at: places)
    for name in ["Gym", "Run"] {
        #expect(isDue(name, on: date(2026, 10, 19), in: kept))
        for day in 13...18 {
            #expect(!isDue(name, on: date(2026, 10, day), in: kept))
        }
    }
}
