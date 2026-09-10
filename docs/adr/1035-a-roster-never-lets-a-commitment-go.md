# 1035. A roster never lets a commitment go: removing is a third state, not a departure

- Status: accepted
- Date: 2026-09-07
- Deciders: Diego Bugmann
- Amended: 2026-09-10 — an unreadable roster store being refused rather than answered as an empty
  roster is added to the decision by `condense-commitment-spec` (#204), which deletes the requirement
  prose that carried the argument; it is this record's failure mode arriving from the store's side.

## Context

A person can stop keeping a commitment, and that is all they can currently do with one they no
longer want. Everything stopped lands on the commitments screen's second list and stays there:
mistyped names, rhythms that were never right, and the ones of day one's eight the owner has never
kept sit for ever beside the things they genuinely stopped and might take up again. B-031 —
*"get rid of a commitment for good, not just stop keeping it"* — is the want, and
`add-roster-removal` (#145) is the Story that builds it.

The obvious shape is the one the words suggest: the roster drops the entry. It is the cheapest thing
to build and it satisfies "no longer due, no longer listed, gone".

**It also erases the record.** A roster answers which commitments it had not stopped keeping on a
date, and a day screen draws its rows from that answer and from nothing else. A commitment the
roster has forgotten is a commitment no past day can ask about, so every day it was ever kept loses
its row — and with the row goes the visible evidence of every tick made against it, on a product
whose single promise is that what you actually did survives. Getting rid of the gym in September
would blank out the summer you went to it.

ADR-1023 has already refused this shape once, from the other direction: *"Forget a stopped
commitment entirely: the roster drops it… Rejected because it fails the other half of the same
sentence: every past day would lose that commitment's rows."* What #145 adds is that the same
argument holds for a removal, where the word itself pushes hardest the other way.

There is a second, quieter consequence. ADR-1027 makes `DayScreen` write day one — the owner's own
eight commitments — exactly when the roster it has just read holds nothing at all, and it is written
that way deliberately: *"what makes this a first launch is that nothing has ever been taken on, not
that nothing is being kept today."* A roster that dropped its entries would read as holding nothing
the moment a person removed the last of them, and day one would be written on top of a list they had
just deliberately emptied, on a phone months into use.

The owner settled it at the grill of #145 on 2026-09-07, answering past all three shapes that were
offered — leave the record alone and drop the entry; delete the record too; refuse removal where
records exist — with one sentence: *"Past days should not lose their rows, they should still be
there even after a commitment was stopped or removed."*

## Decision

**A roster never lets a commitment go. Removing is a third state a roster holds a commitment in,
beside kept and stopped.**

- **The commitment stays in the roster**, in the place it was taken on in, with the day it was
  **kept until**. Nothing takes a commitment out of a roster; there is no operation that shortens
  one.
- **A removed commitment is answered about a date exactly as a stopped one is** — in the answer on
  and before the day it was kept until, out of it after. A day screen cannot tell the two apart and
  is not allowed to, so every past day draws exactly the rows it drew before.
- **The record is not touched.** No tick moves, and `record` has no part in this change. A removal
  is a fact about a roster, never about what was done.
- **Where the difference lives is the commitments screen**, which lists a removed commitment in
  neither of its two lists. That is the whole of what removal is to a person: they are no longer
  offered it, anywhere.
- **A removed commitment always has a kept-until day.** Removing one the roster is keeping takes the
  date it is given; removing one already stopped keeps the day it already had, because that day was
  visible on a list and a removal is not an occasion to move it. "Removed with no day" is a state a
  roster has never been in, and a stored roster claiming it is refused as content that could not be
  a roster.
- **The way back is defining the identical commitment again**, which the roster already takes as
  taking a held commitment up again: in its old place, with its history, with the kept-until day and
  the removal both cleared. There is no list of removed commitments and no undo. A person who cannot
  reproduce the name, the rhythm, the day it is kept from and the kind exactly cannot get it back,
  which is what "for good" means and why the screen asks for the name to be typed.

**The commitment itself gains nothing.** The state lives on the roster's entry, exactly as the
kept-until day does and for exactly the reason ADR-1023 gives: `Tick` embeds the whole `Commitment`
by value and `History` answers by set membership, so a fourth part on `Commitment` would change its
identity the moment it was set and orphan every tick recorded against it. That is the failure this
decision exists to prevent, arriving by way of a `Bool`.

**An unreadable roster store is refused, and never answered as an empty roster.** The failure this
record exists to prevent arrives a second way, at the store: opening a place holding something this
app cannot read as a roster store is an error, not a roster holding nothing, and what is there is
neither overwritten, moved, deleted nor partly kept. A roster reading as holding nothing is
indistinguishable from a first launch to whatever writes day one (ADR-1027), so a silent empty answer
would write day one over a list a person has kept for months and tell them they keep nothing. An
honest error on opening is the failure this product can survive; a list silently replaced by an empty
one is not, and it is the same silence a dropped entry would have caused.

## Consequences

- **Getting rid of something costs the record nothing**, which is the point. Every past day answers
  as it did, every tick stands, and a person who removes a commitment by mistake loses only the
  ability to find it again without retyping it.
- **"Removed" does not mean "deleted", and a reader will expect it to.** This is the surprise the
  record exists for. Nothing shrinks: not the roster, not the file, not the record. A person looking
  for a way to make the app forget something will not find one here, and one has not been asked for.
- **ADR-1027 is discharged without a marker.** A roster that has ever taken something on is never
  again equal to a roster given nothing, so day one cannot be written over a roster a person has
  emptied. No "has ever held something" flag is needed, and none is added — the property falls out
  of removal being a state rather than a departure. `add-roster-removal`'s `day-screen` delta pins
  it with its own scenario.
- **The roster's file gains one field per entry**, and with it a third form. ADR-1031 governs how it
  is read — every form this app has written opens, and each is read as the shape that form has — and
  it names what would have to change at a fourth. This is the second file in the product to reach
  three forms; the record got there a day earlier at `add-number-record` (#138), and the two move
  independently.
- **A roster only ever grows.** Nothing in the product bounds how many commitments it holds, and now
  nothing reduces the count either. On a personal roster reaching double figures over years this is
  a file of kilobytes and a linear scan of a list a person could read aloud; it is stated here so
  that a reversal trigger exists rather than being discovered. **The trigger is a roster large enough
  that a screen or a day view is measurably slow to form**, at which point the answer is an index or
  a separate archive file, not a delete.

## Alternatives considered

**Drop the entry.** The cheapest thing to build and the meaning the word "remove" carries. Rejected
on the mechanism above: every past day loses that commitment's rows, and a roster emptied by removal
reads as a first launch to whatever writes day one. Both failures are silent and both land on the
one thing the product promises.

**Delete the record too — the ticks go with the commitment.** Honest about what "for good" sounds
like, and it makes the roster and the record agree. Rejected by the owner in the same sentence that
settled the rest: past days keep their rows. It is also the only irreversible act in the product,
made from a screen whose other three changes all have a way back.

**Refuse removal where anything has been recorded against the commitment.** The safe-looking middle:
a commitment nobody ever ticked can go, one with history cannot. Rejected because it makes the
feature useless exactly where it is wanted — a commitment kept for two years and finished with is
the one a person most wants off their list — and because the refusal would be one nothing on the
screen could explain: `History` and `RecordStore` take back one tick at a time and enumerate nothing
by commitment, so the screen could not even say how much history was in the way without a surface
built to answer it.

**A fourth part on `Commitment`, `isRemoved`.** Not seriously in play, and named so it is not
proposed again. ADR-1023 measured the cost: it orphans every tick already recorded, which is the
same failure as deleting the record, arriving without anyone deciding it.
