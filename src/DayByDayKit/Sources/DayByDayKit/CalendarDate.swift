import Foundation

public struct CalendarDate: Hashable, Sendable {
    let year: Int
    let month: Int
    let day: Int

    public init?(year: Int, month: Int, day: Int) {
        // `DateComponents` reads back `nil` for any component assigned exactly `Int.max`
        // (Foundation's internal "undefined" sentinel), which would otherwise leave that
        // component unset and let an under-specified date round-trip through
        // `isValidDate(in:)` before Foundation is asked to build anything. Bounding every
        // component first closes that hole. The year lower bound additionally keeps every
        // accepted date on the correct side of the Gregorian calendar's own adoption in
        // 1582 — `Calendar(identifier: .gregorian)` is a hybrid that still applies the
        // Julian calendar before its 1582-10-15 cutover, so an earlier date would form with
        // the wrong weekday rather than the Gregorian one this type promises.
        guard (1...12).contains(month), (1...31).contains(day), (1583...9999).contains(year) else {
            return nil
        }

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!

        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day

        guard components.isValidDate(in: calendar) else {
            return nil
        }

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
