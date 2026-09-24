/// The package's own fixed English for a schedule's rhythm in words — the same shape
/// `DayTitle.swift` holds for a day title. Nothing here is public: `Schedule.inWords`,
/// `Schedule.inWords(given:)` and `Schedule.inWords(given:owing:)` are the only callers, and none
/// of them exposes this table. See `docs/adr/1034-a-schedule-says-its-rhythm-in-words.md`.
enum ScheduleWords {
    /// Monday through Sunday, paired with the three-letter name said for each — the one
    /// Monday-first list this display rule needs, since `Weekday` carries no order of its own
    /// and a `Set<Weekday>` iterates in no order a caller can rely on. A fixed array rather than
    /// a dictionary, so a missing day is a compile-time hole rather than a name silently dropped.
    static let weekdayOrder: [(Weekday, String)] = [
        (.monday, "Mon"),
        (.tuesday, "Tue"),
        (.wednesday, "Wed"),
        (.thursday, "Thu"),
        (.friday, "Fri"),
        (.saturday, "Sat"),
        (.sunday, "Sun"),
    ]

    static func weekdays(_ weekdays: Set<Weekday>) -> String {
        if weekdays.count == 7 {
            return "Every day"
        }
        if weekdays.isEmpty {
            return "No day"
        }
        return weekdayOrder
            .filter { weekdays.contains($0.0) }
            .map(\.1)
            .joined(separator: ", ")
    }

    static func everyNDays(_ days: Int) -> String {
        if days == 1 {
            return "Every day"
        }
        return "Every \(days) days"
    }

    static func dayOfMonth(_ day: Int) -> String {
        let suffix: String
        if (11...13).contains(day % 100) {
            suffix = "th"
        } else {
            switch day % 10 {
            case 1: suffix = "st"
            case 2: suffix = "nd"
            case 3: suffix = "rd"
            default: suffix = "th"
            }
        }
        return "The \(day)\(suffix)"
    }

    static func weeklyQuota(_ timesPerWeek: Int) -> String {
        "\(timesPerWeek)x a week"
    }

    /// A weekly quota said given a count — the count in digits, a slash with no space on
    /// either side, and then its plain words. `count` is said exactly as given: never capped
    /// to the quota, never clamped to a week.
    static func weeklyQuota(_ timesPerWeek: Int, given count: Int) -> String {
        "\(count)/\(weeklyQuota(timesPerWeek))"
    }

    /// A weekly quota said given a count and what its week owes — the count in digits, a slash
    /// with no space on either side, and then what the week owes in place of the quota's own
    /// number of times a week. Both numbers are said exactly as given and judged against
    /// nothing. `openspec/changes/stop-and-resume-as-eras/specs/schedule/spec.md` § *A weekly
    /// quota said given what its week owes says that number in place of its own times a week*.
    static func weeklyQuota(given count: Int, owing owed: Int) -> String {
        "\(count)/\(owed)x a week"
    }
}
