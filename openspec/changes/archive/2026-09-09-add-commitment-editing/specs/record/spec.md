## ADDED Requirements

### Requirement: A history carries every record of one commitment over to another

A history SHALL **carry over** every record it holds of one commitment to another, on being given the
two. Every tick, every number, every note and every addition of the first SHALL afterwards be a record
of the second, on the same calendar date each was made for; the first SHALL afterwards hold none; and
the history SHALL report that it carried them. A number SHALL be carried over digit for digit, a note
character for character, and a day's additions in the order they were made — carrying over moves what
a record is *of* and changes nothing a record *holds*.

This exists because a commitment has no identity of its own and a record embeds the whole commitment
by value, so the only way a person's history can survive their renaming a commitment, or correcting
the day they have been keeping it from, is for every record of the old value to become a record of
the new one. ADR-1023, amended for `add-commitment-editing` (#148).

**It SHALL carry all of them or none of them.** Where any record the history holds of the first
commitment could not be a record of the second — a date the second commitment is not due on, or a
kind whose record the second does not take — the history SHALL refuse, SHALL report that it carried
nothing, and SHALL be left exactly as it was, with every record still a record of the first. The
formation rules are not softened for a carry-over and nothing is dropped to make one succeed: a
record that could not have been made is not a record this system will write, and a history that
silently lost the ones that did not fit would be the false record this product exists to remove.

A history that holds **no** record of the first commitment SHALL carry nothing and SHALL NOT refuse:
there is nothing to move and nothing has gone wrong. A history asked to carry a commitment's records
over **to that same commitment** SHALL likewise change nothing and SHALL NOT refuse.

A history SHALL refuse, and be left exactly as it was, where it already holds **any** record of the
second commitment, on any date. Carrying over is not merging: two records for one day would have to
become one, and which of them survived would be a choice about a person's history that nothing here
is entitled to make.

A history SHALL NOT consult the present moment, the device's clock, its time zone or its locale here
either, and SHALL judge no date except by asking the second commitment whether it is due on it.

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

A store SHALL carry every record it holds of one commitment over to another, and SHALL keep that at
its place **before** it reports it carried, so that a store opened at the same place afterwards — by
the app opened again, or by anything else — holds those records under the second commitment and none
under the first. There is no separate step at which the carry-over is saved, for the reason there is
none for a tick.

A store SHALL report exactly what its history reports and MUST NOT turn the history's refusal into an
error. A carry-over the history refused SHALL keep nothing at the place and leave the store's history
exactly as it was, and so SHALL one the history had nothing to carry for: a store keeps what a change
made, and a change that made none has nothing to keep.

A store that **could not write** SHALL refuse, SHALL leave its history exactly as it was, and SHALL
say so as it already does for every other change it could not keep — the history a store reports is
never ahead of what is kept at its place, and this change is the largest one it makes, so a
half-written place is the one outcome that must not be reachable.

The **form on disk does not move** for a carry-over. It writes different commitment values into
records the store already keeps in exactly that shape, and adds no key, no field and no version to
what a record is.

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

## MODIFIED Requirements

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
place. **Carrying every record of one commitment over to another SHALL be kept the same way too**,
and it is the one change that touches every record a place holds at once: the store's own requirement
for it is *A store carries every record of one commitment over to another, at its place*, and what a
store holds after one is every record it held before, each of the one commitment now a record of the
other.

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
