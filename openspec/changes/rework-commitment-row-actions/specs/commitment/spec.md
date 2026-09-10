## ADDED Requirements

### Requirement: A commitments screen offers the categories in use

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

**Two spellings that differ only in case are two categories, and SHALL be offered as two.** The
screen MUST NOT fold the case of a category and MUST NOT match one loosely against a category
already in use, here or anywhere else it handles one: a screen that folded case would be choosing
which of a person's spellings a heading shows. What it offers is what the roster holds, exactly as
the roster holds it.

**A category on a commitment the screen has stopped is not offered**, and that is deliberate rather
than an omission: the categories offered are the ones a heading is drawn for, the stopped list draws
no headings, and a stopped commitment brings its own category back with it when it is taken up again
in one tap. Nothing is lost by leaving it out, and offering it would draw a word from a list nobody
is looking at.

**What is offered is picked on the act that writes a category without a move: a change.** The
category is one of the four things a change is made of, so a person who wants a word already in use
takes it from what this requirement offers rather than typing it a second time, and the screen that
offers a word is the screen that writes it. A **move** writes a category too — a commitment dropped
into another group is put under that group's category by the same act — but a move needs no
offering: the word it writes is the one the group it landed in already carries.

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
  31 August 2026; and "Creatine" is changed through it to the category "Morning", on the name, the
  rhythm and the day kept from it already has
- **THEN** the categories it offers are "Morning"
- **AND** "Supplements" is not among them

#### Scenario: a commitments screen does not fold the case of a category it is given

- **WHEN** a commitment named "Creatine" and one named "Magnesium", both on a schedule listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen
  is opened at that roster place as of Monday 31 August 2026; "Creatine" is changed through it to the
  category "Supplements"; and "Magnesium" is changed through it to the category "supplements", each
  on the name, the rhythm and the day kept from it already has
- **THEN** what it keeps is two groups, "Supplements" holding "Creatine" and then "supplements"
  holding "Magnesium"
- **AND** the categories it offers are "Supplements" and then "supplements"

## MODIFIED Requirements

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
**changing one** — and for the five that are asked about a commitment already on one of its lists, it
SHALL name that commitment. **A refused change names the commitment it was asked about and not the
one it would have produced**, because the row a person is told beside is the row they tapped, and the
commitment they asked for does not exist. **A refused group move SHALL name the category instead**,
because a group is what was tapped and a category is the whole of what a group is: naming one of its
commitments would point at a row the person did not touch. Which change it was is not
decoration: a person is told beside the thing they asked for, and the only other way to place the
message is for whatever draws the screen to remember which call it made.

**The seven are counted here and numbered nowhere else.** A requirement that introduces one of them
SHALL name it — a refused move, a refused group move, a refused change — and SHALL NOT identify it by
its position among them, because withdrawing a kind renumbers every position after it and falsifies
both the requirements that state one and the archived change folders that cite one, which are never
edited. A statement about the kinds that came *before* a kind is not a position in this sense: it
names them, all of them go on existing, and nothing withdrawn later can make it untrue.

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
**asking to change a commitment on neither of its lists** and **asking for a change that names what a
commitment already is** each answer nothing and
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
  changed through the screen to the category "Sport", on the name, the rhythm and the day kept from
  it already has
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against changing "Gym"
- **AND** what it keeps is one group, with no category, holding "Gym"

#### Scenario: a commitments screen holds nothing against a category change that asks for no change at all

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and put under the category "Sport" there; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it
  and refused; and "Gym" is changed through the screen to the category "Sport" it is already under,
  on the name, the rhythm and the day kept from it already has
- **THEN** the category change refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym"

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
move. That is a refused **group move**, and it is the only kind of refused change a commitments
screen holds that names something other than a commitment — a group is a category and the commitments
under it, a person tapped the heading, and naming one of the rows would point at a row they did not
touch.

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

**A change is the only act on this screen that writes a category without a move.** The category is
one of the four, picked from the categories the screen offers or typed; a commitment given one is
drawn in that category's group and a category of nothing but blank space takes it off, exactly as
defining one does. What a commitments screen no longer does is put a commitment under a category as
an act of its own, so a change is the whole of how a person refiles without dragging. The other way
a category changes on this screen is a **move**: a commitment dropped into another group is put
under that group's category by the same act, because the place a drop names is inside a group. That
is *A commitments screen moves a commitment among the ones it keeps*, which this change leaves
untouched, and the two do not need keeping in step — a drag says where a row sits and takes the
category of where it landed, and a change says what the commitment is.

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

#### Scenario: a category set through a commitments screen's change is kept at the roster place

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; and "Creatine" is changed through it to
  the category "Supplements", on the name, the rhythm and the day kept from it already has
- **THEN** nothing is refused
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** a commitments screen opened afterwards at that place as of that same day keeps those same
  two groups

#### Scenario: a category taken off through a commitments screen's change draws its commitment among the ones under none

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Creatine" is changed through it to a category of three spaces, on the name,
  the rhythm and the day kept from it already has
- **THEN** nothing is refused
- **AND** what it keeps is one group, with no category, holding "Creatine" and then "Gym"

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
  commitments screen is opened at that roster place as of Monday 31 August 2026; "Magnesium" is
  changed through it to the category "Supplements", on the name, the rhythm and the day kept from it
  already has; and "Magnesium" is then changed through it to no category, on those same three
- **THEN** immediately after the first change what it keeps is two groups, "Supplements" holding
  "Magnesium" and then a group with no category holding "Creatine" and then "Gym"
- **AND** afterwards what it keeps is one group, with no category, holding "Creatine", then "Gym",
  then "Magnesium", in the order the roster has held them throughout

### Requirement: A commitments screen that cannot read its roster lists nothing and changes nothing

A commitments screen whose roster place cannot be read SHALL list nothing in either list and SHALL
say that it is not keeping a roster. It MUST NOT take anything on, and it MUST NOT write over what
is at the place — what is there is left untouched for a person or a later version of the app to
recover. It SHALL offer no category either: the categories it offers are the ones the commitments it
keeps are under, and it keeps none.

Defining a commitment through such a screen SHALL be refused as a roster that could not be written.
Asking it to stop keeping a commitment, to take one up again, to remove one, to move one, or to
change one SHALL do nothing and say nothing, by the rule that already governs a commitment neither
list holds: both its lists are empty, so there is nothing there to stop, nothing there to take up,
nothing there to remove, nothing there to move and nothing there to change.

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
  listing all seven weekdays, kept from 1 January 2026, formed directly, is changed through it to the
  category "Sport", on the name, the rhythm and the day kept from it already has
- **THEN** nothing is refused and the screen holds no refused change
- **AND** it says it is not keeping a roster, and what it keeps is no groups at all
- **AND** the categories it offers are none
- **AND** the content at that roster place is byte-for-byte what it was before the screen was opened

### Requirement: What a commitments screen holds about a refused change lasts until the app is shown again or a change is kept

A commitments screen SHALL go on holding a refused change until one of exactly two things happens,
and SHALL then hold nothing. Nothing else SHALL end it. Time passing in particular SHALL NOT,
because this capability reads no clock.

**The app being shown again** ends it. That is inherited rather than added: being shown reads the
roster place afresh and forms both lists again from what is then there, and what was refused is an
answer about a place that has since been read again. It SHALL end whether or not the roster can then
be read — a screen that is then not keeping a roster says that instead, and says more than a refused
change ever could.

**A change reaching a place** ends it, whichever kind it was and whichever change was refused before
it. Defining a commitment that is taken on, a stop that is kept, a take-up-again that is kept, a
removal that is kept, a move that is kept, **a group move that is kept** and **a change of a
commitment that is kept** all count, and a change that writes nothing but a category is one of the
last of those rather than a kind of its own, because a category is one of the four things a change
is made of. A change of a commitment reaches the record place as well as the roster place, and it
ends what is held once it has been kept — one act, one outcome, however many places it touched. This
is one rule rather than one for each kind because it is the at-most-one rule above read the other
way round: a commitments screen holds the outcome of the last change asked of it, so a change that
is asked for and kept leaves nothing to hold. A person who has just been told a change landed is not
also told that an earlier one did not.

A call that reaches the place with no change to make SHALL NOT end it, by the rule above that such a
call is not a change asked for at all. **A move that drops a commitment where it already is is
exactly such a call** — it is accepted rather than refused, and nothing is kept at the place, so
there is nothing to have answered a notice with — **and so are a group move that leaves a group
where it is drawn, a change that names what a commitment already is, the category it is already
under among the four things it names, and a change asked about a commitment on neither of the
screen's lists**. Nor SHALL putting a stop or a removal up for confirmation, typing a name back, or
cancelling either: none of them reaches the roster place, and nothing has been proved about it
either way.

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
  weekdays, kept from that same day, is defined through it and refused; and "Gym" is changed through
  it to the category "Sport", on the name, the rhythm and the day kept from it already has
- **THEN** the screen holds no refused change
- **AND** what it keeps is one group, "Sport", holding "Gym"

#### Scenario: what a commitments screen holds about a refused change stands when a category change puts a commitment under the category it is already under

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and put under the category "Sport" there; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through
  it and refused; and "Gym" is changed through it to the category "Sport" it is already under, on the
  name, the rhythm and the day kept from it already has
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

### Requirement: A commitments screen puts a commitment under a category, and offers the categories in use

**Reason:** B-042 — the *Category* action on a row is withdrawn, and with it the only caller of
`CommitmentsScreen.put(_:under:)`. The change sheet has set a category since
`add-commitment-editing` (#148), over the same words this screen offers, so the `put` half is a
second way to do one thing rather than the only way to do it. Left in place it would be a shipped,
tested requirement no gesture on the phone can reach, which is the defect this Story exists to
prevent. **The offering half is not removed**: it is re-landed above under its own name, *A
commitments screen offers the categories in use*, with every rule about which categories are
offered, in what order, each once and none from the stopped list — the change sheet is the caller
that keeps it alive.

**Migration:** a category is set and taken off through a **change**, which carries the category as
one of the four things it is made of. *A commitments screen changes a commitment on either of its
lists* is modified above to say so and gains the two scenarios this requirement's `put` scenarios
were the only ones asserting: a category set through a change is kept at the roster place, and a
category of nothing but blank space takes one off. Four of this requirement's nine scenarios go with
the method and their tests are deleted — *a commitment is put under a category through a commitments
screen and kept at the roster place*, *a category taken off through a commitments screen draws its
commitment among the ones under none*, *a commitments screen asked to put a commitment it does not
keep under a category does nothing and says nothing* and *a category change a commitments screen
could not keep leaves both its lists as they were* — because each names an act that no longer
exists; the first two are re-landed on the change requirement under names that say which act made
them, and the third and fourth are answered there already by *a commitments screen asked to change a
commitment on neither of its lists does nothing and says nothing* and *a change a commitments screen
could not keep leaves both places as they were*. Nothing on disk is touched: a roster written before
this change reads back with its categories exactly as it did, because a category is the roster's and
neither the file format nor `Roster.put(_:under:)` moves.
