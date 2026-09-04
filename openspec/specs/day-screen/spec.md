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

### Requirement: A day view moves to the day before it and the day after it

A day view SHALL move, when it is handed some commitments and a history, to the day view of the
calendar date one day earlier than its own and to the day view of the calendar date one day later.
What a move gives SHALL be exactly what forming a day view from those commitments, on that date, in
that history would give, and SHALL differ from it in no way: the day view being moved from
contributes the date it is of, and nothing else at all.

A move SHALL carry nothing else across. It MUST NOT keep a row, a name or an answer about whether a
commitment is kept — every row of the day view moved to is asked again, of the date moved to — and
it MUST NOT reuse the commitments or the history the day view being moved from was formed from,
because a day view holds neither. The commitments and the history a move is handed MAY be different
ones, and the day view given back SHALL then be of those: what was handed over before is the
caller's to remember, and a move that quietly preferred it would be a day view holding a list of its
own.

A move SHALL NOT consult the present moment, the device's clock, its time zone or its locale, and
SHALL NOT be given the day it is being made on. Moving is a question asked about a date, exactly as
forming a day view is, so a day view moves onto a date that has not arrived as readily as onto one
that has, and the day view it gives is the same one tomorrow, next year and for ever. What such a
day view's rows then offer is settled already and is not restated here: a row offers no tick when
its date is later than the day it is asked as of.

Moving SHALL leave the day view moved from unchanged. A move gives a day view back rather than
altering one, so a day view that has been moved from is still the day view it was, and may be moved
from again.

#### Scenario: moving to the day after gives the day view of the next date

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, then one named
  "Run" on a schedule listing Monday and Thursday, then one named "Vitamins" on a schedule listing
  all seven weekdays, all three kept from 1 January 2026, and it is moved to the day after, handed
  those same commitments and that same history
- **THEN** the day view moved to holds one row, named "Vitamins", saying the commitment is not kept
- **AND** it is the same day view as one formed on Tuesday 1 September 2026 from those same
  commitments, in that same order, and that same history

#### Scenario: moving to the day before gives the day view of the previous date

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  tick, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, then one
  named "Run" on a schedule listing Monday and Thursday, then one named "Vitamins" on a schedule
  listing all seven weekdays, all three kept from 1 January 2026, and it is moved to the day before,
  handed those same commitments and that same history
- **THEN** the day view moved to holds one row, named "Vitamins", saying the commitment is not kept
- **AND** it is the same day view as one formed on Tuesday 1 September 2026 from those same
  commitments, in that same order, and that same history

#### Scenario: the rows of the day moved to are asked again rather than carried across

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Vitamins" on a
  schedule listing all seven weekdays, kept from 1 January 2026, from a history holding a tick for
  that commitment on Monday 31 August 2026 and no other tick, and it is moved to the day after,
  handed that same commitment and that same history
- **THEN** the day view moved from holds one row saying the commitment is kept
- **AND** the day view moved to holds one row, named "Vitamins", saying the commitment is not kept

#### Scenario: a move uses the commitments and history it is handed rather than the ones the day view came from

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, and it is moved to the day after, handed instead a single commitment named "Vitamins" on a
  schedule listing all seven weekdays, kept from that same day, and a history holding a tick for
  "Vitamins" on Tuesday 1 September 2026
- **THEN** the day view moved to holds one row, named "Vitamins", saying the commitment is kept
- **AND** it holds no row named "Gym"

#### Scenario: a day view moves onto a date that has not arrived, and its rows offer no tick

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from 1 January 2026,
  and it is moved to the day after, handed that same commitment and that same history
- **THEN** the day view moved to holds one row named "Vitamins"
- **AND** that row, asked as of Monday 31 August 2026, offers no tick
- **AND** the same row, asked as of Tuesday 1 September 2026, offers a tick

#### Scenario: moving to the day after and back again gives the day view it started from

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday and a commitment named "Vitamins" on a schedule listing all
  seven weekdays, both kept from 1 January 2026 and handed over in that order, from a history
  holding a tick for "Gym" on that date, and it is moved to the day after and then to the day
  before, handed those same commitments and that same history each time
- **THEN** the day view arrived at is the same day view as the one started from
- **AND** moving the one started from to the day before and then to the day after gives that same
  day view again

### Requirement: A move is one calendar day, and never more

A move SHALL step exactly one calendar day. The day after the last day of a month SHALL be the first
day of the month that follows it, the day after 31 December SHALL be 1 January of the next year, and
the day after 28 February SHALL be 29 February in a leap year and 1 March in a year that is not one —
a leap day is a day like any other and is neither skipped nor doubled. Moving to the day before
SHALL be the same step taken the other way, so that either move undoes the other.

A move SHALL step to the next date whether or not anything is due on it. It MUST NOT skip a date
because no commitment it was handed is due there, MUST NOT stop at the first date something is due
on, and MUST NOT look at the commitments or the history to decide where it lands: a day with nothing
due is an answer rather than a gap, a day view holding no rows moves exactly as one holding rows
does, and a move that skipped would be the day view deciding which days are worth looking at.

#### Scenario: moving does not skip a date on which nothing is due

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, and it is moved to the day after, handed that same commitment and that same history
- **THEN** the day view moved to holds no rows, though Wednesday 2 September 2026 is the next date
  "Gym" is due on
- **AND** moving that day view to the day after in turn holds one row named "Gym"

#### Scenario: moving across the end of a month

- **WHEN** a day view is formed on Wednesday 30 September 2026, from a history that has taken no
  tick, of a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day after, handed that same commitment and that same
  history
- **THEN** the day view moved to is the same day view as one formed on Thursday 1 October 2026 from
  that commitment and that history
- **AND** moving that day view to the day before gives the day view started from

#### Scenario: moving across the turn of a year

- **WHEN** a day view is formed on Thursday 31 December 2026, from a history that has taken no tick,
  of a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from 1 January
  2026, and it is moved to the day after, handed that same commitment and that same history
- **THEN** the day view moved to is the same day view as one formed on Friday 1 January 2027 from
  that commitment and that history
- **AND** moving that day view to the day before gives the day view started from

#### Scenario: moving across the leap day of a leap year

- **WHEN** a day view is formed on Monday 28 February 2028, from a history that has taken no tick,
  of a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from 1 January
  2026, and it is moved to the day after, handed that same commitment and that same history
- **THEN** the day view moved to is the same day view as one formed on Tuesday 29 February 2028 from
  that commitment and that history
- **AND** moving that day view to the day after in turn gives the day view of Wednesday 1 March 2028

#### Scenario: moving across the end of February in a year that is not a leap year

- **WHEN** a day view is formed on Sunday 28 February 2100, from a history that has taken no tick,
  of a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from 1 January
  2026, and it is moved to the day after, handed that same commitment and that same history
- **THEN** the day view moved to is the same day view as one formed on Monday 1 March 2100 from that
  commitment and that history, 2100 having no leap day
- **AND** moving that day view to the day before gives the day view started from

### Requirement: There is no day before the first supported date and none after the last

A day view of 1 January 1583 SHALL give nothing when moved to the day before, and a day view of
31 December 9999 SHALL give nothing when moved to the day after. Those are the first and last dates
the system forms, so the day beyond either is not a calendar date at all, in the way 30 February is
not one, and a day view of a date that does not exist cannot be given.

Nothing SHALL be given rather than the same day view handed back. A caller that wants to stay where
it is can keep the day view it already holds, and one that needs to know it has reached the end of
the calendar could not recover that from a day view equal to the one it asked with.

The refusal SHALL be about the calendar and about nothing else. It MUST NOT depend on which
commitments the move was handed, on what the history holds, on whether the day view being moved from
has any rows, or on which day the caller believes it is: the same day view moved the other way SHALL
move normally, and every day view of any other date SHALL move both ways.

#### Scenario: the first supported date has no day before it

- **WHEN** a day view is formed on Saturday 1 January 1583, from a history that has taken no tick,
  of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 1583, and it is moved to the day before, handed that same commitment and that same
  history
- **THEN** nothing is given
- **AND** moving that same day view to the day after gives the day view of Sunday 2 January 1583,
  which holds no rows

#### Scenario: the last supported date has no day after it

- **WHEN** a day view is formed on Friday 31 December 9999, from a history that has taken no tick,
  of a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from 1 January
  1583, and it is moved to the day after, handed that same commitment and that same history
- **THEN** nothing is given
- **AND** moving that same day view to the day before gives the day view of Thursday 30 December
  9999, which holds one row named "Vitamins"

#### Scenario: the date one day inside each end of the supported dates moves onto that end

- **WHEN** a day view is formed on Sunday 2 January 1583, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  1583, and it is moved to the day before, handed that same commitment and that same history
- **THEN** the day view moved to is the same day view as one formed on Saturday 1 January 1583 from
  that commitment and that history
- **AND** a day view formed on Thursday 30 December 9999, from a history that has taken no tick, of
  a commitment named "Vitamins" on a schedule listing all seven weekdays, kept from 1 January 1583,
  moved to the day after, is the same day view as one formed on Friday 31 December 9999 from that
  commitment and that history

#### Scenario: the refusal at either end does not depend on what the day view holds

- **WHEN** a day view is formed on Saturday 1 January 1583, from a history that has taken no tick,
  of a commitment named "Run" on a schedule listing Monday and Thursday, kept from 1 January 1583,
  and a second is formed on Friday 31 December 9999, of a commitment named "Vitamins" on a schedule
  listing all seven weekdays, also kept from 1 January 1583, from a history holding a tick for
  "Vitamins" on Friday 31 December 9999
- **THEN** the first holds no rows and gives nothing when moved to the day before
- **AND** the second holds one row saying the commitment is kept and gives nothing when moved to the
  day after

### Requirement: A day screen moves the day it is showing one calendar day either way

A day screen SHALL move the day it is showing to the calendar date one day earlier than it and to the
calendar date one day later. What a move gives SHALL be what moving the day view the screen holds
gives, handed the commitments and the record the screen already holds: the step is exactly one
calendar day whatever month, year or leap day it crosses, and it is taken whether or not anything is
due on the day landed on. Neither is restated here — a day screen's move is this capability's own
answer about a day view, asked from the screen.

A move SHALL be asked of the screen and SHALL be handed nothing. A day view holds neither commitments
nor a history and must be given both to move; a day screen holds both already, and a move that took
either from a caller would let two callers put one screen on two different days.

The today SHALL NOT move. A move changes the day being shown and nothing else, so the day the screen
was handed when the app was last shown is the same day after any number of moves in either direction.
Every question a day screen asks as of a day SHALL still be asked as of that today — which tick a row
offers, and whether the day it says is said as today — and a move that carried the today with it
would put a screen two days forward in a position to offer a tick for a day that has not arrived.

A day screen SHALL step as far back and as far forward as the calendar goes, and SHALL add no bound
of its own. It MUST NOT stop at the today it holds, at the earliest day a commitment it was handed is
kept from, or at any day read off what the record holds: a day it can form a day view of is a day it
can show. A day before every commitment was kept from holds no rows, which is an answer rather than a
gap; a day that has not arrived holds rows that already refuse their ticks. A bound at either end
would be a second rule stacked on an answer this capability already gives.

A move SHALL NOT read the record again. It SHALL form the day view from the record as the screen last
read it — the reading done when the app was shown, together with every change kept on the screen
since — in the way making a tick does. Being shown is the moment a day screen learns what is at its
place, and a move is not a moment the record can have changed under the person looking at it. A move
SHALL therefore leave what the screen says about its record exactly as it was, and a day screen that
is not keeping a record SHALL move like any other and go on saying so.

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
from the commitments and the record the screen already holds. It is a move like any other in every
respect but the distance: it reads no record again, it leaves what the screen says about its record
alone, and it moves the day being shown and never the today.

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

### Requirement: A day screen holds the day view of the day it was handed, formed from the record kept at its place

A day screen SHALL be opened from three things: some commitments, the day it is being opened on, and
the place its record is kept at. It SHALL hold the day view of those commitments on that day, formed
from the history held at that place, and SHALL give that day view back whole and unaltered. It adds
nothing to it and takes nothing away: which commitments have a row, in which order, and what each
row says are already this capability's answers about a date, and what is kept at a place is the
`record` capability's answer, so a day screen SHALL hold exactly the day view that would be formed
directly from the same commitments, the same day and that same history.

The today a day screen holds SHALL be given to it and never asked for. This capability MUST NOT read
a clock, MUST NOT consult the present moment, the device's time zone or the locale, so a day screen
opened as of any date the system supports holds that date's day view whatever day it really is, and
two day screens opened as of the same day from the same record hold the same day view for ever.

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

The tick SHALL be the one the row itself offers, asked as of the day the screen holds. The screen
MUST NOT form a tick of its own, MUST NOT choose which tick a row means, and MUST NOT reach past a
row to the commitment underneath it. A row the screen's day view does not hold SHALL change nothing
at all: a row is a commitment's line on a date, so a row from a day this screen is no longer on, or
from another screen entirely, ticks nothing here.

The change SHALL be kept at the screen's place before its day view says so, and the day view SHALL
then be formed again from the record as it stands rather than the day view it held being altered:
what a person reads is always an answer taken from what is kept. A change that could not be kept
SHALL be refused, SHALL be reported to the caller rather than passed over, and SHALL leave the day
view exactly as it was. The day view a person reads MUST NOT be ahead of what is kept at the place,
and a tick that could not be kept MUST NOT be held anywhere in its place.

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
### Requirement: A day screen keeps its record at a place that survives the app being closed

A day screen SHALL name the place it keeps its record at, and MUST NOT leave that choice to whatever
draws it. The place SHALL be one whose contents survive the app being closed, being force-quit and
the device being restarted, and are carried in a backup of the device: it SHALL be inside the
directory the platform reserves for an application's own supporting data — `Application Support` —
within a directory belonging to this app, and it SHALL be one file.

It MUST NOT be the caches directory, which the system empties when it is short of space, and MUST
NOT be the temporary directory, which is not carried in a backup. Either would silently lose the one
thing this product promises to keep, and neither the store nor `record` can refuse a bad place from
where they sit: a store keeps a history at whatever place it is given.

The place SHALL be the same place every time it is asked for, so that the app opened again reads
what the app before it wrote.

#### Scenario: the place a day screen keeps its record is under Application Support, in a directory of the app's own

- **WHEN** the place a day screen keeps its record at is asked for
- **THEN** it is inside the platform's application-support directory
- **AND** it is one file inside a directory of this app's own within it, rather than directly inside
  it

#### Scenario: the place a day screen keeps its record is neither the caches directory nor the temporary directory

- **WHEN** the place a day screen keeps its record at is asked for
- **THEN** it is not inside the platform's caches directory
- **AND** it is not inside the temporary directory

#### Scenario: the place a day screen keeps its record is the same place every time it is asked

- **WHEN** the place a day screen keeps its record at is asked for twice
- **THEN** the two are the same place

### Requirement: A day screen that cannot read its record draws the day and keeps nothing

Opening a day screen at a place holding something that cannot be read as a record SHALL give a day
screen rather than an error. It SHALL hold the day view of its day formed from a history that has
taken no tick, so a person can still see what the day asks of them, and it SHALL say that it is not
keeping a record.

Such a screen SHALL take no tick. A tick made on it MUST NOT be shown as kept, MUST NOT be held in
memory to be kept later, and MUST NOT be kept anywhere else: a screen that shows a tick it cannot
keep is exactly the lost record this product exists to prevent, and one that cannot keep a tick is
better silent than convincing.

It SHALL leave what is at the place exactly as it was — not overwritten, not moved, not emptied —
so that a later version of the app, or the person, can still recover it. That is the `record`
capability's own refusal carried through rather than a second rule, and every way a store can refuse
to open SHALL be answered in that one way — the day drawn, no tick taken, what is at the place left
exactly as it was — whatever the reason was.

A day screen that is not keeping a record SHALL say which of two things is so: that the record at
its place was **written by a later version of DayByDay**, or only that the record could not be read.
It MUST NOT tell any other reason apart, and MUST NOT say a record was written by a later version
when it was refused for any other reason. The two are separated because a person can act on them
differently and only differently: a record written by a later version is whole, and what is behind
is the app, so the answer is to update the app and on no account to delete or replace what is at the
place — while a screen that says only that something is wrong with the record invites exactly the
one action that loses it, which is the loss this product exists to prevent. Every other reason a
store can refuse to open leaves a person the same single thing to do, so telling those apart buys
nothing and this capability does not.

A day screen that could read its record SHALL say that it is keeping one.

#### Scenario: a day screen opened where the record cannot be read still holds the day view of that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday and a commitment named "Run" on a schedule listing Tuesday, Thursday and
  Sunday, both kept from 1 January 2026
- **THEN** its day view holds one row, for "Gym"
- **AND** that row says the commitment is not kept

#### Scenario: a day screen opened where the record cannot be read says it is not keeping one and gives no further reason

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026
- **THEN** it says it is not keeping a record
- **AND** it does not say the record was written by a later version of DayByDay

#### Scenario: a record written in a later form than this app knows makes a day screen that says the record is from a later version

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a record written
  in a form one later than the form this app writes, holding no ticks, of a commitment named "Gym"
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026
- **THEN** it says it is not keeping a record
- **AND** it says the record was written by a later version of DayByDay
- **AND** its day view holds one row, for "Gym", saying the commitment is not kept

#### Scenario: a day screen opened where the record can be read says it is keeping one

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026
- **THEN** it says it is keeping a record
- **AND** a day screen opened at a place where a tick has been kept says the same

#### Scenario: ticking a row on a day screen that is not keeping a record changes nothing and keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
- **THEN** its day view still says the commitment is not kept on that date
- **AND** it still says it is not keeping a record

#### Scenario: a day screen opened where the record cannot be read leaves what is at the place as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
- **THEN** the content at that place is byte-for-byte what it was before the screen was opened

#### Scenario: ticking a row on a day screen holding a record from a later version keeps nothing and leaves the record as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a record written
  in a form one later than the form this app writes, holding no ticks, of a commitment named "Gym"
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is
  ticked
- **THEN** its day view still says the commitment is not kept on that date
- **AND** it still says the record was written by a later version of DayByDay
- **AND** the content at that place is byte-for-byte what it was before the screen was opened

### Requirement: A day screen re-reads its day and its record when the app is shown again

A day screen SHALL be told when the app has been shown — opened from nothing, or brought back in
front of a person — and SHALL be handed the day it has been shown on. On being told, it SHALL take
that day as the day it holds and form its day view again, from the record read again at its place.
This SHALL be the only moment a day screen changes day.

A day screen shown again on a later day SHALL hold that later day's day view, so a morning visit
lands on the morning rather than on the night before. A day screen shown again on the day it is
already on SHALL hold that same day's day view, formed again rather than merely kept.

Reading the record again SHALL be a fresh opening at the place rather than a re-reading of what was
already held, so a change made at that place since SHALL be seen. A day screen that could not read
its record when it opened SHALL say it is keeping one after being shown again where the record can
then be read, and one that could SHALL say it is not after being shown again where it then cannot.
What it says about the record SHALL be formed again from what is at the place as it then stands and
never carried over, the reason included: a screen that said only that the record could not be read
SHALL say the record was written by a later version of DayByDay when that is what is then at the
place. Nothing else of a day screen SHALL survive being shown again: the commitments it was handed
and the place it keeps its record at are all it carries across.

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

### Requirement: A day view says its day as a weekday and a date, and says Today on the day it is asked as of

A day view SHALL say the day it is of, in words, when it is asked as of a day. That answer is its
**day title**, and it is read off the day view's date and off the day it is asked as of, and off
nothing else: it MUST NOT depend on the rows the day view holds, on whether any of them says its
commitment is kept, or on how many there are, so a day view holding no rows at all says its day
exactly as one holding seven does.

The date SHALL be said as four things in this order, separated by single spaces: the name of the
weekday, the day of the month as a number with no leading zero, the name of the month, and the year
as four digits — "Monday 31 August 2026". On the day it is asked as of, and on no other day, the
word "Today" SHALL be said in front of that date, separated from it by a space, a middle dot and a
space — "Today · Thursday 3 September 2026". The day it is asked as of SHALL decide that and nothing
else: no other day is named in words, so the day before is said as its date exactly as the day after
is, and the date itself is said the same way whatever day the question is asked as of.

The names of the weekdays and of the months SHALL be this capability's own — the English names,
fixed here — and MUST NOT be taken from the device's language, region, locale or calendar
preferences. The same day is said in the same words on every device, which is what makes a day title
something a test can state at all. As throughout this capability, the question is asked *of a date*:
this capability MUST NOT read a clock and MUST NOT consult the present moment or the device's time
zone, so a day title is answered for every date the system supports and a past day's title reads
tomorrow exactly as it does now.

#### Scenario: a day view says its day as a weekday, a day of the month, a month and a year

- **WHEN** a day view of Monday 31 August 2026 is asked what its day is as of Thursday 3 September
  2026
- **THEN** it says "Monday 31 August 2026"

#### Scenario: a day view of the day it is asked as of says Today before the date

- **WHEN** a day view of Thursday 3 September 2026 is asked what its day is as of Thursday
  3 September 2026
- **THEN** it says "Today · Thursday 3 September 2026"

#### Scenario: a day view of a day before the one it is asked as of says the date and not Today

- **WHEN** a day view of Wednesday 2 September 2026 is asked what its day is as of Thursday
  3 September 2026
- **THEN** it says "Wednesday 2 September 2026"

#### Scenario: a day view of a day after the one it is asked as of says the date and not Today

- **WHEN** a day view of Friday 4 September 2026 is asked what its day is as of Thursday 3 September
  2026
- **THEN** it says "Friday 4 September 2026"

#### Scenario: a day of the month below ten is said without a leading zero

- **WHEN** a day view of Tuesday 1 September 2026 is asked what its day is as of Thursday
  3 September 2026
- **THEN** it says "Tuesday 1 September 2026"

#### Scenario: every weekday is said by its own name

- **WHEN** the day views of the seven days from Monday 31 August 2026 to Sunday 6 September 2026 are
  each asked what their day is as of Thursday 1 January 2026
- **THEN** they say "Monday 31 August 2026", "Tuesday 1 September 2026", "Wednesday 2 September
  2026", "Thursday 3 September 2026", "Friday 4 September 2026", "Saturday 5 September 2026" and
  "Sunday 6 September 2026"

#### Scenario: every month is said by its own name

- **WHEN** the day views of the fifteenth day of each of the twelve months of 2026 are each asked
  what their day is as of Thursday 1 January 2026
- **THEN** they say "Thursday 15 January 2026", "Sunday 15 February 2026", "Sunday 15 March 2026",
  "Wednesday 15 April 2026", "Friday 15 May 2026", "Monday 15 June 2026", "Wednesday 15 July 2026",
  "Saturday 15 August 2026", "Tuesday 15 September 2026", "Thursday 15 October 2026", "Sunday
  15 November 2026" and "Tuesday 15 December 2026"

#### Scenario: a day view says its day in the first supported year and in the last

- **WHEN** a day view of Saturday 1 January 1583 is asked what its day is as of Monday 3 January
  1583
- **THEN** it says "Saturday 1 January 1583"
- **AND** a day view of Friday 31 December 9999 asked as of Monday 27 December 9999 says "Friday
  31 December 9999"

#### Scenario: a day view says the leap day of a leap year

- **WHEN** a day view of Tuesday 29 February 2028 is asked what its day is as of Monday 28 February
  2028
- **THEN** it says "Tuesday 29 February 2028"

#### Scenario: a day view holding no rows says its day just the same

- **WHEN** a day view of no commitments at all on Wednesday 2 September 2026 is asked what its day
  is as of Thursday 3 September 2026
- **THEN** it holds no rows
- **AND** it says "Wednesday 2 September 2026"



#### Scenario: a day screen moved off today keeps the day it is showing when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day before; and the app is then shown again as of Wednesday
  2 September 2026
- **THEN** its day view is the same day view as one formed directly of those two commitments, in that
  order, on Sunday 30 August 2026, from a history that has taken no tick
- **AND** it says the day is "Sunday 30 August 2026"

#### Scenario: a day screen moved away and back onto today moves onto the new day when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day before and then to the day after; and the app is then
  shown again as of Wednesday 2 September 2026
- **THEN** its day view is the same day view as one formed directly of those two commitments, in that
  order, on Wednesday 2 September 2026, from a history that has taken no tick
- **AND** it says the day is "Today · Wednesday 2 September 2026"

#### Scenario: a day screen sent back to today moves onto the new day when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before three times; it is sent back to today; and the app is
  then shown again as of Wednesday 2 September 2026
- **THEN** it says the day is "Today · Wednesday 2 September 2026"

#### Scenario: a day screen kept on a day that has since arrived offers the tick it refused before

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day after, onto Tuesday 1 September 2026, and its one row is
  ticked; the app is then shown again as of Tuesday 1 September 2026; and the one row it then holds
  is ticked
- **THEN** the first ticking left the day view saying the commitment is not kept
- **AND** after being shown again it says the day is "Today · Tuesday 1 September 2026"
- **AND** the second ticking makes its day view say the commitment is kept on Tuesday 1 September
  2026

#### Scenario: a day screen moved off today reads its record again when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before; a tick for that commitment on Sunday 30 August 2026
  is then kept at that place by something else; and the app is shown again as of Monday 31 August
  2026
- **THEN** its day view says the commitment is kept on Sunday 30 August 2026
- **AND** it says the day is "Sunday 30 August 2026", the screen not having moved



### Requirement: A day screen says the day it is showing, as of the day it was handed

A day screen SHALL say the day it is showing, and that SHALL be its day view's day title asked as of
the today it was handed. It adds nothing to that answer and takes nothing away: the words are the day
title requirement's, and the only thing a day screen contributes is the day the question is asked as
of, which is the today it holds and is the one thing here that is not on the screen already.

The date it says SHALL follow the day the screen is showing, and the word "Today" SHALL follow the
today. A day screen moved off its today therefore says a bare date, and one showing its today — for
having never moved, for having been moved back, or for having been sent back — says "Today" in front
of that date. That is how a person knows they are not where they started, and it is why a screen that
can be moved has to say its day at all.

The today SHALL be the one the screen was handed and never one it went looking for. A day screen MUST
NOT read a clock to say its day, so a screen handed a day says that day whatever day it really is,
and it says the same day until it is moved or the app is shown again — a tick made on it MUST NOT
change what it says the day is, and neither MUST time passing.

A day screen SHALL say its day whether or not it is keeping a record. What a date asks of a person
needs no record to answer, so a screen that could not read one says its day exactly as a screen that
did.

#### Scenario: a day screen says the day it is showing

- **WHEN** a day screen is opened as of Thursday 3 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026
- **THEN** it says the day is "Today · Thursday 3 September 2026"

#### Scenario: a day screen says the day it was handed rather than the day it really is

- **WHEN** a day screen is opened as of Monday 3 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583
- **THEN** it says the day is "Today · Monday 3 January 1583"
- **AND** a day screen opened the same way as of Monday 27 December 9999 says the day is "Today ·
  Monday 27 December 9999"

#### Scenario: a day screen says the day its own day view says, asked as of the day it was handed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026
- **THEN** what it says the day is is what its day view says when that day view is asked as of Monday
  31 August 2026

#### Scenario: a day screen shown again on a later day says that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the app is then shown again as of Tuesday 1 September 2026
- **THEN** it says the day is "Today · Tuesday 1 September 2026"

#### Scenario: a day screen that cannot read its record still says the day

- **WHEN** a day screen is opened as of Monday 31 August 2026, of a commitment named "Journaling" on
  a schedule listing all seven weekdays, kept from 1 January 2026, at a place holding a run of bytes
  that is not a record
- **THEN** it says it is not keeping a record
- **AND** it says the day is "Today · Monday 31 August 2026"

#### Scenario: a day screen says the same day after a tick is made on it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and its one row is ticked
- **THEN** it says the day is "Today · Monday 31 August 2026", exactly as it did before the tick

#### Scenario: a day screen moved to another day says that day and does not say Today

- **WHEN** a day screen is opened as of Thursday 3 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day before
- **THEN** it says the day is "Wednesday 2 September 2026"
- **AND** moving it to the day before again makes it say the day is "Tuesday 1 September 2026"

#### Scenario: a day screen sent back onto today says Today again

- **WHEN** a day screen is opened as of Thursday 3 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before twice; and it is then sent back to today
- **THEN** it says the day is "Today · Thursday 3 September 2026"

