# 1056. A restore is whole or nothing, and one stopped partway is undone as it was

- Status: proposed — written while the delta of `restore-from-a-copy` (#267) was being written, on
  the grill's settled answer 4; approved at that Story's G4
- Date: 2026-09-15
- Deciders: Diego Bugmann

## Context

Restoring a copy writes three files: the record, the roster and the one-offs. Each store already
writes its own file atomically, and nothing spans all three. A save in progress (ADR-1049) spans two
of them, and it records a carry between two commitments, not the contents of a file, so it cannot
undo a restore. The owner settled that a restore is all or nothing and that the app makes no copy of
what goes. So the phone as it was exists nowhere but in its three files at the moment the restore
begins. It can fail in two ways: a write refused partway, or the app stopped between two writes.

## Decision

**Before a restore writes anything, it keeps what stood at the three places, and at the
save-in-progress place, in one file beside the record place: a restore in progress.** It then writes
the three stores and takes that file away.

- **A refused write is undone at once.** The bytes are put back and the file is taken away. Where
  putting them back fails too, the file stays.
- **A standing restore in progress is undone the next time the places are opened**, by a commitments
  screen or a day screen, before a torn save is looked for and before any store is read. It says
  nothing, because a restore is said only once it is whole.
- **Undone means rolled back, never forward.** The phone is left exactly as it was before the restore
  began, as a torn save is.
- **One that cannot be read or undone withholds all three places**: nothing is read from them and
  nothing is written over them.

## Consequences

- A restore briefly holds the phone's old contents twice. The file exists only between a restore's
  first write and its last.
- Every reader of the places gains one step before `undoTornSave`.
- A restore the person was told was refused can never appear on the next launch. The price is that
  one stopped a moment before it finished is lost too, and must be asked for again.
- Rejected: rolling forward from the copy, which could put back a restore the person was told had
  failed. Also rejected: writing three staged files and renaming them, which is still three acts a
  stop can fall between.
