public struct Roster: Hashable, Sendable {
    /// A commitment this roster holds, and the day it was kept until when this roster has
    /// stopped keeping it. `keptUntil` is `nil` for a commitment this roster has not stopped
    /// keeping.
    struct Entry: Hashable, Sendable {
        let commitment: Commitment
        let keptUntil: CalendarDate?
        let category: String?
    }

    var entries: [Entry]

    /// Whether deleting left this roster holding nothing. `false` for a roster given no
    /// commitment at all — the two are not the same roster. Set by `delete` when the last entry
    /// goes, cleared by any `add`. `design.md` § *Emptied is a mark on the roster, not the file's
    /// absence*.
    var emptied: Bool

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
        emptied = false
    }

    /// The commitments this roster keeps, in the order it holds them. A commitment it has
    /// stopped keeping is not among them. An earlier era is never among them either: every era
    /// but a commitment's newest carries a kept-until day of its own, the day it gave way to the
    /// one in front of it, so this needs no clause of its own to leave earlier eras out.
    public var commitments: [Commitment] {
        entries.compactMap { $0.keptUntil == nil ? $0.commitment : nil }
    }

    /// The commitments this roster has stopped keeping, in the order it holds them — each read
    /// back at its newest era. An earlier era of a stopped commitment is in neither this list nor
    /// `commitments`: unlike `commitments`, which an earlier era's own kept-until day already
    /// excludes, an earlier era of an actively-kept commitment also carries one, so this walks
    /// each identity once and asks only its first — its newest — era. A deleted commitment holds
    /// no entry at all, so it is in neither list without a clause of its own.
    /// `openspec/changes/give-a-commitment-an-identity/design.md` § *Equality is the identity,
    /// and an era is an entry*.
    public var stopped: [Commitment] {
        var seenIdentities: Set<Commitment.Identity> = []
        var result: [Commitment] = []
        for entry in entries {
            guard seenIdentities.insert(entry.commitment.identity).inserted else {
                continue
            }
            if entry.keptUntil != nil {
                result.append(entry.commitment)
            }
        }
        return result
    }

    /// Every era of the commitment `commitment` identifies, newest first — the order this roster
    /// already holds a commitment's eras in. Empty where this roster does not hold that identity
    /// at all. `design.md` § *The seam*.
    public func eras(of commitment: Commitment) -> [Commitment] {
        entries.filter { $0.commitment.identity == commitment.identity }.map(\.commitment)
    }

    /// The day the commitment `commitment` identifies is kept from — its earliest era's, the
    /// last in `eras(of:)` — or `nil` where this roster does not hold that identity at all.
    public func keptFrom(of commitment: Commitment) -> CalendarDate? {
        eras(of: commitment).last?.keptFrom
    }

    /// The earliest calendar date any commitment this roster holds is kept from, or `nil` where
    /// it holds none at all. `openspec/changes/add-day-picker/design.md` § *The seam*.
    public var earliestKeptFrom: CalendarDate? {
        entries.map(\.commitment.keptFrom).min { $0.days(until: $1) > 0 }
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
    /// every commitment already held, and answers `true`. When this roster holds it stopped,
    /// takes it up again in the place it has, putting it under `category` whatever
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
    /// Refuses wherever `commitment`'s name is already held by a kept or a stopped commitment
    /// other than itself — `nameIsHeldByAnother(_:notIdentity:)` — whether this is a brand-new
    /// commitment or one taken up again by identity; a name a roster has deleted a commitment
    /// under, and a name only an earlier era carries, are both free, because that check already
    /// reads `commitments` and `stopped` alone. A successful add or take-up-again clears
    /// `emptied`: this roster is never both emptied and holding something.
    /// `openspec/changes/give-a-commitment-an-identity/specs/commitment/spec.md` § *A roster
    /// refuses a commitment whose name one it keeps or has stopped already has*.
    private mutating func addTakingUpAgain(
        _ commitment: Commitment, category: (String?) -> String?
    ) -> Bool {
        guard !nameIsHeldByAnother(commitment.name, notIdentity: commitment.identity) else {
            return false
        }

        if let index = entries.firstIndex(where: { $0.commitment.identity == commitment.identity })
        {
            guard entries[index].keptUntil != nil else {
                return false
            }

            entries[index] = Entry(
                commitment: entries[index].commitment, keptUntil: nil,
                category: category(entries[index].category))
            emptied = false
            return true
        }

        entries.append(
            Entry(commitment: commitment, keptUntil: nil, category: category(nil)))
        emptied = false
        return true
    }

    /// Whether `name` — compared as two names are compared throughout this type: the same but
    /// for the case of a letter or blank space at either end — already belongs to a commitment
    /// this roster keeps or has stopped keeping, other than the one `identity` names. A
    /// commitment this roster has deleted holds no name against one offered, and neither does an
    /// earlier era beyond the name its own commitment carries: `commitments` and `stopped` each
    /// already answer one commitment per identity, at its newest era alone.
    private func nameIsHeldByAnother(_ name: String, notIdentity identity: Commitment.Identity)
        -> Bool
    {
        (commitments + stopped).contains {
            $0.identity != identity && Self.sameName($0.name, name)
        }
    }

    /// Whether `lhs` and `rhs` are one name for the roster's name refusal: the same but for the
    /// case of a letter, or for blank space at the start or the end of either — every other
    /// difference, blank space inside a name included, makes two names. `Blank.trimmed` is the
    /// one place this package trims blank space from a name; `docs/adr/1039-blank-is-one-test
    /// -asked-in-one-place.md`.
    private static func sameName(_ lhs: String, _ rhs: String) -> Bool {
        Blank.trimmed(lhs).lowercased() == Blank.trimmed(rhs).lowercased()
    }

    /// Renames `commitment` to `name`, writing it on every era of it, and answers `true`. Each
    /// era's schedule, day kept from, kind and day kept until, the commitment's identity, its
    /// state, its category and its place in the roster's order are left exactly as they were.
    /// Refuses, leaving this roster exactly as it was, where it does not hold `commitment` at
    /// all, and where `name` is already held by another commitment it keeps or has stopped
    /// keeping — `nameIsHeldByAnother(_:notIdentity:)`, which already reads `commitments` and
    /// `stopped` alone, so a name only a deleted commitment held is free. Renaming a commitment
    /// to the name it already has is not refused: `nameIsHeldByAnother` excludes `commitment`'s
    /// own identity, so this never trips on itself. `openspec/changes/
    /// give-a-commitment-an-identity/design.md` § *The seam*.
    @discardableResult
    public mutating func rename(_ commitment: Commitment, to name: String) -> Bool {
        guard entries.contains(where: { $0.commitment.identity == commitment.identity }) else {
            return false
        }

        guard !nameIsHeldByAnother(name, notIdentity: commitment.identity) else {
            return false
        }

        for index in entries.indices
        where entries[index].commitment.identity == commitment.identity {
            entries[index] = Entry(
                commitment: Commitment(renaming: entries[index].commitment, to: name),
                keptUntil: entries[index].keptUntil, category: entries[index].category)
        }
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
            commitment: entries[index].commitment, keptUntil: date,
            category: entries[index].category)
        return true
    }

    /// Deletes `commitment` — every era of it — and answers `true`, whatever state this roster
    /// holds it in, kept or stopped. The roster answers with it on no date afterwards, and every
    /// other commitment is left exactly as it was, in the order it was in. A roster this leaves
    /// holding no commitment at all becomes `emptied`. Answers `false` and changes nothing when
    /// this roster does not hold `commitment` — one it does not hold at all, one already deleted
    /// included.
    public mutating func delete(_ commitment: Commitment) -> Bool {
        guard entries.contains(where: { $0.commitment.identity == commitment.identity }) else {
            return false
        }

        entries.removeAll { $0.commitment.identity == commitment.identity }
        if entries.isEmpty {
            emptied = true
        }
        return true
    }

    /// Puts `commitment`, which this roster is keeping, under `category`, or under none where
    /// `category` is `nil` or holds nothing but blank space, and answers `true`. Every other
    /// category is kept exactly as given — no trimming, no folding of case. Changes nothing else
    /// about this roster: not the commitment, not its state, not its place in the order. Answers
    /// `false` and changes nothing when this roster is not currently keeping `commitment` — one
    /// it does not hold at all, one it has stopped keeping, or one it has deleted.
    public mutating func put(_ commitment: Commitment, under category: String?) -> Bool {
        guard let index = entries.firstIndex(where: { $0.commitment == commitment }),
            entries[index].keptUntil == nil
        else {
            return false
        }

        entries[index] = Entry(
            commitment: entries[index].commitment, keptUntil: entries[index].keptUntil,
            category: Self.normalized(category))
        return true
    }

    /// Puts `era` on `commitment`, which this roster is keeping, as of `date` — the day the era
    /// it gives way to was kept until — under `category`, or under none where `category` is
    /// `nil` or holds nothing but blank space, and answers `true`. `era` takes the place
    /// `commitment` held and becomes its newest era; the era it gives way to carries `date` as
    /// the day it was kept until and sits immediately behind it, holding the category
    /// `commitment` had — and the whole identity is then mended, `mended(_:)`: every era it
    /// leaves holding no day is dropped, the one it reaches behind is cut to the day before, and
    /// an era alike the new one joins it. Any date is accepted, including one earlier than the
    /// day the era it gives way to is kept from, which the mend then drops. Answers `false` and
    /// changes nothing when this roster is not currently keeping `commitment` — one it does not
    /// hold at all, one it has stopped keeping, or one it has deleted — or when `era` does not
    /// carry `commitment`'s identity, its name, or the sort of its kind.
    /// `openspec/changes/collapse-a-same-day-rhythm-change/specs/commitment/spec.md` § *A roster
    /// puts a new era on a commitment it is keeping, from a day, and keeps no era holding no
    /// day*.
    @discardableResult
    public mutating func put(
        era: Commitment, on commitment: Commitment, keptUntil date: CalendarDate,
        under category: String?
    ) -> Bool {
        guard
            let index = entries.firstIndex(where: { $0.commitment.identity == commitment.identity }
            ), entries[index].keptUntil == nil
        else {
            return false
        }

        guard era.identity == commitment.identity, era.name == commitment.name,
            era.kind.isOfTheSameSort(as: commitment.kind)
        else {
            return false
        }

        let precedingEntry = Entry(
            commitment: entries[index].commitment, keptUntil: date,
            category: entries[index].category)
        entries[index] = Entry(
            commitment: era, keptUntil: nil, category: Self.normalized(category))
        entries.insert(precedingEntry, at: index + 1)

        let runLength = entries[index...].prefix { $0.commitment.identity == commitment.identity }.count
        entries.replaceSubrange(
            index..<(index + runLength), with: Self.mended(Array(entries[index..<(index + runLength)])))

        return true
    }

    /// Mends one identity's eras, `entries` — already gathered, adjacent and newest first, the
    /// newest's own `keptUntil` never touched — as both `put(era:on:keptUntil:under:)` and every
    /// reader run it, `design.md` § *One mend, run by the put and by the reader*: each era but
    /// the newest is cut to the day before the era in front of it (in the mended result, not
    /// necessarily the one in front of it here) is kept from, carrying whatever day kept until it
    /// already had where that is earlier; an era that then holds no day is dropped, the newest
    /// never among them; and two eras left standing side by side alike in schedule and in kind —
    /// range or target included — join into one, kept from the older's day and carrying the
    /// newer's day kept until, state and category. Package-internal: `RosterDocument.formRoster()`
    /// and `RosterDocument.folded()` are the two readers that call this, once per identity, before
    /// either answers.
    static func mended(_ entries: [Entry]) -> [Entry] {
        guard var front = entries.first else {
            return entries
        }
        var result = [front]

        for entry in entries.dropFirst() {
            guard let dayBeforeFront = front.commitment.keptFrom.adding(days: -1) else {
                // The front era's own day kept from is the calendar's first supported date: no
                // day exists before it, so nothing behind it can hold one either.
                continue
            }
            let keptUntil = entry.keptUntil.map { Self.earlier($0, dayBeforeFront) } ?? dayBeforeFront
            guard entry.commitment.keptFrom.days(until: keptUntil) >= 0 else {
                // Holds no day once cut: dropped, and the front stands unchanged for whatever
                // comes next.
                continue
            }

            let cut = Entry(commitment: entry.commitment, keptUntil: keptUntil, category: entry.category)
            if front.commitment.schedule == cut.commitment.schedule,
                front.commitment.kind == cut.commitment.kind
            {
                let joined = Entry(
                    commitment: Commitment(
                        era: front.commitment, schedule: front.commitment.schedule,
                        keptFrom: cut.commitment.keptFrom, kind: front.commitment.kind)!,
                    keptUntil: front.keptUntil, category: front.category)
                result[result.count - 1] = joined
                front = joined
            } else {
                result.append(cut)
                front = cut
            }
        }

        return result
    }

    /// The earlier of `lhs` and `rhs` — the one `mended(_:)` needs to cut a day kept until down
    /// to whichever bound is tighter, never widening one already narrower than the fresh cut.
    private static func earlier(_ lhs: CalendarDate, _ rhs: CalendarDate) -> CalendarDate {
        lhs.days(until: rhs) < 0 ? rhs : lhs
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
    /// when `offset` is the number kept; a stopped commitment lying between is passed rather
    /// than pushed. Both paths answer `true` and report that the roster moved `commitment`.
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
        // the sequence moves, and a stopped commitment lying between the two is not passed
        // because nothing goes by it. Checking this before touching `entries` is what keeps that
        // true: computing a destination from a post-removal index, as the general case below
        // does, would walk the moved commitment past exactly such a commitment. The category is
        // still applied here — a carve-out is about the sequence, not the category.
        guard offset != sourceKeptIndex, offset != sourceKeptIndex + 1 else {
            entries[sourceIndex] = Entry(
                commitment: entries[sourceIndex].commitment,
                keptUntil: entries[sourceIndex].keptUntil, category: normalized)
            return true
        }

        var entry = entries.remove(at: sourceIndex)
        entry = Entry(commitment: entry.commitment, keptUntil: entry.keptUntil, category: normalized)

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

    /// Moves the **group** named by `category` to `offset`, a place counted over the groups this
    /// roster is keeping that are under a category, as they stand before the move, running from 0
    /// (before the first of them) to the number of them (after the last). Every commitment under
    /// `category` — kept and stopped alike — travels together as one block, keeping its
    /// order against the others that travel; every commitment that does not travel stays in the
    /// order it was in against every other commitment that does not travel. `design.md` § *A group
    /// move is a block move*, ADR-1044.
    ///
    /// `category` goes through the same `Blank` test every other category does (ADR-1039), so a
    /// category of nothing but blank space is the group under no category. Answers `false` and
    /// changes nothing when `category` — normalized — names no group this roster is keeping under
    /// a category: no category at all, one nothing it holds has ever been under, or one only a
    /// stopped commitment is under. Answers `false` and changes nothing when `offset` is
    /// below 0 or above the number of groups kept under a category; not clamped.
    ///
    /// Two offsets name the place the group already has — the one it is at among the groups kept
    /// under a category, and the one just after that — and on both nothing is taken out of
    /// `entries` and nothing in it moves. Every other offset takes every commitment under
    /// `category` out of the sequence and puts the block back immediately before the **first
    /// commitment this roster is keeping** under the category of the group that stood at `offset`,
    /// or immediately after the last commitment under the category of the last group kept under one
    /// when `offset` is the number of them — that second anchor counted over every commitment under
    /// the target category, whatever state it is in, and not only the ones this roster is keeping.
    /// The first is measured over the kept ones because the offset itself is counted over the groups
    /// a person can see; where a stopped commitment under the target lies earlier than its first
    /// kept one, the block lands after that stopped commitment, so a date before the stop reads
    /// the two groups the other way round from today. `design.md` § *Where the
    /// block is put*, ADR-1044. Both paths answer `true` and report that the roster moved the group.
    public mutating func move(group category: String?, toOffset offset: Int) -> Bool {
        guard let normalizedCategory = Self.normalized(category) else {
            return false
        }

        // The groups this roster is keeping under a category, in the order they stand before the
        // move — the same list `CommitmentsScreen.categoriesInUse` reads, `design.md` § *The
        // offset counts the headed groups*.
        var categorisedOrder: [String] = []
        for entry in entries where entry.keptUntil == nil {
            guard let entryCategory = entry.category, !categorisedOrder.contains(entryCategory)
            else { continue }
            categorisedOrder.append(entryCategory)
        }

        guard let sourceGroupIndex = categorisedOrder.firstIndex(of: normalizedCategory) else {
            return false
        }

        guard (0...categorisedOrder.count).contains(offset) else {
            return false
        }

        // Offset `sourceGroupIndex` names the moved group itself, and offset
        // `sourceGroupIndex + 1` names the group that already follows it among the ones kept under
        // a category — or, where the moved group is the last of them, is the number of them,
        // again where it already stands. Neither asks a kept group to stand anywhere new, so
        // nothing in the sequence moves — the carve-out that keeps a scattered group from being
        // gathered by a no-op, `design.md` § *The two offsets that gather nothing*.
        guard offset != sourceGroupIndex, offset != sourceGroupIndex + 1 else {
            return true
        }

        var moving: [Entry] = []
        var remaining: [Entry] = []
        for entry in entries {
            if entry.category == normalizedCategory {
                moving.append(entry)
            } else {
                remaining.append(entry)
            }
        }

        // `offset == categorisedOrder.count` means "after the last of them"; every other offset
        // names the group that stood there before the move, before whose first **kept**
        // commitment the block is put back — the offset is counted over the groups a person can
        // see, `design.md` § *Where the block is put*. Neither lookup can miss: the guard above
        // ruled out `offset == sourceGroupIndex` and `offset == sourceGroupIndex + 1`, so
        // `targetCategory` is never `normalizedCategory`, and `remaining` still holds every
        // commitment under it — kept and stopped alike — with at least one kept, because
        // being in `categorisedOrder` is exactly what having one means.
        let targetCategory =
            offset == categorisedOrder.count ? categorisedOrder.last! : categorisedOrder[offset]

        if offset == categorisedOrder.count {
            let lastUnderTarget = remaining.lastIndex(where: { $0.category == targetCategory })!
            remaining.insert(contentsOf: moving, at: lastUnderTarget + 1)
        } else {
            let firstKeptUnderTarget = remaining.firstIndex(where: {
                $0.category == targetCategory && $0.keptUntil == nil
            })!
            remaining.insert(contentsOf: moving, at: firstKeptUnderTarget)
        }

        entries = remaining
        return true
    }

    /// Changes `era` for `changed`, in the place `era` held, under `category` — or under none
    /// where `category` is `nil` or holds nothing but blank space — and answers `true`. The day
    /// `era` was kept until and the state of its commitment are left exactly as they were, and
    /// nothing else this roster holds moves; asked to change `era` for a value alike to it in
    /// every part, this roster is left exactly as it was but for the category offered, and still
    /// answers `true` — no branch of its own, because that case already satisfies every guard
    /// below and takes the same path. Answers `false` and changes nothing when this roster does
    /// not hold `era` at all — matched on its identity, its schedule, its day kept from and its
    /// kind, because two eras of one commitment share an identity `==` alone cannot tell apart —
    /// or when `changed` does not carry `era`'s identity, its name, or the sort of its kind.
    /// `openspec/changes/give-a-commitment-an-identity/specs/commitment/spec.md` § *A roster
    /// changes an era of a commitment it holds for another of that commitment*.
    @discardableResult
    public mutating func change(
        _ era: Commitment, to changed: Commitment, under category: String?
    ) -> Bool {
        guard
            let index = entries.firstIndex(where: {
                $0.commitment.identity == era.identity && $0.commitment.schedule == era.schedule
                    && $0.commitment.keptFrom == era.keptFrom && $0.commitment.kind == era.kind
            })
        else {
            return false
        }

        guard changed.identity == era.identity, changed.name == era.name,
            changed.kind.isOfTheSameSort(as: era.kind)
        else {
            return false
        }

        entries[index] = Entry(
            commitment: changed, keptUntil: entries[index].keptUntil,
            category: Self.normalized(category))
        return true
    }

    /// The commitments this roster had not stopped keeping on `date`, in the order it holds
    /// them. It applies no other rule: a commitment's own day it is kept from and its
    /// schedule are the commitment's answer, not the roster's. A deleted commitment holds no
    /// entry at all, so it never answers on any date without a clause of its own.
    public func commitments(on date: CalendarDate) -> [Commitment] {
        entries.compactMap { entry in
            guard let keptUntil = entry.keptUntil else {
                return entry.commitment
            }

            return date.days(until: keptUntil) >= 0 ? entry.commitment : nil
        }
    }
}
