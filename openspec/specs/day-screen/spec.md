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

The row SHALL offer nothing when the day view's date is later than the day it is asked as of, and
SHALL offer nothing when its commitment's kind is not a tick. Where neither holds it SHALL offer the
tick. A row asked as of its own date SHALL offer the tick — a day that has arrived can have been
kept, and only one that has not is refused — and so SHALL a row whose date is earlier, however much
earlier: the past is writable back to the day the commitment is kept from, and a commitment that is
not due there has no row to ask.

A row whose commitment's kind is not a tick SHALL offer nothing whatever day it is asked as of, and
that is a refusal of a different shape from the one about a day that has not arrived. There is no
tick of such a commitment for it to offer: a tick is of a commitment whose kind is a tick, which is
the `record` capability's rule and not one restated here. The row itself is unchanged and stays in
the day view, because the commitment is due on that date and a day view holds a row for every
commitment that is; hiding it would be a day view that answers a different question from the one it
was asked. What such a row offers *instead* of a tick is not this requirement's — offering nothing
is the honest answer while there is nothing to offer, and a tick offered in its place would record
that a weight was taken when no weight was given.

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

A row SHALL refuse for those two reasons and no other. A row exists only for a commitment that is
due on the day view's date, so being due on the date and the commitment's kind together are the
whole of what makes a tick formable: a row offers nothing when it is asked as of a day earlier than
its own, and a row offers nothing when its commitment's kind is not a tick. It MUST NOT refuse on
what the history says, on how many rows the day view holds, or on anything about the commitment
other than the kind its days take.

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

#### Scenario: a row for a commitment whose kind is not a tick offers nothing

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of Monday
  31 August 2026
- **THEN** the day view holds one row named "Weight", saying the commitment is not kept
- **AND** that row offers no tick
- **AND** the same row asked as of Sunday 6 September 2026, a day later than its own, offers no tick
  either
- **AND** a row for a commitment alike in every way but of the tick kind, asked as of Monday
  31 August 2026, offers a tick

### Requirement: A row is a commitment's line on a date

A row SHALL be three things and no others: the commitment it is a line for, the date the day view
holding it is of, and what the history the day view was formed from says about that commitment on
that date — whether it is kept, and, where its commitment's kind is a number, a note or a total,
the number that day holds, the note that day holds, or **the sum that day's additions come to**. Two
rows SHALL be the same row when all three agree, and SHALL be different when any one of them
differs.

The third of the three is one thing rather than three. A tick commitment's day is kept or it is not
and there is nothing else to know about it; a number commitment's day holds a number or it does
not, a note commitment's day holds a note or it does not, and holding one is what makes either
kept. Two rows of one number commitment on one date holding different numbers are therefore
different rows, for the reason two dates are: they offer different number entries, and one cannot
stand in for the other. Two rows of one note commitment on one date holding different notes are
different rows by the very same argument, and a row's third part grows by the note for the same
reason it grew by the number rather than for a new one. It grows by the **sum** for that reason a
third and last time: two rows of one total commitment on one date whose days have added different
amounts offer different total entries, and one cannot stand in for the other.

What a total row holds is the day's **sum** and never its additions, so two rows of one total
commitment on one date whose days hold different additions summing alike SHALL be **the same row**.
That is the shape this capability wants rather than a gap in it: everything a row does with what its
day holds — what its entry says, whether it offers a take-back, whether it is kept — is answered by
the sum, and taking a last addition back is answered by the record at the place rather than by the
row that asked for it. A row carrying the list so that two such rows could be told apart would give
this capability the additions themselves, which the requirement on what a total entry says exists to
keep out of it.

A row SHALL hold **only what its own commitment's kind can put there**. A tick commitment's row
holds neither a number nor a note, a number commitment's row holds no note, and a note commitment's
row holds no number — the history answers *no number* and *no note* for a commitment of any other
kind, so this follows from what a history says rather than being a rule this capability adds. A row
of any kind but a total holds a sum of **zero**, and holds it as a sum rather than as nothing at all,
because that is what a history answers for such a commitment; so every row holds a sum, and only a
total row's can be above zero.

The date is part of what a row is rather than something the day view alone holds. Two rows for the
same commitment, each saying the same thing about it, on two different dates SHALL be different
rows: they offer different ticks, and one cannot stand in for the other. This adds to what a day
view is without changing it — a day view is already its rows and its date, so day views on two dates
were already two day views, and this makes them so a second way rather than a new way.

A row SHALL be reachable only through the day view that holds it, and SHALL give back four things:
its commitment's name, **the rhythm that commitment runs on in words**, whether that commitment is
kept, and **what it offers** — a tick, a number entry, a note entry or a total entry, according to
its commitment's kind, and, on a total row whose day holds an addition, taking that addition back
besides. It MUST NOT give back the commitment itself, the schedule underneath it, the day it is kept
from, the date the row is for, **the number that day holds**, **the note that day holds**, or **the
sum that day's additions come to**: what a reader is given is what a screen draws and what a tap
makes, and nothing else has been asked for.

None of the number, the note and the sum is among them, though a row now holds all three. Each is
given out only inside the entry a row offers, so that a screen drawing a row has nothing to draw it
with: a row for a day holding 70.5, a row for a day holding "Ran 8k." and a row for a day that has
added 30 each say what a ticked row says and no more. That is a shape rather than a rule someone has
to keep, which is why what the day holds is part of what a row *is* and no part of what a row *gives
back* — and it matters more for a note than for a number, since a note is the one record long enough
that drawing it in a list would change what the list is for.

The words SHALL be the ones the `schedule` capability says for the schedule the row's commitment
carries, and this capability SHALL compose none of them — they are the same words a commitments
screen's entry says for the same commitment, so one rhythm reads the same way on both screens.
Giving them back is not this capability reaching past a commitment to the schedule underneath it:
the words are asked of the commitment, exactly as its name is.

Every row SHALL say its rhythm, on every day view, always — not only where two rows would otherwise
read alike. The day screen is the daily visit, and what rhythm a thing runs on is part of reading
the day rather than a disambiguation added when a name happens to repeat. A row SHALL say it
whether or not the commitment is kept on that date, and whatever the row offers or does not: a row
for a day that has not arrived offers nothing at all and says its rhythm like every other row, and
so does a row offering a number entry in a tick's place.

The rhythm is not a fourth thing a row is: the words are read off the commitment the row already
holds, so two rows agreeing on the three things above agree on the rhythm they say, and no row is
made different from another by this requirement.

#### Scenario: two rows for the same commitment and date saying the same thing are the same row

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on
  a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, each from a history
  holding a tick for that commitment on that date
- **THEN** each holds one row saying the commitment is kept
- **AND** the two rows are the same row

#### Scenario: two rows for the same commitment on different dates are different rows

- **WHEN** two day views are formed of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, each from a history that has taken no tick,
  one on Monday 31 August 2026 and one on Wednesday 2 September 2026
- **THEN** each holds one row named "Gym", saying the commitment is not kept
- **AND** the two rows are different rows

#### Scenario: two rows for the same commitment and date differing in whether it is kept are different rows

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on
  a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, the first from a
  history that has taken no tick and the second from a history holding a tick for that commitment
  on that date
- **THEN** the two rows are different rows

#### Scenario: a row says the rhythm its commitment runs on in words

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick,
  of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, one named
  "Finances" on a schedule on the 31st of the month, one named "Contact lenses" on a schedule of
  every 14 days starting on 31 August 2026, and one named "Reading" on a schedule of 3 times a
  week, all kept from 1 January 2026
- **THEN** the day view holds four rows, saying "Mon, Wed, Sat", "The 31st", "Every 14 days" and
  "3x a week" in that order

#### Scenario: a row says its rhythm whether or not its commitment is kept

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on
  a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, the first from a
  history that has taken no tick and the second from a history holding a tick for that commitment
  on that date
- **THEN** the first day view's row says it is not kept and says "Mon, Wed, Sat"
- **AND** the second day view's row says it is kept and says "Mon, Wed, Sat"

#### Scenario: a row for a day that has not arrived says its rhythm

- **WHEN** a day view is formed on Friday 4 September 2026, from a history that has taken no tick,
  of a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026,
  and its row is asked for the tick it offers as of Thursday 3 September 2026
- **THEN** the row offers no tick
- **AND** the row says "Every day"

#### Scenario: two rows for commitments alike in name and not in rhythm say different rhythms

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick,
  of a commitment named "Vitamins" on a schedule listing Monday and Wednesday and a commitment
  named "Vitamins" on a schedule listing all seven weekdays, both kept from 1 January 2026
- **THEN** the day view holds two rows, both named "Vitamins"
- **AND** the first says "Mon, Wed" and the second says "Every day"

#### Scenario: two rows for the same number commitment and date holding different numbers are different rows

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Weight"
  of the number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, the first from a history holding a number of 70.5 for that
  commitment on that date and the second from a history holding a number of 71 for it on that date
- **THEN** each holds one row saying the commitment is kept
- **AND** the two rows are different rows

#### Scenario: two rows for the same number commitment and date holding the same number are the same row

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Weight"
  of the number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, each from a history holding a number of 70.5 for that
  commitment on that date
- **THEN** each holds one row saying the commitment is kept
- **AND** the two rows are the same row

#### Scenario: two rows for the same note commitment and date holding different notes are different rows

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Journal"
  of the note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026,
  the first from a history holding a note of "Ran 8k." for that commitment on that date and the
  second from a history holding a note of "Rested." for it on that date
- **THEN** each holds one row saying the commitment is kept
- **AND** the two rows are different rows

#### Scenario: two rows for the same note commitment and date holding the same note are the same row

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Journal"
  of the note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026,
  each from a history holding a note of "Ran 8k." for that commitment on that date
- **THEN** each holds one row saying the commitment is kept
- **AND** the two rows are the same row

#### Scenario: two rows for the same total commitment and date whose days have added different amounts are different rows

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, the first from a history holding an addition of 30 for that commitment on that
  date and the second from a history holding one of 90 for it on that date
- **THEN** each holds one row saying the commitment is not kept
- **AND** the two rows are different rows

#### Scenario: two rows for the same total commitment and date whose days have added the same amount are the same row

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, each from a history holding an addition of 30 for that commitment on that date
- **THEN** each holds one row saying the commitment is not kept
- **AND** the two rows are the same row

#### Scenario: two rows whose days hold different additions summing alike are the same row

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, the first from a history holding additions of 30 and 30 for that commitment on
  that date and the second from a history holding one addition of 60 for it on that date
- **THEN** the two rows are the same row
- **AND** the entry each offers says "60 of 120"

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

**Nor is it a rule that a day screen says nothing about the days either side of the one it is
showing.** A day screen says the day view of the day before and the day view of the day after, and at
1 January 1583 and 31 December 9999 it says none on that side — *A day screen says no day view before
the first supported date and none after the last*. That absence is visible to a caller and this
requirement's refusal is narrowed to leave room for it, on the distinction it already draws once
above: **what the screen can draw is not whether it can move.** An absent day view says there is
nothing to draw beside the day being shown, which is what a gesture reaching past the end of the
calendar resists against; it says nothing about whether the move may be asked for, and a caller MUST
NOT stand a move down on the strength of it. Asking for a move that has nowhere to go SHALL go on
being answered by this requirement — by the screen staying exactly as it is, reporting nothing — and
that is still the only answer about moving this capability gives.

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

### Requirement: A day screen takes on the commitments it was handed when its roster holds nothing at all

A day screen SHALL be handed some commitments, and SHALL take them on — in the order it was handed
them — exactly when the roster it has just read holds nothing at all. It SHALL keep them at its
roster place before drawing from them, and the day view it then holds SHALL be of the roster as it
then stands rather than of the list it was handed.

A roster holding anything at all SHALL be left exactly as it is, and the commitments handed in SHALL
NOT be taken on a second time. A roster every one of whose commitments has been stopped **or
removed** still holds them, so it is not a roster holding nothing and MUST NOT be written over: what
makes this a first launch is that nothing has ever been taken on, not that nothing is being kept
today and not that nothing is being offered today.

That a removal leaves the commitment in the roster is what makes this hold without a marker of its
own. A roster that dropped its entries would read as a roster holding nothing the moment a person
removed the last of them, and day one — the owner's own eight commitments — would be written on top
of a list they had just deliberately emptied, on a phone that has been in use for months. ADR-1027
and ADR-1035 are read together here.

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

#### Scenario: a day screen opened on a roster whose commitments have all been removed takes nothing on

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and removed as of Sunday 30 August 2026; and a day
  screen of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  that same day, is opened at that roster place as of Monday 31 August 2026, at a record place where
  nothing has been kept
- **THEN** its day view holds no rows
- **AND** a roster store opened afterwards at that roster place holds a roster that is the same
  roster as one given "Journaling" once and asked to remove it as of Sunday 30 August 2026
- **AND** "Gym" is not at that roster place

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

### Requirement: A day screen tells on the row that was tapped that a change could not be kept

Where a change a row offers cannot be kept, a day screen SHALL tell it **on that row** — the row
that was tapped or committed on — as well as refusing the change to the caller. The two are not
alternatives and neither replaces the other: the refusal reaching the caller is what a test
asserts on and what stops a shell drawn later from swallowing the failure a second time, and what
is told on the row is what a person reads. A day screen that only threw would be silent to the
person; one that only told the row would be silent to everything else.

Where instead it is the **value** a person gave that was refused, the telling on the row SHALL be
the whole of the report and nothing SHALL be thrown. Nothing was asked of the place, so there is
no failure for a caller to swallow, and the cause named below carries more than a throw could:
what a person must give instead. Which values those are is the requirement on entering a number,
the one on reading what an entry is committed with as a number, and the one on reading what is
committed in a total entry, and none of the three is restated here.

It SHALL name a cause **only where a person can act on that cause differently**, and SHALL tell
every other refusal the same way and name nothing at all. The test is what a person does next, and
it is the one this capability already applies to a record that could not be opened. A change the
place refused leaves a person exactly one thing to do whatever the reason was — try again, and if
it keeps failing, look at the device — so it names nothing: it MUST NOT tell which of making the
tick and taking it back was asked for, it MUST NOT tell which of entering a number and taking one
back was asked for, it MUST NOT tell which of writing a note and taking one back was asked for, it
MUST NOT tell which of adding to a day and taking that day's last addition back was asked for, and
it MUST NOT tell why the place would not take the change.

**Exactly four causes SHALL be named, and every one of them is the value a person gave.** A value
committed in a number entry **or in a total entry** that is not a number SHALL be told as "Not a
number" — one cause and not two, because the person's next act is the same one in both and a second
wording for it would be two messages saying one thing. A number the commitment refuses SHALL be told
by naming the range that commitment declares — "Must be between 40 and 150" for a range of 40 to
150 — because the one thing the person can do about it is give a number inside those bounds, and
"try again" is false there: 300 against 40 to 150 is refused for ever, however many times it is
committed. An amount committed in a total entry that is not above zero SHALL be told as **"Must be
more than 0"**. An amount that would take that day's additions past what this system can keep exactly
SHALL be told as **"Too large to add"**. The words SHALL be this package's own English and no
locale's, and each bound SHALL be said exactly as the commitment declares it, as a range hint says
it.

**The two new causes are named on this requirement's own test and no other.** A person told "Must be
more than 0" gives a different amount; a person told "Too large to add" gives a smaller one; neither
is anything "try again" would fix, and neither is the place's doing. The second says the only thing
its person can act on: the headroom it could otherwise name is a thirty-eight-digit number, and a
message nobody can use is a message that teaches them to ignore the next one.

**No fifth cause SHALL be named.** A number a commitment with no range would refuse does not exist —
every number is a number to it — and a total commitment declares no bound of its own at all, so the
refusals a total row can meet are exactly the three above and the place's own, which names nothing.
A cause a person cannot act on differently MUST NOT be named however easily it could be.

**A note names no cause at all.** A note commitment declares no bound, and every text that says
something is a note, so there is nothing this screen can refuse a committed note for but the place
refusing to take it — and a text that says nothing is not a refusal but the take-back. A note SHALL
therefore be told exactly as a refused tick is: on the row, naming nothing. Nothing about a note's
length, its script, its line breaks or its characters SHALL be named as a cause, because no such
refusal exists to name and inventing a message for one would teach a person a rule this product does
not have.

**A commit in a total entry that says nothing names no cause either, because it is no refusal.** It
keeps nothing and takes nothing back, which is what a person who committed an empty field asked for;
telling them something would be answering a question they did not ask.

It SHALL tell it of **at most one row at a time**, and that row SHALL be the row tapped or
committed on last. A second refusal SHALL move what is told — and the cause it names, or the
absence of one — onto its own row, and SHALL leave nothing on the first: one refusal is one event,
two notices say the same thing twice, and the tap the person is waiting on an answer for is the
one they just made.

The row it is told of SHALL be named by what a row is — a commitment's line on a date — and this
capability SHALL give a row no identity beyond that. Where a day view holds two rows that are the
same row, both are told of. That is inherited rather than chosen here: two rows are the same row
only when their commitments are alike in name, in schedule, in the day they are kept from and in
kind, and the two rows agree about the day as well — whether it is kept, and the number it holds.
Giving a row an identity of its own would change what a row is throughout this capability.

Telling it MUST NOT change what a day screen says about **keeping a record**. A refused change is
one change refused; whether a screen is keeping a record is about whether the store opened at its
place, and it is formed again only when the app is shown. A screen that opened its record goes on
saying it is keeping one however many changes it refuses, so that the screen never guesses which
condition a failed write proves.

What the day view holds is unaffected, which is the requirement on making and taking back a tick
and the one on entering a number, and is not restated here.

#### Scenario: a refused tick is told on the row that was tapped

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
- **THEN** ticking is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept

#### Scenario: a refused tick is told on the row that was tapped and on no other row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, a commitment named "Journaling" on a schedule listing
  all seven weekdays and a commitment named "Supplements and habits" on that same schedule, in
  that order and all kept from 1 January 2026, and the second of its three rows is ticked
- **THEN** the day screen tells, on the second row, that the change could not be kept
- **AND** it tells nothing on the first row and nothing on the third

#### Scenario: a refused take-back is told on the row that was tapped

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from
  but not written to and that holds a record in which a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, is already kept on that date,
  and its one row — which says the commitment is kept — is ticked
- **THEN** taking the tick back is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** its day view still says the commitment is kept on that date

#### Scenario: a second refused tap is told on the row tapped last and no longer on the first

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday and a commitment named "Journaling" on a schedule listing
  all seven weekdays, in that order and both kept from 1 January 2026; its first row is ticked;
  and its second row is then ticked
- **THEN** both taps are refused with an error
- **AND** the day screen tells, on the second row, that the change could not be kept
- **AND** it tells nothing on the first row

#### Scenario: a refused change does not change what a day screen says about keeping a record

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
  twice
- **THEN** the day screen says it is keeping a record
- **AND** it tells, on that row, that the change could not be kept

#### Scenario: a number outside the commitment's range is told on the row, naming the bounds it broke

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 and a
  commitment named "Mood" of the number kind with a range of 1 to 10, both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026, and "300" is committed on the
  first row
- **THEN** the day screen tells, on that row, that the number must be between 40 and 150
- **AND** it tells nothing on the second row
- **AND** committing "0.5" on the second row of the screen it then holds tells, on that row, that
  the number must be between 1 and 10

#### Scenario: a value that is not a number is told on the row, saying so

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "1.2.3" is committed on
  its one row
- **THEN** the day screen tells, on that row, that it is not a number
- **AND** a day screen alike in every way but of a commitment with no range tells the same thing
  on its own row for the same value

#### Scenario: a number refused by the place is told on the row and names no cause

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Weight" of the
  number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, and "70.5" is committed on its one row
- **THEN** committing is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** what it tells names no cause
- **AND** committing nothing at all on that row tells the same thing on it and names no cause
  either

#### Scenario: a second refused commit is told on the row committed on last and no longer on the first

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 and a
  commitment named "Mood" of the number kind with a range of 1 to 10, in that order and both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026; "300" is
  committed on the first row; and "1.2.3" is then committed on the second row of the screen it
  then holds
- **THEN** the day screen tells, on the second row, that it is not a number
- **AND** it tells nothing on the first row

#### Scenario: a note refused by the place is told on the row and names no cause

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journal" of the note
  kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and
  "Ran 8k." is committed on its one row
- **THEN** committing is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** what it tells names no cause
- **AND** committing nothing at all on that row tells the same thing on it and names no cause
  either
- **AND** committing a note of a hundred thousand characters on that row tells the same thing on it
  and names no cause either

#### Scenario: an amount that is not above zero is told on the row, saying so

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120 and a commitment
  named "Water" of the total kind with a target of 2, both on a schedule listing Monday, Wednesday
  and Saturday and both kept from 1 January 2026, and "0" is committed on the first row
- **THEN** the day screen tells, on that row, that it must be more than 0
- **AND** it tells nothing on the second row
- **AND** committing "-1" on the second row of the screen it then holds tells, on that row, that it
  must be more than 0, and tells nothing on the first

#### Scenario: an amount too large to add to the day is told on the row, saying so

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; a whole number of thirty-eight
  nines is committed on its one row; and "0.5" is then committed on the row it then holds
- **THEN** the day screen tells, on that row, that it is too large to add
- **AND** what it tells is not "Not a number" and not "Must be more than 0"

#### Scenario: a value that is not a number committed in a total entry is told the same thing a number entry tells

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 and a commitment
  named "Protein" of the total kind with a target of 120, in that order and both on a schedule
  listing Monday, Wednesday and Saturday and both kept from 1 January 2026, and "1.2.3" is committed
  on the first row and then on the second row of the screen it then holds
- **THEN** the day screen tells, on the second row, that it is not a number
- **AND** what it tells there is word for word what it told on the first row

#### Scenario: an addition refused by the place is told on the row and names no cause

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Protein" of the total
  kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and "30" is committed on its one row
- **THEN** committing is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** what it tells names no cause

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

### Requirement: A day screen tells nothing on a row where there was no tick to refuse

A tap or a commit that never reaches the record's place is not a refused change. A day screen
SHALL tell nothing on the row for one, and SHALL NOT end what it is already telling on another
row: there is no refusal to report and nothing has been proved about the place either way.

**The four causes the requirement above names are the exception, and they are the whole of it.** A
value that is not a number, a number the commitment refuses, an amount that is not above zero and an
amount too large to add to its day all reach no place either, and every one of them is told, because
what a person is told there is not that the place refused them — it is what to give instead. Where
the value was never read at all, this requirement governs, and the four cases below are all of
them.

A tap or a commit on a day screen that is **not keeping a record** SHALL be the first, whatever
the reason the store would not open, and whatever was committed — a value that commitment would
refuse included, because such a screen never gets as far as reading what was committed and would
be naming a cause about a value it never read. It already says it is keeping no record, and that
says more than a per-row message would and is what a person can act on; the two would share the
same end — being shown again — and would clear together, so the row would only ever repeat it.

A tap or a commit on a row **for a day that has not arrived** SHALL be the second. Such a row offers
no tick, no number entry, no note entry, no total entry and no take-back, asked as of the today the
screen was handed, so there is no change to refuse and nothing was asked of the place. What is told
on a row means a change did not reach the place, and here there was no change. The honest answer to
a day that has not arrived is a row that does not invite the tap at all, and that is not this
capability's answer here — for the fourth and last kind of row now, and the price is paid a fourth
time rather than half-fixed.

A tap or a commit on a **row the day screen's day view does not hold** SHALL be the third. Such a
row already changes nothing at all, and telling something about it would be a change.

A commit on a **row that offers no entry at all for any other reason** SHALL be the fourth, and it
is now a **tick row alone**: such a row was never asked for anything to be committed and has nothing
to refuse. What is committed on one keeps nothing and says nothing, exactly as a tick made on a
number row, a note row or a total row does — a row answers for the kind its commitment declares and
stays silent about every other. **A take-back asked of a row that offers none** SHALL be told nothing
by the same rule and for the same reason, whichever of the three things makes the row offer none.

**A total row is no longer among them**, and that is what this change moves here — as #140 moved the
note row before it, and there is no fifth kind left to move. A total row offers a total entry, so a
commit on one is read, kept and answered for exactly as a commit on a number row is, and it names one
of three causes where a number row names one of two.

A commit in a total entry that **says nothing** SHALL likewise be told nothing on the row, and SHALL
NOT end what is already told on another. It is read rather than never read, so it is not one of the
four cases above; but it asks for no change, refuses nothing, and reaches no place, so there is
nothing to report about it in either direction. What it does to the day is the requirement on reading
what is committed in a total entry, and it is not restated here.

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

#### Scenario: a tap on a row a day screen's day view does not hold is told nothing on the row

- **WHEN** two day screens of a commitment named "Journaling" on a schedule listing all seven
  weekdays, kept from 1 January 2026, are opened at one place where nothing can be written — a
  path beneath an existing ordinary file — the first as of Monday 31 August 2026 and the second as
  of Wednesday 2 September 2026, and the second screen's row is ticked on the first screen
- **THEN** the first day screen tells nothing on any row

#### Scenario: a tap on a row a day screen's day view does not hold does not end what is already told

- **WHEN** two day screens of a commitment named "Journaling" on a schedule listing all seven
  weekdays, kept from 1 January 2026, are opened at one place where nothing can be written — a
  path beneath an existing ordinary file — the first as of Monday 31 August 2026 and the second as
  of Wednesday 2 September 2026; the first screen's own row is ticked; and the second screen's row
  is then ticked on the first screen
- **THEN** the first day screen still tells, on its own row, that the change could not be kept

#### Scenario: a commit on a day screen that is not keeping a record is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Weight" of the number kind with
  a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, and "70.5" is committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** it says it is not keeping a record
- **AND** committing "300" and then "1.2.3" on that row tells nothing on any row either

#### Scenario: a commit on a row for a day that has not arrived is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026; it is moved to the day after; and "300" is
  committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on Tuesday 1 September 2026

#### Scenario: a commit on a row that offers no number entry is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and "1.2.3" is committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on that date

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

#### Scenario: a commit on a note row on a day screen that is not keeping a record is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Journal" of the note kind, on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "Ran 8k." is
  committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** it says it is not keeping a record
- **AND** committing nothing at all on that row tells nothing on any row either

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

### Requirement: A row offers the number entry its commitment takes, and offers none for a day that has not arrived

A row SHALL offer, when asked as of a calendar date, either exactly one number entry or nothing at
all. The entry it offers SHALL be the entry for that row's commitment on the date the day view
holding it is of, and nothing else: the row is a commitment on a date and a number is of a
commitment on a date, so there is nothing left for a caller to supply and nothing for the row to
choose.

The row SHALL offer nothing when its commitment's kind is not a number, and SHALL offer nothing when
the day view's date is later than the day it is asked as of. Where neither holds it SHALL offer the
entry. A row asked as of its own date SHALL offer it — a day that has arrived can have been kept,
and only one that has not is refused — and so SHALL a row whose date is earlier, however much
earlier: the past is writable back to the day the commitment is kept from, and a commitment that is
not due there has no row to ask.

The second refusal is the tick's own, word for word and for the same reason: a record is what a
person did about a day, and a day that has not happened has nothing yet to say about it. Its price
is the same too — such a row invites a tap it will not answer — and that price is deliberately paid
again here rather than fixed, so that one answer covers every kind of row and whoever fixes it fixes
it once.

A row SHALL offer at most one of a tick, a number entry, a note entry and a total entry, and never
two of them. A commitment's kind says what its days take and it says one thing: a row whose
commitment's kind is a tick offers the tick alone, one whose kind is a number offers the number entry
alone, one whose kind is a note offers the note entry alone, and one whose kind is a total offers the
total entry alone — there is no longer a kind whose row offers nothing. Which of them it offers is
therefore the only thing a row says about its kind — a row of any kind says its name, the rhythm it
runs on and whether the day was kept in exactly the same way.

Whether a row offers an entry SHALL NOT depend on what the history says. A row already saying its
commitment is kept offers one exactly as a row saying it is not, because a number entered can be
entered again and a number entered on the wrong day has to be reachable to be taken back. What the
entry it offers *carries* does depend on the history, and that is the next requirement's.

The day the row is asked as of SHALL be given to it, and this capability MUST NOT read it from a
clock, MUST NOT consult the present moment, the device's time zone or the locale, and MUST NOT keep
it. A row therefore answers the same way for ever when asked as of the same day.

#### Scenario: a row offers the number entry for its commitment on the date the day view is of

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of
  Monday 31 August 2026
- **THEN** the day view holds one row named "Weight"
- **AND** that row offers a number entry

#### Scenario: a row for a commitment whose kind is not a number offers no number entry

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Gym" of the tick kind, one named "Journal" of the note kind and one named
  "Water" of the total kind with a target of 120, all three on a schedule listing Monday,
  Wednesday and Saturday and all kept from 1 January 2026, and each of its rows is asked as of
  Monday 31 August 2026
- **THEN** the day view holds three rows, named "Gym", "Journal" and "Water"
- **AND** none of them offers a number entry
- **AND** a row for a commitment alike in every way but of the number kind with no range, asked as
  of that same day, offers one

#### Scenario: a row offers a tick or a number entry and never both

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Gym" of the tick kind and a commitment named "Weight" of the number kind
  with a range of 40 to 150, both on a schedule listing Monday, Wednesday and Saturday and both
  kept from 1 January 2026, and both its rows are asked as of Monday 31 August 2026
- **THEN** the row named "Gym" offers a tick and no number entry
- **AND** the row named "Weight" offers a number entry and no tick
- **AND** a row for a commitment alike in every way but of the note kind, asked as of that same
  day, offers neither of them
- **AND** a row for one alike in every way but of the total kind with a target of 120 offers neither
  of them either

#### Scenario: a row for a date later than the day it is asked as of offers no number entry

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  record, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is
  asked as of Monday 31 August 2026
- **THEN** the day view holds one row named "Weight"
- **AND** that row offers no number entry
- **AND** it offers no tick either

#### Scenario: a row for a date later than the day it is asked as of offers no number entry even where the day holds a number

- **WHEN** a day view is formed on Wednesday 2 September 2026, of a commitment named "Weight" of
  the number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, from a history holding a number of 70.5 for that commitment on that
  date, and its one row is asked as of Monday 31 August 2026
- **THEN** that row says the commitment is kept
- **AND** it offers no number entry

#### Scenario: a row for a date earlier than the day it is asked as of offers the number entry

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of
  Saturday 5 September 2026
- **THEN** the row offers a number entry

#### Scenario: a row offers the number entry whether or not the day is already kept

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Weight"
  of the number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, the first from a history that has taken no record and the
  second from a history holding a number of 70.5 for that commitment on that date, and each one's
  row is asked as of that same day
- **THEN** the first row says the commitment is not kept and the second says it is
- **AND** both offer a number entry

### Requirement: A number entry says the range its commitment takes and the number the day already holds

A number entry SHALL say two things and no others: the number the history the day view was formed
from holds for that commitment on that date, or **no number** where it holds none; and the range the
commitment declares, said as a hint, or **no hint** where it declares none.

The hint SHALL be the lowest the commitment declares, an en dash, and the highest, and nothing else
— "40–150" for a weight of 40 to 150, "1–10" for a mood of one to ten. It is this package's own
words and no locale's, as a day title and a rhythm in words are, and each bound SHALL be said as it
was given, with no digit added and none dropped: a range of 40.5 to 150 says "40.5–150". A
commitment that declares no range SHALL say no hint, because there is no bound to say and an
invented one would be a rule the commitment does not carry. A range hint exists so that a person
learns what a commitment takes before it refuses them; a range that is only ever a refusal teaches
by refusing, which is the one way this product will not teach.

The number SHALL be the one the `record` capability answers for that commitment on that date, asked
of the history the day view was formed from, and MUST NOT be recomputed here — exactly as whether
the day is kept is. An entry offered again from a history the number has been taken back from SHALL
say no number.

A row SHALL NOT say the number itself. What a row gives back is its name, the rhythm its commitment
runs on in words, whether that commitment is kept, and what it offers; the number is reachable only
through the entry. So a row for a day holding 70.5 and a row for a day holding 71 say exactly what a
ticked row says — that the day was kept — and a number is read where a number is worth reading,
which is not the daily list of what a day asks of you.

#### Scenario: a number entry says the range its commitment declares as a hint

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Weight" of the number kind with a range of 40 to 150 and a commitment
  named "Mood" of the number kind with a range of 1 to 10, both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, and both its rows are asked as of that
  same day
- **THEN** the entry the first row offers says the hint "40–150"
- **AND** the entry the second row offers says the hint "1–10"
- **AND** the entry of a row for a commitment alike in every way but with a range of 40.5 to
  150.25 says the hint "40.5–150.25"

#### Scenario: a number entry of a commitment that declares no range says no hint

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Weight" of the number kind with no range, on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of that same day
- **THEN** the entry that row offers says no hint

#### Scenario: a number entry says the number the history holds for that commitment on that date

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Weight" of the
  number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, from a history holding a number of 70.5 for that commitment on that
  date, and its one row is asked as of that same day
- **THEN** the entry that row offers says the number 70.5
- **AND** it says 70.5 exactly, not 70 and not 71

#### Scenario: a number entry says no number where the day holds none

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Weight"
  of the number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, the first from a history that has taken no record and the
  second from a history a number of 70.5 for that commitment on that date was added to and then
  taken back from, and each one's row is asked as of that same day
- **THEN** the entry the first row offers says no number
- **AND** the entry the second row offers says no number

#### Scenario: a row for a number commitment holding a number says its name, its rhythm and that the day is kept

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Weight" of the
  number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, from a history holding a number of 70.5 for that commitment on that
  date
- **THEN** the day view holds one row named "Weight"
- **AND** that row says "Mon, Wed, Sat"
- **AND** it says the commitment is kept
- **AND** a row of a day view formed the same way but from a history holding a number of 71
  instead says all three of those things identically

### Requirement: A day screen enters the number a row's entry takes, and keeps it before the day view says so

A day screen SHALL enter, on one of its rows, the number a person commits in that row's number
entry, and SHALL take the number on that day back where what is committed is empty. Which of the two
a commit means SHALL be read off what was committed and MUST NOT be given to the screen: something
holding a number enters it, something holding nothing takes the number back, and there is nothing
else a commit can mean. What holds a number and what holds nothing is the next requirement's.

The entry SHALL be the one the row itself offers, asked as of the today the screen was handed and
never as of the day it is showing. A day screen moved onto a day that has not arrived therefore
enters nothing on it: the row it holds is for a date later than that today, and such a row offers no
entry. The screen MUST NOT form a number of its own, MUST NOT choose which day a commit is for, and
MUST NOT reach past a row to the commitment underneath it.

A commit SHALL change nothing at all — nothing kept, nothing shown, nothing told — in each of three
cases, and each is the tick's own answer to the same condition. A row the screen's day view does not
hold changes nothing: a row is a commitment's line on a date, so a row from a day this screen is no
longer on ticks nothing here and enters nothing here either. A row that offers no number entry
changes nothing, whether because its commitment's kind is not a number or because its date has not
arrived. And a screen that is not keeping a record changes nothing, whatever the reason its store
would not open — a screen that took a weight it could not keep would be exactly the lost record this
product exists to prevent.

A number the commitment refuses SHALL keep nothing and SHALL leave the day exactly as it was. Which
numbers a commitment refuses is the `record` capability's answer and this capability adds nothing to
it and takes nothing away: a row offers an entry only where its commitment's kind is a number, and a
row exists only on a date its commitment is due on, so the range the commitment declares is the only
refusal a number formed here can meet. What a person is told about it is the requirement on what a
day screen tells on a row.

The change SHALL be kept at the screen's record place before its day view says so, and the day view
SHALL then be formed again, on the day the screen is showing, from the record as it stands and from
the commitments its roster had not stopped keeping on that day, rather than the day view it held
being altered. A change that could not be kept SHALL be refused, SHALL be reported to the caller
rather than passed over, and SHALL leave the day view exactly as it was. The day view a person reads
MUST NOT be ahead of what is kept at the place, and a number that could not be kept MUST NOT be held
anywhere in its place. A number entered on a day that already holds one replaces it, which is the
`record` capability's answer and not a second rule here.

Taking the number back SHALL reach the place whether or not the day holds a number, and SHALL be
refused only where the place would not take it. The outcome asked for on a day holding none already
holds, so nothing about the record changes; what does happen is that the place was written, which is
the proof a person is owed that the place would take a change.

A number SHALL reach the record's place and nothing else. Entering one or taking one back MUST NOT
write to the roster's place, and MUST NOT change what the screen says about its roster: the two are
kept independently, and a number is not a change to what a person keeps.

#### Scenario: entering a number on a row makes the day screen say the commitment is kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "70.5" is committed on its
  one row
- **THEN** the day screen's day view says the commitment is kept on that date

#### Scenario: a number entered on a day screen is held by a day screen opened afterwards at the same place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one
  row; and a second day screen of the same commitment is then opened at the same place as of the
  same day
- **THEN** the second day screen's day view says the commitment is kept on that date
- **AND** the entry its one row offers says the number 70.5

#### Scenario: the number entry a row offers says the number just entered on it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "70.5" is committed on its
  one row
- **THEN** the entry the row the day screen then holds offers says the number 70.5

#### Scenario: a number entered on a day that already holds one replaces it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one
  row; and "71.2" is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers says the number 71.2
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: committing an empty entry takes the number back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one
  row; and nothing at all is then committed on the row it then holds
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** the entry its row offers says no number
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: committing an empty entry on a day that holds no number leaves the day as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and nothing at all is
  committed on its one row
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a number the commitment refuses keeps nothing and leaves the day as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one
  row; and "300" is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers says the number 70.5
- **AND** the day view says the commitment is kept on that date
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a number that cannot be kept is refused and leaves the day view as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Weight" of the
  number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, and "70.5" is committed on its one row
- **THEN** committing is refused with an error
- **AND** the day screen's day view still says the commitment is not kept on that date
- **AND** a day screen opened afterwards at the same place says the same

#### Scenario: entering a number on a row the day screen's day view does not hold changes nothing

- **WHEN** two day screens of a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, are opened
  at one place where nothing has been kept, the first as of Monday 31 August 2026 and the second
  as of Wednesday 2 September 2026, and "70.5" is committed on the first screen in the second
  screen's row's number entry
- **THEN** the first day screen's day view still says the commitment is not kept on Monday 31
  August 2026
- **AND** a day screen opened afterwards at that place as of Wednesday 2 September 2026 says the
  commitment is not kept on that date either

#### Scenario: committing on a row that offers no number entry changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind and a commitment named "Weight" of the number
  kind with a range of 40 to 150, both on a schedule listing all seven weekdays and both kept from
  1 January 2026; "70.5" is committed on the row named "Gym"; the screen is then moved to the day
  after; and "70.5" is committed on the row it then holds named "Weight"
- **THEN** the day screen's day view says neither commitment is kept on Tuesday 1 September 2026
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says neither is
  kept on that date

#### Scenario: entering a number on a day screen that is not keeping a record changes nothing and keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Weight" of the number kind with
  a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, and "70.5" is committed on its one row
- **THEN** its day view still says the commitment is not kept on that date
- **AND** it still says it is not keeping a record
- **AND** the content at that place is byte-for-byte what it was before the screen was opened

#### Scenario: entering a number on one row leaves the other rows of the day as they were

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind, a commitment named "Weight" of the number
  kind with a range of 40 to 150 and a commitment named "Mood" of the number kind with a range of
  1 to 10, in that order, all three on a schedule listing all seven weekdays and all kept from 1
  January 2026, and "70.5" is committed on the second row
- **THEN** the day screen's day view holds three rows in that same order
- **AND** only the second says its commitment is kept

#### Scenario: entering a number on a day a day screen has moved back to keeps it on that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026; it is moved to the day before; and "70.5"
  is committed on its one row
- **THEN** its day view says the commitment is kept on Sunday 30 August 2026
- **AND** a day screen opened afterwards at that place as of Sunday 30 August 2026 says the
  commitment is kept on that date
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says the
  commitment is not kept on that date

#### Scenario: entering a number writes nothing to the roster's place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place and a roster
  place where nothing has been kept, of a commitment named "Weight" of the number kind with a
  range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026; the roster place is read once the screen has been opened; and "70.5" is then committed on
  its one row, and nothing at all committed on the row it then holds
- **THEN** the content at the roster place is byte-for-byte what it was after the screen was
  opened
- **AND** the day screen says it is keeping its roster

### Requirement: A day screen reads what an entry is committed with as a number, as a take-back, or as neither

A day screen SHALL read what is committed in a number entry as exactly one of three things: a
number, a take-back, or a value that is not a number. It SHALL read it itself, and MUST NOT consult
the device's locale, its region or its keyboard to do so — nothing in this system reads a locale,
and reading one here would make the same typing mean two things on two phones.

**Blank space** around what is committed SHALL be disregarded before it is read, and **blank space
SHALL mean whatever the `record` capability means by it**. This capability SHALL NOT decide it a
second time, and SHALL NOT decide it one way for a number entry and another for a note entry: one
question asked in one place is what keeps a number entry and a note entry from disagreeing about
which texts are a take-back. Blank space is therefore spaces, tabs and line breaks alike, and a
character that occupies no width is **not** blank space — a zero-width space is a character like any
other here, is not disregarded, and what is committed still holds it once the blank space around it
is gone.

What holds nothing once blank space is disregarded — the empty text among them — SHALL be a
**take-back**. Nothing else SHALL be one. A value that is not a number MUST NOT be read as a
take-back, because an entry a person had half typed would then erase the day they were entering it
on; and a text of characters a person cannot see MUST NOT be read as one, for that reason and more
sharply, because nothing on the row would tell them the day had been cleared and nothing they can
see would tell them why.

What is committed SHALL be a **number** when, once blank space around it is disregarded, it holds in
this order and holds nothing else: an optional minus sign, then digits and at most one decimal
separator, with at least one digit among them. The separator SHALL be a full stop or a comma, and
both SHALL be read the same way, because an iPhone's decimal keypad prints whichever the region it is
set to says and a field that refuses the key on its own keyboard is broken. The number it holds SHALL
be the number those digits say, exactly, with no digit added and none dropped.

A day screen SHALL therefore keep only a number it can keep **exactly**, and text saying one it
cannot SHALL be a value that is not a number here. Up to **thirty-eight significant digits** SHALL
be kept — counted from the first digit that is not a zero to the last that is not a zero — at every
magnitude this system holds. Text saying more digits than that, or a number too large or too near
zero for this system to hold at all, MUST NOT be rounded, shortened or otherwise fitted to what can
be held: a number nobody typed, kept under a person's name and never mentioned, is exactly the false
record this product exists to remove, and it is worse than a refusal because nothing tells them it
happened. Nor SHALL such text be read as a take-back, for the reason no value that is not a number
is one. The bound is this system's own rather than a rule about weights — no number a commitment in
this product asks a person for comes near it, and what reaches it is a paste.

Everything else SHALL be a value that is not a number: two separators, a separator with no digit
beside it, a sign anywhere but the front, an exponent, letters or spaces among the digits, a
character of no width anywhere in it, a digit that is not one of the ten this package reads, and
digits saying a number that cannot be kept exactly. Such a value SHALL keep nothing and SHALL take
nothing back, and the day SHALL be left exactly as it was.

#### Scenario: a number typed with a full stop is entered exactly as it was typed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and "70.5" is committed on its one row
- **THEN** the entry the row the day screen then holds offers says the number 70.5
- **AND** committing "0.000001" and then "98765432109876543210.5" on that row leaves it saying
  each of those numbers in turn, digit for digit

#### Scenario: a number typed with a comma is entered as the same number as one typed with a full stop

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "70,5" is committed on its
  one row
- **THEN** the entry the row the day screen then holds offers says the number 70.5

#### Scenario: a number typed with leading zeros or a trailing separator is entered as the number it says

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and "0000070.50" is committed on its
  one row
- **THEN** the entry the row the day screen then holds offers says the number 70.5
- **AND** committing "70." on that row leaves it saying the number 70
- **AND** committing " 70.5 " on that row leaves it saying the number 70.5

#### Scenario: a negative number is entered where the commitment declares no range

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Balance" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and "-12.75" is committed on its one
  row
- **THEN** the entry the row the day screen then holds offers says the number -12.75
- **AND** the day view says the commitment is kept on that date

#### Scenario: an entry committed empty takes the number back, and one holding nothing but space does the same

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 and a
  commitment named "Mood" of the number kind with a range of 1 to 10, both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026; "70.5" is committed on the
  first row and "8" on the second; and then nothing at all is committed on the first row and two
  spaces on the second
- **THEN** the day screen's day view says neither commitment is kept on that date
- **AND** the entry each of its rows offers says no number

#### Scenario: an entry committed with line breaks alone takes the number back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one
  row; and a text of three line breaks is then committed on the row it then holds
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** the entry its row offers says no number
- **AND** the day screen tells nothing on any row
- **AND** committing "70.5" again and then a text of one tab followed by one line break leaves it
  saying no number too
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: an entry committed with a zero-width space alone keeps nothing and takes nothing back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one
  row; and a text of one zero-width space is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers says the number 70.5
- **AND** the day view says the commitment is kept on that date
- **AND** the day screen tells, on that row, that it is not a number
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a value that is not a number keeps nothing and takes nothing back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one row;
  and each of "1.2.3", ".", "-", "12abc", "1e3", "7-0" and "٧٠" is then committed in turn on the
  row it then holds
- **THEN** the entry the row the day screen then holds offers says the number 70.5 after every one
  of them
- **AND** the day view says the commitment is kept on that date
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a number of as many digits as can be kept is entered exactly

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and a whole number of thirty-eight
  nines is committed on its one row
- **THEN** the entry the row the day screen then holds offers says that number, digit for digit
- **AND** the day view says the commitment is kept on that date
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a number too long to be kept exactly keeps nothing and takes nothing back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one row; and
  a whole number of thirty-nine nines, a whole number of two hundred ones, and a number whose only
  digit that is not a zero is at the hundred-and-twenty-ninth place after the point are each then
  committed in turn on the row it then holds
- **THEN** the entry the row the day screen then holds offers says the number 70.5 after every one
  of them
- **AND** the day screen tells, on that row, that it is not a number
- **AND** the day view says the commitment is kept on that date
- **AND** a day screen opened afterwards at the same place as of the same day says the same

### Requirement: A row offers the note entry its commitment takes, and offers none for a day that has not arrived

A row SHALL offer, when asked as of a calendar date, either exactly one note entry or nothing at all.
The entry it offers SHALL be the entry for that row's commitment on the date the day view holding it
is of, and nothing else: the row is a commitment on a date and a note is of a commitment on a date,
so there is nothing left for a caller to supply and nothing for the row to choose.

The row SHALL offer nothing when its commitment's kind is not a note, and SHALL offer nothing when
the day view's date is later than the day it is asked as of. Where neither holds it SHALL offer the
entry. A row asked as of its own date SHALL offer it — a day that has arrived can have been kept,
and only one that has not is refused — and so SHALL a row whose date is earlier, however much
earlier: the past is writable back to the day the commitment is kept from, and a commitment that is
not due there has no row to ask.

The second refusal is the tick's own and the number entry's own, word for word and for the same
reason: a record is what a person did about a day, and a day that has not happened has nothing yet to
say about it. Its price is the same too — such a row invites a tap it will not answer — and that
price is deliberately paid a third time here rather than fixed, so that one answer covers all three
kinds of row and whoever fixes it fixes it once.

A row SHALL offer at most one of a tick, a number entry, a note entry and a total entry, and never
two of them. A commitment's kind says what its days take and it says one thing: a row whose
commitment's kind is a tick offers the tick alone, one whose kind is a number offers the number entry
alone, one whose kind is a note offers the note entry alone, and one whose kind is a total offers the
total entry alone — there is no longer a kind whose row offers nothing. Which of them it offers is
therefore the only thing a row says about its kind — a row of any kind says its name, the rhythm it
runs on and whether the day was kept in exactly the same way.

Whether a row offers an entry SHALL NOT depend on what the history says. A row already saying its
commitment is kept offers one exactly as a row saying it is not, because a note written can be
written again and a note written on the wrong day has to be reachable to be taken back. What the
entry it offers *carries* does depend on the history, and that is the next requirement's.

The day the row is asked as of SHALL be given to it, and this capability MUST NOT read it from a
clock, MUST NOT consult the present moment, the device's time zone or the locale, and MUST NOT keep
it. A row therefore answers the same way for ever when asked as of the same day.

#### Scenario: a row offers the note entry for its commitment on the date the day view is of

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and its one row is asked as of Monday 31 August 2026
- **THEN** the day view holds one row named "Journal"
- **AND** that row offers a note entry

#### Scenario: a row for a commitment whose kind is not a note offers no note entry

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Gym" of the tick kind, one named "Weight" of the number kind with a range
  of 40 to 150 and one named "Water" of the total kind with a target of 120, all three on a schedule
  listing Monday, Wednesday and Saturday and all kept from 1 January 2026, and each of its rows is
  asked as of Monday 31 August 2026
- **THEN** the day view holds three rows, named "Gym", "Weight" and "Water"
- **AND** none of them offers a note entry
- **AND** a row for a commitment alike in every way but of the note kind, asked as of that same day,
  offers one

#### Scenario: a row offers a tick, a number entry or a note entry and never two of them

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Gym" of the tick kind, a commitment named "Weight" of the number kind with
  a range of 40 to 150 and a commitment named "Journal" of the note kind, all on a schedule listing
  Monday, Wednesday and Saturday and all kept from 1 January 2026, and all three of its rows are
  asked as of Monday 31 August 2026
- **THEN** the row named "Gym" offers a tick and neither a number entry nor a note entry
- **AND** the row named "Weight" offers a number entry and neither a tick nor a note entry
- **AND** the row named "Journal" offers a note entry and neither a tick nor a number entry
- **AND** a row for a commitment alike in every way but of the total kind with a target of 120,
  asked as of that same day, offers none of those three

#### Scenario: a row for a date later than the day it is asked as of offers no note entry

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  record, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, and its one row is asked as of Monday 31 August 2026
- **THEN** the day view holds one row named "Journal"
- **AND** that row offers no note entry
- **AND** it offers neither a tick nor a number entry either

#### Scenario: a row for a date later than the day it is asked as of offers no note entry even where the day holds a note

- **WHEN** a day view is formed on Wednesday 2 September 2026, of a commitment named "Journal" of
  the note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026,
  from a history holding a note of "Ran 8k." for that commitment on that date, and its one row is
  asked as of Monday 31 August 2026
- **THEN** that row says the commitment is kept
- **AND** it offers no note entry

#### Scenario: a row for a date earlier than the day it is asked as of offers the note entry

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and its one row is asked as of Saturday 5 September 2026
- **THEN** the row offers a note entry

#### Scenario: a row offers the note entry whether or not the day is already kept

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Journal"
  of the note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026,
  the first from a history that has taken no record and the second from a history holding a note of
  "Ran 8k." for that commitment on that date, and each one's row is asked as of that same day
- **THEN** the first row says the commitment is not kept and the second says it is
- **AND** both offer a note entry

### Requirement: A note entry says the note the day already holds, and says nothing else

A note entry SHALL say exactly one thing: the note the history the day view was formed from holds
for that commitment on that date, or **no note** where it holds none.

It says one thing where a number entry says two, and that is the kind's own difference rather than
an omission. A number commitment may declare a **range**, so a number entry has a bound to teach
before it refuses anyone; a note commitment declares nothing at all — every text that says something
is a note — so there is nothing a note entry could teach and nothing it will refuse a person for.
An invented hint would be a rule the commitment does not carry, and a placeholder telling a person
how to write is this product deciding what their own words should look like.

The note SHALL be the one the `record` capability answers for that commitment on that date, asked of
the history the day view was formed from, and MUST NOT be recomposed, shortened or otherwise altered
here — exactly as whether the day is kept is, and exactly as the number is. It SHALL be the whole of
what was written, however long and however many lines: a note entry opened on a day already written
on shows a person what they wrote, because it is the one place a note can be read at all and a
person who cannot read it back cannot correct it. An entry offered again from a history the note has
been taken back from SHALL say no note.

A row SHALL NOT say the note itself. What a row gives back is its name, the rhythm its commitment
runs on in words, whether that commitment is kept, and what it offers; the note is reachable only
through the entry. So a row for a day holding "Ran 8k." and a row for a day holding "Rested." say
exactly what a ticked row says — that the day was kept — and what a person wrote is read where it is
worth reading, which is not the daily list of what a day asks of you.

#### Scenario: a note entry says the note the history holds for that commitment on that date

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Journal" of the
  note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, from a
  history holding a note of "Ran 8k before work. Knee held up." for that commitment on that date,
  and its one row is asked as of that same day
- **THEN** the entry that row offers says that note
- **AND** it says it character for character, whole

#### Scenario: a note entry says a note of many lines and many characters whole

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Journal" of the
  note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, from a
  history holding a note of three lines separated by line breaks for that commitment on that date,
  and its one row is asked as of that same day
- **THEN** the entry that row offers says all three lines, with the line breaks between them
- **AND** an entry formed the same way from a history holding a note of a hundred thousand
  characters says that note whole

#### Scenario: a note entry says no note where the day holds none

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Journal"
  of the note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026,
  the first from a history that has taken no record and the second from a history a note of
  "Ran 8k." for that commitment on that date was added to and then taken back from, and each one's
  row is asked as of that same day
- **THEN** the entry the first row offers says no note
- **AND** the entry the second row offers says no note

#### Scenario: a row for a note commitment holding a note says its name, its rhythm and that the day is kept

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Journal" of the
  note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, from a
  history holding a note of "Ran 8k." for that commitment on that date
- **THEN** the day view holds one row named "Journal"
- **AND** that row says "Mon, Wed, Sat"
- **AND** it says the commitment is kept
- **AND** a row of a day view formed the same way but from a history holding a note of "Rested."
  instead says all three of those things identically

### Requirement: A day screen enters the note a row's entry takes, and keeps it before the day view says so

A day screen SHALL enter, on one of its rows, the note a person commits in that row's note entry,
and SHALL take the note on that day back where what is committed says nothing. Which of the two a
commit means SHALL be read off what was committed and MUST NOT be given to the screen: something
saying something writes it, something saying nothing takes the note back, and there is nothing else
a commit can mean. What says something and what says nothing is the next requirement's.

**Which entry a commit lands in SHALL be decided by the row it was made on, and by nothing about the
text itself.** A commit on a row offering a number entry is read as a number, a commit on a row
offering a note entry is read as a note, and a commit on a row offering neither changes nothing at
all — so "70.5" committed on a note row is the note "70.5" and not a number, and a caller cannot
commit into an entry the row does not offer however the text is shaped. The row already says which
kind its commitment declares; a second answer, from the text or from the caller, could only ever
disagree with it, and the disagreement would be answered by silence, which is the one refusal a
person can neither see nor act on.

The entry SHALL be the one the row itself offers, asked as of the today the screen was handed and
never as of the day it is showing. A day screen moved onto a day that has not arrived therefore
writes nothing on it: the row it holds is for a date later than that today, and such a row offers no
entry. The screen MUST NOT form a note of its own, MUST NOT choose which day a commit is for, and
MUST NOT reach past a row to the commitment underneath it.

A commit SHALL change nothing at all — nothing kept, nothing shown, nothing told — in each of three
cases, and each is the tick's own answer and the number's own answer to the same condition. A row
the screen's day view does not hold changes nothing: a row is a commitment's line on a date, so a
row from a day this screen is no longer on ticks nothing here and writes nothing here either. A row
that offers no note entry changes nothing, whether because its commitment's kind is not a note or
because its date has not arrived. And a screen that is not keeping a record changes nothing,
whatever the reason its store would not open — a screen that took a sentence it could not keep would
be exactly the lost record this product exists to prevent.

There is **no fourth case in which a note a person committed is refused**. A note commitment
declares no bound of any kind, and every text that says something is a note, so the only thing this
screen can refuse a committed note for is the place refusing to take it. A text that says nothing is
not a refusal at all: it is the take-back, which is a change a person asked for and got.

The change SHALL be kept at the screen's record place before its day view says so, and the day view
SHALL then be formed again, on the day the screen is showing, from the record as it stands and from
the commitments its roster had not stopped keeping on that day, rather than the day view it held
being altered. A change that could not be kept SHALL be refused, SHALL be reported to the caller
rather than passed over, and SHALL leave the day view exactly as it was. The day view a person reads
MUST NOT be ahead of what is kept at the place, and a note that could not be kept MUST NOT be held
anywhere in its place. A note written on a day that already holds one replaces it, which is the
`record` capability's answer and not a second rule here.

Taking the note back SHALL reach the place whether or not the day holds a note, and SHALL be refused
only where the place would not take it. The outcome asked for on a day holding none already holds,
so nothing about the record changes; what does happen is that the place was written, which is the
proof a person is owed that the place would take a change.

A note SHALL reach the record's place and nothing else. Writing one or taking one back MUST NOT
write to the roster's place, and MUST NOT change what the screen says about its roster: the two are
kept independently, and a note is not a change to what a person keeps.

#### Scenario: entering a note on a row makes the day screen say the commitment is kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, and "Ran 8k before work." is committed on its one row
- **THEN** the day screen's day view says the commitment is kept on that date

#### Scenario: a note entered on a day screen is held by a day screen opened afterwards at the same place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026; "Ran 8k before work." is committed on its one row; and a
  second day screen of the same commitment is then opened at the same place as of the same day
- **THEN** the second day screen's day view says the commitment is kept on that date
- **AND** the entry its one row offers says the note "Ran 8k before work."

#### Scenario: the note entry a row offers says the note just entered on it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, and a text of three lines separated by line breaks is
  committed on its one row
- **THEN** the entry the row the day screen then holds offers says that text, line breaks and all

#### Scenario: a note entered on a day that already holds one replaces it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026; "Ran 8k." is committed on its one row; and "Ran 8k. Knee
  held up." is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers says the note "Ran 8k. Knee held up."
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: committing an empty note entry takes the note back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026; "Ran 8k." is committed on its one row; and nothing at all
  is then committed on the row it then holds
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** the entry its row offers says no note
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: committing an empty note entry on a day that holds no note leaves the day as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, and nothing at all is committed on its one row
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a note that cannot be kept is refused and leaves the day view as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journal" of the note
  kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and
  "Ran 8k." is committed on its one row
- **THEN** committing is refused with an error
- **AND** the day screen's day view still says the commitment is not kept on that date
- **AND** a day screen opened afterwards at the same place says the same

#### Scenario: entering a note on a row the day screen's day view does not hold changes nothing

- **WHEN** two day screens of a commitment named "Journal" of the note kind, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, are opened at one place where nothing
  has been kept, the first as of Monday 31 August 2026 and the second as of Wednesday 2 September
  2026, and "Ran 8k." is committed on the first screen in the second screen's row's note entry
- **THEN** the first day screen's day view still says the commitment is not kept on Monday 31 August
  2026
- **AND** a day screen opened afterwards at that place as of Wednesday 2 September 2026 says the
  commitment is not kept on that date either

#### Scenario: committing on a row that offers no note entry changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind and a commitment named "Journal" of the note
  kind, both on a schedule listing all seven weekdays and both kept from 1 January 2026; "Ran 8k."
  is committed on the row named "Gym"; the screen is then moved to the day after; and "Ran 8k." is
  committed on the row it then holds named "Journal"
- **THEN** the day screen's day view says neither commitment is kept on Tuesday 1 September 2026
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says neither is
  kept on that date

#### Scenario: a commit is read as the entry the row it was made on offers

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 and a commitment
  named "Journal" of the note kind, in that order and both on a schedule listing Monday, Wednesday
  and Saturday and both kept from 1 January 2026; "70.5" is committed on the first row; and "70.5"
  is then committed on the second row of the screen it then holds
- **THEN** the entry the first row of the screen it then holds offers says the number 70.5
- **AND** the entry the second row offers says the note "70.5"
- **AND** the day view says both commitments are kept on that date

#### Scenario: entering a note on a day screen that is not keeping a record changes nothing and keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Journal" of the note kind, on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "Ran 8k." is
  committed on its one row
- **THEN** its day view still says the commitment is not kept on that date
- **AND** it still says it is not keeping a record
- **AND** the content at that place is byte-for-byte what it was before the screen was opened

#### Scenario: entering a note on one row leaves the other rows of the day as they were

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind, a commitment named "Journal" of the note kind
  and a commitment named "Weight" of the number kind with a range of 40 to 150, in that order, all
  three on a schedule listing all seven weekdays and all kept from 1 January 2026, and "Ran 8k." is
  committed on the second row
- **THEN** the day screen's day view holds three rows in that same order
- **AND** only the second says its commitment is kept

#### Scenario: entering a note on a day a day screen has moved back to keeps it on that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing all seven weekdays,
  kept from 1 January 2026; it is moved to the day before; and "Ran 8k." is committed on its one row
- **THEN** its day view says the commitment is kept on Sunday 30 August 2026
- **AND** a day screen opened afterwards at that place as of Sunday 30 August 2026 says the
  commitment is kept on that date
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says the
  commitment is not kept on that date

#### Scenario: entering a note writes nothing to the roster's place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place and a roster place
  where nothing has been kept, of a commitment named "Journal" of the note kind, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; the roster place is read once
  the screen has been opened; and "Ran 8k." is then committed on its one row, and nothing at all
  committed on the row it then holds
- **THEN** the content at the roster place is byte-for-byte what it was after the screen was opened
- **AND** the day screen says it is keeping its roster

### Requirement: A day screen reads what is committed in a note entry as a note or as a take-back

A day screen SHALL read what is committed in a note entry as exactly one of two things: a note, or a
take-back. There is no third answer, because a note commitment declares no bound and every text that
says something is a note — so unlike a number entry, which has a shape a text can fail, a note entry
has nothing a person can get wrong.

What is committed SHALL be a **take-back** when it says nothing: the empty text, and any text made
only of blank space. Everything else SHALL be a note.

**Blank space SHALL mean whatever the `record` capability means by it**, and this capability SHALL
NOT decide it a second time. A text this screen calls blank and `record` would accept as a note, or
the reverse, would be a commit that is neither written nor taken back, and a person would be left
looking at a day that did not answer them. Asking one question in one place is what makes that state
impossible rather than merely unlikely, and it is why blank space here is spaces, tabs and line
breaks alike, exactly as it is where a note is formed and where a commitment name is judged.

Blank space at the start and the end of what is committed SHALL be disregarded before the note is
formed, and everything between the first and the last character that is not blank space SHALL be
kept exactly as it was written — line breaks, tabs and runs of spaces among them. The trim is the
screen's rather than the record's because it is where a person typed: a keyboard leaves a trailing
space behind without being asked, and nobody means to keep one under their own name. What lies
between is theirs and is not touched, so a note deliberately written as three paragraphs is kept as
three paragraphs.

This reading SHALL NOT be the number entry's reading, and neither SHALL be applied to the other. A
number entry's reading is its own requirement and its answers are three rather than two, because a
number has a shape a text can fail and a note has none. What the two share is exactly one thing, and
they SHALL share it: what counts as blank space, asked of the `record` capability by both and decided
by neither. A number entry disregarding one blank space and a note entry another would be two answers
to one question living a few lines apart, which is the shape that produced the defect the number
entry's own requirement now closes.

#### Scenario: a note committed with space around it is kept without that space and unchanged within it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, and a text of two spaces, then "Ran 8k.", then a line
  break, then "Knee held up.", then a line break and two spaces, is committed on its one row
- **THEN** the entry the row the day screen then holds offers says "Ran 8k." then a line break then
  "Knee held up.", and nothing else
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a note committed with space inside it keeps every character of that space

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, and the text "Monday" followed by two line breaks, three
  spaces, a tab and "Tuesday" is committed on its one row
- **THEN** the entry the row the day screen then holds offers says exactly that text, character for
  character

#### Scenario: an entry committed empty takes the note back, and one holding nothing but blank space does the same

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind and a commitment named "Sleep" of the note
  kind, both on a schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026;
  "Ran 8k." is committed on the first row and "Slept badly." on the second; and then nothing at all
  is committed on the first row and two spaces on the second
- **THEN** the day screen's day view says neither commitment is kept on that date
- **AND** the entry each of its rows offers says no note

#### Scenario: an entry committed with line breaks alone takes the note back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026; "Ran 8k." is committed on its one row; and a text of three
  line breaks is then committed on the row it then holds
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** the entry its row offers says no note
- **AND** committing "Ran 8k." again and then a text of one tab followed by one line break leaves it
  saying no note too
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a note of one visible character among blank space is written rather than taken back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, and a text of a line break, two spaces, a full stop, a tab
  and a line break is committed on its one row
- **THEN** the day screen's day view says the commitment is kept on that date
- **AND** the entry its row offers says the note "."

#### Scenario: a note of any length, any script and any number of lines is entered whole

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, and each of a text of a hundred thousand characters, the
  text "שלום עולם", a text of one emoji and a text of twenty lines is committed in turn on the row
  the screen then holds
- **THEN** the entry the row offers says each of them in turn, character for character
- **AND** the day view says the commitment is kept on that date after every one of them
- **AND** a day screen opened afterwards at the same place as of the same day says the same

### Requirement: A row offers the total entry its commitment takes, and offers none for a day that has not arrived

A row SHALL offer, when asked as of a calendar date, either exactly one total entry or nothing at
all. The entry it offers SHALL be the entry for that row's commitment on the date the day view
holding it is of, and nothing else: the row is a commitment on a date and an addition is of a
commitment on a date, so there is nothing left for a caller to supply and nothing for the row to
choose.

The row SHALL offer nothing when its commitment's kind is not a total, and SHALL offer nothing when
the day view's date is later than the day it is asked as of. Where neither holds it SHALL offer the
entry. A row asked as of its own date SHALL offer it — a day that has arrived can have been kept,
and only one that has not is refused — and so SHALL a row whose date is earlier, however much
earlier: the past is writable back to the day the commitment is kept from, and a commitment that is
not due there has no row to ask.

The second refusal is the tick's own, the number entry's own and the note entry's own, word for word
and for the same reason: a record is what a person did about a day, and a day that has not happened
has nothing yet to say about it. Its price is the same too — such a row invites a tap it will not
answer — and that price is deliberately paid a fourth and last time here rather than fixed, so that
one answer covers every kind of row and whoever fixes it fixes it once.

A row SHALL offer at most one of a tick, a number entry, a note entry and a total entry, and never
two of them. A commitment's kind says what its days take and it says one thing: a row whose
commitment's kind is a tick offers the tick alone, one whose kind is a number offers the number entry
alone, one whose kind is a note offers the note entry alone, and one whose kind is a total offers the
total entry alone. **There is no longer a kind whose row offers nothing**, which is what this
requirement completes: which of the four it offers is the only thing a row says about its kind, and a
row of any kind says its name, the rhythm it runs on and whether the day was kept in exactly the same
way.

Whether a row offers an entry SHALL NOT depend on what the history says. A row already saying its
commitment is kept offers one exactly as a row saying it is not, because a day at its target can be
added to again and a day past it is not closed. What the entry it offers *carries* does depend on the
history, and that is the next requirement's.

The day the row is asked as of SHALL be given to it, and this capability MUST NOT read it from a
clock, MUST NOT consult the present moment, the device's time zone or the locale, and MUST NOT keep
it. A row therefore answers the same way for ever when asked as of the same day.

#### Scenario: a row offers the total entry for its commitment on the date the day view is of

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of Monday
  31 August 2026
- **THEN** the day view holds one row named "Protein"
- **AND** that row offers a total entry

#### Scenario: a row for a commitment whose kind is not a total offers no total entry

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Gym" of the tick kind, one named "Weight" of the number kind with a range
  of 40 to 150 and one named "Journal" of the note kind, all three on a schedule listing Monday,
  Wednesday and Saturday and all kept from 1 January 2026, and each of its rows is asked as of Monday
  31 August 2026
- **THEN** the day view holds three rows, named "Gym", "Weight" and "Journal"
- **AND** none of them offers a total entry
- **AND** a row for a commitment alike in every way but of the total kind with a target of 120, asked
  as of that same day, offers one

#### Scenario: a row offers a tick, a number entry, a note entry or a total entry and never two of them

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Gym" of the tick kind, one named "Weight" of the number kind with a range
  of 40 to 150, one named "Journal" of the note kind and one named "Protein" of the total kind with
  a target of 120, all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, and all four of its rows are asked as of Monday 31 August 2026
- **THEN** the row named "Gym" offers a tick and none of the three entries
- **AND** the row named "Weight" offers a number entry and nothing else of the four
- **AND** the row named "Journal" offers a note entry and nothing else of the four
- **AND** the row named "Protein" offers a total entry and nothing else of the four

#### Scenario: a row for a date later than the day it is asked as of offers no total entry

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  record, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of
  Monday 31 August 2026
- **THEN** the day view holds one row named "Protein"
- **AND** that row offers no total entry
- **AND** it offers no tick, no number entry and no note entry either

#### Scenario: a row for a date later than the day it is asked as of offers no total entry even where the day holds additions

- **WHEN** a day view is formed on Wednesday 2 September 2026, of a commitment named "Protein" of
  the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, from a history holding additions of 30 and 90 for that commitment on that
  date, and its one row is asked as of Monday 31 August 2026
- **THEN** that row says the commitment is kept
- **AND** it offers no total entry

#### Scenario: a row for a date earlier than the day it is asked as of offers the total entry

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of Saturday
  5 September 2026
- **THEN** the row offers a total entry

#### Scenario: a row offers the total entry whether or not the day is already kept

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, the first from a history holding an addition of 30 for that commitment on that
  date and the second from a history holding one of 120, and each one's row is asked as of that same
  day
- **THEN** the first row says the commitment is not kept and the second says it is
- **AND** both offer a total entry

### Requirement: A total entry says the day's sum and the commitment's target, and says nothing else

A total entry SHALL say exactly one thing: **the day's sum and the commitment's target, in words** —
"150 of 120" for a day that has added 150 against a target of 120. It is one phrase saying two
numbers, and it says them because a person adding to a day has to know how far the day has got and
how far it has to go; neither number answers that on its own.

The sum SHALL be the one the `record` capability answers for that commitment on that date, asked of
the history the day view was formed from, and MUST NOT be recomputed here — exactly as whether the
day is kept is, and exactly as the number and the note are. The target SHALL be the one the
commitment declares, said as it was declared with no digit added and none dropped, and the sum SHALL
be said the same way. A day that holds no addition SHALL say a sum of **zero** rather than saying
nothing, because zero is what that day has added and there is no such thing as a total entry with no
sum to say.

**It SHALL say the true sum, whether or not the sum has passed the target.** A day that has added
150 against a target of 120 says "150 of 120" and never "120 of 120": showing a person less than
they recorded would be this app editing their own record down to look tidy, which is the false record
this product exists to remove. The words SHALL be this package's own English and no locale's, as a
day title and a rhythm in words are.

**A total entry SHALL say no hint, and there is none to say.** A number entry says the range its
commitment declares, because a range is a bound one commitment declares and another does not, and a
person is owed it before it refuses them. Every total there will ever be takes the same amounts —
anything above zero — so a hint on a total entry would be the same words on every total row in the
app, which is noise rather than teaching. What a total entry refuses a person for is told when it
refuses them, and that is another requirement's.

**Its field is not prefilled, and this capability SHALL NOT say a value for one to be prefilled
from.** A number entry says the number the day already holds, because committing it again is a
replacement and a person editing 70.5 to 71 must see the 70.5. A commit in a total entry is an
**addition**, so a field opening on the day's 90 and committed unread would make the day 180 — the
sum a total entry says is for reading and never for editing, and it is the first thing in this system
of which that is true.

A row SHALL NOT say the sum itself. What a row gives back is its name, the rhythm its commitment runs
on in words, whether that commitment is kept, and what it offers; the sum is reachable only through
the entry, exactly as the number and the note are. So a row for a day that has added 30 and a row for
a day that has added 90 say exactly what a ticked row says about themselves — that the day is not
kept — and how far the day has got is read in the one place a person can act on it.

#### Scenario: a total entry says the day's sum and the commitment's target

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, from a history holding additions of 30 and 45.5 for that commitment on that date,
  and its one row is asked as of that same day
- **THEN** the entry that row offers says "75.5 of 120"
- **AND** the entry of a row for a commitment alike in every way but with a target of 0.5, asked as
  of that same day, says "75.5 of 0.5"

#### Scenario: a total entry of a day holding no addition says a sum of zero

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, the first from a history that has taken no record and the second from a
  history an addition of 30 for that commitment on that date was added to and then taken back from,
  and each one's row is asked as of that same day
- **THEN** the entry the first row offers says "0 of 120"
- **AND** the entry the second row offers says "0 of 120"

#### Scenario: a total entry says the true sum once it has passed the target

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, from a history holding additions of 120 and 30 for that commitment on that date,
  and its one row is asked as of that same day
- **THEN** the entry that row offers says "150 of 120"
- **AND** that row says the commitment is kept

#### Scenario: a row for a total commitment says its name, its rhythm and whether the day is kept, and never its sum

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, from a history holding an addition of 30 for that commitment on that date
- **THEN** the day view holds one row named "Protein"
- **AND** that row says "Mon, Wed, Sat"
- **AND** it says the commitment is not kept
- **AND** a row of a day view formed the same way but from a history holding an addition of 90
  instead says all three of those things identically

### Requirement: A row offers taking back its day's last addition, and offers none where the day holds none

A row SHALL offer, when asked as of a calendar date, **taking its day's last addition back**, exactly
where two things hold: it offers a total entry as of that day, and the day it is for holds at least
one addition. Where either fails it SHALL offer no such thing. It is the only affordance in this
capability that appears and disappears with what the history says, and it is the **second** thing a
row offers, beside an entry, where every other kind of row offers exactly one thing.

It is a second thing because it cannot be the same gesture as the entry. A number entry and a note
entry are taken back by being committed blank, which works because a blank commit means *the day
holds nothing now* and the day held one record. A total's take-back removes the **last addition** and
leaves the rest, so the same gesture would silently delete the most recent thing a person added and
they would have to remember what it was to know what they had lost. Its own act is what makes that
impossible rather than merely unlikely.

Whether the day holds an addition SHALL be read off the day's **sum being above zero**, and this
capability SHALL NOT ask for the additions themselves. Every addition is above zero, so a day with
one has a sum above zero and a day with none has a sum of zero — the two questions have the same
answer, and asking the one that is already answered keeps the list of additions out of this
capability entirely.

A row that offers no take-back MUST NOT be hidden, MUST NOT be drawn as kept, and MUST NOT be given
some other act in its place. It offers a total entry like every other total row, says its name, its
rhythm and whether the day is kept like every other row, and the only difference is that there is
nothing there to take back.

#### Scenario: a row whose day holds an addition offers taking the last one back

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, from a history holding an addition of 30 for that commitment on that date, and its
  one row is asked as of that same day
- **THEN** that row offers taking its day's last addition back
- **AND** a row of a day view formed the same way but from a history holding additions of 120 and 30
  offers it too, though that day is kept and past its target

#### Scenario: a row whose day holds no addition offers no take-back

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, the first from a history that has taken no record and the second from a
  history an addition of 30 for that commitment on that date was added to and then taken back from,
  and each one's row is asked as of that same day
- **THEN** neither row offers taking its day's last addition back
- **AND** both offer a total entry

#### Scenario: a row for a commitment whose kind is not a total offers no take-back

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" of the tick
  kind, one named "Weight" of the number kind with a range of 40 to 150 and one named "Journal" of
  the note kind, all three on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, from a history holding a tick for "Gym", a number of 70.5 for "Weight" and a note
  holding "Ran 8k." for "Journal", all on that date, and each of its rows is asked as of that same
  day
- **THEN** none of the three rows offers taking its day's last addition back

#### Scenario: a row for a date later than the day it is asked as of offers no take-back

- **WHEN** a day view is formed on Wednesday 2 September 2026, of a commitment named "Protein" of
  the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, from a history holding an addition of 30 for that commitment on that date,
  and its one row is asked as of Monday 31 August 2026
- **THEN** that row offers no take-back
- **AND** the same row asked as of Wednesday 2 September 2026 offers one

#### Scenario: a row goes on offering the take-back while the day still holds an addition

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, from a history holding additions of 30 and 90 for that commitment on that date;
  that day's last addition is taken back from that history; and a day view is formed again from the
  history as it now stands
- **THEN** the row of the day view formed again offers taking its day's last addition back
- **AND** its entry says "30 of 120"
- **AND** a day view formed again after that day's last addition is taken back once more offers no
  take-back, and its entry says "0 of 120"

### Requirement: A day screen adds what is committed in a row's total entry, and keeps it before the day view says so

A day screen SHALL add, on one of its rows, the amount a person commits in that row's total entry,
to the additions that row's day already holds. A commit in a total entry is **always an addition**:
it is never a replacement of what the day holds, and it is never a take-back, however the day stood
before it. Committing 30 twice leaves a day of 60, where committing 70.5 twice in a number entry
leaves a day of 70.5, and that difference is the whole of what the total kind is.

**What is committed SHALL NOT be read as a take-back, whatever it says.** A commit that says nothing
at all — an empty field, or one holding nothing but blank space — SHALL keep nothing, take nothing
back and change nothing at all. That is where a total entry parts from a number entry and a note
entry, whose blank commit is exactly the take-back: a total's take-back removes only the *last*
addition, so reading a blank commit as one would silently delete the most recent thing a person added
and leave them to remember what it was. Taking an addition back is its own act on the row, and it is
its own requirement.

**Which entry a commit lands in SHALL be decided by the row it was made on, and by nothing about the
text itself.** A commit on a row offering a number entry is read as a number, a commit on a row
offering a note entry is read as a note, a commit on a row offering a total entry is read as an
amount to add, and a commit on a row offering none of the three changes nothing at all — so "30"
committed on a note row is the note "30" and on a total row is thirty added to the day, and a caller
cannot commit into an entry the row does not offer however the text is shaped.

The entry SHALL be the one the row itself offers, asked as of the today the screen was handed and
never as of the day it is showing. A day screen moved onto a day that has not arrived therefore adds
nothing on it: the row it holds is for a date later than that today, and such a row offers no entry.
The screen MUST NOT form an addition of its own, MUST NOT choose which day a commit is for, and MUST
NOT reach past a row to the commitment underneath it.

A commit SHALL change nothing at all — nothing kept, nothing shown, nothing told — in each of three
cases, and each is the tick's own answer, the number's and the note's to the same condition. A row
the screen's day view does not hold changes nothing. A row that offers no total entry changes
nothing, whether because its commitment's kind is not a total or because its date has not arrived.
And a screen that is not keeping a record changes nothing, whatever the reason its store would not
open.

The change SHALL be kept at the screen's record place before its day view says so, and the day view
SHALL then be formed again, on the day the screen is showing, from the record as it stands and from
the commitments its roster had not stopped keeping on that day, rather than the day view it held
being altered. A change that could not be kept SHALL be refused, SHALL be reported to the caller
rather than passed over, and SHALL leave the day view exactly as it was. The day view a person reads
MUST NOT be ahead of what is kept at the place, and an addition that could not be kept MUST NOT be
held anywhere in its place.

An addition SHALL reach the record's place and nothing else. Making one MUST NOT write to the
roster's place, and MUST NOT change what the screen says about its roster: the two are kept
independently, and an addition is not a change to what a person keeps.

#### Scenario: adding on a total row makes the day screen say what the day has added

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "30" is committed on its one
  row
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** the day view says the commitment is not kept on that date

#### Scenario: a day's additions accumulate rather than replace one another

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "30" is committed on its one
  row and then "30" again on the row it then holds
- **THEN** the entry the row the day screen then holds offers says "60 of 120"
- **AND** committing "45.5" on the row it then holds leaves it saying "105.5 of 120"

#### Scenario: reaching the target makes the day screen say the commitment is kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "30" and then "90" are
  committed on the row it holds each time
- **THEN** the day screen's day view says the commitment is kept on that date
- **AND** the entry its row offers says "120 of 120"

#### Scenario: an addition past the target keeps the day and says the true sum

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "120" and then "30" are
  committed on the row it holds each time
- **THEN** the day screen's day view says the commitment is kept on that date
- **AND** the entry its row offers says "150 of 120"

#### Scenario: an addition entered on a day screen is held by a day screen opened afterwards at the same place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" and then "90" are committed
  on the row it holds each time; and a second day screen of the same commitment is then opened at the
  same place as of the same day
- **THEN** the second day screen's day view says the commitment is kept on that date
- **AND** the entry its one row offers says "120 of 120"

#### Scenario: an addition that cannot be kept is refused and leaves the day view as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Protein" of the total
  kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and "30" is committed on its one row
- **THEN** committing is refused with an error
- **AND** the entry the row the day screen then holds offers still says "0 of 120"
- **AND** a day screen opened afterwards at the same place says the same

#### Scenario: committing nothing at all in a total entry keeps nothing and takes nothing back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" and then "90" are committed
  on the row it holds each time; and nothing at all is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers still says "120 of 120"
- **AND** the day view still says the commitment is kept on that date
- **AND** committing two spaces, and then a text of three line breaks, leaves it saying the same
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: adding on a row the day screen's day view does not hold changes nothing

- **WHEN** two day screens of a commitment named "Protein" of the total kind with a target of 120,
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, are opened at one
  place where nothing has been kept, the first as of Monday 31 August 2026 and the second as of
  Wednesday 2 September 2026, and "30" is committed on the first screen in the second screen's row's
  total entry
- **THEN** the entry the first day screen's row offers still says "0 of 120"
- **AND** a day screen opened afterwards at that place as of Wednesday 2 September 2026 says "0 of
  120" too

#### Scenario: committing on a row that offers no total entry changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind and a commitment named "Protein" of the total
  kind with a target of 120, both on a schedule listing all seven weekdays and both kept from
  1 January 2026; "30" is committed on the row named "Gym"; the screen is then moved to the day
  after; and "30" is committed on the row it then holds named "Protein"
- **THEN** the day screen's day view says neither commitment is kept on Tuesday 1 September 2026
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says neither is
  kept on that date, and says "0 of 120" for "Protein"

#### Scenario: a commit is read as the entry the row it was made on offers, for all four kinds

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind, one named "Weight" of the number kind with a
  range of 40 to 150, one named "Journal" of the note kind and one named "Protein" of the total kind
  with a target of 120, in that order and all on a schedule listing Monday, Wednesday and Saturday
  and all kept from 1 January 2026, and "120" is committed in turn on each of the four rows the
  screen holds at the time
- **THEN** the entry the second row of the screen it then holds offers says the number 120
- **AND** the entry the third row offers says the note "120"
- **AND** the entry the fourth row offers says "120 of 120"
- **AND** the day view says "Gym" is not kept and the other three are kept on that date

#### Scenario: adding on a day screen that is not keeping a record changes nothing and keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and
  "30" is committed on its one row
- **THEN** the entry its row offers still says "0 of 120"
- **AND** it still says it is not keeping a record
- **AND** the content at that place is byte-for-byte what it was before the screen was opened

#### Scenario: adding on one row leaves the other rows of the day as they were

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind, a commitment named "Protein" of the total kind
  with a target of 120 and a commitment named "Water" of the total kind with a target of 2, in that
  order, all three on a schedule listing all seven weekdays and all kept from 1 January 2026, and
  "120" is committed on the second row
- **THEN** the day screen's day view holds three rows in that same order
- **AND** only the second says its commitment is kept
- **AND** the entry the third row offers says "0 of 2"

#### Scenario: adding on a day a day screen has moved back to keeps it on that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing all seven weekdays, kept from 1 January 2026; it is moved to the day before; and "120" is
  committed on its one row
- **THEN** its day view says the commitment is kept on Sunday 30 August 2026
- **AND** a day screen opened afterwards at that place as of Sunday 30 August 2026 says the
  commitment is kept on that date
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says the
  commitment is not kept on that date, and says "0 of 120"

#### Scenario: adding writes nothing to the roster's place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place and a roster place
  where nothing has been kept, of a commitment named "Protein" of the total kind with a target of
  120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; the roster
  place is read once the screen has been opened; and "30" is then committed on its one row, and
  nothing at all committed on the row it then holds
- **THEN** the content at the roster place is byte-for-byte what it was after the screen was opened
- **AND** the day screen says it is keeping its roster

### Requirement: A day screen reads what is committed in a total entry as an amount to add, as nothing at all, or as a value it refuses

A day screen SHALL read what is committed in a total entry as exactly one of three things: an
**amount to add**, **nothing at all**, or a **value it refuses**. There is no fourth answer, and
none of the three is a take-back.

**What is committed SHALL be nothing at all when it says nothing**: the empty text, and any text made
only of blank space. Such a commit changes nothing and refuses nothing, and nothing SHALL be told of
it — a person who opened a field and committed it empty asked for no change and got none. What the
screen was **already** telling on a row SHALL stand, because nothing has happened to end it; that is
the requirement on how long what is told lasts, and it is not restated here.

**Blank space SHALL mean whatever the `record` capability means by it**, and this capability SHALL
NOT decide it a third time. It is spaces, tabs and line breaks alike, exactly as it is where a
number entry and a note entry are read and where a commitment name is judged, and a character that
occupies no width is not blank space. Blank space at the start and the end of what is committed SHALL
be disregarded before it is read further.

**What is left SHALL be read as a decimal number in exactly the way a number entry's commit is
read**, and this capability SHALL NOT read it a second way: the same digits, the same two decimal
separators read alike, the same refusal of an exponent or a stray sign, and the same
**thirty-eight significant digits** beyond which text says a number this system cannot keep exactly.
That reading is its own requirement and is not restated here. Text it does not read as a number SHALL
be **refused**, SHALL keep nothing, SHALL take nothing back, and SHALL be told on the row as
**"Not a number"** — the cause a number entry already names for the same text, because the person's
next act is the same one.

**An amount that is not above zero SHALL be refused**, SHALL keep nothing, and SHALL be told on the
row as **"Must be more than 0"**. Zero and every amount below it are refused where the record is
formed, which is `record`'s own rule and not a second one here; what this capability adds is the
telling, and it names this cause because a person can act on it differently — they can give a
different amount, and "try again" is false for ever.

**An amount that would take the day's additions past what this system can keep exactly SHALL be
refused**, SHALL keep nothing, SHALL leave the day's additions standing, and SHALL be told on the row
as **"Too large to add"**. The bound is the day's sum as arithmetic gives it, counted in
**significant digits** from the first digit that is not a zero to the last that is not a zero: up to
thirty-eight SHALL be added, and text that would take the sum past that SHALL NOT. It is the same
bound, for the same reason, that a number entry already applies to one typed number, moved onto the
one record this system accumulates — a total whose sum has quietly stopped equalling what was added
is a false record, and it is worse than a refusal because nothing tells a person it happened. It
SHALL be judged against the sum arithmetic gives and never against any shortened form of it, because
a sum that has been shortened has already lost the digits that would prove it wrong. The cause names
only what a person can act on: the headroom it could otherwise name is a thirty-eight-digit number,
which is not something anybody types against.

**No further cause SHALL be named, and a total entry SHALL teach nothing before it refuses.** There
is no hint, no ceiling drawn on the field and no rule a total commitment declares of its own; a
person meets these three refusals by making one, which is the price of a rule that is the same for
every total there will ever be.

#### Scenario: an amount committed with space around it is added

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and a text of two spaces, then
  "30", then a line break, is committed on its one row
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** the day screen tells nothing on any row

#### Scenario: an amount typed with a comma is added as the same amount as one typed with a full stop

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "45,5" is committed on its
  one row
- **THEN** the entry the row the day screen then holds offers says "45.5 of 120"
- **AND** committing "0000030.50" on the row it then holds leaves it saying "76 of 120"

#### Scenario: an amount of zero or below is refused and told on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" is committed on its one
  row; and "0" is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers still says "30 of 120"
- **AND** the day screen tells, on that row, that it must be more than 0
- **AND** committing "-30" and then "-0.000001" on the row leaves it saying "30 of 120" and telling
  the same thing each time
- **AND** a day screen opened afterwards at the same place as of the same day says "30 of 120"

#### Scenario: a value that is not a number committed in a total entry is refused and told on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" is committed on its one
  row; and each of "1.2.3", ".", "-", "12abc", "1e3" and a text of one zero-width space is then
  committed in turn on the row it then holds
- **THEN** the entry the row the day screen then holds offers says "30 of 120" after every one of
  them
- **AND** the day screen tells, on that row, that it is not a number
- **AND** a day screen opened afterwards at the same place as of the same day says "30 of 120"

#### Scenario: an amount that would take the day's sum past what can be kept exactly is refused and told on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; a whole number of thirty-eight
  nines is committed on its one row; and "0.5" is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers says the day's sum as that whole number
  of thirty-eight nines, of 120
- **AND** the day screen tells, on that row, that it is too large to add
- **AND** a day screen opened afterwards at the same place as of the same day says the same sum

#### Scenario: an amount that takes the day's sum to a number that can be kept exactly is added

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; a whole number of thirty-eight
  nines is committed on its one row; and "1" is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers says a sum of 1 followed by
  thirty-eight zeros, of 120
- **AND** the day screen tells nothing on any row
- **AND** committing "0.5" on the row it then holds tells, on that row, that it is too large to add,
  and leaves the sum as it was

#### Scenario: a commit saying nothing in a total entry changes nothing and tells nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" is committed on its one
  row; "0" is then committed on the row it then holds; and nothing at all is then committed on the
  row it then holds
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** the day screen still tells, on that row, that it must be more than 0
- **AND** committing a text of one tab followed by one line break leaves it saying and telling the
  same

### Requirement: A day screen takes back the last addition a row offers, and keeps it before the day view says so

A day screen SHALL take back, on one of its rows, the last addition that row's day holds, and SHALL
keep the change before its day view says so. It is its **own act**, taking a row and nothing else:
there is no amount to give it, because the day's order names the addition that goes, and there is no
text to commit, because a commit in a total entry is always an addition.

It SHALL take back exactly one addition each time it is asked, and SHALL leave every earlier addition
of that day standing, in the order they were made. Taking back three additions is three acts, and
this capability SHALL offer no act that clears a day.

It SHALL change nothing at all — nothing kept, nothing shown, nothing told — in each of three cases,
which are the same three every other change on this screen has. A row the screen's day view does not
hold changes nothing. A row that **offers no take-back** changes nothing, whether because its
commitment's kind is not a total, because its date has not arrived, or because its day holds no
addition to take back. And a screen that is not keeping a record changes nothing, whatever the reason
its store would not open.

The change SHALL be kept at the screen's record place before its day view says so, and the day view
SHALL then be formed again, on the day the screen is showing, from the record as it stands and from
the commitments its roster had not stopped keeping on that day. A change that could not be kept SHALL
be refused, SHALL be reported to the caller rather than passed over, SHALL be told on the row naming
no cause, and SHALL leave the day view exactly as it was: a person whose take-back the place would
not accept is owed the same one thing to do as a person whose tick it would not accept, and no more.

A take-back SHALL reach the record's place and nothing else, exactly as an addition does.

#### Scenario: taking back the last addition on a row leaves the day short by exactly that amount

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" and then "90" are committed
  on the row it holds each time; and that row's last addition is then taken back
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** the day view says the commitment is not kept on that date

#### Scenario: taking back the last addition twice removes the two most recent

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30", then "45", then "50" are
  committed on the row it holds each time; and the last addition of the row it then holds is taken
  back twice
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** that row still offers taking its day's last addition back
- **AND** taking it back once more leaves the entry saying "0 of 120" and the row offering no
  take-back

#### Scenario: a take-back is held by a day screen opened afterwards at the same place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" and then "90" are committed
  on the row it holds each time; that row's last addition is taken back; and a second day screen of
  the same commitment is then opened at the same place as of the same day
- **THEN** the second day screen's day view says the commitment is not kept on that date
- **AND** the entry its one row offers says "30 of 120"

#### Scenario: a take-back that cannot be kept is refused and leaves the day view as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from but
  not written to and that holds a record in which a commitment named "Protein" of the total kind
  with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, has added 30 and 90 on that date, and that row's last addition is taken back
- **THEN** taking back is refused with an error
- **AND** the entry the row the day screen then holds offers still says "120 of 120"
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** what it tells names no cause

#### Scenario: taking back on a row that offers no take-back changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind and a commitment named "Protein" of the total
  kind with a target of 120, both on a schedule listing Monday, Wednesday and Saturday and both kept
  from 1 January 2026, and the last addition is taken back on each of its two rows in turn
- **THEN** the day screen's day view says neither commitment is kept on that date
- **AND** the entry the second row offers says "0 of 120"
- **AND** the day screen tells nothing on any row

#### Scenario: taking back on a row for a day that has not arrived changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing all seven weekdays, kept from 1 January 2026; "30" is committed on its one row; the screen
  is moved to the day after; and the last addition is taken back on the row it then holds
- **THEN** a day screen opened afterwards at that place as of Monday 31 August 2026 says "30 of 120"
- **AND** the day screen tells nothing on any row

#### Scenario: taking back on a row the day screen's day view does not hold changes nothing

- **WHEN** two day screens of a commitment named "Protein" of the total kind with a target of 120,
  on a schedule listing all seven weekdays, kept from 1 January 2026, are opened at one place where
  nothing has been kept, the first as of Monday 31 August 2026 and the second as of Tuesday
  1 September 2026; "30" is committed on each screen's own row; and the second screen's row is then
  taken back on the first screen
- **THEN** a day screen opened afterwards at that place as of Tuesday 1 September 2026 says "30 of
  120"

#### Scenario: taking back on a day screen that is not keeping a record changes nothing and keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and
  the last addition is taken back on its one row
- **THEN** it says it is not keeping a record
- **AND** the day screen tells nothing on any row
- **AND** the content at that place is byte-for-byte what it was before the screen was opened

#### Scenario: taking back writes nothing to the roster's place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place and a roster place
  where nothing has been kept, of a commitment named "Protein" of the total kind with a target of
  120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" is
  committed on its one row; the roster place is read; and that row's last addition is then taken
  back
- **THEN** the content at the roster place is byte-for-byte what it was before the take-back
- **AND** the day screen says it is keeping its roster

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

### Requirement: A day screen says the day view of the day before the one it is showing and of the day after

A day screen SHALL say two further day views beside the one it is showing: the day view of the
calendar date one day earlier than the day being shown, and the day view of the calendar date one
day later. They SHALL be two answers rather than one — a caller needs either without the other, and
neither is derived from the other — and the day view of the day being shown SHALL go on being said
exactly as it is today, unchanged in name, in shape and in every answer it gives.

**Each SHALL be the day view this screen would hold had it been moved onto that day.** It SHALL be
formed from the commitments the screen's roster had not stopped keeping **on that day**, in the
groups and the order that roster answers with for it, and from the record the screen already holds —
which is to say from exactly what *A day screen moves the day it is showing one calendar day either
way* would form on landing there. A commitment the roster stopped keeping yesterday therefore has a
row on the day before and none on the day being shown, and a commitment kept from tomorrow has a row
on the day after and none today. This capability MUST NOT form either from the commitments answered
for the day being shown: a neighbour formed against the wrong day's roster would change the moment it
was moved onto, and what a person is shown of a day must be what they get when they reach it.

**Saying either SHALL read neither place again.** The roster asked is the one read when the app was
last shown or the screen was last returned to, whichever happened later, together with every change
kept since; the record is the record as the screen last read it, together with every change kept on
the screen since. Being shown and being returned to are the moments a day screen learns what is at
either place, and being asked what is either side of the day is not one of them.

**Saying either SHALL change nothing about the screen.** The day being shown SHALL be the day it was,
the today SHALL NOT move, nothing SHALL be kept at either place, and **what the screen is telling on
a row SHALL be left exactly as it was**. What a day screen tells on a row lasts until the app is
shown again, a change is kept, or the day it is showing changes, and asking what is either side of
the day is none of those three: a caller that stepped the screen onto a neighbour and back in order
to read one would wipe a refusal the person had not read yet, and this answer exists so that nothing
ever has to.

**Exactly one day either side SHALL be said, and never a run of them.** A day screen says the day
before and the day after and no day beyond either; a caller wanting the day after that moves the
screen and asks again, and gets the answer for the day it is then showing.

**Both SHALL follow the day being shown**, whatever put the screen on it: the day it was opened on, a
move either way, the way back to today, a day picked on its day picker, a new today handed to it when
the app was shown again, or the screen being returned to. Each of those SHALL leave the two answers
being the neighbours of the day then being shown, formed from the roster and the record then held —
so a screen returned to after its roster changed says its neighbours from the roster it then holds,
and never from the one it held before.

**A day screen that is not keeping a record or not keeping a roster SHALL say them like any other.**
Each is formed exactly as the day being shown is, from whatever the screen holds: a screen that could
not read its record says three days of rows none of which is kept, and a screen that could not read
its roster says three days holding no rows. Withholding them would let a failure at a place take away
what a person can be shown of the days either side, which is more than the failure itself costs, and
what the screen says about either place SHALL be untouched by being asked.

#### Scenario: a day screen says the day view of the day before the one it is showing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026
- **THEN** the day view it says of the day before is the same day view as one formed directly of
  those two commitments, in that order, on Sunday 30 August 2026, from a history that has taken no
  tick
- **AND** that day view holds one row, named "Journaling"

#### Scenario: a day screen says the day view of the day after the one it is showing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026
- **THEN** the day view it says of the day after is the same day view as one formed directly of those
  two commitments, in that order, on Tuesday 1 September 2026, from a history that has taken no tick
- **AND** that day view holds one row, named "Journaling"

#### Scenario: a day screen says the day one calendar day either side and no day further

- **WHEN** a day screen is opened as of Sunday 1 March 2026, at a place where nothing has been kept,
  of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1 January
  2026
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Saturday 28 February 2026 from a history that has taken no tick, which is one
  calendar day earlier and not two
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Monday 2 March 2026 from that same history

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
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Monday 31 August 2026 from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Wednesday 2 September 2026 from that same history

#### Scenario: a day screen sent back to today says the day either side of that today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before three times; and it is then sent back to today
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Sunday 30 August 2026 from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Tuesday 1 September 2026 from that same history

#### Scenario: a day screen showing a day picked on its day picker says the day either side of that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and Friday 25 September 2026 is picked on its day picker
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Thursday 24 September 2026 from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Saturday 26 September 2026 from that same history

#### Scenario: a day screen shown again on a new day says the day either side of that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the app is then shown again as of Wednesday 2 September 2026
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Tuesday 1 September 2026 from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Thursday 3 September 2026 from that same history

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

#### Scenario: a day screen that cannot read its record says the day either side of it with nothing kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes that
  is not what a record is written as, of a commitment named "Journaling" on a schedule listing all
  seven weekdays, kept from 1 January 2026
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Sunday 30 August 2026 from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Tuesday 1 September 2026 from that same history
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

### Requirement: A day screen says no day view before the first supported date and none after the last

A day screen showing 1 January 1583 SHALL say no day view of the day before it, and a day screen
showing 31 December 9999 SHALL say no day view of the day after it. Those are the first and last
dates the system forms, so there is no day view to say, in the way there is none for 30 February —
and the absence is the whole of the answer, exactly as it is when a day view is asked for the day
before its own first date.

**The absence SHALL be about the calendar and about nothing else.** A screen showing either end SHALL
go on saying the day view on its other side; a screen showing any other date SHALL say one on both
sides, whatever its roster holds, whatever its record holds, whether its day view has any rows, and
whichever day it was handed as today.

**The absence SHALL NOT be read as an answer about moving.** It says what there is to draw beside the
day being shown; whether a move has anywhere to go is not answered here and is not answered anywhere,
and a caller MUST NOT stand a move down on the strength of it. Staying exactly as it was is the
move's own answer, given by the move.

#### Scenario: a day screen showing the first supported date says no day view before it and says the day after

- **WHEN** a day screen is opened as of Saturday 1 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583
- **THEN** it says no day view of the day before
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Sunday 2 January 1583 from a history that has taken no tick

#### Scenario: a day screen showing the last supported date says no day view after it and says the day before

- **WHEN** a day screen is opened as of Friday 31 December 9999, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583
- **THEN** it says no day view of the day after
- **AND** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Thursday 30 December 9999 from a history that has taken no tick

#### Scenario: a day screen moved off an end of the calendar says a day view either side of it

- **WHEN** a day screen is opened as of Saturday 1 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583, and it is moved to the day after
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Saturday 1 January 1583 from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Monday 3 January 1583 from that same history

### Requirement: A day screen makes every change on the day it is showing and none on a day either side of it

Every change a day screen makes SHALL be made on the day it is showing. A tick made or taken back, a
number entered or taken back, a note entered or taken back, an amount added and a last addition taken
back are all changes to the day being shown, and a day screen SHALL make none of them on the day
before it or the day after it, whatever it says about those days.

**A row that only a day either side holds SHALL change nothing at all.** A row is a commitment's line
on a date, so a row taken from the day view of the day before or of the day after is a row for a date
this screen is not on: making a tick with it, entering with it and taking back with it SHALL each
leave the record's place exactly as it was, SHALL leave the screen's day view exactly as it was, and
SHALL leave what the screen says of the days either side exactly as it was. This is the shipped rule
that *a row the screen's day view does not hold SHALL change nothing at all*, read over the rows this
capability now says: what a day screen says of a neighbouring day is something to draw, and never
something to act through.

**Nothing SHALL be told on such a row.** A row this screen is not on is not a refusal a person needs
to be told about — nothing was attempted on the day they are looking at — so a change asked for
through one SHALL leave what the screen is telling on a row exactly as it was, whether that was
something or nothing.

#### Scenario: ticking a row a day screen says of the day before changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the one row of the day view it says of the day before is ticked
- **THEN** the day view it says of the day before still says the commitment is not kept on Sunday
  30 August 2026
- **AND** its day view is the same day view as the one it held when it was opened
- **AND** the content at its record place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: entering a number on a row a day screen says of the day after changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026; and "72" is committed on the one row of the
  day view it says of the day after
- **THEN** the entry that row offers, asked again from the day view the screen then says of the day
  after, says no number
- **AND** its day view is the same day view as the one it held when it was opened
- **AND** the content at its record place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: taking back the last addition on a row a day screen says of the day before changes nothing

- **WHEN** a day screen is opened as of Sunday 30 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing all seven weekdays, kept from 1 January 2026; "30" is committed on the one row it holds;
  it is moved to the day after; and the last addition is then taken back on the one row of the day
  view it says of the day before
- **THEN** the entry that row offers, asked again from the day view the screen then says of the day
  before, says "30 of 120"
- **AND** the content at its record place is byte-for-byte what it was immediately before that
  take-back was asked for

#### Scenario: a day screen tells nothing on a row of a day either side of the one it is showing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026, and the one row of the day view it
  says of the day before is ticked
- **THEN** it is telling nothing on any row
- **AND** ticking that row is not refused with an error
