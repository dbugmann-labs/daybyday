import Foundation

/// The versioned form a `RecordStore` writes to and reads from disk. `design.md` § *The form on
/// disk* fixes the shape below by hand, in the record's own words, rather than deriving `Codable`
/// on the engine types: the file's shape is a contract independent of how `Schedule`, `Commitment`
/// and `Tick` happen to be laid out in Swift.
///
/// `RecordDocument` converts to and from a `Set<Tick>` and a `[RecordedDay: Decimal]` rather than a
/// `History`: `History` keeps its own ticks and numbers `private`, by design, and building one back
/// up from a decoded document only needs its public `add(_:)` — reading one out is the direction
/// that has no public way through, so this type works at the one level the engine already opens up.
struct RecordDocument: Codable {
    /// The form this app writes. A document whose `version` is higher is a later form; `Envelope`
    /// below reads it before this whole shape is decoded, as `design.md` requires.
    static let currentVersion = 3

    /// The form `numbers` was introduced at: forms at or after this one carry the key, forms
    /// before it never do. Kept apart from `currentVersion` on purpose — a fourth form would move
    /// `currentVersion` to `4` without moving this, and `RecordStore.init(at:)`'s shape-against-form
    /// guard reads against this constant precisely so raising `currentVersion` alone cannot
    /// silently change which forms are expected to carry `numbers`.
    static let numbersIntroducedInVersion = 3

    var version: Int
    var ticks: [TickRecord]

    /// `nil` exactly when the document held no `numbers` key at all — forms 1 and 2 never write
    /// one, and telling that apart from a present-but-empty array is what lets a later guard
    /// refuse a form whose shape and declared version disagree, per `design.md` § *Each form is
    /// read as the shape that form has*. `Codable`'s synthesis decodes a missing key as `nil` for
    /// an `Optional` property and omits the key on encoding one, both without help here.
    var numbers: [NumberRecord]?

    /// Builds the document that exactly represents `ticks` and `numbers`, in the stable order
    /// `design.md` fixes: by commitment name, then kept-from day, then date, then schedule, then
    /// kind as the final tiebreaker — so two equal sets of ticks and numbers produce
    /// byte-identical files regardless of `Dictionary`'s per-process iteration order. A day holds
    /// at most one number per commitment, so two numbers cannot tie on all five for the *same*
    /// commitment — but two distinct commitments (different kinds, same name, schedule and
    /// kept-from day) can each hold a number on the same date and tie on the first four, which is
    /// what `kind` is for. A tick's commitment is always of the tick kind, so `kind` never
    /// actually discriminates two ticks.
    init(_ ticks: Set<Tick>, _ numbers: [RecordedDay: Decimal]) {
        version = Self.currentVersion
        self.ticks = ticks.map(TickRecord.init).sorted(by: Self.isOrderedBefore)
        self.numbers = numbers
            .map {
                NumberRecord(
                    commitment: CommitmentRecord($0.key.commitment),
                    date: DateRecord($0.key.date),
                    number: $0.value)
            }
            .sorted(by: Self.isOrderedBefore)
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

    /// Re-forms every number this document holds, exactly as `formTicks()` does for ticks. A
    /// document with no `numbers` key at all holds none, which is not a failure to form — `nil`
    /// here means one of the numbers present could not be formed, the whole document refused, not
    /// the bad ones dropped. Returns the formed `Number`s themselves, not a dictionary keyed by
    /// day: `RecordStore.init(at:)` needs both the dictionary (to hold and later write back) and
    /// each `Number` (to add to `history`), and building the dictionary from the `Number`s is one
    /// line at the call site — forming it here and having the caller re-form each `Number` back
    /// out of it, as this used to, ran `Number.init?` twice over the same three inputs.
    func formNumbers() -> [Number]? {
        var result: [Number] = []
        for record in numbers ?? [] {
            guard let number = record.formed() else {
                return nil
            }
            result.append(number)
        }
        return result
    }

    private static func isOrderedBefore<Record: DatedCommitmentRecord>(
        _ lhs: Record, _ rhs: Record
    ) -> Bool {
        if lhs.commitment.name != rhs.commitment.name {
            return lhs.commitment.name < rhs.commitment.name
        }
        if lhs.commitment.keptFrom != rhs.commitment.keptFrom {
            return lhs.commitment.keptFrom < rhs.commitment.keptFrom
        }
        if lhs.date != rhs.date {
            return lhs.date < rhs.date
        }
        if lhs.commitment.schedule != rhs.commitment.schedule {
            return lhs.commitment.schedule < rhs.commitment.schedule
        }
        return kindSortKey(lhs.commitment.kind) < kindSortKey(rhs.commitment.kind)
    }

    /// The final tiebreaker: two numbers for two distinct commitments alike in name, kept-from
    /// day, date and schedule but of different kinds tie on every field above this one, so `kind`
    /// closes the order — case first then payload, mirroring `ScheduleRecord`'s own `sortKey`
    /// rather than asking `KindRecord` to compare itself (see its doc comment in
    /// `CommitmentCoding.swift`). `nil` — the form written before a commitment carried a kind —
    /// sorts before every case; no number can be held in that form, so it never actually ties
    /// against one.
    private static func kindSortKey(_ kind: KindRecord?) -> String {
        guard let kind else {
            return ""
        }
        switch kind {
        case .tick:
            return "0"
        case .number(let range):
            guard let range else {
                return "1:"
            }
            return "1:\(range.lowest):\(range.highest)"
        case .note:
            return "2"
        case .total(let target):
            return "3:\(target)"
        }
    }
}

/// What `TickRecord` and `NumberRecord` share: enough to sort either by the one stable key
/// `design.md` § *The form on disk* fixes, so the two record kinds are ordered identically without
/// two copies of the same comparison.
private protocol DatedCommitmentRecord {
    var commitment: CommitmentRecord { get }
    var date: DateRecord { get }
}

/// Reads only `version`, so a later form is told apart from the body before the body is ever
/// decoded — a document whose body this app cannot parse and a document from a newer app must not
/// report the same error.
struct RecordDocumentEnvelope: Decodable {
    var version: Int
}

struct TickRecord: Codable, DatedCommitmentRecord {
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

struct NumberRecord: Codable, DatedCommitmentRecord {
    var commitment: CommitmentRecord
    var date: DateRecord
    var number: Decimal

    func formed() -> Number? {
        guard let commitment = commitment.commitment(), let date = date.calendarDate() else {
            return nil
        }
        return Number(number, for: commitment, on: date)
    }
}
