## MODIFIED Requirements

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

#### Scenario: taking back a note leaves another commitment's number on the same day standing

- **WHEN** a note holding "Ran 8k." for a commitment named "Journal" of the note kind and a number of
  70.5 for a commitment named "Weight" of the number kind with no range, both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026, are added to a history on Monday
  31 August 2026, and "Journal"'s note on that date is taken back
- **THEN** the history answers that "Weight" has 70.5 on Monday 31 August 2026, and that it was kept
  on it
- **AND** that "Journal" has no note on it

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

#### Scenario: taking back the last addition leaves every other kind of record on the same day standing

- **WHEN** a tick for a commitment named "Gym" of the tick kind, a number of 70.5 for a commitment
  named "Weight" of the number kind with no range, a note holding "Ran 8k." for a commitment named
  "Journal" of the note kind, and additions of 30 and then 90 for a commitment named "Protein" of the
  total kind with a target of 120, all four on a schedule listing Monday, Wednesday and Saturday and
  all kept from 1 January 2026, are added to a history on Monday 31 August 2026, and "Protein"'s last
  addition on that date is taken back
- **THEN** the history answers 30 for "Protein" on that date
- **AND** that "Gym" was kept on it, that "Weight" has 70.5 on it and that "Journal" has "Ran 8k." on
  it

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
- **THEN** the history does not refuse
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

#### Scenario: carrying over is refused whole where only some of the records could be the other commitment's

- **WHEN** a history holding a tick for a commitment named "Gym" on a schedule listing all seven
  weekdays, kept from 1 June 2026, on every date from Monday 3 August through Wednesday 30 September
  2026 is asked to carry that commitment's records over to a commitment named "Gym" alike in every
  other way but kept from 4 August 2026
- **THEN** the history reports that it carried nothing over
- **AND** it answers that the commitment kept from 4 August 2026 was kept on none of those dates
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

#### Scenario: a store keeps a day's additions at its place and never their sum

- **WHEN** additions of 31 and then 89.5 for a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 are added to a store
- **THEN** the content at that place holds 120.5, the day's sum, nowhere
- **AND** a store opened afterwards at the same place answers that the commitment has added 120.5 on
  that date

### Requirement: A history answers whether a commitment was kept on a day from the records it holds

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

#### Scenario: a tick of one commitment does not keep another on the same date

- **WHEN** a tick for a commitment named "Gym" on Monday 31 August 2026 is added to a history, and a
  commitment named "Run" on the same schedule listing Monday, Wednesday and Saturday and kept from
  the same 1 January 2026 is asked about
- **THEN** the history answers that "Run" was not kept on Monday 31 August 2026
- **AND** that "Gym" was

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

#### Scenario: a tick does not keep a commitment alike in name and kind but on another schedule or kept from another day

- **WHEN** a tick for a commitment named "Gym" of the tick kind, on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026 is added to a history
- **THEN** the history answers that a commitment named "Gym" of the tick kind on a schedule listing
  Monday alone, kept from 1 January 2026, was not kept on that date
- **AND** that one named "Gym" of the tick kind on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 February 2026, was not kept on it
- **AND** that the commitment the tick is of was kept on it

### Requirement: A note is of a note commitment on a calendar date it is due on, and holds one text

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

#### Scenario: a text of one zero-width space is a note

- **WHEN** a text of one zero-width space is offered for a commitment named "Journal" of the note
  kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026
- **THEN** a note is recorded
- **AND** the note holds that one zero-width space exactly

### Requirement: A store keeps every change it is given before it reports it kept

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

#### Scenario: a take-back that cannot be kept is refused and the record stays held

- **WHEN** a tick for a commitment named "Gym" of the tick kind, a number of 70.5 for a commitment
  named "Weight" of the number kind with no range, a note holding "Ran 8k." for a commitment named
  "Journal" of the note kind, and an addition of 30 for a commitment named "Protein" of the total kind
  with a target of 120, all four on a schedule listing Monday, Wednesday and Saturday and all kept
  from 1 January 2026, are added to a store on Monday 31 August 2026; what is at that place is then
  made impossible to write; and the tick is taken back
- **THEN** taking it back is refused with an error
- **AND** taking back "Weight"'s number, "Journal"'s note and "Protein"'s last addition on that date
  are each refused with an error too
- **AND** the store's history still answers that "Gym" was kept on that date, that "Weight" has 70.5
  on it, that "Journal" has "Ran 8k." on it and that "Protein" has added 30 on it
