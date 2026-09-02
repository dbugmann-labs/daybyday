public struct Tick: Hashable, Sendable {
    let commitment: Commitment
    let date: CalendarDate

    public init?(_ commitment: Commitment, on date: CalendarDate) {
        guard commitment.isDue(on: date) else {
            return nil
        }

        self.commitment = commitment
        self.date = date
    }
}
