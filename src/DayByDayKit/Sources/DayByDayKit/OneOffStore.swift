import Foundation

/// One-offs kept at a place, across the app being closed and opened again. See
/// `openspec/specs/one-off/spec.md` for the behaviour contract and this change's `design.md`
/// § *The seam* for why the surface is shaped this way.
public final class OneOffStore {
    private let place: URL

    /// Opens the one-off store kept at `place`, reading what is there. A place where nothing has
    /// been kept opens holding nothing; a place holding something that cannot be read throws.
    public init(at place: URL) throws {
        self.place = place

        guard FileManager.default.fileExists(atPath: place.path) else {
            self.oneOffs = OneOffs()
            return
        }

        let data = try Data(contentsOf: place)

        guard let envelope = try? JSONDecoder().decode(OneOffDocumentEnvelope.self, from: data)
        else {
            throw OneOffStoreError.notAStore(at: place)
        }
        guard (1...OneOffDocument.currentVersion).contains(envelope.version) else {
            if envelope.version > OneOffDocument.currentVersion {
                throw OneOffStoreError.laterForm(at: place, version: envelope.version)
            }
            throw OneOffStoreError.notAStore(at: place)
        }
        guard let document = try? JSONDecoder().decode(OneOffDocument.self, from: data),
            let oneOffs = Self.formed(from: document)
        else {
            throw OneOffStoreError.notAStore(at: place)
        }

        self.oneOffs = oneOffs
    }

    /// Forms the one-offs `document` holds — `nil` where they fail to form. The one place
    /// `init(at:)` reads a decoded document into this store's own shape, shared with
    /// `CopyDocument.read`'s own per-store reading — `openspec/changes/restore-from-a-copy
    /// /design.md` § *Reading a copy: the envelope decides, and a later version outranks damage*.
    static func formed(from document: OneOffDocument) -> OneOffs? {
        guard Self.shapeAgrees(with: document) else {
            return nil
        }
        return document.formOneOffs()
    }

    /// Whether every entry's `tick` agrees with what `document.version` declares it should
    /// carry, and, where the document is at or after `tickOrderIntroducedInVersion`, whether its
    /// done entries' places give the tick order a place of its own for each, numbered from one
    /// without a gap — `design.md` § *The form on disk: form 2, a place on every done entry*, on
    /// the same footing as `RosterStore.shapeAgrees(with:)`. A `tick` is present exactly on a
    /// done entry at or after that form; present anywhere else — a not-done entry, or any entry
    /// at all before that form — disagrees and refuses the whole document.
    private static func shapeAgrees(with document: OneOffDocument) -> Bool {
        guard document.version >= 1 else {
            return false
        }
        let ticksAgreeWithForm = document.oneOffs.allSatisfy {
            ($0.tick != nil)
                == (document.version >= OneOffDocument.tickOrderIntroducedInVersion
                    && $0.doneOn != nil)
        }
        guard ticksAgreeWithForm else {
            return false
        }

        let ticks = document.oneOffs.compactMap(\.tick)
        guard !ticks.isEmpty else {
            return true
        }
        return Set(ticks) == Set(1...ticks.count)
    }

    /// Exactly what is kept at `place`.
    public private(set) var oneOffs: OneOffs

    /// Kept at `place` before this returns. Answers what `OneOffs.add` answers — `false`,
    /// without throwing and without writing, when a one-off with the same name and date is
    /// already held.
    @discardableResult
    public func add(_ oneOff: OneOff) throws -> Bool {
        var next = oneOffs
        guard next.add(oneOff) else {
            return false
        }
        try write(next)

        oneOffs = next
        return true
    }

    /// Kept at `place` before this returns. Answers what `OneOffs.add(_:doneOn:)` answers —
    /// `false`, without throwing and without writing, when a one-off with the same name and date
    /// is already held, or when `day` falls before `oneOff`'s own date.
    @discardableResult
    public func add(_ oneOff: OneOff, doneOn day: CalendarDate) throws -> Bool {
        var next = oneOffs
        guard next.add(oneOff, doneOn: day) else {
            return false
        }
        try write(next)

        oneOffs = next
        return true
    }

    /// Kept at `place` before this returns. Answers what `OneOffs.tick` answers — `false`,
    /// without throwing and without writing, when this does not hold `oneOff`, when it is
    /// already done, or when `day` falls before `oneOff`'s own date.
    @discardableResult
    public func tick(_ oneOff: OneOff, on day: CalendarDate) throws -> Bool {
        var next = oneOffs
        guard next.tick(oneOff, on: day) else {
            return false
        }
        try write(next)

        oneOffs = next
        return true
    }

    /// Kept at `place` before this returns. Answers what `OneOffs.takeBack` answers — `false`,
    /// without throwing and without writing, when this does not hold `oneOff` or it is not done.
    @discardableResult
    public func takeBack(_ oneOff: OneOff) throws -> Bool {
        var next = oneOffs
        guard next.takeBack(oneOff) else {
            return false
        }
        try write(next)

        oneOffs = next
        return true
    }

    /// Kept at `place` before this returns. Answers what `OneOffs.rename` answers — `false`,
    /// without throwing and without writing, when this does not hold `oneOff`, when `name` says
    /// nothing, or when a one-off with `name` on `oneOff`'s date is already held.
    @discardableResult
    public func rename(_ oneOff: OneOff, to name: String) throws -> Bool {
        var next = oneOffs
        guard next.rename(oneOff, to: name) else {
            return false
        }
        try write(next)

        oneOffs = next
        return true
    }

    /// Kept at `place` before this returns. Answers what `OneOffs.remove` answers — `false`,
    /// without throwing and without writing, when this does not hold `oneOff`.
    @discardableResult
    public func remove(_ oneOff: OneOff) throws -> Bool {
        var next = oneOffs
        guard next.remove(oneOff) else {
            return false
        }
        try write(next)

        oneOffs = next
        return true
    }

    /// Writes `next` as the whole document, in the byte-stable form `design.md` § *The form on
    /// disk* fixes: `.sortedKeys` so a keyed container's keys do not follow Foundation's
    /// per-process hash order, on top of `OneOffs`'s own order, which is never sorted.
    private func write(_ next: OneOffs) throws {
        let document = OneOffDocument(next)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let data = try encoder.encode(document)

        do {
            try FileManager.default.createDirectory(
                at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
            try data.write(to: place, options: .atomic)
        } catch {
            throw OneOffStoreError.cannotWrite(at: place)
        }
    }
}

public enum OneOffStoreError: Error, Equatable, Sendable {
    /// What is at `place` is not a store this app can read, or holds what could not be a
    /// one-off.
    case notAStore(at: URL)
    /// A store in a form later than this app writes; `version` is the form found.
    case laterForm(at: URL, version: Int)
    /// The change could not be kept at `place`; nothing was held.
    case cannotWrite(at: URL)
}
