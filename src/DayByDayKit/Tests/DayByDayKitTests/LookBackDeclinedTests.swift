import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private func places() -> (roster: URL, record: URL) {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    return (
        directory.appendingPathComponent("roster.json"),
        directory.appendingPathComponent("record.json")
    )
}

private let monWedSat = Schedule.weekdays([.monday, .wednesday, .saturday])

private let februaryDueDays = [4, 7, 9, 11, 14, 16, 18, 21, 23, 25, 28].map { date(2026, 2, $0) }

/// The Gym of the first scenarios: Mon/Wed/Sat from 1 January 2026, kept on eleven days of
/// February and declined on 7 January, 4 March, 7 March and 9 March 2026.
@MainActor
private func declinedGymScreen() throws -> (screen: CommitmentsScreen, gym: Commitment) {
    let held = places()
    let gym = Commitment(name: "Gym", schedule: monWedSat, keptFrom: date(2026, 1, 1))!
    try RosterStore(at: held.roster).add(gym)
    let record = try RecordStore(at: held.record)
    for day in februaryDueDays {
        try record.add(Tick(gym, on: day)!)
    }
    for day in [date(2026, 1, 7), date(2026, 3, 4), date(2026, 3, 7), date(2026, 3, 9)] {
        try record.add(Decline(for: gym, on: day, reason: nil)!)
    }
    return (
        CommitmentsScreen(
            asOf: date(2026, 3, 15), keepingRosterAt: held.roster, keepingRecordAt: held.record),
        gym
    )
}

@MainActor
@Test(
    "a look-back counts every day declined since the day it is kept from, and its whole still counts them due and unkept"
)
func aLookBackCountsEveryDayDeclinedSinceTheDayItIsKeptFromAndItsWholeStillCountsThemDueAndUnkept()
    throws
{
    let (screen, gym) = try declinedGymScreen()

    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.declinedInWords == "4")
    #expect(lookBack?.whole == "11/31")
}
