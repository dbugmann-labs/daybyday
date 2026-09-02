import Testing
import DayByDayKit

@Test("a day view holds a row for each commitment due on the date")
func aDayViewHoldsARowForEachCommitmentDueOnTheDate() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.monday, .thursday]), keptFrom: keptFrom)!
    let finances = Commitment(
        name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 25)!), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [gym, run, finances], on: monday, in: history)

    #expect(dayView.rows.count == 2)
    #expect(dayView.rows.map(\.name) == ["Gym", "Run"])
}
