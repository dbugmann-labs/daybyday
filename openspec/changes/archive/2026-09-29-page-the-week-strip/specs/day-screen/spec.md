## ADDED Requirements

### Requirement: A day screen pages to the week before and the week after, keeping the weekday it is showing

A day screen SHALL page to the week after the week the day being shown lies in, and to the week
before it, making the day being shown that week's day of the same weekday, whether or not that week
holds the today, save where the next requirement lands a page back. Where that day lies past the
calendar's last date, a page to the week after SHALL land on that last date instead; where no week
follows, it SHALL leave the screen exactly as it was. A page SHALL give what a move gives: the day
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

### Requirement: A page to the week before lands on no day earlier than the day picker reaches

A page to the week before SHALL land on no day earlier than the earliest day the screen's day picker
reaches, read off the reach as it stands before the page, and the today SHALL be bound by it as any
other day is. Where the day on the same weekday is earlier than that earliest day or lies outside
the calendar, the page SHALL land on that earliest day instead, where the week paged to holds it.
Where that week holds no day that is that earliest day or later, the page SHALL leave the screen
exactly as it was: showing the day it was showing, holding the day view it held, and telling what
it told.

#### Scenario: a day screen paged back into the week holding the earliest day its picker reaches lands on that day

- **WHEN** a day screen is opened as of Wednesday 16 September 2026, at a place where nothing has
  been kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 4 September 2026, and it is paged to the week before twice
- **THEN** its day picker opens on Friday 4 September 2026 and reaches back to Friday 4 September
  2026
- **AND** its week strip marks Friday 4 September 2026 as shown, and offers Saturday 5 and Sunday
  6 September 2026 and no other day

#### Scenario: a day screen paged back from the week holding the earliest day its picker reaches is left exactly as it was

- **WHEN** a day screen is opened as of Wednesday 16 September 2026, at a record place that can be
  read from but not written to and where nothing has been kept, of a commitment named "Journaling"
  on a schedule listing all seven weekdays, kept from Friday 4 September 2026; it is paged to the
  week before twice; its one row is ticked and refused; and it is paged to the week before again
- **THEN** its day view is the same day view as the one it held before that last page, and its day
  picker opens on Friday 4 September 2026
- **AND** it is still telling on that row that the change could not be kept

#### Scenario: a day screen moved below the earliest day its roster keeps pages back no further than the week it is showing

- **WHEN** a day screen is opened as of Monday 7 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 4 September 2026; it is moved to the day before five times; and it is paged to the week
  before
- **THEN** its day picker opens on Wednesday 2 September 2026
- **AND** paged to the week after and then to the week before, its day picker opens on Friday
  4 September 2026

#### Scenario: a day screen paged back into the week holding its today lands on no day earlier than its picker reaches, the today included

- **WHEN** a day screen is opened as of Wednesday 16 September 2026, at a place where nothing has
  been kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 18 September 2026, and it is paged to the week after and then to the week before
- **THEN** its day picker opens on Friday 18 September 2026, and it offers the way back to today
- **AND** paged to the week before again, its day picker still opens on Friday 18 September 2026

#### Scenario: a day screen paged back into the week of the first supported date lands on that date

- **WHEN** a day screen is opened as of Wednesday 5 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583, and it is paged to the week before
- **THEN** its day picker opens on Saturday 1 January 1583
- **AND** paged to the week before again, its day view is the same day view as the one it held
  before that page, and its day picker still opens on Saturday 1 January 1583

### Requirement: A day screen says the week strip a page either way would give, marking no day as shown

A day screen SHALL say two further week strips, one for each way it pages, each of the week that
page would land in. Each SHALL hold
the days that page would leave its week strip holding, SHALL mark the today where that week holds
it, and SHALL mark no day as shown. Each SHALL offer what that page would leave its week strip
offering and, besides, the day that page would land on. Each SHALL be said where that page would
move the day being shown, and SHALL be absent exactly where that page would leave the screen as it
was. Saying either SHALL read neither place again and SHALL change nothing about the screen, what
it is telling included. Both SHALL follow the day being shown, the today and the reach as they
stand.

#### Scenario: a day screen's week strip either side holds the week a page there would land in and marks no day as shown

- **WHEN** a day screen is opened as of Wednesday 16 September 2026, at a place where nothing has
  been kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 4 September 2026, and it is paged to the week before
- **THEN** the week strip it says of the week before holds Monday 31 August 2026 to Sunday
  6 September 2026, marks no day as shown and none as the today, and offers Friday 4, Saturday 5
  and Sunday 6 September 2026 and no other day
- **AND** the week strip it says of the week after holds Monday 14 September 2026 to Sunday
  20 September 2026, marks Wednesday 16 September 2026 as the today and no day as shown, and offers
  every day it holds

#### Scenario: a day screen's week strip either side offers what the reach a page there would give reaches

- **WHEN** a day screen is opened as of Tuesday 1 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 4 September 2026, and it is moved to the day before seven times
- **THEN** the week strip it says of the week after marks Tuesday 1 September 2026 as the today and
  no day as shown
- **AND** it offers Tuesday 1 to Sunday 6 September 2026, and not Monday 31 August 2026

#### Scenario: a day screen says no week strip either side where a page there would leave it as it was

- **WHEN** a day screen is opened as of Wednesday 16 September 2026, at a place where nothing has
  been kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 4 September 2026, and it is paged to the week before twice
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

#### Scenario: a day screen's week strip either side follows its reach once it is returned to

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Monday 14 September 2026, is taken on at a roster place; a day screen of no commitments at all is
  opened at that roster place as of Wednesday 16 September 2026, at a record place where nothing has
  been kept; a commitment named "Gym" on that same schedule, kept from 1 January 2026, is then taken
  on at that roster place by something else; and the screen is returned to
- **THEN** it says a week strip of the week before, holding Monday 7 September 2026 to Sunday
  13 September 2026 and offering every day it holds
- **AND** before it was returned to, it said no week strip of the week before
