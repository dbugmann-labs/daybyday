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

    /// How many days of `date`'s Monday-to-Sunday week `commitment` was kept, through `date`
    /// inclusive and no later day. See `openspec/specs/record/spec.md` § *A history answers a
    /// commitment's standing in the week of a calendar date* and this change's `design.md` for
    /// why the week is worked out here rather than on `CalendarDate` or `Weekday`.
    public func standing(for commitment: Commitment, through date: CalendarDate) -> Int {
        Self.daysOfWeek(through: date).count { isKept(commitment, on: $0) }
    }

    /// The days from `date` back to the Monday of its week, inclusive — walked one day at a
    /// time so that every step stays at the ±1 `adding(days:)` documents as safe, stopping
    /// where a week is truncated by the supported calendar rather than stepping past it.
    private static func daysOfWeek(through date: CalendarDate) -> [CalendarDate] {
        var days = [date]
        var current = date

        while current.weekday != .monday, let previous = current.adding(days: -1) {
            days.append(previous)
            current = previous
        }

        return days
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

    /// Whether this history holds any record of `commitment` — a tick, a number, a note or an
    /// addition. Package-internal: a screen that would carry records onto `commitment` needs
    /// this before it does, to tell that cause apart from a day left not due. `design.md` §
    /// *The seam*.
    func holdsRecords(of commitment: Commitment) -> Bool {
        ticks.contains { $0.commitment == commitment }
            || numbers.keys.contains { $0.commitment == commitment }
            || notes.keys.contains { $0.commitment == commitment }
            || additions.keys.contains { $0.commitment == commitment }
    }

    /// The dates this history holds any record of `commitment` on — a tick, a number, a note or
    /// an addition, each contributing the dates it is held for. Package-internal, the same seam
    /// as `holdsRecords(of:)`.
    func datesRecorded(for commitment: Commitment) -> Set<CalendarDate> {
        var dates: Set<CalendarDate> = []
        dates.formUnion(ticks.filter { $0.commitment == commitment }.map(\.date))
        dates.formUnion(numbers.keys.filter { $0.commitment == commitment }.map(\.date))
        dates.formUnion(notes.keys.filter { $0.commitment == commitment }.map(\.date))
        dates.formUnion(additions.keys.filter { $0.commitment == commitment }.map(\.date))
        return dates
    }

    /// Gives every record `fold` names an identity that identity, and drops every record it maps
    /// to `nil`. A record whose commitment — name, schedule, day kept from and kind alone,
    /// `CommitmentRecord.bare(_:)` — is not a key `fold` holds at all is left exactly as it was:
    /// neither the fold nor this reads that as belonging to any commitment the roster once held,
    /// so it is a record of a commitment the roster holds in no state, `SaveInProgress`'s orphan
    /// carry-back to settle from there. Answers whether anything moved. Package-internal:
    /// `RecordStore.settle(_:)` is the one caller. `design.md` § *The seam* and § *Migration*.
    mutating func settle(_ fold: [CommitmentRecord: Commitment.Identity?]) -> Bool {
        guard !fold.isEmpty else {
            return false
        }

        var moved = false

        /// Where `commitment`'s bare shape is a key in `fold`, answers the commitment settled onto
        /// the identity it names — or `nil` where the fold dropped it, which this tells apart from
        /// "leave it as it is" by way of the outer optional. `nil` outer means "not a key at all."
        func settled(_ commitment: Commitment) -> Commitment?? {
            guard let mapped = fold[CommitmentRecord.bare(commitment)] else {
                return nil
            }
            guard let identity = mapped else {
                return .some(nil)
            }
            return .some(
                Commitment(
                    identity: identity, name: commitment.name, schedule: commitment.schedule,
                    keptFrom: commitment.keptFrom, kind: commitment.kind))
        }

        var newTicks: Set<Tick> = []
        for tick in ticks {
            guard let outcome = settled(tick.commitment) else {
                newTicks.insert(tick)
                continue
            }
            moved = true
            if let settledCommitment = outcome, let newTick = Tick(settledCommitment, on: tick.date) {
                newTicks.insert(newTick)
            }
        }
        ticks = newTicks

        var newNumbers: [RecordedDay: Decimal] = [:]
        for (day, value) in numbers {
            guard let outcome = settled(day.commitment) else {
                newNumbers[day] = value
                continue
            }
            moved = true
            if let settledCommitment = outcome {
                newNumbers[RecordedDay(commitment: settledCommitment, date: day.date)] = value
            }
        }
        numbers = newNumbers

        var newNotes: [RecordedDay: String] = [:]
        for (day, text) in notes {
            guard let outcome = settled(day.commitment) else {
                newNotes[day] = text
                continue
            }
            moved = true
            if let settledCommitment = outcome {
                newNotes[RecordedDay(commitment: settledCommitment, date: day.date)] = text
            }
        }
        notes = newNotes

        var newAdditions: [RecordedDay: [Decimal]] = [:]
        for (day, amounts) in additions {
            guard let outcome = settled(day.commitment) else {
                newAdditions[day] = amounts
                continue
            }
            moved = true
            if let settledCommitment = outcome {
                newAdditions[RecordedDay(commitment: settledCommitment, date: day.date)] = amounts
            }
        }
        additions = newAdditions

        return moved
    }

    /// Erases every tick, number, note and addition whose commitment's identity is one of
    /// `identities`, from every date it was made on. Answers whether anything was erased.
    /// Package-internal: `RecordStore.erase(_:)` is the one caller. `design.md` § *The seam* and
    /// § *Deletion writes the record place first and puts it back* — the one act both a single
    /// commitment's deletion and the upgrade's migration erasure share.
    mutating func erase(_ identities: Set<Commitment.Identity>) -> Bool {
        guard !identities.isEmpty else {
            return false
        }

        var erased = false

        let newTicks = ticks.filter { !identities.contains($0.commitment.identity) }
        if newTicks.count != ticks.count { erased = true }
        ticks = newTicks

        let newNumbers = numbers.filter { !identities.contains($0.key.commitment.identity) }
        if newNumbers.count != numbers.count { erased = true }
        numbers = newNumbers

        let newNotes = notes.filter { !identities.contains($0.key.commitment.identity) }
        if newNotes.count != notes.count { erased = true }
        notes = newNotes

        let newAdditions = additions.filter { !identities.contains($0.key.commitment.identity) }
        if newAdditions.count != additions.count { erased = true }
        additions = newAdditions

        return erased
    }

    /// Carries every record held of `commitment` over to `changed`, on the same date each was
    /// made for. See `openspec/specs/record/spec.md` § *A history carries every record of one
    /// commitment over to another*.
    public mutating func carryOver(_ commitment: Commitment, to changed: Commitment) -> Bool {
        carryOver(commitment, to: changed, matching: { _ in true })
    }

    /// Carries the records held of `commitment` made on or after `day` over to `changed`, on the
    /// same date each was made for; every record made before `day` stays under `commitment`.
    /// Package-internal: a restart needs this before it carries part of a history over, to tell
    /// this cause apart from carrying it whole. `openspec/changes/add-interval-restart/design.md`
    /// § *Carrying part of a history is package-internal*.
    mutating func carryOver(_ commitment: Commitment, to changed: Commitment, onOrAfter day: CalendarDate)
        -> Bool
    {
        carryOver(commitment, to: changed, matching: { day.days(until: $0) >= 0 })
    }

    /// The act both `carryOver` overloads perform, differing only in which dated records
    /// `matches` lets through: every one, for the whole-history overload, or only those on or
    /// after a day, for the restart's dated one. Refuses wherever `changed` holds any record at
    /// all — the wider of the two refusals `move(_:to:matching:)` is shared behind, `design.md`
    /// § *Carrying back refuses only on a shared day*.
    private mutating func carryOver(
        _ commitment: Commitment, to changed: Commitment, matching matches: (CalendarDate) -> Bool
    ) -> Bool {
        guard commitment != changed else {
            return true
        }
        guard hasRecords(of: commitment, matching: matches) else {
            return true
        }
        guard !holdsRecords(of: changed) else {
            return false
        }
        return move(commitment, to: changed, matching: matches)
    }

    /// Carries every record held of `orphan` back to `source`, on the same date each was made
    /// for. Refuses only where a record would not form under `source` or would land on a day
    /// `source` already holds a record on — narrower than `carryOver`, which refuses wherever
    /// `source` holds any record at all, `design.md` § *Carrying back refuses only on a shared
    /// day*. Package-internal: `SaveInProgress` is the only caller, to undo a torn save and to
    /// carry an orphaned record back to its one possible source.
    mutating func carryBack(_ orphan: Commitment, to source: Commitment) -> Bool {
        guard orphan != source else {
            return true
        }
        guard hasRecords(of: orphan, matching: { _ in true }) else {
            return true
        }
        guard datesRecorded(for: source).isDisjoint(with: datesRecorded(for: orphan)) else {
            return false
        }
        return move(orphan, to: source, matching: { _ in true })
    }

    /// Whether this history holds any record of `commitment` on a date `matches` lets through —
    /// the emptiness check `carryOver` and `carryBack` both start from, before either asks what
    /// its own refusal is.
    private func hasRecords(of commitment: Commitment, matching matches: (CalendarDate) -> Bool)
        -> Bool
    {
        ticks.contains { $0.commitment == commitment && matches($0.date) }
            || numbers.keys.contains { $0.commitment == commitment && matches($0.date) }
            || notes.keys.contains { $0.commitment == commitment && matches($0.date) }
            || additions.keys.contains { $0.commitment == commitment && matches($0.date) }
    }

    /// Moves every record held of `commitment` matching `matches` over to `changed`, on the same
    /// date each was made for. The caller must already have confirmed the move is allowed —
    /// `hasRecords(of:matching:)` found something to move and whichever refusal applies did not
    /// fire — so this only performs it, answering `false` without moving anything where a record
    /// cannot re-form under `changed`.
    private mutating func move(
        _ commitment: Commitment, to changed: Commitment, matching matches: (CalendarDate) -> Bool
    ) -> Bool {
        let matchingTicks = ticks.filter { $0.commitment == commitment && matches($0.date) }
        let matchingNumbers = numbers.filter { $0.key.commitment == commitment && matches($0.key.date) }
        let matchingNotes = notes.filter { $0.key.commitment == commitment && matches($0.key.date) }
        let matchingAdditions = additions.filter { $0.key.commitment == commitment && matches($0.key.date) }

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

    /// Every tick, number, note and addition this history holds, as the four collections
    /// `RecordDocument.init(ticks:numbers:notes:additions:)` takes — the one way back out of the
    /// private storage this type otherwise keeps to itself (see that initializer's own doc
    /// comment). Package-internal: `CopyDocument` is the one caller outside `RecordStore`, to
    /// write a copy's record in the form the record store writes now, from a `History` value
    /// alone rather than the store that read it. `openspec/changes/make-a-copy/design.md` §
    /// *A copy is the values, not the files*.
    func recordDocumentParts() -> (
        ticks: Set<Tick>, numbers: [RecordedDay: Decimal], notes: [RecordedDay: String],
        additions: [RecordedDay: [Decimal]]
    ) {
        (ticks, numbers, notes, additions)
    }

    /// Every commitment this history holds any record of — a tick, a number, a note or an
    /// addition — each once. Package-internal: `SaveInProgress.carryBackOrphanedRecords(in:
    /// against:)` needs this to find which commitments a roster no longer holds in any state
    /// still have records at the record place.
    func commitmentsWithRecords() -> Set<Commitment> {
        var commitments: Set<Commitment> = []
        commitments.formUnion(ticks.map(\.commitment))
        commitments.formUnion(numbers.keys.map(\.commitment))
        commitments.formUnion(notes.keys.map(\.commitment))
        commitments.formUnion(additions.keys.map(\.commitment))
        return commitments
    }
}
