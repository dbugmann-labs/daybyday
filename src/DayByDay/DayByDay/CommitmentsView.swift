import Foundation
import SwiftUI
import DayByDayKit

/// Which rhythm shape the form is currently offering. A UI-only selector: the rule each shape
/// names lives behind the seam, in `Rhythm` and the screen that refuses what it cannot form.
private enum RhythmKind: String, CaseIterable, Identifiable, Hashable {
    case weekdays = "Weekdays"
    case dayOfMonth = "Day of month"
    case everyNDays = "Every N days"
    case weeklyQuota = "Times a week"

    var id: String { rawValue }
}

private let allWeekdays: [Weekday] = [
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
]

private func weekdayName(_ weekday: Weekday) -> String {
    switch weekday {
    case .monday: "Monday"
    case .tuesday: "Tuesday"
    case .wednesday: "Wednesday"
    case .thursday: "Thursday"
    case .friday: "Friday"
    case .saturday: "Saturday"
    case .sunday: "Sunday"
    }
}

/// Turns the calendar date `screen` hands back into the instant a SwiftUI `DatePicker` needs —
/// the reverse of `ContentView.today()`, and, like it, edge code per ADR-1004: both read
/// `Calendar.current`, the device's own calendar, so the two conversions agree.
private func date(from calendarDate: CalendarDate) -> Date {
    var components = DateComponents()
    components.year = calendarDate.year
    components.month = calendarDate.month
    components.day = calendarDate.day
    return Calendar.current.date(from: components)!
}

/// The words a person reads for a refused change, in the shell's own vocabulary — the same shape
/// `RosterState`'s three cases already map to. One case, `.namesNothing` through
/// `.wouldLeaveARecordedDayNotDue`, one sentence; nothing here decides whether a refusal
/// happened, only what it is called. File-scope rather than a method, so both `CommitmentsView`
/// and `CommitmentSheet` read off the same words.
@ViewBuilder
private func refusalText(_ refusal: CommitmentsScreen.Refusal) -> some View {
    switch refusal {
    case .namesNothing:
        Text("Give it a name.")
    case .dueOnNoDay:
        Text("Choose at least one weekday.")
    case .rhythmOutOfRange:
        Text("That number isn't one this rhythm accepts.")
    case .alreadyKept:
        Text("Already being kept.")
    case .notKept:
        Text("The roster could not be read or could not be written.")
    case .stoppedCommitmentCannotChangeRhythm:
        Text("Take it up again first to change its rhythm.")
    case .wouldLeaveARecordedDayNotDue:
        Text("Choose a day that leaves every recorded day due.")
    }
}

/// Which commitment `CommitmentSheet` is open for — nothing, for a sheet that defines a new one,
/// or the one it is open to change. `Identifiable` so `.sheet(item:)` can drive it directly, and
/// so opening a second commitment while one sheet is already open (unreachable from this view
/// today) still gets a sheet of its own identity rather than the first one's state reused under
/// it.
private enum SheetTarget: Identifiable {
    case defining
    case changing(Commitment)

    var id: Int {
        switch self {
        case .defining: 0
        case .changing(let commitment): commitment.hashValue
        }
    }

    var commitment: Commitment? {
        if case .changing(let commitment) = self { commitment } else { nil }
    }
}

/// The roster's own management surface: what it keeps, what it has stopped, and the sheet — B-037
/// — that defines a new commitment on one of the four rhythms `CommitmentsScreen` offers, or
/// changes one already on either list.
struct CommitmentsView: View {
    let screen: CommitmentsScreen

    @State private var sheetTarget: SheetTarget?
    @Environment(\.editMode) private var editMode

    var body: some View {
        List {
            if screen.keptGroups.isEmpty {
                Section("Kept") {
                    Text("Nothing is being kept.")
                }
            }
            // A `Section` per group, not one flat list: the category is the section's own
            // header, and the group with none draws no header. Each section's `ForEach` carries
            // one `.onMove`, over an offset already counted inside that section's own entries —
            // `design.md` § *The shell rides this Story*. It passes that offset straight through
            // to `screen.move` beside the section's own `group.category`: nothing here adds,
            // subtracts, counts rows or asks where a finger is.
            //
            // `.sectionActions` draws two icon buttons below a categorised section's content, the
            // one documented per-section action surface — `design.md` § *The shell rides this
            // Story*. Gated on `editMode` below: `grill.md` § *Settled* 6 decided the actions
            // appear in Edit mode only, and both the appearance and the row re-evaluating on that
            // transition are confirmed — on the phone (2026-09-09) and by
            // `zzzScratchVerifyEditGateAndRowHeight`, a throwaway XCUITest run during this fix and
            // not kept: no `Move up`/`Move down` button exists before `EditButton()` is tapped,
            // both exist right after. Both sit in one `HStack`, itself the single view the content
            // closure returns, so the row reads as one item with two separately tappable buttons
            // rather than two stacked rows — confirmed on the phone: Apple's own documented example
            // draws a single `Button` and says nothing about two, so this was open until walked.
            // Each carries the accessibility label the prose in `proposal.md` and `design.md`
            // names, `Move up` and `Move down`, unchanged by drawing an icon instead of the words.
            // `groupIndex` is the group's own position in
            // `screen.keptGroups`, which is `screen.categoriesInUse`'s position too: the group
            // under no category, where there is one, is always last, so every categorised group
            // sits at the same index in both. Up is `groupIndex - 1`, down is `groupIndex + 2`,
            // and each is drawn only where that offset is one `screen.categoriesInUse` has, so no
            // tap can reach a refusal; nothing here counts rows or asks where a finger is.
            ForEach(Array(screen.keptGroups.enumerated()), id: \.element.category) { groupIndex, group in
                Section {
                    // Keyed on the commitment's own value, not its position — as the flat list
                    // was before this Story's group move started carrying whole blocks through
                    // this `ForEach`. `.onMove` still takes its offsets from the underlying
                    // `group.commitments`, whatever the `id:` is keyed on.
                    ForEach(group.commitments, id: \.self) { commitment in
                        commitmentLine(
                            Text(commitment.name), rhythmInWords: commitment.rhythmInWords
                        )
                        .swipeActions(edge: .leading) {
                            Button {
                                sheetTarget = .changing(commitment)
                            } label: {
                                Image(systemName: "pencil")
                            }
                            .tint(.accentColor)
                            .accessibilityLabel("Edit")
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                screen.askToStopKeeping(commitment)
                            } label: {
                                Image(systemName: "stop.circle")
                            }
                            .tint(.orange)
                            .accessibilityLabel("Stop")
                            Button(role: .destructive) {
                                screen.askToRemove(commitment)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                            .accessibilityLabel("Remove")
                        }
                    }
                    .onMove { source, offset in
                        guard let rowIndex = source.first else { return }
                        screen.move(group.commitments[rowIndex], toOffset: offset, under: group.category)
                    }
                } header: {
                    if let category = group.category {
                        // Same insets as the day screen's category heading, for the same reason
                        // and off the same measurement — see the comment there. The `Kept` and
                        // `Stopped` headings below keep the platform's own padding: they divide
                        // this screen rather than name a group, and the owner's ask was about the
                        // gap above a category.
                        Text(category)
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 6, trailing: 16))
                    }
                }
                .sectionActions {
                    if editMode?.wrappedValue.isEditing == true, let category = group.category {
                        // One `HStack`, so this is one item to `sectionActions` rather than two —
                        // see the comment above `ForEach(Array(screen.keptGroups.enumerated())…`.
                        //
                        // **This row cannot be made thinner than a commitment row from here.**
                        // Measured 2026-09-09 with `zzzScratchVerifyEditGateAndRowHeight`: a
                        // `sectionActions` row's own frame reads exactly 52.0pt — identical, to the
                        // decimal, to a plain commitment row's (`Creatine - Every day`, also
                        // 52.0pt) — and stays exactly 52.0pt across three separate builds tried in
                        // turn: `.listRowInsets` alone (below), `.listRowInsets` plus
                        // `.frame(height: 32)`, and both plus
                        // `.environment(\.defaultMinListRowHeight, 32)` on the row's own content.
                        // None moved it by a point. `sectionActions` appears to impose a fixed,
                        // platform-drawn row height on this SDK (iOS 26.5) that no content-level
                        // sizing modifier reaches — consistent with the header text above shrinking
                        // to 28pt off the same `.listRowInsets` this row ignores, so the modifier
                        // itself works in this file, just not on a `sectionActions` row. Left as
                        // `.listRowInsets` alone, since the other two measured no different from
                        // one another and from having neither; not shrinking the icons instead,
                        // since that would not change what reads as thick — the row.
                        HStack(spacing: 32) {
                            if groupIndex > 0 {
                                Button {
                                    screen.move(group: category, toOffset: groupIndex - 1)
                                } label: {
                                    Image(systemName: "arrow.up")
                                }
                                .accessibilityLabel("Move up")
                            }
                            if groupIndex + 2 <= screen.categoriesInUse.count {
                                Button {
                                    screen.move(group: category, toOffset: groupIndex + 2)
                                } label: {
                                    Image(systemName: "arrow.down")
                                }
                                .accessibilityLabel("Move down")
                            }
                        }
                        .buttonStyle(.borderless)
                        .listRowInsets(EdgeInsets(top: 2, leading: 16, bottom: 2, trailing: 16))
                    }
                }
            }

            if case .stopping(_, let stopRefusal) = screen.refusedChange {
                refusalText(stopRefusal)
            }

            if case .removing(let removed, let removingRefusal) = screen.refusedChange,
                screen.kept.contains(removed)
            {
                refusalText(removingRefusal)
            }

            if case .moving(_, let movingRefusal) = screen.refusedChange {
                refusalText(movingRefusal)
            }

            if case .movingGroup(_, let movingGroupRefusal) = screen.refusedChange {
                refusalText(movingGroupRefusal)
            }

            Section("Stopped") {
                if screen.stopped.isEmpty {
                    Text("Nothing has been stopped.")
                }
                ForEach(screen.stopped, id: \.self) { commitment in
                    commitmentLine(
                        Text(commitment.name), rhythmInWords: commitment.rhythmInWords
                    )
                    .swipeActions(edge: .leading) {
                        Button {
                            sheetTarget = .changing(commitment)
                        } label: {
                            Image(systemName: "pencil")
                        }
                        .tint(.accentColor)
                        .accessibilityLabel("Edit")
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            screen.keepAgain(commitment)
                        } label: {
                            Image(systemName: "play.circle")
                        }
                        .tint(.green)
                        .accessibilityLabel("Resume")
                        Button(role: .destructive) {
                            screen.askToRemove(commitment)
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                        .accessibilityLabel("Remove")
                    }
                }
            }

            if case .keepingAgain(_, let keepAgainRefusal) = screen.refusedChange {
                refusalText(keepAgainRefusal)
            }

            if case .removing(let removed, let removingRefusal) = screen.refusedChange,
                screen.stopped.contains(removed)
            {
                refusalText(removingRefusal)
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
        // Apple documents `.default` and `.compact` but publishes no point value for either.
        // Measured directly on device (iPhone 17 simulator, iOS 26.5, this SDK): the platform
        // default renders as ~17.7pt between two adjacent sections, confirmed by a calibration
        // read-back — setting this same modifier to 0 and to 20 moved the on-screen gap to
        // exactly 0 and exactly 20, so the measurement has no hidden offset to account for. 12 is
        // about two thirds of that, per the owner's ask.
        .listSectionSpacing(12)
        .navigationTitle("Commitments")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Toggle(
                    isOn: Binding(
                        get: { editMode?.wrappedValue.isEditing == true },
                        set: { isReordering in
                            editMode?.wrappedValue = isReordering ? .active : .inactive
                        }
                    )
                ) {
                    Image(systemName: "arrow.up.arrow.down")
                }
                .toggleStyle(.button)
                .accessibilityLabel(
                    editMode?.wrappedValue.isEditing == true ? "Reorder, on" : "Reorder, off")
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    sheetTarget = .defining
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Define a commitment")
            }
        }
        .alert(
            "Stop keeping this commitment?",
            isPresented: Binding(
                get: { screen.awaitingConfirmation != nil },
                set: { isPresented in
                    if !isPresented && screen.awaitingConfirmation != nil {
                        screen.cancelStopKeeping()
                    }
                }
            ),
            presenting: screen.awaitingConfirmation
        ) { commitment in
            Button("Stop keeping \(commitment.name)", role: .destructive) {
                screen.confirmStopKeeping()
            }
            Button("Cancel", role: .cancel) {
                screen.cancelStopKeeping()
            }
        }
        .sheet(
            isPresented: Binding(
                get: { screen.awaitingRemoval != nil },
                set: { isPresented in
                    if !isPresented {
                        screen.cancelRemoving()
                    }
                }
            )
        ) {
            if let commitment = screen.awaitingRemoval {
                NavigationStack {
                    Form {
                        Section {
                            Text("Type \"\(commitment.name)\" to remove it for good.")
                            TextField(
                                "Name",
                                text: Binding(
                                    get: { screen.nameTypedBack },
                                    set: { screen.nameTypedBack = $0 }
                                ))
                        }
                    }
                    .navigationTitle("Remove \(commitment.name)")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                screen.cancelRemoving()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Remove", role: .destructive) {
                                screen.confirmRemoving()
                            }
                            .disabled(!screen.nameTypedBackMatches)
                        }
                    }
                }
            }
        }
        .sheet(item: $sheetTarget) { target in
            CommitmentSheet(screen: screen, changing: target.commitment)
        }
    }
}

/// The one sheet that both defines a new commitment and changes one already on either of
/// `screen`'s lists — B-037. Reached by a `+` in `CommitmentsView`'s toolbar for defining and by
/// a tap on a row for changing. Its fields start from `screen.whatItIsMadeOf(commitment)` when it
/// is open to change one, and from `screen.dayToKeepFrom` when it is open to define; either way, a
/// refusal leaves every field exactly as it was typed rather than closing the sheet, because a
/// rhythm built control by control is most of the work a refusal would otherwise throw away.
private struct CommitmentSheet: View {
    let screen: CommitmentsScreen
    let changing: Commitment?
    let canChangeRhythmAndKeptFrom: Bool

    @State private var name: String
    @State private var category: String
    @State private var rhythmKind: RhythmKind
    @State private var selectedWeekdays: Set<Weekday>
    @State private var dayOfMonth: Int
    @State private var intervalDays: Int
    @State private var timesPerWeek: Int
    @State private var keptFromDate: Date
    @State private var refusal: CommitmentsScreen.Refusal?
    @Environment(\.dismiss) private var dismiss

    /// `commitment` is `nil` to define a new commitment, and the one to change otherwise. Every
    /// field starts from `screen.whatItIsMadeOf(commitment)` in the second case — the rhythm and
    /// the day kept from included, whether or not `canChangeRhythmAndKeptFrom` then lets a thumb
    /// into them — and from an empty form kept from `screen.dayToKeepFrom` in the first.
    init(screen: CommitmentsScreen, changing commitment: Commitment?) {
        self.screen = screen
        self.changing = commitment

        let madeOf = commitment.flatMap { screen.whatItIsMadeOf($0) }
        canChangeRhythmAndKeptFrom = madeOf?.canChangeRhythmAndKeptFrom ?? true

        _name = State(initialValue: madeOf?.name ?? "")
        _category = State(initialValue: madeOf?.category ?? "")
        _keptFromDate = State(initialValue: date(from: madeOf?.keptFrom ?? screen.dayToKeepFrom))

        switch madeOf?.rhythm {
        case .weekdays(let weekdays):
            _rhythmKind = State(initialValue: .weekdays)
            _selectedWeekdays = State(initialValue: weekdays)
            _dayOfMonth = State(initialValue: 1)
            _intervalDays = State(initialValue: 1)
            _timesPerWeek = State(initialValue: 1)
        case .dayOfMonth(let day):
            _rhythmKind = State(initialValue: .dayOfMonth)
            _selectedWeekdays = State(initialValue: [])
            _dayOfMonth = State(initialValue: day)
            _intervalDays = State(initialValue: 1)
            _timesPerWeek = State(initialValue: 1)
        case .everyNDays(let days):
            _rhythmKind = State(initialValue: .everyNDays)
            _selectedWeekdays = State(initialValue: [])
            _dayOfMonth = State(initialValue: 1)
            _intervalDays = State(initialValue: days)
            _timesPerWeek = State(initialValue: 1)
        case .weeklyQuota(let timesPerWeek):
            _rhythmKind = State(initialValue: .weeklyQuota)
            _selectedWeekdays = State(initialValue: [])
            _dayOfMonth = State(initialValue: 1)
            _intervalDays = State(initialValue: 1)
            _timesPerWeek = State(initialValue: timesPerWeek)
        case nil:
            _rhythmKind = State(initialValue: .weekdays)
            _selectedWeekdays = State(initialValue: [])
            _dayOfMonth = State(initialValue: 1)
            _intervalDays = State(initialValue: 1)
            _timesPerWeek = State(initialValue: 1)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)

                    Picker("Rhythm", selection: $rhythmKind) {
                        ForEach(RhythmKind.allCases) { kind in
                            Text(kind.rawValue).tag(kind)
                        }
                    }
                    .disabled(!canChangeRhythmAndKeptFrom)

                    switch rhythmKind {
                    case .weekdays:
                        ForEach(allWeekdays, id: \.self) { weekday in
                            Toggle(
                                weekdayName(weekday),
                                isOn: Binding(
                                    get: { selectedWeekdays.contains(weekday) },
                                    set: { isOn in
                                        if isOn {
                                            selectedWeekdays.insert(weekday)
                                        } else {
                                            selectedWeekdays.remove(weekday)
                                        }
                                    }
                                ))
                        }
                        .disabled(!canChangeRhythmAndKeptFrom)
                    case .dayOfMonth:
                        Stepper("Day \(dayOfMonth)", value: $dayOfMonth, in: 1...31)
                            .disabled(!canChangeRhythmAndKeptFrom)
                    case .everyNDays:
                        LabeledContent("Every") {
                            TextField("Days", value: $intervalDays, format: .number)
                                .keyboardType(.numberPad)
                            Text("day(s)")
                        }
                        .disabled(!canChangeRhythmAndKeptFrom)
                    case .weeklyQuota:
                        Stepper("\(timesPerWeek) time(s) a week", value: $timesPerWeek, in: 1...7)
                            .disabled(!canChangeRhythmAndKeptFrom)
                    }

                    DatePicker("Kept from", selection: $keptFromDate, displayedComponents: [.date])
                        .disabled(!canChangeRhythmAndKeptFrom)

                    TextField("Category (optional)", text: $category)
                    if !screen.categoriesInUse.isEmpty {
                        Menu("Use an existing category") {
                            ForEach(screen.categoriesInUse, id: \.self) { existing in
                                Button(existing) {
                                    category = existing
                                }
                            }
                        }
                    }

                    if let refusal {
                        refusalText(refusal)
                    }
                }
            }
            .navigationTitle(changing == nil ? "Define a commitment" : "Change \(changing!.name)")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(changing == nil ? "Add" : "Save") {
                        save()
                    }
                }
            }
        }
    }

    /// The `Rhythm` the form is currently offering, from whichever fields `rhythmKind` selects.
    private var rhythmBeingBuilt: Rhythm {
        switch rhythmKind {
        case .weekdays:
            return .weekdays(selectedWeekdays)
        case .dayOfMonth:
            return .dayOfMonth(dayOfMonth)
        case .everyNDays:
            return .everyNDays(intervalDays)
        case .weeklyQuota:
            return .weeklyQuota(timesPerWeek)
        }
    }

    /// Hands `rhythmBeingBuilt` to `screen.change` where this sheet is open to change a
    /// commitment, and to `screen.define` otherwise, alongside the name typed and the day picked.
    /// A number the calendar will not take is not judged here — the screen refuses it as
    /// `.rhythmOutOfRange` — so the only guard left is the date picker's instant failing to
    /// convert, which a `DatePicker` cannot actually produce. Dismisses on a change kept; stays
    /// open with every field exactly as typed on a refusal, and says why.
    private func save() {
        let components = Calendar.current.dateComponents(
            [.year, .month, .day], from: keptFromDate)
        guard
            let keptFrom = CalendarDate(
                year: components.year!, month: components.month!, day: components.day!)
        else { return }

        if let commitment = changing {
            refusal = screen.change(
                commitment, toName: name, on: rhythmBeingBuilt, keptFrom: keptFrom,
                under: category.isEmpty ? nil : category)
        } else {
            refusal = screen.define(
                name: name, on: rhythmBeingBuilt, keptFrom: keptFrom,
                under: category.isEmpty ? nil : category)
        }

        if refusal == nil {
            dismiss()
        }
    }
}
