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
    static let currentVersion = 3

    /// The form `removed` was introduced at: forms at or after this one carry it on every entry,
    /// forms before it never do. Kept apart from `currentVersion` on purpose, for the reason
    /// `RecordDocument.numbersIntroducedInVersion`'s own comment gives — a fourth form would move
    /// `currentVersion` to `4` without moving this, and `RosterStore.init(at:)`'s
    /// shape-against-form guard reads against this constant precisely so raising `currentVersion`
    /// alone cannot silently change which forms are expected to carry `removed`.
    static let removalIntroducedInVersion = 3

    var version: Int
    var commitments: [RosterEntryRecord]

    /// Builds the document that exactly represents `roster`, in the roster's own order.
    init(_ roster: Roster) {
        version = Self.currentVersion
        commitments = roster.entries.map { entry in
            RosterEntryRecord(
                commitment: CommitmentRecord(entry.commitment),
                keptUntil: entry.keptUntil.map(DateRecord.init),
                removed: entry.isRemoved)
        }
    }

    /// Re-forms `roster` through `Roster.add`, `Roster.retire` and `Roster.remove`, so every
    /// invariant the engine has applies to what comes off the disk and a document that could not
    /// be a roster is refused rather than trusted. `nil` if any one entry in the document could
    /// not be formed, if replaying it is refused by `Roster` itself, or if an entry is held as
    /// removed with no day it was kept until — a state a roster has never been in.
    func formRoster() -> Roster? {
        var roster = Roster()
        for entry in commitments {
            guard let commitment = entry.commitment.commitment() else {
                return nil
            }
            guard roster.add(commitment) else {
                return nil
            }
            guard let keptUntilRecord = entry.keptUntil else {
                guard entry.removed != true else {
                    return nil
                }
                continue
            }
            guard let keptUntil = keptUntilRecord.calendarDate() else {
                return nil
            }
            if entry.removed == true {
                guard roster.remove(commitment, keptUntil: keptUntil) else {
                    return nil
                }
            } else {
                guard roster.retire(commitment, keptUntil: keptUntil) else {
                    return nil
                }
            }
        }
        return roster
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
struct RosterEntryRecord: Codable {
    var commitment: CommitmentRecord
    var keptUntil: DateRecord?
    var removed: Bool?
}
