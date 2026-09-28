## ADDED Requirements

### Requirement: A day screen pages to the week before and the week after, landing on the Monday or on the today

A day screen SHALL page to the week after the week the day being shown lies in, and to the week
before it, making the day being shown a day of that week: the today last handed where that week
holds it, and that week's Monday otherwise, save where the next requirement lands a page back. A
page SHALL give what a move gives: the day view of the day landed on, formed from the commitments
its roster had not stopped keeping there and the record held. It SHALL read neither place again and
SHALL NOT move the today. A page that moves the day SHALL be a change of the day being shown
wherever this capability speaks of one. A page to the week after SHALL reach as far as the calendar
goes; where no week follows, it SHALL leave the screen exactly as it was.

#### Scenario: a day screen paged to the week after lands on that week's Monday

- **WHEN** a day screen is opened as of Wednesday 16 September 2026, at a place where nothing has
  been kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is paged to the week after
- **THEN** its day view is the same day view as one formed directly of that commitment and of
  one-offs holding nothing, on Monday 21 September 2026 as of Wednesday 16 September 2026, from a
  history that has taken no tick, and it offers the way back to today
- **AND** its week strip holds Monday 21 September 2026 to Sunday 27 September 2026, with Monday
  21 September 2026 marked as shown and no day marked as the today
- **AND** paged to the week after again, its day picker opens on Monday 28 September 2026

#### Scenario: a day screen paged to the week before lands on that week's Monday

- **WHEN** a day screen is opened as of Wednesday 16 September 2026, at a place where nothing has
  been kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is paged to the week before
- **THEN** its day picker opens on Monday 7 September 2026, and it offers the way back to today
- **AND** paged to the week before again, its day picker opens on Monday 31 August 2026
- **AND** sent back to today from there, its day picker opens on Wednesday 16 September 2026

#### Scenario: a day screen paged into the week holding its today lands on the today from either side

- **WHEN** a day screen is opened as of Wednesday 16 September 2026, at a place where nothing has
  been kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is paged to the week after and then to the week before
- **THEN** its day picker opens on Wednesday 16 September 2026, and it offers no way back to today
- **AND** a second day screen opened the same way, paged to the week before twice and then to the
  week after twice, has its day picker open on Wednesday 16 September 2026

#### Scenario: a day screen paged to the week after from the last week of the calendar is left exactly as it was

- **WHEN** a day screen is opened as of Thursday 30 December 9999, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is paged to the week after
- **THEN** its day view is the same day view as the one it held when it was opened, and its day
  picker opens on Thursday 30 December 9999
- **AND** a second day screen opened the same way as of Wednesday 22 December 9999 and paged to the
  week after has its day picker open on Monday 27 December 9999

#### Scenario: paging a day screen does not read its roster or its record again

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Wednesday 16 September 2026, at a record place where nothing has been
  kept; a commitment named "Gym" on that same schedule, kept from 1 January 2026, is then taken on
  at that roster place by something else, and a tick for "Journaling" on Monday 7 September 2026 is
  kept at that record place by something else; and it is paged to the week before
- **THEN** its day view holds one row, named "Journaling"
- **AND** that row says the commitment is not kept on Monday 7 September 2026
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
  its one-off entry and refused and which is then paged to the week before, tells nothing under its
  one-off entry

### Requirement: A page to the week before lands on no day earlier than the day picker reaches, save the today

A page to the week before SHALL land on no day earlier than the earliest day the screen's day picker
reaches, read off the reach as it stands before the page, save the today. Where that week holds the
today, the page SHALL land on the today, whatever the reach. Otherwise, where that week's Monday is
earlier than that earliest day or lies outside the calendar, the page SHALL land on that earliest day
instead. Where that week holds neither the today nor any day that is that earliest day or later, the
page SHALL leave the screen exactly as it was: showing the day it was showing, holding the day view
it held, and telling what it told.

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

#### Scenario: a day screen paged back into the week holding its today lands on the today however late its roster's earliest day

- **WHEN** a day screen is opened as of Wednesday 16 September 2026, at a place where nothing has
  been kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 25 September 2026, and it is paged to the week after and then to the week before
- **THEN** its day picker opens on Wednesday 16 September 2026, and it offers no way back to today
- **AND** paged to the week before again, its day picker still opens on Wednesday 16 September 2026

#### Scenario: a day screen whose roster keeps nothing until more than a week after its today pages back no further than that week

- **WHEN** a day screen is opened as of Wednesday 16 September 2026, at a place where nothing has
  been kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 2 October 2026; Monday 5 October 2026 is picked; and it is paged to the week before
- **THEN** its day picker opens on Friday 2 October 2026
- **AND** paged to the week before again, its day picker still opens on Friday 2 October 2026, and
  it offers the way back to today

#### Scenario: a day screen paged back into the week of the first supported date lands on that date

- **WHEN** a day screen is opened as of Wednesday 5 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583, and it is paged to the week before
- **THEN** its day picker opens on Saturday 1 January 1583
- **AND** paged to the week before again, its day view is the same day view as the one it held
  before that page, and its day picker still opens on Saturday 1 January 1583

### Requirement: A day screen says the week strip a page either way would give

A day screen SHALL say two further week strips beside its own: the week strip it would say once
paged to the week before, and the one it would say once paged to the week after, each holding,
marking and offering exactly what that page would leave it saying. Each SHALL be said where that page
would move the day being shown, and SHALL be absent exactly where that page would leave the screen as
it was. Saying either SHALL read neither place again and SHALL change nothing about the screen, what
it is telling included. Both SHALL follow the day being shown, the today and the reach as they stand.

#### Scenario: a day screen says as the week strip either side the strip a page there would leave it saying

- **WHEN** a day screen is opened as of Wednesday 16 September 2026, at a place where nothing has
  been kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 4 September 2026, and it is paged to the week before
- **THEN** the week strip it says of the week before is the same week strip as that of a day screen
  opened the same way and paged to the week before twice, marking Friday 4 September 2026 as shown
  and offering Saturday 5 and Sunday 6 September 2026 and no other day
- **AND** the week strip it says of the week after is the same week strip as that of a day screen
  opened the same way and not paged, marking Wednesday 16 September 2026 as shown and as the today

#### Scenario: a day screen's week strip of the week before offers from the today it would land on however late its roster's earliest day

- **WHEN** a day screen is opened as of Wednesday 16 September 2026, at a place where nothing has
  been kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  Friday 25 September 2026, and it is paged to the week after
- **THEN** the week strip it says of the week before marks Wednesday 16 September 2026 as shown and
  as the today
- **AND** it offers Thursday 17 to Sunday 20 September 2026, and no other day

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
- **THEN** the week strip it says of the week before marks Monday 7 September 2026 as shown
- **AND** before it was returned to, it said no week strip of the week before
