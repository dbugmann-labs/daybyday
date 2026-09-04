import Foundation

/// The versioned form a `RosterStore` writes to and reads from disk. `design.md` § *The form on
/// disk* fixes the shape below by hand, in the roster's own words, rather than deriving `Codable`
/// on the engine types: the file's shape is a contract independent of how `Roster` and
/// `Commitment` happen to be laid out in Swift.
///
/// The array is in the order the commitments were taken on, and is not sorted — `design.md` says
/// why: order is one of the things a roster is.
struct RosterDocument: Codable {
    /// The form this app writes. A document whose `version` is higher is a later form; `Envelope`
    /// below reads it before this whole shape is decoded, as `design.md` requires.
    static let currentVersion = 1

    var version: Int
    var commitments: [RosterEntryRecord]

    /// Builds the document that exactly represents `roster`, in the roster's own order.
    init(_ roster: Roster) {
        version = Self.currentVersion
        commitments = roster.entries.map { entry in
            RosterEntryRecord(
                commitment: CommitmentRecord(entry.commitment),
                keptUntil: entry.keptUntil.map(DateRecord.init))
        }
    }

    /// Re-forms `roster` through `Roster.add` and `Roster.retire`, so every invariant the engine
    /// has applies to what comes off the disk and a document that could not be a roster is
    /// refused rather than trusted. `nil` if any one entry in the document could not be formed, or
    /// if replaying it is refused by `Roster` itself.
    func formRoster() -> Roster? {
        var roster = Roster()
        for entry in commitments {
            guard let commitment = entry.commitment.commitment() else {
                return nil
            }
            guard roster.add(commitment) else {
                return nil
            }
            if let keptUntilRecord = entry.keptUntil {
                guard let keptUntil = keptUntilRecord.calendarDate() else {
                    return nil
                }
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
struct RosterEntryRecord: Codable {
    var commitment: CommitmentRecord
    var keptUntil: DateRecord?
}
