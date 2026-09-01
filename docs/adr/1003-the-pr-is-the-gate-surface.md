# 1003. The pull request opens at Stage 4 as a draft, and both human gates are read through it

- Status: accepted
- Date: 2026-08-30
- Deciders: Diego Bugmann

## Context

Until now the process said nothing about when a pull request comes into existence. The stage
table mentioned one only at Stage 8 — "PR marked ready" — with no earlier stage creating it, so
in practice it appeared at the end, once everything was already built.

That left the two human gates without a surface. G4 was presented as a list of file paths to
open by hand: `proposal.md`, then `specs/<capability>/spec.md`, then `design.md`. G7 was
presented as a reviewer's report against a working tree only the agent could see. Both are the
same reviewing problem GitHub already solves, and neither showed CI's verdict next to the thing
being judged.

The second half of the problem is `main` moving. A delta's ADDED / MODIFIED / REMOVED claims
are written against `openspec/specs/` *as it stands*, and another Story archiving into a
capability changes that ground without touching a file on this branch. A gate answered on a
stale base is a decision about a merge that will not happen.

## Decision

**One pull request per Story, opened as a draft at Stage 4 and open until the merge.**
`spec-author` pushes the branch and opens it immediately after committing the change folder;
the implementer pushes into it; the janitor takes it out of draft with `gh pr ready` after the
archive commit. Its body carries `Closes #<issue#>`, which is what auto-closes the Story.

**Both gates are read through it, and it is rebased onto `origin/main` before each.**
`git fetch origin && git rebase origin/main`, then `git push --force-with-lease` — a rebase
rather than a merge, so the PR shows the Story's own commits on top of current `main` and
nothing else. A conflict landing inside the change folder or `openspec/specs/` is a stop, not a
merge to resolve: it is §7's spec collision arriving late, and it belongs to the human.

**Draft state is the signal that the Story is unfinished.** Three of the seven merge-time
checks — 4 scenario coverage, 5 G4 recorded, 8 archive complete — ask whether the Story is
*finished*, and are skipped while the PR is a draft. Checks 1, 2, 6 and 7 run from the first
push. The workflow subscribes to `ready_for_review` so the full list actually runs
when the draft is lifted; it is not one of GitHub's default `pull_request` event types.

`pnpm run status` gained the PR as a fact — whether it exists, whether it is a draft, how many
commits `main` has moved past it — and refuses to hand a gate to the human until the diff is
there and current.

## Consequences

- **The gate presentation changes; the gate does not.** Approval is still a human's comment on
  the Story issue, still the exact line `G4: approved`, still CI check 5 (ADR-0014). The PR is
  where the thing being approved is read; the issue is still where the decision is recorded,
  because that is what check 5 reads and what survives a merged, deleted branch.
- **Checks 3, 4, 5 and 8 no longer run continuously on an in-flight Story.** This is smaller
  than it sounds: a draft cannot be merged, so nothing they guard can land while they are
  skipped, and the alternative was a PR that is red by construction from the day it opens —
  which is a red build nobody reads. The cost is that a Story finds out about a coverage or
  containment failure when the draft is lifted rather than on every push. `pnpm run checks`
  runs the same list locally and is the earlier warning.
- **Story branches are force-pushed.** `--force-with-lease` and one agent per working tree
  (`docs/story-mechanics.md`) are what make that safe. A second agent pushing to the
  same story branch from another clone would lose commits; the rule against that predates this
  decision and now has a second reason behind it.
- **The rebase can fail, and that is a feature.** A conflict is the earliest honest signal that
  two Stories raced for one capability. Before this, the same collision surfaced at merge time,
  which §7 names as the failure mode to avoid.
- Rejected: opening the PR non-draft at Stage 4. It would fail three checks on day one and
  invite the habit of merging past a red X. Also rejected: opening it only at G7, keeping G4 on
  file paths. That leaves the hardest gate — the one the whole requirement set rests on — with
  the worst reading surface of the two.

## Corrections

- **2026-08-30** — the worktree rule was cited as `AGENTS.md` § *Working in parallel*; it now
  lives in `docs/story-mechanics.md`. The rule is unchanged, only its address.
- **2026-09-01** — the counts read "four of the eight merge-time checks", listing check 3 among
  the three skipped on a draft, and "fail four checks on day one". ADR-1008 dropped check 3 on
  2026-08-31 and the rest kept their numbers, so it is three of seven: 4, 5 and 8. Not a change
  of mind — which checks ask whether the Story is finished, and the decision that a draft
  asserts it is not, are both unchanged.
