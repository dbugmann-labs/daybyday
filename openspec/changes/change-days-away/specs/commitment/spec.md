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

### Requirement: A change of days away gives back the days a commitment no longer has under them and takes those it newly has

A kept change SHALL give each commitment the changed days away are over their gap as changed, every
day of it neither given back nor newly taken left as it was. Days given back before the new first day SHALL be kept on the rhythm, range and target the
commitment held on the day before the old first day. The commitment SHALL be taken up again on the
day after the new last day on the rhythm, range and target it holds on the later of that day and the
day after the old last day, an every-N-days count beginning again there. A commitment kept through
the old first day SHALL stay kept through it while the first day does not move. A commitment newly
picked SHALL take its gap as days away said give one, and one no longer picked SHALL be left as a
removal leaves it.

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

#### Scenario: a commitment changed while away is taken up on its new rhythm wherever the day back moves, and keeps it once the days away are removed

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; days away named "Mallorca" from Tuesday 13 through
  Sunday 18 October 2026 are said over "Gym" through a commitments screen opened at that roster place
  as of Monday 12 October 2026; "Gym" is changed to a schedule listing all seven weekdays through one
  opened there as of Thursday 15 October 2026; and "Mallorca" is changed through that screen to end on
  Friday 16 October 2026
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place holds "Gym" due on Saturday 17 and Sunday
  18 October 2026 and on neither Thursday 15 nor Friday 16 October 2026
- **AND** changed again through it to end on Tuesday 20 October 2026, one holds "Gym" due on Wednesday
  21 and Thursday 22 October 2026 and on none of Saturday 17, Sunday 18 and Monday 19 October 2026
- **AND** removed then through it, the removal confirmed, one holds "Gym" due on Wednesday 14, Monday
  19 and Thursday 22 October 2026 and on neither Thursday 15 nor Tuesday 20 October 2026

#### Scenario: a commitment ticked onto days away takes its gap, and one unticked is left as though it had never been picked

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

#### Scenario: a commitment kept through a first day it holds a record on stays kept through it while the first day does not move

- **WHEN** a commitment named "Creatine" and one named "Magnesium", both on schedules listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; a tick for "Creatine"
  on Monday 12 October 2026 is kept at a record place; days away from that Monday through Wednesday
  14 October 2026 are said over both through a commitments screen opened at those places as of that
  Monday; and they are changed to end on Friday 16 October 2026 through one opened there as of
  Tuesday 13 October 2026
- **THEN** nothing is refused
- **AND** a day screen opened at those places as of Monday 12 October 2026 holds one row, named
  "Creatine", saying it is kept; one opened as of Thursday 15 October 2026 holds no row; and one
  opened as of Saturday 17 October 2026 holds both

### Requirement: A commitments screen refuses days away said or changed that would put a recorded day under them, naming the commitment and the day

A commitments screen SHALL refuse days away said or changed that would newly put under them, for a
commitment picked, a day on which its record holds a tick, a number, a note, an addition or a decline
of that commitment, naming the first such commitment the roster holds and that commitment's earliest
such day. A first day that is the day the screen was handed SHALL instead keep through it a
commitment holding a record there, as days away said keep one. Days a change gives back, and days
already under those days away before the change, SHALL NOT be judged. A screen that cannot read its
record SHALL judge no day as holding a record. A refused saying or change SHALL keep nothing and
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
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; a tick for "Creatine"
  on Monday 12 October 2026 is kept at a record place; days away from that Monday through Friday
  16 October 2026 are said over both through a commitments screen opened at those places as of that
  Monday; ticks for "Magnesium" on Wednesday 14 and Friday 16 October 2026 are then kept at the record
  place; and through a commitments screen opened at those places as of Tuesday 13 October 2026 the
  days away are changed to begin on Sunday 11 October 2026, then to end on Thursday 15 October 2026,
  and then to the name "Flu"
- **THEN** the first is refused as over a recorded day, naming "Creatine" and Monday 12 October 2026,
  and neither the second nor the third is refused
- **AND** a day screen opened at those places as of Friday 16 October 2026 holds a row named
  "Magnesium" saying it is kept

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

### Requirement: A change of days away keeps a stopped commitment they are over, picked or not, and keeps it no later than their first day where they reach past its stop

A change through a commitments screen SHALL keep over the changed days away a stopped commitment
they are over that stays picked, and SHALL give one no longer picked back their days up to the day
they remember it kept until, as a removal gives them back. Where they begin on or before that day
and end after it, the commitment SHALL be kept until the day before their first day and no later.
A change moving their last day back SHALL give it back the days after the new last day up to the
day remembered. Only a change moving their first day later than the
day after the day remembered SHALL take a stopped commitment out of them, giving back their days up
to that day, and a change leaving them over no commitment SHALL be refused as days away over no
commitment.

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

#### Scenario: days away moved past the last day a stopped commitment was kept keep it until the day before them

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Flu" from Thursday
  1 through Saturday 3 October 2026 are said over both through a commitments screen opened at that
  roster place as of Thursday 1 October 2026; "Gym" is stopped, the stop confirmed, through one opened
  there as of Monday 5 October 2026; and "Flu" is changed to end on Wednesday 7 October 2026 through
  one opened there as of Monday 12 October 2026
- **THEN** it is not refused, and that screen lists "Flu" as past over "Gym" and "Run"
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had not
  stopped keeping on Wednesday 30 September 2026 and not on Sunday 4 October 2026, and holds "Run"
  due on Thursday 8 October 2026 and not on Monday 5 October 2026

#### Scenario: a stopped commitment kept until the day before days away stays picked through a later change of them, owing no day after its stop

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Flu" from Thursday
  1 through Saturday 3 October 2026 are said over both through a commitments screen opened at that
  roster place as of Thursday 1 October 2026; "Gym" is stopped, the stop confirmed, through one opened
  there as of Monday 5 October 2026; and through one opened there as of Monday 12 October 2026 "Flu"
  is changed to end on Wednesday 7 October 2026, and then to the name "Fever", from Thursday 1
  through Wednesday 7 October 2026, over both
- **THEN** neither is refused, and that screen lists "Fever" as past over "Gym" and "Run"
- **AND** a day screen opened at that roster place and a record place where nothing has been kept, as
  of Monday 5 October 2026, holds no row
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
  stopped keeping on Sunday 27 September 2026 and not on Monday 28 September 2026

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

### Requirement: Days away remember the day a stop kept each commitment they are over until, and no change or removal of them makes it owe a day after it

A stop confirmed through a commitments screen SHALL make every days away that keep the commitment
remember the day the stop kept it until, unless they remember a day for it already, which SHALL stay
as it is. Days away SHALL keep remembering that day through every change of them that keeps the
commitment over them, and once it is taken up again. A removal confirmed and the commitment
unticked SHALL give it back their days up to the day remembered, and no removal and no change of
them SHALL make it owe a day after that day and before the day it was next taken up again. What
days away remember SHALL be kept at the roster place with them, before either list says so.

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
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had not
  stopped keeping on Sunday 4 and on Monday 12 October 2026, and not on Monday 5 or Sunday 11 October
  2026

### Requirement: A commitments screen takes a commitment up again on a day inside days away over it from the day after their last day

A commitments screen asked to take up again a stopped commitment on a day inside days away over it
SHALL take it up again on the day after their last day, instead of on the day it was handed, on the
rhythm, range and target it had, an every-N-days count beginning there, as a change made while away
holds from that day. Those days away SHALL stay over it and SHALL keep remembering the day its stop
kept it until. Every other take-up-again SHALL be as it was.

#### Scenario: a commitment taken up again inside days away over it is taken up on the day after their last day, and stays remembered by them

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
  Tuesday 13, Wednesday 14 and Monday 19 October 2026, and on none of Thursday 15 through Sunday
  18 October 2026

### Requirement: A roster store keeps what days away remember, reads a roster kept before they remembered as remembering the later of their last day and the last day kept, and refuses what no roster could remember

A roster store SHALL keep what each days away remember across the app being closed and opened
again. A roster in the form written before days away remembered a stop
SHALL be read as remembering, for each stopped commitment days away are over, the later of their
last day and the last day it was kept, and reading it MUST NOT change what is at its place. A store
in the forms written since SHALL say of every days away what it remembers, empty where nothing; a
store saying so where its form does not, or not where it does, SHALL be refused as content that is
not a roster store. So SHALL a store whose days away remember a commitment they are not over or one
twice, a day before the day before their first day, or nothing for a stopped commitment they are
over.

#### Scenario: a roster kept before days away remembered a stop is read as remembering the later of their last day and the last day kept

- **WHEN** a roster store is opened at each of two places holding a roster written in the form used
  before days away remembered a stop, whose commitments are "Gym" and "Run" on schedules listing all
  seven weekdays, "Run" kept from 1 January 2026 until Wednesday 30 September 2026 and again from
  Sunday 4 October 2026, and whose one days away, named "Flu", run from Thursday 1 through Saturday
  3 October 2026 over both: at the first, "Gym" kept from 1 January until Wednesday 30 September
  2026; at the second, "Gym" kept from 1 January until Wednesday 30 September 2026 and again from
  Sunday 4 until Sunday 11 October 2026
- **THEN** each opens without error, and the content at each place is byte-for-byte what it was before
  the store was opened
- **AND** once "Flu" is removed, the removal confirmed, through a commitments screen opened at the
  first place as of Monday 12 October 2026, a roster store opened there answers with "Gym" when asked
  what it had not stopped keeping on Saturday 3 October 2026 and not on Sunday 4 October 2026
- **AND** once "Flu" is changed to end on Wednesday 7 October 2026 and then removed, the removal
  confirmed, through one opened at the second place as of that Monday, a roster store opened there
  answers with "Gym" when asked what it had not stopped keeping on Tuesday 6 and on Sunday 11 October
  2026, and not on Monday 12 October 2026

#### Scenario: a roster store whose days away remember what no roster could is refused

- **WHEN** a roster store is opened at each of seven places, each holding a roster whose commitments
  are "Gym", stopped, kept from 1 January until Wednesday 30 September 2026, and "Run", kept, and
  whose one days away run from Thursday 1 through Saturday 3 October 2026, one place each: in the form
  this app writes now, over "Run" alone, remembering Saturday 3 October 2026 for "Gym"; over both,
  remembering that day for "Gym" twice; over both, remembering Tuesday 29 September 2026 for "Gym";
  over both, remembering nothing; over both, saying nothing of what they remember; in the form used
  before days away remembered a stop, over both, remembering Saturday 3 October 2026 for "Gym"; and,
  as a control, in the form this app writes now, over both, remembering that day for "Gym"
- **THEN** each of the first six is refused as content that is not a roster store
- **AND** the seventh opens without error

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
A confirmed removal SHALL be kept at the roster place before the list says so, and SHALL leave every
commitment the days away were over as though never said, past days and a first day kept through
included, an every-N-days count running on through their days, a change made since standing from
the day its era is kept from, and a stop they remember standing. A removal the roster place cannot
keep SHALL be refused as a roster that could not be written, still listed.

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

## REMOVED Requirements

### Requirement: A commitments screen refuses days away it cannot say, naming what they clash with, and keeps nothing of them

**Reason**: Days away may now begin on a day already gone; the requirement is carried whole, without
that refusal, as *A commitments screen refuses days away ending before they begin, over nothing, or
clashing with what it holds, and keeps nothing of them*.
**Migration**: None on disk.

### Requirement: A commitments screen lists the days away whose last day has not passed, earliest first, each with the commitments it is over

**Reason**: Past days away are now listed apart rather than dropped; carried as *A commitments screen
lists every days away, those not over earliest first and past ones apart, latest first*.
**Migration**: None on disk.

### Requirement: A commitments screen asks before it removes days away, and removes only days away not yet begun, as though they had never been said

**Reason**: Any listed days away can now be removed; carried as *A commitments screen asks before it
removes days away, and removes any it lists as though they had never been said*.
**Migration**: None on disk.

## RENAMED Requirements

- FROM: `### Requirement: A stop or a deletion through a commitments screen takes a commitment out of its days away, and days away left over none go`
- TO: `### Requirement: A stop through a commitments screen takes a commitment out of days away not begun, a deletion out of every days away, and days away left over none go`

## MODIFIED Requirements

### Requirement: A stop through a commitments screen takes a commitment out of days away not begun, a deletion out of every days away, and days away left over none go

A stop confirmed through a commitments screen SHALL take the commitment out of every days away it is
over that have not begun. Days away begun, under way or past, SHALL keep it and remember the day the
stop kept it until; where they are under way, the commitment SHALL stay kept until the day it was
kept until before them. A deletion confirmed through it SHALL take the commitment out of every days
away it is over, those whose last day has passed included. Days away a stop or a deletion leaves
over no commitment SHALL go from the roster. What a stop or a deletion does to days away SHALL be
kept at the roster place with it, before either list says so.

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

#### Scenario: a commitment stopped while its days away are under way is kept until the day before them

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Mallorca" from
  Tuesday 13 through Sunday 18 October 2026 are said over both through a commitments screen opened
  at that roster place as of Monday 12 October 2026; and "Gym" is stopped, the stop confirmed, through
  a commitments screen opened there as of Thursday 15 October 2026
- **THEN** nothing is refused, and that screen lists "Mallorca" over "Gym" and "Run"
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had not
  stopped keeping on Monday 12 October 2026 and not on Tuesday 13 or Wednesday 14 October 2026
- **AND** once "Mallorca" is removed through that screen, the removal confirmed, one answers with
  "Gym" when asked what it had not stopped keeping on Wednesday 14 October 2026 and not on Thursday
  15 October 2026

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

### Requirement: A commitments screen says days away over the commitments it keeps that are picked, each taking a gap over them

A commitments screen SHALL say days away from a name, a first day, a last day and the commitments it
keeps that are picked, keeping them at the roster place before it lists them. The name SHALL be
trimmed of blank space at either end, one that says nothing meaning none, and SHALL NOT be refused for
being one other days away carry. The first day SHALL be any day, however long gone, and the last day
the first or later, unlimited.

Each commitment picked SHALL be kept until the day before the first day, or through the first day
where that is the day handed and the record holds any record of it there, and SHALL be taken up again
on the day after the last day on its rhythm, range and target, an every-N-days count beginning again
there. Every other commitment SHALL be left as it was.

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

#### Scenario: days away from today keep a commitment that holds a record today until today, and the others until the day before

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
  12 October 2026 still holds one row, named "Creatine", saying it is not kept

#### Scenario: days away said over days already gone take their gap there, however far back

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
