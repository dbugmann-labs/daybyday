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

/// The days every check reads: past every day any act in a sequence names, which the clock and the
/// days said never leave.
private let window = -5...80

/// A small deterministic source of choices, so a failing sequence can be run again.
private struct Choices {
    var state: UInt64

    mutating func next(_ bound: Int) -> Int {
        state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
        return Int((state >> 33) % UInt64(bound))
    }

    mutating func chance(_ one: Int, in all: Int) -> Bool {
        next(all) < one
    }
}

/// The seed a run begins from: `DAYS_AWAY_PROPERTY_SEED` where that is set to a number, for the run alone,
/// else the committed one.
private func seed(committed: UInt64) -> UInt64 {
    ProcessInfo.processInfo.environment["DAYS_AWAY_PROPERTY_SEED"].flatMap { UInt64($0) } ?? committed
}

/// The roster kept at `place`, or `nil` where no roster store reads it.
private func rosterRead(_ place: URL) -> Roster? {
    try? RosterStore(at: place).roster
}

/// The days of the window each commitment is due on in the roster kept at `place`, read as a day
/// screen reads it, or `nil` where no roster store reads it.
private func dueDays(at place: URL) -> [String: Set<Int>]? {
    rosterRead(place).map(dueDays)
}

private func dueDays(_ roster: Roster) -> [String: Set<Int>] {
    var due: [String: Set<Int>] = [:]
    for day in window {
        let date = dayN(day)
        for commitment in roster.groups(on: date).flatMap(\.commitments) where commitment.isDue(on: date) {
            due[commitment.name, default: []].insert(day)
        }
    }
    return due
}

/// The days of the window each commitment is due on, worked out from the eras and days away of
/// `roster` alone — never through the read under test: a day is due when an era holds it, no days
/// away over the commitment cover it, and the rhythm of the era is due on it, an every-N-days era
/// counted again from the latest day after days away over the commitment that it holds, on or
/// before the day.
private func dueDaysOnTheEras(_ roster: Roster) -> [String: Set<Int>] {
    var due: [String: Set<Int>] = [:]
    for entry in roster.entries {
        let over = roster.spans.filter { $0.commitments.contains(entry.commitment.identity) }
        let from = number(entry.commitment.keptFrom)
        let until = entry.keptUntil.map(number) ?? Int.max
        for day in window where from <= day && day <= until {
            if over.contains(where: { number($0.firstDay) <= day && day <= number($0.lastDay) }) {
                continue
            }
            var schedule = entry.commitment.schedule
            if case .everyNDays(let interval, from: _) = schedule {
                let restarts = over.map { number($0.lastDay) + 1 }.filter { from <= $0 && $0 <= until && $0 <= day }
                if let latest = restarts.max() {
                    schedule = .everyNDays(interval, from: dayN(latest))
                }
            }
            if schedule.isDue(on: dayN(day)) {
                due[entry.commitment.name, default: []].insert(day)
            }
        }
    }
    return due
}

/// Whether a change of `target` to days beginning on `first` moves them wholly past the day after
/// the stop of a stopped commitment they are over, in `roster`.
private func movesWhollyPastAStop(_ target: DaysAway, to first: CalendarDate, in roster: Roster) -> Bool {
    target.commitments.contains { pick in
        roster.entries.first { $0.commitment.identity == pick.identity }?.keptUntil
            .map { number(first) > number($0) + 1 } ?? false
    }
}

/// Whether `schedule` counts every N days.
private func countsEveryNDays(_ schedule: Schedule) -> Bool {
    if case .everyNDays = schedule { return true }
    return false
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

/// A day inside some of `spans` over `commitment`, moving `clock` to it where days only move forward, or
/// `nil` where there is none to reach.
private func daysInside(
    _ spans: [DaysAway], over commitment: Commitment, clock: inout Int, forward: Bool,
    choices: inout Choices
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
    return first + choices.next(last - first + 1)
}

/// What a run counted, so that the checks it makes are shown to have run.
private struct Tally {
    var renamed = 0
    var movedBack = 0
    var oneOrTwo = 0
    var oneOrTwoBothEndsMoved = 0
    var removed = 0
    var takeUpsInside = 0
    var rhythmChangesInside = 0
    var changesOfOthers = 0
    var removalsOfOthers = 0
    var deletions = 0
    /// Kept changes moving days away over a stopped pick wholly past the day after its stop.
    var changesWhollyPastAStop = 0
}

/// Every roster a commitments screen keeps through days away said, changed and removed and commitments
/// stopped, taken up again, changed in rhythm and deleted is one a roster store reads, and the days of
/// every commitment, stopped ones included, obey what days away promise, with no act, check, sequence or
/// refusal excluded: (a) a roster store opened afterwards reads what was written and no act is refused
/// as a roster that could not be written; (b) renaming each listed days away, their days and picks as
/// they are, is kept and changes no day; (c) a change followed by its move back restores every day; (d)
/// the same days reached in one change, or through a free intermediate change whose first and last days
/// are both drawn at random, give the same days; (e) a removal confirmed gives back exactly the days it
/// hid — each day of it in no other days away over the commitment and due on its eras, worked out from
/// the eras alone — and changes no other day. Every state is also read against the eras and days away
/// alone. A change or intermediate refused for a reason the specification gives keeps nothing and is
/// drawn again, at most 20 times.
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
            // A third of the screens are opened inside some days away, where stops, take-ups and changes
            // are made while days away are under way.
            let existing = current.daysAway
            if !existing.isEmpty, choices.chance(1, in: 3) {
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
            var first = 1 + choices.next(36)
            var last = first + choices.next(9)
            if iteration == 0 {
                first = 5 + choices.next(10)
                last = first + choices.next(5)
            }
            var refusal: CommitmentsScreen.Refusal?

            // Every sequence begins by saying days away over everything kept, then another beginning the
            // day after the first ends, a stop and a take-up; the rest are chosen.
            let pick = iteration == 0 ? 0 : iteration == 1 ? 6 : iteration == 2 ? 18 : iteration == 3 ? 22 : choices.next(46)
            switch pick {
            case 0, 1, 2, 3, 4, 5:
                let over = commitments.kept.filter { _ in iteration == 0 || !choices.chance(1, in: 4) }
                acts.append("say \(first)-\(last) over \(over.map(\.name)) as of \(today)")
                refusal = commitments.sayDaysAway(
                    named: "S\(acts.count)", from: dayN(first), through: dayN(last), over: over)
            case 6, 7, 8:
                // Days away that begin the day after others end.
                let all = listed(commitments)
                guard !all.isEmpty else { continue }
                let neighbour = all[choices.next(all.count)]
                let begin = number(neighbour.lastDay) + 1
                let end = begin + choices.next(5)
                guard begin <= 40 else { continue }
                let over = commitments.kept.filter { kept in
                    iteration == 1 || neighbour.commitments.contains { $0.identity == kept.identity }
                        || choices.chance(1, in: 4)
                }
                acts.append("say \(begin)-\(end) over \(over.map(\.name)) as of \(today)")
                refusal = commitments.sayDaysAway(
                    named: "S\(acts.count)", from: dayN(begin), through: dayN(end), over: over)
            case 9, 10, 11, 12, 13, 37, 38, 39:
                let all = listed(commitments)
                guard !all.isEmpty else { continue }
                let index = choices.next(all.count)
                let target = all[index]
                // Every change and removal picks from all the days away the screen lists, past ones too.
                let pool = commitments.kept + commitments.stopped.filter { target.commitments.contains($0) }
                var from = target.firstDay
                var through = target.lastDay
                var picked = target.commitments
                var name = target.name ?? ""
                switch choices.next(4) {
                case 0:
                    from = dayN(first)
                    through = dayN(last)
                    picked = pool.filter { _ in !choices.chance(1, in: 3) }
                case 1:
                    from = dayN(first)
                    through = dayN(last)
                case 2:
                    picked = pool.filter { _ in !choices.chance(1, in: 3) }
                default:
                    name = "N\(acts.count)"
                }
                acts.append(
                    "change \(target.title) to \(number(from))-\(number(through)) over \(picked.map(\.name)) as of \(today)"
                )
                refusal = commitments.changeDaysAway(
                    target, named: name, from: from, through: through, over: picked)
                if refusal == nil, index > 0 {
                    tally.changesOfOthers += 1
                }
                if refusal == nil, movesWhollyPastAStop(target, to: from, in: current) {
                    tally.changesWhollyPastAStop += 1
                }
            case 32, 33, 34:
                // Untick one commitment from days away.
                let all = listed(commitments)
                guard !all.isEmpty else { continue }
                let target = all[choices.next(all.count)]
                let dropped = choices.next(target.commitments.count)
                let picked = target.commitments.enumerated().filter { $0.offset != dropped }.map(\.element)
                acts.append(
                    "untick \(target.commitments[dropped].name) from \(target.title) as of \(today)")
                let index = all.firstIndex(of: target) ?? 0
                refusal = commitments.changeDaysAway(
                    target, named: target.name ?? "", from: target.firstDay, through: target.lastDay,
                    over: picked)
                if refusal == nil, index > 0 {
                    tally.changesOfOthers += 1
                }
            case 14, 15, 16, 17, 40, 41, 42:
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
            case 18, 19, 20, 21:
                guard !commitments.kept.isEmpty else { continue }
                let target = commitments.kept[choices.next(commitments.kept.count)]
                if !choices.chance(1, in: 10),
                    let moved = daysInside(
                        existing, over: target, clock: &clock, forward: clockMovesForward, choices: &choices)
                {
                    today = moved
                    commitments = screen(roster, asOf: today)
                }
                acts.append("stop \(target.name) as of \(today)")
                commitments.askToStopKeeping(target)
                refusal = commitments.confirmStopKeeping()
            case 22, 23, 24, 25, 26, 27:
                guard !commitments.stopped.isEmpty else { continue }
                let target = commitments.stopped[choices.next(commitments.stopped.count)]
                if !choices.chance(1, in: 10),
                    let moved = daysInside(
                        existing, over: target, clock: &clock, forward: clockMovesForward, choices: &choices)
                {
                    today = moved
                    commitments = screen(roster, asOf: today)
                }
                acts.append("take up \(target.name) as of \(today)")
                let over = existing.filter { span in span.commitments.contains { $0.identity == target.identity } }
                refusal = commitments.keepAgain(target)
                if refusal == nil, over.contains(where: { number($0.firstDay) <= today && today <= number($0.lastDay) }) {
                    tally.takeUpsInside += 1
                }
            case 28, 29, 30, 31, 43, 44, 45:
                guard !commitments.kept.isEmpty else { continue }
                let target = commitments.kept[choices.next(commitments.kept.count)]
                if !choices.chance(1, in: 10),
                    let moved = daysInside(
                        existing, over: target, clock: &clock, forward: clockMovesForward, choices: &choices)
                {
                    today = moved
                    commitments = screen(roster, asOf: today)
                }
                guard let made = commitments.whatItIsMadeOf(target) else { continue }
                var rhythm: Rhythm
                if choices.chance(1, in: 3) {
                    rhythm = .everyNDays(2 + choices.next(4))
                } else {
                    var weekdays = Set(
                        [Weekday.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
                            .filter { _ in choices.chance(1, in: 2) })
                    if weekdays.isEmpty { weekdays = [.monday] }
                    rhythm = .weekdays(weekdays)
                }
                acts.append("change the rhythm of \(target.name) to \(rhythm) as of \(today)")
                let over = existing.filter { span in span.commitments.contains { $0.identity == target.identity } }
                refusal = commitments.change(
                    target, toName: target.name, on: rhythm, keptFrom: made.keptFrom, under: nil)
                if refusal == nil, rhythm != made.rhythm,
                    over.contains(where: { number($0.firstDay) <= today && today <= number($0.lastDay) })
                {
                    tally.rhythmChangesInside += 1
                }
            default:
                let everything = commitments.kept + commitments.stopped
                guard !everything.isEmpty, choices.chance(1, in: 2) else { continue }
                let target = everything[choices.next(everything.count)]
                acts.append("delete \(target.name) as of \(today)")
                commitments.askToDelete(target)
                commitments.nameTypedBack = target.name
                refusal = commitments.confirmDeleting()
                if refusal == nil, !(commitments.kept + commitments.stopped).contains(target) {
                    tally.deletions += 1
                }
            }

            // (a) A roster store reads what was written, and no act was refused as unwritable.
            if refusal == .notKept {
                failures.append("sequence \(sequence): refused as a roster that could not be written, after \(acts)")
                break
            }
            guard let held = rosterRead(roster) else {
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
            let before = dueDays(held)
            let onTheEras = differences(dueDaysOnTheEras(held), before)
            if !onTheEras.isEmpty {
                failures.append("sequence \(sequence): the days read differ from the eras and days away (\(onTheEras)), after \(acts)")
                break
            }

            // (b) Renaming each listed days away, same days and picks, is kept and changes no day.
            do {
                let renamed = try copy(of: roster)
                let atCopy = screen(renamed, asOf: today)
                var ran = false
                for span in listed(atCopy) {
                    let newName = "R" + (span.name ?? "")
                    if let refused = atCopy.changeDaysAway(
                        span, named: newName, from: span.firstDay, through: span.lastDay,
                        over: span.commitments)
                    {
                        failures.append(
                            "sequence \(sequence): renaming \(span.title) was refused (\(refused)), after \(acts)")
                    } else if let now = listed(atCopy).first(where: { $0 == span }),
                        now.name == newName, now.firstDay == span.firstDay,
                        now.lastDay == span.lastDay,
                        Set(now.commitments.map(\.identity)) == Set(span.commitments.map(\.identity))
                    {
                        ran = true
                    } else {
                        failures.append(
                            "sequence \(sequence): renaming \(span.title) did not keep its days and picks, after \(acts)")
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

            // (e) A removal confirmed gives back exactly the days it hid and changes no other day.
            do {
                let removal = try copy(of: roster)
                let atRemoval = screen(removal, asOf: today)
                let spans = listed(atRemoval)
                if !spans.isEmpty {
                    let index = choices.next(spans.count)
                    let gone = spans[index]
                    atRemoval.askToRemove(gone)
                    if let refused = atRemoval.confirmRemovingDaysAway() {
                        failures.append(
                            "sequence \(sequence): removing \(gone.title) was refused (\(refused)), after \(acts)")
                    } else if let nowRoster = rosterRead(removal),
                        nowRoster.spans.count == held.spans.count - 1
                    {
                        tally.removed += 1
                        if index > 0 {
                            tally.removalsOfOthers += 1
                        }
                        let now = dueDays(nowRoster)
                        let onEras = dueDaysOnTheEras(nowRoster)
                        var problems: [String] = []
                        // Each day of it in no other days away over the commitment and due on its eras.
                        for commitment in gone.commitments
                        where nowRoster.entries.contains(where: { $0.commitment.identity == commitment.identity }) {
                            let others = held.spans.filter {
                                $0.identity != gone.identity && $0.commitments.contains(commitment.identity)
                            }
                            for day in number(gone.firstDay)...number(gone.lastDay) {
                                let inOther = others.contains {
                                    number($0.firstDay) <= day && day <= number($0.lastDay)
                                }
                                guard !inOther else { continue }
                                let dueOnItsEras = onEras[commitment.name]?.contains(day) ?? false
                                if dueOnItsEras != (now[commitment.name]?.contains(day) ?? false) {
                                    problems.append(
                                        "\(commitment.name) \(dueOnItsEras ? "not given back" : "owed") on \(day)")
                                }
                            }
                        }
                        // No other day changes: every day read is the day the eras and the days away left
                        // say, and a commitment the days away were not over is as it was.
                        let drift = differences(onEras, now)
                        if !drift.isEmpty { problems.append("the days read differ from the eras (\(drift))") }
                        let overNames = Set(gone.commitments.map(\.name))
                        for name in Set(before.keys).union(now.keys) where !overNames.contains(name) {
                            for day in window
                            where (before[name]?.contains(day) ?? false) != (now[name]?.contains(day) ?? false) {
                                problems.append("\(name) changed on \(day) though the days away were not over it")
                            }
                        }
                        if !problems.isEmpty {
                            failures.append(
                                "sequence \(sequence): removing \(gone.title) \(number(gone.firstDay))-\(number(gone.lastDay)): \(problems.prefix(4).joined(separator: "; ")), after \(acts)"
                            )
                        }
                    }
                }
            }

            // (c) and (d) A change to other days, followed by its move back, and the same days reached
            // in one change and through a free intermediate one.
            let all = listed(commitments)
            guard !all.isEmpty else { continue }
            let target = all[choices.next(all.count)]
            /// Changes `span` on `screen`; a change refused as a roster that could not be written is a
            /// failure, any other refusal is answered for the caller to draw again.
            func change(
                _ screen: CommitmentsScreen, _ span: DaysAway, _ from: Int, _ through: Int
            ) -> CommitmentsScreen.Refusal? {
                let refusal = screen.changeDaysAway(
                    span, named: target.name ?? "", from: dayN(from), through: dayN(through),
                    over: span.commitments)
                if refusal == .notKept {
                    failures.append("sequence \(sequence): a change refused as unwritable, after \(acts)")
                }
                return refusal
            }
            var direct: (first: Int, last: Int, place: URL, screen: CommitmentsScreen)?
            for _ in 0..<20 where direct == nil {
                let first = 1 + choices.next(36)
                let last = first + choices.next(9)
                let place = try copy(of: roster)
                let atPlace = screen(place, asOf: today)
                guard let there = listed(atPlace).first(where: { $0 == target }) else { break }
                if change(atPlace, there, first, last) == nil {
                    if movesWhollyPastAStop(target, to: dayN(first), in: held) {
                        tally.changesWhollyPastAStop += 1
                    }
                    direct = (first, last, place, atPlace)
                }
            }
            guard let direct else { continue }
            let inOne = dueDays(at: direct.place)

            // (d) The same days reached through an intermediate change whose ends are both moved.
            var through: URL?
            for _ in 0..<20 where through == nil {
                let first = 1 + choices.next(36)
                let last = first + choices.next(9)
                guard first != number(target.firstDay), last != number(target.lastDay) else { continue }
                let place = try copy(of: roster)
                let atPlace = screen(place, asOf: today)
                guard let start = listed(atPlace).first(where: { $0 == target }),
                    change(atPlace, start, first, last) == nil,
                    let middle = listed(atPlace).first(where: { $0 == target })
                else { continue }
                if let refusal = change(atPlace, middle, direct.first, direct.last) {
                    failures.append(
                        "sequence \(sequence): \(target.title) moved to \(first)-\(last) could not then be moved to \(direct.first)-\(direct.last) (\(refusal)), after \(acts)"
                    )
                    break
                }
                through = place
            }
            if let through {
                tally.oneOrTwo += 1
                tally.oneOrTwoBothEndsMoved += 1
                if let two = dueDays(at: through), let one = inOne {
                    let changed = differences(one, two)
                    if !changed.isEmpty {
                        failures.append(
                            "sequence \(sequence): \(target.title) \(number(target.firstDay))-\(number(target.lastDay)) to \(direct.first)-\(direct.last) in one change and through another leave different days (\(changed)), after \(acts)"
                        )
                    }
                } else {
                    failures.append("sequence \(sequence): a change left a roster no store reads, after \(acts)")
                }
            }

            // (c) The move back must not be refused, and restores every day.
            if let now = listed(direct.screen).first(where: { $0 == target }) {
                if let refusal = change(direct.screen, now, number(target.firstDay), number(target.lastDay)) {
                    failures.append(
                        "sequence \(sequence): \(target.title) moved to \(direct.first)-\(direct.last) could not be moved back (\(refusal)), after \(acts)"
                    )
                } else {
                    tally.movedBack += 1
                    if let back = dueDays(at: direct.place) {
                        let changed = differences(before, back)
                        if !changed.isEmpty {
                            failures.append(
                                "sequence \(sequence): \(target.title) \(number(target.firstDay))-\(number(target.lastDay)) moved to \(direct.first)-\(direct.last) and back changed days (\(changed)), after \(acts)"
                            )
                        }
                    } else {
                        failures.append("sequence \(sequence): a move back left a roster no store reads, after \(acts)")
                    }
                }
            }
        }
    }

    for failure in failures.prefix(6) {
        Issue.record(Comment(rawValue: failure))
    }
    #expect(failures.isEmpty, "\(failures.count) failing sequences")
    return tally
}

/// Fails unless the run did each thing often enough for its passing to mean something.
private func expectEnough(_ tally: Tally, _ mode: String) {
    print(
        "days away property, \(mode): (b) \(tally.renamed), (c) \(tally.movedBack), (d) \(tally.oneOrTwo) with both ends moved \(tally.oneOrTwoBothEndsMoved), (e) \(tally.removed) ran unskipped; take-ups inside days away \(tally.takeUpsInside); rhythm changes inside days away \(tally.rhythmChangesInside); changes wholly past a stopped pick's stop \(tally.changesWhollyPastAStop); kept changes of others \(tally.changesOfOthers); confirmed removals of others \(tally.removalsOfOthers); deletions \(tally.deletions)"
    )
    #expect(tally.renamed >= 400, "(b) ran unskipped")
    #expect(tally.movedBack >= 400, "(c) ran unskipped")
    #expect(tally.oneOrTwo >= 400, "(d) ran unskipped")
    #expect(tally.oneOrTwoBothEndsMoved >= 400, "(d) ran with both ends of its intermediate moved")
    #expect(tally.removed >= 400, "(e) ran unskipped")
    #expect(tally.takeUpsInside >= 50, "take-ups kept inside days away")
    #expect(tally.rhythmChangesInside >= 50, "rhythm changes kept inside days away")
    #expect(tally.changesWhollyPastAStop >= 50, "changes moving days away wholly past a stopped pick's stop")
    #expect(tally.changesOfOthers >= 150, "kept changes of days away other than the first listed")
    #expect(tally.removalsOfOthers >= 150, "confirmed removals of days away other than the first listed")
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
