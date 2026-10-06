## Why

A weekly-quota row says its standing — "1/5x a week" — and leaves the arithmetic to the person:
nothing on today's day screen says that the week can no longer be met without today. This Story
marks that row, on today only and only while today is not kept, so the day it matters is the day
it shows. It warns and never rewards, and counts nothing across weeks (`CONTEXT.md` § *Slack*).

## What Changes

- A day screen answers, for a row, the mark "Needed today" or no mark.
- The mark is answered for a weekly-quota row of the screen's today, not kept, whose week owes
  exactly as many days as are left in it, today included.
- A week with a day to spare, one owing nothing more, or one that can no longer be met: no mark.
- A row of any other day, the day either side of the one shown included, carries no mark; the
  screen's today is the one it was last handed, never the clock and never the day it is showing.
- A week that never had slack — seven times a week, or a part week owing every day it holds — is
  marked on every unkept day while it can still be met.
- The shell draws the mark as a caption-size glyph after the row's words, read aloud as "Needed
  today"; the trailing slot and its two colours are unchanged.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `day-screen`: ADDED — the mark on a weekly-quota row with no slack, and the today it is judged on.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/DayScreen.swift` — the member answering the mark.
- `src/DayByDayKit/Sources/DayByDayKit/DayView.swift` — the row's own reading of its slack,
  package-internal.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — one new test file for the eleven scenarios.
- `src/DayByDay/DayByDay/ContentView.swift` and `CommitmentLine.swift` — the glyph after the words.
