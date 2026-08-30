public enum Weekday: Hashable, Sendable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday

    /// Maps `Foundation.Calendar`'s weekday component, which numbers Sunday as 1.
    init(foundationWeekday: Int) {
        switch foundationWeekday {
        case 1: self = .sunday
        case 2: self = .monday
        case 3: self = .tuesday
        case 4: self = .wednesday
        case 5: self = .thursday
        case 6: self = .friday
        case 7: self = .saturday
        default: fatalError("invalid Foundation weekday component: \(foundationWeekday)")
        }
    }
}
