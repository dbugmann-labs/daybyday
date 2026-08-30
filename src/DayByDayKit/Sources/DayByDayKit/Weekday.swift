public enum Weekday: Hashable, Sendable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday

    /// Maps `Foundation.Calendar`'s weekday component, which numbers Sunday as 1.
    private static let byFoundationWeekday: [Int: Weekday] = [
        1: .sunday,
        2: .monday,
        3: .tuesday,
        4: .wednesday,
        5: .thursday,
        6: .friday,
        7: .saturday,
    ]

    init(foundationWeekday: Int) {
        self = Self.byFoundationWeekday[foundationWeekday]!
    }
}
