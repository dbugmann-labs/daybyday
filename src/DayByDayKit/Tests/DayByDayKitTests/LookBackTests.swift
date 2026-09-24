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
    let today = CalendarDate(year: 2026, month: 3, day: 15)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.add(journaling)
    try rosterStore.delete(journaling)
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
@Test("a tick commitment's look-back says a month in a gap as nothing out of nothing and counts no tick a gap day holds")
func aTickCommitmentsLookBackSaysAMonthInAGapAsNothingOutOfNothingAndCountsNoTickAGapDayHolds()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let olderKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let olderKeptUntil = CalendarDate(year: 2026, month: 1, day: 31)!
    let newerKeptFrom = CalendarDate(year: 2026, month: 4, day: 1)!
    let schedule: Schedule = .weekdays([.monday, .wednesday, .saturday])
    let olderGym = Commitment(name: "Gym", schedule: schedule, keptFrom: olderKeptFrom)!
    let newerGym = Commitment(era: olderGym, schedule: schedule, keptFrom: newerKeptFrom, kind: .tick)!
    let gapTickDay = CalendarDate(year: 2026, month: 2, day: 4)!
    let today = CalendarDate(year: 2026, month: 4, day: 15)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderGym)
    try rosterStore.put(era: newerGym, on: olderGym, keptUntil: olderKeptUntil, under: nil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(olderGym, on: gapTickDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerGym)

    #expect(
        lookBack?.lines == [
            .month(inWords: "April 2026", fraction: "0/7"),
            .month(inWords: "March 2026", fraction: "0/0"),
            .month(inWords: "February 2026", fraction: "0/0"),
            .month(inWords: "January 2026", fraction: "0/13"),
        ])
    #expect(lookBack?.whole == "0/20")
}

@MainActor
@Test("a quota commitment's look-back says a week in a gap as nothing out of nothing")
func aQuotaCommitmentsLookBackSaysAWeekInAGapAsNothingOutOfNothing() throws {
    let places = freshRosterAndRecordPlaces()
    let olderKeptFrom = CalendarDate(year: 2026, month: 2, day: 23)!
    let olderKeptUntil = CalendarDate(year: 2026, month: 3, day: 1)!
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 16)!
    let quota: Schedule = .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!)
    let olderGym = Commitment(name: "Gym", schedule: quota, keptFrom: olderKeptFrom)!
    let newerGym = Commitment(era: olderGym, schedule: quota, keptFrom: newerKeptFrom, kind: .tick)!
    let today = CalendarDate(year: 2026, month: 3, day: 22)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderGym)
    try rosterStore.put(era: newerGym, on: olderGym, keptUntil: olderKeptUntil, under: nil)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerGym)

    #expect(
        lookBack?.lines == [
            .week(inWords: "16–22 Mar 2026", fraction: "0/3"),
            .week(inWords: "9–15 Mar 2026", fraction: "0/0"),
            .week(inWords: "2–8 Mar 2026", fraction: "0/0"),
            .week(inWords: "23 Feb – 1 Mar 2026", fraction: "0/3"),
        ])
}

@MainActor
@Test("a gap between a weekly quota era and one that is not is said in the unit of the era before it")
func aGapBetweenAWeeklyQuotaEraAndOneThatIsNotIsSaidInTheUnitOfTheEraBeforeIt() throws {
    let places = freshRosterAndRecordPlaces()
    let olderKeptFrom = CalendarDate(year: 2026, month: 2, day: 23)!
    let olderKeptUntil = CalendarDate(year: 2026, month: 3, day: 1)!
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 16)!
    let olderGym = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: olderKeptFrom)!
    let newerGym = Commitment(
        era: olderGym, schedule: .weekdays([.monday, .wednesday, .saturday]),
        keptFrom: newerKeptFrom, kind: .tick)!
    let today = CalendarDate(year: 2026, month: 3, day: 22)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderGym)
    try rosterStore.put(era: newerGym, on: olderGym, keptUntil: olderKeptUntil, under: nil)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerGym)

    #expect(
        lookBack?.lines == [
            .month(inWords: "March 2026", fraction: "0/3"),
            .week(inWords: "9–15 Mar 2026", fraction: "0/0"),
            .week(inWords: "2–8 Mar 2026", fraction: "0/0"),
            .week(inWords: "23 Feb – 1 Mar 2026", fraction: "0/3"),
        ])
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
        guard case .month(_, let fraction) = line else { continue }
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
        era: olderGym, schedule: .weekdays([.tuesday, .thursday]), keptFrom: newerKeptFrom,
        kind: .tick)!
    let today = CalendarDate(year: 2026, month: 3, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderGym)
    try rosterStore.put(era: newerGym, on: olderGym, keptUntil: boundary, under: nil)
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
        era: olderGym, schedule: .weekdays([.tuesday, .thursday]), keptFrom: newerKeptFrom,
        kind: .tick)!
    let today = CalendarDate(year: 2026, month: 3, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderGym)
    try rosterStore.put(era: newerGym, on: olderGym, keptUntil: boundary, under: nil)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerGym)

    #expect(lookBack?.rhythmInWords == "Tue, Thu")
    #expect(lookBack?.keptFromInWords == "1 January 2026")
}

@MainActor
@Test("a look-back chains every era of the commitment it was asked about")
func aLookBackChainsEveryEraOfTheCommitmentItWasAskedAbout() throws {
    let places = freshRosterAndRecordPlaces()
    // Three different weekday sets, so the roster's mend — which joins eras alike in schedule
    // and kind — never joins these three into one: `openspec/changes/
    // collapse-a-same-day-rhythm-change/tasks.md` § 1.3.
    let firstSchedule: Schedule = .weekdays([.monday, .wednesday, .friday])
    let secondSchedule: Schedule = .weekdays([.tuesday, .thursday, .saturday])
    let thirdSchedule: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let firstKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let firstKeptUntil = CalendarDate(year: 2026, month: 1, day: 31)!
    let secondKeptFrom = CalendarDate(year: 2026, month: 2, day: 1)!
    let secondKeptUntil = CalendarDate(year: 2026, month: 2, day: 28)!
    let thirdKeptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let today = CalendarDate(year: 2026, month: 3, day: 31)!

    let first = Commitment(name: "Gym", schedule: firstSchedule, keptFrom: firstKeptFrom)!
    let second = Commitment(era: first, schedule: secondSchedule, keptFrom: secondKeptFrom, kind: .tick)!
    let third = Commitment(era: second, schedule: thirdSchedule, keptFrom: thirdKeptFrom, kind: .tick)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(first)
    try rosterStore.put(era: second, on: first, keptUntil: firstKeptUntil, under: nil)
    try rosterStore.put(era: third, on: second, keptUntil: secondKeptUntil, under: nil)
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
@Test("a look-back reaches no era of another commitment however alike it is")
func aLookBackReachesNoEraOfAnotherCommitmentHoweverAlikeItIs() throws {
    let places = freshRosterAndRecordPlaces()
    let allSevenDays =
        #"["monday","tuesday","wednesday","thursday","friday","saturday","sunday"]"#
    try FileManager.default.createDirectory(
        at: places.roster.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(
        """
        {
          "version": 4,
          "commitments": [
            {
              "commitment": {
                "name": "Gym",
                "keptFrom": { "year": 2026, "month": 3, "day": 4 },
                "schedule": { "weekdays": \(allSevenDays) }
              },
              "removed": false,
              "category": null
            },
            {
              "commitment": {
                "name": "Gym 2",
                "keptFrom": { "year": 2026, "month": 3, "day": 4 },
                "schedule": { "weekdays": \(allSevenDays) }
              },
              "removed": false,
              "category": null
            },
            {
              "commitment": {
                "name": "Gym 2",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": \(allSevenDays) }
              },
              "keptUntil": { "year": 2026, "month": 3, "day": 3 },
              "removed": true,
              "category": null
            },
            {
              "commitment": {
                "name": "Gym 2",
                "keptFrom": { "year": 2026, "month": 1, "day": 1 },
                "schedule": { "weekdays": \(allSevenDays) }
              },
              "keptUntil": { "year": 2026, "month": 3, "day": 3 },
              "removed": false,
              "category": null
            }
          ]
        }
        """.utf8
        ).write(to: places.roster)

    let today = CalendarDate(year: 2026, month: 3, day: 31)!
    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let gym = try #require(screen.kept.first { $0.name == "Gym" })
    let gymLookBack = screen.lookBack(at: gym)

    #expect(gymLookBack?.keptFromInWords == "4 March 2026")
    #expect(gymLookBack?.lines.count == 1)
    #expect(
        gymLookBack?.lines.contains { line in
            if case .month(let inWords, _) = line { return inWords == "March 2026" }
            return false
        } == true)

    let stoppedGym2 = try #require(screen.stopped.first { $0.name == "Gym 2" })
    let stoppedLookBack = screen.lookBack(at: stoppedGym2)

    #expect(stoppedLookBack?.keptFromInWords == "1 January 2026")
}

@MainActor
@Test("a look-back chains an era whose range or target differs behind the one it was asked about")
func aLookBackChainsAnEraWhoseRangeOrTargetDiffersBehindTheOneItWasAskedAbout() throws {
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let olderKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let today = CalendarDate(year: 2026, month: 3, day: 31)!

    let moodPlaces = freshRosterAndRecordPlaces()
    let olderMood = Commitment(
        name: "Mood", schedule: everyDay, keptFrom: olderKeptFrom,
        kind: .number(range: Commitment.Range(lowest: 1, highest: 10)))!
    let newerMood = Commitment(
        era: olderMood, schedule: everyDay, keptFrom: newerKeptFrom,
        kind: .number(range: Commitment.Range(lowest: 1, highest: 5)))!
    let moodRosterStore = try RosterStore(at: moodPlaces.roster)
    try moodRosterStore.add(olderMood)
    try moodRosterStore.put(era: newerMood, on: olderMood, keptUntil: boundary, under: nil)
    _ = try RecordStore(at: moodPlaces.record)
    let moodScreen = CommitmentsScreen(
        asOf: today, keepingRosterAt: moodPlaces.roster, keepingRecordAt: moodPlaces.record)

    #expect(moodScreen.lookBack(at: newerMood)?.keptFromInWords == "1 January 2026")

    let proteinPlaces = freshRosterAndRecordPlaces()
    let olderProtein = Commitment(
        name: "Protein", schedule: everyDay, keptFrom: olderKeptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let newerProtein = Commitment(
        era: olderProtein, schedule: everyDay, keptFrom: newerKeptFrom,
        kind: .total(target: Commitment.Target(100)!))!
    let proteinRosterStore = try RosterStore(at: proteinPlaces.roster)
    try proteinRosterStore.add(olderProtein)
    try proteinRosterStore.put(era: newerProtein, on: olderProtein, keptUntil: boundary, under: nil)
    _ = try RecordStore(at: proteinPlaces.record)
    let proteinScreen = CommitmentsScreen(
        asOf: today, keepingRosterAt: proteinPlaces.roster, keepingRecordAt: proteinPlaces.record)

    #expect(proteinScreen.lookBack(at: newerProtein)?.keptFromInWords == "1 January 2026")

    let weightPlaces = freshRosterAndRecordPlaces()
    let olderWeight = Commitment(
        name: "Weight", schedule: everyDay, keptFrom: olderKeptFrom,
        kind: .number(range: Commitment.Range(lowest: 40, highest: 150)))!
    let newerWeight = Commitment(
        era: olderWeight, schedule: everyDay, keptFrom: newerKeptFrom, kind: .number(range: nil))!
    let weightRosterStore = try RosterStore(at: weightPlaces.roster)
    try weightRosterStore.add(olderWeight)
    try weightRosterStore.put(era: newerWeight, on: olderWeight, keptUntil: boundary, under: nil)
    _ = try RecordStore(at: weightPlaces.record)
    let weightScreen = CommitmentsScreen(
        asOf: today, keepingRosterAt: weightPlaces.roster, keepingRecordAt: weightPlaces.record)

    #expect(weightScreen.lookBack(at: newerWeight)?.keptFromInWords == "1 January 2026")
}

// Not a scenario in the delta: scenario 6.7's own fixture only re-offers an era the chain search
// would otherwise find, which never reaches the `entry.isRemoved` clause of `chain`'s guard at
// all — this isolates the clause that tells a stopped era apart from a removed one. G7 finding
// 3, second pass, on #272.
@MainActor
@Test("a stopped era of the same name and kind, kept until the chain's target day, does not end it")
func aStoppedEraOfTheSameNameAndKindKeptUntilTheChainsTargetDayDoesNotEndIt() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gymKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let stoppedKeptFrom = CalendarDate(year: 2025, month: 12, day: 1)!
    let gym = Commitment(name: "Gym", schedule: everyDay, keptFrom: gymKeptFrom)!
    // Stopped, not removed, of the same name and kind, kept until the day the chain would ask
    // for — the state `entry.isRemoved` alone tells apart from a removed era: it answers the
    // guard's `keptUntil` and `name`/`kind` clauses but must fail on `isRemoved`.
    let stoppedGym = Commitment(name: "Gym", schedule: everyDay, keptFrom: stoppedKeptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.add(stoppedGym)
    try rosterStore.retire(stoppedGym, keptUntil: boundary)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.keptFromInWords == "4 March 2026")
    #expect(lookBack?.lines.count == 1)
}

@MainActor
@Test("a look-back says nothing between the lines either side of a boundary")
func aLookBackSaysNothingBetweenTheLinesEitherSideOfABoundary() throws {
    let places = freshRosterAndRecordPlaces()
    let olderKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let olderGym = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: olderKeptFrom)!
    let newerGym = Commitment(
        era: olderGym, schedule: .weekdays([.tuesday, .thursday]), keptFrom: newerKeptFrom,
        kind: .tick)!
    let today = CalendarDate(year: 2026, month: 3, day: 31)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderGym)
    try rosterStore.put(era: newerGym, on: olderGym, keptUntil: boundary, under: nil)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerGym)

    let lineKinds: [String] = lookBack!.lines.map {
        switch $0 {
        case .month(let inWords, _): return "month:\(inWords)"
        case .week(let inWords, _): return "week:\(inWords)"
        }
    }
    #expect(lineKinds == ["month:March 2026", "month:February 2026", "month:January 2026"])

    let mixedPlaces = freshRosterAndRecordPlaces()
    let mixedOldKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let mixedBoundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let mixedNewKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let mixedOld = Commitment(
        name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: mixedOldKeptFrom)!
    let mixedNew = Commitment(
        era: mixedOld, schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!),
        keptFrom: mixedNewKeptFrom, kind: .tick)!
    let mixedToday = CalendarDate(year: 2026, month: 3, day: 15)!

    let mixedRosterStore = try RosterStore(at: mixedPlaces.roster)
    try mixedRosterStore.add(mixedOld)
    try mixedRosterStore.put(era: mixedNew, on: mixedOld, keptUntil: mixedBoundary, under: nil)
    _ = try RecordStore(at: mixedPlaces.record)

    let mixedScreen = CommitmentsScreen(
        asOf: mixedToday, keepingRosterAt: mixedPlaces.roster, keepingRecordAt: mixedPlaces.record)
    let mixedLookBack = mixedScreen.lookBack(at: mixedNew)

    let mixedLineKinds: [String] = mixedLookBack!.lines.map {
        switch $0 {
        case .month(let inWords, _): return "month:\(inWords)"
        case .week(let inWords, _): return "week:\(inWords)"
        }
    }
    #expect(
        mixedLineKinds == [
            "week:9–15 Mar 2026", "week:2–8 Mar 2026",
            "month:March 2026", "month:February 2026", "month:January 2026",
        ])
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

@MainActor
@Test("a look-back says a week's kept days out of its quota")
func aLookBackSaysAWeeksKeptDaysOutOfItsQuota() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 2, day: 23)!
    let gym = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!
    let firstKept = CalendarDate(year: 2026, month: 3, day: 9)!
    let secondKept = CalendarDate(year: 2026, month: 3, day: 11)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: firstKept)!)
    try recordStore.add(Tick(gym, on: secondKept)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.lines.contains(.week(inWords: "9–15 Mar 2026", fraction: "2/3")) == true)
}

@MainActor
@Test("a look-back says its weeks newest first, and leaves none between out")
func aLookBackSaysItsWeeksNewestFirstAndLeavesNoneBetweenOut() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 2, day: 23)!
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
                .week(inWords: "9–15 Mar 2026", fraction: "0/3"),
                .week(inWords: "2–8 Mar 2026", fraction: "0/3"),
                .week(inWords: "23 Feb – 1 Mar 2026", fraction: "0/3"),
            ])
}

@MainActor
@Test("a look-back counts the week in progress against the whole quota")
func aLookBackCountsTheWeekInProgressAgainstTheWholeQuota() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 11)!
    let kept = CalendarDate(year: 2026, month: 3, day: 9)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: kept)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.lines.first == .week(inWords: "9–15 Mar 2026", fraction: "1/3"))

    // A tick on a day of the week in progress that is still to come — after `today`, within the
    // same week — does not count: the walk itself never reads past `today`, so the week still
    // owes "0/3", not "1/3", `WeekQuota.standing(monday:links:history:keptThrough:)`'s own
    // `keptThrough` and not the default that counts every day of the week regardless.
    let laterPlaces = freshRosterAndRecordPlaces()
    let laterTick = CalendarDate(year: 2026, month: 3, day: 13)!

    let laterRosterStore = try RosterStore(at: laterPlaces.roster)
    try laterRosterStore.add(gym)
    let laterRecordStore = try RecordStore(at: laterPlaces.record)
    try laterRecordStore.add(Tick(gym, on: laterTick)!)

    let laterScreen = CommitmentsScreen(
        asOf: today, keepingRosterAt: laterPlaces.roster, keepingRecordAt: laterPlaces.record)
    let laterLookBack = laterScreen.lookBack(at: gym)

    #expect(laterLookBack?.lines.first == .week(inWords: "9–15 Mar 2026", fraction: "0/3"))
}

@MainActor
@Test("a look-back counts the week a commitment is kept from against its part of the quota")
func aLookBackCountsTheWeekACommitmentIsKeptFromAgainstItsPartOfTheQuota() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!
    let kept = CalendarDate(year: 2026, month: 1, day: 2)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: kept)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.lines.last == .week(inWords: "29 Dec 2025 – 4 Jan 2026", fraction: "1/2"))
}

@MainActor
@Test("a look-back says a week kept past its quota as the days kept, uncapped")
func aLookBackSaysAWeekKeptPastItsQuotaAsTheDaysKeptUncapped() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 2, day: 23)!
    let gym = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!
    let keptDays = [9, 10, 11, 12].map { CalendarDate(year: 2026, month: 3, day: $0)! }

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    for day in keptDays {
        try recordStore.add(Tick(gym, on: day)!)
    }

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.lines.contains(.week(inWords: "9–15 Mar 2026", fraction: "4/3")) == true)
}

@MainActor
@Test("a part week owes its quota times the days held over seven, rounded to the nearest whole number")
func aPartWeekOwesItsQuotaTimesTheDaysHeldOverSevenRoundedToTheNearestWholeNumber() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 3)!
    let gym = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 1)!), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 8)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.lines == [.week(inWords: "2–8 Mar 2026", fraction: "0/1")])

    let saturdayPlaces = freshRosterAndRecordPlaces()
    let saturdayKeptFrom = CalendarDate(year: 2026, month: 3, day: 7)!
    let saturdayGym = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!),
        keptFrom: saturdayKeptFrom)!
    let saturdayRosterStore = try RosterStore(at: saturdayPlaces.roster)
    try saturdayRosterStore.add(saturdayGym)
    _ = try RecordStore(at: saturdayPlaces.record)
    let saturdayScreen = CommitmentsScreen(
        asOf: today, keepingRosterAt: saturdayPlaces.roster,
        keepingRecordAt: saturdayPlaces.record)
    let saturdayLookBack = saturdayScreen.lookBack(at: saturdayGym)

    #expect(saturdayLookBack?.lines == [.week(inWords: "2–8 Mar 2026", fraction: "0/1")])

    let sundayPlaces = freshRosterAndRecordPlaces()
    let sundayKeptFrom = CalendarDate(year: 2026, month: 3, day: 8)!
    let sundayGym = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: sundayKeptFrom)!
    let sundayRosterStore = try RosterStore(at: sundayPlaces.roster)
    try sundayRosterStore.add(sundayGym)
    _ = try RecordStore(at: sundayPlaces.record)
    let sundayScreen = CommitmentsScreen(
        asOf: today, keepingRosterAt: sundayPlaces.roster, keepingRecordAt: sundayPlaces.record)
    let sundayLookBack = sundayScreen.lookBack(at: sundayGym)

    #expect(sundayLookBack?.lines == [.week(inWords: "2–8 Mar 2026", fraction: "0/0")])
}

@MainActor
@Test("a part week that owes nothing is still said, and a day kept in it counts")
func aPartWeekThatOwesNothingIsStillSaidAndADayKeptInItCounts() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 8)!
    let gym = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 8)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: keptFrom)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.lines == [.week(inWords: "2–8 Mar 2026", fraction: "1/0")])
    #expect(lookBack?.whole == "1/0")
}

@MainActor
@Test("a stopped quota commitment's look-back counts its last week through the day it was kept until")
func aStoppedQuotaCommitmentsLookBackCountsItsLastWeekThroughTheDayItWasKeptUntil() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let keptUntil = CalendarDate(year: 2026, month: 3, day: 3)!
    let gym = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!
    let keptOn2March = CalendarDate(year: 2026, month: 3, day: 2)!
    let keptOn4March = CalendarDate(year: 2026, month: 3, day: 4)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    try rosterStore.retire(gym, keptUntil: keptUntil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(gym, on: keptOn2March)!)
    try recordStore.add(Tick(gym, on: keptOn4March)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.lines.first == .week(inWords: "2–8 Mar 2026", fraction: "1/1"))
}

@MainActor
@Test("a week a gap cuts owes the days its eras hold, days to come included, and counts a day kept before the stop")
func aWeekAGapCutsOwesTheDaysItsErasHoldDaysToComeIncludedAndCountsADayKeptBeforeTheStop() throws {
    let places = freshRosterAndRecordPlaces()
    let olderKeptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let olderKeptUntil = CalendarDate(year: 2026, month: 3, day: 2)!
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 5)!
    let quota: Schedule = .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!)
    let olderGym = Commitment(name: "Gym", schedule: quota, keptFrom: olderKeptFrom)!
    let newerGym = Commitment(era: olderGym, schedule: quota, keptFrom: newerKeptFrom, kind: .tick)!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!
    let secondMarch = CalendarDate(year: 2026, month: 3, day: 2)!
    let fifthMarch = CalendarDate(year: 2026, month: 3, day: 5)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderGym)
    try rosterStore.put(era: newerGym, on: olderGym, keptUntil: olderKeptUntil, under: nil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(olderGym, on: secondMarch)!)
    try recordStore.add(Tick(newerGym, on: fifthMarch)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerGym)

    #expect(lookBack?.lines.first == .week(inWords: "2–8 Mar 2026", fraction: "2/2"))
}

@MainActor
@Test("a look-back says a weekday era's months and a quota era's weeks, each in its own unit")
func aLookBackSaysAWeekdayErasMonthsAndAQuotaErasWeeksEachInItsOwnUnit() throws {
    let places = freshRosterAndRecordPlaces()
    let oldKeptFrom = CalendarDate(year: 2026, month: 2, day: 23)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let newKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let old = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: oldKeptFrom)!
    let new = Commitment(
        era: old, schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: newKeptFrom,
        kind: .tick)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!
    let oldKeptDays = [23, 25, 27].map { CalendarDate(year: 2026, month: 2, day: $0)! }
        + [CalendarDate(year: 2026, month: 3, day: 2)!]
    let newKeptDays = [4, 7, 9].map { CalendarDate(year: 2026, month: 3, day: $0)! }

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(old)
    try rosterStore.put(era: new, on: old, keptUntil: boundary, under: nil)
    let recordStore = try RecordStore(at: places.record)
    for day in oldKeptDays {
        try recordStore.add(Tick(old, on: day)!)
    }
    for day in newKeptDays {
        try recordStore.add(Tick(new, on: day)!)
    }

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: new)

    #expect(
        lookBack?.lines
            == [
                .month(inWords: "March 2026", fraction: "3/5"),
                .week(inWords: "2–8 Mar 2026", fraction: "1/1"),
                .week(inWords: "23 Feb – 1 Mar 2026", fraction: "3/3"),
            ])
}

@MainActor
@Test("a week two quota eras share says its kept days out of both eras' parts of their quotas")
func aWeekTwoQuotaErasShareSaysItsKeptDaysOutOfBothErasPartsOfTheirQuotas() throws {
    let places = freshRosterAndRecordPlaces()
    let oldKeptFrom = CalendarDate(year: 2026, month: 2, day: 23)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let newKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let old = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: oldKeptFrom)!
    let new = Commitment(
        era: old, schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 5)!), keptFrom: newKeptFrom,
        kind: .tick)!
    let today = CalendarDate(year: 2026, month: 3, day: 8)!
    let keptOn2March = CalendarDate(year: 2026, month: 3, day: 2)!
    let keptOn5March = CalendarDate(year: 2026, month: 3, day: 5)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(old)
    try rosterStore.put(era: new, on: old, keptUntil: boundary, under: nil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Tick(old, on: keptOn2March)!)
    try recordStore.add(Tick(new, on: keptOn5March)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: new)

    let weekOf2March = lookBack!.lines.filter { line in
        if case .week(let inWords, _) = line { return inWords == "2–8 Mar 2026" }
        return false
    }
    #expect(weekOf2March == [.week(inWords: "2–8 Mar 2026", fraction: "2/4")])
    #expect(lookBack?.lines.contains(.week(inWords: "23 Feb – 1 Mar 2026", fraction: "0/3")) == true)
}

@MainActor
@Test("a look-back's whole is the sum of the weeks it says")
func aLookBacksWholeIsTheSumOfTheWeeksItSays() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 2, day: 23)!
    let gym = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!
    let keptDays = [
        CalendarDate(year: 2026, month: 2, day: 23)!,
        CalendarDate(year: 2026, month: 2, day: 25)!,
        CalendarDate(year: 2026, month: 3, day: 2)!,
    ]

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    let recordStore = try RecordStore(at: places.record)
    for day in keptDays {
        try recordStore.add(Tick(gym, on: day)!)
    }

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.whole == "3/9")
}

@MainActor
@Test("a mixed chain's whole sums its months' due days and its weeks' quotas alike")
func aMixedChainsWholeSumsItsMonthsDueDaysAndItsWeeksQuotasAlike() throws {
    let places = freshRosterAndRecordPlaces()
    let oldKeptFrom = CalendarDate(year: 2026, month: 2, day: 23)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let newKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let old = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: oldKeptFrom)!
    let new = Commitment(
        era: old, schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: newKeptFrom,
        kind: .tick)!
    let today = CalendarDate(year: 2026, month: 3, day: 15)!
    let oldKeptDays = [23, 25, 27].map { CalendarDate(year: 2026, month: 2, day: $0)! }
        + [CalendarDate(year: 2026, month: 3, day: 2)!]
    let newKeptDays = [4, 7, 9].map { CalendarDate(year: 2026, month: 3, day: $0)! }

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(old)
    try rosterStore.put(era: new, on: old, keptUntil: boundary, under: nil)
    let recordStore = try RecordStore(at: places.record)
    for day in oldKeptDays {
        try recordStore.add(Tick(old, on: day)!)
    }
    for day in newKeptDays {
        try recordStore.add(Tick(new, on: day)!)
    }

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: new)

    #expect(lookBack?.whole == "7/9")
}

@MainActor
@Test("a look-back says a week inside one month as its two days, that month's short name and the year")
func aLookBackSaysAWeekInsideOneMonthAsItsTwoDaysThatMonthsShortNameAndTheYear() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 9, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 9, day: 13)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(
        lookBack?.lines.first
            == .week(inWords: "7–13 Sep 2026", fraction: "0/3"))
}

@MainActor
@Test("a look-back says a week across two months as each end's day and short month, and the year once")
func aLookBackSaysAWeekAcrossTwoMonthsAsEachEndsDayAndShortMonthAndTheYearOnce() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 9, day: 1)!
    let gym = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 9, day: 13)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(
        lookBack?.lines.last
            == .week(inWords: "31 Aug – 6 Sep 2026", fraction: "0/3"))
}

@MainActor
@Test("a look-back says a week across two years as each end's day, short month and year")
func aLookBackSaysAWeekAcrossTwoYearsAsEachEndsDayShortMonthAndYear() throws {
    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2025, month: 12, day: 29)!
    let gym = Commitment(
        name: "Gym", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!), keptFrom: keptFrom)!
    let today = CalendarDate(year: 2026, month: 1, day: 4)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(gym)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: gym)

    #expect(lookBack?.lines == [.week(inWords: "29 Dec 2025 – 4 Jan 2026", fraction: "0/3")])
}

@MainActor
@Test("a number commitment's look-back says a point for each day that holds a number")
func aNumberCommitmentsLookBackSaysAPointForEachDayThatHoldsANumber() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let weight = Commitment(
        name: "Weight", schedule: everyDay, keptFrom: keptFrom, kind: .number(range: nil))!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!
    let firstDay = CalendarDate(year: 2026, month: 3, day: 1)!
    let thirdDay = CalendarDate(year: 2026, month: 3, day: 3)!
    let fourthDay = CalendarDate(year: 2026, month: 3, day: 4)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(weight)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Number(72.5, for: weight, on: firstDay)!)
    try recordStore.add(Number(71, for: weight, on: thirdDay)!)
    try recordStore.add(Number(70.8, for: weight, on: fourthDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: weight)

    #expect(
        lookBack?.graph?.points == [
            LookBack.Graph.Point(day: 0, value: 72.5, inWords: "72.5", isKept: nil),
            LookBack.Graph.Point(day: 2, value: 71, inWords: "71", isKept: nil),
            LookBack.Graph.Point(day: 3, value: 70.8, inWords: "70.8", isKept: nil),
        ])
    #expect(lookBack?.lines == [])
    #expect(lookBack?.whole == nil)
}

@MainActor
@Test("a number commitment's look-back says no graph where no day holds a number")
func aNumberCommitmentsLookBackSaysNoGraphWhereNoDayHoldsANumber() throws {
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let today = CalendarDate(year: 2026, month: 3, day: 5)!

    let places = freshRosterAndRecordPlaces()
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let weight = Commitment(
        name: "Weight", schedule: everyDay, keptFrom: keptFrom, kind: .number(range: nil))!
    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(weight)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: weight)

    #expect(lookBack?.graph == nil)
    #expect(lookBack?.lines == [])
    #expect(lookBack?.whole == nil)
    #expect(lookBack?.name == "Weight")
    #expect(lookBack?.rhythmInWords == "Every day")
    #expect(lookBack?.keptFromInWords == "1 March 2026")

    let laterPlaces = freshRosterAndRecordPlaces()
    let laterKeptFrom = CalendarDate(year: 2026, month: 4, day: 1)!
    let laterWeight = Commitment(
        name: "Weight", schedule: everyDay, keptFrom: laterKeptFrom, kind: .number(range: nil))!
    let laterRosterStore = try RosterStore(at: laterPlaces.roster)
    try laterRosterStore.add(laterWeight)
    _ = try RecordStore(at: laterPlaces.record)

    let laterScreen = CommitmentsScreen(
        asOf: today, keepingRosterAt: laterPlaces.roster, keepingRecordAt: laterPlaces.record)
    #expect(laterScreen.lookBack(at: laterWeight)?.graph == nil)
}

@MainActor
@Test("a number commitment's look-back says one point where one day holds a number")
func aNumberCommitmentsLookBackSaysOnePointWhereOneDayHoldsANumber() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let weight = Commitment(
        name: "Weight", schedule: everyDay, keptFrom: keptFrom, kind: .number(range: nil))!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!
    let thirdDay = CalendarDate(year: 2026, month: 3, day: 3)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(weight)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Number(72.5, for: weight, on: thirdDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: weight)

    #expect(
        lookBack?.graph?.points == [
            LookBack.Graph.Point(day: 2, value: 72.5, inWords: "72.5", isKept: nil)
        ])
}

@MainActor
@Test("a number commitment's look-back says the number the era holding a day kept")
func aNumberCommitmentsLookBackSaysTheNumberTheEraHoldingADayKept() throws {
    let places = freshRosterAndRecordPlaces()
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let olderKeptFrom = CalendarDate(year: 2026, month: 3, day: 2)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let olderWeight = Commitment(
        name: "Weight", schedule: .weekdays([.monday]), keptFrom: olderKeptFrom,
        kind: .number(range: nil))!
    let newerWeight = Commitment(
        era: olderWeight,
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: newerKeptFrom, kind: .number(range: nil))!
    let today = CalendarDate(year: 2026, month: 3, day: 4)!
    let olderDay = CalendarDate(year: 2026, month: 3, day: 2)!
    let newerDay = CalendarDate(year: 2026, month: 3, day: 4)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderWeight)
    try rosterStore.put(era: newerWeight, on: olderWeight, keptUntil: boundary, under: nil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Number(80, for: olderWeight, on: olderDay)!)
    try recordStore.add(Number(70, for: newerWeight, on: newerDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerWeight)

    #expect(
        lookBack?.graph?.points == [
            LookBack.Graph.Point(day: 0, value: 80, inWords: "80", isKept: nil),
            LookBack.Graph.Point(day: 2, value: 70, inWords: "70", isKept: nil),
        ])
}

@MainActor
@Test("a number commitment's graph says a day for every day from the day it is kept from through today")
func aNumberCommitmentsGraphSaysADayForEveryDayFromTheDayItIsKeptFromThroughToday() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let weight = Commitment(
        name: "Weight", schedule: everyDay, keptFrom: keptFrom, kind: .number(range: nil))!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!
    let firstDay = CalendarDate(year: 2026, month: 3, day: 1)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(weight)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Number(72.5, for: weight, on: firstDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: weight)

    #expect(lookBack?.graph?.days.count == 5)
    #expect(lookBack?.graph?.days.first == "1 March 2026")
    #expect(lookBack?.graph?.days.last == "5 March 2026")
    #expect(lookBack?.graph?.points.first?.day == 0)
}

@MainActor
@Test("a number commitment's graph says a month for each calendar month its days run through")
func aNumberCommitmentsGraphSaysAMonthForEachCalendarMonthItsDaysRunThrough() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 2, day: 20)!
    let weight = Commitment(
        name: "Weight", schedule: everyDay, keptFrom: keptFrom, kind: .number(range: nil))!
    let today = CalendarDate(year: 2026, month: 3, day: 3)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(weight)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Number(72.5, for: weight, on: keptFrom)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: weight)

    #expect(
        lookBack?.graph?.months == [
            LookBack.Graph.Month(inWords: "February 2026", day: 0),
            LookBack.Graph.Month(inWords: "March 2026", day: 9),
        ])
}

@MainActor
@Test("a stopped number commitment's graph runs through the day it was kept until")
func aStoppedNumberCommitmentsGraphRunsThroughTheDayItWasKeptUntil() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 2, day: 25)!
    let keptUntil = CalendarDate(year: 2026, month: 2, day: 28)!
    let weight = Commitment(
        name: "Weight", schedule: everyDay, keptFrom: keptFrom, kind: .number(range: nil))!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(weight)
    try rosterStore.retire(weight, keptUntil: keptUntil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Number(72.5, for: weight, on: keptFrom)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: weight)

    #expect(lookBack?.graph?.days.count == 4)
    #expect(lookBack?.graph?.days.first == "25 February 2026")
    #expect(lookBack?.graph?.days.last == "28 February 2026")
}

@MainActor
@Test("a number commitment's graph says no point for a number kept after the day it was kept until")
func aNumberCommitmentsGraphSaysNoPointForANumberKeptAfterTheDayItWasKeptUntil() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 2, day: 25)!
    let keptUntil = CalendarDate(year: 2026, month: 2, day: 28)!
    let weight = Commitment(
        name: "Weight", schedule: everyDay, keptFrom: keptFrom, kind: .number(range: nil))!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!
    let dayWithinSpan = CalendarDate(year: 2026, month: 2, day: 27)!
    let dayAfterKeptUntil = CalendarDate(year: 2026, month: 3, day: 4)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(weight)
    try rosterStore.retire(weight, keptUntil: keptUntil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Number(72.5, for: weight, on: dayWithinSpan)!)
    try recordStore.add(Number(71, for: weight, on: dayAfterKeptUntil)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: weight)

    #expect(
        lookBack?.graph?.points == [
            LookBack.Graph.Point(day: 2, value: 72.5, inWords: "72.5", isKept: nil)
        ])
}

@MainActor
@Test("a number commitment's graph runs between the range its newest era declares")
func aNumberCommitmentsGraphRunsBetweenTheRangeItsNewestEraDeclares() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let mood = Commitment(
        name: "Mood", schedule: everyDay, keptFrom: keptFrom,
        kind: .number(range: Commitment.Range(lowest: 1, highest: 10)))!
    let today = CalendarDate(year: 2026, month: 3, day: 2)!
    let secondDay = CalendarDate(year: 2026, month: 3, day: 2)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(mood)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Number(6, for: mood, on: keptFrom)!)
    try recordStore.add(Number(7, for: mood, on: secondDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: mood)

    #expect(lookBack?.graph?.lowest == 1)
    #expect(lookBack?.graph?.lowestInWords == "1")
    #expect(lookBack?.graph?.highest == 10)
    #expect(lookBack?.graph?.highestInWords == "10")
}

@MainActor
@Test("a number commitment's graph with no range runs between the values its points say")
func aNumberCommitmentsGraphWithNoRangeRunsBetweenTheValuesItsPointsSay() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let weight = Commitment(
        name: "Weight", schedule: everyDay, keptFrom: keptFrom, kind: .number(range: nil))!
    let today = CalendarDate(year: 2026, month: 3, day: 3)!
    let secondDay = CalendarDate(year: 2026, month: 3, day: 2)!
    let thirdDay = CalendarDate(year: 2026, month: 3, day: 3)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(weight)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Number(72.5, for: weight, on: keptFrom)!)
    try recordStore.add(Number(70.8, for: weight, on: secondDay)!)
    try recordStore.add(Number(71, for: weight, on: thirdDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: weight)

    #expect(lookBack?.graph?.lowestInWords == "70.8")
    #expect(lookBack?.graph?.highestInWords == "72.5")
}

@MainActor
@Test("a number commitment's graph with one point says that value as its lowest and its highest")
func aNumberCommitmentsGraphWithOnePointSaysThatValueAsItsLowestAndItsHighest() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let weight = Commitment(
        name: "Weight", schedule: everyDay, keptFrom: keptFrom, kind: .number(range: nil))!
    let today = CalendarDate(year: 2026, month: 3, day: 3)!
    let secondDay = CalendarDate(year: 2026, month: 3, day: 2)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(weight)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Number(72.5, for: weight, on: secondDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: weight)

    #expect(lookBack?.graph?.lowestInWords == "72.5")
    #expect(lookBack?.graph?.highestInWords == "72.5")
}

@MainActor
@Test("a number commitment's graph widens to hold a value outside its newest era's range")
func aNumberCommitmentsGraphWidensToHoldAValueOutsideItsNewestErasRange() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let olderKeptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let olderMood = Commitment(
        name: "Mood", schedule: everyDay, keptFrom: olderKeptFrom,
        kind: .number(range: Commitment.Range(lowest: 1, highest: 10)))!
    let newerMood = Commitment(
        era: olderMood, schedule: everyDay, keptFrom: newerKeptFrom,
        kind: .number(range: Commitment.Range(lowest: 1, highest: 5)))!
    let today = CalendarDate(year: 2026, month: 3, day: 4)!
    let olderDay = CalendarDate(year: 2026, month: 3, day: 2)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderMood)
    try rosterStore.put(era: newerMood, on: olderMood, keptUntil: boundary, under: nil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Number(8, for: olderMood, on: olderDay)!)
    try recordStore.add(Number(4, for: newerMood, on: newerKeptFrom)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerMood)

    #expect(lookBack?.graph?.lowestInWords == "1")
    #expect(lookBack?.graph?.highestInWords == "8")
}

@MainActor
@Test("a number commitment's graph says nothing where one era gives way to the next")
func aNumberCommitmentsGraphSaysNothingWhereOneEraGivesWayToTheNext() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let olderKeptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let olderWeight = Commitment(
        name: "Weight", schedule: everyDay, keptFrom: olderKeptFrom, kind: .number(range: nil))!
    let newerWeight = Commitment(
        era: olderWeight, schedule: .weekdays([.tuesday, .thursday]), keptFrom: newerKeptFrom,
        kind: .number(range: nil))!
    let today = CalendarDate(year: 2026, month: 3, day: 8)!
    let olderDay = CalendarDate(year: 2026, month: 3, day: 2)!
    let newerDay = CalendarDate(year: 2026, month: 3, day: 5)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderWeight)
    try rosterStore.put(era: newerWeight, on: olderWeight, keptUntil: boundary, under: nil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Number(72.5, for: olderWeight, on: olderDay)!)
    try recordStore.add(Number(71, for: newerWeight, on: newerDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerWeight)

    #expect(lookBack?.graph?.days.count == 8)
    #expect(lookBack?.graph?.days.first == "1 March 2026")
    #expect(lookBack?.graph?.days.last == "8 March 2026")
    #expect(lookBack?.graph?.months == [LookBack.Graph.Month(inWords: "March 2026", day: 0)])
    #expect(
        lookBack?.graph?.points == [
            LookBack.Graph.Point(day: 1, value: 72.5, inWords: "72.5", isKept: nil),
            LookBack.Graph.Point(day: 4, value: 71, inWords: "71", isKept: nil),
        ])
}

@MainActor
@Test("a number commitment's graph says the days of a gap and no number a gap day holds")
func aNumberCommitmentsGraphSaysTheDaysOfAGapAndNoNumberAGapDayHolds() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let olderKeptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let olderKeptUntil = CalendarDate(year: 2026, month: 3, day: 3)!
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 6)!
    let olderWeight = Commitment(
        name: "Weight", schedule: everyDay, keptFrom: olderKeptFrom, kind: .number(range: nil))!
    let newerWeight = Commitment(
        era: olderWeight, schedule: everyDay, keptFrom: newerKeptFrom, kind: .number(range: nil))!
    let today = CalendarDate(year: 2026, month: 3, day: 8)!
    let secondOfMarch = CalendarDate(year: 2026, month: 3, day: 2)!
    let gapDay = CalendarDate(year: 2026, month: 3, day: 4)!
    let seventhOfMarch = CalendarDate(year: 2026, month: 3, day: 7)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderWeight)
    try rosterStore.put(era: newerWeight, on: olderWeight, keptUntil: olderKeptUntil, under: nil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Number(72.5, for: olderWeight, on: secondOfMarch)!)
    try recordStore.add(Number(71, for: olderWeight, on: gapDay)!)
    try recordStore.add(Number(70, for: newerWeight, on: seventhOfMarch)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerWeight)

    #expect(lookBack?.graph?.days.count == 8)
    #expect(lookBack?.graph?.days.first == "1 March 2026")
    #expect(lookBack?.graph?.days.last == "8 March 2026")
    #expect(
        lookBack?.graph?.points == [
            LookBack.Graph.Point(day: 1, value: 72.5, inWords: "72.5", isKept: nil),
            LookBack.Graph.Point(day: 6, value: 70, inWords: "70", isKept: nil),
        ])
}

@MainActor
@Test("a look-back says a number with a fraction as its digits either side of a full stop")
func aLookBackSaysANumberWithAFractionAsItsDigitsEitherSideOfAFullStop() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let weight = Commitment(
        name: "Weight", schedule: everyDay, keptFrom: keptFrom, kind: .number(range: nil))!
    let today = CalendarDate(year: 2026, month: 3, day: 2)!
    let secondDay = CalendarDate(year: 2026, month: 3, day: 2)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(weight)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Number(72.5, for: weight, on: keptFrom)!)
    try recordStore.add(Number(0.08, for: weight, on: secondDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: weight)

    #expect(lookBack?.graph?.points.map(\.inWords) == ["72.5", "0.08"])
    #expect(lookBack?.graph?.lowestInWords == "0.08")
    #expect(lookBack?.graph?.highestInWords == "72.5")
}

@MainActor
@Test("a look-back says a whole number with no separator between thousands")
func aLookBackSaysAWholeNumberWithNoSeparatorBetweenThousands() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let steps = Commitment(
        name: "Steps", schedule: everyDay, keptFrom: keptFrom, kind: .number(range: nil))!
    let today = CalendarDate(year: 2026, month: 3, day: 1)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(steps)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Number(100000, for: steps, on: keptFrom)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: steps)

    #expect(lookBack?.graph?.points.map(\.inWords) == ["100000"])
}

@MainActor
@Test("a total commitment's look-back says a point for each day that holds an addition")
func aTotalCommitmentsLookBackSaysAPointForEachDayThatHoldsAnAddition() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: everyDay, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!
    let firstDay = CalendarDate(year: 2026, month: 3, day: 1)!
    let thirdDay = CalendarDate(year: 2026, month: 3, day: 3)!
    let fourthDay = CalendarDate(year: 2026, month: 3, day: 4)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(protein)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Addition(100, for: protein, on: firstDay)!)
    try recordStore.add(Addition(50, for: protein, on: firstDay)!)
    try recordStore.add(Addition(87.5, for: protein, on: thirdDay)!)
    try recordStore.add(Addition(120, for: protein, on: fourthDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: protein)

    #expect(lookBack?.graph?.points.map(\.day) == [0, 2, 3])
    #expect(lookBack?.graph?.points.map(\.value) == [150, 87.5, 120])
    #expect(lookBack?.graph?.points.contains { $0.day == 1 } == false)
    #expect(lookBack?.graph?.points.contains { $0.day == 4 } == false)
    #expect(lookBack?.graph?.days.count == 5)
    #expect(lookBack?.graph?.days.first == "1 March 2026")
    #expect(lookBack?.graph?.days.last == "5 March 2026")
    #expect(lookBack?.lines == [])
    #expect(lookBack?.whole == nil)
}

@MainActor
@Test("a total commitment's look-back says no graph where no day holds an addition")
func aTotalCommitmentsLookBackSaysNoGraphWhereNoDayHoldsAnAddition() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: everyDay, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(protein)
    _ = try RecordStore(at: places.record)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: protein)

    #expect(lookBack?.graph == nil)
    #expect(lookBack?.lines == [])
    #expect(lookBack?.whole == nil)
    #expect(lookBack?.name == "Protein")
    #expect(lookBack?.rhythmInWords == "Every day")
    #expect(lookBack?.keptFromInWords == "1 March 2026")

    let takenBackPlaces = freshRosterAndRecordPlaces()
    let takenBackDay = CalendarDate(year: 2026, month: 3, day: 3)!
    let takenBackProtein = Commitment(
        name: "Protein", schedule: everyDay, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let takenBackRosterStore = try RosterStore(at: takenBackPlaces.roster)
    try takenBackRosterStore.add(takenBackProtein)
    let takenBackRecordStore = try RecordStore(at: takenBackPlaces.record)
    try takenBackRecordStore.add(Addition(50, for: takenBackProtein, on: takenBackDay)!)
    try takenBackRecordStore.removeLastAddition(for: takenBackProtein, on: takenBackDay)

    let takenBackScreen = CommitmentsScreen(
        asOf: today, keepingRosterAt: takenBackPlaces.roster,
        keepingRecordAt: takenBackPlaces.record)
    let takenBackLookBack = takenBackScreen.lookBack(at: takenBackProtein)

    #expect(takenBackLookBack?.graph == nil)
}

@MainActor
@Test("a total commitment's look-back says the sum the era holding a day kept")
func aTotalCommitmentsLookBackSaysTheSumTheEraHoldingADayKept() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let olderKeptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let olderProtein = Commitment(
        name: "Protein", schedule: everyDay, keptFrom: olderKeptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let newerProtein = Commitment(
        era: olderProtein, schedule: everyDay, keptFrom: newerKeptFrom,
        kind: .total(target: Commitment.Target(100)!))!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!
    let olderDay = CalendarDate(year: 2026, month: 3, day: 2)!
    let newerDay = CalendarDate(year: 2026, month: 3, day: 5)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderProtein)
    try rosterStore.put(era: newerProtein, on: olderProtein, keptUntil: boundary, under: nil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Addition(90, for: olderProtein, on: olderDay)!)
    try recordStore.add(Addition(110, for: newerProtein, on: newerDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerProtein)

    #expect(lookBack?.graph?.points.map(\.day) == [1, 4])
    #expect(lookBack?.graph?.points.map(\.value) == [90, 110])
}

@MainActor
@Test(
    "a total commitment's graph marks a point kept where its sum passes its target, and not where it falls short"
)
func aTotalCommitmentsGraphMarksAPointKeptWhereItsSumPassesItsTargetAndNotWhereItFallsShort() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: everyDay, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!
    let firstDay = CalendarDate(year: 2026, month: 3, day: 1)!
    let thirdDay = CalendarDate(year: 2026, month: 3, day: 3)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(protein)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Addition(150, for: protein, on: firstDay)!)
    try recordStore.add(Addition(87.5, for: protein, on: thirdDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: protein)

    let firstPoint = lookBack?.graph?.points.first { $0.day == 0 }
    let secondPoint = lookBack?.graph?.points.first { $0.day == 2 }

    #expect(firstPoint?.inWords == "150 of 120")
    #expect(firstPoint?.isKept == true)
    #expect(secondPoint?.inWords == "87.5 of 120")
    #expect(secondPoint?.isKept == false)
}

@MainActor
@Test("a total commitment's graph marks a point kept where its sum reaches its target exactly")
func aTotalCommitmentsGraphMarksAPointKeptWhereItsSumReachesItsTargetExactly() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: everyDay, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!
    let fourthDay = CalendarDate(year: 2026, month: 3, day: 4)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(protein)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Addition(100, for: protein, on: fourthDay)!)
    try recordStore.add(Addition(20, for: protein, on: fourthDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: protein)

    #expect(lookBack?.graph?.points.count == 1)
    #expect(lookBack?.graph?.points.first?.inWords == "120 of 120")
    #expect(lookBack?.graph?.points.first?.isKept == true)
}

@MainActor
@Test("a total commitment's graph judges each point against the target the era holding its day declared")
func aTotalCommitmentsGraphJudgesEachPointAgainstTheTargetTheEraHoldingItsDayDeclared() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let olderKeptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let olderProtein = Commitment(
        name: "Protein", schedule: everyDay, keptFrom: olderKeptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let newerProtein = Commitment(
        era: olderProtein, schedule: everyDay, keptFrom: newerKeptFrom,
        kind: .total(target: Commitment.Target(100)!))!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!
    let olderDay = CalendarDate(year: 2026, month: 3, day: 2)!
    let newerDay = CalendarDate(year: 2026, month: 3, day: 5)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderProtein)
    try rosterStore.put(era: newerProtein, on: olderProtein, keptUntil: boundary, under: nil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Addition(110, for: olderProtein, on: olderDay)!)
    try recordStore.add(Addition(110, for: newerProtein, on: newerDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerProtein)

    let olderPoint = lookBack?.graph?.points.first { $0.day == 1 }
    let newerPoint = lookBack?.graph?.points.first { $0.day == 4 }

    #expect(olderPoint?.inWords == "110 of 120")
    #expect(olderPoint?.isKept == false)
    #expect(newerPoint?.inWords == "110 of 100")
    #expect(newerPoint?.isKept == true)
}

@MainActor
@Test(
    "a total commitment's target rule runs across every day of its graph, a day holding no addition included"
)
func aTotalCommitmentsTargetRuleRunsAcrossEveryDayOfItsGraphADayHoldingNoAdditionIncluded() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: everyDay, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!
    let thirdDay = CalendarDate(year: 2026, month: 3, day: 3)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(protein)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Addition(150, for: protein, on: thirdDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: protein)

    #expect(
        lookBack?.graph?.targetRule == [
            LookBack.Graph.Stretch(from: 0, through: 4, target: 120, inWords: "120")
        ])

    let numberPlaces = freshRosterAndRecordPlaces()
    let weightKeptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let weight = Commitment(
        name: "Weight", schedule: everyDay, keptFrom: weightKeptFrom, kind: .number(range: nil))!
    let numberRosterStore = try RosterStore(at: numberPlaces.roster)
    try numberRosterStore.add(weight)
    let numberRecordStore = try RecordStore(at: numberPlaces.record)
    try numberRecordStore.add(Number(72.5, for: weight, on: weightKeptFrom)!)
    let numberScreen = CommitmentsScreen(
        asOf: today, keepingRosterAt: numberPlaces.roster, keepingRecordAt: numberPlaces.record)
    let numberLookBack = numberScreen.lookBack(at: weight)

    #expect(numberLookBack?.graph?.targetRule == [])
}

@MainActor
@Test("a total commitment's target rule steps where the target changed")
func aTotalCommitmentsTargetRuleStepsWhereTheTargetChanged() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let olderKeptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let olderProtein = Commitment(
        name: "Protein", schedule: everyDay, keptFrom: olderKeptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let newerProtein = Commitment(
        era: olderProtein, schedule: everyDay, keptFrom: newerKeptFrom,
        kind: .total(target: Commitment.Target(100)!))!
    let today = CalendarDate(year: 2026, month: 3, day: 8)!
    let olderDay = CalendarDate(year: 2026, month: 3, day: 2)!
    let newerDay = CalendarDate(year: 2026, month: 3, day: 5)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderProtein)
    try rosterStore.put(era: newerProtein, on: olderProtein, keptUntil: boundary, under: nil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Addition(90, for: olderProtein, on: olderDay)!)
    try recordStore.add(Addition(110, for: newerProtein, on: newerDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerProtein)

    #expect(
        lookBack?.graph?.targetRule == [
            LookBack.Graph.Stretch(from: 0, through: 2, target: 120, inWords: "120"),
            LookBack.Graph.Stretch(from: 3, through: 7, target: 100, inWords: "100"),
        ])
}

@MainActor
@Test("a total commitment's target rule runs through a gap at the target of the era before it")
func aTotalCommitmentsTargetRuleRunsThroughAGapAtTheTargetOfTheEraBeforeIt() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let olderKeptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let olderKeptUntil = CalendarDate(year: 2026, month: 3, day: 3)!
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 6)!
    let olderProtein = Commitment(
        name: "Protein", schedule: everyDay, keptFrom: olderKeptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let newerProtein = Commitment(
        era: olderProtein, schedule: everyDay, keptFrom: newerKeptFrom,
        kind: .total(target: Commitment.Target(100)!))!
    let today = CalendarDate(year: 2026, month: 3, day: 8)!
    let olderDay = CalendarDate(year: 2026, month: 3, day: 2)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderProtein)
    try rosterStore.put(era: newerProtein, on: olderProtein, keptUntil: olderKeptUntil, under: nil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Addition(150, for: olderProtein, on: olderDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerProtein)

    #expect(
        lookBack?.graph?.targetRule == [
            LookBack.Graph.Stretch(from: 0, through: 4, target: 120, inWords: "120"),
            LookBack.Graph.Stretch(from: 5, through: 7, target: 100, inWords: "100"),
        ])
}

@MainActor
@Test("a total commitment's graph runs from zero to its greatest sum where a sum passes every target")
func aTotalCommitmentsGraphRunsFromZeroToItsGreatestSumWhereASumPassesEveryTarget() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let protein = Commitment(
        name: "Protein", schedule: everyDay, keptFrom: keptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!
    let firstDay = CalendarDate(year: 2026, month: 3, day: 1)!
    let thirdDay = CalendarDate(year: 2026, month: 3, day: 3)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(protein)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Addition(150, for: protein, on: firstDay)!)
    try recordStore.add(Addition(87.5, for: protein, on: thirdDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: protein)

    #expect(lookBack?.graph?.lowestInWords == "0")
    #expect(lookBack?.graph?.highestInWords == "150")
}

@MainActor
@Test("a total commitment's graph runs from zero to its greatest target where every sum falls short")
func aTotalCommitmentsGraphRunsFromZeroToItsGreatestTargetWhereEverySumFallsShort() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let olderKeptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let olderProtein = Commitment(
        name: "Protein", schedule: everyDay, keptFrom: olderKeptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let newerProtein = Commitment(
        era: olderProtein, schedule: everyDay, keptFrom: newerKeptFrom,
        kind: .total(target: Commitment.Target(100)!))!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!
    let olderDay = CalendarDate(year: 2026, month: 3, day: 2)!
    let newerDay = CalendarDate(year: 2026, month: 3, day: 5)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderProtein)
    try rosterStore.put(era: newerProtein, on: olderProtein, keptUntil: boundary, under: nil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Addition(30, for: olderProtein, on: olderDay)!)
    try recordStore.add(Addition(40, for: newerProtein, on: newerDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerProtein)

    #expect(lookBack?.graph?.lowestInWords == "0")
    #expect(lookBack?.graph?.highestInWords == "120")
}

@MainActor
@Test("a total commitment's graph says nothing where only the rhythm changed")
func aTotalCommitmentsGraphSaysNothingWhereOnlyTheRhythmChanged() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let olderKeptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let olderProtein = Commitment(
        name: "Protein", schedule: everyDay, keptFrom: olderKeptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let newerProtein = Commitment(
        era: olderProtein, schedule: .weekdays([.tuesday, .thursday]), keptFrom: newerKeptFrom,
        kind: .total(target: Commitment.Target(120)!))!
    let today = CalendarDate(year: 2026, month: 3, day: 8)!
    let olderDay = CalendarDate(year: 2026, month: 3, day: 2)!
    let newerDay = CalendarDate(year: 2026, month: 3, day: 5)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderProtein)
    try rosterStore.put(era: newerProtein, on: olderProtein, keptUntil: boundary, under: nil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Addition(150, for: olderProtein, on: olderDay)!)
    try recordStore.add(Addition(90, for: newerProtein, on: newerDay)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerProtein)

    #expect(lookBack?.graph?.days.count == 8)
    #expect(lookBack?.graph?.days.first == "1 March 2026")
    #expect(lookBack?.graph?.days.last == "8 March 2026")
    #expect(lookBack?.graph?.months == [LookBack.Graph.Month(inWords: "March 2026", day: 0)])
    #expect(
        lookBack?.graph?.points == [
            LookBack.Graph.Point(day: 1, value: 150, inWords: "150 of 120", isKept: true),
            LookBack.Graph.Point(day: 4, value: 90, inWords: "90 of 120", isKept: false),
        ])
    #expect(
        lookBack?.graph?.targetRule == [
            LookBack.Graph.Stretch(from: 0, through: 7, target: 120, inWords: "120")
        ])
}

@MainActor
@Test("a look-back says a number below zero with a leading minus")
func aLookBackSaysANumberBelowZeroWithALeadingMinus() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let balance = Commitment(
        name: "Balance", schedule: everyDay, keptFrom: keptFrom,
        kind: .number(range: Commitment.Range(lowest: -10, highest: 10)))!
    let today = CalendarDate(year: 2026, month: 3, day: 1)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(balance)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Number(-3, for: balance, on: keptFrom)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: balance)

    #expect(lookBack?.graph?.points.map(\.inWords) == ["-3"])
    #expect(lookBack?.graph?.lowestInWords == "-10")
    #expect(lookBack?.graph?.highestInWords == "10")
}

@MainActor
@Test("a note commitment's look-back says each day's note under its day, newest first")
func aNoteCommitmentsLookBackSaysEachDaysNoteUnderItsDayNewestFirst() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let journal = Commitment(name: "Journal", schedule: everyDay, keptFrom: keptFrom, kind: .note)!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(journal)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(
        Note("Quiet day.", for: journal, on: CalendarDate(year: 2026, month: 3, day: 1)!)!)
    try recordStore.add(
        Note("Long walk.", for: journal, on: CalendarDate(year: 2026, month: 3, day: 3)!)!)
    try recordStore.add(
        Note("Read in the evening.", for: journal, on: CalendarDate(year: 2026, month: 3, day: 4)!)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: journal)

    #expect(
        lookBack?.notes == [
            LookBack.DatedNote(dayInWords: "4 March 2026", text: "Read in the evening."),
            LookBack.DatedNote(dayInWords: "3 March 2026", text: "Long walk."),
            LookBack.DatedNote(dayInWords: "1 March 2026", text: "Quiet day."),
        ])
    #expect(lookBack?.lines == [])
    #expect(lookBack?.whole == nil)
    #expect(lookBack?.graph == nil)
}

@MainActor
@Test(
    "a note commitment's look-back says a note's text exactly as the record holds it, line breaks included"
)
func aNoteCommitmentsLookBackSaysANotesTextExactlyAsTheRecordHoldsItLineBreaksIncluded() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let journal = Commitment(name: "Journal", schedule: everyDay, keptFrom: keptFrom, kind: .note)!
    let fourthMarch = CalendarDate(year: 2026, month: 3, day: 4)!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!
    let fourLines = "Three things today:\n– finished the draft\n– called Anna\n– early night"

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(journal)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Note(fourLines, for: journal, on: fourthMarch)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: journal)

    #expect(
        lookBack?.notes == [
            LookBack.DatedNote(dayInWords: "4 March 2026", text: fourLines)
        ])

    let longPlaces = freshRosterAndRecordPlaces()
    let longJournal = Commitment(
        name: "Journal", schedule: everyDay, keptFrom: keptFrom, kind: .note)!
    let longNote = String(repeating: "a", count: 600)

    let longRosterStore = try RosterStore(at: longPlaces.roster)
    try longRosterStore.add(longJournal)
    let longRecordStore = try RecordStore(at: longPlaces.record)
    try longRecordStore.add(Note(longNote, for: longJournal, on: fourthMarch)!)

    let longScreen = CommitmentsScreen(
        asOf: today, keepingRosterAt: longPlaces.roster, keepingRecordAt: longPlaces.record)
    let longLookBack = longScreen.lookBack(at: longJournal)

    #expect(longLookBack?.notes.map(\.text) == [longNote])
}

@MainActor
@Test("a note commitment's look-back says no note where no day holds one")
func aNoteCommitmentsLookBackSaysNoNoteWhereNoDayHoldsOne() throws {
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!

    let places = freshRosterAndRecordPlaces()
    let journal = Commitment(name: "Journal", schedule: everyDay, keptFrom: keptFrom, kind: .note)!
    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(journal)
    _ = try RecordStore(at: places.record)
    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: journal)

    #expect(lookBack?.notes == [])
    #expect(lookBack?.noteCountInWords == nil)
    #expect(lookBack?.lines == [])
    #expect(lookBack?.whole == nil)
    #expect(lookBack?.graph == nil)
    #expect(lookBack?.name == "Journal")
    #expect(lookBack?.rhythmInWords == "Every day")
    #expect(lookBack?.keptFromInWords == "1 March 2026")

    let takenBackPlaces = freshRosterAndRecordPlaces()
    let takenBackJournal = Commitment(
        name: "Journal", schedule: everyDay, keptFrom: keptFrom, kind: .note)!
    let thirdMarch = CalendarDate(year: 2026, month: 3, day: 3)!
    let takenBackRosterStore = try RosterStore(at: takenBackPlaces.roster)
    try takenBackRosterStore.add(takenBackJournal)
    let takenBackRecordStore = try RecordStore(at: takenBackPlaces.record)
    try takenBackRecordStore.add(Note("Quiet day.", for: takenBackJournal, on: thirdMarch)!)
    try takenBackRecordStore.removeNote(for: takenBackJournal, on: thirdMarch)
    let takenBackScreen = CommitmentsScreen(
        asOf: today, keepingRosterAt: takenBackPlaces.roster,
        keepingRecordAt: takenBackPlaces.record)

    #expect(takenBackScreen.lookBack(at: takenBackJournal)?.notes == [])

    let futurePlaces = freshRosterAndRecordPlaces()
    let futureKeptFrom = CalendarDate(year: 2026, month: 4, day: 1)!
    let futureJournal = Commitment(
        name: "Journal", schedule: everyDay, keptFrom: futureKeptFrom, kind: .note)!
    let futureRosterStore = try RosterStore(at: futurePlaces.roster)
    try futureRosterStore.add(futureJournal)
    _ = try RecordStore(at: futurePlaces.record)
    let futureScreen = CommitmentsScreen(
        asOf: today, keepingRosterAt: futurePlaces.roster, keepingRecordAt: futurePlaces.record)

    #expect(futureScreen.lookBack(at: futureJournal)?.notes == [])

    let tickPlaces = freshRosterAndRecordPlaces()
    let gym = Commitment(name: "Gym", schedule: everyDay, keptFrom: keptFrom)!
    let tickRosterStore = try RosterStore(at: tickPlaces.roster)
    try tickRosterStore.add(gym)
    let tickRecordStore = try RecordStore(at: tickPlaces.record)
    try tickRecordStore.add(Tick(gym, on: thirdMarch)!)
    let tickScreen = CommitmentsScreen(
        asOf: today, keepingRosterAt: tickPlaces.roster, keepingRecordAt: tickPlaces.record)

    #expect(tickScreen.lookBack(at: gym)?.notes == [])
}

@MainActor
@Test("a stopped note commitment's look-back says no note after the day it was kept until")
func aStoppedNoteCommitmentsLookBackSaysNoNoteAfterTheDayItWasKeptUntil() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 2, day: 25)!
    let keptUntil = CalendarDate(year: 2026, month: 2, day: 28)!
    let journal = Commitment(name: "Journal", schedule: everyDay, keptFrom: keptFrom, kind: .note)!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(journal)
    try rosterStore.retire(journal, keptUntil: keptUntil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(
        Note("Quiet day.", for: journal, on: CalendarDate(year: 2026, month: 2, day: 27)!)!)
    try recordStore.add(
        Note("Long walk.", for: journal, on: CalendarDate(year: 2026, month: 3, day: 4)!)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: journal)

    #expect(
        lookBack?.notes == [
            LookBack.DatedNote(dayInWords: "27 February 2026", text: "Quiet day.")
        ])
    #expect(lookBack?.keptUntilInWords == "28 February 2026")
}

@MainActor
@Test("a note commitment's look-back says the notes of every era of its chain")
func aNoteCommitmentsLookBackSaysTheNotesOfEveryEraOfItsChain() throws {
    let places = freshRosterAndRecordPlaces()
    let olderKeptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let boundary = CalendarDate(year: 2026, month: 3, day: 3)!
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 4)!
    let olderJournal = Commitment(
        name: "Journal",
        schedule: .weekdays([
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
        ]), keptFrom: olderKeptFrom, kind: .note)!
    let newerJournal = Commitment(
        era: olderJournal, schedule: .weekdays([.tuesday, .thursday]), keptFrom: newerKeptFrom,
        kind: .note)!
    let today = CalendarDate(year: 2026, month: 3, day: 8)!
    let secondMarch = CalendarDate(year: 2026, month: 3, day: 2)!
    let fifthMarch = CalendarDate(year: 2026, month: 3, day: 5)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderJournal)
    try rosterStore.put(era: newerJournal, on: olderJournal, keptUntil: boundary, under: nil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Note("Quiet day.", for: olderJournal, on: secondMarch)!)
    try recordStore.add(Note("Long walk.", for: newerJournal, on: fifthMarch)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerJournal)

    #expect(
        lookBack?.notes == [
            LookBack.DatedNote(dayInWords: "5 March 2026", text: "Long walk."),
            LookBack.DatedNote(dayInWords: "2 March 2026", text: "Quiet day."),
        ])
    #expect(lookBack?.keptFromInWords == "1 March 2026")
}

@MainActor
@Test("a note commitment's look-back says no note a gap day holds")
func aNoteCommitmentsLookBackSaysNoNoteAGapDayHolds() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let olderKeptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let olderKeptUntil = CalendarDate(year: 2026, month: 3, day: 3)!
    let newerKeptFrom = CalendarDate(year: 2026, month: 3, day: 6)!
    let olderJournal = Commitment(
        name: "Journal", schedule: everyDay, keptFrom: olderKeptFrom, kind: .note)!
    let newerJournal = Commitment(
        era: olderJournal, schedule: everyDay, keptFrom: newerKeptFrom, kind: .note)!
    let today = CalendarDate(year: 2026, month: 3, day: 8)!
    let secondMarch = CalendarDate(year: 2026, month: 3, day: 2)!
    let gapDay = CalendarDate(year: 2026, month: 3, day: 4)!
    let seventhMarch = CalendarDate(year: 2026, month: 3, day: 7)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(olderJournal)
    try rosterStore.put(era: newerJournal, on: olderJournal, keptUntil: olderKeptUntil, under: nil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(Note("Ran 8k.", for: olderJournal, on: secondMarch)!)
    try recordStore.add(Note("Rested.", for: olderJournal, on: gapDay)!)
    try recordStore.add(Note("Swam.", for: newerJournal, on: seventhMarch)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: newerJournal)

    #expect(
        lookBack?.notes == [
            LookBack.DatedNote(dayInWords: "7 March 2026", text: "Swam."),
            LookBack.DatedNote(dayInWords: "2 March 2026", text: "Ran 8k."),
        ])
    #expect(lookBack?.noteCountInWords == "2 notes")
}

@MainActor
@Test("a note commitment's look-back counts the notes it says")
func aNoteCommitmentsLookBackCountsTheNotesItSays() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let journal = Commitment(name: "Journal", schedule: everyDay, keptFrom: keptFrom, kind: .note)!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(journal)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(
        Note("Quiet day.", for: journal, on: CalendarDate(year: 2026, month: 3, day: 1)!)!)
    try recordStore.add(
        Note("Long walk.", for: journal, on: CalendarDate(year: 2026, month: 3, day: 3)!)!)
    try recordStore.add(
        Note("Read in the evening.", for: journal, on: CalendarDate(year: 2026, month: 3, day: 4)!)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: journal)

    #expect(lookBack?.noteCountInWords == "3 notes")
}

@MainActor
@Test("a note commitment's look-back that says one note counts it in the singular")
func aNoteCommitmentsLookBackThatSaysOneNoteCountsItInTheSingular() throws {
    let places = freshRosterAndRecordPlaces()
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 2, day: 25)!
    let keptUntil = CalendarDate(year: 2026, month: 2, day: 28)!
    let journal = Commitment(name: "Journal", schedule: everyDay, keptFrom: keptFrom, kind: .note)!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!

    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(journal)
    try rosterStore.retire(journal, keptUntil: keptUntil)
    let recordStore = try RecordStore(at: places.record)
    try recordStore.add(
        Note("Quiet day.", for: journal, on: CalendarDate(year: 2026, month: 2, day: 27)!)!)
    try recordStore.add(
        Note("Long walk.", for: journal, on: CalendarDate(year: 2026, month: 3, day: 4)!)!)

    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let lookBack = screen.lookBack(at: journal)

    #expect(lookBack?.noteCountInWords == "1 note")
}

@MainActor
@Test("a look-back that says no note says no count")
func aLookBackThatSaysNoNoteSaysNoCount() throws {
    let everyDay: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let keptFrom = CalendarDate(year: 2026, month: 3, day: 1)!
    let today = CalendarDate(year: 2026, month: 3, day: 5)!

    let places = freshRosterAndRecordPlaces()
    let journal = Commitment(name: "Journal", schedule: everyDay, keptFrom: keptFrom, kind: .note)!
    let rosterStore = try RosterStore(at: places.roster)
    try rosterStore.add(journal)
    _ = try RecordStore(at: places.record)
    let screen = CommitmentsScreen(
        asOf: today, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    #expect(screen.lookBack(at: journal)?.noteCountInWords == nil)

    let tickPlaces = freshRosterAndRecordPlaces()
    let gym = Commitment(name: "Gym", schedule: everyDay, keptFrom: keptFrom)!
    let tickRosterStore = try RosterStore(at: tickPlaces.roster)
    try tickRosterStore.add(gym)
    let tickRecordStore = try RecordStore(at: tickPlaces.record)
    try tickRecordStore.add(Tick(gym, on: CalendarDate(year: 2026, month: 3, day: 3)!)!)
    let tickScreen = CommitmentsScreen(
        asOf: today, keepingRosterAt: tickPlaces.roster, keepingRecordAt: tickPlaces.record)

    #expect(tickScreen.lookBack(at: gym)?.noteCountInWords == nil)
}
