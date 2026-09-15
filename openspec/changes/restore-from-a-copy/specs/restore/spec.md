## ADDED Requirements

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
them. A removed commitment SHALL be counted as neither. Where a place cannot be read, it SHALL say so
in place of any count that store gives. Cancelling SHALL leave the screen and the three places as
they were. A restore awaiting confirmation SHALL stand until it is confirmed, cancelled or replaced
by another ask.

#### Scenario: a commitments screen asked to restore says the copy's moment and what the copy and the phone keep, have stopped and hold as one-offs

- **WHEN** commitments named "Gym" and "Journaling", each on a schedule listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; a one-off named "Book dentist" on
  25 September 2026 is kept at a one-off place; a commitments screen is opened at those places and a
  record place where nothing has been kept as of Monday 31 August 2026; a copy is made through it as
  of that day at 14:32; "Journaling" is then stopped through it, a commitment named "Reading" alike
  in every other way is taken on through it, and "Gym" is removed through it; a one-off named "Post
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
  is made through it as of that day at 14:32; it is asked to remove "Gym" and "Gym" is typed back;
  and it is asked to restore from that copy and the restore is cancelled
- **THEN** no restore is awaiting confirmation, and it holds no copy restored
- **AND** "Gym" is still awaiting removal, with "Gym" still typed back
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
shown, SHALL hold no restore, commitment or removal awaiting confirmation and no name typed back, and
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
  of that day at 14:32; "Journaling" is then taken up again through it; it is asked to remove "Gym"
  and "Gym" is typed back; and it is asked to restore from that copy and the restore is confirmed
- **THEN** what it keeps is one entry, named "Gym", and what it has stopped is one entry, named
  "Journaling"
- **AND** nothing is awaiting removal, no name is typed back, and no restore is awaiting confirmation
- **AND** a screen asked to stop keeping "Gym" rather than to remove it, before the restore was asked
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
