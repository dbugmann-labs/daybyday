## Why

A person's commitments come out in the order they happened to be taken on, and there is nothing
they can do about it. Day one wrote eight of them in the order the owner listed them one afternoon;
everything defined since has landed at the end. The order is the one thing about a roster a person
reads every single day — it is which rows a thumb reaches without scrolling, on the day screen as
much as on the commitments screen — and it is the only thing about a roster they cannot change.

**B-033** is the want — *"put my commitments in the order I want them"* — `FEAT: commitment` (#26)
is the Feature this Story hangs off, and #145 (`add-roster-removal`, B-031) is the blocker that
closed first, because the third state a roster now holds a commitment in is a place in the order
this change makes a person's.

**An order the system works out and an order a person sets are different things, and this change
swaps one for the other.** The roster has always refused to invent an order — alphabetical would be
a rule about the owner's own words, and by the day each is kept from would leave day one's eight
tied — and every one of those arguments still stands. None of them argues against the owner
choosing. So the sentence that reads *"the order SHALL be the order they were taken on and nothing
else"* becomes *the order is the person's, and taken-on order is where it starts*. **ADR-1037**
records that, because three `CONTEXT.md` entries and two requirement titles say the old thing and a
reader who meets one of them should be sent to the record rather than left to guess.

## What Changes

- **A roster moves a commitment**, which is its fourth act on one beside taking it on, stopping
  keeping it and removing it. A move takes a commitment and an **offset** — a place counted over the
  commitments the roster is keeping **as they stand before the move** — and takes no date, because
  nothing about a move is dated and the roster still never asks what day it is.
- **The order runs over everything the roster holds**, kept, stopped and removed alike, as one
  sequence of which the commitments screen's two lists are filters. A stopped commitment therefore
  keeps the place it has, and taking it up again returns it there. **Only the moved commitment
  moves**: a stopped or removed one lying between where it was and where it goes stays exactly where
  it is, and the price of that is stated rather than hidden — a stopped commitment taken up again
  lands where the sequence now puts it, not beside the neighbour it used to have.
- **A commitments screen moves a commitment on its kept list, by a drag**, and nowhere else. There
  is no confirmation: a drag is the confirmation, and a drag back is the undo. A move it would not
  make is the **fifth** kind of refused change, beside defining, stopping, keeping again and
  removing.
- **A drop that puts a commitment where it already is is accepted and writes nothing** — it is not a
  refusal, and it does not answer a refused-change notice already standing, because nothing was
  kept. Two offsets do this for any commitment, which is a fact about the gesture rather than a
  choice: the place it is at, and the place just after it.
- **An offset outside the kept commitments is refused by the roster** rather than clamped, because
  the seam is public even though a drag cannot produce one. A clamp puts a commitment somewhere
  nobody asked for. Through the screen the same offset asks for no change at all and so refuses
  nothing, by the rule the screen already has for a commitment neither of its lists holds.
- **Nothing about the file changes.** A roster's order has always been carried by the order the
  commitments are written in, so a move rewrites the same fields in a different sequence at the same
  form. `RosterDocument.currentVersion` stays 3 and no field is added. A roster written before this
  change reads back with its taken-on order as the order its owner starts from.
- **The day screen inherits the new order for nothing.** It already draws what it was handed in the
  order it was handed it and is already forbidden from reordering the roster's answer. That is a
  claim rather than an observation until a test says otherwise, so the `day-screen` delta carries
  one scenario and no behaviour change.
- **The SwiftUI drag rides this Story's branch**, in its own `tasks.md` section, under ADR-1019's
  2026-09-04 exception. The offset the kit takes is the offset `List`'s own `onMove` hands over, so
  the shell converts nothing.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: the roster's order becomes the person's and gains a move; the roster store keeps a
  move and reads a roster back in the order it holds rather than the order it was taken on; the
  commitments screen moves a commitment on its kept list, and a refused move is its fifth kind of
  refused change. Nine requirements say "in the place it was taken on in" or "in the order they were
  taken on" as a rule, and each becomes "in the place it has" or "in the order the roster holds
  them" — the same behaviour for a roster nobody has moved, and the true one for a roster somebody
  has.
- `day-screen`: one scenario, and no behaviour change. A day screen draws its rows in the order its
  roster was moved into, which turns "it inherits the order for nothing" into a fact.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `Roster`, `RosterStore`, `CommitmentsScreen`. No new file
  and no new type behind the seam.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — an `.onMove` on the kept list and the edit mode
  that reaches it, under ADR-1019's exception.
- `docs/adr/` — ADR-1037 written. **Not** amended: ADR-1031 (no form moves, so its trigger does not
  fire), ADR-1023 (no kept-until day moves), ADR-1027 (a moved roster is still not an empty one, by
  the rule that already holds).
- **Not touched:** `RosterDocument`, `RosterStore`'s reading of the two forms before it, the
  `record` and `schedule` capabilities, `DayScreen`, `DayView`, and every tick already recorded.
  That the file does not move is the finding this change rests on, not an omission.
