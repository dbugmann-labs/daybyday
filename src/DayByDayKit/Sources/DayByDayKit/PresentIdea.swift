import Foundation

/// A thing to give a person: a text, a link or both. See this change's `design.md` § *The seam*.
public struct PresentIdea: Hashable, Sendable {
    public let text: String?
    public let link: String?
    /// Whether it has been given. Every idea `init(text:link:)` makes is not.
    public let isGiven: Bool

    public init(text: String, link: String) throws(PresentIdeaRefusal) {
        let text = Blank.saysNothing(text) ? nil : Blank.trimmed(text)
        let link = Blank.saysNothing(link) ? nil : Blank.trimmed(link)
        if let link, !Self.readsAsAWebAddress(link) {
            throw .linkIsNotAWebAddress
        }
        guard text != nil || link != nil else {
            throw .saysNothing
        }
        self.text = text
        self.link = link.map(Self.kept)
        self.isGiven = false
    }

    private init(text: String?, link: String?, isGiven: Bool) {
        self.text = text
        self.link = link
        self.isGiven = isGiven
    }

    /// This idea, its text and link as they are, given or not as `isGiven` says.
    func marked(given isGiven: Bool) -> PresentIdea {
        PresentIdea(text: text, link: link, isGiven: isGiven)
    }

    /// Whether `link` holds no blank space and, after an optional http:// or https:// in any
    /// case, begins with a host: two or more parts joined by single dots, each one or more letters,
    /// digits or hyphens, the last letters alone and at least two long, followed by nothing or by
    /// "/", "?" or "#" and whatever comes after.
    private static func readsAsAWebAddress(_ link: String) -> Bool {
        guard !link.contains(where: \.isWhitespace) else {
            return false
        }
        var rest = Substring(link)
        for scheme in ["https://", "http://"] where rest.lowercased().hasPrefix(scheme) {
            rest = rest.dropFirst(scheme.count)
            break
        }
        let host = rest.prefix { !"/?#".contains($0) }
        let parts = host.split(separator: ".", omittingEmptySubsequences: false)
        guard parts.count >= 2 else {
            return false
        }
        let partsAreWords = parts.allSatisfy {
            !$0.isEmpty && $0.allSatisfy { $0.isLetter || $0.isWholeNumber || $0 == "-" }
        }
        guard partsAreWords, let last = parts.last else {
            return false
        }
        return last.count >= 2 && last.allSatisfy(\.isLetter)
    }

    /// `link` as it is kept: as typed where it names http or https in any case, otherwise with
    /// https:// in front.
    private static func kept(_ link: String) -> String {
        let lowered = link.lowercased()
        return lowered.hasPrefix("http://") || lowered.hasPrefix("https://") ? link : "https://" + link
    }

    public var opens: URL? { link.flatMap { URL(string: $0) } }
}

public enum PresentIdeaRefusal: Error, Equatable, Sendable {
    case saysNothing, linkIsNotAWebAddress, notKept
}
