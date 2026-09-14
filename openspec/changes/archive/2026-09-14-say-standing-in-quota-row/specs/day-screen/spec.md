## MODIFIED Requirements

### Requirement: A row is its commitment, its date and what that day holds

A row SHALL be its commitment, its day view's date, whether that day is kept and, for a number, a
note or a total, what that day holds, and, only where its commitment is on a weekly quota, its
standing on that date. Two rows SHALL be the same row when all of these agree, and SHALL be
different when any one differs.

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

### Requirement: A row gives back what a screen draws and what a tap makes

A row SHALL be reachable only through the day view holding it, and SHALL give back four things: its
commitment's name, its rhythm in words, whether it is kept, and what it offers — a tick or the entry
its commitment's kind takes. It MUST NOT give back the commitment, its schedule, the day it is kept from, the
date, the number, the note, the sum or its standing; the number, the note and the sum SHALL be given
out only inside the entry a row offers.

The words SHALL be `schedule`'s for the commitment's schedule, said given the row's standing on a
weekly quota and plainly otherwise, and composed by no other capability. The standing SHALL be
`record`'s answer through the row's date, whatever the kind and whether or not that date has
arrived. Every row SHALL say its rhythm, always, kept or not and whatever it offers.

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
