## ADDED Requirements

### Requirement: A weekly-quota schedule is due on every date

A commitment whose schedule is a weekly quota — a number of times to be done within a week, on any
days — SHALL be due on every calendar date the system forms. A quota constrains how many times, not
which days, so every day of every week is a day the commitment runs on; the system MUST NOT consider
the weekday the date falls on, which week the date belongs to, where a week begins, how many times
the quota asks for, the current time, the device's time zone or the locale. A quota of one and a
quota of seven therefore answer alike on every date, and both answer alike to a schedule listing all
seven weekdays. Two rules having the same extension is not a contradiction, and this capability does
not resolve one.

**Whether the week's quota has already been met is not a question this capability answers, and this
requirement MUST NOT be read as claiming that it is.** Due-ness here says the day is one on which
the commitment may be done; it does not say the commitment is still outstanding. Answering that
needs a record of what was ticked, which is a question asked of a commitment's history rather than
of a date, and the system SHALL keep it outside this capability: a surface that stops showing a
weekly quota once its week is complete MUST decide that from tick records, not from this predicate.
The consequence is stated rather than hidden — a consumer that draws every due commitment and
nothing else will show a three-times-a-week commitment on all seven days of the week, which is
correct for the first three and unhelpful for the last four.

#### Scenario: a weekly quota is due on every date of a week

- **WHEN** a schedule of 3 times a week is asked about each date from Monday 31 August 2026 through
  Sunday 6 September 2026
- **THEN** the commitment is due on every one of those seven dates

#### Scenario: a weekly quota of one is due on every date of a week

- **WHEN** a schedule of 1 time a week is asked about each date from Monday 31 August 2026 through
  Sunday 6 September 2026
- **THEN** the commitment is due on every one of those seven dates

#### Scenario: a weekly quota is due on the dates either side of a week boundary

- **WHEN** a schedule of 3 times a week is asked about Sunday 6 September 2026
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about Monday 7 September 2026 answers that it is due

#### Scenario: a weekly quota is due on a leap day

- **WHEN** a schedule of 3 times a week is asked about 29 February 2028
- **THEN** the commitment is due on that date

#### Scenario: a weekly quota is due across the turn of a year

- **WHEN** a schedule of 3 times a week is asked about 31 December 2026
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 1 January 2027 answers that it is due

#### Scenario: a weekly quota is due on the first and last dates the system forms

- **WHEN** a schedule of 3 times a week is asked about 1 January 1583
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 31 December 9999 answers that it is due

### Requirement: A weekly quota is a number of times from one to seven

The system SHALL form a weekly quota only from a whole number of times from 1 through 7 inclusive,
and MUST refuse every other number rather than adjust it: zero MUST NOT be read as a commitment with
nothing to do, a negative number names no obligation, and a number above seven MUST NOT be reduced
to seven. A number outside that range names no weekly rhythm, so no schedule may be built on one —
the same refusal, for the same reason, that stops a calendar date being formed from a combination
that names no day.

Seven is the ceiling because a day records at most one completion of a commitment, so a week holds
at most seven of them and an eighth would be a promise no week could ever keep. A quota that can
never be met is the same failure as a commitment that never comes due, which this capability already
refuses elsewhere. A quota of exactly seven is valid and means one completion on each day of the
week.

#### Scenario: a quota below one time a week is not a weekly quota

- **WHEN** the number 0 is offered as a number of times a week
- **THEN** no weekly quota is formed
- **AND** the number −1 offered as a number of times a week forms none either

#### Scenario: a quota of more times a week than the week has days is not a weekly quota

- **WHEN** the number 8 is offered as a number of times a week
- **THEN** no weekly quota is formed

#### Scenario: one time a week is a weekly quota

- **WHEN** the number 1 is offered as a number of times a week
- **THEN** a weekly quota of 1 time a week is formed

#### Scenario: seven times a week is a weekly quota

- **WHEN** the number 7 is offered as a number of times a week
- **THEN** a weekly quota of 7 times a week is formed
