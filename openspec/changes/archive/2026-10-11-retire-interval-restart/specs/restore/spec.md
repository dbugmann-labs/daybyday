## MODIFIED Requirements

### Requirement: A copy is written at the copy place after every change a person keeps, a deletion included

Where a copy place is set, the app SHALL write a copy there after every change a person keeps at the
record place, the roster place or the one-off place, as of the moment its clock answers once that
change is kept: a tick made or taken back on a commitment or on a one-off; a number, a note or a
total entered or taken back; the last addition taken back; a one-off added, renamed or removed; a
commitment defined, changed, stopped, deleted, taken up again, moved, or moved as a
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
