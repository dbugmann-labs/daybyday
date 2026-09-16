## MODIFIED Requirements

### Requirement: A look-back reads a commitment's earlier eras off the roster by resemblance

A look-back SHALL read a commitment's **chain** of **eras**. Behind a commitment stands the removed
commitment of the same name and a kind of the same sort — a number behind a number, a total behind
a total, whatever it carries — whose day kept until is the day before that commitment's day kept
from; behind that one stands the same again, until none answers. Where more than one removed
commitment answers, the look-back SHALL take the one the roster holds nearest after the era in front
of it. A commitment the roster has not removed SHALL NOT be an earlier era, and a look-back SHALL
never reach one. A look-back SHALL count each day it counts against the era that holds that day,
SHALL say the newest era's rhythm in words, and SHALL say the earliest era's day kept from as the
day the commitment is kept from.

#### Scenario: a look-back counts the era behind the one it was asked about

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Tuesday and
  Thursday, kept from 4 March 2026, whose days take a tick, on a roster also holding removed a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026 and kept until 3 March 2026, whose days take a tick, kept on no day at all, as of 31 March
  2026
- **THEN** its lines are the months March 2026, February 2026 and January 2026
- **AND** the line for March 2026 says the fraction "0/9", the one day the older era was due
  through 3 March 2026 and the eight days the newer era was due from 4 March 2026

#### Scenario: a look-back says the newest era's rhythm and the earliest era's day kept from

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Tuesday and
  Thursday, kept from 4 March 2026, whose days take a tick, on a roster also holding removed a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026 and kept until 3 March 2026, whose days take a tick, as of 31 March 2026
- **THEN** it says the rhythm "Tue, Thu" and the day kept from "1 January 2026"

#### Scenario: a look-back chains every era behind the one it was asked about

- **WHEN** a look-back is asked for at the newest of three commitments named "Gym" whose days take
  a tick, the first kept from 1 January 2026 and kept until 31 January 2026, the second kept from 1
  February 2026 and kept until 28 February 2026, both held removed, and the third kept from 1 March
  2026, as of 31 March 2026
- **THEN** it says the day kept from "1 January 2026"
- **AND** its lines are the months March 2026, February 2026 and January 2026

#### Scenario: a removed commitment of another name or another kind is not an earlier era

- **WHEN** a look-back is asked for at a commitment named "Gym" kept from 4 March 2026 whose days
  take a tick, on a roster also holding removed a commitment named "Running" kept until 3 March
  2026 whose days take a tick, and one named "Gym" kept until 3 March 2026 whose days take a number
- **THEN** it says the day kept from "4 March 2026" and its one line is the month March 2026

#### Scenario: a removed commitment kept until any day but the day before is not an earlier era

- **WHEN** a look-back is asked for at a commitment named "Gym" kept from 4 March 2026 whose days
  take a tick, on a roster also holding removed a commitment named "Gym" whose days take a tick,
  kept from 1 January 2026 and kept until 2 March 2026
- **THEN** it says the day kept from "4 March 2026" and its one line is the month March 2026
- **AND** a removed commitment of that name and kind kept until 4 March 2026 is not an earlier era
  either

#### Scenario: a look-back takes the nearest of two removed commitments that both answer

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Tuesday and
  Thursday, kept from 4 March 2026, whose days take a tick, on a roster holding, immediately after
  it, a removed commitment named "Gym" kept from 1 February 2026 and kept until 3 March 2026, and
  after that one a removed commitment named "Gym" kept from 1 January 2026 and kept until 3 March
  2026, all three taking a tick
- **THEN** it says the day kept from "1 February 2026"
- **AND** its lines are the months March 2026 and February 2026

#### Scenario: an era the roster has taken up again is kept rather than removed and ends a chain

- **WHEN** a look-back is asked for at a commitment named "Gym" kept from 4 March 2026 whose days
  take a tick, on a roster keeping a commitment named "Gym" kept from 1 January 2026 whose days
  take a tick, which it had held removed and kept until 3 March 2026 before it was offered again
- **THEN** it says the day kept from "4 March 2026" and its one line is the month March 2026

#### Scenario: a look-back chains an era whose range or target differs behind the one it was asked about

- **WHEN** a look-back is asked for at a commitment named "Mood" kept from 4 March 2026 whose days
  take a number with a range of 1 to 5, on a roster also holding removed a commitment named "Mood"
  kept from 1 January 2026 and kept until 3 March 2026 whose days take a number with a range of 1 to
  10, as of 31 March 2026
- **THEN** it says the day kept from "1 January 2026"
- **AND** a look-back at a commitment named "Protein" kept from 4 March 2026 whose days take a total
  with a target of 100, on a roster also holding removed one named "Protein" kept from 1 January 2026
  and kept until 3 March 2026 whose days take a total with a target of 120, says the day kept from
  "1 January 2026" too
- **AND** a look-back at a commitment named "Weight" kept from 4 March 2026 whose days take a number
  carrying no range, on a roster also holding removed one named "Weight" kept from 1 January 2026 and
  kept until 3 March 2026 whose days take a number with a range of 40 to 150, says the same
