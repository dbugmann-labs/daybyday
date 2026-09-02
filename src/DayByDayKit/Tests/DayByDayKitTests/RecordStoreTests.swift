import Foundation
import Testing
import DayByDayKit

/// A fresh place under the temporary directory, one per test, so tests are independent and need
/// no teardown: a UUID names the directory, and the store's file sits one level under it, so the
/// directory itself does not exist until the store creates it.
private func freshPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("store.json")
}

@Test("a store opened where nothing has been kept holds an empty history")
func aStoreOpenedWhereNothingHasBeenKeptHoldsAnEmptyHistory() throws {
    let place = freshPlace()

    let store = try RecordStore(at: place)

    #expect(store.history == History())
}

@Test("a tick added to a store is held by a second store opened at the same place while the first is still open")
func aTickAddedToAStoreIsHeldByASecondStoreOpenedAtTheSamePlaceWhileTheFirstIsStillOpen() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tick = Tick(commitment, on: monday)!

    let first = try RecordStore(at: place)
    try first.add(tick)
    let second = try RecordStore(at: place)

    #expect(second.history.isKept(commitment, on: monday))
}
