import Foundation

/// The versioned form an `OneOffStore` writes to and reads from disk. `design.md` § *The form on
/// disk* fixes the shape below by hand, in the one-off's own words, rather than deriving `Codable`
/// on the engine types: the file's shape is a contract independent of how `OneOff` and `OneOffs`
/// happen to be laid out in Swift.
///
/// The array is in the order `OneOffs` holds its entries, and is not sorted — nothing sorts a
/// one-off, because that order is what a later Story draws from.
struct OneOffDocument: Codable {
    /// The form this app writes. A document whose `version` is higher is a later form;
    /// `OneOffDocumentEnvelope` below reads it before this whole shape is decoded, as
    /// `design.md` requires.
    static let currentVersion = 1

    var version: Int
    var oneOffs: [OneOffEntryRecord]

    /// Builds the document that exactly represents `oneOffs`, in the order it holds them.
    init(_ oneOffs: OneOffs) {
        version = Self.currentVersion
        self.oneOffs = oneOffs.entries.map { entry in
            OneOffEntryRecord(
                name: entry.oneOff.name,
                date: DateRecord(entry.oneOff.date),
                doneOn: entry.doneOn.map(DateRecord.init))
        }
    }

    /// Re-forms `oneOffs` through `OneOffs.add` and `OneOffs.add(_:doneOn:)`, so every invariant
    /// the engine has applies to what comes off the disk and a document that could not be a
    /// one-off holder is refused rather than trusted. `nil` if any one entry in the document
    /// could not be formed, or if replaying it is refused by `OneOffs` itself — a name that says
    /// nothing, a date that names no day, a day done before the one-off's own date, or two
    /// one-offs alike in name and date.
    func formOneOffs() -> OneOffs? {
        var oneOffs = OneOffs()
        for entry in self.oneOffs {
            guard let date = entry.date.calendarDate(),
                let oneOff = OneOff(name: entry.name, date: date)
            else {
                return nil
            }

            if let doneOnRecord = entry.doneOn {
                guard let doneOn = doneOnRecord.calendarDate() else {
                    return nil
                }
                guard oneOffs.add(oneOff, doneOn: doneOn) else {
                    return nil
                }
            } else {
                guard oneOffs.add(oneOff) else {
                    return nil
                }
            }
        }
        return oneOffs
    }
}

/// Reads only `version`, so a later form is told apart from the body before the body is ever
/// decoded — a document whose body this app cannot parse and a document from a newer app must not
/// report the same error.
struct OneOffDocumentEnvelope: Decodable {
    var version: Int
}

/// One one-off a store keeps: its name, its date, and the day it was done — absent where it is
/// not done. `doneOn` is optional by meaning rather than by form, so it carries no
/// `IntroducedInVersion` constant: its presence is never judged against the version, unlike
/// `RosterEntryRecord.category` (`design.md` § *The form on disk*).
struct OneOffEntryRecord: Codable {
    var name: String
    var date: DateRecord
    var doneOn: DateRecord?
}
