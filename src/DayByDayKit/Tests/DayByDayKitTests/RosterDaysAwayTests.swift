import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private func freshPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("roster.json")
}

private let gymID = "11111111-1111-1111-1111-111111111111"
private let runID = "22222222-2222-2222-2222-222222222222"
private let sharedID = "44444444-4444-4444-4444-444444444444"

private func day(_ month: Int, _ day: Int) -> String {
    #"{ "year": 2026, "month": \#(month), "day": \#(day) }"#
}

/// One days away as a roster document writes it.
private func span(
    _ name: String?, from first: String, through last: String, over commitments: [String],
    identity: String = UUID().uuidString
) -> String {
    let named = name.map { #""\#($0)""# } ?? "null"
    let over = commitments.map { #""\#($0)""# }.joined(separator: ",")
    return """
        { "identity": "\(identity)", "name": \(named), "firstDay": \(first),
          "lastDay": \(last), "commitments": [\(over)] }
        """
}

/// A roster of "Gym" and "Run", each on every weekday kept from 1 January 2026, in the form given;
/// `daysAway` is the raw JSON list, or `nil` to leave the key out.
private func rosterJSON(version: Int, daysAway: String?) -> Data {
    let entries = [("Gym", gymID), ("Run", runID)].map { name, id in
        """
        {
          "commitment": {
            "name": "\(name)",
            "keptFrom": { "year": 2026, "month": 1, "day": 1 },
            "schedule": { "weekdays": ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"] },
            "identity": "\(id)"
          },
          "category": null,
          "usualAmounts": [],
          "shifts": []
        }
        """
    }.joined(separator: ",")
    let spans = daysAway.map { #""daysAway": \#($0),"# } ?? ""
    return Data(
        """
        { "version": \(version), "emptied": false, \(spans) "commitments": [\(entries)] }
        """.utf8)
}

private func opened(_ bytes: Data) throws -> (place: URL, result: Result<RosterStore, any Error>) {
    let place = freshPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try bytes.write(to: place)
    return (place, Result { try RosterStore(at: place) })
}

@MainActor
@Test("days away kept at a roster place are read back after the app is closed and opened again")
func daysAwayKeptAtARosterPlaceAreReadBackAfterTheAppIsClosedAndOpenedAgain() throws {
    let place = freshPlace()
    let commitments = ["Gym", "Run", "Creatine"].map {
        Commitment(
            name: $0, schedule: .weekdays([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
            keptFrom: date(2026, 1, 1), kind: .tick)!
    }
    let store = try RosterStore(at: place)
    for commitment in commitments {
        try store.add(commitment)
    }
    let flu = CommitmentsScreen(asOf: date(2026, 10, 1), keepingRosterAt: place)
    flu.sayDaysAway(
        named: "Flu", from: date(2026, 10, 1), through: date(2026, 10, 3), over: [commitments[2]])
    let monday = CommitmentsScreen(asOf: date(2026, 10, 12), keepingRosterAt: place)
    monday.sayDaysAway(
        named: "Mallorca", from: date(2026, 10, 13), through: date(2026, 10, 18),
        over: [commitments[1], commitments[0]])
    monday.sayDaysAway(
        named: "", from: date(2026, 10, 20), through: date(2026, 10, 20), over: [commitments[2]])

    let held = try RosterStore(at: place).roster.daysAway

    #expect(held.map(\.name) == ["Flu", "Mallorca", nil])
    #expect(held.map(\.firstDay) == [date(2026, 10, 1), date(2026, 10, 13), date(2026, 10, 20)])
    #expect(held.map(\.lastDay) == [date(2026, 10, 3), date(2026, 10, 18), date(2026, 10, 20)])
    #expect(held.map { $0.commitments.map(\.name) } == [["Creatine"], ["Gym", "Run"], ["Creatine"]])
}

@Test("a roster kept before days away could be said is read with none, and its place left as it was")
func aRosterKeptBeforeDaysAwayCouldBeSaidIsReadWithNoneAndItsPlaceLeftAsItWas() throws {
    let bytes = rosterJSON(version: 9, daysAway: nil)
    let (place, result) = try opened(bytes)

    let store = try result.get()

    #expect(store.roster.commitments.map(\.name) == ["Gym", "Run"])
    #expect(store.roster.daysAway.isEmpty)
    #expect(try Data(contentsOf: place) == bytes)
}

@Test("a roster store holding days away no roster could hold is refused")
func aRosterStoreHoldingDaysAwayNoRosterCouldHoldIsRefused() throws {
    let thirteen = day(10, 13)
    let eighteen = day(10, 18)
    let refused: [String] = [
        "[" + span("Mallorca", from: thirteen, through: eighteen, over: []) + "]",
        "[" + span("Mallorca", from: thirteen, through: eighteen, over: ["33333333-3333-3333-3333-333333333333"]) + "]",
        "[" + span("Mallorca", from: thirteen, through: eighteen, over: [gymID, gymID]) + "]",
        "[" + span("Mallorca", from: day(10, 14), through: day(10, 13), over: [gymID]) + "]",
        "[" + span("   ", from: thirteen, through: eighteen, over: [gymID]) + "]",
        "["
            + span("Mallorca", from: thirteen, through: eighteen, over: [gymID]) + ","
            + span("Lisbon", from: eighteen, through: day(10, 19), over: [gymID, runID]) + "]",
        "["
            + span(
                "Mallorca", from: thirteen, through: day(10, 14), over: [gymID], identity: sharedID)
            + ","
            + span(
                "Lisbon", from: day(10, 20), through: day(10, 21), over: [runID], identity: sharedID)
            + "]",
    ]
    for list in refused {
        let (place, result) = try opened(rosterJSON(version: 10, daysAway: list))
        #expect(throws: RosterStoreError.notAStore(at: place)) { try result.get() }
    }

    let control =
        "["
        + span("Mallorca", from: thirteen, through: eighteen, over: [gymID]) + ","
        + span("Lisbon", from: thirteen, through: eighteen, over: [runID]) + "]"
    let (_, result) = try opened(rosterJSON(version: 10, daysAway: control))
    #expect(try result.get().roster.daysAway.count == 2)
}

@Test("a roster store whose shape and declared form disagree about days away is refused")
func aRosterStoreWhoseShapeAndDeclaredFormDisagreeAboutDaysAwayIsRefused() throws {
    let before = try opened(rosterJSON(version: 9, daysAway: "[]"))
    #expect(throws: RosterStoreError.notAStore(at: before.place)) { try before.result.get() }

    let now = try opened(rosterJSON(version: 10, daysAway: nil))
    #expect(throws: RosterStoreError.notAStore(at: now.place)) { try now.result.get() }
}

@Test("days away removed fill their days from the day after a first day a commitment was kept through")
func daysAwayRemovedFillTheirDaysFromTheDayAfterAFirstDayACommitmentWasKeptThrough() {
    let everyDay = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let old = Commitment(name: "Creatine", schedule: everyDay, keptFrom: date(2026, 1, 1), kind: .tick)!
    let resumed = Commitment(
        era: old, schedule: everyDay, keptFrom: date(2026, 10, 15), kind: .tick)!
    let span = Roster.Span(
        identity: .minted(), name: nil, firstDay: date(2026, 10, 12), lastDay: date(2026, 10, 14),
        commitments: [old.identity])
    var held = Roster()
    held.entries = [
        Roster.Entry(commitment: resumed, keptUntil: nil, category: nil, usualAmounts: []),
        Roster.Entry(commitment: old, keptUntil: date(2026, 10, 12), category: nil, usualAmounts: []),
    ]
    held.spans = [span]

    held.removeDaysAway(span.identity)

    #expect(held.eras(of: old).count == 1)
    for due in [date(2026, 10, 12), date(2026, 10, 13), date(2026, 10, 14), date(2026, 10, 15)] {
        #expect(held.groups(on: due).flatMap(\.commitments).contains { $0.isDue(on: due) })
    }
}
