# Retrospective — building the system, and running it once

**Scope:** everything from the empty repository to the first Story merged end to end.
`docs/process.md` §12 asked for exactly this: *"Phase 4 revisits this list against what
actually happened during the dry run."* This is that revisit.

Written at commit `72a05e1`, three days after `e5fcc2e`.

---

## 1. What exists

| | |
|---|---|
| Hand-written prose (rules, ADRs, agent definitions, process) | ~1,750 lines |
| Code and config (checks, CI, issue templates, generator) | ~1,060 lines |
| Product code | **48 lines** |
| ADRs | 14 |
| Commits on `main` | 16 |
| Merge-time checks | 6 (1 generic, 5 bespoke) |

The ratio of scaffolding to product is roughly 60:1. That is the correct number for a project
whose product is deliberately undefined, and it is also the number to watch: if it is still
above 5:1 after ten real Stories, the apparatus is not amortising and §12's cut list applies.

## 2. What the first Story cost

`add-version-command` — four scenarios, 48 lines of implementation — went through all nine
stages. It produced **three pull requests**: the Story itself (#9), a CI fix that the Story
uncovered (#8), and a documentation fix the Story uncovered (#10). Review raised eight
findings: five fixed, one dropped, one resolved by amending a task, one deferred to issue #7.

That is the honest cost picture, and it is not representative — a rehearsal Story pays for
every defect in the machinery it is the first to touch. `docs/process.md` §12 already carves
out the exception it relied on: *a Story whose purpose is to exercise the pipeline itself*.
The rule it protects — **no Story smaller than roughly two hours goes through the full
pipeline** — survives this run intact and matters more now than when it was written.

## 3. Did the checks earn their keep?

The question §12 posed. One verdict each, on evidence rather than intent.

| Check | Fired in anger? | Verdict |
|---|---|---|
| 2 — spec-diff containment | No | **Keep.** Unproven but irreplaceable |
| 3 — one change per branch | No | **Keep, provisionally.** Cheapest to drop |
| 4 — scenario coverage | Not as a failure | **Keep.** It paced the work rather than caught it |
| 5 — G4 approval recorded | No | **Keep.** It converted a convention into a build failure |
| 6 — commit hygiene | No | **Keep.** Cost is one regex file |
| 9 — archived before merge | Added 2026-09-04, *after* the merges it would have blocked | **Keep.** The only one written against evidence |

**None of the five has ever blocked a bad merge.** That is worth stating plainly rather than
dressing up, and it is the least comfortable line in this document. What can be said in their
defence is narrower and specific:

- **Check 4 shaped the work.** Reporting `1/4 covered — next: "<title>"` gave the implementer
  the next scenario by name and nothing else. Four red-green cycles happened in delta order
  without anyone policing it. A check that changes behaviour without ever failing is doing its
  job; it is simply invisible when it works.
- **Check 5 changed what G4 *is*.** Before it, G4 was a sentence in a document. After it, a
  Story that reaches a PR without a recorded human decision goes red. `ADR-0014` is explicit
  that this cannot prove a human made the decision — agents act through the owner's token, and
  nothing closes that. It proves the decision was *recorded*, which converts a silent omission
  into a loud one. That is the whole of what was available.
- **Checks 2 and 3 are insurance.** They defend against a spec edit smuggled past the delta,
  and against two changes riding one branch. Neither has happened at one concurrent Story, and
  neither *can* happen much at one concurrent Story. They are priced for the three-Story
  future, not this one.
- **Check 9 is the exception to this whole section, and was added after it was written.** The
  five above were designed against imagined failures and none has fired. Check 9 was written on
  2026-09-04 against two that had already happened — `add-every-n-days-schedule` merged
  unarchived as `d6506cd`, `add-screen-navigation` as `d40a6f0`, each costing a recovery PR —
  and was verified by running it against `8062ac3f` and `fb2634a`, the heads that actually
  merged, where it exits 1. That is the only check here whose keep is evidenced rather than
  argued, and the reason its verdict is not "provisionally". ADR-1008 § *Amendment*.

**The staging fix was the most valuable change made to them.** As first written, `pnpm run
checks` could not pass before Stage 8, and check 4's failure text instructed the reader to
write every missing test — directly contradicting `AGENTS.md` rule 3. A guardrail whose
failure message tells you to break a hard rule is worse than no guardrail. They are now
informational locally and binding in CI.

## 4. The sharpest finding: the checks were validated against themselves

All three original checks resolve a change folder by name. All three assumed the archived form
is `openspec/changes/archive/<change-id>/`. The archive step actually writes
`archive/YYYY-MM-DD-<change-id>/` — a form `docs/process.md` §5 **already documented
correctly** when the checks were written.

So all three failed simultaneously, at the last commit before the first real PR: the Story
finished, reviewed, branch ready. The worst possible place to find it.

Each check had been tested in both directions before it shipped. The tests passed. They passed
because the fixture encoded the same wrong assumption as the code — same author, same sitting,
same misreading of a document that was sitting there being right.

**The lesson is not "test more."** It is that a check must be exercised against output produced
by the real tool at least once, and that a fixture written alongside the code it tests proves
only internal consistency. `tests/ci-lib.test.ts` now pins the date-prefix rule directly, with
a comment saying why that is the worst place to discover it.

## 5. What the dry run caught that design review did not

Phase 3 put a cold agent through stages 0–4 and asked it to **audit the documentation rather
than follow it**. Fifteen defects. The four that mattered were all of one kind: *the documents
were internally coherent and did not survive contact with the tools they described.*

- `gh issue create` has no `--type` flag, so every documented path to creating a conforming
  issue produced a typeless one.
- Nothing anywhere said how to attach a sub-issue — it needs an API call keyed on the child's
  database `id`, not its issue number.
- G4's marker was the bare word "approved", which occurs in ordinary prose. Any agent writing
  *"waiting on the approved comment"* forged the gate for a grep-based reader.
- `docs/graph.mmd` was documented four times as generated from `gh issue list --json`, which
  carries neither the issue type nor the sub-issue edge. It could never have worked. This one
  survived until Phase 4, because nothing tried to build the generator until then.

A cold agent instructed to be adversarial found in one session what four rounds of writing and
re-reading did not. **That is the technique worth keeping**, and it is cheap: the instruction
is "report every defect, do not work around any of them."

## 6. §12's cut list, revisited

§12 proposed cutting in this order if the process hurt. Against evidence:

| Proposed cut | Now |
|---|---|
| 1. Fold Stage 3 into Stage 4 | **Still first.** Grilling never justified its own session at one Story |
| 2. Fold Stage 7 into Stage 8 | **Demote.** Review produced 8 findings on 48 lines; it is the highest-yield stage measured |
| 3. Drop the Epic level | **Promote to second.** One Epic, one Feature, one Story — the Epic carried nothing a Feature did not |
| 4. Drop checks 3 and 4 | **Drop check 3 only.** Check 4 paces the red-green loop; check 3 defends a collision that cannot occur yet |

**2026-08-30 — cut 1 was taken.** Grilling is now a step inside Stage 4 and there is no
Stage 3. The row above is what was concluded on the day and stands as written; what changed
since is that the fold had already happened in practice, one Story later, without anyone
deciding it. `docs/adr/1005-the-grill-is-a-step-inside-propose.md` records the decision.

**2026-08-31 — cut 4 was taken, in the narrowed form.** Check 3 is gone; check 4 stays, exactly
as the row concluded. The row above stands as written; what changed since is that the collision
check 3 defends still had not occurred, and check 3 had meanwhile blocked a *correct* PR. Story
#9's archive wrote 30 of 31 scenarios into `openspec/specs/schedule/spec.md`; the repair replays
the archive, so its diff carries no new `openspec/changes/archive/<date>-<id>/` directory — the
archive landed in PR #18 — and check 3 reads the PR's own diff for exactly that. On a `chore/`
branch check 2 fails instead, and on any other prefix `parseBranch` returns `other` and checks 2,
3, 4, 5 and 6 all skip. There was no branch name on which that repair could land under honest
scrutiny. A guardrail whose only recorded effect is to block correct work is the case §3 said it
would take. One change per PR is now convention caught at review.
`docs/adr/1008-the-single-change-rule-is-convention.md` records the decision.

Unchanged: **G4 and check 2 are never cut.** Nothing in this run argued against that.

The one addition the run suggests: **the human's real cost is not the gates, it is the
machinery defects the gates surface.** §12 priced G2/G4/G7 at 45–90 minutes per Story. That
held. What it did not price was PRs #8 and #10 — work created by the Story rather than
contained in it. That cost decays as the machinery settles, but it is not zero on Story two.

## 7. Known weak points

The first four and the resolved fifth are from this document's stated scope. The last two were
found running Story #11 on 2026-09-02, after it, and are recorded here rather than in a second
document because they are the same kind of thing: a rule the process states and nothing checks.

- **Per-agent write permissions are largely convention.** Path-scoped permissions cannot be
  set per agent, and subagent frontmatter hooks are silently skipped unless the folder is
  explicitly trusted. Three layers enforce what can be enforced; `AGENTS.md` and `ADR-0013`
  state exactly which matrix rows are mechanical and which are not. Do not read the table as
  a guarantee.
- **Project settings load from the session's startup folder.** A session started one directory
  above the repo gets no deny rules, no agents and no skills, and says nothing about it. This
  is the single easiest way to run the whole process unprotected.
- **An agent that holds `Bash` can write any file**, whatever its `disallowedTools` say.
  `orchestrator`, `reviewer` and `janitor` all need `Bash`.
- **The graph generator does not paginate** past 100 issues. It throws rather than truncating.
- **An ADR number is claimed at Stage 4 and merged at Stage 9**, so any branch open across
  another ADR's merge collides with it. Found twice in one day on Story #11, 2026-09-02: its
  ADR was written as 1010, renumbered to 1014 when the backlog ADR landed under it, and
  renumbered again to 1015 when `the-question-comes-first` took 1014 during review. The second
  move touched the signed change folder — the ADR is cross-referenced from `proposal.md`,
  `design.md` and `tasks.md` — so it cost a second G4 signature for a filename. Nothing checks
  for the collision; `git rebase` finds it, in `docs/adr/README.md`, at the worst moment. What
  to do about it is an open technical decision rather than a fix, and it is recorded as one in
  `docs/open-questions.md`.
- **A written instruction failed three times in the place it was written.**
  `.claude/agents/reviewer.md` tells the reviewer that the missing `Agent` tool is a deliberate
  decision — a sub-agent would not inherit its `disallowedTools` and could edit the working
  tree — and to run the two `code-review` axes inline instead. That paragraph exists *because*
  the reviewer reported it twice on Story #42; it reported it a third time on Story #11,
  2026-09-02, from a session that had read the file. Rewritten on 2026-09-02 to say "do not
  report this" as its own instruction rather than as a clause at the end of the rationale. The
  general point is the one worth keeping: an instruction placed after the reasoning that
  justifies it is read as commentary, and prose the agent must *act* on has to be shaped as an
  action.
- **Rule 3 is unenforced, and a batched Story is indistinguishable from a disciplined one after
  the fact.** Found at Story #11's review, 2026-09-02 (PR #45): nine of ten scenarios were
  written in two commits — five tests and five ticked boxes in one, four tests and the guard
  that satisfies them in another — and nine `tasks.md` boxes were ticked as though each had
  been its own red-green cycle. `pnpm run checks` passed throughout, because CI check 4 counts
  scenario coverage and never asks in what order coverage arrived. The behaviour was correct
  and the owner deliberately let it stand; what was lost is the evidence, since `tasks.md` had
  asked for a report if any predicted-green scenario ran red, and after batching no such
  observation could have been made. A squash merge then removed the only trace: the commit
  shapes the finding rests on are not reachable from `main`. This is the first Story where
  scenario count made the shortcut worth taking, and there will be more.
- **~~ADRs had no way to correct a false statement.~~ Resolved 2026-08-24.** The rule
  forbade editing an accepted ADR except to add a `Superseded by` line, so `ADR-0002`'s two
  wrong command names had no route out. `docs/adr/README.md` was changed to separate the
  decision, its rationale and its alternatives — still immutable at that point — from incidental
  detail, which was corrected in place and logged in a dated `## Corrections` section. An audit
  of the other thirteen ADRs found no further stale detail. *(The immutable half went too, on
  2026-09-03: an accepted ADR is now edited in place and stamped, and git history is the audit
  trail. ADR-1020.)*

## 8. Open

- **Issue #7** — manifest read failures escape `runCli` as exceptions instead of a `CliResult`.
  The one review finding deferred rather than fixed.
- **Whether any of this holds at three concurrent Stories.** Every judgement above is drawn
  from a sample of one, run by its own author. That is the largest caveat on this document.

## 9. Condensing the specs, 2026-09-10 to 2026-09-11

Issue #199: chore PR #200 (budgets, `openspec/config.yaml`, ADR-1047, `check:budgets`), then four
editorial Stories — `condense-day-screen-spec` (#201, PR #203), `condense-commitment-spec` (#204,
PR #207), `condense-record-spec` (#205, PR #206), `condense-schedule-spec` (#208, PR #209). The plan
is `docs/research/2026-09-09-concise-specs.md`. Written at `2a98cf6`. A bare time is UTC and names a
#199 comment; times before 21:00 are 2026-09-10, times after 05:00 are 2026-09-11.

**The re-baseline caught two defects before any Story ran.** Step 3 surveyed the 37 requirement
blocks changed between `4e64641` and `662809f`. `day-screen`'s *A day screen reads its roster again
when it is returned to* had been reversed by #148 while the old sentence's shape survived; the
earlier survey's note recorded the retired rule, so a rewrite working from it would have kept a rule
that no longer held (plan § *The re-baseline of 2026-09-10*; box 2.24 of #201's `tasks.md`). Step 4
found that the `openspec/config.yaml` block drafted in the plan did not parse — a bare `word: word`
in a plain list item is a YAML mapping — and `openspec` 1.10.0 printed *could not parse … ignoring
it*, exited 0, and delivered no context and no rules to any artifact. Rewritten as folded scalars,
wording unchanged, `openspec instructions` returned 3 / 5 / 5 / 5 rules for proposal / specs /
design / tasks (15:13:35Z).

**Every delta was written by parallel rewrite agents over requirement ranges, assembled by script,
then verified.** On all four Stories the script found every scenario byte-identical and present
once, and `openspec validate --strict` exited 0. Every defect below was found with both green.

On `day-screen` the first G4 was signed at 17:16:47Z. Verification ran after it and failed four
boxes, repaired in `cd1ae7d` and named in `fa453a7`'s message. Box 2.17's requirement had lost the
one-clause deferral to *A day view is a value*'s group rule that the box said to keep; restoring it
took the requirement to 166 words and `design.md`'s overrun list from sixteen to seventeen. Boxes
2.27 and 2.31 said a number, and a note, entered on a day already holding one "replaces it", a bare
declarative; both became "SHALL replace it". Box 2.47's requirement stated the move-versus-draw pair
a second time instead of cross-referencing box 2.11's requirement. That cost the second G4
(17:42:48Z). G7 then found six defects the three verification agents had cleared, four fixed in
`8c70a17`: the significant-digit count had lost its second bound, so the spec refused a number the
code keeps; the total entry deferred to "the eight answers" of a requirement enumerating no eight;
`proposal.md` § *Impact* named one file wrongly and omitted three; and one entry requirement
restated a rule its siblings had dropped. That cost the third G4 (18:47:03Z; 18:55:12Z).

`commitment` ran its verifiers before G4: 39 PASS, 3 FAIL over 41 boxes — a sentence whose
grammatical subject the rewrite had changed, the offset's lower bound dropped, and a false reason in
`design.md` for a cut (20:28:13Z). G7 found five more (05:29:42Z). The one rated HIGH was a clause
putting the stopped list in the order commitments were taken on, which a scenario in the same
requirement disproves. It entered through replacement wording the conductor relayed for an earlier
fix; box 2.16 had been ticked on a verifier PASS. At the fix round the agents refused two relayed
instructions after reading the scenarios (05:35:36Z). On `record` the pre-tick verifiers returned
16 PASS / 1 FAIL, a rule carried by a bare declarative, and G7 found four more: two MUST NOT
prohibitions lost, which no WHEN/THEN scenario can assert; a "SHALL carry nothing else" closure
lost; eight requirements unwrapped at 243–695 characters a line; and a request to delete three
sentences as unsourced, which `spec-author` rejected because `AND` lines in current scenarios assert
all three (05:21:05Z, 05:34:11Z). The rewrite agents had swept for "so that", "because" and
"therefore"; the bare declaratives survived that sweep. On `schedule` the verifier passed 18/18
before G4, and G7's 3 should-fix findings sat in ADRs: ADR-1051 said nothing else depended on the
clamp where two requirements do, ADR-1015 and ADR-1028 cited spec text the delta removed, and a
sentence the Story's own ADR called "the spec's rule" had been dropped. No check reads an ADR that
quotes a spec (06:46:56Z).

**What G4 cost the human was not measured.** `docs/process.md` §4 prices the stops at "roughly
45–90 minutes of your own time per Story", the grill "15–30 minutes" of it, G4 and G7 "answered in
a word". The record holds diff sizes, signatures and timestamps, not reading time, and this section
does not estimate it.

| Story | G4 read, lines added / removed | `G4: approved` comments | first at G4 → first approval |
|---|---|---|---|
| `day-screen` #201 | 914 / 2,015 | 3 | 16:04:28Z → 17:16:47Z |
| `commitment` #204 | 938 / 2,014 | 2 | 20:07:09Z → 05:05:13Z |
| `record` #205 | 872 / 1,330 | 3 | 19:56:09Z → 20:05:45Z |
| `schedule` #208 | 105 / 211 | 2 | PR opened 05:54:41Z → 05:58:51Z |

The `schedule` row is measured here — `6daa59e`'s delta against the spec at `a88ce0a` — because
#199 records no at-G4 comment for it; `commitment` was first put at 20:07:09Z on 941 / 2,016 and
re-put at 20:28:13Z. Of the ten signatures, the six after each Story's first followed an edit to the
signed folder. `day-screen`'s second and third came 10 minutes after `cd1ae7d` (16 lines added, 15
removed) and 89 seconds after `8c70a17` (21 / 21). `record`'s second (05:05:02Z) and `commitment`'s
first (05:05:13Z) were recorded 11 seconds apart. `openspec/specs/day-screen/spec.md` was 5,562
lines at `662809f` and is 4,450 at `2a98cf6`.

**The rehearsal has not run.** Plan § *Phase 1*: "Whatever Story is proposed first after phase 1
merges is the first one written under the new rules"; #199's body records phase 1 landing "in the
gap before the next Story". PR #200 merged at 2026-09-10T15:30:59Z. On 2026-09-11 `gh issue list
--state all --limit 15` shows four Stories created since, all editorial, and there is no open Story,
`story/*` branch or unarchived change folder. What the editorial Stories showed about the caps:
`commitment`'s `design.md` is 169 lines against 150 by `check:budgets` and says so in the file, its
31 overruns and 21 knowingly-untested rules being 52 entries (05:41:04Z). `day-screen`'s stayed
inside 150 lines while two decisions ran 20 and 19 lines against "at most 12" and § *Open
Questions* 14 against 12, unreported, because `scripts/check-artifact-budgets.ts` counts
`design.md` as one file (18:55:12Z). Requirements over 150 words at merge: 17 on `day-screen`, 31 of
42 on `commitment`, 8 of 19 on `record`, none of 18 on `schedule`.
