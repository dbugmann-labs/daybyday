## Why

The week strip reaches any day of the shown day's week in one tap, but another week still takes a
swipe per day or a trip into the calendar. Swiping the strip itself should turn it to the week
before or after, and take the shown day with it, as a calendar's week row does.

## What Changes

- A day screen pages to the week after and to the week before the one it is showing, and the day
  being shown moves with the page: to that week's Monday, or to the today where the week holds it.
- A page back reaches no day earlier than the day picker reaches, landing on that earliest day where
  the Monday is earlier; the today is reached whatever the reach.
- A page with nowhere to go, past the reach going back or past the calendar going forward, leaves
  the screen exactly as it was.
- A page is a change of the day being shown like any other move, and reads neither place again.
- A day screen says the week strip a page either way would give, and says none where that page
  would do nothing.
- The shell pages the strip on a horizontal swipe across it: the strip slides under the finger, the
  rows are replaced where they stand once it lands, and a swipe never taps the day it started on.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `day-screen`: ADDED — paging the week strip, how far back a page reaches, and the week strip
  either side.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/DayScreen.swift` — two pages and two neighbour strips.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — the day screen tests.
- `src/DayByDay/DayByDay/ContentView.swift` — the strip takes its own swipe and slides.
- `docs/adr/1042-*` — amended: the strip takes a horizontal swipe inside its own bounds.
- `CONTEXT.md` — § *Week strip*.
