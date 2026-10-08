import Foundation
import Testing
@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private let gymSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])
private let januaryFirst = date(2026, 1, 1)

private func gym(keptFrom: CalendarDate = januaryFirst) -> Commitment {
    Commitment(name: "Gym", schedule: gymSchedule, keptFrom: keptFrom)!
}

private func freshPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("roster.json")
}

/// The commitment `roster` keeps, newest era.
private func kept(_ roster: Roster) -> Commitment {
    roster.commitments[0]
}

@Test("a commitment is not due on the day a shift took its due day from, and is due on the day it put it on")
func aCommitmentIsNotDueOnTheDayAShiftTookItsDueDayFromAndIsDueOnTheDayItPutItOn() {
    var roster = Roster()
    let commitment = gym()
    _ = roster.add(commitment)

    let shifted = roster.shift(commitment, from: date(2026, 8, 31), to: date(2026, 9, 1))

    #expect(shifted)
    let keeps = kept(roster)
    let asked: [CalendarDate] = [date(2026, 8, 31)] + (1...7).map { date(2026, 9, $0) }
    let due = asked.filter { keeps.isDue(on: $0) }
    #expect(due == [date(2026, 9, 1), date(2026, 9, 2), date(2026, 9, 5), date(2026, 9, 7)])
}

@Test("a roster shifts a weekday-set due day onto a free day and leaves the rest of its rhythm as it was")
func aRosterShiftsAWeekdaySetDueDayOntoAFreeDayAndLeavesTheRestOfItsRhythmAsItWas() {
    var roster = Roster()
    let commitment = gym()
    _ = roster.add(commitment)

    let shifted = roster.shift(commitment, from: date(2026, 8, 31), to: date(2026, 9, 1))

    #expect(shifted)
    let eras = roster.eras(of: commitment)
    #expect(eras.count == 1)
    #expect(roster.keptFrom(of: commitment) == januaryFirst)
    #expect(eras.first?.rhythmInWords == "Mon, Wed, Sat")
    let keeps = kept(roster)
    #expect(keeps.isDue(on: date(2026, 9, 2)))
    #expect(keeps.isDue(on: date(2026, 9, 5)))
    #expect(keeps.isDue(on: date(2026, 9, 7)))
}

@Test("a roster shifts a day-of-month due day across the end of its month, inside its week")
func aRosterShiftsADayOfMonthDueDayAcrossTheEndOfItsMonthInsideItsWeek() {
    var roster = Roster()
    let finances = Commitment(
        name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 31)!), keptFrom: januaryFirst)!
    _ = roster.add(finances)

    let shifted = roster.shift(finances, from: date(2026, 8, 31), to: date(2026, 9, 1))

    #expect(shifted)
    let keeps = kept(roster)
    #expect(keeps.isDue(on: date(2026, 9, 1)))
    #expect(!keeps.isDue(on: date(2026, 8, 31)))
    #expect(keeps.isDue(on: date(2026, 9, 30)))
}

@Test("a roster refuses to shift a due day onto one of its own days, a day another shift put a due day on, or a day of another week")
func aRosterRefusesToShiftADueDayOntoOneOfItsOwnDaysADayAnotherShiftPutADueDayOnOrADayOfAnotherWeek() {
    var roster = Roster()
    let commitment = gym()
    _ = roster.add(commitment)
    let first = roster.shift(commitment, from: date(2026, 9, 2), to: date(2026, 9, 3))
    #expect(first)

    let monday = date(2026, 8, 31)
    var refused: [Bool] = []
    for other in [
        date(2026, 9, 2), date(2026, 9, 3), date(2026, 9, 5), date(2026, 9, 8), monday,
    ] {
        refused.append(roster.shift(commitment, from: monday, to: other))
    }

    #expect(refused == [false, false, false, false, false])
    let keeps = kept(roster)
    #expect(keeps.isDue(on: monday))
    #expect(keeps.isDue(on: date(2026, 9, 3)))
    #expect(!keeps.isDue(on: date(2026, 9, 2)))
}

@Test("a roster refuses to shift a due day onto a day the era holding it does not hold")
func aRosterRefusesToShiftADueDayOntoADayTheEraHoldingItDoesNotHold() {
    var late = Roster()
    let lateGym = gym(keptFrom: date(2026, 9, 2))
    _ = late.add(lateGym)

    let beforeKeptFrom = late.shift(lateGym, from: date(2026, 9, 2), to: date(2026, 9, 1))

    #expect(!beforeKeptFrom)

    var gapped = Roster()
    let commitment = gym()
    _ = gapped.add(commitment)
    _ = gapped.retire(commitment, keptUntil: date(2026, 9, 2))
    _ = gapped.keepAgain(commitment, from: date(2026, 9, 5))
    var accepted: [Bool] = []
    for other in [date(2026, 9, 3), date(2026, 9, 4), date(2026, 9, 6)] {
        accepted.append(gapped.shift(commitment, from: date(2026, 9, 2), to: other))
    }
    #expect(accepted == [false, false, false])
    let shiftedBack = gapped.shift(commitment, from: date(2026, 9, 2), to: date(2026, 9, 1))
    #expect(shiftedBack)
}

@Test("a roster refuses to shift a day the commitment is not due on, and a weekly-quota day")
func aRosterRefusesToShiftADayTheCommitmentIsNotDueOnAndAWeeklyQuotaDay() {
    var roster = Roster()
    let commitment = gym()
    _ = roster.add(commitment)
    let first = roster.shift(commitment, from: date(2026, 8, 31), to: date(2026, 9, 1))
    #expect(first)

    let origin = roster.shift(commitment, from: date(2026, 8, 31), to: date(2026, 9, 3))
    let notDue = roster.shift(commitment, from: date(2026, 9, 4), to: date(2026, 9, 6))

    #expect(!origin)
    #expect(!notDue)

    var reading = Roster()
    let weeklyQuota = Commitment(
        name: "Reading", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!),
        keptFrom: januaryFirst)!
    _ = reading.add(weeklyQuota)
    let quotaDay = reading.shift(weeklyQuota, from: date(2026, 8, 31), to: date(2026, 9, 1))
    #expect(!quotaDay)
}

@Test("a roster shifts a day of a commitment it has stopped, and refuses one it does not hold")
func aRosterShiftsADayOfACommitmentItHasStoppedAndRefusesOneItDoesNotHold() {
    var roster = Roster()
    let commitment = gym()
    _ = roster.add(commitment)
    _ = roster.retire(commitment, keptUntil: date(2026, 9, 5))

    let stopped = roster.shift(commitment, from: date(2026, 8, 31), to: date(2026, 9, 1))

    #expect(stopped)

    let run = Commitment(name: "Run", schedule: gymSchedule, keptFrom: januaryFirst)!
    let neverHeld = roster.shift(run, from: date(2026, 8, 31), to: date(2026, 9, 1))
    #expect(!neverHeld)

    var deleted = Roster()
    _ = deleted.add(commitment)
    _ = deleted.delete(commitment)
    let afterDelete = deleted.shift(commitment, from: date(2026, 8, 31), to: date(2026, 9, 1))
    #expect(!afterDelete)
    #expect(deleted.entries.isEmpty)
}

@Test("a day a shift put a due day on, shifted again, keeps the day it came from")
func aDayAShiftPutADueDayOnShiftedAgainKeepsTheDayItCameFrom() {
    var roster = Roster()
    let commitment = gym()
    _ = roster.add(commitment)
    let first = roster.shift(commitment, from: date(2026, 8, 31), to: date(2026, 9, 1))
    #expect(first)

    let again = roster.shift(commitment, from: date(2026, 9, 1), to: date(2026, 9, 3))

    #expect(again)
    var keeps = kept(roster)
    #expect(keeps.isDue(on: date(2026, 9, 3)))
    #expect(!keeps.isDue(on: date(2026, 8, 31)))
    #expect(!keeps.isDue(on: date(2026, 9, 1)))

    let back = roster.shift(commitment, from: date(2026, 9, 3), to: date(2026, 8, 31))

    #expect(back)
    keeps = kept(roster)
    #expect(keeps.isDue(on: date(2026, 8, 31)))
    #expect(!keeps.isDue(on: date(2026, 9, 1)))
    #expect(!keeps.isDue(on: date(2026, 9, 3)))
}

@Test("a day a shift put a due day on, shifted to the day it came from, leaves no shift")
func aDayAShiftPutADueDayOnShiftedToTheDayItCameFromLeavesNoShift() throws {
    let commitment = gym()
    let first = freshPlace()
    let second = freshPlace()
    let firstStore = try RosterStore(at: first)
    let secondStore = try RosterStore(at: second)
    try firstStore.add(commitment)
    try secondStore.add(commitment)

    let out = try firstStore.shift(commitment, from: date(2026, 8, 31), to: date(2026, 9, 1))
    let back = try firstStore.shift(commitment, from: date(2026, 9, 1), to: date(2026, 8, 31))

    #expect(out)
    #expect(back)
    let keeps = try #require(firstStore.roster.commitments.first)
    #expect(keeps.isDue(on: date(2026, 8, 31)))
    #expect(!keeps.isDue(on: date(2026, 9, 1)))
    #expect(try Data(contentsOf: first) == Data(contentsOf: second))
}

@Test("a roster refuses to shift a due day back to the day it came from once no era is due on that day")
func aRosterRefusesToShiftADueDayBackToTheDayItCameFromOnceNoEraIsDueOnThatDay() {
    let monday = date(2026, 8, 31)
    let tuesday = date(2026, 9, 1)
    let run = Commitment(
        name: "Run", schedule: .weekdays([.tuesday, .thursday]), keptFrom: januaryFirst)!

    var stopped = Roster()
    _ = stopped.add(run)
    _ = stopped.shift(run, from: tuesday, to: monday)
    _ = stopped.retire(kept(stopped), keptUntil: monday)
    let stoppedBack = stopped.shift(run, from: monday, to: tuesday)
    #expect(!stoppedBack)
    #expect(stopped.commitments(on: monday).contains { $0.isDue(on: monday) })

    var changed = Roster()
    _ = changed.add(run)
    _ = changed.shift(run, from: tuesday, to: monday)
    let further = Commitment(
        era: kept(changed), schedule: .weekdays([.wednesday, .friday]), keptFrom: tuesday,
        kind: .tick)!
    _ = changed.put(era: further, on: kept(changed), keptUntil: monday, under: nil)
    let changedBack = changed.shift(run, from: monday, to: tuesday)
    #expect(!changedBack)
    #expect(changed.commitments(on: monday).contains { $0.isDue(on: monday) })

    var gymRoster = Roster()
    let commitment = gym()
    _ = gymRoster.add(commitment)
    _ = gymRoster.shift(commitment, from: monday, to: tuesday)
    let gymFurther = Commitment(
        era: kept(gymRoster), schedule: .weekdays([.wednesday, .friday]), keptFrom: tuesday,
        kind: .tick)!
    _ = gymRoster.put(era: gymFurther, on: kept(gymRoster), keptUntil: monday, under: nil)
    let gymBack = gymRoster.shift(commitment, from: tuesday, to: monday)
    #expect(gymBack)
    #expect(gymRoster.commitments(on: monday).contains { $0.isDue(on: monday) })
    #expect(!gymRoster.commitments(on: tuesday).contains { $0.isDue(on: tuesday) })
}

@Test("a shift kept at a roster place is held by a roster store opened afterwards at the same place")
func aShiftKeptAtARosterPlaceIsHeldByARosterStoreOpenedAfterwardsAtTheSamePlace() throws {
    let place = freshPlace()
    let store = try RosterStore(at: place)
    let commitment = gym()
    try store.add(commitment)
    let shifted = try store.shift(commitment, from: date(2026, 8, 31), to: date(2026, 9, 1))
    #expect(shifted)
    let era = Commitment(
        era: commitment, schedule: .weekdays([.tuesday, .thursday]), keptFrom: date(2026, 9, 7),
        kind: .tick)!
    let put = try store.put(
        era: era, on: commitment, keptUntil: date(2026, 9, 6), under: nil)
    #expect(put)

    let reopened = try RosterStore(at: place)

    #expect(reopened.roster.eras(of: commitment).count == 2)
    let onTuesday = reopened.roster.commitments(on: date(2026, 9, 1))
    #expect(!onTuesday.isEmpty)
    #expect(onTuesday.contains { $0.isDue(on: date(2026, 9, 1)) })
    let onMonday = reopened.roster.commitments(on: date(2026, 8, 31))
    #expect(!onMonday.isEmpty)
    #expect(onMonday.allSatisfy { !$0.isDue(on: date(2026, 8, 31)) })
}

/// A roster in the given form holding "Gym" on Monday, Wednesday and Saturday: one era per element
/// of `eraShifts`, newest first, each carrying the raw JSON given as its shifts — `nil` leaves the
/// key out. With two eras the older is kept from 1 January 2026 until 6 September and the newer
/// from 7 September; with one it is kept from 1 January.
private func gymRosterJSON(version: Int, eraShifts: [String?]) -> Data {
    let entries = eraShifts.enumerated().map { index, shifts -> String in
        let isOlder = index > 0
        let (month, dayOfMonth) = (eraShifts.count == 2 && !isOlder) ? (9, 7) : (1, 1)
        let keptUntil = isOlder ? #""keptUntil": { "year": 2026, "month": 9, "day": 6 },"# : ""
        let shiftsKey = shifts.map { #","shifts": \#($0)"# } ?? ""
        return """
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": \(month), "day": \(dayOfMonth) },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "identity": "11111111-1111-1111-1111-111111111111"
              },
              \(keptUntil)
              "category": null,
              "usualAmounts": []\(shiftsKey)
            }
            """
    }.joined(separator: ",")
    return Data(
        """
        { "version": \(version), "emptied": false, "commitments": [\(entries)] }
        """.utf8)
}

private func expectNotARosterStore(_ bytes: Data) throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try bytes.write(to: place)

    #expect(throws: RosterStoreError.notAStore(at: place)) {
        try RosterStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a roster kept in the form before shifts is read as holding none, and its place is left as it was")
func aRosterKeptInTheFormBeforeShiftsIsReadAsHoldingNoneAndItsPlaceIsLeftAsItWas() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = gymRosterJSON(version: 7, eraShifts: [nil])
    try bytes.write(to: place)

    let store = try RosterStore(at: place)

    let keeps = try #require(store.roster.commitments.first)
    #expect(keeps.isDue(on: date(2026, 8, 31)))
    #expect(!keeps.isDue(on: date(2026, 9, 1)))
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a roster store whose shape and declared form disagree about shifts is refused")
func aRosterStoreWhoseShapeAndDeclaredFormDisagreeAboutShiftsIsRefused() throws {
    try expectNotARosterStore(gymRosterJSON(version: 7, eraShifts: ["[]"]))
    try expectNotARosterStore(gymRosterJSON(version: 8, eraShifts: [nil]))
}

@Test("a roster store holding a shift no roster could hold is refused")
func aRosterStoreHoldingAShiftNoRosterCouldHoldIsRefused() throws {
    let sundayToMonday = #"[{ "from": \#(day(9, 6)), "to": \#(day(9, 7)) }]"#
    let toItself = #"[{ "from": \#(day(8, 31)), "to": \#(day(8, 31)) }]"#
    let twiceFrom = #"[{ "from": \#(day(8, 31)), "to": \#(day(9, 1)) },{ "from": \#(day(8, 31)), "to": \#(day(9, 2)) }]"#
    let twiceOnto = #"[{ "from": \#(day(8, 31)), "to": \#(day(9, 1)) },{ "from": \#(day(9, 2)), "to": \#(day(9, 1)) }]"#
    let one = #"[{ "from": \#(day(8, 31)), "to": \#(day(9, 1)) }]"#
    try expectNotARosterStore(gymRosterJSON(version: 8, eraShifts: [sundayToMonday]))
    try expectNotARosterStore(gymRosterJSON(version: 8, eraShifts: [toItself]))
    try expectNotARosterStore(gymRosterJSON(version: 8, eraShifts: [twiceFrom]))
    try expectNotARosterStore(gymRosterJSON(version: 8, eraShifts: [twiceOnto]))
    try expectNotARosterStore(gymRosterJSON(version: 8, eraShifts: [one, "[]"]))
}

private func day(_ month: Int, _ day: Int) -> String {
    #"{ "year": 2026, "month": \#(month), "day": \#(day) }"#
}
