# Working a Story

The mechanics of a Story from Stage 4 to merge. `AGENTS.md` carries the rules; this file carries
the keystrokes. **Read it before you touch git on a Story.** Why any of it is shaped this way is
in `docs/process.md` §5 and §7, and in ADR-1003.

## One branch, one working tree

**Two agents in one clone share `HEAD`.** A checkout by one moves the other's working tree
underneath it mid-task, and neither is told — it happened on 2026-08-29, and nothing was lost
only because both branches happened to point at the same commit. So every branch is worked in
its own worktree (hard rule 8): a Story, a chore, an archive branch, a throwaway spike. Not "if
someone else is here" — you cannot see the other agent, and `git worktree list` showing one
entry only tells you nobody has *taken* a worktree, which is what you are about to do:

```bash
git fetch origin
git worktree add ../daybyday-<change-id> -b story/<issue#>-<change-id> origin/main
cd ../daybyday-<change-id>
git branch --unset-upstream          # <- same trap as `git checkout -b`; do not skip it
pnpm install                         # a worktree starts with no node_modules
```

A chore is the same four commands with `../daybyday-<slug>` and `chore/<slug>`.

Work there, push and open the PR from there, and remove it once the PR has merged — § *After
the merge* below has that command and its one trap. `pnpm run status` prints the exact command
for every open Story, so you rarely have to assemble one by hand.

A worktree gets its own `HEAD` and index, which is the point. `.git/config` and tracked files are
shared, so `gh` still resolves to `dbugmann-labs/daybyday` and `.claude/`'s `deny` rules load;
anything gitignored does **not** come with you — `node_modules`, `CLAUDE.local.md`,
`.claude/settings.local.json`. Which is why anything another agent must know goes in a tracked
file.

Still one concurrent Story per capability: a worktree removes the collision in the *working
tree*, not two Stories racing for one file in `openspec/specs/`, which is decided at Stage 2
(`docs/process.md` §7).

## Cutting the branch

**At Stage 4**, from `origin/main`, once the Story exists — with `git worktree add -b`, per the
section above. There is no branch-only form: `git checkout -b` in this clone is rule 8's one
prohibition, and the worktree costs a directory.

`git branch --unset-upstream` is not optional. Skipping it leaves the branch tracking
`origin/main`, so a later bare `git push` targets the protected branch and is rejected.

Commit the change folder as `docs(<capability>): propose <change-id>` — it is documentation
until G4 — then `feat(<capability>): ...` for implementation. The archive at Stage 8 is the one
commit that breaks the pattern: `chore(archive): <change-id>`, scoped `archive` because it moves
the change folder rather than changing behaviour. Do not extrapolate `chore(<capability>): ...`
from it.

## The draft PR

**Open it in the same breath**, before asking for G4 — a change folder is far easier to judge as
a diff than as four files someone opens by hand:

```bash
git push -u origin story/<issue#>-<change-id>
gh pr create --draft --base main --title '<change-id>' --body 'Closes #<issue#>'
```

`Closes #<issue#>` is what auto-closes the Story on merge, so it is not optional. Draft is not
decoration either: CI reads it as "this Story is not finished" and skips checks 4, 5 and 8,
which bind again when the janitor runs `gh pr ready` at Stage 8. Keep pushing as you go; the PR
is the Story's one URL from Stage 4 to merge.

**Refresh it before each of the two gates**, G4 and G7:

```bash
git fetch origin && git rebase origin/main
git push --force-with-lease origin story/<issue#>-<change-id>
```

A rebase rather than a merge, so the PR shows the Story's own commits and nothing else — and
because a delta's ADDED / MODIFIED claims are written against the specs as they stand, which
`main` moving underneath can invalidate without touching a file on the branch. A rebase conflict
inside the change folder or `openspec/specs/` is a stop: another Story landed on this capability,
which is the human's decision, not a merge you resolve (rule 5).

## Checks and checkboxes

**`pnpm run checks` is staged**: mid-Story it reports rather than fails, printing
`2/4 covered — next: "<title>"`, because a check demanding every test at once would force the
bulk transcription rule 3 forbids. In CI the same checks bind.

**Gate checkboxes** are ticked by whoever can verify the condition. The one no agent may ever
tick is G4: that is the human's decision, recorded as a comment rather than a checkbox.

## After the merge

### The worktree

**A merged branch's worktree goes with it.** The squash merge closes the Story and deletes the
branch on the remote, so the directory it was worked in is a live checkout of something nobody
will push again — and it still answers `git worktree list`, the one place you can read who is
working where. Left alone they accumulate, and that list stops meaning anything: two trees
survived their merges by 2026-09-03, from Stories #101 and #102.

Run it **from the main clone**, not from inside the tree:

```bash
cd ../daybyday                             # the main clone — a sibling of every worktree
git worktree remove ../daybyday-<change-id>
git branch -D story/<issue#>-<change-id>   # a squash merge leaves the local ref behind, and
                                           # `-d` refuses it: the commits themselves never landed
```

`git worktree remove .` from *inside* the tree also works — and leaves your shell in a directory
that no longer exists, so every command after it fails with `fatal: Unable to read current
working directory` and nothing says why. Leave first; it costs one `cd`.

**A refusal is a stop, not a `--force`.** `fatal: '<path>' contains modified or untracked files,
use --force to delete it` means something on that branch was never committed, and what it was
worth is not the removing agent's call (rule 5). Report it. If a tree was deleted with `rm -rf`
rather than removed, `git worktree list` marks it `prunable` and `git worktree prune` clears the
record.

Two worktrees outlive a merge on purpose. `chore/backlog` is long-lived and reused across
grooming passes (ADR-1010, and `/atlas backlog` reuses it rather than cutting a new one), and any
chore tree whose own PR is still open is still in use — "the Story merged" says nothing about it.

### Closing

Closing cascades one level per pass, and `open` means the same thing at every level: there is
outstanding work under this node. The Story closes with its PR; settling its parents is the
janitor's step, and the rules are in `docs/agents/issue-tracker.md` § *Closing the hierarchy*.

### Labels

Pipeline issues carry no triage label — they are triaged by existing. The five triage labels are
for inbound or unplanned work only. `docs/agents/triage-labels.md`.
