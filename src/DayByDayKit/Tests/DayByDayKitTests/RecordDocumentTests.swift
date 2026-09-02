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
