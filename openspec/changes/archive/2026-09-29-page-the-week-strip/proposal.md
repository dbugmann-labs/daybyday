## Why

The week strip reaches any day of the shown day's week in one tap, but another week still takes a
swipe per day or a trip into the calendar. Swiping the strip, or tapping a chevron beside it, should
turn it to the week before or after and take the shown day with it, as a calendar's week row does.

## What Changes

- A day screen pages to the week after and to the week before the one it is showing, and the day
  being shown moves with the page, to the same weekday of that week, the today's week included.
- A page back reaches no day earlier than the day picker reaches, the today included, landing on
  that earliest day where the weekday is earlier; a page forward past the calendar lands on its last.
- A page with nowhere to go, past the reach going back or past the calendar going forward, leaves
  the screen exactly as it was.
- A page is a change of the day being shown like any other move, and reads neither place again.
- A day screen says the week a page either way would land in, marking no day as shown, and says
  none where that page would do nothing.
- The shell pages the strip on a swipe across it and on a chevron either side of it, faded where the
  page would do nothing: the strip slides, and the rows are replaced where they stand once it lands.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `day-screen`: ADDED — paging the week strip, how far back a page reaches, and the week strip
  either side.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/DayScreen.swift` — two pages and two neighbour strips.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — the day screen tests.
- `src/DayByDay/DayByDay/ContentView.swift` — the strip takes its own swipe, gains two chevrons and
  slides.
- `docs/adr/1042-*` — amended: the strip takes a horizontal swipe inside its own bounds, and two
  chevrons beside it page weeks.
- `CONTEXT.md` — § *Week strip*.
