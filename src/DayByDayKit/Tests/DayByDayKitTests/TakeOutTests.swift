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

/// A fresh directory of its own — "a directory of its own" in every scenario below. Not created
/// until a take-out writes into it.
private func freshDirectory() -> URL {
    FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
}

private let allWeekdays: Schedule = .weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])
private let allWeekdaysRhythm: Rhythm = .weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])

private let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
private let monday = CalendarDate(year: 2026, month: 8, day: 31)!
private let sunday = CalendarDate(year: 2026, month: 8, day: 30)!
private let september25th = CalendarDate(year: 2026, month: 9, day: 25)!

private let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!
private let journaling = Commitment(name: "Journaling", schedule: allWeekdays, keptFrom: keptFrom)!

/// Writes `bytes` at `place`, creating the directory it lies in first — the "a run of bytes that
/// is not a store of its kind" every scenario below sets up the same way.
private func writeBytes(_ bytes: Data, to place: URL) throws {
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try bytes.write(to: place)
}

/// The minimal bytes a store written by a later version reads as: the envelope's `version` alone
/// decides `.laterForm`, so the rest of the shape needs only to parse. Mirrors
/// `RestoreTests.swift`'s own later-form fixtures.
private func laterFormBytes(for store: Copy.Store) -> Data {
    switch store {
    case .record:
        return Data(#"{"version":\#(RecordDocument.currentVersion + 1),"ticks":[]}"#.utf8)
    case .roster:
        return Data(#"{"version":\#(RosterDocument.currentVersion + 1),"commitments":[]}"#.utf8)
    case .oneOffs:
        return Data(#"{"version":\#(OneOffDocument.currentVersion + 1),"oneOffs":[]}"#.utf8)
    case .birthdayTicks:
        return Data(#"{"version":\#(BirthdayDocument.currentVersion + 1),"ticks":[]}"#.utf8)
    }
}

// MARK: - § 3: what a take-out is

@MainActor
@Test("a take-out hands out the three files byte-for-byte under the names they lie under")
func aTakeOutHandsOutTheThreeFilesByteForByteUnderTheNamesTheyLieUnder() throws {
    let places = freshThreePlaces()
    // The roster is kept in the earliest form a roster store reads — mirrors `CopyTests.swift`'s
    // own `aCopyOfAPlaceKeptInAnEarlierFormIsWrittenInTheFormThatStoreWritesNow`.
    try writeBytes(
        Data(
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
            """.utf8), to: places.roster)
    try OneOffStore(at: places.oneOffs).add(OneOff(name: "Book dentist", date: september25th)!)
    try writeBytes(Data("not what a record is written as".utf8), to: places.record)

    let recordBytes = try Data(contentsOf: places.record)
    let rosterBytes = try Data(contentsOf: places.roster)
    let oneOffBytes = try Data(contentsOf: places.oneOffs)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    let directory = freshDirectory()
    let result = screen.takeOut(writingInto: directory)

    guard case .success(let urls) = result else {
        Issue.record("expected a take-out to be made")
        return
    }
    #expect(Set(urls.map(\.lastPathComponent)) == ["record.json", "roster.json", "one-offs.json"])
    let parents = Set(urls.map { $0.deletingLastPathComponent() })
    #expect(parents.count == 1)
    let contents = try FileManager.default.contentsOfDirectory(atPath: try #require(parents.first).path)
    #expect(Set(contents) == Set(urls.map(\.lastPathComponent)))

    for url in urls {
        let expected: Data
        switch url.lastPathComponent {
        case "record.json": expected = recordBytes
        case "roster.json": expected = rosterBytes
        case "one-offs.json": expected = oneOffBytes
        default:
            Issue.record("unexpected file \(url.lastPathComponent)")
            continue
        }
        #expect(try Data(contentsOf: url) == expected)
    }
}

@MainActor
@Test("a take-out where nothing has been kept at a place hands out only the files that stand")
func aTakeOutWhereNothingHasBeenKeptAtAPlaceHandsOutOnlyTheFilesThatStand() throws {
    let places = freshThreePlaces()
    try writeBytes(Data("not what a roster is written as".utf8), to: places.roster)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    let directory = freshDirectory()
    let result = screen.takeOut(writingInto: directory)

    guard case .success(let urls) = result else {
        Issue.record("expected a take-out to be made")
        return
    }
    #expect(urls.map(\.lastPathComponent) == ["roster.json"])
    #expect(try Data(contentsOf: urls[0]) == Data(contentsOf: places.roster))
    // Nothing is written at the record place or the one-off place — the places themselves,
    // never asked for anything, not merely the directory the take-out wrote into.
    #expect(!FileManager.default.fileExists(atPath: places.record.path))
    #expect(!FileManager.default.fileExists(atPath: places.oneOffs.path))
}

@MainActor
@Test("a take-out hands out a save in progress and a restore in progress that could not be undone")
func aTakeOutHandsOutASaveInProgressAndARestoreInProgressThatCouldNotBeUndone() throws {
    let places = freshThreePlaces()
    try RosterStore(at: places.roster).add(gym)
    let saveInProgressPlace = SaveInProgress.place(besideRecordAt: places.record)
    let restoreInProgressPlace = RestoreInProgress.place(besideRecordAt: places.record)
    try writeBytes(Data("not what a save in progress is written as".utf8), to: saveInProgressPlace)
    try writeBytes(
        Data("not what a restore in progress is written as".utf8), to: restoreInProgressPlace)

    let rosterBytes = try Data(contentsOf: places.roster)
    let saveInProgressBytes = try Data(contentsOf: saveInProgressPlace)
    let restoreInProgressBytes = try Data(contentsOf: restoreInProgressPlace)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    let directory = freshDirectory()
    let result = screen.takeOut(writingInto: directory)

    guard case .success(let urls) = result else {
        Issue.record("expected a take-out to be made")
        return
    }
    #expect(
        Set(urls.map(\.lastPathComponent))
            == ["roster.json", "save-in-progress.json", "restore-in-progress.json"])
    for url in urls {
        let expected: Data
        switch url.lastPathComponent {
        case "roster.json": expected = rosterBytes
        case "save-in-progress.json": expected = saveInProgressBytes
        case "restore-in-progress.json": expected = restoreInProgressBytes
        default:
            Issue.record("unexpected file \(url.lastPathComponent)")
            continue
        }
        #expect(try Data(contentsOf: url) == expected)
    }

    #expect(try Data(contentsOf: saveInProgressPlace) == saveInProgressBytes)
    #expect(try Data(contentsOf: restoreInProgressPlace) == restoreInProgressBytes)
}

@MainActor
@Test("a take-out does not hand out the copy place")
func aTakeOutDoesNotHandOutTheCopyPlace() throws {
    let places = freshThreePlaces()
    try writeBytes(Data("not what a record is written as".utf8), to: places.record)
    let recordBytes = try Data(contentsOf: places.record)

    let copyPlaceState = places.record.deletingLastPathComponent()
        .appendingPathComponent("copy-place.json")
    let moment = Moment(on: monday, hour: 14, minute: 32)!
    let copyPlace = CopyPlace(
        at: copyPlaceState, keepingRecordAt: places.record, keepingRosterAt: places.roster,
        keepingOneOffsAt: places.oneOffs, asking: { moment })

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs, copyingTo: copyPlace)

    let copyPlaceFolder = freshDirectory()
    screen.givenAsCopyPlace(copyPlaceFolder)

    let directory = freshDirectory()
    let result = screen.takeOut(writingInto: directory)

    guard case .success(let urls) = result else {
        Issue.record("expected a take-out to be made")
        return
    }
    #expect(urls.map(\.lastPathComponent) == ["record.json"])
    #expect(try Data(contentsOf: urls[0]) == recordBytes)
    #expect(urls.allSatisfy { $0.deletingLastPathComponent() != copyPlaceFolder })
    #expect(copyPlace.folderName == copyPlaceFolder.lastPathComponent)
}

// MARK: - § 4: when a take-out is offered, and what it says

@MainActor
@Test("a commitments screen whose three places all read offers no take-out")
func aCommitmentsScreenWhoseThreePlacesAllReadOffersNoTakeOut() throws {
    let places = freshThreePlaces()
    try RosterStore(at: places.roster).add(gym)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    #expect(!screen.offersATakeOut)
    #expect(screen.storesNotRead.isEmpty)
}

@MainActor
@Test(
    "a commitments screen offers a take-out naming every place that cannot be read, in the order record, roster, one-offs"
)
func aCommitmentsScreenOffersATakeOutNamingEveryPlaceThatCannotBeReadInTheOrderRecordRosterOneOffs()
    throws
{
    do {
        let places = freshThreePlaces()
        try writeBytes(Data("not what a record is written as".utf8), to: places.record)
        try writeBytes(Data("not what a roster is written as".utf8), to: places.roster)
        try writeBytes(Data("not what a one-off holder is written as".utf8), to: places.oneOffs)

        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)

        #expect(screen.offersATakeOut)
        #expect(
            screen.storesNotRead == [
                CommitmentsScreen.StoreNotRead(store: .record, cause: .couldNotBeRead),
                CommitmentsScreen.StoreNotRead(store: .roster, cause: .couldNotBeRead),
                CommitmentsScreen.StoreNotRead(store: .oneOffs, cause: .couldNotBeRead),
            ])
    }

    do {
        let places = freshThreePlaces()
        try writeBytes(Data("not what a one-off holder is written as".utf8), to: places.oneOffs)

        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)

        #expect(screen.offersATakeOut)
        #expect(
            screen.storesNotRead == [
                CommitmentsScreen.StoreNotRead(store: .oneOffs, cause: .couldNotBeRead)
            ])
    }
}

@MainActor
@Test(
    "a commitments screen offers a take-out over a store written by a later version, and says so rather than that it could not be read"
)
func aCommitmentsScreenOffersATakeOutOverAStoreWrittenByALaterVersionAndSaysSoRatherThanThatItCouldNotBeRead()
    throws
{
    do {
        let places = freshThreePlaces()
        try writeBytes(laterFormBytes(for: .roster), to: places.roster)

        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)

        #expect(screen.offersATakeOut)
        #expect(
            screen.storesNotRead == [
                CommitmentsScreen.StoreNotRead(store: .roster, cause: .writtenByALaterVersion)
            ])
    }

    do {
        let places = freshThreePlaces()
        try writeBytes(laterFormBytes(for: .record), to: places.record)
        try writeBytes(Data("not what a one-off holder is written as".utf8), to: places.oneOffs)

        let screen = CommitmentsScreen(
            asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
            keepingOneOffsAt: places.oneOffs)

        #expect(screen.offersATakeOut)
        #expect(
            screen.storesNotRead == [
                CommitmentsScreen.StoreNotRead(store: .record, cause: .writtenByALaterVersion),
                CommitmentsScreen.StoreNotRead(store: .oneOffs, cause: .couldNotBeRead),
            ])
    }
}

@MainActor
@Test("a commitments screen shown again says what the three places then hold")
func aCommitmentsScreenShownAgainSaysWhatTheThreePlacesThenHold() throws {
    let places = freshThreePlaces()

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
    #expect(!screen.offersATakeOut)

    try writeBytes(Data("not what a record is written as".utf8), to: places.record)

    #expect(!screen.offersATakeOut)
    screen.shown(asOf: monday)
    #expect(screen.offersATakeOut)
    #expect(
        screen.storesNotRead == [CommitmentsScreen.StoreNotRead(store: .record, cause: .couldNotBeRead)])

    try FileManager.default.removeItem(at: places.record)

    #expect(screen.offersATakeOut)
    screen.shown(asOf: monday)
    #expect(!screen.offersATakeOut)
}

@MainActor
@Test("a commitments screen that confirmed a restore offers no take-out")
func aCommitmentsScreenThatConfirmedARestoreOffersNoTakeOut() throws {
    let places = freshThreePlaces()
    try writeBytes(Data("not what a record is written as".utf8), to: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
    #expect(screen.offersATakeOut)

    let sourcePlaces = freshThreePlaces()
    try RosterStore(at: sourcePlaces.roster).add(gym)
    let sourceScreen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: sourcePlaces.roster, keepingRecordAt: sourcePlaces.record,
        keepingOneOffsAt: sourcePlaces.oneOffs)
    let result = sourceScreen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: freshDirectory())
    guard case .success(let file) = result else {
        Issue.record("expected a copy to be made")
        return
    }

    #expect(screen.askToRestore(from: file) == nil)
    #expect(screen.confirmRestoring() == nil)
    #expect(!screen.offersATakeOut)
}

@MainActor
@Test("a commitments screen holding a save in progress it could not undo offers a take-out naming all three")
func aCommitmentsScreenHoldingASaveInProgressItCouldNotUndoOffersATakeOutNamingAllThree() throws {
    let places = freshThreePlaces()
    try RosterStore(at: places.roster).add(gym)
    let saveInProgressPlace = SaveInProgress.place(besideRecordAt: places.record)
    try writeBytes(Data("not what a save in progress is written as".utf8), to: saveInProgressPlace)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    #expect(screen.offersATakeOut)
    #expect(
        screen.storesNotRead == [
            CommitmentsScreen.StoreNotRead(store: .record, cause: .couldNotBeRead),
            CommitmentsScreen.StoreNotRead(store: .roster, cause: .couldNotBeRead),
            CommitmentsScreen.StoreNotRead(store: .oneOffs, cause: .couldNotBeRead),
        ])
}

// MARK: - § 5: taking the files out

@MainActor
@Test(
    "a commitments screen asked for a take-out answers where every file was written, in the order record, roster, one-offs"
)
func aCommitmentsScreenAskedForATakeOutAnswersWhereEveryFileWasWrittenInTheOrderRecordRosterOneOffs()
    throws
{
    let places = freshThreePlaces()
    try RosterStore(at: places.roster).add(gym)
    try OneOffStore(at: places.oneOffs).add(OneOff(name: "Book dentist", date: september25th)!)
    try writeBytes(Data("not what a record is written as".utf8), to: places.record)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    let directory = freshDirectory()
    let result = screen.takeOut(writingInto: directory)

    guard case .success(let urls) = result else {
        Issue.record("expected a take-out to be made")
        return
    }
    #expect(urls.map(\.lastPathComponent) == ["record.json", "roster.json", "one-offs.json"])
    let parent = try #require(urls.first).deletingLastPathComponent()
    let contents = try FileManager.default.contentsOfDirectory(atPath: parent.path)
    #expect(Set(contents) == Set(urls.map(\.lastPathComponent)))
}

@MainActor
@Test(
    "a take-out made leaves a commitments screen's lists and what it is awaiting exactly as they were"
)
func aTakeOutMadeLeavesACommitmentsScreensListsAndWhatItIsAwaitingExactlyAsTheyWere() throws {
    let places = freshThreePlaces()
    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.retire(journaling, keptUntil: sunday)
    try writeBytes(Data("not a one-off holder".utf8), to: places.oneOffs)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
    screen.askToDelete(gym)
    screen.nameTypedBack = "Gym"

    let result = screen.takeOut(writingInto: freshDirectory())
    guard case .success = result else {
        Issue.record("expected a take-out to be made")
        return
    }

    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.stopped.map(\.name) == ["Journaling"])
    #expect(screen.awaitingDeletion == gym)
    #expect(screen.nameTypedBack == "Gym")
    #expect(screen.awaitingConfirmation == nil)
}

@MainActor
@Test("a take-out made leaves a refused change standing and says nothing of its own")
func aTakeOutMadeLeavesARefusedChangeStandingAndSaysNothingOfItsOwn() throws {
    let places = freshThreePlaces()
    try RosterStore(at: places.roster).add(gym)
    try writeBytes(Data("not a one-off holder".utf8), to: places.oneOffs)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    let defineRefusal = screen.define(name: "Gym", on: allWeekdaysRhythm, keptFrom: keptFrom, under: nil)
    #expect(defineRefusal == .nameAlreadyInUse("Gym"))

    let result = screen.takeOut(writingInto: freshDirectory())
    guard case .success = result else {
        Issue.record("expected a take-out to be made")
        return
    }

    #expect(screen.refusedChange == .defining(.nameAlreadyInUse("Gym")))
}

@MainActor
@Test("a take-out asked for where a commitments screen offers none hands out nothing and writes nothing")
func aTakeOutAskedForWhereACommitmentsScreenOffersNoneHandsOutNothingAndWritesNothing() throws {
    let places = freshThreePlaces()
    try RosterStore(at: places.roster).add(gym)
    let rosterBytes = try Data(contentsOf: places.roster)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
    #expect(!screen.offersATakeOut)

    let directory = freshDirectory()
    let result = screen.takeOut(writingInto: directory)

    guard case .success(let urls) = result else {
        Issue.record("expected a take-out not to be refused")
        return
    }
    #expect(urls.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: directory.path))
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
}

@MainActor
@Test("a take-out asked for twice leaves the files of the first standing")
func aTakeOutAskedForTwiceLeavesTheFilesOfTheFirstStanding() throws {
    let places = freshThreePlaces()
    try writeBytes(Data("not what a roster is written as".utf8), to: places.roster)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    let directory = freshDirectory()
    let first = screen.takeOut(writingInto: directory)
    guard case .success(let firstURLs) = first, let firstURL = firstURLs.first else {
        Issue.record("expected the first take-out to be made")
        return
    }
    let firstBytes = try Data(contentsOf: firstURL)

    let second = screen.takeOut(writingInto: directory)
    guard case .success(let secondURLs) = second, let secondURL = secondURLs.first else {
        Issue.record("expected the second take-out to be made")
        return
    }

    #expect(firstURL != secondURL)
    #expect(try Data(contentsOf: firstURL) == firstBytes)
}

// MARK: - § 6: a take-out that cannot be made

@MainActor
@Test("a take-out refused names the store that could not be taken out and hands out none of the others")
func aTakeOutRefusedNamesTheStoreThatCouldNotBeTakenOutAndHandsOutNoneOfTheOthers() throws {
    let places = freshThreePlaces()
    try RosterStore(at: places.roster).add(gym)
    let rosterBytes = try Data(contentsOf: places.roster)
    try FileManager.default.createDirectory(at: places.record, withIntermediateDirectories: true)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
    #expect(screen.offersATakeOut)

    let directory = freshDirectory()
    let result = screen.takeOut(writingInto: directory)

    guard case .failure(let refusal) = result else {
        Issue.record("expected a take-out to be refused")
        return
    }
    #expect(refusal == .storeCouldNotBeRead)
    #expect(screen.refusedChange == .takingOut(.record, .storeCouldNotBeRead))
    // A refused take-out is never asked through the sheet, so it leaves no refusal at its foot.
    #expect(screen.sheetRefusal == nil)
    // No file stands in `directory`: the fresh subdirectory `takeOut` wrote the roster into is
    // removed whole on the refusal, so at most an empty `directory` is left where nothing stood
    // before this call.
    if FileManager.default.fileExists(atPath: directory.path) {
        #expect(try FileManager.default.contentsOfDirectory(atPath: directory.path).isEmpty)
    }
    #expect(try Data(contentsOf: places.roster) == rosterBytes)

    // A save in progress that cannot be handed over is refused the same way, naming the record.
    let places2 = freshThreePlaces()
    try RosterStore(at: places2.roster).add(gym)
    let saveInProgressPlace = SaveInProgress.place(besideRecordAt: places2.record)
    try FileManager.default.createDirectory(
        at: saveInProgressPlace, withIntermediateDirectories: true)

    let screen2 = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places2.roster, keepingRecordAt: places2.record,
        keepingOneOffsAt: places2.oneOffs)

    let result2 = screen2.takeOut(writingInto: freshDirectory())
    guard case .failure(let refusal2) = result2 else {
        Issue.record("expected the second take-out to be refused")
        return
    }
    #expect(refusal2 == .storeCouldNotBeRead)
    #expect(screen2.refusedChange == .takingOut(.record, .storeCouldNotBeRead))
    #expect(screen2.sheetRefusal == nil)
}

@MainActor
@Test("a take-out that cannot be written where it is to be written is refused as a place that could not be written")
func aTakeOutThatCannotBeWrittenWhereItIsToBeWrittenIsRefusedAsAPlaceThatCouldNotBeWritten() throws {
    let places = freshThreePlaces()
    try writeBytes(Data("not what a roster is written as".utf8), to: places.roster)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)

    let directory = freshDirectory()
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
    defer {
        try? FileManager.default.setAttributes(
            [.posixPermissions: 0o700], ofItemAtPath: directory.path)
    }

    let result = screen.takeOut(writingInto: directory)

    guard case .failure(let refusal) = result else {
        Issue.record("expected a take-out to be refused")
        return
    }
    #expect(refusal == .notKept)
    #expect(refusal != .storeCouldNotBeRead)
    #expect(screen.refusedChange == .takingOut(nil, .notKept))
    #expect(screen.sheetRefusal == nil)
    #expect(try FileManager.default.contentsOfDirectory(atPath: directory.path).isEmpty)
}

@MainActor
@Test("a take-out refused replaces the refused change a commitments screen held")
func aTakeOutRefusedReplacesTheRefusedChangeACommitmentsScreenHeld() throws {
    let places = freshThreePlaces()
    try RosterStore(at: places.roster).add(gym)
    try writeBytes(Data("not a one-off holder".utf8), to: places.oneOffs)

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
    let defineRefusal = screen.define(name: "Gym", on: allWeekdaysRhythm, keptFrom: keptFrom, under: nil)
    #expect(defineRefusal == .nameAlreadyInUse("Gym"))
    #expect(screen.refusedChange == .defining(.nameAlreadyInUse("Gym")))
    let sheetRefusalBeforeTakeOut = screen.sheetRefusal
    #expect(sheetRefusalBeforeTakeOut != nil)

    let directory = freshDirectory()
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
    defer {
        try? FileManager.default.setAttributes(
            [.posixPermissions: 0o700], ofItemAtPath: directory.path)
    }

    let result = screen.takeOut(writingInto: directory)
    guard case .failure = result else {
        Issue.record("expected a take-out to be refused")
        return
    }

    #expect(screen.refusedChange == .takingOut(nil, .notKept))
    // The refusal replaces `refusedChange` but is never asked through the sheet, so
    // `sheetRefusal` is left exactly as the definition's own refusal set it.
    #expect(screen.sheetRefusal == sheetRefusalBeforeTakeOut)
}
