## ADDED Requirements

### Requirement: A commitments screen says which field of its sheet a refusal it answers is about

Where a commitments screen refuses a commitment defined through it, a change to one, or a restart,
it SHALL hold that refusal with which field of its sheet it is about — at most one, the
last ask's, a restart's included. A name that says nothing SHALL be about the name field. A rhythm
due on no day, and a rhythm number the calendar will not take, SHALL be about the rhythm field. A
range that is not a range SHALL be about the range field, and a target that is not a target about
the target field. Every refusal a restart answers SHALL be about the restart day field but for a
place that could not be written. A commitment already kept, records already kept under what a
change would produce, and a place that could not be written SHALL be about the whole
change and no field.

#### Scenario: a refusal that a name says nothing is about the name field

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it
- **THEN** it is refused as a name that says nothing, about the name field of its sheet
- **AND** the screen holds that refusal against defining a commitment as well

#### Scenario: a refusal that a rhythm is due on no day is about the rhythm field

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Gym" on a weekday-set rhythm of no weekdays at all,
  kept from that same day, is defined through it
- **THEN** it is refused as a rhythm due on no day, about the rhythm field of its sheet

#### Scenario: a refusal that the calendar will not take a rhythm's number is about the rhythm field

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Contact lenses" on an interval rhythm of 0 days,
  kept from that same day, is defined through it
- **THEN** it is refused as a rhythm number the calendar will not take, about the rhythm field of
  its sheet
- **AND** one named "Finances" on a day-of-the-month rhythm of the 32nd is about that field too

#### Scenario: a refusal that a range is not a range is about the range field

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Mood" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the number kind with a lowest of "10" and
  a highest of "1", is defined through it
- **THEN** it is refused as a range that is not a range, about the range field of its sheet

#### Scenario: a refusal that a target is not a target is about the target field

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Water" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the total kind with a target of "0", is
  defined through it
- **THEN** it is refused as a target that is not a target, about the target field of its sheet

#### Scenario: a refusal that a commitment is already kept is about the whole change and no field

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 31 August 2026; and a commitment alike to it in every way is defined through the screen
- **THEN** it is refused as a commitment already kept, about the whole change and about no field of
  its sheet

#### Scenario: a refusal that a roster could not be written is about the whole change and no field

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; what is at that place is then made impossible to write; and a commitment
  named "Journaling" on a weekday-set rhythm of all seven weekdays, kept from that same day, is
  defined through it
- **THEN** it is refused as a place that could not be written, about the whole change and about no
  field of its sheet

#### Scenario: a refusal that records are already kept under the commitment a change would produce is about the whole change

- **WHEN** a commitment named "Gym" and then one named "Run", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a tick on Monday 3 August
  2026 for a commitment named "Gym 🏋️" alike to both in every way but its name is kept at a record
  place; a commitments screen is opened at that roster place and that record place as of Monday
  31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️", on the rhythm and the day
  kept from it already has, under no category
- **THEN** it is refused as records already kept under the commitment the change would produce,
  about the whole change and about no field of its sheet

#### Scenario: a restart refused for the day it was asked from is about the restart day field

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a commitments screen is
  opened at that roster place and at a record place where nothing has been kept as of Monday
  31 August 2026; and "Nails" is restarted through it from Monday 3 August 2026
- **THEN** it is refused as a day before the day it is kept from, about the restart day field of its
  sheet
- **AND** a restart from Tuesday 1 September 2026 and one from Sunday 30 August 2026 are each about
  that field too

#### Scenario: a restart refused as a commitment already kept is about the restart day field

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, and one named "Nails" on a schedule of every 4 days
  starting on Monday 31 August 2026, kept from that day, are taken on at a roster place; the second
  is removed there as of Sunday 30 August 2026; a commitments screen is opened at that roster place
  and at a record place where nothing has been kept as of Monday 31 August 2026; and the first is
  restarted through it from Monday 31 August 2026
- **THEN** it is refused as a commitment already kept, about the restart day field of its sheet

#### Scenario: a restart refused for records already kept or a day recorded on is about the restart day field

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a tick on Monday 31 August
  2026 for a commitment named "Nails" on a schedule of every 4 days starting on that day, kept from
  that day, is kept at a record place; a commitments screen is opened at that roster place and that
  record place as of Monday 31 August 2026; and "Nails" is restarted through it from Monday
  31 August 2026
- **THEN** it is refused as records already kept under the commitment the change would produce,
  about the restart day field of its sheet
- **AND** a screen opened the same way, but with a tick for "Nails" on Sunday 30 August 2026 kept at
  the record place instead and restarted from Saturday 29 August 2026, is refused as a day already
  recorded on that the change would leave not due, about that field too

#### Scenario: a restart refused by a place that could not be written is about the whole change

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Saturday 1 August 2026, is taken on at a roster place; ticks for it on Thursday
  6 August 2026 and Monday 10 August 2026 are kept at a record place; a commitments screen is opened
  at that roster place and that record place as of Monday 31 August 2026; what is at that roster
  place is then made impossible to write; and "Nails" is restarted through it from Sunday 2 August
  2026
- **THEN** it is refused as a place that could not be written, about the whole change and about no
  field of its sheet

### Requirement: A commitments screen says whether a refusal about a rhythm or a day kept from is about one of them or the whole change

A day already recorded on that a change would leave not due, and a change a stopped commitment does
not take, SHALL be about the rhythm field of the screen's sheet where the rhythm asked for differs
from the one the commitment runs on and the day kept from asked for does not, SHALL be about the
day-kept-from field where that day differs and the rhythm does not, and SHALL be about the whole
change and no field where both differ. What the commitment is made of, and not what any earlier ask
carried, SHALL decide which of the two differs.

#### Scenario: a day recorded on that a change would leave not due is about the day-kept-from field

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 June 2026,
  is taken on at a roster place; ticks for it on Monday 3 August 2026 and Wednesday 5 August 2026
  are kept at a record place; a commitments screen is opened at that roster place and that record
  place as of Monday 31 August 2026; and "Gym" is changed through it to the day kept from Tuesday
  4 August 2026, on the name and the rhythm it already has, under no category
- **THEN** it is refused as a day already recorded on that the change would leave not due, about the
  day-kept-from field of its sheet

#### Scenario: a change a stopped commitment does not take is about the rhythm field where only the rhythm differs

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place and stopped there as of Sunday 30 August 2026; a
  commitments screen is opened at that roster place and at a record place where nothing has been
  kept as of Monday 31 August 2026; and "Gym" is changed through it to a weekday-set rhythm of
  Tuesday and Thursday, on the name and the day kept from it already has, under no category
- **THEN** it is refused as a change a stopped commitment does not take, about the rhythm field of
  its sheet

#### Scenario: a change a stopped commitment does not take is about the day-kept-from field where only that day differs

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place and stopped there as of Sunday 30 August 2026; a
  commitments screen is opened at that roster place and at a record place where nothing has been
  kept as of Monday 31 August 2026; and "Gym" is changed through it to the day kept from Monday
  5 January 2026, on the name and the rhythm it already has, under no category
- **THEN** it is refused as a change a stopped commitment does not take, about the day-kept-from
  field of its sheet

#### Scenario: a refusal is about the whole change where both the rhythm and the day kept from differ

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place and stopped there as of Sunday 30 August 2026; a
  commitments screen is opened at that roster place and at a record place where nothing has been
  kept as of Monday 31 August 2026; and "Gym" is changed through it to a weekday-set rhythm of
  Tuesday and Thursday, kept from Monday 5 January 2026, on the name it already has, under no
  category
- **THEN** it is refused as a change a stopped commitment does not take, about the whole change and
  about no field of its sheet

### Requirement: What a commitments screen tells on its sheet lasts until that field is edited, the next ask, the sheet closing or the app being shown again

What a commitments screen holds about a refusal on its sheet SHALL stand until the field it is about
is edited, until the next commitment is defined, changed or restarted through the screen, until the
sheet is closed, or until the app is shown again, and SHALL then be held no longer; nothing else
SHALL end it. A field being edited SHALL end only what is about that field, and what is about the
whole change SHALL be ended by no edit at all. An ask that is kept SHALL end it, an ask that is
refused SHALL replace it, and a call asking for no change at all SHALL leave it exactly as it was.
It SHALL be held beside what the screen holds about a refused change, which SHALL go on lasting as
long as its own requirement says.

#### Scenario: what a commitments screen tells on its sheet ends when the field it is about is edited

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and its sheet's name field is told
  edited
- **THEN** the screen tells nothing on its sheet
- **AND** it still holds a name that says nothing, against defining a commitment

#### Scenario: what a commitments screen tells on its sheet stands when another field is edited

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and its sheet's rhythm field, its
  day-kept-from field, its range field, its target field and its restart day field are each told
  edited
- **THEN** it still tells a name that says nothing, about the name field of its sheet

#### Scenario: what a commitments screen tells at the foot of its sheet stands when a field is edited

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 31 August 2026; a commitment alike to "Gym" in every way is defined through it and refused;
  and its sheet's name field is told edited
- **THEN** it still tells a commitment already kept, about the whole change and about no field of
  its sheet

#### Scenario: what a commitments screen tells on its sheet ends when the sheet is closed

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and its sheet is told closed
- **THEN** the screen tells nothing on its sheet
- **AND** a screen whose sheet is told closed after a commitment alike to "Gym" in every way was
  defined through it and refused tells nothing on its sheet either

#### Scenario: a refused restart replaces what a refused save told on a commitments screen's sheet

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a commitments screen is
  opened at that roster place and at a record place where nothing has been kept as of Monday
  31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven weekdays, kept from
  that same day, is defined through it and refused; and "Nails" is then restarted through it from
  Monday 3 August 2026 and refused
- **THEN** it tells a day before the day it is kept from, about the restart day field of its sheet
- **AND** a screen asked for the two the other way about tells a name that says nothing, about the
  name field of its sheet

#### Scenario: what a commitments screen tells on its sheet ends when an ask is kept

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and a commitment named "Journaling"
  on that same rhythm and kept-from day is then defined through it
- **THEN** "Journaling" is not refused
- **AND** the screen tells nothing on its sheet

#### Scenario: what a commitments screen tells on its sheet ends when the app is shown again

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and the app is then shown again as of
  that same day
- **THEN** the screen tells nothing on its sheet

#### Scenario: what a commitments screen tells on its sheet stands when a call asks for no change at all

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and "Gym" is then changed through it
  to exactly the name, rhythm, day kept from and category it already has
- **THEN** that call refuses nothing
- **AND** the screen still tells a name that says nothing, about the name field of its sheet

### Requirement: A commitments screen offers all seven weekdays for a form's weekday chips

A commitments screen SHALL offer all seven weekdays as the weekday set a form starts its chips from
where they have nothing behind them — a commitment being defined, and a commitment put onto a
weekday-set rhythm it does not already run on. It SHALL offer the same seven whatever its roster
holds, as the kind and the day it offers for a new commitment already do, and SHALL NOT offer a
weekday set a commitment already runs on in their place: what a commitment is made of is what its
own chips start from.

#### Scenario: a commitments screen offers all seven weekdays for a form's weekday chips

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept
- **THEN** the weekdays it offers for a form's chips are all seven
- **AND** a screen opened at a place keeping a commitment on a schedule listing Monday alone offers
  all seven too, and says that commitment is made of Monday alone
