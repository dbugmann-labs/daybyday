## ADDED Requirements

### Requirement: A day screen says whether it offers the way back to today

A day screen SHALL say whether it offers the way back to the today it was handed. It SHALL offer the
way back exactly where the day it is showing is not that today, and SHALL offer none where it is.

**The screen answers this, and nothing outside it works it out.** A day screen gives out neither the
today it was handed nor the day it is showing, so nothing holding one can compare them; and what
bounds an offer is what the screen holds the answer to, which is `CONTEXT.md` § *Offered* read
against this one control. A caller that must decide whether to draw the way back asks this and
nothing else.

**The answer SHALL be about the control and not about the position.** It says whether the way back to
today is offered; it MUST NOT be phrased as, or stand in for, whether the screen is showing its
today. The two coincide, and saying the second would make the screen's own today readable through an
answer that exists to hide it — and the next control added anywhere would then be judged by an
answer that was never about it.

The answer SHALL take no day from the caller, and this capability MUST NOT read a clock to find one.
The today it is measured against SHALL be the today the screen was last handed — the day it was
opened on, or the day the app was last shown on — exactly as the way back itself is measured against
it. A screen therefore answers the same way for ever until something moves the day it is showing or
hands it a new today.

The answer SHALL follow the day being shown, and never the number of moves made. A screen moved away
from its today offers the way back; the same screen sent back offers none; and a screen moved to the
day before and then to the day after offers none either, because it is showing its today again. A
move that had nowhere to go MUST NOT change the answer: a screen showing 1 January 1583 as its today
and moved to the day before is showing that today still, and offers no way back.

Being handed a new today SHALL be answered the same way, against the days as they then stand. A
screen showing its today follows onto the new one and goes on offering no way back; a screen showing
another day stays on it and is measured against the new today — so a screen the day has caught up
with, showing the day that has since become today, offers no way back although it was moved.

**Offering none SHALL NOT make the way back a refusal.** Going back to today is unchanged in every
respect by this requirement: it stays something a day screen does from whatever day it is showing,
including from its today, where it leaves the screen showing that today. What is offered governs
what a person is given to tap, and not what this capability accepts — the same split a tap on a row
that offers nothing already has.

The answer SHALL be about the day being shown and the today, and about nothing else. It MUST NOT
depend on what the screen says about its record or its roster, on whether its day view holds any
rows, or on what is being told on a row.

#### Scenario: a day screen showing the today it was handed offers no way back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is not moved
- **THEN** it offers no way back to today
- **AND** it says the day is "Today · Monday 31 August 2026"

#### Scenario: a day screen moved into the past offers the way back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day before
- **THEN** it offers the way back to today
- **AND** a screen moved to the day before three times offers it too

#### Scenario: a day screen moved into the future offers the way back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day after
- **THEN** it offers the way back to today
- **AND** a screen moved to the day after three times offers it too

#### Scenario: a day screen offers no way back to today once it has gone back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before twice; and it is then sent back to today
- **THEN** it offers no way back to today
- **AND** a second screen opened the same way, moved to the day before and then to the day after,
  offers none either

#### Scenario: going back to today on a day screen that offers no way back leaves it showing that today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is sent back to today without having been moved
- **THEN** it says the day is "Today · Monday 31 August 2026"
- **AND** it offers no way back to today, exactly as it did before

#### Scenario: a day screen shown again on a later day offers the way back to today from the day it stayed on

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before; and the app is then shown again as of Wednesday
  2 September 2026
- **THEN** it offers the way back to today
- **AND** sent back, it says the day is "Today · Wednesday 2 September 2026" and offers no way back

#### Scenario: a day screen showing its today when the app is shown again on a later day offers no way back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the app is shown again as of Wednesday 2 September 2026 without it having been
  moved
- **THEN** it offers no way back to today
- **AND** it says the day is "Today · Wednesday 2 September 2026"

#### Scenario: a day screen the day it is showing has caught up with offers no way back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day after; and the app is then shown again as of Tuesday
  1 September 2026
- **THEN** it offers no way back to today
- **AND** it says the day is "Today · Tuesday 1 September 2026"

#### Scenario: a day screen whose move had nowhere to go offers no way back to today

- **WHEN** a day screen is opened as of Saturday 1 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583, and it is moved to the day before; and a second day screen is opened the same way
  as of Friday 31 December 9999 and moved to the day after
- **THEN** neither offers a way back to today
- **AND** the first, moved to the day after, offers the way back

#### Scenario: a day screen that cannot read its record says whether it offers the way back to today like any other

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes that
  is not what a record is written as, of a commitment named "Journaling" on a schedule listing all
  seven weekdays, kept from 1 January 2026, and it is moved to the day before
- **THEN** it offers the way back to today
- **AND** it says it is not keeping a record
- **AND** sent back, it offers no way back to today and still says it is not keeping a record

### Requirement: A row says whether it offers anything at all

A row SHALL say, when asked as of a calendar date, whether it offers anything at all: it SHALL say it
offers something exactly where it offers, as of that day, a tick, a number entry, a note entry or a
total entry, and SHALL say it offers nothing where it offers none of the four.

**The answer SHALL be read off those offers, and MUST NOT be worked out from the date.** The two
coincide today — every kind offers exactly one of the four on a day that has arrived, and none of
them on a day that has not — so this is a choice of which sentence is true rather than of what is
answered now. It is the sentence `CONTEXT.md` § *Offered* carries, *a screen draws as a target only
what it offers*, and a kind added later whose row offers nothing on a day that has arrived is
answered by it without this requirement being reopened.

The take-back a total row offers SHALL NOT widen the answer, and MUST NOT be a fifth thing asked
about. A row offers the take-back only where it offers a total entry, so counting it could change no
answer; a total row whose day holds no addition offers a total entry and therefore offers something,
exactly as one whose day holds several does.

The day the row is asked as of SHALL be given to it, exactly as it is for the five offers before it,
and this capability MUST NOT read it from a clock, MUST NOT consult the present moment, the device's
time zone or the locale, and MUST NOT keep it. A row therefore answers the same way for ever when
asked as of the same day, and a row asked as of two different days answers each on its own.

The answer SHALL say whether there is something to offer and never which thing. A caller that must
know what to draw asks the offer itself, which is what already says what it is; this says only
whether the row is something to tap.

A row that offers nothing SHALL be a row like every other in every other respect. It MUST NOT be
hidden, MUST NOT be drawn as kept, and MUST NOT be given some other act in its place: it says its
name, its rhythm and whether its day is kept, because a day view holds a row for every commitment
due on its date and a row still says what that day will ask of you. That there is nothing to tap is
this capability's answer; what is drawn for such a row is the caller's.

#### Scenario: a row of every kind offers something on a day that has arrived

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" of the tick
  kind, one named "Weight" of the number kind with a range of 40 to 150, one named "Journal" of the
  note kind and one named "Protein" of the total kind with a target of 120, all four on a schedule
  listing Monday, Wednesday and Saturday and all kept from 1 January 2026, from a history that has
  taken no record, and every one of its rows is asked as of that same day
- **THEN** the day view holds four rows, named "Gym", "Weight", "Journal" and then "Protein"
- **AND** every one of them says it offers something

#### Scenario: no row of a day view whose date has not arrived offers anything

- **WHEN** a day view is formed on Wednesday 2 September 2026, of a commitment named "Gym" of the
  tick kind, one named "Weight" of the number kind with a range of 40 to 150, one named "Journal" of
  the note kind and one named "Protein" of the total kind with a target of 120, all four on a
  schedule listing all seven weekdays and all kept from 1 January 2026, from a history that has taken
  no record, and every one of its rows is asked as of Monday 31 August 2026
- **THEN** the day view holds four rows, named "Gym", "Weight", "Journal" and then "Protein"
- **AND** none of them says it offers anything

#### Scenario: a row for a date earlier than the day it is asked as of offers something

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, and its one row is asked as of Saturday 5 September 2026
- **THEN** that row says it offers something
- **AND** it offers the tick for that commitment on Monday 31 August 2026

#### Scenario: a row's answer about offering anything follows the day it is asked as of

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  record, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026, and its one row is asked twice — once as of
  Tuesday 1 September 2026 and once as of Wednesday 2 September 2026
- **THEN** the first asking says the row offers nothing
- **AND** the second says it offers something

#### Scenario: a row offers something whether or not its day says the commitment is kept

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, the first from a history
  that has taken no tick and the second from a history holding a tick for that commitment on that
  date, and each one's row is asked as of that same day
- **THEN** the first row says the commitment is not kept and the second says it is
- **AND** both say they offer something

#### Scenario: a total row whose day holds no addition offers something

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein" of
  the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, the first from a history that has taken no record and the second from a
  history holding an addition of 30 for that commitment on that date, and each one's row is asked as
  of that same day
- **THEN** the first row offers no take-back and the second offers one
- **AND** both say they offer something

#### Scenario: a row offers something on its own date in the first supported year and in the last

- **WHEN** a day view is formed on Monday 3 January 1583, from a history that has taken no record, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  1583, and its one row is asked as of Monday 3 January 1583
- **THEN** that row says it offers something
- **AND** the row of a day view of the same commitment and history on Monday 27 December 9999, asked
  as of Monday 27 December 9999, says it offers something
- **AND** that same row, asked as of Monday 3 January 1583, says it offers nothing

## MODIFIED Requirements

### Requirement: A move with nowhere to go leaves a day screen exactly as it was

A day screen showing 1 January 1583 SHALL be left exactly as it is when moved to the day before, and
a day screen showing 31 December 9999 SHALL be left exactly as it is when moved to the day after.
Those are the first and last dates the system forms, so there is no day view to move to, in the way
there is none for 30 February.

Staying SHALL be the whole of the answer. The screen SHALL go on showing the day it was showing,
holding the day view it was holding and saying what it was saying about its record, and it MUST NOT
report that the move had nowhere to go. A day view moved past either end gives nothing rather than
itself, because a caller holding a value could not otherwise tell it had reached the end of the
calendar; a screen is not a value, and a person looking at one that has not moved can see that it has
not moved.

A day screen SHALL NOT say whether it can move either way, at any date and in either direction. The
two ends are 1 January 1583 and 31 December 9999, so such an answer would be the same on every day
anyone will look at, and what is drawn where a move does nothing is the shell's to decide rather than
this capability's.

**That refusal is about the two ends of the calendar, and it is not a rule that a day screen says
nothing about its controls.** A day screen does say whether it offers the way back to today, and the
difference is the one `CONTEXT.md` § *Offered* draws: what bounds an offer is what the screen holds
the answer to, and an answer about the ends would be the same on every day anyone will look at while
an answer about the today changes with every move. So the sentence above about what is drawn is about
the chevrons and about nothing else — where a chevron has nothing to say for itself the shell decides
alone, and where the way back to today has something to say the shell asks. Neither answer moves the
other, and this requirement gains no rule from the existence of the other.

Being left as it was SHALL be about the calendar and about nothing else. It MUST NOT depend on which
commitments the screen was handed, on what its record holds, on whether its day view has any rows, or
on which day it was handed as today: a screen at either end SHALL move normally in the other
direction, and a screen showing any other date SHALL move both ways.

#### Scenario: a day screen showing the first supported date is unchanged when it is moved to the day before

- **WHEN** a day screen is opened as of Sunday 2 January 1583, at a place where nothing has been kept,
  of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1 January
  1583; it is moved to the day before; and it is moved to the day before again
- **THEN** its day view is the same day view as one formed directly of that commitment on Saturday
  1 January 1583 from a history that has taken no tick
- **AND** it says the day is "Saturday 1 January 1583"
- **AND** it says it is keeping a record

#### Scenario: a day screen showing the last supported date is unchanged when it is moved to the day after

- **WHEN** a day screen is opened as of Thursday 30 December 9999, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583; it is moved to the day after; and it is moved to the day after again
- **THEN** its day view is the same day view as one formed directly of that commitment on Friday
  31 December 9999 from a history that has taken no tick
- **AND** it says the day is "Friday 31 December 9999"
- **AND** it says it is keeping a record

#### Scenario: a day screen at either end of the calendar still moves the other way

- **WHEN** a day screen is opened as of Saturday 1 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583, and a second day screen is opened the same way as of Friday 31 December 9999
- **THEN** the first, moved to the day before and then to the day after, says the day is "Sunday
  2 January 1583"
- **AND** the second, moved to the day after and then to the day before, says the day is "Thursday
  30 December 9999"
