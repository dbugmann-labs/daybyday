## Why

A copy can leave the phone, and nothing brings one back. A person on a new phone, or with a store
that will not read, has a file that holds their whole history and no way to put it in. This change
gives them the second of the things `FEAT: restore` owes: pick a copy, be told what goes, and have
the phone become what the copy holds.

## What Changes

- The commitments screen offers putting a copy back, whatever its stores hold, readable or not.
- A picked file is read whole; one that is not a copy, a damaged copy, and a copy from a later
  version are refused, each for its own reason, and nothing is written.
- Before anything is written the screen says the copy's moment and what it and the phone keep,
  have stopped and hold as one-offs, or that a store here cannot be read.
- One confirmation puts the copy back: the three stores become what it holds, in today's forms.
- A restore is whole or nothing; a store that cannot be written leaves the phone as it was, and one
  stopped partway is undone the next time the stores are read.
- After a restore the commitments screen lists what the copy holds, drops what it was awaiting and
  names the copy put back by its moment.
- The day screen, returned to after a restore, reads all three stores again and drops what it was
  telling.

## Capabilities

### New Capabilities

None — `restore` already exists.

### Modified Capabilities

- `restore`: ADDED five requirements — reading a copy, what is said first, putting it back, a
  restore that cannot be made whole, and the day screen returned to after one.
- `commitment`: MODIFIED two requirements — putting a copy back joins the kinds of refused change,
  and a copy put back ends a refused change while asking for one does not.
- `day-screen`: MODIFIED four requirements — being returned to after a restore reads all three
  places and ends what a day screen tells on a row and under a one-off name field.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/CommitmentsScreen.swift`, `DayScreen.swift`
- `src/DayByDayKit/Sources/DayByDayKit/` — reading a copy, the three stores' form reading, a
  restore in progress
- `src/DayByDayKit/Tests/DayByDayKitTests/`
- `src/DayByDay/DayByDay/CommitmentsView.swift`, `ContentView.swift`
- `CONTEXT.md`, `docs/adr/`
