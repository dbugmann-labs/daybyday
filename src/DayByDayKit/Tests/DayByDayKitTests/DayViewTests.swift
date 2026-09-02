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

@Test("a commitment not due on the date has no row")
func aCommitmentNotDueOnTheDateHasNoRow() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!
    let history = History()

    let dayView = DayView(of: [gym], on: tuesday, in: history)

    #expect(dayView.rows.isEmpty)
}

@Test("a commitment ticked on the date has a row that says it is kept")
func aCommitmentTickedOnTheDateHasARowThatSaysItIsKept() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Tick(gym, on: monday)!)

    let dayView = DayView(of: [gym], on: monday, in: history)

    #expect(dayView.rows.count == 1)
    #expect(dayView.rows[0].name == "Gym")
    #expect(dayView.rows[0].isKept)
}
