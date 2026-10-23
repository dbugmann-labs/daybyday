## Why

"Pool", due on Fridays only, slipped to the Monday after and could not be shifted there: a
weekday-set or day-of-month due day reaches only the free days of its own Monday-to-Sunday week.
A **shift** of either shape now reaches past its week, up to the due days of its own schedule
either side, while keeping every day of its week it reaches today (`CONTEXT.md` § *Shift*).

## What Changes

- A weekday-set or day-of-month due day is shifted onto a free day of its week or onto any day
  after its schedule's due day before it and before the one after it; on one weekday that is the
  Saturday before a Friday through the Thursday after, on a day of the month about a month each way.
- A day shifted again is judged from the day it came from, that day included where its era is due
  on it, so the way back is always offered, across a week or not.
- The due days either side are the schedule's own; a day another shift put a due day on stays not
  free, and one shift never narrows another's reach, even where the two then fall out of order.
- No weekday-set or day-of-month shift crosses or lands on days away, as an every-N-days one
  already does not.
- A day screen offers every shape's days said with their date, as "Sat 29 Aug", and a shifted row
  says "from Fri 4 Sep" or "to Mon 7 Sep" for every shape.
- The roster and record stores read a shift whose two days lie in two weeks, and both forms move
  with no change of shape so an older app refuses them as a later form.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: one ADDED, one REMOVED, four MODIFIED.
- `day-screen`: one ADDED, one REMOVED, four MODIFIED.
- `record`: one MODIFIED.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `Roster`, `RosterDocument`, `CommitmentCoding`,
  `RecordDocument`, `DayView`, `DayScreen`.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — new tests beside the carried ones; three carried
  tests renamed; the carried lines naming the old row words, offered days or forms rewritten.
- `docs/adr/1066-a-shift-is-part-of-the-commitment.md` — amended.
- `CONTEXT.md` — **Free day** amended.
