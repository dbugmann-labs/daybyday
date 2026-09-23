import Foundation

/// The versioned form a `RosterStore` writes to and reads from disk. `design.md` § *The form on
/// disk* fixes the shape below by hand, in the roster's own words, rather than deriving `Codable`
/// on the engine types: the file's shape is a contract independent of how `Roster` and
/// `Commitment` happen to be laid out in Swift.
///
/// The array is in the roster's own order, and is not sorted — `design.md` says why: order is
/// one of the things a roster is.
struct RosterDocument: Codable {
    /// The form this app writes. A document whose `version` is higher is a later form; `Envelope`
    /// below reads it before this whole shape is decoded, as `design.md` requires.
    static let currentVersion = 5

    /// The form a commitment record first carried an `identity` key at: forms at or after this
    /// one carry it on every entry's commitment, forms before it never do, on the same footing as
    /// `removalIntroducedInVersion` and `categoryIntroducedInVersion`. A document before this form
    /// is exactly what `folded()` reads; `formRoster()` is the path for one at or after it.
    static let identityIntroducedInVersion = 5

    /// The form `removed` was introduced at: forms at or after this one carry it on every entry,
    /// forms before it never do. Kept apart from `currentVersion` on purpose, for the reason
    /// `RecordDocument.numbersIntroducedInVersion`'s own comment gives — a fourth form would move
    /// `currentVersion` to `4` without moving this, and `RosterStore.init(at:)`'s
    /// shape-against-form guard reads against this constant precisely so raising `currentVersion`
    /// alone cannot silently change which forms are expected to carry `removed`.
    static let removalIntroducedInVersion = 3

    /// The form `category` was introduced at: forms at or after this one carry the key on every
    /// entry — `null` where the commitment is under none — and forms before it never do. Kept
    /// apart from `currentVersion` for the same reason `removalIntroducedInVersion` is.
    static let categoryIntroducedInVersion = 4

    var version: Int
    var commitments: [RosterEntryRecord]

    /// Builds the document that exactly represents `roster`, in the roster's own order.
    init(_ roster: Roster) {
        version = Self.currentVersion
        commitments = roster.entries.map { entry in
            RosterEntryRecord(
                commitment: CommitmentRecord(entry.commitment),
                keptUntil: entry.keptUntil.map(DateRecord.init),
                removed: entry.isRemoved,
                category: entry.category)
        }
    }

    /// One era's shape, everything but its identity and its name — both fixed within one
    /// identity's own adjacent run, the name by every era carrying what a rename last wrote
    /// across all of them — so two eras of one run sharing this shape are the same era written
    /// twice, `formRoster()`'s own duplicate guard.
    private struct EraShape: Hashable {
        let schedule: Schedule
        let keptFrom: CalendarDate
        let kind: Commitment.Kind

        init(_ commitment: Commitment) {
            schedule = commitment.schedule
            keptFrom = commitment.keptFrom
            kind = commitment.kind
        }
    }

    /// Re-forms `roster` by rebuilding its entries directly, in the document's own order, rather
    /// than replaying through `Roster`'s mutating methods: a document at this form already carries
    /// every invariant the engine enforces on the way in — an identity's eras adjacent and its
    /// newest era first, a name refused twice over — so this only re-validates what this app could
    /// not itself have written: a commitment that will not form, an entry held removed with no day
    /// it was kept until, the same identity's eras split apart by another identity's, and the same
    /// era — its schedule, its day kept from and its kind together — written twice within one
    /// identity's own run. Two of one identity's eras may share a day kept from without being the
    /// same era — `Roster.put(era:on:keptUntil:under:)` already accepts that, "any date is
    /// accepted", `design.md` § *A roster puts a new era on a commitment it is keeping, from a
    /// day* — so this checks the whole shape rather than the day alone. `nil` on any of those.
    /// Used at or after `identityIntroducedInVersion`; `folded()` is the one path for a document
    /// before it.
    func formRoster() -> Roster? {
        var entries: [Roster.Entry] = []
        var closedIdentities: Set<Commitment.Identity> = []
        var currentIdentity: Commitment.Identity?
        var shapesInCurrentRun: Set<EraShape> = []

        for entry in commitments {
            guard let commitment = entry.commitment.commitment() else {
                return nil
            }
            if commitment.identity != currentIdentity {
                guard !closedIdentities.contains(commitment.identity) else {
                    return nil
                }
                if let currentIdentity {
                    closedIdentities.insert(currentIdentity)
                }
                currentIdentity = commitment.identity
                shapesInCurrentRun = []
            }
            let shape = EraShape(commitment)
            guard shapesInCurrentRun.insert(shape).inserted else {
                return nil
            }

            let keptUntil: CalendarDate?
            if let keptUntilRecord = entry.keptUntil {
                guard let date = keptUntilRecord.calendarDate() else {
                    return nil
                }
                keptUntil = date
            } else {
                guard entry.removed != true else {
                    return nil
                }
                keptUntil = nil
            }

            entries.append(
                Roster.Entry(
                    commitment: commitment, keptUntil: keptUntil, isRemoved: entry.removed == true,
                    category: entry.category))
        }

        var roster = Roster()
        roster.entries = entries
        return roster
    }

    /// A roster folded from a document kept before a commitment had an identity, and the
    /// identity — or `nil` where the fold dropped it — each stored commitment record ended up
    /// under. Keyed by `CommitmentRecord.bare(_:)` of the commitment each entry formed, never by
    /// the entry's own raw wire record: a record's `kind` key absent and one naming the tick kind
    /// explicitly describe the same commitment, and `RecordStore.settle(_:)` looks a record's
    /// commitment up the same normalized way, so the two sides of a fold can never disagree over
    /// a kind the wire form leaves to be inferred. `design.md` § *The seam* and § *Migration*.
    struct Fold {
        let roster: Roster
        let identities: [CommitmentRecord: Commitment.Identity?]
    }

    /// One commitment the fold is building — either an entry this document keeps or has stopped
    /// keeping, or a removed entry that has since become its own stopped commitment — and the
    /// mutable front of its chain: `front` is the day kept from of whichever era is currently the
    /// frontmost unresolved end of it, and `frontIndex` that era's own place among `commitments`,
    /// for *the nearest in the roster's order* tie-break. `representative` carries the identity
    /// and the name every era of it shares; `Commitment(era of:)` reads nothing else from it.
    /// `headIndex` is the place, among `commitments`, of the entry this chain was made from — set
    /// once and never moved, unlike `frontIndex` — so the roster a fold answers with can stand its
    /// commitments in that order once every chain has gathered its own eras. `eras` gathers those
    /// eras as they attach, the head first, so it is already newest-first by construction; `shapes`
    /// is every era's shape gathered so far, the head's included, so an entry alike in every part
    /// with one already in this chain — the same era held twice — is caught on attach, on the same
    /// footing as `formRoster()`'s own duplicate guard for the form this app writes.
    private final class Chain {
        let representative: Commitment
        let headIndex: Int
        var front: CalendarDate
        var frontIndex: Int
        var eras: [Roster.Entry]
        var shapes: Set<EraShape>

        init(representative: Commitment, headIndex: Int, head: Roster.Entry) {
            self.representative = representative
            self.headIndex = headIndex
            self.front = representative.keptFrom
            self.frontIndex = headIndex
            self.eras = [head]
            self.shapes = [EraShape(representative)]
        }
    }

    /// Folds this document once, as `design.md` § *Migration* and *A roster store folds a roster
    /// kept before a commitment had an identity* describe — `nil` where any one entry could not be
    /// formed, or where an entry is held removed with no day it was kept until, exactly as
    /// `formRoster()` refuses those. Every entry this document keeps or has stopped keeping becomes
    /// a commitment of its own, in the state and the category it was held in. Every removed entry
    /// is then judged in the document's own order: one whose name and kind sort match a commitment
    /// already placed, and whose day kept until is the day before that commitment's current
    /// frontmost era, becomes an earlier era of it — the nearest such commitment, by that front's
    /// own place, where more than one answers. One that chains to nothing but whose name and kind
    /// sort match a commitment this document itself keeps or has stopped becomes a stopped
    /// commitment of its own. Every other removed entry is dropped.
    ///
    /// The roster this answers with holds its commitments in the order of the entry each was made
    /// from — never the order a chain finished gathering eras in — with each commitment's own eras
    /// gathered together immediately behind it, newest first: `design.md` § *The eras gather
    /// behind their commitment; the commitments keep their order*. A document holding one era
    /// twice, on either path — as two entries this document itself keeps or has stopped, or as an
    /// era attaching to a chain that already holds its shape — is refused rather than folded, on
    /// the same footing as *One era held twice in a stored form-4 roster is refused, not folded*.
    func folded() -> Fold? {
        struct Decoded {
            let record: CommitmentRecord
            let commitment: Commitment
            let keptUntil: CalendarDate?
            let isRemoved: Bool
            let category: String?
        }

        var decoded: [Decoded] = []
        for entry in commitments {
            guard let commitment = entry.commitment.commitment() else {
                return nil
            }

            let keptUntil: CalendarDate?
            if let keptUntilRecord = entry.keptUntil {
                guard let date = keptUntilRecord.calendarDate() else {
                    return nil
                }
                keptUntil = date
            } else {
                keptUntil = nil
            }

            let isRemoved = entry.removed == true
            guard !isRemoved || keptUntil != nil else {
                return nil
            }

            decoded.append(
                Decoded(
                    record: entry.commitment, commitment: commitment, keptUntil: keptUntil,
                    isRemoved: isRemoved, category: entry.category))
        }

        var identities: [CommitmentRecord: Commitment.Identity?] = [:]

        // Every entry this document keeps or has stopped keeping becomes a commitment of its own
        // straightaway — each a chain a removed entry may still attach to. Two such entries alike
        // in every part would each mint their own identity and collide silently in `identities`,
        // keyed by that one bare shape — which is exactly one identity kept from one day twice,
        // `formRoster()`'s own guard for the form this app writes. `mintedBareShapes` is that same
        // guard here, before any identity is minted rather than after.
        var chains: [Chain] = []
        var originallyKeptOrStopped: [(name: String, kind: Commitment.Kind)] = []
        var mintedBareShapes: Set<CommitmentRecord> = []
        for (index, item) in decoded.enumerated() where !item.isRemoved {
            guard mintedBareShapes.insert(CommitmentRecord.bare(item.commitment)).inserted else {
                return nil
            }
            let head = Roster.Entry(
                commitment: item.commitment, keptUntil: item.keptUntil, isRemoved: false,
                category: item.category)
            chains.append(Chain(representative: item.commitment, headIndex: index, head: head))
            originallyKeptOrStopped.append((item.commitment.name, item.commitment.kind))
            identities.updateValue(item.commitment.identity, forKey: CommitmentRecord.bare(item.commitment))
        }

        // Removed entries are judged in the document's own order, so a chain's front has already
        // moved past whatever attached to it earlier in the document by the time a later entry is
        // judged against it — which is what makes "the nearest in the roster's order" fall out of
        // this single pass rather than needing its own tie-break for the common case.
        for (index, item) in decoded.enumerated() where item.isRemoved {
            let keptUntil = item.keptUntil!

            let matchingChains = chains.filter {
                $0.representative.name == item.commitment.name
                    && $0.representative.kind.isOfTheSameSort(as: item.commitment.kind)
            }
            let attachable = matchingChains.filter { keptUntil.days(until: $0.front) == 1 }

            if let chain = attachable.max(by: { $0.frontIndex < $1.frontIndex }) {
                // Never fails: `chain.representative.name` already formed once, and a blank name
                // is the era initialiser's one refusal.
                let era = Commitment(
                    era: chain.representative, schedule: item.commitment.schedule,
                    keptFrom: item.commitment.keptFrom, kind: item.commitment.kind)!
                let shape = EraShape(era)
                guard chain.shapes.insert(shape).inserted else {
                    return nil
                }
                identities.updateValue(era.identity, forKey: CommitmentRecord.bare(item.commitment))
                chain.eras.append(
                    Roster.Entry(
                        commitment: era, keptUntil: keptUntil, isRemoved: false,
                        category: item.category))
                chain.front = item.commitment.keptFrom
                chain.frontIndex = index
                continue
            }

            let resemblesKeptOrStopped = originallyKeptOrStopped.contains {
                $0.name == item.commitment.name && $0.kind.isOfTheSameSort(as: item.commitment.kind)
            }
            guard resemblesKeptOrStopped else {
                identities.updateValue(nil, forKey: CommitmentRecord.bare(item.commitment))
                continue
            }

            guard mintedBareShapes.insert(CommitmentRecord.bare(item.commitment)).inserted else {
                return nil
            }

            let standalone = Roster.Entry(
                commitment: item.commitment, keptUntil: keptUntil, isRemoved: false,
                category: item.category)
            chains.append(Chain(representative: item.commitment, headIndex: index, head: standalone))
            identities.updateValue(item.commitment.identity, forKey: CommitmentRecord.bare(item.commitment))
        }

        // Each chain in the order of the entry its commitment was made from, `headIndex` — never
        // `frontIndex`, which moves as eras attach — then that chain's own eras, already
        // newest-first by construction: `design.md` § *The eras gather behind their commitment;
        // the commitments keep their order*.
        var roster = Roster()
        roster.entries = chains.sorted { $0.headIndex < $1.headIndex }.flatMap(\.eras)
        return Fold(roster: roster, identities: identities)
    }
}

/// Reads only `version`, so a later form is told apart from the body before the body is ever
/// decoded — a document whose body this app cannot parse and a document from a newer app must not
/// report the same error.
struct RosterDocumentEnvelope: Decodable {
    var version: Int
}

/// One commitment a roster keeps, and the day it was kept until when the roster has stopped
/// keeping it. `keptUntil` is absent for a commitment the roster has not stopped keeping.
/// `removed` is present exactly at forms at or after `RosterDocument.removalIntroducedInVersion`
/// — `true` for a commitment the roster has removed, `false` for one it has not, and absent
/// entirely at every form before: presence means "this form", not "this commitment", which is
/// what lets `RosterStore.init(at:)` check the whole document's shape against its declared
/// version rather than trusting each entry on its own.
///
/// `category` is present exactly at forms at or after `RosterDocument.categoryIntroducedInVersion`
/// too, but a plain `Optional` cannot say so on its own: `KeyedDecodingContainer.decodeIfPresent`
/// reads an explicit `null` and an absent key alike as `nil`, and "this commitment is under no
/// category" and "this form has no categories in it" must read as two different things
/// (`design.md` § *Context*). `categoryKeyPresent` is `true` exactly when the "category" key was
/// in the JSON at all, and is what `RosterStore.init(at:)` checks against the declared version;
/// it is never itself written, because `encode(to:)` always writes `category` — `null` where the
/// commitment is under none — so there is nothing for it to say at write time.
struct RosterEntryRecord: Codable {
    var commitment: CommitmentRecord
    var keptUntil: DateRecord?
    var removed: Bool?
    var category: String?
    var categoryKeyPresent: Bool

    private enum CodingKeys: String, CodingKey {
        case commitment, keptUntil, removed, category
    }

    init(commitment: CommitmentRecord, keptUntil: DateRecord?, removed: Bool?, category: String?) {
        self.commitment = commitment
        self.keptUntil = keptUntil
        self.removed = removed
        self.category = category
        self.categoryKeyPresent = true
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        commitment = try container.decode(CommitmentRecord.self, forKey: .commitment)
        keptUntil = try container.decodeIfPresent(DateRecord.self, forKey: .keptUntil)
        removed = try container.decodeIfPresent(Bool.self, forKey: .removed)
        categoryKeyPresent = container.contains(.category)
        category = try container.decodeIfPresent(String.self, forKey: .category)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(commitment, forKey: .commitment)
        try container.encodeIfPresent(keptUntil, forKey: .keptUntil)
        try container.encodeIfPresent(removed, forKey: .removed)
        try container.encode(category, forKey: .category)
    }
}
