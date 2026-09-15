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

    public enum Line: Hashable, Sendable {
        case month(inWords: String, fraction: String?)
        case rhythmChanged(inWords: String, from: String)
    }

    /// One era of a look-back's **chain**: a commitment, and the last day it counts through —
    /// `today` or the day this screen was handed for the newest era, the day before the era in
    /// front of it is kept from for every era behind it. `design.md` § *Two removed commitments
    /// that both answer: the nearest one wins*.
    private struct Era {
        let commitment: Commitment
        let end: CalendarDate

        var start: CalendarDate { commitment.keptFrom }
    }

    /// A month this look-back has walked: the calendar month, whether any era running on a
    /// weekly quota counted a day inside it, and the days it counted kept out of the days it
    /// counted due — ignored where `touchedByQuota` is `true`, `design.md` § *A month any quota
    /// era touches says no fraction*.
    private struct MonthTally {
        let year: Int
        let month: Int
        var due: Int = 0
        var kept: Int = 0
        var touchedByQuota: Bool = false

        var line: Line {
            .month(
                inWords: LookBackWords.month(year: year, month: month),
                fraction: touchedByQuota ? nil : LookBackWords.fraction(kept: kept, due: due))
        }
    }

    /// A key naming a calendar month, so a **rhythm changed** line can be looked up by the
    /// calendar month it sits above.
    private struct YearMonth: Hashable {
        let year: Int
        let month: Int
    }

    /// Forms the look-back at `commitment`, on either of a commitments screen's lists —
    /// `keptUntil` is the day the roster stopped keeping it, `nil` where the roster is still
    /// keeping it. `entries` is the roster's own entries, in its own order, so the chain behind
    /// `commitment` can be read by resemblance — `design.md` § *A look-back reads a commitment's
    /// earlier eras off the roster by resemblance*. `today` is the day the screen was handed, and
    /// `history` is the record this screen reads.
    static func form(
        for commitment: Commitment, keptUntil: CalendarDate?, entries: [Roster.Entry],
        today: CalendarDate, history: History
    ) -> LookBack {
        let frontEnd = keptUntil ?? today
        let eras = chain(from: commitment, end: frontEnd, entries: entries)
        let earliestEra = eras.last!

        guard case .tick = commitment.kind else {
            return LookBack(
                name: commitment.name, rhythmInWords: commitment.rhythmInWords,
                keptFromInWords: LookBackWords.day(earliestEra.start),
                keptUntilInWords: keptUntil.map(LookBackWords.day), whole: nil, lines: [])
        }

        let hasQuotaEra = eras.contains {
            if case .weeklyQuota = $0.commitment.schedule { return true }
            return false
        }

        let (monthTallies, totalDue, totalKept) = Self.walkDays(
            from: earliestEra.start, through: frontEnd, eras: eras, history: history)

        // Keyed on the calendar month a boundary's newer era is kept from, so two boundaries
        // landing in the same month say two lines rather than the second overwriting the first
        // — `design.md` § *The change line sits above the month the newer era is kept from* and
        // `spec.md` § *A look-back says where the rhythm changed, between its months*: "one such
        // line for each boundary ... in the same newest-first order its months are in". The loop
        // below already visits `eras` newest-first, so appending rather than assigning keeps that
        // order inside one month's list too.
        var changedLinesFor: [YearMonth: [Line]] = [:]
        for index in 0..<max(eras.count - 1, 0) {
            let newer = eras[index]
            let ym = YearMonth(year: newer.start.year, month: newer.start.month)
            changedLinesFor[ym, default: []].append(
                .rhythmChanged(
                    inWords: newer.commitment.rhythmInWords, from: LookBackWords.day(newer.start)))
        }

        var lines: [Line] = []
        for tally in monthTallies {
            if let changedLines = changedLinesFor[YearMonth(year: tally.year, month: tally.month)] {
                lines.append(contentsOf: changedLines)
            }
            lines.append(tally.line)
        }

        return LookBack(
            name: commitment.name, rhythmInWords: commitment.rhythmInWords,
            keptFromInWords: LookBackWords.day(earliestEra.start),
            keptUntilInWords: keptUntil.map(LookBackWords.day),
            whole: hasQuotaEra ? nil : LookBackWords.fraction(kept: totalKept, due: totalDue),
            lines: lines)
    }

    /// The chain of eras behind `commitment`, newest first: `commitment` itself, ending on `end`,
    /// then every removed commitment the roster holds by resemblance behind it — same name, same
    /// kind, kept until the day before the era in front of it is kept from — walking `entries` in
    /// its own order, outward from the era in front, so that where more than one answers the
    /// nearest one wins. `design.md` § *A look-back reads a commitment's earlier eras off the
    /// roster by resemblance* and § *Two removed commitments that both answer: the nearest one
    /// wins*.
    private static func chain(from commitment: Commitment, end: CalendarDate, entries: [Roster.Entry])
        -> [Era]
    {
        var eras: [Era] = [Era(commitment: commitment, end: end)]

        guard let frontIndex = entries.firstIndex(where: { $0.commitment == commitment }) else {
            return eras
        }

        var searchFrom = frontIndex + 1
        var current = eras[0]

        while searchFrom < entries.count {
            // Where the day before `current.start` cannot be formed at all — the earliest day
            // this calendar can hold — there is no honest day to search for: falling back to
            // `current.start` itself would search for an era kept until the same day the front
            // era is kept from, which `spec.md` § *A removed commitment kept until any day but
            // the day before is not an earlier era* rules out as one day too late. The chain
            // ends here instead.
            guard let targetKeptUntil = current.start.adding(days: -1) else {
                break
            }
            // A slice's `firstIndex(where:)` answers an index into the base array `entries`
            // already — an `ArraySlice` keeps the indices it was sliced from rather than
            // rebasing them to zero — so this is the found entry's own index, not an offset
            // still needing `searchFrom` added back in.
            guard
                let foundIndex = entries[searchFrom...].firstIndex(where: { entry in
                    entry.isRemoved && entry.keptUntil == targetKeptUntil
                        && entry.commitment.name == current.commitment.name
                        && entry.commitment.kind == current.commitment.kind
                })
            else {
                break
            }

            let foundEntry = entries[foundIndex]
            let era = Era(commitment: foundEntry.commitment, end: foundEntry.keptUntil!)
            eras.append(era)
            current = era
            searchFrom = foundIndex + 1
        }

        return eras
    }

    /// Walks every day from `start` through `end` inclusive, one calendar day at a time —
    /// `design.md` § *Risks / Trade-offs*: opened deliberately, once, on a phone, not on the
    /// daily path. Answers the months walked, oldest first, and the total days kept and due
    /// across every day walked whose era does not run on a weekly quota.
    private static func walkDays(
        from start: CalendarDate, through end: CalendarDate, eras: [Era], history: History
    ) -> (months: [MonthTally], totalDue: Int, totalKept: Int) {
        guard start.days(until: end) >= 0 else {
            return ([], 0, 0)
        }

        var months: [MonthTally] = []
        var current = MonthTally(year: start.year, month: start.month)
        var totalDue = 0
        var totalKept = 0
        var day = start

        while true {
            if day.year != current.year || day.month != current.month {
                months.append(current)
                current = MonthTally(year: day.year, month: day.month)
            }

            if let era = eras.first(where: { $0.start.days(until: day) >= 0 && day.days(until: $0.end) >= 0 })
            {
                if case .weeklyQuota = era.commitment.schedule {
                    current.touchedByQuota = true
                } else if era.commitment.isDue(on: day) {
                    current.due += 1
                    totalDue += 1
                    if history.isKept(era.commitment, on: day) {
                        current.kept += 1
                        totalKept += 1
                    }
                }
            }

            guard day != end, let next = day.adding(days: 1) else {
                break
            }
            day = next
        }

        months.append(current)
        return (months.reversed(), totalDue, totalKept)
    }
}
