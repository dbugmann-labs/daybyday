public struct DayView: Hashable, Sendable {
    public struct Row: Hashable, Sendable {
        let commitment: Commitment
        public let isKept: Bool

        public var name: String { commitment.name }
    }

    let date: CalendarDate
    public let rows: [Row]

    public init(of commitments: [Commitment], on date: CalendarDate, in history: History) {
        self.date = date
        self.rows = commitments
            .filter { $0.isDue(on: date) }
            .map { Row(commitment: $0, isKept: history.isKept($0, on: date)) }
    }
}
