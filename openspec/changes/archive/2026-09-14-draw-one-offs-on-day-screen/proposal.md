## Why

One-offs can be held, ticked, taken back and kept across the app being closed, and nothing a person
looks at shows one. The day screen is where a day's debts are read, so this change is where a
one-off first appears: on the one day it stands on, in a group of its own, saying how late it is.

## What Changes

- One-offs answer which of them stand on a day as of a today, ordered by the date owed, then added.
- A day view holds a group headed "One-offs", after every group of commitments, where any stand.
- A one-off row says "3 days late" in the rhythm's place while undone, and nothing once done.
- Lateness is always days — "1 day late", "400 days late" — and never weeks, months or a date.
- A one-off row offers its tick where its day has arrived; ticking records the today.
- Taking a tick back on a past day is offered, and the one-off leaves that day for today.
- A day screen keeps its one-offs at a third place of its own, read when opened and when shown.
- A day screen that cannot read that place draws its commitments, no group, and says why.
- A refused one-off change shares the screen's one notice with commitment rows, in both directions.
- The days either side carry their One-offs group, formed as of the today; the reach is unmoved.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `one-off`: ADDED — one-offs answer the one-offs standing on a day, earliest owed first.
- `day-screen`: ADDED — the One-offs group, the one-off row, its identity, the one-off place, drawing
  from it, an unreadable one, the one-off tick, and the shared notice; MODIFIED — a day screen holds
  the day view of the day it was handed; a day view is a value; a day screen re-reads its day and
  its places when shown; what is told lasts until three things; a day screen tells nothing where
  there was no change to refuse.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/OneOffs.swift` — the reader of what stands on a day.
- `src/DayByDayKit/Sources/DayByDayKit/DayView.swift` — the One-offs group and the one-off row.
- `src/DayByDayKit/Sources/DayByDayKit/DayScreen.swift` — the one-off place, its state, the tick,
  the notice.
- `src/DayByDayKit/Tests/DayByDayKitTests/OneOffTests.swift`, `DayViewTests.swift` and
  `DayScreenTests.swift` — the tests.
- `src/DayByDay/DayByDay/ContentView.swift` — the shell draws the group, its rows and the state line.
- `docs/adr/1052-a-one-off-follows-today-until-it-is-done.md` — amended: the row says lateness, not
  the date.
- No existing store or encoding changes; the one-off store's form is as shipped.
