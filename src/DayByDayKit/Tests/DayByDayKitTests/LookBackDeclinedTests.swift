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

@MainActor
@Test("a month line says how many of its days were declined beside its fraction")
func aMonthLineSaysHowManyOfItsDaysWereDeclinedBesideItsFraction() throws {
    let (screen, gym) = try declinedGymScreen()

    let lookBack = screen.lookBack(at: gym)

    #expect(
        lookBack?.lines.contains(
            .month(inWords: "March 2026", fraction: "0/6", declinedInWords: "3 declined")) == true)
    #expect(
        lookBack?.lines.contains(
            .month(inWords: "January 2026", fraction: "0/13", declinedInWords: "1 declined"))
            == true)
    #expect(
        lookBack?.lines.contains(.month(inWords: "February 2026", fraction: "11/12")) == true)
}

@MainActor
@Test(
    "a declined day in a week a week line says is counted on its month line, and no week line says a declined count"
)
func aDeclinedDayInAWeekAWeekLineSaysIsCountedOnItsMonthLineAndNoWeekLineSaysADeclinedCount()
    throws
{
    let held = places()
    let old = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!),
        keptFrom: date(2026, 2, 23))!
    let new = Commitment(era: old, schedule: monWedSat, keptFrom: date(2026, 3, 4), kind: .tick)!
    let roster = try RosterStore(at: held.roster)
    try roster.add(old)
    try roster.put(era: new, on: old, keptUntil: date(2026, 3, 3), under: nil)
    let record = try RecordStore(at: held.record)
    for day in [date(2026, 2, 23), date(2026, 2, 25), date(2026, 2, 27), date(2026, 3, 2)] {
        try record.add(Tick(old, on: day)!)
    }
    for day in [date(2026, 3, 7), date(2026, 3, 9)] {
        try record.add(Tick(new, on: day)!)
    }
    try record.add(Decline(for: new, on: date(2026, 3, 4), reason: nil)!)
    let screen = CommitmentsScreen(
        asOf: date(2026, 3, 15), keepingRosterAt: held.roster, keepingRecordAt: held.record)

    let lookBack = screen.lookBack(at: new)

    #expect(
        lookBack?.lines == [
            .month(inWords: "March 2026", fraction: "2/5", declinedInWords: "1 declined"),
            .week(inWords: "2–8 Mar 2026", fraction: "1/1"),
            .week(inWords: "23 Feb – 1 Mar 2026", fraction: "3/3"),
        ])
    #expect(lookBack?.declinedInWords == "1")
}

private let everyDay = Schedule.weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])

@MainActor
@Test("a number commitment's look-back counts a day declined however long ago, and its graph says no point on one")
func aNumberCommitmentsLookBackCountsADayDeclinedHoweverLongAgoAndItsGraphSaysNoPointOnOne()
    throws
{
    let held = places()
    let weight = Commitment(
        name: "Weight", schedule: everyDay, keptFrom: date(2026, 1, 1), kind: .number(range: nil))!
    let protein = Commitment(
        name: "Protein", schedule: everyDay, keptFrom: date(2026, 3, 1),
        kind: .total(target: Commitment.Target(120)!))!
    let journal = Commitment(
        name: "Journal", schedule: everyDay, keptFrom: date(2026, 3, 1), kind: .note)!
    let roster = try RosterStore(at: held.roster)
    for commitment in [weight, protein, journal] {
        try roster.add(commitment)
    }
    let record = try RecordStore(at: held.record)
    try record.add(Number(72.5, for: weight, on: date(2026, 3, 1))!)
    try record.add(Decline(for: weight, on: date(2026, 1, 2), reason: nil)!)
    try record.add(Decline(for: weight, on: date(2026, 3, 10), reason: nil)!)
    try record.add(Addition(150, for: protein, on: date(2026, 3, 1))!)
    try record.add(Decline(for: protein, on: date(2026, 3, 3), reason: nil)!)
    try record.add(Note("Quiet day.", for: journal, on: date(2026, 3, 1))!)
    try record.add(Decline(for: journal, on: date(2026, 3, 3), reason: nil)!)

    let weightScreen = CommitmentsScreen(
        asOf: date(2026, 3, 15), keepingRosterAt: held.roster, keepingRecordAt: held.record)
    let weightLookBack = weightScreen.lookBack(at: weight)

    #expect(weightLookBack?.declinedInWords == "2")
    let graph = weightLookBack?.graph
    #expect(graph?.points.map(\.inWords) == ["72.5"])
    #expect(graph?.points.map { graph?.days[$0.day] } == ["1 March 2026"])
    #expect(graph?.averageInWords(over: .month) == "72.5")

    let smallScreen = CommitmentsScreen(
        asOf: date(2026, 3, 5), keepingRosterAt: held.roster, keepingRecordAt: held.record)
    let proteinLookBack = smallScreen.lookBack(at: protein)
    #expect(proteinLookBack?.declinedInWords == "1")
    #expect(proteinLookBack?.graph?.points.count == 1)
    let journalLookBack = smallScreen.lookBack(at: journal)
    #expect(journalLookBack?.declinedInWords == "1")
    #expect(journalLookBack?.notes.map(\.text) == ["Quiet day."])
    #expect(journalLookBack?.noteCountInWords == "1 note")
}

@MainActor
@Test("a look-back that says no graph or no note still counts its declined days")
func aLookBackThatSaysNoGraphOrNoNoteStillCountsItsDeclinedDays() throws {
    let held = places()
    let weight = Commitment(
        name: "Weight", schedule: everyDay, keptFrom: date(2026, 3, 1), kind: .number(range: nil))!
    let journal = Commitment(
        name: "Journal", schedule: everyDay, keptFrom: date(2026, 3, 1), kind: .note)!
    let roster = try RosterStore(at: held.roster)
    try roster.add(weight)
    try roster.add(journal)
    let record = try RecordStore(at: held.record)
    try record.add(Decline(for: weight, on: date(2026, 3, 3), reason: nil)!)
    try record.add(Decline(for: journal, on: date(2026, 3, 3), reason: nil)!)
    let screen = CommitmentsScreen(
        asOf: date(2026, 3, 5), keepingRosterAt: held.roster, keepingRecordAt: held.record)

    let weightLookBack = screen.lookBack(at: weight)
    let journalLookBack = screen.lookBack(at: journal)

    #expect(weightLookBack?.graph == nil)
    #expect(weightLookBack?.declinedInWords == "1")
    #expect(journalLookBack?.notes.isEmpty == true)
    #expect(journalLookBack?.noteCountInWords == nil)
    #expect(journalLookBack?.declinedInWords == "1")
}
