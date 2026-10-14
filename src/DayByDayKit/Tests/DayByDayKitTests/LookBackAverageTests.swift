import Foundation
import Testing

@testable import DayByDayKit

private let everyDay: Schedule = .weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

/// A fresh pair of places under one fresh temporary directory.
private func freshPlaces() -> (roster: URL, record: URL) {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    return (
        directory.appendingPathComponent("roster.json"),
        directory.appendingPathComponent("record.json")
    )
}

/// The graph of a number commitment kept every day from `keptFrom`, holding `numbers`, as of `today`.
@MainActor
private func weightGraph(
    name: String = "Weight", range: Commitment.Range? = nil, keptFrom: CalendarDate, keptUntil: CalendarDate? = nil,
    numbers: [(CalendarDate, Decimal)], today: CalendarDate
) throws -> LookBack.Graph? {
    let places = freshPlaces()
    let weight = Commitment(
        name: name, schedule: everyDay, keptFrom: keptFrom, kind: .number(range: range))!
    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(weight)
    if let keptUntil { try rosterStore.retire(weight, keptUntil: keptUntil) }
    let recordStore = try RecordStore(at: places.record)
    for (day, value) in numbers { try recordStore.add(Number(value, for: weight, on: day)!) }
    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    return screen.lookBack(at: weight)?.graph
}

@MainActor
@Test("a graph averages the points among each span's newest days")
func aGraphAveragesThePointsAmongEachSpansNewestDays() throws {
    let graph = try weightGraph(
        keptFrom: date(2025, 1, 1),
        numbers: [
            (date(2025, 3, 30), 60), (date(2025, 3, 31), 70), (date(2025, 12, 29), 74),
            (date(2025, 12, 30), 80), (date(2026, 2, 28), 79), (date(2026, 3, 1), 82),
            (date(2026, 3, 31), 85),
        ],
        today: date(2026, 3, 31))

    #expect(graph?.averageInWords(over: .month) == "83.5")
    #expect(graph?.averageInWords(over: .threeMonths) == "81.5")
    #expect(graph?.averageInWords(over: .year) == "78.3")
    #expect(graph?.averageInWords(over: .all) == "75.7")
}

@MainActor
@Test("a span longer than its graph's days averages every point the graph says")
func aSpanLongerThanItsGraphsDaysAveragesEveryPointTheGraphSays() throws {
    let graph = try weightGraph(
        keptFrom: date(2026, 3, 1), numbers: [(date(2026, 3, 1), 70), (date(2026, 3, 5), 73)],
        today: date(2026, 3, 10))

    #expect(graph?.averageInWords(over: .month) == "71.5")
    #expect(graph?.averageInWords(over: .threeMonths) == "71.5")
    #expect(graph?.averageInWords(over: .year) == "71.5")
    #expect(graph?.averageInWords(over: .all) == "71.5")
}

@MainActor
@Test("a stopped commitment's spans end on the day it was kept until")
func aStoppedCommitmentsSpansEndOnTheDayItWasKeptUntil() throws {
    let graph = try weightGraph(
        keptFrom: date(2026, 1, 1), keptUntil: date(2026, 1, 31),
        numbers: [(date(2026, 1, 15), 80), (date(2026, 3, 4), 90)], today: date(2026, 3, 31))

    #expect(graph?.averageInWords(over: .month) == "80")
}

@MainActor
@Test("a graph says no average over a span holding no point")
func aGraphSaysNoAverageOverASpanHoldingNoPoint() throws {
    let graph = try weightGraph(
        keptFrom: date(2026, 1, 1), numbers: [(date(2026, 1, 15), 80)], today: date(2026, 3, 31))

    #expect(graph != nil)
    #expect(graph?.averageInWords(over: .month) == nil)
    #expect(graph?.averageInWords(over: .threeMonths) == "80")
    #expect(graph?.averageInWords(over: .year) == "80")
    #expect(graph?.averageInWords(over: .all) == "80")
}

@MainActor
@Test("a total commitment's average takes in each day's sum across a change of target, and says no target")
func aTotalCommitmentsAverageTakesInEachDaysSumAcrossAChangeOfTargetAndSaysNoTarget() throws {
    let places = freshPlaces()
    let older = Commitment(
        name: "Protein", schedule: everyDay, keptFrom: date(2026, 3, 1),
        kind: .total(target: Commitment.Target(120)!))!
    let newer = Commitment(
        era: older, schedule: everyDay, keptFrom: date(2026, 3, 4),
        kind: .total(target: Commitment.Target(100)!))!
    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(older)
    try rosterStore.put(era: newer, on: older, keptUntil: date(2026, 3, 3), under: nil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Addition(100, for: older, on: date(2026, 3, 2))!)
    try recordStore.add(Addition(50, for: older, on: date(2026, 3, 2))!)
    try recordStore.add(Addition(85, for: newer, on: date(2026, 3, 5))!)
    let screen = CommitmentsScreen(
        asOf: date(2026, 3, 8), keepingRosterAt: places.roster, keepingRecordAt: places.record)

    #expect(screen.lookBack(at: newer)?.graph?.averageInWords(over: .month) == "117.5")
}

@MainActor
@Test("a graph's average takes in no number the record holds for a day of a gap")
func aGraphsAverageTakesInNoNumberTheRecordHoldsForADayOfAGap() throws {
    let places = freshPlaces()
    let older = Commitment(
        name: "Weight", schedule: everyDay, keptFrom: date(2026, 3, 1), kind: .number(range: nil))!
    let newer = Commitment(
        era: older, schedule: everyDay, keptFrom: date(2026, 3, 6), kind: .number(range: nil))!
    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(older)
    try rosterStore.put(era: newer, on: older, keptUntil: date(2026, 3, 3), under: nil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Number(72, for: older, on: date(2026, 3, 2))!)
    try recordStore.add(Number(90, for: older, on: date(2026, 3, 4))!)
    try recordStore.add(Number(70, for: newer, on: date(2026, 3, 7))!)
    let screen = CommitmentsScreen(
        asOf: date(2026, 3, 8), keepingRosterAt: places.roster, keepingRecordAt: places.record)

    #expect(screen.lookBack(at: newer)?.graph?.averageInWords(over: .month) == "71")
}

@MainActor
@Test("a look-back says an average to one decimal place")
func aLookBackSaysAnAverageToOneDecimalPlace() throws {
    let first = try weightGraph(
        keptFrom: date(2026, 3, 1),
        numbers: [(date(2026, 3, 1), 80), (date(2026, 3, 2), 81), (date(2026, 3, 3), 83)],
        today: date(2026, 3, 3))
    let second = try weightGraph(
        keptFrom: date(2026, 3, 1),
        numbers: [(date(2026, 3, 1), 100), (date(2026, 3, 2), 101), (date(2026, 3, 3), 101)],
        today: date(2026, 3, 3))
    let third = try weightGraph(
        keptFrom: date(2026, 3, 1), numbers: [(date(2026, 3, 1), 72.2), (date(2026, 3, 2), 72.3)],
        today: date(2026, 3, 3))

    #expect(first?.averageInWords(over: .month) == "81.3")
    #expect(second?.averageInWords(over: .month) == "100.7")
    #expect(third?.averageInWords(over: .month) == "72.3")
}

@MainActor
@Test(
    "a look-back says an average rounding to a whole number with no fraction and no separator between thousands"
)
func aLookBackSaysAnAverageRoundingToAWholeNumberWithNoFractionAndNoSeparatorBetweenThousands()
    throws
{
    let weight = try weightGraph(
        keptFrom: date(2026, 3, 1), numbers: [(date(2026, 3, 1), 74.9), (date(2026, 3, 2), 75.02)],
        today: date(2026, 3, 2))
    let steps = try weightGraph(
        name: "Steps", keptFrom: date(2026, 3, 1),
        numbers: [(date(2026, 3, 1), 12000), (date(2026, 3, 2), 12002)], today: date(2026, 3, 2))

    #expect(weight?.averageInWords(over: .month) == "75")
    #expect(steps?.averageInWords(over: .month) == "12001")
}

@MainActor
@Test(
    "a look-back rounds a halfway average below zero away from zero, and says one rounding to zero as 0"
)
func aLookBackRoundsAHalfwayAverageBelowZeroAwayFromZeroAndSaysOneRoundingToZeroAs0() throws {
    let range = Commitment.Range(lowest: -10, highest: 10)
    let halfway = try weightGraph(
        name: "Balance", range: range, keptFrom: date(2026, 3, 1),
        numbers: [(date(2026, 3, 1), -1), (date(2026, 3, 2), -2.5)], today: date(2026, 3, 2))
    let zero = try weightGraph(
        name: "Balance", range: range, keptFrom: date(2026, 3, 1),
        numbers: [(date(2026, 3, 1), 0.02), (date(2026, 3, 2), -0.1)], today: date(2026, 3, 2))

    #expect(halfway?.averageInWords(over: .month) == "-1.8")
    #expect(zero?.averageInWords(over: .month) == "0")
}
