## MODIFIED Requirements

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
