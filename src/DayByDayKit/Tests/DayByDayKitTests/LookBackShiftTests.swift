import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private func freshPlaces() -> (roster: URL, record: URL) {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    return (
        directory.appendingPathComponent("roster.json"),
        directory.appendingPathComponent("record.json")
    )
}

@MainActor
@Test("a weekday-set day shifted into the next month is counted due and kept there")
func aWeekdaySetDayShiftedIntoTheNextMonthIsCountedDueAndKeptThere() throws {
    let places = freshPlaces()
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]),
        keptFrom: date(2026, 1, 1))!
    let store = try RosterStore(at: places.roster)
    try store.add(gym)
    try store.shift(gym, from: date(2026, 8, 31), to: date(2026, 9, 1))
    let shifted = store.roster.commitments[0]
    try RecordStore(at: places.record).add(Tick(shifted, on: date(2026, 9, 1))!)
    let screen = CommitmentsScreen(
        asOf: date(2026, 9, 6), keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let lookBack = screen.lookBack(at: screen.kept[0])

    #expect(lookBack?.lines.contains(.month(inWords: "September 2026", fraction: "1/3")) == true)
    #expect(lookBack?.lines.contains(.month(inWords: "August 2026", fraction: "0/13")) == true)
}

@MainActor
@Test("a day-of-month day shifted into the month before leaves that month owing two days and its own none")
func aDayOfMonthDayShiftedIntoTheMonthBeforeLeavesThatMonthOwingTwoDaysAndItsOwnNone() throws {
    let places = freshPlaces()
    let finances = Commitment(
        name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 1)!), keptFrom: date(2026, 1, 1))!
    let store = try RosterStore(at: places.roster)
    try store.add(finances)
    try store.shift(finances, from: date(2026, 9, 1), to: date(2026, 8, 31))
    _ = try RecordStore(at: places.record)
    let screen = CommitmentsScreen(
        asOf: date(2026, 9, 30), keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let lookBack = screen.lookBack(at: screen.kept[0])

    #expect(lookBack?.lines.contains(.month(inWords: "August 2026", fraction: "0/2")) == true)
    #expect(lookBack?.lines.contains(.month(inWords: "September 2026", fraction: "0/0")) == true)
}

@MainActor
@Test("an every-N-days day shifted back into the month before moves every later due day with it")
func anEveryNDaysDayShiftedBackIntoTheMonthBeforeMovesEveryLaterDueDayWithIt() throws {
    let places = freshPlaces()
    let lenses = Commitment(
        name: "Contact lenses",
        schedule: .everyNDays(DayInterval(days: 14)!, from: date(2026, 8, 25)),
        keptFrom: date(2026, 8, 25))!
    let store = try RosterStore(at: places.roster)
    try store.add(lenses)
    try store.shift(lenses, from: date(2026, 9, 8), to: date(2026, 8, 31))
    let shifted = store.roster.commitments[0]
    let records = try RecordStore(at: places.record)
    try records.add(Tick(shifted, on: date(2026, 8, 25))!)
    try records.add(Tick(shifted, on: date(2026, 8, 31))!)
    let screen = CommitmentsScreen(
        asOf: date(2026, 9, 30), keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let lookBack = screen.lookBack(at: screen.kept[0])

    #expect(lookBack?.lines.contains(.month(inWords: "August 2026", fraction: "2/2")) == true)
    #expect(lookBack?.lines.contains(.month(inWords: "September 2026", fraction: "0/2")) == true)
}
