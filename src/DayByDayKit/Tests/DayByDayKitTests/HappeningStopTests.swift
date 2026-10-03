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

@Test(
    "a happening stopped keeps its name, its place and its occurrences, and resumed is stopped no longer"
)
func aHappeningStoppedKeepsItsNameItsPlaceAndItsOccurrencesAndResumedIsStoppedNoLonger() throws {
    var (happenings, made) = try holding(["Augenmigräne", "Kopfweh", "Schlecht geschlafen"])
    let kopfweh = made[1]
    let noted = Occurrence(of: kopfweh, on: friday, at: time(9, 10), saying: nil)
    let notedOne = happenings.note(noted)
    #expect(notedOne)

    let stopped = happenings.stop(kopfweh)
    #expect(stopped)

    #expect(happenings.isStopped(kopfweh))
    #expect(!happenings.isStopped(made[0]))
    #expect(!happenings.isStopped(made[2]))
    #expect(happenings.all.map(\.name) == ["Augenmigräne", "Kopfweh", "Schlecht geschlafen"])
    #expect(happenings.occurrences == [noted])

    let resumed = happenings.resume(kopfweh)
    #expect(resumed)
    #expect(!happenings.isStopped(kopfweh))
    #expect(happenings.all[1] == kopfweh)
}

@Test(
    "a stopped happening takes no occurrence noted, and its occurrences are still changed and taken back"
)
func aStoppedHappeningTakesNoOccurrenceNotedAndItsOccurrencesAreStillChangedAndTakenBack() throws {
    var (happenings, made) = try holding(["Kopfweh"])
    let kopfweh = made[0]
    let morning = Occurrence(of: kopfweh, on: friday, at: time(9, 10), saying: nil)
    let notedMorning = happenings.note(morning)
    #expect(notedMorning)
    let stopped = happenings.stop(kopfweh)
    #expect(stopped)

    let notedEvening = happenings.note(Occurrence(of: kopfweh, on: friday, at: time(18, 40), saying: nil))

    #expect(!notedEvening)
    #expect(happenings.occurrences == [morning])
    let changed = happenings.change(morning, to: time(8, 0), saying: "links")
    #expect(changed)
    let taken = happenings.takeBack(
        Occurrence(of: kopfweh, on: friday, at: time(8, 0), saying: "links"))
    #expect(taken)
    #expect(happenings.occurrences.isEmpty)
    #expect(happenings.all == [kopfweh])
    #expect(happenings.isStopped(kopfweh))
}

@Test(
    "a stopped happening's name refuses another's, and a stopped happening renamed stays stopped")
func aStoppedHappeningsNameRefusesAnothersAndAStoppedHappeningRenamedStaysStopped() throws {
    var (happenings, made) = try holding(["Kopfweh"])
    let kopfweh = made[0]
    let stopped = happenings.stop(kopfweh)
    #expect(stopped)

    let lower = try #require(Happening(name: "kopfweh"))
    let addedAlike = happenings.add(lower)
    #expect(!addedAlike)

    let renamed = happenings.rename(kopfweh, to: "Spannungskopfweh")
    #expect(renamed)
    #expect(happenings.isStopped(kopfweh))

    let again = try #require(Happening(name: "Kopfweh"))
    let addedAgain = happenings.add(again)
    #expect(addedAgain)
    #expect(!happenings.isStopped(again))
}

@Test(
    "stopping a stopped happening, resuming one not stopped, or either of one not held is refused and changes nothing"
)
func stoppingAStoppedHappeningResumingOneNotStoppedOrEitherOfOneNotHeldIsRefusedAndChangesNothing()
    throws
{
    var (happenings, made) = try holding(["Augenmigräne", "Kopfweh"])
    let stopped = happenings.stop(made[1])
    #expect(stopped)
    let before = happenings

    let stoppedAgain = happenings.stop(made[1])
    #expect(!stoppedAgain)
    #expect(happenings == before)

    let resumedNotStopped = happenings.resume(made[0])
    #expect(!resumedNotStopped)
    #expect(happenings == before)

    let notHeld = try #require(Happening(name: "Schlecht geschlafen"))
    let stoppedNotHeld = happenings.stop(notHeld)
    let resumedNotHeld = happenings.resume(notHeld)
    #expect(!stoppedNotHeld)
    #expect(!resumedNotHeld)
    #expect(happenings == before)
}

@Test("a happening deleted takes every occurrence of it and leaves the rest in their order")
func aHappeningDeletedTakesEveryOccurrenceOfItAndLeavesTheRestInTheirOrder() throws {
    var (happenings, made) = try holding(["Augenmigräne", "Kopfweh", "Schlecht geschlafen"])
    let augenmigraene = made[0]
    let kopfweh = made[1]
    let schlecht = made[2]
    let evening = happenings.note(Occurrence(of: kopfweh, on: friday, at: time(18, 40), saying: nil))
    let eye = Occurrence(of: augenmigraene, on: thursday, at: nil, saying: nil)
    let noted = happenings.note(eye)
    let earlier = happenings.note(Occurrence(of: kopfweh, on: wednesday, at: nil, saying: nil))
    #expect(evening && noted && earlier)

    let deleted = happenings.delete(kopfweh)

    #expect(deleted)
    #expect(happenings.all == [augenmigraene, schlecht])
    #expect(happenings.occurrences == [eye])
    let lower = try #require(Happening(name: "kopfweh"))
    let addedLower = happenings.add(lower)
    #expect(addedLower)
    let stoppedSchlecht = happenings.stop(schlecht)
    let deletedSchlecht = happenings.delete(schlecht)
    #expect(stoppedSchlecht && deletedSchlecht)
    #expect(happenings.all == [augenmigraene, lower])
}

@Test("deleting a happening not held is refused and changes nothing")
func deletingAHappeningNotHeldIsRefusedAndChangesNothing() throws {
    var (happenings, made) = try holding(["Kopfweh"])
    let kopfweh = made[0]
    let morning = Occurrence(of: kopfweh, on: friday, at: time(9, 10), saying: nil)
    let noted = happenings.note(morning)
    #expect(noted)
    let before = happenings

    let sameName = try #require(Happening(name: "Kopfweh"))
    let deletedOther = happenings.delete(sameName)
    #expect(!deletedOther)
    #expect(happenings == before)

    let deleted = happenings.delete(kopfweh)
    let deletedTwice = happenings.delete(kopfweh)
    #expect(deleted)
    #expect(!deletedTwice)
    let notedAgain = happenings.note(morning)
    #expect(!notedAgain)
}

@Test("a happening store opened again holds the happenings as stopped, resumed and deleted")
func aHappeningStoreOpenedAgainHoldsTheHappeningsAsStoppedResumedAndDeleted() throws {
    let place = freshPlace()
    let augenmigraene = try #require(Happening(name: "Augenmigräne"))
    let kopfweh = try #require(Happening(name: "Kopfweh"))
    let schlecht = try #require(Happening(name: "Schlecht geschlafen"))

    let first = try HappeningStore(at: place)
    for happening in [augenmigraene, kopfweh, schlecht] {
        try first.add(happening)
    }
    let morning = Occurrence(of: kopfweh, on: friday, at: time(9, 10), saying: nil)
    try first.note(morning)
    try first.note(Occurrence(of: augenmigraene, on: thursday, at: nil, saying: nil))
    try first.stop(kopfweh)
    try first.stop(schlecht)
    try first.resume(schlecht)
    try first.delete(augenmigraene)

    let second = try HappeningStore(at: place)

    #expect(second.happenings.all == [kopfweh, schlecht])
    #expect(second.happenings.isStopped(kopfweh))
    #expect(!second.happenings.isStopped(schlecht))
    #expect(second.happenings.occurrences == [morning])
    #expect(second.happenings == first.happenings)
}

@Test("a stop, a resume or a deletion the happening store cannot keep is refused and not held")
func aStopAResumeOrADeletionTheHappeningStoreCannotKeepIsRefusedAndNotHeld() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let place = directory.appendingPathComponent("happenings.json")
    let augenmigraene = try #require(Happening(name: "Augenmigräne"))
    let kopfweh = try #require(Happening(name: "Kopfweh"))

    let store = try HappeningStore(at: place)
    try store.add(augenmigraene)
    try store.add(kopfweh)
    try store.stop(kopfweh)
    let eye = Occurrence(of: augenmigraene, on: friday, at: time(9, 10), saying: nil)
    try store.note(eye)

    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
    #expect(throws: HappeningStoreError.cannotWrite(at: place)) {
        try store.stop(augenmigraene)
    }
    #expect(!store.happenings.isStopped(augenmigraene))
    #expect(throws: HappeningStoreError.cannotWrite(at: place)) {
        try store.resume(kopfweh)
    }
    #expect(store.happenings.isStopped(kopfweh))
    #expect(throws: HappeningStoreError.cannotWrite(at: place)) {
        try store.delete(augenmigraene)
    }
    #expect(store.happenings.all.contains(augenmigraene))
    #expect(store.happenings.occurrences == [eye])
    try FileManager.default.setAttributes([.posixPermissions: 0o700], ofItemAtPath: directory.path)

    let before = try Data(contentsOf: place)
    let stoppedAgain = try store.stop(kopfweh)
    #expect(!stoppedAgain)
    #expect(try Data(contentsOf: place) == before)
}

@Test("a happening store in an earlier form is read as holding no happening stopped")
func aHappeningStoreInAnEarlierFormIsReadAsHoldingNoHappeningStopped() throws {
    let valid = "6F1B0F3E-0C1D-4F57-9A77-1B2E3C4D5E6F"
    let secondForm = Data(
        #"""
        {"version": 2, "happenings": [{"identity": "\#(valid)", "name": "Kopfweh"}], "occurrences": [{"happening": "\#(valid)", "day": {"year": 2026, "month": 10, "day": 2}}]}
        """#.utf8)
    let firstForm = Data(
        #"{"version": 1, "happenings": [{"identity": "\#(valid)", "name": "Kopfweh"}]}"#.utf8)

    let place = try placeHolding(secondForm)
    let opened = try HappeningStore(at: place)
    let kopfweh = try #require(opened.happenings.all.first)

    #expect(kopfweh.name == "Kopfweh")
    #expect(!opened.happenings.isStopped(kopfweh))
    #expect(opened.happenings.occurrences == [Occurrence(of: kopfweh, on: friday, at: nil, saying: nil)])
    #expect(try Data(contentsOf: place) == secondForm)

    let firstPlace = try placeHolding(firstForm)
    let firstOpened = try HappeningStore(at: firstPlace)
    let firstKopfweh = try #require(firstOpened.happenings.all.first)
    #expect(!firstOpened.happenings.isStopped(firstKopfweh))
    #expect(try Data(contentsOf: firstPlace) == firstForm)

    try opened.stop(kopfweh)
    let again = try HappeningStore(at: place)
    #expect(again.happenings.isStopped(try #require(again.happenings.all.first)))
    #expect(
        again.happenings.occurrences
            == [Occurrence(of: kopfweh, on: friday, at: nil, saying: nil)])
}

private func placeHolding(_ bytes: Data) throws -> URL {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try bytes.write(to: place)
    return place
}
