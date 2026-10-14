import Foundation
import Testing

@testable import DayByDayKit

/// The `day`th day counted from 1 October 2026, which runs on into November and back into September.
private func dayN(_ day: Int) -> CalendarDate {
    CalendarDate(year: 2026, month: 10, day: 1).flatMap { $0.adding(days: day - 1) }!
}

/// The number `date` has counted as `dayN` counts.
private func number(_ date: CalendarDate) -> Int {
    dayN(1).days(until: date) + 1
}

/// A small deterministic source of choices, so a failing sequence can be run again.
private struct Choices {
    var state: UInt64

    mutating func next(_ bound: Int) -> Int {
        state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
        return Int((state >> 33) % UInt64(bound))
    }
}

/// The seed a run begins from: `DAYS_AWAY_PROPERTY_SEED` where that is set to a number, for the run alone,
/// else the committed one.
private func seed(committed: UInt64) -> UInt64 {
    ProcessInfo.processInfo.environment["DAYS_AWAY_PROPERTY_SEED"].flatMap { UInt64($0) } ?? committed
}

/// The days of 5 days before 1 October through 55 days after that each commitment is due on in the
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

/// The roster kept at `place`, or `nil` where no roster store reads it.
private func rosterRead(_ place: URL) -> Roster? {
    try? RosterStore(at: place).roster
}

/// The day a stop is taken up on, worked out from the requirement's words (*Days away remember every stop
/// and take-up*): a fixed day as it is, none as none, and for a day back the day after the last day of the
/// days away that remember it, wherever that moves — save that where that is no later than the day after
/// the stop, it is the day back the stop was taken up for.
private func takeUp(of stop: Roster.Stop, endingOn last: Int) -> Int? {
    switch stop.takeUp {
    case nil:
        return nil
    case .day(let day):
        return number(day)
    case .dayBack(madeFor: let day):
        return last + 1 > number(stop.day) + 1 ? last + 1 : number(day)
    }
}

/// The days a stop keeps its commitment out of — from the day after its day kept until to the day before
/// its take-up, endless where it has none — or `nil` where they are none.
private func gap(of stop: Roster.Stop, endingOn last: Int) -> ClosedRange<Int>? {
    let first = number(stop.day) + 1
    let end = takeUp(of: stop, endingOn: last).map { $0 - 1 } ?? 100_000
    return first <= end ? first...end : nil
}

/// Whether a commitment holds a day in the gap of a stop of it that the days away over that day do not
/// remember, whether none do or only other days away, whichever days away were said, changed or removed to
/// bring it there — the state of the known gap *Days away can make a stopped commitment owe a day inside
/// its stop*.
private func holdsADayInAGapOfAStopNotRemembered(_ roster: Roster) -> Bool {
    onlyOtherDaysAwayRememberAStop(roster, byGap: true) || aStopNobodyRemembers(roster)
}

/// Whether some days away hold a day in the gap of a stop of a commitment that only other days away remember;
/// with `byGap` a stop they remember with another gap is not one they know of, else any stop of the same day is.
private func onlyOtherDaysAwayRememberAStop(_ roster: Roster, byGap: Bool) -> Bool {
    for span in roster.spans {
        for commitment in span.commitments {
            let own = span.remembers[commitment] ?? []
            for other in roster.spans where other.identity != span.identity {
                for stop in other.remembers[commitment] ?? [] {
                    // A stop these days away remember with the same gap is one they know of; the same
                    // stop with another gap, a take-up another days away made that has since gone stale,
                    // is not.
                    guard let theirs = gap(of: stop, endingOn: number(other.lastDay)),
                        !own.contains(where: {
                            $0.day == stop.day
                                && (!byGap || gap(of: $0, endingOn: number(span.lastDay)) == theirs)
                        })
                    else {
                        continue
                    }
                    if theirs.overlaps(number(span.firstDay)...number(span.lastDay)) {
                        return true
                    }
                }
            }
        }
    }
    return false
}

/// Whether some days away hold a day in a gap of a stop that they do not remember, whoever does.
private func aStopNobodyRemembers(_ roster: Roster) -> Bool {
    // A stretch of days the eras of a commitment do not hold that reaches past every days away over it is
    // a stop's gap; days away holding a day of it that remember no stop with a gap there are in the state.
    let top = 200
    var identities: [Commitment.Identity] = []
    for span in roster.spans {
        for identity in span.commitments where !identities.contains(identity) {
            identities.append(identity)
        }
    }
    for identity in identities {
        let eras = roster.entries.filter { $0.commitment.identity == identity }
        guard let earliest = eras.map({ number($0.commitment.keptFrom) }).min() else { continue }
        // held[day - earliest] for the days from the earliest through `top`.
        var held = [Bool](repeating: false, count: max(top - earliest + 1, 0))
        for era in eras {
            let from = number(era.commitment.keptFrom)
            let to = min(era.keptUntil.map { number($0) } ?? top, top)
            if from <= to { for day in from...to { held[day - earliest] = true } }
        }
        let over = roster.spans.filter { $0.commitments.contains(identity) }
        var covered = [Bool](repeating: false, count: held.count)
        for span in over {
            for day in max(number(span.firstDay), earliest)...max(number(span.lastDay), earliest) where day - earliest < covered.count {
                covered[day - earliest] = true
            }
            // The gaps of the stops they remember are theirs too.
            for stop in span.remembers[identity] ?? [] {
                if let gap = gap(of: stop, endingOn: number(span.lastDay)),
                    max(gap.lowerBound, earliest) <= min(gap.upperBound, top)
                {
                    for day in max(gap.lowerBound, earliest)...min(gap.upperBound, top) {
                        covered[day - earliest] = true
                    }
                }
            }
        }
        func isHeld(_ day: Int) -> Bool { day < earliest || day > top || held[day - earliest] }
        for span in over {
            for day in max(number(span.firstDay), earliest)...max(number(span.lastDay), earliest) where !isHeld(day) {
                var from = day
                while from - 1 >= earliest, !isHeld(from - 1) { from -= 1 }
                var to = day
                while to < top, !isHeld(to + 1) { to += 1 }
                // A stretch the days away over the commitment, and the stops they remember, explain whole is
                // theirs; a stretch with days they do not is the gap of a stop none of them remembers.
                if (from...to).contains(where: { !covered[$0 - earliest] }) {
                    return true
                }
            }
        }
    }
    return false
}

/// A day inside some of `spans` over `commitment`, moving `clock` to it where days only move forward, or
/// `nil` where there is none to reach.
private func daysInside(
    _ spans: [DaysAway], over commitment: Commitment, notBefore earliest: Int, clock: inout Int,
    forward: Bool, choices: inout Choices
) -> Int? {
    let over = spans.filter { span in span.commitments.contains { $0.identity == commitment.identity } }
    guard !over.isEmpty else {
        return nil
    }
    let span = over[choices.next(over.count)]
    let first = number(span.firstDay)
    let last = number(span.lastDay)
    if forward {
        guard clock <= last else {
            return nil
        }
        clock = max(clock, first)
        return clock
    }
    let from = max(first, earliest)
    return from <= last ? from + choices.next(last - from + 1) : first + choices.next(last - first + 1)
}

/// What a run counted, so that the checks it makes are shown to have run.
private struct Tally {
    var renamed = 0
    var movedBack = 0
    var oneOrTwo = 0
    var removed = 0
    var takeUpsInside = 0
    var takeUpsWhileTwo = 0
    var changesOfOthers = 0
    var removalsOfOthers = 0
    var deletions = 0
    /// The acts left out only because a stop another days away remember with another gap is not known.
    var leftOutByGapAlone: [String] = []
}

/// Every roster a commitments screen keeps through days away said, changed and removed and commitments
/// stopped, taken up again and deleted is one a roster store reads, and the days of every commitment
/// obey what days away promise: (a) a roster store opened afterwards reads what was written and no act is
/// refused as a roster that could not be written; (b) renaming days away, their days and picks as they
/// are, changes no day; (c) a change followed by its move back restores every day; (d) the same days
/// reached in one change or two leave the same days; (e) a removal confirmed leaves each commitment it
/// was over held, Gym and Run due, on every day of the days away removed that lies in no other days away
/// over it and in no gap of a stop they remembered, owing no day in such a gap, and changes no day of a
/// commitment it was not over. A step refused for a reason the specification gives is skipped.
///
/// The generator leaves out exactly the states of the two known gaps in `docs/open-questions.md`, an act
/// that would leave one being made as though it never was: days away over a commitment holding a day in
/// the gap of a stop of it that only other days away remember, whichever of them was said or changed to
/// bring it there (*Days away can make a stopped commitment owe a day inside its stop*); and a stop or
/// take-up through a screen opened as of a day before an earlier stop or take-up of the commitment was
/// made as of, while days away are over it (*A stop or take-up made through a screen opened as of an
/// earlier day…*).
@MainActor
private func checkEveryActLeavesDaysAwayAsPromised(clockMovesForward: Bool) throws -> Tally {
    var choices = Choices(state: seed(committed: clockMovesForward ? 402_777 : 402_006))
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
        var lastActAsOf: [String: Int] = [:]
        var clock = 1
        for iteration in 0..<12 {
            let current = try RosterStore(at: roster).roster
            var today: Int
            if clockMovesForward {
                clock += choices.next(4)
                today = clock
            } else {
                today = 1 + choices.next(40)
            }
            // A third of the screens are opened inside some days away, where stops and take-ups are
            // made while days away are under way.
            let existing = current.daysAway
            if !existing.isEmpty, choices.next(3) == 0 {
                let inside = existing[choices.next(existing.count)]
                let first = number(inside.firstDay)
                let last = number(inside.lastDay)
                if clockMovesForward {
                    if clock <= last {
                        clock = max(clock, first)
                        today = clock
                    }
                } else {
                    today = first + choices.next(last - first + 1)
                }
            }
            var commitments = screen(roster, asOf: today)
            // Every sequence begins by saying days away over everything kept, twice, the second beginning the
            // day after the first ends, so that two days away are over each commitment from the start.
            var first = 1 + choices.next(36)
            var last = first + choices.next(9)
            if iteration == 0 {
                first = 5 + choices.next(10)
                last = first + choices.next(5)
            }
            var refusal: CommitmentsScreen.Refusal?
            let snapshot = try Data(contentsOf: roster)
            let tallyBefore = tally
            let lastActBefore = lastActAsOf

            let pick = iteration == 0 ? 0 : iteration == 1 ? 6 : iteration == 2 ? 18 : iteration == 3 ? 23 : choices.next(37)
            switch pick {
            case 0, 1, 2, 3, 4, 5:
                let over = commitments.kept.filter { _ in iteration == 0 || choices.next(4) != 0 }
                acts.append("say \(first)-\(last) over \(over.map(\.name)) as of \(today)")
                refusal = commitments.sayDaysAway(
                    named: "S\(acts.count)", from: dayN(first), through: dayN(last), over: over)
            case 6, 7, 8:
                // Days away that begin the day after others end.
                guard let neighbour = listed(commitments).randomElement(using: &choices) else {
                    continue
                }
                let begin = number(neighbour.lastDay) + 1
                let end = begin + choices.next(5)
                guard begin <= 40 else { continue }
                let over = commitments.kept.filter { kept in
                    iteration == 1 || neighbour.commitments.contains { $0.identity == kept.identity } || choices.next(4) == 0
                }
                acts.append("say \(begin)-\(end) over \(over.map(\.name)) as of \(today)")
                refusal = commitments.sayDaysAway(
                    named: "S\(acts.count)", from: dayN(begin), through: dayN(end), over: over)
            case 9, 10, 11, 12, 13, 34, 35:
                let all = listed(commitments)
                guard !all.isEmpty else { continue }
                let index = choices.next(all.count)
                let target = all[index]
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
                if refusal == nil, index > 0 {
                    tally.changesOfOthers += 1
                }
            case 14, 15, 16, 17, 36:
                let all = listed(commitments)
                guard !all.isEmpty else { continue }
                let index = choices.next(all.count)
                let target = all[index]
                acts.append("remove \(target.title) as of \(today)")
                commitments.askToRemove(target)
                refusal = commitments.confirmRemovingDaysAway()
                if refusal == nil, index > 0 {
                    tally.removalsOfOthers += 1
                }
            case 18, 19, 20, 21, 22:
                guard !commitments.kept.isEmpty else { continue }
                let target = commitments.kept[choices.next(commitments.kept.count)]
                if choices.next(10) != 0, let moved = daysInside(existing, over: target, notBefore: lastActAsOf[target.name] ?? Int.min, clock: &clock, forward: clockMovesForward, choices: &choices) {
                    today = moved
                    commitments = screen(roster, asOf: today)
                }
                if let earlier = lastActAsOf[target.name], today < earlier,
                    current.spans.contains(where: { $0.commitments.contains(target.identity) })
                {
                    continue
                }
                acts.append("stop \(target.name) as of \(today)")
                commitments.askToStopKeeping(target)
                refusal = commitments.confirmStopKeeping()
                if refusal == nil {
                    lastActAsOf[target.name] = today
                }
            case 23, 24, 25, 26, 27, 28, 29, 30:
                guard !commitments.stopped.isEmpty else { continue }
                let target = commitments.stopped[choices.next(commitments.stopped.count)]
                if choices.next(10) != 0, let moved = daysInside(existing, over: target, notBefore: lastActAsOf[target.name] ?? Int.min, clock: &clock, forward: clockMovesForward, choices: &choices) {
                    today = moved
                    commitments = screen(roster, asOf: today)
                }
                if let earlier = lastActAsOf[target.name], today < earlier,
                    current.spans.contains(where: { $0.commitments.contains(target.identity) })
                {
                    continue
                }
                acts.append("take up \(target.name) as of \(today)")
                let over = existing.filter { span in span.commitments.contains { $0.identity == target.identity } }
                refusal = commitments.keepAgain(target)
                if refusal == nil {
                    lastActAsOf[target.name] = today
                    if over.contains(where: { number($0.firstDay) <= today && today <= number($0.lastDay) }) {
                        tally.takeUpsInside += 1
                    }
                    if over.count >= 2 {
                        tally.takeUpsWhileTwo += 1
                    }
                }
            default:
                let everything = commitments.kept + commitments.stopped
                guard !everything.isEmpty, choices.next(2) == 0 else { continue }
                let target = everything[choices.next(everything.count)]
                acts.append("delete \(target.name) as of \(today)")
                commitments.askToDelete(target)
                commitments.nameTypedBack = target.name
                refusal = commitments.confirmDeleting()
                if refusal == nil, !(commitments.kept + commitments.stopped).contains(target) {
                    tally.deletions += 1
                }
            }

            // An act that leaves the state of a known gap is left out, as though never made.
            if let held = rosterRead(roster), holdsADayInAGapOfAStopNotRemembered(held) {
                try snapshot.write(to: roster)
                let byGapAlone = !onlyOtherDaysAwayRememberAStop(held, byGap: false) && !aStopNobodyRemembers(held)
                tally = tallyBefore
                if byGapAlone {
                    tally.leftOutByGapAlone.append("sequence \(sequence), after \(acts)")
                }
                lastActAsOf = lastActBefore
                acts.removeLast()
                continue
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

            // (e) A removal confirmed leaves each commitment it was over held, and Gym and Run due, on every
            // day of the days away removed that lies in no other days away over it and in no gap of a stop
            // they remembered, owing no day in such a gap, and changes no day of a commitment it was not over.
            do {
                let removal = try copy(of: roster)
                let atRemoval = screen(removal, asOf: today)
                let spans = listed(atRemoval)
                if !spans.isEmpty {
                    let gone = spans[choices.next(spans.count)]
                    if let wasRoster = rosterRead(removal), let remembered = wasRoster.spans.first(where: { $0.identity == gone.identity }) {
                        atRemoval.askToRemove(gone)
                        let refused = atRemoval.confirmRemovingDaysAway()
                        if refused == nil, let nowRoster = rosterRead(removal), nowRoster.spans.count == wasRoster.spans.count - 1,
                            !holdsADayInAGapOfAStopNotRemembered(nowRoster),
                            let now = dueDays(at: removal)
                        {
                            tally.removed += 1
                            var problems: [String] = []
                            let overNames = Set(gone.commitments.map(\.name))
                            for commitment in gone.commitments
                            where nowRoster.entries.contains(where: { $0.commitment.identity == commitment.identity }) {
                                let others = wasRoster.spans.filter {
                                    $0.identity != gone.identity && $0.commitments.contains(commitment.identity)
                                }
                                let gaps = (remembered.remembers[commitment.identity] ?? []).compactMap {
                                    gap(of: $0, endingOn: number(gone.lastDay))
                                }
                                for day in number(gone.firstDay)...number(gone.lastDay) {
                                    let inOther = others.contains {
                                        number($0.firstDay) <= day && day <= number($0.lastDay)
                                    }
                                    guard !inOther, !gaps.contains(where: { $0.contains(day) }) else {
                                        continue
                                    }
                                    let held = nowRoster.entries.contains {
                                        $0.commitment.identity == commitment.identity
                                            && $0.commitment.keptFrom.days(until: dayN(day)) >= 0
                                            && ($0.keptUntil.map { dayN(day).days(until: $0) >= 0 } ?? true)
                                    }
                                    if !held {
                                        problems.append("\(commitment.name) not held on \(day)")
                                    } else if commitment.name != "Nails", !(now[commitment.name]?.contains(day) ?? false) {
                                        problems.append("\(commitment.name) not due on \(day)")
                                    }
                                }
                                for gap in gaps {
                                    for day in gap.clamped(to: -5...55) where now[commitment.name]?.contains(day) ?? false {
                                        problems.append("\(commitment.name) owed on \(day) inside a stop's gap \(gap)")
                                    }
                                }
                            }
                            let rest = before.filter { !overNames.contains($0.key) }
                            let restNow = now.filter { !overNames.contains($0.key) }
                            let restChanged = differences(rest, restNow)
                            if !restChanged.isEmpty {
                                problems.append("a commitment it was not over changed (\(restChanged))")
                            }
                            if !problems.isEmpty {
                                failures.append(
                                    "sequence \(sequence): removing \(gone.title) \(number(gone.firstDay))-\(number(gone.lastDay)): \(problems.prefix(4).joined(separator: "; ")), after \(acts)"
                                )
                            }
                        }
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
            /// Changes `span` on `screen`, kept at `place`, answering whether it was kept; a change refused
            /// as a roster that could not be written is a failure, any other refusal a skip, and so is a
            /// change onto the shape of a known gap.
            func change(
                _ screen: CommitmentsScreen, at place: URL, _ span: DaysAway, _ from: CalendarDate,
                _ through: CalendarDate
            ) -> Bool {
                let snapshot = try? Data(contentsOf: place)
                let refusal = screen.changeDaysAway(
                    span, named: target.name ?? "", from: from, through: through, over: span.commitments)
                if refusal == .notKept {
                    failures.append("sequence \(sequence): a change refused as unwritable, after \(acts)")
                }
                if refusal == nil, let held = rosterRead(place), holdsADayInAGapOfAStopNotRemembered(held) {
                    if let snapshot { try? snapshot.write(to: place) }
                    return false
                }
                return refusal == nil
            }
            let moved = try copy(of: roster)
            let atMoved = screen(moved, asOf: today)
            guard let there = listed(atMoved).first(where: { $0 == target }),
                change(atMoved, at: moved, there, dayN(newFirst), dayN(newLast)),
                let now = listed(atMoved).first(where: { $0 == target }),
                Set(now.commitments.map(\.identity)) == Set(target.commitments.map(\.identity))
            else {
                continue
            }
            let inOne = dueDays(at: moved)
            if change(atMoved, at: moved, now, target.firstDay, target.lastDay) {
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
                change(atTwice, at: twice, start, stepFirst, stepLast),
                let middle = listed(atTwice).first(where: { $0 == target }),
                Set(middle.commitments.map(\.identity)) == Set(target.commitments.map(\.identity)),
                change(atTwice, at: twice, middle, dayN(newFirst), dayN(newLast)),
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

/// Fails unless the run did each thing often enough for its passing to mean something.
private func expectEnough(_ tally: Tally, _ mode: String) {
    print(
        "days away property, \(mode): (b) \(tally.renamed), (c) \(tally.movedBack), (d) \(tally.oneOrTwo), (e) \(tally.removed) ran unskipped; take-ups inside days away \(tally.takeUpsInside), while two are over it \(tally.takeUpsWhileTwo); kept changes of others \(tally.changesOfOthers); confirmed removals of others \(tally.removalsOfOthers); deletions \(tally.deletions)"
    )
    for left in tally.leftOutByGapAlone { print("left out by the gap match alone, \(mode): \(left)") }
    #expect(tally.renamed >= 400 && tally.movedBack >= 400 && tally.oneOrTwo >= 400 && tally.removed >= 400)
    #expect(tally.takeUpsInside >= 50, "take-ups kept inside days away")
    #expect(tally.takeUpsWhileTwo >= 50, "take-ups kept while two days away are over the commitment")
    #expect(tally.changesOfOthers >= 150, "kept changes of days away other than the first listed")
    #expect(tally.removalsOfOthers >= 150, "confirmed removals of days away other than the first listed")
    #expect(tally.deletions >= 50, "deletions taking effect")
}

@MainActor
@Test("every act on days away leaves every commitment's days as days away promise, as of days moving forward")
func everyActOnDaysAwayLeavesEveryCommitmentsDaysAsDaysAwayPromiseAsOfDaysMovingForward() throws {
    expectEnough(try checkEveryActLeavesDaysAwayAsPromised(clockMovesForward: true), "days moving forward")
}

@MainActor
@Test("every act on days away leaves every commitment's days as days away promise, as of days in any order")
func everyActOnDaysAwayLeavesEveryCommitmentsDaysAsDaysAwayPromiseAsOfDaysInAnyOrder() throws {
    expectEnough(try checkEveryActLeavesDaysAwayAsPromised(clockMovesForward: false), "days in any order")
}
