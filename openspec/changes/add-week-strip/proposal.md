## Why

Reaching a day in the same week as the one shown takes a swipe per day or a trip into the calendar.
The day screen's head has room to say the week itself: seven days under the date, any of them one
tap away, with the chevrons that only ever stepped one day gone.

## What Changes

- A day screen says its week strip: the seven days, Monday to Sunday, of the week the shown day lies
  in, each said by a single letter and its date.
- The strip marks the day being shown and the today, where the today lies in that week, and marks
  nothing about how any day went.
- The strip offers every day it holds but the one being shown and any earlier than the day picker
  reaches; days after the today are offered like any other.
- A tap on an offered day shows it exactly as picking it on the day picker does.
- Past either end of the supported calendar a strip day keeps its letter and holds no date.
- The shell draws the strip under the date row, which moves to the leading edge; the chevrons leave.
  The day swipe stays, and a strip tap replaces the day where it stands.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `day-screen`: ADDED — the week strip a day screen says, and which of its days it offers.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/DayScreen.swift` — the strip and its day value.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — the day screen tests.
- `src/DayByDay/DayByDay/ContentView.swift` — the head: the strip in, the chevrons out.
- `docs/adr/1042-*` and `docs/adr/1045-*` — amended: the strip depicts the swipe, and its days fade.
- `CONTEXT.md` — § *Week strip*, § *Day navigation* and § *Offered*.
