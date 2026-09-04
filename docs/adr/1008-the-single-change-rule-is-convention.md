# 1008. CI check 3 is dropped; one change per PR is convention, not a build failure

- Status: accepted
- Date: 2026-08-31
- Deciders: Diego Bugmann
- Amended: 2026-09-04 — the hole this left is closed by CI check 9, after it cost two recovery PRs

## Context

CI check 3, the **single-change rule**, read the PR's own diff and asserted two things about a
`story/` branch: that it added exactly one directory under `openspec/changes/archive/`, and that
it left no active change folder behind. On a `chore/` branch it asserted the diff touched at most
one change folder. It is why the branch name embeds the change id, and it was the mechanical half
of `AGENTS.md`'s *One Story = one change = one branch = one PR*.

**What it defended is a collision that cannot occur at one concurrent Story.** Two changes riding
one branch, or two Stories entangling through a shared `openspec/specs/` file, need a second
Story in flight to happen at all. `docs/process.md` §7 fixes the concurrency at one and names the
trigger for revisiting it. This is the same arithmetic ADR-0004 already ran when it rejected the
second archive PR: a defence priced for a three-Story future, paid for in the one-Story present.

`docs/retrospective.md` §3 scored the checks after the first end-to-end Story and put check 3 at
*"Keep, provisionally. Cheapest to drop"* — none of the five had ever blocked a bad merge, and
checks 2 and 3 were classed together as insurance. §6 then narrowed §12's fourth cut to
**"Drop check 3 only. Check 4 paces the red-green loop; check 3 defends a collision that cannot
occur yet."** That conclusion was recorded on 2026-08-30 and never acted on.

**What forced it is that check 3 has now blocked a correct PR.** Story #9's capability spec lost
a scenario when `/opsx:archive` wrote `openspec/specs/schedule/spec.md` — 31 expected, 30
written. The repair replays the archive and restores the missing scenario, so its diff contains
no new `openspec/changes/archive/<date>-<id>/` directory: the archive itself landed in PR #18.
Check 3 reads the PR's own diff for that directory and fails on its absence. The branch prefixes
do not offer a way out, and the enumeration is exhaustive:

- On `story/…`, check 3 fails — nothing is archived in this diff.
- On `chore/…`, check 2 fails — a chore branch must touch `openspec/specs/` not at all.
- On any other prefix, `parseBranch` returns `other` and checks 2, 3, 4, 5 and 6 **all** skip.

So the repair can land only on a branch name that silences the check that makes the source of
truth safe. **There is no branch name on which a correct spec repair lands under honest
scrutiny while check 3 exists.** A guardrail whose only recorded effect in two Stories is to
block correct work, and whose evasion costs check 2, has stopped being insurance.

## Decision

**CI check 3 is removed.** `scripts/check-single-change.ts` is deleted, the `check:change`
package script and its place in the `checks` chain go with it, and the `3 · single-change rule`
step leaves the `verify` job.

**One change per PR survives as convention, caught at review.** It remains true in `AGENTS.md`,
in the branch naming, and in what a reviewer is looking at. What is gone is the assertion that a
build can prove it.

**The numbers keep the gap. There is no check 3.** Checks 4–8 keep the numbers they had. This is
the rule `AGENTS.md` § *The pipeline* already states for stages and gates — there is no Stage 3,
no G3, G5 or G6 — applied to the same register for the same reason: the numbers are read. They
are the step names in `.github/workflows/ci.yml`, the rows of `docs/process.md` §7, the scoring
table in `docs/retrospective.md` §3, and the draft-skip set written into four documents. A
renumbered check 4 would leave every one of those references pointing silently at a different
check.

**G4 and check 2 are not touched.** `docs/process.md` §7 and `docs/retrospective.md` §6 both say
those two are never cut, and nothing here argues against it. Check 2 is the one that protects the
source of truth, and this decision leaves it doing strictly more of the work.

## Consequences

- **Nothing mechanically enforces one change per PR.** Two changes riding one branch now reach
  the human. This is the class of rule ADR-0013 describes: path-scoped permissions cannot be set
  per agent, so the fine-grained conventions are caught at review and the table must not be read
  as a guarantee. Check 3 was one of the few that had escaped that class; it rejoins it.
- **An active change folder could then merge to `main` — and twice it did.** Check 3 was what
  failed a PR whose Story was never archived. Check 8, `openspec validate --archived`, still binds
  at Stage 8 and still requires every `tasks.md` box in a *newly archived* change to be ticked —
  but it says nothing about a change that was never archived at all. This ADR accepted that,
  naming `pnpm run status` as the projection that would show it. **That mitigation was not
  sufficient, and check 9 now closes the hole** — see *Amendment* below.
- **The draft-skip set changed with check 3's removal.** ADR-1003 stands as written: it decided
  that the PR opens as a draft at Stage 4 and that the checks asserting a *finished* Story wait
  for `gh pr ready`. That decision is unchanged; only which checks are in the set has moved, and
  `docs/process.md` §7 is the file that keeps the list.
- **ADR-1007's rejection of the spec-PR-first shape stands, one argument lighter.** It listed
  four costs, one of which was an active change folder sitting on `main` between two PRs that
  check 3 would read as a second Story. That cost is gone; the other three — a second branch kind
  through `parseBranch`, `status.ts` and the graph, a red-by-construction build, and two rebases
  per Story — are not, and they were sufficient on their own.
- **`pnpm run checks` is one check shorter and no longer staged in two places.** Check 4 is the
  only staged check left: it reports locally and binds in CI. The paragraph in `docs/process.md`
  §7 explaining staging now describes one check rather than two, which is one fewer thing for the
  next reader to hold.
- **The switch-back is cheap and the trigger already exists.** If a second concurrent Story is
  ever started, `docs/process.md` §7's switch-back trigger fires at Stage 2 — serialise, or move
  the pair to separate `archive/<change-id>` PRs. Restoring check 3 from git history is an hour's
  work and would be the right response to that trigger. Deleting it now costs nothing that cannot
  be bought back at the moment the concurrency it assumes actually arrives.
- Rejected: **renumbering checks 4–8 down to 3–7.** It reads tidier and falsifies the CI step
  names, `docs/retrospective.md` §3's per-check verdicts, and every "checks 4, 5 and 8" sentence
  in the process docs. ADR-1005 rejected exactly this for the stage numbers, and the register is
  more valuable frozen than tidy.
- Rejected: **keeping check 3 and adding an escape hatch** — a `repair/` branch prefix, or a
  commit-message opt-out. That is a new branch kind through `parseBranch`, `status.ts` and the
  graph, plus a documented way to turn a check off, to preserve a check that has never fired in
  anger. The hatch would be more machinery than the guardrail.
- Rejected: **demoting check 3 to a warning.** A check that cannot fail is a comment with a CI
  bill attached. If the rule is convention, the honest form is prose in `AGENTS.md`, which is
  where it already is.

## Amendment — 2026-09-04: check 9 closes what this left open

The consequence above was accepted on the strength of one compensating control, `pnpm run status`.
It was not enough, and the cost was two recovery PRs.

**`add-every-n-days-schedule`** merged as `d6506cd` on 2026-08-31 — the same day this ADR was
accepted — with its change folder unarchived. `gh pr ready` fired two seconds after the G7 tick
was pushed and the merge followed sixty seconds later; the archive commit `9a378333` was authored
ten minutes *after* the merge, parented on the merge itself, and PR #32 recovered it.
**`add-screen-navigation`** merged as `d40a6f0` on 2026-09-04 the other way: the archive had run,
and its three close-out commits sat in the worktree and were never pushed, so `gh pr ready` bound
CI to a head three commits behind them. PR #118 recovered it.

The two have different proximate causes — Stage 8 skipped, and Stage 8 unpushed — and one enabling
cause: `verify` went green on an unarchived head both times, and green is what the `main` ruleset
accepts. `pnpm run status` could not have closed the second at all. It reads the change folder off
local disk, so a branch archived in the worktree and stale on the remote reported as finished work
waiting to merge, which is exactly what it was not.

**CI check 9 asserts that a non-draft story branch's own change folder is archived.** It is the
narrow half of what check 3 caught incidentally, and it does not bring back what this ADR removed
check 3 for. Check 3 asked a question about *the whole diff* — one archived directory added, no
active folder left anywhere — which is what let a second change riding the branch fail it, and
what made evading it cost check 2. Check 9 asks one question about one folder, this Story's own,
and has no opinion about anything else on the branch. The switch-back trigger in `docs/process.md`
§7 is untouched: if a second concurrent Story is ever started, restoring check 3 is still the
response, and check 9 neither helps nor hinders that.

What makes it work where `status` did not is *where it runs*. CI checks out the PR head, so the
property asserted is a property of the commit that will merge rather than of somebody's working
tree — which is why it catches an unpushed archive without reasoning about pushes at all. Verified
against both failures: run against `8062ac3f` and `fb2634a`, the heads that actually merged, it
exits 1; run against `9a378333`, a correctly archived story head, it passes.

Two things go with it, neither of them a guardrail: the janitor's archive push is now a numbered
step carrying its command rather than a clause inside another step's rationale, and
`pnpm run status` compares the branch against the PR head so Stage 9 can no longer call a Story finished on
the strength of local disk alone.

**What is still open.** A story PR merged while it is *still a draft* skips 4, 5, 8 and 9 alike.
This ADR's original reasoning — "a draft cannot be merged, so nothing they guard can land while
they are skipped" — is GitHub's UI behaviour, not a rule the `main` ruleset enforces. Neither
failure took that route, and closing it would mean a check that runs on drafts to assert the PR is
not one, which is not obviously worth its own red X.
