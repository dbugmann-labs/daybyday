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
    static let currentVersion = 2

    /// The form `tick` was introduced at: forms at or after this one carry it on every done
    /// entry, and on no other, and forms before it never carry it at all — on the same footing
    /// as `RosterDocument.categoryIntroducedInVersion`, `design.md` § *The form on disk*.
    static let tickOrderIntroducedInVersion = 2

    var version: Int
    var oneOffs: [OneOffEntryRecord]

    /// Builds the document that exactly represents `oneOffs`, in the order it holds them: every
    /// done entry carries its place in the tick order, 1 the oldest, and no other entry carries
    /// one. `design.md` § *The form on disk: form 2, a place on every done entry*.
    init(_ oneOffs: OneOffs) {
        version = Self.currentVersion
        var places: [OneOff: Int] = [:]
        for (index, oneOff) in oneOffs.doneOrder.enumerated() {
            places[oneOff] = index + 1
        }
        self.oneOffs = oneOffs.entries.map { entry in
            OneOffEntryRecord(
                name: entry.oneOff.name,
                date: DateRecord(entry.oneOff.date),
                doneOn: entry.doneOn.map(DateRecord.init),
                tick: entry.doneOn != nil ? places[entry.oneOff] : nil)
        }
    }

    /// Re-forms `oneOffs` through `OneOffs.add` and `OneOffs.add(_:doneOn:)`, so every invariant
    /// the engine has applies to what comes off the disk and a document that could not be a
    /// one-off holder is refused rather than trusted. `nil` if any one entry in the document
    /// could not be formed, or if replaying it is refused by `OneOffs` itself — a name that says
    /// nothing, a date that names no day, a day done before the one-off's own date, or two
    /// one-offs alike in name and date. Assumes `OneOffStore.shapeAgrees(with:)` has already
    /// found this document's `tick` fields consistent with its own declared `version`; this
    /// builds the tick order from them rather than checking them again.
    ///
    /// At or after `tickOrderIntroducedInVersion`, the tick order is exactly what each done
    /// entry's own `tick` place says. Before it, this app kept no tick order at all, so one is
    /// derived once — `design.md` § *Form 1 is read as a tick order derived once, never as a
    /// second state*: read newest-first, it stands by each one-off's own date, earliest first,
    /// then the order added, exactly as this app drew a past day before this Story. That is the
    /// document's done entries, in the order they appear, sorted ascending by date (a stable
    /// sort, so a tie keeps the order added) and then reversed — the oldest tick last in that
    /// ascending reading is the most recently ticked, first once reversed.
    func formOneOffs() -> OneOffs? {
        var oneOffs = OneOffs()
        var doneInDocumentOrder: [OneOff] = []
        var places: [OneOff: Int] = [:]

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
                doneInDocumentOrder.append(oneOff)
                if let tick = entry.tick {
                    places[oneOff] = tick
                }
            } else {
                guard oneOffs.add(oneOff) else {
                    return nil
                }
            }
        }

        guard !doneInDocumentOrder.isEmpty else {
            return oneOffs
        }

        if version >= Self.tickOrderIntroducedInVersion {
            oneOffs.doneOrder = doneInDocumentOrder.sorted { places[$0]! < places[$1]! }
        } else {
            oneOffs.doneOrder = Array(
                doneInDocumentOrder
                    .sorted { $0.date.days(until: $1.date) > 0 }
                    .reversed())
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

/// One one-off a store keeps: its name, its date, the day it was done — absent where it is not
/// done — and its place in the tick order. `doneOn` is optional by meaning rather than by form,
/// so it carries no `IntroducedInVersion` constant: its presence is never judged against the
/// version, unlike `RosterEntryRecord.category`. `tick` is the opposite: present exactly on a
/// done entry at forms at or after `OneOffDocument.tickOrderIntroducedInVersion`, and absent
/// everywhere else — `OneOffStore.shapeAgrees(with:)` is what checks that, on the same footing as
/// `RosterStore.shapeAgrees(with:)` checks `category` (`design.md` § *The form on disk*).
struct OneOffEntryRecord: Codable {
    var name: String
    var date: DateRecord
    var doneOn: DateRecord?
    var tick: Int?
}
