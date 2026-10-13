## ADDED Requirements

### Requirement: A day screen's day picker opens on the day it is showing and reaches back to the first supported date

A day screen SHALL say its day picker as one answer of two days: the day it opens on and the earliest
day it reaches. The day it opens on SHALL be the day being shown, whatever put it there. The earliest
day it reaches SHALL be the first supported date, 1 January 1583, whatever its roster, its record and
its one-offs hold, whether or not any of them can be read, and whatever day is being shown or was
last handed as the today; it SHALL never move. The answer SHALL take no day from the caller and read
no clock, and MUST NOT give out the today the screen was last handed, under any name. Nothing SHALL
be answered about whether the day picker is offered.

#### Scenario: a day screen's day picker opens on the day it is showing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is not moved
- **THEN** its day picker opens on Monday 31 August 2026
- **AND** moved to the day before, its day picker opens on Sunday 30 August 2026
- **AND** moved from there to the day after twice, its day picker opens on Tuesday 1 September 2026

#### Scenario: a day screen's day picker reaches back to the first supported date and opens on the last

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026
- **THEN** its day picker reaches back to 1 January 1583
- **AND** a second day screen opened the same way as of Friday 31 December 9999 opens on Friday
  31 December 9999 and reaches back to 1 January 1583
- **AND** a third opened the same way as of Saturday 1 January 1583 opens on Saturday 1 January 1583
  and reaches back to Saturday 1 January 1583

#### Scenario: a day screen's day picker reaches back to the first supported date whatever its roster holds

- **WHEN** a commitment named "Gym" kept from 1 January 2026 and one named "Run" kept from 1 March
  2026, both on a schedule listing all seven weekdays, are taken on at a roster place; "Gym" is
  deleted there; and a day screen of no commitments at all is opened at that roster place as of
  Monday 31 August 2026, at a record place where nothing has been kept
- **THEN** its day picker reaches back to 1 January 1583
- **AND** a day screen opened as of that same day at a roster place holding a run of bytes that is
  not what a roster is written as, and one at a roster place holding nothing at all and handed no
  commitments at all, each reach back to 1 January 1583
- **AND** after a commitment named "Journaling" on that same schedule, kept from 1 January 2010, is
  then taken on at the first one's roster place by something else and the app is shown again as of
  that same day, the first one still reaches back to 1 January 1583

### Requirement: A day screen's week strip marks the earliest day anything on its roster is kept from, on every week strip it says

A day screen SHALL mark, on every week strip it says, its own and those a page either way would
give, the earliest day anything on its roster is kept from, and SHALL mark no other day so. That day
SHALL be the `commitment` capability's answer for the roster the screen last read or kept, stopped
commitments counting and deleted ones not; a day screen MUST NOT recompute it. It SHALL be marked
wherever it falls, before, on or after the today, the day being shown included. Where the roster
answers no such day, because it holds no commitment or cannot be read, no day SHALL be so marked.
The mark SHALL follow the roster each time it is read again, SHALL NOT move the day being shown, and
MUST NOT depend on the record, the one-offs, the happenings or the rows of any day.

#### Scenario: a day screen's week strip marks the earliest day anything on its roster is kept from, though nothing is due on it

- **WHEN** a day screen is opened as of Wednesday 2 September 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  Tuesday 1 September 2026, and one named "Journaling" on a schedule listing all seven weekdays,
  kept from Friday 4 September 2026
- **THEN** its week strip marks Tuesday 1 September 2026 as the earliest day anything on its roster
  is kept from, and no other day so
- **AND** it offers Tuesday 1 September 2026

#### Scenario: a day screen's week strip marks the earliest day kept from where it lies after the today

- **WHEN** a day screen is opened as of Wednesday 2 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 4 September 2026
- **THEN** its week strip marks Friday 4 September 2026 as the earliest day anything on its roster
  is kept from, and no other day so
- **AND** it marks Wednesday 2 September 2026 as shown and as the today

#### Scenario: a day screen's week strip marks the earliest day kept from where it is the day shown and the today

- **WHEN** a day screen is opened as of Friday 4 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 4 September 2026
- **THEN** its week strip marks Friday 4 September 2026 as shown, as the today and as the earliest
  day anything on its roster is kept from
- **AND** moved to the day after, its week strip marks Saturday 5 September 2026 as shown, and still
  marks Friday 4 September 2026 as the today and as that earliest day

#### Scenario: a day screen's week strip marks the earliest day kept from on the week strip a page either way would give

- **WHEN** a day screen is opened as of Wednesday 9 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 4 September 2026
- **THEN** the week strip it says of the week before marks Friday 4 September 2026 as the earliest
  day anything on its roster is kept from, and its own week strip marks no day so
- **AND** a day screen opened the same way as of Wednesday 26 August 2026 marks Friday 4 September
  2026 so on the week strip it says of the week after, and no day so on its own

#### Scenario: a day screen's week strip marks the earliest day kept from of a commitment its roster has stopped keeping, and not of one it has deleted

- **WHEN** a commitment named "Gym" kept from Tuesday 1 September 2026 and one named "Journaling"
  kept from Friday 4 September 2026, both on a schedule listing all seven weekdays, are taken on at
  a roster place; "Gym" is stopped there as of Thursday 3 September 2026; and a day screen of no
  commitments at all is opened at that roster place as of Saturday 5 September 2026, at a record
  place where nothing has been kept
- **THEN** its week strip marks Tuesday 1 September 2026 as the earliest day anything on its roster
  is kept from
- **AND** a day screen opened the same way at a roster place of its own, where "Gym" is deleted
  rather than stopped, marks Friday 4 September 2026 so, and not Tuesday 1 September 2026

#### Scenario: a day screen whose roster holds nothing or cannot be read marks no day as the earliest kept from

- **WHEN** a day screen is opened as of Wednesday 2 September 2026, at a roster place holding a run
  of bytes that is not what a roster is written as, at a record place where nothing has been kept,
  of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from Tuesday
  1 September 2026
- **THEN** its week strip marks no day as the earliest day anything on its roster is kept from, and
  nor does either week strip it says of the week before and the week after
- **AND** a day screen opened as of that same day at a roster place holding nothing at all, at a
  record place where nothing has been kept, handed no commitments at all, marks no day so

#### Scenario: a day screen's week strip follows the earliest day kept from once its roster is read again

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 4 September 2026, is taken on at a roster place; a day screen of no commitments at all is
  opened at that roster place as of Wednesday 2 September 2026, at a record place where nothing has
  been kept; a commitment named "Gym" on that same schedule, kept from Tuesday 1 September 2026, is
  then taken on at that roster place by something else; and the screen is returned to
- **THEN** its week strip marks Tuesday 1 September 2026 as the earliest day anything on its roster
  is kept from, and not Friday 4 September 2026
- **AND** before it was returned to, its week strip marked Friday 4 September 2026 so
- **AND** its day picker still opens on Wednesday 2 September 2026

#### Scenario: a day screen's week strip marks the earliest day kept from whatever its record and its one-offs hold

- **WHEN** a one-off named "Renew passport" on 31 August 2026 is added at a one-off place, and a day
  screen of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 4 September 2026, is opened at that one-off place as of Wednesday 2 September 2026, at a
  record place holding a run of bytes that is not what a record is written as and a roster place
  where nothing has been kept
- **THEN** its week strip marks Friday 4 September 2026 as the earliest day anything on its roster
  is kept from, and not Monday 31 August 2026
- **AND** its One-offs group holds one row, named "Renew passport", and it says it is not keeping a
  record

### Requirement: A day screen shows any day picked on its day picker

A day screen SHALL show any calendar date it is given, a date earlier than anything on its roster
is kept from included, and SHALL refuse none, whatever its roster holds and whether or not it can
be read. Showing a picked day SHALL give what a move gives: the day view formed for the
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
  that order and of one-offs holding nothing, on Monday 15 June 2026 as of that same day, from a
  history that has taken no tick
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
  1 January 2026; and Saturday 1 January 1583, the earliest day its day picker reaches, is picked
- **THEN** its day picker opens on Saturday 1 January 1583 and reaches back to Saturday 1 January
  1583
- **AND** its day view holds no rows, and it offers the way back to today

#### Scenario: a day screen shows a day picked earlier than anything on its roster is kept from

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; and Wednesday 31 December 2025 is picked
- **THEN** its day view is the same day view as one formed directly of that commitment and of
  one-offs holding nothing, on Wednesday 31 December 2025 as of Monday 31 August 2026, from a
  history that has taken no tick, and it holds no rows
- **AND** its day picker opens on Wednesday 31 December 2025, and it offers the way back to today
- **AND** a day screen opened the same way but at a roster place holding a run of bytes that is not
  what a roster is written as, on which Wednesday 31 December 2025 is picked, has its day picker
  open on Wednesday 31 December 2025

#### Scenario: a day screen picking the day it is already showing changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place that can be read
  from but not written to and where nothing has been kept, of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked
  and refused; and Monday 31 August 2026 is picked
- **THEN** its day picker still opens on Monday 31 August 2026, and it offers no way back to today
- **AND** it is still telling on that row that the change could not be kept
- **AND** its day view is the same day view as the one it held before that day was picked

#### Scenario: a day screen picking a day draws the commitments its roster had not stopped keeping on that day

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and both kept from 1 January 2026, are taken on at a roster place in that order; "Gym" is
  stopped there as of Monday 15 June 2026; and a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept
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

#### Scenario: a day screen offers the way back to today once a day other than that today is picked

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and Monday 15 June 2026 is picked
- **THEN** it offers the way back to today
- **AND** picking Monday 31 August 2026 from there, it offers no way back to today

### Requirement: A day screen draws the one-offs held at its one-off place as of the today it was handed

A day screen SHALL form its day view, and the day views either side of it, from the one-offs held at
its one-off place as of the today it was last handed, and never as of the day it is showing. It
SHALL open that place when it is opened and when the app is shown again, and at no other moment:
being moved, being sent back to today, a day being picked, being returned to and saying the day
either side SHALL NOT open it, save being returned to from a commitments screen that has restored a
copy, which SHALL. Opening it SHALL write nothing there and take nothing on. A day
screen that could read its one-offs SHALL say it is keeping them.

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

### Requirement: A day screen's week strip offers every day holding a date but the one it is showing

A day of a day screen's week strip SHALL be offered exactly where it holds a date and is not the day
being shown; no other day SHALL be offered. A day after the today, and a day earlier than anything
on the screen's roster is kept from, SHALL each be offered as any other day is, whatever the roster
holds and whether or not it can be read. Showing a day the strip offers SHALL be showing a picked
day, as *A day screen shows any day picked on its day picker* states.

#### Scenario: a day screen's week strip offers every day of its week but the one it is showing

- **WHEN** a day screen is opened as of Wednesday 2 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026
- **THEN** its week strip offers Monday 31 August, Tuesday 1, Thursday 3, Friday 4, Saturday 5 and
  Sunday 6 September 2026
- **AND** it does not offer Wednesday 2 September 2026

#### Scenario: a day screen's week strip offers the days of its week before anything on its roster is kept from

- **WHEN** a day screen is opened as of Saturday 5 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 4 September 2026
- **THEN** its week strip offers Monday 31 August to Friday 4 September 2026 and Sunday 6 September
  2026, and does not offer Saturday 5 September 2026
- **AND** a day screen opened the same way as of Wednesday 2 September 2026, but at a roster place
  holding a run of bytes that is not what a roster is written as, offers every day of its week but
  Wednesday 2 September 2026
- **AND** showing the day the first one's week strip holds as Monday 31 August 2026 gives a day view
  holding no rows, and its week strip then marks that day as shown

#### Scenario: a day screen's week strip offers no day outside the calendar

- **WHEN** a day screen is opened as of Saturday 1 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026
- **THEN** its week strip offers Sunday 2 January 1583, and no other day
- **AND** a day screen opened the same way as of Friday 31 December 9999 offers Monday 27 to
  Thursday 30 December 9999, and no other day

#### Scenario: a day screen shows a day tapped on its week strip

- **WHEN** a day screen is opened as of Thursday 3 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the day its week strip holds as Monday 31 August 2026 is shown
- **THEN** its day view is the same day view as one formed directly of that commitment and of
  one-offs holding nothing, on Monday 31 August 2026 as of Thursday 3 September 2026, from a history
  that has taken no tick, and it offers the way back to today
- **AND** its week strip marks Monday 31 August 2026 as shown and Thursday 3 September 2026 as the
  today
- **AND** showing the day its week strip holds as Sunday 6 September 2026 from there marks that day
  as shown

### Requirement: A day screen says the week strip a page either way would give, of the week that page would land in

A day screen SHALL say two further week strips, one for each way it pages, each of the week that
page would land in. Each SHALL hold
the days that page would leave its week strip holding, SHALL mark the today where that week holds
it, and SHALL mark no day as shown. Each SHALL offer what that page would leave its week strip
offering and, besides, the day that page would land on. Each SHALL be said where that page would
move the day being shown, and SHALL be absent exactly where that page would leave the screen as it
was. Saying either SHALL read neither place again and SHALL change nothing about the screen, what
it is telling included. Both SHALL follow the day being shown, the today and the roster as they
stand.

#### Scenario: a day screen's week strip either side holds the week a page there would land in and marks no day as shown

- **WHEN** a day screen is opened as of Wednesday 16 September 2026, at a place where nothing has
  been kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 4 September 2026, and it is paged to the week before
- **THEN** the week strip it says of the week before holds Monday 31 August 2026 to Sunday
  6 September 2026, marks no day as shown and none as the today, and offers every day it holds
- **AND** the week strip it says of the week after holds Monday 14 September 2026 to Sunday
  20 September 2026, marks Wednesday 16 September 2026 as the today and no day as shown, and offers
  every day it holds

#### Scenario: a day screen says no week strip either side where a page there would leave it as it was

- **WHEN** a day screen is opened as of Saturday 1 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026
- **THEN** it says no week strip of the week before, and says one of the week after
- **AND** a day screen opened the same way as of Thursday 30 December 9999 says no week strip of the
  week after, and says one of the week before

#### Scenario: saying the week strip either side leaves a day screen exactly as it was

- **WHEN** a day screen is opened as of Wednesday 16 September 2026, at a record place that can be
  read from but not written to and where nothing has been kept, of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked
  and refused; and the week strips it says of the week before and of the week after are both read
- **THEN** its day view is the same day view as the one it held before they were read, and its day
  picker opens on Wednesday 16 September 2026
- **AND** it is still telling on that row that the change could not be kept, and it offers no way
  back to today

## MODIFIED Requirements

### Requirement: A day screen says the week of the day it is showing as its week strip

A day screen SHALL say its week strip: the seven days of the week the day being shown lies in,
Monday first and Sunday last. Each day SHALL say its letter, "M", "T", "W", "T", "F", "S" and "S" in
that order, and its date; a day outside the calendar the screen supports SHALL keep its letter and
hold no date. The letters SHALL be this capability's own English and MUST NOT come from the device's
language, region, locale or calendar. The strip SHALL mark the day being shown as shown and the
today last handed where that week holds it, and SHALL mark nothing else but days away and the
earliest kept-from day. It SHALL follow the day being shown and the today, read no clock and take
no day from the caller, and what it holds and marks MUST NOT depend on the record or on the rows of
any day.

#### Scenario: a day screen says the seven days of its week, Monday first, each by its letter

- **WHEN** a day screen is opened as of Wednesday 2 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026
- **THEN** its week strip holds Monday 31 August 2026 to Sunday 6 September 2026, in that order,
  saying "M", "T", "W", "T", "F", "S" and "S"
- **AND** Wednesday 2 September 2026 is marked as shown and as the today, and no other day is marked

#### Scenario: a day screen's week strip marks the today apart from the day it is showing

- **WHEN** a day screen is opened as of Thursday 3 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day before twice
- **THEN** its week strip still holds Monday 31 August 2026 to Sunday 6 September 2026
- **AND** Tuesday 1 September 2026 is marked as shown and Thursday 3 September 2026 as the today, and
  no other day is marked

#### Scenario: a day screen moved into another week holds that week in its strip and marks no day as the today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day before
- **THEN** its week strip holds Monday 24 August 2026 to Sunday 30 August 2026, with Sunday 30 August
  2026 marked as shown and no day marked as the today
- **AND** moved to the day after, its week strip holds Monday 31 August 2026 to Sunday 6 September
  2026, with Monday 31 August 2026 marked as shown and as the today

#### Scenario: a day screen's week strip runs across the turn of a month and a year

- **WHEN** a day screen is opened as of Thursday 31 December 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026
- **THEN** its week strip holds Monday 28 December 2026 to Sunday 3 January 2027, in that order,
  saying "M", "T", "W", "T", "F", "S" and "S"

#### Scenario: a day screen's week strip holds no date for a day outside the calendar

- **WHEN** a day screen is opened as of Saturday 1 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583
- **THEN** its week strip holds seven days saying "M", "T", "W", "T", "F", "S" and "S", the first
  five holding no date and none of them marked, then Saturday 1 January 1583 marked as shown and as
  the today, then Sunday 2 January 1583
- **AND** a day screen opened the same way as of Friday 31 December 9999 holds Monday 27 December
  9999 to Friday 31 December 9999, then two days saying "S" and holding no date

#### Scenario: a day screen shown again on a later day follows it in its week strip only where it was showing its today

- **WHEN** a day screen is opened as of Sunday 6 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the app is then shown again as of Monday 7 September 2026
- **THEN** its week strip holds Monday 7 September 2026 to Sunday 13 September 2026, with Monday 7
  September 2026 marked as shown and as the today
- **AND** a second day screen opened the same way, moved to the day before and then shown again as
  of Monday 7 September 2026, holds Monday 31 August 2026 to Sunday 6 September 2026, with Saturday
  5 September 2026 marked as shown and no day marked as the today

#### Scenario: a day screen's week strip is the same whatever its record holds and whatever is ticked

- **WHEN** a day screen is opened as of Wednesday 2 September 2026, at a record place holding a run
  of bytes that is not what a record is written as, of a commitment named "Journaling" on a schedule
  listing all seven weekdays, kept from 1 January 2026
- **THEN** its week strip is the same week strip as that of a day screen opened the same way at a
  place where nothing has been kept
- **AND** that second day screen's week strip is the same after its one row is ticked as before

### Requirement: A day screen pages to the week before and the week after, keeping the weekday it is showing

A day screen SHALL page to the week after the week the day being shown lies in, and to the week
before it, making the day being shown that week's day of the same weekday, whether or not that week
holds the today. Where that day lies outside the calendar, the page SHALL land instead on whichever
of the calendar's first and last dates that week holds; where that week holds no date, it SHALL
leave the screen exactly as it was. A page SHALL give what a move gives: the day
view of the day landed on, formed from the commitments its roster had not stopped keeping there and
the record held. It SHALL read neither place again nor move the today. A page that moves the day
SHALL be a change of the day being shown wherever this capability speaks of one.

#### Scenario: a day screen paged to the week after lands on the same weekday of that week

- **WHEN** a day screen is opened as of Wednesday 16 September 2026, at a place where nothing has
  been kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is paged to the week after
- **THEN** its day view is the same day view as one formed directly of that commitment and of
  one-offs holding nothing, on Wednesday 23 September 2026 as of Wednesday 16 September 2026, from a
  history that has taken no tick, and it offers the way back to today
- **AND** its week strip holds Monday 21 September 2026 to Sunday 27 September 2026, with Wednesday
  23 September 2026 marked as shown and no day marked as the today
- **AND** paged to the week after again, its day picker opens on Wednesday 30 September 2026

#### Scenario: a day screen paged to the week before lands on the same weekday of that week

- **WHEN** a day screen is opened as of Wednesday 16 September 2026, at a place where nothing has
  been kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is paged to the week before
- **THEN** its day picker opens on Wednesday 9 September 2026, and it offers the way back to today
- **AND** paged to the week before again, its day picker opens on Wednesday 2 September 2026
- **AND** sent back to today from there, its day picker opens on Wednesday 16 September 2026

#### Scenario: a day screen paged to the week before passes the earliest day anything on its roster is kept from, keeping the weekday

- **WHEN** a day screen is opened as of Wednesday 16 September 2026, at a place where nothing has
  been kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 4 September 2026, and it is paged to the week before three times
- **THEN** its day picker opens on Wednesday 26 August 2026, and its day view holds no rows
- **AND** its week strip holds Monday 24 August 2026 to Sunday 30 August 2026, with Wednesday
  26 August 2026 marked as shown, and offers every other day it holds
- **AND** paged to the week before again, its day picker opens on Wednesday 19 August 2026

#### Scenario: a day screen paged into the week holding its today lands on the same weekday and not on the today

- **WHEN** a day screen is opened as of Wednesday 16 September 2026, at a place where nothing has
  been kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day after twice; and it is paged to the week after and then to
  the week before
- **THEN** its day picker opens on Friday 18 September 2026, and it offers the way back to today
- **AND** its week strip marks Friday 18 September 2026 as shown and Wednesday 16 September 2026 as
  the today
- **AND** a second day screen opened the same way, moved to the day before twice and paged to the
  week before and then to the week after, has its day picker open on Monday 14 September 2026

#### Scenario: a day screen paged to the week after from the last week of the calendar is left exactly as it was

- **WHEN** a day screen is opened as of Thursday 30 December 9999, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is paged to the week after
- **THEN** its day view is the same day view as the one it held when it was opened, and its day
  picker opens on Thursday 30 December 9999
- **AND** a second day screen opened the same way as of Wednesday 22 December 9999 and paged to the
  week after has its day picker open on Wednesday 29 December 9999

#### Scenario: a day screen paged to the week after onto a day past the calendar lands on its last date

- **WHEN** a day screen is opened as of Saturday 25 December 9999, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is paged to the week after
- **THEN** its day picker opens on Friday 31 December 9999, and it offers the way back to today
- **AND** its week strip marks Friday 31 December 9999 as shown, and no day as the today

#### Scenario: a day screen paged back into the week of the first supported date lands on that date

- **WHEN** a day screen is opened as of Wednesday 5 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583, and it is paged to the week before
- **THEN** its day picker opens on Saturday 1 January 1583
- **AND** paged to the week before again, its day view is the same day view as the one it held
  before that page, and its day picker still opens on Saturday 1 January 1583

#### Scenario: paging a day screen does not read its roster or its record again

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Wednesday 16 September 2026, at a record place where nothing has been
  kept; a commitment named "Gym" on that same schedule, kept from 1 January 2026, is then taken on
  at that roster place by something else, and a tick for "Journaling" on Wednesday 9 September 2026
  is kept at that record place by something else; and it is paged to the week before
- **THEN** its day view holds one row, named "Journaling"
- **AND** that row says the commitment is not kept on Wednesday 9 September 2026
- **AND** it says it is keeping a record and a roster, exactly as it did before it was paged

#### Scenario: a day screen paged to another week draws the commitments its roster had not stopped keeping on the day it lands on

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and both kept from 1 January 2026, are taken on at a roster place in that order; "Gym" is
  stopped there as of Thursday 10 September 2026; and a day screen of no commitments at all is
  opened at that roster place as of Wednesday 16 September 2026, at a record place where nothing
  has been kept
- **THEN** paged to the week before, its day view holds two rows, named "Gym" and then "Journaling"
- **AND** paged to the week after from there, its day view holds one row, named "Journaling"

#### Scenario: a day screen stops telling what it was telling when a page moves the day it is showing

- **WHEN** a day screen is opened as of Wednesday 16 September 2026, at a record place that can be
  read from but not written to and where nothing has been kept, of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked
  and refused; and it is paged to the week after
- **THEN** it tells nothing on any row
- **AND** a one-off named "Call mum" on 16 September 2026 being added at a one-off place, a day
  screen of no commitments at all opened at that one-off place as of Wednesday 16 September 2026, at
  a record place and a roster place where nothing has been kept, on which "Call mum" is committed in
  its one-off entry and refused and which is then paged to the week after, tells nothing under its
  one-off entry

## REMOVED Requirements

### Requirement: A day screen's reach bounds its day picker and is read again whenever its roster is

**Reason**: The day picker has no floor left to bound; the roster is read again for the week strip's
mark, which *A day screen's week strip marks the earliest day anything on its roster is kept from, on
every week strip it says* states (ADR-1048).
**Migration**: None on disk; nothing a day screen keeps moves.

### Requirement: A day screen says the day its day picker opens on and the earliest day it reaches, from what its roster still holds

**Reason**: The earliest day is the first supported date whatever the roster holds; *A day screen's
day picker opens on the day it is showing and reaches back to the first supported date* replaces it.
**Migration**: None on disk.

### Requirement: A page to the week before lands on no day earlier than the day picker reaches

**Reason**: A page back keeps its weekday as far as the calendar goes; landing on its first date is
stated in *A day screen pages to the week before and the week after, keeping the weekday it is
showing*.
**Migration**: None on disk.

### Requirement: A day screen shows a day picked on its day picker

**Reason**: Its scenarios about the earliest day the day picker reached are withdrawn, which
`openspec` allows only by removing the requirement; it is carried whole, less those, as *A day screen shows any day picked on its day picker*.
**Migration**: None on disk.

### Requirement: A day screen draws the one-offs at its one-off place as of the today it was handed

**Reason**: Its scenarios about the earliest day the day picker reached are withdrawn, which
`openspec` allows only by removing the requirement; it is carried whole, less those, as *A day screen draws the one-offs held at its one-off place as of the today it was handed*.
**Migration**: None on disk.

### Requirement: A day screen's week strip offers every day it can show but the one it is showing

**Reason**: Its scenarios about the earliest day the day picker reached are withdrawn, which
`openspec` allows only by removing the requirement; it is carried whole, less those, as *A day screen's week strip offers every day holding a date but the one it is showing*.
**Migration**: None on disk.

### Requirement: A day screen says the week strip a page either way would give, marking no day as shown

**Reason**: Its scenarios about the earliest day the day picker reached are withdrawn, which
`openspec` allows only by removing the requirement; it is carried whole, less those, as *A day screen says the week strip a page either way would give, of the week that page would land in*.
**Migration**: None on disk.
