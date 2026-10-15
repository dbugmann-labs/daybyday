import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private let monday12 = date(2026, 10, 12)
private let everyDay = Schedule.weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])

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
private func screen(_ places: Places, asOf day: CalendarDate) -> CommitmentsScreen {
    CommitmentsScreen(
        asOf: day, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
}

private func isDue(_ name: String, on day: CalendarDate, in roster: Roster) -> Bool {
    roster.groups(on: day).flatMap(\.commitments).contains {
        $0.name == name && $0.isDue(on: day)
    }
}

@MainActor
@Test("a tick commitment's look-back counts no day days away hide, and counts a day under them holding a record")
func aTickCommitmentsLookBackCountsNoDayDaysAwayHideAndCountsADayUnderThemHoldingARecord() throws {
    let places = Places()
    let gym = Commitment(
        name: "Gym", schedule: everyDay, keptFrom: date(2026, 10, 1), kind: .tick)!
    try RosterStore(at: places.roster).add(gym)
    try RecordStore(at: places.record).add(Tick(gym, on: monday12)!)
    let refusal = screen(places, asOf: monday12).sayDaysAway(
        named: "", from: monday12, through: date(2026, 10, 14), over: [gym])

    let lookBack = screen(places, asOf: date(2026, 10, 15)).lookBack(at: gym)

    #expect(refusal == nil)
    #expect(lookBack?.lines == [.month(inWords: "October 2026", fraction: "1/13")])
}

@MainActor
@Test("a week days away cover owes its quota in proportion to the days they leave")
func aWeekDaysAwayCoverOwesItsQuotaInProportionToTheDaysTheyLeave() throws {
    let places = Places()
    let yuno = Commitment(
        name: "Yuno", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 5)!),
        keptFrom: date(2026, 1, 1), kind: .tick)!
    try RosterStore(at: places.roster).add(yuno)
    let record = try RecordStore(at: places.record)
    try record.add(Tick(yuno, on: monday12)!)
    try record.add(Tick(yuno, on: date(2026, 10, 13))!)
    let refusal = screen(places, asOf: monday12).sayDaysAway(
        named: "", from: date(2026, 10, 16), through: date(2026, 10, 18), over: [yuno])

    let lookBack = screen(places, asOf: date(2026, 10, 18)).lookBack(at: yuno)

    #expect(refusal == nil)
    #expect(lookBack?.lines.first == .week(inWords: "12–18 Oct 2026", fraction: "2/3"))
}

@MainActor
@Test("a roster refuses to shift a weekday-set due day onto, or from, a day days away hide")
func aRosterRefusesToShiftAWeekdaySetDueDayOntoOrFromADayDaysAwayHide() throws {
    let places = Places()
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]),
        keptFrom: date(2026, 1, 1), kind: .tick)!
    try RosterStore(at: places.roster).add(gym)
    let refusal = screen(places, asOf: monday12).sayDaysAway(
        named: "", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym])
    let store = try RosterStore(at: places.roster)

    let onto = try store.shift(gym, from: monday12, to: date(2026, 10, 13))
    let from = try store.shift(gym, from: date(2026, 10, 14), to: date(2026, 10, 13))
    let outside = try store.shift(gym, from: date(2026, 10, 10), to: date(2026, 10, 11))

    #expect(refusal == nil)
    #expect(!onto)
    #expect(!from)
    #expect(outside)
    #expect(isDue("Gym", on: monday12, in: store.roster))
    #expect(isDue("Gym", on: date(2026, 10, 11), in: store.roster))
    #expect(!isDue("Gym", on: date(2026, 10, 10), in: store.roster))
}

@MainActor
@Test("a roster shifts an every-N-days due day after days away on the count begun again the day after them")
func aRosterShiftsAnEveryNDaysDueDayAfterDaysAwayOnTheCountBegunAgainTheDayAfterThem() throws {
    let places = Places()
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: date(2026, 10, 1)),
        keptFrom: date(2026, 10, 1), kind: .tick)!
    try RosterStore(at: places.roster).add(nails)
    let refusal = screen(places, asOf: monday12).sayDaysAway(
        named: "", from: date(2026, 10, 20), through: date(2026, 10, 25), over: [nails])
    let store = try RosterStore(at: places.roster)

    let first = try store.shift(nails, from: date(2026, 10, 29), to: date(2026, 10, 28))
    let second = try store.shift(nails, from: date(2026, 10, 30), to: date(2026, 10, 31))

    #expect(refusal == nil)
    #expect(!first)
    #expect(second)
    for due in [date(2026, 10, 26), date(2026, 10, 31), date(2026, 11, 4)] {
        #expect(isDue("Nails", on: due, in: store.roster))
    }
    for notDue in [date(2026, 10, 29), date(2026, 10, 30), date(2026, 11, 3)] {
        #expect(!isDue("Nails", on: notDue, in: store.roster))
    }
}

@MainActor
@Test("an every-N-days commitment's look-back counts its due days on the count begun again after days away")
func anEveryNDaysCommitmentsLookBackCountsItsDueDaysOnTheCountBegunAgainAfterDaysAway() throws {
    let places = Places()
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: date(2026, 10, 1)),
        keptFrom: date(2026, 10, 1), kind: .tick)!
    try RosterStore(at: places.roster).add(nails)
    let refusal = screen(places, asOf: monday12).sayDaysAway(
        named: "", from: date(2026, 10, 13), through: date(2026, 10, 14), over: [nails])
    let record = try RecordStore(at: places.record)
    for day in [date(2026, 10, 15), date(2026, 10, 19)] {
        let counted = try #require(
            try RosterStore(at: places.roster).roster.groups(on: day).flatMap(\.commitments)
                .first { $0.name == "Nails" })
        try record.add(Tick(counted, on: day)!)
    }

    let lookBack = screen(places, asOf: date(2026, 10, 31)).lookBack(at: nails)

    #expect(refusal == nil)
    #expect(lookBack?.lines == [.month(inWords: "October 2026", fraction: "2/8")])
}

@MainActor
@Test("a roster refuses to shift an every-N-days due day across days away, or onto the first due day of the count begun again after them")
func aRosterRefusesToShiftAnEveryNDaysDueDayAcrossDaysAwayOrOntoTheFirstDueDayOfTheCountBegunAgainAfterThem() throws {
    let places = Places()
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: date(2026, 10, 1)),
        keptFrom: date(2026, 10, 1), kind: .tick)!
    try RosterStore(at: places.roster).add(nails)
    let refusal = screen(places, asOf: date(2026, 10, 1)).sayDaysAway(
        named: "", from: date(2026, 10, 11), through: date(2026, 10, 12), over: [nails])
    let store = try RosterStore(at: places.roster)

    let acrossToTheCount = try store.shift(nails, from: date(2026, 10, 9), to: date(2026, 10, 13))
    let onto = try store.shift(nails, from: date(2026, 10, 9), to: date(2026, 10, 11))
    let back = try store.shift(nails, from: date(2026, 10, 13), to: date(2026, 10, 10))
    let before = try store.shift(nails, from: date(2026, 10, 9), to: date(2026, 10, 10))

    #expect(refusal == nil)
    #expect(!acrossToTheCount)
    #expect(!onto)
    #expect(!back)
    #expect(before)
    for due in [10, 13, 17] { #expect(isDue("Nails", on: date(2026, 10, due), in: store.roster)) }
    for notDue in [9, 11, 14] { #expect(!isDue("Nails", on: date(2026, 10, notDue), in: store.roster)) }
}

/// Not a scenario of the delta: the ninth review's repros, in which the first due day of the count
/// begun again is not a due day of the count before it, so the shift is not refused on its account.
@MainActor
@Test("a due day before days away is not shifted onto the first due day of the count begun again after them")
func aDueDayBeforeDaysAwayIsNotShiftedOntoTheFirstDueDayOfTheCountBegunAgainAfterThem() throws {
    for days in [(14, 15), (14, 14)] {
        let places = Places()
        let nails = Commitment(
            name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: date(2026, 10, 1)),
            keptFrom: date(2026, 10, 1), kind: .tick)!
        try RosterStore(at: places.roster).add(nails)
        #expect(
            screen(places, asOf: monday12).sayDaysAway(
                named: "", from: date(2026, 10, days.0), through: date(2026, 10, days.1), over: [nails])
                == nil)
        let store = try RosterStore(at: places.roster)
        let restart = days.1 + 1

        #expect(try !store.shift(nails, from: date(2026, 10, 13), to: date(2026, 10, restart)))
        #expect(try !store.shift(nails, from: date(2026, 10, 13), to: date(2026, 10, days.0)))
        for due in [1, 5, 9, 13, restart, restart + 4] {
            #expect(isDue("Nails", on: date(2026, 10, due), in: store.roster))
        }
    }
}

@MainActor
@Test("a roster refuses to shift a weekday-set day a shift put a due day on onto a day days away hide")
func aRosterRefusesToShiftAWeekdaySetDayAShiftPutADueDayOnOntoADayDaysAwayHide() throws {
    let places = Places()
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]),
        keptFrom: date(2026, 1, 1), kind: .tick)!
    try RosterStore(at: places.roster).add(gym)
    let refusal = screen(places, asOf: monday12).sayDaysAway(
        named: "", from: date(2026, 10, 16), through: date(2026, 10, 16), over: [gym])
    let store = try RosterStore(at: places.roster)

    let first = try store.shift(gym, from: monday12, to: date(2026, 10, 13))
    let second = try store.shift(gym, from: date(2026, 10, 13), to: date(2026, 10, 16))
    let third = try store.shift(gym, from: date(2026, 10, 13), to: date(2026, 10, 15))

    #expect(refusal == nil)
    #expect(first)
    #expect(!second)
    #expect(third)
    for due in [14, 15, 17] { #expect(isDue("Gym", on: date(2026, 10, due), in: store.roster)) }
    for notDue in [12, 13, 16] { #expect(!isDue("Gym", on: date(2026, 10, notDue), in: store.roster)) }
}
