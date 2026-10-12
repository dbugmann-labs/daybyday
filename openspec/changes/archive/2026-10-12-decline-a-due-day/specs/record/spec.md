## ADDED Requirements

### Requirement: A decline is of a commitment on a calendar date it is due on, and carries a reason or none

A decline SHALL be a commitment, a calendar date and a reason or none, and nothing else. The system
SHALL refuse to form one for a commitment on a date it is not due on, a date before its kept-from day
included, and for a commitment on a weekly quota on any date, and SHALL form one for a commitment of
every kind on a date it is due on; it MUST refuse rather than adjust.

A reason empty or made only of blank space, judged by the test a note is judged by, SHALL be refused
and MUST NOT be taken as no reason. Every other reason SHALL be kept exactly as given, of any length
and in any script, blank space and line breaks included. Two declines SHALL be the same exactly when
their commitment, date and reason all are, no reason differing from every reason.

#### Scenario: a decline is formed for a commitment of every kind on a date it is due on, with a reason or none

- **WHEN** a decline with the reason "Ran out" is offered for a commitment named "Magnesium" of the
  tick kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026
- **THEN** a decline is formed, holding the reason "Ran out"
- **AND** a decline with no reason is formed for that same commitment and date, holding none
- **AND** a decline is formed on that date for a commitment alike in every way but of the number
  kind with a range of 40 to 150, for one of the note kind, and for one of the total kind with a
  target of 120
- **AND** a decline is formed for a commitment named "Finances" on a schedule on the 25th of the
  month, kept from 1 January 2026, on 25 September 2026, and for one named "Nails" on a schedule of
  every 4 days starting on Thursday 6 August 2026, kept from that day, on Sunday 30 August 2026

#### Scenario: a commitment takes no decline on a date it is not due on

- **WHEN** a decline with the reason "Ran out" is offered for a commitment named "Magnesium" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Tuesday 1 September
  2026
- **THEN** no decline is formed
- **AND** no decline is formed for the same commitment kept from Wednesday 2 September 2026 on
  Monday 31 August 2026, a date its schedule is due on but its kept-from day is not reached by
- **AND** no decline with no reason is formed on either date

#### Scenario: a commitment on a weekly quota takes no decline on any date

- **WHEN** a decline with no reason is offered for a commitment named "Yuno" on a weekly quota of
  2 times a week, kept from 1 January 2026, on each date from Monday 31 August through Sunday
  6 September 2026
- **THEN** no decline is formed on any of those seven dates
- **AND** no decline with the reason "Away" is formed on any of them either

#### Scenario: a reason that says nothing forms no decline

- **WHEN** a decline whose reason is the empty text is offered for a commitment named "Magnesium" on
  a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August
  2026
- **THEN** no decline is formed
- **AND** no decline is formed with a reason of three spaces, of three line breaks, or of a tab
  followed by a line break
- **AND** a decline is formed with a reason of one zero-width space, holding it exactly

#### Scenario: a reason is kept exactly as given, whatever it holds

- **WHEN** each of " Ran out ", a text of a hundred thousand characters, "שלום עולם", a text of one
  emoji, and a text of two lines separated by a line break is offered as the reason of a decline for
  a commitment named "Magnesium" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, on Monday 31 August 2026
- **THEN** a decline is formed for every one of them
- **AND** each holds the reason it was given, character for character, the spaces around " Ran out "
  and the line break included

#### Scenario: two declines are the same exactly when their commitment, date and reason all are

- **WHEN** two declines with the reason "Ran out" are formed, both for a commitment named
  "Magnesium" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and
  both on Monday 31 August 2026
- **THEN** the two are the same decline
- **AND** a decline with the reason "Away" for that same commitment and date is a different decline
  from either, and so is one with no reason
- **AND** a decline with the reason "Ran out" for that same commitment on Wednesday 2 September 2026
  is different again, and so is one on Monday 31 August 2026 for a commitment alike in every way but
  named "Zinc"

### Requirement: A history holds a decline in its day's place, and never beside another record

A history SHALL answer whether a commitment's day is declined, and with what reason, from the
declines it holds, a date it is not due on answered not declined rather than refused; the answer SHALL depend on the commitment and the date
alone. A decline SHALL NOT keep its day and SHALL NOT count toward a standing.

A history SHALL hold at most one decline per commitment per day, a later one replacing it, and never
a decline beside another record of that commitment on that day: a decline added where the day holds
a tick, a number, a note or an addition SHALL leave the history as it was, and any of those added
where it holds a decline SHALL replace it, the history then being the same as one never given that
decline. Two histories holding the same records SHALL be the same history, in any order.

#### Scenario: a declined day is answered declined, with its reason, and not kept

- **WHEN** a decline with the reason "Ran out" for a commitment named "Magnesium" of the tick kind,
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday
  31 August 2026 is added to a history
- **THEN** the history answers that "Magnesium" is declined on that date, with the reason "Ran out"
- **AND** that it was not kept on that date, and that its standing on Sunday 6 September 2026 is zero
- **AND** that it is declined on no other date, Wednesday 2 September 2026 and Tuesday 1 September
  2026, a date it is not due on, included
- **AND** that a commitment named "Zinc" on that same schedule and kept from that same day is not
  declined on Monday 31 August 2026
- **AND** a history that has taken no record answers that "Magnesium" is declined on no date

#### Scenario: a decline added on a declined day replaces it

- **WHEN** a decline with the reason "Ran out" and then a decline with the reason "Ran out, ordered
  more", both for a commitment named "Magnesium" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, on Monday 31 August 2026, are added to a history
- **THEN** the history answers that "Magnesium" is declined on that date, with the reason "Ran out,
  ordered more"
- **AND** the history is the same as a history the second decline alone was added to
- **AND** a decline with no reason added after them leaves it declined on that date, with none

#### Scenario: a decline added on a day holding any other record leaves the history as it was

- **WHEN** a tick for a commitment named "Gym" of the tick kind, a number of 70.5 for one named
  "Weight" of the number kind with no range, a note holding "Ran 8k." for one named "Journal" of the
  note kind, and an addition of 30 for one named "Protein" of the total kind with a target of 120 —
  all four on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026 —
  are added to a history on Monday 31 August 2026, and a decline with the reason "Away" is then
  added for each of the four on that date
- **THEN** the history is the same as it was before the four declines were added
- **AND** it answers that none of the four is declined on that date, and that "Protein" has added 30
  on it and was not kept on it

#### Scenario: a record added on a declined day replaces the decline

- **WHEN** a decline with the reason "Away" is added to a history for each of a commitment named
  "Gym" of the tick kind, one named "Weight" of the number kind with no range, one named "Journal"
  of the note kind and one named "Protein" of the total kind with a target of 120 — all four on a
  schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026 — on Monday
  31 August 2026, and then a tick for "Gym", a number of 70.5 for "Weight", a note holding "Ran 8k."
  for "Journal" and an addition of 30 for "Protein" are added on that date
- **THEN** the history is the same as a history that tick, that number, that note and that addition
  alone were added to
- **AND** it answers that none of the four is declined on that date, that "Gym", "Weight" and
  "Journal" were kept on it, and that "Protein" was not
- **AND** taking the tick for "Gym" back leaves "Gym" neither kept nor declined on that date

#### Scenario: two histories given the same declines in either order are the same history

- **WHEN** a decline with the reason "Ran out" on Monday 31 August 2026 and a decline with no reason
  on Wednesday 2 September 2026, both for a commitment named "Magnesium" on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, are added to one history in that order
  and to another in the opposite order
- **THEN** the two histories are the same history
- **AND** a history given the decline on Monday with the reason "Away" in place of "Ran out" is a
  different history from either

### Requirement: A decline a history holds can be taken back

A history SHALL let the decline it holds for a commitment on a calendar date be taken back, named by
that commitment and that date rather than by its reason. Taking it back SHALL leave that day holding
no record of that commitment, the history the same as one never given that decline, and every other
record standing exactly as it did, on other days and for other commitments. Nothing of a decline
taken back SHALL be kept. Taking back where the history holds no decline SHALL leave it unchanged
rather than being refused, whatever else the day holds and whether or not the commitment is due on
that date.

#### Scenario: a decline taken back leaves its day holding nothing

- **WHEN** declines with the reason "Ran out" for a commitment named "Magnesium" on Monday 31 August
  and on Wednesday 2 September 2026, and a decline with no reason for a commitment named "Zinc" on
  Monday 31 August 2026 — both on a schedule listing Monday, Wednesday and Saturday and both kept
  from 1 January 2026 — are added to a history, and "Magnesium"'s decline on 31 August is taken back
- **THEN** the history answers that "Magnesium" is neither declined nor kept on Monday 31 August 2026
- **AND** that it is still declined on Wednesday 2 September 2026, and that "Zinc" is still declined
  on Monday 31 August 2026
- **AND** a history given one decline and then taken back is the same as a history that has taken no
  record at all

#### Scenario: taking back a decline where the history holds none leaves it unchanged

- **WHEN** a tick for a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, on Monday 31 August 2026 is added to a history, and "Gym"'s decline on
  that date, which the history does not hold, is taken back
- **THEN** the history is the same as it was before
- **AND** it still answers that "Gym" was kept on that date
- **AND** taking back "Gym"'s decline on Tuesday 1 September 2026, a date it is not due on, leaves it
  unchanged too

### Requirement: A store keeps the declines it is given, and reads each back as it was given

A store SHALL keep a decline added, replaced or taken back at its place before it reports it kept,
and a store opened there afterwards SHALL hold exactly the declines kept and not since taken back or
replaced, each with its reason character for character or with none. A record that replaced a
decline SHALL leave nothing of it at the place. A decline or a take-back that cannot be kept SHALL be
refused, the history left as it was. Beside a decline the store SHALL keep the shift its day answers
to, as *A store persists each kind of record as exactly what it is* says of every record. A history
kept in a form before a day could hold a decline SHALL be read as holding none, its place left
byte-for-byte as it was.

#### Scenario: declines kept in a store are read back by a store opened afterwards, each with its reason

- **WHEN** a decline with the reason "Ran out" on Monday 31 August 2026, one with no reason on
  Wednesday 2 September 2026, and one whose reason is " Knee still sore " followed by a line break
  and "Resting it." on Saturday 5 September 2026, each for a commitment named "Run" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, are added to a store; a decline
  with the reason "Ran out, ordered more" is then added on Monday 31 August 2026; the decline on
  Wednesday is taken back; and a store is opened afterwards at the same place
- **THEN** the later store's history is the same as a history the decline with the reason "Ran out,
  ordered more" and the decline on Saturday alone were added to
- **AND** it answers the reason on Saturday 5 September 2026 character for character, the spaces and
  the line break included, and that "Run" is not declined on Wednesday 2 September 2026

#### Scenario: a record added on a declined day is read back alone by a store opened afterwards

- **WHEN** a decline with the reason "Away" for a commitment named "Gym" of the tick kind and one with
  no reason for a commitment named "Protein" of the total kind with a target of 120, both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026, are added to a
  store on Monday 31 August 2026; a tick for "Gym" and an addition of 30 for "Protein" are then added
  on that date; and a store is opened afterwards at the same place
- **THEN** the later store's history is the same as a history that tick and that addition alone were
  added to
- **AND** the content at that place holds "Away" nowhere

#### Scenario: a decline that cannot be kept is refused and not held

- **WHEN** a store is opened at a place where nothing can be written — a path beneath an existing
  ordinary file — and a decline with the reason "Ran out" for a commitment named "Magnesium" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026
  is added to it
- **THEN** adding it is refused with an error
- **AND** the store's history is still the same as a history that has taken no record
- **AND** a store opened afterwards at the same place holds an empty history
- **AND** a store holding that decline, whose place is then made impossible to write, refuses taking
  it back with an error, and its history still answers that "Magnesium" is declined on that date

#### Scenario: a decline on a day a shift put a due day on is read back after the app is closed and opened again

- **WHEN** a roster holds a commitment named "Magnesium" of the tick kind, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, with its due day on Monday 31 August 2026
  shifted to Tuesday 1 September 2026; a decline with the reason "Away" for it on Tuesday 1 September
  2026, formed against the commitment that roster keeps, is kept at a record place; and a store is
  opened afterwards at that record place
- **THEN** opening is not refused
- **AND** its history answers that "Magnesium" is declined on Tuesday 1 September 2026, with the
  reason "Away"

#### Scenario: a history kept before a day could hold a decline is read with none, and its place left as it was

- **WHEN** a store is opened at a place holding a history written in the form used before a day could
  hold a decline, holding one tick for a commitment named "Gym" of the tick kind on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August 2026
- **THEN** it opens without error
- **AND** its history is the same as a history that tick was added to, and answers that "Gym" is
  declined on no date
- **AND** the content at that place is byte-for-byte what it was before
- **AND** a decline with the reason "Away" for a commitment named "Run" on that same schedule and
  kept from that same day, on Wednesday 2 September 2026, added to it is read back beside that tick
  by a store opened afterwards

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
carrying no addition at all, a decline of a commitment on a weekly quota or one whose reason
says nothing, a day holding a decline beside any other record of its commitment, or a shift kept beside a record that could not be one: of a
commitment not every N days, one that took its due day from that record's own date or from a day
outside that date's Monday-to-Sunday week, or put it on a day other than that date; of one every N
days, one whose two days are one day or not fewer days apart than its interval, or that put its due
day on a day after that date.

Every rule a record is formed by SHALL be applied again to what comes off the place, and of a shift
kept beside a record exactly the ones its last case names; this capability SHALL add no other rule
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

- **WHEN** a store is opened at a place holding a store in the form this app writes, whose one
  number is 300 for a commitment named "Weight" of the number kind with a range of 40 to 150, on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August
  2026 — a number outside its commitment's range
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

- **WHEN** a store is opened at a place holding a store in the form this app writes, whose one day
  of additions holds an amount of 0, for a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, on
  Monday 31 August 2026 — an amount that is not above zero
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
  holds an addition of a whole number of thirty-eight nines and then an addition of 0.5 — two
  amounts each of which is an addition, and a day no person using this app could have made, because
  their exact sum needs thirty-nine significant digits — for a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1
  January 2026, on Monday 31 August 2026
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

#### Scenario: a store holding a record beside an every-N-days shift that could not be one is refused

- **WHEN** a store is opened at a place holding a store in the form this app writes, whose one tick
  is of a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August 2026,
  kept from that day, on Friday 4 September 2026, kept beside a shift from Wednesday
  26 August 2026 to Monday 31 August 2026 — five days apart
- **THEN** opening is refused with an error
- **AND** a store at a place holding a tick of "Nails" on Thursday 3 September 2026 kept beside a
  shift from Friday 4 September to Saturday 5 September 2026 is refused the same way
- **AND** a store at a place holding a tick of a commitment named "Gym" on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, on Wednesday 2 September 2026, kept
  beside a shift from Monday 31 August to Tuesday 1 September 2026, is refused the same way
- **AND** the content at each place is byte-for-byte what it was before
- **AND** a store at a place holding the tick of "Nails" on Friday 4 September 2026 kept beside a
  shift from Sunday 30 August to Monday 31 August 2026 opens without error, and answers that
  "Nails" was kept on that day

#### Scenario: a store holding what could not be a decline is refused

- **WHEN** a store is opened at a place holding a store in the form this app writes, whose one decline
  is of a commitment named "Yuno" on a weekly quota of 2 times a week, kept from 1 January 2026, on
  Monday 31 August 2026
- **THEN** opening is refused with an error
- **AND** a store at a place holding one decline of a commitment named "Magnesium" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, on Tuesday 1 September 2026, a
  date it is not due on, is refused the same way
- **AND** so is one holding a decline of "Magnesium" on Monday 31 August 2026 whose reason is three
  spaces, and one holding both a decline and a tick of "Magnesium" on that date
- **AND** the content at each place is byte-for-byte what it was before

### Requirement: A store reads every form it has written

A store SHALL read a history kept in any form this app has written, the current form and every form
before it. It SHALL refuse a form later than the one it writes, and SHALL refuse a form number this
app has never written, one below the earliest, with an error saying the content is not a store
rather than that it is from a later form. A store SHALL read each form as the shape that form has,
and SHALL refuse one whose shape and declared form disagree. Which shape belongs to which form SHALL
be judged against the form each part was first written at, never the newest: numbers arrived at the
third form, notes the fourth, additions the fifth, a record's identity the sixth, a shift kept beside a record
the seventh, and the day a shift put a due day on, kept beside a record on another day, the eighth, and declines the ninth. Opening a store MUST NOT change what is at its
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
- **AND** a store at a place holding a store in the form this app writes, with no place for
  additions in it at all, is refused the same way
- **AND** a store written in the form used before a day could hold a note, holding neither notes nor
  additions, is read without error, because that form is expected to carry neither
- **AND** the error says the content is not a store rather than that it is from a later form
- **AND** the content at each place is byte-for-byte what it was before

#### Scenario: a change that leaves a store's history as it was writes nothing at its place

- **WHEN** a tick for a commitment named "Gym" of the tick kind, a number of 70.5 for a commitment
  named "Weight" of the number kind with no range and a note holding "Ran 8k." for a commitment
  named "Journal" of the note kind, all three on a schedule listing Monday, Wednesday and Saturday
  and all kept from 1 January 2026, on Monday 31 August 2026, are added to a store; what is at that
  place is then made impossible to write; and that same tick is added to the store again
- **THEN** adding it is not refused
- **AND** adding that same number again, and that same note again, is not refused either
- **AND** taking back a tick for "Gym" on Wednesday 2 September 2026, the number of "Weight" and the
  note of "Journal" on that date, and the last addition of a commitment named "Protein" of the total
  kind with a target of 120 on Monday 31 August 2026 — none of which the store holds — is not
  refused either
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

#### Scenario: a store whose shape and declared form disagree about the day a shift put a due day on is refused

- **WHEN** a store is opened at a place holding a store written in the form used before the day a
  shift put a due day on was kept beside a record on another day, whose one tick, of a commitment
  named "Nails" on a schedule of every 4 days starting on Thursday 6 August 2026, kept from that
  day, on Friday 4 September 2026, nonetheless has kept beside it a shift from Sunday 30 August 2026
  to Monday 31 August 2026, both days
- **THEN** opening is refused with an error
- **AND** the error says the content is not a store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a store whose shape and declared form disagree about declines is refused

- **WHEN** a store is opened at a place holding a store written in the form used before a day could
  hold a decline, which nonetheless holds one decline
- **THEN** opening is refused with an error
- **AND** a store at a place holding a store in the form this app writes, with no place for declines
  in it at all, is refused the same way
- **AND** the error says the content is not a store rather than that it is from a later form
- **AND** the content at each place is byte-for-byte what it was before

### Requirement: A history carries every record of one commitment over to another

A history SHALL carry over every record it holds of one commitment to another: each SHALL afterwards
be a record of the second, on the date it was made for, the first SHALL hold none, and the history
SHALL report that it carried them. A number SHALL be carried digit for digit, a note character for
character, a day's additions in their order, and a decline with its reason character for character
or with none.

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

#### Scenario: a decline is carried over with its reason, character for character

- **WHEN** a history holding a decline whose reason is " Ran out " for a commitment named "Magnesium"
  on a schedule listing all seven weekdays, kept from 1 January 2026, on Monday 3 August 2026 is
  asked to carry that commitment's records over to a commitment named "Magnesium 💊" alike in every
  other way
- **THEN** the history reports that it carried them over
- **AND** it answers that "Magnesium 💊" is declined on that date with the reason " Ran out ", and
  that "Magnesium" is declined on no date
- **AND** a history holding that same decline, asked to carry it over to a commitment named
  "Magnesium" alike in every other way but kept from 1 September 2026, reports that it carried
  nothing over and is the same history as one that was never asked
