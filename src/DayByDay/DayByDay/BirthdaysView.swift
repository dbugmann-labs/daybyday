import SwiftUI
import DayByDayKit

/// The coming year's birthdays, soonest first: one inset section, each line the calendar's words
/// leading and wrapping beside its day trailing, dimmed and never wrapped. No chevron, tick or
/// cake — every line on this screen is a birthday, and it neither shows nor takes a tick.
/// `design.md` § *The shell* and § *What the shell draws*. Decides nothing (ADR-1019): the Kit
/// hands `lines` and `birthdayState`, and the one sentence for an empty list is drawn for the
/// state it hands.
struct BirthdaysView: View {
    let screen: BirthdaysScreen

    var body: some View {
        List {
            Section {
                if screen.lines.isEmpty {
                    Text(emptySentence)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(Array(screen.lines.enumerated()), id: \.offset) { _, line in
                        HStack(alignment: .firstTextBaseline, spacing: 12) {
                            Text(line.words)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(line.dayInWords)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                    }
                }
            }
        }
        .navigationTitle("Birthdays")
        .navigationBarTitleDisplayMode(.large)
    }

    private var emptySentence: String {
        switch screen.birthdayState {
        case .off: "Birthdays are off."
        case .calendarUnreadable: "Birthdays could not be read."
        case .on: "No birthdays in the coming year."
        }
    }
}
