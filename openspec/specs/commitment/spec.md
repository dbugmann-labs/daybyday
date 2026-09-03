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

### Requirement: A roster holds the commitments a person keeps, in the order they were taken on

A roster SHALL hold commitments, in the order they were added to it, and SHALL read them back in
that order. A roster that has been given no commitment SHALL hold none, and SHALL be an answer
rather than a refusal: a person who keeps nothing yet has an empty roster, not a missing one.
There SHALL be no upper bound on how many commitments a roster holds.

The order SHALL be the order they were taken on and nothing else. A roster MUST NOT sort its
commitments by name, by the day each is kept from, by the schedule each runs on, or by any other
property of them. It has no order of its own to invent: day one's commitments are all kept from the
same day, so an order taken from that day would leave them tied and the roster choosing between
them, and an order taken from a name would be a rule about the owner's own words. This is the same
reason a day view orders nothing of its own and shows what it was handed in the order it was handed
it.

A roster SHALL hold commitments and nothing else. It MUST NOT give a commitment an identifier, a
position a commitment can be asked for, a record of the day it was added, or any state of its own,
and it MUST NOT alter a commitment it holds: a commitment read back out of a roster SHALL be the
commitment that was put in, with the same name, the same schedule and the same day it is kept from.

A roster SHALL NOT consult the present moment, the device's clock, its time zone or its locale, and
SHALL NOT be asked what day it is. It judges no date at all: a commitment kept from a day long past
and a commitment kept from the last date the system supports are held alike, and whether either is
due on any date is the commitment's own answer and not the roster's.

A roster SHALL be a value. Two rosters holding the same commitments in the same order SHALL be the
same roster, and two holding the same commitments in a different order SHALL be different rosters,
because the order is one of the things a roster holds. Adding a commitment to a roster SHALL leave
every other roster untouched, so a roster that was copied before an addition SHALL still hold what
it held.

#### Scenario: a roster that has been given no commitment holds none

- **WHEN** a roster is formed and nothing is added to it
- **THEN** the roster holds no commitments

#### Scenario: a roster reads its commitments back in the order they were added

- **WHEN** a roster is given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all three on a schedule listing Monday, Wednesday and Saturday and all three kept
  from 1 January 2026
- **THEN** the roster holds those three commitments in that order — "Water plants", then "Gym", then
  "Journaling" — and not in alphabetical order

#### Scenario: a roster does not order its commitments by the day they are kept from

- **WHEN** a roster is given a commitment named "Gym" kept from 1 March 2026, then one named "Run"
  kept from 1 January 2026, both on a schedule listing Monday, Wednesday and Saturday
- **THEN** the roster holds "Gym" first and "Run" second, in the order they were added and not in
  the order of the days they are kept from

#### Scenario: two rosters holding the same commitments in the same order are the same roster

- **WHEN** two rosters are each given a commitment named "Gym", then one named "Run", both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026
- **THEN** the two are the same roster

#### Scenario: two rosters holding the same commitments in a different order are different rosters

- **WHEN** one roster is given a commitment named "Gym" and then one named "Run", and a second
  roster is given the same two the other way round, all on a schedule listing Monday, Wednesday and
  Saturday and all kept from 1 January 2026
- **THEN** the two are different rosters

#### Scenario: adding to a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is copied, and a commitment named "Run" alike in every other
  way is added to the copy
- **THEN** the copy holds two commitments, "Gym" and then "Run"
- **AND** the roster it was copied from still holds one commitment, "Gym", and is not the same
  roster as the copy

#### Scenario: a roster holds a commitment kept from the last supported date like any other

- **WHEN** a roster is given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 31 December 9999, and then one named "Run" alike in every other way but kept
  from 1 January 2026
- **THEN** the roster holds both, in that order, and reads each back with the day it is kept from
  unchanged

### Requirement: A roster refuses a commitment it already holds

A roster SHALL refuse a commitment equal to one it already holds. Refusing SHALL leave the roster
exactly as it was — the same commitments, in the same order, with the one already held keeping the
position it had — and the roster SHALL report that the commitment was not added. Adding a commitment
a roster does not hold SHALL place it after every commitment already there and SHALL report that it
was added.

Reporting is part of the refusal and MUST NOT be dropped. A caller that does not care may ignore
what it is told, but a caller that does care cannot recover a report that was never made: doing
nothing and saying nothing is indistinguishable to a person from having added a second commitment,
which is the one thing a roster exists to prevent. Whether anything is said on a screen, and in what
words, is not this requirement's — it is what a screen does with the report.

Two commitments are the same commitment when their name, their schedule and the day they are kept
from are all the same, and a roster SHALL use that and nothing else to decide what it already holds.
It MUST NOT invent a coarser sameness of its own: two commitments alike in name but differing in
schedule or in the day they are kept from are different commitments and a roster SHALL hold both,
and two names differing only by blank space are different names, because a commitment's name is
stored exactly as it was given and tidying it belongs where a person typed it.

This is why the refusal exists at all. A commitment carries no identifier, so a roster holding two
commitments a person would call identical could not be told which of them to stop keeping, which of
them to change, or which of them a screen was pointing at. There is nothing to tell them apart by,
and so there must not be two.

A roster SHALL refuse nothing else. It MUST NOT judge a name, a schedule or a day a commitment is
kept from — anything that is a commitment at all was already accepted when the commitment was formed
— it MUST NOT refuse on how many commitments it holds, and it MUST NOT refuse on a date.

#### Scenario: adding a commitment a roster does not hold places it after the ones already there and says it was added

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is given one named "Run" alike in every other way
- **THEN** the roster reports that the commitment was added
- **AND** the roster holds two commitments, "Gym" first and "Run" second

#### Scenario: adding a commitment a roster already holds says it was not added and leaves the roster as it was

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is given a second commitment formed with that same name, that
  same schedule and that same day
- **THEN** the roster reports that the commitment was not added
- **AND** the roster still holds exactly one commitment, named "Gym"
- **AND** it is the same roster as one given that commitment once

#### Scenario: a refused commitment does not move the one already held

- **WHEN** a roster is given a commitment named "Gym", then one named "Run", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January
  2026, and is then given a second commitment alike in every way to "Gym"
- **THEN** the roster still holds three commitments in the order "Gym", "Run", "Journaling", with
  "Gym" in the position it already had and not moved to the end

#### Scenario: two commitments alike in name but on different schedules are both held

- **WHEN** a roster is given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and then one named "Gym" on a schedule listing Tuesday and
  Thursday, kept from that same day
- **THEN** the roster reports that the second commitment was added
- **AND** the roster holds two commitments, both named "Gym"

#### Scenario: two commitments alike in name and schedule but kept from different days are both held

- **WHEN** a roster is given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and then one alike in name and schedule but kept from
  2 January 2026
- **THEN** the roster reports that the second commitment was added
- **AND** the roster holds two commitments, both named "Gym"

#### Scenario: two names differing only by a space at the end are different commitments and both are held

- **WHEN** a roster is given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and then one named "Gym " — the same word with a trailing
  space — alike in every other way
- **THEN** the roster reports that the second commitment was added
- **AND** the roster holds two commitments, the first reading back as "Gym" and the second as "Gym "
