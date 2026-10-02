## Why

A happening can be made and renamed, but nothing records that one came. This Story lets a person
note an occurrence from the day screen — on today or a past day, at a time or at none, with a note
or none — and shows on each day what came on it. Changing and taking one back, the look-back,
stopping and deleting, and the copy are each a later Story under `FEAT: happening`.

## What Changes

- An **occurrence** is one happening, a day, a time of that day or none, and a note or none.
- Happenings hold their occurrences in the order noted, two alike both counted; a rename keeps them.
- The happening store keeps occurrences in a second form, and reads the first as holding none.
- The day screen reads the happenings at the place the commitments screen keeps them, when opened,
  shown and returned to.
- A button on the day screen opens the list of happenings, on today and past days only, while one
  exists and they can be read; picking one opens a sheet with a time and a note.
- The time starts at the current one on today and blank on a past day; either can be cleared.
- A time later than now, or a day that has not come, is refused; so is a note that cannot be kept.
- A day draws one row per happening that came on it, its times inline, earliest first, then
  "no time" for each untimed one; no row where nothing came.
- A happening store that cannot be read gets a line in the day screen's store card and no button.
- Noting writes no copy and touches no other store.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `happening`: ADDED — the occurrence, happenings holding occurrences, and the store keeping them.
- `day-screen`: ADDED — reading the happenings, offering and noting an occurrence, the time it
  starts at, its refusals, the row of what came, and a happening place that cannot be read.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — a new file for the occurrence and its time of day;
  `Happenings.swift`, `HappeningDocument.swift` and `HappeningStore.swift` hold occurrences;
  `DayView.swift` gains the happening rows; `DayScreen.swift` reads the happening place and notes.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — new test files for the occurrence, its store and the
  day screen's noting; one carried fixture's later-form version number moves (`tasks.md` § 2).
- `src/DayByDay/DayByDay/ContentView.swift` — the bolt, its menu, the note sheet, the row of what
  came and the store card's line.
- `CONTEXT.md` — **Time of day** and **Happening row** added; **Happening store** amended.
