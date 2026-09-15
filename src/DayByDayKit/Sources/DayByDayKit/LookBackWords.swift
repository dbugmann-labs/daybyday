/// The package's own fixed English a look-back is said in — the same shape `DayTitle.swift` and
/// `ScheduleWords.swift` hold. Nothing here is public: `LookBack.form(...)` is the only caller,
/// and it exposes no member of this table. See
/// `docs/adr/1022-the-day-is-said-in-the-apps-own-words.md` and
/// `docs/adr/1034-a-schedule-says-its-rhythm-in-words.md`, the two ADRs this table follows the
/// pattern of.
enum LookBackWords {
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

    /// A month as that month's name and its year, separated by a single space.
    static func month(year: Int, month: Int) -> String {
        "\(monthNames[month]!) \(year)"
    }

    /// A day as the day of the month, that month's name and the year, each part separated by a
    /// single space.
    static func day(_ date: CalendarDate) -> String {
        "\(date.day) \(monthNames[date.month]!) \(date.year)"
    }

    /// A fraction as the count of days kept, a slash with no space on either side, and the count
    /// of days due.
    static func fraction(kept: Int, due: Int) -> String {
        "\(kept)/\(due)"
    }
}
