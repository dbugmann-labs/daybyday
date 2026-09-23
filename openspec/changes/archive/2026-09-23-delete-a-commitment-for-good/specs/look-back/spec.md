## MODIFIED Requirements

### Requirement: A commitments screen answers a look-back at a commitment on either of its lists

A commitments screen SHALL answer a **look-back** at any commitment on its kept list or its stopped
list, whatever kind that commitment's days take. A look-back SHALL say the commitment's name, the
rhythm it runs on in words, the day it is kept from and, where the roster has stopped keeping that
commitment, the day it was kept until; where the roster is keeping it, the look-back SHALL say no
day kept until. The screen SHALL answer no look-back at a commitment on neither list, and none at
all while it cannot read its roster or cannot read its record. A look-back SHALL be a value: asking
for the same commitment twice SHALL answer the same look-back, and asking SHALL change nothing the
screen holds and SHALL write nothing at either place it keeps.

#### Scenario: a commitments screen answers a look-back at a commitment it keeps

- **WHEN** a commitments screen keeping a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, whose days take a tick, as of 15 March 2026, is
  asked for a look-back at it
- **THEN** it answers one, saying the name "Gym", the rhythm "Mon, Wed, Sat" and the day kept from
  "1 January 2026"
- **AND** the look-back says no day kept until

#### Scenario: a commitments screen answers a look-back at a commitment it has stopped, saying the day it was kept until

- **WHEN** a commitments screen that has stopped keeping a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026 and kept until 28 February 2026,
  whose days take a tick, as of 15 March 2026, is asked for a look-back at it
- **THEN** it answers one, saying the name "Gym", the rhythm "Mon, Wed, Sat", the day kept from
  "1 January 2026" and the day kept until "28 February 2026"

#### Scenario: a commitments screen answers no look-back at a commitment on neither of its lists

- **WHEN** a commitments screen keeping a commitment named "Gym" is asked for a look-back at a
  commitment named "Journaling" that its roster does not hold
- **THEN** it answers no look-back
- **AND** asked for a look-back at a commitment it has deleted, it answers none either

#### Scenario: a commitments screen that cannot read its roster or its record answers no look-back

- **WHEN** a commitments screen whose roster place holds a run of bytes that is not a roster is
  asked for a look-back at any commitment
- **THEN** it answers no look-back
- **AND** a commitments screen that reads its roster but whose record place holds a run of bytes
  that is not a record answers no look-back either

#### Scenario: asking a commitments screen for a look-back changes nothing and writes nothing

- **WHEN** a commitments screen keeping a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, whose days take a tick, as of 15 March 2026, is
  asked for a look-back at it twice
- **THEN** both answers are the same look-back
- **AND** the lists it draws, the change it last refused and the bytes at its roster place and at
  its record place are exactly what they were before the first ask
