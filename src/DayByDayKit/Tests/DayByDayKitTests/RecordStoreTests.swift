import Foundation
import Testing
import DayByDayKit

/// A fresh place under the temporary directory, one per test, so tests are independent and need
/// no teardown: a UUID names the directory, and the store's file sits one level under it, so the
/// directory itself does not exist until the store creates it.
private func freshPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("store.json")
}

@Test("a store opened where nothing has been kept holds an empty history")
func aStoreOpenedWhereNothingHasBeenKeptHoldsAnEmptyHistory() throws {
    let place = freshPlace()

    let store = try RecordStore(at: place)

    #expect(store.history == History())
}

@Test("a tick added to a store is held by a second store opened at the same place while the first is still open")
func aTickAddedToAStoreIsHeldByASecondStoreOpenedAtTheSamePlaceWhileTheFirstIsStillOpen() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tick = Tick(commitment, on: monday)!

    let first = try RecordStore(at: place)
    try first.add(tick)
    let second = try RecordStore(at: place)

    #expect(second.history.isKept(commitment, on: monday))
}

@Test("a tick taken back is not held by a store opened afterwards at the same place")
func aTickTakenBackIsNotHeldByAStoreOpenedAfterwardsAtTheSamePlace() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tick = Tick(commitment, on: monday)!

    let first = try RecordStore(at: place)
    try first.add(tick)
    try first.remove(tick)
    let later = try RecordStore(at: place)

    #expect(!later.history.isKept(commitment, on: monday))
    #expect(later.history == History())
}

@Test("a store opened again holds exactly the ticks added and not taken back")
func aStoreOpenedAgainHoldsExactlyTheTicksAddedAndNotTakenBack() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)!

    let gymOn31Aug = Tick(gym, on: CalendarDate(year: 2026, month: 8, day: 31)!)!
    let gymOn2Sep = Tick(gym, on: CalendarDate(year: 2026, month: 9, day: 2)!)!
    let gymOn5Sep = Tick(gym, on: CalendarDate(year: 2026, month: 9, day: 5)!)!
    let runOn31Aug = Tick(run, on: CalendarDate(year: 2026, month: 8, day: 31)!)!

    let store = try RecordStore(at: place)
    try store.add(gymOn31Aug)
    try store.add(gymOn2Sep)
    try store.add(gymOn5Sep)
    try store.add(runOn31Aug)
    try store.remove(gymOn2Sep)

    let later = try RecordStore(at: place)

    var expected = History()
    expected.add(gymOn31Aug)
    expected.add(gymOn5Sep)
    expected.add(runOn31Aug)
    #expect(later.history == expected)
}

@Test("adding a tick the store already holds leaves what is kept unchanged")
func addingATickTheStoreAlreadyHoldsLeavesWhatIsKeptUnchanged() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let tick = Tick(commitment, on: CalendarDate(year: 2026, month: 8, day: 31)!)!

    let store = try RecordStore(at: place)
    try store.add(tick)
    try store.add(tick)

    let later = try RecordStore(at: place)

    var expected = History()
    expected.add(tick)
    #expect(later.history == expected)
}

@Test("a tick in the first supported year and one in the last are read back unchanged")
func aTickInTheFirstSupportedYearAndOneInTheLastAreReadBackUnchanged() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 1583, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let firstDate = CalendarDate(year: 1583, month: 1, day: 3)!
    let lastDate = CalendarDate(year: 9999, month: 12, day: 27)!
    let firstTick = Tick(commitment, on: firstDate)!
    let lastTick = Tick(commitment, on: lastDate)!

    let store = try RecordStore(at: place)
    try store.add(firstTick)
    try store.add(lastTick)

    let later = try RecordStore(at: place)

    #expect(later.history.isKept(commitment, on: firstDate))
    #expect(later.history.isKept(commitment, on: lastDate))
    var expected = History()
    expected.add(firstTick)
    expected.add(lastTick)
    #expect(later.history == expected)
}

@Test("ticks of commitments on every schedule shape are read back as the same ticks")
func ticksOfCommitmentsOnEveryScheduleShapeAreReadBackAsTheSameTicks() throws {
    let place = freshPlace()
    let januaryFirst2026 = CalendarDate(year: 2026, month: 1, day: 1)!

    let gym = Commitment(
        name: "Gym",
        schedule: .weekdays([.monday, .wednesday, .saturday]),
        keptFrom: januaryFirst2026)!
    let gymTick = Tick(gym, on: CalendarDate(year: 2026, month: 8, day: 31)!)!

    let finances = Commitment(
        name: "Finances",
        schedule: .dayOfMonth(DayOfMonth(day: 25)!),
        keptFrom: januaryFirst2026)!
    let financesTick = Tick(finances, on: CalendarDate(year: 2026, month: 9, day: 25)!)!

    let plants = Commitment(
        name: "Plants",
        schedule: .everyNDays(
            DayInterval(days: 3)!, from: CalendarDate(year: 2026, month: 8, day: 25)!),
        keptFrom: CalendarDate(year: 2026, month: 9, day: 1)!)!
    let plantsTick = Tick(plants, on: CalendarDate(year: 2026, month: 9, day: 3)!)!

    let reading = Commitment(
        name: "Reading",
        schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!),
        keptFrom: januaryFirst2026)!
    let readingTick = Tick(reading, on: CalendarDate(year: 2026, month: 9, day: 7)!)!

    let store = try RecordStore(at: place)
    try store.add(gymTick)
    try store.add(financesTick)
    try store.add(plantsTick)
    try store.add(readingTick)

    let later = try RecordStore(at: place)

    var expected = History()
    expected.add(gymTick)
    expected.add(financesTick)
    expected.add(plantsTick)
    expected.add(readingTick)
    #expect(later.history == expected)

    #expect(later.history.isKept(gym, on: CalendarDate(year: 2026, month: 8, day: 31)!))
    #expect(later.history.isKept(finances, on: CalendarDate(year: 2026, month: 9, day: 25)!))
    #expect(later.history.isKept(plants, on: CalendarDate(year: 2026, month: 9, day: 3)!))
    #expect(later.history.isKept(reading, on: CalendarDate(year: 2026, month: 9, day: 7)!))
}

@Test("a commitment name is read back exactly, whatever it contains")
func aCommitmentNameIsReadBackExactlyWhateverItContains() throws {
    let place = freshPlace()
    let name = "Zürich — „langer“ Lauf 🏃\nSonntags"
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: name, schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tick = Tick(commitment, on: monday)!

    let store = try RecordStore(at: place)
    try store.add(tick)

    let later = try RecordStore(at: place)

    #expect(later.history.isKept(commitment, on: monday))
    var expected = History()
    expected.add(tick)
    #expect(later.history == expected)
}

@Test("stores at different places hold different histories")
func storesAtDifferentPlacesHoldDifferentHistories() throws {
    let firstPlace = freshPlace()
    let secondPlace = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tick = Tick(commitment, on: monday)!

    let first = try RecordStore(at: firstPlace)
    try first.add(tick)
    let second = try RecordStore(at: secondPlace)

    #expect(second.history == History())

    let laterFirst = try RecordStore(at: firstPlace)
    #expect(laterFirst.history.isKept(commitment, on: monday))
}

@Test("a tick that cannot be kept is refused and not held")
func aTickThatCannotBeKeptIsRefusedAndNotHeld() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    let place = blocker.appendingPathComponent("store.json")

    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let tick = Tick(commitment, on: monday)!

    let store = try RecordStore(at: place)

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try store.add(tick)
    }
    #expect(store.history == History())

    let later = try RecordStore(at: place)
    #expect(later.history == History())
}

@Test("a number that cannot be kept is refused and not held")
func aNumberThatCannotBeKeptIsRefusedAndNotHeld() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    let place = blocker.appendingPathComponent("store.json")

    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let number = Number(70.5, for: commitment, on: monday)!

    let store = try RecordStore(at: place)

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try store.add(number)
    }
    #expect(store.history == History())

    let later = try RecordStore(at: place)
    #expect(later.history == History())
}

@Test("content that is not a store is refused and left as it was")
func contentThatIsNotAStoreIsRefusedAndLeftAsItWas() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data("not a store".utf8)
    try bytes.write(to: place)

    #expect(throws: RecordStoreError.notAStore(at: place)) {
        try RecordStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a store written in a later form than this app knows is refused")
func aStoreWrittenInALaterFormThanThisAppKnowsIsRefused() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(#"{"version": 6, "ticks": []}"#.utf8)
    try bytes.write(to: place)

    #expect(throws: RecordStoreError.laterForm(at: place, version: 6)) {
        try RecordStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a store written in a form this app has never written is refused")
func aStoreWrittenInAFormThisAppHasNeverWrittenIsRefused() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(#"{"version": 0, "ticks": []}"#.utf8)
    try bytes.write(to: place)

    #expect(throws: RecordStoreError.notAStore(at: place)) {
        try RecordStore(at: place)
    }
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a store holding what could not be a tick is refused")
func aStoreHoldingWhatCouldNotBeATickIsRefused() throws {
    let notDuePlace = freshPlace()
    try FileManager.default.createDirectory(
        at: notDuePlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let notDueBytes = Data(
        """
        {
          "version": 1,
          "ticks": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "date": { "year": 2026, "month": 9, "day": 1 }
            }
          ]
        }
        """.utf8)
    try notDueBytes.write(to: notDuePlace)

    let noSuchDayPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: noSuchDayPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let noSuchDayBytes = Data(
        """
        {
          "version": 1,
          "ticks": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "date": { "year": 2026, "month": 2, "day": 30 }
            }
          ]
        }
        """.utf8)
    try noSuchDayBytes.write(to: noSuchDayPlace)

    #expect(throws: RecordStoreError.notAStore(at: notDuePlace)) {
        try RecordStore(at: notDuePlace)
    }
    #expect(throws: RecordStoreError.notAStore(at: noSuchDayPlace)) {
        try RecordStore(at: noSuchDayPlace)
    }
    #expect(try Data(contentsOf: notDuePlace) == notDueBytes)
    #expect(try Data(contentsOf: noSuchDayPlace) == noSuchDayBytes)
}

@Test("a number added to a store is held by a second store opened at the same place while the first is still open")
func aNumberAddedToAStoreIsHeldByASecondStoreOpenedAtTheSamePlaceWhileTheFirstIsStillOpen() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let number = Number(70.5, for: commitment, on: monday)!

    let first = try RecordStore(at: place)
    try first.add(number)
    let second = try RecordStore(at: place)

    #expect(second.history.number(for: commitment, on: monday) == 70.5)
    #expect(second.history.isKept(commitment, on: monday))
}

@Test("a number taken back is not held by a store opened afterwards at the same place")
func aNumberTakenBackIsNotHeldByAStoreOpenedAfterwardsAtTheSamePlace() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let number = Number(70.5, for: commitment, on: monday)!

    let first = try RecordStore(at: place)
    try first.add(number)
    try first.removeNumber(for: commitment, on: monday)
    let later = try RecordStore(at: place)

    #expect(later.history.number(for: commitment, on: monday) == nil)
    #expect(later.history == History())
}

@Test("a number entered again is kept once by a store opened afterwards, as the later number")
func aNumberEnteredAgainIsKeptOnceByAStoreOpenedAfterwardsAsTheLaterNumber() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let commitment = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let first = try RecordStore(at: place)
    try first.add(Number(70.5, for: commitment, on: monday)!)
    try first.add(Number(71.2, for: commitment, on: monday)!)
    let later = try RecordStore(at: place)

    var expected = History()
    expected.add(Number(71.2, for: commitment, on: monday)!)
    #expect(later.history == expected)
    #expect(later.history.number(for: commitment, on: monday) == 71.2)
}

@Test("a number is read back exactly as it was given, whatever its digits")
func aNumberIsReadBackExactlyAsItWasGivenWhateverItsDigits() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let veryLarge = Decimal(string: "98765432109876543210.5")!
    let values: [Decimal] = [70.5, 0.000001, -12.75, 0, veryLarge]
    let commitments = values.map { value in
        Commitment(
            name: "\(value)", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!
    }

    let first = try RecordStore(at: place)
    var expected = History()
    for (commitment, value) in zip(commitments, values) {
        let number = Number(value, for: commitment, on: monday)!
        try first.add(number)
        expected.add(number)
    }

    let later = try RecordStore(at: place)

    for (commitment, value) in zip(commitments, values) {
        #expect(later.history.number(for: commitment, on: monday) == value)
    }
    #expect(later.history == expected)
}

@Test("a store opened again holds exactly the ticks and numbers added and not taken back")
func aStoreOpenedAgainHoldsExactlyTheTicksAndNumbersAddedAndNotTakenBack() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let gymOnMonday = Tick(gym, on: monday)!
    let gymOnWednesday = Tick(gym, on: wednesday)!
    let weightOnMonday = Number(70.5, for: weight, on: monday)!
    let weightOnWednesday = Number(71, for: weight, on: wednesday)!

    let store = try RecordStore(at: place)
    try store.add(gymOnMonday)
    try store.add(gymOnWednesday)
    try store.add(weightOnMonday)
    try store.add(weightOnWednesday)
    try store.remove(gymOnWednesday)
    try store.removeNumber(for: weight, on: monday)

    let later = try RecordStore(at: place)

    var expected = History()
    expected.add(gymOnMonday)
    expected.add(weightOnWednesday)
    #expect(later.history == expected)
    #expect(later.history.isKept(gym, on: monday))
    #expect(!later.history.isKept(gym, on: wednesday))
    #expect(later.history.number(for: weight, on: wednesday) == 71)
    #expect(later.history.number(for: weight, on: monday) == nil)
}

@Test("a store holding a number its commitment would refuse is refused")
func aStoreHoldingANumberItsCommitmentWouldRefuseIsRefused() throws {
    let outOfRangePlace = freshPlace()
    try FileManager.default.createDirectory(
        at: outOfRangePlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let outOfRangeBytes = Data(
        """
        {
          "version": 3,
          "ticks": [],
          "numbers": [
            {
              "commitment": {
                "name": "Weight",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "number": { "lowest": 40, "highest": 150 } }
              },
              "date": { "year": 2026, "month": 8, "day": 31 },
              "number": 300
            }
          ]
        }
        """.utf8)
    try outOfRangeBytes.write(to: outOfRangePlace)

    let wrongKindPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: wrongKindPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let wrongKindBytes = Data(
        """
        {
          "version": 3,
          "ticks": [],
          "numbers": [
            {
              "commitment": {
                "name": "Weight",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "tick": {} }
              },
              "date": { "year": 2026, "month": 8, "day": 31 },
              "number": 70.5
            }
          ]
        }
        """.utf8)
    try wrongKindBytes.write(to: wrongKindPlace)

    let notDuePlace = freshPlace()
    try FileManager.default.createDirectory(
        at: notDuePlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let notDueBytes = Data(
        """
        {
          "version": 3,
          "ticks": [],
          "numbers": [
            {
              "commitment": {
                "name": "Weight",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "number": {} }
              },
              "date": { "year": 2026, "month": 9, "day": 1 },
              "number": 70.5
            }
          ]
        }
        """.utf8)
    try notDueBytes.write(to: notDuePlace)

    #expect(throws: RecordStoreError.notAStore(at: outOfRangePlace)) {
        try RecordStore(at: outOfRangePlace)
    }
    #expect(throws: RecordStoreError.notAStore(at: wrongKindPlace)) {
        try RecordStore(at: wrongKindPlace)
    }
    #expect(throws: RecordStoreError.notAStore(at: notDuePlace)) {
        try RecordStore(at: notDuePlace)
    }
    #expect(try Data(contentsOf: outOfRangePlace) == outOfRangeBytes)
    #expect(try Data(contentsOf: wrongKindPlace) == wrongKindBytes)
    #expect(try Data(contentsOf: notDuePlace) == notDueBytes)
}

@Test("a store whose shape and declared form disagree about numbers is refused")
func aStoreWhoseShapeAndDeclaredFormDisagreeAboutNumbersIsRefused() throws {
    let earlyFormWithNumbersPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: earlyFormWithNumbersPlace.deletingLastPathComponent(),
        withIntermediateDirectories: true)
    let earlyFormWithNumbersBytes = Data(
        """
        {
          "version": 2,
          "ticks": [],
          "numbers": [
            {
              "commitment": {
                "name": "Weight",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "number": {} }
              },
              "date": { "year": 2026, "month": 8, "day": 31 },
              "number": 70.5
            }
          ]
        }
        """.utf8)
    try earlyFormWithNumbersBytes.write(to: earlyFormWithNumbersPlace)

    let currentFormWithoutNumbersPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: currentFormWithoutNumbersPlace.deletingLastPathComponent(),
        withIntermediateDirectories: true)
    let currentFormWithoutNumbersBytes = Data(
        """
        {
          "version": 4,
          "ticks": [],
          "notes": [
            {
              "commitment": {
                "name": "Journal",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "note": {} }
              },
              "date": { "year": 2026, "month": 8, "day": 31 },
              "text": "Ran 8k."
            }
          ]
        }
        """.utf8)
    try currentFormWithoutNumbersBytes.write(to: currentFormWithoutNumbersPlace)

    #expect(throws: RecordStoreError.notAStore(at: earlyFormWithNumbersPlace)) {
        try RecordStore(at: earlyFormWithNumbersPlace)
    }
    #expect(throws: RecordStoreError.notAStore(at: currentFormWithoutNumbersPlace)) {
        try RecordStore(at: currentFormWithoutNumbersPlace)
    }
    #expect(try Data(contentsOf: earlyFormWithNumbersPlace) == earlyFormWithNumbersBytes)
    #expect(
        try Data(contentsOf: currentFormWithoutNumbersPlace) == currentFormWithoutNumbersBytes)
}

@Test("a history kept before a commitment carried a kind is read with every commitment of the plain kind")
func aHistoryKeptBeforeACommitmentCarriedAKindIsReadWithEveryCommitmentOfThePlainKind() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 1,
          "ticks": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "date": { "year": 2026, "month": 8, "day": 31 }
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RecordStore(at: place)

    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var expected = History()
    expected.add(Tick(gym, on: monday)!)

    #expect(store.history == expected)
    #expect(store.history.isKept(gym, on: monday))
}

@Test("a history kept before a day could hold a number is read, and no day in it holds a number")
func aHistoryKeptBeforeADayCouldHoldANumberIsReadAndNoDayInItHoldsANumber() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 2,
          "ticks": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "tick": {} }
              },
              "date": { "year": 2026, "month": 8, "day": 31 }
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RecordStore(at: place)

    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: nil))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var expected = History()
    expected.add(Tick(gym, on: monday)!)

    #expect(store.history == expected)
    #expect(store.history.isKept(gym, on: monday))
    #expect(store.history.number(for: weight, on: monday) == nil)
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a number added over a history kept before a day could hold a number is read back beside the ticks already there")
func aNumberAddedOverAHistoryKeptBeforeADayCouldHoldANumberIsReadBackBesideTheTicksAlreadyThere()
    throws
{
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 2,
          "ticks": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "tick": {} }
              },
              "date": { "year": 2026, "month": 8, "day": 31 }
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RecordStore(at: place)
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let number = Number(70.5, for: weight, on: monday)!
    try store.add(number)

    let later = try RecordStore(at: place)

    var expected = History()
    expected.add(Tick(gym, on: monday)!)
    expected.add(number)
    #expect(later.history == expected)
    #expect(later.history.isKept(gym, on: monday))
    #expect(later.history.number(for: weight, on: monday) == 70.5)
}

@Test("reading a history kept in an earlier form changes nothing at its place")
func readingAHistoryKeptInAnEarlierFormChangesNothingAtItsPlace() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 1,
          "ticks": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "date": { "year": 2026, "month": 8, "day": 31 }
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    _ = try RecordStore(at: place)

    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a tick added over a history kept in an earlier form is read back beside the ticks already there")
func aTickAddedOverAHistoryKeptInAnEarlierFormIsReadBackBesideTheTicksAlreadyThere() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 1,
          "ticks": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
              },
              "date": { "year": 2026, "month": 8, "day": 31 }
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RecordStore(at: place)
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    try store.add(Tick(gym, on: wednesday)!)

    let later = try RecordStore(at: place)

    var expected = History()
    expected.add(Tick(gym, on: monday)!)
    expected.add(Tick(gym, on: wednesday)!)
    #expect(later.history == expected)
    #expect(later.history.isKept(gym, on: monday))
    #expect(later.history.isKept(gym, on: wednesday))
}

@Test("a note added to a store is held by a second store opened at the same place while the first is still open")
func aNoteAddedToAStoreIsHeldByASecondStoreOpenedAtTheSamePlaceWhileTheFirstIsStillOpen() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let note = Note("Ran 8k.", for: commitment, on: monday)!

    let first = try RecordStore(at: place)
    try first.add(note)
    let second = try RecordStore(at: place)

    #expect(second.history.note(for: commitment, on: monday) == "Ran 8k.")
    #expect(second.history.isKept(commitment, on: monday))
}

@Test("a note taken back is not held by a store opened afterwards at the same place")
func aNoteTakenBackIsNotHeldByAStoreOpenedAfterwardsAtTheSamePlace() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let note = Note("Ran 8k.", for: commitment, on: monday)!

    let first = try RecordStore(at: place)
    try first.add(note)
    try first.removeNote(for: commitment, on: monday)
    let later = try RecordStore(at: place)

    #expect(later.history.note(for: commitment, on: monday) == nil)
    #expect(later.history == History())
}

@Test("a note written again is kept once by a store opened afterwards, as the later note")
func aNoteWrittenAgainIsKeptOnceByAStoreOpenedAfterwardsAsTheLaterNote() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let first = try RecordStore(at: place)
    try first.add(Note("Ran 8k.", for: commitment, on: monday)!)
    try first.add(Note("Ran 8k. Knee held up.", for: commitment, on: monday)!)
    let later = try RecordStore(at: place)

    var expected = History()
    expected.add(Note("Ran 8k. Knee held up.", for: commitment, on: monday)!)
    #expect(later.history == expected)
    #expect(later.history.note(for: commitment, on: monday) == "Ran 8k. Knee held up.")
}

@Test("a note is read back exactly as it was written, whatever it contains")
func aNoteIsReadBackExactlyAsItWasWrittenWhateverItContains() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let texts: [(name: String, text: String)] = [
        ("ThreeLines", "Line one\nLine two\nLine three"),
        ("Emoji", "👩‍👩‍👧‍👦"),
        ("RightToLeft", "שלום עולם"),
        ("Decomposed", "e\u{0301}"),
        ("Spaced", " Ran 8k. "),
        ("Long", String(repeating: "a", count: 100_000)),
    ]
    let commitments = texts.map { name, _ in
        Commitment(name: name, schedule: schedule, keptFrom: keptFrom, kind: .note)!
    }

    let first = try RecordStore(at: place)
    var expected = History()
    for (commitment, (_, text)) in zip(commitments, texts) {
        let note = Note(text, for: commitment, on: monday)!
        try first.add(note)
        expected.add(note)
    }

    let later = try RecordStore(at: place)

    for (commitment, (_, text)) in zip(commitments, texts) {
        let read = later.history.note(for: commitment, on: monday)
        #expect(read.map { Array($0.unicodeScalars) } == Array(text.unicodeScalars))
    }
    #expect(later.history == expected)
}

@Test("a store opened again holds exactly the ticks, numbers and notes added and not taken back")
func aStoreOpenedAgainHoldsExactlyTheTicksNumbersAndNotesAddedAndNotTakenBack() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let gymOnMonday = Tick(gym, on: monday)!
    let weightOnMonday = Number(70.5, for: weight, on: monday)!
    let journalOnMonday = Note("Ran 8k.", for: journal, on: monday)!
    let journalOnWednesday = Note("Rested.", for: journal, on: wednesday)!

    let store = try RecordStore(at: place)
    try store.add(gymOnMonday)
    try store.add(weightOnMonday)
    try store.add(journalOnMonday)
    try store.add(journalOnWednesday)
    try store.removeNumber(for: weight, on: monday)
    try store.removeNote(for: journal, on: monday)

    let later = try RecordStore(at: place)

    var expected = History()
    expected.add(gymOnMonday)
    expected.add(journalOnWednesday)
    #expect(later.history == expected)
    #expect(later.history.isKept(gym, on: monday))
    #expect(later.history.number(for: weight, on: monday) == nil)
    #expect(later.history.note(for: journal, on: monday) == nil)
    #expect(later.history.note(for: journal, on: wednesday) == "Rested.")
}

@Test("a note that cannot be kept is refused and not held")
func aNoteThatCannotBeKeptIsRefusedAndNotHeld() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    let place = blocker.appendingPathComponent("store.json")

    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let commitment = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let note = Note("Ran 8k.", for: commitment, on: monday)!

    let store = try RecordStore(at: place)

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try store.add(note)
    }
    #expect(store.history == History())

    let later = try RecordStore(at: place)
    #expect(later.history == History())
}

@Test("a store holding a note that could not be a note is refused")
func aStoreHoldingANoteThatCouldNotBeANoteIsRefused() throws {
    let blankTextPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: blankTextPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let blankTextBytes = Data(
        """
        {
          "version": 4,
          "ticks": [],
          "numbers": [],
          "notes": [
            {
              "commitment": {
                "name": "Journal",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "note": {} }
              },
              "date": { "year": 2026, "month": 8, "day": 31 },
              "text": "   "
            }
          ]
        }
        """.utf8)
    try blankTextBytes.write(to: blankTextPlace)

    let wrongKindPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: wrongKindPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let wrongKindBytes = Data(
        """
        {
          "version": 4,
          "ticks": [],
          "numbers": [],
          "notes": [
            {
              "commitment": {
                "name": "Journal",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "tick": {} }
              },
              "date": { "year": 2026, "month": 8, "day": 31 },
              "text": "Ran 8k."
            }
          ]
        }
        """.utf8)
    try wrongKindBytes.write(to: wrongKindPlace)

    let notDuePlace = freshPlace()
    try FileManager.default.createDirectory(
        at: notDuePlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let notDueBytes = Data(
        """
        {
          "version": 4,
          "ticks": [],
          "numbers": [],
          "notes": [
            {
              "commitment": {
                "name": "Journal",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "note": {} }
              },
              "date": { "year": 2026, "month": 9, "day": 1 },
              "text": "Ran 8k."
            }
          ]
        }
        """.utf8)
    try notDueBytes.write(to: notDuePlace)

    #expect(throws: RecordStoreError.notAStore(at: blankTextPlace)) {
        try RecordStore(at: blankTextPlace)
    }
    #expect(throws: RecordStoreError.notAStore(at: wrongKindPlace)) {
        try RecordStore(at: wrongKindPlace)
    }
    #expect(throws: RecordStoreError.notAStore(at: notDuePlace)) {
        try RecordStore(at: notDuePlace)
    }
    #expect(try Data(contentsOf: blankTextPlace) == blankTextBytes)
    #expect(try Data(contentsOf: wrongKindPlace) == wrongKindBytes)
    #expect(try Data(contentsOf: notDuePlace) == notDueBytes)
}

@Test("a history kept before a day could hold a note is read, and no day in it holds a note")
func aHistoryKeptBeforeADayCouldHoldANoteIsReadAndNoDayInItHoldsANote() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 3,
          "ticks": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "tick": {} }
              },
              "date": { "year": 2026, "month": 8, "day": 31 }
            }
          ],
          "numbers": [
            {
              "commitment": {
                "name": "Weight",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "number": { "lowest": 40, "highest": 150 } }
              },
              "date": { "year": 2026, "month": 8, "day": 31 },
              "number": 70.5
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RecordStore(at: place)

    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var expected = History()
    expected.add(Tick(gym, on: monday)!)
    expected.add(Number(70.5, for: weight, on: monday)!)

    #expect(store.history == expected)
    #expect(store.history.isKept(gym, on: monday))
    #expect(store.history.number(for: weight, on: monday) == 70.5)
    #expect(store.history.note(for: journal, on: monday) == nil)
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a note added over a history kept before a day could hold a note is read back beside the records already there")
func aNoteAddedOverAHistoryKeptBeforeADayCouldHoldANoteIsReadBackBesideTheRecordsAlreadyThere()
    throws
{
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 3,
          "ticks": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "tick": {} }
              },
              "date": { "year": 2026, "month": 8, "day": 31 }
            }
          ],
          "numbers": [
            {
              "commitment": {
                "name": "Weight",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "number": { "lowest": 40, "highest": 150 } }
              },
              "date": { "year": 2026, "month": 8, "day": 31 },
              "number": 70.5
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RecordStore(at: place)
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let note = Note("Ran 8k.", for: journal, on: monday)!
    try store.add(note)

    let later = try RecordStore(at: place)

    var expected = History()
    expected.add(Tick(gym, on: monday)!)
    expected.add(Number(70.5, for: weight, on: monday)!)
    expected.add(note)
    #expect(later.history == expected)
    #expect(later.history.isKept(gym, on: monday))
    #expect(later.history.number(for: weight, on: monday) == 70.5)
    #expect(later.history.note(for: journal, on: monday) == "Ran 8k.")
}

@Test("a store whose shape and declared form disagree about notes is refused")
func aStoreWhoseShapeAndDeclaredFormDisagreeAboutNotesIsRefused() throws {
    let earlyFormWithNotesPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: earlyFormWithNotesPlace.deletingLastPathComponent(),
        withIntermediateDirectories: true)
    let earlyFormWithNotesBytes = Data(
        """
        {
          "version": 3,
          "ticks": [],
          "numbers": [],
          "notes": [
            {
              "commitment": {
                "name": "Journal",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "note": {} }
              },
              "date": { "year": 2026, "month": 8, "day": 31 },
              "text": "Ran 8k."
            }
          ]
        }
        """.utf8)
    try earlyFormWithNotesBytes.write(to: earlyFormWithNotesPlace)

    let currentFormWithoutNotesPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: currentFormWithoutNotesPlace.deletingLastPathComponent(),
        withIntermediateDirectories: true)
    let currentFormWithoutNotesBytes = Data(
        #"{"version": 4, "ticks": [], "numbers": []}"#.utf8)
    try currentFormWithoutNotesBytes.write(to: currentFormWithoutNotesPlace)

    let earlyFormNeitherPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: earlyFormNeitherPlace.deletingLastPathComponent(),
        withIntermediateDirectories: true)
    let earlyFormNeitherBytes = Data(#"{"version": 2, "ticks": []}"#.utf8)
    try earlyFormNeitherBytes.write(to: earlyFormNeitherPlace)

    #expect(throws: RecordStoreError.notAStore(at: earlyFormWithNotesPlace)) {
        try RecordStore(at: earlyFormWithNotesPlace)
    }
    #expect(throws: RecordStoreError.notAStore(at: currentFormWithoutNotesPlace)) {
        try RecordStore(at: currentFormWithoutNotesPlace)
    }
    let readWithoutError = try RecordStore(at: earlyFormNeitherPlace)
    #expect(readWithoutError.history == History())
    #expect(try Data(contentsOf: earlyFormWithNotesPlace) == earlyFormWithNotesBytes)
    #expect(
        try Data(contentsOf: currentFormWithoutNotesPlace) == currentFormWithoutNotesBytes)
    #expect(try Data(contentsOf: earlyFormNeitherPlace) == earlyFormNeitherBytes)
}

@Test(
    "an addition made in a store is held by a second store opened at the same place while the first is still open"
)
func anAdditionMadeInAStoreIsHeldByASecondStoreOpenedAtTheSamePlaceWhileTheFirstIsStillOpen()
    throws
{
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let addition = Addition(30, for: protein, on: monday)!

    let first = try RecordStore(at: place)
    try first.add(addition)
    let second = try RecordStore(at: place)

    #expect(second.history.total(for: protein, on: monday) == 30)
    #expect(!second.history.isKept(protein, on: monday))
}

@Test("a day's additions are read back in the order they were made")
func aDaysAdditionsAreReadBackInTheOrderTheyWereMade() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let store = try RecordStore(at: place)
    try store.add(Addition(45, for: protein, on: monday)!)
    try store.add(Addition(30, for: protein, on: monday)!)

    let later = try RecordStore(at: place)

    #expect(later.history.total(for: protein, on: monday) == 75)

    try later.removeLastAddition(for: protein, on: monday)

    #expect(later.history.total(for: protein, on: monday) == 45)

    let evenLater = try RecordStore(at: place)
    #expect(evenLater.history.total(for: protein, on: monday) == 45)
}

@Test("a day's last addition taken back is not held by a store opened afterwards at the same place")
func aDaysLastAdditionTakenBackIsNotHeldByAStoreOpenedAfterwardsAtTheSamePlace() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let first = try RecordStore(at: place)
    try first.add(Addition(30, for: protein, on: monday)!)
    try first.removeLastAddition(for: protein, on: monday)
    let later = try RecordStore(at: place)

    #expect(later.history.total(for: protein, on: monday) == 0)
    #expect(later.history == History())
}

@Test("two additions alike in every way on one day are both read back")
func twoAdditionsAlikeInEveryWayOnOneDayAreBothReadBack() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    let store = try RecordStore(at: place)
    try store.add(Addition(30, for: protein, on: monday)!)
    try store.add(Addition(30, for: protein, on: monday)!)

    let later = try RecordStore(at: place)

    #expect(later.history.total(for: protein, on: monday) == 60)

    try later.removeLastAddition(for: protein, on: monday)
    #expect(later.history.total(for: protein, on: monday) == 30)

    try later.removeLastAddition(for: protein, on: monday)
    #expect(later.history.total(for: protein, on: monday) == 0)
}

@Test("an amount is read back exactly as it was given, whatever its digits")
func anAmountIsReadBackExactlyAsItWasGivenWhateverItsDigits() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let thirtyEightNines = Decimal(string: String(repeating: "9", count: 38))!
    let amounts: [Decimal] = [0.000001, 30, 119.95, thirtyEightNines]
    let target = Commitment.Target(120)!
    let commitments = amounts.map { amount in
        Commitment(
            name: "\(amount)", schedule: schedule, keptFrom: keptFrom, kind: .total(target: target))!
    }

    let first = try RecordStore(at: place)
    var expected = History()
    for (commitment, amount) in zip(commitments, amounts) {
        let addition = Addition(amount, for: commitment, on: monday)!
        try first.add(addition)
        expected.add(addition)
    }

    let later = try RecordStore(at: place)

    for (commitment, amount) in zip(commitments, amounts) {
        #expect(later.history.total(for: commitment, on: monday) == amount)
    }
    #expect(later.history == expected)
}

@Test("a store opened again holds exactly the ticks, numbers, notes and additions added and not taken back")
func aStoreOpenedAgainHoldsExactlyTheTicksNumbersNotesAndAdditionsAddedAndNotTakenBack() throws {
    let place = freshPlace()
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let wednesday = CalendarDate(year: 2026, month: 9, day: 2)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let tick = Tick(gym, on: monday)!
    let number = Number(70.5, for: weight, on: monday)!
    let note = Note("Ran 8k.", for: journal, on: monday)!
    let additionOnMonday = Addition(30, for: protein, on: monday)!
    let additionOnWednesday = Addition(45, for: protein, on: wednesday)!

    let store = try RecordStore(at: place)
    try store.add(tick)
    try store.add(number)
    try store.add(note)
    try store.add(additionOnMonday)
    try store.add(additionOnWednesday)
    try store.removeNumber(for: weight, on: monday)
    try store.removeLastAddition(for: protein, on: wednesday)

    let later = try RecordStore(at: place)

    var expected = History()
    expected.add(tick)
    expected.add(note)
    expected.add(additionOnMonday)
    #expect(later.history == expected)
    #expect(later.history.isKept(gym, on: monday))
    #expect(later.history.number(for: weight, on: monday) == nil)
    #expect(later.history.note(for: journal, on: monday) == "Ran 8k.")
    #expect(later.history.total(for: protein, on: monday) == 30)
    #expect(later.history.total(for: protein, on: wednesday) == 0)
}

@Test("an addition that cannot be kept is refused and not held")
func anAdditionThatCannotBeKeptIsRefusedAndNotHeld() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    let place = blocker.appendingPathComponent("store.json")

    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let addition = Addition(30, for: protein, on: monday)!

    let store = try RecordStore(at: place)

    #expect(throws: RecordStoreError.cannotWrite(at: place)) {
        try store.add(addition)
    }
    #expect(store.history == History())

    let later = try RecordStore(at: place)
    #expect(later.history == History())
}

@Test("a history kept before a day could hold an addition is read, and no day in it holds one")
func aHistoryKeptBeforeADayCouldHoldAnAdditionIsReadAndNoDayInItHoldsOne() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 4,
          "ticks": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "tick": {} }
              },
              "date": { "year": 2026, "month": 8, "day": 31 }
            }
          ],
          "numbers": [
            {
              "commitment": {
                "name": "Weight",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "number": { "lowest": 40, "highest": 150 } }
              },
              "date": { "year": 2026, "month": 8, "day": 31 },
              "number": 70.5
            }
          ],
          "notes": [
            {
              "commitment": {
                "name": "Journal",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "note": {} }
              },
              "date": { "year": 2026, "month": 8, "day": 31 },
              "text": "Ran 8k."
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RecordStore(at: place)

    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let range = Commitment.Range(lowest: 40, highest: 150)!
    let weight = Commitment(
        name: "Weight", schedule: schedule, keptFrom: keptFrom, kind: .number(range: range))!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    var expected = History()
    expected.add(Tick(gym, on: monday)!)
    expected.add(Number(70.5, for: weight, on: monday)!)
    expected.add(Note("Ran 8k.", for: journal, on: monday)!)

    #expect(store.history == expected)
    #expect(store.history.isKept(gym, on: monday))
    #expect(store.history.number(for: weight, on: monday) == 70.5)
    #expect(store.history.note(for: journal, on: monday) == "Ran 8k.")
    #expect(store.history.total(for: protein, on: monday) == 0)
    #expect(!store.history.isKept(protein, on: monday))
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("an addition made over a history kept before a day could hold an addition is read back beside the records already there")
func anAdditionMadeOverAHistoryKeptBeforeADayCouldHoldAnAdditionIsReadBackBesideTheRecordsAlreadyThere()
    throws
{
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 4,
          "ticks": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "tick": {} }
              },
              "date": { "year": 2026, "month": 8, "day": 31 }
            }
          ],
          "numbers": [],
          "notes": [
            {
              "commitment": {
                "name": "Journal",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "note": {} }
              },
              "date": { "year": 2026, "month": 8, "day": 31 },
              "text": "Ran 8k."
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RecordStore(at: place)
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom, kind: .tick)!
    let journal = Commitment(name: "Journal", schedule: schedule, keptFrom: keptFrom, kind: .note)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let firstAddition = Addition(30, for: protein, on: monday)!
    let secondAddition = Addition(90, for: protein, on: monday)!
    try store.add(firstAddition)
    try store.add(secondAddition)

    let later = try RecordStore(at: place)

    var expected = History()
    expected.add(Tick(gym, on: monday)!)
    expected.add(Note("Ran 8k.", for: journal, on: monday)!)
    expected.add(firstAddition)
    expected.add(secondAddition)
    #expect(later.history == expected)
    #expect(later.history.isKept(gym, on: monday))
    #expect(later.history.note(for: journal, on: monday) == "Ran 8k.")
    #expect(later.history.total(for: protein, on: monday) == 120)
    #expect(later.history.isKept(protein, on: monday))
}

@Test("a store whose shape and declared form disagree about additions is refused")
func aStoreWhoseShapeAndDeclaredFormDisagreeAboutAdditionsIsRefused() throws {
    let earlyFormWithAdditionsPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: earlyFormWithAdditionsPlace.deletingLastPathComponent(),
        withIntermediateDirectories: true)
    let earlyFormWithAdditionsBytes = Data(
        """
        {
          "version": 4,
          "ticks": [],
          "numbers": [],
          "notes": [],
          "additions": [
            {
              "commitment": {
                "name": "Protein",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "total": { "target": 120 } }
              },
              "date": { "year": 2026, "month": 8, "day": 31 },
              "amounts": [30]
            }
          ]
        }
        """.utf8)
    try earlyFormWithAdditionsBytes.write(to: earlyFormWithAdditionsPlace)

    let currentFormWithoutAdditionsPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: currentFormWithoutAdditionsPlace.deletingLastPathComponent(),
        withIntermediateDirectories: true)
    let currentFormWithoutAdditionsBytes = Data(
        #"{"version": 5, "ticks": [], "numbers": [], "notes": []}"#.utf8)
    try currentFormWithoutAdditionsBytes.write(to: currentFormWithoutAdditionsPlace)

    let earlyFormNeitherPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: earlyFormNeitherPlace.deletingLastPathComponent(),
        withIntermediateDirectories: true)
    let earlyFormNeitherBytes = Data(#"{"version": 3, "ticks": [], "numbers": []}"#.utf8)
    try earlyFormNeitherBytes.write(to: earlyFormNeitherPlace)

    #expect(throws: RecordStoreError.notAStore(at: earlyFormWithAdditionsPlace)) {
        try RecordStore(at: earlyFormWithAdditionsPlace)
    }
    #expect(throws: RecordStoreError.notAStore(at: currentFormWithoutAdditionsPlace)) {
        try RecordStore(at: currentFormWithoutAdditionsPlace)
    }
    let readWithoutError = try RecordStore(at: earlyFormNeitherPlace)
    #expect(readWithoutError.history == History())

    #expect(
        try Data(contentsOf: earlyFormWithAdditionsPlace) == earlyFormWithAdditionsBytes)
    #expect(
        try Data(contentsOf: currentFormWithoutAdditionsPlace)
            == currentFormWithoutAdditionsBytes)
    #expect(try Data(contentsOf: earlyFormNeitherPlace) == earlyFormNeitherBytes)
}

@Test("a store holding what could not be an addition is refused")
func aStoreHoldingWhatCouldNotBeAnAdditionIsRefused() throws {
    let zeroPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: zeroPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let zeroBytes = Data(
        """
        {
          "version": 5,
          "ticks": [],
          "numbers": [],
          "notes": [],
          "additions": [
            {
              "commitment": {
                "name": "Protein",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "total": { "target": 120 } }
              },
              "date": { "year": 2026, "month": 8, "day": 31 },
              "amounts": [0]
            }
          ]
        }
        """.utf8)
    try zeroBytes.write(to: zeroPlace)

    let negativePlace = freshPlace()
    try FileManager.default.createDirectory(
        at: negativePlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let negativeBytes = Data(
        """
        {
          "version": 5,
          "ticks": [],
          "numbers": [],
          "notes": [],
          "additions": [
            {
              "commitment": {
                "name": "Protein",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "total": { "target": 120 } }
              },
              "date": { "year": 2026, "month": 8, "day": 31 },
              "amounts": [-30]
            }
          ]
        }
        """.utf8)
    try negativeBytes.write(to: negativePlace)

    let wrongKindPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: wrongKindPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let wrongKindBytes = Data(
        """
        {
          "version": 5,
          "ticks": [],
          "numbers": [],
          "notes": [],
          "additions": [
            {
              "commitment": {
                "name": "Protein",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "tick": {} }
              },
              "date": { "year": 2026, "month": 8, "day": 31 },
              "amounts": [30]
            }
          ]
        }
        """.utf8)
    try wrongKindBytes.write(to: wrongKindPlace)

    let notDuePlace = freshPlace()
    try FileManager.default.createDirectory(
        at: notDuePlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let notDueBytes = Data(
        """
        {
          "version": 5,
          "ticks": [],
          "numbers": [],
          "notes": [],
          "additions": [
            {
              "commitment": {
                "name": "Protein",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "total": { "target": 120 } }
              },
              "date": { "year": 2026, "month": 9, "day": 1 },
              "amounts": [30]
            }
          ]
        }
        """.utf8)
    try notDueBytes.write(to: notDuePlace)

    let emptyDayPlace = freshPlace()
    try FileManager.default.createDirectory(
        at: emptyDayPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    let emptyDayBytes = Data(
        """
        {
          "version": 5,
          "ticks": [],
          "numbers": [],
          "notes": [],
          "additions": [
            {
              "commitment": {
                "name": "Protein",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "total": { "target": 120 } }
              },
              "date": { "year": 2026, "month": 8, "day": 31 },
              "amounts": []
            }
          ]
        }
        """.utf8)
    try emptyDayBytes.write(to: emptyDayPlace)

    #expect(throws: RecordStoreError.notAStore(at: zeroPlace)) {
        try RecordStore(at: zeroPlace)
    }
    #expect(throws: RecordStoreError.notAStore(at: negativePlace)) {
        try RecordStore(at: negativePlace)
    }
    #expect(throws: RecordStoreError.notAStore(at: wrongKindPlace)) {
        try RecordStore(at: wrongKindPlace)
    }
    #expect(throws: RecordStoreError.notAStore(at: notDuePlace)) {
        try RecordStore(at: notDuePlace)
    }
    #expect(throws: RecordStoreError.notAStore(at: emptyDayPlace)) {
        try RecordStore(at: emptyDayPlace)
    }
    #expect(try Data(contentsOf: zeroPlace) == zeroBytes)
    #expect(try Data(contentsOf: negativePlace) == negativeBytes)
    #expect(try Data(contentsOf: wrongKindPlace) == wrongKindBytes)
    #expect(try Data(contentsOf: notDuePlace) == notDueBytes)
    #expect(try Data(contentsOf: emptyDayPlace) == emptyDayBytes)
}

@Test("a store holding a day whose additions sum past what can be kept exactly is read rather than refused")
func aStoreHoldingADayWhoseAdditionsSumPastWhatCanBeKeptExactlyIsReadRatherThanRefused() throws {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bytes = Data(
        """
        {
          "version": 5,
          "ticks": [],
          "numbers": [],
          "notes": [],
          "additions": [
            {
              "commitment": {
                "name": "Protein",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": ["monday", "wednesday", "saturday"] },
                "kind": { "total": { "target": 120 } }
              },
              "date": { "year": 2026, "month": 8, "day": 31 },
              "amounts": [99999999999999999999999999999999999999, 0.5]
            }
          ]
        }
        """.utf8)
    try bytes.write(to: place)

    let store = try RecordStore(at: place)

    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: schedule, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!

    #expect(store.history.isKept(protein, on: monday))
    #expect(store.history.total(for: protein, on: monday) > Commitment.Target(120)!.amount)
    #expect(try Data(contentsOf: place) == bytes)
}
