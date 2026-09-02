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

@Test("a tick taken back is not held by a store opened afterwards at the same place")
func aTickTakenBackIsNotHeldByAStoreOpenedAfterwardsAtTheSamePlace() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tick = Tick(commitment, on: monday)!

    let first = try RecordStore(at: place)
    try first.add(tick)
    try first.remove(tick)
    let later = try RecordStore(at: place)

    #expect(!later.history.isKept(commitment, on: monday))
    #expect(later.history == History())
}

@Test("a store opened again holds exactly the ticks added and not taken back")
func aStoreOpenedAgainHoldsExactlyTheTicksAddedAndNotTakenBack() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    let gymOn31Aug = Tick(gym, on: CalendarDate(year: 2026, month: 8, day: 31)!)!
    let gymOn2Sep = Tick(gym, on: CalendarDate(year: 2026, month: 9, day: 2)!)!
    let gymOn5Sep = Tick(gym, on: CalendarDate(year: 2026, month: 9, day: 5)!)!
    let runOn31Aug = Tick(run, on: CalendarDate(year: 2026, month: 8, day: 31)!)!

    let store = try RecordStore(at: place)
    try store.add(gymOn31Aug)
    try store.add(gymOn2Sep)
    try store.add(gymOn5Sep)
    try store.add(runOn31Aug)
    try store.remove(gymOn2Sep)

    let later = try RecordStore(at: place)

    var expected = History()
    expected.add(gymOn31Aug)
    expected.add(gymOn5Sep)
    expected.add(runOn31Aug)
    #expect(later.history == expected)
}

@Test("adding a tick the store already holds leaves what is kept unchanged")
func addingATickTheStoreAlreadyHoldsLeavesWhatIsKeptUnchanged() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let tick = Tick(commitment, on: CalendarDate(year: 2026, month: 8, day: 31)!)!

    let store = try RecordStore(at: place)
    try store.add(tick)
    try store.add(tick)

    let later = try RecordStore(at: place)

    var expected = History()
    expected.add(tick)
    #expect(later.history == expected)
}
