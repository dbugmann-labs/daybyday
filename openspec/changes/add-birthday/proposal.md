## Why

The phone already knows whose birthday falls on each day, and the day screen cannot say so.
`FEAT: birthday` answers that, and this is its first Story: what a birthday is once the calendar
has handed it over, which of them fall on a day, the tick the app keeps against one, and a store of
its own for those ticks. The switch, the day screen's group and the copy are each a later Story, and
all three are blocked on this one.

## What Changes

- A **birthday** is a contact, the calendar's own words for it that year, and the day it falls on.
- It is handed to the app, never composed by it: the words are kept exactly as handed.
- A birthday whose contact says nothing is refused.
- The birthdays on a day are the ones handed that fall on it, in the order they were handed.
- A birthday is ticked against its contact and its day, whatever its words say.
- A tick can be taken back; a second tick and a take-back of nothing are refused.
- A tick stays held until it is taken back, whatever the calendar hands afterwards.
- A birthday store keeps the ticks and nothing else, at a place of its own.
- It writes each change before reporting it kept, and refuses a place it cannot read.
- An ADR records that a tick is keyed to the contact and the day, and its cost on a new phone.

## Capabilities

### New Capabilities

- `birthday`: what a birthday handed by the calendar is, which birthdays fall on a day, the tick
  kept against one, and the store that keeps those ticks across the app being closed.

### Modified Capabilities

None.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — four new files: the value, the ticks, the store and the
  form on disk.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — two new test files, the value's and the store's.
- `docs/adr/` — a new record for the tick's key, with its `README.md` row.
- `CONTEXT.md` — **Birthday** amended for the tick's key, and **Birthday store** added.
- No screen, no shell file, no existing store or capability, and nothing that reads the calendar.
