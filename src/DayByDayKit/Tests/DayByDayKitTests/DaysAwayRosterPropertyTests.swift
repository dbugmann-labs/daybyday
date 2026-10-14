import Foundation
import Testing

@testable import DayByDayKit

/// The `day`th day counted from 1 October 2026, which runs on into November and back into September.
private func dayN(_ day: Int) -> CalendarDate {
    CalendarDate(year: 2026, month: 10, day: 1).flatMap { $0.adding(days: day - 1) }!
}

/// A small deterministic source of choices, so a failing sequence can be run again.
private struct Choices {
    var state: UInt64

    mutating func next(_ bound: Int) -> Int {
        state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
        return Int((state >> 33) % UInt64(bound))
    }
}

/// The days of 1 October through 20 November that each of the three commitments is due on in the
/// roster kept at `place`, or `nil` where no roster store reads it.
private func dueDays(at place: URL) -> [String: Set<Int>]? {
    guard let roster = try? RosterStore(at: place).roster else {
        return nil
    }
    var due: [String: Set<Int>] = [:]
    for day in -5...55 {
        let date = dayN(day)
        for commitment in roster.groups(on: date).flatMap(\.commitments) where commitment.isDue(on: date) {
            due[commitment.name, default: []].insert(day)
        }
    }
    return due
}

/// What differs between two maps of due days, or an empty string.
private func differences(_ before: [String: Set<Int>], _ after: [String: Set<Int>]) -> String {
    Set(before.keys).union(after.keys).sorted().compactMap { name in
        let was = before[name] ?? []
        let now = after[name] ?? []
        return was == now
            ? nil : "\(name): lost \(was.subtracting(now).sorted()) gained \(now.subtracting(was).sorted())"
    }.joined(separator: "; ")
}

/// A copy of the roster kept at `place`, in a directory of its own.
private func copy(of place: URL) throws -> URL {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let copied = directory.appendingPathComponent("roster.json")
    try FileManager.default.copyItem(at: place, to: copied)
    return copied
}

@MainActor
private func screen(_ roster: URL, asOf day: Int) -> CommitmentsScreen {
    let directory = roster.deletingLastPathComponent()
    return CommitmentsScreen(
        asOf: dayN(day), keepingRosterAt: roster,
        keepingRecordAt: directory.appendingPathComponent("record.json"),
        keepingOneOffsAt: directory.appendingPathComponent("one-offs.json"))
}

@MainActor
private func listed(_ screen: CommitmentsScreen) -> [DaysAway] {
    screen.daysAway + screen.pastDaysAway
}

/// How many times each of (b), (c) and (d) ran unskipped.
private struct Tally {
    var renamed = 0
    var movedBack = 0
    var oneOrTwo = 0
}

/// Every roster a commitments screen keeps through days away said, changed and removed and commitments
/// stopped, taken up again and deleted is one a roster store reads, and the days of every commitment
/// obey what days away promise: (a) a roster store opened afterwards reads what was written and no act is
/// refused as a roster that could not be written; (b) renaming days away, their days and picks as they
/// are, changes no day; (c) a change followed by its move back restores every day; (d) the same days
/// reached in one change or two leave the same days. A step refused for a reason the specification
/// gives is skipped.
@MainActor
private func checkEveryActLeavesDaysAwayAsPromised(clockMovesForward: Bool) throws -> Tally {
    var choices = Choices(state: clockMovesForward ? 402_777 : 402_006)
    var tally = Tally()
    var failures: [String] = []

    for sequence in 0..<400 {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let roster = directory.appendingPathComponent("roster.json")
        let every = Schedule.weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ])
        let store = try RosterStore(at: roster)
        try store.add(Commitment(name: "Gym", schedule: every, keptFrom: dayN(-60))!)
        try store.add(Commitment(name: "Run", schedule: every, keptFrom: dayN(-60))!)
        try store.add(
            Commitment(
                name: "Nails", schedule: .everyNDays(DayInterval(days: 3)!, from: dayN(-60)),
                keptFrom: dayN(-60))!)

        var acts: [String] = []
        var clock = 1
        for _ in 0..<12 {
            let today: Int
            if clockMovesForward {
                clock += choices.next(4)
                today = clock
            } else {
                today = 1 + choices.next(40)
            }
            let commitments = screen(roster, asOf: today)
            let first = 1 + choices.next(36)
            let last = first + choices.next(9)
            var refusal: CommitmentsScreen.Refusal?

            switch choices.next(10) {
            case 0, 1:
                let over = commitments.kept.filter { _ in choices.next(2) == 0 }
                acts.append("say \(first)-\(last) over \(over.map(\.name)) as of \(today)")
                refusal = commitments.sayDaysAway(
                    named: "S\(acts.count)", from: dayN(first), through: dayN(last), over: over)
            case 2:
                // Days away that begin the day after others end.
                guard let neighbour = listed(commitments).randomElement(using: &choices) else {
                    continue
                }
                let begin = dayN(1).days(until: neighbour.lastDay) + 2
                let end = begin + choices.next(5)
                let over = commitments.kept.filter { _ in choices.next(2) == 0 }
                acts.append("say \(begin)-\(end) over \(over.map(\.name)) as of \(today)")
                refusal = commitments.sayDaysAway(
                    named: "S\(acts.count)", from: dayN(begin), through: dayN(end), over: over)
            case 3, 4:
                let all = listed(commitments)
                guard !all.isEmpty else { continue }
                let target = all[choices.next(all.count)]
                let pool = commitments.kept + commitments.stopped.filter { target.commitments.contains($0) }
                var from = target.firstDay
                var through = target.lastDay
                var picked = target.commitments
                var name = target.name ?? ""
                switch choices.next(4) {
                case 0:
                    from = dayN(first)
                    through = dayN(last)
                    picked = pool.filter { _ in choices.next(3) != 0 }
                case 1:
                    from = dayN(first)
                    through = dayN(last)
                case 2:
                    picked = pool.filter { _ in choices.next(3) != 0 }
                default:
                    name = "N\(acts.count)"
                }
                acts.append(
                    "change \(target.title) to \(from)-\(through) over \(picked.map(\.name)) as of \(today)")
                refusal = commitments.changeDaysAway(
                    target, named: name, from: from, through: through, over: picked)
            case 5:
                let all = listed(commitments)
                guard !all.isEmpty else { continue }
                let target = all[choices.next(all.count)]
                acts.append("remove \(target.title) as of \(today)")
                commitments.askToRemove(target)
                refusal = commitments.confirmRemovingDaysAway()
            case 6, 7:
                guard !commitments.kept.isEmpty else { continue }
                let target = commitments.kept[choices.next(commitments.kept.count)]
                acts.append("stop \(target.name) as of \(today)")
                commitments.askToStopKeeping(target)
                refusal = commitments.confirmStopKeeping()
            case 8:
                guard !commitments.stopped.isEmpty else { continue }
                let target = commitments.stopped[choices.next(commitments.stopped.count)]
                acts.append("take up \(target.name) as of \(today)")
                refusal = commitments.keepAgain(target)
            default:
                guard choices.next(4) == 0,
                    let target = (commitments.kept + commitments.stopped).first(where: { $0.name == "Run" })
                else {
                    continue
                }
                acts.append("delete Run as of \(today)")
                commitments.askToDelete(target)
                refusal = commitments.confirmDeleting()
            }

            // (a) A roster store reads what was written, and no act was refused as unwritable.
            if refusal == .notKept {
                failures.append("sequence \(sequence): refused as a roster that could not be written, after \(acts)")
                break
            }
            guard let before = dueDays(at: roster) else {
                failures.append("sequence \(sequence): a roster store refuses what was written, after \(acts)")
                break
            }
            let reopened = screen(roster, asOf: today)
            if listed(reopened).map({ "\($0.title) \($0.daysInWords)" })
                != listed(commitments).map({ "\($0.title) \($0.daysInWords)" })
            {
                failures.append("sequence \(sequence): a roster store reads other days away than were written, after \(acts)")
                break
            }

            // (b) Renaming each listed days away, same days and picks, changes no day.
            do {
                let renamed = try copy(of: roster)
                let atCopy = screen(renamed, asOf: today)
                var ran = false
                for span in listed(atCopy) {
                    if atCopy.changeDaysAway(
                        span, named: "R" + (span.name ?? ""), from: span.firstDay, through: span.lastDay,
                        over: span.commitments) == nil
                    {
                        ran = true
                    } else if atCopy.daysAwayRefusal == .notKept {
                        failures.append("sequence \(sequence): a rename refused as unwritable, after \(acts)")
                    }
                }
                if ran {
                    tally.renamed += 1
                    if let after = dueDays(at: renamed) {
                        let changed = differences(before, after)
                        if !changed.isEmpty {
                            failures.append("sequence \(sequence): renaming changed days (\(changed)), after \(acts)")
                        }
                    } else {
                        failures.append("sequence \(sequence): a rename left a roster no store reads, after \(acts)")
                    }
                }
            }

            // (c) and (d) A change to other days, followed by its move back, and the same days reached
            // in one change or two.
            let all = listed(commitments)
            guard !all.isEmpty else { continue }
            let target = all[choices.next(all.count)]
            let newFirst = 1 + choices.next(36)
            let newLast = newFirst + choices.next(9)
            /// Changes `span` on `screen`, answering whether it was kept; a change refused as a roster that
            /// could not be written is a failure, any other refusal a skip.
            func change(_ screen: CommitmentsScreen, _ span: DaysAway, _ from: CalendarDate, _ through: CalendarDate)
                -> Bool
            {
                let refusal = screen.changeDaysAway(
                    span, named: target.name ?? "", from: from, through: through, over: span.commitments)
                if refusal == .notKept {
                    failures.append("sequence \(sequence): a change refused as unwritable, after \(acts)")
                }
                return refusal == nil
            }
            let moved = try copy(of: roster)
            let atMoved = screen(moved, asOf: today)
            guard let there = listed(atMoved).first(where: { $0 == target }),
                change(atMoved, there, dayN(newFirst), dayN(newLast)),
                let now = listed(atMoved).first(where: { $0 == target }),
                Set(now.commitments.map(\.identity)) == Set(target.commitments.map(\.identity))
            else {
                continue
            }
            let inOne = dueDays(at: moved)
            if change(atMoved, now, target.firstDay, target.lastDay) {
                tally.movedBack += 1
                if let back = dueDays(at: moved) {
                    let changed = differences(before, back)
                    if !changed.isEmpty {
                        failures.append(
                            "sequence \(sequence): \(target.title) \(target.firstDay)-\(target.lastDay) moved to \(newFirst)-\(newLast) and back changed days (\(changed)), after \(acts)"
                        )
                    }
                } else {
                    failures.append("sequence \(sequence): a move back left a roster no store reads, after \(acts)")
                }
            }

            let twice = try copy(of: roster)
            let atTwice = screen(twice, asOf: today)
            guard let start = listed(atTwice).first(where: { $0 == target }) else { continue }
            let lastFirst = target.firstDay.days(until: dayN(newLast)) >= 0
            let stepFirst = lastFirst ? target.firstDay : dayN(newFirst)
            let stepLast = lastFirst ? dayN(newLast) : target.lastDay
            guard
                change(atTwice, start, stepFirst, stepLast),
                let middle = listed(atTwice).first(where: { $0 == target }),
                Set(middle.commitments.map(\.identity)) == Set(target.commitments.map(\.identity)),
                change(atTwice, middle, dayN(newFirst), dayN(newLast)),
                let two = dueDays(at: twice), let one = inOne
            else {
                continue
            }
            tally.oneOrTwo += 1
            let changed = differences(one, two)
            if !changed.isEmpty {
                failures.append(
                    "sequence \(sequence): \(target.title) \(target.firstDay)-\(target.lastDay) to \(newFirst)-\(newLast) in one change and in two leave different days (\(changed)), after \(acts)"
                )
            }
        }
    }

    for failure in failures.prefix(6) {
        Issue.record(Comment(rawValue: failure))
    }
    #expect(failures.isEmpty, "\(failures.count) failing sequences")
    return tally
}

extension Array {
    fileprivate func randomElement(using choices: inout Choices) -> Element? {
        isEmpty ? nil : self[choices.next(count)]
    }
}

@MainActor
@Test("every act on days away leaves every commitment's days as days away promise, as of days moving forward")
func everyActOnDaysAwayLeavesEveryCommitmentsDaysAsDaysAwayPromiseAsOfDaysMovingForward() throws {
    let tally = try checkEveryActLeavesDaysAwayAsPromised(clockMovesForward: true)
    print("days away property, days moving forward: (b) \(tally.renamed), (c) \(tally.movedBack), (d) \(tally.oneOrTwo) ran unskipped")
    #expect(tally.renamed > 400 && tally.movedBack > 400 && tally.oneOrTwo > 400)
}

@MainActor
@Test("every act on days away leaves every commitment's days as days away promise, as of days in any order")
func everyActOnDaysAwayLeavesEveryCommitmentsDaysAsDaysAwayPromiseAsOfDaysInAnyOrder() throws {
    let tally = try checkEveryActLeavesDaysAwayAsPromised(clockMovesForward: false)
    print("days away property, days in any order: (b) \(tally.renamed), (c) \(tally.movedBack), (d) \(tally.oneOrTwo) ran unskipped")
    #expect(tally.renamed > 400 && tally.movedBack > 400 && tally.oneOrTwo > 400)
}
