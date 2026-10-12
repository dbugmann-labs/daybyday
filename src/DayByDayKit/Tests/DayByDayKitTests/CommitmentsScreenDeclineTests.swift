import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private let everyDay = Schedule.weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])

private func places() -> (roster: URL, record: URL, oneOffs: URL) {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    return (
        directory.appendingPathComponent("roster.json"),
        directory.appendingPathComponent("record.json"),
        directory.appendingPathComponent("one-offs.json")
    )
}

@MainActor
@Test("a deletion erases every decline of its commitment")
func aDeletionErasesEveryDeclineOfItsCommitment() throws {
    let held = places()
    let gym = Commitment(name: "Gym", schedule: everyDay, keptFrom: date(2026, 1, 1))!
    let run = Commitment(name: "Run", schedule: everyDay, keptFrom: date(2026, 1, 1))!
    let roster = try RosterStore(at: held.roster)
    try roster.add(gym)
    try roster.add(run)
    let monday = date(2026, 8, 3)
    let store = try RecordStore(at: held.record)
    try store.add(Decline(for: gym, on: monday, reason: "Away")!)
    try store.add(Decline(for: gym, on: date(2026, 8, 4), reason: nil)!)
    try store.add(Decline(for: run, on: monday, reason: "Ill")!)
    let screen = CommitmentsScreen(
        asOf: date(2026, 8, 31), keepingRosterAt: held.roster, keepingRecordAt: held.record,
        keepingOneOffsAt: held.oneOffs)

    screen.askToDelete(gym)
    screen.nameTypedBack = "Gym"

    #expect(screen.confirmDeleting() == nil)

    var expected = History()
    expected.add(Decline(for: run, on: monday, reason: "Ill")!)
    #expect(try RecordStore(at: held.record).history == expected)
    let content = try String(contentsOf: held.record, encoding: .utf8)
    #expect(!content.contains("Away"))
}

@MainActor
@Test("a commitment stopped through a commitments screen on a day it was declined is kept until that day")
func aCommitmentStoppedThroughACommitmentsScreenOnADayItWasDeclinedIsKeptUntilThatDay() throws {
    let held = places()
    let gym = Commitment(name: "Gym", schedule: everyDay, keptFrom: date(2026, 1, 1))!
    let monday = date(2026, 8, 31)
    try RosterStore(at: held.roster).add(gym)
    try RecordStore(at: held.record).add(Decline(for: gym, on: monday, reason: "Away")!)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: held.roster, keepingRecordAt: held.record,
        keepingOneOffsAt: held.oneOffs)

    screen.askToStopKeeping(gym)
    screen.confirmStopKeeping()

    let later = try RosterStore(at: held.roster)
    #expect(later.roster.commitments(on: monday).map(\.name) == ["Gym"])
    #expect(later.roster.commitments(on: date(2026, 9, 1)).isEmpty)
    let day = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: held.record,
        keepingRosterAt: held.roster, keepingOneOffsAt: held.oneOffs)
    #expect(day.dayView.rows.map(\.name) == ["Gym"])
    #expect(day.dayView.rows[0].isDeclined)
    #expect(day.dayView.rows[0].declineReason == "Away")
}
