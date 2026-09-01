# 1009. One grill skill, owned by this repo, wrapping the flagged one

- Status: accepted
- Date: 2026-09-01
- Deciders: Diego Bugmann

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
skill knows: this repository's three non-optional outputs (`## Open Questions` filled in, new
terms in `CONTEXT.md`, an ADR for a hard decision), and a branch on who is running it — the
conductor asks a round and waits; a subagent writes `## Questions for you` into `design.md` and
hands back.

This is a third option ADR-0009 did not consider: neither installing whole and living with the
gap, nor forking. Wrap the flagged skill in one this repo owns.

## Consequences

- One name for both grills. The human types `/grill`; `spec-author` invokes `Skill("grill")`.
- **The branch is the real gain.** `grill-with-docs` would have told `spec-author` to block on a
  human it cannot reach. A skill that cannot express "you are a subagent, write instead of
  waiting" is the wrong skill for half of this pipeline, flag or no flag.
- No fork and no vendoring, so ADR-0009's decision stands unchanged: the plugin is still
  installed whole and updates are still one command. `grill` depends on `grilling` and
  `domain-modeling` by name; if a plugin update flags or renames either, `grill` breaks loudly
  at invocation rather than silently doing nothing, which is the failure mode it replaces.
- The generalisation is available but not yet taken: any other flagged skill the process needs
  can be wrapped the same way. `to-tickets` is the obvious candidate and is deliberately left
  alone — it produces issue bodies, which is exactly the surface rule 4 governs, so a human
  typing it and the conductor relaying the result is a feature.
- `grill-with-docs` stays on the "only the human can type" list in `AGENTS.md`. It is still
  there, still typable, and now redundant.

## Alternatives considered

**Vendor `grill-with-docs` with the flag stripped.** Forks the plugin for one line, drifts on
`claude plugin update`, and still would not carry the subagent branch. Rejected — and ADR-0009
already rejected forking for a stronger reason.

**Name the wrapper `grill-with-docs` so the docs need no change.** A project skill shadowing a
plugin skill of the same name reintroduces the ambiguity that made `/code-review` resolve to
Claude Code's built-in review instead of the intended one. Rejected: the collision is the bug.

**Leave Stage 4's grill as prose in `spec-author.md`.** That is the status quo, and it is what
produced a documented step nobody could run.
