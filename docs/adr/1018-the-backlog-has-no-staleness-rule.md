# 1018. The backlog has no staleness rule; a want waits without going bad

- Status: accepted
- Date: 2026-09-03
- Deciders: Diego Bugmann

Supersedes the **staleness rule** of ADR-1010. That ADR's diagnosis of the parking lot, its
admission rule, its exit rule and the two commands it introduced are untouched and still hold;
only the sentence forcing a choice on an entry that has sat through two grooming passes is
withdrawn. Per `docs/adr/README.md`, ADR-1010 keeps its file and is not edited.

## Context

ADR-1010 inherited the parking lot's staleness rule — an entry that has sat through two rounds
should be promoted or deleted — and made it enforceable for the first time by writing down when
a grooming pass happened. `scripts/lib/backlog.ts` counted the passes dated after a want's
capture, and `pnpm run status` put anything at two or more in `▸ WAITING ON YOU`.

It fired for the first time on 2026-09-03, on seven of fifteen wants at once, and the count was
measuring the wrong thing.

**A pass takes exactly one cluster forward.** That is `/atlas backlog`'s design and it is right
for a four-to-eight-hour week: sweep, cluster, propose a disposition for each, grill the one
cluster the human picks, stop at G1. Every want outside that cluster therefore survives the pass
by construction. The counter was reading a throughput limit as neglect, and it read it the same
way whether the want was blocked on a dependency — B-007 and B-011 both wait on a store that did
not exist until #56 — or genuinely unasked-for, which in this backlog was true of exactly one
entry. Both grooming passes had already written down which, in prose, in their *Not taken*
dispositions; the counter ignored all of it and counted days.

The wording had drifted from the code as well. The rule said "survived two grooming passes
**untouched**", and the seven entries it fired on were precisely the ones the first pass had
touched — Principle lines written, braindump quotes folded in, the same day. The parser had no
notion of touched at all.

What follows from firing on seven wants at once is not seven decisions. It is one of two
outcomes: good wants dropped to satisfy a counter, or — far more likely — the line kept and the
banner ignored, and after two rounds of that `▸ WAITING ON YOU` is noise. That is the parking
lot's own failure, reproduced one level up, which is the thing ADR-1010 exists to prevent.

## Decision

**There is no staleness rule.** A want sits in `docs/backlog.md` until a grooming pass promotes,
merges or drops it, and sitting there costs it nothing. No count of passes survived, no forced
choice, no promote-or-drop.

**`pnpm run status` never puts a want in `▸ WAITING ON YOU`.** It reports how many wants there
are, how many have been decided, when the last pass ran and what has been captured since, and
then prints `/atlas backlog`. What is *owed* is a gate, and gates come from the tracker above.
The backlog is a queue the human draws from at their own rate.

**The *Grooming passes* log stays, and so does the rule that every pass appends a line.** It was
never only a counter: it is where a pass records what its sweep found and which clusters it
declined, with reasons, and both `/atlas backlog` and `/to-tickets` read that to start from the
last pass's reasoning rather than from the wants alone.

**The judgement the rule was reaching for stays with the human, in prose.** A pass that declines
a cluster says why — blocked on a named issue, or nothing asks for it — and a want declined
twice for the second reason is a drop worth proposing. That is a recommendation a pass makes,
not a threshold a script computes.

## Consequences

- **Nothing in the repo computes a want's age.** `Want.survived` and `Backlog.stale` are gone
  from `scripts/lib/backlog.ts`; `renderBacklog` no longer takes the `waiting` array, so no code
  path exists for the backlog to write into it.
- **The graveyard risk comes back, and is accepted knowingly.** The protection is now that
  `pnpm run status` prints the backlog on every session that starts off a story branch, and that
  the sweep opens the file every pass. Both were what actually fixed the parking lot; the
  counter never got the chance to.
- **The reversal trigger is a real graveyard, not a number.** If a pass finds itself carrying
  wants it can neither promote nor argue against, the answer to reach for is a rule that counts
  *declined for the same reason twice*, using the dispositions the pass already writes — not
  this one restored.
- **`/atlas backlog` loses a step and gains nothing.** Its step 2 no longer forces a choice on
  anything; the clustering rules above it are unchanged.
