import Foundation

public struct CalendarDate: Hashable, Sendable {
    /// `TimeZone(identifier: "UTC")!` is used rather than `.gmt`: this package declares no
    /// platform in `Package.swift`, and `.gmt` does not compile against the resulting default
    /// deployment target.
    private static let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()

    /// The three components a validating initializer already checked. Public so that the edge —
    /// where an instant becomes a calendar date and back, per ADR-1004 — can rebuild a `Date` in
    /// whatever calendar it is asking on, the reverse of `ContentView.today()`'s own conversion.
    /// Read-only: the only way to change one is to form a new `CalendarDate`.
    public let year: Int
    public let month: Int
    public let day: Int

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

        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day

        guard components.isValidDate(in: Self.calendar) else {
            return nil
        }

        self.year = year
        self.month = month
        self.day = day
    }

    /// This date's midnight instant in the UTC calendar above, shared by `weekday`,
    /// `daysInMonth` and `days(until:)` rather than each building its own `DateComponents`.
    private var date: Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day

        return Self.calendar.date(from: components)!
    }

    /// The Gregorian weekday of this date, independent of the host's time zone and locale.
    var weekday: Weekday {
        let foundationWeekday = Self.calendar.component(.weekday, from: date)
        return Weekday(foundationWeekday: foundationWeekday)
    }

    /// The true length of the month this date falls in — 28 or 29 for February according to
    /// whether `year` is a leap year, 30 or 31 otherwise.
    var daysInMonth: Int {
        Self.calendar.range(of: .day, in: .month, for: date)!.count
    }

    /// The signed number of calendar days from this date to `other`, counting a leap day like
    /// any other and independent of month length, weekday, time of day and time zone. Negative
    /// when `other` falls before this date. ADR-1004 fixes the supported year range at 1583
    /// through 9999 — under four million days end to end even counting every year as a leap
    /// year — so the result comfortably fits in `Int` and a remainder taken against it cannot
    /// overflow.
    func days(until other: CalendarDate) -> Int {
        Self.calendar.dateComponents([.day], from: date, to: other.date).day!
    }

    /// The calendar date `days` calendar days from this one, or `nil` when that date falls
    /// outside the supported range — built on the same private UTC `Calendar` as `weekday`,
    /// `daysInMonth` and `days(until:)`, and returning through `init?(year:month:day:)` so the
    /// 1583–9999 guard is not restated here. That holds at the ±1 steps this method is
    /// actually called with (`DayView.previousDay`/`nextDay`), the only callers today. It does
    /// not hold in general: `Calendar.date(byAdding:to:)` saturates rather than failing on an
    /// extreme `days`, so `adding(days: Int.max)` and `adding(days: Int.min)` each read back a
    /// plausible date inside 1583–9999 rather than `nil` — a large step gives a silently wrong
    /// answer, not a crash and not a refusal.
    func adding(days: Int) -> CalendarDate? {
        let stepped = Self.calendar.date(byAdding: .day, value: days, to: date)!
        let components = Self.calendar.dateComponents([.year, .month, .day], from: stepped)
        return CalendarDate(year: components.year!, month: components.month!, day: components.day!)
    }
}
