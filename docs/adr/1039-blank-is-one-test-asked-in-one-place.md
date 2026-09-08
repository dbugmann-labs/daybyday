# 1039. Blank is one test, asked in one place, and it is Swift's

- Status: accepted
- Date: 2026-09-08
- Deciders: Diego Bugmann

## Context

Three things in `DayByDayKit` have to answer "does this text say anything?", and by
`add-note-record` (#140) all three are live:

- `Commitment.init?` refuses a name that is empty or made only of blank space, and has since
  `add-commitment-type` — `guard !name.allSatisfy(\.isWhitespace)`.
- `Note.init?` refuses a text that says nothing, on the grill's settled answer that a note is judged
  exactly as a commitment name is.
- `DayScreen.enter(_:on:)` reads a commit as a **take-back** when what was committed says nothing,
  and otherwise trims the blank space around it before the record is formed.

There are two obvious tests to reach for and **they disagree, in both directions**. Measured through
the real package on 2026-09-08, Apple Swift 6.3.3 (swiftlang-6.3.3.1.3), target
`arm64-apple-macosx26.0`:

```
                              Character.isWhitespace   CharacterSet.whitespaces(AndNewlines)
U+000A line feed                      yes                     no  (yes for AndNewlines)
U+2028 line separator                 yes                     no  (yes for AndNewlines)
U+00A0 no-break space                 yes                     yes
U+200B ZERO WIDTH SPACE               NO                      YES (both sets)
U+FEFF zero-width no-break space      no                      no
```

The zero-width space is the one that matters: Foundation's character sets contain it and Swift's
`Character.isWhitespace` does not, so `Commitment.init?` accepts a name of one U+200B today while any
`CharacterSet`-based reading would call the same text blank.

That is not hypothetical. `add-number-entry` (#139) trims a committed number with
`CharacterSet.whitespaces`, and the consequence was measured through `DayScreen.enter(_:on:)` on a
day already holding 70.5: **committing a lone U+200B trims to the empty text and takes the number
back**, silently, with nothing told on the row. A paste of one invisible character deletes a record.
Nobody chose that; it fell out of two places answering one question two ways.

## Decision

**One test decides whether a text says anything, it lives in one place, and it is Swift's
`Character.isWhitespace`.**

```swift
enum Blank {
    static func saysNothing(_ text: String) -> Bool   // text.allSatisfy(\.isWhitespace)
    static func trimmed(_ text: String) -> String     // drop(while:) at each end, same predicate
}
```

`Commitment.init?`, `Note.init?` and `DayScreen.enter(_:on:)`'s note branch all call `Blank` and
none of them spells the predicate out. Three consequences follow, and they are the decision:

- **Swift's test, not Foundation's**, because it is the one already shipped in `Commitment.init?`
  and because the alternative silently swallows a zero-width space. A note of one U+200B is
  therefore a note — invisible, and accepted for exactly the reason a commitment named with one is
  accepted. That edge is pinned by a scenario so it stays a decision rather than becoming an
  accident.
- **A line break is blank space.** `CharacterSet.whitespaces` does not contain one, which is why the
  number's reading calls a lone newline "Not a number" rather than a take-back. For a note, where a
  person types into a multi-line field, that answer would be wrong on sight.
- **The same function answers both questions**, so the state "a commit that is neither a record nor a
  take-back" is unrepresentable rather than merely untested: after `Blank.trimmed`, what is left
  begins with a character `Blank.saysNothing` does not accept, so `Note.init?`'s blank guard cannot
  fire on text the screen decided was a note.

**`DayScreen.read(_:)`'s number trim is deliberately left on `CharacterSet.whitespaces`.** The Story
grill settled that the inconsistency between the two entries stands and is not fixed by #140, and
the measurement above was put to the owner at that Story's residual round rather than acted on
here. This record exists partly to stop the *wrong* resolution: someone finding two whitespace tests
in `DayScreen.swift` and making the note match the number would import the deletion path into the
note, where a multi-line field makes it far easier to reach.

## Alternatives considered

**`CharacterSet.whitespacesAndNewlines` for both.** The obvious Foundation reach, and it looks like
the wider, safer set. It contains U+200B, so `"\u{200B}"` would be a take-back at the screen and a
perfectly good note at `Note.init?` — the exact two-answers state this record exists to prevent —
and it would put the deletion path into the note as well.

**Match the number's `CharacterSet.whitespaces`, so the whole package agrees today.** It buys
agreement by adopting the worse test: notes would stop trimming line breaks, a note typed with a
trailing newline would keep it, and a commit of one newline would be neither a note nor a take-back.
The grill also said in as many words not to widen the number's trim.

**Define our own set — Unicode's `White_Space` property plus the zero-width characters.** Wider than
either, and it would refuse a commitment name that is accepted today, which is a behaviour change to
a signed requirement dressed up as a helper. It also puts this package in the business of deciding
which invisible characters count, which is a rule about the owner's own words.

**Leave the predicate inline in all three places.** It is one short expression and looks harmless.
That is precisely how the number and the name came to disagree — nobody wrote a second definition on
purpose.

## Consequences

- **A note of one zero-width space is a note that draws as nothing.** Accepted, and inherited: the
  same is already true of a commitment name. Closing it here alone would mean two definitions of
  blank in one package.
- **`Commitment.init?` is refactored with no behaviour change** — the same predicate, moved. The
  suite is expected to report the same count before and after, and a red test there is a stop.
- **The package now has one blank test and one trim, and a second one is a review finding.** Anything
  later that asks the same question — a total's units, a category's name, a search box — calls
  `Blank` or explains why not.
- **The reversal trigger is a text this rule gets visibly wrong**: a person reporting that something
  they typed was neither kept nor cleared. Amend this record in place if that arrives (ADR-1020).
- **It does not fix `add-number-entry`.** The measurement is recorded in
  `openspec/changes/archive/…/add-note-record/design.md` § *Context* and in
  `docs/open-questions.md`; the fix, if the owner takes it, is `read(_:)`'s trim moving to `Blank`,
  after which this record describes the whole package rather than everything but one function.
