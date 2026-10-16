import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private let januaryFirst = date(2026, 1, 1)
private let monday12 = date(2026, 10, 12)
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

private func commitment(
    _ name: String, _ schedule: Schedule = everyDay, keptFrom: CalendarDate = januaryFirst,
    kind: Commitment.Kind = .tick
) -> Commitment {
    Commitment(name: name, schedule: schedule, keptFrom: keptFrom, kind: kind)!
}

private func nails() -> Commitment {
    commitment(
        "Nails", .everyNDays(DayInterval(days: 3)!, from: date(2026, 10, 1)),
        keptFrom: date(2026, 10, 1))
}

private func takeOn(_ commitments: [Commitment], at places: Places) throws {
    let store = try RosterStore(at: places.roster)
    for commitment in commitments {
        try store.add(commitment)
    }
}

@MainActor
private func screen(_ places: Places, asOf day: CalendarDate = monday12) -> CommitmentsScreen {
    CommitmentsScreen(
        asOf: day, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
}

@MainActor
private func rows(on day: CalendarDate, at places: Places) -> [DayView.Row] {
    DayScreen(
        startingFrom: [], asOf: day, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs
    ).dayView.rows
}

private func isDue(_ name: String, on day: CalendarDate, in roster: Roster) -> Bool {
    roster.groups(on: day).flatMap(\.commitments).contains {
        $0.name == name && $0.isDue(on: day)
    }
}

/// The commitment named `name` as the roster at `places` reads it on `day`, days away over it
/// counted again: the commitment a tick on that day is kept for.
private func read(_ name: String, on day: CalendarDate, at places: Places) throws -> Commitment {
    try #require(
        try RosterStore(at: places.roster).roster.groups(on: day).flatMap(\.commitments)
            .first { $0.name == name })
}

@MainActor
@Test("a day under days away holding a number, a note, an addition or a decline keeps its row")
func aDayUnderDaysAwayHoldingANumberANoteAnAdditionOrADeclineKeepsItsRow() throws {
    let places = Places()
    let weight = commitment("Weight", kind: .number(range: Commitment.Range(lowest: 40, highest: 150)!))
    let journal = commitment("Journal", kind: .note)
    let water = commitment("Water", kind: .total(target: Commitment.Target(120)!))
    let creatine = commitment("Creatine")
    try takeOn([weight, journal, water, creatine], at: places)
    let record = try RecordStore(at: places.record)
    try record.add(Number(70.5, for: weight, on: monday12)!)
    try record.add(Note("Slept badly", for: journal, on: monday12)!)
    try record.add(Addition(30, for: water, on: monday12)!)
    try record.add(Decline(for: creatine, on: monday12, reason: nil)!)
    let commitments = screen(places)

    let refusal = commitments.sayDaysAway(
        named: "", from: monday12, through: date(2026, 10, 14), over: [weight, journal, water, creatine])

    #expect(refusal == nil)
    #expect(rows(on: monday12, at: places).map(\.name) == ["Weight", "Journal", "Water", "Creatine"])
    #expect(rows(on: date(2026, 10, 13), at: places).isEmpty)
}

@MainActor
@Test(
    "days away said over past days are refused where the every-N-days count begun again after them leaves a recorded day not due, naming it and the day"
)
func daysAwaySaidOverPastDaysAreRefusedWhereTheEveryNDaysCountBegunAgainAfterThemLeavesARecordedDayNotDueNamingItAndTheDay()
    throws
{
    let places = Places()
    let nails = nails()
    let gym = commitment("Gym")
    try takeOn([nails, gym], at: places)
    let tuesday13 = date(2026, 10, 13)
    try RecordStore(at: places.record).add(Tick(nails, on: tuesday13)!)
    let commitments = screen(places, asOf: date(2026, 10, 14))
    let before = try Data(contentsOf: places.roster)

    let refused = commitments.sayDaysAway(
        named: "", from: date(2026, 10, 8), through: date(2026, 10, 8), over: [gym, nails])

    #expect(refused == .recordedDayLeftNotDue(nails, tuesday13))
    #expect(commitments.daysAway.isEmpty)
    #expect(commitments.pastDaysAway.isEmpty)
    #expect(try Data(contentsOf: places.roster) == before)
    let kept = commitments.sayDaysAway(
        named: "", from: date(2026, 10, 8), through: date(2026, 10, 9), over: [gym, nails])
    #expect(kept == nil)
    #expect(rows(on: tuesday13, at: places).filter { $0.name == "Nails" }.map(\.isKept) == [true])
}

@MainActor
@Test(
    "days away whose removal would leave a recorded day not due on the count running on through them are refused and stay listed, naming it and the day"
)
func daysAwayWhoseRemovalWouldLeaveARecordedDayNotDueOnTheCountRunningOnThroughThemAreRefusedAndStayListedNamingItAndTheDay()
    throws
{
    let places = Places()
    let nails = nails()
    try takeOn([nails], at: places)
    let commitments = screen(places)
    #expect(
        commitments.sayDaysAway(
            named: "Sick", from: date(2026, 10, 5), through: date(2026, 10, 7), over: [nails]) == nil)
    let record = try RecordStore(at: places.record)
    try record.add(Tick(read("Nails", on: date(2026, 10, 8), at: places), on: date(2026, 10, 8))!)
    try record.add(Tick(read("Nails", on: date(2026, 10, 11), at: places), on: date(2026, 10, 11))!)
    let before = try Data(contentsOf: places.roster)
    let later = screen(places)

    later.askToRemove(try #require(later.pastDaysAway.first { $0.title == "Sick" }))
    let refused = later.confirmRemovingDaysAway()

    #expect(refused == .recordedDayLeftNotDue(nails, date(2026, 10, 8)))
    #expect(later.pastDaysAway.map(\.title) == ["Sick"])
    #expect(later.daysAwayAwaitingRemoval == nil)
    #expect(try Data(contentsOf: places.roster) == before)
    #expect(rows(on: date(2026, 10, 11), at: places).map(\.name) == ["Nails"])
    #expect(rows(on: date(2026, 10, 11), at: places).map(\.isKept) == [true])
}

@MainActor
@Test(
    "days away changed, or a commitment unticked from them, are refused where the every-N-days count begun again on another day leaves a recorded day not due"
)
func daysAwayChangedOrACommitmentUntickedFromThemAreRefusedWhereTheEveryNDaysCountBegunAgainOnAnotherDayLeavesARecordedDayNotDue()
    throws
{
    let places = Places()
    let nails = nails()
    let gym = commitment("Gym")
    try takeOn([nails, gym], at: places)
    let commitments = screen(places)
    #expect(
        commitments.sayDaysAway(
            named: "Sick", from: date(2026, 10, 5), through: date(2026, 10, 7), over: [nails, gym])
            == nil)
    let sunday11 = date(2026, 10, 11)
    try RecordStore(at: places.record).add(
        Tick(read("Nails", on: sunday11, at: places), on: sunday11)!)
    let later = screen(places)
    let sick = try #require(later.pastDaysAway.first)

    let shorter = later.changeDaysAway(
        sick, named: "Sick", from: date(2026, 10, 5), through: date(2026, 10, 8), over: [nails, gym])
    let unticked = later.changeDaysAway(
        sick, named: "Sick", from: date(2026, 10, 5), through: date(2026, 10, 7), over: [gym])
    let longer = later.changeDaysAway(
        sick, named: "Sick", from: date(2026, 10, 5), through: date(2026, 10, 10), over: [nails, gym])

    #expect(shorter == .recordedDayLeftNotDue(nails, sunday11))
    #expect(unticked == .recordedDayLeftNotDue(nails, sunday11))
    #expect(longer == nil)
    let listed = try #require(later.pastDaysAway.first)
    #expect(listed.title == "Sick")
    #expect(listed.daysInWords == "Mon 5 Oct – Sat 10 Oct")
    #expect(listed.commitments.map(\.name) == ["Nails", "Gym"])
    let kept = try RosterStore(at: places.roster).roster
    #expect(isDue("Nails", on: sunday11, in: kept))
    #expect(isDue("Nails", on: date(2026, 10, 14), in: kept))
    #expect(!isDue("Nails", on: date(2026, 10, 8), in: kept))
}

@MainActor
@Test(
    "days away that would put one recorded day under them and leave another not due are refused naming the day put under them"
)
func daysAwayThatWouldPutOneRecordedDayUnderThemAndLeaveAnotherNotDueAreRefusedNamingTheDayPutUnderThem()
    throws
{
    let places = Places()
    let nails = nails()
    let gym = commitment("Gym")
    try takeOn([nails, gym], at: places)
    let commitments = screen(places)
    #expect(
        commitments.sayDaysAway(
            named: "Sick", from: date(2026, 10, 5), through: date(2026, 10, 7), over: [nails, gym])
            == nil)
    let thursday8 = date(2026, 10, 8)
    let record = try RecordStore(at: places.record)
    try record.add(Tick(read("Nails", on: date(2026, 10, 11), at: places), on: date(2026, 10, 11))!)
    try record.add(Tick(gym, on: thursday8)!)
    let later = screen(places)

    let refused = later.changeDaysAway(
        try #require(later.pastDaysAway.first), named: "Sick", from: date(2026, 10, 5),
        through: thursday8, over: [nails, gym])

    #expect(refused == .recordOnDaysAway(gym, thursday8))
    #expect(later.pastDaysAway.map(\.title) == ["Sick"])
    #expect(later.pastDaysAway.first?.daysInWords == "Mon 5 Oct – Wed 7 Oct")
}

/// Not a scenario: the rule of the requirement's "a commitment ticked onto or unticked from them
/// included", for the tick. Pins a survivor of the tenth review.
@MainActor
@Test(
    "a commitment ticked onto days away is refused where the count begun again leaves its recorded day not due"
)
func aCommitmentTickedOntoDaysAwayIsRefusedWhereTheCountBegunAgainLeavesItsRecordedDayNotDue()
    throws
{
    let places = Places()
    let nails = nails()
    let gym = commitment("Gym")
    try takeOn([nails, gym], at: places)
    let tuesday13 = date(2026, 10, 13)
    try RecordStore(at: places.record).add(Tick(nails, on: tuesday13)!)
    let commitments = screen(places, asOf: date(2026, 10, 14))
    #expect(
        commitments.sayDaysAway(
            named: "Sick", from: date(2026, 10, 8), through: date(2026, 10, 8), over: [gym]) == nil)
    let sick = try #require(commitments.pastDaysAway.first)
    let before = try Data(contentsOf: places.roster)

    let refused = commitments.changeDaysAway(
        sick, named: "Sick", from: date(2026, 10, 8), through: date(2026, 10, 8),
        over: [gym, nails])

    #expect(refused == .recordedDayLeftNotDue(nails, tuesday13))
    #expect(try Data(contentsOf: places.roster) == before)
    #expect(commitments.pastDaysAway.first?.commitments.map(\.name) == ["Gym"])
}

@MainActor
@Test(
    "days away said that put one recorded day under them and leave another not due are refused naming the day put under them"
)
func daysAwaySaidThatPutOneRecordedDayUnderThemAndLeaveAnotherNotDueAreRefusedNamingTheDayPutUnderThem()
    throws
{
    let places = Places()
    let nails = nails()
    let gym = commitment("Gym")
    try takeOn([nails, gym], at: places)
    let thursday8 = date(2026, 10, 8)
    let record = try RecordStore(at: places.record)
    try record.add(Tick(nails, on: date(2026, 10, 13))!)
    try record.add(Tick(gym, on: thursday8)!)
    let commitments = screen(places, asOf: date(2026, 10, 14))
    let before = try Data(contentsOf: places.roster)

    let refused = commitments.sayDaysAway(
        named: "", from: thursday8, through: thursday8, over: [nails, gym])

    #expect(refused == .recordOnDaysAway(gym, thursday8))
    #expect(try Data(contentsOf: places.roster) == before)
    #expect(commitments.pastDaysAway.isEmpty)
}

@MainActor
@Test(
    "a refusal for a recorded day left not due names the first such commitment the roster holds")
func aRefusalForARecordedDayLeftNotDueNamesTheFirstSuchCommitmentTheRosterHolds() throws {
    let places = Places()
    let nails = nails()
    let hair = commitment(
        "Hair", .everyNDays(DayInterval(days: 3)!, from: date(2026, 10, 1)),
        keptFrom: date(2026, 10, 1))
    try takeOn([nails, hair], at: places)
    let tuesday13 = date(2026, 10, 13)
    let record = try RecordStore(at: places.record)
    try record.add(Tick(hair, on: tuesday13)!)
    try record.add(Tick(nails, on: tuesday13)!)
    let commitments = screen(places, asOf: date(2026, 10, 14))

    let refused = commitments.sayDaysAway(
        named: "", from: date(2026, 10, 8), through: date(2026, 10, 8), over: [hair, nails])

    #expect(refused == .recordedDayLeftNotDue(nails, tuesday13))
}

@MainActor
@Test("a recorded day not due before days away is not judged as left not due by them")
func aRecordedDayNotDueBeforeDaysAwayIsNotJudgedAsLeftNotDueByThem() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    #expect(
        screen(places, asOf: date(2026, 10, 14)).sayDaysAway(
            named: "Trip", from: date(2026, 10, 8), through: date(2026, 10, 10), over: [gym, run])
            == nil)
    stopKeeping(gym, on: screen(places, asOf: date(2026, 10, 9)))
    try RecordStore(at: places.record).add(Tick(gym, on: monday12)!)
    let later = screen(places, asOf: date(2026, 10, 14))
    let trip = try #require(later.pastDaysAway.first)
    #expect(later.stopped.map(\.name) == ["Gym"])
    #expect(trip.commitments.map(\.name) == ["Gym", "Run"])

    let refused = later.changeDaysAway(
        trip, named: "Trip", from: date(2026, 10, 8), through: date(2026, 10, 10),
        over: [gym, run])

    #expect(refused == nil)
    #expect(later.pastDaysAway.first?.commitments.map(\.name) == ["Gym", "Run"])
}

@MainActor
@Test("a refusal for a recorded day left not due leaves no days away awaiting removal")
func aRefusalForARecordedDayLeftNotDueLeavesNoDaysAwayAwaitingRemoval() throws {
    let places = Places()
    let nails = nails()
    let gym = commitment("Gym")
    try takeOn([nails, gym], at: places)
    try RecordStore(at: places.record).add(Tick(nails, on: date(2026, 10, 13))!)
    let commitments = screen(places, asOf: date(2026, 10, 14))
    #expect(
        commitments.sayDaysAway(
            named: "Trip", from: date(2026, 10, 5), through: date(2026, 10, 5), over: [gym]) == nil)
    let trip = try #require(commitments.pastDaysAway.first)

    commitments.askToRemove(trip)
    let said = commitments.sayDaysAway(
        named: "", from: date(2026, 10, 8), through: date(2026, 10, 8), over: [gym, nails])
    #expect(said == .recordedDayLeftNotDue(nails, date(2026, 10, 13)))
    #expect(commitments.daysAwayAwaitingRemoval == nil)

    commitments.askToRemove(trip)
    let changed = commitments.changeDaysAway(
        trip, named: "Trip", from: date(2026, 10, 8), through: date(2026, 10, 8), over: [gym, nails])
    #expect(changed == .recordedDayLeftNotDue(nails, date(2026, 10, 13)))
    #expect(commitments.daysAwayAwaitingRemoval == nil)
}

@MainActor
private func stopKeeping(_ commitment: Commitment, on screen: CommitmentsScreen) {
    screen.askToStopKeeping(commitment)
    screen.confirmStopKeeping()
}
