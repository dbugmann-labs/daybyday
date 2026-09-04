import Foundation

/// The wire shape of a `Commitment`, shared byte-for-byte by `RecordDocument` and
/// `RosterDocument`: both keep a commitment the same way, so a fifth `Schedule` case is one
/// compile error in this one exhaustive `switch` rather than two. `design.md` § *The form on
/// disk* fixes the shape below by hand, in the record's own words, rather than deriving `Codable`
/// on the engine types: the file's shape is a contract independent of how `Schedule` and
/// `Commitment` happen to be laid out in Swift.
struct CommitmentRecord: Codable {
    var name: String
    var keptFrom: DateRecord
    var schedule: ScheduleRecord

    init(_ commitment: Commitment) {
        name = commitment.name
        keptFrom = DateRecord(commitment.keptFrom)
        schedule = ScheduleRecord(commitment.schedule)
    }

    func commitment() -> Commitment? {
        guard let schedule = schedule.schedule(), let keptFrom = keptFrom.calendarDate() else {
            return nil
        }
        return Commitment(name: name, schedule: schedule, keptFrom: keptFrom)
    }
}

struct DateRecord: Codable, Equatable, Comparable {
    var year: Int
    var month: Int
    var day: Int

    init(_ date: CalendarDate) {
        year = date.year
        month = date.month
        day = date.day
    }

    func calendarDate() -> CalendarDate? {
        CalendarDate(year: year, month: month, day: day)
    }

    static func < (lhs: DateRecord, rhs: DateRecord) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        }
        if lhs.month != rhs.month {
            return lhs.month < rhs.month
        }
        return lhs.day < rhs.day
    }
}

/// One of the four shapes `Schedule` has. The conversion from `Schedule` is an exhaustive `switch`,
/// so a fifth case is a compile error here rather than a silent gap — `design.md` § *A fifth
/// schedule shape* names this on purpose.
enum ScheduleRecord: Codable, Equatable, Comparable {
    case weekdays([String])
    case dayOfMonth(Int)
    case everyNDays(Int, from: DateRecord)
    case timesPerWeek(Int)

    private enum CodingKeys: String, CodingKey {
        case weekdays, dayOfMonth, everyNDays, from, timesPerWeek
    }

    /// Monday first, so that two equal sets of weekdays write equal text regardless of `Set`'s own
    /// iteration order — `design.md` § *The form on disk*.
    private static let weekOrder: [Weekday] = [
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ]

    /// The one wire name per weekday. `weekday(named:)` is this table's inverse, built from it, so
    /// the two directions cannot disagree the way two hand-written `switch`es could.
    private static let wireNames: [Weekday: String] = [
        .monday: "monday",
        .tuesday: "tuesday",
        .wednesday: "wednesday",
        .thursday: "thursday",
        .friday: "friday",
        .saturday: "saturday",
        .sunday: "sunday",
    ]

    private static let weekdaysByWireName: [String: Weekday] = Dictionary(
        uniqueKeysWithValues: wireNames.map { ($0.value, $0.key) })

    private static func name(for weekday: Weekday) -> String {
        wireNames[weekday]!
    }

    private static func weekday(named name: String) -> Weekday? {
        weekdaysByWireName[name]
    }

    init(_ schedule: Schedule) {
        switch schedule {
        case .weekdays(let weekdays):
            let ordered = Self.weekOrder.filter { weekdays.contains($0) }.map(Self.name(for:))
            self = .weekdays(ordered)
        case .dayOfMonth(let dayOfMonth):
            self = .dayOfMonth(dayOfMonth.day)
        case .everyNDays(let interval, from: let start):
            self = .everyNDays(interval.days, from: DateRecord(start))
        case .weeklyQuota(let quota):
            self = .timesPerWeek(quota.timesPerWeek)
        }
    }

    func schedule() -> Schedule? {
        switch self {
        case .weekdays(let names):
            var weekdays = Set<Weekday>()
            for name in names {
                guard let weekday = Self.weekday(named: name) else {
                    return nil
                }
                weekdays.insert(weekday)
            }
            return .weekdays(weekdays)
        case .dayOfMonth(let day):
            guard let dayOfMonth = DayOfMonth(day: day) else {
                return nil
            }
            return .dayOfMonth(dayOfMonth)
        case .everyNDays(let days, from: let start):
            guard let interval = DayInterval(days: days), let start = start.calendarDate() else {
                return nil
            }
            return .everyNDays(interval, from: start)
        case .timesPerWeek(let timesPerWeek):
            guard let quota = WeeklyQuota(timesPerWeek: timesPerWeek) else {
                return nil
            }
            return .weeklyQuota(quota)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let weekdays = try container.decodeIfPresent([String].self, forKey: .weekdays) {
            self = .weekdays(weekdays)
        } else if let dayOfMonth = try container.decodeIfPresent(Int.self, forKey: .dayOfMonth) {
            self = .dayOfMonth(dayOfMonth)
        } else if let everyNDays = try container.decodeIfPresent(Int.self, forKey: .everyNDays) {
            let from = try container.decode(DateRecord.self, forKey: .from)
            self = .everyNDays(everyNDays, from: from)
        } else if let timesPerWeek = try container.decodeIfPresent(Int.self, forKey: .timesPerWeek) {
            self = .timesPerWeek(timesPerWeek)
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "no recognised schedule shape"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .weekdays(let names):
            try container.encode(names, forKey: .weekdays)
        case .dayOfMonth(let day):
            try container.encode(day, forKey: .dayOfMonth)
        case .everyNDays(let days, from: let start):
            try container.encode(days, forKey: .everyNDays)
            try container.encode(start, forKey: .from)
        case .timesPerWeek(let timesPerWeek):
            try container.encode(timesPerWeek, forKey: .timesPerWeek)
        }
    }

    /// Orders every shape against every other, case first then payload, so `RecordDocument` has a
    /// tiebreaker for two ticks alike in commitment name, kept-from day and date but not schedule.
    static func < (lhs: ScheduleRecord, rhs: ScheduleRecord) -> Bool {
        lhs.sortKey < rhs.sortKey
    }

    private var sortKey: String {
        switch self {
        case .weekdays(let names):
            return "0:" + names.joined(separator: ",")
        case .dayOfMonth(let day):
            return "1:\(day)"
        case .everyNDays(let days, from: let start):
            return "2:\(days):\(start.year)-\(start.month)-\(start.day)"
        case .timesPerWeek(let timesPerWeek):
            return "3:\(timesPerWeek)"
        }
    }
}
