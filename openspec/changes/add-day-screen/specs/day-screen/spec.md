## ADDED Requirements

### Requirement: A day screen holds the day view of the day it was handed, formed from the record kept at its place

A day screen SHALL be opened from three things: some commitments, the day it is being opened on, and
the place its record is kept at. It SHALL hold the day view of those commitments on that day, formed
from the history held at that place, and SHALL give that day view back whole and unaltered. It adds
nothing to it and takes nothing away: which commitments have a row, in which order, and what each
row says are already this capability's answers about a date, and what is kept at a place is the
`record` capability's answer, so a day screen SHALL hold exactly the day view that would be formed
directly from the same commitments, the same day and that same history.

The day a day screen holds SHALL be given to it and never asked for. This capability MUST NOT read a
clock, MUST NOT consult the present moment, the device's time zone or the locale, so a day screen
opened as of any date the system supports holds that date's day view whatever day it really is, and
two day screens opened as of the same day from the same record hold the same day view for ever.

A day screen SHALL hold that day until the app is shown again, and SHALL be moved onto another day
by nothing else. Time passing MUST NOT move it, and neither MUST a tick made on it: a screen a
person is looking at cannot change day underneath them.

#### Scenario: a day screen opened where nothing has been kept holds the day view of that day with nothing kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Run" on a schedule listing Tuesday, Thursday and Sunday, both kept from 1 January
  2026
- **THEN** its day view holds one row, for "Gym"
- **AND** that row says the commitment is not kept

#### Scenario: a day screen opened where a tick was kept holds a day view that says the commitment is kept

- **WHEN** a tick for a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, on Monday 31 August 2026 is kept at a place, and a day screen of that
  commitment is then opened at that place as of Monday 31 August 2026
- **THEN** its day view's one row says the commitment is kept

#### Scenario: a day screen holds the day it was handed rather than the day it really is

- **WHEN** a day screen is opened as of Monday 3 January 1583, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 1583
- **THEN** its day view is the same day view as one formed directly of that commitment on Monday
  3 January 1583 from a history that has taken no tick
- **AND** a day screen opened the same way as of Monday 27 December 9999 holds the day view of that
  date instead

#### Scenario: a day screen holds the same day view as one formed directly from the same commitments, day and history

- **WHEN** ticks for a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday
  and for a commitment named "Journaling" on a schedule listing all seven weekdays, both kept from
  1 January 2026, on Monday 31 August 2026 are kept at a place; the "Journaling" tick is then taken
  back; and a day screen of those two commitments, in that order, is opened at that place as of
  Monday 31 August 2026
- **THEN** its day view is the same day view as one formed directly of those two commitments, in
  that order, on Monday 31 August 2026, from a history holding exactly the remaining tick

### Requirement: A day screen makes and takes back the tick a row offers, and keeps it before the day view says so

A day screen SHALL make the tick one of its rows offers, and SHALL take that same tick back where
the row already says its commitment is kept. Which of the two a tap means SHALL be read off the row
and MUST NOT be given to the screen: a row saying its commitment is not kept makes the tick, a row
saying it is takes it back, and there is nothing else a tap can mean.

The tick SHALL be the one the row itself offers, asked as of the day the screen holds. The screen
MUST NOT form a tick of its own, MUST NOT choose which tick a row means, and MUST NOT reach past a
row to the commitment underneath it. A row the screen's day view does not hold SHALL change nothing
at all: a row is a commitment's line on a date, so a row from a day this screen is no longer on, or
from another screen entirely, ticks nothing here.

The change SHALL be kept at the screen's place before its day view says so, and the day view SHALL
then be formed again from the record as it stands rather than the day view it held being altered:
what a person reads is always an answer taken from what is kept. A change that could not be kept
SHALL be refused, SHALL be reported to the caller rather than passed over, and SHALL leave the day
view exactly as it was. The day view a person reads MUST NOT be ahead of what is kept at the place,
and a tick that could not be kept MUST NOT be held anywhere in its place.

#### Scenario: ticking a row that says its commitment is not kept makes the day screen say it is kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and its one row is ticked
- **THEN** the day screen's day view says the commitment is kept on that date

#### Scenario: ticking a row that says its commitment is kept takes the tick back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; its one row is ticked; and the row the day screen then holds is ticked again
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** its day view is the same day view as the one the screen held when it was opened

#### Scenario: a tick made on a day screen is held by a day screen opened afterwards at the same place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; its one row is ticked; and a second day screen of the same commitment is then
  opened at the same place as of the same day
- **THEN** the second day screen's day view says the commitment is kept on that date

#### Scenario: a tick taken back on a day screen is not held by a day screen opened afterwards at the same place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; its one row is ticked and the resulting row ticked again; and a second day screen
  of the same commitment is then opened at the same place as of the same day
- **THEN** the second day screen's day view says the commitment is not kept on that date

#### Scenario: ticking one row leaves the other rows of the day as they were

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, a
  commitment named "Journaling" on a schedule listing all seven weekdays and a commitment named
  "Supplements and habits" on that same schedule, in that order and all kept from 1 January 2026,
  and the second of its three rows is ticked
- **THEN** the day screen's day view holds three rows in that same order
- **AND** only the second says its commitment is kept

#### Scenario: a change that cannot be kept is refused and leaves the day view as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
- **THEN** ticking is refused with an error
- **AND** the day screen's day view still says the commitment is not kept on that date
- **AND** a day screen opened afterwards at the same place says the same

#### Scenario: a row the day screen's day view does not hold changes nothing

- **WHEN** two day screens of a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, are opened at one place where nothing has been kept, the first
  as of Monday 31 August 2026 and the second as of Wednesday 2 September 2026, and the second
  screen's row is ticked on the first screen
- **THEN** the first day screen's day view still says the commitment is not kept on Monday 31 August
  2026
- **AND** a day screen opened afterwards at that place as of Wednesday 2 September 2026 says the
  commitment is not kept on that date either

### Requirement: A day screen keeps its record at a place that survives the app being closed

A day screen SHALL name the place it keeps its record at, and MUST NOT leave that choice to whatever
draws it. The place SHALL be one whose contents survive the app being closed, being force-quit and
the device being restarted, and are carried in a backup of the device: it SHALL be inside the
directory the platform reserves for an application's own supporting data — `Application Support` —
within a directory belonging to this app, and it SHALL be one file.

It MUST NOT be the caches directory, which the system empties when it is short of space, and MUST
NOT be the temporary directory, which is not carried in a backup. Either would silently lose the one
thing this product promises to keep, and neither the store nor `record` can refuse a bad place from
where they sit: a store keeps a history at whatever place it is given.

The place SHALL be the same place every time it is asked for, so that the app opened again reads
what the app before it wrote.

#### Scenario: the place a day screen keeps its record is under Application Support, in a directory of the app's own

- **WHEN** the place a day screen keeps its record at is asked for
- **THEN** it is inside the platform's application-support directory
- **AND** it is one file inside a directory of this app's own within it, rather than directly inside
  it

#### Scenario: the place a day screen keeps its record is neither the caches directory nor the temporary directory

- **WHEN** the place a day screen keeps its record at is asked for
- **THEN** it is not inside the platform's caches directory
- **AND** it is not inside the temporary directory

#### Scenario: the place a day screen keeps its record is the same place every time it is asked

- **WHEN** the place a day screen keeps its record at is asked for twice
- **THEN** the two are the same place

### Requirement: A day screen that cannot read its record draws the day and keeps nothing

Opening a day screen at a place holding something that cannot be read as a record SHALL give a day
screen rather than an error. It SHALL hold the day view of its day formed from a history that has
taken no tick, so a person can still see what the day asks of them, and it SHALL say that it is not
keeping a record.

Such a screen SHALL take no tick. A tick made on it MUST NOT be shown as kept, MUST NOT be held in
memory to be kept later, and MUST NOT be kept anywhere else: a screen that shows a tick it cannot
keep is exactly the lost record this product exists to prevent, and one that cannot keep a tick is
better silent than convincing.

It SHALL leave what is at the place exactly as it was — not overwritten, not moved, not emptied —
so that a later version of the app, or the person, can still recover it. That is the `record`
capability's own refusal carried through rather than a second rule, and every way a store can refuse
to open SHALL be treated here in that one way: this capability does not tell them apart.

A day screen that could read its record SHALL say that it is keeping one.

#### Scenario: a day screen opened where the record cannot be read still holds the day view of that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday and a commitment named "Run" on a schedule listing Tuesday, Thursday and
  Sunday, both kept from 1 January 2026
- **THEN** its day view holds one row, for "Gym"
- **AND** that row says the commitment is not kept

#### Scenario: a day screen opened where the record cannot be read says it is not keeping one

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026
- **THEN** it says it is not keeping a record

#### Scenario: a record written in a later form than this app knows makes a day screen that is not keeping one

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a record written
  in a form one later than the form this app writes, holding no ticks, of a commitment named "Gym"
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026
- **THEN** it says it is not keeping a record
- **AND** its day view holds one row, for "Gym", saying the commitment is not kept

#### Scenario: a day screen opened where the record can be read says it is keeping one

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026
- **THEN** it says it is keeping a record
- **AND** a day screen opened at a place where a tick has been kept says the same

#### Scenario: ticking a row on a day screen that is not keeping a record changes nothing and keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
- **THEN** its day view still says the commitment is not kept on that date
- **AND** it still says it is not keeping a record

#### Scenario: a day screen opened where the record cannot be read leaves what is at the place as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
- **THEN** the content at that place is byte-for-byte what it was before the screen was opened

### Requirement: A day screen re-reads its day and its record when the app is shown again

A day screen SHALL be told when the app has been shown — opened from nothing, or brought back in
front of a person — and SHALL be handed the day it has been shown on. On being told, it SHALL take
that day as the day it holds and form its day view again, from the record read again at its place.
This SHALL be the only moment a day screen changes day.

A day screen shown again on a later day SHALL hold that later day's day view, so a morning visit
lands on the morning rather than on the night before. A day screen shown again on the day it is
already on SHALL hold that same day's day view, formed again rather than merely kept.

Reading the record again SHALL be a fresh opening at the place rather than a re-reading of what was
already held, so a change made at that place since SHALL be seen. A day screen that could not read
its record when it opened SHALL say it is keeping one after being shown again where the record can
then be read, and one that could SHALL say it is not after being shown again where it then cannot.
Nothing else of a day screen SHALL survive being shown again: the commitments it was handed and the
place it keeps its record at are all it carries across.

#### Scenario: a day screen shown again on a later day holds that day's day view

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Run" on a schedule listing Tuesday, Thursday and Sunday, both kept from 1 January
  2026, and it is then shown as of Tuesday 1 September 2026
- **THEN** its day view holds one row, for "Run"

#### Scenario: a day screen shown again on the day it is already on holds that day's day view

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and it is then shown as of Monday 31 August 2026
- **THEN** its day view is the same day view as the one it held when it was opened

#### Scenario: a day screen shown again reads the record again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; a tick for that commitment on that date is then kept at that place by something
  else; and the day screen is shown as of Monday 31 August 2026
- **THEN** its day view says the commitment is kept on that date

#### Scenario: a day screen that could not read its record starts keeping one when it is shown again and the record can be read

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026; what is at that place is then replaced by a
  record holding a tick for that commitment on that date; and the day screen is shown as of Monday
  31 August 2026
- **THEN** it says it is keeping a record
- **AND** its day view says the commitment is kept on that date

#### Scenario: a day screen that was keeping a record stops when it is shown again and the record cannot be read

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; what is at that place is then replaced by a run of bytes that is not what a record
  is written as; and the day screen is shown as of Monday 31 August 2026
- **THEN** it says it is not keeping a record
- **AND** its day view says the commitment is not kept on that date

#### Scenario: a day screen does not change day when a tick is made on it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Run" on a schedule listing Tuesday, Thursday and Sunday, both kept from 1 January
  2026, and its one row is ticked
- **THEN** its day view is the same day view as one formed directly of those two commitments, in
  that order, on Monday 31 August 2026, from a history holding exactly that one tick
