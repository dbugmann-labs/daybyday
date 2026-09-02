# 1016. The fourth model tier is withdrawn; `spec-author` returns to Opus

- Status: accepted
- Date: 2026-09-02
- Deciders: Diego Bugmann

Supersedes ADR-1011 in full, which restores the routing rule of ADR-0006 — the sentence ADR-1011
had replaced. Everything else in ADR-0006 was never touched by either record and still holds. Per
`docs/adr/README.md`, ADR-1011 keeps its file and is not edited.

## Context

ADR-1011 was accepted on 2026-09-02 and withdrawn the same day, before any change folder had been
written under it.

It priced the tier honestly and the price is what withdrew it. Claude Fable 5.1 is $10 / $50 per
million input / output tokens against Claude Opus 5's $5 / $25 — re-checked on 2026-09-02 against
the current model table and unchanged since ADR-1011 quoted it. That is 2× per token on Stage 4 of
every Story, paid on every proposal, every grill turn and every question round the stage runs.

The trial ADR-1011 designed was sound and it was not cheap. Its evidence — fewer `## Questions for
you` rounds bounced back, fewer second approvals bought by editing the folder after signing, fewer
G7 findings on the spec axis — is only readable across several Stories, so the tier had to be paid
for over several Stories before it could be judged. The owner's decision is that the doubled rate
is not worth paying to find that out on a repo worked 4–8 hours a week.

**This is a price decision, not a verdict on the model.** No change folder has been read and judged
as better or worse for having been written on Fable, and nothing here should be cited as evidence
that the tier does not work. It was withdrawn before it was measured.

## Decision

The routing rule reverts to ADR-0006's, unchanged. Stated once, in full:

> Model tier follows whether the task creates, judges, or merely executes requirements. Creating
> or judging → **Opus**. Executing an approved, written-down plan → **Sonnet**. Mechanical work
> whose correctness is visible in the diff → **Haiku**.

**`spec-author` returns to `model: opus`.** It was the only agent that moved, so it is the only
one that moves back, and no agent in this repo is routed to Fable.

**The recommendation to run the conductor on Fable for Stages 1 and 2 goes with it.** Nothing in
the repo ever recorded that choice — the conductor has no definition file to carry a model — so
what is removed is the sentence in `AGENTS.md`, not a setting. The human can still start a session
on any model; the process no longer suggests spending the tier there.

**`effort` stays unset.** ADR-1011 named `effort: max` on Opus as its own successor, and this
record deliberately does not take it: that answers a different question — whether Stage 4 is
under-resourced — and taking it in the same commit as the withdrawal would leave the two changes
tangled exactly as ADR-1011 refused to tangle them. It remains one line in
`.claude/agents/spec-author.md` whenever the question is worth asking.

## Consequences

- **Stage 4 runs on Opus again and nothing else in the pipeline moves.** ADR-1011 claimed the
  change was one frontmatter line to reverse; this record is the demonstration, and the rest of the
  reversal is three documents and this file.
- **The observation ADR-1011 made is still true and is now unaddressed.** Stage 4 remains the one
  step nothing downstream re-examines: G4 signs a digest, the implementer takes one scenario at a
  time, the reviewer's spec axis checks the code against the delta rather than the delta against
  reality, and the archive writes it into `openspec/specs/`. Withdrawing the tier withdraws the
  answer, not the question. If a bad requirement does reach the archive, `effort` is the cheap knob
  and this is the record to supersede.
- **The register now carries a decision and its reversal hours apart, and that is the register
  working.** Someone who later wonders whether Fable was ever considered can read ADR-1011's
  argument, its price and its exit rather than guessing from a commit.
- **Nothing enforces this.** Model routing is frontmatter and prose; no check in this repo reads
  either. A future agent definition could be written on any tier the CLI accepts, and only review
  would catch it.

## Alternatives considered

**Run the trial anyway and decide on evidence.** The rigorous option, and the one ADR-1011 designed
for. Rejected on price: the evidence costs several Stories at 2× on Stage 4 to collect, and the
owner does not want to spend it. That is a legitimate reason to stop a trial and it is recorded as
the actual one.

**Take ADR-1011's named successor and set `effort: max` on Opus in the same commit.** Rejected for
this change, not on principle — see the Decision. Withdrawing the tier and raising effort together
would move two variables at once, which is the mistake ADR-1011 avoided by leaving `effort` unset.

**Revert the commit whole and delete ADR-1011.** The tidiest diff, and forbidden:
`docs/adr/README.md` makes accepted ADRs immutable and requires a reversal to be a new record.
Deleting it would also destroy the price and the argument, which are the two things a future
proposal of the same idea needs.

**Keep the tier for the conductor's Stages 1 and 2 only.** There is nothing to keep: that was never
a setting, only a suggestion in prose. The suggestion goes because it recommends the same spend at
the stage where the human is sitting there waiting for it.
