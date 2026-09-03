public struct DayView: Hashable, Sendable {
    public struct Row: Hashable, Sendable {
        let commitment: Commitment
        let date: CalendarDate
        public let isKept: Bool

        public var name: String { commitment.name }

        /// The tick this row makes, or `nil` when the row's date is later than `today`.
        public func tick(asOf today: CalendarDate) -> Tick? {
            fatalError("not implemented")
        }
    }

    let date: CalendarDate
    public let rows: [Row]

    public init(of commitments: [Commitment], on date: CalendarDate, in history: History) {
        self.date = date
        self.rows = commitments
            .filter { $0.isDue(on: date) }
            .map { Row(commitment: $0, date: date, isKept: history.isKept($0, on: date)) }
    }
}
