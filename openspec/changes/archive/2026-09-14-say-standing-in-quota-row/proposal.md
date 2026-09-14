## Why

A commitment on a weekly quota has a row on every day of the week, and that row says "3x a week" on
the seventh night exactly as on the first. The history now answers a commitment's standing, the
count of its week's days kept through a date, and nothing on the day screen says it. This change is
where a person first reads how much of the week is already behind them.

## What Changes

- A schedule can be said given a count: a weekly quota says the count before its words, "1/3x a week".
- The count is said as given and judges nothing: "0/3x a week", "4/3x a week", "9/3x a week".
- A weekday set, a day of the month and an interval said given a count say their plain words.
- A day-screen row on a weekly quota says its rhythm given its standing through the row's own date.
- A week with nothing kept yet says "0/3x a week" rather than the plain words.
- A row for a day that has not arrived says its standing too, with no special case.
- A quota row says its standing whatever its commitment's kind: tick, number, note or total.
- A met or passed quota is said by the count alone; a row gives back no met state and no standing.
- A weekly quota's row is its standing as well: rows differing only in it are different rows.
- A row on any other schedule holds no standing, and says what it said before.
- The commitments screen and the form's preview keep the plain words.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `schedule`: ADDED — a schedule said given a count; MODIFIED — a schedule says its rhythm in words.
- `day-screen`: MODIFIED — a row is its commitment, its date and what that day holds; MODIFIED — a
  row gives back what a screen draws and what a tap makes.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/Schedule.swift` and `ScheduleWords.swift` — the counted words.
- `src/DayByDayKit/Sources/DayByDayKit/DayView.swift` — a row holds and says its standing.
- `src/DayByDayKit/Tests/DayByDayKitTests/ScheduleTests.swift` and `DayViewTests.swift` — the tests.
- `docs/adr/1034-a-schedule-says-its-rhythm-in-words.md` and
  `docs/adr/1050-a-week-is-monday-to-sunday-and-the-history-counts-it.md` — amended.
- No store, no document encoding and no shell file changes; the shell already draws the row's words.
