## Why

A declined day is told apart from a forgotten one on its row, but a look-back still reads the two
alike: a tick's fraction counts both unkept, and a number's, a total's or a note's page shows no
trace of a declined day at all. This Story says how many days were declined, on every kind's page
and on each of a tick's month lines, and changes no fraction (`grill.md` § *Settled*).

## What Changes

- Every kind's look-back says how many days it counts were declined, from the day kept from through
  the last day it counts, and says nothing where none was.
- A tick's month line says how many of its days were declined, as "1 declined" or "3 declined",
  and a month with none reads as it does today; a week line never says a count.
- A declined day stays among the due days and out of the kept days of every fraction.
- A declined day the look-back does not count due — in a gap, after the day kept until, or on a
  day an era running on a weekly quota holds — is counted nowhere.
- A number's and a total's graph, the averages and a note page's notes are unchanged; no reason is
  said.
- The look-back page draws a "Declined" row last in its head card where the count is said, and the
  month count as a caption under the month's name.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `look-back`: two ADDED.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `LookBack`, `LookBackWords`.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — new look-back tests; carried tests that match a month
  line's cases by position gain one binding.
- `src/DayByDay/DayByDay/LookBackView.swift` — the head card's "Declined" row and the month caption.
