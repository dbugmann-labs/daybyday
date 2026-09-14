## Why

Everything the app can hold today recurs. A form to send back by Friday and a call to make on the
20th have nowhere to go, so they are kept in someone's head or in another app, and the day screen
is not the whole of the day. `FEAT: one-off` (#239) answers that, and this is its first Story: the
value, the rule that says which day it stands on, its tick, and a store of its own. Both other
Stories under the Feature are blocked on it.

## What Changes

- A **one-off** is a name and a calendar date and nothing else; alike in both is the same one-off.
- A name that says nothing is refused by the value, exactly as a commitment's name is.
- A one-off stands on **exactly one day at a time**, answered as of a today.
- Undone, it stands on the later of its date and that today — so it follows today once its day has
  passed.
- Done, it stands on the day it was ticked, for good.
- A one-off is ticked on the day it was done, never on a day before the day it is owed on.
- A tick can be taken back, and the one-off stands again by the undone rule.
- A one-off is removed outright, done or not, tick and all, in one act.
- A one-off can be made already done, which is how a past day's one-off is written down.
- One-offs refuse a one-off alike in name and date, done or undone, and say so.
- A one-off store keeps them at a place of its own, writing each change before it reports it kept,
  and refuses a place it cannot read rather than emptying it.
- ADR-1052 records that a one-off follows today until it is done.

## Capabilities

### New Capabilities

- `one-off`: what a one-off is, which day it stands on as of a today, its tick and its removal, and
  the store that keeps one-offs across the app being closed.

### Modified Capabilities

None.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/OneOff.swift` — the value and its refusal.
- `src/DayByDayKit/Sources/DayByDayKit/OneOffs.swift` — what holds them and the standing rule.
- `src/DayByDayKit/Sources/DayByDayKit/OneOffStore.swift` — the store.
- `src/DayByDayKit/Sources/DayByDayKit/OneOffDocument.swift` — the form on disk, version 1.
- `src/DayByDayKit/Tests/DayByDayKitTests/OneOffTests.swift` — the value's acceptance tests.
- `src/DayByDayKit/Tests/DayByDayKitTests/OneOffStoreTests.swift` — the store's.
- `docs/adr/1052-a-one-off-follows-today-until-it-is-done.md` — new, with its `README.md` row.
- No screen, no shell file, and no existing store, document or capability is touched.
