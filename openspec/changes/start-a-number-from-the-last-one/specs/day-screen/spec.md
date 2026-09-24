## ADDED Requirements

### Requirement: A typed number entry says the latest number its commitment holds before its day as its starting number

Except where it says none, a number entry SHALL say as its starting number the number its day
view's history holds for the row's commitment on the latest date before the row's date that holds
one, however much earlier. Every era of that commitment SHALL count alike, and no other commitment's
number SHALL count. A number held on the row's date or later, or one taken back, SHALL NOT be it. A
row SHALL give out its starting number only inside the entry it offers.

A starting number SHALL keep nothing until it is committed: the row SHALL say whether its day is kept
as the history does, and the entry SHALL say no number for it. Committed, it SHALL be entered on the
row's date as any committed number is, and the day it came from SHALL keep its own.

#### Scenario: a typed number entry on a day holding no number says the latest number held before that day as its starting number

- **WHEN** a day view is formed on Monday 31 August 2026 of a commitment named "Weight" of the number
  kind with a range of 40 to 150, on a schedule listing all seven weekdays, kept from 1 January 2026,
  from a history holding a number of 71.8 for that commitment on Saturday 29 August 2026 and one of
  72.4 on Sunday 30 August 2026, and its one row is asked as of that same day
- **THEN** the entry that row offers says the starting number 72.4
- **AND** it says 72.4 exactly, not 72 and not 73
- **AND** it says no number, and the hint "40–150"
- **AND** the row says the commitment is not kept

#### Scenario: a number held on the entry's day or on a later day is not its starting number

- **WHEN** a day view is formed on Monday 31 August 2026 of a commitment named "Weight" of the number
  kind with a range of 40 to 150, on a schedule listing all seven weekdays, kept from 1 January 2026,
  from a history holding a number of 71.8 for that commitment on Saturday 29 August 2026, one of 73.1
  on Tuesday 1 September 2026 and one of 73.5 on Wednesday 2 September 2026, and its one row is asked
  as of Wednesday 2 September 2026
- **THEN** the entry that row offers says the starting number 71.8
- **AND** the entry of the row of a day view formed the same way on Friday 28 August 2026 says no
  starting number

#### Scenario: a starting number is the latest number held however far back it lies

- **WHEN** a day view is formed on Monday 31 August 2026 of a commitment named "Weight" of the number
  kind with a range of 40 to 150, on a schedule listing all seven weekdays, kept from 1 January 2020,
  from a history holding a number of 68 for that commitment on Wednesday 1 January 2020 and no other,
  and its one row is asked as of that same day
- **THEN** the entry that row offers says the starting number 68

#### Scenario: a number taken back is not a starting number, and the latest one still held is

- **WHEN** a day view is formed on Monday 31 August 2026 of a commitment named "Weight" of the number
  kind with a range of 40 to 150, on a schedule listing all seven weekdays, kept from 1 January 2026,
  from a history holding a number of 71.8 for that commitment on Saturday 29 August 2026, to which a
  number of 72.4 on Sunday 30 August 2026 was added and then taken back, and its one row is asked as
  of that same day
- **THEN** the entry that row offers says the starting number 71.8
- **AND** the entry of a row of a day view formed the same way from a history that has had
  Saturday's number taken back as well says no starting number

#### Scenario: a starting number is its own commitment's number and never another's

- **WHEN** a day view is formed on Monday 31 August 2026 of a commitment named "Weight" of the number
  kind with a range of 40 to 150 and a commitment named "Sleep" of the number kind with a range of 0
  to 24, both on a schedule listing all seven weekdays and both kept from 1 January 2026, from a
  history holding a number of 72.4 for "Weight" on Saturday 29 August 2026 and one of 8 for "Sleep" on
  Sunday 30 August 2026, and both its rows are asked as of that same day
- **THEN** the entry the row named "Weight" offers says the starting number 72.4
- **AND** the entry the row named "Sleep" offers says the starting number 8
- **AND** the entry of a row for a third commitment, named "Waist" and alike "Weight" in every way
  but its name, formed from that same history, says no starting number

#### Scenario: a starting number is read across every era of its commitment

- **WHEN** a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026, is taken on at a roster place; a commitments
  screen opened at that place as of Monday 31 August 2026 changes its range to 40 to 200; and a day
  screen of no commitments at all is then opened at that roster place and a record place holding a
  record in which that commitment holds the number 72.4 on Sunday 30 August 2026, as of that same day
- **THEN** the entry its one row offers says the starting number 72.4 and the hint "40–200"
- **AND** where the commitments screen changes its schedule to Monday, Wednesday and Saturday instead,
  the entry says the starting number 72.4 and the hint "40–150"

#### Scenario: a starting number keeps nothing until it is committed, and committed as it is said is entered on the day being entered

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place where nothing has
  been kept and a record place holding a record in which a commitment named "Weight" of the number
  kind with a range of 40 to 150 holds the number 72.4 on Sunday 30 August 2026, of that commitment on
  a schedule listing all seven weekdays, kept from 1 January 2026, and the record place is read once
  the screen has been opened
- **THEN** its day view says the commitment is not kept on that date
- **AND** the entry its row offers says no number and the starting number 72.4
- **AND** the content at the record place is byte-for-byte what it was once the screen was opened
- **AND** once "72.4" is committed on that row, the day view says the commitment is kept on that date
  and the entry the row it then holds offers says the number 72.4 and no starting number
- **AND** a day screen opened afterwards at the same places as of Sunday 30 August 2026 says "Weight"
  holds the number 72.4 on that date

#### Scenario: a number entered on a day is the starting number of the day after it, and taking it back takes that away

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026; it is moved to the day before; "72.4" is
  committed on its one row; and it is then moved to the day after
- **THEN** the entry the row it then holds offers says the starting number 72.4
- **AND** once it is moved to the day before, nothing at all is committed on the row it then holds,
  and it is moved to the day after again, the entry the row it then holds offers says no starting
  number

### Requirement: A number entry says no starting number where its day holds a number, where it is chosen, or where it would refuse the last number held

A number entry SHALL say no starting number where its day holds a number, where it is chosen, and
where the number that would be its starting number lies outside the range its row's commitment
declares, both bounds lying inside that range. That commitment SHALL be the era holding the row's
date, never the era the number was held under. Where that number lies outside the range, the entry
MUST NOT say an earlier number instead, however many earlier ones lie inside it. No number SHALL lie
outside the range of a commitment declaring none. Whether an entry says a starting number SHALL NOT
change the hint it says, nor whether it is chosen or typed.

#### Scenario: a number entry on a day holding a number says that number and no starting number

- **WHEN** a day view is formed on Monday 31 August 2026 of a commitment named "Weight" of the number
  kind with a range of 40 to 150, on a schedule listing all seven weekdays, kept from 1 January 2026,
  from a history holding a number of 72.4 for that commitment on Sunday 30 August 2026 and one of 73.1
  on Monday 31 August 2026, and its one row is asked as of that same day
- **THEN** the entry that row offers says the number 73.1 and no starting number
- **AND** the entry of a row of a day view formed the same way from a history that has then had
  Monday's number taken back says no number and the starting number 72.4

#### Scenario: a chosen entry says no starting number

- **WHEN** a day view is formed on Monday 31 August 2026 of a commitment named "Mood" of the number
  kind with a range of 1 to 10, on a schedule listing all seven weekdays, kept from 1 January 2026,
  from a history holding a number of 7 for that commitment on Sunday 30 August 2026, and its one row
  is asked as of that same day
- **THEN** the entry that row offers is chosen and says no starting number
- **AND** it says no number, and the values 1 to 10 in order

#### Scenario: a latest number outside the range of the era holding the day is no starting number, and none earlier is said instead

- **WHEN** a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026, is taken on at a roster place; a commitments
  screen opened at that place as of Monday 31 August 2026 changes its range to 50 to 100; and a day
  screen of no commitments at all is then opened at that roster place and a record place holding a
  record in which that commitment holds the number 72.4 on Saturday 29 August 2026 and 45 on Sunday
  30 August 2026, as of that same day
- **THEN** the entry its one row offers says no starting number and no number
- **AND** it says the hint "50–100"
- **AND** where that record holds 120 on Sunday 30 August 2026 instead of 45, the entry says no
  starting number either
- **AND** where it holds 60 there instead, the entry says the starting number 60
- **AND** where it holds 50 there, or 100, the entry says that number as its starting number

#### Scenario: a commitment declaring no range takes any number held before its day as its starting number

- **WHEN** a day view is formed on Monday 31 August 2026 of a commitment named "Balance" of the number
  kind with no range, on a schedule listing all seven weekdays, kept from 1 January 2026, from a
  history holding a number of -12.75 for that commitment on Sunday 30 August 2026, and its one row is
  asked as of that same day
- **THEN** the entry that row offers says the starting number -12.75 and no hint
- **AND** where that history holds a whole number of thirty-eight nines on that date instead, the
  entry says that number as its starting number, digit for digit

## MODIFIED Requirements

### Requirement: A number entry says the range its commitment takes and the number the day already holds

A number entry SHALL say three things and no others: the number the history the day view was formed
from holds for that commitment on that date, or no number where it holds none; the range the
commitment declares, as a hint where the entry is typed and as its values where it is chosen, or no
hint where it declares none; and its starting number, or none.

The hint SHALL be the lowest bound the commitment declares, an en dash, and the highest — "40–150"
for 40 to 150 — in this package's own words and no locale's, each bound said as given, no
digit added or dropped. The number SHALL be the one the `record` capability answers for that
commitment on that date, MUST NOT be recomputed here, and SHALL be none where the history has had it
taken back. A row SHALL NOT say the number itself.

#### Scenario: a number entry says the range its commitment declares as a hint

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Weight" of the number kind with a range of 40 to 150 and a commitment
  named "Sleep" of the number kind with a range of 0 to 24, both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, and both its rows are asked as of that
  same day
- **THEN** the entry the first row offers says the hint "40–150"
- **AND** the entry the second row offers says the hint "0–24"
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

### Requirement: A row is its commitment, its date and what that day holds

A row SHALL be its commitment, its day view's date, whether that day is kept and, for a number, a
note or a total, what that day holds, its starting number or none, and, only where its commitment is
on a weekly quota, its standing on that date and what its week owes. Two rows SHALL be the same row
when all of these agree, and SHALL be different when any one differs.

Two rows of one commitment on one date SHALL be different rows where their days hold different
numbers or notes, and SHALL be the same row where their days' additions differ
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
