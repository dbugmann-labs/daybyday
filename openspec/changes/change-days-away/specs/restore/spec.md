## RENAMED Requirements

- FROM: `### Requirement: Days away said or removed on a commitments screen write a copy at the copy place, and a restore puts them back`
- TO: `### Requirement: Days away said, changed or removed on a commitments screen write a copy at the copy place, and a restore puts them back`

## MODIFIED Requirements

### Requirement: Days away said, changed or removed on a commitments screen write a copy at the copy place, and a restore puts them back

Where a copy place is set, a commitments screen SHALL write a copy there after every days away it
says, changes or removes and keeps at its roster place, as of the moment its clock answers once the change is
kept, and that copy SHALL hold every days away the roster place then holds, each with its name or
none, its days, its commitments and the stops it remembers of each. Days away refused, a change refused, a removal asked for or
cancelled, and a removal refused SHALL write no copy and SHALL leave the last copy as it was. A restore confirmed SHALL make the
roster place hold exactly the days away the copy holds, each remembering what it remembers there,
and nothing of the days away it held before, every commitment holding the gaps the copy's roster
holds.

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

#### Scenario: a copy holding days away that remember a stop, restored, gives the stopped commitment back no day after it

- **WHEN** a commitment named "Gym" and one named "Run", both on schedules listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; days away named "Flu" from Thursday
  1 through Saturday 3 October 2026 are said over both through a commitments screen opened at that
  roster place as of Thursday 1 October 2026; "Gym" is stopped, the stop confirmed, through one opened
  there as of Monday 5 October 2026; through one opened there as of Monday 12 October 2026, "Flu" is
  changed to end on Wednesday 7 October 2026, a copy is made as of that day at 14:32, and "Flu" is
  removed, the removal confirmed; that screen is asked to restore from that copy and the restore is
  confirmed; and "Flu" is removed through it again, the removal confirmed
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had not
  stopped keeping on Sunday 4 October 2026 and not on Monday 5 October 2026
