# 1039. Blank is one test, asked in one place, and it is Swift's

- Status: accepted
- Date: 2026-09-08
- Deciders: Diego Bugmann

## Context

Four things in `DayByDayKit` have to answer "does this text say anything?", and by
`add-note-record` (#140) all four are live:

- `Commitment.init?` refuses a name that is empty or made only of blank space, and has since
  `add-commitment-type` — `guard !name.allSatisfy(\.isWhitespace)`.
- `Note.init?` refuses a text that says nothing, on the grill's settled answer that a note is judged
  exactly as a commitment name is.
- `DayScreen.enter(_:on:)` reads a commit in a **note** entry as a take-back when what was committed
  says nothing, and otherwise trims the blank space around it before the record is formed.
- `DayScreen.read(_:)` reads a commit in a **number** entry as a take-back when nothing is left once
  the blank space around it is disregarded, and has since `add-number-entry` (#139).

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

`Commitment.init?`, `Note.init?`, `DayScreen.enter(_:on:)`'s note branch and `DayScreen.read(_:)`'s
number trim all call `Blank`, and none of them spells the predicate out. **There is no exception, and
the absence of one is half the decision** — the defect above is what an exception costs, and a rule
with one carve-out in it is a rule nobody can apply to the fifth caller. Three consequences follow:

- **Swift's test, not Foundation's**, because it is the one already shipped in `Commitment.init?`
  and because the alternative silently swallows a zero-width space. A note of one U+200B is
  therefore a note — invisible, and accepted for exactly the reason a commitment named with one is
  accepted. That edge is pinned by a scenario so it stays a decision rather than becoming an
  accident.
- **A line break is blank space.** `CharacterSet.whitespaces` does not contain one, which is why the
  number's reading called a lone newline "Not a number" rather than a take-back until `add-note-record`
  moved it. For a note, where a person types into a multi-line field, that answer would be wrong on
  sight; for a number it was merely odd, and the two are now one answer.
- **The same function answers both questions**, so the state "a commit that is neither a record nor a
  take-back" is unrepresentable rather than merely untested: after `Blank.trimmed`, what is left
  begins with a character `Blank.saysNothing` does not accept, so `Note.init?`'s blank guard cannot
  fire on text the screen decided was a note.

**`DayScreen.read(_:)` moves onto `Blank` in the same change.** #140's grill first settled that the
inconsistency between the two entries would stand and be recorded rather than fixed, on the reading
that the harm was a lone newline told "Not a number". The measurement above showed the harm ran the
other way and cost a record, so it was put to the owner at that Story's residual round and the
settled answer was reversed before G4. The edit is one expression, every text the number entry's
archived scenarios name answers exactly as it did, and the two texts that change answer are the two
this record is about. **The one `CharacterSet` left in the package is
`CommitmentsScreen.nameTypedBackMatches`**, which trims both sides of a name a person types back to
confirm a removal. It is deliberately not `Blank`'s: it asks whether two names are the same, not
whether a text says anything, and it guards a gesture rather than a record. Anything that asks
*this* question and does not call `Blank` is a review finding.

## Alternatives considered

**`CharacterSet.whitespacesAndNewlines` for both.** The obvious Foundation reach, and it looks like
the wider, safer set. It contains U+200B, so `"\u{200B}"` would be a take-back at the screen and a
perfectly good note at `Note.init?` — the exact two-answers state this record exists to prevent —
and it would put the deletion path into the note as well.

**Move the note onto the number's `CharacterSet.whitespaces`, so the whole package agrees without
touching signed behaviour.** It buys agreement by adopting the worse test: notes would stop trimming
line breaks, a note typed with a trailing newline would keep it, a commit of one newline would be
neither a note nor a take-back, and the deletion path would follow the trim into the note — where a
multi-line field makes a pasted zero-width space far easier to reach than a decimal keypad does.

**Leave `read(_:)` alone and record the defect in `docs/open-questions.md`.** This was the decision
for one day. It was reversed once the harm was measured rather than assumed: it is cheaper to change
one expression under a gate that has not closed yet than to carry a known deletion path into an
archived spec and hope the follow-up Story gets written.

**Define our own set — Unicode's `White_Space` property plus the zero-width characters.** Wider than
either, and it would refuse a commitment name that is accepted today, which is a behaviour change to
a signed requirement dressed up as a helper. It also puts this package in the business of deciding
which invisible characters count, which is a rule about the owner's own words.

**Leave the predicate inline in all three places.** It is one short expression and looks harmless.
That is precisely how the number and the name came to disagree — nobody wrote a second definition on
purpose.

## Consequences

- **A note of one zero-width space is a note that draws as nothing, and a number entry committed with
  one is told "Not a number".** Accepted, and inherited: the same is already true of a commitment
  name. Closing it would take a second, wider definition of blank than the commitment has. Neither
  answer loses a record, which is the property that was missing.
- **A number entry committed with a line break alone is now a take-back rather than "Not a number".**
  The second direction of the same disagreement, closed in the same edit. A decimal keypad produces
  neither character, so both paths are a paste.
- **`Commitment.init?` is refactored with no behaviour change** — the same predicate, moved. The
  suite is expected to report the same count before and after, and a red test there is a stop.
- **The package now has one blank test and one trim, and a second one is a review finding.** Anything
  later that asks the same question — a total's units, a category's name, a search box — calls
  `Blank` or explains why not.
- **The reversal trigger is a text this rule gets visibly wrong**: a person reporting that something
  they typed was neither kept nor cleared. Amend this record in place if that arrives (ADR-1020).
- **It reaches back into `add-number-entry`.** One MODIFIED requirement in #140's `day-screen` delta
  restates *A day screen reads what an entry is committed with as a number, as a take-back, or as
  neither* on this test, carrying all eight of its archived scenarios forward unchanged and adding
  one scenario per direction. That is the whole cost, and it was paid before G4 rather than as a
  second Story.
