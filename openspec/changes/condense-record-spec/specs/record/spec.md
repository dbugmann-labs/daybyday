## MODIFIED Requirements

### Requirement: A tick is of a commitment on a calendar date it is due on

A tick SHALL be a commitment and a calendar date and nothing else: no time of day, no time zone, no
note, no count, no order.

The system SHALL refuse a tick for a commitment on a date it is not due on, and for a commitment
whose kind is not a tick on any date, whether or not its day holds a number, a note or additions at
its target, and MUST refuse rather than adjust the date or substitute another kind's record. A date
before its kept-from day SHALL take no tick, and a schedule due on no date SHALL take none; due-ness
SHALL be the `commitment` capability's answer. The system MUST NOT consult the present moment, the
time zone or the locale; a screen withholding days not yet arrived SHALL do so itself. Two ticks
SHALL be the same tick exactly where commitment and date are alike.

#### Scenario: a tick is formed for a commitment on a date it is due on

- **WHEN** a tick is offered for a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, on Monday 31 August 2026
- **THEN** a tick is formed

#### Scenario: a commitment takes no tick on a date it is not due on

- **WHEN** a tick is offered for a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, on Tuesday 1 September 2026
- **THEN** no tick is formed

#### Scenario: a commitment takes no tick on a date before the day it is kept from

- **WHEN** a tick is offered for a commitment on a schedule listing Monday, Wednesday and Saturday,
  kept from Wednesday 2 September 2026, on Monday 31 August 2026
- **THEN** no tick is formed, though the schedule is due on that date
- **AND** a tick offered for the same commitment on Wednesday 2 September 2026 is formed

#### Scenario: a commitment on a schedule due on no date takes no tick on any date

- **WHEN** a tick is offered for a commitment on a schedule listing no weekday at all, kept from
  1 January 2026, on each date from Monday 31 August through Sunday 6 September 2026
- **THEN** no tick is formed on any of those seven dates

#### Scenario: a tick is formed on the last day of a month too short for the scheduled day

- **WHEN** a tick is offered for a commitment named "Finances" on a schedule on the 31st of the
  month, kept from 1 January 2026, on 28 February 2027
- **THEN** a tick is formed
- **AND** a tick offered for the same commitment on 1 March 2027 is not formed

#### Scenario: an interval landing before the day it is kept from takes no tick and the first landing after it does

- **WHEN** a tick is offered for a commitment on a schedule of every 3 days starting on 25 August
  2026, kept from 1 September 2026, on 28 August 2026
- **THEN** no tick is formed, though the interval lands on that date
- **AND** a tick offered for the same commitment on 3 September 2026 is formed

#### Scenario: a tick is formed on a due date in the first supported year and in the last

- **WHEN** a tick is offered for a commitment on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 1583, on Monday 3 January 1583
- **THEN** a tick is formed
- **AND** a tick offered for the same commitment on Monday 27 December 9999 is formed

#### Scenario: two ticks alike in commitment and date are the same tick

- **WHEN** two ticks are formed, both for a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, and both on Monday 31 August 2026
- **THEN** the two are the same tick

#### Scenario: two ticks of the same commitment on different dates are different ticks

- **WHEN** two ticks are formed for one commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, one on Monday 31 August 2026 and one on
  Wednesday 2 September 2026
- **THEN** the two are different ticks

#### Scenario: two ticks of different commitments on the same date are different ticks

- **WHEN** two ticks are formed on Monday 31 August 2026, one for a commitment named "Gym" and one
  for a commitment named "Run", both on a schedule listing Monday, Wednesday and Saturday and both
  kept from 1 January 2026
- **THEN** the two are different ticks

#### Scenario: a commitment whose kind is not a tick takes no tick on a date it is due on

- **WHEN** a tick is offered for a commitment named "Weight" of the number kind with no range, on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August
  2026 — a date it is due on
- **THEN** no tick is formed
- **AND** no tick is formed for a commitment alike in every way but of the number kind with a range
  of 40 to 150, nor for one of the note kind, nor for one of the total kind with a target of 120
- **AND** a tick is formed for a commitment alike in every way but of the tick kind

#### Scenario: a number commitment with a number on a date still takes no tick on it

- **WHEN** a number of 70.5 for a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026 is added to a history, and a tick is offered for that same commitment on that same
  date
- **THEN** no tick is formed
- **AND** the history still answers that the commitment has 70.5 on that date

#### Scenario: a note commitment with a note on a date still takes no tick on it

- **WHEN** a note holding "Ran 8k." for a commitment named "Journal" of the note kind, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026 is
  added to a history, and a tick is offered for that same commitment on that same date
- **THEN** no tick is formed
- **AND** the history still answers that the commitment has "Ran 8k." on that date

#### Scenario: a total commitment whose day is at its target still takes no tick on it

- **WHEN** additions of 30 and then 90 for a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 are added to a history, and a tick is offered for that same commitment on
  that same date
- **THEN** no tick is formed
- **AND** the history still answers that the commitment has added 120 on that date, and that it was
  kept on it
- **AND** no tick is formed for that commitment on a date its day holds no addition either

### Requirement: A history answers whether a commitment was kept on a day from the ticks it holds

A history SHALL hold records and SHALL answer whether a commitment was kept on a calendar date: kept
exactly where it holds a record of that commitment on that date that keeps it and not kept
otherwise. A history that has taken no record SHALL answer not kept everywhere. A tick SHALL keep
its day by being there, and so SHALL a number, whatever it is, and a note, whatever it says. A total
commitment SHALL be kept exactly where the additions its day holds sum to its target or more, and
not kept where they sum to less; a number, a note or a total commitment with nothing on a date it is
due on SHALL be not kept there. Additions past the target SHALL keep the day and change nothing else
about it: a target is a floor a day must reach, never a ceiling on what may be added. A day holding
no addition SHALL sum to zero, below every target there can be, a target being above zero. The
comparison SHALL be the sum against the target, in that order and never the target against the sum.

The answer SHALL depend on the commitment and the date and on nothing else: no record of one
commitment SHALL keep another on the same date, and no record on one date SHALL keep its commitment
on another. A history SHALL answer about the commitment it was handed and never widen the question
to commitments alike to it in three parts out of four. A date the commitment is not due on SHALL be
answered not kept rather than refused. Adding a tick the history already holds SHALL leave the
history unchanged. Two histories holding the same records SHALL be the same history, whatever order
records of different commitments and days arrived in.

#### Scenario: an empty history has kept nothing

- **WHEN** a history that has taken no tick is asked whether a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, was kept on Monday 31 August 2026
- **THEN** the commitment was not kept on that date

#### Scenario: a commitment ticked on a date was kept on that date

- **WHEN** a tick for a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, on Monday 31 August 2026 is added to a history
- **THEN** the history answers that the commitment was kept on Monday 31 August 2026

#### Scenario: a commitment ticked on one date was not kept on another date it is due on

- **WHEN** a tick for a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, on Monday 31 August 2026 is added to a history
- **THEN** the history answers that the commitment was not kept on Wednesday 2 September 2026

#### Scenario: a tick of one commitment does not keep another on the same date

- **WHEN** a tick for a commitment named "Gym" on Monday 31 August 2026 is added to a history, and a
  commitment named "Run" on the same schedule listing Monday, Wednesday and Saturday and kept from
  the same 1 January 2026 is asked about
- **THEN** the history answers that "Run" was not kept on Monday 31 August 2026
- **AND** that "Gym" was

#### Scenario: a commitment was not kept on a date it is not due on

- **WHEN** a tick for a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, on Monday 31 August 2026 is added to a history, and the history is asked
  about Tuesday 1 September 2026
- **THEN** the history answers that the commitment was not kept on that date

#### Scenario: a history answers each date on its own across a week

- **WHEN** ticks for a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, on Monday 31 August 2026 and on Saturday 5 September 2026 are added to a
  history, and it is asked about each date from Monday 31 August through Sunday 6 September 2026
- **THEN** the commitment was kept on exactly 31 August and 5 September 2026, and on none of the
  other five dates

#### Scenario: adding a tick the history already holds leaves it unchanged

- **WHEN** the same tick — a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, on Monday 31 August 2026 — is added to a history twice
- **THEN** the history is the same as a history that tick was added to once

#### Scenario: two histories holding the same ticks are the same history

- **WHEN** a tick on Monday 31 August 2026 and a tick on Wednesday 2 September 2026, both for a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, are added to one history in that order and to another in the opposite order
- **THEN** the two histories are the same history

#### Scenario: a commitment whose kind is not a tick was not kept on a date it is due on

- **WHEN** a history that has taken no tick is asked whether a commitment named "Weight" of the
  number kind with no range, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, was kept on Monday 31 August 2026 — a date it is due on
- **THEN** it answers that the commitment was not kept
- **AND** a history holding a tick for a commitment alike in every way but of the tick kind, on that
  same date, still answers that the number commitment was not kept on it

#### Scenario: a number commitment with a number recorded on a date was kept on that date

- **WHEN** a number of 70.5 for a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026 is added to a history
- **THEN** the history answers that the commitment was kept on Monday 31 August 2026

#### Scenario: a number commitment due on a date with no number recorded was not kept on it

- **WHEN** a number of 70.5 for a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026 is added to a history
- **THEN** the history answers that the commitment was not kept on Wednesday 2 September 2026, a date
  it is due on
- **AND** that a commitment named "Mood" of the number kind with a range of 1 to 10, on that same
  schedule and kept from that same day, was not kept on Monday 31 August 2026

#### Scenario: every number a commitment accepts keeps its day, whatever the number is

- **WHEN** a number of 40 is added to one history, 150 to another and 95 to a third, each for a
  commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026
- **THEN** every one of the three histories answers that the commitment was kept on that date
- **AND** a history given -12.75 for a commitment alike in every way but with no range answers that
  it was kept too

#### Scenario: a commitment of the note kind and one of the total kind were not kept on a date they are due on

- **WHEN** a history holding a tick for a commitment named "Gym" of the tick kind and a number of 70.5
  for a commitment named "Weight" of the number kind with no range, both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026, on Monday 31 August 2026, is
  asked about a commitment named "Journal" of the note kind on that same schedule and kept from that
  same day
- **THEN** it answers that "Journal" was not kept on Monday 31 August 2026, a date it is due on
- **AND** it answers the same way for a commitment named "Protein" of the total kind with a target of
  120, alike in every other way

#### Scenario: a note commitment with a note recorded on a date was kept on that date

- **WHEN** a note holding "Ran 8k before work. Knee held up." for a commitment named "Journal" of
  the note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 is added to a history
- **THEN** the history answers that the commitment was kept on Monday 31 August 2026

#### Scenario: a note commitment due on a date with no note recorded was not kept on it

- **WHEN** a note holding "Ran 8k." for a commitment named "Journal" of the note kind, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026 is
  added to a history
- **THEN** the history answers that the commitment was not kept on Wednesday 2 September 2026, a
  date it is due on
- **AND** that a commitment named "Sleep" of the note kind, on that same schedule and kept from that
  same day, was not kept on Monday 31 August 2026

#### Scenario: every note a commitment accepts keeps its day, whatever it says

- **WHEN** a note holding "Ran 8k." is added to one history, one holding "Missed it, too tired." to
  another, one holding a single full stop to a third and one holding a hundred thousand characters
  to a fourth, each for a commitment named "Journal" of the note kind, on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026
- **THEN** every one of the four histories answers that the commitment was kept on that date

#### Scenario: a total commitment whose day's additions reach its target was kept on that date

- **WHEN** additions of 30 and then 90 for a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 are added to a history
- **THEN** the history answers that the commitment was kept on Monday 31 August 2026
- **AND** a history given one addition of 120 instead of the two answers the same

#### Scenario: a total commitment whose day's additions fall short of its target was not kept on it

- **WHEN** additions of 30 and then 89.99 for a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 are added to a history
- **THEN** the history answers that the commitment was not kept on that date
- **AND** a history that has taken no addition answers that the commitment was not kept on it either
- **AND** a further addition of 0.01 on that date makes it answer that the commitment was kept

#### Scenario: additions past the target keep the day and change nothing else about it

- **WHEN** additions of 120 and then 30 for a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 are added to a history
- **THEN** the history answers that the commitment was kept on that date
- **AND** it answers that the commitment has added 150 on it, rather than 120

#### Scenario: a total commitment is kept on one day and not on another from each day's own additions

- **WHEN** additions of 120 on Monday 31 August 2026 and 30 on Wednesday 2 September 2026, both for
  a commitment named "Protein" of the total kind with a target of 120, on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, are added to a history
- **THEN** the history answers that the commitment was kept on Monday 31 August 2026
- **AND** that it was not kept on Wednesday 2 September 2026
- **AND** that it was not kept on Saturday 5 September 2026, a date it is due on and has added
  nothing on

### Requirement: A tick can be taken back

A history SHALL let a tick it holds be taken back. Taking back a tick SHALL leave the history as
though that tick had never been added: the commitment SHALL be not kept on that date, and every
other tick, the same commitment on other dates and other commitments on the same date, SHALL stand
exactly as it did. The system MUST NOT keep anything of a tick that was taken back, and a history
ticked and then unticked SHALL be the same history as one that was never ticked. Taking back a tick
the history does not hold SHALL leave the history unchanged rather than being refused.

#### Scenario: a tick taken back leaves the commitment not kept on that date

- **WHEN** a tick for a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, on Monday 31 August 2026 is added to a history and then taken back
- **THEN** the history answers that the commitment was not kept on Monday 31 August 2026

#### Scenario: taking back a tick leaves the same commitment's ticks on other dates standing

- **WHEN** ticks for a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, on Monday 31 August 2026 and on Saturday 5 September 2026 are added to a
  history, and the tick on 31 August is taken back
- **THEN** the history answers that the commitment was kept on Saturday 5 September 2026
- **AND** that it was not kept on Monday 31 August 2026

#### Scenario: taking back a tick leaves another commitment's tick on the same date standing

- **WHEN** ticks on Monday 31 August 2026 for a commitment named "Gym" and for a commitment named
  "Run", both on a schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026,
  are added to a history, and the tick for "Gym" is taken back
- **THEN** the history answers that "Run" was kept on Monday 31 August 2026
- **AND** that "Gym" was not

#### Scenario: taking back a tick the history does not hold leaves it unchanged

- **WHEN** a tick for a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, on Saturday 5 September 2026 is added to a history, and a tick for the
  same commitment on Monday 31 August 2026, which the history does not hold, is taken back
- **THEN** the history is the same as it was before the tick was taken back
- **AND** it still answers that the commitment was kept on Saturday 5 September 2026

#### Scenario: a history ticked and then unticked is the same as one never ticked

- **WHEN** a tick for a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, on Monday 31 August 2026 is added to a history and then taken back
- **THEN** the history is the same as a history that has taken no tick

### Requirement: A store that cannot be read is refused rather than emptied

Opening a store at a place holding something this app cannot read as a store SHALL be refused with
an error. The store MUST NOT answer with an empty history, overwrite, move or delete what is there,
or keep the part of it that could be read: the whole SHALL be refused and what is at that place left
unchanged. What this app cannot read as a store SHALL include content that is not a store at all, a
store written in a form later than the one this app knows, and a store holding something that could
not be a record: a date that names no day, a commitment on a date it is not due on, a record against
a commitment of another kind, a number outside the range its commitment declares, a note whose text
says nothing, an addition of an amount that is not above zero, or a day carrying no addition at all.

Every rule a record is formed by SHALL be applied again to what comes off the place, and this
capability SHALL add no rule there and drop none: a note SHALL NOT be read back more leniently than
it was written. Each addition SHALL be re-formed on its own, and no rule SHALL be applied across a
day. A store holding a day whose additions sum to more than this system can keep exactly SHALL be
read rather than refused, and that day SHALL answer whatever its additions come to. What a day's
additions may sum to SHALL be judged in the `day-screen` capability and never in this one, and no
rule of that kind SHALL be applied to what comes off the place.

#### Scenario: content that is not a store is refused and left as it was

- **WHEN** a store is opened at a place holding content that is not a store — a run of bytes that
  is not what the store writes
- **THEN** opening is refused with an error
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a store written in a later form than this app knows is refused

- **WHEN** a store is opened at a place holding a store written in a form one later than the form
  this app writes, holding no ticks
- **THEN** opening is refused with an error
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a store holding what could not be a tick is refused

- **WHEN** a store is opened at a place holding a store in the form this app writes, whose one tick
  is of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, on Tuesday 1 September 2026 — a date the commitment is not due on
- **THEN** opening is refused with an error
- **AND** a store at a place holding one tick on 30 February 2026, a date that names no day, is
  refused the same way
- **AND** the content at each place is byte-for-byte what it was before

#### Scenario: a store holding a number its commitment would refuse is refused

- **WHEN** a store is opened at a place holding a store in the form this app writes, whose one number
  is 300 for a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026 — a
  number outside its commitment's range
- **THEN** opening is refused with an error
- **AND** a store at a place holding one number of 70.5 against a commitment alike in every way but
  of the tick kind is refused the same way
- **AND** a store at a place holding one number of 70.5 on Tuesday 1 September 2026, a date its
  commitment is not due on, is refused the same way
- **AND** the content at each place is byte-for-byte what it was before

#### Scenario: a store holding a note that could not be a note is refused

- **WHEN** a store is opened at a place holding a store in the form this app writes, whose one note
  holds a text of three spaces, for a commitment named "Journal" of the note kind, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026 — a
  text that says nothing
- **THEN** opening is refused with an error
- **AND** a store at a place holding one note holding "Ran 8k." against a commitment alike in every
  way but of the tick kind is refused the same way
- **AND** a store at a place holding one note holding "Ran 8k." on Tuesday 1 September 2026, a date
  its commitment is not due on, is refused the same way
- **AND** the content at each place is byte-for-byte what it was before

#### Scenario: a store holding what could not be an addition is refused

- **WHEN** a store is opened at a place holding a store in the form this app writes, whose one day of
  additions holds an amount of 0, for a commitment named "Protein" of the total kind with a target of
  120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026 — an amount that is not above zero
- **THEN** opening is refused with an error
- **AND** a store at a place holding a day of additions holding -30 is refused the same way
- **AND** a store at a place holding one addition of 30 against a commitment alike in every way but
  of the tick kind is refused the same way
- **AND** a store at a place holding one addition of 30 on Tuesday 1 September 2026, a date its
  commitment is not due on, is refused the same way
- **AND** a store at a place holding a day carrying no addition at all is refused the same way
- **AND** the content at each place is byte-for-byte what it was before

#### Scenario: a store holding a day whose additions sum past what can be kept exactly is read rather than refused

- **WHEN** a store is opened at a place holding a store in the form this app writes, whose one day
  holds an addition of a whole number of thirty-eight nines and then an addition of 0.5 — two amounts
  each of which is an addition, and a day no person using this app could have made, because their
  exact sum needs thirty-nine significant digits — for a commitment named "Protein" of the total kind
  with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, on Monday 31 August 2026
- **THEN** it opens without error
- **AND** it answers that the commitment was kept on that date, its day's sum being far past 120
- **AND** the content at that place is byte-for-byte what it was before

### Requirement: A number is of a number commitment on a calendar date it is due on

A number SHALL be exactly a commitment, a calendar date and one decimal number and nothing else: no
unit, no time of day, no time zone, no note beside it, no order.

The system SHALL refuse to form a number on a date its commitment is not due on, a date before its
kept-from day and every date of a schedule due on none included, and for a commitment whose kind is
not a number on any date, whether or not that day holds a note or additions; it MUST refuse rather
than adjust or substitute. Where a commitment declares a range, a number below the lowest or above
the highest SHALL be refused and one at either end or between SHALL be formed; a range is bounds
only, and SHALL NOT require a whole number, fix a step or enumerate the values it allows. Where it
declares none, every number SHALL be formed, negative, zero or very large alike. A value that is not
a number SHALL be refused where the record is formed, range or no range. A number formed SHALL be
the number given rather than one rounded or shortened. Two numbers SHALL be the same number exactly
where commitment, date and number are alike.

#### Scenario: a number is recorded for a number commitment on a date it is due on

- **WHEN** 70.5 is offered for a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026
- **THEN** a number is recorded
- **AND** 70.5 is offered for a commitment alike in every way but of the number kind with no range,
  on that same date, and a number is recorded

#### Scenario: a number commitment takes no number on a date it is not due on

- **WHEN** 70.5 is offered for a commitment named "Weight" of the number kind with no range, on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Tuesday 1 September
  2026
- **THEN** no number is recorded
- **AND** no number is recorded for the same commitment kept from Wednesday 2 September 2026 on
  Monday 31 August 2026, a date its schedule is due on but its kept-from day is not reached by
- **AND** no number is recorded for a commitment alike in every way but on a schedule listing no
  weekday at all, on any date from Monday 31 August through Sunday 6 September 2026

#### Scenario: a commitment whose kind is not a number takes no number on a date it is due on

- **WHEN** 70.5 is offered for a commitment named "Gym" of the tick kind, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026 — a date it is
  due on
- **THEN** no number is recorded
- **AND** no number is recorded for a commitment alike in every way but of the note kind, nor for one
  of the total kind with a target of 120
- **AND** a number is recorded for a commitment alike in every way but of the number kind with no
  range

#### Scenario: a number outside the commitment's range is not recorded

- **WHEN** 300 is offered for a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026
- **THEN** no number is recorded
- **AND** no number is recorded for 39.9 on that same commitment and date
- **AND** a number is recorded for 70.5 on that same commitment and date

#### Scenario: a number at either end of the commitment's range is recorded

- **WHEN** 40 is offered for a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026
- **THEN** a number is recorded
- **AND** a number is recorded for 150 on that same commitment and date
- **AND** a number is recorded for 100 on a commitment alike in every way but with a range of 100 to
  100, which takes exactly one value

#### Scenario: a number between two whole numbers is recorded on a range of whole numbers

- **WHEN** 5.5 is offered for a commitment named "Mood" of the number kind with a range of 1 to 10,
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August
  2026
- **THEN** a number is recorded, and it is 5.5 rather than 5 or 6

#### Scenario: a number commitment with no range takes any number

- **WHEN** each of -12.75, 0, 0.000001 and 98765432109876543210.5 is offered for a commitment named
  "Weight" of the number kind with no range, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, on Monday 31 August 2026
- **THEN** a number is recorded for every one of them
- **AND** each records the number it was given rather than one rounded or shortened

#### Scenario: a value that is not a number is not recorded

- **WHEN** a value that is not a number is offered for a commitment named "Weight" of the number kind
  with no range, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026
- **THEN** no number is recorded
- **AND** no number is recorded for that same value on a commitment alike in every way but with a
  range of 40 to 150

#### Scenario: two numbers are the same exactly when their commitment, date and number all are

- **WHEN** two numbers of 70.5 are recorded, both for a commitment named "Weight" of the number kind
  with no range, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and
  both on Monday 31 August 2026
- **THEN** the two are the same number
- **AND** a number of 71 for that same commitment on that same date is a different number from either
- **AND** a number of 70.5 for that same commitment on Wednesday 2 September 2026 is different again
- **AND** so is a number of 70.5 on Monday 31 August 2026 for a commitment alike in every way but
  named "Weight before breakfast"

#### Scenario: a note commitment with a note on a date still takes no number on it

- **WHEN** a note holding "Ran 8k." for a commitment named "Journal" of the note kind, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026 is
  added to a history, and 70.5 is then offered for that same commitment on that same date
- **THEN** no number is recorded
- **AND** the history still answers that the commitment has "Ran 8k." on that date

#### Scenario: a total commitment with additions on a date still takes no number on it

- **WHEN** additions of 30 and then 90 for a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 are added to a history, and 70.5 is then offered for that same commitment on
  that same date
- **THEN** no number is recorded
- **AND** the history still answers that the commitment has added 120 on that date

### Requirement: A history answers what number a commitment has on a day from the numbers it holds

A history SHALL hold numbers beside its ticks, and SHALL answer what number a commitment has on a
calendar date: the number it holds there, and no number where it holds none. No number of one
commitment SHALL be read as another's on the same date, nor a number on one date as the same
commitment's on another. A commitment of another kind, and a date it is not due on, SHALL each be
answered no number rather than refused.

A history SHALL hold at most one number per commitment per day: one added where it holds one SHALL
replace it, and the history SHALL then be the same as one given only the later number. A number the
commitment refuses SHALL leave what the history holds exactly as it was. Two histories holding the
same ticks and numbers SHALL be the same history, whatever order they arrived in.

#### Scenario: a history that has taken no number has no number for a commitment on a day

- **WHEN** a history that has taken no number is asked what number a commitment named "Weight" of the
  number kind with no range, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, has on Monday 31 August 2026
- **THEN** it answers that there is no number

#### Scenario: a number added to a history is the number that commitment has on that day

- **WHEN** a number of 70.5 for a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026 is added to a history
- **THEN** the history answers that the commitment has 70.5 on Monday 31 August 2026
- **AND** the number it answers with is 70.5 exactly, not 70 and not 71

#### Scenario: a number on one date is not the number on another date the same commitment is due on

- **WHEN** a number of 70.5 for a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026 is added to a history
- **THEN** the history answers that the commitment has no number on Wednesday 2 September 2026
- **AND** a number of 71 for the same commitment on Wednesday 2 September 2026 added to that history
  leaves Monday 31 August 2026 still answering 70.5

#### Scenario: a number of one commitment is not the number of another on the same date

- **WHEN** a number of 70.5 for a commitment named "Weight" and a number of 8 for a commitment named
  "Mood", both of the number kind with no range, both on a schedule listing Monday, Wednesday and
  Saturday and both kept from 1 January 2026, are added to a history on Monday 31 August 2026
- **THEN** the history answers 70.5 for "Weight" on that date
- **AND** 8 for "Mood" on that date

#### Scenario: a number entered again on the same day replaces the one before it

- **WHEN** a number of 70.5 and then a number of 71.2, both for a commitment named "Weight" of the
  number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, on Monday 31 August 2026, are added to a history
- **THEN** the history answers that the commitment has 71.2 on Monday 31 August 2026
- **AND** the history is the same as a history the second number alone was added to

#### Scenario: a history has no number for a commitment whose kind is not a number

- **WHEN** a history holding a tick for a commitment named "Gym" of the tick kind, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026 is asked
  what number that commitment has on that date
- **THEN** it answers that there is no number rather than refusing the question
- **AND** it answers the same way for a commitment alike in every way but of the note kind, and for
  one of the total kind with a target of 120
- **AND** it answers the same way for a number commitment asked about Tuesday 1 September 2026, a
  date it is not due on

#### Scenario: a number the commitment refuses leaves the number already on that day standing

- **WHEN** a number of 70.5 for a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026 is added to a history, and 300 is then offered for that same commitment and date
- **THEN** no number is recorded for 300
- **AND** the history still answers that the commitment has 70.5 on Monday 31 August 2026
- **AND** the history is the same as it was before 300 was offered

#### Scenario: two histories holding the same numbers are the same history

- **WHEN** a number of 70.5 on Monday 31 August 2026 and a number of 71 on Wednesday 2 September
  2026, both for a commitment named "Weight" of the number kind with a range of 40 to 150, on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, are added to one history
  in that order and to another in the opposite order
- **THEN** the two histories are the same history

#### Scenario: a history holds ticks and numbers side by side and answers each on its own

- **WHEN** a tick for a commitment named "Gym" of the tick kind and a number of 70.5 for a commitment
  named "Weight" of the number kind with no range, both on a schedule listing Monday, Wednesday and
  Saturday and both kept from 1 January 2026, are added to a history on Monday 31 August 2026
- **THEN** the history answers that "Gym" has no number on that date, and that it was kept on it
- **AND** that "Weight" has 70.5 on that date, and that it was kept on it
- **AND** taking the tick back leaves "Weight" still holding 70.5

### Requirement: A number can be taken back

A history SHALL let the number it holds for a commitment on a calendar date be taken back by that
commitment and that date rather than by the number itself. Taking a number back SHALL leave the
history as though that number had never been added: the day SHALL hold no number, the commitment
SHALL be not kept on that date, and every other number SHALL stand exactly as it did, as SHALL every
tick. The system MUST NOT keep anything of a number that was taken back, and a history given a
number and then taken back SHALL be the same history as one that was never given one. Taking back
where the history holds no number there SHALL leave the history unchanged rather than being refused,
whether nothing was ever entered, the commitment's kind is not a number, or it is not due on that
date.

#### Scenario: a number taken back leaves the day holding no number and the commitment not kept on it

- **WHEN** a number of 70.5 for a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026 is added to a history, and that commitment's number on that date is taken back
- **THEN** the history answers that the commitment has no number on Monday 31 August 2026
- **AND** that it was not kept on that date

#### Scenario: taking back a number leaves the same commitment's numbers on other days standing

- **WHEN** numbers of 70.5 on Monday 31 August 2026 and 71 on Saturday 5 September 2026, both for a
  commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, are added to a history, and the number on
  31 August is taken back
- **THEN** the history answers that the commitment has 71 on Saturday 5 September 2026
- **AND** that it has no number on Monday 31 August 2026

#### Scenario: taking back a number leaves another commitment's number on the same day standing

- **WHEN** a number of 70.5 for a commitment named "Weight" and a number of 8 for a commitment named
  "Mood", both of the number kind with no range, both on a schedule listing Monday, Wednesday and
  Saturday and both kept from 1 January 2026, are added to a history on Monday 31 August 2026, and
  "Weight"'s number on that date is taken back
- **THEN** the history answers that "Mood" has 8 on Monday 31 August 2026
- **AND** that "Weight" has no number on it

#### Scenario: taking back a number where the history holds none leaves it unchanged

- **WHEN** a number of 70.5 for a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Saturday
  5 September 2026 is added to a history, and that commitment's number on Monday 31 August 2026,
  which the history does not hold, is taken back
- **THEN** the history is the same as it was before the number was taken back
- **AND** taking back a number for a commitment alike in every way but of the tick kind, and taking
  one back on Tuesday 1 September 2026, each leave it unchanged too

#### Scenario: a history given a number and then taken back is the same as one never given one

- **WHEN** a number of 70.5 for a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026 is added to a history and then taken back
- **THEN** the history is the same as a history that has taken no record at all

### Requirement: A note is of a note commitment on a calendar date it is due on

A note SHALL be a commitment, a calendar date and one text, and nothing else; the system SHALL
refuse to form one for a commitment on a calendar date it is not due on, and for a commitment whose
kind is not a note on any date, whatever that day holds; it MUST refuse rather than adjust or
substitute.

A text empty or made only of blank space SHALL be refused; the system MUST NOT accept such a text
and keep no note, and MUST NOT substitute a placeholder of its own. Blank space SHALL mean
whitespace judged by the test a commitment name is judged by, and a character that test does not
call whitespace SHALL NOT be blank space here. Every other text SHALL be a note, of any length and
any script, and MAY hold a line break. It SHALL be kept exactly as given, blank space at its start
or end included. Two notes SHALL be the same exactly when their commitment, date and text all are.

#### Scenario: a note is recorded for a note commitment on a date it is due on

- **WHEN** the text "Ran 8k before work. Knee held up." is offered for a commitment named "Journal"
  of the note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026,
  on Monday 31 August 2026
- **THEN** a note is recorded

#### Scenario: a note commitment takes no note on a date it is not due on

- **WHEN** the text "Ran 8k." is offered for a commitment named "Journal" of the note kind, on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Tuesday 1 September
  2026
- **THEN** no note is recorded
- **AND** no note is recorded for the same commitment kept from Wednesday 2 September 2026 on
  Monday 31 August 2026, a date its schedule is due on but its kept-from day is not reached by
- **AND** no note is recorded for a commitment alike in every way but on a schedule listing no
  weekday at all, on any date from Monday 31 August through Sunday 6 September 2026

#### Scenario: a commitment whose kind is not a note takes no note on a date it is due on

- **WHEN** the text "Ran 8k." is offered for a commitment named "Gym" of the tick kind, on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August
  2026 — a date it is due on
- **THEN** no note is recorded
- **AND** no note is recorded for a commitment alike in every way but of the number kind with no
  range, nor for one of the number kind with a range of 40 to 150, nor for one of the total kind
  with a target of 120
- **AND** a note is recorded for a commitment alike in every way but of the note kind

#### Scenario: a text that says nothing is not a note

- **WHEN** the empty text is offered for a commitment named "Journal" of the note kind, on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August
  2026
- **THEN** no note is recorded
- **AND** no note is recorded for a text of three spaces, for a text of three line breaks, for a
  text of a tab followed by a line break, or for a text of one no-break space
- **AND** a note is recorded for the text "Ran 8k." on that same commitment and date

#### Scenario: a text holding one character that is not blank space is a note, kept with the blank space around it

- **WHEN** the text " \n x \t " — a space, a line break, a space, the letter x, a space, a tab and a
  space — is offered for a commitment named "Journal" of the note kind, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026
- **THEN** a note is recorded
- **AND** the note holds that text exactly, with every space, line break and tab it was given

#### Scenario: a note takes any length, any script and a line break

- **WHEN** each of "Ran 8k before work. Knee held up.", a text of a hundred thousand characters, the
  text "שלום עולם", the text "𐐷 𝔘𝔫𝔦𝔠𝔬𝔡𝔢", a text of one emoji, and a text of three lines separated
  by line breaks is offered for a commitment named "Journal" of the note kind, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026
- **THEN** a note is recorded for every one of them
- **AND** each note holds the text it was given, character for character

#### Scenario: two notes are the same exactly when their commitment, date and text all are

- **WHEN** two notes are recorded holding the text "Ran 8k.", both for a commitment named "Journal"
  of the note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026,
  and both on Monday 31 August 2026
- **THEN** the two are the same note
- **AND** a note holding "Rested." for that same commitment on that same date is a different note
  from either
- **AND** a note holding "Ran 8k." for that same commitment on Wednesday 2 September 2026 is
  different again
- **AND** so is a note holding "Ran 8k." on Monday 31 August 2026 for a commitment alike in every
  way but named "Training journal"

#### Scenario: a total commitment with additions on a date still takes no note on it

- **WHEN** additions of 30 and then 90 for a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 are added to a history, and the text "Ran 8k." is then offered for that same
  commitment on that same date
- **THEN** no note is recorded
- **AND** the history still answers that the commitment has added 120 on that date

### Requirement: A history answers what note a commitment has on a day from the notes it holds

A history SHALL hold notes beside the ticks and numbers it holds, and SHALL answer what note a
commitment has on a calendar date: the note it holds for it on that date, character for character,
and no note where it holds none. The answer SHALL depend on the commitment and the date alone: no
commitment's note SHALL be read as another's, nor one date's as another's. A commitment whose kind
is not a note, or a date it is not due on, SHALL be answered no note rather than refused.

A commitment's day SHALL hold at most one note, a later one replacing it and leaving the same
history as one it alone was added to. A text the system refuses SHALL leave the history exactly as
it was. Two histories holding the same ticks, numbers and notes SHALL be the same history, whatever
their order of arrival.

#### Scenario: a history that has taken no note has no note for a commitment on a day

- **WHEN** a history that has taken no note is asked what note a commitment named "Journal" of the
  note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, has on
  Monday 31 August 2026
- **THEN** it answers that there is no note

#### Scenario: a note added to a history is the note that commitment has on that day

- **WHEN** a note holding "Ran 8k before work. Knee held up." for a commitment named "Journal" of
  the note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 is added to a history
- **THEN** the history answers that the commitment has that note on Monday 31 August 2026
- **AND** the text it answers with is that text exactly, character for character

#### Scenario: a note on one date is not the note on another date the same commitment is due on

- **WHEN** a note holding "Ran 8k." for a commitment named "Journal" of the note kind, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026 is
  added to a history
- **THEN** the history answers that the commitment has no note on Wednesday 2 September 2026
- **AND** a note holding "Rested." for the same commitment on Wednesday 2 September 2026 added to
  that history leaves Monday 31 August 2026 still answering "Ran 8k."

#### Scenario: a note of one commitment is not the note of another on the same date

- **WHEN** a note holding "Ran 8k." for a commitment named "Journal" and a note holding "Slept
  badly." for a commitment named "Sleep", both of the note kind, both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are added to a history on Monday
  31 August 2026
- **THEN** the history answers "Ran 8k." for "Journal" on that date
- **AND** "Slept badly." for "Sleep" on that date

#### Scenario: a note entered again on the same day replaces the one before it

- **WHEN** a note holding "Ran 8k." and then a note holding "Ran 8k. Knee held up." both for a
  commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, on Monday 31 August 2026, are added to a history
- **THEN** the history answers that the commitment has "Ran 8k. Knee held up." on Monday 31 August
  2026
- **AND** the history is the same as a history the second note alone was added to

#### Scenario: a history has no note for a commitment whose kind is not a note

- **WHEN** a history holding a tick for a commitment named "Gym" of the tick kind, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026 is
  asked what note that commitment has on that date
- **THEN** it answers that there is no note rather than refusing the question
- **AND** it answers the same way for a commitment alike in every way but of the number kind with no
  range, and for one of the total kind with a target of 120
- **AND** it answers the same way for a note commitment asked about Tuesday 1 September 2026, a date
  it is not due on

#### Scenario: a text the system refuses leaves the note already on that day standing

- **WHEN** a note holding "Ran 8k." for a commitment named "Journal" of the note kind, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026 is
  added to a history, and a text of three spaces is then offered for that same commitment and date
- **THEN** no note is recorded for the three spaces
- **AND** the history still answers that the commitment has "Ran 8k." on Monday 31 August 2026
- **AND** the history is the same as it was before the three spaces were offered

#### Scenario: two histories holding the same notes are the same history

- **WHEN** a note holding "Ran 8k." on Monday 31 August 2026 and a note holding "Rested." on
  Wednesday 2 September 2026, both for a commitment named "Journal" of the note kind, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, are added to one history in that
  order and to another in the opposite order
- **THEN** the two histories are the same history

#### Scenario: a history holds ticks, numbers and notes side by side and answers each on its own

- **WHEN** a tick for a commitment named "Gym" of the tick kind, a number of 70.5 for a commitment
  named "Weight" of the number kind with no range, and a note holding "Ran 8k." for a commitment
  named "Journal" of the note kind, all three on a schedule listing Monday, Wednesday and Saturday
  and all kept from 1 January 2026, are added to a history on Monday 31 August 2026
- **THEN** the history answers that "Gym" has no number and no note on that date, and that it was
  kept on it
- **AND** that "Weight" has 70.5 and no note on that date, and that it was kept on it
- **AND** that "Journal" has "Ran 8k." and no number on that date, and that it was kept on it
- **AND** taking the tick back leaves "Weight" still holding 70.5 and "Journal" still holding
  "Ran 8k."

### Requirement: A note can be taken back

A history SHALL let the note it holds for a commitment on a calendar date be taken back, named by
that commitment and that date rather than by the text.

Taking a note back SHALL leave the history as though that note had never been added: the day SHALL
hold no note, the commitment SHALL be not kept on that date, and every other note, tick and number
SHALL stand exactly as it did, on other days and for other commitments. Nothing of a note taken back
SHALL be kept, and a history given a note and then taken back SHALL be the same history as one never
given one. Taking back where the history holds no such note SHALL leave it unchanged rather than
being refused, whether the day was never written on, the commitment's kind is not a note, or it is
not due on that date.

#### Scenario: a note taken back leaves the day holding no note and the commitment not kept on it

- **WHEN** a note holding "Ran 8k." for a commitment named "Journal" of the note kind, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026 is
  added to a history, and that commitment's note on that date is taken back
- **THEN** the history answers that the commitment has no note on Monday 31 August 2026
- **AND** that it was not kept on that date

#### Scenario: taking back a note leaves the same commitment's notes on other days standing

- **WHEN** notes holding "Ran 8k." on Monday 31 August 2026 and "Rested." on Saturday 5 September
  2026, both for a commitment named "Journal" of the note kind, on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, are added to a history, and the note on
  31 August is taken back
- **THEN** the history answers that the commitment has "Rested." on Saturday 5 September 2026
- **AND** that it has no note on Monday 31 August 2026

#### Scenario: taking back a note leaves another commitment's note on the same day standing

- **WHEN** a note holding "Ran 8k." for a commitment named "Journal" and a note holding "Slept
  badly." for a commitment named "Sleep", both of the note kind, both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are added to a history on Monday
  31 August 2026, and "Journal"'s note on that date is taken back
- **THEN** the history answers that "Sleep" has "Slept badly." on Monday 31 August 2026
- **AND** that "Journal" has no note on it

#### Scenario: taking back a note where the history holds none leaves it unchanged

- **WHEN** a note holding "Ran 8k." for a commitment named "Journal" of the note kind, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Saturday 5 September 2026 is
  added to a history, and that commitment's note on Monday 31 August 2026, which the history does
  not hold, is taken back
- **THEN** the history is the same as it was before the note was taken back
- **AND** taking back a note for a commitment alike in every way but of the tick kind, and taking
  one back on Tuesday 1 September 2026, each leave it unchanged too

#### Scenario: a history given a note and then taken back is the same as one never given one

- **WHEN** a note holding "Ran 8k." for a commitment named "Journal" of the note kind, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026 is
  added to a history and then taken back
- **THEN** the history is the same as a history that has taken no record at all

### Requirement: An addition is of a total commitment on a calendar date it is due on

An addition SHALL be a commitment, a calendar date and one decimal number, and SHALL carry nothing
else: no unit, no time of day, no time zone, no note beside it, and no position of its own among its
day's additions. The system SHALL refuse an addition for a commitment on a date it is not due on, or
whose kind is not a total, and MUST refuse rather than adjust.

It SHALL refuse zero, every amount below zero, and any value that is not a number; it MUST NOT
accept such an amount and add nothing, and MUST NOT substitute an amount of its own. Every other
amount SHALL be an addition, kept exactly as given, no digit added or dropped. This capability SHALL
set no ceiling: what a day's additions may sum to is decided where a person makes one. Two additions
SHALL be the same exactly when their commitment, date and amount all are, which SHALL NOT make a day
given two alike hold one.

#### Scenario: an addition is recorded for a total commitment on a date it is due on

- **WHEN** 30 is offered for a commitment named "Protein" of the total kind with a target of 120,
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026
- **THEN** an addition is recorded

#### Scenario: a total commitment takes no addition on a date it is not due on

- **WHEN** 30 is offered for a commitment named "Protein" of the total kind with a target of 120,
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Tuesday
  1 September 2026
- **THEN** no addition is recorded
- **AND** no addition is recorded for the same commitment kept from Wednesday 2 September 2026 on
  Monday 31 August 2026, a date its schedule is due on but its kept-from day is not reached by
- **AND** no addition is recorded for a commitment alike in every way but on a schedule listing no
  weekday at all, on any date from Monday 31 August through Sunday 6 September 2026

#### Scenario: a commitment whose kind is not a total takes no addition on a date it is due on

- **WHEN** 30 is offered for a commitment named "Gym" of the tick kind, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026 — a date it is
  due on
- **THEN** no addition is recorded
- **AND** no addition is recorded for a commitment alike in every way but of the number kind with
  no range, nor for one of the number kind with a range of 40 to 150, nor for one of the note kind
- **AND** an addition is recorded for a commitment alike in every way but of the total kind with a
  target of 120

#### Scenario: an amount that is not above zero is not an addition

- **WHEN** 0 is offered for a commitment named "Protein" of the total kind with a target of 120, on
  a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August
  2026
- **THEN** no addition is recorded
- **AND** no addition is recorded for -30, nor for -0.000001, on that same commitment and date
- **AND** an addition is recorded for 0.000001 on that same commitment and date

#### Scenario: a value that is not a number is not an addition

- **WHEN** a value that is not a number is offered for a commitment named "Protein" of the total
  kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, on Monday 31 August 2026
- **THEN** no addition is recorded

#### Scenario: an addition takes any amount above zero, at either end of what this system holds

- **WHEN** each of 0.000001, 30, 119.95 and a whole number of thirty-eight nines is offered for a
  commitment named "Protein" of the total kind with a target of 120, on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026
- **THEN** an addition is recorded for every one of them
- **AND** each records the amount it was given rather than one rounded or shortened
- **AND** an addition of 500 is recorded on that same commitment and date, though the target is 120

#### Scenario: two additions are the same exactly when their commitment, date and amount all are

- **WHEN** two additions of 30 are recorded, both for a commitment named "Protein" of the total
  kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and both on Monday 31 August 2026
- **THEN** the two are the same addition
- **AND** an addition of 45 for that same commitment on that same date is a different addition from
  either
- **AND** an addition of 30 for that same commitment on Wednesday 2 September 2026 is different
  again
- **AND** so is an addition of 30 on Monday 31 August 2026 for a commitment alike in every way but
  named "Protein after training"

### Requirement: A history answers what a commitment has added on a day from the additions it holds

A history SHALL hold additions beside the ticks, numbers and notes it holds, and SHALL answer what a
commitment has added on a calendar date: the sum of those it holds for it on that date. A day SHALL
hold every addition made on it, in the order they were made, and a second alike in every way to one
already there SHALL be held beside it rather than replacing it. A history SHALL give out the sum and
SHALL NOT give out the additions themselves.

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

#### Scenario: an addition added to a history is the total that commitment has on that day

- **WHEN** an addition of 30 for a commitment named "Protein" of the total kind with a target of
  120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026 is added to a history
- **THEN** the history answers that the commitment has added 30 on Monday 31 August 2026
- **AND** it answers 30 exactly, neither rounded nor shortened

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

### Requirement: The last addition a day holds can be taken back

A history SHALL let the last addition of a commitment on a calendar date be taken back, named by
that commitment and date. Only the last SHALL go, and no other SHALL go except by taking back the
ones after it, one at a time. The system MUST NOT offer taking an addition back by its amount, and
MUST NOT offer clearing a day's additions in one act.

Taking it back SHALL leave the history as though that addition had never been made, keeping nothing
of it: the additions before it SHALL stand in order, the sum SHALL be short by exactly the amount
that went, and every other record SHALL stand exactly as it did; a history taken back to none SHALL
be the same as one never given any. Taking back where it holds no such addition SHALL leave it
unchanged rather than being refused, whether the day holds none, the commitment's kind is not a
total, or it is not due on that date.

#### Scenario: the last addition taken back leaves the day short by exactly that amount

- **WHEN** additions of 30 and then 90 for a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 are added to a history, and that commitment's last addition on that date is
  taken back
- **THEN** the history answers 30 for that commitment on that date
- **AND** it answers that the commitment was not kept on that date

#### Scenario: taking back the last addition twice removes the two most recent, in the order they were made

- **WHEN** additions of 30, then 45, then 50 for a commitment named "Protein" of the total kind with
  a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026,
  on Monday 31 August 2026 are added to a history, and that commitment's last addition on that date
  is taken back twice
- **THEN** the history answers 30 for that commitment on that date
- **AND** the history is the same as one the addition of 30 alone was added to

#### Scenario: taking back the only addition a day holds leaves the day holding none

- **WHEN** an addition of 120 for a commitment named "Protein" of the total kind with a target of
  120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026 is added to a history, and that commitment's last addition on that date is taken
  back
- **THEN** the history answers zero for that commitment on that date
- **AND** it answers that the commitment was not kept on that date
- **AND** the history is the same as a history that has taken no record at all

#### Scenario: taking back the last addition leaves the same commitment's other days standing

- **WHEN** additions of 30 on Monday 31 August 2026 and 45 on Saturday 5 September 2026, both for a
  commitment named "Protein" of the total kind with a target of 120, on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, are added to a history, and the last addition on
  31 August is taken back
- **THEN** the history answers 45 for that commitment on Saturday 5 September 2026
- **AND** zero for it on Monday 31 August 2026

#### Scenario: taking back the last addition leaves another commitment's day standing

- **WHEN** additions of 30 for a commitment named "Protein" and 45 for a commitment named "Water",
  both of the total kind with a target of 120, both on a schedule listing Monday, Wednesday and
  Saturday and both kept from 1 January 2026, are added to a history on Monday 31 August 2026, and
  "Protein"'s last addition on that date is taken back
- **THEN** the history answers 45 for "Water" on Monday 31 August 2026
- **AND** zero for "Protein" on it

#### Scenario: taking back where the day holds no addition leaves the history unchanged

- **WHEN** an addition of 30 for a commitment named "Protein" of the total kind with a target of
  120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Saturday
  5 September 2026 is added to a history, and that commitment's last addition on Monday 31 August
  2026, which the history holds none for, is taken back
- **THEN** the history is the same as it was before
- **AND** taking the last addition back for a commitment alike in every way but of the tick kind,
  and taking one back on Tuesday 1 September 2026, each leave it unchanged too

#### Scenario: a history given additions and taken back one by one is the same as one never given any

- **WHEN** additions of 30, then 45, then 50 for a commitment named "Protein" of the total kind with
  a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026,
  on Monday 31 August 2026 are added to a history, and that commitment's last addition on that date
  is taken back three times
- **THEN** the history is the same as a history that has taken no record at all
- **AND** taking it back a fourth time leaves it the same again

### Requirement: A history carries every record of one commitment over to another

A history SHALL carry over every record it holds of one commitment to another: each SHALL afterwards
be a record of the second, on the date it was made for, the first SHALL hold none, and the history
SHALL report that it carried them. A number SHALL be carried digit for digit, a note character for
character, a day's additions in their order.

It SHALL carry all of them or none: where any record of the first could not be one of the second, or
it already holds one of the second on any date, it SHALL refuse, report that it carried nothing, and
be left exactly as it was. A history holding no record of the first, or asked to carry a
commitment's records over to itself, SHALL change nothing and SHALL NOT refuse. It SHALL judge no
date except by asking the second commitment whether it is due.

#### Scenario: every record of a commitment is carried over to another, on the dates each was made for

- **WHEN** a history holding a tick for a commitment named "Gym" on a schedule listing all seven
  weekdays, kept from 1 January 2026, on Monday 3 August 2026 and another on Tuesday 4 August 2026 is
  asked to carry that commitment's records over to a commitment named "Gym 🏋️" alike in every other
  way
- **THEN** the history reports that it carried them over
- **AND** it answers that "Gym 🏋️" was kept on Monday 3 August 2026 and on Tuesday 4 August 2026
- **AND** it answers that "Gym" was kept on neither

#### Scenario: a number, a note and a day's additions are carried over exactly

- **WHEN** a history holding a number of 72.45 for a commitment named "Weight" of the number kind, a
  note reading " kept the promise " for one named "Journal" of the note kind, and additions of
  30, 12.5 and 30 in that order for one named "Protein" of the total kind with a target of 120 — all
  three on a schedule listing all seven weekdays, kept from 1 January 2026, all on Monday
  3 August 2026 — is asked to carry each over to a commitment alike in every way but named
  "Bodyweight", "Journalling" and "Protein grams"
- **THEN** the history reports of each that it carried them over
- **AND** it answers 72.45 for "Bodyweight", that same note character for character for
  "Journalling", and 72.5 added for "Protein grams" on that day
- **AND** taking back the last addition of "Protein grams" on that day leaves 42.5 added

#### Scenario: carrying over is refused where a record sits on a date the other commitment is not due on

- **WHEN** a history holding a tick for a commitment named "Gym" on a schedule listing all seven
  weekdays, kept from 1 June 2026, on Monday 3 August 2026 is asked to carry that commitment's
  records over to a commitment named "Gym" alike in every other way but kept from 1 September 2026
- **THEN** the history reports that it carried nothing over
- **AND** it answers that the commitment kept from 1 June 2026 was kept on Monday 3 August 2026
- **AND** it is the same history as one that was never asked

#### Scenario: carrying over is refused where the two commitments differ in the kind their days take

- **WHEN** a history holding a number of 72.45 for a commitment named "Weight" of the number kind on
  a schedule listing all seven weekdays, kept from 1 January 2026, on Monday 3 August 2026 is asked
  to carry that commitment's records over to a commitment alike in every other way of the note kind
- **THEN** the history reports that it carried nothing over
- **AND** it is the same history as one that was never asked

#### Scenario: carrying over the records of a commitment that has none refuses nothing and changes nothing

- **WHEN** a history holding a tick for a commitment named "Journaling" on a schedule listing all
  seven weekdays, kept from 1 January 2026, on Monday 3 August 2026 is asked to carry the records of
  a commitment named "Gym" alike in every other way over to one named "Gym 🏋️"
- **THEN** the history reports that it carried nothing over and does not refuse
- **AND** it is the same history as one that was never asked

#### Scenario: carrying a commitment's records over to that same commitment changes nothing and refuses nothing

- **WHEN** a history holding a tick for a commitment named "Gym" on a schedule listing all seven
  weekdays, kept from 1 January 2026, on Monday 3 August 2026 is asked to carry that commitment's
  records over to that same commitment
- **THEN** the history does not refuse
- **AND** it is the same history as one that was never asked

#### Scenario: carrying over to a commitment the history already holds a record of is refused

- **WHEN** a history holding a tick for a commitment named "Gym" on a schedule listing all seven
  weekdays, kept from 1 January 2026, on Monday 3 August 2026 and a tick for one named "Run" alike in
  every other way on Tuesday 4 August 2026 is asked to carry "Gym"'s records over to "Run"
- **THEN** the history reports that it carried nothing over
- **AND** it is the same history as one that was never asked

### Requirement: A store carries every record of one commitment over to another, at its place

A store SHALL carry every record of one commitment over to another, and SHALL keep that at its place
before it reports it carried, so a store opened at that place afterwards SHALL hold them under the
second commitment and none under the first.

A store SHALL report exactly what its history reports, and MUST NOT turn the history's refusal into
an error. A carry-over the history refused SHALL keep nothing at the place, and so SHALL one the
history had nothing to carry for. A store that could not write SHALL refuse, SHALL leave its history
exactly as it was, and SHALL say so as for every other change it could not keep. The form on disk
SHALL NOT move for a carry-over: it writes different commitment values into records already kept in
that shape, and adds no key, no field and no version to what a record is.

#### Scenario: records carried over through a store are read back under the other commitment by a store opened afterwards

- **WHEN** a tick for a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, on Monday 3 August 2026 is added to a store; that store carries "Gym"'s records
  over to a commitment named "Gym 🏋️" alike in every other way; and a store is opened afterwards at
  the same place
- **THEN** the first store reports that it carried them over
- **AND** the later store's history answers that "Gym 🏋️" was kept on Monday 3 August 2026 and that
  "Gym" was not

#### Scenario: a carry-over a store's history refuses keeps nothing at its place

- **WHEN** a tick for a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 June 2026, on Monday 3 August 2026 is added to a store, and that store is asked to carry "Gym"'s
  records over to a commitment named "Gym" alike in every other way but kept from 1 September 2026
- **THEN** the store reports that it carried nothing over, without an error
- **AND** the content at that place is byte-for-byte what it was before the store was asked

#### Scenario: a carry-over with nothing to carry keeps nothing at a store's place

- **WHEN** a tick for a commitment named "Journaling" on a schedule listing all seven weekdays, kept
  from 1 January 2026, on Monday 3 August 2026 is added to a store, and that store is asked to carry
  the records of a commitment named "Gym" alike in every other way over to one named "Gym 🏋️"
- **THEN** the store reports that it carried nothing over, without an error
- **AND** the content at that place is byte-for-byte what it was before the store was asked

#### Scenario: a store that could not write a carry-over leaves its history exactly as it was

- **WHEN** a tick for a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, on Monday 3 August 2026 is added to a store; what is at that place is then made
  impossible to write; and the store is asked to carry "Gym"'s records over to a commitment named
  "Gym 🏋️" alike in every other way
- **THEN** the store says the change could not be kept
- **AND** its history answers that "Gym" was kept on Monday 3 August 2026 and that "Gym 🏋️" was not

## REMOVED Requirements

### Requirement: A store reads a history kept before a commitment carried a kind
**Reason**: Split into the two requirements added below; no behaviour changes.
**Migration**: Every scenario is carried verbatim to one of the two added requirements.

### Requirement: A store keeps a history at a place, across the app being closed and opened again
**Reason**: Split into the two requirements added below; no behaviour changes.
**Migration**: Every scenario is carried verbatim to one of the two added requirements.

## ADDED Requirements

### Requirement: A store reads every form it has written

A store SHALL read a history kept in any form this app has written, the current form and every form
before it. It SHALL refuse a form later than the one it writes, and SHALL refuse a form number this
app has never written, one below the earliest, with an error saying the content is not a store
rather than that it is from a later form. A store SHALL read each form as the shape that form has,
and SHALL refuse one whose shape and declared form disagree. Which shape belongs to which form SHALL
be judged against the form each part was first written at, never the newest: numbers arrived at the
third form, notes the fourth, additions the fifth. Opening a store MUST NOT change what is at its
place, which SHALL stay byte-for-byte what it was: a store SHALL write only when a change is kept.

#### Scenario: reading a history kept in an earlier form changes nothing at its place

- **WHEN** a store is opened at a place holding a history written in the form used before a
  commitment carried a kind, and nothing is added to it and nothing taken back
- **THEN** the content at that place is byte-for-byte what it was before

#### Scenario: a store written in a form this app has never written is refused

- **WHEN** a store is opened at a place holding a store whose form is one below the earliest form
  this app has ever written, holding no ticks
- **THEN** opening is refused with an error
- **AND** the error says the content is not a store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a store whose shape and declared form disagree about numbers is refused

- **WHEN** a store is opened at a place holding a store written in the form used before a day could
  hold a number, which nonetheless holds one number
- **THEN** opening is refused with an error
- **AND** a store at a place holding a store in the form this app writes, with no place for numbers
  in it at all, is refused the same way
- **AND** the error says the content is not a store rather than that it is from a later form
- **AND** the content at each place is byte-for-byte what it was before

#### Scenario: a store whose shape and declared form disagree about notes is refused

- **WHEN** a store is opened at a place holding a store written in the form used before a day could
  hold a note, which nonetheless holds one note
- **THEN** opening is refused with an error
- **AND** a store at a place holding a store in the form this app writes, with no place for notes in
  it at all, is refused the same way
- **AND** a store written in the form used before a day could hold a number, holding neither numbers
  nor notes, is read without error, because that form is expected to carry neither
- **AND** the error says the content is not a store rather than that it is from a later form
- **AND** the content at each place is byte-for-byte what it was before

#### Scenario: a store whose shape and declared form disagree about additions is refused

- **WHEN** a store is opened at a place holding a store written in the form used before a day could
  hold an addition, which nonetheless holds one addition
- **THEN** opening is refused with an error
- **AND** a store at a place holding a store in the form this app writes, with no place for additions
  in it at all, is refused the same way
- **AND** a store written in the form used before a day could hold a note, holding neither notes nor
  additions, is read without error, because that form is expected to carry neither
- **AND** the error says the content is not a store rather than that it is from a later form
- **AND** the content at each place is byte-for-byte what it was before

### Requirement: Each earlier form is read as the record it always was

A history kept in the form written before a commitment carried a kind SHALL be read with every
tick's commitment of the plain kind. A history kept in the form written before a day could hold a
number SHALL be read with every tick as it stands and no number on any day; one kept before a day
could hold a note, with every tick and number as they stand and no note on any day; and one kept
before a day could hold an addition, with every tick, number and note as they stand and no addition
on any day; such a history SHALL answer a total of zero on every day and every total commitment not
kept. The next change kept there SHALL be written whole in the form this app writes, and every tick,
number and note the earlier form held SHALL still be in it.

#### Scenario: a history kept before a commitment carried a kind is read with every commitment of the plain kind

- **WHEN** a store is opened at a place holding a history written in the form used before a
  commitment carried a kind, holding one tick for a commitment named "Gym" on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026
- **THEN** it opens without error
- **AND** its history is the same as a history that tick was added to, for a commitment of the tick
  kind
- **AND** it answers that the commitment was kept on Monday 31 August 2026

#### Scenario: a tick added over a history kept in an earlier form is read back beside the ticks already there

- **WHEN** a store is opened at a place holding a history written in the form used before a
  commitment carried a kind, holding one tick for a commitment named "Gym" on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026; a tick for
  that same commitment on Wednesday 2 September 2026 is added to it; and a store is opened
  afterwards at the same place
- **THEN** the later store's history is the same as a history both those ticks were added to
- **AND** it answers that the commitment was kept on both dates

#### Scenario: a history kept before a day could hold a number is read, and no day in it holds a number

- **WHEN** a store is opened at a place holding a history written in the form used before a day could
  hold a number, holding one tick for a commitment named "Gym" of the tick kind, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026
- **THEN** it opens without error
- **AND** its history is the same as a history that tick was added to
- **AND** it answers that the commitment was kept on Monday 31 August 2026
- **AND** it answers that a commitment named "Weight" of the number kind with no range, on that same
  schedule and kept from that same day, has no number on that date
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a number added over a history kept before a day could hold a number is read back beside the ticks already there

- **WHEN** a store is opened at a place holding a history written in the form used before a day could
  hold a number, holding one tick for a commitment named "Gym" of the tick kind, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026; a
  number of 70.5 for a commitment named "Weight" of the number kind with a range of 40 to 150, on
  that same schedule and kept from that same day, on Monday 31 August 2026 is added to it; and a
  store is opened afterwards at the same place
- **THEN** the later store's history is the same as a history that tick and that number were both
  added to
- **AND** it answers that "Gym" was kept on that date and that "Weight" has 70.5 on it

#### Scenario: a history kept before a day could hold a note is read, and no day in it holds a note

- **WHEN** a store is opened at a place holding a history written in the form used before a day could
  hold a note, holding one tick for a commitment named "Gym" of the tick kind and one number of 70.5
  for a commitment named "Weight" of the number kind with a range of 40 to 150, both on a schedule
  listing Monday, Wednesday and Saturday and both kept from 1 January 2026, on Monday 31 August 2026
- **THEN** it opens without error
- **AND** its history is the same as a history that tick and that number were added to
- **AND** it answers that "Gym" was kept on Monday 31 August 2026 and that "Weight" has 70.5 on it
- **AND** it answers that a commitment named "Journal" of the note kind, on that same schedule and
  kept from that same day, has no note on that date
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a note added over a history kept before a day could hold a note is read back beside the records already there

- **WHEN** a store is opened at a place holding a history written in the form used before a day could
  hold a note, holding one tick for a commitment named "Gym" of the tick kind and one number of 70.5
  for a commitment named "Weight" of the number kind with a range of 40 to 150, both on a schedule
  listing Monday, Wednesday and Saturday and both kept from 1 January 2026, on Monday 31 August 2026;
  a note holding "Ran 8k." for a commitment named "Journal" of the note kind, on that same schedule
  and kept from that same day, on Monday 31 August 2026 is added to it; and a store is opened
  afterwards at the same place
- **THEN** the later store's history is the same as a history that tick, that number and that note
  were all added to
- **AND** it answers that "Gym" was kept on that date, that "Weight" has 70.5 on it, and that
  "Journal" has "Ran 8k." on it

#### Scenario: a history kept before a day could hold an addition is read, and no day in it holds one

- **WHEN** a store is opened at a place holding a history written in the form used before a day could
  hold an addition, holding one tick for a commitment named "Gym" of the tick kind, one number of
  70.5 for a commitment named "Weight" of the number kind with a range of 40 to 150, and one note
  holding "Ran 8k." for a commitment named "Journal" of the note kind, all three on a schedule listing
  Monday, Wednesday and Saturday and all kept from 1 January 2026, on Monday 31 August 2026
- **THEN** it opens without error
- **AND** its history is the same as a history that tick, that number and that note were added to
- **AND** it answers that "Gym" was kept on Monday 31 August 2026, that "Weight" has 70.5 on it and
  that "Journal" has "Ran 8k." on it
- **AND** it answers that a commitment named "Protein" of the total kind with a target of 120, on
  that same schedule and kept from that same day, has added zero on that date and was not kept on it
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: an addition made over a history kept before a day could hold an addition is read back beside the records already there

- **WHEN** a store is opened at a place holding a history written in the form used before a day could
  hold an addition, holding one tick for a commitment named "Gym" of the tick kind and one note
  holding "Ran 8k." for a commitment named "Journal" of the note kind, both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026, on Monday 31 August 2026;
  additions of 30 and then 90 for a commitment named "Protein" of the total kind with a target of
  120, on that same schedule and kept from that same day, on Monday 31 August 2026 are made to it;
  and a store is opened afterwards at the same place
- **THEN** the later store's history is the same as a history that tick, that note and those two
  additions were added to, in that order
- **AND** it answers that "Gym" was kept on that date, that "Journal" has "Ran 8k." on it, and that
  "Protein" has added 120 on it and was kept on it

### Requirement: A store keeps what it is given before it reports it kept

A store SHALL be opened at a place and SHALL hold a history: every tick, number, note and addition
added to it and not since taken back. Opening a store where nothing has been kept SHALL give an
empty history rather than an error. Every change SHALL be kept at that place before the store
reports it kept: a record added, a record taken back, and every record of one commitment carried
over to another. A store opened at that place afterwards SHALL hold every change kept there, whether
or not the store that kept it is still open. Nothing SHALL be held only in memory. A change that
cannot be kept SHALL be refused and not held. A store SHALL hold at most one tick per commitment per
day, so adding one it already holds SHALL leave what is kept unchanged. Stores at different places
SHALL be independent.

#### Scenario: a store opened where nothing has been kept holds an empty history

- **WHEN** a store is opened at a place where no store has ever been kept
- **THEN** it opens without error
- **AND** its history is the same as a history that has taken no tick

#### Scenario: a tick added to a store is held by a second store opened at the same place while the first is still open

- **WHEN** a tick for a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, on Monday 31 August 2026 is added to a store, and a second store is then
  opened at the same place with the first still open and nothing else done to it
- **THEN** the second store's history answers that the commitment was kept on Monday 31 August 2026

#### Scenario: a tick taken back is not held by a store opened afterwards at the same place

- **WHEN** a tick for a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, on Monday 31 August 2026 is added to a store and then taken back, and a
  store is opened afterwards at the same place
- **THEN** the later store's history answers that the commitment was not kept on Monday 31 August
  2026
- **AND** its history is the same as a history that has taken no tick

#### Scenario: a store opened again holds exactly the ticks added and not taken back

- **WHEN** ticks are added to a store for a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August, Wednesday 2 September and
  Saturday 5 September 2026, and for a commitment named "Run" on the same schedule and kept from the
  same day on Monday 31 August 2026; the tick for "Gym" on 2 September is taken back; and a store is
  opened afterwards at the same place
- **THEN** the later store's history is the same as a history to which exactly the three remaining
  ticks were added

#### Scenario: adding a tick the store already holds leaves what is kept unchanged

- **WHEN** the same tick — a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, on Monday 31 August 2026 — is added to a store twice, and a
  store is opened afterwards at the same place
- **THEN** the later store's history is the same as a history that tick was added to once

#### Scenario: stores at different places hold different histories

- **WHEN** a tick for a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, on Monday 31 August 2026 is added to a store at one place, and a store
  is opened at a different place where nothing has been kept
- **THEN** the second store's history is the same as a history that has taken no tick
- **AND** a store opened afterwards at the first place answers that the commitment was kept on
  Monday 31 August 2026

#### Scenario: a tick that cannot be kept is refused and not held

- **WHEN** a store is opened at a place where nothing can be written — a path beneath an existing
  ordinary file — and a tick for a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, on Monday 31 August 2026 is added to it
- **THEN** adding the tick is refused with an error
- **AND** the store's history is still the same as a history that has taken no tick
- **AND** a store opened afterwards at the same place holds an empty history

#### Scenario: a number added to a store is held by a second store opened at the same place while the first is still open

- **WHEN** a number of 70.5 for a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026 is added to a store, and a second store is then opened at the same place with the
  first still open and nothing else done to it
- **THEN** the second store's history answers that the commitment has 70.5 on Monday 31 August 2026
- **AND** that it was kept on that date

#### Scenario: a number taken back is not held by a store opened afterwards at the same place

- **WHEN** a number of 70.5 for a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026 is added to a store and then taken back, and a store is opened afterwards at the
  same place
- **THEN** the later store's history answers that the commitment has no number on Monday 31 August
  2026
- **AND** its history is the same as a history that has taken no record

#### Scenario: a store opened again holds exactly the ticks and numbers added and not taken back

- **WHEN** a tick for a commitment named "Gym" of the tick kind on Monday 31 August 2026 and on
  Wednesday 2 September 2026, and numbers of 70.5 on Monday 31 August 2026 and 71 on Wednesday
  2 September 2026 for a commitment named "Weight" of the number kind with a range of 40 to 150 —
  both commitments on a schedule listing Monday, Wednesday and Saturday and both kept from 1 January
  2026 — are added to a store; the tick on 2 September and the number on 31 August are taken back;
  and a store is opened afterwards at the same place
- **THEN** the later store's history is the same as a history to which exactly the one remaining tick
  and the one remaining number were added
- **AND** it answers that "Gym" was kept on 31 August and not on 2 September, and that "Weight" has
  71 on 2 September and no number on 31 August

#### Scenario: a number that cannot be kept is refused and not held

- **WHEN** a store is opened at a place where nothing can be written — a path beneath an existing
  ordinary file — and a number of 70.5 for a commitment named "Weight" of the number kind with a
  range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026,
  on Monday 31 August 2026 is added to it
- **THEN** adding the number is refused with an error
- **AND** the store's history is still the same as a history that has taken no record
- **AND** a store opened afterwards at the same place holds an empty history

#### Scenario: a note added to a store is held by a second store opened at the same place while the first is still open

- **WHEN** a note holding "Ran 8k before work. Knee held up." for a commitment named "Journal" of
  the note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 is added to a store, and a second store is then opened at the same place
  with the first still open and nothing else done to it
- **THEN** the second store's history answers that the commitment has that note on Monday 31 August
  2026
- **AND** that it was kept on that date

#### Scenario: a note taken back is not held by a store opened afterwards at the same place

- **WHEN** a note holding "Ran 8k." for a commitment named "Journal" of the note kind, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026 is
  added to a store and then taken back, and a store is opened afterwards at the same place
- **THEN** the later store's history answers that the commitment has no note on Monday 31 August
  2026
- **AND** its history is the same as a history that has taken no record

#### Scenario: a store opened again holds exactly the ticks, numbers and notes added and not taken back

- **WHEN** a tick for a commitment named "Gym" of the tick kind on Monday 31 August 2026, a number
  of 70.5 for a commitment named "Weight" of the number kind with a range of 40 to 150 on that same
  date, and notes holding "Ran 8k." on Monday 31 August 2026 and "Rested." on Wednesday 2 September
  2026 for a commitment named "Journal" of the note kind — all three commitments on a schedule
  listing Monday, Wednesday and Saturday and all kept from 1 January 2026 — are added to a store;
  the number and the note on 31 August are taken back; and a store is opened afterwards at the same
  place
- **THEN** the later store's history is the same as a history to which exactly the one remaining
  tick and the one remaining note were added
- **AND** it answers that "Gym" was kept on 31 August, that "Weight" has no number on it, and that
  "Journal" has no note on 31 August and "Rested." on 2 September

#### Scenario: a note that cannot be kept is refused and not held

- **WHEN** a store is opened at a place where nothing can be written — a path beneath an existing
  ordinary file — and a note holding "Ran 8k." for a commitment named "Journal" of the note kind, on
  a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August
  2026 is added to it
- **THEN** adding the note is refused with an error
- **AND** the store's history is still the same as a history that has taken no record
- **AND** a store opened afterwards at the same place holds an empty history

#### Scenario: an addition made in a store is held by a second store opened at the same place while the first is still open

- **WHEN** an addition of 30 for a commitment named "Protein" of the total kind with a target of 120,
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August
  2026 is added to a store, and a second store is then opened at the same place with the first still
  open and nothing else done to it
- **THEN** the second store's history answers that the commitment has added 30 on Monday 31 August
  2026
- **AND** that it was not kept on that date

#### Scenario: a day's last addition taken back is not held by a store opened afterwards at the same place

- **WHEN** additions of 30 and then 90 for a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 are added to a store and the last of them is then taken back, and a store is
  opened afterwards at the same place
- **THEN** the later store's history answers that the commitment has added 30 on that date
- **AND** its history is the same as a history the addition of 30 alone was added to
- **AND** taking the last addition back once more and opening a store again leaves it the same as a
  history that has taken no record

#### Scenario: a store opened again holds exactly the ticks, numbers, notes and additions added and not taken back

- **WHEN** a tick for a commitment named "Gym" of the tick kind on Monday 31 August 2026, a number of
  70.5 for a commitment named "Weight" of the number kind with a range of 40 to 150 on that same
  date, a note holding "Ran 8k." for a commitment named "Journal" of the note kind on that same date,
  and additions of 30 on Monday 31 August 2026 and 45 on Wednesday 2 September 2026 for a commitment
  named "Protein" of the total kind with a target of 120 — all four commitments on a schedule listing
  Monday, Wednesday and Saturday and all kept from 1 January 2026 — are added to a store; the number
  and the last addition on 2 September are taken back; and a store is opened afterwards at the same
  place
- **THEN** the later store's history is the same as a history to which exactly the tick, the note and
  the addition of 30 were added
- **AND** it answers that "Gym" was kept on 31 August, that "Weight" has no number on it, that
  "Journal" has "Ran 8k." on it, and that "Protein" has added 30 on 31 August and zero on
  2 September

#### Scenario: an addition that cannot be kept is refused and not held

- **WHEN** a store is opened at a place where nothing can be written — a path beneath an existing
  ordinary file — and an addition of 30 for a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 is added to it
- **THEN** adding the addition is refused with an error
- **AND** the store's history is still the same as a history that has taken no record
- **AND** a store opened afterwards at the same place holds an empty history

### Requirement: A store persists each kind of record as exactly what it is

A store SHALL persist each record as exactly what it is and nothing else: its commitment whole, kind
included, its calendar date, and the number, text or amounts it carries, in the order they were
made. A record read back SHALL be the same record that was added: every schedule shape, any name,
any supported date, numbers and amounts digit for digit, notes character for character at every
length and in every script, blank space and line breaks included, each character in the very form
given. A store MUST NOT round or shorten a number or an amount, trim, re-spell or otherwise tidy a
note, or pass a date through an instant, a time zone or a locale. The order read back SHALL be the
order they were made in, which names the addition a take-back removes. A store SHALL keep the later
of two numbers or two notes given for one day, hold every addition a day was given, and MUST NOT
persist the day's sum.

#### Scenario: ticks of commitments on every schedule shape are read back as the same ticks

- **WHEN** ticks are added to a store for one commitment on each schedule shape the system has — a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, on Monday 31 August 2026; a commitment named "Finances" on a schedule on the 25th of the
  month, kept from 1 January 2026, on 25 September 2026; a commitment named "Plants" on a schedule
  of every 3 days starting on 25 August 2026, kept from 1 September 2026, on 3 September 2026; and a
  commitment named "Reading" on a weekly quota of 3 times a week, kept from 1 January 2026, on
  Monday 7 September 2026 — and a store is opened afterwards at the same place
- **THEN** the later store's history is the same as a history to which those same ticks were added
- **AND** it answers that each of the four commitments was kept on its date

#### Scenario: a commitment name is read back exactly, whatever it contains

- **WHEN** a tick is added to a store for a commitment whose name is "Zürich — „langer“ Lauf 🏃" followed
  by a line break and the word "Sonntags", on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, on Monday 31 August 2026, and a store is opened afterwards at the same place
- **THEN** the later store's history answers that a commitment with exactly that name, schedule and
  kept-from day was kept on Monday 31 August 2026
- **AND** its history is the same as a history that tick was added to

#### Scenario: a tick in the first supported year and one in the last are read back unchanged

- **WHEN** ticks are added to a store for a commitment on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 1583, on Monday 3 January 1583 and on Monday 27 December 9999, and a
  store is opened afterwards at the same place
- **THEN** the later store's history answers that the commitment was kept on both dates
- **AND** its history is the same as a history those two ticks were added to

#### Scenario: a number entered again is kept once by a store opened afterwards, as the later number

- **WHEN** a number of 70.5 and then a number of 71.2, both for a commitment named "Weight" of the
  number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, on Monday 31 August 2026, are added to a store, and a store is opened
  afterwards at the same place
- **THEN** the later store's history is the same as a history the second number alone was added to
- **AND** it answers that the commitment has 71.2 on Monday 31 August 2026

#### Scenario: a number is read back exactly as it was given, whatever its digits

- **WHEN** numbers of 70.5, 0.000001, -12.75, 0 and 98765432109876543210.5 are added to a store, each
  for a commitment of the number kind with no range named after the number it carries, all on a
  schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026, on Monday
  31 August 2026, and a store is opened afterwards at the same place
- **THEN** the later store's history answers each commitment with exactly the number it was given,
  neither rounded nor shortened
- **AND** its history is the same as a history those same numbers were added to

#### Scenario: a note written again is kept once by a store opened afterwards, as the later note

- **WHEN** a note holding "Ran 8k." and then a note holding "Ran 8k. Knee held up.", both for a
  commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, on Monday 31 August 2026, are added to a store, and a store is opened
  afterwards at the same place
- **THEN** the later store's history is the same as a history the second note alone was added to
- **AND** it answers that the commitment has "Ran 8k. Knee held up." on Monday 31 August 2026

#### Scenario: a note is read back exactly as it was written, whatever it contains

- **WHEN** notes are added to a store for commitments of the note kind, all on a schedule listing
  Monday, Wednesday and Saturday and all kept from 1 January 2026, on Monday 31 August 2026, each
  commitment named after the note it carries, holding in turn: a note of three lines separated by
  line breaks; a note of one emoji made of several joined characters; a note in a right-to-left
  script; a note whose letters are written as a plain letter followed by a separate accent mark; a
  note beginning and ending with a space; and a note of a hundred thousand characters — and a store
  is opened afterwards at the same place
- **THEN** the later store's history answers each commitment with exactly the note it was given,
  character for character, neither shortened nor trimmed nor re-spelled
- **AND** the note whose letters were written as a plain letter followed by a separate accent mark
  reads back written that way still, rather than as the single accented letter that says the same
  thing
- **AND** its history is the same as a history those same notes were added to

#### Scenario: a day's additions are read back in the order they were made

- **WHEN** additions of 30, then 45, then 50 for a commitment named "Protein" of the total kind with
  a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 are added to a store, and a store is opened afterwards at the same place
- **THEN** the later store's history is the same as a history those three additions were added to in
  that same order
- **AND** it answers that the commitment has added 125 on that date
- **AND** taking that day's last addition back on the later store leaves it answering 75, so the
  addition of 50 was the one the order named

#### Scenario: two additions alike in every way on one day are both read back

- **WHEN** additions of 30 and then 30 again for a commitment named "Protein" of the total kind with
  a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 are added to a store, and a store is opened afterwards at the same place
- **THEN** the later store's history answers that the commitment has added 60 on that date
- **AND** taking that day's last addition back on the later store leaves it answering 30 rather than
  zero

#### Scenario: an amount is read back exactly as it was given, whatever its digits

- **WHEN** additions of 0.000001, 30, 119.95 and a whole number of thirty-eight nines are added to a
  store, each for a commitment of the total kind with a target of 120 named after the amount it
  carries, all on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026,
  on Monday 31 August 2026, and a store is opened afterwards at the same place
- **THEN** the later store's history answers each commitment with exactly the amount it was given,
  neither rounded nor shortened
- **AND** its history is the same as a history those same additions were added to
