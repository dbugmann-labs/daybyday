## MODIFIED Requirements

### Requirement: A roster holds the commitments a person keeps, in the order they were taken on

A roster SHALL hold commitments, in an order it holds, and SHALL read back, in that order, every
commitment it has not stopped keeping. A roster that has been given no commitment SHALL
hold none, and SHALL be an answer rather than a refusal: a person who keeps nothing yet has an empty
roster, not a missing one. There SHALL be no upper bound on how many commitments a roster holds.

**The order SHALL be the person's.** The order the commitments were taken on is its initial value
and the place a newly taken-on commitment lands, and **moving** a commitment is the only thing that
ever changes it. A roster MUST NOT sort its commitments by name, by the day each is kept from, by
the schedule each runs on, by the category each is under, or by any other property of them: it still
has no order of its own to invent, because day one's commitments are all kept from the same day, so
an order taken from that day would leave them tied and the roster choosing between them, and an
order taken from a name would be a rule about the owner's own words. None of that argues against the
owner choosing, and only they can, because what an order is for — which rows a thumb reaches first —
is not something a roster can work out. This is the same reason a day view orders nothing of its own
and shows what it was handed in the order it was handed it. ADR-1037.

**The order runs over everything the roster holds**, kept, stopped and removed alike, as one
sequence. A roster holds one order and not one per state, so a commitment it has stopped keeping or
removed has a place in that sequence exactly as a kept one does, keeps that place while it is
stopped or removed, and returns to it when it is taken up again.

A roster SHALL hold commitments and, for each commitment, at most three further things: the
**category** that commitment is under, where it is under one; the day that commitment was **kept
until**, where the roster has stopped keeping it or removed it; and **that it was removed**, where
it has been removed. It holds nothing else. It MUST NOT give a commitment an identifier, a position
a commitment can be asked for, a record of the day it was added, or any other state of its own, and
it MUST NOT alter a commitment it holds: a commitment read back out of a roster SHALL be the
commitment that was put in, with the same name, the same schedule and the same day it is kept from.
None of the three is ever the commitment's: a commitment SHALL NOT gain a fifth part by being
stopped, by being removed or by being put under a category, and it SHALL go on answering whether it
is due on a date exactly as it did before. **The ban on a position is a ban on a read.** Nothing asks
a roster where a commitment is, and moving one hands a place **in** rather than reading one out; the
sequence is observable only as the order the roster reads its commitments back in.

**A category is read back where a position is not, and the difference is what the read would mean.**
A position is something the roster worked out about a commitment; a category is a word the person
chose and put there, so reading it back is reading back what they said. The roster answers it as
part of the **groups** it reads its commitments back in, and nothing asks it about one commitment on
its own.

**Kept, stopped and removed are the three states a roster holds a commitment in**, and a commitment
it holds is in exactly one of them. A commitment it is keeping has no kept-until day and has not been
removed; one it has stopped keeping has a kept-until day and has not been removed; one it has
removed has a kept-until day and has been removed. A category is not a fourth state and cuts across
all three: a commitment in any of them is under a category or under none. **A roster never lets a
commitment go**: nothing takes a commitment out of a roster, so a roster that has ever been given a
commitment SHALL NOT be the same roster as one that has been given none, whatever has since been
done to what it holds.

A roster SHALL NOT consult the present moment, the device's clock, its time zone or its locale, and
SHALL NOT be asked what day it is; every date it works with SHALL be one it was handed. It SHALL
judge a date in one way only: against a day it was told a commitment was kept until. It MUST NOT
judge a commitment's own day it is kept from, MUST NOT judge a schedule, and MUST NOT decide whether
a commitment is due — a commitment kept from a day long past and a commitment kept from the last
date the system supports are held alike, and whether either is due on any date is the commitment's
own answer and not the roster's.

A roster SHALL be a value. Two rosters holding the same commitments in the same order, each in the
same one of the three states, each under the same category where it is under one, and each with the
same kept-until day where it has one, SHALL be the same roster, and two holding the same commitments
in a different order SHALL be different rosters, because the order is one of the things a roster
holds. Adding a commitment to a roster, stopping one, removing one, moving one or putting one under
a category SHALL leave every other roster untouched, so a roster that was copied before any of the
five SHALL still hold what it held.

#### Scenario: a roster that has been given no commitment holds none

- **WHEN** a roster is formed and nothing is added to it
- **THEN** the roster holds no commitments

#### Scenario: a roster reads its commitments back in the order they were added

- **WHEN** a roster is given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all three on a schedule listing Monday, Wednesday and Saturday and all three kept
  from 1 January 2026
- **THEN** the roster holds those three commitments in that order — "Water plants", then "Gym", then
  "Journaling" — and not in alphabetical order

#### Scenario: a roster does not order its commitments by the day they are kept from

- **WHEN** a roster is given a commitment named "Gym" kept from 1 March 2026, then one named "Run"
  kept from 1 January 2026, both on a schedule listing Monday, Wednesday and Saturday
- **THEN** the roster holds "Gym" first and "Run" second, in the order they were added and not in
  the order of the days they are kept from

#### Scenario: two rosters holding the same commitments in the same order are the same roster

- **WHEN** two rosters are each given a commitment named "Gym", then one named "Run", both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026
- **THEN** the two are the same roster

#### Scenario: two rosters holding the same commitments in a different order are different rosters

- **WHEN** one roster is given a commitment named "Gym" and then one named "Run", and a second
  roster is given the same two the other way round, all on a schedule listing Monday, Wednesday and
  Saturday and all kept from 1 January 2026
- **THEN** the two are different rosters

#### Scenario: adding to a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is copied, and a commitment named "Run" alike in every other
  way is added to the copy
- **THEN** the copy holds two commitments, "Gym" and then "Run"
- **AND** the roster it was copied from still holds one commitment, "Gym", and is not the same
  roster as the copy

#### Scenario: a roster holds a commitment kept from the last supported date like any other

- **WHEN** a roster is given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 31 December 9999, and then one named "Run" alike in every other way but kept
  from 1 January 2026
- **THEN** the roster holds both, in that order, and reads each back with the day it is kept from
  unchanged

#### Scenario: two rosters differing only in the category one commitment is under are different rosters

- **WHEN** two rosters are each given a commitment named "Gym", then one named "Run", both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026, and the first
  is asked to put "Gym" under the category "Sport"
- **THEN** the two are different rosters
- **AND** a third roster given the same two and asked to put "Gym" under "Sport" is the same roster
  as the first

### Requirement: A roster refuses a commitment it already holds

A roster SHALL refuse a commitment equal to one it is already keeping — one it holds and has neither
stopped keeping nor removed. Refusing SHALL leave the roster exactly as it was — the same
commitments, in the same order, with the one already held keeping the position it had **and the
category it is under** — and the roster SHALL report that the commitment was not added. **A category
offered alongside a commitment the roster is already keeping SHALL change nothing**: the category is
held on the roster's entry rather than on the commitment, so it is not one of the things that decide
whether two commitments are the same one, and a refusal that quietly recategorised would be a change
made by an ask that was turned down. Adding a commitment a roster does not hold at all SHALL place
it after every commitment already there, **under the category it was offered under**, and SHALL
report that it was added; a commitment offered **without a category being said at all** SHALL be
added under none.

**A commitment may be offered with a category or without one, and the two are different asks.** A
commitment offered with a category is offered by something that has a category to say — a form a
person has just filled in — and the category it says is applied. A commitment offered without one is
offered by something with nothing to say about categories, and the roster SHALL then leave the
category it holds for that commitment exactly as it is: none for a commitment it does not hold at
all, and whatever it was for a commitment it is taking up again. There is no third form of the ask
and no way to say "leave it alone" while also saying a category, because saying nothing is what
leaving it alone is.

A commitment the roster has stopped keeping is one it still holds, and offering it again SHALL take
it up again rather than being refused. **A commitment the roster has removed is one it still holds
too, and offering it again SHALL take it up again in exactly the same way** — that is the one way
back from a removal, and it exists because a roster never lets a commitment go. In both cases the
roster SHALL drop the day that commitment was kept until, SHALL no longer hold it as removed, SHALL
read the commitment back once more among the commitments it keeps, in the place it has rather than
at the end, **SHALL put it under the category it was offered under where a category was said,
whatever category it was under before, and SHALL leave the category it is under exactly as it is
where none was said,** and SHALL report that the roster now keeps it — the same report an addition
makes, because it says the same thing. It SHALL NOT hold the commitment twice, and there SHALL be no
second way to take one up again: offering it is the way, whichever of the two states it was in.

**The offered category wins on a commitment taken up again, and that is the decision.** A commitment
is offered again with a category by a person filling a form in, and the category on that form is what
they are saying now; keeping the old one would be the roster overriding them, and there would then be
no way to take a category off a commitment while taking it up again. Being offered under no category
therefore takes the category off. Offering it again *without saying a category* — which is what a
screen's one tap on a stopped commitment does, since that tap asks for nothing — leaves the category
alone, so a commitment taken up again that way comes back under the category it was under.

Taking a commitment up again SHALL change what the dates between the day it was kept until and the
day it was offered again answer about that commitment, and that is the decision rather than an
oversight. A roster holds at most one kept-until day for a commitment and holds no span of them, so
a commitment with no kept-until day is one it was keeping on every date. The alternative — refusing,
so that starting again means a commitment kept from a different day — was weighed and rejected: it
leaves a mis-tapped stop with no way back, and the commitment that came back would be a different
one, losing the place it has and starting a fresh history. What was actually done on
those days is untouched either way, because that is the ticks and no tick moves. What a screen
offers, and whether it says that the days between will read as kept, is the screen's.

Reporting is part of the refusal and MUST NOT be dropped. A caller that does not care may ignore
what it is told, but a caller that does care cannot recover a report that was never made: doing
nothing and saying nothing is indistinguishable to a person from having added a second commitment,
which is the one thing a roster exists to prevent. Whether anything is said on a screen, and in what
words, is not this requirement's — it is what a screen does with the report.

Two commitments are the same commitment when their name, their schedule, the day they are kept from
and the kind their days take are all the same, and a roster SHALL use those four and nothing else to
decide what it already holds — when it refuses one it is keeping, and when it takes one up again
that it had stopped or removed. **The category is expressly not a fifth**, in either direction: a
commitment offered under one category and held under another is still the commitment the roster
holds, and two commitments alike in all four parts are still one commitment however they are filed.
A roster MUST NOT invent a coarser sameness of its own either: two commitments
alike in name but differing in schedule, in the day they are kept from or in the kind their days
take are different commitments and a roster SHALL hold both, and two names differing only by blank
space are different names, because a commitment's name is stored exactly as it was given and tidying
it belongs where a person typed it. A weight and a mood kept under one name, on one rhythm, from one
day differ in what their days hold and are two commitments; a roster judging them alike would leave
a person unable to say which of the two a screen was pointing at.

This is why the refusal exists at all. A commitment carries no identifier, so a roster holding two
commitments a person would call identical could not be told which of them to stop keeping, which of
them to remove, which of them to change, or which of them a screen was pointing at. There is nothing
to tell them apart by, and so there must not be two.

A roster SHALL refuse nothing else that it is offered to add. It MUST NOT judge a name, a schedule,
a day a commitment is kept from, a kind or a category — anything that is a commitment at all was
already accepted when the commitment was formed, and a range that could not be a range or a target
that could not be a target never reached a commitment to be offered here — it MUST NOT refuse on how
many commitments it holds, and it MUST NOT refuse on a date. What a roster refuses when it is asked
to *stop* keeping a commitment, and when it is asked to *remove* one, are separate rules, and this
one neither states them nor narrows them.

#### Scenario: adding a commitment a roster does not hold places it after the ones already there and says it was added

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is given one named "Run" alike in every other way
- **THEN** the roster reports that the commitment was added
- **AND** the roster holds two commitments, "Gym" first and "Run" second

#### Scenario: adding a commitment a roster already holds says it was not added and leaves the roster as it was

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is given a second commitment formed with that same name, that
  same schedule and that same day
- **THEN** the roster reports that the commitment was not added
- **AND** the roster still holds exactly one commitment, named "Gym"
- **AND** it is the same roster as one given that commitment once

#### Scenario: a refused commitment does not move the one already held

- **WHEN** a roster is given a commitment named "Gym", then one named "Run", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January
  2026, and is then given a second commitment alike in every way to "Gym"
- **THEN** the roster still holds three commitments in the order "Gym", "Run", "Journaling", with
  "Gym" in the position it already had and not moved to the end

#### Scenario: two commitments alike in name but on different schedules are both held

- **WHEN** a roster is given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and then one named "Gym" on a schedule listing Tuesday and
  Thursday, kept from that same day
- **THEN** the roster reports that the second commitment was added
- **AND** the roster holds two commitments, both named "Gym"

#### Scenario: two commitments alike in name and schedule but kept from different days are both held

- **WHEN** a roster is given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and then one alike in name and schedule but kept from
  2 January 2026
- **THEN** the roster reports that the second commitment was added
- **AND** the roster holds two commitments, both named "Gym"

#### Scenario: two names differing only by a space at the end are different commitments and both are held

- **WHEN** a roster is given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and then one named "Gym " — the same word with a trailing
  space — alike in every other way
- **THEN** the roster reports that the second commitment was added
- **AND** the roster holds two commitments, the first reading back as "Gym" and the second as "Gym "

#### Scenario: offering a commitment the roster has stopped keeping takes it up again

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, has stopped keeping it as of 31 January 2026, and is then
  given a commitment formed with that same name, that same schedule and that same day
- **THEN** the roster reports that it now keeps the commitment
- **AND** the roster reads back that one commitment and no second copy of it
- **AND** it is the same roster as one given that commitment once and never asked to stop keeping it

#### Scenario: a commitment taken up again keeps the place it was taken on in

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January
  2026, stops keeping "Gym" as of 31 January 2026 and is then given a commitment alike in every way
  to "Gym"
- **THEN** the roster reports that it now keeps the commitment
- **AND** the roster reads back three commitments in the order "Water plants", "Gym", "Journaling",
  with "Gym" in the place it was taken on in and not at the end

#### Scenario: two commitments alike in every way but the kind their days take are both held

- **WHEN** a roster holding a commitment named "Weight" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, of the number kind with a range of 40 to 150, is given one
  named "Weight" alike in name, schedule and the day it is kept from but of the note kind
- **THEN** the roster reports that the commitment was added
- **AND** the roster holds two commitments, the number one first and the note one second
- **AND** offering the number one again is refused

#### Scenario: offering a commitment the roster has removed takes it up again, in the place it was taken on in

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January
  2026, removes "Gym" as of 31 January 2026, and is then given a commitment formed with that same
  name, that same schedule and that same day
- **THEN** the roster reports that it now keeps the commitment
- **AND** the roster reads back three commitments in the order "Water plants", "Gym", "Journaling",
  with "Gym" in the place it was taken on in and not at the end
- **AND** it is the same roster as one given the three in that order and never asked to remove any of
  them

#### Scenario: a commitment taken up again after being removed is kept on every date again

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, removes it as of 31 January 2026, and is then given that same
  commitment again
- **THEN** it answers with that commitment on 31 January 2026, on 1 February 2026 and on 1 March 2026
- **AND** the roster reads back that one commitment and no second copy of it

#### Scenario: a commitment moved and then stopped is taken up again in the place it was moved to

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, moves "Journaling" to the offset 0, stops keeping it as of 31 January 2026, and is
  then given that same commitment again
- **THEN** the roster reports that it now keeps the commitment
- **AND** it reads back three commitments in the order "Journaling", "Water plants", "Gym"

#### Scenario: a commitment a roster does not hold is added under the category it was offered under

- **WHEN** a roster is given a commitment named "Creatine" on a schedule listing all seven weekdays,
  kept from 1 January 2026, under the category "Supplements", then one named "Gym" alike in
  every other way under no category, and then one named "Journaling" alike in every other way with
  no category said at all
- **THEN** the roster reports that each was added
- **AND** it reads back two groups, one under "Supplements" holding "Creatine" and one under no
  category holding "Gym" and then "Journaling"

#### Scenario: a commitment offered again with no category said keeps the category it was under

- **WHEN** a roster given a commitment named "Creatine" on a schedule listing all seven weekdays,
  kept from 1 January 2026, under the category "Supplements", stops keeping it as of
  31 January 2026, and is then given a commitment alike in every way with no category said at all
- **THEN** the roster reports that it now keeps the commitment
- **AND** it reads back one group, under "Supplements", holding "Creatine"

#### Scenario: a commitment taken up again is put under the category it was offered under

- **WHEN** a roster given a commitment named "Creatine" on a schedule listing all seven weekdays,
  kept from 1 January 2026, under the category "Supplements", stops keeping it as of
  31 January 2026, and is then given a commitment alike in every way under the category "Morning"
- **THEN** the roster reports that it now keeps the commitment
- **AND** it reads back one group, under "Morning", holding "Creatine"
- **AND** a roster alike in every way offered it again under no category instead reads back one
  group, under no category, holding "Creatine"

#### Scenario: a commitment a roster is already keeping is refused whatever category it is offered under

- **WHEN** a roster given a commitment named "Creatine" on a schedule listing all seven weekdays,
  kept from 1 January 2026, under the category "Supplements", is offered a commitment alike in
  every way under the category "Morning"
- **THEN** the roster reports that the commitment was not added
- **AND** it reads back one group, under "Supplements", holding "Creatine"
- **AND** it is the same roster as one given that commitment once under "Supplements" and asked
  nothing else

### Requirement: A roster moves a commitment among the ones it keeps

A roster SHALL move a commitment it is keeping, on being given that commitment, an **offset** — a
place counted over the commitments the roster is keeping **as they stand before the move**, running
from 0, before the first of them, to the number it is keeping, which is after the last — and the
**category** to put it under, which may be none. Moving SHALL put the commitment under that category
and SHALL report that the roster moved the commitment. This is the only thing that ever changes a
roster's order.

**A move carries a category because the gesture does.** A row dropped into another group's rows has
been moved and recategorised by one drag, and a roster that took the two separately would keep one of
them where the other could not be kept. Where a move is asked for with the category the commitment
is already under, the category is the one it already had and nothing about it changes; the category
is applied on every move rather than only on some, so there is no move that silently leaves it alone.

**The moved commitment is put where the offset points, and nothing else is picked up.** Unless the
offset is one of the two that ask for the place the commitment already has — the offset it is at
among the commitments the roster is keeping, and the one just after that — the commitment SHALL be
taken out of the sequence the roster holds and put back immediately before the commitment that stood
at that offset among the ones the roster was keeping, or immediately after the last of them where
the offset is the number it is keeping. Every other commitment the roster holds SHALL afterwards be
in the order it was in — kept, stopped and removed alike — and no two of them SHALL be reordered
against each other. A stopped or removed commitment lying between where the moved commitment was and
where it goes is passed rather than pushed: the moved commitment goes by, and it stands still.

**On those two offsets the commitment SHALL NOT be taken out of the sequence at all**, and nothing
in the sequence SHALL move. The carve-out is not tidiness: taking the commitment out and putting it
back immediately before whatever stood at the offset just after its own would walk it past a stopped
or removed commitment lying between the two, and hand back a roster that is not the roster it was.
**The carve-out is about the sequence and not about the category**: a move on one of those two
offsets still puts the commitment under the category it was moved under, because the offset says
where and the category says what, and only the first of the two has anything to carve out.
The paragraph below says why both offsets ask for the place the commitment already has.

**An offset is counted over the commitments the roster is keeping and over nothing else.** The
commitments a roster has stopped keeping or removed are in its order but not in that count, because
the list a person is looking at when they move something is the list of what they keep; a place
counted over all three states would be a number nothing shows. It is counted over the order the
roster holds and not over the order the roster **draws** — the groups are a reading of that order,
and the screen that draws them is where a place on the screen becomes a place in the order.

**The price of one order over three states, taken knowingly.** A commitment the roster has stopped
keeping has a place in the sequence and holds it, so taking it up again returns it exactly there —
but the commitments around it may have moved since, so what it comes back beside is where the
sequence now puts it and not the neighbour it used to have. That is what one order over everything a
roster holds costs. The alternative, an order per state, would mean a roster holding more than one
order, which it is not.

**An offset that puts a commitment where it already is, under the category it is already under,
SHALL be accepted**, SHALL report that the roster moved it, and SHALL leave the roster the same
roster it was. Two offsets do this for any commitment — the one it is at, and the one just after it
— and they arrive there differently. The
offset it is at names the moved commitment itself, and immediately before itself is where it already
stands. The offset just after it names the **next** commitment the roster is keeping and not the
moved one — or, where the moved commitment is the last one kept, is the number kept, which is after
the last of them and so is again where it already stands — and a commitment is already immediately
before the one that follows it among the ones the roster is keeping. Neither offset asks for a
commitment the roster is keeping to stand anywhere new, so nothing in the sequence the roster holds
moves at all: a stopped or removed commitment lying between the moved one and the one that follows
it is not passed, because nothing goes by it. This is not a refusal: the roster's refusals are about
a move it cannot make at all, and this is one it can make whose result is the roster it already had.
A person who picks a row up and puts it back has made no mistake to be told about.

The roster SHALL refuse to move a commitment in exactly two cases, and SHALL report each rather than
doing nothing silently, for the same reason a refused addition is reported:

- **a commitment it is not keeping** — one it does not hold at all, one it has stopped keeping, or
  one it has removed. A stopped or a removed commitment already has its place, and a move that
  reached one would rearrange an order against a list nobody moves things on.
- **an offset below 0, or above the number of commitments the roster is keeping.** Not clamped. A
  clamp puts a commitment somewhere nobody asked for, which is the silently-wrong-thing the roster's
  other refusals exist to prevent; no gesture can produce such an offset, but a gesture is not the
  only way in.

A roster asked either SHALL be left exactly as it was, **its categories included**: a refused move
puts nothing under anything.

**A move takes no date and moves none.** The roster SHALL NOT be asked what day it is for a move,
SHALL NOT record when one happened, and SHALL NOT change any day a commitment was kept until or any
commitment's own day it is kept from. Moving SHALL change nothing about the commitment itself and
nothing about what has been recorded against it: every tick already recorded SHALL stand, and the
commitment SHALL go on answering whether it is due on a date exactly as it did before. That holds of
the category a move carries as much as of the place: a category is the roster's, so putting a
commitment under one re-keys nothing.

A roster SHALL be a value here too: moving a commitment SHALL leave every other roster untouched,
and two rosters holding the same commitments in a different order are already different rosters.

#### Scenario: moving a commitment to the end puts it after every commitment the roster is keeping

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, is asked to move "Water plants" to the offset 3, counted over the three commitments
  it is keeping
- **THEN** the roster reports that it moved the commitment
- **AND** it reads back three commitments in the order "Gym", "Journaling", "Water plants"

#### Scenario: moving a commitment to the front puts it before every commitment the roster is keeping

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, is asked to move "Journaling" to the offset 0
- **THEN** the roster reports that it moved the commitment
- **AND** it reads back three commitments in the order "Journaling", "Water plants", "Gym"

#### Scenario: an offset is counted over the commitments the roster is keeping as they stand before the move

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, is asked to move "Water plants" to the offset 2
- **THEN** it reads back three commitments in the order "Gym", "Water plants", "Journaling", the
  offset naming "Journaling" — the commitment that stood at it before the move — as the one the moved
  commitment comes to stand before
- **AND** a roster alike in every way asked to move "Water plants" to the offset 3 instead reads back
  "Gym", "Journaling", "Water plants"

#### Scenario: a stopped commitment between the two places is passed rather than pushed

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", then one named "Reading", all on a schedule listing Monday, Wednesday and Saturday
  and all kept from 1 January 2026, stops keeping "Gym" as of 31 January 2026, and is then asked to
  move "Water plants" to the offset 2, counted over the three commitments it is then keeping
- **THEN** the roster reports that it moved the commitment
- **AND** it reads back three commitments it is keeping, in the order "Journaling", "Water plants",
  "Reading"
- **AND** asked about 31 January 2026 it answers with "Gym", then "Journaling", then "Water plants",
  then "Reading" — "Gym" first, where it has been since it was taken on
- **AND** a roster that had removed "Gym" as of that same day instead answers with those four in that
  same order

#### Scenario: an offset of nothing at all puts a commitment before the first one kept and not before a stopped one

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, stops keeping "Water plants" as of 31 January 2026, and is then asked to move
  "Journaling" to the offset 0
- **THEN** the roster reports that it moved the commitment
- **AND** it reads back two commitments it is keeping, "Journaling" and then "Gym"
- **AND** asked about 31 January 2026 it answers with "Water plants", then "Journaling", then "Gym",
  the stopped commitment still first

#### Scenario: two offsets leave a commitment where it already is, and both are accepted

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, is asked to move "Gym" to the offset 1, and a roster alike in every way is asked to
  move "Gym" to the offset 2
- **THEN** each reports that it moved the commitment
- **AND** each reads back "Water plants", "Gym", "Journaling"
- **AND** each is the same roster as one that was never asked

#### Scenario: the offset just after a commitment's own passes nothing, with a stopped or removed commitment lying between

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", then one named "Reading", all on a schedule listing Monday, Wednesday and Saturday
  and all kept from 1 January 2026, stops keeping "Journaling" as of 31 January 2026, and is then
  asked to move "Gym" to the offset 2 — the offset just after "Gym"'s own among the three it is then
  keeping, which names "Reading" and not "Gym", with the stopped "Journaling" lying between the two
- **THEN** the roster reports that it moved the commitment
- **AND** the roster is the same roster as one that was never asked, "Journaling" still standing
  between "Gym" and "Reading" rather than passed
- **AND** a roster that had removed "Journaling" as of that same day instead reports that it moved
  the commitment and is likewise the same roster as one that was never asked

#### Scenario: moving a commitment the roster is not keeping says it was not moved and leaves the roster as it was

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, stops keeping "Gym" as of 31 January 2026 and removes "Journaling" as of that same
  day, and is then asked to move "Gym" to the offset 0
- **THEN** the roster reports that it did not move the commitment
- **AND** the roster is the same roster as one that was never asked
- **AND** asking it to move "Journaling" to the offset 0, and asking it to move a commitment named
  "Run" alike in every other way to "Water plants" and never given to it, each report that it did not
  move the commitment and leave the roster the same

#### Scenario: an offset below zero and one above the number of commitments kept are both refused

- **WHEN** a roster given a commitment named "Water plants" and then one named "Gym", both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026, is asked to move
  "Gym" to the offset -1
- **THEN** the roster reports that it did not move the commitment
- **AND** the roster is the same roster as one that was never asked
- **AND** asking it to move "Gym" to the offset 3, one above the two commitments it is keeping,
  reports that it did not move the commitment and leaves the roster the same

#### Scenario: moving a commitment moves no day and changes no commitment

- **WHEN** a roster given a commitment named "Water plants" kept from 1 January 2026, then one named
  "Gym" kept from 1 March 2026, then one named "Journaling" kept from 1 June 2026, all on a schedule
  listing Monday, Wednesday and Saturday, stops keeping "Water plants" as of 31 January 2026, and is
  then asked to move "Journaling" to the offset 0
- **THEN** the roster answers with "Water plants" on 31 January 2026 and without it on
  1 February 2026, the day it was kept until unmoved
- **AND** each of the three reads back the day it is kept from unchanged
- **AND** "Gym" is due on Monday 2 March 2026 and not due on Tuesday 3 March 2026, exactly as it was
  before

#### Scenario: moving a commitment on a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Water plants" and then one named "Gym", both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026, is copied, and
  the copy moves "Gym" to the offset 0
- **THEN** the copy reads back "Gym" and then "Water plants"
- **AND** the roster it was copied from still reads back "Water plants" and then "Gym", and is not
  the same roster as the copy

#### Scenario: a roster keeping one commitment accepts both the offsets it has

- **WHEN** a roster holding one commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to move it to the offset 0, and a roster alike in
  every way is asked to move it to the offset 1
- **THEN** each reports that it moved the commitment
- **AND** each is the same roster as one that was never asked
- **AND** a roster alike in every way asked to move it to the offset 2 reports that it did not move
  the commitment

#### Scenario: a move puts a commitment under the category it was moved under

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, is asked to move "Journaling" to the offset 0 under the category "Sport"
- **THEN** the roster reports that it moved the commitment
- **AND** it reads back two groups, one under "Sport" holding "Journaling" and one under no category
  holding "Water plants" and then "Gym"

#### Scenario: a move under no category takes a commitment's category off

- **WHEN** a roster given a commitment named "Gym" and then one named "Journaling", both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026, puts "Gym"
  under the category "Sport", and is then asked to move "Gym" to the offset 2 under no category
- **THEN** the roster reports that it moved the commitment
- **AND** it reads back one group, under no category, holding "Journaling" and then "Gym"

#### Scenario: a move to the place a commitment already has still puts it under the category it was moved under

- **WHEN** a roster given a commitment named "Gym" and then one named "Journaling", both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026, is asked to
  move "Gym" to the offset 0 under the category "Sport"
- **THEN** the roster reports that it moved the commitment
- **AND** it reads back two groups, one under "Sport" holding "Gym" and one under no category
  holding "Journaling"
- **AND** it is not the same roster as one that was never asked

#### Scenario: a refused move puts a commitment under no category at all

- **WHEN** a roster given a commitment named "Gym" and then one named "Journaling", both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026, stops keeping
  "Gym" as of 31 January 2026, and is then asked to move "Gym" to the offset 0 under the category
  "Sport"
- **THEN** the roster reports that it did not move the commitment
- **AND** the roster is the same roster as one that was never asked
- **AND** asking it to move "Journaling" to the offset -1 under "Sport" likewise reports that it did
  not move the commitment and leaves the roster the same

### Requirement: A roster store keeps a roster at a place, across the app being closed and opened again

A roster store SHALL be opened at a place, and SHALL hold a roster: every commitment taken on
through it, in the order the roster holds them, against each commitment the category it is under,
and against each commitment it has stopped keeping
or removed, the day that commitment was kept until, and against each commitment it has removed, that it
was removed. Opening a roster store at a place where nothing has been kept SHALL give a roster
holding nothing rather than an error — that is what the first launch looks like, and it is the only
time a roster store opens holding nothing.

A commitment taken on through a roster store SHALL be kept at that place before the store reports it
taken on, so that a store opened at the same place afterwards — by the app opened again, or by
anything else, and whether or not the first store was ever closed — holds it. Stopping a commitment
SHALL be kept the same way, and so SHALL removing one, moving one, putting one under a category, and
taking one up again. There is no
separate step at which a roster store is saved: the app can be stopped at any moment without
warning, and a commitment waiting to be saved would be one a person believes they have taken on. A
roster store that cannot keep a change MUST refuse it and MUST NOT hold it: the roster a store
reports is never ahead of what is kept at its place.

A roster store SHALL report exactly what the roster reports, and MUST NOT turn a roster's own refusal
into an error. Offering a commitment the roster is already keeping, asking it to stop keeping one it
does not hold, asking it to stop keeping one it has already stopped or removed, and asking it to
remove one it does not hold or has already removed, asking it to move one it is not keeping or
to move one to an offset outside the commitments it is keeping, and asking it to put one it is not
keeping under a category each leave the roster exactly as it was — so nothing is kept at the place,
and the store says what the roster said. **A change that leaves
the roster exactly as it was SHALL keep nothing at the place either, and SHALL still report what the
roster reported** — a move that put a commitment back where it already was under the category it was
already under, and a category change that put a commitment under the category it was already under,
are both such a change: a store keeps what a change made, and a
change that made none has nothing to keep. What a roster accepts, what it
refuses and what it takes up again are the roster's own rules, stated above, and a store adds nothing
to them and takes nothing away.

A roster store SHALL persist exactly what a roster is — each commitment with the name, the
schedule, the day it is kept from and the kind its days take that the commitment is made of,
together with whatever that kind carries; against each commitment the category it is under, and
that it is under none where it is under none; against each stopped or removed commitment the day it was
kept until; and against each removed commitment that it was removed — and nothing it invented. A
number commitment's range SHALL be kept where it has one and SHALL be absent where it has none, both
ends exactly as they were given; a total commitment's target SHALL be kept exactly as it was given,
decimal fraction and all, and MUST NOT be rounded, widened or narrowed on the way in or out. **A
category SHALL be kept exactly as it was given**, blank space at either end and all, and MUST NOT be
trimmed, case-folded, deduplicated against another category or turned into a reference to a list of
categories kept somewhere else: there is no such list, and the categories that exist are exactly the
words the commitments carry. It
SHALL keep the commitments in the order the roster holds them and read them back in that order,
because the order is one of the things a roster is — and it is the person's, so a store that
reordered would be overwriting a decision rather than tidying a history. A roster store MUST NOT
impose an order of its own, MUST NOT sort by name, by a day, by a category or by anything else, and
MUST NOT write its commitments grouped: the groups are a reading of the roster's one order and are
worked out again on every read, so a store that wrote them would be keeping the same fact twice. A roster read back SHALL be the same roster
that was kept, for every schedule shape, for every kind, for any name a commitment can have, for any
category a commitment can be under, for any
date the system supports, and for each of the three states a roster holds a commitment in. The store
MUST NOT key anything to the moment it was entered, MUST NOT record the day a commitment was taken
on, and MUST NOT pass a calendar date through an instant, a time zone or a locale on the way in or
out.

Roster stores at different places SHALL be independent of each other, and a roster store SHALL be
independent of any store keeping anything else: taking on a commitment, stopping one, removing one,
moving one or putting one under a category MUST NOT change what is kept at any other place.

#### Scenario: a roster store opened where nothing has been kept holds a roster holding nothing

- **WHEN** a roster store is opened at a place where no roster store has ever been kept
- **THEN** it opens without error
- **AND** its roster is the same roster as one that has been given no commitment

#### Scenario: a commitment taken on through a roster store is held by a second store opened at the same place while the first is still open

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store, and a second roster store is then opened at the
  same place with the first still open and nothing else done to it
- **THEN** the first store reports that the commitment was added
- **AND** the second store's roster is the same roster as one given that commitment once

#### Scenario: a roster store opened again holds its commitments in the order they were taken on

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  three on a schedule listing Monday, Wednesday and Saturday and all three kept from 1 January 2026,
  are taken on through a roster store, and a store is opened afterwards at the same place
- **THEN** the later store's roster reads back those three commitments in that order — "Water
  plants", then "Gym", then "Journaling" — and not in alphabetical order
- **AND** its roster is the same roster as one given the three in that order

#### Scenario: a commitment stopped through a roster store is read back stopped, on the day it was kept until

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken on
  through a roster store; the store is asked to stop keeping "Gym" as of 31 January 2026; and a store
  is opened afterwards at the same place
- **THEN** the store reports that it stopped keeping the commitment
- **AND** the later store's roster, asked about 31 January 2026, answers with all three in the order
  "Water plants", "Gym", "Journaling"
- **AND** asked about 1 February 2026 it answers with "Water plants" and then "Journaling"

#### Scenario: a commitment taken up again through a roster store is read back kept, in the place it was taken on in

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken on
  through a roster store; the store is asked to stop keeping "Gym" as of 31 January 2026; the store is
  then given a commitment alike in every way to "Gym"; and a store is opened afterwards at the same
  place
- **THEN** the later store's roster reads back three commitments in the order "Water plants", "Gym",
  "Journaling", with "Gym" in the place it was taken on in and not at the end
- **AND** its roster is the same roster as one given the three in that order and never asked to stop
  keeping any of them

#### Scenario: a commitment a roster store is already keeping is refused and nothing at its place changes

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store; a second commitment formed with that same name,
  that same schedule and that same day is then offered to it; and a store is opened afterwards at the
  same place
- **THEN** the store reports that the second commitment was not added, and does not report an error
- **AND** its roster still holds exactly one commitment, named "Gym"
- **AND** the later store's roster is the same roster as one given that commitment once

#### Scenario: a stop a roster store refuses is reported and nothing at its place changes

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store and the store is asked to stop keeping it as of
  31 January 2026; the store is then asked to stop keeping it again as of 28 February 2026, and asked
  to stop keeping a commitment named "Run" alike in every other way as of 31 January 2026; and a store
  is opened afterwards at the same place
- **THEN** the store reports of each of those two askings that it did not stop keeping the
  commitment, and reports no error
- **AND** the later store's roster answers with "Gym" on 31 January 2026 and with nothing on
  1 February 2026, the day first given standing
- **AND** its roster is the same roster as one given "Gym" and asked once to stop keeping it as of
  31 January 2026

#### Scenario: commitments on every schedule shape are read back as the same commitments

- **WHEN** one commitment on each schedule shape the system has is taken on through a roster store —
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026; a commitment named "Finances" on a schedule on the 25th of the month, kept from that same day;
  a commitment named "Plants" on a schedule of every 3 days starting on 25 August 2026, kept from
  1 September 2026; and a commitment named "Reading" on a weekly quota of 3 times a week, kept from
  1 January 2026 — in that order, and a store is opened afterwards at the same place
- **THEN** the later store's roster is the same roster as one given those same four commitments in
  that same order
- **AND** it reads back all four, in that order

#### Scenario: a commitment name is read back out of a roster store exactly, whatever it contains

- **WHEN** a commitment whose name is "Zürich — „langer“ Lauf 🏃" followed by a line break and the
  word "Sonntags", on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, is
  taken on through a roster store, and a store is opened afterwards at the same place
- **THEN** the later store's roster reads back one commitment whose name is exactly that
- **AND** its roster is the same roster as one given that commitment once

#### Scenario: a roster kept from the first supported date and stopped on the last is read back unchanged

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 1583, and then one named "Run" alike in every other way but kept from 31 December 9999,
  are taken on through a roster store; the store is asked to stop keeping "Gym" as of 31 December
  9999; and a store is opened afterwards at the same place
- **THEN** the later store's roster is the same roster as one given those two commitments in that
  order and asked to stop keeping the first as of 31 December 9999
- **AND** asked about 31 December 9999 it answers with both, "Gym" first and "Run" second

#### Scenario: roster stores at different places hold different rosters

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store at one place, and a roster store is opened at a
  different place where nothing has been kept
- **THEN** the second store's roster is the same roster as one that has been given no commitment
- **AND** a roster store opened afterwards at the first place reads back that one commitment

#### Scenario: a change that cannot be kept is refused and not held

- **WHEN** a roster store is opened at a place where nothing can be written — a path beneath an
  existing ordinary file — and a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is offered to it
- **THEN** taking the commitment on is refused with an error
- **AND** the store's roster is still the same roster as one that has been given no commitment
- **AND** a roster store opened afterwards at the same place holds a roster holding nothing

#### Scenario: a commitment of each kind is read back as the same commitment

- **WHEN** one commitment of each kind the system has is taken on through a roster store — a
  commitment named "Gym" of the tick kind; one named "Weight" of the number kind with no range; one
  named "Mood" of the number kind with a range of 1 to 10; one named "Journal" of the note kind; and
  one named "Protein" of the total kind with a target of 120 — all five on a schedule listing
  Monday, Wednesday and Saturday, all kept from 1 January 2026, in that order, and a store is opened
  afterwards at the same place
- **THEN** the later store's roster is the same roster as one given those same five commitments in
  that same order
- **AND** it reads back all five, in that order, each of the kind it was given

#### Scenario: a range and a target are read back exactly, decimal fractions and all

- **WHEN** a commitment named "Weight" of the number kind with a range of -40.5 to 150.25, and one
  named "Protein" of the total kind with a target of 119.95, both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store, and
  a store is opened afterwards at the same place
- **THEN** the later store's roster reads back a range whose lowest is -40.5 and whose highest is
  150.25, and a target of 119.95
- **AND** its roster is the same roster as one given those two commitments in that order

#### Scenario: a commitment removed through a roster store is read back removed, on the day it was kept until

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken on
  through a roster store; the store is asked to remove "Gym" as of 31 January 2026; and a store is
  opened afterwards at the same place
- **THEN** the store reports that it removed the commitment
- **AND** the later store's roster is the same roster as one given the three in that order and asked
  to remove "Gym" as of 31 January 2026
- **AND** the later store's roster, asked about 31 January 2026, answers with all three in the order
  "Water plants", "Gym", "Journaling", and asked about 1 February 2026 answers with "Water plants"
  and then "Journaling"

#### Scenario: a removal a roster store refuses is reported and nothing at its place changes

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store and the store is asked to remove it as of
  31 January 2026; the store is then asked to remove it again as of 28 February 2026, and asked to
  remove a commitment named "Run" alike in every other way as of 31 January 2026; and a store is
  opened afterwards at the same place
- **THEN** the store reports of each of those two askings that it did not remove the commitment, and
  reports no error
- **AND** the later store's roster answers with "Gym" on 31 January 2026 and with nothing on
  1 February 2026, the day first given standing
- **AND** its roster is the same roster as one given "Gym" and asked once to remove it as of
  31 January 2026

#### Scenario: a commitment taken up again through a roster store after being removed is read back kept

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken on
  through a roster store; the store is asked to remove "Gym" as of 31 January 2026; the store is then
  given a commitment alike in every way to "Gym"; and a store is opened afterwards at the same place
- **THEN** the later store's roster reads back three commitments in the order "Water plants", "Gym",
  "Journaling", with "Gym" in the place it was taken on in and not at the end
- **AND** its roster is the same roster as one given the three in that order and never asked to remove
  any of them

#### Scenario: a removal that cannot be kept is refused and the roster a store reports does not move

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store; what is at that place is then made impossible to
  write; and the store is asked to remove "Gym" as of 31 January 2026
- **THEN** removing the commitment is refused with an error
- **AND** the store's roster is still the same roster as one given that commitment once and asked
  nothing else

#### Scenario: a commitment moved through a roster store is read back in the place it was moved to

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken on
  through a roster store; the store is asked to move "Journaling" to the offset 0; and a store is
  opened afterwards at the same place
- **THEN** the store reports that it moved the commitment
- **AND** the later store's roster reads back three commitments in the order "Journaling", "Water
  plants", "Gym"
- **AND** its roster is the same roster as one given the three in that order and never moved

#### Scenario: a move a roster store refuses is reported and nothing at its place changes

- **WHEN** a commitment named "Water plants" and one named "Gym", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store; the
  store is asked to move a commitment named "Run" alike in every other way, and never taken on, to
  the offset 0; and a store is opened afterwards at the same place
- **THEN** the store reports that it did not move the commitment, and does not report an error
- **AND** the later store's roster reads back "Water plants" and then "Gym"

#### Scenario: a move that leaves a roster as it was keeps nothing at its place

- **WHEN** a commitment named "Water plants" and one named "Gym", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store; the
  content at that place is read; and the store is then asked to move "Gym" to the offset 2
- **THEN** the store reports that it moved the commitment
- **AND** the content at that place is byte-for-byte what was read before the move
- **AND** the store's roster reads back "Water plants" and then "Gym"

#### Scenario: a move that cannot be kept is refused and the roster a store reports does not move

- **WHEN** a commitment named "Water plants" and one named "Gym", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store; what
  is at that place is then made impossible to write; and the store is asked to move "Gym" to the
  offset 0
- **THEN** the move is refused
- **AND** the store's roster still reads back "Water plants" and then "Gym"

#### Scenario: a commitment put under a category through a roster store is read back under it

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Journaling", all on
  a schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken on
  through a roster store; the store is asked to put "Creatine" under the category "Supplements"; and
  a store is opened afterwards at the same place
- **THEN** the store reports that it put the commitment under the category
- **AND** the later store's roster reads back two groups, one under "Supplements" holding "Creatine"
  and one under no category holding "Gym" and then "Journaling"
- **AND** its roster is the same roster as one given the three in that order and asked to put
  "Creatine" under "Supplements"

#### Scenario: a category is read back out of a roster store exactly, blank space and all

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store;
  "Creatine" is put under the category " Supplements " and "Gym" under the category "Supplements";
  and a store is opened afterwards at the same place
- **THEN** the later store's roster reads back two groups, the first under " Supplements " with both
  spaces and the second under "Supplements"
- **AND** neither group holds both commitments

#### Scenario: a category change a roster store refuses is reported and nothing at its place changes

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store and the store is asked to stop keeping it as of
  31 January 2026; the store is then asked to put it under the category "Sport"; and a store is
  opened afterwards at the same place
- **THEN** the store reports that it did not put the commitment under the category, and reports no
  error
- **AND** its roster is the same roster as one given "Gym" and asked once to stop keeping it as of
  31 January 2026

#### Scenario: a category change that leaves a roster as it was keeps nothing at its place

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store;
  "Gym" is put under the category "Sport"; the content at that place is read; and the store is then
  asked to put "Gym" under "Sport" again
- **THEN** the store reports that it put the commitment under the category
- **AND** the content at that place is byte-for-byte what was read before that second asking

#### Scenario: a category change that cannot be kept is refused and the roster a store reports does not move

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store; what is at that place is then made impossible
  to write; and the store is asked to put "Gym" under the category "Sport"
- **THEN** putting the commitment under the category is refused with an error
- **AND** the store's roster is still the same roster as one given that commitment once and asked
  nothing else

#### Scenario: a commitment moved under a category through a roster store is read back moved and under it

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken
  on through a roster store; the store is asked to move "Journaling" to the offset 0 under the
  category "Sport"; and a store is opened afterwards at the same place
- **THEN** the store reports that it moved the commitment
- **AND** the later store's roster reads back two groups, one under "Sport" holding "Journaling" and
  one under no category holding "Water plants" and then "Gym"

### Requirement: A roster store reads a roster kept before a commitment carried a kind

A roster store SHALL read a roster kept in any form this app has written before the one it writes
now, rather than refusing it, and SHALL read each such roster as the roster it was. Three earlier
forms exist. The form written **before a commitment carried a kind** holds no kind for any commitment, and
every commitment in it SHALL be read as being of the plain kind — a tick is what every one of them
was: reading them any other way would change what a person keeps, and refusing them would tell a
person who has kept a roster since before this change that they keep nothing. The form written
**before a commitment could be removed** holds nothing about removal for any commitment, and every
commitment in it SHALL be read as one the roster has not removed, which every one of them was. The
form written **before a commitment could be put under a category** holds nothing about a category for
any commitment, and every commitment in it SHALL be read as one the roster holds under no category —
which every one of them was, and which is an ordinary state rather than a gap, so nothing needs
inventing to fill it.

Reading a roster kept in an earlier form MUST NOT change what is at the place. A store writes on a
change being kept and at no other moment, so opening the app and doing nothing SHALL leave the
content byte-for-byte what it was, in the form it was already in. The next change kept there SHALL
be written in the form this app writes, whole, and everything the earlier form held SHALL still be
in it — the order the commitments were taken on, every day one was kept until, and every part of
every commitment.

**Each form SHALL be read as the shape that form has.** A roster store declares its form before
anything else in it is read, so what may be in it is known rather than guessed at. Whether a stored
roster says anything about removal SHALL agree with the form it declares, in both directions: a
roster store declaring a form written before a commitment could be removed and yet saying something
about removal SHALL be refused as content that is not a roster store, and so SHALL one declaring the
form this app writes and saying nothing about removal. **Whether it says anything about a category
SHALL agree with the form it declares in exactly the same two directions**: a store declaring a form
written before a commitment could be put under a category and yet saying something about one SHALL
be refused as content that is not a roster store, and so SHALL one declaring the form this app
writes and saying nothing about a category for a commitment. A commitment under no category is said
so rather than left unsaid, which is what lets the two be told apart at all —
reading it any other way would make the declared form decorative — every form would accept every
other form's shape — and would launder a file this app never wrote into a current-form one the next
time something was kept there. The
rule that a commitment carrying no kind is read as a tick is unchanged and is stated above; that is what
an *absent* part means where the part belongs to the commitment, and this paragraph is about what a
*form* is allowed to contain.

The forms a roster store reads SHALL be exactly the ones this app has written: the form it writes
now and every form before it. It SHALL NOT weaken the refusal of a form *later* than the one it
writes, which is a form it cannot know the shape of, and it SHALL refuse a form number it has never
written at all — one below the earliest — as content that is not a roster store, because a number no
version of this app ever wrote says nothing about the shape of what follows it.

#### Scenario: a roster kept before a commitment carried a kind is read with every commitment of the plain kind

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment carried a kind, whose two commitments are named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, and "Finances" on a schedule on the 25th of the
  month, kept from that same day
- **THEN** it opens without error
- **AND** its roster is the same roster as one given those two commitments, both of the tick kind,
  in that order

#### Scenario: reading a roster kept in an earlier form changes nothing at its place

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment carried a kind, and nothing is asked of the store
- **THEN** the content at that place is byte-for-byte what it was before

#### Scenario: a commitment of another kind taken on over a roster kept in an earlier form is read back with its kind

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment carried a kind, whose one commitment is named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026; a commitment named "Weight" of the number kind
  with a range of 40 to 150, alike in schedule and kept-from day, is taken on through it; and a
  store is opened afterwards at the same place
- **THEN** the later store's roster reads back both commitments in that order, "Gym" of the tick
  kind and "Weight" of the number kind carrying that range

#### Scenario: a roster store written in a form this app has never written is refused

- **WHEN** a roster store is opened at a place holding a roster store whose form is one below the
  earliest form this app has ever written, holding no commitments
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster kept before a commitment could be removed is read with every commitment not removed

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment could be removed, whose two commitments are named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026 and stopped as of 31 January 2026, and
  "Journaling" on that same schedule, kept from that same day and never stopped
- **THEN** it opens without error
- **AND** its roster is the same roster as one given those two commitments in that order and asked to
  stop keeping "Gym" as of 31 January 2026
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store declaring a form written before removal and saying something about removal is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form used before a
  commitment could be removed and yet says, of its one commitment, that it has not been removed
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store declaring the form this app writes and saying nothing about removal is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form this app
  writes and yet says nothing at all about removal for its one commitment
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a commitment removed over a roster kept before removal existed is read back removed

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment could be removed, whose one commitment is named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026; that commitment is removed through it as of
  31 January 2026; and a store is opened afterwards at the same place
- **THEN** the later store's roster is the same roster as one given that commitment once and asked to
  remove it as of 31 January 2026
- **AND** the later store's roster reads back no commitments it is keeping

#### Scenario: a roster kept before a commitment could be put under a category is read with every commitment under none

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment could be put under a category, whose two commitments are named "Creatine" on a schedule
  listing all seven weekdays, kept from 1 January 2026, and "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from that same day
- **THEN** it opens without error
- **AND** its roster reads back one group, under no category, holding "Creatine" and then "Gym"
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store declaring a form written before categories and saying something about one is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form used before a
  commitment could be put under a category and yet says, of its one commitment, that it is under
  none
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store declaring the form this app writes and saying nothing about a category is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form this app
  writes and yet says nothing at all about a category for its one commitment
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a commitment put under a category over a roster kept before categories existed is read back under it

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment could be put under a category, whose two commitments are named "Creatine" and "Gym",
  both on a schedule listing all seven weekdays and both kept from 1 January 2026; "Creatine" is put
  under the category "Supplements" through it; and a store is opened afterwards at the same place
- **THEN** the later store's roster reads back two groups, one under "Supplements" holding
  "Creatine" and one under no category holding "Gym"
- **AND** the later store's roster reads back both commitments of the tick kind and neither as
  removed

### Requirement: A commitments screen lists the commitments its roster keeps, in the order they were taken on

A commitments screen SHALL hold a roster, read at the place it keeps its roster, and SHALL list the
commitments that roster is keeping, **in groups**, in the order the roster answers with. A commitment
the roster has stopped keeping MUST NOT be in that list, and neither MUST a commitment the roster
has removed.

**A group is a category and the entries under it, and the screen makes none of them.** The groups,
their order, which entries are in each and which entries are under no category at all are the
roster's answer, read off it and drawn: a group sits where its first commitment sits in the order
the person set, the entries under no category come last in a group with no category, and within a
group the entries are in the roster's own order. This screen SHALL NOT sort the groups, SHALL NOT
put the group with no category anywhere but last, and SHALL NOT invent a group for a category no
commitment it keeps is under. Ordering the groups by name would be a rule about the owner's own
words, which is the argument the roster's order has always rested on, and a second thing working out
where a group goes is a second thing that could disagree with the first — which is exactly what
ADR-1037 refused for the order itself.

**What it keeps, read across its groups, is the commitments the roster is keeping and nothing else**
— the same commitments, and each exactly once. Grouping rearranges what is drawn and changes nothing
about what the roster holds, so a commitment given a category is drawn in that category's group while
staying exactly where the roster holds it, and taking the category off draws it back among the ones
under none, where it never stopped being.

An entry in the list SHALL be a commitment's name and the rhythm it runs on **in words**, and
nothing else. The words are the ones the `schedule` capability says for the schedule that
commitment carries, read off the commitment the entry is for: this screen composes none of them and
chooses none of them, so an entry and a day screen's row say one rhythm the same way. An entry
SHALL NOT say the kind its days take, which is the surface `add-kind-to-commitments-screen` (#142)
adds, and SHALL NOT say the day the commitment is kept from, which says when it began rather than
what rhythm it runs on. **An entry SHALL NOT say its category either**: the group it is drawn in
says it, and saying it twice would leave a screen able to say two different things.

Two commitments alike in name and unlike in rhythm are therefore two entries a person can tell
apart, which is what a rhythm beside a name is for. Two alike in name **and** in rhythm, unlike
only in the day they are kept from or the kind their days take, are still two entries a person
cannot tell apart, and that is accepted rather than refused. The roster refuses only a commitment
it is already keeping, and a screen refusing a name the roster allows would forbid the same thing
kept on two rhythms. **Two such entries are also the one case where a person removing one of them
must be careful**, because the name typed back matches both; which of the two is removed is the one
the removal was asked about, and never the one the typing picks out.

**The scenario below titled *two commitments alike in name and not in rhythm are two entries a
person cannot tell apart* is kept exactly as it was, and its title is now wrong.** Everything it
asserts still holds — two entries, both named "Vitamins", the first of which can be stopped — but
the entries say different rhythms, so a person can tell them apart, and the scenario after it says
so. It is kept because `openspec` 1.10.0 refuses a MODIFIED requirement that drops any scenario the
current spec has, and the only way to drop one is to rename the requirement, which moves the whole
block to the bottom of the spec at archive time. `design.md` § *Three scenario titles that are now
wrong* has the evidence.

A commitments screen SHALL ask its roster no date. What it lists is what a person keeps now; which
commitments a roster had not stopped keeping on a given date is the day screen's question and not
this screen's.

A roster holding nothing at all SHALL be listed as nothing at all, in no groups at all. A
commitments screen MUST NOT
take any commitment on of its own — day one belongs to the day screen and to the moment its roster
holds nothing (ADR-1027), and a second thing writing day one would take it on twice.

#### Scenario: a commitments screen lists the commitments its roster keeps, in the order they were taken on

- **WHEN** a commitment named "Water plants" on a schedule listing all seven weekdays, then one
  named "Gym" on a schedule listing Monday, Wednesday and Saturday, then one named "Journaling" on
  a schedule listing all seven weekdays, all kept from 1 January 2026, are taken on at a roster
  place; and a commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it keeps is three entries, named "Water plants", then "Gym", then "Journaling"
- **AND** it says it is keeping a roster

#### Scenario: a commitments screen does not list a commitment its roster has stopped keeping

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and one
  named "Journaling" on a schedule listing all seven weekdays, both kept from 1 January 2026, are
  taken on at a roster place; "Gym" is stopped there as of Sunday 30 August 2026; and a commitments
  screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it keeps is one entry, named "Journaling"
- **AND** "Gym" is not in what it keeps, although Monday 31 August 2026 is the day after the day it
  was kept until and the screen was asked no date at all

#### Scenario: an entry says the rhythm its commitment runs on, whichever of the four shapes it is

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, one named
  "Finances" on a schedule on the 25th of the month, one named "Contact lenses" on a schedule of
  every 14 days starting on 1 January 2026, and one named "Reading" on a schedule of 3 times a
  week, all kept from 1 January 2026, are taken on at a roster place; and a commitments screen is
  opened at that roster place as of Monday 31 August 2026
- **THEN** what it keeps is four entries saying "Mon, Wed, Sat", "The 25th", "Every 14 days" and
  "3x a week" beside their names, in that order

#### Scenario: two commitments alike in name and not in rhythm are two entries a person cannot tell apart

- **WHEN** a commitment named "Vitamins" on a schedule listing Monday and Wednesday and one named
  "Vitamins" on a schedule listing Tuesday and Thursday, both kept from 1 January 2026, are taken
  on at a roster place; and a commitments screen is opened at that roster place as of Monday
  31 August 2026
- **THEN** what it keeps is two entries, both named "Vitamins"
- **AND** stopping the first of them leaves what it keeps as one entry named "Vitamins"

#### Scenario: two commitments alike in name and not in rhythm are told apart by the rhythm their entries say

- **WHEN** a commitment named "Vitamins" on a schedule listing Monday and Wednesday and one named
  "Vitamins" on a schedule listing Tuesday and Thursday, both kept from 1 January 2026, are taken
  on at a roster place; and a commitments screen is opened at that roster place as of Monday
  31 August 2026
- **THEN** what it keeps is two entries, both named "Vitamins", the first saying "Mon, Wed" and the
  second saying "Tue, Thu"
- **AND** stopping the first of them leaves what it keeps as one entry named "Vitamins", saying
  "Tue, Thu"

#### Scenario: two commitments alike in name and in rhythm are two entries that say the same thing

- **WHEN** a commitment named "Vitamins" on a schedule listing Monday and Wednesday kept from
  1 January 2026, and one named "Vitamins" on a schedule listing Monday and Wednesday kept from
  1 June 2026, are taken on at a roster place; and a commitments screen is opened at that roster
  place as of Monday 31 August 2026
- **THEN** what it keeps is two entries, both named "Vitamins" and both saying "Mon, Wed"
- **AND** neither is refused, because the roster is keeping two different commitments

#### Scenario: a commitments screen opened on a roster that holds nothing lists nothing and takes nothing on

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept
- **THEN** what it keeps is nothing and what it has stopped is nothing
- **AND** it says it is keeping a roster
- **AND** nothing is kept at that roster place

#### Scenario: removing one of two entries alike in name removes the one it was asked about

- **WHEN** a commitment named "Vitamins" on a schedule listing Monday and Wednesday and one named
  "Vitamins" on a schedule listing Tuesday and Thursday, both kept from 1 January 2026, are taken on
  at a roster place; a commitments screen is opened at that roster place as of Monday 31 August 2026;
  it is asked to remove the second of them; "Vitamins" is typed back; and the removal is confirmed
- **THEN** what it keeps is one entry, named "Vitamins", saying "Mon, Wed"
- **AND** what it has stopped is nothing

#### Scenario: a commitments screen draws what it keeps in groups, one per category

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Magnesium", then
  one named "Finances", all on a schedule listing all seven weekdays and kept from 1 January 2026,
  are taken on at a roster place; "Creatine" and "Magnesium" are put under the category
  "Supplements" there and "Gym" under "Sport"; and a commitments screen is opened at that roster
  place as of Monday 31 August 2026
- **THEN** what it keeps is three groups: "Supplements" holding "Creatine" and then "Magnesium",
  then "Sport" holding "Gym", then a group with no category holding "Finances"
- **AND** what it keeps, read across its groups, is four entries, named "Creatine", "Magnesium",
  "Gym" and then "Finances"

#### Scenario: a group sits where its first commitment sits in the order the person set

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Magnesium", all on
  a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; "Gym" is put under the category "Sport" there and "Magnesium" under "Supplements"; and a
  commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it keeps is three groups: "Sport" holding "Gym", then "Supplements" holding
  "Magnesium", then a group with no category holding "Creatine"
- **AND** the groups are not in alphabetical order

#### Scenario: a commitments screen whose commitments are none of them under a category draws one group

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; and a commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it keeps is one group, with no category, holding "Water plants", then "Gym", then
  "Journaling"

#### Scenario: a commitment given a category is drawn in that group and returns when the category is taken off

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Magnesium", all on a
  schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster place; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; "Magnesium" is put
  under the category "Supplements" through it; and "Magnesium" is then put under no category through
  it
- **THEN** immediately after the first change what it keeps is two groups, "Supplements" holding
  "Magnesium" and then a group with no category holding "Creatine" and then "Gym"
- **AND** afterwards what it keeps is one group, with no category, holding "Creatine", then "Gym",
  then "Magnesium", in the order the roster has held them throughout

### Requirement: A commitments screen lists what has been stopped, beside what it keeps

A commitments screen SHALL list, separately from the commitments its roster is keeping, the
commitments that roster has stopped keeping — in the order the roster holds them, each as a name and
the rhythm it runs on in words, exactly as the first list is. A stopped commitment is never moved,
so that is the order it was taken on in for as long as nobody has moved a commitment past it. **A commitment the roster has removed
SHALL be in neither list**; every other commitment the roster holds SHALL be in exactly one of the
two and never in both.

**The list of what has been stopped SHALL NOT be grouped.** It is one flat list whatever categories
its commitments are under, and a stopped commitment's category is said nowhere on this screen. It is
not the list a person reads daily, and it is the shortest-lived of the two; grouping would double the
structure of the screen for the list that needs it least, and it would draw a heading for a category
no commitment being kept is under. A commitment the roster has stopped keeping goes on being under
the category it was under, so taking it up again from this list — which asks for nothing — draws it
back in that category's group, and nothing about that has to be shown here.

That a removed commitment is in neither list is the whole of what removal is on a screen. The roster
still holds it, every past day still draws it and every tick against it still stands; what has
changed is that a person is no longer offered it, anywhere, and the two lists are once more only the
things they have a decision to make about.

This second list exists because the roster's rule that offering a stopped commitment again *takes
it up again* cannot otherwise be reached from a phone. A person who had to retype a name, rebuild a
rhythm and match a day kept from exactly would in practice be making a different commitment, and a
roster every one of whose commitments has been stopped would be a day screen with no rows for ever.
It says a rhythm for the same reason the first list does: two stopped commitments alike in name are
as hard to tell apart as two kept ones, and this list is the one place a person picks which of them
to take up again.

A removed commitment has no such list, and that is the price of removal rather than an oversight:
the way back is to define the identical commitment again, which the roster takes as taking it up
again. A person who cannot reproduce the name, the rhythm and the day exactly cannot get it back,
which is what "for good" means and why the removal is confirmed by typing.

A roster that has stopped nothing SHALL list nothing as stopped.

#### Scenario: a commitments screen lists what its roster has stopped keeping, in the order they were taken on

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling",
  all on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a
  roster place; "Journaling" and then "Water plants" are stopped there as of Sunday 30 August 2026;
  and a commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it has stopped is two entries, named "Water plants" and then "Journaling"
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a stopped entry says the rhythm its commitment runs on, as a kept entry does

- **WHEN** a commitment named "Vitamins" on a schedule listing Monday and Wednesday and one named
  "Vitamins" on a schedule of 3 times a week, both kept from 1 January 2026, are taken on at a
  roster place; both are stopped there as of Sunday 30 August 2026; and a commitments screen is
  opened at that roster place as of Monday 31 August 2026
- **THEN** what it has stopped is two entries, both named "Vitamins", the first saying "Mon, Wed"
  and the second saying "3x a week"

#### Scenario: a commitments screen whose roster has stopped nothing lists nothing as stopped

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; and a commitments screen is opened at that roster
  place as of Monday 31 August 2026
- **THEN** what it has stopped is nothing
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a commitment a commitments screen keeps is not among what it has stopped

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped
  there as of Sunday 30 August 2026; and a commitments screen is opened at that roster place as of
  Monday 31 August 2026
- **THEN** no commitment is in both of its lists
- **AND** what it keeps names only "Journaling" and what it has stopped names only "Gym"

#### Scenario: a commitments screen lists a commitment its roster has removed in neither of its lists

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; "Gym" is removed there as of Sunday 30 August 2026 and "Journaling" is stopped there as of
  that same day; and a commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it keeps is one entry, named "Water plants"
- **AND** what it has stopped is one entry, named "Journaling"
- **AND** "Gym" is in neither of its lists

#### Scenario: what a commitments screen has stopped is in the order its roster holds them

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; a commitments screen is opened at that roster place as of Monday 31 August 2026;
  "Journaling" is moved to the offset 0; and "Journaling" and then "Water plants" are stopped through
  it
- **THEN** what it has stopped is two entries, named "Journaling" and then "Water plants", and not in
  the order the two were taken on
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: what a commitments screen has stopped is one flat list whatever categories its commitments are under

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Magnesium", all on a
  schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster place;
  "Creatine" and "Magnesium" are put under the category "Supplements" there and "Gym" under "Sport";
  all three are stopped there as of Sunday 30 August 2026; and a commitments screen is opened at
  that roster place as of Monday 31 August 2026
- **THEN** what it has stopped is three entries, named "Creatine", then "Gym", then "Magnesium"
- **AND** what it keeps is no groups at all

#### Scenario: a stopped commitment taken up again is drawn in the group of the category it was under

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and stopped there as of Sunday 30 August 2026; a commitments screen
  is opened at that roster place as of Monday 31 August 2026; and "Creatine" is taken up again
  through it
- **THEN** what it keeps is two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** what it has stopped is nothing

### Requirement: A commitments screen defines a commitment from a name, a rhythm and the day it is kept from

A commitments screen SHALL define a commitment from four things and no others: a name, a rhythm,
the day it is kept from, and the **category** to put it under, which may be none. The commitment so
formed SHALL be taken on at the roster place before either of the screen's lists says so, and SHALL
then be last in what the screen keeps, in the group of the category it was given, because that is
the place the roster gives it — **unless the roster already holds that commitment stopped or
removed, in which case it is taken up again in the place it has**, again because that is
the place the roster gives it. Defining is therefore the one way back to a removed commitment, and
the screen does nothing of its own to make it so: it hands the roster four things and reports what
the roster answers.

**A commitment taken up again by being defined again is put under the category the form carried**,
whatever category it was under before, and under none where the form carried none. That is the
roster's rule and not this screen's, and it is right here for the reason it is right there: the
person is looking at the form now, so what it says is what they are saying. Taking a stopped
commitment up again from the list of what has been stopped is a different act, asks for nothing, and
leaves the category alone.

**A category made of nothing but blank space is no category, and SHALL NOT be refused.** Unlike a
name, a category is optional, so a field with nothing in it and a field with three spaces in it both
say the same thing — that this commitment is under none — and emptying the field is how a category is
taken off. Every other category SHALL be accepted and kept exactly as it was given, blank space at
its ends and all: there is no length limit, no restricted script and no reserved word, because a
category is the owner's own words in exactly the way a name is.

A **rhythm** SHALL be one of four, and all four SHALL be offered: a weekday set, a day of the
month, an interval of a whole number of days, and a weekly quota. A rhythm carries nothing the
calendar does not supply — in particular an interval rhythm carries no start date.

Three of the four are a number, and a rhythm SHALL carry that number as the person gave it, judged
by nothing on the way. A rhythm is what a person said, not what the system was able to make of it,
so the judging happens in one place — the screen, when it is asked to define — and the requirement
below says what it does there.

**The day a commitment is kept from SHALL also be the start date of an interval rhythm.** The
commitment is due on the day a person started keeping it and every N days after it. The two remain
distinct in the model and may disagree where something other than this screen forms the commitment;
this screen offers one date and uses it for both.

A commitments screen SHALL offer, as the day to keep a commitment from, the day it was handed. It
SHALL accept any calendar date the system supports in that place, the future included: a person who
has kept something since June says June, and "I start the gym on Monday" is a real thing to want. A
commitments screen MUST NOT judge that date against the day it was handed, and MUST NOT bound it in
any way the calendar does not.

#### Scenario: a commitment defined through a commitments screen is kept at the roster place before either list says so

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Gym" on a weekday-set rhythm of Monday, Wednesday
  and Saturday, kept from that same day, is defined through it
- **THEN** a roster store opened afterwards at that place holds one commitment, named "Gym"
- **AND** what the screen keeps is one entry, named "Gym"
- **AND** nothing is refused

#### Scenario: a commitment defined through a commitments screen is last in what it keeps

- **WHEN** a commitment named "Water plants" and one named "Gym", both on a schedule listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen
  is opened at that roster place as of Monday 31 August 2026; and a commitment named "Journaling"
  on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it
- **THEN** what it keeps is three entries, named "Water plants", then "Gym", then "Journaling"

#### Scenario: a commitment defined on each of the four rhythms is read back on the schedule that rhythm names

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and four commitments kept from that same day are defined through it — "Gym"
  on a weekday-set rhythm of Monday, Wednesday and Saturday; "Finances" on a day-of-the-month rhythm
  of the 25th; "Contact lenses" on an interval rhythm of 14 days; and "Reading" on a weekly-quota
  rhythm of 3 times a week
- **THEN** a roster store opened afterwards at that place holds four commitments equal, one for one
  and in that order, to commitments formed directly from those names, the schedules those rhythms
  name and Monday 31 August 2026

#### Scenario: a commitment defined on an interval rhythm counts from the day it is kept from

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Contact lenses" on an interval rhythm of 14 days,
  kept from Wednesday 1 July 2026, is defined through it
- **THEN** the commitment a roster store opened afterwards at that place holds is due on Wednesday
  1 July 2026 and on Wednesday 15 July 2026
- **AND** it is not due on Thursday 2 July 2026 and not due on Tuesday 30 June 2026

#### Scenario: a commitments screen offers the day it was handed as the day to keep a commitment from

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept
- **THEN** the day it offers to keep a commitment from is Monday 31 August 2026

#### Scenario: a commitments screen accepts a day to keep from that has not arrived and one long past

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "Gym" on a weekday-set rhythm of all seven weekdays,
  kept from 31 December 9999, is defined through it; and a commitment named "Journaling" on that
  same rhythm, kept from 1 January 1583, is defined through it
- **THEN** neither is refused
- **AND** what the screen keeps is two entries, named "Gym" and then "Journaling"

#### Scenario: a commitment defined again after being removed is taken up again in the place it was taken on in

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; "Gym" is removed there as of Sunday 30 August 2026; a commitments screen is opened at that
  roster place as of Monday 31 August 2026; and a commitment named "Gym" on a weekday-set rhythm of
  all seven weekdays, kept from 1 January 2026, is defined through it
- **THEN** nothing is refused
- **AND** what it keeps is three entries, named "Water plants", then "Gym", then "Journaling"
- **AND** what it has stopped is nothing

#### Scenario: a commitment defined under a category is drawn in that category's group and kept under it

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and a commitment named "Creatine" on a weekday-set rhythm of all
  seven weekdays, kept from that same day, under the category "Supplements", is defined through it
- **THEN** nothing is refused
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** a roster store opened afterwards at that place reads back "Creatine" under "Supplements"

#### Scenario: a commitment defined under a category of nothing but blank space is under none and is not refused

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Gym" on a weekday-set rhythm of all seven weekdays,
  kept from that same day, under a category of three spaces, is defined through it
- **THEN** nothing is refused
- **AND** what it keeps is one group, with no category, holding "Gym"
- **AND** a commitment named "Journaling" alike in every other way defined under a category with
  nothing in it at all is likewise not refused and is in that same group

#### Scenario: a commitment defined again after being removed takes the category the form carried

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and removed there as of Sunday 30 August 2026; a commitments screen
  is opened at that roster place as of Monday 31 August 2026; and a commitment named "Creatine" on a
  weekday-set rhythm of all seven weekdays, kept from 1 January 2026, under the category "Morning",
  is defined through it
- **THEN** nothing is refused
- **AND** what it keeps is two groups, "Morning" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** a screen alike in every way that defines it under no category instead keeps one group,
  with no category, holding "Creatine" and then "Gym"

#### Scenario: a category is kept exactly as it was typed on the form

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and two commitments on a weekday-set rhythm of all seven weekdays, kept
  from that same day, are defined through it — one named "Creatine" under the category
  " Supplements " and one named "Magnesium" under the category "Supplements"
- **THEN** neither is refused
- **AND** what it keeps is two groups, the first " Supplements " with both spaces holding
  "Creatine", the second "Supplements" holding "Magnesium"

### Requirement: A commitments screen moves a commitment among the ones it keeps

A commitments screen SHALL move a commitment on the list of what it keeps, on being given that
commitment and an **offset** counted over that list **as it stands before the move**, and SHALL keep
the move at the roster place before the list says so. It SHALL ask for no confirmation and SHALL ask
for nothing else: the gesture is a drag, a drag is its own confirmation, and dragging back is the
undo. This is where the order a **day screen** draws in is set, and it is the only place a person
sets it.

**The offset is counted over what the screen draws** — the list of what it keeps read across its
groups, from 0 before the first entry drawn to the number of entries drawn, which is after the last
— and not over the order the roster holds. Those two were one list until the list was grouped and are
now two, and the drawn one is the one the offset means, because a drag happens on what a person is
looking at. Turning a place on the screen into a place in the roster's order is this screen's work
and nobody else's: it is the same conversion whichever gesture produced the offset, and putting it
here is what keeps every other layer from holding a second copy of the grouping rule.

**A drop also says what the row is now under.** The commitment SHALL be put under the category of the
group the offset falls in — the category of the entry drawn at that offset, or, where the offset is
the number of entries drawn, the category of the last entry drawn. A row dropped among another
group's rows is therefore moved **and** put under that group's category by one drag, and a row
dropped among the entries under no category is moved and has its category taken off. One gesture
doing what it looks like it does was chosen over a drag that only ever reordered, and the price is
stated rather than hidden: a drag is now the second way a category changes, beside the field.

**The place the commitment comes to stand in the roster's order is immediately before the entry drawn
at that offset**, or after the last commitment the roster is keeping where the offset is the number
of entries drawn. Because the moved commitment is under that entry's category once the drop is made,
and a group's entries are drawn in the roster's own order, that is the place that draws it where it
was dropped.

**Moving a group's first commitment away moves the group**, and that follows from where a group sits
rather than from anything this requirement adds: a group sits where its first commitment sits, so a
group whose first commitment has gone somewhere else is afterwards drawn where its next commitment
sits. A person who drags the only row of a group into another group therefore sees one heading fewer,
and a person who drags a group's top row to the bottom of the screen may see that group follow it up
the list. It is stated here because it is the one result of a drag that is not the row that was
dragged.

**Two offsets leave a commitment where it is drawn, and on those the screen SHALL change nothing at
all** — not the order, and not the category. They are the offset the entry is drawn at and the one
just after it, which is the gesture's own arithmetic rather than a rule this screen makes, and the
carve-out covers the category because the second of the two names the entry that follows, which may
belong to another group. A drop that has moved nothing has not recategorised anything either: a
person who picks a row up and puts it back down has said nothing. The one place this cannot be
reached from is the second offset of a group's last row, which asks for the place the row already has
and so is not a way into the next group; a person who wants that row at the top of the next group
drops it below that group's first row.

**The move is offered on what the screen keeps and nowhere else.** A commitment on the list of what
it has stopped SHALL NOT be moved through this screen: it already has a place in the roster's order,
taking it up again returns it there, and that list is not the one an order is read off. It is not
grouped either, so there is no group on it to drop anything into.

A commitments screen asked to move a commitment neither of its lists holds, one on the list of what
it has stopped, or one to an offset that the list of what it keeps does not have SHALL do nothing and
SHALL say nothing. Each of those asks for no change at all, by the rule that already governs a
commitment neither list holds, so the roster's own two refusals are never reached through this
screen and there is nothing for it to word.

A move the screen could not keep at the roster place SHALL be refused as a roster that could not be
written, leaving both lists as they were, **and leaving the commitment under the category it was
already under**. That is the **fifth** kind of refused change a commitments
screen holds, beside defining a commitment, stopping keeping one, taking one up again and removing
one, and it SHALL name the commitment it was asked to move. A reorder that silently failed to write
would leave a person looking at an order the phone forgets the moment it is closed, which is what
this screen's refusals exist to prevent.

**A drop that puts a commitment where it already is changes nothing and says nothing.** It is not
refused, it changes neither list, and it does not answer a refused change the screen is already
holding: nothing reached the roster place, so nothing has been proved about it either way. Two
offsets do this for any commitment, which is the gesture's own arithmetic rather than a rule this
screen makes.

#### Scenario: a commitment moved through a commitments screen is where it was dropped, and is kept there

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; a commitments screen is opened at that roster place as of Monday 31 August 2026; and
  "Journaling" is moved to the offset 0
- **THEN** nothing is refused
- **AND** what it keeps is three entries, named "Journaling", "Water plants" and then "Gym"
- **AND** a commitments screen opened afterwards at that place as of that same day keeps those three
  in that same order

#### Scenario: an offset a commitments screen is given is counted over what it keeps before the move

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; a commitments screen is opened at that roster place as of Monday 31 August 2026; and "Water
  plants" is moved to the offset 2
- **THEN** what it keeps is three entries, named "Gym", "Water plants" and then "Journaling"
- **AND** a screen alike in every way that moves "Water plants" to the offset 3 instead keeps "Gym",
  "Journaling" and then "Water plants"

#### Scenario: a commitments screen asked to move a commitment it has stopped does nothing and says nothing

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped there as of
  Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and it is asked to move "Gym" to the offset 0
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is one entry, named "Journaling", and what it has stopped is one entry, named
  "Gym"

#### Scenario: a commitments screen asked to move a commitment on neither of its lists does nothing and says nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and it is asked to move a commitment named "Journaling" on that same
  schedule and kept-from day, formed directly and never taken on, to the offset 0
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a commitments screen given an offset the list it keeps does not have does nothing and says nothing

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; and "Gym" is moved to the offset 3, which
  a list of two does not have
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is two entries, named "Gym" and then "Journaling"
- **AND** moving "Gym" to the offset -1 refuses nothing and leaves what it keeps the same again

#### Scenario: a move a commitments screen could not keep leaves both its lists as they were

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; what is at that place is then made
  impossible to write; and "Journaling" is moved to the offset 0
- **THEN** it is refused as a roster that could not be written
- **AND** what it keeps is two entries, named "Gym" and then "Journaling", and what it has stopped is
  nothing

#### Scenario: a move that drops a commitment where it already is changes nothing and refuses nothing

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; the content at that place is read; and
  "Journaling" is moved to the offset 2
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is two entries, named "Gym" and then "Journaling"
- **AND** the content at that place is byte-for-byte what was read before the move

#### Scenario: a commitments screen shown again lists what it keeps in the order it was moved into

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; a commitments screen is opened at that roster place as of Monday 31 August 2026;
  "Journaling" is moved to the offset 0; and the screen is shown again as of Tuesday
  1 September 2026
- **THEN** what it keeps is three entries, named "Journaling", "Water plants" and then "Gym"

#### Scenario: a commitment moved and then stopped through a commitments screen keeps the place it was moved to

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; a commitments screen is opened at that roster place as of Monday 31 August 2026;
  "Journaling" is moved to the offset 0; and the screen is then asked to stop keeping "Journaling"
  and the stop is confirmed
- **THEN** what it keeps is two entries, named "Water plants" and then "Gym"
- **AND** what it has stopped is one entry, named "Journaling"
- **AND** a roster store opened afterwards at that place answers with "Journaling", then "Water
  plants", then "Gym" when asked what it had not stopped keeping on Sunday 30 August 2026

#### Scenario: a commitment dropped among another group's entries is put under that group's category

- **WHEN** a commitment named "Creatine", then one named "Magnesium", then one named "Gym", all on
  a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; "Creatine" and "Magnesium" are put under the category "Supplements" there; a commitments
  screen is opened at that roster place as of Monday 31 August 2026; and "Gym" is moved to the
  offset 1
- **THEN** nothing is refused
- **AND** what it keeps is one group, "Supplements", holding "Creatine", then "Gym", then
  "Magnesium"

#### Scenario: a commitment dropped among the entries under no category has its category taken off

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Journaling", all on
  a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; "Creatine" is put under the category "Supplements" there; a commitments screen is opened at
  that roster place as of Monday 31 August 2026; and "Creatine" is moved to the offset 3
- **THEN** nothing is refused
- **AND** what it keeps is one group, with no category, holding "Gym", then "Journaling", then
  "Creatine"

#### Scenario: an offset a commitments screen is given is counted over what it draws and not over the roster's own order

- **WHEN** a commitment named "Gym", then one named "Creatine", then one named "Magnesium", all on
  a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; "Creatine" and "Magnesium" are put under the category "Supplements" there; a commitments
  screen is opened at that roster place as of Monday 31 August 2026; and "Gym" is moved to the
  offset 1
- **THEN** what it keeps is one group, "Supplements", holding "Creatine", then "Gym", then
  "Magnesium" — the offset naming the entry drawn at it, "Magnesium", and not the commitment the
  roster holds at it, which is "Creatine"
- **AND** a roster store opened afterwards at that place reads back "Creatine", then "Gym", then
  "Magnesium", all three under "Supplements"

#### Scenario: a drop where a commitment is already drawn changes neither its place nor its category

- **WHEN** a commitment named "Creatine", then one named "Gym", all on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there; a commitments screen is opened at that roster place as of Monday
  31 August 2026; the content at that place is read; and "Creatine" is moved to the offset 1
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** the content at that place is byte-for-byte what was read before the move

#### Scenario: a commitment dropped past the last entry drawn takes the last group's category

- **WHEN** a commitment named "Gym", then one named "Creatine", then one named "Magnesium", all on
  a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; "Gym" is put under the category "Sport" there and "Creatine" and "Magnesium" under
  "Supplements"; a commitments screen is opened at that roster place as of Monday 31 August 2026;
  and "Gym" is moved to the offset 3, which is the number of entries it draws
- **THEN** what it keeps is one group, "Supplements", holding "Creatine", then "Magnesium", then
  "Gym"
- **AND** no group is drawn under "Sport"

#### Scenario: dragging a group's only entry into another group leaves one heading fewer

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Journaling", all on
  a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; "Creatine" is put under the category "Supplements" there and "Gym" under "Sport"; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; and "Gym" is moved
  to the offset 0
- **THEN** what it keeps is two groups, "Supplements" holding "Gym" and then "Creatine", and then a
  group with no category holding "Journaling"
- **AND** no group is drawn under "Sport"

### Requirement: A commitments screen holds the change it refused and why, one at a time

Where a change asked of a commitments screen is refused, the screen SHALL hold **which change was
asked for** and **why it was refused**, as well as answering the refusal to the caller. The two are
not alternatives and neither replaces the other: the refusal answered to the caller is what a test
asserts on and what stops a shell drawn later from swallowing the failure a second time, and what
the screen holds is what a person is told from. A screen that only answered would leave how long a
person is told for to whatever drew it, and that lifetime would then be decided in a layer nothing
regresses.

The change it holds SHALL be one of the six a person can ask for — defining a commitment, stopping
keeping one, taking a stopped one up again, removing one, moving one, or putting one under a
category — and for the five that are asked about a commitment already on one of its lists, it SHALL
name that commitment. Which change it was is not
decoration: a person is told beside the thing they asked for, and the only other way to place the
message is for whatever draws the screen to remember which call it made.

Why it was refused SHALL be the same refusal that was answered to the caller, and no more. A
commitments screen SHALL hold **no words a person reads**: the distinction between its refusals is
this capability's, and the sentence said for each is the drawing's, exactly as it already is for
whether the screen is keeping a roster. ADR-1022.

It SHALL hold **at most one refused change at a time**, and that change SHALL be the change asked
for last. Asking for a second change replaces what is held rather than adding to it: one refusal is
one event, two would tell a person twice about two different moments, and the ask they are waiting
on an answer for is the one they just made.

A call that asks for **no change at all** SHALL NOT be a refusal. Asking to stop keeping a
commitment the screen does not keep, confirming a stop when nothing is awaiting confirmation, taking
up again a commitment the screen has not stopped, asking to remove a commitment on neither of its
lists, confirming a removal when nothing is awaiting removal, **confirming a removal while the name
typed back does not match**, **asking to move a commitment the screen does not keep**, **asking
to move one to an offset outside what it keeps** and **asking to put a commitment the screen does not
keep under a category** each answer nothing and change nothing, so each
SHALL leave the screen holding no refused change and SHALL leave whatever it is already holding
exactly as it was.
There is nothing to report and nothing has been proved about the roster place either way.

A name typed back that does not match is emphatically not a refusal, and that is the decision rather
than an omission. A person mid-way through typing a name has asked for nothing yet; telling them
they are wrong on every keystroke would be the screen refusing what nobody offered it. What the
screen answers instead is whether the name matches, which is what makes the confirmation reachable
or not, and there is nothing else to say.

Which refusals exist, and which of them are told apart, are the requirements above and are not
restated here.

#### Scenario: a commitments screen holds a refused definition against defining a commitment

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it
- **THEN** it is refused as a name that says nothing
- **AND** the screen holds that refusal, against defining a commitment

#### Scenario: a commitments screen holds a refused stop against the commitment it was asked to stop

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; what is at that place is then made impossible to write; and the
  screen is asked to stop keeping "Gym" and the stop is confirmed
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against stopping keeping "Gym"

#### Scenario: a commitments screen holds a refused take-up-again against the commitment it was asked to take up again

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and stopped there as of Sunday 30 August 2026; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; what is at that
  place is then made impossible to write; and "Gym" is taken up again through the screen
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against taking "Gym" up again

#### Scenario: a commitments screen refused twice holds only the change it was asked for last

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; what is at that place is then made impossible to write; a commitment
  named "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined
  through the screen; and the screen is then asked to stop keeping "Gym" and the stop is confirmed
- **THEN** the screen holds one refused change, which is a roster that could not be written against
  stopping keeping "Gym"
- **AND** it holds nothing against defining a commitment

#### Scenario: a commitments screen that has been asked for no change holds no refused change

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place, and a commitments screen is opened at that roster
  place as of Monday 31 August 2026
- **THEN** the screen holds no refused change

#### Scenario: a commitments screen holds nothing against a call that changes nothing at all

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; the screen is asked to stop keeping a commitment named "Journaling"
  on that same schedule and kept-from day, formed directly and never taken on; a stop is then
  confirmed with nothing awaiting confirmation; and "Gym", which has not been stopped, is taken up
  again through the screen
- **THEN** nothing is refused by any of the three
- **AND** the screen holds no refused change

#### Scenario: a commitments screen holds a refused removal against the commitment it was asked to remove

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is asked to remove "Gym" and "Gym" is typed back; what is at that
  place is then made impossible to write; and the removal is confirmed
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against removing "Gym"
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a commitments screen holds nothing against a removal confirmed on a name that does not match

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; it is asked to remove "Gym";
  "Gymm" is typed back; and the removal is confirmed
- **THEN** the removal refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one entry, named "Gym", and "Gym" is still awaiting removal

#### Scenario: a commitments screen holds a refused move against the commitment it was asked to move

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, and one named "Journaling" alike in every other way are taken on at a roster place;
  a commitments screen is opened at that roster place as of Monday 31 August 2026; what is at that
  place is then made impossible to write; and "Journaling" is moved to the offset 0
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against moving "Journaling"
- **AND** what it keeps is two entries, named "Gym" and then "Journaling"

#### Scenario: a commitments screen holds nothing against a move that asks for no change at all

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is asked to move a commitment named "Journaling" on that same
  schedule and kept-from day, formed directly and never taken on, to the offset 0; and "Gym" is then
  moved to the offset 2, which a list of one commitment does not have
- **THEN** neither is refused
- **AND** the screen holds no refused change
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a commitments screen holds a refused category change against the commitment it was asked about

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; what is at that place is then made impossible to write; and "Gym" is
  put under the category "Sport" through the screen
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against putting "Gym" under a category
- **AND** what it keeps is one group, with no category, holding "Gym"

#### Scenario: a commitments screen holds nothing against a category change that asks for no change at all

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; and a commitment named
  "Journaling" on that same schedule and kept-from day, formed directly and never taken on, is put
  under the category "Sport" through the screen
- **THEN** the category change refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, with no category, holding "Gym"

### Requirement: What a commitments screen holds about a refused change lasts until the app is shown again or a change is kept

A commitments screen SHALL go on holding a refused change until one of exactly two things happens,
and SHALL then hold nothing. Nothing else SHALL end it. Time passing in particular SHALL NOT,
because this capability reads no clock.

**The app being shown again** ends it. That is inherited rather than added: being shown reads the
roster place afresh and forms both lists again from what is then there, and what was refused is an
answer about a place that has since been read again. It SHALL end whether or not the roster can then
be read — a screen that is then not keeping a roster says that instead, and says more than a refused
change ever could.

**A change reaching the roster place** ends it, whichever of the six it was and whichever change
was refused before it. Defining a commitment that is taken on, a stop that is kept, a take-up-again
that is kept, a removal that is kept, a move that is kept and a category change that is kept all
count. This is one rule rather than five because it is
the at-most-one rule above read the other way round: a commitments screen holds the outcome of the
last change asked of it, so a change that is asked for and kept leaves nothing to hold. A person who
has just been told a change landed is not also told that an earlier one did not.

A call that reaches the place with no change to make SHALL NOT end it, by the rule above that such a
call is not a change asked for at all. **A move that drops a commitment where it already is is
exactly such a call** — it is accepted rather than refused, and nothing is kept at the place, so
there is nothing to have answered a notice with — **and so is a category change that puts a
commitment under the category it is already under**. Nor SHALL putting a stop or a removal up for
confirmation, typing a name back, or cancelling either: none of them reaches the roster place, and
nothing has been proved about it either way.

#### Scenario: what a commitments screen holds about a refused change ends when the app is shown again

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and the app is then shown again as of
  that same day
- **THEN** the screen holds no refused change
- **AND** it says it is keeping a roster

#### Scenario: what a commitments screen holds about a refused change ends when the app is shown again where the roster then cannot be read

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; what is at that place is then made impossible to write; the screen is
  asked to stop keeping "Gym" and the stop is confirmed and refused; and the app is then shown again
  as of that same day
- **THEN** the screen holds no refused change
- **AND** it says it is not keeping a roster

#### Scenario: what a commitments screen holds about a refused change ends when a commitment is defined and kept

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and a commitment named "Journaling" on
  that same rhythm and kept-from day is then defined through it
- **THEN** "Journaling" is not refused
- **AND** the screen holds no refused change

#### Scenario: what a commitments screen holds about a refused change ends when a stop is kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; and the screen is then asked
  to stop keeping "Gym" and the stop is confirmed
- **THEN** the stop is not refused
- **AND** the screen holds no refused change

#### Scenario: what a commitments screen holds about a refused change ends when a commitment is taken up again and kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and stopped there as of Sunday 30 August 2026; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through
  it and refused; and "Gym" is then taken up again through the screen
- **THEN** taking "Gym" up again is not refused
- **AND** the screen holds no refused change

#### Scenario: what a commitments screen holds about a refused change stands when a call changes nothing at all

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; "Gym", which has not been
  stopped, is then taken up again through the screen; and a stop is then confirmed with nothing
  awaiting confirmation
- **THEN** the screen still holds a name that says nothing, against defining a commitment

#### Scenario: what a commitments screen holds about a refused change stands when a stop is asked for and cancelled

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; and the screen is then asked
  to stop keeping "Gym" and the stop is cancelled
- **THEN** the screen still holds a name that says nothing, against defining a commitment
- **AND** nothing is awaiting confirmation

#### Scenario: what a commitments screen holds about a refused change ends when a removal is kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; and the screen is then asked
  to remove "Gym", "Gym" is typed back, and the removal is confirmed
- **THEN** the removal is not refused
- **AND** the screen holds no refused change
- **AND** "Gym" is in neither of its lists

#### Scenario: what a commitments screen holds about a refused change stands when a removal is asked for and cancelled

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; and the screen is then asked
  to remove "Gym", "Gym" is typed back, and the removal is cancelled
- **THEN** the screen still holds a name that says nothing, against defining a commitment
- **AND** nothing is awaiting removal and nothing has been typed back

#### Scenario: what a commitments screen holds about a refused change ends when a move is kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, and one named "Journaling" alike in every other way are taken on at a roster place;
  a commitments screen is opened at that roster place as of Monday 31 August 2026; a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it
  and refused; and "Journaling" is then moved to the offset 0
- **THEN** the move is not refused
- **AND** the screen holds no refused change
- **AND** what it keeps is two entries, named "Journaling" and then "Gym"

#### Scenario: what a commitments screen holds about a refused change stands when a move drops a commitment where it already is

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, and one named "Journaling" alike in every other way are taken on at a roster place;
  a commitments screen is opened at that roster place as of Monday 31 August 2026; a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it
  and refused; and "Journaling" is then moved to the offset 2
- **THEN** the move is not refused
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is two entries, named "Gym" and then "Journaling"

#### Scenario: what a commitments screen holds about a refused change ends when a category change is kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; and "Gym" is put under the
  category "Sport" through it
- **THEN** the screen holds no refused change
- **AND** what it keeps is one group, "Sport", holding "Gym"

#### Scenario: what a commitments screen holds about a refused change stands when a category change puts a commitment under the category it is already under

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and put under the category "Sport" there; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through
  it and refused; and "Gym" is put under the category "Sport" through it
- **THEN** the second change refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment

### Requirement: A commitments screen that cannot read its roster lists nothing and changes nothing

A commitments screen whose roster place cannot be read SHALL list nothing in either list and SHALL
say that it is not keeping a roster. It MUST NOT take anything on, and it MUST NOT write over what
is at the place — what is there is left untouched for a person or a later version of the app to
recover. It SHALL offer no category either: the categories it offers are the ones the commitments it
keeps are under, and it keeps none.

Defining a commitment through such a screen SHALL be refused as a roster that could not be written.
Asking it to stop keeping a commitment, to take one up again, to remove one, to move one, or to put
one under a category SHALL do
nothing and say nothing, by the rule that already governs a commitment neither list holds: both its
lists are empty, so there is nothing there to stop, nothing there to take up, nothing there to
remove, nothing there to move and nothing there to put under anything.

Every way the place can refuse to be read SHALL be answered alike, save one, which SHALL be named:
a roster **written by a later version of DayByDay**. That roster is whole and it is the app that is
behind, so the person's answer is to update the app and leave the file completely alone, where a
screen saying only that something is wrong invites deleting it. No other reason leaves a person
anything different to do, so no other reason is told apart. ADR-1021.

The condition SHALL last only until the app is shown again, since being shown reads the place
afresh.

#### Scenario: a commitments screen that cannot read its roster lists nothing and says it is not keeping one

- **WHEN** a run of bytes that is not a roster store is written at a roster place, and a commitments
  screen is opened at that place as of Monday 31 August 2026
- **THEN** what it keeps is nothing and what it has stopped is nothing
- **AND** it says it is not keeping a roster

#### Scenario: a roster written in a later form than this app knows makes a commitments screen that says the roster is from a later version

- **WHEN** a roster store document declaring a version later than this app writes is written at a
  roster place, and a commitments screen is opened at that place as of Monday 31 August 2026
- **THEN** it says the roster was written by a later version of DayByDay, told apart from a roster
  that could not be read
- **AND** what it keeps is nothing and what it has stopped is nothing

#### Scenario: a commitments screen that cannot read its roster refuses a new commitment and leaves what is at the place as it was

- **WHEN** a run of bytes that is not a roster store is written at a roster place; a commitments
  screen is opened at that place as of Monday 31 August 2026; a commitment named "Gym" on a
  weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it; and it
  is then asked to stop keeping a commitment named "Journaling" formed directly, and the stop is
  confirmed
- **THEN** defining "Gym" is refused as a roster that could not be written
- **AND** the stop refuses nothing and leaves nothing awaiting confirmation
- **AND** the content at that place is byte-for-byte what was written there

#### Scenario: a commitments screen that could not read its roster starts keeping one when it is shown again and the roster can be read

- **WHEN** a run of bytes that is not a roster store is written at a roster place; a commitments
  screen is opened at that place as of Monday 31 August 2026; what is at that place is replaced with
  a roster store holding a commitment named "Gym" on a schedule listing all seven weekdays, kept
  from 1 January 2026; and the screen is shown again as of Monday 31 August 2026
- **THEN** it says it is keeping a roster
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a commitments screen that cannot read its roster does nothing when it is asked to remove a commitment

- **WHEN** a run of bytes that is not a roster store is written at a roster place; a commitments
  screen is opened at that place as of Monday 31 August 2026; and it is asked to remove a commitment
  named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026, formed directly
- **THEN** nothing is awaiting removal and nothing is refused
- **AND** the content at that place is byte-for-byte what was written there

#### Scenario: a commitments screen that cannot read its roster does nothing when it is asked to move a commitment

- **WHEN** a run of bytes that is not a roster store is written at a roster place; a commitments
  screen is opened at that place as of Monday 31 August 2026; and it is asked to move a commitment
  named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026, formed directly, to
  the offset 0
- **THEN** nothing is refused and it says it is not keeping a roster
- **AND** the content at that place is byte-for-byte what was written there

#### Scenario: a commitments screen that cannot read its roster does nothing when it is asked to put a commitment under a category

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place holding a
  run of bytes that is not what a roster is written as, and a commitment named "Gym" on a schedule
  listing all seven weekdays, kept from 1 January 2026, formed directly, is put under the category
  "Sport" through it
- **THEN** nothing is refused and the screen holds no refused change
- **AND** it says it is not keeping a roster, and what it keeps is no groups at all
- **AND** the categories it offers are none
- **AND** the content at that roster place is byte-for-byte what it was before the screen was opened

## ADDED Requirements

### Requirement: A roster puts a commitment under a category

A roster SHALL put a commitment it is keeping under a **category**, on being given that commitment
and the category, and SHALL report that it put the commitment under it. This is a fifth act on a
commitment beside taking one on, stopping keeping one, removing one and moving one, and it is the
only act that changes a category on its own — a move carries one too, because the gesture that makes
a move carries one.

**A category is a word the person chose, and the roster judges it for saying something and for
nothing else.** A category made of nothing but blank space, and a category with nothing in it at
all, both mean the commitment is under **no** category, and neither SHALL be refused: unlike a name,
a category is optional, so a field emptied is how one is taken off rather than a mistake to report.
Every other category SHALL be kept exactly as it was given — no length limit, no restricted script,
no reserved word, no trimming and no folding of case, so a category with blank space at its ends is
that category and not the one without. Two commitments are under one category when the words are
the same word, and under two when they are not.

**There is no list of categories anywhere.** The categories that exist are exactly the words the
roster's commitments are under, so a category no commitment is under has stopped existing and there
is nothing to delete; nothing creates a category before a commitment is put under it, and nothing
holds one afterwards. A roster MUST NOT keep a second collection of category words, MUST NOT hold a
count of what is under each, and MUST NOT refuse a category because no commitment is under it yet.

**A category is the roster's and never the commitment's.** Putting a commitment under one SHALL
change nothing about the commitment itself: the same name, the same schedule, the same day it is
kept from and the same kind, so it goes on answering whether it is due on a date exactly as it did
before and every record already made against it stands. That is why a category may change at all —
a fifth part on the commitment would orphan everything recorded against it the moment a person
refiled it. ADR-1038.

**A category cuts across the three states rather than adding one.** A commitment the roster has
stopped keeping or removed goes on being under the category it was under, and is read back under it
wherever such a commitment is read back. But the roster SHALL refuse to *change* the category on a
commitment it is not keeping — one it does not hold at all, one it has stopped keeping, or one it has
removed — and SHALL report that rather than doing nothing silently, exactly as it refuses to move
one. A stopped commitment is not on the list a person is filing things on, and a change made against
it would be a change made to a list nobody is looking at. A roster asked for one SHALL be left
exactly as it was.

**Putting a commitment under the category it is already under SHALL be accepted**, SHALL report that
the roster put it under the category, and SHALL leave the roster the same roster it was. It is not a
refusal, for the reason a drop where a commitment already is is not one: it is a change the roster
can make whose result is the roster it already had.

A roster SHALL NOT be asked what day it is to put a commitment under a category, SHALL NOT record
when one happened, and SHALL NOT change any day a commitment was kept until or the order it holds
its commitments in. **Only a move changes the order**, and putting a commitment under a category is
not a move: a commitment given a category is drawn somewhere else and held exactly where it was, so
taking the category off draws it back where it never stopped being. A roster SHALL be a value here
too: putting a commitment under a category SHALL leave every other roster untouched, and two rosters
alike in every way but the category one commitment is under are different rosters.

#### Scenario: a commitment a roster is keeping is put under the category it was given

- **WHEN** a roster given a commitment named "Creatine" and then one named "Gym", both on a schedule
  listing all seven weekdays and both kept from 1 January 2026, is asked to put "Creatine" under the
  category "Supplements"
- **THEN** the roster reports that it put the commitment under the category
- **AND** it reads back two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"

#### Scenario: a category of nothing but blank space puts a commitment under none, and is not refused

- **WHEN** a roster given a commitment named "Creatine" on a schedule listing all seven weekdays,
  kept from 1 January 2026, puts it under the category "Supplements", and is then asked to put it
  under a category of three spaces
- **THEN** the roster reports that it put the commitment under the category
- **AND** it reads back one group, with no category, holding "Creatine"
- **AND** a roster alike in every way asked instead for a category with nothing in it at all reads
  back that same one group

#### Scenario: a category is held exactly as it was given, blank space at its ends and all

- **WHEN** a roster given a commitment named "Creatine" and then one named "Magnesium", both on a
  schedule listing all seven weekdays and both kept from 1 January 2026, puts "Creatine" under the
  category " Supplements " and "Magnesium" under the category "Supplements"
- **THEN** it reads back two groups, the first " Supplements " with both spaces holding "Creatine"
  and the second "Supplements" holding "Magnesium"
- **AND** a roster alike in every way that puts "Magnesium" under " Supplements " too reads back one
  group holding both

#### Scenario: putting a commitment under the category it is already under is accepted and changes nothing

- **WHEN** a roster given a commitment named "Creatine" on a schedule listing all seven weekdays,
  kept from 1 January 2026, puts it under the category "Supplements", and is then asked to put it
  under "Supplements" again
- **THEN** the roster reports that it put the commitment under the category
- **AND** it is the same roster as one asked only once

#### Scenario: putting a commitment the roster is not keeping under a category is refused

- **WHEN** a roster given a commitment named "Creatine", then one named "Gym", then one named
  "Journaling", all on a schedule listing all seven weekdays and all kept from 1 January 2026, stops
  keeping "Gym" as of 31 January 2026 and removes "Journaling" as of that same day, and is then
  asked to put "Gym" under the category "Sport"
- **THEN** the roster reports that it did not put the commitment under the category
- **AND** the roster is the same roster as one that was never asked
- **AND** asking it to put "Journaling" under "Sport", and asking it to put a commitment named "Run"
  alike in every other way and never given to it under "Sport", each report that it did not put the
  commitment under the category and leave the roster the same

#### Scenario: a commitment the roster has stopped keeping is still under the category it was under

- **WHEN** a roster given a commitment named "Creatine" and then one named "Gym", both on a schedule
  listing all seven weekdays and both kept from 1 January 2026, puts "Creatine" under the category
  "Supplements", stops keeping "Creatine" as of 31 January 2026, and is then given a commitment
  alike in every way to "Creatine" under "Supplements"
- **THEN** it reads back two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** it is the same roster as one given the two, asked to put "Creatine" under "Supplements",
  and never asked to stop keeping anything

#### Scenario: putting a commitment under a category changes no day, no commitment and no order

- **WHEN** a roster given a commitment named "Creatine" kept from 1 January 2026, then one named
  "Gym" kept from 1 March 2026, then one named "Journaling" kept from 1 June 2026, all on a schedule
  listing Monday, Wednesday and Saturday, stops keeping "Creatine" as of 31 January 2026, and then
  puts "Journaling" under the category "Evening"
- **THEN** the roster answers with "Creatine" on 31 January 2026 and without it on 1 February 2026,
  the day it was kept until unmoved
- **AND** each of the three reads back the day it is kept from unchanged
- **AND** "Gym" is due on Monday 2 March 2026 and not due on Tuesday 3 March 2026, exactly as it was
  before
- **AND** the roster reads back the commitments it is keeping as "Gym" and then "Journaling", in the
  order it held them before

#### Scenario: putting a commitment under a category on a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Creatine" and then one named "Gym", both on a
  schedule listing all seven weekdays and both kept from 1 January 2026, is copied, and the copy
  puts "Creatine" under the category "Supplements"
- **THEN** the copy reads back two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** the roster it was copied from reads back one group, with no category, holding "Creatine"
  and then "Gym", and is not the same roster as the copy

### Requirement: A roster reads the commitments it is keeping in groups, one per category

A roster SHALL read back the commitments it is keeping in **groups**: a group is a category, or no
category at all, together with the commitments under it, in the order the roster holds them. It
SHALL answer the same way about a calendar date, with the commitments it had not stopped keeping on
that date. This is the one place in the product where grouping is worked out, and everything that
draws groups draws these.

**A group sits where its first commitment sits in the order the roster holds its commitments.** The
groups SHALL be in the order in which each category is first met, walking the commitments in the
roster's own order, and the commitments within a group SHALL be in that same order. **The group of
the commitments under no category SHALL come last**, wherever the first of them sits, and SHALL be
absent entirely where every commitment is under a category. A group for a category no commitment is
under SHALL NOT exist, so a category whose last commitment has been put under another has no group
and there is nothing left to delete.

The roster SHALL invent no other arrangement. It MUST NOT sort the groups by their category, MUST
NOT sort within a group, and MUST NOT put the group with no category anywhere but last: ordering by
the words would be a rule about the owner's own words, which is the argument the order itself has
always rested on. Placing a group where its first commitment sits is not such a rule — it is the
person's order, read a second way — and putting the uncategorised last is the one arrangement that
leaves a roster nobody has categorised looking exactly as it looked before there were categories.

**The groups are a reading of the roster's one order and not a second order.** The order the roster
holds its commitments in is unchanged by anything about a category, and the flat reads — the
commitments it is keeping, and the commitments it had not stopped keeping on a date — SHALL go on
answering in that order and SHALL NOT be grouped or rearranged. Reading in groups and reading flat
therefore answer with the same commitments, each exactly once, and disagree only in the order they
come in. Nothing is stored for a group: they are worked out on every read, from the order and the
categories, and there is nowhere for the two readings to drift apart.

Reading in groups over a date SHALL take exactly the commitments the roster had not stopped keeping
on that date — the commitments it is keeping, and every commitment whose kept-until day is that date
or later, whether it was stopped or removed — each under the category it is under. A roster holding
nothing at all, and a roster none of whose commitments had been taken on by the date asked about,
SHALL each read back no groups at all rather than one empty group.

#### Scenario: a roster none of whose commitments is under a category reads back one group

- **WHEN** a roster is given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing all seven weekdays and all kept from 1 January 2026
- **THEN** it reads back one group, with no category, holding "Water plants", then "Gym", then
  "Journaling"

#### Scenario: a roster that has been given no commitment reads back no groups at all

- **WHEN** a roster is formed and nothing is added to it
- **THEN** it reads back no groups at all
- **AND** a roster given one commitment and asked to stop keeping it likewise reads back no groups
  at all

#### Scenario: a group sits where its first commitment sits in the order the roster holds them

- **WHEN** a roster is given a commitment named "Creatine", then one named "Gym", then one named
  "Magnesium", then one named "Finances", all on a schedule listing all seven weekdays and all kept
  from 1 January 2026, and puts "Creatine" and "Magnesium" under the category "Supplements" and
  "Gym" under "Sport"
- **THEN** it reads back three groups: "Supplements" holding "Creatine" and then "Magnesium", then
  "Sport" holding "Gym", then a group with no category holding "Finances"
- **AND** the groups are not in alphabetical order

#### Scenario: the commitments under no category come last however early the first of them sits

- **WHEN** a roster is given a commitment named "Finances", then one named "Creatine", then one
  named "Gym", all on a schedule listing all seven weekdays and all kept from 1 January 2026, and
  puts "Creatine" under the category "Supplements" and "Gym" under "Sport"
- **THEN** it reads back three groups: "Supplements" holding "Creatine", then "Sport" holding "Gym",
  then a group with no category holding "Finances"
- **AND** a roster alike in every way that also puts "Finances" under "Supplements" reads back two
  groups, "Supplements" holding "Finances" and then "Creatine", and then "Sport" holding "Gym"

#### Scenario: a category whose last commitment is put under another is no longer a group

- **WHEN** a roster is given a commitment named "Creatine" and then one named "Gym", both on a
  schedule listing all seven weekdays and both kept from 1 January 2026, puts "Gym" under the
  category "Sport", and then puts "Gym" under the category "Supplements"
- **THEN** it reads back two groups, "Supplements" holding "Gym" and then a group with no category
  holding "Creatine"
- **AND** no group is under "Sport"

#### Scenario: reading in groups and reading flat answer with the same commitments in different orders

- **WHEN** a roster is given a commitment named "Creatine", then one named "Gym", then one named
  "Magnesium", all on a schedule listing all seven weekdays and all kept from 1 January 2026, and
  puts "Creatine" and "Magnesium" under the category "Supplements"
- **THEN** it reads back its commitments flat as "Creatine", then "Gym", then "Magnesium", in the
  order it holds them
- **AND** it reads back two groups, "Supplements" holding "Creatine" and then "Magnesium", and then
  a group with no category holding "Gym"

#### Scenario: a roster answers about a date in groups, with what it had not stopped keeping on it

- **WHEN** a roster is given a commitment named "Creatine", then one named "Gym", then one named
  "Journaling", all on a schedule listing all seven weekdays and all kept from 1 January 2026; puts
  "Creatine" under the category "Supplements" and "Gym" under "Sport"; and stops keeping "Gym" as of
  31 January 2026
- **THEN** asked about 31 January 2026 it reads back three groups: "Supplements" holding "Creatine",
  then "Sport" holding "Gym", then a group with no category holding "Journaling"
- **AND** asked about 1 February 2026 it reads back two groups, "Supplements" holding "Creatine" and
  then a group with no category holding "Journaling"

#### Scenario: a removed commitment is in the groups a roster answers a date with, under its category

- **WHEN** a roster is given a commitment named "Creatine" and then one named "Gym", both on a
  schedule listing all seven weekdays and both kept from 1 January 2026; puts "Gym" under the
  category "Sport"; and removes "Gym" as of 31 January 2026
- **THEN** asked about 31 January 2026 it reads back two groups, a group with no category holding
  "Creatine" coming after "Sport" holding "Gym"
- **AND** asked about 1 February 2026 it reads back one group, with no category, holding "Creatine"

### Requirement: A commitments screen puts a commitment under a category, and offers the categories in use

A commitments screen SHALL put a commitment on the list of what it keeps under a **category**, on
being given that commitment and the category, and SHALL keep that at the roster place before either
list says so. It SHALL ask for no confirmation: a category is one word, changing it is one act, and
changing it back is the undo. This is one of the two ways a category changes on this screen; the
other is a **drag**, which carries a category because a drop lands in a group.

A commitments screen asked to put a commitment it does not keep under a category — one on the list
of what it has stopped, or one neither of its lists holds — SHALL do nothing and SHALL say nothing,
by the rule that already governs a commitment neither list holds. The roster's own refusal is
therefore never reached through this screen and there is nothing for it to word. One it could not
keep at the roster place SHALL be refused as a roster that could not be written, leaving both lists
as they were and the commitment under the category it was already under. That is the **sixth** kind
of refused change a commitments screen holds, and it SHALL name the commitment it was asked about.

A category made of nothing but blank space SHALL put the commitment under none and SHALL NOT be
refused, which is how a category is taken off. Nothing else about a category SHALL be refused, and
the screen SHALL pass it to the roster exactly as it was given: it MUST NOT trim it, MUST NOT fold
its case, and MUST NOT match it loosely against a category already in use. A screen that folded case
would be choosing which of a person's spellings a heading shows.

**A commitments screen SHALL offer the categories already in use**, so that a person picks one
rather than typing it again. They SHALL be the categories the commitments it **keeps** are under,
each once, in the order the screen draws its groups; a screen keeping nothing under any category
SHALL offer none. They are read off the roster the screen is drawing rather than held anywhere, so a
category whose last kept commitment has been put under another is gone from what is offered at the
same moment its heading goes, and a category is never offered that no heading shows.

**The offering is what makes typing safe rather than a convenience.** A phone capitalises the first
letter of a field, so "Supplements" typed once and "supplements" typed the next time would silently
become two groups — and the alternative, folding case when matching, would have the app decide which
spelling a person meant. Offering the words already in use removes the problem instead of judging
the owner's words. A category a person types that matches none of them is accepted exactly as typed
and becomes a group of its own, which is how the first commitment under a new category gets there.

**A category on a commitment the screen has stopped is not offered**, and that is deliberate rather
than an omission: the categories offered are the ones a heading is drawn for, the stopped list draws
no headings, and a stopped commitment brings its own category back with it when it is taken up again
in one tap. Nothing is lost by leaving it out, and offering it would draw a word from a list nobody
is looking at.

#### Scenario: a commitment is put under a category through a commitments screen and kept at the roster place

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; and "Creatine" is put under the category
  "Supplements" through it
- **THEN** nothing is refused
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** a commitments screen opened afterwards at that place as of that same day keeps those same
  two groups

#### Scenario: a category taken off through a commitments screen draws its commitment among the ones under none

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Creatine" is put under a category of three spaces through it
- **THEN** nothing is refused
- **AND** what it keeps is one group, with no category, holding "Creatine" and then "Gym"

#### Scenario: a commitments screen offers the categories the commitments it keeps are under, each once

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Magnesium", then one
  named "Finances", all on a schedule listing all seven weekdays and kept from 1 January 2026, are
  taken on at a roster place; "Creatine" and "Magnesium" are put under the category "Supplements"
  there and "Gym" under "Sport"; and a commitments screen is opened at that roster place as of
  Monday 31 August 2026
- **THEN** the categories it offers are "Supplements" and then "Sport", in the order it draws its
  groups
- **AND** "Supplements" is offered once

#### Scenario: a commitments screen keeping nothing under a category offers none

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; and a commitments screen is
  opened at that roster place as of Monday 31 August 2026
- **THEN** the categories it offers are none
- **AND** what it keeps is one group, with no category, holding "Gym" and then "Journaling"

#### Scenario: a commitments screen offers no category that only a commitment it has stopped is under

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and stopped there as of Sunday 30 August 2026; and a commitments
  screen is opened at that roster place as of Monday 31 August 2026
- **THEN** the categories it offers are none
- **AND** after "Creatine" is taken up again through the screen, the categories it offers are
  "Supplements"

#### Scenario: a category no longer under any commitment kept is no longer offered

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Creatine" is put under the category "Morning" through it
- **THEN** the categories it offers are "Morning"
- **AND** "Supplements" is not among them

#### Scenario: a commitments screen does not fold the case of a category it is given

- **WHEN** a commitment named "Creatine" and one named "Magnesium", both on a schedule listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen
  is opened at that roster place as of Monday 31 August 2026; "Creatine" is put under the category
  "Supplements" through it; and "Magnesium" is put under the category "supplements" through it
- **THEN** what it keeps is two groups, "Supplements" holding "Creatine" and then "supplements"
  holding "Magnesium"
- **AND** the categories it offers are "Supplements" and then "supplements"

#### Scenario: a commitments screen asked to put a commitment it does not keep under a category does nothing and says nothing

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is stopped there
  as of Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Creatine" is put under the category "Supplements" through it
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is one group, with no category, holding "Gym", and what it has stopped is
  one entry, named "Creatine"
- **AND** putting a commitment named "Journaling" on that same schedule and kept-from day, formed
  directly and never taken on, under "Supplements" likewise refuses nothing and changes nothing

#### Scenario: a category change a commitments screen could not keep leaves both its lists as they were

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; what is at that place is then made
  impossible to write; and "Creatine" is put under the category "Supplements" through it
- **THEN** it is refused as a roster that could not be written
- **AND** what it keeps is one group, with no category, holding "Creatine" and then "Gym", and what
  it has stopped is nothing
- **AND** the categories it offers are none

### Requirement: A commitments screen says which group a drop would join, while a drag is live

A commitments screen SHALL say **which group a drop would join**, on being given a commitment on the
list of what it keeps and an offset counted over what it draws. The answer SHALL be a category, or
that the drop would join the commitments under no category, or that there is no group it would join
at all — three answers and not two, because "under none" is a group a person can drop into and "no
group" is the absence of an answer.

**It SHALL be the answer the drop itself would give**, worked out by the same rule and in the same
place: the category of the entry drawn at that offset, or of the last entry drawn where the offset is
the number of entries drawn, and the group the commitment is already in on the two offsets that leave
it where it is drawn. A screen that answered one thing and then did another would be worse than a
screen that said nothing, so this is one rule read twice and never two rules.

Saying it SHALL change nothing. It is a question and not an act: no order, no category, no refused
change, nothing written at the roster place, and no answer given to a refused change the screen is
already holding. It SHALL be answerable while the drag is still live and before anything has moved,
as often as the offset under a person's thumb changes.

**There is no group a drop would join** where the offset is one the list the screen draws does not
have, where the commitment is on the list of what it has stopped, where it is one neither list holds,
and where the screen keeps nothing at all — including a screen that cannot read its roster, which
keeps nothing. Each of those is an ask no drop could satisfy, and each is answered with no group
rather than with a guess.

**The screen answers which group, and nothing is drawn for that answer today.** Which group a drop
would join is the screen's to work out, exactly as an order and a refusal are, and drawing anything
for it would be the app shell's, which decides nothing — but a live drag publishes no destination
the shell could read, so the group a drop would join is known and not yet shown. Were it drawn it is
the group's heading that would carry it, rather than the category on the row itself, because the row
is under a moving thumb and text that moves with a drag is the hardest thing on a phone to read.

**This exists because a drop on the seam between two groups is arithmetic a person cannot see.** The
place after the last row of one group and before the first of the next is one offset, and it joins
the group below; without a mark, a person learns which group they landed in only after the drop has
happened. The mark is what makes a rule that has to pick a side legible while there is still time to
move the thumb.

#### Scenario: a commitments screen says which group a drop at an offset would join

- **WHEN** a commitment named "Creatine", then one named "Magnesium", then one named "Gym", all on a
  schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster place;
  "Creatine" and "Magnesium" are put under the category "Supplements" there; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; and it is asked which group a drop of
  "Gym" at the offset 1 would join
- **THEN** it says "Supplements"
- **AND** asked about the offset 0 it says "Supplements" again

#### Scenario: a drop past the last entry drawn would join the last group drawn

- **WHEN** a commitment named "Gym", then one named "Creatine", then one named "Magnesium", all on a
  schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster place;
  "Gym" is put under the category "Sport" there and "Creatine" and "Magnesium" under "Supplements";
  a commitments screen is opened at that roster place as of Monday 31 August 2026; and it is asked
  which group a drop of "Gym" at the offset 3, which is the number of entries it draws, would join
- **THEN** it says "Supplements", which is the group the last entry drawn is in
- **AND** it does not say "Sport", which is the group "Gym" is drawn in

#### Scenario: a drop among the entries under no category would join no category, which is not no group

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Journaling", all on a
  schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster place;
  "Creatine" is put under the category "Supplements" there; a commitments screen is opened at that
  roster place as of Monday 31 August 2026; and it is asked which group a drop of "Creatine" at the
  offset 3 would join
- **THEN** it says the group under no category
- **AND** that answer is told apart from there being no group a drop would join

#### Scenario: the two offsets that leave a commitment where it is drawn would join the group it is already in

- **WHEN** a commitment named "Creatine", then one named "Magnesium", then one named "Gym", all on a
  schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster place;
  "Creatine" and "Magnesium" are put under the category "Supplements" there and "Gym" under "Sport";
  a commitments screen is opened at that roster place as of Monday 31 August 2026; and it is asked
  which group a drop of "Magnesium" at the offset 1 would join
- **THEN** it says "Supplements", which is the group "Magnesium" is already in
- **AND** asked about the offset 2 it says "Supplements" again, and not "Sport", whose first entry is
  drawn there

#### Scenario: a commitments screen says no group where the offset is one the list it draws does not have

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and it is asked which group a drop of "Gym" at the offset 3, which a list of two
  does not have, would join
- **THEN** it says there is no group a drop would join
- **AND** asked about the offset -1 it says there is no group a drop would join again

#### Scenario: a commitments screen says no group for a commitment it does not keep

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and "Gym" is stopped there as of Sunday 30 August 2026; a commitments
  screen is opened at that roster place as of Monday 31 August 2026; and it is asked which group a
  drop of "Gym" at the offset 0 would join
- **THEN** it says there is no group a drop would join
- **AND** asked about a commitment named "Journaling" on that same schedule and kept-from day, formed
  directly and never taken on, at the offset 0, it says there is no group a drop would join

#### Scenario: a commitments screen that cannot read its roster says no group a drop would join

- **WHEN** a run of bytes that is not a roster store is written at a roster place; a commitments
  screen is opened at that place as of Monday 31 August 2026; and it is asked which group a drop of a
  commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026, formed
  directly, at the offset 0 would join
- **THEN** it says there is no group a drop would join
- **AND** it says it is not keeping a roster, and what it keeps is no groups at all

#### Scenario: the group a commitments screen says a drop would join is the group the drop puts the commitment in

- **WHEN** a commitment named "Creatine", then one named "Magnesium", then one named "Gym", all on a
  schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster place;
  "Creatine" and "Magnesium" are put under the category "Supplements" there; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; it is asked which group a drop of "Gym" at
  the offset 1 would join; and "Gym" is then moved to that same offset
- **THEN** the group it said and the group "Gym" is drawn in afterwards are the same group,
  "Supplements"
- **AND** a screen alike in every way answers and then moves alike at the offset 2, at the offset 3
  and at the offset 0

#### Scenario: asking which group a drop would join changes nothing at the roster place

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there; a commitments screen is opened at that roster place as of Monday
  31 August 2026; the content at that place is read; and the screen is asked which group a drop of
  "Gym" would join at the offset 0, then at the offset 1, then at the offset 2
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** the content at that place is byte-for-byte what was read before it was asked
