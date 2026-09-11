# Making the specs and change folders concise

**Status: a plan, not a decision, and nothing here is implemented.** Recorded 2026-09-09 against
`main` at `4e64641`, `openspec` 1.10.0. Every line number below is as of that commit. **Several
Stories will ship before this plan is taken up** — `add-commitment-editing` (#148) and
`add-day-picker` (#176) are in flight today and more will follow — so everything measured here
is a snapshot, and § *Before taking this up* is the step that brings it back to the truth. The
plan then runs between two Stories, so that the next one cut is the first written under the new
rules. The seven survey reports it rests on are in `2026-09-09-concise-specs/`, one per spec
range and one for the change folders; they are the checklists the rewrite Stories work from,
not background reading.

## The question

The capability specs are 12,515 lines and the change folders have grown from 167 lines for the
first Story to over 2,000 for the largest. Can `openspec/config.yaml` make future artifacts
shorter, and should the existing specs be rewritten to the same shape?

## What was measured

### The specs

| Spec | Lines | Requirements | Scenarios | Words | Requirement prose (words) |
|---|---|---|---|---|---|
| `cli-version` | 51 | 2 | 4 | 367 | 116 |
| `schedule` | 740 | 18 | 78 | 7,593 | 3,448 |
| `record` | 2,235 | 17 | 170 | 27,705 | 9,244 |
| `commitment` | 5,896 | 41 | 406 | 72,140 | 26,522 |
| `day-screen` | 5,562 | 48 | 399 | 71,412 | 24,847 |
| **Total** | **14,484** | **126** | **1,057** | **179,217** | **64,177** |

*Re-measured 2026-09-10 on `main` at `662809f`. On 2026-09-09 at `4e64641` the totals were 12,515
lines, 114 requirements, 932 scenarios, 153,590 words and 54,287 words of prose; the six Stories
archived in between added 16 requirements, rewrote 21 and removed 4.*

"Requirement prose" is the text between a `### Requirement:` heading and its first scenario. It
is **35% of the words**. The other 65% is scenarios, and every one of the 932 scenarios is
already the target shape: WHEN/THEN/AND bullets and nothing else, checked mechanically across
all five files. So the size problem has two different causes, and they need two different
answers.

**The prose is two-thirds rationale.** Across the four large specs the surveys rate the prose
at roughly 45–65% normative, 25–45% rationale and alternatives, and 10–25% cross-references
and restatements of neighbouring requirements. One requirement in `commitment` (line 518,
*A roster refuses a commitment it already holds*) runs 1,315 words before its first scenario;
`cli-version`'s two requirements run 64 and 52 and are the reference shape. Almost all of the
rationale is already recorded: the surveys traced it to ADR-1004, 1013, 1015, 1017, 1021, 1022,
1023, 1026, 1027, 1028, 1030, 1031, 1032, 1033, 1034, 1035, 1036, 1037, 1038, 1039, 1040, 1041,
1044 and 1045, often near verbatim. That is the two-places-to-be-wrong problem `docs/process.md`
§1 exists to prevent, and it is the strongest reason to cut.

**But the prose hides rules.** The surveys list, requirement by requirement, sentences that read
as justification and carry a rule a test asserts or a later requirement leans on. There are
around a hundred of them, and roughly twenty have **no scenario at all** — prohibitions and
absences such as "a store MUST NOT persist the day's sum" (`record` line 679) or "the total
entry's field is not prefilled" (`day-screen` line 4019). A trim that deletes paragraphs by
rhetorical shape passes every CI check and silently drops those. This is why the rewrite is
extraction first and deletion second, and why it is Opus-grade work read at G4, not a script.

**Scenario count is a separate lever.** The surveys find about 118 scenarios (13%) that repeat
another with only a fixture or a record kind swapped: seven fixtures of one rule in `day-screen`
requirement 24, thirteen stop/remove twins in `commitment` requirement 12, the 27/31/35 and
29/33/38 families in `day-screen` that restate one behaviour per record kind. Each drop deletes
a passing acceptance test and, as § *Mechanism* explains, cannot ride on the prose rewrite.

### The change folders

| Folder | proposal | design | tasks | total |
|---|---|---|---|---|
| `2026-08-23-add-version-command` | 37 | 83 | 47 | 167 |
| `2026-08-30-add-weekday-set-schedule` | 59 | 233 | 120 | 412 |
| `2026-09-06-add-commitments-screen` | 207 | 728 | 1,151 | 2,086 |
| `2026-09-08-add-number-entry` | 173 | 581 | 888 | 1,642 |
| `2026-09-09-add-offered-today-control` | 96 | 239 | 203 | 538 |

The change-folder survey finds one cause dominating: **reopening**. The two outliers were each
reopened for a second and third G4, and each reopening added history rather than replacing text.
In `add-commitments-screen`, 406 lines of `tasks.md` (35%) are a pasted UI-test source file, an
Xcode recipe and run logs inside one box; another ~300 are red/green diaries and "what the Nth
review pass found" sections. `design.md` spends 121 lines on the full Swift declaration of the
seam, re-issued three times in `tasks.md`, and 120 on which review pass changed what.
`add-number-entry`'s `design.md` § Context is 132 lines of five successive measurements, four of
which exist to correct the one before. The latest folder, `add-offered-today-control`, is close
to the floor already: one line per scenario box, one setup section, one gates section.

The survey's estimate is that the rules below would have brought `add-commitments-screen` to
roughly 60 / 180 / 155 lines from 207 / 728 / 1,151.

## What OpenSpec 1.10.0 can configure

Verified against `dist/core/project-config.js` and `dist/core/artifact-graph/instruction-loader.js`
in the installed package, not from memory.

- `openspec/config.yaml` takes `schema`, `context`, `rules`, `operations` and `githubCopilot`.
  This repo's file is the `init` scaffold with every key commented out; nothing has ever been
  configured.
- `context` is injected into the instructions for every artifact; `rules.<artifact>` only into
  that artifact's, keyed by the schema's artifact ids `proposal`, `specs`, `design`, `tasks`.
  Unknown ids warn. Both reach `spec-author` through `/opsx:propose` step 5a, which runs
  `openspec instructions <artifact> --json` and treats them as "constraints for you, not content
  for the file".
- `operations.apply.guidance` and `operations.archive.guidance` are advisory lists read by
  `openspec instructions apply|archive`. The docs say workflows "may decline to follow entries
  that conflict".
- Templates can only be replaced by forking the whole schema into `openspec/schemas/<name>/`
  (`openspec schema fork spec-driven <name>`) and pointing `schema:` at it. **Do not.** A fork
  copies the schema's instruction text, which then drifts from upstream on every `openspec`
  upgrade, and the one template gap that matters — `design.md` has no seam section — is a one-line
  rule.
- Nothing in `rules` is enforced. The stock schema already says "Keep it concise (1-2 pages)"
  for proposals and "reference the proposal ... if a section would only restate them, point to
  them instead" for design, and the folders grew anyway. Rules change what an agent is told;
  the reviewer's checklist and a lint are what change what it ships.

## The proposed `openspec/config.yaml`

**Corrected 2026-09-10.** The first draft of this block wrote each rule as a plain scalar, and a
bare `word: word` inside one (`normative only: SHALL/MUST`) is a YAML mapping. `openspec` 1.10.0
then prints *could not parse … ignoring it* and runs with no context and no rules — a warning,
never a failure, which is exactly how it would have gone unnoticed. Every rule is now a folded
scalar (`>-`), and the block below is the file as committed and proven: `openspec instructions`
returns 3 / 5 / 5 / 5 rules for proposal / specs / design / tasks, the context on all four, and
`operationGuidance` on apply and archive.

```yaml
# Governed by ADR-1047; every rule below is repeated for the reviewer in
# .claude/agents/reviewer.md. Rules are folded scalars (>-) because a bare
# "word: word" inside a list item is a YAML mapping and the CLI then ignores
# the whole file with a parse warning — it does not fail.
schema: spec-driven

context: >-
  DayByDay: an iPhone app. The engine and screens are a Swift package, DayByDayKit, under
  src/; the SwiftUI shell draws what the screens answer. AGENTS.md and CONTEXT.md are binding.
  Every `#### Scenario:` title becomes an acceptance test name verbatim and CI checks it.
  A spec states the rule and stops; rationale lives in docs/adr/ and design.md.
  Say each thing once, in the one artifact it belongs to.

rules:
  proposal:
    - >-
      Hard cap 60 lines. Why at most 6 lines; What Changes at most 12 one-line bullets;
      Capabilities names capability paths and ADDED/MODIFIED/REMOVED only; Impact at most
      12 lines naming files and directories.
    - >-
      No Swift declarations, member names, test counts, tool versions, commit SHAs, dates or
      Story history anywhere in this file.
    - >-
      Do not account for documents the change leaves alone.
  specs:
    - >-
      Requirement prose is normative only: SHALL/MUST sentences, 40 to 150 words, one or two
      paragraphs. No rationale, no alternatives, no "this is the decision", no bold
      sentences, no Story or issue history.
    - >-
      Every rule a scenario tests is a SHALL/MUST sentence, never only a consequence, a
      "so that" or a "therefore".
    - >-
      State each rule once, in the requirement it belongs to. Cross-reference another
      requirement in one clause only where a test depends on it; never restate it.
    - >-
      Scenarios are WHEN/THEN/AND bullets only. One scenario per distinct behaviour: a
      fixture variation is an extra AND on the existing scenario, and a copy per record
      kind only where the kinds answer differently.
    - >-
      A MODIFIED requirement carries the whole block verbatim except the sentences that
      change.
  design:
    - >-
      Hard cap 150 lines: Context at most 20, Goals/Non-Goals 12, Decisions 80, Risks 20,
      Open Questions 12.
    - >-
      Always include "### The seam" under Decisions: each new or changed member as one
      signature line, no doc comments, no bodies.
    - >-
      One decision is at most 12 lines: the choice, why, then each rejected alternative in
      one line. A decision that outlives the change goes to docs/adr/ and is cited by number.
    - >-
      Context states each fact the design turns on once, as its current measured value. No
      chronology of measurements and no review-pass or reopening history; on a reopen, edit
      in place.
    - >-
      Reference proposal.md and the delta instead of restating them. Open Questions lists
      only what is still open, or "None." with the reason.
  tasks:
    - >-
      One box per scenario, one line: the title verbatim plus at most one clause naming the
      wrong implementation it catches. Setup, shell, gates and the archive handover at most
      80 lines together.
    - >-
      Never paste source, test bodies, build recipes, command transcripts or logs. A
      verification is one line: what ran, the count, pass or fail.
    - >-
      State the rule-5 stop once at the top of the file. One test-count assertion for the
      whole file, in the final gate box, read off a run and never derived by arithmetic.
    - >-
      No "what review pass N found" sections and no red/green diary. On a reopen, edit the
      boxes that change and add the new scenario boxes.
    - >-
      Every box tickable before /opsx:archive; a post-archive check is prose inside a box
      that says who ticks it and when.

operations:
  apply:
    guidance:
      - >-
        Tick boxes as they complete. Add no prose, logs or code to tasks.md.
  archive:
    guidance:
      - >-
        Report the archive in three lines: what moved, what the spec diff touched, what
        is left for the janitor.
```

Two things in it are deliberate trade-offs. The 150-word ceiling on requirement prose will be
exceeded by a handful of requirements that genuinely carry four record kinds' worth of rules
(`record` 1 and 5, `day-screen` 3); the surveys recommend splitting those rather than squeezing
them, and a Story may say so in its `design.md`. And the seam-as-signatures rule loses the doc
comments that `design.md` § The seam has carried; the change-folder survey judged those the
part of the seam that `tasks.md` re-issues anyway.

### What has to move with it

`config.yaml` reaches only `/opsx:propose`. Four other places state the artifacts' shape, and
if they keep saying the old thing the rules lose:

1. `.claude/agents/spec-author.md` — add the same budgets as a numbered step, and replace the
   "every section still true is left exactly as it was, so the second G4 is read as a diff"
   practice, which is what turned reopenings into history sections, with "edit in place; the G4
   diff is the PR's diff".
2. `.claude/agents/reviewer.md` — the standards axis checks the four budgets and the "no rule
   only as a consequence" rule, and reports overrun as a finding.
3. `.claude/agents/implementer.md` — ticks boxes and writes nothing else into `tasks.md`.
4. `docs/process.md` §9 DoR — one line: the change folder is within its budgets.

Whether to add a lint is the one open call. A script under `scripts/` that counts words between
each `### Requirement:` heading and its first scenario, and lines per artifact, is an hour's
work and would run in `pnpm run checks` as advisory. The argument for it is the history above:
the stock schema's "keep it concise" did nothing. The argument against is one more check on a
list `docs/process.md` §12 already calls the ceiling. Recommendation: **add it, advisory only,
never binding** — a warning in the PR log is enough for one human to see the trend.

## Mechanism: how a spec rewrite can land at all

This is the part that decides the shape of the work, and it was checked against the archiver's
source rather than assumed.

- **Rule 2 and CI check 2 close the chore lane.** `openspec/specs/` is written by `/opsx:archive`
  only, and `scripts/check-spec-containment.ts` fails any `chore/` branch that touches a
  capability spec. A rewrite is therefore a **Story**, with a change folder, a G4 and an archive,
  even though it changes no behaviour. `docs/process.md` §5 says chores are for "no behaviour
  change", which reads as if it covers this; it does not, and the ADR below should say so.
- **The delta is `## MODIFIED Requirements` carrying every requirement in full.** The archiver
  (`dist/core/specs-apply.js`) replaces a requirement block by its normalised heading, so the
  delta file is the rewritten spec minus `## Purpose`. Editing `## Purpose` is the one hand-edit
  the schema itself sanctions, and none of the five needs it.
- **Scenario titles cannot change and none can be dropped.** `findMissingCurrentScenarios`
  makes the archive throw if a MODIFIED block omits any scenario the current spec holds:
  *"current spec contains scenario(s) not present in the modified block ... Refresh the change
  spec before archiving"*. So the prose rewrite keeps all 932 titles, and CI check 4 passes
  without a single test changing, because every title already has one.
- **Dropping duplicate scenarios is a different change** and its mechanism is **unverified**:
  the schema documents `RENAMED` (FROM/TO) and `REMOVED` (with Reason and Migration), and the
  archiver rejects a name that appears under both MODIFIED and ADDED or REMOVED. Whether
  REMOVED plus ADDED under the same heading in one delta is accepted has not been tried. Try it
  on a scratch change before planning phase 3 on it.
- **Rule 3 is moot for a rewrite Story** — there is no red-green loop because no test changes —
  and `tasks.md` says so in one line rather than pretending otherwise.
- **G4 reads a diff, and the delta is a whole file.** The PR diff shows a new 2,000-line file.
  The useful read is the current spec against the delta:

  ```bash
  git diff --no-index openspec/specs/day-screen/spec.md \
      openspec/changes/condense-day-screen-spec/specs/day-screen/spec.md
  ```

  and the archive commit at G8 shows the same diff a second time, in place. The G4 read is
  still the long one: for `day-screen` it is a diff over ~4,900 lines, and §12's 45–90 minutes
  per Story will not hold. Budget two to three hours of your time for each of the two large
  capabilities, and read the survey's *Rules at risk* list against the rewritten requirements
  rather than the whole diff.

## Before taking this up: re-baseline

Every Story that merges after `4e64641` adds or modifies requirements that no survey has read.
They were written under the old habits, so they carry the same rationale-in-prose and the same
rules-hidden-in-commentary as everything above, and a rewrite Story that works only from the
surveys in this folder would trim them blind. The first step of phase 1, before any config lands,
is therefore to list what shipped and survey it:

```bash
git fetch origin
git log --oneline 4e64641..origin/main -- openspec/specs/            # which Stories landed
git diff 4e64641 origin/main -- openspec/specs/ | grep -E '^\+### Requirement:'   # what they added
git diff --stat 4e64641 origin/main -- openspec/specs/ docs/adr/       # how much moved, and which ADRs came with it
```

For each requirement that list names, run the same survey the seven reports were produced by —
one subagent per capability or per requirement range, read-only, reporting the same five things:
the per-requirement table (prose words, scenario count, normative / rationale / cross-reference
split, verdict, words after), **Rules at risk** (sentences that read as rationale but carry a rule
a test or a later requirement depends on, quoted with line numbers), **Rationale needing a home**
(which ADR already records it, or none), **Scenario duplication**, and totals. Write each report
beside the seven here, dated, and refresh the phase 2 table's numbers from them. The survey's
*Rules at risk* list is what the reviewer works from at G7, so a requirement that is not on one
is a requirement the rewrite can silently break.

Two more things go stale with the specs. The line numbers in every report and in this document
are as of `4e64641` and will have drifted; re-anchor by requirement title, never by line. And any
Story that reopened a change folder after this date is one more data point for the change-folder
survey — if one grew past the phase 1 budgets, note which rule would have caught it before
writing the config.

### The re-baseline of 2026-09-10

Done as step 3 of the checklist below, on `main` at `662809f`. The block list is
`2026-09-09-concise-specs/rebaseline-2026-09-10-changed-blocks.md` and the four reports are
`survey-2026-09-10-record.md`, `survey-2026-09-10-commitment-modified.md`,
`survey-2026-09-10-commitment-added.md` and `survey-2026-09-10-day-screen.md`. What they add to the
seven originals, in order of how much it matters to the rewrite:

- **A shipped rule was reversed and the old sentence's shape survived.** `day-screen`'s *reads its
  roster again when it is returned to* now re-reads the record too (#148); the earlier survey's
  note for it records the retired rule. A trimmer working from the old notes preserves a rule that
  no longer holds. The new report supersedes the old entry.
- **The blocks written after the first survey repeat its worst habit at full strength.** The seven
  ADDED `commitment` blocks average 678 prose words; `commitment`'s *already-kept vs.
  could-not-be-written* grew 85% and gained no scenario, so its three new rules live in prose
  alone. Around twenty rules across the new blocks have **no scenario at all**; the reports list
  them, and the grill for each Story asks whether each becomes a scenario or is recorded as
  knowingly untested.
- **Rules stated in two places with no scenario under either**: `day-screen`'s move-vs-draw pair
  appears in both *a move with nowhere to go* and *no day view before the first date*. Trim both
  and it is stated nowhere — the same failure the first survey caught between its requirements 5
  and 19.
- **Rationale with no ADR home, new since the plan**: `commitment`'s rule that the seven refusal
  kinds are never numbered (a rule about how requirements are written, not behaviour), the
  record-place-before-roster-place write order, the aggregate earliest-day question, the
  offering-and-case rule for categories, half-a-range, ignore-rather-than-refuse, and
  one-act-one-outcome; `record`'s note fidelity and merge-vs-refuse; `day-screen`'s day-picker
  floor and clamp (in the archived `add-day-picker` design only). Each is a grill question.
- **Verdicts moved**: no block in the re-baselined scope is `keep`, and four `commitment` blocks
  that were `trim` are now `rewrite`.

## The plan

### Phase 0 — this PR

Land this document and the seven surveys. Nothing else changes.

### Phase 1 — stop the growth (one chore, after #148 and #176 merge)

`chore/concise-artifacts`, cut once the re-baseline above is done and no Story is between its
propose and its merge: the `config.yaml` above, the four agent and process edits, an ADR
recording (a) the artifact budgets and where they are enforced, (b) that a spec may be
rewritten with no behaviour change as a Story whose delta is MODIFIED-only and whose tests do
not change, and (c) that the schema is not forked and why. Optionally the advisory lint. Half a
day of agent work, one PR to read.

One decision sits here: **which Story is the rehearsal.** Whatever Story is proposed first after
phase 1 merges is the first one written under the new rules, and the cheapest test of them. The
recommendation is to land phase 1 in the gap before an ordinary, small Story rather than before a
large one, so the first folder read against the budgets is one where an overrun is easy to see.

### Phase 2 — rewrite the prose, one Story per capability, sequential

| Order | Change id | Prose words now → after | Scenarios | Why this order |
|---|---|---|---|---|
| 1 | `condense-day-screen-spec` | 24,847 → ~6,600 | 399, unchanged | largest; every one of the 15 blocks changed since the survey is over 150 words |
| 2 | `condense-commitment-spec` | 26,522 → ~8,750 | 406, unchanged | second largest; the seven ADDED blocks average 678 prose words each |
| 3 | `condense-record-spec` | 9,244 → ~2,520 | 170, unchanged | nine of seventeen need re-extraction; two requirements to split |
| 4 | `condense-schedule-spec` | 3,448 → ~1,835 | 78, unchanged | optional — the saving is 1,600 words; do it only if 1–3 went smoothly |
| — | `cli-version` | 116 → 103 | 4 | leave alone; it is the reference shape |

Total: 64,177 → ~19,800 prose words (−69%), 179,217 → ~135,000 words overall, roughly 14,500 →
11,000 lines — **as of `662809f`, refreshed by the 2026-09-10 re-baseline.** The scenarios are untouched, which is why the file count of lines falls by only a
quarter while the prose falls by two-thirds.

Each Story runs the ordinary pipeline with three adaptations:

- **The grill is short and pre-written.** Its frontier is the survey's *Rationale needing a home*
  entries with no ADR (about seventeen across the five specs: the short-month clamp, the
  calendar-date read-back, the no-prefill rule, the phone-capitalisation argument, the
  keypad-comma argument, and so on) and its *Rules at risk* entries that have no scenario.
  Each is one question: write an ADR paragraph, keep the rule as a bare SHALL, or drop it
  deliberately. The conductor asks them as rounds; nothing else needs asking.
- **`spec-author` works one requirement at a time against the survey's checklist**: extract
  every rule the survey lists into a SHALL/MUST sentence, then delete, then check the
  requirement's own scenarios still have a sentence each of them asserts. The two halves of a
  large spec must not be trimmed in parallel: `day-screen` requirements 5 and 19 each defer one
  rule to the other, and two agents would delete it twice.
- **The reviewer's fidelity axis is the survey's *Rules at risk* list**, not the delta's scenario
  list. `reviewer` gets the survey file as input and reports any listed sentence whose rule is
  no longer stated.

Two structural moves ride along where the survey found them: five scenarios under `day-screen`
requirement 17 that test requirement 16, and one under `cli-version` requirement 1 governed by
requirement 2, move to the requirement they belong to (a scenario moving between MODIFIED
blocks in one delta keeps its title, so the archiver accepts it — verify on the first Story).
And two paragraphs must not simply vanish: `commitment` lines 1631–1638 and 2255–2260 record
that a scenario title is now false and is kept only because the archiver forbids dropping it.
That is a fact about the process, and it goes into the ADR from phase 1, not into a spec and
not into the bin.

### Phase 3 — drop duplicate scenarios (optional, gated, not before phase 2)

About 118 scenarios, 13% of the total, each deleting a test. Do it only if the specs still feel
long after phase 2, only after the REMOVED/ADDED mechanism is verified on a scratch change, and
one capability at a time. The surveys name every candidate pair and which to keep.

## Where this plan pushes back on the ask

**The specs are large mostly because they have 932 scenarios, not because the prose is long.**
Cutting the prose by two-thirds removes a third of the words. If the number that bothers you
is the line count, the lever is the scenario-density rule in `rules.specs` for future Stories,
and phase 3 for the past. The prose rewrite is still worth doing, but for a different reason:
it is the correctness hazard that some twenty tested rules exist only as sentences that look
like commentary, which the next MODIFIED delta will trim.

**The change-folder bloat is a reopening problem, not a template problem.** The baseline folders
were fine. The rules that matter most are the three about history — no measurement chronologies,
no review-pass sections, edit in place on a reopen — and they need `spec-author.md` to stop
asking for the opposite. The line caps are secondary.

**Rules in `config.yaml` will not hold on their own.** They reach one command and are advisory.
The reviewer's checklist is the enforcement, and the lint is the trend line. Without those two,
this is the stock schema's "keep it concise" again.

**Not rewriting is a defensible alternative** — apply the rules to new deltas only and let each
requirement get concise the next time a Story modifies it. It was rejected here because a
MODIFIED block must carry the whole requirement, so the editorial rewrite would then happen
inside a behaviour Story's delta, and G4 would be reading two kinds of change in one diff. Four
dedicated editorial Stories, each a pure prose diff, are easier to read and easier to refuse.

**Do not fork the schema**, for the maintenance reason above, and do not extend the rewrite to
`grill.md` or the ADRs. `grill.md` is the conductor's record of what you said; its length is
your interview's length. ADRs are where the rationale is supposed to go, and phase 2 will add
to them, not cut.

## Open questions this plan leaves to you

1. Which gap between Stories phase 1 lands in, and so which Story is the rehearsal (see phase 1).
2. Whether to add the advisory lint (recommended: yes).
3. Whether phase 2 stops after `record` (recommended: decide after `commitment` lands).
4. Whether phase 3 happens at all (recommended: not until the rules have run for a few Stories
   and the duplicates are still felt).

## Execution checklist, written 2026-09-10

State on the day this was written: PR #187 open and unmerged; no Story open; six Stories archived
since `4e64641` (`add-day-picker`, `add-commitment-editing`, `shorten-day-title`,
`add-adjacent-day-views`, `add-kind-to-commitments-screen`, `rework-commitment-row-actions`),
which added sixteen requirements and rewrote others across `commitment` (+1,651 lines),
`day-screen` (+1,087) and `record` (+161), plus ADR-1046 and amendments to five older ADRs. Every
Feature issue is closed (#6 schedule, #26 commitment, #27 day-screen, #53 record) and so is the
Epic (#1); an editorial Story reopens its Feature and the Epic through the ordinary pipeline. The
next free ADR number is 1047, to be re-verified at the time. The six new change folders run
582–780 lines with no reopening among them: `design.md` 208–310 and `tasks.md` 235–342, which
puts the ordinary folder at roughly twice the phase 1 budgets — a data point for the ADR, not a
reason to move the caps before they have been tried.

Each step ends at something you read. Steps 1–7 are one chore PR; steps 8–11 are one Story each.

1. **Merge PR #187** (you), then `git worktree remove ../daybyday-concise-specs-plan`.
2. **Cut the chore worktree** from `origin/main`: `../daybyday-concise-artifacts`,
   branch `chore/concise-artifacts`, `git branch --unset-upstream`, `pnpm install`.
3. **Re-baseline.** A script lists every requirement block that is new or changed since
   `4e64641` (the sixteen ADDED headings plus every MODIFIED block, found by diffing block by
   block, not by heading). Three survey subagents, one each for `commitment`, `day-screen` and
   `record`, read exactly those blocks with the rubric in § *Before taking this up* and write
   `survey-2026-09-10-<capability>.md` beside the seven reports. Re-measure all five specs and
   refresh the phase 2 table and the totals in this document from the current files.
4. **Write `openspec/config.yaml`** as drafted above. Prove it is read: `openspec new change
   scratch`, then `openspec instructions specs --change scratch --json` must show the `rules`
   and `context` fields populated; delete the scratch folder before committing.
5. **Edit the four documents** — conductor's own work under rule 6: `spec-author.md` (budgets as
   a numbered step; "edit in place" replacing the left-as-it-was practice; an editorial Story
   names no seam and says so), `reviewer.md` (standards axis checks the budgets; fidelity axis
   for an editorial Story is the survey's *Rules at risk* list), `implementer.md` (ticks boxes,
   writes nothing else into `tasks.md`), `docs/process.md` §9 (DoR: within budgets; seam named
   *or* `design.md` states that no test changes and why).
6. **Write ADR-1047** and its README row: the budgets and where each is enforced; the editorial
   Story lane (MODIFIED-only delta, no test change, no seam, rule 3 moot); no schema fork; and
   the two facts from `commitment` lines 1631–1638 and 2255–2260 that a scenario title can be
   false and kept because the archiver forbids dropping it.
7. **Optionally the advisory lint** — decision 2. `scripts/check-artifact-budgets.ts`, wired
   into `pnpm run checks`, exit 0 always, one warning line per overrun. Then `pnpm run checks`,
   `pnpm run verify`, commit as `chore(process): budget the change folder and the spec prose`,
   push, open the PR. **You read and merge it**; then the worktree is removed.
8. **Story 1, `condense-day-screen-spec`.** `orchestrator` writes the Story issue under #27.
   The conductor cuts the worktree and grills from the two survey lists for `day-screen` (the
   rationale with no ADR home; the rules with no scenario) — one question each, in rounds.
   `spec-author` writes the folder: a MODIFIED delta carrying every requirement, the sixteen
   new ones included, every scenario title unchanged; `design.md` with no seam and the reason;
   `tasks.md` with one box per requirement ("its *Rules at risk* sentences are each a
   SHALL/MUST in the rewritten text") plus validate and the archive handover. Draft PR; **G4 is
   you reading `git diff --no-index` of the current spec against the delta.** `implementer`
   works the checklist and ticks; `reviewer` reports on fidelity against the survey; `janitor`
   archives; **G8 is you reading the archive commit**; merge; worktree removed.
9. **Story 2, `condense-commitment-spec`**, the same way, under #26.
10. **Story 3, `condense-record-spec`**, the same way, under #53.
11. **Decide `schedule`** (decision 3); if yes, Story 4 under #6.
12. **Close out**: move the entry in `docs/open-questions.md` to *Settled*, add a paragraph to
    `docs/retrospective.md` on what the budgets did to the first Story written under them, and
    take decision 4 on phase 3 — only after trying REMOVED plus ADDED on a scratch change.

## Outcome, 2026-09-11

Measured after all four editorial Stories merged: `condense-day-screen-spec` (#203, `8c4143d`),
`condense-commitment-spec` (#207, `bc096ac`), `condense-record-spec` (#206, `4158432`),
`condense-schedule-spec` (#209, `94d2341`). Before is `662809f`, the commit § *The re-baseline of
2026-09-10* reports against.

| Spec | Lines | Requirements | Scenarios | Words | Prose words |
|---|---|---|---|---|---|
| `cli-version` | 51 → 51 | 2 → 2 | 4 → 4 | 367 → 367 | 116 → 116 |
| `schedule` | 740 → 640 | 18 → 18 | 78 → 78 | 7,593 → 6,105 | 3,448 → 1,960 |
| `record` | 2,235 → 1,838 | 17 → 19 | 170 → 170 | 27,705 → 21,767 | 9,244 → 3,287 |
| `commitment` | 5,896 → 4,822 | 41 → 42 | 406 → 406 | 72,140 → 57,047 | 26,522 → 11,414 |
| `day-screen` | 5,562 → 4,450 | 48 → 51 | 399 → 399 | 71,412 → 55,008 | 24,847 → 8,374 |
| **Total** | **14,484 → 11,801** | **126 → 132** | **1,057 → 1,057** | **179,217 → 140,294** | **64,177 → 25,151** |

Lines fell 18% and prose 61%, against the plan's estimate of ~69% to ~19,800; the gap was not
attributed by measurement. Six requirements were
added by splitting (`day-screen` three, `commitment` one, `record` two); none merged; no scenario
title changed.

**Requirements still over 150 prose words**: `cli-version` 0, `schedule` 0, `record` 8, `day-screen`
17, `commitment` 31 — 56 total. Each list matches its `design.md` § *Overruns the budget* exactly,
title for title:
`openspec/changes/archive/2026-09-11-condense-record-spec/design.md`,
`openspec/changes/archive/2026-09-10-condense-day-screen-spec/design.md`,
`openspec/changes/archive/2026-09-11-condense-commitment-spec/design.md`. `day-screen`'s design.md
states 8,390 words, not the 8,374 measured here; two commits after it was written (`cd1ae7d`,
`8c70a17`) corrected four sentences at review, after the total was last written down — the
seventeen-title list itself is unaffected.

**Change folders against the budgets** (proposal.md ≤60 lines, design.md ≤150, tasks.md ≤80 + one
line per scenario, requirement prose 40–150 words; no cap on the delta spec file, `grill.md` or
`grill-frontier.md`):

| Folder | proposal | design | tasks (cap) | delta spec | grill.md | grill-frontier.md |
|---|---|---|---|---|---|---|
| `condense-day-screen-spec` | 59 | 150 | 90 (479) | 4,462 | 60 | 93 |
| `condense-commitment-spec` | 59 | **169 (over)** | 125 (486) | 4,823 | 104 | 190 |
| `condense-record-spec` | 57 | 123 | 59 (250) | 1,842 | 90 | 243 |
| `condense-schedule-spec` | 44 | 134 | 58 (158) | 633 | 96 | 310 |

Only `commitment`'s `design.md` is over, by 19 lines; its own § *Overruns the budget* says naming
all fifty-two entries its two lists need costs the overrun and dropping one was judged worse.

**The rehearsal.** Plan decision 1 named the first ordinary Story proposed after PR #200 merged
(2026-09-10T15:30:59Z) as the rehearsal. None exists: every issue opened after #200 is one of the
four condense Stories (#201, #204, #205, #208) or the tracking issue #199, still open;
`openspec/changes/` holds only `archive/`; `git log origin/main --since 2026-09-10T15:00` runs from
`662809f` through the four condense merges and two chore PRs (#202, graph regens) with no other
Story; `gh pr list --state all` shows none open or merged for an ordinary Story since. The budgets
have therefore never been read against an ordinary folder, only against the four editorial ones
above, whose `tasks.md` cap is inflated by scenario count and whose `design.md` carries a section
(*Overruns the budget*) no other Story's template asks for. The comparison is instead the six
pre-budget folders the checklist preamble names — `add-day-picker`, `add-commitment-editing`,
`shorten-day-title`, `add-adjacent-day-views`, `add-kind-to-commitments-screen`,
`rework-commitment-row-actions` — measured the same way: proposal.md 87–134 lines, design.md
209–311, tasks.md 236–343. Every design.md and tasks.md in the set is over the new caps by roughly
double; no proposal.md clears the new 60-line cap either. What this leaves unmeasured is whether an
ordinary Story's `spec-author`, working from `openspec/config.yaml`'s rules rather than only the
editorial checklist, lands inside these budgets on its own — the open question phase 1 called this
rehearsal for.

**Method.** One script (`measure/measure.mjs`, this session's scratch folder) replicates
`scripts/check-artifact-budgets.ts`'s own counting: prose is the text from a `### Requirement:`
heading to its first `#### Scenario:` line, heading and scenario line excluded, split on whitespace.
Two line-counting conventions were compared: counting `\n` bytes (`wc -l` on a file with a trailing
newline) reproduces this plan's 14,484 for `662809f` exactly; `text.split('\n').length` — what the
lint's own `lineCount` helper uses — reproduces the #199 comment's 14,489, one line high per file
from each spec file's trailing newline. Every other 662809f total (126 requirements, 1,057
scenarios, 179,217 words, 64,177 prose words) reproduced exactly under either convention. The spec
table uses the `wc -l` convention; the change-folder table uses the lint's, one line higher per
file, because that is the count a budget is judged by. The script was not kept.
