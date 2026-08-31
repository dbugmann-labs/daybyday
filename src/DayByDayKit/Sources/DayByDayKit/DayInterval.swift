public struct DayInterval: Hashable, Sendable {
    let days: Int

    public init?(days: Int) {
        guard days >= 1 else {
            return nil
        }

        self.days = days
    }
}
