## Why

`openspec/specs/day-screen/spec.md` carries scenarios that assert nothing another scenario under the
same requirement does not, each with a passing test that proves the same thing twice. ADR-1047
decision 6 says which may be dropped; this change applies it to `day-screen`, as
`drop-duplicate-record-scenarios` applied it to `record`.

## What Changes

- Twenty-seven scenarios are dropped, each asserted in full by a kept scenario under the same
  requirement.
- The test carrying each dropped title is deleted in this change, and no test is added.
- The seventeen requirements that lose a scenario are REMOVED and ADDED back under a reworded heading.
- Each added requirement keeps its prose and every other scenario verbatim, and lands at the end of
  the spec, which is the one position change.
- Two requirements are MODIFIED in place: one follows a renamed heading it cites, and one names a
  day picked on the day picker among what changes the day a screen is showing, as its siblings do.
- Two kept tests are brought to their unchanged scenarios before any deletion, no assertion
  weakened; a red on either stops the change before anything is deleted and returns it to G4.
- ADR-1026's live reference to a renamed heading follows it.
- **No behaviour changes, no scenario title changes, and no seam is new or changed.**

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `day-screen`: two requirements MODIFIED; seventeen REMOVED and ADDED under new headings.

## Impact

- `openspec/changes/drop-duplicate-day-screen-scenarios/` — this folder.
- `openspec/specs/day-screen/spec.md` — twenty-seven scenarios, seventeen headings, three sentences.
- `src/DayByDayKit/Tests/DayByDayKitTests/DayViewTests.swift` — seven tests deleted, one kept test
  corrected.
- `src/DayByDayKit/Tests/DayByDayKitTests/DayScreenTests.swift` — twenty tests deleted, one kept
  test corrected.
- `docs/adr/1026-a-day-screen-keeps-the-day-you-moved-to.md` — one heading reference.
