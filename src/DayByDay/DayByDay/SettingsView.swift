import Foundation
import SwiftUI
import UIKit
import UniformTypeIdentifiers
import DayByDayKit

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
        case (.birthdayTicks, .storeWrittenByALaterVersion):
            Text("Your birthday ticks were written by a newer version of DayByDay.")
        case (.happenings, .storeWrittenByALaterVersion):
            Text("Your happenings were written by a newer version of DayByDay.")
        case (.record, _):
            Text("Your record could not be read.")
        case (.roster, _):
            Text("Your roster could not be read.")
        case (.oneOffs, _):
            Text("Your one-offs could not be read.")
        case (.birthdayTicks, _):
            Text("Your birthday ticks could not be read.")
        case (.happenings, _):
            Text("Your happenings could not be read.")
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
            case (.birthdayTicks, .couldNotBeRead):
                Text("Your birthday ticks could not be read.")
            case (.birthdayTicks, .writtenByALaterVersion):
                Text("Your birthday ticks were written by a newer version of DayByDay.")
            case (.happenings, .couldNotBeRead):
                Text("Your happenings could not be read.")
            case (.happenings, .writtenByALaterVersion):
                Text("Your happenings were written by a newer version of DayByDay.")
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
        case .birthdayTicks:
            Text("The birthday ticks could not be taken out.")
        case .happenings:
            Text("The happenings could not be taken out.")
        case nil:
            Text("That folder could not be written.")
        }
    }
    .font(.caption)
    .foregroundStyle(.red)
}

/// The words a person reads for one side of a restore's counts — a copy's own, or the phone's —
/// naming what each of `unreadable`'s stores says in place of the count it would otherwise give:
/// the roster's kept and stopped counts together, the one-offs' count on its own, the happenings'
/// two counts together, and the record and the birthday ticks named on their own though they give
/// no count at all. `design.md` § *The shell*: "a line of counts
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
        if unreadable.contains(.birthdayTicks) {
            Text("Your birthday ticks could not be read.")
        }
        if unreadable.contains(.happenings) {
            Text("Your happenings could not be read.")
        } else {
            Text(
                "\(counts.happenings ?? 0) happening(s), has stopped \(counts.stoppedHappenings ?? 0)"
            )
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
/// `SettingsView` can hand them to the platform's share sheet. `design.md` § *The shell*:
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
    case .storeCouldNotBeRead(.birthdayTicks):
        "your birthday ticks could not be read"
    case .storeCouldNotBeRead(.happenings):
        "your happenings could not be read"
    case .storeWrittenByALaterVersion(.record):
        "your record was written by a newer version of DayByDay"
    case .storeWrittenByALaterVersion(.roster):
        "your roster was written by a newer version of DayByDay"
    case .storeWrittenByALaterVersion(.oneOffs):
        "your one-offs were written by a newer version of DayByDay"
    case .storeWrittenByALaterVersion(.birthdayTicks):
        "your birthday ticks were written by a newer version of DayByDay"
    case .storeWrittenByALaterVersion(.happenings):
        "your happenings were written by a newer version of DayByDay"
    }
}

/// The URL the last copy made answered, wrapped so `.sheet(item:)` can drive the share sheet
/// directly, since a `URL` alone is not `Identifiable` for that.
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
/// Settings, reached from the day screen's toolbar: everything that once sat below the lists on
/// the Commitments screen — the copy place, the birthday switch, making, taking out and restoring
/// a copy — and the app's version. Draws what `screen` and `birthdaySwitch` already say and adds
/// no rule of its own (ADR-1019); `openspec/changes/add-settings-screen/design.md` § *The shell*.
struct SettingsView: View {
    let screen: CommitmentsScreen
    let birthdaySwitch: BirthdaySwitch

    @Environment(\.dismiss) private var dismiss
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

    /// The version and build the app's bundle carries, as "Version 1.0 (1)" — the shell's own, since
    /// the Kit cannot read a bundle.
    private var versionText: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? ""
        let build = info?["CFBundleVersion"] as? String ?? ""
        return "Version \(version) (\(build))"
    }

    var body: some View {
        NavigationStack {
            List {
                // The copy place, directly above its last-copy line — `CONTEXT.md` § *Copy place*.
                // The row is a plain `Button` that draws its chevron by hand, as it did on the
                // Commitments screen.
                Section {
                    Button {
                        isPickingCopyPlaceFolder = true
                    } label: {
                        HStack {
                            LabeledContent(
                                "Copy place", value: screen.copyPlace?.folderName ?? "Pick a folder")
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
                } footer: {
                    VStack(alignment: .leading, spacing: 2) {
                        if let copyPlace = screen.copyPlace, copyPlace.folderName != nil {
                            // `copyPlace.set(to:)` always attempts a copy the moment a folder is
                            // given, so a last copy or a stop stands beside a folder's name —
                            // never neither.
                            if let lastCopy = copyPlace.lastCopy {
                                Text("Last copy \(momentText(lastCopy))")
                            }
                            if let stopped = copyPlace.stopped {
                                Text(
                                    "Stopped since \(momentText(stopped.since)): \(copyPlaceStopText(stopped.stop))"
                                )
                                .foregroundStyle(.red)
                            }
                        } else {
                            Text("Pick a folder to keep a copy there.")
                        }
                        if let refusedCopyPlace = screen.refusedCopyPlace {
                            refusalText(refusedCopyPlace)
                        }
                    }
                    .font(.caption)
                }

                // The birthday switch: draws only what `birthdaySwitch` says; turning it on runs
                // `turnOn()` in a `Task`, and the refused line and its button show only while it
                // says it is refused. The switch takes the app's tint rather than system green.
                Section {
                    Toggle(
                        "Birthdays",
                        isOn: Binding(
                            get: { birthdaySwitch.isOn },
                            set: { isOn in
                                if isOn {
                                    Task { await birthdaySwitch.turnOn() }
                                } else {
                                    birthdaySwitch.turnOff()
                                }
                            }
                        )
                    )
                    .tint(.accentColor)
                } footer: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Birthdays from your phone's calendar, on the day they fall.")
                        if birthdaySwitch.isRefused {
                            Text("Calendar access is off for DayByDay, so birthdays can't be read.")
                            Button("Open iPhone Settings") {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }
                    }
                    .font(.caption)
                }

                Section {
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

                    // Drawn only while a store cannot be read or is from a newer version.
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
                }

                Section {
                } footer: {
                    Text(versionText)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .listSectionSpacing(12)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
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
        .presentationDetents([.large])
    }
}
