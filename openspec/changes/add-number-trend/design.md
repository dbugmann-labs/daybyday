## Context

See `proposal.md` § *Why*, and `grill.md`, whose settled answers 1–7 and § *Layout* this delta is
written on. The facts the shape turns on, read off this worktree:

- `CommitmentsScreen.lookBack(at:)` answers a `LookBack` whose `graph` is formed by
  `LookBack.graph(from:through:eras:history:)`, one walk of every calendar day of the span. A
  point's `day` is its place in `days`, and `days` holds every calendar day, gap days included, so
  two places differ by exactly the calendar days between them.
- The graph says a point only on a day an era holds that holds a number: none for a gap day, none
  after the day kept until. A number's graph with no point is `nil`; a total's points carry `isKept`.
- `LookBackView` holds `span` as `@State`, so a new visit opens on Month; it draws the trace as one
  `LineMark` series in `Color.secondary` with no `series:` value, and picks a tapped point from
  `graph.points` alone.
- `.toggleStyle(.button)` already draws the commitments screen's Reorder button and the define
  sheet's weekday chips.

## Goals / Non-Goals

**Goals:** the trend's every rule under Kit test at the existing seam; the shell drawing layout C
and deciding nothing but whether the trend is shown.

**Non-Goals:** a trend on a total (grooming grill); the trend said in words anywhere (grill 5); a
remembered switch (grooming grill); any change to the values axis, the dates axis, the tap or the
trace itself.

## Decisions

### The seam

```swift
public let trend: [TrendPoint]                                                        // LookBack.Graph
public struct TrendPoint: Hashable, Sendable { public let day: Int; public let value: Decimal }  // LookBack.Graph
```

`CommitmentsScreen.lookBack(at:)` is the seam, unchanged; every new scenario's test reads
`lookBack(at:)?.graph?.trend`. `day` is a place in `days`, as a point's is.

### The trend is the Kit's, formed from the points after the walk

Once `graph(from:through:eras:history:)` has its points, each point gives one trend point: the
`Decimal` sum of the values of the points whose `day` lies within six places before its own,
divided by their count. Reading the points rather than the record is what makes the era, gap and
day-kept-until rules hold with no rule of their own, since a gap day's number was never a point.
- *Rejected:* averaging in the shell — a rule no test reaches, against ADR-1019.
- *Rejected:* reading `history` for each window day — it would take in a gap day's number.
- *Rejected:* a separate `trend(at:)` on the screen — a second seam for a value the graph owns.

### `Decimal` division, no rounding, and no words

The value is `sum / Decimal(count)`, Foundation's own `Decimal` division, kept as it comes; the
shell plots it through `NSDecimalNumber.doubleValue` as it plots a point. No `inWords`: the trend
is read as a trace (grill 5, 6), and a value said in words would need a rounding rule the look-back
does not have (`spec.md` § *A look-back says a number as its digits*).
- *Rejected:* rounding to the inputs' fraction digits — a rule nothing asked for.
- *Rejected:* `Double` on the seam — the graph's values are `Decimal` throughout.

### None is an empty array, and the axis does not move

A total's graph carries `trend: []`; a number's graph always has a point, so its trend is never
empty, and the shell offers the button exactly where `!graph.trend.isEmpty` (grill 3). An average
lies between the least and greatest values it takes in, so `lowest` and `highest` hold every trend
point already and their rule is untouched.
- *Rejected:* `[TrendPoint]?` — two ways to say no trend.

### The shell (ADR-1019: no rule the Kit does not state)

`LookBackView` gains `@State private var showsTrend = false`, so every visit opens with it off and
nothing is remembered, as `span`. Where `!graph.trend.isEmpty`, the span picker and a `Toggle`
labelled "Trend" share one row: the toggle drawn with `.toggleStyle(.button)` in a capsule of about
80pt, tinted with the accent when on; the picker takes the rest of the row. A total's look-back
keeps the picker full width. A change of span leaves `showsTrend` alone (grill 4). On, the chart
draws a `LineMark` through `graph.trend` in `Color.primary`, about 2.5pt, no symbol, under its own
`series:` value so it never joins the trace, laid over the unchanged trace and its dots; never in
the accent (ADR-1045). The tap still picks from `graph.points` only and its callout says that
point's words, trend on or off (grill 6).

### What the shell draws

Option C, *beside spans*, chosen at the layout round from
https://claude.ai/artifact/8dSvPpuYaNXVwizcnGP7on — the owner's call against the designer's A.

```
C · Beside spans
┌───────────────────────────┐
│ ‹                         │
│ Weight            (large) │
│ Every day      (subhead)  │
│ ┌───────────────────────┐ │
│ │KEPT FROM 1 August 2026│ │
│ └───────────────────────┘ │
│ [Month|3mo|Year|All](Trend)│
│ ┌───────────────────────┐ │
│ │75.2 ─────────────────  │ │
│ │     ·╲ ·━━━·  ·        │ │
│ │       ━━·  ╲━━━ ·╱     │ │
│ │71.6 ──────────╲━━━━━── │ │
│ │ 5 September   25 Sept… │ │
│ └───────────────────────┘ │
│                           │
│                           │
└───────────────────────────┘
 · grey trace, dots, as today   ━ the trend: label colour, about 2.5pt, no dots, drawn over the trace
 (Trend) a button, accent-tinted when on
```

## Risks / Trade-offs

- **The trend joined into the trace**, since the trace's `LineMark` carries no `series:`. → Both
  marks get a `series:` value; W.2 shows two separate traces.
- **"3 months" cut short in the narrowed picker at larger text sizes**, the cost named at the
  layout round. → Accepted there; a G7 finding if it truncates at the default size.
- **The walk's history must be typed.** `pnpm run walk` uninstalls the app first and the shell has
  no seeding hook, so W.3's months of numbers are entered through the day screen, which makes a long
  walk. → No hook is added for it; a step that cannot be driven is a stop.
- **A carried test comparing two whole look-backs** gains a field on both sides alike, and stays
  green.

## Open Questions

None. `grill.md` § *Left open* is "None.", and the one thing it left to this design — how precisely
an average is carried — is decided above. Writing the delta turned up no question for the owner.
