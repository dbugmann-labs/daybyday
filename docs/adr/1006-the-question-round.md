# 1006. A question round, not a fifth gate

- Status: accepted
- Date: 2026-08-30
- Deciders: Diego Bugmann
- Amended: 2026-09-04 — the grill moves to the conductor and runs interactively, in rounds,
  before the change folder is written; its answers land in `grill.md` and `spec-author` writes
  the delta on them. `## Questions for you` is demoted to the **residual round**, for the
  question that only becomes visible while the delta is being phrased. What makes a question the
  human's is unchanged, and this is still a stop rather than a gate.

## Context

ADR-1005 folded the grill into Stage 4 and listed three obligations that moved with it. Two are
artifacts and are visible on disk: `design.md` § *Open Questions* is filled in, and new domain
terms land in `CONTEXT.md`. The third is not an artifact:

> **The human still answers what the grill cannot settle.** That was never an agent's decision
> to make, and folding the stage does not make it one.

Nothing implemented that sentence. `spec-author` was told to *"stop and ask through whoever
spawned you"*, and the conductor had no defined behaviour for receiving such a question:
`.claude/commands/atlas.md` knew how to spawn an agent and how to present a gate, and a returned
question is neither. So the obligation was stated in four documents and executable in none —
which is the defect ADR-1005 itself was written to remove, one layer further down.

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

### The first shape ran the interview where an interview cannot happen

This record's first shape moved the *asking* to the conductor and left the *loop* in the agent.
Three things follow from that, and none of them needed a transcript to see once the pieces were
laid next to each other on 2026-09-04.

**The loop collapsed to a single pass.** `grilling` is not one question and not one round; it is
a loop — ask the frontier, wait, recompute the frontier from what came back, ask again, stop when
it is empty. The Story grill ran inside `spec-author`, which cannot wait, so the loop executed
exactly once and returned a report. The design tree never got past depth one, and every question
that the answers to round one would have unblocked went unasked. The fact was named correctly
above and the wrong boundary was drawn from it: the part that needed the human was the loop, not
the phrasing.

**Writing the change folder first leaned the answer.** The round was to reach the human next to a
diff written on the agent's own recommended answers, so that the question arrived with its
consequence visible. What that also means is that agreeing costs nothing and disagreeing costs a
rewrite the human can see on the screen in front of them. That is a lean, and it points at the
recommendation — the rubber stamp this record was written to prevent, reached from the other
side. It is the same double edge ADR-1012 found in question-first ordering: a form can produce
the cheap reply by making the expensive one look expensive.

**The five-part wrapper dropped exactly the questions worth asking.** `.claude/skills/grill/`
told the conductor to present the round "in the standard five-part form". A five-part block
carries one question under a ten-line budget (ADR-1012); an interview carries n. And `AGENTS.md`
and `atlas.md` both said "do not ask four when one decides it", which is right at a gate and
exactly wrong at a grill, where the fourth question is the product. Between them the shape
guaranteed a questionnaire.

## Decision

**The Story grill is an interview, it is the first step of Stage 4, and the conductor holds it —
interactively, in rounds, until the frontier is empty.** `spec-author` is spawned afterwards and
writes the delta on settled answers rather than on its own recommendations. Stage 4 keeps its
shape — grill, then propose — so ADR-1005 is untouched, and there is no new stage, no new gate
and no new number.

- **The round is a shape the conductor prints, and it is printed unwrapped**: `grilling`'s own
  format, every question carrying the answer the conductor would give, never inside a five-part
  block. A five-part block asks for a decision; a round asks for answers. ADR-1012, amended.
- **The grill writes one file, `grill.md`, into the change folder.** `## Settled` carries the
  answers — one line of decision and one clause of why — and not requirements; phrasing a settled
  answer as a requirement is the conductor writing the delta. New terms land in `CONTEXT.md`.
  **`## Left open` is required, and `None.` with the reason is a valid answer**; it is the same
  obligation `design.md` § *Open Questions* carries, one step earlier, and `spec-author` carries
  it forward into that section.
- **The answers travel in the file, not in the prompt.** `spec-author` is spawned with the issue
  number and nothing else, reads `grill.md` out of the worktree, and proposes.
- **`## Questions for you` survives as the residual round.** It is for the question that only
  becomes visible while the delta is being written — an edge nobody could see until someone tried
  to phrase the requirement. `spec-author` writes it into `design.md` with a recommended answer
  and what changes in the delta if it goes the other way, the conductor relays it in the
  five-part form — a block and not a round, because by then the delta exists and each question is
  a decision read against a diff — and re-spawns with the answers. It should now be rare, and one
  that could have been asked at the grill is a finding about the grill.
- **What makes a question the human's is unchanged.** A question belongs to them only if
  **both** hold: its answer would change the delta, and it is a preference they hold rather than
  a fact that could be looked up. **Finding facts is the agent's job, never the human's** — read
  the spec, measure it, check the environment, or dispatch an agent to. A question that reaches
  the human and turns out to have had an answer on disk is a finding about the grill, and it does
  not block the rest of the frontier while it is looked up.
- **The conductor holds the question tree and nothing else.** ADR-1002's line is redrawn by
  *object* rather than by effort: the questions, their answers and the terms they land are the
  conductor's; the delta, the tests and `src/` are not. Every fact is dispatched. Reasoning about
  what a requirement should say, rather than about what to ask next, is the signal that the line
  has been crossed, and the move is to stop and hand it to `spec-author`.

**This is a stop, not a gate.** There is no G-number, no marker string, no CI check, and nothing
blocks on either the grill or a residual round mechanically.

## Consequences

- **The rhythm gains one guaranteed interruption per Story and loses an occasional one.** A
  round the agent happened to raise, at the end of Stage 4, is traded for a grill that always
  runs, at the top of it; the round survives as the rare residual. That delta is the decision.
  The resulting count, and its price, are kept in `docs/process.md` §4 § *The rhythm, and what it
  costs* and not restated here. The walk-away structure is preserved exactly where it was:
  everything from the `spec-author` spawn to G7 still runs unattended, and the step report's
  walk-away line still says so. **Interactivity is bought with the owner's presence** — 15 to 30
  contiguous minutes per Story, on a four-to-eight-hour week, and it cannot be bought any other
  way. The trade is taken because the grill sits before any code exists, which is where that
  attention has the most leverage: an answer given here costs a sentence, and the same answer at
  review costs the delta, the tests and the implementer's run.
- **`docs/process.md`'s "Every stage is entered by the conductor ... it executes no stage itself"
  becomes false, and is reworded.** What survives, and what keeps ADR-1002 intact, is that the
  conductor executes no stage's *output*. The boundary is the one drawn in the decision above,
  by object: it holds the question tree, never the artifact, and it dispatches an agent for every
  fact. If a grill ever has the conductor reasoning about requirements to keep the questions
  intelligible, that is the signal this was the wrong shape.
- **The worktree is cut before the grill rather than by `spec-author`.** `grill.md` needs
  somewhere to live, rule 8 forbids a checkout, and a grill that runs before the worktree exists
  has nowhere to put its answers. Stage 4's first keystroke is therefore `git worktree add`, and
  `pnpm run status` prints it.
- **The change folder is created by the grill, not by `/opsx:propose`.** `openspec new change`
  exits 1 against a directory that already exists, so the moment the grill started leaving
  `grill.md` behind, `spec-author`'s first command would have failed on every Story. The grill
  runs `openspec new change <change-id>` at its close and `spec-author` enters `/opsx:propose`
  at the artifact build order instead. Scaffolding with the CLI rather than `mkdir` is what
  keeps `.openspec.yaml`, which records the schema and is where `skip_specs` would go. Found by
  audit on 2026-09-04, after this decision had been written down but before it was ever run.
- **`grill.md` is inside what G4 signs.** The digest covers every file in the change folder but
  `tasks.md` (ADR-1007), and nothing there is file-specific, so this fell out rather than being
  designed. It is the right answer: the human approves the answers the delta was written on, and
  rewriting the grill after approval costs a second one, exactly as rewriting the delta does.
- **The answers survive a session boundary, because they are a file.** That is why they travel in
  `grill.md` rather than in the spawn prompt: `atlas.md`'s "hand it the issue number and nothing
  else" survives unchanged, `AGENTS.md` § *Context discipline* is honoured on both sides, and a
  session that dies between the grill and the propose loses nothing that was settled.
- **A required place to say "I decided this on your behalf" still exists, and there are now two.**
  `grill.md` § *Left open* is the first and `design.md`'s residual round is the second. The
  failure this removes is unchanged: a product decision arriving inside `## Decisions` prose,
  correct and well-argued, where a human reading at G4 sees an argument rather than a question.
- **Nothing enforces that the grill happened, or that it asked well.** `pnpm run status` can see
  that `grill.md` exists and that `## Left open` is non-empty; it cannot see the interview, and a
  file with two shallow questions in it passes every check a file with twelve good ones passes.
  Worse, **a grill in progress is not observable on disk at all**, because `grill.md` is written
  at the end — a session that stops mid-interview leaves its answers in a transcript, which is
  exactly what `AGENTS.md` § *Context discipline* says is not a durable file. This is the same
  trade ADR-1005 and ADR-0010 make and it is worth stating rather than implying: the artifact is
  checkable, the judgement is not.
- **It is one more thing that can turn into a gate.** ADR-1002 named that risk about
  `pnpm run status` and the test applies here unchanged: if the grill or the residual round ever
  grows a marker, a check, or a `G` number, it has become the sixth gate this decision was shaped
  to avoid.

## Alternatives considered

**Leave it at G4 and rely on `changes: <what>`.** The existing reply vocabulary already lets the
human reject a decision, and #9 proves an agent can flag one well without a mechanism. Rejected
because the flag was optional and its placement was the agent's choice: buried in
`## Decisions`, a proposed product decision reads as a settled one, and G4's question — *"are
these the right requirements?"* — is not the same question as *"this one was mine to make and
an agent made it."*

**A separate grill session, handed off before the propose session.** This is substantially the
decision now taken, and the entry is kept because what it got right and what it got wrong are
both instructive. It was right that only a top-level session can ask, right that this is the
consequence of ADR-1002 rather than a defect in any agent, and right about the tension it named:
the conductor is forbidden work context, and an open-ended grill *is* work context. Its rejection
rested on two costs — a session start, on a process whose scarcest input is the owner's
attention, and the loss of the human reading the question next to the delta it would change. The
shape now taken pays both. There is no extra session, because the conductor is already in the
loop and already talking to the human, so the grill costs a step rather than a boundary. And the
read-next-to-the-diff case is preserved for the questions that actually need it, which are the
ones that only appear while the delta is being phrased: that is the residual round. The tension
with ADR-1002 is real and is settled by object, not by relay — the question tree is context the
conductor may hold; the delta is not.

**Ask before writing the change folder.** Rejected on two counts when this record was first
written, and both have since been paid, so it is now what happens. The first was that
`pnpm run status` derives the stage from the change folder, so a Story with questions and no
folder is indistinguishable from one that has not started — which does not bite when the grill is
synchronous and the human is in the room for it, and `grill.md` lands in the folder at the end
regardless. The second was losing the question read next to the diff, and the residual round
keeps that for the case it was actually about. What the original entry was right about is that
this ordering does work on an answer that may be overturned; what it missed is that the reverse
ordering leans the answer.

**Keep the grill in `spec-author` and loop the relay** — spawn, return a round, relay it, respawn
with the answers, return round two, and so on until the frontier is empty. This is the smallest
change that gets the loop back, and it keeps the interview inside an agent where the work is.
Rejected because every round costs a subagent spawn and a full context rebuild: the agent re-reads
the issue, `CONTEXT.md`, the Feature and the capability spec to ask its second question. That
buys the latency of asynchronous mail with the presence cost of a conversation and reads as
neither — the human waits between questions that arrive as if in a chat, and the process pays for
a fresh context per question. An interview is cheap only when the interviewer is still holding
what was just said.
