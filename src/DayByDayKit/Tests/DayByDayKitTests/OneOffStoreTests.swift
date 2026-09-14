import Foundation
import Testing
import DayByDayKit

/// A fresh place under the temporary directory, one per test, so tests are independent and need
/// no teardown: a UUID names the directory, and the store's file sits one level under it, so the
/// directory itself does not exist until the store creates it. Mirrors `RosterStoreTests`'s
/// `freshPlace()`.
private func freshPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("oneOffs.json")
}

@Test("a store opened where nothing has been kept holds no one-offs")
func aStoreOpenedWhereNothingHasBeenKeptHoldsNoOneOffs() throws {
    let place = freshPlace()

    let store = try OneOffStore(at: place)

    #expect(store.oneOffs == OneOffs())
}

@Test("a store opened again holds exactly the one-offs left there, done or not as they were left")
func aStoreOpenedAgainHoldsExactlyTheOneOffsLeftThereDoneOrNotAsTheyWereLeft() throws {
    let place = freshPlace()
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    let callDad = OneOff(name: "Call dad", date: CalendarDate(year: 2026, month: 9, day: 26)!)!
    let sendForm = OneOff(name: "Send form", date: CalendarDate(year: 2026, month: 9, day: 27)!)!
    let september26 = CalendarDate(year: 2026, month: 9, day: 26)!
    let september28 = CalendarDate(year: 2026, month: 9, day: 28)!
    let october5 = CalendarDate(year: 2026, month: 10, day: 5)!

    let store = try OneOffStore(at: place)
    try store.add(callMum)
    try store.add(callDad)
    try store.add(sendForm)
    try store.tick(callMum, on: september28)
    try store.tick(callDad, on: september26)
    try store.takeBack(callDad)
    try store.remove(sendForm)

    let later = try OneOffStore(at: place)

    var expected = OneOffs()
    _ = expected.add(callMum)
    _ = expected.add(callDad)
    _ = expected.tick(callMum, on: september28)
    #expect(later.oneOffs == expected)
    #expect(later.oneOffs.standingDay(for: callMum, asOf: october5) == september28)
    #expect(later.oneOffs.standingDay(for: callDad, asOf: october5) == october5)
    #expect(later.oneOffs.standingDay(for: sendForm, asOf: october5) == nil)
}

@Test("a change is kept before the store reports it kept")
func aChangeIsKeptBeforeTheStoreReportsItKept() throws {
    let place = freshPlace()
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    let october5 = CalendarDate(year: 2026, month: 10, day: 5)!

    let first = try OneOffStore(at: place)
    try first.add(callMum)
    try first.tick(callMum, on: september25)

    let second = try OneOffStore(at: place)

    #expect(second.oneOffs.standingDay(for: callMum, asOf: october5) == september25)
}

@Test("a one-off change that cannot be kept is refused and not held")
func aOneOffChangeThatCannotBeKeptIsRefusedAndNotHeld() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    let place = blocker.appendingPathComponent("oneOffs.json")

    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!

    let store = try OneOffStore(at: place)

    #expect(throws: OneOffStoreError.cannotWrite(at: place)) {
        try store.add(callMum)
    }
    #expect(store.oneOffs == OneOffs())

    let later = try OneOffStore(at: place)
    #expect(later.oneOffs == OneOffs())
}

@Test("a change the one-offs refuse leaves the place untouched")
func aChangeTheOneOffsRefuseLeavesThePlaceUntouched() throws {
    let place = freshPlace()
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!

    let store = try OneOffStore(at: place)
    try store.add(callMum)
    let contentAfterFirst = try Data(contentsOf: place)

    let addedAgain = try store.add(callMum)

    #expect(!addedAgain)
    #expect(try Data(contentsOf: place) == contentAfterFirst)
}

@Test("one-off stores at different places are independent")
func oneOffStoresAtDifferentPlacesAreIndependent() throws {
    let firstPlace = freshPlace()
    let secondPlace = freshPlace()
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!

    let first = try OneOffStore(at: firstPlace)
    try first.add(callMum)
    let second = try OneOffStore(at: secondPlace)

    #expect(second.oneOffs == OneOffs())

    let laterFirst = try OneOffStore(at: firstPlace)
    var expected = OneOffs()
    _ = expected.add(callMum)
    #expect(laterFirst.oneOffs == expected)
}

@Test("content that is not a one-off store is refused and left as it was")
func contentThatIsNotAOneOffStoreIsRefusedAndLeftAsItWas() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data("not a one-off store".utf8)
    try bytes.write(to: place)

    #expect(throws: OneOffStoreError.notAStore(at: place)) {
        try OneOffStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a one-off store written in a later form than this app knows is refused")
func aOneOffStoreWrittenInALaterFormThanThisAppKnowsIsRefused() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(#"{"version": 2, "oneOffs": []}"#.utf8)
    try bytes.write(to: place)

    #expect(throws: OneOffStoreError.laterForm(at: place, version: 2)) {
        try OneOffStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a one-off store holding what could not be a one-off is refused")
func aOneOffStoreHoldingWhatCouldNotBeAOneOffIsRefused() throws {
    let blankNamePlace = freshPlace()
    try FileManager.default.createDirectory(
        at: blankNamePlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let blankNameBytes = Data(
        """
        {
          "version": 1,
          "oneOffs": [
            { "name": "   ", "date": { "year": 2026, "month": 9, "day": 25 } }
          ]
        }
        """.utf8)
    try blankNameBytes.write(to: blankNamePlace)

    let noSuchDayPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: noSuchDayPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let noSuchDayBytes = Data(
        """
        {
          "version": 1,
          "oneOffs": [
            { "name": "Call mum", "date": { "year": 2026, "month": 2, "day": 30 } }
          ]
        }
        """.utf8)
    try noSuchDayBytes.write(to: noSuchDayPlace)

    let doneBeforeDatePlace = freshPlace()
    try FileManager.default.createDirectory(
        at: doneBeforeDatePlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let doneBeforeDateBytes = Data(
        """
        {
          "version": 1,
          "oneOffs": [
            {
              "name": "Call mum",
              "date": { "year": 2026, "month": 9, "day": 25 },
              "doneOn": { "year": 2026, "month": 9, "day": 24 }
            }
          ]
        }
        """.utf8)
    try doneBeforeDateBytes.write(to: doneBeforeDatePlace)

    let sameOneOffTwicePlace = freshPlace()
    try FileManager.default.createDirectory(
        at: sameOneOffTwicePlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let sameOneOffTwiceBytes = Data(
        """
        {
          "version": 1,
          "oneOffs": [
            { "name": "Call mum", "date": { "year": 2026, "month": 9, "day": 25 } },
            { "name": "Call mum", "date": { "year": 2026, "month": 9, "day": 25 } }
          ]
        }
        """.utf8)
    try sameOneOffTwiceBytes.write(to: sameOneOffTwicePlace)

    #expect(throws: OneOffStoreError.notAStore(at: blankNamePlace)) {
        try OneOffStore(at: blankNamePlace)
    }
    #expect(throws: OneOffStoreError.notAStore(at: noSuchDayPlace)) {
        try OneOffStore(at: noSuchDayPlace)
    }
    #expect(throws: OneOffStoreError.notAStore(at: doneBeforeDatePlace)) {
        try OneOffStore(at: doneBeforeDatePlace)
    }
    #expect(throws: OneOffStoreError.notAStore(at: sameOneOffTwicePlace)) {
        try OneOffStore(at: sameOneOffTwicePlace)
    }

    #expect(try Data(contentsOf: blankNamePlace) == blankNameBytes)
    #expect(try Data(contentsOf: noSuchDayPlace) == noSuchDayBytes)
    #expect(try Data(contentsOf: doneBeforeDatePlace) == doneBeforeDateBytes)
    #expect(try Data(contentsOf: sameOneOffTwicePlace) == sameOneOffTwiceBytes)
}
