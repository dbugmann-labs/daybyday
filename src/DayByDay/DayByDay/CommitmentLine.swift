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
func commitmentLine(_ name: Text, rhythmInWords: String) -> Text {
    let rhythm = Text(verbatim: "- " + rhythmInWords)
        .font(.caption)
        .foregroundStyle(.secondary)
    return Text("\(name) \(rhythm)")
}
