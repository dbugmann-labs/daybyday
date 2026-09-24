## Why

On today, a one-off that has been ticked stays where its date put it, among the ones still owed, so
what is left to do is scattered through what is done. This Story puts every one-off still owed above
every one done, and the done in the order they were ticked, newest first — so a tick moves the row
to just below the last one still owed, and moving it is visible.

## What Changes

- One-offs answer a day's one-offs with every one still owed before every one done.
- The owed keep today's order: earliest owed first, one date's in the order they were added.
- The done stand newest tick first; a one-off added already done is the newest tick.
- One-offs keep the order ticks were made in, never a time of day; a tick taken back leaves it,
  a rename keeps a place in it, a removal leaves the rest as they were.
- The one-off store keeps that order in a new form, reads the form before it, and refuses an order
  it could not hold; ticks from before it are older than every tick since, by the date owed.
- A copy carries the order, because it carries the one-off store's own form.
- A one-off row gives back a key that survives its tick, so the shell can follow it.
- The shell moves a one-off row with a short animation when it is ticked or its tick taken back.
- **BREAKING** for a downgrade only: a one-off store written by this build is a later form to an
  earlier one, which refuses it and leaves it as it is.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `one-off`: REMOVED — the order by the date owed alone. ADDED — the order owed before done, the
  tick order, and how a one-off store keeps, reads and refuses it.
- `day-screen`: MODIFIED — a one-off row is its one-off, its date and whether it is done, now with a
  key.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — the one-offs value, the one-off store's form on disk, and
  the day view's one-off row.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — the one-off, one-off store and day view tests.
- `src/DayByDay/DayByDay/` — the day screen's view: how one-off rows are keyed, and the animated
  tick.
- `docs/open-questions.md` — the one-off store's test-lifetime entry, fixed here and removed.
- `CONTEXT.md` — the one-off row's key.
