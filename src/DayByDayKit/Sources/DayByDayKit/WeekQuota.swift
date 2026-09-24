import Foundation

/// A week's standing against every weekly-quota era of a commitment's chain holding a day of it —
/// read off the chain rather than one era alone, so a week two quota eras share is judged against
/// both, and a week a gap cuts owes only the days its eras actually hold. See `openspec/specs/
/// look-back/spec.md` § *A week a weekly quota era holds owes its quota in proportion to the days
/// held*. `LookBack.walkDays` and a day view's weekly-quota row both read a week this way, so the
/// number either says agrees — `openspec/changes/stop-and-resume-as-eras/design.md` § *One week
/// rule, in one place*.
enum WeekQuota {
    /// One era of a chain: a commitment, and the last day it holds — `nil` where it holds every
    /// day from its own day kept from on, days after today included, the chain's front era where
    /// the commitment is not stopped. No `Link` holds a day of a gap: a day between one link's own
    /// end and the next link's day kept from belongs to neither, and is held by nothing. Shared
    /// with `LookBack`'s own chain, `LookBack.Era`, rather than each holding its own alike shape.
    struct Link {
        let commitment: Commitment
        let end: CalendarDate?

        init(_ commitment: Commitment, end: CalendarDate?) {
            self.commitment = commitment
            self.end = end
        }

        /// This link's own day it is kept from — its commitment's, read here so a caller walking
        /// a chain of links reads a link's start off the same shape it reads `commitment` and
        /// `end` from.
        var start: CalendarDate { commitment.keptFrom }
    }

    /// The `Link` of `links` holding `day` — the one whose commitment's day kept from is on or
    /// before `day` and whose `end`, where it has one, is on or after it — or `nil` where none
    /// does.
    private static func link(holding day: CalendarDate, in links: [Link]) -> Link? {
        links.first {
            $0.commitment.keptFrom.days(until: day) >= 0
                && ($0.end.map { day.days(until: $0) >= 0 } ?? true)
        }
    }

    /// The days of the Monday-to-Sunday week starting `monday` kept against a weekly-quota link
    /// holding a day of it, and what that week owes: for each of the week's seven days, the link
    /// holding it — where one does, and it runs on a weekly quota — contributes its quota over
    /// seven; every part is summed and rounded once to the nearest whole number, and no exact tie
    /// ever arises at a denominator of seven, so which way a tie rounds never has to be chosen.
    /// `owed` reads every day so held, days after `keptThrough` included — *A week a weekly quota
    /// era holds owes its quota in proportion to the days held* says nothing about when a day
    /// falls, days to come included. `kept` counts the same seven days against `history`, but
    /// only through `keptThrough`: a look-back passes its own walk's end, so a week in progress,
    /// or a week a stop cuts short, never counts a tick past the day the walk itself has reached;
    /// a day view's row passes its own date, so it counts nothing past the day it draws.
    /// `design.md` § *One week rule, in one place*. `nil` where no day of the week is held by a
    /// weekly-quota link at all — the caller's own reading of a gap or a different rhythm's unit
    /// decides whether the week is said regardless.
    static func standing(
        monday: CalendarDate, links: [Link], history: History, keptThrough end: CalendarDate
    ) -> (kept: Int, owed: Int)? {
        var kept = 0
        var owedNumerator = 0
        var hasQuotaDay = false
        var day = monday

        for _ in 0..<7 {
            if let link = Self.link(holding: day, in: links),
                case .weeklyQuota(let quota) = link.commitment.schedule
            {
                hasQuotaDay = true
                owedNumerator += quota.timesPerWeek
                let dayCounts = day.days(until: end) >= 0
                if dayCounts, history.isKept(link.commitment, on: day) {
                    kept += 1
                }
            }
            guard let next = day.adding(days: 1) else {
                break
            }
            day = next
        }

        guard hasQuotaDay else {
            return nil
        }
        let owed = Int((Double(owedNumerator) / 7).rounded())
        return (kept, owed)
    }

    /// The Monday of `date`'s calendar week, walked back one day at a time so every step stays
    /// at the ±1 `adding(days:)` documents as safe. Shared by every caller of `standing(monday:
    /// links:history:)`, so a week is found the same way wherever it is read.
    static func monday(of date: CalendarDate) -> CalendarDate {
        var current = date
        while current.weekday != .monday, let previous = current.adding(days: -1) {
            current = previous
        }
        return current
    }

    /// `commitment`'s whole chain, read off `roster`'s own entries by identity, newest first —
    /// the same chain a look-back reads, `design.md` § *A look-back reads a commitment's eras off
    /// the roster by its identity*. A single link holding `commitment` as its only era, with no
    /// end, where `roster` is `nil` or does not hold that identity at all — a day view formed
    /// from bare commitments reads each as its only era, `design.md` § *One week rule, in one
    /// place*.
    static func chain(of commitment: Commitment, in roster: Roster?) -> [Link] {
        guard let roster else {
            return [Link(commitment, end: nil)]
        }

        let matching = roster.entries.filter { $0.commitment.identity == commitment.identity }
        guard !matching.isEmpty else {
            return [Link(commitment, end: nil)]
        }

        return matching.map { Link($0.commitment, end: $0.keptUntil) }
    }
}
