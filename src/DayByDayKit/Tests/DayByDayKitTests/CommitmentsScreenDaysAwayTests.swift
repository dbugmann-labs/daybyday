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
private let runSchedule = Schedule.weekdays([.tuesday, .thursday, .sunday])

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

@MainActor
private func rows(on day: CalendarDate, at places: Places) -> [String] {
    DayScreen(
        startingFrom: [], asOf: day, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs
    ).dayView.rows.map(\.name)
}

@MainActor
@Test(
    "days away said over two commitments leave them no row on their days and rows again from the day after"
)
func daysAwaySaidOverTwoCommitmentsLeaveThemNoRowOnTheirDaysAndRowsAgainFromTheDayAfter() throws {
    let places = Places()
    let gym = commitment("Gym", gymSchedule)
    let run = commitment("Run", runSchedule)
    let creatine = commitment("Creatine")
    try takeOn([gym, run, creatine], at: places)
    let commitments = screen(places)

    let refusal = commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, run])

    #expect(refusal == nil)
    #expect(commitments.kept.map(\.name) == ["Gym", "Run", "Creatine"])
    #expect(commitments.stopped.isEmpty)
    #expect(rows(on: monday12, at: places) == ["Gym", "Creatine"])
    #expect(rows(on: date(2026, 10, 14), at: places) == ["Creatine"])
    #expect(rows(on: date(2026, 10, 15), at: places) == ["Creatine"])
    #expect(rows(on: date(2026, 10, 17), at: places) == ["Creatine"])
    #expect(rows(on: date(2026, 10, 19), at: places) == ["Gym", "Creatine"])
    #expect(rows(on: date(2026, 10, 20), at: places) == ["Run", "Creatine"])
}
