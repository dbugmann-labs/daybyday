## ADDED Requirements

### Requirement: A store keeps a record on a day a shift put a due day on, and reads it back

A store SHALL keep a record of any kind on a day a shift of its commitment put a due day on, and
SHALL read it back, once the app is closed and opened again, as that record of that commitment on
that day, whatever shifts the commitment has made since. It SHALL keep beside such a record the day
that shift took its due day from, a part first written at the seventh form, and no other shift, as
*A store persists each kind of record as exactly what it is* says, and SHALL read a history kept in
a form before it as holding none beside any record.

#### Scenario: records on a day a shift put a due day on are read back after the app is closed and opened again

- **WHEN** a roster holds a commitment named "Gym" of the tick kind and one named "Protein" of the
  total kind with a target of 120, both on a schedule listing Monday, Wednesday and Saturday and kept
  from 1 January 2026, each with its due day on Monday 31 August 2026 shifted to Tuesday 1 September
  2026; a tick for "Gym" and an addition of 35 for "Protein" on Tuesday 1 September 2026, each
  formed against the commitment that roster keeps, are kept at a record place; "Gym"'s due day on
  Wednesday 2 September 2026 is then shifted to Thursday 3 September 2026; and a store is opened
  afterwards at that record place
- **THEN** opening is not refused
- **AND** its history keeps "Gym" on Tuesday 1 September 2026, and has added 35 for "Protein" on that
  day
- **AND** the content at that record place holds Wednesday 2 September 2026, the later shift's day,
  nowhere

## MODIFIED Requirements

### Requirement: A store that cannot be read is refused rather than emptied

Opening a store at a place holding something this app cannot read as a store SHALL be refused with
an error. The store MUST NOT answer with an empty history, overwrite, move or delete what is there,
or keep the part of it that could be read: the whole SHALL be refused and what is at that place left
unchanged. What this app cannot read as a store SHALL include content that is not a store at all, a
store written in a form later than the one this app knows, and a store holding something that could
not be a record: a date that names no day, a commitment on a date it is not due on — its schedule and the shift kept beside the record deciding
which —, a record against a commitment of another kind, a number outside the range its commitment
declares, a note whose text says nothing, an addition of an amount that is not above zero, a day
carrying no addition at all, or a shift kept beside a record that took its due day from that
record's own date or from a day outside that date's Monday-to-Sunday week.

Every rule a record is formed by SHALL be applied again to what comes off the place, and of a shift
kept beside a record exactly the two its last case names; this capability SHALL add no other rule
there and drop none: a note SHALL NOT be read back more leniently than
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

#### Scenario: a store holding a tick against a commitment of another kind, or a note of other blank space, is refused

- **WHEN** a store is opened at a place holding a store in the form this app writes, whose one tick
  is of a commitment named "Weight" of the number kind with no range, on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026 — a record against a
  commitment of another kind
- **THEN** opening is refused with an error
- **AND** a store at a place holding one note of three line breaks, for a commitment named "Journal"
  of the note kind on that same schedule and kept from that same day, on that same date, is refused
  the same way
- **AND** so is one holding a note of a tab followed by a line break, and one holding a note of one
  no-break space
- **AND** the content at each place is byte-for-byte what it was before

#### Scenario: a store holding a day whose later addition is not above zero is refused

- **WHEN** a store is opened at a place holding a store in the form this app writes, whose one day
  holds an addition of 30 and then an addition of 0, for a commitment named "Protein" of the total
  kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, on Monday 31 August 2026
- **THEN** opening is refused with an error
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a store holding a record beside a shift that could not be one is refused

- **WHEN** a store is opened at a place holding a store in the form this app writes, whose one tick
  is of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, on Tuesday 1 September 2026, kept beside a shift from Monday 24 August 2026 — a
  day of the week before
- **THEN** opening is refused with an error
- **AND** a store at a place holding that tick kept beside a shift from Tuesday 1 September 2026
  itself is refused the same way
- **AND** the content at each place is byte-for-byte what it was before
- **AND** a store at a place holding that tick kept beside a shift from Monday 31 August 2026 opens
  without error, and answers that "Gym" was kept on Tuesday 1 September 2026

### Requirement: A store reads every form it has written

A store SHALL read a history kept in any form this app has written, the current form and every form
before it. It SHALL refuse a form later than the one it writes, and SHALL refuse a form number this
app has never written, one below the earliest, with an error saying the content is not a store
rather than that it is from a later form. A store SHALL read each form as the shape that form has,
and SHALL refuse one whose shape and declared form disagree. Which shape belongs to which form SHALL
be judged against the form each part was first written at, never the newest: numbers arrived at the
third form, notes the fourth, additions the fifth, a record's identity the sixth, and a shift kept beside a record
the seventh. Opening a store MUST NOT change what is at its
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

#### Scenario: a change that leaves a store's history as it was writes nothing at its place

- **WHEN** a tick for a commitment named "Gym" of the tick kind, a number of 70.5 for a commitment
  named "Weight" of the number kind with no range and a note holding "Ran 8k." for a commitment named
  "Journal" of the note kind, all three on a schedule listing Monday, Wednesday and Saturday and all
  kept from 1 January 2026, on Monday 31 August 2026, are added to a store; what is at that place is
  then made impossible to write; and that same tick is added to the store again
- **THEN** adding it is not refused
- **AND** adding that same number again, and that same note again, is not refused either
- **AND** taking back a tick for "Gym" on Wednesday 2 September 2026, the number of "Weight" and the
  note of "Journal" on that date, and the last addition of a commitment named "Protein" of the total
  kind with a target of 120 on Monday 31 August 2026 — none of which the store holds — is not refused
  either
- **AND** the store's history is the same as it was before what is at that place was made impossible
  to write
#### Scenario: a store whose shape and declared form disagree about identities is refused

- **WHEN** a store is opened at a place holding a store written in the form used before a record
  carried an identity, which nonetheless says an identity for one record
- **THEN** opening is refused with an error
- **AND** a store at a place holding a store in the form this app writes, saying no identity for one
  record, is refused the same way
- **AND** the error says the content is not a store rather than that it is from a later form
- **AND** the content at each place is byte-for-byte what it was before

#### Scenario: a store whose shape and declared form disagree about shifts is refused

- **WHEN** a store is opened at a place holding a store written in the form used before a shift was
  kept beside a record, whose one tick, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, on Tuesday 1 September 2026, nonetheless has a
  shift from Monday 31 August 2026 kept beside it
- **THEN** opening is refused with an error
- **AND** the error says the content is not a store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

### Requirement: A store persists each kind of record as exactly what it is

A store SHALL persist each record as exactly what it is and nothing else: its commitment whole but
for the shifts it carries, identity and kind included, its calendar date, the number, text or
amounts it carries, in the order they were made, and, beside a record on a day a shift put a due day
on, the day that shift took it from and no other shift. An identity SHALL be kept exactly as given
and MUST NOT be reissued on a write, and what a record is of SHALL be that identity and that date
and nothing else, never the shift kept beside it, so a record
read back is a record of the same commitment rather than of one alike to it. A record read back SHALL be the same record that was added: every schedule shape, any name,
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

#### Scenario: a store keeps a day's additions at its place and never their sum

- **WHEN** additions of 31 and then 89.5 for a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 are added to a store
- **THEN** the content at that place holds 120.5, the day's sum, nowhere
- **AND** a store opened afterwards at the same place answers that the commitment has added 120.5 on
  that date
#### Scenario: a record is read back as a record of the same commitment rather than one alike to it

- **WHEN** a tick for a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, on Monday 31 August 2026 is added to a store, and a store is opened afterwards at
  the same place
- **THEN** the later store's history answers that that commitment was kept on Monday 31 August 2026
- **AND** it answers that a commitment formed on its own, alike in name, schedule, day kept from and
  kind, was not kept on it

#### Scenario: a record of an era is read back under the commitment whose era it is

- **WHEN** a tick for a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, on Monday 3 August 2026 is added to a store; a tick for a further era of that same
  commitment, on a schedule listing Tuesday and Thursday, kept from Monday 31 August 2026, on
  Tuesday 1 September 2026 is added to it; and a store is opened afterwards at the same place
- **THEN** the later store's history answers that the commitment was kept on Monday 3 August 2026
  and on Tuesday 1 September 2026, asked with either era
- **AND** its history is the same as a history those two ticks were added to
