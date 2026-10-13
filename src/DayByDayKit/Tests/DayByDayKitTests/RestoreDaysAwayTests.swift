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

private struct Places {
    let roster: URL
    let record: URL
    let oneOffs: URL
    let birthday: URL
    let happenings: URL
    let copyState: URL

    init() {
        let base = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        roster = base.appendingPathComponent("roster.json")
        record = base.appendingPathComponent("record.json")
        oneOffs = base.appendingPathComponent("one-offs.json")
        birthday = base.appendingPathComponent("birthday-ticks.json")
        happenings = base.appendingPathComponent("happenings.json")
        copyState = base.appendingPathComponent("copy-place.json")
    }

    @MainActor
    func screen(copyingTo copyPlace: CopyPlace? = nil) -> CommitmentsScreen {
        CommitmentsScreen(
            asOf: monday12, keepingRosterAt: roster, keepingRecordAt: record, keepingOneOffsAt: oneOffs,
            keepingBirthdayTicksAt: birthday, keepingHappeningsAt: happenings, copyingTo: copyPlace)
    }
}

private func commitment(_ name: String) -> Commitment {
    Commitment(name: name, schedule: everyDay, keptFrom: januaryFirst, kind: .tick)!
}

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

private func copyHeld(in directory: URL) throws -> Copy {
    let files = try FileManager.default.contentsOfDirectory(
        at: directory, includingPropertiesForKeys: nil)
    let file = try #require(files.first)
    #expect(files.count == 1)
    #expect(file.lastPathComponent == "DayByDay.daybyday")
    guard case .success(let copy) = CopyDocument.read(try Data(contentsOf: file)) else {
        Issue.record("expected the file to read as a copy")
        throw CocoaError(.fileReadCorruptFile)
    }
    return copy
}

@MainActor
@Test("days away said and removed on a commitments screen each write a copy at the copy place")
func daysAwaySaidAndRemovedOnACommitmentsScreenEachWriteACopyAtTheCopyPlace() throws {
    let places = Places()
    let gym = commitment("Gym")
    try RosterStore(at: places.roster).add(gym)
    let copyPlace = CopyPlace(
        at: places.copyState, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday,
        keepingHappeningsAt: places.happenings,
        asking: laterMinuteEachTime(from: Moment(on: monday12, hour: 14, minute: 32)!))
    let screen = places.screen(copyingTo: copyPlace)
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    screen.givenAsCopyPlace(directory)

    let said = screen.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])

    #expect(said == nil)
    let afterSaying = try copyHeld(in: directory)
    #expect(afterSaying.moment == Moment(on: monday12, hour: 14, minute: 33)!)
    #expect(afterSaying.roster.daysAway.map(\.title) == ["Mallorca"])
    #expect(afterSaying.roster.daysAway.first?.commitments.map(\.name) == ["Gym"])

    screen.askToRemove(try #require(screen.daysAway.first))
    let removed = screen.confirmRemovingDaysAway()

    #expect(removed == nil)
    let afterRemoving = try copyHeld(in: directory)
    #expect(afterRemoving.moment == Moment(on: monday12, hour: 14, minute: 34)!)
    #expect(afterRemoving.roster.daysAway.isEmpty)

    let refused = screen.sayDaysAway(
        named: "", from: date(2026, 10, 14), through: date(2026, 10, 13), over: [gym])
    #expect(refused == .lastDayBeforeFirstDay)
    #expect(copyPlace.lastCopy == Moment(on: monday12, hour: 14, minute: 34)!)
    #expect(try copyHeld(in: directory).moment == Moment(on: monday12, hour: 14, minute: 34)!)
}

@MainActor
@Test("a copy holding days away, restored, puts them and their gaps back at the roster place")
func aCopyHoldingDaysAwayRestoredPutsThemAndTheirGapsBackAtTheRosterPlace() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    let store = try RosterStore(at: places.roster)
    try store.add(gym)
    try store.add(run)
    let screen = places.screen()
    screen.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    let made = screen.makeACopy(
        asOf: Moment(on: monday12, hour: 14, minute: 32)!,
        writingInto: FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true))
    guard case .success(let copyURL) = made else {
        Issue.record("expected a copy to be made")
        return
    }
    screen.askToRemove(try #require(screen.daysAway.first))
    screen.confirmRemovingDaysAway()
    screen.sayDaysAway(
        named: "Lisbon", from: date(2026, 10, 19), through: date(2026, 10, 21), over: [run])

    let asked = screen.askToRestore(from: copyURL)
    let restored = screen.confirmRestoring()

    #expect(asked == nil)
    #expect(restored == nil)
    #expect(screen.daysAway.map(\.title) == ["Mallorca"])
    #expect(screen.daysAway.first?.commitments.map(\.name) == ["Gym"])
    let roster = try RosterStore(at: places.roster).roster
    #expect(roster.daysAway.map(\.title) == ["Mallorca"])
    func isDue(_ name: String, on day: CalendarDate) -> Bool {
        roster.groups(on: day).flatMap(\.commitments).contains { $0.name == name && $0.isDue(on: day) }
    }
    for gap in 13...18 {
        #expect(!isDue("Gym", on: date(2026, 10, gap)))
    }
    #expect(isDue("Gym", on: date(2026, 10, 19)))
    #expect(isDue("Run", on: date(2026, 10, 19)))
}

@MainActor
@Test("days away changed on a commitments screen write a copy at the copy place")
func daysAwayChangedOnACommitmentsScreenWriteACopyAtTheCopyPlace() throws {
    let places = Places()
    let gym = commitment("Gym")
    try RosterStore(at: places.roster).add(gym)
    let copyPlace = CopyPlace(
        at: places.copyState, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday,
        keepingHappeningsAt: places.happenings,
        asking: laterMinuteEachTime(from: Moment(on: monday12, hour: 14, minute: 32)!))
    let screen = places.screen(copyingTo: copyPlace)
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    screen.givenAsCopyPlace(directory)
    screen.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    let mallorca = try #require(screen.daysAway.first)

    let changed = screen.changeDaysAway(
        mallorca, named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 16),
        over: [gym])
    let refused = screen.changeDaysAway(
        try #require(screen.daysAway.first), named: "Mallorca", from: date(2026, 10, 13),
        through: monday12, over: [gym])

    #expect(changed == nil)
    #expect(refused == .lastDayBeforeFirstDay)
    let copy = try copyHeld(in: directory)
    #expect(copy.moment == Moment(on: monday12, hour: 14, minute: 34)!)
    #expect(copy.roster.daysAway.map(\.title) == ["Mallorca"])
    #expect(copy.roster.daysAway.first?.lastDay == date(2026, 10, 16))
    #expect(copy.roster.daysAway.first?.commitments.map(\.name) == ["Gym"])
    #expect(copyPlace.lastCopy == Moment(on: monday12, hour: 14, minute: 34)!)
}
