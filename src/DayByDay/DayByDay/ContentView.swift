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
    // `openspec/changes/add-adjacent-day-views/design.md` § *What the shell draws*: the settle
    // at release and a chevron tap are animated, and Reduce Motion turns that half off — the
    // drag itself goes on tracking the finger either way.
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showingCommitments = false
    @State private var commitmentsScreen: CommitmentsScreen?
    @State private var enteringRow: DayView.Row?
    @State private var enteringText = ""
    @State private var enteringNoteRow: DayView.Row?
    @State private var enteringNoteText = ""
    @State private var enteringTotalRow: DayView.Row?
    @State private var enteringTotalText = ""
    // The paged day content's own width, measured off `GeometryReader` and used both to size the
    // full slide a carry or a chevron tap settles to and as the threshold a drag must cross to
    // carry. `dragTranslation` is the live offset applied to the three-list `HStack`: the drag's
    // own `width` while a finger is down, and the settle's target while one is not.
    @State private var pageWidth: CGFloat = 0
    @State private var dragTranslation: CGFloat = 0
    // Which axis the current drag has committed to, decided once from the first sample
    // `daySwipeGesture` sees and held until the finger lifts — the owner's own words from the
    // phone walk: "once I start swiping, no more scrolling, and once I start scrolling, no more
    // swiping." `nil` between drags. Read by `pagedDayContent` to disable the day `List`s' own
    // scrolling for exactly as long as this drag owns the horizontal axis, so the two can never
    // both be live inside one continuous drag the way comparing each sample's ratio on its own
    // allowed.
    @State private var lockedDragAxis: Axis?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                dayControls
                pagedDayContent
            }
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

    /// The controls that stay put while the day's rows page beneath them: the chevrons and the
    /// day picker, the conditional `Today` button, and the two store messages — facts about the
    /// screen rather than about a day. `design.md` § *What the shell draws*: "the icons travel,
    /// the dock stays." Drawn outside the paged `List`s entirely, on purpose — ADR-1019's amended
    /// guard is that nothing here decides anything a test cannot already see decided behind the
    /// seam; this view only reads what `screen` already computed and calls the two moves the
    /// chevrons already called before this Story.
    private var dayControls: some View {
        VStack(spacing: 8) {
            HStack {
                Button {
                    playSettle(towards: .previous)
                } label: {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.borderless)
                Spacer()
                Text(screen.title)
                // The day picker: between the chevrons and beside the short weekday title, and
                // what says the date now that the title says only the weekday
                // (`shorten-day-title/grill.md` § *Settled* 5). Bounded by `screen.dayPickerReach`,
                // which the shell computes neither end of, per ADR-1019's 2026-09-04 amendment.
                // `.labelsHidden()` because the weekday text beside it already labels the row; the
                // default (non-`.graphical`) style is what B-040 asked for and B-007 explicitly
                // left out. The picker always replaces where it stands and animates nothing,
                // whatever a page settle is doing (`design.md` § *What the shell draws*).
                DatePicker(
                    "Day",
                    selection: Binding(
                        get: { date(from: screen.dayPickerReach.opensOn) },
                        set: { newDate in
                            let components = Calendar.current.dateComponents(
                                [.year, .month, .day], from: newDate)
                            guard
                                let picked = CalendarDate(
                                    year: components.year!, month: components.month!,
                                    day: components.day!)
                            else { return }
                            screen.showDay(picked)
                        }
                    ),
                    in: date(from: screen.dayPickerReach.earliest)...,
                    displayedComponents: [.date]
                )
                .labelsHidden()
                Spacer()
                Button {
                    playSettle(towards: .next)
                } label: {
                    Image(systemName: "chevron.right")
                }
                .buttonStyle(.borderless)
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
        }
        .padding(.horizontal)
        .padding(.top, 24)
        // The gap below the last of these controls — `Today` where it shows, otherwise the day
        // row itself — down to where `pagedDayContent` starts. Lifting the four controls out of
        // the `List` (`tasks.md` § 4.1) took the `List`'s own top content margin out with them,
        // and the phone walk (PR #194) reported what was left too tight. This machine cannot
        // launch the Simulator to read the gap on screen the way #180 and ADR-1043's chore did,
        // so this is not a measured value: it reuses the 24pt already established above, for the
        // same visual weight on both sides of this fixed block, and is left for the owner's
        // re-walk to confirm.
        .padding(.bottom, 24)
    }

    /// The day the finger is asked to carry towards: `.previous` reveals `screen.previousDayView`
    /// and moves the page rightward under it; `.next` reveals `screen.nextDayView` and moves the
    /// page leftward. `design.md` § *What the shell draws*: leftwards onto the next day,
    /// rightwards onto the previous — a chevron tap plays the same settle a completed drag does.
    private enum Neighbour {
        case previous, next
    }

    /// Three lists in a row — the day before, the day being shown and the day after — each the
    /// width of the container and translated by `dragTranslation`. No `List` is ever nested
    /// inside another scroll view, and no two days' rows are ever handed to one `ForEach`:
    /// `design.md` § *What the shell draws*, `tasks.md` § 4.2 and § 4.4.
    private var pagedDayContent: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            HStack(spacing: 0) {
                dayList(for: screen.previousDayView)
                    .frame(width: width)
                dayList(for: screen.dayView)
                    .frame(width: width)
                    .accessibilityIdentifier("CurrentDayList")
                dayList(for: screen.nextDayView)
                    .frame(width: width)
            }
            .offset(x: -width + dragTranslation)
            .clipped()
            // Disables all three `List`s' own scrolling for exactly as long as this drag has
            // locked the horizontal axis — the other half of the lock `daySwipeGesture` keeps in
            // `lockedDragAxis`. `.scrollDisabled` is an environment value every `List` beneath
            // reads, so setting it once here reaches all three without touching `dayList(for:)`.
            .scrollDisabled(lockedDragAxis == .horizontal)
            .simultaneousGesture(daySwipeGesture(pageWidth: width))
            .onAppear { pageWidth = width }
            .onChange(of: width) { _, newWidth in pageWidth = newWidth }
        }
    }

    /// One day's rows, in a plain `List` — the same groups, the same per-row rendering and the
    /// same `ForEach(Array(group.rows.enumerated()), id: \.offset)` keying this screen has always
    /// used, now driven by whichever of the three day views this list was handed. `nil` — only
    /// possible at either end of the calendar — draws an empty list; the drag never reveals it,
    /// because it resists at that end (`daySwipeGesture`).
    @ViewBuilder
    private func dayList(for dayView: DayView?) -> some View {
        List {
            if let dayView {
                // A `Section` per group, the category as its header and none where there is no
                // category — the same arrangement `CommitmentsView`'s kept list takes.
                // `design.md` § *The shell rides this Story*.
                ForEach(dayView.groups, id: \.category) { group in
                    Section {
                        // `Row` carries no identity of its own beyond `isKept` and `name`
                        // (`DayView.swift` keeps `commitment` and `date` internal to the kit),
                        // and `isKept` is exactly what a tap flips — keying `ForEach` on the
                        // row's value would make SwiftUI see a tap as one row removed and
                        // another inserted. The offset within this group's own `ForEach` is
                        // stable across a tap, exactly as the flat offset was, so it stands in
                        // as the identity instead.
                        ForEach(Array(group.rows.enumerated()), id: \.offset) { _, row in
                            rowView(row)
                        }
                    } header: {
                        if let category = group.category {
                            // The platform's own padding around a category heading, dropped.
                            // Measured on this SDK (iPhone 17 simulator, iOS 26.5) rather than
                            // assumed, the way `.listSectionSpacing(12)` below was: the gap
                            // between the card above and the card this heading belongs to read
                            // 52.33pt untouched and reads 40.00pt with these insets, and the
                            // heading itself has not moved sideways — the 16pt leading and
                            // trailing are the platform's own, restated because
                            // `listRowInsets` replaces all four.
                            //
                            // **40.00pt is the floor, and it is not these insets that set it.**
                            // The heading's row will not lay out under 28pt however small they
                            // go — negative values only slide the words inside it — so what is
                            // left is that 28 plus the 12 below. Anything tighter has to come
                            // out of `.listSectionSpacing`, and that is the gap before the
                            // ungrouped rows, which is the one the owner asked to keep.
                            Text(category)
                                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 6, trailing: 16))
                        }
                    }
                }
            }
        }
        // Same measured value as `CommitmentsView`'s kept list — see the comment there for how
        // it was determined.
        .listSectionSpacing(12)
    }

    /// One row's content and the tap that acts on it — pulled out of `dayList(for:)` so the same
    /// rendering runs for all three days without being written three times. Acting on a row from
    /// a neighbouring day is inert: `DayScreen.tick`, `enter(_:on:)` and `takeBackLast(on:)` each
    /// return early on a row `screen.dayView.rows` does not contain, which every row here but the
    /// centre list's is — `openspec/specs/day-screen/spec.md`'s *A day screen makes every change
    /// on the day it is showing and none on a day either side of it*.
    @ViewBuilder
    private func rowView(_ row: DayView.Row) -> some View {
        let entry = row.numberEntry(asOf: today())
        let noteEntry = row.noteEntry(asOf: today())
        let totalEntry = row.totalEntry(asOf: today())
        let isTarget = row.offersAnything(asOf: today())
        // Concrete, not `.primary`/`.secondary` — those are hierarchical and resolve against
        // the enclosing `Button`'s accent tint, which is the whole of why the name reads blue
        // today. ADR-1045 decision 9.
        let nameColor: Color = row.isKept ? .secondary : .primary
        // Decision 4, reversed by ADR-1045's third amendment: an unkept tick row carries no
        // mark at all. The trailing slot holds a mark only where the row is kept, so the open
        // `circle` that used to say "not yet kept, but you can" is gone and nothing takes its
        // place.
        let markSystemName: String? = row.isKept ? "checkmark" : nil
        // Decision 8: the checkmark takes the system green — the concrete `Color.green`, never
        // a hierarchical style, so it reads green inside the enclosing `Button` and outside it
        // alike. It is the only mark this slot draws now, and it is still stated explicitly,
        // since it is not drawn inside a `Button` reliably.
        let markColor: Color = Color.green
        // Resets the hierarchy the rhythm inside `commitmentLine` still reads `.secondary`
        // against, so it reads grey rather than the Button's accent tint, without editing that
        // file. Decision 11: the strikethrough goes on this child `Text`, not the composed one
        // — measured (ADR-1045) to stay on the name, survive the interpolation and take the
        // child's own colour, where `.strikethrough()` on the composed `Text` would draw a
        // second rule across the rhythm's own baseline as well.
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
        // `isTarget` decides whether there is a tap at all; the four `nil` checks above stay
        // only to decide which sheet a tap opens. ADR-1045.
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
            // Decisions 3 and 5, ADR-1045: a row that offers nothing recedes as one thing —
            // the name, the rhythm and any mark fade together rather than by three different
            // amounts.
            label
                .opacity(0.5)
        }
    }

    /// ADR-1042, carried forward by `design.md` § *What the shell draws*: a horizontal drag on
    /// the day screen moves the day it is showing, beside the chevrons rather than instead of
    /// them, calling the same `showPreviousDay()` and `showNextDay()` they call — never
    /// `showDay(_:)`, which is bounded by the day picker's reach and would silently refuse a
    /// page back below the roster's earliest kept-from day. `minimumDistance` keeps a plain tap
    /// on a row or a button from ever reaching either closure. What is new since the phone walk
    /// (PR #194) is that the axis is decided once, from the first sample this gesture sees, and
    /// held in `lockedDragAxis` until the finger lifts — comparing each sample's own ratio on its
    /// own let a single continuous drag flip axes mid-flight, which is how a vertical scroll and
    /// a horizontal page both ran at once. A drag that locks vertical only stops paging here;
    /// `pagedDayContent`'s `.scrollDisabled(lockedDragAxis == .horizontal)` is what stops a
    /// horizontally locked drag from also scrolling the `List` underneath. The page tracks the
    /// finger live (`dragTranslation`) once locked horizontal, and resists where the neighbour it
    /// would reveal is absent, settling back on release rather than carrying.
    private func daySwipeGesture(pageWidth: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 40)
            .onChanged { value in
                if lockedDragAxis == nil {
                    lockedDragAxis =
                        abs(value.translation.width) > abs(value.translation.height)
                        ? .horizontal : .vertical
                }
                guard lockedDragAxis == .horizontal else {
                    return
                }
                if value.translation.width < 0 {
                    dragTranslation = screen.nextDayView == nil ? 0 : value.translation.width
                } else {
                    dragTranslation = screen.previousDayView == nil ? 0 : value.translation.width
                }
            }
            .onEnded { value in
                defer { lockedDragAxis = nil }
                guard lockedDragAxis == .horizontal else {
                    settle(to: 0, then: nil)
                    return
                }

                let width = value.translation.width
                let carries = abs(width) > pageWidth / 3
                if width < 0, screen.nextDayView != nil, carries {
                    settle(to: -pageWidth) { screen.showNextDay() }
                } else if width > 0, screen.previousDayView != nil, carries {
                    settle(to: pageWidth) { screen.showPreviousDay() }
                } else {
                    settle(to: 0, then: nil)
                }
            }
    }

    /// Plays a chevron tap's settle: the same full-page slide a carried drag ends with, in the
    /// same direction — leftwards onto the next day, rightwards onto the previous
    /// (`design.md` § *What the shell draws*). Where there is no day view on that side the page
    /// has nowhere to go, so the day is moved directly with no slide to play — `showPreviousDay()`
    /// and `showNextDay()` are themselves already a no-op there.
    private func playSettle(towards neighbour: Neighbour) {
        switch neighbour {
        case .previous:
            guard screen.previousDayView != nil else {
                screen.showPreviousDay()
                return
            }
            settle(to: pageWidth) { screen.showPreviousDay() }
        case .next:
            guard screen.nextDayView != nil else {
                screen.showNextDay()
                return
            }
            settle(to: -pageWidth) { screen.showNextDay() }
        }
    }

    /// Slides `dragTranslation` to `target` and, once that finishes, resets it to zero and runs
    /// `move` — the day-changing call, made only after the page has visually finished travelling
    /// to it. Skipped entirely where `reduceMotion` is set: the settle becomes an instant change,
    /// exactly as `design.md` § *What the shell draws* asks, and the drag's own live tracking
    /// above is untouched by this either way — the HIG lists tracking directly with a gesture as
    /// a way to reduce motion, not a target for removing it.
    private func settle(to target: CGFloat, then move: (() -> Void)?) {
        guard !reduceMotion else {
            dragTranslation = 0
            move?()
            return
        }

        withAnimation(.easeOut, completionCriteria: .logicallyComplete) {
            dragTranslation = target
        } completion: {
            dragTranslation = 0
            move?()
        }
    }
}
