## Context

See `proposal.md` § *Why*, and `grill.md` for what was settled. The facts this design turns on:

- `LookBack.form(for:keptUntil:entries:today:history:)` builds a graph for a number and returns a
  head alone for a note and a total. `LookBack.graph(from:through:eras:history:)` walks the span a
  day at a time, reading each day against `era(holding:in:)`; `walkDays` is the tick's and quota's.
- `Addition.init` refuses an amount not above zero, and `History.removeLastAddition` drops the day's
  key with its last amount, so a day's `History.total(for:on:)` is above zero exactly where it holds
  an addition. `History.isKept(_:on:)` judges a total's day as its sum against its commitment's
  target, `>=` — the rule the day screen's row is ticked by.
- A target change puts a new era (`Commitment.Kind` carries the target), kept from the
  screen's today, the older era kept until the day before; a chain's eras are contiguous.
- The day screen's row says `"\(total) of \(target.amount)"`. Measured on this toolchain: a
  `Decimal` sum past thirty-eight significant digits interpolates as plain digits, rounded, no
  exponent — so the look-back says what the row says, whatever the store holds.
- `LookBackView` draws a graph with Swift Charts: one `LineMark` series in the secondary colour
  with a circle symbol, bounds in a pinned lane, the picker's four spans, and "No number yet." for a
  number page with no graph. A `Commitment.Target` is above zero, so a total's bounds never meet.

## Goals / Non-Goals

**Goals:** a total's page saying each day's sum against what that day was owed; one graph type for
both kinds that plot, so the shell's card, picker and scroll serve both; every word in the kit.

**Non-Goals:** a note's page (#276); any figure, line or whole for a total (grill decision 3); the
day screen's row; `Roster`, `Commitment`, `History`, `Schedule`; the `walkDays` split.

## Decisions

### The seam

```swift
public let LookBack.Graph.targetRule: [LookBack.Graph.Stretch]
public struct LookBack.Graph.Stretch: Hashable, Sendable
public let LookBack.Graph.Stretch.from: Int
public let LookBack.Graph.Stretch.through: Int
public let LookBack.Graph.Stretch.target: Decimal
public let LookBack.Graph.Stretch.inWords: String
public let LookBack.Graph.Point.isKept: Bool?
static func LookBackWords.sum(_ sum: Decimal, of target: Decimal) -> String
```

`CommitmentsScreen.lookBack(at:)` and every shipped member keep their signatures. For a total,
`Point.value` is the sum and `Point.inWords` says "150 of 120"; `lowest`/`highest` and their words
are the delta's bounds. `targetRule` is empty and `isKept` is `nil` on a number's graph.
`LookBackWords.sum(_:of:)` is internal beside the rest of that table, built on `number(_:)`.

### One graph, not a second type

A total's graph is a number's plus a rule and a mark: the same days, months, points and bounds,
the same card. Rejected: a `TotalGraph` beside `Graph`, which duplicates five members and splits
the shell's card in two for two additions.

### A point is where the sum is above zero, and kept is `History.isKept`

The walk reads `total(for:on:)` against the era holding the day and makes a point where it is above
zero — the addition rule above makes that exactly "holds an addition". Kept is `isKept` against the
same era's commitment, so the page and the day screen's row cannot disagree about a day. Rejected:
a public `History` member naming a day that holds additions, a new seam for a fact already carried.

### `isKept` is optional

`nil` on a number's point says the graph judges nothing there (ADR-1045); `false` would say "not
kept" of a kind that is never judged. Rejected: a `Bool` with the shell checking the kind.

### The rule is stretches, not a target per day

Each stretch carries its first and last day as places in `days`, like a point, so the shell draws
one dashed segment and one label per stretch and never finds a step itself. Consecutive eras owing
one target share a stretch, which is what keeps #300's boundary silent. Rejected: a target per day,
which puts the step-finding, a rule, in the shell (ADR-1019).

### The graph walk grows; `walkDays` is not reached

A total says no line and no whole, so its points and rule come from the graph's own walk, which
gains a branch on the kind. `docs/open-questions.md` § *`LookBack.walkDays` does five jobs* says the
tally-pass split is owed by #275 "if it reaches the function"; it does not, so the split stays owed.

### The shell rides this Story

ADR-1019's three conditions hold: `LookBackView` is the immediate consumer, it adds no behaviour
the kit does not specify, and it is `tasks.md` § 8. Each stretch is a dashed segment in the
secondary colour from `from` to `through` at its target, with no riser between two (the wireframe).
Each is labelled with its `inWords` at its last day: the newest at the rule's newest end, each
earlier one where the rule steps (grill decision 14). A kept point is ringed; one not kept is the
shipped dot in the secondary colour; a number's points are drawn as now. A total whose look-back
says no graph says "Nothing added yet." and draws no picker (grill decision 8); picker, spans and
scroll are the number's. None of it is a rule: position, dash and ring cross no seam.

### Migration

None — additive. No persisted type and no encoding changes; a look-back only reads.

### The records

ADR-1045 is amended for the kept mark, which goes past its 2026-09-17 amendment's "marks no day
kept". `CONTEXT.md` § *Target rule*, § *Look-back* and § *Graph* are the grill's; this delta adds
**stretch** inside § *Target rule*, where the spec needs the word.

### What the shell draws

**Option A**, ringed when kept, chosen at the grill's layout round from three at
https://claude.ai/artifact/9TodyrPaTtpnUGDSYmS8TY. The wireframe is `grill.md` § *Layout*,
verbatim; the rule's label (grill decision 14) was settled after it and is not drawn in it.

```
Option A — Ringed when kept   (recommended)

+------------------------------------------+
| <            Protein                     |  nav bar: back, and the name
| Protein                                  |  .largeTitle.bold
| Every day                                |  .subheadline, secondary
| +--------------------------------------+ |
| | KEPT FROM          1 September 2025  | |  dates card, unchanged
| +--------------------------------------+ |
| [ Month | 3 months |  Year  |   All   ]  |  picker, unchanged; Month on opening
| +--------------------------------------+ |
| | 150 |------------------------------- | |  gridline at the top bound, as shipped
| |     |  (•)     (•)                   | |
| |     |- -(•)- - - -•- -(•)           | |  target rule: dashed, secondary, the
| |     |   /  \ /  \/  \   \           | |  whole dates axis; 120 through 3 March
| |     |  •    •        \   (•)- - - - | |  then 100 from 4 March — the rule jumps,
| |     |                 •  /  \ (•)   | |  no vertical riser
| |     |                    •    •     | |
| |   0 |_______________________________| |  kept point: the shipped dot in the
| |      18 February 2026   10 March 2026 | |  label colour, ringed; not kept: the
| +--------------------------------------+ |  shipped dot, secondary, no ring
+------------------------------------------+  trace: secondary, joined across gaps
```

## Risks / Trade-offs

- A stretch a day or two long puts its label on top of the next one's. → Layout, not a rule; the
  walk's second picture shows a step, and a collision is a G7 finding fixed without a delta.
- An axis from zero flattens a total that always lands near its target. → Grill decision 4: a sum
  is an amount, and the rule, not the axis, is what a day is read against.
- The ring is the graph's first mark of kept. → The owner's call against the recommendation, on
  the record in ADR-1045; nothing marks a day missed, and the day screen shows none of it.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason, and every edge the delta turned up —
the taken-back addition, the equal-target boundary, the older era's higher target — follows from a
settled decision and is recorded above. The designer's note on colliding month labels at All is
#274's graph; the walk's third picture shows it. No residual round is outstanding.
