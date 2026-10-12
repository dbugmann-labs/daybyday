import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private func freshPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("roster.json")
}

private func write(_ json: String, at place: URL) throws {
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(json.utf8).write(to: place)
}

private let everyDay = Schedule.weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])

@Test("a roster holding days away is written as form 10 with them, once, of the whole roster")
func aRosterHoldingDaysAwayIsWrittenAsForm10WithThemOnceOfTheWholeRoster() throws {
    let place = freshPlace()
    let gym = Commitment(name: "Gym", schedule: everyDay, keptFrom: date(2026, 1, 1))!
    let run = Commitment(name: "Run", schedule: everyDay, keptFrom: date(2026, 1, 1))!
    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(run)
    roster.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, run],
        keptThroughFirstDay: [])
    try RosterStore(at: place).replace(with: roster)

    let object = try #require(
        JSONSerialization.jsonObject(with: Data(contentsOf: place)) as? [String: Any])
    let daysAway = try #require(object["daysAway"] as? [[String: Any]])
    #expect(object["version"] as? Int == 10)
    #expect(daysAway.count == 1)
    #expect(daysAway[0]["name"] as? String == "Mallorca")
    #expect((daysAway[0]["commitments"] as? [String])?.count == 2)

    let reopened = try RosterStore(at: place).roster.daysAway
    #expect(reopened.map(\.title) == ["Mallorca"])
    #expect(reopened.map(\.commitments).map { $0.map(\.name) } == [["Gym", "Run"]])
}

@Test("a roster in form 10 without days away, and one before it with them, are refused")
func aRosterInForm10WithoutDaysAwayAndOneBeforeItWithThemAreRefused() throws {
    let without = freshPlace()
    try write(#"{"version": 10, "commitments": [], "emptied": false}"#, at: without)
    #expect(throws: RosterStoreError.notAStore(at: without)) {
        try RosterStore(at: without)
    }

    let before = freshPlace()
    try write(#"{"version": 9, "commitments": [], "emptied": false, "daysAway": []}"#, at: before)
    #expect(throws: RosterStoreError.notAStore(at: before)) {
        try RosterStore(at: before)
    }

    let earlier = freshPlace()
    try write(#"{"version": 9, "commitments": [], "emptied": false}"#, at: earlier)
    #expect(try RosterStore(at: earlier).roster.daysAway.isEmpty)
}
