## MODIFIED Requirements

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

### Requirement: A copy is written at the copy place after every change a person keeps

Where a copy place is set, the app SHALL write a copy there after every change a person keeps at the
record place, the roster place or the one-off place, as of the moment its clock answers once that
change is kept: a tick made or taken back on a commitment or on a one-off; a number, a note or a
total entered or taken back; the last addition taken back; a one-off added, renamed or removed; a
commitment defined, changed, restarted, stopped, removed, taken up again, moved, or moved as a
group; and a restore confirmed. One change SHALL write exactly one copy however many places it
reached, and that copy SHALL hold the three places as they stand once the change is kept. A call
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

#### Scenario: a commitment defined, stopped, taken up again and removed through a commitments screen each write a copy at the copy place

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, keeping its copy place at a place of its own
  and asking a clock that answers a later minute each time it is asked, from that day at 14:32; a
  directory of its own is given to it as its copy place; and a commitment named "Gym" on a schedule
  listing all seven weekdays, kept from 1 January 2026, is defined through it, then stopped, then
  taken up again, then removed
- **THEN** none of the four is refused
- **AND** the copy at that directory after each of the four holds a roster in exactly the state that
  change left at the roster place
- **AND** the last copy made after the removal is Monday 31 August 2026 at 14:36

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
