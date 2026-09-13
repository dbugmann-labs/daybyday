## Why

Twelve rules in `openspec/specs/record/spec.md` ship with no scenario that would fail were they
broken, so a later rewrite could drop or bend any of them with every check green. One of them is
broken in the code today: a store writes at its place on a change that leaves its history as it was.

## What Changes

- One scenario is added for each of twelve uncovered rules, across ten requirements, each arriving
  with the one test named for it.
- The ten requirements are MODIFIED, every sentence and every existing scenario verbatim.
- No rule is reworded, no scenario is dropped, and no heading changes.
- A store stops writing on a change that leaves its history as it was: the one test expected red on
  arrival, and the least fix that turns it green.
- The rules nothing can prove stay in the spec and are recorded as a *Known gaps* entry for `record`.
- What a day whose additions overflow answers is recorded as an open product question, not decided.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `record`: ten requirements MODIFIED, twelve scenarios ADDED among them.

## Impact

- `openspec/changes/cover-record-rules/` — this folder.
- `openspec/specs/record/spec.md` — twelve scenarios, at archive.
- `src/DayByDayKit/Sources/DayByDayKit/RecordStore.swift` — the least fix for the one red.
- `src/DayByDayKit/Tests/DayByDayKitTests/RecordStoreTests.swift` — seven tests added.
- `src/DayByDayKit/Tests/DayByDayKitTests/RecordTests.swift` — five tests added.
- `docs/open-questions.md` — one *Known gaps* entry and one open product question.
