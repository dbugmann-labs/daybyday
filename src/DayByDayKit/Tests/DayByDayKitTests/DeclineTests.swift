import Foundation
import Testing
@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private let mwf = Schedule.weekdays([.monday, .wednesday, .saturday])

@Test("a decline is formed for a commitment of every kind on a date it is due on, with a reason or none")
func aDeclineIsFormedForACommitmentOfEveryKindOnADateItIsDueOnWithAReasonOrNone() {
    let keptFrom = date(2026, 1, 1)
    let monday = date(2026, 8, 31)
    let magnesium = Commitment(name: "Magnesium", schedule: mwf, keptFrom: keptFrom)!

    let withReason = Decline(for: magnesium, on: monday, reason: "Ran out")
    #expect(withReason?.reason == "Ran out")
    let withNone = Decline(for: magnesium, on: monday, reason: nil)
    #expect(withNone != nil)
    #expect(withNone?.reason == nil)

    let kinds: [Commitment.Kind] = [
        .number(range: Commitment.Range(lowest: 40, highest: 150)),
        .note,
        .total(target: Commitment.Target(120)!),
    ]
    for kind in kinds {
        let other = Commitment(name: "Magnesium", schedule: mwf, keptFrom: keptFrom, kind: kind)!
        #expect(Decline(for: other, on: monday, reason: nil) != nil)
    }

    let finances = Commitment(
        name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 25)!), keptFrom: keptFrom)!
    #expect(Decline(for: finances, on: date(2026, 9, 25), reason: nil) != nil)
    let nails = Commitment(
        name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: date(2026, 8, 6)),
        keptFrom: date(2026, 8, 6))!
    #expect(Decline(for: nails, on: date(2026, 8, 30), reason: nil) != nil)
}

@Test("a commitment takes no decline on a date it is not due on")
func aCommitmentTakesNoDeclineOnADateItIsNotDueOn() {
    let magnesium = Commitment(name: "Magnesium", schedule: mwf, keptFrom: date(2026, 1, 1))!

    #expect(Decline(for: magnesium, on: date(2026, 9, 1), reason: "Ran out") == nil)
    let late = Commitment(name: "Magnesium", schedule: mwf, keptFrom: date(2026, 9, 2))!
    #expect(Decline(for: late, on: date(2026, 8, 31), reason: "Ran out") == nil)
    #expect(Decline(for: magnesium, on: date(2026, 9, 1), reason: nil) == nil)
    #expect(Decline(for: late, on: date(2026, 8, 31), reason: nil) == nil)
}

@Test("a commitment on a weekly quota takes no decline on any date")
func aCommitmentOnAWeeklyQuotaTakesNoDeclineOnAnyDate() {
    let yuno = Commitment(
        name: "Yuno", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 2)!),
        keptFrom: date(2026, 1, 1))!

    var day = date(2026, 8, 31)
    for _ in 0..<7 {
        #expect(Decline(for: yuno, on: day, reason: nil) == nil)
        #expect(Decline(for: yuno, on: day, reason: "Away") == nil)
        day = day.adding(days: 1)!
    }
}

@Test("a reason that says nothing forms no decline")
func aReasonThatSaysNothingFormsNoDecline() {
    let magnesium = Commitment(name: "Magnesium", schedule: mwf, keptFrom: date(2026, 1, 1))!
    let monday = date(2026, 8, 31)

    #expect(Decline(for: magnesium, on: monday, reason: "") == nil)
    #expect(Decline(for: magnesium, on: monday, reason: "   ") == nil)
    #expect(Decline(for: magnesium, on: monday, reason: "\n\n\n") == nil)
    #expect(Decline(for: magnesium, on: monday, reason: "\t\n") == nil)
    #expect(Decline(for: magnesium, on: monday, reason: "\u{200B}")?.reason == "\u{200B}")
}

@Test("a reason is kept exactly as given, whatever it holds")
func aReasonIsKeptExactlyAsGivenWhateverItHolds() {
    let magnesium = Commitment(name: "Magnesium", schedule: mwf, keptFrom: date(2026, 1, 1))!
    let monday = date(2026, 8, 31)

    let reasons = [
        " Ran out ", String(repeating: "a", count: 100_000), "שלום עולם", "🌧️",
        "Knee sore\nResting it",
    ]
    for reason in reasons {
        let decline = Decline(for: magnesium, on: monday, reason: reason)
        #expect(decline != nil)
        #expect(decline?.reason == reason)
    }
}

@Test("two declines are the same exactly when their commitment, date and reason all are")
func twoDeclinesAreTheSameExactlyWhenTheirCommitmentDateAndReasonAllAre() {
    let magnesium = Commitment(name: "Magnesium", schedule: mwf, keptFrom: date(2026, 1, 1))!
    let zinc = Commitment(name: "Zinc", schedule: mwf, keptFrom: date(2026, 1, 1))!
    let monday = date(2026, 8, 31)

    let first = Decline(for: magnesium, on: monday, reason: "Ran out")!
    let second = Decline(for: magnesium, on: monday, reason: "Ran out")!
    #expect(first == second)
    #expect(first != Decline(for: magnesium, on: monday, reason: "Away")!)
    #expect(second != Decline(for: magnesium, on: monday, reason: nil)!)
    #expect(first != Decline(for: magnesium, on: date(2026, 9, 2), reason: "Ran out")!)
    #expect(first != Decline(for: zinc, on: monday, reason: "Ran out")!)
}
