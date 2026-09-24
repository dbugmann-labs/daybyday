import Foundation

/// The versioned form a `BirthdayStore` writes to and reads from disk. `design.md` § *The form
/// on disk* fixes the shape below by hand, in the birthday's own words, rather than deriving
/// `Codable` on `BirthdayTicks` itself: the file's shape is a contract independent of how
/// `BirthdayTicks` happens to be laid out in Swift, and carries no words and no switch —
/// decision 1 in `design.md`.
///
/// Ticks are written by contact then by day, for a byte-stable file: `BirthdayTicks` itself
/// holds them in a `Set`, which is never written in that order.
struct BirthdayDocument: Codable {
    /// The form this app writes. A document whose `version` is higher is a later form;
    /// `BirthdayDocumentEnvelope` below reads it before this whole shape is decoded, as
    /// `design.md` requires.
    static let currentVersion = 1

    var version: Int
    var ticks: [BirthdayTickRecord]

    /// Builds the document that exactly represents `ticks`, in contact-then-day order.
    init(_ ticks: BirthdayTicks) {
        version = Self.currentVersion
        self.ticks = ticks.keys
            .sorted { lhs, rhs in
                if lhs.contact != rhs.contact {
                    return lhs.contact < rhs.contact
                }
                return DateRecord(lhs.day) < DateRecord(rhs.day)
            }
            .map { BirthdayTickRecord(contact: $0.contact, day: DateRecord($0.day)) }
    }

    /// Re-forms the ticks `self.ticks` holds through `Birthday`'s own contact rule and
    /// `BirthdayTicks.tick`, so every invariant the engine has applies to what comes off the
    /// disk and a document that could not be a tick holder is refused rather than trusted.
    /// `nil` where any one entry's contact says nothing, its day names no day, or replaying it
    /// is refused by `BirthdayTicks` itself — two ticks alike in contact and day.
    func formTicks() -> BirthdayTicks? {
        var ticks = BirthdayTicks()
        for entry in self.ticks {
            guard let day = entry.day.calendarDate(),
                let birthday = Birthday(contact: entry.contact, words: "", day: day)
            else {
                return nil
            }
            guard ticks.tick(birthday) else {
                return nil
            }
        }
        return ticks
    }
}

/// Reads only `version`, so a later form is told apart from the body before the body is ever
/// decoded — a document whose body this app cannot parse and a document from a newer app must
/// not report the same error.
struct BirthdayDocumentEnvelope: Decodable {
    var version: Int
}

/// One tick a store keeps: the contact and the day it was ticked against, and nothing else —
/// no words and no switch, per decision 1 in `design.md`.
struct BirthdayTickRecord: Codable {
    var contact: String
    var day: DateRecord
}
