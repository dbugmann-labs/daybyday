## Why

`openspec/specs/schedule/spec.md` carries scenarios that assert nothing another scenario under the
same requirement does not, each with a passing test that proves the same thing twice. ADR-1047
kept them through the condensing Story because it did not authorise pruning; this change amends it
to say what may be dropped, and applies that rule to `schedule` first.

## What Changes

- Six scenarios are dropped, each asserted in full by a kept scenario under the same requirement.
- The test carrying each dropped title is deleted in this change, and no test is added.
- The five requirements that lose a scenario are REMOVED and ADDED back under a reworded heading.
- Each added requirement keeps its prose and every other scenario verbatim.
- The two in-spec references to a renamed heading follow it, one of them in a MODIFIED requirement.
- The added requirements land at the end of the spec, which is the one position change.
- ADR-1047 gains the rule for what a pruning Story may drop, and decision 2 points to it.
- **No behaviour changes, no scenario title changes, and no seam is new or changed.**

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `schedule`: one requirement MODIFIED; five REMOVED and ADDED under new headings.

## Impact

- `openspec/changes/drop-duplicate-schedule-scenarios/` — this folder.
- `openspec/specs/schedule/spec.md` — six scenarios, five headings, two cross-references.
- `src/DayByDayKit/Tests/DayByDayKitTests/ScheduleTests.swift` — two tests deleted.
- `src/DayByDayKit/Tests/DayByDayKitTests/DayOfMonthScheduleTests.swift` — two tests deleted.
- `src/DayByDayKit/Tests/DayByDayKitTests/WeeklyQuotaScheduleTests.swift` — one test deleted.
- `src/DayByDayKit/Tests/DayByDayKitTests/EveryNDaysScheduleTests.swift` — one test deleted.
- `docs/adr/1047-an-artifact-has-a-budget-and-condensing-is-a-story.md` — decision 6 added.
- `docs/adr/README.md` — the 1047 row extended.
