import Foundation
import Testing

@testable import DayByDayKit

/// A fresh place under the temporary directory, one per test; the directory does not exist until
/// the store creates it.
private func freshPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("happenings.json")
}

/// Writes `bytes` at a fresh place and answers it.
private func placeHolding(_ bytes: Data) throws -> URL {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try bytes.write(to: place)
    return place
}

@Test("a happening store opened where nothing has been kept holds no happenings")
func aHappeningStoreOpenedWhereNothingHasBeenKeptHoldsNoHappenings() throws {
    let store = try HappeningStore(at: freshPlace())

    #expect(store.happenings == Happenings())
}

@Test(
    "a happening store opened again holds the happenings left there, renamed and in their order")
func aHappeningStoreOpenedAgainHoldsTheHappeningsLeftThereRenamedAndInTheirOrder() throws {
    let place = freshPlace()
    let augenmigraene = try #require(Happening(name: "Augenmigräne"))
    let kopfweh = try #require(Happening(name: "Kopfweh"))

    let first = try HappeningStore(at: place)
    try first.add(augenmigraene)
    try first.add(kopfweh)
    try first.rename(kopfweh, to: "Spannungskopfweh")

    let second = try HappeningStore(at: place)

    #expect(second.happenings.all.map(\.name) == ["Augenmigräne", "Spannungskopfweh"])
    #expect(second.happenings.all[0] == augenmigraene)
    #expect(second.happenings.all[1] == kopfweh)
    #expect(second.happenings == first.happenings)
    withExtendedLifetime(first) {}
}

@Test("a happening change that cannot be kept is refused and not held")
func aHappeningChangeThatCannotBeKeptIsRefusedAndNotHeld() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    let blockedPlace = blocker.appendingPathComponent("happenings.json")
    let kopfweh = try #require(Happening(name: "Kopfweh"))

    let blocked = try HappeningStore(at: blockedPlace)
    #expect(throws: HappeningStoreError.cannotWrite(at: blockedPlace)) {
        try blocked.add(kopfweh)
    }
    #expect(blocked.happenings == Happenings())

    let readOnly = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: readOnly, withIntermediateDirectories: true)
    let place = readOnly.appendingPathComponent("happenings.json")
    let store = try HappeningStore(at: place)
    try store.add(kopfweh)
    let before = store.happenings

    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: readOnly.path)
    #expect(throws: HappeningStoreError.cannotWrite(at: place)) {
        try store.rename(kopfweh, to: "Spannungskopfweh")
    }
    try FileManager.default.setAttributes([.posixPermissions: 0o700], ofItemAtPath: readOnly.path)

    #expect(store.happenings == before)
    #expect(store.happenings.all.map(\.name) == ["Kopfweh"])
    #expect(try HappeningStore(at: place).happenings == before)
}

@Test("a change the happenings refuse leaves the happening store's place untouched")
func aChangeTheHappeningsRefuseLeavesTheHappeningStoresPlaceUntouched() throws {
    let place = freshPlace()
    let kopfweh = try #require(Happening(name: "Kopfweh"))
    let store = try HappeningStore(at: place)
    try store.add(kopfweh)
    let kept = try Data(contentsOf: place)

    // Nothing can be written from here, so a refused ask that rewrote the place would throw.
    let directory = place.deletingLastPathComponent()
    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
    defer {
        try? FileManager.default.setAttributes(
            [.posixPermissions: 0o700], ofItemAtPath: directory.path)
    }

    let alike = try store.add(try #require(Happening(name: "kopfweh")))
    #expect(!alike)
    #expect(try Data(contentsOf: place) == kept)

    let blank = try store.rename(kopfweh, to: "   ")
    #expect(!blank)
    #expect(try Data(contentsOf: place) == kept)
}

@Test("happening stores at different places are independent")
func happeningStoresAtDifferentPlacesAreIndependent() throws {
    let first = freshPlace()
    let kopfweh = try #require(Happening(name: "Kopfweh"))
    let one = try HappeningStore(at: first)
    try one.add(kopfweh)

    let other = try HappeningStore(at: freshPlace())
    #expect(other.happenings == Happenings())

    let later = try HappeningStore(at: first)
    #expect(later.happenings.all.map(\.name) == ["Kopfweh"])
}

@Test("content that is not a happening store is refused and left as it was")
func contentThatIsNotAHappeningStoreIsRefusedAndLeftAsItWas() throws {
    let bytes = Data("not a happening store".utf8)
    let place = try placeHolding(bytes)

    #expect(throws: HappeningStoreError.notAStore(at: place)) {
        try HappeningStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a happening store written in a later form than this app knows is refused")
func aHappeningStoreWrittenInALaterFormThanThisAppKnowsIsRefused() throws {
    let laterVersion = HappeningDocument.currentVersion + 1
    let bytes = Data(#"{"version": \#(laterVersion), "happenings": []}"#.utf8)
    let place = try placeHolding(bytes)

    #expect(throws: HappeningStoreError.laterForm(at: place, version: laterVersion)) {
        try HappeningStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a happening store holding what could not be a happening is refused")
func aHappeningStoreHoldingWhatCouldNotBeAHappeningIsRefused() throws {
    let valid = "6F1B0F3E-0C1D-4F57-9A77-1B2E3C4D5E6F"
    let other = "A1B2C3D4-0C1D-4F57-9A77-1B2E3C4D5E70"
    func store(_ happenings: String) -> Data {
        Data(#"{"version": 1, "happenings": [\#(happenings)]}"#.utf8)
    }
    func entry(_ identity: String, _ name: String) -> String {
        #"{"identity": "\#(identity)", "name": "\#(name)"}"#
    }

    let bad = [
        store(entry(valid, "   ")),
        store(entry("not-an-identity", "Kopfweh")),
        store(entry(valid, "Kopfweh") + "," + entry(other, "kopfweh")),
        store(entry(valid, "Kopfweh") + "," + entry(valid, "Augenmigräne")),
    ]

    for bytes in bad {
        let place = try placeHolding(bytes)

        #expect(throws: HappeningStoreError.notAStore(at: place)) {
            try HappeningStore(at: place)
        }
        #expect(try Data(contentsOf: place) == bytes)
    }

    let good = try placeHolding(store(entry(valid, "Kopfweh")))
    #expect(try HappeningStore(at: good).happenings.all.map(\.name) == ["Kopfweh"])
}

@Test("a happening store opened again holds the occurrences noted there, in their order")
func aHappeningStoreOpenedAgainHoldsTheOccurrencesNotedThereInTheirOrder() throws {
    let place = freshPlace()
    let kopfweh = try #require(Happening(name: "Kopfweh"))
    let second = try #require(CalendarDate(year: 2026, month: 10, day: 2))
    let earlier = try #require(CalendarDate(year: 2026, month: 9, day: 30))

    let first = try HappeningStore(at: place)
    try first.add(kopfweh)
    try first.note(
        Occurrence(of: kopfweh, on: second, at: TimeOfDay(hour: 9, minute: 10), saying: "links"))
    try first.note(Occurrence(of: kopfweh, on: earlier, at: nil, saying: nil))
    try first.rename(kopfweh, to: "Spannungskopfweh")

    let again = try HappeningStore(at: place)

    #expect(again.happenings.occurrences.count == 2)
    #expect(again.happenings.occurrences.map(\.happening) == [kopfweh.identity, kopfweh.identity])
    #expect(again.happenings.all.map(\.name) == ["Spannungskopfweh"])
    #expect(again.happenings.occurrences[0].day == second)
    #expect(again.happenings.occurrences[0].time == TimeOfDay(hour: 9, minute: 10))
    #expect(again.happenings.occurrences[0].note == "links")
    #expect(again.happenings.occurrences[1].day == earlier)
    #expect(again.happenings.occurrences[1].time == nil)
    #expect(again.happenings.occurrences[1].note == nil)
    #expect(again.happenings == first.happenings)
    withExtendedLifetime(first) {}
}

@Test("an occurrence the happening store cannot keep is refused and not held")
func anOccurrenceTheHappeningStoreCannotKeepIsRefusedAndNotHeld() throws {
    let place = freshPlace()
    let kopfweh = try #require(Happening(name: "Kopfweh"))
    let second = try #require(CalendarDate(year: 2026, month: 10, day: 2))
    let store = try HappeningStore(at: place)
    try store.add(kopfweh)

    let directory = place.deletingLastPathComponent()
    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
    defer {
        try? FileManager.default.setAttributes(
            [.posixPermissions: 0o700], ofItemAtPath: directory.path)
    }
    let kept = try Data(contentsOf: place)

    #expect(throws: HappeningStoreError.cannotWrite(at: place)) {
        try store.note(
            Occurrence(of: kopfweh, on: second, at: TimeOfDay(hour: 9, minute: 10), saying: nil))
    }
    #expect(store.happenings.all == [kopfweh])
    #expect(store.happenings.occurrences.isEmpty)

    let stranger = try #require(Happening(name: "Schlecht geschlafen"))
    let refused = try store.note(Occurrence(of: stranger, on: second, at: nil, saying: nil))
    #expect(!refused)
    #expect(try Data(contentsOf: place) == kept)
}

@Test("a happening store in its first form is read as holding no occurrences")
func aHappeningStoreInItsFirstFormIsReadAsHoldingNoOccurrences() throws {
    let valid = "6F1B0F3E-0C1D-4F57-9A77-1B2E3C4D5E6F"
    let bytes = Data(#"{"version": 1, "happenings": [{"identity": "\#(valid)", "name": "Kopfweh"}]}"#.utf8)
    let place = try placeHolding(bytes)

    let store = try HappeningStore(at: place)

    #expect(store.happenings.all.map(\.name) == ["Kopfweh"])
    #expect(store.happenings.occurrences.isEmpty)
    #expect(try Data(contentsOf: place) == bytes)

    let kopfweh = try #require(store.happenings.all.first)
    let second = try #require(CalendarDate(year: 2026, month: 10, day: 2))
    try store.note(Occurrence(of: kopfweh, on: second, at: nil, saying: nil))

    let again = try HappeningStore(at: place)
    #expect(again.happenings.all.map(\.name) == ["Kopfweh"])
    #expect(again.happenings.occurrences.map(\.day) == [second])
}

@Test("a happening store holding an occurrence that could not be one is refused")
func aHappeningStoreHoldingAnOccurrenceThatCouldNotBeOneIsRefused() throws {
    let valid = "6F1B0F3E-0C1D-4F57-9A77-1B2E3C4D5E6F"
    let other = "A1B2C3D4-0C1D-4F57-9A77-1B2E3C4D5E70"
    func store(_ occurrence: String) -> Data {
        Data(
            #"""
            {"version": 2, "happenings": [{"identity": "\#(valid)", "name": "Kopfweh"}], "occurrences": [\#(occurrence)]}
            """#.utf8)
    }
    func occurrence(_ identity: String, _ date: String, _ time: String = "") -> String {
        #"{"happening": "\#(identity)", "day": \#(date)\#(time)}"#
    }
    let october = #"{"year": 2026, "month": 10, "day": 2}"#

    let bad = [
        store(occurrence(other, october)),
        store(occurrence(valid, #"{"year": 2026, "month": 2, "day": 30}"#)),
        store(occurrence(valid, october, #", "hour": 24, "minute": 0"#)),
    ]
    for bytes in bad {
        let place = try placeHolding(bytes)

        #expect(throws: HappeningStoreError.notAStore(at: place)) {
            try HappeningStore(at: place)
        }
        #expect(try Data(contentsOf: place) == bytes)
    }

    let good = try placeHolding(store(occurrence(valid, october, #", "hour": 9, "minute": 10"#)))
    #expect(try HappeningStore(at: good).happenings.occurrences.count == 1)
}
