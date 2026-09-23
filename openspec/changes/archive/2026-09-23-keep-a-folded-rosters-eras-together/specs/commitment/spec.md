## ADDED Requirements

### Requirement: A fold stands each commitment's eras together, behind the commitment they belong to

The roster a fold answers with SHALL hold the eras of each commitment it made together, the newest
first and each earlier era immediately behind the era it gave way to, wherever the stored roster
held the entries they were made from; no entry of another commitment SHALL stand between two of
them. The commitments SHALL stand in the order the stored roster held the entry each was made from
— the entry it kept or had stopped keeping, or the removed entry that chained to nothing and became
a stopped commitment of its own. The roster a fold answers with SHALL be one this app writes and
reads back as it stands, under *A roster store keeps a roster and every era at a place, across the
app being closed and opened again*.

#### Scenario: a commitment's eras fold together though the stored roster held another commitment's entry between them

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment had an identity, whose entries are "Gym" on a schedule listing Tuesday and Thursday,
  kept from 1 March 2026 and kept; "Run" on a schedule listing Monday, kept from 1 February 2026
  and kept; and "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, removed and kept until 28 February 2026
- **THEN** its roster reads back two commitments it is keeping, "Gym" first and "Run" second
- **AND** it reads back two eras of "Gym", the one on Tuesday and Thursday first, and one of "Run"
- **AND** the two eras of "Gym" stand one behind the other in the roster, with "Run" behind both
- **AND** it says "Gym" is kept from 1 January 2026

#### Scenario: an era the stored roster held in front of the commitment it belongs to folds behind it

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment had an identity, whose entries are "Swim" on a schedule of every 8 days from
  10 September 2026, kept from 10 September 2026, removed and kept until 15 September 2026; "Swim"
  on a schedule listing Friday, kept from 10 September 2026, removed and kept until 15 September
  2026; and "Swim" on a schedule listing Friday, kept from 16 September 2026 and kept
- **THEN** its roster reads back one commitment it is keeping, "Swim" on Friday, with two eras, the
  one kept from 16 September 2026 first
- **AND** it says the commitment it keeps is kept from 10 September 2026
- **AND** it reads back one commitment it has stopped, "Swim", which is not the one it keeps
- **AND** the one it has stopped stands in front of both eras of the one it keeps

#### Scenario: a folded roster whose stored entries were interleaved is read back whole after the next change is kept

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment had an identity, whose entries are "Gym" on a schedule listing Tuesday and Thursday,
  kept from 1 March 2026 and kept; "Run" on a schedule listing Monday, kept from 1 February 2026
  and kept; and "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, removed and kept until 28 February 2026, and a commitment named "Swim" is taken on through
  it
- **THEN** a store opened afterwards at that place opens without error
- **AND** that store reads back three commitments it is keeping, "Gym", "Run" and "Swim"
- **AND** it reads back two eras of "Gym" and says "Gym" is kept from 1 January 2026

## MODIFIED Requirements

### Requirement: A roster store that cannot be read is refused rather than emptied

Opening a roster store at a place holding something this app cannot read as a roster store SHALL be
refused with an error. The store MUST NOT answer with a roster holding nothing in its place, MUST
NOT overwrite, move or delete what is there, and MUST NOT keep the part of it that could be read.

This app cannot read, as a roster store: content that is not a roster store; a roster store written
in a form later than the one this app knows; and a roster store holding something that could not be
a roster — a commitment that could not be formed, a date that names no day, the same era held
twice, one commitment's eras with another commitment's entry standing between them, or a
commitment held as removed with no day it was kept until. Two entries SHALL be the same
era where they carry one identity and are alike in schedule, in the day they are kept from and in
the kind their days take, and, in a roster kept before a commitment had an identity, where the
commitments they hold are alike in every part; entries carrying one identity and differing in any of
those three SHALL be that commitment's eras and SHALL be read as one commitment. A commitment of the number
kind carrying only one end of a range SHALL be one that could not be formed, and SHALL be refused
with the rest; the missing end SHALL NOT be invented.

#### Scenario: content that is not a roster store is refused and left as it was

- **WHEN** a roster store is opened at a place holding content that is not a roster store — a run of
  bytes that is not what the store writes
- **THEN** opening is refused with an error
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store written in a later form than this app knows is refused

- **WHEN** a roster store is opened at a place holding a roster store written in a form one later
  than the form this app writes, holding no commitments
- **THEN** opening is refused with an error
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store holding what could not be a roster is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment has a name of three spaces — a name no commitment can be formed with
- **THEN** opening is refused with an error
- **AND** a roster store at a place holding one commitment kept from 30 February 2026, a date that
  names no day, is refused the same way
- **AND** a roster store at a place holding the same era twice — two entries alike in identity, in
  name, in schedule, in the day it is kept from and in kind — is refused the same way
- **AND** the content at each of the three places is byte-for-byte what it was before

#### Scenario: a roster store holding a commitment with half a range is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment is of the number kind carrying a lowest of 40 and no highest at all
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** a roster store at a place holding one commitment of the number kind carrying a highest of
  150 and no lowest at all is refused the same way
- **AND** the content at each of the two places is byte-for-byte what it was before

#### Scenario: a roster store holding a commitment removed with no day it was kept until is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment is held as removed and carries no day it was kept until
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store holding a commitment again after holding it stopped or removed is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose two commitments are the same commitment — named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026 — the first held stopped as of 31 January 2026
  and the second held kept
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** a roster store at a place holding the same two, the first held removed as of 31 January
  2026, is refused the same way
- **AND** the content at each of the two places is byte-for-byte what it was before

#### Scenario: a roster store holding a day kept until that names no day is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment, named "Gym" on a schedule listing Monday, Wednesday and Saturday and kept
  from 1 January 2026, is held stopped as of 30 February 2026
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store holding a commitment whose range has its lowest above its highest is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment, named "Gym" and kept from 1 January 2026, on a schedule listing Monday,
  Wednesday and Saturday, is of the number kind with a lowest of 10 and a highest of 1
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store holding a commitment whose target is not above zero is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment, named "Gym" and kept from 1 January 2026, on a schedule listing Monday,
  Wednesday and Saturday, is of the total kind with a target of 0
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store holding a commitment on a day of the month outside the thirty-one is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment, named "Gym" and kept from 1 January 2026, is on a schedule on the 32nd of
  the month
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store holding an every-N-days schedule whose start date names no day is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment, named "Gym" and kept from 1 January 2026, is on a schedule of every 3 days
  starting on 30 February 2026
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store holding one commitment's eras split apart by another commitment's entry is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose three entries are two eras of one commitment named "Gym" — the newer on a schedule listing
  Tuesday and Thursday, kept from 1 March 2026, and the earlier on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026 and kept until 28 February 2026 — with the one
  entry of a commitment named "Run" standing between them
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster kept before a commitment had an identity holding one era twice is refused

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment had an identity, whose entries are "Gym" on a schedule listing Monday, kept from
  1 March 2026 and kept, and "Gym" on that same schedule, kept from 1 March 2026, removed and kept
  until 28 February 2026 — alike in every part with the entry in front of it, and chaining to it
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before
