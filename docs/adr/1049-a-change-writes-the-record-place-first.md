# 1049. A change writes the record place first, and no requirement identifies a refusal by its number

- Status: accepted — both shapes were settled in the Stories that built them, `add-commitment-editing`
  (#148) and `rework-commitment-row-actions`; this record is written by `condense-commitment-spec`
  (#204), the Story that deletes the requirement prose which had been carrying the reasoning
- Date: 2026-09-10
- Amended: 2026-09-23 — a deletion writes the record place first too, erasing its records, and puts
  it back where the roster place refuses; a kill between the two leaves the commitment listed with
  no records rather than records under no commitment. ADR-1060.
- Amended: 2026-09-14 — the write order stands, but asking for the same change again is no longer the
  repair for a half-written change, because the refusal onto records already kept (#247) blocks that
  retry. `save-change-whole` (#249) replaces it with a save in progress undone when the places are
  next read, and adds what happens to records already orphaned. § *Making a torn save whole* is the
  new part.
- Deciders: Diego Bugmann

## Context

Two rules in `openspec/specs/commitment/spec.md` have kept themselves alive only in the prose a
condensing Story deletes, and in archived change folders, which is not where a cold reader looks.
They share a subject: each one keeps a later edit from silently falsifying something already written
down, one in a person's files and one in this repository's own documents.

The first is an ordering. A change to a commitment can touch two places — the **record place**, where
the records already written against it are carried over to the changed commitment, and the **roster
place**, where the commitment itself is replaced. They are separate files and nothing makes one write
of both, so one of them goes first and the choice has a failure mode either way. A restart (#248)
writes the same two places in the same order.

The second is a rule about how the spec is written. *A commitments screen holds the change it
refused and why it was refused, one at a time* enumerates the kinds of change a person can ask for.
Requirements elsewhere have to refer to one of them, and referring to it by position is the natural
shorthand. The second rule has no scenario and could not have one: no behaviour distinguishes a spec
that obeys it from one that does not.

## Decision

**The record place is written before the roster place, on every change that touches both.** Written
the other way round, a roster that took the change and a record place that then refused it leaves a
past day drawing a commitment it holds no record of, silently. In the order stated, a failure leaves
records under a commitment the roster never took on — a **torn save** — which the decision below
makes whole. **Where nothing is carried over, nothing at all is written at the record place**; a
change that moves no record leaves that file untouched rather than rewriting it with what it already
held.

**The kinds of refused change are counted in one requirement and numbered nowhere else.** A
requirement that introduces one names it — a refused move, a refused group move, a refused change —
and identifies it by its name and never by its position. Withdrawing a kind renumbers every position
after it, which falsifies both the requirements stating one and the archived change folders citing
one; archived folders are never edited, so a number written into one is wrong for ever the day a kind
goes. A statement about the kinds that came *before* a kind is not a position in this sense: it names
them, all of them go on existing, and nothing withdrawn later can make it untrue.

**The general form is that a cross-reference never names a count.** Defer behaviour for behaviour,
with no number in it. This is the rule the refusal kinds make concrete, and it holds wherever one
requirement leans on a set another requirement enumerates.

## Making a torn save whole

The original repair was the person asking for the same change again: the retry carried nothing, there
being nothing left under the old commitment, and wrote the roster. It stopped converging once a change
onto a commitment the record place already holds records of was refused, because after a tear the
retry meets exactly those records.

**A save that carries records leaves a save in progress beside the record place before its first
write**, naming the commitment the records are carried from and the one they are carried to, and
takes it away after the roster place is written. Whatever reads the places next asks one question of
it: does the roster hold, in any state, the commitment the records went to? If so, the save finished
and the save in progress is taken away. If not, the records are carried back and the save never
happened, which is what a person who was never told it saved expects. A roster write that fails
mid-save runs the same undo, so there is one way back rather than two.

**A torn save that cannot be undone withholds the record place** from a day screen and the roster
from a commitments screen until it can be. Nothing torn is ever drawn or written over.

**A record orphaned by any cause goes back only to its one possible source**: the one commitment the
roster holds, in any state, that it could have been carried from — the same kind, the same rhythm
with an interval's start date set aside, and due on every day it holds. Where there are none, several,
a day already recorded on that source, or a second orphan with the same source, nothing moves and the
commitments screen says so. Nothing on disk tells a tear's orphan from one a replaced roster left, so
both are treated alike.

## Consequences

- **The write order still has no scenario.** No test makes the record place refuse after the
  roster place accepted, so only a reader catches a roster written first.
- **A third file sits beside the record place**, briefly on every save that carries records, and
  stands only after a stop.
- **Two commitments alike in all but name make an orphan ambiguous**, so a past tear between them is
  said rather than repaired. The save in progress is what spares new tears that fate.
- **The in-save undo failing has no scenario of its own**; it runs the same undo as reading the
  places does, which has.
- **A rewrite of the spec cannot introduce "the seventh kind".** The rule already forced one
  requirement's sentence to be reworded during a length-driven rewrite, and it is the reason a
  deferral to a neighbouring requirement's count is a defect rather than a shorthand.
- **Nothing mechanical enforces the numbering rule.** It is caught at review.

## Alternatives considered

**Write the roster place first.** Rejected on the mechanism above: the failure it leaves is silent,
and a past day draws a row whose records have gone.

**Make the two places one write, one file for both.** Rejected at the grill of `save-change-whole`:
it reverses keeping the roster place deliberately apart from the record place (#103). If a
transaction across the two is ever built, the save in progress and the ordering both stop mattering.

**Repair every orphan by matching alone, with no save in progress.** Rejected: the common tear, a
rename between two commitments alike in all but name, is exactly the ambiguous case.

**Carry an orphan back to the likeliest of several sources.** Rejected: choosing between two
histories is a judgement about someone's past that nothing here is entitled to make.

**Number the refusal kinds and keep the numbers stable by never reusing one.** Rejected: it keeps a
register of positions in a document nobody maintains, and the archived folders that cite one are
outside the reach of any correction. Naming costs nothing and cannot go stale.
