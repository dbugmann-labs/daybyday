## Context

See `proposal.md` § *Why*. What matters here is what already exists, what this change may not
invent, and — because `grill.md`'s carried-over note binds it — what was **measured** rather than
asserted.

`record` is finished for numbers and this change copies its shape rather than inventing one.
`Number.init?(_:for:on:)` refuses a value the commitment will not take, `History.number(for:on:)`
reads one back, `History.removeNumber(for:on:)` takes one back by naming the commitment and the day
(ADR-1033), and `RecordStore` persists all of it at form 3, reading forms 1 through 3 and refusing a
form whose shape disagrees with what it declares (ADR-1031). `day-screen` has the two shapes this
change extends: `DayView.Row.numberEntry(asOf:)` and `DayView.Row.numberRecord(_:asOf:)`, the pair
#139 named **for the two Stories that would copy it**, and `DayScreen.enter(_:on:)` with
`DayScreen.Notice`.

**Every claim below about what a note may hold was measured through `DayByDayKit`, not reasoned.**
`grill.md` § *Left open* requires it, and #139's carried-over note 3 says why: a measurement that
re-implements the thing it is checking proves nothing. Each measurement below drove the real package
from an executable linking `DayByDayKit` by path, on this machine on 2026-09-08, Apple Swift 6.3.3
(swiftlang-6.3.3.1.3), target `arm64-apple-macosx26.0`.

### Measurement 1 — the two whitespace tests in this package disagree, in both directions

The grill settled (answer 5) that blank means whitespace in the full sense and that this matches
`Commitment.init?`, which refuses a name on `allSatisfy(\.isWhitespace)`, while `DayScreen.read(_:)`
trims a committed number with `CharacterSet.whitespaces`. Asked of one character at a time, through
`Commitment.init?`:

```
char                    Character.isWhitespace   .whitespacesAndNewlines   .whitespaces   Commitment refuses
U+0020 space                     yes                      yes                  yes              yes
U+0009 tab                       yes                      yes                  yes              yes
U+000A line feed                 yes                      yes                  NO               yes
U+000D carriage return           yes                      yes                  NO               yes
U+0085 next line                 yes                      yes                  NO               yes
U+00A0 no-break space            yes                      yes                  yes              yes
U+2028 line separator            yes                      yes                  NO               yes
U+2029 paragraph separator       yes                      yes                  NO               yes
U+3000 ideographic space         yes                      yes                  yes              yes
U+200B ZERO WIDTH SPACE          NO                       yes                  yes              NO
U+200D zero-width joiner         NO                       no                   no               NO
U+FEFF zero-width no-break sp.   NO                       no                   no               NO
```

The empty string is blank by `allSatisfy` (vacuously) and refused. `"\n\n\n"` and `" \t\n "` are
refused. **`"\u{200B}"` is not blank by Swift's test and forms a commitment name** — while both
Foundation character sets contain it.

So the two tests disagree twice over, and neither disagreement is a rounding error: a line break is
whitespace to Swift and not to `CharacterSet.whitespaces`, and a zero-width space is whitespace to
Foundation and not to Swift. **A note that used one test to decide *blank* and the other to decide
*what to trim* would have texts that are neither a note nor a take-back.** § *Decisions* takes one
test and uses it for both.

### Measurement 2 — what the disagreement already does to a committed number

Driven through `DayScreen.enter(_:on:)` on a number row already holding 70.5, at a real place:

```
committed            ->  what the day then holds
U+0020 space             TAKEN BACK
U+0009 tab               TAKEN BACK
U+00A0 no-break space    TAKEN BACK
U+3000 ideographic sp.   TAKEN BACK
""  (the empty text)     TAKEN BACK
U+000A line feed         kept 70.5, told "Not a number"
U+000D carriage return   kept 70.5, told "Not a number"
U+2028 line separator    kept 70.5, told "Not a number"
U+FEFF zero-width nbsp   kept 70.5, told "Not a number"
U+200B ZERO WIDTH SPACE  TAKEN BACK
```

The last line is the finding. The grill knew the newline direction, which is harmless — a lone
newline is told "Not a number" rather than taken back, and nobody loses a record. The
**zero-width-space direction is not harmless**: a paste of one invisible character silently deletes
the number kept for that day, and the screen then draws the day as not kept with no message at all.
It is reachable only by a paste, because a decimal keypad prints no such character, and it is
`add-number-entry`'s behaviour rather than anything this change introduces.

**This change fixes it, and both directions close together.** The measurement was put to the owner
as a residual round, because it was not the fact the grill's answer 5 was given against — that answer
weighed the harmless direction and two figures that turned out to be wrong, and it was reversed in
`grill.md` on 2026-09-08, before G4. So `read(_:)`'s trim moves onto the same `Blank` the note uses,
one MODIFIED requirement joins the `day-screen` delta, and the package ends with one blank test
rather than one blank test and an exception.

### Measurement 2a — what the widened trim does to every text an archived scenario names

The fix is a trim swap on a requirement that is already archived, so what matters is not that the two
new texts answer differently but that **nothing else does**. Every text named in the archived
scenarios of *A day screen reads what an entry is committed with as a number, as a take-back, or as
neither* was put through both trims and through the rest of `read(_:)`'s reading, which the fix does
not touch. Unlike measurements 1, 3 and 4 this one cannot yet be driven through `DayByDayKit` —
`Blank` does not exist until § 12 of `tasks.md` — so the two predicates were compiled and run
side by side, on this machine on 2026-09-08, Apple Swift 6.3.3 (swiftlang-6.3.3.1.3):

```
committed                    .whitespaces        Character.isWhitespace   same answer
" 70.5 "                     "70.5"              "70.5"                   yes
"  " (two spaces)            "" — take-back      "" — take-back           yes
""  (the empty text)         "" — take-back      "" — take-back           yes
"1.2.3" "." "-" "12abc"      unchanged           unchanged                yes
"1e3" "7-0" "٧٠"             unchanged           unchanged                yes
"0000070.50"  "70."          unchanged           unchanged                yes
"70,5"  "-12.75"             unchanged           unchanged                yes
─── and the three texts the fix is about, for contrast ───
U+200B alone                 "" — take-back      "<ZWSP>" — not a number  NO
"\n\n\n"                     unchanged — n.a.n.  "" — take-back           NO
"\t\n"                       "\n" — n.a.n.       "" — take-back           NO
```

**No archived scenario changes answer**, so none is rewritten and none is deleted: the MODIFIED
requirement carries all eight of them forward word for word and adds two. The thirty-eight-digit and
thirty-nine-digit texts are digits throughout and cannot be touched by a trim at all. `tasks.md`
§ 12.7 re-runs the eight tests named for those scenarios against the real edit, because a predicate
measured beside the package is weaker evidence than the suite, and a red one there is a stop.

### Measurement 3 — what a text survives, through a real `RecordStore`

A note is a `String`, and the one `String` this app already persists is a commitment's name, through
the very `Codable`/JSON path (`JSONEncoder` with `.sortedKeys`, `Data.write(to:options: .atomic)`) a
note will take. Each text below was written as a commitment's name, the store reopened, and the name
read back **out of the file's own bytes** and compared **unicode scalar for unicode scalar** — not
through Swift's `==`, which is canonical and would call two different scalar runs equal:

```
text                                  scalars    file        identical
plain English                              33      256 B     yes
"Zürich — „langer" Lauf 🏃"                24      257 B     yes
e + combining acute (2 scalars)             2      226 B     yes
precomposed é (1 scalar)                    1      225 B     yes
👩‍👩‍👧‍👦 (ZWJ family sequence)                    7      248 B     yes
𐐷 𝔘𝔫𝔦𝔠𝔬𝔡𝔢 (non-BMP)                        9      256 B     yes
שלום עולם (right-to-left)                   9      240 B     yes
three lines with line breaks               28      254 B     yes
a tab inside                                8      232 B     yes
zero-width scalars inside                  11      238 B     yes
a NUL (U+0000) inside                       3      231 B     yes
emoji + variation selector                  2      230 B     yes
1 000 characters                        1 000    2 223 B     yes
100 000 characters                    100 000  200 223 B     yes
1 000 000 characters                1 000 000  2 000 223 B   yes
```

So the delta's "character for character, at every length, in every script" is a measured claim and
not a hopeful one — including a NUL, which JSON escapes, and a million characters, which is a 2 MB
file written atomically without complaint. **There is no length at which this stops working that any
person will reach by typing**, which is why the delta sets no bound: a bound would be a number
invented here rather than one the system has.

### Measurement 4 — two texts that are one text

```
"e\u{0301}" == "é"                       -> true      (Swift String equality is canonical)
their unicodeScalars are equal           -> false
the two commitments are equal            -> true
each is still written back as its own scalars -> true / true
```

**Two notes differing only in how the same writing is spelled are the same note**, because Swift
compares `String`s by canonical equivalence and a `Note`'s identity is its commitment, its date and
its text. That is inherited from `Commitment`, where it has been true and correct since the name
existed, and it is the right answer: a person who types é and a person whose keyboard sends e + ́
wrote the same word. What it does **not** license is normalising on the way to disk — each is kept
as the scalars it was given, and the delta says so in words ("in the very form each character was
given in rather than any other form of the same writing") with a scenario that fails an
implementation reaching for `precomposedStringWithCanonicalMapping`.

## Goals / Non-Goals

**Goals**

- One `Note` record that copies `Number`'s shape exactly, so #141's total copies one shape and not
  two.
- One whitespace test in this package's answer to "does this text say anything", asked in one place
  and used by the record, by the note entry **and by the number entry** — no exception, because an
  exception is what measurement 2 found and what it cost.
- One way in for a commit, whatever entry the row offers, so a caller cannot pick the wrong door.

**Non-Goals**

- Any change to what a number entry does **beyond the trim**. Its three answers stay three, its parse
  table is untouched, its two causes stay two, and no scenario of its own is rewritten (measurement
  2a). What moves is one expression: which characters are disregarded before the text is read.
- Any change to `CommitmentsScreen.nameTypedBackMatches`, the third `CharacterSet` in this package.
  It trims both sides of a name a person is typing back to confirm a removal, which is *are these two
  names the same* rather than *does this text say anything*; it guards a gesture rather than a record,
  and widening it would be a delta against a third capability nobody grilled. Named in ADR-1039 so
  that the claim "one blank test" stays a true claim rather than a tidy one.
- The general record reader `History` will eventually have. #138's grill deferred it and named this
  Story and #141 as the point at which the deferral runs out; the grill (answer 6) took the third
  one-off reader knowingly, because the **total** is the record whose shape would actually decide
  the general one and it does not exist yet.
- Reading a note back anywhere but in the entry it was written in. That is B-007's, at the owner's
  direction (`grill.md` answer 12).
- Fixing B-035, the tap a future row does not answer. Repeated a third time, deliberately, so one
  fix covers three kinds of row.
- A UI test of any kind. `docs/open-questions.md` § *No UI smoke layer* still holds.

## Decisions

### The seam

**Widened, not new.** One new type in `record`, mirroring `Number`; two members on an existing row;
one existing screen member widened, and one private reading behind it moved onto `Blank` without its
signature or its answers changing. Every scenario in this delta is driven through `Note`, `History`,
`RecordStore`, `DayView` or `DayScreen`, and no test spawns a process or captures a stream.

```swift
/// A note recorded for a note commitment on a calendar date it is due on.
public struct Note: Hashable, Sendable {
    let commitment: Commitment
    let date: CalendarDate
    let text: String

    /// `nil` when the commitment is not due on `date`, when its kind is not a note, or when
    /// `text` says nothing — `Blank.says(nothing:)` below.
    public init?(_ text: String, for commitment: Commitment, on date: CalendarDate)
}

public struct History {
    // ticks and numbers as today, plus:
    private var notes: [RecordedDay: String]
    public mutating func add(_ note: Note)
    public mutating func removeNote(for commitment: Commitment, on date: CalendarDate)
    public func note(for commitment: Commitment, on date: CalendarDate) -> String?
    // isKept widens once more: a note keeps its day by being there.
}

public final class RecordStore {
    public func add(_ note: Note) throws
    public func removeNote(for commitment: Commitment, on date: CalendarDate) throws
}

extension DayView {
    /// What a note commitment's row offers in a tick's place. One thing, and no more.
    public struct NoteEntry: Hashable, Sendable {
        /// The note the day already holds, or `nil` where it holds none.
        public let note: String?
    }

    public struct Row {
        // commitment, date, isKept, number as today, plus:
        let note: String?

        /// The note entry this row offers, or `nil` when its commitment's kind is not a note or
        /// the row's date is later than `today`.
        public func noteEntry(asOf today: CalendarDate) -> NoteEntry?

        /// The note record this row makes of `text` — this row's commitment, on this row's date —
        /// or `nil` when the row offers no note entry as of `today`, or the text says nothing.
        public func noteRecord(_ text: String, asOf today: CalendarDate) -> Note?
    }
}

@MainActor @Observable public final class DayScreen {
    /// Unchanged signature. Enters what `text` holds in whichever entry `row` offers, or takes
    /// that day's record back where it holds nothing.
    public func enter(_ text: String, on row: DayView.Row) throws

    /// Unchanged signature, unchanged three answers, unchanged parse. Its first line stops being
    /// `text.trimmingCharacters(in: .whitespaces)` and becomes `Blank.trimmed(text)`.
    private static func read(_ text: String) -> CommittedText
}

/// The one place this package decides whether a text says anything. Internal.
enum Blank {
    static func saysNothing(_ text: String) -> Bool
    static func trimmed(_ text: String) -> String
}

// In DayScreen.swift, private to this capability, beside the number's twin.
private extension RecordStore {
    func removeNote(on day: RecordedDay) throws
}
```

`noteEntry(asOf:)` and `noteRecord(_:asOf:)` are **the pair #139 named for this Story** —
`<kind>Entry(asOf:)` for what a row offers, `<kind>Record(_:asOf:)` for what a row makes. #139's
`design.md` § *The seam* argues the naming and says in as many words that it exists so #140 and #141
copy it rather than re-deciding it. This is that copy; nothing here re-opens it.

**Rejected: a second screen member, `enterNote(_:on:)` or `write(_:on:)`.** Two public members
taking exactly `(String, DayView.Row)`, differing only in name, and each answering the other's row
with silence. A caller cannot be told apart from a bug there, and the shell would have to branch on
a kind the row already knows. `enter` was already a kind-neutral verb — its own doc comment reads
"enters what `text` holds on `row`" — so widening it costs no rename and adds no surface.
**Rejected: renaming `enter` to `commit(_:on:)`.** It reads slightly better and costs a rename of a
member signed at G4 four days ago, with every archived scenario written against it. The name is not
wrong; the cost is real.

### One whitespace test, in one place, and it is Swift's

Measurement 1 shows the two tests already in this package disagree in both directions. The rule the
delta takes: **`Character.isWhitespace`, everywhere this package asks whether a text says anything.**

- `Commitment.init?` refuses `name` when `Blank.saysNothing(name)`. A refactor with no behaviour in
  it — `Blank.saysNothing` is `allSatisfy(\.isWhitespace)`, which is what that guard already spells
  out inline — and the point of moving it is that there is then one place to change and one place to
  read.
- `Note.init?` refuses `text` when `Blank.saysNothing(text)`, the same guard character for character.
  That is the grill's answer 5 and it is what "judged exactly as a commitment name is" means when
  written down.
- `DayScreen.enter(_:on:)`, on a note row, asks **the same function**: `Blank.saysNothing(text)` is
  the take-back, everything else is trimmed by `Blank.trimmed` — `drop(while:\.isWhitespace)` at
  each end — and handed to `row.noteRecord(_:asOf:)`.
- `DayScreen.read(_:)`, on a number row, trims with `Blank.trimmed` instead of
  `trimmingCharacters(in: .whitespaces)`. **One expression, and it is the whole of the fix**: the
  reading's three answers, its parse table, its thirty-eight-digit bound and its two causes are
  untouched, and measurement 2a shows every text an archived scenario names answers as it did.

The four asks being one function is the whole of the decision. It makes the state the delta forbids —
a commit that is neither a note nor a take-back — **unrepresentable rather than merely tested for**:
after the trim, what is left has a first character that is not whitespace, so `Note.init?`'s blank
guard cannot fire, and `noteRecord` can only return `nil` for a reason `enter` has already guarded.
Measured behaviour of the trim:

```
"  Ran 8k.  "              blank no   -> "Ran 8k."
"\n\nRan 8k.\n\n"          blank no   -> "Ran 8k."
"\tRan\t8k.\t"             blank no   -> "Ran\t8k."      (the interior tab stays)
"<NBSP>Ran 8k.<NBSP>"      blank no   -> "Ran 8k."
"Line one\nLine two"       blank no   -> "Line one\nLine two"
"  \n \t "                 blank yes  -> ""              (a take-back)
"<ZWSP>"                   blank no   -> "<ZWSP>"        (a note)
""                         blank yes  -> ""              (a take-back)
```

**A note of one zero-width space is a note, and that is deliberate.** It is the visible edge of
"judged exactly as a commitment name is": `Commitment.init?` accepts a name of one U+200B today
(measurement 1), so a person can already have a row whose name draws as nothing. Making the note
refuse it would need a second, wider definition of blank that the commitment does not have, and two
definitions is the thing this section exists to avoid. The delta pins it with an **AND** clause so
that nobody switches to a `CharacterSet` later and changes the answer without noticing.

**Rejected: `CharacterSet.whitespacesAndNewlines`** for the trim, which is the obvious Foundation
reach. It contains U+200B (measurement 1), so `"\u{200B}"` would trim to empty and be a take-back at
the screen while `Note.init?` would accept it as a note — the two answers this section exists to
prevent, and the very shape of the live defect measurement 2 found in the number.
**Rejected: moving the note onto the number's `CharacterSet.whitespaces`** so that both entries agree
without touching signed behaviour. It agrees by adopting the worse test: the note would stop trimming
line breaks, so a note typed with a trailing newline would keep it, and a commit of one newline would
be neither a note nor a take-back — and it would carry the deletion path into the note, where a
multi-line field makes a pasted zero-width space far easier to reach than a decimal keypad does.
**Rejected: leaving `read(_:)` alone and recording the defect.** That is what the grill settled and
what this delta said until the residual round; the owner reversed it once the measurement was in
front of them. The reasons it was reversed are worth keeping, because they are the reasons a similar
call gets made again: the harm was measured in the direction nobody had weighed, no archived scenario
breaks (measurement 2a), and the folder was not yet signed, so there was no second G4 to pay for.
**Rejected: trimming in `Note.init?` instead of at the screen.** `commitment`'s own requirement says
"Tidying what a person typed belongs where they typed it, not in the rule that decides what a
commitment is", and a note is judged as a name is. The record keeps what it is given; the screen,
which is where a person typed, is what tidies.

`docs/adr/1039` carries this decision. It is written about the whole package rather than about the
note, because after this change `DayScreen.swift` holds no second whitespace test to be "fixed"
towards — and the one `CharacterSet` left in the package, `CommitmentsScreen.nameTypedBackMatches`,
is named there with the reason it is a different question.

### A note entry says one thing, and a row still says none

`NumberEntry` says two things — the number and the range hint. `NoteEntry` says one, and the delta
states why rather than leaving it as an omission: a note commitment declares nothing, so there is no
bound to teach before it refuses anyone and nothing it will refuse anyone for. A placeholder telling
a person how to write would be this product deciding what their own words should look like, which
is on the wrong side of *Commitment name* and of the grill's answer 2.

The row holds the note and does not give it out, by the same shape #139 used for the number: `Row.note`
is internal and the only way out is `noteEntry(asOf:)`. A screen drawing a row has nothing to draw the
note with. That matters more here than it did for the number — a note is the one record long enough
that drawing it in the daily list would change what the list is for — and it is the grill's answer 7,
which was given **against** the recommendation and narrowed what this Story is.

`Row` is `Hashable` with synthesized conformance, so the stored `note` participates in equality, and
*A row is a commitment's line on a date* is modified to say so. That is the number's argument
applied unchanged: two rows of one note commitment on one date holding different notes offer
different entries and neither can stand in for the other.

**Rejected: `NoteEntry` carrying a hint of its own** — a word count, a character budget, a "two or
three sentences" nudge. Every one of them is a rule `record` does not have, and the delta would then
have to say what happens when it is broken. Nothing happens: there is no bound.

### `History` grows a third one-off reader, knowingly

`note(for:on:)` beside `number(for:on:)`, and `notes: [RecordedDay: String]` beside `numbers`. This
is the grill's answer 6, taken with its price named: **a twelfth face on `docs/open-questions.md`'s
public-surface gap**, in that a row now gives a note out through the entry it offers while still
giving no tick out, and `History` now answers three questions three ways.

The alternative — the general record reader all four kinds share — is deliberately **not** taken
here, though #138's deferral named this Story as one of the two that spend it. The reason is that
the total, not the note, is the record whose shape decides it: a total's record is a list of
additions rather than one value, and its take-back removes the last addition rather than the record.
A general reader designed now would be designed around three records that are all "one value keyed by
day" and would have to be redesigned the moment the fourth arrived. ADR-1033's own stated reversal
trigger is "when a note and a total are both recordable" — after #141, not after this.

### The form on disk moves to 4, and the shape guard reads a per-field constant

`RecordDocument.currentVersion` moves from 3 to 4 and gains `notes: [NoteRecord]?`, exactly as
`numbers` was added at 3. `RecordDocument.numbersIntroducedInVersion` already exists for this reason
and its doc comment predicted this move; `notesIntroducedInVersion = 4` joins it, and
`RecordStore.init` gains a second guard of the same shape:

```swift
guard (document.numbers != nil) == (document.version >= RecordDocument.numbersIntroducedInVersion),
      (document.notes   != nil) == (document.version >= RecordDocument.notesIntroducedInVersion)
else { throw RecordStoreError.notAStore(at: place) }
```

The delta says this in words — "judged against the form each part was first written at and never
against whichever form happens to be the newest" — because it is the one thing a fifth form will get
wrong if it is left implicit. `NoteRecord` conforms to `DatedCommitmentRecord` and sorts on the same
five-part key, so the file stays byte-stable.

**Rejected: one `records` array with a kind tag.** It would rewrite how ticks and numbers are
persisted, which is a migration of two forms to fix a shape nobody has complained about, and it is
the same premature generalisation § *`History` grows a third one-off reader* declines.

### `enter(_:on:)` dispatches on what the row offers, and not on the text

```swift
public func enter(_ text: String, on row: DayView.Row) throws {
    guard dayView.rows.contains(row) else { return }
    guard let recordStore else { return }

    if let entry = row.numberEntry(asOf: today) { /* unchanged, exactly as today */ }
    else if row.noteEntry(asOf: today) != nil   { /* the note's reading */ }
    else { return }
}
```

The number branch is not touched — same reading, same three answers, same causes. The note branch is
`Blank.saysNothing(text)` ? take back : `row.noteRecord(Blank.trimmed(text), asOf: today)`, added and
kept, with the same throw-and-notice on a write failure and **no cause ever named**. The final
`else` is the delta's fourth "told nothing" case, now a tick row and a total row rather than a tick
row, a note row and a total row.

`ContentView.swift` gains a multi-line field on a note row's tap, prefilled from `entry.note`, with
Save and Cancel; Save calls `try? screen.enter(text, on: row)`. None of that is a requirement
(`CONTEXT.md` § *App shell*) and none of it is tested, which is why `tasks.md` § 16.3 is a person
typing a paragraph on a phone and reading it back after a force-quit.

### ADR-1033 is amended in place, and its filename does not move

The grill's answer 9. 1033 currently reads as the *number's* decision; a note is taken back the same
way for the same reason, and a reader meeting two kinds that follow one number-shaped record has to
reconstruct it. The file is amended to be about **a record** taken back by naming the commitment and
the day, with the stamp `docs/adr/README.md` § 2 requires.

**The filename stays `1033-a-number-is-taken-back-by-naming-the-day.md`.** Renaming it would break
`openspec/changes/archive/2026-09-07-add-number-record/tasks.md` § 8, which names that path and
which `.claude/settings.json` denies editing. Title-and-filename drift is normal here — 1005, 1006,
1017, 1019 and 1031 all carry it — and a broken path in the archive is not.

## Risks / Trade-offs

- **This change edits behaviour a signed requirement describes.** → `read(_:)`'s trim is a
  requirement `add-number-entry` shipped four days ago, and reopening one is not free. Mitigated
  three ways: the edit is one expression, the MODIFIED requirement carries all eight archived
  scenarios forward unchanged, and measurement 2a puts every text they name through both trims and
  shows none answers differently. What is left is the two texts the fix exists for. The alternative
  was leaving a measured path by which a paste deletes a day's record, in a product whose whole
  argument is that a record is not lost.
- **A number entry now reads a lone line break as a take-back rather than as "Not a number".** →
  Accepted and pinned by a scenario. It is the second direction of the same inconsistency, and it is
  the answer a person would want: a text of three newlines says nothing, so it clears the day. A
  decimal keypad cannot produce it, so the path is a paste in both directions.
- **77 new scenarios in one change folder.** → Accepted, and it is the arithmetic of the grill's
  answer 1: this Story is #138's half plus #139's half, which were 38 and 37, plus the two the
  residual round added. The alternative was two Stories and two G4s for one kind, which G2 already
  weighed and declined.
- **A note of one zero-width space is a note that draws as nothing, and a number entry committed with
  one is now told "Not a number".** → Accepted, both pinned by scenarios and explained in § *One
  whitespace test*. It is inherited from `Commitment`, where the same is true of a name today, and
  closing it would take a second, wider definition of blank than the commitment has — which is
  exactly the two-definitions failure measurement 2 exhibits. A person who cannot see what they
  pasted is told something in the number entry and keeps something invisible in the note; neither
  loses a record, which is the property that was missing before.
- **Two spellings of one word are one note, so writing the day again with the other spelling is not
  a change.** → Accepted. Measurement 4: it is Swift's canonical equality, it is already how a
  commitment name behaves, and it is the answer a person would want. What is fenced is the other
  direction — nothing normalises on the way to disk — by a scenario in the store requirement.
- **A note of a million characters is kept, and the whole file is rewritten on every change**
  (ADR-1017). → Accepted, measured at 2 MB written atomically. A person reaching that has pasted a
  book into a journal field once; a bound of our own would be a number invented here, and the day it
  bites is the day someone loses the end of what they wrote.
- **A note row on a future day invites a tap it will not answer, and now so does its field.** → Not
  mitigated, deliberately, for the third time. B-035's third face, and whoever takes it finds all
  three named.
- **`History` now answers three questions three ways and gives no tick out.** → Accepted and
  recorded: the twelfth face of the public-surface gap, landed at G7 as #139's eleventh was.

## Migration Plan

Nothing to migrate by hand. Form 3 stores read back unchanged with no note on any day, and are
rewritten whole at form 4 the next time anything is kept at that place — ADR-1031, unchanged. The
eleven test fixtures that say `4` to mean *a form later than this app writes* move to `5`, which is
a mechanical step with no behaviour in it (`tasks.md` § 1).

## Open Questions

**None.** `grill.md` § *Left open* says "None." with its reason — twelve questions over four rounds,
every one answered. Writing the delta turned up exactly one thing the owner had to decide, it was put
to them as a residual round, and it is settled below. Nothing is outstanding.

**Settled at the residual round, 2026-09-08, before G4 — a paste of one invisible character silently
deleted a number a day already held.** Measurement 2 found that committing `U+200B` in a **number**
entry over a day holding 70.5 took the number back and said nothing, because `read(_:)` trimmed with
`CharacterSet.whitespaces`, which contains U+200B. The delta as first written left it, on the grill's
answer 5, and asked whether to fix it. **The owner answered: fix it.** So `read(_:)`'s trim moved onto
the same `Blank` this change introduces, the `day-screen` delta gained one MODIFIED requirement —
*A day screen reads what an entry is committed with as a number, as a take-back, or as neither* — and
that requirement gained two scenarios, one for each direction the two tests disagreed in. Nothing
else in either delta moved, and no archived scenario was rewritten (measurement 2a). `grill.md`
answer 5 was amended in place to record the reversal; the half of it that still stands is that blank
is `Character.isWhitespace`, in one place, for the whole package. ADR-1039 is written on the whole
package rather than on the note alone, and `tasks.md` § 16.5 no longer owes
`docs/open-questions.md` an entry about the defect, because it is closed here rather than recorded.

The two things `grill.md` § *Left open* carried rather than left open are both discharged here.
The whitespace inconsistency (answer 5) is § *Context* measurements 2 and 2a, and it is fixed rather
than only recorded. The requirement that every claim about what a note may hold carry a measurement
through `DayByDayKit` beside it is measurements 1, 3 and 4, each run against the real package rather
than a re-implementation of it.

Seven things writing the delta turned up and settled here rather than asking, and why each was not a
question:

- **Which whitespace test.** Not a preference: the grill named `Commitment.init?`'s test by name at
  answer 5, and measurement 1 shows the alternative would create a text that is neither a note nor a
  take-back. § *One whitespace test, in one place, and it is Swift's*.
- **Whether a note of one zero-width space is a note.** A consequence of the answer above rather
  than a decision of its own; the same is already true of a commitment name, measured. Pinned by a
  scenario so that it stays a decision.
- **Whether `CommitmentsScreen.nameTypedBackMatches` moves onto `Blank` too.** Not a preference and
  not this Story's: it asks *are these two names the same*, not *does this text say anything*, and it
  guards a confirmation gesture rather than a record. Named in § *Goals / Non-Goals* and in ADR-1039
  so the "one blank test" claim stays true rather than tidy.
- **Whether the screen gets a second way in for a note.** Settled against, on a stated hazard —
  two members of one signature answering each other's rows with silence — and it changes no scenario
  either way, since every one of them observes the day and the entry rather than which member was
  called.
- **Whether `NoteEntry` says a hint.** Settled against by the grill's answer 2: a note commitment
  declares nothing, so there is nothing true to say.
- **Whether `History` takes the general record reader now.** The grill answered it at 6; what the
  delta added is the reason it is the *total* rather than the note that would decide the shape,
  which is ADR-1033's own reversal trigger read literally.
- **Whether ADR-1033's file is renamed with its title.** Not a preference: the archive holds a path
  to it that permission settings forbid editing. § *ADR-1033 is amended in place*.
