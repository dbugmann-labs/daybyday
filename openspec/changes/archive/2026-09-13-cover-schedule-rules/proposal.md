## Why

Four rules in `openspec/specs/schedule/spec.md` ship with no scenario that would fail were they
broken, so a later rewrite could drop or bend any of them with every check green. ADR-1047 has no
lane for a Story that adds scenarios to rules that already ship; this change records that lane and
applies it to `schedule` first.

## What Changes

- One scenario is added for each of four uncovered rules: the short-month clamp for the 28th and
  30th, an interval repeating with no final occurrence, the Gregorian weekday at both ends of the
  supported years, and calendar-anchored shapes matching in either direction.
- Each added scenario arrives with the one test named for it.
- The four requirements carrying them are MODIFIED, every sentence and existing scenario verbatim.
- No rule is reworded, no scenario is dropped, and no heading changes.
- The rules nothing can prove stay in the spec and are recorded as a *Known gaps* entry.
- ADR-1047 gains the covering-Story lane, and its owed budget review stays with the first
  behaviour Story.
- **No behaviour changes and no seam is new or changed.** A test red on arrival is fixed here,
  bounded to what makes that scenario pass.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `schedule`: four requirements MODIFIED, one scenario ADDED to each.

## Impact

- `openspec/changes/cover-schedule-rules/` — this folder.
- `openspec/specs/schedule/spec.md` — four scenarios, at archive.
- `src/DayByDayKit/Tests/DayByDayKitTests/DayOfMonthScheduleTests.swift` — one test added.
- `src/DayByDayKit/Tests/DayByDayKitTests/EveryNDaysScheduleTests.swift` — two tests added.
- `src/DayByDayKit/Tests/DayByDayKitTests/ScheduleTests.swift` — one test added.
- `docs/adr/1047-an-artifact-has-a-budget-and-condensing-is-a-story.md` — decision 7 added,
  decision 1 amended.
- `docs/adr/README.md` — the 1047 row extended.
- `docs/open-questions.md` — one *Known gaps* entry for `schedule`.
