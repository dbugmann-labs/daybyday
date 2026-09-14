## Why

Rules in `openspec/specs/day-screen/spec.md` ship with no scenario that would fail were they broken,
so a later change could bend any of them with every check green. This covering Story gives each such
rule a scenario of its own, under ADR-1047 decision 7, and records the rules nothing can prove.

## What Changes

- One scenario is added for each uncovered rule a seam reaches: moves, going back to today and
  picking a day, the two places' refusals, reading a typed number, changes on a neighbour day, the
  day picker's reach, what a tick, a return and a showing again leave said, and a take-back refused
  by the place.
- Each added scenario arrives with the one test named for it.
- Every requirement carrying one is MODIFIED, every sentence and existing scenario verbatim but one.
- One rule is reworded, because `cover-record-rules` made it false on `main`: a take-back reaches
  the place only where the day holds a number. No scenario is dropped, and no heading changes.
- Rules the grill listed that an existing scenario already covers get no scenario; `design.md` names
  the scenario that covers each.
- The rules nothing can prove stay in the spec and are recorded as one *Known gaps* entry.
- **No behaviour changes and no seam is new or changed.** A test red on arrival is fixed here,
  bounded to what makes that scenario pass.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `day-screen`: sixteen requirements MODIFIED, each gaining the scenarios for its uncovered rules.

## Impact

- `openspec/changes/cover-day-screen-rules/` — this folder.
- `openspec/specs/day-screen/spec.md` — the added scenarios, at archive.
- `src/DayByDayKit/Tests/DayByDayKitTests/DayScreenTests.swift` — one test per added scenario.
- `docs/open-questions.md` — one *Known gaps* entry for `day-screen`.
