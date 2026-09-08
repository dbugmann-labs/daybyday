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

/// The roster's own management surface: what it keeps, what it has stopped, and a form that
/// defines a new commitment on one of the four rhythms `CommitmentsScreen` offers.
struct CommitmentsView: View {
    let screen: CommitmentsScreen

    @State private var name = ""
    @State private var category = ""
    @State private var rhythmKind: RhythmKind = .weekdays
    @State private var selectedWeekdays: Set<Weekday> = []
    @State private var dayOfMonth = 1
    @State private var intervalDays = 1
    @State private var timesPerWeek = 1
    @State private var keptFromDate: Date
    @State private var categorising: Commitment?
    @State private var categoryTyped = ""

    init(screen: CommitmentsScreen) {
        self.screen = screen
        _keptFromDate = State(initialValue: date(from: screen.dayToKeepFrom))
    }

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
            // `.sectionActions` draws `Move up` and `Move down` below a categorised section's
            // content in Edit mode, the one documented per-section action surface — `design.md`
            // § *The shell rides this Story*. `index` is the group's own position in
            // `screen.keptGroups`, which is `screen.categoriesInUse`'s position too: the group
            // under no category, where there is one, is always last, so every categorised group
            // sits at the same index in both. Up is `index - 1`, down is `index + 2`, and each is
            // drawn only where that offset is one `screen.categoriesInUse` has, so no tap can
            // reach a refusal; nothing here counts rows or asks where a finger is.
            ForEach(Array(screen.keptGroups.enumerated()), id: \.element.category) { index, group in
                Section {
                    ForEach(Array(group.commitments.enumerated()), id: \.offset) {
                        index, commitment in
                        commitmentLine(
                            Text(commitment.name), rhythmInWords: commitment.rhythmInWords
                        )
                        .swipeActions {
                            Button("Stop") {
                                screen.askToStopKeeping(commitment)
                            }
                            Button("Remove", role: .destructive) {
                                screen.askToRemove(commitment)
                            }
                            Button("Category") {
                                categorising = commitment
                                categoryTyped = group.category ?? ""
                            }
                        }
                    }
                    .onMove { source, offset in
                        guard let index = source.first else { return }
                        screen.move(group.commitments[index], toOffset: offset, under: group.category)
                    }
                } header: {
                    if let category = group.category {
                        // Same insets as the day screen's category heading, for the same reason
                        // and off the same measurement — see the comment there. The `Kept`,
                        // `Stopped` and `Define a commitment` headings below keep the platform's
                        // own padding: they divide this screen rather than name a group, and the
                        // owner's ask was about the gap above a category.
                        Text(category)
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 6, trailing: 16))
                    }
                }
                .sectionActions {
                    if let category = group.category {
                        if index > 0 {
                            Button("Move up") {
                                screen.move(group: category, toOffset: index - 1)
                            }
                        }
                        if index + 2 <= screen.categoriesInUse.count {
                            Button("Move down") {
                                screen.move(group: category, toOffset: index + 2)
                            }
                        }
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

            if case .categorising(_, let categorisingRefusal) = screen.refusedChange {
                refusalText(categorisingRefusal)
            }

            Section("Stopped") {
                if screen.stopped.isEmpty {
                    Text("Nothing has been stopped.")
                }
                ForEach(screen.stopped, id: \.self) { commitment in
                    commitmentLine(
                        Text(commitment.name), rhythmInWords: commitment.rhythmInWords
                    )
                    .swipeActions {
                        Button("Resume") {
                            screen.keepAgain(commitment)
                        }
                        Button("Remove", role: .destructive) {
                            screen.askToRemove(commitment)
                        }
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

            Section("Define a commitment") {
                TextField("Name", text: $name)

                Picker("Rhythm", selection: $rhythmKind) {
                    ForEach(RhythmKind.allCases) { kind in
                        Text(kind.rawValue).tag(kind)
                    }
                }

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
                case .dayOfMonth:
                    Stepper("Day \(dayOfMonth)", value: $dayOfMonth, in: 1...31)
                case .everyNDays:
                    LabeledContent("Every") {
                        TextField("Days", value: $intervalDays, format: .number)
                            .keyboardType(.numberPad)
                        Text("day(s)")
                    }
                case .weeklyQuota:
                    Stepper("\(timesPerWeek) time(s) a week", value: $timesPerWeek, in: 1...7)
                }

                if let preview = rhythmBeingBuilt.inWords {
                    Text(preview)
                        .foregroundStyle(.secondary)
                }

                DatePicker("Kept from", selection: $keptFromDate, displayedComponents: [.date])

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

                Button("Add") {
                    define()
                }

                if case .defining(let refusal) = screen.refusedChange {
                    refusalText(refusal)
                }
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
                EditButton()
            }
        }
        .onChange(of: screen.dayToKeepFrom) { _, newValue in
            keptFromDate = date(from: newValue)
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
        .sheet(
            isPresented: Binding(
                get: { categorising != nil },
                set: { isPresented in
                    if !isPresented {
                        categorising = nil
                    }
                }
            )
        ) {
            if let commitment = categorising {
                NavigationStack {
                    Form {
                        Section {
                            TextField("Category (blank for none)", text: $categoryTyped)
                        }
                        if !screen.categoriesInUse.isEmpty {
                            Section("Already in use") {
                                ForEach(screen.categoriesInUse, id: \.self) { existing in
                                    Button(existing) {
                                        categoryTyped = existing
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle("Category for \(commitment.name)")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                categorising = nil
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                screen.put(
                                    commitment,
                                    under: categoryTyped.isEmpty ? nil : categoryTyped)
                                categorising = nil
                            }
                        }
                    }
                }
            }
        }
    }

    /// The words a person reads for a refused change, in the shell's own vocabulary — the same
    /// shape `RosterState`'s three cases already map to. One case, `.namesNothing` through
    /// `.notKept`, one sentence; nothing here decides whether a refusal happened, only what it is
    /// called.
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
        }
    }

    /// The `Rhythm` the form is currently offering, from whichever fields `rhythmKind` selects.
    /// Read by `define()` to hand off, and by the preview to say it in words as it is built.
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

    /// Hands `rhythmBeingBuilt` to `define`, alongside the name typed and the day picked. A
    /// number the calendar will not take is not judged here — `screen.define` refuses it as
    /// `.rhythmOutOfRange` — so the only guard left is the date picker's instant failing to
    /// convert, which a `DatePicker` cannot actually produce.
    private func define() {
        let components = Calendar.current.dateComponents(
            [.year, .month, .day], from: keptFromDate)
        guard
            let keptFrom = CalendarDate(
                year: components.year!, month: components.month!, day: components.day!)
        else { return }

        let refusal = screen.define(
            name: name, on: rhythmBeingBuilt, keptFrom: keptFrom,
            under: category.isEmpty ? nil : category)

        if refusal == nil {
            name = ""
            category = ""
            selectedWeekdays = []
        }
    }
}
