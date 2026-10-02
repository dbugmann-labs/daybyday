import Foundation

/// The versioned form a `HappeningStore` writes to and reads from disk, shaped by hand rather than
/// by deriving `Codable` on the value, as `OneOffDocument` is: the file's shape is a contract
/// independent of how `Happening` is laid out in Swift. The array is in the order `Happenings`
/// holds them, and is never sorted. `openspec/changes/add-happening/design.md` § *Migration*.
struct HappeningDocument: Codable {
    static let currentVersion = 2

    /// The form that added `occurrences`; a form before it carries none and reads as holding none.
    static let occurrencesIntroducedInVersion = 2

    var version: Int
    var happenings: [HappeningRecord]
    var occurrences: [OccurrenceRecord]?

    init(_ happenings: Happenings) {
        version = Self.currentVersion
        self.happenings = happenings.all.map {
            HappeningRecord(identity: $0.identity.uuidString, name: $0.name)
        }
        occurrences = happenings.occurrences.map {
            OccurrenceRecord(
                happening: $0.happening.uuidString, day: DateRecord($0.day),
                hour: $0.time?.hour, minute: $0.time?.minute, note: $0.note)
        }
    }

    /// Re-forms the happenings through `Happening` and `Happenings.add`, and the occurrences through
    /// `Occurrence` and `Happenings.note`, so every rule the values have applies to what comes off
    /// the disk: `nil` where an identity is not one, a name says nothing, two happenings share a
    /// name or an identity, or an occurrence is missing, has a bad identity, day or time (one of
    /// hour and minute alone, or out of range), or is of a happening not held.
    func formHappenings() -> Happenings? {
        var formed = Happenings()
        for record in happenings {
            guard let identity = Happening.Identity(record.identity),
                !Blank.saysNothing(record.name)
            else {
                return nil
            }
            guard formed.add(Happening(identity: identity, name: record.name)) else {
                return nil
            }
        }

        if version < Self.occurrencesIntroducedInVersion {
            return formed
        }
        guard let records = occurrences else {
            return nil
        }
        for record in records {
            guard let identity = Happening.Identity(record.happening),
                let day = record.day.calendarDate()
            else {
                return nil
            }
            var time: TimeOfDay?
            switch (record.hour, record.minute) {
            case (nil, nil):
                time = nil
            case let (hour?, minute?):
                guard let formedTime = TimeOfDay(hour: hour, minute: minute) else {
                    return nil
                }
                time = formedTime
            default:
                return nil
            }
            let occurrence = Occurrence(ofIdentity: identity, on: day, at: time, saying: record.note)
            guard formed.note(occurrence) else {
                return nil
            }
        }
        return formed
    }
}

/// Reads only `version`, so a later form is told apart from a body this app cannot parse.
struct HappeningDocumentEnvelope: Decodable {
    var version: Int
}

struct HappeningRecord: Codable {
    var identity: String
    var name: String
}

/// One occurrence as the file keeps it: `hour`, `minute` and `note` are absent where there is none.
struct OccurrenceRecord: Codable {
    var happening: String
    var day: DateRecord
    var hour: Int?
    var minute: Int?
    var note: String?
}
