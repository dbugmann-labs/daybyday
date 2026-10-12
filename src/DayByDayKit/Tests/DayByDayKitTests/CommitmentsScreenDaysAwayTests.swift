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
    "days away from a day already gone, ending before they begin, or over nothing are refused and keep nothing"
)
func daysAwayFromADayAlreadyGoneEndingBeforeTheyBeginOrOverNothingAreRefusedAndKeepNothing() throws {
    let places = Places()
    let gym = commitment("Gym")
    try takeOn([gym], at: places)
    let commitments = screen(places)
    let before = try Data(contentsOf: places.roster)

    let gone = commitments.sayDaysAway(
        named: "", from: date(2026, 10, 11), through: date(2026, 10, 13), over: [gym])
    let backwards = commitments.sayDaysAway(
        named: "", from: date(2026, 10, 14), through: date(2026, 10, 13), over: [gym])
    let overNothing = commitments.sayDaysAway(
        named: "", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [])

    #expect(gone == .firstDayHasPassed)
    #expect(backwards == .lastDayBeforeFirstDay)
    #expect(overNothing == .overNoCommitment)
    #expect(commitments.daysAway.isEmpty)
    #expect(try Data(contentsOf: places.roster) == before)
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
