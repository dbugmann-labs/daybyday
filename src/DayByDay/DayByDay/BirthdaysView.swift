import SwiftUI
import DayByDayKit

/// The coming year's birthdays, soonest first: one inset section, each line the calendar's words
/// leading and wrapping over the count of its present ideas, dimmed, beside its day trailing,
/// dimmed and never wrapped, and a chevron to the person's page. No tick or cake — it neither
/// shows nor takes a tick. `add-present-idea/design.md` § *The shell* and § *What the shell
/// draws*. Decides nothing (ADR-1019): the Kit hands `lines`, `ideasInWords`, `birthdayState` and
/// `presentIdeaState` and `saysACopyCanBeRestored`, and the sentences for an empty list and an
/// unreadable place are drawn for the state it hands.
struct BirthdaysView: View {
    let screen: BirthdaysScreen

    var body: some View {
        List {
            if let notKept = presentIdeasSentence {
                Section {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(notKept)
                            .foregroundStyle(.secondary)
                        if screen.saysACopyCanBeRestored {
                            Text("A copy can be restored from Settings")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            Section {
                if screen.lines.isEmpty {
                    Text(emptySentence)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(Array(screen.lines.enumerated()), id: \.offset) { _, line in
                        NavigationLink {
                            PresentIdeasView(screen: screen, line: line)
                        } label: {
                            HStack(alignment: .firstTextBaseline, spacing: 12) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(line.words)
                                    if let ideasInWords = line.ideasInWords {
                                        Text(ideasInWords)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                }
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
        }
        .navigationTitle("Birthdays")
        .navigationBarTitleDisplayMode(.large)
    }

    private var presentIdeasSentence: String? {
        switch screen.presentIdeaState {
        case .kept: nil
        case .notKept: "The present ideas could not be read."
        case .writtenByALaterVersion:
            "The present ideas were written by a newer version of DayByDay and must not be deleted."
        }
    }

    private var emptySentence: String {
        switch screen.birthdayState {
        case .off: "Birthdays are off."
        case .calendarUnreadable: "Birthdays could not be read."
        case .on: "No birthdays in the coming year."
        }
    }
}
