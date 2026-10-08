## Why

Nails due on Sunday and done on Monday leaves Sunday missed, Monday's tick nowhere to go, and the
next due day still counted from Sunday. #392 shifts a weekday-set or day-of-month due day; an
every-N-days one is refused. A **shift** of an every-N-days due day puts it on a day between the
due days either side of it, and its count runs on from there (`CONTEXT.md` § *Shift*). A range or
target change also restarts the count today, which nothing asked for.

## What Changes

- A roster shifts an every-N-days due day onto a day after the due day before it and before the
  one after it, a week crossed or not, but no earlier than the first day of its era.
- The count runs on from the day it landed: every later due day moves with it, earlier ones stay.
- It is refused while anything stands after the day: a later shift, a later era, or, on a day
  screen, a record on a later day. A weekday set and a day of the month keep #392's rules.
- A landing shifted again keeps the day it came from and that day's bounds; shifted back to it,
  it leaves no shift. A day another shift took a due day from is never landed on.
- A day screen offers the days in date order, each said "Thu 27 Aug"; the landing row says
  "from Sun 30 Aug" and the origin row "to Mon 31 Aug". Weekday-set rows keep "Tue", "from Mon".
- A change of range or target alone keeps an every-N-days count running; a change of N, or of
  shape, still starts the new count on the day it is made. Eras already made stay as made.
- A look-back counts every-N-days due days as the shifted count runs.
- A record on a day the shifted count reaches keeps that shift beside it, and is read back.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: three ADDED, one REMOVED, three MODIFIED.
- `day-screen`: three MODIFIED.
- `record`: one ADDED, three MODIFIED.
- `look-back`: one MODIFIED.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `Commitment`, `Roster`, `RosterDocument`,
  `CommitmentCoding`, `RecordDocument`, `RecordStore`, `DayView`, `DayScreen`,
  `CommitmentsScreen`.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — new tests beside the carried ones; one carried
  scenario renamed; the carried lines naming the record or roster form as current or later.
- `docs/adr/1066-a-shift-is-part-of-the-commitment.md` — amended.
- `CONTEXT.md` — **Free day** amended.
