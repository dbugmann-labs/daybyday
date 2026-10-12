## MODIFIED Requirements

### Requirement: A history answers what a commitment has added on a calendar date from the additions it holds

A history SHALL hold additions beside the ticks, numbers and notes it holds, and SHALL answer what a
commitment has added on a calendar date: the sum of those it holds for it on that date. A day SHALL
hold every addition made on it, in the order they were made, and a second alike in every way to one
already there SHALL be held beside it rather than replacing it. A history SHALL give out the sum,
and SHALL NOT give out any addition but the day's last.

The sum SHALL be zero where the day holds no addition and never nothing, so a history that has taken
no addition SHALL answer zero, and so SHALL one asked about a commitment whose kind is not a total,
or about a date it is not due on. Every addition is above zero, so a sum above zero SHALL mean the
day holds at least one and a sum of zero that it holds none. The answer SHALL depend on the
commitment and the date alone. An amount the system refuses SHALL leave the history exactly as it
was. Two histories holding the same ticks, numbers, notes and additions in the same order on every
day SHALL be the same history, and two holding one day's additions in different orders SHALL be
different.

#### Scenario: a history that has taken no addition answers a total of zero for a commitment on a day

- **WHEN** a history that has taken no record is asked what a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, has added on Monday 31 August 2026
- **THEN** it answers zero
- **AND** it answers zero rather than nothing

#### Scenario: additions made on one day accumulate rather than replace one another

- **WHEN** additions of 30, then 45.5, then 30 again, all for a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, on Monday 31 August 2026, are added to a history
- **THEN** the history answers that the commitment has added 105.5 on that date
- **AND** the two additions of 30 both count, so the day is not 75.5

#### Scenario: the additions of one day are not counted in another day's total

- **WHEN** additions of 30 on Monday 31 August 2026 and 45 on Wednesday 2 September 2026, both for
  a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, are added to a history
- **THEN** the history answers 30 for Monday 31 August 2026
- **AND** 45 for Wednesday 2 September 2026
- **AND** zero for Saturday 5 September 2026

#### Scenario: the additions of one commitment are not counted in another's total on the same date

- **WHEN** an addition of 30 for a commitment named "Protein" and an addition of 45 for a
  commitment named "Water", both of the total kind with a target of 120, both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026, are added to a history on
  Monday 31 August 2026
- **THEN** the history answers 30 for "Protein" on that date
- **AND** 45 for "Water" on that date

#### Scenario: a history answers a total of zero for a commitment whose kind is not a total

- **WHEN** a history holding a tick for a commitment named "Gym" of the tick kind, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026 is
  asked what that commitment has added on that date
- **THEN** it answers zero rather than refusing the question
- **AND** it answers zero for a commitment alike in every way but of the number kind with no range,
  and for one of the note kind
- **AND** it answers zero for a total commitment asked about Tuesday 1 September 2026, a date it is
  not due on

#### Scenario: an amount the system refuses leaves the day's additions standing

- **WHEN** an addition of 60 for a commitment named "Protein" of the total kind with a target of
  120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026 is added to a history, and 0 and then -30 are offered for that same commitment and
  date
- **THEN** no addition is recorded for either
- **AND** the history still answers 60 for that commitment on that date
- **AND** the history is the same as it was before the two amounts were offered

#### Scenario: two histories holding the same additions in the same order are the same history

- **WHEN** additions of 30 on Monday 31 August 2026 and 45 on Wednesday 2 September 2026, both for
  a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, are added to one history in that order
  and to another in the opposite order
- **THEN** the two histories are the same history, because no day holds two of them

#### Scenario: two histories holding one day's additions in different orders are different histories

- **WHEN** additions of 30 and then 45 for a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 are added to one history, and 45 and then 30 to another
- **THEN** the two histories are different histories
- **AND** both answer 75 for that commitment on that date

#### Scenario: a history holds ticks, numbers, notes and additions side by side and answers each on its own

- **WHEN** a tick for a commitment named "Gym" of the tick kind, a number of 70.5 for a commitment
  named "Weight" of the number kind with no range, a note holding "Ran 8k." for a commitment named
  "Journal" of the note kind, and additions of 30 and 90 for a commitment named "Protein" of the
  total kind with a target of 120, all four on a schedule listing Monday, Wednesday and Saturday
  and all kept from 1 January 2026, are added to a history on Monday 31 August 2026
- **THEN** the history answers that "Gym" has added zero on that date, and that it was kept on it
- **AND** that "Weight" has 70.5 and has added zero, and that it was kept on it
- **AND** that "Journal" has "Ran 8k." and has added zero, and that it was kept on it
- **AND** that "Protein" has added 120, has no number and no note, and was kept on it
- **AND** taking the tick back leaves "Weight" still holding 70.5, "Journal" still holding "Ran 8k."
  and "Protein" still having added 120
