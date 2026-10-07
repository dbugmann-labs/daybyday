## ADDED Requirements

### Requirement: A day view holds a row for a day a shift took a due day from, and that row offers nothing

A day view SHALL hold a row for each commitment handed to it a shift of which took a due day from
its date, in the place among its rows that commitment was handed in. That row SHALL say its
commitment is not kept, and SHALL offer no tick, no number entry, no note entry, no total entry and
no take-back, whatever its kind and whatever day it is asked as of; it SHALL say it offers nothing
at all, and a day screen SHALL offer it no day to shift to. A group holding no row but such a row
SHALL still be drawn, holding it.

#### Scenario: a row of a day a shift took a due day from offers nothing, whatever its kind

- **WHEN** a day screen is opened as of Tuesday 1 September 2026, at a record place where nothing
  has been kept and a roster place holding, in this order and each on a schedule listing Monday,
  Wednesday and Saturday and kept from 1 January 2026, a commitment named "Gym" of the tick kind,
  one named "Weight" of the number kind with a range of 40 to 150, one named "Journal" of the note
  kind and one named "Protein" of the total kind with a target of 120, the due day of each on Monday
  31 August 2026 shifted to Tuesday 1 September 2026; and the screen is moved to the day before
- **THEN** its day view holds four rows, named "Gym", "Weight", "Journal" and then "Protein", each
  saying its commitment is not kept
- **AND** asked as of Tuesday 1 September 2026, none of them offers a tick, a number entry, a note
  entry, a total entry or a take-back, and each says it offers nothing at all
- **AND** the day screen offers none of the four a day to shift to

#### Scenario: a group holding only a row a shift took a due day from is still drawn

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a group under "Sport" holding a commitment named "Gym" on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, as a roster holds it once its due day on that date is
  shifted to Tuesday 1 September 2026, and then a group with no category holding one named
  "Journaling" on a schedule listing all seven weekdays, kept from 1 January 2026
- **THEN** the day view holds two groups, under "Sport" and then under no category
- **AND** the group under "Sport" holds one row, named "Gym", saying "to Tue"

### Requirement: A day screen offers a row the free days its due day can be shifted to

Asked about a row its day view holds, a day screen SHALL offer exactly the days its roster would
shift that row's due day onto, as *A roster shifts a due day of a commitment it holds onto a free
day of that day's week* gives them, in week order from Monday, each with its date and the
three-letter name of its weekday, as a day view says its day. It SHALL offer none where the row's
day holds any record — a tick, a number, a note or an addition, a total short of its target
included — none where it is not keeping its record or its roster, and none for a row only a day
view either side holds. Asking SHALL change nothing the screen holds and nothing at any of its
places.

#### Scenario: a day screen offers a row the free days of its week, Monday first, each said as its weekday

- **WHEN** a day screen is opened as of Wednesday 2 September 2026, at places where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and is moved to the day before twice
- **THEN** the day screen offers its one row, of Monday 31 August 2026, the days Tuesday 1,
  Thursday 3, Friday 4 and Sunday 6 September 2026, in that order, said "Tue", "Thu", "Fri" and
  "Sun"
- **AND** once moved to Saturday 5 September 2026, a day not yet arrived, it offers that day's row
  Tuesday 1, Thursday 3, Friday 4 and Sunday 6 September 2026 alike
- **AND** the content at every place is byte-for-byte what it was immediately after it was opened

#### Scenario: a day screen offers a row a shift put its due day on the free days of its week and the day it came from

- **WHEN** a roster place holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, whose due day on Monday 31 August 2026 is shifted to Thursday
  3 September 2026, and a day screen is opened at it as of Thursday 3 September 2026, at a record
  place where nothing has been kept
- **THEN** the day screen offers its one row the days Monday 31 August, Tuesday 1, Friday 4 and
  Sunday 6 September 2026, in that order, said "Mon", "Tue", "Fri" and "Sun"

#### Scenario: a day screen offers no day to shift a row whose day holds a record

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and its one row is ticked
- **THEN** the day screen offers the row its day view then holds no day to shift to
- **AND** once that row is ticked again, it offers the row its day view then holds Tuesday 1,
  Thursday 3, Friday 4 and Sunday 6 September 2026
- **AND** a row of a commitment named "Protein" of the total kind with a target of 120, on the same
  schedule, whose day holds an addition of 35, is offered no day, though it says its commitment is
  not kept

#### Scenario: a day screen offers no day to shift a row where it is not keeping its record, nor a row of a day either side

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place where nothing has
  been kept and a record place holding a run of bytes that is not what a record is written as, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026
- **THEN** the day screen offers its one row no day to shift to
- **AND** a day screen opened as of Monday 31 August 2026, at places where nothing has been kept, of
  a commitment named "Run" on a schedule listing Tuesday and Thursday, kept from 1 January 2026,
  offers the row of the day view it says of the day after no day to shift to

### Requirement: A day screen shifts a row's due day to a day it offers, and keeps the shift at its roster place before the day view says so

A day screen SHALL shift the due day of a row its day view holds onto a day it offers that row,
keeping the shift at its roster place before its day view says so, and SHALL then form its day view
and the day views either side from its roster as it then stands. A day it does not offer that row,
and a row its day view does not hold, SHALL change nothing, keep nothing at any place and tell
nothing. A shift that cannot be kept at the roster place SHALL be refused with an error and told on
its row, as *A day screen tells on the row that was tapped that its change could not be kept*
requires, its day view staying as it was.

#### Scenario: a row's due day shifted to a day offered is kept at the roster place, and the day view says where it went

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and its one row is shifted to Tuesday 1 September 2026
- **THEN** nothing is refused, and its day view holds one row, named "Gym", saying "to Tue" and
  offering nothing
- **AND** the day view it says of the day after holds a row named "Gym" saying "from Mon"
- **AND** the commitment a roster store opened afterwards at that roster place keeps is due on
  Tuesday 1 September 2026 and not on Monday 31 August 2026

#### Scenario: a day shifted back to the day it came from leaves both days as they were

- **WHEN** a roster place holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, whose due day on Monday 31 August 2026 is shifted to Tuesday
  1 September 2026; a day screen is opened at it as of Tuesday 1 September 2026, at a record place
  where nothing has been kept; and its one row is shifted to Monday 31 August 2026
- **THEN** nothing is refused, and its day view holds no row
- **AND** the day view it says of the day before holds one row, named "Gym", saying "Mon, Wed, Sat"
  and offering its tick
- **AND** the commitment a roster store opened afterwards at that roster place keeps is due on
  Monday 31 August 2026 and not on Tuesday 1 September 2026

#### Scenario: shifting a row to a day not offered changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and its one row is shifted to Wednesday 2 September 2026
- **THEN** nothing is refused and nothing is told on any row
- **AND** its day view still holds one row, named "Gym", saying "Mon, Wed, Sat"
- **AND** shifting it to Tuesday 8 September 2026, a day of the week after, changes nothing either,
  and the content at every place is byte-for-byte what it was immediately after it was opened

#### Scenario: a shift the roster place cannot keep is refused and told on its row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and one
  named "Journaling" on a schedule listing all seven weekdays, in that order and both kept from
  1 January 2026; what is at its roster place is then made impossible to write; and the "Gym" row
  is shifted to Tuesday 1 September 2026
- **THEN** shifting is refused with an error
- **AND** the day screen tells, on the "Gym" row, that the change could not be kept, and nothing on
  the "Journaling" row
- **AND** its day view still holds the "Gym" row saying "Mon, Wed, Sat" and offering its tick

## RENAMED Requirements

- FROM: `### Requirement: A day view holds the commitments due on a date, each with whether it is kept`
- TO: `### Requirement: A day view holds the commitments due on a date and those a shift took a due day from, each with whether it is kept`

- FROM: `### Requirement: A day view draws its rows in the groups it was handed, and draws no group with nothing due`
- TO: `### Requirement: A day view draws its rows in the groups it was handed, and draws no group holding no row`

## MODIFIED Requirements

### Requirement: A day view holds the commitments due on a date and those a shift took a due day from, each with whether it is kept

A day view SHALL be formed from some commitments, a calendar date and a history, and SHALL hold one
row for each commitment due on that date, one for each a shift took a due day from on that date, as
*A day view holds a row for a day a shift took a due day from, and that row offers nothing* says, and none for any other. Each row SHALL carry its
commitment's name exactly as given, and SHALL say whether the history holds that commitment kept on
that date.

Whether a commitment is due SHALL be the `commitment` capability's answer, asked of the commitment
itself rather than of the schedule it carries; whether it is kept SHALL be the `record`
capability's. A day view MUST NOT recompute either, MUST NOT consider a commitment's name, a clock,
a time zone or a locale, and SHALL be formed for any supported date, arrived or not. It SHALL NOT
count, total or rank anything. Rows SHALL come only from the commitments handed over: the history
SHALL be asked about each of them in turn and SHALL never be enumerated. A day view with no such
commitment, or none at all, SHALL hold no rows rather than refuse.

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

### Requirement: A day view draws its rows in the groups it was handed, and draws no group holding no row

A day view SHALL be handed its commitments in groups — a category, or none, with its commitments —
and SHALL hold one for each group handed with a row on its date, in the order handed, each
holding its commitments' rows in that order. Its rows SHALL be every row its groups hold, in the
order drawn, and a row in a group SHALL say what one under no category says. A day view SHALL sort
neither the groups nor within one, SHALL NOT decide where commitments under no category go, and
SHALL NOT combine two groups under one category. A group holding no row SHALL NOT be drawn, and
one handed only such groups SHALL hold no groups and no rows. A day view MAY be handed no grouping,
and SHALL then hold one group with no category, or none where it holds no row.

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

### Requirement: A day view's rows are in the order it was handed its commitments

A day view's rows SHALL appear in the order its commitments were handed to it, with the ones that
have no row on the date left out and every other one left where it was. A day view SHALL NOT impose
an order of its own: it MUST NOT sort by name, by the rhythm a commitment runs on, by the day it is
kept from or by whether it is kept, and it MUST NOT move a row that has been ticked. A day view
SHALL hold one row per commitment it was handed that has one on the date and SHALL NOT combine two
into one, so
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

A day view SHALL be the groups it holds, its One-offs group where it holds one, its Birthdays group
where it holds one, and the calendar date it was formed on, and nothing else. Two day views SHALL be
the same day view when they are of the same date and hold the same groups in the same order, each
group holding the same rows in the same order, the same One-offs group or none, and the same
Birthdays group or none, and SHALL be different when any of that differs;
two day views holding the same rows in the same order under different groupings SHALL therefore be
two day views.

A difference in what a day view was handed that does not reach a row SHALL make no difference to the
day view: a commitment not due, and no shift of which took a due day from that date, produces no row,
a group holding no row produces no group, and a tick for a commitment the day view was not handed is never looked up, and a one-off
standing on another day produces no one-off row, so a day view handed any of the four SHALL be the
same day view as one that was not handed it. A day view handed no one-offs at all SHALL NOT be the
same day view as one handed one-offs holding none. A day view SHALL be an answer given from a
history as it stood rather than a window onto one, and ticking that history afterwards MUST NOT
change the day view.

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

#### Scenario: two day views differing only in a one-off standing on another day are the same day view

- **WHEN** a day view is formed on Monday 28 September 2026 as of that same day, from a history that
  has taken no tick, of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, and of one-offs holding nothing; and a second is formed the same way of
  one-offs holding "Send form" on 30 September 2026, not done
- **THEN** the two are the same day view
- **AND** a third formed the same way of one-offs holding "Call mum" on 25 September 2026, not done,
  is a different day view from both
- **AND** a fourth formed the same way and handed no one-offs at all is a different day view from the
  first

### Requirement: A day screen draws the commitments its roster had not stopped keeping on the day it is showing, and never one deleted

A day screen SHALL form every day view from the commitments the roster at its roster place had not
stopped keeping on the day shown, in the roster's groups and order. Every day view SHALL ask the
roster again for the day then shown: when the screen is opened, moved, sent back to today, shown
again or returned to, and when a tick is made or a shift is kept. The roster asked SHALL be the one read when the app
was last shown or the screen last returned to, whichever happened later, with any change kept since;
asking MUST NOT open the place. A commitment the roster stopped SHALL have a row up to and including
the day it was kept until, and none after. A commitment taken up again after a gap SHALL have no row
on a day of the gap, and SHALL have its rows again from the day its new era is kept from. A commitment the roster has deleted SHALL have a row on no day,
the days it was ticked on included. A group holding no row
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

#### Scenario: a day screen draws no row for a commitment on a day of a gap

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place, stopped there as of Sunday 23 August 2026 and taken
  up again there from Monday 31 August 2026; and a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept, and
  moved to the day before
- **THEN** the day view it held when it was opened holds one row, named "Journaling"
- **AND** after the move its day view holds no rows
- **AND** Sunday 23 August 2026, picked on its day picker, holds one row, named "Journaling"

### Requirement: A row offers the tick that keeps its commitment, and offers none for a day that has not arrived

A row SHALL offer, asked as of a calendar date, exactly one tick or nothing at all: the tick of its
commitment on its day view's date. A row asked as of its own date SHALL offer that tick, and so
SHALL a row whose date is earlier, however much earlier. A row SHALL offer nothing where its date is
later than the day it is asked as of, nothing where its commitment's kind is not a tick, whatever
day it is asked as of, and nothing where a shift took its due day from its date, as
*A day view holds a row for a day a shift took a due day from, and that row offers nothing* says;
such a row SHALL stay in the day view unchanged. A row SHALL refuse for those three reasons and no
other, and SHALL offer the same tick whether or not it says the commitment is kept.

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

### Requirement: A row offers the number entry its commitment takes, and offers none for a day that has not arrived

A row asked as of a calendar date SHALL offer either exactly one number entry or nothing at all, and
the entry SHALL be for its commitment on the day view's date. It SHALL offer nothing when its
commitment's kind is not a number, and nothing when the day view's date is later than the day it is
asked as of, whatever that day already holds. It SHALL offer nothing where a shift took its due
day from the day view's date, as *A day view holds a row for a day a shift took a due day from, and that row offers nothing*
says, and SHALL otherwise offer the entry for its own date and any earlier one, however much
earlier.

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

### Requirement: A row offers the note entry its commitment takes, and offers none for a day that has not arrived

A row asked as of a calendar date SHALL offer either exactly one note entry or nothing at all, and
the entry SHALL be for its commitment on the day view's date. It SHALL offer nothing when its
commitment's kind is not a note, and nothing when the day view's date is later than the day it is
asked as of, whatever that day already holds. It SHALL offer nothing where a shift took its due
day from the day view's date, as *A day view holds a row for a day a shift took a due day from, and that row offers nothing*
says, and SHALL otherwise offer the entry for its own date and any earlier one, however much
earlier.

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

### Requirement: A row offers the total entry its commitment takes, and offers none for a day that has not arrived

A row SHALL offer, when asked as of a calendar date, either one total entry or nothing at all, and
that entry SHALL be the one for its commitment on the date its day view is of. The row SHALL offer
nothing where its commitment's kind is not a total, and nothing where its day view's date is later
than the day it is asked as of, whatever additions that day holds, and nothing where a shift took
its due day from that date, as *A day view holds a row for a day a shift took a due day from, and that row offers nothing*
says. Where none of the three holds it SHALL offer the entry, on its own date and on any earlier
one. Whether it offers one SHALL NOT depend on
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

### Requirement: A row is its commitment, its date and what that day holds

A row SHALL be its commitment, its day view's date, whether that day is kept and, for a number, a
note or a total, what that day holds, its starting number or none, for a total the usual amounts its
commitment declares, and, only where its commitment is on a weekly quota, its standing on that date
and what its week owes, and, where a shift took its due day from that date or put one on it, the
day that due day went to or came from. Two rows SHALL be the same row when all of these agree, and SHALL be
different when any one differs.

Two rows of one commitment on one date SHALL be different rows where their days hold different
numbers or notes, and SHALL be the same row where their days' additions differ but sum alike, a
total row holding the day's sum and never its additions. A row SHALL hold only what its commitment's
kind can put there, and every row but a total's SHALL hold a sum of zero, as a sum rather than
nothing at all.

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

#### Scenario: two rows for the same number commitment and date holding no number but differing in starting number are different rows

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Weight"
  of the number kind with a range of 40 to 150, on a schedule listing all seven weekdays, kept from
  1 January 2026, the first from a history holding a number of 72.4 for that commitment on Sunday
  30 August 2026 and the second from a history holding a number of 71.8 for it on that date
- **THEN** each holds one row saying the commitment is not kept
- **AND** the two rows are different rows
- **AND** a row of a day view formed the same way from a history holding 72.4 on Sunday 30 August
  2026 and 60 on Saturday 29 August 2026 is the same row as the first

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

#### Scenario: two weekly-quota rows alike in commitment, date and day but differing in standing are different rows

- **WHEN** two day views are formed on Wednesday 2 September 2026, each of a commitment named
  "Reading" on a weekly quota of 3 times a week, kept from 1 January 2026, the first from a history
  that has taken no tick and the second from a history holding a tick for that commitment on Monday
  31 August 2026
- **THEN** each holds one row named "Reading", saying the commitment is not kept
- **AND** the first says "0/3x a week" and the second says "1/3x a week"
- **AND** the two rows are different rows

#### Scenario: two weekly-quota rows whose histories differ only outside the row's week through its date are the same row

- **WHEN** two day views are formed on Wednesday 2 September 2026, each of a commitment named
  "Reading" on a weekly quota of 3 times a week, kept from 1 January 2026, each from a history
  holding a tick for that commitment on Monday 31 August 2026, the second history also holding ticks
  for it on Sunday 30 August and Thursday 3 September 2026
- **THEN** both rows say "1/3x a week"
- **AND** the two rows are the same row

#### Scenario: two rows on a schedule that is not a weekly quota whose histories differ on another day of the week are the same row

- **WHEN** two day views are formed on Wednesday 2 September 2026, each of a commitment named "Gym"
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, the first from a
  history that has taken no tick and the second from a history holding a tick for that commitment on
  Monday 31 August 2026
- **THEN** both rows say "Mon, Wed, Sat", saying the commitment is not kept
- **AND** the two rows are the same row

#### Scenario: two weekly-quota rows alike but for what their week owes are different rows

- **WHEN** two day views are formed on Wednesday 2 September 2026, each from a history that has
  taken no tick, the first of a commitment named "Reading" on a weekly quota of 3 times a week, kept
  from 1 January 2026, and the second of an era of that same commitment on that same quota, kept
  from Wednesday 2 September 2026
- **THEN** the first row says "0/3x a week" and the second says "0/2x a week"
- **AND** the two rows are different rows

#### Scenario: two total rows alike but for the usual amounts their commitment declares are different rows

- **WHEN** a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  all seven weekdays, kept from 1 January 2026, declaring a usual amount of 35 named "Müesli", is
  taken on at a roster place; a day screen is opened at that roster place and at a record place where
  nothing has been kept as of Monday 31 August 2026, and its one row is read; a commitments screen
  opened at the same places changes "Protein" to a usual amount typed as "35" named "Shake", on
  everything else it already has; and the day screen is returned to
- **THEN** the row the day screen then holds is a different row from the one read before
- **AND** once "Protein" is changed back to 35 named "Müesli" and the day screen is returned to
  again, the row it then holds is the same row as the one read first

#### Scenario: a row of a day a shift took its due day from is a different row from the one that day held before

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; the one row of its day view is held; and that row is then shifted to Tuesday
  1 September 2026 through the screen
- **THEN** the row named "Gym" its day view then holds is a different row from the one held
- **AND** once the screen is moved to the day after, that day's "Gym" row is shifted to Monday
  31 August 2026 and the screen is moved back, the row its day view holds is the same row as the one
  held

### Requirement: A row gives back what a screen draws and what a tap makes

A row SHALL be reachable only through the day view holding it, and SHALL give back four things: its
commitment's name, its rhythm in words, whether it is kept, and what it offers — a tick or the entry
its commitment's kind takes. It MUST NOT give back the commitment, its schedule, the day it is kept
from, the date or its standing, and SHALL give out the number, the note and the sum only inside the
entry it offers.

The words SHALL be `schedule`'s for the commitment's schedule, said given the row's standing and
what its week owes on a weekly quota and plainly otherwise, and composed by no other capability.
Both SHALL be counted as `look-back` counts a week, the standing through the row's date, whatever the
kind and whether or not it has arrived. A row of a day a shift put its due day on SHALL say instead
"from" and the three-letter weekday name of the day that due day came from, as "from Mon", and a row
of a day a shift took its due day from SHALL say "to" and that of the day it went to, as "to Tue",
each in place of its rhythm and in this package's own English. Every other row SHALL say its rhythm,
kept or not and whatever it offers.

#### Scenario: a row says the rhythm its commitment runs on in words

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick,
  of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, one named
  "Finances" on a schedule on the 31st of the month, one named "Contact lenses" on a schedule of
  every 14 days starting on 31 August 2026, and one named "Reading" on a schedule of 3 times a
  week, all kept from 1 January 2026
- **THEN** the day view holds four rows, saying "Mon, Wed, Sat", "The 31st", "Every 14 days" and
  "0/3x a week" in that order

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

#### Scenario: a weekly-quota row says its standing counted through its own date and from its own week's Monday

- **WHEN** day views are formed of a commitment named "Reading" on a weekly quota of 3 times a week,
  kept from 1 January 2026, from a history holding ticks for that commitment on Sunday 30 August,
  Monday 31 August, Wednesday 2 September and Friday 4 September 2026
- **THEN** the row on Sunday 30 August 2026 says "1/3x a week"
- **AND** the rows on Monday 31 August and Tuesday 1 September 2026 say "1/3x a week"
- **AND** the row on Wednesday 2 September 2026 says "2/3x a week" and the row on Sunday 6 September
  2026 says "3/3x a week"

#### Scenario: a weekly-quota row past its quota says the true count and still offers a tick

- **WHEN** day views are formed of a commitment named "Reading" on a weekly quota of 3 times a week,
  kept from 1 January 2026, from a history holding ticks for that commitment on each day from Monday
  31 August through Thursday 3 September 2026, and each row is asked as of Saturday 5 September 2026
- **THEN** the row on Thursday 3 September 2026 says "4/3x a week", says it is kept and offers a tick
- **AND** the row on Saturday 5 September 2026 says "4/3x a week", says it is not kept and offers a
  tick

#### Scenario: a weekly-quota row for a day that has not arrived says its standing through its own date

- **WHEN** a day view is formed on Friday 4 September 2026 of a commitment named "Reading" on a
  weekly quota of 3 times a week, kept from 1 January 2026, from a history holding ticks for that
  commitment on Monday 31 August and Thursday 3 September 2026, and its row is asked as of Wednesday
  2 September 2026
- **THEN** the row offers no tick
- **AND** the row says "2/3x a week"

#### Scenario: a weekly-quota row whose commitment is not a tick says its standing by the days kept

- **WHEN** day views are formed on Wednesday 2 September 2026, each on a weekly quota of 3 times a
  week and kept from 1 January 2026, of a commitment named "Weight" of the number kind from a
  history holding a number of 70.5 for it on Monday 31 August 2026, one named "Journal" of the note
  kind from a history holding a note of "Ran 8k." for it on that Monday, and one named "Protein" of
  the total kind with a target of 120 from a history holding an addition of 120 for it on that Monday
  and one of 30 on Tuesday 1 September 2026
- **THEN** each of the three rows says "1/3x a week"

#### Scenario: a row on a schedule that is not a weekly quota says its plain words whatever its week holds

- **WHEN** a day view is formed on Wednesday 2 September 2026 of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday and one named "Vitamins" on a schedule listing all
  seven weekdays, both kept from 1 January 2026, from a history holding ticks for both on Monday
  31 August and Wednesday 2 September 2026
- **THEN** the first row says "Mon, Wed, Sat" and the second says "Every day"

#### Scenario: a weekly-quota row in a part week says what its week owes

- **WHEN** a day view is formed on Wednesday 2 September 2026 of a commitment named "Reading" on a
  weekly quota of 3 times a week, kept from that day, and one on Saturday 5 September 2026 of a
  commitment named "Stretch" on a weekly quota of 1 time a week, kept from that day, each from a
  history that has taken no tick
- **THEN** the row of "Reading" says "0/2x a week"
- **AND** the row of "Stretch" says "0/0x a week"

#### Scenario: a weekly-quota row counts a day kept before a stop in the week it was taken up again

- **WHEN** a commitment named "Reading" on a weekly quota of 3 times a week, kept from 1 January
  2026, is taken on at a roster place; a tick for it on Monday 31 August 2026 is kept at a record
  place; "Reading" is stopped at that roster place as of Monday 31 August 2026 and taken up again
  there from Thursday 3 September 2026; and a day screen of no commitments at all is opened at those
  places as of Thursday 3 September 2026
- **THEN** its day view holds one row, named "Reading", saying "1/2x a week"

#### Scenario: a row says where a shifted due day came from, and the row of the day it left says where it went

- **WHEN** a roster place holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, whose due day on Monday 31 August 2026 is shifted to Tuesday
  1 September 2026, and a day screen is opened at it as of Tuesday 1 September 2026, at a record
  place where nothing has been kept
- **THEN** its one row says "from Mon"
- **AND** the row of the day view it says of the day before says "to Tue", and the row of
  Wednesday 2 September 2026, once the screen is moved there, says "Mon, Wed, Sat"
- **AND** a commitment named "Finances" on a schedule on the 1st of the month, kept from 1 January
  2026, whose due day on Tuesday 1 September 2026 is shifted to Monday 31 August 2026, has a row
  saying "from Tue" on Monday 31 August 2026 and one saying "to Mon" on Tuesday 1 September 2026
