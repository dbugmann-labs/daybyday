## ADDED Requirements

### Requirement: A day screen tells on the row that was tapped that a change could not be kept

Where a change a row offers cannot be kept, a day screen SHALL tell it **on that row** — the row
that was tapped — as well as refusing the change to the caller. The two are not alternatives and
neither replaces the other: the refusal reaching the caller is what a test asserts on and what stops
a shell drawn later from swallowing the failure a second time, and what is told on the row is what a
person reads. A day screen that only threw would be silent to the person; one that only told the row
would be silent to everything else.

It SHALL tell every refusal the same way, and SHALL name no cause. It MUST NOT tell which of making
the tick and taking it back was asked for, and it MUST NOT tell why the place would not take the
change. A tick refused on a record that could be read leaves a person exactly one thing to do
whatever the reason was — try again, and if it keeps failing, look at the device — so two messages
would buy a person nothing they could act on, which is the same test this capability already applies
to a record that could not be opened.

It SHALL tell it of **at most one row at a time**, and that row SHALL be the row tapped last. A
second refused tap SHALL move what is told onto its own row and SHALL leave nothing on the first:
one refusal is one event, two notices say the same thing twice, and the tap the person is waiting on
an answer for is the one they just made.

The row it is told of SHALL be named by what a row is — a commitment's line on a date — and this
capability SHALL give a row no identity beyond that. Where a day view holds two rows that are the
same row, both are told of. That is inherited rather than chosen here: two rows are the same row
only when two commitments are alike in name, in schedule and in the day they are kept from, and
giving a row an identity of its own would change what a row is throughout this capability.

Telling it MUST NOT change what a day screen says about **keeping a record**. A refused change is
one change refused; whether a screen is keeping a record is about whether the store opened at its
place, and it is formed again only when the app is shown. A screen that opened its record goes on
saying it is keeping one however many changes it refuses, so that the screen never guesses which
condition a failed write proves.

What the day view holds is unaffected, which is the existing requirement on making and taking back a
tick and is not restated here.

#### Scenario: a refused tick is told on the row that was tapped

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
- **THEN** ticking is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept

#### Scenario: a refused tick is told on the row that was tapped and on no other row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, a commitment named "Journaling" on a schedule listing all
  seven weekdays and a commitment named "Supplements and habits" on that same schedule, in that
  order and all kept from 1 January 2026, and the second of its three rows is ticked
- **THEN** the day screen tells, on the second row, that the change could not be kept
- **AND** it tells nothing on the first row and nothing on the third

#### Scenario: a refused take-back is told on the row that was tapped

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from but
  not written to and that holds a record in which a commitment named "Gym" on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, is already kept on that date, and its
  one row — which says the commitment is kept — is ticked
- **THEN** taking the tick back is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** its day view still says the commitment is kept on that date

#### Scenario: a second refused tap is told on the row tapped last and no longer on the first

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday and a commitment named "Journaling" on a schedule listing
  all seven weekdays, in that order and both kept from 1 January 2026; its first row is ticked; and
  its second row is then ticked
- **THEN** both taps are refused with an error
- **AND** the day screen tells, on the second row, that the change could not be kept
- **AND** it tells nothing on the first row

#### Scenario: a refused change does not change what a day screen says about keeping a record

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked twice
- **THEN** the day screen says it is keeping a record
- **AND** it tells, on that row, that the change could not be kept

### Requirement: What a day screen tells on a row lasts until the app is shown again, a change is kept, or the day it is showing changes

A day screen SHALL go on telling it, on the same row, until one of exactly three things happens, and
SHALL then tell nothing on any row. Nothing else SHALL end it. Time passing in particular SHALL NOT,
because this capability reads no clock.

**The app being shown again** ends it. That is inherited rather than added: nothing of a day screen
but the commitments it was handed, the two places it keeps its record and its roster at and the day
it is showing survives being shown, and this is not one of them. It SHALL end whether or not the
record can then be read, because being shown forms what a screen says again from what is at the
place rather than carrying anything over — a screen that is then not keeping a record says that
instead, and says more than a row ever could.

**A change reaching the record's place** ends it, on whichever row that change was made. A tick that
lands and a take-back that lands both count: what is being told is that the place would not take
your change, and either one landing is proof to the contrary. One rule rather than two, because a
person cannot act on the difference. A change that does not reach the place SHALL NOT end it — a
second refusal moves it rather than ending it, and a tap that changes nothing at all changes this
nothing either.

**The day the screen is showing changing** ends it. What is told is about a tap on a row of the day
you were on, and a day you have moved away from has no row to say it under; carrying it forward
would put a message under a commitment that refused nothing. The rule SHALL be the day being shown
**changing** and never the gesture that was made. A move with nowhere to go — the day before the
first supported date, the day after the last — and going back to today from a screen already showing
today both leave a day screen exactly as it was, which is already this capability's answer, and what
it is telling is part of how it was.

#### Scenario: what a day screen tells on a row ends when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked; and the
  app is then shown again as of that same day
- **THEN** the day screen tells nothing on any row
- **AND** its one row still says the commitment is not kept on that date

#### Scenario: what a day screen tells on a row ends when the app is shown again where the record then cannot be read

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked; that
  place is then made to hold a run of bytes that is not what a record is written as; and the app is
  shown again as of that same day
- **THEN** the day screen says it is not keeping a record
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when the same change is made again and is kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from but
  not written to and where nothing has been kept, of a commitment named "Gym" on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked and refused; the
  place is then made writable; and the row the screen holds is ticked again
- **THEN** the day screen's day view says the commitment is kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when a change is kept on another row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from but
  not written to and where nothing has been kept, of a commitment named "Gym" on a schedule listing
  Monday, Wednesday and Saturday and a commitment named "Journaling" on a schedule listing all seven
  weekdays, in that order and both kept from 1 January 2026; its first row is ticked and refused;
  the place is then made writable; and its second row is ticked
- **THEN** the day screen's day view says "Journaling" is kept on that date and "Gym" is not
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when a take-back is kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both
  kept from 1 January 2026; its second row is ticked and kept; the place is then made unwritable;
  its first row is ticked and refused; the place is made writable again; and the row for
  "Journaling" is ticked once more
- **THEN** the day screen's day view says "Journaling" is not kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when the day screen is moved to the day before

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; its one row is ticked; and it is
  then moved to the day before
- **THEN** the day screen tells nothing on any row
- **AND** it says "Sunday 30 August 2026"

#### Scenario: what a day screen tells on a row ends when the day screen is moved to the day after

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; its one row is ticked; and it is
  then moved to the day after
- **THEN** the day screen tells nothing on any row
- **AND** it says "Tuesday 1 September 2026"

#### Scenario: what a day screen tells on a row ends when the day screen is sent back to today from another day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; it is moved to the day before; its
  one row is ticked; and it is then sent back to today
- **THEN** the day screen tells nothing on any row
- **AND** it says "Today · Monday 31 August 2026"

#### Scenario: what a day screen tells on a row stands when a move has nowhere to go

- **WHEN** a day screen is opened as of Saturday 1 January 1583 and another as of Friday
  31 December 9999, each at its own place where nothing can be written — a path beneath an existing
  ordinary file — of a commitment named "Journaling" on a schedule listing all seven weekdays, kept
  from 1 January 1583; each screen's one row is ticked; and the first is then moved to the day
  before and the second to the day after
- **THEN** each day screen still tells, on the row that was ticked on it, that the change could not
  be kept
- **AND** the first says "Today · Saturday 1 January 1583" and the second says "Today · Friday
  31 December 9999"

#### Scenario: what a day screen tells on a row stands when a day screen showing today is sent back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; its one row is ticked; and it is
  then sent back to today without having been moved
- **THEN** the day screen still tells, on that row, that the change could not be kept
- **AND** it says "Today · Monday 31 August 2026"

### Requirement: A day screen tells nothing on a row where there was no tick to refuse

A tap that never reaches the record's place is not a refused change. A day screen SHALL tell nothing
on the row for such a tap, and SHALL NOT end what it is already telling on another row: there is no
refusal to report and nothing has been proved about the place either way.

A tap on a day screen that is **not keeping a record** SHALL be one of them, whatever the reason the
store would not open. Such a screen already says it is keeping no record, and that says more than a
per-row message would and is what a person can act on; the two would share the same end — being
shown again — and would clear together, so the row would only ever repeat it.

A tap on a row **for a day that has not arrived** SHALL be another. Such a row offers no tick, asked
as of the today the screen was handed, so there is no change to refuse and nothing was asked of the
place. What is told on a row means a change did not reach the place, and here there was no change.
The honest answer to a day that has not arrived is a row that does not invite the tap at all, and
that is not this capability's answer here.

A tap on a **row the day screen's day view does not hold** SHALL be the third. Such a row already
changes nothing at all, and telling something about it would be a change.

#### Scenario: a tap on a day screen that is not keeping a record is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
- **THEN** the day screen tells nothing on any row
- **AND** it says it is not keeping a record

#### Scenario: a tap on a day screen holding a record from a later version is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a record written
  in a form one later than the form this app writes, holding no ticks, of a commitment named "Gym"
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is
  ticked
- **THEN** the day screen tells nothing on any row
- **AND** it says the record was written by a later version of DayByDay

#### Scenario: a tap on a row for a day that has not arrived is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; it is moved to the day after; and
  its one row is ticked
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on Tuesday 1 September 2026

#### Scenario: a tap on a row a day screen's day view does not hold is told nothing on the row

- **WHEN** two day screens of a commitment named "Journaling" on a schedule listing all seven
  weekdays, kept from 1 January 2026, are opened at one place where nothing can be written — a path
  beneath an existing ordinary file — the first as of Monday 31 August 2026 and the second as of
  Wednesday 2 September 2026, and the second screen's row is ticked on the first screen
- **THEN** the first day screen tells nothing on any row

#### Scenario: a tap on a row a day screen's day view does not hold does not end what is already told

- **WHEN** two day screens of a commitment named "Journaling" on a schedule listing all seven
  weekdays, kept from 1 January 2026, are opened at one place where nothing can be written — a path
  beneath an existing ordinary file — the first as of Monday 31 August 2026 and the second as of
  Wednesday 2 September 2026; the first screen's own row is ticked; and the second screen's row is
  then ticked on the first screen
- **THEN** the first day screen still tells, on its own row, that the change could not be kept
