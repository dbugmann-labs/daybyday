# 1049. A change writes the record place first, and no requirement identifies a refusal by its number

- Status: accepted — both shapes were settled in the Stories that built them, `add-commitment-editing`
  (#148) and `rework-commitment-row-actions`; this record is written by `condense-commitment-spec`
  (#204), the Story that deletes the requirement prose which had been carrying the reasoning
- Date: 2026-09-10
- Deciders: Diego Bugmann

## Context

Two rules in `openspec/specs/commitment/spec.md` have kept themselves alive only in the prose a
condensing Story deletes, and in archived change folders, which is not where a cold reader looks.
They share a subject: each one keeps a later edit from silently falsifying something already written
down, one in a person's files and one in this repository's own documents.

The first is an ordering. A change to a commitment can touch two places — the **record place**, where
the records already written against it are carried over to the changed commitment, and the **roster
place**, where the commitment itself is replaced. They are separate files and nothing makes one write
of both, so one of them goes first and the choice has a failure mode either way.

The second is a rule about how the spec is written. *A commitments screen holds the change it refused
and why, one at a time* enumerates the seven kinds of change a person can ask for. Requirements
elsewhere have to refer to one of them, and referring to it by position is the natural shorthand.
Neither rule has a scenario, and the second could not have one: no behaviour distinguishes a spec
that obeys it from one that does not.

## Decision

**The record place is written before the roster place, on every change that touches both.** Written
the other way round, a roster that took the change and a record place that then refused it leaves a
past day drawing a commitment it holds no record of — and asking for the same change again cannot
repair it, because the commitment the second ask names as the one to change is no longer the one the
records are under. In the order stated, the same second ask carries nothing over, there being nothing
left under the old commitment, and then writes the roster, which is exactly the repair. **Where
nothing is carried over, nothing at all is written at the record place**; a change that moves no
record leaves that file untouched rather than rewriting it with what it already held.

**The seven kinds of refused change are counted in one requirement and numbered nowhere else.** A
requirement that introduces one names it — a refused move, a refused group move, a refused change —
and identifies it by its name and never by its position among the seven. Withdrawing a kind renumbers
every position after it, which falsifies both the requirements stating one and the archived change
folders citing one; archived folders are never edited, so a number written into one is wrong for ever
the day a kind goes. A statement about the kinds that came *before* a kind is not a position in this
sense: it names them, all of them go on existing, and nothing withdrawn later can make it untrue.

**The general form is that a cross-reference never names a count.** Defer behaviour for behaviour,
with no number in it. This is the rule the refusal kinds make concrete, and it holds wherever one
requirement leans on a set another requirement enumerates.

## Consequences

- **The write order is a guarantee with no test.** No scenario makes the record place fail, so
  nothing but a reader catches an implementation that writes the roster first; it is stated as a rule
  in the requirement on changing a commitment and listed as knowingly untested by the Story that
  wrote this record.
- **A repair exists for a half-written change**, and it is the person asking for the same change
  again. That is only true in this order, which is why the order is part of the decision rather than
  an implementation detail.
- **A rewrite of the spec cannot introduce "the seventh kind".** The rule already forced one
  requirement's sentence to be reworded during a length-driven rewrite, and it is the reason a
  deferral to a neighbouring requirement's count is a defect rather than a shorthand.
- **Nothing mechanical enforces either rule.** Both are caught at review, and both are stated in the
  spec as normative sentences so that a reader has something to catch them against.

## Alternatives considered

**Write the roster place first.** Rejected on the mechanism above: the failure it leaves is
unrepairable by the act a person would naturally repeat, and it is silent — a past day draws a row
whose records have gone.

**Make the two places one write.** Rejected as out of reach rather than as wrong: they are separate
files with separate stores, and nothing in this product makes a transaction across two of them. If
one is ever built, the ordering stops mattering and this half of the record is reversed.

**Number the refusal kinds and keep the numbers stable by never reusing one.** Rejected: it keeps a
register of positions in a document nobody maintains, and the archived folders that cite one are
outside the reach of any correction. Naming costs nothing and cannot go stale.
