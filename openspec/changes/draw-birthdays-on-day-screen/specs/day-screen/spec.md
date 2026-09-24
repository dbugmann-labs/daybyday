## ADDED Requirements

### Requirement: A day screen draws the birthdays falling on each day as one group headed Birthdays, while birthdays are on

A day screen MAY be opened with a birthday switch and a calendar, which it asks for the birthdays
falling on a run of days and which says the order words are collated in. Birthdays SHALL be on for a
day screen exactly while it was handed both and that switch is on. While they are on, its day view
SHALL hold one group of birthday rows, headed "Birthdays" in this package's own words, holding a row
for each birthday the calendar hands that falls on its date, and SHALL hold no such group where none
falls there, the day views either side alike. That group SHALL NOT be one of its groups of
commitments, its rows SHALL NOT be among its commitment rows, and it SHALL come before every group
of commitments. A birthday row SHALL say its birthday's words exactly as the calendar handed them,
empty words included.

#### Scenario: a day screen with birthdays on draws the birthdays falling on its day in a group headed Birthdays

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Tuesday 20 January 2026 at a record place, a roster
  place, a one-off place and a birthday place where nothing has been kept, with birthdays on and a
  calendar holding the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 20 January
  2026 and the contact "john"'s worded "John Appleseed's 46th Birthday" on 21 January 2026
- **THEN** its day view holds a Birthdays group headed "Birthdays", holding one row, saying "Kate
  Bell's 48th Birthday" and saying it is not ticked
- **AND** it holds one group of commitments, with no category, and its commitment rows are named
  "Journaling" alone
- **AND** the day view it says of the day after holds a Birthdays group holding one row, saying
  "John Appleseed's 46th Birthday"
- **AND** the day view it says of the day before holds no Birthdays group

#### Scenario: a birthday row says the calendar's words exactly, and empty words make a row that says nothing and still ticks

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at four
  places where nothing has been kept, with birthdays on and a calendar holding the contact "kate"'s
  birthday with empty words on 20 January 2026, and its one birthday row is ticked
- **THEN** its Birthdays group holds one row, saying nothing and saying it is ticked
- **AND** a day screen opened the same way of a calendar holding that birthday worded " Kate Bell's
  48th Birthday ", with blank space at both ends, holds one row saying exactly that

### Requirement: A birthday row is its birthday and whether it is ticked, and offers its tick where its day has arrived

A birthday row SHALL be its birthday and whether that birthday is ticked. Two birthday rows SHALL be
the same row exactly when both agree, and two day views SHALL be different day views where a
birthday row they hold differs. A birthday row SHALL give back its words, whether it is ticked and
whether it offers its tick, and MUST NOT give back its birthday's contact or day. It SHALL offer its
tick when asked as of a today no earlier than its date, however much later, whether or not it is
ticked, and SHALL offer none when asked as of an earlier today; the today SHALL be given to it. A
birthday row offering no tick SHALL still be held.

#### Scenario: a birthday row offers its tick on its day and on any day after it, and none before

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at four
  places where nothing has been kept, with birthdays on and a calendar holding the contact "kate"'s
  birthday worded "Kate Bell's 48th Birthday" on 20 January 2026 and the contact "john"'s worded
  "John Appleseed's 46th Birthday" on 21 January 2026
- **THEN** its one birthday row offers its tick asked as of 20 January 2026, and asked as of
  20 January 2036
- **AND** it offers none asked as of 19 January 2026
- **AND** the one birthday row of the day view it says of the day after offers none asked as of
  20 January 2026, and offers its tick asked as of 21 January 2026

#### Scenario: two birthday rows are the same row exactly when their birthdays and their ticks agree

- **WHEN** two day screens of no commitments at all are opened as of Tuesday 20 January 2026, each
  at four places of its own where nothing has been kept, with birthdays on and a calendar holding
  the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 20 January 2026
- **THEN** their two birthday rows are the same row, and their two day views are the same day view
- **AND** after the second screen's birthday row is ticked, the two rows are different rows and the
  two day views are different day views
- **AND** a third opened the same way of a calendar holding that contact's birthday worded
  "Kate Smith's 48th Birthday" on that day holds a row that is a different row from the first's

### Requirement: A day screen follows its birthday switch, and asks the calendar nothing while birthdays are off

A day screen SHALL read whether its birthday switch is on each time it forms the day view of the day
it is showing, so a switch turned on or off while the screen is left SHALL be followed once it is
returned to. While birthdays are off, a day screen SHALL hold no Birthdays group on any day, SHALL
say birthdays are off, SHALL say nothing about its birthday ticks, and MUST NOT ask its calendar
anything. A day screen shown again SHALL show its birthday switch again before it forms its day view
or asks its calendar anything, so birthdays kept on where the phone no longer gives full calendar
access SHALL be off.

#### Scenario: a day screen with birthdays off asks the calendar nothing and draws no Birthdays group

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at a
  record place, a roster place and a one-off place where nothing has been kept and a birthday place
  holding a run of bytes that is not what birthday ticks are written as, with a birthday switch that
  is off, asking a phone that gives full calendar access, and a calendar holding the contact
  "kate"'s birthday worded "Kate Bell's 48th Birthday" on 20 January 2026
- **THEN** its day view holds no Birthdays group, and neither does the day view it says of the day
  before or of the day after
- **AND** it says birthdays are off, and says nothing about its birthday ticks
- **AND** its calendar has been asked nothing
- **AND** a day screen opened the same way with a birthday switch that is on and no calendar, and one
  opened with a calendar and no birthday switch, each say birthdays are off the same way

#### Scenario: a birthday switch turned on while a day screen is left is followed when it is returned to

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at four
  places where nothing has been kept, with a birthday switch that is off, asking a phone that gives
  full calendar access, and a calendar holding the contact "kate"'s birthday worded "Kate Bell's 48th
  Birthday" on 20 January 2026; the switch is then turned on; and the day screen is returned to
- **THEN** its day view holds a Birthdays group holding one row, saying "Kate Bell's 48th Birthday"
- **AND** it says birthdays are on
- **AND** after the switch is turned off and the day screen is returned to again, it holds no
  Birthdays group and says birthdays are off

#### Scenario: a day screen shown again after the phone withdraws calendar access says birthdays are off and asks the calendar nothing

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at four
  places where nothing has been kept, with birthdays on, its switch asking a phone that gives full
  calendar access, and a calendar holding the contact "kate"'s birthday worded "Kate Bell's 48th
  Birthday" on 20 January 2026; the phone then denies calendar access; and the app is shown again as
  of that same day
- **THEN** its day view holds no Birthdays group, and it says birthdays are off
- **AND** it does not say birthdays could not be read
- **AND** its birthday switch is off
- **AND** its calendar has been asked once in all, when the screen was opened

### Requirement: A day screen asks the calendar for the day it is showing and the day either side, each time it forms that day's view

While birthdays are on, a day screen SHALL ask its calendar once, for the days from the day before
the one it is showing through the day after, each time it forms the day view of the day it is
showing — being opened, shown again, returned to, moved, sent back to today or put on a picked day,
and after a change is kept — and SHALL form the day views either side from that same answer. Saying
either SHALL ask nothing. Where the day it is showing is the first or the last supported date, it
SHALL ask for the days that exist. A birthday the calendar hands on a day it was not asked for SHALL
NOT be drawn.

#### Scenario: a day screen asks the calendar once for the day it shows and the day either side, and never to say either

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at four
  places where nothing has been kept, with birthdays on and a calendar that records every ask and
  hands, whatever it is asked for, the contact "kate"'s birthday worded "Kate Bell's 48th Birthday"
  on 23 January 2026; the
  day views it says of the day before and of the day after are read; and it is moved to the day
  after
- **THEN** its calendar has been asked twice: for 19 January through 21 January 2026, and then for
  20 January through 22 January 2026
- **AND** neither its day view nor the day view it says of the day after holds a Birthdays group
- **AND** a day screen opened the same way as of Friday 31 December 9999 asks for 30 December
  through 31 December 9999, and one opened as of Saturday 1 January 1583 asks for 1 January through
  2 January 1583

### Requirement: A day screen whose calendar cannot be read draws no Birthdays group and says so

Where asking its calendar fails, a day screen SHALL hold no Birthdays group, neither on the day it is
showing nor on either side, and SHALL say birthdays could not be read, saying nothing about its
birthday ticks and telling no reason the calendar failed. It SHALL draw its commitments and its
one-offs exactly as it would otherwise, SHALL keep nothing, and what it says about its record, its
roster and its one-offs SHALL be untouched. What it says about birthdays SHALL be formed again at its
next ask, so an ask that succeeds SHALL draw the birthdays and end the saying.

#### Scenario: a day screen whose calendar cannot be read draws no Birthdays group and says birthdays could not be read

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Tuesday 20 January 2026 at a record place, a roster place
  and a one-off place where nothing has been kept and a birthday place holding a run of bytes that is
  not what birthday ticks are written as, with birthdays on and a calendar whose every ask fails
- **THEN** its day view holds one row, named "Journaling", and no Birthdays group, and neither day
  view it says either side holds one
- **AND** it says birthdays could not be read, and says nothing about its birthday ticks
- **AND** it says it is keeping a record, keeping a roster and keeping one-offs
- **AND** after the calendar holds the contact "kate"'s birthday worded "Kate Bell's 48th Birthday"
  on 20 January 2026 and answers, and the day screen is returned to, its Birthdays group holds one
  row saying those words and it says its birthday ticks could not be read

### Requirement: A day screen draws a day's birthdays in the order their words are collated in

A day screen SHALL hand each day view the birthdays falling on its date in the order its calendar
says their words are collated in, and MUST NOT keep the order the calendar handed them in. Two
birthdays whose words neither comes before the other SHALL be in the order of their contacts,
compared character by character. A day screen SHALL consult no locale of its own to order them, and
a day view SHALL draw its birthday rows in the order it was handed them.

#### Scenario: a day's birthdays are drawn in the order their words are collated in, whatever order the calendar hands them

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at four
  places where nothing has been kept, with birthdays on and a calendar collating words in
  alphabetical order with capitals and small letters alike, handing in this order the contact
  "zoe"'s birthday worded "Zoe Adams's Birthday", the contact "kate"'s worded "Kate Bell's 48th
  Birthday" and the contact "anna"'s worded "anna Haro's Birthday", all on 20 January 2026
- **THEN** its Birthdays group holds rows saying "anna Haro's Birthday", "Kate Bell's 48th Birthday"
  and then "Zoe Adams's Birthday"
- **AND** with a calendar collating words in the reverse of that order, the rows are in the reverse
  order
- **AND** of two birthdays both worded "Sam's Birthday" on that day, of the contacts "sam-2" and then
  "sam-1" handed in that order, ticking the first row ticks the contact "sam-1"'s birthday

### Requirement: A day screen keeps its birthday ticks at its own place, beside its other places

A day screen SHALL name the place it keeps its birthday ticks at, and MUST NOT leave that choice to
whatever draws it. The place SHALL be one file inside a directory belonging to this app, within the
directory the platform reserves for an application's own supporting data, and MUST NOT be inside
the caches directory or the temporary directory. It SHALL be the same place every time it is asked
for, and SHALL be none of the places the day screen keeps its record, its roster and its one-offs at,
nor the place a birthday switch is kept at by default. A day screen SHALL open its birthday place
when it is opened and when the app is shown again, whether or not birthdays are on, and at no other
moment; opening it SHALL write nothing there.

#### Scenario: the place a day screen keeps its birthday ticks is a file of the app's own under Application Support, the same every time

- **WHEN** the place a day screen keeps its birthday ticks at is asked for twice
- **THEN** the two are the same place
- **AND** it is one file inside a directory of this app's own within the platform's
  application-support directory, rather than directly inside it
- **AND** it is not inside the platform's caches directory, and not inside the temporary directory

#### Scenario: the place a day screen keeps its birthday ticks is none of its other places

- **WHEN** the places a day screen keeps its birthday ticks, its record, its roster and its one-offs
  at, and the place a birthday switch is kept at by default, are all asked for
- **THEN** the five are five different places

#### Scenario: a day screen reads its birthday place again when shown and not when returned to or moved

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at four
  places where nothing has been kept, with birthdays on and a calendar holding the contact "kate"'s
  birthday worded "Kate Bell's 48th Birthday" on 20 January 2026; that birthday is then ticked at
  its birthday place by something else; and the day screen is returned to, moved to the day after
  and moved back
- **THEN** its Birthdays group holds one row, saying it is not ticked
- **AND** after the app is shown again as of that same day, that row says it is ticked
- **AND** a day screen opened the same way and never ticked leaves nothing kept at its birthday
  place

### Requirement: A day screen that cannot read its birthday ticks draws its birthdays unticked and keeps no tick

Opening a day screen at a birthday place holding something that cannot be read as birthday ticks
SHALL give a day screen rather than an error. While birthdays are on, it SHALL draw its Birthdays
group as it would otherwise, every row saying its birthday is not ticked, and SHALL say its birthday
ticks were written by a later version of DayByDay where that is why, and otherwise only that they
could not be read; it MUST NOT tell any other reason apart. A tick asked of a birthday row on it
SHALL change nothing, keep nothing anywhere, throw nothing and be told on no row. It SHALL leave what
is at that place exactly as it was, and what it says about its record, its roster and its one-offs
SHALL NOT be read off that place.

#### Scenario: a day screen whose birthday place cannot be read draws its birthdays unticked and keeps no tick

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at a record
  place, a roster place and a one-off place where nothing has been kept and a birthday place holding
  a run of bytes that is not what birthday ticks are written as, with birthdays on and a calendar
  holding the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 20 January 2026; and
  its one birthday row is ticked
- **THEN** ticking is not refused with an error, and it tells nothing on any row
- **AND** its Birthdays group holds one row, saying "Kate Bell's 48th Birthday" and saying it is not
  ticked
- **AND** it says its birthday ticks could not be read, and does not say they were written by a later
  version of DayByDay
- **AND** it says it is keeping a record, keeping a roster and keeping one-offs
- **AND** the content at that birthday place is byte-for-byte what it was before the screen was
  opened
- **AND** a day screen opened the same way at a birthday place that is a directory holding nothing
  says the same, and that place is still a directory holding nothing

#### Scenario: birthday ticks written in a later form make a day screen that says they are from a later version

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at a record
  place, a roster place and a one-off place where nothing has been kept and a birthday place holding
  birthday ticks written in a form one later than the form this app writes, holding no ticks, with
  birthdays on and a calendar holding the contact "kate"'s birthday worded "Kate Bell's 48th
  Birthday" on 20 January 2026
- **THEN** it says its birthday ticks were written by a later version of DayByDay
- **AND** its Birthdays group holds one row, saying it is not ticked
- **AND** the content at that birthday place is byte-for-byte what it was before the screen was
  opened

### Requirement: A day screen makes and takes back a birthday row's tick, and keeps the change before the day view says so

A day screen SHALL make the tick a birthday row offers where its birthday is not ticked, and SHALL
take that tick back where it is; which of the two SHALL be read off the row. The tick SHALL be held
against the row's birthday on that birthday's own day, whatever today the screen was handed. The
change SHALL be kept at the birthday place before the day view says so, every day view then being
formed again. A change that cannot be kept SHALL be refused to the caller and SHALL leave the day
view as it was. A birthday row the screen's day view does not hold, and one offering no tick as of
the screen's today, SHALL change nothing and throw nothing. A birthday change MUST NOT write to the
record's place, the roster's or the one-off place.

#### Scenario: ticking a birthday row keeps its tick, and ticking it again takes the tick back

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at four
  places where nothing has been kept, with birthdays on and a calendar holding the contact "kate"'s
  birthday worded "Kate Bell's 48th Birthday" on 20 January 2026; and its one birthday row is ticked
- **THEN** ticking is not refused, and its Birthdays group holds one row saying it is ticked
- **AND** a birthday store opened afterwards at its birthday place holds that birthday ticked
- **AND** nothing has been kept at its record place, its roster place or its one-off place
- **AND** after that row is ticked again, it says it is not ticked, and a birthday store opened
  afterwards at its birthday place holds no ticks

#### Scenario: a birthday row on a past day is ticked against its own day, not the today

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2020, is opened as of Tuesday 20 January 2026 at four places where nothing has
  been kept, with birthdays on and a calendar holding the contact "anna"'s birthday worded "Anna
  Haro's 40th Birthday" on 29 August 2025; Friday 29 August 2025 is picked; and its one birthday row
  is ticked
- **THEN** that row says it is ticked
- **AND** a birthday store opened afterwards at its birthday place holds the contact "anna"'s
  birthday on 29 August 2025 ticked, and holds no tick on 20 January 2026

#### Scenario: a birthday tick that cannot be kept is refused and leaves the day view as it was

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at a record
  place, a roster place and a one-off place where nothing has been kept and a birthday place where
  nothing can be written — a path beneath an existing ordinary file — with birthdays on and a
  calendar holding the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 20 January
  2026; and its one birthday row is ticked
- **THEN** ticking is refused with an error
- **AND** its Birthdays group still holds one row, saying it is not ticked
- **AND** a birthday store opened afterwards at that place holds no ticks

#### Scenario: ticking a birthday row that the day view does not hold or that offers no tick changes nothing

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at four
  places where nothing has been kept, with birthdays on and a calendar holding the contact "john"'s
  birthday worded "John Appleseed's 46th Birthday" on 21 January 2026; the birthday row of the day
  view it says of the day after is ticked; and it is then moved to the day after and its own birthday
  row, which offers no tick as of 20 January 2026, is ticked
- **THEN** neither ticking is refused with an error, and it tells nothing on any row
- **AND** its Birthdays group holds one row, saying it is not ticked
- **AND** nothing has been kept at its birthday place

### Requirement: A day screen tells on the birthday row that was tapped that its change could not be kept

Where a birthday tick cannot be kept, a day screen SHALL tell it on the birthday row tapped as well
as refusing it to the caller, and what it tells SHALL name no cause. A day screen SHALL tell at most
one row at a time, whatever its kind: a refusal on a birthday row SHALL move what is told onto that
row and leave nothing told on any commitment or one-off row, and a refusal on a commitment row or a
one-off row SHALL leave nothing told on any birthday row. Telling on a birthday row MUST NOT change
what a day screen says about birthdays.

#### Scenario: a refused birthday tick is told on its row and ends what was told on a commitment row

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Tuesday 20 January 2026 at a record place and a birthday
  place where nothing can be written — each a path beneath an existing ordinary file — and a roster
  place and a one-off place where nothing has been kept, with birthdays on and a calendar holding
  the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 20 January 2026; its one
  commitment row is ticked and refused; and its one birthday row is then ticked
- **THEN** ticking the birthday row is refused with an error
- **AND** it tells, on the birthday row, that the change could not be kept, naming no cause
- **AND** it tells nothing on the commitment row
- **AND** it still says birthdays are on

#### Scenario: a refused commitment or one-off tick ends what was told on a birthday row

- **WHEN** a one-off named "Call mum" on 20 January 2026 is added at a one-off place that is then
  made so that it can be read from but not written to; a day screen of a commitment named
  "Journaling" on a schedule listing all seven weekdays, kept from 1 January 2026, is opened at that
  one-off place as of Tuesday 20 January 2026, at a record place and a birthday place where nothing
  can be written — each a path beneath an existing ordinary file — and a roster place where nothing
  has been kept, with birthdays on and a calendar holding the contact "kate"'s birthday worded "Kate
  Bell's 48th Birthday" on 20 January 2026; its one birthday row is ticked and refused; and its one
  commitment row is then ticked and refused
- **THEN** it tells, on the commitment row, that the change could not be kept
- **AND** it tells nothing on the birthday row
- **AND** after the birthday row is ticked and refused again and the one-off row is then ticked and
  refused, it tells on the one-off row and nothing on the birthday row

## MODIFIED Requirements

### Requirement: A day view is a value and nothing else

A day view SHALL be the groups it holds, its One-offs group where it holds one, its Birthdays group
where it holds one, and the calendar date it was formed on, and nothing else. Two day views SHALL be
the same day view when they are of the same date and hold the same groups in the same order, each
group holding the same rows in the same order, the same One-offs group or none, and the same
Birthdays group or none, and SHALL be different when any of that differs;
two day views holding the same rows in the same order under different groupings SHALL therefore be
two day views.

A difference in what a day view was handed that does not reach a row SHALL make no difference to the
day view: a commitment not due produces no row, a group none of whose commitments is due produces no
group, and a tick for a commitment the day view was not handed is never looked up, and a one-off
standing on another day produces no one-off row, so a day view handed any of the four SHALL be the
same day view as one that was not handed it. A day view handed no one-offs at all SHALL NOT be the
same day view as one handed one-offs holding none. A day view SHALL be an answer given from a
history as it stood rather than a window onto one, and ticking that history afterwards MUST NOT
change the day view.

#### Scenario: two day views of the same commitments and history on different dates are different day views

- **WHEN** two day views are formed of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, each from a history that has taken no tick, one
  on Monday 31 August 2026 and one on Wednesday 2 September 2026
- **THEN** each holds one row named "Gym", saying the commitment is not kept
- **AND** the two are different day views

#### Scenario: two day views differing only in a commitment that is not due are the same day view

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, and a second day view is formed on that same date and from that same history, of that same
  commitment followed by one named "Finances" on a schedule on the 25th of the month, also kept from
  1 January 2026
- **THEN** each holds one row named "Gym", saying the commitment is not kept
- **AND** the two are the same day view

#### Scenario: two day views differing only in a tick for a commitment neither was handed are the same day view

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, the first from a history
  that has taken no tick and the second from a history holding a tick on that date for a commitment
  named "Run" on a schedule listing Monday and Thursday, kept from 1 January 2026
- **THEN** each holds one row named "Gym", saying the commitment is not kept
- **AND** the two are the same day view

#### Scenario: a day view does not change when the history it was built from is ticked afterwards

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, from a history that has taken no
  tick, and a tick for that commitment on that date is then added to the history
- **THEN** that day view still holds one row saying the commitment is not kept
- **AND** a day view formed again from the history as it now stands holds one row saying it is kept
- **AND** the two are different day views

#### Scenario: two day views differing only in how their commitments were grouped are different day views

- **WHEN** two day views are formed on Monday 31 August 2026, from a history that has taken no tick,
  each of a commitment named "Creatine" and one named "Magnesium", both on a schedule listing all
  seven weekdays and both kept from 1 January 2026 and handed over in that order — the first with
  both under no category, the second with both in a group under "Supplements"
- **THEN** each holds two rows, named "Creatine" and then "Magnesium"
- **AND** the two are different day views

#### Scenario: two day views differing only in a group none of whose commitments is due are the same day view

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, under no category, and a second day view is formed on that same date and from that
  same history of that same commitment together with a group under "Money" holding one commitment
  named "Finances" on a schedule on the 25th of the month, also kept from 1 January 2026
- **THEN** each holds one group, with no category, holding one row named "Gym"
- **AND** the two are the same day view

#### Scenario: two day views differing only in a one-off standing on another day are the same day view

- **WHEN** a day view is formed on Monday 28 September 2026 as of that same day, from a history that
  has taken no tick, of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, and of one-offs holding nothing; and a second is formed the same way of
  one-offs holding "Send form" on 30 September 2026, not done
- **THEN** the two are the same day view
- **AND** a third formed the same way of one-offs holding "Call mum" on 25 September 2026, not done,
  is a different day view from both
- **AND** a fourth formed the same way and handed no one-offs at all is a different day view from the
  first

### Requirement: What a day screen tells on a row lasts only until the app is shown again, a change is kept, or the day it is showing changes

A day screen SHALL go on telling it, on the same row, until one of exactly three things happens, and
SHALL then tell nothing on any row. Nothing else SHALL end it, time passing included. The app being
shown again SHALL end it, whether or not the record can then be read. A change reaching the record's
place, the one-off place or the birthday place SHALL end it, on whichever row it was made, whatever the change; a copy
restored through a commitments screen is such a change, and SHALL end it once the day screen is
returned to from that commitments screen. The day
being shown changing SHALL end it — the day changing and never the gesture made — so a move with
nowhere to go, and today sent back to today, SHALL leave it standing.

A change that reaches none of those places SHALL NOT end it: a refused value moves what is told rather
than ending it. A commit in a total entry that says nothing is neither an end nor a refusal, so what
was told SHALL stand exactly as it was; closing a number or note entry without committing it SHALL
end nothing either.

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

#### Scenario: what a day screen tells on a row ends when a one-off tick is kept

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place; a day screen
  of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1 January
  2026, is opened at that one-off place as of Monday 28 September 2026, at a record place where
  nothing can be written — a path beneath an existing ordinary file — and a roster place where
  nothing has been kept; its one commitment row is ticked and refused; and its one one-off row is
  then ticked
- **THEN** its One-offs group holds one row, named "Call mum", saying it is done
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a one-off row ends when a commitment tick is kept

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place that is then
  made so that it can be read from but not written to; a day screen of a commitment named
  "Journaling" on a schedule listing all seven weekdays, kept from 1 January 2026, is opened at that
  one-off place as of Monday 28 September 2026, at a record place and a roster place where nothing
  has been kept; its one one-off row is ticked and refused; and its one commitment row is then ticked
- **THEN** its day view says "Journaling" is kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a one-off row stands when returned to and ends when the app is shown again

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place that is then
  made so that it can be read from but not written to; a day screen of no commitments at all is
  opened at that one-off place as of Monday 28 September 2026, at a record place and a roster place
  where nothing has been kept; its one one-off row is ticked and refused; and it is returned to
- **THEN** it still tells, on that one-off row, that the change could not be kept
- **AND** after the app is then shown again as of that same day, it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when a one-off rename is kept, a blank one included

- **WHEN** one-offs named "Call mum" and then "Pay fine", both on 25 September 2026, are added at a
  one-off place; a day screen of a commitment named "Journaling" on a schedule listing all seven
  weekdays, kept from 1 January 2026, is opened at that one-off place as of Monday 28 September 2026,
  at a record place where nothing can be written — a path beneath an existing ordinary file — and a
  roster place where nothing has been kept; its one commitment row is ticked and refused; and
  "Ring mum" is committed in the name field of the row named "Call mum"
- **THEN** its One-offs group holds rows named "Ring mum" and then "Pay fine"
- **AND** it tells nothing on any row
- **AND** after its commitment row is ticked and refused again and a text of blank space alone is
  committed in the name field of the row named "Pay fine", its One-offs group holds one row, named
  "Ring mum", and it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when a birthday tick is kept

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Tuesday 20 January 2026 at a record place where nothing
  can be written — a path beneath an existing ordinary file — and a roster place, a one-off place and
  a birthday place where nothing has been kept, with birthdays on and a calendar holding the contact
  "kate"'s birthday worded "Kate Bell's 48th Birthday" on 20 January 2026; its one commitment row is
  ticked and refused; and its one birthday row is then ticked
- **THEN** its Birthdays group holds one row, saying it is ticked
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a birthday row ends when a commitment tick is kept

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Tuesday 20 January 2026 at a birthday place where nothing
  can be written — a path beneath an existing ordinary file — and a record place, a roster place and
  a one-off place where nothing has been kept, with birthdays on and a calendar holding the contact
  "kate"'s birthday worded "Kate Bell's 48th Birthday" on 20 January 2026; its one birthday row is
  ticked and refused; and its one commitment row is then ticked
- **THEN** its day view says "Journaling" is kept on that date
- **AND** it tells nothing on any row

### Requirement: A day screen re-reads its day and its places when the app is shown again

A day screen SHALL be told when the app has been shown — opened from nothing, or brought back in
front of a person — and SHALL be handed the day it has been shown on. It SHALL then take that day as
its today and form its day view again from the record, the roster and the one-offs read again at
their places, whatever day it is showing, a tick made on it being no such moment. A day screen
showing the day it was last handed as today SHALL show the day it has now been shown on, and one
showing any other day SHALL go on showing that day; that comparison SHALL be made against the today
the screen held before it was told, and against nothing kept for the purpose. A day screen shown
again on the day it is already showing SHALL hold that day's day view, formed again rather than
merely kept.

Reading either place again SHALL be a fresh opening there, so a change made since SHALL be seen, and
what the screen says about the record, about the roster and about its one-offs SHALL each be formed
again from what is then there, the reason included and nothing carried over. A roster read again
that holds nothing at all SHALL have the commitments the screen was handed taken on into it. Nothing
else SHALL survive being shown again: what the screen was opened from and the day it is showing are
all a day screen carries across.

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
  that order and of one-offs holding nothing, on Monday 31 August 2026 as of that same day, from a
  history holding exactly that one tick

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
- **THEN** its day view is the same day view as one formed directly of those two commitments, in
  that order and of one-offs holding nothing, on Sunday 30 August 2026 as of that same day, from a
  history that has taken no tick
- **AND** its day picker opens on Sunday 30 August 2026, and it offers the way back to today

#### Scenario: a day screen moved away and back onto today moves onto the new day when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day before and then to the day after; and the app is then
  shown again as of Wednesday 2 September 2026
- **THEN** its day view is the same day view as one formed directly of those two commitments, in
  that order and of one-offs holding nothing, on Wednesday 2 September 2026 as of that same day,
  from a history that has taken no tick
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

#### Scenario: a day screen shown again carries over no reason it gave for not keeping its record or its roster

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place holding a record
  and a roster place holding a roster, each written in a form one later than the form this app
  writes and holding nothing, of a commitment named "Gym" on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026; what is at each place is then replaced by a run of bytes
  that is not what a record or a roster is written as; and the app is shown again as of Monday
  31 August 2026
- **THEN** it says it is not keeping a record, and does not say the record was written by a later
  version of DayByDay
- **AND** it says it is not keeping a roster, and does not say the roster was written by a later
  version of DayByDay

#### Scenario: a day screen that could not read its one-offs starts keeping them when shown again and they can be read

- **WHEN** a day screen of no commitments at all is opened as of Monday 28 September 2026, at a
  one-off place holding a run of bytes that is not what one-offs are written as, at a record place
  and a roster place where nothing has been kept; what is at that one-off place is then replaced by a
  one-off store holding "Call mum" on 25 September 2026; and the app is shown again as of that same
  day
- **THEN** it says it is keeping one-offs
- **AND** its One-offs group holds one row, named "Call mum"
