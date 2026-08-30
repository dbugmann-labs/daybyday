## Purpose

Describes how DayByDay decides whether a commitment is due on a given day. It is the contract
every screen and every stored tick rests on: the day list asks this question of each commitment
before it draws a row, and it asks it of a date rather than of the present moment, so that a day
in the past answers the same way today as it did when it was today.

## ADDED Requirements

### Requirement: A weekday-set schedule is due on the weekdays it lists

A commitment whose schedule is a set of weekdays SHALL be due on a calendar date exactly when
the weekday of that date is a member of the set, and SHALL NOT be due on any other date.
Membership is the whole rule: the system MUST NOT consider the current time, the device's time
zone, the locale, or which day the user considers the week to begin on. A set that lists every
weekday is therefore due on every date, and a set that lists no weekday is due on none — the
system MUST answer both rather than treat either as an error.

#### Scenario: a date on a listed weekday is due

- **WHEN** a schedule listing Monday, Wednesday and Saturday is asked about Monday 31 August 2026
- **THEN** the commitment is due on that date

#### Scenario: a date on an unlisted weekday is not due

- **WHEN** a schedule listing Monday, Wednesday and Saturday is asked about Tuesday 1 September 2026
- **THEN** the commitment is not due on that date

#### Scenario: a schedule listing every weekday is due on seven consecutive dates

- **WHEN** a schedule listing all seven weekdays is asked about each date from Monday 31 August
  2026 through Sunday 6 September 2026
- **THEN** the commitment is due on every one of those seven dates

#### Scenario: a schedule listing no weekday is due on none of seven consecutive dates

- **WHEN** a schedule listing no weekday at all is asked about each date from Monday 31 August
  2026 through Sunday 6 September 2026
- **THEN** the commitment is due on none of those seven dates

#### Scenario: a Sunday-only schedule is due on Sunday and not on Saturday

- **WHEN** a schedule listing only Sunday is asked about Sunday 6 September 2026
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about Saturday 5 September 2026 answers that it is not due

### Requirement: The weekday of a calendar date follows the Gregorian calendar

The system SHALL determine which weekday a calendar date falls on from the Gregorian calendar
and from nothing else, for every calendar date it accepts. This MUST hold across the boundaries
where a wrong answer is easiest to produce and hardest to notice: the leap day of a leap year,
and the turn of a year. The answer MUST NOT vary with the host's time zone or locale, which it
cannot, because a calendar date carries neither.

#### Scenario: a leap day is placed on its Gregorian weekday

- **WHEN** a schedule listing only Tuesday is asked about Tuesday 29 February 2028
- **THEN** the commitment is due on that date
- **AND** a schedule listing only Monday asked about the same date answers that it is not due

#### Scenario: the first day of a year is placed on its Gregorian weekday

- **WHEN** a schedule listing only Friday is asked about Friday 1 January 2027
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about Thursday 31 December 2026 answers that it is not due

### Requirement: A calendar date names a day that exists

A calendar date is a year, a month of that year and a day of that month. The system SHALL refuse
to form a calendar date from a combination of the three that names no day, and MUST refuse it
rather than adjust it: a day past the end of its month MUST NOT become a day of the following
month, and a month past the twelfth MUST NOT become a month of the following year. A date that
does not exist has no weekday, so no schedule may be asked about one.

#### Scenario: a day beyond the end of its month is not a calendar date

- **WHEN** the year 2026, the month February and the day 30 are offered as a calendar date
- **THEN** no calendar date is formed
- **AND** in particular 2 March 2026 is not formed in its place

#### Scenario: the twenty-ninth of February in a common year is not a calendar date

- **WHEN** the year 2027, the month February and the day 29 are offered as a calendar date
- **THEN** no calendar date is formed

#### Scenario: the twenty-ninth of February in a leap year is a calendar date

- **WHEN** the year 2028, the month February and the day 29 are offered as a calendar date
- **THEN** a calendar date is formed for 29 February 2028

#### Scenario: a month outside the twelve is not a calendar date

- **WHEN** the year 2026, the month 13 and the day 1 are offered as a calendar date
- **THEN** no calendar date is formed
- **AND** in particular 1 January 2027 is not formed in its place
