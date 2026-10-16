## Context

See `proposal.md` § *Why*, and `grill.md`, whose nine settled answers and layout round this delta
is written on. The facts it turns on, read off `origin/main`:

- **A history answers a decline by day.** `History.decline(for:on:)` keys by the commitment, whose
  equality is its identity, so a decline formed against an earlier era is found from any era of
  the chain. A day holding a decline holds no other record of that commitment (ADR-1068).
- **A decline forms only on a day its commitment is due**, never for a weekly quota; but
  `Schedule.isDue` answers true on every day of a quota, and a rhythm change can leave an older
  era's decline on a day a newer era holds and is not due on.
- **`walkDays` counts a tick's due and kept days per month** in a private `MonthTally`, on the one
  branch where a non-quota era holds the day and is due on it; a number's, a total's and a note's
  look-back walk their days separately and count nothing due.
- **`LookBack.Line.month(inWords:fraction:)`** is matched by position in twelve places — eleven in
  `LookBackTests.swift`, one in `LookBackView.swift` — and constructed by label in 23 places across
  four test files.
- **The head card's rows split label from value**: `LookBackDateRow` draws a shell label, uppercased,
  left and a Kit value right — "Kept from", "The whole", and "Average" under the graph.

## Goals / Non-Goals

**Goals:** the delta, every rule drivable through `CommitmentsScreen.lookBack(at:)`; the page
drawing the "Declined" row and the month caption of § *What the shell draws*.

**Non-Goals:** listing declined days or their reasons (`docs/backlog.md`); marking a graph; any
change to a fraction, the averages, the notes or a week line; a count that follows the span picker
(`grill.md` § *Settled* 3, 6, 7).

## Decisions

### The seam

```swift
public let LookBack.declinedInWords: String?
case LookBack.Line.month(inWords: String, fraction: String, declinedInWords: String? = nil)
static func LookBackWords.declined(_ count: Int) -> String
```

Reached through the existing seam, `CommitmentsScreen.lookBack(at:)`. A test compares
`declinedInWords` — "4", or `nil` for no declined count — and a month line by equality, as the
carried tests already do; `LookBackWords.declined(_:)` is internal and answers "3 declined".

### The month count rides the month case, with a default

The month case gains a third associated value defaulting to `nil`, so every carried constructor
compiles and equals a line with no declined day, as every carried fixture is. The twelve positional
matches gain one `_` and nothing else, the only carried edit the change makes.
- *A parallel `[String?]` beside `lines`:* rejected — two arrays kept in step by position.
- *`Line` as a struct:* rejected — every carried test that builds or matches a line would move.

### The count is stored, and decided where due is

`declinedInWords` is a stored member counted over the whole reach, so no span reaches it. On a
tick the month tally counts a decline on the branch that already counts the day due, and the page
count sums the months; the other kinds count by the same predicate — the era holding the day, not
on a quota, due on it, holding a decline — in the walk they already make.
- *A method taking a `Span`:* rejected — the grill fixed one reach (`grill.md` § *Settled* 7).

### A decline the look-back does not count due is counted nowhere

A decline on a gap day, after the last day counted, on a quota era's day, or on a day the holding
era is not due on adds to no count. A declined day is an owed day not kept (`CONTEXT.md`
§ *Declined*); where no day is owed there is nothing declined, and the month counts then sum to the
page count by construction. Decided rather than asked: both edges follow from the settled meaning.
- *Count every decline in reach:* rejected — the page count could exceed its month counts.

### The Kit hands the figure; the shell draws "Declined"

`declinedInWords` answers "3" and the page draws it in a `LookBackDateRow` labelled "Declined",
as "The whole" and "Average" are drawn. The month caption is one string, "3 declined", which the
Kit says whole because the caption has no label to split from.

### What the shell draws

Option A, the count as a caption under the month, chosen at the layout round from
https://claude.ai/artifact/6zREdFBmhXsTChsytPzyXP.

```
A · Under the month                          (recommended)
‹
Run                                         .largeTitle, nav bar
Mon, Wed, Sat                               .subheadline, secondary
┌──────────────────────────────────────┐
│ KEPT FROM             5 January 2026 │    head card; KEPT UNTIL under
│ ──────────────────────────────────── │    KEPT FROM where stopped
│ THE WHOLE                    105/122 │
│ ──────────────────────────────────── │
│ DECLINED                           6 │    only above zero; last row
└──────────────────────────────────────┘
  Months                                    .headline
  October 2026                     4/6      fraction on the month's
  1 declined                                first baseline; count is
  ────────────────────────────────────      .caption, secondary, under
  September 2026                  9/13      the name
  3 declined
  ────────────────────────────────────
  August 2026                    13/14      no decline: one line, as today
  ────────────────────────────────────
  July 2026                      10/13
  2 declined
  ────────────────────────────────────
  ... one line per month, newest first; a week line never holds a count

Number, total, note page: the same head card with no THE WHOLE row,
so DECLINED sits under KEPT FROM (or KEPT UNTIL). The graph, picker,
average card and notes are unchanged.
```

## Risks / Trade-offs

- [A carried test edited beyond the added `_`] → `tasks.md` § 2.1 names the twelve matches as the
  only carried edit; any other is a stop.
- [The walk's history spans three months] → the define sheet's "Kept from" picker takes a past day
  and the day screen reaches any past day, so it is typed, never seeded.
- [A sibling Story lands on `look-back` before G4] → `tasks.md` § 1 re-runs `openspec validate`
  against current `main` before any test is written.

## Open Questions

None. The grill left none open. Writing the delta raised two edges it did not reach — a decline on a
weekly quota era's day and one on a day the holding era is not due on — and both are decided above,
under *A decline the look-back does not count due is counted nowhere*, because each follows from the
settled meaning of a declined day rather than from a preference.
