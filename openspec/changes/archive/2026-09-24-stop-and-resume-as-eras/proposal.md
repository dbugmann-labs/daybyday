## Why

Taking a stopped commitment up again clears the day it was kept until, so every day of the pause
reads as kept once more: the day screen draws rows for days the person was not keeping it, and a
look-back counts those days as owed and missed. A stop made after a tick that morning also hides the
tick. A pause should cost nothing, and a week the commitment only partly held should owe only its
part.

## What Changes

- Taking a commitment up again begins a new era from the day it is taken up again, on the rhythm,
  range and target it had; the days between are a gap, owing nothing and drawing no row.
- An interval's count begins again on the day it is taken up again.
- Taken up again on or before the day after its stop, the stop is undone and no era is added.
- A stop on a day that already holds a record of the commitment is kept until that day.
- A stop that would leave the newest era holding no day drops it, and stops the era behind it.
- A commitment whose only era holds no day takes the resumed era as its first.
- Stored rosters are read the same way: no two alike eras join across a gap, and a stopped newest
  era holding no day behind an older one is dropped.
- A week a weekly quota holds on only some of its days owes the quota in proportion, rounded to the
  nearest whole number; a week two quota eras share owes each one's part, summed. **BREAKING** for
  five shipped look-back fractions.
- A look-back counts nothing in a gap and runs its months and weeks unbroken through it.
- A weekly quota's row says what its week owes, and counts a day kept before a stop in that week.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: one ADDED, seven MODIFIED.
- `look-back`: three ADDED, one MODIFIED, one REMOVED.
- `day-screen`: three MODIFIED.
- `schedule`: one ADDED.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `Roster`, `RosterStore`, `CommitmentsScreen`,
  `LookBack`, `DayView`, `DayScreen`, `Schedule`, `ScheduleWords`, and one new week helper.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — roster, store, screen, look-back, day view and
  schedule tests.
- `docs/adr/1061-a-part-week-owes-its-quota-in-proportion.md` — new.
- `docs/adr/1023-…`, `docs/adr/1050-…`, `docs/adr/1059-…` — amended in place.
- `CONTEXT.md` — **Resume**, and **Roster** and **Standing** amended.
