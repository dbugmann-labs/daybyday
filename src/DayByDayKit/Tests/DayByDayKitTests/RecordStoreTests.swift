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

@Test("a tick in the first supported year and one in the last are read back unchanged")
func aTickInTheFirstSupportedYearAndOneInTheLastAreReadBackUnchanged() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 1583, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let firstDate = CalendarDate(year: 1583, month: 1, day: 3)!
    let lastDate = CalendarDate(year: 9999, month: 12, day: 27)!
    let firstTick = Tick(commitment, on: firstDate)!
    let lastTick = Tick(commitment, on: lastDate)!

    let store = try RecordStore(at: place)
    try store.add(firstTick)
    try store.add(lastTick)

    let later = try RecordStore(at: place)

    #expect(later.history.isKept(commitment, on: firstDate))
    #expect(later.history.isKept(commitment, on: lastDate))
    var expected = History()
    expected.add(firstTick)
    expected.add(lastTick)
    #expect(later.history == expected)
}

@Test("ticks of commitments on every schedule shape are read back as the same ticks")
func ticksOfCommitmentsOnEveryScheduleShapeAreReadBackAsTheSameTicks() throws {
    let place = freshPlace()
    let januaryFirst2026 = CalendarDate(year: 2026, month: 1, day: 1)!

    let gym = Commitment(
        name: "Gym",
        schedule: .weekdays([.monday, .wednesday, .saturday]),
        keptFrom: januaryFirst2026)!
    let gymTick = Tick(gym, on: CalendarDate(year: 2026, month: 8, day: 31)!)!

    let finances = Commitment(
        name: "Finances",
        schedule: .dayOfMonth(DayOfMonth(day: 25)!),
        keptFrom: januaryFirst2026)!
    let financesTick = Tick(finances, on: CalendarDate(year: 2026, month: 9, day: 25)!)!

    let plants = Commitment(
        name: "Plants",
        schedule: .everyNDays(
            DayInterval(days: 3)!, from: CalendarDate(year: 2026, month: 8, day: 25)!),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!)!
    let plantsTick = Tick(plants, on: CalendarDate(year: 2026, month: 9, day: 3)!)!

    let reading = Commitment(
        name: "Reading",
        schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!),
        keptFrom: januaryFirst2026)!
    let readingTick = Tick(reading, on: CalendarDate(year: 2026, month: 9, day: 7)!)!

    let store = try RecordStore(at: place)
    try store.add(gymTick)
    try store.add(financesTick)
    try store.add(plantsTick)
    try store.add(readingTick)

    let later = try RecordStore(at: place)

    var expected = History()
    expected.add(gymTick)
    expected.add(financesTick)
    expected.add(plantsTick)
    expected.add(readingTick)
    #expect(later.history == expected)

    #expect(later.history.isKept(gym, on: CalendarDate(year: 2026, month: 8, day: 31)!))
    #expect(later.history.isKept(finances, on: CalendarDate(year: 2026, month: 9, day: 25)!))
    #expect(later.history.isKept(plants, on: CalendarDate(year: 2026, month: 9, day: 3)!))
    #expect(later.history.isKept(reading, on: CalendarDate(year: 2026, month: 9, day: 7)!))
}

@Test("a commitment name is read back exactly, whatever it contains")
func aCommitmentNameIsReadBackExactlyWhateverItContains() throws {
    let place = freshPlace()
    let name = "Zürich — „langer“ Lauf 🏃\nSonntags"
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: name, schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tick = Tick(commitment, on: monday)!

    let store = try RecordStore(at: place)
    try store.add(tick)

    let later = try RecordStore(at: place)

    #expect(later.history.isKept(commitment, on: monday))
    var expected = History()
    expected.add(tick)
    #expect(later.history == expected)
}

@Test("stores at different places hold different histories")
func storesAtDifferentPlacesHoldDifferentHistories() throws {
    let firstPlace = freshPlace()
    let secondPlace = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tick = Tick(commitment, on: monday)!

    let first = try RecordStore(at: firstPlace)
    try first.add(tick)
    let second = try RecordStore(at: secondPlace)

    #expect(second.history == History())

    let laterFirst = try RecordStore(at: firstPlace)
    #expect(laterFirst.history.isKept(commitment, on: monday))
}
