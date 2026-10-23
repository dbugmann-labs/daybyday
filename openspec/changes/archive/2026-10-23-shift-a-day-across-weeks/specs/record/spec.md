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
commitment not every N days, one that took its due day from that record's own date, or put it on a
day other than that date, whatever week each lies in; of one every N
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
  1 January 2026, on Tuesday 1 September 2026, kept beside a shift from Tuesday 1 September 2026
  itself
- **THEN** opening is refused with an error
- **AND** the content at each place is byte-for-byte what it was before
- **AND** a store at a place holding that tick kept beside a shift from Monday 31 August 2026 opens
  without error, and answers that "Gym" was kept on Tuesday 1 September 2026
- **AND** a store at a place holding a tick of a commitment named "Pool" on a schedule listing
  Friday, kept from 1 January 2026, on Monday 7 September 2026, kept beside a shift from Friday
  4 September 2026 — a day of the week before — opens without error, and answers that "Pool" was
  kept on Monday 7 September 2026

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
