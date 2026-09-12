## Why

`openspec/specs/commitment/spec.md` carries scenarios that assert nothing another scenario under the
same requirement does not, each with a passing test that proves the same thing twice. ADR-1047
decision 6 says which may be dropped; this change applies it to `commitment`, as
`drop-duplicate-day-screen-scenarios` applied it to `day-screen`, and is the last of the four.

## What Changes

- Eight scenarios are dropped, each asserted in full by a kept scenario under the same requirement.
- The test carrying each dropped title is deleted in this change, and no test is added.
- The seven requirements that lose a scenario are REMOVED and ADDED back under a reworded heading.
- Each added requirement keeps its prose and every other scenario verbatim, and lands at the end of
  the spec, which is the one position change.
- No kept test is edited and none is strengthened, so no deletion waits on a test going green.
- ADR-1047 gains the discriminator that proves decision 6's condition 1, and decision 5's list of
  false scenario titles loses the one this change drops.
- ADR-1049's live reference to a renamed heading follows it.
- **No behaviour changes, no scenario title changes, and no seam is new or changed.**

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: seven requirements REMOVED and ADDED under new headings.

## Impact

- `openspec/changes/drop-duplicate-commitment-scenarios/` — this folder.
- `openspec/specs/commitment/spec.md` — eight scenarios and seven headings.
- `src/DayByDayKit/Tests/DayByDayKitTests/CommitmentTests.swift` — one test deleted.
- `src/DayByDayKit/Tests/DayByDayKitTests/RosterTests.swift` — one test deleted.
- `src/DayByDayKit/Tests/DayByDayKitTests/CommitmentsScreenTests.swift` — six tests deleted.
- `docs/adr/1047-an-artifact-has-a-budget-and-condensing-is-a-story.md` — decisions 5 and 6.
- `docs/adr/1049-a-change-writes-the-record-place-first.md` — one heading reference.
