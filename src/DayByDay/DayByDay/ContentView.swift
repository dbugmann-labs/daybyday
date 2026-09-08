import Foundation
import SwiftUI
import DayByDayKit

/// The owner's week, as stated on 2026-09-04:
///
/// > creatine daily · magnesium daily · nails every 4 days from Sunday 6 September ·
/// > gym Mon/Wed/Sat · run Tue/Thu/Sun · public pool Fri ·
/// > contact lenses every 14 days from Saturday 5 September · finances every 25th ·
/// > yuno 5x a week
///
/// `keptFrom` is 2026-09-04, the day the list was stated and the first day any of it can show a
/// row. The two interval schedules count from their own stated day instead, which is why each
/// carries its own `from`. This is display data handed to `DayByDayKit`, not a rule of its own:
/// every answer still comes from `Commitment.isDue(on:)` and `Schedule.isDue(on:)`.
///
/// It is a **seed, not the roster**. `DayScreen.init(startingFrom:)` takes it on only where the
/// roster kept at `DayScreen.rosterPlace` holds nothing at all; against a roster holding anything
/// this list is ignored. Editing it therefore changes nothing on an install that has already run
/// once — delete the app first, or the change is invisible.
private let dayOneCommitments: [Commitment] = {
    let keptFrom = CalendarDate(year: 2026, month: 9, day: 4)!
    let daily: Schedule = .weekdays([
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
    ])
    let nailsFrom = CalendarDate(year: 2026, month: 9, day: 6)!
    let lensesFrom = CalendarDate(year: 2026, month: 9, day: 5)!

    return [
        Commitment(name: "Creatine", schedule: daily, keptFrom: keptFrom),
        Commitment(name: "Magnesium", schedule: daily, keptFrom: keptFrom),
        Commitment(
            name: "Nails", schedule: .everyNDays(DayInterval(days: 4)!, from: nailsFrom),
            keptFrom: keptFrom),
        Commitment(
            name: "Gym", schedule: .weekdays([.monday, .wednesday, .saturday]), keptFrom: keptFrom),
        Commitment(
            name: "Run", schedule: .weekdays([.tuesday, .thursday, .sunday]), keptFrom: keptFrom),
        Commitment(name: "Public Pool", schedule: .weekdays([.friday]), keptFrom: keptFrom),
        Commitment(
            name: "Contact Lenses",
            schedule: .everyNDays(DayInterval(days: 14)!, from: lensesFrom), keptFrom: keptFrom),
        Commitment(
            name: "Finances", schedule: .dayOfMonth(DayOfMonth(day: 25)!), keptFrom: keptFrom),
        Commitment(
            name: "Yuno", schedule: .weeklyQuota(WeeklyQuota(timesPerWeek: 5)!),
            keptFrom: keptFrom),
        Commitment(
            name: "Weight", schedule: daily, keptFrom: keptFrom,
            kind: .number(range: Commitment.Range(lowest: 40, highest: 150))),
    ].compactMap { $0 }
}()

/// Turns an instant into the calendar date `DayByDayKit` speaks — the conversion ADR-1004 keeps
/// out of the engine and puts at the edge, which is here. Reads `Calendar.current`, the device's
/// own calendar and time zone, because "today" is a question asked of wherever the phone is.
/// `CommitmentsView`'s own `date(from:)` is this conversion run in reverse, so a form's default
/// date is read from the seam rather than from a second clock read of its own.
private func today() -> CalendarDate {
    let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    return CalendarDate(year: components.year!, month: components.month!, day: components.day!)!
}

struct ContentView: View {
    @State private var screen = DayScreen(startingFrom: dayOneCommitments, asOf: today())
    @Environment(\.scenePhase) private var scenePhase
    @State private var showingCommitments = false
    @State private var commitmentsScreen: CommitmentsScreen?
    @State private var enteringRow: DayView.Row?
    @State private var enteringText = ""
    @State private var enteringNoteRow: DayView.Row?
    @State private var enteringNoteText = ""
    @State private var enteringTotalRow: DayView.Row?
    @State private var enteringTotalText = ""

    var body: some View {
        NavigationStack {
            dayList
                .navigationDestination(isPresented: $showingCommitments) {
                    if let commitmentsScreen {
                        CommitmentsView(screen: commitmentsScreen)
                    }
                }
                .toolbar {
                    ToolbarItem {
                        Button("Commitments") {
                            commitmentsScreen = CommitmentsScreen(asOf: today())
                            showingCommitments = true
                        }
                    }
                }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                screen.shown(asOf: today())
                commitmentsScreen?.shown(asOf: today())
            }
        }
        .onChange(of: showingCommitments) { _, isShowing in
            if !isShowing {
                screen.returnedTo()
                commitmentsScreen = nil
            }
        }
    }

    private var dayList: some View {
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

            switch screen.rosterState {
            case .kept:
                EmptyView()
            case .notKept:
                Text("The roster could not be read or could not be written.")
            case .writtenByALaterVersion:
                Text("The roster was written by a newer version of DayByDay and must not be deleted.")
            }

            // A `Section` per group, the category as its header and none where there is no
            // category — the same arrangement `CommitmentsView`'s kept list takes, and where this
            // screen's own half of the boundary before the ungrouped rows comes from.
            // `design.md` § *The shell rides this Story*.
            ForEach(screen.dayView.groups, id: \.category) { group in
                Section {
                    // `Row` carries no identity of its own beyond `isKept` and `name`
                    // (`DayView.swift` keeps `commitment` and `date` internal to the kit), and
                    // `isKept` is exactly what a tap flips — keying `ForEach` on the row's value
                    // would make SwiftUI see a tap as one row removed and another inserted. The
                    // offset within this group's own `ForEach` is stable across a tap, exactly as
                    // the flat offset was, so it stands in as the identity instead.
                    ForEach(Array(group.rows.enumerated()), id: \.offset) { _, row in
                        let entry = row.numberEntry(asOf: today())
                        let noteEntry = row.noteEntry(asOf: today())
                        let totalEntry = row.totalEntry(asOf: today())
                        Button {
                            if let entry {
                                enteringText = entry.number.map { "\($0)" } ?? ""
                                enteringRow = row
                            } else if let noteEntry {
                                enteringNoteText = noteEntry.note ?? ""
                                enteringNoteRow = row
                            } else if totalEntry != nil {
                                enteringTotalText = ""
                                enteringTotalRow = row
                            } else {
                                try? screen.tick(row)
                            }
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    commitmentLine(
                                        Text(row.name)
                                            .foregroundStyle(row.isKept ? .secondary : .primary),
                                        rhythmInWords: row.rhythmInWords)
                                    if let totalEntry {
                                        Text(totalEntry.soFarOfTarget)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    if row == screen.notice?.row {
                                        Text(screen.notice?.cause ?? "Not saved. Try again.")
                                            .font(.caption)
                                            .foregroundStyle(.red)
                                    }
                                }
                                if row.isKept || entry != nil || noteEntry != nil || totalEntry != nil {
                                    Spacer()
                                }
                                if row.isKept {
                                    Image(systemName: "checkmark")
                                }
                                if entry != nil || noteEntry != nil || totalEntry != nil {
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                } header: {
                    if let category = group.category {
                        Text(category)
                    }
                }
            }
        }
        // Same measured value as `CommitmentsView`'s kept list — see the comment there for how
        // it was determined.
        .listSectionSpacing(12)
        .simultaneousGesture(daySwipeGesture)
        .alert(
            enteringRow?.name ?? "",
            isPresented: Binding(
                get: { enteringRow != nil },
                set: { isPresented in
                    if !isPresented {
                        enteringRow = nil
                    }
                }
            ),
            presenting: enteringRow
        ) { row in
            TextField(row.numberEntry(asOf: today())?.hint ?? "", text: $enteringText)
                .keyboardType(.decimalPad)
            Button("Save") {
                try? screen.enter(enteringText, on: row)
                enteringRow = nil
            }
            Button("Cancel", role: .cancel) {
                enteringRow = nil
            }
        }
        .sheet(
            isPresented: Binding(
                get: { enteringNoteRow != nil },
                set: { isPresented in
                    if !isPresented {
                        enteringNoteRow = nil
                    }
                }
            )
        ) {
            if let row = enteringNoteRow {
                NavigationStack {
                    TextEditor(text: $enteringNoteText)
                        .padding()
                        .navigationTitle(row.name)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    enteringNoteRow = nil
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Save") {
                                    try? screen.enter(enteringNoteText, on: row)
                                    enteringNoteRow = nil
                                }
                            }
                        }
                }
            }
        }
        .sheet(
            isPresented: Binding(
                get: { enteringTotalRow != nil },
                set: { isPresented in
                    if !isPresented {
                        enteringTotalRow = nil
                    }
                }
            )
        ) {
            if let row = enteringTotalRow {
                NavigationStack {
                    VStack {
                        TextField("Amount", text: $enteringTotalText)
                            .keyboardType(.decimalPad)
                            .padding()
                        if row.offersTakeBackLast(asOf: today()) {
                            Button("Take back last", role: .destructive) {
                                try? screen.takeBackLast(on: row)
                                enteringTotalRow = nil
                            }
                        }
                        Spacer()
                    }
                    .navigationTitle(row.name)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                enteringTotalRow = nil
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                try? screen.enter(enteringTotalText, on: row)
                                enteringTotalRow = nil
                            }
                        }
                    }
                }
            }
        }
    }

    /// ADR-1042: a horizontal swipe on the day screen moves the day it is showing, beside the
    /// chevrons rather than instead of them — the same `showPreviousDay()` and `showNextDay()`
    /// they call, so a move with nowhere to go behaves exactly as a chevron tap already does.
    /// `minimumDistance` keeps a plain tap on a row or a button from ever reaching `onEnded`, and
    /// comparing the two axes keeps an ordinary vertical scroll from being read as a day move.
    /// `.simultaneousGesture` is what lets the list's own scrolling and its rows' own taps keep
    /// working underneath it — this recognizer only ever acts on release.
    private var daySwipeGesture: some Gesture {
        DragGesture(minimumDistance: 40)
            .onEnded { value in
                guard abs(value.translation.width) > abs(value.translation.height) else {
                    return
                }
                if value.translation.width < 0 {
                    screen.showNextDay()
                } else {
                    screen.showPreviousDay()
                }
            }
    }
}
