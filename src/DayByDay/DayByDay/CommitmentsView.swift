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
    @State private var refusal: CommitmentsScreen.Refusal?

    init(screen: CommitmentsScreen, keptFromDate: Date) {
        self.screen = screen
        _keptFromDate = State(initialValue: keptFromDate)
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

                switch refusal {
                case nil:
                    EmptyView()
                case .namesNothing:
                    Text("Give it a name.")
                case .dueOnNoDay:
                    Text("Choose at least one weekday.")
                case .alreadyKept:
                    Text("Already being kept.")
                case .notKept:
                    Text("The roster could not be read or could not be written.")
                }
            }
        }
        .navigationTitle("Commitments")
        .confirmationDialog(
            "Stop keeping this commitment?",
            isPresented: Binding(
                get: { screen.awaitingConfirmation != nil },
                set: { isPresented in
                    if !isPresented {
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

    /// Builds the `Rhythm` the form is currently offering and hands it to `define`, alongside
    /// the name typed and the day picked. Does nothing when a widget's own value cannot form the
    /// piece it stands for — a `Stepper` bounded to a type's own range cannot produce one, so this
    /// only guards the free-form day count and the date picker's arbitrary range.
    private func define() {
        let rhythm: Rhythm
        switch rhythmKind {
        case .weekdays:
            rhythm = .weekdays(selectedWeekdays)
        case .dayOfMonth:
            guard let value = DayOfMonth(day: dayOfMonth) else { return }
            rhythm = .dayOfMonth(value)
        case .everyNDays:
            guard let value = DayInterval(days: intervalDays) else { return }
            rhythm = .everyNDays(value)
        case .weeklyQuota:
            guard let value = WeeklyQuota(timesPerWeek: timesPerWeek) else { return }
            rhythm = .weeklyQuota(value)
        }

        let components = Calendar.current.dateComponents(
            [.year, .month, .day], from: keptFromDate)
        guard
            let keptFrom = CalendarDate(
                year: components.year!, month: components.month!, day: components.day!)
        else { return }

        refusal = screen.define(name: name, on: rhythm, keptFrom: keptFrom)

        if refusal == nil {
            name = ""
            selectedWeekdays = []
        }
    }
}
