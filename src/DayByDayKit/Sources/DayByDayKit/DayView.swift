public struct DayView: Hashable, Sendable {
    public struct Row: Hashable, Sendable {
        let commitment: Commitment
        let date: CalendarDate
        public let isKept: Bool

        public var name: String { commitment.name }

        /// The tick this row makes, or `nil` when the row's date is later than `today`.
        public func tick(asOf today: CalendarDate) -> Tick? {
            guard today.days(until: date) <= 0 else {
                return nil
            }

            return Tick(commitment, on: date)
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
            .map { Row(commitment: $0, date: date, isKept: history.isKept($0, on: date)) }
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
