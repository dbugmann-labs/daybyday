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
private let runSchedule = Schedule.weekdays([.tuesday, .thursday, .sunday])

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

@MainActor
private func rows(on day: CalendarDate, at places: Places) -> [String] {
    DayScreen(
        startingFrom: [], asOf: day, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs
    ).dayView.rows.map(\.name)
}

@MainActor
@Test(
    "days away said over two commitments leave them no row on their days and rows again from the day after"
)
func daysAwaySaidOverTwoCommitmentsLeaveThemNoRowOnTheirDaysAndRowsAgainFromTheDayAfter() throws {
    let places = Places()
    let gym = commitment("Gym", gymSchedule)
    let run = commitment("Run", runSchedule)
    let creatine = commitment("Creatine")
    try takeOn([gym, run, creatine], at: places)
    let commitments = screen(places)

    let refusal = commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, run])

    #expect(refusal == nil)
    #expect(commitments.kept.map(\.name) == ["Gym", "Run", "Creatine"])
    #expect(commitments.stopped.isEmpty)
    #expect(rows(on: monday12, at: places) == ["Gym", "Creatine"])
    #expect(rows(on: date(2026, 10, 14), at: places) == ["Creatine"])
    #expect(rows(on: date(2026, 10, 15), at: places) == ["Creatine"])
    #expect(rows(on: date(2026, 10, 17), at: places) == ["Creatine"])
    #expect(rows(on: date(2026, 10, 19), at: places) == ["Gym", "Creatine"])
    #expect(rows(on: date(2026, 10, 20), at: places) == ["Run", "Creatine"])
}

@MainActor
@Test("a look-back at a commitment with days away ahead is the same as one taken before they were said")
func aLookBackAtACommitmentWithDaysAwayAheadIsTheSameAsOneTakenBeforeTheyWereSaid() throws {
    let places = Places()
    let gym = commitment("Gym", gymSchedule)
    let creatine = commitment("Creatine")
    try takeOn([gym, creatine], at: places)
    let record = try RecordStore(at: places.record)
    for day in [date(2026, 9, 28), date(2026, 9, 30), date(2026, 10, 3), date(2026, 10, 7)] {
        try record.add(Tick(gym, on: day)!)
    }
    let commitments = screen(places)
    let before = commitments.lookBack(at: gym)

    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])

    #expect(before != nil)
    #expect(commitments.lookBack(at: gym) == before)
    #expect(commitments.lookBack(at: creatine) == screen(places).lookBack(at: creatine))
}

@MainActor
@Test("days away keep their name trimmed, and a name that says nothing is none")
func daysAwayKeepTheirNameTrimmedAndANameThatSaysNothingIsNone() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    let creatine = commitment("Creatine")
    try takeOn([gym, run, creatine], at: places)
    let commitments = screen(places)

    let first = commitments.sayDaysAway(
        named: " Mallorca ", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    let second = commitments.sayDaysAway(
        named: "   ", from: date(2026, 10, 20), through: date(2026, 10, 20), over: [creatine])
    let third = commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 19), through: date(2026, 10, 20), over: [run])

    #expect(first == nil)
    #expect(second == nil)
    #expect(third == nil)
    #expect(commitments.daysAway.map(\.name) == ["Mallorca", "Mallorca", nil])
}

@MainActor
@Test("days away of one day are said, and so are days away of any length however far ahead")
func daysAwayOfOneDayAreSaidAndSoAreDaysAwayOfAnyLengthHoweverFarAhead() throws {
    let places = Places()
    let creatine = commitment("Creatine")
    let run = commitment("Run")
    try takeOn([creatine, run], at: places)
    let commitments = screen(places)

    let oneDay = commitments.sayDaysAway(
        named: "", from: date(2026, 10, 13), through: date(2026, 10, 13), over: [creatine])
    let farAhead = commitments.sayDaysAway(
        named: "", from: date(2027, 6, 1), through: date(2033, 12, 31), over: [run])

    #expect(oneDay == nil)
    #expect(farAhead == nil)
    #expect(rows(on: date(2026, 10, 13), at: places) == ["Run"])
    #expect(rows(on: date(2026, 10, 14), at: places) == ["Creatine", "Run"])
    #expect(rows(on: date(2027, 9, 15), at: places) == ["Creatine"])
}

private func isDue(_ name: String, on day: CalendarDate, in roster: Roster) -> Bool {
    roster.groups(on: day).flatMap(\.commitments).contains {
        $0.name == name && $0.isDue(on: day)
    }
}

@MainActor
@Test(
    "a commitment is taken up again after days away on the rhythm, range and target it had, an every-N-days count beginning again"
)
func aCommitmentIsTakenUpAgainAfterDaysAwayOnTheRhythmRangeAndTargetItHadAnEveryNDaysCountBeginningAgain()
    throws
{
    let places = Places()
    let nails = commitment(
        "Nails", .everyNDays(DayInterval(days: 4)!, from: date(2026, 10, 1)),
        keptFrom: date(2026, 10, 1))
    let weight = commitment(
        "Weight", kind: .number(range: Commitment.Range(lowest: 40, highest: 150)!))
    try takeOn([nails, weight], at: places)
    let commitments = screen(places)

    let refusal = commitments.sayDaysAway(
        named: "", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [nails, weight])

    #expect(refusal == nil)
    let roster = try RosterStore(at: places.roster).roster
    for due in [date(2026, 10, 9), date(2026, 10, 19), date(2026, 10, 23)] {
        #expect(isDue("Nails", on: due, in: roster))
    }
    for notDue in [date(2026, 10, 13), date(2026, 10, 17), date(2026, 10, 21)] {
        #expect(!isDue("Nails", on: notDue, in: roster))
    }
    let day = DayScreen(
        startingFrom: [], asOf: date(2026, 10, 19), keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOffs)
    let weightRow = try #require(day.dayView.rows.first { $0.name == "Weight" })
    #expect(weightRow.numberEntry(asOf: date(2026, 10, 19))?.hint == "40–150")
}

@MainActor
@Test(
    "days away from today keep a commitment that holds a record today until today, and the others until the day before"
)
func daysAwayFromTodayKeepACommitmentThatHoldsARecordTodayUntilTodayAndTheOthersUntilTheDayBefore()
    throws
{
    let places = Places()
    let creatine = commitment("Creatine")
    let magnesium = commitment("Magnesium")
    try takeOn([creatine, magnesium], at: places)
    let tick = Tick(creatine, on: monday12)!
    let record = try RecordStore(at: places.record)
    try record.add(tick)
    let commitments = screen(places)

    let refusal = commitments.sayDaysAway(
        named: "", from: monday12, through: date(2026, 10, 14), over: [creatine, magnesium])

    #expect(refusal == nil)
    func dayRows(_ day: CalendarDate) -> [DayView.Row] {
        DayScreen(
            startingFrom: [], asOf: day, keepingRecordAt: places.record,
            keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOffs
        ).dayView.rows
    }
    #expect(dayRows(monday12).map(\.name) == ["Creatine"])
    #expect(dayRows(monday12).map(\.isKept) == [true])
    #expect(dayRows(date(2026, 10, 13)).isEmpty)
    #expect(dayRows(date(2026, 10, 15)).map(\.name) == ["Creatine", "Magnesium"])

    try record.remove(tick)
    #expect(dayRows(monday12).map(\.name) == ["Creatine"])
    #expect(dayRows(monday12).map(\.isKept) == [false])
}

@MainActor
@Test(
    "days away over a commitment other days away are over on a shared day are refused, naming those days away"
)
func daysAwayOverACommitmentOtherDaysAwayAreOverOnASharedDayAreRefusedNamingThoseDaysAway() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    let creatine = commitment("Creatine")
    try takeOn([gym, run, creatine], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, run])
    let mallorca = try #require(commitments.daysAway.first)

    let shared = commitments.sayDaysAway(
        named: "", from: date(2026, 10, 17), through: date(2026, 10, 20), over: [run, creatine])

    #expect(shared == .overlapsDaysAway(mallorca))
    #expect(commitments.daysAway.map(\.title) == ["Mallorca"])
    let creatineAlone = commitments.sayDaysAway(
        named: "", from: date(2026, 10, 17), through: date(2026, 10, 20), over: [creatine])
    let gymAfter = commitments.sayDaysAway(
        named: "", from: date(2026, 10, 19), through: date(2026, 10, 20), over: [gym])
    #expect(creatineAlone == nil)
    #expect(gymAfter == nil)
}

@MainActor
@Test("days away over a commitment kept from their first day or later are refused, naming it")
func daysAwayOverACommitmentKeptFromTheirFirstDayOrLaterAreRefusedNamingIt() throws {
    let places = Places()
    let yoga = commitment("Yoga", keptFrom: date(2026, 10, 14))
    let pilates = commitment("Pilates", keptFrom: date(2026, 10, 13))
    try takeOn([yoga, pilates], at: places)
    let commitments = screen(places)

    let later = commitments.sayDaysAway(
        named: "", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [yoga])
    let sameDay = commitments.sayDaysAway(
        named: "", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [pilates])

    #expect(later == .keptFromFirstDayOrLater("Yoga"))
    #expect(sameDay == .keptFromFirstDayOrLater("Pilates"))
    #expect(commitments.daysAway.isEmpty)
}

@MainActor
@Test("days away over a commitment with a shift on one of their days are refused, naming it")
func daysAwayOverACommitmentWithAShiftOnOneOfTheirDaysAreRefusedNamingIt() throws {
    let places = Places()
    let gym = commitment("Gym", gymSchedule)
    try takeOn([gym], at: places)
    try RosterStore(at: places.roster).shift(gym, from: monday12, to: date(2026, 10, 13))
    let commitments = screen(places)

    let shifted = commitments.sayDaysAway(
        named: "", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    let clear = commitments.sayDaysAway(
        named: "", from: date(2026, 10, 14), through: date(2026, 10, 18), over: [gym])

    #expect(shifted == .shiftOnDaysAway("Gym"))
    #expect(clear == nil)
}

private func setWritable(_ directory: URL, _ writable: Bool) throws {
    try FileManager.default.setAttributes(
        [.posixPermissions: writable ? 0o700 : 0o500], ofItemAtPath: directory.path)
}

@MainActor
@Test("days away a commitments screen cannot keep at its roster place are refused")
func daysAwayACommitmentsScreenCannotKeepAtItsRosterPlaceAreRefused() throws {
    let places = Places()
    let gym = commitment("Gym")
    try takeOn([gym], at: places)
    let commitments = screen(places)
    let directory = places.roster.deletingLastPathComponent()
    try setWritable(directory, false)
    defer { try? setWritable(directory, true) }

    let refusal = commitments.sayDaysAway(
        named: "", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])

    #expect(refusal == .notKept)
    #expect(commitments.daysAway.isEmpty)

    let unreadable = Places()
    try FileManager.default.createDirectory(
        at: unreadable.roster.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a roster".utf8).write(to: unreadable.roster)
    let unreadableScreen = screen(unreadable)

    #expect(
        unreadableScreen.sayDaysAway(
            named: "", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
            == .notKept)
}

@MainActor
@Test("a commitments screen asked to say days away over a commitment it does not keep does nothing")
func aCommitmentsScreenAskedToSayDaysAwayOverACommitmentItDoesNotKeepDoesNothing() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    try RosterStore(at: places.roster).retire(run, keptUntil: date(2026, 10, 11))
    let commitments = screen(places)
    let before = try Data(contentsOf: places.roster)

    let refusal = commitments.sayDaysAway(
        named: "", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, run])

    #expect(refusal == nil)
    #expect(commitments.daysAway.isEmpty)
    #expect(commitments.daysAwayRefusal == nil)
    #expect(try Data(contentsOf: places.roster) == before)
}

@MainActor
@Test(
    "a refusal of days away is told until the sheet is edited or closed, days away are kept, or the app is shown again"
)
func aRefusalOfDaysAwayIsToldUntilTheSheetIsEditedOrClosedDaysAwayAreKeptOrTheAppIsShownAgain()
    throws
{
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    let commitments = screen(places)
    func sayBackwards() {
        commitments.sayDaysAway(
            named: "", from: date(2026, 10, 14), through: date(2026, 10, 13), over: [gym])
    }

    sayBackwards()
    #expect(commitments.daysAwayRefusal == .lastDayBeforeFirstDay)
    commitments.askToStopKeeping(run)
    commitments.confirmStopKeeping()
    #expect(commitments.stopped.map(\.name) == ["Run"])
    #expect(commitments.daysAwayRefusal == .lastDayBeforeFirstDay)

    commitments.daysAwaySheetEdited()
    #expect(commitments.daysAwayRefusal == nil)

    sayBackwards()
    #expect(commitments.daysAwayRefusal == .lastDayBeforeFirstDay)
    commitments.daysAwaySheetClosed()
    #expect(commitments.daysAwayRefusal == nil)

    sayBackwards()
    #expect(commitments.daysAwayRefusal == .lastDayBeforeFirstDay)
    commitments.shown(asOf: monday12)
    #expect(commitments.daysAwayRefusal == nil)

    sayBackwards()
    #expect(commitments.daysAwayRefusal == .lastDayBeforeFirstDay)
    commitments.sayDaysAway(
        named: "", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    #expect(commitments.daysAwayRefusal == nil)
    #expect(commitments.daysAway.count == 1)
}

@MainActor
@Test(
    "a commitments screen lists days away by name or Away, with their days in words and their commitments, earliest first"
)
func aCommitmentsScreenListsDaysAwayByNameOrAwayWithTheirDaysInWordsAndTheirCommitmentsEarliestFirst()
    throws
{
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    let creatine = commitment("Creatine")
    try takeOn([gym, run, creatine], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "", from: date(2026, 10, 20), through: date(2026, 10, 20), over: [creatine])
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [run, gym])
    commitments.sayDaysAway(
        named: "Lisbon", from: date(2026, 10, 13), through: date(2026, 10, 14), over: [creatine])
    let made = try #require(commitments.whatItIsMadeOf(gym))

    let refusal = commitments.change(
        gym, toName: "Gym 🏋️", on: made.rhythm, keptFrom: made.keptFrom, under: nil)

    #expect(refusal == nil)
    #expect(commitments.daysAway.map(\.title) == ["Mallorca", "Lisbon", "Away"])
    #expect(
        commitments.daysAway.map(\.daysInWords) == [
            "Tue 13 Oct – Sun 18 Oct", "Tue 13 Oct – Wed 14 Oct", "Tue 20 Oct",
        ])
    #expect(
        commitments.daysAway.map { $0.commitments.map(\.name) } == [
            ["Gym 🏋️", "Run"], ["Creatine"], ["Creatine"],
        ])
}

@MainActor
@Test("days away leave the list once their last day has passed and stay at the roster place")
func daysAwayLeaveTheListOnceTheirLastDayHasPassedAndStayAtTheRosterPlace() throws {
    let places = Places()
    let gym = commitment("Gym")
    let creatine = commitment("Creatine")
    try takeOn([gym, creatine], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    commitments.sayDaysAway(
        named: "", from: date(2026, 10, 20), through: date(2026, 10, 20), over: [creatine])

    commitments.shown(asOf: date(2026, 10, 18))
    #expect(commitments.daysAway.map(\.title) == ["Mallorca", "Away"])
    commitments.shown(asOf: date(2026, 10, 19))
    #expect(commitments.daysAway.map(\.title) == ["Away"])
    commitments.shown(asOf: date(2026, 10, 21))
    #expect(commitments.daysAway.isEmpty)
    #expect(try RosterStore(at: places.roster).roster.daysAway.map(\.title) == ["Mallorca", "Away"])
}

@MainActor
@Test("a commitments screen that cannot read its roster lists no days away")
func aCommitmentsScreenThatCannotReadItsRosterListsNoDaysAway() throws {
    let places = Places()
    try FileManager.default.createDirectory(
        at: places.roster.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a roster".utf8).write(to: places.roster)

    let commitments = screen(places)

    #expect(commitments.daysAway.isEmpty)
    #expect(commitments.rosterState == .notKept)
}

@MainActor
@Test("asking to remove days away changes nothing until it is confirmed, and a cancel changes nothing")
func askingToRemoveDaysAwayChangesNothingUntilItIsConfirmedAndACancelChangesNothing() throws {
    let places = Places()
    let gym = commitment("Gym")
    try takeOn([gym], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    let mallorca = try #require(commitments.daysAway.first)
    let before = try Data(contentsOf: places.roster)

    commitments.askToRemove(mallorca)

    #expect(commitments.offersRemoving(mallorca))
    #expect(commitments.daysAwayAwaitingRemoval == mallorca)
    #expect(commitments.daysAway.map(\.title) == ["Mallorca"])

    commitments.cancelRemovingDaysAway()

    #expect(commitments.daysAwayAwaitingRemoval == nil)
    #expect(commitments.daysAway.map(\.title) == ["Mallorca"])
    #expect(try Data(contentsOf: places.roster) == before)
}

@MainActor
@Test("days away removed before they begin leave their commitments as though never said")
func daysAwayRemovedBeforeTheyBeginLeaveTheirCommitmentsAsThoughNeverSaid() throws {
    let places = Places()
    let gym = commitment("Gym")
    let nails = commitment(
        "Nails", .everyNDays(DayInterval(days: 4)!, from: date(2026, 10, 1)),
        keptFrom: date(2026, 10, 1))
    try takeOn([gym, nails], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, nails])
    let mallorca = try #require(commitments.daysAway.first)

    commitments.askToRemove(mallorca)
    let refusal = commitments.confirmRemovingDaysAway()

    #expect(refusal == nil)
    #expect(commitments.daysAway.isEmpty)
    let roster = try RosterStore(at: places.roster).roster
    #expect(isDue("Gym", on: date(2026, 10, 15), in: roster))
    for due in [date(2026, 10, 13), date(2026, 10, 17), date(2026, 10, 21)] {
        #expect(isDue("Nails", on: due, in: roster))
    }
    #expect(!isDue("Nails", on: date(2026, 10, 19), in: roster))
}

@MainActor
@Test("days away already begun offer no removal, and asking to remove them does nothing")
func daysAwayAlreadyBegunOfferNoRemovalAndAskingToRemoveThemDoesNothing() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(named: "", from: monday12, through: date(2026, 10, 14), over: [gym])
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [run])
    let begun = try #require(commitments.daysAway.first)
    let mallorca = try #require(commitments.daysAway.last)

    commitments.askToRemove(begun)

    #expect(!commitments.offersRemoving(begun))
    #expect(commitments.daysAwayAwaitingRemoval == nil)
    #expect(commitments.offersRemoving(mallorca))

    commitments.shown(asOf: date(2026, 10, 13))
    commitments.askToRemove(mallorca)

    #expect(!commitments.offersRemoving(mallorca))
    #expect(commitments.daysAwayAwaitingRemoval == nil)
}

@MainActor
@Test("a commitments screen awaits one removal, stop or deletion at a time")
func aCommitmentsScreenAwaitsOneRemovalStopOrDeletionAtATime() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    let mallorca = try #require(commitments.daysAway.first)

    commitments.askToStopKeeping(run)
    commitments.askToRemove(mallorca)

    #expect(commitments.daysAwayAwaitingRemoval == mallorca)
    #expect(commitments.awaitingConfirmation == nil)

    commitments.askToDelete(run)

    #expect(commitments.daysAwayAwaitingRemoval == nil)
    #expect(commitments.awaitingDeletion == run)
}

@MainActor
@Test("days away removed beside other days away over the same commitment leave the other's gap where it was")
func daysAwayRemovedBesideOtherDaysAwayOverTheSameCommitmentLeaveTheOthersGapWhereItWas() throws {
    let places = Places()
    let gym = commitment("Gym")
    try takeOn([gym], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    commitments.sayDaysAway(
        named: "Lisbon", from: date(2026, 10, 19), through: date(2026, 10, 21), over: [gym])
    let mallorca = try #require(commitments.daysAway.first { $0.title == "Mallorca" })

    commitments.askToRemove(mallorca)
    let refusal = commitments.confirmRemovingDaysAway()

    #expect(refusal == nil)
    #expect(commitments.daysAway.map(\.title) == ["Lisbon"])
    let roster = try RosterStore(at: places.roster).roster
    for due in [date(2026, 10, 15), date(2026, 10, 22)] {
        #expect(isDue("Gym", on: due, in: roster))
    }
    for notDue in [date(2026, 10, 19), date(2026, 10, 21)] {
        #expect(!isDue("Gym", on: notDue, in: roster))
    }
}

@MainActor
@Test("days away removed after a change of rhythm leave that change standing from the day it was made")
func daysAwayRemovedAfterAChangeOfRhythmLeaveThatChangeStandingFromTheDayItWasMade() throws {
    let places = Places()
    let gym = commitment("Gym", gymSchedule)
    try takeOn([gym], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    let made = try #require(commitments.whatItIsMadeOf(gym))
    let everyWeekday: Set<Weekday> = [
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ]
    let changed = commitments.change(
        gym, toName: "Gym", on: .weekdays(everyWeekday), keptFrom: made.keptFrom, under: nil)
    let mallorca = try #require(commitments.daysAway.first)
    #expect(!isDue("Gym", on: date(2026, 10, 15), in: try RosterStore(at: places.roster).roster))

    commitments.askToRemove(mallorca)
    let refusal = commitments.confirmRemovingDaysAway()

    #expect(changed == nil)
    #expect(refusal == nil)
    let roster = try RosterStore(at: places.roster).roster
    var day = monday12
    for _ in 0..<30 {
        #expect(isDue("Gym", on: day, in: roster))
        day = day.adding(days: 1)!
    }
    #expect(isDue("Gym", on: date(2026, 10, 10), in: roster))
    #expect(!isDue("Gym", on: date(2026, 10, 9), in: roster))

    // The same removal over the eras a change made before the days begin would leave: the change
    // standing from the day it was made runs through them.
    let old = commitment("Gym", gymSchedule)
    let changedEra = Commitment(
        era: old, schedule: everyDay, keptFrom: monday12, kind: .tick)!
    let resumed = Commitment(
        era: old, schedule: everyDay, keptFrom: date(2026, 10, 19), kind: .tick)!
    let span = Roster.Span(
        identity: .minted(), name: "Mallorca", firstDay: date(2026, 10, 13),
        lastDay: date(2026, 10, 18), commitments: [old.identity])
    var heldRoster = Roster()
    heldRoster.entries = [
        Roster.Entry(commitment: resumed, keptUntil: nil, category: nil, usualAmounts: []),
        Roster.Entry(commitment: changedEra, keptUntil: monday12, category: nil, usualAmounts: []),
        Roster.Entry(commitment: old, keptUntil: date(2026, 10, 11), category: nil, usualAmounts: []),
    ]
    heldRoster.spans = [span]

    heldRoster.removeDaysAway(span.identity)

    #expect(heldRoster.spans.isEmpty)
    #expect(heldRoster.eras(of: old).count == 2)
    day = monday12
    for _ in 0..<30 {
        #expect(isDue("Gym", on: day, in: heldRoster))
        day = day.adding(days: 1)!
    }
    #expect(isDue("Gym", on: date(2026, 10, 10), in: heldRoster))
    #expect(!isDue("Gym", on: date(2026, 10, 9), in: heldRoster))
}

@MainActor
@Test("a removal a commitments screen cannot keep at its roster place is refused and the days away stay listed")
func aRemovalACommitmentsScreenCannotKeepAtItsRosterPlaceIsRefusedAndTheDaysAwayStayListed() throws {
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

    commitments.askToRemove(mallorca)
    let refusal = commitments.confirmRemovingDaysAway()

    #expect(refusal == .notKept)
    #expect(commitments.daysAwayRefusal == .notKept)
    #expect(commitments.daysAway.map(\.title) == ["Mallorca"])
}

@MainActor
private func stop(_ commitment: Commitment, on screen: CommitmentsScreen) -> CommitmentsScreen.Refusal? {
    screen.askToStopKeeping(commitment)
    return screen.confirmStopKeeping()
}

private func notStoppedOn(_ day: CalendarDate, at places: Places) throws -> [String] {
    try RosterStore(at: places.roster).roster.commitments(on: day).map(\.name)
}

@MainActor
@Test("a commitment stopped before its days away begin leaves them, and they stay over the others")
func aCommitmentStoppedBeforeItsDaysAwayBeginLeavesThemAndTheyStayOverTheOthers() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, run])

    let refusal = stop(gym, on: commitments)

    #expect(refusal == nil)
    #expect(commitments.daysAway.map(\.title) == ["Mallorca"])
    #expect(commitments.daysAway[0].commitments.map(\.name) == ["Run"])
    #expect(commitments.stopped.map(\.name) == ["Gym"])
    #expect(try notStoppedOn(date(2026, 10, 11), at: places).contains("Gym"))
    #expect(try !notStoppedOn(monday12, at: places).contains("Gym"))
}

@MainActor
@Test("a commitment stopped while its days away are under way is kept until the day before them")
func aCommitmentStoppedWhileItsDaysAwayAreUnderWayIsKeptUntilTheDayBeforeThem() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    screen(places).sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, run])
    let underWay = screen(places, asOf: date(2026, 10, 15))

    let refusal = stop(gym, on: underWay)

    #expect(refusal == nil)
    #expect(underWay.daysAway.map(\.title) == ["Mallorca"])
    #expect(underWay.daysAway[0].commitments.map(\.name) == ["Run"])
    #expect(try notStoppedOn(monday12, at: places).contains("Gym"))
    #expect(try !notStoppedOn(date(2026, 10, 13), at: places).contains("Gym"))
    #expect(try !notStoppedOn(date(2026, 10, 14), at: places).contains("Gym"))
}

@MainActor
@Test("days away a stop leaves over no commitment go from the roster")
func daysAwayAStopLeavesOverNoCommitmentGoFromTheRoster() throws {
    let places = Places()
    let gym = commitment("Gym")
    try takeOn([gym], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])

    _ = stop(gym, on: commitments)

    #expect(commitments.daysAway.isEmpty)
    #expect(try RosterStore(at: places.roster).roster.daysAway.isEmpty)
}

@MainActor
@Test("a deletion takes a commitment out of its days away, past ones included, and days away left over none go")
func aDeletionTakesACommitmentOutOfItsDaysAwayPastOnesIncludedAndDaysAwayLeftOverNoneGo() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    screen(places, asOf: date(2026, 10, 1)).sayDaysAway(
        named: "Flu", from: date(2026, 10, 1), through: date(2026, 10, 3), over: [gym])
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, run])

    commitments.askToDelete(gym)
    commitments.nameTypedBack = "Gym"
    let refusal = commitments.confirmDeleting()

    #expect(refusal == nil)
    let held = try RosterStore(at: places.roster).roster.daysAway
    #expect(held.map(\.title) == ["Mallorca"])
    #expect(held[0].commitments.map(\.name) == ["Run"])
}

@MainActor
@Test("a stopped commitment stays in days away already past")
func aStoppedCommitmentStaysInDaysAwayAlreadyPast() throws {
    let places = Places()
    let gym = commitment("Gym")
    try takeOn([gym], at: places)
    screen(places, asOf: date(2026, 10, 1)).sayDaysAway(
        named: "Flu", from: date(2026, 10, 1), through: date(2026, 10, 3), over: [gym])
    let commitments = screen(places)

    let refusal = stop(gym, on: commitments)

    #expect(refusal == nil)
    let held = try RosterStore(at: places.roster).roster.daysAway
    #expect(held.map(\.title) == ["Flu"])
    #expect(held[0].commitments.map(\.name) == ["Gym"])
}

private let everyWeekday: Set<Weekday> = [
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
]

@MainActor
@Test("a rhythm changed before days away begin holds before them and after them, and not on their days")
func aRhythmChangedBeforeDaysAwayBeginHoldsBeforeThemAndAfterThemAndNotOnTheirDays() throws {
    let places = Places()
    let gym = commitment("Gym", gymSchedule)
    try takeOn([gym], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    let made = try #require(commitments.whatItIsMadeOf(gym))

    let refusal = commitments.change(
        gym, toName: "Gym", on: .weekdays(everyWeekday), keptFrom: made.keptFrom, under: nil)

    #expect(refusal == nil)
    #expect(commitments.daysAway.map(\.title) == ["Mallorca"])
    let roster = try RosterStore(at: places.roster).roster
    for due in [monday12, date(2026, 10, 19), date(2026, 10, 20)] {
        #expect(isDue("Gym", on: due, in: roster))
    }
    var day = date(2026, 10, 13)
    for _ in 0..<6 {
        #expect(!isDue("Gym", on: day, in: roster))
        day = day.adding(days: 1)!
    }
}

@MainActor
@Test("a rhythm changed while days away are under way holds from the day after them")
func aRhythmChangedWhileDaysAwayAreUnderWayHoldsFromTheDayAfterThem() throws {
    let places = Places()
    let gym = commitment("Gym", gymSchedule)
    try takeOn([gym], at: places)
    screen(places).sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    let underWay = screen(places, asOf: date(2026, 10, 15))
    let made = try #require(underWay.whatItIsMadeOf(gym))

    let refusal = underWay.change(
        gym, toName: "Gym", on: .weekdays(everyWeekday), keptFrom: made.keptFrom, under: nil)

    #expect(refusal == nil)
    let roster = try RosterStore(at: places.roster).roster
    for due in [monday12, date(2026, 10, 19), date(2026, 10, 20)] {
        #expect(isDue("Gym", on: due, in: roster))
    }
    var day = date(2026, 10, 13)
    for _ in 0..<6 {
        #expect(!isDue("Gym", on: day, in: roster))
        day = day.adding(days: 1)!
    }
}

@MainActor
@Test("an every-N-days count changed before days away begins again on the day after them")
func anEveryNDaysCountChangedBeforeDaysAwayBeginsAgainOnTheDayAfterThem() throws {
    let places = Places()
    let nails = commitment(
        "Nails", .everyNDays(DayInterval(days: 4)!, from: date(2026, 10, 1)), keptFrom: date(2026, 10, 1))
    try takeOn([nails], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [nails])
    let made = try #require(commitments.whatItIsMadeOf(nails))

    let refusal = commitments.change(
        nails, toName: "Nails", on: .everyNDays(3), keptFrom: made.keptFrom, under: nil)

    #expect(refusal == nil)
    let roster = try RosterStore(at: places.roster).roster
    for due in [monday12, date(2026, 10, 19), date(2026, 10, 22)] {
        #expect(isDue("Nails", on: due, in: roster))
    }
    for notDue in [date(2026, 10, 15), date(2026, 10, 21), date(2026, 10, 24)] {
        #expect(!isDue("Nails", on: notDue, in: roster))
    }
}

@MainActor
@Test("the day kept from moved onto or past days away is refused, naming them")
func theDayKeptFromMovedOntoOrPastDaysAwayIsRefusedNamingThem() throws {
    let places = Places()
    let creatine = commitment("Creatine")
    try takeOn([creatine], at: places)
    let commitments = screen(places)
    commitments.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [creatine])
    let mallorca = try #require(commitments.daysAway.first)
    let before = try Data(contentsOf: places.roster)

    let onto = commitments.change(
        creatine, toName: "Creatine", on: .weekdays(everyWeekday), keptFrom: date(2026, 10, 13),
        under: nil)
    let past = commitments.change(
        creatine, toName: "Creatine", on: .weekdays(everyWeekday), keptFrom: date(2026, 10, 19),
        under: nil)

    #expect(onto == .keptFromMovedIntoDaysAway(mallorca))
    #expect(past == .keptFromMovedIntoDaysAway(mallorca))
    #expect(try Data(contentsOf: places.roster) == before)
    let allowed = commitments.change(
        creatine, toName: "Creatine", on: .weekdays(everyWeekday), keptFrom: monday12, under: nil)
    #expect(allowed == nil)
}

@MainActor
@Test("a roster shifts an every-N-days due day before days away said over it")
func aRosterShiftsAnEveryNDaysDueDayBeforeDaysAwaySaidOverIt() throws {
    let places = Places()
    let nails = commitment(
        "Nails", .everyNDays(DayInterval(days: 4)!, from: date(2026, 10, 1)), keptFrom: date(2026, 10, 1))
    try takeOn([nails], at: places)
    screen(places).sayDaysAway(
        named: "", from: date(2026, 10, 20), through: date(2026, 10, 25), over: [nails])
    let store = try RosterStore(at: places.roster)

    let shifted = try store.shift(nails, from: date(2026, 10, 13), to: date(2026, 10, 14))

    #expect(shifted)
    for due in [date(2026, 10, 14), date(2026, 10, 18), date(2026, 10, 26), date(2026, 10, 30)] {
        #expect(isDue("Nails", on: due, in: store.roster))
    }
    for notDue in [date(2026, 10, 13), date(2026, 10, 17)] {
        #expect(!isDue("Nails", on: notDue, in: store.roster))
    }
    let again = try store.shift(nails, from: date(2026, 10, 18), to: date(2026, 10, 20))
    #expect(!again)
}
