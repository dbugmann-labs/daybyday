import Foundation
import Testing

@testable import DayByDayKit

private func date(_ day: Int) -> CalendarDate {
    CalendarDate(year: 2026, month: 10, day: day)!
}

/// A roster store holding "Gym" and "Run", each on every weekday, and the roster it holds.
private func storeWithGymAndRun() throws -> (store: RosterStore, place: URL, gym: Commitment, run: Commitment) {
    let place = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("roster.json")
    let every = Schedule.weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let gym = Commitment(name: "Gym", schedule: every, keptFrom: date(1).adding(days: -200)!)!
    let run = Commitment(name: "Run", schedule: every, keptFrom: date(1).adding(days: -200)!)!
    let store = try RosterStore(at: place)
    try store.add(gym)
    try store.add(run)
    return (store, place, gym, run)
}

/// Every write a roster store makes holds days away to what they may remember, before the place is
/// touched, so no act a screen makes can write a roster the store then refuses to read.
@Test("a roster breaching what days away may remember is refused before it is written")
func aRosterBreachingWhatDaysAwayMayRememberIsRefusedBeforeItIsWritten() throws {
    let (store, place, gym, run) = try storeWithGymAndRun()
    let written = try Data(contentsOf: place)

    func span(
        over commitments: [Commitment], remembering remembers: [Commitment.Identity: [Roster.Stop]]
    ) -> Roster.Span {
        Roster.Span(
            identity: .minted(), name: nil, firstDay: date(1), lastDay: date(3),
            commitments: commitments.map(\.identity), remembers: remembers)
    }
    let breaches: [(String, Roster.Span)] = [
        // I1: a stop of a commitment the days away are not over.
        ("I1", span(over: [run], remembering: [gym.identity: [Roster.Stop(day: date(3), takeUp: nil)]])),
        // I2: two stops of one commitment on one day.
        (
            "I2",
            span(
                over: [gym],
                remembering: [
                    gym.identity: [
                        Roster.Stop(day: date(3), takeUp: .day(date(8))),
                        Roster.Stop(day: date(3), takeUp: nil),
                    ]
                ])
        ),
        // I3: a stop not taken up before another.
        (
            "I3",
            span(
                over: [gym],
                remembering: [
                    gym.identity: [
                        Roster.Stop(day: date(3), takeUp: nil),
                        Roster.Stop(day: date(12), takeUp: nil),
                    ]
                ])
        ),
        // I4: a take-up on or before its stop's day.
        (
            "I4",
            span(
                over: [gym],
                remembering: [gym.identity: [Roster.Stop(day: date(3), takeUp: .day(date(3)))]])
        ),
    ]

    for (invariant, breaching) in breaches {
        var next = store.roster
        next.spans = [breaching]

        #expect(throws: RosterStoreError.cannotWrite(at: place), "\(invariant)") {
            _ = try store.replace(with: next)
        }
        #expect(try Data(contentsOf: place) == written, "\(invariant)")
    }
}
