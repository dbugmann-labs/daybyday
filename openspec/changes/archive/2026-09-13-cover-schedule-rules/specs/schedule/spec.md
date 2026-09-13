## MODIFIED Requirements

### Requirement: The weekday of a calendar date follows the Gregorian calendar

The system SHALL determine which weekday a calendar date falls on from the Gregorian calendar and
from nothing else, for every calendar date it accepts. This MUST hold on the leap day of a leap year
and across the turn of a year. The answer MUST NOT vary with the host's time zone or locale.

#### Scenario: a leap day is placed on its Gregorian weekday

- **WHEN** a schedule listing only Tuesday is asked about Tuesday 29 February 2028
- **THEN** the commitment is due on that date
- **AND** a schedule listing only Monday asked about the same date answers that it is not due

#### Scenario: the first day of a year is placed on its Gregorian weekday

- **WHEN** a schedule listing only Friday is asked about Friday 1 January 2027
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about Thursday 31 December 2026 answers that it is not due

#### Scenario: the first and last dates the system forms are placed on their Gregorian weekdays

- **WHEN** a schedule listing only Saturday is asked about Saturday 1 January 1583
- **THEN** the commitment is due on that date
- **AND** a schedule listing only Tuesday, the weekday the Julian calendar gives that date, asked
  about the same date answers that it is not due
- **AND** a schedule listing only Friday asked about Friday 31 December 9999 answers that it is due
- **AND** a schedule listing only Monday, the weekday the Julian calendar gives that date, asked
  about the same date answers that it is not due

### Requirement: A month too short for the scheduled day is due on its last day

When a month has fewer days than the scheduled day of the month, the commitment SHALL be due on the
last day of that month, MUST NOT be skipped in that month, and MUST NOT roll into the month after.
The last day SHALL be taken from that particular month's true length, 28 or 29 days of February by
whether the year is a leap year and 30 of a thirty-day month, and MUST NOT be taken from a fixed
shortest month. A month long enough to hold the scheduled day SHALL be untouched by this rule: the
commitment SHALL be due on the scheduled day itself and on no other date in that month.

In a common February, schedules on the 28th, 29th, 30th and 31st SHALL all be due on the same date,
and the system MUST NOT treat that as a collision to be resolved.

#### Scenario: a schedule on the thirty-first is due on the last day of a thirty-day month

- **WHEN** a schedule on the 31st of the month is asked about 30 September 2026
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 29 September 2026 answers that it is not due

#### Scenario: a schedule on the thirty-first is due on the last day of a common February

- **WHEN** a schedule on the 31st of the month is asked about 28 February 2027
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 1 March 2027 answers that it is not due

#### Scenario: a schedule on the thirty-first is due on the leap day of a leap February

- **WHEN** a schedule on the 31st of the month is asked about 29 February 2028
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 28 February 2028 answers that it is not due

#### Scenario: a schedule on the twenty-ninth is due on the last day of a common February

- **WHEN** a schedule on the 29th of the month is asked about 28 February 2027
- **THEN** the commitment is due on that date

#### Scenario: a schedule on the thirty-first is not moved in a month that has a thirty-first

- **WHEN** a schedule on the 31st of the month is asked about 31 August 2026
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 30 August 2026 answers that it is not due

#### Scenario: schedules on the twenty-eighth through the thirty-first are all due on the last day of a common February

- **WHEN** schedules on the 28th, the 29th, the 30th and the 31st of the month are each asked about
  28 February 2027
- **THEN** all four commitments are due on that date
- **AND** each of the four asked about 27 February 2027 answers that it is not due
- **AND** each of the four asked about 1 March 2027 answers that it is not due

### Requirement: An every-N-days schedule is due on its start date and every interval after it

A commitment whose schedule is an interval of days SHALL be due on a calendar date exactly when that
date is the schedule's start date or falls a whole number of intervals after it, and SHALL NOT be
due on any other date.

The count SHALL be of calendar days, every day counting once and the leap day of a leap year
included, and MUST NOT vary by the length of the months the two dates fall in, the weekday either
falls on, the turn of a year, the current time, the device's time zone or the locale. The rule SHALL
repeat forward without end while the supported years allow a date to be formed, with no month, week
or year resetting it and no final occurrence. An interval longer than the supported years SHALL be
answered as *An interval is a whole number of days, at least one* says.

#### Scenario: a schedule is due on its start date

- **WHEN** a schedule of every 3 days starting on 31 August 2026 is asked about 31 August 2026
- **THEN** the commitment is due on that date

#### Scenario: a date one interval after the start date is due

- **WHEN** a schedule of every 3 days starting on 31 August 2026 is asked about 3 September 2026
- **THEN** the commitment is due on that date

#### Scenario: a date between two due dates is not due

- **WHEN** a schedule of every 3 days starting on 31 August 2026 is asked about 1 September 2026
- **THEN** the commitment is not due on that date
- **AND** the same schedule asked about 2 September 2026 answers that it is not due

#### Scenario: an every-N-days schedule is due on exactly five dates across a fortnight

- **WHEN** a schedule of every 3 days starting on 31 August 2026 is asked about each date from
  31 August through 13 September 2026
- **THEN** the commitment is due on exactly five of those fourteen dates — 31 August, 3, 6, 9 and
  12 September 2026

#### Scenario: the interval counts across the end of a month

- **WHEN** a schedule of every 14 days starting on 25 August 2026 is asked about 8 September 2026
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 25 September 2026 answers that it is not due

#### Scenario: the interval counts a leap day as a day

- **WHEN** a schedule of every 3 days starting on 26 February 2028 is asked about 29 February 2028
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 1 March 2028 answers that it is not due

#### Scenario: the interval counts across the turn of a year

- **WHEN** a schedule of every 7 days starting on 28 December 2026 is asked about 4 January 2027
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 1 January 2027 answers that it is not due

#### Scenario: an interval of one day is due on every date

- **WHEN** a schedule of every 1 day starting on 31 August 2026 is asked about each date from
  31 August through 6 September 2026
- **THEN** the commitment is due on every one of those seven dates

#### Scenario: an interval longer than the supported years is due only on its start date

- **WHEN** a schedule of every 4,000,000 days starting on 1 January 1583 is asked about 1 January
  1583
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 2 January 1583 answers that it is not due
- **AND** the same schedule asked about 31 December 9999, the last date the system forms, answers
  that it is not due

#### Scenario: an every-N-days schedule is still due near the last date the system forms

- **WHEN** a schedule of every 3 days starting on 31 August 2026 is asked about 30 December 9999
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 31 December 9999 answers that it is not due

### Requirement: An every-N-days schedule is not due before its start date

A commitment whose schedule is an interval of days SHALL NOT be due on any calendar date earlier
than its start date. The system MUST NOT project the interval backwards: a date a whole number of
intervals before the start date SHALL NOT be due, and neither SHALL any other earlier date. The
weekday-set and day-of-month shapes SHALL be anchored to the calendar rather than to a start, and
SHALL remain due on every date they match in either direction.

#### Scenario: a date a whole interval before the start date is not due

- **WHEN** a schedule of every 3 days starting on 3 September 2026 is asked about 31 August 2026
- **THEN** the commitment is not due on that date
- **AND** the same schedule asked about 22 August 2026, four intervals earlier still, answers that
  it is not due

#### Scenario: an every-N-days schedule is due on none of the seven dates before its start date

- **WHEN** a schedule of every 3 days starting on 31 August 2026 is asked about each date from
  24 through 30 August 2026
- **THEN** the commitment is due on none of those seven dates

#### Scenario: a weekday-set and a day-of-month schedule are due on the dates they match at both ends of the supported years

- **WHEN** a schedule listing only Monday is asked about Monday 3 January 1583 and about Monday
  27 December 9999
- **THEN** the commitment is due on both dates
- **AND** a schedule on the 1st of the month asked about 1 January 1583 and about 1 December 9999
  answers that it is due on both
