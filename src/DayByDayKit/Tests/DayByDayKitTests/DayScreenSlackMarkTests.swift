import Foundation
import Testing

@testable import DayByDayKit

private let newYear = CalendarDate(year: 2026, month: 1, day: 1)!
private let monday5 = CalendarDate(year: 2026, month: 10, day: 5)!
private let tuesday6 = CalendarDate(year: 2026, month: 10, day: 6)!
private let wednesday7 = CalendarDate(year: 2026, month: 10, day: 7)!
private let thursday8 = CalendarDate(year: 2026, month: 10, day: 8)!
private let saturday10 = CalendarDate(year: 2026, month: 10, day: 10)!
private let sunday11 = CalendarDate(year: 2026, month: 10, day: 11)!

private struct Places {
    let record: URL
    let roster: URL
    let oneOffs: URL

    init() {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        record = directory.appendingPathComponent("record.json")
        roster = directory.appendingPathComponent("roster.json")
        oneOffs = directory.appendingPathComponent("one-offs.json")
    }
}

private func quota(
    _ name: String, _ times: Int, from: CalendarDate = newYear,
    kind: Commitment.Kind = .tick
) -> Commitment {
    Commitment(
        name: name, schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: times)!), keptFrom: from,
        kind: kind)!
}

/// A day screen opened as of `today` over `commitment`, at `places`, where `ticks` were kept
/// before it was opened.
@MainActor
private func screen(
    of commitment: Commitment, asOf today: CalendarDate, keptOn ticks: [CalendarDate] = [],
    at places: Places = Places()
) throws -> DayScreen {
    if !ticks.isEmpty {
        let store = try RecordStore(at: places.record)
        for day in ticks {
            try store.add(Tick(commitment, on: day)!)
        }
    }
    return DayScreen(
        startingFrom: [commitment], asOf: today, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOffs)
}

@MainActor
private func onlyRow(_ screen: DayScreen) -> DayView.Row {
    screen.dayView.rows[0]
}

private let needed = "Needed today"

@MainActor
@Test("a weekly-quota row on today owing every day left in its week is marked Needed today")
func aWeeklyQuotaRowOnTodayOwingEveryDayLeftInItsWeekIsMarkedNeededToday() throws {
    let yuno = try screen(of: quota("Yuno", 5), asOf: thursday8, keptOn: [monday5])

    #expect(onlyRow(yuno).rhythmInWords == "1/5x a week")
    #expect(!onlyRow(yuno).isKept)
    #expect(yuno.mark(on: onlyRow(yuno)) == needed)

    let gym = try screen(of: quota("Gym", 3), asOf: sunday11, keptOn: [monday5, wednesday7])

    #expect(onlyRow(gym).rhythmInWords == "2/3x a week")
    #expect(gym.mark(on: onlyRow(gym)) == needed)
}

@MainActor
@Test("a weekly-quota row on today with a day to spare carries no mark")
func aWeeklyQuotaRowOnTodayWithADayToSpareCarriesNoMark() throws {
    let yuno = try screen(of: quota("Yuno", 5), asOf: thursday8, keptOn: [monday5, tuesday6])

    #expect(onlyRow(yuno).rhythmInWords == "2/5x a week")
    #expect(yuno.mark(on: onlyRow(yuno)) == nil)

    let wednesday = try screen(of: quota("Yuno", 5), asOf: wednesday7, keptOn: [monday5])

    #expect(onlyRow(wednesday).rhythmInWords == "1/5x a week")
    #expect(wednesday.mark(on: onlyRow(wednesday)) == nil)
}

@MainActor
@Test("a weekly-quota row on today whose week owes nothing more carries no mark")
func aWeeklyQuotaRowOnTodayWhoseWeekOwesNothingMoreCarriesNoMark() throws {
    let gym = try screen(
        of: quota("Gym", 3), asOf: thursday8, keptOn: [monday5, tuesday6, wednesday7])

    #expect(onlyRow(gym).rhythmInWords == "3/3x a week")
    #expect(gym.mark(on: onlyRow(gym)) == nil)

    let stretch = try screen(of: quota("Stretch", 1, from: saturday10), asOf: saturday10)

    #expect(onlyRow(stretch).rhythmInWords == "0/0x a week")
    #expect(stretch.mark(on: onlyRow(stretch)) == nil)
}

@MainActor
@Test("a weekly-quota row on today whose week can no longer be met carries no mark")
func aWeeklyQuotaRowOnTodayWhoseWeekCanNoLongerBeMetCarriesNoMark() throws {
    let yuno = try screen(of: quota("Yuno", 5), asOf: thursday8)

    #expect(onlyRow(yuno).rhythmInWords == "0/5x a week")
    #expect(!onlyRow(yuno).isKept)
    #expect(yuno.mark(on: onlyRow(yuno)) == nil)
}

@MainActor
@Test("a marked row loses its mark once ticked and has it back once the tick is taken back")
func aMarkedRowLosesItsMarkOnceTickedAndHasItBackOnceTheTickIsTakenBack() throws {
    let yuno = try screen(of: quota("Yuno", 5), asOf: thursday8, keptOn: [monday5])

    try yuno.tick(onlyRow(yuno))

    #expect(onlyRow(yuno).rhythmInWords == "2/5x a week")
    #expect(onlyRow(yuno).isKept)
    #expect(yuno.mark(on: onlyRow(yuno)) == nil)

    try yuno.tick(onlyRow(yuno))

    #expect(onlyRow(yuno).rhythmInWords == "1/5x a week")
    #expect(yuno.mark(on: onlyRow(yuno)) == needed)
}

@MainActor
@Test("a weekly-quota total row is marked while its day falls short of its target")
func aWeeklyQuotaTotalRowIsMarkedWhileItsDayFallsShortOfItsTarget() throws {
    let protein = quota("Protein", 5, kind: .total(target: Commitment.Target(120)!))
    let places = Places()
    let store = try RecordStore(at: places.record)
    try store.add(Addition(120, for: protein, on: monday5)!)
    try store.add(Addition(30, for: protein, on: thursday8)!)
    let screen = try screen(of: protein, asOf: thursday8, at: places)

    #expect(onlyRow(screen).rhythmInWords == "1/5x a week")
    #expect(!onlyRow(screen).isKept)
    #expect(screen.mark(on: onlyRow(screen)) == needed)

    try screen.enter("90", on: onlyRow(screen))

    #expect(onlyRow(screen).rhythmInWords == "2/5x a week")
    #expect(onlyRow(screen).isKept)
    #expect(screen.mark(on: onlyRow(screen)) == nil)
}

@MainActor
@Test("a week owing every day it holds is marked on today until a day of it is missed")
func aWeekOwingEveryDayItHoldsIsMarkedOnTodayUntilADayOfItIsMissed() throws {
    let monday = try screen(of: quota("Vitamins", 7), asOf: monday5)

    #expect(onlyRow(monday).rhythmInWords == "0/7x a week")
    #expect(monday.mark(on: onlyRow(monday)) == needed)

    let kept = try screen(of: quota("Vitamins", 7), asOf: wednesday7, keptOn: [monday5, tuesday6])

    #expect(onlyRow(kept).rhythmInWords == "2/7x a week")
    #expect(kept.mark(on: onlyRow(kept)) == needed)

    let missed = try screen(of: quota("Vitamins", 7), asOf: wednesday7, keptOn: [monday5])

    #expect(onlyRow(missed).rhythmInWords == "1/7x a week")
    #expect(missed.mark(on: onlyRow(missed)) == nil)

    let part = try screen(of: quota("Vitamins", 7, from: thursday8), asOf: thursday8)

    #expect(onlyRow(part).rhythmInWords == "0/4x a week")
    #expect(part.mark(on: onlyRow(part)) == needed)
}

@MainActor
@Test("a row on a schedule that is not a weekly quota carries no mark")
func aRowOnAScheduleThatIsNotAWeeklyQuotaCarriesNoMark() throws {
    let creatine = Commitment(
        name: "Creatine",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: newYear)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.tuesday, .thursday, .sunday]), keptFrom: newYear)!
    let places = Places()
    let screen = DayScreen(
        startingFrom: [creatine, run], asOf: thursday8, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOffs)

    #expect(screen.dayView.rows.map(\.rhythmInWords) == ["Every day", "Tue, Thu, Sun"])
    #expect(screen.dayView.rows.allSatisfy { !$0.isKept })
    #expect(screen.dayView.rows.allSatisfy { screen.mark(on: $0) == nil })
}

@MainActor
@Test("a day screen marks no row of the day before or the day after its today")
func aDayScreenMarksNoRowOfTheDayBeforeOrTheDayAfterItsToday() throws {
    let yuno = try screen(of: quota("Yuno", 5), asOf: thursday8)
    yuno.showPreviousDay()

    #expect(onlyRow(yuno).rhythmInWords == "0/5x a week")
    #expect(!onlyRow(yuno).isKept)
    #expect(yuno.mark(on: onlyRow(yuno)) == nil)

    let twoKept = try screen(of: quota("Yuno", 5), asOf: thursday8, keptOn: [monday5, tuesday6])
    let after = try #require(twoKept.nextDayView).rows[0]

    #expect(after.rhythmInWords == "2/5x a week")
    #expect(twoKept.mark(on: after) == nil)

    let oneKept = try screen(of: quota("Yuno", 5), asOf: thursday8, keptOn: [monday5])
    oneKept.showPreviousDay()
    let dayAfter = try #require(oneKept.nextDayView).rows[0]

    #expect(dayAfter.rhythmInWords == "1/5x a week")
    #expect(oneKept.mark(on: dayAfter) == needed)
}

@MainActor
@Test("a day screen marks by the today it was last handed, not by the day it is showing")
func aDayScreenMarksByTheTodayItWasLastHandedNotByTheDayItIsShowing() throws {
    let yuno = try screen(of: quota("Yuno", 5), asOf: wednesday7, keptOn: [monday5])
    yuno.showNextDay()

    #expect(onlyRow(yuno).rhythmInWords == "1/5x a week")
    #expect(yuno.mark(on: onlyRow(yuno)) == nil)

    yuno.shown(asOf: thursday8)

    #expect(onlyRow(yuno).date == thursday8)
    #expect(yuno.mark(on: onlyRow(yuno)) == needed)
}
