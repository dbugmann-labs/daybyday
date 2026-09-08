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
    let bytes = Data(#"{"version": 5, "commitments": []}"#.utf8)
    try bytes.write(to: place)

    #expect(throws: RosterStoreError.laterForm(at: place, version: 5)) {
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
          "version": 3,
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
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let waterPlants = Commitment(name: "Water plants", schedule: schedule, keptFrom: keptFrom)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!

    let store = try RosterStore(at: place)
    try store.add(waterPlants)
    try store.add(gym)
    let bytesBeforeMove = try Data(contentsOf: place)

    let moved = try store.move(gym, toOffset: 2, under: nil)

    #expect(moved)
    #expect(try Data(contentsOf: place) == bytesBeforeMove)
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
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let journaling = Commitment(name: "Journaling", schedule: schedule, keptFrom: keptFrom)!

    let store = try RosterStore(at: place)
    try store.add(gym)
    try store.add(journaling)
    try store.put(gym, under: "Sport")

    let bytesBeforeSecondAsk = try Data(contentsOf: place)

    let put = try store.put(gym, under: "Sport")

    #expect(put)
    #expect(try Data(contentsOf: place) == bytesBeforeSecondAsk)
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
