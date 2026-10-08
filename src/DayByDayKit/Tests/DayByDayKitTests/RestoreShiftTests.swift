import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private let monday = date(2026, 8, 31)
private let tuesday = date(2026, 9, 1)

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

/// "Gym" on Monday, Wednesday and Saturday taken on at a roster place, a day screen opened at
/// Monday 31 August 2026 keeping a copy place whose directory a commitments screen was given, the
/// clock asked a later minute each time from 14:32.
@MainActor
private func dayScreen(_ setup: Setup) throws -> DayScreen {
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]),
        keptFrom: date(2026, 1, 1))!
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
@Test("a shift kept on a day screen writes a copy at the copy place holding that shift")
func aShiftKeptOnADayScreenWritesACopyAtTheCopyPlaceHoldingThatShift() throws {
    let setup = Setup()
    let day = try dayScreen(setup)

    try day.shift(day.dayView.rows.first { $0.name == "Gym" }!, to: tuesday)

    #expect(day.notice == nil)
    let first = try setup.copied()
    #expect(first.moment == Moment(on: monday, hour: 14, minute: 33)!)
    #expect(first.roster.commitments[0].isDue(on: tuesday))
    #expect(!first.roster.commitments[0].isDue(on: monday))

    day.showNextDay()
    try day.shift(day.dayView.rows.first { $0.name == "Gym" }!, to: monday)

    let second = try setup.copied()
    #expect(second.moment == Moment(on: monday, hour: 14, minute: 34)!)
    #expect(second.roster.commitments[0].isDue(on: monday))
    #expect(!second.roster.commitments[0].isDue(on: tuesday))
}

@MainActor
@Test("a shift refused, or asked of a day not offered, writes no copy at the copy place")
func aShiftRefusedOrAskedOfADayNotOfferedWritesNoCopyAtTheCopyPlace() throws {
    let setup = Setup()
    let day = try dayScreen(setup)
    let directory = setup.roster.deletingLastPathComponent()
    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
    defer {
        try? FileManager.default.setAttributes(
            [.posixPermissions: 0o700], ofItemAtPath: directory.path)
    }

    #expect(throws: (any Error).self) {
        try day.shift(day.dayView.rows.first { $0.name == "Gym" }!, to: tuesday)
    }

    #expect(try setup.copied().moment == Moment(on: monday, hour: 14, minute: 32)!)

    let writable = Setup()
    let other = try dayScreen(writable)

    try other.shift(other.dayView.rows.first { $0.name == "Gym" }!, to: date(2026, 9, 2))

    #expect(try writable.copied().moment == Moment(on: monday, hour: 14, minute: 32)!)
}
