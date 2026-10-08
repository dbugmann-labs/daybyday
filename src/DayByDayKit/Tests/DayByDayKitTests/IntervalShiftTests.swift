import Foundation
import Testing
@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private func every(_ days: Int, from start: CalendarDate) -> Schedule {
    .everyNDays(DayInterval(days: days)!, from: start)
}

private let august6 = date(2026, 8, 6)

private func nails(keptFrom: CalendarDate = august6) -> Commitment {
    Commitment(name: "Nails", schedule: every(4, from: august6), keptFrom: keptFrom)!
}

private func lenses() -> Commitment {
    Commitment(
        name: "Contact lenses", schedule: every(14, from: date(2026, 8, 25)),
        keptFrom: date(2026, 8, 25))!
}

/// The dates from `first` through `last` that `commitment` is due on.
private func dueDays(_ commitment: Commitment, from first: CalendarDate, through last: CalendarDate)
    -> [CalendarDate]
{
    (0...first.days(until: last)).map { first.adding(days: $0)! }.filter { commitment.isDue(on: $0) }
}

@Test("an every-N-days commitment is due counting on from the day a shift put its due day on")
func anEveryNDaysCommitmentIsDueCountingOnFromTheDayAShiftPutItsDueDayOn() {
    var roster = Roster()
    let commitment = nails()
    _ = roster.add(commitment)
    let shifted = roster.shift(commitment, from: date(2026, 8, 30), to: date(2026, 8, 31))
    #expect(shifted)

    let keeps = roster.commitments[0]
    #expect(
        dueDays(keeps, from: date(2026, 8, 26), through: date(2026, 9, 8)) == [
            date(2026, 8, 26), date(2026, 8, 31), date(2026, 9, 4), date(2026, 9, 8),
        ])

    var lensRoster = Roster()
    let contactLenses = lenses()
    _ = lensRoster.add(contactLenses)
    let lensShifted = lensRoster.shift(contactLenses, from: date(2026, 9, 8), to: date(2026, 9, 5))
    #expect(lensShifted)
    let lensKeeps = lensRoster.commitments[0]
    #expect(lensKeeps.isDue(on: date(2026, 9, 5)))
    #expect(lensKeeps.isDue(on: date(2026, 9, 19)))
    #expect(!lensKeeps.isDue(on: date(2026, 9, 8)))
    #expect(!lensKeeps.isDue(on: date(2026, 9, 22)))
}

@Test("an every-N-days count runs on from a shift only where the shift took a due day on or after its start date")
func anEveryNDaysCountRunsOnFromAShiftOnlyWhereTheShiftTookADueDayOnOrAfterItsStartDate() {
    var roster = Roster()
    let commitment = nails()
    _ = roster.add(commitment)
    let shifted = roster.shift(commitment, from: date(2026, 8, 30), to: date(2026, 8, 31))
    #expect(shifted)
    let further = Commitment(
        era: commitment, schedule: every(5, from: date(2026, 9, 1)), keptFrom: date(2026, 9, 1),
        kind: .tick)!
    let put = roster.put(
        era: further, on: commitment, keptUntil: date(2026, 8, 31), under: nil)
    #expect(put)

    func dueAccordingToTheRoster(on day: CalendarDate) -> Bool {
        roster.commitments(on: day).contains { $0.isDue(on: day) }
    }
    #expect(dueAccordingToTheRoster(on: date(2026, 8, 31)))
    #expect(dueAccordingToTheRoster(on: date(2026, 9, 1)))
    #expect(dueAccordingToTheRoster(on: date(2026, 9, 6)))
    #expect(!dueAccordingToTheRoster(on: date(2026, 9, 4)))
}

@Test("a roster shifts an every-N-days due day onto any day between the due days either side of it, a week crossed or not")
func aRosterShiftsAnEveryNDaysDueDayOntoAnyDayBetweenTheDueDaysEitherSideOfItAWeekCrossedOrNot() {
    let targets = [
        date(2026, 8, 27), date(2026, 8, 28), date(2026, 8, 29),
        date(2026, 8, 31), date(2026, 9, 1), date(2026, 9, 2),
    ]
    for other in targets {
        var roster = Roster()
        let commitment = nails()
        _ = roster.add(commitment)

        let shifted = roster.shift(commitment, from: date(2026, 8, 30), to: other)

        #expect(shifted)
        #expect(roster.eras(of: commitment).count == 1)
        #expect(roster.keptFrom(of: commitment) == august6)
        #expect(roster.eras(of: commitment).first?.rhythmInWords == "Every 4 days")
    }

    var lensRoster = Roster()
    let contactLenses = lenses()
    _ = lensRoster.add(contactLenses)
    let crossed = lensRoster.shift(contactLenses, from: date(2026, 9, 8), to: date(2026, 9, 5))
    #expect(crossed)
}

@Test("a roster refuses to shift an every-N-days due day onto a due day either side of it, a day beyond them, or itself")
func aRosterRefusesToShiftAnEveryNDaysDueDayOntoADueDayEitherSideOfItADayBeyondThemOrItself() {
    var roster = Roster()
    let commitment = nails()
    _ = roster.add(commitment)
    let others = [
        date(2026, 8, 26), date(2026, 8, 25), date(2026, 9, 3), date(2026, 9, 4),
        date(2026, 8, 30),
    ]

    var accepted: [Bool] = []
    for other in others {
        accepted.append(roster.shift(commitment, from: date(2026, 8, 30), to: other))
    }

    #expect(accepted == [false, false, false, false, false])
    let keeps = roster.commitments[0]
    #expect(keeps.isDue(on: date(2026, 8, 30)))
    #expect(keeps.isDue(on: date(2026, 9, 3)))
}

@Test("an era's first every-N-days due day is shifted back no further than the day that era is kept from")
func anErasFirstEveryNDaysDueDayIsShiftedBackNoFurtherThanTheDayThatEraIsKeptFrom() {
    var roster = Roster()
    let commitment = nails(keptFrom: date(2026, 8, 4))
    _ = roster.add(commitment)

    let tooFar = roster.shift(commitment, from: august6, to: date(2026, 8, 3))
    let bound = roster.shift(commitment, from: august6, to: date(2026, 8, 4))

    #expect(!tooFar)
    #expect(bound)
    let keeps = roster.commitments[0]
    #expect(keeps.isDue(on: date(2026, 8, 4)))
    #expect(keeps.isDue(on: date(2026, 8, 8)))
    #expect(!keeps.isDue(on: august6))
    #expect(!keeps.isDue(on: date(2026, 8, 10)))

    var moods = Roster()
    let mood = Commitment(
        name: "Mood", schedule: every(4, from: august6), keptFrom: august6,
        kind: .number(range: Commitment.Range(lowest: 1, highest: 10)!))!
    let narrower = Commitment(
        era: mood, schedule: every(4, from: august6), keptFrom: date(2026, 9, 1),
        kind: .number(range: Commitment.Range(lowest: 1, highest: 5)!))!
    _ = moods.add(mood)
    _ = moods.put(era: narrower, on: mood, keptUntil: date(2026, 8, 31), under: nil)

    let before = moods.shift(mood, from: date(2026, 9, 3), to: date(2026, 8, 31))
    let after = moods.shift(mood, from: date(2026, 9, 3), to: date(2026, 9, 1))
    #expect(!before)
    #expect(after)
}

@Test("a roster refuses to shift an every-N-days due day while a later shift or a later era of it stands")
func aRosterRefusesToShiftAnEveryNDaysDueDayWhileALaterShiftOrALaterEraOfItStands() {
    var shifted = Roster()
    let commitment = nails()
    _ = shifted.add(commitment)
    let later = shifted.shift(commitment, from: date(2026, 9, 3), to: date(2026, 9, 4))
    #expect(later)

    let refused = shifted.shift(commitment, from: date(2026, 8, 30), to: date(2026, 8, 31))

    #expect(!refused)
    #expect(shifted.commitments[0].isDue(on: date(2026, 8, 30)))

    var eras = Roster()
    _ = eras.add(commitment)
    let further = Commitment(
        era: commitment, schedule: every(5, from: date(2026, 9, 1)), keptFrom: date(2026, 9, 1),
        kind: .tick)!
    _ = eras.put(era: further, on: commitment, keptUntil: date(2026, 8, 31), under: nil)

    let refusedAcrossEras = eras.shift(commitment, from: date(2026, 8, 30), to: date(2026, 8, 31))
    #expect(!refusedAcrossEras)
}

@Test("an every-N-days day a shift put a due day on, shifted again, keeps the day it came from and that day's bounds")
func anEveryNDaysDayAShiftPutADueDayOnShiftedAgainKeepsTheDayItCameFromAndThatDaysBounds() {
    var roster = Roster()
    let commitment = nails()
    _ = roster.add(commitment)
    let first = roster.shift(commitment, from: date(2026, 8, 30), to: date(2026, 8, 31))
    #expect(first)

    let again = roster.shift(commitment, from: date(2026, 8, 31), to: date(2026, 9, 2))

    #expect(again)
    let keeps = roster.commitments[0]
    #expect(keeps.isDue(on: date(2026, 9, 2)))
    #expect(keeps.isDue(on: date(2026, 9, 6)))
    for notDue in [date(2026, 8, 30), date(2026, 8, 31), date(2026, 9, 4)] {
        #expect(!keeps.isDue(on: notDue))
    }
    let creeping = roster.shift(commitment, from: date(2026, 9, 2), to: date(2026, 9, 3))
    #expect(!creeping)
    let home = roster.shift(commitment, from: date(2026, 9, 2), to: date(2026, 8, 30))
    #expect(home)
    let homeKeeps = roster.commitments[0]
    #expect(homeKeeps.isDue(on: date(2026, 8, 30)))
    #expect(homeKeeps.isDue(on: date(2026, 9, 3)))
    #expect(!homeKeeps.isDue(on: date(2026, 8, 31)))
    #expect(!homeKeeps.isDue(on: date(2026, 9, 2)))
}

@Test("a roster refuses to shift an every-N-days due day onto a day another shift took a due day from")
func aRosterRefusesToShiftAnEveryNDaysDueDayOntoADayAnotherShiftTookADueDayFrom() {
    var roster = Roster()
    let commitment = nails()
    _ = roster.add(commitment)
    let first = roster.shift(commitment, from: date(2026, 8, 30), to: date(2026, 8, 29))
    #expect(first)

    let onto = roster.shift(commitment, from: date(2026, 9, 2), to: date(2026, 8, 30))
    let past = roster.shift(commitment, from: date(2026, 9, 2), to: date(2026, 8, 31))

    #expect(!onto)
    #expect(past)
    let keeps = roster.commitments[0]
    for due in [date(2026, 8, 29), date(2026, 8, 31), date(2026, 9, 4)] {
        #expect(keeps.isDue(on: due))
    }
    #expect(!keeps.isDue(on: date(2026, 8, 30)))
    #expect(!keeps.isDue(on: date(2026, 9, 2)))
}

@Test("a roster shifts an every-N-days day of a commitment it has stopped only onto a day it held")
func aRosterShiftsAnEveryNDaysDayOfACommitmentItHasStoppedOnlyOntoADayItHeld() {
    var stopped = Roster()
    let commitment = nails()
    _ = stopped.add(commitment)
    _ = stopped.retire(commitment, keptUntil: date(2026, 8, 31))

    let beyond = stopped.shift(commitment, from: date(2026, 8, 30), to: date(2026, 9, 1))
    let within = stopped.shift(commitment, from: date(2026, 8, 30), to: date(2026, 8, 31))

    #expect(!beyond)
    #expect(within)

    var shiftedThenStopped = Roster()
    _ = shiftedThenStopped.add(commitment)
    let first = shiftedThenStopped.shift(commitment, from: date(2026, 8, 30), to: date(2026, 8, 29))
    #expect(first)
    _ = shiftedThenStopped.retire(commitment, keptUntil: date(2026, 8, 29))

    let back = shiftedThenStopped.shift(commitment, from: date(2026, 8, 29), to: date(2026, 8, 30))

    #expect(!back)
    #expect(shiftedThenStopped.stopped[0].isDue(on: date(2026, 8, 29)))
}

private func freshPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("roster.json")
}

@Test("an every-N-days shift across a week is held by a roster store opened afterwards")
func anEveryNDaysShiftAcrossAWeekIsHeldByARosterStoreOpenedAfterwards() throws {
    let place = freshPlace()
    let store = try RosterStore(at: place)
    let contactLenses = lenses()
    try store.add(contactLenses)
    let shifted = try store.shift(contactLenses, from: date(2026, 9, 8), to: date(2026, 9, 5))
    #expect(shifted)

    let reopened = try RosterStore(at: place)

    let keeps = reopened.roster.commitments[0]
    #expect(keeps.isDue(on: date(2026, 9, 5)))
    #expect(keeps.isDue(on: date(2026, 9, 19)))
    #expect(!keeps.isDue(on: date(2026, 9, 8)))
    #expect(!keeps.isDue(on: date(2026, 9, 22)))
}

private func freshPlaces() -> (roster: URL, record: URL) {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    return (
        directory.appendingPathComponent("roster.json"),
        directory.appendingPathComponent("record.json")
    )
}

private func mood(_ highest: Decimal = 10) -> Commitment {
    Commitment(
        name: "Mood", schedule: every(4, from: august6), keptFrom: august6,
        kind: .number(range: Commitment.Range(lowest: 1, highest: highest)))!
}

@MainActor
@Test("a range or a target change keeps an every-N-days count running from its start date")
func aRangeOrATargetChangeKeepsAnEveryNDaysCountRunningFromItsStartDate() throws {
    let places = freshPlaces()
    let commitment = mood()
    try RosterStore(at: places.roster).add(commitment)
    let screen = CommitmentsScreen(
        asOf: date(2026, 8, 31), keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        commitment, toName: "Mood", on: .everyNDays(4), keptFrom: august6, under: nil,
        lowest: "1", highest: "5")

    #expect(refusal == nil)
    let reopened = try RosterStore(at: places.roster).roster
    let eras = reopened.eras(of: commitment)
    #expect(eras.count == 2)
    #expect(eras[0].kind == .number(range: Commitment.Range(lowest: 1, highest: 5)))
    #expect(eras[0].schedule == every(4, from: august6))
    #expect(eras[0].keptFrom == date(2026, 8, 31))
    func dueAccordingToTheRoster(on day: CalendarDate) -> Bool {
        reopened.commitments(on: day).contains { $0.isDue(on: day) }
    }
    #expect(dueAccordingToTheRoster(on: date(2026, 9, 3)))
    #expect(!dueAccordingToTheRoster(on: date(2026, 8, 31)))
    #expect(!dueAccordingToTheRoster(on: date(2026, 9, 4)))

    let totalPlaces = freshPlaces()
    let protein = Commitment(
        name: "Protein", schedule: every(4, from: august6), keptFrom: august6,
        kind: .total(target: Commitment.Target(120)!))!
    try RosterStore(at: totalPlaces.roster).add(protein)
    let totalScreen = CommitmentsScreen(
        asOf: date(2026, 8, 31), keepingRosterAt: totalPlaces.roster,
        keepingRecordAt: totalPlaces.record)
    _ = totalScreen.change(
        protein, toName: "Protein", on: .everyNDays(4), keptFrom: august6, under: nil,
        target: "150")
    let proteinEras = try RosterStore(at: totalPlaces.roster).roster.eras(of: protein)
    #expect(proteinEras.count == 2)
    #expect(proteinEras[0].schedule == every(4, from: august6))

    let intervalPlaces = freshPlaces()
    let otherMood = mood()
    try RosterStore(at: intervalPlaces.roster).add(otherMood)
    let intervalScreen = CommitmentsScreen(
        asOf: date(2026, 8, 31), keepingRosterAt: intervalPlaces.roster,
        keepingRecordAt: intervalPlaces.record)
    _ = intervalScreen.change(
        otherMood, toName: "Mood", on: .everyNDays(5), keptFrom: august6, under: nil,
        lowest: "1", highest: "5")
    let intervalEras = try RosterStore(at: intervalPlaces.roster).roster.eras(of: otherMood)
    #expect(intervalEras[0].schedule == every(5, from: date(2026, 8, 31)))
}
