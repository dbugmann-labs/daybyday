## Why

A copy leaves the phone only when a person asks for one and remembers to. `FEAT: restore` owes a
third thing: a folder picked once, and a mirror kept there by the app itself, at most one change
behind. Nothing in the app persists a setting today, so there is no place to copy to and nothing to
say about the last copy. This change adds the place and the copying together.

## What Changes

- A copy place: one folder a person picks, kept at a file of its own across the app being closed.
- A copy written there the moment the folder is picked, so there is something to say at once.
- A folder already holding a copy asks to restore it first; replacing it with this phone's is the
  other answer, and cancelling sets no place.
- A folder whose copy cannot be read is refused as a copy place, and nothing is written there.
- One file at the copy place, of a fixed name, overwritten whole by every copy.
- A copy after every change a person keeps, from the day screen and the commitments screen alike.
- A copy that cannot be made refuses no change: the change is kept and the next one tries again.
- A line on the commitments screen naming the folder, the last copy made there, and a stop with its
  reason and since when, told apart as unreachable, unwritable, or a store that could not be read.
- Forgetting the copy place, after which the app copies only when it is asked.
- A write the app makes on its own — a torn save or restore undone, orphaned records carried back,
  the day-one take-on — writes no copy.
- The commitments screen's *Copy* section gains the copy place row and the line; the day screen
  says nothing about any of it.

## Capabilities

### New Capabilities

None — `restore` already exists.

### Modified Capabilities

- `restore`: ADDED nine requirements — what a copy place is, picking one, a folder that already
  holds a copy, a folder whose copy cannot be read, the copy after a kept change, a copy that
  cannot be made, what the commitments screen says, forgetting, and the writes that copy nothing.
- `day-screen`: MODIFIED one requirement — a take-back reaches the copy place as well as the
  record place.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — a new copy place, the copy forming shared out of the
  commitments screen
- `src/DayByDayKit/Sources/DayByDayKit/CommitmentsScreen.swift`, `DayScreen.swift`
- `src/DayByDayKit/Tests/DayByDayKitTests/`
- `src/DayByDay/DayByDay/CommitmentsView.swift`, `ContentView.swift`
- `CONTEXT.md`, `docs/adr/`
