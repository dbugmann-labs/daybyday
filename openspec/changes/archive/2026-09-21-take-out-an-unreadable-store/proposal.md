## Why

A copy is refused whole whenever one of the three places cannot be read, so the two places that
*can* be read have no way off the phone before a restore overwrites all three. "Left for a person
to recover" is empty when no person can reach the files: the Files app cannot see Application
Support, and the share sheet is the only door out.

## What Changes

- A take-out: the files at the record place, the roster place and the one-off place handed out
  exactly as they lie, each under the name it lies under, through the share sheet.
- A save in progress or a restore in progress still standing goes out beside them; the copy place
  setting does not.
- The take-out is offered on the commitments screen only while a store cannot be read — what lies
  there is not a store of its kind, or it was written by a later version of the app — and nowhere
  else, so no working phone can hand out torn saves or old forms.
- The offer says which stores cannot be read, and which of the two things is so for each.
- A take-out that cannot be made hands out nothing and is refused, naming the store.
- A take-out made says nothing on the screen afterwards.
- A refused copy over a store written by a later version says so, rather than that the store could
  not be read — the same file no longer carries two causes on one screen.
- A copy the app stopped making on its own tells the same two causes apart in its stop.
- A day screen not keeping a store says, once, that a copy can be restored and where; not where the
  only cause is a store written by a later version.

## Capabilities

### New Capabilities

None — `restore` already exists.

### Modified Capabilities

- `restore`: ADDED five requirements — what a take-out is, when it is offered and what it says,
  taking one out, a take-out that cannot be made, and the day screen's line. MODIFIED two — a
  refused copy and a stopped copy each tell a store written by a later version apart from one that
  could not be read.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/CommitmentsScreen.swift` — the take-out and what the screen
  says about the three places
- `src/DayByDayKit/Sources/DayByDayKit/CopyPlace.swift`, `DayScreen.swift`
- `src/DayByDayKit/Tests/DayByDayKitTests/`
- `src/DayByDay/DayByDay/CommitmentsView.swift`, `ContentView.swift`
- `CONTEXT.md`, `docs/open-questions.md`
