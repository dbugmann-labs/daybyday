## MODIFIED Requirements

### Requirement: A store persists each kind of record as exactly what it is

A store SHALL persist each record as exactly what it is and nothing else: its commitment whole,
identity and kind included, its calendar date, and the number, text or amounts it carries, in the
order they were made. An identity SHALL be kept exactly as given and MUST NOT be reissued on a
write, and what a record is of SHALL be that identity and that date and nothing else, so a record
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

### Requirement: A store reads every form it has written

A store SHALL read a history kept in any form this app has written, the current form and every form
before it. It SHALL refuse a form later than the one it writes, and SHALL refuse a form number this
app has never written, one below the earliest, with an error saying the content is not a store
rather than that it is from a later form. A store SHALL read each form as the shape that form has,
and SHALL refuse one whose shape and declared form disagree. Which shape belongs to which form SHALL
be judged against the form each part was first written at, never the newest: numbers arrived at the
third form, notes the fourth, additions the fifth, and a record's identity the sixth. Opening a store MUST NOT change what is at its
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

### Requirement: Each earlier form is read as the record it always was

A history kept in the form written before a commitment carried a kind SHALL be read with every
tick's commitment of the plain kind. A history kept in the form written before a day could hold a
number SHALL be read with every tick as it stands and no number on any day; one kept before a day
could hold a note, with every tick and number as they stand and no note on any day; and one kept
before a day could hold an addition, with every tick, number and note as they stand and no addition
on any day; such a history SHALL answer a total of zero on every day and every total commitment not
kept. A history kept in the form written before a record carried an identity SHALL be read with every
record carrying none, and each SHALL be given one as *Reading the places carries the records of a
folded roster onto the commitments the fold made* says; a record left carrying none SHALL answer
about no commitment at all. The next change kept there SHALL be written whole in the form this app
writes, and every tick, number and note the earlier form held SHALL still be in it.

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
#### Scenario: a history kept before a record carried an identity is read with every record carrying none

- **WHEN** a store is opened at a place holding a history written in the form used before a record
  carried an identity, holding one tick for a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026
- **THEN** it opens without error
- **AND** its history answers that a commitment formed on its own, alike in every part, was not kept
  on Monday 31 August 2026
- **AND** the content at that place is byte-for-byte what it was before

### Requirement: A store carries every record of one commitment over to another, at its place

A store SHALL carry every record of one commitment over to another, and SHALL keep that at its place
before it reports it carried, so a store opened at that place afterwards SHALL hold them under the
second commitment and none under the first.

A store SHALL report exactly what its history reports, and MUST NOT turn the history's refusal into
an error. A carry-over the history refused SHALL keep nothing at the place, and so SHALL one the
history had nothing to carry for. A store that could not write SHALL refuse, SHALL leave its history
exactly as it was, and SHALL say so as for every other change it could not keep. The form on disk SHALL NOT move for a carry-over: it writes a different identity, and the commitment
that carries it, into records already kept in that shape, and adds no key, no field and no version
to what a record is.

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
- **THEN** the store refuses nothing, without an error
- **AND** the content at that place is byte-for-byte what it was before the store was asked

#### Scenario: a store that could not write a carry-over leaves its history exactly as it was

- **WHEN** a tick for a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, on Monday 3 August 2026 is added to a store; what is at that place is then made
  impossible to write; and the store is asked to carry "Gym"'s records over to a commitment named
  "Gym 🏋️" alike in every other way
- **THEN** the store says the change could not be kept
- **AND** its history answers that "Gym" was kept on Monday 3 August 2026 and that "Gym 🏋️" was not

#### Scenario: a number, a note and a day's additions carried over through a store are read back under the other commitment by a store opened afterwards

- **WHEN** a number of 72.45 for a commitment named "Weight" of the number kind with no range, a note
  holding "Ran 8k." for one named "Journal" of the note kind, and additions of 30 and then 12.5 for
  one named "Protein" of the total kind with a target of 120 — all three on a schedule listing all
  seven weekdays, kept from 1 January 2026, all on Monday 3 August 2026 — are added to a store; that
  store carries each over to a commitment alike in every way but named "Bodyweight", "Journalling"
  and "Protein grams"; and a store is opened afterwards at the same place
- **THEN** the later store's history is the same as a history that number, that note and those two
  additions in that order were added to, under "Bodyweight", "Journalling" and "Protein grams"
- **AND** it answers that "Weight" has no number, that "Journal" has no note and that "Protein" has
  added zero on that date

#### Scenario: a carry-over through a store leaves at its place what a store given those records under the other commitment holds

- **WHEN** a tick for a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, on Monday 3 August 2026 is added to a store at one place, and that store carries
  "Gym"'s records over to a commitment named "Gym 🏋️" alike in every other way; and a tick for
  "Gym 🏋️" on that same date is added to a store at a second place
- **THEN** the content at the first place is byte-for-byte the content at the second
