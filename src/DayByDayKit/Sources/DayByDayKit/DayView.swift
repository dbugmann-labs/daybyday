import Foundation

public struct DayView: Hashable, Sendable {
    /// What a number commitment's row offers in a tick's place.
    public struct NumberEntry: Hashable, Sendable {
        /// The number the day already holds, or `nil` where it holds none.
        public let number: Decimal?
        /// The range the commitment declares, said for an empty field — "40–150" — or `nil`
        /// where it declares none or the entry is chosen. `CONTEXT.md` § *Number entry*.
        public let hint: String?
        /// Every whole number the commitment's range holds, lowest first, where the range is
        /// short — both bounds whole numbers and eleven values or fewer, both counted,
        /// `CONTEXT.md` § *Short range* — and `nil` where the entry is typed instead. Never
        /// empty where it is not `nil`; `hint` and this are never both non-`nil` — but a typed
        /// entry whose commitment declares no range at all has neither.
        public let values: [Decimal]?
        /// The same range said as the cause a number outside it is refused for — "Must be
        /// between 40 and 150" — or `nil` where the commitment declares none. Internal: the
        /// shell reads a cause off the notice, never off an entry.
        let refusalCause: String?
        /// The number this entry's commitment held on the latest date before this row's date
        /// that holds one, or `nil` where its day already holds a number, where the entry is
        /// chosen, or where that number lies outside the range this entry refuses against.
        /// `CONTEXT.md` § *Starting number*.
        public let startingNumber: Decimal?
    }

    /// What a note commitment's row offers in a tick's place.
    public struct NoteEntry: Hashable, Sendable {
        /// The note the day already holds, or `nil` where it holds none.
        public let note: String?
    }

    /// What a total commitment's row offers in a tick's place.
    public struct TotalEntry: Hashable, Sendable {
        /// The day's sum and the commitment's target, in this package's own words — "150 of
        /// 120".
        public let soFarOfTarget: String
    }

    /// What a row makes of an amount committed in its total entry.
    public enum TotalRecord: Hashable, Sendable {
        case addition(Addition)
        case notAboveZero
        case tooLargeToAdd
    }

    public struct Row: Hashable, Sendable {
        let commitment: Commitment
        let date: CalendarDate
        public let isKept: Bool

        /// The number the history the day view was formed from holds for this row's commitment
        /// on this row's date, or `nil` where it holds none. Not given back by anything but
        /// `numberEntry(asOf:)`; see `design.md` § *A row holds the number and does not give it
        /// out*.
        let number: Decimal?

        /// The number this row's commitment held on the latest date before this row's date that
        /// holds one, kept only where this row's day holds no number, its range is not short —
        /// a short range is chosen, never typed — and that number does not lie outside it; `nil`
        /// otherwise. Worked out at formation, from the history this row's day view was formed
        /// from, and part of the row: `design.md` § *The row works the starting number out at
        /// formation, and it is part of the row*. Not given back by anything but
        /// `numberEntry(asOf:)`.
        let startingNumber: Decimal?

        /// The note the history the day view was formed from holds for this row's commitment on
        /// this row's date, or `nil` where it holds none. Not given back by anything but
        /// `noteEntry(asOf:)`.
        let note: String?

        /// The sum the history the day view was formed from has added for this row's commitment
        /// on this row's date. Not given back by anything but `totalEntry(asOf:)`.
        let total: Decimal

        /// This row's commitment's standing on a weekly quota — the days of its week, from its
        /// Monday through this row's date, that a weekly-quota era of the commitment's chain
        /// holds and history answers kept against, and what that week owes — `nil` on every
        /// other schedule. A fourth thing a weekly-quota row is, alongside its commitment, its
        /// date and what that day holds; see `design.md` § *A row stores its standing, and
        /// stores none off a weekly quota* and § *One week rule, in one place*.
        struct WeekStanding: Hashable, Sendable {
            let kept: Int
            let owed: Int
        }

        let weekStanding: WeekStanding?

        public var name: String { commitment.name }

        /// The rhythm this row's commitment runs on, in words — given this row's standing and
        /// what its week owes on a weekly quota, and plainly otherwise. See
        /// `docs/adr/1034-a-schedule-says-its-rhythm-in-words.md`.
        public var rhythmInWords: String {
            guard let weekStanding else {
                return commitment.rhythmInWords
            }
            return commitment.schedule.inWords(given: weekStanding.kept, owing: weekStanding.owed)
        }

        /// The tick this row makes, or `nil` when the row's date is later than `today`.
        public func tick(asOf today: CalendarDate) -> Tick? {
            guard today.days(until: date) <= 0 else {
                return nil
            }

            return Tick(commitment, on: date)
        }

        /// The number entry this row offers, or `nil` when its commitment's kind is not a number
        /// or the row's date is later than `today`. Chosen where the commitment's range is short
        /// (`Commitment.Range.isShort`), typed otherwise — `CONTEXT.md` § *Short range*.
        public func numberEntry(asOf today: CalendarDate) -> NumberEntry? {
            guard today.days(until: date) <= 0 else {
                return nil
            }

            guard case .number(let range) = commitment.kind else {
                return nil
            }

            if let range, range.isShort {
                return NumberEntry(
                    number: number, hint: nil, values: range.wholeNumbers,
                    refusalCause: "Must be between \(range.lowest) and \(range.highest)",
                    startingNumber: startingNumber)
            }

            return NumberEntry(
                number: number, hint: range.map { "\($0.lowest)–\($0.highest)" }, values: nil,
                refusalCause: range.map { "Must be between \($0.lowest) and \($0.highest)" },
                startingNumber: startingNumber)
        }

        /// The number record this row makes of `decimal` — this row's commitment, on this row's
        /// date — or `nil` when the row offers no number entry as of `today`, or its commitment
        /// refuses the value.
        public func numberRecord(_ decimal: Decimal, asOf today: CalendarDate) -> Number? {
            guard numberEntry(asOf: today) != nil else {
                return nil
            }

            return Number(decimal, for: commitment, on: date)
        }

        /// The record a number for this row is kept under: this row's commitment on this row's
        /// date. Internal, and the only thing a take-back needs.
        var recordedDay: RecordedDay {
            RecordedDay(commitment: commitment, date: date)
        }

        /// The note entry this row offers, or `nil` when its commitment's kind is not a note or
        /// the row's date is later than `today`.
        public func noteEntry(asOf today: CalendarDate) -> NoteEntry? {
            guard today.days(until: date) <= 0 else {
                return nil
            }

            guard case .note = commitment.kind else {
                return nil
            }

            return NoteEntry(note: note)
        }

        /// The note record this row makes of `text` — this row's commitment, on this row's date
        /// — or `nil` when the row offers no note entry as of `today`, or the text says nothing.
        public func noteRecord(_ text: String, asOf today: CalendarDate) -> Note? {
            guard noteEntry(asOf: today) != nil else {
                return nil
            }

            return Note(text, for: commitment, on: date)
        }

        /// The total entry this row offers, or `nil` when its commitment's kind is not a total
        /// or the row's date is later than `today`.
        public func totalEntry(asOf today: CalendarDate) -> TotalEntry? {
            guard today.days(until: date) <= 0 else {
                return nil
            }

            guard case .total(let target) = commitment.kind else {
                return nil
            }

            return TotalEntry(soFarOfTarget: "\(total) of \(target.amount)")
        }

        /// What this row makes of `amount` — an addition of this row's commitment on this row's
        /// date, or the reason it makes none. `nil` when the row offers no total entry as of
        /// `today`.
        public func totalRecord(_ amount: Decimal, asOf today: CalendarDate) -> TotalRecord? {
            guard totalEntry(asOf: today) != nil else {
                return nil
            }

            guard let addition = Addition(amount, for: commitment, on: date) else {
                return .notAboveZero
            }

            guard Digits.canAdd(amount, to: total) else {
                return .tooLargeToAdd
            }

            return .addition(addition)
        }

        /// Whether this row offers taking its day's last addition back: exactly when it offers
        /// a total entry as of `today` and its day's sum is above zero.
        public func offersTakeBackLast(asOf today: CalendarDate) -> Bool {
            totalEntry(asOf: today) != nil && total > 0
        }

        /// Whether this row offers anything at all as of `today`: a tick, a number entry, a
        /// note entry or a total entry. Read off those four and never off the date.
        public func offersAnything(asOf today: CalendarDate) -> Bool {
            tick(asOf: today) != nil || numberEntry(asOf: today) != nil
                || noteEntry(asOf: today) != nil || totalEntry(asOf: today) != nil
        }
    }

    /// What this day view says its day is: the three-letter name of the weekday its date falls
    /// on, and nothing else. The words are this package's own and do not follow the device's
    /// locale; see ADR-1022.
    public var title: String {
        DayTitle.weekdayNames[date.weekday]!
    }

    /// A category, or no category at all, together with the rows under it that are due on this
    /// day view's date. `design.md` § *The seam*.
    public struct Group: Hashable, Sendable {
        public let category: String?
        public let rows: [Row]

        public init(category: String?, rows: [Row]) {
            self.category = category
            self.rows = rows
        }
    }

    /// A one-off standing on a day view's date: its one-off, that date and whether it is done.
    /// `design.md` § *Lateness is derived from what the row is, never stored*.
    public struct OneOffRow: Hashable, Sendable {
        let oneOff: OneOff
        let date: CalendarDate
        public let isDone: Bool

        public var name: String { oneOff.name }

        /// How late this row's one-off is, said in days — "1 day late", "400 days late" — or
        /// `nil` while it is done or not yet late. `design.md` § *The seam*.
        public var lateInWords: String? {
            guard !isDone else {
                return nil
            }

            let daysLate = oneOff.date.days(until: date)
            guard daysLate > 0 else {
                return nil
            }

            return daysLate == 1 ? "1 day late" : "\(daysLate) days late"
        }

        /// Whether this row offers its tick as of `today`: `true` exactly when `today` is no
        /// earlier than this row's date, whether or not the one-off is done. `design.md` § *The
        /// seam*.
        public func offersTick(asOf today: CalendarDate) -> Bool {
            today.days(until: date) <= 0
        }
    }

    /// The one-offs standing on a day view's date, headed "One-offs". `design.md` § *A One-offs
    /// group of its own, not a fifth `Group`*.
    public struct OneOffGroup: Hashable, Sendable {
        public let heading: String
        public let rows: [OneOffRow]
    }

    /// A birthday falling on a day view's date, and whether it is ticked. `design.md` § *The
    /// seam*. Holds its birthday privately — a row gives back its words, whether it is ticked
    /// and whether it offers its tick, and nothing else; `openspec/changes
    /// /draw-birthdays-on-day-screen/specs/day-screen/spec.md` requirement *A birthday row is
    /// its birthday and whether it is ticked...* "MUST NOT give back its birthday's contact or
    /// day."
    public struct BirthdayRow: Hashable, Sendable {
        let birthday: Birthday
        public let isTicked: Bool

        /// The calendar's own words for this row's birthday, exactly as handed — empty space
        /// included, never trimmed.
        public var words: String { birthday.words }

        /// Whether this row offers its tick as of `today`: `true` exactly when `today` is no
        /// earlier than this row's birthday's day, whether or not it is ticked.
        public func offersTick(asOf today: CalendarDate) -> Bool {
            today.days(until: birthday.day) <= 0
        }
    }

    /// The birthdays falling on a day view's date, headed "Birthdays". `design.md` § *A group
    /// of its own, mirroring the one-offs*.
    public struct BirthdayGroup: Hashable, Sendable {
        public let heading: String
        public let rows: [BirthdayRow]
    }

    let date: CalendarDate

    /// This day view's rows, in **groups** — one for each group it was handed that holds at
    /// least one row due on this day view's date, in the order it was handed them. A day view
    /// works out no group of its own: it sorts none, combines none under the same category, and
    /// decides no place for the commitments under no category. `design.md` § *The seam*.
    public let groups: [Group]

    /// The one-offs standing on this day view's date, or `nil` where none stand. `design.md`
    /// § *A One-offs group of its own, not a fifth `Group`*.
    public let oneOffGroup: OneOffGroup?

    /// The birthdays standing on this day view's date, or `nil` where none fall there —
    /// `openspec/changes/draw-birthdays-on-day-screen/specs/day-screen/spec.md` requirement *A
    /// day screen draws the birthdays falling on each day...*: "SHALL hold no such group where
    /// none falls there." `nil` too where this day view was not handed any birthdays at all —
    /// every existing initializer below, none of which takes one.
    public let birthdayGroup: BirthdayGroup?

    /// Every row this day view holds, read across `groups` in the order the groups are drawn —
    /// the same rows `groups` holds and each exactly once.
    public var rows: [Row] { groups.flatMap(\.rows) }

    public init(of commitments: [Commitment], on date: CalendarDate, in history: History) {
        self.init(of: [Roster.Group(category: nil, commitments: commitments)], on: date, in: history)
    }

    /// Forms a day view from `groups` — the same shape a roster reads its commitments back in —
    /// each drawn as its own group, dropping every commitment not due on `date` and, with it, a
    /// group left holding none. `design.md` § *The seam*. Reads every commitment as its own only
    /// era: `init(of:on:in:roster:)` is the form that reads a commitment's whole chain instead,
    /// package-internal because `DayScreen` is its only caller.
    public init(of groups: [Roster.Group], on date: CalendarDate, in history: History) {
        self.init(of: groups, on: date, in: history, roster: nil)
    }

    /// Forms a day view exactly as `init(of:on:in:)` does, and additionally reads a weekly-quota
    /// row's standing off `roster`'s whole chain for its commitment rather than the one era
    /// `groups` itself holds, where `roster` is given — so a week a resume's gap or a stop cuts is
    /// judged against every era it holds and not the one shown alone,
    /// `openspec/changes/stop-and-resume-as-eras/design.md` § *One week rule, in one place*.
    /// Package-internal: `DayScreen.formDayView` is the one caller, which always has a roster to
    /// give; nothing outside the package needs a day view read this way.
    init(
        of groups: [Roster.Group], on date: CalendarDate, in history: History, roster: Roster?,
        birthdayGroup: BirthdayGroup? = nil
    ) {
        self.date = date
        self.groups = Self.makeGroups(from: groups, on: date, in: history, roster: roster)
        self.oneOffGroup = nil
        self.birthdayGroup = birthdayGroup
    }

    /// Forms a day view exactly as `init(of:on:in:)` does, and additionally holds a `OneOffGroup`
    /// headed "One-offs" of the one-offs standing on `date` as of `today` — holding no rows where
    /// none stand, rather than no group at all, since this initializer was handed one-offs.
    /// `design.md` § *The empty group is the offer*.
    public init(
        of groups: [Roster.Group], oneOffs: OneOffs, asOf today: CalendarDate,
        on date: CalendarDate, in history: History
    ) {
        self.init(
            of: groups, oneOffs: oneOffs, asOf: today, on: date, in: history, roster: nil)
    }

    /// Forms a day view exactly as `init(of:oneOffs:asOf:on:in:)` does, reading a weekly-quota
    /// row's standing off `roster`'s whole chain where `roster` is given, exactly as
    /// `init(of:on:in:roster:)` does. Package-internal for the same reason: `DayScreen
    /// .formDayView` is the one caller.
    init(
        of groups: [Roster.Group], oneOffs: OneOffs, asOf today: CalendarDate,
        on date: CalendarDate, in history: History, roster: Roster?,
        birthdayGroup: BirthdayGroup? = nil
    ) {
        self.date = date
        self.groups = Self.makeGroups(from: groups, on: date, in: history, roster: roster)

        let standing = oneOffs.standing(on: date, asOf: today)
        self.oneOffGroup = OneOffGroup(
            heading: "One-offs",
            rows: standing.map { oneOff in
                OneOffRow(oneOff: oneOff, date: date, isDone: oneOffs.isDone(oneOff))
            })
        self.birthdayGroup = birthdayGroup
    }

    /// The groups `init(of:on:in:roster:)` and `init(of:oneOffs:asOf:on:in:roster:)` both hold:
    /// one for each group handed in that keeps at least one row due on `date`, dropping every
    /// commitment not due and, with it, a group left holding none. A weekly-quota row's standing
    /// is read off `WeekQuota`, against `commitment`'s whole chain where `roster` holds one.
    private static func makeGroups(
        from groups: [Roster.Group], on date: CalendarDate, in history: History, roster: Roster?
    ) -> [Group] {
        groups.compactMap { group in
            let rows = group.commitments
                .filter { $0.isDue(on: date) }
                .map { commitment -> Row in
                    let weekStanding: Row.WeekStanding?
                    if case .weeklyQuota = commitment.schedule {
                        let links = WeekQuota.chain(of: commitment, in: roster)
                        let monday = WeekQuota.monday(of: date)
                        let standing =
                            WeekQuota.standing(
                                monday: monday, links: links, history: history, keptThrough: date)
                            ?? (kept: 0, owed: 0)
                        weekStanding = Row.WeekStanding(kept: standing.kept, owed: standing.owed)
                    } else {
                        weekStanding = nil
                    }
                    let number = history.number(for: commitment, on: date)
                    return Row(
                        commitment: commitment, date: date,
                        isKept: history.isKept(commitment, on: date),
                        number: number,
                        startingNumber: Self.startingNumber(
                            for: commitment, heldNumber: number, on: date, in: history),
                        note: history.note(for: commitment, on: date),
                        total: history.total(for: commitment, on: date),
                        weekStanding: weekStanding)
                }
            guard !rows.isEmpty else {
                return nil
            }
            return Group(category: group.category, rows: rows)
        }
    }

    /// The starting number a number row of `commitment` stores: `nil` where `heldNumber` is not
    /// `nil` — the day already holds a number — where `commitment`'s kind is not a number or its
    /// range is short — a short range is chosen, never typed — or where `history` holds no
    /// earlier number for `commitment` before `date`; otherwise the latest number `history`
    /// holds for `commitment` before `date`, or `nil` where it lies outside `commitment`'s own
    /// range, both bounds included. `design.md` § *The row works the starting number out at
    /// formation, and it is part of the row* and § *A refused latest number is none, never a
    /// reach further back*.
    private static func startingNumber(
        for commitment: Commitment, heldNumber: Decimal?, on date: CalendarDate, in history: History
    ) -> Decimal? {
        guard heldNumber == nil, case .number(let range) = commitment.kind,
            !(range?.isShort ?? false)
        else {
            return nil
        }

        guard let latest = history.latestNumber(for: commitment, before: date) else {
            return nil
        }

        if let range, !(range.lowest <= latest && latest <= range.highest) {
            return nil
        }

        return latest
    }

    /// The day view of the calendar date one day before this one's, or `nil` when this day view
    /// is of 1 January 1583.
    public func previousDay(of commitments: [Commitment], in history: History) -> DayView? {
        guard let previousDate = date.adding(days: -1) else {
            return nil
        }

        return DayView(of: commitments, on: previousDate, in: history)
    }

    /// The day view of the calendar date one day before this one's, or `nil` when this day view
    /// is of 1 January 1583.
    public func previousDay(of groups: [Roster.Group], in history: History) -> DayView? {
        guard let previousDate = date.adding(days: -1) else {
            return nil
        }

        return DayView(of: groups, on: previousDate, in: history)
    }

    /// The day view of the calendar date one day after this one's, or `nil` when this day view
    /// is of 31 December 9999.
    public func nextDay(of commitments: [Commitment], in history: History) -> DayView? {
        guard let nextDate = date.adding(days: 1) else {
            return nil
        }

        return DayView(of: commitments, on: nextDate, in: history)
    }

    /// The day view of the calendar date one day after this one's, or `nil` when this day view
    /// is of 31 December 9999.
    public func nextDay(of groups: [Roster.Group], in history: History) -> DayView? {
        guard let nextDate = date.adding(days: 1) else {
            return nil
        }

        return DayView(of: groups, on: nextDate, in: history)
    }
}

/// A range is short where both its bounds are whole numbers and it holds eleven whole numbers or
/// fewer, both bounds counted — `CONTEXT.md` § *Short range*. A short range's number entry is
/// chosen from `wholeNumbers`; every other range is typed. Kept here, `fileprivate`, rather than
/// on `Commitment.Range` itself: this Story's own fix reaches no file but `DayView.swift`,
/// `DayScreen.swift` and their tests (`tasks.md` § 1).
extension Commitment.Range {
    fileprivate var isShort: Bool {
        guard lowest.isWholeNumber, highest.isWholeNumber else {
            return false
        }
        return (highest - lowest + 1) <= 11
    }

    /// Every whole number from `lowest` to `highest`, both included, lowest first — the values a
    /// short range's entry offers. Bounded to `highest − lowest + 1` steps by the loop itself, so
    /// it can never run more than eleven times: a `Decimal` past its own precision can make
    /// `value + 1 == value` hold forever (`1e50 + 1 == 1e50`), so the loop counts steps down
    /// rather than comparing `value` against `highest` on every pass.
    fileprivate var wholeNumbers: [Decimal] {
        let stepCount = NSDecimalNumber(decimal: highest - lowest + 1).intValue
        var values: [Decimal] = []
        var value = lowest
        for _ in 0..<max(stepCount, 0) {
            values.append(value)
            value += 1
        }
        return values
    }
}

extension Decimal {
    /// Whether this decimal holds no fractional part — 40 is, 40.5 is not, and 40.0 is (a
    /// `Decimal`'s own trailing zeros never make it fractional). Compares against the value
    /// rounded toward zero, so how many trailing zeros this decimal's own representation happens
    /// to carry never changes the answer.
    fileprivate var isWholeNumber: Bool {
        guard !isNaN else {
            return false
        }
        var rounded = Decimal()
        var value = self
        NSDecimalRound(&rounded, &value, 0, .down)
        return rounded == self
    }
}
