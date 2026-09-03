# 1024. The issue graph refreshes itself, and pushes to main over a deploy key

- Status: accepted
- Date: 2026-09-03
- Deciders: Diego Bugmann

## Context

`docs/graph.mmd` is a read-only projection of the Epic → Feature → Story hierarchy held in
GitHub Issues (ADR-0002, ADR-0012). Nothing reads it back. It exists so a human can see the
shape of the tracker without clicking through it.

Keeping it current cost a **second pull request per Story**. `janitor` step 6 regenerated it
after the merge — and by then the Story branch was gone, so the commit needed a branch of its
own, which under hard rule 8 needed a worktree of its own. Twelve of the first 102 commits on
`main` were `chore: regenerate the issue graph`, each one a branch, a worktree, a PR, a CI run
and a merge, for a generated file nobody reads.

The obvious fix — fold the regeneration into the Story's own PR — does not work, and it is
worth writing down why, because it is the first thing anyone will propose. The graph is a
projection of issue **state**, and the Story issue does not close until its PR merges. A graph
committed on the Story branch would show that Story open. Making it correct would mean teaching
the generator to *predict* the merge: mark the Story closed, then cascade closure to any parent
whose children are then all closed, mirroring what `janitor` step 5 does afterwards. That is
real logic, with a real divergence — a Feature deliberately held open because more Stories are
queued but not yet cut, which no generator can know — and it buys a file that is stale again the
moment anyone opens an issue.

The trigger was never the merge. It is the issue event.

## Decision

**`.github/workflows/graph.yml` regenerates `docs/graph.mmd` on every `issues` activity and
pushes it straight to `main`.** No Story branch carries it, no chore PR exists for it, and
`janitor` has no step 6.

Firing on issue activity rather than on merge is what makes it correct without predicting
anything. Squashing a Story PR closes the Story; `janitor` then closes its Feature and its
Epic. Those are three separate events, and the file converges across them. `concurrency` with
`cancel-in-progress` collapses the burst into one run that sees the final state.

The trigger carries **no `types:` filter**. Sub-issue edge changes are the one input to this
graph whose activity type is not documented, and an unfiltered trigger cannot miss one that
gets added later. Most runs therefore change nothing and exit without committing. A daily
`schedule` is the net under all of it.

**The push goes over a repository deploy key, not `GITHUB_TOKEN`.** The `main` ruleset requires
a pull request, so a bypass actor is needed either way. GitHub Actions cannot be one here: the
API rejects it with *"Actor GitHub Actions integration must be part of the ruleset source or
owner organization"*, and `dbugmann-labs` has no app installations. So `GITHUB_TOKEN` cannot
push to `main` however it is permissioned, and the choice was between a personal access token
and a deploy key.

The deploy key wins on every axis that matters here. It reaches exactly one repository, it
never expires, and it required no human to mint it. Most importantly it is **narrower than the
Actions-app bypass would have been**: `GITHUB_TOKEN` still cannot write to `main`, so the
capability belongs to the one workflow holding the key rather than to every workflow that ever
lands in `.github/`.

Enabling it took an organisation-level flip, `deploy_keys_enabled_for_repositories`, which was
`false`.

## Consequences

**`main` is no longer only reachable through a reviewed pull request.** This is the real cost
and it is accepted deliberately. The repository has one contributor; the ruleset's job is to
stop unreviewed work landing, and a regenerated projection is not work. The bypass is a single
`DeployKey` entry — `deletion`, `non_fast_forward`, `required_linear_history`, `pull_request`
and `required_status_checks` are all untouched for every other actor.

**A deploy-key push triggers workflows**, unlike a `GITHUB_TOKEN` push. Without care every
closed issue would buy a full CI run, macOS Swift job included, to verify a generated file. So
`ci.yml` carries `paths-ignore: ['docs/graph.mmd']` on its `push` trigger. Note what that does
*not* weaken: `paths-ignore` skips a run only when every changed file matches, and no other
branch may touch that file, so nothing else can ride in behind it.

**The generator now refuses to write an empty graph.** Issue types are an organisation-level
feature, so a token able to list issues cannot necessarily read the field this graph is built
out of. Without them every node is filtered out and the old code would cheerfully overwrite a
full tracker with *"No Epic, Feature or Story issues yet"*. Issues present and not one of them
typed is the signature of that, and it is now a thrown error — hard rule 5, and the thing most
likely to break if the token's scope ever narrows.

**The 100-issue ceiling now fails in public.** The generator has never paginated; it throws
rather than truncating. That used to surface to whoever ran `pnpm run graph`. It is now a red
workflow run, which is strictly better, and the repository is at 23 issues.

**`pnpm run graph` still works** and is still the way to check the generator's output while
changing it. It is simply no longer part of anyone's process.

## Alternatives considered

- **Fold it into the Story PR.** Rejected above: needs merge prediction, and diverges from
  reality exactly where a human judgement lives.
- **Have the Action open the chore PR.** Removes the keystrokes and none of the noise. Every
  commit, PR and CI run survives; the thing being objected to is untouched.
- **Take the graph off `main` entirely** — an orphan `graph` branch, or the run's job summary.
  Needs no bypass and no key, since the ruleset covers only the default branch, and would make
  *"a projection, never an input"* structurally true rather than a comment at the top of a
  file. Rejected because the file is worth having in the tree you already have open; this was
  the one decision here that went on taste rather than on evidence.
- **A fine-grained personal access token in a secret.** Works, needs no organisation flip, but
  it is a credential that acts as a person, reaches whatever else it is scoped to, and expires
  one day without telling anybody.
