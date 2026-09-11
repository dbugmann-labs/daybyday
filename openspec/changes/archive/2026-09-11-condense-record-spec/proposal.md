## Why

`openspec/specs/record/spec.md` runs to 2,235 lines, of which 9,244 words are requirement prose, and
by the surveys' own split just under half of that prose is rationale nine ADRs already record or a
restatement of the requirement next door. Prose that long hides rules: sentences that read as
justification carry behaviour a test asserts, so a trim by rhetorical shape passes every check and
drops them silently. ADR-1047 makes condensing a spec an editorial Story and sets the budget each
requirement is written to; `docs/research/2026-09-09-concise-specs.md` is the plan.

## What Changes

- Every requirement's prose is rewritten to 40–150 normative words — SHALL/MUST sentences, nothing
  else.
- Every sentence the two record surveys list under *Rules at risk* becomes one of those sentences,
  because each carries behaviour a scenario asserts or a neighbour leans on.
- Rationale an ADR already records is deleted rather than restated, and nothing is deleted before it
  has a home.
- Three pieces of rationale with no home get one first, as three dated ADR amendments: text kept in
  the form it was typed in, a carry-over refusing rather than merging, and a part judged against the
  form it was first written at.
- Three more are homed without an ADR: the target that is a floor stays as a normative sentence, the
  "false record" refrain is `CONTEXT.md`'s and goes, and the note about why a reader gives back a
  value is dropped outright.
- Two requirements are split in two each, because neither reaches 150 words honestly; every scenario
  title goes verbatim to the half it belongs to.
- Every scenario title, body and position is carried across otherwise unchanged: none is added,
  renamed, merged or dropped.
- The seven rules the surveys find with no scenario survive as bare SHALL/MUST sentences, and
  `design.md` lists all seven as knowingly untested.
- **No behaviour changes, nothing under `src/` or the tests changes, and there is no seam** —
  `design.md` says why that satisfies the Definition of Ready.
- Scenario deduplication is the plan's next phase and is not this Story: every deletion there takes
  an acceptance test and a CI-checked title with it.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `record`: 15 requirements MODIFIED, carrying every scenario; 2 REMOVED and 4 ADDED, being the two
  requirements that split, each replaced by two that carry its scenarios between them.

## Impact

- `openspec/specs/record/spec.md` — the prose of every requirement, and nothing else in it.
- `openspec/changes/condense-record-spec/` — this folder: the delta, `proposal.md`, `design.md`,
  `tasks.md`, and the two files the grill left.
- `docs/adr/1023-a-commitment-is-kept-until-a-day-the-roster-holds.md` — a carry-over refuses on a
  collision rather than merging.
- `docs/adr/1031-a-store-reads-the-form-before-it.md` — a part is judged against the form it was
  first written at, never the newest.
- `docs/adr/1032-a-recorded-number-is-a-decimal.md` — text is kept in the exact form it was typed
  in, as numbers are kept digit for digit.
