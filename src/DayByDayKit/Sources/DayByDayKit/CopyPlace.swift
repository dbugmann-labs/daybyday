import Foundation

/// The one folder a person picks for the app to keep a mirror of itself in, and the copy written
/// there after every change a person keeps. See `openspec/specs/restore/spec.md` for the
/// behaviour contract and `openspec/changes/copy-on-every-change/design.md` § *The seam* for why
/// the surface is shaped this way. Holds nothing of the record, the roster or the one-offs
/// themselves — only where the copy place is, the moment of the last copy written there and, where
/// the last attempt failed, why and since when.
@MainActor
@Observable
public final class CopyPlace {
    /// The place a copy place keeps its own state when it is not told another: a file of its own
    /// under the platform's application-support directory, beside the record, the roster and the
    /// one-off places but none of the three itself. `design.md` § *Migration*.
    public static var place: URL {
        let applicationSupport = FileManager.default.urls(
            for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return applicationSupport
            .appendingPathComponent("DayByDay", isDirectory: true)
            .appendingPathComponent("copy-place.json")
    }

    /// The name a copy is written under, in the folder that is the copy place — a fixed name,
    /// overwritten whole by every copy. `design.md` § Settled 1.
    static let fileName = "DayByDay.daybyday"

    private let statePlace: URL
    private let recordPlace: URL
    private let rosterPlace: URL
    private let oneOffPlace: URL
    private let momentNow: @Sendable () -> Moment?

    /// The folder this copy place is kept at, and enough to find it again across the app being
    /// closed: its path, its name, and a bookmark to resolve it by where the path alone no longer
    /// answers. `design.md` § *The folder is bookmark data beside its path*.
    private struct Folder: Hashable {
        let path: String
        let name: String
        let bookmark: Data?
    }

    private var folder: Folder?

    /// The name of the folder this copy place is kept at, or `nil` where no folder has ever been
    /// given. Read from what was last persisted, never by resolving or reading the folder itself
    /// — `openspec/specs/restore/spec.md` § *A commitments screen says its copy place, the last
    /// copy made there and a stop*.
    public private(set) var folderName: String?

    /// The moment of the last copy successfully written at the copy place, or `nil` where none
    /// has ever been.
    public private(set) var lastCopy: Moment?

    /// Why the last attempt to write a copy at the copy place failed, and the moment that failure
    /// began — `nil` where the last attempt succeeded, or none has ever been made.
    public private(set) var stopped: Stopped?

    /// The four reasons a copy cannot be made at the copy place — `design.md` § *The seam*.
    public enum Stop: Hashable, Sendable {
        case folderCannotBeReached
        case folderCannotBeWritten
        case storeCouldNotBeRead(Copy.Store)
        /// A store was written by a later version of DayByDay while forming the copy the copy
        /// place writes on its own — told apart from `storeCouldNotBeRead` rather than folded
        /// into it. `design.md` § *The later-version cause is said wherever the store is named*.
        case storeWrittenByALaterVersion(Copy.Store)
    }

    /// A stop standing at the copy place: which of the three it is, and the moment it began.
    /// `since` stands from the first failure of an unbroken run, whatever each failure's own
    /// reason — a copy made ends it.
    public struct Stopped: Hashable, Sendable {
        public let stop: Stop
        public let since: Moment
    }

    /// Opens the copy place kept at `place`, reading what is there — no folder, no last copy and
    /// no stop where nothing has ever been kept. Forms a copy by reading the record kept at
    /// `keepingRecordAt`, the roster kept at `keepingRosterAt` and the one-offs kept at
    /// `keepingOneOffsAt`, defaulting to exactly the places a day screen keeps them.
    /// `momentNow` is the clock a copy's moment is stamped from, asked once per copy written.
    public init(
        at place: URL = CopyPlace.place, keepingRecordAt recordPlace: URL = DayScreen.recordPlace,
        keepingRosterAt rosterPlace: URL = DayScreen.rosterPlace,
        keepingOneOffsAt oneOffPlace: URL = DayScreen.oneOffPlace,
        asking momentNow: @escaping @Sendable () -> Moment?
    ) {
        self.statePlace = place
        self.recordPlace = recordPlace
        self.rosterPlace = rosterPlace
        self.oneOffPlace = oneOffPlace
        self.momentNow = momentNow

        let read = Self.readState(at: place)
        self.folder = read.folder
        self.folderName = read.folder?.name
        self.lastCopy = read.lastCopy
        self.stopped = read.stopped
    }

    /// Forgets the copy place: afterwards no folder, no last copy and no stop stand, here or read
    /// back by a copy place opened again at the same place. Writes nothing at the record place,
    /// the roster place or the one-off place, and leaves the file at the folder it forgot exactly
    /// as it is. Does nothing where no folder is set.
    public func forget() {
        guard folder != nil else {
            return
        }
        folder = nil
        folderName = nil
        lastCopy = nil
        stopped = nil
        persist()
    }

    /// Makes `folder` the copy place, replacing whatever was there — the file at the folder it
    /// replaces, if any, is left exactly as it is. Writes a copy there at once, as of the moment
    /// this copy place's clock then answers: where that copy is written, its moment becomes the
    /// last copy and no stop stands; where it cannot be, the folder still becomes the copy place,
    /// no last copy stands, and the stop is held as of that moment. `design.md` § *One copy place,
    /// handed to both screens*.
    func set(to folder: URL) {
        // The directory must exist before it is bookmarked — `bookmarkData()` throws for a path
        // nothing stands at yet. A folder a person picked through the document picker already
        // exists; this only matters where it does not, and is a harmless no-op otherwise.
        Self.withSecurityScopedAccess(to: folder) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        // `.minimalBookmark`, per `design.md` § *The folder is bookmark data beside its path*:
        // the smallest form, and the one `.withSecurityScope` — macOS-only — is not.
        let bookmark = Self.withSecurityScopedAccess(to: folder) {
            try? folder.bookmarkData(options: .minimalBookmark)
        }
        self.folder = Folder(path: folder.path, name: folder.lastPathComponent, bookmark: bookmark)
        self.folderName = folder.lastPathComponent
        self.lastCopy = nil
        self.stopped = nil
        persist()

        guard let moment = momentNow() else {
            return
        }
        Self.withSecurityScopedAccess(to: folder) {
            writeCopy(into: folder, asOf: moment)
        }
    }

    /// A change has been kept at the record place, the roster place or the one-off place. Writes
    /// a copy at the copy place where one is set; does nothing where none is. Tries the bookmark
    /// first, falling back to the plain path — `design.md` § *The folder is bookmark data beside
    /// its path* — holding one security-scoped bracket per candidate from the existence check
    /// through the write, never released in between: a probe made without access answers `false`
    /// for a folder that is there, which once left every copy after a relaunch reporting the
    /// folder unreachable for good.
    func keptAChange() {
        guard let folder else {
            return
        }
        guard let moment = momentNow() else {
            return
        }

        if let bookmark = folder.bookmark {
            var isStale = false
            if let url = try? URL(resolvingBookmarkData: bookmark, bookmarkDataIsStale: &isStale),
                !isStale,
                Self.withSecurityScopedAccess(to: url, { attemptCopyWhereDirectory(url, asOf: moment) })
            {
                return
            }
        }

        let url = URL(fileURLWithPath: folder.path, isDirectory: true)
        if Self.withSecurityScopedAccess(to: url, { attemptCopyWhereDirectory(url, asOf: moment) }) {
            return
        }

        stop(.folderCannotBeReached, asOf: moment)
    }

    /// Tried from inside a security-scoped bracket `keptAChange()` already holds on `url`: `false`
    /// where `url` is not a directory at all, so the caller falls back to another candidate or
    /// reports the folder unreachable; `true` once a copy has been attempted there — written, or
    /// stopped for its own reason — either way because `url` was the right folder to try.
    private func attemptCopyWhereDirectory(_ url: URL, asOf moment: Moment) -> Bool {
        guard Self.isDirectory(url) else {
            return false
        }
        writeCopy(into: url, asOf: moment)
        return true
    }

    /// Reads the file named `Self.fileName` in `folder`, answering `nil` where there is none,
    /// `.success` where it reads as a copy, and `.failure` where it does not — `design.md` § *A
    /// folder holding a copy that cannot be read is refused as a copy place*.
    func copyHeldIn(_ folder: URL) -> Result<Copy, CommitmentsScreen.Refusal>? {
        let file = folder.appendingPathComponent(Self.fileName)
        guard
            let data = Self.withSecurityScopedAccess(to: folder, { try? Data(contentsOf: file) })
        else {
            return nil
        }
        return CopyDocument.read(data)
    }

    /// Forms a copy of the record, the roster and the one-offs kept at `recordAt`, `rosterAt` and
    /// `oneOffsAt`, as of `moment` — reading the three places fresh, undoing a torn restore and
    /// then a torn save first. The one copy-forming path `CommitmentsScreen.makeACopy` and this
    /// copy place's own `writeCopy` both call, per `proposal.md`'s own "the copy forming shared
    /// out of the commitments screen". Answers `notRead` alongside the result rather than leaving a
    /// caller that needs to name which store failed to call `readStores` a second time —
    /// `readStores` is not pure, undoing a torn restore and a torn save as it goes, so a second
    /// call redid that rather than merely re-reading. The refusal names the *first* place `notRead`
    /// holds, in the fixed order record, roster, one-offs: `.storeWrittenByALaterVersion` where
    /// that place's own cause is a later version, `.storeCouldNotBeRead` otherwise — so a record
    /// that cannot be read at all outranks a roster merely written by a later version, exactly as
    /// `openspec/specs/restore/spec.md` § *A copy that cannot be made leaves nothing behind* asks.
    static func form(
        recordAt: URL, rosterAt: URL, oneOffsAt: URL, asOf moment: Moment
    ) -> (result: Result<Copy, CommitmentsScreen.Refusal>, notRead: [CommitmentsScreen.StoreNotRead]) {
        let read = readStores(recordAt: recordAt, rosterAt: rosterAt, oneOffsAt: oneOffsAt)
        guard let record = read.record, let roster = read.roster, let oneOffs = read.oneOffs else {
            let refusal: CommitmentsScreen.Refusal =
                read.notRead.first?.cause == .writtenByALaterVersion
                ? .storeWrittenByALaterVersion : .storeCouldNotBeRead
            return (.failure(refusal), read.notRead)
        }
        return (
            .success(
                Copy(
                    moment: moment, history: record.history, roster: roster.roster,
                    oneOffs: oneOffs.oneOffs)),
            []
        )
    }

    /// What reading the three stores comes back as, each opened independently, `nil` in its own
    /// field exactly where that store could not be read, without stopping at the first — shared by
    /// `form(...)`, which cares only whether all three read, and by `makeACopy` and `askToRestore`,
    /// which name every one that did not. Internal rather than `private`, so `CommitmentsScreen`
    /// reads off this one definition rather than keeping a second of its own.
    struct StoresRead {
        let record: RecordStore?
        let roster: RosterStore?
        let oneOffs: OneOffStore?
        /// Which of the three could not be read, and why, in the fixed order record, roster,
        /// one-offs. `design.md` § *One reading of the three places, carrying the cause*.
        let notRead: [CommitmentsScreen.StoreNotRead]

        /// Which of the three could not be read, in the fixed order record, roster, one-offs —
        /// `AwaitingRestore.unreadable` reads off this: the restore sheet says a count is missing,
        /// not why.
        var unreadable: [Copy.Store] { notRead.map(\.store) }
    }

    /// Opens the record at `place`, telling `.laterForm` apart from every other reason
    /// `RecordStore` can refuse to open — mirrors `DayScreen`'s own `open(at:)`.
    private static func openRecordTellingLaterVersionApart(
        at place: URL
    ) -> (store: RecordStore?, cause: CommitmentsScreen.StoreNotRead.Cause?) {
        do {
            return (try RecordStore(at: place), nil)
        } catch RecordStoreError.laterForm {
            return (nil, .writtenByALaterVersion)
        } catch {
            return (nil, .couldNotBeRead)
        }
    }

    /// Opens the roster at `place`, telling `.laterForm` apart from every other reason
    /// `RosterStore` can refuse to open — mirrors `CommitmentsScreen`'s own opener.
    private static func openRosterTellingLaterVersionApart(
        at place: URL
    ) -> (store: RosterStore?, cause: CommitmentsScreen.StoreNotRead.Cause?) {
        do {
            return (try RosterStore(at: place), nil)
        } catch RosterStoreError.laterForm {
            return (nil, .writtenByALaterVersion)
        } catch {
            return (nil, .couldNotBeRead)
        }
    }

    /// Opens the one-offs at `place`, telling `.laterForm` apart from every other reason
    /// `OneOffStore` can refuse to open — mirrors `DayScreen`'s own `openOneOffs(at:)`.
    private static func openOneOffsTellingLaterVersionApart(
        at place: URL
    ) -> (store: OneOffStore?, cause: CommitmentsScreen.StoreNotRead.Cause?) {
        do {
            return (try OneOffStore(at: place), nil)
        } catch OneOffStoreError.laterForm {
            return (nil, .writtenByALaterVersion)
        } catch {
            return (nil, .couldNotBeRead)
        }
    }

    /// Opens the record, the roster and the one-off store at `recordAt`, `rosterAt` and
    /// `oneOffsAt`, undoing a restore in progress and then a save in progress first, so a torn
    /// restore and a torn save are both undone before either place is read and an earlier-form
    /// store yields a current-form copy. Never carries an orphaned record back: a copy SHALL leave
    /// the three places exactly as it found them, apart from a restore in progress or a save in
    /// progress undone. Where a restore in progress or a save in progress stands and cannot itself
    /// be undone, all three answer not read, each as a place that could not be read, told as the
    /// record — the place both stand beside. `design.md` § *One reading of the three places,
    /// carrying the cause*.
    static func readStores(
        recordAt recordPlace: URL, rosterAt rosterPlace: URL, oneOffsAt oneOffPlace: URL
    ) -> StoresRead {
        guard
            RestoreInProgress.undoTornRestore(
                recordAt: recordPlace, rosterAt: rosterPlace, oneOffsAt: oneOffPlace),
            SaveInProgress.undoTornSave(recordAt: recordPlace, rosterAt: rosterPlace)
        else {
            return StoresRead(
                record: nil, roster: nil, oneOffs: nil,
                notRead: Copy.Store.allCases.map {
                    CommitmentsScreen.StoreNotRead(store: $0, cause: .couldNotBeRead)
                })
        }

        let record = openRecordTellingLaterVersionApart(at: recordPlace)
        let roster = openRosterTellingLaterVersionApart(at: rosterPlace)
        let oneOffs = openOneOffsTellingLaterVersionApart(at: oneOffPlace)

        var notRead: [CommitmentsScreen.StoreNotRead] = []
        if let cause = record.cause {
            notRead.append(CommitmentsScreen.StoreNotRead(store: .record, cause: cause))
        }
        if let cause = roster.cause {
            notRead.append(CommitmentsScreen.StoreNotRead(store: .roster, cause: cause))
        }
        if let cause = oneOffs.cause {
            notRead.append(CommitmentsScreen.StoreNotRead(store: .oneOffs, cause: cause))
        }

        return StoresRead(
            record: record.store, roster: roster.store, oneOffs: oneOffs.store, notRead: notRead)
    }

    /// Writes `copy` into `directory` under `fileName`, creating the directory first where it
    /// does not yet exist, and answers where it was written. Replaces a file of that name already
    /// standing there. Throws where the directory could not be created or the file could not be
    /// written. The one write path `CommitmentsScreen.makeACopy` — which names a file for the
    /// minute the copy was made — and this copy place's own `writeCopy` — which always writes
    /// under `Self.fileName` — both call.
    static func write(_ copy: Copy, into directory: URL, named fileName: String) throws -> URL {
        let document = CopyDocument(copy)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let data = try encoder.encode(document)

        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let url = directory.appendingPathComponent(fileName)
        try data.write(to: url, options: .atomic)
        return url
    }

    /// Runs `body` bracketed by `url.startAccessingSecurityScopedResource()`, stopping only where
    /// starting answered true — `design.md` § *The folder is bookmark data beside its path, and
    /// every write is bracketed*. Apple documents this call as safe on a URL that needs no such
    /// access at all, answering `false` there, so every read and write at the picked folder goes
    /// through this rather than only the ones known to need it.
    private static func withSecurityScopedAccess<T>(to url: URL, _ body: () throws -> T) rethrows -> T {
        let accessing = url.startAccessingSecurityScopedResource()
        defer {
            if accessing {
                url.stopAccessingSecurityScopedResource()
            }
        }
        return try body()
    }

    /// Forms a copy of this copy place's own three places as of `moment`, and writes it into
    /// `url`, updating `lastCopy` and `stopped` from the result. Called from inside a
    /// security-scoped bracket the caller already holds on `url` — `set(to:)`'s own, or one of
    /// `keptAChange()`'s two candidates. A store that cannot be read stops as
    /// `.storeCouldNotBeRead`, naming the first store `readStores` found unreadable; a folder that
    /// cannot be written stops as `.folderCannotBeWritten`. Either way this screen's change is
    /// already kept — this never throws and never refuses anything to a caller.
    private func writeCopy(into url: URL, asOf moment: Moment) {
        let formed = Self.form(
            recordAt: recordPlace, rosterAt: rosterPlace, oneOffsAt: oneOffPlace, asOf: moment)
        switch formed.result {
        case .failure:
            let first = formed.notRead.first
            let store = first?.store ?? .record
            if first?.cause == .writtenByALaterVersion {
                stop(.storeWrittenByALaterVersion(store), asOf: moment)
            } else {
                stop(.storeCouldNotBeRead(store), asOf: moment)
            }
        case .success(let copy):
            do {
                _ = try Self.write(copy, into: url, named: Self.fileName)
                lastCopy = moment
                stopped = nil
                persist()
            } catch {
                stop(.folderCannotBeWritten, asOf: moment)
            }
        }
    }

    /// Holds `reason` as the stop standing at the copy place, keeping `since` from whatever stop
    /// already stood — a later failure, whatever its own reason, leaves the moment the outage
    /// began where it is; only a copy made afterwards ends it. `design.md` § *A copy that cannot
    /// be made on a kept change*.
    private func stop(_ reason: Stop, asOf moment: Moment) {
        let since = stopped?.since ?? moment
        stopped = Stopped(stop: reason, since: since)
        persist()
    }

    /// Whether `url` is a directory that is actually there — called only from inside a
    /// security-scoped bracket already held on `url`, since `fileExists` without that access
    /// answers `false` for a folder that is there. `design.md` § *The folder is bookmark data
    /// beside its path, and every write is bracketed*.
    private static func isDirectory(_ url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) else {
            return false
        }
        return isDirectory.boolValue
    }

    /// What this copy place's own state file holds, on disk.
    private struct StateDocument: Codable {
        var version: Int
        var path: String?
        var name: String?
        var bookmark: Data?
        var lastCopy: MomentRecord?
        var stop: StopRecord?
    }

    /// The wire shape of `Stop`, beside the moment it began.
    private struct StopRecord: Codable {
        var reason: String
        var store: String?
        var since: MomentRecord

        init(_ stopped: Stopped) {
            since = MomentRecord(stopped.since)
            switch stopped.stop {
            case .folderCannotBeReached:
                reason = "folderCannotBeReached"
                store = nil
            case .folderCannotBeWritten:
                reason = "folderCannotBeWritten"
                store = nil
            case .storeCouldNotBeRead(let which):
                reason = "storeCouldNotBeRead"
                switch which {
                case .record: store = "record"
                case .roster: store = "roster"
                case .oneOffs: store = "oneOffs"
                }
            case .storeWrittenByALaterVersion(let which):
                reason = "storeWrittenByALaterVersion"
                switch which {
                case .record: store = "record"
                case .roster: store = "roster"
                case .oneOffs: store = "oneOffs"
                }
            }
        }

        func formStopped() -> Stopped? {
            guard let moment = since.moment() else {
                return nil
            }
            switch reason {
            case "folderCannotBeReached":
                return Stopped(stop: .folderCannotBeReached, since: moment)
            case "folderCannotBeWritten":
                return Stopped(stop: .folderCannotBeWritten, since: moment)
            case "storeCouldNotBeRead":
                let which: Copy.Store
                switch store {
                case "roster": which = .roster
                case "oneOffs": which = .oneOffs
                default: which = .record
                }
                return Stopped(stop: .storeCouldNotBeRead(which), since: moment)
            case "storeWrittenByALaterVersion":
                let which: Copy.Store
                switch store {
                case "roster": which = .roster
                case "oneOffs": which = .oneOffs
                default: which = .record
                }
                return Stopped(stop: .storeWrittenByALaterVersion(which), since: moment)
            default:
                return nil
            }
        }
    }

    /// Reads `place` as a copy place's own state — no folder, no last copy and no stop where
    /// nothing has ever been kept there, or where what is there cannot be read as this state's
    /// own form.
    private static func readState(
        at place: URL
    ) -> (folder: Folder?, lastCopy: Moment?, stopped: Stopped?) {
        guard let data = try? Data(contentsOf: place),
            let document = try? JSONDecoder().decode(StateDocument.self, from: data)
        else {
            return (nil, nil, nil)
        }

        let folder: Folder?
        if let path = document.path, let name = document.name {
            folder = Folder(path: path, name: name, bookmark: document.bookmark)
        } else {
            folder = nil
        }

        return (folder, document.lastCopy?.moment(), document.stop?.formStopped())
    }

    /// Writes this copy place's own state to `statePlace` whole, replacing whatever was there.
    private func persist() {
        let document = StateDocument(
            version: 1, path: folder?.path, name: folder?.name, bookmark: folder?.bookmark,
            lastCopy: lastCopy.map(MomentRecord.init), stop: stopped.map(StopRecord.init))

        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys]
            let data = try encoder.encode(document)
            try FileManager.default.createDirectory(
                at: statePlace.deletingLastPathComponent(), withIntermediateDirectories: true)
            try data.write(to: statePlace, options: .atomic)
        } catch {
            // The copy place's own state file could not be written. Nothing in the delta names a
            // behaviour for this — the in-memory state above is still correct for this run, and a
            // later launch that cannot read it back opens exactly as one that has never kept a
            // copy place, which is the one reading `design.md` § *Migration* gives a phone that
            // has never picked a folder.
        }
    }
}
