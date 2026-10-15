/// The days away laid over one commitment's whole life: the first and last day of each days away
/// that is over it. A commitment's eras, stops and take-ups are never cut for days away; a reader
/// asks this mask which days they hide. `openspec/changes/change-days-away/design.md` § *The
/// model: days away are a mask*, ADR-1069.
struct DaysAwayMask: Hashable, Sendable {
    /// One days away over the commitment: its first and last day.
    struct Stretch: Hashable, Sendable {
        let first: CalendarDate
        let last: CalendarDate
    }

    var stretches: [Stretch] = []

    /// No days away over the commitment.
    static let none = DaysAwayMask()

    /// Whether any days away over the commitment cover `day`.
    func covers(_ day: CalendarDate) -> Bool {
        stretches.contains { $0.first.days(until: day) >= 0 && day.days(until: $0.last) >= 0 }
    }

    /// The latest day after days away over the commitment that falls on or before `day` and that
    /// `holds` — the day an every-N-days count is begun again from — or `nil` where there is none.
    func countedFrom(on day: CalendarDate, holds: (CalendarDate) -> Bool) -> CalendarDate? {
        var latest: CalendarDate?
        for stretch in stretches {
            guard let after = stretch.last.adding(days: 1), after.days(until: day) >= 0,
                holds(after)
            else {
                continue
            }
            if latest.map({ $0.days(until: after) > 0 }) ?? true {
                latest = after
            }
        }
        return latest
    }
}

extension Commitment {
    /// This era as days away leave it when an every-N-days count is begun again on `day`: the same
    /// commitment, kept from and counting from `day`. Any other rhythm is not counted, and is
    /// returned as it is.
    func countedAgain(from day: CalendarDate) -> Commitment {
        guard case .everyNDays(let interval, from: _) = schedule else {
            return self
        }
        return Commitment(
            era: self, schedule: .everyNDays(interval, from: day), keptFrom: day, kind: kind)!
    }
}

extension Roster {
    /// One days away as the roster holds it: an identity of its own, a name or none, a first and a
    /// last day, and the identities of the commitments it is over; nothing else. ADR-1069.
    struct Span: Hashable, Sendable {
        let identity: DaysAway.Identity
        let name: String?
        let firstDay: CalendarDate
        let lastDay: CalendarDate
        let commitments: [Commitment.Identity]
    }

    /// The days away this roster holds, in the order of their first days, days away sharing a
    /// first day in the order they were said.
    public var daysAway: [DaysAway] {
        spans.enumerated().sorted { lhs, rhs in
            let apart = lhs.element.firstDay.days(until: rhs.element.firstDay)
            return apart != 0 ? apart > 0 : lhs.offset < rhs.offset
        }.map { daysAway(of: $0.element) }
    }

    /// `span` as a `DaysAway`, its commitments read at their newest era in the order this roster
    /// holds them.
    func daysAway(of span: Span) -> DaysAway {
        var seen: Set<Commitment.Identity> = []
        var commitments: [Commitment] = []
        for entry in entries where span.commitments.contains(entry.commitment.identity) {
            if seen.insert(entry.commitment.identity).inserted {
                commitments.append(entry.commitment)
            }
        }
        return DaysAway(
            identity: span.identity, name: span.name, firstDay: span.firstDay,
            lastDay: span.lastDay, commitments: commitments)
    }

    // MARK: The read

    /// The days away over the commitment `identity` names, laid over its life.
    func mask(over identity: Commitment.Identity) -> DaysAwayMask {
        DaysAwayMask(
            stretches: spans.filter { $0.commitments.contains(identity) }
                .map { DaysAwayMask.Stretch(first: $0.firstDay, last: $0.lastDay) })
    }

    /// Whether days away over the commitment `identity` names hide `day`, reading no record: every
    /// day they cover is hidden.
    func hides(_ identity: Commitment.Identity, on day: CalendarDate) -> Bool {
        mask(over: identity).covers(day)
    }

    /// The commitment `entry` holds as of `day`, read as days away over it leave it: `nil` where
    /// they hide `day` — covered, and `history` holds nothing of the commitment on it — and, where
    /// the era counts every N days, with its count begun again on the latest day after days away
    /// over it that the era holds, on or before `day`. The one read every reader of what a
    /// commitment owes, holds or leaves free goes through. `design.md` § *The model: days away are
    /// a mask*.
    func read(_ entry: Entry, on day: CalendarDate, recordedIn history: History?) -> Commitment? {
        let mask = mask(over: entry.commitment.identity)
        guard !mask.stretches.isEmpty else {
            return entry.commitment
        }
        if mask.covers(day), !(history?.holdsRecord(of: entry.commitment, on: day) ?? false) {
            return nil
        }
        guard let counted = mask.countedFrom(on: day, holds: entry.holds) else {
            return entry.commitment
        }
        return entry.commitment.countedAgain(from: counted)
    }

    // MARK: Saying, changing, removing

    /// Says days away over `commitments`, held beside the others. Touches no era. The caller has
    /// judged every refusal.
    mutating func sayDaysAway(
        named name: String?, from first: CalendarDate, through last: CalendarDate,
        over commitments: [Commitment]
    ) {
        spans.append(
            Span(
                identity: .minted(), name: name, firstDay: first, lastDay: last,
                commitments: commitments.map(\.identity)))
    }

    /// Replaces the days away `identity` names in the place it holds in the order said, with the
    /// same identity. Touches no era. The caller has judged every refusal.
    mutating func changeDaysAway(
        _ identity: DaysAway.Identity, named name: String?, from first: CalendarDate,
        through last: CalendarDate, over commitments: [Commitment]
    ) {
        guard let index = spans.firstIndex(where: { $0.identity == identity }) else {
            return
        }
        spans[index] = Span(
            identity: identity, name: name, firstDay: first, lastDay: last,
            commitments: commitments.map(\.identity))
    }

    /// Removes the days away `identity` names. Touches no era: the days they hid are owed again
    /// because nothing hides them.
    mutating func removeDaysAway(_ identity: DaysAway.Identity) {
        spans.removeAll { $0.identity == identity }
    }

    /// The commitments among `commitments` that stay over the days away `identity` names once they
    /// begin on `first`: every one kept, and a stopped one unless `first` is later than the day
    /// after the day it was last kept.
    func commitmentsStayingOver(
        _ commitments: [Commitment], changing identity: DaysAway.Identity, from first: CalendarDate
    ) -> [Commitment] {
        commitments.filter { commitment in
            guard let lastKept = lastDayKept(of: commitment) else {
                return true
            }
            return first.days(until: lastKept) >= -1
        }
    }

    /// `commitments` in the order this roster holds them, those it does not hold last.
    func inRosterOrder(_ commitments: [Commitment]) -> [Commitment] {
        var held: [Commitment.Identity] = []
        for entry in entries where !held.contains(entry.commitment.identity) {
            held.append(entry.commitment.identity)
        }
        return commitments.enumerated().sorted { lhs, rhs in
            let l = held.firstIndex(of: lhs.element.identity) ?? held.count
            let r = held.firstIndex(of: rhs.element.identity) ?? held.count
            return l != r ? l < r : lhs.offset < rhs.offset
        }.map(\.element)
    }

    /// The last day `commitment` was kept, or `nil` where it is kept still or this roster does not
    /// hold it.
    private func lastDayKept(of commitment: Commitment) -> CalendarDate? {
        entries.first { $0.commitment.identity == commitment.identity }?.keptUntil
    }

    /// Takes `commitment` out of every days away it is over whose first day is after `today` — every
    /// one where `today` is `nil` — and drops the days away that are left over no commitment.
    /// Touches no era: a stop or a deletion has already formed those.
    mutating func leaveDaysAway(of commitment: Commitment, notBegunBy today: CalendarDate?) {
        spans = spans.compactMap { span in
            guard span.commitments.contains(commitment.identity),
                today.map({ $0.days(until: span.firstDay) > 0 }) ?? true
            else {
                return span
            }
            let left = span.commitments.filter { $0 != commitment.identity }
            guard !left.isEmpty else {
                return nil
            }
            return Span(
                identity: span.identity, name: span.name, firstDay: span.firstDay,
                lastDay: span.lastDay, commitments: left)
        }
    }
}
