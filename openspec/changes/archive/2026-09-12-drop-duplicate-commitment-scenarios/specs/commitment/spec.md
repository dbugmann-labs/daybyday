## REMOVED Requirements

### Requirement: A commitment's kind is a tick, a number, a note or a total

**Reason**: Added back below as *A commitment's kind is exactly one of a tick, a number, a note or a
total*, without a scenario another under it already asserts.
**Migration**: Dropped with its test: `a commitment reads back the kind it was given`. The rest is
carried verbatim.

### Requirement: A roster stops keeping a commitment, on the day it was kept until

**Reason**: Added back below as *A roster stops keeping a commitment it holds, on the day it was
kept until*, without a scenario another under it already asserts.
**Migration**: Dropped with its test: `stopping a commitment a roster keeps says so and takes it out
of the commitments read back`. The rest is carried verbatim.

### Requirement: A commitments screen lists the commitments its roster keeps, in the order they were taken on

**Reason**: Added back below as *A commitments screen lists the commitments its roster keeps, in the
order the roster answers with*, without a scenario another under it already asserts.
**Migration**: Dropped with its test: `two commitments alike in name and not in rhythm are two
entries a person cannot tell apart`. The rest is carried verbatim.

### Requirement: A commitments screen takes a stopped commitment up again in one tap

**Reason**: Added back below as *A commitments screen takes a commitment it has stopped up again in
one tap*, without a scenario another under it already asserts.
**Migration**: Dropped with its test: `a commitment taken up again through a commitments screen is
in the place it was taken on in`. The rest is carried verbatim.

### Requirement: A commitments screen holds the change it refused and why, one at a time

**Reason**: Added back below as *A commitments screen holds the change it refused and why it was
refused, one at a time*, without a scenario another under it already asserts.
**Migration**: Dropped with their tests: `a commitments screen holds a refused stop against the
commitment it was asked to stop`, `a commitments screen that has been asked for no change holds no
refused change`. The rest is carried verbatim.

### Requirement: A commitments screen moves a commitment among the ones it keeps

**Reason**: Added back below as *A commitments screen moves a commitment among the ones it is
keeping*, without a scenario another under it already asserts.
**Migration**: Dropped with its test: `a commitment dropped among another group's entries is put
under that group's category`. The rest is carried verbatim.

### Requirement: A commitments screen refuses a range that is not a range, and a target that is not a target

**Reason**: Added back below as *A commitments screen refuses to define a commitment whose range is
not a range, or whose target is not a target*, without a scenario another under it already asserts.
**Migration**: Dropped with its test: `a commitments screen refuses a range whose lowest is above
its highest`. The rest is carried verbatim.

## ADDED Requirements

### Requirement: A commitment's kind is exactly one of a tick, a number, a note or a total

A commitment's kind SHALL be exactly one of four: a tick, a number, a note or a total. There SHALL
be no fifth and no way to hold none.

A tick and a note SHALL carry nothing, a number MAY carry a range, and a total MUST carry a target.
A range SHALL belong to the number kind and a target to the total kind, and the system MUST NOT
offer any way of attaching either to a kind it does not belong to: a commitment of a kind with no
room for one SHALL be one that cannot be formed at all, rather than one refused when it is tried.

A commitment SHALL read its kind back, along with whatever that kind carries. A commitment formed
without a kind named SHALL be of the plain kind, a tick, and naming the tick explicitly SHALL give
the same commitment as naming nothing. The kind SHALL NOT enter into whether a commitment is due.

#### Scenario: a commitment of each of the four kinds is formed and reads its kind back

- **WHEN** four commitments are formed, all named "Gym", all on a schedule listing Monday,
  Wednesday and Saturday and all kept from 1 January 2026 — one of the tick kind, one of the number
  kind carrying no range, one of the note kind, and one of the total kind with a target of 120
- **THEN** each of the four reads its own kind back
- **AND** the total reads back a target of 120

#### Scenario: a commitment formed without a kind is of the plain kind

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is formed without a kind being named
- **THEN** its kind reads back as the tick kind
- **AND** it is the same commitment as one formed alike in every way with the tick kind named

#### Scenario: a commitment's kind does not change whether it is due

- **WHEN** two commitments named "Gym" are formed on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, one of the tick kind and one of the number kind carrying a
  range of 40 to 150
- **THEN** both are due on Monday 31 August 2026
- **AND** neither is due on Tuesday 1 September 2026

### Requirement: A roster stops keeping a commitment it holds, on the day it was kept until

A roster SHALL stop keeping a commitment it holds, on being given that commitment and the calendar
date it was kept until, which is the last day it was kept. Stopping SHALL take the commitment out of
the commitments the roster reads back, SHALL record that day against it, and SHALL report that the
roster stopped keeping it, leaving everything else exactly as it was, in the order it was in.

The roster SHALL refuse to stop keeping a commitment in exactly three cases, and SHALL report each:
one it does not hold at all; one it has already stopped keeping; and one it has removed, a removal
being a last state there is nothing a stop could add to. In the second and the third the kept-until
day SHALL stand as first given, and in all three the roster SHALL be left exactly as it was, for as
long as the roster has stopped keeping that commitment or has removed it. Taking a commitment up
again SHALL clear that day and SHALL be the only thing that does, as *A roster refuses a commitment
it already holds* says, and a commitment taken up again SHALL be one the roster can stop keeping
again, on whatever day it was kept until the second time.

The roster SHALL refuse on no date: any calendar date the system supports SHALL be accepted as a day
a commitment was kept until, including the first, the last, and one earlier than the day that
commitment is kept from. The roster SHALL NOT ask what day it is, MUST NOT refuse a day for being in
the future, and MUST NOT accept one for being in the past.

Stopping SHALL change nothing about the commitment itself and nothing recorded against it: a stopped
commitment SHALL answer whether it is due exactly as before, and every tick already recorded SHALL
stand. Stopping SHALL leave every other roster untouched, and two rosters differing only in the day
one commitment was kept until SHALL be different rosters.

#### Scenario: stopping one commitment leaves the others where they were

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January
  2026, is asked to stop keeping "Gym" as of 31 January 2026
- **THEN** the roster reads back two commitments in the order "Water plants", then "Journaling"

#### Scenario: stopping a commitment a roster does not hold says it was not stopped and leaves the roster as it was

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to stop keeping a commitment named "Run" alike in
  every other way, as of 31 January 2026
- **THEN** the roster reports that it did not stop keeping the commitment
- **AND** the roster is the same roster as one that was never asked

#### Scenario: stopping a commitment already stopped says it was not stopped and keeps the day first given

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, has stopped keeping it as of 31 January 2026, and is asked to
  stop keeping it again as of 28 February 2026
- **THEN** the roster reports that it did not stop keeping the commitment
- **AND** the roster is the same roster as one asked only the first time

#### Scenario: a commitment taken up again can be stopped again, on a new day

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, stops keeping it as of 31 January 2026, is given that same
  commitment again, and is then asked to stop keeping it as of 28 February 2026
- **THEN** the roster reports that it stopped keeping the commitment
- **AND** it answers with that commitment on 28 February 2026 and with nothing on 1 March 2026

#### Scenario: a commitment kept until a day before the day it is kept from is accepted

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 March 2026, is asked to stop keeping it as of 1 January 2026
- **THEN** the roster reports that it stopped keeping the commitment
- **AND** the roster reads back no commitments

#### Scenario: two rosters differing only in the day one commitment was kept until are different rosters

- **WHEN** two rosters each holding a commitment named "Gym" on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, stop keeping it — one as of 31 January 2026 and one as of
  28 February 2026
- **THEN** the two are different rosters
- **AND** a third roster stopping that commitment as of 31 January 2026 is the same roster as the
  first

#### Scenario: stopping a commitment on a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is copied, and the copy stops keeping that commitment as of
  31 January 2026
- **THEN** the copy reads back no commitments
- **AND** the roster it was copied from still reads back that one commitment and is not the same
  roster as the copy

#### Scenario: stopping a commitment a roster has removed says it was not stopped and keeps the day it was kept until

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, removes it as of 31 January 2026, and is then asked to stop
  keeping it as of 28 February 2026
- **THEN** the roster reports that it did not stop keeping the commitment
- **AND** the roster is the same roster as one that removed the commitment as of 31 January 2026 and
  was never asked to stop keeping it

### Requirement: A commitments screen lists the commitments its roster keeps, in the order the roster answers with

A commitments screen SHALL hold a roster, read at the place it keeps its roster, and SHALL list the
commitments that roster is keeping, in groups, in the order the roster answers with; one the roster
has stopped keeping or removed MUST NOT be in that list. The groups, their order and their contents
SHALL be the roster's answer, read off it and drawn: a group sits where its first commitment sits,
entries under no category come last in a group with no category, and within a group entries are in the
roster's own order. Across its groups the list SHALL be the commitments the roster is keeping and
nothing else, each exactly once: a commitment given a category is drawn in that category's group while
staying where the roster holds it, and taking the category off draws it back among those under none.

An entry SHALL be a commitment's name and the rhythm it runs on in words and nothing else, in the
words the `schedule` capability says for that commitment's schedule, and SHALL NOT say the kind its
days take, the day it is kept from, or its category. Two commitments alike in name and unlike in
rhythm SHALL be two entries; two alike in both SHALL be two entries that say the same thing, and SHALL
NOT be refused. Where two are alike in name, the commitment removed SHALL be the one the removal was
asked about and never the one the typing picks out. A commitments screen SHALL ask its roster no date
and MUST NOT take any commitment on, and a roster holding nothing SHALL be listed as nothing at all,
in no groups at all.

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

### Requirement: A commitments screen takes a commitment it has stopped up again in one tap

A commitments screen SHALL take a commitment it has stopped up again, without asking for confirmation
and without asking for a name, a rhythm or a day. It SHALL keep that at the roster place before either
list says so; the commitment SHALL then be in what the screen keeps, in the place it has, and not in
what it has stopped. A commitments screen asked to take up again a commitment its roster has not
stopped SHALL do nothing and SHALL say nothing. One it could not keep at the roster place SHALL be
refused as a roster that could not be written, leaving both lists as they were.

#### Scenario: a commitment taken up again through a commitments screen moves from what it has stopped to what it keeps

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped there as
  of Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Gym" is taken up again through it
- **THEN** what it keeps is two entries, named "Gym" and then "Journaling"
- **AND** what it has stopped is nothing
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had
  not stopped keeping on Tuesday 1 September 2026

#### Scenario: taking a commitment up again through a commitments screen asks for no confirmation

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; "Gym" is stopped there as of Sunday 30 August 2026;
  a commitments screen is opened at that roster place as of Monday 31 August 2026; and "Gym" is
  taken up again through it
- **THEN** nothing is awaiting confirmation at any point
- **AND** what it keeps is one entry, named "Gym", with nothing else asked of the screen

#### Scenario: a commitments screen asked to take up again a commitment it has not stopped does nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and "Gym" is taken up again through it
- **THEN** nothing is refused
- **AND** what it keeps is one entry, named "Gym", and what it has stopped is nothing
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

### Requirement: A commitments screen holds the change it refused and why it was refused, one at a time

Where a change asked of a commitments screen is refused, the screen SHALL hold which change was
asked for and why it was refused, as well as answering the refusal to the caller. The change held
SHALL be one of the seven a person can ask for — defining a commitment, stopping keeping one, taking
a stopped one up again, removing one, moving one, moving a whole group, changing one — and for the
five asked about a commitment already on one of its lists it SHALL name that commitment: the one it
was asked about, not the one the change would have produced. A refused group move SHALL name the
category instead. The seven are counted here and numbered nowhere else: a requirement that
introduces one SHALL name it, and SHALL NOT identify it by its position among them.

Why it was refused SHALL be the same refusal answered to the caller and no more, and a commitments
screen SHALL hold no words a person reads. It SHALL hold at most one refused change at a time, the
change asked for last. A call asking for no change at all SHALL NOT be a refusal, and each SHALL
leave the screen holding no refused change and leave whatever it holds exactly as it was: a stop
asked about a commitment it does not keep; a stop confirmed with nothing awaiting confirmation; a
take-up-again of one it has not stopped; a removal asked about a commitment on neither list; a
removal confirmed with nothing awaiting removal; a removal confirmed while the name typed back does
not match; a move of one it does not keep; a move into a group it draws none of, or to an offset
that group does not have; a group move of a group it draws none of, those under no category among
them, or to an offset its category groups do not have; a change asked about a commitment on neither
list; and a change that names what a commitment already is. A name typed back that does not match is
not a refusal.

#### Scenario: a commitments screen holds a refused definition against defining a commitment

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it
- **THEN** it is refused as a name that says nothing
- **AND** the screen holds that refusal, against defining a commitment

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

### Requirement: A commitments screen moves a commitment among the ones it is keeping

A commitments screen SHALL move a commitment on the list of what it keeps, on being given that
commitment, the group it was dropped in and an offset counted over the entries drawn in that group
as they stand before the move, from 0, before the first of them, to the number drawn in that group,
and SHALL keep the move at the roster place before the list says so. It SHALL ask for no
confirmation and for nothing else. The commitment SHALL be put under the category of the group it
was dropped in, and a row dropped among the entries under no category has its category taken off. It
SHALL come to stand immediately before the entry drawn at that offset in that group, or after the
last entry drawn in it where the offset is the number drawn in it. The end of a group is a place a
drop can reach, and reaching it SHALL file the commitment in that group and not in the one drawn
after it. A group whose first commitment has been moved away SHALL afterwards be drawn where its
next commitment sits.

On the offset an entry is drawn at within its own group and the one just after it, the screen SHALL
change neither the order nor the category, SHALL refuse nothing and SHALL say nothing; those two
carve out nothing anywhere else, and a commitment dropped in any group but the one it is already in
SHALL be filed there at every offset that group has. A screen asked to move a commitment neither
list holds, one it has stopped, one into a group it draws none of — a category no commitment it
keeps is under, no category at all included — or one to an offset that group does not have SHALL do
nothing and SHALL say nothing. A move it could not keep at the roster place SHALL be refused as a
roster that could not be written, SHALL name the commitment it was asked to move, and SHALL leave
both lists as they were and the commitment under the category it was already under.

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

### Requirement: A commitments screen refuses to define a commitment whose range is not a range, or whose target is not a target

A commitments screen SHALL refuse to define a commitment of the number kind whose range is not a
range, and one of the total kind whose target is not a target; nothing SHALL be kept at the roster
place, neither of its lists SHALL change, and each SHALL be held as a refused change against
defining a commitment. A range is not a range when its lowest is above its highest, when either end
is not a number, or when one end holds something and the other is blank, which is its own refusal
and not a range left blank. A target is not a target when it is not a number, when it is not above
zero, or when it is blank. Both ends of a range left blank SHALL NOT be this refusal and SHALL NOT
be a refusal at all: it is a commitment of the number kind carrying no range. A range or a target
left in a field the kind chosen has no room for is not refused, as *A commitments screen defines a
commitment from a name, a rhythm and the day it is kept from* says.

The three ways a range fails SHALL be one refusal, told apart from every other this screen makes but
not from each other, and the three ways a target fails SHALL be one refusal likewise; the two SHALL
be told apart from each other. This screen SHALL refuse exactly what the value refuses and SHALL
invent nothing, and the `commitment` capability's own rules for a range and a target are unchanged
by this requirement. A lowest equal to its highest is a range of exactly one value, a range end may
be negative and may be zero, and a target may carry a decimal fraction and SHALL NOT be rounded to a
whole number. A number typed with more significant digits than this system keeps exactly is not a
number and SHALL be refused as such rather than kept shortened.

#### Scenario: a commitments screen refuses a range end that is not a number

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Mood" on a weekday-set rhythm of all seven weekdays,
  kept from that same day, under no category, of the number kind with a lowest of "one" and a highest
  of "10", is defined through it
- **THEN** it is refused as a range that is not a range
- **AND** a commitment alike in every way with a lowest of "1" and a highest of "1e2" is refused the
  same way
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a commitments screen refuses a range with one end typed and the other blank

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Weight" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the number kind with a lowest of "40" and
  a highest of "", is defined through it
- **THEN** it is refused as a range that is not a range
- **AND** a commitment alike in every way with a lowest of "  " and a highest of "150" is refused the
  same way
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a commitments screen refuses a target that is not a number

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Protein" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the total kind with a target of "120g", is
  defined through it
- **THEN** it is refused as a target that is not a target
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a commitments screen refuses a target that is not above zero

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Protein" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the total kind with a target of "0", is
  defined through it
- **THEN** it is refused as a target that is not a target
- **AND** a commitment alike in every way with a target of "-1" is refused the same way
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a commitments screen refuses a total with nothing in its target field

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Protein" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the total kind with a target of "", is
  defined through it
- **THEN** it is refused as a target that is not a target
- **AND** a commitment alike in every way with a target of "   " is refused the same way
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a range end and a target of more than thirty-eight significant digits are not numbers

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Mood" on a weekday-set rhythm of all seven weekdays,
  kept from that same day, under no category, of the number kind with a lowest of "1" and a highest
  of a 1 followed by thirty-nine 9s, is defined through it; and then one named "Protein" alike in
  rhythm, day and category, of the total kind with a target of that same number
- **THEN** the first is refused as a range that is not a range and the second as a target that is not
  a target
- **AND** a commitment named "Mood" alike in every way whose highest is a 1 followed by
  thirty-seven 9s is not refused
- **AND** what the screen keeps is that one entry, named "Mood"

#### Scenario: a commitments screen accepts a range of one value, and one whose ends are negative and zero

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and two commitments on a weekday-set rhythm of all seven weekdays, kept from
  that same day, under no category, are defined through it — "Doses" of the number kind with a lowest
  of "7" and a highest of "7", and "Weight change" of the number kind with a lowest of "-40.5" and a
  highest of "0"
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place holds "Doses" with a range whose lowest and
  highest are both 7, and "Weight change" with a range whose lowest is -40.5 and whose highest is 0

#### Scenario: a commitments screen accepts a target with a decimal fraction, below one

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and two commitments on a weekday-set rhythm of all seven weekdays, kept from
  that same day, under no category, are defined through it — "Dose" of the total kind with a target
  of "0.5" and "Vitamin D" of the total kind with a target of "0.0001"
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place holds "Dose" with a target of 0.5 and
  "Vitamin D" with a target of 0.0001

#### Scenario: a range a commitments screen refuses is told apart from a target and from its other refusals

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and four commitments on a weekday-set rhythm of all seven weekdays, kept
  from that same day, under no category, are defined through it — "Mood" of the number kind with a
  lowest of "10" and a highest of "1"; "Protein" of the total kind with a target of "0"; "   " of the
  tick kind; and "Finances" of the tick kind on a day-of-the-month rhythm of the 32nd instead
- **THEN** the first is refused as a range that is not a range, the second as a target that is not a
  target, the third as a name that says nothing and the fourth as a rhythm number the calendar will
  not take, each of the four told apart from the other three
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a commitments screen holds a refused range against defining a commitment

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Mood" on a weekday-set rhythm of all seven weekdays,
  kept from that same day, under no category, of the number kind with a lowest of "10" and a highest
  of "1", is defined through it
- **THEN** the screen holds that refusal, against defining a commitment
- **AND** a screen alike in every way asked afterwards to define "Protein" of the total kind with a
  target of "0" holds that refusal instead, against defining a commitment
