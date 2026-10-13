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

/// One days away as a roster document writes it in form 11, `remembers` the raw JSON list of the
/// commitments it remembers a stop for and the day, or `nil` to leave the key out.
private func span(
    _ name: String?, from first: String, through last: String, over commitments: [String],
    identity: String = UUID().uuidString, remembers: String? = "[]"
) -> String {
    let named = name.map { #""\#($0)""# } ?? "null"
    let over = commitments.map { #""\#($0)""# }.joined(separator: ",")
    return """
        { "identity": "\(identity)", "name": \(named), "firstDay": \(first),
          "lastDay": \(last), "commitments": [\(over)]\(remembers.map { #", "remembers": \#($0)"# } ?? "") }
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
        let (place, result) = try opened(rosterJSON(version: 11, daysAway: list))
        #expect(throws: RosterStoreError.notAStore(at: place)) { try result.get() }
    }

    let control =
        "["
        + span("Mallorca", from: thirteen, through: eighteen, over: [gymID]) + ","
        + span("Lisbon", from: thirteen, through: eighteen, over: [runID]) + "]"
    let (_, result) = try opened(rosterJSON(version: 11, daysAway: control))
    #expect(try result.get().roster.daysAway.count == 2)
}

@Test("a roster store whose shape and declared form disagree about days away is refused")
func aRosterStoreWhoseShapeAndDeclaredFormDisagreeAboutDaysAwayIsRefused() throws {
    let before = try opened(rosterJSON(version: 9, daysAway: "[]"))
    #expect(throws: RosterStoreError.notAStore(at: before.place)) { try before.result.get() }

    let now = try opened(rosterJSON(version: 10, daysAway: nil))
    #expect(throws: RosterStoreError.notAStore(at: now.place)) { try now.result.get() }
}

/// One era of "Gym" or "Run" on every weekday, kept from `from` until `until` or still.
private func era(_ name: String, _ id: String, from: String, until: String? = nil) -> String {
    """
    {
      "commitment": {
        "name": "\(name)",
        "keptFrom": \(from),
        "schedule": { "weekdays": ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"] },
        "identity": "\(id)"
      },
      "keptUntil": \(until ?? "null"),
      "category": null,
      "usualAmounts": [],
      "shifts": []
    }
    """
}

private func rosterJSON(version: Int, eras: [String], daysAway: String) -> Data {
    Data(
        """
        { "version": \(version), "emptied": false, "daysAway": \(daysAway),
          "commitments": [\(eras.joined(separator: ","))] }
        """.utf8)
}

@MainActor
@Test(
    "a roster kept before days away remembered a stop is read as remembering the later of their last day and the last day kept"
)
func aRosterKeptBeforeDaysAwayRememberedAStopIsReadAsRememberingTheLaterOfTheirLastDayAndTheLastDayKept()
    throws
{
    let january1 = day(1, 1)
    let run = [
        era("Run", runID, from: day(10, 4)), era("Run", runID, from: january1, until: day(9, 30)),
    ]
    let flu = "[" + span("Flu", from: day(10, 1), through: day(10, 3), over: [gymID, runID], remembers: nil) + "]"
    let first = rosterJSON(
        version: 10, eras: [era("Gym", gymID, from: january1, until: day(9, 30))] + run, daysAway: flu)
    let second = rosterJSON(
        version: 10,
        eras: [
            era("Gym", gymID, from: day(10, 4), until: day(10, 11)),
            era("Gym", gymID, from: january1, until: day(9, 30)),
        ] + run, daysAway: flu)

    let (firstPlace, firstResult) = try opened(first)
    let (secondPlace, secondResult) = try opened(second)

    _ = try firstResult.get()
    _ = try secondResult.get()
    #expect(try Data(contentsOf: firstPlace) == first)
    #expect(try Data(contentsOf: secondPlace) == second)

    let monday12 = date(2026, 10, 12)
    for place in [firstPlace, secondPlace] {
        let screen = CommitmentsScreen(asOf: monday12, keepingRosterAt: place)
        let flu = try #require(screen.pastDaysAway.first)
        #expect(
            screen.changeDaysAway(
                flu, named: "Flu", from: date(2026, 10, 1), through: date(2026, 10, 7),
                over: flu.commitments) == nil)
        screen.askToRemove(try #require(screen.pastDaysAway.first))
        #expect(screen.confirmRemovingDaysAway() == nil)
    }
    let atFirst = try RosterStore(at: firstPlace).roster
    #expect(dueOn(atFirst, "Gym", date(2026, 10, 3)))
    #expect(!dueOn(atFirst, "Gym", date(2026, 10, 4)))
    let atSecond = try RosterStore(at: secondPlace).roster
    #expect(dueOn(atSecond, "Gym", date(2026, 10, 6)))
    #expect(dueOn(atSecond, "Gym", date(2026, 10, 11)))
    #expect(!dueOn(atSecond, "Gym", monday12))
}

private func dueOn(_ roster: Roster, _ name: String, _ day: CalendarDate) -> Bool {
    roster.groups(on: day).flatMap(\.commitments).contains { $0.name == name && $0.isDue(on: day) }
}

@Test("a roster store whose days away remember what no roster could is refused")
func aRosterStoreWhoseDaysAwayRememberWhatNoRosterCouldIsRefused() throws {
    let eras = [
        era("Gym", gymID, from: day(1, 1), until: day(9, 30)), era("Run", runID, from: day(1, 1)),
    ]
    func flu(over commitments: [String], remembers: String?) -> String {
        "[" + span("Flu", from: day(10, 1), through: day(10, 3), over: commitments, remembers: remembers) + "]"
    }
    func remembering(_ id: String, _ when: String) -> String {
        #"{ "commitment": "\#(id)", "day": \#(when) }"#
    }
    let saturday3 = day(10, 3)
    let refused: [(Int, String)] = [
        (11, flu(over: [runID], remembers: "[" + remembering(gymID, saturday3) + "]")),
        (
            11,
            flu(
                over: [gymID, runID],
                remembers: "[" + remembering(gymID, saturday3) + "," + remembering(gymID, saturday3) + "]")
        ),
        (11, flu(over: [gymID, runID], remembers: "[" + remembering(gymID, day(9, 29)) + "]")),
        (11, flu(over: [gymID, runID], remembers: "[]")),
        (11, flu(over: [gymID, runID], remembers: nil)),
        (10, flu(over: [gymID, runID], remembers: "[" + remembering(gymID, saturday3) + "]")),
    ]
    for (version, list) in refused {
        let (place, result) = try opened(rosterJSON(version: version, eras: eras, daysAway: list))
        #expect(throws: RosterStoreError.notAStore(at: place)) { try result.get() }
    }

    let control = flu(over: [gymID, runID], remembers: "[" + remembering(gymID, saturday3) + "]")
    let (_, result) = try opened(rosterJSON(version: 11, eras: eras, daysAway: control))
    #expect(try result.get().roster.daysAway.count == 1)
}
