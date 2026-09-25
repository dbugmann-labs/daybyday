## Why

Birthday ticks are kept in a store of their own, and nothing that looks after the other three
stores looks after that one: a copy leaves them behind, a restore leaves the phone's in place, a
take-out does not hand their file out, and a tick writes no copy at the copy place. A new phone
restored from a copy loses every birthday tick. This Story carries the fourth store like the three.

## What Changes

- A copy holds the birthday ticks, read whether or not birthdays are on.
- Unreadable or later-version ticks refuse a copy whole, named after the one-offs, and stop the copy place.
- A copy made before copies held ticks holds none; one whose ticks do not read is a damaged copy.
- A restore puts the copy's ticks back, whole or not at all, and counts none of them.
- What a restore says first names the phone's ticks only where they cannot be read.
- A torn restore is undone at the birthday place too.
- A day screen returned to after a restore reads its birthday place afresh.
- A screen given no birthday place keeps its ticks beside its record place.
- A birthday tick made or taken back writes a copy at the copy place.
- A take-out hands out the ticks' file, is offered while they cannot be read, and names them.
- A day screen that says its ticks could not be read also says a copy can be restored.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `restore`: ADDED — a copy's birthday ticks, where the commitments screen and the copy place keep
  them, reading them from a copy, a restore of them, a torn restore at the birthday place, and a
  birthday tick's copy. RENAMED and MODIFIED — what a take-out is. MODIFIED — the take-out's
  offer, its answer and its refusal; the day screen's restore line.
- `day-screen`: MODIFIED — when a day screen opens its birthday place.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — the copy and its written form, the copy place, the
  restore in progress, the commitments screen and the day screen.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — new tests; every existing test carried unedited.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — the birthday ticks' line wherever a store is
  named on the commitments screen.
- `CONTEXT.md` — *Birthday place*.
