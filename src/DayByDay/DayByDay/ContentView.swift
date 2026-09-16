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
    // Which one-off name field, if any, has focus — the entry or a row's rename field. Only one
    // field is ever focused at a time (`design.md` § *A refusal under a name field is its own
    // value, and there is one at a time*), so a single `@FocusState` value stands for all of
    // them, driving both the TextField that has it and the toolbar `+`/checkmark that read it.
    private enum OneOffFocus: Hashable {
        case entry
        case row(DayView.OneOffRow)
    }
    @FocusState private var oneOffFocus: OneOffFocus?
    // The entry's own typed text, and the text typed into whichever row is being renamed. Each is
    // emptied on every commit `commitOneOffEntry()` or `commitRename(of:to:)` makes, kept or
    // refused alike (`design.md` § *A refusal under a name field is its own value*: "the shell
    // empties its field on every commit"). What the field *shows* and *resends* while a refusal
    // stands is never read off these — `oneOffEntryCommitText` and `oneOffRowTextBinding(for:)`
    // both read `nameRefusal`'s own `text` there instead — so shown and committed always agree,
    // and this pair only matters again once the refusal ends: by an edit, a day change, or the
    // app being shown again, each of which the kit itself clears `nameRefusal` on.
    @State private var oneOffEntryText = ""
    @State private var oneOffRowText = ""
    // Set immediately before `commitFocusedOneOffField()` clears `oneOffFocus`, having already
    // committed whichever field it found focused; consumed — read once and reset — the next time
    // `onChange(of: oneOffFocus)` fires, so the commit that focus change would otherwise trigger
    // there does not repeat one `commitFocusedOneOffField()` already made. Losing focus commits
    // from more than one place (the checkmark, a row's own Return, every day move and
    // `scenePhase` leaving `.active`), and more than one of those can fire for the one field
    // losing focus; without this, the second finds the field already emptied by the first — a
    // harmless no-op for an add, but not for a rename, which a blank text removes outright.
    @State private var justCommittedOneOffField = false
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
    // allowed. Cleared both by `onEnded`'s `defer`, for a drag that finishes, and by the
    // `onChange(of: isDraggingDay)` below, for one that is *cancelled* instead — see that
    // property.
    @State private var lockedDragAxis: Axis?
    // Mirrors whether `daySwipeGesture` currently has a finger down, off SwiftUI's own
    // gesture-active state rather than off `onChanged`/`onEnded` — a `@GestureState` resets
    // itself to its initial value the moment the gesture it is `updating` stops being active,
    // whether that is a normal `onEnded` or a *cancellation* (an incoming call banner, the app
    // backgrounded with the finger down), neither of which reaches `onEnded`. That reset is what
    // `pagedDayContent`'s `onChange(of: isDraggingDay)` clears `lockedDragAxis` from, so a
    // cancelled drag can never leave the day lists unable to scroll the way a reset that lived
    // only in `onEnded`'s `defer` would.
    @GestureState private var isDraggingDay = false

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
                // The way back to today: a plain text button on the toolbar's left, where
                // nothing is drawn today. Still gated on `screen.offersGoingBackToToday` and
                // still calls exactly what the button under the day row used to.
                if screen.offersGoingBackToToday {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Today") {
                            commitFocusedOneOffField(forDeparture: true)
                            screen.showToday()
                        }
                    }
                }
                ToolbarItem {
                    Button("Commitments") {
                        commitmentsScreen = CommitmentsScreen(asOf: today())
                        showingCommitments = true
                    }
                }
                // The `+`: shown exactly where `oneOffGroup != nil` says adding is offered
                // (`design.md` § *The empty group is the offer*), and focuses the entry.
                if screen.dayView.oneOffGroup != nil {
                    ToolbarItem {
                        Button {
                            oneOffFocus = .entry
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                // The green checkmark: shown while any one-off field is focused, and commits and
                // drops focus exactly as Return does, minus the fresh entry Return leaves focused.
                // `design.md` § *The shell*. Gated on `oneOffFocusNamesALiveField`, not a bare
                // `oneOffFocus != nil` — see that property's own doc comment for why.
                if oneOffFocusNamesALiveField {
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            // `commitFocusedOneOffField()` already drops focus itself once it
                            // has committed — except where a rename it just made is refused, in
                            // which case the row stays focused on purpose (grill answer 18): see
                            // its own doc comment.
                            commitFocusedOneOffField()
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.green)
                        }
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
                        ZStack {
                            Color(.systemGroupedBackground)
                                .ignoresSafeArea()
                            TextEditor(text: $enteringNoteText)
                                .scrollContentBackground(.hidden)
                                .padding(8)
                                .background(.background, in: RoundedRectangle(cornerRadius: 12))
                                .padding()
                        }
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
            // A total takes an amount in an alert over the day, the same way a number entry takes
            // a number, rather than in a sheet that replaces the day with a screen. Adding to a
            // running total is a few keystrokes against a number you already know, and the sheet
            // spent a whole screen and two navigation animations on them. The message says what
            // the row was saying — `soFarOfTarget`, the package's own words — because the alert
            // now covers the row that said it. Nothing here decides anything: the amount still
            // goes to `DayScreen.enter(_:on:)` as typed and the take-back is still offered exactly
            // where `offersTakeBackLast(asOf:)` says it is, which is what the sheet did too.
            .alert(
                enteringTotalRow?.name ?? "",
                isPresented: Binding(
                    get: { enteringTotalRow != nil },
                    set: { isPresented in
                        if !isPresented {
                            enteringTotalRow = nil
                        }
                    }
                ),
                presenting: enteringTotalRow
            ) { row in
                TextField("Amount", text: $enteringTotalText)
                    .keyboardType(.decimalPad)
                Button("Save") {
                    try? screen.enter(enteringTotalText, on: row)
                    enteringTotalRow = nil
                }
                if row.offersTakeBackLast(asOf: today()) {
                    Button("Take back last", role: .destructive) {
                        try? screen.takeBackLast(on: row)
                        enteringTotalRow = nil
                    }
                }
                Button("Cancel", role: .cancel) {
                    enteringTotalRow = nil
                }
            } message: { row in
                if let totalEntry = row.totalEntry(asOf: today()) {
                    Text(totalEntry.soFarOfTarget)
                }
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase != .active {
                commitFocusedOneOffField(forDeparture: true)
            }
            if phase == .active {
                screen.shown(asOf: today())
                commitmentsScreen?.shown(asOf: today())
            }
        }
        .onChange(of: showingCommitments) { _, isShowing in
            if !isShowing {
                screen.returnedTo(from: commitmentsScreen)
                commitmentsScreen = nil
            }
        }
        // Losing focus commits (`design.md` § *The shell*): whichever one-off field just gave up
        // focus — by a tap elsewhere, which is what this exists to catch, or by the checkmark or
        // one of the explicit moves below, each of which has already committed its own field via
        // `commitFocusedOneOffField()` before this fires — is committed here too. The comment
        // this replaced claimed that second pass was always harmless because a field already
        // emptied by its own commit commits nothing on a second pass; true for an add, which
        // `DayScreen.addOneOff` no-ops on blank text, but not for a rename, which a blank text
        // removes outright — `justCommittedOneOffField` is what actually makes the second pass
        // harmless, by skipping it exactly once for every commit `commitFocusedOneOffField()`
        // has already made. This does not route a rename through `commitRename(of:to:)` the way
        // `commitFocusedOneOffField()` does, and so does not refocus a row it finds refused:
        // focus has already moved on by the time this fires, to whatever a tap elsewhere landed
        // on, and forcing it back could only fight that — not, as `commitFocusedOneOffField()`
        // can, hold a field that was never actually going to lose focus in the first place.
        //
        // **Gaining focus seeds `oneOffRowText`, and that half is new.** A one-off row's name
        // field is always present (`oneOffRowView(_:)`'s own doc comment) and reached by an
        // ordinary tap into it — no code of this file's own asks `@FocusState` to focus a field
        // that does not exist yet, which is what left the keyboard never coming up before. That
        // means nothing else runs *before* the field gains focus to seed what it should show, the
        // way the deleted `startRename(of:)` once did from inside a `Button` action; this is the
        // one place a row's own name field is known to have just gained focus, from a tap or from
        // `commitFocusedOneOffField()` reopening a refused one. Unconditional, past both guards
        // above: a fresh field's text matters whether or not anything else needed committing.
        //
        // The commit below reads `oneOffRowCommitText(for:)`, not raw `oneOffRowText`, for the
        // same reason `commitFocusedOneOffField()` does — see that function's own doc comment
        // (a phone check on b3860c8 found a refused rename deleted here too, by the identical
        // stale-blank path: a tap elsewhere lands on nothing that moves focus, per grill answer
        // 18, so it is not this that removed anything on the phone — it was this same call
        // reached a second time, from the checkmark or a day change, after `oneOffRowText` had
        // already been cleared by the first, refused attempt).
        .onChange(of: oneOffFocus) { oldValue, newValue in
            defer {
                if case .row(let row) = newValue, newValue != oldValue {
                    if let nameRefusal = screen.nameRefusal, nameRefusal.row == row {
                        oneOffRowText = nameRefusal.text
                    } else {
                        oneOffRowText = row.name
                    }
                }
            }
            guard let oldValue, oldValue != newValue else {
                return
            }
            guard !justCommittedOneOffField else {
                justCommittedOneOffField = false
                return
            }
            switch oldValue {
            case .entry:
                commitOneOffEntry()
            case .row(let row):
                try? screen.rename(row, to: oneOffRowCommitText(for: row))
                oneOffRowText = ""
            }
        }
    }

    /// Commits whatever one-off field currently has focus — the entry, or a row's rename field —
    /// and, once committed, drops focus itself: a caller that also means to drop it need not set
    /// `oneOffFocus` a second time (the checkmark does not). Where a rename this finds is refused,
    /// `forDeparture` decides what becomes of it. `false` — the checkmark and a row's own Return —
    /// holds the row focused with its typed name and the cause under it (grill answer 18, "exactly
    /// as a refused add"). `true` — every caller about to move the day away from this field or send
    /// the app to the background: the chevrons, swipe, `Today`, the day picker and `scenePhase`
    /// leaving `.active` — drops focus and, since `commitRename(of:to:)` has already emptied
    /// `oneOffRowText`, the typed text with it, instead of holding it open on a page about to
    /// become a neighbour or go unseen (grill answer 12, "dropped with its text by the time the
    /// day lands"). Guarded on `oneOffFocus` being non-`nil` at entry, so a second, redundant call
    /// — `scenePhase` leaving `.active` calls this once per phase it passes through on the way to
    /// the background, `.inactive` and then `.background` — finds nothing left to commit and does
    /// nothing. Called before every one of the moves `design.md` § *The shell* names: the
    /// chevrons, swipe, `Today`, the day picker and `scenePhase` leaving `.active`, in each case
    /// before the day actually moves.
    ///
    /// **Sends `oneOffRowCommitText(for: row)`, never raw `oneOffRowText` — a phone check on
    /// b3860c8 found what reading the raw state here actually does.** A row refused once already
    /// has an empty `oneOffRowText` (`commitRename(of:to:)` clears it on every attempt, kept or
    /// refused), so a *second* call here for the same still-refused row — the checkmark tapped
    /// again, or a day change arriving while the refusal stands, `forDeparture` true — sent blank,
    /// and a blank rename removes the one-off outright (grill answer 16) rather than leaving it
    /// exactly as it was (grill answers 12 and 18). `oneOffRowCommitText(for:)` reads the refusal
    /// back out instead, the same way `oneOffEntryCommitText` already did for the entry.
    private func commitFocusedOneOffField(forDeparture: Bool = false) {
        guard let focus = oneOffFocus else {
            return
        }
        switch focus {
        case .entry:
            commitOneOffEntry()
        case .row(let row):
            let refused = commitRename(of: row, to: oneOffRowCommitText(for: row))
            guard !refused || forDeparture else {
                oneOffFocus = .row(row)
                return
            }
        }
        justCommittedOneOffField = true
        oneOffFocus = nil
    }

    /// Whether `oneOffFocus` still names a field that actually exists to hold it — `.entry`
    /// always does, wherever the toolbar `+` itself shows; `.row(row)` only while `row` is still
    /// one of `screen.dayView.oneOffGroup`'s own rows. **The checkmark reads this, not a bare
    /// `oneOffFocus != nil`, and that is load-bearing.** A phone check on 3a70bda found the
    /// checkmark still showing after a one-off was removed — a blank rename committed by Return
    /// or the checkmark, or *Remove* from the long-press menu — driven for real on the simulator
    /// and confirmed by dumping the hierarchy at that exact point: no field anywhere in it held
    /// focus, yet `oneOffFocus` was still non-`nil` by the checkmark's own evidence. `@FocusState`
    /// dropping a value assigned `nil` in the very update that also tears down the view it named
    /// — every one of the three removal paths is exactly that, unlike an ordinary rename, which
    /// leaves the row's own field in the tree, just renamed — is the same class of `@FocusState`
    /// unreliability `oneOffRowView(_:)`'s own doc comment already found nesting a gesture, not
    /// removing a view, tripping into; `commitFocusedOneOffField()` above already sets
    /// `oneOffFocus = nil` on every successful commit, removal included, so the assignment itself
    /// is not the gap. Reading a *validated* value here, rather than chasing why the raw one goes
    /// stale, is what actually keeps the checkmark honest: harmless everywhere else, since
    /// `DayScreen.rename` and `.tick` already guard on the row still being one of theirs before
    /// writing anything, so a stale `oneOffFocus` this catches was never going to reach the model.
    private var oneOffFocusNamesALiveField: Bool {
        switch oneOffFocus {
        case nil:
            return false
        case .entry:
            return true
        case .row(let row):
            return screen.dayView.oneOffGroup?.rows.contains(row) ?? false
        }
    }

    /// The entry's committed candidate: `nameRefusal`'s own `text` while a refusal stands under
    /// the entry, `oneOffEntryText` otherwise — the same rule `oneOffEntryTextBinding` reads the
    /// field's display by, kept in one place so every commit site sends exactly the text the
    /// entry is showing rather than a possibly-stale `oneOffEntryText` of its own.
    private var oneOffEntryCommitText: String {
        if let nameRefusal = screen.nameRefusal, nameRefusal.row == nil {
            return nameRefusal.text
        }
        return oneOffEntryText
    }

    /// Commits `oneOffEntryCommitText` as a new one-off from the entry and empties
    /// `oneOffEntryText`, kept or refused alike (`design.md` § *A refusal under a name field is
    /// its own value*: "the shell empties its field on every commit"). What the entry shows and
    /// resends while a refusal stands is `oneOffEntryCommitText`'s own read of `nameRefusal.text`,
    /// not this state, so emptying it here never loses the typed text — only ends the entry's
    /// last claim on it, which the refusal itself, while it stands, already holds.
    private func commitOneOffEntry() {
        let text = oneOffEntryCommitText
        try? screen.addOneOff(named: text)
        oneOffEntryText = ""
    }

    /// Commits `text` as a rename of `row`, empties `oneOffRowText` and reports whether it was
    /// refused — kept or refused alike (`design.md` § *A refusal under a name field is its own
    /// value*: "the shell empties its field on every commit"); what the row shows and resends
    /// while a refusal stands is `oneOffRowTextBinding(for:)`'s own read of `nameRefusal.text`,
    /// not this state. `commitFocusedOneOffField()`, its one caller, reads the result to decide
    /// what becomes of a refusal: put back in focus (grill answer 18) or, `forDeparture`, dropped
    /// with it (grill answer 12) — this function decides only whether, not what. Called only from
    /// there, and not from `onChange(of: oneOffFocus)`'s own, unconditional commit: focus has
    /// already moved on by the time that fires, to wherever a tap elsewhere landed, and putting
    /// it back on `row` there would fight that rather than hold a field that was never actually
    /// about to lose it.
    private func commitRename(of row: DayView.OneOffRow, to text: String) -> Bool {
        try? screen.rename(row, to: text)
        oneOffRowText = ""
        return screen.nameRefusal?.row == row
    }

    /// The controls that stay put while the day's rows page beneath them: the chevrons and the
    /// day picker, and the two store messages — facts about the
    /// screen rather than about a day. `design.md` § *What the shell draws*: "the icons travel,
    /// the dock stays." Drawn outside the paged `List`s entirely, on purpose — ADR-1019's amended
    /// guard is that nothing here decides anything a test cannot already see decided behind the
    /// seam; this view only reads what `screen` already computed and calls the two moves the
    /// chevrons already called before this Story. `Today` itself is no longer drawn here — it
    /// moved into the toolbar's leading item, gated on the same `offersGoingBackToToday` and
    /// calling the same two moves (`body`'s `.toolbar`).
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
                            commitFocusedOneOffField(forDeparture: true)
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
            switch screen.recordState {
            case .kept:
                EmptyView()
            case .unreadable:
                Text("The record could not be read.")
                    .font(.caption)
                    .foregroundStyle(.red)
            case .writtenByALaterVersion:
                Text("The record was written by a newer version of DayByDay and must not be deleted.")
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            switch screen.rosterState {
            case .kept:
                EmptyView()
            case .notKept:
                Text("The roster could not be read or could not be written.")
                    .font(.caption)
                    .foregroundStyle(.red)
            case .writtenByALaterVersion:
                Text("The roster was written by a newer version of DayByDay and must not be deleted.")
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            switch screen.oneOffState {
            case .kept:
                EmptyView()
            case .unreadable:
                Text("The one-offs could not be read.")
                    .font(.caption)
                    .foregroundStyle(.red)
            case .writtenByALaterVersion:
                Text("The one-offs were written by a newer version of DayByDay and must not be deleted.")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding(.horizontal)
        .padding(.top, 24)
        // The gap below the last of these controls — `Today` where it shows, otherwise the day
        // row itself — down to where `pagedDayContent` starts. Lifting the four controls out of
        // the `List` (`tasks.md` § 4.1) took the `List`'s own top content margin out with them,
        // and the phone walk (PR #194) reported what was left too tight. Not measured against a
        // booted Simulator the way #180 and ADR-1043's chore did, and the way the category
        // heading's inset below is ("Measured on this SDK"): the constraint is the session's, not
        // the machine's — a cold Simulator boot is silent long enough to trip this harness's own
        // stream watchdog, and ADR-1019 records the Simulator booting here without issue
        // otherwise. So this reuses the 24pt already established above, for the same visual
        // weight on both sides of this fixed block. The second phone walk (PR #194) confirmed it
        // on a paired iPhone: the gap reads right on both a today and a non-today day.
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
    ///
    /// **Reading `screen.dayView` here, alongside both neighbours, is load-bearing and not just
    /// what this view happens to draw.** `DayScreen` is `@Observable` over `recordStore`, a
    /// reference; a tick mutates the history behind that reference without the reference itself
    /// changing, so SwiftUI's observation has nothing to diff on `previousDayView` or
    /// `nextDayView` alone. `dayView` is reassigned on every write, so reading it here is what
    /// carries the redraw to the neighbours too. A view built to hold only the neighbours would
    /// not be told a tick had landed on one — `design.md` § *Computed, not stored, and that is
    /// the load-bearing choice* names the wrinkle; do not drop this read while chasing it away.
    private var pagedDayContent: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            HStack(spacing: 0) {
                dayList(for: screen.previousDayView, isShown: false)
                    .frame(width: width)
                dayList(for: screen.dayView, isShown: true)
                    .frame(width: width)
                    .accessibilityIdentifier("CurrentDayList")
                dayList(for: screen.nextDayView, isShown: false)
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
            // The cancellation half of the reset described on `lockedDragAxis` and
            // `isDraggingDay` above: when SwiftUI resets `isDraggingDay` to `false` — on a
            // completed drag or a cancelled one alike — this clears the lock too, so a drag that
            // never reaches `onEnded` cannot leave the day lists permanently unscrollable.
            .onChange(of: isDraggingDay) { _, dragging in
                if !dragging {
                    lockedDragAxis = nil
                }
            }
        }
    }

    /// One day's rows, in a plain `List` — the same groups, the same per-row rendering and the
    /// same `ForEach(Array(group.rows.enumerated()), id: \.offset)` keying this screen has always
    /// used, now driven by whichever of the three day views this list was handed. `nil` — only
    /// possible at either end of the calendar — draws an empty list; the drag never reveals it,
    /// because it resists at that end (`daySwipeGesture`). `isShown` is `true` only for
    /// `screen.dayView`'s own list, and decides nothing but which line ends the One-offs group:
    /// the live one-off entry there, a disabled line on either neighbour (`design.md` § *The
    /// shell*) — acting on a one-off row from a neighbouring day is inert the same way a
    /// commitment row's tap already is, so the rows themselves need no `isShown` distinction.
    @ViewBuilder
    private func dayList(for dayView: DayView?, isShown: Bool) -> some View {
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
                // The One-offs group, after every group of commitments — `openspec/specs/
                // day-screen/spec.md`'s *A day view draws the one-offs standing on its date as
                // one group headed One-offs*. `dayView.oneOffGroup` is `nil` only where this
                // screen is not keeping one-offs at all; it is still drawn, holding no rows but
                // the entry, on a day none stand on (`design.md` § *The empty group is the
                // offer*). One-off rows are keyed by value, not by offset — a tick or a rename
                // re-keys a row by its new value on purpose (grill answer 19), unlike a
                // commitment row's tap, which the offset above still keys through.
                if let oneOffGroup = dayView.oneOffGroup {
                    Section {
                        ForEach(oneOffGroup.rows, id: \.self) { row in
                            oneOffRowView(row)
                        }
                        oneOffEntryView(isShown: isShown)
                    } header: {
                        Text(oneOffGroup.heading)
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 6, trailing: 16))
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

    /// One one-off row's content and the two taps that act on it (grill answers 21-24, reopened
    /// at the phone check after the long-press *Rename* below proved unreachable on the device: it
    /// worked around a `contextMenu` teardown race with `DispatchQueue.main.asyncAfter`, and the
    /// owner asked for a different gesture rather than a fix for it). A tap on the drawn name
    /// alone starts a rename of this row, on every one-off row: done or not, and a later day's
    /// row that offers no tick included (answer 24, "rename stays offered on every one-off row").
    /// A tap anywhere else on it, the lateness words included, ticks or takes back as before,
    /// offered exactly where `offersTick(asOf:)` says so and a no-op where it is not.
    ///
    /// **The name is an always-present `TextField`, never conditionally swapped in for a
    /// `Button`- or `Text`-drawn name the moment renaming starts.** Three other shapes were each
    /// built and driven for real on the simulator first, and every one of them left the row a
    /// plain, unticked button with no field ever gaining focus: (1) a `.highPriorityGesture`
    /// nested inside the row's enclosing `Button`; (2) a plain `.onTapGesture` nested the same
    /// way, ruling out `Button` specifically as the cause; (3) the name as its *own*, sibling
    /// `Button` — not nested in anything — whose action did nothing but `oneOffFocus = .row(row)`.
    /// A control check on that same freshly-added row, reduced to a lone `Button` calling
    /// `screen.tick(row)`, ticked correctly on the identical driven tap — ruling out the row, the
    /// coordinate and a freshly-inserted List cell as the cause. What every failing shape shared
    /// was asking `@FocusState` to focus a `TextField` that does not exist until that same update
    /// creates it; the one thing that has ever reliably taken focus from a plain tap in this file
    /// is the one-off entry, which is a `TextField` from the first frame it is ever drawn. This
    /// row's name is now built the same way, and driving it — see `tasks.md` § 7.4 — is what
    /// actually opened the field and brought the keyboard up.
    ///
    /// `TextField` draws its own text; it has no `.strikethrough()` the way `Text` does, so a
    /// done row's struck-through name is drawn by a `Text` `.overlay`, `.allowsHitTesting(false)`
    /// so the tap still reaches the field beneath it, shown only while not renaming — the field's
    /// own text is `Color.clear` there rather than removed, so the field itself, and the tap
    /// target it is, never leaves the tree.
    ///
    /// The rest of the row — the mark and the lateness words — is a second, sibling `Button`,
    /// proven reliable by the control above, on the *same* line as the name rather than a second
    /// line below it: `.frame(maxWidth: .infinity, maxHeight: .infinity)`, so it fills the row's
    /// own remaining width and matches its own height, and ticks or takes back exactly where
    /// `offersTick(asOf:)` says so. `lateInWords` is its own `Text` rather than folded into the
    /// name's the way `rowView(_:)` folds a commitment's rhythm in with `commitmentLine` — a
    /// shared `Text` has no seam two independent `Button`s can split — but sits beside the mark
    /// exactly where `commitmentLine` would draw it, since nothing here forces the two apart:
    /// `lateInWords` is only ever non-`nil` on an undone row (`DayView.OneOffRow`'s own guard),
    /// and a mark only ever draws on a done one, so the two never compete for the space. The
    /// notices are *not* inside this `Button` — see the `VStack` wrapping this whole function's
    /// body — so nothing here forces a row with neither a mark nor a lateness word to draw tall
    /// enough to tap by hand, which is what a `44`pt minimum on this `Button` alone once did.
    /// Both `Button`s share `opacity`, so the row still fades together (ADR-1045 decisions 3 and
    /// 5) on a day it offers no tick, name included. A long press still opens a `contextMenu`,
    /// now with a destructive *Remove* alone — *Rename* lived there; the tap above replaces it
    /// rather than fixing it in place.
    @ViewBuilder
    private func oneOffRowView(_ row: DayView.OneOffRow) -> some View {
        let isRenaming = oneOffFocus == .row(row)
        let nameColor: Color = row.isDone ? .secondary : .primary
        let markSystemName: String? = row.isDone ? "checkmark" : nil
        let markColor: Color = Color.green
        let offersTick = row.offersTick(asOf: today())

        // The name and the rest of the row share one line; the notices sit on a second line
        // below both, in one place rather than one copy per branch — a phone check on b3860c8
        // found "Already on this day" drawn *beside* the name while renaming, not below it,
        // because that branch put the refusal in a `VStack` that was a sibling of the `TextField`
        // in the same `HStack`, not underneath it (`design.md` § *A refusal under a name field*,
        // grill answers 11 and 18: "under" is not negotiable). One `VStack` outside the line
        // fixes that for both branches at once, and reads `screen.notice`/`screen.nameRefusal`
        // the same way regardless of `isRenaming`, since a row keeps telling either while it is
        // being edited, not just while it is not.
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                TextField("", text: oneOffRowTextBinding(for: row))
                    .focused($oneOffFocus, equals: .row(row))
                    .onSubmit {
                        // `commitFocusedOneOffField()` commits this row and drops focus, or — a
                        // rename it finds refused — leaves the row focused with the typed name
                        // and the cause showing under it; see its own doc comment.
                        commitFocusedOneOffField()
                    }
                    .foregroundStyle(isRenaming ? Color.primary : Color.clear)
                    .overlay(alignment: .leading) {
                        if !isRenaming {
                            Text(row.name)
                                .foregroundStyle(nameColor)
                                .strikethrough(row.isDone)
                                .allowsHitTesting(false)
                        }
                    }
                    .fixedSize()

                // Lateness words on the same line as the name — as `rowView(_:)`'s own
                // `commitmentLine` draws a commitment's rhythm — rather than a line of their own
                // below it: a row with nothing else to show (an ordinary undone one-off, due
                // today) would otherwise be a `Button` with no content at all, and forcing it
                // tall enough to tap by hand is what made every one-off row noticeably thicker
                // than a commitment row, empty space and all, on the phone. `.frame(maxHeight:
                // .infinity)` is what actually keeps it tappable without that: it stretches this
                // `Button` to match its own row's height — set by the `TextField` beside it, or
                // by the List's own row minimum where that is taller — rather than this `Button`
                // setting the row's height itself, the way the deleted `minHeight: 44` did.
                if !isRenaming {
                    Button {
                        if offersTick {
                            try? screen.tick(row)
                        }
                    } label: {
                        HStack {
                            if let lateInWords = row.lateInWords {
                                Text(verbatim: lateInWords)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer(minLength: 0)
                            if let markSystemName {
                                Image(systemName: markSystemName)
                                    .foregroundStyle(markColor)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            if row == screen.notice?.oneOffRow {
                Text(screen.notice?.cause ?? "Not saved. Try again.")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
            if screen.nameRefusal?.row == row {
                Text(screen.nameRefusal?.cause ?? "Not saved. Try again.")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .opacity(isRenaming || offersTick ? 1 : 0.5)
        .contextMenu {
            if !isRenaming {
                Button("Remove", role: .destructive) {
                    try? screen.remove(row)
                }
            }
        }
    }

    /// The one-off entry: a `TextField` as the last line of the shown day's One-offs group,
    /// focused by the toolbar `+` and by nothing else; a disabled, non-interactive line in the
    /// same place on either neighbour, since typing there would commit to the wrong day.
    /// `design.md` § *The shell*.
    ///
    /// **Return no longer opens a fresh entry (grill answer 25, reopened from answer 6).** A
    /// kept add — or a blank one, which adds nothing — drops focus and closes the keyboard,
    /// exactly as the checkmark already does for a kept commit; a refused add leaves focus where
    /// it is, showing the typed text and the cause under it, same as check 1 already does. This
    /// reads `screen.nameRefusal` itself, deliberately *not* routed through
    /// `commitFocusedOneOffField()`: that function's own `.entry` case has no refusal check at
    /// all, and giving it one would also change what the checkmark does for a refused entry —
    /// asked for here only for Return.
    ///
    /// **The refused branch re-asserts `oneOffFocus = .entry` rather than simply leaving it
    /// untouched, and driving this for real on the simulator is what found that the second half
    /// matters.** Pressing Return on a `TextField` resigns its first responder as part of
    /// handling the key itself, independently of anything this closure does; `@FocusState`
    /// reflects that resignation back, so a refusal found by *only* skipping the drop — never
    /// writing `oneOffFocus` at all — still lost focus, keyboard included, exactly the outcome
    /// this exists to avoid. `commitFocusedOneOffField()`'s own refused branch for a row already
    /// re-asserts `oneOffFocus = .row(row)` for the same reason; this mirrors it for `.entry`.
    @ViewBuilder
    private func oneOffEntryView(isShown: Bool) -> some View {
        if isShown {
            VStack(alignment: .leading) {
                TextField("New one-off", text: oneOffEntryTextBinding)
                    .focused($oneOffFocus, equals: .entry)
                    .onSubmit {
                        commitOneOffEntry()
                        if let nameRefusal = screen.nameRefusal, nameRefusal.row == nil {
                            // Refused: re-assert focus, showing the typed text and the
                            // cause under it (check 1) — see this function's own doc
                            // comment for why re-asserting, not just leaving it, is needed.
                            oneOffFocus = .entry
                        } else {
                            // Kept, or blank (adds nothing): drop focus and close the
                            // keyboard, matching what the checkmark already does.
                            justCommittedOneOffField = true
                            oneOffFocus = nil
                        }
                    }
                if screen.nameRefusal?.row == nil, let nameRefusal = screen.nameRefusal {
                    Text(nameRefusal.cause ?? "Not saved. Try again.")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
        } else {
            Text("New one-off")
                .foregroundStyle(.secondary)
                .opacity(0.5)
        }
    }

    /// The entry's text: `oneOffEntryCommitText`, the same value `commitOneOffEntry()` would
    /// send — `nameRefusal`'s own `text` while a refusal stands under the entry, so what was
    /// typed is what keeps showing, `oneOffEntryText` otherwise. `design.md` § *A refusal under a
    /// name field is its own value, and there is one at a time*. Typing here ends a refusal
    /// standing under the entry — `screen.nameRefusal?.row == nil` reads true both there and
    /// where nothing is told at all, and false only where a *row's* refusal stands, which this
    /// must leave alone (`openspec/specs/day-screen/spec.md` § *What a day screen tells under a
    /// one-off name field lasts until…*: "the text in *that* field is edited"). Guarded on
    /// `newValue` actually differing from what is shown: a `TextField` flushes its own last-drawn
    /// text back through this `set` when it loses focus, which lands here *after*
    /// `commitOneOffEntry()` has already set a fresh `nameRefusal` for the very same text — read
    /// unguarded, that flush re-ends the refusal it was reporting and restores the stale text
    /// `commitOneOffEntry()` had just emptied, which is how a refused add both told nothing and
    /// outlived the entry across a chevron move that committed it a second time. A flush always
    /// repeats `oneOffEntryCommitText` verbatim, so this cannot also swallow a genuine keystroke.
    private var oneOffEntryTextBinding: Binding<String> {
        Binding(
            get: { oneOffEntryCommitText },
            set: { newValue in
                guard newValue != oneOffEntryCommitText else {
                    return
                }
                if screen.nameRefusal?.row == nil {
                    screen.oneOffNameEdited()
                }
                oneOffEntryText = newValue
            }
        )
    }

    /// `row`'s own name field's text, the same rule `oneOffEntryTextBinding` reads by:
    /// `nameRefusal`'s `text` while it stands under this row, `oneOffRowText` otherwise. Typing
    /// here ends a refusal standing under this row, or ends nothing where none stands, but must
    /// leave alone a refusal standing under a *different* field — the entry, or (`isRenaming`
    /// only ever showing one row's field at a time) a row reached by `Rename` while another row's
    /// refusal was left in place. Same requirement as `oneOffEntryTextBinding`, guarded the same
    /// way and for the same reason: a stale flush from this field losing focus must not re-end a
    /// refusal `commitRename(of:to:)` just set for the very text it is echoing back.
    private func oneOffRowTextBinding(for row: DayView.OneOffRow) -> Binding<String> {
        Binding(
            get: { oneOffRowDisplayText(for: row) },
            set: { newValue in
                guard newValue != oneOffRowDisplayText(for: row) else {
                    return
                }
                if screen.nameRefusal == nil || screen.nameRefusal?.row == row {
                    screen.oneOffNameEdited()
                }
                oneOffRowText = newValue
            }
        )
    }

    /// `row`'s own committed candidate — `nameRefusal`'s own `text` while a refusal stands under
    /// `row`, `oneOffRowText` otherwise — the same rule `oneOffEntryCommitText` reads the
    /// entry's by. **Every commit site must read this, and never raw `oneOffRowText` directly**:
    /// a refusal empties `oneOffRowText` the moment it is set (`commitRename(of:to:)`'s own doc
    /// comment, "the shell empties its field on every commit"), so a *second* commit attempt on
    /// the same still-refused row — the checkmark tapped again, or a day change arriving while
    /// the refusal still stands — that read `oneOffRowText` raw would send blank, and a blank
    /// rename removes the one-off outright (grill answer 16). That is exactly what reached the
    /// phone on b3860c8: renaming onto a name already held, then leaving the day or tapping the
    /// checkmark again, deleted the one-off it was refused for, rather than leaving it exactly as
    /// it was (grill answers 12 and 18). Unlike `oneOffRowDisplayText(for:)`, this does not gate
    /// on `row` being the *currently* focused row: `.onChange(of: oneOffFocus)` calls this for
    /// `oldValue`'s row after `oneOffFocus` has already moved on to `newValue`, so reading live
    /// focus there would silently swap in `row.name` and lose whatever was typed or refused.
    private func oneOffRowCommitText(for row: DayView.OneOffRow) -> String {
        if let nameRefusal = screen.nameRefusal, nameRefusal.row == row {
            return nameRefusal.text
        }
        return oneOffRowText
    }

    /// `row`'s own name field's shown text. The field is now always present (`oneOffRowView(_:)`
    /// never swaps it out for a `Text`, for reasons its own doc comment gives), so this reads
    /// `row.name` itself wherever this row is not the one with focus, and `oneOffRowCommitText(for:)`
    /// — the same value a commit would send — while it does. Read by both the `get` and the
    /// `set` of `oneOffRowTextBinding(for:)` so a stale flush is recognised by the same rule
    /// that draws the field.
    private func oneOffRowDisplayText(for row: DayView.OneOffRow) -> String {
        guard oneOffFocus == .row(row) else {
            return row.name
        }
        return oneOffRowCommitText(for: row)
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
            .updating($isDraggingDay) { _, isDraggingDay, _ in
                isDraggingDay = true
            }
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
                    commitFocusedOneOffField(forDeparture: true)
                    settle(to: -pageWidth) { screen.showNextDay() }
                } else if width > 0, screen.previousDayView != nil, carries {
                    commitFocusedOneOffField(forDeparture: true)
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
        commitFocusedOneOffField(forDeparture: true)
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
