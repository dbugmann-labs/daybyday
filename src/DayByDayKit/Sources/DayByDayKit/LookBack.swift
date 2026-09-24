import Foundation

/// One commitment seen on its own, over everything since the day it was kept from —
/// `openspec/changes/look-back-at-a-tick/design.md` § *The seam*. A value: asking twice for the
/// same commitment answers the same look-back, and nothing about it is read again once formed.
public struct LookBack: Hashable, Sendable {
    public let name: String
    public let rhythmInWords: String
    public let keptFromInWords: String
    public let keptUntilInWords: String?
    public let whole: String?
    public let lines: [Line]
    public let graph: Graph?
    /// A note commitment's notes, newest first — empty on every other kind, and on a note that
    /// says no note. `openspec/changes/look-back-at-a-note/design.md` § *The seam*.
    public let notes: [DatedNote]
    /// A note commitment's count of the notes it says, "38 notes" or "1 note" — `nil` on every
    /// other kind, and where `notes` is empty. `design.md` § *The seam*.
    public let noteCountInWords: String?

    public enum Line: Hashable, Sendable {
        case month(inWords: String, fraction: String)
        case week(inWords: String, fraction: String)
    }

    /// One day's note, said as a look-back says a day, and the text the record holds for it
    /// exactly, line breaks included. `design.md` § *The seam*.
    public struct DatedNote: Hashable, Sendable {
        public let dayInWords: String
        public let text: String
    }

    /// A number commitment's numbers over its dates axis — `nil` for every other kind, and for a
    /// number holding none. `design.md` § *The seam*: `day` on a point and a month is a place in
    /// `days`, which says every calendar day of the span in words, so the shell can plot and
    /// scroll on plain integers and label any position without composing a date itself
    /// (ADR-1022).
    public struct Graph: Hashable, Sendable {
        public let days: [String]
        public let months: [Month]
        public let points: [Point]
        public let lowest: Decimal
        public let lowestInWords: String
        public let highest: Decimal
        public let highestInWords: String
        /// A total commitment's target across its whole dates axis, one `Stretch` per run of
        /// consecutive days owed one target — empty on a number's graph. `design.md` § *The
        /// rule is stretches, not a target per day*.
        public let targetRule: [Stretch]

        public struct Month: Hashable, Sendable {
            public let inWords: String
            public let day: Int
        }

        public struct Point: Hashable, Sendable {
            public let day: Int
            public let value: Decimal
            public let inWords: String
            /// Whether a total's point reached its day's target — `nil` on a number's point,
            /// which the graph judges nothing about. `design.md` § *`isKept` is optional*.
            public let isKept: Bool?
        }

        public struct Stretch: Hashable, Sendable {
            public let from: Int
            public let through: Int
            public let target: Decimal
            public let inWords: String
        }
    }

    /// One era of a look-back's **chain**: a commitment, and the last day it holds — the day it
    /// was kept until for every era behind the one this look-back was asked about, and for that
    /// one itself where it is stopped; `nil` where it is not, so it holds every day from its own
    /// day kept from on, days after today included — `openspec/changes/
    /// stop-and-resume-as-eras/design.md` § *A week a weekly quota era holds owes its quota in
    /// proportion to the days held*. `openspec/changes/give-a-commitment-an-identity/design.md`
    /// § *A look-back reads a commitment's eras off the roster by its identity*. The same shape
    /// `WeekQuota.Link` already is — this is that type under the name a look-back's own chain
    /// reads by, rather than a second struct alike it.
    private typealias Era = WeekQuota.Link

    /// A key naming a calendar month, so a walk can tell whether the day just visited has left
    /// the calendar month it was in.
    private struct YearMonth: Hashable {
        let year: Int
        let month: Int
    }

    /// A month this look-back has walked: the calendar month, and the days it counted kept out
    /// of the days it counted due across every day of it held by an era not running on a weekly
    /// quota. `hasNonQuotaDay` is false, and no line is said, where every day of the month the
    /// chain covers is held by an era running on a weekly quota — those days are said by a
    /// `WeekTally`'s line instead. `lastDay` is the last day of the month actually counted this
    /// way, used to order this line among the others.
    private struct MonthTally {
        let yearMonth: YearMonth
        var due: Int = 0
        var kept: Int = 0
        var hasNonQuotaDay: Bool = false
        var lastDay: CalendarDate

        var line: Line? {
            guard hasNonQuotaDay else { return nil }
            return .month(
                inWords: LookBackWords.month(year: yearMonth.year, month: yearMonth.month),
                fraction: LookBackWords.fraction(kept: kept, due: due))
        }
    }

    /// A calendar week — Monday through the following Sunday — this look-back has walked: whether
    /// any day of it is said in the unit of a weekly-quota era, whether that era genuinely holds
    /// the day or a gap after one does, `design.md` § *One week rule, in one place*. `hasQuotaDay`
    /// false says no line at all; true, the fraction itself is read off `WeekQuota.standing(_:)`
    /// against the chain, once the whole week has been walked, rather than accumulated here one
    /// day at a time — a week two quota eras share is judged against both, not the last one
    /// walked. `lastDay` is the last day of the week actually counted this way.
    private struct WeekTally {
        let monday: CalendarDate
        var hasQuotaDay: Bool = false
        var lastDay: CalendarDate

        /// The days this week counts kept, and what it owes — reading `eras` and `history` fresh
        /// rather than a running total, once the whole week has been walked, so a week two quota
        /// eras share is judged against both. `nil` where `hasQuotaDay` is false. `keptThrough` is
        /// this look-back's own walk end, `through`, so a week in progress or a week the walk's
        /// own stop cuts counts a tick no later than the walk itself ever reads — the same day
        /// the fraction it counts against is judged through. `WeekQuota.standing(monday:links:
        /// history:keptThrough:)` itself answers `nil` for a week holding no day any era of
        /// `eras` genuinely holds — a week a gap alone carries every day of, said in the unit of
        /// the era before it — which this reads as owing nothing, "0/0".
        func standing(eras: [Era], history: History, keptThrough: CalendarDate) -> (
            kept: Int, owed: Int
        )? {
            guard hasQuotaDay else { return nil }
            return WeekQuota.standing(
                monday: monday, links: eras, history: history, keptThrough: keptThrough) ?? (0, 0)
        }

        func line(_ standing: (kept: Int, owed: Int)) -> Line {
            .week(
                inWords: LookBackWords.week(from: monday, through: LookBack.sunday(of: monday)),
                fraction: LookBackWords.fraction(kept: standing.kept, due: standing.owed))
        }
    }

    /// Forms the look-back at `commitment`, on either of a commitments screen's lists —
    /// `keptUntil` is the day the roster stopped keeping it, `nil` where the roster is still
    /// keeping it. `entries` is the roster's own entries, in its own order, so the chain behind
    /// `commitment` can be read off every entry carrying its identity — `design.md` § *A
    /// look-back reads a commitment's eras off the roster by its identity*. `today` is the day
    /// the screen was handed, and `history` is the record this screen reads.
    static func form(
        for commitment: Commitment, keptUntil: CalendarDate?, entries: [Roster.Entry],
        today: CalendarDate, history: History
    ) -> LookBack {
        let frontEnd = keptUntil ?? today
        let eras = chain(from: commitment, keptUntil: keptUntil, entries: entries)
        let earliestEra = eras.last!

        switch commitment.kind {
        case .number, .total:
            let graph = Self.graph(from: earliestEra.start, through: frontEnd, eras: eras, history: history)
            return LookBack(
                name: commitment.name, rhythmInWords: commitment.rhythmInWords,
                keptFromInWords: LookBackWords.day(earliestEra.start),
                keptUntilInWords: keptUntil.map(LookBackWords.day), whole: nil, lines: [],
                graph: graph, notes: [], noteCountInWords: nil)
        case .note:
            let notes = Self.notes(from: earliestEra.start, through: frontEnd, eras: eras, history: history)
            return LookBack(
                name: commitment.name, rhythmInWords: commitment.rhythmInWords,
                keptFromInWords: LookBackWords.day(earliestEra.start),
                keptUntilInWords: keptUntil.map(LookBackWords.day), whole: nil, lines: [],
                graph: nil, notes: notes,
                noteCountInWords: notes.isEmpty ? nil : LookBackWords.notes(notes.count))
        case .tick:
            break
        }

        let (lines, totalDue, totalKept) = Self.walkDays(
            from: earliestEra.start, through: frontEnd, eras: eras, history: history)

        return LookBack(
            name: commitment.name, rhythmInWords: commitment.rhythmInWords,
            keptFromInWords: LookBackWords.day(earliestEra.start),
            keptUntilInWords: keptUntil.map(LookBackWords.day),
            whole: LookBackWords.fraction(kept: totalKept, due: totalDue),
            lines: lines, graph: nil, notes: [], noteCountInWords: nil)
    }

    /// The chain of eras behind `commitment`, newest first: `commitment` itself, ending on
    /// `keptUntil` — `nil` where the roster is still keeping it, so it holds every day from its
    /// own day kept from on — then every entry `entries` holds carrying the same identity, each
    /// ending on the day it was kept until, the day between one such day and the era in front of
    /// it a gap neither holds — the order `entries` already holds a commitment's eras in,
    /// `Roster.eras(of:)`'s own. Reaches no era of any other commitment, however alike it is in
    /// name, kind, rhythm or day: what chains is the identity alone. `design.md` § *A look-back
    /// reads a commitment's eras off the roster by its identity* and
    /// `openspec/changes/stop-and-resume-as-eras/design.md` § *One mend carries the gap and the
    /// stop's collapse*.
    private static func chain(
        from commitment: Commitment, keptUntil: CalendarDate?, entries: [Roster.Entry]
    ) -> [Era] {
        let matching = entries.filter { $0.commitment.identity == commitment.identity }

        guard !matching.isEmpty else {
            return [Era(commitment, end: keptUntil)]
        }

        return matching.enumerated().map { offset, entry in
            offset == 0
                ? Era(commitment, end: keptUntil)
                : Era(entry.commitment, end: entry.keptUntil)
        }
    }

    /// The Sunday six days after `monday`, walked forward one day at a time so every step stays
    /// at the ±1 `adding(days:)` documents as safe — the same discipline `WeekQuota.monday(of:)`
    /// walks backward with, rather than the single six-day step that discipline forbids.
    private static func sunday(of monday: CalendarDate) -> CalendarDate {
        var current = monday
        for _ in 0..<6 {
            current = current.adding(days: 1)!
        }
        return current
    }

    /// Whether `a` falls on or before `b` — the ordering `days(until:)` answers signed, spelled
    /// out here for sorting this look-back's lines by their own last counted day, newest first.
    private static func isOnOrBefore(_ a: CalendarDate, _ b: CalendarDate) -> Bool {
        a.days(until: b) >= 0
    }

    /// The era of `eras` that holds `day` — the one whose day kept from is on or before `day` and
    /// whose end, where it has one, is on or after it — or `nil` where none does: a day before the
    /// earliest era's own day kept from, or a day of a gap between two eras. Shared by `walkDays`
    /// and `graph`, so a day is read against the same era's commitment wherever it is walked.
    /// `design.md` § *A second walk, not a wider `walkDays`*.
    private static func era(holding day: CalendarDate, in eras: [Era]) -> Era? {
        eras.first { $0.start.days(until: day) >= 0 && ($0.end.map { day.days(until: $0) >= 0 } ?? true) }
    }

    /// Whether the schedule `schedule` runs on a weekly quota — the one thing that decides which
    /// unit a day, held or a gap, is said in.
    private static func isWeeklyQuota(_ schedule: Schedule) -> Bool {
        if case .weeklyQuota = schedule { return true }
        return false
    }

    /// Walks every day from `start` through `end` inclusive, one calendar day at a time —
    /// `design.md` § *Risks / Trade-offs*: opened deliberately, once, on a phone, not on the
    /// daily path. Buckets each day into the calendar month or the calendar week it falls in,
    /// according to whether the era holding it — or, for a day of a gap, the era immediately
    /// before it — runs on a weekly quota, `openspec/changes/stop-and-resume-as-eras/design.md`
    /// § *A look-back counts nothing in a gap, and says its lines unbroken through it* — a month
    /// or a week that holds only such days still says a line, "nothing out of nothing", rather
    /// than being left out. Returns every line this look-back says, newest first, together with
    /// the whole's numerator and denominator — the sum of every line's own, month due days and
    /// week owed days alike, `openspec/changes/look-back-at-a-quota/specs/look-back/spec.md` § *A
    /// look-back says one whole across everything since the day the commitment is kept from*.
    private static func walkDays(
        from start: CalendarDate, through end: CalendarDate, eras: [Era], history: History
    ) -> (lines: [Line], totalDue: Int, totalKept: Int) {
        guard start.days(until: end) >= 0 else {
            return ([], 0, 0)
        }

        var months: [MonthTally] = []
        var weeks: [WeekTally] = []
        var currentMonth = MonthTally(
            yearMonth: YearMonth(year: start.year, month: start.month), lastDay: start)
        var currentWeekMonday = WeekQuota.monday(of: start)
        var currentWeek = WeekTally(monday: currentWeekMonday, lastDay: start)
        var day = start
        // The unit of the era holding the most recent day walked — updated only on a day some era
        // genuinely holds, never on a gap day, so every gap day is said in the unit of the era
        // before it. `start` is always the earliest era's own day kept from, so this is set truly
        // before any gap can be reached.
        var lastEraWasQuota = false

        while true {
            if day.year != currentMonth.yearMonth.year || day.month != currentMonth.yearMonth.month {
                months.append(currentMonth)
                currentMonth = MonthTally(
                    yearMonth: YearMonth(year: day.year, month: day.month), lastDay: day)
            }

            let dayMonday = WeekQuota.monday(of: day)
            if dayMonday != currentWeekMonday {
                weeks.append(currentWeek)
                currentWeekMonday = dayMonday
                currentWeek = WeekTally(monday: dayMonday, lastDay: day)
            }

            if let era = Self.era(holding: day, in: eras) {
                let isQuota = Self.isWeeklyQuota(era.commitment.schedule)
                lastEraWasQuota = isQuota
                if isQuota {
                    currentWeek.hasQuotaDay = true
                    currentWeek.lastDay = day
                } else {
                    currentMonth.hasNonQuotaDay = true
                    currentMonth.lastDay = day
                    if era.commitment.isDue(on: day) {
                        currentMonth.due += 1
                        if history.isKept(era.commitment, on: day) {
                            currentMonth.kept += 1
                        }
                    }
                }
            } else if lastEraWasQuota {
                currentWeek.hasQuotaDay = true
                currentWeek.lastDay = day
            } else {
                currentMonth.hasNonQuotaDay = true
                currentMonth.lastDay = day
            }

            guard day != end, let next = day.adding(days: 1) else {
                break
            }
            day = next
        }

        months.append(currentMonth)
        weeks.append(currentWeek)

        // Only the months and weeks that actually say something — held by an era or a gap after
        // one — say a line — `spec.md` § *A tick commitment's look-back counts each calendar
        // month's kept days out of its due days* and § *A weekly quota era's look-back counts
        // each week's kept days out of what the week owes*.
        struct SortableLine {
            let line: Line
            let lastDay: CalendarDate
            let due: Int
            let kept: Int
        }
        let monthEntries: [SortableLine] = months.compactMap { tally in
            guard let line = tally.line else { return nil }
            return SortableLine(line: line, lastDay: tally.lastDay, due: tally.due, kept: tally.kept)
        }
        let weekEntries: [SortableLine] = weeks.compactMap { tally in
            guard let standing = tally.standing(eras: eras, history: history, keptThrough: end)
            else { return nil }
            return SortableLine(
                line: tally.line(standing), lastDay: tally.lastDay, due: standing.owed,
                kept: standing.kept)
        }

        var sortableLines = monthEntries
        sortableLines.append(contentsOf: weekEntries)
        sortableLines.sort { !Self.isOnOrBefore($0.lastDay, $1.lastDay) }

        let lines = sortableLines.map(\.line)

        let totalDue = sortableLines.reduce(0) { $0 + $1.due }
        let totalKept = sortableLines.reduce(0) { $0 + $1.kept }

        return (lines, totalDue, totalKept)
    }

    /// A note commitment's notes, oldest first as walked then reversed — `design.md` § *A walk of
    /// the span, reading the era holding each day*: shares `era(holding:in:)` with `walkDays` and
    /// `graph` rather than widening either, and reads a day's note only where an era holds it, so
    /// no note after the day kept until is said. Empty where `start` is after `end`.
    private static func notes(
        from start: CalendarDate, through end: CalendarDate, eras: [Era], history: History
    ) -> [LookBack.DatedNote] {
        guard start.days(until: end) >= 0 else {
            return []
        }

        var notes: [LookBack.DatedNote] = []
        var day = start

        while true {
            if let era = Self.era(holding: day, in: eras),
                let text = history.note(for: era.commitment, on: day)
            {
                notes.append(LookBack.DatedNote(dayInWords: LookBackWords.day(day), text: text))
            }

            guard day != end, let next = day.adding(days: 1) else {
                break
            }
            day = next
        }

        return notes.reversed()
    }

    /// A number or a total commitment's graph: a walk of `start` through `end` inclusive of its
    /// own, sharing `era(holding:in:)` with `walkDays` rather than widening it — `design.md` § *A
    /// second walk, not a wider `walkDays`* and § *The graph walk grows; `walkDays` is not
    /// reached*. `nil` where no day it counts holds a number or an addition.
    private static func graph(
        from start: CalendarDate, through end: CalendarDate, eras: [Era], history: History
    ) -> LookBack.Graph? {
        guard start.days(until: end) >= 0 else {
            return nil
        }

        let isTotal: Bool
        if case .total = eras.first!.commitment.kind {
            isTotal = true
        } else {
            isTotal = false
        }

        var days: [String] = []
        var months: [LookBack.Graph.Month] = []
        var points: [LookBack.Graph.Point] = []
        var stretches: [LookBack.Graph.Stretch] = []
        var currentStretchFrom: Int?
        var currentStretchTarget: Decimal?
        var currentYearMonth: YearMonth?
        var day = start
        var index = 0

        while true {
            days.append(LookBackWords.day(day))

            let yearMonth = YearMonth(year: day.year, month: day.month)
            if yearMonth != currentYearMonth {
                months.append(
                    LookBack.Graph.Month(
                        inWords: LookBackWords.month(year: day.year, month: day.month), day: index))
                currentYearMonth = yearMonth
            }

            if let era = Self.era(holding: day, in: eras) {
                if isTotal, case .total(let target) = era.commitment.kind {
                    let sum = history.total(for: era.commitment, on: day)
                    if sum > 0 {
                        points.append(
                            LookBack.Graph.Point(
                                day: index, value: sum,
                                inWords: LookBackWords.sum(sum, of: target.amount),
                                isKept: history.isKept(era.commitment, on: day)))
                    }

                    // One stretch per run of consecutive days owed the same target —
                    // `design.md` § *The rule is stretches, not a target per day*. A day with
                    // no addition is still owed a target, so this reads every day, not only
                    // those that made a point.
                    if currentStretchTarget != target.amount {
                        if let from = currentStretchFrom, let previousTarget = currentStretchTarget
                        {
                            stretches.append(
                                LookBack.Graph.Stretch(
                                    from: from, through: index - 1, target: previousTarget,
                                    inWords: LookBackWords.number(previousTarget)))
                        }
                        currentStretchFrom = index
                        currentStretchTarget = target.amount
                    }
                } else if !isTotal, let value = history.number(for: era.commitment, on: day) {
                    points.append(
                        LookBack.Graph.Point(
                            day: index, value: value, inWords: LookBackWords.number(value),
                            isKept: nil))
                }
            }

            guard day != end, let next = day.adding(days: 1) else {
                break
            }
            day = next
            index += 1
        }

        if let from = currentStretchFrom, let target = currentStretchTarget {
            stretches.append(
                LookBack.Graph.Stretch(
                    from: from, through: index, target: target,
                    inWords: LookBackWords.number(target)))
        }

        guard !points.isEmpty else {
            return nil
        }

        // The newest era's own range where it declares one, the points themselves where it
        // declares none, each widened to hold a value the range does not — `design.md` § *The
        // values axis says its two bounds and nothing between*.
        var lowest: Decimal
        var highest: Decimal
        if isTotal {
            lowest = 0
            highest = 0
        } else if case .number(let range) = eras.first!.commitment.kind, let range {
            lowest = range.lowest
            highest = range.highest
        } else {
            lowest = points[0].value
            highest = points[0].value
        }
        for point in points {
            if point.value < lowest { lowest = point.value }
            if point.value > highest { highest = point.value }
        }
        if isTotal {
            // The values axis stays in view of the target rule too, not only the sums —
            // `spec.md` § *A total commitment's graph runs its values from zero to its greatest
            // sum or target*.
            for stretch in stretches {
                if stretch.target > highest { highest = stretch.target }
            }
        }

        return LookBack.Graph(
            days: days, months: months, points: points,
            lowest: lowest, lowestInWords: LookBackWords.number(lowest),
            highest: highest, highestInWords: LookBackWords.number(highest),
            targetRule: stretches)
    }
}
