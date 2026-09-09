/// The words a day title is made of: the app's own, fixed English names for each weekday,
/// independent of the device's language, region, locale or calendar preferences.
/// See `docs/adr/1022-the-day-is-said-in-the-apps-own-words.md`.
///
/// Nothing here is public: no requirement asks for the name of a weekday on its own, only for
/// the day title `DayView.title` assembles from it. `Weekday.swift` is `schedule`'s type and is
/// not touched — see `design.md` § *Why the two weekday tables stay apart*.
enum DayTitle {
    static let weekdayNames: [Weekday: String] = [
        .monday: "Mon",
        .tuesday: "Tue",
        .wednesday: "Wed",
        .thursday: "Thu",
        .friday: "Fri",
        .saturday: "Sat",
        .sunday: "Sun",
    ]
}
