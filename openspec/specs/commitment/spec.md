# commitment Specification

## Purpose

Describes what a commitment is to DayByDay — the name a person gave something they owe themselves,
the schedule deciding which days it is due on, and the day from which they have been keeping it —
and how it answers whether it is due on a calendar date. The `schedule` capability owns the rules;
this one owns the thing that carries one, which is what a screen lists, what a person reads, and
what a tick is eventually recorded against.

## Requirements

### Requirement: A commitment is a name, a schedule, and the day it is kept from

A commitment SHALL be exactly three things: a name, the schedule that decides which days it is due
on, and the calendar date from which it is kept. It SHALL carry nothing else. In particular it has
no identifier of its own, no record of what was ticked, no position in a list, and no state that can
be paused or archived — a commitment is what it is made of, and nothing more. The name it was given
SHALL be readable back.

All three SHALL be required. The system MUST NOT form a commitment without a day it is kept from,
and MUST NOT supply one of its own in place of a missing one: it cannot know what day it is, because
the present moment is not something this capability is allowed to consult, and a default of any
other kind would be a guess about a person's history.

Two commitments SHALL be the same commitment when their name, their schedule and the day they are
kept from are all the same, and SHALL be different commitments when any of the three differs. This
is what "carries nothing else" means where it can be observed: a commitment holds no hidden identity
that would make two commitments a person would call identical distinguishable to the system.

The day a commitment is kept from is a calendar date, so it already names a day that exists inside
the supported years and needs no validity rule of its own here. It is deliberately not a record of
when the commitment was entered into the app: a person who has been going to the gym since June may
say so, and the day they are keeping it from is then in the past.

#### Scenario: a commitment reads back the name it was given

- **WHEN** a commitment is formed with the name "Gym", a schedule listing Monday, Wednesday and
  Saturday, and kept from 1 January 2026
- **THEN** the commitment's name reads back as "Gym"

#### Scenario: two commitments alike in name, schedule and kept-from day are the same commitment

- **WHEN** two commitments are formed, both named "Gym", both on a schedule listing Monday,
  Wednesday and Saturday, and both kept from 1 January 2026
- **THEN** the two are the same commitment

#### Scenario: two commitments differing only in name are different commitments

- **WHEN** two commitments are formed on the same schedule listing Monday, Wednesday and Saturday
  and kept from the same 1 January 2026, one named "Gym" and one named "Run"
- **THEN** the two are different commitments

#### Scenario: two commitments differing only in schedule are different commitments

- **WHEN** two commitments are formed, both named "Gym" and both kept from 1 January 2026, one on a
  schedule listing Monday and one on a schedule listing Tuesday
- **THEN** the two are different commitments

#### Scenario: two commitments differing only in the day they are kept from are different commitments

- **WHEN** two commitments are formed, both named "Gym" and both on a schedule listing Monday,
  Wednesday and Saturday, one kept from 1 January 2026 and one kept from 2 January 2026
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

- **WHEN** an empty name, a schedule listing Monday, Wednesday and Saturday, and 1 January 2026 as
  the day it is kept from are offered as a commitment
- **THEN** no commitment is formed

#### Scenario: a name of only whitespace is not a commitment

- **WHEN** a name of three spaces, a schedule listing Monday, Wednesday and Saturday, and 1 January
  2026 as the day it is kept from are offered as a commitment
- **THEN** no commitment is formed
- **AND** a name of a tab followed by a newline forms none either

#### Scenario: a name with a space at each end is stored exactly as given

- **WHEN** a commitment is formed with the name " Gym ", a schedule listing Monday, Wednesday and
  Saturday, and kept from 1 January 2026
- **THEN** the commitment's name reads back as " Gym ", with both spaces
- **AND** it is a different commitment from one named "Gym" alike in every other way

#### Scenario: a name of a single emoji is a commitment

- **WHEN** a commitment is formed with a name that is the single emoji 🏋️, a schedule listing
  Monday, Wednesday and Saturday, and kept from 1 January 2026
- **THEN** the commitment's name reads back as that emoji

### Requirement: A commitment is due exactly when its schedule is due, on and after the day it is kept from

On the day a commitment is kept from and on every date after it, the commitment SHALL be due exactly
when the schedule it carries is due on that date, and SHALL NOT be due on any other such date. It
adds nothing to its schedule's answer and takes nothing away: the system MUST NOT consider the
commitment's name, the current time, the device's time zone, the locale, or whether the commitment
has been ticked. As throughout `schedule`, the question is asked of a calendar date rather than of
the present moment, so a date in the past answers the same way today as it did when it was today.

Delegation is the whole of the rule from that day onwards, and it holds for every schedule shape the
`schedule` capability defines and for every shape added to it later, without this requirement
changing. It holds equally for a schedule that is due on no date at all: such a commitment SHALL
answer that it is not due, rather than the system treating it as an error, exactly as `schedule`
requires of the schedule itself.

#### Scenario: a commitment on a weekday-set schedule is due on a listed weekday and not on another

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is asked about Monday 31 August 2026
- **THEN** the commitment is due on that date
- **AND** the same commitment asked about Tuesday 1 September 2026 answers that it is not due

#### Scenario: a commitment on a day-of-month schedule is due on the last day of a month too short for its day

- **WHEN** a commitment named "Finances" on a schedule on the 31st of the month, kept from 1 January
  2026, is asked about 28 February 2027
- **THEN** the commitment is due on that date
- **AND** the same commitment asked about 1 March 2027 answers that it is not due

#### Scenario: a commitment on an every-N-days schedule is due on its start date and not on the day before it

- **WHEN** a commitment named "Contact lenses" on a schedule of every 14 days starting on 25 August
  2026, kept from that same 25 August 2026, is asked about 25 August 2026
- **THEN** the commitment is due on that date
- **AND** the same commitment asked about 24 August 2026 answers that it is not due

#### Scenario: two commitments with different names and the same schedule are due on the same dates

- **WHEN** a commitment named "Gym" and a commitment named "Run", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are each asked about every date from
  Monday 31 August through Sunday 6 September 2026
- **THEN** the two answer identically on all seven dates — due on 31 August, 2 September and
  5 September 2026, and not due on the other four

#### Scenario: a commitment on a schedule that is due on no date is never due

- **WHEN** a commitment named "Gym" on a schedule listing no weekday at all, kept from 1 January
  2026, is asked about each date from Monday 31 August through Sunday 6 September 2026
- **THEN** the commitment is due on none of those seven dates

### Requirement: A commitment is not due before the day it is kept from

A commitment SHALL NOT be due on any calendar date earlier than the day it is kept from, whatever
its schedule says about that date. The day it is kept from is where the commitment begins to be
owed; the dates before it are dates on which nothing had been committed to, and the system MUST NOT
answer that a commitment was due on one of them.

This is what stops the product inventing a history of failures. Because an unticked due day reads as
a day the commitment was missed, a rule anchored only to the calendar would fill every earlier year
with misses nobody could ever have avoided: a commitment on Mondays, Wednesdays and Saturdays, kept
from this week, would otherwise answer *due* for every such day back to the first year the system
supports. A record of what was actually kept cannot open with a fabricated one.

The rule applies to every schedule shape alike, and it is a floor rather than a phase: the day a
commitment is kept from does not have to be a day its schedule is due on, and it does not shift the
schedule to begin there. When the schedule is an interval of days, its own start date and this floor
are separate and both apply — the interval decides which dates the rhythm lands on, this requirement
decides that landings before the floor are not due, and a start date earlier than the floor is
therefore a rhythm whose first occurrences are simply never owed.

#### Scenario: a commitment is not due on a date before the day it is kept from

- **WHEN** a commitment on a schedule listing Monday, Wednesday and Saturday, kept from Wednesday
  2 September 2026, is asked about Monday 31 August 2026
- **THEN** the commitment is not due on that date, though its schedule is due on it
- **AND** the same commitment asked about Wednesday 2 September 2026 answers that it is due

#### Scenario: a commitment is due on the day it is kept from when its schedule is due that day

- **WHEN** a commitment on a schedule listing Monday, Wednesday and Saturday, kept from Monday
  31 August 2026, is asked about Monday 31 August 2026
- **THEN** the commitment is due on that date

#### Scenario: a commitment is not due on the day it is kept from when its schedule is not due that day

- **WHEN** a commitment on a schedule listing Monday, Wednesday and Saturday, kept from Tuesday
  1 September 2026, is asked about Tuesday 1 September 2026
- **THEN** the commitment is not due on that date
- **AND** the same commitment asked about Wednesday 2 September 2026 answers that it is due

#### Scenario: a commitment is due on none of the dates in the month before it is kept from

- **WHEN** a commitment on a schedule on the 25th of the month, kept from 1 September 2026, is asked
  about each date from 1 through 31 August 2026
- **THEN** the commitment is due on none of those thirty-one dates
- **AND** the same commitment asked about 25 September 2026 answers that it is due

#### Scenario: an every-N-days occurrence before the day it is kept from is not due

- **WHEN** a commitment on a schedule of every 3 days starting on 25 August 2026, kept from
  1 September 2026, is asked about 28 August 2026
- **THEN** the commitment is not due on that date, though the interval lands on it
- **AND** the same commitment asked about 31 August 2026, the next landing before the floor, answers
  that it is not due
- **AND** the same commitment asked about 3 September 2026 answers that it is due
