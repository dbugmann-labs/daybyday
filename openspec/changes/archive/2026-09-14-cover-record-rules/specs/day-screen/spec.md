## MODIFIED Requirements

### Requirement: A day screen tells on the row that was tapped that its change could not be kept

Where a change a row offers cannot be kept, a day screen SHALL tell it on the row tapped or
committed on and SHALL refuse the change to the caller as well; where the value given was refused
instead, that telling SHALL be the whole report and nothing SHALL be thrown. A cause SHALL be named
only where a person can act on it: a change the place refused SHALL name none, and MUST NOT tell
which change was asked or why it was refused.

Exactly four causes SHALL be named and no fifth: "Not a number" for a value that is not a number, in
a number entry or a total entry; "Must be between 40 and 150" — the commitment's own declared range
— for a number it refuses; "Must be more than 0" for an amount not above zero; and "Too large to
add" for an amount that would take the day past what can be kept exactly. The words SHALL be this
package's own English and no locale's. Nothing about a note's
length, script, line breaks or characters SHALL be named as a cause. At most one row SHALL be told
at a time, the one tapped or committed on last, and a second refusal SHALL move what is told, with
its cause, onto its own row, leaving nothing on the first. Where a day view holds two rows that are
the same row, both SHALL be told of. Telling MUST NOT change what a day screen says about keeping a
record.

#### Scenario: a refused tick is told on the row that was tapped and on no other row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, a commitment named "Journaling" on a schedule listing
  all seven weekdays and a commitment named "Supplements and habits" on that same schedule, in
  that order and all kept from 1 January 2026, and the second of its three rows is ticked
- **THEN** the day screen tells, on the second row, that the change could not be kept
- **AND** it tells nothing on the first row and nothing on the third

#### Scenario: a refused take-back is told on the row that was tapped

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from
  but not written to and that holds a record in which a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, is already kept on that date,
  and its one row — which says the commitment is kept — is ticked
- **THEN** taking the tick back is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** its day view still says the commitment is kept on that date

#### Scenario: a second refused tap is told on the row tapped last and no longer on the first

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday and a commitment named "Journaling" on a schedule listing
  all seven weekdays, in that order and both kept from 1 January 2026; its first row is ticked;
  and its second row is then ticked
- **THEN** both taps are refused with an error
- **AND** the day screen tells, on the second row, that the change could not be kept
- **AND** it tells nothing on the first row

#### Scenario: a refused change does not change what a day screen says about keeping a record

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
  twice
- **THEN** the day screen says it is keeping a record
- **AND** it tells, on that row, that the change could not be kept

#### Scenario: a number outside the commitment's range is told on the row, naming the bounds it broke

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 and a
  commitment named "Mood" of the number kind with a range of 1 to 10, both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026, and "300" is committed on the
  first row
- **THEN** the day screen tells, on that row, that the number must be between 40 and 150
- **AND** it tells nothing on the second row
- **AND** committing "0.5" on the second row of the screen it then holds tells, on that row, that
  the number must be between 1 and 10

#### Scenario: a number refused by the place is told on the row and names no cause

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Weight" of the
  number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, and "70.5" is committed on its one row
- **THEN** committing is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** what it tells names no cause

#### Scenario: a second refused commit is told on the row committed on last and no longer on the first

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 and a
  commitment named "Mood" of the number kind with a range of 1 to 10, in that order and both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026; "300" is
  committed on the first row; and "1.2.3" is then committed on the second row of the screen it
  then holds
- **THEN** the day screen tells, on the second row, that it is not a number
- **AND** it tells nothing on the first row

#### Scenario: a note refused by the place is told on the row and names no cause

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journal" of the note
  kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and
  "Ran 8k." is committed on its one row
- **THEN** committing is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** what it tells names no cause
- **AND** committing a note of a hundred thousand characters on that row tells the same thing on it
  and names no cause either

#### Scenario: an amount that is not above zero is told on the row, saying so

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120 and a commitment
  named "Water" of the total kind with a target of 2, both on a schedule listing Monday, Wednesday
  and Saturday and both kept from 1 January 2026, and "0" is committed on the first row
- **THEN** the day screen tells, on that row, that it must be more than 0
- **AND** it tells nothing on the second row
- **AND** committing "-1" on the second row of the screen it then holds tells, on that row, that it
  must be more than 0, and tells nothing on the first

#### Scenario: an amount too large to add to the day is told on the row, saying so

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; a whole number of thirty-eight
  nines is committed on its one row; and "0.5" is then committed on the row it then holds
- **THEN** the day screen tells, on that row, that it is too large to add
- **AND** what it tells is not "Not a number" and not "Must be more than 0"

#### Scenario: a value that is not a number committed in a total entry is told the same thing a number entry tells

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 and a commitment
  named "Protein" of the total kind with a target of 120, in that order and both on a schedule
  listing Monday, Wednesday and Saturday and both kept from 1 January 2026, and "1.2.3" is committed
  on the first row and then on the second row of the screen it then holds
- **THEN** the day screen tells, on the second row, that it is not a number
- **AND** what it tells there is word for word what it told on the first row

#### Scenario: an addition refused by the place is told on the row and names no cause

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Protein" of the total
  kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and "30" is committed on its one row
- **THEN** committing is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** what it tells names no cause
