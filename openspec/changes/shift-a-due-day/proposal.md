## Why

Gym on Monday done on Tuesday leaves Monday missed and Tuesday's tick nowhere to go: a weekday set
and a day of the month are anchored to the calendar, and nothing moves one due day of them. A
**shift** puts that one due day on a free day of its week, the day it came from saying where it went
(`CONTEXT.md` § *Shift*). This Story is the weekday-set and day-of-month half; every N days is #393.

## What Changes

- A roster shifts one due day of a weekday-set or day-of-month commitment onto a free day of its
  Monday-to-Sunday week, a day of the next or last month included; the rest of its rhythm stands.
- The day it came from stops being due; the day it lands on is due, for every kind of record.
- A shifted day shifts again keeping where it came from, and shifted to that day leaves no shift.
- A day holding any record is not shifted, nor a weekly-quota or every-N-days day.
- A day screen offers a row's free days, Monday first, said "Tue", "Thu"; a long press opens them.
- The day a shift lands on says "from Mon" in its rhythm's place; the day it left keeps a faded row
  saying "to Tue" that offers nothing.
- A change of rhythm, day kept from, range or target, and a stop, are refused while any shift has
  either day after today: "Shift its day back first."
- A look-back counts a shifted day due where it landed, and the day it came from not at all.
- The roster and record stores keep shifts across the app being closed; a copy carries them.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: three ADDED, two MODIFIED, two RENAMED.
- `day-screen`: three ADDED, ten MODIFIED, two RENAMED.
- `record`: one ADDED.
- `look-back`: one ADDED.
- `restore`: one ADDED.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `Commitment`, `Roster`, `RosterStore`,
  `RosterDocument`, `CommitmentCoding`, `RecordDocument`, `DayView`, `DayScreen`,
  `CommitmentsScreen`.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — new tests for the shift, beside the carried ones.
- `src/DayByDay/DayByDay/ContentView.swift` — the long-press menu on a commitment row.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — the refusal's words.
- `docs/adr/1066-a-shift-is-part-of-the-commitment.md` — new.
- `CONTEXT.md` — **Free day**, and **Shift** amended.
