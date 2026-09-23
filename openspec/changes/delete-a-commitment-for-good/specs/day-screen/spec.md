## ADDED Requirements

### Requirement: A day screen draws the commitments its roster had not stopped keeping on the day it is showing, and never one deleted

A day screen SHALL form every day view from the commitments the roster at its roster place had not
stopped keeping on the day shown, in the roster's groups and order. Every day view SHALL ask the
roster again for the day then shown: when the screen is opened, moved, sent back to today, shown
again or returned to, and when a tick is made. The roster asked SHALL be the one read when the app
was last shown or the screen last returned to, whichever happened later, with any change kept since;
asking MUST NOT open the place. A commitment the roster stopped SHALL have a row up to and including
the day it was kept until, and none after. A commitment the roster has deleted SHALL have a row on no day,
the days it was ticked on included. A group with nothing due
produces no group, as *A day view is a value and nothing else* states.

#### Scenario: a day screen draws the commitments its roster keeps, in the order they were taken on

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays and then one
  named "Supplements and habits" on that same schedule, both kept from 1 January 2026, are taken on
  at a roster place; and a day screen of no commitments at all is opened at that roster place as of
  Monday 31 August 2026, at a record place where nothing has been kept
- **THEN** its day view holds two rows, named "Journaling" and then "Supplements and habits"
- **AND** it says it is keeping a roster

#### Scenario: a day screen draws a commitment on the day it was kept until and not on the day after it

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and stopped as of Sunday 30 August 2026; a day screen
  of no commitments at all is opened at that roster place as of Monday 31 August 2026, at a record
  place where nothing has been kept; and it is moved to the day before
- **THEN** the day view it held when it was opened holds no rows, Monday 31 August 2026 being after
  the day the commitment was kept until
- **AND** after the move its day view holds one row, named "Journaling"

#### Scenario: moving a day screen does not read its roster again

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from that same
  day, is then taken on at that roster place by something else; and the day screen is moved to the
  day before and then to the day after
- **THEN** its day view holds one row, named "Journaling"
- **AND** it says it is keeping a roster, exactly as it did before the move

#### Scenario: a tick made on a day screen leaves what is kept at its roster place as it was

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Monday 31 August 2026 at a roster place and a record
  place where nothing has been kept, and its one row is ticked
- **THEN** its day view says the commitment is kept on that date
- **AND** the content at its roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a day screen draws its rows in the order its roster was moved into

- **WHEN** a commitment named "Journaling", then one named "Supplements and habits", then one named
  "Gym", all on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a
  roster place; "Gym" is moved there to the offset 0; and a day screen of no commitments at all is
  opened at that roster place as of Monday 31 August 2026, at a record place where nothing has been
  kept
- **THEN** its day view holds three rows, named "Gym", "Journaling" and then "Supplements and habits"
- **AND** it says it is keeping a roster

#### Scenario: a day screen draws its rows in the groups its roster puts them in

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Magnesium", then one
  named "Journaling", all on a schedule listing all seven weekdays and kept from 1 January 2026, are
  taken on at a roster place; "Creatine" and "Magnesium" are put under the category "Supplements"
  there and "Gym" under "Sport"; and a day screen of no commitments at all is opened at that roster
  place as of Monday 31 August 2026, at a record place where nothing has been kept
- **THEN** its day view holds three groups: "Supplements" holding rows named "Creatine" and then
  "Magnesium", then "Sport" holding a row named "Gym", then a group with no category holding a row
  named "Journaling"
- **AND** it says it is keeping a roster

#### Scenario: a day screen draws a group again after a category is changed at its roster place

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a day screen of no
  commitments at all is opened at that roster place as of Monday 31 August 2026, at a record place
  where nothing has been kept; "Creatine" is put under the category "Supplements" at that roster
  place by something else; and the app is shown again as of that same day
- **THEN** the day view it held when it was opened holds one group, with no category, holding rows
  named "Creatine" and then "Gym"
- **AND** afterwards its day view holds two groups, "Supplements" holding a row named "Creatine" and
  then a group with no category holding a row named "Gym"

#### Scenario: a day screen draws a deleted commitment on no day, the days it was ticked on included

- **WHEN** a commitment named "Journaling" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Journaling" is ticked on
  Sunday 30 August 2026 at a record place; a commitments screen opened at those places as of Monday
  31 August 2026 deletes "Journaling"; and a day screen of no commitments at all is opened at those
  places as of Monday 31 August 2026 and moved to the day before
- **THEN** its day view holds one row, named "Gym", saying the commitment is not kept
- **AND** moved back to Monday 31 August 2026 its day view holds one row, named "Gym"

### Requirement: A day screen says the day its day picker opens on and the earliest day it reaches, from what its roster still holds

A day screen SHALL say the reach of its day picker as one answer of two days: the day it opens on
and the earliest day it reaches. The day it opens on SHALL be the day being shown, whatever put it
there. The earliest day it reaches SHALL be the earlier of the earliest day anything on its roster
is kept from and the day being shown, and SHALL never be later than the day it opens on. Where the
roster answers no such day, the today last handed SHALL stand in its place. That day SHALL be the
`commitment` capability's answer for the roster the screen last read, counting every commitment it
holds, stopped ones included and deleted ones not; a day screen MUST NOT recompute it, nor narrow it to the
commitments due on some day, to those still kept, or to those its day view holds rows for.

#### Scenario: a day screen's day picker opens on the day it is showing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is not moved
- **THEN** its day picker opens on Monday 31 August 2026
- **AND** moved to the day before, its day picker opens on Sunday 30 August 2026
- **AND** moved from there to the day after twice, its day picker opens on Tuesday 1 September 2026

#### Scenario: a day screen's day picker reaches back to the earliest day anything on its roster is kept from

- **WHEN** a commitment named "Gym" kept from 1 March 2026, one named "Run" kept from 1 January
  2026 and one named "Journaling" kept from 1 February 2026, all on a schedule listing all seven
  weekdays, are taken on at a roster place; and a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept
- **THEN** its day picker reaches back to 1 January 2026
- **AND** its day picker opens on Monday 31 August 2026

#### Scenario: a day screen's day picker reaches back past a commitment its roster has stopped keeping

- **WHEN** a commitment named "Gym" kept from 1 January 2026 and one named "Run" kept from 1 March
  2026, both on a schedule listing all seven weekdays, are taken on at a roster place; "Gym" is
  stopped there as of 31 January 2026; and a day screen of no commitments at all is opened at that
  roster place as of Monday 31 August 2026, at a record place where nothing has been kept
- **THEN** its day picker reaches back to 1 January 2026
- **AND** its day view holds one row, named "Run"

#### Scenario: a day screen's day picker no longer reaches back to a commitment its roster has deleted

- **WHEN** a commitment named "Gym" kept from 1 January 2026 and one named "Run" kept from 1 March
  2026, both on a schedule listing all seven weekdays, are taken on at a roster place; "Gym" is
  deleted there; and a day screen of no commitments at all is opened at that roster place as of
  Monday 31 August 2026, at a record place where nothing has been kept
- **THEN** its day picker reaches back to 1 March 2026
- **AND** its day view holds one row, named "Run"

#### Scenario: a day screen's day picker reaches back to the day it is showing where that is the earlier of the two

- **WHEN** a day screen is opened as of Thursday 1 January 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 June 2026
- **THEN** its day picker opens on Thursday 1 January 2026 and reaches back to Thursday 1 January
  2026
- **AND** moved to the day before, its day picker opens on Wednesday 31 December 2025 and reaches
  back to Wednesday 31 December 2025

#### Scenario: a day screen that cannot read its roster reaches back to the today it was handed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a run of
  bytes that is not what a roster is written as, at a record place where nothing has been kept, of
  a commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1 January 2026
- **THEN** it says it is not keeping a roster
- **AND** its day picker opens on Monday 31 August 2026 and reaches back to Monday 31 August 2026
- **AND** moved to the day before, its day picker reaches back to Sunday 30 August 2026

#### Scenario: a day screen that takes on the commitments it was handed reaches back to the earliest of those

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding nothing at
  all, at a record place where nothing has been kept, of a commitment named "Gym" kept from
  1 March 2026 and one named "Journaling" kept from 1 February 2026, both on a schedule listing all
  seven weekdays
- **THEN** its day picker reaches back to 1 February 2026, those two having been taken on
- **AND** a second day screen opened as of that same day, at a roster place of its own also holding
  nothing at all and handed no commitments at all, reaches back to Monday 31 August 2026

#### Scenario: a day screen's day picker reaches back to the first supported date and opens on the last

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583
- **THEN** its day picker reaches back to 1 January 1583
- **AND** a second day screen opened the same way as of Friday 31 December 9999 opens on Friday
  31 December 9999 and reaches back to 1 January 1583

#### Scenario: a day screen's day picker reaches back to the day a commitment is kept from though nothing is due on that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place and a record place
  where nothing has been kept, of a commitment named "Finances" on a schedule on the 25th of the
  month, kept from 1 January 2026, and one named "Journaling" on a schedule listing all seven
  weekdays, kept from 1 March 2026
- **THEN** its day picker reaches back to 1 January 2026, and neither to 25 January 2026 nor to
  1 March 2026
- **AND** its day view holds one row, named "Journaling"

## MODIFIED Requirements

### Requirement: A day screen takes on the commitments it was handed when its roster holds nothing at all

A day screen SHALL be handed some commitments and SHALL take them on, in the order handed, exactly
when the roster it has just read holds nothing at all. It SHALL keep them at its roster place before
drawing from them. A roster holding anything at all SHALL be left exactly as it is, and the
commitments handed in SHALL NOT be taken on again: a roster every one of whose commitments has been
stopped still holds them, and a roster emptied — by deleting its last commitment, by erasing every
commitment a stored roster held removed, or by restoring a copy of an emptied roster — is not a
roster holding nothing at all; neither SHALL be written over. Only a roster place where nothing has
been kept, or one holding a roster given nothing, SHALL be given the commitments handed in.

A day screen that could not read its roster SHALL take nothing on and SHALL leave that place exactly
as it was. One that could read its roster but could not keep what it was handed SHALL hold a roster
holding nothing and no rows, and SHALL say it is not keeping a roster.

#### Scenario: a day screen opened where no roster has been kept takes on the commitments it was handed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place and a record place
  where nothing has been kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday
  and Saturday and a commitment named "Journaling" on a schedule listing all seven weekdays, in that
  order and both kept from 1 January 2026
- **THEN** its day view holds two rows, named "Gym" and then "Journaling"
- **AND** a roster store opened afterwards at that roster place reads back those two commitments, in
  that order

#### Scenario: a day screen opened a second time does not take the commitments on again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place and a record place
  where nothing has been kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday
  and Saturday and a commitment named "Journaling" on a schedule listing all seven weekdays, in that
  order and both kept from 1 January 2026; "Gym" is then stopped at that roster place as of Sunday
  30 August 2026 by something else; and a second day screen of those same two commitments is opened
  at those same two places as of Monday 31 August 2026
- **THEN** the second day screen's day view holds one row, named "Journaling"
- **AND** a roster store opened afterwards at that roster place reads back one commitment and holds
  no second copy of either

#### Scenario: a day screen opened on a roster whose commitments have all been stopped takes nothing on

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and stopped as of Sunday 30 August 2026; and a day
  screen of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  that same day, is opened at that roster place as of Monday 31 August 2026, at a record place where
  nothing has been kept
- **THEN** its day view holds no rows
- **AND** a roster store opened afterwards at that roster place holds a roster that is the same
  roster as one given "Journaling" once and asked to stop keeping it as of Sunday 30 August 2026

#### Scenario: a day screen that cannot read its roster takes nothing on and leaves what is at the place as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a run of
  bytes that is not what a roster is written as, at a record place where nothing has been kept, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026
- **THEN** the content at that roster place is byte-for-byte what it was before the screen was opened
- **AND** its day view holds no rows

#### Scenario: a day screen that could not keep the commitments it was handed says it is not keeping a roster

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place where nothing can be
  written — a path beneath an existing ordinary file — at a record place where nothing has been kept,
  of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1 January
  2026
- **THEN** it says it is not keeping a roster
- **AND** its day view holds no rows
- **AND** it says it is keeping a record

#### Scenario: a day screen shown again on a roster that holds nothing takes the commitments on again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place and a record place
  where nothing has been kept, of a commitment named "Journaling" on a schedule listing all seven
  weekdays, kept from 1 January 2026; what is at its roster place is then replaced by a roster store
  that has been given no commitment; and the app is shown again as of Monday 31 August 2026
- **THEN** its day view holds one row, named "Journaling"
- **AND** a roster store opened afterwards at that roster place reads back that one commitment

#### Scenario: a day screen opened on a roster whose commitments have all been removed takes nothing on

- **WHEN** a roster written in the form used before a commitment could be deleted is at a roster
  place, whose one commitment, named "Journaling" on a schedule listing all seven weekdays and kept
  from 1 January 2026, is held removed and kept until Sunday 30 August 2026; and a day screen of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from that same
  day, is opened at that roster place as of Monday 31 August 2026, at a record place where nothing
  has been kept
- **THEN** its day view holds no rows
- **AND** the content at that roster place is byte-for-byte what it was before the screen was opened
- **AND** "Gym" is not at that roster place

#### Scenario: a day screen opened on a roster whose last commitment was deleted takes nothing on

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and deleted there; and a day screen of a commitment
  named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from that same day, is
  opened at that roster place as of Monday 31 August 2026, at a record place where nothing has been
  kept, and then shown again as of Tuesday 1 September 2026
- **THEN** its day view holds no rows
- **AND** a roster store opened afterwards at that roster place reads back nothing it keeps and
  nothing it has stopped, and "Gym" is not at that roster place

## REMOVED Requirements

### Requirement: A day screen draws the commitments its roster had not stopped keeping on the day it is showing

**Reason:** the removed state is retired and a commitment is deleted instead (#304), so scenario
titles naming removal go or change, which a kept heading cannot carry. Replaced in full by *A day
screen draws the commitments its roster had not stopped keeping on the day it is showing, and never
one deleted*.

**Migration:** every other scenario is carried under the new heading with its title unchanged, and
its test with it. Going, with their tests: *a day screen draws a removed commitment on the day it
was kept until and not on the day after it*; *a day screen draws a removed commitment under a
category exactly as it draws a stopped one*. Arriving: *a day screen draws a deleted commitment on
no day, the days it was ticked on included*.

### Requirement: A day screen says the day its day picker opens on and the earliest day it reaches

**Reason:** the removed state is retired and a commitment is deleted instead (#304), so scenario
titles naming removal go or change, which a kept heading cannot carry. Replaced in full by *A day
screen says the day its day picker opens on and the earliest day it reaches, from what its roster
still holds*.

**Migration:** every other scenario is carried under the new heading with its title unchanged, and
its test with it. Going, with their tests: *a day screen's day picker reaches back past a commitment
its roster has removed*. Arriving: *a day screen's day picker no longer reaches back to a commitment
its roster has deleted*.
