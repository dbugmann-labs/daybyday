import Foundation
import Testing
import DayByDayKit

/// A fresh place under the temporary directory, one per test, so tests are independent and need
/// no teardown: a UUID names the directory, and the store's file sits one level under it, so the
/// directory itself does not exist until the store creates it. Mirrors `RecordStoreTests`'s
/// `freshPlace()`.
private func freshPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("roster.json")
}

@Test("a roster store opened where nothing has been kept holds a roster holding nothing")
func aRosterStoreOpenedWhereNothingHasBeenKeptHoldsARosterHoldingNothing() throws {
    let place = freshPlace()

    let store = try RosterStore(at: place)

    #expect(store.roster == Roster())
}

@Test(
    "a commitment taken on through a roster store is held by a second store opened at the same place while the first is still open"
)
func aCommitmentTakenOnThroughARosterStoreIsHeldByASecondStoreOpenedAtTheSamePlaceWhileTheFirstIsStillOpen()
    throws
{
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    let first = try RosterStore(at: place)
    let added = try first.add(gym)
    let second = try RosterStore(at: place)

    #expect(added)
    var expected = Roster()
    _ = expected.add(gym)
    #expect(second.roster == expected)
}

@Test("a roster store opened again holds its commitments in the order they were taken on")
func aRosterStoreOpenedAgainHoldsItsCommitmentsInTheOrderTheyWereTakenOn() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    let store = try RosterStore(at: place)
    try store.add(waterPlants)
    try store.add(gym)
    try store.add(journaling)

    let later = try RosterStore(at: place)

    #expect(later.roster.commitments == [waterPlants, gym, journaling])
    var expected = Roster()
    _ = expected.add(waterPlants)
    _ = expected.add(gym)
    _ = expected.add(journaling)
    #expect(later.roster == expected)
}

@Test("a commitment stopped through a roster store is read back stopped, on the day it was kept until")
func aCommitmentStoppedThroughARosterStoreIsReadBackStoppedOnTheDayItWasKeptUntil() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let januaryThirtyFirst = CalendarDate(year: 2026, month: 1, day: 31)!
    let februaryFirst = CalendarDate(year: 2026, month: 2, day: 1)!

    let store = try RosterStore(at: place)
    try store.add(waterPlants)
    try store.add(gym)
    try store.add(journaling)
    let stopped = try store.retire(gym, keptUntil: januaryThirtyFirst)

    let later = try RosterStore(at: place)

    #expect(stopped)
    #expect(
        later.roster.commitments(on: januaryThirtyFirst) == [waterPlants, gym, journaling])
    #expect(later.roster.commitments(on: februaryFirst) == [waterPlants, journaling])
}

@Test(
    "a commitment taken up again through a roster store is read back kept, in the place it was taken on in"
)
func aCommitmentTakenUpAgainThroughARosterStoreIsReadBackKeptInThePlaceItWasTakenOnIn() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let januaryThirtyFirst = CalendarDate(year: 2026, month: 1, day: 31)!

    let store = try RosterStore(at: place)
    try store.add(waterPlants)
    try store.add(gym)
    try store.add(journaling)
    try store.retire(gym, keptUntil: januaryThirtyFirst)
    try store.add(gym)

    let later = try RosterStore(at: place)

    #expect(later.roster.commitments == [waterPlants, gym, journaling])
    var expected = Roster()
    _ = expected.add(waterPlants)
    _ = expected.add(gym)
    _ = expected.add(journaling)
    #expect(later.roster == expected)
}

@Test("a commitment a roster store is already keeping is refused and nothing at its place changes")
func aCommitmentARosterStoreIsAlreadyKeepingIsRefusedAndNothingAtItsPlaceChanges() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let sameGym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    let store = try RosterStore(at: place)
    try store.add(gym)
    let addedAgain = try store.add(sameGym)

    let later = try RosterStore(at: place)

    #expect(!addedAgain)
    #expect(store.roster.commitments == [gym])
    var expected = Roster()
    _ = expected.add(gym)
    #expect(later.roster == expected)
}

@Test("a stop a roster store refuses is reported and nothing at its place changes")
func aStopARosterStoreRefusesIsReportedAndNothingAtItsPlaceChanges() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let januaryThirtyFirst = CalendarDate(year: 2026, month: 1, day: 31)!
    let februaryTwentyEighth = CalendarDate(year: 2026, month: 2, day: 28)!
    let februaryFirst = CalendarDate(year: 2026, month: 2, day: 1)!

    let store = try RosterStore(at: place)
    try store.add(gym)
    try store.retire(gym, keptUntil: januaryThirtyFirst)
    let stoppedAgain = try store.retire(gym, keptUntil: februaryTwentyEighth)
    let stoppedNotHeld = try store.retire(run, keptUntil: januaryThirtyFirst)

    let later = try RosterStore(at: place)

    #expect(!stoppedAgain)
    #expect(!stoppedNotHeld)
    #expect(later.roster.commitments(on: januaryThirtyFirst) == [gym])
    #expect(later.roster.commitments(on: februaryFirst) == [])
    var expected = Roster()
    _ = expected.add(gym)
    _ = expected.retire(gym, keptUntil: januaryThirtyFirst)
    #expect(later.roster == expected)
}

@Test("commitments on every schedule shape are read back as the same commitments")
func commitmentsOnEveryScheduleShapeAreReadBackAsTheSameCommitments() throws {
    let place = freshPlace()
    let januaryFirst2026 = CalendarDate(year: 2026, month: 1, day: 1)!

    let gym = Commitment(
        name: "Gym",
        schedule: .weekdays([.monday, .wednesday, .saturday]),
        keptFrom: januaryFirst2026)!

    let finances = Commitment(
        name: "Finances",
        schedule: .dayOfMonth(DayOfMonth(day: 25)!),
        keptFrom: januaryFirst2026)!

    let plants = Commitment(
        name: "Plants",
        schedule: .everyNDays(
            DayInterval(days: 3)!, from: CalendarDate(year: 2026, month: 8, day: 25)!),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!)!

    let reading = Commitment(
        name: "Reading",
        schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!),
        keptFrom: januaryFirst2026)!

    let store = try RosterStore(at: place)
    try store.add(gym)
    try store.add(finances)
    try store.add(plants)
    try store.add(reading)

    let later = try RosterStore(at: place)

    var expected = Roster()
    _ = expected.add(gym)
    _ = expected.add(finances)
    _ = expected.add(plants)
    _ = expected.add(reading)
    #expect(later.roster == expected)

    #expect(later.roster.commitments == [gym, finances, plants, reading])
}

@Test("a commitment name is read back out of a roster store exactly, whatever it contains")
func aCommitmentNameIsReadBackOutOfARosterStoreExactlyWhateverItContains() throws {
    let place = freshPlace()
    let name = "Zürich — „langer“ Lauf 🏃\nSonntags"
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: name, schedule: schedule, keptFrom: keptFrom)!

    let store = try RosterStore(at: place)
    try store.add(commitment)

    let later = try RosterStore(at: place)

    #expect(later.roster.commitments.map(\.name) == [name])
    var expected = Roster()
    _ = expected.add(commitment)
    #expect(later.roster == expected)
}

@Test("a roster kept from the first supported date and stopped on the last is read back unchanged")
func aRosterKeptFromTheFirstSupportedDateAndStoppedOnTheLastIsReadBackUnchanged() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let firstSupported = CalendarDate(year: 1583, month: 1, day: 1)!
    let lastSupported = CalendarDate(year: 9999, month: 12, day: 31)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: firstSupported)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: lastSupported)!

    let store = try RosterStore(at: place)
    try store.add(gym)
    try store.add(run)
    try store.retire(gym, keptUntil: lastSupported)

    let later = try RosterStore(at: place)

    var expected = Roster()
    _ = expected.add(gym)
    _ = expected.add(run)
    _ = expected.retire(gym, keptUntil: lastSupported)
    #expect(later.roster == expected)
    #expect(later.roster.commitments(on: lastSupported) == [gym, run])
}

@Test("roster stores at different places hold different rosters")
func rosterStoresAtDifferentPlacesHoldDifferentRosters() throws {
    let firstPlace = freshPlace()
    let secondPlace = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    let first = try RosterStore(at: firstPlace)
    try first.add(gym)
    let second = try RosterStore(at: secondPlace)

    #expect(second.roster == Roster())

    let laterFirst = try RosterStore(at: firstPlace)
    var expected = Roster()
    _ = expected.add(gym)
    #expect(laterFirst.roster == expected)
}

@Test("a change that cannot be kept is refused and not held")
func aChangeThatCannotBeKeptIsRefusedAndNotHeld() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    let place = blocker.appendingPathComponent("roster.json")

    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    let store = try RosterStore(at: place)

    #expect(throws: RosterStoreError.cannotWrite(at: place)) {
        try store.add(gym)
    }
    #expect(store.roster == Roster())

    let later = try RosterStore(at: place)
    #expect(later.roster == Roster())
}

@Test("content that is not a roster store is refused and left as it was")
func contentThatIsNotARosterStoreIsRefusedAndLeftAsItWas() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data("not a roster store".utf8)
    try bytes.write(to: place)

    #expect(throws: RosterStoreError.notAStore(at: place)) {
        try RosterStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a roster store written in a later form than this app knows is refused")
func aRosterStoreWrittenInALaterFormThanThisAppKnowsIsRefused() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(#"{"version": 2, "commitments": []}"#.utf8)
    try bytes.write(to: place)

    #expect(throws: RosterStoreError.laterForm(at: place, version: 2)) {
        try RosterStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a roster store holding what could not be a roster is refused")
func aRosterStoreHoldingWhatCouldNotBeARosterIsRefused() throws {
    let blankNamePlace = freshPlace()
    try FileManager.default.createDirectory(
        at: blankNamePlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let blankNameBytes = Data(
        """
        {
          "version": 1,
          "commitments": [
            {
              "commitment": {
                "name": "   ",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              }
            }
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
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 2, "day": 30 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              }
            }
          ]
        }
        """.utf8)
    try noSuchDayBytes.write(to: noSuchDayPlace)

    let sameCommitmentTwicePlace = freshPlace()
    try FileManager.default.createDirectory(
        at: sameCommitmentTwicePlace.deletingLastPathComponent(),
        withIntermediateDirectories: true)
    let sameCommitmentTwiceBytes = Data(
        """
        {
          "version": 1,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              }
            },
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              }
            }
          ]
        }
        """.utf8)
    try sameCommitmentTwiceBytes.write(to: sameCommitmentTwicePlace)

    #expect(throws: RosterStoreError.notAStore(at: blankNamePlace)) {
        try RosterStore(at: blankNamePlace)
    }
    #expect(throws: RosterStoreError.notAStore(at: noSuchDayPlace)) {
        try RosterStore(at: noSuchDayPlace)
    }
    #expect(throws: RosterStoreError.notAStore(at: sameCommitmentTwicePlace)) {
        try RosterStore(at: sameCommitmentTwicePlace)
    }
    #expect(try Data(contentsOf: blankNamePlace) == blankNameBytes)
    #expect(try Data(contentsOf: noSuchDayPlace) == noSuchDayBytes)
    #expect(try Data(contentsOf: sameCommitmentTwicePlace) == sameCommitmentTwiceBytes)
}
