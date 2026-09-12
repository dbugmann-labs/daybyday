# Day Screen Specification

## Purpose

Describes what one calendar date asks of a person and what they did about it — the commitments due
on that date, each with whether it is kept, in the order the day view was handed them. It is where
`commitment`'s answer about a date and `record`'s answer about a tick are brought together for a
single day, and it is what the screen a person lands on draws.

## Requirements

### Requirement: A day view moves to the day before it and the day after it

Handed some commitments and a history, a day view SHALL move to the day view of the calendar date
one day either side of its own, giving exactly what forming a day view from those commitments, on
that date, in that history would give. A move SHALL carry nothing else across: it MUST NOT keep a
row, a name or an answer about whether a commitment is kept, and MUST NOT reuse what the day view
moved from was formed from.

The commitments and the history a move is handed MAY be different ones, and the day view given back
SHALL then be of those. A move MUST NOT consult a clock, a time zone or a locale and SHALL NOT be
given the day it is being made on, so a day view SHALL move onto a date that has not arrived as
readily as onto one that has, and a row of such a day view SHALL offer no tick asked as of an
earlier day. Moving SHALL leave the day view moved from unchanged.

#### Scenario: moving to the day after gives the day view of the next date

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, then one named
  "Run" on a schedule listing Monday and Thursday, then one named "Vitamins" on a schedule listing
  all seven weekdays, all three kept from 1 January 2026, and it is moved to the day after, handed
  those same commitments and that same history
- **THEN** the day view moved to holds one row, named "Vitamins", saying the commitment is not kept
- **AND** it is the same day view as one formed on Tuesday 1 September 2026 from those same
  commitments, in that same order, and that same history

#### Scenario: moving to the day before gives the day view of the previous date

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  tick, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, then one
  named "Run" on a schedule listing Monday and Thursday, then one named "Vitamins" on a schedule
  listing all seven weekdays, all three kept from 1 January 2026, and it is moved to the day before,
  handed those same commitments and that same history
- **THEN** the day view moved to holds one row, named "Vitamins", saying the commitment is not kept
- **AND** it is the same day view as one formed on Tuesday 1 September 2026 from those same
  commitments, in that same order, and that same history

#### Scenario: the rows of the day moved to are asked again rather than carried across

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Vitamins" on a
  schedule listing all seven weekdays, kept from 1 January 2026, from a history holding a tick for
  that commitment on Monday 31 August 2026 and no other tick, and it is moved to the day after,
  handed that same commitment and that same history
- **THEN** the day view moved from holds one row saying the commitment is kept
- **AND** the day view moved to holds one row, named "Vitamins", saying the commitment is not kept

#### Scenario: a move uses the commitments and history it is handed rather than the ones the day view came from

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, and it is moved to the day after, handed instead a single commitment named "Vitamins" on a
  schedule listing all seven weekdays, kept from that same day, and a history holding a tick for
  "Vitamins" on Tuesday 1 September 2026
- **THEN** the day view moved to holds one row, named "Vitamins", saying the commitment is kept
- **AND** it holds no row named "Gym"

#### Scenario: a day view moves onto a date that has not arrived, and its rows offer no tick

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from 1 January 2026,
  and it is moved to the day after, handed that same commitment and that same history
- **THEN** the day view moved to holds one row named "Vitamins"
- **AND** that row, asked as of Monday 31 August 2026, offers no tick
- **AND** the same row, asked as of Tuesday 1 September 2026, offers a tick

#### Scenario: moving to the day after and back again gives the day view it started from

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday and a commitment named "Vitamins" on a schedule listing all
  seven weekdays, both kept from 1 January 2026 and handed over in that order, from a history
  holding a tick for "Gym" on that date, and it is moved to the day after and then to the day
  before, handed those same commitments and that same history each time
- **THEN** the day view arrived at is the same day view as the one started from
- **AND** moving the one started from to the day before and then to the day after gives that same
  day view again

### Requirement: A move is one calendar day, and never more

A move SHALL step exactly one calendar day. The day after the last day of a month SHALL be the first
day of the month that follows it, the day after 31 December SHALL be 1 January of the next year, and
the day after 28 February SHALL be 29 February in a leap year and 1 March in a year that is not one.
Moving to the day before SHALL be the same step taken the other way, so that either move undoes the
other.

A move SHALL step to the next date whether or not anything is due on it. It MUST NOT skip a date
because no commitment it was handed is due there, MUST NOT stop at the first date something is due
on, and MUST NOT look at the commitments or the history to decide where it lands.

#### Scenario: moving does not skip a date on which nothing is due

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, and it is moved to the day after, handed that same commitment and that same history
- **THEN** the day view moved to holds no rows, though Wednesday 2 September 2026 is the next date
  "Gym" is due on
- **AND** moving that day view to the day after in turn holds one row named "Gym"

#### Scenario: moving across the end of a month

- **WHEN** a day view is formed on Wednesday 30 September 2026, from a history that has taken no
  tick, of a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day after, handed that same commitment and that same
  history
- **THEN** the day view moved to is the same day view as one formed on Thursday 1 October 2026 from
  that commitment and that history
- **AND** moving that day view to the day before gives the day view started from

#### Scenario: moving across the turn of a year

- **WHEN** a day view is formed on Thursday 31 December 2026, from a history that has taken no tick,
  of a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from 1 January
  2026, and it is moved to the day after, handed that same commitment and that same history
- **THEN** the day view moved to is the same day view as one formed on Friday 1 January 2027 from
  that commitment and that history
- **AND** moving that day view to the day before gives the day view started from

#### Scenario: moving across the leap day of a leap year

- **WHEN** a day view is formed on Monday 28 February 2028, from a history that has taken no tick,
  of a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from 1 January
  2026, and it is moved to the day after, handed that same commitment and that same history
- **THEN** the day view moved to is the same day view as one formed on Tuesday 29 February 2028 from
  that commitment and that history
- **AND** moving that day view to the day after in turn gives the day view of Wednesday 1 March 2028

#### Scenario: moving across the end of February in a year that is not a leap year

- **WHEN** a day view is formed on Sunday 28 February 2100, from a history that has taken no tick,
  of a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from 1 January
  2026, and it is moved to the day after, handed that same commitment and that same history
- **THEN** the day view moved to is the same day view as one formed on Monday 1 March 2100 from that
  commitment and that history, 2100 having no leap day
- **AND** moving that day view to the day before gives the day view started from

### Requirement: There is no day before the first supported date and none after the last

A day view of 1 January 1583 SHALL give nothing when moved to the day before, and a day view of 31
December 9999 SHALL give nothing when moved to the day after; those are the first and last dates the
system forms. Nothing SHALL be given rather than the same day view handed back.

The refusal SHALL be about the calendar and about nothing else. It MUST NOT depend on which
commitments the move was handed, on what the history holds, on whether the day view being moved from
has any rows, or on which day the caller believes it is: the same day view moved the other way SHALL
move normally, and every day view of any other date SHALL move both ways.

#### Scenario: the first supported date has no day before it

- **WHEN** a day view is formed on Saturday 1 January 1583, from a history that has taken no tick,
  of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 1583, and it is moved to the day before, handed that same commitment and that same
  history
- **THEN** nothing is given
- **AND** moving that same day view to the day after gives the day view of Sunday 2 January 1583,
  which holds no rows

#### Scenario: the last supported date has no day after it

- **WHEN** a day view is formed on Friday 31 December 9999, from a history that has taken no tick,
  of a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from 1 January
  1583, and it is moved to the day after, handed that same commitment and that same history
- **THEN** nothing is given
- **AND** moving that same day view to the day before gives the day view of Thursday 30 December
  9999, which holds one row named "Vitamins"

#### Scenario: the date one day inside each end of the supported dates moves onto that end

- **WHEN** a day view is formed on Sunday 2 January 1583, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  1583, and it is moved to the day before, handed that same commitment and that same history
- **THEN** the day view moved to is the same day view as one formed on Saturday 1 January 1583 from
  that commitment and that history
- **AND** a day view formed on Thursday 30 December 9999, from a history that has taken no tick, of
  a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from 1 January 1583,
  moved to the day after, is the same day view as one formed on Friday 31 December 9999 from that
  commitment and that history

#### Scenario: the refusal at either end does not depend on what the day view holds

- **WHEN** a day view is formed on Saturday 1 January 1583, from a history that has taken no tick,
  of a commitment named "Run" on a schedule listing Monday and Thursday, kept from 1 January 1583,
  and a second is formed on Friday 31 December 9999, of a commitment named "Vitamins" on a schedule
  listing all seven weekdays, also kept from 1 January 1583, from a history holding a tick for
  "Vitamins" on Friday 31 December 9999
- **THEN** the first holds no rows and gives nothing when moved to the day before
- **AND** the second holds one row saying the commitment is kept and gives nothing when moved to the
  day after

### Requirement: A day screen moves the day it is showing one calendar day either way

A day screen SHALL move the day it is showing one calendar day either way, giving what moving the
day view it holds gives, handed the record the screen holds and the commitments its roster answers
with on the day landed on. A move SHALL be asked of the screen and handed nothing. The today SHALL
NOT move, and every question a day screen asks as of a day SHALL still be asked as of that today.

A day screen SHALL step as far either way as the calendar goes: it MUST NOT stop at the today it
holds, at the earliest day a commitment its roster answers with is kept from, or at any day read off
what the record or the roster holds. A move SHALL NOT read either place again: it SHALL form the day
view from the record as the screen last read it — the reading done when the app was shown, together
with every change kept on the screen since — and from the roster as last read, asked afresh about
the day landed on, and SHALL leave what the screen says about either place exactly as it was. A day
screen not keeping one of them SHALL move like any other and go on saying so.

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
- **THEN** its day picker opens on Tuesday 1 September 2026, and it offers the way back to today
- **AND** moving it to the day before makes its day picker open on Monday 31 August 2026, which is
  the day it was handed, and makes it offer no way back

#### Scenario: a day screen moves onto a day that has not arrived and shows it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day after four times
- **THEN** its day view is the same day view as one formed directly of that commitment on Friday
  4 September 2026 from a history that has taken no tick
- **AND** its day picker opens on Friday 4 September 2026

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
handed, making the day being shown that today and forming the day view again on it, from the
commitments its roster answers with on that today and the record the screen holds. It SHALL read
neither the record nor the roster again, SHALL leave what the screen says about either of them
alone, and SHALL move the day being shown and never the today.

The day it goes back to SHALL be the today the screen was last handed, and this capability MUST NOT
read a clock to find it. Going back SHALL take no day from the caller and SHALL reach that today and
no other. A day screen already showing its today SHALL be left showing it.

#### Scenario: a day screen moved into the past goes back to today in one step

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day before three times; and it is then sent back to today
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** its day picker opens on Monday 31 August 2026, and it offers no way back to today

#### Scenario: a day screen moved into the future goes back to today in one step

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day after three times; and it is then sent back to today
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** its day picker opens on Monday 31 August 2026, and it offers no way back to today

#### Scenario: a day screen already showing today is left where it is when it is sent back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is sent back to today without having been moved
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** its day picker opens on Monday 31 August 2026, and it offers no way back to today

#### Scenario: a day screen goes back to the today it was last handed rather than the day it opened on

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; the app is then shown again as of Wednesday 2 September 2026; it is moved to the
  day before twice; and it is then sent back to today
- **THEN** its day picker opens on Wednesday 2 September 2026, and it offers no way back to today

#### Scenario: going back to today does not read the record again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before; a tick for that commitment on Monday 31 August 2026
  is then kept at that place by something else; and it is sent back to today
- **THEN** its day view says the commitment is not kept on Monday 31 August 2026
- **AND** it says it is keeping a record, exactly as it did before

### Requirement: A move with nowhere to go leaves a day screen exactly as it was

A day screen showing 1 January 1583 SHALL be left exactly as it is when moved to the day before, and
one showing 31 December 9999 SHALL be left exactly as it is when moved to the day after. Staying
SHALL be the whole of the answer: the screen SHALL go on showing the day it was showing, holding the
day view it was holding and saying what it was saying about its record, and it MUST NOT report that
the move had nowhere to go.

A day screen SHALL NOT say whether it can move either way. A caller MUST NOT stand a move down on
the strength of a day view a screen says on neither side, and asking for a move that has nowhere to
go SHALL go on being answered by this requirement. Being left as it was SHALL be about the calendar
and about nothing else, depending neither on which commitments the screen was handed, nor on what
its record holds, nor on whether its day view has any rows, nor on which day it was handed as today:
a screen at either end SHALL move normally the other way, and one showing any other date SHALL move
both ways.

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

### Requirement: A day screen holds the day view of the day it was handed, formed from the record kept at its place

A day screen SHALL be opened from four things: some commitments, the day it is being opened on, the
place its record is kept at and the place its roster is kept at. It SHALL hold the day view of that
day, of the commitments its roster answers with on it, formed from the history held at the record's
place, and SHALL give that day view back whole and unaltered. The commitments it is opened from
SHALL be the ones it takes on when its roster holds nothing at all, and SHALL NOT be a list it
draws.

The today SHALL be given to a day screen and never asked for, this capability reading no clock and
consulting no time zone or locale. A day screen SHALL hold two separate days: the today it was
handed, as of which every question it asks is asked, and the day it is showing, which SHALL begin as
that same today and SHALL be the one a move changes. A day screen MUST NOT keep only one of them. It
SHALL hold the day it is showing until it is moved, a day is picked, or the app is shown again, and
SHALL be moved onto another day by nothing else, neither by time passing nor by a tick made on it;
its today SHALL be replaced only when the app is shown again.

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

### Requirement: A day screen keeps its record at a place that survives the app being closed

A day screen SHALL name the place it keeps its record at, and MUST NOT leave that choice to whatever
draws it. The place SHALL be one whose contents survive the app being closed, being force-quit and
the device being restarted, and are carried in a backup of the device: it SHALL be inside the
directory the platform reserves for an application's own supporting data — `Application Support` —
within a directory belonging to this app, and it SHALL be one file. It MUST NOT be the caches
directory, and MUST NOT be the temporary directory. The place SHALL be the same place every time it
is asked for.

#### Scenario: the place a day screen keeps its record is under Application Support, in a directory of the app's own

- **WHEN** the place a day screen keeps its record at is asked for
- **THEN** it is inside the platform's application-support directory
- **AND** it is one file inside a directory of this app's own within it, rather than directly inside
  it

#### Scenario: the place a day screen keeps its record is neither the caches directory nor the temporary directory

- **WHEN** the place a day screen keeps its record at is asked for
- **THEN** it is not inside the platform's caches directory
- **AND** it is not inside the temporary directory

#### Scenario: the place a day screen keeps its record is the same place every time it is asked

- **WHEN** the place a day screen keeps its record at is asked for twice
- **THEN** the two are the same place

### Requirement: A day screen that cannot read its record draws the day and keeps nothing

Opening a day screen at a place holding something that cannot be read as a record SHALL give a day
screen rather than an error: it SHALL hold the day view of its day formed from a history that has
taken no tick, and SHALL say that it is not keeping a record. Such a screen SHALL take no tick — a
tick made on it MUST NOT be shown as kept, MUST NOT be held in memory to be kept later, and MUST NOT
be kept anywhere else — and SHALL leave what is at the place exactly as it was, not overwritten, not
moved, not emptied. Every way a store can refuse to open SHALL be answered in that one way.

A day screen that is not keeping a record SHALL say which of two things is so: that the record at
its place was written by a later version of DayByDay, or only that it could not be read. It MUST NOT
tell any other reason apart, and MUST NOT say a record was written by a later version when it was
refused for any other reason. A day screen that could read its record SHALL say that it is keeping
one.

#### Scenario: a day screen opened where the record cannot be read still holds the day view of that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday and a commitment named "Run" on a schedule listing Tuesday, Thursday and
  Sunday, both kept from 1 January 2026
- **THEN** its day view holds one row, for "Gym"
- **AND** that row says the commitment is not kept

#### Scenario: a day screen opened where the record cannot be read says it is not keeping one and gives no further reason

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026
- **THEN** it says it is not keeping a record
- **AND** it does not say the record was written by a later version of DayByDay

#### Scenario: a record written in a later form than this app knows makes a day screen that says the record is from a later version

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a record written
  in a form one later than the form this app writes, holding no ticks, of a commitment named "Gym"
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026
- **THEN** it says it is not keeping a record
- **AND** it says the record was written by a later version of DayByDay
- **AND** its day view holds one row, for "Gym", saying the commitment is not kept

#### Scenario: a day screen opened where the record can be read says it is keeping one

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026
- **THEN** it says it is keeping a record
- **AND** a day screen opened at a place where a tick has been kept says the same

#### Scenario: ticking a row on a day screen that is not keeping a record changes nothing and keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
- **THEN** its day view still says the commitment is not kept on that date
- **AND** it still says it is not keeping a record

#### Scenario: a day screen opened where the record cannot be read leaves what is at the place as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
- **THEN** the content at that place is byte-for-byte what it was before the screen was opened

#### Scenario: ticking a row on a day screen holding a record from a later version keeps nothing and leaves the record as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a record written
  in a form one later than the form this app writes, holding no ticks, of a commitment named "Gym"
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is
  ticked
- **THEN** its day view still says the commitment is not kept on that date
- **AND** it still says the record was written by a later version of DayByDay
- **AND** the content at that place is byte-for-byte what it was before the screen was opened

### Requirement: A day screen draws the commitments its roster had not stopped keeping on the day it is showing

A day screen SHALL form every day view from the commitments the roster at its roster place had not
stopped keeping on the day shown, in the roster's groups and order. Every day view SHALL ask the
roster again for the day then shown: when the screen is opened, moved, sent back to today, shown
again or returned to, and when a tick is made. The roster asked SHALL be the one read when the app
was last shown or the screen last returned to, whichever happened later, with any change kept since;
asking MUST NOT open the place. A commitment the roster stopped or removed SHALL have a row up to
and including the day it was kept until, and none after; a day screen MUST NOT tell the two apart in
any way: not in the row drawn, in what it says or offers, nor in its group. A group with nothing due
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

#### Scenario: a day screen draws a removed commitment on the day it was kept until and not on the day after it

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place, ticked on Sunday 30 August 2026, and removed as of
  that same day; and a day screen of no commitments at all is opened at that roster place as of
  Monday 31 August 2026, at the record place that tick was kept at
- **THEN** the day view it held when it was opened holds no rows, Monday 31 August 2026 being after
  the day the commitment was kept until
- **AND** after it is moved to the day before, its day view holds one row, named "Journaling", saying
  the commitment is kept on that date

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

### Requirement: A day screen takes on the commitments it was handed when its roster holds nothing at all

A day screen SHALL be handed some commitments and SHALL take them on, in the order handed, exactly
when the roster it has just read holds nothing at all. It SHALL keep them at its roster place before
drawing from them. A roster holding anything at all SHALL be left exactly as it is, and the
commitments handed in SHALL NOT be taken on again: a roster every one of whose commitments has been
stopped or removed still holds them, so it is not a roster holding nothing and MUST NOT be written
over.

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

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and removed as of Sunday 30 August 2026; and a day
  screen of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  that same day, is opened at that roster place as of Monday 31 August 2026, at a record place where
  nothing has been kept
- **THEN** its day view holds no rows
- **AND** a roster store opened afterwards at that roster place holds a roster that is the same
  roster as one given "Journaling" once and asked to remove it as of Sunday 30 August 2026
- **AND** "Gym" is not at that roster place

### Requirement: A day screen keeps its roster at its own place, beside its record

A day screen SHALL name the place it keeps its roster at, and MUST NOT leave that choice to whatever
draws it. The place SHALL be inside the directory the platform reserves for an application's own
supporting data — `Application Support` — within a directory belonging to this app, and it SHALL be
one file. Its contents SHALL survive the app being closed, being force-quit and the device being
restarted, and SHALL be carried in a backup of the device. It MUST NOT be the caches directory and
MUST NOT be the temporary directory. It SHALL be the same place every time it is asked for, and it
SHALL NOT be the place the day screen keeps its record at.

#### Scenario: the place a day screen keeps its roster is under Application Support, in a directory of the app's own

- **WHEN** the place a day screen keeps its roster at is asked for
- **THEN** it is inside the platform's application-support directory
- **AND** it is one file inside a directory of this app's own within it, rather than directly inside
  it

#### Scenario: the place a day screen keeps its roster is neither the caches directory nor the temporary directory

- **WHEN** the place a day screen keeps its roster at is asked for
- **THEN** it is not inside the platform's caches directory
- **AND** it is not inside the temporary directory

#### Scenario: the place a day screen keeps its roster is the same place every time it is asked

- **WHEN** the place a day screen keeps its roster at is asked for twice
- **THEN** the two are the same place

#### Scenario: the place a day screen keeps its roster is not the place it keeps its record

- **WHEN** the place a day screen keeps its roster at and the place it keeps its record at are both
  asked for
- **THEN** the two are different places

### Requirement: A day screen that cannot read its roster draws the day and no rows

A day screen opened where the roster cannot be read SHALL still be a day screen: it SHALL hold no
rows, SHALL say it is not keeping a roster, and SHALL leave the place exactly as it was, not written
over with the commitments it was handed. It SHALL say which of two things is so: the roster was
written by a later version of DayByDay, or it only could not be read. It MUST NOT tell another
reason apart or name a later version for any other refusal.

What a day screen says about its roster SHALL be read off the roster's place and what it says about
its record off the record's, neither off the other, and it may be keeping one and not the other. A
day screen that could read its roster SHALL say so; one that could not SHALL say its day just the
same.

#### Scenario: a day screen opened where the roster cannot be read holds no rows and says it is not keeping one

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a run of
  bytes that is not what a roster is written as, at a record place where nothing has been kept, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026
- **THEN** its day view holds no rows
- **AND** it says it is not keeping a roster
- **AND** it does not say the roster was written by a later version of DayByDay

#### Scenario: a roster written in a later form than this app knows makes a day screen that says the roster is from a later version

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a roster
  written in a form one later than the form this app writes, holding no commitments, at a record place
  where nothing has been kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026
- **THEN** it says it is not keeping a roster
- **AND** it says the roster was written by a later version of DayByDay
- **AND** its day view holds no rows

#### Scenario: a day screen opened where the roster can be read says it is keeping one

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place and a record place
  where nothing has been kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026
- **THEN** it says it is keeping a roster
- **AND** a day screen opened at a roster place where a commitment has already been taken on says the
  same

#### Scenario: a day screen that cannot read its roster still says the day and goes on keeping its record

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a run of
  bytes that is not what a roster is written as, at a record place where nothing has been kept, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026
- **THEN** it says the day is "Mon"
- **AND** it says it is keeping a record
- **AND** it says it is not keeping a roster

#### Scenario: a day screen that cannot read its record still draws the commitments its roster keeps

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and then one
  named "Journaling" on a schedule listing all seven weekdays, both kept from 1 January 2026, are
  taken on at a roster place; and a day screen of no commitments at all is opened at that roster place
  as of Monday 31 August 2026, at a record place holding a run of bytes that is not what a record is
  written as
- **THEN** its day view holds two rows, named "Gym" and then "Journaling", neither saying its
  commitment is kept
- **AND** it says it is not keeping a record
- **AND** it says it is keeping a roster

### Requirement: A row offers the number entry its commitment takes, and offers none for a day that has not arrived

A row asked as of a calendar date SHALL offer either exactly one number entry or nothing at all, and
the entry SHALL be for its commitment on the day view's date. It SHALL offer nothing when its
commitment's kind is not a number, and nothing when the day view's date is later than the day it is
asked as of, whatever that day already holds. It SHALL offer the entry for its own date and any
earlier one, however much earlier.

A row SHALL offer at most one of a tick, a number entry, a note entry and a total entry, and never
two; the kind its commitment declares decides which. Whether a row offers an entry SHALL NOT depend
on what the history says. The day a row is asked as of SHALL be given to it and MUST NOT be read
from a clock or a locale.

#### Scenario: a row offers the number entry for its commitment on the date the day view is of

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of
  Monday 31 August 2026
- **THEN** the day view holds one row named "Weight"
- **AND** that row offers a number entry

#### Scenario: a row for a commitment whose kind is not a number offers no number entry

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Gym" of the tick kind, one named "Journal" of the note kind and one named
  "Water" of the total kind with a target of 120, all three on a schedule listing Monday,
  Wednesday and Saturday and all kept from 1 January 2026, and each of its rows is asked as of
  Monday 31 August 2026
- **THEN** the day view holds three rows, named "Gym", "Journal" and "Water"
- **AND** none of them offers a number entry
- **AND** a row for a commitment alike in every way but of the number kind with no range, asked as
  of that same day, offers one

#### Scenario: a row offers a tick or a number entry and never both

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Gym" of the tick kind and a commitment named "Weight" of the number kind
  with a range of 40 to 150, both on a schedule listing Monday, Wednesday and Saturday and both
  kept from 1 January 2026, and both its rows are asked as of Monday 31 August 2026
- **THEN** the row named "Gym" offers a tick and no number entry
- **AND** the row named "Weight" offers a number entry and no tick
- **AND** a row for a commitment alike in every way but of the note kind, asked as of that same
  day, offers neither of them
- **AND** a row for one alike in every way but of the total kind with a target of 120 offers neither
  of them either

#### Scenario: a row for a date later than the day it is asked as of offers no number entry

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  record, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is
  asked as of Monday 31 August 2026
- **THEN** the day view holds one row named "Weight"
- **AND** that row offers no number entry
- **AND** it offers no tick either

#### Scenario: a row for a date later than the day it is asked as of offers no number entry even where the day holds a number

- **WHEN** a day view is formed on Wednesday 2 September 2026, of a commitment named "Weight" of
  the number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, from a history holding a number of 70.5 for that commitment on that
  date, and its one row is asked as of Monday 31 August 2026
- **THEN** that row says the commitment is kept
- **AND** it offers no number entry

#### Scenario: a row for a date earlier than the day it is asked as of offers the number entry

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of
  Saturday 5 September 2026
- **THEN** the row offers a number entry

#### Scenario: a row offers the number entry whether or not the day is already kept

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Weight"
  of the number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, the first from a history that has taken no record and the
  second from a history holding a number of 70.5 for that commitment on that date, and each one's
  row is asked as of that same day
- **THEN** the first row says the commitment is not kept and the second says it is
- **AND** both offer a number entry

### Requirement: A number entry says the range its commitment takes and the number the day already holds

A number entry SHALL say two things and no others: the number the history the day view was formed
from holds for that commitment on that date, or no number where it holds none; and the range the
commitment declares, said as a hint, or no hint where it declares none.

The hint SHALL be the lowest bound the commitment declares, an en dash, and the highest, and nothing
else — "40–150" for a range of 40 to 150 — in this package's own words and no locale's, each bound
said as it was given, with no digit added and none dropped. The number SHALL be the one the `record`
capability answers for that commitment on that date, MUST NOT be recomputed here, and SHALL be no
number where the history the entry is offered from has had it taken back. A row SHALL NOT say the
number itself.

#### Scenario: a number entry says the range its commitment declares as a hint

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Weight" of the number kind with a range of 40 to 150 and a commitment
  named "Mood" of the number kind with a range of 1 to 10, both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, and both its rows are asked as of that
  same day
- **THEN** the entry the first row offers says the hint "40–150"
- **AND** the entry the second row offers says the hint "1–10"
- **AND** the entry of a row for a commitment alike in every way but with a range of 40.5 to
  150.25 says the hint "40.5–150.25"

#### Scenario: a number entry of a commitment that declares no range says no hint

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Weight" of the number kind with no range, on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of that same day
- **THEN** the entry that row offers says no hint

#### Scenario: a number entry says the number the history holds for that commitment on that date

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Weight" of the
  number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, from a history holding a number of 70.5 for that commitment on that
  date, and its one row is asked as of that same day
- **THEN** the entry that row offers says the number 70.5
- **AND** it says 70.5 exactly, not 70 and not 71

#### Scenario: a number entry says no number where the day holds none

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Weight"
  of the number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, the first from a history that has taken no record and the
  second from a history a number of 70.5 for that commitment on that date was added to and then
  taken back from, and each one's row is asked as of that same day
- **THEN** the entry the first row offers says no number
- **AND** the entry the second row offers says no number

#### Scenario: a row for a number commitment holding a number says its name, its rhythm and that the day is kept

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Weight" of the
  number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, from a history holding a number of 70.5 for that commitment on that
  date
- **THEN** the day view holds one row named "Weight"
- **AND** that row says "Mon, Wed, Sat"
- **AND** it says the commitment is kept
- **AND** a row of a day view formed the same way but from a history holding a number of 71
  instead says all three of those things identically

### Requirement: A day screen reads what an entry is committed with as a number, as a take-back, or as neither

A day screen SHALL read what is committed in a number entry as exactly one of three things: a
number, a take-back, or a value that is not a number. It MUST NOT consult the device's locale,
region or keyboard. Blank space around what is committed SHALL be disregarded before it is read, and
SHALL mean whatever the `record` capability means by it, decided neither again here nor differently
for a note entry; a character of no width is not blank space.

What holds nothing once blank space is disregarded SHALL be a take-back, and nothing else SHALL be
one. It SHALL be a number when it holds, in this order and nothing else, an optional minus sign,
then digits and at most one decimal separator with at least one digit among them; the separator
SHALL be a full stop or a comma, read alike, and the number SHALL be exactly what those digits say.
Up to thirty-eight significant digits SHALL be kept, counted from the first digit that is not a zero
to the last that is not a zero; text saying more, or a number too large or too near zero to hold,
MUST NOT be rounded, shortened or fitted to what can be held. Everything else SHALL be a value that
is not a number: two separators, a separator with no digit beside it, a sign anywhere but the front,
an exponent, letters or spaces among the digits, a character of no width anywhere in it, a digit
that is not one of the ten this package reads, and digits saying a number that cannot be kept
exactly. Such a value SHALL keep nothing, take nothing back, and leave the day exactly as it was.

#### Scenario: a number typed with a full stop is entered exactly as it was typed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and "70.5" is committed on its one row
- **THEN** the entry the row the day screen then holds offers says the number 70.5
- **AND** committing "0.000001" and then "98765432109876543210.5" on that row leaves it saying
  each of those numbers in turn, digit for digit

#### Scenario: a number typed with a comma is entered as the same number as one typed with a full stop

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "70,5" is committed on its
  one row
- **THEN** the entry the row the day screen then holds offers says the number 70.5

#### Scenario: a number typed with leading zeros or a trailing separator is entered as the number it says

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and "0000070.50" is committed on its
  one row
- **THEN** the entry the row the day screen then holds offers says the number 70.5
- **AND** committing "70." on that row leaves it saying the number 70
- **AND** committing " 70.5 " on that row leaves it saying the number 70.5

#### Scenario: a negative number is entered where the commitment declares no range

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Balance" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and "-12.75" is committed on its one
  row
- **THEN** the entry the row the day screen then holds offers says the number -12.75
- **AND** the day view says the commitment is kept on that date

#### Scenario: an entry committed empty takes the number back, and one holding nothing but space does the same

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 and a
  commitment named "Mood" of the number kind with a range of 1 to 10, both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026; "70.5" is committed on the
  first row and "8" on the second; and then nothing at all is committed on the first row and two
  spaces on the second
- **THEN** the day screen's day view says neither commitment is kept on that date
- **AND** the entry each of its rows offers says no number

#### Scenario: an entry committed with line breaks alone takes the number back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one
  row; and a text of three line breaks is then committed on the row it then holds
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** the entry its row offers says no number
- **AND** the day screen tells nothing on any row
- **AND** committing "70.5" again and then a text of one tab followed by one line break leaves it
  saying no number too
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: an entry committed with a zero-width space alone keeps nothing and takes nothing back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one
  row; and a text of one zero-width space is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers says the number 70.5
- **AND** the day view says the commitment is kept on that date
- **AND** the day screen tells, on that row, that it is not a number
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a value that is not a number keeps nothing and takes nothing back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one row;
  and each of "1.2.3", ".", "-", "12abc", "1e3", "7-0" and "٧٠" is then committed in turn on the
  row it then holds
- **THEN** the entry the row the day screen then holds offers says the number 70.5 after every one
  of them
- **AND** the day view says the commitment is kept on that date
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a number of as many digits as can be kept is entered exactly

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and a whole number of thirty-eight
  nines is committed on its one row
- **THEN** the entry the row the day screen then holds offers says that number, digit for digit
- **AND** the day view says the commitment is kept on that date
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a number too long to be kept exactly keeps nothing and takes nothing back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one row; and
  a whole number of thirty-nine nines, a whole number of two hundred ones, and a number whose only
  digit that is not a zero is at the hundred-and-twenty-ninth place after the point are each then
  committed in turn on the row it then holds
- **THEN** the entry the row the day screen then holds offers says the number 70.5 after every one
  of them
- **AND** the day screen tells, on that row, that it is not a number
- **AND** the day view says the commitment is kept on that date
- **AND** a day screen opened afterwards at the same place as of the same day says the same

### Requirement: A row offers the note entry its commitment takes, and offers none for a day that has not arrived

A row asked as of a calendar date SHALL offer either exactly one note entry or nothing at all, and
the entry SHALL be for its commitment on the day view's date. It SHALL offer nothing when its
commitment's kind is not a note, and nothing when the day view's date is later than the day it is
asked as of, whatever that day already holds. It SHALL offer the entry for its own date and any
earlier one, however much earlier.

A row offers at most one of a tick, a number entry, a note entry and a total entry, as the
requirement on the number entry a row offers states. Whether a row offers an entry SHALL NOT depend
on what the history says. The day a row is asked as of SHALL be given to it and MUST NOT be read
from a clock or a locale.

#### Scenario: a row offers the note entry for its commitment on the date the day view is of

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and its one row is asked as of Monday 31 August 2026
- **THEN** the day view holds one row named "Journal"
- **AND** that row offers a note entry

#### Scenario: a row for a commitment whose kind is not a note offers no note entry

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Gym" of the tick kind, one named "Weight" of the number kind with a range
  of 40 to 150 and one named "Water" of the total kind with a target of 120, all three on a schedule
  listing Monday, Wednesday and Saturday and all kept from 1 January 2026, and each of its rows is
  asked as of Monday 31 August 2026
- **THEN** the day view holds three rows, named "Gym", "Weight" and "Water"
- **AND** none of them offers a note entry
- **AND** a row for a commitment alike in every way but of the note kind, asked as of that same day,
  offers one

#### Scenario: a row offers a tick, a number entry or a note entry and never two of them

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Gym" of the tick kind, a commitment named "Weight" of the number kind with
  a range of 40 to 150 and a commitment named "Journal" of the note kind, all on a schedule listing
  Monday, Wednesday and Saturday and all kept from 1 January 2026, and all three of its rows are
  asked as of Monday 31 August 2026
- **THEN** the row named "Gym" offers a tick and neither a number entry nor a note entry
- **AND** the row named "Weight" offers a number entry and neither a tick nor a note entry
- **AND** the row named "Journal" offers a note entry and neither a tick nor a number entry
- **AND** a row for a commitment alike in every way but of the total kind with a target of 120,
  asked as of that same day, offers none of those three

#### Scenario: a row for a date later than the day it is asked as of offers no note entry

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  record, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, and its one row is asked as of Monday 31 August 2026
- **THEN** the day view holds one row named "Journal"
- **AND** that row offers no note entry
- **AND** it offers neither a tick nor a number entry either

#### Scenario: a row for a date later than the day it is asked as of offers no note entry even where the day holds a note

- **WHEN** a day view is formed on Wednesday 2 September 2026, of a commitment named "Journal" of
  the note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026,
  from a history holding a note of "Ran 8k." for that commitment on that date, and its one row is
  asked as of Monday 31 August 2026
- **THEN** that row says the commitment is kept
- **AND** it offers no note entry

#### Scenario: a row for a date earlier than the day it is asked as of offers the note entry

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and its one row is asked as of Saturday 5 September 2026
- **THEN** the row offers a note entry

#### Scenario: a row offers the note entry whether or not the day is already kept

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Journal"
  of the note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026,
  the first from a history that has taken no record and the second from a history holding a note of
  "Ran 8k." for that commitment on that date, and each one's row is asked as of that same day
- **THEN** the first row says the commitment is not kept and the second says it is
- **AND** both offer a note entry

### Requirement: A day screen reads what is committed in a note entry as a note or as a take-back

A day screen SHALL read what is committed in a note entry as exactly one of two things: a note, or a
take-back. It SHALL be a take-back when it says nothing — the empty text, and any text made only of
blank space — and a note otherwise. Blank space SHALL mean whatever the `record` capability means by
it, and this capability SHALL NOT decide it a second time: spaces, tabs and line breaks alike.

Blank space at the start and end of what is committed SHALL be disregarded before the note is
formed, and everything between the first and last character that is not blank space SHALL be kept
exactly as written, line breaks, tabs and runs of spaces among them. This reading SHALL NOT be the
number entry's, and neither SHALL be applied to the other; what the two share is what counts as
blank space.

#### Scenario: a note committed with space around it is kept without that space and unchanged within it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, and a text of two spaces, then "Ran 8k.", then a line
  break, then "Knee held up.", then a line break and two spaces, is committed on its one row
- **THEN** the entry the row the day screen then holds offers says "Ran 8k." then a line break then
  "Knee held up.", and nothing else
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a note committed with space inside it keeps every character of that space

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, and the text "Monday" followed by two line breaks, three
  spaces, a tab and "Tuesday" is committed on its one row
- **THEN** the entry the row the day screen then holds offers says exactly that text, character for
  character

#### Scenario: an entry committed empty takes the note back, and one holding nothing but blank space does the same

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind and a commitment named "Sleep" of the note
  kind, both on a schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026;
  "Ran 8k." is committed on the first row and "Slept badly." on the second; and then nothing at all
  is committed on the first row and two spaces on the second
- **THEN** the day screen's day view says neither commitment is kept on that date
- **AND** the entry each of its rows offers says no note

#### Scenario: an entry committed with line breaks alone takes the note back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026; "Ran 8k." is committed on its one row; and a text of three
  line breaks is then committed on the row it then holds
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** the entry its row offers says no note
- **AND** committing "Ran 8k." again and then a text of one tab followed by one line break leaves it
  saying no note too
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a note of one visible character among blank space is written rather than taken back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, and a text of a line break, two spaces, a full stop, a tab
  and a line break is committed on its one row
- **THEN** the day screen's day view says the commitment is kept on that date
- **AND** the entry its row offers says the note "."

#### Scenario: a note of any length, any script and any number of lines is entered whole

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, and each of a text of a hundred thousand characters, the
  text "שלום עולם", a text of one emoji and a text of twenty lines is committed in turn on the row
  the screen then holds
- **THEN** the entry the row offers says each of them in turn, character for character
- **AND** the day view says the commitment is kept on that date after every one of them
- **AND** a day screen opened afterwards at the same place as of the same day says the same

### Requirement: A row offers the total entry its commitment takes, and offers none for a day that has not arrived

A row SHALL offer, when asked as of a calendar date, either one total entry or nothing at all, and
that entry SHALL be the one for its commitment on the date its day view is of. The row SHALL offer
nothing where its commitment's kind is not a total, and nothing where its day view's date is later
than the day it is asked as of, whatever additions that day holds. Where neither holds it SHALL
offer the entry, on its own date and on any earlier one. Whether it offers one SHALL NOT depend on
the history. A row SHALL offer at most one entry kind, as *A row offers the number entry its
commitment takes, and offers none for a day that has not arrived* requires. The day it is asked as
of SHALL be given to it and MUST NOT be read from a clock.

#### Scenario: a row offers the total entry for its commitment on the date the day view is of

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of Monday
  31 August 2026
- **THEN** the day view holds one row named "Protein"
- **AND** that row offers a total entry

#### Scenario: a row for a commitment whose kind is not a total offers no total entry

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Gym" of the tick kind, one named "Weight" of the number kind with a range
  of 40 to 150 and one named "Journal" of the note kind, all three on a schedule listing Monday,
  Wednesday and Saturday and all kept from 1 January 2026, and each of its rows is asked as of Monday
  31 August 2026
- **THEN** the day view holds three rows, named "Gym", "Weight" and "Journal"
- **AND** none of them offers a total entry
- **AND** a row for a commitment alike in every way but of the total kind with a target of 120, asked
  as of that same day, offers one

#### Scenario: a row offers a tick, a number entry, a note entry or a total entry and never two of them

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Gym" of the tick kind, one named "Weight" of the number kind with a range
  of 40 to 150, one named "Journal" of the note kind and one named "Protein" of the total kind with
  a target of 120, all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, and all four of its rows are asked as of Monday 31 August 2026
- **THEN** the row named "Gym" offers a tick and none of the three entries
- **AND** the row named "Weight" offers a number entry and nothing else of the four
- **AND** the row named "Journal" offers a note entry and nothing else of the four
- **AND** the row named "Protein" offers a total entry and nothing else of the four

#### Scenario: a row for a date later than the day it is asked as of offers no total entry

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  record, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of
  Monday 31 August 2026
- **THEN** the day view holds one row named "Protein"
- **AND** that row offers no total entry
- **AND** it offers no tick, no number entry and no note entry either

#### Scenario: a row for a date later than the day it is asked as of offers no total entry even where the day holds additions

- **WHEN** a day view is formed on Wednesday 2 September 2026, of a commitment named "Protein" of
  the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, from a history holding additions of 30 and 90 for that commitment on that
  date, and its one row is asked as of Monday 31 August 2026
- **THEN** that row says the commitment is kept
- **AND** it offers no total entry

#### Scenario: a row for a date earlier than the day it is asked as of offers the total entry

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of Saturday
  5 September 2026
- **THEN** the row offers a total entry

#### Scenario: a row offers the total entry whether or not the day is already kept

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, the first from a history holding an addition of 30 for that commitment on that
  date and the second from a history holding one of 120, and each one's row is asked as of that same
  day
- **THEN** the first row says the commitment is not kept and the second says it is
- **AND** both offer a total entry

### Requirement: A total entry says the day's sum and the commitment's target, and says nothing else

A total entry SHALL say exactly one thing: the day's sum and the commitment's target, as the one
phrase `<sum> of <target>`. The sum SHALL be the one the `record` capability answers for that
commitment on that date, and MUST NOT be recomputed here; a day that holds no addition SHALL say a
sum of zero. The target SHALL be said as the commitment declared it, with no digit added and none
dropped, and the sum SHALL be said the same way. A total entry SHALL say the true sum whether or not
the sum has passed the target. The words SHALL be this package's own English and no locale's. A
total entry SHALL say no hint. Its field is not prefilled, and this capability SHALL NOT say a value
for one to be prefilled from. A row SHALL NOT say the sum itself.

#### Scenario: a total entry says the day's sum and the commitment's target

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, from a history holding additions of 30 and 45.5 for that commitment on that date,
  and its one row is asked as of that same day
- **THEN** the entry that row offers says "75.5 of 120"
- **AND** the entry of a row for a commitment alike in every way but with a target of 0.5, asked as
  of that same day, says "75.5 of 0.5"

#### Scenario: a total entry of a day holding no addition says a sum of zero

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, the first from a history that has taken no record and the second from a
  history an addition of 30 for that commitment on that date was added to and then taken back from,
  and each one's row is asked as of that same day
- **THEN** the entry the first row offers says "0 of 120"
- **AND** the entry the second row offers says "0 of 120"

#### Scenario: a total entry says the true sum once it has passed the target

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, from a history holding additions of 120 and 30 for that commitment on that date,
  and its one row is asked as of that same day
- **THEN** the entry that row offers says "150 of 120"
- **AND** that row says the commitment is kept

#### Scenario: a row for a total commitment says its name, its rhythm and whether the day is kept, and never its sum

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, from a history holding an addition of 30 for that commitment on that date
- **THEN** the day view holds one row named "Protein"
- **AND** that row says "Mon, Wed, Sat"
- **AND** it says the commitment is not kept
- **AND** a row of a day view formed the same way but from a history holding an addition of 90
  instead says all three of those things identically

### Requirement: A row offers taking back its day's last addition, and offers none where the day holds none

A row SHALL offer, when asked as of a calendar date, taking its day's last addition back, exactly
where two things hold: it offers a total entry as of that day, and the day it is for holds at least
one addition. Where either fails it SHALL offer no such thing. The take-back SHALL be a second thing
the row offers, beside the entry, and MUST NOT be the entry's own gesture. Whether the day holds an
addition SHALL be read off the day's sum being above zero, and this capability SHALL NOT ask for the
additions themselves. A row that offers no take-back MUST NOT be hidden, MUST NOT be drawn as kept,
and MUST NOT be given some other act in its place; it offers a total entry like every other total
row and says its name, its rhythm and whether the day is kept.

#### Scenario: a row whose day holds an addition offers taking the last one back

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, from a history holding an addition of 30 for that commitment on that date, and its
  one row is asked as of that same day
- **THEN** that row offers taking its day's last addition back
- **AND** a row of a day view formed the same way but from a history holding additions of 120 and 30
  offers it too, though that day is kept and past its target

#### Scenario: a row whose day holds no addition offers no take-back

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, the first from a history that has taken no record and the second from a
  history an addition of 30 for that commitment on that date was added to and then taken back from,
  and each one's row is asked as of that same day
- **THEN** neither row offers taking its day's last addition back
- **AND** both offer a total entry

#### Scenario: a row for a commitment whose kind is not a total offers no take-back

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" of the tick
  kind, one named "Weight" of the number kind with a range of 40 to 150 and one named "Journal" of
  the note kind, all three on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, from a history holding a tick for "Gym", a number of 70.5 for "Weight" and a note
  holding "Ran 8k." for "Journal", all on that date, and each of its rows is asked as of that same
  day
- **THEN** none of the three rows offers taking its day's last addition back

#### Scenario: a row for a date later than the day it is asked as of offers no take-back

- **WHEN** a day view is formed on Wednesday 2 September 2026, of a commitment named "Protein" of
  the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, from a history holding an addition of 30 for that commitment on that date,
  and its one row is asked as of Monday 31 August 2026
- **THEN** that row offers no take-back
- **AND** the same row asked as of Wednesday 2 September 2026 offers one

#### Scenario: a row goes on offering the take-back while the day still holds an addition

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, from a history holding additions of 30 and 90 for that commitment on that date;
  that day's last addition is taken back from that history; and a day view is formed again from the
  history as it now stands
- **THEN** the row of the day view formed again offers taking its day's last addition back
- **AND** its entry says "30 of 120"
- **AND** a day view formed again after that day's last addition is taken back once more offers no
  take-back, and its entry says "0 of 120"

### Requirement: A day screen reads what is committed in a total entry as an amount to add, as nothing at all, or as a value it refuses

A day screen SHALL read what is committed in a total entry as one of three things, none a take-back:
an amount to add, nothing, or a value it refuses. A commit saying nothing — empty text, or blank
space only — SHALL keep nothing, refuse nothing and be told of nothing. Blank space SHALL mean what
`record` means by it and SHALL be disregarded at both ends; what is left SHALL be read as a decimal
number exactly as a number entry's commit is read. Any other commit SHALL be refused, keep nothing,
and be told on the row: "Not a number" where what is left does not read as one, "Must be more than
0" where it is not above zero, and "Too large to add" where it would take the day's sum, as
arithmetic gives it, past thirty-eight significant digits. No further cause SHALL be named.

#### Scenario: an amount committed with space around it is added

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and a text of two spaces, then
  "30", then a line break, is committed on its one row
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** the day screen tells nothing on any row

#### Scenario: an amount typed with a comma is added as the same amount as one typed with a full stop

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "45,5" is committed on its
  one row
- **THEN** the entry the row the day screen then holds offers says "45.5 of 120"
- **AND** committing "0000030.50" on the row it then holds leaves it saying "76 of 120"

#### Scenario: an amount of zero or below is refused and told on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" is committed on its one
  row; and "0" is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers still says "30 of 120"
- **AND** the day screen tells, on that row, that it must be more than 0
- **AND** committing "-30" and then "-0.000001" on the row leaves it saying "30 of 120" and telling
  the same thing each time
- **AND** a day screen opened afterwards at the same place as of the same day says "30 of 120"

#### Scenario: a value that is not a number committed in a total entry is refused and told on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" is committed on its one
  row; and each of "1.2.3", ".", "-", "12abc", "1e3" and a text of one zero-width space is then
  committed in turn on the row it then holds
- **THEN** the entry the row the day screen then holds offers says "30 of 120" after every one of
  them
- **AND** the day screen tells, on that row, that it is not a number
- **AND** a day screen opened afterwards at the same place as of the same day says "30 of 120"

#### Scenario: an amount that would take the day's sum past what can be kept exactly is refused and told on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; a whole number of thirty-eight
  nines is committed on its one row; and "0.5" is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers says the day's sum as that whole number
  of thirty-eight nines, of 120
- **AND** the day screen tells, on that row, that it is too large to add
- **AND** a day screen opened afterwards at the same place as of the same day says the same sum

#### Scenario: an amount that takes the day's sum to a number that can be kept exactly is added

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; a whole number of thirty-eight
  nines is committed on its one row; and "1" is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers says a sum of 1 followed by
  thirty-eight zeros, of 120
- **AND** the day screen tells nothing on any row
- **AND** committing "0.5" on the row it then holds tells, on that row, that it is too large to add,
  and leaves the sum as it was

#### Scenario: a commit saying nothing in a total entry changes nothing and tells nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" is committed on its one
  row; "0" is then committed on the row it then holds; and nothing at all is then committed on the
  row it then holds
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** the day screen still tells, on that row, that it must be more than 0
- **AND** committing a text of one tab followed by one line break leaves it saying and telling the
  same

### Requirement: A day screen takes back the last addition a row offers, and keeps it before the day view says so

A day screen SHALL take back, on one of its rows, the last addition that day holds, and SHALL keep
the change before its day view says so. It SHALL take back exactly one addition each time it is
asked, SHALL leave every earlier addition standing in the order they were made, and SHALL offer no
act that clears a day. It SHALL change nothing — nothing kept, nothing shown, nothing told — on a
row the screen's day view does not hold, on a row that offers no take-back, or on a screen that is
not keeping a record. The day view SHALL then be formed again. A change that could not be kept SHALL
be refused, reported to the caller, told on the row naming no cause, and SHALL leave the day view as
it was. A take-back SHALL reach the record's place and nothing else.

#### Scenario: taking back the last addition on a row leaves the day short by exactly that amount

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" and then "90" are committed
  on the row it holds each time; and that row's last addition is then taken back
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** the day view says the commitment is not kept on that date

#### Scenario: taking back the last addition twice removes the two most recent

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30", then "45", then "50" are
  committed on the row it holds each time; and the last addition of the row it then holds is taken
  back twice
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** that row still offers taking its day's last addition back
- **AND** taking it back once more leaves the entry saying "0 of 120" and the row offering no
  take-back

#### Scenario: a take-back is held by a day screen opened afterwards at the same place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" and then "90" are committed
  on the row it holds each time; that row's last addition is taken back; and a second day screen of
  the same commitment is then opened at the same place as of the same day
- **THEN** the second day screen's day view says the commitment is not kept on that date
- **AND** the entry its one row offers says "30 of 120"

#### Scenario: a take-back that cannot be kept is refused and leaves the day view as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from but
  not written to and that holds a record in which a commitment named "Protein" of the total kind
  with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, has added 30 and 90 on that date, and that row's last addition is taken back
- **THEN** taking back is refused with an error
- **AND** the entry the row the day screen then holds offers still says "120 of 120"
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** what it tells names no cause

#### Scenario: taking back on a row that offers no take-back changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind and a commitment named "Protein" of the total
  kind with a target of 120, both on a schedule listing Monday, Wednesday and Saturday and both kept
  from 1 January 2026, and the last addition is taken back on each of its two rows in turn
- **THEN** the day screen's day view says neither commitment is kept on that date
- **AND** the entry the second row offers says "0 of 120"
- **AND** the day screen tells nothing on any row

#### Scenario: taking back on a row for a day that has not arrived changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing all seven weekdays, kept from 1 January 2026; "30" is committed on its one row; the screen
  is moved to the day after; and the last addition is taken back on the row it then holds
- **THEN** a day screen opened afterwards at that place as of Monday 31 August 2026 says "30 of 120"
- **AND** the day screen tells nothing on any row

#### Scenario: taking back on a row the day screen's day view does not hold changes nothing

- **WHEN** two day screens of a commitment named "Protein" of the total kind with a target of 120,
  on a schedule listing all seven weekdays, kept from 1 January 2026, are opened at one place where
  nothing has been kept, the first as of Monday 31 August 2026 and the second as of Tuesday
  1 September 2026; "30" is committed on each screen's own row; and the second screen's row is then
  taken back on the first screen
- **THEN** a day screen opened afterwards at that place as of Tuesday 1 September 2026 says "30 of
  120"

#### Scenario: taking back on a day screen that is not keeping a record changes nothing and keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and
  the last addition is taken back on its one row
- **THEN** it says it is not keeping a record
- **AND** the day screen tells nothing on any row
- **AND** the content at that place is byte-for-byte what it was before the screen was opened

#### Scenario: taking back writes nothing to the roster's place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place and a roster place
  where nothing has been kept, of a commitment named "Protein" of the total kind with a target of
  120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" is
  committed on its one row; the roster place is read; and that row's last addition is then taken
  back
- **THEN** the content at the roster place is byte-for-byte what it was before the take-back
- **AND** the day screen says it is keeping its roster

### Requirement: A day view draws its rows in the groups it was handed, and draws no group with nothing due

A day view SHALL be handed its commitments in groups — a category, or none, with its commitments —
and SHALL hold one for each group handed with something due on its date, in the order handed, each
holding its due commitments' rows in that order. Its rows SHALL be every row its groups hold, in the
order drawn, and a row in a group SHALL say what one under no category says. A day view SHALL sort
neither the groups nor within one, SHALL NOT decide where commitments under no category go, and
SHALL NOT combine two groups under one category. A group with nothing due SHALL NOT be drawn, and
one handed only such groups SHALL hold no groups and no rows. A day view MAY be handed no grouping,
and SHALL then hold one group with no category, or none where none is due.

#### Scenario: a day view holds one group for each group it was handed that has something due

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a group under "Supplements" holding a commitment named "Creatine" and then one named "Magnesium",
  then a group under "Sport" holding one named "Gym", then a group with no category holding one
  named "Journaling", all four on a schedule listing all seven weekdays and all kept from
  1 January 2026
- **THEN** the day view holds three groups, under "Supplements", then "Sport", then no category
- **AND** its rows, read across its groups, are named "Creatine", "Magnesium", "Gym" and then
  "Journaling", in that order

#### Scenario: a day view draws no group whose commitments are none of them due on the date

- **WHEN** a day view is formed on Tuesday 1 September 2026, from a history that has taken no tick,
  of a group under "Money" holding a commitment named "Finances" on a schedule on the 25th of the
  month, then a group under "Sport" holding one named "Gym" on a schedule listing all seven
  weekdays, both kept from 1 January 2026
- **THEN** the day view holds one group, under "Sport", holding one row named "Gym"
- **AND** no group is drawn under "Money"

#### Scenario: a day view handed only groups with nothing due holds no groups at all

- **WHEN** a day view is formed on Tuesday 1 September 2026, from a history that has taken no tick,
  of a group under "Money" holding a commitment named "Finances" on a schedule on the 25th of the
  month, kept from 1 January 2026
- **THEN** the day view holds no groups and no rows
- **AND** it is the same day view as one formed on that date, from that same history, of no
  commitments at all

#### Scenario: a day view drops the commitments that are not due and keeps the group its due ones are in

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a group under "Supplements" holding a commitment named "Creatine" on a schedule listing all seven
  weekdays and then one named "Vitamin D" on a schedule on the 25th of the month, both kept from
  1 January 2026
- **THEN** the day view holds one group, under "Supplements", holding one row named "Creatine"

#### Scenario: a day view handed commitments with no grouping holds one group with no category

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, then one named
  "Run" on a schedule listing Monday and Thursday, both kept from 1 January 2026, handed over with
  no grouping at all
- **THEN** the day view holds one group, with no category, holding rows named "Gym" and then "Run"
- **AND** it is the same day view as one formed on that date, from that same history, of one group
  with no category holding those same two commitments in that same order

#### Scenario: a day view does not combine two groups under the same category

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a group under "Supplements" holding a commitment named "Creatine", then a group under "Sport"
  holding one named "Gym", then a second group under "Supplements" holding one named "Magnesium",
  all three on a schedule listing all seven weekdays and all kept from 1 January 2026
- **THEN** the day view holds three groups, under "Supplements", then "Sport", then "Supplements"
- **AND** its rows, read across its groups, are named "Creatine", "Gym" and then "Magnesium"

#### Scenario: a row in a group says whether its commitment is kept, exactly as a row under no category does

- **WHEN** a day view is formed on Monday 31 August 2026, of a group under "Supplements" holding a
  commitment named "Creatine" and then one named "Magnesium", both on a schedule listing all seven
  weekdays and both kept from 1 January 2026, from a history holding a tick for "Magnesium" on that
  date
- **THEN** the day view holds one group, under "Supplements", holding two rows named "Creatine" and
  then "Magnesium"
- **AND** only the second row says its commitment is kept

### Requirement: A row says whether it offers anything at all

A row SHALL say, when asked as of a calendar date, whether it offers anything at all: it SHALL say
it offers something where it offers, as of that day, a tick, a number entry, a note entry or a total
entry, and nothing where it offers none of the four. The answer SHALL be read off those offers and
MUST NOT be worked out from the date. The take-back a total row offers SHALL NOT widen the answer.
The answer SHALL say whether there is something to offer and never which thing. The day it is asked
as of SHALL be given to it and MUST NOT be read from a clock. A row that offers nothing SHALL be a
row like every other: it MUST NOT be hidden, MUST NOT be drawn as kept, and MUST NOT be given some
other act in its place.

#### Scenario: a row of every kind offers something on a day that has arrived

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" of the tick
  kind, one named "Weight" of the number kind with a range of 40 to 150, one named "Journal" of the
  note kind and one named "Protein" of the total kind with a target of 120, all four on a schedule
  listing Monday, Wednesday and Saturday and all kept from 1 January 2026, from a history that has
  taken no record, and every one of its rows is asked as of that same day
- **THEN** the day view holds four rows, named "Gym", "Weight", "Journal" and then "Protein"
- **AND** every one of them says it offers something

#### Scenario: no row of a day view whose date has not arrived offers anything

- **WHEN** a day view is formed on Wednesday 2 September 2026, of a commitment named "Gym" of the
  tick kind, one named "Weight" of the number kind with a range of 40 to 150, one named "Journal" of
  the note kind and one named "Protein" of the total kind with a target of 120, all four on a
  schedule listing all seven weekdays and all kept from 1 January 2026, from a history that has taken
  no record, and every one of its rows is asked as of Monday 31 August 2026
- **THEN** the day view holds four rows, named "Gym", "Weight", "Journal" and then "Protein"
- **AND** none of them says it offers anything

#### Scenario: a row for a date earlier than the day it is asked as of offers something

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, and its one row is asked as of Saturday 5 September 2026
- **THEN** that row says it offers something
- **AND** it offers the tick for that commitment on Monday 31 August 2026

#### Scenario: a row's answer about offering anything follows the day it is asked as of

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  record, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026, and its one row is asked twice — once as of
  Tuesday 1 September 2026 and once as of Wednesday 2 September 2026
- **THEN** the first asking says the row offers nothing
- **AND** the second says it offers something

#### Scenario: a row offers something whether or not its day says the commitment is kept

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, the first from a history
  that has taken no tick and the second from a history holding a tick for that commitment on that
  date, and each one's row is asked as of that same day
- **THEN** the first row says the commitment is not kept and the second says it is
- **AND** both say they offer something

#### Scenario: a total row whose day holds no addition offers something

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein" of
  the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, the first from a history that has taken no record and the second from a
  history holding an addition of 30 for that commitment on that date, and each one's row is asked as
  of that same day
- **THEN** the first row offers no take-back and the second offers one
- **AND** both say they offer something

#### Scenario: a row offers something on its own date in the first supported year and in the last

- **WHEN** a day view is formed on Monday 3 January 1583, from a history that has taken no record, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  1583, and its one row is asked as of Monday 3 January 1583
- **THEN** that row says it offers something
- **AND** the row of a day view of the same commitment and history on Monday 27 December 9999, asked
  as of Monday 27 December 9999, says it offers something
- **AND** that same row, asked as of Monday 3 January 1583, says it offers nothing

### Requirement: A day screen shows a day picked on its day picker

A day screen SHALL show the calendar date it is given where it is not earlier than the earliest day
its day picker reaches, that earliest day included, and SHALL otherwise leave the screen as it was,
clamping to no day. Showing a picked day SHALL give what a move gives: the day view formed for the
day landed on, from the commitments its roster had not stopped keeping there and the record held. It
SHALL NOT read the record or the roster again, and SHALL leave what it says of either as it was. The
today SHALL NOT move, and every question asked as of that today SHALL still be, the way back to
today included. A pick that leaves the day being shown unchanged SHALL change nothing. Showing a
picked day SHALL be asked of the screen and handed one thing, the day to show.

#### Scenario: a day screen shows a day picked between the earliest day its picker reaches and the day it was showing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and one
  named "Journaling" on a schedule listing all seven weekdays, in that order and both kept from
  1 January 2026; and Monday 15 June 2026 is picked
- **THEN** its day view is the same day view as one formed directly of those two commitments, in
  that order, on Monday 15 June 2026, from a history that has taken no tick
- **AND** its day picker opens on Monday 15 June 2026

#### Scenario: a day screen shows a day picked after the today it was handed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; and Friday 25 December 2026 is picked
- **THEN** its day picker opens on Friday 25 December 2026
- **AND** a second day screen opened the same way, on which Friday 31 December 9999 is picked, has
  its day picker open on Friday 31 December 9999

#### Scenario: a day screen shows the earliest day its day picker reaches when that day is picked

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; and Thursday 1 January 2026, the earliest day its day picker reaches, is picked
- **THEN** its day picker opens on Thursday 1 January 2026 and reaches back to Thursday 1 January
  2026

#### Scenario: a day screen is left exactly as it was by a day picked earlier than its day picker reaches

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; and Wednesday 31 December 2025 is picked
- **THEN** it offers no way back to today
- **AND** its day view is the same day view as the one it held before that day was picked, and is
  not the day view of Thursday 1 January 2026
- **AND** its day picker still opens on Monday 31 August 2026 and reaches back to 1 January 2026

#### Scenario: a day screen picking the day it is already showing changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place that can be read
  from but not written to and where nothing has been kept, of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked
  and refused; and Monday 31 August 2026 is picked
- **THEN** its day picker still opens on Monday 31 August 2026, and it offers no way back to today
- **AND** it is still telling on that row that the change could not be kept
- **AND** its day view is the same day view as the one it held before that day was picked

#### Scenario: a day screen picking a day draws the commitments its roster had not stopped keeping on that day

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all
  seven weekdays and both kept from 1 January 2026, are taken on at a roster place in that order;
  "Gym" is stopped there as of Monday 15 June 2026; and a day screen of no commitments at all is
  opened at that roster place as of Monday 31 August 2026, at a record place where nothing has been
  kept
- **THEN** picking Wednesday 10 June 2026 gives a day view holding two rows, named "Gym" and then
  "Journaling"
- **AND** picking Saturday 20 June 2026 from there gives a day view holding one row, named
  "Journaling"

#### Scenario: picking a day on a day screen does not read its roster or its record again

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; a
  commitment named "Gym" on that same schedule and kept from that same day is then taken on at that
  roster place by something else, and a tick for "Journaling" on Monday 15 June 2026 is kept at
  that record place by something else; and Monday 15 June 2026 is picked
- **THEN** its day view holds one row, named "Journaling"
- **AND** that row says the commitment is not kept on Monday 15 June 2026
- **AND** it says it is keeping a record and a roster, exactly as it did before that day was picked

#### Scenario: picking a day on a day screen does not change the today it was handed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; and Monday 15 June 2026 is picked
- **THEN** its day picker opens on Monday 15 June 2026, and it offers the way back to today
- **AND** sent back to today, its day picker opens on Monday 31 August 2026 and it offers no way
  back

#### Scenario: a day screen stops telling what it was telling on a row when a picked day changes the day it is showing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place that can be read
  from but not written to and where nothing has been kept, of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked
  and refused; and Monday 15 June 2026 is picked
- **THEN** it tells nothing on any row
- **AND** its day picker opens on Monday 15 June 2026

#### Scenario: a day screen goes on telling what it was telling on a row when a picked day is earlier than its day picker reaches

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place that can be read
  from but not written to and where nothing has been kept, of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked
  and refused; and Wednesday 31 December 2025 is picked
- **THEN** it is still telling on that row that the change could not be kept
- **AND** its day picker still opens on Monday 31 August 2026

#### Scenario: a day screen offers the way back to today once a day other than that today is picked

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and Monday 15 June 2026 is picked
- **THEN** it offers the way back to today
- **AND** picking Monday 31 August 2026 from there, it offers no way back to today
- **AND** a screen on which Wednesday 31 December 2025 is picked instead offers no way back to
  today, that day never having been shown

### Requirement: A day screen says no day view before the first supported date and none after the last

A day screen showing 1 January 1583 SHALL say no day view of the day before it, and one showing 31
December 9999 SHALL say none of the day after it; the absence is the whole of the answer. The
absence SHALL be about the calendar and about nothing else: a screen showing either end SHALL go on
saying the day view on its other side, and a screen showing any other date SHALL say one on both
sides, whatever its roster holds, whatever its record holds, whether its day view has any rows, and
whichever day it was handed as today. The absence SHALL NOT be read as an answer about moving,
which *A move with nowhere to go leaves a day screen exactly as it was* states.

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

Every change a day screen makes SHALL be made on the day it is showing: a tick made or taken back, a
number or a note entered or taken back, an amount added and a last addition taken back are all
changes to the day being shown, and none of them SHALL be made on the day before it or the day after
it. A row that only a day either side holds SHALL change nothing: ticking, entering and taking back
with it SHALL each leave the record's place, the screen's day view and what it says of the days
either side exactly as they were — the shipped rule that a row the screen's day view does not hold
changes nothing, read over the rows this capability says. Nothing SHALL be told on such a row, and
what the screen is telling SHALL be left as it was.

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

### Requirement: A row is its commitment, its date and what that day holds

A row SHALL be three things and no others: its commitment, its day view's date, and what that day
view's history says of that commitment on that date — whether it is kept and, where its kind is a
number, a note or a total, the number, the note or the sum that day holds. Two rows SHALL be the
same row when all three agree, and SHALL be different when any one differs.

Two rows of one commitment on one date SHALL therefore be different rows where their days hold
different numbers or different notes, and SHALL be the same row where their days' additions differ
but sum alike, a total row holding the day's sum and never its additions. A row SHALL hold only what
its commitment's kind can put there, and every row but a total's SHALL hold a sum of zero, as a sum
rather than nothing at all.

#### Scenario: two rows for the same commitment and date saying the same thing are the same row

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on
  a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, each from a history
  holding a tick for that commitment on that date
- **THEN** each holds one row saying the commitment is kept
- **AND** the two rows are the same row

#### Scenario: two rows for the same commitment on different dates are different rows

- **WHEN** two day views are formed of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, each from a history that has taken no tick,
  one on Monday 31 August 2026 and one on Wednesday 2 September 2026
- **THEN** each holds one row named "Gym", saying the commitment is not kept
- **AND** the two rows are different rows

#### Scenario: two rows for the same commitment and date differing in whether it is kept are different rows

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on
  a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, the first from a
  history that has taken no tick and the second from a history holding a tick for that commitment
  on that date
- **THEN** the two rows are different rows

#### Scenario: two rows for the same number commitment and date holding different numbers are different rows

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Weight"
  of the number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, the first from a history holding a number of 70.5 for that
  commitment on that date and the second from a history holding a number of 71 for it on that date
- **THEN** each holds one row saying the commitment is kept
- **AND** the two rows are different rows

#### Scenario: two rows for the same number commitment and date holding the same number are the same row

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Weight"
  of the number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, each from a history holding a number of 70.5 for that
  commitment on that date
- **THEN** each holds one row saying the commitment is kept
- **AND** the two rows are the same row

#### Scenario: two rows for the same note commitment and date holding different notes are different rows

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Journal"
  of the note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026,
  the first from a history holding a note of "Ran 8k." for that commitment on that date and the
  second from a history holding a note of "Rested." for it on that date
- **THEN** each holds one row saying the commitment is kept
- **AND** the two rows are different rows

#### Scenario: two rows for the same note commitment and date holding the same note are the same row

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Journal"
  of the note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026,
  each from a history holding a note of "Ran 8k." for that commitment on that date
- **THEN** each holds one row saying the commitment is kept
- **AND** the two rows are the same row

#### Scenario: two rows for the same total commitment and date whose days have added different amounts are different rows

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, the first from a history holding an addition of 30 for that commitment on that
  date and the second from a history holding one of 90 for it on that date
- **THEN** each holds one row saying the commitment is not kept
- **AND** the two rows are different rows

#### Scenario: two rows for the same total commitment and date whose days have added the same amount are the same row

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, each from a history holding an addition of 30 for that commitment on that date
- **THEN** each holds one row saying the commitment is not kept
- **AND** the two rows are the same row

#### Scenario: two rows whose days hold different additions summing alike are the same row

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, the first from a history holding additions of 30 and 30 for that commitment on
  that date and the second from a history holding one addition of 60 for it on that date
- **THEN** the two rows are the same row
- **AND** the entry each offers says "60 of 120"

### Requirement: A row gives back what a screen draws and what a tap makes

A row SHALL be reachable only through the day view holding it, and SHALL give back four things: its
commitment's name, the rhythm that commitment runs on in words, whether that commitment is kept, and
what it offers — a tick, a number entry, a note entry or a total entry, according to its
commitment's kind. It MUST NOT give back the commitment, its schedule, the day it is kept from, the
date, the number, the note or the sum; those last three SHALL be given out only inside the entry a
row offers.

The rhythm's words SHALL be the ones the `schedule` capability says for the schedule the row's
commitment carries, and this capability SHALL compose none of them. Every row SHALL say its rhythm,
always, whether or not its commitment is kept on that date and whatever the row offers or does not.
The rhythm SHALL be read off the commitment the row already holds, so two rows alike in the three
things a row is say the same rhythm.

#### Scenario: a row says the rhythm its commitment runs on in words

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick,
  of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, one named
  "Finances" on a schedule on the 31st of the month, one named "Contact lenses" on a schedule of
  every 14 days starting on 31 August 2026, and one named "Reading" on a schedule of 3 times a
  week, all kept from 1 January 2026
- **THEN** the day view holds four rows, saying "Mon, Wed, Sat", "The 31st", "Every 14 days" and
  "3x a week" in that order

#### Scenario: a row says its rhythm whether or not its commitment is kept

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on
  a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, the first from a
  history that has taken no tick and the second from a history holding a tick for that commitment
  on that date
- **THEN** the first day view's row says it is not kept and says "Mon, Wed, Sat"
- **AND** the second day view's row says it is kept and says "Mon, Wed, Sat"

#### Scenario: a row for a day that has not arrived says its rhythm

- **WHEN** a day view is formed on Friday 4 September 2026, from a history that has taken no tick,
  of a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026,
  and its row is asked for the tick it offers as of Thursday 3 September 2026
- **THEN** the row offers no tick
- **AND** the row says "Every day"

#### Scenario: two rows for commitments alike in name and not in rhythm say different rhythms

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick,
  of a commitment named "Vitamins" on a schedule listing Monday and Wednesday and a commitment
  named "Vitamins" on a schedule listing all seven weekdays, both kept from 1 January 2026
- **THEN** the day view holds two rows, both named "Vitamins"
- **AND** the first says "Mon, Wed" and the second says "Every day"

### Requirement: A day screen says the day its day picker opens on and the earliest day it reaches

A day screen SHALL say the reach of its day picker as one answer of two days: the day it opens on
and the earliest day it reaches. The day it opens on SHALL be the day being shown, whatever put it
there. The earliest day it reaches SHALL be the earlier of the earliest day anything on its roster
is kept from and the day being shown, and SHALL never be later than the day it opens on. Where the
roster answers no such day, the today last handed SHALL stand in its place. That day SHALL be the
`commitment` capability's answer for the roster the screen last read, counting every commitment it
holds, stopped and removed included; a day screen MUST NOT recompute it, nor narrow it to the
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

#### Scenario: a day screen's day picker reaches back past a commitment its roster has removed

- **WHEN** a commitment named "Gym" kept from 1 January 2026 and one named "Run" kept from 1 March
  2026, both on a schedule listing all seven weekdays, are taken on at a roster place; "Gym" is
  removed there as of 31 January 2026; and a day screen of no commitments at all is opened at that
  roster place as of Monday 31 August 2026, at a record place where nothing has been kept
- **THEN** its day picker reaches back to 1 January 2026
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

### Requirement: A day screen's reach bounds its day picker and is read again whenever its roster is

The reach SHALL bound the day picker and never the screen: *A day screen moves the day it is showing
one calendar day either way* is unchanged by it and MUST NOT be read as narrowed by it. What is
bounded SHALL be what a person may pick and what showing a picked day accepts. Nothing SHALL be
answered about whether the day picker is offered. The answer MUST NOT give out the today the screen
was last handed, under any name. It SHALL take no day from the caller and read no clock. It SHALL be
read again whenever the roster is, and reading it SHALL move no day: where the earliest day it
reaches rises, the screen SHALL go on showing its day and the reach SHALL reach less far. The answer
SHALL be about the roster the screen holds and the day being shown, and nothing else.

#### Scenario: a day screen whose roster stops being readable goes on showing its day and reaches back to it

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2020, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; it
  is moved to the day before; that roster place is then made to hold a run of bytes that is not
  what a roster is written as; and the screen is returned to
- **THEN** its day picker opens on Sunday 30 August 2026 and reaches back to Sunday 30 August
  2026
- **AND** before it was returned to, its day picker reached back to 1 January 2020

#### Scenario: a day screen that cannot read its record says the reach of its day picker like any other

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place holding a run of
  bytes that is not what a record is written as, of a commitment named "Journaling" on a schedule
  listing all seven weekdays, kept from 1 January 2026
- **THEN** it says it is not keeping a record
- **AND** its day picker opens on Monday 31 August 2026 and reaches back to 1 January 2026

### Requirement: A day screen says the day view of the day either side of the one it is showing, formed as a move there would form it

A day screen SHALL say two further day views beside the one it is showing: the day view of the
calendar date one day earlier than the day being shown, and that of the date one day later. They
SHALL be two answers rather than one, and the day view of the day being shown SHALL go on being said
exactly as it is, unchanged in name, in shape and in every answer. Each SHALL be the day view this
screen would hold had it been moved onto that day, formed from the commitments its roster had not
stopped keeping there and from the record it holds, so a change kept on the day being shown SHALL
leave both as they were. This capability MUST NOT form either from the commitments answered for the
day being shown. Exactly one day either side SHALL be said, never a run of them.

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

### Requirement: A day screen asked the day either side reads neither place again and is left exactly as it was

Saying either SHALL read neither place again: the roster asked SHALL be the one read when the app
was last shown or the screen was last returned to, whichever happened later, and the record the one
the screen last read, each with every change kept since. Saying either SHALL change nothing about
the screen: the day being shown SHALL be the day it was, the today SHALL NOT move, nothing SHALL be
kept at either place, and what the screen is telling on a row SHALL be left exactly as it was. Both
SHALL follow the day being shown, whatever put the screen on it, and SHALL be formed from the roster
and the record then held. A day screen not keeping a record or not keeping a roster SHALL say them
like any other, and what it says about either place SHALL be untouched by being asked.

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

### Requirement: A day view holds the commitments due on a date, each with whether it is kept

A day view SHALL be formed from some commitments, a calendar date and a history, and SHALL hold one
row for each commitment due on that date and none for one that is not. Each row SHALL carry its
commitment's name exactly as given, and SHALL say whether the history holds that commitment kept on
that date.

Whether a commitment is due SHALL be the `commitment` capability's answer, asked of the commitment
itself rather than of the schedule it carries; whether it is kept SHALL be the `record`
capability's. A day view MUST NOT recompute either, MUST NOT consider a commitment's name, a clock,
a time zone or a locale, and SHALL be formed for any supported date, arrived or not. It SHALL NOT
count, total or rank anything. Rows SHALL come only from the commitments handed over: the history
SHALL be asked about each of them in turn and SHALL never be enumerated. A day view with nothing
due, or none at all, SHALL hold no rows rather than refuse.

#### Scenario: a day view holds a row for each commitment due on the date

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, a commitment named
  "Run" on a schedule listing Monday and Thursday, and a commitment named "Finances" on a schedule on
  the 25th of the month, all three kept from 1 January 2026
- **THEN** the day view holds two rows
- **AND** they are named "Gym" and "Run"

#### Scenario: a commitment not due on the date has no row

- **WHEN** a day view is formed on Tuesday 1 September 2026, from a history that has taken no tick,
  of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026
- **THEN** the day view holds no rows

#### Scenario: a commitment ticked on the date has a row that says it is kept

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, from a history holding a tick for
  that commitment on that date
- **THEN** the day view holds one row
- **AND** that row is named "Gym" and says the commitment is kept

#### Scenario: a day view of no commitments at all has no rows

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  no commitments at all
- **THEN** the day view holds no rows

#### Scenario: a day view holds no rows when none of the commitments is due

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of a
  commitment named "Finances" on a schedule on the 25th of the month, kept from 1 January 2026, and a
  commitment named "Contact lenses" on a schedule of every 14 days starting on 25 August 2026, kept
  from that same day
- **THEN** the day view holds no rows

#### Scenario: a commitment whose schedule is due but which is kept from a later day has no row

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from Wednesday
  2 September 2026
- **THEN** the day view holds no rows, though the schedule is due on that date
- **AND** a day view of the same commitment on Wednesday 2 September 2026 holds one row named "Gym"

#### Scenario: a tick for a commitment the day view was not handed adds no row

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, from a history holding a tick on
  that date for a commitment named "Run" on a schedule listing Monday and Thursday, kept from the
  same day
- **THEN** the day view holds one row
- **AND** that row is named "Gym" and says the commitment is not kept

#### Scenario: a tick on another date does not make the row say it is kept

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, from a history holding a tick for
  that commitment on Saturday 5 September 2026
- **THEN** the day view holds one row saying the commitment is not kept
- **AND** a day view of the same commitment and history on Saturday 5 September 2026 holds one row
  saying it is kept

#### Scenario: two commitments with the same name and different schedules each have their own row

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday and a commitment named "Gym" on a schedule listing Monday
  and Thursday, both kept from 1 January 2026, from a history holding a tick on that date for the
  first of them only
- **THEN** the day view holds two rows, both named "Gym"
- **AND** the first says the commitment is kept and the second says it is not

#### Scenario: a commitment on a weekly quota has a row on every day of the week

- **WHEN** a day view is formed on each date from Monday 31 August through Sunday 6 September 2026,
  from a history that has taken no tick, of a commitment named "Reading" on a schedule of 3 times a
  week, kept from 1 January 2026
- **THEN** each of the seven day views holds one row named "Reading", saying the commitment is not
  kept
- **AND** when the history holds ticks for that commitment on Monday 31 August, Wednesday 2 September
  and Saturday 5 September 2026, those three dates' rows say it is kept and the other four dates
  still hold a row saying it is not

#### Scenario: a day view is formed in the first supported year and in the last

- **WHEN** a day view is formed on Monday 3 January 1583, from a history that has taken no tick, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  1583
- **THEN** the day view holds one row named "Gym", saying the commitment is not kept
- **AND** a day view of the same commitment and history on Monday 27 December 9999 holds one row
  saying the same

#### Scenario: a row carries the commitment's name exactly as it was given

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of a
  commitment named " Gym ", with a space at each end, and a commitment named with the single emoji
  🏋️, both on a schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026
- **THEN** the first row is named " Gym ", with both spaces
- **AND** the second row is named with that emoji

### Requirement: A row offers the tick that keeps its commitment, and offers none for a day that has not arrived

A row SHALL offer, asked as of a calendar date, exactly one tick or nothing at all: the tick of its
commitment on its day view's date. A row asked as of its own date SHALL offer that tick, and so
SHALL a row whose date is earlier, however much earlier. A row SHALL offer nothing where its date is
later than the day it is asked as of, and nothing where its commitment's kind is not a tick,
whatever day it is asked as of; such a row SHALL stay in the day view unchanged. A row SHALL refuse
for those two reasons and no other, and SHALL offer the same tick whether or not it says the
commitment is kept.

The day a row is asked as of SHALL be given to it, never read from a clock or a locale and never
kept, so a row asked as of two different days SHALL answer each on its own. Adding the tick a row
offers to the history SHALL make a day view formed again from it say the row is kept, and taking it
back SHALL make one say it is not; the row SHALL neither add nor take back anything itself, and MUST
NOT hold, copy or alter a history.

#### Scenario: adding the tick a row offers makes a day view formed again say the commitment is kept

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026; its one row is asked as of that same day; and the tick it offers is added to that history
- **THEN** a day view formed again on Monday 31 August 2026, of the same commitment and from the
  history as it now stands, holds one row named "Gym" saying the commitment is kept

#### Scenario: taking back the tick a row offers makes a day view formed again say the commitment is not kept

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, from a history holding a tick
  for that commitment on that date; its one row is asked as of that same day; and the tick it offers
  is taken back from that history
- **THEN** that row says the commitment is kept
- **AND** a day view formed again on Monday 31 August 2026, of the same commitment and from the
  history as it now stands, holds one row named "Gym" saying the commitment is not kept

#### Scenario: a row already saying the commitment is kept offers the same tick

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, the first from a
  history that has taken no tick and the second from a history holding a tick for that commitment on
  that date, and each one's row is asked as of that same day
- **THEN** the first row says the commitment is not kept and the second says it is
- **AND** both offer the same tick

#### Scenario: a row for a date later than the day it is asked as of offers no tick

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  tick, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and its one row is asked as of Monday 31 August 2026
- **THEN** the day view holds one row named "Gym"
- **AND** that row offers no tick

#### Scenario: a row for a date earlier than the day it is asked as of offers the tick

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, and its one row is asked as of Saturday 5 September 2026
- **THEN** the row offers a tick
- **AND** that tick is the same tick as one formed directly for that commitment on Monday 31 August
  2026

#### Scenario: a row for a date later than the day it is asked as of offers no tick even where it says the commitment is kept

- **WHEN** a day view is formed on Saturday 5 September 2026, of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, from a history holding
  a tick for that commitment on that date, and its one row is asked as of Monday 31 August 2026
- **THEN** that row says the commitment is kept
- **AND** it offers no tick

#### Scenario: a row's answer follows the day it is asked as of rather than the day the day view was formed

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  tick, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and its one row is asked twice — once as of Tuesday 1 September 2026 and once as
  of Wednesday 2 September 2026
- **THEN** the first asking offers no tick
- **AND** the second offers the tick for that commitment on Wednesday 2 September 2026

#### Scenario: a row offers the tick in the first supported year and in the last

- **WHEN** a day view is formed on Monday 3 January 1583, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  1583, and its one row is asked as of Monday 3 January 1583
- **THEN** the row offers a tick
- **AND** the row of a day view of the same commitment and history on Monday 27 December 9999, asked
  as of Monday 27 December 9999, offers a tick
- **AND** that same row, asked as of Monday 3 January 1583, offers none

#### Scenario: every row of a day view whose date has not arrived offers no tick

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  tick, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, then one
  named "Vitamins" on a schedule listing all seven weekdays, then one named "Reading" on a weekly
  quota of 3 times a week, all three kept from 1 January 2026, and every one of its rows is asked as
  of Monday 31 August 2026
- **THEN** the day view holds three rows, named "Gym", "Vitamins" and "Reading"
- **AND** none of them offers a tick

#### Scenario: a row for a commitment on a weekly quota offers a tick even where its quota is already met

- **WHEN** a day view is formed on Sunday 6 September 2026, of a commitment named "Reading" on a
  weekly quota of 3 times a week, kept from 1 January 2026, from a history holding ticks for that
  commitment on Monday 31 August, Wednesday 2 September and Saturday 5 September 2026, and its one
  row is asked as of Sunday 6 September 2026
- **THEN** the day view holds one row named "Reading", saying the commitment is not kept
- **AND** that row offers a tick

#### Scenario: a row for a commitment whose kind is not a tick offers nothing

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of Monday
  31 August 2026
- **THEN** the day view holds one row named "Weight", saying the commitment is not kept
- **AND** that row offers no tick
- **AND** the same row asked as of Sunday 6 September 2026, a day later than its own, offers no tick
  either
- **AND** a row for a commitment alike in every way but of the tick kind, asked as of Monday
  31 August 2026, offers a tick

### Requirement: A day view's rows are in the order it was handed its commitments

A day view's rows SHALL appear in the order its commitments were handed to it, with the ones that
are not due on the date left out and every other one left where it was. A day view SHALL NOT impose
an order of its own: it MUST NOT sort by name, by the rhythm a commitment runs on, by the day it is
kept from or by whether it is kept, and it MUST NOT move a row that has been ticked. A day view
SHALL hold one row per commitment it was handed that is due and SHALL NOT combine two into one, so
handing the same commitment to a day view twice SHALL give two rows.

#### Scenario: handing the same commitments in the opposite order reverses the rows

- **WHEN** the same three commitments — "Gym", "Run" and "Vitamins" — are handed to a day view on
  Monday 31 August 2026, from a history that has taken no tick, in the order "Vitamins", "Run", "Gym"
- **THEN** the day view's rows are named "Vitamins", "Run" and "Gym", in that order

#### Scenario: a kept commitment keeps its place among the ones that are not kept

- **WHEN** a day view is formed on Monday 31 August 2026, of the commitments "Gym", "Run" and
  "Vitamins" handed over in that order, from a history holding a tick for "Run" on that date
- **THEN** the day view's rows are named "Gym", "Run" and "Vitamins", in that order
- **AND** only the middle row says its commitment is kept

#### Scenario: dropping a commitment that is not due leaves the others in their order

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, then one named
  "Finances" on a schedule on the 25th of the month, then one named "Run" on a schedule listing
  Monday and Thursday, all three kept from 1 January 2026
- **THEN** the day view holds two rows, named "Gym" and "Run", in that order

#### Scenario: a commitment handed twice has two rows

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  one commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, handed over twice
- **THEN** the day view holds two rows, both named "Gym"
- **AND** both say the commitment is not kept

### Requirement: A day view is a value and nothing else

A day view SHALL be the groups it holds and the calendar date it was formed on, and nothing else.
Two day views SHALL be the same day view when they are of the same date and hold the same groups in
the same order, each group holding the same rows in the same order, and SHALL be different when any
of that differs; two day views holding the same rows in the same order under different groupings
SHALL therefore be two day views.

A difference in what a day view was handed that does not reach a row SHALL make no difference to the
day view: a commitment not due produces no row, a group none of whose commitments is due produces no
group, and a tick for a commitment the day view was not handed is never looked up, so a day view
handed any of the three SHALL be the same day view as one that was not. A day view SHALL be an
answer given from a history as it stood rather than a window onto one, and ticking that history
afterwards MUST NOT change the day view.

#### Scenario: two day views of the same commitments and history on different dates are different day views

- **WHEN** two day views are formed of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, each from a history that has taken no tick, one
  on Monday 31 August 2026 and one on Wednesday 2 September 2026
- **THEN** each holds one row named "Gym", saying the commitment is not kept
- **AND** the two are different day views

#### Scenario: two day views differing only in a commitment that is not due are the same day view

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, and a second day view is formed on that same date and from that same history, of that same
  commitment followed by one named "Finances" on a schedule on the 25th of the month, also kept from
  1 January 2026
- **THEN** each holds one row named "Gym", saying the commitment is not kept
- **AND** the two are the same day view

#### Scenario: two day views differing only in a tick for a commitment neither was handed are the same day view

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, the first from a history
  that has taken no tick and the second from a history holding a tick on that date for a commitment
  named "Run" on a schedule listing Monday and Thursday, kept from 1 January 2026
- **THEN** each holds one row named "Gym", saying the commitment is not kept
- **AND** the two are the same day view

#### Scenario: a day view does not change when the history it was built from is ticked afterwards

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, from a history that has taken no
  tick, and a tick for that commitment on that date is then added to the history
- **THEN** that day view still holds one row saying the commitment is not kept
- **AND** a day view formed again from the history as it now stands holds one row saying it is kept
- **AND** the two are different day views

#### Scenario: two day views differing only in how their commitments were grouped are different day views

- **WHEN** two day views are formed on Monday 31 August 2026, from a history that has taken no tick,
  each of a commitment named "Creatine" and one named "Magnesium", both on a schedule listing all
  seven weekdays and both kept from 1 January 2026 and handed over in that order — the first with
  both under no category, the second with both in a group under "Supplements"
- **THEN** each holds two rows, named "Creatine" and then "Magnesium"
- **AND** the two are different day views

#### Scenario: two day views differing only in a group none of whose commitments is due are the same day view

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, under no category, and a second day view is formed on that same date and from that
  same history of that same commitment together with a group under "Money" holding one commitment
  named "Finances" on a schedule on the 25th of the month, also kept from 1 January 2026
- **THEN** each holds one group, with no category, holding one row named "Gym"
- **AND** the two are the same day view

### Requirement: A day screen makes and takes back the tick a row offers, and keeps the change before the day view says so

A day screen SHALL make the tick one of its rows offers and SHALL take that same tick back where the
row says its commitment is kept; which of the two a tap means SHALL be read off the row and MUST NOT
be given to the screen. The tick SHALL be the one the row offers asked as of the today the screen
was handed, never as of the day it is showing, so moving a screen forward MUST NOT make a tick
formable that was not formable before. A row the screen's day view does not hold SHALL change
nothing at all.

The change SHALL be kept at the screen's record place before its day view says so, the day view then
being formed again, on the day the screen is showing, from the record as it stands and the
commitments its roster answers with on that day. A change that could not be kept SHALL be refused,
SHALL be reported to the caller rather than passed over, and SHALL leave the day view exactly as it
was. Making a tick or taking one back MUST NOT write to the roster's place, and MUST NOT change what
the screen says about its roster.

#### Scenario: ticking a row that says its commitment is kept takes the tick back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; its one row is ticked; and the row the day screen then holds is ticked again
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** its day view is the same day view as the one the screen held when it was opened

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

### Requirement: A day screen re-reads its day and its places when the app is shown again

A day screen SHALL be told when the app has been shown — opened from nothing, or brought back in
front of a person — and SHALL be handed the day it has been shown on. It SHALL then take that day as
its today and form its day view again from the record and the roster read again at their places,
whatever day it is showing, a tick made on it being no such moment. A day screen showing the day it
was last handed as today SHALL show the day it has now been shown on, and one showing any other day
SHALL go on showing that day; that comparison SHALL be made against the today the screen held before
it was told, and against nothing kept for the purpose. A day screen shown again on the day it is
already showing SHALL hold that day's day view, formed again rather than merely kept.

Reading either place again SHALL be a fresh opening there, so a change made since SHALL be seen, and
what the screen says about the record and about the roster SHALL each be formed again from what is
then there, the reason included and nothing carried over. A roster read again that holds nothing at
all SHALL have the commitments the screen was handed taken on into it. Nothing else SHALL survive
being shown again: those commitments, the two places and the day it is showing are all a day screen
carries across.

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

#### Scenario: a day screen shown again reads its roster again

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from that same
  day, is then taken on at that roster place by something else; and the day screen is shown as of
  Monday 31 August 2026
- **THEN** its day view holds two rows, named "Journaling" and then "Gym"

#### Scenario: a day screen that could not read its roster starts keeping one when it is shown again and the roster can be read

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a run of
  bytes that is not what a roster is written as, at a record place where nothing has been kept, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026; what is at that roster place is then replaced by a roster that has been given a commitment
  named "Journaling" on a schedule listing all seven weekdays, kept from that same day; and the day
  screen is shown as of Monday 31 August 2026
- **THEN** it says it is keeping a roster
- **AND** its day view holds one row, named "Journaling"

#### Scenario: a day screen that was keeping a roster stops when it is shown again and the roster cannot be read

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place and a record place
  where nothing has been kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026; what is at that roster place is then replaced by a roster
  written in a form one later than the form this app writes, holding no commitments; and the day
  screen is shown as of Monday 31 August 2026
- **THEN** it says it is not keeping a roster
- **AND** it says the roster was written by a later version of DayByDay
- **AND** its day view holds no rows

#### Scenario: a day screen moved off today keeps the day it is showing when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day before; and the app is then shown again as of Wednesday
  2 September 2026
- **THEN** its day view is the same day view as one formed directly of those two commitments, in that
  order, on Sunday 30 August 2026, from a history that has taken no tick
- **AND** its day picker opens on Sunday 30 August 2026, and it offers the way back to today

#### Scenario: a day screen moved away and back onto today moves onto the new day when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day before and then to the day after; and the app is then
  shown again as of Wednesday 2 September 2026
- **THEN** its day view is the same day view as one formed directly of those two commitments, in that
  order, on Wednesday 2 September 2026, from a history that has taken no tick
- **AND** its day picker opens on Wednesday 2 September 2026, and it offers no way back to today

#### Scenario: a day screen sent back to today moves onto the new day when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before three times; it is sent back to today; and the app is
  then shown again as of Wednesday 2 September 2026
- **THEN** its day picker opens on Wednesday 2 September 2026, and it offers no way back to today

#### Scenario: a day screen kept on a day that has since arrived offers the tick it refused before

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day after, onto Tuesday 1 September 2026, and its one row is
  ticked; the app is then shown again as of Tuesday 1 September 2026; and the one row it then holds
  is ticked
- **THEN** the first ticking left the day view saying the commitment is not kept
- **AND** after being shown again its day picker opens on Tuesday 1 September 2026, and it offers
  no way back to today
- **AND** the second ticking makes its day view say the commitment is kept on Tuesday 1 September
  2026

#### Scenario: a day screen moved off today reads its record again when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before; a tick for that commitment on Sunday 30 August 2026
  is then kept at that place by something else; and the app is shown again as of Monday 31 August
  2026
- **THEN** its day view says the commitment is kept on Sunday 30 August 2026
- **AND** its day picker still opens on Sunday 30 August 2026, the screen not having moved

### Requirement: A day screen tells on the row that was tapped that its change could not be kept

Where a change a row offers cannot be kept, a day screen SHALL tell it on the row tapped or
committed on and SHALL refuse the change to the caller as well; where the value given was refused
instead, that telling SHALL be the whole report and nothing SHALL be thrown. A cause SHALL be named
only where a person can act on it: a change the place refused SHALL name none, and MUST NOT tell
which change was asked or why it was refused.

Exactly four causes SHALL be named and no fifth: "Not a number" for a value that is not a number, in
a number entry or a total entry; "Must be between 40 and 150" — the commitment's own declared range
— for a number it refuses; "Must be more than 0" for an amount not above zero; and "Too large to
add" for an amount that would take the day past what can be kept exactly. The words SHALL be this
package's own English and no locale's. Nothing about a note's
length, script, line breaks or characters SHALL be named as a cause. At most one row SHALL be told
at a time, the one tapped or committed on last, and a second refusal SHALL move what is told, with
its cause, onto its own row, leaving nothing on the first. Where a day view holds two rows that are
the same row, both SHALL be told of. Telling MUST NOT change what a day screen says about keeping a
record.

#### Scenario: a refused tick is told on the row that was tapped and on no other row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, a commitment named "Journaling" on a schedule listing
  all seven weekdays and a commitment named "Supplements and habits" on that same schedule, in
  that order and all kept from 1 January 2026, and the second of its three rows is ticked
- **THEN** the day screen tells, on the second row, that the change could not be kept
- **AND** it tells nothing on the first row and nothing on the third

#### Scenario: a refused take-back is told on the row that was tapped

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from
  but not written to and that holds a record in which a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, is already kept on that date,
  and its one row — which says the commitment is kept — is ticked
- **THEN** taking the tick back is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** its day view still says the commitment is kept on that date

#### Scenario: a second refused tap is told on the row tapped last and no longer on the first

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday and a commitment named "Journaling" on a schedule listing
  all seven weekdays, in that order and both kept from 1 January 2026; its first row is ticked;
  and its second row is then ticked
- **THEN** both taps are refused with an error
- **AND** the day screen tells, on the second row, that the change could not be kept
- **AND** it tells nothing on the first row

#### Scenario: a refused change does not change what a day screen says about keeping a record

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
  twice
- **THEN** the day screen says it is keeping a record
- **AND** it tells, on that row, that the change could not be kept

#### Scenario: a number outside the commitment's range is told on the row, naming the bounds it broke

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 and a
  commitment named "Mood" of the number kind with a range of 1 to 10, both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026, and "300" is committed on the
  first row
- **THEN** the day screen tells, on that row, that the number must be between 40 and 150
- **AND** it tells nothing on the second row
- **AND** committing "0.5" on the second row of the screen it then holds tells, on that row, that
  the number must be between 1 and 10

#### Scenario: a number refused by the place is told on the row and names no cause

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Weight" of the
  number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, and "70.5" is committed on its one row
- **THEN** committing is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** what it tells names no cause
- **AND** committing nothing at all on that row tells the same thing on it and names no cause
  either

#### Scenario: a second refused commit is told on the row committed on last and no longer on the first

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 and a
  commitment named "Mood" of the number kind with a range of 1 to 10, in that order and both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026; "300" is
  committed on the first row; and "1.2.3" is then committed on the second row of the screen it
  then holds
- **THEN** the day screen tells, on the second row, that it is not a number
- **AND** it tells nothing on the first row

#### Scenario: a note refused by the place is told on the row and names no cause

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journal" of the note
  kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and
  "Ran 8k." is committed on its one row
- **THEN** committing is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** what it tells names no cause
- **AND** committing nothing at all on that row tells the same thing on it and names no cause
  either
- **AND** committing a note of a hundred thousand characters on that row tells the same thing on it
  and names no cause either

#### Scenario: an amount that is not above zero is told on the row, saying so

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120 and a commitment
  named "Water" of the total kind with a target of 2, both on a schedule listing Monday, Wednesday
  and Saturday and both kept from 1 January 2026, and "0" is committed on the first row
- **THEN** the day screen tells, on that row, that it must be more than 0
- **AND** it tells nothing on the second row
- **AND** committing "-1" on the second row of the screen it then holds tells, on that row, that it
  must be more than 0, and tells nothing on the first

#### Scenario: an amount too large to add to the day is told on the row, saying so

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; a whole number of thirty-eight
  nines is committed on its one row; and "0.5" is then committed on the row it then holds
- **THEN** the day screen tells, on that row, that it is too large to add
- **AND** what it tells is not "Not a number" and not "Must be more than 0"

#### Scenario: a value that is not a number committed in a total entry is told the same thing a number entry tells

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 and a commitment
  named "Protein" of the total kind with a target of 120, in that order and both on a schedule
  listing Monday, Wednesday and Saturday and both kept from 1 January 2026, and "1.2.3" is committed
  on the first row and then on the second row of the screen it then holds
- **THEN** the day screen tells, on the second row, that it is not a number
- **AND** what it tells there is word for word what it told on the first row

#### Scenario: an addition refused by the place is told on the row and names no cause

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Protein" of the total
  kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and "30" is committed on its one row
- **THEN** committing is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** what it tells names no cause

### Requirement: What a day screen tells on a row lasts only until the app is shown again, a change is kept, or the day it is showing changes

A day screen SHALL go on telling it, on the same row, until one of exactly three things happens, and
SHALL then tell nothing on any row. Nothing else SHALL end it, time passing included. The app being
shown again SHALL end it, whether or not the record can then be read. A change reaching the record's
place SHALL end it, on whichever row it was made, whatever the change. The day being shown changing
SHALL end it — the day changing and never the gesture made — so a move with nowhere to go, and today
sent back to today, SHALL leave it standing.

A change that does not reach the place SHALL NOT end it: a refused value moves what is told rather
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

### Requirement: A day screen tells nothing on a row where there was no change to refuse

A tap or a commit that never reaches the record's place is not a refused change: apart from the four
causes named above, a day screen SHALL tell nothing on its row and SHALL NOT end what it is already
telling on another row. It SHALL tell nothing for a tap or commit on a day screen not keeping a
record, whatever the reason its store would not open and whatever was committed, a refused value
included; for one on a row for a day that has not arrived; for one on a row the screen's day view
does not hold; and for a commit on a row that offers no entry at all, or a take-back asked of a row
offering none, whatever makes it offer none. A commit in a total entry that says nothing SHALL
likewise be told nothing and SHALL NOT end what is already told.

#### Scenario: a tap on a day screen that is not keeping a record is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
- **THEN** the day screen tells nothing on any row
- **AND** it says it is not keeping a record

#### Scenario: a tap on a day screen holding a record from a later version is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a record written
  in a form one later than the form this app writes, holding no ticks, of a commitment named "Gym"
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row
  is ticked
- **THEN** the day screen tells nothing on any row
- **AND** it says the record was written by a later version of DayByDay

#### Scenario: a tap on a row for a day that has not arrived is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; it is moved to the day after; and
  its one row is ticked
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on Tuesday 1 September 2026

#### Scenario: a tap on a row a day screen's day view does not hold does not end what is already told

- **WHEN** two day screens of a commitment named "Journaling" on a schedule listing all seven
  weekdays, kept from 1 January 2026, are opened at one place where nothing can be written — a
  path beneath an existing ordinary file — the first as of Monday 31 August 2026 and the second as
  of Wednesday 2 September 2026; the first screen's own row is ticked; and the second screen's row
  is then ticked on the first screen
- **THEN** the first day screen still tells, on its own row, that the change could not be kept

#### Scenario: a commit on a row for a day that has not arrived is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026; it is moved to the day after; and "300" is
  committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on Tuesday 1 September 2026

#### Scenario: a commit on a row a day screen's day view does not hold is told nothing and does not end what is already told

- **WHEN** two day screens of a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing all seven weekdays, kept from 1 January 2026, are opened at one place
  where nothing has been kept, the first as of Monday 31 August 2026 and the second as of
  Wednesday 2 September 2026; "300" is committed on the first screen's own row; and "1.2.3" is
  then committed on the first screen, on the second screen's row
- **THEN** the first day screen still tells, on its own row, that the number must be between 40
  and 150

#### Scenario: a commit on a row that offers no entry at all is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and "Ran 8k." is committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on that date
- **AND** committing "30" and then nothing at all on that row tells nothing on any row either

#### Scenario: a commit on a note row for a day that has not arrived is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing all seven weekdays,
  kept from 1 January 2026; it is moved to the day after; and "Ran 8k." is committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on Tuesday 1 September 2026

#### Scenario: a commit on a total row on a day screen that is not keeping a record is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and
  "30" is committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** it says it is not keeping a record
- **AND** committing "0", then "1.2.3", then nothing at all on that row tells nothing on any row
  either
- **AND** taking that row's last addition back tells nothing on any row either

#### Scenario: a commit on a total row for a day that has not arrived is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing all seven weekdays, kept from 1 January 2026; it is moved to the day after; and "0" is
  committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on Tuesday 1 September 2026
- **AND** taking that row's last addition back tells nothing on any row either

#### Scenario: taking back on a row that offers no take-back is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" of the tick kind
  and a commitment named "Protein" of the total kind with a target of 120, in that order and both on
  a schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026; the first row
  is ticked and refused; and the last addition is then taken back on the second row, whose day holds
  none
- **THEN** the day screen still tells, on the first row, that the change could not be kept
- **AND** it tells nothing on the second row

### Requirement: A day screen reads its roster again whenever it is returned to

A day screen returned to SHALL read its roster place again and SHALL form its day view from the
roster it then reads. Being returned to SHALL NOT take a new today nor move the day being shown. It
SHALL read its record place again where it is keeping a record and SHALL NOT where it is not: a
screen not keeping one does not start by being returned to, and that state, with anything else that
lasts until the app is shown again, SHALL stand across being returned to. What a day screen tells on
a row ends on exactly three things, of which being returned to is not one; it SHALL go on telling
it. Where the roster it then reads holds nothing at all, it SHALL take on the commitments it was
handed; where that place cannot be read, it SHALL say so and draw no rows.

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

### Requirement: A day screen enters the number a row's entry takes, and keeps the change before the day view says so

A day screen SHALL enter, on one of its rows, the number a person commits in that row's number
entry, and SHALL take that day's number back where what is committed is empty; which of the two a
commit means SHALL be read off what was committed and MUST NOT be given to the screen. The entry
SHALL be the one the row itself offers, asked as of the today the screen was handed and never the
day it is showing.

A commit SHALL change nothing at all — nothing kept, nothing shown, nothing told — on a row the
screen's day view does not hold, on a row that offers no number entry, and on a screen that is not
keeping a record. A number the commitment refuses SHALL keep nothing and SHALL leave the day exactly
as it was. The change SHALL be kept at the screen's record place before its day view says so, and
the day view SHALL then be formed again from the record as it stands rather than altered; a change
that could not be kept SHALL be refused, reported to the caller, and SHALL leave the day view
exactly as it was. A number entered on a day that already holds one SHALL replace it. Taking one
back SHALL reach the place whether or not the day holds a number, and SHALL be refused only by the
place.
Entering a number or taking one back MUST NOT write to the roster's place or change what the screen
says about its roster.

#### Scenario: a number entered on a day that already holds one replaces it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one
  row; and "71.2" is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers says the number 71.2
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: committing an empty entry takes the number back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one
  row; and nothing at all is then committed on the row it then holds
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** the entry its row offers says no number
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: committing an empty entry on a day that holds no number leaves the day as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and nothing at all is
  committed on its one row
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a number the commitment refuses keeps nothing and leaves the day as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one
  row; and "300" is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers says the number 70.5
- **AND** the day view says the commitment is kept on that date
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a number that cannot be kept is refused and leaves the day view as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Weight" of the
  number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, and "70.5" is committed on its one row
- **THEN** committing is refused with an error
- **AND** the day screen's day view still says the commitment is not kept on that date
- **AND** a day screen opened afterwards at the same place says the same

#### Scenario: entering a number on a row the day screen's day view does not hold changes nothing

- **WHEN** two day screens of a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, are opened
  at one place where nothing has been kept, the first as of Monday 31 August 2026 and the second
  as of Wednesday 2 September 2026, and "70.5" is committed on the first screen in the second
  screen's row's number entry
- **THEN** the first day screen's day view still says the commitment is not kept on Monday 31
  August 2026
- **AND** a day screen opened afterwards at that place as of Wednesday 2 September 2026 says the
  commitment is not kept on that date either

#### Scenario: committing on a row that offers no number entry changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind and a commitment named "Weight" of the number
  kind with a range of 40 to 150, both on a schedule listing all seven weekdays and both kept from
  1 January 2026; "70.5" is committed on the row named "Gym"; the screen is then moved to the day
  after; and "70.5" is committed on the row it then holds named "Weight"
- **THEN** the day screen's day view says neither commitment is kept on Tuesday 1 September 2026
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says neither is
  kept on that date

#### Scenario: entering a number on a day screen that is not keeping a record changes nothing and keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Weight" of the number kind with
  a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, and "70.5" is committed on its one row
- **THEN** its day view still says the commitment is not kept on that date
- **AND** it still says it is not keeping a record
- **AND** the content at that place is byte-for-byte what it was before the screen was opened

#### Scenario: entering a number on one row leaves the other rows of the day as they were

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind, a commitment named "Weight" of the number
  kind with a range of 40 to 150 and a commitment named "Mood" of the number kind with a range of
  1 to 10, in that order, all three on a schedule listing all seven weekdays and all kept from 1
  January 2026, and "70.5" is committed on the second row
- **THEN** the day screen's day view holds three rows in that same order
- **AND** only the second says its commitment is kept

#### Scenario: entering a number on a day a day screen has moved back to keeps it on that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026; it is moved to the day before; and "70.5"
  is committed on its one row
- **THEN** its day view says the commitment is kept on Sunday 30 August 2026
- **AND** a day screen opened afterwards at that place as of Sunday 30 August 2026 says the
  commitment is kept on that date
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says the
  commitment is not kept on that date

#### Scenario: entering a number writes nothing to the roster's place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place and a roster
  place where nothing has been kept, of a commitment named "Weight" of the number kind with a
  range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026; the roster place is read once the screen has been opened; and "70.5" is then committed on
  its one row, and nothing at all committed on the row it then holds
- **THEN** the content at the roster place is byte-for-byte what it was after the screen was
  opened
- **AND** the day screen says it is keeping its roster

### Requirement: A note entry says the whole note the day already holds, and says nothing else

A note entry SHALL say exactly one thing: the note the history the day view was formed from holds
for that commitment on that date, or no note where it holds none. It SHALL say no hint and nothing else. The note SHALL be the one the `record` capability answers for
that commitment on that date, MUST NOT be recomposed, shortened or otherwise altered here, and SHALL
be the whole of what was written, however long and however many lines. An entry offered again from a
history the note has been taken back from SHALL say no note. A row SHALL NOT say the note itself.

#### Scenario: a note entry says a note of many lines and many characters whole

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Journal" of the
  note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, from a
  history holding a note of three lines separated by line breaks for that commitment on that date,
  and its one row is asked as of that same day
- **THEN** the entry that row offers says all three lines, with the line breaks between them
- **AND** an entry formed the same way from a history holding a note of a hundred thousand
  characters says that note whole

#### Scenario: a note entry says no note where the day holds none

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Journal"
  of the note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026,
  the first from a history that has taken no record and the second from a history a note of
  "Ran 8k." for that commitment on that date was added to and then taken back from, and each one's
  row is asked as of that same day
- **THEN** the entry the first row offers says no note
- **AND** the entry the second row offers says no note

#### Scenario: a row for a note commitment holding a note says its name, its rhythm and that the day is kept

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Journal" of the
  note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, from a
  history holding a note of "Ran 8k." for that commitment on that date
- **THEN** the day view holds one row named "Journal"
- **AND** that row says "Mon, Wed, Sat"
- **AND** it says the commitment is kept
- **AND** a row of a day view formed the same way but from a history holding a note of "Rested."
  instead says all three of those things identically

### Requirement: A day screen enters the note a row's entry takes, and keeps the change before the day view says so

A day screen SHALL enter, on one of its rows, the note a person commits in that row's note entry,
and SHALL take that day's note back where what is committed says nothing; which of the two a commit
means SHALL be read off what was committed and MUST NOT be given to the screen. Which entry a commit
lands in SHALL be decided by the row it was made on and by nothing about the text itself, so a
number committed on a note row is kept as a note.

Entering a note and taking one back SHALL answer as entering a number and taking one back do,
behaviour for behaviour, under the requirement on entering a number. A note written on a day that
already holds one SHALL replace it. No note a person commits SHALL be refused for anything but the
place refusing to take it.

#### Scenario: a note entered on a day screen is held by a day screen opened afterwards at the same place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026; "Ran 8k before work." is committed on its one row; and a
  second day screen of the same commitment is then opened at the same place as of the same day
- **THEN** the second day screen's day view says the commitment is kept on that date
- **AND** the entry its one row offers says the note "Ran 8k before work."

#### Scenario: a note entered on a day that already holds one replaces it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026; "Ran 8k." is committed on its one row; and "Ran 8k. Knee
  held up." is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers says the note "Ran 8k. Knee held up."
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: committing an empty note entry takes the note back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026; "Ran 8k." is committed on its one row; and nothing at all
  is then committed on the row it then holds
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** the entry its row offers says no note
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: committing an empty note entry on a day that holds no note leaves the day as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, and nothing at all is committed on its one row
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a note that cannot be kept is refused and leaves the day view as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journal" of the note
  kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and
  "Ran 8k." is committed on its one row
- **THEN** committing is refused with an error
- **AND** the day screen's day view still says the commitment is not kept on that date
- **AND** a day screen opened afterwards at the same place says the same

#### Scenario: entering a note on a row the day screen's day view does not hold changes nothing

- **WHEN** two day screens of a commitment named "Journal" of the note kind, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, are opened at one place where nothing
  has been kept, the first as of Monday 31 August 2026 and the second as of Wednesday 2 September
  2026, and "Ran 8k." is committed on the first screen in the second screen's row's note entry
- **THEN** the first day screen's day view still says the commitment is not kept on Monday 31 August
  2026
- **AND** a day screen opened afterwards at that place as of Wednesday 2 September 2026 says the
  commitment is not kept on that date either

#### Scenario: committing on a row that offers no note entry changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind and a commitment named "Journal" of the note
  kind, both on a schedule listing all seven weekdays and both kept from 1 January 2026; "Ran 8k."
  is committed on the row named "Gym"; the screen is then moved to the day after; and "Ran 8k." is
  committed on the row it then holds named "Journal"
- **THEN** the day screen's day view says neither commitment is kept on Tuesday 1 September 2026
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says neither is
  kept on that date

#### Scenario: a commit is read as the entry the row it was made on offers

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 and a commitment
  named "Journal" of the note kind, in that order and both on a schedule listing Monday, Wednesday
  and Saturday and both kept from 1 January 2026; "70.5" is committed on the first row; and "70.5"
  is then committed on the second row of the screen it then holds
- **THEN** the entry the first row of the screen it then holds offers says the number 70.5
- **AND** the entry the second row offers says the note "70.5"
- **AND** the day view says both commitments are kept on that date

#### Scenario: entering a note on a day screen that is not keeping a record changes nothing and keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Journal" of the note kind, on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "Ran 8k." is
  committed on its one row
- **THEN** its day view still says the commitment is not kept on that date
- **AND** it still says it is not keeping a record
- **AND** the content at that place is byte-for-byte what it was before the screen was opened

#### Scenario: entering a note on one row leaves the other rows of the day as they were

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind, a commitment named "Journal" of the note kind
  and a commitment named "Weight" of the number kind with a range of 40 to 150, in that order, all
  three on a schedule listing all seven weekdays and all kept from 1 January 2026, and "Ran 8k." is
  committed on the second row
- **THEN** the day screen's day view holds three rows in that same order
- **AND** only the second says its commitment is kept

#### Scenario: entering a note on a day a day screen has moved back to keeps it on that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing all seven weekdays,
  kept from 1 January 2026; it is moved to the day before; and "Ran 8k." is committed on its one row
- **THEN** its day view says the commitment is kept on Sunday 30 August 2026
- **AND** a day screen opened afterwards at that place as of Sunday 30 August 2026 says the
  commitment is kept on that date
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says the
  commitment is not kept on that date

#### Scenario: entering a note writes nothing to the roster's place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place and a roster place
  where nothing has been kept, of a commitment named "Journal" of the note kind, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; the roster place is read once
  the screen has been opened; and "Ran 8k." is then committed on its one row, and nothing at all
  committed on the row it then holds
- **THEN** the content at the roster place is byte-for-byte what it was after the screen was opened
- **AND** the day screen says it is keeping its roster

### Requirement: A day screen adds what is committed in a row's total entry, and keeps the change before the day view says so

A day screen SHALL add, on one of its rows, the amount committed in its total entry to the additions
that day holds. A commit in a total entry SHALL always be an addition, never a replacement or a
take-back; one that says nothing SHALL keep nothing, take nothing back and change nothing. Which
entry a commit lands in SHALL be decided by the row it was made on and never by the text, for all
four kinds. The entry SHALL be the one the row offers, asked as of the today the screen was handed.
The change SHALL be kept at the record place before the day view says so, and the day view SHALL
then be formed again. Adding SHALL otherwise answer as entering a number does, under the requirement
on entering a number, except where this requirement or the one on reading a total entry states
otherwise.

#### Scenario: adding on a total row makes the day screen say what the day has added

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "30" is committed on its one
  row
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** the day view says the commitment is not kept on that date

#### Scenario: a day's additions accumulate rather than replace one another

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "30" is committed on its one
  row and then "30" again on the row it then holds
- **THEN** the entry the row the day screen then holds offers says "60 of 120"
- **AND** committing "45.5" on the row it then holds leaves it saying "105.5 of 120"

#### Scenario: an addition past the target keeps the day and says the true sum

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "120" and then "30" are
  committed on the row it holds each time
- **THEN** the day screen's day view says the commitment is kept on that date
- **AND** the entry its row offers says "150 of 120"

#### Scenario: an addition that cannot be kept is refused and leaves the day view as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Protein" of the total
  kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and "30" is committed on its one row
- **THEN** committing is refused with an error
- **AND** the entry the row the day screen then holds offers still says "0 of 120"
- **AND** a day screen opened afterwards at the same place says the same

#### Scenario: committing nothing at all in a total entry keeps nothing and takes nothing back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" and then "90" are committed
  on the row it holds each time; and nothing at all is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers still says "120 of 120"
- **AND** the day view still says the commitment is kept on that date
- **AND** committing two spaces, and then a text of three line breaks, leaves it saying the same
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: adding on a row the day screen's day view does not hold changes nothing

- **WHEN** two day screens of a commitment named "Protein" of the total kind with a target of 120,
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, are opened at one
  place where nothing has been kept, the first as of Monday 31 August 2026 and the second as of
  Wednesday 2 September 2026, and "30" is committed on the first screen in the second screen's row's
  total entry
- **THEN** the entry the first day screen's row offers still says "0 of 120"
- **AND** a day screen opened afterwards at that place as of Wednesday 2 September 2026 says "0 of
  120" too

#### Scenario: committing on a row that offers no total entry changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind and a commitment named "Protein" of the total
  kind with a target of 120, both on a schedule listing all seven weekdays and both kept from
  1 January 2026; "30" is committed on the row named "Gym"; the screen is then moved to the day
  after; and "30" is committed on the row it then holds named "Protein"
- **THEN** the day screen's day view says neither commitment is kept on Tuesday 1 September 2026
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says neither is
  kept on that date, and says "0 of 120" for "Protein"

#### Scenario: a commit is read as the entry the row it was made on offers, for all four kinds

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind, one named "Weight" of the number kind with a
  range of 40 to 150, one named "Journal" of the note kind and one named "Protein" of the total kind
  with a target of 120, in that order and all on a schedule listing Monday, Wednesday and Saturday
  and all kept from 1 January 2026, and "120" is committed in turn on each of the four rows the
  screen holds at the time
- **THEN** the entry the second row of the screen it then holds offers says the number 120
- **AND** the entry the third row offers says the note "120"
- **AND** the entry the fourth row offers says "120 of 120"
- **AND** the day view says "Gym" is not kept and the other three are kept on that date

#### Scenario: adding on a day screen that is not keeping a record changes nothing and keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and
  "30" is committed on its one row
- **THEN** the entry its row offers still says "0 of 120"
- **AND** it still says it is not keeping a record
- **AND** the content at that place is byte-for-byte what it was before the screen was opened

#### Scenario: adding on one row leaves the other rows of the day as they were

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind, a commitment named "Protein" of the total kind
  with a target of 120 and a commitment named "Water" of the total kind with a target of 2, in that
  order, all three on a schedule listing all seven weekdays and all kept from 1 January 2026, and
  "120" is committed on the second row
- **THEN** the day screen's day view holds three rows in that same order
- **AND** only the second says its commitment is kept
- **AND** the entry the third row offers says "0 of 2"

#### Scenario: adding on a day a day screen has moved back to keeps it on that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing all seven weekdays, kept from 1 January 2026; it is moved to the day before; and "120" is
  committed on its one row
- **THEN** its day view says the commitment is kept on Sunday 30 August 2026
- **AND** a day screen opened afterwards at that place as of Sunday 30 August 2026 says the
  commitment is kept on that date
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says the
  commitment is not kept on that date, and says "0 of 120"

#### Scenario: adding writes nothing to the roster's place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place and a roster place
  where nothing has been kept, of a commitment named "Protein" of the total kind with a target of
  120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; the roster
  place is read once the screen has been opened; and "30" is then committed on its one row, and
  nothing at all committed on the row it then holds
- **THEN** the content at the roster place is byte-for-byte what it was after the screen was opened
- **AND** the day screen says it is keeping its roster

### Requirement: A day screen answers whether it offers the way back to today

A day screen SHALL say whether it offers the way back to the today it was handed, offering it where
the day being shown is not that today and none where it is. The answer SHALL be about the control
and not the position, about the day being shown and the today and nothing else, and MUST NOT stand
in for whether the screen shows its today. It SHALL take no day from the caller and read no clock,
and SHALL be measured against the today last handed. It SHALL follow the day being shown, a move
with nowhere to go MUST NOT change it, and a new today SHALL be answered against the days as they
stand. Offering none SHALL NOT make the way back a refusal: it is still done from whatever day the
screen shows, including its today, leaving it showing that today.

#### Scenario: a day screen moved into the past offers the way back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day before
- **THEN** it offers the way back to today
- **AND** a screen moved to the day before three times offers it too

#### Scenario: a day screen moved into the future offers the way back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day after
- **THEN** it offers the way back to today
- **AND** a screen moved to the day after three times offers it too

#### Scenario: a day screen offers no way back to today once it has gone back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before twice; and it is then sent back to today
- **THEN** it offers no way back to today
- **AND** a second screen opened the same way, moved to the day before and then to the day after,
  offers none either

#### Scenario: going back to today on a day screen that offers no way back leaves it showing that today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is sent back to today without having been moved
- **THEN** its day picker opens on Monday 31 August 2026
- **AND** it offers no way back to today, exactly as it did before

#### Scenario: a day screen shown again on a later day offers the way back to today from the day it stayed on

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before; and the app is then shown again as of Wednesday
  2 September 2026
- **THEN** it offers the way back to today
- **AND** sent back, its day picker opens on Wednesday 2 September 2026 and it offers no way back

#### Scenario: a day screen showing its today when the app is shown again on a later day offers no way back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the app is shown again as of Wednesday 2 September 2026 without it having been
  moved
- **THEN** it offers no way back to today
- **AND** its day picker opens on Wednesday 2 September 2026

#### Scenario: a day screen the day it is showing has caught up with offers no way back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day after; and the app is then shown again as of Tuesday
  1 September 2026
- **THEN** it offers no way back to today
- **AND** its day picker opens on Tuesday 1 September 2026

#### Scenario: a day screen whose move had nowhere to go offers no way back to today

- **WHEN** a day screen is opened as of Saturday 1 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583, and it is moved to the day before; and a second day screen is opened the same way
  as of Friday 31 December 9999 and moved to the day after
- **THEN** neither offers a way back to today
- **AND** the first, moved to the day after, offers the way back

#### Scenario: a day screen that cannot read its record says whether it offers the way back to today like any other

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes that
  is not what a record is written as, of a commitment named "Journaling" on a schedule listing all
  seven weekdays, kept from 1 January 2026, and it is moved to the day before
- **THEN** it offers the way back to today
- **AND** it says it is not keeping a record
- **AND** sent back, it offers no way back to today and still says it is not keeping a record

### Requirement: A day view says its day as its weekday

A day view SHALL say the day it is of in words, as its day title, read off its date and off nothing
else: it MUST NOT read a clock, and MUST NOT depend on the rows it holds or on whether any is kept.
It SHALL be the name of the weekday its date falls on and nothing else — no day of the month, no
month, no year, no word in front of it — and the names SHALL be the three-letter "Mon", "Tue",
"Wed", "Thu", "Fri", "Sat" and "Sun". It SHALL NOT depend on any other day: two dates on the same
weekday SHALL have the same title. The names SHALL be this capability's own English and MUST NOT
come from the device's language, region, locale or calendar. What day of the month, month and year
it is SHALL be said by the day picker, never here.

#### Scenario: every weekday is said by its own name

- **WHEN** the day views of the seven days from Monday 31 August 2026 to Sunday 6 September 2026 are
  each asked what their day is
- **THEN** they say "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" and "Sun"

#### Scenario: two day views whose dates fall on the same weekday say the same day title

- **WHEN** the day views of Monday 31 August 2026, of Monday 15 June 2026 and of Monday 3 January
  1583 are each asked what their day is
- **THEN** each of them says "Mon"

#### Scenario: a day view says its day in the first supported year and in the last

- **WHEN** a day view of Saturday 1 January 1583 is asked what its day is
- **THEN** it says "Sat"
- **AND** a day view of Friday 31 December 9999 says "Fri"

#### Scenario: a day view says the leap day of a leap year

- **WHEN** a day view of Tuesday 29 February 2028 is asked what its day is
- **THEN** it says "Tue"

#### Scenario: a day view holding no rows says its day just the same

- **WHEN** a day view of no commitments at all on Wednesday 2 September 2026 is asked what its day is
- **THEN** it holds no rows
- **AND** it says "Wed"

### Requirement: A day screen says which day it is showing

A day screen SHALL say the day it is showing, and that SHALL be its day view's day title, to which
it adds nothing; the words SHALL follow the day being shown and nothing else. They MUST NOT follow
the today the screen was handed, and no word, mark or spacing SHALL tell a screen showing its today
from one showing any other day; whether it is that today is answered by *A day screen answers
whether it offers the way back to today*. A day screen MUST NOT read a clock to say its day, and
SHALL go on saying the day it was handed until it is moved, a day is picked, or the app is shown
again. A tick made on it MUST NOT change what it says the day is. It SHALL say its day whether or
not it is keeping a record or a roster.

#### Scenario: a day screen says its day the same way whether or not it is showing its today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day before seven times, onto Monday 24 August 2026
- **THEN** it says the day is "Mon", exactly as it did before it was moved
- **AND** it offers the way back to today, where before it was moved it offered none

#### Scenario: a day screen says the day its own day view says

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026
- **THEN** what it says the day is is what its day view says

#### Scenario: a day screen says the day it was handed rather than the day it really is

- **WHEN** a day screen is opened as of Monday 3 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583
- **THEN** it says the day is "Mon"
- **AND** a day screen opened the same way as of Friday 31 December 9999 says the day is "Fri"

#### Scenario: a day screen shown again on a later day says that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the app is then shown again as of Tuesday 1 September 2026
- **THEN** it says the day is "Tue"

#### Scenario: a day screen moved to another day says that day

- **WHEN** a day screen is opened as of Thursday 3 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day before
- **THEN** it says the day is "Wed"
- **AND** moving it to the day before again makes it say the day is "Tue"

#### Scenario: a day screen sent back onto today says that today's weekday

- **WHEN** a day screen is opened as of Thursday 3 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before twice; and it is then sent back to today
- **THEN** it says the day is "Thu"

#### Scenario: a day screen showing a day picked on its day picker says that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and Wednesday 10 June 2026 is picked
- **THEN** it says the day is "Wed"

#### Scenario: a day screen that cannot read its record still says the day

- **WHEN** a day screen is opened as of Monday 31 August 2026, of a commitment named "Journaling" on
  a schedule listing all seven weekdays, kept from 1 January 2026, at a place holding a run of bytes
  that is not a record
- **THEN** it says it is not keeping a record
- **AND** it says the day is "Mon"

#### Scenario: a day screen says the same day after a tick is made on it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and its one row is ticked
- **THEN** it says the day is "Mon", exactly as it did before the tick
