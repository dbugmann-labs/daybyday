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

    /// The index into `screen.kept` (flat) each group's heading is drawn above — only where the
    /// group is under a category, since the group with none draws no heading. `screen.keptGroups`
    /// says the groups; this reads them, converting nothing about what is in each.
    private var keptGroupHeadings: [Int: String] {
        var headings: [Int: String] = [:]
        var offset = 0
        for group in screen.keptGroups {
            if let category = group.category {
                headings[offset] = category
            }
            offset += group.commitments.count
        }
        return headings
    }

    var body: some View {
        List {
            Section("Kept") {
                if screen.kept.isEmpty {
                    Text("Nothing is being kept.")
                }
                // One flat `ForEach` over `screen.kept`, not a `Section` per group — a per-section
                // `.onMove` would hand this shell an offset counted within that section, which is
                // arithmetic ADR-1019's guard forbids. The group a row is under is drawn as a
                // heading above the first entry of that group, read off `screen.keptGroups`;
                // `.onMove`'s offset passes through untouched, over `screen.kept` exactly as
                // `design.md` § *The seam* fixes it.
                ForEach(Array(screen.kept.enumerated()), id: \.element) { index, commitment in
                    if let heading = keptGroupHeadings[index] {
                        Text(heading)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
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
                            categoryTyped =
                                screen.keptGroups.first { $0.commitments.contains(commitment) }?
                                .category ?? ""
                        }
                    }
                }
                // The drag hands an `IndexSet` and a destination `Int`; a single-row drag in a
                // `List` always produces one element, and `offset` passes through to `screen.move`
                // untouched — `design.md` § *The seam* fixes the arithmetic there, not here.
                .onMove { source, offset in
                    guard let index = source.first else { return }
                    screen.move(screen.kept[index], toOffset: offset)
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
