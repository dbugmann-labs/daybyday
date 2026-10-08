import Foundation
import Testing
@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private func nails(shiftedFrom origin: CalendarDate, to landing: CalendarDate) -> Commitment {
    let plain = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: date(2026, 8, 6)),
        keptFrom: date(2026, 8, 6))!
    return Commitment(plain, shifts: [origin: landing])
}

@Test("a commitment record beside a later day of a shifted count writes both days of the shift and reads them back")
func aCommitmentRecordBesideALaterDayOfAShiftedCountWritesBothDaysOfTheShift() throws {
    let shifted = nails(shiftedFrom: date(2026, 8, 30), to: date(2026, 8, 31))

    let record = CommitmentRecord(shifted, recordedOn: date(2026, 9, 4))
    #expect(record.shiftedFrom == DateRecord(date(2026, 8, 30)))
    #expect(record.shiftedTo == DateRecord(date(2026, 8, 31)))

    let decoded = try JSONDecoder().decode(
        CommitmentRecord.self, from: JSONEncoder().encode(record))
    let formed = try #require(decoded.commitment(recordedOn: date(2026, 9, 4)))
    #expect(formed.shifts == [date(2026, 8, 30): date(2026, 8, 31)])
}

@Test("a commitment record on the day a shift put a due day on keeps the day it came from alone, and bare drops both")
func aCommitmentRecordOnTheLandingKeepsTheDayItCameFromAlone() {
    let shifted = nails(shiftedFrom: date(2026, 8, 30), to: date(2026, 8, 31))

    let onLanding = CommitmentRecord(shifted, recordedOn: date(2026, 8, 31))
    #expect(onLanding.shiftedFrom == DateRecord(date(2026, 8, 30)))
    #expect(onLanding.shiftedTo == nil)

    let beforeIt = CommitmentRecord(shifted, recordedOn: date(2026, 8, 26))
    #expect(beforeIt.shiftedFrom == nil)
    #expect(beforeIt.shiftedTo == nil)

    let bare = CommitmentRecord.bare(shifted)
    #expect(bare.shiftedFrom == nil)
    #expect(bare.shiftedTo == nil)
}
