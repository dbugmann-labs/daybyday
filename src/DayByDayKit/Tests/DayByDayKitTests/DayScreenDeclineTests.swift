import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private let januaryFirst = date(2026, 1, 1)
private let monday = date(2026, 8, 31)
private let tuesday = date(2026, 9, 1)
private let wednesday = date(2026, 9, 2)
private let saturday = date(2026, 8, 29)
private let gymSchedule = Schedule.weekdays([.monday, .wednesday, .saturday])

private struct Places {
    let record: URL
    let roster: URL
    let oneOffs: URL

    init() {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        record = directory.appendingPathComponent("record.json")
        roster = directory.appendingPathComponent("roster.json")
        oneOffs = directory.appendingPathComponent("one-offs.json")
    }

    var contents: [Data?] { [record, roster, oneOffs].map { try? Data(contentsOf: $0) } }
}

private func commitment(
    _ name: String, schedule: Schedule = gymSchedule, kind: Commitment.Kind = .tick
) -> Commitment {
    Commitment(name: name, schedule: schedule, keptFrom: januaryFirst, kind: kind)!
}

@MainActor
private func screen(
    _ commitments: [Commitment], asOf today: CalendarDate = monday, at places: Places = Places()
) -> DayScreen {
    DayScreen(
        startingFrom: commitments, asOf: today, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOffs)
}

@MainActor
private func row(_ name: String, in day: DayScreen) -> DayView.Row {
    day.dayView.rows.first { $0.name == name }!
}

private func setWritable(_ directory: URL, _ writable: Bool) throws {
    try FileManager.default.setAttributes(
        [.posixPermissions: writable ? 0o700 : 0o500], ofItemAtPath: directory.path)
}

@MainActor
@Test("a day screen offers declining a row of every kind but a weekly quota's whose day holds nothing")
func aDayScreenOffersDecliningARowOfEveryKindButAWeeklyQuotasWhoseDayHoldsNothing() throws {
    let places = Places()
    let day = screen(
        [
            commitment("Gym"),
            commitment("Weight", kind: .number(range: Commitment.Range(lowest: 40, highest: 150)!)),
            commitment("Journal", kind: .note),
            commitment("Protein", kind: .total(target: Commitment.Target(120)!)),
            commitment("Yuno", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 2)!)),
        ], at: places)
    let before = places.contents

    for name in ["Gym", "Weight", "Journal", "Protein"] {
        #expect(day.offersDecline(for: row(name, in: day)))
    }
    #expect(!day.offersDecline(for: row("Yuno", in: day)))

    day.showPreviousDay()
    day.showPreviousDay()
    #expect(day.dayView.date == saturday)
    #expect(day.offersDecline(for: row("Gym", in: day)))

    for _ in 0..<4 { day.showNextDay() }
    #expect(day.dayView.date == wednesday)
    #expect(day.dayView.rows.allSatisfy { !day.offersDecline(for: $0) })

    #expect(places.contents == before)
}

@MainActor
@Test("a day screen offers no decline for a row whose day holds a record")
func aDayScreenOffersNoDeclineForARowWhoseDayHoldsARecord() throws {
    let day = screen([
        commitment("Gym"),
        commitment("Weight", kind: .number(range: nil)),
        commitment("Journal", kind: .note),
        commitment("Protein", kind: .total(target: Commitment.Target(120)!)),
    ])

    try day.tick(row("Gym", in: day))
    try day.enter("70.5", on: row("Weight", in: day))
    try day.enter("Ran 8k.", on: row("Journal", in: day))
    try day.enter("30", on: row("Protein", in: day))

    #expect(day.dayView.rows.count == 4)
    #expect(day.dayView.rows.allSatisfy { !day.offersDecline(for: $0) })
    #expect(!row("Protein", in: day).isKept)

    try day.tick(row("Gym", in: day))

    #expect(day.offersDecline(for: row("Gym", in: day)))
}

@MainActor
@Test("a day screen offers no decline where it is not keeping its record, for a row of a day either side, or for a row a shift took its due day from")
func aDayScreenOffersNoDeclineWhereItIsNotKeepingItsRecordForARowOfADayEitherSideOrForARowAShiftTookItsDueDayFrom() throws {
    let places = Places()
    try FileManager.default.createDirectory(
        at: places.record.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a record is written as".utf8).write(to: places.record)
    let unreadable = screen([commitment("Gym")], at: places)

    #expect(unreadable.dayView.rows.count == 1)
    #expect(!unreadable.offersDecline(for: unreadable.dayView.rows[0]))

    let run = commitment("Run", schedule: .weekdays([.tuesday, .thursday]))
    let neighbour = screen([run])

    #expect(neighbour.dayView.rows.isEmpty)
    let after = try #require(neighbour.nextDayView?.rows.first)
    #expect(!neighbour.offersDecline(for: after))

    let afterwards = screen([commitment("Gym")], asOf: tuesday)
    let before = try #require(afterwards.previousDayView?.rows.first)
    #expect(afterwards.dayView.rows.isEmpty)
    #expect(!afterwards.offersDecline(for: before))

    let shifted = Places()
    let store = try RosterStore(at: shifted.roster)
    let gym = commitment("Gym")
    try store.add(gym)
    try store.shift(gym, from: monday, to: tuesday)
    let day = screen([], asOf: tuesday, at: shifted)

    #expect(day.dayView.rows.map(\.rhythmInWords) == ["from Mon 31 Aug"])
    #expect(day.offersDecline(for: day.dayView.rows[0]))
    day.showPreviousDay()
    #expect(day.dayView.rows.map(\.rhythmInWords) == ["to Tue 1 Sep"])
    #expect(!day.offersDecline(for: day.dayView.rows[0]))
}

@MainActor
@Test("a row declined with a reason is kept at the record place, and its row says it is declined with that reason")
func aRowDeclinedWithAReasonIsKeptAtTheRecordPlaceAndItsRowSaysItIsDeclinedWithThatReason() throws {
    let places = Places()
    let run = commitment("Run")
    let day = screen([run], at: places)

    try day.decline(day.dayView.rows[0], reason: "  Knee still sore.  ")

    #expect(day.notice == nil)
    let declined = day.dayView.rows[0]
    #expect(declined.isDeclined)
    #expect(declined.declineReason == "Knee still sore.")
    #expect(!declined.isKept)
    #expect(day.offersDecline(for: declined))
    let store = try RecordStore(at: places.record)
    #expect(store.history.decline(for: run, on: monday)?.reason == "Knee still sore.")
}

@MainActor
@Test("a row declined with a blank reason is declined with none")
func aRowDeclinedWithABlankReasonIsDeclinedWithNone() throws {
    let day = screen([commitment("Gym"), commitment("Run")])

    try day.decline(row("Gym", in: day), reason: "")
    try day.decline(row("Run", in: day), reason: "   \n")

    #expect(day.notice == nil)
    for name in ["Gym", "Run"] {
        #expect(row(name, in: day).isDeclined)
        #expect(row(name, in: day).declineReason == nil)
    }
}

@MainActor
@Test("a declined row offers its tick or entry, and a record made through it replaces the decline")
func aDeclinedRowOffersItsTickOrEntryAndARecordMadeThroughItReplacesTheDecline() throws {
    func kinds() -> [Commitment] {
        [
            commitment("Gym"),
            commitment("Weight", kind: .number(range: nil)),
            commitment("Journal", kind: .note),
            commitment("Protein", kind: .total(target: Commitment.Target(120)!)),
        ]
    }
    let day = screen(kinds())
    for name in ["Gym", "Weight", "Journal", "Protein"] {
        try day.decline(row(name, in: day), reason: "Away")
        #expect(row(name, in: day).isDeclined)
    }

    try day.tick(row("Gym", in: day))
    try day.enter("70.5", on: row("Weight", in: day))
    try day.enter("Ran 8k.", on: row("Journal", in: day))
    try day.enter("30", on: row("Protein", in: day))

    #expect(day.notice == nil)
    #expect(day.dayView.rows.allSatisfy { !$0.isDeclined })
    #expect(row("Gym", in: day).isKept)
    #expect(row("Weight", in: day).isKept)
    #expect(row("Journal", in: day).isKept)
    #expect(!row("Protein", in: day).isKept)
    #expect(row("Protein", in: day).totalEntry(asOf: monday)?.soFarOfTarget == "30 of 120")

    let blank = screen(kinds())
    for name in ["Weight", "Journal"] {
        try blank.decline(row(name, in: blank), reason: "Away")
        try blank.enter("", on: row(name, in: blank))
        #expect(row(name, in: blank).isDeclined)
        #expect(row(name, in: blank).declineReason == "Away")
    }
}

@MainActor
@Test("a declined row's reason is changed or cleared, and the decline stands")
func aDeclinedRowsReasonIsChangedOrClearedAndTheDeclineStands() throws {
    let places = Places()
    let gym = commitment("Gym")
    let day = screen([gym], at: places)

    try day.decline(day.dayView.rows[0], reason: "Away")
    try day.decline(day.dayView.rows[0], reason: "Away at a wedding")

    #expect(day.dayView.rows[0].isDeclined)
    #expect(day.dayView.rows[0].declineReason == "Away at a wedding")

    try day.decline(day.dayView.rows[0], reason: "")

    #expect(day.notice == nil)
    #expect(day.dayView.rows[0].isDeclined)
    #expect(day.dayView.rows[0].declineReason == nil)
    let kept = try #require(try RecordStore(at: places.record).history.decline(for: gym, on: monday))
    #expect(kept.reason == nil)
}

@MainActor
@Test("declining a row whose decline is not offered changes nothing and tells nothing")
func decliningARowWhoseDeclineIsNotOfferedChangesNothingAndTellsNothing() throws {
    let places = Places()
    let day = screen(
        [
            commitment("Gym"), commitment("Run", schedule: .weekdays([.tuesday, .thursday])),
            commitment("Yuno", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 2)!)),
        ], at: places)
    try day.tick(row("Gym", in: day))
    let after = try #require(day.nextDayView?.rows.first { $0.name == "Run" })
    let before = places.contents

    try day.decline(row("Gym", in: day), reason: "Away")
    try day.decline(row("Yuno", in: day), reason: "Away")
    try day.decline(after, reason: "Away")
    day.showNextDay()
    day.showNextDay()
    try day.decline(row("Gym", in: day), reason: "Away")
    day.showToday()

    #expect(day.notice == nil)
    #expect(row("Gym", in: day).isKept)
    #expect(day.dayView.rows.allSatisfy { !$0.isDeclined })
    #expect(places.contents == before)
}

@MainActor
@Test("a decline the record place cannot keep is refused and told on its row")
func aDeclineTheRecordPlaceCannotKeepIsRefusedAndToldOnItsRow() throws {
    let places = Places()
    let day = screen(
        [commitment("Gym"), commitment("Journaling", schedule: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]))],
        at: places)
    let directory = places.record.deletingLastPathComponent()
    let gym = row("Gym", in: day)
    try setWritable(directory, false)
    defer { try? setWritable(directory, true) }

    #expect(throws: (any Error).self) { try day.decline(gym, reason: "Away") }

    #expect(day.notice?.row == gym)
    #expect(day.notice?.cause == nil)
    #expect(!row("Gym", in: day).isDeclined)

    try setWritable(directory, true)
    try day.decline(row("Journaling", in: day), reason: "")

    #expect(day.notice == nil)
}

@MainActor
@Test("a declined row's decline taken back leaves its day holding nothing")
func aDeclinedRowsDeclineTakenBackLeavesItsDayHoldingNothing() throws {
    let places = Places()
    let day = screen([commitment("Gym")], at: places)
    try day.decline(day.dayView.rows[0], reason: "Away")

    try day.takeBackDecline(on: day.dayView.rows[0])

    let back = day.dayView.rows[0]
    #expect(!back.isDeclined)
    #expect(!back.isKept)
    #expect(day.offersDecline(for: back))
    #expect(back.tick(asOf: monday) != nil)
    #expect(try RecordStore(at: places.record).history == History())
}

@MainActor
@Test("taking back the decline of a row that is not declined changes nothing and tells nothing")
func takingBackTheDeclineOfARowThatIsNotDeclinedChangesNothingAndTellsNothing() throws {
    let places = Places()
    let day = screen([commitment("Gym"), commitment("Run")], at: places)
    try day.tick(row("Gym", in: day))
    let before = places.contents

    try day.takeBackDecline(on: row("Gym", in: day))
    try day.takeBackDecline(on: row("Run", in: day))

    #expect(day.notice == nil)
    #expect(row("Gym", in: day).isKept)
    #expect(places.contents == before)
}

@MainActor
@Test("a decline's take-back or new reason the record place cannot keep is refused and told on its row")
func aDeclinesTakeBackOrNewReasonTheRecordPlaceCannotKeepIsRefusedAndToldOnItsRow() throws {
    let places = Places()
    let day = screen([commitment("Gym")], at: places)
    try day.decline(day.dayView.rows[0], reason: "Away")
    let declined = day.dayView.rows[0]
    let directory = places.record.deletingLastPathComponent()
    try setWritable(directory, false)
    defer { try? setWritable(directory, true) }

    #expect(throws: (any Error).self) { try day.takeBackDecline(on: declined) }
    #expect(day.notice?.row == declined)
    #expect(day.notice?.cause == nil)

    try setWritable(directory, true)
    try day.decline(declined, reason: "Away")
    #expect(day.notice == nil)
    try setWritable(directory, false)

    #expect(throws: (any Error).self) { try day.decline(declined, reason: "Ill") }
    #expect(day.notice?.row == declined)
    #expect(day.dayView.rows[0].isDeclined)
    #expect(day.dayView.rows[0].declineReason == "Away")
}

private func dayView(of commitment: Commitment, declining decline: Decline?) -> DayView {
    var history = History()
    if let decline {
        history.add(decline)
    }
    var held = Roster()
    _ = held.add(commitment)
    return DayView(of: held.groups, on: monday, in: history)
}

@Test("two rows alike but for whether their day is declined, or for its reason, are different rows")
func twoRowsAlikeButForWhetherTheirDayIsDeclinedOrForItsReasonAreDifferentRows() {
    let gym = commitment("Gym")
    func declined(_ reason: String?) -> DayView.Row {
        dayView(of: gym, declining: Decline(for: gym, on: monday, reason: reason)!).rows[0]
    }
    let none = dayView(of: gym, declining: nil).rows[0]
    let away = declined("Away")
    let ill = declined("Ill")

    #expect(none != away)
    #expect(none != ill)
    #expect(away != ill)
    #expect([none, away, ill].allSatisfy { !$0.isKept })
    #expect(declined(nil) != none)
    #expect(declined(nil) != away)
    #expect(declined(nil) != ill)
    #expect(declined("Away") == away)
}

@Test("a declined row gives back that it is declined and its whole reason, and says its rhythm")
func aDeclinedRowGivesBackThatItIsDeclinedAndItsWholeReasonAndSaysItsRhythm() {
    let run = commitment("Run")
    let magnesium = commitment(
        "Magnesium",
        schedule: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]))
    let gym = commitment("Gym")
    let reason = "Knee still sore after Tuesday's run, resting it until the weekend."
    var history = History()
    history.add(Decline(for: run, on: monday, reason: reason)!)
    history.add(Decline(for: magnesium, on: monday, reason: nil)!)
    var held = Roster()
    _ = held.add(run)
    _ = held.add(magnesium)
    _ = held.add(gym)

    let rows = DayView(of: held.groups, on: monday, in: history).rows

    #expect(rows.map(\.name) == ["Run", "Magnesium", "Gym"])
    #expect(rows[0].isDeclined)
    #expect(rows[0].declineReason == reason)
    #expect(rows[0].rhythmInWords == "Mon, Wed, Sat")
    #expect(!rows[0].isKept)
    #expect(rows[1].isDeclined)
    #expect(rows[1].declineReason == nil)
    #expect(rows[1].rhythmInWords == "Every day")
    #expect(!rows[2].isDeclined)
    #expect(rows[2].declineReason == nil)
}

@MainActor
@Test("a day screen offers no day to shift a declined row")
func aDayScreenOffersNoDayToShiftADeclinedRow() throws {
    let day = screen([commitment("Gym")])
    try day.decline(day.dayView.rows[0], reason: "")

    #expect(day.shiftDays(for: day.dayView.rows[0]).isEmpty)

    try day.takeBackDecline(on: day.dayView.rows[0])

    #expect(
        day.shiftDays(for: day.dayView.rows[0]).map(\.date) == [
            date(2026, 8, 30), tuesday, date(2026, 9, 3), date(2026, 9, 4), date(2026, 9, 6),
        ])
}
