## ADDED Requirements

### Requirement: A day view moves to the day before it and the day after it

A day view SHALL move, when it is handed some commitments and a history, to the day view of the
calendar date one day earlier than its own and to the day view of the calendar date one day later.
What a move gives SHALL be exactly what forming a day view from those commitments, on that date, in
that history would give, and SHALL differ from it in no way: the day view being moved from
contributes the date it is of, and nothing else at all.

A move SHALL carry nothing else across. It MUST NOT keep a row, a name or an answer about whether a
commitment is kept — every row of the day view moved to is asked again, of the date moved to — and
it MUST NOT reuse the commitments or the history the day view being moved from was formed from,
because a day view holds neither. The commitments and the history a move is handed MAY be different
ones, and the day view given back SHALL then be of those: what was handed over before is the
caller's to remember, and a move that quietly preferred it would be a day view holding a list of its
own.

A move SHALL NOT consult the present moment, the device's clock, its time zone or its locale, and
SHALL NOT be given the day it is being made on. Moving is a question asked about a date, exactly as
forming a day view is, so a day view moves onto a date that has not arrived as readily as onto one
that has, and the day view it gives is the same one tomorrow, next year and for ever. What such a
day view's rows then offer is settled already and is not restated here: a row offers no tick when
its date is later than the day it is asked as of.

Moving SHALL leave the day view moved from unchanged. A move gives a day view back rather than
altering one, so a day view that has been moved from is still the day view it was, and may be moved
from again.

#### Scenario: moving to the day after gives the day view of the next date

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, then one named
  "Run" on a schedule listing Monday and Thursday, then one named "Vitamins" on a schedule listing
  all seven weekdays, all three kept from 1 January 2026, and it is moved to the day after, handed
  those same commitments and that same history
- **THEN** the day view moved to holds one row, named "Vitamins", saying the commitment is not kept
- **AND** it is the same day view as one formed on Tuesday 1 September 2026 from those same
  commitments, in that same order, and that same history

#### Scenario: moving to the day before gives the day view of the previous date

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  tick, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, then one
  named "Run" on a schedule listing Monday and Thursday, then one named "Vitamins" on a schedule
  listing all seven weekdays, all three kept from 1 January 2026, and it is moved to the day before,
  handed those same commitments and that same history
- **THEN** the day view moved to holds one row, named "Vitamins", saying the commitment is not kept
- **AND** it is the same day view as one formed on Tuesday 1 September 2026 from those same
  commitments, in that same order, and that same history

#### Scenario: the rows of the day moved to are asked again rather than carried across

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Vitamins" on a
  schedule listing all seven weekdays, kept from 1 January 2026, from a history holding a tick for
  that commitment on Monday 31 August 2026 and no other tick, and it is moved to the day after,
  handed that same commitment and that same history
- **THEN** the day view moved from holds one row saying the commitment is kept
- **AND** the day view moved to holds one row, named "Vitamins", saying the commitment is not kept

#### Scenario: a move uses the commitments and history it is handed rather than the ones the day view came from

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, and it is moved to the day after, handed instead a single commitment named "Vitamins" on a
  schedule listing all seven weekdays, kept from that same day, and a history holding a tick for
  "Vitamins" on Tuesday 1 September 2026
- **THEN** the day view moved to holds one row, named "Vitamins", saying the commitment is kept
- **AND** it holds no row named "Gym"

#### Scenario: a day view moves onto a date that has not arrived, and its rows offer no tick

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from 1 January 2026,
  and it is moved to the day after, handed that same commitment and that same history
- **THEN** the day view moved to holds one row named "Vitamins"
- **AND** that row, asked as of Monday 31 August 2026, offers no tick
- **AND** the same row, asked as of Tuesday 1 September 2026, offers a tick

#### Scenario: moving to the day after and back again gives the day view it started from

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday and a commitment named "Vitamins" on a schedule listing all
  seven weekdays, both kept from 1 January 2026 and handed over in that order, from a history
  holding a tick for "Gym" on that date, and it is moved to the day after and then to the day
  before, handed those same commitments and that same history each time
- **THEN** the day view arrived at is the same day view as the one started from
- **AND** moving the one started from to the day before and then to the day after gives that same
  day view again

### Requirement: A move is one calendar day, and never more

A move SHALL step exactly one calendar day. The day after the last day of a month SHALL be the first
day of the month that follows it, the day after 31 December SHALL be 1 January of the next year, and
the day after 28 February SHALL be 29 February in a leap year and 1 March in a year that is not one —
a leap day is a day like any other and is neither skipped nor doubled. Moving to the day before
SHALL be the same step taken the other way, so that either move undoes the other.

A move SHALL step to the next date whether or not anything is due on it. It MUST NOT skip a date
because no commitment it was handed is due there, MUST NOT stop at the first date something is due
on, and MUST NOT look at the commitments or the history to decide where it lands: a day with nothing
due is an answer rather than a gap, a day view holding no rows moves exactly as one holding rows
does, and a move that skipped would be the day view deciding which days are worth looking at.

#### Scenario: moving does not skip a date on which nothing is due

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, and it is moved to the day after, handed that same commitment and that same history
- **THEN** the day view moved to holds no rows, though Wednesday 2 September 2026 is the next date
  "Gym" is due on
- **AND** moving that day view to the day after in turn holds one row named "Gym"

#### Scenario: moving across the end of a month

- **WHEN** a day view is formed on Wednesday 30 September 2026, from a history that has taken no
  tick, of a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day after, handed that same commitment and that same
  history
- **THEN** the day view moved to is the same day view as one formed on Thursday 1 October 2026 from
  that commitment and that history
- **AND** moving that day view to the day before gives the day view started from

#### Scenario: moving across the turn of a year

- **WHEN** a day view is formed on Thursday 31 December 2026, from a history that has taken no tick,
  of a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from 1 January
  2026, and it is moved to the day after, handed that same commitment and that same history
- **THEN** the day view moved to is the same day view as one formed on Friday 1 January 2027 from
  that commitment and that history
- **AND** moving that day view to the day before gives the day view started from

#### Scenario: moving across the leap day of a leap year

- **WHEN** a day view is formed on Monday 28 February 2028, from a history that has taken no tick,
  of a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from 1 January
  2026, and it is moved to the day after, handed that same commitment and that same history
- **THEN** the day view moved to is the same day view as one formed on Tuesday 29 February 2028 from
  that commitment and that history
- **AND** moving that day view to the day after in turn gives the day view of Wednesday 1 March 2028

#### Scenario: moving across the end of February in a year that is not a leap year

- **WHEN** a day view is formed on Sunday 28 February 2100, from a history that has taken no tick,
  of a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from 1 January
  2026, and it is moved to the day after, handed that same commitment and that same history
- **THEN** the day view moved to is the same day view as one formed on Monday 1 March 2100 from that
  commitment and that history, 2100 having no leap day
- **AND** moving that day view to the day before gives the day view started from

### Requirement: There is no day before the first supported date and none after the last

A day view of 1 January 1583 SHALL give nothing when moved to the day before, and a day view of
31 December 9999 SHALL give nothing when moved to the day after. Those are the first and last dates
the system forms, so the day beyond either is not a calendar date at all, in the way 30 February is
not one, and a day view of a date that does not exist cannot be given.

Nothing SHALL be given rather than the same day view handed back. A caller that wants to stay where
it is can keep the day view it already holds, and one that needs to know it has reached the end of
the calendar could not recover that from a day view equal to the one it asked with.

The refusal SHALL be about the calendar and about nothing else. It MUST NOT depend on which
commitments the move was handed, on what the history holds, on whether the day view being moved from
has any rows, or on which day the caller believes it is: the same day view moved the other way SHALL
move normally, and every day view of any other date SHALL move both ways.

#### Scenario: the first supported date has no day before it

- **WHEN** a day view is formed on Saturday 1 January 1583, from a history that has taken no tick,
  of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 1583, and it is moved to the day before, handed that same commitment and that same
  history
- **THEN** nothing is given
- **AND** moving that same day view to the day after gives the day view of Sunday 2 January 1583,
  which holds no rows

#### Scenario: the last supported date has no day after it

- **WHEN** a day view is formed on Friday 31 December 9999, from a history that has taken no tick,
  of a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from 1 January
  1583, and it is moved to the day after, handed that same commitment and that same history
- **THEN** nothing is given
- **AND** moving that same day view to the day before gives the day view of Thursday 30 December
  9999, which holds one row named "Vitamins"

#### Scenario: the date one day inside each end of the supported dates moves onto that end

- **WHEN** a day view is formed on Sunday 2 January 1583, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  1583, and it is moved to the day before, handed that same commitment and that same history
- **THEN** the day view moved to is the same day view as one formed on Saturday 1 January 1583 from
  that commitment and that history
- **AND** a day view formed on Thursday 30 December 9999, from a history that has taken no tick, of
  a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from 1 January 1583,
  moved to the day after, is the same day view as one formed on Friday 31 December 9999 from that
  commitment and that history

#### Scenario: the refusal at either end does not depend on what the day view holds

- **WHEN** a day view is formed on Saturday 1 January 1583, from a history that has taken no tick,
  of a commitment named "Run" on a schedule listing Monday and Thursday, kept from 1 January 1583,
  and a second is formed on Friday 31 December 9999, of a commitment named "Vitamins" on a schedule
  listing all seven weekdays, also kept from 1 January 1583, from a history holding a tick for
  "Vitamins" on Friday 31 December 9999
- **THEN** the first holds no rows and gives nothing when moved to the day before
- **AND** the second holds one row saying the commitment is kept and gives nothing when moved to the
  day after
