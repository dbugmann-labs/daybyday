## Why

The day swipe reaches every past day, and a one-off of something done or an older happening can be
entered on any of them, but the day picker and the week strip stop at the earliest day anything on
the roster is kept from. The days before it are exactly where those entries go, so the floor keeps a
person out of days the app already draws and accepts (`grill.md` settled 1–2).

## What Changes

- The day picker reaches back to the calendar's first date, 1 January 1583, whatever the roster
  holds, and opens on the day being shown as before. A pick is never refused.
- The week strip offers every day holding a date but the one shown; no day is faded for being early.
- A page to the week before keeps its weekday as far back as the calendar goes, landing on its first
  date where the weekday precedes it, as a page after already lands on the last.
- The week strip marks the earliest day anything on the roster is kept from, stopped commitments
  counting and deleted ones not, on its own week and on the weeks a page either way would give,
  wherever that day falls; a roster answering none marks nothing.
- The reach is retired as a term, and ADR-1048 is amended to the decision as it now stands.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `day-screen`: two ADDED, six MODIFIED, three REMOVED.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/DayScreen.swift` — the picker's earliest day, the strip's
  offers and its new mark, the backward page.
- `src/DayByDayKit/Tests/DayByDayKitTests/DayScreenTests.swift` — new tests, five rewritten, the
  tests of removed scenarios deleted.
- `src/DayByDay/DayByDay/ContentView.swift` — the dash under the marked day.
- `docs/adr/1048-a-day-pickers-floor-is-the-earliest-day-kept-from.md` — amended; `CONTEXT.md` —
  *Reach* retired, *Day picker* and *Week strip* amended.
