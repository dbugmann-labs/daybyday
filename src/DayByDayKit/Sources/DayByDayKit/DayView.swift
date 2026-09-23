import Foundation

public struct DayView: Hashable, Sendable {
    /// What a number commitment's row offers in a tick's place.
    public struct NumberEntry: Hashable, Sendable {
        /// The number the day already holds, or `nil` where it holds none.
        public let number: Decimal?
        /// The range the commitment declares, said for an empty field — "40–150" — or `nil`
        /// where it declares none.
        public let hint: String?
        /// The same range said as the cause a number outside it is refused for — "Must be
        /// between 40 and 150" — or `nil` where the commitment declares none. Internal: the
        /// shell reads a cause off the notice, never off an entry.
        let refusalCause: String?
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
        /// or the row's date is later than `today`.
        public func numberEntry(asOf today: CalendarDate) -> NumberEntry? {
            guard today.days(until: date) <= 0 else {
                return nil
            }

            guard case .number(let range) = commitment.kind else {
                return nil
            }

            return NumberEntry(
                number: number, hint: range.map { "\($0.lowest)–\($0.highest)" },
                refusalCause: range.map { "Must be between \($0.lowest) and \($0.highest)" })
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

    let date: CalendarDate

    /// This day view's rows, in **groups** — one for each group it was handed that holds at
    /// least one row due on this day view's date, in the order it was handed them. A day view
    /// works out no group of its own: it sorts none, combines none under the same category, and
    /// decides no place for the commitments under no category. `design.md` § *The seam*.
    public let groups: [Group]

    /// The one-offs standing on this day view's date, or `nil` where none stand. `design.md`
    /// § *A One-offs group of its own, not a fifth `Group`*.
    public let oneOffGroup: OneOffGroup?

    /// Every row this day view holds, read across `groups` in the order the groups are drawn —
    /// the same rows `groups` holds and each exactly once.
    public var rows: [Row] { groups.flatMap(\.rows) }

    public init(of commitments: [Commitment], on date: CalendarDate, in history: History) {
        self.init(of: [Roster.Group(category: nil, commitments: commitments)], on: date, in: history)
    }

    /// Forms a day view from `groups` — the same shape a roster reads its commitments back in —
    /// each drawn as its own group, dropping every commitment not due on `date` and, with it, a
    /// group left holding none. `design.md` § *The seam*. `roster`, where given, is where a
    /// weekly-quota row reads its commitment's whole chain from, so a week a resume's gap or a
    /// stop cuts is judged against every era it holds and not the one shown alone —
    /// `openspec/changes/stop-and-resume-as-eras/design.md` § *One week rule, in one place*. A
    /// day view formed with no roster reads every commitment as its own only era.
    public init(
        of groups: [Roster.Group], on date: CalendarDate, in history: History, roster: Roster? = nil
    ) {
        self.date = date
        self.groups = Self.makeGroups(from: groups, on: date, in: history, roster: roster)
        self.oneOffGroup = nil
    }

    /// Forms a day view exactly as `init(of:on:in:roster:)` does, and additionally holds a
    /// `OneOffGroup` headed "One-offs" of the one-offs standing on `date` as of `today` — holding
    /// no rows where none stand, rather than no group at all, since this initializer was handed
    /// one-offs. `design.md` § *The empty group is the offer*.
    public init(
        of groups: [Roster.Group], oneOffs: OneOffs, asOf today: CalendarDate,
        on date: CalendarDate, in history: History, roster: Roster? = nil
    ) {
        self.date = date
        self.groups = Self.makeGroups(from: groups, on: date, in: history, roster: roster)

        let standing = oneOffs.standing(on: date, asOf: today)
        self.oneOffGroup = OneOffGroup(
            heading: "One-offs",
            rows: standing.map { oneOff in
                OneOffRow(oneOff: oneOff, date: date, isDone: oneOffs.isDone(oneOff))
            })
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
                    return Row(
                        commitment: commitment, date: date,
                        isKept: history.isKept(commitment, on: date),
                        number: history.number(for: commitment, on: date),
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
