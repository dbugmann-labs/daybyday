import Foundation
import Testing
@testable import DayByDayKit

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
    let stopped = try store.retire(gym, keptUntil: lastSupported)

    let later = try RosterStore(at: place)

    var expected = Roster()
    _ = expected.add(gym)
    _ = expected.add(run)
    _ = expected.retire(gym, keptUntil: lastSupported)
    #expect(stopped)
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
    let bytes = Data(#"{"version": 6, "commitments": []}"#.utf8)
    try bytes.write(to: place)

    #expect(throws: RosterStoreError.laterForm(at: place, version: 6)) {
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
    // One identity, kept from one day, twice — two eras cannot both be true of it.
    let sameCommitmentTwiceBytes = Data(
        """
        {
          "version": 5,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "identity": "11111111-1111-1111-1111-111111111111"
              },
              "removed": false,
              "category": null
            },
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "identity": "11111111-1111-1111-1111-111111111111"
              },
              "keptUntil": { "year": 2026, "month": 1, "day": 31 },
              "removed": false,
              "category": null
            }
          ]
        }
        """.utf8)
    try sameCommitmentTwiceBytes.write(to: sameCommitmentTwicePlace)

    let halfRangePlace = freshPlace()
    try FileManager.default.createDirectory(
        at: halfRangePlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let halfRangeBytes = Data(
        """
        {
          "version": 1,
          "commitments": [
            {
              "commitment": {
                "name": "Weight",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "number": { "lowest": 40 } }
              }
            }
          ]
        }
        """.utf8)
    try halfRangeBytes.write(to: halfRangePlace)

    #expect(throws: RosterStoreError.notAStore(at: blankNamePlace)) {
        try RosterStore(at: blankNamePlace)
    }
    #expect(throws: RosterStoreError.notAStore(at: noSuchDayPlace)) {
        try RosterStore(at: noSuchDayPlace)
    }
    #expect(throws: RosterStoreError.notAStore(at: sameCommitmentTwicePlace)) {
        try RosterStore(at: sameCommitmentTwicePlace)
    }
    #expect(throws: RosterStoreError.notAStore(at: halfRangePlace)) {
        try RosterStore(at: halfRangePlace)
    }
    #expect(try Data(contentsOf: blankNamePlace) == blankNameBytes)
    #expect(try Data(contentsOf: noSuchDayPlace) == noSuchDayBytes)
    #expect(try Data(contentsOf: sameCommitmentTwicePlace) == sameCommitmentTwiceBytes)
    #expect(try Data(contentsOf: halfRangePlace) == halfRangeBytes)
}

@Test("a roster store holding a commitment with half a range is refused")
func aRosterStoreHoldingACommitmentWithHalfARangeIsRefused() throws {
    let lowestOnlyPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: lowestOnlyPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let lowestOnlyBytes = Data(
        """
        {
          "version": 1,
          "commitments": [
            {
              "commitment": {
                "name": "Weight",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "number": { "lowest": 40 } }
              }
            }
          ]
        }
        """.utf8)
    try lowestOnlyBytes.write(to: lowestOnlyPlace)

    let highestOnlyPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: highestOnlyPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let highestOnlyBytes = Data(
        """
        {
          "version": 1,
          "commitments": [
            {
              "commitment": {
                "name": "Weight",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "number": { "highest": 150 } }
              }
            }
          ]
        }
        """.utf8)
    try highestOnlyBytes.write(to: highestOnlyPlace)

    #expect(throws: RosterStoreError.notAStore(at: lowestOnlyPlace)) {
        try RosterStore(at: lowestOnlyPlace)
    }
    #expect(throws: RosterStoreError.notAStore(at: highestOnlyPlace)) {
        try RosterStore(at: highestOnlyPlace)
    }
    #expect(try Data(contentsOf: lowestOnlyPlace) == lowestOnlyBytes)
    #expect(try Data(contentsOf: highestOnlyPlace) == highestOnlyBytes)
}

@Test("a commitment of each kind is read back as the same commitment")
func aCommitmentOfEachKindIsReadBackAsTheSameCommitment() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!
    let mood = Commitment(
        name: "Mood", schedule: schedule, keptFrom: keptFrom,
        kind: .number(range: Commitment.Range(lowest: 1, highest: 10)!))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!

    let store = try RosterStore(at: place)
    try store.add(gym)
    try store.add(weight)
    try store.add(mood)
    try store.add(journal)
    try store.add(protein)

    let later = try RosterStore(at: place)

    var expected = Roster()
    _ = expected.add(gym)
    _ = expected.add(weight)
    _ = expected.add(mood)
    _ = expected.add(journal)
    _ = expected.add(protein)
    #expect(later.roster == expected)
    #expect(later.roster.commitments.map(\.kind) == [
        gym.kind, weight.kind, mood.kind, journal.kind, protein.kind,
    ])
}

@Test("a range and a target are read back exactly, decimal fractions and all")
func aRangeAndATargetAreReadBackExactlyDecimalFractionsAndAll() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: -40.5, highest: 150.25)!
    let target = Commitment.Target(119.95)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom, kind: .total(target: target))!

    let store = try RosterStore(at: place)
    try store.add(weight)
    try store.add(protein)

    let later = try RosterStore(at: place)

    var expected = Roster()
    _ = expected.add(weight)
    _ = expected.add(protein)
    #expect(later.roster == expected)
    guard case .number(range: let readRange?) = later.roster.commitments[0].kind else {
        Issue.record("expected a number commitment with a range")
        return
    }
    guard case .total(target: let readTarget) = later.roster.commitments[1].kind else {
        Issue.record("expected a total commitment with a target")
        return
    }
    #expect(readRange.lowest == -40.5)
    #expect(readRange.highest == 150.25)
    #expect(readTarget.amount == 119.95)
}

@Test("a roster kept before a commitment carried a kind is read with every commitment of the plain kind")
func aRosterKeptBeforeACommitmentCarriedAKindIsReadWithEveryCommitmentOfThePlainKind() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
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
                "name": "Finances",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "dayOfMonth": 25 }
              }
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RosterStore(at: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom,
        kind: .tick)!
    let finances = Commitment(
        name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 25)!), keptFrom: keptFrom,
        kind: .tick)!
    var expected = Roster()
    _ = expected.add(gym)
    _ = expected.add(finances)
    #expect(store.roster == expected)
}

@Test("reading a roster kept in an earlier form changes nothing at its place")
func readingARosterKeptInAnEarlierFormChangesNothingAtItsPlace() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
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
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    _ = try RosterStore(at: place)

    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a commitment of another kind taken on over a roster kept in an earlier form is read back with its kind")
func aCommitmentOfAnotherKindTakenOnOverARosterKeptInAnEarlierFormIsReadBackWithItsKind() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
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
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RosterStore(at: place)
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    try store.add(weight)

    let later = try RosterStore(at: place)

    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    var expected = Roster()
    _ = expected.add(gym)
    _ = expected.add(weight)
    #expect(later.roster == expected)
    #expect(later.roster.commitments.map(\.kind) == [.tick, .number(range: range)])
}

@Test("a roster store written in a form this app has never written is refused")
func aRosterStoreWrittenInAFormThisAppHasNeverWrittenIsRefused() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(#"{"version": 0, "commitments": []}"#.utf8)
    try bytes.write(to: place)

    #expect(throws: RosterStoreError.notAStore(at: place)) {
        try RosterStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a commitment removed through a roster store is read back removed, on the day it was kept until")
func aCommitmentRemovedThroughARosterStoreIsReadBackRemovedOnTheDayItWasKeptUntil() throws {
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
    let removed = try store.remove(gym, keptUntil: januaryThirtyFirst)

    let later = try RosterStore(at: place)

    #expect(removed)
    var expected = Roster()
    _ = expected.add(waterPlants)
    _ = expected.add(gym)
    _ = expected.add(journaling)
    _ = expected.remove(gym, keptUntil: januaryThirtyFirst)
    #expect(later.roster == expected)
    #expect(
        later.roster.commitments(on: januaryThirtyFirst) == [waterPlants, gym, journaling])
    #expect(later.roster.commitments(on: februaryFirst) == [waterPlants, journaling])
}

@Test("a removal a roster store refuses is reported and nothing at its place changes")
func aRemovalARosterStoreRefusesIsReportedAndNothingAtItsPlaceChanges() throws {
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
    try store.remove(gym, keptUntil: januaryThirtyFirst)
    let removedAgain = try store.remove(gym, keptUntil: februaryTwentyEighth)
    let removedNotHeld = try store.remove(run, keptUntil: januaryThirtyFirst)

    let later = try RosterStore(at: place)

    #expect(!removedAgain)
    #expect(!removedNotHeld)
    #expect(later.roster.commitments(on: januaryThirtyFirst) == [gym])
    #expect(later.roster.commitments(on: februaryFirst) == [])
    var expected = Roster()
    _ = expected.add(gym)
    _ = expected.remove(gym, keptUntil: januaryThirtyFirst)
    #expect(later.roster == expected)
}

@Test("a commitment taken up again through a roster store after being removed is read back kept")
func aCommitmentTakenUpAgainThroughARosterStoreAfterBeingRemovedIsReadBackKept() throws {
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
    try store.remove(gym, keptUntil: januaryThirtyFirst)
    try store.add(gym)

    let later = try RosterStore(at: place)

    #expect(later.roster.commitments == [waterPlants, gym, journaling])
    var expected = Roster()
    _ = expected.add(waterPlants)
    _ = expected.add(gym)
    _ = expected.add(journaling)
    #expect(later.roster == expected)
}

@Test("a removal that cannot be kept is refused and the roster a store reports does not move")
func aRemovalThatCannotBeKeptIsRefusedAndTheRosterAStoreReportsDoesNotMove() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let place = directory.appendingPathComponent("roster.json")
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    let store = try RosterStore(at: place)
    try store.add(gym)

    try FileManager.default.removeItem(at: directory)
    try Data().write(to: directory)

    #expect(throws: RosterStoreError.cannotWrite(at: place)) {
        try store.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    }

    var expected = Roster()
    _ = expected.add(gym)
    #expect(store.roster == expected)
}

@Test("a roster kept before a commitment could be removed is read with every commitment not removed")
func aRosterKeptBeforeACommitmentCouldBeRemovedIsReadWithEveryCommitmentNotRemoved() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 2,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "keptUntil": { "year": 2026, "month": 1, "day": 31 }
            },
            {
              "commitment": {
                "name": "Journaling",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              }
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RosterStore(at: place)

    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    var expected = Roster()
    _ = expected.add(gym)
    _ = expected.add(journaling)
    _ = expected.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    #expect(store.roster == expected)
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a commitment removed over a roster kept before removal existed is read back removed")
func aCommitmentRemovedOverARosterKeptBeforeRemovalExistedIsReadBackRemoved() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 2,
          "commitments": [
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
    try bytes.write(to: place)

    let store = try RosterStore(at: place)
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    try store.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let later = try RosterStore(at: place)

    var expected = Roster()
    _ = expected.add(gym)
    _ = expected.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    #expect(later.roster == expected)
    #expect(later.roster.commitments.isEmpty)
}

@Test("a roster store declaring a form written before removal and saying something about removal is refused")
func aRosterStoreDeclaringAFormWrittenBeforeRemovalAndSayingSomethingAboutRemovalIsRefused() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 2,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": false
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    #expect(throws: RosterStoreError.notAStore(at: place)) {
        try RosterStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a roster store declaring the form this app writes and saying nothing about removal is refused")
func aRosterStoreDeclaringTheFormThisAppWritesAndSayingNothingAboutRemovalIsRefused() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "category": "Sport"
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    #expect(throws: RosterStoreError.notAStore(at: place)) {
        try RosterStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a roster store holding a commitment removed with no day it was kept until is refused")
func aRosterStoreHoldingACommitmentRemovedWithNoDayItWasKeptUntilIsRefused() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 3,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": true
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    #expect(throws: RosterStoreError.notAStore(at: place)) {
        try RosterStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a commitment moved through a roster store is read back in the place it was moved to")
func aCommitmentMovedThroughARosterStoreIsReadBackInThePlaceItWasMovedTo() throws {
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
    let moved = try store.move(journaling, toOffset: 0, under: nil)

    let later = try RosterStore(at: place)

    #expect(moved)
    #expect(later.roster.commitments == [journaling, waterPlants, gym])
    var expected = Roster()
    _ = expected.add(journaling)
    _ = expected.add(waterPlants)
    _ = expected.add(gym)
    #expect(later.roster == expected)
}

@Test("a move a roster store refuses is reported and nothing at its place changes")
func aMoveARosterStoreRefusesIsReportedAndNothingAtItsPlaceChanges() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    let store = try RosterStore(at: place)
    try store.add(waterPlants)
    try store.add(gym)
    let moved = try store.move(run, toOffset: 0, under: nil)

    let later = try RosterStore(at: place)

    #expect(!moved)
    #expect(later.roster.commitments == [waterPlants, gym])
}

@Test("a move that leaves a roster as it was keeps nothing at its place")
func aMoveThatLeavesARosterAsItWasKeepsNothingAtItsPlace() throws {
    // Route 1, `design.md` § *Strengthened in place, and the three proven by mutation* (the four
    // no-op tests): the place is seeded with the roster in an earlier form, one the store itself
    // would never write. A write that rewrote byte-identical content would be invisible to a
    // check against bytes the store wrote itself, because `RosterStore.write` is byte-stable;
    // seeded here in a form only a write would ever replace, any write at all is visible.
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let bytes = Data(
        """
        {
          "version": 1,
          "commitments": [
            {
              "commitment": {
                "name": "Water plants",
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
    try bytes.write(to: place)

    let store = try RosterStore(at: place)

    let moved = try store.move(gym, toOffset: 2, under: nil)

    #expect(moved)
    #expect(try Data(contentsOf: place) == bytes)
    #expect(store.roster.commitments == [waterPlants, gym])
}

@Test("a move that cannot be kept is refused and the roster a store reports does not move")
func aMoveThatCannotBeKeptIsRefusedAndTheRosterAStoreReportsDoesNotMove() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let place = directory.appendingPathComponent("roster.json")
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    let store = try RosterStore(at: place)
    try store.add(waterPlants)
    try store.add(gym)

    try FileManager.default.removeItem(at: directory)
    try Data().write(to: directory)

    #expect(throws: RosterStoreError.cannotWrite(at: place)) {
        try store.move(gym, toOffset: 0, under: nil)
    }

    var expected = Roster()
    _ = expected.add(waterPlants)
    _ = expected.add(gym)
    #expect(store.roster == expected)
}

@Test("a roster store declaring a form written before categories and saying something about one is refused")
func aRosterStoreDeclaringAFormWrittenBeforeCategoriesAndSayingSomethingAboutOneIsRefused() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 3,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": false,
              "category": null
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    #expect(throws: RosterStoreError.notAStore(at: place)) {
        try RosterStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a roster store declaring the form this app writes and saying nothing about a category is refused")
func aRosterStoreDeclaringTheFormThisAppWritesAndSayingNothingAboutACategoryIsRefused() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": false
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    #expect(throws: RosterStoreError.notAStore(at: place)) {
        try RosterStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a roster kept before a commitment could be put under a category is read with every commitment under none")
func aRosterKeptBeforeACommitmentCouldBePutUnderACategoryIsReadWithEveryCommitmentUnderNone()
    throws
{
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 3,
          "commitments": [
            {
              "commitment": {
                "name": "Creatine",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"] }
              },
              "removed": false
            },
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": false
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RosterStore(at: place)

    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(
        name: "Creatine",
        schedule: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
        keptFrom: keptFrom)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!

    #expect(
        store.roster.groups == [Roster.Group(category: nil, commitments: [creatine, gym])])
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a commitment put under a category over a roster kept before categories existed is read back under it")
func aCommitmentPutUnderACategoryOverARosterKeptBeforeCategoriesExistedIsReadBackUnderIt() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 3,
          "commitments": [
            {
              "commitment": {
                "name": "Creatine",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"] }
              },
              "removed": false
            },
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"] }
              },
              "removed": false
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RosterStore(at: place)
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let schedule = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    try store.put(creatine, under: "Supplements")

    let later = try RosterStore(at: place)

    #expect(
        later.roster.groups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym]),
            ])
    #expect(later.roster.commitments.map(\.kind) == [.tick, .tick])
}

@Test("a commitment put under a category through a roster store is read back under it")
func aCommitmentPutUnderACategoryThroughARosterStoreIsReadBackUnderIt() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    let store = try RosterStore(at: place)
    try store.add(creatine)
    try store.add(gym)
    try store.add(journaling)

    let put = try store.put(creatine, under: "Supplements")

    let later = try RosterStore(at: place)

    #expect(put)
    #expect(
        later.roster.groups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: nil, commitments: [gym, journaling]),
            ])

    var expected = Roster()
    _ = expected.add(creatine)
    _ = expected.add(gym)
    _ = expected.add(journaling)
    _ = expected.put(creatine, under: "Supplements")
    #expect(later.roster == expected)
}

@Test("a category is read back out of a roster store exactly, blank space and all")
func aCategoryIsReadBackOutOfARosterStoreExactlyBlankSpaceAndAll() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    let store = try RosterStore(at: place)
    try store.add(creatine)
    try store.add(gym)
    try store.put(creatine, under: " Supplements ")
    try store.put(gym, under: "Supplements")

    let later = try RosterStore(at: place)

    #expect(
        later.roster.groups
            == [
                Roster.Group(category: " Supplements ", commitments: [creatine]),
                Roster.Group(category: "Supplements", commitments: [gym]),
            ])
}

@Test("a category change a roster store refuses is reported and nothing at its place changes")
func aCategoryChangeARosterStoreRefusesIsReportedAndNothingAtItsPlaceChanges() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    let store = try RosterStore(at: place)
    try store.add(gym)
    try store.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)

    let put = try store.put(gym, under: "Sport")

    let later = try RosterStore(at: place)

    #expect(!put)

    var expected = Roster()
    _ = expected.add(gym)
    _ = expected.retire(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    #expect(later.roster == expected)
}

@Test("a category change that leaves a roster as it was keeps nothing at its place")
func aCategoryChangeThatLeavesARosterAsItWasKeepsNothingAtItsPlace() throws {
    // Route 1, `design.md` § *Strengthened in place, and the three proven by mutation* (the four
    // no-op tests): the current form, laid out with different
    // key order and spacing than `RosterStore.write`'s own `.sortedKeys` encoding ever produces
    // — so any write at all, even of byte-identical content, is visible as bytes changing shape.
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": false,
              "category": "Sport"
            },
            {
              "commitment": {
                "name": "Journaling",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": false,
              "category": null
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RosterStore(at: place)

    let put = try store.put(gym, under: "Sport")

    #expect(put)
    #expect(try Data(contentsOf: place) == bytes)
    #expect(store.roster.groups == [
        Roster.Group(category: "Sport", commitments: [gym]),
        Roster.Group(category: nil, commitments: [journaling]),
    ])
}

@Test("a category change that cannot be kept is refused and the roster a store reports does not move")
func aCategoryChangeThatCannotBeKeptIsRefusedAndTheRosterAStoreReportsDoesNotMove() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let place = directory.appendingPathComponent("roster.json")
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    let store = try RosterStore(at: place)
    try store.add(gym)

    try FileManager.default.removeItem(at: directory)
    try Data().write(to: directory)

    #expect(throws: RosterStoreError.cannotWrite(at: place)) {
        try store.put(gym, under: "Sport")
    }

    var expected = Roster()
    _ = expected.add(gym)
    #expect(store.roster == expected)
}

@Test("a commitment moved under a category through a roster store is read back moved and under it")
func aCommitmentMovedUnderACategoryThroughARosterStoreIsReadBackMovedAndUnderIt() throws {
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

    let moved = try store.move(journaling, toOffset: 0, under: "Sport")

    let later = try RosterStore(at: place)

    #expect(moved)
    #expect(
        later.roster.groups
            == [
                Roster.Group(category: "Sport", commitments: [journaling]),
                Roster.Group(category: nil, commitments: [waterPlants, gym]),
            ])
}

@Test("a group moved through a roster store is read back in the order it was moved into")
func aGroupMovedThroughARosterStoreIsReadBackInTheOrderItWasMovedInto() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: schedule, keptFrom: keptFrom)!

    let store = try RosterStore(at: place)
    try store.add(gym)
    try store.add(creatine)
    try store.add(magnesium)
    try store.put(gym, under: "Sport")
    try store.put(creatine, under: "Supplements")
    try store.put(magnesium, under: "Supplements")
    let moved = try store.move(group: "Supplements", toOffset: 0)

    let later = try RosterStore(at: place)

    #expect(moved)
    #expect(
        later.roster.groups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine, magnesium]),
                Roster.Group(category: "Sport", commitments: [gym]),
            ])
    #expect(later.roster.commitments == [creatine, magnesium, gym])
}

@Test("a group move a roster store refuses keeps nothing at its place")
func aGroupMoveARosterStoreRefusesKeepsNothingAtItsPlace() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!

    let store = try RosterStore(at: place)
    try store.add(gym)
    try store.add(creatine)
    try store.put(creatine, under: "Supplements")
    let bytesBeforeMove = try Data(contentsOf: place)

    let movedNoSuchGroup = try store.move(group: "Sport", toOffset: 0)

    #expect(!movedNoSuchGroup)
    #expect(try Data(contentsOf: place) == bytesBeforeMove)

    let movedOutOfRange = try store.move(group: "Supplements", toOffset: 2)

    #expect(!movedOutOfRange)
    #expect(try Data(contentsOf: place) == bytesBeforeMove)
}

@Test("a group move that leaves a group where it is keeps nothing at a roster store's place")
func aGroupMoveThatLeavesAGroupWhereItIsKeepsNothingAtARosterStoresPlace() throws {
    // Route 1, `design.md` § *Strengthened in place, and the three proven by mutation* (the four
    // no-op tests): the current form, laid out with different
    // key order and spacing than `RosterStore.write`'s own `.sortedKeys` encoding ever produces.
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Creatine",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": false,
              "category": "Supplements"
            },
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": false,
              "category": null
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RosterStore(at: place)

    let movedAtItsOwnOffset = try store.move(group: "Supplements", toOffset: 0)

    #expect(movedAtItsOwnOffset)
    #expect(try Data(contentsOf: place) == bytes)

    let movedAtOffsetJustAfter = try store.move(group: "Supplements", toOffset: 1)

    #expect(movedAtOffsetJustAfter)
    #expect(try Data(contentsOf: place) == bytes)
    #expect(store.roster.groups == [
        Roster.Group(category: "Supplements", commitments: [creatine]),
        Roster.Group(category: nil, commitments: [gym]),
    ])
}

@Test("an era changed through a roster store is read back changed by a store opened afterwards")
func anEraChangedThroughARosterStoreIsReadBackChangedByAStoreOpenedAfterwards() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let newSchedule = Schedule.weekdays([.tuesday, .thursday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let changedGym = Commitment(era: gym, schedule: newSchedule, keptFrom: keptFrom, kind: .tick)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    let first = try RosterStore(at: place)
    try first.add(waterPlants)
    try first.add(gym)
    try first.add(journaling)

    let changed = try first.change(gym, to: changedGym, under: "Sport")

    let later = try RosterStore(at: place)

    #expect(changed)
    #expect(later.roster.commitments == [waterPlants, changedGym, journaling])
    #expect(
        later.roster.groups
            == [
                Roster.Group(category: "Sport", commitments: [changedGym]),
                Roster.Group(category: nil, commitments: [waterPlants, journaling]),
            ])
}

@Test("a commitment superseded through a roster store is read back superseded by a store opened afterwards")
func aCommitmentSupersededThroughARosterStoreIsReadBackSupersededByAStoreOpenedAfterwards() throws {
    let place = freshPlace()
    let originalSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let newSchedule = Schedule.weekdays([.tuesday, .thursday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: originalSchedule, keptFrom: keptFrom)!
    let newGym = Commitment(
        name: "Gym", schedule: newSchedule,
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!)!
    let thirtyFirstOfAugust = CalendarDate(year: 2026, month: 8, day: 31)!

    let first = try RosterStore(at: place)
    try first.add(gym)

    let superseded = try first.supersede(
        gym, with: newGym, keptUntil: thirtyFirstOfAugust, under: nil)

    let later = try RosterStore(at: place)

    #expect(superseded)
    #expect(later.roster.commitments == [newGym])
    #expect(later.roster.commitments(on: thirtyFirstOfAugust) == [newGym, gym])
}

@Test("a change and a new era a roster refuses keep nothing at a roster store's place")
func aChangeAndANewEraARosterRefusesKeepNothingAtARosterStoresPlace() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let thirtyFirstOfAugust = CalendarDate(year: 2026, month: 8, day: 31)!

    let store = try RosterStore(at: place)
    try store.add(gym)
    try store.add(run)
    let bytesBefore = try Data(contentsOf: place)

    // "run" carries neither gym's identity, so it is refused both as an era changed in place and
    // as a new era put on.
    let changed = try store.change(gym, to: run, under: nil)

    #expect(!changed)
    #expect(try Data(contentsOf: place) == bytesBefore)

    let put = try store.put(era: run, on: gym, keptUntil: thirtyFirstOfAugust, under: nil)

    #expect(!put)
    #expect(try Data(contentsOf: place) == bytesBefore)
}

@Test("a change of a commitment for itself keeps nothing at a roster store's place")
func aChangeOfACommitmentForItselfKeepsNothingAtARosterStoresPlace() throws {
    // Route 1, `design.md` § *Strengthened in place, and the three proven by mutation* (the four
    // no-op tests): the current form, laid out with different
    // key order and spacing than `RosterStore.write`'s own `.sortedKeys` encoding ever produces.
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": false,
              "category": "Sport"
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RosterStore(at: place)
    let rosterBefore = store.roster

    let changed = try store.change(gym, to: gym, under: "Sport")

    #expect(changed)
    #expect(store.roster == rosterBefore)
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a name of ten thousand characters is a commitment and is read back out of a roster store whole")
func aNameOfTenThousandCharactersIsACommitmentAndIsReadBackOutOfARosterStoreWhole() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let longName = String(repeating: "a", count: 10_000)
    let commitment = Commitment(name: longName, schedule: schedule, keptFrom: keptFrom)!

    let store = try RosterStore(at: place)
    let added = try store.add(commitment)

    #expect(added)

    let later = try RosterStore(at: place)

    #expect(later.roster.commitments.map(\.name) == [longName])
    #expect(later.roster.commitments.first?.name.count == 10_000)
}

@Test("a roster store given a thousand commitments holds every one of them, in the order they were given")
func aRosterStoreGivenAThousandCommitmentsHoldsEveryOneOfThemInTheOrderTheyWereGiven() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let names = (1...1_000).map { "Commitment \($0)" }
    let commitments = names.map { Commitment(name: $0, schedule: schedule, keptFrom: keptFrom)! }

    let store = try RosterStore(at: place)
    for commitment in commitments {
        let added = try store.add(commitment)
        #expect(added)
    }

    let later = try RosterStore(at: place)

    #expect(later.roster.commitments.count == 1_000)
    #expect(later.roster.commitments.first?.name == "Commitment 1")
    #expect(later.roster.commitments.last?.name == "Commitment 1000")
    #expect(later.roster.commitments == commitments)
}

/// A place holding "Gym" under "Sport", "Journaling" under "Evening" and "Run" — kept under no
/// category, then stopped as of `stoppedOn` — whose directory has since been replaced by a plain
/// file, so any further write to it fails with `RosterStoreError.cannotWrite`. The five tests
/// below ask a different verb of the `store` returned, already holding this roster in memory,
/// and check only that the refusal is reported and that roster is unmoved by it.
private func storeThatCanWriteNoFurther(
    gym: Commitment, journaling: Commitment, run: Commitment, stoppedOn: CalendarDate
) throws -> (store: RosterStore, place: URL) {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let place = directory.appendingPathComponent("roster.json")

    let store = try RosterStore(at: place)
    try store.add(gym, under: "Sport")
    try store.add(journaling, under: "Evening")
    try store.add(run)
    try store.retire(run, keptUntil: stoppedOn)

    try FileManager.default.removeItem(at: directory)
    try Data().write(to: directory)

    return (store, place)
}

@Test("a stop that cannot be kept is refused and the roster a store reports does not move")
func aStopThatCannotBeKeptIsRefusedAndTheRosterAStoreReportsDoesNotMove() throws {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let stoppedOn = CalendarDate(year: 2026, month: 1, day: 31)!

    let (store, place) = try storeThatCanWriteNoFurther(
        gym: gym, journaling: journaling, run: run, stoppedOn: stoppedOn)

    #expect(throws: RosterStoreError.cannotWrite(at: place)) {
        try store.retire(gym, keptUntil: stoppedOn)
    }

    var expected = Roster()
    _ = expected.add(gym, under: "Sport")
    _ = expected.add(journaling, under: "Evening")
    _ = expected.add(run)
    _ = expected.retire(run, keptUntil: stoppedOn)
    #expect(store.roster == expected)
}

@Test("a group move that cannot be kept is refused and the roster a store reports does not move")
func aGroupMoveThatCannotBeKeptIsRefusedAndTheRosterAStoreReportsDoesNotMove() throws {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let stoppedOn = CalendarDate(year: 2026, month: 1, day: 31)!

    let (store, place) = try storeThatCanWriteNoFurther(
        gym: gym, journaling: journaling, run: run, stoppedOn: stoppedOn)

    #expect(throws: RosterStoreError.cannotWrite(at: place)) {
        try store.move(group: "Sport", toOffset: 2)
    }

    var expected = Roster()
    _ = expected.add(gym, under: "Sport")
    _ = expected.add(journaling, under: "Evening")
    _ = expected.add(run)
    _ = expected.retire(run, keptUntil: stoppedOn)
    #expect(store.roster == expected)
}

@Test(
    "a change of an era that cannot be kept is refused and the roster a store reports does not move"
)
func aChangeOfAnEraThatCannotBeKeptIsRefusedAndTheRosterAStoreReportsDoesNotMove() throws {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let newSchedule = Schedule.weekdays([.tuesday, .thursday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let changedGym = Commitment(era: gym, schedule: newSchedule, keptFrom: keptFrom, kind: .tick)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let stoppedOn = CalendarDate(year: 2026, month: 1, day: 31)!

    let (store, place) = try storeThatCanWriteNoFurther(
        gym: gym, journaling: journaling, run: run, stoppedOn: stoppedOn)

    #expect(throws: RosterStoreError.cannotWrite(at: place)) {
        try store.change(gym, to: changedGym, under: nil)
    }

    var expected = Roster()
    _ = expected.add(gym, under: "Sport")
    _ = expected.add(journaling, under: "Evening")
    _ = expected.add(run)
    _ = expected.retire(run, keptUntil: stoppedOn)
    #expect(store.roster == expected)
}

@Test("a new era that cannot be kept is refused and the roster a store reports does not move")
func aNewEraThatCannotBeKeptIsRefusedAndTheRosterAStoreReportsDoesNotMove() throws {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let stoppedOn = CalendarDate(year: 2026, month: 1, day: 31)!
    let newSchedule = Schedule.weekdays([.tuesday, .thursday])
    let newKeptFrom = CalendarDate(year: 2026, month: 9, day: 1)!
    let newEra = Commitment(era: gym, schedule: newSchedule, keptFrom: newKeptFrom, kind: .tick)!
    let putAsOf = CalendarDate(year: 2026, month: 8, day: 31)!

    let (store, place) = try storeThatCanWriteNoFurther(
        gym: gym, journaling: journaling, run: run, stoppedOn: stoppedOn)

    #expect(throws: RosterStoreError.cannotWrite(at: place)) {
        try store.put(era: newEra, on: gym, keptUntil: putAsOf, under: nil)
    }

    var expected = Roster()
    _ = expected.add(gym, under: "Sport")
    _ = expected.add(journaling, under: "Evening")
    _ = expected.add(run)
    _ = expected.retire(run, keptUntil: stoppedOn)
    #expect(store.roster == expected)
}

@Test("a take-up-again that cannot be kept is refused and the roster a store reports does not move")
func aTakeUpAgainThatCannotBeKeptIsRefusedAndTheRosterAStoreReportsDoesNotMove() throws {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let stoppedOn = CalendarDate(year: 2026, month: 1, day: 31)!

    let (store, place) = try storeThatCanWriteNoFurther(
        gym: gym, journaling: journaling, run: run, stoppedOn: stoppedOn)

    #expect(throws: RosterStoreError.cannotWrite(at: place)) {
        try store.add(run)
    }

    var expected = Roster()
    _ = expected.add(gym, under: "Sport")
    _ = expected.add(journaling, under: "Evening")
    _ = expected.add(run)
    _ = expected.retire(run, keptUntil: stoppedOn)
    #expect(store.roster == expected)
}

/// The three states "Run" is seeded in across the ten store-refusal tests below, alongside a
/// "Gym" always kept under no category. `seededGymAndRunPlace(runState:)` writes both at the form
/// this app reads, laid out with different key order and spacing than `RosterStore.write`'s own
/// `.sortedKeys` encoding ever produces — so a refusal that wrote `nextRoster` back
/// unconditionally, even byte-identical content, would still change the place's bytes, and each
/// test's byte check below would see it. Route 1, `design.md` § *Strengthened in place, and the
/// three proven by mutation*.
private enum SeededRunState {
    case kept
    case stopped
    case removed
}

/// Writes a roster store at the place returned, holding "Gym" — kept, under no category — and
/// "Run" in `runState`, both on a schedule listing Monday, Wednesday and Saturday and kept from 1
/// January 2026. "Run" is stopped or removed as of 31 January 2026 where `runState` calls for it.
private func seededGymAndRunPlace(runState: SeededRunState) throws -> URL {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)

    let runEntry: String
    switch runState {
    case .kept:
        runEntry = """
            {
              "commitment": {
                "name": "Run",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": false,
              "category": null
            }
            """
    case .stopped:
        runEntry = """
            {
              "commitment": {
                "name": "Run",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": false,
              "category": null,
              "keptUntil": { "year": 2026, "month": 1, "day": 31 }
            }
            """
    case .removed:
        runEntry = """
            {
              "commitment": {
                "name": "Run",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": true,
              "category": null,
              "keptUntil": { "year": 2026, "month": 1, "day": 31 }
            }
            """
    }

    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": false,
              "category": null
            },
            \(runEntry)
          ]
        }
        """.utf8)
    try bytes.write(to: place)
    return place
}

@Test("a stop a roster store refuses for a removed commitment is reported and nothing at its place changes")
func aStopARosterStoreRefusesForARemovedCommitmentIsReportedAndNothingAtItsPlaceChanges() throws {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    let place = try seededGymAndRunPlace(runState: .removed)
    let store = try RosterStore(at: place)
    let bytesBeforeAsk = try Data(contentsOf: place)

    let stopped = try store.retire(run, keptUntil: CalendarDate(year: 2026, month: 2, day: 28)!)

    #expect(!stopped)
    #expect(store.roster.commitments == [gym])
    #expect(try Data(contentsOf: place) == bytesBeforeAsk)
}

@Test("a move a roster store refuses for a stopped commitment is reported and nothing at its place changes")
func aMoveARosterStoreRefusesForAStoppedCommitmentIsReportedAndNothingAtItsPlaceChanges() throws {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    let place = try seededGymAndRunPlace(runState: .stopped)
    let store = try RosterStore(at: place)
    let bytesBeforeAsk = try Data(contentsOf: place)

    let moved = try store.move(run, toOffset: 0, under: nil)

    #expect(!moved)
    #expect(store.roster.commitments == [gym])
    #expect(try Data(contentsOf: place) == bytesBeforeAsk)
}

@Test("a move a roster store refuses for a removed commitment is reported and nothing at its place changes")
func aMoveARosterStoreRefusesForARemovedCommitmentIsReportedAndNothingAtItsPlaceChanges() throws {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    let place = try seededGymAndRunPlace(runState: .removed)
    let store = try RosterStore(at: place)
    let bytesBeforeAsk = try Data(contentsOf: place)

    let moved = try store.move(run, toOffset: 0, under: nil)

    #expect(!moved)
    #expect(store.roster.commitments == [gym])
    #expect(try Data(contentsOf: place) == bytesBeforeAsk)
}

@Test(
    "a move a roster store refuses for an offset it does not have is reported and nothing at its place changes"
)
func aMoveARosterStoreRefusesForAnOffsetItDoesNotHaveIsReportedAndNothingAtItsPlaceChanges() throws {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    let place = try seededGymAndRunPlace(runState: .kept)
    let store = try RosterStore(at: place)
    let bytesBeforeAsk = try Data(contentsOf: place)

    let movedToThree = try store.move(gym, toOffset: 3, under: nil)
    let movedToNegativeOne = try store.move(gym, toOffset: -1, under: nil)

    #expect(!movedToThree)
    #expect(!movedToNegativeOne)
    #expect(store.roster.commitments == [gym, run])
    #expect(try Data(contentsOf: place) == bytesBeforeAsk)
}

@Test(
    "a category change a roster store refuses for a commitment it does not hold is reported and nothing at its place changes"
)
func aCategoryChangeARosterStoreRefusesForACommitmentItDoesNotHoldIsReportedAndNothingAtItsPlaceChanges()
    throws
{
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    let place = try seededGymAndRunPlace(runState: .kept)
    let store = try RosterStore(at: place)
    let bytesBeforeAsk = try Data(contentsOf: place)

    let put = try store.put(journaling, under: "Sport")

    #expect(!put)
    #expect(store.roster.commitments == [gym, run])
    #expect(try Data(contentsOf: place) == bytesBeforeAsk)
}

@Test(
    "a category change a roster store refuses for a removed commitment is reported and nothing at its place changes"
)
func aCategoryChangeARosterStoreRefusesForARemovedCommitmentIsReportedAndNothingAtItsPlaceChanges()
    throws
{
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    let place = try seededGymAndRunPlace(runState: .removed)
    let store = try RosterStore(at: place)
    let bytesBeforeAsk = try Data(contentsOf: place)

    let put = try store.put(run, under: "Sport")

    #expect(!put)
    #expect(store.roster.commitments == [gym])
    #expect(try Data(contentsOf: place) == bytesBeforeAsk)
}

@Test("a change a roster store refuses for a commitment it does not hold is reported and nothing at its place changes")
func aChangeARosterStoreRefusesForACommitmentItDoesNotHoldIsReportedAndNothingAtItsPlaceChanges()
    throws
{
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom)!

    let place = try seededGymAndRunPlace(runState: .kept)
    let store = try RosterStore(at: place)
    let bytesBeforeAsk = try Data(contentsOf: place)

    let changed = try store.change(journaling, to: journal, under: nil)

    #expect(!changed)
    #expect(store.roster.commitments == [gym, run])
    #expect(try Data(contentsOf: place) == bytesBeforeAsk)
}

@Test(
    "a new era a roster store refuses to put on a stopped commitment is reported and nothing at its place changes"
)
func aNewEraARosterStoreRefusesToPutOnAStoppedCommitmentIsReportedAndNothingAtItsPlaceChanges()
    throws
{
    let newSchedule = Schedule.weekdays([.tuesday, .thursday])

    let place = try seededGymAndRunPlace(runState: .stopped)
    let store = try RosterStore(at: place)
    let bytesBeforeAsk = try Data(contentsOf: place)
    let run = store.roster.stopped.first!
    let newEra = Commitment(
        era: run, schedule: newSchedule, keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!,
        kind: .tick)!

    let put = try store.put(
        era: newEra, on: run, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!, under: nil)

    #expect(!put)
    #expect(store.roster.commitments.map(\.name) == ["Gym"])
    #expect(try Data(contentsOf: place) == bytesBeforeAsk)
}

@Test(
    "a supersession a roster store refuses for a removed commitment is reported and nothing at its place changes"
)
func aSupersessionARosterStoreRefusesForARemovedCommitmentIsReportedAndNothingAtItsPlaceChanges()
    throws
{
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!
    let running = Commitment(name: "Running", schedule: schedule, keptFrom: keptFrom)!

    let place = try seededGymAndRunPlace(runState: .removed)
    let store = try RosterStore(at: place)
    let bytesBeforeAsk = try Data(contentsOf: place)

    let superseded = try store.supersede(
        run, with: running, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!, under: nil)

    #expect(!superseded)
    #expect(store.roster.commitments == [gym])
    #expect(try Data(contentsOf: place) == bytesBeforeAsk)
}

@Test(
    "a supersession a roster store refuses for a commitment it already holds is reported and nothing at its place changes"
)
func aSupersessionARosterStoreRefusesForACommitmentItAlreadyHoldsIsReportedAndNothingAtItsPlaceChanges()
    throws
{
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    let place = try seededGymAndRunPlace(runState: .removed)
    let store = try RosterStore(at: place)
    let bytesBeforeAsk = try Data(contentsOf: place)

    let superseded = try store.supersede(
        gym, with: run, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!, under: nil)

    #expect(!superseded)
    #expect(store.roster.commitments == [gym])
    #expect(try Data(contentsOf: place) == bytesBeforeAsk)
}

@Test("categories differing only in case are read back out of a roster store as two categories")
func categoriesDifferingOnlyInCaseAreReadBackOutOfARosterStoreAsTwoCategories() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: schedule, keptFrom: keptFrom)!
    let magnesium = Commitment(name: "Magnesium", schedule: schedule, keptFrom: keptFrom)!

    let store = try RosterStore(at: place)
    try store.add(creatine)
    try store.add(magnesium)
    _ = try store.put(creatine, under: "Supplements")
    _ = try store.put(magnesium, under: "supplements")

    let later = try RosterStore(at: place)

    #expect(
        later.roster.groups
            == [
                Roster.Group(category: "Supplements", commitments: [creatine]),
                Roster.Group(category: "supplements", commitments: [magnesium]),
            ])
}

@Test("a roster store and a record store kept beside it change nothing at each other's place")
func aRosterStoreAndARecordStoreKeptBesideItChangeNothingAtEachOthersPlace() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let rosterPlace = directory.appendingPathComponent("roster.json")
    let recordPlace = directory.appendingPathComponent("record.json")
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let january5th = CalendarDate(year: 2026, month: 1, day: 5)!
    let january7th = CalendarDate(year: 2026, month: 1, day: 7)!
    let januaryThirtyFirst = CalendarDate(year: 2026, month: 1, day: 31)!

    let recordStore = try RecordStore(at: recordPlace)
    try recordStore.add(Tick(gym, on: january5th)!)

    let recordBytesBeforeRosterWrites = try Data(contentsOf: recordPlace)

    let rosterStore = try RosterStore(at: rosterPlace)
    try rosterStore.add(gym)
    try rosterStore.retire(gym, keptUntil: januaryThirtyFirst)

    #expect(try Data(contentsOf: recordPlace) == recordBytesBeforeRosterWrites)

    let rosterBytesAfterStop = try Data(contentsOf: rosterPlace)

    try recordStore.add(Tick(gym, on: january7th)!)

    #expect(try Data(contentsOf: rosterPlace) == rosterBytesAfterStop)
}

@Test("a change kept over a roster in an earlier form keeps every day a commitment was kept until")
func aChangeKeptOverARosterInAnEarlierFormKeepsEveryDayACommitmentWasKeptUntil() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 1,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "keptUntil": { "year": 2026, "month": 1, "day": 31 }
            },
            {
              "commitment": {
                "name": "Journaling",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              }
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RosterStore(at: place)
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    try store.add(run)

    let later = try RosterStore(at: place)
    let januaryThirtyFirst = CalendarDate(year: 2026, month: 1, day: 31)!
    let februaryFirst = CalendarDate(year: 2026, month: 2, day: 1)!

    #expect(later.roster.commitments(on: januaryThirtyFirst) == [gym, journaling, run])
    #expect(later.roster.commitments(on: februaryFirst) == [journaling, run])
}

@Test("a roster store declaring a later form whose body this app cannot read is refused as a later form")
func aRosterStoreDeclaringALaterFormWhoseBodyThisAppCannotReadIsRefusedAsALaterForm() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(#"{"version": 6, "commitments": "not an array"}"#.utf8)
    try bytes.write(to: place)

    #expect(throws: RosterStoreError.laterForm(at: place, version: 6)) {
        try RosterStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a roster store holding a commitment again after holding it stopped or removed is refused")
func aRosterStoreHoldingACommitmentAgainAfterHoldingItStoppedOrRemovedIsRefused() throws {
    let stoppedPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: stoppedPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let stoppedBytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "keptUntil": { "year": 2026, "month": 1, "day": 31 },
              "removed": false,
              "category": null
            },
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": false,
              "category": null
            }
          ]
        }
        """.utf8)
    try stoppedBytes.write(to: stoppedPlace)

    let removedPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: removedPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let removedBytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "keptUntil": { "year": 2026, "month": 1, "day": 31 },
              "removed": true,
              "category": null
            },
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": false,
              "category": null
            }
          ]
        }
        """.utf8)
    try removedBytes.write(to: removedPlace)

    #expect(throws: RosterStoreError.notAStore(at: stoppedPlace)) {
        try RosterStore(at: stoppedPlace)
    }
    #expect(throws: RosterStoreError.notAStore(at: removedPlace)) {
        try RosterStore(at: removedPlace)
    }
    #expect(try Data(contentsOf: stoppedPlace) == stoppedBytes)
    #expect(try Data(contentsOf: removedPlace) == removedBytes)
}

@Test("a roster store holding a day kept until that names no day is refused")
func aRosterStoreHoldingADayKeptUntilThatNamesNoDayIsRefused() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "keptUntil": { "year": 2026, "month": 2, "day": 30 },
              "removed": false,
              "category": null
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    #expect(throws: RosterStoreError.notAStore(at: place)) {
        try RosterStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a roster store holding a commitment whose range has its lowest above its highest is refused")
func aRosterStoreHoldingACommitmentWhoseRangeHasItsLowestAboveItsHighestIsRefused() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "number": { "lowest": 10, "highest": 1 } }
              },
              "removed": false,
              "category": null
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    #expect(throws: RosterStoreError.notAStore(at: place)) {
        try RosterStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a roster store holding a commitment whose target is not above zero is refused")
func aRosterStoreHoldingACommitmentWhoseTargetIsNotAboveZeroIsRefused() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "total": { "target": 0 } }
              },
              "removed": false,
              "category": null
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    #expect(throws: RosterStoreError.notAStore(at: place)) {
        try RosterStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a roster store holding a commitment on a day of the month outside the thirty-one is refused")
func aRosterStoreHoldingACommitmentOnADayOfTheMonthOutsideTheThirtyOneIsRefused() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "dayOfMonth": 32 }
              },
              "removed": false,
              "category": null
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    #expect(throws: RosterStoreError.notAStore(at: place)) {
        try RosterStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a roster store holding an every-N-days schedule whose start date names no day is refused")
func aRosterStoreHoldingAnEveryNDaysScheduleWhoseStartDateNamesNoDayIsRefused() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "everyNDays": 3, "from": { "year": 2026, "month": 2, "day": 30 } }
              },
              "removed": false,
              "category": null
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    #expect(throws: RosterStoreError.notAStore(at: place)) {
        try RosterStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a category of a thousand characters is held and read back out of a roster store whole")
func aCategoryOfAThousandCharactersIsHeldAndReadBackOutOfARosterStoreWhole() throws {
    let place = freshPlace()
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let longCategory = String(repeating: "S", count: 1_000)

    let store = try RosterStore(at: place)
    try store.add(creatine)
    let put = try store.put(creatine, under: longCategory)

    #expect(put)

    let later = try RosterStore(at: place)

    #expect(later.roster.groups == [Roster.Group(category: longCategory, commitments: [creatine])])
}

@Test("a category written in a script other than Latin is held and read back out of a roster store exactly")
func aCategoryWrittenInAScriptOtherThanLatinIsHeldAndReadBackOutOfARosterStoreExactly() throws {
    let place = freshPlace()
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let creatine = Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: daily, keptFrom: keptFrom)!
    let japaneseCategory = "サプリ"
    let cyrillicCategory = "Спорт"

    let store = try RosterStore(at: place)
    try store.add(creatine)
    try store.add(gym)
    _ = try store.put(creatine, under: japaneseCategory)
    _ = try store.put(gym, under: cyrillicCategory)

    let later = try RosterStore(at: place)

    #expect(
        later.roster.groups
            == [
                Roster.Group(category: japaneseCategory, commitments: [creatine]),
                Roster.Group(category: cyrillicCategory, commitments: [gym]),
            ])
}

@Test(
    "taking a stopped commitment up again is refused where a commitment the roster keeps already has its name"
)
func takingAStoppedCommitmentUpAgainIsRefusedWhereACommitmentTheRosterKeepsAlreadyHasItsName()
    throws
{
    // Two "Gym"s, one kept and one stopped, can only ever sit side by side in a roster read from
    // the form used before a commitment had an identity: `Roster.add` itself already refuses a
    // second "Gym" the moment a first is kept, so the fold is the one way in.
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": false,
              "category": null
            },
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["tuesday", "thursday"] }
              },
              "keptUntil": { "year": 2026, "month": 1, "day": 31 },
              "removed": false,
              "category": null
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RosterStore(at: place)
    var roster = store.roster
    let stoppedGym = roster.stopped.first!

    let takenUp = roster.add(stoppedGym)

    #expect(!takenUp)
    #expect(roster.commitments.map(\.rhythmInWords) == ["Mon, Wed, Sat"])
    #expect(roster.commitments.allSatisfy { $0.name == "Gym" })
    #expect(roster.stopped.map(\.rhythmInWords) == ["Tue, Thu"])
    #expect(roster.stopped.allSatisfy { $0.name == "Gym" })
}

@Test(
    "a commitment with two eras kept through a roster store is read back as one commitment with two eras"
)
func aCommitmentWithTwoErasKeptThroughARosterStoreIsReadBackAsOneCommitmentWithTwoEras() throws {
    let place = freshPlace()
    let originalSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let newSchedule = Schedule.weekdays([.tuesday, .thursday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: originalSchedule, keptFrom: keptFrom)!
    let newEra = Commitment(
        era: gym, schedule: newSchedule, keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!,
        kind: .tick)!

    let store = try RosterStore(at: place)
    try store.add(gym)
    try store.put(
        era: newEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!, under: nil)

    let later = try RosterStore(at: place)

    #expect(later.roster.commitments == [newEra])
    #expect(later.roster.eras(of: newEra) == [newEra, gym])
}

@Test("a roster store read back holds the same commitments rather than commitments alike to them")
func aRosterStoreReadBackHoldsTheSameCommitmentsRatherThanCommitmentsAlikeToThem() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    let store = try RosterStore(at: place)
    try store.add(gym)

    let first = try RosterStore(at: place)
    let second = try RosterStore(at: place)

    #expect(first.roster.commitments.first == gym)
    #expect(first.roster.commitments == second.roster.commitments)
    #expect(first.roster.commitments.first?.identity == gym.identity)
}

@Test(
    "an era a roster store refuses to put on a removed commitment is reported and nothing at its place changes"
)
func anEraARosterStoreRefusesToPutOnARemovedCommitmentIsReportedAndNothingAtItsPlaceChanges()
    throws
{
    let place = freshPlace()
    let originalSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let newSchedule = Schedule.weekdays([.tuesday, .thursday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: originalSchedule, keptFrom: keptFrom)!
    let newEra = Commitment(
        era: gym, schedule: newSchedule, keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!,
        kind: .tick)!

    let store = try RosterStore(at: place)
    try store.add(gym)
    try store.remove(gym, keptUntil: CalendarDate(year: 2026, month: 1, day: 31)!)
    let bytesBefore = try Data(contentsOf: place)

    let put = try store.put(
        era: newEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!, under: nil)

    #expect(!put)
    #expect(try Data(contentsOf: place) == bytesBefore)
}

@Test(
    "a roster store declaring a form written before identities and saying something about one is refused"
)
func aRosterStoreDeclaringAFormWrittenBeforeIdentitiesAndSayingSomethingAboutOneIsRefused() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "identity": "11111111-1111-1111-1111-111111111111"
              },
              "removed": false,
              "category": null
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    #expect(throws: RosterStoreError.notAStore(at: place)) {
        try RosterStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test(
    "a roster store declaring the form this app writes and saying nothing about an identity is refused"
)
func aRosterStoreDeclaringTheFormThisAppWritesAndSayingNothingAboutAnIdentityIsRefused() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 5,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": false,
              "category": null
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    #expect(throws: RosterStoreError.notAStore(at: place)) {
        try RosterStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test(
    "an era a roster store refuses to put on because it is not that commitment's is reported and nothing at its place changes"
)
func anEraARosterStoreRefusesToPutOnBecauseItIsNotThatCommitmentsIsReportedAndNothingAtItsPlaceChanges()
    throws
{
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let newSchedule = Schedule.weekdays([.tuesday, .thursday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let notGymsEra = Commitment(
        name: "Gym", schedule: newSchedule, keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!)!

    let store = try RosterStore(at: place)
    try store.add(gym)
    let bytesBefore = try Data(contentsOf: place)

    let put = try store.put(
        era: notGymsEra, on: gym, keptUntil: CalendarDate(year: 2026, month: 8, day: 31)!,
        under: nil)

    #expect(!put)
    #expect(try Data(contentsOf: place) == bytesBefore)
}

@Test("a chain of removed entries folds into the eras of the commitment in front of it")
func aChainOfRemovedEntriesFoldsIntoTheErasOfTheCommitmentInFrontOfIt() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 3, "day": 1 },
                "schedule": { "weekdays": ["tuesday", "thursday"] }
              },
              "removed": false,
              "category": null
            },
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 2, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "keptUntil": { "year": 2026, "month": 2, "day": 28 },
              "removed": true,
              "category": null
            },
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "timesPerWeek": 3 }
              },
              "keptUntil": { "year": 2026, "month": 1, "day": 31 },
              "removed": true,
              "category": null
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RosterStore(at: place)

    #expect(store.roster.commitments.map(\.rhythmInWords) == ["Tue, Thu"])
    #expect(store.roster.commitments.allSatisfy { $0.name == "Gym" })
    #expect(store.roster.stopped.isEmpty)
    let gym = store.roster.commitments.first!
    #expect(store.roster.eras(of: gym).map(\.rhythmInWords) == ["Tue, Thu", "Mon, Wed, Sat", "3x a week"])
    #expect(store.roster.keptFrom(of: gym) == CalendarDate(year: 2026, month: 1, day: 1)!)
}

@Test("a removed entry nothing kept or stopped resembles is dropped by the fold")
func aRemovedEntryNothingKeptOrStoppedResemblesIsDroppedByTheFold() throws {
    // Driven from a document decoded in memory, never written to a file.
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": false,
              "category": null
            },
            {
              "commitment": {
                "name": "Yoga",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "keptUntil": { "year": 2026, "month": 1, "day": 31 },
              "removed": true,
              "category": null
            }
          ]
        }
        """.utf8)
    let document = try JSONDecoder().decode(RosterDocument.self, from: bytes)

    let fold = document.folded()

    #expect(fold != nil)
    #expect(fold?.roster.commitments.map(\.name) == ["Gym"])
    #expect(fold?.roster.stopped.isEmpty == true)
    #expect(fold?.roster.commitments(on: CalendarDate(year: 2026, month: 1, day: 31)!).map(\.name) == ["Gym"])

    let yoga = document.commitments[1].commitment
    #expect(fold?.identities[yoga] == Optional<Commitment.Identity?>.some(nil))
}

@Test("a removed entry that resembles a live commitment but chains to nothing becomes a stopped commitment")
func aRemovedEntryThatResemblesALiveCommitmentButChainsToNothingBecomesAStoppedCommitment() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 3, "day": 1 },
                "schedule": { "weekdays": ["tuesday", "thursday"] }
              },
              "removed": false,
              "category": null
            },
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "keptUntil": { "year": 2026, "month": 2, "day": 20 },
              "removed": true,
              "category": null
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RosterStore(at: place)

    #expect(store.roster.commitments.map(\.rhythmInWords) == ["Tue, Thu"])
    #expect(store.roster.stopped.map(\.rhythmInWords) == ["Mon, Wed, Sat"])
    #expect(store.roster.commitments.allSatisfy { $0.name == "Gym" })
    #expect(store.roster.stopped.allSatisfy { $0.name == "Gym" })
    #expect(store.roster.commitments.first?.identity != store.roster.stopped.first?.identity)
    #expect(store.roster.commitments.first.map { store.roster.eras(of: $0).count } == 1)
    #expect(store.roster.stopped.first.map { store.roster.eras(of: $0).count } == 1)
    #expect(store.roster.keptFrom(of: store.roster.commitments.first!) == CalendarDate(year: 2026, month: 3, day: 1)!)
}

@Test("the fold takes the nearest of two removed entries that both chain")
func theFoldTakesTheNearestOfTwoRemovedEntriesThatBothChain() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 3, "day": 4 },
                "schedule": { "weekdays": ["tuesday", "thursday"] }
              },
              "removed": false,
              "category": null
            },
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 2, "day": 1 },
                "schedule": { "weekdays": ["monday"] }
              },
              "keptUntil": { "year": 2026, "month": 3, "day": 3 },
              "removed": true,
              "category": null
            },
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["wednesday"] }
              },
              "keptUntil": { "year": 2026, "month": 3, "day": 3 },
              "removed": true,
              "category": null
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RosterStore(at: place)

    let gym = store.roster.commitments.first!
    #expect(store.roster.eras(of: gym).map(\.rhythmInWords) == ["Tue, Thu", "Mon"])
    #expect(store.roster.keptFrom(of: gym) == CalendarDate(year: 2026, month: 2, day: 1)!)
    #expect(store.roster.stopped.map(\.rhythmInWords) == ["Wed"])
}

@Test("a removed entry of another kind sort does not fold as an era")
func aRemovedEntryOfAnotherKindSortDoesNotFoldAsAnEra() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Mood",
                "keptFrom": { "year": 2026, "month": 3, "day": 1 },
                "schedule": {
                  "weekdays": [
                    "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"
                  ]
                },
                "kind": { "number": { "lowest": 1, "highest": 5 } }
              },
              "removed": false,
              "category": null
            },
            {
              "commitment": {
                "name": "Mood",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": {
                  "weekdays": [
                    "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"
                  ]
                },
                "kind": { "note": {} }
              },
              "keptUntil": { "year": 2026, "month": 2, "day": 28 },
              "removed": true,
              "category": null
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RosterStore(at: place)

    #expect(store.roster.commitments.count == 1)
    #expect(store.roster.commitments.first?.kind == .number(range: Commitment.Range(lowest: 1, highest: 5)))
    #expect(store.roster.eras(of: store.roster.commitments.first!).count == 1)
    #expect(store.roster.stopped.isEmpty)
}

@Test("an era whose range differs folds behind the commitment in front of it")
func anEraWhoseRangeDiffersFoldsBehindTheCommitmentInFrontOfIt() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Mood",
                "keptFrom": { "year": 2026, "month": 3, "day": 1 },
                "schedule": {
                  "weekdays": [
                    "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"
                  ]
                },
                "kind": { "number": { "lowest": 1, "highest": 5 } }
              },
              "removed": false,
              "category": null
            },
            {
              "commitment": {
                "name": "Mood",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": {
                  "weekdays": [
                    "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"
                  ]
                },
                "kind": { "number": { "lowest": 1, "highest": 10 } }
              },
              "keptUntil": { "year": 2026, "month": 2, "day": 28 },
              "removed": true,
              "category": null
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RosterStore(at: place)

    let mood = store.roster.commitments.first!
    #expect(store.roster.eras(of: mood).map(\.kind) == [
        .number(range: Commitment.Range(lowest: 1, highest: 5)),
        .number(range: Commitment.Range(lowest: 1, highest: 10)),
    ])
    #expect(store.roster.keptFrom(of: mood) == CalendarDate(year: 2026, month: 1, day: 1)!)
}

@Test("the fold leaves two commitments holding one name where the stored roster held two")
func theFoldLeavesTwoCommitmentsHoldingOneNameWhereTheStoredRosterHeldTwo() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday"] }
              },
              "removed": false,
              "category": null
            },
            {
              "commitment": {
                "name": "Gym ",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["tuesday"] }
              },
              "removed": false,
              "category": null
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RosterStore(at: place)

    #expect(store.roster.commitments.map(\.name) == ["Gym", "Gym "])
    #expect(store.roster.commitments[0].identity != store.roster.commitments[1].identity)
}

@Test("folding a roster changes nothing at its place, and the next change is written in the form this app writes")
func foldingARosterChangesNothingAtItsPlaceAndTheNextChangeIsWrittenInTheFormThisAppWrites() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "removed": false,
              "category": null
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RosterStore(at: place)

    #expect(try Data(contentsOf: place) == bytes)

    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)!
    try store.add(run)

    let later = try RosterStore(at: place)
    let laterDocument = try JSONDecoder().decode(RosterDocument.self, from: Data(contentsOf: place))

    #expect(later.roster.commitments.map(\.name) == ["Gym", "Run"])
    #expect(later.roster.stopped.isEmpty)
    #expect(laterDocument.version == RosterDocument.currentVersion)
}
