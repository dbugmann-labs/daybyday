import Foundation
import Testing
import DayByDayKit

/// A fresh place under the temporary directory, one per test, so tests are independent and need
/// no teardown: a UUID names the directory, and the record file sits one level under it, so the
/// directory itself does not exist until something creates it. Mirrors `RecordStoreTests`'s
/// `freshPlace()`.
private func freshPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("record.json")
}

@MainActor
@Test("a day screen opened where nothing has been kept holds the day view of that day with nothing kept")
func aDayScreenOpenedWhereNothingHasBeenKeptHoldsTheDayViewOfThatDayWithNothingKept() {
    let place = freshPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.tuesday, .thursday, .sunday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = DayScreen(of: [gym, run], asOf: monday, keeping: place)

    #expect(screen.dayView.rows.map(\.name) == ["Gym"])
    #expect(!screen.dayView.rows[0].isKept)
}

@MainActor
@Test("a day screen opened where a tick was kept holds a day view that says the commitment is kept")
func aDayScreenOpenedWhereATickWasKeptHoldsADayViewThatSaysTheCommitmentIsKept() throws {
    let place = freshPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tick = Tick(gym, on: monday)!

    let store = try RecordStore(at: place)
    try store.add(tick)

    let screen = DayScreen(of: [gym], asOf: monday, keeping: place)

    #expect(screen.dayView.rows.count == 1)
    #expect(screen.dayView.rows[0].isKept)
}

@MainActor
@Test("a day screen holds the day it was handed rather than the day it really is")
func aDayScreenHoldsTheDayItWasHandedRatherThanTheDayItReallyIs() {
    let keptFrom = CalendarDate(year: 1583, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let firstSupported = CalendarDate(year: 1583, month: 1, day: 3)!
    let lastSupported = CalendarDate(year: 9999, month: 12, day: 27)!

    let onFirstSupported = DayScreen(of: [gym], asOf: firstSupported, keeping: freshPlace())
    let onLastSupported = DayScreen(of: [gym], asOf: lastSupported, keeping: freshPlace())

    #expect(
        onFirstSupported.dayView
            == DayView(of: [gym], on: firstSupported, in: History()))
    #expect(
        onLastSupported.dayView
            == DayView(of: [gym], on: lastSupported, in: History()))
}

@MainActor
@Test(
    "a day screen holds the same day view as one formed directly from the same commitments, day and history"
)
func aDayScreenHoldsTheSameDayViewAsOneFormedDirectlyFromTheSameCommitmentsDayAndHistory() throws {
    let place = freshPlace()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let journaling = Commitment(
        name: "Journaling",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gymTick = Tick(gym, on: monday)!
    let journalingTick = Tick(journaling, on: monday)!

    let store = try RecordStore(at: place)
    try store.add(gymTick)
    try store.add(journalingTick)
    try store.remove(journalingTick)

    let screen = DayScreen(of: [gym, journaling], asOf: monday, keeping: place)

    var expectedHistory = History()
    expectedHistory.add(gymTick)
    let expected = DayView(of: [gym, journaling], on: monday, in: expectedHistory)

    #expect(screen.dayView == expected)
}
