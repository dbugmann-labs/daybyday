## ADDED Requirements

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

## MODIFIED Requirements

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

## REMOVED Requirements

### Requirement: A copy is written at the copy place after every change a person keeps

**Reason:** the removed state is retired and a commitment is deleted instead (#304), so scenario
titles naming removal go or change, which a kept heading cannot carry. Replaced in full by *A copy
is written at the copy place after every change a person keeps, a deletion included*.

**Migration:** every other scenario is carried under the new heading with its title unchanged, and
its test with it. Going, with their tests: *a commitment defined, stopped, taken up again and
removed through a commitments screen each write a copy at the copy place*. Arriving: *a commitment
defined, stopped, taken up again and deleted through a commitments screen each write a copy at the
copy place*.
