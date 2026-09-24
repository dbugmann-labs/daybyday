import Foundation
import Testing

@testable import DayByDayKit

/// A fresh roster place, record place and one-off place, three sibling files under one fresh
/// temporary directory — mirrors `CommitmentsScreenTests.swift`'s own
/// `freshRosterAndRecordPlaces()`, widened to the third place `makeACopy` reads. Nothing is
/// created until something writes to one of the three.
private func freshThreePlaces() -> (roster: URL, record: URL, oneOffs: URL) {
    let base = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    return (
        base.appendingPathComponent("roster.json"),
        base.appendingPathComponent("record.json"),
        base.appendingPathComponent("one-offs.json")
    )
}

/// A fresh directory of its own for a copy to be written into — "a directory of its own" in
/// every scenario below — not created until `makeACopy` itself creates it.
private func freshCopyDirectory() -> URL {
    FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
}

private let allWeekdays: Schedule = .weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])

@MainActor
@Test("a copy holds the history, the roster and the one-offs the three places hold")
func aCopyHoldsTheHistoryTheRosterAndTheOneOffsTheThreePlacesHold() throws {
    let places = freshThreePlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let bookDentist = OneOff(
        name: "Book dentist", date: CalendarDate(year: 2026, month: 9, day: 25)!)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: august30th)!)
    let oneOffStore = try OneOffStore(at: places.oneOffs)
    try oneOffStore.add(bookDentist)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    let rosterBytes = try Data(contentsOf: places.roster)
    let recordBytes = try Data(contentsOf: places.record)
    let oneOffBytes = try Data(contentsOf: places.oneOffs)

    let result = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())

    guard case .success(let url) = result else {
        Issue.record("expected a copy to be made")
        return
    }
    let copy = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: url)).formCopy())

    #expect(copy.roster.entries.map(\.commitment.name) == ["Gym"])
    #expect(copy.history.isKept(gym, on: august30th))
    #expect(copy.oneOffs.entries.map(\.oneOff.name) == ["Book dentist"])
    #expect(copy.oneOffs.entries.map(\.oneOff.date) == [bookDentist.date])

    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    #expect(try Data(contentsOf: places.record) == recordBytes)
    #expect(try Data(contentsOf: places.oneOffs) == oneOffBytes)
}

@MainActor
@Test("a copy of three places where nothing has been kept is made and holds nothing")
func aCopyOfThreePlacesWhereNothingHasBeenKeptIsMadeAndHoldsNothing() throws {
    let places = freshThreePlaces()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    let result = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())

    guard case .success(let url) = result else {
        Issue.record("expected a copy to be made")
        return
    }
    let copy = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: url)).formCopy())

    #expect(copy.roster == Roster())
    #expect(copy.history == History())
    #expect(copy.oneOffs == OneOffs())

    #expect(!FileManager.default.fileExists(atPath: places.roster.path))
    #expect(!FileManager.default.fileExists(atPath: places.record.path))
    #expect(!FileManager.default.fileExists(atPath: places.oneOffs.path))
}

@MainActor
@Test(
    "a copy is formed from what the places hold when it is asked for, not from what a screen read"
)
func aCopyIsFormedFromWhatThePlacesHoldWhenItIsAskedForNotFromWhatAScreenRead() throws {
    let places = freshThreePlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: allWeekdays, keptFrom: keptFrom)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    // Taken on by something other than the screen — a second store opened at the same place.
    let otherRosterStore = try RosterStore(at: places.roster)
    try otherRosterStore.add(journaling)

    let result = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())

    guard case .success(let url) = result else {
        Issue.record("expected a copy to be made")
        return
    }
    let copy = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: url)).formCopy())

    #expect(copy.roster.entries.map(\.commitment.name) == ["Gym", "Journaling"])
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a copy taken where a save was torn holds what undoing the torn save leaves")
func aCopyTakenWhereASaveWasTornHoldsWhatUndoingTheTornSaveLeaves() throws {
    let places = freshThreePlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let gymEmoji = Commitment(name: "Gym 🏋️", schedule: allWeekdays, keptFrom: keptFrom)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gymEmoji, on: august3rd)!)
    try SaveInProgress(carriedFrom: gym, to: gymEmoji).keep(
        at: SaveInProgress.place(besideRecordAt: places.record))

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    let result = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())

    guard case .success(let url) = result else {
        Issue.record("expected a copy to be made")
        return
    }
    let copy = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: url)).formCopy())

    #expect(copy.history.isKept(gym, on: august3rd))
    #expect(!copy.history.isKept(gymEmoji, on: august3rd))
    #expect(
        !FileManager.default.fileExists(
            atPath: SaveInProgress.place(besideRecordAt: places.record).path))
}

@MainActor
@Test("a copy is refused whole where one of the three places cannot be read")
func aCopyIsRefusedWholeWhereOneOfTheThreePlacesCannotBeRead() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    // The record place cannot be read.
    do {
        let places = freshThreePlaces()
        let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
        let bookDentist = OneOff(
            name: "Book dentist", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
        let rosterStore = try RosterStore(at: places.roster)
        try rosterStore.add(gym)
        let oneOffStore = try OneOffStore(at: places.oneOffs)
        try oneOffStore.add(bookDentist)

        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)

        try FileManager.default.createDirectory(
            at: places.record.deletingLastPathComponent(), withIntermediateDirectories: true)
        try Data("not what a record is written as".utf8).write(to: places.record)

        let directory = freshCopyDirectory()
        let result = screen.makeACopy(
            asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: directory)

        guard case .failure(let refusal) = result else {
            Issue.record("expected a copy to be refused")
            return
        }
        #expect(refusal == .storeCouldNotBeRead)
        #expect(screen.refusedChange == .makingACopy(.record, .storeCouldNotBeRead))
        #expect(!FileManager.default.fileExists(atPath: directory.path))
    }

    // The roster place, rather than the record place, cannot be read.
    do {
        let places = freshThreePlaces()
        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)

        try FileManager.default.createDirectory(
            at: places.roster.deletingLastPathComponent(), withIntermediateDirectories: true)
        try Data("not what a roster is written as".utf8).write(to: places.roster)

        let result = screen.makeACopy(
            asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())

        guard case .failure(let refusal) = result else {
            Issue.record("expected a copy to be refused")
            return
        }
        #expect(refusal == .storeCouldNotBeRead)
        #expect(screen.refusedChange == .makingACopy(.roster, .storeCouldNotBeRead))
    }

    // The one-off place cannot be read.
    do {
        let places = freshThreePlaces()
        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)

        try FileManager.default.createDirectory(
            at: places.oneOffs.deletingLastPathComponent(), withIntermediateDirectories: true)
        try Data("not what a one-off holder is written as".utf8).write(to: places.oneOffs)

        let result = screen.makeACopy(
            asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())

        guard case .failure(let refusal) = result else {
            Issue.record("expected a copy to be refused")
            return
        }
        #expect(refusal == .storeCouldNotBeRead)
        #expect(screen.refusedChange == .makingACopy(.oneOffs, .storeCouldNotBeRead))
    }
}

@MainActor
@Test(
    "a copy refused with more than one place unreadable names the record before the roster and the roster before the one-offs"
)
func aCopyRefusedWithMoreThanOnePlaceUnreadableNamesTheRecordBeforeTheRosterAndTheRosterBeforeTheOneOffs()
    throws
{
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    // All three unreadable: named the record.
    do {
        let places = freshThreePlaces()
        try FileManager.default.createDirectory(
            at: places.roster.deletingLastPathComponent(), withIntermediateDirectories: true)
        try Data("not what a roster is written as".utf8).write(to: places.roster)
        try Data("not what a record is written as".utf8).write(to: places.record)
        try Data("not what a one-off holder is written as".utf8).write(to: places.oneOffs)

        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)

        let result = screen.makeACopy(
            asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())

        guard case .failure(let refusal) = result else {
            Issue.record("expected a copy to be refused")
            return
        }
        #expect(refusal == .storeCouldNotBeRead)
        #expect(screen.refusedChange == .makingACopy(.record, .storeCouldNotBeRead))
    }

    // The record place can be read; the roster and the one-off places cannot: named the roster.
    do {
        let places = freshThreePlaces()
        try FileManager.default.createDirectory(
            at: places.roster.deletingLastPathComponent(), withIntermediateDirectories: true)
        try Data("not what a roster is written as".utf8).write(to: places.roster)
        try Data("not what a one-off holder is written as".utf8).write(to: places.oneOffs)

        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)

        let result = screen.makeACopy(
            asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())

        guard case .failure(let refusal) = result else {
            Issue.record("expected a copy to be refused")
            return
        }
        #expect(refusal == .storeCouldNotBeRead)
        #expect(screen.refusedChange == .makingACopy(.roster, .storeCouldNotBeRead))
    }

    // The record and the roster places can be read; the one-off place cannot: named the one-offs.
    do {
        let places = freshThreePlaces()
        try FileManager.default.createDirectory(
            at: places.oneOffs.deletingLastPathComponent(), withIntermediateDirectories: true)
        try Data("not what a one-off holder is written as".utf8).write(to: places.oneOffs)

        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)

        let result = screen.makeACopy(
            asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())

        guard case .failure(let refusal) = result else {
            Issue.record("expected a copy to be refused")
            return
        }
        #expect(refusal == .storeCouldNotBeRead)
        #expect(screen.refusedChange == .makingACopy(.oneOffs, .storeCouldNotBeRead))
    }
}

@MainActor
@Test("a copy carries the moment it was handed, and the places it was read from carry none")
func aCopyCarriesTheMomentItWasHandedAndThePlacesItWasReadFromCarryNone() throws {
    let places = freshThreePlaces()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    let first = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
    guard case .success(let firstURL) = first else {
        Issue.record("expected a copy to be made")
        return
    }
    let firstCopy = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: firstURL)).formCopy())
    #expect(firstCopy.moment == Moment(on: monday, hour: 14, minute: 32)!)

    let second = screen.makeACopy(
        asOf: Moment(on: monday, hour: 9, minute: 7)!, writingInto: freshCopyDirectory())
    guard case .success(let secondURL) = second else {
        Issue.record("expected a copy to be made")
        return
    }
    let secondCopy = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: secondURL)).formCopy())
    #expect(secondCopy.moment == Moment(on: monday, hour: 9, minute: 7)!)

    #expect(!FileManager.default.fileExists(atPath: places.roster.path))
    #expect(!FileManager.default.fileExists(atPath: places.record.path))
    #expect(!FileManager.default.fileExists(atPath: places.oneOffs.path))
}

@Test("a moment is refused where its hour or its minute is not one the clock has")
func aMomentIsRefusedWhereItsHourOrItsMinuteIsNotOneTheClockHas() {
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    #expect(Moment(on: monday, hour: 24, minute: 0) == nil)
    #expect(Moment(on: monday, hour: 0, minute: 60) == nil)
    #expect(Moment(on: monday, hour: -1, minute: 0) == nil)
    #expect(Moment(on: monday, hour: 0, minute: -1) == nil)

    #expect(Moment(on: monday, hour: 23, minute: 59) != nil)
    #expect(Moment(on: monday, hour: 0, minute: 0) != nil)
}

@MainActor
@Test(
    "what is written for a copy holds its own form, its moment and the three stores as they are written now"
)
func whatIsWrittenForACopyHoldsItsOwnFormItsMomentAndTheThreeStoresAsTheyAreWrittenNow() throws {
    let places = freshThreePlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: august30th)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    let result = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())

    guard case .success(let url) = result else {
        Issue.record("expected a copy to be made")
        return
    }
    let copyDocument = try JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: url))

    #expect(copyDocument.version == CopyDocument.currentVersion)
    #expect(copyDocument.record.version == RecordDocument.currentVersion)
    #expect(copyDocument.roster.version == RosterDocument.currentVersion)
    #expect(copyDocument.oneOffs.version == OneOffDocument.currentVersion)

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys]

    // What is held for each store is exactly what that store writes at its own place for the
    // same value: byte-identical, since both go through the same byte-stable encoder over the
    // same document shape.
    #expect(try encoder.encode(copyDocument.record) == Data(contentsOf: places.record))
    #expect(try encoder.encode(copyDocument.roster) == Data(contentsOf: places.roster))
    #expect(try encoder.encode(copyDocument.oneOffs) == encoder.encode(OneOffDocument(OneOffs())))
}

// The two unit tests below are `openspec/changes/put-done-one-offs-last/tasks.md` § 4.3's own:
// a copy carries the tick order because it nests `OneOffDocument` as written, with no copy code
// of its own (`design.md` § *A copy carries it with no delta of its own*) — proved here by a real
// encode-decode round trip through `CopyDocument`, never by comparing values that were never
// serialized.

@Test("a copy formed from one-offs with two ticks reads back as equal one-offs")
func aCopyFormedFromOneOffsWithTwoTicksReadsBackAsEqualOneOffs() throws {
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 20)!)!
    let payFine = OneOff(name: "Pay fine", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    let september28 = CalendarDate(year: 2026, month: 9, day: 28)!

    var oneOffs = OneOffs()
    _ = oneOffs.add(callMum)
    _ = oneOffs.add(payFine)
    _ = oneOffs.tick(callMum, on: september28)
    _ = oneOffs.tick(payFine, on: september28)

    let copy = Copy(
        moment: Moment(on: september28, hour: 9, minute: 0)!, history: History(), roster: Roster(),
        oneOffs: oneOffs)
    let data = try JSONEncoder().encode(CopyDocument(copy))
    let formed = try #require(JSONDecoder().decode(CopyDocument.self, from: data).formCopy())

    #expect(formed.oneOffs == oneOffs)
}

@Test(
    "a copy nesting form-1 one-offs reads back with the order this app draws for ticks from before the tick order was kept"
)
func aCopyNestingForm1OneOffsReadsBackWithTheOrderThisAppDrawsForTicksFromBeforeTheTickOrderWasKept()
    throws
{
    let september28 = CalendarDate(year: 2026, month: 9, day: 28)!

    // The same four one-offs, in the same document order, `OneOffStoreTests.swift`'s "a one-off
    // store kept before the tick order..." (task 4.1) reads directly — carried here inside a
    // copy instead, at form 1, to prove the copy nests the document as written rather than
    // deriving anything of its own.
    let payFine = OneOffEntryRecord(
        name: "Pay fine", date: DateRecord(CalendarDate(year: 2026, month: 9, day: 25)!),
        doneOn: DateRecord(september28), tick: nil)
    let callMum = OneOffEntryRecord(
        name: "Call mum", date: DateRecord(CalendarDate(year: 2026, month: 9, day: 20)!),
        doneOn: DateRecord(september28), tick: nil)
    let bookDentist = OneOffEntryRecord(
        name: "Book dentist", date: DateRecord(CalendarDate(year: 2026, month: 9, day: 20)!),
        doneOn: DateRecord(september28), tick: nil)
    let sendForm = OneOffEntryRecord(
        name: "Send form", date: DateRecord(CalendarDate(year: 2026, month: 9, day: 26)!),
        doneOn: nil, tick: nil)

    var oneOffDocument = OneOffDocument(OneOffs())
    oneOffDocument.version = 1
    oneOffDocument.oneOffs = [payFine, callMum, bookDentist, sendForm]

    var copyDocument = CopyDocument(
        Copy(
            moment: Moment(on: september28, hour: 9, minute: 0)!, history: History(),
            roster: Roster(), oneOffs: OneOffs()))
    copyDocument.oneOffs = oneOffDocument

    let data = try JSONEncoder().encode(copyDocument)
    let formed = try #require(JSONDecoder().decode(CopyDocument.self, from: data).formCopy())

    #expect(
        formed.oneOffs.standing(on: september28, asOf: september28).map(\.name)
            == ["Send form", "Call mum", "Book dentist", "Pay fine"])
}

@MainActor
@Test("a copy of a place kept in an earlier form is written in the form that store writes now")
func aCopyOfAPlaceKeptInAnEarlierFormIsWrittenInTheFormThatStoreWritesNow() throws {
    let places = freshThreePlaces()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    try FileManager.default.createDirectory(
        at: places.roster.deletingLastPathComponent(), withIntermediateDirectories: true)

    let rosterBytes = Data(
        """
        {
          "version": 1,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": {
                  "weekdays": [
                    "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"
                  ]
                }
              }
            }
          ]
        }
        """.utf8)
    try rosterBytes.write(to: places.roster)

    let recordBytes = Data(
        """
        {
          "version": 1,
          "ticks": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": {
                  "weekdays": [
                    "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"
                  ]
                }
              },
              "date": { "year": 2026, "month": 8, "day": 30 }
            }
          ]
        }
        """.utf8)
    try recordBytes.write(to: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    let rosterBytesAfterOpen = try Data(contentsOf: places.roster)
    let recordBytesAfterOpen = try Data(contentsOf: places.record)

    let result = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())

    guard case .success(let url) = result else {
        Issue.record("expected a copy to be made")
        return
    }
    let copyDocument = try JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: url))

    #expect(copyDocument.roster.version == RosterDocument.currentVersion)
    #expect(copyDocument.record.version == RecordDocument.currentVersion)

    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!

    #expect(copyDocument.roster.formRoster()?.roster.entries.map(\.commitment.name) == ["Gym"])
    #expect(
        copyDocument.record.formTicks()?.contains {
            $0.commitment.name == "Gym" && $0.date == august30th
        } == true)

    #expect(try Data(contentsOf: places.roster) == rosterBytesAfterOpen)
    #expect(try Data(contentsOf: places.record) == recordBytesAfterOpen)
}

@MainActor
@Test("a commitments screen asked for a copy writes one file and answers where it wrote it")
func aCommitmentsScreenAskedForACopyWritesOneFileAndAnswersWhereItWroteIt() throws {
    let places = freshThreePlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    let directory = freshCopyDirectory()
    let result = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: directory)

    guard case .success(let url) = result else {
        Issue.record("expected a copy to be made")
        return
    }

    #expect(FileManager.default.fileExists(atPath: url.path))
    let contents = try FileManager.default.contentsOfDirectory(atPath: directory.path)
    #expect(contents == [url.lastPathComponent])
}

@MainActor
@Test(
    "a copy made leaves a commitments screen's lists and what it is awaiting exactly as they were"
)
func aCopyMadeLeavesACommitmentsScreensListsAndWhatItIsAwaitingExactlyAsTheyWere() throws {
    let places = freshThreePlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: allWeekdays, keptFrom: keptFrom)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.retire(journaling, keptUntil: august30th)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
    screen.askToDelete(gym)
    screen.nameTypedBack = "Gym"

    let result = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
    guard case .success = result else {
        Issue.record("expected a copy to be made")
        return
    }

    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.map(\.name) == ["Journaling"])
    #expect(screen.awaitingDeletion == gym)
    #expect(screen.nameTypedBack == "Gym")
    #expect(screen.awaitingConfirmation == nil)
}

@MainActor
@Test("a commitments screen that cannot read its roster is still asked for a copy")
func aCommitmentsScreenThatCannotReadItsRosterIsStillAskedForACopy() throws {
    let places = freshThreePlaces()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    try FileManager.default.createDirectory(
        at: places.roster.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a roster is written as".utf8).write(to: places.roster)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    #expect(screen.rosterState == .notKept)

    let result = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())

    guard case .failure(let refusal) = result else {
        Issue.record("expected a copy to be refused")
        return
    }
    #expect(refusal == .storeCouldNotBeRead)
    #expect(screen.refusedChange == .makingACopy(.roster, .storeCouldNotBeRead))
}

@MainActor
@Test("a copy's name says the day and the minute it was made, each part padded")
func aCopysNameSaysTheDayAndTheMinuteItWasMadeEachPartPadded() throws {
    let places = freshThreePlaces()
    let january5th = CalendarDate(year: 2026, month: 1, day: 5)!
    let august31st = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(
        asOf: january5th, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    let directory = freshCopyDirectory()

    let first = screen.makeACopy(
        asOf: Moment(on: january5th, hour: 9, minute: 7)!, writingInto: directory)
    guard case .success(let firstURL) = first else {
        Issue.record("expected a copy to be made")
        return
    }
    #expect(firstURL.lastPathComponent == "DayByDay 2026-01-05 09.07.daybyday")

    let second = screen.makeACopy(
        asOf: Moment(on: august31st, hour: 14, minute: 32)!, writingInto: directory)
    guard case .success(let secondURL) = second else {
        Issue.record("expected a copy to be made")
        return
    }
    #expect(secondURL.lastPathComponent == "DayByDay 2026-08-31 14.32.daybyday")
}

@MainActor
@Test("a copy written where a copy of that name already stands replaces it")
func aCopyWrittenWhereACopyOfThatNameAlreadyStandsReplacesIt() throws {
    let places = freshThreePlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let moment = Moment(on: monday, hour: 14, minute: 32)!

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    let directory = freshCopyDirectory()
    let first = screen.makeACopy(asOf: moment, writingInto: directory)
    guard case .success(let firstURL) = first else {
        Issue.record("expected a copy to be made")
        return
    }

    let refusal = screen.define(
        name: "Gym", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: keptFrom, under: nil)
    #expect(refusal == nil)

    let second = screen.makeACopy(asOf: moment, writingInto: directory)
    guard case .success(let secondURL) = second else {
        Issue.record("expected a copy to be made")
        return
    }

    #expect(firstURL == secondURL)
    let contents = try FileManager.default.contentsOfDirectory(atPath: directory.path)
    #expect(contents == [secondURL.lastPathComponent])

    let copy = try #require(
        JSONDecoder().decode(CopyDocument.self, from: Data(contentsOf: secondURL)).formCopy())
    #expect(copy.roster.entries.map(\.commitment.name) == ["Gym"])
}

@MainActor
@Test("a copy that cannot be written is refused as a place that could not be written")
func aCopyThatCannotBeWrittenIsRefusedAsAPlaceThatCouldNotBeWritten() throws {
    let places = freshThreePlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let rosterBytes = try Data(contentsOf: places.roster)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    let directory = freshCopyDirectory()
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
    defer {
        try? FileManager.default.setAttributes(
            [.posixPermissions: 0o700], ofItemAtPath: directory.path)
    }

    let result = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: directory)

    guard case .failure(let refusal) = result else {
        Issue.record("expected a copy to be refused")
        return
    }
    #expect(refusal == .notKept)
    #expect(refusal != .storeCouldNotBeRead)
    #expect(screen.refusedChange == .makingACopy(nil, .notKept))
    #expect(try FileManager.default.contentsOfDirectory(atPath: directory.path).isEmpty)
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
}

@MainActor
@Test("a copy refused because a store could not be read leaves the three places as they were")
func aCopyRefusedBecauseAStoreCouldNotBeReadLeavesTheThreePlacesAsTheyWere() throws {
    let places = freshThreePlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let bookDentist = OneOff(
        name: "Book dentist", date: CalendarDate(year: 2026, month: 9, day: 25)!)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let oneOffStore = try OneOffStore(at: places.oneOffs)
    try oneOffStore.add(bookDentist)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    try Data("not what a one-off holder is written as".utf8).write(to: places.oneOffs)
    let rosterBytes = try Data(contentsOf: places.roster)
    let oneOffBytes = try Data(contentsOf: places.oneOffs)

    let result = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())

    guard case .failure(let refusal) = result else {
        Issue.record("expected a copy to be refused")
        return
    }
    #expect(refusal == .storeCouldNotBeRead)
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    #expect(try Data(contentsOf: places.oneOffs) == oneOffBytes)
    #expect(!FileManager.default.fileExists(atPath: places.record.path))
}

/// The minimal bytes a store written by a later version reads as: the envelope's `version` alone
/// decides `.laterForm`, so the rest of the shape needs only to parse.
private func laterFormBytes(for store: Copy.Store) -> Data {
    switch store {
    case .record:
        return Data("{\"version\":\(RecordDocument.currentVersion + 1),\"ticks\":[]}".utf8)
    case .roster:
        return Data("{\"version\":\(RosterDocument.currentVersion + 1),\"commitments\":[]}".utf8)
    case .oneOffs:
        return Data("{\"version\":\(OneOffDocument.currentVersion + 1),\"oneOffs\":[]}".utf8)
    }
}

@MainActor
@Test(
    "a copy refused over a store written by a later version says so rather than that it could not be read"
)
func aCopyRefusedOverAStoreWrittenByALaterVersionSaysSoRatherThanThatItCouldNotBeRead() throws {
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let moment = Moment(on: monday, hour: 14, minute: 32)!

    // The roster place holds a roster written in a later form.
    do {
        let places = freshThreePlaces()
        try FileManager.default.createDirectory(
            at: places.roster.deletingLastPathComponent(), withIntermediateDirectories: true)
        try laterFormBytes(for: .roster).write(to: places.roster)

        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)

        let result = screen.makeACopy(asOf: moment, writingInto: freshCopyDirectory())

        guard case .failure(let refusal) = result else {
            Issue.record("expected a copy to be refused")
            return
        }
        #expect(refusal == .storeWrittenByALaterVersion)
        #expect(refusal != .storeCouldNotBeRead)
        #expect(screen.refusedChange == .makingACopy(.roster, .storeWrittenByALaterVersion))
    }

    // The record place, rather than the roster place, holds a record written in a later form.
    do {
        let places = freshThreePlaces()
        try FileManager.default.createDirectory(
            at: places.record.deletingLastPathComponent(), withIntermediateDirectories: true)
        try laterFormBytes(for: .record).write(to: places.record)

        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)

        let result = screen.makeACopy(asOf: moment, writingInto: freshCopyDirectory())

        guard case .failure(let refusal) = result else {
            Issue.record("expected a copy to be refused")
            return
        }
        #expect(refusal == .storeWrittenByALaterVersion)
        #expect(screen.refusedChange == .makingACopy(.record, .storeWrittenByALaterVersion))
    }

    // The one-off place holds one-offs written in a later form.
    do {
        let places = freshThreePlaces()
        try FileManager.default.createDirectory(
            at: places.oneOffs.deletingLastPathComponent(), withIntermediateDirectories: true)
        try laterFormBytes(for: .oneOffs).write(to: places.oneOffs)

        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)

        let result = screen.makeACopy(asOf: moment, writingInto: freshCopyDirectory())

        guard case .failure(let refusal) = result else {
            Issue.record("expected a copy to be refused")
            return
        }
        #expect(refusal == .storeWrittenByALaterVersion)
        #expect(screen.refusedChange == .makingACopy(.oneOffs, .storeWrittenByALaterVersion))
    }

    // The record place holds a run of bytes that is not a record, and the roster place holds a
    // roster written in a later form: refused as a store that could not be read, naming the
    // record — the earlier place in the fixed order outranks the later version.
    do {
        let places = freshThreePlaces()
        try FileManager.default.createDirectory(
            at: places.record.deletingLastPathComponent(), withIntermediateDirectories: true)
        try Data("not what a record is written as".utf8).write(to: places.record)
        try FileManager.default.createDirectory(
            at: places.roster.deletingLastPathComponent(), withIntermediateDirectories: true)
        try laterFormBytes(for: .roster).write(to: places.roster)

        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)

        let result = screen.makeACopy(asOf: moment, writingInto: freshCopyDirectory())

        guard case .failure(let refusal) = result else {
            Issue.record("expected a copy to be refused")
            return
        }
        #expect(refusal == .storeCouldNotBeRead)
        #expect(screen.refusedChange == .makingACopy(.record, .storeCouldNotBeRead))
    }
}
