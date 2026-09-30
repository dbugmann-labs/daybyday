## ADDED Requirements

### Requirement: A day screen adds a usual amount tapped in a row's total entry, and keeps the change before the day view says so

A day screen SHALL add, on one of its rows, a usual amount the total entry that row offers says, as
an addition of that usual amount's amount on the row's day, and SHALL keep the change before its day
view says so. The day SHALL keep the amount and never the name. It SHALL add one addition each time
it is asked and SHALL ask for no confirmation, and that addition SHALL be taken back as the day's
last like any other. The day view SHALL then be formed again. A change that could not be kept SHALL
be refused, reported to the caller, told on the row naming no cause, and SHALL leave the day view as
it was. An addition SHALL reach the record's place and the copy place, and nothing else.

#### Scenario: a usual amount tapped in a total entry is added to the day, and kept before the day view says so

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place where nothing has
  been kept and a roster place holding a commitment named "Protein" of the total kind with a target
  of 120, on a schedule listing all seven weekdays, kept from 1 January 2026, declaring a usual amount
  of 20 with no name and one of 35 named "Müesli"; and the usual amount of 35 named "Müesli" its one
  row's entry says is added on that row, and then again on the row it then holds
- **THEN** the entry the row the day screen then holds offers says "70 of 120"
- **AND** the day screen tells nothing on any row
- **AND** a day screen opened afterwards at the same places as of the same day says "70 of 120"
- **AND** the content at the roster place is byte-for-byte what it was before the first addition

#### Scenario: an addition made by a usual amount is taken back as the day's last

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place where nothing has
  been kept and a roster place holding a commitment named "Protein" of the total kind with a target
  of 120, on a schedule listing all seven weekdays, kept from 1 January 2026, declaring a usual amount
  of 35 named "Müesli"; "30" is committed on its one row; the usual amount of 35 named "Müesli" is
  added on the row it then holds; and that row's last addition is then taken back
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** taking back the last addition once more leaves it saying "0 of 120"

#### Scenario: a usual amount whose addition cannot be kept is refused and leaves the day view as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place that can be read
  from but not written to, holding an addition of 30 for a commitment named "Protein" of the total
  kind with a target of 120, on a schedule listing all seven weekdays, kept from 1 January 2026, on
  that date, and a roster place holding that commitment declaring a usual amount of 35 named
  "Müesli"; and that usual amount is added on its one row
- **THEN** adding it is refused with an error
- **AND** the entry the row the day screen then holds offers still says "30 of 120"
- **AND** the day screen tells, on that row, that the change could not be kept, naming no cause

#### Scenario: a day screen returned to from a commitments screen offers the usual amounts declared there

- **WHEN** a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  all seven weekdays, kept from 1 January 2026, declaring a usual amount of 20 with no name, is taken
  on at a roster place; a day screen is opened at that roster place and at a record place where
  nothing has been kept as of Monday 31 August 2026; a commitments screen opened at the same places
  changes "Protein" to a usual amount typed as "25" named "Shake", on everything else it already has;
  and the day screen is returned to
- **THEN** the entry its one row offers says one usual amount, "25" named "Shake"
- **AND** adding it on that row leaves the entry saying "25 of 120"

### Requirement: A day screen refuses a usual amount too large to add, and changes nothing for one a row's entry does not say

A day screen SHALL refuse a usual amount whose amount would take the day's sum, as arithmetic gives
it, past thirty-eight significant digits: it SHALL keep nothing, SHALL leave every addition the day
holds standing, and SHALL tell on the row that it is too large to add, as a typed amount is told. It
SHALL change nothing — nothing kept, nothing shown, nothing told — for a usual amount the total entry
of the row it is added on does not say, on a row its day view does not hold, on a row that offers no
total entry, a row for a day that has not arrived included, or on a screen that is not keeping a
record.

#### Scenario: a usual amount that would take the day's sum past what can be kept exactly is refused and told on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place where nothing has
  been kept and a roster place holding a commitment named "Protein" of the total kind with a target
  of 120, on a schedule listing all seven weekdays, kept from 1 January 2026, declaring a usual amount
  of 20 with no name; a whole number of thirty-eight nines is committed on its one row; and the usual
  amount of 20 is added on the row it then holds
- **THEN** the entry the row the day screen then holds offers says the day's sum as that whole number
  of thirty-eight nines, of 120
- **AND** the day screen tells, on that row, that it is too large to add
- **AND** a day screen opened afterwards at the same places as of the same day says the same sum

#### Scenario: a usual amount a day screen cannot add on a row changes nothing and tells nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place where nothing has
  been kept and a roster place holding a commitment named "Protein" of the total kind with a target
  of 120 declaring a usual amount of 20 with no name, one named "Creatine" of the total kind with a
  target of 5 declaring one of 5 with no name, and one named "Gym" of the tick kind, all on a
  schedule listing all seven weekdays and kept from 1 January 2026; and the usual amount of 5 its
  "Creatine" row's entry says is added on its "Protein" row, and the usual amount of 20 its "Protein"
  row's entry says is added on its "Gym" row
- **THEN** the entry its "Protein" row offers says "0 of 120" and its "Creatine" row's says "0 of 5"
- **AND** the day view says "Gym" is not kept, and the day screen tells nothing on any row
- **AND** the usual amount of 20, added on the "Protein" row of the day after once the screen is
  moved there, or on a "Protein" row of a day screen whose record place holds a run of bytes that is
  not what a record is written as, keeps nothing and tells nothing

## RENAMED Requirements

- FROM: `### Requirement: A total entry says the day's sum and the commitment's target, and says nothing else`
- TO: `### Requirement: A total entry says the day's sum, the commitment's target and its usual amounts, and says nothing else`

## MODIFIED Requirements

### Requirement: A total entry says the day's sum, the commitment's target and its usual amounts, and says nothing else

A total entry SHALL say exactly two things: the day's sum and the commitment's target, as the one
phrase `<sum> of <target>`, and the usual amounts its commitment declares. The sum SHALL be the one
the `record` capability answers for that commitment on that date, and MUST NOT be recomputed here; a
day that holds no addition SHALL say a sum of zero. The target SHALL be said as the commitment
declared it, with no digit added and none dropped, and the sum SHALL be said the same way. A total
entry SHALL say the true sum whether or not the sum has passed the target. The words SHALL be this
package's own English and no locale's. Each usual amount SHALL be said as declared, its amount with
no digit added or dropped and its name or no name, in the order a roster answers them and whichever
era holds the day; an entry SHALL say none where its commitment declares none. A total entry SHALL
say no hint. Its field is not prefilled, and this capability SHALL NOT say a value for one to be
prefilled from. A row SHALL NOT say the sum itself.

#### Scenario: a total entry says the day's sum and the commitment's target

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, from a history holding additions of 30 and 45.5 for that commitment on that date,
  and its one row is asked as of that same day
- **THEN** the entry that row offers says "75.5 of 120"
- **AND** the entry of a row for a commitment alike in every way but with a target of 0.5, asked as
  of that same day, says "75.5 of 0.5"

#### Scenario: a total entry of a day holding no addition says a sum of zero

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, the first from a history that has taken no record and the second from a
  history an addition of 30 for that commitment on that date was added to and then taken back from,
  and each one's row is asked as of that same day
- **THEN** the entry the first row offers says "0 of 120"
- **AND** the entry the second row offers says "0 of 120"

#### Scenario: a total entry says the true sum once it has passed the target

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, from a history holding additions of 120 and 30 for that commitment on that date,
  and its one row is asked as of that same day
- **THEN** the entry that row offers says "150 of 120"
- **AND** that row says the commitment is kept

#### Scenario: a row for a total commitment says its name, its rhythm and whether the day is kept, and never its sum

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, from a history holding an addition of 30 for that commitment on that date
- **THEN** the day view holds one row named "Protein"
- **AND** that row says "Mon, Wed, Sat"
- **AND** it says the commitment is not kept
- **AND** a row of a day view formed the same way but from a history holding an addition of 90
  instead says all three of those things identically

#### Scenario: a total entry says the usual amounts its commitment declares, smallest first and as declared

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place where nothing has
  been kept and a roster place holding a commitment named "Protein" of the total kind with a target
  of 120, declaring usual amounts of 45 named "Chicken breast", 35 named "Müesli", 20 with no name,
  35 with no name and 0.5 named "Salt", and one named "Creatine" alike in every way but declaring
  none, both on a schedule listing all seven weekdays and kept from 1 January 2026
- **THEN** the entry its "Protein" row offers says "0 of 120" and the usual amounts "0.5" named
  "Salt", "20" with no name, "35" with no name, "35" named "Müesli" and "45" named "Chicken breast",
  in that order
- **AND** the entry its "Creatine" row offers says no usual amounts

#### Scenario: a total entry on a day of an earlier era says the usual amounts its commitment declares now

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place where nothing has
  been kept and a roster place holding a commitment named "Protein" of the total kind with a target
  of 100, on a schedule listing all seven weekdays, kept from 1 January 2026, with a later era of it
  with a target of 120 kept from Monday 31 August 2026, declaring a usual amount of 20 with no name;
  and Monday 3 August 2026 is picked on its day picker
- **THEN** the entry its one row offers says "0 of 100"
- **AND** it says the usual amount "20" with no name

### Requirement: A row is its commitment, its date and what that day holds

A row SHALL be its commitment, its day view's date, whether that day is kept and, for a number, a
note or a total, what that day holds, its starting number or none, for a total the usual amounts its
commitment declares, and, only where its commitment is on a weekly quota, its standing on that date
and what its week owes. Two rows SHALL be the same row when all of these agree, and SHALL be
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
