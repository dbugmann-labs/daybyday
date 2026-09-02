# 1010. A groomed backlog replaces the parking lot

- Status: accepted
- Date: 2026-09-02
- Deciders: Diego Bugmann

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
  proposes a promotion, a merge, a split or a drop for each, forces a choice on any entry that
  has survived two passes, then grills the cluster taken forward with the existing `grill` skill
  and stops at **G1**.

**Grooming adds one stop in front of Stage 1 and nothing else.** No new stage, no new gate, no
new number, and no second grill: `/atlas backlog` hands to the Stage 1 machinery that already
exists — G1, then `orchestrator`, then the `/to-tickets` breakdown and G2.

## Consequences

- **The staleness rule becomes enforceable for the first time.** A grooming pass is a thing that
  happens and can be counted, so "survived two passes" is observable where "two rounds of Epic
  intake" never was.
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
