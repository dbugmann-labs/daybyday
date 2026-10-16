## MODIFIED Requirements

### Requirement: A day screen marks a weekly-quota row of its today whose week has no slack, while the row is not kept

Asked about a row of the today it was last handed, a day screen SHALL answer the mark "Needed today"
exactly where the row's commitment is on a weekly quota, the row says its commitment is not kept,
and what the row's week owes, less its standing, equals the days from the row's
date through that week's Sunday, both counted, that the commitment's eras hold and its days away
leave. The owing and
the standing SHALL be the numbers the row's rhythm words say.

It SHALL answer no mark where the week still owes fewer days than are left in it, where it owes
nothing more, where it owes more days than are left in it, for a row that says its commitment is
kept, and for a row whose commitment is on any other schedule. Asking SHALL change nothing the
screen holds and nothing at any of its places.

#### Scenario: a weekly-quota row on today owing every day left in its week is marked Needed today

- **WHEN** a day screen is opened as of Thursday 8 October 2026, at a record place holding a tick
  for "Yuno" on Monday 5 October 2026, of a commitment named "Yuno" on a weekly quota of 5 times a
  week, kept from 1 January 2026
- **THEN** its one row says "1/5x a week" and says it is not kept
- **AND** the day screen answers the mark "Needed today" for that row
- **AND** a day screen opened as of Sunday 11 October 2026, at a record place holding ticks for
  "Gym" on Monday 5 and Wednesday 7 October 2026, of a commitment named "Gym" on a weekly quota of
  3 times a week, kept from 1 January 2026, answers "Needed today" for its row saying "2/3x a week"

#### Scenario: a weekly-quota row on today with a day to spare carries no mark

- **WHEN** a day screen is opened as of Thursday 8 October 2026, at a record place holding ticks
  for "Yuno" on Monday 5 and Tuesday 6 October 2026, of a commitment named "Yuno" on a weekly quota
  of 5 times a week, kept from 1 January 2026
- **THEN** its one row says "2/5x a week" and the day screen answers no mark for it
- **AND** a day screen opened the same way as of Wednesday 7 October 2026, at a record place holding
  a tick for "Yuno" on Monday 5 October 2026 alone, answers no mark for its row saying "1/5x a week"

#### Scenario: a weekly-quota row on today whose week owes nothing more carries no mark

- **WHEN** a day screen is opened as of Thursday 8 October 2026, at a record place holding ticks for
  "Gym" on Monday 5, Tuesday 6 and Wednesday 7 October 2026, of a commitment named "Gym" on a weekly
  quota of 3 times a week, kept from 1 January 2026
- **THEN** its one row says "3/3x a week" and the day screen answers no mark for it
- **AND** a day screen opened as of Saturday 10 October 2026, at a place where nothing has been
  kept, of a commitment named "Stretch" on a weekly quota of 1 time a week, kept from that day,
  answers no mark for its row saying "0/0x a week"

#### Scenario: a weekly-quota row on today whose week can no longer be met carries no mark

- **WHEN** a day screen is opened as of Thursday 8 October 2026, at a place where nothing has been
  kept, of a commitment named "Yuno" on a weekly quota of 5 times a week, kept from 1 January 2026
- **THEN** its one row says "0/5x a week" and says it is not kept
- **AND** the day screen answers no mark for it

#### Scenario: a marked row loses its mark once ticked and has it back once the tick is taken back

- **WHEN** a day screen is opened as of Thursday 8 October 2026, at a record place holding a tick
  for "Yuno" on Monday 5 October 2026, of a commitment named "Yuno" on a weekly quota of 5 times a
  week, kept from 1 January 2026, and its one row is ticked
- **THEN** the row the day screen then holds says "2/5x a week", says it is kept and carries no mark
- **AND** once that row is ticked again, the row the day screen then holds says "1/5x a week" and
  the day screen answers "Needed today" for it

#### Scenario: a lost week ticked on today carries no mark though its standing owes every day left

- **WHEN** a day screen is opened as of Thursday 8 October 2026, at a place where nothing has been
  kept, of a commitment named "Yuno" on a weekly quota of 5 times a week, kept from 1 January 2026,
  and its one row is ticked
- **THEN** the row the day screen then holds says "1/5x a week" and says it is kept
- **AND** the day screen answers no mark for it

#### Scenario: a weekly-quota total row is marked while its day falls short of its target

- **WHEN** a day screen is opened as of Thursday 8 October 2026, at a record place holding an
  addition of 120 for "Protein" on Monday 5 October 2026 and one of 30 on Thursday 8 October 2026,
  of a commitment named "Protein" of the total kind with a target of 120, on a weekly quota of 5
  times a week, kept from 1 January 2026
- **THEN** its one row says "1/5x a week" and says it is not kept
- **AND** the day screen answers "Needed today" for it
- **AND** once "90" is committed on that row, the row the day screen then holds says "2/5x a week",
  says it is kept and carries no mark

#### Scenario: a week owing every day it holds is marked on today until a day of it is missed

- **WHEN** a day screen is opened as of Monday 5 October 2026, at a place where nothing has been
  kept, of a commitment named "Vitamins" on a weekly quota of 7 times a week, kept from 1 January
  2026
- **THEN** the day screen answers "Needed today" for its row saying "0/7x a week"
- **AND** one opened the same way as of Wednesday 7 October 2026, at a record place holding ticks for
  "Vitamins" on Monday 5 and Tuesday 6 October 2026, answers "Needed today" for its row saying
  "2/7x a week", and one holding a tick on Monday 5 October 2026 alone answers no mark for its row
  saying "1/7x a week"
- **AND** one opened as of Thursday 8 October 2026, at a place where nothing has been kept, of
  "Vitamins" on that same quota kept from that day, answers "Needed today" for its row saying
  "0/4x a week"

#### Scenario: a row on a schedule that is not a weekly quota carries no mark

- **WHEN** a day screen is opened as of Thursday 8 October 2026, at a place where nothing has been
  kept, of a commitment named "Creatine" on a schedule listing all seven weekdays and a commitment
  named "Run" on a schedule listing Tuesday, Thursday and Sunday, both kept from 1 January 2026
- **THEN** its rows say "Every day" and "Tue, Thu, Sun", each not kept
- **AND** the day screen answers no mark for either

#### Scenario: a weekly-quota row on today owing every day left before days away later in its week is marked Needed today

- **WHEN** a commitment named "Yuno" on a weekly quota of 5 times a week, kept from 1 January 2026, is
  taken on at a roster place; days away from Friday 16 through Sunday 18 October 2026 are said over
  it through a commitments screen opened at that roster place as of Monday 12 October 2026; a tick for
  "Yuno" on that Monday is kept at a record place; and a day screen is opened at those places as of
  Wednesday 14 October 2026
- **THEN** its one row says "1/3x a week" and says it is not kept
- **AND** the day screen answers "Needed today" for it
- **AND** a day screen opened the same way as of Tuesday 13 October 2026 answers no mark for its row
  saying "1/3x a week"

#### Scenario: a weekly-quota row on a day under days away holding a record counts that day among the days its week holds

- **WHEN** a commitment named "Protein" of the total kind with a target of 120, on a weekly quota of
  5 times a week, kept from 1 January 2026, is taken on at a roster place; an addition of 30 for
  "Protein" on Monday 12 October 2026 is kept at a record place; days away from that Monday through
  Wednesday 14 October 2026 are said over it through a commitments screen opened at those places as
  of that Monday; and a day screen is opened at those places as of that Monday
- **THEN** its one row says "0/4x a week" and says it is not kept
- **AND** the day screen answers no mark for it

### Requirement: A day view says the days away its date lies in, one line each, by name or Away

A day screen SHALL say, on every day view it forms, the day either side of the one shown included,
one line for each days away its roster holds whose days include that view's date, in the order of
their first days, days away sharing a first day in the order they were said. Each line SHALL be the
name of those days away, or "Away" where they have none, and SHALL name no commitment. The lines SHALL
be said on every day of those days away, whatever rows that day holds, days before the today
included and a day on which a commitment picked holds a record, and so shows its row, included, and on
no other day.

#### Scenario: a day screen says the name of days away on each of their days, and nothing either side

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and one named
  "Creatine" on a schedule listing all seven weekdays, both kept from 1 January 2026, are taken on at
  a roster place; days away named "Mallorca" from Tuesday 13 through Sunday 18 October 2026 are said
  over "Gym" through a commitments screen opened at that roster place as of Monday 12 October 2026;
  and a day screen is opened at that roster place, a record place and a one-off place where nothing
  has been kept, as of Thursday 15 October 2026
- **THEN** its day view says one line, "Mallorca", and holds one row, named "Creatine"
- **AND** the day views it says of the day before and of the day after each say "Mallorca"
- **AND** a day screen opened the same way as of Monday 12 October 2026, and one as of Monday
  19 October 2026, says no line

#### Scenario: days away with no name are said as Away, and two on one day in the order of their first days

- **WHEN** commitments named "Gym" and "Creatine" on schedules listing all seven weekdays, kept from
  1 January 2026, are taken on at a roster place; days away with no name from Thursday 15 through
  Friday 16 October 2026 over "Creatine", and then days away named "Mallorca" from Tuesday 13 through
  Sunday 18 October 2026 over "Gym", are said through a commitments screen opened at that roster
  place as of Monday 12 October 2026; and a day screen is opened at that roster place, a record place
  and a one-off place where nothing has been kept, as of Thursday 15 October 2026
- **THEN** its day view says two lines, "Mallorca" and then "Away", and holds no row
- **AND** a day screen opened the same way as of Saturday 17 October 2026 says "Mallorca" alone

#### Scenario: days away are said on days already gone, and on a first day a commitment is kept through

- **WHEN** commitments named "Creatine" and "Magnesium" on schedules listing all seven weekdays, kept
  from 1 January 2026, are taken on at a roster place; a tick for "Creatine" on Monday 12 October 2026
  is kept at a record place; days away from that Monday through Wednesday 14 October 2026 are said
  over both through a commitments screen opened at those places as of that Monday; and a day screen
  is opened at those places and a one-off place where nothing has been kept, as of Friday 16 October
  2026, and moved to the day before three times
- **THEN** its day view, of Tuesday 13 October 2026, says one line, "Away", and holds no row
- **AND** moved to the day before once more, its day view says "Away" and holds one row, named
  "Creatine", saying it is kept
