import Foundation

public struct History: Hashable, Sendable {
    private var ticks: Set<Tick>
    private var numbers: [RecordedDay: Decimal]
    private var notes: [RecordedDay: String]
    private var additions: [RecordedDay: [Decimal]]

    public init() {
        ticks = []
        numbers = [:]
        notes = [:]
        additions = [:]
    }

    public mutating func add(_ tick: Tick) {
        ticks.insert(tick)
    }

    public mutating func remove(_ tick: Tick) {
        ticks.remove(tick)
    }

    public mutating func add(_ number: Number) {
        numbers[RecordedDay(commitment: number.commitment, date: number.date)] = number.number
    }

    public mutating func removeNumber(for commitment: Commitment, on date: CalendarDate) {
        numbers[RecordedDay(commitment: commitment, date: date)] = nil
    }

    /// Re-forms a tick from `commitment` and `date` rather than testing `ticks` for one built
    /// directly, because `Tick` exposes neither part to build one from. That re-forming asks
    /// `Schedule.isDue(on:)` again, but not as a second, independent check: a tick can only be
    /// a member of `ticks` if its own formation already passed that same guard, and an equal
    /// `commitment` answers `isDue(on:)` the same way every time, so the answer here still
    /// comes from what `ticks` holds.
    ///
    /// A commitment is kept by a tick, by a number or by a note, whichever its kind can produce:
    /// a tick keeps its day by being there, and every number and every note does too, whatever
    /// either holds. A total is kept when the day's sum has reached its commitment's target —
    /// the comparison is the sum against the target, in that order, never the reverse.
    public func isKept(_ commitment: Commitment, on date: CalendarDate) -> Bool {
        if let tick = Tick(commitment, on: date), ticks.contains(tick) {
            return true
        }

        if case .total(let target) = commitment.kind {
            return total(for: commitment, on: date) >= target.amount
        }

        let day = RecordedDay(commitment: commitment, date: date)
        return numbers[day] != nil || notes[day] != nil
    }

    public func number(for commitment: Commitment, on date: CalendarDate) -> Decimal? {
        numbers[RecordedDay(commitment: commitment, date: date)]
    }

    public mutating func add(_ note: Note) {
        notes[RecordedDay(commitment: note.commitment, date: note.date)] = note.text
    }

    public mutating func removeNote(for commitment: Commitment, on date: CalendarDate) {
        notes[RecordedDay(commitment: commitment, date: date)] = nil
    }

    public func note(for commitment: Commitment, on date: CalendarDate) -> String? {
        notes[RecordedDay(commitment: commitment, date: date)]
    }

    /// What that day has added: the sum of the additions it holds, and zero where it holds
    /// none — for every commitment, on every date, whatever its kind.
    public func total(for commitment: Commitment, on date: CalendarDate) -> Decimal {
        let day = RecordedDay(commitment: commitment, date: date)
        return (additions[day] ?? []).reduce(0, +)
    }

    /// Appends to the day `addition` is for. A day holds many, in the order they were made, and
    /// a second addition alike in every way to the first is held beside it.
    public mutating func add(_ addition: Addition) {
        let day = RecordedDay(commitment: addition.commitment, date: addition.date)
        additions[day, default: []].append(addition.amount)
    }

    /// Removes the last addition of that day, leaving the history unchanged where it holds none.
    public mutating func removeLastAddition(for commitment: Commitment, on date: CalendarDate) {
        let day = RecordedDay(commitment: commitment, date: date)
        guard var amounts = additions[day], !amounts.isEmpty else {
            return
        }

        amounts.removeLast()
        additions[day] = amounts.isEmpty ? nil : amounts
    }

    /// Carries every record held of `commitment` over to `changed`, on the same date each was
    /// made for. See `openspec/specs/record/spec.md` § *A history carries every record of one
    /// commitment over to another*.
    public mutating func carryOver(_ commitment: Commitment, to changed: Commitment) -> Bool {
        guard commitment != changed else {
            return true
        }

        let matchingTicks = ticks.filter { $0.commitment == commitment }
        let matchingNumbers = numbers.filter { $0.key.commitment == commitment }
        let matchingNotes = notes.filter { $0.key.commitment == commitment }
        let matchingAdditions = additions.filter { $0.key.commitment == commitment }

        guard
            !(matchingTicks.isEmpty && matchingNumbers.isEmpty && matchingNotes.isEmpty
                && matchingAdditions.isEmpty)
        else {
            return true
        }

        let holdsAny =
            ticks.contains { $0.commitment == changed }
            || numbers.keys.contains { $0.commitment == changed }
            || notes.keys.contains { $0.commitment == changed }
            || additions.keys.contains { $0.commitment == changed }
        guard !holdsAny else {
            return false
        }

        var newTicks: Set<Tick> = []
        for tick in matchingTicks {
            guard let newTick = Tick(changed, on: tick.date) else {
                return false
            }
            newTicks.insert(newTick)
        }

        var newNumbers: [RecordedDay: Decimal] = [:]
        for (day, value) in matchingNumbers {
            guard let newNumber = Number(value, for: changed, on: day.date) else {
                return false
            }
            newNumbers[RecordedDay(commitment: changed, date: day.date)] = newNumber.number
        }

        var newNotes: [RecordedDay: String] = [:]
        for (day, text) in matchingNotes {
            guard let newNote = Note(text, for: changed, on: day.date) else {
                return false
            }
            newNotes[RecordedDay(commitment: changed, date: day.date)] = newNote.text
        }

        var newAdditions: [RecordedDay: [Decimal]] = [:]
        for (day, amounts) in matchingAdditions {
            var carriedAmounts: [Decimal] = []
            for amount in amounts {
                guard let newAddition = Addition(amount, for: changed, on: day.date) else {
                    return false
                }
                carriedAmounts.append(newAddition.amount)
            }
            newAdditions[RecordedDay(commitment: changed, date: day.date)] = carriedAmounts
        }

        for tick in matchingTicks {
            ticks.remove(tick)
        }
        ticks.formUnion(newTicks)

        for day in matchingNumbers.keys {
            numbers[day] = nil
        }
        for (day, value) in newNumbers {
            numbers[day] = value
        }

        for day in matchingNotes.keys {
            notes[day] = nil
        }
        for (day, value) in newNotes {
            notes[day] = value
        }

        for day in matchingAdditions.keys {
            additions[day] = nil
        }
        for (day, value) in newAdditions {
            additions[day] = value
        }

        return true
    }
}
