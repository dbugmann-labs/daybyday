import Foundation
import Testing
import DayByDayKit

/// A fresh place under the temporary directory, one per test, so tests are independent and need
/// no teardown: a UUID names the directory, and the store's file sits one level under it, so the
/// directory itself does not exist until the store creates it. Mirrors `OneOffStoreTests`'s
/// `freshPlace()`.
private func freshPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("birthdayTicks.json")
}

/// The file system's own identifier for whatever is at `place` right now. An atomic rewrite
/// swaps in a new file even when its bytes are identical to what was there, so this changes on a
/// rewrite where a byte comparison alone would not catch one.
private func inode(at place: URL) throws -> UInt64 {
    let attributes = try FileManager.default.attributesOfItem(atPath: place.path)
    return (attributes[.systemFileNumber] as! NSNumber).uint64Value
}

@Test("a birthday store opened where nothing has been kept holds no ticks")
func aBirthdayStoreOpenedWhereNothingHasBeenKeptHoldsNoTicks() throws {
    let place = freshPlace()

    let store = try BirthdayStore(at: place)

    #expect(store.ticks == BirthdayTicks())
}

@Test("a birthday store opened again holds exactly the ticks left there, and none of their words")
func aBirthdayStoreOpenedAgainHoldsExactlyTheTicksLeftThereAndNoneOfTheirWords() throws {
    let place = freshPlace()
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    let september26 = CalendarDate(year: 2026, month: 9, day: 26)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: september25)!
    let john = Birthday(contact: "john", words: "John Appleseed's 40th Birthday", day: september26)!
    let anna = Birthday(contact: "anna", words: "Anna Haro's Birthday", day: september25)!
    let kateRenamed = Birthday(
        contact: "kate", words: "Kate Smith's 48th Birthday", day: september25)!

    let store = try BirthdayStore(at: place)
    try store.tick(kate)
    try store.tick(john)
    try store.tick(anna)
    try store.takeBack(john)

    let later = try BirthdayStore(at: place)

    var expected = BirthdayTicks()
    _ = expected.tick(kate)
    _ = expected.tick(anna)
    #expect(later.ticks == expected)
    #expect(later.ticks.isTicked(kateRenamed))

    let content = try String(contentsOf: place, encoding: .utf8)
    #expect(!content.contains("Kate"))
    #expect(!content.contains("John"))
    #expect(!content.contains("Anna"))
}

@Test("a birthday tick is kept before the store reports it kept")
func aBirthdayTickIsKeptBeforeTheStoreReportsItKept() throws {
    let place = freshPlace()
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: september25)!

    let first = try BirthdayStore(at: place)
    try first.tick(kate)

    let second = try BirthdayStore(at: place)

    #expect(second.ticks.isTicked(kate))

    withExtendedLifetime(first) {}
}

@Test("a birthday tick that cannot be kept is refused and not held")
func aBirthdayTickThatCannotBeKeptIsRefusedAndNotHeld() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    let place = blocker.appendingPathComponent("birthdayTicks.json")

    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: september25)!

    let store = try BirthdayStore(at: place)

    #expect(throws: BirthdayStoreError.cannotWrite(at: place)) {
        try store.tick(kate)
    }
    #expect(store.ticks == BirthdayTicks())

    let later = try BirthdayStore(at: place)
    #expect(later.ticks == BirthdayTicks())
}

@Test("a change the birthday ticks refuse leaves the place untouched")
func aChangeTheBirthdayTicksRefuseLeavesThePlaceUntouched() throws {
    let place = freshPlace()
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: september25)!
    let john = Birthday(
        contact: "john", words: "John Appleseed's 40th Birthday", day: september25)!

    let store = try BirthdayStore(at: place)
    try store.tick(kate)
    let contentAfterFirst = try Data(contentsOf: place)
    let inodeAfterFirst = try inode(at: place)

    let tickedAgain = try store.tick(kate)

    #expect(!tickedAgain)
    #expect(try Data(contentsOf: place) == contentAfterFirst)
    #expect(try inode(at: place) == inodeAfterFirst)

    let takenBackNeverTicked = try store.takeBack(john)

    #expect(!takenBackNeverTicked)
    #expect(try Data(contentsOf: place) == contentAfterFirst)
    #expect(try inode(at: place) == inodeAfterFirst)
}

@Test("birthday stores at different places are independent")
func birthdayStoresAtDifferentPlacesAreIndependent() throws {
    let firstPlace = freshPlace()
    let secondPlace = freshPlace()
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: september25)!

    let first = try BirthdayStore(at: firstPlace)
    try first.tick(kate)
    let second = try BirthdayStore(at: secondPlace)

    #expect(second.ticks == BirthdayTicks())

    let laterFirst = try BirthdayStore(at: firstPlace)
    #expect(laterFirst.ticks.isTicked(kate))
}

@Test("content that is not a birthday store is refused and left as it was")
func contentThatIsNotABirthdayStoreIsRefusedAndLeftAsItWas() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data("not a birthday store".utf8)
    try bytes.write(to: place)

    #expect(throws: BirthdayStoreError.notAStore(at: place)) {
        try BirthdayStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a birthday store written in a later form than this app knows is refused")
func aBirthdayStoreWrittenInALaterFormThanThisAppKnowsIsRefused() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(#"{"version": 2, "ticks": []}"#.utf8)
    try bytes.write(to: place)

    #expect(throws: BirthdayStoreError.laterForm(at: place, version: 2)) {
        try BirthdayStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a birthday store holding what could not be a tick is refused")
func aBirthdayStoreHoldingWhatCouldNotBeATickIsRefused() throws {
    let blankContactPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: blankContactPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let blankContactBytes = Data(
        """
        {
          "version": 1,
          "ticks": [
            { "contact": "   ", "day": { "year": 2026, "month": 9, "day": 25 } }
          ]
        }
        """.utf8)
    try blankContactBytes.write(to: blankContactPlace)

    let noSuchDayPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: noSuchDayPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let noSuchDayBytes = Data(
        """
        {
          "version": 1,
          "ticks": [
            { "contact": "kate", "day": { "year": 2026, "month": 2, "day": 30 } }
          ]
        }
        """.utf8)
    try noSuchDayBytes.write(to: noSuchDayPlace)

    let sameTickTwicePlace = freshPlace()
    try FileManager.default.createDirectory(
        at: sameTickTwicePlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let sameTickTwiceBytes = Data(
        """
        {
          "version": 1,
          "ticks": [
            { "contact": "kate", "day": { "year": 2026, "month": 9, "day": 25 } },
            { "contact": "kate", "day": { "year": 2026, "month": 9, "day": 25 } }
          ]
        }
        """.utf8)
    try sameTickTwiceBytes.write(to: sameTickTwicePlace)

    #expect(throws: BirthdayStoreError.notAStore(at: blankContactPlace)) {
        try BirthdayStore(at: blankContactPlace)
    }
    #expect(throws: BirthdayStoreError.notAStore(at: noSuchDayPlace)) {
        try BirthdayStore(at: noSuchDayPlace)
    }
    #expect(throws: BirthdayStoreError.notAStore(at: sameTickTwicePlace)) {
        try BirthdayStore(at: sameTickTwicePlace)
    }

    #expect(try Data(contentsOf: blankContactPlace) == blankContactBytes)
    #expect(try Data(contentsOf: noSuchDayPlace) == noSuchDayBytes)
    #expect(try Data(contentsOf: sameTickTwicePlace) == sameTickTwiceBytes)
}
