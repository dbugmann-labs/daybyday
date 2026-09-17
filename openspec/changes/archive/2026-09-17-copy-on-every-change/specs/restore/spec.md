## ADDED Requirements

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
  its copy place at a place of its own and asking a clock that answers that day at 14:32; a
  commitment alike in every way to "Gym" is defined through it and refused as already kept; and a
  directory holding a file named `DayByDay.daybyday` that is a run of bytes that is not a copy is
  then given to it as its copy place
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
- **AND** a commitment alike in every way to "Gym" defined through it and refused as already kept
  leaves the last copy made at that same moment
- **AND** a stop asked for and cancelled, and a restore asked for and cancelled, each leave it there
  too

### Requirement: A copy that cannot be made at the copy place refuses no change

A change a person keeps SHALL be kept whether or not the copy that follows it can be made, and the
caller SHALL be answered exactly as it is where the copy is made. Where the copy cannot be made, the
app SHALL hold why and the moment it first could not, SHALL leave the last copy made exactly as it
was, and MUST NOT hold it as a change it refused. Why SHALL be told apart as the folder that cannot
be reached, the folder that cannot be written, and a store that could not be read, naming which
store. A later change that also fails SHALL leave that moment where it is. The next change kept
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
