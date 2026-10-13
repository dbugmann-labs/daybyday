## Context

See `proposal.md` § *Why*, and `grill.md`, whose four settled answers and layout this delta is
written on. The facts it turns on, read off `origin/main` at 99bf62e:

- **`History` keeps a day's additions in the order they were made**, privately, and gives out only
  their sum through `total(for:on:)`; `removeLastAddition` removes the last one appended.
- **`DayView.Row` holds the day's sum and never its additions**, and its synthesized equality is
  every stored property. `offersTakeBackLast(asOf:)` is `totalEntry(asOf:) != nil && total > 0`.
- **The sum and the usual amounts are said by `Decimal`'s own description** — `"\(total) of …"` —
  so "0000030.50" reads as 30.5, and thirty-eight nines are said whole.
- **The label is the shell's alone**: `ContentView.swift` draws `Button("Take back last", role:
  .destructive)` where `offersTakeBackLast(asOf:)` is true. No spec and no UI test names it.
- **Three shipped rules close the amount off**: `record`'s "SHALL NOT give out the additions
  themselves", `day-screen`'s "SHALL NOT ask for the additions themselves", and `day-screen`'s row
  equality, "the same row where their days' additions differ but sum alike". `grill.md` names the
  first two; the third is this delta's finding.
- **A probe adding the last addition to the row**, run on a scratch copy of the Kit, turned exactly
  one carried test red: *two rows whose days hold different additions summing alike are the same
  row*.

## Goals / Non-Goals

**Goals:** the delta, every rule drivable through `DayView.Row`, and the sheet drawing the row's
words in place of its fixed label.

**Non-Goals:** listing a day's additions (`grill.md` § *Settled* 1); any change to the sheet's
layout, role or what a tap does; condensing the carried MODIFIED requirements, which an editorial
Story would do under ADR-1047.

## Decisions

### The seam

```swift
func History.lastAddition(for commitment: Commitment, on date: CalendarDate) -> Decimal?
let DayView.Row.lastAddition: Decimal?
public func DayView.Row.takeBackLastInWords(asOf today: CalendarDate) -> String?
```

All three are new. `offersTakeBackLast(asOf:)` keeps its signature, and `takeBackLastInWords` is
`nil` exactly where it answers `false`. Acceptance tests attach at `DayView` and `DayScreen` as the
carried total scenarios do. A test that reaches `History.lastAddition` does so through
`@testable import`, as ten test files already do.

### The words are the row's, said whole by the Kit

The row gives back "Take back last (35)" entire, and the shell draws it as given (ADR-1019).
- *A field on `TotalEntry`:* rejected. A total entry "SHALL say exactly two things", and the
  take-back is "a second thing the row offers, beside the entry".
- *The amount alone, with the shell writing the label:* rejected. The brackets would be a rule that
  only the walk shows, and the words would be the shell's to decide.

### `record` loosens one prohibition and gains no member it gives out

The sentence becomes "SHALL NOT give out any addition but the day's last". The query is
package-internal, specified only through what the row says — the shape
`start-a-number-from-the-last-one` gave `latestNumber(for:before:)`.
- *A public `History` member with its own `record` requirement:* rejected — a second capability's
  surface for a question only the day screen asks.
- *Leaving `record` untouched:* rejected — its sentence forbids exactly this.

### The row holds the last addition, so what a total row is grows by it

Two rows saying different take-back words cannot be the same value (*A day view is a value and
nothing else*). The MODIFIED *A row is …* says so, and its two scenarios pin both directions.
- *Custom equality leaving it out:* rejected — a row equal to a stale one has kept a list row
  undrawn before.

### The carried title stands, and its fixture changes

`openspec` 1.10.0 refuses a MODIFIED block that drops a scenario, so *two rows whose days hold
different additions summing alike are the same row* keeps its title. Its fixture now ends alike —
30 and 30 against 10, 20 and 30 — and the old fixture, 30 and 30 against 60, becomes the new
"different rows" scenario. Its test is the one carried test this change edits.

### The carried requirements are over budget as shipped

*A history answers what a commitment has added …* and *A row is …* exceed 150 words before this
delta. Each changes one sentence here and is not condensed (Non-Goals).

### What the shell draws

No mockup: the `designer` found no layout question (`grill.md` § *Layout*). The sheet is as
shipped, with only the take-back's label changed:

```
┌───────────────────────────────┐
│ Cancel     <name>        Save │
│         <soFarOfTarget>       │
├───────────────────────────────┤
│ [ amount field            ]   │
├───────────────────────────────┤
│ <usual amount>  <name>        │
│ ...                           │
├───────────────────────────────┤
│ Take back last (20)           │  ← destructive role, as shipped
└───────────────────────────────┘
```

## Risks / Trade-offs

- [A long amount wraps the label] → a sum past thirty-eight digits is refused, and the designer
  found that "Take back last (12.5)" fits. A thirty-eight-digit amount may wrap. That is accepted,
  and no walk picture shows it.
- [A sibling Story lands on `day-screen` before G4] → `tasks.md` § 1 re-runs `openspec validate`
  against current `main` before any test is written.

## Open Questions

None. The grill left none open and asked the three edges this delta turns on: the words, a decimal
amount and the walk. Where the shipped rules are loosened is settled above, under *Decisions*, and
writing the delta raised no question that only the owner could answer.
