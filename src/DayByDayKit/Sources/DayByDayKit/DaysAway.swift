import Foundation

/// A span of days a person says, over the commitments they pick, on which those commitments owe
/// nothing: a name or none, a first and a last day, and the commitments it is over. Equal by an
/// identity of its own, as a happening is (ADR-1065), so a later Story can move its ends and it
/// stays the same days away. The roster holds each beside its commitments and gives each commitment
/// picked its gap as eras — ADR-1069; `openspec/changes/say-days-away/design.md` § *The seam*.
public struct DaysAway: Hashable, Sendable {
    public struct Identity: Hashable, Sendable {
        private let value: UUID

        fileprivate init() {
            value = UUID()
        }

        init?(_ uuidString: String) {
            guard let value = UUID(uuidString: uuidString) else {
                return nil
            }
            self.value = value
        }

        var uuidString: String { value.uuidString }

        static func minted() -> Identity { Identity() }
    }

    let identity: Identity
    public let name: String?
    public let firstDay: CalendarDate
    public let lastDay: CalendarDate
    /// The commitments it is over, each at its newest era, in the order the roster holds them,
    /// read when asked — a renamed commitment is read under the name it now carries.
    public let commitments: [Commitment]

    init(
        identity: Identity, name: String?, firstDay: CalendarDate, lastDay: CalendarDate,
        commitments: [Commitment]
    ) {
        self.identity = identity
        self.name = name
        self.firstDay = firstDay
        self.lastDay = lastDay
        self.commitments = commitments
    }

    /// Its name, or "Away" where it has none.
    public var title: String { name ?? "Away" }

    /// Its days as a person reads them, "Tue 13 Oct – Sun 18 Oct", one day said once, "Tue 20 Oct".
    public var daysInWords: String {
        let first = Self.dayInWords(firstDay)
        return firstDay == lastDay ? first : "\(first) – \(Self.dayInWords(lastDay))"
    }

    /// A day as days away say it, "Tue 13 Oct".
    public static func dayInWords(_ day: CalendarDate) -> String {
        DayTitle.shiftedDayInWords(day)
    }

    public static func == (lhs: DaysAway, rhs: DaysAway) -> Bool {
        lhs.identity == rhs.identity
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identity)
    }
}
