import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private let januaryFirst = date(2026, 1, 1)
private let everyDay = Schedule.weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])

private struct Places {
    let roster: URL
    let record: URL
    let oneOffs: URL

    init() {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        roster = directory.appendingPathComponent("roster.json")
        record = directory.appendingPathComponent("record.json")
        oneOffs = directory.appendingPathComponent("one-offs.json")
    }
}

private func commitment(_ name: String, _ schedule: Schedule = everyDay) -> Commitment {
    Commitment(name: name, schedule: schedule, keptFrom: januaryFirst)!
}

@MainActor
private func screen(_ places: Places, asOf day: CalendarDate) -> CommitmentsScreen {
    CommitmentsScreen(
        asOf: day, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
}

private func isDue(_ name: String, on day: CalendarDate, in roster: Roster) -> Bool {
    roster.groups(on: day).flatMap(\.commitments).contains { $0.name == name && $0.isDue(on: day) }
}

/// Pins "…save that where that day is no later than the day after its stop, the take-up SHALL be the day after
/// their last day when it was made" (*A commitments screen takes a commitment up again on a day inside days away
/// over it from the day after their last day*) at its boundary: days away moved to end on the day the stop kept
/// the commitment until, whose day after is the day after the stop, as the scenario moving them before the stop
/// does not reach.
@MainActor
@Test("days away moved to end on the day a commitment was stopped keep its take-up on the day back it was taken up for")
func daysAwayMovedToEndOnTheDayACommitmentWasStoppedKeepItsTakeUpOnTheDayBackItWasTakenUpFor() throws {
    let places = Places()
    let store = try RosterStore(at: places.roster)
    try store.add(commitment("Gym"))
    try store.add(commitment("Run"))
    let setUp = screen(places, asOf: date(2026, 10, 4))
    setUp.sayDaysAway(
        named: "Flu", from: date(2026, 10, 9), through: date(2026, 10, 11), over: setUp.kept)

    let stopping = screen(places, asOf: date(2026, 10, 9))
    stopping.askToStopKeeping(try #require(stopping.kept.first { $0.name == "Gym" }))
    #expect(stopping.confirmStopKeeping() == nil)
    let takingUp = screen(places, asOf: date(2026, 10, 10))
    #expect(takingUp.keepAgain(try #require(takingUp.stopped.first { $0.name == "Gym" })) == nil)
    let moving = screen(places, asOf: date(2026, 10, 10))
    let flu = try #require(moving.daysAway.first)
    let moved = moving.changeDaysAway(
        flu, named: "Flu", from: date(2026, 10, 5), through: date(2026, 10, 8), over: flu.commitments)

    #expect(moved == nil)
    let roster = try RosterStore(at: places.roster).roster
    #expect(isDue("Gym", on: date(2026, 10, 4), in: roster))
    for day in 5...11 {
        #expect(!isDue("Gym", on: date(2026, 10, day), in: roster), "Gym is not due on 10/\(day)")
    }
    #expect(isDue("Gym", on: date(2026, 10, 12), in: roster))
    #expect(isDue("Run", on: date(2026, 10, 9), in: roster))
    #expect(isDue("Run", on: date(2026, 10, 12), in: roster))
}

/// Pins "The commitment SHALL be taken up again on the day after the new last day on the rhythm, range and target
/// it holds on the later of that day and the day after the old last day" (*A change of days away gives back the
/// days a commitment no longer has under them and takes those it newly has*) where the rhythm changed after the
/// days away ended: the days given back after the new last day are kept on the rhythm held after the old one, not
/// on the one held before the old first day.
@MainActor
@Test("days away moved wholly before their old days give back what they hid on the rhythm the commitment holds after them")
func daysAwayMovedWhollyBeforeTheirOldDaysGiveBackWhatTheyHidOnTheRhythmTheCommitmentHoldsAfterThem() throws {
    let places = Places()
    let store = try RosterStore(at: places.roster)
    try store.add(commitment("Gym"))
    let setUp = screen(places, asOf: date(2026, 10, 7))
    setUp.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 10), through: date(2026, 10, 17), over: setUp.kept)

    let editing = screen(places, asOf: date(2026, 10, 18))
    let gym = try #require(editing.kept.first)
    let made = try #require(editing.whatItIsMadeOf(gym))
    let mondaysWednesdaysFridays = Rhythm(Schedule.weekdays([.monday, .wednesday, .friday]))
    #expect(
        editing.change(
            gym, toName: "Gym", on: mondaysWednesdaysFridays, keptFrom: made.keptFrom, under: nil) == nil)
    let moving = screen(places, asOf: date(2026, 10, 18))
    let mallorca = try #require(moving.pastDaysAway.first)
    let moved = moving.changeDaysAway(
        mallorca, named: "Mallorca", from: date(2026, 10, 1), through: date(2026, 10, 1),
        over: mallorca.commitments)

    #expect(moved == nil)
    let roster = try RosterStore(at: places.roster).roster
    #expect(!isDue("Gym", on: date(2026, 10, 1), in: roster))
    for day in 2...9 {
        #expect(isDue("Gym", on: date(2026, 10, day), in: roster), "Gym is due on 10/\(day)")
    }
    // Monday 12, Wednesday 14 and Friday 16 October, and no other day of the days given back.
    for day in 10...17 {
        let due = [12, 14, 16].contains(day)
        #expect(isDue("Gym", on: date(2026, 10, day), in: roster) == due, "Gym on 10/\(day)")
    }
}
