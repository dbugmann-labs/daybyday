## Context

See `proposal.md` § *Why*, and `grill.md`, whose six settled answers, the grooming grill's seven
and the layout round this delta is written on. The facts it turns on, read off `origin/main`:

- **The span is the shell's alone today.** `LookBackView` holds a private `Span` — "Month", "3
  months", "Year", "All" — whose `lengthInDays` is 31, 92, 366 and `nil`; it sets how many days
  the plot holds in its width and nothing the Kit says. No spec names a span.
- **A graph already holds everything an average needs.** `LookBack.Graph.days` ends on the last
  day the look-back counts, and its `points` carry each day's place and value — a total's at its
  sum — with no point on a gap day or a day holding nothing. Its equality is synthesized over its
  stored properties.
- **A number is said as `Decimal`'s own description** (`LookBackWords.number`). Measured on this
  machine: `NSDecimalRound` to scale 1 in `.plain` mode, then that description, says 74.96 as
  "75", -1.75 as "-1.8", -0.04 as "0" and 72.25 as "72.3"; 244 / 3 is carried to 38 digits first.
- **The head card's rows already split label from value.** `LookBackDateRow` draws a shell label,
  uppercased, left and a Kit value right — "Kept from", "The whole".
- **`Roster.Span` exists**, internal, for a **days away**'s dates.

## Goals / Non-Goals

**Goals:** the delta, every rule drivable through `CommitmentsScreen.lookBack(at:)`; the page
drawing the average card of § *What the shell draws*, for the span picked.

**Non-Goals:** any change to the trend, the graph's bounds, its scroll or the picker's look;
remembering the span between visits; an average on a tick's, a quota's or a note's page; following
the scroll (`grill.md` § *Settled* 3).

## Decisions

### The seam

```swift
public enum LookBack.Span: CaseIterable, Hashable, Sendable { case month, threeMonths, year, all }
public var LookBack.Span.lengthInDays: Int? { get }
public func LookBack.Graph.averageInWords(over span: LookBack.Span) -> String?
```

All three are new and reached through the existing seam, `CommitmentsScreen.lookBack(at:)`. A test
asks `lookBack(at:)?.graph?.averageInWords(over:)` and compares the string; "no average" is `nil`.

### The span crosses the seam, and the shell reads its lengths from it

The Kit owns the four spans and their lengths, and `LookBackView` drops its private enum for
`LookBack.Span`, keeping only the picker's titles. The 31 the plot opens on and the 31 the average
takes in are then one number, and the grill's "provable at the seam" holds.
- *`averageInWords(lastDays: Int?)`, the lengths left in the shell:* rejected — 31, 92 and 366
  would be tested nowhere, and the two could drift.
- *`lookBack(at:over:)`, a look-back formed per span:* rejected — a whole walk of the history again
  on every tap of the picker, for one figure.

### A method on the graph, not a stored figure

The average is worked out from `points` and `days.count`, which the graph already holds, so the
graph's equality does not grow, and a look-back with no graph has no average by construction.
- *Four stored strings on `Graph`:* rejected — equality would grow by values derived from members
  it already compares.
- *A member of `LookBack`:* rejected — a tick's, a quota's and a note's would need a rule saying
  `nil`, where on `Graph` they have nothing to ask.

### The seam hands the figure; the shell draws "Average"

`averageInWords(over:)` answers "81.3", and the page draws it in a `LookBackDateRow` labelled
"Average", as "The whole" is drawn. This answers the designer's question (`grill.md` § *Left
open*); the label is in the wireframe and the walk shows it.
- *"Average 81.3" whole:* rejected — the row sets the figure right of the label, so the shell
  would split the Kit's string again.

### A halfway average below zero rounds away from zero

The grill said "half up", which for a positive is the same thing. Below zero the delta rounds
away from zero, -1.75 to "-1.8", so an average and its negation say the same digits; it is
`.plain`'s own rule, and no "-0" is said.
- *Toward the greater value, -1.75 to "-1.7":* rejected — "1.75" and "-1.75" would round apart.

### "Span" names the picker's choice

The grill and `CONTEXT.md` already say "the span"; this delta lands **Span** as a term, saying it
is not a days away's dates. `Roster.Span` is internal and nested, so the names never meet.
- *A fresh word:* rejected — it would rename what the grill's answers and *Average* already say.

### What the shell draws

Option C, under the graph, with the word, chosen at the layout round from
https://claude.ai/artifact/2z3HzjHdGFWk17Hfkus2V9. The total's page is the same with no Trend
button, the picker taking the full row, and "Average 95".

```
C · Under the graph
‹
Weight
Every day
┌──────────────────────────┐
│ KEPT FROM    1 June 2026 │
└──────────────────────────┘
[Month|3 months|Year|All] Trend
┌──────────────────────────┐
│86 ────────────────────── │
│   ╱╲_╱‾╲_╱‾‾╲_╱‾╲        │
│71 ────────────────────── │
│  19 Sep 2026  10 Oct 2026│
└──────────────────────────┘
┌──────────────────────────┐
│ AVERAGE             81.3 │
└──────────────────────────┘

No point in span: the card goes; nothing above moves.
```

## Risks / Trade-offs

- [A long run of thirty-eight-digit values loses its last digits when summed] → `Decimal` holds
  38; the figure is said to a tenth, and no such history is plausible. Accepted, untested.
- [The page's span and the Kit's drift] → the shell reads `lengthInDays`, and § 3 of `tasks.md`
  checks the private enum is gone.
- [A sibling Story lands on `look-back` before G4] → `tasks.md` § 1 re-runs `openspec validate`
  against current `main` before any test is written.

## Open Questions

None. The grill left none open; the one question it handed on, figure or whole words, is settled
above under *The seam hands the figure*. Writing the delta raised one edge the grill did not reach —
a halfway average below zero — and it is decided above rather than asked, since its answer is a
matter of symmetry and moves one AND clause.
