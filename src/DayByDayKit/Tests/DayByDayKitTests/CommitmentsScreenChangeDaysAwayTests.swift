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
private let gymSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])

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

private func isDue(_ name: String, on day: CalendarDate, in roster: Roster) -> Bool {
    roster.groups(on: day).flatMap(\.commitments).contains {
        $0.name == name && $0.isDue(on: day)
    }
}

private func roster(at places: Places) throws -> Roster {
    try RosterStore(at: places.roster).roster
}

@MainActor
@Test("days away renamed keep their days and commitments and stay the same days away")
func daysAwayRenamedKeepTheirDaysAndCommitmentsAndStayTheSameDaysAway() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, run])
    let before = try #require(commitments.daysAway.first)

    let renamed = commitments.changeDaysAway(
        before, named: " Majorca ", from: date(2026, 10, 13), through: date(2026, 10, 18),
        over: [gym, run])

    #expect(renamed == nil)
    let after = try #require(commitments.daysAway.first)
    #expect(commitments.daysAway.count == 1)
    #expect(after.title == "Majorca")
    #expect(after.daysInWords == "Tue 13 Oct – Sun 18 Oct")
    #expect(after.commitments.map(\.name) == ["Gym", "Run"])
    #expect(after == before)

    commitments.changeDaysAway(
        after, named: "  ", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, run])
    #expect(commitments.daysAway.map(\.title) == ["Away"])
    let kept = try roster(at: places)
    for name in ["Gym", "Run"] {
        #expect(isDue(name, on: date(2026, 10, 19), in: kept))
        for day in 13...18 {
            #expect(!isDue(name, on: date(2026, 10, day), in: kept))
        }
    }
}

@MainActor
@Test("a change ending before it begins, or over nothing, is refused and keeps nothing")
func aChangeEndingBeforeItBeginsOrOverNothingIsRefusedAndKeepsNothing() throws {
    let places = Places()
    let gym = commitment("Gym")
    try takeOn([gym], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    let said = try #require(commitments.daysAway.first)
    let before = try Data(contentsOf: places.roster)

    let backwards = commitments.changeDaysAway(
        said, named: "Mallorca", from: date(2026, 10, 14), through: date(2026, 10, 13), over: [gym])
    let overNothing = commitments.changeDaysAway(
        said, named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [])

    #expect(backwards == .lastDayBeforeFirstDay)
    #expect(overNothing == .overNoCommitment)
    #expect(commitments.daysAway.map(\.title) == ["Mallorca"])
    #expect(commitments.daysAway.map(\.daysInWords) == ["Tue 13 Oct – Sun 18 Oct"])
    #expect(commitments.daysAway.first?.commitments.map(\.name) == ["Gym"])
    #expect(try Data(contentsOf: places.roster) == before)
}

@MainActor
@Test("a change is judged against other days away and never against the days away changed")
func aChangeIsJudgedAgainstOtherDaysAwayAndNeverAgainstTheDaysAwayChanged() throws {
    let places = Places()
    let gym = commitment("Gym")
    try takeOn([gym], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    commitments.sayDaysAway(
        named: "Lisbon", from: date(2026, 10, 20), through: date(2026, 10, 21), over: [gym])
    let mallorca = try #require(commitments.daysAway.first { $0.title == "Mallorca" })

    let within = commitments.changeDaysAway(
        mallorca, named: "Mallorca", from: date(2026, 10, 14), through: date(2026, 10, 19),
        over: [gym])
    let clash = commitments.changeDaysAway(
        mallorca, named: "Mallorca", from: date(2026, 10, 14), through: date(2026, 10, 20),
        over: [gym])

    #expect(within == nil)
    guard case .overlapsDaysAway(let named)? = clash else {
        Issue.record("expected an overlap, got \(String(describing: clash))")
        return
    }
    #expect(named.title == "Lisbon")
    #expect(commitments.daysAway.first { $0.title == "Mallorca" }?.daysInWords == "Wed 14 Oct – Mon 19 Oct")
}

@MainActor
@Test(
    "a commitment picked by a change is refused where it is kept from their first day or later or has a shift on one of their days, naming it"
)
func aCommitmentPickedByAChangeIsRefusedWhereItIsKeptFromTheirFirstDayOrLaterOrHasAShiftOnOneOfTheirDaysNamingIt()
    throws
{
    let places = Places()
    let gym = commitment("Gym")
    let swim = commitment("Swim", gymSchedule)
    let yoga = commitment("Yoga", keptFrom: date(2026, 10, 14))
    try takeOn([gym, swim, yoga], at: places)
    let store = try RosterStore(at: places.roster)
    #expect(try store.shift(swim, from: monday12, to: date(2026, 10, 13)))
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    let mallorca = try #require(commitments.daysAway.first)

    let later = commitments.changeDaysAway(
        mallorca, named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18),
        over: [gym, yoga])
    let shifted = commitments.changeDaysAway(
        mallorca, named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18),
        over: [gym, swim])

    #expect(later == .keptFromFirstDayOrLater("Yoga"))
    #expect(shifted == .shiftOnDaysAway("Swim"))
    #expect(commitments.daysAway.first?.commitments.map(\.name) == ["Gym"])
}

@MainActor
@Test(
    "a change asked of days away it does not list, or over a stopped commitment they are not over, does nothing"
)
func aChangeAskedOfDaysAwayItDoesNotListOrOverAStoppedCommitmentTheyAreNotOverDoesNothing() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    let store = try RosterStore(at: places.roster)
    #expect(try store.retire(run, keptUntil: date(2026, 10, 11)))
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    let mallorca = try #require(commitments.daysAway.first)
    let read = try Data(contentsOf: places.roster)

    let overStopped = commitments.changeDaysAway(
        mallorca, named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18),
        over: [gym, run])

    #expect(overStopped == nil)
    #expect(commitments.daysAway.first?.commitments.map(\.name) == ["Gym"])
    #expect(try Data(contentsOf: places.roster) == read)

    commitments.askToRemove(mallorca)
    #expect(commitments.confirmRemovingDaysAway() == nil)
    let readAgain = try Data(contentsOf: places.roster)
    let unlisted = commitments.changeDaysAway(
        mallorca, named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 17),
        over: [gym])

    #expect(unlisted == nil)
    #expect(commitments.daysAway.isEmpty)
    #expect(try Data(contentsOf: places.roster) == readAgain)
}

private func setWritable(_ directory: URL, _ writable: Bool) throws {
    try FileManager.default.setAttributes(
        [.posixPermissions: writable ? 0o700 : 0o500], ofItemAtPath: directory.path)
}

@MainActor
@Test(
    "a change a commitments screen cannot keep at its roster place is refused and the days away stay as they were"
)
func aChangeACommitmentsScreenCannotKeepAtItsRosterPlaceIsRefusedAndTheDaysAwayStayAsTheyWere() throws {
    let places = Places()
    let gym = commitment("Gym")
    try takeOn([gym], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    let mallorca = try #require(commitments.daysAway.first)
    let directory = places.roster.deletingLastPathComponent()
    try setWritable(directory, false)
    defer { try? setWritable(directory, true) }

    let refusal = commitments.changeDaysAway(
        mallorca, named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 17),
        over: [gym])

    #expect(refusal == .notKept)
    #expect(commitments.daysAway.map(\.title) == ["Mallorca"])
    #expect(commitments.daysAway.map(\.daysInWords) == ["Tue 13 Oct – Sun 18 Oct"])
}

private func nails() -> Commitment {
    commitment(
        "Nails", .everyNDays(DayInterval(days: 4)!, from: date(2026, 10, 1)),
        keptFrom: date(2026, 10, 1))
}

@MainActor
@Test(
    "a last day moved later keeps commitments away through it and takes them up again the day after, an every-N-days count beginning there"
)
func aLastDayMovedLaterKeepsCommitmentsAwayThroughItAndTakesThemUpAgainTheDayAfterAnEveryNDaysCountBeginningThere()
    throws
{
    let places = Places()
    let gym = commitment("Gym")
    let nails = nails()
    try takeOn([gym, nails], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, nails])
    let mallorca = try #require(commitments.daysAway.first)

    let refusal = commitments.changeDaysAway(
        mallorca, named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 20),
        over: [gym, nails])

    #expect(refusal == nil)
    #expect(commitments.daysAway.map(\.daysInWords) == ["Tue 13 Oct – Tue 20 Oct"])
    let kept = try roster(at: places)
    #expect(isDue("Gym", on: date(2026, 10, 21), in: kept))
    #expect(!isDue("Gym", on: date(2026, 10, 19), in: kept))
    #expect(!isDue("Gym", on: date(2026, 10, 20), in: kept))
    #expect(isDue("Nails", on: date(2026, 10, 21), in: kept))
    #expect(isDue("Nails", on: date(2026, 10, 25), in: kept))
    #expect(!isDue("Nails", on: date(2026, 10, 19), in: kept))
    #expect(!isDue("Nails", on: date(2026, 10, 23), in: kept))
}

@MainActor
private func rows(on day: CalendarDate, at places: Places) -> [String] {
    DayScreen(
        startingFrom: [], asOf: day, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs
    ).dayView.rows.map(\.name)
}

@MainActor
@Test(
    "a last day moved earlier gives its days back, owed again, and takes commitments up again the day after"
)
func aLastDayMovedEarlierGivesItsDaysBackOwedAgainAndTakesCommitmentsUpAgainTheDayAfter() throws {
    let places = Places()
    let gym = commitment("Gym")
    let nails = nails()
    try takeOn([gym, nails], at: places)
    screen(places).sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, nails])
    let thursday = screen(places, asOf: date(2026, 10, 15))
    let mallorca = try #require(thursday.daysAway.first)

    let refusal = thursday.changeDaysAway(
        mallorca, named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 15),
        over: [gym, nails])

    #expect(refusal == nil)
    let kept = try roster(at: places)
    #expect(isDue("Gym", on: date(2026, 10, 16), in: kept))
    #expect(isDue("Gym", on: date(2026, 10, 17), in: kept))
    #expect(!isDue("Gym", on: date(2026, 10, 15), in: kept))
    #expect(isDue("Nails", on: date(2026, 10, 16), in: kept))
    #expect(isDue("Nails", on: date(2026, 10, 20), in: kept))
    #expect(!isDue("Nails", on: date(2026, 10, 19), in: kept))
    #expect(rows(on: date(2026, 10, 16), at: places) == ["Gym", "Nails"])
}

@MainActor
@Test(
    "a first day moved earlier takes days already gone, and moved later gives days back on the rhythm held before"
)
func aFirstDayMovedEarlierTakesDaysAlreadyGoneAndMovedLaterGivesDaysBackOnTheRhythmHeldBefore() throws {
    let places = Places()
    let gym = commitment("Gym", gymSchedule)
    try takeOn([gym], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    let mallorca = try #require(commitments.daysAway.first)

    let earlier = commitments.changeDaysAway(
        mallorca, named: "Mallorca", from: date(2026, 10, 8), through: date(2026, 10, 18), over: [gym])
    let afterEarlier = try roster(at: places)
    let later = commitments.changeDaysAway(
        mallorca, named: "Mallorca", from: date(2026, 10, 15), through: date(2026, 10, 18),
        over: [gym])
    let afterLater = try roster(at: places)

    #expect(earlier == nil)
    #expect(later == nil)
    #expect(isDue("Gym", on: date(2026, 10, 7), in: afterEarlier))
    #expect(!isDue("Gym", on: date(2026, 10, 10), in: afterEarlier))
    #expect(!isDue("Gym", on: monday12, in: afterEarlier))
    #expect(isDue("Gym", on: date(2026, 10, 10), in: afterLater))
    #expect(isDue("Gym", on: monday12, in: afterLater))
    #expect(isDue("Gym", on: date(2026, 10, 14), in: afterLater))
    #expect(!isDue("Gym", on: date(2026, 10, 13), in: afterLater))
    #expect(!isDue("Gym", on: date(2026, 10, 17), in: afterLater))
}

@MainActor
@Test(
    "a commitment changed while away is taken up on its new rhythm wherever the day back moves, and keeps it once the days away are removed"
)
func aCommitmentChangedWhileAwayIsTakenUpOnItsNewRhythmWhereverTheDayBackMovesAndKeepsItOnceTheDaysAwayAreRemoved()
    throws
{
    let places = Places()
    let gym = commitment("Gym", gymSchedule)
    try takeOn([gym], at: places)
    screen(places).sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    let thursday = screen(places, asOf: date(2026, 10, 15))
    let made = try #require(thursday.whatItIsMadeOf(gym))
    let changed = thursday.change(
        gym, toName: "Gym", on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]), keptFrom: made.keptFrom, under: nil)
    let mallorca = try #require(thursday.daysAway.first)

    let earlier = thursday.changeDaysAway(
        mallorca, named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 16),
        over: [gym])
    let afterEarlier = try roster(at: places)
    let later = thursday.changeDaysAway(
        mallorca, named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 20),
        over: [gym])
    let afterLater = try roster(at: places)
    thursday.askToRemove(mallorca)
    let removed = thursday.confirmRemovingDaysAway()
    let afterRemoval = try roster(at: places)

    #expect(changed == nil)
    #expect(earlier == nil)
    #expect(later == nil)
    #expect(removed == nil)
    #expect(isDue("Gym", on: date(2026, 10, 17), in: afterEarlier))
    #expect(isDue("Gym", on: date(2026, 10, 18), in: afterEarlier))
    #expect(!isDue("Gym", on: date(2026, 10, 15), in: afterEarlier))
    #expect(!isDue("Gym", on: date(2026, 10, 16), in: afterEarlier))
    #expect(isDue("Gym", on: date(2026, 10, 21), in: afterLater))
    #expect(isDue("Gym", on: date(2026, 10, 22), in: afterLater))
    for day in [17, 18, 19] {
        #expect(!isDue("Gym", on: date(2026, 10, day), in: afterLater))
    }
    for day in [14, 19, 22] {
        #expect(isDue("Gym", on: date(2026, 10, day), in: afterRemoval))
    }
    #expect(!isDue("Gym", on: date(2026, 10, 15), in: afterRemoval))
    #expect(!isDue("Gym", on: date(2026, 10, 20), in: afterRemoval))
}

@MainActor
@Test(
    "a commitment ticked onto days away takes its gap, and one unticked is left as though it had never been picked"
)
func aCommitmentTickedOntoDaysAwayTakesItsGapAndOneUntickedIsLeftAsThoughItHadNeverBeenPicked() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    let nails = nails()
    try takeOn([gym, run, nails], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, nails])
    let mallorca = try #require(commitments.daysAway.first)

    let refusal = commitments.changeDaysAway(
        mallorca, named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18),
        over: [gym, run])

    #expect(refusal == nil)
    #expect(commitments.daysAway.first?.commitments.map(\.name) == ["Gym", "Run"])
    let kept = try roster(at: places)
    #expect(isDue("Run", on: date(2026, 10, 19), in: kept))
    #expect(!isDue("Run", on: date(2026, 10, 15), in: kept))
    for day in [13, 17, 21] {
        #expect(isDue("Nails", on: date(2026, 10, day), in: kept))
    }
    #expect(!isDue("Nails", on: date(2026, 10, 19), in: kept))
}

@MainActor
private func keptRows(on day: CalendarDate, at places: Places) -> [String: Bool] {
    let rows = DayScreen(
        startingFrom: [], asOf: day, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs
    ).dayView.rows
    return Dictionary(uniqueKeysWithValues: rows.map { ($0.name, $0.isKept) })
}

@MainActor
@Test(
    "a commitment kept through a first day it holds a record on stays kept through it while the first day does not move"
)
func aCommitmentKeptThroughAFirstDayItHoldsARecordOnStaysKeptThroughItWhileTheFirstDayDoesNotMove()
    throws
{
    let places = Places()
    let creatine = commitment("Creatine")
    let magnesium = commitment("Magnesium")
    try takeOn([creatine, magnesium], at: places)
    try RecordStore(at: places.record).add(Tick(creatine, on: monday12)!)
    screen(places).sayDaysAway(
        named: "", from: monday12, through: date(2026, 10, 14), over: [creatine, magnesium])
    let tuesday = screen(places, asOf: date(2026, 10, 13))
    let said = try #require(tuesday.daysAway.first)

    let refusal = tuesday.changeDaysAway(
        said, named: "", from: monday12, through: date(2026, 10, 16), over: [creatine, magnesium])

    #expect(refusal == nil)
    #expect(keptRows(on: monday12, at: places) == ["Creatine": true])
    #expect(keptRows(on: date(2026, 10, 15), at: places).isEmpty)
    #expect(Set(keptRows(on: date(2026, 10, 17), at: places).keys) == ["Creatine", "Magnesium"])
}

@MainActor
@Test(
    "days away said over a day holding any record of a commitment picked are refused, naming it and the day"
)
func daysAwaySaidOverADayHoldingAnyRecordOfACommitmentPickedAreRefusedNamingItAndTheDay() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    let creatine = commitment("Creatine")
    let weight = commitment("Weight", kind: .number(range: Commitment.Range(lowest: 40, highest: 150)!))
    let journal = commitment("Journal", kind: .note)
    let water = commitment("Water", kind: .total(target: Commitment.Target(120)!))
    try takeOn([gym, run, creatine, weight, journal, water], at: places)
    try RosterStore(at: places.roster).put(run, under: "Sport")
    let record = try RecordStore(at: places.record)
    let tuesday6 = date(2026, 10, 6)
    try record.add(Tick(run, on: date(2026, 10, 5))!)
    try record.add(Tick(gym, on: tuesday6)!)
    try record.add(Tick(gym, on: date(2026, 10, 7))!)
    try record.add(Number(70.5, for: weight, on: tuesday6)!)
    try record.add(Note("Slept badly", for: journal, on: tuesday6)!)
    try record.add(Addition(30, for: water, on: tuesday6)!)
    try record.add(Decline(for: creatine, on: tuesday6, reason: nil)!)
    let commitments = screen(places)
    let before = try Data(contentsOf: places.roster)

    var refusals: [CommitmentsScreen.Refusal?] = []
    for picked in [[weight], [journal], [water], [creatine], [gym, run]] {
        refusals.append(
            commitments.sayDaysAway(
                named: "", from: date(2026, 10, 5), through: date(2026, 10, 7), over: picked))
    }

    #expect(
        refusals == [
            .recordOnDaysAway(weight, tuesday6), .recordOnDaysAway(journal, tuesday6),
            .recordOnDaysAway(water, tuesday6), .recordOnDaysAway(creatine, tuesday6),
            .recordOnDaysAway(gym, tuesday6),
        ])
    #expect(commitments.daysAway.isEmpty)
    #expect(try Data(contentsOf: places.roster) == before)
}

@MainActor
@Test(
    "a commitment ticked onto days away over a day holding its record is refused, naming it and the day"
)
func aCommitmentTickedOntoDaysAwayOverADayHoldingItsRecordIsRefusedNamingItAndTheDay() throws {
    let places = Places()
    let gym = commitment("Gym")
    let yuno = commitment("Yuno")
    try takeOn([gym, yuno], at: places)
    let saturday10 = date(2026, 10, 10)
    try RecordStore(at: places.record).add(Tick(yuno, on: saturday10)!)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: saturday10, through: date(2026, 10, 18), over: [gym])
    let mallorca = try #require(commitments.daysAway.first)

    let refused = commitments.changeDaysAway(
        mallorca, named: "Mallorca", from: saturday10, through: date(2026, 10, 18), over: [gym, yuno])
    #expect(refused == .recordOnDaysAway(yuno, saturday10))
    #expect(commitments.daysAway.first?.commitments.map(\.name) == ["Gym"])

    let kept = commitments.changeDaysAway(
        mallorca, named: "Mallorca", from: date(2026, 10, 11), through: date(2026, 10, 18),
        over: [gym, yuno])
    #expect(kept == nil)
}

@MainActor
@Test(
    "days away moved over a recorded day are refused, and days they give back or already hold are not judged"
)
func daysAwayMovedOverARecordedDayAreRefusedAndDaysTheyGiveBackOrAlreadyHoldAreNotJudged() throws {
    let places = Places()
    let creatine = commitment("Creatine")
    let magnesium = commitment("Magnesium")
    try takeOn([creatine, magnesium], at: places)
    let record = try RecordStore(at: places.record)
    try record.add(Tick(creatine, on: monday12)!)
    screen(places).sayDaysAway(
        named: "", from: monday12, through: date(2026, 10, 16), over: [creatine, magnesium])
    try record.add(Tick(magnesium, on: date(2026, 10, 14))!)
    try record.add(Tick(magnesium, on: date(2026, 10, 16))!)
    let tuesday = screen(places, asOf: date(2026, 10, 13))
    let said = try #require(tuesday.daysAway.first)

    let earlier = tuesday.changeDaysAway(
        said, named: "", from: date(2026, 10, 11), through: date(2026, 10, 16),
        over: [creatine, magnesium])
    let shorter = tuesday.changeDaysAway(
        said, named: "", from: monday12, through: date(2026, 10, 15), over: [creatine, magnesium])
    let renamed = tuesday.changeDaysAway(
        said, named: "Flu", from: monday12, through: date(2026, 10, 15), over: [creatine, magnesium])

    #expect(earlier == .recordOnDaysAway(creatine, monday12))
    #expect(shorter == nil)
    #expect(renamed == nil)
    #expect(keptRows(on: date(2026, 10, 16), at: places)["Magnesium"] == true)
}

@MainActor
@Test(
    "a first day moved onto the day handed keeps through it a commitment holding a record there"
)
func aFirstDayMovedOntoTheDayHandedKeepsThroughItACommitmentHoldingARecordThere() throws {
    let places = Places()
    let creatine = commitment("Creatine")
    let magnesium = commitment("Magnesium")
    try takeOn([creatine, magnesium], at: places)
    try RecordStore(at: places.record).add(Tick(creatine, on: monday12)!)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [creatine, magnesium])
    let said = try #require(commitments.daysAway.first)

    let refusal = commitments.changeDaysAway(
        said, named: "", from: monday12, through: date(2026, 10, 18), over: [creatine, magnesium])

    #expect(refusal == nil)
    #expect(keptRows(on: monday12, at: places) == ["Creatine": true])
    #expect(keptRows(on: date(2026, 10, 13), at: places).isEmpty)
}

@MainActor
@Test("a commitments screen that cannot read its record refuses no days away for a record")
func aCommitmentsScreenThatCannotReadItsRecordRefusesNoDaysAwayForARecord() throws {
    let places = Places()
    let gym = commitment("Gym")
    try takeOn([gym], at: places)
    try Data("not what a record is written as".utf8).write(to: places.record)
    let commitments = screen(places)

    let refusal = commitments.sayDaysAway(
        named: "", from: date(2026, 10, 5), through: date(2026, 10, 7), over: [gym])

    #expect(refusal == nil)
    let kept = try roster(at: places)
    #expect(!isDue("Gym", on: date(2026, 10, 5), in: kept))
    #expect(!isDue("Gym", on: date(2026, 10, 7), in: kept))
}

@MainActor
private func stopKeeping(_ commitment: Commitment, on screen: CommitmentsScreen) {
    screen.askToStopKeeping(commitment)
    screen.confirmStopKeeping()
}

@MainActor
@Test(
    "a stopped commitment in days away already past stays picked through a change, and unticked has their days back up to its stop"
)
func aStoppedCommitmentInDaysAwayAlreadyPastStaysPickedThroughAChangeAndUntickedHasTheirDaysBackUpToItsStop()
    throws
{
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    let thursday1 = date(2026, 10, 1)
    screen(places, asOf: thursday1).sayDaysAway(
        named: "Flu", from: thursday1, through: date(2026, 10, 3), over: [gym, run])
    stopKeeping(gym, on: screen(places))
    let commitments = screen(places)
    let flu = try #require(commitments.pastDaysAway.first)

    let both = commitments.changeDaysAway(
        flu, named: "Fever", from: thursday1, through: date(2026, 10, 3), over: [gym, run])
    #expect(both == nil)
    #expect(commitments.pastDaysAway.map(\.title) == ["Fever"])
    #expect(commitments.pastDaysAway.first?.commitments.map(\.name) == ["Gym", "Run"])

    let fever = try #require(commitments.pastDaysAway.first)
    let one = commitments.changeDaysAway(
        fever, named: "Fever", from: thursday1, through: date(2026, 10, 3), over: [run])
    #expect(one == nil)
    #expect(commitments.pastDaysAway.first?.commitments.map(\.name) == ["Run"])

    #expect(rows(on: date(2026, 10, 2), at: places) == ["Gym"])
    let store = try RosterStore(at: places.roster)
    #expect(store.roster.commitments(on: date(2026, 10, 11)).map(\.name).contains("Gym"))
    #expect(!store.roster.commitments(on: monday12).map(\.name).contains("Gym"))
}

@MainActor
@Test("days away moved past the last day a stopped commitment was kept keep it until the day before them")
func daysAwayMovedPastTheLastDayAStoppedCommitmentWasKeptKeepItUntilTheDayBeforeThem() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    let thursday1 = date(2026, 10, 1)
    screen(places, asOf: thursday1).sayDaysAway(
        named: "Flu", from: thursday1, through: date(2026, 10, 3), over: [gym, run])
    stopKeeping(gym, on: screen(places, asOf: date(2026, 10, 5)))
    let commitments = screen(places)
    let flu = try #require(commitments.pastDaysAway.first)

    let refusal = commitments.changeDaysAway(
        flu, named: "Flu", from: thursday1, through: date(2026, 10, 7), over: [gym, run])

    #expect(refusal == nil)
    #expect(commitments.pastDaysAway.map(\.title) == ["Flu"])
    #expect(commitments.pastDaysAway.first?.commitments.map(\.name) == ["Gym", "Run"])
    let kept = try RosterStore(at: places.roster).roster
    #expect(kept.commitments(on: date(2026, 9, 30)).map(\.name).contains("Gym"))
    #expect(!kept.commitments(on: date(2026, 10, 4)).map(\.name).contains("Gym"))
    #expect(isDue("Run", on: date(2026, 10, 8), in: kept))
    #expect(!isDue("Run", on: date(2026, 10, 5), in: kept))
}

@MainActor
@Test(
    "a stopped commitment kept until the day before days away stays picked through a later change of them, owing no day after its stop"
)
func aStoppedCommitmentKeptUntilTheDayBeforeDaysAwayStaysPickedThroughALaterChangeOfThemOwingNoDayAfterItsStop()
    throws
{
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    let thursday1 = date(2026, 10, 1)
    screen(places, asOf: thursday1).sayDaysAway(
        named: "Flu", from: thursday1, through: date(2026, 10, 3), over: [gym, run])
    stopKeeping(gym, on: screen(places, asOf: date(2026, 10, 5)))
    let commitments = screen(places)
    let flu = try #require(commitments.pastDaysAway.first)
    #expect(
        commitments.changeDaysAway(
            flu, named: "Flu", from: thursday1, through: date(2026, 10, 7), over: [gym, run]) == nil)
    let moved = try #require(commitments.pastDaysAway.first)

    let renamed = commitments.changeDaysAway(
        moved, named: "Fever", from: thursday1, through: date(2026, 10, 7), over: [gym, run])

    #expect(renamed == nil)
    #expect(commitments.pastDaysAway.map(\.title) == ["Fever"])
    #expect(commitments.pastDaysAway.first?.commitments.map(\.name) == ["Gym", "Run"])
    #expect(rows(on: date(2026, 10, 5), at: places) == [])
    let kept = try RosterStore(at: places.roster).roster
    #expect(kept.commitments(on: date(2026, 9, 30)).map(\.name).contains("Gym"))
    #expect(!kept.commitments(on: thursday1).map(\.name).contains("Gym"))
}

@MainActor
@Test(
    "days away over nothing but a commitment stopped the day after them are renamed, and moved earlier, still over it"
)
func daysAwayOverNothingButACommitmentStoppedTheDayAfterThemAreRenamedAndMovedEarlierStillOverIt()
    throws
{
    let places = Places()
    let gym = commitment("Gym")
    try takeOn([gym], at: places)
    let thursday1 = date(2026, 10, 1)
    let saturday3 = date(2026, 10, 3)
    screen(places, asOf: thursday1).sayDaysAway(
        named: "Flu", from: thursday1, through: saturday3, over: [gym])
    stopKeeping(gym, on: screen(places, asOf: date(2026, 10, 4)))
    let commitments = screen(places)
    let flu = try #require(commitments.pastDaysAway.first)

    let renamed = commitments.changeDaysAway(
        flu, named: "Fever", from: thursday1, through: saturday3, over: [gym])
    #expect(renamed == nil)
    let fever = try #require(commitments.pastDaysAway.first)
    let earlier = commitments.changeDaysAway(
        fever, named: "Fever", from: date(2026, 9, 28), through: saturday3, over: [gym])

    #expect(earlier == nil)
    #expect(commitments.pastDaysAway.map(\.title) == ["Fever"])
    #expect(commitments.pastDaysAway.map(\.daysInWords) == ["Mon 28 Sep – Sat 3 Oct"])
    #expect(commitments.pastDaysAway.first?.commitments.map(\.name) == ["Gym"])
    let kept = try RosterStore(at: places.roster).roster
    #expect(kept.commitments(on: date(2026, 9, 27)).map(\.name).contains("Gym"))
    #expect(!kept.commitments(on: date(2026, 9, 28)).map(\.name).contains("Gym"))
}

@MainActor
@Test(
    "days away moved wholly past the last day a stopped commitment was kept leave it out, and are refused where it was all they were over"
)
func daysAwayMovedWhollyPastTheLastDayAStoppedCommitmentWasKeptLeaveItOutAndAreRefusedWhereItWasAllTheyWereOver()
    throws
{
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    let thursday1 = date(2026, 10, 1)
    let saying = screen(places, asOf: thursday1)
    saying.sayDaysAway(named: "Flu", from: thursday1, through: date(2026, 10, 3), over: [gym, run])
    saying.sayDaysAway(
        named: "Cold", from: date(2026, 9, 1), through: date(2026, 9, 2), over: [gym])
    stopKeeping(gym, on: screen(places, asOf: date(2026, 10, 5)))
    let commitments = screen(places)
    let flu = try #require(commitments.pastDaysAway.first { $0.title == "Flu" })
    let cold = try #require(commitments.pastDaysAway.first { $0.title == "Cold" })

    let first = commitments.changeDaysAway(
        cold, named: "Cold", from: date(2026, 10, 6), through: date(2026, 10, 8), over: [gym])
    let second = commitments.changeDaysAway(
        flu, named: "Flu", from: date(2026, 10, 6), through: date(2026, 10, 8), over: [gym, run])

    #expect(first == .overNoCommitment)
    #expect(second == nil)
    #expect(commitments.pastDaysAway.map(\.title) == ["Flu", "Cold"])
    #expect(commitments.pastDaysAway.map(\.daysInWords) == ["Tue 6 Oct – Thu 8 Oct", "Tue 1 Sep – Wed 2 Sep"])
    #expect(commitments.pastDaysAway.map { $0.commitments.map(\.name) } == [["Run"], ["Gym"]])
    #expect(rows(on: date(2026, 10, 2), at: places) == ["Gym", "Run"])
    let kept = try RosterStore(at: places.roster).roster
    #expect(kept.commitments(on: date(2026, 10, 4)).map(\.name).contains("Gym"))
    #expect(!kept.commitments(on: date(2026, 10, 5)).map(\.name).contains("Gym"))
}

@MainActor
@Test("days away over a commitment stopped the day after them, removed, give it back every day of them")
func daysAwayOverACommitmentStoppedTheDayAfterThemRemovedGiveItBackEveryDayOfThem() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    let thursday1 = date(2026, 10, 1)
    screen(places, asOf: thursday1).sayDaysAway(
        named: "Flu", from: thursday1, through: date(2026, 10, 3), over: [gym, run])
    stopKeeping(gym, on: screen(places, asOf: date(2026, 10, 4)))
    let commitments = screen(places)
    let flu = try #require(commitments.pastDaysAway.first)

    commitments.askToRemove(flu)
    let refusal = commitments.confirmRemovingDaysAway()

    #expect(refusal == nil)
    #expect(commitments.daysAway.isEmpty && commitments.pastDaysAway.isEmpty)
    #expect(rows(on: date(2026, 10, 2), at: places) == ["Gym", "Run"])
    let kept = try RosterStore(at: places.roster).roster
    #expect(kept.commitments(on: date(2026, 10, 3)).map(\.name).contains("Gym"))
    #expect(!kept.commitments(on: date(2026, 10, 4)).map(\.name).contains("Gym"))
}

@MainActor
@Test(
    "days away moved past a stop and then removed give the stopped commitment back its days up to its stop and none after"
)
func daysAwayMovedPastAStopAndThenRemovedGiveTheStoppedCommitmentBackItsDaysUpToItsStopAndNoneAfter()
    throws
{
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    let thursday1 = date(2026, 10, 1)
    screen(places, asOf: thursday1).sayDaysAway(
        named: "Flu", from: thursday1, through: date(2026, 10, 3), over: [gym, run])
    stopKeeping(gym, on: screen(places, asOf: date(2026, 10, 5)))
    let commitments = screen(places)
    let flu = try #require(commitments.pastDaysAway.first)
    let moved = commitments.changeDaysAway(
        flu, named: "Flu", from: thursday1, through: date(2026, 10, 7), over: [gym, run])
    #expect(moved == nil)

    commitments.askToRemove(try #require(commitments.pastDaysAway.first))
    let refusal = commitments.confirmRemovingDaysAway()

    #expect(refusal == nil)
    #expect(commitments.daysAway.isEmpty && commitments.pastDaysAway.isEmpty)
    #expect(rows(on: date(2026, 10, 4), at: places) == ["Gym", "Run"])
    #expect(rows(on: date(2026, 10, 6), at: places) == ["Run"])
    let kept = try RosterStore(at: places.roster).roster
    #expect(kept.commitments(on: date(2026, 10, 4)).map(\.name).contains("Gym"))
    #expect(!kept.commitments(on: date(2026, 10, 5)).map(\.name).contains("Gym"))
}

@MainActor
@Test(
    "a stopped commitment unticked from days away moved past its stop has their days back up to its stop and none after"
)
func aStoppedCommitmentUntickedFromDaysAwayMovedPastItsStopHasTheirDaysBackUpToItsStopAndNoneAfter()
    throws
{
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    let thursday1 = date(2026, 10, 1)
    screen(places, asOf: thursday1).sayDaysAway(
        named: "Flu", from: thursday1, through: date(2026, 10, 3), over: [gym, run])
    stopKeeping(gym, on: screen(places, asOf: date(2026, 10, 5)))
    let commitments = screen(places)
    let flu = try #require(commitments.pastDaysAway.first)
    #expect(
        commitments.changeDaysAway(
            flu, named: "Flu", from: thursday1, through: date(2026, 10, 7), over: [gym, run]) == nil)
    let moved = try #require(commitments.pastDaysAway.first)

    let unticked = commitments.changeDaysAway(
        moved, named: "Flu", from: thursday1, through: date(2026, 10, 7), over: [run])

    #expect(unticked == nil)
    #expect(commitments.pastDaysAway.first?.commitments.map(\.name) == ["Run"])
    #expect(rows(on: thursday1, at: places) == ["Gym"])
    #expect(rows(on: date(2026, 10, 5), at: places) == [])
    let kept = try RosterStore(at: places.roster).roster
    #expect(kept.commitments(on: date(2026, 10, 4)).map(\.name).contains("Gym"))
    #expect(!kept.commitments(on: date(2026, 10, 5)).map(\.name).contains("Gym"))
}

@MainActor
@Test(
    "days away moved past a stop and then wholly past it give the stopped commitment back its days up to its stop"
)
func daysAwayMovedPastAStopAndThenWhollyPastItGiveTheStoppedCommitmentBackItsDaysUpToItsStop() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    let thursday1 = date(2026, 10, 1)
    screen(places, asOf: thursday1).sayDaysAway(
        named: "Flu", from: thursday1, through: date(2026, 10, 3), over: [gym, run])
    stopKeeping(gym, on: screen(places, asOf: date(2026, 10, 5)))
    let commitments = screen(places)
    let flu = try #require(commitments.pastDaysAway.first)
    #expect(
        commitments.changeDaysAway(
            flu, named: "Flu", from: thursday1, through: date(2026, 10, 7), over: [gym, run]) == nil)
    let moved = try #require(commitments.pastDaysAway.first)

    let wholly = commitments.changeDaysAway(
        moved, named: "Flu", from: date(2026, 10, 6), through: date(2026, 10, 8), over: [gym, run])

    #expect(wholly == nil)
    #expect(commitments.pastDaysAway.map(\.daysInWords) == ["Tue 6 Oct – Thu 8 Oct"])
    #expect(commitments.pastDaysAway.first?.commitments.map(\.name) == ["Run"])
    #expect(rows(on: thursday1, at: places) == ["Gym", "Run"])
    let kept = try RosterStore(at: places.roster).roster
    #expect(kept.commitments(on: date(2026, 10, 4)).map(\.name).contains("Gym"))
    #expect(!kept.commitments(on: date(2026, 10, 5)).map(\.name).contains("Gym"))
}

@MainActor
@Test("days away moved past a stop and back again give the stopped commitment back its days up to its stop")
func daysAwayMovedPastAStopAndBackAgainGiveTheStoppedCommitmentBackItsDaysUpToItsStop() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    let thursday1 = date(2026, 10, 1)
    screen(places, asOf: thursday1).sayDaysAway(
        named: "Flu", from: thursday1, through: date(2026, 10, 3), over: [gym, run])
    stopKeeping(gym, on: screen(places, asOf: date(2026, 10, 5)))
    let commitments = screen(places)
    let flu = try #require(commitments.pastDaysAway.first)
    #expect(
        commitments.changeDaysAway(
            flu, named: "Flu", from: thursday1, through: date(2026, 10, 7), over: [gym, run]) == nil)
    let moved = try #require(commitments.pastDaysAway.first)

    let back = commitments.changeDaysAway(
        moved, named: "Flu", from: thursday1, through: date(2026, 10, 3), over: [gym, run])

    #expect(back == nil)
    #expect(commitments.pastDaysAway.map(\.daysInWords) == ["Thu 1 Oct – Sat 3 Oct"])
    #expect(commitments.pastDaysAway.first?.commitments.map(\.name) == ["Gym", "Run"])
    #expect(rows(on: date(2026, 10, 4), at: places) == ["Gym", "Run"])
    let kept = try RosterStore(at: places.roster).roster
    #expect(kept.commitments(on: date(2026, 10, 4)).map(\.name).contains("Gym"))
    #expect(!kept.commitments(on: date(2026, 10, 5)).map(\.name).contains("Gym"))
}

@MainActor
@Test(
    "a stopped commitment taken up again after days away moved past its stop owes, once they are removed, its days up to its stop and none before it was taken up again"
)
func aStoppedCommitmentTakenUpAgainAfterDaysAwayMovedPastItsStopOwesOnceTheyAreRemovedItsDaysUpToItsStopAndNoneBeforeItWasTakenUpAgain()
    throws
{
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    let thursday1 = date(2026, 10, 1)
    screen(places, asOf: thursday1).sayDaysAway(
        named: "Flu", from: thursday1, through: date(2026, 10, 3), over: [gym, run])
    stopKeeping(gym, on: screen(places, asOf: date(2026, 10, 5)))
    let commitments = screen(places)
    let flu = try #require(commitments.pastDaysAway.first)
    #expect(
        commitments.changeDaysAway(
            flu, named: "Flu", from: thursday1, through: date(2026, 10, 7), over: [gym, run]) == nil)
    let stoppedGym = try #require(commitments.stopped.first)
    #expect(commitments.keepAgain(stoppedGym) == nil)

    commitments.askToRemove(try #require(commitments.pastDaysAway.first))
    let refusal = commitments.confirmRemovingDaysAway()

    #expect(refusal == nil)
    let kept = try RosterStore(at: places.roster).roster
    for day in [4, 12] {
        #expect(isDue("Gym", on: date(2026, 10, day), in: kept))
    }
    for day in [5, 11] {
        #expect(!isDue("Gym", on: date(2026, 10, day), in: kept))
    }
}

@MainActor
@Test(
    "a commitment taken up again inside days away over it is taken up on the day after their last day, and stays remembered by them"
)
func aCommitmentTakenUpAgainInsideDaysAwayOverItIsTakenUpOnTheDayAfterTheirLastDayAndStaysRememberedByThem()
    throws
{
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    screen(places).sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, run])
    stopKeeping(gym, on: screen(places, asOf: date(2026, 10, 15)))
    let commitments = screen(places, asOf: date(2026, 10, 16))
    let stoppedGym = try #require(commitments.stopped.first)

    let refusal = commitments.keepAgain(stoppedGym)

    #expect(refusal == nil)
    #expect(commitments.kept.map(\.name).contains("Gym"))
    #expect(commitments.daysAway.map(\.title) == ["Mallorca"])
    #expect(commitments.daysAway.first?.commitments.map(\.name) == ["Gym", "Run"])
    let roster = try RosterStore(at: places.roster).roster
    #expect(isDue("Gym", on: date(2026, 10, 19), in: roster))
    for day in 16...18 {
        #expect(!isDue("Gym", on: date(2026, 10, day), in: roster))
    }

    commitments.askToRemove(try #require(commitments.daysAway.first))
    #expect(commitments.confirmRemovingDaysAway() == nil)
    let removed = try RosterStore(at: places.roster).roster
    for day in [13, 14, 19] {
        #expect(isDue("Gym", on: date(2026, 10, day), in: removed))
    }
    for day in 15...18 {
        #expect(!isDue("Gym", on: date(2026, 10, day), in: removed))
    }
}
