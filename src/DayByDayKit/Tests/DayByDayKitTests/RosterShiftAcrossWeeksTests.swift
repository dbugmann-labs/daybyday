import Foundation
import Testing
@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private let januaryFirst = date(2026, 1, 1)

private func pool() -> Commitment {
    Commitment(name: "Pool", schedule: .weekdays([.friday]), keptFrom: januaryFirst)!
}

private func gym() -> Commitment {
    Commitment(name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: januaryFirst)!
}

private func finances() -> Commitment {
    Commitment(name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 31)!), keptFrom: januaryFirst)!
}

@Test("a roster shifts a one-weekday due day onto any day between its due days either side, a week crossed or not")
func aRosterShiftsAOneWeekdayDueDayOntoAnyDayBetweenItsDueDaysEitherSideAWeekCrossedOrNot() {
    let landings = [date(2026, 8, 29), date(2026, 9, 3), date(2026, 9, 5), date(2026, 9, 7), date(2026, 9, 10)]
    var rosters: [(Roster, Commitment)] = []
    var answers: [Bool] = []
    for landing in landings {
        var roster = Roster()
        let commitment = pool()
        _ = roster.add(commitment)
        answers.append(roster.shift(commitment, from: date(2026, 9, 4), to: landing))
        rosters.append((roster, commitment))
    }

    #expect(answers == [true, true, true, true, true])
    for (roster, commitment) in rosters {
        #expect(roster.eras(of: commitment).count == 1)
        #expect(roster.keptFrom(of: commitment) == januaryFirst)
        #expect(roster.eras(of: commitment).first?.rhythmInWords == "Fri")
    }
    let keeps = rosters[3].0.commitments[0]
    #expect(keeps.isDue(on: date(2026, 9, 7)))
    #expect(keeps.isDue(on: date(2026, 9, 11)))
    #expect(!keeps.isDue(on: date(2026, 9, 4)))
}

@Test("a roster refuses to shift a one-weekday due day onto its due day either side or a day beyond them")
func aRosterRefusesToShiftAOneWeekdayDueDayOntoItsDueDayEitherSideOrADayBeyondThem() {
    var roster = Roster()
    let commitment = pool()
    _ = roster.add(commitment)

    var answers: [Bool] = []
    for other in [date(2026, 8, 27), date(2026, 8, 28), date(2026, 9, 11), date(2026, 9, 12)] {
        answers.append(roster.shift(commitment, from: date(2026, 9, 4), to: other))
    }

    #expect(answers == [false, false, false, false])
    let keeps = roster.commitments[0]
    #expect(keeps.isDue(on: date(2026, 9, 4)))
    #expect(keeps.isDue(on: date(2026, 9, 11)))
}

@Test("a weekday-set due day is shifted past its own due days inside its week, and outside it only up to them")
func aWeekdaySetDueDayIsShiftedPastItsOwnDueDaysInsideItsWeekAndOutsideItOnlyUpToThem() {
    var answers: [Bool] = []
    for landing in [date(2026, 8, 30), date(2026, 9, 3), date(2026, 9, 4)] {
        var roster = Roster()
        let commitment = gym()
        _ = roster.add(commitment)
        answers.append(roster.shift(commitment, from: date(2026, 8, 31), to: landing))
    }

    #expect(answers == [true, true, true])
    var alike = Roster()
    let commitment = gym()
    _ = alike.add(commitment)
    let atSaturday = alike.shift(commitment, from: date(2026, 9, 5), to: date(2026, 9, 1))
    #expect(atSaturday)
    var another = Roster()
    let other = gym()
    _ = another.add(other)
    let beforeWeek = another.shift(other, from: date(2026, 8, 31), to: date(2026, 8, 28))
    let pastNext = another.shift(other, from: date(2026, 9, 5), to: date(2026, 9, 8))
    #expect(!beforeWeek)
    #expect(!pastNext)
}

@Test("a roster shifts a day-of-month due day onto any day between its due days either side, about a month each way")
func aRosterShiftsADayOfMonthDueDayOntoAnyDayBetweenItsDueDaysEitherSideAboutAMonthEachWay() {
    var first = Roster()
    let early = finances()
    _ = first.add(early)
    var second = Roster()
    let late = finances()
    _ = second.add(late)

    let toFirst = first.shift(early, from: date(2026, 8, 31), to: date(2026, 8, 1))
    let toSecond = second.shift(late, from: date(2026, 8, 31), to: date(2026, 9, 29))

    #expect(toFirst)
    #expect(toSecond)
    let keeps = second.commitments[0]
    #expect(keeps.isDue(on: date(2026, 9, 29)))
    #expect(keeps.isDue(on: date(2026, 9, 30)))
    #expect(!keeps.isDue(on: date(2026, 8, 31)))
    var alike = Roster()
    let beyond = finances()
    _ = alike.add(beyond)
    var refused: [Bool] = []
    for other in [date(2026, 7, 31), date(2026, 9, 30), date(2026, 10, 1)] {
        refused.append(alike.shift(beyond, from: date(2026, 8, 31), to: other))
    }
    #expect(refused == [false, false, false])
}

@Test("a day a shift put into another week, shifted again, is judged from the day it came from")
func aDayAShiftPutIntoAnotherWeekShiftedAgainIsJudgedFromTheDayItCameFrom() {
    var roster = Roster()
    let commitment = pool()
    _ = roster.add(commitment)
    let first = roster.shift(commitment, from: date(2026, 9, 4), to: date(2026, 9, 7))
    #expect(first)

    let beyond = roster.shift(commitment, from: date(2026, 9, 7), to: date(2026, 9, 12))
    let within = roster.shift(commitment, from: date(2026, 9, 7), to: date(2026, 8, 29))

    #expect(!beyond)
    #expect(within)
    var keeps = roster.commitments[0]
    #expect(keeps.isDue(on: date(2026, 8, 29)))
    #expect(!keeps.isDue(on: date(2026, 9, 4)))
    #expect(!keeps.isDue(on: date(2026, 9, 7)))
    let back = roster.shift(commitment, from: date(2026, 8, 29), to: date(2026, 9, 4))
    #expect(back)
    keeps = roster.commitments[0]
    #expect(keeps.isDue(on: date(2026, 9, 4)))
    #expect(!keeps.isDue(on: date(2026, 8, 29)))
    #expect(!keeps.isDue(on: date(2026, 9, 7)))
}

@Test("the due days either side of a day are its schedule's, never where another shift put one")
func theDueDaysEitherSideOfADayAreItsSchedulesNeverWhereAnotherShiftPutOne() {
    var roster = Roster()
    let commitment = pool()
    _ = roster.add(commitment)
    let first = roster.shift(commitment, from: date(2026, 9, 4), to: date(2026, 9, 7))
    #expect(first)

    let onto = roster.shift(commitment, from: date(2026, 9, 11), to: date(2026, 9, 7))
    let past = roster.shift(commitment, from: date(2026, 9, 11), to: date(2026, 9, 5))

    #expect(!onto)
    #expect(past)
    let keeps = roster.commitments[0]
    #expect(keeps.isDue(on: date(2026, 9, 5)))
    #expect(keeps.isDue(on: date(2026, 9, 7)))
    #expect(!keeps.isDue(on: date(2026, 9, 4)))
    #expect(!keeps.isDue(on: date(2026, 9, 11)))
}

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

@MainActor
private func sayDaysAway(
    at places: Places, from first: CalendarDate, through last: CalendarDate, over commitment: Commitment
) throws {
    let screen = CommitmentsScreen(
        asOf: date(2026, 10, 12), keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
    #expect(screen.sayDaysAway(named: "", from: first, through: last, over: [commitment]) == nil)
}

@MainActor
@Test("a roster shifts a weekday-set or day-of-month due day across days away, inside its week or past it, and onto none of their days")
func aRosterShiftsAWeekdaySetOrDayOfMonthDueDayAcrossDaysAwayInsideItsWeekOrPastItAndOntoNoneOfTheirDays() throws {
    let places = Places()
    let pool = pool()
    try RosterStore(at: places.roster).add(pool)
    try sayDaysAway(at: places, from: date(2026, 10, 17), through: date(2026, 10, 18), over: pool)
    let store = try RosterStore(at: places.roster)

    let onto = try store.shift(pool, from: date(2026, 10, 16), to: date(2026, 10, 18))
    let past = try store.shift(pool, from: date(2026, 10, 16), to: date(2026, 10, 19))

    #expect(!onto)
    #expect(past)
    let back = try store.shift(pool, from: date(2026, 10, 19), to: date(2026, 10, 16))
    #expect(back)

    let gymPlaces = Places()
    let gym = gym()
    try RosterStore(at: gymPlaces.roster).add(gym)
    try sayDaysAway(at: gymPlaces, from: date(2026, 10, 13), through: date(2026, 10, 13), over: gym)
    let gymStore = try RosterStore(at: gymPlaces.roster)
    let across = try gymStore.shift(gym, from: date(2026, 10, 12), to: date(2026, 10, 15))
    #expect(across)
}

@Test("a weekday-set or day-of-month shift across a week is held by a roster store opened afterwards")
func aWeekdaySetOrDayOfMonthShiftAcrossAWeekIsHeldByARosterStoreOpenedAfterwards() throws {
    let place = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("roster.json")
    let store = try RosterStore(at: place)
    let pool = pool()
    let finances = finances()
    try store.add(pool)
    try store.add(finances)
    let poolShifted = try store.shift(pool, from: date(2026, 9, 4), to: date(2026, 9, 7))
    let financesShifted = try store.shift(finances, from: date(2026, 8, 31), to: date(2026, 9, 29))
    #expect(poolShifted)
    #expect(financesShifted)

    let reopened = try RosterStore(at: place)

    let kept = reopened.roster.commitments
    let keptPool = kept.first { $0.name == "Pool" }!
    let keptFinances = kept.first { $0.name == "Finances" }!
    #expect(keptPool.isDue(on: date(2026, 9, 7)))
    #expect(!keptPool.isDue(on: date(2026, 9, 4)))
    #expect(keptFinances.isDue(on: date(2026, 9, 29)))
    #expect(!keptFinances.isDue(on: date(2026, 8, 31)))
}
