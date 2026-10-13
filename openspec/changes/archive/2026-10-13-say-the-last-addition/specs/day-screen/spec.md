## ADDED Requirements

### Requirement: A row says the amount its take-back would remove

A row SHALL say, when asked as of a calendar date, the words of the take-back it offers:
"Take back last", a space, and the amount of its day's last addition in round brackets, as in
"Take back last (35)". It SHALL say them exactly where it offers taking its day's last addition
back as of that day, and SHALL say no such words where it offers none. The amount SHALL be the last
addition its day holds in the history its day view was formed from, and SHALL be said as its total
entry says the day's sum, with no digit added and none dropped. The words SHALL name the amount
alone and MUST NOT name a usual amount's name, and SHALL be this package's own English and no
locale's. A day view formed again after a take-back SHALL say the addition made before the one
taken back.

#### Scenario: a row says the amount of its day's last addition in its take-back

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, from a history holding additions of 35 and then 20 for that commitment on that
  date, and its one row is asked as of that same day
- **THEN** that row says the take-back words "Take back last (20)"
- **AND** a row of a day view formed the same way but from a history holding additions of 20 and
  then 35 says "Take back last (35)"

#### Scenario: a take-back on a day screen leaves its row saying the addition made before it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "35" and then "20" are committed
  on the row it holds each time; and that row's last addition is then taken back
- **THEN** the row the day screen then holds, asked as of that same day, says the take-back words
  "Take back last (35)"
- **AND** the entry it offers says "35 of 120"
- **AND** taking back the last addition of the row it then holds leaves a row that says no
  take-back words, whose entry says "0 of 120"
- **AND** on a second such day screen at a fresh place, "30" committed twice and the last addition
  taken back once leaves its row saying "Take back last (30)" and its entry "30 of 120"

#### Scenario: a take-back says a decimal amount as the day's sum says it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "12.5" is committed on its
  one row
- **THEN** the row the day screen then holds, asked as of that same day, says the take-back words
  "Take back last (12.5)", and its entry says "12.5 of 120"
- **AND** committing "0000030.50" on the row it then holds leaves it saying "Take back last (30.5)"
  and its entry "43 of 120"
- **AND** committing "45,5" on the row it then holds leaves it saying "Take back last (45.5)" and
  its entry "88.5 of 120"
- **AND** on a second such day screen at a fresh place, a whole number of thirty-eight nines
  committed leaves its row saying "Take back last (", that whole number of thirty-eight nines, and
  ")"

#### Scenario: a take-back says a usual amount by its amount and never by its name

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place where nothing has
  been kept and a roster place holding a commitment named "Protein" of the total kind with a target
  of 120, on a schedule listing all seven weekdays, kept from 1 January 2026, declaring a usual
  amount of 20 with no name and one of 35 named "Müesli"; "12" is committed on its one row; and the
  usual amount of 35 named "Müesli" the entry of the row it then holds says is added on that row
- **THEN** the row the day screen then holds, asked as of that same day, says the take-back words
  "Take back last (35)"
- **AND** adding the usual amount of 20 with no name on the row it then holds leaves it saying
  "Take back last (20)"

#### Scenario: a row that offers no take-back says no take-back words

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of that same
  day
- **THEN** that row says no take-back words
- **AND** neither does a row of a day view formed the same way from a history an addition of 30 for
  that commitment on that date was added to and then taken back from
- **AND** neither do the rows of a day view formed on that date of a commitment named "Gym" of the
  tick kind, one named "Weight" of the number kind with a range of 40 to 150 and one named
  "Journal" of the note kind, alike in schedule and day kept from, from a history holding a tick
  for "Gym", a number of 70.5 for "Weight" and a note holding "Ran 8k." for "Journal" on that date
- **AND** the row of a day view formed on Wednesday 2 September 2026 from a history holding an
  addition of 30 for "Protein" on that date says none asked as of Monday 31 August 2026, and says
  "Take back last (30)" asked as of Wednesday 2 September 2026

## MODIFIED Requirements

### Requirement: A row offers taking back its day's last addition, and offers none where the day holds none

A row SHALL offer, when asked as of a calendar date, taking its day's last addition back, exactly
where two things hold: it offers a total entry as of that day, and the day it is for holds at least
one addition. Where either fails it SHALL offer no such thing. The take-back SHALL be a second thing
the row offers, beside the entry, and MUST NOT be the entry's own gesture. Whether the day holds an
addition SHALL be read off the day's sum being above zero, and this capability SHALL NOT ask for any
addition but the day's last. A row that offers no take-back MUST NOT be hidden, MUST NOT be drawn as
kept, and MUST NOT be given some other act in its place; it offers a total entry like every other
total row and says its name, its rhythm and whether the day is kept.

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

### Requirement: A row is its commitment, its date and what that day holds

A row SHALL be its commitment, its day view's date, whether that day is kept, whether it is declined
and with what reason or none, and, for a number, a note or a total, what that day holds, its starting number or none, for a total the usual amounts its
commitment declares, and, only where its commitment is on a weekly quota, its standing on that date
and what its week owes, and, where a shift took its due day from that date or put one on it, the
day that due day went to or came from. Two rows SHALL be the same row when all of these agree, and SHALL be
different when any one differs.

Two rows of one commitment on one date SHALL be different rows where their days hold different
numbers or notes, or additions summing differently or ending in different amounts, and SHALL be the
same row where their days' additions differ but sum alike and end in the same amount, a total row
holding the day's sum and its day's last addition and never the additions before it. A row SHALL
hold only what its commitment's kind can put there, and every row but a total's SHALL hold a sum of
zero, as a sum rather than nothing at all.

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
  from 1 January 2026, the first from a history holding additions of 30 and then 30 for that
  commitment on that date and the second from a history holding additions of 10, then 20, then 30
  for it on that date
- **THEN** the two rows are the same row
- **AND** the entry each offers says "60 of 120"
- **AND** each, asked as of that same day, says the take-back words "Take back last (30)"

#### Scenario: two rows whose days hold additions summing alike but ending in different amounts are different rows

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, the first from a history holding additions of 30 and then 30 for that
  commitment on that date and the second from a history holding one addition of 60 for it on that
  date
- **THEN** the two rows are different rows
- **AND** the entry each offers says "60 of 120"
- **AND** the first, asked as of that same day, says the take-back words "Take back last (30)", and
  the second "Take back last (60)"
- **AND** a row formed the same way from a history holding additions of 30 and then 90 is a
  different row from one formed from a history holding 90 and then 30

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
