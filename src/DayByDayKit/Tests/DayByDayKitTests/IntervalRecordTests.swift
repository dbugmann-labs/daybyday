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

@Test("records on every-N-days days a shifted count runs on to are read back after the app is closed and opened again")
func recordsOnEveryNDaysDaysAShiftedCountRunsOnToAreReadBackAfterTheAppIsClosedAndOpenedAgain() throws {
    let schedule = Schedule.everyNDays(DayInterval(days: 4)!, from: date(2026, 8, 6))
    let keptFrom = date(2026, 8, 6)
    let nails = Commitment(name: "Nails", schedule: schedule, keptFrom: keptFrom)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    var roster = Roster()
    _ = roster.add(nails)
    _ = roster.add(protein)
    for commitment in [nails, protein] {
        let shifted = roster.shift(commitment, from: date(2026, 8, 30), to: date(2026, 8, 31))
        #expect(shifted)
    }
    let landing = date(2026, 8, 31)
    let later = date(2026, 9, 4)
    let place = freshPlace()
    let store = try RecordStore(at: place)
    try store.add(Tick(roster.commitments[0], on: landing)!)
    try store.add(Tick(roster.commitments[0], on: later)!)
    try store.add(Addition(35, for: roster.commitments[1], on: later)!)

    let reopened = try RecordStore(at: place)

    #expect(reopened.history.isKept(roster.commitments[0], on: landing))
    #expect(reopened.history.isKept(roster.commitments[0], on: later))
    #expect(reopened.history.total(for: roster.commitments[1], on: later) == 35)
}

/// A form-8 store holding one tick of "Nails" on `recorded`, kept beside the given shift days.
private func nailsTickJSON(
    version: Int = 8, gym: Bool = false, recorded: (month: Int, day: Int),
    from: (month: Int, day: Int), to: (month: Int, day: Int)?
) -> Data {
    func day(_ d: (month: Int, day: Int)) -> String {
        #"{ "year": 2026, "month": \#(d.month), "day": \#(d.day) }"#
    }
    let landing = to.map { #","shiftedTo": \#(day($0))"# } ?? ""
    return Data(
        """
        {
          "version": \(version),
          "ticks": [
            {
              "commitment": {
                "name": "\(gym ? "Gym" : "Nails")",
                "keptFrom": { "year": 2026, "month": \(gym ? 1 : 8), "day": \(gym ? 1 : 6) },
                "schedule": \(gym
                    ? #"{ "weekdays": ["monday", "wednesday", "saturday"] }"#
                    : #"{ "everyNDays": 4, "from": { "year": 2026, "month": 8, "day": 6 } }"#),
                "kind": { "tick": {} },
                "identity": "22222222-2222-2222-2222-222222222222",
                "shiftedFrom": \(day(from))\(landing)
              },
              "date": \(day(recorded))
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

@Test("a store holding a record beside an every-N-days shift that could not be one is refused")
func aStoreHoldingARecordBesideAnEveryNDaysShiftThatCouldNotBeOneIsRefused() throws {
    try expectNotAStore(nailsTickJSON(recorded: (9, 4), from: (8, 26), to: (8, 31)))
    try expectNotAStore(nailsTickJSON(recorded: (9, 3), from: (9, 4), to: (9, 5)))
    try expectNotAStore(nailsTickJSON(gym: true, recorded: (9, 2), from: (8, 31), to: (9, 1)))

    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try nailsTickJSON(recorded: (9, 4), from: (8, 30), to: (8, 31)).write(to: place)
    let store = try RecordStore(at: place)
    let nails = Commitment(
        identity: Commitment.Identity("22222222-2222-2222-2222-222222222222")!, name: "Nails",
        schedule: .everyNDays(DayInterval(days: 4)!, from: date(2026, 8, 6)),
        keptFrom: date(2026, 8, 6), kind: .tick, shifts: [date(2026, 8, 30): date(2026, 8, 31)])!
    #expect(store.history.isKept(nails, on: date(2026, 9, 4)))
}

@Test("a store whose shape and declared form disagree about the day a shift put a due day on is refused")
func aStoreWhoseShapeAndDeclaredFormDisagreeAboutTheDayAShiftPutADueDayOnIsRefused() throws {
    try expectNotAStore(nailsTickJSON(version: 7, recorded: (9, 4), from: (8, 30), to: (8, 31)))
}
