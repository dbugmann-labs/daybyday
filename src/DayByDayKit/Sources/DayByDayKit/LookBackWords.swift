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

    /// The three-letter month names a week's span is said in — the one place a look-back says a
    /// month short, `openspec/changes/look-back-at-a-quota/specs/look-back/spec.md` § *A look-back
    /// says a week as the span of its days, in short month names*.
    static let shortMonthNames: [Int: String] = [
        1: "Jan",
        2: "Feb",
        3: "Mar",
        4: "Apr",
        5: "May",
        6: "Jun",
        7: "Jul",
        8: "Aug",
        9: "Sep",
        10: "Oct",
        11: "Nov",
        12: "Dec",
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

    /// A week as the span of its seven days, `start` through `end` — inside one calendar month,
    /// the two days joined by an en dash with no space on either side, then that month's short
    /// name and the year; across two months in one year, each end as its day and short month
    /// name, an en dash with a single space on either side between them, and the year once after
    /// the second end; across two years, each end's own day, short month and year. See
    /// `openspec/changes/look-back-at-a-quota/specs/look-back/spec.md` § *A look-back says a week
    /// as the span of its days, in short month names*.
    static func week(from start: CalendarDate, through end: CalendarDate) -> String {
        if start.year == end.year && start.month == end.month {
            return "\(start.day)–\(end.day) \(shortMonthNames[start.month]!) \(start.year)"
        }
        if start.year == end.year {
            return
                "\(start.day) \(shortMonthNames[start.month]!) – \(end.day) \(shortMonthNames[end.month]!) \(end.year)"
        }
        return
            "\(start.day) \(shortMonthNames[start.month]!) \(start.year) – \(end.day) \(shortMonthNames[end.month]!) \(end.year)"
    }

    /// A fraction as the count of days kept, a slash with no space on either side, and the count
    /// of days due.
    static func fraction(kept: Int, due: Int) -> String {
        "\(kept)/\(due)"
    }
}
