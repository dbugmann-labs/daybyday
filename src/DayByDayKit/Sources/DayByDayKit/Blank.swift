/// The one place this package decides whether a text says anything. See this change's
/// `design.md` § *One whitespace test, in one place, and it is Swift's* for why `Character
/// .isWhitespace` is the whole of the test and no `CharacterSet` stands beside it.
enum Blank {
    static func saysNothing(_ text: String) -> Bool {
        text.allSatisfy(\.isWhitespace)
    }

    static func trimmed(_ text: String) -> String {
        var scalars = Substring(text)
        while let first = scalars.first, first.isWhitespace {
            scalars.removeFirst()
        }
        while let last = scalars.last, last.isWhitespace {
            scalars.removeLast()
        }
        return String(scalars)
    }
}
