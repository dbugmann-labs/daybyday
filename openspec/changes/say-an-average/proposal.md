## Why

A number's or a total's look-back draws where the values went but never says where they usually
sit, so a person reads it off the trace by eye. This Story says one average beside the graph, of
the span the picker has chosen, and leaves the trend, the graph and every other page as they are
(`grill.md` § *Settled at the grooming grill*).

## What Changes

- A number's and a total's graph say an average over each of four spans of their newest days — a
  month, three months, a year and all — and say none over a span holding no point.
- The average takes in only the days the graph draws a point on, a gap's numbers never, and runs
  across a change of range or target as the trace does.
- A total's average says no target.
- The average is said to one decimal place, a trailing ".0" dropped, in the look-back's digits.
- A tick's, a quota's and a note's look-back say no average.
- The look-back page draws the average in a card of one label-and-value row under the graph card,
  for the span picked, and draws no card where that span holds no point.
- The span picker's four lengths move from the page into the look-back, so the page and the
  average read one set.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `look-back`: two ADDED.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `LookBack`, `LookBackWords`.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — new look-back tests beside the carried ones.
- `src/DayByDay/DayByDay/LookBackView.swift` — the span picker's lengths and the average card.
- `CONTEXT.md` — a new entry, *Span*.
