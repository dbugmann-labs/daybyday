import Foundation
import Testing
@testable import DayByDayKit

/// Below `RecordStore`'s public seam: exercises `ScheduleRecord`'s internal conversion directly,
/// so it traces to nothing in `specs/record/spec.md` (AGENTS.md rule 3 — free-form unit tests
/// below the seam). `RecordStoreTests.swift`'s scenario 2.6 already round-trips a weekday
/// schedule end to end, but only through three of the seven days; this test is the one place all
/// seven are checked, so `name(for:)` and `weekday(named:)` cannot silently disagree on a day
/// scenario 2.6 never names.
@Test("every weekday round-trips through its ScheduleRecord wire name")
func everyWeekdayRoundTripsThroughItsScheduleRecordWireName() {
    let weekdaysAndWireNames: [(Weekday, String)] = [
        (.monday, "monday"),
        (.tuesday, "tuesday"),
        (.wednesday, "wednesday"),
        (.thursday, "thursday"),
        (.friday, "friday"),
        (.saturday, "saturday"),
        (.sunday, "sunday"),
    ]

    for (weekday, wireName) in weekdaysAndWireNames {
        let record = ScheduleRecord(.weekdays([weekday]))
        #expect(record == .weekdays([wireName]))
        #expect(record.schedule() == .weekdays([weekday]))
    }
}

/// Below `RecordStore`'s public seam: exercises `RecordDocument.init(_:_:)`'s sort directly, so
/// it traces to nothing in `specs/record/spec.md` (AGENTS.md rule 3). Two distinct commitments —
/// same name, kept-from day, date and schedule, different `kind` — are the one way two numbers
/// can tie on every field `isOrderedBefore` checked before `kind` was added as the final
/// tiebreaker; without it, which one comes first depends on `Dictionary`'s per-process iteration
/// order, so two runs writing the same two numbers could emit different bytes.
@Test("two numbers alike in name, kept-from day, date and schedule sort by kind")
func twoNumbersAlikeInNameKeptFromDayDateAndScheduleSortByKind() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let plain = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!
    let ranged = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!

    let numbers: [RecordedDay: Decimal] = [
        RecordedDay(commitment: ranged, date: monday): 70.5,
        RecordedDay(commitment: plain, date: monday): 71,
    ]

    let document = RecordDocument([], numbers, [:])

    #expect(document.numbers?.map(\.number) == [71, 70.5])
}
