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
