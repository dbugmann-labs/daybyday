## MODIFIED Requirements

### Requirement: A day screen returned to from a commitments screen that restored a copy draws what the copy holds

A day screen returned to from a commitments screen that has restored a copy since that screen was
opened SHALL open its record place, its roster place and its one-off place afresh, whether or not it
was keeping each, and SHALL form its day view from what it then reads, taking on the commitments it
was handed where the roster it reads holds nothing at all. It SHALL NOT take a new today, nor move the
day it is showing. It SHALL then tell nothing on any row and nothing under any one-off name field.
Returned to from a commitments screen that has restored no copy, it SHALL be returned to exactly as
being returned to is.

#### Scenario: a day screen returned to after a restore draws the copy's commitments, records and one-offs

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a one-off named "Book dentist" on 31 August 2026 is
  kept at a one-off place; a day screen of no commitments at all is opened at those places and a
  record place where nothing has been kept as of Monday 31 August 2026; a commitments screen is
  opened at the same places and a copy is made through it as of that day at 14:32; the day screen's
  "Gym" row is then ticked, a commitment named "Journaling" alike in every other way is taken on
  through the commitments screen, and "Book dentist" is removed through the day screen; the
  commitments screen restores that copy; and the day screen is returned to from it
- **THEN** its day view holds one row, named "Gym", which says its commitment was not kept
- **AND** its One-offs group holds one row, named "Book dentist"

#### Scenario: a day screen that was keeping no record keeps the copy's record once returned to after a restore

- **WHEN** a record place holds a run of bytes that is not a record, and a one-off place a run of
  bytes that is not a one-off holder; a day screen of a commitment named "Gym" on a schedule listing
  all seven weekdays, kept from 1 January 2026, is opened at those places and a roster place where
  nothing has been kept as of Monday 31 August 2026; a commitments screen opened at the same places
  restores a copy holding that commitment and a tick for it on that day; and the day screen is
  returned to from it
- **THEN** it says it is keeping a record and keeping one-offs
- **AND** its day view holds one row, named "Gym", which says its commitment was kept

#### Scenario: a day screen returned to after a restore tells nothing it was telling

- **WHEN** a commitment named "Sleep" of the number kind, taking 0 to 24, on a schedule listing all
  seven weekdays and kept from 1 January 2026, is taken on at a roster place; a one-off named "Book
  dentist" on 31 August 2026 is kept at a one-off place; a day screen of no commitments at all is
  opened at those places and a record place where nothing has been kept as of Monday 31 August 2026;
  25 is committed in the "Sleep" row's number entry and refused; "Book dentist" is committed in its
  one-off entry and refused; a commitments screen opened at the same places restores a copy made
  there; and the day screen is returned to from it
- **THEN** it tells nothing on any row
- **AND** it tells nothing under its one-off entry

#### Scenario: a day screen returned to after a restore keeps the today it was handed and the day it was showing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place, a record place and a one-off place where nothing has been kept as of Monday
  31 August 2026 and moved to the day before; a commitments screen opened at the same places restores
  a copy made there; and the day screen is returned to from it
- **THEN** its day picker opens on Sunday 30 August 2026, and it offers the way back to today
- **AND** its day view holds one row, named "Gym"

#### Scenario: a day screen returned to from a commitments screen that restored no copy does not read its record again

- **WHEN** a record place holds a run of bytes that is not a record; a day screen of a commitment
  named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026, is opened at that
  place and a roster place and a one-off place where nothing has been kept as of Monday 31 August
  2026; a commitments screen is opened at the same places; what is at the record place is removed; a
  copy is made through the commitments screen as of that day at 14:32; and the day screen is returned
  to from it
- **THEN** it still says it is keeping no record

#### Scenario: a day screen returned to from a commitments screen that restored a copy and then kept a change opens all three places

- **WHEN** a record place holds a run of bytes that is not a record; a day screen of no commitments
  at all is opened at that place and a roster place and a one-off place where nothing has been kept
  as of Monday 31 August 2026; a commitments screen opened at the same places restores a copy holding
  a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026, and a
  tick for it on that day; a commitment named "Journaling" alike in every other way is then defined
  and kept through the commitments screen; and the day screen is returned to from it
- **THEN** it says it is keeping a record
- **AND** its day view holds two rows, named "Gym" and then "Journaling", the first saying its
  commitment was kept

#### Scenario: a day screen returned to after a copy of nothing was restored takes on the commitments it was handed

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened at a roster place, a record place and a one-off place where
  nothing has been kept as of Monday 31 August 2026, where a copy of three places holding nothing is
  then restored through a commitments screen opened at the same places; and the day screen is
  returned to from it
- **THEN** a roster store opened afterwards at that roster place holds one commitment, named
  "Journaling"
- **AND** its day view holds one row, named "Journaling"
