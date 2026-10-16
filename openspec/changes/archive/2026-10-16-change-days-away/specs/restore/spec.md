## RENAMED Requirements

- FROM: `### Requirement: Days away said or removed on a commitments screen write a copy at the copy place, and a restore puts them back`
- TO: `### Requirement: Days away said, changed or removed on a commitments screen write a copy at the copy place, and a restore puts them back`

## MODIFIED Requirements

### Requirement: Days away said, changed or removed on a commitments screen write a copy at the copy place, and a restore puts them back

Where a copy place is set, a commitments screen SHALL write a copy there after every days away it
says, changes or removes and keeps at its roster place, as of the moment its clock answers once the
change is kept, and that copy SHALL hold every days away the roster place then holds, each with its
name or none, its days and its commitments. Days away refused, a change refused, a removal asked for
or cancelled, and a removal refused SHALL write no copy and SHALL leave the last copy as it was. A
restore confirmed SHALL make the roster place hold exactly the days away the copy holds, and nothing
of the days away it held before, every commitment holding the eras the copy's roster holds, a copy in
an earlier roster form read as a roster store reads that form.

#### Scenario: days away said and removed on a commitments screen each write a copy at the copy place

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place and at a
  record place, a one-off place, a birthday place and a happening place where nothing has been kept,
  as of Monday 12 October 2026, keeping its copy place at a place of its own and asking a clock that
  answers a later minute each time it is asked, from that day at 14:32; a directory of its own is
  given to it as its copy place; and days away named "Mallorca" from Tuesday 13 through Sunday
  18 October 2026 are said through it over "Gym", and then removed through it, asked for and confirmed
- **THEN** neither is refused
- **AND** that directory's one file named `DayByDay.daybyday` after the days away are said is a copy
  made at Monday 12 October 2026 at 14:33, holding a roster holding "Mallorca" over "Gym"; after the
  removal it is one made at 14:34, holding a roster holding no days away
- **AND** days away from Wednesday 14 through Tuesday 13 October 2026 then said through it are refused,
  and the last copy made is still Monday 12 October 2026 at 14:34

#### Scenario: a copy holding days away, restored, puts them and their gaps back at the roster place

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; a commitments screen is opened at that
  roster place as of Monday 12 October 2026; days away named "Mallorca" from Tuesday 13 through Sunday
  18 October 2026 are said through it over "Gym"; a copy is made through it as of that day at 14:32;
  "Mallorca" is then removed through it, and days away named "Lisbon" from Monday 19 through Wednesday
  21 October 2026 are said through it over "Run"; and the screen is asked to restore from that copy
  and the restore is confirmed
- **THEN** it is not refused, and it lists "Mallorca" over "Gym" alone
- **AND** a roster store opened afterwards at that place holds one days away, "Mallorca", "Gym" due on
  neither Thursday 15 October 2026 nor any other day of "Mallorca", and "Run" due on Monday
  19 October 2026

#### Scenario: days away changed on a commitments screen write a copy at the copy place

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place and at a
  record place, a one-off place, a birthday place and a happening place where nothing has been kept,
  as of Monday 12 October 2026, keeping its copy place at a place of its own and asking a clock that
  answers a later minute each time it is asked, from that day at 14:32; a directory of its own is
  given to it as its copy place; days away named "Mallorca" from Tuesday 13 through Sunday 18 October
  2026 are said through it over "Gym"; and they are changed through it to end on Friday 16 October
  2026, and then to end on Monday 12 October 2026
- **THEN** the first change is not refused, and the second is refused
- **AND** that directory's one file named `DayByDay.daybyday` after the first change is a copy made at
  Monday 12 October 2026 at 14:34, holding a roster holding "Mallorca" from Tuesday 13 through Friday
  16 October 2026 over "Gym"
- **AND** after the second, the last copy made is still Monday 12 October 2026 at 14:34

#### Scenario: a copy made before days away moved, restored, gives a commitment taken up again inside them back the days it held then

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Mallorca" from
  Tuesday 13 through Sunday 18 October 2026 are said over both through a commitments screen opened at
  that roster place as of Monday 12 October 2026; "Gym" is stopped, the stop confirmed, through one
  opened there as of Thursday 15 October 2026; and through one opened there as of Friday 16 October
  2026 "Gym" is taken up again, a copy is made as of that day at 14:32, "Mallorca" is changed to end
  on Thursday 15 October 2026, and that screen is asked to restore from that copy and the restore is
  confirmed
- **THEN** nothing is refused, and it lists "Mallorca", "Tue 13 Oct – Sun 18 Oct", over "Gym" and "Run"
- **AND** a roster store opened afterwards at that place holds "Gym" due on Monday 19 October 2026 and on
  none of Tuesday 13 through Sunday 18 October 2026
- **AND** once "Mallorca" is removed through that screen, the removal confirmed, one holds "Gym" due on
  Tuesday 13, Wednesday 14, Friday 16 and Monday 19 October 2026, and not on Thursday 15 October 2026
