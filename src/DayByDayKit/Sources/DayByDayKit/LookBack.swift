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

    public enum Line: Hashable, Sendable {
        case month(inWords: String, fraction: String)
        case week(inWords: String, fraction: String)
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

    /// One era of a look-back's **chain**: a commitment, and the last day it counts through —
    /// `today` or the day this screen was handed for the newest era, the day it was kept until
    /// for every era behind it, each carrying the same identity as the one in front of it.
    /// `openspec/changes/give-a-commitment-an-identity/design.md` § *A look-back reads a
    /// commitment's eras off the roster by its identity*.
    private struct Era {
        let commitment: Commitment
        let end: CalendarDate

        var start: CalendarDate { commitment.keptFrom }
    }

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

    /// A calendar week — Monday through the following Sunday — this look-back has walked: the
    /// days it counted kept, out of the quota of the newest weekly-quota era holding a day of it
    /// — the last one processed wins, and days are walked oldest first, so a week two quota eras
    /// share ends up judged by the newer, `design.md` § *A week two quota eras share is judged
    /// by the newer*. `hasQuotaDay` is false, and no line is said, where no day of this week is
    /// held by an era running on a weekly quota. `lastDay` is the last day of the week actually
    /// counted this way.
    private struct WeekTally {
        let monday: CalendarDate
        var kept: Int = 0
        var quota: Int = 0
        var hasQuotaDay: Bool = false
        var lastDay: CalendarDate

        var line: Line? {
            guard hasQuotaDay else { return nil }
            return .week(
                inWords: LookBackWords.week(from: monday, through: LookBack.sunday(of: monday)),
                fraction: LookBackWords.fraction(kept: kept, due: quota))
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
        let eras = chain(from: commitment, end: frontEnd, entries: entries)
        let earliestEra = eras.last!

        if case .number = commitment.kind {
            let graph = Self.graph(from: earliestEra.start, through: frontEnd, eras: eras, history: history)
            return LookBack(
                name: commitment.name, rhythmInWords: commitment.rhythmInWords,
                keptFromInWords: LookBackWords.day(earliestEra.start),
                keptUntilInWords: keptUntil.map(LookBackWords.day), whole: nil, lines: [],
                graph: graph)
        }

        if case .total = commitment.kind {
            let graph = Self.graph(from: earliestEra.start, through: frontEnd, eras: eras, history: history)
            return LookBack(
                name: commitment.name, rhythmInWords: commitment.rhythmInWords,
                keptFromInWords: LookBackWords.day(earliestEra.start),
                keptUntilInWords: keptUntil.map(LookBackWords.day), whole: nil, lines: [],
                graph: graph)
        }

        guard case .tick = commitment.kind else {
            return LookBack(
                name: commitment.name, rhythmInWords: commitment.rhythmInWords,
                keptFromInWords: LookBackWords.day(earliestEra.start),
                keptUntilInWords: keptUntil.map(LookBackWords.day), whole: nil, lines: [],
                graph: nil)
        }

        let (lines, totalDue, totalKept) = Self.walkDays(
            from: earliestEra.start, through: frontEnd, eras: eras, history: history)

        return LookBack(
            name: commitment.name, rhythmInWords: commitment.rhythmInWords,
            keptFromInWords: LookBackWords.day(earliestEra.start),
            keptUntilInWords: keptUntil.map(LookBackWords.day),
            whole: LookBackWords.fraction(kept: totalKept, due: totalDue),
            lines: lines, graph: nil)
    }

    /// The chain of eras behind `commitment`, newest first: `commitment` itself, ending on `end`,
    /// then every entry `entries` holds carrying the same identity, each ending on the day it was
    /// kept until — the order `entries` already holds a commitment's eras in, `Roster.eras(of:)`'s
    /// own. Reaches no era of any other commitment, however alike it is in name, kind, rhythm or
    /// day: what chains is the identity alone. `design.md` § *A look-back reads a commitment's
    /// eras off the roster by its identity*.
    private static func chain(from commitment: Commitment, end: CalendarDate, entries: [Roster.Entry])
        -> [Era]
    {
        let matching = entries.filter { $0.commitment.identity == commitment.identity }

        guard !matching.isEmpty else {
            return [Era(commitment: commitment, end: end)]
        }

        return matching.enumerated().map { offset, entry in
            offset == 0
                ? Era(commitment: commitment, end: end)
                : Era(commitment: entry.commitment, end: entry.keptUntil!)
        }
    }

    /// The Monday of `date`'s calendar week, walked back one day at a time so every step stays
    /// at the ±1 `adding(days:)` documents as safe — the same technique
    /// `History.standing(for:through:)` uses to find a week's start.
    private static func monday(of date: CalendarDate) -> CalendarDate {
        var current = date
        while current.weekday != .monday, let previous = current.adding(days: -1) {
            current = previous
        }
        return current
    }

    /// The Sunday six days after `monday`, walked forward one day at a time so every step stays
    /// at the ±1 `adding(days:)` documents as safe — the same discipline `monday(of:)` above
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

    /// The era of `eras` that holds `day` — the one whose span runs from its own day kept from
    /// through its own end inclusive — or `nil` where none does. Shared by `walkDays` and
    /// `graph`, so a day is read against the same era's commitment wherever it is walked.
    /// `design.md` § *A second walk, not a wider `walkDays`*.
    private static func era(holding day: CalendarDate, in eras: [Era]) -> Era? {
        eras.first { $0.start.days(until: day) >= 0 && day.days(until: $0.end) >= 0 }
    }

    /// Walks every day from `start` through `end` inclusive, one calendar day at a time —
    /// `design.md` § *Risks / Trade-offs*: opened deliberately, once, on a phone, not on the
    /// daily path. Buckets each day into the calendar month or the calendar week it falls in,
    /// according to whether the era holding it runs on a weekly quota, and returns every line
    /// this look-back says, newest first, together with the whole's numerator and denominator —
    /// the sum of every line's own, month due days and week quotas alike,
    /// `openspec/changes/look-back-at-a-quota/specs/look-back/spec.md` § *A look-back says one
    /// whole across everything since the day the commitment is kept from*.
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
        var currentWeekMonday = Self.monday(of: start)
        var currentWeek = WeekTally(monday: currentWeekMonday, lastDay: start)
        var day = start

        while true {
            if day.year != currentMonth.yearMonth.year || day.month != currentMonth.yearMonth.month {
                months.append(currentMonth)
                currentMonth = MonthTally(
                    yearMonth: YearMonth(year: day.year, month: day.month), lastDay: day)
            }

            let dayMonday = Self.monday(of: day)
            if dayMonday != currentWeekMonday {
                weeks.append(currentWeek)
                currentWeekMonday = dayMonday
                currentWeek = WeekTally(monday: dayMonday, lastDay: day)
            }

            if let era = Self.era(holding: day, in: eras) {
                if case .weeklyQuota(let quota) = era.commitment.schedule {
                    currentWeek.hasQuotaDay = true
                    currentWeek.quota = quota.timesPerWeek
                    currentWeek.lastDay = day
                    if history.isKept(era.commitment, on: day) {
                        currentWeek.kept += 1
                    }
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
            }

            guard day != end, let next = day.adding(days: 1) else {
                break
            }
            day = next
        }

        months.append(currentMonth)
        weeks.append(currentWeek)

        // Only the months and weeks that actually hold a day of the right kind say a line —
        // `spec.md` § *A tick commitment's look-back counts each calendar month's kept days out
        // of its due days* and § *A weekly quota era's look-back counts each week's kept days
        // out of its quota*.
        struct SortableLine {
            let line: Line
            let lastDay: CalendarDate
        }
        let monthEntries: [SortableLine] = months.compactMap { tally in
            guard let line = tally.line else { return nil }
            return SortableLine(line: line, lastDay: tally.lastDay)
        }
        let weekEntries: [SortableLine] = weeks.compactMap { tally in
            guard let line = tally.line else { return nil }
            return SortableLine(line: line, lastDay: tally.lastDay)
        }

        var sortableLines = monthEntries
        sortableLines.append(contentsOf: weekEntries)
        sortableLines.sort { !Self.isOnOrBefore($0.lastDay, $1.lastDay) }

        let lines = sortableLines.map(\.line)

        let totalDue = months.reduce(0) { $0 + $1.due } + weeks.reduce(0) { $0 + $1.quota }
        let totalKept = months.reduce(0) { $0 + $1.kept } + weeks.reduce(0) { $0 + $1.kept }

        return (lines, totalDue, totalKept)
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
            // `design.md` § *The rule is stretches, not a target per day* / `spec.md` § *A total
            // commitment's graph runs its values from zero to its greatest sum or target*.
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
