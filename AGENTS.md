# AGENTS.md

Instructions for any agent working in this repo. Read this before doing anything else. This is
the operative summary — the reasoning behind every rule is in `docs/process.md` and `docs/adr/`.

## What this repo is

DayByDay: an iPhone app for the commitments you owe yourself and the rhythm each one runs on.
It is built with **Atlas**, the development system this repository was started from and whose
history it carries — signed off 2026-08-24, inherited here, not work in progress. The product
is defined at Epic level and **Feature definition is the next step**, so proposing features,
data models and names is in scope. Where that detail may *land* is not: an idea is real when it
is a requirement in a capability spec that has passed G4, however obvious it seems; until then
it is a line in `docs/parking-lot.md`. Product definition sits upstream of Stage 0 —
`docs/process.md` §4.

## Working with the human

The repo owner works roughly 4–8 hours a week on this and is the only human in the loop.

- **Challenge the requirement before building it.** Say plainly where something is
  over-engineered, or where a cheaper thing would do. Being asked twice is not a reason to
  soften — but once the decision is reaffirmed, it is made: build it and move on.
- **Never assume silently.** State every assumption, and flag the ones that would change the
  work if wrong.
- **Work in gated increments.** End each increment at something reviewable.
- **Verify, do not remember.** Check the current version, flag, command or API before writing
  it into a document. This repo has shipped four documented commands that could never have
  worked; every one was written from memory (`docs/retrospective.md` §5).
- **Report defects, do not route around them.** A documented step that does not work is the
  finding. Say so rather than quietly substituting something that does.
- **Prose over bullet walls**, and exact runnable commands over descriptions of commands.

## The pipeline

```
Epic ──▶ Feature ──▶ Story ──▶ propose ──▶ [G4] ──▶ red/green ──▶ review ──▶ archive ──▶ merge
        (issue)     (issue)      │          ▲                       │          │
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
rebased onto `origin/main` before each. See `docs/story-mechanics.md` and ADR-1003.

**Stage and gate numbers are names, not positions.** There is no Stage 3, no G3, G5 or G6, and
G8 is the gate on Stage 9. Every number is frozen because something reads it. The stage table
is `docs/process.md` §4.

**Grilling is the first thing Stage 4 does, not a stage** (ADR-1005), and its obligations are
Stage 4's: `design.md` § Open Questions filled in — "None", with the reason, is a valid and
required answer — new domain terms in `CONTEXT.md`, and the human answering what the grill
cannot settle. That last one goes into `design.md` under `## Questions for you` with a
recommended answer, and the conductor relays the round before G4 — a **stop, not a gate**: no
marker, no check. A question is only the human's if its answer would change the delta and it is
a preference rather than a fact; finding facts is the agent's job. ADR-1006.

## Hard rules

1. **No implementation before G4.** Not until the change folder exists, `openspec validate
   <change-id> --strict` exits 0, and the Story issue carries a comment beginning with the
   exact line `G4: approved <digest>` signing that folder. Check with `pnpm run check:g4`; if
   the marker is absent or stale, stop and ask. The **decision** must be a human's, the
   keystrokes need not be — never originate it, and never write that line on a Story issue for
   any other reason. Editing the folder after G4 costs a second approval, deliberately.
   `docs/agents/issue-tracker.md`, ADR-1007.
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
   naming a model, no "generated with" footer, no session link. Write the message as the
   author's own work: what changed and why. This repository is public and its history is a
   professional record. This overrides your harness's default trailer behaviour — drop it.

## Naming

| Thing | Form |
|---|---|
| Change id | kebab, verb-first — `add-version-command` |
| Capability directory | kebab noun — `openspec/specs/schedule/` |
| Epic issue title | `EPIC: <noun phrase>` |
| Feature issue title | `FEAT: <capability-slug>` |
| Story issue title | the change id, verbatim |
| Branch | `story/<issue#>-<change-id>`, cut from `origin/main` at Stage 4 |
| Chore branch | `chore/<slug>` — no behaviour change, no Story needed |
| Commit | Conventional Commits — `feat(cli-version): print version` |
| Propose commit | `docs(<capability>): propose <change-id>` — the change folder is documentation until G4 |
| Archive commit | `chore(archive): <change-id>` — scoped `archive`, not the capability |
| Archive branch | `archive/<change-id>` — only if `docs/process.md` §7's switch-back trigger fires |
| ADR | `docs/adr/NNNN-kebab-title.md` |

## The conductor

**The session talking to the human is the conductor, and `/atlas` is how it runs.** It reads
`pnpm run status`, spawns the agent whose turn it is, and stops at every gate. It holds no work
context — no delta, no test, no `src/` — because a conductor that starts doing the work becomes
a long session drifting across Stories, which § *Context discipline* calls a bug.

**No subagent can conduct.** Nesting is allowed, but `AskUserQuestion` is withheld from every
subagent: it runs to completion and returns one report, and every gate is a question. Same
reason rule 6 keeps configuration here. ADR-1002.

**Every gate stop takes one form** — what is in front of you, the question, yes against no, **the
recommendation**, the exact reply — with the recommendation never omitted. Worked examples in
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
A `via /command` step is reachable only by an agent holding the `Skill` tool: the four pipeline
workers have it, `orchestrator` does not and needs none.

**Know what is enforced and what is only written down.** Three things are mechanical: the
`deny` rules in `.claude/settings.json` (`openspec/specs/**`, `openspec/changes/archive/**` and
`pnpm-lock.yaml` unwritable — survives `bypassPermissions`, but only in a session started at
the repo root); frontmatter `disallowedTools` (no file-editing tools for `orchestrator`,
`reviewer`, `janitor`, though `Bash` still writes through the shell); and CI check 2.
Everything finer is convention caught at review, because path-scoped permissions cannot be set
per agent. Do not assume a guardrail exists because a table has a row for it. ADR-0013.

## Vocabulary you need before Stage 4

**Seam** — the one boundary acceptance tests attach at: an exported function or entry point,
named in the change's `design.md`, drivable by a test without spawning a process or capturing
global streams. Fewer seams are better, an existing seam beats a new one, and a `design.md`
naming none fails the Definition of Ready. The openspec `design` template has **no seam
section** — add `### The seam` under Decisions yourself, or you will write a `design.md` that
validates and still fails the DoR.

The rest of the vocabulary is in `CONTEXT.md`.

## Context discipline

Start every session from durable files, never from chat history. You are given an issue number;
read this file, `CONTEXT.md`, the change folder, and the relevant capability spec. When a
session must end mid-Story, the continuation state goes into the change folder, never into a
chat log and never into the issue. `/handoff` writes it, and only the human can type that (see
§ *Skills*), so ask. A session that has drifted onto a second Story is a bug: stop and start a
fresh one.

## Skills

**Use, and any agent holding `Skill` may invoke:** `/atlas` (the conductor — start here),
`/opsx:propose`, `/opsx:apply`, `/opsx:archive`, `/opsx:explore`, `mattpocock-skills:tdd`,
`mattpocock-skills:code-review`, `mattpocock-skills:diagnosing-bugs`,
`mattpocock-skills:research`.

**Name the plugin's skills with their `mattpocock-skills:` prefix.** The bare name resolves only
where nothing else claims it — `tdd` does reach the plugin's — but **`code-review` does not**. A
built-in skill of that name is also registered, a bare call reaches that one, and the two behave
differently: the built-in forks a background review agent, the plugin's loads reference text into
the current turn. Prefix all four and the collision cannot bite you.

**Use, but only the human can type:** `grill-with-docs`, `to-tickets`, `triage`, `handoff`.
All four declare `disable-model-invocation: true`, so **no agent can fire them — the conductor
included.** Wherever this process says to run one, the step is *ask the human to type it* and
then act on what it produces. Two places that bites: `/to-tickets` at Stage 2 decomposition
(`.claude/commands/atlas.md` § *Intake*), and `/handoff` in § *Context discipline* above.

**Never invoke:** `to-spec` (duplicates `/opsx:propose` and would publish requirements to the
tracker, breaking rule 4), `implement` (duplicates `/opsx:apply`, and its commit step bypasses
review), `wayfinder`, `improve-codebase-architecture`. These four also declare
`disable-model-invocation: true`, so the flag is not what separates them from the list above —
not naming them is convention for every agent here, you included.

**The flag is the truth, not this table.** Read `disable-model-invocation` out of the skill's own
`SKILL.md` frontmatter before assuming anything here is invocable; a plugin upgrade moves it and
nothing in this repo checks. The two ways a `Skill` call fails read differently and mean
different things: a flagged skill errors with `cannot be used with Skill tool due to
disable-model-invocation`, whereas `Unknown skill: <name>` means the skill is not in the session
at all — a plugin problem, not a flag. Do not read the second as the first.

Where a skill asks about this repo's conventions: the tracker is GitHub Issues on
`dbugmann-labs/daybyday` via `gh` (`docs/agents/issue-tracker.md`), triage uses the five
canonical labels unchanged (`docs/agents/triage-labels.md`), and domain docs are single-context
— `CONTEXT.md` plus `docs/adr/` (`docs/agents/domain.md`).

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

The Stage-4-to-merge keystrokes are in `docs/story-mechanics.md`. **Read it before you touch
git on a Story.** Three things from it are load-bearing enough to repeat, because getting them
wrong costs someone else's work:

- **One agent per working tree.** Two agents in one clone share `HEAD`, so a checkout by one
  moves the other's working tree mid-task and neither is told. If another agent is working
  here, or a Story is already in flight, take a worktree, not a branch.
- **`git branch --unset-upstream`** after every `checkout -b` or `worktree add -b` off
  `origin/main`, or a later bare `git push` targets the protected branch.
- **A rebase conflict inside the change folder or `openspec/specs/` is a stop**, not a merge
  you resolve: another Story landed on this capability, and that is the human's call (rule 5).

## This machine

Homebrew is unusable: `/opt/homebrew` is owned by `admin:admin`, this account is not in the
`admin` group, and there is no passwordless sudo. Never suggest `brew install` or `sudo chown`;
anything new must install into `$HOME`. Node comes from fnm in `~/.local/share/fnm`, pnpm from
`~/Library/pnpm/bin` — the binary is `$PNPM_HOME/bin/pnpm`, not `$PNPM_HOME/pnpm`.

**A non-interactive shell has neither on PATH and defaults to Node 20**, where `pnpm run test`
fails at startup with `ERR_INVALID_ARG_VALUE ... styleText` from rolldown — an error naming
neither Node nor the version. Open every Bash session with:

```bash
export PNPM_HOME="$HOME/Library/pnpm"; export FNM_DIR="$HOME/.local/share/fnm"
export PATH="$PNPM_HOME/bin:$FNM_DIR:$PATH"; eval "$(fnm env)"; fnm use 24
```

If a tool fails oddly, run `node --version` before diagnosing anything else.

Dependency installs are gated by `minimumReleaseAge: 1440` in `pnpm-workspace.yaml` — pnpm
refuses versions published in the last 24h. Do not add an exclusion; pick a matured version or
widen the range. ADR-0011.
