# 1002. The conductor is the main session, and status is a projection

- Status: accepted
- Date: 2026-08-29
- Deciders: Diego Bugmann
- Amended: 2026-09-04 — *holds no work context* is redrawn by object rather than by effort: the
  conductor runs both grills itself and holds the question tree, and still writes no delta, no
  test and no `src/`. The claim that every interruption arrives in the same shape is corrected
  with it, and the interruption count is dropped rather than corrected: totals belong in
  `docs/process.md` §4, not in a record. ADR-1006, ADR-1012.

## Context

`docs/process.md` describes ten stages and five gates. Running a Story through them meant the
human personally invoking six agents in order and knowing, each time, that it was their turn.
Three things made that harder than it needed to be, and the first is a defect rather than a
gap.

**The orchestrator was defined to do something it had no way to do.** `.claude/agents/orchestrator.md`
listed "Delegation — hand a subagent a Story issue number and nothing else" as one of its four
jobs, `AGENTS.md` repeated it, and §6 of the process document described the orchestrator as the
agent that hands work on. Its frontmatter reads `tools: Read, Grep, Glob, Bash, TodoWrite,
WebFetch`. There is no `Agent` tool in that list, so it could not spawn `spec-author`,
`implementer`, `reviewer` or `janitor`. The pipeline's stated conductor was in fact a
specialist that wrote GitHub issues and returned. The human was the conductor all along,
without the documents ever saying so.

**That is a missing tool, not a missing capability, and the distinction was checked rather than
assumed.** Claude Code permits nested delegation: a subagent may spawn subagents up to three
layers deep by default, the `Agent` tool is available to subagents unless withheld, and
`Agent(type1, type2)` scopes which types a given agent may spawn. So "give the orchestrator the
`Agent` tool and let it conduct" is a real option, and the first draft of this record wrongly
implied the harness forbade it. What the harness does forbid is the half that matters:
`AskUserQuestion` is permanently withheld from every subagent, which cannot stop mid-run to ask
anything — it runs to completion and returns one report. Every gate is a question. Two further
properties follow from nesting itself: nested output never reaches the main conversation except
as the parent's summary, and each layer puts another agent between the human and the record of
what they decided.

**Nothing answered "where am I?"** `pnpm run checks` answers *is this mergeable*;
`docs/graph.mmd` draws the issue tree. Neither says *this Story is at Stage 4 and waiting on
your signature*. Reconstructing that by hand meant correlating eight signals across three
systems: the branch name, the change folder, `openspec validate`, the `G4: approved` comment,
scenario coverage, the `tasks.md` boxes, the sub-issue edges and the PR. `docs/process.md` §4
prices the human's own time per Story, and §12 names it as the cost that decides whether this
process survives a four-to-eight-hour week. Re-deriving position at the start of
every session is part of that bill and buys nothing.

**Gate stops had no defined shape.** G1, G2, G4 and G7 are each "the human says yes", and
nothing specified what the human is shown at the moment of deciding. Each session improvised
the presentation, which is how a gate quietly becomes a rubber stamp.

The retrospective is the counter-argument and it is a real one: scaffolding to product stands
at roughly 60:1, and none of the four bespoke merge-time checks has ever blocked a bad merge.
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

**The conductor holds no work context.** It reads status, presents gates, runs the two grills,
spawns the agent whose turn it is, and reports what came back. It writes no delta, no test and
no `src/`. This is what keeps `AGENTS.md` § *Context discipline* intact: a conductor that starts
doing the work becomes a long session drifting across several Stories, which that section calls
a bug.

**The line is drawn by object, not by effort** — amended 2026-09-04, when the Story grill moved
here. An open-ended interview *is* work context by any measure of effort, so the rule survives
only if it names things rather than exertion: the conductor holds the question tree — the
questions, their answers, and the terms they land — and never the delta, the tests or `src/`.
`grill.md` is the one file it writes, and it holds decisions rather than requirements, which is
why writing it is not authoring the spec. ADR-1006 carries the reasoning.

**`pnpm run status` derives the stage from the systems of record and names whose turn it is.**
It is a projection in exactly the sense `docs/graph.mmd` is one: read-only, derived on demand,
never an input, and consumed by no check. Deleting it would cost information, not correctness.
Scenario discovery moves into `scripts/lib/coverage.ts` so that CI check 4 and status share one
definition of "covered" rather than two that can disagree.

**Gate stops take one fixed form**, specified in `.claude/commands/atlas.md` and
`docs/process.md` §4: what is in front of you, the question, what a yes commits you to against
what a no costs, and the exact reply.

## Consequences

The human is interrupted at gates rather than at every stage boundary, and each interruption
arrives in one of two asking shapes: the grill prints as a round, and every gate as a five-part
block. How many stops that is, and what they cost, is `docs/process.md` §4 § *The rhythm, and
what it costs* — deliberately not repeated here. *Amended 2026-09-04; this read "roughly four
times per Story" and "the same shape", both written before the grill became an interview, and
the count was then dropped rather than corrected a second time. ADR-1006, ADR-1012.* A session
that opens on `main` can ask what is outstanding and get an answer rather than reconstructing
one.

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

**Give the orchestrator an `Agent` tool and let it conduct.** This is the strongest
alternative and it is genuinely available — see the Context above; nesting is permitted. It was
rejected on three counts, in increasing order of weight.

*Gates become cold restarts.* A subagent cannot ask, so it must terminate at every gate, return,
and be re-spawned afterwards. That is survivable — `pnpm run status` exists precisely so a cold
agent can recover its position in one command — but it means the conductor conducts only
between gates, and between gates there are rarely more than two steps. The value of conducting
is concentrated exactly where a subagent cannot be.

*The reviewer's findings would arrive paraphrased.* Nested subagent output reaches the main
conversation only as the parent's summary. At G7 the human would read the reviewer through
whatever spawned it, and the reviewer's findings are the one artifact that must reach the human
unmediated — the entire point of an agent that reports and never edits.

*The G4 relay would gain a hop.* The human says "approved" to the session in front of them. If
the conductor is a subagent, that decision must be relayed to it before the marker is written,
so the agent recording the gate is not the agent that heard the decision. ADR-0014 rests on
agents never originating that marker; adding a relay hop makes "did a human actually say this?"
harder to audit for no gain. It is the same argument hard rule 6 already makes about
configuration, and gate decisions are authorization in exactly that sense.

What the alternative would have bought is real and is conceded: a main session that stays small
because the workers' reports land somewhere else. The mitigation is that the conductor holds no
work context by rule, and `/handoff` between gates is already the answer when a session does
get long. If that proves insufficient in practice, this is the decision to revisit, and
`Agent(spec-author, implementer, reviewer, janitor)` is the shape it would take.

**A `G7: reviewed` marker to make Stage 7 observable.** Rejected above: one status line is not
worth a second gate convention.

**Do nothing and keep driving by hand.** Rejected, but it was the honest baseline. It works; it
costs the scarcest thing in this project, which is the owner's attention, and it degrades
fastest exactly when sessions are far apart.

## Corrections

- **2026-09-01** — the counter-argument read "five bespoke merge-time checks". Check 3 was
  dropped by ADR-1008 on 2026-08-31, leaving four: 2, 4, 5 and 6. Not a change of mind — the
  retrospective finding this sentence records, that none of them had blocked a bad merge, is
  unchanged, and so is the decision it was weighed against.
