public struct OneOffs: Hashable, Sendable {
    /// A one-off this holds, and the day it was done — `nil` for a one-off that is not done.
    /// `design.md` § *Done is held against the one-off, never on it*.
    struct Entry: Hashable, Sendable {
        let oneOff: OneOff
        let doneOn: CalendarDate?
    }

    var entries: [Entry]

    /// The done one-offs this holds, in the order they were ticked — oldest tick first, so the
    /// most recently ticked is the last element. `design.md` § *The tick order is a list in the
    /// value, not a number on a tick*: a tick or an add already done appends here, a take-back or
    /// a removal drops, a rename replaces in place. Never a time of day. This is a stored
    /// property, so two `OneOffs` differing only in this order are unequal — `design.md`'s
    /// rejected "a counter stamped on each tick" would instead compare equal after a removal
    /// left a hole one holder lacked and the other did not.
    var doneOrder: [OneOff]

    public init() {
        entries = []
        doneOrder = []
    }

    public mutating func add(_ oneOff: OneOff) -> Bool {
        guard !entries.contains(where: { $0.oneOff == oneOff }) else {
            return false
        }

        entries.append(Entry(oneOff: oneOff, doneOn: nil))
        return true
    }

    public mutating func add(_ oneOff: OneOff, doneOn day: CalendarDate) -> Bool {
        guard !entries.contains(where: { $0.oneOff == oneOff }) else {
            return false
        }

        guard oneOff.date.days(until: day) >= 0 else {
            return false
        }

        entries.append(Entry(oneOff: oneOff, doneOn: day))
        doneOrder.append(oneOff)
        return true
    }

    public mutating func tick(_ oneOff: OneOff, on day: CalendarDate) -> Bool {
        guard let index = entries.firstIndex(where: { $0.oneOff == oneOff }) else {
            return false
        }

        guard entries[index].doneOn == nil else {
            return false
        }

        guard oneOff.date.days(until: day) >= 0 else {
            return false
        }

        entries[index] = Entry(oneOff: oneOff, doneOn: day)
        doneOrder.append(oneOff)
        return true
    }

    public mutating func takeBack(_ oneOff: OneOff) -> Bool {
        guard let index = entries.firstIndex(where: { $0.oneOff == oneOff }) else {
            return false
        }

        guard entries[index].doneOn != nil else {
            return false
        }

        entries[index] = Entry(oneOff: oneOff, doneOn: nil)
        doneOrder.removeAll { $0 == oneOff }
        return true
    }

    /// Renames `oneOff`, done or not, to `name` in place — one write, so a refused rename holds
    /// nothing changed and a kept one keeps the entry's place among one-offs owed on the same
    /// date. Refused, changing nothing, when this does not hold `oneOff`, when `name` says
    /// nothing, or when a one-off named `name` on `oneOff`'s date is already held, `oneOff`
    /// itself included. `design.md` § *A rename is one act in `one-off`, and keeps the one-off's
    /// place*.
    public mutating func rename(_ oneOff: OneOff, to name: String) -> Bool {
        guard let index = entries.firstIndex(where: { $0.oneOff == oneOff }) else {
            return false
        }
        guard let renamed = OneOff(name: name, date: oneOff.date) else {
            return false
        }
        guard !entries.contains(where: { $0.oneOff == renamed }) else {
            return false
        }

        if let doneIndex = doneOrder.firstIndex(of: oneOff) {
            doneOrder[doneIndex] = renamed
        }
        entries[index] = Entry(oneOff: renamed, doneOn: entries[index].doneOn)
        return true
    }

    public mutating func remove(_ oneOff: OneOff) -> Bool {
        guard let index = entries.firstIndex(where: { $0.oneOff == oneOff }) else {
            return false
        }

        entries.remove(at: index)
        doneOrder.removeAll { $0 == oneOff }
        return true
    }

    /// The day `oneOff` stands on as of `today` — the later of its date and `today` while it is
    /// not done, the day it was done once it is, and `nil` where this does not hold it.
    /// `design.md` § *The standing day is the later of the date and today, or the day it was
    /// ticked*.
    public func standingDay(for oneOff: OneOff, asOf today: CalendarDate) -> CalendarDate? {
        guard let entry = entries.first(where: { $0.oneOff == oneOff }) else {
            return nil
        }

        if let doneOn = entry.doneOn {
            return doneOn
        }

        return oneOff.date.days(until: today) > 0 ? today : oneOff.date
    }

    /// The one-offs this holds that stand on `day` as of `today`: every one not done first,
    /// ordered by each one-off's own date, earliest first — a stable sort, so two owed on the
    /// same date keep the order they were added in — then every one done, the most recently
    /// ticked first. `design.md` § *The order is `one-off`'s answer, and a day view only asks
    /// for it* and § *The tick order is a list in the value, not a number on a tick*.
    public func standing(on day: CalendarDate, asOf today: CalendarDate) -> [OneOff] {
        let onDay = entries
            .map(\.oneOff)
            .filter { standingDay(for: $0, asOf: today) == day }

        let owed = onDay
            .filter { !isDone($0) }
            .sorted { $0.date.days(until: $1.date) > 0 }

        let doneOnDay = Set(onDay.filter { isDone($0) })
        let done = doneOrder.reversed().filter { doneOnDay.contains($0) }

        return owed + done
    }

    /// Whether this holds `oneOff` and it is done. `design.md` § *The seam*.
    func isDone(_ oneOff: OneOff) -> Bool {
        entries.first(where: { $0.oneOff == oneOff })?.doneOn != nil
    }
}
