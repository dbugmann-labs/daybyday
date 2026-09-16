## MODIFIED Requirements

### Requirement: What a day screen tells on a row lasts only until the app is shown again, a change is kept, or the day it is showing changes

A day screen SHALL go on telling it, on the same row, until one of exactly three things happens, and
SHALL then tell nothing on any row. Nothing else SHALL end it, time passing included. The app being
shown again SHALL end it, whether or not the record can then be read. A change reaching the record's
place or the one-off place SHALL end it, on whichever row it was made, whatever the change; a copy
restored through a commitments screen is such a change, and SHALL end it once the day screen is
returned to from that commitments screen. The day
being shown changing SHALL end it — the day changing and never the gesture made — so a move with
nowhere to go, and today sent back to today, SHALL leave it standing.

A change that reaches neither place SHALL NOT end it: a refused value moves what is told rather
than ending it. A commit in a total entry that says nothing is neither an end nor a refusal, so what
was told SHALL stand exactly as it was; closing a number or note entry without committing it SHALL
end nothing either.

#### Scenario: what a day screen tells on a row ends when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked; and the
  app is then shown again as of that same day
- **THEN** the day screen tells nothing on any row
- **AND** its one row still says the commitment is not kept on that date

#### Scenario: what a day screen tells on a row ends when the app is shown again where the record then cannot be read

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked; that
  place is then made to hold a run of bytes that is not what a record is written as; and the app
  is shown again as of that same day
- **THEN** the day screen says it is not keeping a record
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when a change is kept on another row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from
  but not written to and where nothing has been kept, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday and a commitment named "Journaling" on a schedule listing
  all seven weekdays, in that order and both kept from 1 January 2026; its first row is ticked and
  refused; the place is then made writable; and its second row is ticked
- **THEN** the day screen's day view says "Journaling" is kept on that date and "Gym" is not
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when a take-back is kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both
  kept from 1 January 2026; its second row is ticked and kept; the place is then made unwritable;
  its first row is ticked and refused; the place is made writable again; and the row for
  "Journaling" is ticked once more
- **THEN** the day screen's day view says "Journaling" is not kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when the day screen is moved to the day before

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; its one row is ticked; and it is
  then moved to the day before
- **THEN** the day screen tells nothing on any row
- **AND** its day picker opens on Sunday 30 August 2026

#### Scenario: what a day screen tells on a row ends when the day screen is moved to the day after

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; its one row is ticked; and it is
  then moved to the day after
- **THEN** the day screen tells nothing on any row
- **AND** its day picker opens on Tuesday 1 September 2026

#### Scenario: what a day screen tells on a row ends when the day screen is sent back to today from another day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; it is moved to the day before;
  its one row is ticked; and it is then sent back to today
- **THEN** the day screen tells nothing on any row
- **AND** its day picker opens on Monday 31 August 2026, and it offers no way back to today

#### Scenario: what a day screen tells on a row stands when a move has nowhere to go

- **WHEN** a day screen is opened as of Saturday 1 January 1583 and another as of Friday 31
  December 9999, each at its own place where nothing can be written — a path beneath an existing
  ordinary file — of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 1583; each screen's one row is ticked; and the first is then moved to the
  day before and the second to the day after
- **THEN** each day screen still tells, on the row that was ticked on it, that the change could
  not be kept
- **AND** the first's day picker still opens on Saturday 1 January 1583 and the second's on Friday
  31 December 9999

#### Scenario: what a day screen tells on a row stands when a day screen showing today is sent back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; its one row is ticked; and it is
  then sent back to today without having been moved
- **THEN** the day screen still tells, on that row, that the change could not be kept
- **AND** its day picker still opens on Monday 31 August 2026, and it offers no way back to today

#### Scenario: what a day screen tells on a row ends when a number is entered and kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from
  but not written to and where nothing has been kept, of a commitment named "Weight" of the number
  kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; "70.5" is committed on its one row and refused; the place is then made writable;
  and "70.5" is committed again on the row the screen then holds
- **THEN** the day screen's day view says the commitment is kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when a number is taken back and kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 on a schedule
  listing Monday, Wednesday and Saturday and a commitment named "Journaling" of the tick kind on a
  schedule listing all seven weekdays, in that order and both kept from 1 January 2026; "70.5" is
  committed on the first row and kept; the place is then made unwritable; the second row is ticked
  and refused; the place is made writable again; and nothing at all is committed on the row for
  "Weight"
- **THEN** the day screen's day view says "Weight" is not kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells about a refused value ends when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "300" is committed on its one
  row; and the app is then shown again as of that same day
- **THEN** the day screen tells nothing on any row
- **AND** its one row still says the commitment is not kept on that date

#### Scenario: what a day screen tells about a refused value ends when the day screen is moved to the day before

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026; "1.2.3" is committed on its one row; and
  it is then moved to the day before
- **THEN** the day screen tells nothing on any row
- **AND** its day picker opens on Sunday 30 August 2026

#### Scenario: what a day screen tells on a row ends when a note is written and kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from but
  not written to and where nothing has been kept, of a commitment named "Journal" of the note kind,
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; "Ran 8k." is
  committed on its one row and refused; the place is then made writable; and "Ran 8k." is committed
  again on the row the screen then holds
- **THEN** the day screen's day view says the commitment is kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when a note is taken back and kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind on a schedule listing Monday, Wednesday and
  Saturday and a commitment named "Gym" of the tick kind on a schedule listing all seven weekdays,
  in that order and both kept from 1 January 2026; "Ran 8k." is committed on the first row and kept;
  the place is then made unwritable; the second row is ticked and refused; the place is made
  writable again; and nothing at all is committed on the row for "Journal"
- **THEN** the day screen's day view says "Journal" is not kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when an addition is made and kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from but
  not written to and where nothing has been kept, of a commitment named "Protein" of the total kind
  with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026; "30" is committed on its one row and refused; the place is then made writable; and "30" is
  committed again on the row the screen then holds
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when a last addition is taken back and kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120 on a schedule listing
  Monday, Wednesday and Saturday and a commitment named "Gym" of the tick kind on a schedule listing
  all seven weekdays, in that order and both kept from 1 January 2026; "30" is committed on the first
  row and kept; the place is then made unwritable; the second row is ticked and refused; the place is
  made writable again; and the last addition is taken back on the row for "Protein"
- **THEN** the entry that row then offers says "0 of 120"
- **AND** it tells nothing on any row

#### Scenario: a commit saying nothing in a total entry leaves what a day screen is telling standing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Protein" of the total
  kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; "30" is committed on its one row and refused; and nothing at all is then committed
  on the row it holds
- **THEN** the day screen still tells, on that row, that the change could not be kept
- **AND** the entry that row offers still says "0 of 120"

#### Scenario: what a day screen tells on a row ends when a one-off tick is kept

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place; a day screen
  of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1 January
  2026, is opened at that one-off place as of Monday 28 September 2026, at a record place where
  nothing can be written — a path beneath an existing ordinary file — and a roster place where
  nothing has been kept; its one commitment row is ticked and refused; and its one one-off row is
  then ticked
- **THEN** its One-offs group holds one row, named "Call mum", saying it is done
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a one-off row ends when a commitment tick is kept

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place that is then
  made so that it can be read from but not written to; a day screen of a commitment named
  "Journaling" on a schedule listing all seven weekdays, kept from 1 January 2026, is opened at that
  one-off place as of Monday 28 September 2026, at a record place and a roster place where nothing
  has been kept; its one one-off row is ticked and refused; and its one commitment row is then ticked
- **THEN** its day view says "Journaling" is kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a one-off row stands when returned to and ends when the app is shown again

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place that is then
  made so that it can be read from but not written to; a day screen of no commitments at all is
  opened at that one-off place as of Monday 28 September 2026, at a record place and a roster place
  where nothing has been kept; its one one-off row is ticked and refused; and it is returned to
- **THEN** it still tells, on that one-off row, that the change could not be kept
- **AND** after the app is then shown again as of that same day, it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when a one-off rename is kept, a blank one included

- **WHEN** one-offs named "Call mum" and then "Pay fine", both on 25 September 2026, are added at a
  one-off place; a day screen of a commitment named "Journaling" on a schedule listing all seven
  weekdays, kept from 1 January 2026, is opened at that one-off place as of Monday 28 September 2026,
  at a record place where nothing can be written — a path beneath an existing ordinary file — and a
  roster place where nothing has been kept; its one commitment row is ticked and refused; and
  "Ring mum" is committed in the name field of the row named "Call mum"
- **THEN** its One-offs group holds rows named "Ring mum" and then "Pay fine"
- **AND** it tells nothing on any row
- **AND** after its commitment row is ticked and refused again and a text of blank space alone is
  committed in the name field of the row named "Pay fine", its One-offs group holds one row, named
  "Ring mum", and it tells nothing on any row

### Requirement: A day screen reads its roster again whenever it is returned to

A day screen returned to SHALL read its roster place again and SHALL form its day view from the
roster it then reads. Being returned to SHALL NOT take a new today nor move the day being shown. It
SHALL read its record place again where it is keeping a record and SHALL NOT where it is not: a
screen not keeping one does not start by being returned to, and that state, with anything else that
lasts until the app is shown again, SHALL stand across being returned to. What a day screen tells on
a row ends on exactly three things, of which being returned to is not one; it SHALL go on telling
it. Where the roster it then reads holds nothing at all, it SHALL take on the commitments it was
handed; where that place cannot be read, it SHALL say so and draw no rows. A day screen returned to
from a commitments screen that has restored a copy SHALL instead be returned to as `restore` says.

#### Scenario: a commitment taken on at a day screen's roster place is drawn when the screen is returned to

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; a
  commitment named "Gym" on that same schedule, kept from that same day, is then taken on at that
  roster place by something else; and the day screen is returned to
- **THEN** its day view holds two rows, named "Journaling" and then "Gym"
- **AND** the day view it held before it was returned to held one row, named "Journaling"

#### Scenario: a commitment stopped at a day screen's roster place is not drawn when the screen is returned to

- **WHEN** a commitment named "Journaling" and one named "Gym", both on a schedule listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; a day screen of no
  commitments at all is opened at that roster place as of Monday 31 August 2026, at a record place
  where nothing has been kept; "Gym" is then stopped at that roster place by something else, as of
  Sunday 30 August 2026; and the day screen is returned to
- **THEN** its day view holds one row, named "Journaling"

#### Scenario: a day screen returned to goes on showing the day it was showing

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; it
  is moved to the day before; and it is returned to
- **THEN** its day picker opens on Sunday 30 August 2026
- **AND** its day view holds one row, named "Journaling"

#### Scenario: a day screen returned to keeps the today it was handed

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; and
  it is returned to
- **THEN** its day picker opens on Monday 31 August 2026, and it offers no way back to today

#### Scenario: a day screen returned to does not read its record again

- **WHEN** a run of bytes that is not a record store is written at a record place; a day screen of
  a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is opened as of Monday 31 August 2026 at that record place and at a roster place
  where nothing has been kept; what is at the record place is removed, so that nothing has been kept
  there and the place reads clean; and the day screen is returned to
- **THEN** it still says it is keeping no record
- **AND** its day view holds one row, named "Journaling"

#### Scenario: a day screen that could not read its roster starts keeping one when it is returned to and the roster can be read

- **WHEN** a run of bytes that is not a roster store is written at a roster place; a day screen of
  no commitments at all is opened at that place as of Monday 31 August 2026, at a record place where
  nothing has been kept; what is at the roster place is replaced with a roster store holding a
  commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1 January 2026;
  and the day screen is returned to
- **THEN** it says it is keeping a roster
- **AND** its day view holds one row, named "Journaling"

#### Scenario: a day screen returned to on a roster that holds nothing takes the commitments it was handed on again

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Monday 31 August 2026 at a roster place where nothing
  has been kept and a record place where nothing has been kept; everything kept at the roster place
  is removed; and the day screen is returned to
- **THEN** a roster store opened afterwards at that place holds one commitment, named "Journaling"
- **AND** its day view holds one row, named "Journaling"

#### Scenario: a day screen returned to goes on telling what it was telling on a row

- **WHEN** a day screen of no commitments at all is opened as of Monday 31 August 2026 at a roster
  place holding a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and at a record place where nothing can be written — a path beneath an existing
  ordinary file; its one row is ticked and refused; and the day screen is returned to
- **THEN** it still tells, on that row, that the change could not be kept
- **AND** its day view holds one row, named "Journaling"

#### Scenario: a commitment renamed at a day screen's places is drawn under its new name and still kept when the screen is returned to

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 31 August 2026 is kept at a
  record place; a day screen of no commitments at all is opened at that roster place and that record
  place as of Monday 31 August 2026; that commitment is then changed at both places by something else
  to the name "Gym 🏋️"; and the day screen is returned to
- **THEN** its day view holds one row, named "Gym 🏋️"
- **AND** that row says its commitment was kept

#### Scenario: a day screen returned to where its roster cannot be read says so and draws no rows

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept;
  that roster place is then made to hold a run of bytes that is not what a roster is written as;
  and the day screen is returned to
- **THEN** it says it is not keeping a roster
- **AND** its day view holds no rows
- **AND** before it was returned to, its day view held one row, named "Journaling"

### Requirement: A day screen draws the one-offs at its one-off place as of the today it was handed

A day screen SHALL form its day view, and the day views either side of it, from the one-offs held at
its one-off place as of the today it was last handed, and never as of the day it is showing. It
SHALL open that place when it is opened and when the app is shown again, and at no other moment:
being moved, being sent back to today, a day being picked, being returned to and saying the day
either side SHALL NOT open it, save being returned to from a commitments screen that has restored a
copy, which SHALL. Opening it SHALL write nothing there and take nothing on. A day
screen that could read its one-offs SHALL say it is keeping them. The one-offs it holds MUST NOT
move the reach of its day picker.

#### Scenario: a day screen draws the one-offs kept at its one-off place on the today it was handed

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place, and a day
  screen of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is opened at that one-off place as of Monday 28 September 2026, at a record place
  and a roster place where nothing has been kept
- **THEN** its day view holds one row named "Journaling" and a One-offs group holding one row named
  "Call mum", saying "3 days late"
- **AND** it says it is keeping one-offs

#### Scenario: a day screen moved off today draws no undone late one-off and draws one owed ahead on its date

- **WHEN** one-offs named "Call mum" on 25 September 2026 and "Pay fine" on 30 September 2026 are
  added at a one-off place, and a day screen of a commitment named "Journaling" on a schedule
  listing all seven weekdays, kept from 1 January 2026, is opened at that one-off place as of Monday
  28 September 2026, at a record place and a roster place where nothing has been kept; and it is
  moved to the day before
- **THEN** its One-offs group holds no rows
- **AND** the day view it says of the day after holds a One-offs group holding one row, named
  "Call mum"
- **AND** after Wednesday 30 September 2026 is picked, its One-offs group holds one row, named
  "Pay fine", saying nothing in the rhythm's place and offering no tick as of 28 September 2026

#### Scenario: a day screen opened where no one-offs have been kept writes nothing at its one-off place

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Monday 28 September 2026, at a one-off place, a record
  place and a roster place where nothing has been kept
- **THEN** its day view holds a One-offs group holding no rows
- **AND** it says it is keeping one-offs
- **AND** nothing has been kept at its one-off place

#### Scenario: a day screen reads its one-off place again when shown and not when returned to

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Monday 28 September 2026, at a one-off place, a record
  place and a roster place where nothing has been kept; a one-off named "Call mum" on 25 September
  2026 is then added at that one-off place by something else; and the day screen is returned to
- **THEN** its One-offs group holds no rows
- **AND** after the app is shown again as of that same day, its One-offs group holds one row, named
  "Call mum"

#### Scenario: a day screen shown again on a later day draws a one-off that has followed today

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place; a day screen
  of no commitments at all is opened at that one-off place as of Friday 25 September 2026, at a
  record place and a roster place where nothing has been kept; and the app is shown again as of
  Monday 28 September 2026
- **THEN** its One-offs group holds one row, named "Call mum", saying "3 days late"
- **AND** before it was shown again, that group's one row said nothing in the rhythm's place

#### Scenario: a day screen's one-offs do not move the reach of its day picker

- **WHEN** a one-off named "Renew passport" on 1 January 2020 is added at a one-off place, and a day
  screen of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is opened at that one-off place as of Monday 28 September 2026, at a record place
  and a roster place where nothing has been kept
- **THEN** its day picker reaches back to 1 January 2026
- **AND** its One-offs group holds one row, named "Renew passport"

### Requirement: What a day screen tells under a one-off name field lasts until its text is edited, the day it is showing changes, or the app is shown again

What a day screen tells under its one-off entry or under a one-off row's name field SHALL stand
until the text in that field is edited, a commit from that field is kept, the day being shown
changes, or the app is shown again, and SHALL then be told no longer. The day changing, and never
the gesture made, SHALL end it, so a screen on its today sent back to today SHALL leave it standing.
Nothing else SHALL end it: a change kept on a row or from another field, a refusal told on a row,
and being returned to SHALL NOT, save being returned to from a commitments screen that has restored
a copy, which SHALL. A day screen SHALL tell under at most one one-off name field at a
time, and a refusal in another field SHALL replace what it was telling. What is told under a row's
name field SHALL also end when the day view no longer holds that row.

#### Scenario: what is told under the one-off entry stands when a change is kept on a row or from another field and when returned to

- **WHEN** one-offs named "Pay fine" on 25 September 2026 and "Call mum" on 28 September 2026 are
  added at a one-off place; a day screen of a commitment named "Journaling" on a schedule listing all
  seven weekdays, kept from 1 January 2026, is opened at that one-off place as of Monday
  28 September 2026, at a record place and a roster place where nothing has been kept; "Call mum" is
  committed in its one-off entry and refused; its commitment row is ticked; "Pay the fine" is
  committed in the name field of the row named "Pay fine"; and it is returned to
- **THEN** it still tells, under its one-off entry, "Already on this day"
- **AND** its day view says "Journaling" is kept on that date
- **AND** its One-offs group holds rows named "Pay the fine" and then "Call mum"

#### Scenario: what is told under a one-off name field ends when its text is edited or a commit from it is kept

- **WHEN** a one-off named "Call mum" on 28 September 2026 is added at a one-off place; a day screen
  of no commitments at all is opened at that one-off place as of Monday 28 September 2026, at a
  record place and a roster place where nothing has been kept; "Call mum" is committed in its one-off
  entry and refused; and the text in its one-off entry is then edited
- **THEN** it tells nothing under its one-off entry or under any one-off row's name field
- **AND** its One-offs group holds one row, named "Call mum"
- **AND** after "Call mum" is committed in its one-off entry and refused again, and "Call dad" is
  committed there with no edit told between, its One-offs group holds rows named "Call mum" and then
  "Call dad", and it tells nothing under its one-off entry

#### Scenario: what is told under a one-off name field ends when the day being shown changes and stands when today is sent back to today

- **WHEN** a one-off named "Call mum" on 28 September 2026 is added at a one-off place; a day screen
  of no commitments at all is opened at that one-off place as of Monday 28 September 2026, at a
  record place and a roster place where nothing has been kept; "Call mum" is committed in its one-off
  entry and refused; and it is sent back to today without having been moved
- **THEN** it still tells, under its one-off entry, "Already on this day"
- **AND** after it is moved to the day after, it tells nothing under its one-off entry
- **AND** a day screen opened the same way, on which "Call mum" is committed and refused and
  Wednesday 30 September 2026 is then picked, tells nothing under its one-off entry

#### Scenario: what is told under a one-off name field ends when the app is shown again

- **WHEN** a one-off named "Call mum" on 28 September 2026 is added at a one-off place; a day screen
  of no commitments at all is opened at that one-off place as of Monday 28 September 2026, at a
  record place and a roster place where nothing has been kept; "Call mum" is committed in its one-off
  entry and refused; and the app is shown again as of that same day
- **THEN** it tells nothing under its one-off entry
- **AND** its One-offs group holds one row, named "Call mum"

#### Scenario: a refusal under one one-off name field replaces what is told under another, and ends when its row is no longer held

- **WHEN** one-offs named "Call mum" and then "Ring mum", both on 28 September 2026, are added at a
  one-off place; a day screen of no commitments at all is opened at that one-off place as of Monday
  28 September 2026, at a record place and a roster place where nothing has been kept; "Call mum" is
  committed in its one-off entry and refused; and "Ring mum" is then committed in the name field of
  the row named "Call mum" and refused
- **THEN** it tells, under the name field of the row named "Call mum", "Already on this day"
- **AND** it tells nothing under its one-off entry
- **AND** after the row named "Call mum" is ticked, it tells nothing under its one-off entry or under
  any one-off row's name field

#### Scenario: a rename committed with its row's own name leaves a refusal already told under that row standing

- **WHEN** one-offs named "Call mum" and then "Ring mum", both on 28 September 2026, are added at a
  one-off place; a day screen of no commitments at all is opened at that one-off place as of Monday
  28 September 2026, at a record place and a roster place where nothing has been kept; "Ring mum" is
  committed in the name field of the row named "Call mum" and refused; and "Call mum" is then
  committed in that same name field
- **THEN** committing is not refused with an error
- **AND** it still tells, under the name field of the row named "Call mum", "Already on this day",
  carrying the text "Ring mum"
- **AND** its One-offs group holds rows named "Call mum" and then "Ring mum"

