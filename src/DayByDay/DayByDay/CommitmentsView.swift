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
    @State private var rhythmKind: RhythmKind = .weekdays
    @State private var selectedWeekdays: Set<Weekday> = []
    @State private var dayOfMonth = 1
    @State private var intervalDays = 1
    @State private var timesPerWeek = 1
    @State private var keptFromDate: Date

    init(screen: CommitmentsScreen) {
        self.screen = screen
        _keptFromDate = State(initialValue: date(from: screen.dayToKeepFrom))
    }

    var body: some View {
        List {
            Section("Kept") {
                if screen.kept.isEmpty {
                    Text("Nothing is being kept.")
                }
                ForEach(screen.kept, id: \.self) { commitment in
                    Button {
                        screen.askToStopKeeping(commitment)
                    } label: {
                        Text(commitment.name)
                    }
                }
            }

            if case .stopping(_, let stopRefusal) = screen.refusedChange {
                refusalText(stopRefusal)
            }

            Section("Stopped") {
                if screen.stopped.isEmpty {
                    Text("Nothing has been stopped.")
                }
                ForEach(screen.stopped, id: \.self) { commitment in
                    Button {
                        screen.keepAgain(commitment)
                    } label: {
                        Text(commitment.name)
                    }
                }
            }

            if case .keepingAgain(_, let keepAgainRefusal) = screen.refusedChange {
                refusalText(keepAgainRefusal)
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

                DatePicker("Kept from", selection: $keptFromDate, displayedComponents: [.date])

                Button("Add") {
                    define()
                }

                if case .defining(let refusal) = screen.refusedChange {
                    refusalText(refusal)
                }
            }
        }
        .navigationTitle("Commitments")
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

    /// Builds the `Rhythm` the form is currently offering and hands it to `define`, alongside
    /// the name typed and the day picked. A number the calendar will not take is not judged here —
    /// `screen.define` refuses it as `.rhythmOutOfRange` — so the only guard left is the date
    /// picker's instant failing to convert, which a `DatePicker` cannot actually produce.
    private func define() {
        let rhythm: Rhythm
        switch rhythmKind {
        case .weekdays:
            rhythm = .weekdays(selectedWeekdays)
        case .dayOfMonth:
            rhythm = .dayOfMonth(dayOfMonth)
        case .everyNDays:
            rhythm = .everyNDays(intervalDays)
        case .weeklyQuota:
            rhythm = .weeklyQuota(timesPerWeek)
        }

        let components = Calendar.current.dateComponents(
            [.year, .month, .day], from: keptFromDate)
        guard
            let keptFrom = CalendarDate(
                year: components.year!, month: components.month!, day: components.day!)
        else { return }

        let refusal = screen.define(name: name, on: rhythm, keptFrom: keptFrom)

        if refusal == nil {
            name = ""
            selectedWeekdays = []
        }
    }
}
