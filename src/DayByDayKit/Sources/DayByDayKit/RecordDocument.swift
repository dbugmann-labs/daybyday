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
    /// by commitment name, then kept-from day, then date, then schedule as the last tiebreaker for
    /// two commitments alike in the first three — so two equal sets of ticks produce byte-identical
    /// files.
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
                if lhs.date != rhs.date {
                    return lhs.date < rhs.date
                }
                return lhs.commitment.schedule < rhs.commitment.schedule
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
