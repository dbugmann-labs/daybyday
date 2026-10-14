import Foundation
import Testing

@testable import DayByDayKit

/// The `day`th day counted from 1 October 2026, which runs on into November.
private func date(_ day: Int) -> CalendarDate {
    CalendarDate(year: 2026, month: 10, day: 1)!.adding(days: day - 1)!
}

/// A small deterministic source of choices, so a failing sequence can be run again.
private struct Choices {
    var state: UInt64

    mutating func next(_ bound: Int) -> Int {
        state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
        return Int((state >> 33) % UInt64(bound))
    }
}

/// Every roster a commitments screen keeps is one a roster store reads: runs many sequences of days
/// away said, changed and removed and commitments stopped and taken up again, through screens opened as
/// of days in any order, and opens a roster store after every act.
@MainActor
@Test("every roster a screen keeps through stops, take-ups and changes of days away reads back")
func everyRosterAScreenKeepsThroughStopsTakeUpsAndChangesOfDaysAwayReadsBack() throws {
    var choices = Choices(state: 20_261_013)
    for sequence in 0..<150 {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let roster = directory.appendingPathComponent("roster.json")
        let every = Schedule.weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ])
        let gym = Commitment(name: "Gym", schedule: every, keptFrom: date(1).adding(days: -200)!)!
        let run = Commitment(name: "Run", schedule: every, keptFrom: date(1).adding(days: -200)!)!
        let store = try RosterStore(at: roster)
        try store.add(gym)
        try store.add(run)

        func screen(_ day: Int) -> CommitmentsScreen {
            CommitmentsScreen(
                asOf: date(day), keepingRosterAt: roster,
                keepingRecordAt: directory.appendingPathComponent("record.json"),
                keepingOneOffsAt: directory.appendingPathComponent("one-offs.json"))
        }
        var acts: [String] = []
        for _ in 0..<14 {
            let today = 1 + choices.next(31)
            let commitments = screen(today)
            let first = 1 + choices.next(28)
            let last = first + choices.next(8)
            switch choices.next(6) {
            case 0:
                acts.append("say \(first)-\(last) as of \(today)")
                commitments.sayDaysAway(
                    named: "Away", from: date(first), through: date(last),
                    over: choices.next(3) == 0 ? [gym] : [gym, run])
            case 1:
                guard let target = (commitments.daysAway + commitments.pastDaysAway).first else {
                    continue
                }
                acts.append("change to \(first)-\(last) as of \(today)")
                let picked = commitments.kept + commitments.stopped.filter { target.commitments.contains($0) }
                commitments.changeDaysAway(
                    target, named: "Away", from: date(first), through: date(last),
                    over: choices.next(4) == 0 ? Array(picked.prefix(1)) : picked)
            case 2:
                guard let target = (commitments.daysAway + commitments.pastDaysAway).first else {
                    continue
                }
                acts.append("remove as of \(today)")
                commitments.askToRemove(target)
                commitments.confirmRemovingDaysAway()
            case 3, 4:
                guard let target = commitments.kept.first(where: { $0.name == (choices.next(2) == 0 ? "Gym" : "Run") })
                else {
                    continue
                }
                acts.append("stop \(target.name) as of \(today)")
                commitments.askToStopKeeping(target)
                commitments.confirmStopKeeping()
            default:
                guard let target = commitments.stopped.first else {
                    continue
                }
                acts.append("take up \(target.name) as of \(today)")
                commitments.keepAgain(target)
            }
            do {
                _ = try RosterStore(at: roster)
            } catch {
                Issue.record("sequence \(sequence) is not read after: \(acts)")
                break
            }
        }
    }
}
