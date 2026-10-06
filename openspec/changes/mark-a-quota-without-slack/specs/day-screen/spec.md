## ADDED Requirements

### Requirement: A day screen marks a weekly-quota row of its today whose week has no slack, while the row is not kept

Asked about a row of the today it was last handed, a day screen SHALL answer the mark "Needed today"
exactly where the row's commitment is on a weekly quota, the row says its commitment is not kept,
whatever its kind, and what the row's week owes, less its standing, equals the number of days from
the row's date through that week's Sunday, both counted. The owing and the standing SHALL be the
numbers the row's rhythm words say.

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

### Requirement: A day screen marks no row of a day other than the today it was last handed

A day screen SHALL answer no mark for a row whose date is not the today it was last handed, whatever
that row's week owes: neither for a row of a day before that today nor for one of a day after it,
whether the row is of the day the screen is showing or of the day either side of it as the screen
says that day. A row of that today SHALL be answered as the requirement on marking a weekly-quota
row says, whichever day the screen is showing. Its today SHALL be the one it was opened as of until
the app is shown again, and the one it is then handed after that; the day it is showing MUST NOT
stand in for it, and no clock SHALL be read.

#### Scenario: a day screen marks no row of the day before or the day after its today

- **WHEN** a day screen is opened as of Thursday 8 October 2026, at a place where nothing has been
  kept, of a commitment named "Yuno" on a weekly quota of 5 times a week, kept from 1 January 2026,
  and it is moved to the day before
- **THEN** its one row says "0/5x a week", says it is not kept and carries no mark
- **AND** a day screen opened the same way at a record place holding ticks for "Yuno" on Monday 5
  and Tuesday 6 October 2026 answers no mark for the row of the day view it says of the day after,
  which says "2/5x a week"
- **AND** a day screen opened the same way at a record place holding a tick for "Yuno" on Monday 5
  October 2026 alone, and moved to the day before, answers "Needed today" for the row of the day
  view it says of the day after, which says "1/5x a week"

#### Scenario: a day screen marks by the today it was last handed, not by the day it is showing

- **WHEN** a day screen is opened as of Wednesday 7 October 2026, at a record place holding a tick
  for "Yuno" on Monday 5 October 2026, of a commitment named "Yuno" on a weekly quota of 5 times a
  week, kept from 1 January 2026, and it is moved to the day after
- **THEN** its one row says "1/5x a week" and carries no mark
- **AND** once it is shown again as of Thursday 8 October 2026, it is still showing that Thursday
  and answers "Needed today" for the row it then holds
