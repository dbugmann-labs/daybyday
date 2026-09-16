## MODIFIED Requirements

### Requirement: A commitments screen says what a commitment it is asked to change is made of

A commitments screen SHALL say, for a commitment on either of its lists, the things a change is asked
with: the name it has, the rhythm it runs on, the day it is kept from, the category it is under and
the range or the target its kind carries. For a commitment on neither list it SHALL say nothing at
all. The rhythm SHALL be the one of the four that names that commitment's schedule, carrying the
number that schedule carries; an interval rhythm carries no start date, so an interval schedule's own
start date SHALL NOT be part of what is said.

It SHALL say whether anything beyond the name and the category can be changed at all: the rhythm, the
day it is kept from and the range or the target alike can be changed for a commitment its roster is
keeping, and none of them can for one it has stopped keeping. It SHALL say the kind that commitment's
days take, with the range or the target that kind carries — the number kind's range, or that it
carries none; the total kind's target; nothing beside a tick or a note. Which of the four kinds it is
SHALL be shown and SHALL never be asked about. A control for each of the things above SHALL be drawn,
and the ones that cannot be changed SHALL NOT let a thumb in.

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

#### Scenario: a commitments screen says a stopped commitment's range and target cannot be changed either

- **WHEN** a commitment named "Mood" of the number kind with a range of 1 to 10, one named "Protein"
  of the total kind with a target of 120, and one named "Weight" of the number kind with a range of
  40 to 150, all on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on
  at a roster place; "Mood" and "Protein" are stopped there as of Sunday 30 August 2026; and a
  commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it says "Mood" is made of says its range cannot be changed, and what it says
  "Protein" is made of says its target cannot be changed
- **AND** what it says "Weight" is made of says its range can be changed

#### Scenario: a commitments screen says nothing about a commitment on neither of its lists

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is removed there as of
  Sunday 30 August 2026; and a commitments screen is opened at that roster place as of Monday
  31 August 2026
- **THEN** it says nothing about what "Gym" is made of
- **AND** it says nothing about what a commitment named "Run" alike in every other way, which its
  roster has never held, is made of

#### Scenario: a commitments screen says the kind a commitment it keeps takes, with what that kind carries

- **WHEN** a commitment named "Gym" of the tick kind, one named "Mood" of the number kind with a
  range of 1 to 10, one named "Journal" of the note kind, and one named "Protein" of the total kind
  with a target of 120, all on a schedule listing all seven weekdays and all kept from 1 January
  2026, are taken on at a roster place; and a commitments screen is opened at that roster place as of
  Monday 31 August 2026
- **THEN** what it says each is made of names the tick kind, the number kind carrying a range whose
  lowest is 1 and whose highest is 10, the note kind, and the total kind carrying a target of 120, in
  that order

#### Scenario: a commitments screen says a number commitment carrying no range takes the number kind and no range

- **WHEN** a commitment named "Weight" of the number kind carrying no range, and one named "Gym" of
  the tick kind, both on a schedule listing all seven weekdays and kept from 1 January 2026, are
  taken on at a roster place; "Weight" is stopped there as of Sunday 30 August 2026; and a
  commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it says "Weight" is made of names the number kind carrying no range
- **AND** it says that "Weight"'s rhythm and the day it is kept from cannot be changed

#### Scenario: a commitments screen says what a commitment it has stopped is made of

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and stopped there as of Sunday 30 August 2026; and a commitments
  screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it says "Creatine" is made of names "Creatine", a weekday-set rhythm of all seven
  weekdays, 1 January 2026 as the day it is kept from, and the category "Supplements"
- **AND** it says that "Creatine"'s rhythm and the day it is kept from cannot be changed

### Requirement: A commitments screen works out which act a change on either of its lists needs

A commitments screen SHALL change a commitment on either of its lists from five things and no others
— a name, a rhythm, the day it is kept from, the category, which may be none, and the range or the
target its kind has room for — and SHALL work out from them which of two acts the change needs. On a
different name, a different day kept from, or both, on the rhythm, range and target it already has,
it SHALL carry every record of the commitment over at the record place and then change it for the
changed one at the roster place, in the place the roster holds it; every past day afterwards answers
about the changed commitment as it did about the one it replaced. On a different rhythm, a different
range or a different target it SHALL supersede: the commitment is kept until the day before the day
the screen was handed and held removed, and the one the five name, kept from the day the screen was
handed, takes its place; no record SHALL move and no past day SHALL change its answer. On both in
one save it SHALL carry over first and supersede second, so the superseded commitment carries the new
name, the corrected day it was kept from and the range or target it already had, and the commitment
taken on the new name, the new rhythm, the new range or target and the day the screen was handed.

On an interval rhythm the day kept from is also the rhythm's start date, so a change naming a
different day SHALL form the changed commitment's schedule from that day and the days it was due on
before are not the days it is due on after; on the other three, dueness does not depend on that day,
so moving it earlier only widens the window and every day already recorded on SHALL stay due. The
record place SHALL be written before the roster place, and where nothing is carried over nothing
SHALL be written at the record place at all.

Which of the four kinds its days take is not one of the five and SHALL NOT change: the changed
commitment SHALL be of the kind the one it replaces is of. The range a number kind carries and the
target a total kind carries SHALL be what the change names, a range named where the commitment
carried none and none named where it carried one alike; a commitment carried over SHALL carry the
range or target it already has, and only the commitment taken on in a supersession SHALL carry the
new one. A range or a target named for a kind that has no room for it SHALL be ignored. A change
SHALL write the category it is given, and a category of nothing but blank space SHALL take it off. A
commitment its roster has stopped keeping SHALL be changed in name and category only, and SHALL stay
stopped on the day it was kept until. Where the five things name the commitment that is already
there, and the category it is already under, the screen SHALL change nothing, SHALL write nothing at
either place and SHALL refuse nothing.

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
  commitment on Tuesday and Thursday kept from Monday 31 August 2026 and then the one on Monday,
  Wednesday and Saturday kept from 1 January 2026, and about Monday 31 August 2026 with the one on
  Tuesday and Thursday kept from that day
- **AND** what it has stopped is nothing

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
  "Gym 🏋️" on Tuesday and Thursday, kept from 31 August 2026, and then "Gym 🏋️" on Monday,
  Wednesday and Saturday, kept from 1 January 2026
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

#### Scenario: the day an interval commitment is kept from is moved earlier and every day it is due on moves with it

- **WHEN** a commitment named "Contact lenses" on an interval rhythm of 14 days, kept from Wednesday
  1 July 2026, is taken on at a roster place; a commitments screen is opened at that roster place as
  of Monday 31 August 2026; and "Contact lenses" is changed through it to the day kept from Monday
  29 June 2026, on the name and the rhythm it already has, under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place holds is due on Monday 29 June
  2026 and on Monday 13 July 2026
- **AND** it is not due on Wednesday 1 July 2026

#### Scenario: a change that names what is already there changes nothing and refuses nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, under the category "Sport", is taken on at a roster place; a tick for it on Monday
  3 August 2026 is kept at a record place; a commitments screen is opened at that roster place and
  that record place as of Monday 31 August 2026; and "Gym" is changed through it to exactly the name,
  rhythm, day kept from and category it already has
- **THEN** nothing is refused
- **AND** what it keeps is one group, "Sport", holding one entry named "Gym"
- **AND** the content at both places is byte-for-byte what it was immediately after the screen was
  opened
- **AND** a screen alike in every way keeping "Mood" of the number kind with a range of 1 to 10,
  asked to change it to exactly the range it already carries beside everything else it already has,
  refuses nothing and leaves the content at both places byte-for-byte as it was

#### Scenario: a stopped commitment renamed through a commitments screen stays stopped, on the day it was kept until

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped there as of
  Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️", on the rhythm and the day
  kept from it already has, under no category
- **THEN** nothing is refused
- **AND** what it has stopped is one entry, named "Gym 🏋️"
- **AND** what it keeps is one entry, named "Journaling"
- **AND** a roster store opened afterwards at that place answers with "Gym 🏋️" and then "Journaling"
  when asked what it had not stopped keeping on Sunday 30 August 2026, and with "Journaling" alone on
  Monday 31 August 2026

#### Scenario: a commitment of the number kind changed through a commitments screen keeps the kind its days take

- **WHEN** a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026, is taken on at a roster place; a commitments
  screen is opened at that roster place as of Monday 31 August 2026; and "Weight" is changed through
  it to the name "Bodyweight", on the rhythm, the day kept from and the range it already has, under
  no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place holds is of the number kind
  with a range of 40 to 150
- **AND** what it keeps is one entry, named "Bodyweight"

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

#### Scenario: a commitment of the total kind whose rhythm is changed through a commitments screen keeps its kind and its target

- **WHEN** a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, is taken on at a roster place; a
  commitments screen is opened at that roster place and at a record place where nothing has been
  kept as of Monday 31 August 2026; and "Protein" is changed through it to a weekday-set rhythm of
  Tuesday and Thursday, on the name, the day kept from and the target it already has, under no
  category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place is keeping is of the total
  kind with a target of 120

#### Scenario: the day a commitment is kept from moved earlier through a commitments screen carries every record over, each day still due

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 August 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of
  Monday 31 August 2026; and "Gym" is changed through it to the day kept from 1 June 2026, on the
  name and the rhythm it already has, under no category
- **THEN** nothing is refused
- **AND** a store opened afterwards at that record place answers that the commitment kept from 1
  June 2026 was kept on Monday 3 August 2026
- **AND** it answers that the commitment kept from 1 August 2026 was not kept on that day

#### Scenario: a stopped commitment put under a category through a commitments screen's change stays stopped under it

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is stopped there
  as of Sunday 30 August 2026; a commitments screen is opened at that roster place and at a record
  place where nothing has been kept as of Monday 31 August 2026; and "Creatine" is changed through
  it to the category "Supplements", on the name, the rhythm and the day kept from it already has
- **THEN** nothing is refused
- **AND** what it has stopped is one entry, named "Creatine", and what it says "Creatine" is made of
  says the category "Supplements"
- **AND** after "Creatine" is taken up again through the screen, what it keeps is two groups,
  "Supplements" holding "Creatine" and then a group with no category holding "Gym"

#### Scenario: a name, an earlier day kept from and a rhythm changed in one save put the corrected day on the superseded commitment

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 August 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  and at a record place where nothing has been kept as of Monday 31 August 2026; and "Gym" is
  changed through it to the name "Gym 🏋️", on a weekday-set rhythm of Tuesday and Thursday, kept
  from 1 June 2026, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with
  "Gym 🏋️" on Tuesday and Thursday, kept from 31 August 2026, and then "Gym 🏋️" on Monday,
  Wednesday and Saturday, kept from 1 June 2026
- **AND** what the screen keeps is one entry, named "Gym 🏋️", saying "Tue, Thu"

#### Scenario: a change that carries nothing over writes nothing at the record place

- **WHEN** a commitment named "Creatine" on a schedule listing all seven weekdays, kept from 1
  January 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of
  Monday 31 August 2026; the content at that record place is read; and "Creatine" is changed through
  it to the category "Supplements", on the name, the rhythm and the day kept from it already has
- **THEN** nothing is refused
- **AND** the content at that record place is byte-for-byte what was read before the change

#### Scenario: a change of rhythm through a commitments screen puts the new commitment under the category it was given

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, under the category "Sport", is taken on at a roster place; a commitments screen is
  opened at that roster place and at a record place where nothing has been kept as of Monday 31
  August 2026; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and Thursday,
  under the category "Morning"
- **THEN** nothing is refused
- **AND** what it keeps is one group, "Morning", holding one entry named "Gym", saying "Tue, Thu"

#### Scenario: a name and a rhythm changed in one save through a commitments screen put the new commitment under the category given

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, under the category "Sport", is taken on at a roster place; a commitments screen is
  opened at that roster place and at a record place where nothing has been kept as of Monday 31
  August 2026; and "Gym" is changed through it to the name "Gym 🏋️" on a weekday-set rhythm of
  Tuesday and Thursday, under the category "Morning"
- **THEN** nothing is refused
- **AND** what it keeps is one group, "Morning", holding one entry named "Gym 🏋️", saying "Tue,
  Thu"

#### Scenario: a commitment whose range is changed through a commitments screen is kept until yesterday and the new one is taken on today

- **WHEN** a commitment named "Mood" of the number kind with a range of 1 to 10, on a schedule
  listing all seven weekdays, kept from 1 January 2026, is taken on at a roster place; a commitments
  screen is opened at that roster place and at a record place where nothing has been kept as of
  Monday 31 August 2026; and "Mood" is changed through it to a range of 1 to 5, on the name, the
  rhythm and the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** what it keeps is one entry, named "Mood"
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with the
  commitment ranging 1 to 5 kept from Monday 31 August 2026 and then the one ranging 1 to 10 kept
  from 1 January 2026, and about Monday 31 August 2026 with the one ranging 1 to 5 alone
- **AND** what it has stopped is nothing

#### Scenario: a target changed through a commitments screen supersedes and leaves every record already made standing

- **WHEN** a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  all seven weekdays, kept from 1 January 2026, is taken on at a roster place; additions summing to
  120 for it on Monday 3 August 2026 are kept at a record place; a commitments screen is opened at
  that roster place and that record place as of Monday 31 August 2026; the content at that record
  place is read; and "Protein" is changed through it to a target of 100, on the name, the rhythm and
  the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place is keeping is of the total
  kind with a target of 100
- **AND** a store opened afterwards at that record place answers 120 added for the commitment with a
  target of 120 on Monday 3 August 2026, and nothing added for the one with a target of 100
- **AND** the content at that record place is byte-for-byte what was read before the change

#### Scenario: a range added to a number commitment carrying none, and one taken off, each supersede

- **WHEN** a commitment named "Weight" of the number kind carrying no range and one named "Mood" of
  the number kind with a range of 1 to 10, both on a schedule listing all seven weekdays and kept
  from 1 January 2026, are taken on at a roster place; a commitments screen is opened at that roster
  place and at a record place where nothing has been kept as of Monday 31 August 2026; "Weight" is
  changed through it to a range of 40 to 150 and "Mood" to no range at all, each on the name, rhythm
  and day kept from it already has, under no category
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place answers about Monday 31 August 2026 with
  "Weight" ranging 40 to 150 and "Mood" carrying no range, both kept from that day
- **AND** it answers about Sunday 30 August 2026 with "Weight" carrying no range and "Mood" ranging
  1 to 10, both kept from 1 January 2026, among them

#### Scenario: a name and a range changed in one save put the new name on the superseded commitment and the new range on the one taken on

- **WHEN** a commitment named "Mood" of the number kind with a range of 1 to 10, on a schedule
  listing all seven weekdays, kept from 1 January 2026, is taken on at a roster place; a number of 7
  for it on Monday 3 August 2026 is kept at a record place; a commitments screen is opened at that
  roster place and that record place as of Monday 31 August 2026; and "Mood" is changed through it to
  the name "Mood 🙂" with a range of 1 to 5, on the rhythm and the day kept from it already has,
  under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with
  "Mood 🙂" ranging 1 to 5, kept from 31 August 2026, and then "Mood 🙂" ranging 1 to 10, kept from
  1 January 2026
- **AND** a store opened afterwards at that record place answers 7 for "Mood 🙂" ranging 1 to 10 on
  Monday 3 August 2026, and nothing for "Mood" ranging 1 to 10

### Requirement: A commitments screen refuses a change it cannot make

A commitments screen SHALL refuse a change in the words it already uses: a name that says nothing, a
weekday set with no days in it, a rhythm number the calendar will not take, a commitment the roster
already holds, and a place that could not be written. A change whose result the roster already holds
SHALL be refused, kept, stopped or removed alike. A place that could not be written SHALL cover the
record place as well as the roster place, and the two SHALL be told the same way. A change naming a
range that is not a range, or a target that is not a target, SHALL be refused as that, on the grounds
*A commitments screen refuses to define a commitment whose range is not a range, or whose target is
not a target* gives.

Two refusals are this change's own, and each SHALL be told apart from the other seven and from each
other. A change asking for a different rhythm, a different day kept from, a different range or a
different target on a commitment its roster has stopped keeping SHALL be refused as **a change a
stopped commitment does not take**. A change SHALL be refused as **a day already recorded on that
the change would leave not due** where any day the commitment has a record on is a day the changed
commitment is not due on, and no record
SHALL be carried over to a day it could not have been made on; moving the day an interval commitment
is kept from earlier by a whole number of intervals leaves every day already recorded on due and
SHALL NOT be refused.

A commitments screen asked to change a commitment on neither of its lists, one its roster has
removed included, SHALL do nothing and SHALL say nothing. Nothing SHALL be kept at either place by a
refused change, and neither of the screen's lists SHALL move.

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

#### Scenario: a change a commitments screen could not carry over at the record place is refused as a place that could not be written

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a record
  place; a commitments screen is opened at that roster place and that record place as of Monday 31
  August 2026; what is at that record place is then made impossible to write; and "Gym" is changed
  through it to the name "Gym 🏋️", under no category
- **THEN** it is refused as a place that could not be written, told the same way as a roster place
  that could not be written
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a change a commitments screen could not carry over at the record place leaves the roster place as it was

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a record
  place in a directory of its own; a commitments screen is opened at that roster place and that
  record place as of Monday 31 August 2026; the record place's directory is then made impossible to
  write, while the roster place's directory stays writable; and "Gym" is changed through it to the
  name "Gym 🏋️", under no category
- **THEN** the content at that roster place is byte-for-byte what it was immediately after the
  screen was opened

#### Scenario: a change refused at the roster place after its records were carried over leaves the record place as it was

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of
  Monday 31 August 2026; the content at that record place is read; what is at that roster place is
  then made impossible to write; and "Gym" is changed through it to the name "Gym 🏋️", under no
  category
- **THEN** it is refused as a place that could not be written
- **AND** the content at that record place is byte-for-byte what was read before the change

#### Scenario: a name and a rhythm changed in one save and refused at the roster place leave the record place as it was

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of
  Monday 31 August 2026; the content at that record place is read; what is at that roster place is
  then made impossible to write; and "Gym" is changed through it to the name "Gym 🏋️" on a
  weekday-set rhythm of Tuesday and Thursday, under no category
- **THEN** it is refused as a place that could not be written
- **AND** the content at that record place is byte-for-byte what was read before the change

#### Scenario: a change of rhythm whose result the roster already holds is refused as a commitment already kept

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and one named "Gym" on a schedule listing Tuesday and Thursday, kept from Monday
  31 August 2026, are taken on at a roster place; a commitments screen is opened at that roster
  place and at a record place where nothing has been kept as of Monday 31 August 2026; and the first
  "Gym" is changed through it to a weekday-set rhythm of Tuesday and Thursday, on the name and the
  day kept from it already has, under no category
- **THEN** it is refused as a commitment already kept
- **AND** what it keeps is two entries, both named "Gym", saying "Mon, Wed, Sat" and then "Tue, Thu"

#### Scenario: a name and a rhythm changed in one save whose result the roster already holds are refused as a commitment already kept

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing Monday,
  Wednesday and Saturday and kept from 1 January 2026, are taken on at a roster place; a commitments
  screen is opened at that roster place and at a record place where nothing has been kept as of
  Monday 31 August 2026; and "Gym" is changed through it to the name "Run" on a weekday-set rhythm
  of Tuesday and Thursday, under no category
- **THEN** it is refused as a commitment already kept
- **AND** what it keeps is two entries, named "Gym" and then "Run", both saying "Mon, Wed, Sat"

#### Scenario: a name, a later day kept from and a rhythm changed in one save past a day recorded on is refused

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 June 2026,
  is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a record place; a
  commitments screen is opened at that roster place and that record place as of Monday 31 August
  2026; and "Gym" is changed through it to the name "Gym 🏋️", on a weekday-set rhythm of Tuesday
  and Thursday, kept from 1 September 2026, under no category
- **THEN** it is refused as a day already recorded on that the change would leave not due
- **AND** what the screen keeps is one entry named "Gym", and the content at both places is
  byte-for-byte what it was immediately after the screen was opened

#### Scenario: a change of rhythm a commitments screen could not keep leaves both its lists as they were

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  and at a record place where nothing has been kept as of Monday 31 August 2026; what is at that
  roster place is then made impossible to write; and "Gym" is changed through it to a weekday-set
  rhythm of Tuesday and Thursday, under no category
- **THEN** it is refused as a place that could not be written
- **AND** what it keeps is one entry, named "Gym", saying "Mon, Wed, Sat", and what it has stopped
  is nothing
- **AND** the screen holds that refusal, against changing "Gym"

#### Scenario: a change refuses a range that is not a range and a target that is not a target

- **WHEN** a commitment named "Mood" of the number kind with a range of 1 to 10 and one named
  "Protein" of the total kind with a target of 120, both on a schedule listing all seven weekdays and
  kept from 1 January 2026, are taken on at a roster place; a commitments screen is opened at that
  roster place and at a record place where nothing has been kept as of Monday 31 August 2026; "Mood"
  is changed through it to a lowest of "10" and a highest of "1"; and "Protein" is changed through it
  to a target of "0", each on the name, rhythm and day kept from it already has, under no category
- **THEN** the first is refused as a range that is not a range and the second as a target that is not
  a target, each told apart from the other and from a commitment already kept
- **AND** what it keeps is two entries, named "Mood" and then "Protein", and the content at that
  roster place is byte-for-byte what it was immediately after the screen was opened
- **AND** a change of "Mood" to a lowest of "40" and a highest left blank is refused as a range that
  is not a range too

#### Scenario: changing the range or the target of a stopped commitment is refused

- **WHEN** a commitment named "Mood" of the number kind with a range of 1 to 10 and one named
  "Protein" of the total kind with a target of 120, both on a schedule listing all seven weekdays and
  kept from 1 January 2026, are taken on at a roster place; both are stopped there as of Sunday
  30 August 2026; a commitments screen is opened at that roster place and at a record place where
  nothing has been kept as of Monday 31 August 2026; and "Mood" is changed through it to a range of
  1 to 5, on the name, rhythm and day kept from it already has, under no category
- **THEN** it is refused as a change a stopped commitment does not take, told apart from a range that
  is not a range and from a place that could not be written
- **AND** a change of "Protein" to a target of 100, alike in every other way, is refused the same way
- **AND** what it has stopped is two entries, named "Mood" and then "Protein"

#### Scenario: a change of range whose result the roster already holds is refused as a commitment already kept

- **WHEN** a commitment named "Mood" of the number kind with a range of 1 to 10, kept from 1 January
  2026, and one named "Mood" of the number kind with a range of 1 to 5, kept from Monday
  31 August 2026, both on a schedule listing all seven weekdays, are taken on at a roster place; a
  commitments screen is opened at that roster place and at a record place where nothing has been kept
  as of Monday 31 August 2026; and the first "Mood" is changed through it to a range of 1 to 5, on
  the name, rhythm and day kept from it already has, under no category
- **THEN** it is refused as a commitment already kept
- **AND** what it keeps is two entries, both named "Mood"

## ADDED Requirements

### Requirement: A commitments screen says whether a refusal about a rhythm, a day kept from, a range or a target is about one of them or the whole change

A day already recorded on that a change would leave not due, and a change a stopped commitment does
not take, SHALL be about the field of whichever one of the four things a change is asked with beyond
its name and its category — the rhythm, the day kept from, the range and the target — differs from
what the commitment is made of: the rhythm field, the day-kept-from field, the range field or the
target field. Where more than one of the four differs, each SHALL be about the whole change and no
field. What the commitment is made of, and not what any earlier ask carried, SHALL decide which of
the four differ.

#### Scenario: a day recorded on that a change would leave not due is about the day-kept-from field

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 June 2026,
  is taken on at a roster place; ticks for it on Monday 3 August 2026 and Wednesday 5 August 2026
  are kept at a record place; a commitments screen is opened at that roster place and that record
  place as of Monday 31 August 2026; and "Gym" is changed through it to the day kept from Tuesday
  4 August 2026, on the name and the rhythm it already has, under no category
- **THEN** it is refused as a day already recorded on that the change would leave not due, about the
  day-kept-from field of its sheet

#### Scenario: a change a stopped commitment does not take is about the rhythm field where only the rhythm differs

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place and stopped there as of Sunday 30 August 2026; a
  commitments screen is opened at that roster place and at a record place where nothing has been
  kept as of Monday 31 August 2026; and "Gym" is changed through it to a weekday-set rhythm of
  Tuesday and Thursday, on the name and the day kept from it already has, under no category
- **THEN** it is refused as a change a stopped commitment does not take, about the rhythm field of
  its sheet

#### Scenario: a change a stopped commitment does not take is about the day-kept-from field where only that day differs

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place and stopped there as of Sunday 30 August 2026; a
  commitments screen is opened at that roster place and at a record place where nothing has been
  kept as of Monday 31 August 2026; and "Gym" is changed through it to the day kept from Monday
  5 January 2026, on the name and the rhythm it already has, under no category
- **THEN** it is refused as a change a stopped commitment does not take, about the day-kept-from
  field of its sheet

#### Scenario: a refusal is about the whole change where both the rhythm and the day kept from differ

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place and stopped there as of Sunday 30 August 2026; a
  commitments screen is opened at that roster place and at a record place where nothing has been
  kept as of Monday 31 August 2026; and "Gym" is changed through it to a weekday-set rhythm of
  Tuesday and Thursday, kept from Monday 5 January 2026, on the name it already has, under no
  category
- **THEN** it is refused as a change a stopped commitment does not take, about the whole change and
  about no field of its sheet

#### Scenario: a change a stopped commitment does not take is about the range field where only the range differs

- **WHEN** a commitment named "Mood" of the number kind with a range of 1 to 10 and one named
  "Protein" of the total kind with a target of 120, both on a schedule listing all seven weekdays and
  kept from 1 January 2026, are taken on at a roster place and stopped there as of Sunday
  30 August 2026; a commitments screen is opened at that roster place and at a record place where
  nothing has been kept as of Monday 31 August 2026; and "Mood" is changed through it to a range of
  1 to 5, on the name, rhythm and day kept from it already has, under no category
- **THEN** it is refused as a change a stopped commitment does not take, about the range field of its
  sheet
- **AND** a change of "Protein" to a target of 100, alike in every other way, is about the target
  field of its sheet

#### Scenario: a refusal is about the whole change where a range and another of the four differ

- **WHEN** a commitment named "Mood" of the number kind with a range of 1 to 10, on a schedule
  listing all seven weekdays, kept from 1 January 2026, is taken on at a roster place and stopped
  there as of Sunday 30 August 2026; a commitments screen is opened at that roster place and at a
  record place where nothing has been kept as of Monday 31 August 2026; and "Mood" is changed through
  it to a range of 1 to 5 on a weekday-set rhythm of Tuesday and Thursday, on the name and the day
  kept from it already has, under no category
- **THEN** it is refused as a change a stopped commitment does not take, about the whole change and
  about no field of its sheet
- **AND** a change of "Mood" to a range of 1 to 5 kept from Monday 5 January 2026, on the name and
  rhythm it already has, is about the whole change and no field too

## REMOVED Requirements

### Requirement: A commitments screen says whether a refusal about a rhythm or a day kept from is about one of them or the whole change

**Reason**: the same rule now decides among four things and not two — a stopped commitment takes
no change to its range or its target either — so the title no longer says what the requirement
holds. Added back above under a title that does.
**Migration**: every scenario is carried verbatim to the requirement added above, with two added
beside them; no test moves.
