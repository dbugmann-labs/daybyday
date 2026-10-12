import Foundation
import Testing
@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private let mwf = Schedule.weekdays([.monday, .wednesday, .saturday])
private let keptFrom = date(2026, 1, 1)
private let monday = date(2026, 8, 31)
private let tuesday = date(2026, 9, 1)
private let wednesday = date(2026, 9, 2)

private func magnesium() -> Commitment {
    Commitment(name: "Magnesium", schedule: mwf, keptFrom: keptFrom)!
}

@Test("a declined day is answered declined, with its reason, and not kept")
func aDeclinedDayIsAnsweredDeclinedWithItsReasonAndNotKept() {
    let commitment = magnesium()
    let zinc = Commitment(name: "Zinc", schedule: mwf, keptFrom: keptFrom)!
    var history = History()
    #expect(history.decline(for: commitment, on: monday) == nil)

    history.add(Decline(for: commitment, on: monday, reason: "Ran out")!)

    #expect(history.decline(for: commitment, on: monday)?.reason == "Ran out")
    #expect(history.decline(for: commitment, on: monday) != nil)
    #expect(!history.isKept(commitment, on: monday))
    #expect(history.standing(for: commitment, through: date(2026, 9, 6)) == 0)
    #expect(history.decline(for: commitment, on: wednesday) == nil)
    #expect(history.decline(for: commitment, on: tuesday) == nil)
    #expect(history.decline(for: zinc, on: monday) == nil)
}

@Test("a decline added on a declined day replaces it")
func aDeclineAddedOnADeclinedDayReplacesIt() {
    let commitment = magnesium()
    var history = History()

    history.add(Decline(for: commitment, on: monday, reason: "Ran out")!)
    history.add(Decline(for: commitment, on: monday, reason: "Ran out, ordered more")!)

    #expect(history.decline(for: commitment, on: monday)?.reason == "Ran out, ordered more")
    var alone = History()
    alone.add(Decline(for: commitment, on: monday, reason: "Ran out, ordered more")!)
    #expect(history == alone)
    history.add(Decline(for: commitment, on: monday, reason: nil)!)
    #expect(history.decline(for: commitment, on: monday) != nil)
    #expect(history.decline(for: commitment, on: monday)?.reason == nil)
}

private func fourKinds() -> (gym: Commitment, weight: Commitment, journal: Commitment, protein: Commitment) {
    (
        Commitment(name: "Gym", schedule: mwf, keptFrom: keptFrom)!,
        Commitment(name: "Weight", schedule: mwf, keptFrom: keptFrom, kind: .number(range: nil))!,
        Commitment(name: "Journal", schedule: mwf, keptFrom: keptFrom, kind: .note)!,
        Commitment(
            name: "Protein", schedule: mwf, keptFrom: keptFrom,
            kind: .total(target: Commitment.Target(120)!))!
    )
}

@Test("a decline added on a day holding any other record leaves the history as it was")
func aDeclineAddedOnADayHoldingAnyOtherRecordLeavesTheHistoryAsItWas() {
    let kinds = fourKinds()
    var history = History()
    history.add(Tick(kinds.gym, on: monday)!)
    history.add(Number(70.5, for: kinds.weight, on: monday)!)
    history.add(Note("Ran 8k.", for: kinds.journal, on: monday)!)
    history.add(Addition(30, for: kinds.protein, on: monday)!)
    let before = history

    for commitment in [kinds.gym, kinds.weight, kinds.journal, kinds.protein] {
        history.add(Decline(for: commitment, on: monday, reason: "Away")!)
    }

    #expect(history == before)
    for commitment in [kinds.gym, kinds.weight, kinds.journal, kinds.protein] {
        #expect(history.decline(for: commitment, on: monday) == nil)
    }
    #expect(history.total(for: kinds.protein, on: monday) == 30)
    #expect(!history.isKept(kinds.protein, on: monday))
}

@Test("a record added on a declined day replaces the decline")
func aRecordAddedOnADeclinedDayReplacesTheDecline() {
    let kinds = fourKinds()
    let all = [kinds.gym, kinds.weight, kinds.journal, kinds.protein]
    var history = History()
    for commitment in all {
        history.add(Decline(for: commitment, on: monday, reason: "Away")!)
    }

    history.add(Tick(kinds.gym, on: monday)!)
    history.add(Number(70.5, for: kinds.weight, on: monday)!)
    history.add(Note("Ran 8k.", for: kinds.journal, on: monday)!)
    history.add(Addition(30, for: kinds.protein, on: monday)!)

    var alone = History()
    alone.add(Tick(kinds.gym, on: monday)!)
    alone.add(Number(70.5, for: kinds.weight, on: monday)!)
    alone.add(Note("Ran 8k.", for: kinds.journal, on: monday)!)
    alone.add(Addition(30, for: kinds.protein, on: monday)!)
    #expect(history == alone)
    for commitment in all {
        #expect(history.decline(for: commitment, on: monday) == nil)
    }
    #expect(history.isKept(kinds.gym, on: monday))
    #expect(history.isKept(kinds.weight, on: monday))
    #expect(history.isKept(kinds.journal, on: monday))
    #expect(!history.isKept(kinds.protein, on: monday))

    history.remove(Tick(kinds.gym, on: monday)!)
    #expect(!history.isKept(kinds.gym, on: monday))
    #expect(history.decline(for: kinds.gym, on: monday) == nil)
}

@Test("two histories given the same declines in either order are the same history")
func twoHistoriesGivenTheSameDeclinesInEitherOrderAreTheSameHistory() {
    let commitment = magnesium()
    let first = Decline(for: commitment, on: monday, reason: "Ran out")!
    let second = Decline(for: commitment, on: wednesday, reason: nil)!
    var forward = History()
    forward.add(first)
    forward.add(second)
    var backward = History()
    backward.add(second)
    backward.add(first)

    #expect(forward == backward)
    var away = History()
    away.add(Decline(for: commitment, on: monday, reason: "Away")!)
    away.add(second)
    #expect(away != forward)
    #expect(away != backward)
}

@Test("a decline taken back leaves its day holding nothing")
func aDeclineTakenBackLeavesItsDayHoldingNothing() {
    let commitment = magnesium()
    let zinc = Commitment(name: "Zinc", schedule: mwf, keptFrom: keptFrom)!
    var history = History()
    history.add(Decline(for: commitment, on: monday, reason: "Ran out")!)
    history.add(Decline(for: commitment, on: wednesday, reason: "Ran out")!)
    history.add(Decline(for: zinc, on: monday, reason: nil)!)

    history.removeDecline(for: commitment, on: monday)

    #expect(history.decline(for: commitment, on: monday) == nil)
    #expect(!history.isKept(commitment, on: monday))
    #expect(history.decline(for: commitment, on: wednesday) != nil)
    #expect(history.decline(for: zinc, on: monday) != nil)
    var one = History()
    one.add(Decline(for: commitment, on: monday, reason: nil)!)
    one.removeDecline(for: commitment, on: monday)
    #expect(one == History())
}

@Test("taking back a decline where the history holds none leaves it unchanged")
func takingBackADeclineWhereTheHistoryHoldsNoneLeavesItUnchanged() {
    let gym = Commitment(name: "Gym", schedule: mwf, keptFrom: keptFrom)!
    var history = History()
    history.add(Tick(gym, on: monday)!)
    let before = history

    history.removeDecline(for: gym, on: monday)

    #expect(history == before)
    #expect(history.isKept(gym, on: monday))
    history.removeDecline(for: gym, on: tuesday)
    #expect(history == before)
}
