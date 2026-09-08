# 1043. A group move carries the whole group, where a commitment's move steps over what lies between

- Status: accepted
- Date: 2026-09-08
- Deciders: Diego Bugmann

## Context

ADR-1037 made a roster's order the person's and gave it one verb, `move`, taking a commitment and a
place. ADR-1038 made a category the roster's and gave it one reading rule: a group sits where its
first commitment sits, and the commitments under no category come last. Together they leave a group's
position **derived** — nothing is stored for a group, and where a heading sits is an accident of when
its first commitment was taken on.

`add-category-order` (#168) makes that position the person's too. The grill settled the shape in one
sentence — *moving a group relocates its commitments as a block inside the roster's one order* — and
refused the alternative of a second, explicit order over categories, which would have overturned
ADR-1038 eight days after it shipped and left an order entry behind whenever a category's last
commitment let it go.

What is left to decide is what "as a block" contains, and it is not obvious, because the
single-commitment move already answers the neighbouring question the other way. `commitment/spec.md`
says three times over that a stopped or removed commitment lying between where a commitment was and
where it goes is **passed rather than pushed**: the moved commitment goes by, and it stands still.
A reader who has just read `Roster.move` will expect a group move to do the same and leave everything
it is not keeping where it was.

## Decision

**A group move carries every commitment under that category — kept, stopped and removed alike — as
one block, keeping their order against each other.**

- **The block is every entry under the category, in every state.** Not the kept ones, not the ones a
  list is drawing today.
- **It is placed against the *whole* of the target group's block**, not against that group's first
  kept commitment: immediately before the first commitment under the category of the group that stood
  at the offset, or immediately after the last commitment under the category of the last group kept
  under one.
- **A commitment's move is unchanged.** It goes on passing what lies between rather than pushing it,
  and the two rules stand side by side deliberately.

The reason is not symmetry and not tidiness — it is that the other choice is **observably wrong**. A
roster answers about a calendar date in groups too, drawing the commitments it had not stopped keeping
on that date each under its category, and ADR-1038's rule places a group at its *first* commitment. A
stopped member left behind at the group's old place would go on anchoring that group there: move
*Supplements* below *Sport* today, and January still draws *Supplements* first. There is one order and
it is the person's; a group order that holds only for dates after the move is not one.

The two rules differ because the two acts differ in what they are about. A commitment's move is about
one row a person has hold of, and what it steps over is nobody's business but its own. A group move is
about a heading, and a heading is not a thing at all — it is a reading of where the commitments under
one word sit. To move the reading you have to move all of them.

## Consequences

- **A group whose commitments were scattered comes back contiguous**, so a commitment under another
  category that lay between two of them is afterwards on one side of the whole group. Everything that
  stays keeps its order against everything else that stays, and that is all a group move promises.
  This is the price of one order over one roster, and `commitment/spec.md` states it rather than
  leaving it to be found.
- **Moving a group away and back does not restore the roster**, because the first of the two moves
  gathered it. Asking for the place a group already has is carved out of the gather entirely — two
  offsets change nothing at all — so a tap that means nothing costs nothing; but two taps that mean
  something are not an undo of each other.
- **A group move carries no category argument and can never change one.** Every commitment travels
  under the category that named the group, so unlike a commitment's move this act is not a second way
  a category changes. Nothing is re-keyed and every record already made stands, which is the property
  ADR-1038 bought by putting the category on the roster rather than on the commitment.
- **ADR-1038 is untouched.** A group still sits where its first commitment sits; this decision moves
  the commitments so that rule draws the group somewhere else. **ADR-1037 is amended rather than
  superseded**: a move is still the only thing that ever changes a roster's order, and it now takes a
  group as well as a commitment.
- **A category only a stopped or removed commitment is under cannot be moved**, and keeps whatever
  place its commitments have. Taking one of them up again brings the group back into a roster whose
  groups may have been reordered since — the same price ADR-1037 already took for a stopped
  commitment's own place, one level up.

## Alternatives considered

**Move only the group's kept commitments.** Rejected on the mechanism above: the dated group read
would disagree with what the person just did, and the disagreement grows with every stopped
commitment.

**Move only the group's first commitment**, which is all ADR-1038's rule strictly needs to redraw the
heading. Rejected because it leaves the rest of the group where it was: the flat reads, and every past
date, would then place the group's own members on both sides of another group, and a person who moved
a heading would find the rows under it had not come along.

**A second, explicit order over categories.** Rejected at the grill (`add-category-order`'s `grill.md`
§ *Settled* 1) before this decision was reached: it would overturn ADR-1038, and it would need an
entry deleted whenever a category emptied — the "nothing to delete" property that ADR-1038 and the
no-list-of-categories rule were both chosen for.
