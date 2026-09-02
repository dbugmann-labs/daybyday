public struct WeeklyQuota: Hashable, Sendable {
    let timesPerWeek: Int

    public init?(timesPerWeek: Int) {
        self.timesPerWeek = timesPerWeek
    }
}
