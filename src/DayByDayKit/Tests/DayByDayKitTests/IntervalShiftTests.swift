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
