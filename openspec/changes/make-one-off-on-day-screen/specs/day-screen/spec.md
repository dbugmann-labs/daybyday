## ADDED Requirements

### Requirement: A day screen adds a one-off committed in its one-off entry on the day it is showing

A day screen SHALL add a one-off named what is committed in its one-off entry, with blank space at
both ends disregarded, dated the day it is showing and no other day. Where that day is earlier than
the today it was last handed, the one-off SHALL be added already done on that day; on that today or
a later day it SHALL be added not done. The addition SHALL be kept at the one-off place before the
day view says so, every day view then being formed again, and, as every change reaching that place
does, SHALL end what the screen tells on a row. A commit saying nothing SHALL add nothing, write
nothing and tell nothing, and SHALL leave whatever is already told as it was. A day screen not
keeping one-offs SHALL add nothing, throw nothing and tell nothing, whatever is committed.

#### Scenario: a one-off committed in the one-off entry on today is added not done on today

- **WHEN** a day screen of no commitments at all is opened as of Monday 28 September 2026, at a
  one-off place, a record place and a roster place where nothing has been kept, and "Call mum" is
  committed in its one-off entry
- **THEN** its One-offs group holds one row, named "Call mum", saying it is not done and saying
  nothing in the rhythm's place
- **AND** a one-off store opened afterwards at that one-off place holds "Call mum" on 28 September
  2026, standing on 5 October 2026 as of 5 October 2026
- **AND** nothing has been kept at its record place or its roster place

#### Scenario: a one-off committed on a later day is added not done on that day and offers no tick

- **WHEN** a day screen of no commitments at all is opened as of Monday 28 September 2026, at a
  one-off place, a record place and a roster place where nothing has been kept; it is moved to the
  day after; and "Send form" is committed in its one-off entry
- **THEN** its One-offs group holds one row, named "Send form", saying it is not done and offering no
  tick as of 28 September 2026
- **AND** sent back to today, its One-offs group holds no rows
- **AND** a one-off store opened afterwards at that one-off place holds "Send form" on 29 September
  2026, not done

#### Scenario: a one-off committed on a past day is added already done on that day and stays on it

- **WHEN** a day screen of no commitments at all is opened as of Monday 28 September 2026, at a
  one-off place, a record place and a roster place where nothing has been kept; it is moved to the
  day before; and "Call mum" is committed in its one-off entry
- **THEN** its One-offs group holds one row, named "Call mum", saying it is done
- **AND** sent back to today, its One-offs group holds no rows
- **AND** a one-off store opened afterwards at that one-off place holds "Call mum" on 27 September
  2026, standing on 27 September 2026 as of 5 October 2026

#### Scenario: blank space around a name committed in the one-off entry is not part of the one-off added

- **WHEN** a day screen of no commitments at all is opened as of Monday 28 September 2026, at a
  one-off place, a record place and a roster place where nothing has been kept, and a text of two
  spaces, then "Call mum", then one space is committed in its one-off entry
- **THEN** its One-offs group holds one row, named "Call mum"
- **AND** a one-off store opened afterwards at that one-off place holds a one-off named "Call mum" on
  28 September 2026 and none whose name has blank space at either end

#### Scenario: a commit saying nothing in the one-off entry adds nothing and tells nothing

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Monday 28 September 2026, at a record place where
  nothing can be written — a path beneath an existing ordinary file — and a one-off place and a
  roster place where nothing has been kept; its one commitment row is ticked and refused; and an
  empty text and then a text of blank space alone are committed in its one-off entry
- **THEN** its One-offs group holds no rows
- **AND** it tells nothing under its one-off entry
- **AND** it still tells, on its commitment row, that the change could not be kept
- **AND** nothing has been kept at its one-off place

#### Scenario: a day screen not keeping one-offs adds nothing whatever is committed in its one-off entry

- **WHEN** a day screen of no commitments at all is opened as of Monday 28 September 2026, at a
  one-off place holding a run of bytes that is not what one-offs are written as, at a record place
  and a roster place where nothing has been kept, and "Call mum" is committed in its one-off entry
- **THEN** committing is not refused with an error
- **AND** its day view holds no One-offs group, and it tells nothing under its one-off entry
- **AND** the content at that one-off place is byte-for-byte what it was before the screen was opened
- **AND** a day screen opened the same way at a one-off place holding a one-off store written in a
  form one later than the form this app writes says and keeps the same

#### Scenario: a one-off added ends what a day screen tells on a row

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Monday 28 September 2026, at a record place where
  nothing can be written — a path beneath an existing ordinary file — and a one-off place and a
  roster place where nothing has been kept; its one commitment row is ticked and refused; and
  "Call mum" is committed in its one-off entry
- **THEN** its One-offs group holds one row, named "Call mum"
- **AND** it tells nothing on any row

### Requirement: A day screen refuses an add or a rename it cannot make, and tells it under the field it was committed in

Where a one-off with the committed name, blank space at both ends disregarded, is already held on
the date an add or a rename would give, done or not and wherever it stands, the add or rename SHALL
be refused without an error and keep nothing, and the screen SHALL tell "Already on this day". Where
an add or a rename, a rename committed saying nothing included, cannot be kept at the one-off place,
it SHALL be refused to the caller with an error, keep nothing, and be told naming no cause. What is
told SHALL be told under the one-off entry for an add and under the row's name field for a rename,
and SHALL carry the text committed exactly as it was typed. It SHALL NOT be what the screen tells on
a row, and neither SHALL end, move or replace the other.

#### Scenario: an add of a name already held on the day shown is refused and told under the one-off entry

- **WHEN** a one-off named "Call mum" on 28 September 2026 is added at a one-off place; a day screen
  of no commitments at all is opened at that one-off place as of Monday 28 September 2026, at a
  record place and a roster place where nothing has been kept; and "Call mum" followed by one space
  is committed in its one-off entry
- **THEN** committing is not refused with an error
- **AND** its One-offs group holds one row, named "Call mum"
- **AND** it tells, under its one-off entry, "Already on this day", carrying the text "Call mum"
  followed by one space
- **AND** the content at that one-off place is byte-for-byte what it was before the commit
- **AND** where "Call mum" on 28 September 2026 was added there already done on that day, the commit
  is refused and told the same way

#### Scenario: an add is refused on a past day where a one-off of that name owed there now stands on today

- **WHEN** a one-off named "Call mum" on 25 September 2026, not done, is added at a one-off place; a
  day screen of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is opened at that one-off place as of Monday 28 September 2026, at a record place
  and a roster place where nothing has been kept; Friday 25 September 2026 is picked; and "Call mum"
  is committed in its one-off entry
- **THEN** it tells, under its one-off entry, "Already on this day"
- **AND** its One-offs group holds no rows
- **AND** sent back to today, with "Call mum" committed in its one-off entry again, its One-offs
  group holds two rows named "Call mum", the first saying "3 days late" and the second saying
  nothing in the rhythm's place

#### Scenario: an add that cannot be kept is refused with an error and told under the one-off entry beside what is told on a row

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Monday 28 September 2026, at a record place where
  nothing can be written — a path beneath an existing ordinary file — at a one-off place that can be
  read from but not written to and where nothing has been kept, and at a roster place where nothing
  has been kept; its one commitment row is ticked and refused; and "Call mum" is committed in its
  one-off entry
- **THEN** committing is refused with an error
- **AND** it tells, under its one-off entry, that the one-off could not be kept, naming no cause and
  carrying the text "Call mum"
- **AND** it still tells, on its commitment row, that the change could not be kept
- **AND** its One-offs group holds no rows

#### Scenario: a rename onto a one-off already held is refused and told under its row, which keeps its name

- **WHEN** one-offs named "Call mum" and then "Ring mum", both on 28 September 2026, are added at a
  one-off place; a day screen of no commitments at all is opened at that one-off place as of Monday
  28 September 2026, at a record place and a roster place where nothing has been kept; and
  "Ring mum" is committed in the name field of the row named "Call mum"
- **THEN** committing is not refused with an error
- **AND** its One-offs group holds rows named "Call mum" and then "Ring mum"
- **AND** it tells, under the name field of the row named "Call mum", "Already on this day",
  carrying the text "Ring mum"
- **AND** it tells nothing under its one-off entry
- **AND** the content at that one-off place is byte-for-byte what it was before the commit

#### Scenario: a rename that cannot be kept is refused with an error and told under its row

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place that is then
  made so that it can be read from but not written to; a day screen of no commitments at all is
  opened at that one-off place as of Monday 28 September 2026, at a record place and a roster place
  where nothing has been kept; and "Ring mum" is committed in the name field of its one one-off row
- **THEN** committing is refused with an error
- **AND** it tells, under that row's name field, that the one-off could not be kept, naming no cause
  and carrying the text "Ring mum"
- **AND** it tells nothing on any row
- **AND** its One-offs group still holds one row, named "Call mum"
- **AND** a text of blank space alone committed in that name field is refused and told the same way,
  and that row is still held

### Requirement: What a day screen tells under a one-off name field lasts until its text is edited, the day it is showing changes, or the app is shown again

What a day screen tells under its one-off entry or under a one-off row's name field SHALL stand
until the text in that field is edited, a commit from that field is kept, the day being shown
changes, or the app is shown again, and SHALL then be told no longer. The day changing, and never
the gesture made, SHALL end it, so a screen on its today sent back to today SHALL leave it standing.
Nothing else SHALL end it: a change kept on a row or from another field, a refusal told on a row,
and being returned to SHALL NOT. A day screen SHALL tell under at most one one-off name field at a
time, and a refusal in another field SHALL replace what it was telling. What is told under a row's
name field SHALL also end when the day view no longer holds that row.

#### Scenario: what is told under the one-off entry stands when a change is kept on a row or from another field and when returned to

- **WHEN** one-offs named "Pay fine" on 25 September 2026 and "Call mum" on 28 September 2026 are
  added at a one-off place; a day screen of a commitment named "Journaling" on a schedule listing all
  seven weekdays, kept from 1 January 2026, is opened at that one-off place as of Monday
  28 September 2026, at a record place and a roster place where nothing has been kept; "Call mum" is
  committed in its one-off entry and refused; its commitment row is ticked; "Pay the fine" is
  committed in the name field of the row named "Pay fine"; and it is returned to
- **THEN** it still tells, under its one-off entry, "Already on this day"
- **AND** its day view says "Journaling" is kept on that date
- **AND** its One-offs group holds rows named "Pay the fine" and then "Call mum"

#### Scenario: what is told under a one-off name field ends when its text is edited or a commit from it is kept

- **WHEN** a one-off named "Call mum" on 28 September 2026 is added at a one-off place; a day screen
  of no commitments at all is opened at that one-off place as of Monday 28 September 2026, at a
  record place and a roster place where nothing has been kept; "Call mum" is committed in its one-off
  entry and refused; and the text in its one-off entry is then edited
- **THEN** it tells nothing under its one-off entry or under any one-off row's name field
- **AND** its One-offs group holds one row, named "Call mum"
- **AND** after "Call mum" is committed in its one-off entry and refused again, and "Call dad" is
  committed there with no edit told between, its One-offs group holds rows named "Call mum" and then
  "Call dad", and it tells nothing under its one-off entry

#### Scenario: what is told under a one-off name field ends when the day being shown changes and stands when today is sent back to today

- **WHEN** a one-off named "Call mum" on 28 September 2026 is added at a one-off place; a day screen
  of no commitments at all is opened at that one-off place as of Monday 28 September 2026, at a
  record place and a roster place where nothing has been kept; "Call mum" is committed in its one-off
  entry and refused; and it is sent back to today without having been moved
- **THEN** it still tells, under its one-off entry, "Already on this day"
- **AND** after it is moved to the day after, it tells nothing under its one-off entry
- **AND** a day screen opened the same way, on which "Call mum" is committed and refused and
  Wednesday 30 September 2026 is then picked, tells nothing under its one-off entry

#### Scenario: what is told under a one-off name field ends when the app is shown again

- **WHEN** a one-off named "Call mum" on 28 September 2026 is added at a one-off place; a day screen
  of no commitments at all is opened at that one-off place as of Monday 28 September 2026, at a
  record place and a roster place where nothing has been kept; "Call mum" is committed in its one-off
  entry and refused; and the app is shown again as of that same day
- **THEN** it tells nothing under its one-off entry
- **AND** its One-offs group holds one row, named "Call mum"

#### Scenario: a refusal under one one-off name field replaces what is told under another, and ends when its row is no longer held

- **WHEN** one-offs named "Call mum" and then "Ring mum", both on 28 September 2026, are added at a
  one-off place; a day screen of no commitments at all is opened at that one-off place as of Monday
  28 September 2026, at a record place and a roster place where nothing has been kept; "Call mum" is
  committed in its one-off entry and refused; and "Ring mum" is then committed in the name field of
  the row named "Call mum" and refused
- **THEN** it tells, under the name field of the row named "Call mum", "Already on this day"
- **AND** it tells nothing under its one-off entry
- **AND** after the row named "Call mum" is ticked, it tells nothing under its one-off entry or under
  any one-off row's name field

### Requirement: A day screen renames and removes the one-off a row holds, on any day and done or not

A day screen SHALL rename the one-off a one-off row holds to the text committed in that row's name
field, with blank space at both ends disregarded, and SHALL remove that one-off outright when removal
is asked of the row. Either SHALL be made on any one-off row its day view holds, done or not and
whether or not it offers its tick, and SHALL be kept at the one-off place before the day view says
so. A rename SHALL keep the one-off's date, whether it is done and the day it was done. A rename
committed saying nothing SHALL remove the one-off, and one whose text, so disregarded, is the row's
own name SHALL change nothing, write nothing and tell nothing. A one-off row the day view does not
hold SHALL change nothing, throw nothing and tell nothing, whether renamed or removed.

#### Scenario: a one-off renamed from its row on a past day keeps its date and stays done there

- **WHEN** a one-off named "Call mum" on 25 September 2026, ticked on 25 September 2026, and one
  named "Send form" on 30 September 2026, not done, are added at a one-off place; a day screen of a
  commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1 January 2026,
  is opened at that one-off place as of Monday 28 September 2026, at a record place and a roster
  place where nothing has been kept; Friday 25 September 2026 is picked; and "Ring mum" is committed
  in the name field of its one one-off row
- **THEN** its One-offs group holds one row, named "Ring mum", saying it is done
- **AND** a one-off store opened afterwards at that one-off place holds "Ring mum" on 25 September
  2026, standing on 25 September 2026 as of 5 October 2026, and none named "Call mum"
- **AND** after Wednesday 30 September 2026 is picked and "Send the form" is committed in the name
  field of its one one-off row, which offers no tick as of 28 September 2026, its One-offs group
  holds one row, named "Send the form"

#### Scenario: a rename committed with its row's own name changes nothing and writes nothing

- **WHEN** a one-off named "Call mum" on 28 September 2026 is added at a one-off place; a day screen
  of no commitments at all is opened at that one-off place as of Monday 28 September 2026, at a
  record place and a roster place where nothing has been kept; and "Call mum" followed by one space
  is committed in the name field of its one one-off row
- **THEN** committing is not refused with an error
- **AND** it tells nothing under that row's name field or under its one-off entry
- **AND** the content at that one-off place is byte-for-byte what it was before the commit

#### Scenario: a rename committed saying nothing removes the one-off

- **WHEN** one-offs named "Call mum" on 25 September 2026 and "Call dad" on 28 September 2026 are
  added at a one-off place; a day screen of no commitments at all is opened at that one-off place as
  of Monday 28 September 2026, at a record place and a roster place where nothing has been kept; and
  a text of blank space alone is committed in the name field of the row named "Call mum"
- **THEN** its One-offs group holds one row, named "Call dad"
- **AND** a one-off store opened afterwards at that one-off place holds "Call dad" alone
- **AND** it tells nothing under any one-off row's name field or under its one-off entry

#### Scenario: a one-off removed from its row is held no longer, done or not and whether or not it offers its tick

- **WHEN** one-offs named "Call mum" on 25 September 2026, not done, "Call dad" on 28 September 2026,
  ticked on 28 September 2026, and "Pay fine" on 30 September 2026, not done, are added at a one-off
  place; a day screen of no commitments at all is opened at that one-off place as of Monday
  28 September 2026, at a record place and a roster place where nothing has been kept; its rows
  named "Call mum" and "Call dad" are removed; it is moved to the day after twice; and its row named
  "Pay fine", which offers no tick as of 28 September 2026, is removed
- **THEN** its One-offs group holds no rows
- **AND** sent back to today, its One-offs group holds no rows
- **AND** a one-off store opened afterwards at that one-off place holds no one-offs

#### Scenario: renaming or removing a one-off row a day screen's day view does not hold changes nothing

- **WHEN** one-offs named "Call mum" on 25 September 2026 and "Pay fine" on 29 September 2026 are
  added at a one-off place; a day screen of no commitments at all is opened at that one-off place as
  of Monday 28 September 2026, at a record place and a roster place where nothing has been kept; and
  on the one one-off row of the day view it says of the day after, "Pay the fine" is committed in
  that row's name field and removal is asked
- **THEN** neither is refused with an error
- **AND** the day view it says of the day after still holds one one-off row, named "Pay fine"
- **AND** it tells nothing on any row, under any one-off row's name field or under its one-off entry
- **AND** the content at that one-off place is byte-for-byte what it was before either was asked

## MODIFIED Requirements

### Requirement: A day view is a value and nothing else

A day view SHALL be the groups it holds, its One-offs group where it holds one, and the calendar
date it was formed on, and nothing else. Two day views SHALL be the same day view when they are of
the same date and hold the same groups in the same order, each group holding the same rows in the
same order, and the same One-offs group or none, and SHALL be different when any of that differs;
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

### Requirement: A day view draws the one-offs standing on its date as one group headed One-offs

A day view MAY be handed one-offs and a today beside its commitments. It SHALL then hold one group
of one-off rows, headed "One-offs" in this package's own words, holding a row for each one-off
standing on its date as of that today, in the order the `one-off` capability answers them; a day
view MUST NOT order them itself. Where none stands on its date it SHALL still hold that group,
holding no rows. That group SHALL NOT be one of its groups of commitments, its rows SHALL NOT be
among the commitment rows it holds, and it SHALL come after every group of commitments. A day view
handed no one-offs SHALL hold no One-offs group. A one-off row SHALL say its one-off's name exactly
as given.

#### Scenario: a day view holds a One-offs group of the one-offs standing on its date

- **WHEN** a day view is formed on Monday 28 September 2026 as of that same day, from a history that
  has taken no tick, of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, and of one-offs holding "Call mum" on 25 September 2026 and "Send form"
  on 30 September 2026, neither done
- **THEN** it holds one group of commitments, with no category, holding one row named "Journaling"
- **AND** it holds a One-offs group headed "One-offs", holding one row named "Call mum"
- **AND** its commitment rows are named "Journaling" alone

#### Scenario: a day view of a past day draws no undone one-off owed on that day

- **WHEN** a day view is formed on Friday 25 September 2026 as of Monday 28 September 2026, from a
  history that has taken no tick, of no commitments at all and of one-offs holding "Call mum" on
  25 September 2026, not done
- **THEN** it holds a One-offs group headed "One-offs", holding no rows
- **AND** a day view formed on that date from that same history of no commitments and handed no
  one-offs holds no One-offs group

#### Scenario: a day view's one-off rows are in the order one-offs answer them

- **WHEN** a day view is formed on Monday 28 September 2026 as of that same day, from a history that
  has taken no tick, of no commitments at all and of one-offs to which "Send form" on 28 September
  2026, "Call mum" on 25 September 2026 and "Book dentist" on 25 September 2026 were added in that
  order, none done
- **THEN** its One-offs group holds rows named "Call mum", "Book dentist" and then "Send form"
- **AND** it holds no group of commitments and no commitment rows

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
- **THEN** its One-offs group holds no rows
- **AND** the day view it says of the day after holds a One-offs group holding one row, named
  "Call mum"
- **AND** after Wednesday 30 September 2026 is picked, its One-offs group holds one row, named
  "Pay fine", saying nothing in the rhythm's place and offering no tick as of 28 September 2026

#### Scenario: a day screen opened where no one-offs have been kept writes nothing at its one-off place

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Monday 28 September 2026, at a one-off place, a record
  place and a roster place where nothing has been kept
- **THEN** its day view holds a One-offs group holding no rows
- **AND** it says it is keeping one-offs
- **AND** nothing has been kept at its one-off place

#### Scenario: a day screen reads its one-off place again when shown and not when returned to

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Monday 28 September 2026, at a one-off place, a record
  place and a roster place where nothing has been kept; a one-off named "Call mum" on 25 September
  2026 is then added at that one-off place by something else; and the day screen is returned to
- **THEN** its One-offs group holds no rows
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
- **THEN** its One-offs group holds no rows
- **AND** sent back to today, its One-offs group holds one row, named "Call mum", saying it is not
  done and saying "3 days late"

#### Scenario: a one-off tick that cannot be kept is refused and leaves the day view as it was

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place that is then
  made so that it can be read from but not written to, and a day screen of no commitments at all is
  opened at that one-off place as of Monday 28 September 2026, at a record place and a roster place
  where nothing has been kept; and its one one-off row is ticked
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

Where a one-off tick or removal cannot be kept, a day screen SHALL tell it on the one-off row tapped
as well as refusing it to the caller, and what it tells SHALL name no cause. A day screen SHALL tell
at most one row at a time, whether a commitment row or a one-off row: a refusal on a one-off row
SHALL move what is told onto that row and leave nothing told on any commitment row, and a refusal on
a commitment row SHALL leave nothing told on any one-off row. Telling on a one-off row MUST NOT
change what a day screen says about keeping one-offs.

#### Scenario: a refused one-off tick is told on its row and ends what was told on a commitment row

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place that is then
  made so that it can be read from but not written to; a day screen of a commitment named
  "Journaling" on a schedule listing all seven weekdays, kept from 1 January 2026, is opened at that
  one-off place as of Monday 28 September 2026, at a record place where nothing can be written — a
  path beneath an existing ordinary file — and a roster place where nothing has been kept; its one
  commitment row is ticked and refused; and its one one-off row is then ticked
- **THEN** ticking the one-off row is refused with an error
- **AND** it tells, on the one-off row, that the change could not be kept, naming no cause
- **AND** it tells nothing on the commitment row
- **AND** it still says it is keeping one-offs

#### Scenario: a refused commitment tick ends what was told on a one-off row

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place that is then
  made so that it can be read from but not written to; a day screen of a commitment named
  "Journaling" on a schedule listing all seven weekdays, kept from 1 January 2026, is opened at that
  one-off place as of Monday 28 September 2026, at a record place where nothing can be written — a
  path beneath an existing ordinary file — and a roster place where nothing has been kept; its one
  one-off row is ticked and refused; and its one commitment row is then ticked
- **THEN** it tells, on the commitment row, that the change could not be kept
- **AND** it tells nothing on the one-off row

#### Scenario: a one-off removal that cannot be kept is refused with an error and told on its row

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place that is then
  made so that it can be read from but not written to; a day screen of no commitments at all is
  opened at that one-off place as of Monday 28 September 2026, at a record place and a roster place
  where nothing has been kept; and removal is asked of its one one-off row
- **THEN** removing is refused with an error
- **AND** it tells, on that one-off row, that the change could not be kept, naming no cause
- **AND** its One-offs group still holds one row, named "Call mum"
- **AND** it tells nothing under its one-off entry

### Requirement: A day screen moves the day it is showing one calendar day either way

A day screen SHALL move the day it is showing one calendar day either way, giving what moving the
day view it holds gives, handed the record the screen holds and the commitments its roster answers
with on the day landed on. A move SHALL be asked of the screen and handed nothing. The today SHALL
NOT move, and every question a day screen asks as of a day SHALL still be asked as of that today.

A day screen SHALL step as far either way as the calendar goes: it MUST NOT stop at the today it
holds, at the earliest day a commitment its roster answers with is kept from, or at any day read off
what the record or the roster holds. A move SHALL NOT read either place again: it SHALL form the day
view from the record as the screen last read it — the reading done when the app was shown, together
with every change kept on the screen since — and from the roster as last read, asked afresh about
the day landed on, and SHALL leave what the screen says about either place exactly as it was. A day
screen not keeping one of them SHALL move like any other and go on saying so.

#### Scenario: a day screen moved to the day before shows the previous day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026, and it is moved to the day before
- **THEN** its day view is the same day view as one formed directly of those two commitments, in
  that order and of one-offs holding nothing, on Sunday 30 August 2026 as of that same day, from a
  history that has taken no tick
- **AND** it holds one row, named "Journaling"

#### Scenario: a day screen moved to the day after shows the next day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026, and it is moved to the day after
- **THEN** its day view is the same day view as one formed directly of those two commitments, in
  that order and of one-offs holding nothing, on Tuesday 1 September 2026 as of that same day, from
  a history that has taken no tick
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
- **THEN** its day view is the same day view as one formed directly of that commitment and of
  one-offs holding nothing, on Friday 4 September 2026 as of that same day, from a history that has
  taken no tick
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
- **THEN** its day view is the same day view as one formed directly of that commitment and of
  one-offs holding nothing, on Sunday 30 August 2026 as of that same day, from a history that has
  taken no tick
- **AND** it says it is not keeping a record

#### Scenario: a day screen that is not keeping a roster moves and goes on saying why

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a roster
  written in a form one later than the form this app writes, holding no commitments, at a record
  place where nothing has been kept, of a commitment named "Journaling" on a schedule listing all
  seven weekdays, kept from 1 January 2026, and it is moved to the day before and then to the day
  after
- **THEN** after the move to the day before, its day view is the same day view as one formed
  directly of no commitments at all and of one-offs holding nothing, on Sunday 30 August 2026 as of
  that same day, from a history that has taken no tick
- **AND** after the move to the day after, its day view is the same day view as one formed directly
  of no commitments at all and of one-offs holding nothing, on Monday 31 August 2026 as of that same
  day, from that same history
- **AND** after each move it says it is not keeping a roster
- **AND** after each move it says the roster was written by a later version of DayByDay
- **AND** after each move its day view holds no rows

#### Scenario: a tick kept on a day screen is still shown after it moves away and back, goes back to today or has that day picked

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; its one row is ticked; and it is moved to the day before and then to the day after
- **THEN** its day view says the commitment is kept on Monday 31 August 2026
- **AND** moved to the day before and then sent back to today, its day view says the same
- **AND** moved to the day before and then with Monday 31 August 2026 picked on its day picker, its
  day view says the same

### Requirement: A move with nowhere to go leaves a day screen exactly as it was

A day screen showing 1 January 1583 SHALL be left exactly as it is when moved to the day before, and
one showing 31 December 9999 SHALL be left exactly as it is when moved to the day after. Staying
SHALL be the whole of the answer: the screen SHALL go on showing the day it was showing, holding the
day view it was holding and saying what it was saying about its record, and it MUST NOT report that
the move had nowhere to go.

A day screen SHALL NOT say whether it can move either way. A caller MUST NOT stand a move down on
the strength of a day view a screen says on neither side, and asking for a move that has nowhere to
go SHALL go on being answered by this requirement. Being left as it was SHALL be about the calendar
and about nothing else, depending neither on which commitments the screen was handed, nor on what
its record holds, nor on whether its day view has any rows, nor on which day it was handed as today:
a screen at either end SHALL move normally the other way, and one showing any other date SHALL move
both ways.

#### Scenario: a day screen showing the first supported date is unchanged when it is moved to the day before

- **WHEN** a day screen is opened as of Sunday 2 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1
  January 1583; it is moved to the day before; and it is moved to the day before again
- **THEN** its day view is the same day view as one formed directly of that commitment and of
  one-offs holding nothing, on Saturday 1 January 1583 as of that same day, from a history that has
  taken no tick
- **AND** its day picker opens on Saturday 1 January 1583
- **AND** it says it is keeping a record

#### Scenario: a day screen showing the last supported date is unchanged when it is moved to the day after

- **WHEN** a day screen is opened as of Thursday 30 December 9999, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583; it is moved to the day after; and it is moved to the day after again
- **THEN** its day view is the same day view as one formed directly of that commitment and of
  one-offs holding nothing, on Friday 31 December 9999 as of that same day, from a history that has
  taken no tick
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

### Requirement: A day screen holds the day view of the day it was handed, formed from the record kept at its place

A day screen SHALL be opened from five things: some commitments, the day it is being opened on, the
place its record is kept at, the place its roster is kept at and the place its one-offs are kept at.
It SHALL hold the day view of that day, of the commitments its roster answers with on it and of the
one-offs held at its one-off place, formed from the history held at the record's place, and SHALL
give that day view back whole and unaltered. The commitments it is opened from SHALL be the ones it
takes on when its roster holds nothing at all, and SHALL NOT be a list it draws.

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
- **THEN** its day view is the same day view as one formed directly of that commitment and of
  one-offs holding nothing, on Monday 3 January 1583 as of that same day, from a history that has
  taken no tick
- **AND** a day screen opened the same way as of Monday 27 December 9999 holds the day view of that
  date instead

#### Scenario: a day screen holds the same day view as one formed directly from the same commitments, day and history

- **WHEN** ticks for a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday
  and for a commitment named "Journaling" on a schedule listing all seven weekdays, both kept from
  1 January 2026, on Monday 31 August 2026 are kept at a place; the "Journaling" tick is then taken
  back; and a day screen of those two commitments, in that order, is opened at that place as of
  Monday 31 August 2026
- **THEN** its day view is the same day view as one formed directly of those two commitments, in
  that order and of one-offs holding nothing, on Monday 31 August 2026 as of that same day, from a
  history holding exactly the remaining tick

### Requirement: A day screen shows a day picked on its day picker

A day screen SHALL show the calendar date it is given where it is not earlier than the earliest day
its day picker reaches, that earliest day included, and SHALL otherwise leave the screen as it was,
clamping to no day. Showing a picked day SHALL give what a move gives: the day view formed for the
day landed on, from the commitments its roster had not stopped keeping there and the record held. It
SHALL NOT read the record or the roster again, and SHALL leave what it says of either as it was. The
today SHALL NOT move, and every question asked as of that today SHALL still be, the way back to
today included. A pick that leaves the day being shown unchanged SHALL change nothing. Showing a
picked day SHALL be asked of the screen and handed one thing, the day to show.

#### Scenario: a day screen shows a day picked between the earliest day its picker reaches and the day it was showing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and one
  named "Journaling" on a schedule listing all seven weekdays, in that order and both kept from
  1 January 2026; and Monday 15 June 2026 is picked
- **THEN** its day view is the same day view as one formed directly of those two commitments, in
  that order and of one-offs holding nothing, on Monday 15 June 2026 as of that same day, from a
  history that has taken no tick
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

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and both kept from 1 January 2026, are taken on at a roster place in that order; "Gym" is
  stopped there as of Monday 15 June 2026; and a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept
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

### Requirement: A day screen says no day view before the first supported date and none after the last

A day screen showing 1 January 1583 SHALL say no day view of the day before it, and one showing 31
December 9999 SHALL say none of the day after it; the absence is the whole of the answer. The
absence SHALL be about the calendar and about nothing else: a screen showing either end SHALL go on
saying the day view on its other side, and a screen showing any other date SHALL say one on both
sides, whatever its roster holds, whatever its record holds, whether its day view has any rows, and
whichever day it was handed as today. The absence SHALL NOT be read as an answer about moving,
which *A move with nowhere to go leaves a day screen exactly as it was* states.

#### Scenario: a day screen showing the first supported date says no day view before it and says the day after

- **WHEN** a day screen is opened as of Saturday 1 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583
- **THEN** it says no day view of the day before
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment and of one-offs holding nothing, on Sunday 2 January 1583 as of that same day, from a
  history that has taken no tick

#### Scenario: a day screen showing the last supported date says no day view after it and says the day before

- **WHEN** a day screen is opened as of Friday 31 December 9999, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583
- **THEN** it says no day view of the day after
- **AND** the day view it says of the day before is the same day view as one formed directly of that
  commitment and of one-offs holding nothing, on Thursday 30 December 9999 as of that same day, from
  a history that has taken no tick

#### Scenario: a day screen moved off an end of the calendar says a day view either side of it

- **WHEN** a day screen is opened as of Saturday 1 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583, and it is moved to the day after
- **THEN** the day view it says of the day before is the same day view as one formed directly of
  that commitment and of one-offs holding nothing, on Saturday 1 January 1583 as of that same day,
  from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment and of one-offs holding nothing, on Monday 3 January 1583 as of that same day, from
  that same history

#### Scenario: a day screen showing the first supported date says no day view before it whatever its places, its rows and its today

- **WHEN** a day screen is opened as of Sunday 2 January 1583, at a roster place holding a run of
  bytes that is not what a roster is written as and a record place holding a run of bytes that is
  not what a record is written as, of a commitment named "Journaling" on a schedule listing all
  seven weekdays, kept from 1 January 1583, and it is moved to the day before
- **THEN** its day view holds no rows, and it says no day view of the day before
- **AND** the day view it says of the day after is the same day view as one formed directly of no
  commitments at all and of one-offs holding nothing, on Sunday 2 January 1583 as of that same day,
  from a history that has taken no tick
- **AND** moved to the day after, it says a day view of the day before and a day view of the day
  after

### Requirement: A day screen says the day view of the day either side of the one it is showing, formed as a move there would form it

A day screen SHALL say two further day views beside the one it is showing: the day view of the
calendar date one day earlier than the day being shown, and that of the date one day later. They
SHALL be two answers rather than one, and the day view of the day being shown SHALL go on being said
exactly as it is, unchanged in name, in shape and in every answer. Each SHALL be the day view this
screen would hold had it been moved onto that day, formed from the commitments its roster had not
stopped keeping there and from the record it holds, so a change kept on the day being shown SHALL
leave both as they were. This capability MUST NOT form either from the commitments answered for the
day being shown. Exactly one day either side SHALL be said, never a run of them.

#### Scenario: a day screen says the day view of the day before the one it is showing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026
- **THEN** the day view it says of the day before is the same day view as one formed directly of
  those two commitments, in that order and of one-offs holding nothing, on Sunday 30 August 2026 as
  of that same day, from a history that has taken no tick
- **AND** that day view holds one row, named "Journaling"

#### Scenario: a day screen says the day view of the day after the one it is showing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026
- **THEN** the day view it says of the day after is the same day view as one formed directly of
  those two commitments, in that order and of one-offs holding nothing, on Tuesday 1 September 2026
  as of that same day, from a history that has taken no tick
- **AND** that day view holds one row, named "Journaling"

#### Scenario: a day screen says the day one calendar day either side and no day further

- **WHEN** a day screen is opened as of Sunday 1 March 2026, at a place where nothing has been kept,
  of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1 January
  2026
- **THEN** the day view it says of the day before is the same day view as one formed directly of
  that commitment and of one-offs holding nothing, on Saturday 28 February 2026 as of that same day,
  from a history that has taken no tick, which is one calendar day earlier and not two
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment and of one-offs holding nothing, on Monday 2 March 2026 as of that same day, from that
  same history

#### Scenario: a day screen says a day either side drawn from the commitments its roster had not stopped keeping on that day

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and stopped as of Sunday 30 August 2026; and a day
  screen of no commitments at all is opened at that roster place as of Monday 31 August 2026, at a
  record place where nothing has been kept
- **THEN** its day view holds no rows, Monday 31 August 2026 being after the day the commitment was
  kept until
- **AND** the day view it says of the day before holds one row, named "Journaling"
- **AND** the day view it says of the day after holds no rows

#### Scenario: a day screen says a day either side drawn from the record it already holds

- **WHEN** a tick for a commitment named "Journaling" on a schedule listing all seven weekdays, kept
  from 1 January 2026, on Tuesday 1 September 2026 is kept at a place; and a day screen of that
  commitment is then opened at that place as of Monday 31 August 2026
- **THEN** the day view it says of the day after holds one row, saying the commitment is kept
- **AND** the day view it says of the day before holds one row, saying the commitment is not kept
- **AND** its own day view holds one row, saying the commitment is not kept

#### Scenario: a tick made on the day a day screen is showing leaves the day either side of it as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; the day views it says of the day before and of the day after are read; and its one
  row is then ticked
- **THEN** its day view says the commitment is kept on Monday 31 August 2026
- **AND** the day view it says of the day before is the same day view as the one it said before the
  tick, saying the commitment is not kept on Sunday 30 August 2026
- **AND** the day view it says of the day after is the same day view as the one it said before the
  tick, saying the commitment is not kept on Tuesday 1 September 2026

### Requirement: A day screen asked the day either side reads neither place again and is left exactly as it was

Saying either SHALL read neither place again: the roster asked SHALL be the one read when the app
was last shown or the screen was last returned to, whichever happened later, and the record the one
the screen last read, each with every change kept since. Saying either SHALL change nothing about
the screen: the day being shown SHALL be the day it was, the today SHALL NOT move, nothing SHALL be
kept at either place, and what the screen is telling on a row SHALL be left exactly as it was. Both
SHALL follow the day being shown, whatever put the screen on it, and SHALL be formed from the roster
and the record then held. A day screen not keeping a record or not keeping a roster SHALL say them
like any other, and what it says about either place SHALL be untouched by being asked.

#### Scenario: saying the day either side of a day screen leaves the day it is showing exactly as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the day views it says of the day before and of the day after are both read
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** its day picker opens on Monday 31 August 2026, and it offers no way back to today

#### Scenario: a day screen moved to another day says the day either side of that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day after
- **THEN** the day view it says of the day before is the same day view as one formed directly of
  that commitment and of one-offs holding nothing, on Monday 31 August 2026 as of that same day,
  from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment and of one-offs holding nothing, on Wednesday 2 September 2026 as of that same day,
  from that same history

#### Scenario: a day screen sent back to today says the day either side of that today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before three times; and it is then sent back to today
- **THEN** the day view it says of the day before is the same day view as one formed directly of
  that commitment and of one-offs holding nothing, on Sunday 30 August 2026 as of that same day,
  from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment and of one-offs holding nothing, on Tuesday 1 September 2026 as of that same day, from
  that same history

#### Scenario: a day screen showing a day picked on its day picker says the day either side of that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and Friday 25 September 2026 is picked on its day picker
- **THEN** the day view it says of the day before is the same day view as one formed directly of
  that commitment and of one-offs holding nothing, on Thursday 24 September 2026 as of that same
  day, from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment and of one-offs holding nothing, on Saturday 26 September 2026 as of that same day,
  from that same history

#### Scenario: a day screen shown again on a new day says the day either side of that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the app is then shown again as of Wednesday 2 September 2026
- **THEN** the day view it says of the day before is the same day view as one formed directly of
  that commitment and of one-offs holding nothing, on Tuesday 1 September 2026 as of that same day,
  from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment and of one-offs holding nothing, on Thursday 3 September 2026 as of that same day, from
  that same history

#### Scenario: saying the day either side of a day screen does not read its record or its roster again

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; a
  commitment named "Gym" on a schedule listing all seven weekdays, kept from that same day, is then
  taken on at that roster place by something else, and a tick for "Journaling" on Sunday 30 August
  2026 is kept at that record place by something else
- **THEN** the day view it says of the day before holds one row, named "Journaling", saying the
  commitment is not kept
- **AND** the day view it says of the day after holds one row, named "Journaling"
- **AND** it says it is keeping a roster and keeping a record, exactly as it did before

#### Scenario: a day screen that cannot read its record says the day either side of it with nothing kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes that
  is not what a record is written as, of a commitment named "Journaling" on a schedule listing all
  seven weekdays, kept from 1 January 2026
- **THEN** the day view it says of the day before is the same day view as one formed directly of
  that commitment and of one-offs holding nothing, on Sunday 30 August 2026 as of that same day,
  from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment and of one-offs holding nothing, on Tuesday 1 September 2026 as of that same day, from
  that same history
- **AND** it says it is not keeping a record

#### Scenario: a day screen that cannot read its roster says the day either side of it and neither holds rows

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a run of
  bytes that is not what a roster is written as, at a record place where nothing has been kept, of a
  commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1 January 2026
- **THEN** the day view it says of the day before holds no rows
- **AND** the day view it says of the day after holds no rows
- **AND** it says it is not keeping a roster

#### Scenario: a day screen goes on telling what it was telling on a row when it is asked the day either side of it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; its one row is ticked and the
  change is refused; and the day views it says of the day before and of the day after are then both
  read
- **THEN** it is still telling, on that row, that the change could not be kept
- **AND** its day view is the same day view as the one it held when it was opened

#### Scenario: a day screen returned to says the day either side of it from the roster it then holds

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; a
  commitment named "Gym" on a schedule listing all seven weekdays, kept from that same day, is then
  taken on at that roster place by something else; and the screen is returned to
- **THEN** the day view it says of the day before holds two rows, named "Journaling" and then "Gym"
- **AND** the day view it says of the day after holds two rows, named "Journaling" and then "Gym"

#### Scenario: saying the day either side of a day screen keeps nothing at either place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place and a roster place
  where nothing has been kept, of a commitment named "Journaling" on a schedule listing all seven
  weekdays, kept from 1 January 2026; the roster place is read; and the day views it says of the
  day before and of the day after are both read
- **THEN** nothing has been kept at its record place
- **AND** the content at its roster place is byte-for-byte what it was before those day views were
  read

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
else SHALL survive being shown again: those commitments, the three places and the day it is showing
are all a day screen carries across.

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
