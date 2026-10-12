import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private let monday = date(2026, 8, 31)
private let everyDay = Schedule.weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])

private func fresh(_ name: String) -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent(name)
}

/// A clock that answers a later minute each time it is asked, starting from `first`.
@MainActor
private func laterMinuteEachTime(from first: Moment) -> @Sendable () -> Moment? {
    final class Counter: @unchecked Sendable {
        var minutesAsked = 0
    }
    let counter = Counter()
    return {
        let moment = Moment(
            on: first.day, hour: first.hour, minute: first.minute + counter.minutesAsked)!
        counter.minutesAsked += 1
        return moment
    }
}

private struct Setup {
    let record = fresh("record.json")
    let roster = fresh("roster.json")
    let oneOffs = fresh("one-offs.json")
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    var file: URL { directory.appendingPathComponent("DayByDay.daybyday") }

    func copied() throws -> Copy {
        try #require(JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: file)).formCopy())
    }
}

private let gym = Commitment(name: "Gym", schedule: everyDay, keptFrom: date(2026, 1, 1))!

@MainActor
private func dayScreen(_ setup: Setup) throws -> DayScreen {
    try RosterStore(at: setup.roster).add(gym)
    let copyPlace = CopyPlace(
        at: fresh("copy-place.json"), keepingRecordAt: setup.record, keepingRosterAt: setup.roster,
        keepingOneOffsAt: setup.oneOffs,
        asking: laterMinuteEachTime(from: Moment(on: monday, hour: 14, minute: 32)!))
    let commitments = CommitmentsScreen(
        asOf: monday, keepingRosterAt: setup.roster, keepingRecordAt: setup.record,
        keepingOneOffsAt: setup.oneOffs, copyingTo: copyPlace)
    commitments.givenAsCopyPlace(setup.directory)
    return DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: setup.record,
        keepingRosterAt: setup.roster, keepingOneOffsAt: setup.oneOffs, copyingTo: copyPlace)
}

@MainActor
@Test("a decline made, its reason changed and its take-back on a day screen each write a copy at the copy place")
func aDeclineMadeItsReasonChangedAndItsTakeBackOnADayScreenEachWriteACopyAtTheCopyPlace() throws {
    let setup = Setup()
    let day = try dayScreen(setup)

    try day.decline(day.dayView.rows[0], reason: "Away")

    #expect(day.notice == nil)
    let first = try setup.copied()
    #expect(first.moment == Moment(on: monday, hour: 14, minute: 33)!)
    #expect(first.history.decline(for: gym, on: monday)?.reason == "Away")

    try day.decline(day.dayView.rows[0], reason: "Away at a wedding")

    let second = try setup.copied()
    #expect(second.moment == Moment(on: monday, hour: 14, minute: 34)!)
    #expect(second.history.decline(for: gym, on: monday)?.reason == "Away at a wedding")

    try day.takeBackDecline(on: day.dayView.rows[0])

    let third = try setup.copied()
    #expect(third.moment == Moment(on: monday, hour: 14, minute: 35)!)
    #expect(third.history == History())

    let refused = Setup()
    let other = try dayScreen(refused)
    let directory = refused.record.deletingLastPathComponent()
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
    defer {
        try? FileManager.default.setAttributes(
            [.posixPermissions: 0o700], ofItemAtPath: directory.path)
    }

    #expect(throws: (any Error).self) { try other.decline(other.dayView.rows[0], reason: "Away") }

    #expect(try refused.copied().moment == Moment(on: monday, hour: 14, minute: 32)!)
}

@MainActor
@Test("a copy holding a decline, restored, puts the decline and its reason back at the record place")
func aCopyHoldingADeclineRestoredPutsTheDeclineAndItsReasonBackAtTheRecordPlace() throws {
    let held = Setup()
    let sunday = date(2026, 8, 30)
    try RosterStore(at: held.roster).add(gym)
    let store = try RecordStore(at: held.record)
    try store.add(Decline(for: gym, on: sunday, reason: "Away")!)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: held.roster, keepingRecordAt: held.record,
        keepingOneOffsAt: held.oneOffs)
    guard
        case .success(let copyURL) = screen.makeACopy(
            asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: held.directory)
    else {
        Issue.record("expected a copy to be made")
        return
    }
    try store.removeDecline(for: gym, on: sunday)
    try store.add(Tick(gym, on: monday)!)

    #expect(screen.askToRestore(from: copyURL) == nil)
    #expect(screen.confirmRestoring() == nil)

    var expected = History()
    expected.add(Decline(for: gym, on: sunday, reason: "Away")!)
    #expect(try RecordStore(at: held.record).history == expected)
}
