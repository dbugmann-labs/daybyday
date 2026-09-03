## Why

A day view answers for one date, and until now the only date anyone could ask about was the one
the app worked out at launch. `ContentView` forms `DayView(of: dayOneCommitments, on: today(), in:
History())` once and never again, so the record the product exists to keep — a tick made on the day
it was missed, a week looked back over — is unreachable: the past is writable (`CONTEXT.md` §
*Tick*, and `docs/open-questions.md` § *Settled*, 2026-09-02) and nothing can reach it.

#70 built the day view and #71 put the tick in the row. Both answer about *a* date and neither
moves between dates, and nothing outside `DayByDayKit` can: `CalendarDate` is not `Comparable`, its
`year`, `month` and `day` are internal, and it has no day arithmetic at all. Working out which date
comes next is therefore either impossible for the app shell or possible only by keeping a second,
parallel `Foundation.Date` beside the one the kit speaks — which is a rule that can be wrong in a
way a test would catch, and so is exactly what `CONTEXT.md` § *App shell* keeps out of the shell.
This is the third and last Story under `FEAT: day-screen` (#27).

## What Changes

- A day view can be moved to the calendar date one day earlier than its own, and to the one one day
  later. Each move gives back the day view of that date, formed from the commitments and history it
  is handed at the moment of the move.
- Moving steps exactly one calendar day, across the end of a month, the end of a year and a leap
  day alike, and never skips a date on which nothing happens to be due.
- There is no day before 1 January 1583 and none after 31 December 9999, so a day view on either
  gives nothing when moved that way rather than clamping to itself.
- Moving never asks what day it is. Navigation is a question about a date, like every other
  question in the package (ADR-1004); a day view moved onto a date that has not arrived is formed
  exactly like any other, and whether its rows offer a tick is already settled by #71.
- Purely additive. Both of #70's day-view requirements and all three of #71's are untouched: two
  ADDED requirements, no MODIFIED one and no REMOVED one.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `day-screen`: two ADDED requirements — a day view moves to the day before it and the day after
  it, and there is no day before the first supported date nor any after the last.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/DayView.swift` — two new public methods on `DayView`; no
  existing member's signature or behaviour changes.
- `src/DayByDayKit/Sources/DayByDayKit/CalendarDate.swift` — an internal way to step one day, used
  only from inside the module. Nothing becomes public, so `openspec/specs/schedule/spec.md`, which
  owns what a calendar date is, needs no delta.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — one acceptance test per scenario, named identically,
  added to the 149 passing at `12f768d`.
- `src/DayByDay` — untouched by this Story. The shell holds one day view and draws its rows; wiring
  a gesture to a move, and drawing *which* day is being looked at, are not this Story's and the
  second is blocked on a `schedule` delta this Story deliberately does not write (`design.md`
  § *Risks*).
