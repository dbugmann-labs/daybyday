# 1020. ADRs are mutable, and git history is the audit trail

- Status: accepted
- Date: 2026-09-03
- Deciders: Diego Bugmann

## Context

Until now an accepted ADR could not be edited. A reversal had to be a new record that superseded
the old one, the superseded file stayed where it was, and only incidental detail — a wrong command
name, a moved path — could be corrected in place, in the open, under a dated `## Corrections`
section. The reasoning was that the decision, its rationale and the alternatives it weighed are
the record, and the register is worth having only if a reader can trust they still say what they
said on the day.

Nineteen records in, that rule had produced three chains and no reader who benefited from them.

**The fourth model tier, `1011` and `1016`.** It was accepted on 2026-09-02 and withdrawn the same
day, before a single change folder had been written under it. The net effect on the repository was
zero — `1011` superseded ADR-0006's routing rule, `1016` restored it — and the cost was two files
and **seventeen live references to `1011`**, every one of which sent a reader to a decision that
had been reversed within hours. To find the rule actually in force you had to read three files and
work out which sentence of the first survived the second.

**The gate-stop ordering, `1014` into ADR-1012.** It superseded exactly two things there: the
order of the five parts, and the budget on one of them. Everything else in ADR-1012 held. A
reader who opened ADR-1012 — the record the register named, and the one every cross-reference
pointed at — read the wrong ordering with nothing on the page to warn them.

**The backlog staleness rule, `1018` into ADR-1010.** Same shape: one withdrawn sentence out of a
decision whose diagnosis, split, admission rule and two commands were all untouched.

Two things make the chains cost more here than they would elsewhere. Cross-references resolve by
number and there are over a hundred of them, in `AGENTS.md`, under `docs/`, in `.claude/` and in
archived change folders that may not be edited at all — so a partial supersession silently
falsifies every reference to the record it partly replaced. And the reader this register is
written for is often a cold agent told to read `docs/adr/` to find out how things work; it follows
a cross-reference, reads one file, and has no way to learn that a later number rewrote a sentence
of it.

The rule's premise was also weaker than it looked. **The audit trail the immutability rule was
protecting already exists, and it is better than the chains.** This repository is public, `main`
is protected, and every ADR change arrives as a commit on a pull request with a description. There
is no route by which an ADR changes without a reviewable, dated, attributed diff. `git log -p
docs/adr/1010-a-groomed-backlog-replaces-the-parking-lot.md` answers "what did this say before,
and why did it change" in one command, in order, with the reasoning attached — which is what a
chain of files was reaching for and does not deliver.

## Decision

**An accepted ADR may be edited in place.** When a decision changes, change the file that holds
it. Three things go with the edit, and they are stated normatively in `docs/adr/README.md`:

1. **The PR says what changed and why.** That is where it is read, attached to the diff.
2. **The file carries an `- Amended: YYYY-MM-DD — <one line>` stamp** in its header block, newest
   first, so a reader sees that the file has moved without opening git.
3. **The file is left reading as one coherent decision** — the decision as it stands today, not a
   decision with a rebuttal stapled to it. Reasoning from the old shape stays only where it
   explains why the current shape is what it is.

A trivial fix — a typo, a dead link, a path that moved — needs no stamp.

**`## Corrections` is retired rather than converted.** It was the same idea under an older name.
The five ADRs that carry one keep it, because those sections carry three to ten lines of detail
each that a one-line header stamp cannot hold and rewriting them would destroy the record this
change exists to preserve. Nothing new goes there.

**A number is never reused, and a gap is normal.** This is the one thing mutability must not be
allowed to imply. Deleting a file frees nothing: a reused number silently re-points every existing
cross-reference at a different decision, including the ones in archived change folders that cannot
be corrected. `1011`, `1014`, `1016` and `1018` are gaps.

**The three chains are collapsed into the records they partly superseded**, and the reversals are
deleted. ADR-0006 is left exactly as it was, having been superseded and restored to no effect.

## Consequences

- **A cross-reference now resolves to the decision in force.** That is the whole point, and it is
  what the chains could not give: `ADR-1012` is the ordering the conductor actually prints, and
  `ADR-1010` is the backlog rule that actually runs.
- **Reading an ADR no longer tells you whether it is current.** Under the old rule it did not
  either — you had to know that a later number had superseded part of it — but the failure mode
  moves. The `Amended` stamp is the mitigation and it is only as good as the discipline that
  writes it; nothing checks that an edit carries one.
- **What a decision said on the day is now one command away rather than zero.** `git log -p` on
  the file, or the PR. This is a real loss for the reader who is holding a printout and not a
  clone, and it is the price. It is small because the register's actual reader is an agent or the
  owner, both of whom have the repository.
- **Two files' worth of argument that no longer describes anything went with the reversals.** The
  Fable price comparison and the trial's exit criteria are in `git log`, not in `docs/adr/`, and
  someone proposing the tier again will not find them by reading the register. The Amended stamp
  on ADR-1010 and ADR-1012 names the date to look at; nothing points at the Fable chain, because
  after the collapse there is no file for a pointer to sit in.
- **This does not settle when a number is claimed.** Two branches open at once can still write the
  same number and learn of it only at a rebase. `docs/open-questions.md` § *Open technical
  decisions* holds that question and it stays open — mutability makes a wrong number cheaper to
  fix in the register, and does nothing about the signed change folder that cross-references it.
- **Nothing enforces any of this.** No check reads `docs/adr/`. A silent edit is possible and only
  review would catch it — which was equally true of the immutability rule it replaces.

## Alternatives considered

**Keep immutability and collapse nothing.** The status quo. Rejected on the evidence above: three
chains in nineteen records, seventeen references pointing at a decision reversed the same day, and
no reader served. The rule was defending an audit trail that the PR history already provides.

**Keep immutability, and require a `Superseded in part by ADR-NNNN` line at the top of the
superseded file.** The cheap fix, and it addresses the sharpest failure — the reader who opens
ADR-1012 and does not learn that its ordering moved. Rejected because it is a mutation: editing an
accepted ADR to add that line is exactly the thing the rule forbids, so the rule has to bend
anyway, and the version that bends this far has conceded the principle while keeping the file
sprawl. Once the file is editable, folding the decision in is strictly better than pointing at
where the rest of it lives.

**Mutable, but keep the reversal files as tombstones pointing at the fold.** Preserves the
argument in `1011` and `1016` for anyone proposing Fable again, at the cost of two files that
decide nothing and a register with dead rows in it. Rejected: `git log` holds them, and a
tombstone in a register of decisions is a decision-shaped thing that is not one — which is the
mistake `docs/parking-lot.md` made and ADR-1010 diagnosed.

**Mutable, with a check that fails a PR touching `docs/adr/` without an `Amended` stamp.** A real
option and the natural successor if the stamp turns out not to get written. Rejected for now
because it would fail on every trivial fix, and a check the author routinely has to reason their
way around is one that teaches people to ignore it. Worth revisiting after the stamp has been
lived with, and worth it only with an escape for trivial edits.

**Delete the reversed records and write nothing.** Tidiest, and it loses the one thing worth
keeping: the question "what happens when I find an edited ADR?" has an answer in this file rather
than in whichever commit message a reader happens to open.
