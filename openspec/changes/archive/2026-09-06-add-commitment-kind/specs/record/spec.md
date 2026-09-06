## ADDED Requirements

### Requirement: A store reads a history kept before a commitment carried a kind

A store SHALL read a history kept in the form written before a commitment carried a kind, rather
than refusing it, and SHALL read the commitment of every tick in it as being of the plain kind. That
form holds no kind for any commitment, and a tick is of a commitment whose kind is a tick, so the
plain kind is not a guess about those ticks but the only kind any of them could have had. Refusing
them would tell a person who has been keeping this record since before this change that they have
kept nothing.

Reading a history kept in an earlier form MUST NOT change what is at the place. A store writes on a
change being kept and at no other moment, so opening the app and doing nothing SHALL leave the
content byte-for-byte what it was, in the form it was already in. The next change kept there SHALL
be written in the form this app writes, whole, and every tick the earlier form held SHALL still be
in it.

The forms a store reads SHALL be exactly the ones this app has written: the form it writes now and
the form written before a commitment carried a kind. It SHALL NOT weaken the refusal of a form
*later* than the one it writes, which is a form it cannot know the shape of, and it SHALL refuse a
form number it has never written at all — one below the earliest — as content that is not a store,
because a number no version of this app ever wrote says nothing about the shape of what follows it.

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

## MODIFIED Requirements

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
someone tapped it would be a false record of the sort this product exists to remove. What a number,
a note or a total commitment's day does take is not this requirement's; until there is such a
record, those commitments simply have no record here.

A history holds ticks and nothing else, so a commitment whose kind is not a tick is answered *not
kept* on every date, there being no tick of one it could hold. That follows from the refusal rather
than adding to it, and it is stated here so that nobody reads the refusal as leaving such a
commitment in an undefined state.

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

### Requirement: A history answers whether a commitment was kept on a day from the ticks it holds

A history SHALL hold ticks, and SHALL answer whether a commitment was kept on a calendar date: kept
exactly when the history holds a tick of that commitment on that date, and not kept otherwise. A
history that has taken no tick SHALL answer *not kept* for every commitment on every date.

The answer SHALL depend on the commitment and the date and on nothing else. A tick of one commitment
MUST NOT make another commitment kept on the same date, and a tick on one date MUST NOT make the
same commitment kept on another date. Asking about a date the commitment is not due on SHALL be
answered — *not kept*, since no tick can exist there — rather than refused: telling *not due* apart
from *due and missed* is the asker's job, with the `commitment` capability's answer beside this one.
Asking about a commitment whose kind is not a tick SHALL be answered the same way and for the same
reason: no tick of such a commitment can be formed, so a history holds none of it and answers *not
kept* on a date it is due on exactly as on one it is not. A history is asked about the commitment it
was handed and never widens the question to the commitments alike to it in three parts out of four.

Adding a tick the history already holds SHALL leave the history unchanged: there is at most one tick
per commitment per day, and a second tap is not a second record. Two histories holding the same
ticks SHALL be the same history, whatever order the ticks were added in.

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

### Requirement: A store keeps a history at a place, across the app being closed and opened again

A store SHALL be opened at a place, and SHALL hold a history: every tick added to it and not since
taken back. Opening a store at a place where nothing has been kept SHALL give an empty history
rather than an error — that is what the first launch looks like, and it is the only time a store
opens empty.

A tick added to a store SHALL be kept at that place before the store reports it added, so that a
store opened at the same place afterwards — by the app opened again, or by anything else, and
whether or not the first store was ever closed — holds it. There is no separate step at which a
store is saved: the app can be stopped at any moment without warning, and a tick waiting to be saved
would be exactly the record the product promises not to lose. Taking a tick back SHALL be kept the
same way. A store that cannot keep a change MUST refuse it and MUST NOT hold it: the history a store
reports is never ahead of what is kept at its place.

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
