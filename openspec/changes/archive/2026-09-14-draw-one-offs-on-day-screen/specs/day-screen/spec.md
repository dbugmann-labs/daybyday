## ADDED Requirements

### Requirement: A day view draws the one-offs standing on its date as one group headed One-offs

A day view MAY be handed one-offs and a today beside its commitments. It SHALL then hold one group
of one-off rows, headed "One-offs" in this package's own words, holding a row for each one-off
standing on its date as of that today, in the order the `one-off` capability answers them; a day
view MUST NOT order them itself. Where none stands on its date it SHALL hold no such group. That
group SHALL NOT be one of its groups of commitments, its rows SHALL NOT be among the commitment rows
it holds, and it SHALL come after every group of commitments. A day view handed no one-offs SHALL
hold no One-offs group. A one-off row SHALL say its one-off's name exactly as given.

#### Scenario: a day view holds a One-offs group of the one-offs standing on its date

- **WHEN** a day view is formed on Monday 28 September 2026 as of that same day, from a history that
  has taken no tick, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept
  from 1 January 2026, and of one-offs holding "Call mum" on 25 September 2026 and "Send form" on
  30 September 2026, neither done
- **THEN** it holds one group of commitments, with no category, holding one row named "Journaling"
- **AND** it holds a One-offs group headed "One-offs", holding one row named "Call mum"
- **AND** its commitment rows are named "Journaling" alone

#### Scenario: a day view of a past day draws no undone one-off owed on that day

- **WHEN** a day view is formed on Friday 25 September 2026 as of Monday 28 September 2026, from a
  history that has taken no tick, of no commitments at all and of one-offs holding "Call mum" on
  25 September 2026, not done
- **THEN** it holds no One-offs group
- **AND** it is the same day view as one formed on that date from that same history of no
  commitments and handed no one-offs

#### Scenario: a day view's one-off rows are in the order one-offs answer them

- **WHEN** a day view is formed on Monday 28 September 2026 as of that same day, from a history that
  has taken no tick, of no commitments at all and of one-offs to which "Send form" on 28 September
  2026, "Call mum" on 25 September 2026 and "Book dentist" on 25 September 2026 were added in that
  order, none done
- **THEN** its One-offs group holds rows named "Call mum", "Book dentist" and then "Send form"
- **AND** it holds no group of commitments and no commitment rows

### Requirement: A one-off row says how late it is while undone, and offers its tick where its day has arrived

A one-off row SHALL say whether its one-off is done. In the place a commitment row says its rhythm,
it SHALL say how many days late its one-off is where the one-off is not done and the row's date is
later than the one-off's date, and SHALL say nothing there otherwise. The count SHALL be the row's
date less the one-off's date in calendar days, said "1 day late" for one and "N days late" for any
other number, however large, and MUST NOT be said in weeks, months or as a date. A one-off row
SHALL offer its tick when asked as of a today no earlier than its date, whether or not its one-off is
done, and SHALL offer none when asked as of an earlier today; the day it is asked as of SHALL be
given to it. A row offering no tick SHALL still be held.

#### Scenario: an undone one-off row on a day after its date says how many days late it is

- **WHEN** a day view is formed on Monday 28 September 2026 as of that same day, of no commitments at
  all and of one-offs holding "Call mum" on 25 September 2026 and "Call dad" on 27 September 2026,
  neither done
- **THEN** the row named "Call mum" says "3 days late" and says it is not done
- **AND** the row named "Call dad" says "1 day late"

#### Scenario: a one-off row late by more than a year still says days

- **WHEN** a day view is formed on Monday 28 September 2026 as of that same day, of no commitments at
  all and of one-offs holding "Renew passport" on 24 August 2025, not done
- **THEN** its one row says "400 days late"

#### Scenario: a one-off row on its own date says nothing in the rhythm's place

- **WHEN** a day view is formed on Monday 28 September 2026 as of that same day, of no commitments at
  all and of one-offs holding "Send form" on 28 September 2026, not done
- **THEN** its one row says nothing in the rhythm's place
- **AND** the row of a day view formed the same way on Wednesday 30 September 2026, of one-offs
  holding "Pay fine" on 30 September 2026, says nothing there either

#### Scenario: a one-off ticked late says nothing in the rhythm's place on the day it was ticked

- **WHEN** a day view is formed on Monday 28 September 2026 as of Monday 5 October 2026, of no
  commitments at all and of one-offs holding "Call mum" on 25 September 2026, ticked on
  28 September 2026
- **THEN** its one row says it is done and says nothing in the rhythm's place
- **AND** a day view formed on that same date as of 28 September 2026 holds a row saying the same

#### Scenario: a one-off row offers its tick where its day has arrived, done or not

- **WHEN** a day view is formed on Monday 28 September 2026 as of that same day, of no commitments at
  all and of one-offs holding "Call mum" on 25 September 2026, not done, and "Call dad" on
  28 September 2026, ticked on 28 September 2026, and each row is asked as of that same day
- **THEN** both rows offer their tick
- **AND** a row of "Pay fine" on 30 September 2026, not done, in a day view formed on that date as of
  28 September 2026, offers no tick asked as of 28 September 2026 and offers one asked as of
  30 September 2026
- **AND** the row of "Call dad" in a day view formed on 28 September 2026 as of 5 October 2026 offers
  its tick asked as of 5 October 2026

### Requirement: A one-off row is its one-off, its date and whether it is done

A one-off row SHALL be its one-off, its day view's date and whether its one-off is done. Two one-off
rows SHALL be the same row exactly when all three agree, and SHALL be different rows when any one
differs. A one-off row SHALL give back its name, what it says in the rhythm's place, whether its
one-off is done and whether it offers its tick, and MUST NOT give back the one-off, the one-off's
date or the row's date.

#### Scenario: two one-off rows alike in one-off, date and whether done are the same row

- **WHEN** two day views are formed on Monday 28 September 2026 as of that same day, each of no
  commitments at all and of one-offs holding "Call mum" on 25 September 2026, the first with it not
  done and the second with it not done either
- **THEN** the two one-off rows are the same row
- **AND** a third day view formed the same way with "Call mum" ticked on 28 September 2026 holds a
  row that is a different row from both

#### Scenario: two one-off rows of one one-off on different dates are different rows

- **WHEN** a day view is formed on Monday 28 September 2026 as of that same day and another on
  Tuesday 29 September 2026 as of that same day, each of no commitments at all and of one-offs
  holding "Call mum" on 25 September 2026, not done
- **THEN** the first row says "3 days late" and the second says "4 days late"
- **AND** the two rows are different rows

### Requirement: A day screen keeps its one-offs at its own place, beside its record and its roster

A day screen SHALL name the place it keeps its one-offs at, and MUST NOT leave that choice to
whatever draws it. The place SHALL be one file inside a directory belonging to this app, within the
directory the platform reserves for an application's own supporting data — `Application Support` —
so that its contents survive the app being closed, being force-quit and the device being restarted,
and are carried in a backup of the device. It MUST NOT be the caches directory and MUST NOT be the
temporary directory. It SHALL be the same place every time it is asked for, and SHALL be neither the
place the day screen keeps its record at nor the place it keeps its roster at.

#### Scenario: the place a day screen keeps its one-offs is a file of the app's own under Application Support

- **WHEN** the place a day screen keeps its one-offs at is asked for
- **THEN** it is one file inside a directory of this app's own within the platform's
  application-support directory, rather than directly inside it
- **AND** it is not inside the platform's caches directory, and not inside the temporary directory

#### Scenario: the place a day screen keeps its one-offs is the same place every time it is asked

- **WHEN** the place a day screen keeps its one-offs at is asked for twice
- **THEN** the two are the same place

#### Scenario: the place a day screen keeps its one-offs is neither its record place nor its roster place

- **WHEN** the places a day screen keeps its one-offs, its record and its roster at are all asked for
- **THEN** the three are three different places

### Requirement: A day screen draws the one-offs at its one-off place as of the today it was handed

A day screen SHALL form its day view, and the day views either side of it, from the one-offs held at
its one-off place as of the today it was last handed, and never as of the day it is showing. It
SHALL open that place when it is opened and when the app is shown again, and at no other moment:
being moved, being sent back to today, a day being picked, being returned to and saying the day
either side SHALL NOT open it. Opening it SHALL write nothing there and take nothing on. A day
screen that could read its one-offs SHALL say it is keeping them. The one-offs it holds MUST NOT
move the reach of its day picker.

#### Scenario: a day screen draws the one-offs kept at its one-off place on the today it was handed

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place, and a day
  screen of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is opened at that one-off place as of Monday 28 September 2026, at a record place
  and a roster place where nothing has been kept
- **THEN** its day view holds one row named "Journaling" and a One-offs group holding one row named
  "Call mum", saying "3 days late"
- **AND** it says it is keeping one-offs

#### Scenario: a day screen moved off today draws no undone late one-off and draws one owed ahead on its date

- **WHEN** one-offs named "Call mum" on 25 September 2026 and "Pay fine" on 30 September 2026 are
  added at a one-off place, and a day screen of a commitment named "Journaling" on a schedule
  listing all seven weekdays, kept from 1 January 2026, is opened at that one-off place as of Monday
  28 September 2026, at a record place and a roster place where nothing has been kept; and it is
  moved to the day before
- **THEN** its day view holds no One-offs group
- **AND** the day view it says of the day after holds a One-offs group holding one row, named
  "Call mum"
- **AND** after Wednesday 30 September 2026 is picked, its One-offs group holds one row, named
  "Pay fine", saying nothing in the rhythm's place and offering no tick as of 28 September 2026

#### Scenario: a day screen opened where no one-offs have been kept writes nothing at its one-off place

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Monday 28 September 2026, at a one-off place, a record
  place and a roster place where nothing has been kept
- **THEN** its day view holds no One-offs group
- **AND** it says it is keeping one-offs
- **AND** nothing has been kept at its one-off place

#### Scenario: a day screen reads its one-off place again when shown and not when returned to

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Monday 28 September 2026, at a one-off place, a record
  place and a roster place where nothing has been kept; a one-off named "Call mum" on 25 September
  2026 is then added at that one-off place by something else; and the day screen is returned to
- **THEN** its day view holds no One-offs group
- **AND** after the app is shown again as of that same day, its One-offs group holds one row, named
  "Call mum"

#### Scenario: a day screen shown again on a later day draws a one-off that has followed today

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place; a day screen
  of no commitments at all is opened at that one-off place as of Friday 25 September 2026, at a
  record place and a roster place where nothing has been kept; and the app is shown again as of
  Monday 28 September 2026
- **THEN** its One-offs group holds one row, named "Call mum", saying "3 days late"
- **AND** before it was shown again, that group's one row said nothing in the rhythm's place

#### Scenario: a day screen's one-offs do not move the reach of its day picker

- **WHEN** a one-off named "Renew passport" on 1 January 2020 is added at a one-off place, and a day
  screen of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is opened at that one-off place as of Monday 28 September 2026, at a record place
  and a roster place where nothing has been kept
- **THEN** its day picker reaches back to 1 January 2026
- **AND** its One-offs group holds one row, named "Renew passport"

### Requirement: A day screen that cannot read its one-offs draws its commitments and no One-offs group

Opening a day screen at a one-off place holding something that cannot be read as one-offs SHALL give
a day screen rather than an error. It SHALL draw its commitments exactly as it would otherwise, hold
no One-offs group on any day, say that it is not keeping one-offs, and leave what is at that place
exactly as it was. It SHALL say which of two things is so: the one-offs were written by a later
version of DayByDay, or they only could not be read; it MUST NOT tell any other reason apart, nor
name a later version for any other refusal. What a day screen says about its one-offs SHALL be read
off the one-off place alone, and what it says about its record and its roster SHALL NOT be read off
that place.

#### Scenario: a day screen whose one-off place cannot be read draws its commitments and no One-offs group

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Monday 28 September 2026, at a one-off place holding a
  run of bytes that is not what one-offs are written as, at a record place and a roster place where
  nothing has been kept
- **THEN** its day view holds one row, named "Journaling", and no One-offs group
- **AND** it says it is not keeping one-offs, and does not say they were written by a later version
  of DayByDay
- **AND** it says it is keeping a record and keeping a roster
- **AND** the content at that one-off place is byte-for-byte what it was before the screen was opened
- **AND** a day screen opened the same way at a one-off place that is a directory holding nothing
  says the same, and that place is still a directory holding nothing

#### Scenario: one-offs written in a later form make a day screen that says they are from a later version

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Monday 28 September 2026, at a one-off place holding a
  one-off store written in a form one later than the form this app writes, holding no one-offs, at a
  record place and a roster place where nothing has been kept
- **THEN** it says it is not keeping one-offs
- **AND** it says the one-offs were written by a later version of DayByDay
- **AND** its day view holds one row, named "Journaling", and no One-offs group
- **AND** the content at that one-off place is byte-for-byte what it was before the screen was opened

#### Scenario: a day screen that cannot read its record still draws and ticks its one-offs

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place, and a day
  screen of no commitments at all is opened at that one-off place as of Monday 28 September 2026, at
  a record place holding a run of bytes that is not what a record is written as and a roster place
  where nothing has been kept; and its one one-off row is ticked
- **THEN** it says it is not keeping a record and says it is keeping one-offs
- **AND** its One-offs group holds one row, named "Call mum", saying it is done

### Requirement: A day screen makes and takes back a one-off row's tick on the today, and keeps the change before the day view says so

A day screen SHALL make the tick a one-off row offers where its one-off is not done, and SHALL take
that tick back where it is done; which of the two SHALL be read off the row. A tick SHALL record the
today the screen was last handed and MUST NOT record the day being shown. The change SHALL be kept
at the one-off place before the day view says so, every day view then being formed again from the
one-offs as they stand. A change that could not be kept SHALL be refused to the caller and SHALL
leave the day view as it was. A one-off row the screen's day view does not hold, and one offering no
tick as of that today, SHALL change nothing and SHALL throw nothing. A one-off change MUST NOT write
to the record's place or the roster's.

#### Scenario: ticking a late one-off row keeps it done on the today and it says nothing late

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place; a day screen
  of no commitments at all is opened at that one-off place as of Monday 28 September 2026, at a
  record place and a roster place where nothing has been kept; and its one one-off row is ticked
- **THEN** its One-offs group holds one row, named "Call mum", saying it is done and saying nothing
  in the rhythm's place
- **AND** a one-off store opened afterwards at that one-off place holds "Call mum" standing on
  28 September 2026 as of 5 October 2026
- **AND** nothing has been kept at its record place or its roster place

#### Scenario: a one-off tick taken back on a past day leaves that day and stands on today again

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place and ticked
  there on 25 September 2026; a day screen of a commitment named "Journaling" on a schedule listing
  all seven weekdays, kept from 1 January 2026, is opened at that one-off place as of Monday
  28 September 2026, at a record place and a roster place where nothing has been kept; Friday
  25 September 2026 is picked; and its one one-off row is ticked
- **THEN** its day view holds no One-offs group
- **AND** sent back to today, its One-offs group holds one row, named "Call mum", saying it is not
  done and saying "3 days late"

#### Scenario: a one-off tick that cannot be kept is refused and leaves the day view as it was

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place that is then
  made so that it can be read from but not written to, and a day screen of no commitments at all is opened at that
  one-off place as of Monday 28 September 2026, at a record place and a roster place where nothing
  has been kept; and its one one-off row is ticked
- **THEN** ticking is refused with an error
- **AND** its One-offs group still holds one row, named "Call mum", saying it is not done
- **AND** a one-off store opened afterwards at that place holds "Call mum" not done

#### Scenario: ticking a one-off row that the day view does not hold or that offers no tick changes nothing

- **WHEN** one-offs named "Call mum" on 25 September 2026 and "Pay fine" on 29 September 2026 are
  added at a one-off place; two day screens of no commitments at all are opened at that one-off
  place, the first as of Monday 28 September 2026 and the second as of Tuesday 29 September 2026,
  each at a record place and a roster place of its own where nothing has been kept; the second
  screen's row named "Call mum" is ticked on the first screen; and the first screen is then moved
  to the day after and its own row named "Pay fine", which offers no tick as of 28 September 2026,
  is ticked
- **THEN** neither ticking is refused with an error
- **AND** the first screen's One-offs group still holds one row, named "Pay fine", saying it is not
  done
- **AND** sent back to today, its One-offs group holds one row, named "Call mum", saying it is not
  done
- **AND** the content at that one-off place is byte-for-byte what it was before either was ticked

### Requirement: A day screen tells on the one-off row that was tapped that its change could not be kept

Where a one-off change cannot be kept, a day screen SHALL tell it on the one-off row tapped as well
as refusing it to the caller, and what it tells SHALL name no cause. A day screen SHALL tell at most
one row at a time, whether a commitment row or a one-off row: a refusal on a one-off row SHALL move
what is told onto that row and leave nothing told on any commitment row, and a refusal on a
commitment row SHALL leave nothing told on any one-off row. Telling on a one-off row MUST NOT change
what a day screen says about keeping one-offs.

#### Scenario: a refused one-off tick is told on its row and ends what was told on a commitment row

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place that is then
  made so that it can be read from but not written to; a day screen of a commitment named "Journaling" on a schedule
  listing all seven weekdays, kept from 1 January 2026, is opened at that one-off place as of Monday
  28 September 2026, at a record place where nothing can be written — a path beneath an existing
  ordinary file — and a roster place where nothing has been kept; its one commitment row is ticked
  and refused; and its one one-off row is then ticked
- **THEN** ticking the one-off row is refused with an error
- **AND** it tells, on the one-off row, that the change could not be kept, naming no cause
- **AND** it tells nothing on the commitment row
- **AND** it still says it is keeping one-offs

#### Scenario: a refused commitment tick ends what was told on a one-off row

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place that is then
  made so that it can be read from but not written to; a day screen of a commitment named "Journaling" on a schedule
  listing all seven weekdays, kept from 1 January 2026, is opened at that one-off place as of Monday
  28 September 2026, at a record place where nothing can be written — a path beneath an existing
  ordinary file — and a roster place where nothing has been kept; its one one-off row is ticked and
  refused; and its one commitment row is then ticked
- **THEN** it tells, on the commitment row, that the change could not be kept
- **AND** it tells nothing on the one-off row

## MODIFIED Requirements

### Requirement: A day screen holds the day view of the day it was handed, formed from the record kept at its place

A day screen SHALL be opened from five things: some commitments, the day it is being opened on, the
place its record is kept at, the place its roster is kept at and the place its one-offs are kept at.
It SHALL hold the day view of that day, of the commitments its roster answers with on it and of the
one-offs held at its one-off place, formed from the history held at the record's place, and SHALL
give that day view back whole and unaltered. The commitments it is opened from
SHALL be the ones it takes on when its roster holds nothing at all, and SHALL NOT be a list it
draws.

The today SHALL be given to a day screen and never asked for, this capability reading no clock and
consulting no time zone or locale. A day screen SHALL hold two separate days: the today it was
handed, as of which every question it asks is asked, and the day it is showing, which SHALL begin as
that same today and SHALL be the one a move changes. A day screen MUST NOT keep only one of them. It
SHALL hold the day it is showing until it is moved, a day is picked, or the app is shown again, and
SHALL be moved onto another day by nothing else, neither by time passing nor by a tick made on it;
its today SHALL be replaced only when the app is shown again.

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

### Requirement: A day view is a value and nothing else

A day view SHALL be the groups it holds, its One-offs group where it holds one, and the calendar
date it was formed on, and nothing else. Two day views SHALL be the same day view when they are of
the same date and hold the same groups in the same order, each group holding the same rows in the
same order, and the same One-offs group or none, and SHALL be different when any of that differs; two day views holding the same rows in the same order under different groupings
SHALL therefore be two day views.

A difference in what a day view was handed that does not reach a row SHALL make no difference to the
day view: a commitment not due produces no row, a group none of whose commitments is due produces no
group, and a tick for a commitment the day view was not handed is never looked up, and a one-off standing
on another day produces no one-off row, so a day view handed any of the four SHALL be the same day
view as one that was not. A day view SHALL be an
answer given from a history as it stood rather than a window onto one, and ticking that history
afterwards MUST NOT change the day view.

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
  has taken no tick, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept
  from 1 January 2026, handed no one-offs; and a second is formed the same way of one-offs holding
  "Send form" on 30 September 2026, not done
- **THEN** the two are the same day view
- **AND** a third formed the same way of one-offs holding "Call mum" on 25 September 2026, not done,
  is a different day view from both

### Requirement: A day screen re-reads its day and its places when the app is shown again

A day screen SHALL be told when the app has been shown — opened from nothing, or brought back in
front of a person — and SHALL be handed the day it has been shown on. It SHALL then take that day as
its today and form its day view again from the record, the roster and the one-offs read again at their places,
whatever day it is showing, a tick made on it being no such moment. A day screen showing the day it
was last handed as today SHALL show the day it has now been shown on, and one showing any other day
SHALL go on showing that day; that comparison SHALL be made against the today the screen held before
it was told, and against nothing kept for the purpose. A day screen shown again on the day it is
already showing SHALL hold that day's day view, formed again rather than merely kept.

Reading either place again SHALL be a fresh opening there, so a change made since SHALL be seen, and
what the screen says about the record, about the roster and about its one-offs SHALL each be formed
again from what is
then there, the reason included and nothing carried over. A roster read again that holds nothing at
all SHALL have the commitments the screen was handed taken on into it. Nothing else SHALL survive
being shown again: those commitments, the three places and the day it is showing are all a day screen
carries across.

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

### Requirement: What a day screen tells on a row lasts only until the app is shown again, a change is kept, or the day it is showing changes

A day screen SHALL go on telling it, on the same row, until one of exactly three things happens, and
SHALL then tell nothing on any row. Nothing else SHALL end it, time passing included. The app being
shown again SHALL end it, whether or not the record can then be read. A change reaching the record's
place or the one-off place SHALL end it, on whichever row it was made, whatever the change. The day
being shown changing
SHALL end it — the day changing and never the gesture made — so a move with nowhere to go, and today
sent back to today, SHALL leave it standing.

A change that reaches neither place SHALL NOT end it: a refused value moves what is told rather
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

### Requirement: A day screen tells nothing on a row where there was no change to refuse

A tap or a commit that reaches no place is not a refused change: apart from the four causes named
above, a day screen SHALL tell nothing on its row and SHALL NOT end what it is already telling on
another row. It SHALL tell nothing for a tap or commit on a day screen not keeping a record, whatever
the reason its store would not open and whatever was committed, a refused value included; for one on
a row for a day that has not arrived; for one on a row the screen's day view does not hold; and for a
commit on a row that offers no entry at all, or a take-back asked of a row offering none, whatever makes it offer none. A commit in a total entry that says nothing SHALL
likewise be told nothing and SHALL NOT end what is already told.

#### Scenario: a tap on a day screen that is not keeping a record is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
- **THEN** the day screen tells nothing on any row
- **AND** it says it is not keeping a record

#### Scenario: a tap on a day screen holding a record from a later version is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a record written
  in a form one later than the form this app writes, holding no ticks, of a commitment named "Gym"
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row
  is ticked
- **THEN** the day screen tells nothing on any row
- **AND** it says the record was written by a later version of DayByDay

#### Scenario: a tap on a row for a day that has not arrived is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; it is moved to the day after; and
  its one row is ticked
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on Tuesday 1 September 2026

#### Scenario: a tap on a row a day screen's day view does not hold does not end what is already told

- **WHEN** two day screens of a commitment named "Journaling" on a schedule listing all seven
  weekdays, kept from 1 January 2026, are opened at one place where nothing can be written — a
  path beneath an existing ordinary file — the first as of Monday 31 August 2026 and the second as
  of Wednesday 2 September 2026; the first screen's own row is ticked; and the second screen's row
  is then ticked on the first screen
- **THEN** the first day screen still tells, on its own row, that the change could not be kept

#### Scenario: a commit on a row for a day that has not arrived is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026; it is moved to the day after; and "300" is
  committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on Tuesday 1 September 2026

#### Scenario: a commit on a row a day screen's day view does not hold is told nothing and does not end what is already told

- **WHEN** two day screens of a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing all seven weekdays, kept from 1 January 2026, are opened at one place
  where nothing has been kept, the first as of Monday 31 August 2026 and the second as of
  Wednesday 2 September 2026; "300" is committed on the first screen's own row; and "1.2.3" is
  then committed on the first screen, on the second screen's row
- **THEN** the first day screen still tells, on its own row, that the number must be between 40
  and 150

#### Scenario: a commit on a row that offers no entry at all is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and "Ran 8k." is committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on that date
- **AND** committing "30" and then nothing at all on that row tells nothing on any row either

#### Scenario: a commit on a note row for a day that has not arrived is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing all seven weekdays,
  kept from 1 January 2026; it is moved to the day after; and "Ran 8k." is committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on Tuesday 1 September 2026

#### Scenario: a commit on a total row on a day screen that is not keeping a record is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and
  "30" is committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** it says it is not keeping a record
- **AND** committing "0", then "1.2.3", then nothing at all on that row tells nothing on any row
  either
- **AND** taking that row's last addition back tells nothing on any row either

#### Scenario: a commit on a total row for a day that has not arrived is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing all seven weekdays, kept from 1 January 2026; it is moved to the day after; and "0" is
  committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on Tuesday 1 September 2026
- **AND** taking that row's last addition back tells nothing on any row either

#### Scenario: taking back on a row that offers no take-back is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" of the tick kind
  and a commitment named "Protein" of the total kind with a target of 120, in that order and both on
  a schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026; the first row
  is ticked and refused; and the last addition is then taken back on the second row, whose day holds
  none
- **THEN** the day screen still tells, on the first row, that the change could not be kept
- **AND** it tells nothing on the second row

#### Scenario: a commit on a day screen holding a record from a later version is told nothing whatever was committed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a record written
  in a form one later than the form this app writes, holding nothing, of a commitment named "Weight"
  of the number kind with a range of 40 to 150, one named "Journal" of the note kind and one named
  "Protein" of the total kind with a target of 120, all three on a schedule listing Monday,
  Wednesday and Saturday and kept from 1 January 2026; and "300" and then "1.2.3" are committed on
  the row named "Weight", "Ran 8k." and then nothing at all on the row named "Journal", and "0" on
  the row named "Protein"
- **THEN** no commit is refused with an error
- **AND** the day screen tells nothing on any row
- **AND** it says the record was written by a later version of DayByDay

#### Scenario: a tick on a one-off row a day screen's day view does not hold does not end what is already told

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place; two day
  screens of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, are opened at that one-off place, the first as of Monday 28 September 2026 at a
  record place where nothing can be written — a path beneath an existing ordinary file — and the
  second as of Tuesday 29 September 2026 at a record place of its own where nothing has been kept,
  each at a roster place of its own where nothing has been kept; the first screen's commitment row is
  ticked and refused; and the second screen's one-off row is then ticked on the first screen
- **THEN** the first day screen still tells, on its commitment row, that the change could not be kept
- **AND** it tells nothing on its one-off row
