## Why

A number logged most days wobbles from one day to the next, and the wobble hides which way the
number is going. A **trend** — each day's average of the numbers held in the seven calendar days
ending on it — evens the wobble out, and a person turns it on over the graph when they want to read
the drift rather than the days.

## What Changes

- A number commitment's graph says a trend: one trend point on each day that holds a number, the
  average of the numbers its graph holds in the seven calendar days ending on that day.
- The first days average what their window holds, so one number is a trend of that number.
- The trend reads across an era boundary and counts no number a gap day holds, as the graph does.
- A total commitment's graph says no trend.
- The shell draws a "Trend" button beside the span picker on a number's look-back, off on every
  visit, kept on across a change of span; on, it draws the trend over the unchanged trace.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `look-back`: ADDED — a number commitment's graph says a trend through its points.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/LookBack.swift` — the graph walk forms the trend.
- `src/DayByDayKit/Tests/DayByDayKitTests/LookBackTests.swift` — the new scenarios' tests.
- `src/DayByDay/DayByDay/LookBackView.swift` — the "Trend" button and the trend's trace.
- `CONTEXT.md` — § *Trend*, where its points stand.
