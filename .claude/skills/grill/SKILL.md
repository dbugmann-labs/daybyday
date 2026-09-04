---
name: grill
description: Interrogate a plan, a Feature idea or a Story until nothing is silently assumed, and land the vocabulary that comes out of it. Use for the Feature grill at Stage 1 and the Story grill at the top of Stage 4.
---

# Grill

This repository grills twice and the two ask different questions, but they ask them the same way
and **the conductor runs both**. This is the one skill they use. `docs/process.md` § *The two
grills* says which is which; `AGENTS.md` is binding over everything here.

**Why this exists rather than `grill-with-docs`.** That skill declares
`disable-model-invocation: true`, so no agent can invoke it and no subagent can ask a human to
type it — which made it unreachable at exactly the step that needs it most. Its body is two
Skill calls, both of them reachable. This skill makes those calls and adds what this repository
requires on top. ADR-1009.

## Step 1 — invoke both underlying skills

Call the `Skill` tool twice:

- `mattpocock-skills:grilling` — the design-tree protocol: work the **frontier** in rounds, and
  give every question a recommended answer.
- `mattpocock-skills:domain-modeling` — what turns settled words into `CONTEXT.md` entries and
  hard decisions into ADRs.

Then follow `grilling`'s protocol as written. **The rounds are the point of it**, and the two
places this repository used to bend them are the two failures it now avoids — see step 3.

## Step 2 — check you are the conductor

**A grill is an interview, and only the conductor can hold one.** No subagent holds
`AskUserQuestion`: it runs to completion and returns one report, so a grill inside one collapses
to a single non-blocking pass and every question that the human's answers would have unblocked
goes unasked. That is the harness, not something an agent can work around. ADR-1002, ADR-1006.

So:

- **If you are the conductor** — the session talking to the human, running `/atlas` — grill.
  `.claude/commands/atlas.md` § *The Story grill* and § *Intake* carry the two procedures, and
  § *The round* carries the shape.
- **If you are a subagent, you are in the wrong place.** Stop and say so rather than writing a
  round nobody asked for. The Story grill happens at the top of Stage 4, before `spec-author` is
  spawned, and `grill.md` in the change folder is what it left you: read it, and write the delta
  on the answers it holds. The one thing that is still yours is the **residual round** — a
  question that only became visible while you were writing the delta — and that is
  `.claude/agents/spec-author.md` step 2, not this skill.

## Step 3 — the two rules this repository adds

**Ask the whole frontier.** `AGENTS.md` § *The conductor* says **"a gate carries one decision, so
do not ask four things when one decides it"**, and says in the same breath that this is a rule
about gates and only about gates. **It does not apply here.** A grill exists to reach the fourth
question, and the round that asks only the most important one is the questionnaire this skill was
rewritten to stop producing. If four questions are ready, ask four.

**Ask the round with `AskUserQuestion`, never inside a five-part gate block.** That block carries
one question under a ten-line budget, so wrapping an interview in it forces exactly the questions
worth asking to be dropped; a five-part block asks for a decision, a round asks for answers.
`grilling`'s format — `❓`, `➡️`, a rule between questions — is how you compose the round; the
picker is how you ask it, and it is the tool that made the grill the conductor's in the first
place, since no subagent holds it. The recommendation is the first option, marked
`(Recommended)`. **The tool's four-question cap is split across consecutive calls and never
allowed to shrink a round.** Printing the markdown as well is allowed and never required.
`.claude/commands/atlas.md` § *The round* has the rest. ADR-1012.

Both of these were the repository's own additions and both were wrong. They are written down
here so the next person to tidy this skill does not reinstate them.

## Step 4 — what must come out

Three things, none optional:

1. **The questions and their answers are written to a file**, because a conversation is not a
   durable file and `AGENTS.md` § *Context discipline* binds here too. At Stage 4 that is
   `grill.md` in the change folder, whose shape is in `.claude/commands/atlas.md` § *The Story
   grill*; it carries `## Settled`, `## Terms landed in CONTEXT.md`, and a `## Left open` section
   where `None.` is valid and required, with the reason. At Stage 1 there is no change folder yet and the
   output is the Feature issue plus the `CONTEXT.md` terms.

   **The asymmetry is deliberate, not an omission.** The Stage 4 grill needs a file because its
   reader is a subagent that will be spawned cold and can be handed nothing but an issue number.
   The Stage 1 grill's readers are the human typing `/to-tickets` and `orchestrator` writing the
   issue, and what it settled lands in two durable places they both read — the Feature issue's
   scope and `CONTEXT.md`. Do not invent a second file to make the two look alike.
2. **Every new domain term lands in `CONTEXT.md`**, one entry per thing. This is what
   `domain-modeling` is for, and it is why `CONTEXT.md` names this skill as its maintainer.
3. **A decision that was hard, expensive to reverse, or surprising gets an ADR** under
   `docs/adr/`. `docs/adr/README.md` carries the numbering rule — DayByDay's own start at 1001,
   numbers are never reused and gaps are normal — and the amendment rule: a decision that changes
   is edited into the file that holds it, not superseded by a new one.

**Finding facts is your job, never the human's** — read the spec, check the environment, measure
it, or dispatch an agent to. Only a preference they hold, whose answer would change the work, is
theirs. A question that reaches the human and turns out to have had an answer on disk is a
finding about you, and it does not block the rest of the frontier while you look it up.

## Where you stop

`grilling` says the session is done when the frontier is empty. Here that means: at Stage 1, you
have one capability you can name in a sentence, and you stop at G1. At Stage 4, `grill.md` leaves
nothing open, and you hand to `spec-author`.

You do not approve anything. G1 and G4 are the human's.
