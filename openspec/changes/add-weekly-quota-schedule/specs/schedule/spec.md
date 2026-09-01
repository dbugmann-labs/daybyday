## ADDED Requirements

### Requirement: A weekly-quota schedule is due on every date

A commitment whose schedule is a weekly quota of N completions SHALL be due on every calendar date
the system forms, and SHALL NOT decline any date. The quota says how many times within a week the
commitment is owed; it says nothing about which days it is owed on, because a commitment on this
shape is one whose owner has deliberately not chosen days. Three times a week is any three days of
that week, so every day of it is a day the commitment may be done, and every day therefore asks.

The system MUST NOT derive days from the count: a quota of three is not Monday, Wednesday and
Friday, nor the first three days of the week, nor any other selection. It MUST NOT consider the
weekday the date falls on, the day of the month, the current time, the device's time zone or the
locale. The shape is anchored to no start date and to no first week — like the weekday-set and
day-of-month shapes and unlike every N days, it carries no date of its own, so it is due in both
directions for as long as the supported year range allows a date to be formed.

Two consequences are part of this requirement rather than accidents of it, and are stated here
because a reader will otherwise take them for defects.

**The count does not reach this answer.** Two weekly-quota schedules that differ only in their
number are due on exactly the same dates. The number is not dead — it is the size of the obligation
the week carries, and it is what a screen will subtract completions from — but it is not a fact
about any one date, and the system MUST NOT let it become one.

**Whether the quota has already been met is not this capability's question.** A commitment that has
been read three times this week still answers *due* on the week's remaining dates, because this
capability decides which days a commitment may be done on and nothing else. Answering otherwise
would require the week's ticks, which no requirement in this system has yet created, and would make
a past date's answer change after it was given: ask on Thursday whether Monday was due, having
ticked Monday, Tuesday and Wednesday, and a satisfaction-aware rule says no about a day it said yes
about at the time. `CONTEXT.md` fixes due-ness as a question asked of a date rather than of the
present moment, and a writable past depends on that answer staying put. Closing the row once the
week's quota is met is a real and wanted behaviour; it belongs above this seam, to whatever
capability owns ticks, and this requirement is what keeps the boundary legible.

#### Scenario: a weekly quota is due on every one of seven consecutive dates

- **WHEN** a schedule of a quota of 3 completions a week is asked about each date from Monday
  31 August 2026 through Sunday 6 September 2026
- **THEN** the commitment is due on every one of those seven dates

#### Scenario: a quota of one and a quota of seven are due on the same seven dates

- **WHEN** a schedule of a quota of 1 completion a week and a schedule of a quota of 7 completions a
  week are each asked about every date from Monday 31 August 2026 through Sunday 6 September 2026
- **THEN** the two schedules give the same answer on every one of those seven dates
- **AND** that answer is that the commitment is due

#### Scenario: a weekly quota is due on a date that a weekday set of the same size would miss

- **WHEN** a schedule of a quota of 3 completions a week is asked about Tuesday 1 September 2026
- **THEN** the commitment is due on that date
- **AND** a schedule listing Monday, Wednesday and Friday asked about the same date answers that it
  is not due

#### Scenario: a weekly quota is due on the leap day of a leap year

- **WHEN** a schedule of a quota of 3 completions a week is asked about 29 February 2028
- **THEN** the commitment is due on that date

#### Scenario: a weekly quota is due on the first and the last date the system forms

- **WHEN** a schedule of a quota of 3 completions a week is asked about 1 January 1583
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 31 December 9999 answers that it is due

### Requirement: A weekly quota is a number of completions from one to seven

The system SHALL form a weekly quota only from a whole number of completions from 1 through 7
inclusive, and MUST refuse every other number rather than adjust it: a number above 7 MUST NOT be
reduced to 7, and zero and negative numbers MUST NOT be read as "no obligation" or as an obligation
running the other way. A number outside that range names no weekly obligation, so no schedule may be
built on one — the same refusal, for the same reason, that stops a calendar date being formed from a
combination that names no day.

Seven is the ceiling because a completion is recorded once per commitment per day: a week holds
seven days, so it cannot hold an eighth completion for a rule of this shape, and a number that can
never be reached would be an obligation guaranteed to be missed. One is the floor because a quota of
none is not a rhythm — a commitment owed zero times a week is a commitment that was not made.

#### Scenario: a quota of three completions a week is a weekly quota

- **WHEN** the number 3 is offered as a weekly quota
- **THEN** a weekly quota of 3 completions a week is formed

#### Scenario: a quota of seven completions a week is a weekly quota

- **WHEN** the number 7 is offered as a weekly quota
- **THEN** a weekly quota of 7 completions a week is formed

#### Scenario: a quota above seven completions a week is not a weekly quota

- **WHEN** the number 8 is offered as a weekly quota
- **THEN** no weekly quota is formed

#### Scenario: a quota of no completions a week is not a weekly quota

- **WHEN** the number 0 is offered as a weekly quota
- **THEN** no weekly quota is formed
- **AND** the number −1 offered as a weekly quota forms none either
