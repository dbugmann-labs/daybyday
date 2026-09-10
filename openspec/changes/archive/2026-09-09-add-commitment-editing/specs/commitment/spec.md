## ADDED Requirements

### Requirement: A roster changes a commitment it holds for another, in the place it holds it

A roster SHALL change a commitment it holds for another, on being given the two and the **category**
to put the result under, which may be none. Changing SHALL put the second commitment in the place the
first held, SHALL leave the day that commitment was kept until and whether it was removed exactly as
they were, SHALL put it under the category it was offered under, and SHALL report that it changed.
Nothing else the roster holds SHALL move.

**This is a replacement and deliberately not a removal followed by an addition.** A commitment taken
on third stays third, one the roster has stopped stays stopped on the day it was kept until, and one
it has removed stays removed. Adding would put the result last in an order the person set, and
removing would put a kept-until day on a commitment nobody stopped keeping.

**The category is the offered one, whatever the commitment was under before**, for the reason it is
the offered one when a commitment is taken up again: a change is asked for by something holding a
form, and the category on that form is what the person is saying now. Being offered under no category
takes the category off.

A roster SHALL change a commitment in any of the three states it holds one in, and SHALL leave it in
the state it was in. Which commitments a person can reach in order to change one is a screen's
question and not a roster's: a roster draws no lists and offers nothing.

The roster SHALL refuse to change a commitment in exactly two cases, and SHALL report each rather
than doing nothing silently, for the same reason a refused addition is reported:

- a commitment the roster does not hold at all; and
- a change whose result is a commitment the roster **already holds** — kept, stopped or removed
  alike. This is stricter than what a roster refuses when it is offered a commitment, and the
  difference is deliberate: offering a stopped or removed commitment takes it up again, which is one
  history returning, while changing one commitment into another the roster holds would put two
  histories under one value with no way back to the fact that they were deliberately kept apart.

A roster asked to change a commitment **for itself** SHALL be left exactly as it was and SHALL report
that it changed, exactly as a move that puts a commitment back where it already is is accepted rather
than refused. A change that makes no change is not an error, and a roster asked for one has nothing
to refuse.

Changing SHALL change nothing about either commitment and nothing about what has been recorded
against either. What a record of the commitment that was replaced is now a record of is the `record`
capability's question, asked of a history and never of a roster; a roster holds no records and
carries none over.

A roster SHALL be a value here too: changing a commitment SHALL leave every other roster untouched,
and two rosters differing only in one commitment having been changed SHALL be different rosters.

#### Scenario: changing a commitment a roster holds puts the result in the place the one it replaced held

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, is asked to change "Gym" for a commitment named "Gym 🏋️" alike in every other way,
  under no category
- **THEN** the roster reports that it changed the commitment
- **AND** it reads back three commitments in the order "Water plants", then "Gym 🏋️", then
  "Journaling"

#### Scenario: a changed commitment is put under the category the change was offered under

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, under the category "Sport", is asked to change it for a
  commitment named "Gym 🏋️" alike in every other way, under the category "Morning"
- **THEN** the roster reads back one group, "Morning", holding "Gym 🏋️"
- **AND** a roster asked for that same change under no category reads back one group, with no
  category, holding "Gym 🏋️"

#### Scenario: changing a commitment a roster has stopped keeping leaves it stopped, on the day it was kept until

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, stops keeping it as of 31 January 2026, and is then asked to
  change it for a commitment named "Gym 🏋️" alike in every other way, under no category
- **THEN** the roster reports that it changed the commitment
- **AND** it reads back no commitments it is keeping and one it has stopped, named "Gym 🏋️"
- **AND** it answers with "Gym 🏋️" on 31 January 2026 and with nothing on 1 February 2026

#### Scenario: changing a commitment a roster has removed leaves it removed

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, removes it as of 31 January 2026, and is then asked to change
  it for a commitment named "Gym 🏋️" alike in every other way, under no category
- **THEN** the roster reports that it changed the commitment
- **AND** it reads back no commitments it is keeping and none it has stopped
- **AND** it answers with "Gym 🏋️" on 31 January 2026 and with nothing on 1 February 2026

#### Scenario: changing a commitment a roster does not hold is refused and leaves the roster as it was

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to change a commitment named "Run" alike in every
  other way for one named "Runs", under no category
- **THEN** the roster reports that it did not change the commitment
- **AND** the roster is the same roster as one that was never asked

#### Scenario: changing a commitment into one the roster already holds is refused, whichever state it holds it in

- **WHEN** a roster given a commitment named "Gym" and one named "Run", both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026, is asked to change "Gym" for a
  commitment named "Run" alike in every other way, under no category
- **THEN** the roster reports that it did not change the commitment
- **AND** the roster is the same roster as one that was never asked
- **AND** a roster that had stopped keeping "Run" as of 31 January 2026 refuses that same change, and
  so does one that had removed it as of that day

#### Scenario: changing a commitment for itself changes nothing and is not refused

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, under the category "Sport", is asked to change that commitment
  for that same commitment, under the category "Sport"
- **THEN** the roster reports that it changed the commitment
- **AND** the roster is the same roster as one that was never asked

#### Scenario: changing a commitment on a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is copied, and the copy changes that commitment for one named
  "Gym 🏋️" alike in every other way, under no category
- **THEN** the copy reads back one commitment, named "Gym 🏋️"
- **AND** the roster it was copied from still reads back one commitment named "Gym" and is not the
  same roster as the copy

### Requirement: A roster supersedes a commitment it is keeping with another, from a day

A roster SHALL **supersede** a commitment it is keeping with another, on being given the two, a
calendar date — the day the superseded commitment was **kept until** — and the **category** to put
the commitment taking its place under, which may be none. Superseding SHALL do three things as one
act: record the date as the day the superseded commitment was kept until, hold that commitment as
**removed**, and take the other commitment on in the place the superseded one held, under the
category it was offered under. It SHALL report that it superseded.

**The commitment taking the place is the one that keeps it**, and the superseded commitment sits
immediately behind it in the roster's order. A person changing a rhythm has not asked for a row to
move, and appending the new commitment would send it to the end of an order they set. The superseded
commitment is drawn in neither of a screen's lists, so the only place the two are read together is a
date's answer, where they are adjacent and only one of them is ever due.

Superseding is the roster's answer to a person changing the rhythm a commitment runs on, and it is
carried this way because **a commitment has no identity of its own** and a record embeds the whole
commitment by value: a rhythm that could change on the commitment would orphan every record already
made against it. ADR-1023 and ADR-1030, both amended for this Story.

The roster SHALL refuse to supersede in exactly two cases, and SHALL report each:

- a commitment the roster is **not keeping** — one it does not hold, one it has stopped keeping, and
  one it has removed alike. There is nothing for a rhythm to decide about days a commitment has none
  of; and
- a superseding commitment the roster **already holds**, kept, stopped or removed alike, for the
  reason a change into one it already holds is refused. A commitment asked to supersede **itself** is
  refused by that same rule and asks for nothing.

The roster SHALL refuse on no date. Any calendar date the system supports SHALL be accepted as the
day the superseded commitment was kept until, including the first and the last, and including a date
earlier than the day that commitment is kept from: such a commitment is one the roster was keeping on
no date at all, exactly as a stop on such a date already leaves one. As everywhere else, the roster
SHALL NOT ask what day it is, SHALL NOT judge either commitment's schedule, and SHALL NOT decide
whether either is due.

Superseding SHALL change nothing about either commitment and nothing about what has been recorded
against either, and **the roster SHALL hold no link between the two**. Nothing reads one, and a
surface with no reader is not a requirement; the cost is that one commitment's record across a change
cannot afterwards be read as a single run.

A roster SHALL be a value here too: superseding SHALL leave every other roster untouched, and two
rosters differing only in a supersession SHALL be different rosters.

#### Scenario: superseding a commitment takes the other one on in the place the superseded one held

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, then one named "Journaling", all kept from 1 January 2026,
  is asked to supersede "Gym" with a commitment named "Gym" on a schedule listing Tuesday and
  Thursday, kept from 1 September 2026, as of 31 August 2026, under no category
- **THEN** the roster reports that it superseded the commitment
- **AND** it reads back three commitments it is keeping, in the order "Water plants", then "Gym" on
  Tuesday and Thursday, then "Journaling"

#### Scenario: a superseded commitment is held removed, on the day it was kept until

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to supersede it with a commitment named "Gym" on a
  schedule listing Tuesday and Thursday, kept from 1 September 2026, as of 31 August 2026, under no
  category
- **THEN** the roster reads back one commitment it is keeping, on Tuesday and Thursday, and none it
  has stopped
- **AND** asked about 31 August 2026 it answers with both, the one on Tuesday and Thursday first
- **AND** asked about 1 September 2026 it answers with the one on Tuesday and Thursday alone

#### Scenario: the commitment that supersedes another is put under the category it was offered under

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, under the category "Sport", is asked to supersede it with a
  commitment named "Gym" on a schedule listing Tuesday and Thursday, kept from 1 September 2026, as
  of 31 August 2026, under the category "Morning"
- **THEN** the roster reads back one group it is keeping, "Morning", holding the commitment on
  Tuesday and Thursday

#### Scenario: superseding a commitment a roster is not keeping is refused

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, stops keeping it as of 31 January 2026, and is then asked to
  supersede it with a commitment named "Gym" on a schedule listing Tuesday and Thursday, kept from
  1 September 2026, as of 31 August 2026, under no category
- **THEN** the roster reports that it did not supersede the commitment
- **AND** the roster is the same roster as one that stopped keeping "Gym" as of 31 January 2026 and
  was never asked
- **AND** a roster that had removed "Gym" as of 31 January 2026 refuses that same supersession, and
  so does one that never held it at all

#### Scenario: superseding a commitment with one the roster already holds is refused

- **WHEN** a roster given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday and one named "Gym" on a schedule listing Tuesday and Thursday, both kept from
  1 January 2026, is asked to supersede the first with the second, as of 31 August 2026, under no
  category
- **THEN** the roster reports that it did not supersede the commitment
- **AND** the roster is the same roster as one that was never asked
- **AND** a roster asked to supersede a commitment with that same commitment refuses it too

#### Scenario: a commitment superseded as of a day before the day it is kept from was kept on no date

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 March 2026, is asked to supersede it with a commitment named "Gym" on a
  schedule listing Tuesday and Thursday, kept from 1 March 2026, as of 28 February 2026, under no
  category
- **THEN** the roster reports that it superseded the commitment
- **AND** asked about 28 February 2026 it answers with both, and asked about 1 March 2026 it answers
  with the one on Tuesday and Thursday alone

#### Scenario: a superseded commitment stays where it was for every date the roster answers about

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, then one named "Journaling", all kept from 1 January 2026,
  is asked to supersede "Gym" with a commitment named "Gym" on a schedule listing Tuesday and
  Thursday, kept from 1 September 2026, as of 31 August 2026, under no category
- **THEN** asked about 31 August 2026 it answers with four commitments, in the order "Water plants",
  the "Gym" on Tuesday and Thursday, the "Gym" on Monday, Wednesday and Saturday, then "Journaling"

#### Scenario: superseding on a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is copied, and the copy supersedes it with a commitment named
  "Gym" on a schedule listing Tuesday and Thursday, kept from 1 September 2026, as of
  31 August 2026, under no category
- **THEN** the copy reads back one commitment it is keeping, on Tuesday and Thursday
- **AND** the roster it was copied from still reads back one commitment named "Gym" on Monday,
  Wednesday and Saturday, and is not the same roster as the copy

### Requirement: A commitments screen says what a commitment it is asked to change is made of

A commitments screen SHALL say, for a commitment on either of its lists, the four things a change is
asked with — the **name** it has, the **rhythm** it runs on, the **day it is kept from** and the
**category** it is under — so that a form opened to change it starts from what that commitment is
rather than from what a new one would be. For a commitment on neither of its lists it SHALL say
nothing at all.

The rhythm it says SHALL be the one of the four that names that commitment's schedule, carrying the
number that schedule carries. An **interval** rhythm carries no start date, so an interval schedule's
own start date is not part of what is said; the day the commitment is kept from is said separately,
and on a commitment this screen defined the two are the same day. There is no rhythm a commitment's
schedule cannot be said as, because every schedule this screen can define one on was named by a
rhythm in the first place.

It SHALL also say **whether the rhythm and the day kept from can be changed at all**: they can for a
commitment its roster is keeping, and they cannot for one it has stopped keeping. A stopped
commitment has no days left for a rhythm to decide about, so the only change it takes is a rename.
The **kind** its days take is not among the four and is not said here: a kind never changes, so a
form has nothing to offer for it.

This says what a commitment *is*, and no words a person reads. What a form draws, where it is reached
from and which of its fields it lets a thumb into are the drawing's, exactly as they already are for
everything else this screen answers. ADR-1022.

#### Scenario: a commitments screen says what a commitment it keeps is made of, on each of the four rhythms

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, one named
  "Finances" on a schedule on the 25th of the month, one named "Contact lenses" on a schedule of
  every 14 days starting on 1 January 2026, and one named "Reading" on a schedule of 3 times a week,
  all kept from 1 January 2026, are taken on at a roster place; and a commitments screen is opened at
  that roster place as of Monday 31 August 2026
- **THEN** what it says each is made of names a weekday-set rhythm of Monday, Wednesday and Saturday,
  a day-of-the-month rhythm of the 25th, an interval rhythm of 14 days and a weekly-quota rhythm of
  3 times a week, in that order
- **AND** each says the name that commitment has and 1 January 2026 as the day it is kept from

#### Scenario: a commitments screen says the category a commitment it keeps is under

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there; and a commitments screen is opened at that roster place as of Monday
  31 August 2026
- **THEN** what it says "Creatine" is made of says the category "Supplements"
- **AND** what it says "Gym" is made of says no category at all

#### Scenario: a commitments screen says a stopped commitment's rhythm and day kept from cannot be changed

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped there as of
  Sunday 30 August 2026; and a commitments screen is opened at that roster place as of Monday
  31 August 2026
- **THEN** what it says "Gym" is made of says its rhythm and the day it is kept from cannot be changed
- **AND** what it says "Journaling" is made of says they can

#### Scenario: a commitments screen says nothing about a commitment on neither of its lists

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is removed there as of
  Sunday 30 August 2026; and a commitments screen is opened at that roster place as of Monday
  31 August 2026
- **THEN** it says nothing about what "Gym" is made of
- **AND** it says nothing about what a commitment named "Run" alike in every other way, which its
  roster has never held, is made of

### Requirement: A commitments screen changes a commitment on either of its lists

A commitments screen SHALL change a commitment on either of its lists, from the same four things it
defines one from and no others: a **name**, a **rhythm**, the **day it is kept from**, and the
**category** to put it under, which may be none. It SHALL work out from those four which of two acts
the change needs, and where it needs both it SHALL perform them in one order and no other.

- **A different name, a different day kept from, or both, on the rhythm the commitment already runs
  on.** The screen SHALL carry every record of that commitment over to the changed one at the record
  place, and SHALL then change the commitment for the changed one at the roster place, in the place
  the roster holds it. Every past day afterwards draws the changed commitment and answers about it
  exactly as it answered about the one it replaced. **A name is not a rule** — nothing is due or not
  due because of it — and **the day a commitment is kept from is a claim about a person's own
  history** rather than a rule about days ahead, so correcting either corrects the whole of what has
  been kept rather than starting something new.
- **A different rhythm.** The screen SHALL supersede: the commitment is kept until the day **before**
  the day the screen was handed and held removed, and the commitment the four things name — kept from
  the day the screen was handed — is taken on in its place. **No record moves and no past day
  changes its answer**: the new rhythm decides the days from today onward and every day already lived
  answers exactly as it did (ADR-1013).
- **Both, in one save: the carry-over first, then the supersession.** It is the only order that
  satisfies the two rules above at once — the superseded commitment then carries the new name and the
  corrected day it was kept from, so every past day redraws correctly, while the commitment taken on
  carries the new name, the new rhythm and the day the screen was handed as the day it is kept from.
  The day the person typed into the field reaches the past, which is what they were correcting, and
  not the commitment starting today, which cannot begin before today without rewriting the days
  behind it.

**On an interval rhythm the day a commitment is kept from is also the rhythm's start date, and
changing that day moves the grid with it.** A commitment kept every N days from one day is due on that
day and every N days after it, so a change that names a different day SHALL form the changed
commitment's schedule from the day the change names, exactly as defining one does: one date is offered
and one date answers for both, and a person is never asked for a second. The days such a commitment
was due on before the change are therefore not the days it is due on after it. On the other three
rhythms — a weekday set, a day of the month, a weekly quota — dueness does not depend on the day kept
from at all, so moving that day earlier only widens the window and every day already recorded on stays
due. That difference is why the refusal below is about what the change would leave, and never about
which way the day moved.

**The record place is written before the roster place, and that order is part of the decision.** The
two are separate files and nothing makes one write of both. Written the other way round, a roster
that took the change and a record place that then refused it would leave a past day drawing a
commitment it holds no record of, and asking for the same change again could not repair it, because
the commitment the second ask names as the one to change is no longer the one the records are under.
In the order stated, the same second ask carries nothing over — there is nothing left under the old
commitment — and then writes the roster, which is exactly the repair. Where nothing is carried over,
nothing is written at the record place at all.

**The kind its days take is not one of the four and SHALL NOT change.** The changed commitment SHALL
be of the kind the commitment it replaces is of, on every one of the acts above. ADR-1030.

**Where the four things name the commitment that is already there, and the category it is already
under**, the screen SHALL change nothing, SHALL write nothing at either place and SHALL refuse
nothing. Closing a form opened by accident is not an error.

**A commitment its roster has stopped keeping SHALL be changed in name and category only**, and a
change asking for a different rhythm or a different day kept from on one SHALL be refused as a change
a stopped commitment does not take, told apart from every other refusal, because what a person does
about it — take the commitment up again first — is theirs to do. A commitment its roster has
**removed** is on neither of this screen's lists; a screen asked to change one, or to change any
commitment on neither list, SHALL do nothing and SHALL say nothing, exactly as it already answers
every other change asked about a commitment it does not have.

A change SHALL be refused in the words this screen already uses wherever it already has them, and
for the same reasons: a **name that says nothing**, a **weekday set with no days in it**, a **rhythm
number the calendar will not take**, a **commitment the roster already holds** and a **place that
could not be written**. The fourth is stricter here than it is for defining, and that is the
decision: defining a commitment the roster has stopped or removed takes that commitment up again,
while changing one *into* it would put two histories under one value, so a change whose result the
roster holds in **any** of the three states is refused. The fifth covers the record place as well as
the roster place: neither leaves a person anything to do but try again later, so the two are told the
same way.

Two refusals are this change's own, because nothing before it could produce them, and each SHALL be
told apart from the other five for the reason ADR-1036 gives — a person can act on each, and on each
differently:

- **A change a stopped commitment does not take**, above: take the commitment up again first.
- **A day already recorded on that the change would leave not due.** A change SHALL be refused where
  any day the commitment has a record on is a day the changed commitment is not due on, and carrying
  the record over to a day it could not have been made on is not something this system does. Moving
  the day a commitment is kept from *later* can strand a recorded day on any of the four rhythms. On
  an interval rhythm, where the grid moves with the day, moving it **earlier** does the same: unless
  the day moves by a whole number of intervals, every day already recorded on falls off the new grid.
  What a person does about it is pick a day that leaves every recorded day due, or leave the day
  alone.

Nothing SHALL be kept at either place by a refused change, and neither of the screen's lists SHALL
move.

#### Scenario: a commitment renamed through a commitments screen is drawn under its new name, in the place it held

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; a commitments screen is opened at that roster place as of Monday 31 August 2026; and "Gym"
  is changed through it to the name "Gym 🏋️", on the rhythm and the day kept from it already has,
  under no category
- **THEN** nothing is refused
- **AND** what it keeps is three entries, named "Water plants", then "Gym 🏋️", then "Journaling"
- **AND** a roster store opened afterwards at that place holds those three commitments in that order

#### Scenario: every record of a commitment renamed through a commitments screen is carried over to the new name

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of
  Monday 31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️", on the rhythm and the
  day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** a store opened afterwards at that record place answers that "Gym 🏋️" was kept on Monday
  3 August 2026
- **AND** it answers that "Gym" was not kept on that day

#### Scenario: a commitment whose rhythm is changed through a commitments screen is kept until yesterday and the new one is taken on today

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, on the name and the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** what it keeps is one entry, named "Gym", saying "Tue, Thu"
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with the
  commitment on Monday, Wednesday and Saturday kept from 1 January 2026, and about Monday
  31 August 2026 with the one on Tuesday and Thursday kept from that day

#### Scenario: a rhythm changed through a commitments screen leaves every record already made standing

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of
  Monday 31 August 2026; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, under no category
- **THEN** nothing is refused
- **AND** a store opened afterwards at that record place answers that the commitment on Monday,
  Wednesday and Saturday was kept on Monday 3 August 2026
- **AND** the content at that record place is byte-for-byte what it was before the change

#### Scenario: a name and a rhythm changed in one save put the new name on the superseded commitment

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of
  Monday 31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️" on a weekday-set
  rhythm of Tuesday and Thursday, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with
  "Gym 🏋️" on Monday, Wednesday and Saturday, kept from 1 January 2026
- **AND** what the screen keeps is one entry, named "Gym 🏋️", saying "Tue, Thu"
- **AND** a store opened afterwards at that record place answers that "Gym 🏋️" on Monday, Wednesday
  and Saturday was kept on Monday 3 August 2026

#### Scenario: the day a commitment is kept from is moved earlier through a commitments screen and the days it opens become due

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 August
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 31 August 2026; and "Gym" is changed through it to the day kept from 1 June 2026, on the
  name and the rhythm it already has, under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place holds is due on Monday
  1 June 2026 and on Monday 3 August 2026

#### Scenario: moving the day a commitment is kept from past a day it has a record on is refused

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 June 2026,
  is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a record place; a
  commitments screen is opened at that roster place and that record place as of Monday
  31 August 2026; and "Gym" is changed through it to the day kept from 1 September 2026, under no
  category
- **THEN** it is refused as a day already recorded on that the change would leave not due, told
  apart from a place that could not be written
- **AND** what the screen keeps is one entry named "Gym", and the content at both places is
  byte-for-byte what it was immediately after the screen was opened

#### Scenario: the day an interval commitment is kept from is moved earlier and every day it is due on moves with it

- **WHEN** a commitment named "Contact lenses" on an interval rhythm of 14 days, kept from Wednesday
  1 July 2026, is taken on at a roster place; a commitments screen is opened at that roster place as
  of Monday 31 August 2026; and "Contact lenses" is changed through it to the day kept from Monday
  29 June 2026, on the name and the rhythm it already has, under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place holds is due on Monday 29 June
  2026 and on Monday 13 July 2026
- **AND** it is not due on Wednesday 1 July 2026

#### Scenario: moving the day an interval commitment is kept from off a day it has a record on is refused

- **WHEN** a commitment named "Contact lenses" on an interval rhythm of 14 days, kept from Wednesday
  1 July 2026, is taken on at a roster place; a tick for it on Wednesday 15 July 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of Monday
  31 August 2026; and "Contact lenses" is changed through it to the day kept from Monday 29 June 2026,
  on the name and the rhythm it already has, under no category
- **THEN** it is refused as a day already recorded on that the change would leave not due, told apart
  from a place that could not be written
- **AND** what the screen keeps is one entry named "Contact lenses", and the content at both places is
  byte-for-byte what it was immediately after the screen was opened

#### Scenario: an interval commitment's day kept from moved earlier by a whole number of intervals leaves every recorded day due

- **WHEN** a commitment named "Contact lenses" on an interval rhythm of 14 days, kept from Wednesday
  1 July 2026, is taken on at a roster place; a tick for it on Wednesday 15 July 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of Monday
  31 August 2026; and "Contact lenses" is changed through it to the day kept from Wednesday 17 June
  2026, on the name and the rhythm it already has, under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place holds is due on Wednesday
  17 June 2026 and on Wednesday 15 July 2026
- **AND** a store opened afterwards at that record place answers that the commitment kept from
  Wednesday 17 June 2026 was kept on Wednesday 15 July 2026
- **AND** it answers that the commitment kept from Wednesday 1 July 2026 was not kept on that day

#### Scenario: a change whose result the roster already holds is refused, whichever state it holds it in

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; and "Gym" is changed through it to the
  name "Run", under no category
- **THEN** it is refused as a commitment already kept
- **AND** what it keeps is two entries, named "Gym" and then "Run"
- **AND** the same change is refused the same way on a screen whose roster had stopped keeping "Run"
  as of Sunday 30 August 2026, and on one whose roster had removed it as of that day

#### Scenario: a change that names what is already there changes nothing and refuses nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, under the category "Sport", is taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; and "Gym" is changed through it to exactly
  the name, rhythm, day kept from and category it already has
- **THEN** nothing is refused
- **AND** what it keeps is one group, "Sport", holding one entry named "Gym"
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a stopped commitment renamed through a commitments screen stays stopped, on the day it was kept until

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped there as of
  Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️", on the rhythm and the day
  kept from it already has, under no category
- **THEN** nothing is refused
- **AND** what it has stopped is one entry, named "Gym 🏋️"
- **AND** what it keeps is one entry, named "Journaling"

#### Scenario: changing the rhythm or the day kept from of a stopped commitment is refused

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; "Gym" is stopped there as of Sunday 30 August 2026;
  a commitments screen is opened at that roster place as of Monday 31 August 2026; and "Gym" is
  changed through it to a weekday-set rhythm of Tuesday and Thursday, under no category
- **THEN** it is refused as a change a stopped commitment does not take, told apart from a commitment
  already kept and from a place that could not be written
- **AND** a change to the day kept from 1 June 2026 on that same stopped commitment is refused the
  same way
- **AND** what it has stopped is one entry, named "Gym"

#### Scenario: a commitments screen asked to change a commitment on neither of its lists does nothing and says nothing

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is removed there as of
  Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️", under no category
- **THEN** nothing is refused
- **AND** what it keeps is one entry named "Journaling" and what it has stopped is nothing
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a change a commitments screen could not keep leaves both places as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; what is at that place is then made impossible to write; and "Gym" is
  changed through it to the name "Gym 🏋️", under no category
- **THEN** it is refused as a place that could not be written, told apart from a commitment already
  kept
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a change refuses a name that says nothing, a rhythm due on no day and a rhythm number the calendar will not take

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and "Gym" is changed through it three times — once to the name "   ",
  once to a weekday-set rhythm listing no weekdays, and once to a day-of-the-month rhythm of the 32nd
- **THEN** the three are refused as a name that says nothing, a rhythm due on no day and a rhythm
  number the calendar will not take, each told apart from the others
- **AND** what it keeps is one entry, named "Gym", after all three

#### Scenario: a commitment of the number kind changed through a commitments screen keeps the kind its days take

- **WHEN** a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026, is taken on at a roster place; a commitments
  screen is opened at that roster place as of Monday 31 August 2026; and "Weight" is changed through
  it to the name "Bodyweight", under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place holds is of the number kind
  with a range of 40 to 150

#### Scenario: a rhythm changed on the first date the calendar supports supersedes as of that day itself

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 1583, is taken on at a roster place; a commitments screen is opened at that roster place
  as of 1 January 1583; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place answers about 1 January 1583 with both
  commitments, and about 2 January 1583 with the one on Tuesday and Thursday alone

## MODIFIED Requirements

### Requirement: A commitment is a name, a schedule, and the day it is kept from

A commitment SHALL be exactly four things: a name, the schedule that decides which days it is due
on, the calendar date from which it is kept, and the kind of record its days take. It SHALL carry
nothing else. In particular it has no identifier of its own, no record of what was ticked, no
position in a list, and no state that can be paused or archived — a commitment is what it is made
of, and nothing more. The name it was given SHALL be readable back, and so SHALL the kind.

The first three SHALL be required. The system MUST NOT form a commitment without a day it is kept
from, and MUST NOT supply one of its own in place of a missing one: it cannot know what day it is,
because the present moment is not something this capability is allowed to consult, and a default of
any other kind would be a guess about a person's history. The kind is the one part with a default,
and that default is the plain kind — a tick — because a day that takes a tick is what every
commitment took before there was a choice.

Two commitments SHALL be the same commitment when their name, their schedule, the day they are kept
from and their kind are all the same, and SHALL be different commitments when any of the four
differs. This is what "carries nothing else" means where it can be observed: a commitment holds no
hidden identity that would make two commitments a person would call identical distinguishable to the
system. A weight and a mood taken on the same rhythm, from the same day, under one name are two
commitments, because what their days hold is not the same thing.

The day a commitment is kept from is a calendar date, so it already names a day that exists inside
the supported years and needs no validity rule of its own here. It is deliberately not a record of
when the commitment was entered into the app: a person who has been going to the gym since June may
say so, and the day they are keeping it from is then in the past.

The kind is fixed when the commitment is formed and SHALL NOT change afterwards. There is no way to
move a commitment from one kind to another, and there is deliberately none: a record embeds the
whole commitment by value, so a part that changed would orphan everything already recorded against
it.

**Changing a commitment is now a thing a person does, and none of it happens here.** A commitment
still carries nothing else and still has no identity of its own, so no part of one is mutable and
nothing about this requirement moves. What changes is carried one level up and one capability across:
a **different name** or a **different day kept from** is a second commitment that every record of the
first is carried over to (`record`), put in the place the roster holds the first in; a **different
rhythm** is a second commitment the roster takes on in the first's place while holding the first
**removed**, kept until the day before. Neither re-keys anything, because in both cases every record
still embeds a commitment the roster still holds. The **kind** is the one part no change reaches at
all, and that is the ground ADR-1030 stands on: what a person keeps is not something they can edit
into something else. ADR-1023 and ADR-1030, both amended for `add-commitment-editing` (#148).

#### Scenario: a commitment reads back the name it was given

- **WHEN** a commitment is formed with the name "Gym", a schedule listing Monday, Wednesday and
  Saturday, and kept from 1 January 2026
- **THEN** the commitment's name reads back as "Gym"

#### Scenario: two commitments alike in name, schedule and kept-from day are the same commitment

- **WHEN** two commitments are formed, both named "Gym", both on a schedule listing Monday,
  Wednesday and Saturday, and both kept from 1 January 2026
- **THEN** the two are the same commitment

#### Scenario: two commitments differing only in name are different commitments

- **WHEN** two commitments are formed on the same schedule listing Monday, Wednesday and Saturday
  and kept from the same 1 January 2026, one named "Gym" and one named "Run"
- **THEN** the two are different commitments

#### Scenario: two commitments differing only in schedule are different commitments

- **WHEN** two commitments are formed, both named "Gym" and both kept from 1 January 2026, one on a
  schedule listing Monday and one on a schedule listing Tuesday
- **THEN** the two are different commitments

#### Scenario: two commitments differing only in the day they are kept from are different commitments

- **WHEN** two commitments are formed, both named "Gym" and both on a schedule listing Monday,
  Wednesday and Saturday, one kept from 1 January 2026 and one kept from 2 January 2026
- **THEN** the two are different commitments

#### Scenario: two commitments differing only in the kind their days take are different commitments

- **WHEN** two commitments are formed, both named "Gym", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, one of the tick kind and one of the note
  kind
- **THEN** the two are different commitments

#### Scenario: two number commitments differing only in their range are different commitments

- **WHEN** two commitments are formed, both named "Weight", both on a schedule listing Monday,
  Wednesday and Saturday, both kept from 1 January 2026 and both of the number kind, one with a
  range of 40 to 150 and one with no range at all
- **THEN** the two are different commitments
- **AND** a third alike in every way but carrying a range of 40 to 200 is a different commitment
  again

### Requirement: A roster holds the commitments a person keeps, in the order they were taken on

A roster SHALL hold commitments, in an order it holds, and SHALL read back, in that order, every
commitment it has not stopped keeping. A roster that has been given no commitment SHALL
hold none, and SHALL be an answer rather than a refusal: a person who keeps nothing yet has an empty
roster, not a missing one. There SHALL be no upper bound on how many commitments a roster holds.

**The order SHALL be the person's.** The order the commitments were taken on is its initial value
and the place a newly taken-on commitment lands, and **moving** is the only thing that ever changes
the order of the commitments a roster already holds. Two things put a commitment somewhere other than
last, and neither is a move: **changing** one commitment for another puts the second exactly where
the first was, and **superseding** takes the second on in the place the first held. Both are a person
correcting or replacing a row they are looking at, so a row that jumped to the bottom of the list
would be the roster undoing an order they set. A move takes one of exactly two things and there is no third: a **commitment**, which goes where
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
**Changing one commitment for another is not altering one**, and the difference is the whole of why a
change is safe: the roster is handed a second commitment, already formed, and puts it where the first
was — it edits no part of anything, and the commitment it reads back afterwards is the one it was
handed, exactly as before. It still holds no link between the two, and being changed or superseded
gives neither of them a fifth part.
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


#### Scenario: a commitment taken on to supersede another lands in that one's place rather than after every commitment already there

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, then one named "Journaling", all kept from 1 January 2026,
  supersedes "Gym" with a commitment named "Gym" on a schedule listing Tuesday and Thursday, kept
  from 1 September 2026, as of 31 August 2026, under no category
- **THEN** the roster reads back three commitments it is keeping, in the order "Water plants", then
  the "Gym" on Tuesday and Thursday, then "Journaling"
- **AND** a commitment named "Reading" added to that roster afterwards is read back last of the four

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
one under a category, **changing one commitment for another**, **superseding one with another**, and
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
that are under a category**, **asking it to change a commitment it does not hold or to change one
into a commitment it already holds**, **asking it to supersede a commitment it is not keeping or to
supersede one with a commitment it already holds**, and asking it to put one it is not
keeping under a category each leave the roster exactly as it was — so nothing is kept at the place,
and the store says what the roster said. **A change that leaves
the roster exactly as it was SHALL keep nothing at the place either, and SHALL still report what the
roster reported** — a move that put a commitment back where it already was under the category it was
already under, **a group move that put a group back where it already was**, a category change
that put a commitment under the category it was already under, **and a change of a commitment for
itself under the category it was already under**,
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
moving one, moving a group, putting one under a category, changing one for another or superseding one
MUST NOT change what is kept at any other
place. **A change of commitment reaches a record place as well, and a roster store is not what
reaches it**: carrying a commitment's records over is the `record` capability's, kept at its own place
by its own store, and whatever asks for both is what puts them in an order.

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


#### Scenario: a commitment changed through a roster store is read back changed by a store opened afterwards

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken on
  through a roster store; the store is asked to change "Gym" for a commitment named "Gym 🏋️" alike in
  every other way, under the category "Sport"; and a store is opened afterwards at the same place
- **THEN** the first store reports that it changed the commitment
- **AND** the later store's roster reads back three commitments in the order "Water plants", then
  "Gym 🏋️", then "Journaling", with "Gym 🏋️" under "Sport"

#### Scenario: a commitment superseded through a roster store is read back superseded by a store opened afterwards

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store; the store is asked to supersede it with a
  commitment named "Gym" on a schedule listing Tuesday and Thursday, kept from 1 September 2026, as of
  31 August 2026, under no category; and a store is opened afterwards at the same place
- **THEN** the first store reports that it superseded the commitment
- **AND** the later store's roster reads back one commitment it is keeping, on Tuesday and Thursday,
  and none it has stopped
- **AND** that roster answers about 31 August 2026 with both commitments

#### Scenario: a change and a supersession a roster refuses keep nothing at a roster store's place

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing Monday, Wednesday
  and Saturday and both kept from 1 January 2026, are taken on through a roster store; and the store
  is asked to change "Gym" for "Run" under no category, and then to supersede a commitment named
  "Journaling" alike in every other way, which it does not hold, with one named "Journal"
- **THEN** the store reports of each that the roster did not make the change, without an error
- **AND** the content at that place is byte-for-byte what it was before either ask

#### Scenario: a change of a commitment for itself keeps nothing at a roster store's place

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, under the category "Sport", is taken on through a roster store, and the store is
  asked to change that commitment for that same commitment, under the category "Sport"
- **THEN** the store reports that it changed the commitment
- **AND** the content at that place is byte-for-byte what it was before the ask

### Requirement: A commitments screen defines a commitment from a name, a rhythm and the day it is kept from

A commitments screen SHALL define a commitment from four things and no others: a name, a rhythm,
the day it is kept from, and the **category** to put it under, which may be none. **Changing a
commitment takes the same four and no others**, which is why they are four rather than five: one form
serves both, and a fifth thing here would be a field a change had nothing to do with. The commitment so
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

A commitments screen SHALL offer, as the day to keep a **new** commitment from, the day it was
handed. For a commitment it already holds, the day it offers is that commitment's own day and is said
by the requirement *A commitments screen says what a commitment it is asked to change is made of*;
this one is about defining, and defining is what the day the screen was handed is the right answer
for. It
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

### Requirement: A commitments screen tells a commitment it already keeps apart from a roster it could not write

A commitments screen SHALL refuse a commitment its roster is already keeping, and SHALL refuse a
change it could not keep at a place, and SHALL tell the two apart. Neither SHALL change
either of the screen's lists, and neither SHALL change what is at the roster place.

**Both refusals reach further than defining now, and in different directions.** A change to a
commitment is refused as one the roster already holds where the roster holds it in **any** of the
three states rather than only where it is keeping it, because changing one commitment into another
would put two histories under one value where defining one merely takes it up again. And a change the
screen could not keep is told the same way whether it was the **record place** or the **roster place**
that would not take it: a person can do nothing about either but try again later, which is the test
this requirement has always applied.

This deliberately does not follow the day screen, which tells every refused tick the same way
(ADR-1021). The reasoning there was that a refusal a person cannot act on differently should not be
told apart, and it does not carry: a commitment you already keep is your own doing and you can
change the name, the rhythm or the day you keep it from, while a place that will not take a write
leaves a person nothing to do but try again later.

A commitment the roster has **stopped** keeping is not a duplicate. Defining the same three things
again SHALL take that commitment up again, in the place it has, exactly as offering it to the
roster does. **Changing another commitment into it is a duplicate**, and is refused: the way back to
a stopped or a removed commitment stays the deliberate one, and a spelling correction is not it.

#### Scenario: a commitments screen refuses a commitment its roster is already keeping

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and a commitment named "Gym" on a weekday-set rhythm of Monday,
  Wednesday and Saturday, kept from 1 January 2026, is defined through it
- **THEN** it is refused as a commitment already kept
- **AND** what the screen keeps is one entry, named "Gym"
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a commitments screen that could not keep a new commitment says the roster could not be written

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place under a
  directory that cannot be created, and a commitment named "Gym" on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it
- **THEN** it is refused as a roster that could not be written, told apart from a commitment already
  kept
- **AND** what the screen keeps is nothing

#### Scenario: defining a commitment a commitments screen has stopped keeping takes it up again in the place it was taken on in

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling",
  all on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a
  roster place; "Gym" is stopped there as of Sunday 30 August 2026; a commitments screen is opened
  at that roster place as of Monday 31 August 2026; and a commitment named "Gym" on a weekday-set
  rhythm of all seven weekdays, kept from 1 January 2026, is defined through it
- **THEN** it is not refused
- **AND** what the screen keeps is three entries, named "Water plants", then "Gym", then
  "Journaling"
- **AND** what it has stopped is nothing

#### Scenario: a commitment a commitments screen refuses as already kept is not taken on a second time

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and that same commitment is defined through it twice
- **THEN** both are refused as a commitment already kept
- **AND** a roster store opened afterwards at that place holds one commitment

### Requirement: A commitments screen holds the change it refused and why, one at a time

Where a change asked of a commitments screen is refused, the screen SHALL hold **which change was
asked for** and **why it was refused**, as well as answering the refusal to the caller. The two are
not alternatives and neither replaces the other: the refusal answered to the caller is what a test
asserts on and what stops a shell drawn later from swallowing the failure a second time, and what
the screen holds is what a person is told from. A screen that only answered would leave how long a
person is told for to whatever drew it, and that lifetime would then be decided in a layer nothing
regresses.

The change it holds SHALL be one of the eight a person can ask for — defining a commitment, stopping
keeping one, taking a stopped one up again, removing one, moving one, **moving a whole group**,
putting one under a category, or **changing one** — and for the six that are asked about a commitment
already on one of its lists, it SHALL name that commitment. **A refused change names the commitment
it was asked about and not the one it would have produced**, because the row a person is told beside
is the row they tapped, and the commitment they asked for does not exist. **A refused group move SHALL name the category instead**,
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
among them — or to move a group to an offset the groups it draws under a category do not have**,
**asking to change a commitment on neither of its lists**, **asking for a change that names what a
commitment already is** and
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


#### Scenario: a commitments screen holds a refused change against the commitment it was asked to change

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; a commitments screen is opened at that
  roster place as of Monday 31 August 2026; and "Gym" is changed through it to the name "Run", under
  no category
- **THEN** it is refused as a commitment already kept
- **AND** the screen holds that refusal, against changing "Gym"

#### Scenario: a commitments screen holds nothing against a change that asks for no change at all

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is removed there as of
  Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️", under no category
- **THEN** the screen holds no refused change
- **AND** a change of "Journaling" to exactly the name, rhythm, day kept from and category it already
  has leaves the screen holding no refused change either

### Requirement: What a commitments screen holds about a refused change lasts until the app is shown again or a change is kept

A commitments screen SHALL go on holding a refused change until one of exactly two things happens,
and SHALL then hold nothing. Nothing else SHALL end it. Time passing in particular SHALL NOT,
because this capability reads no clock.

**The app being shown again** ends it. That is inherited rather than added: being shown reads the
roster place afresh and forms both lists again from what is then there, and what was refused is an
answer about a place that has since been read again. It SHALL end whether or not the roster can then
be read — a screen that is then not keeping a roster says that instead, and says more than a refused
change ever could.

**A change reaching a place** ends it, whichever of the eight it was and whichever change
was refused before it. Defining a commitment that is taken on, a stop that is kept, a take-up-again
that is kept, a removal that is kept, a move that is kept, **a group move that is kept**, a
category change that is kept and **a change of a commitment that is kept** all
count. A change of a commitment reaches the record place as well as the roster place, and it ends
what is held once it has been kept — one act, one outcome, however many places it touched. This is one rule rather than six because it is
the at-most-one rule above read the other way round: a commitments screen holds the outcome of the
last change asked of it, so a change that is asked for and kept leaves nothing to hold. A person who
has just been told a change landed is not also told that an earlier one did not.

A call that reaches the place with no change to make SHALL NOT end it, by the rule above that such a
call is not a change asked for at all. **A move that drops a commitment where it already is is
exactly such a call** — it is accepted rather than refused, and nothing is kept at the place, so
there is nothing to have answered a notice with — **and so are a group move that leaves a group
where it is drawn, a category change that puts a commitment under the category it is already
under, a change that names what a commitment already is, and a change asked about a commitment on
neither of the screen's lists**. Nor SHALL putting a stop or a removal up for
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


#### Scenario: what a commitments screen holds about a refused change ends when a change to a commitment is kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and "Gym" is then changed through it to
  the name "Gym 🏋️", under no category
- **THEN** the change is not refused
- **AND** the screen holds no refused change

#### Scenario: what a commitments screen holds about a refused change stands when a change names what is already there

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and "Gym" is then changed through it to
  exactly the name, rhythm, day kept from and category it already has
- **THEN** the screen still holds a name that says nothing, against defining a commitment

## REMOVED Requirements

### Requirement: A commitments screen says in words the rhythm its form is building

**Reason:** B-036 — the rhythm-preview line under the form says what the controls immediately above
it already show, and it is taken back rather than narrowed. The words themselves are not lost: a
schedule still says its rhythm in words (ADR-1034), every entry on both of this screen's lists still
says them, and a day screen's row still does. What goes is the one place that said them for a rhythm
nobody had committed to yet — including the two shapes only a half-built rhythm can be in, "No day"
and nothing at all, which existed only to describe a form mid-edit.

**Migration:** none. Nothing else reads what this requirement provides, no requirement in any
capability depends on it, and no record or file on disk is touched by removing it. The five scenarios
under it and the tests carrying their titles go with it, and so does the surface behind them.

