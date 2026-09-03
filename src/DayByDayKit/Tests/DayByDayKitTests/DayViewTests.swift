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

@Test("a commitment on a weekly quota has a row on every day of the week")
func aCommitmentOnAWeeklyQuotaHasARowOnEveryDayOfTheWeek() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let reading = Commitment(
        name: "Reading", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let week = [
        CalendarDate(year: 2026, month: 8, day: 31)!,
        CalendarDate(year: 2026, month: 9, day: 1)!,
        CalendarDate(year: 2026, month: 9, day: 2)!,
        CalendarDate(year: 2026, month: 9, day: 3)!,
        CalendarDate(year: 2026, month: 9, day: 4)!,
        CalendarDate(year: 2026, month: 9, day: 5)!,
        CalendarDate(year: 2026, month: 9, day: 6)!,
    ]
    let emptyHistory = History()

    let unticked = week.map { DayView(of: [reading], on: $0, in: emptyHistory) }

    for dayView in unticked {
        #expect(dayView.rows.count == 1)
        #expect(dayView.rows[0].name == "Reading")
        #expect(!dayView.rows[0].isKept)
    }

    var tickedHistory = History()
    let monday = week[0]
    let wednesday = week[2]
    let saturday = week[5]
    tickedHistory.add(Tick(reading, on: monday)!)
    tickedHistory.add(Tick(reading, on: wednesday)!)
    tickedHistory.add(Tick(reading, on: saturday)!)

    let ticked = week.map { DayView(of: [reading], on: $0, in: tickedHistory) }
    let keptDates = Set([monday, wednesday, saturday])

    for (date, dayView) in zip(week, ticked) {
        #expect(dayView.rows.count == 1)
        #expect(dayView.rows[0].isKept == keptDates.contains(date))
    }
}

@Test("a day view is formed in the first supported year and in the last")
func aDayViewIsFormedInTheFirstSupportedYearAndInTheLast() {
    let keptFrom = CalendarDate(year: 1583, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let firstYear = CalendarDate(year: 1583, month: 1, day: 3)!
    let lastYear = CalendarDate(year: 9999, month: 12, day: 27)!
    let history = History()

    let onFirstYear = DayView(of: [gym], on: firstYear, in: history)
    let onLastYear = DayView(of: [gym], on: lastYear, in: history)

    #expect(onFirstYear.rows.count == 1)
    #expect(onFirstYear.rows[0].name == "Gym")
    #expect(!onFirstYear.rows[0].isKept)
    #expect(onLastYear.rows.count == 1)
    #expect(onLastYear.rows[0].name == "Gym")
    #expect(!onLastYear.rows[0].isKept)
}

@Test("a row carries the commitment's name exactly as it was given")
func aRowCarriesTheCommitmentsNameExactlyAsItWasGiven() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let spaced = Commitment(name: " Gym ", schedule: schedule, keptFrom: keptFrom)!
    let emoji = Commitment(name: "🏋️", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [spaced, emoji], on: monday, in: history)

    #expect(dayView.rows.count == 2)
    #expect(dayView.rows[0].name == " Gym ")
    #expect(dayView.rows[1].name == "🏋️")
}

@Test("rows are in the order the commitments were handed over")
func rowsAreInTheOrderTheCommitmentsWereHandedOver() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.monday, .thursday]), keptFrom: keptFrom)!
    let vitamins = Commitment(
        name: "Vitamins",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [gym, run, vitamins], on: monday, in: history)

    #expect(dayView.rows.map(\.name) == ["Gym", "Run", "Vitamins"])
}

@Test("handing the same commitments in the opposite order reverses the rows")
func handingTheSameCommitmentsInTheOppositeOrderReversesTheRows() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.monday, .thursday]), keptFrom: keptFrom)!
    let vitamins = Commitment(
        name: "Vitamins",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [vitamins, run, gym], on: monday, in: history)

    #expect(dayView.rows.map(\.name) == ["Vitamins", "Run", "Gym"])
}

@Test("a kept commitment keeps its place among the ones that are not kept")
func aKeptCommitmentKeepsItsPlaceAmongTheOnesThatAreNotKept() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.monday, .thursday]), keptFrom: keptFrom)!
    let vitamins = Commitment(
        name: "Vitamins",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Tick(run, on: monday)!)

    let dayView = DayView(of: [gym, run, vitamins], on: monday, in: history)

    #expect(dayView.rows.map(\.name) == ["Gym", "Run", "Vitamins"])
    #expect(dayView.rows.map(\.isKept) == [false, true, false])
}

@Test("dropping a commitment that is not due leaves the others in their order")
func droppingACommitmentThatIsNotDueLeavesTheOthersInTheirOrder() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let finances = Commitment(
        name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 25)!), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.monday, .thursday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [gym, finances, run], on: monday, in: history)

    #expect(dayView.rows.map(\.name) == ["Gym", "Run"])
}

@Test("a commitment handed twice has two rows")
func aCommitmentHandedTwiceHasTwoRows() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [gym, gym], on: monday, in: history)

    #expect(dayView.rows.count == 2)
    #expect(dayView.rows.map(\.name) == ["Gym", "Gym"])
    #expect(dayView.rows.map(\.isKept) == [false, false])
}

@Test("two day views of the same commitments, date and history are the same day view")
func twoDayViewsOfTheSameCommitmentsDateAndHistoryAreTheSameDayView() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.monday, .thursday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Tick(gym, on: monday)!)

    let first = DayView(of: [gym, run], on: monday, in: history)
    let second = DayView(of: [gym, run], on: monday, in: history)

    #expect(first == second)
}

@Test("two day views of the same commitments and history on different dates are different day views")
func twoDayViewsOfTheSameCommitmentsAndHistoryOnDifferentDatesAreDifferentDayViews() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let history = History()

    let onMonday = DayView(of: [gym], on: monday, in: history)
    let onWednesday = DayView(of: [gym], on: wednesday, in: history)

    #expect(onMonday.rows.map(\.name) == ["Gym"])
    #expect(!onMonday.rows[0].isKept)
    #expect(onWednesday.rows.map(\.name) == ["Gym"])
    #expect(!onWednesday.rows[0].isKept)
    #expect(onMonday != onWednesday)
}

@Test("a day view does not change when the history it was built from is ticked afterwards")
func aDayViewDoesNotChangeWhenTheHistoryItWasBuiltFromIsTickedAfterwards() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()

    let before = DayView(of: [gym], on: monday, in: history)
    history.add(Tick(gym, on: monday)!)
    let after = DayView(of: [gym], on: monday, in: history)

    #expect(before.rows.count == 1)
    #expect(!before.rows[0].isKept)
    #expect(after.rows.count == 1)
    #expect(after.rows[0].isKept)
    #expect(before != after)
}

@Test("a day view of no commitments at all has no rows")
func aDayViewOfNoCommitmentsAtAllHasNoRows() {
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [], on: monday, in: history)

    #expect(dayView.rows.isEmpty)
}

@Test("two day views differing only in a commitment that is not due are the same day view")
func twoDayViewsDifferingOnlyInACommitmentThatIsNotDueAreTheSameDayView() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let finances = Commitment(
        name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 25)!), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let first = DayView(of: [gym], on: monday, in: history)
    let second = DayView(of: [gym, finances], on: monday, in: history)

    #expect(first.rows.map(\.name) == ["Gym"])
    #expect(!first.rows[0].isKept)
    #expect(second.rows.map(\.name) == ["Gym"])
    #expect(!second.rows[0].isKept)
    #expect(first == second)
}

@Test("two day views differing only in a tick for a commitment neither was handed are the same day view")
func twoDayViewsDifferingOnlyInATickForACommitmentNeitherWasHandedAreTheSameDayView() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.monday, .thursday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let noTicks = History()
    var withATick = History()
    withATick.add(Tick(run, on: monday)!)

    let first = DayView(of: [gym], on: monday, in: noTicks)
    let second = DayView(of: [gym], on: monday, in: withATick)

    #expect(first.rows.map(\.name) == ["Gym"])
    #expect(!first.rows[0].isKept)
    #expect(second.rows.map(\.name) == ["Gym"])
    #expect(!second.rows[0].isKept)
    #expect(first == second)
}

@Test("a row offers the tick for its commitment on the date the day view is of")
func aRowOffersTheTickForItsCommitmentOnTheDateTheDayViewIsOf() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [gym], on: monday, in: history)

    let tick = dayView.rows[0].tick(asOf: monday)

    #expect(tick != nil)
    #expect(tick == Tick(gym, on: monday))
}

@Test("adding the tick a row offers makes a day view formed again say the commitment is kept")
func addingTheTickARowOffersMakesADayViewFormedAgainSayTheCommitmentIsKept() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    let dayView = DayView(of: [gym], on: monday, in: history)

    let tick = dayView.rows[0].tick(asOf: monday)!
    history.add(tick)

    let dayViewAgain = DayView(of: [gym], on: monday, in: history)
    #expect(dayViewAgain.rows.count == 1)
    #expect(dayViewAgain.rows[0].name == "Gym")
    #expect(dayViewAgain.rows[0].isKept)
}

@Test("taking back the tick a row offers makes a day view formed again say the commitment is not kept")
func takingBackTheTickARowOffersMakesADayViewFormedAgainSayTheCommitmentIsNotKept() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Tick(gym, on: monday)!)
    let dayView = DayView(of: [gym], on: monday, in: history)

    let tick = dayView.rows[0].tick(asOf: monday)!
    history.remove(tick)

    #expect(dayView.rows[0].isKept)
    let dayViewAgain = DayView(of: [gym], on: monday, in: history)
    #expect(dayViewAgain.rows.count == 1)
    #expect(dayViewAgain.rows[0].name == "Gym")
    #expect(!dayViewAgain.rows[0].isKept)
}

@Test("a row already saying the commitment is kept offers the same tick")
func aRowAlreadySayingTheCommitmentIsKeptOffersTheSameTick() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let unticked = History()
    var ticked = History()
    ticked.add(Tick(gym, on: monday)!)

    let notKeptView = DayView(of: [gym], on: monday, in: unticked)
    let keptView = DayView(of: [gym], on: monday, in: ticked)

    #expect(!notKeptView.rows[0].isKept)
    #expect(keptView.rows[0].isKept)
    #expect(notKeptView.rows[0].tick(asOf: monday) == keptView.rows[0].tick(asOf: monday))
}

@Test("a row for a date later than the day it is asked as of offers no tick")
func aRowForADateLaterThanTheDayItIsAskedAsOfOffersNoTick() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [gym], on: wednesday, in: history)

    #expect(dayView.rows.map(\.name) == ["Gym"])
    #expect(dayView.rows[0].tick(asOf: monday) == nil)
}

@Test("a row for a date earlier than the day it is asked as of offers the tick")
func aRowForADateEarlierThanTheDayItIsAskedAsOfOffersTheTick() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let saturday = CalendarDate(year: 2026, month: 9, day: 5)!
    let history = History()

    let dayView = DayView(of: [gym], on: monday, in: history)

    let tick = dayView.rows[0].tick(asOf: saturday)

    #expect(tick != nil)
    #expect(tick == Tick(gym, on: monday))
}

@Test("a row for a date later than the day it is asked as of offers no tick even where it says the commitment is kept")
func aRowForADateLaterThanTheDayItIsAskedAsOfOffersNoTickEvenWhereItSaysTheCommitmentIsKept() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let saturday = CalendarDate(year: 2026, month: 9, day: 5)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Tick(gym, on: saturday)!)

    let dayView = DayView(of: [gym], on: saturday, in: history)

    #expect(dayView.rows[0].isKept)
    #expect(dayView.rows[0].tick(asOf: monday) == nil)
}

@Test("a row's answer follows the day it is asked as of rather than the day the day view was formed")
func aRowsAnswerFollowsTheDayItIsAskedAsOfRatherThanTheDayTheDayViewWasFormed() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!
    let history = History()

    let dayView = DayView(of: [gym], on: wednesday, in: history)
    let row = dayView.rows[0]

    #expect(row.tick(asOf: tuesday) == nil)
    #expect(row.tick(asOf: wednesday) == Tick(gym, on: wednesday))
}
