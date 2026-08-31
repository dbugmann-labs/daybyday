# schedule Specification

## Purpose
Describes how DayByDay decides whether a commitment is due on a given day. It is the contract
every screen and every stored tick rests on: the day list asks this question of each commitment
before it draws a row, and it asks it of a date rather than of the present moment, so that a day
in the past answers the same way today as it did when it was today.

## Requirements

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

The system SHALL also judge each of the three components as the number it was offered, and MUST
NOT accept a date in which a component was treated as absent or unspecified because its value was
extreme. A date with a component missing is not three numbers, so it names no day either.

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

#### Scenario: a month of the largest representable integer is not a calendar date

- **WHEN** the year 2026, the largest integer the platform can represent offered as a month, and
  the day 1 are offered as a calendar date
- **THEN** no calendar date is formed

#### Scenario: a year of the largest representable integer is not a calendar date

- **WHEN** the largest integer the platform can represent offered as a year, the month January and
  the day 1 are offered as a calendar date
- **THEN** no calendar date is formed

#### Scenario: a day of the largest representable integer is not a calendar date

- **WHEN** the year 2026, the month January and the largest integer the platform can represent
  offered as a day are offered as a calendar date
- **THEN** no calendar date is formed

### Requirement: A calendar date lies within the years the system supports

The system SHALL form a calendar date only for a year from 1583 through 9999 inclusive, and SHALL
refuse every year outside that range even when the three components name a day that plainly
exists. The refusal MUST be a refusal rather than an adjustment: a year outside the range MUST NOT
be clamped to the nearest supported year, and no schedule may be asked about a date the system
declines to form.

The lower bound is what makes the Gregorian promise above keepable, and it is drawn at a whole
year on purpose. The Gregorian calendar was adopted on 15 October 1582, and a calendar reaching
back past that day applies the Julian one before it, which places a date before the reform on a
weekday the Gregorian calendar does not give it. The reform fell inside a year, so 1583 is the
first year that is Gregorian throughout, and the system refuses the whole of 1582 rather than the
part of it that precedes 15 October. That over-refuses the seventy-eight days from 15 October to
31 December 1582, whose weekdays it could in fact have answered correctly. It is refused anyway,
because the bound is then a comparison of years, and eleven weeks of the sixteenth century are
worth nothing to a product about commitments a person keeps this month.

The upper bound keeps the year inside a range the system judges for itself, so that no year large
enough to be read back as unspecified reaches the calendar underneath — the month and the day are
bounded by the requirement above, not by this one. A four-digit year is well past the horizon of
any commitment a person keeps.

#### Scenario: a date before the Gregorian calendar's adoption is not a calendar date

- **WHEN** the year 1500, the month January and the day 1 are offered as a calendar date
- **THEN** no calendar date is formed

#### Scenario: the last day before the first full Gregorian year is not a calendar date

- **WHEN** the year 1582, the month December and the day 31 are offered as a calendar date
- **THEN** no calendar date is formed

#### Scenario: the first day of the first full Gregorian year is a calendar date

- **WHEN** the year 1583, the month January and the day 1 are offered as a calendar date
- **THEN** a calendar date is formed for 1 January 1583

#### Scenario: the last day of the last supported year is a calendar date

- **WHEN** the year 9999, the month December and the day 31 are offered as a calendar date
- **THEN** a calendar date is formed for 31 December 9999

#### Scenario: a year past the last supported year is not a calendar date

- **WHEN** the year 10000, the month January and the day 1 are offered as a calendar date
- **THEN** no calendar date is formed

### Requirement: A day-of-month schedule is due on that day of the month

A commitment whose schedule is a day of the month SHALL be due on a calendar date exactly when the
day of the month that date falls on is the scheduled day, and SHALL NOT be due on any other date,
save where the next requirement places it on the last day of a month too short to hold it. The rule
is monthly and unbounded: it repeats in every month of every year the system supports, it is
anchored to no start month, and the system MUST NOT consider the weekday the date falls on, the
current time, the device's time zone or the locale. Exactly one date in any month therefore
satisfies a day-of-month schedule — never none, and never two.

#### Scenario: a date on the scheduled day of the month is due

- **WHEN** a schedule on the 25th of the month is asked about 25 September 2026
- **THEN** the commitment is due on that date

#### Scenario: a date on another day of the same month is not due

- **WHEN** a schedule on the 25th of the month is asked about 24 September 2026
- **THEN** the commitment is not due on that date
- **AND** the same schedule asked about 26 September 2026 answers that it is not due

#### Scenario: a day-of-month schedule is due on exactly one date across a whole month

- **WHEN** a schedule on the 25th of the month is asked about each date from 1 through 30 September
  2026
- **THEN** the commitment is due on exactly one of those thirty dates, 25 September 2026

#### Scenario: a schedule on the first is due on the first of a month and not on the last day of the month before

- **WHEN** a schedule on the 1st of the month is asked about 1 September 2026
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 31 August 2026 answers that it is not due

### Requirement: A month too short for the scheduled day is due on its last day

When a month has fewer days than the scheduled day of the month, the commitment SHALL be due on the
last day of that month. It MUST NOT be skipped in that month, and it MUST NOT roll into the month
after: a schedule on the 31st is due on 28 February and not on 3 March. The last day is the true
length of that particular month — 28 or 29 days of February according to whether the year is a leap
year, 30 days of the four short months — so the system MUST NOT substitute a fixed shortest month.
A month long enough to hold the scheduled day is untouched by this rule: the commitment is due on
the scheduled day itself and on no other date in that month.

This is what keeps a monthly commitment monthly. A schedule on the 31st that were simply absent from
February, April, June, September and November would come due in seven months of the year and pass
five of them in silence, and a commitment that quietly never comes due is the failure this product
exists to remove. The consequence is accepted rather than hidden: in a common February, schedules on
the 28th, 29th, 30th and 31st all fall on the same date, which is the correct reading of "the end of
every month" and not a collision to be resolved.

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

### Requirement: A day of the month is a number from the first to the thirty-first

The system SHALL form a day of the month only from a number from 1 through 31 inclusive, and MUST
refuse every other number rather than adjust it: a number past 31 MUST NOT be reduced to the end of
a month, and a number below 1 MUST NOT be read as counting backwards from the end of one. A number
outside that range names no day of any month, so no schedule may be built on one — the same refusal,
for the same reason, that stops a calendar date being formed from a combination that names no day.

#### Scenario: a day of the month past the thirty-first is not a day of the month

- **WHEN** the number 32 is offered as a day of the month
- **THEN** no day of the month is formed

#### Scenario: a day of the month below the first is not a day of the month

- **WHEN** the number 0 is offered as a day of the month
- **THEN** no day of the month is formed
- **AND** the number −1 offered as a day of the month forms none either

#### Scenario: the thirty-first is a day of the month

- **WHEN** the number 31 is offered as a day of the month
- **THEN** a day of the month is formed for the 31st

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
