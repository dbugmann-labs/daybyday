import Foundation
import Testing

@testable import DayByDayKit

private let friday = CalendarDate(year: 2026, month: 10, day: 2)!
private let thursday = CalendarDate(year: 2026, month: 10, day: 1)!
private let wednesday = CalendarDate(year: 2026, month: 9, day: 30)!

private func time(_ hour: Int, _ minute: Int) -> TimeOfDay {
    TimeOfDay(hour: hour, minute: minute)!
}

private func freshPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("happenings.json")
}

/// A `Happenings` holding the happenings named, in order.
private func holding(_ names: [String]) throws -> (Happenings, [Happening]) {
    var happenings = Happenings()
    var made: [Happening] = []
    for name in names {
        let happening = try #require(Happening(name: name))
        let added = happenings.add(happening)
        #expect(added)
        made.append(happening)
    }
    return (happenings, made)
}

@Test("an occurrence changed keeps its happening, its day and its place in the order noted")
func anOccurrenceChangedKeepsItsHappeningItsDayAndItsPlaceInTheOrderNoted() throws {
    var (happenings, made) = try holding(["Kopfweh"])
    let kopfweh = made[0]
    let first = Occurrence(of: kopfweh, on: friday, at: time(9, 10), saying: "links")
    let second = Occurrence(of: kopfweh, on: thursday, at: nil, saying: nil)
    let notedFirst = happenings.note(first)
    let notedSecond = happenings.note(second)
    #expect(notedFirst && notedSecond)

    let firstChanged = happenings.change(first, to: time(18, 40), saying: nil)
    #expect(firstChanged)

    let changed = Occurrence(of: kopfweh, on: friday, at: time(18, 40), saying: nil)
    #expect(happenings.occurrences == [changed, second])

    let changedAgain = happenings.change(changed, to: nil, saying: "  ")
    #expect(changedAgain)
    #expect(happenings.occurrences == [Occurrence(of: kopfweh, on: friday, at: nil, saying: nil), second])
    #expect(happenings.occurrences[0].note == nil)
}

@Test("of two occurrences alike, the earliest noted is the one changed")
func ofTwoOccurrencesAlikeTheEarliestNotedIsTheOneChanged() throws {
    var (happenings, made) = try holding(["Augenmigräne", "Kopfweh"])
    let augenmigraene = made[0]
    let kopfweh = made[1]
    let first = Occurrence(of: kopfweh, on: friday, at: time(18, 40), saying: nil)
    let middle = Occurrence(of: augenmigraene, on: friday, at: nil, saying: nil)
    for occurrence in [first, middle, first] {
        let noted = happenings.note(occurrence)
        #expect(noted)
    }

    let changed = happenings.change(first, to: time(9, 10), saying: nil)

    #expect(changed)
    #expect(
        happenings.occurrences == [
            Occurrence(of: kopfweh, on: friday, at: time(9, 10), saying: nil), middle, first,
        ])
}

@Test("changing an occurrence not held is refused, and a change to what it holds changes nothing")
func changingAnOccurrenceNotHeldIsRefusedAndAChangeToWhatItHoldsChangesNothing() throws {
    var (happenings, made) = try holding(["Kopfweh"])
    let kopfweh = made[0]
    let held = Occurrence(of: kopfweh, on: friday, at: time(9, 10), saying: "links")
    let noted = happenings.note(held)
    #expect(noted)
    let before = happenings

    let notHeld = Occurrence(of: kopfweh, on: friday, at: time(9, 11), saying: "links")
    let refused = happenings.change(notHeld, to: time(18, 40), saying: nil)
    #expect(!refused)
    #expect(happenings == before)

    let same = happenings.change(held, to: time(9, 10), saying: "links")
    #expect(same)
    #expect(happenings == before)
}

@Test("an occurrence taken back is removed once, and the rest keep their order")
func anOccurrenceTakenBackIsRemovedOnceAndTheRestKeepTheirOrder() throws {
    var (happenings, made) = try holding(["Augenmigräne", "Kopfweh"])
    let augenmigraene = made[0]
    let kopfweh = made[1]
    let first = Occurrence(of: kopfweh, on: friday, at: time(18, 40), saying: nil)
    let middle = Occurrence(of: augenmigraene, on: friday, at: nil, saying: nil)
    for occurrence in [first, middle, first] {
        let noted = happenings.note(occurrence)
        #expect(noted)
    }

    let takenBack = happenings.takeBack(first)

    #expect(takenBack)
    #expect(happenings.occurrences == [middle, first])

    let bothGone = happenings.takeBack(first)
    let middleGone = happenings.takeBack(middle)
    #expect(bothGone && middleGone)
    #expect(happenings.occurrences.isEmpty)
    #expect(happenings.all == [augenmigraene, kopfweh])
}

@Test("taking back an occurrence not held is refused and changes nothing")
func takingBackAnOccurrenceNotHeldIsRefusedAndChangesNothing() throws {
    var (happenings, made) = try holding(["Kopfweh"])
    let kopfweh = made[0]
    let noted = happenings.note(Occurrence(of: kopfweh, on: friday, at: time(9, 10), saying: "links"))
    #expect(noted)
    let before = happenings

    let refused = happenings.takeBack(Occurrence(of: kopfweh, on: friday, at: time(9, 10), saying: nil))

    #expect(!refused)
    #expect(happenings == before)
}

@Test("a happening store opened again holds the occurrences as changed and taken back")
func aHappeningStoreOpenedAgainHoldsTheOccurrencesAsChangedAndTakenBack() throws {
    let place = freshPlace()
    let kopfweh = try #require(Happening(name: "Kopfweh"))
    let first = try HappeningStore(at: place)
    try first.add(kopfweh)
    let one = Occurrence(of: kopfweh, on: friday, at: time(9, 10), saying: "links")
    let two = Occurrence(of: kopfweh, on: friday, at: time(18, 40), saying: nil)
    let three = Occurrence(of: kopfweh, on: wednesday, at: nil, saying: nil)
    for occurrence in [one, two, three] {
        try first.note(occurrence)
    }

    try first.change(one, to: time(8, 0), saying: nil)
    try first.takeBack(two)

    let second = try HappeningStore(at: place)
    #expect(
        second.happenings.occurrences == [
            Occurrence(of: kopfweh, on: friday, at: time(8, 0), saying: nil), three,
        ])
    withExtendedLifetime(first) {}
}

@Test("a change or a take-back the happening store cannot keep is refused and not held")
func aChangeOrATakeBackTheHappeningStoreCannotKeepIsRefusedAndNotHeld() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let place = directory.appendingPathComponent("happenings.json")
    let kopfweh = try #require(Happening(name: "Kopfweh"))
    let store = try HappeningStore(at: place)
    try store.add(kopfweh)
    let held = Occurrence(of: kopfweh, on: friday, at: time(9, 10), saying: nil)
    try store.note(held)
    let kept = try Data(contentsOf: place)
    let before = store.happenings

    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
    defer {
        try? FileManager.default.setAttributes(
            [.posixPermissions: 0o700], ofItemAtPath: directory.path)
    }

    #expect(throws: HappeningStoreError.cannotWrite(at: place)) {
        try store.change(held, to: time(18, 40), saying: nil)
    }
    #expect(store.happenings == before)
    #expect(store.happenings.occurrences == [held])
    #expect(throws: HappeningStoreError.cannotWrite(at: place)) {
        try store.takeBack(held)
    }
    #expect(store.happenings.occurrences == [held])

    let notHeld = Occurrence(of: kopfweh, on: friday, at: time(11, 11), saying: nil)
    let changed = try store.change(notHeld, to: time(12, 0), saying: nil)
    let takenBack = try store.takeBack(notHeld)
    #expect(!changed && !takenBack)
    #expect(try Data(contentsOf: place) == kept)
}
