# Day Screen Specification

## Purpose

Describes what one calendar date asks of a person and what they did about it — the commitments due
on that date, each with whether it is kept, in the order the day view was handed them. It is where
`commitment`'s answer about a date and `record`'s answer about a tick are brought together for a
single day, and it is what the screen a person lands on draws.

## Requirements

### Requirement: A day view is the commitments due on a date, each with whether it is kept

A day view SHALL be formed from three things: some commitments, a calendar date, and a history. It
SHALL hold one row for each of those commitments that is due on that date, and no row for one that is
not. Each row SHALL carry the commitment's name, exactly as the commitment was given it and with
nothing trimmed, added or substituted, and SHALL say whether the history holds that commitment kept
on that date.

Both answers SHALL be taken from the capabilities that own them and neither SHALL be recomputed here.
Whether a commitment is due on the date is the `commitment` capability's answer, asked of the
commitment itself rather than of the schedule it carries, so the day the commitment is kept from
applies without this capability restating it. Whether it is kept is the `record` capability's answer,
asked of the history for that same commitment and that same date. The day view adds nothing to either
and takes nothing away: it MUST NOT consider a commitment's name, the present moment, the device's
time zone or the locale, and it MUST NOT reach past a commitment to the schedule underneath it. As
throughout `commitment` and `record`, the question is asked of a calendar date rather than of the
present moment, so a day view of a past date answers tomorrow exactly as it does today, and a day
view is formed for any date the system supports whether or not that date has arrived.

A commitment that is kept SHALL keep its row. The row says so and goes quiet; it does not leave the
view, and the day view SHALL NOT count, total or rank anything — it says of each commitment that it
is kept or not, and never how many, how often or how many days in a row.

Rows SHALL come only from the commitments the day view was handed. A tick in the history for a
commitment the day view was not given MUST NOT produce a row, and MUST NOT affect any row that is
there: a history is asked about each commitment in turn and is never enumerated.

A day view whose commitments include none that is due on the date, and a day view formed from no
commitments at all, SHALL each be a day view with no rows rather than a refusal. There is nothing for
a day view to reject: every date it can be asked about is a date, and a day with nothing due is an
answer.

#### Scenario: a day view holds a row for each commitment due on the date

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, a commitment named
  "Run" on a schedule listing Monday and Thursday, and a commitment named "Finances" on a schedule on
  the 25th of the month, all three kept from 1 January 2026
- **THEN** the day view holds two rows
- **AND** they are named "Gym" and "Run"

#### Scenario: a commitment not due on the date has no row

- **WHEN** a day view is formed on Tuesday 1 September 2026, from a history that has taken no tick,
  of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026
- **THEN** the day view holds no rows

#### Scenario: a commitment ticked on the date has a row that says it is kept

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, from a history holding a tick for
  that commitment on that date
- **THEN** the day view holds one row
- **AND** that row is named "Gym" and says the commitment is kept

#### Scenario: a commitment not ticked on the date has a row that says it is not kept

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, from a history that has taken no
  tick
- **THEN** the day view holds one row
- **AND** that row is named "Gym" and says the commitment is not kept

#### Scenario: a day view of no commitments at all has no rows

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  no commitments at all
- **THEN** the day view holds no rows

#### Scenario: a day view holds no rows when none of the commitments is due

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of a
  commitment named "Finances" on a schedule on the 25th of the month, kept from 1 January 2026, and a
  commitment named "Contact lenses" on a schedule of every 14 days starting on 25 August 2026, kept
  from that same day
- **THEN** the day view holds no rows

#### Scenario: a commitment whose schedule is due but which is kept from a later day has no row

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from Wednesday
  2 September 2026
- **THEN** the day view holds no rows, though the schedule is due on that date
- **AND** a day view of the same commitment on Wednesday 2 September 2026 holds one row named "Gym"

#### Scenario: a tick for a commitment the day view was not handed adds no row

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, from a history holding a tick on
  that date for a commitment named "Run" on a schedule listing Monday and Thursday, kept from the
  same day
- **THEN** the day view holds one row
- **AND** that row is named "Gym" and says the commitment is not kept

#### Scenario: a tick on another date does not make the row say it is kept

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, from a history holding a tick for
  that commitment on Saturday 5 September 2026
- **THEN** the day view holds one row saying the commitment is not kept
- **AND** a day view of the same commitment and history on Saturday 5 September 2026 holds one row
  saying it is kept

#### Scenario: two commitments with the same name and different schedules each have their own row

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday and a commitment named "Gym" on a schedule listing Monday
  and Thursday, both kept from 1 January 2026, from a history holding a tick on that date for the
  first of them only
- **THEN** the day view holds two rows, both named "Gym"
- **AND** the first says the commitment is kept and the second says it is not

#### Scenario: a commitment on a weekly quota has a row on every day of the week

- **WHEN** a day view is formed on each date from Monday 31 August through Sunday 6 September 2026,
  from a history that has taken no tick, of a commitment named "Reading" on a schedule of 3 times a
  week, kept from 1 January 2026
- **THEN** each of the seven day views holds one row named "Reading", saying the commitment is not
  kept
- **AND** when the history holds ticks for that commitment on Monday 31 August, Wednesday 2 September
  and Saturday 5 September 2026, those three dates' rows say it is kept and the other four dates
  still hold a row saying it is not

#### Scenario: a day view is formed in the first supported year and in the last

- **WHEN** a day view is formed on Monday 3 January 1583, from a history that has taken no tick, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  1583
- **THEN** the day view holds one row named "Gym", saying the commitment is not kept
- **AND** a day view of the same commitment and history on Monday 27 December 9999 holds one row
  saying the same

#### Scenario: a row carries the commitment's name exactly as it was given

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of a
  commitment named " Gym ", with a space at each end, and a commitment named with the single emoji
  🏋️, both on a schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026
- **THEN** the first row is named " Gym ", with both spaces
- **AND** the second row is named with that emoji

### Requirement: A row offers the tick that keeps its commitment, and refuses one for a day that has not arrived

A row SHALL offer, when asked as of a calendar date, either exactly one tick or nothing at all. The
tick it offers SHALL be the tick of that row's commitment on the date the day view holding it is of,
and nothing else: the row is a commitment on a date and a tick is a commitment on a date, so there
is nothing left for a caller to supply and nothing for the row to choose.

The row SHALL offer nothing exactly when the day view's date is later than the day it is asked as
of, and the tick otherwise. A row asked as of its own date SHALL offer the tick — a day that has
arrived can have been kept, and only one that has not is refused — and so SHALL a row whose date is
earlier, however much earlier: the past is writable back to the day the commitment is kept from, and
a commitment that is not due there has no row to ask.

The day the row is asked as of SHALL be given to it, and this capability MUST NOT read it from a
clock, MUST NOT consult the present moment, the device's time zone or the locale, and MUST NOT keep
it. A row therefore answers the same way for ever when asked as of the same day, and a row asked
twice as of two different days answers each on its own — an app left open past midnight refuses on
last night's reckoning for no longer than the question it is asked, because the day arrives with the
question rather than with the day view.

The tick a row offers SHALL be the tick that makes its commitment kept on that date, and the same
tick SHALL be the one that takes it back. Adding it to the history the day view was formed from
makes a day view formed again from that history say the row is kept; taking it back makes a day view
formed again say it is not. The row SHALL NOT add or take back anything itself, and MUST NOT hold,
copy or alter a history: what a record is, where it is held and what happens when one is added twice
are the `record` capability's answers, and this capability adds nothing to them.

A row SHALL offer the same tick whether or not it says its commitment is already kept. The tick is
made of the commitment and the date, and neither of those is what a history says, so the row's
answer depends on the day it is asked as of and on nothing else. A row whose date is later than the
day it is asked as of SHALL therefore offer nothing whether or not it says the commitment is kept:
the refusal is about a day that has not arrived, not about what is recorded on it, and a row that
could be untapped but not tapped would be two rules where the product has one.

A row SHALL refuse for no other reason. A row exists only for a commitment that is due on the day
view's date, and being due on the date is the whole of what makes a tick formable, so the only row
that offers nothing is one asked as of a day earlier than its own.

#### Scenario: a row offers the tick for its commitment on the date the day view is of

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, and its one row is asked as of Monday 31 August 2026
- **THEN** the row offers a tick
- **AND** that tick is the same tick as one formed directly for that commitment on Monday 31 August
  2026

#### Scenario: adding the tick a row offers makes a day view formed again say the commitment is kept

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026; its one row is asked as of that same day; and the tick it offers is added to that history
- **THEN** a day view formed again on Monday 31 August 2026, of the same commitment and from the
  history as it now stands, holds one row named "Gym" saying the commitment is kept

#### Scenario: taking back the tick a row offers makes a day view formed again say the commitment is not kept

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, from a history holding a tick
  for that commitment on that date; its one row is asked as of that same day; and the tick it offers
  is taken back from that history
- **THEN** that row says the commitment is kept
- **AND** a day view formed again on Monday 31 August 2026, of the same commitment and from the
  history as it now stands, holds one row named "Gym" saying the commitment is not kept

#### Scenario: a row already saying the commitment is kept offers the same tick

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, the first from a
  history that has taken no tick and the second from a history holding a tick for that commitment on
  that date, and each one's row is asked as of that same day
- **THEN** the first row says the commitment is not kept and the second says it is
- **AND** both offer the same tick

#### Scenario: a row for a date later than the day it is asked as of offers no tick

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  tick, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and its one row is asked as of Monday 31 August 2026
- **THEN** the day view holds one row named "Gym"
- **AND** that row offers no tick

#### Scenario: a row for a date earlier than the day it is asked as of offers the tick

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, and its one row is asked as of Saturday 5 September 2026
- **THEN** the row offers a tick
- **AND** that tick is the same tick as one formed directly for that commitment on Monday 31 August
  2026

#### Scenario: a row for a date later than the day it is asked as of offers no tick even where it says the commitment is kept

- **WHEN** a day view is formed on Saturday 5 September 2026, of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, from a history holding
  a tick for that commitment on that date, and its one row is asked as of Monday 31 August 2026
- **THEN** that row says the commitment is kept
- **AND** it offers no tick

#### Scenario: a row's answer follows the day it is asked as of rather than the day the day view was formed

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  tick, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and its one row is asked twice — once as of Tuesday 1 September 2026 and once as
  of Wednesday 2 September 2026
- **THEN** the first asking offers no tick
- **AND** the second offers the tick for that commitment on Wednesday 2 September 2026

#### Scenario: a row offers the tick in the first supported year and in the last

- **WHEN** a day view is formed on Monday 3 January 1583, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  1583, and its one row is asked as of Monday 3 January 1583
- **THEN** the row offers a tick
- **AND** the row of a day view of the same commitment and history on Monday 27 December 9999, asked
  as of Monday 27 December 9999, offers a tick
- **AND** that same row, asked as of Monday 3 January 1583, offers none

#### Scenario: every row of a day view whose date has not arrived offers no tick

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  tick, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, then one
  named "Vitamins" on a schedule listing all seven weekdays, then one named "Reading" on a weekly
  quota of 3 times a week, all three kept from 1 January 2026, and every one of its rows is asked as
  of Monday 31 August 2026
- **THEN** the day view holds three rows, named "Gym", "Vitamins" and "Reading"
- **AND** none of them offers a tick

#### Scenario: a row for a commitment on a weekly quota offers a tick even where its quota is already met

- **WHEN** a day view is formed on Sunday 6 September 2026, of a commitment named "Reading" on a
  weekly quota of 3 times a week, kept from 1 January 2026, from a history holding ticks for that
  commitment on Monday 31 August, Wednesday 2 September and Saturday 5 September 2026, and its one
  row is asked as of Sunday 6 September 2026
- **THEN** the day view holds one row named "Reading", saying the commitment is not kept
- **AND** that row offers a tick

### Requirement: A row is a commitment's line on a date

A row SHALL be three things and no others: the commitment it is a line for, the date the day view
holding it is of, and whether that commitment is kept on that date. Two rows SHALL be the same row
when all three agree, and SHALL be different when any one of them differs.

The date is part of what a row is rather than something the day view alone holds. Two rows for the
same commitment, each saying the same thing about it, on two different dates SHALL be different
rows: they offer different ticks, and one cannot stand in for the other. This adds to what a day
view is without changing it — a day view is already its rows and its date, so day views on two dates
were already two day views, and this makes them so a second way rather than a new way.

A row SHALL be reachable only through the day view that holds it, and SHALL give back only its
commitment's name, whether that commitment is kept, and the tick it offers. It MUST NOT give back
the commitment itself, the schedule underneath it, the day it is kept from, or the date the row is
for: what a reader is given is what a screen draws and what a tap makes, and nothing else has been
asked for.

#### Scenario: two rows for the same commitment and date saying the same thing are the same row

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, each from a history
  holding a tick for that commitment on that date
- **THEN** each holds one row saying the commitment is kept
- **AND** the two rows are the same row

#### Scenario: two rows for the same commitment on different dates are different rows

- **WHEN** two day views are formed of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, each from a history that has taken no tick, one
  on Monday 31 August 2026 and one on Wednesday 2 September 2026
- **THEN** each holds one row named "Gym", saying the commitment is not kept
- **AND** the two rows are different rows

#### Scenario: two rows for the same commitment and date differing in whether it is kept are different rows

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, the first from a
  history that has taken no tick and the second from a history holding a tick for that commitment on
  that date
- **THEN** the two rows are different rows

### Requirement: A day view is in the order it was handed its commitments

A day view's rows SHALL appear in the order its commitments were handed to it, with the ones that are
not due on the date left out and every other one left where it was. The day view SHALL NOT impose an
order of its own: it MUST NOT sort by name, by the rhythm a commitment runs on, by the day it is kept
from, or by whether it is kept, and it MUST NOT move a row that has been ticked. Any order it
invented would be a rule about a commitment's name, and a name is its owner's words rather than the
system's; a commitment carries no identifier and no day it was written down, so there is nothing else
an order could be made from.

The day view SHALL hold one row per commitment it was handed that is due, and SHALL NOT combine two
into one. Two commitments alike in name, schedule and the day they are kept from are the same
commitment, and handing the same commitment to a day view twice SHALL give two rows: what is handed
over is the caller's list, and deduplicating it would be the day view deciding something about
identity that no capability has given it to decide.

#### Scenario: rows are in the order the commitments were handed over

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, then one named "Run"
  on a schedule listing Monday and Thursday, then one named "Vitamins" on a schedule listing all
  seven weekdays, all three kept from 1 January 2026
- **THEN** the day view's rows are named "Gym", "Run" and "Vitamins", in that order

#### Scenario: handing the same commitments in the opposite order reverses the rows

- **WHEN** the same three commitments — "Gym", "Run" and "Vitamins" — are handed to a day view on
  Monday 31 August 2026, from a history that has taken no tick, in the order "Vitamins", "Run", "Gym"
- **THEN** the day view's rows are named "Vitamins", "Run" and "Gym", in that order

#### Scenario: a kept commitment keeps its place among the ones that are not kept

- **WHEN** a day view is formed on Monday 31 August 2026, of the commitments "Gym", "Run" and
  "Vitamins" handed over in that order, from a history holding a tick for "Run" on that date
- **THEN** the day view's rows are named "Gym", "Run" and "Vitamins", in that order
- **AND** only the middle row says its commitment is kept

#### Scenario: dropping a commitment that is not due leaves the others in their order

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, then one named
  "Finances" on a schedule on the 25th of the month, then one named "Run" on a schedule listing
  Monday and Thursday, all three kept from 1 January 2026
- **THEN** the day view holds two rows, named "Gym" and "Run", in that order

#### Scenario: a commitment handed twice has two rows

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  one commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, handed over twice
- **THEN** the day view holds two rows, both named "Gym"
- **AND** both say the commitment is not kept

### Requirement: A day view is a value

A day view SHALL be the rows it holds and the calendar date it was formed on, and nothing else. Two
day views SHALL be the same day view when they hold the same rows in the same order on the same date,
and SHALL be different when the date differs, or when the rows differ in how many there are, in their
order, in the commitment any one of them is for, or in whether any one of them says its commitment is
kept. Forming a day view twice from the same commitments, in the same order, on the same date and from
the same history therefore SHALL give the same day view.

A day view holds no identity of its own: two day views a person could not tell apart are not
distinguishable to the system either. That cuts both ways, and the second way is the one worth saying
out loud, because a day view is what a date asked and what was done about it rather than a record of
what it was asked from. A difference in what a day view was handed that does not reach a row SHALL
make no difference to the day view. Both ways that can happen follow from the first requirement rather
than adding anything to it: a commitment that is not due on the date produces no row, so a day view
handed it is the same day view as one that was not; and a tick for a commitment the day view was not
handed is never looked up, so a history holding one gives the same day view as a history that does
not. Which commitments were offered, and which ticks a history held besides the ones asked about, are
the caller's to remember; what a day view keeps is the answer.

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
