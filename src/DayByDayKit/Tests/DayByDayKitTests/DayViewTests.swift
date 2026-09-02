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

@Test("a day view holds no rows when none of the commitments is due")
func aDayViewHoldsNoRowsWhenNoneOfTheCommitmentsIsDue() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let finances = Commitment(
        name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 25)!), keptFrom: keptFrom)!
    let contactLensesStart = CalendarDate(year: 2026, month: 8, day: 25)!
    let contactLenses = Commitment(
        name: "Contact lenses", schedule: .everyNDays(DayInterval(days: 14)!, from: contactLensesStart),
        keptFrom: contactLensesStart)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [finances, contactLenses], on: monday, in: history)

    #expect(dayView.rows.isEmpty)
}

@Test("a commitment whose schedule is due but which is kept from a later day has no row")
func aCommitmentWhoseScheduleIsDueButWhichIsKeptFromALaterDayHasNoRow() {
    let keptFrom = CalendarDate(year: 2026, month: 9, day: 2)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let history = History()

    let onMonday = DayView(of: [gym], on: monday, in: history)
    let onWednesday = DayView(of: [gym], on: wednesday, in: history)

    #expect(onMonday.rows.isEmpty)
    #expect(onWednesday.rows.map(\.name) == ["Gym"])
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

@Test("a commitment not ticked on the date has a row that says it is not kept")
func aCommitmentNotTickedOnTheDateHasARowThatSaysItIsNotKept() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [gym], on: monday, in: history)

    #expect(dayView.rows.count == 1)
    #expect(dayView.rows[0].name == "Gym")
    #expect(!dayView.rows[0].isKept)
}

@Test("a tick for a commitment the day view was not handed adds no row")
func aTickForACommitmentTheDayViewWasNotHandedAddsNoRow() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.monday, .thursday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Tick(run, on: monday)!)

    let dayView = DayView(of: [gym], on: monday, in: history)

    #expect(dayView.rows.count == 1)
    #expect(dayView.rows[0].name == "Gym")
    #expect(!dayView.rows[0].isKept)
}

@Test("a tick on another date does not make the row say it is kept")
func aTickOnAnotherDateDoesNotMakeTheRowSayItIsKept() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let saturday = CalendarDate(year: 2026, month: 9, day: 5)!
    var history = History()
    history.add(Tick(gym, on: saturday)!)

    let onMonday = DayView(of: [gym], on: monday, in: history)
    let onSaturday = DayView(of: [gym], on: saturday, in: history)

    #expect(onMonday.rows.count == 1)
    #expect(!onMonday.rows[0].isKept)
    #expect(onSaturday.rows.count == 1)
    #expect(onSaturday.rows[0].isKept)
}

@Test("two commitments with the same name and different schedules each have their own row")
func twoCommitmentsWithTheSameNameAndDifferentSchedulesEachHaveTheirOwnRow() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gymOne = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let gymTwo = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .thursday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Tick(gymOne, on: monday)!)

    let dayView = DayView(of: [gymOne, gymTwo], on: monday, in: history)

    #expect(dayView.rows.count == 2)
    #expect(dayView.rows.map(\.name) == ["Gym", "Gym"])
    #expect(dayView.rows[0].isKept)
    #expect(!dayView.rows[1].isKept)
}

@Test("a day view of no commitments at all has no rows")
func aDayViewOfNoCommitmentsAtAllHasNoRows() {
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [], on: monday, in: history)

    #expect(dayView.rows.isEmpty)
}
