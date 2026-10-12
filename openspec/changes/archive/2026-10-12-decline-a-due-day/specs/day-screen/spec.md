## ADDED Requirements

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
  been kept, offers the decline of its one row, saying "from Mon", and, once moved to the day before,
  not of that day's row, saying "to Tue"

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

### Requirement: A day screen declines a row with the reason committed, and keeps it before the day view says so

A day screen SHALL decline a row whose decline it offers, with the reason committed, blank space at
its start and end disregarded, and with no reason where what is committed is blank; asked of a
declined row, it SHALL give the decline that reason, or none, in place of the one it had, the
decline standing. It SHALL keep the change at its record place before its day view says so, the day
view then being formed again from the record as it stands. A row whose decline it does not offer
SHALL change nothing, keep nothing at any place and tell nothing. A change that cannot be kept SHALL
be refused with an error and told on its row naming no cause, as *A day screen tells on the row that
was tapped that its change could not be kept* requires, its day view staying as it was.

#### Scenario: a row declined with a reason is kept at the record place, and its row says it is declined with that reason

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been kept,
  of a commitment named "Run" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and its one row is declined with "  Knee still sore.  "
- **THEN** nothing is refused, and the row its day view then holds says it is declined, with the
  reason "Knee still sore.", and that its commitment is not kept
- **AND** the day screen offers that row its decline
- **AND** a record store opened afterwards at that record place answers that "Run" is declined on
  Monday 31 August 2026, with the reason "Knee still sore."

#### Scenario: a row declined with a blank reason is declined with none

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been kept,
  of a commitment named "Gym" and one named "Run", both on a schedule listing Monday, Wednesday and
  Saturday and kept from 1 January 2026; the "Gym" row is declined with the empty text; and the
  "Run" row is declined with three spaces and a line break
- **THEN** nothing is refused, and both rows its day view then holds say they are declined
- **AND** neither gives back a reason

#### Scenario: a declined row's reason is changed or cleared, and the decline stands

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been kept,
  of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; its one row is declined with "Away"; the row its day view then holds is declined
  with "Away at a wedding"; and the row its day view then holds is declined with the empty text
- **THEN** nothing is refused
- **AND** after the second, its row says it is declined, with the reason "Away at a wedding"
- **AND** after the third, its row says it is declined and gives back no reason, and a record store
  opened afterwards at that record place answers that "Gym" is declined on Monday 31 August 2026,
  with no reason

#### Scenario: declining a row whose decline is not offered changes nothing and tells nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been kept,
  of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, one named "Run"
  on a schedule listing Tuesday and Thursday and one named "Yuno" on a weekly quota of 2 times a
  week, all three kept from 1 January 2026; its "Gym" row is ticked; and the "Gym" row its day view
  then holds and the "Yuno" row are each declined with "Away"
- **THEN** nothing is refused and nothing is told on any row
- **AND** the "Gym" row says its commitment is kept, and neither row says it is declined
- **AND** declining the "Run" row of the day view it says of the day after, and, once moved to
  Wednesday 2 September 2026, a day not yet arrived, that day's "Gym" row, changes nothing and tells
  nothing either
- **AND** the content at every place is byte-for-byte what it was immediately after "Gym" was ticked

#### Scenario: a decline the record place cannot keep is refused and told on its row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been kept,
  of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and one named
  "Journaling" on a schedule listing all seven weekdays, in that order and both kept from 1 January
  2026; what is at its record place is then made impossible to write; and the "Gym" row is declined
  with "Away"
- **THEN** declining is refused with an error
- **AND** the day screen tells, on the "Gym" row, that the change could not be kept, naming no cause,
  and nothing on the "Journaling" row
- **AND** its day view still holds the "Gym" row, not declined
- **AND** once the place is made writable again and the "Journaling" row is declined with no reason,
  nothing is refused and the day screen tells nothing on any row

### Requirement: A day screen takes a declined row's decline back, and keeps that before the day view says so

A day screen SHALL take back the decline of a declined row whose decline it offers, keeping that at
its record place before its day view says so, the row's day then holding no record and the day view
being formed again from the record as it stands. A row that is not declined, and a row whose decline
it does not offer, SHALL change nothing, keep nothing at any place and tell nothing. A take-back that
cannot be kept SHALL be refused with an error and told on its row naming no cause, its day view
staying as it was.

#### Scenario: a declined row's decline taken back leaves its day holding nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been kept,
  of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; its one row is declined with "Away"; and the decline of the row its day view then
  holds is taken back
- **THEN** nothing is refused, and the row its day view then holds says neither that it is declined
  nor that its commitment is kept
- **AND** the day screen offers that row its decline, and that row offers its tick
- **AND** a record store opened afterwards at that record place holds a history that has taken no
  record

#### Scenario: taking back the decline of a row that is not declined changes nothing and tells nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been kept,
  of a commitment named "Gym" and one named "Run", both on a schedule listing Monday, Wednesday and
  Saturday and kept from 1 January 2026; its "Gym" row is ticked; and the decline of the "Gym" row
  its day view then holds and of the "Run" row is each taken back
- **THEN** nothing is refused and nothing is told on any row
- **AND** the "Gym" row says its commitment is kept
- **AND** the content at every place is byte-for-byte what it was immediately after "Gym" was ticked

#### Scenario: a decline's take-back or new reason the record place cannot keep is refused and told on its row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been kept,
  of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; its one row is declined with "Away"; what is at its record place is then made
  impossible to write; and the decline of the row its day view then holds is taken back
- **THEN** taking it back is refused with an error, and the day screen tells, on that row, that the
  change could not be kept, naming no cause
- **AND** declining that row with "Ill" is refused with an error and told on it the same way
- **AND** its day view still holds the "Gym" row, declined with the reason "Away"

## MODIFIED Requirements

### Requirement: A row is its commitment, its date and what that day holds

A row SHALL be its commitment, its day view's date, whether that day is kept, whether it is declined
and with what reason or none, and, for a number, a note or a total, what that day holds, its starting number or none, for a total the usual amounts its
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

#### Scenario: two rows alike but for whether their day is declined, or for its reason, are different rows

- **WHEN** three day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, the first from a history
  that has taken no record, the second from a history holding a decline of it on that date with the
  reason "Away", and the third from a history holding one with the reason "Ill"
- **THEN** the three rows are different rows, and none says the commitment is kept
- **AND** a row of a day view formed the same way from a history holding a decline with no reason is
  different from all three
- **AND** a row of a day view formed the same way from a history holding a decline with the reason
  "Away" is the same row as the second

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
"from" and the three-letter weekday name of the day that due day came from, as "from Mon", and a row
of a day a shift took its due day from SHALL say "to" and that of the day it went to, as "to Tue",
each in place of its rhythm and in this package's own English. Where the row's commitment runs
every N days, each SHALL name that day as a day screen offers it, as "from Sun 30 Aug" and "to Mon
31 Aug". Every other row SHALL say its rhythm,
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
- **THEN** its one row says "from Mon"
- **AND** the row of the day view it says of the day before says "to Tue", and the row of
  Wednesday 2 September 2026, once the screen is moved there, says "Mon, Wed, Sat"
- **AND** a commitment named "Finances" on a schedule on the 1st of the month, kept from 1 January
  2026, whose due day on Tuesday 1 September 2026 is shifted to Monday 31 August 2026, has a row
  saying "from Tue" on Monday 31 August 2026 and one saying "to Mon" on Tuesday 1 September 2026

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

### Requirement: A day screen offers a row the free days its due day can be shifted to

Asked about a row its day view holds, a day screen SHALL offer exactly the days its roster would
shift that row's due day onto, in date order, each with its date and the three-letter name of its
weekday, as a day view says its day, and, on every N days, the day of the month and the
three-letter month name after it, as "Thu 27 Aug". It SHALL offer none where the row's day holds
any record — a tick, a number, a note, an addition or a decline, a total short of its target
included — none
on every N days while a later day holds one of its commitment, none where it is not keeping its
record or its roster, and none for a row only a day view either side holds. Asking SHALL change nothing the screen holds and nothing at any of its
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
- **AND** once moved to Monday 31 August 2026, it offers its "Gym" row Tuesday 1, Thursday 3,
  Friday 4 and Sunday 6 September 2026

#### Scenario: a day screen offers no day to shift a declined row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at places where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and its one row is declined with no reason
- **THEN** the day screen offers the row its day view then holds no day to shift to
- **AND** once that row's decline is taken back, it offers the row its day view then holds Tuesday 1,
  Thursday 3, Friday 4 and Sunday 6 September 2026
