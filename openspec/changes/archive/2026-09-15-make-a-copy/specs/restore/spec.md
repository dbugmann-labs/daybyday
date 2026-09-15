## Purpose

The ways a history leaves a phone and comes back: the copy a person asks for, the file it leaves
as, and — as later Stories land — where the app copies on its own and how a copy is put back.

## ADDED Requirements

### Requirement: A copy is what the three places hold, read when it is asked for

Forming a copy SHALL read the record place, the roster place and the one-off place the way the app
reads them when it opens, undoing a save in progress first, at the moment the copy is asked for and
never from what a screen already holds. The copy SHALL hold the history, the roster and the
one-offs those places hold when they are read. A place where nothing has been kept SHALL count as
holding nothing and SHALL NOT refuse the copy. Where any of the three cannot be read the copy SHALL
be refused whole, and the store named SHALL be the record, or the roster where the record could be
read, or the one-offs where both could. Forming a copy SHALL leave the three places as it found
them, apart from a save in progress undone.

#### Scenario: a copy holds the history, the roster and the one-offs the three places hold

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Sunday 30 August 2026 is kept at a
  record place; a one-off named "Book dentist" on 25 September 2026 is kept at a one-off place; a
  commitments screen is opened at those three places as of Monday 31 August 2026; and a copy is
  asked for as of that day at 14:32, written into a directory of its own
- **THEN** the copy is not refused
- **AND** what is written holds a roster of one entry named "Gym", a history keeping "Gym" on
  Sunday 30 August 2026, and one one-off named "Book dentist" on 25 September 2026
- **AND** the content at all three places is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a copy of three places where nothing has been kept is made and holds nothing

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, and a copy is asked for as of that day at
  14:32, written into a directory of its own
- **THEN** the copy is not refused
- **AND** what is written holds a roster keeping nothing, a history keeping nothing and no one-offs
- **AND** nothing is written at any of the three places

#### Scenario: a copy is formed from what the places hold when it is asked for, not from what a screen read

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster
  place, a record place and a one-off place where nothing has been kept as of Monday 31 August 2026;
  a commitment named "Journaling" alike in every other way is then taken on at that roster place
  by something other than the screen; and a copy is asked for as of that day at 14:32
- **THEN** what is written holds a roster of two entries, named "Gym" and then "Journaling"
- **AND** what the screen keeps is still one entry, named "Gym"

#### Scenario: a copy taken where a save was torn holds what undoing the torn save leaves

- **WHEN** a change carrying records is left having reached a record place and not the roster place
  beside it, with the save in progress it left standing; a commitments screen is opened at those
  places and at a one-off place where nothing has been kept as of Monday 31 August 2026; and a copy
  is asked for as of that day at 14:32
- **THEN** the copy is not refused
- **AND** what is written holds the history the record place held before that change reached it
- **AND** the content at that record place is what undoing the torn save leaves, and no save in
  progress stands

#### Scenario: a copy is refused whole where one of the three places cannot be read

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a one-off named "Book dentist" on 25 September 2026
  is kept at a one-off place; a commitments screen is opened at those places and at a record place
  where nothing has been kept as of Monday 31 August 2026; what is at that record place is then
  made a run of bytes that is not a record; and a copy is asked for as of that day at 14:32
- **THEN** it is refused as a store that could not be read, naming the record
- **AND** no file stands in the directory the copy was to be written into
- **AND** a copy asked for where the roster place, rather than the record place, is a run of bytes
  that is not a roster is refused the same way, naming the roster, and one where the one-off place
  is a run of bytes that is not a one-off holder is refused the same way, naming the one-offs

#### Scenario: a copy refused with more than one place unreadable names the record before the roster and the roster before the one-offs

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a record place, a roster
  place and a one-off place each holding a run of bytes that is not a store of its kind, and a copy
  is asked for as of that day at 14:32
- **THEN** it is refused as a store that could not be read, naming the record
- **AND** a copy asked for where the record place can be read and the other two cannot names the
  roster
- **AND** a copy asked for where the record place and the roster place can be read and the one-off
  place cannot names the one-offs

### Requirement: A copy carries the moment it was made and a form of its own

A copy SHALL carry the moment it was made — a calendar date, an hour of that day and a minute of
that hour — exactly as it is handed it, and SHALL read no clock of its own. A moment SHALL be
refused where its hour is not one of the twenty-four or its minute is not one of the sixty. A copy
SHALL carry a form of its own, saying the shape it is written in, and that form SHALL move
independently of the forms the three stores are written in. What is written for a copy SHALL hold
that form, the moment, and what each store holds written in the form that store writes now,
whatever form the place it was read from was in.

#### Scenario: a copy carries the moment it was handed, and the places it was read from carry none

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, and a copy is asked for as of that day at
  14:32
- **THEN** what is written holds Monday 31 August 2026 at 14:32 as the moment it was made
- **AND** a copy asked for as of that same day at 09:07 holds that moment instead
- **AND** nothing written at any of the three places holds a moment at all

#### Scenario: a moment is refused where its hour or its minute is not one the clock has

- **WHEN** a moment on Monday 31 August 2026 at the twenty-fourth hour is formed
- **THEN** it is refused
- **AND** a moment at the sixtieth minute of an hour, at an hour below zero and at a minute below
  zero are each refused the same way
- **AND** a moment at the twenty-third hour and the fifty-ninth minute, and one at the zeroth hour
  and the zeroth minute, are each formed

#### Scenario: what is written for a copy holds its own form, its moment and the three stores as they are written now

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Sunday 30 August 2026 is kept at a
  record place; a commitments screen is opened at those places and at a one-off place where nothing
  has been kept as of Monday 31 August 2026; and a copy is asked for as of that day at 14:32
- **THEN** what is written says the form a copy is written in
- **AND** the record, the roster and the one-offs it holds are each written in the form that store
  writes now
- **AND** what it holds for each store is what that store writes at its own place for the same value

#### Scenario: a copy of a place kept in an earlier form is written in the form that store writes now

- **WHEN** a roster place holding a roster kept in the earliest form a roster store reads, and a
  record place holding a history kept in the earliest form a record store reads, are opened by a
  commitments screen as of Monday 31 August 2026 with a one-off place where nothing has been kept,
  and a copy is asked for as of that day at 14:32
- **THEN** what is written holds that roster and that history written in the form each store writes
  now
- **AND** the content at both places is byte-for-byte what it was immediately after the screen was
  opened

### Requirement: A commitments screen makes a copy when it is asked, and holds nothing about one it made

A commitments screen SHALL offer making a copy whatever its lists hold and whether or not it can
read its roster. Asked for one, it SHALL form a copy as of the moment it is handed, write it as a
single file in the directory it is given to write copies into, and answer where it wrote it. It
SHALL write nothing else anywhere. A copy it made SHALL leave the screen exactly as it was: what it
keeps, what it has stopped, the commitment awaiting confirmation, the commitment awaiting removal
and the name typed back SHALL each be what they were before the copy was asked for.

#### Scenario: a commitments screen asked for a copy writes one file and answers where it wrote it

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster
  place, a record place and a one-off place where nothing has been kept as of Monday 31 August 2026;
  and a copy is asked for as of that day at 14:32, written into a directory of its own
- **THEN** it answers where it wrote the copy, and a file stands there
- **AND** that directory holds that one file and no other

#### Scenario: a copy made leaves a commitments screen's lists and what it is awaiting exactly as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, and one named "Journaling" alike in every other way are taken on at a roster
  place; "Journaling" is stopped there as of Sunday 30 August 2026; a commitments screen is opened
  at that roster place, a record place and a one-off place where nothing has been kept as of Monday
  31 August 2026; it is asked to remove "Gym" and "Gym" is typed back; and a copy is asked for as of
  that day at 14:32
- **THEN** what it keeps is one entry, named "Gym", and what it has stopped is one entry, named
  "Journaling"
- **AND** "Gym" is still awaiting removal, with "Gym" still typed back
- **AND** nothing is awaiting confirmation

#### Scenario: a commitments screen that cannot read its roster is still asked for a copy

- **WHEN** a roster place holding a run of bytes that is not a roster is opened by a commitments
  screen as of Monday 31 August 2026, with a record place and a one-off place where nothing has been
  kept, and a copy is asked for as of that day at 14:32
- **THEN** the screen says it is not keeping a roster
- **AND** the copy is refused as a store that could not be read, naming the roster

### Requirement: A copy is a file named for the minute it was made, of the app's own kind

A copy SHALL be written as one file whose name is the app's name, then the day it was made as a
four-digit year, a two-digit month and a two-digit day joined by hyphens, then the hour and the
minute of that day in twenty-four-hour form, each padded to two digits and separated by a full
stop, with a single space between the three parts. Its extension SHALL be `daybyday` and no other.
Where a file of that name already stands in the directory a copy is written into, the copy SHALL
replace it and SHALL NOT be refused for it.

#### Scenario: a copy's name says the day and the minute it was made, each part padded

- **WHEN** a commitments screen is opened as of Monday 5 January 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, and a copy is asked for as of that day at
  09:07
- **THEN** the file it wrote is named `DayByDay 2026-01-05 09.07.daybyday`
- **AND** a copy asked for as of Monday 31 August 2026 at 14:32 is named
  `DayByDay 2026-08-31 14.32.daybyday`

#### Scenario: a copy written where a copy of that name already stands replaces it

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept; a copy is asked for as of that day at
  14:32; a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is then taken on through the screen; and a copy is asked for again as of that same
  day and minute
- **THEN** neither copy is refused, and both were written at the same file
- **AND** that directory holds that one file
- **AND** what is written there holds a roster of one entry, named "Gym"

### Requirement: A copy that cannot be made leaves nothing behind

Where a store cannot be read, or the file cannot be written, a commitments screen SHALL make no
copy and SHALL answer why: a store that could not be read, or a place that could not be written,
told apart from one another. It SHALL leave no file of its own in the directory it was to write
into, and the record place, the roster place and the one-off place SHALL be byte-for-byte what they
were, save for a save in progress undone. What the screen then holds about the refused copy is the
refused change it holds for every other change it would not make.

#### Scenario: a copy that cannot be written is refused as a place that could not be written

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster
  place, a record place and a one-off place where nothing has been kept as of Monday 31 August 2026;
  and a copy is asked for as of that day at 14:32, written into a directory that cannot be written
  to
- **THEN** it is refused as a place that could not be written, told apart from a store that could
  not be read
- **AND** no file stands in that directory
- **AND** the content at the roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a copy refused because a store could not be read leaves the three places as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a one-off named "Book dentist" on 25 September 2026
  is kept at a one-off place; a commitments screen is opened at those places and at a record place
  where nothing has been kept as of Monday 31 August 2026; what is at that one-off place is then
  made a run of bytes that is not a one-off holder; and a copy is asked for as of that day at 14:32
- **THEN** it is refused as a store that could not be read
- **AND** the content at the roster place and at that one-off place is byte-for-byte what it was
  immediately before the copy was asked for
- **AND** nothing is written at the record place
