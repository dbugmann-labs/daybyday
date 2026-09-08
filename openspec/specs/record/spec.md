# record Specification

## Purpose

Describes what a tick is to DayByDay — a commitment on a calendar date it was due on, and nothing
more — and how a history of ticks answers whether a commitment was kept on a day. It is the record
the product exists to keep: every screen that shows a day as done or not done reads it, and the store
that makes it survive the app being closed persists exactly this shape and nothing it invented.

## Requirements

### Requirement: A store reads a history kept before a commitment carried a kind

A store SHALL read a history kept in **any form this app has written**, rather than refusing it.
Four of those forms are earlier than the one it writes now, and each has a meaning of its own.

A history kept in the form written **before a commitment carried a kind** SHALL be read with the
commitment of every tick in it as being of the plain kind. That form holds no kind for any
commitment, and a tick is of a commitment whose kind is a tick, so the plain kind is not a guess about
those ticks but the only kind any of them could have had. Refusing them would tell a person who has
been keeping this record since before this change that they have kept nothing.

A history kept in the form written **before a day could hold a number** SHALL be read with every tick
in it as it stands and with no number on any day. That form has nowhere to keep a number, and a
person upgrading to a build that can hold one has not thereby entered any.

A history kept in the form written **before a day could hold a note** SHALL be read with every tick
and every number in it as they stand and with no note on any day, for the same reason and by the
same rule: that form has nowhere to keep a note, and a person upgrading to a build that can hold one
has not thereby written any.

A history kept in the form written **before a day could hold an addition** SHALL be read with every
tick, every number and every note in it as they stand and with no addition on any day — so with a
total of zero on every day, and with every total commitment in it not kept — for the same reason and
by the same rule. Each new form this app writes adds one such reading and takes none away, so a store
that has been kept since the first form is read by the current build without a person ever being told
their record is unreadable.

Reading a history kept in an earlier form MUST NOT change what is at the place. A store writes on a
change being kept and at no other moment, so opening the app and doing nothing SHALL leave the
content byte-for-byte what it was, in the form it was already in. The next change kept there SHALL
be written in the form this app writes, whole, and every tick, every number and every note the
earlier form held SHALL still be in it.

The forms a store reads SHALL be exactly the ones this app has written — the form it writes now and
every form before it — and no others. It SHALL NOT weaken the refusal of a form *later* than the one
it writes, which is a form it cannot know the shape of, and it SHALL refuse a form number it has
never written at all — one below the earliest — as content that is not a store, because a number no
version of this app ever wrote says nothing about the shape of what follows it.

A store SHALL read each form **as the shape that form has**, rather than reading every form leniently
and inferring which one it is. A store declares the form it was written in before anything else is
read, so what may be in it is known: a store in a form written before a day could hold a number,
which nonetheless holds one, and a store in the form written now, which has no place for numbers in
it at all, are each refused as content this app never wrote — and a store in a form written before a
day could hold a note, which nonetheless holds one, and a store in the form written now with no
place for notes in it at all, are refused the same way — and so are the same two shapes about
additions. Reading them leniently would make the declared form decorative, and with a fifth form it
is what would let the shapes blur into one nobody can state.

Which shape belongs to which form SHALL be judged against **the form each part was first written
at** and never against whichever form happens to be the newest. Numbers arrived at the third form,
notes at the fourth and additions at the fifth, so a sixth form carrying something else again leaves
all three of those answers exactly where they are: a store goes on expecting a number's place from
the third form onwards, a note's from the fourth onwards and an addition's from the fifth onwards,
rather than expecting every part from whatever the newest form is.
Judging them against the newest would make each new form silently re-declare the shape of the ones
before it, which is the reading this requirement exists to refuse.

#### Scenario: a history kept before a commitment carried a kind is read with every commitment of the plain kind

- **WHEN** a store is opened at a place holding a history written in the form used before a
  commitment carried a kind, holding one tick for a commitment named "Gym" on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026
- **THEN** it opens without error
- **AND** its history is the same as a history that tick was added to, for a commitment of the tick
  kind
- **AND** it answers that the commitment was kept on Monday 31 August 2026

#### Scenario: reading a history kept in an earlier form changes nothing at its place

- **WHEN** a store is opened at a place holding a history written in the form used before a
  commitment carried a kind, and nothing is added to it and nothing taken back
- **THEN** the content at that place is byte-for-byte what it was before

#### Scenario: a tick added over a history kept in an earlier form is read back beside the ticks already there

- **WHEN** a store is opened at a place holding a history written in the form used before a
  commitment carried a kind, holding one tick for a commitment named "Gym" on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026; a tick for
  that same commitment on Wednesday 2 September 2026 is added to it; and a store is opened
  afterwards at the same place
- **THEN** the later store's history is the same as a history both those ticks were added to
- **AND** it answers that the commitment was kept on both dates

#### Scenario: a store written in a form this app has never written is refused

- **WHEN** a store is opened at a place holding a store whose form is one below the earliest form
  this app has ever written, holding no ticks
- **THEN** opening is refused with an error
- **AND** the error says the content is not a store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

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

#### Scenario: a store whose shape and declared form disagree about numbers is refused

- **WHEN** a store is opened at a place holding a store written in the form used before a day could
  hold a number, which nonetheless holds one number
- **THEN** opening is refused with an error
- **AND** a store at a place holding a store in the form this app writes, with no place for numbers
  in it at all, is refused the same way
- **AND** the error says the content is not a store rather than that it is from a later form
- **AND** the content at each place is byte-for-byte what it was before

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

### Requirement: A tick is of a commitment on a calendar date it is due on

A tick SHALL be exactly two things: a commitment and a calendar date. It SHALL carry nothing else —
no time of day, no time zone, no note, no count, no order among ticks. It is keyed to the date the
commitment was kept on and never to the moment it was entered.

The system SHALL refuse to form a tick for a commitment on a calendar date that commitment is not due
on, and MUST refuse rather than adjust: it MUST NOT move the tick to the nearest due date, and MUST
NOT record it anyway and mark it somehow. Whether the commitment is due is the `commitment`
capability's answer for that date; this capability adds nothing to it and takes nothing away, so a
date before the day the commitment is kept from takes no tick for the same reason a Tuesday takes
none on a Monday-Wednesday-Saturday rhythm, and a commitment whose schedule is due on no date takes
no tick on any.

The system SHALL likewise refuse to form a tick for a commitment whose kind is not a tick, on every
date, and MUST refuse rather than substitute: it MUST NOT record a tick for a number commitment as
though a number had been entered, and MUST NOT treat the tick as standing in for whatever that
commitment's day really takes. A tick is the record of the plain kind, and a commitment says which
kind its days take — a weight is a weight or it is nothing, and a day showing as kept because
someone tapped it would be a false record of the sort this product exists to remove. What a number
commitment's day takes is a number, which is its own requirement rather than this one, and the
refusal here does not soften because such a record now exists: a number commitment takes no tick on a
date it is due on whether or not it already has a number on that date. What a note commitment's day
takes is a note, which is its own requirement rather than this one, and the refusal here does not
soften for it either: a note commitment takes no tick on a date it is due on whether or not it
already has a note on that date. What a total commitment's day takes is an **addition**, which is
its own requirement rather than this one, and the refusal here does not soften because such a record
now exists either: a total commitment takes no tick on a date it is due on whether or not its day
already holds additions, and whether or not those additions have reached its target.

A history holds ticks, numbers, notes and additions, so a number commitment is answered from the
number it has on that day, a note commitment from the note it has on that day, and a total commitment
from whether its day's additions have reached its target. There is no longer a kind a history holds
no record of at all. That
follows from the refusal rather than adding to it, and it is stated here so that nobody reads the
refusal as leaving such a commitment in an undefined state: a commitment whose kind is not a tick is
not kept *by a tick*, and whether it is kept at all is the kind's own record's answer.

Whether the date lies in the past, is today, or is still to come MUST NOT enter into it. The system
MUST NOT consult the present moment, the device's time zone or the locale: a tick on a due date in
the first supported year is formed exactly as one in the last, and a screen that wants to withhold
days that have not arrived does so itself, with the day it asked the device for.

Two ticks alike in commitment and date SHALL be the same tick, and two ticks differing in either
SHALL be different ticks. This is what "at most one per commitment per day" means where it can be
observed, and it is the whole of a tick's identity. Two commitments differing only in their kind are
two commitments, but only one of them can be ticked at all, so this changes nothing about which
ticks are the same tick.

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

A history SHALL hold records, and SHALL answer whether a commitment was kept on a calendar date: kept
exactly when the history holds a record of that commitment on that date that keeps it, and not kept
otherwise. A tick keeps its day by being there, and so does a number: **every** number a commitment
accepts keeps its day, whatever the number is, because a range says which numbers a commitment will
take and never which of them count. **So does a note**, and by the same rule and for the same reason:
every note a commitment accepts keeps its day, whatever it says, because what a person wrote is not
something this system grades — a note saying "Missed it, too tired" keeps its day exactly as one
saying "Ran 8k" does, since the commitment was to write the day down and the day was written down.
A history that has taken no record SHALL answer *not kept* for every commitment on every date.

**A total is the one kind whose record does not keep its day by being there.** A total commitment
SHALL be kept on a date exactly when the additions its day holds sum to **its commitment's target or
more**, and SHALL be not kept where they sum to less. That is the whole of the difference: an
addition is a record like every other, and a target is what decides how many of them a day needs.
Additions **past** the target SHALL keep the day and SHALL change nothing else about it — a target is
what a day has to reach and never a ceiling on what may be added — and a day holding no addition sums
to zero, which is below every target there can be, a target being above zero. The comparison SHALL be
**the sum against the target**, in that order and never the target against the sum: the two do not
answer alike where a sum is not a number at all, and only the first of them answers *not kept*
there.

The answer SHALL depend on the commitment and the date and on nothing else. A record of one
commitment MUST NOT make another commitment kept on the same date, and a record on one date MUST NOT
make the same commitment kept on another date. Asking about a date the commitment is not due on
SHALL be answered — *not kept*, since no record can exist there — rather than refused: telling *not
due* apart from *due and missed* is the asker's job, with the `commitment` capability's answer
beside this one. A number commitment SHALL be answered from the number the history holds for it on
that date — kept where there is one, not kept where there is none — a note commitment from the note
it holds for it on that date, by the same rule, and a total commitment from its day's sum against
its target; a number, a note or a total commitment with nothing on a date it is due on is therefore
a day that was missed rather than a day nothing can be recorded on. A history is asked about the
commitment it was handed and never widens the question to the commitments alike to it in three parts
out of four.

Adding a **tick** the history already holds SHALL leave the history unchanged: a day holds at most
one tick per commitment, and a second tap is not a second record. A number and a note can each be
added *differently* for a day already holding one, and doing so replaces it rather than adding a
second — which is each of their own requirements. An **addition** is the one record a day holds more
than one of, and a second addition alike in every way to the first is a second record held beside it
rather than a repeat that changes nothing: that is its own requirement, and it is what makes the
total kind a kind rather than a number with a rule attached. Two histories holding the same records
SHALL be the same history, whatever order records of different commitments and different days were
added in, and additions on one day SHALL be held in the order they were made.

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
though that tick had never been added: the commitment is not kept on that date, and every other tick
— the same commitment on other dates, other commitments on the same date — stands exactly as it did.
The system MUST NOT keep anything of a tick that was taken back: an untick is not a record of its
own, and a history that was ticked and then unticked SHALL be the same history as one that was never
ticked.

Taking back a tick the history does not hold SHALL leave the history unchanged rather than being
refused: the outcome asked for — no such tick — already holds.

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

### Requirement: A store keeps a history at a place, across the app being closed and opened again

A store SHALL be opened at a place, and SHALL hold a history: every tick, every number, every note
and every addition added to it and not since taken back. Opening a store at a place where nothing
has been kept SHALL give an empty history rather than an error — that is what the first launch looks
like, and it is the only time a store opens empty.

A tick added to a store SHALL be kept at that place before the store reports it added, so that a
store opened at the same place afterwards — by the app opened again, or by anything else, and
whether or not the first store was ever closed — holds it. There is no separate step at which a
store is saved: the app can be stopped at any moment without warning, and a tick waiting to be saved
would be exactly the record the product promises not to lose. Taking a tick back SHALL be kept the
same way, and so SHALL a number added and a number taken back, a note added and a note taken back,
and an addition made and a day's last addition taken back: nothing about a number, a note or an
addition is held only in memory, and an addition the store reports as written is one already at its
place.

A store SHALL persist a tick as exactly what a tick is — its commitment, with the name, the
schedule, the kept-from day and the kind that commitment is made of, and its calendar date — and
nothing else. Every tick a store can hold is of a commitment of the plain kind, since no other kind
forms one, so keeping the kind changes what is written rather than what can be read back; it is kept
all the same, because a store persists what a commitment *is* and not the parts of it that happen to
vary. A tick read back SHALL be the same tick that was added, for every schedule shape, for any name
a commitment can have, and for any date the system supports. The store MUST NOT key a tick to the
moment it was entered, and MUST NOT pass a calendar date through an instant, a time zone or a locale
on the way in or out. A store holds at most one tick per commitment per day, as a history does, and
two stores at different places SHALL be independent of each other.

A store SHALL persist a number as exactly what a number is — its commitment, its calendar date and
the number itself — and nothing else. A number read back SHALL be **the same number that was added,
digit for digit**: what a person entered is what is kept and what the next store opened at that place
gives back, so a number MUST NOT be rounded, shortened, or passed on the way in or out through any
form that cannot hold every number a commitment accepts. A store holds at most one number per
commitment per day, as a history does, so a number added for a day the store already holds one for
replaces it and the store keeps the later of the two.

A store SHALL persist a note as exactly what a note is — its commitment, its calendar date and the
text itself — and nothing else. A note read back SHALL be **the same text that was added, character
for character**: every character, at every length, in every script, line breaks and blank space
included, and in the very form each character was given in rather than any other form of the same
writing. What a person wrote is what is kept and what the next store opened at that place gives
back, so a note MUST NOT be shortened, trimmed, re-spelled or otherwise tidied on the way in or out
— a sentence rewritten on the way to disk is a sentence the person did not write, which is the false
record this product exists to remove. A store holds at most one note per commitment per day, as a
history does, so a note added for a day the store already holds one for replaces it and the store
keeps the later of the two.

A store SHALL persist a day's additions as exactly what they are — their commitment, their calendar
date, and the amounts **in the order they were made** — and nothing else. Each amount read back SHALL
be **the same amount that was added, digit for digit**, so an amount MUST NOT be rounded, shortened,
or passed on the way in or out through any form that cannot hold every amount this system accepts;
and the order read back SHALL be the order they were made in, because the order is what names the
addition a take-back removes. A store holds **every** addition a day was given rather than one per
commitment per day: it is the one record a day holds many of, and a store keeping only the last of
them would lose every record but one and answer a different sum. A store MUST NOT persist the day's
**sum**, which is derived from the additions and is not a record.

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

#### Scenario: a day's additions are read back in the order they were made

- **WHEN** additions of 30, then 45, then 50 for a commitment named "Protein" of the total kind with
  a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 are added to a store, and a store is opened afterwards at the same place
- **THEN** the later store's history is the same as a history those three additions were added to in
  that same order
- **AND** it answers that the commitment has added 125 on that date
- **AND** taking that day's last addition back on the later store leaves it answering 75, so the
  addition of 50 was the one the order named

#### Scenario: a day's last addition taken back is not held by a store opened afterwards at the same place

- **WHEN** additions of 30 and then 90 for a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 are added to a store and the last of them is then taken back, and a store is
  opened afterwards at the same place
- **THEN** the later store's history answers that the commitment has added 30 on that date
- **AND** its history is the same as a history the addition of 30 alone was added to
- **AND** taking the last addition back once more and opening a store again leaves it the same as a
  history that has taken no record

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

### Requirement: A store that cannot be read is refused rather than emptied

Opening a store at a place that holds something this app cannot read as a store SHALL be refused
with an error. The store MUST NOT answer with an empty history in its place, MUST NOT overwrite,
move or delete what is there, and MUST NOT keep the part of it that could be read: the whole is
refused, so that whatever is at that place is still there, unchanged, for a person or a later
version of the app to recover. An honest error on opening is the failure the product can survive;
a record silently replaced by an empty one is the failure it exists to remove.

Three things this app cannot read as a store: content that is not a store at all; a store written
in a form later than the one this app knows, which a later version of the app may have left behind;
and a store holding something that could not be a **record** — a date that names no day, a commitment
on a date it is not due on, a number outside the range its commitment declares, a number against a
commitment whose kind is not a number, a note against a commitment whose kind is not a note, a note
whose text says nothing, an addition against a commitment whose kind is not a total, an addition of
an amount that is not above zero, or a day carrying no addition at all where the store never writes
one — because a record that could not be formed is not one this app wrote.
A fourth is named by *A store reads a history kept before a commitment carried a kind* above: a
store whose shape does not match the form it declares.

Every rule a record is formed by SHALL be applied again to what comes off the place, and this
capability SHALL add no rule there and drop none. A note is not read back more leniently than it was
written — a store holding a note of nothing but blank space is refused exactly as forming one is —
because a store that accepted what could never have been made would be a second, quieter definition
of what a record is.

**Each addition SHALL be re-formed on its own, and no rule SHALL be applied across a day.** A store
holding a day whose additions sum to more than this system can keep exactly SHALL be read rather than
refused, and that day SHALL answer whatever its additions come to. That is not the leniency the
paragraph above forbids: what a day's additions may sum to is not a rule this capability has — it is
decided where a person makes an addition, which is the `day-screen` capability's answer — so there is
no rule here to apply again, and inventing one on the way in would be that second, quieter definition
in the other direction. Such content is not something this app can write; refusing a whole record
over a day nobody using this product can have made would cost a person every record they have in
order to protect them from one they do not.

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

A number SHALL be exactly three things: a commitment, a calendar date, and one decimal number. It
SHALL carry nothing else — no unit, because the commitment's own name says kilograms; no time of
day, no time zone, no note beside it, and no order among numbers. It is keyed to the date the number
is for and never to the moment it was entered.

The system SHALL refuse to form a number for a commitment on a calendar date that commitment is not
due on, and MUST refuse rather than adjust, exactly as a tick is refused there. Whether the
commitment is due is the `commitment` capability's answer for that date; this capability adds nothing
to it and takes nothing away, so a date before the day the commitment is kept from takes no number
for the same reason a Tuesday takes none on a Monday-Wednesday-Saturday rhythm.

The system SHALL likewise refuse to form a number for a commitment whose kind is not a number, on
every date, and MUST refuse rather than substitute. A number is the record of the number kind, and a
commitment says which kind its days take: a tick commitment's day takes a tick, and a number recorded
against it would be a false record of the sort this product exists to remove. What a note commitment's
day takes is a note, which is its own requirement rather than this one, and the refusal here does not
soften because such a record now exists: a note commitment takes no number on a date it is due on
whether or not it already has a note on that date. What a total commitment's day takes is an
**addition**, which is its own requirement rather than this one, and the refusal here does not soften
for it either: a total commitment takes no number on a date it is due on whether or not its day
already holds additions.

Where the commitment declares a **range**, the system SHALL refuse a number below the lowest or above
the highest, and SHALL form one at either end and anywhere between them. A range is bounds and
nothing else: it does not say a number must be whole, it fixes no step, and it does not enumerate the
values it allows — so a mood of one to ten takes 5.5 exactly as it takes 5. Where the commitment
declares no range, every number is a number, a negative one and zero and a very large one alike,
because the only rule a number is judged against is the one its own commitment carries.

The system SHALL refuse a value that is not a number at all, whether or not the commitment declares
a range, and SHALL refuse it where the record is formed rather than leaving it to a range to catch.
A range would not catch it reliably — a value that is not a number compares as below every bound and
above none, so a commitment with no range would take one — and such a value is not merely a wrong
number: it cannot be written down in the form a store keeps, so one of them reaching a history would
cost every record in that store rather than its own. Refusing it at the one place a number is made is
what keeps that impossible.

Whether the date lies in the past, is today, or is still to come MUST NOT enter into it. The system
MUST NOT consult the present moment, the device's time zone or the locale: a number on a due date in
the first supported year is formed exactly as one in the last, and a screen that wants to withhold
days that have not arrived does so itself, with the day it asked the device for.

Two numbers alike in commitment, date and number SHALL be the same number, and two differing in any
of the three SHALL be different numbers. The number is part of what the record *is* rather than
something carried beside it, so a day holding 70.5 and a day holding 71 hold two different records —
which of them a history keeps when both are given to it is the next requirement's answer, and it is
not this one's.

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

A history SHALL hold numbers beside the ticks it holds, and SHALL answer what number a commitment has
on a calendar date: the number it holds for that commitment on that date, and *no number* where it
holds none. A history that has taken no number SHALL answer *no number* for every commitment on every
date. This is the first thing a history gives back rather than answers yes or no about, and it is
here because a record nothing can read back is not a record: a screen that has to show the weight a
person entered cannot get it from whether the day was kept.

The answer SHALL depend on the commitment and the date and on nothing else. A number of one
commitment MUST NOT be read as another commitment's on the same date, and a number on one date MUST
NOT be read as the same commitment's on another date. Asking about a commitment whose kind is not a
number SHALL be answered — *no number*, since none of one can be formed for a history to hold —
rather than refused, and asking about a date the commitment is not due on SHALL be answered the same
way and for the same reason. A history is asked about the commitment it was handed and never widens
the question to the commitments alike to it in three parts out of four.

A history SHALL hold at most one number per commitment per day. A number added for a commitment and
date the history already holds a number for SHALL **replace** it, and the history SHALL then be the
same history as one the later number alone was added to: nothing remembers the number that was there,
and a day keeps no history of its own. That is what "entered again it is replaced" means where it can
be observed.

A number the commitment refuses is never a number at all, so there is nothing to add and what the
history holds SHALL stand exactly as it did. A weight of 300 offered against a range of 40 to 150,
over a day already holding 70.5, leaves that day holding 70.5 — the refusal is not a replacement that
then fails, and it is the shape a refused tick already has.

Two histories holding the same ticks and the same numbers SHALL be the same history, whatever order
they arrived in.

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

A history SHALL let the number it holds for a commitment on a calendar date be taken back, and SHALL
take it back by **that commitment and that date** rather than by the number itself. A day holds at
most one number, so naming the day names the record; and a person who mistyped 300 has to be able to
clear it without reading it back first, which taking back by value would demand. This is deliberately
not the shape a tick is taken back in — a tick is handed back whole, because a tick is nothing but a
commitment and a date and there is no third part for a caller to know.

Taking back a number SHALL leave the history as though that number had never been added: the day
holds no number, the commitment is not kept on that date, and every other number — the same
commitment on other days, other commitments on the same day — stands exactly as it did, as does every
tick. The system MUST NOT keep anything of a number that was taken back: taking one back is not a
record of its own, and a history given a number and then taken back SHALL be the same history as one
that was never given one.

Taking back where the history holds no number for that commitment on that date SHALL leave the
history unchanged rather than being refused: the outcome asked for — no number there — already holds.
That covers a day nothing was ever entered on, a commitment whose kind is not a number, and a date
the commitment is not due on.

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

A note SHALL be exactly three things: a commitment, a calendar date, and one text. It SHALL carry
nothing else — no title, because the commitment's own name says what the note is about; no time of
day, no time zone, no number beside it, and no order among notes. It is keyed to the date the note
is for and never to the moment it was entered.

The system SHALL refuse to form a note for a commitment on a calendar date that commitment is not
due on, and MUST refuse rather than adjust, exactly as a tick and a number are refused there.
Whether the commitment is due is the `commitment` capability's answer for that date; this capability
adds nothing to it and takes nothing away, so a date before the day the commitment is kept from
takes no note for the same reason a Tuesday takes none on a Monday-Wednesday-Saturday rhythm.

The system SHALL likewise refuse to form a note for a commitment whose kind is not a note, on every
date, and MUST refuse rather than substitute. A note is the record of the note kind, and a
commitment says which kind its days take: a weight commitment's day takes a number, and a sentence
recorded against it would be a false record of the sort this product exists to remove. What a total
commitment's day takes is an **addition**, which is its own requirement rather than this one, and the
refusal here does not soften for it either: a total commitment takes no note on a date it is due on
whether or not its day already holds additions.

**A text that says nothing is not a note.** The system SHALL refuse a text that is empty, or made
only of blank space, and MUST refuse it rather than adjust it: it MUST NOT accept the text and keep
nothing, and MUST NOT substitute a placeholder of its own. A note of nothing but blank space says
nothing, so it is a record a person would read as an empty day while the day counted as kept — the
same refusal, for the same reason, that stops a name of nothing but blank space naming a commitment.
Blank space SHALL mean whitespace in the full sense, and SHALL be judged by the **same test this
system already judges a commitment name by**: a space, a tab, a line break and a no-break space are
each blank space, so a text of three line breaks is refused exactly as a text of three spaces is,
and a character that test does not call whitespace is not blank space here however little of it a
person can see. One test, asked in one way, is what stops the record and the screen disagreeing
about what an empty day is.

**Every other text SHALL be a note, and SHALL be kept exactly as it was given.** There is no upper
bound on a note's length, no restriction on the script it is written in, no character the system
reserves, and no text it rewrites: a note is the words its owner chose, judged as a commitment name
is judged and for the same reason. A note MAY hold a line break, and holding one changes nothing
about it — this capability knows nothing of a row or a field, and what a person can actually type is
decided where they type it. Blank space at the start or the end of a note is kept with it, because
tidying what a person typed belongs where they typed it and not in the rule that decides what a note
is.

Whether the date lies in the past, is today, or is still to come MUST NOT enter into it. The system
MUST NOT consult the present moment, the device's time zone or the locale: a note on a due date in
the first supported year is formed exactly as one in the last, and a screen that wants to withhold
days that have not arrived does so itself, with the day it asked the device for.

Two notes alike in commitment, date and text SHALL be the same note, and two differing in any of the
three SHALL be different notes. The text is part of what the record *is* rather than something
carried beside it, so a day holding "Ran 8k" and a day holding "Rested" hold two different records —
which of them a history keeps when both are given to it is the next requirement's answer, and it is
not this one's.

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

A history SHALL hold notes beside the ticks and the numbers it holds, and SHALL answer what note a
commitment has on a calendar date: the note it holds for that commitment on that date, and **no
note** where it holds none. A history that has taken no note SHALL answer *no note* for every
commitment on every date. It is the second thing a history gives back rather than answers yes or no
about, and it is here for the reason the number's reader is: a record nothing can read back is not a
record, and a person who has to see what they wrote on Tuesday cannot get it from whether the day
was kept.

The answer SHALL depend on the commitment and the date and on nothing else. A note of one commitment
MUST NOT be read as another commitment's on the same date, and a note on one date MUST NOT be read
as the same commitment's on another date. Asking about a commitment whose kind is not a note SHALL
be answered — *no note*, since none of one can be formed for a history to hold — rather than
refused, and asking about a date the commitment is not due on SHALL be answered the same way and for
the same reason. A history is asked about the commitment it was handed and never widens the question
to the commitments alike to it in three parts out of four.

A history SHALL hold at most one note per commitment per day. A note added for a commitment and date
the history already holds a note for SHALL **replace** it, and the history SHALL then be the same
history as one the later note alone was added to: nothing remembers the note that was there, and a
day keeps no history of its own. That is what "entered again it is replaced" means where it can be
observed.

A text the system refuses is never a note at all, so there is nothing to add and what the history
holds SHALL stand exactly as it did. A text of three spaces offered over a day already holding
"Ran 8k." leaves that day holding "Ran 8k." — the refusal is not a replacement that then fails, and
it is the shape a refused tick and a refused number already have.

Two histories holding the same ticks, the same numbers and the same notes SHALL be the same history,
whatever order they arrived in.

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

A history SHALL let the note it holds for a commitment on a calendar date be taken back, and SHALL
take it back by **that commitment and that date** rather than by the text itself. A day holds at
most one note, so naming the day names the record; and a person who wrote the wrong day's entry has
to be able to clear it without reading it back first, which taking back by text would demand. This
is the shape a number is already taken back in, and it is deliberately not the shape a tick is taken
back in — a tick is handed back whole, because a tick is nothing but a commitment and a date and
there is no third part for a caller to know.

Taking back a note SHALL leave the history as though that note had never been added: the day holds
no note, the commitment is not kept on that date, and every other note — the same commitment on
other days, other commitments on the same day — stands exactly as it did, as does every tick and
every number. The system MUST NOT keep anything of a note that was taken back: taking one back is
not a record of its own, and a history given a note and then taken back SHALL be the same history as
one that was never given one.

Taking back where the history holds no note for that commitment on that date SHALL leave the history
unchanged rather than being refused: the outcome asked for — no note there — already holds. That
covers a day nothing was ever written on, a commitment whose kind is not a note, and a date the
commitment is not due on.

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

An addition SHALL be exactly three things: a commitment, a calendar date, and one decimal number.
It SHALL carry nothing else — no unit, because the commitment's own name says grams; no time of
day, no time zone, no note beside it, and no position of its own among the additions of its day.
It is keyed to the date the addition is for and never to the moment it was entered.

The system SHALL refuse to form an addition for a commitment on a calendar date that commitment is
not due on, and MUST refuse rather than adjust, exactly as a tick, a number and a note are refused
there. Whether the commitment is due is the `commitment` capability's answer for that date; this
capability adds nothing to it and takes nothing away, so a date before the day the commitment is
kept from takes no addition for the same reason a Tuesday takes none on a
Monday-Wednesday-Saturday rhythm.

The system SHALL likewise refuse to form an addition for a commitment whose kind is not a total, on
every date, and MUST refuse rather than substitute. An addition is the record of the total kind,
and a commitment says which kind its days take: a weight commitment's day takes one number that
replaces the last, and treating a weight as something to accumulate would be a false record of the
sort this product exists to remove.

**An amount that is not above zero is not an addition.** The system SHALL refuse zero, SHALL refuse
every amount below zero, and MUST refuse rather than adjust: it MUST NOT accept the amount and add
nothing, and MUST NOT substitute an amount of its own. Zero adds nothing to a day and is a record
of a thing not done wearing the clothes of a thing done. An amount below zero would be a **second
way back**, competing with the take-back this capability already has and reaching further than it —
one that could take a day below where it started, and that no take-back could undo without another
addition. The refusal is made where the record is formed, so that every caller gets it, exactly as
a number outside its commitment's range is refused there.

The system SHALL likewise refuse a value that is not a number at all, and SHALL refuse it where the
record is formed rather than leaving it to the comparison with zero to catch. A value that is not a
number compares as neither above zero nor below it, so the comparison would let one through; and
such a value cannot be written down in the form a store keeps, so one of them reaching a history
would cost every record in that store rather than its own.

**Every other amount SHALL be an addition, and SHALL be kept exactly as it was given**, however
small and however large, with no digit added and none dropped. This capability declares no ceiling
of its own: a day may be added to as many times as a person adds to it, and what a day's additions
may sum to is decided where a person makes one — the `day-screen` capability's answer, for the same
reason the digits a typed number may hold are decided there. A commitment's **target** is not a
ceiling either: additions past the target are additions like any other, and what a target does is
the next requirement but one's.

Whether the date lies in the past, is today, or is still to come MUST NOT enter into it. The system
MUST NOT consult the present moment, the device's time zone or the locale: an addition on a due
date in the first supported year is formed exactly as one in the last, and a screen that wants to
withhold days that have not arrived does so itself, with the day it asked the device for.

Two additions alike in commitment, date and amount SHALL be the same addition, and two differing in
any of the three SHALL be different additions. The amount is part of what the record *is* rather
than something carried beside it. That two additions of 30 on one day are the same *addition* does
**not** make a day given both hold one: a day holds many, and what a history does with two alike is
the next requirement's answer and not this one's.

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

A history SHALL hold additions beside the ticks, the numbers and the notes it holds, and SHALL
answer what a commitment has **added** on a calendar date: the sum of the additions it holds for
that commitment on that date. It is the first record a day holds **more than one of** — a tick, a
number and a note are each at most one per commitment per day, and additions accumulate, which is
the whole of what makes the total kind a different kind rather than a number with a rule attached.

A day SHALL hold every addition made on it, **in the order they were made**, and a second addition
alike in every way to one already there SHALL be held beside it rather than replacing it: adding 30
and then 30 again leaves a day of 60. That is where a total parts from a number and a note, whose
second record replaces the first, and it is why order is part of what a history holds rather than an
incidental of how it holds it — the take-back removes the *last* addition, so the order is what
names the record that goes.

**The sum SHALL be zero where the day holds no addition, and never *nothing*.** A history that has
taken no addition SHALL answer zero for every commitment on every date, and so SHALL a history
asked about a commitment whose kind is not a total, or about a date the commitment is not due on.
That is deliberately not the shape the number's and the note's readers have, which answer *nothing*
where the day holds none: the sum of no additions really is zero whatever the commitment, so zero is
a true answer rather than a stand-in for one, and it keeps a question with a true answer from being
asked with an optional. It is also what makes a day's take-back readable from the sum alone — every
addition is above zero, so a sum above zero means the day holds at least one and a sum of zero means
it holds none.

**A history SHALL give out the sum and SHALL NOT give out the additions themselves.** Nothing needs
the list: the sum answers what the day has, the target answers whether that is enough, and the
take-back is named by the commitment and the date rather than by the addition it removes. Giving out
the list would widen this capability's surface for a caller that does not exist, and the smallest
answer that serves every caller is the one this capability gives.

The answer SHALL depend on the commitment and the date and on nothing else. An addition of one
commitment MUST NOT be counted in another commitment's sum on the same date, and an addition on one
date MUST NOT be counted in the same commitment's sum on another date. A history is asked about the
commitment it was handed and never widens the question to the commitments alike to it in three parts
out of four.

An amount the system refuses is never an addition at all, so there is nothing to add and what the
history holds SHALL stand exactly as it did. An amount of zero offered against a day already holding
60 leaves that day holding 60 — the refusal is not an addition that then fails, and it is the shape
a refused tick, a refused number and a refused note already have.

Two histories holding the same ticks, the same numbers, the same notes and the same additions
**in the same order on every day** SHALL be the same history. Order matters here where it does not
for the other three: two days holding the same additions in different orders answer the same sum and
the same *kept*, but they do not answer the same take-back, so calling them the same history would
make a history that behaves differently equal to one it behaves differently from.

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

A history SHALL let the **last** addition it holds for a commitment on a calendar date be taken
back, named by **that commitment and that date** rather than by the amount itself. That is the shape
every record in this system is taken back in — a person who added the wrong amount has to be able to
undo it without reading it back first — and what differs is *what goes*: one addition rather than
the day. A day holding 30 and then 90 taken back once holds 30, and its sum is 30.

**Only the last SHALL go, and there SHALL be no way to take back any other.** An addition made
earlier in the day is reached by taking back the ones after it, one at a time, in the order that
undoes them. The system MUST NOT offer taking back an addition by naming its amount — two additions
of 30 on one day are the same addition, so an amount names no one of them — and MUST NOT offer
clearing a day's additions in one act. One act erasing six records is a bigger undo than any other
kind of record has, nothing has asked for it, and repeated take-back reaches every outcome it
would.

Taking back the last addition SHALL leave the history as though that addition had never been made:
the day holds the additions before it, in the order they were made; its sum is short by exactly the
amount that went; and every other addition — the same commitment on other days, other commitments on
the same day — stands exactly as it did, as does every tick, every number and every note. The system
MUST NOT keep anything of an addition that was taken back: taking one back is not a record of its
own, and a history given an addition and then taken back SHALL be the same history as one that was
never given it.

Taking back where the history holds no addition for that commitment on that date SHALL leave the
history unchanged rather than being refused: the outcome asked for — one fewer addition, and there
were none — already holds as nearly as it can. That covers a day nothing was ever added to, a
commitment whose kind is not a total, and a date the commitment is not due on.

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
