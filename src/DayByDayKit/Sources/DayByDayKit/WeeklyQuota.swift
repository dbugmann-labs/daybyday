public struct WeeklyQuota: Hashable, Sendable {
    let timesPerWeek: Int

    public init?(timesPerWeek: Int) {
        guard (1...7).contains(timesPerWeek) else {
            return nil
        }

        self.timesPerWeek = timesPerWeek
    }
}
