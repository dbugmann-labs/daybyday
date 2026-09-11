# 1047. Every artifact has a budget, and condensing a spec is a Story

- Status: accepted
- Date: 2026-09-10
- Deciders: Diego Bugmann
- Amended: 2026-09-11 — the budgets are confirmed unchanged. The review decision 1 promised is
  carried to the first ordinary Story's G7, because every Story written under them so far is
  editorial; what those four showed is recorded under decision 1, and none of it moves a cap.
  Decision 2's mechanism is corrected on `openspec` 1.10.0: REMOVED plus ADDED is refused under the
  same heading and accepted only under new ones, and a rename does not carry a dropped scenario
  past the archiver. At #199's close-out.
- Amended: 2026-09-10 — decision 5's list of scenario titles known to be false grows from two to
  three, the third being `day-screen`'s, and decision 2's untried split mechanism is tried and
  recorded as accepted. Both by `condense-day-screen-spec` (#201), the first editorial Story
  written under this record.

## Context

The five capability specs are 12,515 lines and the change folders have grown from 167 lines for the
first Story to 2,086 for the largest. `docs/research/2026-09-09-concise-specs.md` measured both and is
the plan this record decides; #199 tracks the work it lays out.

Two different causes were found. **Requirement prose is 35% of the specs' words and roughly two thirds
of it is rationale**, most of it already recorded in twenty-four ADRs, often near verbatim — the
two-places-to-be-wrong problem `docs/process.md` §1 exists to prevent. Worse, that prose hides rules:
about a hundred sentences that read as justification carry a rule a test asserts, and about twenty of
those have no scenario at all, so a trim by rhetorical shape passes every CI check and drops them
silently. **Change-folder growth is a reopening problem, not a template problem.** The two outliers
were each reopened for a second and third G4, and each reopening added history rather than replacing
text — pasted test sources, build recipes, run logs, red/green diaries, "what the Nth review pass
found" sections, one `design.md` § Context of 132 lines holding five successive measurements. What
OpenSpec 1.10.0 offers against this was read out of the installed package: `openspec/config.yaml`
takes `context` and `rules.<artifact>`, injected into the instructions `/opsx:propose` reads, and
nothing in them is enforced — the stock schema says "keep it concise" and the folders grew anyway.

## Decision

**1. Every change-folder artifact and every requirement's prose has a budget.**

- `proposal.md` at most 60 lines. No Swift declarations, test counts, tool versions, SHAs or Story
  history, and no accounting for documents the change leaves alone.
- `design.md` at most 150 lines, with `### The seam` always present under Decisions and written as
  **signature lines only** — no doc comments, no bodies. Context states each fact once at its current
  value.
- `tasks.md` one line per scenario — the title verbatim plus at most one clause — and at most 80
  lines for everything else together. Never a pasted source, transcript or log.
- **Requirement prose is 40 to 150 normative words**: SHALL/MUST sentences, no rationale, no
  alternatives, no bold sentences, no Story history, and **every rule a scenario tests stated as a
  SHALL/MUST sentence** rather than only as a consequence or a "so that".

**Where each is enforced, and it is three places, not one.** `openspec/config.yaml` tells
`spec-author` what to write, and reaches `/opsx:propose` and nothing else. `.claude/agents/reviewer.md`
is the enforcement: the standards axis checks the budgets at G7 and reports an overrun as a finding.
`scripts/check-artifact-budgets.ts` is an **advisory lint** in `pnpm run checks`, one warning line per
overrun, **exit 0 always and not in CI**. Advisory is the decision, not a stage on the way to binding:
`docs/process.md` §12 calls this apparatus the ceiling of what one person at 4–8h/week can carry, and
a check refusing a merge over a word count is not proportionate to one.

**The caps are deliberately set below the current norm.** The six Stories archived on 2026-09-09 and
2026-09-10 had no reopening among them and still run 582–780 lines, `design.md` at 208–310 and
`tasks.md` at 235–342 — about twice these budgets, so it is the ordinary folder being trimmed and not
only the outliers. **Review the numbers after the first Stories written under them**, on evidence from
those folders rather than on the first overrun.

**The first Stories written under the budgets were the four editorial ones, and they are not the
review.** `proposal.md` and `tasks.md` held on all four. One `design.md` in four ran over,
`condense-commitment-spec`'s at 169 lines against 150, because § *Overruns the budget* and
§ *Open Questions* must each name every entry, and both lists grow with the spec rather than the
decision; without them the four files run 98 to 117. The requirements still over 150 words are
pre-budget prose kept whole by rule, spread so widely that twice the cap still leaves seventeen
over, so neither moves a number. The review is still owed on an ordinary folder, at the first
ordinary Story's G7. Measurements: `docs/research/2026-09-09-concise-specs.md`
§ *Outcome, 2026-09-11*.

**2. A spec may be condensed with no behaviour change, and the lane for that is a Story.** Rule 2 and
CI check 2 leave no other: `openspec/specs/` is written by `/opsx:archive` alone, and
`scripts/check-spec-containment.ts` fails any `chore/` branch touching a capability spec. An
**editorial Story** therefore has a change folder, a G4 and an archive like any other, and four
properties that make it unlike one: its delta **carries every requirement in full** — as
`## MODIFIED Requirements`, or as REMOVED plus ADDED where one requirement splits under decision 1
— every scenario title is unchanged, **no test changes**, and there is no seam, which `design.md`
says and explains. Rule 3's one-scenario loop is moot because there is no red.

**This is not folded into behaviour Stories.** Letting each requirement get concise the next time one
modifies it was the cheaper option, and was rejected because a MODIFIED block carries the whole
requirement: the rewrite would land inside a behaviour delta and G4 would read two kinds of change in
one diff.

**Scenario pruning is a different change and is not authorised here.** The archiver's
`findMissingCurrentScenarios` throws when a MODIFIED block omits a scenario the current spec holds —
*"current spec contains scenario(s) not present in the modified block ... Refresh the change spec
before archiving"* — so a condensing Story keeps every title. **REMOVED plus ADDED under new
headings is accepted**, tried on a scratch OpenSpec root before the first Story planned on it:
`openspec validate --strict` and `openspec archive` both take it, and the added requirements land at
the end of the spec file rather than in the removed one's place. The same heading under both is
refused (*"Requirement present in both ADDED and REMOVED"*), and so is a RENAMED plus MODIFIED pair
that omits a scenario, because the scenario check follows the rename — both tried on 1.10.0 at
#199's close-out. A requirement too big for the prose budget can therefore be split, at the cost of
where it sits in the file.

**3. The schema is not forked.** A fork into `openspec/schemas/` copies instruction text that drifts
from upstream on every upgrade; `rules` and `context` suffice, and the one template gap is one rule.

**4. On a reopen, artifacts are edited in place.** No measurement chronologies, no "what review pass N
found" sections, no red/green diaries, no re-issued seam. Leaving every still-true section exactly as
it was, so a second G4 could be read as a diff, is what turned two reopenings into folders of 1,600
and 2,000 lines; the G4 diff is the PR's diff, and the PR already has one.

**5. Three scenario titles are false and are kept on purpose** — two in
`openspec/specs/commitment/spec.md` and one in `openspec/specs/day-screen/spec.md`. The prose that
says so today is rationale the condensing Story deletes, so the fact lives here:

- *two commitments alike in name and not in rhythm are two entries a person cannot tell apart* — the
  test asserts two entries both named "Vitamins" and that stopping the first leaves one, which holds;
  the entries say different rhythms, so a person can in fact tell them apart, and the scenario after
  it asserts exactly that.
- *a commitment stopped through a commitments screen is kept until the day the screen was handed* —
  the test asserts the commitment is kept until **the day before** the one the screen was handed.
- *a day screen returned to does not read its record again* — a screen that **is** keeping a record
  does read it again, which `add-commitment-editing` (#148) settled when a rename gave the record
  place a second writer. The test asserts the narrower thing that is still true: a screen that could
  not read its record is returned to after the bytes at the place are removed, and
  `#expect(screen.recordState == .unreadable)` still holds, with its one row still drawn — a screen
  not keeping a record does not start keeping one by being returned to.

All three are kept because the archiver forbids dropping a scenario, and the only way to drop one is
removing its requirement and adding it back under a new heading, which moves the whole block to the
bottom of the spec at archive time.

## Consequences

- **The reviewer gains a checklist item that can be counted**, and an editorial Story gives it a
  fidelity axis it does not otherwise have: the survey's *Rules at risk* list, not the delta's
  scenario list. `design.md` § The seam loses its doc comments, which `tasks.md` re-issued anyway.
- **Nothing here can fail a build**, so an over-budget artifact merges if the reviewer and the human
  let it. The cost of this rule is a warning nobody reads; the cost of the other is a blocked Story.
- **Many requirements rewritten from pre-budget prose exceed 150 words honestly** — the ones
  carrying four record kinds' worth of rules. Split them, or say in `design.md` which are over and why.
- **G4 on a condensing Story is not a 45–90 minute read.** The delta is a whole file, so the read is
  `git diff --no-index` against the current spec — hours for a large capability, not §12's 45–90.

## Alternatives considered

**Fork the schema and rewrite the templates.** Rejected above: it buys the seam section and inherits a
permanent merge cost on every upgrade.

**A binding lint in CI.** Rejected: it blocks a merge on prose length, which `docs/process.md` §12
forbids adding to the check list, and the numbers are a first guess.

**Do not rewrite the existing specs at all**, applying the rules to new deltas only. Rejected under
decision 2: the rewrite would then happen inside behaviour Stories' deltas.

**Rewrite `grill.md` and the ADRs to the same budgets.** Refused: `grill.md`'s length is the
interview's, and ADRs are where the rationale being cut is supposed to go — condensing adds to them.
