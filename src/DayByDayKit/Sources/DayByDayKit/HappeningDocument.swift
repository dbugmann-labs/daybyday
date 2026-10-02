import Foundation

/// The versioned form a `HappeningStore` writes to and reads from disk, shaped by hand rather than
/// by deriving `Codable` on the value, as `OneOffDocument` is: the file's shape is a contract
/// independent of how `Happening` is laid out in Swift. The array is in the order `Happenings`
/// holds them, and is never sorted. `openspec/changes/add-happening/design.md` § *Migration*.
struct HappeningDocument: Codable {
    static let currentVersion = 1

    var version: Int
    var happenings: [HappeningRecord]

    init(_ happenings: Happenings) {
        version = Self.currentVersion
        self.happenings = happenings.all.map {
            HappeningRecord(identity: $0.identity.uuidString, name: $0.name)
        }
    }

    /// Re-forms the happenings through `Happening` and `Happenings.add`, so every rule the value
    /// has applies to what comes off the disk: `nil` where an identity is not one, a name says
    /// nothing, two share a name or two share an identity.
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
