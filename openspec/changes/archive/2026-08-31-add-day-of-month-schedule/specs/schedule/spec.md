## ADDED Requirements

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
