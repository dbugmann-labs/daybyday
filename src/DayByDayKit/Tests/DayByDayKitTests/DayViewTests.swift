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

    let dayView = DayView(of: [Commitment](), on: monday, in: history)

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
    #expect(notKeptView.rows[0].tick(asOf: monday) != nil)
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
    #expect(row.tick(asOf: wednesday) != nil)
    #expect(row.tick(asOf: wednesday) == Tick(gym, on: wednesday))
}

@Test("a row offers the tick in the first supported year and in the last")
func aRowOffersTheTickInTheFirstSupportedYearAndInTheLast() {
    let keptFrom = CalendarDate(year: 1583, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let firstYear = CalendarDate(year: 1583, month: 1, day: 3)!
    let lastYear = CalendarDate(year: 9999, month: 12, day: 27)!
    let history = History()

    let onFirstYear = DayView(of: [gym], on: firstYear, in: history)
    let onLastYear = DayView(of: [gym], on: lastYear, in: history)

    #expect(onFirstYear.rows[0].tick(asOf: firstYear) == Tick(gym, on: firstYear))
    #expect(onLastYear.rows[0].tick(asOf: lastYear) == Tick(gym, on: lastYear))
    #expect(onLastYear.rows[0].tick(asOf: firstYear) == nil)
}

@Test("every row of a day view whose date has not arrived offers no tick")
func everyRowOfADayViewWhoseDateHasNotArrivedOffersNoTick() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let vitamins = Commitment(
        name: "Vitamins",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let reading = Commitment(
        name: "Reading", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [gym, vitamins, reading], on: wednesday, in: history)

    #expect(dayView.rows.map(\.name) == ["Gym", "Vitamins", "Reading"])
    #expect(dayView.rows.allSatisfy { $0.tick(asOf: monday) == nil })
}

@Test("a row for a commitment on a weekly quota offers a tick even where its quota is already met")
func aRowForACommitmentOnAWeeklyQuotaOffersATickEvenWhereItsQuotaIsAlreadyMet() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let reading = Commitment(
        name: "Reading", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let saturday = CalendarDate(year: 2026, month: 9, day: 5)!
    let sunday = CalendarDate(year: 2026, month: 9, day: 6)!
    var history = History()
    history.add(Tick(reading, on: monday)!)
    history.add(Tick(reading, on: wednesday)!)
    history.add(Tick(reading, on: saturday)!)

    let dayView = DayView(of: [reading], on: sunday, in: history)

    #expect(dayView.rows.count == 1)
    #expect(dayView.rows[0].name == "Reading")
    #expect(!dayView.rows[0].isKept)
    #expect(dayView.rows[0].tick(asOf: sunday) != nil)
}

@Test("two rows for the same commitment and date saying the same thing are the same row")
func twoRowsForTheSameCommitmentAndDateSayingTheSameThingAreTheSameRow() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Tick(gym, on: monday)!)

    let first = DayView(of: [gym], on: monday, in: history)
    let second = DayView(of: [gym], on: monday, in: history)

    #expect(first.rows[0].isKept)
    #expect(second.rows[0].isKept)
    #expect(first.rows[0] == second.rows[0])
}

@Test("two rows for the same commitment on different dates are different rows")
func twoRowsForTheSameCommitmentOnDifferentDatesAreDifferentRows() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let history = History()

    let onMonday = DayView(of: [gym], on: monday, in: history)
    let onWednesday = DayView(of: [gym], on: wednesday, in: history)

    #expect(onMonday.rows[0].name == "Gym")
    #expect(!onMonday.rows[0].isKept)
    #expect(onWednesday.rows[0].name == "Gym")
    #expect(!onWednesday.rows[0].isKept)
    #expect(onMonday.rows[0] != onWednesday.rows[0])
}

@Test("moving to the day after gives the day view of the next date")
func movingToTheDayAfterGivesTheDayViewOfTheNextDate() {
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
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!
    let history = History()

    let onMonday = DayView(of: [gym, run, vitamins], on: monday, in: history)
    let movedTo = onMonday.nextDay(of: [gym, run, vitamins], in: history)

    let formedDirectly = DayView(of: [gym, run, vitamins], on: tuesday, in: history)

    #expect(movedTo?.rows.count == 1)
    #expect(movedTo?.rows[0].name == "Vitamins")
    #expect(movedTo?.rows[0].isKept == false)
    #expect(movedTo == formedDirectly)
}

@Test("moving to the day before gives the day view of the previous date")
func movingToTheDayBeforeGivesTheDayViewOfThePreviousDate() {
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
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!
    let history = History()

    let onWednesday = DayView(of: [gym, run, vitamins], on: wednesday, in: history)
    let movedTo = onWednesday.previousDay(of: [gym, run, vitamins], in: history)

    let formedDirectly = DayView(of: [gym, run, vitamins], on: tuesday, in: history)

    #expect(movedTo?.rows.count == 1)
    #expect(movedTo?.rows[0].name == "Vitamins")
    #expect(movedTo?.rows[0].isKept == false)
    #expect(movedTo == formedDirectly)
}

@Test("the rows of the day moved to are asked again rather than carried across")
func theRowsOfTheDayMovedToAreAskedAgainRatherThanCarriedAcross() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let vitamins = Commitment(
        name: "Vitamins",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Tick(vitamins, on: monday)!)

    let movedFrom = DayView(of: [vitamins], on: monday, in: history)
    let movedTo = movedFrom.nextDay(of: [vitamins], in: history)

    #expect(movedFrom.rows.count == 1)
    #expect(movedFrom.rows[0].isKept)
    #expect(movedTo?.rows.count == 1)
    #expect(movedTo?.rows[0].name == "Vitamins")
    #expect(movedTo?.rows[0].isKept == false)
}

@Test("a move uses the commitments and history it is handed rather than the ones the day view came from")
func aMoveUsesTheCommitmentsAndHistoryItIsHandedRatherThanTheOnesTheDayViewCameFrom() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let vitamins = Commitment(
        name: "Vitamins",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!
    let noTicks = History()
    var vitaminsTicked = History()
    vitaminsTicked.add(Tick(vitamins, on: tuesday)!)

    let movedFrom = DayView(of: [gym], on: monday, in: noTicks)
    let movedTo = movedFrom.nextDay(of: [vitamins], in: vitaminsTicked)

    #expect(movedTo?.rows.count == 1)
    #expect(movedTo?.rows[0].name == "Vitamins")
    #expect(movedTo?.rows[0].isKept == true)
    #expect(movedTo?.rows.map(\.name).contains("Gym") == false)
}

@Test("a day view moves onto a date that has not arrived, and its rows offer no tick")
func aDayViewMovesOntoADateThatHasNotArrivedAndItsRowsOfferNoTick() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let vitamins = Commitment(
        name: "Vitamins",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!
    let history = History()

    let movedFrom = DayView(of: [vitamins], on: monday, in: history)
    let movedTo = movedFrom.nextDay(of: [vitamins], in: history)

    #expect(movedTo?.rows.count == 1)
    #expect(movedTo?.rows[0].name == "Vitamins")
    #expect(movedTo?.rows[0].tick(asOf: monday) == nil)
    #expect(movedTo?.rows[0].tick(asOf: tuesday) == Tick(vitamins, on: tuesday))
}

@Test("moving to the day after and back again gives the day view it started from")
func movingToTheDayAfterAndBackAgainGivesTheDayViewItStartedFrom() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let vitamins = Commitment(
        name: "Vitamins",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Tick(gym, on: monday)!)

    let start = DayView(of: [gym, vitamins], on: monday, in: history)
    let there = start.nextDay(of: [gym, vitamins], in: history)
    let back = there?.previousDay(of: [gym, vitamins], in: history)

    #expect(back == start)

    let otherWayThere = start.previousDay(of: [gym, vitamins], in: history)
    let otherWayBack = otherWayThere?.nextDay(of: [gym, vitamins], in: history)

    #expect(otherWayBack == start)
}

@Test("moving does not skip a date on which nothing is due")
func movingDoesNotSkipADateOnWhichNothingIsDue() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let onMonday = DayView(of: [gym], on: monday, in: history)
    let onTuesday = onMonday.nextDay(of: [gym], in: history)
    let onWednesday = onTuesday?.nextDay(of: [gym], in: history)

    #expect(onTuesday?.rows.isEmpty == true)
    #expect(onWednesday?.rows.map(\.name) == ["Gym"])
}

@Test("moving across the end of a month")
func movingAcrossTheEndOfAMonth() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let vitamins = Commitment(
        name: "Vitamins",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let september30 = CalendarDate(year: 2026, month: 9, day: 30)!
    let october1 = CalendarDate(year: 2026, month: 10, day: 1)!
    let history = History()

    let onSeptember30 = DayView(of: [vitamins], on: september30, in: history)
    let movedTo = onSeptember30.nextDay(of: [vitamins], in: history)
    let formedDirectly = DayView(of: [vitamins], on: october1, in: history)

    #expect(movedTo == formedDirectly)
    #expect(movedTo?.previousDay(of: [vitamins], in: history) == onSeptember30)
}

@Test("moving across the turn of a year")
func movingAcrossTheTurnOfAYear() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let vitamins = Commitment(
        name: "Vitamins",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let december31 = CalendarDate(year: 2026, month: 12, day: 31)!
    let january1 = CalendarDate(year: 2027, month: 1, day: 1)!
    let history = History()

    let onDecember31 = DayView(of: [vitamins], on: december31, in: history)
    let movedTo = onDecember31.nextDay(of: [vitamins], in: history)
    let formedDirectly = DayView(of: [vitamins], on: january1, in: history)

    #expect(movedTo == formedDirectly)
    #expect(movedTo?.previousDay(of: [vitamins], in: history) == onDecember31)
}

@Test("moving across the leap day of a leap year")
func movingAcrossTheLeapDayOfALeapYear() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let vitamins = Commitment(
        name: "Vitamins",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let february28 = CalendarDate(year: 2028, month: 2, day: 28)!
    let february29 = CalendarDate(year: 2028, month: 2, day: 29)!
    let march1 = CalendarDate(year: 2028, month: 3, day: 1)!
    let history = History()

    let onFebruary28 = DayView(of: [vitamins], on: february28, in: history)
    let onFebruary29 = onFebruary28.nextDay(of: [vitamins], in: history)
    let onMarch1 = onFebruary29?.nextDay(of: [vitamins], in: history)

    #expect(onFebruary29 == DayView(of: [vitamins], on: february29, in: history))
    #expect(onMarch1 == DayView(of: [vitamins], on: march1, in: history))
}

@Test("moving across the end of February in a year that is not a leap year")
func movingAcrossTheEndOfFebruaryInAYearThatIsNotALeapYear() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let vitamins = Commitment(
        name: "Vitamins",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let february28 = CalendarDate(year: 2100, month: 2, day: 28)!
    let march1 = CalendarDate(year: 2100, month: 3, day: 1)!
    let history = History()

    let onFebruary28 = DayView(of: [vitamins], on: february28, in: history)
    let movedTo = onFebruary28.nextDay(of: [vitamins], in: history)
    let formedDirectly = DayView(of: [vitamins], on: march1, in: history)

    #expect(movedTo == formedDirectly)
    #expect(movedTo?.previousDay(of: [vitamins], in: history) == onFebruary28)
}

@Test("the first supported date has no day before it")
func theFirstSupportedDateHasNoDayBeforeIt() {
    let keptFrom = CalendarDate(year: 1583, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let january1 = CalendarDate(year: 1583, month: 1, day: 1)!
    let january2 = CalendarDate(year: 1583, month: 1, day: 2)!
    let history = History()

    let onJanuary1 = DayView(of: [gym], on: january1, in: history)
    let movedBack = onJanuary1.previousDay(of: [gym], in: history)
    let movedForward = onJanuary1.nextDay(of: [gym], in: history)

    #expect(movedBack == nil)
    #expect(movedForward == DayView(of: [gym], on: january2, in: history))
    #expect(movedForward?.rows.isEmpty == true)
}

@Test("the last supported date has no day after it")
func theLastSupportedDateHasNoDayAfterIt() {
    let keptFrom = CalendarDate(year: 1583, month: 1, day: 1)!
    let vitamins = Commitment(
        name: "Vitamins",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let december31 = CalendarDate(year: 9999, month: 12, day: 31)!
    let december30 = CalendarDate(year: 9999, month: 12, day: 30)!
    let history = History()

    let onDecember31 = DayView(of: [vitamins], on: december31, in: history)
    let movedForward = onDecember31.nextDay(of: [vitamins], in: history)
    let movedBack = onDecember31.previousDay(of: [vitamins], in: history)

    #expect(movedForward == nil)
    #expect(movedBack == DayView(of: [vitamins], on: december30, in: history))
    #expect(movedBack?.rows.map(\.name) == ["Vitamins"])
}

@Test("the date one day inside each end of the supported dates moves onto that end")
func theDateOneDayInsideEachEndOfTheSupportedDatesMovesOntoThatEnd() {
    let keptFrom = CalendarDate(year: 1583, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let vitamins = Commitment(
        name: "Vitamins",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let january2 = CalendarDate(year: 1583, month: 1, day: 2)!
    let january1 = CalendarDate(year: 1583, month: 1, day: 1)!
    let december30 = CalendarDate(year: 9999, month: 12, day: 30)!
    let december31 = CalendarDate(year: 9999, month: 12, day: 31)!
    let history = History()

    let onJanuary2 = DayView(of: [gym], on: january2, in: history)
    let movedToStart = onJanuary2.previousDay(of: [gym], in: history)

    #expect(movedToStart == DayView(of: [gym], on: january1, in: history))

    let onDecember30 = DayView(of: [vitamins], on: december30, in: history)
    let movedToEnd = onDecember30.nextDay(of: [vitamins], in: history)

    #expect(movedToEnd == DayView(of: [vitamins], on: december31, in: history))
}

@Test("the refusal at either end does not depend on what the day view holds")
func theRefusalAtEitherEndDoesNotDependOnWhatTheDayViewHolds() {
    let keptFrom = CalendarDate(year: 1583, month: 1, day: 1)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.monday, .thursday]), keptFrom: keptFrom)!
    let vitamins = Commitment(
        name: "Vitamins",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let january1 = CalendarDate(year: 1583, month: 1, day: 1)!
    let december31 = CalendarDate(year: 9999, month: 12, day: 31)!
    let noTicks = History()
    var vitaminsTicked = History()
    vitaminsTicked.add(Tick(vitamins, on: december31)!)

    let first = DayView(of: [run], on: january1, in: noTicks)
    let second = DayView(of: [vitamins], on: december31, in: vitaminsTicked)

    #expect(first.rows.isEmpty)
    #expect(first.previousDay(of: [run], in: noTicks) == nil)
    #expect(second.rows.count == 1)
    #expect(second.rows[0].isKept)
    #expect(second.nextDay(of: [vitamins], in: vitaminsTicked) == nil)
}

@Test("two rows for the same commitment and date differing in whether it is kept are different rows")
func twoRowsForTheSameCommitmentAndDateDifferingInWhetherItIsKeptAreDifferentRows() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let unticked = History()
    var ticked = History()
    ticked.add(Tick(gym, on: monday)!)

    let notKeptView = DayView(of: [gym], on: monday, in: unticked)
    let keptView = DayView(of: [gym], on: monday, in: ticked)

    #expect(notKeptView.rows[0] != keptView.rows[0])
}

@Test("a row says the rhythm its commitment runs on in words")
func aRowSaysTheRhythmItsCommitmentRunsOnInWords() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let finances = Commitment(
        name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 31)!), keptFrom: keptFrom)!
    let contactLenses = Commitment(
        name: "Contact lenses",
        schedule: .everyNDays(DayInterval(days: 14)!, from: CalendarDate(year: 2026, month: 8, day: 31)!),
        keptFrom: keptFrom)!
    let reading = Commitment(
        name: "Reading", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [gym, finances, contactLenses, reading], on: monday, in: history)

    #expect(dayView.rows.map(\.rhythmInWords) == [
        "Mon, Wed, Sat", "The 31st", "Every 14 days", "3x a week",
    ])
}

@Test("a row says its rhythm whether or not its commitment is kept")
func aRowSaysItsRhythmWhetherOrNotItsCommitmentIsKept() {
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
    #expect(notKeptView.rows[0].rhythmInWords == "Mon, Wed, Sat")
    #expect(keptView.rows[0].isKept)
    #expect(keptView.rows[0].rhythmInWords == "Mon, Wed, Sat")
}

@Test("a row for a day that has not arrived says its rhythm")
func aRowForADayThatHasNotArrivedSaysItsRhythm() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let friday = CalendarDate(year: 2026, month: 9, day: 4)!
    let thursday = CalendarDate(year: 2026, month: 9, day: 3)!
    let history = History()

    let dayView = DayView(of: [gym], on: friday, in: history)

    #expect(dayView.rows[0].tick(asOf: thursday) == nil)
    #expect(dayView.rows[0].rhythmInWords == "Every day")
}

@Test("two rows for commitments alike in name and not in rhythm say different rhythms")
func twoRowsForCommitmentsAlikeInNameAndNotInRhythmSayDifferentRhythms() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let vitaminsMondayWednesday = Commitment(
        name: "Vitamins", schedule: .weekdays([.monday, .wednesday]), keptFrom: keptFrom)!
    let vitaminsDaily = Commitment(
        name: "Vitamins",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [vitaminsMondayWednesday, vitaminsDaily], on: monday, in: history)

    #expect(dayView.rows.map(\.name) == ["Vitamins", "Vitamins"])
    #expect(dayView.rows[0].rhythmInWords == "Mon, Wed")
    #expect(dayView.rows[1].rhythmInWords == "Every day")
}

@Test("every weekday is said by its own name")
func everyWeekdayIsSaidByItsOwnName() {
    let days = [CalendarDate(year: 2026, month: 8, day: 31)!]
        + (1...6).map { CalendarDate(year: 2026, month: 9, day: $0)! }

    let titles = days.map { DayView(of: [Commitment](), on: $0, in: History()).title }

    #expect(titles == ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"])
}

@Test("two day views whose dates fall on the same weekday say the same day title")
func twoDayViewsWhoseDatesFallOnTheSameWeekdaySayTheSameDayTitle() {
    let days = [
        CalendarDate(year: 2026, month: 8, day: 31)!,
        CalendarDate(year: 2026, month: 6, day: 15)!,
        CalendarDate(year: 1583, month: 1, day: 3)!,
    ]

    let titles = days.map { DayView(of: [Commitment](), on: $0, in: History()).title }

    #expect(titles == ["Mon", "Mon", "Mon"])
}

@Test("a day view says its day in the first supported year and in the last")
func aDayViewSaysItsDayInTheFirstSupportedYearAndInTheLast() {
    let firstDay = CalendarDate(year: 1583, month: 1, day: 1)!
    let lastDay = CalendarDate(year: 9999, month: 12, day: 31)!

    let firstView = DayView(of: [Commitment](), on: firstDay, in: History())
    let lastView = DayView(of: [Commitment](), on: lastDay, in: History())

    #expect(firstView.title == "Sat")
    #expect(lastView.title == "Fri")
}

@Test("a day view says the leap day of a leap year")
func aDayViewSaysTheLeapDayOfALeapYear() {
    let leapDay = CalendarDate(year: 2028, month: 2, day: 29)!
    let dayView = DayView(of: [Commitment](), on: leapDay, in: History())

    #expect(dayView.title == "Tue")
}

@Test("a day view holding no rows says its day just the same")
func aDayViewHoldingNoRowsSaysItsDayJustTheSame() {
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let dayView = DayView(of: [Commitment](), on: wednesday, in: History())

    #expect(dayView.rows.isEmpty)
    #expect(dayView.title == "Wed")
}

@Test("a row for a commitment whose kind is not a tick offers nothing")
func aRowForACommitmentWhoseKindIsNotATickOffersNothing() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let weightTickKind = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .tick)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let sunday = CalendarDate(year: 2026, month: 9, day: 6)!
    let history = History()

    let dayView = DayView(of: [weight], on: monday, in: history)
    let tickKindDayView = DayView(of: [weightTickKind], on: monday, in: history)

    #expect(dayView.rows.count == 1)
    #expect(dayView.rows[0].name == "Weight")
    #expect(!dayView.rows[0].isKept)
    #expect(dayView.rows[0].tick(asOf: monday) == nil)
    #expect(dayView.rows[0].tick(asOf: sunday) == nil)
    #expect(tickKindDayView.rows[0].tick(asOf: monday) != nil)
}

@Test("a row offers the number entry for its commitment on the date the day view is of")
func aRowOffersTheNumberEntryForItsCommitmentOnTheDateTheDayViewIsOf() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [weight], on: monday, in: history)

    #expect(dayView.rows.count == 1)
    #expect(dayView.rows[0].name == "Weight")
    #expect(dayView.rows[0].numberEntry(asOf: monday) != nil)
}

@Test("a row for a commitment whose kind is not a number offers no number entry")
func aRowForACommitmentWhoseKindIsNotANumberOffersNoNumberEntry() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let water = Commitment(
        name: "Water", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [gym, journal, water], on: monday, in: history)
    let numberDayView = DayView(of: [weight], on: monday, in: history)

    #expect(dayView.rows.map(\.name) == ["Gym", "Journal", "Water"])
    #expect(dayView.rows.allSatisfy { $0.numberEntry(asOf: monday) == nil })
    #expect(numberDayView.rows[0].numberEntry(asOf: monday) != nil)
}

@Test("a row offers a tick or a number entry and never both")
func aRowOffersATickOrANumberEntryAndNeverBoth() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let weightTotal = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [gym, weight], on: monday, in: history)
    let noteDayView = DayView(of: [journal], on: monday, in: history)
    let totalDayView = DayView(of: [weightTotal], on: monday, in: history)

    #expect(dayView.rows.map(\.name) == ["Gym", "Weight"])
    #expect(dayView.rows[0].tick(asOf: monday) != nil)
    #expect(dayView.rows[0].numberEntry(asOf: monday) == nil)
    #expect(dayView.rows[1].numberEntry(asOf: monday) != nil)
    #expect(dayView.rows[1].tick(asOf: monday) == nil)
    #expect(noteDayView.rows[0].tick(asOf: monday) == nil)
    #expect(noteDayView.rows[0].numberEntry(asOf: monday) == nil)
    #expect(totalDayView.rows[0].tick(asOf: monday) == nil)
    #expect(totalDayView.rows[0].numberEntry(asOf: monday) == nil)
}

@Test("a row for a date later than the day it is asked as of offers no number entry")
func aRowForADateLaterThanTheDayItIsAskedAsOfOffersNoNumberEntry() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [weight], on: wednesday, in: history)

    #expect(dayView.rows.map(\.name) == ["Weight"])
    #expect(dayView.rows[0].numberEntry(asOf: monday) == nil)
    #expect(dayView.rows[0].tick(asOf: monday) == nil)
}

@Test(
  "a row for a date later than the day it is asked as of offers no number entry even where the day holds a number"
)
func aRowForADateLaterThanTheDayItIsAskedAsOfOffersNoNumberEntryEvenWhereTheDayHoldsANumber() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Number(70.5, for: weight, on: wednesday)!)

    let dayView = DayView(of: [weight], on: wednesday, in: history)

    #expect(dayView.rows[0].isKept)
    #expect(dayView.rows[0].numberEntry(asOf: monday) == nil)
}

@Test("a row for a date earlier than the day it is asked as of offers the number entry")
func aRowForADateEarlierThanTheDayItIsAskedAsOfOffersTheNumberEntry() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let saturday = CalendarDate(year: 2026, month: 9, day: 5)!
    let history = History()

    let dayView = DayView(of: [weight], on: monday, in: history)

    #expect(dayView.rows[0].numberEntry(asOf: saturday) != nil)
}

@Test("a row offers the number entry whether or not the day is already kept")
func aRowOffersTheNumberEntryWhetherOrNotTheDayIsAlreadyKept() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let unkept = History()
    var kept = History()
    kept.add(Number(70.5, for: weight, on: monday)!)

    let unkeptView = DayView(of: [weight], on: monday, in: unkept)
    let keptView = DayView(of: [weight], on: monday, in: kept)

    #expect(!unkeptView.rows[0].isKept)
    #expect(keptView.rows[0].isKept)
    #expect(unkeptView.rows[0].numberEntry(asOf: monday) != nil)
    #expect(keptView.rows[0].numberEntry(asOf: monday) != nil)
}

@Test("a number entry says the range its commitment declares as a hint")
func aNumberEntrySaysTheRangeItsCommitmentDeclaresAsAHint() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom,
        kind: .number(range: Commitment.Range(lowest: 40, highest: 150)!))!
    let mood = Commitment(
        name: "Mood", schedule: schedule, keptFrom: keptFrom,
        kind: .number(range: Commitment.Range(lowest: 1, highest: 10)!))!
    let fractional = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom,
        kind: .number(range: Commitment.Range(lowest: 40.5, highest: 150.25)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [weight, mood], on: monday, in: history)
    let fractionalDayView = DayView(of: [fractional], on: monday, in: history)

    #expect(dayView.rows[0].numberEntry(asOf: monday)?.hint == "40–150")
    #expect(dayView.rows[1].numberEntry(asOf: monday)?.hint == "1–10")
    #expect(fractionalDayView.rows[0].numberEntry(asOf: monday)?.hint == "40.5–150.25")
}

@Test("a number entry of a commitment that declares no range says no hint")
func aNumberEntryOfACommitmentThatDeclaresNoRangeSaysNoHint() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: nil))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [weight], on: monday, in: history)
    let entry = try #require(dayView.rows[0].numberEntry(asOf: monday))

    #expect(entry.hint == nil)
}

@Test("a number entry says the number the history holds for that commitment on that date")
func aNumberEntrySaysTheNumberTheHistoryHoldsForThatCommitmentOnThatDate() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Number(70.5, for: weight, on: monday)!)

    let dayView = DayView(of: [weight], on: monday, in: history)

    let entry = dayView.rows[0].numberEntry(asOf: monday)

    #expect(entry?.number == 70.5)
    #expect(entry?.number != 70)
    #expect(entry?.number != 71)
}

@Test("a number entry says no number where the day holds none")
func aNumberEntrySaysNoNumberWhereTheDayHoldsNone() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let neverRecorded = History()
    var addedThenRemoved = History()
    addedThenRemoved.add(Number(70.5, for: weight, on: monday)!)
    addedThenRemoved.removeNumber(for: weight, on: monday)

    let neverRecordedView = DayView(of: [weight], on: monday, in: neverRecorded)
    let addedThenRemovedView = DayView(of: [weight], on: monday, in: addedThenRemoved)

    let neverRecordedEntry = try #require(neverRecordedView.rows[0].numberEntry(asOf: monday))
    let addedThenRemovedEntry = try #require(
        addedThenRemovedView.rows[0].numberEntry(asOf: monday))

    #expect(neverRecordedEntry.number == nil)
    #expect(addedThenRemovedEntry.number == nil)
}

@Test(
  "a row for a number commitment holding a number says its name, its rhythm and that the day is kept"
)
func aRowForANumberCommitmentHoldingANumberSaysItsNameItsRhythmAndThatTheDayIsKept() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var historyWith70_5 = History()
    historyWith70_5.add(Number(70.5, for: weight, on: monday)!)
    var historyWith71 = History()
    historyWith71.add(Number(71, for: weight, on: monday)!)

    let dayView = DayView(of: [weight], on: monday, in: historyWith70_5)
    let otherDayView = DayView(of: [weight], on: monday, in: historyWith71)

    #expect(dayView.rows.count == 1)
    #expect(dayView.rows[0].name == "Weight")
    #expect(dayView.rows[0].rhythmInWords == "Mon, Wed, Sat")
    #expect(dayView.rows[0].isKept)
    #expect(otherDayView.rows[0].name == dayView.rows[0].name)
    #expect(otherDayView.rows[0].rhythmInWords == dayView.rows[0].rhythmInWords)
    #expect(otherDayView.rows[0].isKept == dayView.rows[0].isKept)
}

@Test("two rows for the same number commitment and date holding different numbers are different rows")
func twoRowsForTheSameNumberCommitmentAndDateHoldingDifferentNumbersAreDifferentRows() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var historyWith70_5 = History()
    historyWith70_5.add(Number(70.5, for: weight, on: monday)!)
    var historyWith71 = History()
    historyWith71.add(Number(71, for: weight, on: monday)!)

    let firstView = DayView(of: [weight], on: monday, in: historyWith70_5)
    let secondView = DayView(of: [weight], on: monday, in: historyWith71)

    #expect(firstView.rows[0].isKept)
    #expect(secondView.rows[0].isKept)
    #expect(firstView.rows[0] != secondView.rows[0])
}

@Test("two rows for the same number commitment and date holding the same number are the same row")
func twoRowsForTheSameNumberCommitmentAndDateHoldingTheSameNumberAreTheSameRow() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Number(70.5, for: weight, on: monday)!)

    let firstView = DayView(of: [weight], on: monday, in: history)
    let secondView = DayView(of: [weight], on: monday, in: history)

    #expect(firstView.rows[0].isKept)
    #expect(secondView.rows[0].isKept)
    #expect(firstView.rows[0] == secondView.rows[0])
}

@Test("a row offers the note entry for its commitment on the date the day view is of")
func aRowOffersTheNoteEntryForItsCommitmentOnTheDateTheDayViewIsOf() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [journal], on: monday, in: history)

    #expect(dayView.rows.count == 1)
    #expect(dayView.rows[0].name == "Journal")
    #expect(dayView.rows[0].noteEntry(asOf: monday) != nil)
}

@Test("a row for a commitment whose kind is not a note offers no note entry")
func aRowForACommitmentWhoseKindIsNotANoteOffersNoNoteEntry() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let water = Commitment(
        name: "Water", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [gym, weight, water], on: monday, in: history)
    let noteDayView = DayView(of: [journal], on: monday, in: history)

    #expect(dayView.rows.map(\.name) == ["Gym", "Weight", "Water"])
    #expect(dayView.rows.allSatisfy { $0.noteEntry(asOf: monday) == nil })
    #expect(noteDayView.rows[0].noteEntry(asOf: monday) != nil)
}

@Test("a row offers a tick, a number entry or a note entry and never two of them")
func aRowOffersATickANumberEntryOrANoteEntryAndNeverTwoOfThem() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let water = Commitment(
        name: "Water", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [gym, weight, journal], on: monday, in: history)
    let totalDayView = DayView(of: [water], on: monday, in: history)

    #expect(dayView.rows.map(\.name) == ["Gym", "Weight", "Journal"])
    #expect(dayView.rows[0].tick(asOf: monday) != nil)
    #expect(dayView.rows[0].numberEntry(asOf: monday) == nil)
    #expect(dayView.rows[0].noteEntry(asOf: monday) == nil)
    #expect(dayView.rows[1].numberEntry(asOf: monday) != nil)
    #expect(dayView.rows[1].tick(asOf: monday) == nil)
    #expect(dayView.rows[1].noteEntry(asOf: monday) == nil)
    #expect(dayView.rows[2].noteEntry(asOf: monday) != nil)
    #expect(dayView.rows[2].tick(asOf: monday) == nil)
    #expect(dayView.rows[2].numberEntry(asOf: monday) == nil)
    #expect(totalDayView.rows[0].tick(asOf: monday) == nil)
    #expect(totalDayView.rows[0].numberEntry(asOf: monday) == nil)
    #expect(totalDayView.rows[0].noteEntry(asOf: monday) == nil)
}

@Test("a row for a date later than the day it is asked as of offers no note entry")
func aRowForADateLaterThanTheDayItIsAskedAsOfOffersNoNoteEntry() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [journal], on: wednesday, in: history)

    #expect(dayView.rows.map(\.name) == ["Journal"])
    #expect(dayView.rows[0].noteEntry(asOf: monday) == nil)
    #expect(dayView.rows[0].numberEntry(asOf: monday) == nil)
    #expect(dayView.rows[0].tick(asOf: monday) == nil)
}

@Test("a row for a date later than the day it is asked as of offers no note entry even where the day holds a note")
func aRowForADateLaterThanTheDayItIsAskedAsOfOffersNoNoteEntryEvenWhereTheDayHoldsANote() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Note("Ran 8k.", for: journal, on: wednesday)!)

    let dayView = DayView(of: [journal], on: wednesday, in: history)

    #expect(dayView.rows[0].isKept)
    #expect(dayView.rows[0].noteEntry(asOf: monday) == nil)
}

@Test("a row for a date earlier than the day it is asked as of offers the note entry")
func aRowForADateEarlierThanTheDayItIsAskedAsOfOffersTheNoteEntry() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let saturday = CalendarDate(year: 2026, month: 9, day: 5)!
    let history = History()

    let dayView = DayView(of: [journal], on: monday, in: history)

    #expect(dayView.rows[0].noteEntry(asOf: saturday) != nil)
}

@Test("a row offers the note entry whether or not the day is already kept")
func aRowOffersTheNoteEntryWhetherOrNotTheDayIsAlreadyKept() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let notKeptHistory = History()
    var keptHistory = History()
    keptHistory.add(Note("Ran 8k.", for: journal, on: monday)!)

    let notKeptView = DayView(of: [journal], on: monday, in: notKeptHistory)
    let keptView = DayView(of: [journal], on: monday, in: keptHistory)

    #expect(!notKeptView.rows[0].isKept)
    #expect(keptView.rows[0].isKept)
    #expect(notKeptView.rows[0].noteEntry(asOf: monday) != nil)
    #expect(keptView.rows[0].noteEntry(asOf: monday) != nil)
}

@Test("two rows for the same note commitment and date holding different notes are different rows")
func twoRowsForTheSameNoteCommitmentAndDateHoldingDifferentNotesAreDifferentRows() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var historyWithRan = History()
    historyWithRan.add(Note("Ran 8k.", for: journal, on: monday)!)
    var historyWithRested = History()
    historyWithRested.add(Note("Rested.", for: journal, on: monday)!)

    let firstView = DayView(of: [journal], on: monday, in: historyWithRan)
    let secondView = DayView(of: [journal], on: monday, in: historyWithRested)

    #expect(firstView.rows[0].isKept)
    #expect(secondView.rows[0].isKept)
    #expect(firstView.rows[0] != secondView.rows[0])
}

@Test("two rows for the same note commitment and date holding the same note are the same row")
func twoRowsForTheSameNoteCommitmentAndDateHoldingTheSameNoteAreTheSameRow() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Note("Ran 8k.", for: journal, on: monday)!)

    let firstView = DayView(of: [journal], on: monday, in: history)
    let secondView = DayView(of: [journal], on: monday, in: history)

    #expect(firstView.rows[0].isKept)
    #expect(secondView.rows[0].isKept)
    #expect(firstView.rows[0] == secondView.rows[0])
}

@Test("a note entry says a note of many lines and many characters whole")
func aNoteEntrySaysANoteOfManyLinesAndManyCharactersWhole() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let threeLines = "Line one\nLine two\nLine three"
    let long = String(repeating: "a", count: 100_000)
    var threeLinesHistory = History()
    threeLinesHistory.add(Note(threeLines, for: journal, on: monday)!)
    var longHistory = History()
    longHistory.add(Note(long, for: journal, on: monday)!)

    let threeLinesView = DayView(of: [journal], on: monday, in: threeLinesHistory)
    let longView = DayView(of: [journal], on: monday, in: longHistory)

    #expect(threeLinesView.rows[0].noteEntry(asOf: monday)?.note == threeLines)
    #expect(longView.rows[0].noteEntry(asOf: monday)?.note == long)
}

@Test("a note entry says no note where the day holds none")
func aNoteEntrySaysNoNoteWhereTheDayHoldsNone() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let neverRecorded = History()
    var addedThenRemoved = History()
    addedThenRemoved.add(Note("Ran 8k.", for: journal, on: monday)!)
    addedThenRemoved.removeNote(for: journal, on: monday)

    let neverRecordedView = DayView(of: [journal], on: monday, in: neverRecorded)
    let addedThenRemovedView = DayView(of: [journal], on: monday, in: addedThenRemoved)

    #expect(neverRecordedView.rows[0].noteEntry(asOf: monday)?.note == nil)
    #expect(addedThenRemovedView.rows[0].noteEntry(asOf: monday)?.note == nil)
}

@Test("a row for a note commitment holding a note says its name, its rhythm and that the day is kept")
func aRowForANoteCommitmentHoldingANoteSaysItsNameItsRhythmAndThatTheDayIsKept() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let journal = Commitment(
        name: "Journal", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var ranHistory = History()
    ranHistory.add(Note("Ran 8k.", for: journal, on: monday)!)
    var restedHistory = History()
    restedHistory.add(Note("Rested.", for: journal, on: monday)!)

    let ranView = DayView(of: [journal], on: monday, in: ranHistory)
    let restedView = DayView(of: [journal], on: monday, in: restedHistory)

    #expect(ranView.rows.count == 1)
    #expect(ranView.rows[0].name == "Journal")
    #expect(ranView.rows[0].rhythmInWords == "Mon, Wed, Sat")
    #expect(ranView.rows[0].isKept)
    #expect(restedView.rows[0].name == "Journal")
    #expect(restedView.rows[0].rhythmInWords == "Mon, Wed, Sat")
    #expect(restedView.rows[0].isKept)
}

@Test("a row offers the total entry for its commitment on the date the day view is of")
func aRowOffersTheTotalEntryForItsCommitmentOnTheDateTheDayViewIsOf() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [protein], on: monday, in: history)

    #expect(dayView.rows.count == 1)
    #expect(dayView.rows[0].name == "Protein")
    #expect(dayView.rows[0].totalEntry(asOf: monday) != nil)
}

@Test("a row for a commitment whose kind is not a total offers no total entry")
func aRowForACommitmentWhoseKindIsNotATotalOffersNoTotalEntry() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [gym, weight, journal], on: monday, in: history)
    let totalDayView = DayView(of: [protein], on: monday, in: history)

    #expect(dayView.rows.map(\.name) == ["Gym", "Weight", "Journal"])
    #expect(dayView.rows.allSatisfy { $0.totalEntry(asOf: monday) == nil })
    #expect(totalDayView.rows[0].totalEntry(asOf: monday) != nil)
}

@Test("a row offers a tick, a number entry, a note entry or a total entry and never two of them")
func aRowOffersATickANumberEntryANoteEntryOrATotalEntryAndNeverTwoOfThem() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [gym, weight, journal, protein], on: monday, in: history)

    #expect(dayView.rows.map(\.name) == ["Gym", "Weight", "Journal", "Protein"])
    #expect(dayView.rows[0].tick(asOf: monday) != nil)
    #expect(dayView.rows[0].numberEntry(asOf: monday) == nil)
    #expect(dayView.rows[0].noteEntry(asOf: monday) == nil)
    #expect(dayView.rows[0].totalEntry(asOf: monday) == nil)
    #expect(dayView.rows[1].numberEntry(asOf: monday) != nil)
    #expect(dayView.rows[1].tick(asOf: monday) == nil)
    #expect(dayView.rows[1].noteEntry(asOf: monday) == nil)
    #expect(dayView.rows[1].totalEntry(asOf: monday) == nil)
    #expect(dayView.rows[2].noteEntry(asOf: monday) != nil)
    #expect(dayView.rows[2].tick(asOf: monday) == nil)
    #expect(dayView.rows[2].numberEntry(asOf: monday) == nil)
    #expect(dayView.rows[2].totalEntry(asOf: monday) == nil)
    #expect(dayView.rows[3].totalEntry(asOf: monday) != nil)
    #expect(dayView.rows[3].tick(asOf: monday) == nil)
    #expect(dayView.rows[3].numberEntry(asOf: monday) == nil)
    #expect(dayView.rows[3].noteEntry(asOf: monday) == nil)
}

@Test("a row for a date later than the day it is asked as of offers no total entry")
func aRowForADateLaterThanTheDayItIsAskedAsOfOffersNoTotalEntry() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [protein], on: wednesday, in: history)

    #expect(dayView.rows.map(\.name) == ["Protein"])
    #expect(dayView.rows[0].totalEntry(asOf: monday) == nil)
    #expect(dayView.rows[0].noteEntry(asOf: monday) == nil)
    #expect(dayView.rows[0].numberEntry(asOf: monday) == nil)
    #expect(dayView.rows[0].tick(asOf: monday) == nil)
}

@Test("a row for a date later than the day it is asked as of offers no total entry even where the day holds additions")
func aRowForADateLaterThanTheDayItIsAskedAsOfOffersNoTotalEntryEvenWhereTheDayHoldsAdditions() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Addition(30, for: protein, on: wednesday)!)
    history.add(Addition(90, for: protein, on: wednesday)!)

    let dayView = DayView(of: [protein], on: wednesday, in: history)

    #expect(dayView.rows[0].isKept)
    #expect(dayView.rows[0].totalEntry(asOf: monday) == nil)
}

@Test("a row for a date earlier than the day it is asked as of offers the total entry")
func aRowForADateEarlierThanTheDayItIsAskedAsOfOffersTheTotalEntry() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let saturday = CalendarDate(year: 2026, month: 9, day: 5)!
    let history = History()

    let dayView = DayView(of: [protein], on: monday, in: history)

    #expect(dayView.rows[0].totalEntry(asOf: saturday) != nil)
}

@Test("a row offers the total entry whether or not the day is already kept")
func aRowOffersTheTotalEntryWhetherOrNotTheDayIsAlreadyKept() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var notKeptHistory = History()
    notKeptHistory.add(Addition(30, for: protein, on: monday)!)
    var keptHistory = History()
    keptHistory.add(Addition(120, for: protein, on: monday)!)

    let notKeptView = DayView(of: [protein], on: monday, in: notKeptHistory)
    let keptView = DayView(of: [protein], on: monday, in: keptHistory)

    #expect(!notKeptView.rows[0].isKept)
    #expect(keptView.rows[0].isKept)
    #expect(notKeptView.rows[0].totalEntry(asOf: monday) != nil)
    #expect(keptView.rows[0].totalEntry(asOf: monday) != nil)
}

@Test("a total entry says the day's sum and the commitment's target")
func aTotalEntrySaysTheDaysSumAndTheCommitmentsTarget() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let protein120 = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let protein0_5 = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(0.5)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history120 = History()
    history120.add(Addition(30, for: protein120, on: monday)!)
    history120.add(Addition(45.5, for: protein120, on: monday)!)
    var history0_5 = History()
    history0_5.add(Addition(30, for: protein0_5, on: monday)!)
    history0_5.add(Addition(45.5, for: protein0_5, on: monday)!)

    let view120 = DayView(of: [protein120], on: monday, in: history120)
    let view0_5 = DayView(of: [protein0_5], on: monday, in: history0_5)

    #expect(view120.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "75.5 of 120")
    #expect(view0_5.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "75.5 of 0.5")
}

@Test("a total entry of a day holding no addition says a sum of zero")
func aTotalEntryOfADayHoldingNoAdditionSaysASumOfZero() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let neverRecorded = History()
    var addedThenTakenBack = History()
    addedThenTakenBack.add(Addition(30, for: protein, on: monday)!)
    addedThenTakenBack.removeLastAddition(for: protein, on: monday)

    let neverRecordedView = DayView(of: [protein], on: monday, in: neverRecorded)
    let addedThenTakenBackView = DayView(of: [protein], on: monday, in: addedThenTakenBack)

    #expect(neverRecordedView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "0 of 120")
    #expect(addedThenTakenBackView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "0 of 120")
}

@Test("a total entry says the true sum once it has passed the target")
func aTotalEntrySaysTheTrueSumOnceItHasPassedTheTarget() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Addition(120, for: protein, on: monday)!)
    history.add(Addition(30, for: protein, on: monday)!)

    let dayView = DayView(of: [protein], on: monday, in: history)

    #expect(dayView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "150 of 120")
    #expect(dayView.rows[0].isKept)
}

@Test("a row for a total commitment says its name, its rhythm and whether the day is kept, and never its sum")
func aRowForATotalCommitmentSaysItsNameItsRhythmAndWhetherTheDayIsKeptAndNeverItsSum() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history30 = History()
    history30.add(Addition(30, for: protein, on: monday)!)
    var history90 = History()
    history90.add(Addition(90, for: protein, on: monday)!)

    let view30 = DayView(of: [protein], on: monday, in: history30)
    let view90 = DayView(of: [protein], on: monday, in: history90)

    #expect(view30.rows.count == 1)
    #expect(view30.rows[0].name == "Protein")
    #expect(view30.rows[0].rhythmInWords == "Mon, Wed, Sat")
    #expect(!view30.rows[0].isKept)
    #expect(view90.rows[0].name == "Protein")
    #expect(view90.rows[0].rhythmInWords == "Mon, Wed, Sat")
    #expect(!view90.rows[0].isKept)
}

@Test("a row whose day holds an addition offers taking the last one back")
func aRowWhoseDayHoldsAnAdditionOffersTakingTheLastOneBack() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history30 = History()
    history30.add(Addition(30, for: protein, on: monday)!)
    var historyPastTarget = History()
    historyPastTarget.add(Addition(120, for: protein, on: monday)!)
    historyPastTarget.add(Addition(30, for: protein, on: monday)!)

    let view30 = DayView(of: [protein], on: monday, in: history30)
    let viewPastTarget = DayView(of: [protein], on: monday, in: historyPastTarget)

    #expect(view30.rows[0].offersTakeBackLast(asOf: monday))
    #expect(viewPastTarget.rows[0].isKept)
    #expect(viewPastTarget.rows[0].offersTakeBackLast(asOf: monday))
}

@Test("a row whose day holds no addition offers no take-back")
func aRowWhoseDayHoldsNoAdditionOffersNoTakeBack() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let neverRecorded = History()
    var addedThenTakenBack = History()
    addedThenTakenBack.add(Addition(30, for: protein, on: monday)!)
    addedThenTakenBack.removeLastAddition(for: protein, on: monday)

    let neverRecordedView = DayView(of: [protein], on: monday, in: neverRecorded)
    let addedThenTakenBackView = DayView(of: [protein], on: monday, in: addedThenTakenBack)

    #expect(!neverRecordedView.rows[0].offersTakeBackLast(asOf: monday))
    #expect(!addedThenTakenBackView.rows[0].offersTakeBackLast(asOf: monday))
    #expect(neverRecordedView.rows[0].totalEntry(asOf: monday) != nil)
    #expect(addedThenTakenBackView.rows[0].totalEntry(asOf: monday) != nil)
}

@Test("a row for a commitment whose kind is not a total offers no take-back")
func aRowForACommitmentWhoseKindIsNotATotalOffersNoTakeBack() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Tick(gym, on: monday)!)
    history.add(Number(70.5, for: weight, on: monday)!)
    history.add(Note("Ran 8k.", for: journal, on: monday)!)

    let dayView = DayView(of: [gym, weight, journal], on: monday, in: history)

    #expect(dayView.rows.allSatisfy { !$0.offersTakeBackLast(asOf: monday) })
}

@Test("a row for a date later than the day it is asked as of offers no take-back")
func aRowForADateLaterThanTheDayItIsAskedAsOfOffersNoTakeBack() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Addition(30, for: protein, on: wednesday)!)

    let dayView = DayView(of: [protein], on: wednesday, in: history)

    #expect(!dayView.rows[0].offersTakeBackLast(asOf: monday))
    #expect(dayView.rows[0].offersTakeBackLast(asOf: wednesday))
}

@Test("a row goes on offering the take-back while the day still holds an addition")
func aRowGoesOnOfferingTheTakeBackWhileTheDayStillHoldsAnAddition() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Addition(30, for: protein, on: monday)!)
    history.add(Addition(90, for: protein, on: monday)!)
    history.removeLastAddition(for: protein, on: monday)

    let onceTakenBackView = DayView(of: [protein], on: monday, in: history)

    #expect(onceTakenBackView.rows[0].offersTakeBackLast(asOf: monday))
    #expect(onceTakenBackView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "30 of 120")

    history.removeLastAddition(for: protein, on: monday)
    let twiceTakenBackView = DayView(of: [protein], on: monday, in: history)

    #expect(!twiceTakenBackView.rows[0].offersTakeBackLast(asOf: monday))
    #expect(twiceTakenBackView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "0 of 120")
}

@Test(
    "two rows for the same total commitment and date whose days have added different amounts are different rows"
)
func twoRowsForTheSameTotalCommitmentAndDateWhoseDaysHaveAddedDifferentAmountsAreDifferentRows() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var historyWith30 = History()
    historyWith30.add(Addition(30, for: protein, on: monday)!)
    var historyWith90 = History()
    historyWith90.add(Addition(90, for: protein, on: monday)!)

    let firstView = DayView(of: [protein], on: monday, in: historyWith30)
    let secondView = DayView(of: [protein], on: monday, in: historyWith90)

    #expect(!firstView.rows[0].isKept)
    #expect(!secondView.rows[0].isKept)
    #expect(firstView.rows[0] != secondView.rows[0])
}

@Test(
    "two rows for the same total commitment and date whose days have added the same amount are the same row"
)
func twoRowsForTheSameTotalCommitmentAndDateWhoseDaysHaveAddedTheSameAmountAreTheSameRow() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Addition(30, for: protein, on: monday)!)

    let firstView = DayView(of: [protein], on: monday, in: history)
    let secondView = DayView(of: [protein], on: monday, in: history)

    #expect(!firstView.rows[0].isKept)
    #expect(!secondView.rows[0].isKept)
    #expect(firstView.rows[0] == secondView.rows[0])
}

@Test("two rows whose days hold different additions summing alike are the same row")
func twoRowsWhoseDaysHoldDifferentAdditionsSummingAlikeAreTheSameRow() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var historyWithTwoAdditions = History()
    historyWithTwoAdditions.add(Addition(30, for: protein, on: monday)!)
    historyWithTwoAdditions.add(Addition(30, for: protein, on: monday)!)
    var historyWithOneAddition = History()
    historyWithOneAddition.add(Addition(60, for: protein, on: monday)!)

    let firstView = DayView(of: [protein], on: monday, in: historyWithTwoAdditions)
    let secondView = DayView(of: [protein], on: monday, in: historyWithOneAddition)

    #expect(firstView.rows[0] == secondView.rows[0])
    #expect(firstView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "60 of 120")
    #expect(secondView.rows[0].totalEntry(asOf: monday)?.soFarOfTarget == "60 of 120")
}

@Test("a day view handed commitments with no grouping holds one group with no category")
func aDayViewHandedCommitmentsWithNoGroupingHoldsOneGroupWithNoCategory() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let run = Commitment(
        name: "Run", schedule: .weekdays([.monday, .thursday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [gym, run], on: monday, in: history)

    #expect(dayView.groups.map(\.category) == [nil])
    #expect(dayView.groups.first?.rows.map(\.name) == ["Gym", "Run"])

    let groupedDayView = DayView(
        of: [Roster.Group(category: nil, commitments: [gym, run])], on: monday, in: history)

    #expect(dayView == groupedDayView)
}

@Test("a day view holds one group for each group it was handed that has something due")
func aDayViewHoldsOneGroupForEachGroupItWasHandedThatHasSomethingDue() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(
        of: [
            Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
            Roster.Group(category: "Sport", commitments: [gym]),
            Roster.Group(category: nil, commitments: [journaling]),
        ], on: monday, in: history)

    #expect(dayView.groups.map(\.category) == ["Supplements", "Sport", nil])
    #expect(dayView.rows.map(\.name) == ["Creatine", "Magnesium", "Gym", "Journaling"])
}

@Test("a day view draws no group whose commitments are none of them due on the date")
func aDayViewDrawsNoGroupWhoseCommitmentsAreNoneOfThemDueOnTheDate() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let finances = Commitment(
        name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 25)!), keptFrom: keptFrom)!
    let gym = Commitment(
        name: "Gym",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!
    let history = History()

    let dayView = DayView(
        of: [
            Roster.Group(category: "Money", commitments: [finances]),
            Roster.Group(category: "Sport", commitments: [gym]),
        ], on: tuesday, in: history)

    #expect(dayView.groups.map(\.category) == ["Sport"])
    #expect(dayView.groups.first?.rows.map(\.name) == ["Gym"])
}

@Test("a day view handed only groups with nothing due holds no groups at all")
func aDayViewHandedOnlyGroupsWithNothingDueHoldsNoGroupsAtAll() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let finances = Commitment(
        name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 25)!), keptFrom: keptFrom)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!
    let history = History()

    let dayView = DayView(
        of: [Roster.Group(category: "Money", commitments: [finances])], on: tuesday, in: history)

    #expect(dayView.groups.isEmpty)
    #expect(dayView.rows.isEmpty)
    #expect(dayView == DayView(of: [Commitment](), on: tuesday, in: history))
}

@Test("a day view drops the commitments that are not due and keeps the group its due ones are in")
func aDayViewDropsTheCommitmentsThatAreNotDueAndKeepsTheGroupItsDueOnesAreIn() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(
        name: "Creatine",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom)!
    let vitaminD = Commitment(
        name: "Vitamin D", schedule: .dayOfMonth(DayOfMonth(day: 25)!), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(
        of: [Roster.Group(category: "Supplements", commitments: [creatine, vitaminD])],
        on: monday, in: history)

    #expect(dayView.groups.map(\.category) == ["Supplements"])
    #expect(dayView.groups.first?.rows.map(\.name) == ["Creatine"])
}

@Test("a day view does not combine two groups under the same category")
func aDayViewDoesNotCombineTwoGroupsUnderTheSameCategory() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(
        of: [
            Roster.Group(category: "Supplements", commitments: [creatine]),
            Roster.Group(category: "Sport", commitments: [gym]),
            Roster.Group(category: "Supplements", commitments: [magnesium]),
        ], on: monday, in: history)

    #expect(dayView.groups.map(\.category) == ["Supplements", "Sport", "Supplements"])
    #expect(dayView.rows.map(\.name) == ["Creatine", "Gym", "Magnesium"])
}

@Test("a row in a group says whether its commitment is kept, exactly as a row under no category does")
func aRowInAGroupSaysWhetherItsCommitmentIsKeptExactlyAsARowUnderNoCategoryDoes() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var history = History()
    history.add(Tick(magnesium, on: monday)!)

    let dayView = DayView(
        of: [Roster.Group(category: "Supplements", commitments: [creatine, magnesium])],
        on: monday, in: history)

    #expect(dayView.groups.map(\.category) == ["Supplements"])
    let rows = dayView.groups.first?.rows ?? []
    #expect(rows.map(\.name) == ["Creatine", "Magnesium"])
    #expect(rows.map(\.isKept) == [false, true])
}

@Test("two day views differing only in how their commitments were grouped are different day views")
func twoDayViewsDifferingOnlyInHowTheirCommitmentsWereGroupedAreDifferentDayViews() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let ungrouped = DayView(
        of: [Roster.Group(category: nil, commitments: [creatine, magnesium])], on: monday,
        in: history)
    let grouped = DayView(
        of: [Roster.Group(category: "Supplements", commitments: [creatine, magnesium])],
        on: monday, in: history)

    #expect(ungrouped.rows.map(\.name) == ["Creatine", "Magnesium"])
    #expect(grouped.rows.map(\.name) == ["Creatine", "Magnesium"])
    #expect(ungrouped != grouped)
}

@Test("two day views differing only in a group none of whose commitments is due are the same day view")
func twoDayViewsDifferingOnlyInAGroupNoneOfWhoseCommitmentsIsDueAreTheSameDayView() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym",
        schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let finances = Commitment(
        name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 25)!), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let first = DayView(
        of: [Roster.Group(category: nil, commitments: [gym])], on: monday, in: history)
    let second = DayView(
        of: [
            Roster.Group(category: nil, commitments: [gym]),
            Roster.Group(category: "Money", commitments: [finances]),
        ], on: monday, in: history)

    #expect(first.groups.map(\.category) == [nil])
    #expect(first.groups.first?.rows.map(\.name) == ["Gym"])
    #expect(first == second)
}

@Test("a row of every kind offers something on a day that has arrived")
func aRowOfEveryKindOffersSomethingOnADayThatHasArrived() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let target = Commitment.Target(120)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom, kind: .total(target: target))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [gym, weight, journal, protein], on: monday, in: history)

    #expect(dayView.rows.map(\.name) == ["Gym", "Weight", "Journal", "Protein"])
    #expect(dayView.rows.allSatisfy { $0.offersAnything(asOf: monday) })
}

@Test("no row of a day view whose date has not arrived offers anything")
func noRowOfADayViewWhoseDateHasNotArrivedOffersAnything() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let target = Commitment.Target(120)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom, kind: .total(target: target))!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let history = History()

    let dayView = DayView(of: [gym, weight, journal, protein], on: wednesday, in: history)

    #expect(dayView.rows.map(\.name) == ["Gym", "Weight", "Journal", "Protein"])
    #expect(dayView.rows.allSatisfy { !$0.offersAnything(asOf: monday) })
}

@Test("a row for a date earlier than the day it is asked as of offers something")
func aRowForADateEarlierThanTheDayItIsAskedAsOfOffersSomething() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let saturday = CalendarDate(year: 2026, month: 9, day: 5)!
    let history = History()

    let dayView = DayView(of: [gym], on: monday, in: history)
    let row = dayView.rows[0]

    #expect(row.offersAnything(asOf: saturday))
    #expect(row.tick(asOf: saturday) == Tick(gym, on: monday))
}

@Test("a row's answer about offering anything follows the day it is asked as of")
func aRowsAnswerAboutOfferingAnythingFollowsTheDayItIsAskedAsOf() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let tuesday = CalendarDate(year: 2026, month: 9, day: 1)!
    let history = History()

    let dayView = DayView(of: [weight], on: wednesday, in: history)
    let row = dayView.rows[0]

    #expect(!row.offersAnything(asOf: tuesday))
    #expect(row.offersAnything(asOf: wednesday))
}

@Test("a row offers something whether or not its day says the commitment is kept")
func aRowOffersSomethingWhetherOrNotItsDaySaysTheCommitmentIsKept() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var keptHistory = History()
    keptHistory.add(Tick(gym, on: monday)!)

    let notKeptDayView = DayView(of: [gym], on: monday, in: History())
    let keptDayView = DayView(of: [gym], on: monday, in: keptHistory)

    #expect(!notKeptDayView.rows[0].isKept)
    #expect(keptDayView.rows[0].isKept)
    #expect(notKeptDayView.rows[0].offersAnything(asOf: monday))
    #expect(keptDayView.rows[0].offersAnything(asOf: monday))
}

@Test("a total row whose day holds no addition offers something")
func aTotalRowWhoseDayHoldsNoAdditionOffersSomething() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let target = Commitment.Target(120)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom, kind: .total(target: target))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var addedHistory = History()
    addedHistory.add(Addition(30, for: protein, on: monday)!)

    let emptyDayView = DayView(of: [protein], on: monday, in: History())
    let addedDayView = DayView(of: [protein], on: monday, in: addedHistory)

    #expect(!emptyDayView.rows[0].offersTakeBackLast(asOf: monday))
    #expect(addedDayView.rows[0].offersTakeBackLast(asOf: monday))
    #expect(emptyDayView.rows[0].offersAnything(asOf: monday))
    #expect(addedDayView.rows[0].offersAnything(asOf: monday))
}

@Test("a row offers something on its own date in the first supported year and in the last")
func aRowOffersSomethingOnItsOwnDateInTheFirstSupportedYearAndInTheLast() {
    let firstKeptFrom = CalendarDate(year: 1583, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let firstGym = Commitment(name: "Gym", schedule: schedule, keptFrom: firstKeptFrom)!
    let firstDate = CalendarDate(year: 1583, month: 1, day: 3)!
    let history = History()

    let firstDayView = DayView(of: [firstGym], on: firstDate, in: history)
    #expect(firstDayView.rows[0].offersAnything(asOf: firstDate))

    let lastDate = CalendarDate(year: 9999, month: 12, day: 27)!
    let lastDayView = DayView(of: [firstGym], on: lastDate, in: history)
    #expect(lastDayView.rows[0].offersAnything(asOf: lastDate))
    #expect(!lastDayView.rows[0].offersAnything(asOf: firstDate))
}
