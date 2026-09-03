# 1010. A groomed backlog replaces the parking lot

- Status: accepted
- Date: 2026-09-02
- Deciders: Diego Bugmann
- Amended: 2026-09-03 — the staleness rule inherited from the parking lot is withdrawn: a want
  waits without going bad, nothing counts the passes it has survived, and `pnpm run status` never
  calls one overdue. The diagnosis, the split, the admission rule and the two commands are
  unchanged.

## Context

`docs/parking-lot.md` was the one artifact upstream of Stage 0: the holding pen between "someone
said it" and "it is agreed", with a stated exit rule — an entry leaves in exactly one direction,
promoted into an Epic or Feature issue and deleted — and a stated staleness rule: an entry that
has sat through two rounds of Epic intake should be promoted or deleted.

Neither rule ever ran. **No command opened the file.** `/atlas feature <idea>` mentioned it in
passing, as one of three things to check an idea against; nothing enumerated its entries, nothing
proposed a promotion, and nothing could observe that an entry had survived two rounds, because
nothing recorded that a round had happened. The exit rule was a sentence, and the file was
append-only in practice.

The second failure is what the file was allowed to hold. Four unlike things accumulated in it:
things the app should let you do; the principles those things are judged against ("nothing
congratulates you", the five-percent principle); open product questions ("does an unfinished
two-of-three vanish?"); and engineering deferrals (the missing UI smoke layer, SwiftData versus
GRDB, `DayOfMonth.day` being internal). Only the first is a backlog. Mixing the four is why the
file read as a graveyard rather than a list of work, and why nobody wanted to open it — which
closed the loop with the first failure.

The file's *content* was never the problem. Five archived `design.md` files and three ADRs cite
it as evidence of what the owner actually said, and the every-N-days change turned on an anchor
question the parking lot had been holding open since 2026-08-28. That is the thing worth keeping.

### And the staleness rule was carried over, made enforceable, and withdrawn

The parking lot's staleness rule came across into the first form of this decision, where it became
enforceable for the first time: `scripts/lib/backlog.ts` counted the grooming passes dated after a
want's capture, and `pnpm run status` put anything at two or more in `▸ WAITING ON YOU`.

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
lot's own failure, reproduced one level up, which is the thing this record exists to prevent.

## Decision

**Split the file by what a line is, and give each half a command that reads it.**

`docs/backlog.md` holds **wants** — one thing the app should let you do, in the owner's own
words, quoted rather than paraphrased — and a *Decided* ledger of every entry that has left.
`docs/open-questions.md` holds everything that is not a want: open product questions, open
technical decisions, and known gaps in what is built. `CONTEXT.md` gains a *Product principles*
section for the rules that judge a want rather than being one. `docs/parking-lot.md` becomes a
tombstone pointing at all three, because deleting it would break the archived citations and
archived change folders are immutable.

Two conductor commands read them:

- **`/atlas idea <whatever you say>`** captures one want. It reads the backlog, the *Decided*
  ledger, the capability specs and the open Features, then does exactly one of four things and
  says which: writes a new entry, folds the idea into an existing one, or reports that it is
  already a shipped requirement or already an entry. It asks **at most one** question, and only
  about which want it is — never about how it should work.
- **`/atlas backlog`** grooms. It clusters the wants by the capability they would land in,
  proposes a promotion, a merge, a split or a drop for each, then grills the cluster taken
  forward with the existing `grill` skill and stops at **G1**.

**There is no staleness rule.** A want sits in `docs/backlog.md` until a grooming pass promotes,
merges or drops it, and sitting there costs it nothing. No count of passes survived, no forced
choice, no promote-or-drop.

**`pnpm run status` never puts a want in `▸ WAITING ON YOU`.** It reports how many wants there
are, how many have been decided, when the last pass ran and what has been captured since, and
then prints `/atlas backlog`. What is *owed* is a gate, and gates come from the tracker above.
The backlog is a queue the human draws from at their own rate.

**The *Grooming passes* log stays, and so does the rule that every pass appends a line.** It is
not a counter: it is where a pass records what its sweep found and which clusters it declined,
with reasons, and both `/atlas backlog` and `/to-tickets` read that to start from the last pass's
reasoning rather than from the wants alone.

**The judgement a staleness rule reaches for stays with the human, in prose.** A pass that
declines a cluster says why — blocked on a named issue, or nothing asks for it — and a want
declined twice for the second reason is a drop worth proposing. That is a recommendation a pass
makes, not a threshold a script computes.

**Grooming adds one stop in front of Stage 1 and nothing else.** No new stage, no new gate, no
new number, and no second grill: `/atlas backlog` hands to the Stage 1 machinery that already
exists — G1, then `orchestrator`, then the `/to-tickets` breakdown and G2.

## Consequences

- **Nothing in the repo computes a want's age.** There is no `Want.survived` and no
  `Backlog.stale` in `scripts/lib/backlog.ts`, and `renderBacklog` takes no `waiting` array, so
  no code path exists for the backlog to write into one.
- **The graveyard risk the parking lot died of comes back, and is accepted knowingly.** The
  protection is that `pnpm run status` prints the backlog on every session that starts off a
  story branch, and that the sweep opens the file every pass. Both were what actually fixed the
  parking lot; a counter never got the chance to.
- **The reversal trigger is a real graveyard, not a number.** If a pass finds itself carrying
  wants it can neither promote nor argue against, the answer to reach for is a rule that counts
  *declined for the same reason twice*, using the dispositions the pass already writes — not a
  count of passes survived, which has been tried here and measured the wrong thing.
- **Capture is cheap on purpose, and grilling stays where it was.** Interrogating an idea at
  capture would spend rounds on wants that are about to be dropped, and would make the entry
  point one you avoid. The Feature grill at Stage 1 is still the first place a want is argued
  with, and it is unchanged.
- **The admission rule is now falsifiable.** "Is this a want?" has an answer; "is this parked?"
  did not. An item that is not a want has two named homes, so the pressure to put it in the
  backlog anyway is gone.
- **`main` is protected, so capture costs a branch.** The ruleset requires a pull request and
  two green checks, one of them a macOS runner, so one PR per one-line idea is disproportionate.
  Captures accumulate on a long-lived `chore/backlog` branch in its own worktree (rule 8) and the
  PR merges at the next grooming pass. The cost is that `docs/backlog.md` on `main` lags the
  branch between passes; the PR is the live view, which is the same arrangement ADR-1003 makes
  for a Story.
- **Verbatim quoting is a constraint on the agent, not a formatting preference.** The reason the
  parking lot was worth citing in five archived designs is that it recorded what was said, not a
  tidied version of it. An entry that paraphrases a want into spec wording has already made the
  decision the grill exists to make.
- **Three documents' worth of cross-references moved**, plus two Feature issue bodies that
  pointed open questions at the parking lot. Archived change folders were left alone.

## Alternatives considered

**Keep one file and fix the exit rule.** This is the status quo with better prose, and the exit
rule was already written down. Nothing in the previous arrangement failed for want of a clearer
sentence; it failed because no command opened the file. Rejected.

**Put the backlog on the tracker as untyped `needs-triage` issues.** Genuinely cheaper —
`docs/agents/triage-labels.md` already designates that state as the inbox for "an idea that
arrives before it has an Epic", it costs one API call instead of a branch, and it is visible on
a phone. Rejected because the want text would leave the repository: a cold `spec-author` reads
the repo and nothing else, and the archived designs that cite the parking lot cite a path, not
an issue. The friction saved is real; the evidence lost is worth more.

**Both, with the file canonical and an issue mirroring it.** Bidirectional bookkeeping between
the repo and GitHub, which `docs/process.md` §1 rejects by name as the highest-maintenance
component in a setup like this and the one that fails silently. Rejected on that precedent.

**A grooming gate, G0 or similar.** Grooming is a conversation whose output is a Feature the
human already approves at G1. A second gate over the same decision buys a number and costs a
stop. Rejected; it is a stop, exactly like the question round of ADR-1006.

**Keep the staleness rule and fix the counter — count *untouched* passes, as the wording said,
or exclude wants blocked on a named issue.** The version that was actually tried counted days and
called them neglect. A better counter is buildable, and it was rejected because the thing it would
compute is already written down in prose by every pass, in the *Not taken* dispositions, with the
reason attached. A threshold that agrees with the prose adds nothing; one that disagrees is wrong.
