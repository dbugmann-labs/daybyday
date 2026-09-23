## Why

A commitment a person is done with can only be removed today, which hides it from both lists but
keeps it and everything recorded against it on the phone for good. The person wants it gone: the
commitment, every era and every record, confirmed by typing its name back. Deleting takes removal's
place, and the removed state is retired.

## What Changes

- **BREAKING** A roster deletes a commitment with every era, its place and its category; it is
  answered on no date afterwards. Removal and its state go.
- A deletion erases every tick, number, note and addition against the commitment at the record
  place, whole or nothing across the two places.
- The commitments screen asks for deletion on either list and confirms it by the name typed back,
  the rule removal already used.
- A roster that deleting leaves holding nothing is emptied: it is not a roster given nothing, so
  day one is never written back over it, across a restart and across a restore.
- A commitment a stored roster holds removed is read as deleted, with its records, once, and a roster
  that leaves holding nothing is emptied too. Old copies are read the same way.
- The sheet asks for the name and, where a copy place is picked, says the copy in Files follows.
- Requirements naming removal elsewhere are carried with deletion in its place.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: ADDED, MODIFIED and REMOVED; nineteen replaced under new headings.
- `day-screen`: two replaced under new headings, one MODIFIED.
- `restore`: one ADDED, one replaced under a new heading, four MODIFIED.
- `look-back`: one MODIFIED.

## Impact

- `openspec/specs/commitment/spec.md`, `day-screen/spec.md`, `restore/spec.md`, `look-back/spec.md`
  — at archive.
- `src/DayByDayKit/Sources/DayByDayKit/` — `Roster`, `RosterDocument`, `RosterStore`,
  `RecordStore`, `History`, `CommitmentsScreen`, `DayScreen`, `CopyDocument`, `CopyPlace`.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — the roster, store, screen, restore and copy tests.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — the swipe, the sheet and its words.
- `docs/adr/` — one new record; 1027, 1035, 1044, 1048 and 1049 amended in place.
- `CONTEXT.md` — **Emptied**, and the removed state's retirement.
