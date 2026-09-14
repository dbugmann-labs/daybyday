## Why

Rules in `openspec/specs/commitment/spec.md` ship with no scenario that would fail were they broken,
and several shipped tests assert less than the scenario they are named for, three of them provably
unable to fail. A later rewrite could bend any of those rules with every check green. This is the
fourth covering Story, and the first that strengthens tests as well as adding them.

## What Changes

- One scenario is added for each uncovered rule, each arriving with the one test named for it.
- Three of the new scenarios are expected red on arrival; each is fixed here, bounded to that scenario.
- Weak tests are strengthened in place under their titles, with a THEN reworded only where it did not
  name what would fail.
- The three tests shown unable to fail are rewritten and proven by a named mutation reddening each.
- Four rule sentences are reworded as little as keeps them true, each with its scenario.
- One scenario title recorded false is corrected, moving its requirement by REMOVED plus ADDED.
- Rules nothing can prove stay in the spec and are recorded as one *Known gaps* entry.
- ADR-1047 decision 7 is widened to this lane, and decision 5 loses the title corrected here.
- **No behaviour changes** beyond what a red arrival fixes; any internal seam is test-only.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: requirements MODIFIED with added scenarios; one requirement REMOVED and ADDED under
  a reworded heading.

## Impact

- `openspec/changes/cover-commitment-rules/` — this folder.
- `openspec/specs/commitment/spec.md` — at archive.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — `RosterTests`, `RosterStoreTests`, `CommitmentTests`
  and `CommitmentsScreenTests`, tests added and strengthened.
- `src/DayByDayKit/Sources/DayByDayKit/` — only what a red arrival fixes, and any test-only seam.
- `docs/adr/1047-an-artifact-has-a-budget-and-condensing-is-a-story.md` and `docs/adr/README.md`.
- `docs/open-questions.md` — one *Known gaps* entry for `commitment`.
- `CONTEXT.md` — *Covering Story*, amended at the grill.
