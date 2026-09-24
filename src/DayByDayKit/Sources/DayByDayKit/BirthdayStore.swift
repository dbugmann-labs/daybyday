import Foundation

/// Birthday ticks kept at a place, across the app being closed and opened again. See
/// `openspec/specs/birthday/spec.md` for the behaviour contract and this change's `design.md`
/// § *The seam* for why the surface is shaped this way.
public final class BirthdayStore {
    private let place: URL

    /// Opens the birthday store kept at `place`, reading what is there. A place where nothing
    /// has been kept opens holding no ticks; a place holding something that cannot be read
    /// throws.
    public init(at place: URL) throws {
        self.place = place

        guard FileManager.default.fileExists(atPath: place.path) else {
            self.ticks = BirthdayTicks()
            return
        }

        let data = try Data(contentsOf: place)

        guard let envelope = try? JSONDecoder().decode(BirthdayDocumentEnvelope.self, from: data)
        else {
            throw BirthdayStoreError.notAStore(at: place)
        }
        guard (1...BirthdayDocument.currentVersion).contains(envelope.version) else {
            if envelope.version > BirthdayDocument.currentVersion {
                throw BirthdayStoreError.laterForm(at: place, version: envelope.version)
            }
            throw BirthdayStoreError.notAStore(at: place)
        }
        guard let document = try? JSONDecoder().decode(BirthdayDocument.self, from: data),
            let ticks = Self.formed(from: document)
        else {
            throw BirthdayStoreError.notAStore(at: place)
        }

        self.ticks = ticks
    }

    /// Forms the ticks `document` holds — `nil` where they fail to form. The one place
    /// `init(at:)` reads a decoded document into this store's own shape, mirroring
    /// `OneOffStore.formed(from:)`.
    static func formed(from document: BirthdayDocument) -> BirthdayTicks? {
        guard document.version >= 1 else {
            return nil
        }
        return document.formTicks()
    }

    /// Exactly what is kept at `place`.
    public private(set) var ticks: BirthdayTicks

    /// Kept at `place` before this returns. Answers what `BirthdayTicks.tick` answers —
    /// `false`, without throwing and without writing, when `birthday` is already ticked.
    @discardableResult
    public func tick(_ birthday: Birthday) throws -> Bool {
        var next = ticks
        guard next.tick(birthday) else {
            return false
        }
        try write(next)

        ticks = next
        return true
    }

    /// Kept at `place` before this returns. Answers what `BirthdayTicks.takeBack` answers —
    /// `false`, without throwing and without writing, when `birthday` is not ticked.
    @discardableResult
    public func takeBack(_ birthday: Birthday) throws -> Bool {
        var next = ticks
        guard next.takeBack(birthday) else {
            return false
        }
        try write(next)

        ticks = next
        return true
    }

    /// Writes `next` as the whole document, in the byte-stable form `design.md` § *The form on
    /// disk* fixes: `.sortedKeys` so a keyed container's keys do not follow Foundation's
    /// per-process hash order, on top of `BirthdayDocument`'s own contact-then-day order.
    private func write(_ next: BirthdayTicks) throws {
        let document = BirthdayDocument(next)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let data = try encoder.encode(document)

        do {
            try FileManager.default.createDirectory(
                at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
            try data.write(to: place, options: .atomic)
        } catch {
            throw BirthdayStoreError.cannotWrite(at: place)
        }
    }
}

public enum BirthdayStoreError: Error, Equatable, Sendable {
    /// What is at `place` is not a store this app can read, or holds what could not be a tick.
    case notAStore(at: URL)
    /// A store in a form later than this app writes; `version` is the form found.
    case laterForm(at: URL, version: Int)
    /// The change could not be kept at `place`; nothing was held.
    case cannotWrite(at: URL)
}
