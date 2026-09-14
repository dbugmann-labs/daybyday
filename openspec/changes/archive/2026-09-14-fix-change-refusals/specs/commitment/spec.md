## ADDED Requirements

### Requirement: A change leaves an interval commitment's start date where it was unless it names a different day kept from

Where a commitments screen changes a commitment whose schedule is an interval of days, and the
change names the day kept from that the commitment already has, the changed commitment's schedule
SHALL keep the start date the commitment's schedule already has, whether or not that start date is
the day kept from. The same SHALL hold for the commitment a save carries records over to before it
supersedes. A save naming exactly the name, the rhythm, the day kept from and the category a
commitment already has SHALL change nothing, whatever its interval's start date.

A change naming a different day kept from SHALL form the changed commitment's schedule starting on
that day, whatever start date its schedule had before.

#### Scenario: an interval commitment whose start differs from the day it is kept from is renamed and every day recorded on stays due

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a tick for it on Monday
  10 August 2026 is kept at a record place; a commitments screen is opened at that roster place and
  that record place as of Monday 31 August 2026; and "Nails" is changed through it to the name
  "Nails 💅", on the rhythm and the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place holds is due on Thursday
  6 August 2026 and on Monday 10 August 2026, and not due on Saturday 8 August 2026
- **AND** a store opened afterwards at that record place answers that "Nails 💅" was kept on Monday
  10 August 2026

#### Scenario: an interval commitment whose start differs from the day it is kept from is put under a category without touching the record place

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a tick for it on Monday
  10 August 2026 is kept at a record place; a commitments screen is opened at that roster place and
  that record place as of Monday 31 August 2026; and "Nails" is changed through it to the category
  "Care", on the name, the rhythm and the day kept from it already has
- **THEN** nothing is refused
- **AND** what it keeps is one group, "Care", holding one entry named "Nails"
- **AND** the content at that record place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: an interval commitment whose start differs from the day it is kept from saved unchanged changes nothing

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a tick for it on Monday
  10 August 2026 is kept at a record place; a commitments screen is opened at that roster place and
  that record place as of Monday 31 August 2026; and "Nails" is changed through it to exactly the
  name, the rhythm of every 4 days, the day kept from and the category it already has
- **THEN** nothing is refused
- **AND** the content at both places is byte-for-byte what it was immediately after the screen was
  opened

#### Scenario: an interval commitment whose start differs from the day it is kept from is renamed on a new rhythm and the superseded one keeps its start

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a tick for it on Monday
  10 August 2026 is kept at a record place; a commitments screen is opened at that roster place and
  that record place as of Monday 31 August 2026; and "Nails" is changed through it to the name
  "Nails 💅" on a weekday-set rhythm of Sunday, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with
  "Nails 💅" on Sunday, kept from 31 August 2026, and then "Nails 💅" on every 4 days starting on
  Thursday 6 August 2026, kept from Tuesday 4 August 2026
- **AND** a store opened afterwards at that record place answers that the second was kept on Monday
  10 August 2026

#### Scenario: moving the day an interval commitment is kept from moves its start to that day even where the two had differed

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; and "Nails" is changed through it to the
  day kept from Monday 3 August 2026, on the name and the rhythm it already has, under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place holds is due on Monday
  3 August 2026 and on Friday 7 August 2026
- **AND** it is not due on Thursday 6 August 2026

### Requirement: A commitments screen refuses a change that would carry records onto records already kept

A change naming a different name, a different day kept from, or both, whether on the rhythm the
commitment already runs on or together with a different rhythm, SHALL be refused as records already
kept under the commitment the change would produce where the record place already holds any record
of the commitment it would carry records over to. It SHALL be refused so whether or not the
commitment asked about holds any record itself, and SHALL be told apart from every other refusal a
change can meet. Where the same change would also leave a day already recorded on not due, it SHALL
be refused as that instead.

A change so refused SHALL, as every refused change, keep nothing at either place and move neither of
the screen's lists, and every record already kept SHALL stay under the commitment it was kept for.

#### Scenario: moving the day a commitment is kept from onto a commitment whose records are already kept is refused for that cause

- **WHEN** a commitment named "Reading" on a weekly quota of 3 times a week, kept from Monday
  10 August 2026, is taken on at a roster place; a tick for it on Wednesday 12 August 2026, and a
  tick on Sunday 9 August 2026 for a commitment named "Reading" alike in every way but kept from
  Saturday 8 August 2026, are kept at a record place; a commitments screen is opened at that roster
  place and that record place as of Monday 31 August 2026; and "Reading" is changed through it to
  the day kept from Saturday 8 August 2026, on the name and the rhythm it already has, under no
  category
- **THEN** it is refused as records already kept under the commitment the change would produce, told
  apart from a day already recorded on that the change would leave not due and from a place that
  could not be written
- **AND** what the screen keeps is one entry named "Reading", and the content at both places is
  byte-for-byte what it was immediately after the screen was opened

#### Scenario: renaming a commitment with no records onto a commitment whose records are already kept is refused

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick on Monday 3 August 2026 for a commitment
  named "Gym 🏋️" alike in every other way is kept at a record place; a commitments screen is opened
  at that roster place and that record place as of Monday 31 August 2026; and "Gym" is changed
  through it to the name "Gym 🏋️", on the rhythm and the day kept from it already has, under no
  category
- **THEN** it is refused as records already kept under the commitment the change would produce
- **AND** what the screen keeps is one entry named "Gym", and the content at both places is
  byte-for-byte what it was immediately after the screen was opened

#### Scenario: a name and a rhythm changed in one save onto a commitment whose records are already kept are refused for that cause

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026, and a tick on
  Wednesday 5 August 2026 for a commitment named "Gym 🏋️" alike in every other way, are kept at a
  record place; a commitments screen is opened at that roster place and that record place as of
  Monday 31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️" on a weekday-set
  rhythm of Tuesday and Thursday, under no category
- **THEN** it is refused as records already kept under the commitment the change would produce
- **AND** what the screen keeps is one entry, named "Gym", saying "Mon, Wed, Sat", and the content at
  both places is byte-for-byte what it was immediately after the screen was opened

#### Scenario: a change that would leave a recorded day not due and meets records already kept is refused as leaving a recorded day not due

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 June 2026,
  is taken on at a roster place; a tick for it on Monday 3 August 2026, and a tick on Wednesday
  5 August 2026 for a commitment named "Gym" alike in every way but kept from Tuesday 4 August 2026,
  are kept at a record place; a commitments screen is opened at that roster place and that record
  place as of Monday 31 August 2026; and "Gym" is changed through it to the day kept from Tuesday
  4 August 2026, under no category
- **THEN** it is refused as a day already recorded on that the change would leave not due
- **AND** the content at both places is byte-for-byte what it was immediately after the screen was
  opened

## MODIFIED Requirements

### Requirement: A commitment is not due before the day it is kept from

A commitment SHALL NOT be due on any calendar date earlier than the day it is kept from, whatever
its schedule says about that date, and the system MUST NOT answer that a commitment was due on such
a date.

The rule SHALL apply to every schedule shape alike, and SHALL be a floor rather than a phase: the
day a commitment is kept from MAY be a day its schedule is not due on, and the floor itself MUST NOT
shift the schedule's own start date or the phase the schedule runs on, which only a change naming a
different day kept from moves. Where the schedule is an interval of days, that interval's start date
and this floor SHALL be separate and SHALL both apply.

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

#### Scenario: a commitment on a weekly-quota schedule is not due on a date before the day it is kept from

- **WHEN** a commitment named "Reading" on a weekly quota of 3 times a week, kept from Wednesday 2
  September 2026, is asked about Monday 31 August and Tuesday 1 September 2026
- **THEN** the commitment is due on neither of those dates, though its schedule is due on both
- **AND** the same commitment asked about Wednesday 2 September 2026 answers that it is due
