# Grill — add-roster-order

*15 questions over 5 rounds, 2026-09-07.*

## Settled

1. **The person-set order is the roster's own order.** Taken-on order becomes only its initial
   value, and moving a commitment is a roster operation returning a new roster. *Asked because a
   person-set order has to break one of two sentences the spec already holds — "the order they were
   taken on and nothing else", or "MUST NOT give a commitment a position a commitment can be asked
   for". They chose the roster's order over an arrangement held on the screen: a day view already
   draws what it was handed in the order it was handed it, so the day screen inherits the new order
   for nothing, where a screen-held arrangement would need the day screen to read and apply it too
   and could then disagree with it.*

2. **The gesture is a drag to any position, on the commitments screen's kept list.** Not
   move-up/move-down. *One operation expresses any rearrangement, where two each need a decided
   answer at the ends; and drag is the gesture an iPhone list already teaches.*

3. **The order covers everything the roster holds** — kept, stopped and removed alike, as one
   sequence of which the screen's two lists are filters. *The roster already holds all three states
   in one sequence, so scoping the order to one state would mean the roster holds two orders. A
   stopped commitment therefore keeps the slot it had, and taking it up again returns it there —
   which is the answer to the third `## Open` question B-033 was captured with.*

4. **A commitment newly defined lands at the end.** *What a roster does today, so nothing changes
   for a person who never reorders. At the top would push every existing row down the day screen on
   the day a commitment is defined, changing something the person did set.*

5. **A move that drops a commitment where it already is is accepted, and writes nothing.** Not
   refused. *The roster's other refusals are about a commitment it cannot act on at all; this is a
   move it can make, whose result is the roster it already had. A notice for a drag the person did
   not notice making is noise.*

6. **A move becomes a fifth kind of refused change on the commitments screen**, beside defining,
   stopping, keeping again and removing. *Every other change the screen makes reports itself the
   same way, and a reorder that silently failed to write would leave a person looking at an order
   the phone will forget the moment it is closed.*

7. **The vocabulary lands as an amendment to `CONTEXT.md` § *Roster*, plus one new verb**, rather
   than a glossary entry for the order itself. *The order was never a thing separate from a roster;
   giving it its own entry would make it look like one.*

8. **The verb is *move*.** *It names one commitment changing place — what the roster does and what a
   drag is — and sits beside add, stop and remove as a verb taking one commitment. "Reorder" names
   the whole list being rearranged, which is not an operation anything performs.*

9. **The target place is counted over the kept commitments**, not over everything the roster holds.
   *The kept list is the only list on screen when the drag happens, so a position counted over all
   three states would be a number nothing shows.*

10. **Only the moved commitment moves.** A stopped or removed commitment lying between the source
    and the target stays exactly where it is in the sequence. *The stop and the remove requirements
    already say "everything else the roster holds SHALL be exactly as it was, in the order it was
    in", and a move says the same. The price, taken knowingly: a stopped commitment taken up again
    lands where the sequence now puts it rather than where it was relative to its old neighbour —
    which is what one order over all three states costs.*

11. **The seam takes an insertion point, not a final position** —
    `move(_ commitment: Commitment, toOffset offset: Int)`, the offset counted over the kept
    commitments **as they stand before the move**. *A drag hands over an insertion point in the
    pre-move list, so dragging the top of three rows to the bottom gives 3 and not 2. Converting
    between the two conventions is a line that could be wrong in a way a test would catch, and
    ADR-1019 forbids the shell holding one — so the conversion must not exist. The roster's ban on
    "a position a commitment can be asked for" survives: it forbids a **read**, and this hands one
    in. `move(_:above:)` was weighed and dropped for the same reason — the shell would have had to
    map an insertion point to a commitment, including the past-the-end case.*

12. **An offset outside 0 through the number kept is a third refusal**, beside "not a commitment the
    roster is keeping" and "the roster could not be written". Not clamped. *A drag cannot produce
    one, but the seam is public. A clamp puts a commitment somewhere nobody asked for, which is the
    silent-wrong-thing the roster's other refusals exist to prevent.*

13. **A move that changed nothing does not clear a standing refused-change notice.** *Nothing was
    written, so nothing was kept; the notice is about the last change the screen would not make, and
    a drag that moved nothing has not answered it.*

14. **The SwiftUI drag rides this Story's branch**, in its own `tasks.md` section, under ADR-1019's
    2026-09-04 amendment. *All three of the amendment's conditions hold — the drag is the immediate
    consumer of the move landing in the same PR, it introduces no behaviour the kit does not specify
    (settled 11 is what makes that true), and it is named as its own section. The same shape
    `add-roster-removal` and `add-rhythm-in-words` used. A move nobody can reach from a phone does
    not meet the Story's stated intent.*

15. **`CONTEXT.md` § *App shell* is corrected in this change.** *It still says "That is why the shell
    is built on a `chore/` branch with no G4, and it is the only part of the app that ever is",
    written before ADR-1019 was amended and now contradicted by the three Stories that have relied
    on the amendment, this one included. Not this Story's subject, and taken anyway: a glossary entry
    contradicting the ADR the Story stands on is how the next agent gets it wrong.*

## Terms landed in CONTEXT.md

- **Move** — new entry. The roster's fourth act on a commitment, beside taking one on, stopping
  keeping one and removing one: putting a commitment it is keeping at a place among the ones it is
  keeping. It is the only act a person performs on the order.
- **Roster** — amended. The order is no longer "the order they were taken on and nothing the system
  worked out"; it is the order the person set, of which taken-on order is the initial value and the
  place a newly taken-on commitment lands.
- **Roster store** — amended. What it keeps is the order the roster holds, which is now a person's
  and not a history of when things were taken on. No stored field and no form number change (see
  *Facts established*).
- **Commitments screen** — amended. It also **moves** a commitment, from the kept list only, and a
  move it would not make is the fifth kind of **refused change**.
- **App shell** — amended, per settled 15.

## Facts established, so that nobody re-derives them

Every one measured on this worktree at `00a8f23`, 2026-09-07.

- **The stored shape needs no new field and no form bump.** `RosterDocument.currentVersion` is 3 and
  order is carried solely by array position in `commitments` — there is no position, index or rank
  field anywhere in `RosterDocument`, `RosterEntryRecord` or `CommitmentRecord`. A roster written
  before this change reads back with its taken-on order as the person-set order it starts with.
- **The day screen needs no new behaviour.** `day-screen/spec.md:406` already requires "A day view is
  in the order it was handed its commitments", and `:1642` already forbids the day screen reordering
  what the roster answers with. It calls `roster.commitments(on:)` at
  `DayScreen.swift:76`, `:209`, `:217` and consumes that order verbatim.
- **`CommitmentsView.swift:62` is already a `List`** with both lists as `ForEach` children of
  `Section`s — the structure `.onMove(perform:)` attaches to. There is no `.onMove`, `EditButton` or
  `editMode` in the file today.
- **Requirement titles that this change makes wrong are kept, not renamed.** Three say "in the order
  they were taken on" — `commitment/spec.md:382`, `:1249`, and the day screen's scenario title at
  `day-screen/spec.md:1648`. openspec 1.10.0 refuses a MODIFIED requirement that drops a scenario the
  current spec has, and renaming a requirement relocates its whole block to the bottom of the spec at
  archive time, permanently. Settled three times already — `add-commitment-kind`,
  `add-rhythm-in-words` and `add-roster-removal` — and its reasoning is in
  `archive/2026-09-07-add-roster-removal/design.md` § *Three scenario titles that are now wrong*:
  "A stale title is a blemish; a requirement block relocated to the end of a 2,000-line spec is a
  permanent one." Not re-asked.
- **The move takes no date.** Stopping and removing take one because they record a day kept until; a
  move records nothing dated, and the roster still never asks what day it is.
- **A move makes a different roster.** Two rosters holding the same commitments in a different order
  are already different rosters (`commitment/spec.md:382`), so this needs no new rule.

## Left open

Two, both `spec-author`'s to settle while writing the delta rather than the human's:

1. **Whether the change carries a `day-screen` delta spec at all.** Every day-screen requirement is
   already order-agnostic and nothing about its behaviour changes; what is stale is one scenario
   *title*. Whether that warrants a MODIFIED block, or whether `commitment` alone is the delta, is a
   judgement about how the delta is written and not a decision about what the product does.
   `add-rhythm-in-words` carried two delta specs, so there is precedent either way.
2. **An ADR for settled 1.** The decision that a roster's order stops being the order things were
   taken on and becomes the person's is hard to reverse, surprising against three `CONTEXT.md`
   entries and two requirement titles that say the opposite, and the result of a real trade-off
   against a screen-held arrangement — all three of `domain-modeling`'s tests. Number it from
   `docs/adr/README.md`; this grill deliberately did not.

No question the frontier raised was left for the human.
