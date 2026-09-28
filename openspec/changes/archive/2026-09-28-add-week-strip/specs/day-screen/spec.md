## ADDED Requirements

### Requirement: A day screen says the week of the day it is showing as its week strip

A day screen SHALL say its week strip: the seven days of the week the day being shown lies in,
Monday first and Sunday last. Each day SHALL say its letter, "M", "T", "W", "T", "F", "S" and "S" in
that order, and its date; a day outside the calendar the screen supports SHALL keep its letter and
hold no date. The letters SHALL be this capability's own English and MUST NOT come from the
device's language, region, locale or calendar. The strip SHALL mark the day being shown as shown
and, where the today last handed lies in that week, that day as the today, and SHALL mark nothing
else. It SHALL follow the day being shown and the today, read no clock and take no day from the
caller, and what it holds and marks MUST NOT depend on the record or on the rows of
any day.

#### Scenario: a day screen says the seven days of its week, Monday first, each by its letter

- **WHEN** a day screen is opened as of Wednesday 2 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026
- **THEN** its week strip holds Monday 31 August 2026 to Sunday 6 September 2026, in that order,
  saying "M", "T", "W", "T", "F", "S" and "S"
- **AND** Wednesday 2 September 2026 is marked as shown and as the today, and no other day is marked

#### Scenario: a day screen's week strip marks the today apart from the day it is showing

- **WHEN** a day screen is opened as of Thursday 3 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day before twice
- **THEN** its week strip still holds Monday 31 August 2026 to Sunday 6 September 2026
- **AND** Tuesday 1 September 2026 is marked as shown and Thursday 3 September 2026 as the today, and
  no other day is marked

#### Scenario: a day screen moved into another week holds that week in its strip and marks no day as the today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day before
- **THEN** its week strip holds Monday 24 August 2026 to Sunday 30 August 2026, with Sunday 30 August
  2026 marked as shown and no day marked as the today
- **AND** moved to the day after, its week strip holds Monday 31 August 2026 to Sunday 6 September
  2026, with Monday 31 August 2026 marked as shown and as the today

#### Scenario: a day screen's week strip runs across the turn of a month and a year

- **WHEN** a day screen is opened as of Thursday 31 December 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026
- **THEN** its week strip holds Monday 28 December 2026 to Sunday 3 January 2027, in that order,
  saying "M", "T", "W", "T", "F", "S" and "S"

#### Scenario: a day screen's week strip holds no date for a day outside the calendar

- **WHEN** a day screen is opened as of Saturday 1 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583
- **THEN** its week strip holds seven days saying "M", "T", "W", "T", "F", "S" and "S", the first
  five holding no date and none of them marked, then Saturday 1 January 1583 marked as shown and as
  the today, then Sunday 2 January 1583
- **AND** a day screen opened the same way as of Friday 31 December 9999 holds Monday 27 December
  9999 to Friday 31 December 9999, then two days saying "S" and holding no date

#### Scenario: a day screen shown again on a later day follows it in its week strip only where it was showing its today

- **WHEN** a day screen is opened as of Sunday 6 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the app is then shown again as of Monday 7 September 2026
- **THEN** its week strip holds Monday 7 September 2026 to Sunday 13 September 2026, with Monday 7
  September 2026 marked as shown and as the today
- **AND** a second day screen opened the same way, moved to the day before and then shown again as
  of Monday 7 September 2026, holds Monday 31 August 2026 to Sunday 6 September 2026, with Saturday
  5 September 2026 marked as shown and no day marked as the today

#### Scenario: a day screen's week strip is the same whatever its record holds and whatever is ticked

- **WHEN** a day screen is opened as of Wednesday 2 September 2026, at a record place holding a run
  of bytes that is not what a record is written as, of a commitment named "Journaling" on a schedule
  listing all seven weekdays, kept from 1 January 2026
- **THEN** its week strip is the same week strip as that of a day screen opened the same way at a
  place where nothing has been kept
- **AND** that second day screen's week strip is the same after its one row is ticked as before

### Requirement: A day screen's week strip offers every day it can show but the one it is showing

A day of a day screen's week strip SHALL be offered exactly where it holds a date, is not the day
being shown, and is not earlier than the earliest day the screen's day picker reaches; no other day
SHALL be offered. A day after the today SHALL be offered as any other day is. What is offered SHALL
be read off the reach as it stands, and SHALL change wherever the reach changes. Showing a day the
strip offers SHALL be showing a picked day, as *A day screen shows a day picked on its day picker*
states.

#### Scenario: a day screen's week strip offers every day of its week but the one it is showing

- **WHEN** a day screen is opened as of Wednesday 2 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026
- **THEN** its week strip offers Monday 31 August, Tuesday 1, Thursday 3, Friday 4, Saturday 5 and
  Sunday 6 September 2026
- **AND** it does not offer Wednesday 2 September 2026

#### Scenario: a day screen's week strip offers no day earlier than its day picker reaches

- **WHEN** a day screen is opened as of Saturday 5 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 4 September 2026
- **THEN** its week strip offers Friday 4 and Sunday 6 September 2026, and no other day
- **AND** a day screen opened as of Wednesday 2 September 2026 at a roster place holding a run of
  bytes that is not what a roster is written as offers Thursday 3 to Sunday 6 September 2026, and
  no other day

#### Scenario: a day screen moved below the earliest day its roster keeps offers the days between in its strip

- **WHEN** a day screen is opened as of Saturday 5 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 4 September 2026, and it is moved to the day before three times
- **THEN** its week strip marks Wednesday 2 September 2026 as shown
- **AND** it offers Thursday 3 to Sunday 6 September 2026, and neither Monday 31 August nor Tuesday
  1 September 2026

#### Scenario: a day screen's week strip offers the days its roster reaches once it is returned to

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 4 September 2026, is taken on at a roster place; a day screen of no commitments at all is
  opened at that roster place as of Saturday 5 September 2026, at a record place where nothing has
  been kept; a commitment named "Gym" on that same schedule, kept from 1 January 2026, is then taken
  on at that roster place by something else; and the screen is returned to
- **THEN** its week strip offers every day of its week but Saturday 5 September 2026
- **AND** before it was returned to, its week strip offered Friday 4 and Sunday 6 September 2026,
  and no other day

#### Scenario: a day screen shows a day tapped on its week strip

- **WHEN** a day screen is opened as of Thursday 3 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the day its week strip holds as Monday 31 August 2026 is shown
- **THEN** its day view is the same day view as one formed directly of that commitment and of
  one-offs holding nothing, on Monday 31 August 2026 as of Thursday 3 September 2026, from a history
  that has taken no tick, and it offers the way back to today
- **AND** its week strip marks Monday 31 August 2026 as shown and Thursday 3 September 2026 as the
  today
- **AND** showing the day its week strip holds as Sunday 6 September 2026 from there marks that day
  as shown
