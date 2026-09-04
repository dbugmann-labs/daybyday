import Foundation
import SwiftUI
import DayByDayKit

/// The owner's day-one week, quoted verbatim in `docs/backlog.md` § *What day one looks like*:
///
/// > gym Mon/Wed/Sat · run Tue/Thu/Sun · finances every 25th · reading 3× a week ·
/// > supplements and habits daily · journaling daily · contact lenses every 14 days ·
/// > water plants every 3rd day
///
/// `keptFrom`, and the `from` of every interval-based schedule, is 2026-08-28 — the date
/// `docs/backlog.md` itself records this list as having been stated on. This is display data
/// handed to `DayByDayKit`, not a rule of its own: every answer still comes from
/// `Commitment.isDue(on:)` and `Schedule.isDue(on:)`.
private let dayOneCommitments: [Commitment] = {
    let keptFrom = CalendarDate(year: 2026, month: 8, day: 28)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])

    return [
        Commitment(
            name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom),
        Commitment(
            name: "Run", schedule: .weekdays([.tuesday, .thursday, .sunday]), keptFrom: keptFrom),
        Commitment(
            name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 25)!), keptFrom: keptFrom),
        Commitment(
            name: "Reading", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 3)!),
            keptFrom: keptFrom),
        Commitment(name: "Supplements and habits", schedule: daily, keptFrom: keptFrom),
        Commitment(name: "Journaling", schedule: daily, keptFrom: keptFrom),
        Commitment(
            name: "Contact lenses", schedule: .everyNDays(DayInterval(days: 14)!, from: keptFrom),
            keptFrom: keptFrom),
        Commitment(
            name: "Water plants", schedule: .everyNDays(DayInterval(days: 3)!, from: keptFrom),
            keptFrom: keptFrom),
    ].compactMap { $0 }
}()

/// Turns the device's current instant into the calendar date `DayByDayKit` speaks — the
/// conversion ADR-1004 keeps out of the engine and puts at the edge, which is here. Reads
/// `Calendar.current`, the device's own calendar and time zone, because "today" is a question
/// asked of wherever the phone is.
private func today() -> CalendarDate {
    let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    return CalendarDate(year: components.year!, month: components.month!, day: components.day!)!
}

struct ContentView: View {
    @State private var screen = DayScreen(of: dayOneCommitments, asOf: today())
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        List {
            HStack {
                Button {
                    screen.showPreviousDay()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.borderless)
                Spacer()
                Text(screen.title)
                Spacer()
                Button {
                    screen.showNextDay()
                } label: {
                    Image(systemName: "chevron.right")
                }
                .buttonStyle(.borderless)
            }
            Button {
                screen.showToday()
            } label: {
                Text("Today")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            switch screen.recordState {
            case .kept:
                EmptyView()
            case .unreadable:
                Text("The record could not be read.")
            case .writtenByALaterVersion:
                Text("The record was written by a newer version of DayByDay and must not be deleted.")
            }

            // `Row` carries no identity of its own beyond `isKept` and `name` (`DayView.swift`
            // keeps `commitment` and `date` internal to the kit), and `isKept` is exactly what a
            // tap flips — keying `ForEach` on the row's value would make SwiftUI see a tap as one
            // row removed and another inserted. The array's position is stable across a tap, so
            // it stands in as the identity instead.
            ForEach(Array(screen.dayView.rows.enumerated()), id: \.offset) { _, row in
                Button {
                    try? screen.tick(row)
                } label: {
                    HStack {
                        Text(row.name)
                            .foregroundStyle(row.isKept ? .secondary : .primary)
                        if row.isKept {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                screen.shown(asOf: today())
            }
        }
    }
}
