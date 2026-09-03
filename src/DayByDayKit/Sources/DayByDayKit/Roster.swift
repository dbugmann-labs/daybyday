public struct Roster: Hashable, Sendable {
    /// A commitment this roster holds, and the day it was kept until when this roster has
    /// stopped keeping it. `keptUntil` is `nil` for a commitment this roster has not stopped
    /// keeping.
    private struct Entry: Hashable, Sendable {
        let commitment: Commitment
        let keptUntil: CalendarDate?
    }

    private var entries: [Entry]

    /// A roster holding no commitments.
    public init() {
        entries = []
    }

    /// The commitments this roster keeps, in the order they were taken on. A commitment it has
    /// stopped keeping is not among them.
    public var commitments: [Commitment] {
        entries.compactMap { $0.keptUntil == nil ? $0.commitment : nil }
    }

    /// Adds `commitment` after every commitment already held, and answers `true`. When this
    /// roster holds it stopped, takes it up again in the place it has — clearing the day it was
    /// kept until — and answers `true`. Answers `false` and changes nothing when this roster is
    /// already keeping it.
    public mutating func add(_ commitment: Commitment) -> Bool {
        if let index = entries.firstIndex(where: { $0.commitment == commitment }) {
            guard entries[index].keptUntil != nil else {
                return false
            }

            entries[index] = Entry(commitment: commitment, keptUntil: nil)
            return true
        }

        entries.append(Entry(commitment: commitment, keptUntil: nil))
        return true
    }

    /// Stops keeping `commitment` as of `date`, the last day it was kept, and answers `true`.
    /// Answers `false` and changes nothing when this roster does not hold it, or has already
    /// stopped keeping it.
    public mutating func retire(_ commitment: Commitment, keptUntil date: CalendarDate) -> Bool {
        guard let index = entries.firstIndex(where: { $0.commitment == commitment }) else {
            return false
        }

        guard entries[index].keptUntil == nil else {
            return false
        }

        entries[index] = Entry(commitment: commitment, keptUntil: date)
        return true
    }

    /// The commitments this roster had not stopped keeping on `date`, in the order they were
    /// taken on. It applies no other rule: a commitment's own day it is kept from and its
    /// schedule are the commitment's answer, not the roster's.
    public func commitments(on date: CalendarDate) -> [Commitment] {
        fatalError("not implemented")
    }
}
