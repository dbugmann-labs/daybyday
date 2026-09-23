import Foundation
import Testing

@testable import DayByDayKit

/// A fresh roster place, record place and one-off place, three sibling files under one fresh
/// temporary directory — mirrors `CopyTests.swift`'s own `freshThreePlaces()`. Nothing is created
/// until something writes to one of the three.
private func freshThreePlaces() -> (roster: URL, record: URL, oneOffs: URL) {
    let base = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    return (
        base.appendingPathComponent("roster.json"),
        base.appendingPathComponent("record.json"),
        base.appendingPathComponent("one-offs.json")
    )
}

/// A fresh directory of its own for a copy to be written into.
private func freshCopyDirectory() -> URL {
    FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
}

/// A fresh place for a picked `.daybyday` file, named `name`, under a directory of its own —
/// distinct from `freshCopyDirectory()`, which is where `makeACopy` writes, so a test can tell
/// "the place a copy was made" and "the place a person picked a file from" apart.
private func freshPickedFile(named name: String = "DayByDay 2026-08-31 14.32.daybyday") -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent(name)
}

private let allWeekdays: Schedule = .weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])

/// A minimal but valid `.daybyday` file's bytes: form 1 throughout, so no store-specific field
/// need be present, with a moment of Monday 31 August 2026 at 14:32. Every piece is overridable so
/// a test can corrupt exactly the one it is about, and `nil` omits a top-level key entirely —
/// `record`/`roster`/`oneOffs`/`moment` missing outright, as opposed to present but malformed.
private func copyJSON(
    version: Int = 1,
    moment: String? = """
        {"day":{"year":2026,"month":8,"day":31},"hour":14,"minute":32}
        """,
    record: String? = """
        {"version":1,"ticks":[]}
        """,
    roster: String? = """
        {"version":1,"commitments":[]}
        """,
    oneOffs: String? = """
        {"version":1,"oneOffs":[]}
        """
) -> Data {
    var fields = ["\"version\":\(version)"]
    if let moment { fields.append("\"moment\":\(moment)") }
    if let record { fields.append("\"record\":\(record)") }
    if let roster { fields.append("\"roster\":\(roster)") }
    if let oneOffs { fields.append("\"oneOffs\":\(oneOffs)") }
    return Data("{\(fields.joined(separator: ","))}".utf8)
}

@MainActor
@Test("a file that does not read as a copy's form and moment is refused as not a copy")
func aFileThatDoesNotReadAsACopysFormAndMomentIsRefusedAsNotACopy() throws {
    let places = freshThreePlaces()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    func expectNotACopy(_ data: Data?, at file: URL) throws {
        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)

        if let data {
            try FileManager.default.createDirectory(
                at: file.deletingLastPathComponent(), withIntermediateDirectories: true)
            try data.write(to: file)
        }

        let refusal = screen.askToRestore(from: file)

        #expect(refusal == .notACopy)
        #expect(screen.awaitingRestore == nil)
        #expect(!FileManager.default.fileExists(atPath: places.roster.path))
        #expect(!FileManager.default.fileExists(atPath: places.record.path))
        #expect(!FileManager.default.fileExists(atPath: places.oneOffs.path))
    }

    // A run of bytes that is not a copy at all.
    try expectNotACopy(Data("not what a copy is written as".utf8), at: freshPickedFile())

    // A file holding a copy's form and no moment.
    try expectNotACopy(copyJSON(moment: nil), at: freshPickedFile())

    // A form number no version of the app writes.
    try expectNotACopy(copyJSON(version: 0), at: freshPickedFile())

    // A location where no file stands.
    try expectNotACopy(nil, at: freshPickedFile())
}

@MainActor
@Test(
    "a copy whose own form is later than this app reads is refused as a copy from a later version"
)
func aCopyWhoseOwnFormIsLaterThanThisAppReadsIsRefusedAsACopyFromALaterVersion() throws {
    let places = freshThreePlaces()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    func expectFromALaterVersion(_ data: Data) throws {
        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)
        let file = freshPickedFile()
        try FileManager.default.createDirectory(
            at: file.deletingLastPathComponent(), withIntermediateDirectories: true)
        try data.write(to: file)

        let refusal = screen.askToRestore(from: file)

        #expect(refusal == .copyFromALaterVersion)
        #expect(screen.awaitingRestore == nil)
    }

    // The copy's own form is one later than a copy is written in now.
    try expectFromALaterVersion(copyJSON(version: CopyDocument.currentVersion + 1))

    // The copy's own form is the one written now, but its roster is one form later than a
    // roster store writes.
    try expectFromALaterVersion(
        copyJSON(
            version: CopyDocument.currentVersion,
            roster: "{\"version\":\(RosterDocument.currentVersion + 1),\"commitments\":[]}"))
}

@MainActor
@Test("a copy holding a store that does not read is refused as a damaged copy")
func aCopyHoldingAStoreThatDoesNotReadIsRefusedAsADamagedCopy() throws {
    let places = freshThreePlaces()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    func expectDamaged(_ data: Data) throws {
        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)
        let file = freshPickedFile()
        try FileManager.default.createDirectory(
            at: file.deletingLastPathComponent(), withIntermediateDirectories: true)
        try data.write(to: file)

        let refusal = screen.askToRestore(from: file)

        #expect(refusal == .damagedCopy)
        #expect(screen.awaitingRestore == nil)
    }

    // The roster lacks a field its form always writes: `commitments`.
    try expectDamaged(copyJSON(roster: "{\"version\":1}"))

    // No one-offs at all.
    try expectDamaged(copyJSON(oneOffs: nil))

    // The record carries a field its form has no place for: `numbers` at form 1.
    try expectDamaged(copyJSON(record: "{\"version\":1,\"ticks\":[],\"numbers\":[]}"))

    let shapelyRosterAtForm = { (version: Int) in
        """
        {
          "version": \(version),
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
        """
    }
    let shapelyRecordAtForm = { (version: Int) in
        """
        {
          "version": \(version),
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
        """
    }
    let shapelyOneOffsAtForm = { (version: Int) in
        """
        {"version": \(version), "oneOffs": [{"name": "Book dentist", "date": {"year": 2026, "month": 9, "day": 25}}]}
        """
    }

    // A roster whose declared form is below the earliest form a roster store reads — no form
    // this app has ever written, not merely one it cannot read yet.
    try expectDamaged(copyJSON(roster: shapelyRosterAtForm(0)))

    // A roster whose declared form is negative.
    try expectDamaged(copyJSON(roster: shapelyRosterAtForm(-1)))

    // A record whose declared form is below the earliest form a record store reads.
    try expectDamaged(copyJSON(record: shapelyRecordAtForm(0)))

    // A one-off holder whose declared form is below the earliest form a one-off store reads —
    // `formOneOffs` never inspects a version at all, so nothing but the envelope guarded it.
    try expectDamaged(copyJSON(oneOffs: shapelyOneOffsAtForm(0)))
    try expectDamaged(copyJSON(oneOffs: shapelyOneOffsAtForm(-1)))
}

@MainActor
@Test(
    "a copy holding a store of a later form beside a store that does not read is refused as a copy from a later version"
)
func aCopyHoldingAStoreOfALaterFormBesideAStoreThatDoesNotReadIsRefusedAsACopyFromALaterVersion()
    throws
{
    let places = freshThreePlaces()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
    let file = freshPickedFile()
    try FileManager.default.createDirectory(
        at: file.deletingLastPathComponent(), withIntermediateDirectories: true)
    try copyJSON(
        record: "\"not a record\"",
        roster: "{\"version\":\(RosterDocument.currentVersion + 1),\"commitments\":[]}"
    ).write(to: file)

    let refusal = screen.askToRestore(from: file)

    #expect(refusal == .copyFromALaterVersion)
    #expect(screen.awaitingRestore == nil)
}

@MainActor
@Test(
    "a copy holding stores in the earliest forms they are read in is read as what those forms hold"
)
func aCopyHoldingStoresInTheEarliestFormsTheyAreReadInIsReadAsWhatThoseFormsHold() throws {
    let places = freshThreePlaces()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let earliestRoster = """
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
        """
    let earliestRecord = """
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
        """

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
    let file = freshPickedFile()
    try FileManager.default.createDirectory(
        at: file.deletingLastPathComponent(), withIntermediateDirectories: true)
    try copyJSON(record: earliestRecord, roster: earliestRoster).write(to: file)

    let refusal = screen.askToRestore(from: file)

    #expect(refusal == nil)
    #expect(
        screen.awaitingRestore?.copy
            == CommitmentsScreen.Counts(kept: 1, stopped: 0, oneOffs: 0))
}

@MainActor
@Test(
    "a commitments screen asked to restore says the copy's moment and what the copy and the phone keep, have stopped and hold as one-offs"
)
func aCommitmentsScreenAskedToRestoreSaysTheCopysMomentAndWhatTheCopyAndThePhoneKeepHaveStoppedAndHoldAsOneOffs()
    throws
{
    let places = freshThreePlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!)
    try rosterStore.add(Commitment(name: "Journaling", schedule: allWeekdays, keptFrom: keptFrom)!)
    let oneOffStore = try OneOffStore(at: places.oneOffs)
    try oneOffStore.add(OneOff(name: "Book dentist", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    let copyDirectory = freshCopyDirectory()
    let copyResult = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: copyDirectory)
    guard case .success(let copyURL) = copyResult else {
        Issue.record("expected a copy to be made")
        return
    }

    let journaling = screen.kept.first { $0.name == "Journaling" }!
    screen.askToStopKeeping(journaling)
    #expect(screen.confirmStopKeeping() == nil)
    #expect(
        screen.define(name: "Reading", on: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]), keptFrom: keptFrom, under: nil)
            == nil)
    let gym = screen.kept.first { $0.name == "Gym" }!
    screen.askToDelete(gym)
    screen.nameTypedBack = "Gym"
    #expect(screen.confirmDeleting() == nil)
    try oneOffStore.add(OneOff(name: "Post the form", date: CalendarDate(year: 2026, month: 9, day: 1)!)!)

    let rosterBytesBeforeAsk = try Data(contentsOf: places.roster)
    let oneOffBytesBeforeAsk = try Data(contentsOf: places.oneOffs)
    let recordExistedBeforeAsk = FileManager.default.fileExists(atPath: places.record.path)

    let refusal = screen.askToRestore(from: copyURL)

    #expect(refusal == nil)
    #expect(screen.awaitingRestore?.moment == Moment(on: monday, hour: 14, minute: 32)!)
    #expect(
        screen.awaitingRestore?.copy == CommitmentsScreen.Counts(kept: 2, stopped: 0, oneOffs: 1))
    #expect(
        screen.awaitingRestore?.phone == CommitmentsScreen.Counts(kept: 1, stopped: 1, oneOffs: 2))
    #expect(try Data(contentsOf: places.roster) == rosterBytesBeforeAsk)
    #expect(try Data(contentsOf: places.oneOffs) == oneOffBytesBeforeAsk)
    #expect(FileManager.default.fileExists(atPath: places.record.path) == recordExistedBeforeAsk)
}

@MainActor
@Test(
    "a commitments screen asked to restore where a place cannot be read says that store cannot be read in place of its counts"
)
func aCommitmentsScreenAskedToRestoreWhereAPlaceCannotBeReadSaysThatStoreCannotBeReadInPlaceOfItsCounts()
    throws
{
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    // The roster place cannot be read: no counts of kept or stopped, zero one-offs (readable and
    // empty).
    do {
        let places = freshThreePlaces()
        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)
        let copyResult = screen.makeACopy(
            asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
        guard case .success(let copyURL) = copyResult else {
            Issue.record("expected a copy to be made")
            return
        }
        try FileManager.default.createDirectory(
            at: places.roster.deletingLastPathComponent(), withIntermediateDirectories: true)
        try Data("not what a roster is written as".utf8).write(to: places.roster)

        let refusal = screen.askToRestore(from: copyURL)

        #expect(refusal == nil)
        #expect(screen.awaitingRestore?.unreadable == [.roster])
        #expect(screen.awaitingRestore?.phone.kept == nil)
        #expect(screen.awaitingRestore?.phone.stopped == nil)
        #expect(screen.awaitingRestore?.phone.oneOffs == 0)
    }

    // The record place, rather than the roster place, cannot be read: all three counts given.
    do {
        let places = freshThreePlaces()
        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)
        let copyResult = screen.makeACopy(
            asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
        guard case .success(let copyURL) = copyResult else {
            Issue.record("expected a copy to be made")
            return
        }
        try FileManager.default.createDirectory(
            at: places.record.deletingLastPathComponent(), withIntermediateDirectories: true)
        try Data("not what a record is written as".utf8).write(to: places.record)

        let refusal = screen.askToRestore(from: copyURL)

        #expect(refusal == nil)
        #expect(screen.awaitingRestore?.unreadable == [.record])
        #expect(screen.awaitingRestore?.phone.kept == 0)
        #expect(screen.awaitingRestore?.phone.stopped == 0)
        #expect(screen.awaitingRestore?.phone.oneOffs == 0)
    }

    // The one-off place cannot be read: no count of one-offs, kept/stopped still given.
    do {
        let places = freshThreePlaces()
        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)
        let copyResult = screen.makeACopy(
            asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
        guard case .success(let copyURL) = copyResult else {
            Issue.record("expected a copy to be made")
            return
        }
        try FileManager.default.createDirectory(
            at: places.oneOffs.deletingLastPathComponent(), withIntermediateDirectories: true)
        try Data("not what a one-off holder is written as".utf8).write(to: places.oneOffs)

        let refusal = screen.askToRestore(from: copyURL)

        #expect(refusal == nil)
        #expect(screen.awaitingRestore?.unreadable == [.oneOffs])
        #expect(screen.awaitingRestore?.phone.kept == 0)
        #expect(screen.awaitingRestore?.phone.stopped == 0)
        #expect(screen.awaitingRestore?.phone.oneOffs == nil)
    }
}

@MainActor
@Test("a restore asked for and cancelled leaves a commitments screen and its three places as they were")
func aRestoreAskedForAndCancelledLeavesACommitmentsScreenAndItsThreePlacesAsTheyWere() throws {
    let places = freshThreePlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
    let copyResult = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
    guard case .success(let copyURL) = copyResult else {
        Issue.record("expected a copy to be made")
        return
    }

    screen.askToDelete(gym)
    screen.nameTypedBack = "Gym"

    let rosterBytesBefore = try Data(contentsOf: places.roster)
    let recordExistedBefore = FileManager.default.fileExists(atPath: places.record.path)
    let oneOffsExistedBefore = FileManager.default.fileExists(atPath: places.oneOffs.path)

    #expect(screen.askToRestore(from: copyURL) == nil)
    screen.cancelRestoring()

    #expect(screen.awaitingRestore == nil)
    #expect(screen.copyRestored == nil)
    #expect(screen.awaitingDeletion == gym)
    #expect(screen.nameTypedBack == "Gym")
    #expect(try Data(contentsOf: places.roster) == rosterBytesBefore)
    #expect(FileManager.default.fileExists(atPath: places.record.path) == recordExistedBefore)
    #expect(FileManager.default.fileExists(atPath: places.oneOffs.path) == oneOffsExistedBefore)
}

@MainActor
@Test(
    "a restore awaiting confirmation stands when the app is shown again and is replaced by another ask"
)
func aRestoreAwaitingConfirmationStandsWhenTheAppIsShownAgainAndIsReplacedByAnotherAsk() throws {
    let places = freshThreePlaces()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
    let directory = freshCopyDirectory()
    let firstCopy = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: directory)
    guard case .success(let firstCopyURL) = firstCopy else {
        Issue.record("expected a copy to be made")
        return
    }

    #expect(screen.askToRestore(from: firstCopyURL) == nil)
    screen.shown(asOf: monday)

    #expect(screen.awaitingRestore?.moment == Moment(on: monday, hour: 14, minute: 32)!)

    let secondCopy = screen.makeACopy(
        asOf: Moment(on: monday, hour: 9, minute: 7)!, writingInto: directory)
    guard case .success(let secondCopyURL) = secondCopy else {
        Issue.record("expected a copy to be made")
        return
    }
    #expect(screen.askToRestore(from: secondCopyURL) == nil)

    #expect(screen.awaitingRestore?.moment == Moment(on: monday, hour: 9, minute: 7)!)
}

@MainActor
@Test("a restore confirmed makes the three places hold what the copy holds, and what they held is gone")
func aRestoreConfirmedMakesTheThreePlacesHoldWhatTheCopyHoldsAndWhatTheyHeldIsGone() throws {
    let places = freshThreePlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
    let bookDentist = OneOff(name: "Book dentist", date: CalendarDate(year: 2026, month: 9, day: 25)!)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: august30th)!)
    let oneOffStore = try OneOffStore(at: places.oneOffs)
    try oneOffStore.add(bookDentist)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
    let copyResult = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
    guard case .success(let copyURL) = copyResult else {
        Issue.record("expected a copy to be made")
        return
    }

    #expect(
        screen.define(name: "Journaling", on: Rhythm(allWeekdays), keptFrom: keptFrom, under: nil)
            == nil)
    try recordStore.add(Tick(gym, on: monday)!)
    try oneOffStore.add(OneOff(name: "Post the form", date: CalendarDate(year: 2026, month: 9, day: 1)!)!)

    #expect(screen.askToRestore(from: copyURL) == nil)
    #expect(screen.confirmRestoring() == nil)

    let expectedPlaces = freshThreePlaces()
    let expectedRoster = try RosterStore(at: expectedPlaces.roster)
    try expectedRoster.add(gym)
    let expectedRecord = try RecordStore(at: expectedPlaces.record)
    try expectedRecord.add(Tick(gym, on: august30th)!)
    let expectedOneOffs = try OneOffStore(at: expectedPlaces.oneOffs)
    try expectedOneOffs.add(bookDentist)

    #expect(try Data(contentsOf: places.roster) == Data(contentsOf: expectedPlaces.roster))
    #expect(try Data(contentsOf: places.record) == Data(contentsOf: expectedPlaces.record))
    #expect(try Data(contentsOf: places.oneOffs) == Data(contentsOf: expectedPlaces.oneOffs))
}

@MainActor
@Test("a restore confirmed over places that cannot be read replaces what is there")
func aRestoreConfirmedOverPlacesThatCannotBeReadReplacesWhatIsThere() throws {
    let firstPlaces = freshThreePlaces()
    let secondPlaces = freshThreePlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!

    let firstRoster = try RosterStore(at: firstPlaces.roster)
    try firstRoster.add(gym)
    let firstScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: firstPlaces.roster, keepingRecordAt: firstPlaces.record,
        keepingOneOffsAt: firstPlaces.oneOffs)
    let copyResult = firstScreen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
    guard case .success(let copyURL) = copyResult else {
        Issue.record("expected a copy to be made")
        return
    }

    for place in [secondPlaces.roster, secondPlaces.record, secondPlaces.oneOffs] {
        try FileManager.default.createDirectory(
            at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
        try Data("not what a store of its kind is written as".utf8).write(to: place)
    }

    let secondScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: secondPlaces.roster, keepingRecordAt: secondPlaces.record,
        keepingOneOffsAt: secondPlaces.oneOffs)

    #expect(secondScreen.askToRestore(from: copyURL) == nil)
    #expect(secondScreen.confirmRestoring() == nil)

    #expect(secondScreen.rosterState == .kept)
    #expect(secondScreen.kept.map(\.name) == ["Gym"])
    #expect(try RecordStore(at: secondPlaces.record).history == History())
    #expect(try OneOffStore(at: secondPlaces.oneOffs).oneOffs == OneOffs())
}

@MainActor
@Test("a copy of nothing restored leaves the three places holding nothing")
func aCopyOfNothingRestoredLeavesTheThreePlacesHoldingNothing() throws {
    let places = freshThreePlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
    let copyResult = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
    guard case .success(let copyURL) = copyResult else {
        Issue.record("expected a copy to be made")
        return
    }

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: august30th)!)
    let oneOffStore = try OneOffStore(at: places.oneOffs)
    try oneOffStore.add(OneOff(name: "Book dentist", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)

    #expect(screen.askToRestore(from: copyURL) == nil)
    #expect(screen.confirmRestoring() == nil)

    #expect(screen.kept == [])
    #expect(screen.stopped == [])
    #expect(try RosterStore(at: places.roster).roster == Roster())
    #expect(try RecordStore(at: places.record).history == History())
    #expect(try OneOffStore(at: places.oneOffs).oneOffs == OneOffs())
}

private let earliestFormRoster = """
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
    """
private let earliestFormRecord = """
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
    """

@MainActor
@Test("a copy holding stores in earlier forms is restored in the forms each store writes now")
func aCopyHoldingStoresInEarlierFormsIsRestoredInTheFormsEachStoreWritesNow() throws {
    let places = freshThreePlaces()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
    let file = freshPickedFile()
    try FileManager.default.createDirectory(
        at: file.deletingLastPathComponent(), withIntermediateDirectories: true)
    try copyJSON(record: earliestFormRecord, roster: earliestFormRoster).write(to: file)

    #expect(screen.askToRestore(from: file) == nil)
    #expect(screen.confirmRestoring() == nil)

    let rosterEnvelope = try JSONDecoder().decode(
        RosterDocumentEnvelope.self, from: Data(contentsOf: places.roster))
    let recordEnvelope = try JSONDecoder().decode(
        RecordDocumentEnvelope.self, from: Data(contentsOf: places.record))
    #expect(rosterEnvelope.version == RosterDocument.currentVersion)
    #expect(recordEnvelope.version == RecordDocument.currentVersion)
    #expect(screen.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a restore confirmed takes away a save in progress that could not be undone")
func aRestoreConfirmedTakesAwayASaveInProgressThatCouldNotBeUndone() throws {
    let firstPlaces = freshThreePlaces()
    let secondPlaces = freshThreePlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!

    let firstRoster = try RosterStore(at: firstPlaces.roster)
    try firstRoster.add(gym)
    let firstScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: firstPlaces.roster, keepingRecordAt: firstPlaces.record,
        keepingOneOffsAt: firstPlaces.oneOffs)
    let copyResult = firstScreen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
    guard case .success(let copyURL) = copyResult else {
        Issue.record("expected a copy to be made")
        return
    }

    let saveInProgressPlace = SaveInProgress.place(besideRecordAt: secondPlaces.record)
    try FileManager.default.createDirectory(
        at: saveInProgressPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a save in progress is written as".utf8).write(to: saveInProgressPlace)

    let secondScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: secondPlaces.roster, keepingRecordAt: secondPlaces.record,
        keepingOneOffsAt: secondPlaces.oneOffs)

    #expect(secondScreen.askToRestore(from: copyURL) == nil)
    #expect(secondScreen.confirmRestoring() == nil)

    #expect(!FileManager.default.fileExists(atPath: saveInProgressPlace.path))

    let reopened = CommitmentsScreen(
        asOf: monday, keepingRosterAt: secondPlaces.roster, keepingRecordAt: secondPlaces.record,
        keepingOneOffsAt: secondPlaces.oneOffs)
    #expect(reopened.kept.map(\.name) == ["Gym"])
}

@MainActor
@Test("a commitments screen that restored a copy lists what the copy holds and has nothing awaiting")
func aCommitmentsScreenThatRestoredACopyListsWhatTheCopyHoldsAndHasNothingAwaiting() throws {
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
    let copyResult = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
    guard case .success(let copyURL) = copyResult else {
        Issue.record("expected a copy to be made")
        return
    }

    #expect(screen.keepAgain(journaling) == nil)
    screen.askToDelete(gym)
    screen.nameTypedBack = "Gym"

    #expect(screen.askToRestore(from: copyURL) == nil)
    #expect(screen.confirmRestoring() == nil)

    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.map(\.name) == ["Journaling"])
    #expect(screen.awaitingDeletion == nil)
    #expect(screen.nameTypedBack == "")
    #expect(screen.awaitingRestore == nil)

    // A screen asked to stop keeping "Gym" rather than to remove it, before the restore was
    // asked for, has nothing awaiting confirmation afterwards either.
    let otherPlaces = freshThreePlaces()
    let otherRoster = try RosterStore(at: otherPlaces.roster)
    try otherRoster.add(gym)
    let otherScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: otherPlaces.roster, keepingRecordAt: otherPlaces.record,
        keepingOneOffsAt: otherPlaces.oneOffs)
    let otherCopyResult = otherScreen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
    guard case .success(let otherCopyURL) = otherCopyResult else {
        Issue.record("expected a copy to be made")
        return
    }
    otherScreen.askToStopKeeping(gym)
    #expect(otherScreen.askToRestore(from: otherCopyURL) == nil)
    #expect(otherScreen.confirmRestoring() == nil)
    #expect(otherScreen.awaitingConfirmation == nil)
}

@MainActor
@Test(
    "a commitments screen that restored a copy holds that copy's moment until the app is shown again or a change is kept"
)
func aCommitmentsScreenThatRestoredACopyHoldsThatCopysMomentUntilTheAppIsShownAgainOrAChangeIsKept()
    throws
{
    let places = freshThreePlaces()
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
    let copyResult = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
    guard case .success(let copyURL) = copyResult else {
        Issue.record("expected a copy to be made")
        return
    }

    #expect(screen.askToRestore(from: copyURL) == nil)
    #expect(screen.confirmRestoring() == nil)

    let refusal = screen.define(
        name: "   ", on: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: monday, under: nil)
    #expect(refusal == .namesNothing)

    #expect(screen.copyRestored == Moment(on: monday, hour: 14, minute: 32)!)

    screen.shown(asOf: monday)
    #expect(screen.copyRestored == nil)

    // A screen that instead defines and keeps "Gym" on that rhythm, after the restore, holds no
    // copy restored.
    let otherPlaces = freshThreePlaces()
    let otherScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: otherPlaces.roster, keepingRecordAt: otherPlaces.record,
        keepingOneOffsAt: otherPlaces.oneOffs)
    let otherCopyResult = otherScreen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
    guard case .success(let otherCopyURL) = otherCopyResult else {
        Issue.record("expected a copy to be made")
        return
    }
    #expect(otherScreen.askToRestore(from: otherCopyURL) == nil)
    #expect(otherScreen.confirmRestoring() == nil)
    #expect(
        otherScreen.define(
            name: "Gym",
            on: .weekdays([
                .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
            ]), keptFrom: monday, under: nil) == nil)
    #expect(otherScreen.copyRestored == nil)
}

/// A path that cannot be written: `blocker` is an ordinary file, not a directory, and `name`
/// sits beneath it, so any write through it fails — mirrors `DayScreenTests.swift`'s own
/// `blockerPlaces()`.
private func blockedPlace(named name: String) throws -> URL {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    return blocker.appendingPathComponent(name)
}

/// Makes `directory` read-only, so a place already holding something can be made unwritable
/// without disturbing what is there — unlike `blockedPlace(named:)`, which only ever names a
/// place that has never held anything. Mirrors `DayScreenTests.swift`'s own `makeReadOnly(_:)`.
/// Every caller must pair this with `makeWritable(_:)`, including on its failure path.
private func makeReadOnly(_ directory: URL) throws {
    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
}

/// Undoes `makeReadOnly(_:)`, restoring `directory` to a place that can be written to again.
private func makeWritable(_ directory: URL) throws {
    try FileManager.default.setAttributes([.posixPermissions: 0o700], ofItemAtPath: directory.path)
}

@MainActor
@Test(
    "a restore refused where the one-off place cannot be written leaves the record and the roster places as they were"
)
func aRestoreRefusedWhereTheOneOffPlaceCannotBeWrittenLeavesTheRecordAndTheRosterPlacesAsTheyWere()
    throws
{
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!

    func makeCopyOfJournalingAndBookDentist() throws -> URL {
        let places = freshThreePlaces()
        let rosterStore = try RosterStore(at: places.roster)
        try rosterStore.add(
            Commitment(name: "Journaling", schedule: allWeekdays, keptFrom: keptFrom)!)
        let oneOffStore = try OneOffStore(at: places.oneOffs)
        try oneOffStore.add(
            OneOff(name: "Book dentist", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)
        let sourceScreen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)
        let result = sourceScreen.makeACopy(
            asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshCopyDirectory())
        guard case .success(let url) = result else {
            Issue.record("expected a copy to be made")
            return freshPickedFile()
        }
        return url
    }

    // The one-off place cannot be written.
    do {
        let base = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let rosterPlace = base.appendingPathComponent("roster.json")
        let recordPlace = base.appendingPathComponent("record.json")
        let oneOffPlace = try blockedPlace(named: "one-offs.json")

        let rosterStore = try RosterStore(at: rosterPlace)
        try rosterStore.add(gym)
        let recordStore = try RecordStore(at: recordPlace)
        try recordStore.add(Tick(gym, on: august30th)!)

        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace,
            keepingOneOffsAt: oneOffPlace)
        let rosterBytesBefore = try Data(contentsOf: rosterPlace)
        let recordBytesBefore = try Data(contentsOf: recordPlace)

        let copyURL = try makeCopyOfJournalingAndBookDentist()
        #expect(screen.askToRestore(from: copyURL) == nil)
        let refusal = screen.confirmRestoring()

        #expect(refusal == .notKept)
        #expect(try Data(contentsOf: recordPlace) == recordBytesBefore)
        #expect(try Data(contentsOf: rosterPlace) == rosterBytesBefore)
        #expect(!FileManager.default.fileExists(atPath: oneOffPlace.path))
        #expect(screen.kept.map(\.name) == ["Gym"])
        #expect(screen.copyRestored == nil)
        #expect(screen.awaitingRestore == nil)
    }

    // The roster place, rather than the one-off place, cannot be written: the record place is
    // as it was.
    do {
        let base = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let recordPlace = base.appendingPathComponent("record.json")
        let oneOffPlace = base.appendingPathComponent("one-offs.json")
        let rosterPlace = try blockedPlace(named: "roster.json")

        let recordStore = try RecordStore(at: recordPlace)
        try recordStore.add(Tick(gym, on: august30th)!)

        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace,
            keepingOneOffsAt: oneOffPlace)
        let recordBytesBefore = try Data(contentsOf: recordPlace)

        let copyURL = try makeCopyOfJournalingAndBookDentist()
        #expect(screen.askToRestore(from: copyURL) == nil)
        let refusal = screen.confirmRestoring()

        #expect(refusal == .notKept)
        #expect(try Data(contentsOf: recordPlace) == recordBytesBefore)
    }

    // A copy already stands restored when a second restore is confirmed and cannot be made
    // whole: `copyRestored` from that first restore must not stand alongside the refusal —
    // specs/restore/spec.md § *A restore that cannot be made whole leaves the three places as
    // they were*: "with no copy restored". The two blocks above pass whether or not this is
    // cleared, because the screen in each never restored a first copy.
    do {
        let base = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let places = (
            roster: base.appendingPathComponent("roster.json"),
            record: base.appendingPathComponent("record.json"),
            oneOffs: base.appendingPathComponent("one-offs.json")
        )
        let rosterStore = try RosterStore(at: places.roster)
        try rosterStore.add(gym)

        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)

        let firstCopyURL = try makeCopyOfJournalingAndBookDentist()
        #expect(screen.askToRestore(from: firstCopyURL) == nil)
        #expect(screen.confirmRestoring() == nil)
        #expect(screen.copyRestored != nil)

        let secondCopyURL = try makeCopyOfJournalingAndBookDentist()
        #expect(screen.askToRestore(from: secondCopyURL) == nil)

        try makeReadOnly(base)
        defer { try? makeWritable(base) }

        let refusal = screen.confirmRestoring()

        #expect(refusal == .notKept)
        #expect(screen.copyRestored == nil)
    }
}

@MainActor
@Test("a restore stopped before it was whole is undone when the places are next opened")
func aRestoreStoppedBeforeItWasWholeIsUndoneWhenThePlacesAreNextOpened() throws {
    let places = freshThreePlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let august30th = CalendarDate(year: 2026, month: 8, day: 30)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: august30th)!)
    let oneOffStore = try OneOffStore(at: places.oneOffs)
    try oneOffStore.add(OneOff(name: "Book dentist", date: CalendarDate(year: 2026, month: 9, day: 25)!)!)

    let rosterBytesBefore = try Data(contentsOf: places.roster)
    let recordBytesBefore = try Data(contentsOf: places.record)
    let oneOffBytesBefore = try Data(contentsOf: places.oneOffs)

    var journalingRoster = Roster()
    let journalingAdded = journalingRoster.add(
        Commitment(name: "Journaling", schedule: allWeekdays, keptFrom: keptFrom)!)
    #expect(journalingAdded)
    let copy = Copy(
        moment: Moment(on: monday, hour: 14, minute: 32)!, history: History(),
        roster: journalingRoster, oneOffs: OneOffs())

    try RestoreInProgress.restore(
        copy, recordAt: places.record, rosterAt: places.roster, oneOffsAt: places.oneOffs,
        stoppingAfter: 2)

    // Left mid-flight: the restore in progress stands, and the one-off place is untouched.
    #expect(
        FileManager.default.fileExists(
            atPath: RestoreInProgress.place(besideRecordAt: places.record).path))
    #expect(try Data(contentsOf: places.oneOffs) == oneOffBytesBefore)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(try Data(contentsOf: places.roster) == rosterBytesBefore)
    #expect(try Data(contentsOf: places.record) == recordBytesBefore)
    #expect(try Data(contentsOf: places.oneOffs) == oneOffBytesBefore)
    #expect(
        !FileManager.default.fileExists(
            atPath: RestoreInProgress.place(besideRecordAt: places.record).path))

    let dayScreen = DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOffs)
    #expect(dayScreen.dayView.rows.map(\.name) == ["Gym"])

    // The same undo, reached through `DayScreen.returnedTo()` rather than a fresh `init` or a
    // fresh `CommitmentsScreen`. `returnedToOrdinarily()` inlines its own read of the three
    // places instead of sharing `readRecordAndRoster`, and — unlike every other reader of the
    // three places — never called `RestoreInProgress.undoTornRestore` at all, on the branch it
    // takes here: `dayScreen` above is already keeping a record (`recordState == .kept`), so
    // `returnedTo(from:)`'s ordinary path reopens the record place too. A second restore is
    // stopped mid-flight behind that already-open screen's back, and `returnedTo(from:)` is
    // called with a commitments screen that has not itself restored anything —
    // `specs/restore/spec.md`'s own wording, "a commitments screen or a day screen next opens
    // those places", covers this call exactly as it covers a fresh `init`.
    let commitmentsScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
    #expect(commitmentsScreen.hasRestoredACopy == false)

    var journalingAgain = Roster()
    _ = journalingAgain.add(
        Commitment(name: "Journaling", schedule: allWeekdays, keptFrom: keptFrom)!)
    let secondCopy = Copy(
        moment: Moment(on: monday, hour: 9, minute: 7)!, history: History(),
        roster: journalingAgain, oneOffs: OneOffs())
    try RestoreInProgress.restore(
        secondCopy, recordAt: places.record, rosterAt: places.roster, oneOffsAt: places.oneOffs,
        stoppingAfter: 2)

    #expect(
        FileManager.default.fileExists(
            atPath: RestoreInProgress.place(besideRecordAt: places.record).path))

    dayScreen.returnedTo(from: commitmentsScreen)

    #expect(dayScreen.dayView.rows.map(\.name) == ["Gym"])
    #expect(try Data(contentsOf: places.roster) == rosterBytesBefore)
    #expect(try Data(contentsOf: places.record) == recordBytesBefore)
    #expect(try Data(contentsOf: places.oneOffs) == oneOffBytesBefore)
    #expect(
        !FileManager.default.fileExists(
            atPath: RestoreInProgress.place(besideRecordAt: places.record).path))

    // The same undo, reached through the branch `returnedToOrdinarily()` takes when it is not
    // keeping a record — the branch the block above never touches. The record place holds bytes
    // that were never a record before anything else happens to it, so `recordState` reads
    // `.unreadable` from `init` onward and `returnedTo()` always takes this branch here. The
    // roster place is emptied again after `init` takes day one on there — deleting what `init`
    // had already written, not merely never writing it, the same as the block above and
    // `DayScreenTests.swift`'s own analogous save-in-progress test — and a restore is stopped
    // after writing only the record place, leaving a restore in progress that holds what stood
    // at the record place a moment ago: the same unreadable bytes.
    let elsePlaces = freshThreePlaces()
    let garbageRecordBytes = Data("not what a record is written as".utf8)
    try FileManager.default.createDirectory(
        at: elsePlaces.record.deletingLastPathComponent(), withIntermediateDirectories: true)
    try garbageRecordBytes.write(to: elsePlaces.record)

    let elseScreen = DayScreen(
        startingFrom: [gym], asOf: monday, keepingRecordAt: elsePlaces.record,
        keepingRosterAt: elsePlaces.roster, keepingOneOffsAt: elsePlaces.oneOffs)
    let elseCommitmentsScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: elsePlaces.roster, keepingRecordAt: elsePlaces.record,
        keepingOneOffsAt: elsePlaces.oneOffs)
    #expect(elseScreen.recordState == .unreadable)
    #expect(elseScreen.dayView.rows.map(\.name) == ["Gym"])
    #expect(elseCommitmentsScreen.hasRestoredACopy == false)

    try FileManager.default.removeItem(at: elsePlaces.roster)

    try RestoreInProgress.restore(
        secondCopy, recordAt: elsePlaces.record, rosterAt: elsePlaces.roster,
        oneOffsAt: elsePlaces.oneOffs, stoppingAfter: 1)

    #expect(
        FileManager.default.fileExists(
            atPath: RestoreInProgress.place(besideRecordAt: elsePlaces.record).path))

    elseScreen.returnedTo(from: elseCommitmentsScreen)

    #expect(try Data(contentsOf: elsePlaces.record) == garbageRecordBytes)
    #expect(
        !FileManager.default.fileExists(
            atPath: RestoreInProgress.place(besideRecordAt: elsePlaces.record).path))
}

@MainActor
@Test("a restore in progress that cannot be undone leaves a screen reading nothing from the three places")
func aRestoreInProgressThatCannotBeUndoneLeavesAScreenReadingNothingFromTheThreePlaces() throws {
    let places = freshThreePlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let rosterBytesBefore = try Data(contentsOf: places.roster)

    let restoreInProgressPlace = RestoreInProgress.place(besideRecordAt: places.record)
    try FileManager.default.createDirectory(
        at: restoreInProgressPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a restore in progress is written as".utf8).write(to: restoreInProgressPlace)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    #expect(screen.rosterState == .notKept)
    #expect(try Data(contentsOf: places.roster) == rosterBytesBefore)
    #expect(!FileManager.default.fileExists(atPath: places.record.path))
    #expect(!FileManager.default.fileExists(atPath: places.oneOffs.path))

    let journaling = Commitment(name: "Journaling", schedule: allWeekdays, keptFrom: keptFrom)!
    let dayScreen = DayScreen(
        startingFrom: [journaling], asOf: monday, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOffs)

    #expect(dayScreen.recordState == .unreadable)
    #expect(dayScreen.rosterState == .notKept)
    #expect(dayScreen.oneOffState == .unreadable)
    #expect(try Data(contentsOf: places.roster) == rosterBytesBefore)
    #expect(!FileManager.default.fileExists(atPath: places.record.path))
    #expect(!FileManager.default.fileExists(atPath: places.oneOffs.path))

    // The same condition reached through `DayScreen.returnedTo()` on its ordinary path, rather
    // than a fresh `init`: the screen has already read all three places once, cleanly, before the
    // restore in progress is torn. Unlike `readRecordAndRoster` above, `returnedToOrdinarily()`
    // has read nothing of its own on this call to withhold — `openspec/specs/day-screen/spec.md`
    // § *A day screen reads its roster again whenever it is returned to*: "that state, with
    // anything else that lasts until the app is shown again, SHALL stand across being returned
    // to". So the screen stands exactly as it already did, and neither reads from the three
    // places nor writes over them, same as the guard above.
    do {
        let places = freshThreePlaces()
        let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
        let monday = CalendarDate(year: 2026, month: 8, day: 31)!
        let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!

        let rosterStore = try RosterStore(at: places.roster)
        try rosterStore.add(gym)
        let recordStore = try RecordStore(at: places.record)
        try recordStore.add(Tick(gym, on: monday)!)
        let oneOffStore = try OneOffStore(at: places.oneOffs)
        try oneOffStore.add(OneOff(name: "Book dentist", date: monday)!)

        let rosterBytesBefore = try Data(contentsOf: places.roster)
        let recordBytesBefore = try Data(contentsOf: places.record)
        let oneOffBytesBefore = try Data(contentsOf: places.oneOffs)

        let dayScreen = DayScreen(
            startingFrom: [], asOf: monday, keepingRecordAt: places.record,
            keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOffs)
        #expect(dayScreen.recordState == .kept)
        #expect(dayScreen.rosterState == .kept)
        #expect(dayScreen.oneOffState == .kept)
        #expect(dayScreen.dayView.rows.map(\.name) == ["Gym"])
        #expect(dayScreen.dayView.oneOffGroup?.rows.map(\.name) == ["Book dentist"])

        let commitmentsScreen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)
        #expect(commitmentsScreen.hasRestoredACopy == false)

        let restoreInProgressPlace = RestoreInProgress.place(besideRecordAt: places.record)
        try Data("not what a restore in progress is written as".utf8).write(to: restoreInProgressPlace)

        dayScreen.returnedTo(from: commitmentsScreen)

        #expect(dayScreen.recordState == .kept)
        #expect(dayScreen.rosterState == .kept)
        #expect(dayScreen.oneOffState == .kept)
        #expect(dayScreen.dayView.rows.map(\.name) == ["Gym"])
        #expect(dayScreen.dayView.oneOffGroup?.rows.map(\.name) == ["Book dentist"])
        #expect(try Data(contentsOf: places.roster) == rosterBytesBefore)
        #expect(try Data(contentsOf: places.record) == recordBytesBefore)
        #expect(try Data(contentsOf: places.oneOffs) == oneOffBytesBefore)
        #expect(FileManager.default.fileExists(atPath: restoreInProgressPlace.path))
    }
}
