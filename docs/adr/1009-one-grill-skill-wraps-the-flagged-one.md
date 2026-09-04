# 1009. One grill skill, owned by this repo, wrapping the flagged one

- Status: accepted
- Date: 2026-09-01
- Deciders: Diego Bugmann
- Amended: 2026-09-04 — the skill no longer branches on who is running it. Both grills are the
  conductor's, and `grill` now tells a subagent that finds itself invoking it to stop and read
  the `grill.md` the interview left. The reason for owning the wrapper is unchanged and still
  load-bearing: `grill-with-docs` is flagged, so no agent can invoke it and no subagent can ask
  a human to type it. ADR-1006.

## Context

This process grills twice — the Feature grill at Stage 1 and the Story grill inside Stage 4
(ADR-1005) — and both were documented as running `grill-with-docs`. Neither did.

`grill-with-docs` declares `disable-model-invocation: true`. `spec-author`, which owns the Stage
4 grill, is a subagent: it cannot invoke a flagged skill, and it cannot ask the human to type one
either, because no subagent holds `AskUserQuestion` (ADR-1002). So `.claude/agents/spec-author.md`
carried an instruction that could never be followed, and the grill happened — when it happened —
only as prose in that file. `.claude/commands/atlas.md` had told the conductor to grill the
Feature "yourself", with no skill at all, so the two grills shared no protocol whatsoever.

ADR-0009 weighed exactly two options for a skill this repo cannot invoke as shipped: install
whole, or fork. It concluded the flags "happen to be exactly right", which was true of the four
skills on the kill list and false of the fifth the process depended on.

Two further facts came out of auditing it. `grill-with-docs` is not a grill; its entire body is
*"Call the Skill tool twice, for `grilling` and `domain-modeling`."* Both of those are
model-invocable. And the protocol in `grilling` says to ask a round and **wait for the user's
answers** — which is correct for the conductor and impossible for `spec-author`, whose answer to
the same situation is ADR-1006's written question round.

## Decision

Add **`grill`**, a skill owned by this repository at `.claude/skills/grill/SKILL.md`, with no
`disable-model-invocation` flag. Both grills run through it, and nothing routes to
`grill-with-docs` any more.

It makes the same two Skill calls `grill-with-docs` makes, then adds what neither underlying
skill knows. That is this repository's three non-optional outputs — the questions and their
answers written to a durable file, which at Stage 4 is `grill.md` in the change folder; new terms
in `CONTEXT.md`; an ADR for a decision that was hard, expensive to reverse or surprising — and
the two rules this repository had previously got wrong, that a round asks the whole frontier
rather than the most important question, and that it is never wrapped in a five-part block. How
a round is *put* — `AskUserQuestion`, not markdown — was settled later, on 2026-09-04; ADR-1012.

**It does not branch on who is running it.** Both grills are the conductor's, so the only thing
the skill has to say to a subagent is *you are in the wrong place, stop*: the interview happened
before you were spawned, `grill.md` is what it left you, and writing the delta on those answers
is your job. `.claude/skills/grill/SKILL.md` is the normative text.

This is a third option ADR-0009 did not consider: neither installing whole and living with the
gap, nor forking. Wrap the flagged skill in one this repo owns.

## Consequences

- One name for both grills, and one caller: the conductor invokes `Skill("grill")` for the
  Feature grill at Stage 1 and the Story grill at the top of Stage 4. `spec-author` no longer
  invokes it at all.
- **The branch was a correct workaround for a boundary that should not have been crossed.** It
  was right about the immediate problem — `grill-with-docs` would have told `spec-author` to
  block on a human it cannot reach, and the branch let it do something useful instead of
  hanging. But the useful thing it did was write a questionnaire. `grilling` is a loop, a
  subagent cannot wait, so the loop ran exactly once and the design tree never got past depth
  one. The answer was never a better branch; it was that the interview does not belong inside a
  subagent at all. ADR-1006 moved it out, and the gain this record claimed here went with it.
- **The gain that survives is this one.** No fork and no vendoring, so ADR-0009's decision
  stands unchanged: the plugin is still installed whole and updates are still one command.
  `grill` depends on `grilling` and `domain-modeling` by name; if a plugin update flags or
  renames either, `grill` breaks loudly at invocation rather than silently doing nothing, which
  is the failure mode it replaces.
- The generalisation is available but not yet taken: any other flagged skill the process needs
  can be wrapped the same way. `to-tickets` is the obvious candidate and is deliberately left
  alone — it produces issue bodies, which is exactly the surface rule 4 governs, so a human
  typing it and the conductor relaying the result is a feature.
- `grill-with-docs` stays on the "only the human can type" list in `AGENTS.md`. It is still
  there, still typable, and now redundant.

## Alternatives considered

**Vendor `grill-with-docs` with the flag stripped.** Forks the plugin for one line, drifts on
`claude plugin update`, and still would not carry this repository's outputs or its round rules.
Rejected — and ADR-0009
already rejected forking for a stronger reason.

**Name the wrapper `grill-with-docs` so the docs need no change.** A project skill shadowing a
plugin skill of the same name reintroduces the ambiguity that made `/code-review` resolve to
Claude Code's built-in review instead of the intended one. Rejected: the collision is the bug.

**Leave Stage 4's grill as prose in `spec-author.md`.** That is the status quo, and it is what
produced a documented step nobody could run.
