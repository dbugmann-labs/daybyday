## Why

A happening once made can only be renamed. One that has stopped coming still sits in the day
screen's menu every day, and one made by mistake can never go. This Story lets a person stop a
happening, which takes it out of noting and keeps every occurrence, resume it, and delete one with
its occurrences, each from the commitments screen and each confirmed as a commitment's is.

## What Changes

- Happenings hold whether each is stopped; a stop and a resume keep its name, place and occurrences.
- A stopped happening takes no occurrence noted; its occurrences are still changed and taken back,
  its name still refuses a second, and it can still be renamed.
- Happenings delete a happening with every occurrence of it, which frees its name.
- The happening store keeps a stop, a resume and a deletion, in a new form; earlier forms read as
  holding nothing stopped.
- The commitments screen stops a happening once confirmed, resumes one in one tap, keeps a stopped
  one listed in its place and says it is stopped.
- The commitments screen deletes a happening once its name is typed back, and says how many
  occurrences go with it.
- One confirmation of any kind awaits at a time, a happening's and a commitment's alike.
- The day screen lists no stopped happening for noting on any day, and still draws its rows and
  opens its occurrences to be changed or taken back.
- The shell's Happenings card swipes to Stop, Resume and Delete, marks a stopped row "- Stopped",
  and asks with the alert and the delete sheet the grill settled.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `happening`: ADDED — stopping, resuming and deleting, at the value, the store and the commitments
  screen; MODIFIED — the store's form, what the screen tells, and what writes no copy.
- `day-screen`: ADDED — a stopped happening's rows and noting; MODIFIED — which happenings a day
  screen lists, and which a row's occurrences are read from.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `Happenings.swift`, `HappeningStore.swift` and
  `HappeningDocument.swift` stop, resume and delete; `CommitmentsScreen.swift` asks, confirms and
  says; `DayScreen.swift` lists the happenings not stopped and reads rows from all held.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — new test files beside the happening ones.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — the swipes, the marker, the alert, the sheet.
- `CONTEXT.md` — **Happening** amended at the grill.
