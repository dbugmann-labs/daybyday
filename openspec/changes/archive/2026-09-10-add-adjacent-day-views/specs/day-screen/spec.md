## ADDED Requirements

### Requirement: A day screen says the day view of the day before the one it is showing and of the day after

A day screen SHALL say two further day views beside the one it is showing: the day view of the
calendar date one day earlier than the day being shown, and the day view of the calendar date one
day later. They SHALL be two answers rather than one — a caller needs either without the other, and
neither is derived from the other — and the day view of the day being shown SHALL go on being said
exactly as it is today, unchanged in name, in shape and in every answer it gives.

**Each SHALL be the day view this screen would hold had it been moved onto that day.** It SHALL be
formed from the commitments the screen's roster had not stopped keeping **on that day**, in the
groups and the order that roster answers with for it, and from the record the screen already holds —
which is to say from exactly what *A day screen moves the day it is showing one calendar day either
way* would form on landing there. A commitment the roster stopped keeping yesterday therefore has a
row on the day before and none on the day being shown, and a commitment kept from tomorrow has a row
on the day after and none today. This capability MUST NOT form either from the commitments answered
for the day being shown: a neighbour formed against the wrong day's roster would change the moment it
was moved onto, and what a person is shown of a day must be what they get when they reach it.

**Saying either SHALL read neither place again.** The roster asked is the one read when the app was
last shown or the screen was last returned to, whichever happened later, together with every change
kept since; the record is the record as the screen last read it, together with every change kept on
the screen since. Being shown and being returned to are the moments a day screen learns what is at
either place, and being asked what is either side of the day is not one of them.

**Saying either SHALL change nothing about the screen.** The day being shown SHALL be the day it was,
the today SHALL NOT move, nothing SHALL be kept at either place, and **what the screen is telling on
a row SHALL be left exactly as it was**. What a day screen tells on a row lasts until the app is
shown again, a change is kept, or the day it is showing changes, and asking what is either side of
the day is none of those three: a caller that stepped the screen onto a neighbour and back in order
to read one would wipe a refusal the person had not read yet, and this answer exists so that nothing
ever has to.

**Exactly one day either side SHALL be said, and never a run of them.** A day screen says the day
before and the day after and no day beyond either; a caller wanting the day after that moves the
screen and asks again, and gets the answer for the day it is then showing.

**Both SHALL follow the day being shown**, whatever put the screen on it: the day it was opened on, a
move either way, the way back to today, a day picked on its day picker, a new today handed to it when
the app was shown again, or the screen being returned to. Each of those SHALL leave the two answers
being the neighbours of the day then being shown, formed from the roster and the record then held —
so a screen returned to after its roster changed says its neighbours from the roster it then holds,
and never from the one it held before.

**A day screen that is not keeping a record or not keeping a roster SHALL say them like any other.**
Each is formed exactly as the day being shown is, from whatever the screen holds: a screen that could
not read its record says three days of rows none of which is kept, and a screen that could not read
its roster says three days holding no rows. Withholding them would let a failure at a place take away
what a person can be shown of the days either side, which is more than the failure itself costs, and
what the screen says about either place SHALL be untouched by being asked.

#### Scenario: a day screen says the day view of the day before the one it is showing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026
- **THEN** the day view it says of the day before is the same day view as one formed directly of
  those two commitments, in that order, on Sunday 30 August 2026, from a history that has taken no
  tick
- **AND** that day view holds one row, named "Journaling"

#### Scenario: a day screen says the day view of the day after the one it is showing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026
- **THEN** the day view it says of the day after is the same day view as one formed directly of those
  two commitments, in that order, on Tuesday 1 September 2026, from a history that has taken no tick
- **AND** that day view holds one row, named "Journaling"

#### Scenario: a day screen says the day one calendar day either side and no day further

- **WHEN** a day screen is opened as of Sunday 1 March 2026, at a place where nothing has been kept,
  of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1 January
  2026
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Saturday 28 February 2026 from a history that has taken no tick, which is one
  calendar day earlier and not two
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Monday 2 March 2026 from that same history

#### Scenario: saying the day either side of a day screen leaves the day it is showing exactly as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the day views it says of the day before and of the day after are both read
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** its day picker opens on Monday 31 August 2026, and it offers no way back to today

#### Scenario: a day screen moved to another day says the day either side of that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day after
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Monday 31 August 2026 from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Wednesday 2 September 2026 from that same history

#### Scenario: a day screen sent back to today says the day either side of that today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before three times; and it is then sent back to today
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Sunday 30 August 2026 from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Tuesday 1 September 2026 from that same history

#### Scenario: a day screen showing a day picked on its day picker says the day either side of that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and Friday 25 September 2026 is picked on its day picker
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Thursday 24 September 2026 from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Saturday 26 September 2026 from that same history

#### Scenario: a day screen shown again on a new day says the day either side of that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the app is then shown again as of Wednesday 2 September 2026
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Tuesday 1 September 2026 from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Thursday 3 September 2026 from that same history

#### Scenario: a day screen says a day either side drawn from the commitments its roster had not stopped keeping on that day

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and stopped as of Sunday 30 August 2026; and a day
  screen of no commitments at all is opened at that roster place as of Monday 31 August 2026, at a
  record place where nothing has been kept
- **THEN** its day view holds no rows, Monday 31 August 2026 being after the day the commitment was
  kept until
- **AND** the day view it says of the day before holds one row, named "Journaling"
- **AND** the day view it says of the day after holds no rows

#### Scenario: a day screen says a day either side drawn from the record it already holds

- **WHEN** a tick for a commitment named "Journaling" on a schedule listing all seven weekdays, kept
  from 1 January 2026, on Tuesday 1 September 2026 is kept at a place; and a day screen of that
  commitment is then opened at that place as of Monday 31 August 2026
- **THEN** the day view it says of the day after holds one row, saying the commitment is kept
- **AND** the day view it says of the day before holds one row, saying the commitment is not kept
- **AND** its own day view holds one row, saying the commitment is not kept

#### Scenario: saying the day either side of a day screen does not read its record or its roster again

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; a
  commitment named "Gym" on a schedule listing all seven weekdays, kept from that same day, is then
  taken on at that roster place by something else, and a tick for "Journaling" on Sunday 30 August
  2026 is kept at that record place by something else
- **THEN** the day view it says of the day before holds one row, named "Journaling", saying the
  commitment is not kept
- **AND** the day view it says of the day after holds one row, named "Journaling"
- **AND** it says it is keeping a roster and keeping a record, exactly as it did before

#### Scenario: a tick made on the day a day screen is showing leaves the day either side of it as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; the day views it says of the day before and of the day after are read; and its one
  row is then ticked
- **THEN** its day view says the commitment is kept on Monday 31 August 2026
- **AND** the day view it says of the day before is the same day view as the one it said before the
  tick, saying the commitment is not kept on Sunday 30 August 2026
- **AND** the day view it says of the day after is the same day view as the one it said before the
  tick, saying the commitment is not kept on Tuesday 1 September 2026

#### Scenario: a day screen that cannot read its record says the day either side of it with nothing kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes that
  is not what a record is written as, of a commitment named "Journaling" on a schedule listing all
  seven weekdays, kept from 1 January 2026
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Sunday 30 August 2026 from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Tuesday 1 September 2026 from that same history
- **AND** it says it is not keeping a record

#### Scenario: a day screen that cannot read its roster says the day either side of it and neither holds rows

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a run of
  bytes that is not what a roster is written as, at a record place where nothing has been kept, of a
  commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1 January 2026
- **THEN** the day view it says of the day before holds no rows
- **AND** the day view it says of the day after holds no rows
- **AND** it says it is not keeping a roster

#### Scenario: a day screen goes on telling what it was telling on a row when it is asked the day either side of it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; its one row is ticked and the
  change is refused; and the day views it says of the day before and of the day after are then both
  read
- **THEN** it is still telling, on that row, that the change could not be kept
- **AND** its day view is the same day view as the one it held when it was opened

#### Scenario: a day screen returned to says the day either side of it from the roster it then holds

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; a
  commitment named "Gym" on a schedule listing all seven weekdays, kept from that same day, is then
  taken on at that roster place by something else; and the screen is returned to
- **THEN** the day view it says of the day before holds two rows, named "Journaling" and then "Gym"
- **AND** the day view it says of the day after holds two rows, named "Journaling" and then "Gym"

### Requirement: A day screen says no day view before the first supported date and none after the last

A day screen showing 1 January 1583 SHALL say no day view of the day before it, and a day screen
showing 31 December 9999 SHALL say no day view of the day after it. Those are the first and last
dates the system forms, so there is no day view to say, in the way there is none for 30 February —
and the absence is the whole of the answer, exactly as it is when a day view is asked for the day
before its own first date.

**The absence SHALL be about the calendar and about nothing else.** A screen showing either end SHALL
go on saying the day view on its other side; a screen showing any other date SHALL say one on both
sides, whatever its roster holds, whatever its record holds, whether its day view has any rows, and
whichever day it was handed as today.

**The absence SHALL NOT be read as an answer about moving.** It says what there is to draw beside the
day being shown; whether a move has anywhere to go is not answered here and is not answered anywhere,
and a caller MUST NOT stand a move down on the strength of it. Staying exactly as it was is the
move's own answer, given by the move.

#### Scenario: a day screen showing the first supported date says no day view before it and says the day after

- **WHEN** a day screen is opened as of Saturday 1 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583
- **THEN** it says no day view of the day before
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Sunday 2 January 1583 from a history that has taken no tick

#### Scenario: a day screen showing the last supported date says no day view after it and says the day before

- **WHEN** a day screen is opened as of Friday 31 December 9999, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583
- **THEN** it says no day view of the day after
- **AND** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Thursday 30 December 9999 from a history that has taken no tick

#### Scenario: a day screen moved off an end of the calendar says a day view either side of it

- **WHEN** a day screen is opened as of Saturday 1 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583, and it is moved to the day after
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Saturday 1 January 1583 from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Monday 3 January 1583 from that same history

### Requirement: A day screen makes every change on the day it is showing and none on a day either side of it

Every change a day screen makes SHALL be made on the day it is showing. A tick made or taken back, a
number entered or taken back, a note entered or taken back, an amount added and a last addition taken
back are all changes to the day being shown, and a day screen SHALL make none of them on the day
before it or the day after it, whatever it says about those days.

**A row that only a day either side holds SHALL change nothing at all.** A row is a commitment's line
on a date, so a row taken from the day view of the day before or of the day after is a row for a date
this screen is not on: making a tick with it, entering with it and taking back with it SHALL each
leave the record's place exactly as it was, SHALL leave the screen's day view exactly as it was, and
SHALL leave what the screen says of the days either side exactly as it was. This is the shipped rule
that *a row the screen's day view does not hold SHALL change nothing at all*, read over the rows this
capability now says: what a day screen says of a neighbouring day is something to draw, and never
something to act through.

**Nothing SHALL be told on such a row.** A row this screen is not on is not a refusal a person needs
to be told about — nothing was attempted on the day they are looking at — so a change asked for
through one SHALL leave what the screen is telling on a row exactly as it was, whether that was
something or nothing.

#### Scenario: ticking a row a day screen says of the day before changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the one row of the day view it says of the day before is ticked
- **THEN** the day view it says of the day before still says the commitment is not kept on Sunday
  30 August 2026
- **AND** its day view is the same day view as the one it held when it was opened
- **AND** the content at its record place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: entering a number on a row a day screen says of the day after changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026; and "72" is committed on the one row of the
  day view it says of the day after
- **THEN** the entry that row offers, asked again from the day view the screen then says of the day
  after, says no number
- **AND** its day view is the same day view as the one it held when it was opened
- **AND** the content at its record place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: taking back the last addition on a row a day screen says of the day before changes nothing

- **WHEN** a day screen is opened as of Sunday 30 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing all seven weekdays, kept from 1 January 2026; "30" is committed on the one row it holds;
  it is moved to the day after; and the last addition is then taken back on the one row of the day
  view it says of the day before
- **THEN** the entry that row offers, asked again from the day view the screen then says of the day
  before, says "30 of 120"
- **AND** the content at its record place is byte-for-byte what it was immediately before that
  take-back was asked for

#### Scenario: a day screen tells nothing on a row of a day either side of the one it is showing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026, and the one row of the day view it
  says of the day before is ticked
- **THEN** it is telling nothing on any row
- **AND** ticking that row is not refused with an error

## MODIFIED Requirements

### Requirement: A move with nowhere to go leaves a day screen exactly as it was

A day screen showing 1 January 1583 SHALL be left exactly as it is when moved to the day before, and
a day screen showing 31 December 9999 SHALL be left exactly as it is when moved to the day after.
Those are the first and last dates the system forms, so there is no day view to move to, in the way
there is none for 30 February.

Staying SHALL be the whole of the answer. The screen SHALL go on showing the day it was showing,
holding the day view it was holding and saying what it was saying about its record, and it MUST NOT
report that the move had nowhere to go. A day view moved past either end gives nothing rather than
itself, because a caller holding a value could not otherwise tell it had reached the end of the
calendar; a screen is not a value, and a person looking at one that has not moved can see that it has
not moved.

A day screen SHALL NOT say whether it can move either way, at any date and in either direction. The
two ends are 1 January 1583 and 31 December 9999, so such an answer would be the same on every day
anyone will look at, and what is drawn where a move does nothing is the shell's to decide rather than
this capability's.

**That refusal is about the two ends of the calendar, and it is not a rule that a day screen says
nothing about its controls.** A day screen does say whether it offers the way back to today, and the
difference is the one `CONTEXT.md` § *Offered* draws: what bounds an offer is what the screen holds
the answer to, and an answer about the ends would be the same on every day anyone will look at while
an answer about the today changes with every move. So the sentence above about what is drawn is about
the chevrons and about nothing else — where a chevron has nothing to say for itself the shell decides
alone, and where the way back to today has something to say the shell asks. Neither answer moves the
other, and this requirement gains no rule from the existence of the other.

**Nor is it a rule that a day screen says nothing about the days either side of the one it is
showing.** A day screen says the day view of the day before and the day view of the day after, and at
1 January 1583 and 31 December 9999 it says none on that side — *A day screen says no day view before
the first supported date and none after the last*. That absence is visible to a caller and this
requirement's refusal is narrowed to leave room for it, on the distinction it already draws once
above: **what the screen can draw is not whether it can move.** An absent day view says there is
nothing to draw beside the day being shown, which is what a gesture reaching past the end of the
calendar resists against; it says nothing about whether the move may be asked for, and a caller MUST
NOT stand a move down on the strength of it. Asking for a move that has nowhere to go SHALL go on
being answered by this requirement — by the screen staying exactly as it is, reporting nothing — and
that is still the only answer about moving this capability gives.

Being left as it was SHALL be about the calendar and about nothing else. It MUST NOT depend on which
commitments the screen was handed, on what its record holds, on whether its day view has any rows, or
on which day it was handed as today: a screen at either end SHALL move normally in the other
direction, and a screen showing any other date SHALL move both ways.

#### Scenario: a day screen showing the first supported date is unchanged when it is moved to the day before

- **WHEN** a day screen is opened as of Sunday 2 January 1583, at a place where nothing has been kept,
  of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1 January
  1583; it is moved to the day before; and it is moved to the day before again
- **THEN** its day view is the same day view as one formed directly of that commitment on Saturday
  1 January 1583 from a history that has taken no tick
- **AND** its day picker opens on Saturday 1 January 1583
- **AND** it says it is keeping a record

#### Scenario: a day screen showing the last supported date is unchanged when it is moved to the day after

- **WHEN** a day screen is opened as of Thursday 30 December 9999, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583; it is moved to the day after; and it is moved to the day after again
- **THEN** its day view is the same day view as one formed directly of that commitment on Friday
  31 December 9999 from a history that has taken no tick
- **AND** its day picker opens on Friday 31 December 9999
- **AND** it says it is keeping a record

#### Scenario: a day screen at either end of the calendar still moves the other way

- **WHEN** a day screen is opened as of Saturday 1 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583, and a second day screen is opened the same way as of Friday 31 December 9999
- **THEN** after the first is moved to the day before and then to the day after, its day picker
  opens on Sunday 2 January 1583
- **AND** after the second is moved to the day after and then to the day before, its day picker
  opens on Thursday 30 December 9999

