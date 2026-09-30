import Foundation
import Testing

@testable import DayByDayKit

private typealias Typed = CommitmentsScreen.TypedUsualAmount

private let allSeven: Rhythm = .weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])
private let monday = CalendarDate(year: 2026, month: 8, day: 31)!
private let newYear = CalendarDate(year: 2026, month: 1, day: 1)!

private func freshPlaces() -> (record: URL, roster: URL, oneOffs: URL) {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    return (
        directory.appendingPathComponent("record.json"),
        directory.appendingPathComponent("roster.json"),
        directory.appendingPathComponent("one-offs.json")
    )
}

private func said(_ amount: String, _ name: String? = nil) -> DayView.UsualAmount {
    DayView.UsualAmount(amount: amount, name: name)
}

/// Takes on `name` as a total with `target` at `roster`, declaring `usual` as typed.
@MainActor
private func takeOn(
    _ name: String, target: String, usual: [Typed] = [], at roster: URL, from: CalendarDate = newYear
) {
    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: roster)
    let refusal = screen.define(
        name: name, on: allSeven, keptFrom: from, under: nil, kind: .total, target: target,
        usualAmounts: usual)
    #expect(refusal == nil)
}

@MainActor
private func dayScreen(_ places: (record: URL, roster: URL, oneOffs: URL)) -> DayScreen {
    DayScreen(
        startingFrom: [], asOf: monday, keepingRecordAt: places.record,
        keepingRosterAt: places.roster, keepingOneOffsAt: places.oneOffs)
}

@MainActor
private func entry(_ screen: DayScreen, _ name: String) throws -> DayView.TotalEntry {
    let row = try #require(screen.dayView.rows.first { $0.name == name })
    return try #require(row.totalEntry(asOf: monday))
}

@MainActor
@Test("a total entry says the usual amounts its commitment declares, smallest first and as declared")
func aTotalEntrySaysTheUsualAmountsItsCommitmentDeclaresSmallestFirstAndAsDeclared() throws {
    let places = freshPlaces()
    takeOn(
        "Protein", target: "120",
        usual: [
            Typed(amount: "45", name: "Chicken breast"), Typed(amount: "35", name: "Müesli"),
            Typed(amount: "20", name: ""), Typed(amount: "35", name: ""),
            Typed(amount: "0.5", name: "Salt"),
        ], at: places.roster)
    takeOn("Creatine", target: "5", at: places.roster)

    let screen = dayScreen(places)

    let protein = try entry(screen, "Protein")
    #expect(protein.soFarOfTarget == "0 of 120")
    #expect(
        protein.usualAmounts == [
            said("0.5", "Salt"), said("20"), said("35"), said("35", "Müesli"),
            said("45", "Chicken breast"),
        ])
    #expect(try entry(screen, "Creatine").usualAmounts == [])
}

@MainActor
@Test("a total entry on a day of an earlier era says the usual amounts its commitment declares now")
func aTotalEntryOnADayOfAnEarlierEraSaysTheUsualAmountsItsCommitmentDeclaresNow() throws {
    let places = freshPlaces()
    let commitments = CommitmentsScreen(asOf: monday, keepingRosterAt: places.roster)
    #expect(
        commitments.define(
            name: "Protein", on: allSeven, keptFrom: newYear, under: nil, kind: .total,
            target: "100", usualAmounts: []) == nil)
    let protein = try #require(commitments.kept.first)
    #expect(
        commitments.change(
            protein, toName: "Protein", on: allSeven, keptFrom: newYear, under: nil,
            target: "120", usualAmounts: [Typed(amount: "20", name: "")]) == nil)
    let screen = dayScreen(places)
    screen.showDay(CalendarDate(year: 2026, month: 8, day: 3)!)

    let row = try #require(screen.dayView.rows.first)
    let shown = try #require(row.totalEntry(asOf: monday))

    #expect(shown.soFarOfTarget == "0 of 100")
    #expect(shown.usualAmounts == [said("20")])
}

@MainActor
@Test("two total rows alike but for the usual amounts their commitment declares are different rows")
func twoTotalRowsAlikeButForTheUsualAmountsTheirCommitmentDeclaresAreDifferentRows() throws {
    let places = freshPlaces()
    takeOn("Protein", target: "120", usual: [Typed(amount: "35", name: "Müesli")], at: places.roster)
    let screen = dayScreen(places)
    let before = try #require(screen.dayView.rows.first)

    let commitments = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let protein = try #require(commitments.kept.first)
    func declare(_ name: String) {
        #expect(
            commitments.change(
                protein, toName: "Protein", on: allSeven, keptFrom: newYear, under: nil,
                target: "120", usualAmounts: [Typed(amount: "35", name: name)]) == nil)
        screen.returnedTo(from: commitments)
    }
    declare("Shake")
    let changed = try #require(screen.dayView.rows.first)
    declare("Müesli")
    let restored = try #require(screen.dayView.rows.first)

    #expect(changed != before)
    #expect(restored == before)
}

@MainActor
private func addTheOnlyUsualAmount(_ screen: DayScreen, of name: String = "Protein") throws {
    let row = try #require(screen.dayView.rows.first { $0.name == name })
    let usual = try #require(row.totalEntry(asOf: monday)?.usualAmounts.last)
    try screen.add(usual, on: row)
}

@MainActor
@Test("a usual amount tapped in a total entry is added to the day, and kept before the day view says so")
func aUsualAmountTappedInATotalEntryIsAddedToTheDayAndKeptBeforeTheDayViewSaysSo() throws {
    let places = freshPlaces()
    takeOn(
        "Protein", target: "120",
        usual: [Typed(amount: "20", name: ""), Typed(amount: "35", name: "Müesli")],
        at: places.roster)
    let rosterBytes = try Data(contentsOf: places.roster)
    let screen = dayScreen(places)

    try addTheOnlyUsualAmount(screen)
    try addTheOnlyUsualAmount(screen)

    #expect(try entry(screen, "Protein").soFarOfTarget == "70 of 120")
    #expect(screen.notice == nil)
    #expect(try entry(dayScreen(places), "Protein").soFarOfTarget == "70 of 120")
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
}

@MainActor
private func proteinWithMuesli(_ places: (record: URL, roster: URL, oneOffs: URL)) {
    takeOn(
        "Protein", target: "120", usual: [Typed(amount: "35", name: "Müesli")], at: places.roster)
}

@MainActor
@Test("an addition made by a usual amount is taken back as the day's last")
func anAdditionMadeByAUsualAmountIsTakenBackAsTheDaysLast() throws {
    let places = freshPlaces()
    proteinWithMuesli(places)
    let screen = dayScreen(places)
    try screen.enter("30", on: screen.dayView.rows[0])
    try addTheOnlyUsualAmount(screen)

    try screen.takeBackLast(on: screen.dayView.rows[0])

    #expect(try entry(screen, "Protein").soFarOfTarget == "30 of 120")
    try screen.takeBackLast(on: screen.dayView.rows[0])
    #expect(try entry(screen, "Protein").soFarOfTarget == "0 of 120")
}

@MainActor
@Test("a usual amount whose addition cannot be kept is refused and leaves the day view as it was")
func aUsualAmountWhoseAdditionCannotBeKeptIsRefusedAndLeavesTheDayViewAsItWas() throws {
    let places = freshPlaces()
    proteinWithMuesli(places)
    let seeded = dayScreen(places)
    try seeded.enter("30", on: seeded.dayView.rows[0])
    let directory = places.record.deletingLastPathComponent()
    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
    defer {
        try? FileManager.default.setAttributes([.posixPermissions: 0o700], ofItemAtPath: directory.path)
    }
    let screen = dayScreen(places)
    let row = screen.dayView.rows[0]

    #expect(throws: RecordStoreError.cannotWrite(at: places.record)) {
        try addTheOnlyUsualAmount(screen)
    }

    #expect(try entry(screen, "Protein").soFarOfTarget == "30 of 120")
    #expect(screen.notice?.row == row)
    #expect(screen.notice?.cause == nil)
}

@MainActor
@Test("a day screen returned to from a commitments screen offers the usual amounts declared there")
func aDayScreenReturnedToFromACommitmentsScreenOffersTheUsualAmountsDeclaredThere() throws {
    let places = freshPlaces()
    takeOn("Protein", target: "120", usual: [Typed(amount: "20", name: "")], at: places.roster)
    let screen = dayScreen(places)
    let commitments = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let protein = try #require(commitments.kept.first)
    #expect(
        commitments.change(
            protein, toName: "Protein", on: allSeven, keptFrom: newYear, under: nil, target: "120",
            usualAmounts: [Typed(amount: "25", name: "Shake")]) == nil)

    screen.returnedTo(from: commitments)

    #expect(try entry(screen, "Protein").usualAmounts == [said("25", "Shake")])
    try addTheOnlyUsualAmount(screen)
    #expect(try entry(screen, "Protein").soFarOfTarget == "25 of 120")
}

@MainActor
@Test("a usual amount that would take the day's sum past what can be kept exactly is refused and told on the row")
func aUsualAmountThatWouldTakeTheDaysSumPastWhatCanBeKeptExactlyIsRefusedAndToldOnTheRow() throws {
    let places = freshPlaces()
    takeOn("Protein", target: "120", usual: [Typed(amount: "20", name: "")], at: places.roster)
    let nines = String(repeating: "9", count: 38)
    let screen = dayScreen(places)
    try screen.enter(nines, on: screen.dayView.rows[0])

    try addTheOnlyUsualAmount(screen)

    #expect(try entry(screen, "Protein").soFarOfTarget == "\(nines) of 120")
    #expect(screen.notice?.row == screen.dayView.rows[0])
    #expect(screen.notice?.cause == "Too large to add")
    #expect(try entry(dayScreen(places), "Protein").soFarOfTarget == "\(nines) of 120")
}

@MainActor
@Test("a usual amount a day screen cannot add on a row changes nothing and tells nothing")
func aUsualAmountADayScreenCannotAddOnARowChangesNothingAndTellsNothing() throws {
    let places = freshPlaces()
    takeOn("Protein", target: "120", usual: [Typed(amount: "20", name: "")], at: places.roster)
    takeOn("Creatine", target: "5", usual: [Typed(amount: "5", name: "")], at: places.roster)
    let commitments = CommitmentsScreen(asOf: monday, keepingRosterAt: places.roster)
    #expect(
        commitments.define(name: "Gym", on: allSeven, keptFrom: newYear, under: nil) == nil)
    let screen = dayScreen(places)
    let row: (String) throws -> DayView.Row = { name in
        try #require(screen.dayView.rows.first { $0.name == name })
    }
    let creatine = try #require(try entry(screen, "Creatine").usualAmounts.first)
    let protein = try #require(try entry(screen, "Protein").usualAmounts.first)

    try screen.add(creatine, on: try row("Protein"))
    try screen.add(protein, on: try row("Gym"))

    #expect(try entry(screen, "Protein").soFarOfTarget == "0 of 120")
    #expect(try entry(screen, "Creatine").soFarOfTarget == "0 of 5")
    #expect(!(try row("Gym")).isKept)
    #expect(screen.notice == nil)

    screen.showNextDay()
    try screen.add(protein, on: try row("Protein"))
    #expect(screen.notice == nil)
    screen.showToday()
    #expect(try entry(screen, "Protein").soFarOfTarget == "0 of 120")

    let unreadable = freshPlaces()
    takeOn("Protein", target: "120", usual: [Typed(amount: "20", name: "")], at: unreadable.roster)
    try FileManager.default.createDirectory(
        at: unreadable.record.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a record is written as".utf8).write(to: unreadable.record)
    let blind = dayScreen(unreadable)
    try blind.add(protein, on: try #require(blind.dayView.rows.first))
    #expect(blind.notice == nil)
    #expect(try Data(contentsOf: unreadable.record) == Data("not what a record is written as".utf8))
}
