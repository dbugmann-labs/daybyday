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

**A commitment the roster has removed has exactly the same rows.** It is answered about a date as a
stopped commitment is, so it has a row on every day up to and including the day it was kept until
and on none after it, and a day screen SHALL NOT tell the two apart in any way — not in whether the
row is drawn, not in what the row says, and not in what the row offers. Getting rid of a commitment
for good is a statement about the days ahead, and a past day that lost its rows because a person
tidied their list is the failure this product exists to prevent. Where the difference between
stopped and removed lives is the commitments screen, which lists a removed commitment nowhere.

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

#### Scenario: a day screen draws a removed commitment on the day it was kept until and not on the day after it

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place, ticked on Sunday 30 August 2026, and removed as of
  that same day; and a day screen of no commitments at all is opened at that roster place as of
  Monday 31 August 2026, at the record place that tick was kept at
- **THEN** the day view it held when it was opened holds no rows, Monday 31 August 2026 being after
  the day the commitment was kept until
- **AND** after it is moved to the day before, its day view holds one row, named "Journaling", saying
  the commitment is kept on that date

### Requirement: A day screen takes on the commitments it was handed when its roster holds nothing at all

A day screen SHALL be handed some commitments, and SHALL take them on — in the order it was handed
them — exactly when the roster it has just read holds nothing at all. It SHALL keep them at its
roster place before drawing from them, and the day view it then holds SHALL be of the roster as it
then stands rather than of the list it was handed.

A roster holding anything at all SHALL be left exactly as it is, and the commitments handed in SHALL
NOT be taken on a second time. A roster every one of whose commitments has been stopped **or
removed** still holds them, so it is not a roster holding nothing and MUST NOT be written over: what
makes this a first launch is that nothing has ever been taken on, not that nothing is being kept
today and not that nothing is being offered today.

That a removal leaves the commitment in the roster is what makes this hold without a marker of its
own. A roster that dropped its entries would read as a roster holding nothing the moment a person
removed the last of them, and day one — the owner's own eight commitments — would be written on top
of a list they had just deliberately emptied, on a phone that has been in use for months. ADR-1027
and ADR-1035 are read together here.

The commitments are the caller's and the moment is the day screen's. A day screen SHALL take on
exactly what it was handed and MUST NOT invent, name, reorder or drop a commitment of its own; and
it SHALL decide when they are taken on — a roster holding nothing at all — rather than leaving that
to whatever draws the screen.

A day screen that could not read its roster SHALL take nothing on, and what is at that place SHALL be
left exactly as it was: a roster that refuses to open is never written over. A day screen that could
read its roster but could not keep what it was handed SHALL hold a roster holding nothing, SHALL hold
no rows, and SHALL say that it is not keeping a roster — nothing it takes on would survive, which is
the one thing a person can act on, and rows drawn for commitments that were never kept are exactly
what this product exists not to show.

#### Scenario: a day screen opened where no roster has been kept takes on the commitments it was handed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place and a record place
  where nothing has been kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday
  and Saturday and a commitment named "Journaling" on a schedule listing all seven weekdays, in that
  order and both kept from 1 January 2026
- **THEN** its day view holds two rows, named "Gym" and then "Journaling"
- **AND** a roster store opened afterwards at that roster place reads back those two commitments, in
  that order

#### Scenario: a day screen opened a second time does not take the commitments on again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place and a record place
  where nothing has been kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday
  and Saturday and a commitment named "Journaling" on a schedule listing all seven weekdays, in that
  order and both kept from 1 January 2026; "Gym" is then stopped at that roster place as of Sunday
  30 August 2026 by something else; and a second day screen of those same two commitments is opened
  at those same two places as of Monday 31 August 2026
- **THEN** the second day screen's day view holds one row, named "Journaling"
- **AND** a roster store opened afterwards at that roster place reads back one commitment and holds
  no second copy of either

#### Scenario: a day screen opened on a roster whose commitments have all been stopped takes nothing on

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and stopped as of Sunday 30 August 2026; and a day
  screen of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  that same day, is opened at that roster place as of Monday 31 August 2026, at a record place where
  nothing has been kept
- **THEN** its day view holds no rows
- **AND** a roster store opened afterwards at that roster place holds a roster that is the same
  roster as one given "Journaling" once and asked to stop keeping it as of Sunday 30 August 2026

#### Scenario: a day screen that cannot read its roster takes nothing on and leaves what is at the place as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a run of
  bytes that is not what a roster is written as, at a record place where nothing has been kept, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026
- **THEN** the content at that roster place is byte-for-byte what it was before the screen was opened
- **AND** its day view holds no rows

#### Scenario: a day screen that could not keep the commitments it was handed says it is not keeping a roster

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place where nothing can be
  written — a path beneath an existing ordinary file — at a record place where nothing has been kept,
  of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1 January
  2026
- **THEN** it says it is not keeping a roster
- **AND** its day view holds no rows
- **AND** it says it is keeping a record

#### Scenario: a day screen shown again on a roster that holds nothing takes the commitments on again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place and a record place
  where nothing has been kept, of a commitment named "Journaling" on a schedule listing all seven
  weekdays, kept from 1 January 2026; what is at its roster place is then replaced by a roster store
  that has been given no commitment; and the app is shown again as of Monday 31 August 2026
- **THEN** its day view holds one row, named "Journaling"
- **AND** a roster store opened afterwards at that roster place reads back that one commitment

#### Scenario: a day screen opened on a roster whose commitments have all been removed takes nothing on

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and removed as of Sunday 30 August 2026; and a day
  screen of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  that same day, is opened at that roster place as of Monday 31 August 2026, at a record place where
  nothing has been kept
- **THEN** its day view holds no rows
- **AND** a roster store opened afterwards at that roster place holds a roster that is the same
  roster as one given "Journaling" once and asked to remove it as of Sunday 30 August 2026
- **AND** "Gym" is not at that roster place
