## ADDED Requirements

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
commitment awaiting confirmation, the commitment awaiting removal, the name typed back and the
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
  record place where nothing has been kept as of Monday 31 August 2026; it is asked to remove "Gym"
  and "Gym" is typed back; and a take-out is asked for
- **THEN** what it keeps is one entry, named "Gym", and what it has stopped is one entry, named
  "Journaling"
- **AND** "Gym" is still awaiting removal, with "Gym" still typed back
- **AND** nothing is awaiting confirmation

#### Scenario: a take-out made leaves a refused change standing and says nothing of its own

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a one-off place beside it is made a run of bytes
  that is not a one-off holder; a commitments screen is opened at those places and at a record place
  where nothing has been kept as of Monday 31 August 2026; a commitment alike in every way to "Gym"
  is defined through it and refused as already kept; and a take-out is asked for
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
  a one-off holder as of Monday 31 August 2026; a commitment alike in every way to "Gym" is defined
  through it and refused as already kept; and a take-out is asked for, written into a directory that
  cannot be written to
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

## MODIFIED Requirements

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
  commitment alike in every way to one named "Gym" on a schedule listing all seven weekdays, kept
  from 1 January 2026, is defined through it twice, the second refused as already kept; and a
  directory that cannot be written to is given to it as its copy place
- **THEN** the copy that could not be made there is not held as a refused change: the screen holds
  the refused definition against defining a commitment exactly as it did
- **AND** the stop is the folder that cannot be written
- **AND** a commitment named "Journaling" on that rhythm then defined through it is not refused and
  leaves the screen holding no refused change — neither the definition refused before, which keeping
  "Journaling" ended, nor the copy that again could not be made — with the stop still the folder that
  cannot be written

