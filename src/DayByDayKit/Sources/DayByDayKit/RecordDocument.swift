import Foundation

/// The versioned form a `RecordStore` writes to and reads from disk. `design.md` § *The form on
/// disk* fixes the shape below by hand, in the record's own words, rather than deriving `Codable`
/// on the engine types: the file's shape is a contract independent of how `Schedule`, `Commitment`
/// and `Tick` happen to be laid out in Swift.
///
/// `RecordDocument` converts to and from a `Set<Tick>` rather than a `History`: `History` keeps its
/// own ticks `private`, by design, and building one back up from a decoded document only needs its
/// public `add(_:)` — reading one out is the direction that has no public way through, so this type
/// works at the one level the engine already opens up.
struct RecordDocument: Codable {
    /// The form this app writes. A document whose `version` is higher is a later form; `Envelope`
    /// below reads it before this whole shape is decoded, as `design.md` requires.
    static let currentVersion = 1

    var version: Int
    var ticks: [TickRecord]

    /// Builds the document that exactly represents `ticks`, in the stable order `design.md` fixes:
    /// by commitment name, then kept-from day, then date — so two equal sets of ticks produce
    /// byte-identical files.
    init(_ ticks: Set<Tick>) {
        version = Self.currentVersion
        self.ticks = ticks
            .map(TickRecord.init)
            .sorted { lhs, rhs in
                if lhs.commitment.name != rhs.commitment.name {
                    return lhs.commitment.name < rhs.commitment.name
                }
                if lhs.commitment.keptFrom != rhs.commitment.keptFrom {
                    return lhs.commitment.keptFrom < rhs.commitment.keptFrom
                }
                return lhs.date < rhs.date
            }
    }

    /// Re-forms every tick this document holds, through the engine's failable initializers, so
    /// every invariant the engine has applies to what comes off the disk. `nil` if any one tick in
    /// the document could not be formed — the whole document is refused, not the bad ticks dropped.
    func formTicks() -> Set<Tick>? {
        var result = Set<Tick>()
        for record in ticks {
            guard let tick = record.tick() else {
                return nil
            }
            result.insert(tick)
        }
        return result
    }
}

/// Reads only `version`, so a later form is told apart from the body before the body is ever
/// decoded — a document whose body this app cannot parse and a document from a newer app must not
/// report the same error.
struct RecordDocumentEnvelope: Decodable {
    var version: Int
}

struct TickRecord: Codable {
    var commitment: CommitmentRecord
    var date: DateRecord

    init(_ tick: Tick) {
        commitment = CommitmentRecord(tick.commitment)
        date = DateRecord(tick.date)
    }

    func tick() -> Tick? {
        guard let commitment = commitment.commitment(), let date = date.calendarDate() else {
            return nil
        }
        return Tick(commitment, on: date)
    }
}

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
enum ScheduleRecord: Codable {
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

    private static func name(for weekday: Weekday) -> String {
        switch weekday {
        case .monday: return "monday"
        case .tuesday: return "tuesday"
        case .wednesday: return "wednesday"
        case .thursday: return "thursday"
        case .friday: return "friday"
        case .saturday: return "saturday"
        case .sunday: return "sunday"
        }
    }

    private static func weekday(named name: String) -> Weekday? {
        switch name {
        case "monday": return .monday
        case "tuesday": return .tuesday
        case "wednesday": return .wednesday
        case "thursday": return .thursday
        case "friday": return .friday
        case "saturday": return .saturday
        case "sunday": return .sunday
        default: return nil
        }
    }

    init(_ schedule: Schedule) {
        switch schedule {
        case .weekdays(let weekdays):
            let ordered = Self.weekOrder.filter { weekdays.contains($0) }.map(Self.name(for:))
            self = .weekdays(ordered)
        case .dayOfMonth, .everyNDays, .weeklyQuota:
            fatalError("not implemented")
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
        case .dayOfMonth, .everyNDays, .timesPerWeek:
            fatalError("not implemented")
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let weekdays = try container.decodeIfPresent([String].self, forKey: .weekdays) {
            self = .weekdays(weekdays)
        } else {
            fatalError("not implemented")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .weekdays(let names):
            try container.encode(names, forKey: .weekdays)
        case .dayOfMonth, .everyNDays, .timesPerWeek:
            fatalError("not implemented")
        }
    }
}
