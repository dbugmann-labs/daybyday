## Why

Twelve rules in `openspec/specs/record/spec.md` ship with no scenario that would fail were they
broken, so a later rewrite could drop or bend any of them with every check green. One of them is
broken in the code today: a store writes at its place on a change that leaves its history as it was.
Two `day-screen` scenarios hold only because it does, and fixing it makes them false.

## What Changes

- One scenario is added for each of twelve uncovered rules, across ten requirements, each arriving
  with the one test named for it.
- The ten requirements are MODIFIED, every sentence and every existing scenario verbatim.
- No rule is reworded, no scenario is dropped, and no heading changes.
- A store stops writing on a change that leaves its history as it was: the one test expected red on
  arrival, and the least fix that turns it green.
- One `day-screen` requirement is MODIFIED: two of its scenarios lose the AND line saying that
  committing nothing on a row at an unwritable place is told there. A blank commit where nothing is
  held now keeps nothing and tells nothing. Their two tests lose the matching block (grill answer 12).
- The rules nothing can prove stay in the spec and are recorded as a *Known gaps* entry for `record`.
- What a day whose additions overflow answers is recorded as an open product question, not decided.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `record`: ten requirements MODIFIED, twelve scenarios ADDED among them.
- `day-screen`: one requirement MODIFIED, one AND line dropped from each of two scenarios.

## Impact

- `openspec/changes/cover-record-rules/` — this folder.
- `openspec/specs/record/spec.md` — twelve scenarios, at archive.
- `openspec/specs/day-screen/spec.md` — two AND lines removed, at archive.
- `src/DayByDayKit/Tests/DayByDayKitTests/DayScreenTests.swift` — one blank-commit block removed
  from each of two tests.
- `src/DayByDayKit/Sources/DayByDayKit/RecordStore.swift` — the least fix for the one red.
- `src/DayByDayKit/Tests/DayByDayKitTests/RecordStoreTests.swift` — seven tests added.
- `src/DayByDayKit/Tests/DayByDayKitTests/RecordTests.swift` — five tests added.
- `docs/open-questions.md` — one *Known gaps* entry and one open product question.
