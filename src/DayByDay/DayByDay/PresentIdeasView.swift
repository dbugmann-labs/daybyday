import SwiftUI
import DayByDayKit

/// One person's page of present ideas, pushed from a Birthdays line: the line's words as
/// wrapping heading text over its day, dimmed; one card of the ideas added, in the order added —
/// text over its link, or a link alone — or "No ideas yet."; and a "New idea" card, replaced by
/// the line saying why while the place is not kept. `add-present-idea/design.md` § *The shell*.
/// Decides nothing (ADR-1019): the Kit gives back the ideas and refuses the add.
struct PresentIdeasView: View {
    let screen: BirthdaysScreen
    let line: BirthdaysScreen.Line

    @State private var addingIdea = false
    /// Bumped when the sheet is dismissed, so this page is drawn again from what the Kit now holds.
    @State private var sheetsClosed = 0

    var body: some View {
        let _ = sheetsClosed
        let ideas = screen.ideas(of: line)
        List {
            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text(line.words)
                        .font(.title2.weight(.bold))
                        .fixedSize(horizontal: false, vertical: true)
                    Text(line.dayInWords)
                        .foregroundStyle(.secondary)
                }
                .listRowBackground(Color.clear)
            }
            Section {
                if ideas.isEmpty {
                    Text("No ideas yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(Array(ideas.enumerated()), id: \.offset) { _, idea in
                        row(idea)
                    }
                }
            }
            Section {
                if screen.presentIdeaState == .kept {
                    Button("New idea") {
                        addingIdea = true
                    }
                } else {
                    Text(notKeptSentence)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $addingIdea, onDismiss: { sheetsClosed += 1 }) {
            NewIdeaSheet(screen: screen, line: line)
        }
    }

    @ViewBuilder
    private func row(_ idea: PresentIdea) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            if let text = idea.text {
                Text(text)
            }
            if let link = idea.link {
                linkLabel(link, hasText: idea.text != nil, opens: idea.opens)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// The link as one run of text carrying its address, so only the glyphs open it and VoiceOver
    /// announces it as a link; the rest of the row is not a control.
    private func linkLabel(_ link: String, hasText: Bool, opens: URL?) -> some View {
        var words = AttributedString(link)
        words.link = opens
        return Text(words)
            .font(hasText ? .subheadline : .body)
            .foregroundStyle(.tint)
            .lineLimit(1)
            .truncationMode(.tail)
    }

    private var notKeptSentence: String {
        switch screen.presentIdeaState {
        case .writtenByALaterVersion:
            "The present ideas were written by a newer version of DayByDay and must not be deleted."
        default:
            "The present ideas could not be read."
        }
    }
}

private struct NewIdeaSheet: View {
    let screen: BirthdaysScreen
    let line: BirthdaysScreen.Line

    @State private var text = ""
    @State private var link = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Idea", text: $text)
                        .onChange(of: text) { _, _ in screen.ideaFieldEdited() }
                    TextField("Link", text: $link)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .onChange(of: link) { _, _ in screen.ideaFieldEdited() }
                    if let refusal = screen.ideaRefusal {
                        Text(refusalSentence(refusal))
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("New idea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if screen.addIdea(text: text, link: link, to: line) == nil {
                            dismiss()
                        }
                    }
                }
            }
        }
        .onDisappear {
            screen.ideaSheetClosed()
        }
    }

    private func refusalSentence(_ refusal: PresentIdeaRefusal) -> String {
        switch refusal {
        case .saysNothing: "Type an idea or a link."
        case .linkIsNotAWebAddress: "That link is not a web address."
        case .notKept: "Not saved. Try again."
        }
    }
}
