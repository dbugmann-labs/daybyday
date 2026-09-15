## ADDED Requirements

### Requirement: A change that carries records leaves a save in progress until its roster place is written

A commitments screen SHALL, before a change or a restart writes anything at the record place, keep a
save in progress beside the record place naming the commitment its records are carried from and the
one they are carried to, and SHALL take it away once the roster place is written. A change or
restart that carries no record SHALL keep no save in progress. Where it cannot be kept, the change or
restart SHALL be refused as a place that could not be written, writing nothing at either place.

Where the roster place refuses a change or restart whose records were already carried, the screen
SHALL undo the torn save exactly as reading its places does and SHALL then refuse it as a place that
could not be written. Where that undo fails, the screen SHALL from then on hold a torn save it cannot
undo.

#### Scenario: a change that carries records leaves no save in progress once it is kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a record
  place; a commitments screen is opened at that roster place and that record place as of Monday
  31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️", under no category
- **THEN** nothing is refused
- **AND** no save in progress is kept beside that record place

#### Scenario: a change that carries no record is kept where nothing beside the record place can be written

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and one named "Run" on a schedule listing all seven weekdays, kept from that same
  day, are taken on at a roster place; a tick for "Gym" on Monday 3 August 2026 is kept at a record
  place in a directory of its own; a commitments screen is opened at those places as of Monday
  31 August 2026; the record place's directory is then made impossible to write, while the roster
  place's directory stays writable; "Gym" is changed through it to a weekday-set rhythm of Tuesday
  and Thursday; and "Run" is changed through it to the name "Running"
- **THEN** neither change is refused
- **AND** what it keeps is an entry named "Gym" saying "Tue, Thu" and an entry named "Running"

#### Scenario: a change refused at the roster place after carrying its records leaves no save in progress and a roster still kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a record
  place; a commitments screen is opened at those places as of Monday 31 August 2026; what is at that
  roster place is then made impossible to write; and "Gym" is changed through it to the name
  "Gym 🏋️", under no category
- **THEN** it is refused as a place that could not be written
- **AND** no save in progress is kept beside that record place
- **AND** the screen says it is keeping a roster, and what it keeps is one entry, named "Gym"

### Requirement: Reading the places undoes a torn save as it was

A day screen and a commitments screen SHALL read the save in progress each time they read their
places — when opened, when shown again, and a day screen when returned to — before drawing anything
from either place. Where one stands and the roster place holds, in any state, the commitment it names
the records carried to, the screen SHALL take the save in progress away and SHALL write nothing else.
Where one stands and the roster place holds no such commitment, the screen SHALL carry every record
of that commitment back to the commitment they were carried from, SHALL keep that at the record
place, SHALL then take the save in progress away, and SHALL say nothing of it.

#### Scenario: a rename torn between its two places is undone when a commitments screen is opened

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick on Monday 3 August 2026 for a commitment named
  "Gym 🏋️" alike in every other way is kept at a record place; a save in progress naming records
  carried from "Gym" to "Gym 🏋️" is kept beside that record place; and a commitments screen is
  opened at those places as of Monday 31 August 2026
- **THEN** what it keeps is one entry, named "Gym"
- **AND** a store opened afterwards at that record place answers that "Gym" was kept on Monday
  3 August 2026 and that "Gym 🏋️" was not
- **AND** no save in progress is kept beside that record place, and the screen does not say that
  records belong to no commitment

#### Scenario: a restart torn between its two places is undone when a day screen is opened

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Saturday 1 August 2026, is taken on at a roster place; ticks on Thursday 6 August
  2026 and Monday 10 August 2026 for a commitment named "Nails" on a schedule of every 4 days
  starting on Sunday 2 August 2026, kept from that day, are kept at a record place; a save in
  progress naming records carried from the first to the second is kept beside that record place; and
  a day screen of no commitments is opened at those places as of Monday 10 August 2026
- **THEN** its day view holds one row, named "Nails", saying the commitment is kept
- **AND** a store opened afterwards at that record place answers that the first "Nails" was kept on
  both days and the second on neither
- **AND** no save in progress is kept beside that record place

#### Scenario: a save in progress for a save its roster took is taken away and nothing else is written

- **WHEN** a commitment named "Gym 🏋️" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place and removed there as of Sunday 30 August 2026; a tick for it on
  Monday 3 August 2026 is kept at a record place; a save in progress naming records carried from a
  commitment named "Gym" alike in every other way to "Gym 🏋️" is kept beside that record place; the
  content at both places is read; and a commitments screen is opened at those places as of Monday
  31 August 2026
- **THEN** no save in progress is kept beside that record place
- **AND** the content at both places is byte-for-byte what was read

#### Scenario: a torn save is undone when a day screen is shown again

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a day screen of no commitments is opened at that roster place
  and at a record place where nothing has been kept as of Monday 31 August 2026; a tick on that day
  for a commitment named "Gym 🏋️" alike in every other way, and a save in progress naming records
  carried from "Gym" to "Gym 🏋️", are then kept at those places by something else; and the screen is
  shown again as of Monday 31 August 2026
- **THEN** its day view holds one row, named "Gym", saying the commitment is kept
- **AND** no save in progress is kept beside that record place

#### Scenario: a torn save is undone when a day screen is returned to

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a day screen of no commitments is opened at that roster place
  and at a record place where nothing has been kept as of Monday 31 August 2026; a tick on that day
  for a commitment named "Gym 🏋️" alike in every other way, and a save in progress naming records
  carried from "Gym" to "Gym 🏋️", are then kept at those places by something else; and the screen is
  returned to
- **THEN** its day view holds one row, named "Gym", saying the commitment is kept
- **AND** a store opened afterwards at that record place answers that "Gym 🏋️" was not kept on that
  day, and no save in progress is kept beside that record place

### Requirement: A torn save that cannot be undone keeps nothing from the record place

Where a save in progress stands and cannot be undone — it cannot be read or taken away, either place
cannot be read, the record place cannot be written, or its records cannot be carried back — a screen
reading its places SHALL write nothing at either place and SHALL leave the save in progress as it is.
A day screen SHALL then be without its record, saying only that its record could not be read, and
SHALL still draw its rows. A commitments screen SHALL answer as one that cannot read its roster,
listing nothing and changing nothing. Each SHALL try again whenever it reads its places again, and
SHALL keep from both once the torn save is undone.

#### Scenario: a day screen opened on a torn save it cannot undo draws its rows and keeps no tick

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick on Monday 31 August 2026 for a commitment named
  "Gym 🏋️" alike in every other way is kept at a record place in the same directory; a save in
  progress naming records carried from "Gym" to "Gym 🏋️" is kept beside that record place; the
  content at the record place and at the save in progress is read; that directory is made impossible
  to write; a day screen of no commitments is opened at those places as of Monday 31 August 2026; and
  its one row is ticked
- **THEN** its day view holds one row, named "Gym", saying the commitment is not kept
- **AND** it says it is not keeping a record, and does not say the record was written by a later
  version of DayByDay
- **AND** the content at the record place and at the save in progress is byte-for-byte what was read

#### Scenario: a commitments screen opened on a save in progress it cannot read lists nothing and defines nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a run of bytes that is not a save in progress is kept where
  one is kept beside a record place where nothing has been kept; the content at that roster place is
  read; a commitments screen is opened at those places as of Monday 31 August 2026; and a commitment
  named "Run" on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined
  through it
- **THEN** defining "Run" is refused as a roster that could not be written
- **AND** it says it is not keeping a roster, what it keeps is nothing, and it does not say that
  records belong to no commitment
- **AND** the content at that roster place and at the save in progress is byte-for-byte what it was
  before the screen was opened

#### Scenario: a torn save a day screen could not undo is undone once it is shown again and its places can be written

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick on Monday 31 August 2026 for a commitment named
  "Gym 🏋️" alike in every other way is kept at a record place in the same directory; a save in
  progress naming records carried from "Gym" to "Gym 🏋️" is kept beside that record place; that
  directory is made impossible to write; a day screen of no commitments is opened at those places as
  of Monday 31 August 2026; that directory is made writable again; and the screen is shown again as of
  Monday 31 August 2026
- **THEN** it says it is keeping a record
- **AND** its day view holds one row, named "Gym", saying the commitment is kept
- **AND** no save in progress is kept beside that record place

### Requirement: Reading the places carries an orphaned record back to its one possible source

Once no save in progress stands and both places can be read, a day screen and a commitments screen
SHALL find every commitment the record place holds records of that the roster place holds in no
state. A commitment the roster holds in any state SHALL be a possible source of one where it is of
the same kind carrying the same range or target, runs on the same rhythm with an interval's start
date set aside, and is due on every day those records are on. Where exactly one commitment is a
possible source, it holds no record on any of those days, and no other such commitment has it as its
one possible source, every one of those records SHALL be carried back to it and kept at the record
place, and nothing SHALL be said. Otherwise none of them SHALL move.

#### Scenario: an orphaned record with one possible source is carried back to it when a commitments screen is opened

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays and one named "Run" on a
  schedule listing Tuesday and Thursday, both kept from 1 January 2026, are taken on at a roster
  place; a tick on Monday 3 August 2026 for a commitment named "Gym 🏋️" alike to "Gym" in every other
  way is kept at a record place; and a commitments screen is opened at those places as of Monday
  31 August 2026
- **THEN** a store opened afterwards at that record place answers that "Gym" was kept on Monday
  3 August 2026 and that "Gym 🏋️" was not
- **AND** the screen does not say that records belong to no commitment

#### Scenario: an orphaned record is carried back to a removed commitment beside the records it already holds when a day screen is opened

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place and removed there as of Sunday 30 August 2026; a tick for it on
  Monday 3 August 2026, and one on Tuesday 4 August 2026 for a commitment named "Gym 🏋️" alike in
  every other way, are kept at a record place; and a day screen of no commitments is opened at those
  places as of Monday 31 August 2026
- **THEN** a store opened afterwards at that record place answers that "Gym" was kept on Monday
  3 August 2026 and on Tuesday 4 August 2026
- **AND** it answers that "Gym 🏋️" was kept on neither day

#### Scenario: an orphaned record with two possible sources stays where it is and is said

- **WHEN** a commitment named "Creatine" and one named "Magnesium", both on a schedule listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; a tick on Monday
  3 August 2026 for a commitment named "Creatin" alike to both in every other way is kept at a record
  place; the content at that record place is read; and a commitments screen is opened at those places
  as of Monday 31 August 2026
- **THEN** the screen says that records belong to no commitment
- **AND** the content at that record place is byte-for-byte what was read

#### Scenario: an orphaned record with no possible source stays where it is and is said

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a tick on Tuesday 4 August 2026 for a commitment
  named "Gym 🏋️" on a schedule listing Tuesday and Thursday, kept from that same day, is kept at a
  record place; the content at that record place is read; and a commitments screen is opened at those
  places as of Monday 31 August 2026
- **THEN** the screen says that records belong to no commitment
- **AND** the content at that record place is byte-for-byte what was read

#### Scenario: an orphaned record that would land on a day its source already holds moves none of its records

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick for it on Monday 3 August 2026, and ticks on Monday
  3 August 2026 and Tuesday 4 August 2026 for a commitment named "Gym 🏋️" alike in every other way,
  are kept at a record place; the content at that record place is read; and a commitments screen is
  opened at those places as of Monday 31 August 2026
- **THEN** the screen says that records belong to no commitment
- **AND** the content at that record place is byte-for-byte what was read

#### Scenario: two orphaned commitments with the same one possible source both stay where they are

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick on Monday 3 August 2026 for a commitment named
  "Gym 🏋️" and one on Tuesday 4 August 2026 for a commitment named "Gym 2", both alike to "Gym" in
  every other way, are kept at a record place; the content at that record place is read; and a
  commitments screen is opened at those places as of Monday 31 August 2026
- **THEN** the screen says that records belong to no commitment
- **AND** the content at that record place is byte-for-byte what was read

### Requirement: A commitments screen says whether any record belongs to no commitment

A commitments screen SHALL say, each time it reads its places, whether the record place holds any
record of a commitment its roster holds in no state once carrying back is done, and SHALL go on
saying so for as long as one remains. It SHALL NOT say so where it cannot read either place or holds
a torn save it cannot undo. A day screen SHALL say nothing about such records.

#### Scenario: a commitments screen stops saying records belong to no commitment once their commitment is taken on

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a tick on Tuesday 4 August 2026 for a commitment
  named "Gym 🏋️" on a schedule listing Tuesday and Thursday, kept from that same day, is kept at a
  record place; a commitments screen is opened at those places as of Monday 31 August 2026; "Gym 🏋️"
  is taken on at that roster place by something else; and the screen is shown again as of Monday
  31 August 2026
- **THEN** the screen does not say that records belong to no commitment
- **AND** it said so before it was shown again

#### Scenario: a commitments screen that cannot read its record does not say records belong to no commitment

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a run of bytes that is not what a record is written as is kept
  at a record place; and a commitments screen is opened at those places as of Monday 31 August 2026
- **THEN** the screen does not say that records belong to no commitment
- **AND** the content at that record place is byte-for-byte what it was before the screen was opened

## MODIFIED Requirements

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

- **WHEN** a commitment named "Gym" and then one named "Run", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a tick on Monday 3 August
  2026 for a commitment named "Gym 🏋️" alike to both in every way but its name is kept at a record
  place; a commitments screen is opened at that roster place and that record place as of Monday
  31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️", on the rhythm and the day
  kept from it already has, under no category
- **THEN** it is refused as records already kept under the commitment the change would produce
- **AND** what the screen keeps is two entries, named "Gym" and then "Run", and the content at both
  places is byte-for-byte what it was immediately after the screen was opened

#### Scenario: a name and a rhythm changed in one save onto a commitment whose records are already kept are refused for that cause

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026, and a tick on
  that same day for a commitment named "Gym 🏋️" alike in every other way, are kept at a record place;
  a commitments screen is opened at that roster place and that record place as of Monday 31 August
  2026; and "Gym" is changed through it to the name "Gym 🏋️" on a weekday-set rhythm of Tuesday and
  Thursday, under no category
- **THEN** it is refused as records already kept under the commitment the change would produce
- **AND** what the screen keeps is one entry, named "Gym", saying "Mon, Wed, Sat", and the content at
  both places is byte-for-byte what it was immediately after the screen was opened

#### Scenario: a change that would leave a recorded day not due and meets records already kept is refused as leaving a recorded day not due

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 June 2026,
  is taken on at a roster place; ticks for it on Monday 3 August 2026 and Wednesday 5 August 2026,
  and a tick on Wednesday 5 August 2026 for a commitment named "Gym" alike in every way but kept from
  Tuesday 4 August 2026, are kept at a record place; a commitments screen is opened at that roster
  place and that record place as of Monday 31 August 2026; and "Gym" is changed through it to the day
  kept from Tuesday 4 August 2026, under no category
- **THEN** it is refused as a day already recorded on that the change would leave not due
- **AND** the content at both places is byte-for-byte what it was immediately after the screen was
  opened
