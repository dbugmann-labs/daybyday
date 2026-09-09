## MODIFIED Requirements

### Requirement: A roster holds the commitments a person keeps, in the order they were taken on

A roster SHALL hold commitments, in an order it holds, and SHALL read back, in that order, every
commitment it has not stopped keeping. A roster that has been given no commitment SHALL
hold none, and SHALL be an answer rather than a refusal: a person who keeps nothing yet has an empty
roster, not a missing one. There SHALL be no upper bound on how many commitments a roster holds.

**The order SHALL be the person's.** The order the commitments were taken on is its initial value
and the place a newly taken-on commitment lands, and **moving** is the only thing that ever changes
it. A move takes one of exactly two things and there is no third: a **commitment**, which goes where
the move says on its own, or a **group**, which takes every commitment under one category with it as
a block. A roster MUST NOT sort its commitments by name, by the day each is kept from, by
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
SHALL be kept the same way, and so SHALL removing one, moving one, **moving a whole group**, putting
one under a category, and
taking one up again. There is no
separate step at which a roster store is saved: the app can be stopped at any moment without
warning, and a commitment waiting to be saved would be one a person believes they have taken on. A
roster store that cannot keep a change MUST refuse it and MUST NOT hold it: the roster a store
reports is never ahead of what is kept at its place.

A roster store SHALL report exactly what the roster reports, and MUST NOT turn a roster's own refusal
into an error. Offering a commitment the roster is already keeping, asking it to stop keeping one it
does not hold, asking it to stop keeping one it has already stopped or removed, and asking it to
remove one it does not hold or has already removed, asking it to move one it is not keeping or
to move one to an offset outside the commitments it is keeping, **asking it to move a group no
commitment it is keeping is under, or to move a group to an offset outside the groups it is keeping
that are under a category**, and asking it to put one it is not
keeping under a category each leave the roster exactly as it was — so nothing is kept at the place,
and the store says what the roster said. **A change that leaves
the roster exactly as it was SHALL keep nothing at the place either, and SHALL still report what the
roster reported** — a move that put a commitment back where it already was under the category it was
already under, **a group move that put a group back where it already was**, and a category change
that put a commitment under the category it was already under,
are all such a change: a store keeps what a change made, and a
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
moving one, moving a group or putting one under a category MUST NOT change what is kept at any other
place.

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

#### Scenario: a group moved through a roster store is read back in the order it was moved into

- **WHEN** a commitment named "Gym", then one named "Creatine", then one named "Magnesium", all on a
  schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken on
  through a roster store; "Gym" is put under the category "Sport" through it and "Creatine" and
  "Magnesium" under "Supplements"; the store is asked to move the group "Supplements" to the offset
  0, counted over the two groups it is keeping that are under a category; and a store is opened
  afterwards at the same place
- **THEN** the store reports that it moved the group
- **AND** the later store's roster reads back two groups, "Supplements" holding "Creatine" and then
  "Magnesium", and then "Sport" holding "Gym"
- **AND** the later store's roster reads its commitments back flat as "Creatine", then "Magnesium",
  then "Gym"

#### Scenario: a group move a roster store refuses keeps nothing at its place

- **WHEN** a commitment named "Gym" and one named "Creatine", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store;
  "Creatine" is put under the category "Supplements" through it; the content at that place is read;
  and the store is asked to move the group "Sport", which nothing it keeps is under, to the offset 0
- **THEN** the store reports that it did not move the group, without an error
- **AND** the content at that place is byte-for-byte what was read before
- **AND** asking it to move the group "Supplements" to the offset 2, one above the one group it is
  keeping under a category, likewise reports that it did not move the group and leaves that content
  byte-for-byte what it was

#### Scenario: a group move that leaves a group where it is keeps nothing at a roster store's place

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store;
  "Creatine" is put under the category "Supplements" through it; the content at that place is read;
  and the store is asked to move the group "Supplements" to the offset 0
- **THEN** the store reports that it moved the group
- **AND** the content at that place is byte-for-byte what was read before
- **AND** asking it to move the group "Supplements" to the offset 1 instead leaves that true again

### Requirement: A commitments screen holds the change it refused and why, one at a time

Where a change asked of a commitments screen is refused, the screen SHALL hold **which change was
asked for** and **why it was refused**, as well as answering the refusal to the caller. The two are
not alternatives and neither replaces the other: the refusal answered to the caller is what a test
asserts on and what stops a shell drawn later from swallowing the failure a second time, and what
the screen holds is what a person is told from. A screen that only answered would leave how long a
person is told for to whatever drew it, and that lifetime would then be decided in a layer nothing
regresses.

The change it holds SHALL be one of the seven a person can ask for — defining a commitment, stopping
keeping one, taking a stopped one up again, removing one, moving one, **moving a whole group**, or
putting one under a category — and for the five that are asked about a commitment already on one of
its lists, it SHALL name that commitment. **A refused group move SHALL name the category instead**,
because a group is what was tapped and a category is the whole of what a group is: naming one of its
commitments would point at a row the person did not touch. Which change it was is not
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
to move one into a group the screen draws none of or to an offset that group does not have**,
**asking to move a group the screen draws none of — the group of the commitments under no category
among them — or to move a group to an offset the groups it draws under a category do not have** and
**asking to put a commitment the screen does not keep under a category** each answer nothing and
change nothing, so each
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

#### Scenario: a commitments screen holds a refused group move against the category it was asked to move

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and "Gym" under "Sport"; a commitments screen is opened at that
  roster place as of Monday 31 August 2026; what is at that place is then made impossible to write;
  and the group "Sport" is moved to the offset 0
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against moving the group "Sport"
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then "Sport" holding
  "Gym"

#### Scenario: a commitments screen holds nothing against a group move that asks for no change at all

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there; a commitments screen is opened at that roster place as of Monday
  31 August 2026; the group "Sport", which nothing it keeps is under, is moved to the offset 0; the
  group under no category is moved to the offset 0; and the group "Supplements" is then moved to the
  offset 2, which one group under a category does not have
- **THEN** none of the three is refused
- **AND** the screen holds no refused change
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"

### Requirement: What a commitments screen holds about a refused change lasts until the app is shown again or a change is kept

A commitments screen SHALL go on holding a refused change until one of exactly two things happens,
and SHALL then hold nothing. Nothing else SHALL end it. Time passing in particular SHALL NOT,
because this capability reads no clock.

**The app being shown again** ends it. That is inherited rather than added: being shown reads the
roster place afresh and forms both lists again from what is then there, and what was refused is an
answer about a place that has since been read again. It SHALL end whether or not the roster can then
be read — a screen that is then not keeping a roster says that instead, and says more than a refused
change ever could.

**A change reaching the roster place** ends it, whichever of the seven it was and whichever change
was refused before it. Defining a commitment that is taken on, a stop that is kept, a take-up-again
that is kept, a removal that is kept, a move that is kept, **a group move that is kept** and a
category change that is kept all
count. This is one rule rather than six because it is
the at-most-one rule above read the other way round: a commitments screen holds the outcome of the
last change asked of it, so a change that is asked for and kept leaves nothing to hold. A person who
has just been told a change landed is not also told that an earlier one did not.

A call that reaches the place with no change to make SHALL NOT end it, by the rule above that such a
call is not a change asked for at all. **A move that drops a commitment where it already is is
exactly such a call** — it is accepted rather than refused, and nothing is kept at the place, so
there is nothing to have answered a notice with — **and so are a group move that leaves a group
where it is drawn and a category change that puts a commitment under the category it is already
under**. Nor SHALL putting a stop or a removal up for
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

#### Scenario: what a commitments screen holds about a refused change ends when a group move is kept

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and "Gym" under "Sport"; a commitments screen is opened at that
  roster place as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the group "Sport"
  is then moved to the offset 0
- **THEN** the group move refuses nothing
- **AND** the screen holds no refused change

#### Scenario: what a commitments screen holds about a refused change stands when a group move leaves a group where it is

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and "Gym" under "Sport"; a commitments screen is opened at that
  roster place as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the group
  "Supplements" is then moved to the offset 0
- **THEN** the group move refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment

### Requirement: A roster moves a commitment among the ones it keeps

A roster SHALL move a commitment it is keeping, on being given that commitment, an **offset** — a
place counted over the commitments the roster is keeping **as they stand before the move**, running
from 0, before the first of them, to the number it is keeping, which is after the last — and the
**category** to put it under, which may be none. Moving SHALL put the commitment under that category
and SHALL report that the roster moved the commitment. **Moving is the only thing that ever changes
a roster's order**, and a commitment is one of the two things a move takes: the other is a **group**,
which takes every commitment under one category with it as a block. Everything below is about the
first of the two, and a group move's own rules are stated where they belong.

**A move carries a category because the ask above it does.** A commitment moved into another group's
rows has been moved and recategorised by one act, and a roster that took the two separately would
keep one of them where the other could not be kept. Where a move is asked for with the category the
commitment is already under, the category is the one it already had and nothing about it changes; the
category is applied on every move rather than only on some, so there is no move that silently leaves
it alone.

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

### Requirement: A commitments screen moves a commitment among the ones it keeps

A commitments screen SHALL move a commitment on the list of what it keeps, on being given that
commitment, **the group it was dropped in** and an **offset counted over the entries drawn in that
group as they stand before the move**, and SHALL keep the move at the roster place before the list
says so. It SHALL ask for no confirmation and SHALL ask for nothing else: the gesture is a drag, a
drag is its own confirmation, and dragging back is the undo. This is where the order a **day screen**
draws in is set, as far as the rows inside a group go; the order the **groups** themselves are drawn
in is set by moving a group, which is a second act on this same screen. Between them, this screen is
the only place a person sets either.

**A drop says which group it landed in, and its offset is counted inside that group** — from 0
before the first entry drawn in that group to the number of entries drawn in it, which is after the
last. The group is named by its category, or by there being no category, which is the group of the
commitments under none. Where nothing the screen keeps is under a category there is one group, the
one under none, and an offset counted over that group is an offset counted over the whole list the
screen draws. Turning a place inside a group into a place in the roster's order is this screen's work
and nobody else's: putting it here is what keeps every other layer from holding a second copy of the
grouping rule.

**A drop also says what the row is now under.** The commitment SHALL be put under the category of the
group it was dropped in. A row dropped into another group is therefore moved **and** put under that
group's category by one act, and a row dropped among the entries under no category is moved and has
its category taken off. One ask doing both was chosen over a move that only ever reordered, and the
price is stated rather than hidden: a move is now the second way a category changes, beside the
field.

**The place the commitment comes to stand in the roster's order is immediately before the entry drawn
at that offset in that group**, or immediately after the last entry drawn in that group where the
offset is the number drawn in it. Because the moved commitment is under that group's category once
the drop is made, and a group's entries are drawn in the roster's own order, that is the place that
draws it where it was dropped.

**The end of a group is therefore a place a drop can reach, and reaching it files the commitment in
that group and not in the one drawn after it.** Appending a row to a group is the ordinary thing a
person does with a group, and an offset counted over the whole drawn list could not express it: the
place after a group's last entry and the place before the next group's first are one offset on that
list, so one of the two has to be unreachable. Counting inside the group is what gives them one
offset each.

**Moving a group's first commitment away moves the group**, and that follows from where a group sits
rather than from anything this requirement adds: a group sits where its first commitment sits, so a
group whose first commitment has gone somewhere else is afterwards drawn where its next commitment
sits. A person who moves the only row of a group into another group therefore sees one heading fewer,
and a person who moves a group's top row to the bottom of the list may see that group follow it. It
is stated here because it is the one result of a move that is not the row that was moved. **It is not
how a group is meant to be moved** — moving a group is its own act, which carries the whole group and
leaves every row where it was inside it — and this stays a consequence of moving a *row* rather than
a second way to reach the same end.

**Two offsets leave a commitment where it is drawn, and on those the screen SHALL change nothing at
all** — not the order, and not the category. They are the offset the entry is drawn at within its own
group and the one just after it, and they carve out nothing anywhere else: a commitment dropped in
any group but the one it is already in is filed there at every offset that group has, because its
category changes even where the drawn order would not. A drop that has moved nothing has not
recategorised anything either — a person who picks a row up inside its own group and puts it back
down has said nothing.

**The move is offered on what the screen keeps and nowhere else.** A commitment on the list of what
it has stopped SHALL NOT be moved through this screen: it already has a place in the roster's order,
taking it up again returns it there, and that list is not the one an order is read off. It is not
grouped either, so there is no group on it to drop anything into.

A commitments screen asked to move a commitment neither of its lists holds, one on the list of what
it has stopped, one **into a group it draws none of**, or one to an offset that the group it was
dropped in does not have SHALL do nothing and SHALL say nothing. Each of those asks for no change at
all, by the rule that already governs a commitment neither list holds, so the roster's own two
refusals are never reached through this screen and there is nothing for it to word. **A group it
draws none of** is a category no commitment it keeps is under, and it includes no category at all
where everything it keeps is under one: a group nobody is in is drawn nowhere, so no drop can land
in it, and answering with a new group would be the screen inventing a place a person could not have
pointed at.

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
offsets do this for any commitment dropped in the group it is already in, which is the gesture's own
arithmetic rather than a rule this screen makes.

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
  offset 1 in the group "Supplements"
- **THEN** nothing is refused
- **AND** what it keeps is one group, "Supplements", holding "Creatine", then "Gym", then
  "Magnesium"

#### Scenario: a commitment dropped among the entries under no category has its category taken off

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Journaling", all on
  a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; "Creatine" is put under the category "Supplements" there; a commitments screen is opened at
  that roster place as of Monday 31 August 2026; and "Creatine" is moved to the offset 2 in the
  group under no category, which is the number of entries drawn in it
- **THEN** nothing is refused
- **AND** what it keeps is one group, with no category, holding "Gym", then "Journaling", then
  "Creatine"

#### Scenario: an offset a commitments screen is given is counted over the group a drop landed in and not over the roster's own order

- **WHEN** a commitment named "Gym", then one named "Creatine", then one named "Magnesium", all on
  a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; "Creatine" and "Magnesium" are put under the category "Supplements" there; a commitments
  screen is opened at that roster place as of Monday 31 August 2026; and "Gym" is moved to the
  offset 1 in the group "Supplements"
- **THEN** what it keeps is one group, "Supplements", holding "Creatine", then "Gym", then
  "Magnesium" — the offset naming the entry drawn at it in that group, "Magnesium", and not the
  commitment the roster holds at it, which is "Creatine"
- **AND** a roster store opened afterwards at that place reads back "Creatine", then "Gym", then
  "Magnesium", all three under "Supplements"
- **AND** a screen alike in every way asked to move "Gym" to the offset 3 in the group
  "Supplements", which a group of two entries does not have though the list it draws does, refuses
  nothing and leaves what it keeps exactly as it was

#### Scenario: a drop where a commitment is already drawn changes neither its place nor its category

- **WHEN** a commitment named "Creatine", then one named "Gym", all on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there; a commitments screen is opened at that roster place as of Monday
  31 August 2026; the content at that place is read; and "Creatine" is moved to the offset 1 in the
  group "Supplements"
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** moving "Creatine" to the offset 0 in that same group leaves both of those true again
- **AND** the content at that place is byte-for-byte what was read before either move

#### Scenario: a commitment dropped after the last entry of a group is drawn at the end of that group

- **WHEN** a commitment named "Creatine", then one named "Magnesium", then one named "Gym", then one
  named "Journaling", all on a schedule listing all seven weekdays and kept from 1 January 2026, are
  taken on at a roster place; "Creatine" and "Magnesium" are put under the category "Supplements"
  there and "Gym" and "Journaling" under "Sport"; a commitments screen is opened at that roster
  place as of Monday 31 August 2026; and "Journaling" is moved to the offset 2 in the group
  "Supplements", which is the number of entries drawn in it
- **THEN** nothing is refused
- **AND** what it keeps is two groups, "Supplements" holding "Creatine", then "Magnesium", then
  "Journaling", and "Sport" holding "Gym"
- **AND** "Journaling" is under "Supplements" and not under "Sport", whose first entry is drawn
  immediately after it

#### Scenario: a commitments screen asked to move a commitment into a group it draws none of does nothing and says nothing

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; both are put under the
  category "Supplements" there; a commitments screen is opened at that roster place as of Monday
  31 August 2026; the content at that place is read; and "Gym" is moved to the offset 0 in the group
  under no category, which nothing it keeps is under
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is one group, "Supplements", holding "Creatine" and then "Gym"
- **AND** moving "Gym" to the offset 0 in the group "Sport", which nothing it keeps is under either,
  leaves that true again
- **AND** the content at that place is byte-for-byte what was read before either move

#### Scenario: moving a group's only entry into another group leaves one heading fewer

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Journaling", all on
  a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; "Creatine" is put under the category "Supplements" there and "Gym" under "Sport"; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; and "Gym" is moved
  to the offset 0 in the group "Supplements"
- **THEN** what it keeps is two groups, "Supplements" holding "Gym" and then "Creatine", and then a
  group with no category holding "Journaling"
- **AND** no group is drawn under "Sport"


## ADDED Requirements

### Requirement: A roster moves a group among the groups it is keeping

A roster SHALL move a **group**, on being given the **category** naming it and an **offset** — a
place counted over the groups the roster is keeping that are under a category, **as they stand
before the move**, running from 0, before the first of them, to the number of them, which is after
the last. Moving a group SHALL relocate every commitment under that category and SHALL report that
the roster moved the group. This is the second of the two things a move takes, and between them a
move is still the only thing that ever changes a roster's order.

**Everything under the category travels — kept, stopped and removed alike — and keeps its order
against the others that travel.** This is deliberately not the rule a commitment's move follows,
which passes a stopped or removed commitment lying in its way rather than taking it along, and the
difference is observable rather than a taste: a roster answers about a calendar date in groups too,
drawing the commitments it had not stopped keeping on that date each under its category, so a member
left behind would go on sitting where the group used to be and a day in January would read the groups
in an order the person never set. Carrying every member is what lets a past date read the group order
the person set; the one case where it still does not is named two paragraphs below, and that one
comes from where the block is **placed** rather than from what it carries. ADR-1044.

**The group is put where the offset points, and it arrives as one block.** Unless the offset is one
of the two that ask for the place the group already has, every commitment under that category SHALL
be taken out of the sequence the roster holds and put back **immediately before the first commitment
the roster is keeping under the category of the group that stood at that offset**, or, where the
offset is the number of the groups it is keeping under a category, **immediately after the last
commitment under the category of the last of them**, whatever state that one is in. The first is
measured over the commitments the roster is **keeping**, and not over every commitment under the
target category, because the offset itself is counted over the groups a person can see: measured
against a stopped or removed commitment lying earlier than the target group's first kept one, the
block would come to rest at a place the offset never named, and rest there with nothing refused and
the roster written. The second is deliberately not measured that way, and the difference is not an
oversight: after the last of a group is after every commitment under it either way, so no offset can
land wrong there, and placing after the whole of it leaves the group being measured against unbroken.

**What the first of those costs is paid on a past date, and it is said here rather than found
later.** Where a commitment the roster has stopped keeping or removed under the **target** group lies
earlier in the order than that group's first kept commitment, the arriving block is put after it — so
the roster SHALL afterwards answer about a date on which that commitment was still kept in the
opposite group order to the one it reads back today. That follows from the grouping rule rather than
from this act: a group sits where its first commitment sits, and on such a date the first one under
the target is the stopped one. It is accepted deliberately, as the narrower of two harms — what a
person taps lands where they aimed it, on the list they are looking at, every time, and the
disagreement is reachable only by scrolling back to a date before the stop. ADR-1044.

**Every commitment that does not travel SHALL afterwards be in the order it was in against every
other commitment that does not travel** — kept, stopped and removed alike — and no two of them SHALL
be reordered against each other. Nothing further is promised, and what is not promised is the price
of one order over one roster rather than an omission: a group whose commitments were scattered
through the order comes back **contiguous**, so a commitment under another category that lay between
two of them is afterwards on one side of the whole group. There is one order and every reading comes
off it, so a group cannot be moved in the reading without being moved in the order.

**On those two offsets the group SHALL NOT be taken out of the sequence at all**, and nothing in the
sequence SHALL move. They are the offset the group is at among the groups the roster is keeping under
a category, and the one just after it. The first names the group itself, and immediately before
itself is where it already stands; the second names the group that already follows it, or, where it
is the last of them, is the number of them, which is again where it already stands. The carve-out is
where a scattered group is **not** gathered, and that is the point of it: a person who asks for the
place a group already has has made no change, and gathering would be one. It follows — and is said
rather than left to be discovered — that moving a scattered group away and back does not restore the
roster it started with, because the first of the two moves gathered it.

**An offset is counted over the groups the roster is keeping that are under a category, and over
nothing else.** The group of the commitments under **no** category is not in that count, so there is
no offset that puts a group after it: the reading rule appends that group last wherever its
commitments sit, so such an offset could only draw exactly what the offset before it draws while
changing the order the roster holds — a change nobody could have asked for, which is the
silently-wrong-thing this roster's refusals exist to prevent. A category only a commitment it has
stopped keeping or removed is under is not in the count either, for the reason a stopped commitment
is not in a commitment move's own count: the groups a person is looking at when they move one are
the groups they are keeping.

The roster SHALL refuse to move a group in exactly two cases, and SHALL report each rather than doing
nothing silently, for the same reason a refused move of a commitment is reported:

- **a category no commitment it is keeping is under** — one nothing it holds has ever been under, one
  only a stopped or a removed commitment is under, and **no category at all**. The group of the
  commitments under none is a group the roster reads back and is not a group it moves: where that
  group sits is the reading rule's answer and not the person's.
- **an offset below 0, or above the number of groups it is keeping that are under a category.** Not
  clamped, for the reason a commitment's move is not: a clamp puts a group somewhere nobody asked
  for.

A roster asked either SHALL be left exactly as it was, **its categories included**.

**A group move changes no category, no commitment and no day.** It SHALL put nothing under anything:
every commitment travels under the category it was already under, which is the category that named
the group. The roster SHALL NOT be asked what day it is for a group move, SHALL NOT record when one
happened, SHALL NOT change any day a commitment was kept until or is kept from, and SHALL NOT change
which of the three states it holds any commitment in. Every record already made SHALL stand, and
every commitment SHALL go on answering whether it is due on a date exactly as it did before.

A roster SHALL be a value here too: moving a group SHALL leave every other roster untouched.

#### Scenario: moving a group to the front draws it before every other group under a category

- **WHEN** a roster given a commitment named "Gym", then one named "Creatine", then one named
  "Magnesium", all on a schedule listing all seven weekdays and all kept from 1 January 2026, puts
  "Gym" under the category "Sport" and "Creatine" and "Magnesium" under "Supplements", and is then
  asked to move the group "Supplements" to the offset 0
- **THEN** the roster reports that it moved the group
- **AND** it reads back two groups, "Supplements" holding "Creatine" and then "Magnesium", and then
  "Sport" holding "Gym"
- **AND** it reads its commitments back flat as "Creatine", then "Magnesium", then "Gym"

#### Scenario: moving a group to the end draws it after every other group under a category and before the commitments under none

- **WHEN** a roster given a commitment named "Creatine", then one named "Gym", then one named
  "Finances", all on a schedule listing all seven weekdays and all kept from 1 January 2026, puts
  "Creatine" under the category "Supplements" and "Gym" under "Sport", leaving "Finances" under none,
  and is then asked to move the group "Supplements" to the offset 2, the number of groups it is
  keeping under a category
- **THEN** the roster reports that it moved the group
- **AND** it reads back three groups: "Sport" holding "Gym", then "Supplements" holding "Creatine",
  then a group with no category holding "Finances"
- **AND** it reads its commitments back flat as "Gym", then "Creatine", then "Finances"

#### Scenario: an offset for a group is counted over the groups the roster is keeping that are under a category

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Creatine", then one named "Finances", all on a schedule listing all seven weekdays and all kept
  from 1 January 2026, puts "Gym" under the category "Sport", "Creatine" under "Supplements" and
  "Finances" under "Money", leaving "Water plants" under none, and is then asked to move the group
  "Money" to the offset 1
- **THEN** it reads back four groups: "Sport" holding "Gym", then "Money" holding "Finances", then
  "Supplements" holding "Creatine", then a group with no category holding "Water plants" — the offset
  naming "Supplements", the group that stood at it before the move, as the group the moved group comes
  to stand before
- **AND** a roster alike in every way asked to move the group "Sport" to the offset 3 instead, which
  is the number of groups it is keeping under a category and counts no group for the commitments
  under none, reads back "Supplements" holding "Creatine", then "Money" holding "Finances", then
  "Sport" holding "Gym", then a group with no category holding "Water plants"
- **AND** that group with no category is drawn last in both, though "Water plants" is the first
  commitment the roster holds

#### Scenario: a group's stopped and removed commitments travel with it

- **WHEN** a roster given a commitment named "Creatine", then one named "Magnesium", then one named
  "Gym", then one named "Journaling", all on a schedule listing all seven weekdays and all kept from
  1 January 2026, puts "Creatine" and "Magnesium" under the category "Supplements" and "Gym" and
  "Journaling" under "Sport", stops keeping "Creatine" as of 31 January 2026, and is then asked to
  move the group "Supplements" to the offset 2
- **THEN** the roster reports that it moved the group
- **AND** it reads back two groups, "Sport" holding "Gym" and then "Journaling", then "Supplements"
  holding "Magnesium"
- **AND** asked about 31 January 2026 it reads back two groups, "Sport" holding "Gym" and then
  "Journaling", then "Supplements" holding "Creatine" and then "Magnesium" — the stopped "Creatine"
  under its own group and after "Sport", where the group was moved to
- **AND** a roster that had removed "Creatine" as of that same day instead answers about that day in
  those same two groups, in that same order

#### Scenario: a group's commitments are gathered into one block, keeping their order against each other

- **WHEN** a roster given a commitment named "Creatine", then one named "Gym", then one named
  "Magnesium", all on a schedule listing all seven weekdays and all kept from 1 January 2026, puts
  "Creatine" and "Magnesium" under the category "Supplements" and "Gym" under "Sport", and is then
  asked to move the group "Supplements" to the offset 2
- **THEN** the roster reports that it moved the group
- **AND** it reads its commitments back flat as "Gym", then "Creatine", then "Magnesium" — "Creatine"
  and "Magnesium" together and in the order they were in, and "Gym", which lay between them, on one
  side of both
- **AND** it reads back two groups, "Sport" holding "Gym", then "Supplements" holding "Creatine" and
  then "Magnesium"

#### Scenario: two offsets leave a group where it is, and both are accepted

- **WHEN** a roster given a commitment named "Creatine", then one named "Gym", then one named
  "Magnesium", all on a schedule listing all seven weekdays and all kept from 1 January 2026, puts
  "Creatine" and "Magnesium" under the category "Supplements" and "Gym" under "Sport", is asked to
  move the group "Supplements" to the offset 0, and a roster alike in every way is asked to move it
  to the offset 1
- **THEN** each reports that it moved the group
- **AND** each is the same roster as one that was never asked, reading its commitments back flat as
  "Creatine", then "Gym", then "Magnesium" — the group not gathered
- **AND** each reads back two groups, "Supplements" holding "Creatine" and then "Magnesium", and then
  "Sport" holding "Gym"

#### Scenario: moving the group of the commitments under no category is refused

- **WHEN** a roster given a commitment named "Creatine" and then one named "Gym", both on a schedule
  listing all seven weekdays and both kept from 1 January 2026, puts "Creatine" under the category
  "Supplements", and is then asked to move the group under no category to the offset 0
- **THEN** the roster reports that it did not move the group
- **AND** the roster is the same roster as one that was never asked
- **AND** asking it to move the group named by a category of three spaces to the offset 0 likewise
  reports that it did not move the group and leaves the roster the same

#### Scenario: moving a group no commitment the roster is keeping is under is refused

- **WHEN** a roster given a commitment named "Creatine", then one named "Gym", then one named
  "Journaling", all on a schedule listing all seven weekdays and all kept from 1 January 2026, puts
  "Creatine" under the category "Supplements", "Gym" under "Sport" and "Journaling" under "Money",
  stops keeping "Gym" as of 31 January 2026 and removes "Journaling" as of that same day, and is then
  asked to move the group "Sport" to the offset 0
- **THEN** the roster reports that it did not move the group
- **AND** the roster is the same roster as one that was never asked
- **AND** asking it to move the group "Money" to the offset 0, and asking it to move a group "Evening"
  that nothing it holds has ever been under, each report that it did not move the group and leave the
  roster the same

#### Scenario: an offset below zero and one above the number of groups under a category are both refused for a group

- **WHEN** a roster given a commitment named "Creatine", then one named "Gym", then one named
  "Finances", all on a schedule listing all seven weekdays and all kept from 1 January 2026, puts
  "Creatine" under the category "Supplements" and "Gym" under "Sport", leaving "Finances" under none,
  and is then asked to move the group "Sport" to the offset -1
- **THEN** the roster reports that it did not move the group
- **AND** the roster is the same roster as one that was never asked
- **AND** asking it to move the group "Sport" to the offset 3, one above the two groups it is keeping
  under a category though it reads back three groups in all, reports that it did not move the group
  and leaves the roster the same

#### Scenario: moving a group moves no day and changes no commitment

- **WHEN** a roster given a commitment named "Creatine" kept from 1 January 2026, then one named
  "Gym" kept from 1 March 2026, then one named "Journaling" kept from 1 June 2026, all on a schedule
  listing Monday, Wednesday and Saturday, puts "Creatine" under the category "Supplements" and "Gym"
  under "Sport" and leaves "Journaling" under none, stops keeping "Journaling" as of 31 January 2026,
  and is then asked to move the group "Sport" to the offset 0
- **THEN** the roster answers with "Journaling" on 31 January 2026 and without it on 1 February 2026,
  the day it was kept until unmoved
- **AND** each of the three reads back the day it is kept from unchanged
- **AND** "Gym" is due on Monday 2 March 2026 and not due on Tuesday 3 March 2026, exactly as it was
  before
- **AND** it reads back two groups, "Sport" holding "Gym" and then "Supplements" holding "Creatine",
  each commitment under the category it was already under

#### Scenario: moving a group on a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Creatine" under the category "Supplements" and then
  one named "Gym" under "Sport", both on a schedule listing all seven weekdays and both kept from
  1 January 2026, is copied, and the copy moves the group "Sport" to the offset 0
- **THEN** the copy reads back two groups, "Sport" holding "Gym" and then "Supplements" holding
  "Creatine"
- **AND** the roster it was copied from still reads back "Supplements" holding "Creatine" and then
  "Sport" holding "Gym", and is not the same roster as the copy

#### Scenario: a group is put before the first commitment the roster is keeping under the group at the offset

- **WHEN** a roster given a commitment named "Creatine", then one named "Finances", then one named
  "Magnesium", then one named "Gym", all on a schedule listing all seven weekdays and all kept from
  1 January 2026, puts "Creatine" and "Magnesium" under the category "Supplements", "Finances" under
  "Money" and "Gym" under "Sport", stops keeping "Creatine" as of 31 January 2026 — leaving
  "Supplements" a group whose first commitment is one it has stopped — and is then asked to move the
  group "Sport" to the offset 1
- **THEN** the roster reports that it moved the group
- **AND** it reads back three groups: "Money" holding "Finances", then "Sport" holding "Gym", then
  "Supplements" holding "Magnesium" — "Sport" at the offset it was given, after "Money" and before
  "Supplements", the group that stood at that offset
- **AND** it reads its commitments back flat as "Creatine", then "Finances", then "Gym", then
  "Magnesium" — "Gym" put before "Magnesium", the first commitment the roster is keeping under
  "Supplements", and after "Creatine", which it is not

#### Scenario: a group placed against a kept commitment is read in a different order on a date before a stop

- **WHEN** a roster given a commitment named "Creatine", then one named "Magnesium", then one named
  "Vitamin D", then one named "Gym", all on a schedule listing all seven weekdays and all kept from
  1 January 2026, puts "Creatine", "Magnesium" and "Vitamin D" under the category "Supplements" and
  "Gym" under "Sport", stops keeping "Creatine" as of 31 January 2026, and is then asked to move the
  group "Sport" to the offset 0
- **THEN** the roster reports that it moved the group
- **AND** it reads back two groups, "Sport" holding "Gym", then "Supplements" holding "Magnesium" and
  then "Vitamin D"
- **AND** asked about 31 January 2026, a day on which it had not stopped keeping "Creatine", it reads
  back those two groups the other way round: "Supplements" holding "Creatine", then "Magnesium", then
  "Vitamin D", and then "Sport" holding "Gym" — because on that day the first commitment under
  "Supplements" is the one the move was not measured against
- **AND** it reads its commitments back flat as "Creatine", then "Gym", then "Magnesium", then
  "Vitamin D"

#### Scenario: a roster keeping one group under a category accepts both the offsets it has

- **WHEN** a roster holding a commitment named "Creatine" under the category "Supplements" and then
  one named "Gym" under no category, both on a schedule listing all seven weekdays and both kept from
  1 January 2026, is asked to move the group "Supplements" to the offset 0, and a roster alike in
  every way is asked to move it to the offset 1
- **THEN** each reports that it moved the group
- **AND** each is the same roster as one that was never asked
- **AND** a roster alike in every way asked to move it to the offset 2 reports that it did not move
  the group

### Requirement: A commitments screen moves a group among the groups it draws

A commitments screen SHALL move a group on the list of what it keeps, on being given the **category**
naming that group and an **offset counted over the groups it draws that are under a category, as they
stand before the move**, and SHALL keep the move at the roster place before the list says so. It
SHALL ask for no confirmation and SHALL ask for nothing else: moving a group back is the undo, as it
is for a row. This is where the order the **groups** are drawn in — here and on a **day screen** —
is set, and it is the only place a person sets it.

**The offset is the screen's own count and the roster's alike, and this screen converts nothing.**
The groups it draws are the groups the roster answers with, in that order, so a place among the ones
under a category is the same place at both. That is the whole difference from moving a commitment,
whose offset is counted inside one group and has to be turned into a place in the roster's order
here; there is nothing of the sort to do for a group, and inventing an arithmetic would be this
screen holding a second copy of a rule.

**The group of the commitments under no category is not a group this act takes.** It draws no
heading, so there is nothing on the screen to take hold of; and the reading rule draws it last
wherever its commitments sit, so there is nowhere to put it. A screen asked for it does nothing and
says nothing, which is what it already answers for a group it draws none of.

**Everything under the category moves with the group, and the list of what the screen has stopped is
drawn in a different order afterwards.** That list is one flat list in the roster's own order, a
group move changes that order, and a stopped commitment under the moved category travels with the
group like every other. It is not a second rule and it is not a defect: both lists are read off the
roster after the change, and the alternative — a stopped list that held still — would be a second
order for something to keep in step.

**A group is drawn where the person put it, and a past day may draw the groups the other way round.**
The offset is counted over the groups this screen draws, so the group SHALL come to rest at that
offset on this list, every time. Where the group it was put before has a commitment the screen has
stopped lying earlier in the roster's order than the first one it keeps under that category, what is
kept at the roster place SHALL afterwards answer about a date before that stop with those two groups
in the opposite order. That is the roster's own rule read back through the place this screen keeps,
rather than a second rule of the screen's, and it is the accepted price of landing the group where it
was put.

A commitments screen asked to move a group it draws none of — a category nothing it keeps is under,
and no category at all among them — or to an offset that the groups it draws under a category do not
have SHALL do nothing and SHALL say nothing. Each asks for no change at all, by the rule that already
governs a commitment neither list holds, so the roster's own two refusals are never reached through
this screen and there is nothing for it to word.

A group move the screen could not keep at the roster place SHALL be refused as a roster that could
not be written, leaving both lists as they were, and it SHALL name the **category** it was asked to
move. That is the **seventh** kind of refused change a commitments screen holds, beside defining a
commitment, stopping keeping one, taking one up again, removing one, moving one and putting one under
a category, and it is the first that names something other than a commitment — a group is a category
and the commitments under it, a person tapped the heading, and naming one of the rows would point at
a row they did not touch.

**A group move that leaves a group where it is drawn changes nothing and says nothing.** It is not
refused, it changes neither list, and it does not answer a refused change the screen is already
holding: nothing reached the roster place, so nothing has been proved about it either way. Two
offsets do this for any group — the one it is drawn at among the groups under a category, and the one
just after it — which is the same arithmetic a drop back where a row already is runs on.

#### Scenario: a group moved through a commitments screen is drawn where it was moved to, and is kept there

- **WHEN** a commitment named "Gym", then one named "Creatine", then one named "Magnesium", all on a
  schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster place;
  "Gym" is put under the category "Sport" there and "Creatine" and "Magnesium" under "Supplements"; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; and the group
  "Supplements" is moved to the offset 0
- **THEN** nothing is refused
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then "Magnesium", and
  then "Sport" holding "Gym"
- **AND** a commitments screen opened afterwards at that place as of that same day keeps those two
  groups in that same order

#### Scenario: an offset a commitments screen is given for a group is counted over the groups it draws that are under a category

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Creatine", then
  one named "Finances", all on a schedule listing all seven weekdays and kept from 1 January 2026,
  are taken on at a roster place; "Gym" is put under the category "Sport" there, "Creatine" under
  "Supplements" and "Finances" under "Money"; a commitments screen is opened at that roster place as
  of Monday 31 August 2026; and the group "Sport" is moved to the offset 3, the number of groups it
  draws that are under a category
- **THEN** nothing is refused
- **AND** what it keeps is four groups: "Supplements" holding "Creatine", then "Money" holding
  "Finances", then "Sport" holding "Gym", then a group with no category holding "Water plants"
- **AND** a screen alike in every way asked to move the group "Sport" to the offset 4, which the four
  groups it draws have but the three under a category do not, refuses nothing and leaves what it
  keeps exactly as it was

#### Scenario: a group moved through a commitments screen carries the commitments it has stopped with it

- **WHEN** a commitment named "Creatine", then one named "Magnesium", then one named "Gym", then one
  named "Journaling", all on a schedule listing all seven weekdays and kept from 1 January 2026, are
  taken on at a roster place; "Creatine" and "Magnesium" are put under the category "Supplements"
  there and "Gym" and "Journaling" under "Sport"; "Creatine" and "Journaling" are stopped there as of
  Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and the group "Supplements" is moved to the offset 2
- **THEN** nothing is refused
- **AND** what it keeps is two groups, "Sport" holding "Gym", then "Supplements" holding "Magnesium"
- **AND** what it has stopped is two entries, named "Journaling" and then "Creatine", in the order the
  roster now holds them and not the order they were taken on in
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with two
  groups, "Sport" holding "Gym" and then "Journaling", then "Supplements" holding "Creatine" and then
  "Magnesium"

#### Scenario: a commitments screen asked to move the group of the commitments under no category does nothing and says nothing

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there; a commitments screen is opened at that roster place as of Monday
  31 August 2026; the content at that place is read; and the group under no category is moved to the
  offset 0
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** moving the group named by a category of three spaces to the offset 0 leaves that true again
- **AND** the content at that place is byte-for-byte what was read before either move

#### Scenario: a commitments screen asked to move a group it draws none of does nothing and says nothing

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and "Gym" under "Sport"; "Gym" is stopped there as of Sunday
  30 August 2026; a commitments screen is opened at that roster place as of Monday 31 August 2026;
  the content at that place is read; and the group "Sport" is moved to the offset 0
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is one group, "Supplements", holding "Creatine", and what it has stopped is
  one entry, named "Gym"
- **AND** moving the group "Evening", which nothing either list holds is under, to the offset 0
  leaves that true again
- **AND** the content at that place is byte-for-byte what was read before either move

#### Scenario: a commitments screen given an offset the groups it draws do not have does nothing and says nothing

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and "Gym" under "Sport"; a commitments screen is opened at that roster
  place as of Monday 31 August 2026; the content at that place is read; and the group "Sport" is
  moved to the offset 3, which two groups under a category do not have
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then "Sport" holding
  "Gym"
- **AND** moving the group "Sport" to the offset -1 refuses nothing and leaves what it keeps the same
  again
- **AND** the content at that place is byte-for-byte what was read before either move

#### Scenario: a group move a commitments screen could not keep leaves both its lists as they were

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and "Gym" under "Sport"; a commitments screen is opened at that roster
  place as of Monday 31 August 2026; what is at that place is then made impossible to write; and the
  group "Sport" is moved to the offset 0
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against moving the group "Sport", naming the category and no
  commitment
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then "Sport" holding
  "Gym", and what it has stopped is nothing

#### Scenario: a group move that leaves a group where it is drawn changes nothing and refuses nothing

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Magnesium", all on a
  schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster place;
  "Creatine" and "Magnesium" are put under the category "Supplements" there and "Gym" under "Sport";
  a commitments screen is opened at that roster place as of Monday 31 August 2026; the content at
  that place is read; and the group "Supplements" is moved to the offset 0
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then "Magnesium", and
  then "Sport" holding "Gym"
- **AND** moving the group "Supplements" to the offset 1 leaves that true again
- **AND** the content at that place is byte-for-byte what was read before either move

#### Scenario: a group moved above one whose first commitment is stopped is drawn where the person put it

- **WHEN** a commitment named "Creatine", then one named "Magnesium", then one named "Gym", all on a
  schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster place;
  "Creatine" and "Magnesium" are put under the category "Supplements" there and "Gym" under "Sport";
  "Creatine" is stopped there as of Sunday 30 August 2026, leaving "Supplements" a group whose first
  commitment is one the screen has stopped; a commitments screen is opened at that roster place as of
  Monday 31 August 2026; and the group "Sport" is moved to the offset 0
- **THEN** nothing is refused
- **AND** what it keeps is two groups, "Sport" holding "Gym", then "Supplements" holding "Magnesium" —
  drawn at the offset it was given and not after "Supplements"
- **AND** what it has stopped is one entry, named "Creatine"
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with
  those two groups the other way round, "Supplements" holding "Creatine" and then "Magnesium", and
  then "Sport" holding "Gym"

#### Scenario: a commitments screen shown again draws its groups in the order they were moved into

- **WHEN** a commitment named "Gym" and one named "Creatine", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is put under the
  category "Sport" there and "Creatine" under "Supplements"; a commitments screen is opened at that
  roster place as of Monday 31 August 2026; the group "Supplements" is moved to the offset 0; and the
  screen is shown again as of Tuesday 1 September 2026
- **THEN** what it keeps is two groups, "Supplements" holding "Creatine" and then "Sport" holding
  "Gym"
