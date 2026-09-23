## Context

See `proposal.md` § *Why*, and `grill.md` for what was settled. The facts this design turns on:

- `LookBack.form(for:keptUntil:entries:today:history:)` answers a note's look-back as a head alone,
  through the branch it shares with nothing else. `era(holding:in:)` finds the era holding a day.
- `History.note(for:on:)` answers a day's text, keyed by `RecordedDay`, whose commitment compares by
  identity (ADR-1059), so every era of a chain reads the same notes. `Note.init` refuses a day the
  commitment is not due on, so a day holds at most one note and only a due day holds one.
- `DayScreen` trims a note with `Blank.trimmed` before it is recorded; what the record holds is what
  the look-back says. A note may hold line breaks.
- `LookBackWords.day(_:)` says "14 March 2026" and `number(_:)` says digits, no separator.
- `LookBackView` sends a note page to `linesSection`, which says "Nothing is counted here yet."; the
  number and total pages say "No number yet." and "Nothing added yet." in the shell. No look-back
  row is tappable today.

## Goals / Non-Goals

**Goals:** a note's page reading as a journal, newest first; the count and every word said in the
kit; the fold drawn by the one layer that can measure it.

**Non-Goals:** editing a note from the page (it is still changed only in its day-screen row); going
to the day screen from a note; any search, filter or picker; `History`, `Note`, `Roster`,
`DayScreen`; the boundary requirement, whose first sentence already covers every look-back.

## Decisions

### The seam

```swift
public let LookBack.notes: [LookBack.DatedNote]
public let LookBack.noteCountInWords: String?
public struct LookBack.DatedNote: Hashable, Sendable
public let LookBack.DatedNote.dayInWords: String
public let LookBack.DatedNote.text: String
static func LookBackWords.notes(_ count: Int) -> String
```

`CommitmentsScreen.lookBack(at:)` and every shipped member keep their signatures. `notes` is empty
and `noteCountInWords` is `nil` on every kind but a note, and on a note that says no note.
`LookBackWords.notes(_:)` is internal beside the rest of that table, built on `number(_:)`.

### Notes are a list of their own, not a third kind of line

`LookBack.Line` stays a month or a week: the boundary requirement says a look-back's lines are those
alone, and the shell's heading reads the cases `lines` holds. Rejected: a `.note` case on `Line`,
which breaks both and gives a note a fraction slot it never fills.

### A walk of the span, reading the era holding each day

The note branch walks the days it counts, oldest first, as the graph walk does, reads
`note(for:on:)` against `era(holding:in:)`, and reverses. The span alone bounds it, so no note after
the day kept until is said. Rejected: `History`'s dates of any record, filtered — a new reach into
the record for a fact the walk already carries; and widening `walkDays`, which is still owed its
split (`docs/open-questions.md`) and does not reach a note.

### The count is the kit's; the empty sentence is the shell's

The singular and the count's absence at zero are rules a test must assert, so the kit says them.
"No note yet." stands where "No number yet." does, in the shell, because it is drawn where the kit
says no note. Rejected: an `Int` the shell words, which leaves the singular untested (ADR-1022).

### The fold is drawn, not said

Whether a note runs past two lines depends on the screen's width and the text size, so the kit says
every note whole and the shell folds it (`grill.md` § *Left open*). The shell measures each card —
the text at two lines against the same text unlimited, at the card's width — and only a note cut
there is a `Button`; the whole card toggles it (grill 9, 15). Which cards are open is view state, a
set of places in `notes`, empty on every visit (grill 10). Nothing about the fold crosses the seam,
as the picker's span does not. Rejected: a kit flag by character or line count, wrong at any width
but one; a read-only sheet (grill 4).

### The shell rides this Story

ADR-1019's three conditions hold: `LookBackView` is the immediate consumer, adds no behaviour the kit
does not specify beyond the fold's drawing state, and is `tasks.md` § 5. A note page draws the head
and dates card as shipped; then, where `noteCountInWords` is set, it as a `.headline` in the
"Months" heading's place and one card per note in the dates card's fill and radius, the day in
`.caption` semibold and not uppercased, the text beneath it at `.lineLimit(2)` with a tail ellipsis
while folded and unlimited while open, line breaks as written. The cards sit in a `LazyVStack`, and
opening one is animated by the platform. Where `notes` is empty the page says "No note yet." and
draws no heading. The tick, quota, number and total pages keep their sentences.

### Migration

None — additive. No persisted type and no encoding changes; a look-back only reads.

### The records

ADR-1045 is amended: the count is a figure beside the record, on the record's side of its line
because it is never out of the due days, never a fraction and never on the day screen. `CONTEXT.md`
§ *Look-back* is the grill's amendment; the delta turned up no term beyond it.

### What the shell draws

**Option B**, a card per note, chosen at the grill's layout round from three at
https://claude.ai/artifact/JUSsgC44jQkmcXFHiB91jA. The wireframe is `grill.md` § *Layout*, verbatim.

```
 ( < )        Journal
 Journal
 Every day
 ┌──────────────────────────────┐
 │ KEPT FROM     1 January 2026 │
 └──────────────────────────────┘
   38 notes                    <- headline, the "Months" heading's place
 ┌──────────────────────────────┐
 │ 21 September 2026            │  <- caption semibold, not uppercased
 │ Quiet day.                   │
 └──────────────────────────────┘
 ┌──────────────────────────────┐
 │ 20 September 2026            │
 │ Three things today:          │
 │ – finished the draft…        │
 └──────────────────────────────┘
```

## Risks / Trade-offs

- The measurement misjudges an edge — a note of exactly two lines, a larger text size — and a note
  that fits is tappable, or one cut is not. → The walk's first two pictures show both kinds; a miss
  is a G7 finding fixed in the shell without a delta.
- A different text size makes a different set of notes tappable. → Grill decision 9 accepts it:
  what is tappable is exactly what looks tappable at the size in use.
- Years of daily notes are a long page and a long walk of days. → `LazyVStack` draws what is in
  view; the day walk is the one every look-back already takes, once per visit.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason, and the one fact it hands on — that only
the shell can tell a cut note — is decided above under *The fold is drawn, not said*. The edges the
delta turned up, a note after the day kept until and a taken-back note, follow the number's
settled rules. No residual round is outstanding.
