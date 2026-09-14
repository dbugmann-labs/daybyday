## Why

A change that carries records writes the record place first and the roster place second. An app
stopped between the two, or a roster write that fails and whose undo fails too, leaves records
under a commitment the roster never took on: a torn save. Nothing undoes one today, asking for the
same change again no longer repairs it, and records already orphaned on a phone stay orphaned.

## What Changes

- A change or restart that carries records leaves a save in progress beside the record place
  before its first write, and takes it away once the roster place is written.
- Whenever a screen reads its places, a save in progress the roster did not take is undone: its
  records are carried back to the commitment they came from, and nothing is said.
- A torn save that cannot be undone leaves a day screen without its record and a commitments
  screen changing nothing, until the places are read again and it can be.
- A roster write that fails mid-save undoes the save the same way, rather than by a best effort
  whose failure is swallowed.
- An orphaned record with exactly one possible source is carried back to it when the places are
  read; one with none, several, or a day already recorded on the source stays where it is.
- A commitments screen says that records belong to no commitment for as long as any do.
- Two shipped scenarios of the refusal for records already kept are refixtured so that their stray
  records have no single source, and go on testing that refusal.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: ADDED requirements on the save in progress, undoing a torn save when the places are
  read, a torn save that cannot be undone, carrying an orphaned record back, and saying that records
  belong to no commitment; MODIFIED *A commitments screen refuses a change that would carry records
  onto records already kept*, fixtures only.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/CommitmentsScreen.swift` — the save in progress, the undo
  at a roster refusal, and the statement about orphaned records.
- `src/DayByDayKit/Sources/DayByDayKit/DayScreen.swift` — undoing and carrying back when its places
  are read.
- `src/DayByDayKit/Sources/DayByDayKit/History.swift`, `RecordStore.swift` — carrying records back
  onto a commitment that holds records on other days.
- A new internal file for the save in progress and what reading the places does.
- `src/DayByDayKit/Tests/DayByDayKitTests/CommitmentsScreenTests.swift`, `DayScreenTests.swift`.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — draws the statement.
- `docs/adr/`, `CONTEXT.md`.
