## Why

`openspec/specs/commitment/spec.md` runs to nearly six thousand lines, and the surveys trace most of
its requirement prose to rationale the ADRs already record, to change history, or to a restatement of
the requirement next door. Prose that long hides rules: sentences that read as justification carry
behaviour a test asserts, so a trim by rhetorical shape passes every check and drops them silently.
ADR-1047 makes condensing a spec an editorial Story and sets the budget each requirement is written
to; `docs/research/2026-09-09-concise-specs.md` is the plan.

## What Changes

- Every requirement's prose is rewritten to 40–150 normative words — SHALL/MUST sentences, nothing
  else.
- Every sentence the four commitment surveys list under *Rules at risk* becomes one of those
  sentences, because each carries behaviour a scenario asserts or a neighbour leans on.
- Rationale an ADR already records is deleted rather than restated, and nothing is deleted before it
  has a home.
- Eleven pieces of rationale have no home: nine get one first, as four dated ADR amendments and one
  new ADR for this capability's write and refusal discipline, and two are dropped as arguments the
  rules they defend survive without.
- One requirement splits in two, being the only one any survey gives a division for; the rest that
  stay above the word budget are named in `design.md` with the rule that keeps each one there.
- Every scenario title, body and position is carried across verbatim: none is added, renamed, merged
  or dropped, including the two ADR-1047 already records as knowingly false.
- The rules the surveys find with no scenario survive as bare SHALL/MUST sentences; `design.md` lists
  the ones testable today as knowingly untested, and one backlog want carries them as a class.
- One rule is kept for a different reason: no requirement may identify a refusal by its position
  among the seven kinds, which is a rule about how this spec is written and testable by nothing.
- **No behaviour changes, nothing under `src/` or the tests changes, and there is no seam** —
  `design.md` says why that satisfies the Definition of Ready.
- Scenario deduplication is the plan's next phase and is not this Story: every deletion there takes
  an acceptance test and a CI-checked title with it.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: 40 requirements MODIFIED, carrying every scenario; 1 REMOVED and 2 ADDED, being the
  one requirement that splits, its scenarios divided verbatim between the two halves.

## Impact

- `openspec/changes/condense-commitment-spec/` — this folder.
- `openspec/specs/commitment/spec.md` — the prose of every requirement, and nothing else in it.
- `docs/adr/1035-a-roster-never-lets-a-commitment-go.md` — an unreadable store is never an empty one.
- `docs/adr/1038-a-category-is-the-rosters.md` — groups are never written to the file; categories are
  offered rather than case-folded; a change touching both places is one act.
- `docs/adr/1046-a-screen-judges-what-was-typed.md` — half a range is its own refusal, and a value the
  chosen kind has no room for is ignored.
- `docs/adr/1048-a-day-pickers-floor-is-the-earliest-day-kept-from.md` — why the aggregate question
  belongs to the roster.
- `docs/adr/1049-a-change-writes-the-record-place-first.md` — new: the order the two places are
  written in, and why no requirement numbers a refusal kind.
- `docs/adr/README.md` — one row.
