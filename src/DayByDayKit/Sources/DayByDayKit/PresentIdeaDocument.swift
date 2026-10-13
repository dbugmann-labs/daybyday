import Foundation

/// The versioned form a `PresentIdeaStore` writes to and reads from disk, shaped by hand as
/// `BirthdayDocument` is. Contacts are written sorted, each contact's ideas in the order added,
/// an absent part omitted. `design.md` § *Migration*.
struct PresentIdeaDocument: Codable {
    static let currentVersion = 1

    var version: Int
    var contacts: [PresentIdeaContactRecord]

    init(_ ideas: [String: [PresentIdea]]) {
        version = Self.currentVersion
        contacts = ideas.keys.sorted().compactMap { contact in
            let held = ideas[contact] ?? []
            guard !held.isEmpty else {
                return nil
            }
            return PresentIdeaContactRecord(
                contact: contact, ideas: held.map { PresentIdeaRecord(text: $0.text, link: $0.link) })
        }
    }

    /// Re-forms the ideas through `PresentIdea`'s own rules, keeping each part exactly as written:
    /// `nil` where a contact says nothing, an idea says nothing, a part has blank space at either
    /// end, or a link is not as the store keeps one.
    func formIdeas() -> [String: [PresentIdea]]? {
        var formed: [String: [PresentIdea]] = [:]
        for record in contacts {
            guard !Blank.saysNothing(record.contact), formed[record.contact] == nil else {
                return nil
            }
            var held: [PresentIdea] = []
            for entry in record.ideas {
                guard let idea = entry.formed() else {
                    return nil
                }
                held.append(idea)
            }
            formed[record.contact] = held
        }
        return formed
    }
}

/// Reads only `version`, so a later form is told apart from the body before the body is decoded.
struct PresentIdeaDocumentEnvelope: Decodable {
    var version: Int
}

struct PresentIdeaContactRecord: Codable {
    var contact: String
    var ideas: [PresentIdeaRecord]
}

struct PresentIdeaRecord: Codable {
    var text: String?
    var link: String?

    /// The idea this record holds, or `nil` where `PresentIdea` would not keep the same parts.
    func formed() -> PresentIdea? {
        guard let idea = try? PresentIdea(text: text ?? "", link: link ?? ""),
            idea.text == text, idea.link == link
        else {
            return nil
        }
        return idea
    }
}
