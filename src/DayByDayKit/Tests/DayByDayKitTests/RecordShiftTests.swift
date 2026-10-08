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

@Test("records on a day a shift put a due day on are read back after the app is closed and opened again")
func recordsOnADayAShiftPutADueDayOnAreReadBackAfterTheAppIsClosedAndOpenedAgain() throws {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = date(2026, 1, 1)
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    var roster = Roster()
    _ = roster.add(gym)
    _ = roster.add(protein)
    for commitment in [gym, protein] {
        let shifted = roster.shift(commitment, from: date(2026, 8, 31), to: date(2026, 9, 1))
        #expect(shifted)
    }
    let tuesday = date(2026, 9, 1)
    let place = freshPlace()
    let store = try RecordStore(at: place)
    try store.add(Tick(roster.commitments[0], on: tuesday)!)
    try store.add(Addition(35, for: roster.commitments[1], on: tuesday)!)
    let later = roster.shift(roster.commitments[0], from: date(2026, 9, 2), to: date(2026, 9, 3))
    #expect(later)

    let reopened = try RecordStore(at: place)

    #expect(reopened.history.isKept(roster.commitments[0], on: tuesday))
    #expect(reopened.history.total(for: roster.commitments[1], on: tuesday) == 35)
    let written = try String(contentsOf: place, encoding: .utf8)
    #expect(!written.contains(#""day":2,"month":9"#))
}

/// A store in the given form holding one tick of "Gym" on Tuesday 1 September 2026, with the
/// `shiftedFrom` day given beside it — `nil` leaves the key out.
private func tickJSON(version: Int, shiftedFrom: (month: Int, day: Int)?) -> Data {
    let shift = shiftedFrom.map {
        #","shiftedFrom": { "year": 2026, "month": \#($0.month), "day": \#($0.day) }"#
    } ?? ""
    return Data(
        """
        {
          "version": \(version),
          "ticks": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "tick": {} },
                "identity": "11111111-1111-1111-1111-111111111111"\(shift)
              },
              "date": { "year": 2026, "month": 9, "day": 1 }
            }
          ],
          "numbers": [],
          "notes": [],
          "additions": []
        }
        """.utf8)
}

private func expectNotAStore(_ bytes: Data) throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try bytes.write(to: place)

    #expect(throws: RecordStoreError.notAStore(at: place)) {
        try RecordStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a store holding a record beside a shift that could not be one is refused")
func aStoreHoldingARecordBesideAShiftThatCouldNotBeOneIsRefused() throws {
    try expectNotAStore(tickJSON(version: 7, shiftedFrom: (8, 24)))
    try expectNotAStore(tickJSON(version: 7, shiftedFrom: (9, 1)))

    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try tickJSON(version: 7, shiftedFrom: (8, 31)).write(to: place)
    let store = try RecordStore(at: place)
    let gym = Commitment(
        identity: Commitment.Identity("11111111-1111-1111-1111-111111111111")!, name: "Gym",
        schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: date(2026, 1, 1),
        kind: .tick, shifts: [date(2026, 8, 31): date(2026, 9, 1)])!
    #expect(store.history.isKept(gym, on: date(2026, 9, 1)))
}

@Test("a store whose shape and declared form disagree about shifts is refused")
func aStoreWhoseShapeAndDeclaredFormDisagreeAboutShiftsIsRefused() throws {
    try expectNotAStore(tickJSON(version: 6, shiftedFrom: (8, 31)))
}
