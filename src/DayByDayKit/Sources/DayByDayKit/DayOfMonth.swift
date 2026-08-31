public struct DayOfMonth: Hashable, Sendable {
    let day: Int

    public init?(day: Int) {
        guard (1...31).contains(day) else {
            return nil
        }

        self.day = day
    }
}
