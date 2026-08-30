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
