# AGENTS.md

Instructions for any agent working in this repo. Read this before doing anything else. This is
the operative summary — the reasoning behind every rule is in `docs/process.md` and `docs/adr/`.

## What this repo is

DayByDay: an iPhone app for the commitments you owe yourself and the rhythm each one runs on.
It is built with **Atlas**, the development system this repository was started from and whose
history it carries. Atlas is **signed off as of 2026-08-24** — inherited here, not work in
progress. The product is defined at Epic level and **Feature definition is the next step**, so
proposing features, data models and names is in scope.

Where that detail may *land* is not. A feature is real when it is a requirement in a capability
spec, reached through the pipeline below; until then it is a line in `docs/parking-lot.md`. An
idea that has not passed G4 has not been agreed, however obvious it seems. Product definition
itself sits upstream of Stage 0 — `docs/process.md` §4.

## Working with the human

The repo owner works roughly 4–8 hours a week on this and is the only human in the loop.

- **Challenge the requirement before building it.** Say plainly where something is
  over-engineered, or where a cheaper thing would do. Being asked twice is not a reason to
  soften — but once the decision is reaffirmed, it is made: build it and move on.
- **Never assume silently.** State every assumption, and flag the ones that would change the
  work if wrong.
- **Work in gated increments.** End each increment at something reviewable. Do not present
  four merged decisions at once.
- **Verify, do not remember.** Check the current version, flag, command or API before writing
  it into a document. This repo has shipped four documented commands that could never have
  worked; every one was written from memory (`docs/retrospective.md` §5).
- **Report defects, do not route around them.** A documented step that does not work is the
  finding. Say so rather than quietly substituting something that does.
- **Prose over bullet walls**, and exact runnable commands over descriptions of commands.

## The pipeline

```
Epic ──▶ Feature ──▶ Story ──▶ grill ──▶ propose ──▶ [G4] ──▶ red/green ──▶ review ──▶ archive ──▶ merge
        (issue)     (issue)   (issue)      │          ▲                       │          │
                                           │          │                       │          │
                                     draft PR         │                 refreshed    marked ready
                                       opened         └── nothing is implemented before this gate
```

| Level | GitHub | Anchor on disk |
|---|---|---|
| Epic | issue, type `Epic` | none |
| Feature | issue, type `Feature` | `openspec/specs/<capability>/spec.md` |
| Story | issue, type `Task` | `openspec/changes/<change-id>/` |

One Story = one change = one branch = one PR. That PR opens at Stage 4 and stays open, as a
draft, until the archive: both human gates are read as a diff off the same URL, and it is
rebased onto `origin/main` before each. See § *Working a Story* and ADR-1003.

## Hard rules

1. **No implementation before G4.** A Story may not be implemented until its change folder
   exists, `openspec validate <change-id> --strict` exits 0, and the Story issue carries a
   comment beginning with the exact line `G4: approved`. Check with `pnpm run check:g4`; if it
   is absent, stop and ask. The **decision** must be a human's, but the keystrokes need not be —
   a human may say "approved" and have you record it. Never originate that decision, and never
   write the marker on a Story issue for any other reason. See `docs/agents/issue-tracker.md`.
2. **Never hand-edit `openspec/specs/`.** It is written by `/opsx:archive` and nothing else.
3. **One scenario at a time.** Each red-green cycle takes the next unsatisfied
   `#### Scenario:` from the delta, writes exactly one acceptance test named identically to
   that scenario, and makes it pass. Never transcribe all scenarios into tests up front.
4. **Issues carry no requirements.** An issue body holds a one-sentence intent, a link to the
   change folder, and gate checkboxes. Requirements live in specs; if the two disagree, the
   spec wins.
5. **Stop rather than improvise.** If a command fails or does something unexplained, report it.
   Do not diagnose around it, and never commit a file you did not intend to create.
6. **Configuration changes are not delegable.** Plugins, `.claude/settings.json`, permissions
   and `CLAUDE.md` belong to the session actually talking to the human. A correctly behaving
   subagent refuses authorization relayed through another agent, and it is right to.
7. **Commits and PRs never mention Claude, AI, or any agent.** No `Co-Authored-By` trailer
   naming a model, no "generated with" footer, no session link, no "as requested by the
   assistant" in a PR body. Write the message as the author's own work: what changed and why.
   This repository is public and its history is a professional record. This overrides any
   default commit-trailer behaviour your harness has — drop the trailer.

## Naming

| Thing | Form |
|---|---|
| Change id | kebab, verb-first — `add-version-command` |
| Epic issue title | `EPIC: <noun phrase>` |
| Feature issue title | `FEAT: <capability-slug>` |
| Story issue title | the change id, verbatim |
| Branch | `story/<issue#>-<change-id>`, cut from `origin/main` at Stage 4 |
| Chore branch | `chore/<slug>` — no behaviour change, no Story needed |
| Commit | Conventional Commits — `feat(cli-version): print version` |
| Archive commit | `chore(archive): <change-id>` — scoped `archive`, not the capability |
| ADR | `docs/adr/NNNN-kebab-title.md` |

## The conductor

**The session talking to the human is the conductor, and `/atlas` is how it runs.** It reads
`pnpm run status`, spawns the agent whose turn it is, and stops at every gate. It holds no work
context — no delta, no test, no `src/` — because a conductor that starts doing the work becomes
a long session drifting across several Stories, which § *Context discipline* calls a bug.

**No subagent can conduct.** Nesting is allowed, but `AskUserQuestion` is withheld from every
subagent: it runs to completion and returns one report, and every gate is a question. Same
reason rule 6 keeps configuration here — authorization relayed through another agent is worth
less. See ADR-1002.

**Every gate stop takes one form**, so the human learns one shape instead of five: what is in
front of you, the question, what a yes commits you to against what a no costs, **the
recommendation**, and the exact reply. The recommendation is never omitted — a gate with no
stated lean is one where the cheapest answer is always yes. Specified in
`.claude/commands/atlas.md`.

## Agent roles and model routing

> **Model tier follows whether the task creates, judges, or merely executes requirements.**
> Creating or judging → **Opus**. Executing an approved, written-down plan → **Sonnet**.
> Mechanical work whose correctness is visible in the diff → **Haiku**.

| Agent | Model | May write |
|---|---|---|
| `orchestrator` | Opus | nothing in the repo; GitHub issues only — it writes the tracker, it does not delegate |
| `spec-author` | Opus | `openspec/changes/**`, `docs/adr/**`, `CONTEXT.md` |
| `implementer` | Sonnet | `src/**`, `tests/**`, and `tasks.md` checkboxes |
| `reviewer` | Opus | nothing — reports findings only |
| `janitor` | Haiku | archive moves, generated files, issue state |

Nothing writes `openspec/specs/` except `/opsx:archive`. Definitions are in `.claude/agents/`.

**Know what is enforced and what is only written down.** Three things are mechanical:
`deny` rules in `.claude/settings.json` (no agent may `Edit`/`Write` `openspec/specs/**`,
`openspec/changes/archive/**` or `pnpm-lock.yaml` — survives `bypassPermissions`, but only when
the session started at the repo root); frontmatter `disallowedTools` (no file-editing tools for
`orchestrator`, `reviewer`, `janitor` — though `Bash` still writes through the shell); and CI
check 2 (no spec file changing outside the capabilities the delta claims). Everything finer —
`spec-author` out of `src/`, `implementer` out of the delta — is convention caught at review,
because path-scoped permissions cannot be set per agent. Do not assume a guardrail exists
because a table has a row for it. ADR-0013.

## Vocabulary you need before Stage 4

**Seam** — the single boundary at which acceptance tests attach: one exported function or entry
point, named in the change's `design.md`, whose inputs and outputs a test can drive without
spawning a process or capturing global streams. Fewer seams are better, an existing seam beats
a new one, and a Story whose `design.md` names no seam fails the Definition of Ready. The
openspec `design` template has **no seam section** — add `### The seam` under Decisions
yourself, or you will write a `design.md` that validates and still fails the DoR.

The rest of the process vocabulary is in `CONTEXT.md`.

## Working in parallel

**Two agents in one clone share `HEAD`.** A checkout by one moves the other's working tree
underneath it mid-task, and neither is told — it happened on 2026-08-29, and nothing was lost
only because both branches happened to point at the same commit. **So: one agent per working
tree.** If a second agent is working here, or you are starting a Story while another is in
flight, take a worktree instead of a branch:

```bash
git fetch origin
git worktree add ../daybyday-<change-id> -b story/<issue#>-<change-id> origin/main
cd ../daybyday-<change-id>
git branch --unset-upstream          # <- same trap as `git checkout -b`; do not skip it
pnpm install                         # a worktree starts with no node_modules
```

Work there, push and open the PR from there, and clean up after the merge with
`git worktree remove ../daybyday-<change-id>` from the main clone.

A worktree gets its own `HEAD` and index, which is the point. `.git/config` and tracked files
are shared, so `gh` still resolves to `dbugmann-labs/daybyday` and `.claude/`'s `deny` rules
load; anything gitignored does **not** come with you — `node_modules`, `CLAUDE.local.md`,
`.claude/settings.local.json`. Which is why anything another agent must know goes in a tracked
file.

Still one concurrent Story per capability: worktrees remove the collision in the *working
tree*, not two Stories racing for one file in `openspec/specs/`, which is decided at Stage 2.
See `docs/process.md` §7.

## Context discipline

Start every session from durable files, never from chat history. You are given an issue number;
read this file, `CONTEXT.md`, the change folder, and the relevant capability spec. When a
session must end mid-Story, use `/handoff` and write the continuation state into the change
folder — not into a chat log, not into the issue. A session that has drifted onto a second
Story is a bug: stop and start a fresh one.

## Skills

**Use:** `/atlas` (the conductor — start here), `/opsx:propose`, `/opsx:apply`,
`/opsx:archive`, `/opsx:explore`, `grill-with-docs`, `to-tickets`, `tdd`, `code-review`,
`triage`, `handoff`, `diagnosing-bugs`, `research`.

**Never invoke:** `to-spec` (duplicates `/opsx:propose` and would publish requirements to the
issue tracker, breaking rule 4), `implement` (duplicates `/opsx:apply`, and its commit step
bypasses review), `wayfinder`, `improve-codebase-architecture`. All four are
`disable-model-invocation: true`, so they cannot fire on their own — do not invoke them by name
either.

## Agent skills

- **Issue tracker** — GitHub Issues on `dbugmann-labs/daybyday` via `gh`.
  `docs/agents/issue-tracker.md`.
- **Triage labels** — the five canonical roles, label strings unchanged.
  `docs/agents/triage-labels.md`.
- **Domain docs** — single-context: `CONTEXT.md` and `docs/adr/`. `docs/agents/domain.md`.

## Commands

```bash
pnpm run status      # where is this Story, and whose turn is it? start every session here
pnpm run verify      # lint + typecheck + test — must pass before any PR
pnpm run checks      # the merge-time checks; advisory locally, binding in CI
pnpm run check:g4    # is this Story approved? run it before writing any code
pnpm run test:watch  # TDD loop
pnpm run graph       # regenerate docs/graph.mmd from GitHub; Stage 9, never checked by CI
openspec validate <change-id> --strict
openspec validate --all --strict --no-interactive
openspec validate --archived        # every archived tasks.md box ticked
```

## Working a Story

**Cut the branch at Stage 4**, from `origin/main`, once the Story exists:

```bash
git fetch origin && git checkout -b story/<issue#>-<change-id> origin/main
git branch --unset-upstream          # <- do not skip this
```

Skipping the unset leaves the branch tracking `origin/main`, so a later bare `git push`
targets the protected branch and is rejected.

Commit the change folder as `docs(<capability>): propose <change-id>` — it is documentation
until G4 — then `feat(<capability>): ...` for implementation. The archive at Stage 8 is the one
commit that breaks the pattern: `chore(archive): <change-id>`, scoped `archive` because it
moves the change folder rather than changing behaviour. Do not extrapolate
`chore(<capability>): ...` from it.

**Open the draft PR in the same breath**, before asking for G4 — a change folder is far easier
to judge as a diff than as four files someone opens by hand:

```bash
git push -u origin story/<issue#>-<change-id>
gh pr create --draft --base main --title '<change-id>' --body 'Closes #<issue#>'
```

`Closes #<issue#>` is what auto-closes the Story on merge, so it is not optional. Draft is not
decoration either: CI reads it as "this Story is not finished" and skips the four checks that
assert it is — 3, 4, 5 and 8 — which bind again when the janitor runs `gh pr ready` at Stage 8.

**Refresh the PR before each of the two gates**, G4 and G7:

```bash
git fetch origin && git rebase origin/main
git push --force-with-lease origin story/<issue#>-<change-id>
```

A rebase rather than a merge, so the PR shows the Story's own commits and nothing else. Not
tidiness: the delta's ADDED / MODIFIED claims are written against the specs as they stand, and
`main` moving underneath can invalidate them without touching a file on the branch. A rebase
conflict inside the change folder or `openspec/specs/` is a stop — another Story landed on this
capability, which is the human's decision, not a merge you resolve (rule 5).

**`pnpm run checks` is staged.** Mid-Story it reports rather than fails — the single-change
rule reads "still active" until the archive, and coverage reports `2/4 covered — next:
"<title>"` — because a check demanding all four tests at once would force exactly the bulk
transcription rule 3 forbids. In CI the same checks bind, because a PR claims the Story is
finished.

**Gate checkboxes** are ticked by whoever can verify the condition — the orchestrator ticks G1
and G2, the implementer the machine-checkable DoR and DoD boxes. The one no agent may ever tick
is G4: that is the human's decision, recorded as a comment rather than a checkbox.

**Closing.** `open` means one thing at every level: there is outstanding work under this node.
A Story closes with its PR; a Feature when no open Story remains under it, reopening when a new
one is cut (what lives forever is the capability spec, not the issue); an Epic when its
Features do. `docs/graph.mmd` draws a parent ready to close in amber. See
`docs/agents/issue-tracker.md` § *Closing the hierarchy*.

**Labels.** Pipeline issues carry no triage label — they are triaged by existing. The five
triage labels are for inbound or unplanned work only.

## This machine

Homebrew is unusable here: `/opt/homebrew` is owned by `admin:admin`, this account is not in
the `admin` group, and there is no passwordless sudo. Never suggest `brew install` or
`sudo chown`. Node comes from fnm in `~/.local/share/fnm`, pnpm from `~/Library/pnpm/bin` — the
binary is `$PNPM_HOME/bin/pnpm`, not `$PNPM_HOME/pnpm`. Anything new must install into `$HOME`.

**A non-interactive shell has neither on PATH and defaults to Node 20**, where `pnpm run test`
fails at startup with `ERR_INVALID_ARG_VALUE ... styleText` from rolldown — an error naming
neither Node nor the version. Open every Bash session with:

```bash
export PNPM_HOME="$HOME/Library/pnpm"; export FNM_DIR="$HOME/.local/share/fnm"
export PATH="$PNPM_HOME/bin:$FNM_DIR:$PATH"; eval "$(fnm env)"; fnm use 24
```

If a tool fails oddly, run `node --version` before diagnosing anything else.

Dependency installs are gated by `minimumReleaseAge: 1440` in `pnpm-workspace.yaml` — pnpm
refuses versions published in the last 24h. If an install fails that check, do not add an
exclusion; pick a matured version or widen the range. See ADR-0011.
