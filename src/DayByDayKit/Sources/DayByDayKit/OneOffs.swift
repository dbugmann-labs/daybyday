public struct OneOffs: Hashable, Sendable {
    /// A one-off this holds, and the day it was done — `nil` for a one-off that is not done.
    /// `design.md` § *Done is held against the one-off, never on it*.
    struct Entry: Hashable, Sendable {
        let oneOff: OneOff
        let doneOn: CalendarDate?
    }

    var entries: [Entry]

    public init() {
        entries = []
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
        return true
    }

    public mutating func remove(_ oneOff: OneOff) -> Bool {
        guard let index = entries.firstIndex(where: { $0.oneOff == oneOff }) else {
            return false
        }

        entries.remove(at: index)
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
}
