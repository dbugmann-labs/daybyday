import Foundation

public struct CalendarDate: Hashable, Sendable {
    let year: Int
    let month: Int
    let day: Int

    public init?(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }

    /// The Gregorian weekday of this date, independent of the host's time zone and locale.
    var weekday: Weekday {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!

        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day

        let date = calendar.date(from: components)!
        let foundationWeekday = calendar.component(.weekday, from: date)
        return Weekday(foundationWeekday: foundationWeekday)
    }
}
