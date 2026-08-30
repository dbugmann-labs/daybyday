public struct CalendarDate: Hashable, Sendable {
    let year: Int
    let month: Int
    let day: Int

    public init?(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
}
