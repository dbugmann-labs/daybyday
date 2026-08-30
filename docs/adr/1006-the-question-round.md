# 1006. A question round, not a fifth gate

- Status: accepted
- Date: 2026-08-30
- Deciders: Diego Bugmann

## Context

ADR-1005 folded the grill into Stage 4 and listed three obligations that moved with it. Two are
artifacts and are visible on disk: `design.md` § *Open Questions* is filled in, and new domain
terms land in `CONTEXT.md`. The third is not an artifact:

> **The human still answers what the grill cannot settle.** That was never an agent's decision
> to make, and folding the stage does not make it one.

Nothing implements that sentence. `spec-author` is told to *"stop and ask through whoever
spawned you"*, and the conductor has no defined behaviour for receiving such a question:
`.claude/commands/atlas.md` knows how to spawn an agent and how to present a gate, and a
returned question is neither. So the obligation is stated in four documents and executable in
none — which is the defect ADR-1005 itself was written to remove, one layer further down.

**The mechanism it needs cannot live in the agent.** The `grilling` skill is an interview: *"Ask
the whole frontier in one round: number each question and give your recommended answer. Then
wait for the user's answers."* A subagent cannot wait. `AskUserQuestion` is withheld from every
subagent by the harness — that is the whole premise of ADR-1002 — so `spec-author` runs to
completion and returns one report. The stage table said "agent, but **you** answer what it
cannot" for as long as Stage 3 existed, and described a channel that has never been there.

Both Stories run to date show the consequence rather than the failure, because the agent behaved
well. On `add-day-of-month-schedule` (#9), what a short month does — clamp to the last day, or
skip the month entirely — is a product decision with no technical answer. `spec-author` took it,
argued it from `CONTEXT.md` and `docs/parking-lot.md`, wrote the rejected alternatives down, and
labelled it honestly in `design.md`: *"The clamp is a product decision an agent is proposing, not
a fact."* Then `## Open Questions` said **None**, and the first the human saw of it was G4.

That is the good version. It depended on the agent choosing to flag it.

## Decision

**When `spec-author` cannot settle a question, it asks it — in writing, on the change folder —
and the conductor relays the round.** The grill's *work* stays in the agent; the grill's *asking*
moves to the only participant that can ask.

- `design.md` may carry a **`## Questions for you`** section. It exists only while a round is
  outstanding. Each entry is numbered and carries three things: the question, the answer
  `spec-author` recommends, and what changes in the delta if the answer goes the other way.
- **The change folder is written anyway**, on the recommended answers, and it validates, commits,
  pushes and opens the draft PR as normal. The round therefore arrives with its consequence
  visible as a diff rather than as an abstract question. This is deliberate: an interview asks
  "clamp or skip?"; a round asks the same thing with the five scenarios it would rewrite already
  on screen.
- `pnpm run status` reports an outstanding round as **Stage 4, owned by you**. The conductor
  presents it in the standard five-part gate form, collects the answers, and re-spawns
  `spec-author`, which folds each answer into the delta, records it under `## Open Questions` as
  settled, deletes `## Questions for you`, revalidates and pushes.
- A question belongs in a round only if **both** hold: its answer would change the delta, and it
  is a preference the human holds rather than a fact the agent could look up. Finding facts is
  the agent's job, not the human's — the `grilling` skill is explicit about that, and #9's
  `design.md` is the worked example, measuring Foundation's month lengths rather than asking.

**This is a stop, not a gate.** There is no G-number, no marker string, no CI check, and nothing
blocks on it mechanically. A Story with no unsettleable question never triggers one, and the
rhythm stays at four interruptions.

## Consequences

- **A required place to say "I decided this on your behalf."** #9's flag was good behaviour; this
  makes it a section with a name. The failure mode it removes is a product decision arriving
  inside `## Decisions` prose, correct and well-argued, where a human reading at G4 sees an
  argument rather than a question.
- **The cheap case stays cheap.** If the recommendations are right, the reply is one word and the
  delta does not change — `spec-author` records the answers and moves on. The round only costs a
  rewrite when it was going to cost one at G4 anyway, and it costs it before the implementer has
  run rather than after.
- **The conductor stays thin, and ADR-1002's rule holds.** It carries a numbered list of
  questions and a list of answers; it never holds the design tree that produced them. This is the
  same shape as the G4 relay, where it records a decision it did not make. If presenting a round
  ever requires the conductor to reason about the delta to make the question intelligible, that is
  the signal this was the wrong shape — see the rejected alternative below.
- **Nothing enforces that a round was raised when it should have been.** `status` can see that a
  `## Questions for you` section exists; it cannot see a question that was never written down.
  Same trade as ADR-1005 and ADR-0010: the artifact is checkable, the judgement is not, and saying
  so is better than implying otherwise.
- **It is one more thing that can turn into a gate.** ADR-1002 named that risk about
  `pnpm run status` and the test applies here unchanged: if this ever grows a marker, a check, or
  a `G` number, it has become the sixth gate this decision was shaped to avoid.

## Alternatives considered

**Leave it at G4 and rely on `changes: <what>`.** The existing reply vocabulary already lets the
human reject a decision, and #9 proves an agent can flag one well without a mechanism. Rejected
because the flag was optional and its placement was the agent's choice: buried in
`## Decisions`, a proposed product decision reads as a settled one, and G4's question — *"are
these the right requirements?"* — is not the same question as *"this one was mine to make and
an agent made it."* The round costs a section and a status branch; it is the cheapest thing that
makes the difference visible.

**A separate grill session, handed off before the propose session.** A top-level session can ask,
so this works where a subagent does not, and it answers a real tension: the conductor is
forbidden work context by ADR-1002, and an open-ended grill *is* work context. Rejected because
the handoff artifact between the grill session and the propose session would be the change
folder's own `design.md` — which is where the round already lives — so the extra session buys a
context boundary and costs a session start, on a process whose scarcest input is the owner's
attention. The relay keeps the conductor thin by a different route: the agent composes the
questions, the conductor only carries them. If that proves insufficient in practice, this is the
decision to revisit, and `/handoff` into the change folder is the shape it would take.

**Ask before writing the change folder.** Cleaner in theory — no work is done on an answer that
may be overturned. Rejected on two counts. `pnpm run status` derives the stage from the change
folder, so a Story that has questions but no folder is indistinguishable from one that has not
started; and the round would lose the thing that makes it better than an interview, which is that
the human reads the question next to the delta it would change.
