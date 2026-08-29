# 1002. The conductor is the main session, and status is a projection

- Status: accepted
- Date: 2026-08-29
- Deciders: Diego Bugmann

## Context

`docs/process.md` describes ten stages and five gates. Running a Story through them meant the
human personally invoking six agents in order and knowing, each time, that it was their turn.
Three things made that harder than it needed to be, and the first is a defect rather than a
gap.

**The orchestrator was defined to do something it cannot do.** `.claude/agents/orchestrator.md`
listed "Delegation — hand a subagent a Story issue number and nothing else" as one of its four
jobs, `AGENTS.md` repeated it, and §6 of the process document described the orchestrator as the
agent that hands work on. Its frontmatter reads `tools: Read, Grep, Glob, Bash, TodoWrite,
WebFetch`. There is no Agent tool in that list, so it could never spawn `spec-author`,
`implementer`, `reviewer` or `janitor`. The pipeline's stated conductor was in fact a
specialist that wrote GitHub issues and returned. The human was the conductor all along,
without the documents ever saying so.

**Nothing answered "where am I?"** `pnpm run checks` answers *is this mergeable*;
`docs/graph.mmd` draws the issue tree. Neither says *this Story is at Stage 4 and waiting on
your signature*. Reconstructing that by hand meant correlating eight signals across three
systems: the branch name, the change folder, `openspec validate`, the `G4: approved` comment,
scenario coverage, the `tasks.md` boxes, the sub-issue edges and the PR. `docs/process.md` §12
prices the human's own time at 45–90 minutes per Story and names it as the cost that decides
whether this process survives a four-to-eight-hour week. Re-deriving position at the start of
every session is part of that bill and buys nothing.

**Gate stops had no defined shape.** G1, G2, G4 and G7 are each "the human says yes", and
nothing specified what the human is shown at the moment of deciding. Each session improvised
the presentation, which is how a gate quietly becomes a rubber stamp.

The retrospective is the counter-argument and it is a real one: scaffolding to product stands
at roughly 60:1, and none of the five bespoke merge-time checks has ever blocked a bad merge.
Adding machinery here deserves suspicion.

## Decision

**The conductor is the session talking to the human, driven by a `/atlas` command.** It is the
only participant that can both spawn subagents and ask a question, and hard rule 6 already
gives it sole ownership of configuration changes for the same underlying reason: a subagent
correctly refuses authorization relayed through another agent. Gate decisions are authorization.

`.claude/agents/orchestrator.md` is rewritten to describe what it is — the agent that writes
the tracker: issue types, bodies that carry no requirements, and sub-issue edges verified from
both ends. Its delegation claim is removed from the agent file, from `AGENTS.md` and from
`docs/process.md`.

**The conductor holds no work context.** It reads status, presents gates, spawns the agent
whose turn it is, and reports what came back. It writes no delta, no test and no `src/`. This
is what keeps `AGENTS.md` § *Context discipline* intact: a conductor that starts doing the work
becomes a long session drifting across several Stories, which that section calls a bug.

**`pnpm run status` derives the stage from the systems of record and names whose turn it is.**
It is a projection in exactly the sense `docs/graph.mmd` is one: read-only, derived on demand,
never an input, and consumed by no check. Deleting it would cost information, not correctness.
Scenario discovery moves into `scripts/lib/coverage.ts` so that CI check 4 and status share one
definition of "covered" rather than two that can disagree.

**Gate stops take one fixed form**, specified in `.claude/commands/atlas.md` and
`docs/process.md` §4: what is in front of you, the question, what a yes commits you to against
what a no costs, and the exact reply.

## Consequences

The human is interrupted roughly four times per Story instead of at every stage boundary, and
each interruption arrives in the same shape. A session that opens on `main` can ask what is
outstanding and get an answer rather than reconstructing one.

**Status can be wrong, and nothing breaks when it is.** That is the point of making it a
projection. The systems of record remain the change folder, the tracker and the specs; if
status disagrees with them, status is the thing that is wrong.

**Stage 7 stays invisible.** Nothing on disk or in the tracker records that a review ran, so a
Story whose scenarios are all covered reports "review, then archive" until it is archived. A
`G7:` marker mirroring G4 was considered and rejected: G4 earns a machine-readable signature
because it is the gate that gates everything; a second marker buys one accurate status line and
costs a convention every agent must be taught. Status says what it cannot see instead of
guessing.

**This adds a command, not a gate.** The distinction is the whole justification given the
retrospective's 60:1 ratio. Nothing blocks on status, nothing blocks on `/atlas`, and a Story
can still be driven entirely by hand. What is added is a reduction in the one cost §12
identifies as load-bearing. If it ever grows a check that can fail, that is the signal it has
turned into the sixth gate this ADR was written to avoid.

**Numbering has a consequence for Atlas.** This is a process decision recorded in DayByDay's
sequence, because `docs/adr/README.md` reserves `0001`–`0999` for Atlas and DayByDay's own
records start at `1001`. When this is ported upstream it becomes an Atlas ADR with an Atlas
number, and this file stays as the record of where the decision was made and first run.

## Alternatives considered

**Give the orchestrator an Agent tool and let it conduct.** Rejected. A subagent cannot ask the
human a question, so every gate would round-trip through the main session anyway — losing the
context that made the presentation worth reading — and hard rule 6 would still keep
configuration out of its hands. It would also put the agent that writes the tracker in charge
of deciding when to write to it.

**A `G7: reviewed` marker to make Stage 7 observable.** Rejected above: one status line is not
worth a second gate convention.

**Do nothing and keep driving by hand.** Rejected, but it was the honest baseline. It works; it
costs the scarcest thing in this project, which is the owner's attention, and it degrades
fastest exactly when sessions are far apart.
