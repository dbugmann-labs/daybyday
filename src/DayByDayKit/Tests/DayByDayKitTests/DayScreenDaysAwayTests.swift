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

private func commitment(_ name: String, _ schedule: Schedule = everyDay) -> Commitment {
    Commitment(name: name, schedule: schedule, keptFrom: januaryFirst, kind: .tick)!
}

private func takeOn(_ commitments: [Commitment], at places: Places) throws {
    let store = try RosterStore(at: places.roster)
    for commitment in commitments {
        try store.add(commitment)
    }
}

/// Days away said through a commitments screen opened at `places` as of `today`.
@MainActor
private func say(
    _ name: String, from first: CalendarDate, through last: CalendarDate, over commitments: [Commitment],
    at places: Places, asOf today: CalendarDate = monday12
) {
    CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs
    ).sayDaysAway(named: name, from: first, through: last, over: commitments)
}

@MainActor
private func dayScreen(_ places: Places, asOf today: CalendarDate) -> DayScreen {
    DayScreen(
        startingFrom: [], asOf: today, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs)
}

@MainActor
@Test("a day screen says the name of days away on each of their days, and nothing either side")
func aDayScreenSaysTheNameOfDaysAwayOnEachOfTheirDaysAndNothingEitherSide() throws {
    let places = Places()
    let gym = commitment("Gym", gymSchedule)
    let creatine = commitment("Creatine")
    try takeOn([gym, creatine], at: places)
    say("Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym], at: places)

    let thursday = dayScreen(places, asOf: date(2026, 10, 15))

    #expect(thursday.dayView.daysAwayInWords == ["Mallorca"])
    #expect(thursday.dayView.rows.map(\.name) == ["Creatine"])
    #expect(thursday.previousDayView?.daysAwayInWords == ["Mallorca"])
    #expect(thursday.nextDayView?.daysAwayInWords == ["Mallorca"])
    #expect(dayScreen(places, asOf: monday12).dayView.daysAwayInWords.isEmpty)
    #expect(dayScreen(places, asOf: date(2026, 10, 19)).dayView.daysAwayInWords.isEmpty)
}

@MainActor
@Test("days away with no name are said as Away, and two on one day in the order of their first days")
func daysAwayWithNoNameAreSaidAsAwayAndTwoOnOneDayInTheOrderOfTheirFirstDays() throws {
    let places = Places()
    let gym = commitment("Gym")
    let creatine = commitment("Creatine")
    try takeOn([gym, creatine], at: places)
    say("", from: date(2026, 10, 15), through: date(2026, 10, 16), over: [creatine], at: places)
    say("Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym], at: places)

    let thursday = dayScreen(places, asOf: date(2026, 10, 15))

    #expect(thursday.dayView.daysAwayInWords == ["Mallorca", "Away"])
    #expect(thursday.dayView.rows.isEmpty)
    #expect(dayScreen(places, asOf: date(2026, 10, 17)).dayView.daysAwayInWords == ["Mallorca"])
}

@MainActor
@Test("days away are said on days already gone, and on a first day a commitment is kept through")
func daysAwayAreSaidOnDaysAlreadyGoneAndOnAFirstDayACommitmentIsKeptThrough() throws {
    let places = Places()
    let creatine = commitment("Creatine")
    let magnesium = commitment("Magnesium")
    try takeOn([creatine, magnesium], at: places)
    try RecordStore(at: places.record).add(Tick(creatine, on: monday12)!)
    say(
        "", from: monday12, through: date(2026, 10, 14), over: [creatine, magnesium], at: places)

    let friday = dayScreen(places, asOf: date(2026, 10, 16))
    for _ in 0..<3 {
        friday.showPreviousDay()
    }

    #expect(friday.dayView.date == date(2026, 10, 13))
    #expect(friday.dayView.daysAwayInWords == ["Away"])
    #expect(friday.dayView.rows.isEmpty)
    friday.showPreviousDay()
    #expect(friday.dayView.daysAwayInWords == ["Away"])
    #expect(friday.dayView.rows.map(\.name) == ["Creatine"])
    #expect(friday.dayView.rows.map(\.isKept) == [true])
}

@MainActor
@Test("a day screen's week strip marks each day of days away as away, whatever is recorded")
func aDayScreensWeekStripMarksEachDayOfDaysAwayAsAwayWhateverIsRecorded() throws {
    let places = Places()
    let gym = commitment("Gym", gymSchedule)
    let creatine = commitment("Creatine")
    try takeOn([gym, creatine], at: places)
    say("Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym], at: places)

    let monday = dayScreen(places, asOf: monday12)

    let awayDays = monday.weekStrip.filter(\.isAway).compactMap(\.date)
    #expect(awayDays.map(\.day) == [13, 14, 15, 16, 17, 18])
    #expect(monday.weekStrip.first?.isAway == false)
    let before = monday.weekStrip
    try monday.tick(try #require(monday.dayView.rows.first { $0.name == "Creatine" }))
    #expect(monday.weekStrip.map(\.isAway) == before.map(\.isAway))

    let wednesday = dayScreen(places, asOf: date(2026, 10, 21))
    #expect(wednesday.previousWeekStrip?.filter(\.isAway).compactMap(\.date).map(\.day) == [13, 14, 15, 16, 17, 18])
    #expect(wednesday.weekStrip.contains(where: \.isAway) == false)
}

@MainActor
@Test("a weekly-quota row on today owing every day left before days away later in its week is marked Needed today")
func aWeeklyQuotaRowOnTodayOwingEveryDayLeftBeforeDaysAwayLaterInItsWeekIsMarkedNeededToday() throws {
    let places = Places()
    let yuno = Commitment(
        name: "Yuno", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 5)!), keptFrom: januaryFirst,
        kind: .tick)!
    try takeOn([yuno], at: places)
    say("", from: date(2026, 10, 16), through: date(2026, 10, 18), over: [yuno], at: places)
    try RecordStore(at: places.record).add(Tick(yuno, on: monday12)!)

    let wednesday = dayScreen(places, asOf: date(2026, 10, 14))
    let row = try #require(wednesday.dayView.rows.first)

    #expect(wednesday.dayView.rows.count == 1)
    #expect(row.rhythmInWords == "1/3x a week")
    #expect(!row.isKept)
    #expect(wednesday.mark(on: row) == "Needed today")
    let tuesday = dayScreen(places, asOf: date(2026, 10, 13))
    let tuesdayRow = try #require(tuesday.dayView.rows.first)
    #expect(tuesdayRow.rhythmInWords == "1/3x a week")
    #expect(tuesday.mark(on: tuesdayRow) == nil)
}
