# record Specification

## Purpose

Describes what a tick is to DayByDay — a commitment on a calendar date it was due on, and nothing
more — and how a history of ticks answers whether a commitment was kept on a day. It is the record
the product exists to keep: every screen that shows a day as done or not done reads it, and the store
that makes it survive the app being closed persists exactly this shape and nothing it invented.

## Requirements

### Requirement: A store reads a history kept before a commitment carried a kind

A store SHALL read a history kept in **any form this app has written**, rather than refusing it. Two
of those forms are earlier than the one it writes now, and each has a meaning of its own.

A history kept in the form written **before a commitment carried a kind** SHALL be read with the
commitment of every tick in it as being of the plain kind. That form holds no kind for any
commitment, and a tick is of a commitment whose kind is a tick, so the plain kind is not a guess about
those ticks but the only kind any of them could have had. Refusing them would tell a person who has
been keeping this record since before this change that they have kept nothing.

A history kept in the form written **before a day could hold a number** SHALL be read with every tick
in it as it stands and with no number on any day. That form has nowhere to keep a number, and a
person upgrading to a build that can hold one has not thereby entered any.

Reading a history kept in an earlier form MUST NOT change what is at the place. A store writes on a
change being kept and at no other moment, so opening the app and doing nothing SHALL leave the
content byte-for-byte what it was, in the form it was already in. The next change kept there SHALL
be written in the form this app writes, whole, and every tick and every number the earlier form held
SHALL still be in it.

The forms a store reads SHALL be exactly the ones this app has written — the form it writes now and
every form before it — and no others. It SHALL NOT weaken the refusal of a form *later* than the one
it writes, which is a form it cannot know the shape of, and it SHALL refuse a form number it has
never written at all — one below the earliest — as content that is not a store, because a number no
version of this app ever wrote says nothing about the shape of what follows it.

A store SHALL read each form **as the shape that form has**, rather than reading every form leniently
and inferring which one it is. A store declares the form it was written in before anything else is
read, so what may be in it is known: a store in a form written before a day could hold a number,
which nonetheless holds one, and a store in the form written now, which has no place for numbers in
it at all, are each refused as content this app never wrote. Reading them leniently would make the
declared form decorative, and with a third form it is what would let the shapes blur into one nobody
can state.

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
date it is due on whether or not it already has a number on that date. What a note or a total
commitment's day takes has no record here yet, so those commitments simply have none.

A history holds ticks and numbers, so a commitment of the note or the total kind is answered *not
kept* on every date, there being no record of one it could hold, while a number commitment is
answered from the number it has on that day. That follows from the refusal rather than adding to it,
and it is stated here so that nobody reads the refusal as leaving such a commitment in an undefined
state: a commitment whose kind is not a tick is not kept *by a tick*, and whether it is kept at all
is the kind's own record's answer.

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

### Requirement: A history answers whether a commitment was kept on a day from the ticks it holds

A history SHALL hold records, and SHALL answer whether a commitment was kept on a calendar date: kept
exactly when the history holds a record of that commitment on that date that keeps it, and not kept
otherwise. A tick keeps its day by being there, and so does a number: **every** number a commitment
accepts keeps its day, whatever the number is, because a range says which numbers a commitment will
take and never which of them count. A history that has taken no record SHALL answer *not kept* for
every commitment on every date.

The answer SHALL depend on the commitment and the date and on nothing else. A record of one commitment
MUST NOT make another commitment kept on the same date, and a record on one date MUST NOT make the
same commitment kept on another date. Asking about a date the commitment is not due on SHALL be
answered — *not kept*, since no record can exist there — rather than refused: telling *not due* apart
from *due and missed* is the asker's job, with the `commitment` capability's answer beside this one.
Asking about a commitment of the note or the total kind SHALL be answered the same way and for the
same reason: no record of one can be formed, so a history holds none of it and answers *not kept* on
a date it is due on exactly as on one it is not. A number commitment SHALL be answered from the
number the history holds for it on that date — kept where there is one, not kept where there is
none — and a number commitment with no number on a date it is due on is therefore a day that was
missed rather than a day nothing can be recorded on. A history is asked about the commitment it was
handed and never widens the question to the commitments alike to it in three parts out of four.

Adding a record the history already holds SHALL leave the history unchanged: there is at most one
record per commitment per day, and a second tap is not a second record. A number is the one record
that can be added *differently* for a day already holding one, and doing so replaces it rather than
adding a second — which is the number's own requirement, and leaves "at most one record per
commitment per day" exactly as it stands. Two histories holding the same records SHALL be the same
history, whatever order the records were added in.

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

A store SHALL be opened at a place, and SHALL hold a history: every tick and every number added to it
and not since taken back. Opening a store at a place where nothing has been kept SHALL give an empty
history rather than an error — that is what the first launch looks like, and it is the only time a
store opens empty.

A tick added to a store SHALL be kept at that place before the store reports it added, so that a
store opened at the same place afterwards — by the app opened again, or by anything else, and
whether or not the first store was ever closed — holds it. There is no separate step at which a
store is saved: the app can be stopped at any moment without warning, and a tick waiting to be saved
would be exactly the record the product promises not to lose. Taking a tick back SHALL be kept the
same way, and so SHALL a number added and a number taken back: nothing about a number is held only
in memory, and a number the store reports as entered is one already at its place.

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
on a date it is not due on, a number outside the range its commitment declares, or a number against a
commitment whose kind is not a number — because a record that could not be formed is not one this app
wrote. A fourth is named by *A store reads a history kept before a commitment carried a kind* above:
a store whose shape does not match the form it declares.

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
against it would be a false record of the sort this product exists to remove. What a note or a total
commitment's day takes is not this requirement's, and until there is such a record those commitments
have no record here at all.

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
