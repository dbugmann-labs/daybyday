## MODIFIED Requirements

### Requirement: A day screen that is not keeping a store says a copy can be restored and where

A day screen SHALL say that a copy can be restored and SHALL name Settings as where,
exactly while it could not read its record, could not read its one-offs, is not keeping its roster
for either of that roster's two causes, or says its birthday ticks could not be read. However many of
the four are so, it SHALL say it once and no more. It MUST NOT say it where the only store it is not
keeping was written by a later version of DayByDay, and MUST NOT say it where it is keeping all three
and does not say its birthday ticks could not be read. What it says SHALL be words alone,
offering nothing to act on, and saying it SHALL read no place and change nothing.

#### Scenario: a day screen that cannot read its record says a copy can be restored and where

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place holding a run of
  bytes that is not a record, with a roster place and a one-off place where nothing has been kept, of
  a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026
- **THEN** it says a copy can be restored, and names Settings as where
- **AND** a day screen that is not keeping its roster, and one that cannot read its one-offs, each say
  the same
- **AND** a day screen that cannot read its record beside a roster written by a later version of
  DayByDay says the same

#### Scenario: a day screen not keeping any of its three stores says a copy can be restored once

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place, a roster place and
  a one-off place each holding a run of bytes that is not a store of its kind, of a commitment named
  "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026
- **THEN** it says a copy can be restored, once and no more, whatever the number of stores it is not
  keeping

#### Scenario: a day screen whose only store not kept was written by a later version says nothing about restoring a copy

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place holding a record
  written in a form one later than the form this app writes, with a roster place and a one-off place
  where nothing has been kept, of a commitment named "Gym" on a schedule listing all seven weekdays,
  kept from 1 January 2026
- **THEN** it does not say a copy can be restored
- **AND** a day screen whose roster alone, and one whose one-offs alone, were written in a form one
  later than the form this app writes each say nothing about restoring a copy either

#### Scenario: a day screen keeping all three of its stores says nothing about restoring a copy

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place, a roster place and
  a one-off place where nothing has been kept, of a commitment named "Gym" on a schedule listing all
  seven weekdays, kept from 1 January 2026
- **THEN** it does not say a copy can be restored
- **AND** a day screen that could not read its record, once what is at that place is made readable and
  the app is shown again, says nothing about restoring a copy either

#### Scenario: a day screen that says its birthday ticks could not be read says a copy can be restored, and says nothing of it while birthdays are off

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at a record
  place, a roster place and a one-off place where nothing has been kept and a birthday place holding
  a run of bytes that is not what birthday ticks are written as, with birthdays on and a calendar
  holding the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 20 January 2026
- **THEN** it says its birthday ticks could not be read, and says a copy can be restored, naming Settings
  as where
- **AND** with its record place also holding a run of bytes that is not a record, it says so once and
  no more
- **AND** a day screen opened the same way with birthdays off, one whose calendar cannot be read, and
  one whose birthday place holds birthday ticks written in a form one later than the form this app
  writes each say nothing about restoring a copy
