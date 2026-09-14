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
same order, and the same One-offs group or none, and SHALL be different when any of that differs; two day views holding the same rows in the same order under different groupings
SHALL therefore be two day views.

A difference in what a day view was handed that does not reach a row SHALL make no difference to the
day view: a commitment not due produces no row, a group none of whose commitments is due produces no
group, and a tick for a commitment the day view was not handed is never looked up, and a one-off standing
on another day produces no one-off row, so a day view handed any of the four SHALL be the same day
view as one that was not handed it. A day view handed no one-offs at all SHALL NOT be the same day
view as one handed one-offs holding none. A day view SHALL be an
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
  from 1 January 2026, and of one-offs holding nothing; and a second is formed the same way of
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
holding no rows. That
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

Where a one-off tick or removal cannot be kept, a day screen SHALL tell it on the one-off row tapped
as well as refusing it to the caller, and what it tells SHALL name no cause. A day screen SHALL tell
at most one row at a time, whether a commitment row or a one-off row: a refusal on a one-off row
SHALL move what is told onto that row and leave nothing told on any commitment row, and a refusal on
a commitment row SHALL leave nothing told on any one-off row. Telling on a one-off row MUST NOT
change what a day screen says about keeping one-offs.

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

#### Scenario: a one-off removal that cannot be kept is refused with an error and told on its row

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added at a one-off place that is then
  made so that it can be read from but not written to; a day screen of no commitments at all is
  opened at that one-off place as of Monday 28 September 2026, at a record place and a roster place
  where nothing has been kept; and removal is asked of its one one-off row
- **THEN** removing is refused with an error
- **AND** it tells, on that one-off row, that the change could not be kept, naming no cause
- **AND** its One-offs group still holds one row, named "Call mum"
- **AND** it tells nothing under its one-off entry
