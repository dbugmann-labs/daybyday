## ADDED Requirements

### Requirement: An every-N-days schedule is due on its start date and every interval after it

A commitment whose schedule is an interval of days SHALL be due on a calendar date exactly when that
date is the schedule's start date, or falls a whole number of intervals after it — when the number of
days from the start date to the date is zero, or an exact multiple of the interval. It SHALL NOT be
due on any other date.

The count is a count of calendar days, and every day counts once: the leap day of a leap year is a
day of the interval like any other, and the system MUST NOT vary the count by the length of the
months the two dates fall in, by the weekday either falls on, by the turn of a year, by the current
time, by the device's time zone or by the locale. The rule repeats forward without end for as long
as the supported year range allows a date to be formed; no month, week or year resets it, and there
is no final occurrence.

Both the start date and the date asked about are calendar dates, so both already carry the validity
and supported-year rules above and this requirement adds nothing to them.

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

### Requirement: An every-N-days schedule is not due before its start date

A commitment whose schedule is an interval of days SHALL NOT be due on any calendar date earlier
than its start date. The system MUST NOT project the interval backwards: a date a whole number of
intervals before the start date is not due, and neither is any other earlier date. The start date is
where the rule begins, not a phase reference for arithmetic that runs in both directions.

This is what stops the product inventing a history. A commitment is decided on some day, and the
days before it are days on which nothing had been committed to; because an unticked due day reads as
a day the commitment was missed, a rule that reached backwards would fill the past with misses that
never happened, on a screen whose whole purpose is to show what was actually kept.

The interval is the only rule shape this can be said of, because it is the only one carrying a date
of its own. The weekday-set and day-of-month shapes are anchored to the calendar rather than to a
start, and remain due on every date they match in either direction; this requirement does not change
them.

#### Scenario: a date a whole interval before the start date is not due

- **WHEN** a schedule of every 3 days starting on 3 September 2026 is asked about 31 August 2026
- **THEN** the commitment is not due on that date
- **AND** the same schedule asked about 22 August 2026, four intervals earlier still, answers that
  it is not due

#### Scenario: an every-N-days schedule is due on none of the seven dates before its start date

- **WHEN** a schedule of every 3 days starting on 31 August 2026 is asked about each date from
  24 through 30 August 2026
- **THEN** the commitment is due on none of those seven dates

### Requirement: An interval is a whole number of days, at least one

The system SHALL form an interval only from a whole number of days of one or more, and MUST refuse
zero and every negative number rather than adjust them: zero MUST NOT be read as "every day", and a
negative number MUST NOT be read as an interval running backwards. A number outside that range names
no rhythm, so no schedule may be built on one — the same refusal, for the same reason, that stops a
calendar date being formed from a combination that names no day.

An interval of one day is valid, and means a commitment due on every date from its start date
onwards. There is no upper bound: a number of days larger than the entire supported range of years
names a schedule that comes due on its start date and never again, which is a defined answer rather
than an error, and the system MUST give that answer rather than refusing the interval or losing the
arithmetic to overflow.

#### Scenario: an interval of no days is not an interval

- **WHEN** the number 0 is offered as an interval of days
- **THEN** no interval is formed

#### Scenario: an interval of a negative number of days is not an interval

- **WHEN** the number −3 is offered as an interval of days
- **THEN** no interval is formed
- **AND** the number −1 offered as an interval of days forms none either

#### Scenario: an interval of one day is an interval

- **WHEN** the number 1 is offered as an interval of days
- **THEN** an interval of 1 day is formed
