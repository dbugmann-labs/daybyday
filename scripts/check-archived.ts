/**
 * CI check 9 — archived before merge (docs/process.md §7, ADR-1008).
 *
 * A Story merges with its delta folded into `openspec/specs/` and its change folder moved under
 * `openspec/changes/archive/`. That is Stage 8, the janitor's first step, and until this check
 * existed nothing asserted it had happened. Check 8 looks like the one that would: it validates
 * what is *in* the archive directory, so a change that was never archived is simply absent from
 * it and passes vacuously.
 *
 * ADR-1008 recorded that hole deliberately when it removed check 3, and named `pnpm run status`
 * as the projection that would show it. The mitigation failed twice. `add-every-n-days-schedule`
 * merged as d6506cd with its folder unarchived — the archive commit was authored ten minutes
 * later, parented on the merge itself — and `add-screen-navigation` merged as d40a6f0 while its
 * archive commit sat unpushed in a worktree. Both needed a recovery PR. `status` could not have
 * shown the second at all: it reads the change folder off local disk, so a branch archived in the
 * worktree and stale on the remote reports as finished work waiting to merge.
 *
 * This is the narrow half of what check 3 used to catch incidentally. It asks one question about
 * one folder — this Story's own — so it has none of check 3's appetite for blocking correct work,
 * which is what ADR-1008 removed it for. And it runs where the answer matters: CI checks out the
 * PR head, so what it asserts is a property of the commit that will merge rather than of
 * somebody's working tree. That is what lets it catch an unpushed archive without ever reasoning
 * about pushes — "not pushed" is one route to "this head is not archived", skipping Stage 8 is
 * another, and the check does not need to tell them apart to block either.
 *
 * Locally it is informational and cannot be otherwise: run from the worktree it reads the same
 * disk the janitor just archived, so it would have passed on the second failure. The enforcement
 * is the CI step, which the `main` ruleset requires.
 */
import { currentBranch, fail, inCI, locateChange, note, parseBranch, pass, skip } from './lib/ci.ts'

const CHECK = 'archived before merge'
const branch = parseBranch(currentBranch())

if (branch.kind !== 'story') {
  skip(CHECK, `branch "${branch.raw}" is not a story branch`)
  process.exit(0)
}

const loc = locateChange(branch.changeId)

// Checks 4 and 5 both fail hard on a story branch with no change folder at all, and say so
// better than this one could. Deferring keeps a single red check on that case instead of three
// saying the same thing; nothing escapes, because those two block the merge on their own.
if (loc === null) {
  skip(CHECK, `no change folder for "${branch.changeId}" — checks 4 and 5 own that case`)
  process.exit(0)
}

if (loc.archived) {
  pass(CHECK, `${loc.dir}`)
  process.exit(0)
}

// Mid-Story this is the correct state — the archive is Stage 8, and everything before it has the
// folder exactly where this finds it. Failing locally would make `pnpm run checks` red for the
// whole life of a Story, which is the "red build nobody reads" ADR-1003 rejected. Check 4 is
// staged the same way and for the same reason.
if (!inCI) {
  note(CHECK, `"${branch.changeId}" is not archived yet — expected until Stage 8`)
  process.exit(0)
}

fail(CHECK, [
  `This PR is out of draft, so it asserts the Story is finished — but its head still carries`,
  `${loc.dir}, and openspec/specs/ has not been updated from the delta.`,
  '',
  'If the archive has not run yet:',
  '  /opsx:archive on the story branch — the janitor\'s step 1, and the last commit on the branch',
  '',
  'If it ran in your worktree:',
  `  git push origin ${branch.raw} — the commit is local, and this head is behind it`,
  '',
  'Do not merge past this. A Story merged unarchived leaves openspec/specs/ stale and needs a',
  'recovery PR: it happened on add-every-n-days-schedule (#25, recovered by #32) and again on',
  'add-screen-navigation (#116, recovered by #118).',
])
