import Foundation
import SwiftUI
import Symbols
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

/// The clock a copy's moment is stamped from, beside `today()`'s own conversion — `today()`
/// widened to the hour and the minute, read from `Calendar.current` at the same edge, per
/// ADR-1004. `nil` only where the day itself cannot form, which `today()` never answers either.
/// `openspec/changes/copy-on-every-change/design.md` § *The moment is a clock handed in, as
/// ADR-1004 has it*.
private func momentNow() -> Moment? {
    let components = Calendar.current.dateComponents(
        [.year, .month, .day, .hour, .minute], from: Date())
    guard let year = components.year, let month = components.month, let day = components.day,
        let hour = components.hour, let minute = components.minute,
        let date = CalendarDate(year: year, month: month, day: day)
    else {
        return nil
    }
    return Moment(on: date, hour: hour, minute: minute)
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

/// The note sheet's field. A `UITextView` that takes first responder itself the moment it lands in
/// a window — `didMoveToWindow`, once — so the keyboard is asked for while the sheet is being
/// presented and rises alongside it, as it does with the number's alert. The SwiftUI way, a
/// `TextEditor` with `.task { focused = true }` (B-075), only asked once the sheet had finished
/// sliding in, a visible pause; `.defaultFocus` does not take on iOS at all. The look is
/// `TextEditor`'s own — a clear background, the body font, the text view's default insets — and
/// the text still goes back to the presenter as typed, through the binding.
private struct NoteEditorField: UIViewRepresentable {
    @Binding var text: String
    /// `false` where the field is not the point of the sheet it sits in: it opens with the keyboard down.
    var focusesOnAppear = true

    func makeUIView(context: Context) -> UITextView {
        let view = FocusOnAppearTextView()
        view.asksForFocus = focusesOnAppear
        view.delegate = context.coordinator
        view.backgroundColor = .clear
        view.font = .preferredFont(forTextStyle: .body)
        view.adjustsFontForContentSizeCategory = true
        view.text = text
        return view
    }

    func updateUIView(_ view: UITextView, context: Context) {
        context.coordinator.text = $text
        if view.text != text {
            view.text = text
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(text: $text) }

    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>

        init(text: Binding<String>) { self.text = text }

        func textViewDidChange(_ view: UITextView) {
            text.wrappedValue = view.text
        }
    }
}

private final class FocusOnAppearTextView: UITextView {
    private var askedForFocus = false
    var asksForFocus = true

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil, asksForFocus, !askedForFocus {
            askedForFocus = true
            becomeFirstResponder()
        }
    }
}

/// The total entry's Amount field, for the same reason as `NoteEditorField`: a `UITextField` with
/// the decimal pad that takes first responder in `didMoveToWindow`, so the keyboard rises with the
/// sheet rather than after it. The text goes back as typed, through the binding.
private struct TotalAmountField: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextField {
        let view = FocusOnAppearTextField()
        view.placeholder = "Amount"
        view.keyboardType = .decimalPad
        view.font = .preferredFont(forTextStyle: .body)
        view.adjustsFontForContentSizeCategory = true
        view.text = text
        view.addTarget(
            context.coordinator, action: #selector(Coordinator.editingChanged(_:)),
            for: .editingChanged)
        return view
    }

    func updateUIView(_ view: UITextField, context: Context) {
        context.coordinator.text = $text
        if view.text != text {
            view.text = text
        }
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView view: UITextField, context: Context)
        -> CGSize?
    {
        CGSize(width: proposal.width ?? view.intrinsicContentSize.width,
            height: view.intrinsicContentSize.height)
    }

    func makeCoordinator() -> Coordinator { Coordinator(text: $text) }

    final class Coordinator: NSObject {
        var text: Binding<String>

        init(text: Binding<String>) { self.text = text }

        @objc func editingChanged(_ field: UITextField) {
            text.wrappedValue = field.text ?? ""
        }
    }
}

private final class FocusOnAppearTextField: UITextField {
    private var askedForFocus = false

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil, !askedForFocus {
            askedForFocus = true
            becomeFirstResponder()
        }
    }
}

/// The Kit screen the Settings sheet is open to, wrapped so `.sheet(item:)` can drive the sheet.
private struct OpenSettings: Identifiable {
    let id = UUID()
    let screen: CommitmentsScreen
}

/// The happening a note sheet is open for, so `.sheet(item:)` can drive it.
private struct NotedHappening: Identifiable {
    let happening: Happening
    var id: Happening.Identity { happening.identity }
}

/// The occurrence a change sheet is open for, so `.sheet(item:)` can drive it.
private struct ChangedOccurrence: Identifiable {
    let id = UUID()
    let name: String
    let occurrence: Occurrence
}

/// `calendarDate`'s day with the hour and minute of `time`, as the instant a SwiftUI `DatePicker`
/// needs — the reverse of `timeOfDay(from:)`, and edge code like `date(from:)` above (ADR-1004).
private func date(at time: TimeOfDay) -> Date {
    Calendar.current.date(bySettingHour: time.hour, minute: time.minute, second: 0, of: Date())
        ?? Date()
}

/// The hour and minute a picked instant reads as, on the device's own calendar.
private func timeOfDay(from date: Date) -> TimeOfDay? {
    let components = Calendar.current.dateComponents([.hour, .minute], from: date)
    guard let hour = components.hour, let minute = components.minute else {
        return nil
    }
    return TimeOfDay(hour: hour, minute: minute)
}

/// The sheet a happening is noted from: its name as the title, *Cancel* and *Save*, a *Time* row
/// showing the time with a clear button, or *No time* to tap to set one, and the multi-line note
/// field the note-commitment sheet uses. Decides nothing — `DayScreen.note` judges, and a refusal
/// keeps the sheet open over its red line until the next Save or until it closes. ADR-1019;
/// `openspec/changes/note-occurrence-on-day-screen/design.md` § *The shell*.
private struct NoteHappeningSheet: View {
    let title: String
    let boundedAtNow: Bool
    let focusesNote: Bool
    let save: (TimeOfDay?, String) -> DayScreen.OccurrenceRefusal?
    /// Present where the sheet is open on an occurrence already noted: *Take back* at its foot.
    let takeBack: (() -> DayScreen.OccurrenceRefusal?)?

    @Environment(\.dismiss) private var dismiss
    @State private var time: Date?
    @State private var noteText: String
    @State private var refusal: DayScreen.OccurrenceRefusal?
    @State private var confirmingTakeBack = false
    @State private var takeBackRefused = false

    init(
        happening: Happening, startingTime: TimeOfDay?,
        save: @escaping (TimeOfDay?, String) -> DayScreen.OccurrenceRefusal?
    ) {
        self.title = happening.name
        self.boundedAtNow = startingTime != nil
        self.focusesNote = true
        self.save = save
        self.takeBack = nil
        _time = State(initialValue: startingTime.map(date(at:)))
        _noteText = State(initialValue: "")
    }

    /// Open on `occurrence`, its time and note filled in, bounded at now where `boundedAtNow`.
    init(
        changing occurrence: Occurrence, named name: String, boundedAtNow: Bool,
        save: @escaping (TimeOfDay?, String) -> DayScreen.OccurrenceRefusal?,
        takeBack: @escaping () -> DayScreen.OccurrenceRefusal?
    ) {
        self.title = name
        self.boundedAtNow = boundedAtNow
        self.focusesNote = false
        self.save = save
        self.takeBack = takeBack
        _time = State(initialValue: occurrence.time.map(date(at:)))
        _noteText = State(initialValue: occurrence.note ?? "")
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                VStack(spacing: 12) {
                    HStack {
                        Text("Time")
                        Spacer()
                        if let picked = time {
                            if boundedAtNow {
                                DatePicker(
                                    "Time",
                                    selection: Binding(get: { picked }, set: { time = $0 }),
                                    in: ...Date(), displayedComponents: .hourAndMinute
                                )
                                .labelsHidden()
                            } else {
                                DatePicker(
                                    "Time",
                                    selection: Binding(get: { picked }, set: { time = $0 }),
                                    displayedComponents: .hourAndMinute
                                )
                                .labelsHidden()
                            }
                            Button {
                                time = nil
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.borderless)
                            .accessibilityLabel("Clear time")
                        } else {
                            Button("No time") {
                                time = Date()
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                    .padding(12)
                    .background(
                        Color(.secondarySystemGroupedBackground),
                        in: RoundedRectangle(cornerRadius: 12))
                    NoteEditorField(text: $noteText, focusesOnAppear: focusesNote)
                        .padding(8)
                        .background(
                            Color(.secondarySystemGroupedBackground),
                            in: RoundedRectangle(cornerRadius: 12))
                    if takeBack != nil {
                        Button("Take back", role: .destructive) {
                            confirmingTakeBack = true
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(
                            Color(.secondarySystemGroupedBackground),
                            in: RoundedRectangle(cornerRadius: 12))
                        .confirmationDialog(
                            "Take back this occurrence?", isPresented: $confirmingTakeBack,
                            titleVisibility: .visible
                        ) {
                            Button("Take back", role: .destructive) {
                                refusal = nil
                                takeBackRefused = takeBack?() != nil
                                if !takeBackRefused {
                                    dismiss()
                                }
                            }
                            Button("Cancel", role: .cancel) {}
                        }
                    }
                    if takeBackRefused {
                        Text("Not taken back. Try again.")
                            .font(.caption)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    if let refusal {
                        Text(
                            refusal == .notYetCome
                                ? "That time has not come yet." : "Not saved. Try again."
                        )
                        .font(.caption)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        takeBackRefused = false
                        refusal = save(time.flatMap(timeOfDay(from:)), noteText)
                        if refusal == nil {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    // One copy place, built with `momentNow` and handed to every screen built here — the day
    // screen, the commitments screen the toolbar button below pushes and the Settings sheet —
    // `openspec/changes/copy-on-every-change/design.md` § *One copy place, handed to both
    // screens*. `@State` rather than a `let`: `CopyPlace` is a reference type this view never
    // reassigns, but `@State` is what SwiftUI's own convention already uses for `screen` below,
    // and keeps this view's every stored property on the same footing.
    @State private var copyPlace: CopyPlace
    // The app's second setting, beside `copyPlace` — `openspec/changes/turn-birthdays-on/
    // design.md` § *A type of its own beside `CopyPlace`, not a member of `CommitmentsScreen`*:
    // one instance, built here and handed to `SettingsView`, reading and asking through the
    // shell's own adapter in `BirthdayCalendarAccess.swift`.
    @State private var birthdaySwitch: BirthdaySwitch
    @State private var screen: DayScreen
    // ADR-1045's 2026-09-28 amendment: "one light impact for every change the screen keeps, and a
    // selection tick when a day turns". Neither is read for its value — each only has to change
    // for `.sensoryFeedback(_:trigger:)` on `body` to fire — so a plain counter is enough for
    // both.
    @State private var changesKept = 0
    @State private var daysTurned = 0
    @Environment(\.scenePhase) private var scenePhase
    // `openspec/changes/add-adjacent-day-views/design.md` § *What the shell draws*: the settle
    // at release is animated, and Reduce Motion turns that half off — the drag itself goes on
    // tracking the finger either way. The chevrons that once played the same settle on a tap are
    // gone (`add-week-strip`, #346); the week strip replaces the day where it stands instead.
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showingCommitments = false
    @State private var commitmentsScreen: CommitmentsScreen?
    // Settings builds a Kit screen of its own each time it opens, `add-settings-screen/design.md`
    // § *Settings builds a Kit screen of its own each time it opens*, and drops it on dismissal.
    // `settingsScreen` is what the sheet is open to and is `nil` once it is dismissed;
    // `lastSettingsScreen` holds the same Kit screen, set beside it in the Settings button's action,
    // so `onDismiss`'s `returnedTo(from:)` can name the screen the sheet was open to and never
    // depends on the sheet's content having appeared. It is dropped after that call.
    @State private var settingsScreen: OpenSettings?
    @State private var lastSettingsScreen: CommitmentsScreen?
    @State private var enteringRow: DayView.Row?
    @State private var enteringText = ""
    // The chosen row whose values are open in a popover, or `nil` while none is — a chosen
    // entry's tap opens this rather than `enteringRow`'s alert (`design.md` § *The shell rides
    // this Story*). Attached to that row's own `Button` in `rowView(_:)`, so the popover is
    // anchored to the row that opened it rather than presented once for the whole list.
    @State private var choosingRow: DayView.Row?
    @State private var enteringNoteRow: DayView.Row?
    @State private var notingHappening: NotedHappening?
    // A happening row tapped with several occurrences on the day shown opens a popover of them;
    // one tapped in it is held here until the popover has gone, then opens the change sheet.
    @State private var choosingHappeningRow: DayView.HappeningRow?
    @State private var pendingOccurrence: ChangedOccurrence?
    @State private var changingOccurrence: ChangedOccurrence?
    @State private var enteringNoteText = ""
    @State private var enteringTotalRow: DayView.Row?
    @State private var enteringTotalText = ""
    // Which one-off name field, if any, has focus — the entry or a row's rename field. Only one
    // field is ever focused at a time (`design.md` § *A refusal under a name field is its own
    // value, and there is one at a time*), so a single `@FocusState` value stands for all of
    // them, driving both the TextField that has it and the checkmark that reads it.
    //
    // **This tracks the bar's own entry again, in both directions, because `oneOffBar` is pinned
    // with `.safeAreaInset`, not `.safeAreaBar` — that property's own doc comment has why.** A
    // fix round found `.focused($oneOffFocus, equals: .entry)` did nothing for a field hosted in
    // `.safeAreaBar`'s own content, on this SDK, in either direction, and that a `@FocusState`
    // declared local to that same content did no better; `.safeAreaInset` is the ordinary view
    // tree, and this same declaration tracks the field again once the bar is hosted there
    // instead.
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
    // Whether the calendar sheet the date row opens is showing — `dayControls`' own `Button`
    // sets it, and a day picked in the sheet clears it, so the sheet never stays open over the
    // day it has just moved to.
    @State private var pickingDay = false
    // The paged day content's own width, measured off `GeometryReader` and used both to size the
    // full slide a carry settles to and as the threshold a drag must cross to carry.
    // `dragTranslation` is the live offset applied to the three-list `HStack`: the drag's own
    // `width` while a finger is down, and the settle's target while one is not.
    @State private var pageWidth: CGFloat = 0
    @State private var dragTranslation: CGFloat = 0
    // A day swipe's own settle, kept so a jump can cancel it and a cancelled drag can be told
    // from a released one. `daySettling` is true from `settle(to:then:)` starting an animated
    // slide until that slide lands; `daySettleMove` is the day move that landing will make;
    // `daySettleGeneration` is bumped by every cancel, and a slide's completion acts only where
    // the generation it captured still stands — so a week strip tap, `Today` or the day picker
    // that ran inside the ~0.35 s window is never followed by the swipe's own move on top.
    @State private var daySettling = false
    @State private var daySettleMove: (() -> Void)?
    @State private var daySettleGeneration = 0
    // Until when a one-off's tick is the tail of a day swipe rather than a tap of its own. Pushed
    // out by every sample the day swipe reports and by its end. Read off the phone with
    // `NSLog` on the simulator, 2026-09-30: the drag's samples come first, then `onEnded`, then
    // the Button's action, all at the one touch-up — and the button's pressed state arrives
    // *after* the first samples of a fast flick, so anything cleared by it can wipe what those
    // samples set. Nothing clears this but time.
    @State private var swipeClaimsTicksUntil = Date.distantPast
    // The week strip's own live drag offset — `weekStrip`'s own counterpart to `dragTranslation`
    // above, kept apart from it (`tasks.md` § 6.2: "the day swipe... and `settle(to:then:)`'s
    // rows untouched") since the strip pages independently of the rows beneath it: a strip drag
    // never slides `pagedDayContent`, and a day swipe never slides the strip.
    @State private var weekDragTranslation: CGFloat = 0
    // The first sample's own `translation.width`, reported by `weekSwipeGesture()`'s `DragGesture`
    // once minimum distance is met — subtracted from every later sample so the strip tracks the
    // finger from zero instead of jumping by that first sample; `nil` between drags. Reset by
    // `onChange(of: isDraggingWeekStrip)`, the same as `lockedDragAxis` is below, so a cancelled
    // drag cannot leave a stale baseline for the next one to subtract.
    @State private var weekDragStartWidth: CGFloat?
    // Set for as long as `beginWeekStripSettle(to:then:)`'s own animation is in flight.
    // `finishWeekStripSettleNow()` is what a chevron tap, a carried release or a new drag starting
    // calls before acting on its own input, so at most one settle is ever in flight: each finishes
    // the one running, at once and without animation, and only then decides what to do with the
    // day that leaves the screen on.
    @State private var weekStripIsSettling = false
    // The move the settle currently in flight will make once it lands, run by
    // `finishWeekStripSettle(generation:)` — reached either through that settle's own animation
    // completion or through `finishWeekStripSettleNow()` finishing it early.
    @State private var weekStripSettleMove: (() -> Void)?
    // Bumped by `finishWeekStripSettleNow()` before it finishes a settle early, and by
    // `beginWeekStripSettle(to:then:)` when it starts one; `finishWeekStripSettle(generation:)`
    // acts only where the generation it was handed still matches, so a settle's own animation
    // completion, reaching it after `finishWeekStripSettleNow()` already has, does nothing.
    @State private var weekStripSettleGeneration = 0
    // The week strip's own last measured width — `weekChevronButton(direction:)`'s counterpart to
    // `pageWidth` above, kept current the same way that is, from the strip's own `GeometryReader`
    // (`weekStrip`'s `.onAppear`/`.onChange(of:)`).
    @State private var weekStripWidth: CGFloat = 0
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
    // `weekSwipeGesture()`'s own counterpart to `isDraggingDay` above, and reset the same way, by
    // `weekStrip`'s own `onChange(of: isDraggingWeekStrip)`: cancelled, it clears
    // `weekDragStartWidth` and, where nothing is settling, snaps `weekDragTranslation` back to
    // zero rather than leaving the strip drawn part-way onto a neighbour until the next drag.
    // Becoming `true` is read the other way round too — a new drag starting is itself one of the
    // inputs `finishWeekStripSettleNow()` finishes a running settle for, so the drag begins from a
    // strip at rest.
    @GestureState private var isDraggingWeekStrip = false

    /// Builds the one `CopyPlace` this view holds before the day screen it hands it to, so the
    /// same instance backs both — `design.md` § *One copy place, handed to both screens*.
    init() {
        let copyPlace = CopyPlace(asking: momentNow)
        _copyPlace = State(initialValue: copyPlace)
        let birthdaySwitch = BirthdaySwitch(
            readingAccess: currentCalendarAccess, askingForAccess: askForCalendarAccess)
        _birthdaySwitch = State(initialValue: birthdaySwitch)
        _screen = State(
            initialValue: DayScreen(
                startingFrom: dayOneCommitments, asOf: today(),
                readingBirthdaysFrom: makeBirthdayCalendar(), whileOn: birthdaySwitch,
                copyingTo: copyPlace))
    }

    /// Runs `change` against `screen`, ignoring anything it throws — every caller already does,
    /// via `try?` — and bumps `changesKept` only where `screen.dayView` came out different
    /// afterwards. `DayView` is `Hashable` (`DayByDayKit/DayView.swift:3`), so this is a plain
    /// equality check rather than a second rule of its own about what counts as a change.
    ///
    /// **The guard is the snapshot-and-compare, not a read of whether the write "succeeded".**
    /// Every `DayScreen` write already leaves `dayView` untouched on the three cases that must
    /// never buzz — a row from a neighbouring day (an early `guard dayView.rows.contains(row)`
    /// returns before touching it), a refused value (the same shape of early return), and a
    /// value the record already held that a write still reaches the end of (the fresh
    /// `dayViewOfShownDay()` it assigns reads equal to the one before it) — so comparing the two
    /// snapshots catches all three without this file needing to know which guard fired inside
    /// `DayByDayKit`.
    private func keeping(_ change: () throws -> Void) {
        let before = screen.dayView
        try? change()
        if screen.dayView != before {
            changesKept += 1
        }
    }

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
            // The day is the title: the weekday in full, large, over the date row `dayControls`
            // draws beneath it. `screen.title` ("Fri") stays the kit's and is no longer drawn.
            .navigationTitle(weekdayInWords)
            .navigationBarTitleDisplayMode(.large)
            // ADR-1045's 2026-09-28 amendment: "one light impact for every change the screen
            // keeps, and a selection tick when a day turns, never the success haptic". Neither
            // trigger's value is read — `keeping(_:)` and the day-turn call sites bump a counter
            // purely to fire these.
            .sensoryFeedback(.impact(weight: .light), trigger: changesKept)
            .sensoryFeedback(.selection, trigger: daysTurned)
            .toolbar {
                // The way back to today: a plain text button on the toolbar's left, where it
                // is offered. On today itself, where it is not (§ *Offered*), the slot is empty
                // and the date row says "Today" in words instead — green is the kept checkmark's
                // alone (ADR-1045). Still gated on `screen.offersGoingBackToToday` and still
                // calls exactly what the button under the day row used to.
                ToolbarItem(placement: .topBarLeading) {
                    if screen.offersGoingBackToToday {
                        Button("Today") {
                            commitFocusedOneOffField(forDeparture: true)
                            cancelPendingDaySettle()
                            screen.showToday()
                        }
                    }
                }
                // Commitments and Settings, one trailing group — one capsule.
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        commitmentsScreen = CommitmentsScreen(asOf: today(), copyingTo: copyPlace)
                        showingCommitments = true
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                    .accessibilityLabel("Commitments")
                    Button {
                        let opened = CommitmentsScreen(asOf: today(), copyingTo: copyPlace)
                        lastSettingsScreen = opened
                        settingsScreen = OpenSettings(screen: opened)
                        birthdaySwitch.shown()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityLabel("Settings")
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
                    keeping { try screen.enter(enteringText, on: row) }
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
                            NoteEditorField(text: $enteringNoteText)
                                .padding(8)
                                .background(
                                    Color(.secondarySystemGroupedBackground),
                                    in: RoundedRectangle(cornerRadius: 12)
                                )
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
                                    keeping { try screen.enter(enteringNoteText, on: row) }
                                    enteringNoteRow = nil
                                }
                            }
                        }
                    }
                }
            }
            // A happening is noted in a sheet of its own, opened from the bolt's menu. `DayScreen`
            // answers the starting time and judges the Save; this draws both. `design.md` § *The shell*.
            .sheet(item: $notingHappening) { noted in
                NoteHappeningSheet(
                    happening: noted.happening,
                    startingTime: momentNow().flatMap { screen.startingTime(asOf: $0) }
                ) { time, note in
                    guard let now = momentNow() else {
                        return .notKept
                    }
                    var refusal: DayScreen.OccurrenceRefusal?
                    keeping { refusal = screen.note(noted.happening, at: time, saying: note, asOf: now) }
                    return refusal
                }
            }
            // An occurrence is changed or taken back in the noting sheet filled in. `DayScreen` judges
            // both; this draws them. `design.md` § *The shell*.
            .sheet(item: $changingOccurrence) { changed in
                NoteHappeningSheet(
                    changing: changed.occurrence, named: changed.name,
                    boundedAtNow: momentNow().flatMap { screen.startingTime(asOf: $0) } != nil,
                    save: { time, note in
                        guard let now = momentNow() else {
                            return .notKept
                        }
                        var refusal: DayScreen.OccurrenceRefusal?
                        keeping {
                            refusal = screen.change(
                                changed.occurrence, to: time, saying: note, asOf: now)
                        }
                        return refusal
                    },
                    takeBack: {
                        var refusal: DayScreen.OccurrenceRefusal?
                        keeping { refusal = screen.takeBack(changed.occurrence) }
                        return refusal
                    })
            }
            // A total takes an amount in a half-height sheet over the dimmed day: the row's name
            // with `soFarOfTarget` under it, the amount field focused as it opens so the keyboard is up, the row's usual
            // amounts under it — a tap adds one and closes — and *Take back last* below, where
            // `offersTakeBackLast(asOf:)` says it is. Nothing here decides anything: every word
            // and every amount is the Kit's, the field's text still goes to `enter(_:on:)` as
            // typed and a usual amount to `add(_:on:)`. `design.md` § *What the shell draws*.
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
                    let totalEntry = row.totalEntry(asOf: today())
                    NavigationStack {
                        Form {
                            Section {
                                TotalAmountField(text: $enteringTotalText)
                            }
                            if let totalEntry, !totalEntry.usualAmounts.isEmpty {
                                Section {
                                    ForEach(totalEntry.usualAmounts, id: \.self) { usualAmount in
                                        Button {
                                            keeping { try screen.add(usualAmount, on: row) }
                                            enteringTotalRow = nil
                                        } label: {
                                            HStack {
                                                Text(usualAmount.amount)
                                                    .frame(minWidth: 56, alignment: .leading)
                                                if let name = usualAmount.name {
                                                    Text(name)
                                                }
                                                Spacer()
                                            }
                                            .contentShape(Rectangle())
                                        }
                                        .listRowInsets(
                                            EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                                        )
                                        .foregroundStyle(.primary)
                                    }
                                }
                            }
                            if row.offersTakeBackLast(asOf: today()) {
                                Section {
                                    Button("Take back last", role: .destructive) {
                                        keeping { try screen.takeBackLast(on: row) }
                                        enteringTotalRow = nil
                                    }
                                }
                            }
                        }
                        .listSectionSpacing(.compact)
                        .contentMargins(.top, 0, for: .scrollContent)
                        .environment(\.defaultMinListRowHeight, 32)
                        .navigationTitle(row.name)
                        .navigationSubtitle(totalEntry?.soFarOfTarget ?? "")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    enteringTotalRow = nil
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Save") {
                                    keeping { try screen.enter(enteringTotalText, on: row) }
                                    enteringTotalRow = nil
                                }
                            }
                        }
                    }
                    .presentationDetents([.medium])
                }
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase != .active {
                commitFocusedOneOffField(forDeparture: true)
                finishDaySettleNow()
                snapBackIfNotSettling()
            }
            if phase == .active {
                // `screen.shown(asOf:)` reads `birthdaySwitch` itself first — `design.md`
                // § *The switch at every forming, the birthday place at opening and showing*
                // — so this no longer asks it directly.
                screen.shown(asOf: today())
                commitmentsScreen?.shown(asOf: today())
                settingsScreen?.screen.shown(asOf: today())
            }
        }
        .onChange(of: showingCommitments) { _, isShowing in
            if !isShowing {
                screen.returnedTo(from: commitmentsScreen)
                commitmentsScreen = nil
            }
        }
        .sheet(
            item: $settingsScreen,
            onDismiss: {
                // `settingsScreen` is already nil here; `lastSettingsScreen` is the screen the sheet
                // was open to.
                screen.returnedTo(from: lastSettingsScreen)
                lastSettingsScreen = nil
            }
        ) { open in
            SettingsView(screen: open.screen, birthdaySwitch: birthdaySwitch)
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
                keeping { try screen.rename(row, to: oneOffRowCommitText(for: row)) }
                oneOffRowText = ""
            }
        }
    }

    /// Commits whatever one-off field currently has focus — the entry, or a row's rename field —
    /// and, once committed, drops focus itself: a caller that also means to drop it need not set
    /// `oneOffFocus` a second time (the checkmark does not). Where an add or a rename this finds
    /// is refused, `forDeparture` decides what becomes of it, identically for both cases. `false`
    /// — the checkmark and either field's own Return — holds the field focused with its typed
    /// text and the cause under it (grill answer 18, "exactly as a refused add"). `true` — every
    /// caller about to move the day away from this field or send the app to the background: the
    /// week strip, swipe, `Today`, the day picker and `scenePhase` leaving `.active` — drops focus
    /// and, since `commitOneOffEntry()`/`commitRename(of:to:)` have already emptied their own
    /// state, the typed text with it, instead of holding it open on a page about to become a
    /// neighbour or go unseen (grill answer 12, "dropped with its text by the time the day
    /// lands"). Guarded on `oneOffFocus` being non-`nil` at entry, so a second, redundant call —
    /// `scenePhase` leaving `.active` calls this once per phase it passes through on the way to
    /// the background, `.inactive` and then `.background` — finds nothing left to commit and does
    /// nothing. Called before every one of the moves `design.md` § *The shell* names: the
    /// week strip, swipe, `Today`, the day picker and `scenePhase` leaving `.active`, in each case
    /// before the day actually moves.
    ///
    /// **The `.entry` case reads `commitOneOffEntry()`'s own return the same way the `.row` case
    /// already reads `commitRename(of:to:)`'s (a fourth fix round, on the owner's own reading of
    /// the phone build).** Before this, the checkmark dropped focus on a refused *add* regardless
    /// — unlike a refused *rename*, which it already left focused — because this case carried no
    /// refusal check at all; `oneOffBar`'s own `.onSubmit` read `screen.nameRefusal` itself and
    /// re-asserted `.entry` by hand, a second copy of exactly this logic that only Return ran.
    /// Giving `.entry` the same shape as `.row` here is what let `.onSubmit` be deleted down to a
    /// single call to this function, so there is now one path, not two, for a refused add's focus
    /// to stay in step.
    ///
    /// **Sends `oneOffRowCommitText(for: row)`, never raw `oneOffRowText` — a phone check on
    /// b3860c8 found what reading the raw state here actually does.** A row refused once already
    /// has an empty `oneOffRowText` (`commitRename(of:to:)` clears it on every attempt, kept or
    /// refused), so a *second* call here for the same still-refused row — the checkmark tapped
    /// again, or a day change arriving while the refusal stands, `forDeparture` true — sent blank,
    /// and a blank rename removes the one-off outright (grill answer 16) rather than leaving it
    /// exactly as it was (grill answers 12 and 18). `oneOffRowCommitText(for:)` reads the refusal
    /// back out instead, the same way `oneOffEntryCommitText` already did for the entry.
    ///
    private func commitFocusedOneOffField(forDeparture: Bool = false) {
        guard let focus = oneOffFocus else {
            return
        }
        switch focus {
        case .entry:
            let refused = commitOneOffEntry()
            guard !refused || forDeparture else {
                oneOffFocus = .entry
                return
            }
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
    /// always does, wherever `oneOffBar` itself shows; `.row(row)` only while `row` is still
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
    /// last claim on it, which the refusal itself, while it stands, already holds. Returns
    /// whether the attempt was refused — `screen.nameRefusal` standing for the entry (`row ==
    /// nil`) once `addOneOff` has returned — the same shape `commitRename(of:to:)` already
    /// returns for a row, so `commitFocusedOneOffField()` can treat both cases identically.
    @discardableResult
    private func commitOneOffEntry() -> Bool {
        let text = oneOffEntryCommitText
        keeping { try screen.addOneOff(named: text) }
        oneOffEntryText = ""
        if let nameRefusal = screen.nameRefusal, nameRefusal.row == nil {
            return true
        }
        return false
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
        keeping { try screen.rename(row, to: text) }
        oneOffRowText = ""
        return screen.nameRefusal?.row == row
    }

    /// The controls that stay put while the day's rows page beneath them: the date row that opens
    /// the day picker, the week strip under it, and the store messages — facts about the screen
    /// rather than about a day. `design.md` § *What the shell draws*: "the icons travel, the dock
    /// stays." Drawn outside the paged `List`s entirely, on purpose — ADR-1019's amended guard is
    /// that nothing here decides anything a test cannot already see decided behind the seam; this
    /// view only reads what `screen` already computed and calls `showDay(_:)`, the same move the
    /// day picker already called before this Story (`add-week-strip`, #346) replaced the chevrons
    /// with the strip. `Today` itself is no longer drawn here — it moved into the toolbar's
    /// leading item, gated on the same `offersGoingBackToToday` and calling the same two moves
    /// (`body`'s `.toolbar`).
    private var dayControls: some View {
        VStack(spacing: 8) {
            HStack {
                // The date row: leading, under the weekday title, and the way into the day
                // picker — a tap opens the calendar sheet below. The chevrons that used to
                // flank it are gone (`add-week-strip`, #346): the week strip beneath it is what
                // shows a day move now. It says "Today" in words on today, where the toolbar
                // offers no Today button, so the word shows once in either state. It animates
                // nothing, whatever a page settle is doing (`design.md` § *What the shell
                // draws*).
                Button {
                    pickingDay = true
                } label: {
                    Text(dateRowInWords)
                }
                .buttonStyle(.borderless)
                .accessibilityIdentifier("DayDate")
                .accessibilityLabel("Day")
                .accessibilityValue(dateRowInWords)
                Spacer()
            }
            .sheet(isPresented: $pickingDay) {
                dayPickerSheet
            }
            weekStripRowWithChevrons
            // The store lines, held in one card and drawn only while one of them applies — the
            // same states the switches below read, so the card can neither appear empty nor hide
            // a line. Words alone, offering nothing to act on (`restore/spec.md`); the causes red,
            // the way out grey, no colour of its own. The look-back's radius; its fill would vanish here, on
            // the plain `systemBackground` the controls stand on, so the fill is the next step grey.
            if storeLinesApply {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.caption)
                        .foregroundStyle(.red)
                    VStack(alignment: .leading, spacing: 8) {
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

                    // The three birthday lines, after the one-off lines — `design.md` § *The shell*.
                    // `.off` and `.on` say nothing: birthdays being off is not a fault, and the group
                    // itself already says they are on.
                    switch screen.birthdayState {
                    case .off, .on:
                        EmptyView()
                    case .calendarUnreadable:
                        Text("Birthdays could not be read.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    case .ticksUnreadable:
                        Text("The birthday ticks could not be read.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    case .ticksWrittenByALaterVersion:
                        Text(
                            "The birthday ticks were written by a newer version of DayByDay and must not be deleted."
                        )
                        .font(.caption)
                        .foregroundStyle(.red)
                    }

                    switch screen.happeningState {
                    case .kept:
                        EmptyView()
                    case .notKept:
                        Text("The happenings could not be read.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    case .writtenByALaterVersion:
                        Text(
                            "The happenings were written by a newer version of DayByDay and must not be deleted."
                        )
                        .font(.caption)
                        .foregroundStyle(.red)
                    }

                    // The one line pointing at the way out — `design.md` § *What the shell draws*: the
                    // secondary grey, not the red the causes above take, so the way out does not read as a
                    // third thing wrong.
                    if screen.saysACopyCanBeRestored {
                        Text("A copy can be restored from Settings")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    }
                    Spacer(minLength: 0)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    Color(.secondarySystemBackground),
                    in: RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.horizontal)
        // No gap above: the large title carries the space the 24pt here used to. And 12pt below,
        // down to where `pagedDayContent` starts — half the 24pt the phone walk on PR #194 chose
        // when the dock stood alone under an empty bar, now that the title sits over it. A
        // starting point for the owner to tune on the phone, not a measurement.
        .padding(.bottom, 12)
    }

    /// Whether the roster, the one-offs and the birthdays — the three places a day's list is drawn
    /// from — were all read, so an empty list means an empty day. Each state switched
    /// exhaustively, so a new case forces a decision here. Not `recordState`: the record holds
    /// ticks, not what is due.
    private var everySourceOfTheListWasRead: Bool {
        let rosterRead: Bool
        switch screen.rosterState {
        case .kept: rosterRead = true
        case .notKept, .writtenByALaterVersion: rosterRead = false
        }
        let oneOffsRead: Bool
        switch screen.oneOffState {
        case .kept: oneOffsRead = true
        case .unreadable, .writtenByALaterVersion: oneOffsRead = false
        }
        let birthdaysRead: Bool
        switch screen.birthdayState {
        case .off, .on: birthdaysRead = true
        case .calendarUnreadable, .ticksUnreadable, .ticksWrittenByALaterVersion:
            birthdaysRead = false
        }
        return rosterRead && oneOffsRead && birthdaysRead
    }

    /// Whether any store line `dayControls` draws applies — the four states its switches read and
    /// the way-out line, each state switched exhaustively, so a case added to one of them stops
    /// this compiling rather than leaving the card empty or a line hidden.
    private var storeLinesApply: Bool {
        let recordFaulty: Bool
        switch screen.recordState {
        case .kept: recordFaulty = false
        case .unreadable, .writtenByALaterVersion: recordFaulty = true
        }
        let rosterFaulty: Bool
        switch screen.rosterState {
        case .kept: rosterFaulty = false
        case .notKept, .writtenByALaterVersion: rosterFaulty = true
        }
        let oneOffsFaulty: Bool
        switch screen.oneOffState {
        case .kept: oneOffsFaulty = false
        case .unreadable, .writtenByALaterVersion: oneOffsFaulty = true
        }
        let birthdaysFaulty: Bool
        switch screen.birthdayState {
        case .off, .on: birthdaysFaulty = false
        case .calendarUnreadable, .ticksUnreadable, .ticksWrittenByALaterVersion:
            birthdaysFaulty = true
        }
        let happeningsFaulty: Bool
        switch screen.happeningState {
        case .kept: happeningsFaulty = false
        case .notKept, .writtenByALaterVersion: happeningsFaulty = true
        }
        return recordFaulty || rosterFaulty || oneOffsFaulty || birthdaysFaulty || happeningsFaulty
            || screen.saysACopyCanBeRestored
    }

    /// The navigation title: the shown day's weekday in full, "Friday". Formatted here from
    /// `screen.dayPickerReach.opensOn` — the day being shown — through `date(from:)`, in British
    /// English because every word the kit draws is English ("Every day", "14 March 2026") and a
    /// weekday in the device's own language beside them would be the worse mix.
    private var weekdayInWords: String {
        date(from: screen.dayPickerReach.opensOn)
            .formatted(Date.FormatStyle().weekday(.wide).locale(Locale(identifier: "en_GB")))
    }

    /// This app's own words for `calendarDate` in full, "25 September 2026" — day, then month in
    /// full, then year, in fixed British English. Shared by `dateRowInWords`, for the day being
    /// shown, and by `weekStripDay(_:)`'s accessibility label, for a week strip day's own date, so
    /// the two say a date the same way rather than each carrying its own `Date.FormatStyle`.
    private func fullDateInWords(_ calendarDate: CalendarDate) -> String {
        date(from: calendarDate)
            .formatted(
                Date.FormatStyle().day().month(.wide).year().locale(Locale(identifier: "en_GB")))
    }

    /// The date row's words: "25 September 2026", the look-back's form, and
    /// "Today, 25 September 2026" on today — where `screen.offersGoingBackToToday` is false and
    /// the toolbar offers no Today button, so "Today" is said here and only here.
    private var dateRowInWords: String {
        let words = fullDateInWords(screen.dayPickerReach.opensOn)
        return screen.offersGoingBackToToday ? words : "Today, \(words)"
    }

    /// The week strip: three weeks — `screen.previousWeekStrip`, `screen.weekStrip` and
    /// `screen.nextWeekStrip` — laid out side by side and clipped to the middle one's own width,
    /// under the date row (`page-the-week-strip`), exactly as `pagedDayContent` lays out the day
    /// before, the day being shown and the day after (`design.md` § *The shell*). A horizontal
    /// drag on it tracks the finger (`weekSwipeGesture()`), resisting where the neighbour it would
    /// reveal is `nil`; past a third of the width it pages (`pageWeekStrip(_:)`) —
    /// `pagedDayContent`'s own rows never slide for it, and the day swipe never slides this.
    /// `.highPriorityGesture` — rather than the day swipe's own
    /// `.simultaneousGesture` — is what takes the touch from an offered cell's `Button` before a
    /// swipe can also tap the day it began on: unlike the day rows, these cells sit in a plain
    /// `HStack` with no `List` of their own underneath to cancel the touch for it.
    ///
    /// The invisible copy of the current week gives this view the size its own content wants —
    /// both its width and, critically, its height, which a bare `GeometryReader` has none of its
    /// own and so expands to fill whatever `dayControls`' own `VStack` offers it. `.background`
    /// rather than a `ZStack` layer of the two, since a `.background` is sized to the view it sits
    /// behind and cannot grow it the way a `ZStack`'s own union-of-children sizing would.
    private var weekStrip: some View {
        weekStripRow(screen.weekStrip)
            .hidden()
            .allowsHitTesting(false)
            .overlay {
                // A plain, childless hit region the walk's UI test swipes —
                // `docs/running-the-app.md` § *The walk*: sized to this view by `.overlay`, so
                // its frame is exactly the row's own bounds, which the `.background` below draws
                // the real, visible strip at. `.allowsHitTesting(false)` lets the touch XCUITest
                // injects at this element's frame fall through to the real gesture beneath.
                Color.clear
                    .allowsHitTesting(false)
                    .accessibilityIdentifier("WeekStrip")
            }
            .background {
                GeometryReader { proxy in
                    let width = proxy.size.width
                    HStack(spacing: 0) {
                        // `isInteractive: false`: a neighbour's own offered cells must never take
                        // a tap (`design.md` § *The shell*, "The neighbour weeks MUST take none").
                        weekStripRow(screen.previousWeekStrip ?? [], isInteractive: false)
                            .frame(width: width)
                        weekStripRow(screen.weekStrip)
                            .frame(width: width)
                        weekStripRow(screen.nextWeekStrip ?? [], isInteractive: false)
                            .frame(width: width)
                    }
                    .offset(x: -width + weekDragTranslation)
                    // The `.frame(width:)` here resolves the offset, three-week-wide `HStack` back
                    // down to one strip's own width before `.clipped()` acts on it, so both
                    // neighbours slide in from the strip's own edges rather than past them
                    // (`design.md` § *The shell*: "clipped to the strip's own width").
                    .frame(width: width, alignment: .leading)
                    .clipped()
                    // `weekStripWidth` is `weekChevronButton(direction:)`'s own counterpart to
                    // `pagedDayContent`'s `pageWidth`, kept current the same way that is.
                    .onAppear { weekStripWidth = width }
                    .onChange(of: width) { _, newWidth in weekStripWidth = newWidth }
                }
                // `.clipped()` bounds what is drawn, not what the gesture below answers to — the
                // `HStack` inside is three weeks wide before it; `.contentShape` bounds the gesture
                // itself to this one-week frame.
                .contentShape(Rectangle())
                .highPriorityGesture(weekSwipeGesture())
            }
            // The cancellation half of the reset described on `isDraggingWeekStrip` above, the
            // same pattern `pagedDayContent`'s own `onChange(of: isDraggingDay)` follows: a drag
            // that never reaches `onEnded` — an incoming call, the app backgrounded mid-drag —
            // still resets here once SwiftUI resets `isDraggingWeekStrip` for it. Becoming `true`
            // finishes a settle already running at once, so this drag starts from a strip at rest.
            .onChange(of: isDraggingWeekStrip) { _, dragging in
                if dragging {
                    finishWeekStripSettleNow()
                } else {
                    weekDragStartWidth = nil
                    if !weekStripIsSettling {
                        weekDragTranslation = 0
                    }
                }
            }
    }

    /// The strip flanked by the two chevrons `grill.md` 16 brought back, in its own row: `‹` and
    /// `›`, fixed either side while the three weeks slide between them (`design.md` § *What the
    /// shell draws*) — the layout the owner chose over the designer's recommended pair on the date
    /// row (`grill.md` § *Layout*, "a ‹ on the left screen edge"). Narrower than the row it sits in
    /// only because the chevrons take some of that row's width; nothing else here sizes the strip
    /// on purpose. `spacing: 4` rather than the day-list's own gaps, and the chevron's own narrower
    /// frame (`weekChevronButton(direction:)`), give the strip back the width the owner asked for.
    private var weekStripRowWithChevrons: some View {
        HStack(spacing: 4) {
            weekChevronButton(direction: .before)
            weekStrip
            weekChevronButton(direction: .after)
        }
    }

    /// Which way a week chevron pages — `weekChevronButton(direction:)`'s own parameter, private
    /// to this file: the Kit states no rule about a chevron at all (ADR-1019), so this exists only
    /// to share that function's body between the two.
    private enum WeekChevronDirection {
        case before
        case after
    }

    /// A chevron beside the week strip, `grill.md` 16: a tap pages the week exactly as a carried
    /// swipe does, `grill.md` 17 — `pageWeekStrip(_:)`. Faded and disabled where its own neighbour
    /// strip is `nil` — the same `screen.previousWeekStrip`/`nextWeekStrip` a swipe resists on and
    /// `pageWeekStrip(_:)` itself re-reads, so the two can never disagree about where a page has
    /// nowhere to go.
    private func weekChevronButton(direction: WeekChevronDirection) -> some View {
        let offered =
            direction == .before ? screen.previousWeekStrip != nil : screen.nextWeekStrip != nil
        return Button {
            pageWeekStrip(direction)
        } label: {
            // The glyph's own intrinsic size is under 13×17pt; `.frame` widens the tappable area
            // without widening what is drawn, narrower than the HIG's own 44pt minimum at the
            // owner's own request so the strip keeps more of the row, and `.contentShape` makes
            // that whole frame the target rather than only the glyph inside it.
            Image(systemName: direction == .before ? "chevron.left" : "chevron.right")
                .frame(width: 32, height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .disabled(!offered)
        .opacity(offered ? 1 : 0.5)
        .accessibilityLabel(direction == .before ? "Week before" : "Week after")
    }

    /// One week's seven days, one equal-width column each — the row `weekStrip` lays out three
    /// of, side by side. Reads only what it is handed, so a neighbour drawn from
    /// `screen.previousWeekStrip`/`nextWeekStrip` redraws only when the page it previews does.
    /// Indexed by position rather than by the day itself: two days past either end of the
    /// calendar carry the same letter and no date, and so compare equal, which
    /// `ForEach(id: \.self)` cannot tell apart. `isInteractive` is `false` for a neighbour week,
    /// whose own offered cells must draw exactly as the shown week's do but take no tap.
    private func weekStripRow(_ days: [DayScreen.WeekStripDay], isInteractive: Bool = true)
        -> some View
    {
        HStack(spacing: 4) {
            ForEach(Array(days.enumerated()), id: \.offset) { _, day in
                weekStripDay(day, isInteractive: isInteractive)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    /// One day of the week strip: its letter over its day of the month, where it has one — a day
    /// past either end of the calendar draws its letter alone (`design.md` § *Past either end of
    /// the calendar: the letter, and no date*). The day being shown draws in a capsule, the
    /// text colour inverted inside it, blue where that day is also the today; the today alone,
    /// where it is not also being shown, draws its letter and its number in blue with no capsule.
    /// A day neither shown nor offered takes ADR-1045 decision 5's opacity and no tap — the shown
    /// day's own cell is excluded from that fade and is not a target either, since a screen draws
    /// as a target only what it offers (`CONTEXT.md` § *Offered*) and it has nowhere to go.
    /// **A tap commits a focused one-off field for departure, then calls `showDay`, and animates
    /// nothing** — `design.md` § *The shell*: a strip tap is the day picker's act, with no settle
    /// of its own. `.contentShape(Rectangle())` makes the whole column the tap target, the way a
    /// day-list row's own `Button` already does, rather than only the letter and the number
    /// themselves. Every cell speaks as one accessibility element, its date in full where it has
    /// one and its bare letter where it does not, so VoiceOver says one thing rather than the
    /// letter and the number as two — an offered day through the `Button`'s own label, a shown or
    /// faded day through `.accessibilityElement(children: .ignore)`.
    ///
    /// `isInteractive` gates the `Button` on top of `day.isOffered`, so a neighbour week's own
    /// offered days draw exactly as the shown week's do but take no tap at all (`design.md` § *The
    /// shell*: "Only the chevrons and the shown week's offered cells take a tap").
    private func weekStripDay(_ day: DayScreen.WeekStripDay, isInteractive: Bool) -> some View {
        let textColor: Color =
            if day.isShown {
                Color(.systemBackground)
            } else if day.isToday {
                .accentColor
            } else {
                .primary
            }
        let label = VStack(spacing: 2) {
            Text(day.letter)
                .font(.caption2)
            Text(day.date.map { String($0.day) } ?? "")
                .font(.body)
        }
        .foregroundStyle(textColor)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity)
        .background {
            if day.isShown {
                Capsule().fill(day.isToday ? Color.accentColor : Color.primary)
            }
        }
        .opacity(day.isShown || day.isOffered ? 1 : 0.5)
        .contentShape(Rectangle())

        let accessibilityLabel = day.date.map(fullDateInWords) ?? day.letter

        return Group {
            if isInteractive, day.isOffered, let date = day.date {
                Button {
                    commitFocusedOneOffField(forDeparture: true)
                    // `showDay(_:)` reassigns `dayView` even where `date` is already the day
                    // shown, so this compares the shown day itself — `dayPickerReach.opensOn`,
                    // the same property `weekdayInWords` and `dateRowInWords` read as "the day
                    // being shown" — rather than trusting the call to mean a turn, so a tap on the
                    // day already shown does not tick (ADR-1045, amended 2026-09-28).
                    let before = screen.dayPickerReach.opensOn
                    cancelPendingDaySettle()
                    screen.showDay(date)
                    if screen.dayPickerReach.opensOn != before {
                        daysTurned += 1
                    }
                } label: {
                    label
                }
                .buttonStyle(.plain)
                .accessibilityLabel(accessibilityLabel)
            } else {
                label
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(accessibilityLabel)
            }
        }
    }

    /// The day picker, opened from the date row: a graphical calendar in a medium sheet, bounded
    /// by `screen.dayPickerReach`, which the shell computes neither end of, per ADR-1019's
    /// 2026-09-04 amendment. Picking a day commits any focused one-off field as every other day
    /// move does, shows that day and closes the sheet.
    private var dayPickerSheet: some View {
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
                    cancelPendingDaySettle()
                    screen.showDay(picked)
                    pickingDay = false
                }
            ),
            in: date(from: screen.dayPickerReach.earliest)...,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
        .labelsHidden()
        .padding()
        .presentationDetents([.medium])
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
            // Each list is keyed by its role and the day shown, so every day move draws all
            // three afresh at the top: a list that was scrolled and then became a neighbour, or a
            // neighbour that becomes the day, never carries an old offset into the day it opens.
            let shownDay = "\(screen.dayPickerReach.opensOn)"
            HStack(spacing: 0) {
                dayList(for: screen.previousDayView)
                    .frame(width: width)
                    .id("previous-\(shownDay)")
                dayList(for: screen.dayView)
                    .frame(width: width)
                    .accessibilityIdentifier("CurrentDayList")
                    .id("shown-\(shownDay)")
                dayList(for: screen.nextDayView)
                    .frame(width: width)
                    .id("next-\(shownDay)")
            }
            .offset(x: -width + dragTranslation)
            // Horizontal-only clip: `.clipped()` (dropped) clips to the *whole* rendered
            // frame, both axes at once, and that frame's height is `proxy.size.height` —
            // already shortened by `.safeAreaInset`'s own reservation for `oneOffBar` — so it
            // also cut every list off flat at the bar's own top edge, whatever `dayList(for:)`'s
            // own `.scrollEdgeEffectStyle(.soft, for: .bottom)` was set to; confirmed by
            // dropping `.clipped()` outright and watching rows draw straight through to the
            // bar. A custom clip `Path`, `width` wide but built from a fixed, oversized rect
            // rather than this view's own laid-out frame, hides the two neighbouring pages
            // exactly as before while leaving the vertical extent effectively unbounded, so a
            // `List`'s own rows can draw the whole way down — checked on the exported PNG, not
            // by eye: at the capsule's own left edge, mid-scroll, the pixel underneath reads
            // the row's own fill (`#FDFDFD`-ish in light, `#1A1A1C`-ish in dark, matching a
            // cell's `#FFFFFF`/`#1C1C1E`, never the page's `#F2F2F7`/`#000000`), with no sudden
            // jump anywhere above the bar in either appearance.
            .clipShape(Rectangle().path(in: CGRect(x: 0, y: -4000, width: width, height: 8000)))
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
                    // A drag the system cancelled — the home-indicator swipe, a call banner —
                    // never reaches `onEnded`, and left the page wherever the finger was.
                    snapBackIfNotSettling()
                }
            }
        }
        // The one-off entry, pinned at the foot of the paged content rather than scrolled to as
        // a line inside whichever list is showing. `oneOffBar`'s own doc comment has why this is
        // attached here, to `pagedDayContent` itself, and why `.safeAreaInset` rather than
        // `.safeAreaBar` (ADR-1063).
        //
        // **`spacing: 2`, not the left-`nil` default, is what a fifth fix round trimmed** — the
        // owner found the foot gap at a scrolled list's true end "a bit too big" on the phone.
        // Left at its default, `.safeAreaInset` picks its own standard spacing between the list
        // and `oneOffBar`, measured (a long day, scrolled to its foot, one-offs standing) at
        // `43.83pt` between the last row's `maxY` and the capsule's `minY`; `oneOffBar` itself
        // carries no top padding of its own to have trimmed instead, and the list's own bottom
        // content inset is computed from the inset's reserved height, not a separate margin — so
        // the `spacing:` parameter is the whole of the extra room, and the only value worth
        // touching. `spacing: 0` measures `35.83pt`, just under the owner's asked-for 36–40pt;
        // `2` lands at `37.83pt`, inside it with a small margin either side, because `oneOffBar`'s
        // own `.padding(.bottom, 8)` and the capsule's own `.padding(.vertical, 10)` still
        // separate the last row from the capsule's fill — the gap can shrink no further without
        // touching one of those. A day with no one-offs standing never scrolls (the seed roster
        // is five commitments, well short of a screen), so its own gap — measured `254.83pt`,
        // `Weight`'s own `maxY` against the same capsule `minY` — sits unchanged either side of
        // this change and nowhere near touching the capsule.
        .safeAreaInset(edge: .bottom, spacing: 2) {
            oneOffBar
        }
    }

    /// One day's rows, in a plain `List` — the same groups, the same per-row rendering and the
    /// same `ForEach(Array(group.rows.enumerated()), id: \.offset)` keying this screen has always
    /// used, now driven by whichever of the three day views this list was handed. Where the day
    /// holds nothing the list says one thing instead — "Nothing is due on this day." — but only
    /// while the roster, the one-offs and the birthdays were all read; where one was not, the
    /// banner says so and the list says nothing, since it cannot know the day is empty. `nil` —
    /// only possible at either end of the calendar — draws an empty list, no line; the drag never reveals it,
    /// because it resists at that end (`daySwipeGesture`). No list here needs telling whether it
    /// is the one shown any more: the one-off entry no longer lives inside any of the three —
    /// it is `oneOffBar`, pinned at the foot of the whole screen (ADR-1063) — and a rename on a
    /// row already clears the keyboard by the same `.safeAreaInset` mechanics, unaided, on every
    /// one of the three lists alike; the keyboard-height padding this once carried for that is
    /// gone with it — see `oneOffBar`'s own doc comment for the measurement that found so.
    @ViewBuilder
    private func dayList(for dayView: DayView?) -> some View {
        List {
            if let dayView {
                // The Birthdays group, first of all — `openspec/specs/day-screen/spec.md`'s
                // *A day screen draws the birthdays falling on each day...*: "it SHALL come
                // before every group of commitments." `nil` while birthdays are off or none
                // fall on this date (`design.md` § *A group of its own, mirroring the
                // one-offs*). Rows are keyed by offset, not by value, for the same reason a
                // commitment row is just below: a tap changes `isTicked`, which is part of a
                // birthday row's own equality, so keying by value would read as one row
                // removed and another inserted.
                if let birthdayGroup = dayView.birthdayGroup {
                    Section {
                        ForEach(Array(birthdayGroup.rows.enumerated()), id: \.offset) { _, row in
                            birthdayRowView(row)
                        }
                    } header: {
                        Text(birthdayGroup.heading)
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 6, trailing: 16))
                    }
                }
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
                // screen is not keeping one-offs at all; the shell itself skips drawing the
                // group where it holds no rows, since `oneOffBar` is the offer now and a heading
                // over nothing has no job left (ADR-1063) — the kit is unchanged, and still hands
                // back an empty group on a day none stand on, which is why this also checks
                // `!oneOffGroup.rows.isEmpty` and not just the `nil` the kit reserves for a
                // screen not keeping one-offs at all. One-off rows are keyed by `\.key`, not by
                // offset or by the row's own value — `design.md` § *A one-off row's key, and the
                // animation in the shell*: a rename still re-keys (its key carries the one-off's
                // name), but a tick or a take-back does not, so `List` can animate the row's move
                // rather than fading it out of one place and in at another (`oneOffRowView(_:)`'s
                // own `withAnimation` around the tick), unlike a commitment row's tap, which the
                // offset above still keys through.
                if let oneOffGroup = dayView.oneOffGroup, !oneOffGroup.rows.isEmpty {
                    Section {
                        ForEach(oneOffGroup.rows, id: \.key) { row in
                            oneOffRowView(row)
                        }
                    } header: {
                        Text(oneOffGroup.heading)
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 6, trailing: 16))
                    }
                }
                // The happenings that came on this day, one card with no heading after every group:
                // each its name and the times it came, in the Kit's words, with no tap.
                if !dayView.happeningRows.isEmpty {
                    Section {
                        ForEach(Array(dayView.happeningRows.enumerated()), id: \.offset) { _, row in
                            happeningRowView(row)
                        }
                    }
                }
                // The one line where the rows would be, drawn exactly when every group above is
                // absent — the kit hands a day with nothing due "no groups and no rows"
                // (`day-screen/spec.md`), read here the way the One-offs check above reads its
                // own empty group — and only while every source the list is drawn from was read
                // (`everySourceOfTheListWasRead`): a one-off or a birthday we could not read may
                // exist, so "nothing is due" would be a claim the screen cannot make, and the
                // store banner in `dayControls` says why the list is empty instead. The record is
                // left out on purpose: it holds ticks, not what is due.
                // One sentence for every day, on purpose: saying "is due" of today and "was due"
                // of a past day would need this view to compare the list's date with `today()`,
                // and a wrong tense is a thing a test would catch — not a thing the shell may decide.
                if dayView.groups.isEmpty && dayView.birthdayGroup == nil
                    && (dayView.oneOffGroup?.rows.isEmpty ?? true) && everySourceOfTheListWasRead
                {
                    Text("Nothing is due on this day.")
                        .foregroundStyle(.secondary)
                        .listRowBackground(Color.clear)
                }
            }
        }
        // Same measured value as `CommitmentsView`'s kept list — see the comment there for
        // how it was determined.
        .listSectionSpacing(12)
        // **Without this, the list's own bottom edge meets `oneOffBar` in a hard-edged band —
        // walked on the phone in dark mode, and reproduced here in both.** Below the list's own
        // last card and behind the whole width of the bar, a flat `.systemBackground` fill
        // (white in light, black in dark) sat between the page's own grouped grey and the bar's
        // capsule, cut off in a straight line rather than the two blending the way Messages'
        // own field floats over its conversation. `.hard`, this List's effective default on this
        // SDK, is what draws that opaque fill behind a bar sitting over a scroll view's edge;
        // `.soft` is the alternative this same API offers and is what a plain toolbar or tab bar
        // already gets automatically — checked in both appearances, the band is gone in both and
        // the bar reads as a capsule floating over the page's own continuous background, not a
        // panel with a bar drawn on top of it. Neither the `VStack` around `dayControls` and
        // `pagedDayContent` nor `pagedDayContent`'s own clipping carries a background of its own
        // to fix; this is the one line that was doing it.
        .scrollEdgeEffectStyle(.soft, for: .bottom)
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
                    .transition(
                        AsymmetricTransition(
                            insertion: .symbolEffect(.drawOn), removal: .symbolEffect(.drawOff))
                    )
            }
            if entry != nil || noteEntry != nil || totalEntry != nil {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        // `isTarget` decides whether there is a tap at all; the five `nil`/`values` checks
        // above stay only to decide which sheet, alert or popover a tap opens. ADR-1045; the
        // popover branch is this Story's own, `design.md` § *The shell rides this Story*.
        if isTarget {
            Button {
                if let entry, entry.values != nil {
                    choosingRow = row
                } else if let entry {
                    enteringText =
                        (entry.number ?? entry.startingNumber).map { "\($0)" } ?? ""
                    enteringRow = row
                } else if let noteEntry {
                    enteringNoteText = noteEntry.note ?? ""
                    enteringNoteRow = row
                } else if totalEntry != nil {
                    enteringTotalText = ""
                    enteringTotalRow = row
                } else if reduceMotion {
                    keeping { try screen.tick(row) }
                } else {
                    withAnimation {
                        keeping { try screen.tick(row) }
                    }
                }
            } label: {
                label
            }
            // Anchored to this row's own `Button` — never lifted to the list or the screen —
            // so the popover opens from the row that was tapped, `design.md`'s own words.
            // `.presentationCompactAdaptation(.popover)` is what keeps this a popover on an
            // iPhone's compact size class; without it SwiftUI falls back to a sheet.
            // `arrowEdge: .top` puts the arrow on the popover's own top edge, pointing up at the
            // row that was tapped — so the popover itself opens under that row, covering the row
            // below it, per the wireframe at `design.md` § *What the shell draws*.
            .popover(
                isPresented: Binding(
                    get: { choosingRow == row },
                    set: { isPresented in
                        if !isPresented {
                            choosingRow = nil
                        }
                    }
                ),
                arrowEdge: .top
            ) {
                if let entry, let values = entry.values {
                    chosenValuesPopover(row: row, entry: entry, values: values)
                }
            }
        } else {
            // Decisions 3 and 5, ADR-1045: a row that offers nothing recedes as one thing —
            // the name, the rhythm and any mark fade together rather than by three different
            // amounts.
            label
                .opacity(0.5)
        }
    }

    /// A happening row: its name and times in the Kit's words. A tap opens the change sheet on
    /// the one occurrence the day has, or a popover of them under the row where it has several;
    /// the Kit answers which, in the row's order. `change-or-take-back-occurrence/design.md`
    /// § *The shell*.
    @ViewBuilder
    private func happeningRowView(_ row: DayView.HappeningRow) -> some View {
        Button {
            let occurrences = screen.occurrences(of: row)
            if occurrences.count == 1 {
                changingOccurrence = ChangedOccurrence(name: row.name, occurrence: occurrences[0])
            } else if !occurrences.isEmpty {
                choosingHappeningRow = row
            }
        } label: {
            Text("\(row.name) · \(row.timesInWords)")
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .popover(
            isPresented: Binding(
                get: { choosingHappeningRow == row },
                set: { isPresented in
                    if !isPresented {
                        choosingHappeningRow = nil
                    }
                }
            ),
            arrowEdge: .top
        ) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(screen.occurrences(of: row).enumerated()), id: \.offset) { _, occurrence in
                    Button {
                        pendingOccurrence = ChangedOccurrence(name: row.name, occurrence: occurrence)
                        choosingHappeningRow = nil
                    } label: {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(occurrence.timeInWords)
                                if let note = occurrence.note {
                                    Text(note)
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(3)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            Spacer(minLength: 12)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(minWidth: 220)
            .presentationCompactAdaptation(.popover)
            // The sheet opens once the popover has gone, never over it.
            .onDisappear {
                if let pending = pendingOccurrence {
                    pendingOccurrence = nil
                    changingOccurrence = pending
                }
            }
        }
    }

    /// One birthday row's content and the tap that acts on it — `design.md` § *The shell*: "A
    /// row is `Text(verbatim:)` words, grey and struck through with the green check when
    /// ticked, faded to 0.5 where it offers no tick; a tap ticks; the notice line under it
    /// reads 'Not saved. Try again.'" No rhythm, no entry — a birthday row offers nothing but
    /// its tick (`grill.md` § *Settled* 1). Acting on a row from a neighbouring day is inert
    /// the same way a commitment row's tap already is: `DayScreen.tick(_: DayView.BirthdayRow)`
    /// returns early on a row `screen.dayView.birthdayGroup` does not hold. Two G7 changes from
    /// the owner, after walking the phone: a small icon before the words, then — after seeing it
    /// as an SF Symbol — the 🎂 emoji instead. A shell-only change either time; this file's own
    /// doc comment on `nameLine` below has the rest of it.
    @ViewBuilder
    private func birthdayRowView(_ row: DayView.BirthdayRow) -> some View {
        let nameColor: Color = row.isTicked ? .secondary : .primary
        let markSystemName: String? = row.isTicked ? "checkmark" : nil
        let markColor: Color = Color.green
        let offersTick = row.offersTick(asOf: today())

        // The 🎂 emoji before the words, then a space — the owner's second G7 word on this row,
        // in place of the SF Symbol `birthday.cake` the first one asked for. No `.foregroundStyle`
        // on the emoji piece, so it stays in its own full colour whether or not the row is
        // ticked; concatenation keeps each piece's own modifiers, so only the words piece —
        // still `Text(verbatim: row.words)`, unedited — takes the secondary colour and the
        // strikethrough once ticked.
        let nameLine: Text =
            Text("🎂 ")
            + Text(verbatim: row.words)
                .foregroundStyle(nameColor)
                .strikethrough(row.isTicked)

        let label = HStack {
            VStack(alignment: .leading) {
                nameLine
                if row == screen.notice?.birthdayRow {
                    Text("Not saved. Try again.")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            if markSystemName != nil {
                Spacer()
            }
            if let markSystemName {
                Image(systemName: markSystemName)
                    .foregroundStyle(markColor)
                    .transition(
                        AsymmetricTransition(
                            insertion: .symbolEffect(.drawOn), removal: .symbolEffect(.drawOff))
                    )
            }
        }

        if offersTick {
            Button {
                if reduceMotion {
                    keeping { try screen.tick(row) }
                } else {
                    withAnimation {
                        keeping { try screen.tick(row) }
                    }
                }
            } label: {
                label
            }
        } else {
            // Faded as a whole, the same way a commitment row that offers nothing recedes
            // (ADR-1045 decisions 3 and 5) — `grill.md` § *Layout*: "A row on a future day
            // fades as a whole to 0.5."
            label
                .opacity(0.5)
        }
    }

    /// A chosen row's values, opened over the screen from that row's own tap — `design.md`
    /// § *The shell rides this Story* and the wireframe at its § *What the shell draws*: the
    /// day's number said above the values where it is not one of them, then the values
    /// themselves in one line, the one equal to `entry.number` a filled circle with the digit
    /// inverted, and — only where `entry.number` is set — a divider and the clear. A value tap
    /// chooses and closes; the clear clears and closes; a tap elsewhere (SwiftUI's own popover
    /// dismissal) closes and calls nothing, since neither button here is what closes it that
    /// way.
    @ViewBuilder
    private func chosenValuesPopover(
        row: DayView.Row, entry: DayView.NumberEntry, values: [Decimal]
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            if let number = entry.number, !values.contains(number) {
                Text("\(number)")
                    .font(.headline)
            }
            // `spacing: 4` and a 26pt minimum, rather than the roomier defaults first tried here,
            // are what keep eleven values — the most a short range ever offers — from clipping
            // against the popover's own width, measured on the simulator (§ 6.1/6.2). The walk's
            // `phone:` line still asks the owner whether that is comfortable for a thumb;
            // `design.md` § Risks accepts a fix here without a delta if it is not.
            HStack(spacing: 4) {
                ForEach(values, id: \.self) { value in
                    let isChosen = value == entry.number
                    Button {
                        keeping { try screen.choose(value, on: row) }
                        choosingRow = nil
                    } label: {
                        Text("\(value)")
                            .font(.callout)
                            .frame(minWidth: 26, minHeight: 26)
                            .background(Circle().fill(isChosen ? Color.accentColor : Color.clear))
                            .foregroundStyle(isChosen ? Color.white : Color.primary)
                    }
                    .buttonStyle(.plain)
                }
                if entry.number != nil {
                    Divider()
                    Button {
                        keeping { try screen.choose(nil, on: row) }
                        choosingRow = nil
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Clear")
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
        .presentationCompactAdaptation(.popover)
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
    ///
    /// **The outer `VStack`'s `.alignmentGuide(.listRowSeparatorLeading)` is what keeps this
    /// row's separator the same length as a commitment row's, and only a late row ever needed
    /// it.** Measured 2026-09-16, unmodified: the separator under an on-time one-off (no
    /// `lateInWords`) already started at the same leading x, 32.0pt, as the commitment rows
    /// above it — `List` had picked the `TextField`'s own leading edge, the first child it found.
    /// Under a *late* one-off it instead started at 110.67pt and ran only 259.33pt instead of
    /// 338.0 — cut short by exactly the 78.67pt the `lateInWords` `Text` sits to the right of the
    /// name by, because `List` picked *that* view's leading edge once it was there to compete
    /// with the `TextField`'s. Pinning the guide to this `VStack`'s own leading edge, the same
    /// one `rowView(_:)`'s commitment rows read without asking (a plain `Text` has no separate
    /// leading child to compete), fixes both cases at once rather than only the one this was
    /// driven to find.
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
                        // A day swipe that started on this tick is the swipe's, not the tick's.
                        guard Date() >= swipeClaimsTicksUntil else {
                            return
                        }
                        if offersTick {
                            // A tick or a take-back is the only mutation `\.key` (rather than the
                            // row's own value) lets `List` see as a move, so this is the only
                            // place `withAnimation` belongs on a one-off row (`design.md` § *A
                            // one-off row's key, and the animation in the shell*) — not the one
                            // animated change on this screen: the scroll to a freshly entered row
                            // and the day swipe's settle are animated too. A rename still re-keys
                            // and fades; a remove takes the row away outright, which needs no
                            // re-key at all. Reduce Motion turns this animation off the same way
                            // `settle(to:then:)` already turns the day swipe's off.
                            if reduceMotion {
                                keeping { try screen.tick(row) }
                            } else {
                                withAnimation {
                                    keeping { try screen.tick(row) }
                                }
                            }
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
                                    .transition(
                                        AsymmetricTransition(
                                            insertion: .symbolEffect(.drawOn),
                                            removal: .symbolEffect(.drawOff))
                                    )
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
        // See this function's own doc comment for what was measured and why this is on the
        // outer `VStack` rather than left to `List`'s own default (the first leading-aligned
        // child it finds, which a late row's `lateInWords` competes with).
        .alignmentGuide(.listRowSeparatorLeading) { $0[.leading] }
        .opacity(isRenaming || offersTick ? 1 : 0.5)
        .contextMenu {
            if !isRenaming {
                Button("Remove", role: .destructive) {
                    keeping { try screen.remove(row) }
                }
            }
        }
    }

    /// The one-off entry, pinned at the foot of the day screen with `.safeAreaInset(edge:
    /// .bottom)` on `pagedDayContent` (ADR-1063) — one bar for the whole screen, not a line
    /// inside the paged list, and always in reach, so nothing needs scrolling to it any more.
    /// `.safeAreaBar`, tried first, rose above the keyboard the same way `.safeAreaInset` does
    /// here, but never let `oneOffFocus` track this field, in either direction, on this SDK — nor
    /// did giving the field its own, locally declared `@FocusState`; a fix round found neither
    /// the read nor the write direction crosses into `.safeAreaBar`'s own content at all.
    /// `.safeAreaInset` is the ordinary view tree, which is what lets `oneOffFocus` track the
    /// field the same way it already tracks a row's — measured clear of the keyboard exactly as
    /// before, field `maxY 521` against keyboard `minY 583`. Shown exactly where
    /// `screen.dayView.oneOffGroup != nil` says adding is offered, the same test the toolbar `+`
    /// (now gone, along with the scroll that used to carry the entry into view) once gated on.
    ///
    /// **Attached to `pagedDayContent`, not `body`'s own outer `VStack`.** The `VStack` also held
    /// `dayControls`, a plain, non-scrolling view; a `VStack` with a non-scrolling child shrinks
    /// its own layout region for the inset by default, and a `List` reads that same shrunk region
    /// for its own automatic bottom content inset — with the inset on the `VStack`, the last row
    /// still overlapped the bar at rest (measured: row `maxY 839` against bar `minY 800`).
    /// Attached to `pagedDayContent` instead, each `List` gets the correct content inset and the
    /// last row rests clear of the bar once scrolled there (`pagedDayContent`'s own doc comment
    /// has the frames that letting rows draw *behind* the bar while scrolling needed on top of
    /// this — a second, separate fix).
    ///
    /// **Return no longer opens a fresh entry (grill answer 25, reopened from answer 6).** A
    /// kept add — or a blank one, which adds nothing — drops focus and closes the keyboard,
    /// exactly as the checkmark already does for a kept commit; a refused add leaves focus where
    /// it is, showing the typed text and the cause under it, same as check 1 already does. Both
    /// Return and the checkmark call the one path, `commitFocusedOneOffField()` — see its own
    /// doc comment for the refusal check itself. A fourth fix round, on the owner's own reading
    /// of the phone build, found the checkmark alone had never been given this: it dropped focus
    /// on a refused entry regardless, unlike a refused *rename*, which the checkmark already
    /// left focused. There is no longer a second copy of this logic to keep in step — this
    /// closure now only calls the shared function.
    ///
    /// **`commitFocusedOneOffField()`'s own refused branch re-asserts focus rather than simply
    /// leaving it untouched, and driving this for real on the simulator is what found that the
    /// second half matters.** Pressing Return on a `TextField` resigns its first responder as
    /// part of handling the key itself, independently of anything this closure does;
    /// `@FocusState` reflects that resignation back, so a refusal found by *only* skipping the
    /// drop — never writing `oneOffFocus` at all — still lost focus, keyboard included, exactly
    /// the outcome this exists to avoid.
    ///
    /// **Styled to read as a field in a bar, not stray text sitting on the keys.** The field
    /// itself carries the rounded background; the horizontal padding around it matches the 16pt
    /// the list's own section headers use (`dayList(for:)`).
    ///
    /// **The capsule is opaque, not `.glassEffect(in: .capsule)` (a third fix round, on the
    /// owner's own reading of the phone build).** A translucent bar let rows scrolling past
    /// underneath show straight through it once the previous fix let them draw that far — the
    /// bar stopped reading as its own control and became a smear of whatever row was passing.
    /// `Color(.tertiarySystemGroupedBackground)` is Apple's own next layer up from the
    /// `secondarySystemGroupedBackground` a `List` row already fills (`UIInterface.h`: "layered
    /// on top of the main background, when appropriate"), so it is built to stay distinct over a
    /// cell in both appearances without a hand-picked hex; a hairline `.separator` stroke backs
    /// that up in light mode, where the two greys sit closer together. The refusal note gets the
    /// same fill in its own small capsule, directly under the field, so red text floating loose
    /// over rows doesn't repeat the same problem at a smaller size.
    @ViewBuilder
    private var oneOffBar: some View {
        let hasField = screen.dayView.oneOffGroup != nil
        if hasField || screen.offersNotingAHappening {
            HStack(alignment: .top, spacing: 8) {
                if hasField {
                    oneOffEntry
                } else {
                    Spacer(minLength: 0)
                }
                if screen.offersNotingAHappening {
                    happeningBolt
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
    }

    /// The bolt right of the one-off field: a menu of the happenings' names, in the order made,
    /// first at the top (`.menuOrder(.fixed)`), each opening the note sheet. Drawn exactly while
    /// `screen.offersNotingAHappening`; the capsule matches the field's.
    private var happeningBolt: some View {
        Menu {
            ForEach(screen.happenings, id: \.identity) { happening in
                Button(happening.name) {
                    notingHappening = NotedHappening(happening: happening)
                }
            }
        } label: {
            Image(systemName: "bolt")
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(.tertiarySystemGroupedBackground), in: .capsule)
                .overlay(Capsule().strokeBorder(.separator, lineWidth: 0.5))
        }
        .menuOrder(.fixed)
        .accessibilityLabel("Note a happening")
        .accessibilityIdentifier("NoteHappening")
    }

    private var oneOffEntry: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField("New one-off", text: oneOffEntryTextBinding)
                .focused($oneOffFocus, equals: .entry)
                .onSubmit {
                    // The same path the checkmark calls (`commitFocusedOneOffField()`'s own
                    // doc comment) — a refused add re-asserts `.entry` and keeps the keyboard
                    // up, a kept or blank one drops focus, identically for Return and the
                    // checkmark. `forDeparture` stays `false`: Return is not a departure.
                    commitFocusedOneOffField()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(.tertiarySystemGroupedBackground), in: .capsule)
                .overlay(Capsule().strokeBorder(.separator, lineWidth: 0.5))
                .accessibilityIdentifier("OneOffEntry")
            if screen.nameRefusal?.row == nil, let nameRefusal = screen.nameRefusal {
                Text(nameRefusal.cause ?? "Not saved. Try again.")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(.tertiarySystemGroupedBackground), in: .capsule)
            }
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
    /// the day screen moves the day it is showing, calling `showPreviousDay()` and
    /// `showNextDay()` — never `showDay(_:)`, which is bounded by the day picker's reach and
    /// would silently refuse a page back below the roster's earliest kept-from day. The chevrons
    /// that once sat beside this gesture are gone; the week strip is what depicts it now
    /// (ADR-1042's 2026-09-28 amendment, `add-week-strip` #346), and the ownership this gesture
    /// claims over the screen is unchanged by that. `minimumDistance` keeps a plain tap
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
                swipeClaimsTicksUntil = Date().addingTimeInterval(0.35)
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
                swipeClaimsTicksUntil = Date().addingTimeInterval(0.35)
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

    /// Slides `dragTranslation` to `target` and, once that finishes, resets it to zero and runs
    /// `move` — the day-changing call, made only after the page has visually finished travelling
    /// to it. Skipped entirely where `reduceMotion` is set: the settle becomes an instant change,
    /// exactly as `design.md` § *What the shell draws* asks, and the drag's own live tracking
    /// above is untouched by this either way — the HIG lists tracking directly with a gesture as
    /// a way to reduce motion, not a target for removing it.
    ///
    /// `daysTurned` is bumped wherever `move` is non-`nil` — a carried swipe, in both this
    /// branch and the animated completion below — and never on a snap-back, where `move` is
    /// `nil` and the page only springs back to the day it already showed (ADR-1045's 2026-09-28
    /// amendment).
    private func settle(to target: CGFloat, then move: (() -> Void)?) {
        guard !reduceMotion else {
            dragTranslation = 0
            if move != nil {
                daysTurned += 1
            }
            move?()
            return
        }

        let generation = daySettleGeneration
        daySettling = true
        daySettleMove = move
        withAnimation(.easeOut, completionCriteria: .logicallyComplete) {
            dragTranslation = target
        } completion: {
            guard generation == daySettleGeneration else {
                return
            }
            daySettling = false
            daySettleMove = nil
            dragTranslation = 0
            if move != nil {
                daysTurned += 1
            }
            move?()
        }
    }

    /// Drops the slide in flight, if any, without making its move: called by every control that
    /// jumps to a day of its own, before it does, so the ~0.35 s a carried swipe takes to land
    /// never ends with a second, stale move on top of the jump.
    private func cancelPendingDaySettle() {
        daySettleGeneration += 1
        daySettling = false
        daySettleMove = nil
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            dragTranslation = 0
        }
    }

    /// Lands the slide in flight at once, making its move, for the app leaving the foreground:
    /// an animation's completion is not promised to arrive from the background.
    private func finishDaySettleNow() {
        guard daySettling else {
            return
        }
        let move = daySettleMove
        cancelPendingDaySettle()
        if move != nil {
            daysTurned += 1
        }
        move?()
    }

    /// Springs a page left part-way across back to the day it shows, where no release is
    /// carrying it anywhere: the drag was cancelled rather than ended.
    private func snapBackIfNotSettling() {
        guard !daySettling, dragTranslation != 0 else {
            return
        }
        settle(to: 0, then: nil)
    }

    /// A horizontal drag on the week strip pages it to the week before or the week after —
    /// `design.md` § *The shell*: left reveals the week after, right the week before, resisting
    /// where that neighbour is `nil` (`screen.previousWeekStrip`/`nextWeekStrip`). Past a third of
    /// the strip's own width a released drag carries: `pageWeekStrip(_:)`. A mostly vertical drag
    /// does nothing, checked fresh on every sample rather than locked once: unlike
    /// `daySwipeGesture`, nothing beneath this view scrolls, so there is no competing gesture for
    /// an axis lock to arbitrate. `minimumDistance` mirrors `daySwipeGesture`'s own 40pt, which
    /// keeps a plain tap on a cell from ever reaching this gesture's closures at all.
    ///
    /// `onChanged` tracks the finger from its first sample with no jump at recognition
    /// (`design.md` § *The shell*) by subtracting `weekDragStartWidth` — that first sample's own
    /// `translation.width`, whatever it is — from every later one, rather than a fixed 40pt, since
    /// a diagonal first sample can carry less than 40pt of `width` on its own; `weekDragTranslation`
    /// and the neighbour a drag resists on both read that adjusted value's own sign throughout, not
    /// the raw sample's, so the two can never disagree as the finger crosses back over its own
    /// start. Reads `weekStripWidth` rather than taking a `pageWidth` parameter, since this gesture
    /// is attached to the `GeometryReader` that measures it directly. `.updating($isDraggingWeekStrip)`
    /// is `pagedDayContent`'s own `isDraggingDay` pattern, for the same reason: a cancelled drag
    /// reaches neither `onChanged` again nor `onEnded` at all, and only a `@GestureState` reset is
    /// told of it.
    private func weekSwipeGesture() -> some Gesture {
        DragGesture(minimumDistance: 40)
            .updating($isDraggingWeekStrip) { _, isDraggingWeekStrip, _ in
                isDraggingWeekStrip = true
            }
            .onChanged { value in
                if weekDragStartWidth == nil {
                    weekDragStartWidth = value.translation.width
                }
                guard abs(value.translation.width) > abs(value.translation.height) else {
                    return
                }
                let adjusted = value.translation.width - (weekDragStartWidth ?? 0)
                if adjusted < 0 {
                    weekDragTranslation = screen.nextWeekStrip == nil ? 0 : adjusted
                } else {
                    weekDragTranslation = screen.previousWeekStrip == nil ? 0 : adjusted
                }
            }
            .onEnded { value in
                defer { weekDragStartWidth = nil }
                guard abs(value.translation.width) > abs(value.translation.height) else {
                    beginWeekStripSettle(to: 0, then: nil)
                    return
                }

                let adjusted = value.translation.width - (weekDragStartWidth ?? 0)
                guard abs(adjusted) > weekStripWidth / 3 else {
                    beginWeekStripSettle(to: 0, then: nil)
                    return
                }
                pageWeekStrip(adjusted < 0 ? .after : .before)
            }
    }

    /// Finishes any settle already running (`finishWeekStripSettleNow()`) and then pages
    /// `direction` if the week it goes to is still offered once that settle has landed — commits a
    /// focused one-off field for departure and slides the strip a full width
    /// (`beginWeekStripSettle(to:then:)`), calling `screen.showPreviousWeek()`/`showNextWeek()`
    /// only once that settle finishes, so the page never lands mid-slide. Reading
    /// `previousWeekStrip`/`nextWeekStrip` after finishing rather than before is what keeps a
    /// chevron tap or a carried release from ever starting a page the day the settle just landed
    /// on has already refused.
    private func pageWeekStrip(_ direction: WeekChevronDirection) {
        finishWeekStripSettleNow()
        switch direction {
        case .before:
            guard screen.previousWeekStrip != nil else {
                return
            }
            commitFocusedOneOffField(forDeparture: true)
            beginWeekStripSettle(to: weekStripWidth) { screen.showPreviousWeek() }
        case .after:
            guard screen.nextWeekStrip != nil else {
                return
            }
            commitFocusedOneOffField(forDeparture: true)
            beginWeekStripSettle(to: -weekStripWidth) { screen.showNextWeek() }
        }
    }

    /// Slides `weekDragTranslation` to `target` and, once that finishes, runs `move` — `settle(to:
    /// then:)`'s own structure, kept separate so that function's own rows stay untouched (`tasks.md`
    /// § 6.2). Finishes any settle already running first (`finishWeekStripSettleNow()`), so at most
    /// one is ever in flight.
    private func beginWeekStripSettle(to target: CGFloat, then move: (() -> Void)?) {
        finishWeekStripSettleNow()
        weekStripIsSettling = true
        weekStripSettleMove = move
        weekStripSettleGeneration += 1
        let generation = weekStripSettleGeneration

        // Nothing to animate — already at `target`, as a resisted release or a mostly vertical
        // drag both leave `weekDragTranslation` — so `finishWeekStripSettle(generation:)` runs
        // straight away rather than through a `withAnimation` whose value never actually changes.
        guard !reduceMotion, target != weekDragTranslation else {
            finishWeekStripSettle(generation: generation)
            return
        }

        withAnimation(.easeOut, completionCriteria: .logicallyComplete) {
            weekDragTranslation = target
        } completion: {
            finishWeekStripSettle(generation: generation)
        }
    }

    /// Finishes a settle already in flight at once, without animation, so a chevron tap, a carried
    /// release or a drag beginning while the strip is still sliding acts on the day that settle
    /// leaves it showing rather than the one it started on. A no-op where nothing is settling.
    private func finishWeekStripSettleNow() {
        guard weekStripIsSettling else {
            return
        }
        weekStripSettleGeneration += 1
        finishWeekStripSettle(generation: weekStripSettleGeneration)
    }

    /// Runs the move the settle `generation` names, ticks only where that move actually changed
    /// the day being shown, and clears `weekStripIsSettling` — reached either by
    /// `beginWeekStripSettle(to:then:)`'s own animation completion or by
    /// `finishWeekStripSettleNow()` finishing that settle early. Acts only where `generation`
    /// still matches, so whichever of the two reaches a given settle second does nothing.
    private func finishWeekStripSettle(generation: Int) {
        guard weekStripIsSettling, generation == weekStripSettleGeneration else {
            return
        }
        weekDragTranslation = 0
        if let move = weekStripSettleMove {
            let before = screen.dayPickerReach.opensOn
            move()
            if screen.dayPickerReach.opensOn != before {
                daysTurned += 1
            }
        }
        weekStripSettleMove = nil
        weekStripIsSettling = false
    }
}
