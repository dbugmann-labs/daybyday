import Foundation
import SwiftUI
import UIKit
import UniformTypeIdentifiers
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

/// The short label the single-row weekday toggles draw — `chore/reshape-commitment-sheet`,
/// ADR-1019. The value each toggle carries is still the same `Weekday`; this names only what it
/// draws.
private func weekdayShortName(_ weekday: Weekday) -> String {
    switch weekday {
    case .monday: "Mon"
    case .tuesday: "Tue"
    case .wednesday: "Wed"
    case .thursday: "Thu"
    case .friday: "Fri"
    case .saturday: "Sat"
    case .sunday: "Sun"
    }
}

private func kindChoiceName(_ kind: CommitmentsScreen.KindChoice) -> String {
    switch kind {
    case .tick: "Tick"
    case .number: "Number"
    case .note: "Note"
    case .total: "Total"
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
    // One appearance for every refusal this file draws, matching the day screen's row notice —
    // `chore/reshape-commitment-sheet`, ADR-1019. The words above decide what a refusal says;
    // this decides only how it looks, which is why it wraps rather than repeats per case.
    Group {
        switch refusal {
        case .namesNothing:
            Text("Give it a name.")
        case .dueOnNoDay:
            Text("Choose at least one weekday.")
        case .rhythmOutOfRange:
            Text("That number isn't one this rhythm accepts.")
        case .notKept:
            Text("The roster could not be read or could not be written.")
        case .stoppedCommitmentDoesNotTakeThisChange:
            Text("Take it up again first to change anything but its name or category.")
        case .wouldLeaveARecordedDayNotDue:
            Text("Choose a day that leaves every recorded day due.")
        case .rangeIsNotARange:
            Text("That's not a range.")
        case .targetIsNotATarget:
            Text("That's not a target.")
        case .restartDayIsAfterToday:
            Text("Choose a day that isn't after today.")
        case .restartDayIsBeforeKeptFrom:
            Text("Choose a day that isn't before it's kept from.")
        case .alreadyDueOnRestartDay:
            Text("It's already due that day.")
        case .storeCouldNotBeRead:
            // Never drawn on its own: a refused copy is always drawn through
            // `copySectionRefusalText` below, which reads the store off the `RefusedChange`
            // itself rather than off this case. Names no store, so it stays honest whichever one
            // this case ever names.
            Text("That could not be read.")
        case .storeWrittenByALaterVersion:
            // Never drawn on its own, for the same reason `.storeCouldNotBeRead` above is not —
            // a refused copy is always drawn through `copySectionRefusalText`, which reads the
            // store off the `RefusedChange` itself.
            Text("That was written by a newer version of DayByDay.")
        case .notACopy:
            Text("That's not a copy.")
        case .damagedCopy:
            Text("That copy is damaged.")
        case .copyFromALaterVersion:
            Text("That copy is from a newer version of DayByDay.")
        case .nameAlreadyInUse(let name):
            // The seam already hands over the one word this caption says — the name the roster
            // holds the collision under, exactly as it holds it — so this draws it plain, rather
            // than composing a sentence around it: `design.md` § *Risks / Trade-offs*, "the
            // caption carries the name rather than saying 'already kept'."
            Text(name)
        }
    }
    .font(.caption)
    .foregroundStyle(.red)
}

/// The words a person reads for a refused copy, naming the store `store` says where one is
/// given, and the shipped words for a place that could not be written otherwise — `design.md` §
/// *The shell*: "Your record could not be read.", the roster's and the one-offs' likewise, and
/// the shipped words for a place that could not be written. The caption red the section's other
/// refusals use — `design.md` § *What the shell draws* — so this and the take-out caption under
/// it, which say the same words over the same cause, read as one colour.
@ViewBuilder
private func copySectionRefusalText(_ store: Copy.Store?, _ refusal: CommitmentsScreen.Refusal)
    -> some View
{
    Group {
        switch (store, refusal) {
        case (.record, .storeWrittenByALaterVersion):
            Text("Your record was written by a newer version of DayByDay.")
        case (.roster, .storeWrittenByALaterVersion):
            Text("Your roster was written by a newer version of DayByDay.")
        case (.oneOffs, .storeWrittenByALaterVersion):
            Text("Your one-offs were written by a newer version of DayByDay.")
        case (.record, _):
            Text("Your record could not be read.")
        case (.roster, _):
            Text("Your roster could not be read.")
        case (.oneOffs, _):
            Text("Your one-offs could not be read.")
        case (nil, _):
            refusalText(refusal)
        }
    }
    .font(.caption)
    .foregroundStyle(.red)
}

/// The words a person reads naming each store a take-out offer names, and why — `design.md` §
/// *What the shell draws*, settled 13: whenever *Take out the files* is drawn, a caption with it
/// names the store or stores that cannot be read, or that are from a newer version. The caption
/// red the section's other causes use, one line per store in the fixed order `storesNotRead`
/// already carries.
@ViewBuilder
private func takeOutCausesText(_ storesNotRead: [CommitmentsScreen.StoreNotRead]) -> some View {
    VStack(alignment: .leading, spacing: 2) {
        ForEach(storesNotRead, id: \.store) { storeNotRead in
            switch (storeNotRead.store, storeNotRead.cause) {
            case (.record, .couldNotBeRead):
                Text("Your record could not be read.")
            case (.record, .writtenByALaterVersion):
                Text("Your record was written by a newer version of DayByDay.")
            case (.roster, .couldNotBeRead):
                Text("Your roster could not be read.")
            case (.roster, .writtenByALaterVersion):
                Text("Your roster was written by a newer version of DayByDay.")
            case (.oneOffs, .couldNotBeRead):
                Text("Your one-offs could not be read.")
            case (.oneOffs, .writtenByALaterVersion):
                Text("Your one-offs were written by a newer version of DayByDay.")
            }
        }
    }
    .font(.caption)
    .foregroundStyle(.red)
}

/// The words a person reads for a refused take-out — the same caption red the section's other
/// refusals use, naming the store that could not be taken out, or that the folder it was to be
/// written into could not be written where `store` is `nil`. `design.md` § *A refused take-out
/// reuses the refused change, with a case of its own*.
@ViewBuilder
private func takeOutRefusalText(_ store: Copy.Store?) -> some View {
    Group {
        switch store {
        case .record:
            Text("The record could not be taken out.")
        case .roster:
            Text("The roster could not be taken out.")
        case .oneOffs:
            Text("The one-offs could not be taken out.")
        case nil:
            Text("That folder could not be written.")
        }
    }
    .font(.caption)
    .foregroundStyle(.red)
}

/// The words a person reads for one side of a restore's counts — a copy's own, or the phone's —
/// naming what each of `unreadable`'s stores says in place of the count it would otherwise give:
/// the roster's kept and stopped counts together, the one-offs' count on its own, and the record
/// named on its own though it gives no count at all. `design.md` § *The shell*: "a line of counts
/// for each side (a store that cannot be read is said in place of its counts)."
@ViewBuilder
private func restoreCountsText(
    _ counts: CommitmentsScreen.Counts, unreadable: [Copy.Store]
) -> some View {
    VStack(alignment: .leading, spacing: 2) {
        if unreadable.contains(.record) {
            Text("Your record could not be read.")
        }
        if unreadable.contains(.roster) {
            Text("Your roster could not be read.")
        } else {
            Text("Keeps \(counts.kept ?? 0), has stopped \(counts.stopped ?? 0)")
        }
        if unreadable.contains(.oneOffs) {
            Text("Your one-offs could not be read.")
        } else {
            Text("\(counts.oneOffs ?? 0) one-off(s)")
        }
    }
    .font(.caption)
}

/// The words a person reads for the moment a copy was made — the day, in words, and the hour and
/// the minute, `HH:mm`. `design.md` § *The shell*.
private func momentText(_ moment: Moment) -> String {
    var components = DateComponents()
    components.year = moment.day.year
    components.month = moment.day.month
    components.day = moment.day.day
    components.hour = moment.hour
    components.minute = moment.minute
    let date = Calendar.current.date(from: components)!
    return date.formatted(date: .abbreviated, time: .shortened)
}

/// Turns the instant now into the `Moment` a copy is asked for at — the conversion ADR-1004
/// keeps out of the engine and puts at the edge, beside `ContentView.today()`'s own conversion
/// for the same reason. `nil` only where the calendar cannot form today's own date or the clock's
/// own hour or minute, which never happens on a real clock.
private func momentNow() -> Moment? {
    let components = Calendar.current.dateComponents(
        [.year, .month, .day, .hour, .minute], from: Date())
    guard
        let day = CalendarDate(
            year: components.year!, month: components.month!, day: components.day!),
        let moment = Moment(on: day, hour: components.hour!, minute: components.minute!)
    else {
        return nil
    }
    return moment
}

/// Wraps `UIActivityViewController` around the URLs a copy or a take-out answers, so
/// `CommitmentsView` can hand them to the platform's share sheet. `design.md` § *The shell*:
/// `ShareLink` needs its items before the tap, and neither a copy nor a take-out exists until
/// then. A copy hands over one URL; a take-out, several — `openspec/specs/restore/spec.md` § *The
/// shape*.
private struct ShareSheet: UIViewControllerRepresentable {
    let urls: [URL]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: urls, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

/// Wraps `UIDocumentPickerViewController(forOpeningContentTypes: [.folder])` around picking a
/// folder for the copy place, the way `ShareSheet` above wraps `UIActivityViewController` —
/// `design.md` § *The folder is bookmark data beside its path*: Apple documents this grants read
/// and write to the folder and what is later added to it, unlike `.fileImporter` with `.folder`.
private struct FolderPicker: UIViewControllerRepresentable {
    let onPick: (URL) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }

    final class Coordinator: NSObject, UIDocumentPickerDelegate {
        let onPick: (URL) -> Void

        init(onPick: @escaping (URL) -> Void) {
            self.onPick = onPick
        }

        func documentPicker(
            _ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]
        ) {
            guard let url = urls.first else { return }
            onPick(url)
        }
    }
}

/// The words a person reads for why a copy place has stopped — `design.md` § *What the shell
/// draws*: the stopped half of the *Copy* section's footer, drawn in the caption red the
/// screen's other refusals use.
private func copyPlaceStopText(_ stop: CopyPlace.Stop) -> String {
    switch stop {
    case .folderCannotBeReached:
        "the folder cannot be reached"
    case .folderCannotBeWritten:
        "the folder cannot be written"
    case .storeCouldNotBeRead(.record):
        "your record could not be read"
    case .storeCouldNotBeRead(.roster):
        "your roster could not be read"
    case .storeCouldNotBeRead(.oneOffs):
        "your one-offs could not be read"
    case .storeWrittenByALaterVersion(.record):
        "your record was written by a newer version of DayByDay"
    case .storeWrittenByALaterVersion(.roster):
        "your roster was written by a newer version of DayByDay"
    case .storeWrittenByALaterVersion(.oneOffs):
        "your one-offs were written by a newer version of DayByDay"
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

/// The URL the last copy made answered, wrapped so `.sheet(item:)` can drive the share sheet
/// directly — the same idiom `SheetTarget` above drives `CommitmentSheet` with.
private struct CopyShare: Identifiable {
    let url: URL
    var id: URL { url }
}

/// The URLs a take-out answers, wrapped so `.sheet(item:)` can drive the share sheet directly —
/// the same idiom `CopyShare` above drives it with. A take-out answers several URLs at once, so
/// this carries a fresh `UUID` rather than one of them.
private struct TakeOutShare: Identifiable {
    let id = UUID()
    let urls: [URL]
}

/// The roster's own management surface: what it keeps, what it has stopped, and the sheet — B-037
/// — that defines a new commitment on one of the four rhythms `CommitmentsScreen` offers, or
/// changes one already on either list.
struct CommitmentsView: View {
    let screen: CommitmentsScreen

    @State private var sheetTarget: SheetTarget?
    /// The last copy made, wrapped in `CopyShare` — `nil` until a copy is made, and drives the
    /// share sheet: presented exactly while this holds one. `design.md` § *The shell*: `ShareLink`
    /// needs its item before the tap, so the URL is put here on success rather than offered
    /// ahead of one.
    @State private var copyShare: CopyShare?
    /// The URLs the last take-out made answered, wrapped so `.sheet(item:)` can drive the share
    /// sheet directly — `nil` until a take-out is made. `design.md` § *The shell*.
    @State private var takeOutShare: TakeOutShare?
    /// Whether the system file picker for restoring a copy is presented. `design.md` § *The
    /// shell*: `.fileImporter` for the exported type, with `askToRestore` bracketed in
    /// security-scoped access around the URL it hands back.
    @State private var isPickingRestoreFile = false
    /// Whether the folder picker for the copy place is presented.
    @State private var isPickingCopyPlaceFolder = false
    /// Whether the restore awaiting confirmation on `screen.awaitingRestore` was asked through
    /// `givenAsCopyPlace` — shell-local state mirroring which picker was tapped, so the restore
    /// sheet's *Replace it with this phone's* row is drawn only where the ask came from a folder
    /// given as the copy place, `openspec/specs/restore/spec.md` § *A folder that already holds
    /// a copy asks to restore it before it becomes the copy place*. Cleared whenever the sheet
    /// closes, by a cancel, a restore or a replace, and by an ordinary restore asked from a file.
    @State private var awaitingRestoreFromCopyPlacePick = false
    /// The name of the folder `awaitingRestoreFromCopyPlacePick` names, for the *Replace* row's
    /// footer — `screen.copyPlace?.folderName` still names the *old* copy place until a replace
    /// or a confirmed restore actually makes this one it.
    @State private var pendingCopyPlaceFolderName: String?
    @Environment(\.editMode) private var editMode

    /// Which of the four refusals against something already kept — a stop, a kept-side removal,
    /// a single commitment's move or a whole group's move — belongs in `group`'s own section
    /// footer: the group holding what was refused, or the roster's last kept group where none is
    /// known. `chore/commitments-layout`, #261: every refusal still sits with the thing it names.
    private func keptGroupRefusal(for group: Roster.Group) -> CommitmentsScreen.Refusal? {
        let owningGroup: Roster.Group?
        let refusal: CommitmentsScreen.Refusal?

        switch screen.refusedChange {
        case .stopping(let commitment, let stopRefusal):
            owningGroup = screen.keptGroups.first { $0.commitments.contains(commitment) }
            refusal = stopRefusal
        case .removing(let removed, let removingRefusal) where screen.kept.contains(removed):
            owningGroup = screen.keptGroups.first { $0.commitments.contains(removed) }
            refusal = removingRefusal
        case .moving(let commitment, let movingRefusal):
            owningGroup = screen.keptGroups.first { $0.commitments.contains(commitment) }
            refusal = movingRefusal
        case .movingGroup(let category, let movingGroupRefusal):
            owningGroup = screen.keptGroups.first { $0.category == category }
            refusal = movingGroupRefusal
        default:
            owningGroup = nil
            refusal = nil
        }

        guard let refusal else { return nil }
        return (owningGroup ?? screen.keptGroups.last) == group ? refusal : nil
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
                        // `LookBackView(screen:commitment:)` is cheap to construct — two
                        // references — so building it here, in the trailing closure this
                        // initializer resolves to, costs nothing on every redraw of every row on
                        // both lists; `screen.lookBack(at:)`, the day-by-day walk, sits behind
                        // `LookBackView`'s own `body` and only runs once this row is tapped.
                        // `design.md:117-119` accepted that walk only because nothing on the
                        // daily path calls it — this screen redrawing every row's destination was
                        // the path it missed. G7 finding 2 on #272.
                        NavigationLink {
                            LookBackView(screen: screen, commitment: commitment)
                        } label: {
                            commitmentLine(
                                Text(commitment.name), rhythmInWords: commitment.rhythmInWords
                            )
                        }
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
                } footer: {
                    if let refusal = keptGroupRefusal(for: group) {
                        refusalText(refusal)
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

            Section {
                if screen.stopped.isEmpty {
                    Text("Nothing has been stopped.")
                }
                ForEach(screen.stopped, id: \.self) { commitment in
                    NavigationLink {
                        LookBackView(screen: screen, commitment: commitment)
                    } label: {
                        commitmentLine(
                            Text(commitment.name), rhythmInWords: commitment.rhythmInWords
                        )
                    }
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
            } header: {
                Text("Stopped")
            } footer: {
                if let stoppedRefusal = screen.stoppedRefusal {
                    refusalText(stoppedRefusal.refusal)
                }

                if case .removing(let removed, let removingRefusal) = screen.refusedChange,
                    screen.stopped.contains(removed)
                {
                    refusalText(removingRefusal)
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

            // Decides nothing — `screen.recordsBelongToNoCommitment` already carried back every
            // record it could and is the one place this is judged, per ADR-1019. `design.md` §
            // *The shell rides this Story*.
            if screen.recordsBelongToNoCommitment {
                Text("Some records belong to no commitment.")
            }

            // The one section this screen offers a copy through, below *Stopped* —
            // `design.md` § *The shell*. The tap forms a `Moment` beside `today()` and hands it
            // to `makeACopy`; a `Moment` refused only where the clock itself cannot form one,
            // which never happens on a real clock, so nothing is drawn for that case. The copy
            // place row sits at the top of this section — `openspec/changes/copy-on-every-change
            // /design.md` § *What the shell draws*, Option A.
            Section {
                Button {
                    isPickingCopyPlaceFolder = true
                } label: {
                    HStack {
                        LabeledContent(
                            "Copy place", value: screen.copyPlace?.folderName ?? "Pick a folder")
                        // Every row above this one in the walk shows a disclosure chevron —
                        // `design.md` § *What the shell draws* draws one here too. A plain
                        // `Button`, not a `NavigationLink`, so it is drawn by hand the way a day
                        // screen row that opens a sheet already draws its own.
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .swipeActions(edge: .trailing) {
                    if screen.copyPlace?.folderName != nil {
                        Button(role: .destructive) {
                            screen.forgetTheCopyPlace()
                        } label: {
                            Image(systemName: "xmark.circle")
                        }
                        .accessibilityLabel("Forget")
                    }
                }

                if let refusedCopyPlace = screen.refusedCopyPlace {
                    refusalText(refusedCopyPlace)
                }

                Button("Make a copy") {
                    guard let moment = momentNow() else {
                        return
                    }
                    if case .success(let url) = screen.makeACopy(asOf: moment) {
                        copyShare = CopyShare(url: url)
                    }
                }

                if case .makingACopy(let store, let copyRefusal) = screen.refusedChange {
                    copySectionRefusalText(store, copyRefusal)
                }

                // Drawn only while a store cannot be read or is from a newer version —
                // `design.md` § *What the shell draws*, Option B.
                if screen.offersATakeOut {
                    Button("Take out the files") {
                        if case .success(let urls) = screen.takeOut(), !urls.isEmpty {
                            takeOutShare = TakeOutShare(urls: urls)
                        }
                    }

                    takeOutCausesText(screen.storesNotRead)

                    if case .takingOut(let store, _) = screen.refusedChange {
                        takeOutRefusalText(store)
                    }
                }

                Button("Restore from a copy") {
                    isPickingRestoreFile = true
                }

                if case .restoring(let restoreRefusal) = screen.refusedChange {
                    refusalText(restoreRefusal)
                }

                if let copyRestored = screen.copyRestored {
                    Text("Restored the copy from \(momentText(copyRestored))")
                        .font(.caption)
                }
            } header: {
                Text("Copy")
            } footer: {
                if let copyPlace = screen.copyPlace, copyPlace.folderName != nil {
                    VStack(alignment: .leading, spacing: 2) {
                        // `copyPlace.set(to:)` always attempts a copy the moment a folder is
                        // given (`design.md` § *A copy the moment the folder is picked*), so by
                        // the time a folder name stands here, either a last copy or a stop does
                        // too — never neither. `lastCopy == nil` here is unreachable.
                        if let lastCopy = copyPlace.lastCopy {
                            Text("Last copy \(momentText(lastCopy))")
                        }
                        if let stopped = copyPlace.stopped {
                            Text(
                                "Stopped since \(momentText(stopped.since)): \(copyPlaceStopText(stopped.stop))"
                            )
                            .foregroundStyle(.red)
                        }
                    }
                    .font(.caption)
                } else {
                    Text("Pick a folder to keep a copy there.")
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
        .sheet(item: $copyShare) { share in
            ShareSheet(urls: [share.url])
        }
        .sheet(item: $takeOutShare) { share in
            ShareSheet(urls: share.urls)
        }
        .fileImporter(
            isPresented: $isPickingRestoreFile,
            allowedContentTypes: [UTType(exportedAs: "com.dbugmann.daybyday.copy")]
        ) { result in
            guard case .success(let url) = result else {
                return
            }
            guard url.startAccessingSecurityScopedResource() else {
                return
            }
            defer { url.stopAccessingSecurityScopedResource() }
            awaitingRestoreFromCopyPlacePick = false
            pendingCopyPlaceFolderName = nil
            screen.askToRestore(from: url)
        }
        .sheet(isPresented: $isPickingCopyPlaceFolder) {
            FolderPicker { url in
                guard url.startAccessingSecurityScopedResource() else {
                    return
                }
                defer { url.stopAccessingSecurityScopedResource() }
                pendingCopyPlaceFolderName = url.lastPathComponent
                let refusal = screen.givenAsCopyPlace(url)
                awaitingRestoreFromCopyPlacePick = refusal == nil && screen.awaitingRestore != nil
                if !awaitingRestoreFromCopyPlacePick {
                    pendingCopyPlaceFolderName = nil
                }
            }
        }
        .sheet(
            isPresented: Binding(
                get: { screen.awaitingRestore != nil },
                set: { isPresented in
                    if !isPresented {
                        screen.cancelRestoring()
                        awaitingRestoreFromCopyPlacePick = false
                        pendingCopyPlaceFolderName = nil
                    }
                }
            )
        ) {
            if let awaitingRestore = screen.awaitingRestore {
                NavigationStack {
                    Form {
                        Section("Made") {
                            Text(momentText(awaitingRestore.moment))
                        }
                        Section("The copy") {
                            restoreCountsText(awaitingRestore.copy, unreadable: [])
                        }
                        Section("Your phone") {
                            restoreCountsText(
                                awaitingRestore.phone, unreadable: awaitingRestore.unreadable)
                        }
                        // Offered only where this restore was asked through the copy place's own
                        // folder picker — `openspec/specs/restore/spec.md` § *A folder that
                        // already holds a copy asks to restore it before it becomes the copy
                        // place*: replacing restores nothing and makes that folder the copy
                        // place instead.
                        if awaitingRestoreFromCopyPlacePick {
                            Section {
                                Button("Replace it with this phone's", role: .destructive) {
                                    screen.replaceTheCopyAtTheFolderGiven()
                                    awaitingRestoreFromCopyPlacePick = false
                                    pendingCopyPlaceFolderName = nil
                                }
                            } footer: {
                                Text(
                                    "The copy in \(pendingCopyPlaceFolderName ?? "the folder") is overwritten now, and \(pendingCopyPlaceFolderName ?? "the folder") becomes the copy place."
                                )
                            }
                        }
                    }
                    .navigationTitle("Restore this copy?")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                screen.cancelRestoring()
                                awaitingRestoreFromCopyPlacePick = false
                                pendingCopyPlaceFolderName = nil
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Restore", role: .destructive) {
                                screen.confirmRestoring()
                                awaitingRestoreFromCopyPlacePick = false
                                pendingCopyPlaceFolderName = nil
                            }
                        }
                    }
                }
            }
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
    let canChangeMoreThanNameAndCategory: Bool
    /// Whether the sheet draws a *Restart* section — `true` only where `changing` is a
    /// commitment `screen.whatItIsMadeOf` says can be restarted.
    /// `openspec/changes/add-interval-restart/design.md` § *The shell rides this Story*.
    let canRestart: Bool
    /// The day `changing` is kept from, the *Restart* date picker's lower bound. Read once, at
    /// init, from `screen.whatItIsMadeOf` — not the "Kept from" field above, which is a person's
    /// typed correction to the rhythm form and not the commitment's own unchanging day.
    private let restartLowerBound: Date

    @State private var name: String
    @State private var category: String
    /// Whether the category control is showing the *New…* text field rather than the menu of
    /// categories in use — `chore/reshape-commitment-sheet`. Starts `true` only when the
    /// category this sheet opened with is not one the menu would offer, so its word is still
    /// visible rather than silently dropped.
    @State private var enteringNewCategory: Bool
    @State private var rhythmKind: RhythmKind
    @State private var selectedWeekdays: Set<Weekday>
    @State private var dayOfMonth: Int
    @State private var intervalDays: Int
    @State private var timesPerWeek: Int
    @State private var keptFromDate: Date
    @State private var kindChoice: CommitmentsScreen.KindChoice
    @State private var lowest: String
    @State private var highest: String
    @State private var target: String
    @State private var restartDate: Date
    @Environment(\.dismiss) private var dismiss

    /// `commitment` is `nil` to define a new commitment, and the one to change otherwise. Every
    /// field starts from `screen.whatItIsMadeOf(commitment)` in the second case — the rhythm and
    /// the day kept from included, whether or not `canChangeMoreThanNameAndCategory` then lets a thumb
    /// into them — and from an empty form kept from `screen.dayToKeepFrom` in the first.
    init(screen: CommitmentsScreen, changing commitment: Commitment?) {
        self.screen = screen
        self.changing = commitment

        let madeOf = commitment.flatMap { screen.whatItIsMadeOf($0) }
        canChangeMoreThanNameAndCategory = madeOf?.canChangeMoreThanNameAndCategory ?? true
        canRestart = madeOf?.canRestart ?? false
        restartLowerBound = date(from: madeOf?.keptFrom ?? screen.dayToKeepFrom)

        _name = State(initialValue: madeOf?.name ?? "")
        let initialCategory = madeOf?.category ?? ""
        _category = State(initialValue: initialCategory)
        _enteringNewCategory = State(
            initialValue: !initialCategory.isEmpty
                && !screen.categoriesInUse.contains(initialCategory))
        _keptFromDate = State(initialValue: date(from: madeOf?.keptFrom ?? screen.dayToKeepFrom))
        _restartDate = State(initialValue: date(from: screen.dayToKeepFrom))

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
            _selectedWeekdays = State(initialValue: screen.weekdaysToOffer)
            _dayOfMonth = State(initialValue: 1)
            _intervalDays = State(initialValue: 1)
            _timesPerWeek = State(initialValue: 1)
        }

        if let kind = madeOf?.kind {
            // Changing: the picker and the three fields are shown, filled from the kind
            // `whatItIsMadeOf(_:)` says, and never let a thumb in — a kind is set when a
            // commitment is defined and never changes. `design.md` § *The seam*.
            switch kind {
            case .tick:
                _kindChoice = State(initialValue: .tick)
                _lowest = State(initialValue: "")
                _highest = State(initialValue: "")
                _target = State(initialValue: "")
            case .number(let range):
                _kindChoice = State(initialValue: .number)
                _lowest = State(initialValue: range.map { "\($0.lowest)" } ?? "")
                _highest = State(initialValue: range.map { "\($0.highest)" } ?? "")
                _target = State(initialValue: "")
            case .note:
                _kindChoice = State(initialValue: .note)
                _lowest = State(initialValue: "")
                _highest = State(initialValue: "")
                _target = State(initialValue: "")
            case .total(let target):
                _kindChoice = State(initialValue: .total)
                _lowest = State(initialValue: "")
                _highest = State(initialValue: "")
                _target = State(initialValue: "\(target.amount)")
            }
        } else {
            // Defining: the kind offered for a new commitment is always the tick, and the three
            // fields start empty — nothing has been typed into them yet.
            _kindChoice = State(initialValue: screen.kindToOffer)
            _lowest = State(initialValue: "")
            _highest = State(initialValue: "")
            _target = State(initialValue: "")
        }
    }

    /// The refusal `screen.sheetRefusal` is telling under `field`, or `nil` where it is telling
    /// under a different field, telling nothing at all, or `field` names the foot (`nil`) and
    /// `sheetRefusal` is about a named field instead. `design.md` § *The seam*: the sheet draws,
    /// the kit decides.
    private func sheetRefusal(under field: CommitmentsScreen.SheetField?) -> CommitmentsScreen.Refusal?
    {
        guard let sheetRefusal = screen.sheetRefusal, sheetRefusal.field == field else {
            return nil
        }
        return sheetRefusal.refusal
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .onChange(of: name) { _, _ in screen.sheetFieldEdited(.name) }

                    if let nameRefusal = sheetRefusal(under: .name) {
                        refusalText(nameRefusal)
                    }

                    Picker("Kind", selection: $kindChoice) {
                        ForEach(CommitmentsScreen.KindChoice.allCases, id: \.self) { kind in
                            Text(kindChoiceName(kind)).tag(kind)
                        }
                    }
                    .disabled(changing != nil)

                    // Plain `TextField`s bound to `String`: no formatter, no `keyboardType` that
                    // forbids a minus or a separator, and nothing that blocks a character — this
                    // screen says "that is not a number" out loud rather than the shell silently
                    // refusing the keystroke. `design.md` § *One reading of a typed number*.
                    switch kindChoice {
                    case .tick, .note:
                        EmptyView()
                    case .number:
                        HStack {
                            TextField("Lowest", text: $lowest)
                                .onChange(of: lowest) { _, _ in screen.sheetFieldEdited(.range) }
                            TextField("Highest", text: $highest)
                                .onChange(of: highest) { _, _ in screen.sheetFieldEdited(.range) }
                        }
                        .disabled(!canChangeMoreThanNameAndCategory)
                        // `TextField`, unlike `Picker`/`Toggle`/`Stepper`/`DatePicker` above and
                        // below, does not grey its own text on `.disabled` — say so explicitly,
                        // matching the `Color.primary`/`Color.secondary` pair the category label
                        // already draws in.
                        .foregroundStyle(canChangeMoreThanNameAndCategory ? Color.primary : Color.secondary)

                        if let rangeRefusal = sheetRefusal(under: .range) {
                            refusalText(rangeRefusal)
                        }
                    case .total:
                        TextField("Target", text: $target)
                            .onChange(of: target) { _, _ in screen.sheetFieldEdited(.target) }
                            .disabled(!canChangeMoreThanNameAndCategory)
                            .foregroundStyle(canChangeMoreThanNameAndCategory ? Color.primary : Color.secondary)

                        if let targetRefusal = sheetRefusal(under: .target) {
                            refusalText(targetRefusal)
                        }
                    }

                    // The category control, drawn as a row matching `Kind` above rather than the
                    // accent-blue link it used to render as below `Kept from` —
                    // `chore/commitments-layout`. Same `Menu`, same items, same "New…" swap into
                    // the text field; only where it sits and how its label reads changed.
                    if enteringNewCategory {
                        TextField("New category", text: $category)
                    } else {
                        Menu {
                            ForEach(screen.categoriesInUse, id: \.self) { existing in
                                Button(existing) {
                                    category = existing
                                }
                            }
                            Button("New…") {
                                category = ""
                                enteringNewCategory = true
                            }
                        } label: {
                            HStack {
                                // `Color.primary`/`Color.secondary`, not the hierarchical
                                // `.primary`/`.secondary` shape styles: a `Menu`'s label sits in
                                // an ambient tint (accentColor) context, so the hierarchical
                                // styles resolve relative to *that* — solid and faded blue,
                                // measured on device — rather than to the system's actual label
                                // colours. The absolute `Color` values are what `Kind` and
                                // `Rhythm` above draw in.
                                Text(category.isEmpty ? "Category (optional)" : category)
                                    .foregroundStyle(Color.primary)
                                Spacer()
                                Image(systemName: "chevron.up.chevron.down")
                                    .foregroundStyle(Color.secondary)
                            }
                        }
                    }
                }

                // What a commitment runs on, together: the rhythm, the control it selects, and
                // the day it is kept from — `chore/commitments-layout`. A second `Section` says
                // so without a word; every refusal still sits directly under the field it names
                // (#261), and the foot refusal closes this card.
                Section {
                    Picker("Rhythm", selection: $rhythmKind) {
                        ForEach(RhythmKind.allCases) { kind in
                            Text(kind.rawValue).tag(kind)
                        }
                    }
                    .disabled(!canChangeMoreThanNameAndCategory)
                    .onChange(of: rhythmKind) { _, newValue in
                        screen.sheetFieldEdited(.rhythm)
                        // A rhythm switched onto weekdays with nothing behind its chips starts
                        // from every weekday offered — `design.md` § *The weekdays offered are
                        // their own requirement*. Switching away and back leaves a non-empty set
                        // exactly as it was.
                        if newValue == .weekdays, selectedWeekdays.isEmpty {
                            selectedWeekdays = screen.weekdaysToOffer
                        }
                    }

                    switch rhythmKind {
                    case .weekdays:
                        HStack(spacing: 4) {
                            ForEach(allWeekdays, id: \.self) { weekday in
                                Toggle(
                                    weekdayShortName(weekday),
                                    isOn: Binding(
                                        get: { selectedWeekdays.contains(weekday) },
                                        set: { isOn in
                                            if isOn {
                                                selectedWeekdays.insert(weekday)
                                            } else {
                                                selectedWeekdays.remove(weekday)
                                            }
                                        }
                                    )
                                )
                                .toggleStyle(.button)
                                .fixedSize()
                            }
                        }
                        .controlSize(.small)
                        .disabled(!canChangeMoreThanNameAndCategory)
                        .onChange(of: selectedWeekdays) { _, _ in screen.sheetFieldEdited(.rhythm) }
                    case .dayOfMonth:
                        Picker("Day", selection: $dayOfMonth) {
                            ForEach(1...31, id: \.self) { day in
                                Text("\(day)").tag(day)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 150)
                        .disabled(!canChangeMoreThanNameAndCategory)
                        .onChange(of: dayOfMonth) { _, _ in screen.sheetFieldEdited(.rhythm) }
                    case .everyNDays:
                        LabeledContent("Every") {
                            HStack {
                                TextField("Days", value: $intervalDays, format: .number)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 44)
                                    .onChange(of: intervalDays) { _, _ in
                                        screen.sheetFieldEdited(.rhythm)
                                    }
                                Text("day(s)")
                            }
                        }
                        .disabled(!canChangeMoreThanNameAndCategory)
                    case .weeklyQuota:
                        Stepper("\(timesPerWeek) time(s) a week", value: $timesPerWeek, in: 1...7)
                            .disabled(!canChangeMoreThanNameAndCategory)
                            .onChange(of: timesPerWeek) { _, _ in screen.sheetFieldEdited(.rhythm) }
                    }

                    if let rhythmRefusal = sheetRefusal(under: .rhythm) {
                        refusalText(rhythmRefusal)
                    }

                    DatePicker("Kept from", selection: $keptFromDate, displayedComponents: [.date])
                        .disabled(!canChangeMoreThanNameAndCategory)
                        .onChange(of: keptFromDate) { _, _ in screen.sheetFieldEdited(.keptFrom) }

                    if let keptFromRefusal = sheetRefusal(under: .keptFrom) {
                        refusalText(keptFromRefusal)
                    }

                    if let footRefusal = sheetRefusal(under: nil) {
                        refusalText(footRefusal)
                    }
                }

                if canRestart, let commitment = changing {
                    Section("Restart") {
                        // `restartDateRange` is `nil` for a commitment kept from a day after
                        // today — a future kept-from day the spec allows, and `canRestart` says
                        // nothing against. A `ClosedRange` built from that pair would trap, so
                        // the picker goes unbounded instead of hiding the section: `design.md`
                        // § *The shell rides this Story* calls the bounds "only a convenience"
                        // — the kit's own `restart` still refuses whatever the picker would have
                        // ruled out.
                        if let restartDateRange {
                            DatePicker(
                                "Restart from", selection: $restartDate, in: restartDateRange,
                                displayedComponents: [.date])
                        } else {
                            DatePicker(
                                "Restart from", selection: $restartDate,
                                displayedComponents: [.date])
                        }
                        if let restartDayRefusal = sheetRefusal(under: .restartDay) {
                            refusalText(restartDayRefusal)
                        }
                        Button("Restart") {
                            restart(commitment)
                        }
                    }
                    .onChange(of: restartDate) { _, _ in screen.sheetFieldEdited(.restartDay) }
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
        // Every dismiss path — Cancel, a swipe down, and the `dismiss()` a kept save or restart
        // calls below — ends with this sheet disappearing exactly once, so this is the one place
        // that needs to tell the screen the sheet closed. `openspec/specs/commitment/spec.md` §
        // *What a commitments screen tells on its sheet lasts until…*.
        .onDisappear {
            screen.sheetClosed()
        }
    }

    /// The *Restart* date picker's bounds — `restartLowerBound` through `screen.dayToKeepFrom` —
    /// or `nil` where `restartLowerBound` falls after `screen.dayToKeepFrom`: a commitment kept
    /// from a day after today, which `canRestart` still allows. `nil` here means the picker goes
    /// unbounded rather than forming a `ClosedRange` that would trap.
    private var restartDateRange: ClosedRange<Date>? {
        let upperBound = date(from: screen.dayToKeepFrom)
        guard restartLowerBound <= upperBound else {
            return nil
        }
        return restartLowerBound...upperBound
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

        let refusal: CommitmentsScreen.Refusal?
        if let commitment = changing {
            // A change never sends the kind picker — set when a commitment is defined, it never
            // changes — but does send the range or the target field beside it, exactly as they
            // are prefilled and, on a kept commitment, taken a thumb to.
            // `openspec/changes/change-range-and-target/design.md` § *The seam*.
            refusal = screen.change(
                commitment, toName: name, on: rhythmBeingBuilt, keptFrom: keptFrom,
                under: category.isEmpty ? nil : category, lowest: lowest, highest: highest,
                target: target)
        } else {
            refusal = screen.define(
                name: name, on: rhythmBeingBuilt, keptFrom: keptFrom,
                under: category.isEmpty ? nil : category, kind: kindChoice, lowest: lowest,
                highest: highest, target: target)
        }

        if refusal == nil {
            dismiss()
        }
    }

    /// Hands `restartDate`, converted the same way `save()` converts `keptFromDate`, to
    /// `screen.restart(commitment:from:)`. Dismisses on a restart kept; stays open with the day
    /// picked exactly as it was and says why on a refusal.
    /// `openspec/changes/add-interval-restart/design.md` § *The shell rides this Story*.
    private func restart(_ commitment: Commitment) {
        let components = Calendar.current.dateComponents(
            [.year, .month, .day], from: restartDate)
        guard
            let day = CalendarDate(
                year: components.year!, month: components.month!, day: components.day!)
        else { return }

        let refusal = screen.restart(commitment, from: day)

        if refusal == nil {
            dismiss()
        }
    }
}
