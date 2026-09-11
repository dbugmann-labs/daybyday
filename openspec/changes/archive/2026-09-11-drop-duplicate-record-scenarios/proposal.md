## Why

`openspec/specs/record/spec.md` carries scenarios that assert nothing another scenario under the
same requirement does not, each with a passing test that proves the same thing twice. ADR-1047
decision 6 says which may be dropped; this change applies it to `record`, as
`drop-duplicate-schedule-scenarios` applied it to `schedule`.

## What Changes

- Sixteen scenarios are dropped, each asserted in full by a kept scenario under the same requirement.
- The test carrying each dropped title is deleted in this change, and no test is added.
- The nine requirements that lose a scenario are REMOVED and ADDED back under a reworded heading.
- Each added requirement keeps its prose and every other scenario verbatim, and lands at the end of
  the spec, which is the one position change.
- Two scenario lines that call a carry-over with nothing to carry a refusal are reworded to say it
  refuses nothing; their titles stay, and their two requirements are MODIFIED in place.
- Seven kept tests are brought to their unchanged scenarios' values, no assertion weakened; one that
  fails is withdrawn from this change rather than bent to pass.
- Two source doc comments that quote a renamed heading follow it; no code line changes.
- **No behaviour changes, no scenario title changes, and no seam is new or changed.**

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `record`: two requirements MODIFIED; nine REMOVED and ADDED under new headings.

## Impact

- `openspec/changes/drop-duplicate-record-scenarios/` — this folder.
- `openspec/specs/record/spec.md` — sixteen scenarios, nine headings, two scenario lines.
- `src/DayByDayKit/Tests/DayByDayKitTests/RecordTests.swift` — twelve tests deleted, two kept tests
  corrected.
- `src/DayByDayKit/Tests/DayByDayKitTests/RecordStoreTests.swift` — four tests deleted, five kept
  tests corrected.
- `src/DayByDayKit/Sources/DayByDayKit/Note.swift` and `Addition.swift` — one doc comment each.
