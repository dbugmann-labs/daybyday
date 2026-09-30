import Foundation
import Testing

@testable import DayByDayKit

private typealias Typed = CommitmentsScreen.TypedUsualAmount

private func freshRosterPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("roster.json")
}

private func freshRosterAndRecordPlaces() -> (roster: URL, record: URL) {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    return (
        directory.appendingPathComponent("roster.json"),
        directory.appendingPathComponent("record.json")
    )
}

private let allSeven: Rhythm = .weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])
private let allSevenSchedule: Schedule = .weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])
private let monday = CalendarDate(year: 2026, month: 8, day: 31)!
private let newYear = CalendarDate(year: 2026, month: 1, day: 1)!

private func usual(_ amount: Decimal, _ name: String? = nil) -> Commitment.UsualAmount {
    Commitment.UsualAmount(amount, named: name)!
}

@MainActor
private func definingProtein(
    _ typed: [Typed], on screen: CommitmentsScreen, name: String = "Protein", target: String = "120"
) -> CommitmentsScreen.Refusal? {
    screen.define(
        name: name, on: allSeven, keptFrom: monday, under: nil, kind: .total, target: target,
        usualAmounts: typed)
}

@MainActor
@Test("a total commitment defined with usual amounts through a commitments screen declares them")
func aTotalCommitmentDefinedWithUsualAmountsThroughACommitmentsScreenDeclaresThem() throws {
    let place = freshRosterPlace()
    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: place)

    let refusal = definingProtein(
        [Typed(amount: "35", name: "Müesli"), Typed(amount: "20", name: "")], on: screen)

    #expect(refusal == nil)
    let protein = try #require(screen.kept.first)
    #expect(
        screen.whatItIsMadeOf(protein)?.usualAmounts == [usual(20), usual(35, "Müesli")])
    let store = try RosterStore(at: place)
    #expect(store.roster.usualAmounts(of: protein) == [usual(20), usual(35, "Müesli")])
}

@MainActor
@Test("a usual amount's amount is read as a target is read")
func aUsualAmountsAmountIsReadAsATargetIsRead() throws {
    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: freshRosterPlace())

    let refusal = definingProtein(
        [Typed(amount: "  35,5\n", name: "Müesli"), Typed(amount: "0000030.50", name: "")],
        on: screen)

    #expect(refusal == nil)
    let protein = try #require(screen.kept.first)
    #expect(
        screen.whatItIsMadeOf(protein)?.usualAmounts == [usual(Decimal(string: "30.5")!), usual(Decimal(string: "35.5")!, "Müesli")])
}

@MainActor
@Test("a usual amount typed with both its fields blank is no usual amount and is not refused")
func aUsualAmountTypedWithBothItsFieldsBlankIsNoUsualAmountAndIsNotRefused() throws {
    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: freshRosterPlace())

    let refusal = definingProtein(
        [
            Typed(amount: "20", name: ""), Typed(amount: "25", name: ""),
            Typed(amount: "", name: ""),
            Typed(amount: "30", name: ""), Typed(amount: "35", name: ""),
            Typed(amount: "  ", name: "\t"),
            Typed(amount: "40", name: ""),
        ], on: screen)

    #expect(refusal == nil)
    let protein = try #require(screen.kept.first)
    #expect(
        screen.whatItIsMadeOf(protein)?.usualAmounts == [20, 25, 30, 35, 40].map { usual($0) })
}

@MainActor
@Test("a usual amount that is not an amount is refused under its row")
func aUsualAmountThatIsNotAnAmountIsRefusedUnderItsRow() throws {
    let place = freshRosterPlace()
    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: place)

    let refusal = definingProtein(
        [Typed(amount: "20", name: ""), Typed(amount: "", name: "Shake")], on: screen)

    #expect(refusal == .usualAmountIsNotAnAmount(1))
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(field: .usualAmounts, refusal: refusal!))
    #expect(screen.refusedChange == .defining(.usualAmountIsNotAnAmount(1)))

    let thirtyNineNines = String(repeating: "9", count: 39)
    for text in ["abc", "0", "-5", thirtyNineNines] {
        let again = definingProtein(
            [Typed(amount: "20", name: ""), Typed(amount: text, name: "Shake")], on: screen)
        #expect(again == .usualAmountIsNotAnAmount(1), "\(text)")
    }

    #expect(try RosterStore(at: place).roster.commitments.isEmpty)
}

@MainActor
@Test("a usual amount alike with one typed before it is refused under its row")
func aUsualAmountAlikeWithOneTypedBeforeItIsRefusedUnderItsRow() throws {
    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: freshRosterPlace())

    let refusal = definingProtein(
        [
            Typed(amount: "35", name: "Müesli"), Typed(amount: "20", name: ""),
            Typed(amount: "35", name: " müesli "),
        ], on: screen)

    #expect(refusal == .usualAmountAlike(2))
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(field: .usualAmounts, refusal: refusal!))

    let unnamed = definingProtein(
        [Typed(amount: "20", name: ""), Typed(amount: "20.0", name: "")], on: screen)
    #expect(unnamed == .usualAmountAlike(1))

    let differentNames = definingProtein(
        [Typed(amount: "35", name: "Müesli"), Typed(amount: "35", name: "Muesli")], on: screen)
    #expect(differentNames == nil)
}

@MainActor
@Test("a sixth usual amount is refused under its row")
func aSixthUsualAmountIsRefusedUnderItsRow() throws {
    let place = freshRosterPlace()
    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: place)
    let six = ["10", "20", "30", "40", "50", "60"].map { Typed(amount: $0, name: "") }

    let refusal = definingProtein(six, on: screen)

    #expect(refusal == .moreThanFiveUsualAmounts(5))
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(field: .usualAmounts, refusal: refusal!))
    #expect(try RosterStore(at: place).roster.commitments.isEmpty)

    var withABlank = six
    withABlank.insert(Typed(amount: "", name: ""), at: 2)
    #expect(definingProtein(withABlank, on: screen) == .moreThanFiveUsualAmounts(6))
}

@MainActor
@Test("usual amounts typed on a kind that is not a total are ignored rather than refused")
func usualAmountsTypedOnAKindThatIsNotATotalAreIgnoredRatherThanRefused() throws {
    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: freshRosterPlace())
    let typed = [Typed(amount: "abc", name: "Shake"), Typed(amount: "20", name: "")]

    let gym = screen.define(
        name: "Gym", on: allSeven, keptFrom: monday, under: nil, kind: .tick, usualAmounts: typed)
    #expect(gym == nil)
    let gymCommitment = try #require(screen.kept.first { $0.name == "Gym" })
    #expect(screen.whatItIsMadeOf(gymCommitment)?.kind == .tick)
    #expect(screen.whatItIsMadeOf(gymCommitment)?.usualAmounts == [])

    let weight = screen.define(
        name: "Weight", on: allSeven, keptFrom: monday, under: nil, kind: .number, lowest: "40",
        highest: "150", usualAmounts: typed)
    let journal = screen.define(
        name: "Journal", on: allSeven, keptFrom: monday, under: nil, kind: .note,
        usualAmounts: typed)
    #expect(weight == nil)
    #expect(journal == nil)
    for commitment in screen.kept {
        #expect(screen.whatItIsMadeOf(commitment)?.usualAmounts == [])
    }
    #expect(screen.kept.count == 3)
}

@MainActor
@Test("a usual amount is refused only where nothing else typed on the sheet is, and before the roster is asked")
func aUsualAmountIsRefusedOnlyWhereNothingElseTypedOnTheSheetIsAndBeforeTheRosterIsAsked() throws {
    let place = freshRosterPlace()
    let protein = Commitment(
        name: "Protein", schedule: allSevenSchedule, keptFrom: newYear,
        kind: .total(target: Commitment.Target(120)!))!
    try RosterStore(at: place).add(protein)
    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: place)
    let typed = [Typed(amount: "abc", name: "Shake")]

    #expect(
        definingProtein(typed, on: screen, name: "   ", target: "50") == .namesNothing)
    #expect(
        definingProtein(typed, on: screen, name: "Creatine", target: "abc")
            == .targetIsNotATarget)
    #expect(
        definingProtein(typed, on: screen, name: "PROTEIN", target: "50")
            == .usualAmountIsNotAnAmount(0))
}

@MainActor
@Test("what a commitments screen tells about a usual amount ends when its usual amounts are edited")
func whatACommitmentsScreenTellsAboutAUsualAmountEndsWhenItsUsualAmountsAreEdited() {
    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: freshRosterPlace())

    let refusal = definingProtein([Typed(amount: "abc", name: "Shake")], on: screen)
    screen.sheetFieldEdited(.name)
    screen.sheetFieldEdited(.target)

    #expect(refusal == .usualAmountIsNotAnAmount(0))
    #expect(
        screen.sheetRefusal
            == CommitmentsScreen.SheetRefusal(field: .usualAmounts, refusal: .usualAmountIsNotAnAmount(0)))

    screen.sheetFieldEdited(.usualAmounts)

    #expect(screen.sheetRefusal == nil)
}

@MainActor
@Test("a commitments screen says the usual amounts a total commitment declares, smallest first, and none for another kind")
func aCommitmentsScreenSaysTheUsualAmountsATotalCommitmentDeclaresSmallestFirstAndNoneForAnotherKind()
    throws
{
    let place = freshRosterPlace()
    let protein = Commitment(
        name: "Protein", schedule: allSevenSchedule, keptFrom: newYear,
        kind: .total(target: Commitment.Target(120)!))!
    let gym = Commitment(name: "Gym", schedule: allSevenSchedule, keptFrom: newYear)!
    let store = try RosterStore(at: place)
    try store.add(protein)
    try store.add(gym)
    var declared = store.roster
    declared.declare([usual(35, "Müesli"), usual(20)], for: protein)
    try store.replace(with: declared)

    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: place)

    #expect(screen.whatItIsMadeOf(protein)?.usualAmounts == [usual(20), usual(35, "Müesli")])
    #expect(screen.whatItIsMadeOf(gym)?.usualAmounts == [])
}

/// A total "Protein" of target 120 kept from 1 January 2026 at `place`, declaring `declaring`.
private func keptProtein(at place: URL, declaring: [Commitment.UsualAmount] = []) throws
    -> Commitment
{
    let protein = Commitment(
        name: "Protein", schedule: allSevenSchedule, keptFrom: newYear,
        kind: .total(target: Commitment.Target(120)!))!
    let store = try RosterStore(at: place)
    try store.add(protein)
    var declared = store.roster
    declared.declare(declaring, for: protein)
    try store.replace(with: declared)
    return protein
}

@MainActor
@Test("a total commitment's usual amounts changed through a commitments screen put no era on it and leave the record place as it was")
func aTotalCommitmentsUsualAmountsChangedThroughACommitmentsScreenPutNoEraOnItAndLeaveTheRecordPlaceAsItWas()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let protein = try keptProtein(at: places.roster, declaring: [usual(20)])
    let august3rd = CalendarDate(year: 2026, month: 8, day: 3)!
    try RecordStore(at: places.record).add(Addition(30, for: protein, on: august3rd)!)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)
    let recordBytes = try Data(contentsOf: places.record)

    let refusal = screen.change(
        protein, toName: "Protein", on: allSeven, keptFrom: newYear, under: nil, target: "120",
        usualAmounts: [Typed(amount: "35", name: "Müesli"), Typed(amount: "20", name: "")])

    #expect(refusal == nil)
    let later = try RosterStore(at: places.roster)
    #expect(later.roster.eras(of: protein).count == 1)
    #expect(later.roster.usualAmounts(of: protein) == [usual(20), usual(35, "Müesli")])
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test("a target and the usual amounts changed in one save put one era on, and every era declares the new usual amounts")
func aTargetAndTheUsualAmountsChangedInOneSavePutOneEraOnAndEveryEraDeclaresTheNewUsualAmounts()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let protein = try keptProtein(at: places.roster, declaring: [usual(20)])
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        protein, toName: "Protein", on: allSeven, keptFrom: newYear, under: nil, target: "150",
        usualAmounts: [Typed(amount: "35", name: "Müesli")])

    #expect(refusal == nil)
    let later = try RosterStore(at: places.roster)
    let eras = later.roster.eras(of: protein)
    #expect(eras.count == 2)
    #expect(eras.first?.kind == .total(target: Commitment.Target(150)!))
    #expect(later.roster.usualAmounts(of: protein) == [usual(35, "Müesli")])
    #expect(later.roster.entries.allSatisfy { $0.usualAmounts == [usual(35, "Müesli")] })
}

@MainActor
@Test("a stopped total commitment's usual amounts changed through a commitments screen are declared, and it stays stopped")
func aStoppedTotalCommitmentsUsualAmountsChangedThroughACommitmentsScreenAreDeclaredAndItStaysStopped()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let protein = try keptProtein(at: places.roster)
    let gym = Commitment(name: "Gym", schedule: allSevenSchedule, keptFrom: newYear)!
    let store = try RosterStore(at: places.roster)
    try store.add(gym)
    try store.retire(protein, keptUntil: CalendarDate(year: 2026, month: 8, day: 30)!)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        protein, toName: "Protein", on: allSeven, keptFrom: newYear, under: nil,
        usualAmounts: [Typed(amount: "20", name: "")])

    #expect(refusal == nil)
    #expect(screen.stopped.map(\.name) == ["Protein"])
    #expect(screen.whatItIsMadeOf(try #require(screen.stopped.first))?.usualAmounts == [usual(20)])
    #expect(screen.kept.map(\.name) == ["Gym"])
}

/// The bytes at `place` laid out differently — pretty-printed, where a store writes them compact —
/// so a write that changed nothing observable would still change the place's bytes.
private func relaidOut(_ place: URL) throws -> Data {
    let object = try JSONSerialization.jsonObject(with: Data(contentsOf: place))
    let data = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted])
    try data.write(to: place)
    return data
}

@MainActor
@Test("a change naming the usual amounts a total commitment already declares, in another order, changes nothing")
func aChangeNamingTheUsualAmountsATotalCommitmentAlreadyDeclaresInAnotherOrderChangesNothing()
    throws
{
    let places = freshRosterAndRecordPlaces()
    let protein = try keptProtein(at: places.roster, declaring: [usual(20), usual(35, "Müesli")])
    try RecordStore(at: places.record).add(
        Addition(30, for: protein, on: CalendarDate(year: 2026, month: 8, day: 3)!)!)
    let rosterBytes = try relaidOut(places.roster)
    let recordBytes = try relaidOut(places.record)
    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: places.roster, keepingRecordAt: places.record)

    let refusal = screen.change(
        protein, toName: "Protein", on: allSeven, keptFrom: newYear, under: nil, target: "120",
        usualAmounts: [Typed(amount: "35", name: "Müesli"), Typed(amount: "20", name: "")])

    #expect(refusal == nil)
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    #expect(try Data(contentsOf: places.record) == recordBytes)
}

@MainActor
@Test("usual amounts declared through a commitments screen are held by a roster store opened afterwards at the same place")
func usualAmountsDeclaredThroughACommitmentsScreenAreHeldByARosterStoreOpenedAfterwardsAtTheSamePlace()
    throws
{
    let place = freshRosterPlace()
    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: place)

    let defined = screen.define(
        name: "Protein", on: allSeven, keptFrom: newYear, under: nil, kind: .total,
        target: "120",
        usualAmounts: [Typed(amount: "35", name: "Müesli"), Typed(amount: "0.50", name: "")])
    let protein = try #require(screen.kept.first)
    let changed = screen.change(
        protein, toName: "Protein", on: allSeven, keptFrom: newYear, under: nil, target: "150")

    #expect(defined == nil)
    #expect(changed == nil)
    let later = try RosterStore(at: place)
    #expect(later.roster.eras(of: protein).count == 2)
    #expect(
        later.roster.usualAmounts(of: protein)
            == [usual(Decimal(string: "0.5")!), usual(35, "Müesli")])
}

@MainActor
@Test("usual amounts declared over a roster kept before they existed are read back")
func usualAmountsDeclaredOverARosterKeptBeforeTheyExistedAreReadBack() throws {
    let place = freshRosterPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(
        """
        { "version": 6, "emptied": false, "commitments": [
          { "commitment": {
              "kind": { "total": { "target": 120 } },
              "name": "Protein",
              "keptFrom": { "year": 2026, "month": 1, "day": 1 },
              "schedule": { "weekdays": ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"] },
              "identity": "11111111-1111-1111-1111-111111111111" },
            "category": null } ] }
        """.utf8
    ).write(to: place)
    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: place)
    let protein = try #require(screen.kept.first)

    let refusal = screen.change(
        protein, toName: "Protein", on: allSeven, keptFrom: newYear, under: nil,
        usualAmounts: [Typed(amount: "35", name: "Müesli")])

    #expect(refusal == nil)
    let later = try RosterStore(at: place)
    #expect(later.roster.usualAmounts(of: protein) == [usual(35, "Müesli")])
}

private func typedRows(_ amounts: [String]) -> [Typed] {
    amounts.map { Typed(amount: $0, name: "") }
}

@MainActor
@Test("a commitments screen offers another usual amount while fewer than five are on its sheet, blank ones counted")
func aCommitmentsScreenOffersAnotherUsualAmountWhileFewerThanFiveAreOnItsSheetBlankOnesCounted() {
    let screen = CommitmentsScreen(asOf: monday, keepingRosterAt: freshRosterPlace())

    #expect(screen.offersAnotherUsualAmount(after: typedRows(["10", "20", "30", "40"])))
    #expect(screen.offersAnotherUsualAmount(after: []))
    #expect(!screen.offersAnotherUsualAmount(after: typedRows(["10", "20", "30", "40", "50"])))
    #expect(!screen.offersAnotherUsualAmount(after: typedRows(["10", "20", "30", "40", ""])))
    #expect(!screen.offersAnotherUsualAmount(after: typedRows(["10", "20", "30", "40", "abc", "10"])))
}
