## ADDED Requirements

### Requirement: A roster shifts an every-N-days due day onto a day between the due days either side of it, and runs its count on from there

A roster SHALL shift a due day of a commitment it holds, kept or stopped, where the era holding it
runs every N days, only onto a free day of it, and SHALL refuse every other such shift, changing
nothing. A free day SHALL be after any due day before it and before the due day after it; held by
the era holding the due day; and no day another shift of the commitment took a due day from or put
one on. It SHALL refuse the shift while another shift of the commitment has a day after the due
day, or an era of it is kept from a day after it. A day a shift put a due
day on SHALL be shifted as the day it came from would be without that shift, keeping that day, and
shifted to that day SHALL leave no shift.

#### Scenario: a roster shifts an every-N-days due day onto any day between the due days either side of it, a week crossed or not

- **WHEN** six rosters each hold a commitment named "Nails" on a schedule of every 4 days starting
  on Thursday 6 August 2026, kept from that day, and each is asked to shift its due day on Sunday 30
  August 2026 to one of Thursday 27, Friday 28 and Saturday 29 August, and Monday 31 August, Tuesday
  1 and Wednesday 2 September 2026
- **THEN** each of the six answers that it shifted it
- **AND** each still holds one era of "Nails", kept from Thursday 6 August 2026 and saying "Every
  4 days"
- **AND** a roster holding a commitment named "Contact lenses" on a schedule of every 14 days
  starting on Tuesday 25 August 2026, kept from that day, shifts its due day on Tuesday 8 September
  2026 to Saturday 5 September 2026, a day of the week before

#### Scenario: a roster refuses to shift an every-N-days due day onto a due day either side of it, a day beyond them, or itself

- **WHEN** a roster holds a commitment named "Nails" on a schedule of every 4 days starting on
  Thursday 6 August 2026, kept from that day, and is asked to shift its due day on Sunday 30 August
  2026 to Wednesday 26 August, Tuesday 25 August, Thursday 3 September and Friday 4 September 2026,
  and to Sunday 30 August 2026 itself
- **THEN** the roster refuses each of the five
- **AND** the commitment it keeps is still due on Sunday 30 August and Thursday 3 September 2026

#### Scenario: an era's first every-N-days due day is shifted back no further than the day that era is kept from

- **WHEN** a roster holds a commitment named "Nails" on a schedule of every 4 days starting on
  Thursday 6 August 2026, kept from Tuesday 4 August 2026, and is asked to shift its due day on
  Thursday 6 August 2026 to Monday 3 August 2026 and then to Tuesday 4 August 2026
- **THEN** it refuses the first and shifts the second
- **AND** the commitment it keeps is due on Tuesday 4 and Saturday 8 August 2026, and on neither
  Thursday 6 nor Monday 10 August 2026
- **AND** a roster holding a commitment named "Mood" of the number kind with a range of 1 to 10, on
  a schedule of every 4 days starting on Thursday 6 August 2026, kept from that day, given a further
  era ranging 1 to 5 on that same schedule, kept from Tuesday 1 September 2026, refuses to shift its
  due day on Thursday 3 September 2026 to Monday 31 August 2026 and shifts it to Tuesday 1 September
  2026

#### Scenario: a roster refuses to shift an every-N-days due day while a later shift or a later era of it stands

- **WHEN** a roster holds a commitment named "Nails" on a schedule of every 4 days starting on
  Thursday 6 August 2026, kept from that day, whose due day on Thursday 3 September 2026 is shifted
  to Friday 4 September 2026, and is asked to shift its due day on Sunday 30 August 2026 to Monday
  31 August 2026
- **THEN** the roster refuses it, and the commitment it keeps is still due on Sunday 30 August 2026
- **AND** a roster holding "Nails" alike, unshifted but given a further era on a schedule of every
  5 days starting on Tuesday 1 September 2026, kept from that day, refuses the same shift

#### Scenario: an every-N-days day a shift put a due day on, shifted again, keeps the day it came from and that day's bounds

- **WHEN** a roster holds a commitment named "Nails" on a schedule of every 4 days starting on
  Thursday 6 August 2026, kept from that day, whose due day on Sunday 30 August 2026 is shifted to
  Monday 31 August 2026, and is asked to shift Monday 31 August 2026 to Wednesday 2 September 2026
- **THEN** the roster answers that it shifted it
- **AND** the commitment it keeps is due on Wednesday 2 and Sunday 6 September 2026, and on none of
  Sunday 30 August, Monday 31 August and Friday 4 September 2026
- **AND** the roster then refuses to shift Wednesday 2 September 2026 to Thursday 3 September 2026
- **AND** it shifts Wednesday 2 September 2026 to Sunday 30 August 2026, leaving the commitment due
  on Sunday 30 August and Thursday 3 September 2026 and on neither Monday 31 August nor Wednesday
  2 September 2026

#### Scenario: a roster refuses to shift an every-N-days due day onto a day another shift took a due day from

- **WHEN** a roster holds a commitment named "Nails" on a schedule of every 4 days starting on
  Thursday 6 August 2026, kept from that day, whose due day on Sunday 30 August 2026 is shifted to
  Saturday 29 August 2026, and is asked to shift its due day on Wednesday 2 September 2026 to Sunday
  30 August 2026 and then to Monday 31 August 2026
- **THEN** it refuses the first and shifts the second
- **AND** the commitment it keeps is due on Saturday 29 August, Monday 31 August and Friday
  4 September 2026, and on neither Sunday 30 August nor Wednesday 2 September 2026

#### Scenario: a roster shifts an every-N-days day of a commitment it has stopped only onto a day it held

- **WHEN** a roster holds a commitment named "Nails" on a schedule of every 4 days starting on
  Thursday 6 August 2026, kept from that day, stopped as of the day it was kept until, Monday 31
  August 2026, and is asked to shift its due day on Sunday 30 August 2026 to Tuesday 1 September
  2026 and then to Monday 31 August 2026
- **THEN** it refuses the first and shifts the second
- **AND** a roster holding "Nails" alike, not stopped, whose due day on Sunday 30 August 2026 is
  shifted to Saturday 29 August 2026 and which is then stopped as of the day it was kept until,
  Saturday 29 August 2026, refuses to shift Saturday 29 August 2026 to Sunday 30 August 2026, and
  the commitment it holds is still due on Saturday 29 August 2026

### Requirement: A commitments screen keeps an every-N-days count running through a change of range or target alone

A change of range or target alone, on a commitment whose newest era runs every N days, SHALL put on
the new era with the schedule of the era it gives way to, its start date included, and the count
SHALL run on through the change from that start date, or from the day a shift put a due day on, as
*A commitment is due exactly when its schedule is due, on and after the day it is kept from, but
where a shift moved a due day* says. A change naming a different interval, or a rhythm of another
shape, SHALL start the new era's count on the day that era is kept from. An era already kept SHALL
be read with the start date it was kept with, whichever change put it on.

#### Scenario: a range or a target change keeps an every-N-days count running from its start date

- **WHEN** a commitment named "Mood" of the number kind with a range of 1 to 10, on a schedule of
  every 4 days starting on Thursday 6 August 2026, kept from that day, is taken on at a roster
  place; a commitments screen is opened at that roster place and a record place where nothing has
  been kept as of Monday 31 August 2026; and "Mood" is changed through it to a range of 1 to 5, on
  everything else it already has
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place reads back two eras of "Mood", the newer
  ranging 1 to 5, on every 4 days starting on Thursday 6 August 2026, kept from Monday 31 August
  2026
- **AND** the commitment it answers on Thursday 3 September 2026 is due on that date, and the ones
  it answers on Monday 31 August and Friday 4 September 2026 are not
- **AND** a commitment named "Protein" of the total kind with a target of 120, held alike and
  changed to a target of 150, reads back its newer era on every 4 days starting on Thursday
  6 August 2026
- **AND** "Mood" held alike and changed to a range of 1 to 5 on an interval rhythm of 5 days reads
  back its newer era on every 5 days starting on Monday 31 August 2026

#### Scenario: a range change keeps an every-N-days count running from the day a shift put a due day on

- **WHEN** a commitment named "Mood" of the number kind with a range of 1 to 10, on a schedule of
  every 4 days starting on Thursday 6 August 2026, kept from that day, is taken on at a roster place
  and its due day on Sunday 30 August 2026 is shifted there to Monday 31 August 2026; a commitments
  screen is opened at that roster place and a record place where nothing has been kept as of Tuesday
  1 September 2026; and "Mood" is changed through it to a range of 1 to 5, on everything else it
  already has
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place answers on Friday
  4 September 2026 is due on that date, and the one it answers on Thursday 3 September 2026 is not

### Requirement: A roster shifts a weekday-set or day-of-month due day onto a free day of its week

A roster SHALL shift a due day of a commitment it holds, kept or stopped, where the era holding it
runs on a weekday set or a day of the month, only onto a free day, and SHALL refuse, changing
nothing, every other such shift, a weekly-quota day, a day not due and a commitment not held. A free day SHALL be a day of the due day's Monday-to-Sunday week, held by that same era,
that the era's schedule is not due on and that no shift of the commitment has put a due day on; for a day a shift put
there, the day it came from SHALL be free too, but only where an era holding it has a schedule due
on it. Such a day shifted again SHALL keep the day it came from, and shifted to that day SHALL leave
no shift.

#### Scenario: a roster shifts a weekday-set due day onto a free day and leaves the rest of its rhythm as it was

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and is asked to shift its due day on Monday 31 August 2026 to
  Tuesday 1 September 2026
- **THEN** the roster answers that it shifted it
- **AND** it still holds one era of "Gym", kept from 1 January 2026 and saying "Mon, Wed, Sat"
- **AND** the commitment it keeps is due on Wednesday 2 and Saturday 5 September 2026 and on Monday
  7 September 2026

#### Scenario: a roster shifts a day-of-month due day across the end of its month, inside its week

- **WHEN** a roster holds a commitment named "Finances" on a schedule on the 31st of the month, kept
  from 1 January 2026, and is asked to shift its due day on Monday 31 August 2026 to Tuesday
  1 September 2026
- **THEN** the roster answers that it shifted it
- **AND** the commitment it keeps is due on Tuesday 1 September 2026 and not on Monday 31 August
  2026
- **AND** it is due on Wednesday 30 September 2026, the last day of a month too short for its day

#### Scenario: a roster refuses to shift a due day onto one of its own days, a day another shift put a due day on, or a day of another week

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, whose due day on Wednesday 2 September 2026 is shifted to
  Thursday 3 September 2026, and is asked to shift its due day on Monday 31 August 2026 to Wednesday
  2 September 2026, to Thursday 3 September 2026, to Saturday 5 September 2026, to Tuesday
  8 September 2026 and to Monday 31 August 2026 itself
- **THEN** the roster refuses each of the five
- **AND** the commitment it keeps is still due on Monday 31 August and Thursday 3 September 2026,
  and not on Wednesday 2 September 2026

#### Scenario: a roster refuses to shift a due day onto a day the era holding it does not hold

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from Wednesday 2 September 2026, and is asked to shift its due day on that day to
  Tuesday 1 September 2026
- **THEN** the roster refuses it
- **AND** a roster holding "Gym" kept from 1 January 2026, stopped as of the day it was kept until,
  Wednesday 2 September 2026, and taken up again from Saturday 5 September 2026, refuses to shift
  its due day on Wednesday 2 September 2026 to Thursday 3, Friday 4 or Sunday 6 September 2026
- **AND** that roster shifts the same day to Tuesday 1 September 2026

#### Scenario: a roster refuses to shift a day the commitment is not due on, and a weekly-quota day

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, whose due day on Monday 31 August 2026 is shifted to Tuesday
  1 September 2026, and is asked to shift Monday 31 August 2026 to Thursday 3 September 2026, and
  Friday 4 September 2026 to Sunday 6 September 2026
- **THEN** the roster refuses both
- **AND** a roster holding a commitment named "Reading" on a weekly quota of 3 times a week, kept
  from 1 January 2026, refuses to shift its day on Monday 31 August 2026 to Tuesday 1 September 2026

#### Scenario: a roster shifts a day of a commitment it has stopped, and refuses one it does not hold

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026 and stopped as of the day it was kept until, Saturday 5
  September 2026, and is asked to shift its due day on Monday 31 August 2026 to Tuesday 1 September
  2026
- **THEN** the roster answers that it shifted it
- **AND** a roster asked the same of a commitment named "Run" it never held, or of "Gym" once it has
  deleted it, refuses it and is left as it was

#### Scenario: a day a shift put a due day on, shifted again, keeps the day it came from

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, whose due day on Monday 31 August 2026 is shifted to Tuesday
  1 September 2026, and is asked to shift Tuesday 1 September 2026 to Thursday 3 September 2026
- **THEN** the roster answers that it shifted it
- **AND** the commitment it keeps is due on Thursday 3 September 2026, and on neither Monday
  31 August nor Tuesday 1 September 2026
- **AND** the roster then shifts Thursday 3 September 2026 to Monday 31 August 2026, leaving the
  commitment due on Monday 31 August 2026 and on neither Tuesday 1 nor Thursday 3 September 2026

#### Scenario: a day a shift put a due day on, shifted to the day it came from, leaves no shift

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at two roster places; and at the first, its due day on Monday
  31 August 2026 is shifted to Tuesday 1 September 2026 and Tuesday 1 September 2026 is then shifted
  to Monday 31 August 2026
- **THEN** both shifts are answered as shifted
- **AND** the commitment the first place's roster store keeps is due on Monday 31 August 2026 and
  not on Tuesday 1 September 2026
- **AND** the content at the first place is byte-for-byte the content at the second

#### Scenario: a roster refuses to shift a due day back to the day it came from once no era is due on that day

- **WHEN** a roster holds a commitment named "Run" on a schedule listing Tuesday and Thursday, kept
  from 1 January 2026, whose due day on Tuesday 1 September 2026 is shifted to Monday 31 August
  2026, and which is then stopped as of the day it was kept until, Monday 31 August 2026; and it is
  asked to shift Monday 31 August 2026 to Tuesday 1 September 2026
- **THEN** the roster refuses it, and the commitment it holds is still due on Monday 31 August 2026
- **AND** a roster holding "Run" shifted the same way, not stopped but given a further era on a
  schedule listing Wednesday and Friday, kept from Tuesday 1 September 2026, refuses the same shift
  and is still due on Monday 31 August 2026
- **AND** a roster holding "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, whose due day on Monday 31 August 2026 is shifted to Tuesday 1 September 2026 and
  which is then given a further era on a schedule listing Wednesday and Friday, kept from Tuesday
  1 September 2026, shifts Tuesday 1 September 2026 to Monday 31 August 2026, leaving it due on
  Monday 31 August 2026 and not on Tuesday 1 September 2026

## REMOVED Requirements

### Requirement: A roster shifts a due day of a commitment it holds onto a free day of that day's week

**Reason**: it refuses every every-N-days shift, which this change makes. It is replaced by *A
roster shifts a weekday-set or day-of-month due day onto a free day of its week*, added above,
which carries it with one sentence changed and one scenario replaced.
**Migration**: every scenario is carried verbatim but "a roster refuses to shift a day the
commitment is not due on, and an every-N-days due day", replaced by "a roster refuses to shift a day
the commitment is not due on, and a weekly-quota day"; its test is renamed and its last assertion
rewritten to match.

## MODIFIED Requirements

### Requirement: A commitment is due exactly when its schedule is due, on and after the day it is kept from, but where a shift moved a due day

On the day a commitment is kept from and on every date after it, the commitment SHALL be due exactly
when the schedule it carries is due on that date, and SHALL NOT be due on any other such date, but
that a date a shift of it took a due day from SHALL NOT be due and a date a shift of it put a due
day on SHALL be due, whatever its schedule says of either. On an every-N-days schedule, the count
SHALL run from the latest day on or before the date asked about that a shift put a due day on, where
that shift took it from a day on or after the schedule's start date, in place of that start date.
Beyond its shifts it SHALL add nothing and
take nothing away: the system MUST NOT consider the commitment's name, the
current time, the device's time zone, the locale, or whether the commitment has been ticked. The
question SHALL be asked of a calendar date rather than of the present moment, and a date in the past
SHALL answer today as it did when it was today.

Delegation SHALL hold for every schedule shape the `schedule` capability defines and for every shape
added to it later. A commitment on a schedule due on no date SHALL answer that it is not due, rather
than the system treating it as an error.

#### Scenario: a commitment on a weekday-set schedule is due on a listed weekday and not on another

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is asked about Monday 31 August 2026
- **THEN** the commitment is due on that date
- **AND** the same commitment asked about Tuesday 1 September 2026 answers that it is not due

#### Scenario: a commitment on a day-of-month schedule is due on the last day of a month too short for its day

- **WHEN** a commitment named "Finances" on a schedule on the 31st of the month, kept from 1 January
  2026, is asked about 28 February 2027
- **THEN** the commitment is due on that date
- **AND** the same commitment asked about 1 March 2027 answers that it is not due

#### Scenario: a commitment on an every-N-days schedule is due on its start date and not on the day before it

- **WHEN** a commitment named "Contact lenses" on a schedule of every 14 days starting on 25 August
  2026, kept from that same 25 August 2026, is asked about 25 August 2026
- **THEN** the commitment is due on that date
- **AND** the same commitment asked about 24 August 2026 answers that it is not due

#### Scenario: two commitments with different names and the same schedule are due on the same dates

- **WHEN** a commitment named "Gym" and a commitment named "Run", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are each asked about every date from
  Monday 31 August through Sunday 6 September 2026
- **THEN** the two answer identically on all seven dates — due on 31 August, 2 September and
  5 September 2026, and not due on the other four

#### Scenario: a commitment on a schedule that is due on no date is never due

- **WHEN** a commitment named "Gym" on a schedule listing no weekday at all, kept from 1 January
  2026, is asked about each date from Monday 31 August through Sunday 6 September 2026
- **THEN** the commitment is due on none of those seven dates

#### Scenario: a commitment on a weekly-quota schedule is due on every date on and after the day it is kept from

- **WHEN** a commitment named "Reading" on a weekly quota of 3 times a week, kept from 1 January
  2026, is asked about each date from Monday 31 August through Sunday 6 September 2026
- **THEN** the commitment is due on all seven of those dates

#### Scenario: a commitment is not due on the day a shift took its due day from, and is due on the day it put it on

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, whose due day on Monday 31 August 2026 is shifted to Tuesday
  1 September 2026, and the commitment it keeps is asked about each date from Monday 31 August
  through Monday 7 September 2026
- **THEN** it is due on Tuesday 1, Wednesday 2, Saturday 5 and Monday 7 September 2026
- **AND** it is due on none of the other four, Monday 31 August 2026 among them

#### Scenario: an every-N-days commitment is due counting on from the day a shift put its due day on

- **WHEN** a roster holds a commitment named "Nails" on a schedule of every 4 days starting on
  Thursday 6 August 2026, kept from that day, whose due day on Sunday 30 August 2026 is shifted to
  Monday 31 August 2026, and the commitment it keeps is asked about each date from Wednesday 26
  August through Tuesday 8 September 2026
- **THEN** it is due on Wednesday 26 August, Monday 31 August, Friday 4 September and Tuesday
  8 September 2026
- **AND** it is due on none of the other ten, Sunday 30 August, Thursday 3 September and Monday
  7 September 2026 among them
- **AND** a commitment named "Contact lenses" on a schedule of every 14 days starting on Tuesday
  25 August 2026, kept from that day, whose due day on Tuesday 8 September 2026 is shifted to
  Saturday 5 September 2026, is due on Saturday 5 and Saturday 19 September 2026 and on neither
  Tuesday 8 nor Tuesday 22 September 2026

#### Scenario: an every-N-days count runs on from a shift only where the shift took a due day on or after its start date

- **WHEN** a roster holds a commitment named "Nails" on a schedule of every 4 days starting on
  Thursday 6 August 2026, kept from that day, whose due day on Sunday 30 August 2026 is shifted to
  Monday 31 August 2026, and a further era of "Nails", on a schedule of every 5 days starting on
  Tuesday 1 September 2026, kept from that day, is then put on it
- **THEN** the commitment it answers on Monday 31 August 2026 is due on that date
- **AND** the ones it answers on Tuesday 1 and Sunday 6 September 2026 are due on those dates, and
  the one it answers on Friday 4 September 2026 is not

### Requirement: A roster store keeps every shift at its place, and refuses a shift no roster could hold

A roster store SHALL keep every shift its roster holds at its place across the app being closed and
opened again, the day each took a due day from and the day it put it on, writing the same shifts on
every era of the commitment. A roster store holding a shift no roster could hold — its two days
in two Monday-to-Sunday weeks where an era of the commitment holds one of them and no era holding
either runs every N days, one day twice, two shifts of one commitment from one day or onto
one day, or eras of one commitment carrying different shifts — SHALL be refused as holding
something that could not be a roster, SHALL say it is not a roster store rather than a later form,
and SHALL leave the content at its place byte-for-byte as it was.

#### Scenario: a shift kept at a roster place is held by a roster store opened afterwards at the same place

- **WHEN** a roster store is opened at a roster place where nothing has been kept; a commitment
  named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, is
  taken on through it; its due day on Monday 31 August 2026 is shifted to Tuesday 1 September 2026;
  and a further era of "Gym", on a schedule listing Tuesday and Thursday, kept from Monday
  7 September 2026, is then put on it
- **THEN** a roster store opened afterwards at that place reads back two eras of "Gym"
- **AND** the commitment it answers on Tuesday 1 September 2026 is due on that date, and the one it
  answers on Monday 31 August 2026 is not

#### Scenario: a roster store holding a shift no roster could hold is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment, named "Gym", on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, holds a shift from Sunday 6 September 2026 to Monday 7 September 2026
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** a roster store at a place whose "Gym" holds a shift from Monday 31 August 2026 to that
  same day, two shifts from Monday 31 August 2026, or two eras carrying different shifts, is refused
  the same way
- **AND** the content at each place is byte-for-byte what it was before

#### Scenario: an every-N-days shift across a week is held by a roster store opened afterwards

- **WHEN** a roster store is opened at a roster place where nothing has been kept; a commitment
  named "Contact lenses" on a schedule of every 14 days starting on Tuesday 25 August 2026, kept
  from that day, is taken on through it; and its due day on Tuesday 8 September 2026 is shifted to
  Saturday 5 September 2026
- **THEN** opening a roster store afterwards at that place is not refused
- **AND** the commitment it keeps is due on Saturday 5 and Saturday 19 September 2026 and on neither
  Tuesday 8 nor Tuesday 22 September 2026

### Requirement: A roster holds the commitments a person keeps and every era of each, in the order they were taken on

A roster SHALL hold commitments in an order it holds, and SHALL read back in that order every
commitment it has not stopped keeping. A roster given no commitment SHALL hold none, as an answer
rather than a refusal, and there SHALL be no upper bound on how many it holds.

The order SHALL be the person's. The order the commitments were taken on SHALL be its initial value
and the place a newly taken-on commitment lands, and moving SHALL be the only thing that ever
changes it. A move SHALL take one of exactly two things and there SHALL be no third: a commitment,
or a group, which takes every commitment under one category with it as a block. Changing one era
for another SHALL put the second exactly where the first was, and putting a new era on a commitment
SHALL take it on in the place that commitment held; neither is a move. A roster MUST NOT sort its commitments
by name, by the day each is kept from, or by any other property of them. The order SHALL run over
every era of everything the roster holds, kept and stopped alike, and a commitment stopped SHALL keep
its place in it and return to that place when it is taken up again. A commitment deleted SHALL leave
it, and every other SHALL keep the order it had.

A roster SHALL hold, for each era it holds, at most two further things — the category its
commitment is under and the day that era was kept until — and, of the whole roster, whether deleting
emptied it, and nothing else. It MUST NOT give a commitment a position it can be asked for, a record of the day it
was added, or any other state, and MUST NOT alter a commitment it holds but by shifting a due day of it, as *A roster shifts a
weekday-set or day-of-month due day onto a free day of its week* and *A roster shifts an
every-N-days due day onto a day between the due days either side of it, and runs its count on from
there* say: one read back SHALL otherwise be the one that was put in. An identity is a part of a commitment and not a thing the roster gives it, and
the eras of one commitment are linked by carrying it. Changing one era for another SHALL NOT be
altering one. Being stopped, put under a category, changed
or given a new era SHALL give a commitment no part beyond the six *A commitment is an identity, a
name, a schedule, the day it is kept from, the kind its days take and its shifts* names, SHALL leave
its shifts as they were, and SHALL leave it answering whether it is due exactly as before. The ban on a position is a ban on a read: nothing SHALL ask a roster where a
commitment is, and moving one hands a place in rather than reading one out. A category SHALL be read
back as part of the groups the roster reads its commitments back in, and nothing SHALL ask it about
one commitment on its own.

Kept and stopped SHALL be the two states, and a commitment the roster holds SHALL be in exactly one
of them, carried by its newest era: one it is keeping has no kept-until day on that era, and one it
has stopped keeping has one. A category SHALL NOT be a third state and SHALL cut across both.
Deleting SHALL be the one thing that takes a commitment out of a roster, and a roster that deleting
has emptied SHALL NOT be the same roster as one given none.

A roster SHALL NOT consult the present moment, the device's clock, its time zone or its locale,
SHALL NOT be asked what day it is, and SHALL work only with dates it was handed, judging one only
against a day it was told a commitment was kept until and, where it shifts a due day, against the
era holding that day and that day's Monday-to-Sunday week. It MUST NOT judge a commitment's own day it
is kept from or its schedule, and MUST NOT decide whether a commitment is due.

A roster SHALL be a value: two holding the same eras of the same commitments in the same order,
each commitment in the same state and under the same category and each era with the same kept-until
day, SHALL be the same roster; two holding them in a different order SHALL be different rosters. Adding a commitment, stopping one,
deleting one, moving one or putting one under a category SHALL leave every other roster untouched.

#### Scenario: a roster that has been given no commitment holds none

- **WHEN** a roster is formed and nothing is added to it
- **THEN** the roster holds no commitments

#### Scenario: a roster reads its commitments back in the order they were added

- **WHEN** a roster is given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all three on a schedule listing Monday, Wednesday and Saturday and all three kept
  from 1 January 2026
- **THEN** the roster holds those three commitments in that order — "Water plants", then "Gym", then
  "Journaling" — and not in alphabetical order

#### Scenario: a roster does not order its commitments by the day they are kept from

- **WHEN** a roster is given a commitment named "Gym" kept from 1 March 2026, then one named "Run"
  kept from 1 January 2026, both on a schedule listing Monday, Wednesday and Saturday
- **THEN** the roster holds "Gym" first and "Run" second, in the order they were added and not in
  the order of the days they are kept from

#### Scenario: two rosters holding the same commitments in the same order are the same roster

- **WHEN** two rosters are each given a commitment named "Gym", then one named "Run", both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026
- **THEN** the two are the same roster

#### Scenario: two rosters holding the same commitments in a different order are different rosters

- **WHEN** one roster is given a commitment named "Gym" and then one named "Run", and a second
  roster is given the same two the other way round, all on a schedule listing Monday, Wednesday and
  Saturday and all kept from 1 January 2026
- **THEN** the two are different rosters

#### Scenario: adding to a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is copied, and a commitment named "Run" alike in every other
  way is added to the copy
- **THEN** the copy holds two commitments, "Gym" and then "Run"
- **AND** the roster it was copied from still holds one commitment, "Gym", and is not the same
  roster as the copy

#### Scenario: a roster holds a commitment kept from the last supported date like any other

- **WHEN** a roster is given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 31 December 9999, and then one named "Run" alike in every other way but kept
  from 1 January 2026
- **THEN** the roster holds both, in that order, and reads each back with the day it is kept from
  unchanged

#### Scenario: two rosters differing only in the category one commitment is under are different rosters

- **WHEN** two rosters are each given a commitment named "Gym", then one named "Run", both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026, and the first
  is asked to put "Gym" under the category "Sport"
- **THEN** the two are different rosters
- **AND** a third roster given the same two and asked to put "Gym" under "Sport" is the same roster
  as the first

#### Scenario: a new era put on a commitment lands in that commitment's place rather than after every commitment already there

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, then one named "Journaling", all kept from 1 January 2026,
  puts a new era on "Gym" on a schedule listing Tuesday and Thursday, kept from 1 September 2026, as
  of 31 August 2026, under no category
- **THEN** the roster reads back three commitments it is keeping, in the order "Water plants", then
  "Gym" on Tuesday and Thursday, then "Journaling"
- **AND** a commitment named "Reading" added to that roster afterwards is read back last of the four

#### Scenario: a roster store given a thousand commitments holds every one of them, in the order they were given

- **WHEN** a thousand commitments named "Commitment 1" through "Commitment 1000", all on a schedule
  listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken on through a
  roster store in that order, and a store is opened afterwards at the same place
- **THEN** the store reports of each of the thousand that it was added
- **AND** the later store's roster reads back all thousand, "Commitment 1" first, "Commitment 2"
  second and "Commitment 1000" last, in the order they were given
