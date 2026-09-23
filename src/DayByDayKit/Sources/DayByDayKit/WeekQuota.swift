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
    /// end and the next link's day kept from belongs to neither, and is held by nothing.
    struct Link {
        let commitment: Commitment
        let end: CalendarDate?

        init(_ commitment: Commitment, end: CalendarDate?) {
            self.commitment = commitment
            self.end = end
        }
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
    /// `kept` counts the same seven days against `history`. `nil` where no day of the week is held
    /// by a weekly-quota link at all — the caller's own reading of a gap or a different rhythm's
    /// unit decides whether the week is said regardless, `design.md` § *One week rule, in one
    /// place*.
    static func standing(monday: CalendarDate, links: [Link], history: History) -> (kept: Int, owed: Int)? {
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
                if history.isKept(link.commitment, on: day) {
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
}
