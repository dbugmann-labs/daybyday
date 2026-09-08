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

        public var name: String { commitment.name }

        /// The rhythm this row's commitment runs on, in words. See
        /// `docs/adr/1034-a-schedule-says-its-rhythm-in-words.md`.
        public var rhythmInWords: String { commitment.rhythmInWords }

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
    }

    /// What this day view says its day is: the weekday, the day of the month, the month and the
    /// year — "Monday 31 August 2026" — with "Today · " in front of it when `today` is this day
    /// view's own date. The words are this package's own and do not follow the device's locale;
    /// see ADR-1022.
    public func title(asOf today: CalendarDate) -> String {
        let weekday = DayTitle.weekdayNames[date.weekday]!
        let month = DayTitle.monthNames[date.month]!
        let dateWords = "\(weekday) \(date.day) \(month) \(date.year)"

        guard date == today else {
            return dateWords
        }

        return "Today · \(dateWords)"
    }

    let date: CalendarDate
    public let rows: [Row]

    public init(of commitments: [Commitment], on date: CalendarDate, in history: History) {
        self.date = date
        self.rows = commitments
            .filter { $0.isDue(on: date) }
            .map {
                Row(
                    commitment: $0, date: date, isKept: history.isKept($0, on: date),
                    number: history.number(for: $0, on: date),
                    note: history.note(for: $0, on: date),
                    total: history.total(for: $0, on: date))
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

    /// The day view of the calendar date one day after this one's, or `nil` when this day view
    /// is of 31 December 9999.
    public func nextDay(of commitments: [Commitment], in history: History) -> DayView? {
        guard let nextDate = date.adding(days: 1) else {
            return nil
        }

        return DayView(of: commitments, on: nextDate, in: history)
    }
}
