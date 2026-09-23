# restore Specification

## Purpose
The ways a history leaves a phone and comes back: the copy a person asks for, the file it leaves
as, and — as later Stories land — where the app copies on its own and how a copy is put back.

## Requirements

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
keeps, what it has stopped, the commitment awaiting confirmation, the commitment awaiting deletion
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
  31 August 2026; it is asked to delete "Gym" and "Gym" is typed back; and a copy is asked for as of
  that day at 14:32
- **THEN** what it keeps is one entry, named "Gym", and what it has stopped is one entry, named
  "Journaling"
- **AND** "Gym" is still awaiting deletion, with "Gym" still typed back
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
copy and SHALL answer why: a store that could not be read, a store written by a later version of
DayByDay, or a place that could not be written, each told apart from the others. Where the store it
names was written by a later version, it SHALL say so rather than that the store could not be read.
It SHALL leave no file of its own in the directory it was to write
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

#### Scenario: a copy refused over a store written by a later version says so rather than that it could not be read

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place holding a
  roster written in a form one later than the form this app writes, and at a record place and a
  one-off place where nothing has been kept, and a copy is asked for as of that day at 14:32
- **THEN** it is refused as a store written by a later version of DayByDay, naming the roster, told
  apart from a store that could not be read
- **AND** a copy asked for where the record place, rather than the roster place, holds a record
  written in a later form is refused the same way, naming the record, and one where the one-off place
  holds one-offs written in a later form is refused the same way, naming the one-offs
- **AND** a copy asked for where the record place holds a run of bytes that is not a record and the
  roster place holds a roster written in a later form is refused as a store that could not be read,
  naming the record

### Requirement: A copy is read whole, and a file that cannot be restored is refused for its own reason

A commitments screen asked to restore from a file SHALL read that file whole when it is asked, and
SHALL write nothing anywhere in reading it. A file that cannot be read, or whose content does not
read as a copy's own form and a moment, SHALL be refused as not a copy, whatever it is named. A file
that does read as a copy's form and moment, whose own form or the form of any store it holds is later
than this app reads, SHALL be refused as a copy from a later version. Any other such file holding a
store that is missing, or that does not read as the shape its form has, SHALL be refused as a
damaged copy. A store held in an earlier form SHALL be read as the value that form holds. A refused
file SHALL leave no restore awaiting confirmation.

#### Scenario: a file that does not read as a copy's form and moment is refused as not a copy

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, and it is asked to restore from a file named
  `DayByDay 2026-08-31 14.32.daybyday` holding a run of bytes that is not a copy
- **THEN** it is refused as not a copy
- **AND** no restore is awaiting confirmation, and nothing is written at any of the three places
- **AND** a file holding a copy's form and no moment, a file holding a form number no version of the
  app writes, and a location where no file stands are each refused the same way

#### Scenario: a copy whose own form is later than this app reads is refused as a copy from a later version

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept; a copy is made through it as of that day at
  14:32; the form that copy says it is written in is then made one later than a copy is written in
  now; and the screen is asked to restore from it
- **THEN** it is refused as a copy from a later version
- **AND** a copy of the form written now, holding a roster whose form is one later than a roster
  store writes, is refused the same way

#### Scenario: a copy holding a store that does not read is refused as a damaged copy

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place,
  a record place and a one-off place where nothing has been kept as of Monday 31 August 2026; a copy
  is made through it as of that day at 14:32; the roster that copy holds is then made to lack a field
  its form always writes; and the screen is asked to restore from it
- **THEN** it is refused as a damaged copy
- **AND** a copy holding no one-offs at all, and one whose record carries a field its form has no
  place for, are each refused the same way

#### Scenario: a copy holding a store of a later form beside a store that does not read is refused as a copy from a later version

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept; a copy is made through it as of that day at
  14:32; the roster that copy holds is then made one form later than a roster store writes, and its
  record is made a value that is not a record; and the screen is asked to restore from it
- **THEN** it is refused as a copy from a later version

#### Scenario: a copy holding stores in the earliest forms they are read in is read as what those forms hold

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, and it is asked to restore from a copy of
  the form written now, made on that day at 14:32, holding a roster of one commitment named "Gym" in
  the earliest form a roster store reads and a history keeping it on Sunday 30 August 2026 in the
  earliest form a record store reads
- **THEN** it is not refused
- **AND** the restore awaiting confirmation says the copy keeps one commitment, has stopped none and
  holds no one-offs

### Requirement: A commitments screen says what a restore takes away and brings before anything is restored

A commitments screen SHALL offer restoring whatever its lists hold and whether or not its places can
be read. Asked to restore from a file that reads as a copy, it SHALL hold a restore awaiting
confirmation and SHALL write nothing at the three places, save a save in progress undone. That
restore SHALL say the moment the copy was made; how many commitments the copy keeps and has stopped,
and how many one-offs it holds; and the same three counts for the three places, read as a copy reads
them. A commitment a copy's roster holds removed SHALL be counted as neither, being read as deleted. Where a place cannot be read, it SHALL say so
in place of any count that store gives. Cancelling SHALL leave the screen and the three places as
they were. A restore awaiting confirmation SHALL stand until it is confirmed, cancelled or replaced
by another ask.

#### Scenario: a commitments screen asked to restore says the copy's moment and what the copy and the phone keep, have stopped and hold as one-offs

- **WHEN** commitments named "Gym" and "Journaling", each on a schedule listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; a one-off named "Book dentist" on
  25 September 2026 is kept at a one-off place; a commitments screen is opened at those places and a
  record place where nothing has been kept as of Monday 31 August 2026; a copy is made through it as
  of that day at 14:32; "Journaling" is then stopped through it, a commitment named "Reading" alike
  in every other way is taken on through it, and "Gym" is deleted through it; a one-off named "Post
  the form" on 1 September 2026 is kept at the one-off place; and the screen is asked to restore from
  that copy
- **THEN** it is not refused, and the restore awaiting confirmation says Monday 31 August 2026 at 14:32
- **AND** it says the copy keeps two commitments, has stopped none and holds one one-off
- **AND** it says the phone keeps one commitment, has stopped one and holds two one-offs
- **AND** the content at all three places is byte-for-byte what it was immediately before it was asked

#### Scenario: a commitments screen asked to restore where a place cannot be read says that store cannot be read in place of its counts

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept; a copy is made through it as of that day at
  14:32; what is at the roster place is then made a run of bytes that is not a roster; and the screen
  is asked to restore from that copy
- **THEN** it is not refused
- **AND** the restore awaiting confirmation says the roster cannot be read, gives the phone no count
  of commitments kept or stopped, and says the phone holds no one-offs
- **AND** where the record place rather than the roster place is unreadable it says the record cannot
  be read and gives all three counts, and where the one-off place is it says the one-offs cannot be
  read and gives no count of one-offs

#### Scenario: a restore asked for and cancelled leaves a commitments screen and its three places as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place,
  a record place and a one-off place where nothing has been kept as of Monday 31 August 2026; a copy
  is made through it as of that day at 14:32; it is asked to delete "Gym" and "Gym" is typed back;
  and it is asked to restore from that copy and the restore is cancelled
- **THEN** no restore is awaiting confirmation, and it holds no copy restored
- **AND** "Gym" is still awaiting deletion, with "Gym" still typed back
- **AND** the content at all three places is byte-for-byte what it was immediately before the restore
  was asked for

#### Scenario: a restore awaiting confirmation stands when the app is shown again and is replaced by another ask

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept; a copy is made through it as of that day at
  14:32; it is asked to restore from that copy; and the app is then shown again as of that same day
- **THEN** the restore awaiting confirmation still says Monday 31 August 2026 at 14:32
- **AND** a copy made as of that day at 09:07, asked to be restored from next, is the one then
  awaiting confirmation

### Requirement: A restore confirmed makes the three places what the copy holds, and nothing of what was there

Confirming a restore SHALL write the history, the roster and the one-offs the copy holds at the
record place, the roster place and the one-off place, each in the form that store writes now, and
SHALL take away a save in progress standing beside the record place. Nothing the places held before
SHALL remain or be merged, whether or not it could be read, and a copy holding nothing SHALL leave
all three holding nothing. The screen SHALL then read its places as it reads them when the app is
shown, SHALL hold no restore, commitment or deletion awaiting confirmation and no name typed back, and
SHALL hold the moment of the copy it restored until the app is shown again or a change is kept.

#### Scenario: a restore confirmed makes the three places hold what the copy holds, and what they held is gone

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Sunday 30 August 2026 is kept at a
  record place; a one-off named "Book dentist" on 25 September 2026 is kept at a one-off place; a
  commitments screen is opened at those places as of Monday 31 August 2026; a copy is made through it
  as of that day at 14:32; a commitment named "Journaling" alike in every other way is then taken on
  through it, a tick for "Gym" on Monday 31 August 2026 is kept at the record place, and a one-off
  named "Post the form" on 1 September 2026 is kept at the one-off place; and the screen is asked to
  restore from that copy and the restore is confirmed
- **THEN** it is not refused
- **AND** the content at each of the three places is byte-for-byte what that store writes for a
  roster of one entry named "Gym", a history keeping "Gym" on Sunday 30 August 2026 and on no other
  day, and one one-off named "Book dentist" on 25 September 2026

#### Scenario: a restore confirmed over places that cannot be read replaces what is there

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a first roster place, and a copy is made as of Monday 31 August 2026
  at 14:32 through a commitments screen opened there, at a record place and a one-off place where
  nothing has been kept; a second roster place, record place and one-off place each hold a run of
  bytes that is not a store of its kind; and a commitments screen opened at those as of that day is
  asked to restore from that copy and the restore is confirmed
- **THEN** it is not refused, and it says it is keeping a roster
- **AND** what it keeps is one entry, named "Gym"
- **AND** a record store and a one-off store opened at the second places hold nothing

#### Scenario: a copy of nothing restored leaves the three places holding nothing

- **WHEN** a copy is made as of Monday 31 August 2026 at 14:32 through a commitments screen opened at
  a roster place, a record place and a one-off place where nothing has been kept; a commitment named
  "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026, and a tick for it on
  Sunday 30 August 2026 are then kept at those places, with a one-off named "Book dentist" on
  25 September 2026; and a commitments screen opened there is asked to restore from that copy and
  the restore is confirmed
- **THEN** it is not refused, and what it keeps and what it has stopped are each no entries
- **AND** a roster store, a record store and a one-off store opened at those places each hold nothing

#### Scenario: a copy holding stores in earlier forms is restored in the forms each store writes now

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, and it is asked to restore from a copy
  holding a roster of one commitment named "Gym" in the earliest form a roster store reads and a
  history keeping it on Sunday 30 August 2026 in the earliest form a record store reads, and the
  restore is confirmed
- **THEN** the content at the roster place and at the record place is each written in the form that
  store writes now
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a restore confirmed takes away a save in progress that could not be undone

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a first roster place, and a copy is made as of Monday 31 August 2026
  at 14:32 through a commitments screen opened there, at a record place and a one-off place where
  nothing has been kept; a run of bytes that is not a save in progress stands where a save in
  progress is kept beside a second record place; and a commitments screen opened at that record place
  and a roster place and a one-off place beside it is asked to restore from that copy and the
  restore is confirmed
- **THEN** it is not refused
- **AND** nothing stands where a save in progress is kept beside the second record place
- **AND** a commitments screen opened afterwards at the second places keeps one entry, named "Gym"

#### Scenario: a commitments screen that restored a copy lists what the copy holds and has nothing awaiting

- **WHEN** commitments named "Gym" and "Journaling", each on a schedule listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place, and "Journaling" is stopped there as
  of Sunday 30 August 2026; a commitments screen is opened at that roster place, a record place and a
  one-off place where nothing has been kept as of Monday 31 August 2026; a copy is made through it as
  of that day at 14:32; "Journaling" is then taken up again through it; it is asked to delete "Gym"
  and "Gym" is typed back; and it is asked to restore from that copy and the restore is confirmed
- **THEN** what it keeps is one entry, named "Gym", and what it has stopped is one entry, named
  "Journaling"
- **AND** nothing is awaiting deletion, no name is typed back, and no restore is awaiting confirmation
- **AND** a screen asked to stop keeping "Gym" rather than to delete it, before the restore was asked
  for, has nothing awaiting confirmation afterwards

#### Scenario: a commitments screen that restored a copy holds that copy's moment until the app is shown again or a change is kept

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept; a copy is made through it as of that day at
  14:32; it is asked to restore from that copy and the restore is confirmed; and a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it
  and refused
- **THEN** it holds Monday 31 August 2026 at 14:32 as the moment of the copy it restored
- **AND** once the app is shown again as of that same day it holds no copy restored
- **AND** a screen that instead defines and keeps a commitment named "Gym" on that rhythm, after the
  restore, holds no copy restored

### Requirement: A restore that cannot be made whole leaves the three places as they were

Where the record place, the roster place, the one-off place, or the place a restore in progress is
kept beside the record place cannot be written, confirming a restore SHALL refuse it as a place that
could not be written. Each of the three places SHALL then be byte-for-byte what it was before the
restore was confirmed, a place where nothing had been kept still holding nothing, and the screen's
lists SHALL be as they were, with no copy restored and no restore awaiting confirmation. A restore
stopped before it was whole SHALL be undone when a commitments screen or a day screen next opens
those places, before anything is read from them, putting back what the three places and a save in
progress held before it began, and saying nothing. Where it cannot be undone, nothing SHALL be read
from those places nor written over them.

#### Scenario: a restore refused where the one-off place cannot be written leaves the record and the roster places as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place, and a tick for it on Sunday 30 August 2026 is kept
  at a record place; a commitments screen is opened as of Monday 31 August 2026 at those places and
  at a one-off place where nothing can be written — a path beneath an existing ordinary file; and it
  is asked to restore from a copy holding a commitment named "Journaling" and a one-off named "Book
  dentist", and the restore is confirmed
- **THEN** it is refused as a place that could not be written
- **AND** the content at the record place and at the roster place is byte-for-byte what it was
  immediately before the restore was confirmed, and nothing stands at the one-off place
- **AND** what it keeps is one entry, named "Gym", it holds no copy restored and no restore is
  awaiting confirmation
- **AND** a restore refused where the roster place rather than the one-off place cannot be written
  leaves the record place as it was

#### Scenario: a restore stopped before it was whole is undone when the places are next opened

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Sunday 30 August 2026 is kept at a
  record place; a one-off named "Book dentist" on 25 September 2026 is kept at a one-off place; a
  restore of a copy holding a commitment named "Journaling" and nothing else is left having written
  the record place and the roster place and not the one-off place, with the restore in progress it
  left standing; and a commitments screen is opened at those places as of Monday 31 August 2026
- **THEN** what it keeps is one entry, named "Gym"
- **AND** the content at all three places is byte-for-byte what it was before that restore began,
  and no restore in progress stands
- **AND** a day screen of no commitments at all opened at those places instead, on that day, holds
  one row, named "Gym"

#### Scenario: a restore in progress that cannot be undone leaves a screen reading nothing from the three places

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a run of bytes that is not a restore in progress
  stands where one is kept beside a record place where nothing has been kept; and a commitments
  screen is opened at those places and a one-off place where nothing has been kept as of Monday
  31 August 2026
- **THEN** it says it is not keeping a roster
- **AND** the content at the roster place is byte-for-byte what it was, and nothing is written at the
  record place or the one-off place
- **AND** a day screen of a commitment named "Journaling" opened at those places instead says it is
  keeping no record, no roster and no one-offs, and writes nothing at any of them

### Requirement: A day screen returned to from a commitments screen that restored a copy draws what the copy holds

A day screen returned to from a commitments screen that has restored a copy since that screen was
opened SHALL open its record place, its roster place and its one-off place afresh, whether or not it
was keeping each, and SHALL form its day view from what it then reads, taking on the commitments it
was handed where the roster it reads holds nothing at all. It SHALL NOT take a new today, nor move the
day it is showing. It SHALL then tell nothing on any row and nothing under any one-off name field.
Returned to from a commitments screen that has restored no copy, it SHALL be returned to exactly as
being returned to is.

#### Scenario: a day screen returned to after a restore draws the copy's commitments, records and one-offs

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a one-off named "Book dentist" on 31 August 2026 is
  kept at a one-off place; a day screen of no commitments at all is opened at those places and a
  record place where nothing has been kept as of Monday 31 August 2026; a commitments screen is
  opened at the same places and a copy is made through it as of that day at 14:32; the day screen's
  "Gym" row is then ticked, a commitment named "Journaling" alike in every other way is taken on
  through the commitments screen, and "Book dentist" is removed through the day screen; the
  commitments screen restores that copy; and the day screen is returned to from it
- **THEN** its day view holds one row, named "Gym", which says its commitment was not kept
- **AND** its One-offs group holds one row, named "Book dentist"

#### Scenario: a day screen that was keeping no record keeps the copy's record once returned to after a restore

- **WHEN** a record place holds a run of bytes that is not a record, and a one-off place a run of
  bytes that is not a one-off holder; a day screen of a commitment named "Gym" on a schedule listing
  all seven weekdays, kept from 1 January 2026, is opened at those places and a roster place where
  nothing has been kept as of Monday 31 August 2026; a commitments screen opened at the same places
  restores a copy holding that commitment and a tick for it on that day; and the day screen is
  returned to from it
- **THEN** it says it is keeping a record and keeping one-offs
- **AND** its day view holds one row, named "Gym", which says its commitment was kept

#### Scenario: a day screen returned to after a restore tells nothing it was telling

- **WHEN** a commitment named "Mood" of the number kind, taking 1 to 10, on a schedule listing all
  seven weekdays and kept from 1 January 2026, is taken on at a roster place; a one-off named "Book
  dentist" on 31 August 2026 is kept at a one-off place; a day screen of no commitments at all is
  opened at those places and a record place where nothing has been kept as of Monday 31 August 2026;
  11 is committed in the "Mood" row's number entry and refused; "Book dentist" is committed in its
  one-off entry and refused; a commitments screen opened at the same places restores a copy made
  there; and the day screen is returned to from it
- **THEN** it tells nothing on any row
- **AND** it tells nothing under its one-off entry

#### Scenario: a day screen returned to after a restore keeps the today it was handed and the day it was showing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place, a record place and a one-off place where nothing has been kept as of Monday
  31 August 2026 and moved to the day before; a commitments screen opened at the same places restores
  a copy made there; and the day screen is returned to from it
- **THEN** its day picker opens on Sunday 30 August 2026, and it offers the way back to today
- **AND** its day view holds one row, named "Gym"

#### Scenario: a day screen returned to from a commitments screen that restored no copy does not read its record again

- **WHEN** a record place holds a run of bytes that is not a record; a day screen of a commitment
  named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026, is opened at that
  place and a roster place and a one-off place where nothing has been kept as of Monday 31 August
  2026; a commitments screen is opened at the same places; what is at the record place is removed; a
  copy is made through the commitments screen as of that day at 14:32; and the day screen is returned
  to from it
- **THEN** it still says it is keeping no record

#### Scenario: a day screen returned to from a commitments screen that restored a copy and then kept a change opens all three places

- **WHEN** a record place holds a run of bytes that is not a record; a day screen of no commitments
  at all is opened at that place and a roster place and a one-off place where nothing has been kept
  as of Monday 31 August 2026; a commitments screen opened at the same places restores a copy holding
  a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026, and a
  tick for it on that day; a commitment named "Journaling" alike in every other way is then defined
  and kept through the commitments screen; and the day screen is returned to from it
- **THEN** it says it is keeping a record
- **AND** its day view holds two rows, named "Gym" and then "Journaling", the first saying its
  commitment was kept

#### Scenario: a day screen returned to after a copy of nothing was restored takes on the commitments it was handed

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened at a roster place, a record place and a one-off place where
  nothing has been kept as of Monday 31 August 2026, where a copy of three places holding nothing is
  then restored through a commitments screen opened at the same places; and the day screen is
  returned to from it
- **THEN** a roster store opened afterwards at that roster place holds one commitment, named
  "Journaling"
- **AND** its day view holds one row, named "Journaling"

### Requirement: A copy place is one folder, kept at a place of its own across the app being closed

The copy place SHALL be one folder, kept at a place of its own — neither the record place, the
roster place nor the one-off place — together with the moment of the last copy written there and,
where the last attempt failed, why it failed and the moment it first did. All three SHALL be read
back as they were left when the app is opened again. A copy SHALL hold nothing of the copy place,
and confirming a restore SHALL leave the folder that is the copy place exactly as it was. Where no
folder has been given, the copy place SHALL hold no folder, no last copy and no stop.

#### Scenario: a copy place is read back as it was left by one opened again at the same place

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its
  own and asking a clock that answers that day at 14:32; a directory of its own is given to it as
  its copy place; and a second copy place is opened at the place the first was kept at
- **THEN** the second holds that directory as the copy place, and Monday 31 August 2026 at 14:32 as
  the last copy made there
- **AND** it holds no stop
- **AND** the place a copy place is kept at is none of the record place, the roster place and the
  one-off place

#### Scenario: a copy place where nothing has been kept holds no folder, no last copy and no stop

- **WHEN** a copy place is opened at a place where no copy place has ever been kept
- **THEN** it opens without error, and holds no folder, no last copy and no stop

#### Scenario: a restore confirmed leaves the folder that is the copy place as it was

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place,
  a record place and a one-off place where nothing has been kept as of Monday 31 August 2026, keeping
  its copy place at a place of its own and asking a clock that answers a later minute each time it is
  asked, from that day at 14:32; a directory of its own is given to it as its copy place; and it is
  asked to restore from a copy holding a roster of one commitment named "Journaling" on that rhythm
  and the restore is confirmed
- **THEN** the copy place is still that directory
- **AND** a copy place opened at the place this one is kept at holds that same directory

### Requirement: A folder given to a commitments screen becomes the copy place, and a copy is written there at once

A commitments screen given a folder SHALL make it the copy place and SHALL write a copy there at
once, as of the moment its clock then answers. Every copy written at the copy place SHALL be one
file named `DayByDay.daybyday`, holding what a copy holds, and SHALL replace a file of that name
already standing in that folder. Where the copy is written, its moment SHALL become the last copy
and no stop SHALL stand. Where it cannot be written the folder SHALL still become the copy place,
no last copy SHALL stand, and the stop SHALL be held as of that moment. A folder given while another
is the copy place SHALL leave the file at the folder it replaces exactly as it is.

#### Scenario: a folder given as the copy place holds a copy of the three places at once

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Sunday 30 August 2026 is kept at a
  record place; a one-off named "Book dentist" on 25 September 2026 is kept at a one-off place; a
  commitments screen is opened at those three places as of Monday 31 August 2026, keeping its copy
  place at a place of its own and asking a clock that answers that day at 14:32; and a directory of
  its own is given to it as its copy place
- **THEN** that directory holds one file, named `DayByDay.daybyday`
- **AND** what is written there is a copy made at Monday 31 August 2026 at 14:32, holding a roster of
  one entry named "Gym", a history keeping "Gym" on Sunday 30 August 2026 and on no other day, and
  one one-off named "Book dentist" on 25 September 2026
- **AND** the last copy made is that same moment, and no stop stands

#### Scenario: a copy written at the copy place replaces the file of that name already standing there

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers a later minute each time it is asked, from that day at 14:32; a
  directory of its own is given to it as its copy place; and a commitment named "Gym" on a schedule
  listing all seven weekdays, kept from 1 January 2026, is then defined through it
- **THEN** that directory holds one file, named `DayByDay.daybyday`
- **AND** what is written there is a copy made at Monday 31 August 2026 at 14:33, holding a roster of
  one entry named "Gym"
- **AND** the last copy made is that same moment

#### Scenario: a folder given as the copy place that cannot be written becomes the copy place with a stop and no last copy

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers that day at 14:32; and a directory that cannot be written to is
  given to it as its copy place
- **THEN** the copy place is that directory, and no last copy stands
- **AND** the stop is the folder that cannot be written, as of Monday 31 August 2026 at 14:32

#### Scenario: a folder given in another's stead leaves the file at the folder it replaces as it was

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers a later minute each time it is asked, from that day at 14:32; a
  first directory of its own is given to it as its copy place; and a second directory of its own is
  then given to it as its copy place
- **THEN** the copy place is the second directory, and it holds one file named `DayByDay.daybyday`
  made at Monday 31 August 2026 at 14:33
- **AND** the file at the first directory is byte-for-byte what it was before the second was given

### Requirement: A folder that already holds a copy asks to restore it before it becomes the copy place

Where the folder a commitments screen is given holds a file named `DayByDay.daybyday` that reads as
a copy, the screen SHALL set no copy place and SHALL write nothing, and SHALL hold a restore
awaiting confirmation for that file saying exactly what it says for a restore asked for from any
file. Confirming it SHALL restore that copy as any confirmed restore is made, and SHALL then make
that folder the copy place. The screen SHALL also offer replacing the copy standing there with this
phone's: that SHALL restore nothing, leave nothing awaiting a restore, and make that folder the copy
place as any folder given becomes one. Cancelling SHALL set no copy place and SHALL leave the file
in that folder exactly as it is.

#### Scenario: a folder holding a copy asks to restore that copy and sets no copy place

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place,
  a record place and a one-off place where nothing has been kept as of Monday 31 August 2026, keeping
  its copy place at a place of its own and asking a clock that answers a later minute each time it is
  asked, from that day at 14:32; and a directory holding a file named `DayByDay.daybyday` that is a
  copy made at Sunday 30 August 2026 at 09:07, keeping two commitments and holding one one-off, is
  given to it as its copy place
- **THEN** it is not refused, and the restore awaiting confirmation says Sunday 30 August 2026 at
  09:07, that the copy keeps two commitments, has stopped none and holds one one-off, and that the
  phone keeps one commitment, has stopped none and holds no one-offs
- **AND** no copy place is set, and that directory's file is byte-for-byte what it was

#### Scenario: a restore confirmed from a folder given as the copy place makes that folder the copy place

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place,
  a record place and a one-off place where nothing has been kept as of Monday 31 August 2026, keeping
  its copy place at a place of its own and asking a clock that answers a later minute each time it is
  asked, from that day at 14:32; a directory holding a file named `DayByDay.daybyday` that is a copy
  holding a roster of one entry named "Journaling" on that rhythm is given to it as its copy place;
  and the restore is confirmed
- **THEN** what it keeps is one entry, named "Journaling", and the copy place is that directory
- **AND** that directory holds one file named `DayByDay.daybyday`, made at Monday 31 August 2026 at
  14:32, holding a roster of one entry named "Journaling"

#### Scenario: a copy at a folder given as the copy place replaced with this phone's makes that folder the copy place

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place,
  a record place and a one-off place where nothing has been kept as of Monday 31 August 2026, keeping
  its copy place at a place of its own and asking a clock that answers a later minute each time it is
  asked, from that day at 14:32; a directory holding a file named `DayByDay.daybyday` that is a copy
  holding a roster of one entry named "Journaling" on that rhythm is given to it as its copy place;
  and the copy there is replaced with this phone's
- **THEN** what it keeps is one entry, named "Gym", and nothing is awaiting a restore
- **AND** the copy place is that directory, and its one file named `DayByDay.daybyday` is a copy made
  at Monday 31 August 2026 at 14:32 holding a roster of one entry named "Gym"

#### Scenario: a folder given as the copy place whose restore is cancelled becomes no copy place and is left as it was

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers a later minute each time it is asked, from that day at 14:32; a
  directory holding a file named `DayByDay.daybyday` that is a copy holding a roster of one entry
  named "Journaling" on a schedule listing all seven weekdays, kept from 1 January 2026, is given to
  it as its copy place; and the restore is cancelled
- **THEN** nothing is awaiting a restore, no copy place is set, and no last copy and no stop stand
- **AND** that directory's file is byte-for-byte what it was before the directory was given
- **AND** the content at all three places is byte-for-byte what it was before the directory was given

### Requirement: A folder holding a copy that cannot be read is refused as a copy place

Where the folder a commitments screen is given holds a file named `DayByDay.daybyday` that does not
read as a copy, the screen SHALL refuse the folder for that file's own reason, told apart exactly as
a file asked to be restored from is: not a copy, a damaged copy, or a copy from a later version. It
SHALL set no copy place, SHALL write nothing, SHALL leave no restore awaiting confirmation, and
SHALL leave a copy place already set, its last copy and its stop exactly as they were. It SHALL hold
that refusal apart from the change it holds refused, SHALL hold at most one at a time, and SHALL end
it when the app is shown again or another folder is given.

#### Scenario: a folder holding a file of a copy's name that is not a copy is refused, and no copy place is set

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers that day at 14:32; and a directory holding a file named
  `DayByDay.daybyday` that is a run of bytes that is not a copy is given to it as its copy place
- **THEN** it is refused as not a copy, and no copy place is set
- **AND** nothing is awaiting a restore, and that directory's file is byte-for-byte what it was

#### Scenario: a folder holding a damaged copy and one holding a copy from a later version are each refused for their own reason

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers that day at 14:32; and a directory holding a file named
  `DayByDay.daybyday` that is a copy whose roster lacks a field its form always writes is given to it
  as its copy place
- **THEN** it is refused as a damaged copy, and no copy place is set
- **AND** a directory whose `DayByDay.daybyday` says a form later than a copy is written in now is
  refused as a copy from a later version

#### Scenario: a folder refused leaves the copy place already set, its last copy and its stop as they were

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers a later minute each time it is asked, from that day at 14:32; a
  first directory of its own is given to it as its copy place; and a second directory holding a file
  named `DayByDay.daybyday` that is a run of bytes that is not a copy is then given to it
- **THEN** it is refused as not a copy
- **AND** the copy place is still the first directory, the last copy made is still Monday
  31 August 2026 at 14:32, and no stop stands

#### Scenario: a folder refused is held apart from a refused change, and ends when the app is shown again

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place,
  a record place and a one-off place where nothing has been kept as of Monday 31 August 2026, keeping
  its copy place at a place of its own and asking a clock that answers that day at 14:32; a second
  commitment named "Gym" on that same rhythm and day is defined through it and refused for its name;
  and a directory holding a file named `DayByDay.daybyday` that is a run of bytes that is not a copy
  is then given to it as its copy place
- **THEN** it holds the folder refused as not a copy, and still holds the refused definition against
  defining a commitment
- **AND** once the app is shown again as of that same day it holds no folder refused
- **AND** a second directory of its own given to it afterwards leaves it holding no folder refused

### Requirement: A copy that cannot be made at the copy place refuses no change

A change a person keeps SHALL be kept whether or not the copy that follows it can be made, and the
caller SHALL be answered exactly as it is where the copy is made. Where the copy cannot be made, the
app SHALL hold why and the moment it first could not, SHALL leave the last copy made exactly as it
was, and MUST NOT hold it as a change it refused. Why SHALL be told apart as the folder that cannot
be reached, the folder that cannot be written, a store that could not be read, and a store written
by a later version of DayByDay, each of the last two naming which store. A later change that also
fails SHALL leave that moment where it is. The next change kept
SHALL try again, and a copy made SHALL end the stop and become the last copy.

#### Scenario: a tick kept where the copy place cannot be written is kept and is not refused

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen is opened at that roster place, a record
  place and a one-off place where nothing has been kept as of Monday 31 August 2026, keeping its copy
  place at a place of its own and asking a clock that answers a later minute each time it is asked,
  from that day at 14:32; a directory that cannot be written to is given as its copy place through a
  commitments screen opened at those same places; and the row named "Gym" is ticked
- **THEN** the tick is not refused, and the day view says the commitment is kept on that date
- **AND** a record store opened at that record place holds that tick
- **AND** the stop is the folder that cannot be written, as of Monday 31 August 2026 at 14:32

#### Scenario: a folder that cannot be reached is told apart from one that cannot be written

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers a later minute each time it is asked, from that day at 14:32; a
  directory of its own is given to it as its copy place; that directory is then taken away; and a
  commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026, is
  defined through it
- **THEN** the commitment is not refused, and what it keeps is one entry, named "Gym"
- **AND** the stop is the folder that cannot be reached, as of Monday 31 August 2026 at 14:33, and
  the last copy made is still Monday 31 August 2026 at 14:32

#### Scenario: a change kept where a store cannot be read is kept, and the stop names that store

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen is opened at that roster place, a record
  place and a one-off place where nothing has been kept as of Monday 31 August 2026, keeping its copy
  place at a place of its own and asking a clock that answers a later minute each time it is asked,
  from that day at 14:32; a directory of its own is given as its copy place through a commitments
  screen opened at those same places; what is at that one-off place is then made a run of bytes that
  is not a one-off holder; and the row named "Gym" is ticked
- **THEN** the tick is not refused, and a record store opened at that record place holds that tick
- **AND** the stop is a store that could not be read, naming the one-offs, as of Monday 31 August
  2026 at 14:33

#### Scenario: a change kept where a store was written by a later version stops with that cause rather than a store that could not be read

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen is opened at that roster place, a record
  place and a one-off place where nothing has been kept as of Monday 31 August 2026, keeping its copy
  place at a place of its own and asking a clock that answers a later minute each time it is asked,
  from that day at 14:32; a directory of its own is given as its copy place through a commitments
  screen opened at those same places; what is at that one-off place is then made one-offs written in
  a form one later than the form this app writes; and the row named "Gym" is ticked
- **THEN** the tick is not refused, and a record store opened at that record place holds that tick
- **AND** the stop is a store written by a later version of DayByDay, naming the one-offs, as of
  Monday 31 August 2026 at 14:33, told apart from a store that could not be read

#### Scenario: a stop keeps the moment it began over later changes that also fail

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers a later minute each time it is asked, from that day at 14:32; a
  directory that cannot be written to is given to it as its copy place; and a commitment named "Gym"
  on a schedule listing all seven weekdays, kept from 1 January 2026, is defined through it and then
  stopped
- **THEN** neither change is refused
- **AND** the stop is still the folder that cannot be written, as of Monday 31 August 2026 at 14:32,
  and no last copy stands

#### Scenario: a change kept after a stop, where the folder can be written again, ends the stop and becomes the last copy

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers a later minute each time it is asked, from that day at 14:32; a
  directory that cannot be written to is given to it as its copy place; a commitment named "Gym" on a
  schedule listing all seven weekdays, kept from 1 January 2026, is defined through it; that directory
  is then made writable; and "Gym" is stopped through it
- **THEN** no stop stands, and the last copy made is Monday 31 August 2026 at 14:34
- **AND** that directory's one file named `DayByDay.daybyday` holds a roster whose one entry is
  stopped

#### Scenario: a copy that could not be made is not held as a refused change

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers a later minute each time it is asked, from that day at 14:32; a
  commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026, is
  defined through it twice, the second refused for its name; and a directory that cannot be written
  to is given to it as its copy place
- **THEN** the copy that could not be made there is not held as a refused change: the screen holds
  the refused definition against defining a commitment exactly as it did
- **AND** the stop is the folder that cannot be written
- **AND** a commitment named "Journaling" on that rhythm then defined through it is not refused and
  leaves the screen holding no refused change — neither the definition refused before, which keeping
  "Journaling" ended, nor the copy that again could not be made — with the stop still the folder that
  cannot be written

### Requirement: A commitments screen says its copy place, the last copy made there and a stop

A commitments screen SHALL say the name of the folder that is its copy place, the moment of the last
copy written there and, where the last attempt failed, the stop and the moment it began, beside that
last copy. Where no copy place is set it SHALL say no folder, no last copy and no stop. A copy it
made because it was asked for one MUST NOT be the last copy it says. It MUST NOT read the folder in
order to say any of this: only a folder given or a change kept SHALL find out that a folder cannot
be reached, so a screen opened or shown again SHALL say exactly what the last attempt left.

#### Scenario: a commitments screen says the name of the folder that is its copy place and the last copy made there

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers that day at 14:32; and a directory of its own named "Backups" is
  given to it as its copy place
- **THEN** it says its copy place is named "Backups"
- **AND** it says the last copy made there is Monday 31 August 2026 at 14:32, and says no stop

#### Scenario: a commitments screen says the stop and the moment it began beside the last copy made

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers a later minute each time it is asked, from that day at 14:32; a
  directory of its own named "Backups" is given to it as its copy place; that directory is then made
  unwritable; and a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is defined through it
- **THEN** it says the last copy made is Monday 31 August 2026 at 14:32
- **AND** it says the stop is the folder that cannot be written, since Monday 31 August 2026 at 14:33

#### Scenario: a commitments screen with no copy place says no folder, no last copy and no stop

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place where no
  copy place has ever been kept
- **THEN** it says no copy place, no last copy and no stop
- **AND** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, defined through it is not refused and leaves all three as they are

#### Scenario: a copy asked for and made is not the last copy a commitments screen says

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers that day at 14:32; a directory of its own is given to it as its copy
  place; and a copy is then asked for as of that day at 16:05, written into a directory of its own
- **THEN** the copy asked for is not refused
- **AND** it says the last copy made is Monday 31 August 2026 at 14:32, and says no stop
- **AND** the copy place holds one file named `DayByDay.daybyday` made at 14:32

#### Scenario: a commitments screen shown again with its folder gone says what the last attempt left

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers a later minute each time it is asked, from that day at 14:32; a
  directory of its own named "Backups" is given to it as its copy place; that directory is then taken
  away; and the app is shown again as of that same day
- **THEN** it says its copy place is named "Backups", says the last copy made is Monday 31 August
  2026 at 14:32, and says no stop
- **AND** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026,
  then defined through it leaves it saying the folder cannot be reached, since Monday 31 August 2026
  at 14:33

### Requirement: A commitments screen forgets its copy place

Asked to forget its copy place, a commitments screen SHALL afterwards hold no folder, no last copy
and no stop, and a copy place opened again at the place it is kept at SHALL hold none of the three.
Forgetting SHALL write nothing at the record place, the roster place or the one-off place, and SHALL
leave the file at the folder it forgot exactly as it is. A change kept afterwards SHALL write no copy
anywhere and SHALL be kept exactly as it is with a copy place set. Asked to forget where no copy
place is set, the screen SHALL change nothing.

#### Scenario: a copy place forgotten leaves no folder, no last copy and no stop

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers a later minute each time it is asked, from that day at 14:32; a
  directory of its own is given to it as its copy place; and it is asked to forget its copy place
- **THEN** it says no copy place, no last copy and no stop
- **AND** a copy place opened at the place it is kept at holds none of the three

#### Scenario: a copy place forgotten leaves the file at the folder it forgot as it was

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers a later minute each time it is asked, from that day at 14:32; a
  directory of its own is given to it as its copy place; and it is asked to forget its copy place
- **THEN** that directory's one file named `DayByDay.daybyday` is byte-for-byte what it was before
  the copy place was forgotten
- **AND** the content at all three places is byte-for-byte what it was before it was forgotten

#### Scenario: a change kept after the copy place is forgotten writes no copy and is not refused

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers a later minute each time it is asked, from that day at 14:32; a
  directory of its own is given to it as its copy place; it is asked to forget its copy place; and a
  commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026, is
  defined through it
- **THEN** the commitment is not refused, and what it keeps is one entry, named "Gym"
- **AND** that directory's one file named `DayByDay.daybyday` is byte-for-byte what it was before the
  copy place was forgotten, and it says no last copy and no stop

#### Scenario: forgetting where no copy place is set changes nothing

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place where no
  copy place has ever been kept, and it is asked to forget its copy place
- **THEN** it says no copy place, no last copy and no stop
- **AND** the content at all three places is byte-for-byte what it was before it was asked

### Requirement: A write the app makes on its own writes no copy

A write the person did not ask for SHALL write no copy at the copy place and SHALL leave the last
copy and any stop exactly as they were: a torn save undone, a torn restore undone, an orphaned record
carried back to its one possible source when the places are read, and the commitments a day screen
takes on where its roster place holds nothing. A copy SHALL follow only a change the person made.

#### Scenario: a torn save undone when a screen is opened writes no copy at the copy place

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a
  record place; a rename of "Gym" to "Gym 🏋️" is torn between the record place and the roster place;
  and a commitments screen is opened at those places and a one-off place where nothing has been kept
  as of Monday 31 August 2026, keeping its copy place at a place of its own holding a directory of
  its own as the copy place and a last copy made at that day at 09:07
- **THEN** the torn save is undone, and what it keeps is one entry, named "Gym"
- **AND** the last copy made is still Monday 31 August 2026 at 09:07, no stop stands, and that
  directory holds no file

#### Scenario: a torn restore undone when a screen is opened writes no copy at the copy place

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a restore is stopped before it was whole across that
  roster place, a record place and a one-off place; and a commitments screen is opened at those places
  as of Monday 31 August 2026, keeping its copy place at a place of its own holding a directory of its
  own as the copy place and a last copy made at that day at 09:07
- **THEN** the torn restore is undone, and what it keeps is one entry, named "Gym"
- **AND** the last copy made is still Monday 31 August 2026 at 09:07, no stop stands, and that
  directory holds no file

#### Scenario: an orphaned record carried back writes no copy at the copy place

- **WHEN** a record place holds a record of a commitment a roster place holds in no state, with
  exactly one possible source among the commitments that roster holds; and a commitments screen is
  opened at those places and a one-off place where nothing has been kept as of Monday 31 August 2026,
  keeping its copy place at a place of its own holding a directory of its own as the copy place and a
  last copy made at that day at 09:07
- **THEN** the record is carried back to its one possible source
- **AND** the last copy made is still Monday 31 August 2026 at 09:07, no stop stands, and that
  directory holds no file

#### Scenario: the commitments a day screen takes on where its roster place holds nothing write no copy

- **WHEN** a day screen is opened as of Monday 31 August 2026 at a roster place, a record place and a
  one-off place where nothing has been kept, starting from a commitment named "Gym" on a schedule
  listing all seven weekdays, kept from 1 January 2026, keeping its copy place at a place of its own
  holding a directory of its own as the copy place and a last copy made at that day at 09:07
- **THEN** a roster store opened at that roster place holds one entry, named "Gym"
- **AND** the last copy made is still Monday 31 August 2026 at 09:07, no stop stands, and that
  directory holds no file

### Requirement: A take-out is the files at the three places exactly as they lie

A take-out SHALL be the file standing at the record place, the file standing at the roster place and
the file standing at the one-off place, each as it lies and under the name it lies under, together
with a save in progress and a restore in progress still standing beside them. A place where no file
stands SHALL contribute none and SHALL NOT refuse the take-out. Forming a take-out SHALL read no
store as a value, SHALL bring nothing to the form the app writes now, SHALL undo no save in progress
and no restore in progress, and SHALL leave every one of those files byte-for-byte as it found them.
The copy place SHALL NOT be taken out.

#### Scenario: a take-out hands out the three files byte-for-byte under the names they lie under

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a one-off named "Book dentist" on 25 September 2026
  is kept at a one-off place; what is at the record place beside them is made a run of bytes that is
  not a record; and a commitments screen opened at those three places as of Monday 31 August 2026 is
  asked for a take-out, written into a directory of its own
- **THEN** it is not refused, and three files stand there, named as the files at the three places are
  named
- **AND** each holds byte-for-byte what stands at the place it was taken from
- **AND** a take-out of a roster kept in the earliest form a roster store reads hands out those same
  bytes, unchanged

#### Scenario: a take-out where nothing has been kept at a place hands out only the files that stand

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place holding a run
  of bytes that is not a roster, and at a record place and a one-off place where nothing has been
  kept, and it is asked for a take-out, written into a directory of its own
- **THEN** it is not refused, and one file stands there, holding byte-for-byte what is at that roster
  place
- **AND** nothing is written at the record place or the one-off place

#### Scenario: a take-out hands out a save in progress and a restore in progress that could not be undone

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a run of bytes that is not a save in progress and a
  run of bytes that is not a restore in progress are each kept where one is kept beside the record
  place; and a commitments screen opened at those places and at a one-off place where nothing has
  been kept as of Monday 31 August 2026 is asked for a take-out, written into a directory of its own
- **THEN** it is not refused, and the file at the roster place, the save in progress and the restore
  in progress each stand there, byte-for-byte as they lie
- **AND** the save in progress and the restore in progress are still at their places, byte-for-byte
  what they were

#### Scenario: a take-out does not hand out the copy place

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a record place holding a run
  of bytes that is not a record, and at a roster place and a one-off place where nothing has been
  kept, keeping its copy place at a place of its own in the directory those three stand in and asking
  a clock that answers that day at 14:32; a directory of its own is given to it as its copy place;
  and it is asked for a take-out, written into a directory of its own
- **THEN** it is not refused, and one file stands there, holding byte-for-byte what is at that record
  place
- **AND** nothing it hands out was taken from the place the copy place is kept at, and the copy place
  still says the folder it was given

### Requirement: A commitments screen offers a take-out only while a store cannot be read, and says which

A commitments screen SHALL offer a take-out exactly while at least one of the record place, the
roster place and the one-off place cannot be read, whether what lies there is not a store of its kind
or was written by a later version of DayByDay; where all three read it SHALL offer none. With the
offer it SHALL say every place that cannot be read, in the order record, roster, one-offs, and for
each SHALL say which of those two things is so, told apart from one another. It SHALL read the three
places when it is opened, when the app is shown again and when a restore is confirmed, and MUST NOT
read them because it is drawn. A screen holding a save in progress or a restore in progress it could
not undo SHALL say all three could not be read.

#### Scenario: a commitments screen whose three places all read offers no take-out

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place, and a commitments screen is opened at that roster
  place, a record place and a one-off place where nothing has been kept as of Monday 31 August 2026
- **THEN** it offers no take-out, and says no place that could not be read

#### Scenario: a commitments screen offers a take-out naming every place that cannot be read, in the order record, roster, one-offs

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a record place, a roster
  place and a one-off place each holding a run of bytes that is not a store of its kind
- **THEN** it offers a take-out, and says the record, then the roster, then the one-offs, each as a
  place that could not be read
- **AND** a screen opened where only the one-off place holds such a run of bytes offers one and says
  the one-offs alone

#### Scenario: a commitments screen offers a take-out over a store written by a later version, and says so rather than that it could not be read

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place holding a
  roster written in a form one later than the form this app writes, and at a record place and a
  one-off place where nothing has been kept
- **THEN** it offers a take-out, and says the roster as a place written by a later version of
  DayByDay, told apart from one that could not be read
- **AND** a screen opened where the record place holds a record written in a later form and the
  one-off place holds a run of bytes that is not a one-off holder says the record as written by a
  later version and the one-offs as a place that could not be read

#### Scenario: a commitments screen shown again says what the three places then hold

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept; what is at that record place is then made a
  run of bytes that is not a record; and the screen is shown again as of that same day
- **THEN** it offered no take-out before it was shown again, and offers one afterwards, saying the
  record
- **AND** with what is at that record place then made readable, it still offers one until it is shown
  again, and offers none once it is

#### Scenario: a commitments screen that confirmed a restore offers no take-out

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a record place holding a run
  of bytes that is not a record, and at a roster place and a one-off place where nothing has been
  kept; and it is asked to restore from a copy made on that day at 14:32 holding a roster of one
  commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026, and the
  restore is confirmed
- **THEN** it offered a take-out before the restore was confirmed, and offers none afterwards

#### Scenario: a commitments screen holding a save in progress it could not undo offers a take-out naming all three

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a run of bytes that is not a save in progress is kept
  where one is kept beside a record place where nothing has been kept; and a commitments screen is
  opened at those places and at a one-off place where nothing has been kept as of Monday 31 August
  2026
- **THEN** it offers a take-out, and says the record, the roster and the one-offs, each as a place
  that could not be read

### Requirement: A commitments screen takes out the files when it is asked, and holds nothing about one it took out

Asked for a take-out, a commitments screen SHALL write every file that take-out holds where it is
given to write take-outs into, each under the name it lies under at its place, and SHALL answer where
each was written, in the order record, roster, one-offs, save in progress, restore in progress. It
SHALL write nothing else anywhere, and a take-out it makes MUST NOT stand where the files of another
it made stand. Asked for one where it offers none, it SHALL hand out nothing and write nothing. A
take-out it made SHALL leave the screen exactly as it was: what it keeps, what it has stopped, the
commitment awaiting confirmation, the commitment awaiting deletion, the name typed back and the
refused change it holds SHALL each be what they were, and it SHALL say nothing of its own about a
take-out it made.

#### Scenario: a commitments screen asked for a take-out answers where every file was written, in the order record, roster, one-offs

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a one-off named "Book dentist" on 25 September 2026
  is kept at a one-off place; what is at the record place beside them is made a run of bytes that is
  not a record; and a commitments screen opened at those three places as of Monday 31 August 2026 is
  asked for a take-out, written into a directory of its own
- **THEN** it answers three places, the record's first, then the roster's, then the one-offs', and a
  file stands at each
- **AND** the directory it was given holds those three files and no other

#### Scenario: a take-out made leaves a commitments screen's lists and what it is awaiting exactly as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, and one named "Journaling" alike in every other way are taken on at a roster place;
  "Journaling" is stopped there as of Sunday 30 August 2026; a one-off place beside them is made a
  run of bytes that is not a one-off holder; a commitments screen is opened at those places and at a
  record place where nothing has been kept as of Monday 31 August 2026; it is asked to delete "Gym"
  and "Gym" is typed back; and a take-out is asked for
- **THEN** what it keeps is one entry, named "Gym", and what it has stopped is one entry, named
  "Journaling"
- **AND** "Gym" is still awaiting deletion, with "Gym" still typed back
- **AND** nothing is awaiting confirmation

#### Scenario: a take-out made leaves a refused change standing and says nothing of its own

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a one-off place beside it is made a run of bytes
  that is not a one-off holder; a commitments screen is opened at those places and at a record place
  where nothing has been kept as of Monday 31 August 2026; a second commitment named "Gym" on that
  same rhythm and day is defined through it and refused for its name; and a take-out is asked for
- **THEN** the take-out is not refused, and the screen still holds that refused definition against
  defining a commitment
- **AND** it says nothing of its own about the take-out it made

#### Scenario: a take-out asked for where a commitments screen offers none hands out nothing and writes nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place, and a commitments screen opened at that roster
  place, a record place and a one-off place where nothing has been kept as of Monday 31 August 2026
  is asked for a take-out, written into a directory of its own
- **THEN** it answers no place at all, and is not refused
- **AND** no file stands in that directory, and the content at the roster place is byte-for-byte what
  it was immediately after the screen was opened

#### Scenario: a take-out asked for twice leaves the files of the first standing

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place holding a run
  of bytes that is not a roster, and at a record place and a one-off place where nothing has been
  kept; a take-out is asked for, written into a directory of its own; and a take-out is asked for
  again, written into that same directory
- **THEN** neither is refused, and the two answer different places
- **AND** the file the first answered still holds byte-for-byte what it held

### Requirement: A take-out that cannot be made hands out nothing and leaves the places as they were

Where a file the take-out holds cannot be handed over as it lies, or where the files cannot be
written where they are to be written, a commitments screen SHALL hand out no file at all and SHALL
answer why: a store that could not be taken out, naming it, or a place that could not be written,
naming none, told apart from one another. A save in progress and a restore in progress SHALL each be
named as the record, the place they stand beside. It SHALL leave no file of its own where it was to
write, and the record place, the roster place, the one-off place and both in-progress files SHALL be
byte-for-byte what they were. What the screen then holds about the refused take-out is the refused
change it holds for every other change it would not make.

#### Scenario: a take-out refused names the store that could not be taken out and hands out none of the others

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; the record place beside it is made a directory
  holding nothing rather than a file; and a commitments screen opened at those places and at a
  one-off place where nothing has been kept as of Monday 31 August 2026 is asked for a take-out,
  written into a directory of its own
- **THEN** it is refused as a store that could not be taken out, naming the record
- **AND** no file stands in that directory
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened
- **AND** a take-out refused over a save in progress that cannot be handed over is refused the same
  way, naming the record

#### Scenario: a take-out that cannot be written where it is to be written is refused as a place that could not be written

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place holding a run
  of bytes that is not a roster, and at a record place and a one-off place where nothing has been
  kept, and it is asked for a take-out, written into a directory that cannot be written to
- **THEN** it is refused as a place that could not be written, told apart from a store that could not
  be taken out, and naming no store
- **AND** no file stands in that directory

#### Scenario: a take-out refused replaces the refused change a commitments screen held

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place,
  a record place where nothing has been kept, and a one-off place holding a run of bytes that is not
  a one-off holder as of Monday 31 August 2026; a second commitment named "Gym" on that same rhythm
  and day is defined through it and refused for its name; and a take-out is asked for, written into
  a directory that cannot be written to
- **THEN** the screen holds the refused take-out, and no longer holds the refused definition

### Requirement: A day screen that is not keeping a store says a copy can be restored and where

A day screen SHALL say that a copy can be restored and SHALL name the commitments screen as where,
exactly while it could not read its record, could not read its one-offs, or is not keeping its roster
for either of that roster's two causes. However many of the three are so, it SHALL say it once and no
more. It MUST NOT say it where the only store it is not keeping was written by a later version of
DayByDay, and MUST NOT say it where it is keeping all three. What it says SHALL be words alone,
offering nothing to act on, and saying it SHALL read no place and change nothing.

#### Scenario: a day screen that cannot read its record says a copy can be restored and where

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place holding a run of
  bytes that is not a record, with a roster place and a one-off place where nothing has been kept, of
  a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026
- **THEN** it says a copy can be restored, and names the commitments screen as where
- **AND** a day screen that is not keeping its roster, and one that cannot read its one-offs, each say
  the same
- **AND** a day screen that cannot read its record beside a roster written by a later version of
  DayByDay says the same

#### Scenario: a day screen not keeping any of its three stores says a copy can be restored once

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place, a roster place and
  a one-off place each holding a run of bytes that is not a store of its kind, of a commitment named
  "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026
- **THEN** it says a copy can be restored, once and no more, whatever the number of stores it is not
  keeping

#### Scenario: a day screen whose only store not kept was written by a later version says nothing about restoring a copy

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place holding a record
  written in a form one later than the form this app writes, with a roster place and a one-off place
  where nothing has been kept, of a commitment named "Gym" on a schedule listing all seven weekdays,
  kept from 1 January 2026
- **THEN** it does not say a copy can be restored
- **AND** a day screen whose roster alone, and one whose one-offs alone, were written in a form one
  later than the form this app writes each say nothing about restoring a copy either

#### Scenario: a day screen keeping all three of its stores says nothing about restoring a copy

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place, a roster place and
  a one-off place where nothing has been kept, of a commitment named "Gym" on a schedule listing all
  seven weekdays, kept from 1 January 2026
- **THEN** it does not say a copy can be restored
- **AND** a day screen that could not read its record, once what is at that place is made readable and
  the app is shown again, says nothing about restoring a copy either

### Requirement: A copy carries whether its roster was emptied, and holds no commitment removed

A copy SHALL carry whether its roster was emptied, and a restore confirmed from a copy of an emptied
roster SHALL leave the roster place holding an emptied roster, so that a day screen opened or
returned to afterwards SHALL take nothing on. A copy made after a deletion SHALL hold neither the
deleted commitment nor any record against it. A copy whose roster holds a commitment removed SHALL
be read as a roster store reads one, that commitment as deleted, and every record against it in the
copy SHALL be left out of what the restore says it brings and of what it writes at the record place.
A copy SHALL NOT be refused for holding one.

#### Scenario: a copy of an emptied roster restores an emptied roster, and a day screen takes nothing on

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place, a record
  place and a one-off place where nothing has been kept as of Monday 31 August 2026; "Gym" is deleted
  through it; a copy is made through it as of that day at 14:32; a commitment named "Run" alike in
  every other way is then defined through it; the screen is asked to restore from that copy and the
  restore is confirmed; and a day screen of a commitment named "Journaling" alike in every other way
  is opened at those places as of Monday 31 August 2026
- **THEN** the commitments screen keeps nothing and has stopped nothing
- **AND** the day screen's day view holds no rows, and "Journaling" is not at that roster place

#### Scenario: a copy made after a deletion holds neither the commitment nor its records

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; ticks for each on Monday
  3 August 2026 are kept at a record place; a commitments screen is opened at those places and a
  one-off place where nothing has been kept as of Monday 31 August 2026; "Gym" is deleted through it;
  and a copy is made through it as of that day at 14:32
- **THEN** the copy's roster keeps one commitment, named "Run"
- **AND** the copy's history answers that "Run" was kept on Monday 3 August 2026 and holds no other
  record

#### Scenario: a copy holding a removed commitment restores none of it and none of its records

- **WHEN** a file holds a copy whose roster is in the form used before a commitment could be deleted,
  its entries "Gym" held removed and kept until 30 August 2026 and "Run" kept, both on a schedule
  listing all seven weekdays and kept from 1 January 2026, and whose history holds a tick for each on
  Monday 3 August 2026; a commitments screen is opened as of Monday 31 August 2026 at a roster place,
  a record place and a one-off place where nothing has been kept; and it is asked to restore from
  that file
- **THEN** it is not refused, and the restore awaiting confirmation says the copy keeps one
  commitment and has stopped none
- **AND** once the restore is confirmed, what it keeps is one entry, named "Run", and a store opened
  at that record place holds one record, that "Run" was kept on Monday 3 August 2026

### Requirement: A copy is written at the copy place after every change a person keeps, a deletion included

Where a copy place is set, the app SHALL write a copy there after every change a person keeps at the
record place, the roster place or the one-off place, as of the moment its clock answers once that
change is kept: a tick made or taken back on a commitment or on a one-off; a number, a note or a
total entered or taken back; the last addition taken back; a one-off added, renamed or removed; a
commitment defined, changed, restarted, stopped, deleted, taken up again, moved, or moved as a
group; and a restore confirmed. One change SHALL write exactly one copy however many places it
reached, a deletion that erased records at the record place and wrote the roster place included, and that copy SHALL hold the three places as they stand once the change is kept. A call
that keeps nothing anywhere SHALL write no copy and SHALL leave the last copy as it was.

#### Scenario: a tick kept on a day screen writes a copy at the copy place holding that tick

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen is opened at that roster place, a record
  place and a one-off place where nothing has been kept as of Monday 31 August 2026, keeping its copy
  place at a place of its own and asking a clock that answers a later minute each time it is asked,
  from that day at 14:32; a directory of its own is given as its copy place through a commitments
  screen opened at those same places; and the row named "Gym" is ticked
- **THEN** the tick is not refused, and the day view says the commitment is kept on that date
- **AND** that directory's one file named `DayByDay.daybyday` is a copy made at Monday 31 August 2026
  at 14:33, holding a history keeping "Gym" on Monday 31 August 2026
- **AND** the row ticked again writes a copy made at 14:34 holding a history keeping "Gym" on no day

#### Scenario: a one-off added, renamed and removed on a day screen each write a copy at the copy place

- **WHEN** a day screen is opened as of Monday 31 August 2026 at a roster place, a record place and a
  one-off place where nothing has been kept, keeping its copy place at a place of its own and asking
  a clock that answers a later minute each time it is asked, from that day at 14:32; a directory of
  its own is given as its copy place through a commitments screen opened at those same places; and a
  one-off named "Book dentist" is added, renamed to "Book the dentist", and then removed
- **THEN** none of the three is refused
- **AND** the copy at that directory after the add holds one one-off named "Book dentist", after the
  rename one named "Book the dentist", and after the removal no one-offs at all
- **AND** the last copy made after the removal is Monday 31 August 2026 at 14:35

#### Scenario: a number, a note and a total entered on a day screen each write a copy at the copy place

- **WHEN** commitments named "Weight" of the number kind, "Journal" of the note kind and "Protein" of
  the total kind with a target of 120, each on a schedule listing all seven weekdays and kept from
  1 January 2026, are taken on at a roster place; a day screen is opened at that roster place, a
  record place and a one-off place where nothing has been kept as of Monday 31 August 2026, keeping
  its copy place at a place of its own and asking a clock that answers a later minute each time it is
  asked, from that day at 14:32; a directory of its own is given as its copy place through a
  commitments screen opened at those same places; and "82.5" is entered on "Weight", "Ran far." on
  "Journal" and "30" on "Protein"
- **THEN** none of the three is refused
- **AND** the copy at that directory holds a history keeping 82.5 for "Weight", the note "Ran far."
  for "Journal" and an addition of 30 for "Protein", each on Monday 31 August 2026
- **AND** the last copy made is Monday 31 August 2026 at 14:35

#### Scenario: a commitment defined, stopped, taken up again and deleted through a commitments screen each write a copy at the copy place

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers a later minute each time it is asked, from that day at 14:32; a
  directory of its own is given to it as its copy place; and a commitment named "Gym" on a schedule
  listing all seven weekdays, kept from 1 January 2026, is defined through it, then stopped, then
  taken up again, then deleted
- **THEN** none of the four is refused
- **AND** the copy at that directory after each of the four holds a roster in exactly the state that
  change left at the roster place
- **AND** the last copy made after the deletion is Monday 31 August 2026 at 14:36, and holds no
  commitment at all

#### Scenario: a change reaching the record place and the roster place writes exactly one copy holding both

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Sunday 30 August 2026 is kept at a
  record place; a commitments screen is opened at that roster place, that record place and a one-off
  place where nothing has been kept as of Monday 31 August 2026, keeping its copy place at a place of
  its own and asking a clock that answers a later minute each time it is asked, from that day at
  14:32; a directory of its own is given to it as its copy place; and "Gym" is changed through it to
  the name "Gym 🏋️", under no category
- **THEN** the change is not refused
- **AND** the copy at that directory holds a roster of one entry named "Gym 🏋️" and a history keeping
  "Gym 🏋️" on Sunday 30 August 2026
- **AND** the last copy made is Monday 31 August 2026 at 14:33

#### Scenario: a restore confirmed writes a copy at the copy place holding what was restored

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place,
  a record place and a one-off place where nothing has been kept as of Monday 31 August 2026, keeping
  its copy place at a place of its own and asking a clock that answers a later minute each time it is
  asked, from that day at 14:32; a directory of its own is given to it as its copy place; and it is
  asked to restore from a file holding a copy of a roster of one entry named "Journaling" on that
  rhythm and the restore is confirmed
- **THEN** the restore is not refused
- **AND** the copy at that directory holds a roster of one entry named "Journaling"
- **AND** the last copy made is Monday 31 August 2026 at 14:33

#### Scenario: a call that keeps nothing writes no copy at the copy place

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place,
  a record place and a one-off place where nothing has been kept as of Monday 31 August 2026, keeping
  its copy place at a place of its own and asking a clock that answers a later minute each time it is
  asked, from that day at 14:32; a directory of its own is given to it as its copy place; and "Gym"
  is moved to the place it already holds
- **THEN** the last copy made is still Monday 31 August 2026 at 14:32
- **AND** a second commitment named "Gym" on that same rhythm and day defined through it and refused
  for its name leaves the last copy made at that same moment
- **AND** a stop asked for and cancelled, and a restore asked for and cancelled, each leave it there
  too
