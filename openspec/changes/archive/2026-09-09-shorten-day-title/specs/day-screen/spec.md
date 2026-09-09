## ADDED Requirements

### Requirement: A day view says its day as a weekday

A day view SHALL say the day it is of, in words. That answer is its **day title**, and it is read off
the day view's date and off nothing else: it MUST NOT depend on the rows the day view holds, on
whether any of them says its commitment is kept, or on how many there are, so a day view holding no
rows at all says its day exactly as one holding seven does.

The day title SHALL be the name of the weekday its date falls on, and nothing else: no day of the
month, no month, no year, and no word in front of it. The names SHALL be the three-letter ones —
"Mon", "Tue", "Wed", "Thu", "Fri", "Sat" and "Sun" — which are the names this package already says a
schedule's weekdays in, so that one abbreviation is read across the app rather than two.

**The day title SHALL NOT depend on any other day.** It is asked of a date alone and is handed no
day: a day title is the same words whatever day the question is asked on, whatever day the person is
looking at, and whatever day the device thinks it is. Two dates falling on the same weekday therefore
have the same day title however far apart they are, and that is the whole of what this answer says.
What day of the month, month and year a day view is of is said on a day screen by the day picker
beside its title, in whatever words the device uses for a date, and this capability says none of it.

The names of the weekdays SHALL be this capability's own — the English names, fixed here — and MUST
NOT be taken from the device's language, region, locale or calendar preferences, which is what makes
a day title something a test can state at all. ADR-1022. As throughout this capability, the question
is asked *of a date*: this capability MUST NOT read a clock and MUST NOT consult the present moment
or the device's time zone, so a day title is answered for every date the system supports and a past
day's title reads tomorrow exactly as it does now.

#### Scenario: a day view says its day as the three-letter name of its weekday

- **WHEN** a day view of Monday 31 August 2026 is asked what its day is
- **THEN** it says "Mon"

#### Scenario: every weekday is said by its own name

- **WHEN** the day views of the seven days from Monday 31 August 2026 to Sunday 6 September 2026 are
  each asked what their day is
- **THEN** they say "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" and "Sun"

#### Scenario: two day views whose dates fall on the same weekday say the same day title

- **WHEN** the day views of Monday 31 August 2026, of Monday 15 June 2026 and of Monday 3 January
  1583 are each asked what their day is
- **THEN** each of them says "Mon"

#### Scenario: a day view says its day in the first supported year and in the last

- **WHEN** a day view of Saturday 1 January 1583 is asked what its day is
- **THEN** it says "Sat"
- **AND** a day view of Friday 31 December 9999 says "Fri"

#### Scenario: a day view says the leap day of a leap year

- **WHEN** a day view of Tuesday 29 February 2028 is asked what its day is
- **THEN** it says "Tue"

#### Scenario: a day view holding no rows says its day just the same

- **WHEN** a day view of no commitments at all on Wednesday 2 September 2026 is asked what its day is
- **THEN** it holds no rows
- **AND** it says "Wed"

### Requirement: A day screen says the day it is showing

A day screen SHALL say the day it is showing, and that SHALL be its day view's day title. It adds
nothing to that answer and takes nothing away: the words are the day title requirement's, and a day
screen contributes nothing to them at all.

**The words SHALL follow the day being shown and nothing else.** In particular they MUST NOT follow
the today the screen was handed: a day screen showing its today says exactly what a day screen
showing any other day of that weekday says, and there is no word, mark or spacing that tells the two
apart. What tells them apart is *A day screen says whether it offers the way back to today*, which is
the one answer about that and which this requirement leaves untouched; a caller that must know
whether the day being shown is the today asks that answer, and MUST NOT read it out of these words.
A caller that must know *which* day is being shown asks *A day screen says the reach of its day
picker*, whose day the picker opens on is that day.

A day screen MUST NOT read a clock to say its day, so a screen handed a day says that day's weekday
whatever day it really is, and goes on saying it until it is moved, a day is picked on it, or the app
is shown again. A tick made on it MUST NOT change what it says the day is, and neither MUST time
passing.

A day screen SHALL say its day whether or not it is keeping a record and whether or not it is keeping
a roster. What a date asks of a person needs no record to answer, so a screen that could not read one
says its day exactly as a screen that did.

#### Scenario: a day screen says the day it is showing

- **WHEN** a day screen is opened as of Thursday 3 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026
- **THEN** it says the day is "Thu"

#### Scenario: a day screen says its day the same way whether or not it is showing its today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day before seven times, onto Monday 24 August 2026
- **THEN** it says the day is "Mon", exactly as it did before it was moved
- **AND** it offers the way back to today, where before it was moved it offered none

#### Scenario: a day screen says the day its own day view says

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026
- **THEN** what it says the day is is what its day view says

#### Scenario: a day screen says the day it was handed rather than the day it really is

- **WHEN** a day screen is opened as of Monday 3 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583
- **THEN** it says the day is "Mon"
- **AND** a day screen opened the same way as of Friday 31 December 9999 says the day is "Fri"

#### Scenario: a day screen shown again on a later day says that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the app is then shown again as of Tuesday 1 September 2026
- **THEN** it says the day is "Tue"

#### Scenario: a day screen moved to another day says that day

- **WHEN** a day screen is opened as of Thursday 3 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day before
- **THEN** it says the day is "Wed"
- **AND** moving it to the day before again makes it say the day is "Tue"

#### Scenario: a day screen sent back onto today says that today's weekday

- **WHEN** a day screen is opened as of Thursday 3 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before twice; and it is then sent back to today
- **THEN** it says the day is "Thu"

#### Scenario: a day screen showing a day picked on its day picker says that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and Wednesday 10 June 2026 is picked
- **THEN** it says the day is "Wed"

#### Scenario: a day screen that cannot read its record still says the day

- **WHEN** a day screen is opened as of Monday 31 August 2026, of a commitment named "Journaling" on
  a schedule listing all seven weekdays, kept from 1 January 2026, at a place holding a run of bytes
  that is not a record
- **THEN** it says it is not keeping a record
- **AND** it says the day is "Mon"

#### Scenario: a day screen says the same day after a tick is made on it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and its one row is ticked
- **THEN** it says the day is "Mon", exactly as it did before the tick

## MODIFIED Requirements

### Requirement: A day screen re-reads its day and its record when the app is shown again

A day screen SHALL be told when the app has been shown — opened from nothing, or brought back in
front of a person — and SHALL be handed the day it has been shown on. On being told, it SHALL take
that day as its today, and SHALL form its day view again from the record read again at its place and
the roster read again at its own place. All of those SHALL happen whatever day the screen is showing.

Which day it then shows SHALL depend on where it was. A day screen showing the day it was last handed
as today SHALL show the day it has now been shown on, so that putting the phone down on one evening
and picking it up the next morning lands on the morning rather than on the night before. A day screen
showing any other day SHALL go on showing that day: it is a day the person chose, and time passing is
not a reason to take it away. Being shown again includes every glance at another app and back, and
losing a day half filled in to one is the failure this half of the rule exists to prevent.

That comparison SHALL be made against the today the screen held before it was told, and against
nothing kept for the purpose. A day screen moved away and back onto its today is therefore in exactly
the state a screen that never moved is in, and follows the next day it is shown on; so is one sent
back to today.

A day screen shown again on the day it is already showing SHALL hold that same day's day view, formed
again rather than merely kept.

Reading the record again SHALL be a fresh opening at the place rather than a re-reading of what was
already held, so a change made at that place since SHALL be seen. A day screen that could not read
its record when it opened SHALL say it is keeping one after being shown again where the record can
then be read, and one that could SHALL say it is not after being shown again where it then cannot.
What it says about the record SHALL be formed again from what is at the place as it then stands and
never carried over, the reason included: a screen that said only that the record could not be read
SHALL say the record was written by a later version of DayByDay when that is what is then at the
place.

Reading the roster again SHALL be the same fresh opening at the roster's own place, and what the
screen says about the roster SHALL be formed again from what is there in exactly the same way, the
reason included and nothing carried over. A commitment taken on or stopped at that place since SHALL
therefore be seen, which is what keeps a screen from drawing a list that has moved on without it. A
roster read again that holds nothing at all SHALL have the commitments the screen was handed taken on
into it, as when the screen was opened, because that rule is about the roster that was read and not
about the moment it was read at.

Nothing else of a day screen SHALL survive being shown again: the commitments it was handed, the two
places it keeps its record and its roster at, and the day it is showing are all it carries across.

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

#### Scenario: a day screen shown again where the record is from a later version says so

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; what is at that place is then replaced by a record written in a form one later
  than the form this app writes, holding no ticks; and the day screen is shown as of Monday 31
  August 2026
- **THEN** it says it is not keeping a record
- **AND** it says the record was written by a later version of DayByDay
- **AND** its day view says the commitment is not kept on that date

#### Scenario: a day screen does not change day when a tick is made on it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Run" on a schedule listing Tuesday, Thursday and Sunday, both kept from 1 January
  2026, and its one row is ticked
- **THEN** its day view is the same day view as one formed directly of those two commitments, in
  that order, on Monday 31 August 2026, from a history holding exactly that one tick

#### Scenario: a day screen shown again reads its roster again

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from that same
  day, is then taken on at that roster place by something else; and the day screen is shown as of
  Monday 31 August 2026
- **THEN** its day view holds two rows, named "Journaling" and then "Gym"

#### Scenario: a day screen that could not read its roster starts keeping one when it is shown again and the roster can be read

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a run of
  bytes that is not what a roster is written as, at a record place where nothing has been kept, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026; what is at that roster place is then replaced by a roster that has been given a commitment
  named "Journaling" on a schedule listing all seven weekdays, kept from that same day; and the day
  screen is shown as of Monday 31 August 2026
- **THEN** it says it is keeping a roster
- **AND** its day view holds one row, named "Journaling"

#### Scenario: a day screen that was keeping a roster stops when it is shown again and the roster cannot be read

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place and a record place
  where nothing has been kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026; what is at that roster place is then replaced by a roster
  written in a form one later than the form this app writes, holding no commitments; and the day
  screen is shown as of Monday 31 August 2026
- **THEN** it says it is not keeping a roster
- **AND** it says the roster was written by a later version of DayByDay
- **AND** its day view holds no rows

#### Scenario: a day screen moved off today keeps the day it is showing when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day before; and the app is then shown again as of Wednesday
  2 September 2026
- **THEN** its day view is the same day view as one formed directly of those two commitments, in that
  order, on Sunday 30 August 2026, from a history that has taken no tick
- **AND** its day picker opens on Sunday 30 August 2026, and it offers the way back to today

#### Scenario: a day screen moved away and back onto today moves onto the new day when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day before and then to the day after; and the app is then
  shown again as of Wednesday 2 September 2026
- **THEN** its day view is the same day view as one formed directly of those two commitments, in that
  order, on Wednesday 2 September 2026, from a history that has taken no tick
- **AND** its day picker opens on Wednesday 2 September 2026, and it offers no way back to today

#### Scenario: a day screen sent back to today moves onto the new day when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before three times; it is sent back to today; and the app is
  then shown again as of Wednesday 2 September 2026
- **THEN** its day picker opens on Wednesday 2 September 2026, and it offers no way back to today

#### Scenario: a day screen kept on a day that has since arrived offers the tick it refused before

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day after, onto Tuesday 1 September 2026, and its one row is
  ticked; the app is then shown again as of Tuesday 1 September 2026; and the one row it then holds
  is ticked
- **THEN** the first ticking left the day view saying the commitment is not kept
- **AND** after being shown again its day picker opens on Tuesday 1 September 2026, and it offers
  no way back to today
- **AND** the second ticking makes its day view say the commitment is kept on Tuesday 1 September
  2026

#### Scenario: a day screen moved off today reads its record again when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before; a tick for that commitment on Sunday 30 August 2026
  is then kept at that place by something else; and the app is shown again as of Monday 31 August
  2026
- **THEN** its day view says the commitment is kept on Sunday 30 August 2026
- **AND** its day picker still opens on Sunday 30 August 2026, the screen not having moved

### Requirement: A day screen moves the day it is showing one calendar day either way

A day screen SHALL move the day it is showing to the calendar date one day earlier than it and to the
calendar date one day later. What a move gives SHALL be what moving the day view the screen holds
gives, handed the commitments its roster had not stopped keeping on the day landed on and the record
the screen already holds: the step is exactly one calendar day whatever month, year or leap day it
crosses, and it is taken whether or not anything is due on the day landed on. Neither is restated
here — a day screen's move is this capability's own answer about a day view, asked from the screen.

A move SHALL be asked of the screen and SHALL be handed nothing. A day view holds neither commitments
nor a history and must be given both to move; a day screen holds a roster and a record already, and a
move that took either from a caller would let two callers put one screen on two different days.

The today SHALL NOT move. A move changes the day being shown and nothing else, so the day the screen
was handed when the app was last shown is the same day after any number of moves in either direction.
Every question a day screen asks as of a day SHALL still be asked as of that today — which tick a row
offers, and whether the day it says is said as today — and a move that carried the today with it
would put a screen two days forward in a position to offer a tick for a day that has not arrived.

A day screen SHALL step as far back and as far forward as the calendar goes, and SHALL add no bound
of its own. It MUST NOT stop at the today it holds, at the earliest day a commitment its roster
answers with is kept from, or at any day read off what the record or the roster holds: a day it can
form a day view of is a day it can show. A day before every commitment was kept from holds no rows,
which is an answer rather than a gap; a day that has not arrived holds rows that already refuse their
ticks; and a day on which the roster had stopped keeping everything holds no rows for that reason and
is a day like any other. A bound at any of them would be a second rule stacked on an answer this
capability already gives.

A move SHALL NOT read the record or the roster again. It SHALL form the day view from the record as
the screen last read it — the reading done when the app was shown, together with every change kept on
the screen since — and from the roster as the screen last read it, asked afresh about the day landed
on. Being shown is the moment a day screen learns what is at either place, and a move is not a moment
either can have changed under the person looking at it. A move SHALL therefore leave what the screen
says about its record and about its roster exactly as it was, and a day screen that is not keeping one
of them SHALL move like any other and go on saying so.

#### Scenario: a day screen moved to the day before shows the previous day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026, and it is moved to the day before
- **THEN** its day view is the same day view as one formed directly of those two commitments, in that
  order, on Sunday 30 August 2026, from a history that has taken no tick
- **AND** it holds one row, named "Journaling"

#### Scenario: a day screen moved to the day after shows the next day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026, and it is moved to the day after
- **THEN** its day view is the same day view as one formed directly of those two commitments, in that
  order, on Tuesday 1 September 2026, from a history that has taken no tick
- **AND** it holds one row, named "Journaling"

#### Scenario: moving a day screen does not change the today it was handed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day after
- **THEN** its day picker opens on Tuesday 1 September 2026, and it offers the way back to today
- **AND** moving it to the day before makes its day picker open on Monday 31 August 2026, which is
  the day it was handed, and makes it offer no way back

#### Scenario: a day screen moves onto a day that has not arrived and shows it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day after four times
- **THEN** its day view is the same day view as one formed directly of that commitment on Friday
  4 September 2026 from a history that has taken no tick
- **AND** its day picker opens on Friday 4 September 2026

#### Scenario: a day screen moves back to a day before every commitment was kept from and shows no rows

- **WHEN** a day screen is opened as of Thursday 1 January 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day before
- **THEN** its day view holds no rows, Wednesday 31 December 2025 being before the day the commitment
  is kept from
- **AND** moving it to the day after gives back the day view it held when it was opened

#### Scenario: moving a day screen does not read the record again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; a tick for that commitment on Sunday 30 August 2026 is then kept at that place by
  something else; and the day screen is moved to the day before
- **THEN** its day view says the commitment is not kept on Sunday 30 August 2026
- **AND** it says it is keeping a record, exactly as it did before the move

#### Scenario: moving a day screen away and back shows the day it started from

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026, and it is moved to the day after and then to the day before
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** moving it to the day before and then to the day after gives that same day view again

#### Scenario: a day screen that is not keeping a record moves and goes on saying it is keeping none

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes that
  is not what a record is written as, of a commitment named "Journaling" on a schedule listing all
  seven weekdays, kept from 1 January 2026, and it is moved to the day before
- **THEN** its day view is the same day view as one formed directly of that commitment on Sunday
  30 August 2026 from a history that has taken no tick
- **AND** it says it is not keeping a record

### Requirement: A day screen goes straight back to the today it was handed

A day screen SHALL go back, in one step and from whatever day it is showing, to the today it was
handed. Going back SHALL make the day being shown that today and SHALL form the day view again on it,
from the commitments its roster had not stopped keeping on that today and the record the screen
already holds. It is a move like any other in every respect but the distance: it reads neither the
record nor the roster again, it leaves what the screen says about either of them alone, and it moves
the day being shown and never the today.

The day it goes back to SHALL be the today the screen was last handed, and this capability MUST NOT
read a clock to find it. A screen opened on one day and shown again on another goes back to the
second, because that is the today it then holds; a screen never shown again goes back to the day it
was opened on.

Going back SHALL take no day from the caller, and SHALL reach the today and no other day. A day named
by a caller is a different thing to offer and needs something to name one with, and a day screen
offers nothing of the kind.

A day screen already showing its today SHALL be left showing it. There is nothing to undo, and going
back SHALL be an answer rather than a refusal: it is the one move that always has somewhere to go.

#### Scenario: a day screen moved into the past goes back to today in one step

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day before three times; and it is then sent back to today
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** its day picker opens on Monday 31 August 2026, and it offers no way back to today

#### Scenario: a day screen moved into the future goes back to today in one step

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day after three times; and it is then sent back to today
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** its day picker opens on Monday 31 August 2026, and it offers no way back to today

#### Scenario: a day screen already showing today is left where it is when it is sent back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is sent back to today without having been moved
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** its day picker opens on Monday 31 August 2026, and it offers no way back to today

#### Scenario: a day screen goes back to the today it was last handed rather than the day it opened on

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; the app is then shown again as of Wednesday 2 September 2026; it is moved to the
  day before twice; and it is then sent back to today
- **THEN** its day picker opens on Wednesday 2 September 2026, and it offers no way back to today

#### Scenario: going back to today does not read the record again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before; a tick for that commitment on Monday 31 August 2026
  is then kept at that place by something else; and it is sent back to today
- **THEN** its day view says the commitment is not kept on Monday 31 August 2026
- **AND** it says it is keeping a record, exactly as it did before

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
- **AND** its day picker opens on Saturday 1 January 1583
- **AND** it says it is keeping a record

#### Scenario: a day screen showing the last supported date is unchanged when it is moved to the day after

- **WHEN** a day screen is opened as of Thursday 30 December 9999, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583; it is moved to the day after; and it is moved to the day after again
- **THEN** its day view is the same day view as one formed directly of that commitment on Friday
  31 December 9999 from a history that has taken no tick
- **AND** its day picker opens on Friday 31 December 9999
- **AND** it says it is keeping a record

#### Scenario: a day screen at either end of the calendar still moves the other way

- **WHEN** a day screen is opened as of Saturday 1 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583, and a second day screen is opened the same way as of Friday 31 December 9999
- **THEN** after the first is moved to the day before and then to the day after, its day picker
  opens on Sunday 2 January 1583
- **AND** after the second is moved to the day after and then to the day before, its day picker
  opens on Thursday 30 December 9999

### Requirement: A day screen that cannot read its roster draws the day and no rows

Opening a day screen at a place holding something that cannot be read as a roster SHALL give a day
screen rather than an error. It SHALL hold the day view of its day formed from no commitments at all,
so it holds no rows, and it SHALL say that it is not keeping a roster.

It SHALL leave what is at the place exactly as it was — not overwritten, not moved, not emptied, and
not written over with the commitments it was handed — so that a later version of the app, or the
person, can still recover it. That is the `commitment` capability's own refusal carried through rather
than a second rule, and every way a roster store can refuse to open SHALL be answered in that one way
— the day drawn, no rows, what is at the place left exactly as it was — whatever the reason was.

A day screen that is not keeping a roster SHALL say which of two things is so: that the roster at its
place was **written by a later version of DayByDay**, or only that the roster could not be read. It
MUST NOT tell any other reason apart, and MUST NOT say a roster was written by a later version when it
was refused for any other reason. The two are separated for the reason ADR-1021 already gives for a
record: a store written by a later version is whole, and what is behind is the app, so the answer is
to update the app and on no account to delete or replace what is at the place.

What a day screen says about its roster SHALL be read off the roster's place and what it says about
its record off the record's, and neither SHALL be read off the other. A day screen may be keeping one
and not the other, in either combination, and SHALL say so of each: an unreadable record leaves rows
to draw and says nothing is kept about them, while an unreadable roster leaves nothing to draw at all,
and a person can act on those differently. A day screen that could read its roster SHALL say that it
is keeping one.

A day screen that is not keeping a roster SHALL say its day exactly as one that is: what a date is
called needs no roster to answer.

#### Scenario: a day screen opened where the roster cannot be read holds no rows and says it is not keeping one

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a run of
  bytes that is not what a roster is written as, at a record place where nothing has been kept, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026
- **THEN** its day view holds no rows
- **AND** it says it is not keeping a roster
- **AND** it does not say the roster was written by a later version of DayByDay

#### Scenario: a roster written in a later form than this app knows makes a day screen that says the roster is from a later version

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a roster
  written in a form one later than the form this app writes, holding no commitments, at a record place
  where nothing has been kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026
- **THEN** it says it is not keeping a roster
- **AND** it says the roster was written by a later version of DayByDay
- **AND** its day view holds no rows

#### Scenario: a day screen opened where the roster can be read says it is keeping one

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place and a record place
  where nothing has been kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026
- **THEN** it says it is keeping a roster
- **AND** a day screen opened at a roster place where a commitment has already been taken on says the
  same

#### Scenario: a day screen that cannot read its roster still says the day and goes on keeping its record

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a run of
  bytes that is not what a roster is written as, at a record place where nothing has been kept, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026
- **THEN** it says the day is "Mon"
- **AND** it says it is keeping a record
- **AND** it says it is not keeping a roster

#### Scenario: a day screen that cannot read its record still draws the commitments its roster keeps

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and then one
  named "Journaling" on a schedule listing all seven weekdays, both kept from 1 January 2026, are
  taken on at a roster place; and a day screen of no commitments at all is opened at that roster place
  as of Monday 31 August 2026, at a record place holding a run of bytes that is not what a record is
  written as
- **THEN** its day view holds two rows, named "Gym" and then "Journaling", neither saying its
  commitment is kept
- **AND** it says it is not keeping a record
- **AND** it says it is keeping a roster

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
lands, a tick taken back, a number entered and a number taken back, a note written and a note taken
back, an addition made and a day's last addition taken back all count: what is being told is that
the place would not take your change, and any one of them landing is proof to the contrary. One rule
rather than eight, because a person cannot act on the difference. A change that does not reach the
place SHALL NOT end it — a second refusal moves it rather than ending it, and a tap that changes
nothing at all changes this nothing either.

A value the commitment refuses and a value that is not a number reach no place, so neither ends
it. Each is a refusal of its own and moves what is told, and the cause it names, onto its own row.
Someone told that the place would not take their tick and then typing 300 into a weight has
learned nothing about the place, so nothing about the place stops being true — it is replaced by
what they were told instead, which is the one-at-a-time rule and not a fourth end. **A note has no
such case**: every commit in a note entry either reaches the place or is a take-back that reaches
it, so a note is only ever one of the ends above or one of the refusals the place itself makes. **A
total entry has three such cases** — a value that is not a number, an amount not above zero, and an
amount too large to add — and each behaves exactly as a refused number does: it reaches no place,
so it ends nothing, and it moves what is told, with the cause it names, onto its own row.

**A commit in a total entry that says nothing is not an end either, and is not a refusal.** It
reaches no place, so it proves nothing about the place; and it refuses nothing, so there is nothing
of its own to move onto the row. What a day screen was telling therefore stands exactly as it was.
It is the same argument that keeps closing an entry without committing it from being a fourth end,
applied to the one entry in which committing nothing *is* a commit.

**The day the screen is showing changing** ends it. What is told is about a tap on a row of the day
you were on, and a day you have moved away from has no row to say it under; carrying it forward
would put a message under a commitment that refused nothing. The rule SHALL be the day being shown
**changing** and never the gesture that was made. A move with nowhere to go — the day before the
first supported date, the day after the last — and going back to today from a screen already showing
today both leave a day screen exactly as it was, which is already this capability's answer, and what
it is telling is part of how it was.

**Closing a number entry or a note entry without committing it is not a fourth end, and cannot
become one.** Someone who opens an entry and leaves it keeps nothing and commits nothing, so this
capability is never asked anything at all and what it is telling still describes the last thing that
happened. Each of the three ends is something that *changed* — the app was shown, a change landed,
the day moved — and nothing changed here. It is written down because a field with a Cancel beside it
is the most plausible fourth end anyone will propose, and a note's field, which a person may sit in
for a minute before backing out of it, is the most tempting instance of that.

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
  place is then made to hold a run of bytes that is not what a record is written as; and the app
  is shown again as of that same day
- **THEN** the day screen says it is not keeping a record
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when the same change is made again and is kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from
  but not written to and where nothing has been kept, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked and
  refused; the place is then made writable; and the row the screen holds is ticked again
- **THEN** the day screen's day view says the commitment is kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when a change is kept on another row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from
  but not written to and where nothing has been kept, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday and a commitment named "Journaling" on a schedule listing
  all seven weekdays, in that order and both kept from 1 January 2026; its first row is ticked and
  refused; the place is then made writable; and its second row is ticked
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
- **AND** its day picker opens on Sunday 30 August 2026

#### Scenario: what a day screen tells on a row ends when the day screen is moved to the day after

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; its one row is ticked; and it is
  then moved to the day after
- **THEN** the day screen tells nothing on any row
- **AND** its day picker opens on Tuesday 1 September 2026

#### Scenario: what a day screen tells on a row ends when the day screen is sent back to today from another day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; it is moved to the day before;
  its one row is ticked; and it is then sent back to today
- **THEN** the day screen tells nothing on any row
- **AND** its day picker opens on Monday 31 August 2026, and it offers no way back to today

#### Scenario: what a day screen tells on a row stands when a move has nowhere to go

- **WHEN** a day screen is opened as of Saturday 1 January 1583 and another as of Friday 31
  December 9999, each at its own place where nothing can be written — a path beneath an existing
  ordinary file — of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 1583; each screen's one row is ticked; and the first is then moved to the
  day before and the second to the day after
- **THEN** each day screen still tells, on the row that was ticked on it, that the change could
  not be kept
- **AND** the first's day picker still opens on Saturday 1 January 1583 and the second's on Friday
  31 December 9999

#### Scenario: what a day screen tells on a row stands when a day screen showing today is sent back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; its one row is ticked; and it is
  then sent back to today without having been moved
- **THEN** the day screen still tells, on that row, that the change could not be kept
- **AND** its day picker still opens on Monday 31 August 2026, and it offers no way back to today

#### Scenario: what a day screen tells on a row ends when a number is entered and kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from
  but not written to and where nothing has been kept, of a commitment named "Weight" of the number
  kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; "70.5" is committed on its one row and refused; the place is then made writable;
  and "70.5" is committed again on the row the screen then holds
- **THEN** the day screen's day view says the commitment is kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when a number is taken back and kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 on a schedule
  listing Monday, Wednesday and Saturday and a commitment named "Journaling" of the tick kind on a
  schedule listing all seven weekdays, in that order and both kept from 1 January 2026; "70.5" is
  committed on the first row and kept; the place is then made unwritable; the second row is ticked
  and refused; the place is made writable again; and nothing at all is committed on the row for
  "Weight"
- **THEN** the day screen's day view says "Weight" is not kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells about a refused value ends when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "300" is committed on its one
  row; and the app is then shown again as of that same day
- **THEN** the day screen tells nothing on any row
- **AND** its one row still says the commitment is not kept on that date

#### Scenario: what a day screen tells about a refused value ends when the day screen is moved to the day before

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026; "1.2.3" is committed on its one row; and
  it is then moved to the day before
- **THEN** the day screen tells nothing on any row
- **AND** its day picker opens on Sunday 30 August 2026

#### Scenario: what a day screen tells on a row ends when a note is written and kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from but
  not written to and where nothing has been kept, of a commitment named "Journal" of the note kind,
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; "Ran 8k." is
  committed on its one row and refused; the place is then made writable; and "Ran 8k." is committed
  again on the row the screen then holds
- **THEN** the day screen's day view says the commitment is kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when a note is taken back and kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind on a schedule listing Monday, Wednesday and
  Saturday and a commitment named "Gym" of the tick kind on a schedule listing all seven weekdays,
  in that order and both kept from 1 January 2026; "Ran 8k." is committed on the first row and kept;
  the place is then made unwritable; the second row is ticked and refused; the place is made
  writable again; and nothing at all is committed on the row for "Journal"
- **THEN** the day screen's day view says "Journal" is not kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when an addition is made and kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from but
  not written to and where nothing has been kept, of a commitment named "Protein" of the total kind
  with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026; "30" is committed on its one row and refused; the place is then made writable; and "30" is
  committed again on the row the screen then holds
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when a last addition is taken back and kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120 on a schedule listing
  Monday, Wednesday and Saturday and a commitment named "Gym" of the tick kind on a schedule listing
  all seven weekdays, in that order and both kept from 1 January 2026; "30" is committed on the first
  row and kept; the place is then made unwritable; the second row is ticked and refused; the place is
  made writable again; and the last addition is taken back on the row for "Protein"
- **THEN** the entry that row then offers says "0 of 120"
- **AND** it tells nothing on any row

#### Scenario: a commit saying nothing in a total entry leaves what a day screen is telling standing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Protein" of the total
  kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; "30" is committed on its one row and refused; and nothing at all is then committed
  on the row it holds
- **THEN** the day screen still tells, on that row, that the change could not be kept
- **AND** the entry that row offers still says "0 of 120"

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
- **THEN** its day picker opens on Sunday 30 August 2026
- **AND** its day view holds one row, named "Journaling"

#### Scenario: a day screen returned to keeps the today it was handed

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; and
  it is returned to
- **THEN** its day picker opens on Monday 31 August 2026, and it offers no way back to today

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
- **AND** its day picker opens on Monday 31 August 2026

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
- **THEN** its day picker opens on Monday 31 August 2026
- **AND** it offers no way back to today, exactly as it did before

#### Scenario: a day screen shown again on a later day offers the way back to today from the day it stayed on

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before; and the app is then shown again as of Wednesday
  2 September 2026
- **THEN** it offers the way back to today
- **AND** sent back, its day picker opens on Wednesday 2 September 2026 and it offers no way back

#### Scenario: a day screen showing its today when the app is shown again on a later day offers no way back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the app is shown again as of Wednesday 2 September 2026 without it having been
  moved
- **THEN** it offers no way back to today
- **AND** its day picker opens on Wednesday 2 September 2026

#### Scenario: a day screen the day it is showing has caught up with offers no way back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day after; and the app is then shown again as of Tuesday
  1 September 2026
- **THEN** it offers no way back to today
- **AND** its day picker opens on Tuesday 1 September 2026

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
- **THEN** its day picker opens on Sunday 30 August 2026 and reaches back to Sunday 30 August
  2026
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
- **AND** its day picker opens on Monday 15 June 2026

#### Scenario: a day screen shows a day picked after the today it was handed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; and Friday 25 December 2026 is picked
- **THEN** its day picker opens on Friday 25 December 2026
- **AND** a second day screen opened the same way, on which Friday 31 December 9999 is picked, has
  its day picker open on Friday 31 December 9999

#### Scenario: a day screen shows the earliest day its day picker reaches when that day is picked

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; and Thursday 1 January 2026, the earliest day its day picker reaches, is picked
- **THEN** its day picker opens on Thursday 1 January 2026 and reaches back to Thursday 1 January
  2026

#### Scenario: a day screen is left exactly as it was by a day picked earlier than its day picker reaches

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; and Wednesday 31 December 2025 is picked
- **THEN** it offers no way back to today
- **AND** its day view is the same day view as the one it held before that day was picked, and is
  not the day view of Thursday 1 January 2026
- **AND** its day picker still opens on Monday 31 August 2026 and reaches back to 1 January 2026

#### Scenario: a day screen picking the day it is already showing changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place that can be read
  from but not written to and where nothing has been kept, of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked
  and refused; and Monday 31 August 2026 is picked
- **THEN** its day picker still opens on Monday 31 August 2026, and it offers no way back to today
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
- **THEN** its day picker opens on Monday 15 June 2026, and it offers the way back to today
- **AND** sent back to today, its day picker opens on Monday 31 August 2026 and it offers no way
  back

#### Scenario: a day screen stops telling what it was telling on a row when a picked day changes the day it is showing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place that can be read
  from but not written to and where nothing has been kept, of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked
  and refused; and Monday 15 June 2026 is picked
- **THEN** it tells nothing on any row
- **AND** its day picker opens on Monday 15 June 2026

#### Scenario: a day screen goes on telling what it was telling on a row when a picked day is earlier than its day picker reaches

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place that can be read
  from but not written to and where nothing has been kept, of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked
  and refused; and Wednesday 31 December 2025 is picked
- **THEN** it is still telling on that row that the change could not be kept
- **AND** its day picker still opens on Monday 31 August 2026

#### Scenario: a day screen offers the way back to today once a day other than that today is picked

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and Monday 15 June 2026 is picked
- **THEN** it offers the way back to today
- **AND** picking Monday 31 August 2026 from there, it offers no way back to today
- **AND** a screen on which Wednesday 31 December 2025 is picked instead offers no way back to
  today, that day never having been shown

## REMOVED Requirements

### Requirement: A day view says its day as a weekday and a date, and says Today on the day it is asked as of

### Requirement: A day screen says the day it is showing, as of the day it was handed
