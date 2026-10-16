import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private let januaryFirst = date(2026, 1, 1)
private let monday12 = date(2026, 10, 12)
private let everyDay = Schedule.weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])

private struct Places {
    let roster: URL
    let record: URL
    let oneOffs: URL

    init() {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        roster = directory.appendingPathComponent("roster.json")
        record = directory.appendingPathComponent("record.json")
        oneOffs = directory.appendingPathComponent("one-offs.json")
    }
}

private func commitment(_ name: String) -> Commitment {
    Commitment(name: name, schedule: everyDay, keptFrom: januaryFirst, kind: .tick)!
}

private func takeOn(_ commitments: [Commitment], at places: Places) throws {
    let store = try RosterStore(at: places.roster)
    for commitment in commitments {
        try store.add(commitment)
    }
}

@MainActor
private func screen(_ places: Places, asOf day: CalendarDate = monday12) -> CommitmentsScreen {
    CommitmentsScreen(
        asOf: day, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingOneOffsAt: places.oneOffs)
}

private func isDue(_ name: String, on day: CalendarDate, in roster: Roster) -> Bool {
    roster.groups(on: day).flatMap(\.commitments).contains {
        $0.name == name && $0.isDue(on: day)
    }
}

private func roster(at places: Places) throws -> Roster {
    try RosterStore(at: places.roster).roster
}

@MainActor
private func stopKeeping(_ commitment: Commitment, on screen: CommitmentsScreen) {
    screen.askToStopKeeping(commitment)
    screen.confirmStopKeeping()
}

@MainActor
private func takeUpAgain(on screen: CommitmentsScreen) throws -> CommitmentsScreen.Refusal? {
    screen.keepAgain(try #require(screen.stopped.first))
}

/// The one days away a screen lists, upcoming or past.
@MainActor
private func theDaysAway(_ screen: CommitmentsScreen) throws -> DaysAway {
    try #require((screen.daysAway + screen.pastDaysAway).first)
}

@MainActor
private func remove(_ screen: CommitmentsScreen) throws -> CommitmentsScreen.Refusal? {
    screen.askToRemove(try theDaysAway(screen))
    return screen.confirmRemovingDaysAway()
}

/// "Mallorca", Tuesday 13 through Sunday 18 October over "Gym" and "Run", said as of Monday 12 and "Gym"
/// stopped as of Thursday 15.
@MainActor
private func mallorcaWithGymStopped(_ places: Places) throws -> [Commitment] {
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    screen(places).sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, run])
    stopKeeping(gym, on: screen(places, asOf: date(2026, 10, 15)))
    return [gym, run]
}

private func expect(
    _ name: String, due: [Int], notDue: [Int], in roster: Roster, month: Int = 10,
    sourceLocation: SourceLocation = #_sourceLocation
) {
    for day in due {
        #expect(
            isDue(name, on: date(2026, month, day), in: roster), "\(name) due on \(month)/\(day)",
            sourceLocation: sourceLocation)
    }
    for day in notDue {
        #expect(
            !isDue(name, on: date(2026, month, day), in: roster), "\(name) not due on \(month)/\(day)",
            sourceLocation: sourceLocation)
    }
}

@MainActor
@Test(
    "a commitment taken up again inside days away over it is taken up on the day it is handed, its days hidden until the day after them"
)
func aCommitmentTakenUpAgainInsideDaysAwayOverItIsTakenUpOnTheDayItIsHandedItsDaysHiddenUntilTheDayAfterThem()
    throws
{
    let places = Places()
    _ = try mallorcaWithGymStopped(places)
    let friday = screen(places, asOf: date(2026, 10, 16))

    let refusal = try takeUpAgain(on: friday)

    #expect(refusal == nil)
    #expect(friday.kept.map(\.name).contains("Gym"))
    #expect(friday.daysAway.map(\.title) == ["Mallorca"])
    #expect(friday.daysAway.first?.commitments.map(\.name) == ["Gym", "Run"])
    expect("Gym", due: [19], notDue: [16, 17, 18], in: try roster(at: places))

    #expect(try remove(friday) == nil)
    expect("Gym", due: [13, 14, 16, 19], notDue: [15], in: try roster(at: places))
}

@MainActor
@Test(
    "a commitment taken up again inside days away stays picked through a later change moving their first day past its stop"
)
func aCommitmentTakenUpAgainInsideDaysAwayStaysPickedThroughALaterChangeMovingTheirFirstDayPastItsStop()
    throws
{
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    let yoga = commitment("Yoga")
    try takeOn([gym, run, yoga], at: places)
    let saying = screen(places)
    saying.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, run])
    saying.sayDaysAway(
        named: "Lisbon", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [yoga])
    let stopping = screen(places, asOf: date(2026, 10, 15))
    stopKeeping(gym, on: stopping)
    stopKeeping(yoga, on: stopping)
    let commitments = screen(places, asOf: date(2026, 10, 16))
    for stopped in commitments.stopped {
        #expect(commitments.keepAgain(stopped) == nil)
    }
    let mallorca = try #require(commitments.daysAway.first { $0.title == "Mallorca" })
    let lisbon = try #require(commitments.daysAway.first { $0.title == "Lisbon" })

    let first = commitments.changeDaysAway(
        mallorca, named: "Mallorca", from: date(2026, 10, 17), through: date(2026, 10, 18),
        over: [gym, run])
    let second = commitments.changeDaysAway(
        lisbon, named: "Lisbon", from: date(2026, 10, 17), through: date(2026, 10, 18), over: [yoga])

    #expect(first == nil)
    #expect(second == nil)
    #expect(commitments.daysAway.map(\.title) == ["Mallorca", "Lisbon"])
    #expect(
        commitments.daysAway.map(\.daysInWords) == ["Sat 17 Oct – Sun 18 Oct", "Sat 17 Oct – Sun 18 Oct"])
    #expect(commitments.daysAway.map { $0.commitments.map(\.name) } == [["Gym", "Run"], ["Yoga"]])
    let kept = try roster(at: places)
    for name in ["Gym", "Yoga"] {
        expect(name, due: [13, 14, 16, 19], notDue: [15, 17, 18], in: kept)
    }
}

@MainActor
@Test(
    "days away whose first day moved past the stop of a commitment taken up again inside them, removed, leave it owing no day between its stop and its take-up"
)
func daysAwayWhoseFirstDayMovedPastTheStopOfACommitmentTakenUpAgainInsideThemRemovedLeaveItOwingNoDayBetweenItsStopAndItsTakeUp()
    throws
{
    let places = Places()
    let both = try mallorcaWithGymStopped(places)
    let friday = screen(places, asOf: date(2026, 10, 16))
    #expect(try takeUpAgain(on: friday) == nil)

    let changed = friday.changeDaysAway(
        try theDaysAway(friday), named: "Mallorca", from: date(2026, 10, 17),
        through: date(2026, 10, 18), over: both)
    let removed = try remove(friday)

    #expect(changed == nil)
    #expect(removed == nil)
    #expect(friday.daysAway.isEmpty && friday.pastDaysAway.isEmpty)
    let kept = try roster(at: places)
    expect("Gym", due: [13, 14, 16, 19], notDue: [15], in: kept)
    expect("Run", due: [15, 17], notDue: [], in: kept)
}

@MainActor
@Test(
    "days away whose first day moved past the stop of a commitment taken up again inside them, moved back over it and removed, leave it owing no day between its stop and its take-up"
)
func daysAwayWhoseFirstDayMovedPastTheStopOfACommitmentTakenUpAgainInsideThemMovedBackOverItAndRemovedLeaveItOwingNoDayBetweenItsStopAndItsTakeUp()
    throws
{
    let places = Places()
    let both = try mallorcaWithGymStopped(places)
    let friday = screen(places, asOf: date(2026, 10, 16))
    #expect(try takeUpAgain(on: friday) == nil)

    let past = friday.changeDaysAway(
        try theDaysAway(friday), named: "Mallorca", from: date(2026, 10, 17),
        through: date(2026, 10, 18), over: both)
    let back = friday.changeDaysAway(
        try theDaysAway(friday), named: "Mallorca", from: date(2026, 10, 15),
        through: date(2026, 10, 18), over: both)
    let removed = try remove(friday)

    #expect(past == nil)
    #expect(back == nil)
    #expect(removed == nil)
    expect("Gym", due: [13, 14, 16, 19], notDue: [15], in: try roster(at: places))
}

@MainActor
@Test(
    "days away moved to end before a take-up made inside them leave the days between its stop and its take-up owing nothing"
)
func daysAwayMovedToEndBeforeATakeUpMadeInsideThemLeaveTheDaysBetweenItsStopAndItsTakeUpOwingNothing()
    throws
{
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    screen(places).sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18), over: [gym, run])
    stopKeeping(gym, on: screen(places, asOf: date(2026, 10, 14)))
    let saturday = screen(places, asOf: date(2026, 10, 17))
    #expect(try takeUpAgain(on: saturday) == nil)

    let first = saturday.changeDaysAway(
        try theDaysAway(saturday), named: "Mallorca", from: date(2026, 10, 13),
        through: date(2026, 10, 15), over: [gym, run])
    let afterFirst = try roster(at: places)
    let second = saturday.changeDaysAway(
        try theDaysAway(saturday), named: "Mallorca", from: date(2026, 10, 13),
        through: date(2026, 10, 20), over: [gym, run])
    let afterSecond = try roster(at: places)

    #expect(first == nil)
    #expect(second == nil)
    expect("Gym", due: [17, 18], notDue: [14, 15, 16], in: afterFirst)
    expect("Run", due: [16], notDue: [], in: afterFirst)
    expect("Gym", due: [21], notDue: [17, 18, 19, 20], in: afterSecond)
}

@MainActor
@Test(
    "a commitment taken up again inside days away and then unticked from them owes its days up to its stop and from its take-up"
)
func aCommitmentTakenUpAgainInsideDaysAwayAndThenUntickedFromThemOwesItsDaysUpToItsStopAndFromItsTakeUp()
    throws
{
    let places = Places()
    let both = try mallorcaWithGymStopped(places)
    let friday = screen(places, asOf: date(2026, 10, 16))
    #expect(try takeUpAgain(on: friday) == nil)

    let unticked = friday.changeDaysAway(
        try theDaysAway(friday), named: "Mallorca", from: date(2026, 10, 13),
        through: date(2026, 10, 18), over: [both[1]])

    #expect(unticked == nil)
    #expect(friday.daysAway.map(\.title) == ["Mallorca"])
    #expect(friday.daysAway.first?.commitments.map(\.name) == ["Run"])
    expect("Gym", due: [13, 14, 16, 19], notDue: [15], in: try roster(at: places))
}

@MainActor
@Test(
    "days away moved to end before the stop of a commitment taken up again inside them leave its take-up on the day it was made"
)
func daysAwayMovedToEndBeforeTheStopOfACommitmentTakenUpAgainInsideThemLeaveItsTakeUpOnTheDayItWasMade()
    throws
{
    let places = Places()
    let both = try mallorcaWithGymStopped(places)
    let friday = screen(places, asOf: date(2026, 10, 16))
    #expect(try takeUpAgain(on: friday) == nil)

    let changed = friday.changeDaysAway(
        try theDaysAway(friday), named: "Mallorca", from: date(2026, 10, 13),
        through: date(2026, 10, 13), over: both)

    #expect(changed == nil)
    expect("Gym", due: [14, 16, 19], notDue: [13, 15], in: try roster(at: places))
}

@MainActor
@Test(
    "days away moved off a stop and take-up made inside them, and back over them, leave both where they were made"
)
func daysAwayMovedOffAStopAndTakeUpMadeInsideThemAndBackOverThemLeaveBothWhereTheyWereMade() throws {
    let places = Places()
    let both = try mallorcaWithGymStopped(places)
    let friday = screen(places, asOf: date(2026, 10, 16))
    #expect(try takeUpAgain(on: friday) == nil)

    let first = friday.changeDaysAway(
        try theDaysAway(friday), named: "Mallorca", from: date(2026, 10, 5),
        through: date(2026, 10, 10), over: both)
    let afterFirst = try roster(at: places)
    let second = friday.changeDaysAway(
        try theDaysAway(friday), named: "Mallorca", from: date(2026, 10, 13),
        through: date(2026, 10, 18), over: both)
    let third = friday.changeDaysAway(
        try theDaysAway(friday), named: "Mallorca", from: date(2026, 10, 13),
        through: date(2026, 10, 20), over: both)
    let afterThird = try roster(at: places)
    let removed = try remove(friday)
    let afterRemoval = try roster(at: places)

    #expect(first == nil)
    #expect(second == nil)
    #expect(third == nil)
    #expect(removed == nil)
    expect("Gym", due: [11, 14, 16, 19], notDue: [5, 10, 15], in: afterFirst)
    expect("Gym", due: [21], notDue: [15, 16, 17, 18, 19, 20], in: afterThird)
    expect("Gym", due: [13, 14, 16, 21], notDue: [15], in: afterRemoval)
}

@MainActor
@Test(
    "days away moved past the take-up of a commitment taken up again inside them leave it owing the same days whether moved in one change or two"
)
func daysAwayMovedPastTheTakeUpOfACommitmentTakenUpAgainInsideThemLeaveItOwingTheSameDaysWhetherMovedInOneChangeOrTwo()
    throws
{
    let first = Places()
    let second = Places()
    let both = try mallorcaWithGymStopped(first)
    let bothAtSecond = try mallorcaWithGymStopped(second)
    let atFirst = screen(first, asOf: date(2026, 10, 16))
    let atSecond = screen(second, asOf: date(2026, 10, 16))
    #expect(try takeUpAgain(on: atFirst) == nil)
    #expect(try takeUpAgain(on: atSecond) == nil)

    let once = atFirst.changeDaysAway(
        try theDaysAway(atFirst), named: "Mallorca", from: date(2026, 10, 20),
        through: date(2026, 10, 25), over: both)
    let ended = atSecond.changeDaysAway(
        try theDaysAway(atSecond), named: "Mallorca", from: date(2026, 10, 13),
        through: date(2026, 10, 25), over: bothAtSecond)
    let begun = atSecond.changeDaysAway(
        try theDaysAway(atSecond), named: "Mallorca", from: date(2026, 10, 20),
        through: date(2026, 10, 25), over: bothAtSecond)

    #expect(once == nil)
    #expect(ended == nil)
    #expect(begun == nil)
    for places in [first, second] {
        expect(
            "Gym", due: [13, 14, 16, 19, 26], notDue: [15, 20, 21, 22, 23, 24, 25],
            in: try roster(at: places))
    }
}

@MainActor
@Test("days away said, moved and removed over the days of a stop leave the commitment owing none of them")
func daysAwaySaidMovedAndRemovedOverTheDaysOfAStopLeaveTheCommitmentOwingNoneOfThem() throws {
    let places = Places()
    let gym = commitment("Gym")
    let run = commitment("Run")
    try takeOn([gym, run], at: places)
    stopKeeping(run, on: screen(places, asOf: date(2026, 10, 16)))
    let wednesday = screen(places, asOf: date(2026, 10, 28))
    #expect(try takeUpAgain(on: wednesday) == nil)

    let a = wednesday.sayDaysAway(
        named: "A", from: monday12, through: date(2026, 10, 18), over: [run])
    let b = wednesday.sayDaysAway(
        named: "B", from: date(2026, 10, 24), through: date(2026, 10, 24), over: [gym, run])
    wednesday.askToRemove(
        try #require((wednesday.daysAway + wednesday.pastDaysAway).first { $0.title == "B" }))
    let removedB = wednesday.confirmRemovingDaysAway()
    let afterB = try roster(at: places)
    let moved = wednesday.changeDaysAway(
        try #require((wednesday.daysAway + wednesday.pastDaysAway).first { $0.title == "A" }),
        named: "A", from: date(2026, 10, 20), through: date(2026, 10, 26), over: [run])
    let back = wednesday.changeDaysAway(
        try #require((wednesday.daysAway + wednesday.pastDaysAway).first { $0.title == "A" }),
        named: "A", from: monday12, through: date(2026, 10, 18), over: [run])
    let removedA = try remove(wednesday)
    let afterA = try roster(at: places)

    #expect(a == nil)
    #expect(b == nil)
    #expect(removedB == nil)
    #expect(moved == nil)
    #expect(back == nil)
    #expect(removedA == nil)
    expect("Run", due: [], notDue: Array(16...27), in: afterB)
    expect("Gym", due: [24], notDue: [], in: afterB)
    expect("Run", due: [15, 28], notDue: Array(16...27), in: afterA)
}

@MainActor
@Test(
    "a stop undone through a screen opened as of an earlier day leaves the days away over the commitment hiding their days"
)
func aStopUndoneThroughAScreenOpenedAsOfAnEarlierDayLeavesTheDaysAwayOverTheCommitmentHidingTheirDays()
    throws
{
    let places = Places()
    let both = try mallorcaWithGymStopped(places)
    let earlier = screen(places, asOf: monday12)

    let takenUp = try takeUpAgain(on: earlier)
    let beforeChange = try roster(at: places)
    let moved = earlier.changeDaysAway(
        try theDaysAway(earlier), named: "Mallorca", from: date(2026, 10, 20),
        through: date(2026, 10, 25), over: both)
    let back = earlier.changeDaysAway(
        try theDaysAway(earlier), named: "Mallorca", from: date(2026, 10, 13),
        through: date(2026, 10, 18), over: both)

    #expect(takenUp == nil)
    #expect(moved == nil)
    #expect(back == nil)
    #expect(earlier.kept.map(\.name).contains("Gym"))
    #expect(earlier.daysAway.map(\.title) == ["Mallorca"])
    #expect(earlier.daysAway.first?.commitments.map(\.name) == ["Gym", "Run"])
    expect("Gym", due: [12, 19], notDue: Array(13...18), in: beforeChange)
    expect("Gym", due: [12, 19], notDue: Array(13...18), in: try roster(at: places))
}

@MainActor
@Test(
    "a stop made through a screen opened as of a day before the commitment's take-up leaves days away giving back only its days before the stop"
)
func aStopMadeThroughAScreenOpenedAsOfADayBeforeTheCommitmentsTakeUpLeavesDaysAwayGivingBackOnlyItsDaysBeforeTheStop()
    throws
{
    let places = Places()
    let both = try mallorcaWithGymStopped(places)
    #expect(try takeUpAgain(on: screen(places, asOf: date(2026, 10, 17))) == nil)
    let friday = screen(places, asOf: date(2026, 10, 16))
    stopKeeping(both[0], on: friday)

    let long = friday.changeDaysAway(
        try theDaysAway(friday), named: "Mallorca", from: date(2026, 10, 13),
        through: date(2026, 10, 25), over: both)
    let short = friday.changeDaysAway(
        try theDaysAway(friday), named: "Mallorca", from: date(2026, 10, 13),
        through: date(2026, 10, 18), over: both)
    let removed = try remove(friday)

    #expect(long == nil)
    #expect(short == nil)
    #expect(removed == nil)
    let kept = try roster(at: places)
    expect("Gym", due: [13, 14], notDue: Array(16...26), in: kept)
    expect("Run", due: Array(16...26), notDue: [], in: kept)
}
