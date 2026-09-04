## ADDED Requirements

### Requirement: A day screen reads its roster again when it is returned to

A day screen SHALL read its roster place again when it is returned to, and SHALL form its day view
again from the roster it then reads, for the day it is showing. Being returned to is the moment a
person comes back to the day screen from somewhere else in the app, and it is the second and last
moment a day screen opens its roster place — the first being when the app is shown.

It exists because the roster place has a second writer. A commitment taken on or stopped on a
commitments screen reaches the same file, and without this a person would define a commitment and
not see it until the app had been backgrounded and brought in front of them again.

**Being returned to is not being shown, and does three things fewer.** It SHALL NOT take a new
today, it SHALL NOT move the day being shown, and it SHALL NOT read the record again. The last of
those matters: what a day screen says about a record it could not read, and anything else whose
lifetime is fixed as *until the app is shown again*, SHALL stand across being returned to. A person
walking to another screen and back has not restarted anything.

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

## MODIFIED Requirements

### Requirement: A day screen draws the commitments its roster had not stopped keeping on the day it is showing

A day screen SHALL hold a roster, read at the place it keeps its roster, and SHALL form every day
view it holds from the commitments that roster had not stopped keeping on the day being shown, in
the order the roster answers with. It MUST NOT hold a list of commitments of its own, and MUST NOT
ask the roster about the today or about any day other than the one it is showing.

Every day view a day screen forms SHALL ask the roster again for the day then being shown: when the
screen is opened, when it is moved, when it is sent back to today, when the app is shown again,
when the screen is returned to, and when a tick is made. A commitment the roster stopped keeping
therefore has a row on every day up to and including the day it was kept until and on none after
it, and a screen moved across that day changes what it draws without anything being read again.

Asking the roster is not reading the roster's place again. The roster a day screen asks is the one
read at that place when the app was last shown or the screen was last returned to, whichever
happened later, together with any change the screen has kept since — so a move and a tick MUST NOT
open the roster's place, exactly as they MUST NOT open the record's.

The day screen adds nothing to the roster's answer and takes nothing away. Which commitments the
roster had not stopped keeping on a date, and the order they come in, are the `commitment`
capability's answers; which of them then has a row, and what that row says, are this capability's
own answers about a date. A day screen MUST NOT judge a commitment's day it is kept from or its
schedule for itself, and MUST NOT reorder, combine or drop what the roster answers with.

#### Scenario: a day screen draws the commitments its roster keeps, in the order they were taken on

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays and then one
  named "Supplements and habits" on that same schedule, both kept from 1 January 2026, are taken on
  at a roster place; and a day screen of no commitments at all is opened at that roster place as of
  Monday 31 August 2026, at a record place where nothing has been kept
- **THEN** its day view holds two rows, named "Journaling" and then "Supplements and habits"
- **AND** it says it is keeping a roster

#### Scenario: a day screen draws a commitment on the day it was kept until and not on the day after it

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and stopped as of Sunday 30 August 2026; a day screen
  of no commitments at all is opened at that roster place as of Monday 31 August 2026, at a record
  place where nothing has been kept; and it is moved to the day before
- **THEN** the day view it held when it was opened holds no rows, Monday 31 August 2026 being after
  the day the commitment was kept until
- **AND** after the move its day view holds one row, named "Journaling"

#### Scenario: moving a day screen does not read its roster again

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from that same
  day, is then taken on at that roster place by something else; and the day screen is moved to the
  day before and then to the day after
- **THEN** its day view holds one row, named "Journaling"
- **AND** it says it is keeping a roster, exactly as it did before the move

#### Scenario: a tick made on a day screen leaves what is kept at its roster place as it was

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Monday 31 August 2026 at a roster place and a record
  place where nothing has been kept, and its one row is ticked
- **THEN** its day view says the commitment is kept on that date
- **AND** the content at its roster place is byte-for-byte what it was immediately after the screen
  was opened
