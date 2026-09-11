## Why

`openspec/specs/schedule/spec.md` holds 3,448 words of requirement prose over 18 requirements, 12 of
them above the 150-word budget, and most of it is rationale an ADR already records. ADR-1047 decision
2 makes condensing it an editorial Story and keeps that rewrite out of any behaviour delta. Two live
wants, B-017 and B-025, would each modify the weekly-quota requirements, so this lands before either.
`docs/research/2026-09-09-concise-specs.md` is the plan.

## What Changes

- Every requirement's prose is rewritten to 40–150 normative words: SHALL/MUST sentences only.
- Every rule `grill-frontier.md` finds at risk or with no scenario becomes one of those sentences.
- Rationale an ADR already records is deleted, and nothing is deleted before it has a home.
- A new ADR-1051 records the short-month clamp, with skipping the month as the rejected alternative.
- ADR-1004 gains why a calendar date gives its three numbers back and none can be assigned.
- ADR-1034 gains why no start date is said, why seven a week is not "Every day", and why no day has words.
- The date-picker motivation for reading a calendar date back is dropped, with no home.
- The rules with no scenario stay as bare SHALL/MUST sentences; `design.md` lists them as untested.
- No requirement splits, and every scenario title, body and position is carried across verbatim.
- **No behaviour changes, nothing under `src/` or the tests changes, and there is no seam.**
- Pruning duplicate scenarios is the plan's next phase, and not this Story.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `schedule`: all 18 requirements MODIFIED, each carrying its scenarios; nothing REMOVED or ADDED.

## Impact

- `openspec/changes/condense-schedule-spec/` — this folder.
- `openspec/specs/schedule/spec.md` — the prose of every requirement, and nothing else in it.
- `docs/adr/1004-the-rule-engine-speaks-calendar-dates.md` — a calendar date reads back, and no part
  of it can be assigned.
- `docs/adr/1034-a-schedule-says-its-rhythm-in-words.md` — three arguments the prose carried alone.
- `docs/adr/1051-a-short-month-is-due-on-its-last-day.md` — new: the clamp, and why not skip.
- `docs/adr/README.md` — one row added, two extended.
- `docs/open-questions.md` — the known-gaps entry no longer says the read-back requirement's prose
  names the gaps it leaves open.
