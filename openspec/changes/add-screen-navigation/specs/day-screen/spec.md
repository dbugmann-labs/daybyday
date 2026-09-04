## ADDED Requirements

### Requirement: A day screen moves the day it is showing one calendar day either way

A day screen SHALL move the day it is showing to the calendar date one day earlier than it and to the
calendar date one day later. What a move gives SHALL be what moving the day view the screen holds
gives, handed the commitments and the record the screen already holds: the step is exactly one
calendar day whatever month, year or leap day it crosses, and it is taken whether or not anything is
due on the day landed on. Neither is restated here — a day screen's move is this capability's own
answer about a day view, asked from the screen.

A move SHALL be asked of the screen and SHALL be handed nothing. A day view holds neither commitments
nor a history and must be given both to move; a day screen holds both already, and a move that took
either from a caller would let two callers put one screen on two different days.

The today SHALL NOT move. A move changes the day being shown and nothing else, so the day the screen
was handed when the app was last shown is the same day after any number of moves in either direction.
Every question a day screen asks as of a day SHALL still be asked as of that today — which tick a row
offers, and whether the day it says is said as today — and a move that carried the today with it
would put a screen two days forward in a position to offer a tick for a day that has not arrived.

A day screen SHALL step as far back and as far forward as the calendar goes, and SHALL add no bound
of its own. It MUST NOT stop at the today it holds, at the earliest day a commitment it was handed is
kept from, or at any day read off what the record holds: a day it can form a day view of is a day it
can show. A day before every commitment was kept from holds no rows, which is an answer rather than a
gap; a day that has not arrived holds rows that already refuse their ticks. A bound at either end
would be a second rule stacked on an answer this capability already gives.

A move SHALL NOT read the record again. It SHALL form the day view from the record as the screen last
read it — the reading done when the app was shown, together with every change kept on the screen
since — in the way making a tick does. Being shown is the moment a day screen learns what is at its
place, and a move is not a moment the record can have changed under the person looking at it. A move
SHALL therefore leave what the screen says about its record exactly as it was, and a day screen that
is not keeping a record SHALL move like any other and go on saying so.

#### Scenario: a day screen moved to the day before shows the previous day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026, and it is moved to the day before
- **THEN** its day view is the same day view as one formed directly of those two commitments, in that
  order, on Sunday 30 August 2026, from a history that has taken no tick
- **AND** it holds one row, named "Journaling"

#### Scenario: a day screen moved to the day after shows the next day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026, and it is moved to the day after
- **THEN** its day view is the same day view as one formed directly of those two commitments, in that
  order, on Tuesday 1 September 2026, from a history that has taken no tick
- **AND** it holds one row, named "Journaling"

#### Scenario: moving a day screen does not change the today it was handed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day after
- **THEN** it says the day is "Tuesday 1 September 2026", without "Today" in front of it
- **AND** moving it to the day before makes it say the day is "Today · Monday 31 August 2026", which
  is the day it was handed

#### Scenario: a day screen moves onto a day that has not arrived and shows it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day after four times
- **THEN** its day view is the same day view as one formed directly of that commitment on Friday
  4 September 2026 from a history that has taken no tick
- **AND** it says the day is "Friday 4 September 2026"

#### Scenario: a day screen moves back to a day before every commitment was kept from and shows no rows

- **WHEN** a day screen is opened as of Thursday 1 January 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day before
- **THEN** its day view holds no rows, Wednesday 31 December 2025 being before the day the commitment
  is kept from
- **AND** moving it to the day after gives back the day view it held when it was opened

#### Scenario: moving a day screen does not read the record again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; a tick for that commitment on Sunday 30 August 2026 is then kept at that place by
  something else; and the day screen is moved to the day before
- **THEN** its day view says the commitment is not kept on Sunday 30 August 2026
- **AND** it says it is keeping a record, exactly as it did before the move

#### Scenario: moving a day screen away and back shows the day it started from

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026, and it is moved to the day after and then to the day before
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** moving it to the day before and then to the day after gives that same day view again

#### Scenario: a day screen that is not keeping a record moves and goes on saying it is keeping none

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes that
  is not what a record is written as, of a commitment named "Journaling" on a schedule listing all
  seven weekdays, kept from 1 January 2026, and it is moved to the day before
- **THEN** its day view is the same day view as one formed directly of that commitment on Sunday
  30 August 2026 from a history that has taken no tick
- **AND** it says it is not keeping a record

### Requirement: A day screen goes straight back to the today it was handed

A day screen SHALL go back, in one step and from whatever day it is showing, to the today it was
handed. Going back SHALL make the day being shown that today and SHALL form the day view again on it,
from the commitments and the record the screen already holds. It is a move like any other in every
respect but the distance: it reads no record again, it leaves what the screen says about its record
alone, and it moves the day being shown and never the today.

The day it goes back to SHALL be the today the screen was last handed, and this capability MUST NOT
read a clock to find it. A screen opened on one day and shown again on another goes back to the
second, because that is the today it then holds; a screen never shown again goes back to the day it
was opened on.

Going back SHALL take no day from the caller, and SHALL reach the today and no other day. A day named
by a caller is a different thing to offer and needs something to name one with, and a day screen
offers nothing of the kind.

A day screen already showing its today SHALL be left showing it. There is nothing to undo, and going
back SHALL be an answer rather than a refusal: it is the one move that always has somewhere to go.

#### Scenario: a day screen moved into the past goes back to today in one step

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day before three times; and it is then sent back to today
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** it says the day is "Today · Monday 31 August 2026"

#### Scenario: a day screen moved into the future goes back to today in one step

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day after three times; and it is then sent back to today
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** it says the day is "Today · Monday 31 August 2026"

#### Scenario: a day screen already showing today is left where it is when it is sent back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is sent back to today without having been moved
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** it says the day is "Today · Monday 31 August 2026"

#### Scenario: a day screen goes back to the today it was last handed rather than the day it opened on

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; the app is then shown again as of Wednesday 2 September 2026; it is moved to the
  day before twice; and it is then sent back to today
- **THEN** it says the day is "Today · Wednesday 2 September 2026"

#### Scenario: going back to today does not read the record again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before; a tick for that commitment on Monday 31 August 2026
  is then kept at that place by something else; and it is sent back to today
- **THEN** its day view says the commitment is not kept on Monday 31 August 2026
- **AND** it says it is keeping a record, exactly as it did before

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
- **AND** it says the day is "Saturday 1 January 1583"
- **AND** it says it is keeping a record

#### Scenario: a day screen showing the last supported date is unchanged when it is moved to the day after

- **WHEN** a day screen is opened as of Thursday 30 December 9999, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583; it is moved to the day after; and it is moved to the day after again
- **THEN** its day view is the same day view as one formed directly of that commitment on Friday
  31 December 9999 from a history that has taken no tick
- **AND** it says the day is "Friday 31 December 9999"
- **AND** it says it is keeping a record

#### Scenario: a day screen at either end of the calendar still moves the other way

- **WHEN** a day screen is opened as of Saturday 1 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583, and a second day screen is opened the same way as of Friday 31 December 9999
- **THEN** the first, moved to the day before and then to the day after, says the day is "Sunday
  2 January 1583"
- **AND** the second, moved to the day after and then to the day before, says the day is "Thursday
  30 December 9999"

## MODIFIED Requirements

### Requirement: A day screen holds the day view of the day it was handed, formed from the record kept at its place

A day screen SHALL be opened from three things: some commitments, the day it is being opened on, and
the place its record is kept at. It SHALL hold the day view of those commitments on that day, formed
from the history held at that place, and SHALL give that day view back whole and unaltered. It adds
nothing to it and takes nothing away: which commitments have a row, in which order, and what each
row says are already this capability's answers about a date, and what is kept at a place is the
`record` capability's answer, so a day screen SHALL hold exactly the day view that would be formed
directly from the same commitments, the same day and that same history.

The today a day screen holds SHALL be given to it and never asked for. This capability MUST NOT read
a clock, MUST NOT consult the present moment, the device's time zone or the locale, so a day screen
opened as of any date the system supports holds that date's day view whatever day it really is, and
two day screens opened as of the same day from the same record hold the same day view for ever.

A day screen SHALL hold two days, and they SHALL be separate things. The **today** it was handed is a
fact about the device, and every question the screen asks as of a day is asked as of it. The **day it
is showing** is what its day view is of and what a person is looking at; it SHALL begin as that same
today, and it SHALL be the one a move changes. The two coincide when a screen is opened and whenever
it is showing its today, and a day screen MUST NOT keep only one of them: a screen that moved by
writing its today would ask every as-of question as of the day being displayed, which is what would
let a tap offer a tick for a day that has not arrived.

A day screen SHALL hold the day it is showing until it is moved or the app is shown again, and SHALL
be moved onto another day by nothing else. Time passing MUST NOT move it, and neither MUST a tick
made on it: a screen a person is looking at cannot change day underneath them. The today SHALL be
replaced only when the app is shown again, and by nothing a person does on the screen.

#### Scenario: a day screen opened where nothing has been kept holds the day view of that day with nothing kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Run" on a schedule listing Tuesday, Thursday and Sunday, both kept from 1 January
  2026
- **THEN** its day view holds one row, for "Gym"
- **AND** that row says the commitment is not kept

#### Scenario: a day screen opened where a tick was kept holds a day view that says the commitment is kept

- **WHEN** a tick for a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, on Monday 31 August 2026 is kept at a place, and a day screen of that
  commitment is then opened at that place as of Monday 31 August 2026
- **THEN** its day view's one row says the commitment is kept

#### Scenario: a day screen holds the day it was handed rather than the day it really is

- **WHEN** a day screen is opened as of Monday 3 January 1583, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 1583
- **THEN** its day view is the same day view as one formed directly of that commitment on Monday
  3 January 1583 from a history that has taken no tick
- **AND** a day screen opened the same way as of Monday 27 December 9999 holds the day view of that
  date instead

#### Scenario: a day screen holds the same day view as one formed directly from the same commitments, day and history

- **WHEN** ticks for a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday
  and for a commitment named "Journaling" on a schedule listing all seven weekdays, both kept from
  1 January 2026, on Monday 31 August 2026 are kept at a place; the "Journaling" tick is then taken
  back; and a day screen of those two commitments, in that order, is opened at that place as of
  Monday 31 August 2026
- **THEN** its day view is the same day view as one formed directly of those two commitments, in
  that order, on Monday 31 August 2026, from a history holding exactly the remaining tick

### Requirement: A day screen makes and takes back the tick a row offers, and keeps it before the day view says so

A day screen SHALL make the tick one of its rows offers, and SHALL take that same tick back where
the row already says its commitment is kept. Which of the two a tap means SHALL be read off the row
and MUST NOT be given to the screen: a row saying its commitment is not kept makes the tick, a row
saying it is takes it back, and there is nothing else a tap can mean.

The tick SHALL be the one the row itself offers, asked as of the today the screen was handed and
never as of the day it is showing. A day screen moved onto a day that has not arrived therefore takes
no tick on it: the row it holds is for a date later than that today, and a row for such a date offers
nothing. Moving a screen forward MUST NOT make a tick formable that was not formable before the move,
and that is the whole of what holding the two days apart buys. The screen MUST NOT form a tick of its
own, MUST NOT choose which tick a row means, and MUST NOT reach past a row to the commitment
underneath it. A row the screen's day view does not hold SHALL change nothing at all: a row is a
commitment's line on a date, so a row from a day this screen is no longer on, or from another screen
entirely, ticks nothing here.

The change SHALL be kept at the screen's place before its day view says so, and the day view SHALL
then be formed again, on the day the screen is showing, from the record as it stands rather than the
day view it held being altered: what a person reads is always an answer taken from what is kept. A
change that could not be kept SHALL be refused, SHALL be reported to the caller rather than passed
over, and SHALL leave the day view exactly as it was. The day view a person reads MUST NOT be ahead
of what is kept at the place, and a tick that could not be kept MUST NOT be held anywhere in its
place.

#### Scenario: ticking a row that says its commitment is not kept makes the day screen say it is kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and its one row is ticked
- **THEN** the day screen's day view says the commitment is kept on that date

#### Scenario: ticking a row that says its commitment is kept takes the tick back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; its one row is ticked; and the row the day screen then holds is ticked again
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** its day view is the same day view as the one the screen held when it was opened

#### Scenario: a tick made on a day screen is held by a day screen opened afterwards at the same place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; its one row is ticked; and a second day screen of the same commitment is then
  opened at the same place as of the same day
- **THEN** the second day screen's day view says the commitment is kept on that date

#### Scenario: a tick taken back on a day screen is not held by a day screen opened afterwards at the same place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; its one row is ticked and the resulting row ticked again; and a second day screen
  of the same commitment is then opened at the same place as of the same day
- **THEN** the second day screen's day view says the commitment is not kept on that date

#### Scenario: ticking one row leaves the other rows of the day as they were

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, a
  commitment named "Journaling" on a schedule listing all seven weekdays and a commitment named
  "Supplements and habits" on that same schedule, in that order and all kept from 1 January 2026,
  and the second of its three rows is ticked
- **THEN** the day screen's day view holds three rows in that same order
- **AND** only the second says its commitment is kept

#### Scenario: a change that cannot be kept is refused and leaves the day view as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
- **THEN** ticking is refused with an error
- **AND** the day screen's day view still says the commitment is not kept on that date
- **AND** a day screen opened afterwards at the same place says the same

#### Scenario: a row the day screen's day view does not hold changes nothing

- **WHEN** two day screens of a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, are opened at one place where nothing has been kept, the first
  as of Monday 31 August 2026 and the second as of Wednesday 2 September 2026, and the second
  screen's row is ticked on the first screen
- **THEN** the first day screen's day view still says the commitment is not kept on Monday 31 August
  2026
- **AND** a day screen opened afterwards at that place as of Wednesday 2 September 2026 says the
  commitment is not kept on that date either

#### Scenario: ticking a row on a day a day screen has moved back to keeps the tick on that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before; and its one row is ticked
- **THEN** its day view says the commitment is kept on Sunday 30 August 2026
- **AND** a day screen opened afterwards at that place as of Sunday 30 August 2026 says the
  commitment is kept on that date
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says the
  commitment is not kept on that date

#### Scenario: ticking a row on a day a day screen has moved onto that has not arrived keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day after; and its one row is ticked
- **THEN** its day view still says the commitment is not kept on Tuesday 1 September 2026
- **AND** a day screen opened afterwards at that place as of Tuesday 1 September 2026 says the
  commitment is not kept on that date

### Requirement: A day screen re-reads its day and its record when the app is shown again

A day screen SHALL be told when the app has been shown — opened from nothing, or brought back in
front of a person — and SHALL be handed the day it has been shown on. On being told, it SHALL take
that day as its today, and SHALL form its day view again from the record read again at its place.
Both of those SHALL happen whatever day the screen is showing.

Which day it then shows SHALL depend on where it was. A day screen showing the day it was last handed
as today SHALL show the day it has now been shown on, so that putting the phone down on one evening
and picking it up the next morning lands on the morning rather than on the night before. A day screen
showing any other day SHALL go on showing that day: it is a day the person chose, and time passing is
not a reason to take it away. Being shown again includes every glance at another app and back, and
losing a day half filled in to one is the failure this half of the rule exists to prevent.

That comparison SHALL be made against the today the screen held before it was told, and against
nothing kept for the purpose. A day screen moved away and back onto its today is therefore in exactly
the state a screen that never moved is in, and follows the next day it is shown on; so is one sent
back to today.

A day screen shown again on the day it is already showing SHALL hold that same day's day view, formed
again rather than merely kept.

Reading the record again SHALL be a fresh opening at the place rather than a re-reading of what was
already held, so a change made at that place since SHALL be seen. A day screen that could not read
its record when it opened SHALL say it is keeping one after being shown again where the record can
then be read, and one that could SHALL say it is not after being shown again where it then cannot.
What it says about the record SHALL be formed again from what is at the place as it then stands and
never carried over, the reason included: a screen that said only that the record could not be read
SHALL say the record was written by a later version of DayByDay when that is what is then at the
place. Nothing else of a day screen SHALL survive being shown again: the commitments it was handed,
the place it keeps its record at and the day it is showing are all it carries across.

#### Scenario: a day screen shown again on a later day holds that day's day view

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Run" on a schedule listing Tuesday, Thursday and Sunday, both kept from 1 January
  2026, and it is then shown as of Tuesday 1 September 2026
- **THEN** its day view holds one row, for "Run"

#### Scenario: a day screen shown again on the day it is already on holds that day's day view

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and it is then shown as of Monday 31 August 2026
- **THEN** its day view is the same day view as the one it held when it was opened

#### Scenario: a day screen shown again reads the record again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; a tick for that commitment on that date is then kept at that place by something
  else; and the day screen is shown as of Monday 31 August 2026
- **THEN** its day view says the commitment is kept on that date

#### Scenario: a day screen that could not read its record starts keeping one when it is shown again and the record can be read

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026; what is at that place is then replaced by a
  record holding a tick for that commitment on that date; and the day screen is shown as of Monday
  31 August 2026
- **THEN** it says it is keeping a record
- **AND** its day view says the commitment is kept on that date

#### Scenario: a day screen that was keeping a record stops when it is shown again and the record cannot be read

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; what is at that place is then replaced by a run of bytes that is not what a record
  is written as; and the day screen is shown as of Monday 31 August 2026
- **THEN** it says it is not keeping a record
- **AND** its day view says the commitment is not kept on that date

#### Scenario: a day screen shown again where the record is from a later version says so

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; what is at that place is then replaced by a record written in a form one later
  than the form this app writes, holding no ticks; and the day screen is shown as of Monday 31
  August 2026
- **THEN** it says it is not keeping a record
- **AND** it says the record was written by a later version of DayByDay
- **AND** its day view says the commitment is not kept on that date

#### Scenario: a day screen does not change day when a tick is made on it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Run" on a schedule listing Tuesday, Thursday and Sunday, both kept from 1 January
  2026, and its one row is ticked
- **THEN** its day view is the same day view as one formed directly of those two commitments, in
  that order, on Monday 31 August 2026, from a history holding exactly that one tick

#### Scenario: a day screen moved off today keeps the day it is showing when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day before; and the app is then shown again as of Wednesday
  2 September 2026
- **THEN** its day view is the same day view as one formed directly of those two commitments, in that
  order, on Sunday 30 August 2026, from a history that has taken no tick
- **AND** it says the day is "Sunday 30 August 2026"

#### Scenario: a day screen moved away and back onto today moves onto the new day when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day before and then to the day after; and the app is then
  shown again as of Wednesday 2 September 2026
- **THEN** its day view is the same day view as one formed directly of those two commitments, in that
  order, on Wednesday 2 September 2026, from a history that has taken no tick
- **AND** it says the day is "Today · Wednesday 2 September 2026"

#### Scenario: a day screen sent back to today moves onto the new day when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before three times; it is sent back to today; and the app is
  then shown again as of Wednesday 2 September 2026
- **THEN** it says the day is "Today · Wednesday 2 September 2026"

#### Scenario: a day screen kept on a day that has since arrived offers the tick it refused before

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day after, onto Tuesday 1 September 2026, and its one row is
  ticked; the app is then shown again as of Tuesday 1 September 2026; and the one row it then holds
  is ticked
- **THEN** the first ticking left the day view saying the commitment is not kept
- **AND** after being shown again it says the day is "Today · Tuesday 1 September 2026"
- **AND** the second ticking makes its day view say the commitment is kept on Tuesday 1 September
  2026

#### Scenario: a day screen moved off today reads its record again when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before; a tick for that commitment on Sunday 30 August 2026
  is then kept at that place by something else; and the app is shown again as of Monday 31 August
  2026
- **THEN** its day view says the commitment is kept on Sunday 30 August 2026
- **AND** it says the day is "Sunday 30 August 2026", the screen not having moved

### Requirement: A day screen says the day it is showing, as of the day it was handed

A day screen SHALL say the day it is showing, and that SHALL be its day view's day title asked as of
the today it was handed. It adds nothing to that answer and takes nothing away: the words are the day
title requirement's, and the only thing a day screen contributes is the day the question is asked as
of, which is the today it holds and is the one thing here that is not on the screen already.

The date it says SHALL follow the day the screen is showing, and the word "Today" SHALL follow the
today. A day screen moved off its today therefore says a bare date, and one showing its today — for
having never moved, for having been moved back, or for having been sent back — says "Today" in front
of that date. That is how a person knows they are not where they started, and it is why a screen that
can be moved has to say its day at all.

The today SHALL be the one the screen was handed and never one it went looking for. A day screen MUST
NOT read a clock to say its day, so a screen handed a day says that day whatever day it really is,
and it says the same day until it is moved or the app is shown again — a tick made on it MUST NOT
change what it says the day is, and neither MUST time passing.

A day screen SHALL say its day whether or not it is keeping a record. What a date asks of a person
needs no record to answer, so a screen that could not read one says its day exactly as a screen that
did.

#### Scenario: a day screen says the day it is showing

- **WHEN** a day screen is opened as of Thursday 3 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026
- **THEN** it says the day is "Today · Thursday 3 September 2026"

#### Scenario: a day screen says the day it was handed rather than the day it really is

- **WHEN** a day screen is opened as of Monday 3 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583
- **THEN** it says the day is "Today · Monday 3 January 1583"
- **AND** a day screen opened the same way as of Monday 27 December 9999 says the day is "Today ·
  Monday 27 December 9999"

#### Scenario: a day screen says the day its own day view says, asked as of the day it was handed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026
- **THEN** what it says the day is is what its day view says when that day view is asked as of Monday
  31 August 2026

#### Scenario: a day screen shown again on a later day says that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the app is then shown again as of Tuesday 1 September 2026
- **THEN** it says the day is "Today · Tuesday 1 September 2026"

#### Scenario: a day screen that cannot read its record still says the day

- **WHEN** a day screen is opened as of Monday 31 August 2026, of a commitment named "Journaling" on
  a schedule listing all seven weekdays, kept from 1 January 2026, at a place holding a run of bytes
  that is not a record
- **THEN** it says it is not keeping a record
- **AND** it says the day is "Today · Monday 31 August 2026"

#### Scenario: a day screen says the same day after a tick is made on it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and its one row is ticked
- **THEN** it says the day is "Today · Monday 31 August 2026", exactly as it did before the tick

#### Scenario: a day screen moved to another day says that day and does not say Today

- **WHEN** a day screen is opened as of Thursday 3 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day before
- **THEN** it says the day is "Wednesday 2 September 2026"
- **AND** moving it to the day before again makes it say the day is "Tuesday 1 September 2026"

#### Scenario: a day screen sent back onto today says Today again

- **WHEN** a day screen is opened as of Thursday 3 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before twice; and it is then sent back to today
- **THEN** it says the day is "Today · Thursday 3 September 2026"
