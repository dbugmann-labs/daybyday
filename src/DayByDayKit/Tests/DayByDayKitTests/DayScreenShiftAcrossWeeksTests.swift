import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private let januaryFirst = date(2026, 1, 1)

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

@MainActor
private func screen(
    of commitment: Commitment, asOf today: CalendarDate, at places: Places = Places()
) -> DayScreen {
    DayScreen(
        startingFrom: [commitment], asOf: today, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOffs)
}

@MainActor
@Test("a day screen offers a one-weekday row the days between its due days either side, and a day-of-month row about a month each way, each said with its date")
func aDayScreenOffersAOneWeekdayRowTheDaysBetweenItsDueDaysEitherSideAndADayOfMonthRowAboutAMonthEachWayEachSaidWithItsDate() {
    let pool = Commitment(name: "Pool", schedule: .weekdays([.friday]), keptFrom: januaryFirst)!
    let poolScreen = screen(of: pool, asOf: date(2026, 9, 4))

    let poolDays = poolScreen.shiftDays(for: poolScreen.dayView.rows[0])

    #expect(poolDays.count == 12)
    #expect(poolDays.first?.date == date(2026, 8, 29))
    #expect(poolDays.first?.words == "Sat 29 Aug")
    #expect(poolDays.last?.date == date(2026, 9, 10))
    #expect(poolDays.last?.words == "Thu 10 Sep")
    #expect(!poolDays.contains { $0.date == date(2026, 9, 4) })
    #expect(poolDays.map(\.date) == poolDays.map(\.date).sorted { $0.days(until: $1) > 0 })

    let finances = Commitment(
        name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 31)!), keptFrom: januaryFirst)!
    let financesScreen = screen(of: finances, asOf: date(2026, 8, 31))

    let financesDays = financesScreen.shiftDays(for: financesScreen.dayView.rows[0])

    #expect(financesDays.count == 59)
    #expect(financesDays.first?.date == date(2026, 8, 1))
    #expect(financesDays.first?.words == "Sat 1 Aug")
    #expect(financesDays.last?.date == date(2026, 9, 29))
    #expect(financesDays.last?.words == "Tue 29 Sep")
}
