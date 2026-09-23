## Context

`RosterDocument.folded()` decides what each stored entry becomes and then assembles the roster in
the stored document's own order, so an era stays at the index of the entry it was made from.
`formRoster()`, the path every later reading takes, refuses a roster holding one identity's eras
split apart by another identity's, and `RosterStore` throws `notAStore` on that. The fold writes
nothing, so a document whose entries interleave two names opens fine and runs in memory until the
first roster write puts the folded order on disk; the opening after that is refused and the screens
hold one-offs alone.

The owner's roster, replayed against this code, breaks in two places: a chain whose eras straddle a
second commitment of the same name, and an era the stored roster held *in front of* the entry it
chains to, with a third commitment's entry between them. The second is worse than an ordering
fault — `Roster.stopped` walks each identity once and reads its first entry, so that commitment is
read back as stopped and as kept at once. No fixture in the suite interleaves two names.

Form 4 is a legacy form: no build writes one, and the fold is the one path that reads one.
`RosterStore.formed(from:)` shares it with a copy being read, so both sides move together.

## Goals / Non-Goals

**Goals:** a folded roster this app reads back whole, every era behind the commitment it belongs
to; the order of the commitments as the stored roster held them; the owner's own roster proved on
the phone.

**Non-Goals:** no tolerant reading of a roster the broken fold already wrote (settled 2), no change
to which entry becomes what, no repair or diagnosis of a stored roster, and nothing on any screen.

## Decisions

### The seam

No new member: the seam is the shipped one, and only what it answers with changes.

```
struct RosterDocument
func folded() -> Fold?

final class RosterStore
public init(at place: URL) throws
```

### The eras gather behind their commitment; the commitments keep their order

The fold already builds a chain per commitment and attaches each era to its chain's front, newest
to oldest. The roster is assembled from those chains instead of from the document's own index
order: each chain in the order of the entry its commitment was made from, then that chain's eras in
the order they attached, which is newest first by construction. Every head is a kept, stopped or
newly-stopped entry, so ordering the chains by head keeps the commitments exactly where the stored
roster had them, and only eras move. Rejected, at the grill: keeping document order and relaxing
the store's adjacency rule — two readers would then disagree on what a well-formed roster is, and
every later writer would inherit the looser one.

### One era held twice in a stored form-4 roster is refused, not folded

Two entries whose commitments are alike in every part are already the same era held twice, and
*A roster store that cannot be read is refused rather than emptied* already refuses a roster
holding one. The fold enforces that only where both entries would become commitments of their own;
where one chains to the other it makes two identical eras of one commitment, which is a roster this
app cannot read back — the same silent failure by another door. The guard extends to an entry the
fold attaches as an era. This is conformance to the shipped sentence rather than a new rule, so the
requirement gains that scenario and no prose. The owner's roster holds no such pair.

### A roster the broken fold already wrote is not read

Settled 2: the store keeps refusing it. The one file that ever held that shape was restored over,
and no shipped build writes it again once this lands. The refusal requirement gains the clause
naming it, because the code refuses it today and nothing said so.

### Migration

A form-4 roster on a phone folds to the same commitments, eras, states and categories as before;
only the order of the entries within the roster changes, and a commitment's own place does not. A
form-5 roster is untouched. A form-4 roster holding one era twice is refused where it used to fold.
Records carry across unchanged: the fold's identities are keyed by each stored commitment's own
shape, which no ordering touches.

### Two artifacts over budget, and why neither is split

The requirement this change modifies is 240 normative words as shipped, and the one it references
in a clause is longer still. A defect Story adding one clause and two scenarios is the wrong place
to split a shipped requirement into two, which would rewrite every scenario's home for readers of a
spec that has not changed. The new requirement is inside the budget.

## Risks / Trade-offs

**The order of a stored roster's entries changes under a person's feet.** A folded roster written
back is no longer byte-comparable with what an earlier build would have written from the same
source. Nothing reads that comparison, and the fold already rewrote the file's whole shape.

**The fix cannot be proved on the only input that matters.** The suite's fixtures are synthesized
from the owner's shape, never their file. Two `phone:` lines cover the real roster, and the copy
under `~/Coding/daybyday-data/` is the pre-fold snapshot to replay against by hand.

**One more way to refuse at the upgrade.** A form-4 roster holding one era twice now opens as
*could not be read* rather than folding into a roster that dies at the next write. The take-out and
the restore are the doors out, and the failure is visible at once rather than one write later.

## Open Questions

None. The grill left none open, and the three things it left to this delta are settled above: the
placement sentence and the round-trip clause are in the new requirement, the refusal requirement
names a split identity, and the fixtures are synthesized from the owner's two shapes.
