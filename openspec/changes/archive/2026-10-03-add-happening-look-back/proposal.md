## Why

Occurrences can be noted, changed and taken back on the day screen, but nothing yet answers the
question a happening is kept for: when did it come, and how often. This Story gives a happening its
look-back, reached from its row on the commitments screen, so a person can read every occurrence
and a month-by-month count, a run of empty months included.

## What Changes

- A commitments screen answers a look-back at a happening it lists, by its name as listed, and none
  at a happening it does not list or while its happening place cannot be read.
- The look-back says every occurrence of that happening, newest day first, latest time first within
  a day and those with no time after them, each with its day, its time and its note.
- It counts every occurrence it says, "14 times" or "1 time", and says the day it counts since.
- It counts each calendar month from the earliest occurrence's through the current one, newest
  first, a month with none saying "0 times".
- A happening with nothing noted says its name and nothing else.
- Asking for one changes nothing and writes nothing.
- The shell's happening row opens the page on a tap; renaming stays on the swipe.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `happening`: ADDED — a happening's look-back, its occurrences, its counts and its months.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — a new `HappeningLookBack.swift`; `CommitmentsScreen.swift`
  answers it; `LookBackWords.swift` says a count of times.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — a new `CommitmentsScreenHappeningLookBackTests.swift`;
  no carried test moves.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — the happening row becomes a link.
- `src/DayByDay/DayByDay/LookBackView.swift` — the happening's page, beside a commitment's.
