## ADDED Requirements

### Requirement: A day screen draws the commitments its roster had not stopped keeping on the day it is showing

A day screen SHALL hold a roster, read at the place it keeps its roster, and SHALL form every day
view it holds from the commitments that roster had not stopped keeping on the day being shown, in
the order the roster answers with. It MUST NOT hold a list of commitments of its own, and MUST NOT
ask the roster about the today or about any day other than the one it is showing.

Every day view a day screen forms SHALL ask the roster again for the day then being shown: when the
screen is opened, when it is moved, when it is sent back to today, when the app is shown again, and
when a tick is made. A commitment the roster stopped keeping therefore has a row on every day up to
and including the day it was kept until and on none after it, and a screen moved across that day
changes what it draws without anything being read again.

Asking the roster is not reading the roster's place again. The roster a day screen asks is the one
read at that place when the app was last shown, together with any change the screen has kept since,
so a move and a tick MUST NOT open the roster's place, exactly as they MUST NOT open the record's.

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

### Requirement: A day screen takes on the commitments it was handed when its roster holds nothing at all

A day screen SHALL be handed some commitments, and SHALL take them on — in the order it was handed
them — exactly when the roster it has just read holds nothing at all. It SHALL keep them at its
roster place before drawing from them, and the day view it then holds SHALL be of the roster as it
then stands rather than of the list it was handed.

A roster holding anything at all SHALL be left exactly as it is, and the commitments handed in SHALL
NOT be taken on a second time. A roster every one of whose commitments has been stopped still holds
them, so it is not a roster holding nothing and MUST NOT be written over: what makes this a first
launch is that nothing has ever been taken on, not that nothing is being kept today.

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

### Requirement: A day screen keeps its roster at its own place, beside its record

A day screen SHALL name the place it keeps its roster at, and MUST NOT leave that choice to whatever
draws it. The place SHALL be one whose contents survive the app being closed, being force-quit and
the device being restarted, and are carried in a backup of the device: it SHALL be inside the
directory the platform reserves for an application's own supporting data — `Application Support` —
within a directory belonging to this app, and it SHALL be one file.

It MUST NOT be the caches directory, which the system empties when it is short of space, and MUST NOT
be the temporary directory, which is not carried in a backup. The reasoning is the record place's,
unchanged: a store keeps what it is given at whatever place it is given, and cannot refuse a bad one
from where it sits.

The place SHALL be the same place every time it is asked for, so that the app opened again reads what
the app before it wrote, and it SHALL NOT be the place the day screen keeps its record at. The roster
and the record are two values kept independently, so that taking a commitment on does not rewrite a
history and a tick does not rewrite a roster; one file holding both would make either one unreadable
take the other down with it.

#### Scenario: the place a day screen keeps its roster is under Application Support, in a directory of the app's own

- **WHEN** the place a day screen keeps its roster at is asked for
- **THEN** it is inside the platform's application-support directory
- **AND** it is one file inside a directory of this app's own within it, rather than directly inside
  it

#### Scenario: the place a day screen keeps its roster is neither the caches directory nor the temporary directory

- **WHEN** the place a day screen keeps its roster at is asked for
- **THEN** it is not inside the platform's caches directory
- **AND** it is not inside the temporary directory

#### Scenario: the place a day screen keeps its roster is the same place every time it is asked

- **WHEN** the place a day screen keeps its roster at is asked for twice
- **THEN** the two are the same place

#### Scenario: the place a day screen keeps its roster is not the place it keeps its record

- **WHEN** the place a day screen keeps its roster at and the place it keeps its record at are both
  asked for
- **THEN** the two are different places

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
- **THEN** it says the day is "Today · Monday 31 August 2026"
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

## MODIFIED Requirements

### Requirement: A day screen holds the day view of the day it was handed, formed from the record kept at its place

A day screen SHALL be opened from four things: some commitments, the day it is being opened on, the
place its record is kept at, and the place its roster is kept at. It SHALL hold the day view, on that
day, of the commitments its roster had not stopped keeping on it, formed from the history held at the
record's place, and SHALL give that day view back whole and unaltered. The commitments it is opened
from are the ones it takes on when its roster holds nothing at all, and are not a list it draws: what
it draws is always its roster's answer, whether that roster was read at the place or written there a
moment earlier. It adds nothing to the day view and takes nothing away: which commitments have a row,
in which order, and what each row says are already this capability's answers about a date, what the
roster had not stopped keeping is the `commitment` capability's answer, and what is kept at a place is
the `record` capability's, so a day screen SHALL hold exactly the day view that would be formed
directly from the commitments its roster answers with, the same day and that same history.

The today a day screen holds SHALL be given to it and never asked for. This capability MUST NOT read
a clock, MUST NOT consult the present moment, the device's time zone or the locale, so a day screen
opened as of any date the system supports holds that date's day view whatever day it really is, and
two day screens opened as of the same day from the same record and the same roster hold the same day
view for ever.

A day screen SHALL hold two days, and they SHALL be separate things. The **today** it was handed is a
fact about the device, and every question the screen asks as of a day is asked as of it. The **day it
is showing** is what its day view is of and what a person is looking at; it SHALL begin as that same
today, and it SHALL be the one a move changes. The two coincide when a screen is opened and whenever
it is showing its today, and a day screen MUST NOT keep only one of them: a screen that moved by
writing its today would ask every as-of question as of the day being displayed, which is what would
let a tap offer a tick for a day that has not arrived.

A day screen SHALL hold the day it is showing until it is moved or the app is shown again, and SHALL
be moved onto another day by nothing else. Time passing MUST NOT move it, and neither MUST a tick
made on it: a screen a person is looking at cannot change day underneath them. The today SHALL be
replaced only when the app is shown again, and by nothing a person does on the screen.

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

The tick SHALL be the one the row itself offers, asked as of the today the screen was handed and
never as of the day it is showing. A day screen moved onto a day that has not arrived therefore takes
no tick on it: the row it holds is for a date later than that today, and a row for such a date offers
nothing. Moving a screen forward MUST NOT make a tick formable that was not formable before the move,
and that is the whole of what holding the two days apart buys. The screen MUST NOT form a tick of its
own, MUST NOT choose which tick a row means, and MUST NOT reach past a row to the commitment
underneath it. A row the screen's day view does not hold SHALL change nothing at all: a row is a
commitment's line on a date, so a row from a day this screen is no longer on, or from another screen
entirely, ticks nothing here.

The change SHALL be kept at the screen's record place before its day view says so, and the day view
SHALL then be formed again, on the day the screen is showing, from the record as it stands and from
the commitments its roster had not stopped keeping on that day, rather than the day view it held
being altered: what a person reads is always an answer taken from what is kept. A change that could
not be kept SHALL be refused, SHALL be reported to the caller rather than passed over, and SHALL
leave the day view exactly as it was. The day view a person reads MUST NOT be ahead of what is kept
at the place, and a tick that could not be kept MUST NOT be held anywhere in its place.

A tick SHALL reach the record's place and nothing else. Making one or taking one back MUST NOT write
to the roster's place, and MUST NOT change what the screen says about its roster: the two are kept
independently, and a tick is not a change to what a person keeps.

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


#### Scenario: ticking a row on a day a day screen has moved back to keeps the tick on that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before; and its one row is ticked
- **THEN** its day view says the commitment is kept on Sunday 30 August 2026
- **AND** a day screen opened afterwards at that place as of Sunday 30 August 2026 says the
  commitment is kept on that date
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says the
  commitment is not kept on that date

#### Scenario: ticking a row on a day a day screen has moved onto that has not arrived keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day after; and its one row is ticked
- **THEN** its day view still says the commitment is not kept on Tuesday 1 September 2026
- **AND** a day screen opened afterwards at that place as of Tuesday 1 September 2026 says the
  commitment is not kept on that date

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
- **THEN** it says the day is "Tuesday 1 September 2026", without "Today" in front of it
- **AND** moving it to the day before makes it say the day is "Today · Monday 31 August 2026", which
  is the day it was handed

#### Scenario: a day screen moves onto a day that has not arrived and shows it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day after four times
- **THEN** its day view is the same day view as one formed directly of that commitment on Friday
  4 September 2026 from a history that has taken no tick
- **AND** it says the day is "Friday 4 September 2026"

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
- **AND** it says the day is "Today · Monday 31 August 2026"

#### Scenario: a day screen moved into the future goes back to today in one step

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day after three times; and it is then sent back to today
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** it says the day is "Today · Monday 31 August 2026"

#### Scenario: a day screen already showing today is left where it is when it is sent back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is sent back to today without having been moved
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** it says the day is "Today · Monday 31 August 2026"

#### Scenario: a day screen goes back to the today it was last handed rather than the day it opened on

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; the app is then shown again as of Wednesday 2 September 2026; it is moved to the
  day before twice; and it is then sent back to today
- **THEN** it says the day is "Today · Wednesday 2 September 2026"

#### Scenario: going back to today does not read the record again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before; a tick for that commitment on Monday 31 August 2026
  is then kept at that place by something else; and it is sent back to today
- **THEN** its day view says the commitment is not kept on Monday 31 August 2026
- **AND** it says it is keeping a record, exactly as it did before

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
