# 1011. Fable is a fourth model tier, and `spec-author` is the only agent that takes it

- Status: accepted
- Date: 2026-09-02
- Deciders: Diego Bugmann

Supersedes the **routing rule** of ADR-0006. That ADR's write-permission matrix and its
non-delegable-configuration rule are untouched and still hold; only the sentence assigning a
model tier to a verb is replaced. Per `docs/adr/README.md`, ADR-0006 keeps its file and is not
edited.

## Context

ADR-0006 fixed the routing rule on 2026-08-22: creating or judging requirements uses Opus,
executing an approved plan uses Sonnet, mechanical work whose correctness is visible in the diff
uses Haiku. Three tiers, because three were what existed to route to. Claude Fable is a fourth,
above Opus, and the question this record answers is whether the rule gains a row or stays as it
is.

**It is routable here without a wrapper.** Verified 2026-09-02 against Claude Code 2.1.258, from
the CLI's own frontmatter schema and `--help`: an agent definition's `model:` accepts
`haiku`, `sonnet`, `opus`, `fable`, a full model ID, or `inherit`, and `--model fable` is a
session-level alias. Nothing about this decision needs new machinery.

**What the tier costs.** Claude Fable 5.1 is $10 / $50 per million input / output tokens against
Claude Opus 5's $5 / $25 — twice the price — on the same 1M context. The tier buys capability,
not room: a change folder does not fail today because the model ran out of context. Its thinking
is always on, its depth is set by effort rather than a token budget, and single turns on hard
work can run for minutes.

**What the pipeline is short of.** The human works 4–8 hours a week and is the only person in the
loop. The scarce resource is his attention at the four gates, not tokens and not wall-clock
between them, so a tier that thinks longer unattended is nearly free and a tier that thinks longer
while he waits is not.

## Decision

The routing rule gains a clause. Stated once, in full:

> Model tier follows whether the task creates, judges, or merely executes requirements. Creating
> or judging → **Opus**. Executing an approved, written-down plan → **Sonnet**. Mechanical work
> whose correctness is visible in the diff → **Haiku**. Where creating a requirement is the step
> that is *ratified rather than checked* — Stage 4 — → **Fable**.

The fourth tier splits the first verb on one property: how expensive a wrong requirement is to
unwind. It is not "the hardest work gets the best model". It is "the work no later step
re-examines gets the best model".

**`spec-author` moves to Fable.** It is the only agent that does. Nothing else in the matrix
changes, and the permission column changes nowhere.

**The conductor may be run on Fable for Stages 1 and 2**, by the human, per session
(`claude --model fable`, or `/model fable` and back). That is a judgement call at the top of a
Feature, not a setting, and nothing in the repo records it — the conductor has no definition file
to carry a model, which is ADR-1002's whole point.

**`reviewer` stays on Opus.** Escalating a particular review is done by re-running it in a Fable
session, not by changing its frontmatter.

**`implementer`, `janitor` and `orchestrator` never take it.**

### Why Stage 4 and not the Stage 1 grill

The grill at Feature definition has more leverage in principle: a missed assumption there
propagates into every Story underneath it. Two things put Stage 4 first anyway.

**Stage 4's output is ratified, not checked.** G4 signs a digest of the change folder (ADR-1007),
and from that moment every downstream step is faithful to it by design: the implementer takes one
`#### Scenario:` at a time and makes it pass (rule 3), and the reviewer's spec axis asks whether
the code matches the delta — not whether the delta matches reality. The delta then merges into
`openspec/specs/`, which nothing may hand-edit (rule 2). A wrong requirement written at Stage 4 is
not caught later; it is implemented correctly, reviewed as correct, and archived as the truth. No
other artefact in the pipeline has that property.

**Stage 4 runs unattended and Stage 1 does not.** Between G2 and G4 nobody is waiting, so
multi-minute turns cost nothing and buy thoroughness. The grill is the interactive stretch, where
the same turns are paid in the human sitting there, at the one stage where his attention is the
binding constraint. So Stage 1 is where he may spend the tier deliberately; Stage 4 is where the
repo spends it by default.

**And Stage 4 is where the tier is falsifiable.** Its whole output is a diff read at one gate.
Fewer `## Questions for you` rounds bounced back, fewer second approvals bought by editing the
folder after signing, fewer G7 findings on the spec axis — those are countable. "The grill felt
sharper" is not.

## Consequences

- One stage per Story pays 2× per token. Nothing else moves, and the change is one frontmatter
  line to reverse.
- **Fable is documented as losing quality on prompts written prescriptively for earlier models,
  and `AGENTS.md` plus `.claude/agents/spec-author.md` are prescriptive by design.** They are left
  exactly as they are. The rules there are constraints, not style, and loosening them to suit a
  model is how a process starts serving its tools. But if change folders get *worse* rather than
  better, the prompt is the first suspect and the tier is the second.
- **Only one variable moved.** The agent schema also accepts `effort` (see the alternatives), and
  it is deliberately not set at the same time, so the next few change folders measure the tier and
  nothing else.
- This does not touch the failure mode `docs/retrospective.md` §5 records. Four documented commands
  that could never have worked were all written from memory; a more capable model that still does
  not run the command produces the same wrong line. Verify-do-not-remember is unaffected by
  routing.
- The alias set is a property of the CLI, not of this repo. A `model: fable` that stops resolving
  is a Claude Code change, and the check is the frontmatter schema in the installed version, not
  this file.

## Alternatives considered

**Raise `effort` on Opus instead of changing tier.** Verified 2026-09-02 in the same schema: an
agent definition accepts `effort: low | medium | high | max`, or an integer. This is the cheaper
knob and it is genuinely available, which is why it is recorded here rather than dismissed —
Opus at `max` may well close most of the gap at half the price. It is not chosen *first* because
it does not answer the question the tier does: whether a more capable model writes a materially
better delta. Turning both at once would answer neither. If the tier does not visibly pay for
itself over the next few Stories, dropping back to Opus at `max` is the successor decision, and
it is one line in the same file.

**Fable everywhere that judges — `spec-author`, `reviewer`, and the conductor by default.**
Doubles the token price of every stage the human reads, to improve steps whose errors are
recoverable: the reviewer writes nothing and its findings are judged at G7, and a conductor
mistake surfaces at the next gate. Buy the irreversible step first, measure, then decide.
Rejected for now, not on principle.

**No fourth tier.** ADR-0006's rule is clean and three tiers are easy to hold in your head, and
that is worth something real. But the rule was written when three tiers were all there were, and
"the step nothing downstream re-examines" is a distinction the pipeline already makes everywhere
else — G4 is a hard gate precisely because of it. Rejected: the rule was under-specified rather
than complete.

**Single model for everything.** Already rejected by ADR-0006, and a fourth tier makes it worse,
not better.
