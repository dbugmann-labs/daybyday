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

@Test("a record added on a declined day is read back alone by a store opened afterwards")
func aRecordAddedOnADeclinedDayIsReadBackAloneByAStoreOpenedAfterwards() throws {
    let gym = Commitment(name: "Gym", schedule: mwf, keptFrom: keptFrom)!
    let protein = Commitment(
        name: "Protein", schedule: mwf, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let place = freshPlace()
    let store = try RecordStore(at: place)
    try store.add(Decline(for: gym, on: monday, reason: "Away")!)
    try store.add(Decline(for: protein, on: monday, reason: nil)!)
    try store.add(Tick(gym, on: monday)!)
    try store.add(Addition(30, for: protein, on: monday)!)

    let reopened = try RecordStore(at: place)

    var alone = History()
    alone.add(Tick(gym, on: monday)!)
    alone.add(Addition(30, for: protein, on: monday)!)
    #expect(reopened.history == alone)
    #expect(try String(contentsOf: place, encoding: .utf8).contains("Away") == false)
}

private func blockedPlace() throws -> URL {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    return blocker.appendingPathComponent("store.json")
}

@Test("a decline that cannot be kept is refused and not held")
func aDeclineThatCannotBeKeptIsRefusedAndNotHeld() throws {
    let place = try blockedPlace()
    let magnesium = Commitment(name: "Magnesium", schedule: mwf, keptFrom: keptFrom)!
    let decline = Decline(for: magnesium, on: monday, reason: "Ran out")!

    let store = try RecordStore(at: place)

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try store.add(decline)
    }
    #expect(store.history == History())
    #expect(try RecordStore(at: place).history == History())

    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let keptPlace = directory.appendingPathComponent("store.json")
    let kept = try RecordStore(at: keptPlace)
    try kept.add(decline)
    try FileManager.default.removeItem(at: directory)
    try Data().write(to: directory)

    #expect(throws: RecordStoreError.cannotWrite(at: keptPlace)) {
        try kept.removeDecline(for: magnesium, on: monday)
    }
    #expect(kept.history.decline(for: magnesium, on: monday)?.reason == "Ran out")
}

@Test("a decline on a day a shift put a due day on is read back after the app is closed and opened again")
func aDeclineOnADayAShiftPutADueDayOnIsReadBackAfterTheAppIsClosedAndOpenedAgain() throws {
    let magnesium = Commitment(name: "Magnesium", schedule: mwf, keptFrom: keptFrom)!
    var roster = Roster()
    _ = roster.add(magnesium)
    let tuesday = date(2026, 9, 1)
    let didShift = roster.shift(magnesium, from: monday, to: tuesday)
    #expect(didShift)
    let shifted = roster.commitments[0]
    let place = freshPlace()
    let store = try RecordStore(at: place)
    try store.add(Decline(for: shifted, on: tuesday, reason: "Away")!)

    let reopened = try RecordStore(at: place)

    #expect(reopened.history.decline(for: shifted, on: tuesday)?.reason == "Away")
}

/// A store in the given form, holding the given `ticks` and `declines` array bodies as JSON; a
/// `nil` `declines` leaves the key out.
private func storeJSON(
    version: Int, name: String = "Gym", schedule: String = #"{ "weekdays": ["monday", "wednesday", "saturday"] }"#,
    tick: (month: Int, day: Int)? = nil, decline: (month: Int, day: Int, reason: String)? = nil,
    declinesKey: Bool
) -> Data {
    func commitment(_ date: (month: Int, day: Int)) -> String {
        """
        "commitment": {
              "name": "\(name)",
              "keptFrom": { "year": 2026, "month": 1, "day": 1 },
              "schedule": \(schedule),
              "kind": { "tick": {} },
              "identity": "11111111-1111-1111-1111-111111111111"
            },
            "date": { "year": 2026, "month": \(date.month), "day": \(date.day) }
        """
    }
    let ticks = tick.map { "{ \(commitment($0)) }" } ?? ""
    let declines = decline.map {
        "{ \(commitment((month: $0.month, day: $0.day))), \"reason\": \"\($0.reason)\" }"
    } ?? ""
    return Data(
        """
        {
          "version": \(version),
          "ticks": [\(ticks)],
          "numbers": [],
          "notes": [],
          "additions": []\(declinesKey ? ",\n  \"declines\": [\(declines)]" : "")
        }
        """.utf8)
}

@Test("a history kept before a day could hold a decline is read with none, and its place left as it was")
func aHistoryKeptBeforeADayCouldHoldADeclineIsReadWithNoneAndItsPlaceLeftAsItWas() throws {
    let gym = Commitment(
        identity: Commitment.Identity("11111111-1111-1111-1111-111111111111")!, name: "Gym",
        schedule: mwf, keptFrom: keptFrom, kind: .tick)!
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = storeJSON(version: 8, tick: (8, 31), declinesKey: false)
    try bytes.write(to: place)

    let store = try RecordStore(at: place)

    #expect(try Data(contentsOf: place) == bytes)
    #expect(store.history.isKept(gym, on: monday))
    #expect(store.history.decline(for: gym, on: monday) == nil)
    let run = Commitment(name: "Run", schedule: mwf, keptFrom: keptFrom)!
    try store.add(Decline(for: run, on: wednesday, reason: "Away")!)

    let reopened = try RecordStore(at: place)

    #expect(reopened.history.isKept(gym, on: monday))
    #expect(reopened.history.decline(for: run, on: wednesday)?.reason == "Away")
}

@Test("a store holding what could not be a decline is refused")
func aStoreHoldingWhatCouldNotBeADeclineIsRefused() throws {
    let quota = #"{ "timesPerWeek": 2 }"#
    let cases: [Data] = [
        storeJSON(version: 9, name: "Yuno", schedule: quota, decline: (8, 31, "x"), declinesKey: true),
        storeJSON(version: 9, decline: (9, 1, "x"), declinesKey: true),
        storeJSON(version: 9, decline: (8, 31, "   "), declinesKey: true),
        storeJSON(version: 9, tick: (8, 31), decline: (8, 31, "x"), declinesKey: true),
    ]
    for bytes in cases {
        let place = freshPlace()
        try FileManager.default.createDirectory(
            at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
        try bytes.write(to: place)

        #expect(throws: RecordStoreError.notAStore(at: place)) {
            try RecordStore(at: place)
        }
        #expect(try Data(contentsOf: place) == bytes)
    }
}

@Test("a store whose shape and declared form disagree about declines is refused")
func aStoreWhoseShapeAndDeclaredFormDisagreeAboutDeclinesIsRefused() throws {
    let cases: [Data] = [
        storeJSON(version: 8, decline: (8, 31, "x"), declinesKey: true),
        storeJSON(version: 9, declinesKey: false),
    ]
    for bytes in cases {
        let place = freshPlace()
        try FileManager.default.createDirectory(
            at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
        try bytes.write(to: place)

        #expect(throws: RecordStoreError.notAStore(at: place)) {
            try RecordStore(at: place)
        }
        #expect(try Data(contentsOf: place) == bytes)
    }
}
