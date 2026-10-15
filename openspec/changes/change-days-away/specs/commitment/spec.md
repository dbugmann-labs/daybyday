## ADDED Requirements

### Requirement: A commitments screen changes the name, days and commitments of days away it lists, judged as saying judges them and never against themselves

A commitments screen SHALL change days away it lists, past ones included, to a name, a first day, a
last day and the commitments picked, keeping the change at the roster place before it lists them,
and the days away changed SHALL stay the same days away. The name and the days SHALL be read as days
away said read them. The commitments picked SHALL be ones it keeps, or stopped ones those days away
are over. A change SHALL be refused for every reason days away said are refused, judged against
every other days away the roster holds and never against those changed, and a refused change SHALL
keep nothing and leave its lists as they were. Asked to change days away it does not list, or over a
commitment it neither keeps nor those days away are over, it SHALL do nothing and say nothing.

#### Scenario: days away renamed keep their days and commitments and stay the same days away

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; a commitments screen is opened at that
  roster place as of Monday 12 October 2026; days away named "Mallorca" from Tuesday 13 through Sunday
  18 October 2026 are said through it over "Gym" and "Run"; and they are changed through it to the
  name " Majorca ", their own days and both commitments
- **THEN** nothing is refused
- **AND** it lists one days away, "Majorca", "Tue 13 Oct – Sun 18 Oct", over "Gym" and "Run", equal to
  the days away it listed before the change
- **AND** changed again to a name that says nothing, it lists them as "Away", and a roster store opened
  afterwards at that place holds "Gym" and "Run" due on Monday 19 October 2026 and on none of Tuesday
  13 through Sunday 18 October 2026

#### Scenario: a change ending before it begins, or over nothing, is refused and keeps nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 12 October 2026; days away named "Mallorca" from Tuesday 13 through Sunday 18 October 2026
  are said through it over "Gym"; the content at that place is read; and they are changed through it
  to run from Wednesday 14 through Tuesday 13 October 2026 over "Gym", and to their own days over
  nothing
- **THEN** the first is refused as a last day before the first and the second as days away over
  nothing
- **AND** it lists "Mallorca", "Tue 13 Oct – Sun 18 Oct", over "Gym", and the content at that place is
  byte-for-byte what was read

#### Scenario: a change is judged against other days away and never against the days away changed

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 12 October 2026; days away named "Mallorca" from Tuesday 13 through Sunday 18 October 2026
  and days away named "Lisbon" from Tuesday 20 through Wednesday 21 October 2026 are said through it
  over "Gym"; and "Mallorca" is changed through it to run from Wednesday 14 through Monday 19 October
  2026 over "Gym"
- **THEN** it is not refused
- **AND** changed again to run through Tuesday 20 October 2026, it is refused as overlapping days away,
  naming "Lisbon", and it lists "Mallorca", "Wed 14 Oct – Mon 19 Oct"

#### Scenario: a commitment picked by a change is refused where it is kept from their first day or later or has a shift on one of their days, naming it

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, one named "Swim" on a
  schedule listing Monday, Wednesday and Saturday, both kept from 1 January 2026, and one named
  "Yoga" on a schedule listing all seven weekdays, kept from Wednesday 14 October 2026, are taken on
  at a roster place; the due day of "Swim" on Monday 12 October 2026 is shifted there to Tuesday
  13 October 2026; a commitments screen is opened at that roster place as of Monday 12 October 2026;
  days away named "Mallorca" from Tuesday 13 through Sunday 18 October 2026 are said through it over
  "Gym"; and they are changed through it over "Gym" and "Yoga", and then over "Gym" and "Swim"
- **THEN** the first is refused as over a commitment kept from a later day, naming "Yoga", and the
  second as over a commitment with a shift on one of their days, naming "Swim"
- **AND** it lists "Mallorca" over "Gym" alone

#### Scenario: a change asked of days away it does not list, or over a stopped commitment they are not over, does nothing

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place, and "Run" is stopped there as of
  Sunday 11 October 2026; a commitments screen is opened at that roster place as of Monday 12 October
  2026; days away named "Mallorca" from Tuesday 13 through Sunday 18 October 2026 are said through it
  over "Gym"; the content at that place is read; and "Mallorca" is changed through it over "Gym" and
  "Run"
- **THEN** nothing is refused, it lists "Mallorca" over "Gym" alone, and the content at that place is
  byte-for-byte what was read
- **AND** once "Mallorca" is removed through it, the removal confirmed, and the content read again,
  "Mallorca" changed through it to end on Saturday 17 October 2026 is not refused, it lists no days
  away, and the content is byte-for-byte what was read the second time

#### Scenario: a change a commitments screen cannot keep at its roster place is refused and the days away stay as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 12 October 2026; days away named "Mallorca" from Tuesday 13 through Sunday 18 October 2026
  are said through it over "Gym"; what is at that place is then made impossible to write; and
  "Mallorca" is changed through it to end on Saturday 17 October 2026
- **THEN** it is refused as a roster that could not be written
- **AND** it lists "Mallorca", "Tue 13 Oct – Sun 18 Oct"

### Requirement: Days away hide the days they are over from each commitment they are over, and leave its eras as they are

Days away SHALL hide from each commitment they are over every day from their first day through
their last on which the record holds no tick, number, note, addition or decline of that commitment;
where no record is read, every such day SHALL be hidden. A hidden day SHALL be due on no rhythm, and
every reader of a commitment's days SHALL read it as a day of a gap. A day holding a record SHALL NOT
be hidden, and SHALL be hidden again once that record is taken back. An every-N-days era SHALL be
counted again from the latest day after days away over the commitment that it holds, on or before
the day read. Saying, changing or removing days away, and ticking or unticking a commitment on them,
SHALL change no era, stop or take-up of any commitment.

#### Scenario: days away said, changed and removed leave the eras of the commitments they are over as they were

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and one named "Nails" on a schedule of every 4 days starting on Thursday 1 October
  2026, kept from that day, are taken on at a roster place; a commitments screen is opened at that
  roster place as of Monday 12 October 2026; days away named "Mallorca" from Tuesday 13 through Sunday
  18 October 2026 are said through it over both; they are changed through it to end on Tuesday
  20 October 2026 over "Gym" alone; and they are removed through it, the removal confirmed
- **THEN** nothing is refused
- **AND** after each of the three, a roster store opened at that place holds one era of "Gym", kept from
  1 January 2026 and saying "Mon, Wed, Sat", and one era of "Nails", kept from Thursday 1 October 2026
  and saying "Every 4 days", and has stopped neither

#### Scenario: days away from today hide no day holding a record of a commitment picked, and hide it once the record is taken back

- **WHEN** a commitment named "Creatine" and one named "Magnesium", both on schedules listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; a tick for "Creatine"
  on Monday 12 October 2026 is kept at a record place; a commitments screen is opened at those places
  as of that day; and days away from Monday 12 through Wednesday 14 October 2026 are said through it
  over both
- **THEN** nothing is refused
- **AND** a day screen opened at those places as of Monday 12 October 2026 holds one row, named
  "Creatine", saying it is kept; one opened as of Tuesday 13 October 2026 holds no row; one opened
  as of Thursday 15 October 2026 holds both
- **AND** once that tick is taken back at the record place, a day screen opened there as of Monday
  12 October 2026 holds no row

#### Scenario: a day holding a record under days away keeps its row through every later change of them

- **WHEN** a commitment named "Creatine" and one named "Magnesium", both on schedules listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; a tick for "Creatine"
  on Monday 12 October 2026 is kept at a record place; days away from that Monday through Wednesday
  14 October 2026 are said over both through a commitments screen opened at those places as of that
  Monday; and through one opened there as of Tuesday 13 October 2026 they are changed to end on
  Friday 16 October 2026, and then to begin on Sunday 11 October 2026
- **THEN** neither is refused
- **AND** a day screen opened at those places as of Monday 12 October 2026 holds one row, named
  "Creatine", saying it is kept; one opened as of Sunday 11 or Thursday 15 October 2026 holds no row;
  and one opened as of Saturday 17 October 2026 holds both

#### Scenario: an every-N-days count begins again on the day after each days away over it, and runs on unbroken once those days away are removed

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 1 October
  2026, kept from that day, is taken on at a roster place; a commitments screen is opened at that
  roster place as of Monday 12 October 2026; and days away named "Lisbon" from Tuesday 13 through
  Wednesday 14 October 2026 and days away named "Mallorca" from Tuesday 20 through Wednesday
  21 October 2026 are said through it over "Nails"
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place holds "Nails" due on Friday 9, Thursday 15,
  Monday 19, Thursday 22 and Monday 26 October 2026, and on none of Tuesday 13, Saturday 17, Friday 23
  and Sunday 25 October 2026
- **AND** once "Lisbon" is removed through it, the removal confirmed, one holds "Nails" due on Tuesday
  13, Saturday 17, Thursday 22 and Monday 26 October 2026, and on neither Thursday 15 nor Monday
  19 October 2026

### Requirement: A commitments screen says days away over the commitments it keeps that are picked, hiding their days

A commitments screen SHALL say days away from a name, a first day, a last day and the commitments it
keeps that are picked, keeping them at the roster place before it lists them. The name SHALL be
trimmed of blank space at either end, one that says nothing meaning none, and SHALL NOT be refused for
being one other days away carry. The first day SHALL be any day, however long gone, and the last day
the first or later, unlimited. Each commitment picked SHALL have their days hidden as *Days away hide
the days they are over from each commitment they are over, and leave its eras as they are* says, and
every other commitment SHALL be left as it was.

#### Scenario: days away said over two commitments leave them no row on their days and rows again from the day after

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, one named
  "Run" on a schedule listing Tuesday, Thursday and Sunday, and one named "Creatine" on a schedule
  listing all seven weekdays, each kept from 1 January 2026, are taken on at a roster place; a
  commitments screen is opened at that roster place and a record place where nothing has been kept,
  as of Monday 12 October 2026; and days away named "Mallorca" from Tuesday 13 through Sunday
  18 October 2026 are said through it over "Gym" and "Run"
- **THEN** nothing is refused
- **AND** what it keeps is three entries, named "Gym", "Run" and "Creatine", and it has stopped nothing
- **AND** a day screen opened at those places as of Monday 12 October 2026 holds rows named "Gym" and
  "Creatine"; one opened as of Wednesday 14, Thursday 15 or Saturday 17 October 2026 holds one row,
  named "Creatine"
- **AND** one opened as of Monday 19 October 2026 holds rows named "Gym" and "Creatine", and one opened
  as of Tuesday 20 October 2026 rows named "Run" and "Creatine"

#### Scenario: days away keep their name trimmed, and a name that says nothing is none

- **WHEN** commitments named "Gym", "Run" and "Creatine" on schedules listing all seven weekdays,
  kept from 1 January 2026, are taken on at a roster place; a commitments screen is opened at that
  roster place as of Monday 12 October 2026; and days away named " Mallorca " from Tuesday 13 through
  Sunday 18 October 2026 over "Gym", days away named "   " from Tuesday 20 through Tuesday 20 October
  2026 over "Creatine", and days away named "Mallorca" from Monday 19 through Tuesday 20 October 2026
  over "Run" are said through it
- **THEN** none of the three is refused
- **AND** the days away it lists are named "Mallorca", "Mallorca" and none

#### Scenario: days away of one day are said, and so are days away of any length however far ahead

- **WHEN** a commitment named "Creatine" and one named "Run", both on schedules listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen is
  opened at that roster place and a record place where nothing has been kept, as of Monday 12 October
  2026; and days away from Tuesday 13 through Tuesday 13 October 2026 over "Creatine", and days away
  from Tuesday 1 June 2027 through Saturday 31 December 2033 over "Run", are said through it
- **THEN** neither is refused
- **AND** a day screen opened at those places as of Tuesday 13 October 2026 holds one row, named
  "Run", and one opened as of Wednesday 14 October 2026 holds rows named "Creatine" and "Run"
- **AND** one opened as of Wednesday 15 September 2027 holds one row, named "Creatine"

#### Scenario: a commitment is taken up again after days away on the rhythm, range and target it had, an every-N-days count beginning again

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 1 October
  2026, kept from that day, and one named "Weight" of the number kind with a range of 40 to 150 on a
  schedule listing all seven weekdays, kept from 1 January 2026, are taken on at a roster place; a
  commitments screen is opened at that roster place as of Monday 12 October 2026; and days away from
  Tuesday 13 through Sunday 18 October 2026 are said through it over both
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place holds "Nails" due on Friday 9, Monday 19 and
  Friday 23 October 2026, and on none of Tuesday 13, Saturday 17 and Wednesday 21 October 2026
- **AND** a day screen opened at that roster place as of Monday 19 October 2026, at a record place
  where nothing has been kept, holds a row named "Weight" whose number entry says the range "40–150"

#### Scenario: days away said over days already gone hide those days, however far back

- **WHEN** a commitment named "Gym" and one named "Creatine", both on schedules listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen is
  opened at that roster place and a record place where nothing has been kept, as of Monday 12 October
  2026; and days away named "Sick" from Monday 5 through Wednesday 7 October 2026 over "Gym", days
  away named "Lisbon" from Friday 28 through Monday 31 August 2026 over "Gym", and days away from
  Saturday 10 through Wednesday 14 October 2026 over "Creatine" are said through it
- **THEN** none of the three is refused
- **AND** a day screen opened at those places as of Tuesday 6 October 2026 holds one row, named
  "Creatine"; one opened as of Thursday 8 October 2026 holds rows named "Gym" and "Creatine"; and one
  opened as of Monday 12 October 2026 holds one row, named "Gym"
- **AND** a roster store opened afterwards at that place holds "Gym" due on Thursday 27 August and
  Tuesday 1 September 2026, and not on Saturday 29 August 2026

### Requirement: A change of days away gives back the days a commitment no longer has under them and takes those it newly has

A kept change SHALL hide from each commitment the changed days away are over exactly the days they
now cover, and SHALL give back every day they no longer cover as that commitment's own eras have it:
on the rhythm, range and target of the era holding it, owing nothing where no era holds it, an
every-N-days count beginning again on the day after their new last day. A commitment newly picked
SHALL have their days hidden as saying hides them, and one unpicked SHALL be left as a removal leaves
it. The same days reached in one change or several SHALL leave every commitment owing the same days,
and a change moved back SHALL give back exactly what it took.

#### Scenario: a last day moved later keeps commitments away through it and takes them up again the day after, an every-N-days count beginning there

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, and one named "Nails" on a schedule of every 4 days starting on Thursday 1 October 2026, kept
  from that day, are taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 12 October 2026; days away named "Mallorca" from Tuesday 13 through Sunday 18 October
  2026 are said through it over both; and they are changed through it to end on Tuesday 20 October
  2026
- **THEN** nothing is refused, and it lists "Mallorca", "Tue 13 Oct – Tue 20 Oct"
- **AND** a roster store opened afterwards at that place holds "Gym" due on Wednesday 21 October 2026
  and on neither Monday 19 nor Tuesday 20 October 2026, and "Nails" due on Wednesday 21 and Sunday
  25 October 2026 and on neither Monday 19 nor Friday 23 October 2026

#### Scenario: a last day moved earlier gives its days back, owed again, and takes commitments up again the day after

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, and one named "Nails" on a schedule of every 4 days starting on Thursday 1 October 2026, kept
  from that day, are taken on at a roster place; days away named "Mallorca" from Tuesday 13 through
  Sunday 18 October 2026 are said over both through a commitments screen opened at that roster place
  as of Monday 12 October 2026; and they are changed to end on Thursday 15 October 2026 through one
  opened there as of that Thursday
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place holds "Gym" due on Friday 16 and Saturday
  17 October 2026 and not on Thursday 15 October 2026, and "Nails" due on Friday 16 and Tuesday
  20 October 2026 and not on Monday 19 October 2026
- **AND** a day screen opened at that roster place and a record place where nothing has been kept, as
  of Friday 16 October 2026, holds rows named "Gym" and "Nails"

#### Scenario: a first day moved earlier takes days already gone, and moved later gives days back on the rhythm held before

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  and a record place where nothing has been kept, as of Monday 12 October 2026; days away named
  "Mallorca" from Tuesday 13 through Sunday 18 October 2026 are said through it over "Gym"; and they
  are changed through it to begin on Thursday 8 October 2026, and then to begin on Thursday
  15 October 2026
- **THEN** neither is refused
- **AND** after the first, a roster store opened at that place holds "Gym" due on Wednesday 7 October
  2026 and on neither Saturday 10 nor Monday 12 October 2026
- **AND** after the second, one holds "Gym" due on Saturday 10, Monday 12 and Wednesday 14 October 2026
  and on neither Tuesday 13 nor Saturday 17 October 2026

#### Scenario: a commitment ticked onto days away has their days hidden, and one unticked is left as though it had never been picked

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, and one named "Nails" on a schedule of every 4 days starting on
  Thursday 1 October 2026, kept from that day, are taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 12 October 2026; days away named "Mallorca" from Tuesday 13
  through Sunday 18 October 2026 are said through it over "Gym" and "Nails"; and they are changed
  through it over "Gym" and "Run"
- **THEN** nothing is refused, and it lists "Mallorca" over "Gym" and "Run"
- **AND** a roster store opened afterwards at that place holds "Run" due on Monday 19 October 2026 and
  not on Thursday 15 October 2026, and "Nails" due on Tuesday 13, Saturday 17 and Wednesday 21 October
  2026 and not on Monday 19 October 2026

### Requirement: A change through a commitments screen keeps a commitment's days away and puts its era on from the day handed, inside them or not

A change of rhythm, range or target through a commitments screen SHALL leave every days away the
commitment is over where they were, and SHALL put its era on from the day the screen was handed as it
would without them, whether or not days away over the commitment hide that day. Those days away SHALL
hide the era's days through their last day, an every-N-days count beginning again the day after them.
Days a later change or a removal gives back SHALL be owed on the era holding each, those before the
day of the change on the era held before it. A change moving the day the commitment is kept from onto
or past the first day of days away it is over SHALL be refused as moving it into those days away,
naming them, and SHALL change nothing.

#### Scenario: a rhythm changed before days away begin holds before them and after them, and not on their days

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 12 October 2026; days away named "Mallorca" from Tuesday 13 through Sunday 18 October
  2026 are said through it over "Gym"; and "Gym" is changed through it to a schedule listing all seven
  weekdays
- **THEN** nothing is refused, and it still lists "Mallorca" over "Gym"
- **AND** a roster store opened afterwards at that place holds "Gym" due on Monday 12, Monday 19 and
  Tuesday 20 October 2026, and on none of Tuesday 13 through Sunday 18 October 2026

#### Scenario: a rhythm changed while days away are under way holds from the day it was changed, hidden until the day after them

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; days away named "Mallorca" from Tuesday 13 through
  Sunday 18 October 2026 are said over "Gym" through a commitments screen opened at that roster place
  as of Monday 12 October 2026; and "Gym" is changed to a schedule listing all seven weekdays through
  a commitments screen opened there as of Thursday 15 October 2026
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place holds "Gym" due on Monday 12, Monday 19 and
  Tuesday 20 October 2026, and on none of Tuesday 13 through Sunday 18 October 2026
- **AND** once "Mallorca" is removed through that screen, the removal confirmed, one holds "Gym" due on
  Wednesday 14, Thursday 15 and Friday 16 October 2026, and not on Tuesday 13 October 2026

#### Scenario: an every-N-days count changed before days away begins again on the day after them

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 1 October
  2026, kept from that day, is taken on at a roster place; a commitments screen is opened at that
  roster place as of Monday 12 October 2026; days away from Tuesday 13 through Sunday 18 October 2026
  are said through it over "Nails"; and "Nails" is changed through it to every 3 days
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place holds "Nails" due on Monday 12, Monday 19 and
  Thursday 22 October 2026, and on none of Thursday 15, Wednesday 21 and Saturday 24 October 2026

#### Scenario: the day kept from moved onto or past days away is refused, naming them

- **WHEN** a commitment named "Creatine" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 12 October 2026; days away named "Mallorca" from Tuesday 13 through Sunday 18 October 2026
  are said through it over "Creatine"; the content at that place is read; and "Creatine" is changed
  through it to be kept from Tuesday 13 October 2026, and then from Monday 19 October 2026
- **THEN** both are refused as moving the day kept from into days away, naming "Mallorca", and the
  content at that place is byte-for-byte what was read
- **AND** "Creatine" changed through it to be kept from Monday 12 October 2026 is not refused

#### Scenario: a commitment changed while away keeps its new rhythm from the day it was changed wherever the days away move, and once they are removed

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; days away named "Mallorca" from Tuesday 13 through
  Sunday 18 October 2026 are said over "Gym" through a commitments screen opened at that roster place
  as of Monday 12 October 2026; "Gym" is changed to a schedule listing all seven weekdays through one
  opened there as of Thursday 15 October 2026; and through that screen "Mallorca" is changed to end on
  Friday 16 October 2026, then to end on Tuesday 20 October 2026, then to run from Saturday 17 through
  Tuesday 20 October 2026, and then to run from Tuesday 13 through Tuesday 20 October 2026
- **THEN** nothing is refused
- **AND** after the first, a roster store opened at that place holds "Gym" due on Saturday 17 and Sunday
  18 October 2026 and on neither Thursday 15 nor Friday 16 October 2026
- **AND** after the second, one holds "Gym" due on Wednesday 21 and Thursday 22 October 2026 and on
  none of Saturday 17, Sunday 18 and Monday 19 October 2026
- **AND** after the third, one holds "Gym" due on Wednesday 14, Thursday 15 and Friday 16 October 2026
  and on neither Tuesday 13 nor Saturday 17 October 2026; after the fourth, one holds it due on
  Wednesday 21 October 2026 and on none of Wednesday 14 through Tuesday 20 October 2026
- **AND** removed then through it, the removal confirmed, one holds "Gym" due on Wednesday 14, Thursday
  15, Tuesday 20 and Thursday 22 October 2026 and not on Tuesday 13 October 2026

#### Scenario: a change of rhythm made before days away that a change then covers holds from its own day again when they move back

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; days away named "Mallorca" from Tuesday 20 through
  Sunday 25 October 2026 are said over "Gym" through a commitments screen opened at that roster place
  as of Monday 12 October 2026; "Gym" is changed to a schedule listing all seven weekdays through one
  opened there as of Thursday 15 October 2026; and through that screen "Mallorca" is changed to begin
  on Tuesday 13 October 2026, and then to begin on Tuesday 20 October 2026
- **THEN** neither is refused
- **AND** after the first, a roster store opened at that place holds "Gym" due on Tuesday 27 October
  2026 and on none of Wednesday 14 through Sunday 25 October 2026
- **AND** after the second, one holds "Gym" due on Wednesday 14, Thursday 15, Friday 16 and Monday
  19 October 2026, and on none of Tuesday 13 and Tuesday 20 through Sunday 25 October 2026

### Requirement: A commitments screen refuses days away said or changed that would put a recorded day under them, naming the commitment and the day

A commitments screen SHALL refuse days away said or changed that would newly put within their days,
for a commitment picked, a day on which its record holds a tick, a number, a note, an addition or a
decline of that commitment, naming the first such commitment the roster holds and that commitment's
earliest such day. A first day that is the day the screen was handed SHALL NOT be judged, nor SHALL
days a change gives back or days within those days away before the change. A screen that cannot read
its record SHALL judge no day as holding a record. A refused saying or change SHALL keep nothing and
leave its lists as they were.

#### Scenario: days away said over a day holding any record of a commitment picked are refused, naming it and the day

- **WHEN** commitments named "Gym", "Run" and "Creatine", one named "Weight" of the number kind with a
  range of 40 to 150, one named "Journal" of the note kind and one named "Water" of the total kind
  with a target of 120, each on a schedule listing all seven weekdays and kept from 1 January 2026, are
  taken on at a roster place; "Run" is put under the category "Sport" there; kept at a record place
  are a tick for "Run" on Monday 5 October 2026, a
  tick for "Gym" on Tuesday 6 and on Wednesday 7 October 2026, and on Tuesday 6 October 2026 a
  number of 70.5 for "Weight", a note for "Journal", an addition of 30 for "Water" and a decline of
  "Creatine"; a commitments screen is opened at those places as of Monday 12 October 2026; the content
  at the roster place is read; and days away from Monday 5 through Wednesday 7 October 2026 are said
  through it over each of "Weight", "Journal", "Water" and "Creatine" alone, and over "Gym" and "Run"
- **THEN** each of the first four is refused as over a recorded day, naming that commitment and
  Tuesday 6 October 2026, and the fifth naming "Gym" and Tuesday 6 October 2026
- **AND** it lists no days away, and the content at the roster place is byte-for-byte what was read

#### Scenario: a commitment ticked onto days away over a day holding its record is refused, naming it and the day

- **WHEN** a commitment named "Gym" and one named "Yuno", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; a tick for "Yuno" on Saturday
  10 October 2026 is kept at a record place; a commitments screen is opened at those places as of
  Monday 12 October 2026; days away named "Mallorca" from Saturday 10 through Sunday 18 October 2026
  are said through it over "Gym"; and they are changed through it over "Gym" and "Yuno"
- **THEN** the change is refused as over a recorded day, naming "Yuno" and Saturday 10 October 2026
- **AND** it lists "Mallorca" over "Gym" alone, and changed through it to run from Sunday 11 through
  Sunday 18 October 2026 over both, it is not refused

#### Scenario: days away moved over a recorded day are refused, and days they give back or already hold are not judged

- **WHEN** a commitment named "Creatine" and one named "Magnesium", both on schedules listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; ticks for "Creatine" on
  Saturday 10 and Monday 12 October 2026 are kept at a record place; days away from that Monday
  through Friday 16 October 2026 are said over both through a commitments screen opened at those
  places as of that Monday; ticks for "Magnesium" on Wednesday 14 and Friday 16 October 2026 are then
  kept at the record place; and through a commitments screen opened at those places as of Tuesday
  13 October 2026 the days away are changed to begin on Saturday 10 October 2026, then to begin on
  Sunday 11 October 2026, then to end on Thursday 15 October 2026, and then to the name "Flu"
- **THEN** the first is refused as over a recorded day, naming "Creatine" and Saturday 10 October 2026,
  and none of the other three is refused
- **AND** a day screen opened at those places as of Friday 16 October 2026 holds a row named
  "Magnesium" saying it is kept, and one opened as of Monday 12 October 2026 a row named "Creatine"
  saying it is kept

#### Scenario: a first day moved onto the day handed keeps through it a commitment holding a record there

- **WHEN** a commitment named "Creatine" and one named "Magnesium", both on schedules listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; a tick for "Creatine"
  on Monday 12 October 2026 is kept at a record place; a commitments screen is opened at those places
  as of that Monday; days away from Tuesday 13 through Sunday 18 October 2026 are said through it over
  both; and they are changed through it to begin on Monday 12 October 2026
- **THEN** it is not refused
- **AND** a day screen opened at those places as of Monday 12 October 2026 holds one row, named
  "Creatine", saying it is kept, and one opened as of Tuesday 13 October 2026 holds no row

#### Scenario: a commitments screen that cannot read its record refuses no days away for a record

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place and at a
  record place holding a run of bytes that is not what a record is written as, as of Monday
  12 October 2026; and days away from Monday 5 through Wednesday 7 October 2026 are said through it
  over "Gym"
- **THEN** they are not refused
- **AND** a roster store opened afterwards at that place holds "Gym" due on neither Monday 5 nor
  Wednesday 7 October 2026

### Requirement: A change of days away keeps a stopped commitment they are over, picked or not, until it moves their first day past the day after its stop

A change through a commitments screen SHALL keep over the changed days away a stopped commitment
they are over that stays picked, and SHALL give one no longer picked back their days as a removal
gives them back. A change moving their first day later than the day after the last day a stopped
commitment was kept SHALL take it out of them, giving back their days as a removal does, and a change
leaving them over no commitment SHALL be refused as days away over no commitment. No change SHALL move
the day a stopped commitment was kept until.

#### Scenario: a stopped commitment in days away already past stays picked through a change, and unticked has their days back up to its stop

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Flu" from Thursday
  1 through Saturday 3 October 2026 are said over both through a commitments screen opened at that
  roster place as of Thursday 1 October 2026; "Gym" is stopped, the stop confirmed, through one opened
  there as of Monday 12 October 2026; and through that screen "Flu" is changed to the name "Fever"
  over both, and then over "Run" alone
- **THEN** neither is refused
- **AND** after the first it lists "Fever" as past over "Gym" and "Run", and after the second over
  "Run" alone
- **AND** a day screen opened at that roster place and a record place where nothing has been kept, as
  of Friday 2 October 2026, holds one row, named "Gym"
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had not
  stopped keeping on Sunday 11 October 2026 and not on Monday 12 October 2026

#### Scenario: days away moved past the last day a stopped commitment was kept leave it stopped on the day it was

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Flu" from Thursday
  1 through Saturday 3 October 2026 are said over both through a commitments screen opened at that
  roster place as of Thursday 1 October 2026; "Gym" is stopped, the stop confirmed, through one opened
  there as of Monday 5 October 2026; and "Flu" is changed to end on Wednesday 7 October 2026 through
  one opened there as of Monday 12 October 2026
- **THEN** it is not refused, and that screen lists "Flu" as past over "Gym" and "Run"
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had not
  stopped keeping on Sunday 4 October 2026 and not on Monday 5 October 2026, holds "Gym" due on none of
  Thursday 1 through Sunday 4 October 2026, and holds "Run" due on Thursday 8 October 2026 and not on
  Monday 5 October 2026

#### Scenario: a stopped commitment kept until the day before days away stays picked through a later change of them, owing no day after its stop

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Flu" from Thursday
  1 through Saturday 3 October 2026 are said over both through a commitments screen opened at that
  roster place as of Thursday 1 October 2026, and "Gym" is stopped through it, the stop confirmed; and
  through one opened there as of Monday 12 October 2026 "Flu" is changed to end on Wednesday 7 October
  2026, and then to the name "Fever", from Thursday 1 through Wednesday 7 October 2026, over both
- **THEN** neither is refused, and that screen lists "Fever" as past over "Gym" and "Run"
- **AND** a day screen opened at that roster place and a record place where nothing has been kept, as
  of Thursday 1 October 2026, holds no row
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had not
  stopped keeping on Wednesday 30 September 2026 and not on Thursday 1 October 2026

#### Scenario: days away over nothing but a commitment stopped the day after them are renamed, and moved earlier, still over it

- **WHEN** a commitment named "Gym", on a schedule listing all seven weekdays and kept from 1 January
  2026, is taken on at a roster place; days away named "Flu" from Thursday 1 through Saturday
  3 October 2026 are said over it through a commitments screen opened at that roster place as of
  Thursday 1 October 2026; "Gym" is stopped, the stop confirmed, through one opened there as of Sunday
  4 October 2026; and through one opened there as of Monday 12 October 2026 "Flu" is changed to the
  name "Fever", from Thursday 1 through Saturday 3 October 2026, over "Gym", and then to run from
  Monday 28 September through Saturday 3 October 2026 over "Gym"
- **THEN** neither is refused, and that screen lists "Fever" as past, "Mon 28 Sep – Sat 3 Oct", over
  "Gym"
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had not
  stopped keeping on Saturday 3 October 2026 and not on Sunday 4 October 2026, and holds "Gym" due on
  Sunday 27 September 2026 and on none of Monday 28 September through Saturday 3 October 2026

#### Scenario: days away moved wholly past the last day a stopped commitment was kept leave it out, and are refused where it was all they were over

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Flu" from Thursday
  1 through Saturday 3 October 2026 over both, and days away named "Cold" from Tuesday 1 through
  Wednesday 2 September 2026 over "Gym", are said through a commitments screen opened at that roster
  place as of Thursday 1 October 2026; "Gym" is stopped, the stop confirmed, through one opened there
  as of Monday 5 October 2026; and through one opened there as of Monday 12 October 2026 "Cold" is
  changed to run from Tuesday 6 through Thursday 8 October 2026 over "Gym", and "Flu" to those days
  over both
- **THEN** the first is refused as days away over no commitment, and the second is not refused
- **AND** that screen lists as past "Flu", "Tue 6 Oct – Thu 8 Oct", over "Run" alone, and "Cold",
  "Tue 1 Sep – Wed 2 Sep", over "Gym"
- **AND** a day screen opened at that roster place and a record place where nothing has been kept, as
  of Friday 2 October 2026, holds rows named "Gym" and "Run"
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had not
  stopped keeping on Sunday 4 October 2026 and not on Monday 5 October 2026

#### Scenario: a stopped commitment unticked from days away moved past its stop has their days back up to its stop and none after

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Flu" from Thursday
  1 through Saturday 3 October 2026 are said over both through a commitments screen opened at that
  roster place as of Thursday 1 October 2026; "Gym" is stopped, the stop confirmed, through one opened
  there as of Monday 5 October 2026; and through one opened there as of Monday 12 October 2026 "Flu"
  is changed to end on Wednesday 7 October 2026, and then over "Run" alone
- **THEN** neither is refused, and that screen lists "Flu" as past over "Run" alone
- **AND** a day screen opened at that roster place and a record place where nothing has been kept, as
  of Thursday 1 October 2026, holds one row, named "Gym", and one opened as of Monday 5 October 2026
  holds no row
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had not
  stopped keeping on Sunday 4 October 2026 and not on Monday 5 October 2026

#### Scenario: days away moved past a stop and then wholly past it give the stopped commitment back its days up to its stop

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Flu" from Thursday
  1 through Saturday 3 October 2026 are said over both through a commitments screen opened at that
  roster place as of Thursday 1 October 2026; "Gym" is stopped, the stop confirmed, through one opened
  there as of Monday 5 October 2026; and through one opened there as of Monday 12 October 2026 "Flu"
  is changed to end on Wednesday 7 October 2026, and then to run from Tuesday 6 through Thursday
  8 October 2026 over both
- **THEN** neither is refused, and that screen lists "Flu" as past, "Tue 6 Oct – Thu 8 Oct", over
  "Run" alone
- **AND** a day screen opened at that roster place and a record place where nothing has been kept, as
  of Thursday 1 October 2026, holds rows named "Gym" and "Run"
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had not
  stopped keeping on Sunday 4 October 2026 and not on Monday 5 October 2026

#### Scenario: days away moved past a stop and back again give the stopped commitment back its days up to its stop

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Flu" from Thursday
  1 through Saturday 3 October 2026 are said over both through a commitments screen opened at that
  roster place as of Thursday 1 October 2026; "Gym" is stopped, the stop confirmed, through one opened
  there as of Monday 5 October 2026; and through one opened there as of Monday 12 October 2026 "Flu"
  is changed to end on Wednesday 7 October 2026, and then to end on Saturday 3 October 2026
- **THEN** neither is refused, and that screen lists "Flu" as past, "Thu 1 Oct – Sat 3 Oct", over
  "Gym" and "Run"
- **AND** a day screen opened at that roster place and a record place where nothing has been kept, as
  of Sunday 4 October 2026, holds rows named "Gym" and "Run"
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had not
  stopped keeping on Sunday 4 October 2026 and not on Monday 5 October 2026

### Requirement: Days away said, moved, unticked or removed leave every stop and take-up where it was made, and give back exactly the days they hid

Every stop and take-up of a commitment SHALL stay on the day it was made, whatever days away over it
are said, changed, unticked or removed, before or after it was made, and through whichever commitments
screen, opened as of whichever day. A removal confirmed, an untick, and a change no longer covering a
day SHALL give each commitment back exactly the days those days away hid from it, each owed only where
its own eras hold it and its rhythm is due. No day between a stop and its take-up, and no day after a
stop not taken up, SHALL be owed for any of them.

#### Scenario: days away over a commitment stopped the day after them, removed, give it back every day of them

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Flu" from Thursday
  1 through Saturday 3 October 2026 are said over both through a commitments screen opened at that
  roster place as of Thursday 1 October 2026; "Gym" is stopped, the stop confirmed, through one opened
  there as of Sunday 4 October 2026; and "Flu" is removed, the removal confirmed, through one opened
  there as of Monday 12 October 2026
- **THEN** nothing is refused, and that screen lists no days away
- **AND** a day screen opened at that roster place and a record place where nothing has been kept, as
  of Friday 2 October 2026, holds rows named "Gym" and "Run"
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had not
  stopped keeping on Saturday 3 October 2026 and not on Sunday 4 October 2026

#### Scenario: days away moved past a stop and then removed give the stopped commitment back its days up to its stop and none after

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Flu" from Thursday
  1 through Saturday 3 October 2026 are said over both through a commitments screen opened at that
  roster place as of Thursday 1 October 2026; "Gym" is stopped, the stop confirmed, through one opened
  there as of Monday 5 October 2026; and through one opened there as of Monday 12 October 2026 "Flu"
  is changed to end on Wednesday 7 October 2026, and then removed, the removal confirmed
- **THEN** neither is refused, and that screen lists no days away
- **AND** a day screen opened at that roster place and a record place where nothing has been kept, as
  of Sunday 4 October 2026, holds rows named "Gym" and "Run", and one opened as of Tuesday 6 October
  2026 holds one row, named "Run"
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had not
  stopped keeping on Sunday 4 October 2026 and not on Monday 5 October 2026

#### Scenario: a stopped commitment taken up again after days away moved past its stop owes, once they are removed, its days up to its stop and none before it was taken up again

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Flu" from Thursday
  1 through Saturday 3 October 2026 are said over both through a commitments screen opened at that
  roster place as of Thursday 1 October 2026; "Gym" is stopped, the stop confirmed, through one opened
  there as of Monday 5 October 2026; and through one opened there as of Monday 12 October 2026 "Flu"
  is changed to end on Wednesday 7 October 2026, "Gym" is taken up again, and "Flu" is removed, the
  removal confirmed
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place holds "Gym" due on Sunday 4 and Monday
  12 October 2026, and on neither Monday 5 nor Sunday 11 October 2026

#### Scenario: a commitment taken up again after days away whose first day then moves past its stop and back owes, once they are removed, no day between its stop and its take-up

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Flu" from Thursday
  1 through Saturday 3 October 2026 are said over both through a commitments screen opened at that
  roster place as of Thursday 1 October 2026; "Gym" is stopped, the stop confirmed, through one opened
  there as of Monday 5 October 2026; and through one opened there as of Monday 12 October 2026 "Flu"
  is changed to end on Wednesday 7 October 2026, "Gym" is taken up again, "Flu" is changed to begin
  on Tuesday 6 October 2026 and then to begin on Thursday 1 October 2026, and "Flu" is removed, the
  removal confirmed
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place holds "Gym" due on Sunday 4 and Monday
  12 October 2026, and on none of Monday 5, Tuesday 6, Wednesday 7 and Sunday 11 October 2026

#### Scenario: days away said over the days of a stop and take-up already made give the commitment back, once removed, no day between them

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped, the stop confirmed,
  through a commitments screen opened at that roster place as of Monday 5 October 2026, and taken up
  again through one opened there as of Monday 12 October 2026; days away named "Sick" from Thursday
  1 through Wednesday 7 October 2026 are said through that screen over both; and "Sick" is removed
  through it, the removal confirmed
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place holds "Gym" due on Sunday 4 and Monday
  12 October 2026 and on none of Monday 5, Wednesday 7 and Sunday 11 October 2026, and "Run" due on
  Monday 5 October 2026

#### Scenario: days away moved to end before a stop made inside them, then removed, give the commitment back its days up to its stop and none after

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Mallorca" from
  Tuesday 13 through Sunday 18 October 2026 are said over both through a commitments screen opened at
  that roster place as of Monday 12 October 2026; "Gym" is stopped, the stop confirmed, through one
  opened there as of Thursday 15 October 2026; and through one opened there as of Friday 16 October
  2026 "Mallorca" is changed to end on Tuesday 13 October 2026 over both
- **THEN** it is not refused
- **AND** a roster store opened afterwards at that place holds "Gym" due on Wednesday 14 October 2026
  and on neither Tuesday 13 nor Thursday 15 October 2026
- **AND** once "Mallorca" is removed through that screen, the removal confirmed, one holds "Gym" due on
  Tuesday 13 and Wednesday 14 October 2026 and on none of Thursday 15 through Monday 19 October 2026

#### Scenario: a take-up after days away that a change then covers comes back to its own day when they move back

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Flu" from Thursday
  1 through Saturday 3 October 2026 are said over both through a commitments screen opened at that
  roster place as of Thursday 1 October 2026; "Gym" is stopped, the stop confirmed, through one opened
  there as of Monday 5 October 2026, and taken up again through one opened there as of Thursday
  8 October 2026; and through one opened there as of Monday 12 October 2026 "Flu" is changed to end
  on Saturday 10 October 2026 over both, and then to end on Saturday 3 October 2026 over both
- **THEN** neither is refused
- **AND** after the first, a roster store opened at that place holds "Gym" due on Sunday 11 October
  2026 and on neither Thursday 8 nor Saturday 10 October 2026
- **AND** after the second, one holds "Gym" due on Sunday 4, Thursday 8 and Saturday 10 October 2026
  and on neither Monday 5 nor Wednesday 7 October 2026

#### Scenario: days away said, moved and removed over the days of a stop leave the commitment owing none of them

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; "Run" is stopped, the stop confirmed,
  through a commitments screen opened at that roster place as of Friday 16 October 2026, and taken up
  again through one opened there as of Wednesday 28 October 2026; through that Wednesday screen, days
  away named "A" from Monday 12 through Sunday 18 October 2026 are said over "Run", and days away named
  "B" on Saturday 24 October 2026 over "Gym" and "Run"; "B" is removed through it, the removal
  confirmed; and "A" is changed through it to run from Tuesday 20 through Monday 26 October 2026 over
  "Run", then back to run from Monday 12 through Sunday 18 October 2026 over "Run", and is then removed,
  the removal confirmed
- **THEN** nothing is refused
- **AND** once "B" is removed, a roster store opened at that place holds "Run" due on none of Friday 16
  through Tuesday 27 October 2026, Saturday 24 October 2026 included, and "Gym" due on Saturday
  24 October 2026
- **AND** after the last removal, one holds "Run" due on Thursday 15 and Wednesday 28 October 2026 and
  on none of Friday 16 through Tuesday 27 October 2026

#### Scenario: a stop undone through a screen opened as of an earlier day leaves the days away over the commitment hiding their days

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Mallorca" from
  Tuesday 13 through Sunday 18 October 2026 are said over both through a commitments screen opened at
  that roster place as of Monday 12 October 2026; "Gym" is stopped, the stop confirmed, through one
  opened there as of Thursday 15 October 2026; and through one opened there as of Monday 12 October
  2026 "Gym" is taken up again, and "Mallorca" is changed to run from Tuesday 20 through Sunday
  25 October 2026 and then back to run from Tuesday 13 through Sunday 18 October 2026
- **THEN** nothing is refused, and that screen keeps "Gym" and lists "Mallorca" over "Gym" and "Run"
- **AND** before "Mallorca" is changed, a roster store opened at that place holds "Gym" due on Monday 12
  and Monday 19 October 2026 and on none of Tuesday 13 through Sunday 18 October 2026, and after both
  changes one holds it so again

#### Scenario: a stop made through a screen opened as of a day before the commitment's take-up leaves days away giving back only its days before the stop

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Mallorca" from
  Tuesday 13 through Sunday 18 October 2026 are said over both through a commitments screen opened at
  that roster place as of Monday 12 October 2026; "Gym" is stopped, the stop confirmed, through one
  opened there as of Thursday 15 October 2026, and taken up again through one opened there as of
  Saturday 17 October 2026; "Gym" is stopped again, the stop confirmed, through one opened there as of
  Friday 16 October 2026; and through that Friday screen "Mallorca" is changed to end on Sunday
  25 October 2026, then back to end on Sunday 18 October 2026, and is then removed, the removal
  confirmed
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place holds "Gym" due on Tuesday 13 and Wednesday
  14 October 2026 and on none of Friday 16 through Monday 26 October 2026, and "Run" due on every day
  of those

### Requirement: A commitments screen takes a commitment up again inside days away over it on the day it is handed, its days hidden until the day after them

A commitments screen asked to take up again a stopped commitment on a day inside days away over it
SHALL take it up on that day as on any other, on the rhythm, range and target it had, and those days
away SHALL stay over it, hiding its days through their last day. No later change, untick or removal
of those days away SHALL move that take-up. Days away changed to end before it SHALL leave every day
between its stop and its take-up owing nothing, and days given back on or after it SHALL be owed on
the era it began.

#### Scenario: a commitment taken up again inside days away over it is taken up on the day it is handed, its days hidden until the day after them

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Mallorca" from
  Tuesday 13 through Sunday 18 October 2026 are said over both through a commitments screen opened at
  that roster place as of Monday 12 October 2026; "Gym" is stopped, the stop confirmed, through one
  opened there as of Thursday 15 October 2026; and "Gym" is taken up again through one opened there as
  of Friday 16 October 2026
- **THEN** nothing is refused, that screen keeps "Gym", and it lists "Mallorca" over "Gym" and "Run"
- **AND** a roster store opened afterwards at that place holds "Gym" due on Monday 19 October 2026 and
  on none of Friday 16, Saturday 17 and Sunday 18 October 2026
- **AND** once "Mallorca" is removed through that screen, the removal confirmed, one holds "Gym" due on
  Tuesday 13, Wednesday 14, Friday 16 and Monday 19 October 2026, and not on Thursday 15 October 2026

#### Scenario: a commitment taken up again inside days away stays picked through a later change moving their first day past its stop

- **WHEN** commitments named "Gym", "Run" and "Yoga", each on a schedule listing all seven weekdays and
  kept from 1 January 2026, are taken on at a roster place; days away named "Mallorca" from Tuesday 13
  through Sunday 18 October 2026 over "Gym" and "Run", and days away named "Lisbon" over those days
  over "Yoga" alone, are said through a commitments screen opened at that roster place as of Monday
  12 October 2026; "Gym" and "Yoga" are stopped, each stop confirmed, through one opened there as of
  Thursday 15 October 2026; and through one opened there as of Friday 16 October 2026 "Gym" and
  "Yoga" are taken up again, "Mallorca" is changed to run from Saturday 17 through Sunday 18 October
  2026 over "Gym" and "Run", and "Lisbon" is changed to those days over "Yoga"
- **THEN** nothing is refused, and that screen lists "Mallorca", "Sat 17 Oct – Sun 18 Oct", over "Gym"
  and "Run", and "Lisbon", "Sat 17 Oct – Sun 18 Oct", over "Yoga"
- **AND** a roster store opened afterwards at that place holds "Gym" and "Yoga" each due on Tuesday 13,
  Wednesday 14, Friday 16 and Monday 19 October 2026, and on none of Thursday 15, Saturday 17 and
  Sunday 18 October 2026

#### Scenario: days away whose first day moved past the stop of a commitment taken up again inside them, removed, leave it owing no day between its stop and its take-up

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Mallorca" from
  Tuesday 13 through Sunday 18 October 2026 are said over both through a commitments screen opened at
  that roster place as of Monday 12 October 2026; "Gym" is stopped, the stop confirmed, through one
  opened there as of Thursday 15 October 2026; and through one opened there as of Friday 16 October
  2026 "Gym" is taken up again, "Mallorca" is changed to run from Saturday 17 through Sunday
  18 October 2026 over both, and "Mallorca" is removed, the removal confirmed
- **THEN** nothing is refused, and that screen lists no days away
- **AND** a roster store opened afterwards at that place holds "Gym" due on Tuesday 13, Wednesday 14,
  Friday 16 and Monday 19 October 2026 and not on Thursday 15 October 2026, and "Run" due on Thursday
  15 and Saturday 17 October 2026

#### Scenario: days away whose first day moved past the stop of a commitment taken up again inside them, moved back over it and removed, leave it owing no day between its stop and its take-up

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Mallorca" from
  Tuesday 13 through Sunday 18 October 2026 are said over both through a commitments screen opened at
  that roster place as of Monday 12 October 2026; "Gym" is stopped, the stop confirmed, through one
  opened there as of Thursday 15 October 2026; and through one opened there as of Friday 16 October
  2026 "Gym" is taken up again, "Mallorca" is changed to run from Saturday 17 through Sunday
  18 October 2026 over both, then to begin on Thursday 15 October 2026, and is then removed, the
  removal confirmed
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place holds "Gym" due on Tuesday 13, Wednesday 14,
  Friday 16 and Monday 19 October 2026, and not on Thursday 15 October 2026

#### Scenario: days away moved to end before a take-up made inside them leave the days between its stop and its take-up owing nothing

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Mallorca" from
  Tuesday 13 through Sunday 18 October 2026 are said over both through a commitments screen opened at
  that roster place as of Monday 12 October 2026; "Gym" is stopped, the stop confirmed, through one
  opened there as of Wednesday 14 October 2026, and taken up again through one opened there as of
  Saturday 17 October 2026; and through that Saturday screen "Mallorca" is changed to end on Thursday
  15 October 2026, and then to end on Tuesday 20 October 2026
- **THEN** neither is refused
- **AND** after the first, a roster store opened at that place holds "Gym" due on Saturday 17 and Sunday
  18 October 2026 and on none of Wednesday 14, Thursday 15 and Friday 16 October 2026, and "Run" due on
  Friday 16 October 2026
- **AND** after the second, one holds "Gym" due on Wednesday 21 October 2026 and on none of Saturday 17
  through Tuesday 20 October 2026

#### Scenario: days away moved past a later stop of a commitment taken up again inside them, and back again, give it back the days between its take-up and that stop

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Mallorca" from
  Tuesday 13 through Sunday 18 October 2026 are said over both through a commitments screen opened at
  that roster place as of Monday 12 October 2026; "Gym" is stopped, the stop confirmed, through one
  opened there as of Thursday 15 October 2026; through one opened there as of Friday 16 October 2026
  "Gym" is taken up again and "Mallorca" is changed to run from Saturday 17 through Sunday 18 October
  2026 over both; "Gym" is stopped again, the stop confirmed, through one opened there as of Sunday
  25 October 2026; and through one opened there as of Monday 26 October 2026 "Mallorca" is changed to
  end on Friday 30 October 2026 over both, and then to end on Sunday 18 October 2026 over both
- **THEN** neither change is refused
- **AND** after the first, a roster store opened at that place holds "Gym" due on Wednesday 14 and
  Friday 16 October 2026 and on none of Saturday 17, Monday 19 and Saturday 24 October 2026
- **AND** after the second, that screen lists "Mallorca" as past over "Gym" and "Run", and one holds
  "Gym" due on Wednesday 14, Friday 16, Monday 19 and Saturday 24 October 2026 and on none of Thursday
  15, Sunday 18 and Sunday 25 October 2026

#### Scenario: days away renamed leave the take-up of a commitment taken up again inside them where it was

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Mallorca" from
  Tuesday 13 through Sunday 18 October 2026 are said over both through a commitments screen opened at
  that roster place as of Monday 12 October 2026; "Gym" is stopped, the stop confirmed, through one
  opened there as of Thursday 15 October 2026; and through one opened there as of Friday 16 October
  2026 "Gym" is taken up again and "Mallorca" is changed to the name "Majorca", from Tuesday 13
  through Sunday 18 October 2026, over both
- **THEN** nothing is refused, and that screen lists "Majorca" over "Gym" and "Run"
- **AND** a roster store opened afterwards at that place holds "Gym" due on Monday 19 October 2026 and
  on none of Tuesday 13 through Sunday 18 October 2026

#### Scenario: a commitment taken up again inside days away and then unticked from them owes its days up to its stop and from its take-up

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Mallorca" from
  Tuesday 13 through Sunday 18 October 2026 are said over both through a commitments screen opened at
  that roster place as of Monday 12 October 2026; "Gym" is stopped, the stop confirmed, through one
  opened there as of Thursday 15 October 2026; and through one opened there as of Friday 16 October
  2026 "Gym" is taken up again and "Mallorca" is changed over "Run" alone
- **THEN** nothing is refused, and that screen lists "Mallorca" over "Run" alone
- **AND** a roster store opened afterwards at that place holds "Gym" due on Tuesday 13, Wednesday 14,
  Friday 16 and Monday 19 October 2026, and not on Thursday 15 October 2026

#### Scenario: days away moved to end before the stop of a commitment taken up again inside them leave its take-up on the day it was made

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Mallorca" from
  Tuesday 13 through Sunday 18 October 2026 are said over both through a commitments screen opened at
  that roster place as of Monday 12 October 2026; "Gym" is stopped, the stop confirmed, through one
  opened there as of Thursday 15 October 2026; and through one opened there as of Friday 16 October
  2026 "Gym" is taken up again and "Mallorca" is changed to end on Tuesday 13 October 2026 over both
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place holds "Gym" due on Wednesday 14, Friday 16 and
  Monday 19 October 2026, and on neither Tuesday 13 nor Thursday 15 October 2026

#### Scenario: days away moved off a stop and take-up made inside them, and back over them, leave both where they were made

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Mallorca" from
  Tuesday 13 through Sunday 18 October 2026 are said over both through a commitments screen opened at
  that roster place as of Monday 12 October 2026; "Gym" is stopped, the stop confirmed, through one
  opened there as of Thursday 15 October 2026; and through one opened there as of Friday 16 October
  2026 "Gym" is taken up again, "Mallorca" is changed to run from Monday 5 through Saturday 10 October
  2026 over both, then to run from Tuesday 13 through Sunday 18 October 2026 over both, and then to
  end on Tuesday 20 October 2026 over both
- **THEN** nothing is refused
- **AND** after the first change, a roster store opened at that place holds "Gym" due on Sunday 11,
  Wednesday 14, Friday 16 and Monday 19 October 2026, and on none of Monday 5, Saturday 10 and
  Thursday 15 October 2026
- **AND** after the third, one holds "Gym" due on Wednesday 21 October 2026 and on none of Thursday
  15 through Tuesday 20 October 2026
- **AND** once "Mallorca" is removed through that Friday screen, the removal confirmed, one holds "Gym"
  due on Tuesday 13, Wednesday 14, Friday 16 and Wednesday 21 October 2026, and not on Thursday
  15 October 2026

#### Scenario: days away moved past the take-up of a commitment taken up again inside them leave it owing the same days whether moved in one change or two

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at each of two roster places; at each, days away named
  "Mallorca" from Tuesday 13 through Sunday 18 October 2026 are said over both through a commitments
  screen opened there as of Monday 12 October 2026, "Gym" is stopped, the stop confirmed, through one
  opened there as of Thursday 15 October 2026, and "Gym" is taken up again through one opened there as
  of Friday 16 October 2026; and through that Friday screen "Mallorca" is changed at the first to run
  from Tuesday 20 through Sunday 25 October 2026 over both, and at the second to end on Sunday
  25 October 2026 over both and then to begin on Tuesday 20 October 2026 over both
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at each place holds "Gym" due on Tuesday 13, Wednesday 14,
  Friday 16, Monday 19 and Monday 26 October 2026, and on none of Thursday 15 and Tuesday 20 through
  Sunday 25 October 2026

### Requirement: Every roster a commitments screen keeps is one a roster store reads

Every roster a commitments screen keeps at its roster place SHALL be read without error by a roster
store opened there afterwards, whatever sequence of days away said, changed or removed, commitments
stopped, taken up again, changed or deleted, and copies restored, through commitments screens opened
as of any days, made it. No stop, take-up or change of a commitment confirmed through a commitments
screen SHALL be refused for days away over it.

#### Scenario: a commitment stopped, taken up again and stopped again around days away over it leaves a roster a roster store reads, and stays over them through a later change

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at each of three roster places; at the first, days away
  named "Mallorca" from Tuesday 13 through Sunday 18 October 2026 are said over both through a
  commitments screen opened there as of Monday 12 October 2026, "Gym" is stopped, the stop confirmed,
  through one opened there as of Thursday 15 October 2026, "Gym" is taken up again and "Mallorca" is
  changed to run from Saturday 17 through Sunday 18 October 2026 over both through one opened there as
  of Friday 16 October 2026, and "Gym" is stopped, the stop confirmed, through one opened there as of
  Sunday 25 October 2026; at the second, days away named "Flu" from Thursday 1 through Saturday
  3 October 2026 are said over both through one opened there as of Thursday 1 October 2026, "Gym" is
  stopped, the stop confirmed, through one opened there as of Monday 5 October 2026, "Flu" is changed
  to end on Wednesday 7 October 2026, "Gym" is taken up again and "Flu" is changed to begin on Tuesday
  6 October 2026 through one opened there as of Monday 12 October 2026, and "Gym" is stopped, the stop
  confirmed, through one opened there as of Tuesday 20 October 2026; and at the third, "Mallorca" is
  said as at the first, and "Gym" is stopped, the stop confirmed, taken up again, and stopped again,
  the stop confirmed, through one opened there as of Thursday 15 October 2026
- **THEN** nothing is refused, and a roster store opened at each place afterwards opens without error
- **AND** a commitments screen opened at the first as of Monday 26 October 2026 lists "Mallorca" as
  past over "Gym" and "Run", and "Gym" as stopped; and "Mallorca" changed through it to the name
  "Majorca", from Saturday 17 through Sunday 18 October 2026, over both, is not refused and is listed
  over "Gym" and "Run"
- **AND** once "Mallorca" is removed at the third through that Thursday screen, the removal
  confirmed, a roster store opened there holds "Gym" due on Tuesday 13 and Wednesday 14 October 2026
  and on neither Thursday 15 nor Monday 19 October 2026

### Requirement: A commitments screen refuses days away ending before they begin, over nothing, or clashing with what it holds, and keeps nothing of them

A commitments screen SHALL refuse days away whose last day is before their first, or that are over no
commitment. It SHALL refuse days away over a
commitment other days away it holds are over on a shared day, naming those, and SHALL NOT refuse days
away sharing days with others over no commitment in common. It SHALL refuse days away over a
commitment kept from their first day or later, or holding a shift with a day among theirs, naming that
commitment. Days away it cannot keep at the roster place, or asked of it while it cannot read its
roster, SHALL be refused as a roster that could not be written. A refusal SHALL keep nothing and leave
its lists as they were. Asked over a commitment it does not keep, it SHALL do nothing and say
nothing.

#### Scenario: days away ending before they begin, or over nothing, are refused and keep nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 12 October 2026; the content at that place is read; and days away from Wednesday 14 through
  Tuesday 13 October 2026 over "Gym", and from Tuesday 13 through Sunday 18 October 2026 over
  nothing, are said through it
- **THEN** the first is refused as a last day before the first and the second as days away over
  nothing
- **AND** it lists no days away, and the content at that place is byte-for-byte what was read

#### Scenario: days away over a commitment other days away are over on a shared day are refused, naming those days away

- **WHEN** commitments named "Gym", "Run" and "Creatine" on schedules listing all seven weekdays,
  kept from 1 January 2026, are taken on at a roster place; a commitments screen is opened at that
  roster place as of Monday 12 October 2026; days away named "Mallorca" from Tuesday 13 through
  Sunday 18 October 2026 are said through it over "Gym" and "Run"; and days away from Saturday 17
  through Tuesday 20 October 2026 are said through it over "Run" and "Creatine"
- **THEN** they are refused as overlapping days away, naming "Mallorca"
- **AND** the same days said over "Creatine" alone are not refused, nor are days away from Monday 19
  through Tuesday 20 October 2026 said over "Gym"

#### Scenario: days away over a commitment kept from their first day or later are refused, naming it

- **WHEN** a commitment named "Yoga" kept from Wednesday 14 October 2026 and one named "Pilates" kept
  from Tuesday 13 October 2026, both on schedules listing all seven weekdays, are taken on at a
  roster place; a commitments screen is opened at that roster place as of Monday 12 October 2026; and
  days away from Tuesday 13 through Sunday 18 October 2026 are said through it over "Yoga", and then
  over "Pilates"
- **THEN** the first is refused as over a commitment kept from a later day, naming "Yoga", and the
  second likewise, naming "Pilates"
- **AND** it lists no days away

#### Scenario: days away over a commitment with a shift on one of their days are refused, naming it

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; its due day on Monday 12 October 2026 is shifted
  there to Tuesday 13 October 2026; a commitments screen is opened at that roster place as of Monday
  12 October 2026; and days away from Tuesday 13 through Sunday 18 October 2026 are said through it
  over "Gym"
- **THEN** they are refused as over a commitment with a shift on one of their days, naming "Gym"
- **AND** days away from Wednesday 14 through Sunday 18 October 2026 said over "Gym" are not refused

#### Scenario: days away a commitments screen cannot keep at its roster place are refused

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 12 October 2026; what is at that place is then made impossible to write; and days away from
  Tuesday 13 through Sunday 18 October 2026 are said through it over "Gym"
- **THEN** they are refused as a roster that could not be written, and it lists no days away
- **AND** a commitments screen opened as of that day at a roster place holding a run of bytes that is
  not what a roster is written as refuses days away said through it the same way

#### Scenario: a commitments screen asked to say days away over a commitment it does not keep does nothing

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place, and "Run" is stopped there as of
  Sunday 11 October 2026; a commitments screen is opened at that roster place as of Monday 12 October
  2026; and days away from Tuesday 13 through Sunday 18 October 2026 are said through it over "Gym"
  and "Run"
- **THEN** nothing is refused and it lists no days away
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

### Requirement: A commitments screen lists every days away, those not over earliest first and past ones apart, latest first

A commitments screen SHALL list every days away its roster holds, in two lists. The first SHALL hold
those whose last day is the day it was handed or a later one, in the order of their first days, days
away sharing a first day in the order they were said; the second, apart from them, those whose last
day has passed, by first day latest first, days away sharing a first day the last said first. Each SHALL say its name, or "Away" where it has none; its days in words, each as its weekday, its day and its
month's three letters, "Tue 13 Oct – Sun 18 Oct", one day said once, "Tue 20 Oct"; and the
commitments it is over, under the names they now carry, in the order the roster holds them. A
commitments screen that cannot read its roster SHALL list none.

#### Scenario: a commitments screen lists days away by name or Away, with their days in words and their commitments, earliest first

- **WHEN** commitments named "Gym", "Run" and "Creatine" on schedules listing all seven weekdays,
  kept from 1 January 2026, are taken on at a roster place; a commitments screen is opened at that
  roster place as of Monday 12 October 2026; days away with no name from Tuesday 20 through Tuesday
  20 October 2026 over "Creatine", then days away named "Mallorca" from Tuesday 13 through Sunday
  18 October 2026 over "Run" and "Gym", then days away named "Lisbon" from Tuesday 13 through
  Wednesday 14 October 2026 over "Creatine" are said through it; and "Gym" is renamed through it
  "Gym 🏋️"
- **THEN** it lists three days away: "Mallorca", "Tue 13 Oct – Sun 18 Oct", over "Gym 🏋️" and "Run";
  then "Lisbon", "Tue 13 Oct – Wed 14 Oct", over "Creatine"; then "Away", "Tue 20 Oct", over
  "Creatine"
- **AND** it lists none as past

#### Scenario: days away move to the past list once their last day has passed, latest first, and stay at the roster place

- **WHEN** commitments named "Gym" and "Creatine" on schedules listing all seven weekdays, kept from
  1 January 2026, are taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 12 October 2026; days away named "Mallorca" from Tuesday 13 through Sunday 18 October
  2026 over "Gym" and days away from Tuesday 20 through Tuesday 20 October 2026 over "Creatine" are
  said through it; and the app is shown again as of Sunday 18 October 2026
- **THEN** it lists both, and none as past
- **AND** shown again as of Monday 19 October 2026 it lists the one of Tuesday 20 October 2026 alone,
  and "Mallorca" as past
- **AND** shown again as of Wednesday 21 October 2026, and days away named "Flu" from Tuesday 13
  through Wednesday 14 October 2026 then said through it over "Creatine", it lists none, and as past
  "Away", "Flu" and "Mallorca" in that order
- **AND** a roster store opened afterwards at that place holds all three days away

#### Scenario: a commitments screen that cannot read its roster lists no days away

- **WHEN** a commitments screen is opened as of Monday 12 October 2026 at a roster place holding a run
  of bytes that is not what a roster is written as
- **THEN** it lists no days away, none as past, and says the roster could not be read

### Requirement: A commitments screen asks before it removes days away, and removes any it lists as though they had never been said

A commitments screen SHALL offer removing every days away it lists, and SHALL remove them only once
asked and confirmed. Being asked SHALL change nothing but hold which days away await removal,
replacing any change awaiting confirmation; being asked to stop or delete a commitment SHALL leave
none awaiting removal. A cancel, and an ask about days away it does not list, SHALL change nothing.
A confirmed removal SHALL be kept at the roster place before the list says so, and SHALL leave each
commitment they were over as though never said: past days and a day holding a record included, an
every-N-days count running on through their days, and every stop, take-up and change of it standing
from the day it was made. A removal the roster place cannot keep SHALL be refused as a roster that
could not be written, still listed.

#### Scenario: asking to remove days away changes nothing until it is confirmed, and a cancel changes nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 12 October 2026; days away named "Mallorca" from Tuesday 13 through Sunday 18 October 2026
  are said through it over "Gym"; the content at that place is read; and it is asked to remove them
- **THEN** it offers removing them, "Mallorca" awaits removal, and it still lists "Mallorca"
- **AND** once the removal is cancelled nothing awaits removal, it still lists "Mallorca", and the
  content at that place is byte-for-byte what was read

#### Scenario: days away removed before they begin leave their commitments as though never said

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, and one named "Nails" on a schedule of every 4 days starting on Thursday 1 October 2026, kept
  from that day, are taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 12 October 2026; days away named "Mallorca" from Tuesday 13 through Sunday 18 October
  2026 are said through it over both; and it is asked to remove them and the removal is confirmed
- **THEN** nothing is refused and it lists no days away
- **AND** a roster store opened afterwards at that place holds "Gym" due on Thursday 15 October 2026,
  and "Nails" due on Tuesday 13, Saturday 17 and Wednesday 21 October 2026 and not on Monday 19
  October 2026

#### Scenario: days away under way or past are offered for removal, and removed leave their days owed again and open to a record

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; a commitments screen is opened at that
  roster place and a record place where nothing has been kept, as of Monday 12 October 2026; days away
  from Monday 12 through Wednesday 14 October 2026 over "Gym", and days away named "Sick" from Monday
  5 through Wednesday 7 October 2026 over "Run", are said through it; and each is asked to be removed
  through it and the removal confirmed
- **THEN** it offers removing both before either is asked, neither removal is refused, and it lists
  no days away
- **AND** asked again to remove the first, nothing awaits removal
- **AND** a day screen opened at those places as of Tuesday 6 October 2026 holds rows named "Gym" and
  "Run", neither saying it is kept, and the row named "Run" ticked there is kept at the record place;
  one opened as of Monday 12 October 2026 holds both

#### Scenario: days away begun on a first day a commitment was kept through are removed whole

- **WHEN** a commitment named "Creatine" and one named "Magnesium", both on schedules listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; a tick for "Creatine"
  on Monday 12 October 2026 is kept at a record place; days away from that Monday through Wednesday
  14 October 2026 are said over both through a commitments screen opened at those places as of that
  Monday; and they are removed, the removal confirmed, through one opened there as of Tuesday
  13 October 2026
- **THEN** nothing is refused and it lists no days away
- **AND** a roster store opened afterwards at that place holds "Creatine" and "Magnesium" each due on
  Tuesday 13 and Wednesday 14 October 2026
- **AND** a day screen opened at those places as of Monday 12 October 2026 holds rows named "Creatine",
  saying it is kept, and "Magnesium"

#### Scenario: a commitments screen awaits one removal, stop or deletion at a time

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; a commitments screen is opened at that
  roster place as of Monday 12 October 2026; days away named "Mallorca" from Tuesday 13 through Sunday
  18 October 2026 are said through it over "Gym"; it is asked to stop keeping "Run"; and it is then
  asked to remove "Mallorca"
- **THEN** "Mallorca" awaits removal and nothing awaits confirmation of a stop
- **AND** once it is asked to delete "Run", nothing awaits removal and "Run" awaits deletion

#### Scenario: days away removed beside other days away over the same commitment leave the other's gap where it was

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 12 October 2026; days away named "Mallorca" from Tuesday 13 through Sunday 18 October 2026
  and days away named "Lisbon" from Monday 19 through Wednesday 21 October 2026 are said through it
  over "Gym"; and "Mallorca" is removed through it, the removal confirmed
- **THEN** it lists "Lisbon" alone
- **AND** a roster store opened afterwards at that place holds "Gym" due on Thursday 15 and Thursday
  22 October 2026, and not on Monday 19 or Wednesday 21 October 2026

#### Scenario: days away removed after a change of rhythm leave that change standing from the day it was made

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 12 October 2026; days away named "Mallorca" from Tuesday 13 through Sunday 18 October
  2026 are said through it over "Gym"; "Gym" is changed through it to a schedule listing all seven
  weekdays; and "Mallorca" is removed through it, the removal confirmed
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place holds "Gym" due on every day from Monday
  12 October 2026 on, Tuesday 13 and Thursday 15 October 2026 included, and due on Saturday 10 and
  not on Friday 9 October 2026

#### Scenario: a removal a commitments screen cannot keep at its roster place is refused and the days away stay listed

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 12 October 2026; days away named "Mallorca" from Tuesday 13 through Sunday 18 October 2026
  are said through it over "Gym"; what is at that place is then made impossible to write; and
  "Mallorca" is removed through it, the removal confirmed
- **THEN** it is refused as a roster that could not be written
- **AND** it still lists "Mallorca"

### Requirement: A stop through a commitments screen takes a commitment out of days away not begun and leaves it in those begun, a deletion out of every days away, and days away left over none go

A stop confirmed through a commitments screen SHALL take the commitment out of every days away it is
over whose first day is after the day the screen was handed. Days away begun, under way or past, SHALL
keep it, and the stop SHALL be kept on the day it was made, as on any other day. A deletion confirmed
through it SHALL take the commitment out of every days away it is over, those whose last day has
passed included. Days away a stop or a deletion leaves over no commitment SHALL go from the roster.
What a stop or a deletion does to days away SHALL be kept at the roster place with it, before either
list says so.

#### Scenario: a commitment stopped before its days away begin leaves them, and they stay over the others

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; a commitments screen is opened at that
  roster place as of Monday 12 October 2026; days away named "Mallorca" from Tuesday 13 through Sunday
  18 October 2026 are said through it over both; and "Gym" is stopped through it, the stop confirmed
- **THEN** nothing is refused
- **AND** it lists "Mallorca" over "Run" alone
- **AND** what it has stopped is one entry, named "Gym", and a roster store opened afterwards at that
  place answers with "Gym" when asked what it had not stopped keeping on Sunday 11 October 2026 and
  not on Monday 12 October 2026

#### Scenario: a commitment stopped while its days away are under way stays in them, stopped on the day it was made

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Mallorca" from
  Tuesday 13 through Sunday 18 October 2026 are said over both through a commitments screen opened
  at that roster place as of Monday 12 October 2026; and "Gym" is stopped, the stop confirmed, through
  a commitments screen opened there as of Thursday 15 October 2026
- **THEN** nothing is refused, and that screen lists "Mallorca" over "Gym" and "Run"
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had not
  stopped keeping on Wednesday 14 October 2026 and not on Thursday 15 October 2026, and holds "Gym" due
  on none of Tuesday 13 through Monday 19 October 2026
- **AND** once "Mallorca" is removed through that screen, the removal confirmed, one holds "Gym" due on
  Tuesday 13 and Wednesday 14 October 2026 and not on Thursday 15 October 2026

#### Scenario: days away a stop leaves over no commitment go from the roster

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 12 October 2026; days away named "Mallorca" from Tuesday 13 through Sunday 18 October 2026
  are said through it over "Gym"; and "Gym" is stopped through it, the stop confirmed
- **THEN** it lists no days away
- **AND** a roster store opened afterwards at that place holds no days away

#### Scenario: a deletion takes a commitment out of its days away, past ones included, and days away left over none go

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Flu" from Thursday
  1 through Saturday 3 October 2026 are said over "Gym" through a commitments screen opened at that
  roster place as of Thursday 1 October 2026; days away named "Mallorca" from Tuesday 13 through
  Sunday 18 October 2026 are said over both through one opened there as of Monday 12 October 2026;
  and "Gym" is deleted through that second screen, its name typed back
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place holds one days away, "Mallorca", over "Run"

#### Scenario: a stopped commitment stays in days away already past

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; days away named "Flu" from Thursday 1 through Saturday
  3 October 2026 are said over "Gym" through a commitments screen opened at that roster place as of
  Thursday 1 October 2026; and "Gym" is stopped, the stop confirmed, through one opened there as of
  Monday 12 October 2026
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place holds one days away, "Flu", over "Gym"

### Requirement: A roster reads a commitment's due days and free days for a shift as days away over it leave them

For every shift a roster is asked for, whatever the rhythm, a commitment's due days and free days
SHALL be those its eras give once days away over it are laid over them, as *Days away hide the days
they are over from each commitment they are over, and leave its eras as they are* says: a day those
days away hide SHALL be neither a due day nor a free day, and an every-N-days era SHALL be counted
again from the day after them. A shift asked from or onto a day so read as neither SHALL be refused,
changing nothing.

#### Scenario: a roster refuses to shift a weekday-set due day onto, or from, a day days away hide

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; days away from Tuesday 13 through Sunday 18 October
  2026 are said over it through a commitments screen opened at that roster place as of Monday
  12 October 2026; and a roster store opened afterwards at that place is asked to shift its due day on
  Monday 12 October 2026 to Tuesday 13 October 2026, its day Wednesday 14 October 2026 to Tuesday
  13 October 2026, and its due day on Saturday 10 October 2026 to Sunday 11 October 2026
- **THEN** it refuses the first two and shifts the third
- **AND** the commitment it holds is due on Monday 12 and Sunday 11 October 2026 and not on Saturday
  10 October 2026

#### Scenario: a roster shifts an every-N-days due day after days away on the count begun again the day after them

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 1 October
  2026, kept from that day, is taken on at a roster place; days away from Tuesday 20 through Sunday
  25 October 2026 are said over it through a commitments screen opened at that roster place as of
  Monday 12 October 2026; and a roster store opened afterwards at that place is asked to shift its day
  Thursday 29 October 2026 to Wednesday 28 October 2026, and then its due day on Friday 30 October
  2026 to Saturday 31 October 2026
- **THEN** it refuses the first and shifts the second
- **AND** the commitment it holds is due on Monday 26 and Saturday 31 October and Wednesday 4 November
  2026, and on none of Thursday 29 and Friday 30 October and Tuesday 3 November 2026

### Requirement: A roster store reads a roster kept while days away cut gaps into eras with those eras as written

A roster store SHALL read a roster written in the form before days away were laid over eras with
every era of every commitment exactly as written and its days away laid over them, as over any eras.
A gap such days away cut SHALL be read as the stop and take-up it is written as, and removing or
changing those days away SHALL NOT give back its days. Reading it MUST NOT change what is at its
place, and the next roster written there SHALL be in the form written now.

#### Scenario: a roster kept while days away cut gaps into eras is read with those eras as written, and removing those days away gives back none of their days

- **WHEN** a roster store is opened at a place holding a roster written in the form used before days
  away were laid over eras, whose one commitment is named "Gym", on a schedule listing all seven
  weekdays, kept from 1 January 2026 until Monday 12 October 2026 and again from Monday 19 October
  2026, and whose one days away, named "Mallorca", run from Tuesday 13 through Sunday 18 October 2026
  over "Gym"
- **THEN** it opens without error, holding two eras of "Gym" and "Mallorca" over it, and the content at
  that place is byte-for-byte what it was before the store was opened
- **AND** once "Mallorca" is removed through a commitments screen opened there as of Monday 12 October
  2026, the removal confirmed, a roster store opened there holds "Gym" due on Monday 12 and Monday
  19 October 2026 and on none of Tuesday 13 through Sunday 18 October 2026

## REMOVED Requirements

### Requirement: A commitments screen says days away over the commitments it keeps that are picked, each taking a gap over them

**Reason**: Days away no longer cut a gap into the eras; carried as *A commitments screen says days away over the commitments it keeps that are picked, hiding their days*, the record scenario rewritten under *Days away hide the days they are over from each commitment they are over, and leave its eras as they are*.
**Migration**: None on disk.

### Requirement: A commitments screen refuses days away it cannot say, naming what they clash with, and keeps nothing of them

**Reason**: Days away may now begin on a day already gone; the requirement is carried whole, without that refusal, as *A commitments screen refuses days away ending before they begin, over nothing, or clashing with what it holds, and keeps nothing of them*.
**Migration**: None on disk.

### Requirement: A commitments screen lists the days away whose last day has not passed, earliest first, each with the commitments it is over

**Reason**: Past days away are now listed apart rather than dropped; carried as *A commitments screen lists every days away, those not over earliest first and past ones apart, latest first*.
**Migration**: None on disk.

### Requirement: A commitments screen asks before it removes days away, and removes only days away not yet begun, as though they had never been said

**Reason**: Any listed days away can now be removed; carried as *A commitments screen asks before it removes days away, and removes any it lists as though they had never been said*.
**Migration**: None on disk.

### Requirement: A stop or a deletion through a commitments screen takes a commitment out of its days away, and days away left over none go

**Reason**: Days away begun keep a commitment stopped while they are under way; carried as *A stop through a commitments screen takes a commitment out of days away not begun and leaves it in those begun, a deletion out of every days away, and days away left over none go*.
**Migration**: None on disk.

### Requirement: A change through a commitments screen keeps a commitment's days away

**Reason**: A change made while away now holds from the day it was made; carried as *A change through a commitments screen keeps a commitment's days away and puts its era on from the day handed, inside them or not*.
**Migration**: None on disk.

## MODIFIED Requirements

### Requirement: A commitments screen changes a commitment by renaming it, moving the day it is kept from, putting a new era on it, or declaring its usual amounts

A commitments screen SHALL change a commitment on either of its lists from six things and no others
— a name, a rhythm, the day it is kept from, the category, which may be none, the range or the
target its kind has room for, and the usual amounts a total declares — and SHALL work out from them
which acts the change needs, doing each it needs and no other, at the roster place alone. A
different name SHALL rename the commitment through every era of it. A different day kept from SHALL
change the commitment's earliest era for one kept from that day. A different rhythm, range or target
SHALL put a new era on the commitment, kept from the day the screen was handed — or from the day the
commitment is kept from, where that is later, whether or not days away hide that day, as *A change
through a commitments screen keeps a commitment's days away and puts its era on from the day handed,
inside them or not* says — with the era it
gives way to kept until the day before; the name and the day kept from the change names SHALL
already have been written by the two acts above, so one save SHALL rename first, move the day second
and put the era on third. A different category SHALL be written by whichever act runs, and by a put
where none does. Different usual amounts SHALL be declared on every era the save leaves, and SHALL
put no era on.

No change SHALL move a record, and nothing SHALL be written at the record place by any of them: a
record is a record of the commitment, which a rename, a moved day and a new era all leave standing.
Every past day SHALL go on answering about the commitment it answered about, under whatever name it
now carries and against whichever era holds that day.

On an interval rhythm the day kept from is also the rhythm's start date, so a change naming a
different day SHALL form the earliest era's schedule from that day and the days it was due on before
are not the days it is due on after; on the other three, dueness does not depend on that day, so
moving it earlier only widens the window and every day already recorded on SHALL stay due. A day
kept from moved forward past the day an era gives way SHALL drop every era it would leave holding no
day, and the earliest surviving era SHALL be kept from that day.

Which of the four kinds its days take is not one of the six and SHALL NOT change: every era SHALL be
of the kind the commitment is of. The range a number kind carries and the target a total kind
carries SHALL be what the change names, a range named where the commitment carried none and none
named where it carried one alike, and only the era put on SHALL carry the new one. A range or a
target named for a kind that has no room for it SHALL be ignored. A commitment its roster has
stopped keeping SHALL be changed in name, category and usual amounts only, and SHALL stay stopped on
the day it was kept until. Where the six things name what is already there — the usual amounts it
already declares, in whatever order — and the category it is already under, the screen SHALL change
nothing, SHALL write nothing at either place and SHALL refuse nothing.

#### Scenario: a commitment renamed through a commitments screen is drawn under its new name, in the place it held

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; a commitments screen is opened at that roster place as of Monday 31 August 2026; and "Gym"
  is changed through it to the name "Gym 🏋️", on the rhythm and the day kept from it already has,
  under no category
- **THEN** nothing is refused
- **AND** what it keeps is three entries, named "Water plants", then "Gym 🏋️", then "Journaling"
- **AND** a roster store opened afterwards at that place holds those three commitments in that order

#### Scenario: a renamed commitment keeps every record already made, and the record place is not written

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of
  Monday 31 August 2026; the content at that record place is read; and "Gym" is changed through it
  to the name "Gym 🏋️", on the rhythm and the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** a look-back at "Gym 🏋️" counts Monday 3 August 2026 kept
- **AND** the content at that record place is byte-for-byte what was read before the change

#### Scenario: a rename through a commitments screen reaches every era of the commitment

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, under no category; and it is then changed to the name "Lifting", on the rhythm and the
  day kept from it now has
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with
  "Lifting" on Monday, Wednesday and Saturday, and about Monday 31 August 2026 with "Lifting" on
  Tuesday and Thursday
- **AND** a look-back at "Lifting" says the name "Lifting" and the day kept from "1 January 2026"

#### Scenario: a commitment whose rhythm is changed through a commitments screen is given a new era from today

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, on the name and the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** what it keeps is one entry, named "Gym", saying "Tue, Thu"
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with the
  era on Monday, Wednesday and Saturday and about Monday 31 August 2026 with the era on Tuesday and
  Thursday
- **AND** what it has stopped is nothing, and what the screen says "Gym" is made of says the day kept
  from 1 January 2026

#### Scenario: a rhythm changed through a commitments screen leaves every record already made standing

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of
  Monday 31 August 2026; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, under no category
- **THEN** nothing is refused
- **AND** a look-back at "Gym" counts Monday 3 August 2026 kept
- **AND** the content at that record place is byte-for-byte what it was before the change

#### Scenario: a name and a rhythm changed in one save put the new name on every era

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️" on a weekday-set
  rhythm of Tuesday and Thursday, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with
  "Gym 🏋️" on Monday, Wednesday and Saturday, and about Monday 31 August 2026 with "Gym 🏋️" on
  Tuesday and Thursday
- **AND** what the screen keeps is one entry, named "Gym 🏋️", saying "Tue, Thu"

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

#### Scenario: the day a commitment is kept from is moved onto a later era and the eras it leaves no day for are dropped

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 June 2026,
  is taken on at a roster place; a commitments screen is opened at that roster place as of Monday
  31 August 2026; "Gym" is changed through it to a weekday-set rhythm of Tuesday and Thursday, under
  no category; and "Gym" is then changed to the day kept from Monday 31 August 2026, on the name and
  the rhythm it now has
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place reads back one era of "Gym", on Tuesday and
  Thursday, kept from Monday 31 August 2026
- **AND** it says nothing about Sunday 30 August 2026, which "Gym" is not due on

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

#### Scenario: a rhythm changed on the first date the calendar supports puts the new era on as of that day itself

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 1583, is taken on at a roster place; a commitments screen is opened at that roster place
  as of 1 January 1583; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place reads back one era of "Gym", on Tuesday and
  Thursday, kept from 1 January 1583, and answers about 1 January 1583 with that era alone

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

#### Scenario: a name, an earlier day kept from and a rhythm changed in one save reach every era

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 August 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  and at a record place where nothing has been kept as of Monday 31 August 2026; and "Gym" is
  changed through it to the name "Gym 🏋️", on a weekday-set rhythm of Tuesday and Thursday, kept
  from 1 June 2026, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with
  "Gym 🏋️" on Monday, Wednesday and Saturday, kept from 1 June 2026, and about Monday 31 August
  2026 with "Gym 🏋️" on Tuesday and Thursday, kept from 31 August 2026
- **AND** what the screen keeps is one entry, named "Gym 🏋️", saying "Tue, Thu", and what it says
  that commitment is made of says the day kept from 1 June 2026

#### Scenario: a change writes nothing at the record place, whatever it changes

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a record
  place; a commitments screen is opened at that roster place and that record place as of Monday
  31 August 2026; the content at that record place is read; and "Gym" is changed through it three
  times — to the name "Gym 🏋️", then to the day kept from 1 June 2026, then to a weekday-set rhythm
  of Tuesday and Thursday
- **THEN** nothing is refused
- **AND** the content at that record place is byte-for-byte what was read before the first change

#### Scenario: a change of rhythm through a commitments screen puts the commitment under the category it was given

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, under the category "Sport", is taken on at a roster place; a commitments screen is
  opened at that roster place and at a record place where nothing has been kept as of Monday 31
  August 2026; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and Thursday,
  under the category "Morning"
- **THEN** nothing is refused
- **AND** what it keeps is one group, "Morning", holding one entry named "Gym", saying "Tue, Thu"

#### Scenario: a commitment whose range is changed through a commitments screen is given a new era from today

- **WHEN** a commitment named "Mood" of the number kind with a range of 1 to 10, on a schedule
  listing all seven weekdays, kept from 1 January 2026, is taken on at a roster place; a commitments
  screen is opened at that roster place and at a record place where nothing has been kept as of
  Monday 31 August 2026; and "Mood" is changed through it to a range of 1 to 5, on the name, the
  rhythm and the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** what it keeps is one entry, named "Mood"
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with the
  era ranging 1 to 10 and about Monday 31 August 2026 with the era ranging 1 to 5
- **AND** what it has stopped is nothing

#### Scenario: a target changed through a commitments screen puts a new era on and leaves every record standing

- **WHEN** a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  all seven weekdays, kept from 1 January 2026, is taken on at a roster place; additions summing to
  120 for it on Monday 3 August 2026 are kept at a record place; a commitments screen is opened at
  that roster place and that record place as of Monday 31 August 2026; the content at that record
  place is read; and "Protein" is changed through it to a target of 100, on the name, the rhythm and
  the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place is keeping is of the total
  kind with a target of 100
- **AND** a store opened afterwards at that record place answers 120 added for that commitment on
  Monday 3 August 2026
- **AND** the content at that record place is byte-for-byte what was read before the change

#### Scenario: a range added to a number commitment carrying none, and one taken off, each put a new era on

- **WHEN** a commitment named "Weight" of the number kind carrying no range and one named "Mood" of
  the number kind with a range of 1 to 10, both on a schedule listing all seven weekdays and kept
  from 1 January 2026, are taken on at a roster place; a commitments screen is opened at that roster
  place and at a record place where nothing has been kept as of Monday 31 August 2026; "Weight" is
  changed through it to a range of 40 to 150 and "Mood" to no range at all, each on the name, rhythm
  and day kept from it already has, under no category
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place answers about Monday 31 August 2026 with
  "Weight" ranging 40 to 150 and "Mood" carrying no range
- **AND** it answers about Sunday 30 August 2026 with "Weight" carrying no range and "Mood" ranging
  1 to 10, among them
- **AND** each is one commitment with two eras, kept from 1 January 2026

#### Scenario: a commitment kept from a day after today, changed before that day, keeps the day it is kept from

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  Friday 4 September 2026, is taken on at a roster place; a commitments screen is opened at that
  roster place and at a record place where nothing has been kept as of Tuesday 1 September 2026;
  and "Gym" is changed through it to a weekday-set rhythm of Tuesday and Thursday, on the name and
  the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place reads back one era of "Gym", on Tuesday and
  Thursday, kept from Friday 4 September 2026
- **AND** what the screen says "Gym" is made of says the day kept from 4 September 2026
- **AND** a commitment named "Nails" on an interval rhythm of 4 days, kept from that same Friday,
  changed alike to an interval rhythm of 5 days, reads back one era, on every 5 days starting on
  Friday 4 September 2026

#### Scenario: a total commitment's usual amounts changed through a commitments screen put no era on it and leave the record place as it was

- **WHEN** a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  all seven weekdays, kept from 1 January 2026, declaring a usual amount of 20 with no name, is taken
  on at a roster place; an addition of 30 for it on Monday 3 August 2026 is kept at a record place; a
  commitments screen is opened at that roster place and that record place as of Monday 31 August
  2026; and "Protein" is changed through it to usual amounts typed as "35" named "Müesli" and "20"
  with a blank name, on the name, the rhythm, the day kept from and the target it already has, under
  no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place reads back one era of "Protein", and the
  usual amounts 20 with no name and 35 named "Müesli" for it
- **AND** the content at the record place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a target and the usual amounts changed in one save put one era on, and every era declares the new usual amounts

- **WHEN** a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  all seven weekdays, kept from 1 January 2026, declaring a usual amount of 20 with no name, is taken
  on at a roster place; a commitments screen is opened at that roster place and at a record place
  where nothing has been kept as of Monday 31 August 2026; and "Protein" is changed through it to a
  target of 150 and a usual amount typed as "35" named "Müesli", on the name, the rhythm and the day
  kept from it already has, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place reads back two eras of "Protein", the newer
  with a target of 150
- **AND** it reads back the one usual amount 35 named "Müesli" for "Protein"

#### Scenario: a stopped total commitment's usual amounts changed through a commitments screen are declared, and it stays stopped

- **WHEN** a commitment named "Protein" of the total kind with a target of 120 and one named "Gym",
  both on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a
  roster place; "Protein" is stopped there as of Sunday 30 August 2026; a commitments screen is
  opened at that roster place and at a record place where nothing has been kept as of Monday
  31 August 2026; and "Protein" is changed through it to a usual amount typed as "20" with a blank
  name, on everything else it already has
- **THEN** nothing is refused
- **AND** what it has stopped is one entry, named "Protein", and what it says "Protein" is made of
  names 20 with no name
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a change naming the usual amounts a total commitment already declares, in another order, changes nothing

- **WHEN** a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  all seven weekdays, kept from 1 January 2026, declaring a usual amount of 20 with no name and one
  of 35 named "Müesli", is taken on at a roster place; a commitments screen is opened at that roster
  place and at a record place where nothing has been kept as of Monday 31 August 2026; and "Protein"
  is changed through it to usual amounts typed as "35" named "Müesli" and "20" with a blank name, on
  everything else it already has
- **THEN** nothing is refused
- **AND** the content at both places is byte-for-byte what it was immediately after the screen was
  opened

### Requirement: A roster shifts an every-N-days due day onto a day between the due days either side of it, and runs its count on from there

A roster SHALL shift a due day of a commitment it holds, kept or stopped, where the era holding it
runs every N days, only onto a free day of it, and SHALL refuse every other such shift, changing
nothing. A free day SHALL be after any due day before it and before the due day after it; held by
the era holding the due day; and no day another shift of the commitment took a due day from or put
one on. It SHALL refuse the shift while another shift has a day after it, or an era of it is kept
from a day after it. A day a shift put a due day on SHALL be shifted as
the day it came from would be without that shift, keeping that day, and shifted to that day SHALL
leave no shift.

#### Scenario: a roster shifts an every-N-days due day onto any day between the due days either side of it, a week crossed or not

- **WHEN** six rosters each hold a commitment named "Nails" on a schedule of every 4 days starting
  on Thursday 6 August 2026, kept from that day, and each is asked to shift its due day on Sunday 30
  August 2026 to one of Thursday 27, Friday 28 and Saturday 29 August, and Monday 31 August, Tuesday
  1 and Wednesday 2 September 2026
- **THEN** each of the six answers that it shifted it
- **AND** each still holds one era of "Nails", kept from Thursday 6 August 2026 and saying "Every
  4 days"
- **AND** a roster holding a commitment named "Contact lenses" on a schedule of every 14 days
  starting on Tuesday 25 August 2026, kept from that day, shifts its due day on Tuesday 8 September
  2026 to Saturday 5 September 2026, a day of the week before

#### Scenario: a roster refuses to shift an every-N-days due day onto a due day either side of it, a day beyond them, or itself

- **WHEN** a roster holds a commitment named "Nails" on a schedule of every 4 days starting on
  Thursday 6 August 2026, kept from that day, and is asked to shift its due day on Sunday 30 August
  2026 to Wednesday 26 August, Tuesday 25 August, Thursday 3 September and Friday 4 September 2026,
  and to Sunday 30 August 2026 itself
- **THEN** the roster refuses each of the five
- **AND** the commitment it keeps is still due on Sunday 30 August and Thursday 3 September 2026

#### Scenario: an era's first every-N-days due day is shifted back no further than the day that era is kept from

- **WHEN** a roster holds a commitment named "Nails" on a schedule of every 4 days starting on
  Thursday 6 August 2026, kept from Tuesday 4 August 2026, and is asked to shift its due day on
  Thursday 6 August 2026 to Monday 3 August 2026 and then to Tuesday 4 August 2026
- **THEN** it refuses the first and shifts the second
- **AND** the commitment it keeps is due on Tuesday 4 and Saturday 8 August 2026, and on neither
  Thursday 6 nor Monday 10 August 2026
- **AND** a roster holding a commitment named "Mood" of the number kind with a range of 1 to 10, on
  a schedule of every 4 days starting on Thursday 6 August 2026, kept from that day, given a further
  era ranging 1 to 5 on that same schedule, kept from Tuesday 1 September 2026, refuses to shift its
  due day on Thursday 3 September 2026 to Monday 31 August 2026 and shifts it to Tuesday 1 September
  2026

#### Scenario: a roster refuses to shift an every-N-days due day while a later shift or a later era of it stands

- **WHEN** a roster holds a commitment named "Nails" on a schedule of every 4 days starting on
  Thursday 6 August 2026, kept from that day, whose due day on Thursday 3 September 2026 is shifted
  to Friday 4 September 2026, and is asked to shift its due day on Sunday 30 August 2026 to Monday
  31 August 2026
- **THEN** the roster refuses it, and the commitment it keeps is still due on Sunday 30 August 2026
- **AND** a roster holding "Nails" alike, unshifted but given a further era on a schedule of every
  5 days starting on Tuesday 1 September 2026, kept from that day, refuses the same shift

#### Scenario: an every-N-days day a shift put a due day on, shifted again, keeps the day it came from and that day's bounds

- **WHEN** a roster holds a commitment named "Nails" on a schedule of every 4 days starting on
  Thursday 6 August 2026, kept from that day, whose due day on Sunday 30 August 2026 is shifted to
  Monday 31 August 2026, and is asked to shift Monday 31 August 2026 to Wednesday 2 September 2026
- **THEN** the roster answers that it shifted it
- **AND** the commitment it keeps is due on Wednesday 2 and Sunday 6 September 2026, and on none of
  Sunday 30 August, Monday 31 August and Friday 4 September 2026
- **AND** the roster then refuses to shift Wednesday 2 September 2026 to Thursday 3 September 2026
- **AND** it shifts Wednesday 2 September 2026 to Sunday 30 August 2026, leaving the commitment due
  on Sunday 30 August and Thursday 3 September 2026 and on neither Monday 31 August nor Wednesday
  2 September 2026

#### Scenario: a roster refuses to shift an every-N-days due day onto a day another shift took a due day from

- **WHEN** a roster holds a commitment named "Nails" on a schedule of every 4 days starting on
  Thursday 6 August 2026, kept from that day, whose due day on Sunday 30 August 2026 is shifted to
  Saturday 29 August 2026, and is asked to shift its due day on Wednesday 2 September 2026 to Sunday
  30 August 2026 and then to Monday 31 August 2026
- **THEN** it refuses the first and shifts the second
- **AND** the commitment it keeps is due on Saturday 29 August, Monday 31 August and Friday
  4 September 2026, and on neither Sunday 30 August nor Wednesday 2 September 2026

#### Scenario: a roster shifts an every-N-days day of a commitment it has stopped only onto a day it held

- **WHEN** a roster holds a commitment named "Nails" on a schedule of every 4 days starting on
  Thursday 6 August 2026, kept from that day, stopped as of the day it was kept until, Monday 31
  August 2026, and is asked to shift its due day on Sunday 30 August 2026 to Tuesday 1 September
  2026 and then to Monday 31 August 2026
- **THEN** it refuses the first and shifts the second
- **AND** a roster holding "Nails" alike, not stopped, whose due day on Sunday 30 August 2026 is
  shifted to Saturday 29 August 2026 and which is then stopped as of the day it was kept until,
  Saturday 29 August 2026, refuses to shift Saturday 29 August 2026 to Sunday 30 August 2026, and
  the commitment it holds is still due on Saturday 29 August 2026

#### Scenario: a roster shifts an every-N-days due day before days away said over it

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 1 October
  2026, kept from that day, is taken on at a roster place; days away from Tuesday 20 through Sunday
  25 October 2026 are said over it through a commitments screen opened at that roster place as of
  Monday 12 October 2026; and a roster store opened afterwards at that place is asked to shift its due
  day on Tuesday 13 October 2026 to Wednesday 14 October 2026
- **THEN** it shifts it
- **AND** the commitment it holds is due on Wednesday 14 and Sunday 18 October 2026, on neither
  Tuesday 13 nor Saturday 17 October 2026, and on Monday 26 and Friday 30 October 2026
- **AND** the roster store then refuses to shift its due day on Sunday 18 October 2026 to Tuesday
  20 October 2026

### Requirement: What a commitments screen tells about days away lasts until its sheet is edited or closed, days away are kept, or the app is shown again

A commitments screen SHALL hold the last refusal of days away said, changed or removed through it, and
only that one, apart from what it holds about any other change. It SHALL end that refusal when a days
away sheet is edited, when that sheet is closed, when days away are said, changed or removed through
it and kept at the roster place, and when the app is shown again, and at no other moment: a commitment
stopped, changed or deleted through it SHALL leave that refusal standing.

#### Scenario: a refusal of days away is told until the sheet is edited or closed, days away are kept, or the app is shown again

- **WHEN** commitments named "Gym" and "Run" on schedules listing all seven weekdays, kept from
  1 January 2026, are taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 12 October 2026; and days away from Wednesday 14 through Tuesday 13 October 2026 are
  said through it over "Gym"
- **THEN** it tells that refusal, and still tells it once "Run" is stopped through it
- **AND** it tells nothing once the days away sheet is edited
- **AND** the same days away said again are told until the sheet is closed, said again until the app
  is shown again as of that day, said again until days away from Tuesday 13 through Sunday 18 October
  2026 are said through it over "Gym" and kept, and said again until those are changed through it to
  end on Saturday 17 October 2026 and kept

### Requirement: A roster store keeps days away at its place, reads a roster kept before them as holding none, and refuses days away no roster could hold

A roster store SHALL keep every days away a roster holds, its name or none, its days and its
commitments in their order, across the app being closed and opened again, past ones included.
A roster in a form written before days away could be said SHALL be read as holding none, and reading
it MUST NOT change what is at its place. Days away SHALL be said once, of the whole roster, exactly in
the forms written since, empty where none; a store saying them where its form does
not, or not where it does, SHALL be refused as content that is not a roster store. So SHALL a store
holding days away over no commitment, over one it does not hold or one twice, ending before their
first day, named with what says nothing, or sharing an identity, or a day and a commitment, with
other days away.

#### Scenario: days away kept at a roster place are read back after the app is closed and opened again

- **WHEN** commitments named "Gym", "Run" and "Creatine" on schedules listing all seven weekdays,
  kept from 1 January 2026, are taken on at a roster place; days away named "Flu" from Thursday 1
  through Saturday 3 October 2026 are said over "Creatine" through a commitments screen opened at that
  roster place as of Thursday 1 October 2026; and days away named "Mallorca" from Tuesday 13 through
  Sunday 18 October 2026 over "Run" and "Gym", and days away with no name from Tuesday 20 through
  Tuesday 20 October 2026 over "Creatine", are said through one opened there as of Monday 12 October
  2026
- **THEN** a roster store opened afterwards at that place holds three days away: "Flu", from Thursday
  1 through Saturday 3 October 2026, over "Creatine"; "Mallorca", from Tuesday 13 through Sunday
  18 October 2026, over "Gym" and "Run"; and one with no name, Tuesday 20 October 2026, over "Creatine"

#### Scenario: a roster kept before days away could be said is read with none, and its place left as it was

- **WHEN** a roster store is opened at a place holding a roster written in the form used before days
  away could be said, whose one commitment is named "Gym" on a schedule listing all seven weekdays,
  kept from 1 January 2026
- **THEN** it opens without error, and its roster holds "Gym" and no days away
- **AND** the content at that place is byte-for-byte what it was before the store was opened

#### Scenario: a roster store holding days away no roster could hold is refused

- **WHEN** a roster store is opened at each of eight places, each holding a roster in the form this
  app writes now whose commitments are "Gym" and "Run", and whose days away are, one place each: over
  no commitment; over a commitment the roster does not hold; over "Gym" twice; from Wednesday 14
  through Tuesday 13 October 2026; named "   "; over "Gym" from Tuesday 13 through Sunday 18 October
  2026 beside days away over "Gym" and "Run" from Sunday 18 through Monday 19 October 2026; over "Gym"
  from Tuesday 13 through Wednesday 14 October 2026 beside days away over "Run" from Tuesday 20
  through Wednesday 21 October 2026 carrying the same identity; and, as a control, over "Gym" from
  Tuesday 13 through Sunday 18 October 2026 beside days away over "Run" alone on those same days
- **THEN** each of the first seven is refused as content that is not a roster store
- **AND** the eighth opens without error, holding both days away

#### Scenario: a roster store whose shape and declared form disagree about days away is refused

- **WHEN** a roster store is opened at a place holding a roster declaring the form used before days
  away could be said and saying days away, and at a place holding a roster declaring the form this app
  writes now and leaving days away unsaid
- **THEN** each is refused as content that is not a roster store
