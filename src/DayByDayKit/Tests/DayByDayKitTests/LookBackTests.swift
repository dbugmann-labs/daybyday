import Foundation
import Testing

@testable import DayByDayKit

/// A fresh pair of places under one fresh temporary directory — a roster file and a record file
/// beside it. Mirrors `CommitmentsScreenTests.freshRosterAndRecordPlaces()`.
private func freshRosterAndRecordPlaces() -> (roster: URL, record: URL) {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    return (
        directory.appendingPathComponent("roster.json"),
        directory.appendingPathComponent("record.json")
    )
}

@MainActor
@Test("a commitments screen answers a look-back at a commitment it keeps")
func aCommitmentsScreenAnswersALookBackAtACommitmentItKeeps() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.name == "Gym")
    #expect(lookBack?.rhythmInWords == "Mon, Wed, Sat")
    #expect(lookBack?.keptFromInWords == "1 January 2026")
    #expect(lookBack?.keptUntilInWords == nil)
}

@MainActor
@Test(
    "a commitments screen answers a look-back at a commitment it has stopped, saying the day it was kept until"
)
func aCommitmentsScreenAnswersALookBackAtACommitmentItHasStoppedSayingTheDayItWasKeptUntil() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let keptUntil = CalendarDate(year: 2026, month: 2, day: 28)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.retire(gym, keptUntil: keptUntil)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.name == "Gym")
    #expect(lookBack?.rhythmInWords == "Mon, Wed, Sat")
    #expect(lookBack?.keptFromInWords == "1 January 2026")
    #expect(lookBack?.keptUntilInWords == "28 February 2026")
}

@MainActor
@Test("a commitments screen answers no look-back at a commitment on neither of its lists")
func aCommitmentsScreenAnswersNoLookBackAtACommitmentOnNeitherOfItsLists() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let journaling = Commitment(
        name: "Journaling", schedule: .weekdays([.monday, .wednesday, .saturday]),
        keptFrom: keptFrom)!
    let keptUntil = CalendarDate(year: 2026, month: 2, day: 28)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.remove(journaling, keptUntil: keptUntil)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let notHeldAtAll = Commitment(
        name: "Nothing at all", schedule: .weekdays([.monday]), keptFrom: keptFrom)!

    #expect(screen.lookBack(at: notHeldAtAll) == nil)
    #expect(screen.lookBack(at: journaling) == nil)
}

@MainActor
@Test("a commitments screen that cannot read its roster or its record answers no look-back")
func aCommitmentsScreenThatCannotReadItsRosterOrItsRecordAnswersNoLookBack() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!

    let badRosterPlaces = freshRosterAndRecordPlaces()
    try FileManager.default.createDirectory(
        at: badRosterPlaces.roster.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a roster is written as".utf8).write(to: badRosterPlaces.roster)
    let screenWithBadRoster = CommitmentsScreen(
        asOf: today, keepingRosterAt: badRosterPlaces.roster,
        keepingRecordAt: badRosterPlaces.record)

    #expect(screenWithBadRoster.lookBack(at: gym) == nil)

    let badRecordPlaces = freshRosterAndRecordPlaces()
    let rosterStore = try RosterStore(at: badRecordPlaces.roster)
    try rosterStore.add(gym)
    try FileManager.default.createDirectory(
        at: badRecordPlaces.record.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a record is written as".utf8).write(to: badRecordPlaces.record)
    let screenWithBadRecord = CommitmentsScreen(
        asOf: today, keepingRosterAt: badRecordPlaces.roster,
        keepingRecordAt: badRecordPlaces.record)

    #expect(screenWithBadRecord.lookBack(at: gym) == nil)
}

@MainActor
@Test("asking a commitments screen for a look-back changes nothing and writes nothing")
func askingACommitmentsScreenForALookBackChangesNothingAndWritesNothing() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    let firstDue = CalendarDate(year: 2026, month: 1, day: 3)!
    try recordStore.add(Tick(gym, on: firstDue)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    // A refused change already held, before the ask — so the AND below is not comparing two
    // `nil`s regardless of what a look-back does to `refusedChange`.
    _ = screen.change(gym, toName: "", on: Rhythm(gym.schedule), keptFrom: gym.keptFrom, under: nil)
    let keptBefore = screen.kept
    let stoppedBefore = screen.stopped
    let refusedChangeBefore = screen.refusedChange
    #expect(refusedChangeBefore != nil)
    let rosterBytesBefore = try Data(contentsOf: places.roster)
    let recordBytesBefore = try Data(contentsOf: places.record)

    let first = screen.lookBack(at: gym)
    let second = screen.lookBack(at: gym)

    #expect(first == second)
    #expect(screen.kept == keptBefore)
    #expect(screen.stopped == stoppedBefore)
    #expect(screen.refusedChange == refusedChangeBefore)
    #expect(try Data(contentsOf: places.roster) == rosterBytesBefore)
    #expect(try Data(contentsOf: places.record) == recordBytesBefore)
}

@MainActor
@Test("a look-back says a month's kept days out of the days that month was due")
func aLookBackSaysAMonthsKeptDaysOutOfTheDaysThatMonthWasDue() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!
    // Every Monday, Wednesday and Saturday of February 2026 the commitment is due, twelve days
    // in all — kept on every one of them except 2 February 2026.
    let februaryDueDays = [
        4, 7, 9, 11, 14, 16, 18, 21, 23, 25, 28,
    ].map { CalendarDate(year: 2026, month: 2, day: $0)! }

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    for day in februaryDueDays {
        try recordStore.add(Tick(gym, on: day)!)
    }

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(
        lookBack?.lines.contains(.month(inWords: "February 2026", fraction: "11/12")) == true)
}

@MainActor
@Test("a look-back says its months newest first, and leaves none between out")
func aLookBackSaysItsMonthsNewestFirstAndLeavesNoneBetweenOut() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    let months = lookBack?.lines.compactMap { line -> String? in
        if case .month(let inWords, _) = line { return inWords }
        return nil
    }
    #expect(months == ["March 2026", "February 2026", "January 2026"])
}

@MainActor
@Test("a look-back says a month the commitment was due on no day with nothing due")
func aLookBackSaysAMonthTheCommitmentWasDueOnNoDayWithNothingDue() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let sharpenKnives = Commitment(
        name: "Sharpen knives", schedule: .everyNDays(DayInterval(days: 40)!, from: keptFrom),
        keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 5, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(sharpenKnives)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: sharpenKnives)

    let months = lookBack?.lines.compactMap { line -> String? in
        if case .month(let inWords, _) = line { return inWords }
        return nil
    }
    #expect(
        months == [
            "May 2026", "April 2026", "March 2026", "February 2026", "January 2026",
        ])
    #expect(lookBack?.lines.contains(.month(inWords: "April 2026", fraction: "0/0")) == true)
}

@MainActor
@Test("a look-back counts the month in progress through today and no further")
func aLookBackCountsTheMonthInProgressThroughTodayAndNoFurther() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.lines.contains(.month(inWords: "March 2026", fraction: "0/6")) == true)
}

@MainActor
@Test("a stopped commitment's look-back counts through the day it was kept until")
func aStoppedCommitmentsLookBackCountsThroughTheDayItWasKeptUntil() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let keptUntil = CalendarDate(year: 2026, month: 2, day: 28)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.retire(gym, keptUntil: keptUntil)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    let months = lookBack?.lines.compactMap { line -> String? in
        if case .month(let inWords, _) = line { return inWords }
        return nil
    }
    #expect(months == ["February 2026", "January 2026"])
    #expect(lookBack?.lines.contains(.month(inWords: "February 2026", fraction: "0/12")) == true)
}

@MainActor
@Test("a look-back counts no day after the day a commitment was kept until")
func aLookBackCountsNoDayAfterTheDayACommitmentWasKeptUntil() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let keptUntil = CalendarDate(year: 2026, month: 2, day: 28)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!
    let afterKeptUntil = CalendarDate(year: 2026, month: 3, day: 4)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.retire(gym, keptUntil: keptUntil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: afterKeptUntil)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.lines.contains(.month(inWords: "February 2026", fraction: "0/12")) == true)
    #expect(
        lookBack?.lines.contains { if case .month(let inWords, _) = $0 { return inWords == "March 2026" }; return false }
            == false)
}

@MainActor
@Test("a look-back counts no day before the day a commitment is kept from")
func aLookBackCountsNoDayBeforeTheDayACommitmentIsKeptFrom() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 2, day: 16)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 2, day: 28)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.lines == [.month(inWords: "February 2026", fraction: "0/6")])
}

@MainActor
@Test("a look-back at a commitment kept from a day after today says no month at all")
func aLookBackAtACommitmentKeptFromADayAfterTodaySaysNoMonthAtAll() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 4, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.lines == [])
    #expect(lookBack?.name == "Gym")
    #expect(lookBack?.rhythmInWords == "Mon, Wed, Sat")
    #expect(lookBack?.keptFromInWords == "1 April 2026")
}

@MainActor
@Test("a look-back's whole counts every kept day out of every due day since the day it is kept from")
func aLookBacksWholeCountsEveryKeptDayOutOfEveryDueDaySinceTheDayItIsKeptFrom() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!
    let februaryDueDays = [
        4, 7, 9, 11, 14, 16, 18, 21, 23, 25, 28,
    ].map { CalendarDate(year: 2026, month: 2, day: $0)! }

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    for day in februaryDueDays {
        try recordStore.add(Tick(gym, on: day)!)
    }

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.whole == "11/31")
}

@MainActor
@Test("a look-back's whole is the sum of the months it says")
func aLookBacksWholeIsTheSumOfTheMonthsItSays() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let sharpenKnives = Commitment(
        name: "Sharpen knives", schedule: .everyNDays(DayInterval(days: 40)!, from: keptFrom),
        keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 5, day: 31)!
    let kept = CalendarDate(year: 2026, month: 2, day: 10)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(sharpenKnives)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(sharpenKnives, on: kept)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: sharpenKnives)

    var sumKept = 0
    var sumDue = 0
    for line in lookBack!.lines {
        guard case .month(_, let fraction) = line, let fraction else { continue }
        let parts = fraction.split(separator: "/")
        sumKept += Int(parts[0])!
        sumDue += Int(parts[1])!
    }

    #expect(lookBack?.whole == "\(sumKept)/\(sumDue)")
    #expect(lookBack?.whole == "1/4")
}

@MainActor
@Test("a look-back that counts no due day at all says a whole of nothing out of nothing")
func aLookBackThatCountsNoDueDayAtAllSaysAWholeOfNothingOutOfNothing() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 4, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.whole == "0/0")
}

@MainActor
@Test("a look-back counts the era behind the one it was asked about")
func aLookBackCountsTheEraBehindTheOneItWasAskedAbout() throws {
    let places = freshRosterAndRecordPlaces()
    let olderKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let olderGym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: olderKeptFrom)!
    let newerGym = Commitment(
        name: "Gym", schedule: .weekdays([.tuesday, .thursday]), keptFrom: newerKeptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderGym)
    try rosterStore.supersede(olderGym, with: newerGym, keptUntil: boundary, under: nil)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerGym)

    let months = lookBack?.lines.compactMap { line -> String? in
        if case .month(let inWords, _) = line { return inWords }
        return nil
    }
    #expect(months == ["March 2026", "February 2026", "January 2026"])
    #expect(lookBack?.lines.contains(.month(inWords: "March 2026", fraction: "0/9")) == true)
}

@MainActor
@Test("a look-back says the newest era's rhythm and the earliest era's day kept from")
func aLookBackSaysTheNewestErasRhythmAndTheEarliestErasDayKeptFrom() throws {
    let places = freshRosterAndRecordPlaces()
    let olderKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let olderGym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: olderKeptFrom)!
    let newerGym = Commitment(
        name: "Gym", schedule: .weekdays([.tuesday, .thursday]), keptFrom: newerKeptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderGym)
    try rosterStore.supersede(olderGym, with: newerGym, keptUntil: boundary, under: nil)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerGym)

    #expect(lookBack?.rhythmInWords == "Tue, Thu")
    #expect(lookBack?.keptFromInWords == "1 January 2026")
}

@MainActor
@Test("a look-back chains every era behind the one it was asked about")
func aLookBackChainsEveryEraBehindTheOneItWasAskedAbout() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let firstKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let firstKeptUntil = CalendarDate(year: 2026, month: 1, day: 31)!
    let secondKeptFrom = CalendarDate(year: 2026, month: 2, day: 1)!
    let secondKeptUntil = CalendarDate(year: 2026, month: 2, day: 28)!
    let thirdKeptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let first = Commitment(name: "Gym", schedule: everyDay, keptFrom: firstKeptFrom)!
    let second = Commitment(name: "Gym", schedule: everyDay, keptFrom: secondKeptFrom)!
    let third = Commitment(name: "Gym", schedule: everyDay, keptFrom: thirdKeptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(first)
    try rosterStore.supersede(first, with: second, keptUntil: firstKeptUntil, under: nil)
    try rosterStore.supersede(second, with: third, keptUntil: secondKeptUntil, under: nil)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: third)

    let months = lookBack?.lines.compactMap { line -> String? in
        if case .month(let inWords, _) = line { return inWords }
        return nil
    }
    #expect(lookBack?.keptFromInWords == "1 January 2026")
    #expect(months == ["March 2026", "February 2026", "January 2026"])
}

@MainActor
@Test("a removed commitment of another name or another kind is not an earlier era")
func aRemovedCommitmentOfAnotherNameOrAnotherKindIsNotAnEarlierEra() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gymKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let earlierKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: everyDay, keptFrom: gymKeptFrom)!
    let running = Commitment(name: "Running", schedule: everyDay, keptFrom: earlierKeptFrom)!
    let gymNumber = Commitment(
        name: "Gym", schedule: everyDay, keptFrom: earlierKeptFrom, kind: .number(range: nil))!
    let today = CalendarDate(year: 2026, month: 3, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.add(running)
    try rosterStore.remove(running, keptUntil: boundary)
    try rosterStore.add(gymNumber)
    try rosterStore.remove(gymNumber, keptUntil: boundary)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.keptFromInWords == "4 March 2026")
    #expect(lookBack?.lines.count == 1)
    #expect(
        lookBack?.lines.contains { line in
            if case .month(let inWords, _) = line { return inWords == "March 2026" }
            return false
        } == true)
}

@MainActor
@Test("a removed commitment kept until any day but the day before is not an earlier era")
func aRemovedCommitmentKeptUntilAnyDayButTheDayBeforeIsNotAnEarlierEra() throws {
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gymKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let earlierKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: everyDay, keptFrom: gymKeptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 31)!

    // Kept until two days before — one day too early.
    let tooEarlyPlaces = freshRosterAndRecordPlaces()
    let tooEarlyOld = Commitment(name: "Gym", schedule: everyDay, keptFrom: earlierKeptFrom)!
    let tooEarly = CalendarDate(year: 2026, month: 3, day: 2)!
    let tooEarlyRosterStore = try RosterStore(at: tooEarlyPlaces.roster)
    try tooEarlyRosterStore.add(gym)
    try tooEarlyRosterStore.add(tooEarlyOld)
    try tooEarlyRosterStore.remove(tooEarlyOld, keptUntil: tooEarly)
    _ = try RecordStore(at: tooEarlyPlaces.record)
    let tooEarlyScreen = CommitmentsScreen(
        asOf: today, keepingRosterAt: tooEarlyPlaces.roster,
        keepingRecordAt: tooEarlyPlaces.record)
    let tooEarlyLookBack = tooEarlyScreen.lookBack(at: gym)

    #expect(tooEarlyLookBack?.keptFromInWords == "4 March 2026")
    #expect(tooEarlyLookBack?.lines.count == 1)

    // Kept until the same day gym is kept from — one day too late.
    let tooLatePlaces = freshRosterAndRecordPlaces()
    let tooLateOld = Commitment(name: "Gym", schedule: everyDay, keptFrom: earlierKeptFrom)!
    let tooLate = CalendarDate(year: 2026, month: 3, day: 4)!
    let tooLateRosterStore = try RosterStore(at: tooLatePlaces.roster)
    try tooLateRosterStore.add(gym)
    try tooLateRosterStore.add(tooLateOld)
    try tooLateRosterStore.remove(tooLateOld, keptUntil: tooLate)
    _ = try RecordStore(at: tooLatePlaces.record)
    let tooLateScreen = CommitmentsScreen(
        asOf: today, keepingRosterAt: tooLatePlaces.roster, keepingRecordAt: tooLatePlaces.record)
    let tooLateLookBack = tooLateScreen.lookBack(at: gym)

    #expect(tooLateLookBack?.keptFromInWords == "4 March 2026")
    #expect(tooLateLookBack?.lines.count == 1)
}

@MainActor
@Test("a look-back takes the nearest of two removed commitments that both answer")
func aLookBackTakesTheNearestOfTwoRemovedCommitmentsThatBothAnswer() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gymKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let nearKeptFrom = CalendarDate(year: 2026, month: 2, day: 1)!
    let farKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: everyDay, keptFrom: gymKeptFrom)!
    let nearOld = Commitment(name: "Gym", schedule: everyDay, keptFrom: nearKeptFrom)!
    let farOld = Commitment(name: "Gym", schedule: everyDay, keptFrom: farKeptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.add(nearOld)
    try rosterStore.remove(nearOld, keptUntil: boundary)
    try rosterStore.add(farOld)
    try rosterStore.remove(farOld, keptUntil: boundary)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    let months = lookBack?.lines.compactMap { line -> String? in
        if case .month(let inWords, _) = line { return inWords }
        return nil
    }
    #expect(lookBack?.keptFromInWords == "1 February 2026")
    #expect(months == ["March 2026", "February 2026"])
}

@MainActor
@Test("an era the roster has taken up again is kept rather than removed and ends a chain")
func anEraTheRosterHasTakenUpAgainIsKeptRatherThanRemovedAndEndsAChain() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gymKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let oldKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let stoppedKeptFrom = CalendarDate(year: 2025, month: 12, day: 1)!
    let gym = Commitment(name: "Gym", schedule: everyDay, keptFrom: gymKeptFrom)!
    let oldGym = Commitment(name: "Gym", schedule: everyDay, keptFrom: oldKeptFrom)!
    // Stopped, not removed, of the same name and kind, kept until the day the chain would ask
    // for — the state `entry.isRemoved` alone tells apart from a removed era: it answers the
    // guard's `keptUntil` and `name`/`kind` clauses but must fail on `isRemoved`.
    let stoppedGym = Commitment(name: "Gym", schedule: everyDay, keptFrom: stoppedKeptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.add(stoppedGym)
    try rosterStore.retire(stoppedGym, keptUntil: boundary)
    try rosterStore.add(oldGym)
    try rosterStore.remove(oldGym, keptUntil: boundary)
    try rosterStore.add(oldGym)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.keptFromInWords == "4 March 2026")
    #expect(lookBack?.lines.count == 1)
    #expect(
        lookBack?.lines.contains { line in
            if case .month(let inWords, _) = line { return inWords == "March 2026" }
            return false
        } == true)
}

@MainActor
@Test("a look-back says where the rhythm changed, above the month the newer era is kept from")
func aLookBackSaysWhereTheRhythmChangedAboveTheMonthTheNewerEraIsKeptFrom() throws {
    let places = freshRosterAndRecordPlaces()
    let olderKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let olderGym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: olderKeptFrom)!
    let newerGym = Commitment(
        name: "Gym", schedule: .weekdays([.tuesday, .thursday]), keptFrom: newerKeptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderGym)
    try rosterStore.supersede(olderGym, with: newerGym, keptUntil: boundary, under: nil)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerGym)

    let lineKinds: [String] = lookBack!.lines.map {
        switch $0 {
        case .month(let inWords, _): return "month:\(inWords)"
        case .rhythmChanged(let inWords, let from): return "changed:\(inWords):\(from)"
        }
    }
    #expect(
        lineKinds == [
            "changed:Tue, Thu:4 March 2026", "month:March 2026", "month:February 2026",
            "month:January 2026",
        ])
}

@MainActor
@Test("a look-back of one era says no line where the rhythm changed")
func aLookBackOfOneEraSaysNoLineWhereTheRhythmChanged() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(
        lookBack!.lines.allSatisfy {
            if case .month = $0 { return true }
            return false
        })
}

@MainActor
@Test("a look-back of three eras says one line where the rhythm changed for each boundary")
func aLookBackOfThreeErasSaysOneLineWhereTheRhythmChangedForEachBoundary() throws {
    let places = freshRosterAndRecordPlaces()
    let firstKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let firstKeptUntil = CalendarDate(year: 2026, month: 1, day: 31)!
    let secondKeptFrom = CalendarDate(year: 2026, month: 2, day: 1)!
    let secondKeptUntil = CalendarDate(year: 2026, month: 2, day: 28)!
    let thirdKeptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let first = Commitment(name: "Gym", schedule: .weekdays([.monday]), keptFrom: firstKeptFrom)!
    let second = Commitment(name: "Gym", schedule: .weekdays([.tuesday]), keptFrom: secondKeptFrom)!
    let third = Commitment(
        name: "Gym", schedule: .weekdays([.wednesday]), keptFrom: thirdKeptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(first)
    try rosterStore.supersede(first, with: second, keptUntil: firstKeptUntil, under: nil)
    try rosterStore.supersede(second, with: third, keptUntil: secondKeptUntil, under: nil)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: third)

    let changedLines = lookBack!.lines.compactMap { line -> (String, String)? in
        if case .rhythmChanged(let inWords, let from) = line { return (inWords, from) }
        return nil
    }
    #expect(changedLines.count == 2)
    #expect(changedLines[0] == ("Wed", "1 March 2026"))
    #expect(changedLines[1] == ("Tue", "1 February 2026"))
}

// Not a scenario in the delta: scenario 7.3's own three eras start in three different months, so
// nothing in that fixture reaches two boundaries landing inside one calendar month — this reaches
// `LookBack.swift`'s `changedLinesFor` directly. G7 finding 1 on #272.
@MainActor
@Test("a look-back says two lines where the rhythm changed inside the same month, newest first")
func aLookBackSaysTwoLinesWhereTheRhythmChangedInsideTheSameMonthNewestFirst() throws {
    let places = freshRosterAndRecordPlaces()
    let firstKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let firstKeptUntil = CalendarDate(year: 2026, month: 3, day: 5)!
    let secondKeptFrom = CalendarDate(year: 2026, month: 3, day: 6)!
    let secondKeptUntil = CalendarDate(year: 2026, month: 3, day: 10)!
    let thirdKeptFrom = CalendarDate(year: 2026, month: 3, day: 11)!
    let first = Commitment(name: "Gym", schedule: .weekdays([.monday]), keptFrom: firstKeptFrom)!
    let second = Commitment(name: "Gym", schedule: .weekdays([.tuesday]), keptFrom: secondKeptFrom)!
    let third = Commitment(
        name: "Gym", schedule: .weekdays([.wednesday]), keptFrom: thirdKeptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(first)
    try rosterStore.supersede(first, with: second, keptUntil: firstKeptUntil, under: nil)
    try rosterStore.supersede(second, with: third, keptUntil: secondKeptUntil, under: nil)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: third)

    let changedLines = lookBack!.lines.compactMap { line -> (String, String)? in
        if case .rhythmChanged(let inWords, let from) = line { return (inWords, from) }
        return nil
    }
    #expect(changedLines.count == 2)
    #expect(changedLines[0] == ("Wed", "11 March 2026"))
    #expect(changedLines[1] == ("Tue", "6 March 2026"))
}

@MainActor
@Test("a look-back says where an interval commitment's count began again")
func aLookBackSaysWhereAnIntervalCommitmentsCountBeganAgain() throws {
    let places = freshRosterAndRecordPlaces()
    let oldKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let oldKeptUntil = CalendarDate(year: 2026, month: 3, day: 9)!
    let newKeptFrom = CalendarDate(year: 2026, month: 3, day: 10)!
    let old = Commitment(
        name: "Sharpen knives", schedule: .everyNDays(DayInterval(days: 5)!, from: oldKeptFrom),
        keptFrom: oldKeptFrom)!
    let new = Commitment(
        name: "Sharpen knives", schedule: .everyNDays(DayInterval(days: 5)!, from: newKeptFrom),
        keptFrom: newKeptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(old)
    try rosterStore.supersede(old, with: new, keptUntil: oldKeptUntil, under: nil)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: new)

    let changedLines = lookBack!.lines.compactMap { line -> (String, String)? in
        if case .rhythmChanged(let inWords, let from) = line { return (inWords, from) }
        return nil
    }
    #expect(changedLines.count == 1)
    #expect(changedLines[0] == ("Every 5 days", "10 March 2026"))
    let months = lookBack!.lines.compactMap { line -> String? in
        if case .month(let inWords, _) = line { return inWords }
        return nil
    }
    #expect(months.first == "March 2026")
}

@MainActor
@Test("a look-back at a commitment whose days take a number, a note or a total says no line and no whole")
func aLookBackAtACommitmentWhoseDaysTakeANumberANoteOrATotalSaysNoLineAndNoWhole() throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    let numberPlaces = freshRosterAndRecordPlaces()
    let weight = Commitment(
        name: "Weight", schedule: everyDay, keptFrom: keptFrom, kind: .number(range: nil))!
    let numberRosterStore = try RosterStore(at: numberPlaces.roster)
    try numberRosterStore.add(weight)
    _ = try RecordStore(at: numberPlaces.record)
    let numberScreen = CommitmentsScreen(
        asOf: today, keepingRosterAt: numberPlaces.roster, keepingRecordAt: numberPlaces.record)
    let numberLookBack = numberScreen.lookBack(at: weight)

    #expect(numberLookBack?.name == "Weight")
    #expect(numberLookBack?.rhythmInWords == "Every day")
    #expect(numberLookBack?.keptFromInWords == "1 January 2026")
    #expect(numberLookBack?.lines == [])
    #expect(numberLookBack?.whole == nil)

    let notePlaces = freshRosterAndRecordPlaces()
    let journal = Commitment(name: "Journal", schedule: everyDay, keptFrom: keptFrom, kind: .note)!
    let noteRosterStore = try RosterStore(at: notePlaces.roster)
    try noteRosterStore.add(journal)
    _ = try RecordStore(at: notePlaces.record)
    let noteScreen = CommitmentsScreen(
        asOf: today, keepingRosterAt: notePlaces.roster, keepingRecordAt: notePlaces.record)
    let noteLookBack = noteScreen.lookBack(at: journal)

    #expect(noteLookBack?.lines == [])
    #expect(noteLookBack?.whole == nil)

    let totalPlaces = freshRosterAndRecordPlaces()
    let saved = Commitment(
        name: "Saved", schedule: everyDay, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(100)!))!
    let totalRosterStore = try RosterStore(at: totalPlaces.roster)
    try totalRosterStore.add(saved)
    _ = try RecordStore(at: totalPlaces.record)
    let totalScreen = CommitmentsScreen(
        asOf: today, keepingRosterAt: totalPlaces.roster, keepingRecordAt: totalPlaces.record)
    let totalLookBack = totalScreen.lookBack(at: saved)

    #expect(totalLookBack?.lines == [])
    #expect(totalLookBack?.whole == nil)
}

@MainActor
@Test("a look-back at a weekly quota says its months with no fraction and no whole")
func aLookBackAtAWeeklyQuotaSaysItsMonthsWithNoFractionAndNoWhole() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(
        lookBack?.lines
            == [
                .month(inWords: "March 2026", fraction: nil),
                .month(inWords: "February 2026", fraction: nil),
                .month(inWords: "January 2026", fraction: nil),
            ])
    #expect(lookBack?.whole == nil)
}

@MainActor
@Test("a look-back says no fraction on a month a weekly-quota era counts a day of")
func aLookBackSaysNoFractionOnAMonthAWeeklyQuotaEraCountsADayOf() throws {
    let places = freshRosterAndRecordPlaces()
    let oldKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let newKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let old = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: oldKeptFrom)!
    let new = Commitment(
        name: "Gym", schedule: .weekdays([.tuesday, .thursday]), keptFrom: newKeptFrom)!
    let today = CalendarDate(year: 2026, month: 4, day: 30)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(old)
    try rosterStore.supersede(old, with: new, keptUntil: boundary, under: nil)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: new)

    #expect(lookBack?.lines.contains(.month(inWords: "March 2026", fraction: nil)) == true)
    #expect(lookBack?.lines.contains(.month(inWords: "February 2026", fraction: nil)) == true)
    #expect(lookBack?.lines.contains(.month(inWords: "January 2026", fraction: nil)) == true)
    #expect(
        lookBack?.lines.contains { line in
            if case .month(let inWords, let fraction) = line {
                return inWords == "April 2026" && fraction != nil
            }
            return false
        } == true)
    #expect(lookBack?.whole == nil)
}

@MainActor
@Test("a look-back says a month as that month's name and its year")
func aLookBackSaysAMonthAsThatMonthsNameAndItsYear() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(name: "Gym", schedule: everyDay, keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 12, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    let months = lookBack?.lines.compactMap { line -> String? in
        if case .month(let inWords, _) = line { return inWords }
        return nil
    }
    #expect(
        months == [
            "December 2026", "November 2026", "October 2026", "September 2026", "August 2026",
            "July 2026", "June 2026", "May 2026", "April 2026", "March 2026", "February 2026",
            "January 2026",
        ])
}

@MainActor
@Test("a look-back says a day as the day of the month, that month's name and the year")
func aLookBackSaysADayAsTheDayOfTheMonthThatMonthsNameAndTheYear() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let keptUntil = CalendarDate(year: 2026, month: 3, day: 9)!
    let gym = Commitment(name: "Gym", schedule: everyDay, keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.retire(gym, keptUntil: keptUntil)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.keptFromInWords == "1 January 2026")
    #expect(lookBack?.keptUntilInWords == "9 March 2026")
}
