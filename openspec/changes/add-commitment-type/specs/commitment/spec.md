## Purpose

Describes what a commitment is to DayByDay — the name a person gave something they owe themselves,
and the schedule deciding which days it is due on — and how it answers whether it is due on a
calendar date. The `schedule` capability owns the rules; this one owns the thing that carries one,
which is what a screen lists, what a person reads, and what a tick is eventually recorded against.

## ADDED Requirements

### Requirement: A commitment is a name and a schedule

A commitment SHALL be exactly two things: a name, and the schedule that decides which days it is due
on. It SHALL carry nothing else. In particular it has no identifier of its own, no date it was
created on or begins to exist from, no record of what was ticked, no position in a list, and no
state that can be paused or archived — a commitment is what it is made of, and nothing more. The
name it was given SHALL be readable back.

Two commitments SHALL be the same commitment when their name and their schedule are both the same,
and SHALL be different commitments when either differs. This is what "carries nothing else" means
where it can be observed: a commitment holds no hidden identity that would make two commitments a
person would call identical distinguishable to the system.

The system MUST NOT require anything further before a commitment can answer whether it is due. A
start date is carried by the every-N-days schedule shape and by nothing else; a commitment does not
have one of its own, and the requirement below decides due-ness from the schedule alone.

#### Scenario: a commitment reads back the name it was given

- **WHEN** a commitment is formed with the name "Gym" and a schedule listing Monday, Wednesday and
  Saturday
- **THEN** the commitment's name reads back as "Gym"

#### Scenario: two commitments with the same name and the same schedule are the same commitment

- **WHEN** two commitments are formed, both named "Gym" and both on a schedule listing Monday,
  Wednesday and Saturday
- **THEN** the two are the same commitment

#### Scenario: two commitments differing only in name are different commitments

- **WHEN** two commitments are formed on the same schedule listing Monday, Wednesday and Saturday,
  one named "Gym" and one named "Run"
- **THEN** the two are different commitments

#### Scenario: two commitments differing only in schedule are different commitments

- **WHEN** two commitments are formed, both named "Gym", one on a schedule listing Monday and one on
  a schedule listing Tuesday
- **THEN** the two are different commitments

### Requirement: A commitment's name says something

The system SHALL refuse to form a commitment whose name is empty, or whose name is made only of
whitespace, and MUST refuse it rather than adjust it: it MUST NOT trim the name down to nothing and
accept the result, and MUST NOT substitute a placeholder of its own such as "Untitled". A name of
nothing but blank space names nothing, so it picks out no commitment for the person reading a list
of them — the same refusal, for the same reason, that stops a calendar date being formed from a
combination that names no day.

Every other name SHALL be accepted, and SHALL be stored exactly as it was given. There is no upper
bound on a name's length, no restriction on the script it is written in, no character the system
reserves, and no name it rewrites: a commitment's name is the words its owner chose, including any
blank space at the start or the end of them. Tidying what a person typed belongs where they typed
it, not in the rule that decides what a commitment is.

#### Scenario: an empty name is not a commitment

- **WHEN** an empty name and a schedule listing Monday, Wednesday and Saturday are offered as a
  commitment
- **THEN** no commitment is formed

#### Scenario: a name of only whitespace is not a commitment

- **WHEN** a name of three spaces and a schedule listing Monday, Wednesday and Saturday are offered
  as a commitment
- **THEN** no commitment is formed
- **AND** a name of a tab followed by a newline forms none either

#### Scenario: a name with a space at each end is kept as given

- **WHEN** a commitment is formed with the name " Gym " and a schedule listing Monday, Wednesday and
  Saturday
- **THEN** the commitment's name reads back as " Gym ", with both spaces
- **AND** it is a different commitment from one named "Gym" on the same schedule

#### Scenario: a name of a single emoji is a commitment

- **WHEN** a commitment is formed with a name that is the single emoji 🏋️ and a schedule listing
  Monday, Wednesday and Saturday
- **THEN** the commitment's name reads back as that emoji

### Requirement: A commitment is due exactly when its schedule is due

A commitment SHALL be due on a calendar date exactly when the schedule it carries is due on that
date, and SHALL NOT be due on any other date. It adds nothing to that answer and takes nothing away:
the system MUST NOT consider the commitment's name, the current time, the device's time zone, the
locale, whether the commitment has been ticked, or when the commitment came into existence. As
throughout `schedule`, the question is asked of a calendar date rather than of the present moment, so
a date in the past answers the same way today as it did when it was today.

Delegation is the whole of the rule, and it holds for every schedule shape the `schedule` capability
defines and for every shape added to it later, without this requirement changing. It holds equally
for a schedule that is due on no date at all: such a commitment SHALL answer that it is not due,
rather than the system treating it as an error, exactly as `schedule` requires of the schedule
itself.

#### Scenario: a commitment on a weekday-set schedule is due on a listed weekday and not on another

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday is asked
  about Monday 31 August 2026
- **THEN** the commitment is due on that date
- **AND** the same commitment asked about Tuesday 1 September 2026 answers that it is not due

#### Scenario: a commitment on a day-of-month schedule is due on the last day of a month too short for its day

- **WHEN** a commitment named "Finances" on a schedule on the 31st of the month is asked about
  28 February 2027
- **THEN** the commitment is due on that date
- **AND** the same commitment asked about 1 March 2027 answers that it is not due

#### Scenario: a commitment on an every-N-days schedule is due on its start date and not on the day before it

- **WHEN** a commitment named "Contact lenses" on a schedule of every 14 days starting on 25 August
  2026 is asked about 25 August 2026
- **THEN** the commitment is due on that date
- **AND** the same commitment asked about 24 August 2026 answers that it is not due

#### Scenario: two commitments with different names and the same schedule are due on the same dates

- **WHEN** a commitment named "Gym" and a commitment named "Run", both on a schedule listing Monday,
  Wednesday and Saturday, are each asked about every date from Monday 31 August through Sunday
  6 September 2026
- **THEN** the two answer identically on all seven dates — due on 31 August, 2 September and
  5 September 2026, and not due on the other four

#### Scenario: a commitment on a schedule that is due on no date is never due

- **WHEN** a commitment named "Gym" on a schedule listing no weekday at all is asked about each date
  from Monday 31 August through Sunday 6 September 2026
- **THEN** the commitment is due on none of those seven dates
