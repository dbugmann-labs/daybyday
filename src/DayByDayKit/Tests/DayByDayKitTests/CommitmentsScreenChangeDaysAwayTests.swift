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
    // A screen for a day before they begin, which offers their removal.
    let monday = screen(places)
    monday.askToRemove(mallorca)
    let removed = monday.confirmRemovingDaysAway()
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
