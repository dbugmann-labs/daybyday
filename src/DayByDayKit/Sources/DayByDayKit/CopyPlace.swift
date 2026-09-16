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

    /// The three reasons a copy cannot be made at the copy place — `design.md` § *The seam*.
    public enum Stop: Hashable, Sendable {
        case folderCannotBeReached
        case folderCannotBeWritten
        case storeCouldNotBeRead(Copy.Store)
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
        let bookmark = try? folder.bookmarkData()
        self.folder = Folder(path: folder.path, name: folder.lastPathComponent, bookmark: bookmark)
        self.folderName = folder.lastPathComponent
        self.lastCopy = nil
        self.stopped = nil
        persist()

        guard let moment = momentNow() else {
            return
        }
        attemptCopy(into: folder, asOf: moment)
    }

    /// A change has been kept at the record place, the roster place or the one-off place. Writes
    /// a copy at the copy place where one is set; does nothing where none is.
    func keptAChange() {
        guard folder != nil else {
            return
        }
        guard let moment = momentNow() else {
            return
        }
        guard let resolved = resolvedFolder() else {
            stop(.folderCannotBeReached, asOf: moment)
            return
        }
        attemptCopy(into: resolved, asOf: moment)
    }

    /// Reads the file named `Self.fileName` in `folder`, answering `nil` where there is none,
    /// `.success` where it reads as a copy, and `.failure` where it does not — `design.md` § *A
    /// folder holding a copy that cannot be read is refused as a copy place*.
    func copyHeldIn(_ folder: URL) -> Result<Copy, CommitmentsScreen.Refusal>? {
        let file = folder.appendingPathComponent(Self.fileName)
        guard let data = try? Data(contentsOf: file) else {
            return nil
        }
        return CopyDocument.read(data)
    }

    /// Forms a copy of the record, the roster and the one-offs kept at `recordAt`, `rosterAt` and
    /// `oneOffsAt`, as of `moment` — reading the three places fresh, undoing a torn restore and
    /// then a torn save first, exactly as `CommitmentsScreen.makeACopy` reads them.
    /// `openspec/specs/restore/spec.md` § *A copy is what the three places hold, read when it is
    /// asked for*.
    static func form(
        recordAt: URL, rosterAt: URL, oneOffsAt: URL, asOf moment: Moment
    ) -> Result<Copy, CommitmentsScreen.Refusal> {
        let read = readStores(recordAt: recordAt, rosterAt: rosterAt, oneOffsAt: oneOffsAt)
        guard let record = read.record, let roster = read.roster, let oneOffs = read.oneOffs else {
            return .failure(.storeCouldNotBeRead)
        }
        return .success(
            Copy(moment: moment, history: record.history, roster: roster.roster, oneOffs: oneOffs.oneOffs))
    }

    /// What reading the three stores comes back as, each opened independently — mirrors
    /// `CommitmentsScreen`'s own private `StoresRead`, kept separate so this copy place never
    /// reaches into that screen's internals for it.
    private struct StoresRead {
        let record: RecordStore?
        let roster: RosterStore?
        let oneOffs: OneOffStore?

        var unreadable: [Copy.Store] {
            var result: [Copy.Store] = []
            if record == nil { result.append(.record) }
            if roster == nil { result.append(.roster) }
            if oneOffs == nil { result.append(.oneOffs) }
            return result
        }
    }

    private static func readStores(
        recordAt recordPlace: URL, rosterAt rosterPlace: URL, oneOffsAt oneOffPlace: URL
    ) -> StoresRead {
        guard
            RestoreInProgress.undoTornRestore(
                recordAt: recordPlace, rosterAt: rosterPlace, oneOffsAt: oneOffPlace),
            SaveInProgress.undoTornSave(recordAt: recordPlace, rosterAt: rosterPlace)
        else {
            return StoresRead(record: nil, roster: nil, oneOffs: nil)
        }
        return StoresRead(
            record: try? RecordStore(at: recordPlace), roster: try? RosterStore(at: rosterPlace),
            oneOffs: try? OneOffStore(at: oneOffPlace))
    }

    /// Forms a copy of this copy place's own three places as of `moment`, and writes it into
    /// `folder`, updating `lastCopy` and `stopped` from the result. A store that cannot be read
    /// stops as `.storeCouldNotBeRead`, naming the first store `readStores` found unreadable; a
    /// folder that cannot be written stops as `.folderCannotBeWritten`. Either way this screen's
    /// change is already kept — this never throws and never refuses anything to a caller.
    private func attemptCopy(into folder: URL, asOf moment: Moment) {
        let read = Self.readStores(
            recordAt: recordPlace, rosterAt: rosterPlace, oneOffsAt: oneOffPlace)
        guard let record = read.record, let roster = read.roster, let oneOffs = read.oneOffs else {
            stop(.storeCouldNotBeRead(read.unreadable.first ?? .record), asOf: moment)
            return
        }

        let copy = Copy(
            moment: moment, history: record.history, roster: roster.roster, oneOffs: oneOffs.oneOffs)

        do {
            let document = CopyDocument(copy)
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys]
            let data = try encoder.encode(document)

            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            let file = folder.appendingPathComponent(Self.fileName)
            try data.write(to: file, options: .atomic)
        } catch {
            stop(.folderCannotBeWritten, asOf: moment)
            return
        }

        lastCopy = moment
        stopped = nil
        persist()
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

    /// The folder this copy place is kept at, resolved from what was last persisted — the
    /// bookmark first, falling back to the plain path, `design.md` § *The folder is bookmark data
    /// beside its path*. `nil` where no folder is set, or the one set cannot be found: gone,
    /// moved, or access to it taken away.
    private func resolvedFolder() -> URL? {
        guard let folder else {
            return nil
        }

        if let bookmark = folder.bookmark {
            var isStale = false
            if let url = try? URL(resolvingBookmarkData: bookmark, bookmarkDataIsStale: &isStale),
                !isStale, Self.isDirectory(url)
            {
                return url
            }
        }

        let url = URL(fileURLWithPath: folder.path, isDirectory: true)
        guard Self.isDirectory(url) else {
            return nil
        }
        return url
    }

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
