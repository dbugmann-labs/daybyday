## MODIFIED Requirements

### Requirement: A day view is a value

A day view SHALL be the **groups** it holds and the calendar date it was formed on, and nothing else.
Two day views SHALL be the same day view when they hold the same groups, in the same order, holding
the same rows in the same order, on the same date; and SHALL be different when the date differs, when
the groups differ in how many there are, in their order or in the category any one of them is under,
or when the rows differ in how many there are, in their order, in the commitment any one of them is
for, or in whether any one of them says its commitment is kept. Forming a day view twice from the
same commitments, in the same groups, in the same order, on the same date and from the same history
therefore SHALL give the same day view.

**The rows are still what a day view is, and the groups say where each of them is drawn.** Two day
views holding the same rows in the same order under different groupings are two day views, because a
person reading them reads two different screens; a day view whose rows are all under no category and
one whose rows are split into two groups are not each other, however alike the rows are.

A day view holds no identity of its own: two day views a person could not tell apart are not
distinguishable to the system either. That cuts both ways, and the second way is the one worth saying
out loud, because a day view is what a date asked and what was done about it rather than a record of
what it was asked from. A difference in what a day view was handed that does not reach a row SHALL
make no difference to the day view. Three ways that can happen follow from the requirements above
rather than adding anything to them: a commitment that is not due on the date produces no row, so a
day view handed it is the same day view as one that was not; a group none of whose commitments is due
on the date produces no group, so a day view handed it is the same day view as one that was not; and
a tick for a commitment the day view was not handed is never looked up, so a history holding one
gives the same day view as a history that does not. Which commitments were offered, which groups they
were offered in, and which ticks a history held besides the ones asked about, are the caller's to
remember; what a day view keeps is the answer.

The calendar date is part of what a day view is, not merely an argument used to build it: two dates
whose rows happen to coincide are two days, not one.

A day view SHALL be an answer given from a history as that history stood, and not a window onto one.
Ticking a history after a day view was formed from it MUST NOT change that day view; the answer that
takes the new tick into account is a day view formed again. This is what makes a day view something
that can be held, compared and handed on rather than something that changes underneath a reader.

#### Scenario: two day views of the same commitments, date and history are the same day view

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday and a commitment named "Run" on a schedule listing
  Monday and Thursday, both kept from 1 January 2026 and handed over in that order, each from a
  history holding a tick for "Gym" on that date
- **THEN** the two are the same day view

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

### Requirement: A day screen draws the commitments its roster had not stopped keeping on the day it is showing

A day screen SHALL hold a roster, read at the place it keeps its roster, and SHALL form every day
view it holds from the commitments that roster had not stopped keeping on the day being shown, **in
the groups the roster answers with**, in the order the roster answers with. It MUST NOT hold a list
of commitments of its own, and MUST NOT
ask the roster about the today or about any day other than the one it is showing.

**The groups are the roster's answer and the day screen hands them straight on.** Which categories
there are, which commitments are under each, where each group sits and that the commitments under no
category come last are all the `commitment` capability's answers, exactly as the order already is;
this screen SHALL NOT sort them, SHALL NOT rearrange them and SHALL NOT work out a group of its own.
A day view then draws no group with nothing due on the date, and that is the day view's own rule
because it is a rule about what a date asks of you.

Every day view a day screen forms SHALL ask the roster again for the day then being shown: when the
screen is opened, when it is moved, when it is sent back to today, when the app is shown again,
when the screen is returned to, and when a tick is made. A commitment the roster stopped keeping
therefore has a row on every day up to and including the day it was kept until and on none after
it, and a screen moved across that day changes what it draws without anything being read again.

**A commitment the roster has removed has exactly the same rows.** It is answered about a date as a
stopped commitment is, so it has a row on every day up to and including the day it was kept until
and on none after it, and a day screen SHALL NOT tell the two apart in any way — not in whether the
row is drawn, not in what the row says, not in what the row offers, and not in the group it is drawn
in. Getting rid of a commitment
for good is a statement about the days ahead, and a past day that lost its rows because a person
tidied their list is the failure this product exists to prevent. Where the difference between
stopped and removed lives is the commitments screen, which lists a removed commitment nowhere.

Asking the roster is not reading the roster's place again. The roster a day screen asks is the one
read at that place when the app was last shown or the screen was last returned to, whichever
happened later, together with any change the screen has kept since — so a move and a tick MUST NOT
open the roster's place, exactly as they MUST NOT open the record's.

The day screen adds nothing to the roster's answer and takes nothing away. Which commitments the
roster had not stopped keeping on a date, the groups they come in, and the order they come in, are
the `commitment` capability's answers; which of them then has a row, which group is drawn at all, and
what a row says, are this capability's own answers about a date. A day screen MUST NOT judge a
commitment's day it is kept from or its schedule for itself, and MUST NOT reorder, regroup, combine
or drop what the roster answers with.

**The order the roster answers in is the one its owner set, and a day screen inherits it without
doing anything.** Moving a commitment is a change made on the commitments screen, kept at the roster
place, and read by a day screen the next time it asks its roster — which is every day view it forms.
**The grouping arrives the same way and for the same reason**: putting a commitment under a category
is a change made on the commitments screen and kept at the roster place, and this screen draws the
result without a rule of its own. This
requirement gains no rule for either, deliberately: the order and the groups were already the
roster's to give and already this screen's to draw untouched, and the scenarios below exist to make
that a fact rather than a claim.

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

#### Scenario: a day screen draws a removed commitment on the day it was kept until and not on the day after it

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place, ticked on Sunday 30 August 2026, and removed as of
  that same day; and a day screen of no commitments at all is opened at that roster place as of
  Monday 31 August 2026, at the record place that tick was kept at
- **THEN** the day view it held when it was opened holds no rows, Monday 31 August 2026 being after
  the day the commitment was kept until
- **AND** after it is moved to the day before, its day view holds one row, named "Journaling", saying
  the commitment is kept on that date

#### Scenario: a day screen draws its rows in the order its roster was moved into

- **WHEN** a commitment named "Journaling", then one named "Supplements and habits", then one named
  "Gym", all on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a
  roster place; "Gym" is moved there to the offset 0; and a day screen of no commitments at all is
  opened at that roster place as of Monday 31 August 2026, at a record place where nothing has been
  kept
- **THEN** its day view holds three rows, named "Gym", "Journaling" and then "Supplements and habits"
- **AND** it says it is keeping a roster

#### Scenario: a day screen draws its rows in the groups its roster puts them in

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Magnesium", then one
  named "Journaling", all on a schedule listing all seven weekdays and kept from 1 January 2026, are
  taken on at a roster place; "Creatine" and "Magnesium" are put under the category "Supplements"
  there and "Gym" under "Sport"; and a day screen of no commitments at all is opened at that roster
  place as of Monday 31 August 2026, at a record place where nothing has been kept
- **THEN** its day view holds three groups: "Supplements" holding rows named "Creatine" and then
  "Magnesium", then "Sport" holding a row named "Gym", then a group with no category holding a row
  named "Journaling"
- **AND** it says it is keeping a roster

#### Scenario: a day screen draws a group again after a category is changed at its roster place

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a day screen of no
  commitments at all is opened at that roster place as of Monday 31 August 2026, at a record place
  where nothing has been kept; "Creatine" is put under the category "Supplements" at that roster
  place by something else; and the app is shown again as of that same day
- **THEN** the day view it held when it was opened holds one group, with no category, holding rows
  named "Creatine" and then "Gym"
- **AND** afterwards its day view holds two groups, "Supplements" holding a row named "Creatine" and
  then a group with no category holding a row named "Gym"

## ADDED Requirements

### Requirement: A day view draws its rows in the groups it was handed, and draws no group with nothing due

A day view SHALL be handed its commitments in **groups** — a category, or no category at all,
together with the commitments under it — and SHALL hold one group for each group it was handed that
has at least one commitment due on the date, in the order it was handed them, each holding its due
commitments' rows in the order it was handed them. The rows of a day view, read across its groups,
SHALL be every row it holds, in the order the groups are drawn.

**A day view works out no group of its own.** It SHALL NOT sort the groups, SHALL NOT sort within
one, SHALL NOT decide where the commitments under no category go, and SHALL NOT combine two groups
under the same category into one. All of that is decided before a day view is handed anything, by
the roster the categories are held on, and this is what leaves the day view still ordering nothing
of its own: the requirement that its rows are in the order it was handed its commitments is
unchanged, and grouping is not an exception to it because the grouping is handed over too.

**A group with nothing due on the date SHALL NOT be drawn at all**, and that rule is the day view's
own. A day view already draws only what a date asks of you, so a heading with no rows under it would
be a claim about the day rather than about what a person keeps — it would say "you have supplements"
on a day no supplement is due. A group every one of whose commitments is dropped is dropped with
them, and a day view handed only such groups holds no groups and no rows rather than a refusal.

A day view MAY be handed its commitments **with no grouping at all**, and SHALL then hold one group
with no category, holding every due commitment's rows in the order it was handed them, or no group
at all where none is due. That is the same answer as being handed one group with no category, and it
is what every caller that has nothing to say about categories hands over.

#### Scenario: a day view holds one group for each group it was handed that has something due

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a group under "Supplements" holding a commitment named "Creatine" and then one named "Magnesium",
  then a group under "Sport" holding one named "Gym", then a group with no category holding one
  named "Journaling", all four on a schedule listing all seven weekdays and all kept from
  1 January 2026
- **THEN** the day view holds three groups, under "Supplements", then "Sport", then no category
- **AND** its rows, read across its groups, are named "Creatine", "Magnesium", "Gym" and then
  "Journaling", in that order

#### Scenario: a day view draws no group whose commitments are none of them due on the date

- **WHEN** a day view is formed on Tuesday 1 September 2026, from a history that has taken no tick,
  of a group under "Money" holding a commitment named "Finances" on a schedule on the 25th of the
  month, then a group under "Sport" holding one named "Gym" on a schedule listing all seven
  weekdays, both kept from 1 January 2026
- **THEN** the day view holds one group, under "Sport", holding one row named "Gym"
- **AND** no group is drawn under "Money"

#### Scenario: a day view handed only groups with nothing due holds no groups at all

- **WHEN** a day view is formed on Tuesday 1 September 2026, from a history that has taken no tick,
  of a group under "Money" holding a commitment named "Finances" on a schedule on the 25th of the
  month, kept from 1 January 2026
- **THEN** the day view holds no groups and no rows
- **AND** it is the same day view as one formed on that date, from that same history, of no
  commitments at all

#### Scenario: a day view drops the commitments that are not due and keeps the group its due ones are in

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a group under "Supplements" holding a commitment named "Creatine" on a schedule listing all seven
  weekdays and then one named "Vitamin D" on a schedule on the 25th of the month, both kept from
  1 January 2026
- **THEN** the day view holds one group, under "Supplements", holding one row named "Creatine"

#### Scenario: a day view handed commitments with no grouping holds one group with no category

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, then one named
  "Run" on a schedule listing Monday and Thursday, both kept from 1 January 2026, handed over with
  no grouping at all
- **THEN** the day view holds one group, with no category, holding rows named "Gym" and then "Run"
- **AND** it is the same day view as one formed on that date, from that same history, of one group
  with no category holding those same two commitments in that same order

#### Scenario: a day view does not combine two groups under the same category

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a group under "Supplements" holding a commitment named "Creatine", then a group under "Sport"
  holding one named "Gym", then a second group under "Supplements" holding one named "Magnesium",
  all three on a schedule listing all seven weekdays and all kept from 1 January 2026
- **THEN** the day view holds three groups, under "Supplements", then "Sport", then "Supplements"
- **AND** its rows, read across its groups, are named "Creatine", "Gym" and then "Magnesium"

#### Scenario: a row in a group says whether its commitment is kept, exactly as a row under no category does

- **WHEN** a day view is formed on Monday 31 August 2026, of a group under "Supplements" holding a
  commitment named "Creatine" and then one named "Magnesium", both on a schedule listing all seven
  weekdays and both kept from 1 January 2026, from a history holding a tick for "Magnesium" on that
  date
- **THEN** the day view holds one group, under "Supplements", holding two rows named "Creatine" and
  then "Magnesium"
- **AND** only the second row says its commitment is kept
