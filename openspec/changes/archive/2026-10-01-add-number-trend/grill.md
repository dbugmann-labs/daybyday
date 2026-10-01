# Grill — add-number-trend

*8 questions over 3 rounds, 2026-09-30 to 2026-10-01 — the third the layout round — after the grooming grill of B-070.*

Story #369, under `FEAT: look-back` (#271), `EPIC: Looking back` (#269). Intent: a number
commitment's look-back gets a switch that draws a trend over its graph — the seven-day average of its
numbers. Blocked by nothing. The grooming grill of B-070 settled what the trend is, and `CONTEXT.md`
§ *Trend* holds it; the `docs/backlog.md` *Decided* line for B-070 carries the same answers. What
#274's `grill.md` settled for a number's graph, and #300's for an era boundary, stands unless a line
below says otherwise.

Settled at the grooming grill, restated so this file stands alone: **numbers only**, never a total's
graph; for a day, **the average of the numbers held in the seven calendar days ending on it**; it
**stops at the last day the graph counts** and is never a forecast; it **crosses an era boundary and
a gap the way the graph's trace does**; it is **shown only when the switch on the look-back is on**,
and the switch **opens off on every visit and remembers nothing**, as the span does — the owner's
call against the recommendation that it always be drawn. The word is **trend**, never "trend line",
because a line on this page is a row of text.

Two fact agents, no fact sent to the owner: the seam is `CommitmentsScreen.lookBack(at:)`, whose
number graph holds `Decimal` points; one number still makes a graph and no number makes none; a
stopped commitment's graph ends on the day it was kept until; the span is `@State` and resets on each
visit; the look-back says a number as every digit its `Decimal` holds, with no rounding rule, so an
average said in words would print 81.428571… in full.

## Settled

1. **A trend point stands on each day that holds a number, and nowhere else.** Each averages the
   numbers held in the seven calendar days ending on its day, and the trend joins across the days
   between as the trace does. *It invents nothing on a day nothing was entered; a weight logged once
   a week gives a trend that sits on its points, which is true.*
2. **The first days average what is there.** A day with fewer than seven days of history behind it
   averages the numbers its window holds, so the first point is its own number. *The trend starts
   where the graph starts, and settles in as days arrive.*
3. **The switch is there whenever the graph is.** One number is a graph, so one number offers the
   switch, and its trend is that number. *One rule, no threshold.* A look-back with no number has no
   graph and so no switch.
4. **Changing the span keeps the trend on.** Within a visit the switch is the person's until they
   leave. *Turning it on and then going to Year to read it is the point.*
5. **The trend is never said as a number.** No latest value beside the graph or the switch. *One
   trace and one switch; a stated average needs a rounding rule the look-back does not have.*
6. **Tapping a point says that day's number only**, as it does today, whether the trend is on or
   off. *Follows 5; the trend is read as a trace.*
7. **The walk shows three screens**: a number's look-back at the month with the trend off; the same
   with it on; and at the year with it on, over a history long enough that the trend visibly bends
   away from the day-to-day trace. **No `phone:` line.** *The simulator holds a seeded history, and
   nothing here is a gesture only a hand can judge.*

## Terms landed in CONTEXT.md

- **Trend** — landed at the grooming grill of B-070, 2026-09-30, on `main` since c9730f8. No new
  term at this grill.

## Layout

Option C, *beside spans*, chosen from three at https://claude.ai/artifact/8dSvPpuYaNXVwizcnGP7on —
**the owner's call against the designer's recommendation**, which was A, a switch in its own row
under the graph card. C keeps every control of the page on one row. Its cost, named in the round:
the span picker narrows to about three quarters of the width to make room, which gets tight for
"3 months" at larger text sizes; and the control is a button that stays on or off rather than a
switch, the kind the define sheet's weekday chips and the Reorder toolbar button already are. Shared
by all three options: the trend drawn in the label colour, about 2.5pt, with no dots, over the
unchanged grey trace and its dots, and never in the accent colour; the button reads "Trend", tinted
in the accent when on. **The switch of § Settled and of `CONTEXT.md` § *Trend* is this button**:
there "switch" means a control that is on or off, not the iOS switch drawn in options A and B. The
wireframe follows, verbatim from the designer.

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

- **C:** the segmented picker narrows to make room. An 80pt capsule "Trend" button shares its row,
  drawn as a button that stays on or off.

## Left open

None. Every question the frontier raised was answered, and the grooming grill left nothing open.
How precisely an average is carried below the seam is not the owner's to answer and is
`spec-author`'s, in `design.md`.
