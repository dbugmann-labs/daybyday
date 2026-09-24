## Why

A birthday can be read from the phone's calendar, ticked and kept, and the switch that lets the app
read one is on the commitments screen — but nothing yet shows a birthday. This Story draws the day's
birthdays on the day screen, in a group of their own headed *Birthdays* before every commitment, and
takes their tick there. It is the last of the three Stories that make B-059 something a person uses.

## What Changes

- While birthdays are on, a day view holds a *Birthdays* group of the birthdays falling on its date,
  first, and none where none falls; while they are off the calendar is not asked at all.
- A birthday row says the calendar's words exactly, empty words included, and its tick; nothing else.
- Birthday rows are drawn in the order the phone collates their words, never the calendar's order.
- A birthday row is ticked and unticked with one tap, on any day that has arrived, however far back.
- The day screen names the place it keeps birthday ticks at, beside its other places.
- A calendar that cannot be read draws no group and says "Birthdays could not be read."
- Birthday ticks that cannot be read draw the group unticked, keep no tick, and say so.
- A birthday tick that cannot be kept is told on its row, sharing the screen's one notice.
- Being shown again visits the switch first, so access withdrawn in Settings turns birthdays off.
- The shell reads the phone's birthday calendar and draws the group as chosen at the layout round.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `day-screen`: ADDED — the Birthdays group and its rows, when birthdays are read, their order, the
  birthday place, a calendar and ticks that cannot be read, the tick and its notice. MODIFIED — a
  day view is a value; how long a notice lasts; being shown again.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — the day screen and the day view, and one new small type
  for the calendar as the day screen reads it.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — the day screen's tests.
- `src/DayByDay/DayByDay/` — the adapter reading the phone's birthday calendar, and the day screen's
  view: the group, its rows, and the three new lines under the date row.
- `CONTEXT.md` — the term *Birthday place*.
