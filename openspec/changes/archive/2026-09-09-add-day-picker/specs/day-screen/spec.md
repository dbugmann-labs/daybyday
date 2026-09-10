## ADDED Requirements

### Requirement: A day screen says the reach of its day picker

A day screen SHALL say the reach of its day picker, as one answer carrying exactly two days: the day
the picker opens on, and the earliest day it reaches.

**The day it opens on SHALL be the day the screen is showing**, whatever put the screen on that day
— the day it was opened on, a move either way, a way back to today, a new today handed to it, or a
day picked on the picker itself.

**The earliest day it reaches SHALL be the earlier of two days**: the earliest day anything on the
screen's roster is kept from, and the day the screen is showing. Where the roster answers no such
day, **the today the screen was last handed** stands in its place, and the same comparison against
the day being shown is made against it. The earliest day it reaches SHALL therefore never be later
than the day it opens on — a picker that opened on a day it said it could not reach would be
incoherent, and a person who stepped below the floor with the chevrons can always get back to where
they were.

The earliest day anything on the roster is kept from SHALL be the `commitment` capability's answer,
asked of the roster this screen last read, and it MUST NOT be recomputed here. That answer counts
every commitment the roster holds, the ones it has stopped keeping and the ones it has removed
included; a day screen adds nothing to it and takes nothing away, and in particular MUST NOT narrow
it to the commitments due on some day, to the commitments the roster is still keeping, or to the
commitments the day view holds rows for.

**The reach SHALL bound the day picker and never the screen.** A day screen goes on stepping as far
back and as far forward as the calendar goes, adding no bound of its own, exactly as *A day screen
moves the day it is showing one calendar day either way* already requires; that requirement is
unchanged by this one and MUST NOT be read as narrowed by it. What is bounded is the one control:
what a person is given to pick, and — because a picker whose bound the screen would not honour is
not a bound at all — what showing a picked day accepts.

**Nothing SHALL be answered about whether the day picker is offered.** Forward the picker reaches to
the last supported date, so there is always another day to pick and the answer names no far end; a
*whether it is offered* answer would be yes on every day anyone will ever look at, which is the
ground `add-screen-navigation` (#93) refused an answer about the chevrons on and
`add-offered-today-control` (#174) restated. What is drawn for the picker is the caller's; that
there is always something to draw is this capability's.

**The answer SHALL be one answer about the control.** It gives out the day being shown as the day
the picker opens on, because a picker must open on some day and which day that is is a fact about
the control. It MUST NOT give out the today the screen was last handed, under any name, and nothing
about this answer SHALL make that today readable: a caller that must know whether the way back to
today is offered asks *A day screen says whether it offers the way back to today* and nothing else,
and MUST NOT infer it from the day this answer opens on.

The answer SHALL take no day from the caller, and this capability MUST NOT read a clock to find one.
The today it falls back on SHALL be the today the screen was last handed — the day it was opened on,
or the day the app was last shown on — so a screen answers the same way for ever until something
moves the day it is showing, hands it a new today, or changes the roster it holds.

**The answer SHALL be read again whenever the roster is, and reading it SHALL move no day.** The
roster is read when the screen is opened, when the app is shown again and when the screen is
returned to; the reach follows what is then held. Where the earliest day it reaches rises — a roster
that could be read and then could not, a roster whose earliest commitment is not in the one now at
the place — the screen SHALL go on showing the day it was showing, and the reach SHALL simply reach
less far. A screen that moved the person off the day they were looking at because a control's bound
had changed would be worse than a control that reaches shorter.

The answer SHALL be about the roster the screen holds and the day it is showing, and about nothing
else. It MUST NOT depend on what the screen says about its record, on whether its day view holds any
rows, or on what is being told on a row. A day screen that cannot read its roster holds a roster
holding nothing and is answered by the rule above rather than by a rule of its own.

#### Scenario: a day screen's day picker opens on the day it is showing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is not moved
- **THEN** its day picker opens on Monday 31 August 2026
- **AND** moved to the day before, its day picker opens on Sunday 30 August 2026
- **AND** moved from there to the day after twice, its day picker opens on Tuesday 1 September 2026

#### Scenario: a day screen's day picker reaches back to the earliest day anything on its roster is kept from

- **WHEN** a commitment named "Gym" kept from 1 March 2026, one named "Run" kept from 1 January
  2026 and one named "Journaling" kept from 1 February 2026, all on a schedule listing all seven
  weekdays, are taken on at a roster place; and a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept
- **THEN** its day picker reaches back to 1 January 2026
- **AND** its day picker opens on Monday 31 August 2026

#### Scenario: a day screen's day picker reaches back past a commitment its roster has stopped keeping

- **WHEN** a commitment named "Gym" kept from 1 January 2026 and one named "Run" kept from 1 March
  2026, both on a schedule listing all seven weekdays, are taken on at a roster place; "Gym" is
  stopped there as of 31 January 2026; and a day screen of no commitments at all is opened at that
  roster place as of Monday 31 August 2026, at a record place where nothing has been kept
- **THEN** its day picker reaches back to 1 January 2026
- **AND** its day view holds one row, named "Run"

#### Scenario: a day screen's day picker reaches back past a commitment its roster has removed

- **WHEN** a commitment named "Gym" kept from 1 January 2026 and one named "Run" kept from 1 March
  2026, both on a schedule listing all seven weekdays, are taken on at a roster place; "Gym" is
  removed there as of 31 January 2026; and a day screen of no commitments at all is opened at that
  roster place as of Monday 31 August 2026, at a record place where nothing has been kept
- **THEN** its day picker reaches back to 1 January 2026
- **AND** its day view holds one row, named "Run"

#### Scenario: a day screen's day picker reaches back to the day it is showing where that is the earlier of the two

- **WHEN** a day screen is opened as of Thursday 1 January 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 June 2026
- **THEN** its day picker opens on Thursday 1 January 2026 and reaches back to Thursday 1 January
  2026
- **AND** moved to the day before, its day picker opens on Wednesday 31 December 2025 and reaches
  back to Wednesday 31 December 2025

#### Scenario: a day screen that cannot read its roster reaches back to the today it was handed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a run of
  bytes that is not what a roster is written as, at a record place where nothing has been kept, of
  a commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1 January 2026
- **THEN** it says it is not keeping a roster
- **AND** its day picker opens on Monday 31 August 2026 and reaches back to Monday 31 August 2026
- **AND** moved to the day before, its day picker reaches back to Sunday 30 August 2026

#### Scenario: a day screen that takes on the commitments it was handed reaches back to the earliest of those

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding nothing at
  all, at a record place where nothing has been kept, of a commitment named "Gym" kept from
  1 March 2026 and one named "Journaling" kept from 1 February 2026, both on a schedule listing all
  seven weekdays
- **THEN** its day picker reaches back to 1 February 2026, those two having been taken on
- **AND** a second day screen opened as of that same day, at a roster place of its own also holding
  nothing at all and handed no commitments at all, reaches back to Monday 31 August 2026

#### Scenario: a day screen whose roster stops being readable goes on showing its day and reaches back to it

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2020, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; it
  is moved to the day before; that roster place is then made to hold a run of bytes that is not
  what a roster is written as; and the screen is returned to
- **THEN** it says the day it is showing is "Sunday 30 August 2026"
- **AND** its day picker opens on Sunday 30 August 2026 and reaches back to Sunday 30 August 2026
- **AND** before it was returned to, its day picker reached back to 1 January 2020

#### Scenario: a day screen that cannot read its record says the reach of its day picker like any other

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place holding a run of
  bytes that is not what a record is written as, of a commitment named "Journaling" on a schedule
  listing all seven weekdays, kept from 1 January 2026
- **THEN** it says it is not keeping a record
- **AND** its day picker opens on Monday 31 August 2026 and reaches back to 1 January 2026

#### Scenario: a day screen's day picker reaches back to the first supported date and opens on the last

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583
- **THEN** its day picker reaches back to 1 January 1583
- **AND** a second day screen opened the same way as of Friday 31 December 9999 opens on Friday
  31 December 9999 and reaches back to 1 January 1583

### Requirement: A day screen shows a day picked on its day picker

A day screen SHALL show the calendar date it is given to show, where that date is not earlier than
the earliest day its day picker reaches, and SHALL leave the screen exactly as it was where it is
earlier. The earliest day the picker reaches SHALL itself be shown when it is given: the bound
includes its own day.

**A day the reach does not cover MUST NOT be clamped**, to the earliest day it reaches or to any
other. Nothing moves, nothing is formed again and nothing is said about it — the same silence *A
move with nowhere to go leaves a day screen exactly as it was* already gives at the calendar's two
ends. Clamping would put the screen on a day nobody asked for, and a caller that must know what may
be picked asks the reach.

What showing a picked day gives SHALL be what a move gives: the day view the screen holds, formed
for the day landed on, handed the commitments its roster had not stopped keeping on that day and the
record the screen already holds. It SHALL NOT read the record or the roster again, for the reason a
move does not — being shown and being returned to are the moments a day screen learns what is at
either place, and picking a day is neither. It SHALL therefore leave what the screen says about its
record and about its roster exactly as it was, and a day screen that is not keeping one of them
SHALL show a picked day like any other and go on saying so.

**The today SHALL NOT move.** A pick changes the day being shown and nothing else, so the day the
screen was handed when the app was last shown is the same day after any number of picks, and every
question a day screen asks as of that today SHALL still be asked as of it — which tick a row offers,
whether the day it says is said as today, and whether the way back to today is offered. That last
answer SHALL follow the day picked, exactly as it follows a move.

**A pick that leaves the day being shown unchanged SHALL change nothing at all.** That is the day
already being shown, and a day the reach does not cover. What a day screen is telling on a row
SHALL stand across either: *What a day screen tells on a row lasts until the app is shown again, a
change is kept, or the day it is showing changes* keys on the day being shown **changing** and never
on the act made, and neither of these changes it. A pick that does change the day ends it, under
that same requirement and not under a rule added here.

Showing a picked day SHALL be asked of the screen and handed exactly one thing, the day to show. A
day screen holds a roster, a record and a today already; a pick that took any of them from a caller
would let two callers put one screen in two states. The day given is a calendar date, so it already
names a day inside the supported years and needs no validity rule of its own here.

#### Scenario: a day screen shows a day picked between the earliest day its picker reaches and the day it was showing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and one
  named "Journaling" on a schedule listing all seven weekdays, in that order and both kept from
  1 January 2026; and Monday 15 June 2026 is picked
- **THEN** its day view is the same day view as one formed directly of those two commitments, in
  that order, on Monday 15 June 2026, from a history that has taken no tick
- **AND** it says the day is "Monday 15 June 2026"
- **AND** its day picker opens on Monday 15 June 2026

#### Scenario: a day screen shows a day picked after the today it was handed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; and Friday 25 December 2026 is picked
- **THEN** it says the day is "Friday 25 December 2026"
- **AND** a second day screen opened the same way, on which Friday 31 December 9999 is picked, says
  the day is "Friday 31 December 9999"

#### Scenario: a day screen shows the earliest day its day picker reaches when that day is picked

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; and Thursday 1 January 2026, the earliest day its day picker reaches, is picked
- **THEN** it says the day is "Thursday 1 January 2026"
- **AND** its day picker opens on Thursday 1 January 2026 and reaches back to Thursday 1 January
  2026

#### Scenario: a day screen is left exactly as it was by a day picked earlier than its day picker reaches

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; and Wednesday 31 December 2025 is picked
- **THEN** it says the day is "Today · Monday 31 August 2026"
- **AND** its day view is the same day view as the one it held before that day was picked, and is
  not the day view of Thursday 1 January 2026
- **AND** its day picker still opens on Monday 31 August 2026 and reaches back to 1 January 2026

#### Scenario: a day screen picking the day it is already showing changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place that can be read
  from but not written to and where nothing has been kept, of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked
  and refused; and Monday 31 August 2026 is picked
- **THEN** it says the day is "Today · Monday 31 August 2026"
- **AND** it is still telling on that row that the change could not be kept
- **AND** its day view is the same day view as the one it held before that day was picked

#### Scenario: a day screen picking a day draws the commitments its roster had not stopped keeping on that day

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all
  seven weekdays and both kept from 1 January 2026, are taken on at a roster place in that order;
  "Gym" is stopped there as of Monday 15 June 2026; and a day screen of no commitments at all is
  opened at that roster place as of Monday 31 August 2026, at a record place where nothing has been
  kept
- **THEN** picking Wednesday 10 June 2026 gives a day view holding two rows, named "Gym" and then
  "Journaling"
- **AND** picking Saturday 20 June 2026 from there gives a day view holding one row, named
  "Journaling"

#### Scenario: picking a day on a day screen does not read its roster or its record again

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; a
  commitment named "Gym" on that same schedule and kept from that same day is then taken on at that
  roster place by something else, and a tick for "Journaling" on Monday 15 June 2026 is kept at
  that record place by something else; and Monday 15 June 2026 is picked
- **THEN** its day view holds one row, named "Journaling"
- **AND** that row says the commitment is not kept on Monday 15 June 2026
- **AND** it says it is keeping a record and a roster, exactly as it did before that day was picked

#### Scenario: picking a day on a day screen does not change the today it was handed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; and Monday 15 June 2026 is picked
- **THEN** it says the day is "Monday 15 June 2026", without "Today" in front of it
- **AND** sent back to today, it says the day is "Today · Monday 31 August 2026"

#### Scenario: a day screen stops telling what it was telling on a row when a picked day changes the day it is showing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place that can be read
  from but not written to and where nothing has been kept, of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked
  and refused; and Monday 15 June 2026 is picked
- **THEN** it tells nothing on any row
- **AND** it says the day is "Monday 15 June 2026"

#### Scenario: a day screen goes on telling what it was telling on a row when a picked day is earlier than its day picker reaches

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place that can be read
  from but not written to and where nothing has been kept, of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked
  and refused; and Wednesday 31 December 2025 is picked
- **THEN** it is still telling on that row that the change could not be kept
- **AND** it says the day is "Today · Monday 31 August 2026"

#### Scenario: a day screen offers the way back to today once a day other than that today is picked

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and Monday 15 June 2026 is picked
- **THEN** it offers the way back to today
- **AND** picking Monday 31 August 2026 from there, it offers no way back to today
- **AND** a screen on which Wednesday 31 December 2025 is picked instead offers no way back to
  today, that day never having been shown
