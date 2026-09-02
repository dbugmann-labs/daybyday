import Foundation

/// A history kept at a place, across the app being closed and opened again. See
/// `openspec/specs/record/spec.md` for the behaviour contract and this change's `design.md` for
/// why the seam is shaped this way.
public final class RecordStore {
    private let place: URL

    /// Mirrors exactly what `history` holds. `History` keeps its own ticks private by design (see
    /// `RecordDocument.swift`), so the store keeps this alongside it — the one thing a write needs
    /// that `history` itself cannot give back out.
    private var ticks: Set<Tick>

    /// Opens the store kept at `place`, reading what is there. A place where nothing has been
    /// kept opens empty; a place holding something that cannot be read as a store throws.
    public init(at place: URL) throws {
        self.place = place

        guard FileManager.default.fileExists(atPath: place.path) else {
            self.ticks = []
            self.history = History()
            return
        }

        let data = try Data(contentsOf: place)

        guard let envelope = try? JSONDecoder().decode(RecordDocumentEnvelope.self, from: data) else {
            throw RecordStoreError.notAStore(at: place)
        }
        guard envelope.version <= RecordDocument.currentVersion else {
            throw RecordStoreError.laterForm(at: place, version: envelope.version)
        }
        guard let document = try? JSONDecoder().decode(RecordDocument.self, from: data),
            let ticks = document.formTicks()
        else {
            throw RecordStoreError.notAStore(at: place)
        }

        self.ticks = ticks
        var history = History()
        for tick in ticks {
            history.add(tick)
        }
        self.history = history
    }

    /// Every tick added and not since taken back — exactly what is kept at `place`.
    public private(set) var history: History

    /// Kept at `place` before this returns; on failure throws and leaves `history` as it was.
    public func add(_ tick: Tick) throws {
        var nextTicks = ticks
        nextTicks.insert(tick)
        try write(nextTicks)

        ticks = nextTicks
        history.add(tick)
    }

    public func remove(_ tick: Tick) throws {
        fatalError("not implemented")
    }

    private func write(_ ticks: Set<Tick>) throws {
        let document = RecordDocument(ticks)
        let data = try JSONEncoder().encode(document)

        do {
            try FileManager.default.createDirectory(
                at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
            try data.write(to: place, options: .atomic)
        } catch {
            throw RecordStoreError.cannotWrite(at: place)
        }
    }
}

public enum RecordStoreError: Error, Equatable, Sendable {
    /// What is at `place` is not a store this app can read, or holds what could not be a tick.
    case notAStore(at: URL)
    /// A store in a form later than this app writes; `version` is the form found.
    case laterForm(at: URL, version: Int)
    /// The change could not be kept at `place`; nothing was held.
    case cannotWrite(at: URL)
}
