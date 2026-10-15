import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

/// Not a scenario of the delta: an orphaned record is carried back to the one commitment that could
/// have held it, judged through the read days away leave, as `main` judged it with the gap cut.
@MainActor
@Test("an orphaned record on a day only the count begun again after days away makes due is carried back")
func anOrphanedRecordOnADayOnlyTheCountBegunAgainAfterDaysAwayMakesDueIsCarriedBack() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let rosterPlace = directory.appendingPathComponent("roster.json")
    let recordPlace = directory.appendingPathComponent("record.json")
    let oneOffPlace = directory.appendingPathComponent("one-offs.json")
    let thursday1 = date(2026, 10, 1)
    let monday12 = date(2026, 10, 12)
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 3)!, from: thursday1),
        keptFrom: thursday1)!
    try RosterStore(at: rosterPlace).add(nails)
    let opened = CommitmentsScreen(
        asOf: date(2026, 10, 9), keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace,
        keepingOneOffsAt: oneOffPlace)
    #expect(
        opened.sayDaysAway(
            named: "Sick", from: date(2026, 10, 8), through: date(2026, 10, 8), over: [nails])
            == nil)
    let orphan = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 3)!, from: date(2026, 10, 3)),
        keptFrom: date(2026, 10, 3))!
    try RecordStore(at: recordPlace).add(Tick(orphan, on: monday12)!)

    let reopened = CommitmentsScreen(
        asOf: date(2026, 10, 14), keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace,
        keepingOneOffsAt: oneOffPlace)

    #expect(!reopened.recordsBelongToNoCommitment)
    let rows = DayScreen(
        startingFrom: [], asOf: monday12, keepingRecordAt: recordPlace, keepingRosterAt: rosterPlace,
        keepingOneOffsAt: oneOffPlace
    ).dayView.rows
    #expect(rows.map(\.name) == ["Nails"])
    #expect(rows.map(\.isKept) == [true])
}
