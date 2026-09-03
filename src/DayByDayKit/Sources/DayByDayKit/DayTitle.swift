/// The words a day title is made of: the app's own, fixed English names for each weekday and
/// each month, independent of the device's language, region, locale or calendar preferences.
/// See `docs/adr/1022-the-day-is-said-in-the-apps-own-words.md`.
///
/// Nothing here is public: no requirement asks for the name of a weekday or a month on its own,
/// only for the day title `DayView.title(asOf:)` assembles from them. `Weekday.swift` is
/// `schedule`'s type and is not touched — see `design.md` § *Why the words are the app's own*.
enum DayTitle {
    static let weekdayNames: [Weekday: String] = [
        .monday: "Monday",
        .tuesday: "Tuesday",
        .wednesday: "Wednesday",
        .thursday: "Thursday",
        .friday: "Friday",
        .saturday: "Saturday",
        .sunday: "Sunday",
    ]

    /// Maps `CalendarDate.month`, which numbers January as 1.
    static let monthNames: [Int: String] = [
        1: "January",
        2: "February",
        3: "March",
        4: "April",
        5: "May",
        6: "June",
        7: "July",
        8: "August",
        9: "September",
        10: "October",
        11: "November",
        12: "December",
    ]
}
