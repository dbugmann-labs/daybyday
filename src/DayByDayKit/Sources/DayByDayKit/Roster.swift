public struct Roster: Hashable, Sendable {
    /// A commitment this roster holds, and the day it was kept until when this roster has
    /// stopped keeping it. `keptUntil` is `nil` for a commitment this roster has not stopped
    /// keeping. `isRemoved` is `true` for a commitment this roster has removed — always alongside
    /// a `keptUntil` day, never on its own; `design.md` § *Removed is a third state on the entry,
    /// not a fourth part on the commitment* is why the state lives here rather than on
    /// `Commitment`.
    struct Entry: Hashable, Sendable {
        let commitment: Commitment
        let keptUntil: CalendarDate?
        let isRemoved: Bool
    }

    var entries: [Entry]

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

            entries[index] = Entry(
                commitment: entries[index].commitment, keptUntil: nil, isRemoved: false)
            return true
        }

        entries.append(Entry(commitment: commitment, keptUntil: nil, isRemoved: false))
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

        entries[index] = Entry(
            commitment: entries[index].commitment, keptUntil: date, isRemoved: false)
        return true
    }

    /// Removes `commitment` as of `date`, the last day it was kept, and answers `true`. Where
    /// this roster is still keeping it, `date` becomes the day it was kept until; where this
    /// roster has already stopped keeping it, the day it already holds stands and `date` is not
    /// used. Answers `false` and changes nothing when this roster does not hold `commitment`, or
    /// has already removed it.
    public mutating func remove(_ commitment: Commitment, keptUntil date: CalendarDate) -> Bool {
        guard let index = entries.firstIndex(where: { $0.commitment == commitment }) else {
            return false
        }

        guard !entries[index].isRemoved else {
            return false
        }

        let keptUntil = entries[index].keptUntil ?? date
        entries[index] = Entry(
            commitment: entries[index].commitment, keptUntil: keptUntil, isRemoved: true)
        return true
    }

    /// Moves `commitment` to `offset`, a place counted over the commitments this roster is
    /// keeping as they stand before the move, running from 0 (before the first of them) to the
    /// number it is keeping (after the last). Answers `true` and reorders `entries` so that
    /// `commitment` sits immediately before whichever commitment stood at `offset` among the
    /// kept ones before the move, or after all of them when `offset` is the number kept. Answers
    /// `false` and changes nothing when this roster is not keeping `commitment`, or when `offset`
    /// is below 0 or above the number of commitments kept.
    public mutating func move(_ commitment: Commitment, toOffset offset: Int) -> Bool {
        guard let sourceIndex = entries.firstIndex(where: { $0.commitment == commitment }),
            entries[sourceIndex].keptUntil == nil
        else {
            return false
        }

        let keptBeforeMove = entries.filter { $0.keptUntil == nil }
        guard (0...keptBeforeMove.count).contains(offset) else {
            return false
        }

        let sourceKeptIndex = keptBeforeMove.firstIndex(where: { $0.commitment == commitment })!

        // Offset `sourceKeptIndex` names the moved commitment itself, and offset
        // `sourceKeptIndex + 1` names the commitment that already follows it among the ones kept
        // — or, where the moved commitment is the last one kept, is the number kept, again where
        // it already stands. Neither asks a kept commitment to stand anywhere new, so nothing in
        // the sequence moves, and a stopped or removed commitment lying between the two is not
        // passed because nothing goes by it. Checking this before touching `entries` is what
        // keeps that true: computing a destination from a post-removal index, as the general case
        // below does, would walk the moved commitment past exactly such a commitment.
        guard offset != sourceKeptIndex, offset != sourceKeptIndex + 1 else {
            return true
        }

        let entry = entries.remove(at: sourceIndex)

        // `offset == keptBeforeMove.count` means "after the last of them"; every other offset
        // names the commitment that stood there before the move, before which the moved
        // commitment is put back.
        let target = offset == keptBeforeMove.count ? keptBeforeMove.last : keptBeforeMove[offset]
        if let target,
            let targetIndex = entries.firstIndex(where: { $0.commitment == target.commitment })
        {
            let destination = offset == keptBeforeMove.count ? targetIndex + 1 : targetIndex
            entries.insert(entry, at: destination)
        } else {
            entries.insert(entry, at: sourceIndex)
        }

        return true
    }

    /// The commitments this roster had not stopped keeping on `date`, in the order they were
    /// taken on. It applies no other rule: a commitment's own day it is kept from and its
    /// schedule are the commitment's answer, not the roster's. A removed commitment answers
    /// exactly as a stopped one does — invisible to removal is the whole point.
    public func commitments(on date: CalendarDate) -> [Commitment] {
        entries.compactMap { entry in
            guard let keptUntil = entry.keptUntil else {
                return entry.commitment
            }

            return date.days(until: keptUntil) >= 0 ? entry.commitment : nil
        }
    }
}
