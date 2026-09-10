## Why

`openspec/specs/day-screen/spec.md` runs to five and a half thousand lines, and roughly three
quarters of its requirement prose is rationale the ADRs already record, change history, or a
restatement of the requirement next door. Prose that long hides rules: sentences that read as
justification carry behaviour a test asserts, so a trim by rhetorical shape passes every check and
drops them silently. ADR-1047 makes condensing a spec an editorial Story and sets the budget each
requirement is written to; `docs/research/2026-09-09-concise-specs.md` is the plan.

## What Changes

- Every requirement's prose is rewritten to 40–150 normative words — SHALL/MUST sentences, nothing
  else.
- Every sentence the three day-screen surveys list under *Rules at risk* becomes one of those
  sentences, because each carries behaviour a scenario asserts or a neighbour leans on.
- Rationale an ADR already records is deleted rather than restated, and nothing is deleted before
  it has a home.
- Seven pieces of rationale with no home get one first: five dated ADR amendments, one new ADR for
  the day picker's floor, and one glyph kept in its requirement as a normative sentence.
- Three requirements are split in two each, because none of the three reaches 150 words honestly.
- Two rules struck three times over — a row offers at most one entry kind, and the behaviours the
  three entry kinds share — are stated once and cross-referenced in one clause.
- Every scenario title, body and position is carried across verbatim: none is added, renamed,
  merged or dropped.
- The rules the surveys find with no scenario survive as bare SHALL/MUST sentences; the eight
  testable today are listed in `design.md` as knowingly untested and captured as one backlog want.
- **No behaviour changes, nothing under `src/` or the tests changes, and there is no seam** —
  `design.md` says why that satisfies the Definition of Ready.
- Scenario deduplication is the plan's next phase and is not this Story: every deletion there takes
  an acceptance test and a CI-checked title with it.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `day-screen`: 45 requirements MODIFIED, carrying every scenario; 3 REMOVED and 6 ADDED, being
  the three requirements that split, each replaced by two that carry its scenarios between them.

## Impact

- `openspec/specs/day-screen/spec.md` — the prose of every requirement, and nothing else in it.
- `docs/adr/1026-a-day-screen-keeps-the-day-you-moved-to.md` — a day view is a value.
- `docs/adr/1032-a-recorded-number-is-a-decimal.md` — the keypad prints either separator.
- `docs/adr/1034-a-schedule-says-its-rhythm-in-words.md` — every row says its rhythm, always.
- `docs/adr/1041-a-total-entrys-blank-commit-means-nothing.md` — the field is not prefilled.
- `docs/adr/1045-a-target-is-marked-and-what-offers-nothing-recedes.md` — the screen answers
  whether it offers the way back to today, because it gives out neither day.
- `docs/adr/1048-a-day-pickers-floor-is-the-earliest-day-kept-from.md` — new: the floor, the clamp,
  the refusal below it, and why the picker is always offered.
- `docs/adr/1047-an-artifact-has-a-budget-and-condensing-is-a-story.md` — a third scenario title
  known to be false, and it is this capability's.
- `docs/adr/README.md` — one row.
- `docs/backlog.md` — one want, for the rules that stay knowingly untested.
