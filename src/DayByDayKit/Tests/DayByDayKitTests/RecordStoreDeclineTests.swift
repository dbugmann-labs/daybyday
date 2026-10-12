import Foundation
import Testing
@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private func freshPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("store.json")
}

private let mwf = Schedule.weekdays([.monday, .wednesday, .saturday])
private let keptFrom = date(2026, 1, 1)
private let monday = date(2026, 8, 31)
private let wednesday = date(2026, 9, 2)
private let saturday = date(2026, 9, 5)

@Test("declines kept in a store are read back by a store opened afterwards, each with its reason")
func declinesKeptInAStoreAreReadBackByAStoreOpenedAfterwardsEachWithItsReason() throws {
    let run = Commitment(name: "Run", schedule: mwf, keptFrom: keptFrom)!
    let place = freshPlace()
    let store = try RecordStore(at: place)
    let long = " Knee still sore \nResting it."
    try store.add(Decline(for: run, on: monday, reason: "Ran out")!)
    try store.add(Decline(for: run, on: wednesday, reason: nil)!)
    try store.add(Decline(for: run, on: saturday, reason: long)!)
    try store.add(Decline(for: run, on: monday, reason: "Ran out, ordered more")!)
    try store.removeDecline(for: run, on: wednesday)

    let reopened = try RecordStore(at: place)

    var expected = History()
    expected.add(Decline(for: run, on: monday, reason: "Ran out, ordered more")!)
    expected.add(Decline(for: run, on: saturday, reason: long)!)
    #expect(reopened.history == expected)
    #expect(reopened.history.decline(for: run, on: saturday)?.reason == long)
    #expect(reopened.history.decline(for: run, on: wednesday) == nil)
}
