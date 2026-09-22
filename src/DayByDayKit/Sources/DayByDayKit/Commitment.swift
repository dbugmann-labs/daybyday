import Foundation

public struct Commitment: Sendable {
    /// What makes two commitments the same commitment, given once when a commitment is first
    /// formed and never derived from, or changed by, anything else about it. Never shown to a
    /// person. `openspec/changes/give-a-commitment-an-identity/design.md` § *The seam*.
    public struct Identity: Hashable, Sendable {
        private let value: UUID

        fileprivate init() {
            value = UUID()
        }

        /// Reconstructs the identity `uuidString` names — `nil` where it does not read as a
        /// UUID. Package-internal: `CommitmentRecord.commitment()` is the one caller, reading a
        /// stored identity back exactly rather than minting a new one. `design.md` § *The form on
        /// disk*.
        init?(_ uuidString: String) {
            guard let value = UUID(uuidString: uuidString) else {
                return nil
            }
            self.value = value
        }

        /// This identity, written as its UUID string — the one way it is ever put on disk.
        /// Package-internal, on the same footing as `init?(_:)`.
        var uuidString: String { value.uuidString }
    }

    public let identity: Identity
    public let name: String
    let schedule: Schedule
    let keptFrom: CalendarDate
    public let kind: Kind

    public init?(name: String, schedule: Schedule, keptFrom: CalendarDate, kind: Kind = .tick) {
        guard !Blank.saysNothing(name) else {
            return nil
        }

        self.identity = Identity()
        self.name = name
        self.schedule = schedule
        self.keptFrom = keptFrom
        self.kind = kind
    }

    /// Forms a further era of `of` — the same commitment, carrying its identity and its name,
    /// on a different schedule, day kept from and kind. `openspec/changes/
    /// give-a-commitment-an-identity/design.md` § *Equality is the identity, and an era is an
    /// entry*.
    public init?(era of: Commitment, schedule: Schedule, keptFrom: CalendarDate, kind: Kind) {
        self.identity = of.identity
        self.name = of.name
        self.schedule = schedule
        self.keptFrom = keptFrom
        self.kind = kind
    }

    /// Re-forms a commitment carrying `identity` already given, rather than minting a new one —
    /// for a store reading one back exactly as it was written. Package-internal:
    /// `CommitmentRecord.commitment()` is the one caller. `design.md` § *The form on disk*.
    init?(identity: Identity, name: String, schedule: Schedule, keptFrom: CalendarDate, kind: Kind)
    {
        guard !Blank.saysNothing(name) else {
            return nil
        }

        self.identity = identity
        self.name = name
        self.schedule = schedule
        self.keptFrom = keptFrom
        self.kind = kind
    }

    /// Forms `of`, renamed to `name` — the same identity, schedule, day kept from and kind.
    /// Package-internal: `Roster.rename(_:to:)` is the one caller, writing a new name across
    /// every era without disturbing anything else about it.
    init(renaming of: Commitment, to name: String) {
        self.identity = of.identity
        self.name = name
        self.schedule = of.schedule
        self.keptFrom = of.keptFrom
        self.kind = of.kind
    }

    public func isDue(on date: CalendarDate) -> Bool {
        guard keptFrom.days(until: date) >= 0 else {
            return false
        }

        return schedule.isDue(on: date)
    }

    /// The rhythm this commitment runs on, in words. See
    /// `docs/adr/1034-a-schedule-says-its-rhythm-in-words.md`.
    public var rhythmInWords: String { schedule.inWords }
}

extension Commitment: Hashable {
    /// Two commitments are the same commitment exactly when their identities are the same,
    /// whatever their names, schedules, days kept from and kinds — `openspec/changes/
    /// give-a-commitment-an-identity/specs/commitment/spec.md` § *A commitment is an identity, a
    /// name, a schedule, the day it is kept from and the kind its days take*.
    public static func == (lhs: Commitment, rhs: Commitment) -> Bool {
        lhs.identity == rhs.identity
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identity)
    }
}
