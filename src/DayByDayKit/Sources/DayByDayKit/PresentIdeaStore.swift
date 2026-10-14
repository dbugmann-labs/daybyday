import Foundation

/// Present ideas kept at a place, against contacts, across the app being closed and opened
/// again. See this change's `design.md` § *The seam*.
public final class PresentIdeaStore {
    private let place: URL
    private var held: [String: [PresentIdea]]

    /// Opens the store kept at `place`, reading what is there. A place where nothing has been kept
    /// opens holding no ideas; a place holding something that cannot be read throws.
    public init(at place: URL) throws {
        self.place = place

        guard FileManager.default.fileExists(atPath: place.path) else {
            self.held = [:]
            return
        }
        let data = try Data(contentsOf: place)
        guard let envelope = try? JSONDecoder().decode(PresentIdeaDocumentEnvelope.self, from: data)
        else {
            throw PresentIdeaStoreError.notAStore(at: place)
        }
        guard (1...PresentIdeaDocument.currentVersion).contains(envelope.version) else {
            if envelope.version > PresentIdeaDocument.currentVersion {
                throw PresentIdeaStoreError.laterForm(at: place, version: envelope.version)
            }
            throw PresentIdeaStoreError.notAStore(at: place)
        }
        guard let document = try? JSONDecoder().decode(PresentIdeaDocument.self, from: data),
            let formed = Self.formed(from: document)
        else {
            throw PresentIdeaStoreError.notAStore(at: place)
        }
        self.held = formed
    }

    /// The ideas `document` holds as a store would hold them, or `nil` where a store would refuse
    /// them at its own place as not such a store. The one re-forming `init(at:)` and a copy both
    /// go through, so they refuse alike.
    static func formed(from document: PresentIdeaDocument) -> [String: [PresentIdea]]? {
        guard document.version >= 1 else {
            return nil
        }
        return document.formIdeas()
    }

    /// Every idea held, against its contact.
    var all: [String: [PresentIdea]] { held }

    /// The ideas held against `contact`, in the order added.
    public func ideas(of contact: String) -> [PresentIdea] {
        held[contact] ?? []
    }

    /// Kept at the place before this returns; `false`, without throwing and without writing, where
    /// `contact` says nothing.
    @discardableResult
    public func add(_ idea: PresentIdea, to contact: String) throws -> Bool {
        guard !Blank.saysNothing(contact) else {
            return false
        }
        var next = held
        next[contact, default: []].append(idea)
        try write(next)

        held = next
        return true
    }

    /// Replaces the idea at `position` among `contact`'s, keeping its mark and its place; kept at
    /// the place before this returns. `false`, without throwing and without writing, where
    /// `position` names no idea of `contact`.
    @discardableResult
    public func change(_ position: Int, of contact: String, to idea: PresentIdea) throws -> Bool {
        try replacing(position, of: contact) { held in
            held[position] = idea.marked(given: held[position].isGiven)
            return true
        }
    }

    /// Removes the idea at `position` among `contact`'s, the others keeping their order.
    @discardableResult
    public func delete(_ position: Int, of contact: String) throws -> Bool {
        try replacing(position, of: contact) { held in
            held.remove(at: position)
            return true
        }
    }

    /// Marks given, or takes back the mark of, the idea at `position`; `false` where it is
    /// already so.
    @discardableResult
    public func mark(_ position: Int, of contact: String, given: Bool) throws -> Bool {
        try replacing(position, of: contact) { held in
            guard held[position].isGiven != given else {
                return false
            }
            held[position] = held[position].marked(given: given)
            return true
        }
    }

    private func replacing(
        _ position: Int, of contact: String, _ edit: (inout [PresentIdea]) -> Bool
    ) throws -> Bool {
        guard !Blank.saysNothing(contact), var ideas = held[contact],
            ideas.indices.contains(position), edit(&ideas)
        else {
            return false
        }
        var next = held
        next[contact] = ideas.isEmpty ? nil : ideas
        try write(next)

        held = next
        return true
    }

    private func write(_ next: [String: [PresentIdea]]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let data = try encoder.encode(PresentIdeaDocument(next))

        do {
            try FileManager.default.createDirectory(
                at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
            try data.write(to: place, options: .atomic)
        } catch {
            throw PresentIdeaStoreError.cannotWrite(at: place)
        }
    }
}

public enum PresentIdeaStoreError: Error, Equatable, Sendable {
    /// What is at `place` is not a store this app can read, or holds what could not be held.
    case notAStore(at: URL)
    /// A store in a form later than this app writes; `version` is the form found.
    case laterForm(at: URL, version: Int)
    /// The change could not be kept at `place`; nothing was held.
    case cannotWrite(at: URL)
}
