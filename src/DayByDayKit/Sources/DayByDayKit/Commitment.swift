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

    /// An amount a total commitment offers to add in one tap, with the name a person gave it or
    /// none. `openspec/changes/add-usual-amounts/design.md` § *The seam*.
    public struct UsualAmount: Hashable, Sendable {
        public let amount: Decimal
        public let name: String?

        public init?(_ amount: Decimal, named name: String?) {
            guard amount > 0 else {
                return nil
            }

            self.amount = amount
            self.name = name.flatMap { Blank.saysNothing($0) ? nil : $0 }
        }
    }

    public let identity: Identity
    public let name: String
    let schedule: Schedule
    let keptFrom: CalendarDate
    public let kind: Kind

    /// The shifts made of this commitment's due days, each from the day a shift took a due day
    /// from to the day it is on, written alike on every era of it. Empty where none has been made.
    /// Equality ignores it, as it ignores every part but the identity; nothing may decide to
    /// write, redraw or carry by comparing two commitments. `docs/adr/1066-a-shift-is-part-of-
    /// the-commitment.md`.
    let shifts: [CalendarDate: CalendarDate]

    public init?(name: String, schedule: Schedule, keptFrom: CalendarDate, kind: Kind = .tick) {
        guard !Blank.saysNothing(name) else {
            return nil
        }

        self.identity = Identity()
        self.name = name
        self.schedule = schedule
        self.keptFrom = keptFrom
        self.kind = kind
        self.shifts = [:]
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
        self.shifts = of.shifts
    }

    /// Re-forms a commitment carrying `identity` already given, rather than minting a new one —
    /// for a store reading one back exactly as it was written. Package-internal:
    /// `CommitmentRecord.commitment()` is the one caller. `design.md` § *The form on disk*.
    init?(
        identity: Identity, name: String, schedule: Schedule, keptFrom: CalendarDate, kind: Kind,
        shifts: [CalendarDate: CalendarDate] = [:]
    ) {
        guard !Blank.saysNothing(name) else {
            return nil
        }

        self.identity = identity
        self.name = name
        self.schedule = schedule
        self.keptFrom = keptFrom
        self.kind = kind
        self.shifts = shifts
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
        self.shifts = of.shifts
    }

    /// Forms `of` carrying `shifts` in place of the ones it carries — every other part as it was.
    /// Package-internal: `Roster.shift(_:from:to:)` writes a shift on every era of an identity
    /// through it, and a reader gives a stored commitment the shifts its document keeps.
    init(_ of: Commitment, shifts: [CalendarDate: CalendarDate]) {
        self.identity = of.identity
        self.name = of.name
        self.schedule = of.schedule
        self.keptFrom = of.keptFrom
        self.kind = of.kind
        self.shifts = shifts
    }

    /// Whether a shift took a due day of this era's commitment from `date`, a day it is kept from.
    func tookDueDay(from date: CalendarDate) -> Bool {
        keptFrom.days(until: date) >= 0 && shifts[date] != nil
    }

    public func isDue(on date: CalendarDate) -> Bool {
        guard keptFrom.days(until: date) >= 0 else {
            return false
        }

        if shifts[date] != nil {
            return false
        }
        if shifts.values.contains(date) {
            return true
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
