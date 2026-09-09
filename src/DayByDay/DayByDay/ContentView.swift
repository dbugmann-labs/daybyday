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

/// Turns a calendar date the day picker's `screen.dayPickerReach` hands back into the instant a
/// SwiftUI `DatePicker` needs — the reverse of `today()` above, and, like it, edge code per
/// ADR-1004: both read `Calendar.current`, the device's own calendar, so the two conversions
/// agree. `CommitmentsView`'s own `date(from:)` is this same conversion; duplicated here rather
/// than exported, per `openspec/changes/add-day-picker/design.md` § *What the shell draws*.
private func date(from calendarDate: CalendarDate) -> Date {
    var components = DateComponents()
    components.year = calendarDate.year
    components.month = calendarDate.month
    components.day = calendarDate.day
    return Calendar.current.date(from: components)!
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
                // The day picker: bounded by `screen.dayPickerReach`, which the shell computes
                // neither end of, per ADR-1019's 2026-09-04 amendment. `.labelsHidden()` because
                // this row already carries the day's title as text; the default (non-`.graphical`)
                // style is what B-040 asked for and B-007 explicitly left out.
                DatePicker(
                    "Day",
                    selection: Binding(
                        get: { date(from: screen.dayPickerReach.opensOn) },
                        set: { newDate in
                            let components = Calendar.current.dateComponents(
                                [.year, .month, .day], from: newDate)
                            screen.showDay(
                                CalendarDate(
                                    year: components.year!, month: components.month!,
                                    day: components.day!)!)
                        }
                    ),
                    in: date(from: screen.dayPickerReach.earliest)...,
                    displayedComponents: [.date]
                )
                .labelsHidden()
            }
            if screen.offersGoingBackToToday {
                Button {
                    screen.showToday()
                } label: {
                    Text("Today")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }

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
                        // A tick row is exactly the row whose kind offers none of the three
                        // entries above — the same test the tap action below already makes at
                        // its own `else`. `row.tick(asOf:)` cannot stand in for this: it guards
                        // on the date alone and is non-`nil` for every kind (`DayView.swift`),
                        // so it would put a mark on every unkept row rather than only ticks.
                        // ADR-1045.
                        let isTickRow = entry == nil && noteEntry == nil && totalEntry == nil
                        let isTarget = row.offersAnything(asOf: today())
                        // Concrete, not `.primary`/`.secondary` — those are hierarchical and
                        // resolve against the enclosing `Button`'s accent tint, which is the
                        // whole of why the name reads blue today. ADR-1045 decision 9.
                        let nameColor: Color = row.isKept ? .secondary : .primary
                        // Decision 4: the tick kind's own affordance for "not yet kept, but you
                        // can", in the same slot a kept tick uses — never both, and absent
                        // rather than dimmed where the row offers nothing (`CONTEXT.md` §
                        // *Offered*).
                        let markSystemName: String? =
                            row.isKept ? "checkmark" : (isTickRow && isTarget ? "circle" : nil)
                        // Decision 8: the circle keeps the accent, the checkmark takes the
                        // system green — the concrete `Color.green`, never a hierarchical style,
                        // so it reads green inside the enclosing `Button` and outside it alike.
                        // Stated explicitly in both branches, since neither is drawn inside a
                        // `Button` reliably.
                        let markColor: Color = row.isKept ? Color.green : .accentColor
                        // Resets the hierarchy the rhythm inside `commitmentLine` still reads
                        // `.secondary` against, so it reads grey rather than the Button's accent
                        // tint, without editing that file. Decision 11: the strikethrough goes on
                        // this child `Text`, not the composed one — measured (ADR-1045) to stay on
                        // the name, survive the interpolation and take the child's own colour,
                        // where `.strikethrough()` on the composed `Text` would draw a second rule
                        // across the rhythm's own baseline as well.
                        let nameLine: Text =
                            commitmentLine(
                                Text(row.name)
                                    .foregroundStyle(nameColor)
                                    .strikethrough(row.isKept),
                                rhythmInWords: row.rhythmInWords
                            )
                            .foregroundStyle(Color.primary)
                        let label = HStack {
                            VStack(alignment: .leading) {
                                nameLine
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
                            if markSystemName != nil || entry != nil || noteEntry != nil || totalEntry != nil {
                                Spacer()
                            }
                            if let markSystemName {
                                Image(systemName: markSystemName)
                                    .foregroundStyle(markColor)
                            }
                            if entry != nil || noteEntry != nil || totalEntry != nil {
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        // `isTarget` decides whether there is a tap at all; the four `nil`
                        // checks above stay only to decide which sheet a tap opens.
                        // ADR-1045.
                        if isTarget {
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
                                label
                            }
                        } else {
                            // Decisions 3 and 5, ADR-1045: a row that offers nothing recedes as
                            // one thing — the name, the rhythm and any mark fade together rather
                            // than by three different amounts.
                            label
                                .opacity(0.5)
                        }
                    }
                } header: {
                    if let category = group.category {
                        // The platform's own padding around a category heading, dropped. Measured
                        // on this SDK (iPhone 17 simulator, iOS 26.5) rather than assumed, the way
                        // `.listSectionSpacing(12)` below was: the gap between the card above and
                        // the card this heading belongs to read 52.33pt untouched and reads 40.00pt
                        // with these insets, and the heading itself has not moved sideways — the
                        // 16pt leading and trailing are the platform's own, restated because
                        // `listRowInsets` replaces all four.
                        //
                        // **40.00pt is the floor, and it is not these insets that set it.** The
                        // heading's row will not lay out under 28pt however small they go —
                        // negative values only slide the words inside it — so what is left is that
                        // 28 plus the 12 below. Anything tighter has to come out of
                        // `.listSectionSpacing`, and that is the gap before the ungrouped rows,
                        // which is the one the owner asked to keep.
                        Text(category)
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 6, trailing: 16))
                    }
                }
            }
        }
        // Same measured value as `CommitmentsView`'s kept list — see the comment there for how
        // it was determined.
        .listSectionSpacing(12)
        // The gap between the toolbar and the day's title row — not `.listSectionSpacing` above,
        // which is the gap the *category headings* sit under, and not a `listRowInsets` on a
        // section header, since the day-title row is bare content, not a section. Measured on
        // this SDK (iPhone 17 simulator, iOS 26.5) the same way as `.listSectionSpacing(12)`
        // above: with no `.contentMargins` at all, the day-title card's top edge read 151.0pt
        // from the top of the screen. Calibrated against `for: .automatic` specifically —
        // `for: .scrollContent` was tried first and moved the card by less than it was asked to,
        // an unexplained partial effect this comment does not rely on — by setting it to 0pt and
        // to 40pt: the card read 116.0pt and 156.0pt respectively, a full point-for-point 40pt
        // move for a 40pt ask, so `for: .automatic` has no hidden offset to account for and the
        // platform's own unstated default here is 151.0 − 116.0 = 35.0pt. 24 is about two thirds
        // of that, the same proportion `.listSectionSpacing(12)` above took off its own 17.7pt
        // default, and reads 140.0pt on screen — an 11.0pt tightening, confirmed rather than
        // interpolated. Not pushed toward a floor: the owner's ask was "slightly smaller," not
        // "as small as possible," and this leaves a clearly visible gap under the toolbar.
        .contentMargins(.top, 24, for: .automatic)
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
