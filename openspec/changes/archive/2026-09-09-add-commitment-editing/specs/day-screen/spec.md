## MODIFIED Requirements

### Requirement: A day screen reads its roster again when it is returned to

A day screen SHALL read its roster place again when it is returned to, and SHALL form its day view
again from the roster it then reads, for the day it is showing. Being returned to is the moment a
person comes back to the day screen from somewhere else in the app, and it is the second and last
moment a day screen opens its roster place — the first being when the app is shown.

It exists because the roster place has a second writer. A commitment taken on, stopped or **changed**
on a commitments screen reaches the same file, and without this a person would define a commitment and
not see it until the app had been backgrounded and brought in front of them again.

**Being returned to is not being shown, and does two things fewer.** It SHALL NOT take a new
today and it SHALL NOT move the day being shown. A person walking to another screen and back has not
restarted anything.

**It SHALL read its record place again where it is keeping a record, and SHALL NOT where it is not**,
and that is amended for `add-commitment-editing` (#148) rather than as it shipped. The record place
has a second writer now, exactly as the roster place already had: a commitment renamed on a
commitments screen carries every record of it over to the new value at that same file, so a day screen
that read the roster again and not the record would draw the commitment under its new name and answer
that every day it was ever kept was not kept — the one answer this product exists to prevent. What a
day screen says about a record it **could not read** is untouched by that: a screen not keeping a
record does not start keeping one by being returned to, so that state, and anything else whose
lifetime is fixed as *until the app is shown again*, SHALL still stand across being returned to. The
last scenario below asserts exactly that and stays true; **its title, *a day screen returned to does
not read its record again*, is now wrong** and it is kept unrenamed deliberately, because renaming a
requirement's scenario is not something `openspec` allows a MODIFIED requirement to do and the
assertion is the part that matters. That now has a second thing under it
as well as the record state: `add-refused-tick-notice` (#100) landed while this Story was being
written, and what a day screen tells on a row ends on exactly three things, of which being returned
to is not one. It stands, and the last scenario below is what says so.

Where the roster it then reads holds nothing at all, a day screen SHALL take on the commitments it
was handed, exactly as it does when it is opened and when the app is shown again; and where the
place cannot be read, it SHALL say so and draw no rows, exactly as it does then. Being returned to
adds no rule of its own to either.

#### Scenario: a commitment taken on at a day screen's roster place is drawn when the screen is returned to

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; a
  commitment named "Gym" on that same schedule, kept from that same day, is then taken on at that
  roster place by something else; and the day screen is returned to
- **THEN** its day view holds two rows, named "Journaling" and then "Gym"
- **AND** the day view it held before it was returned to held one row, named "Journaling"

#### Scenario: a commitment stopped at a day screen's roster place is not drawn when the screen is returned to

- **WHEN** a commitment named "Journaling" and one named "Gym", both on a schedule listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; a day screen of no
  commitments at all is opened at that roster place as of Monday 31 August 2026, at a record place
  where nothing has been kept; "Gym" is then stopped at that roster place by something else, as of
  Sunday 30 August 2026; and the day screen is returned to
- **THEN** its day view holds one row, named "Journaling"

#### Scenario: a day screen returned to goes on showing the day it was showing

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; it
  is moved to the day before; and it is returned to
- **THEN** it says the day it is showing is "Sunday 30 August 2026"
- **AND** its day view holds one row, named "Journaling"

#### Scenario: a day screen returned to keeps the today it was handed

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; and
  it is returned to
- **THEN** it says the day it is showing is "Today · Monday 31 August 2026"

#### Scenario: a day screen returned to does not read its record again

- **WHEN** a run of bytes that is not a record store is written at a record place; a day screen of
  a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is opened as of Monday 31 August 2026 at that record place and at a roster place
  where nothing has been kept; what is at the record place is removed, so that nothing has been kept
  there and the place reads clean; and the day screen is returned to
- **THEN** it still says it is keeping no record
- **AND** its day view holds one row, named "Journaling"

#### Scenario: a day screen that could not read its roster starts keeping one when it is returned to and the roster can be read

- **WHEN** a run of bytes that is not a roster store is written at a roster place; a day screen of
  no commitments at all is opened at that place as of Monday 31 August 2026, at a record place where
  nothing has been kept; what is at the roster place is replaced with a roster store holding a
  commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1 January 2026;
  and the day screen is returned to
- **THEN** it says it is keeping a roster
- **AND** its day view holds one row, named "Journaling"

#### Scenario: a day screen returned to on a roster that holds nothing takes the commitments it was handed on again

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Monday 31 August 2026 at a roster place where nothing
  has been kept and a record place where nothing has been kept; everything kept at the roster place
  is removed; and the day screen is returned to
- **THEN** a roster store opened afterwards at that place holds one commitment, named "Journaling"
- **AND** its day view holds one row, named "Journaling"

#### Scenario: a day screen returned to goes on telling what it was telling on a row

- **WHEN** a day screen of no commitments at all is opened as of Monday 31 August 2026 at a roster
  place holding a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and at a record place where nothing can be written — a path beneath an existing
  ordinary file; its one row is ticked and refused; and the day screen is returned to
- **THEN** it still tells, on that row, that the change could not be kept
- **AND** its day view holds one row, named "Journaling"


#### Scenario: a commitment renamed at a day screen's places is drawn under its new name and still kept when the screen is returned to

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 31 August 2026 is kept at a
  record place; a day screen of no commitments at all is opened at that roster place and that record
  place as of Monday 31 August 2026; that commitment is then changed at both places by something else
  to the name "Gym 🏋️"; and the day screen is returned to
- **THEN** its day view holds one row, named "Gym 🏋️"
- **AND** that row says its commitment was kept

#### Scenario: what a day screen tells on a row stands when the screen is returned to and reads its record again

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place that cannot be written; the row
  for "Gym" is tapped and the tick is refused; and the day screen is returned to
- **THEN** it still tells on that row that the change could not be kept
