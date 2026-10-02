import Foundation

/// Happenings kept at a place, across the app being closed and opened again. See
/// `openspec/changes/add-happening/design.md` § *The seam*; it is `OneOffStore`'s shape.
public final class HappeningStore {
    private let place: URL

    /// Opens the happening store kept at `place`, reading what is there. A place where nothing
    /// has been kept opens holding nothing; a place holding something that cannot be read throws.
    public init(at place: URL) throws {
        self.place = place

        guard FileManager.default.fileExists(atPath: place.path) else {
            self.happenings = Happenings()
            return
        }

        let data = try Data(contentsOf: place)
        guard let envelope = try? JSONDecoder().decode(HappeningDocumentEnvelope.self, from: data)
        else {
            throw HappeningStoreError.notAStore(at: place)
        }
        guard envelope.version <= HappeningDocument.currentVersion else {
            throw HappeningStoreError.laterForm(at: place, version: envelope.version)
        }
        guard (1...HappeningDocument.currentVersion).contains(envelope.version) else {
            throw HappeningStoreError.notAStore(at: place)
        }
        guard let document = try? JSONDecoder().decode(HappeningDocument.self, from: data),
            let happenings = document.formHappenings()
        else {
            throw HappeningStoreError.notAStore(at: place)
        }

        self.happenings = happenings
    }

    /// Exactly what is kept at `place`.
    public private(set) var happenings: Happenings

    /// Kept at `place` before this returns. `false`, without throwing and without writing, where
    /// `Happenings.add` refuses.
    @discardableResult
    public func add(_ happening: Happening) throws -> Bool {
        var next = happenings
        guard next.add(happening) else {
            return false
        }
        try write(next)

        happenings = next
        return true
    }

    /// Kept at `place` before this returns. `false`, without throwing and without writing, where
    /// `Happenings.rename` refuses.
    @discardableResult
    public func rename(_ happening: Happening, to name: String) throws -> Bool {
        var next = happenings
        guard next.rename(happening, to: name) else {
            return false
        }
        try write(next)

        happenings = next
        return true
    }

    /// Kept at `place` before this returns. `false`, without throwing and without writing, where
    /// `Happenings.note` refuses.
    @discardableResult
    public func note(_ occurrence: Occurrence) throws -> Bool {
        var next = happenings
        guard next.note(occurrence) else {
            return false
        }
        try write(next)

        happenings = next
        return true
    }

    /// Writes `next` as the whole document, `.sortedKeys` so a keyed container's keys do not
    /// follow Foundation's per-process hash order, on top of `Happenings`' own order.
    private func write(_ next: Happenings) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let data = try encoder.encode(HappeningDocument(next))

        do {
            try FileManager.default.createDirectory(
                at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
            try data.write(to: place, options: .atomic)
        } catch {
            throw HappeningStoreError.cannotWrite(at: place)
        }
    }
}

public enum HappeningStoreError: Error, Equatable, Sendable {
    /// What is at `place` is not a store this app can read, or holds what could not be a happening.
    case notAStore(at: URL)
    /// A store in a form later than this app writes; `version` is the form found.
    case laterForm(at: URL, version: Int)
    /// The change could not be kept at `place`; nothing was held.
    case cannotWrite(at: URL)
}
