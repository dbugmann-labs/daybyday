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

**The order the roster answers in is the one its owner set, and a day screen inherits it without
doing anything.** Moving a commitment is a change made on the commitments screen, kept at the roster
place, and read by a day screen the next time it asks its roster — which is every day view it forms.
This requirement gains no rule for it, deliberately: the order was already the roster's to give and
already this screen's to draw untouched, and the scenario below exists to make that a fact rather
than a claim.

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

#### Scenario: a day screen draws its rows in the order its roster was moved into

- **WHEN** a commitment named "Journaling", then one named "Supplements and habits", then one named
  "Gym", all on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a
  roster place; "Gym" is moved there to the offset 0; and a day screen of no commitments at all is
  opened at that roster place as of Monday 31 August 2026, at a record place where nothing has been
  kept
- **THEN** its day view holds three rows, named "Gym", "Journaling" and then "Supplements and habits"
- **AND** it says it is keeping a roster
