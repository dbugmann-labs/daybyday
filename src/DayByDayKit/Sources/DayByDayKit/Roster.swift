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
        let category: String?
    }

    var entries: [Entry]

    /// A category, or no category at all, together with the commitments under it in the order
    /// the roster holds them. `design.md` § *The seam*.
    public struct Group: Hashable, Sendable {
        public let category: String?
        public let commitments: [Commitment]

        public init(category: String?, commitments: [Commitment]) {
            self.category = category
            self.commitments = commitments
        }
    }

    /// A roster holding no commitments.
    public init() {
        entries = []
    }

    /// The commitments this roster keeps, in the order it holds them. A commitment it has
    /// stopped keeping is not among them.
    public var commitments: [Commitment] {
        entries.compactMap { $0.keptUntil == nil ? $0.commitment : nil }
    }

    /// The commitments this roster keeps, in **groups**: a group is a category, or no category
    /// at all, together with the commitments under it, in the order this roster holds them. A
    /// group sits where its first commitment sits, walking the commitments in this roster's own
    /// order; the group of the commitments under no category comes last, wherever the first of
    /// them sits, and is absent where every commitment is under a category. A roster keeping
    /// nothing reads back no groups at all rather than one empty group.
    public var groups: [Group] {
        Self.grouped(entries.compactMap { $0.keptUntil == nil ? $0 : nil })
    }

    /// The groups this roster answers about `date` — the commitments it had not stopped keeping
    /// on that date, each under the category it is under.
    public func groups(on date: CalendarDate) -> [Group] {
        Self.grouped(
            entries.filter { entry in
                guard let keptUntil = entry.keptUntil else { return true }
                return date.days(until: keptUntil) >= 0
            })
    }

    /// Groups `entries`, in the order they are given, by category — a group sits where its
    /// first entry sits, and the group of the commitments under no category comes last.
    private static func grouped(_ entries: [Entry]) -> [Group] {
        var categorisedOrder: [String] = []
        var byCategory: [String: [Commitment]] = [:]
        var uncategorised: [Commitment] = []

        for entry in entries {
            guard let category = entry.category else {
                uncategorised.append(entry.commitment)
                continue
            }

            if byCategory[category] == nil {
                byCategory[category] = []
                categorisedOrder.append(category)
            }
            byCategory[category]!.append(entry.commitment)
        }

        var groups = categorisedOrder.map { Group(category: $0, commitments: byCategory[$0]!) }
        if !uncategorised.isEmpty {
            groups.append(Group(category: nil, commitments: uncategorised))
        }
        return groups
    }

    /// Adds `commitment` after every commitment already held, and answers `true`. When this
    /// roster holds it stopped, takes it up again in the place it has — clearing the day it was
    /// kept until — and answers `true`. Answers `false` and changes nothing when this roster is
    /// already keeping it.
    public mutating func add(_ commitment: Commitment) -> Bool {
        addWithNoCategorySaid(commitment)
    }

    /// Adds `commitment` under `category` — or under none where `category` is `nil` — after
    /// every commitment already held, and answers `true`. When this roster holds it stopped or
    /// removed, takes it up again in the place it has, putting it under `category` whatever
    /// category it was under before. Answers `false` and changes nothing when this roster is
    /// already keeping it. `design.md` § *A commitment is offered with a category or without
    /// one*: this is the form used by something that has a category to say, and it always wins.
    public mutating func add(_ commitment: Commitment, under category: String?) -> Bool {
        let normalized = Self.normalized(category)
        return addTakingUpAgain(commitment, category: { _ in normalized })
    }

    /// `category` with nothing but blank space, or nothing at all, normalized to `nil` — "under
    /// none" — and every other category kept exactly as given. `Blank` is the one test this
    /// package uses to decide whether a text says anything; `docs/adr/1039-blank-is-one-test
    /// -asked-in-one-place.md`.
    private static func normalized(_ category: String?) -> String? {
        category.flatMap {
            Blank.saysNothing($0) ? nil : $0
        }
    }

    /// The one-argument form of the offer: something with nothing to say about categories,
    /// which leaves the category a commitment is under exactly as it is — none for a commitment
    /// not held at all, whatever it already was for one taken up again.
    private mutating func addWithNoCategorySaid(_ commitment: Commitment) -> Bool {
        addTakingUpAgain(commitment, category: { existing in existing })
    }

    /// The shared act behind both forms of the offer: `category` is asked what to put the
    /// commitment under, given the category it already holds (`nil` for one not held at all).
    private mutating func addTakingUpAgain(
        _ commitment: Commitment, category: (String?) -> String?
    ) -> Bool {
        if let index = entries.firstIndex(where: { $0.commitment == commitment }) {
            guard entries[index].keptUntil != nil else {
                return false
            }

            entries[index] = Entry(
                commitment: entries[index].commitment, keptUntil: nil, isRemoved: false,
                category: category(entries[index].category))
            return true
        }

        entries.append(
            Entry(
                commitment: commitment, keptUntil: nil, isRemoved: false, category: category(nil)))
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
            commitment: entries[index].commitment, keptUntil: date, isRemoved: false,
            category: entries[index].category)
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
            commitment: entries[index].commitment, keptUntil: keptUntil, isRemoved: true,
            category: entries[index].category)
        return true
    }

    /// Puts `commitment`, which this roster is keeping, under `category`, or under none where
    /// `category` is `nil` or holds nothing but blank space, and answers `true`. Every other
    /// category is kept exactly as given — no trimming, no folding of case. Changes nothing else
    /// about this roster: not the commitment, not its state, not its place in the order. Answers
    /// `false` and changes nothing when this roster is not currently keeping `commitment` — one
    /// it does not hold at all, one it has stopped keeping, or one it has removed.
    public mutating func put(_ commitment: Commitment, under category: String?) -> Bool {
        guard let index = entries.firstIndex(where: { $0.commitment == commitment }),
            entries[index].keptUntil == nil
        else {
            return false
        }

        entries[index] = Entry(
            commitment: entries[index].commitment, keptUntil: entries[index].keptUntil,
            isRemoved: entries[index].isRemoved, category: Self.normalized(category))
        return true
    }

    /// Moves `commitment` to `offset`, a place counted over the commitments this roster is
    /// keeping as they stand before the move, running from 0 (before the first of them) to the
    /// number it is keeping (after the last), and puts it under `category` — or under none where
    /// `category` is `nil` or holds nothing but blank space. Answers `false` and changes nothing
    /// when this roster is not keeping `commitment`, or when `offset` is below 0 or above the
    /// number of commitments kept.
    ///
    /// Two offsets name the place `commitment` already has — the one it is at among the kept
    /// ones, and the one just after that, naming whichever kept commitment already follows it
    /// (or, when it is the last kept, the number kept) — and on both, nothing is taken out of
    /// `entries` and nothing in it moves, though `category` is still applied. Every other offset
    /// takes `commitment` out of the sequence and puts it back immediately before whichever
    /// commitment stood at `offset` among the kept ones before the move, or after all of them
    /// when `offset` is the number kept; a stopped or removed commitment lying between is passed
    /// rather than pushed. Both paths answer `true` and report that the roster moved
    /// `commitment`.
    public mutating func move(_ commitment: Commitment, toOffset offset: Int, under category: String?)
        -> Bool
    {
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
        let normalized = Self.normalized(category)

        // Offset `sourceKeptIndex` names the moved commitment itself, and offset
        // `sourceKeptIndex + 1` names the commitment that already follows it among the ones kept
        // — or, where the moved commitment is the last one kept, is the number kept, again where
        // it already stands. Neither asks a kept commitment to stand anywhere new, so nothing in
        // the sequence moves, and a stopped or removed commitment lying between the two is not
        // passed because nothing goes by it. Checking this before touching `entries` is what
        // keeps that true: computing a destination from a post-removal index, as the general case
        // below does, would walk the moved commitment past exactly such a commitment. The
        // category is still applied here — a carve-out is about the sequence, not the category.
        guard offset != sourceKeptIndex, offset != sourceKeptIndex + 1 else {
            entries[sourceIndex] = Entry(
                commitment: entries[sourceIndex].commitment,
                keptUntil: entries[sourceIndex].keptUntil,
                isRemoved: entries[sourceIndex].isRemoved, category: normalized)
            return true
        }

        var entry = entries.remove(at: sourceIndex)
        entry = Entry(
            commitment: entry.commitment, keptUntil: entry.keptUntil, isRemoved: entry.isRemoved,
            category: normalized)

        // `offset == keptBeforeMove.count` means "after the last of them"; every other offset
        // names the commitment that stood there before the move, before which the moved
        // commitment is put back. Neither lookup can miss, and not for the same reason.
        // `keptBeforeMove.last!` cannot trap because `keptBeforeMove` always holds the moved
        // commitment itself, so it is never empty. `entries.firstIndex(...)!` cannot trap
        // because the guard above ruled out `offset == sourceKeptIndex` and `offset ==
        // sourceKeptIndex + 1`, so `target` is never the commitment just removed, and every
        // other member of `keptBeforeMove` is still in `entries` after that one removal.
        let target = offset == keptBeforeMove.count ? keptBeforeMove.last! : keptBeforeMove[offset]
        let targetIndex = entries.firstIndex(where: { $0.commitment == target.commitment })!
        let destination = offset == keptBeforeMove.count ? targetIndex + 1 : targetIndex
        entries.insert(entry, at: destination)

        return true
    }

    /// The commitments this roster had not stopped keeping on `date`, in the order it holds
    /// them. It applies no other rule: a commitment's own day it is kept from and its
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
