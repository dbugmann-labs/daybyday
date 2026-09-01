---
name: grill
description: Interrogate a plan, a Feature idea or a Story until nothing is silently assumed, and land the vocabulary that comes out of it. Use for the Feature grill at Stage 1 and the Story grill inside Stage 4.
---

# Grill

This repository grills twice and the two ask different questions, but they ask them the same
way. This is the one skill both use. `docs/process.md` § *The two grills* says which is which;
`AGENTS.md` is binding over everything here.

**Why this exists rather than `grill-with-docs`.** That skill declares
`disable-model-invocation: true`, so no agent can invoke it and no subagent can ask a human to
type it — which made it unreachable at exactly the step that needs it most. Its body is two
Skill calls, both of them reachable. This skill makes those calls, adds what this repository
requires on top, and splits the one behaviour a subagent cannot have. ADR-1009.

## Step 1 — invoke both underlying skills

Call the `Skill` tool twice:

- `mattpocock-skills:grilling` — the design-tree protocol: work the **frontier** in rounds, and
  give every question a recommended answer.
- `mattpocock-skills:domain-modeling` — what turns settled words into `CONTEXT.md` entries and
  hard decisions into ADRs.

Follow `grilling`'s protocol, with one exception, in step 2.

## Step 2 — the rounds, and who you are

`grilling` says to ask a round and wait for the user's answers. **Whether you can wait depends
on which session you are, and getting this wrong is the failure this skill exists to prevent.**

**If you are the conductor** — the session talking to the human, running `/atlas` — ask the
round and wait. That is the Stage 1 Feature grill: one capability or several, what the slug is,
which Epic it hangs under, what it deliberately does not cover, which words enter `CONTEXT.md`.
Present it in the standard five-part form from `.claude/commands/atlas.md` § *The question
round*. Ask the questions whose answers would change the work; do not ask four when one decides
it.

**If you are a subagent** — `spec-author` at Stage 4, or anyone else — **you cannot wait, so do
not try.** No subagent holds `AskUserQuestion`; it runs to completion and returns one report.
Instead of blocking, write the round into `design.md` under `## Questions for you`, numbered,
each entry carrying the question, the answer you recommend, and what changes in the delta if it
goes the other way. Then finish the work on your recommended answers and hand back. The
conductor relays it. ADR-1006, and `.claude/agents/spec-author.md` step 2 has the format.

Do not raise a round for something you could find out. **Finding facts is your job, never the
human's** — read the spec, check the environment, measure it. Only a preference they hold, whose
answer would change the delta, is theirs. A question that reaches the human and turns out to be
a fact is a finding about the agent.

## Step 3 — what must come out, whoever you are

Three things, none optional:

1. **`## Open Questions` in `design.md` is filled in.** `"None."` is a valid and required
   answer — say why. A question left open becomes a scenario someone invents later. (Stage 4
   only; a Stage 1 grill has no `design.md` yet, and its output is the Feature issue.)
2. **Every new domain term lands in `CONTEXT.md`**, one entry per thing. This is what
   `domain-modeling` is for, and it is why `CONTEXT.md` names this skill as its maintainer.
3. **A decision that was hard, expensive to reverse, or surprising gets an ADR** under
   `docs/adr/`, numbered from 1009 up. `docs/adr/README.md` carries the numbering and
   immutability rules.

## Where you stop

`grilling` says the session is done when the frontier is empty. Here that means: at Stage 1, you
have one capability you can name in a sentence and stop at G1; at Stage 4, `design.md` leaves
nothing open, and any round you raised is written down rather than guessed.

You do not approve anything. G1 and G4 are the human's.
