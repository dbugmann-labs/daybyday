## MODIFIED Requirements

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
SHALL hold the day it is showing until it is moved, a day is picked on its day picker, or the app is
shown again, and SHALL be moved onto another day by nothing else, neither by time passing nor by a
tick made on it; its today SHALL be replaced only when the app is shown again.

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

### Requirement: A day screen draws the commitments its roster had not stopped keeping on the day it is showing

A day screen SHALL form every day view from the commitments the roster at its roster place had not
stopped keeping on the day shown, in the roster's groups and order. Every day view SHALL ask the
roster again for the day then shown: when the screen is opened, moved, sent back to today, shown
again or returned to, and when a tick is made. The roster asked SHALL be the one read when the app
was last shown or the screen last returned to, whichever happened later, with any change kept since;
asking MUST NOT open the place. A commitment the roster stopped or removed SHALL have a row up to
and including the day it was kept until, and none after; a day screen MUST NOT tell the two apart in
any way: not in the row drawn, in what it says or offers, nor in its group. A group with nothing due
produces no group, as *A day view is a value made of its groups and its date* states.

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

## REMOVED Requirements

### Requirement: A day view is the commitments due on a date, each with whether it is kept

**Reason**: Added back below as *A day view holds the commitments due on a date, each with whether
it is kept*, without scenarios another under it already asserts.
**Migration**: Dropped with their tests: `a commitment ticked on the date has a row that says it is
kept` and `a commitment not ticked on the date has a row that says it is not kept`. The rest is
carried verbatim.

### Requirement: A row offers the tick that keeps its commitment, and refuses one for a day that has not arrived

**Reason**: Added back below as *A row offers the tick that keeps its commitment, and offers none
for a day that has not arrived*, without a scenario another under it already asserts.
**Migration**: Dropped with its test: `a row offers the tick for its commitment on the date the day
view is of`. The rest is carried verbatim.

### Requirement: A day view is in the order it was handed its commitments

**Reason**: Added back below as *A day view's rows are in the order it was handed its commitments*,
without a scenario another under it already asserts.
**Migration**: Dropped with its test: `rows are in the order the commitments were handed over`. The
rest is carried verbatim.

### Requirement: A day view is a value

**Reason**: Added back below as *A day view is a value made of its groups and its date*, without a
scenario another under it already asserts.
**Migration**: Dropped with its test: `two day views of the same commitments, date and history are
the same day view`. The rest is carried verbatim.

### Requirement: A day screen makes and takes back the tick a row offers, and keeps it before the day view says so

**Reason**: Added back below as *A day screen makes and takes back the tick a row offers, and keeps
the change before the day view says so*, without scenarios another under it already asserts.
**Migration**: Dropped with their tests: `ticking a row that says its commitment is not kept makes
the day screen say it is kept` and `a tick made on a day screen is held by a day screen opened
afterwards at the same place`. The rest is carried verbatim.

### Requirement: A day screen re-reads its day and its record when the app is shown again

**Reason**: Added back below as *A day screen re-reads its day, its record and its roster when the
app is shown again*, without a scenario another under it already asserts.
**Migration**: Dropped with its test: `a day screen shown again reads the record again`. The rest is
carried verbatim.

### Requirement: A day screen tells on the row that was tapped that a change could not be kept

**Reason**: Added back below as *A day screen tells on the row that was tapped that the change the
row offers could not be kept*, without scenarios another under it already asserts.
**Migration**: Dropped with their tests: `a refused tick is told on the row that was tapped` and `a
value that is not a number is told on the row, saying so`. The rest is carried verbatim.

### Requirement: What a day screen tells on a row lasts until the app is shown again, a change is kept, or the day it is showing changes

**Reason**: Added back below as *What a day screen tells on a row lasts until the app is shown
again, a change is kept at the record's place, or the day it is showing changes*, without a scenario
another under it already asserts.
**Migration**: Dropped with its test: `what a day screen tells on a row ends when the same change is
made again and is kept`. The rest is carried verbatim.

### Requirement: A day screen tells nothing on a row where there was no tick to refuse

**Reason**: Added back below as *A day screen tells nothing on a row where there was no change to
refuse*, without scenarios another under it already asserts.
**Migration**: Dropped with their tests: `a commit on a day screen that is not keeping a record is
told nothing on the row`, `a commit on a note row on a day screen that is not keeping a record is
told nothing on the row`, `a commit on a row for a day that has not arrived is told nothing on the
row`, `a commit on a note row for a day that has not arrived is told nothing on the row`, `a tap on
a row a day screen's day view does not hold is told nothing on the row` and `a commit on a row that
offers no number entry is told nothing on the row`. The rest is carried verbatim.

### Requirement: A day screen reads its roster again when it is returned to

**Reason**: Added back below as *A day screen reads its roster again whenever it is returned to*,
without a scenario another under it already asserts.
**Migration**: Dropped with its test: `what a day screen tells on a row stands when the screen is
returned to and reads its record again`. The rest is carried verbatim.

### Requirement: A day screen enters the number a row's entry takes, and keeps it before the day view says so

**Reason**: Added back below as *A day screen enters the number a row's entry takes, and keeps the
change before the day view says so*, without scenarios another under it already asserts.
**Migration**: Dropped with their tests: `entering a number on a row makes the day screen say the
commitment is kept`, `a number entered on a day screen is held by a day screen opened afterwards at
the same place` and `the number entry a row offers says the number just entered on it`. The rest is
carried verbatim.

### Requirement: A note entry says the note the day already holds, and says nothing else

**Reason**: Added back below as *A note entry says the whole note the day already holds, and says
nothing else*, without a scenario another under it already asserts.
**Migration**: Dropped with its test: `a note entry says the note the history holds for that
commitment on that date`. The rest is carried verbatim.

### Requirement: A day screen enters the note a row's entry takes, and keeps it before the day view says so

**Reason**: Added back below as *A day screen enters the note a row's entry takes, and keeps the
change before the day view says so*, without scenarios another under it already asserts.
**Migration**: Dropped with their tests: `entering a note on a row makes the day screen say the
commitment is kept` and `the note entry a row offers says the note just entered on it`. The rest is
carried verbatim.

### Requirement: A day screen adds what is committed in a row's total entry, and keeps it before the day view says so

**Reason**: Added back below as *A day screen adds what is committed in a row's total entry, and
keeps the change before the day view says so*, without scenarios another under it already asserts.
**Migration**: Dropped with their tests: `reaching the target makes the day screen say the
commitment is kept` and `an addition entered on a day screen is held by a day screen opened
afterwards at the same place`. The rest is carried verbatim.

### Requirement: A day screen says whether it offers the way back to today

**Reason**: Added back below as *A day screen says whether it offers the way back to the today it
was handed*, without a scenario another under it already asserts.
**Migration**: Dropped with its test: `a day screen showing the today it was handed offers no way
back to today`. The rest is carried verbatim.

### Requirement: A day view says its day as a weekday

**Reason**: Added back below as *A day view says its day as the name of its weekday*, without a
scenario another under it already asserts.
**Migration**: Dropped with its test: `a day view says its day as the three-letter name of its
weekday`. The rest is carried verbatim.

### Requirement: A day screen says the day it is showing

**Reason**: Added back below as *A day screen says the day it is showing as its day view's day
title*, without a scenario another under it already asserts.
**Migration**: Dropped with its test: `a day screen says the day it is showing`. The rest is carried
verbatim.

## ADDED Requirements

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

### Requirement: A day view is a value made of its groups and its date

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

### Requirement: A day screen re-reads its day, its record and its roster when the app is shown again

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

### Requirement: A day screen tells on the row that was tapped that the change the row offers could not be kept

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

### Requirement: What a day screen tells on a row lasts until the app is shown again, a change is kept at the record's place, or the day it is showing changes

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

### Requirement: A day screen says whether it offers the way back to the today it was handed

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

### Requirement: A day view says its day as the name of its weekday

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

### Requirement: A day screen says the day it is showing as its day view's day title

A day screen SHALL say the day it is showing, and that SHALL be its day view's day title, to which
it adds nothing; the words SHALL follow the day being shown and nothing else. They MUST NOT follow
the today the screen was handed, and no word, mark or spacing SHALL tell a screen showing its today
from one showing any other day; whether it is that today is answered by *A day screen says whether
it offers the way back to the today it was handed*. A day screen MUST NOT read a clock to say its
day, and SHALL go on saying the day it was handed until it is moved, a day is picked, or the app is
shown again. A tick made on it MUST NOT change what it says the day is. It SHALL say its day whether
or not it is keeping a record or a roster.

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
