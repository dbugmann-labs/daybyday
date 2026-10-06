import SwiftUI

/// A commitment's name and the rhythm it runs on, drawn as one run of text: on the same line
/// while it fits, flowing onto a second only where it does not. One `Text` rather than a stack of
/// two, because a stack of two always breaks — the wrap is the whole point.
///
/// Layout, not content. Both strings are handed over already said: the name is the commitment's
/// own and the rhythm is the one `DayByDayKit` says for it, so nothing here composes either. The
/// hyphen is punctuation between the two rather than a third thing an entry says, and it is dimmed
/// with the rhythm so a name still reads as the thing the row is about.
///
/// **A wrap can leave the hyphen at the end of the first line**, which is what a plain space on
/// each side of it gets you. A non-breaking space was tried on 2026-09-07, on both sides in turn,
/// and moved nothing: inside an interpolated child `Text` the line breaker ignores it, and in
/// front of the hyphen it only forbids the break SwiftUI already declines to take. Two spaces, and
/// the hyphen falls where it falls.
///
/// `name` arrives as a `Text` rather than a `String` because the day screen dims the name of a
/// commitment already kept and the commitments screen does not, and that is the caller's choice
/// to make.
///
/// `mark` is the words `DayScreen.mark(on:)` says for a row with no slack, or `nil` for a row with
/// none. Where given, a caption-size glyph follows the rhythm inside the same `Text`, so it wraps
/// with the words, in the label colour, and is read aloud as `mark` — the words are the Kit's and
/// nothing here composes them. The symbol is a build-time value, `design.md` § *The shell*.
func commitmentLine(_ name: Text, rhythmInWords: String, mark: String? = nil) -> Text {
    let rhythm = Text(verbatim: "- " + rhythmInWords)
        .font(.caption)
        .foregroundStyle(.secondary)
    guard let mark else {
        return Text("\(name) \(rhythm)")
    }
    let glyph = Text(Image(systemName: "exclamationmark.circle"))
        .font(.caption)
        .foregroundStyle(Color.primary)
        .accessibilityLabel(mark)
    return Text("\(name) \(rhythm) \(glyph)")
}
