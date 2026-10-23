## ADDED Requirements

### Requirement: A day screen offers a row the free days its due day can be shifted to, each said with its date

Asked about a row its day view holds, a day screen SHALL offer exactly the days its roster would
shift that row's due day onto, in date order, each with its date, said as the three-letter name of its
weekday, the day of the month and the three-letter month name, as "Thu 27 Aug", whatever rhythm the
row's commitment runs on. It SHALL offer none where the row's day holds
any record — a tick, a number, a note, an addition or a decline, a total short of its target
included — none
on every N days while a later day holds one of its commitment, none where it is not keeping its
record or its roster, and none for a row only a day view either side holds. Asking SHALL change nothing the screen holds and nothing at any of its
places.

#### Scenario: a day screen offers a weekday-set row the free days of its week and of its due days either side, each said with its date

- **WHEN** a day screen is opened as of Wednesday 2 September 2026, at places where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and is moved to the day before twice
- **THEN** the day screen offers its one row, of Monday 31 August 2026, the days Sunday
  30 August, Tuesday 1, Thursday 3, Friday 4 and Sunday 6 September 2026, in that order, said "Sun
  30 Aug", "Tue 1 Sep", "Thu 3 Sep", "Fri 4 Sep" and "Sun 6 Sep"
- **AND** once moved to Saturday 5 September 2026, a day not yet arrived, it offers that day's row
  Tuesday 1, Thursday 3, Friday 4 and Sunday 6 September 2026 alike
- **AND** the content at every place is byte-for-byte what it was immediately after it was opened

#### Scenario: a day screen offers a row a shift put its due day on the free days of the day it came from, and that day

- **WHEN** a roster place holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, whose due day on Monday 31 August 2026 is shifted to Thursday
  3 September 2026, and a day screen is opened at it as of Thursday 3 September 2026, at a record
  place where nothing has been kept
- **THEN** the day screen offers its one row the days Sunday 30 August, Monday 31 August,
  Tuesday 1, Friday 4 and Sunday 6 September 2026, in that order, said "Sun 30 Aug", "Mon 31 Aug",
  "Tue 1 Sep", "Fri 4 Sep" and "Sun 6 Sep"
- **AND** a day screen opened as of Monday 7 September 2026, at a record place where nothing has
  been kept and a roster place holding a commitment named "Pool" on a schedule listing Friday, kept
  from 1 January 2026, whose due day on Friday 4 September 2026 is shifted to Monday 7 September
  2026, offers its one row 12 days, Friday 4 September 2026 among them, the first Saturday
  29 August 2026, said "Sat 29 Aug", and the last Thursday 10 September 2026, said "Thu 10 Sep"

#### Scenario: a day screen offers no day to shift a row whose day holds a record

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and its one row is ticked
- **THEN** the day screen offers the row its day view then holds no day to shift to
- **AND** once that row is ticked again, it offers the row its day view then holds Sunday
  30 August, Tuesday 1, Thursday 3, Friday 4 and Sunday 6 September 2026
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

#### Scenario: a day screen offers an every-N-days row the days between its due days either side, each said with its date

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been
  kept, of a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from that day, and is moved to the day before
- **THEN** the day screen offers its one row, of Sunday 30 August 2026, the days Thursday 27, Friday
  28 and Saturday 29 August, Monday 31 August, Tuesday 1 and Wednesday 2 September 2026, in that
  order, said "Thu 27 Aug", "Fri 28 Aug", "Sat 29 Aug", "Mon 31 Aug", "Tue 1 Sep" and "Wed 2 Sep"
- **AND** a day screen opened as of Tuesday 8 September 2026, at places where nothing has been kept,
  of a commitment named "Contact lenses" on a schedule of every 14 days starting on Tuesday
  25 August 2026, kept from that day, offers its one row 26 days, the first Wednesday 26 August
  2026, said "Wed 26 Aug", and the last Monday 21 September 2026, said "Mon 21 Sep"

#### Scenario: a day screen offers an every-N-days row a shift put its due day on the days of the day it came from, that day included

- **WHEN** a roster place holds a commitment named "Nails" on a schedule of every 4 days starting on
  Thursday 6 August 2026, kept from that day, whose due day on Sunday 30 August 2026 is shifted to
  Monday 31 August 2026, and a day screen is opened at it as of Monday 31 August 2026, at a record
  place where nothing has been kept
- **THEN** the day screen offers its one row the days Thursday 27, Friday 28, Saturday 29 and Sunday
  30 August, Tuesday 1 and Wednesday 2 September 2026, in that order, said "Thu 27 Aug", "Fri
  28 Aug", "Sat 29 Aug", "Sun 30 Aug", "Tue 1 Sep" and "Wed 2 Sep"

#### Scenario: a day screen offers no day to shift an every-N-days row while a later day holds a record of it

- **WHEN** a day screen is opened as of Thursday 3 September 2026, at places where nothing has been
  kept, of a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from that day, and of a commitment named "Gym" on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026; its "Nails" row is ticked; it is moved to the day before
  and its "Gym" row is ticked; and it is moved to Sunday 30 August 2026
- **THEN** the day screen offers its "Nails" row no day to shift to
- **AND** once moved to Monday 31 August 2026, it offers its "Gym" row Sunday 30 August, Tuesday 1,
  Thursday 3, Friday 4 and Sunday 6 September 2026

#### Scenario: a day screen offers no day to shift a declined row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and its one row is declined with no reason
- **THEN** the day screen offers the row its day view then holds no day to shift to
- **AND** once that row's decline is taken back, it offers the row its day view then holds Sunday
  30 August, Tuesday 1, Thursday 3, Friday 4 and Sunday 6 September 2026

#### Scenario: a day screen offers a one-weekday row the days between its due days either side, and a day-of-month row about a month each way, each said with its date

- **WHEN** a day screen is opened as of Friday 4 September 2026, at places where nothing has been
  kept, of a commitment named "Pool" on a schedule listing Friday, kept from 1 January 2026
- **THEN** the day screen offers its one row 12 days, every day from Saturday 29 August through
  Thursday 10 September 2026 but Friday 4 September, in date order, the first said "Sat 29 Aug" and
  the last "Thu 10 Sep"
- **AND** a day screen opened as of Monday 31 August 2026, at places where nothing has been kept, of
  a commitment named "Finances" on a schedule on the 31st of the month, kept from 1 January 2026,
  offers its one row 59 days, the first Saturday 1 August 2026, said "Sat 1 Aug", and the last
  Tuesday 29 September 2026, said "Tue 29 Sep"

## MODIFIED Requirements

### Requirement: A row gives back what a screen draws and what a tap makes

A row SHALL be reachable only through the day view holding it, and SHALL give back six things: its
commitment's name, its rhythm in words, whether it is kept, whether it is declined, the reason it is
declined with, whole, or none, and what it offers — a tick or the entry
its commitment's kind takes. It MUST NOT give back the commitment, its schedule, the day it is kept
from, the date or its standing, and SHALL give out the number, the note and the sum only inside the
entry it offers.

The words SHALL be `schedule`'s for the commitment's schedule, said given the row's standing and
what its week owes on a weekly quota and plainly otherwise, and composed by no other capability.
Both SHALL be counted as `look-back` counts a week, the standing through the row's date, whatever the
kind and whether or not it has arrived. A row of a day a shift put its due day on SHALL say instead
"from" and the day that due day came from, named as a day screen offers a day, as "from Mon
31 Aug", and a row of a day a shift took its due day from SHALL say "to" and the day it went to, as
"to Tue 1 Sep", each in place of its rhythm, in this package's own English and whatever rhythm its
commitment runs on. Every other row SHALL say its rhythm,
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
- **THEN** the row on Thursday 3 September 2026 says "4/3x a week", says it is kept and offers a
  tick
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
  the total kind with a target of 120 from a history holding an addition of 120 for it on that
  Monday and one of 30 on Tuesday 1 September 2026
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
- **THEN** its one row says "from Mon 31 Aug"
- **AND** the row of the day view it says of the day before says "to Tue 1 Sep", and the row of
  Wednesday 2 September 2026, once the screen is moved there, says "Mon, Wed, Sat"
- **AND** a commitment named "Finances" on a schedule on the 1st of the month, kept from 1 January
  2026, whose due day on Tuesday 1 September 2026 is shifted to Monday 31 August 2026, has a row
  saying "from Tue 1 Sep" on Monday 31 August 2026 and one saying "to Mon 31 Aug" on Tuesday
  1 September 2026
- **AND** a commitment named "Pool" on a schedule listing Friday, kept from 1 January 2026, whose
  due day on Friday 4 September 2026 is shifted to Monday 7 September 2026, has a row saying "from
  Fri 4 Sep" on Monday 7 September 2026 and one saying "to Mon 7 Sep" on Friday 4 September 2026

#### Scenario: an every-N-days row says where its shifted due day came from, and the row of the day it left where it went, each by weekday and date

- **WHEN** a roster place holds a commitment named "Nails" on a schedule of every 4 days starting on
  Thursday 6 August 2026, kept from that day, whose due day on Sunday 30 August 2026 is shifted to
  Monday 31 August 2026, and a day screen is opened at it as of Monday 31 August 2026, at a record
  place where nothing has been kept
- **THEN** its one row says "from Sun 30 Aug"
- **AND** the row of the day view it says of the day before says "to Mon 31 Aug"

#### Scenario: a declined row gives back that it is declined and its whole reason, and says its rhythm

- **WHEN** a day view is formed on Monday 31 August 2026 of a commitment named "Run" on a schedule
  listing Monday, Wednesday and Saturday, one named "Magnesium" on a schedule listing all seven
  weekdays and one named "Gym" on a schedule listing Monday, Wednesday and Saturday, all three kept
  from 1 January 2026, from a history holding a decline of "Run" on that date with the reason "Knee
  still sore after Tuesday's run, resting it until the weekend." and one of "Magnesium" with no
  reason
- **THEN** the row of "Run" says it is declined, gives back that reason whole, says "Mon, Wed, Sat"
  and says its commitment is not kept
- **AND** the row of "Magnesium" says it is declined, gives back no reason and says "Every day"
- **AND** the row of "Gym" says it is not declined and gives back no reason

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
- **AND** the group under "Sport" holds one row, named "Gym", saying "to Tue 1 Sep"

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
- **THEN** nothing is refused, and its day view holds one row, named "Gym", saying "to Tue 1 Sep"
  and offering nothing
- **AND** the day view it says of the day after holds a row named "Gym" saying "from Mon 31 Aug"
- **AND** the commitment a roster store opened afterwards at that roster place keeps is due on
  Tuesday 1 September 2026 and not on Monday 31 August 2026
- **AND** a day screen opened as of Monday 7 September 2026, at places where nothing has been kept,
  of a commitment named "Pool" on a schedule listing Friday, kept from 1 January 2026, moved to
  Friday 4 September 2026, whose one row is shifted to Monday 7 September 2026, holds one row, named
  "Pool", saying "to Mon 7 Sep", and the commitment a roster store opened afterwards at that roster
  place keeps is due on Monday 7 September 2026 and not on Friday 4 September 2026

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
- **AND** a day screen opened as of Monday 7 September 2026, at a record place where nothing has
  been kept and a roster place holding a commitment named "Pool" on a schedule listing Friday, kept
  from 1 January 2026, whose due day on Friday 4 September 2026 is shifted to that Monday, whose one
  row is shifted to Friday 4 September 2026, holds no row, and the commitment a roster store opened
  afterwards at that roster place keeps is due on Friday 4 September 2026 and not on Monday
  7 September 2026

#### Scenario: shifting a row to a day not offered changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and its one row is shifted to Wednesday 2 September 2026
- **THEN** nothing is refused and nothing is told on any row
- **AND** its day view still holds one row, named "Gym", saying "Mon, Wed, Sat"
- **AND** shifting it to Tuesday 8 September 2026, a day past its next due day, changes nothing either,
  and the content at every place is byte-for-byte what it was immediately after it was opened
- **AND** a day screen opened the same way of a commitment named "Run" on a schedule listing Tuesday
  and Thursday, kept from 1 January 2026, changes nothing and tells nothing when the row of the day
  view it says of the day after is shifted to Wednesday 2 September 2026

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

#### Scenario: an every-N-days row shifted through a day screen runs its count on from the day it landed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been
  kept, of a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from that day; it is moved to the day before; and its one row is shifted to Monday 31
  August 2026
- **THEN** nothing is refused, and its day view holds one row, named "Nails", offering nothing
- **AND** once the screen is moved to Thursday 3 September 2026 its day view holds no row, and once
  moved on to Friday 4 September 2026 it holds one row, named "Nails", saying "Every 4 days"
- **AND** the commitment a roster store opened afterwards at that roster place keeps is due on
  Monday 31 August 2026 and not on Sunday 30 August 2026

### Requirement: A day screen offers declining a row whose day holds nothing, and a declined row its reason and its take-back

A day screen SHALL offer the decline of a row its day view holds where that row offers its tick or
entry as of the today it was handed, its commitment is not on a weekly quota, and its day
holds no record but a decline — no tick, number, note or addition, a total short of its target
included: on a row whose day holds nothing, as declining, and on a declined row, as changing its
reason and taking the decline back. It SHALL offer none where it is not keeping its record, and none
for a row only a day view either side holds. Asking SHALL change nothing at the screen or its places.
A declined row SHALL offer its tick or entry, a record made through it replacing the
decline as *A history holds a decline in its day's place, and never beside another record* requires.

#### Scenario: a day screen offers declining a row of every kind but a weekly quota's whose day holds nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been kept,
  of a commitment named "Gym" of the tick kind, one named "Weight" of the number kind with a range of
  40 to 150, one named "Journal" of the note kind and one named "Protein" of the total kind with a
  target of 120, each on a schedule listing Monday, Wednesday and Saturday, and one named "Yuno" on a
  weekly quota of 2 times a week, all five kept from 1 January 2026
- **THEN** the day screen offers the decline of the rows of "Gym", "Weight", "Journal" and "Protein",
  and not of the row of "Yuno"
- **AND** once moved to Saturday 29 August 2026, a day already past, it offers the decline of that
  day's "Gym" row
- **AND** once moved to Wednesday 2 September 2026, a day not yet arrived, it offers the decline of
  no row
- **AND** the content at every place is byte-for-byte what it was immediately after it was opened

#### Scenario: a day screen offers no decline for a row whose day holds a record

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been kept,
  of a commitment named "Gym" of the tick kind, one named "Weight" of the number kind with no range,
  one named "Journal" of the note kind and one named "Protein" of the total kind with a target of
  120, all four on a schedule listing Monday, Wednesday and Saturday and kept from 1 January 2026;
  its "Gym" row is ticked; and "70.5" is entered on "Weight", "Ran 8k." on "Journal" and "30" on
  "Protein"
- **THEN** the day screen offers the decline of none of the four rows its day view then holds, though
  the row of "Protein" says its commitment is not kept
- **AND** once the "Gym" row is ticked again, it offers the decline of the row its day view then holds

#### Scenario: a day screen offers no decline where it is not keeping its record, for a row of a day either side, or for a row a shift took its due day from

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place where nothing has
  been kept and a record place holding a run of bytes that is not what a record is written as, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026
- **THEN** the day screen offers the decline of no row
- **AND** a day screen opened as of Monday 31 August 2026, at places where nothing has been kept, of
  a commitment named "Run" on a schedule listing Tuesday and Thursday, kept from 1 January 2026,
  offers the decline of no row of the day view it says of the day after
- **AND** a day screen opened as of Tuesday 1 September 2026 at a roster place holding "Gym" whose
  due day on Monday 31 August 2026 is shifted to that Tuesday, and a record place where nothing has
  been kept, offers the decline of its one row, saying "from Mon 31 Aug", and, once moved to the day before,
  not of that day's row, saying "to Tue 1 Sep"

#### Scenario: a declined row offers its tick or entry, and a record made through it replaces the decline

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been kept,
  of a commitment named "Gym" of the tick kind, one named "Weight" of the number kind with no range,
  one named "Journal" of the note kind and one named "Protein" of the total kind with a target of
  120, all four on a schedule listing Monday, Wednesday and Saturday and kept from 1 January 2026;
  each of its four rows is declined with the reason "Away"; and then the "Gym" row is ticked, "70.5"
  is entered on "Weight", "Ran 8k." on "Journal" and "30" on "Protein"
- **THEN** nothing is refused, and no row its day view then holds says it is declined
- **AND** the rows of "Gym", "Weight" and "Journal" say their commitments are kept, and the row of
  "Protein" says its commitment is not, its entry saying "30 of 120"
- **AND** on a day screen opened the same way whose declined "Weight" and "Journal" rows are each
  committed blank in their entries, both rows still say they are declined, with the reason "Away"

## REMOVED Requirements

### Requirement: A day screen offers a row the free days its due day can be shifted to

**Reason**: it says a weekday-set or day-of-month day as its weekday alone. It is replaced by
*A day screen offers a row the free days its due day can be shifted to, each said with its date*, added above, which carries it with that sentence rewritten for every rhythm.
**Migration**: every scenario is carried, four offering wider days said with their date. Two are
renamed, their tests with them: "...the free days of its week, Monday first, each said as its
weekday" to "...a weekday-set row the free days of its week and of its due days either side, each
said with its date", and "...the free days of its week and the day it came from" to "...the free
days of the day it came from, and that day".
