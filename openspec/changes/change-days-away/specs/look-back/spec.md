## MODIFIED Requirements

### Requirement: A look-back counts nothing in a gap, and says its lines unbroken through it

A look-back SHALL count no day of a **gap**, the days between one era's day kept until and the next
era's day kept from, and SHALL say nothing a record holds for a gap day: no kept day, no point and
no note. A day days away over the commitment hide SHALL be counted as a day of a gap, and a day
under them holding a record of it as any other day. It SHALL run its month lines and its week lines unbroken through a gap, saying each gap day
in the unit of the era before the gap, so a month or a week holding only gap days SHALL say a
fraction of nothing out of nothing. A graph SHALL say every day of a gap among its days, and a
total's target rule SHALL owe a gap day the target of the era before the gap.

#### Scenario: a tick commitment's look-back says a month in a gap as nothing out of nothing and counts no tick a gap day holds

- **WHEN** a look-back is asked for at a commitment named "Gym" whose days take a tick, whose
  earlier era ran on a schedule listing Monday, Wednesday and Saturday from 1 January 2026 until
  31 January 2026 and whose newest runs on that schedule from 1 April 2026, kept on 4 February 2026
  and on no other day, as of 15 April 2026
- **THEN** its lines are the months April 2026, March 2026, February 2026 and January 2026, in that
  order, saying "0/7", "0/0", "0/0" and "0/13"
- **AND** its whole says "0/20"

#### Scenario: a quota commitment's look-back says a week in a gap as nothing out of nothing

- **WHEN** a look-back is asked for at a commitment named "Gym" whose days take a tick, whose
  earlier era ran on a schedule of three times a week from 23 February 2026 until 1 March 2026 and
  whose newest runs on that schedule from 16 March 2026, kept on no day at all, as of 22 March 2026
- **THEN** its lines are the weeks "16–22 Mar 2026", "9–15 Mar 2026", "2–8 Mar 2026" and "23 Feb –
  1 Mar 2026", in that order, saying "0/3", "0/0", "0/0" and "0/3"

#### Scenario: a gap between a weekly quota era and one that is not is said in the unit of the era before it

- **WHEN** a look-back is asked for at a commitment named "Gym" whose days take a tick, whose
  earlier era ran on a schedule of three times a week from 23 February 2026 until 1 March 2026 and
  whose newest runs on a schedule listing Monday, Wednesday and Saturday from 16 March 2026, kept on
  no day at all, as of 22 March 2026
- **THEN** its lines are, in order, the month "March 2026" saying "0/3", the weeks "9–15 Mar 2026"
  and "2–8 Mar 2026" each saying "0/0", and the week "23 Feb – 1 Mar 2026" saying "0/3"

#### Scenario: a number commitment's graph says the days of a gap and no number a gap day holds

- **WHEN** a look-back is asked for at a commitment named "Weight" whose days take a number, whose
  earlier era ran on a schedule listing every day from 1 March 2026 until 3 March 2026 and whose
  newest runs on that schedule from 6 March 2026, the record holding 72.5 on 2 March 2026, 71 on
  4 March 2026 and 70 on 7 March 2026, as of 8 March 2026
- **THEN** its graph says eight days, "1 March 2026" first and "8 March 2026" last
- **AND** it says two points, "72.5" naming the second of those days and "70" naming the seventh

#### Scenario: a total commitment's target rule runs through a gap at the target of the era before it

- **WHEN** a look-back is asked for at a commitment named "Protein" whose days take a total, whose
  earlier era ran on a schedule listing every day with a target of 120 from 1 March 2026 until
  3 March 2026 and whose newest runs on that schedule with a target of 100 from 6 March 2026, the
  older era holding an addition of 150 on 2 March 2026, as of 8 March 2026
- **THEN** its target rule says two stretches, the first from the first of its eight days through
  the fifth saying "120", and the second from the sixth through the eighth saying "100"

#### Scenario: a note commitment's look-back says no note a gap day holds

- **WHEN** a look-back is asked for at a commitment named "Journal" whose days take a note, whose
  earlier era ran on a schedule listing every day from 1 March 2026 until 3 March 2026 and whose
  newest runs on that schedule from 6 March 2026, the record holding "Ran 8k." on 2 March 2026,
  "Rested." on 4 March 2026 and "Swam." on 7 March 2026, as of 8 March 2026
- **THEN** it says two notes, "Swam." on "7 March 2026" first and "Ran 8k." on "2 March 2026" second
- **AND** it says "2 notes"

#### Scenario: a tick commitment's look-back counts no day days away hide, and counts a day under them holding a record

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from Thursday
  1 October 2026, whose days take a tick, is taken on at a roster place; a tick for "Gym" on Monday
  12 October 2026 is kept at a record place; days away from that Monday through Wednesday 14 October
  2026 are said over it through a commitments screen opened at those places as of that Monday; and a
  commitments screen opened at those places as of Thursday 15 October 2026 is asked for a look-back at
  "Gym"
- **THEN** its one line is the month October 2026, saying "1/13"

### Requirement: A week a weekly quota era holds owes its quota in proportion to the days held

A week SHALL owe, for each era of a commitment running on a weekly quota that holds a day of it,
that era's quota times the number of the week's days it holds, over seven; the parts SHALL be summed
and rounded once to the nearest whole number. An era SHALL hold every day from its day kept from
through the day it was kept until, and every day from its day kept from on where it carries no day
kept until, days after today included. No era SHALL hold a day of a gap, nor a day days away over the commitment hide. What a week owes SHALL be
the same number wherever it is said, a look-back's week line and a row's words alike, and a week
owing nothing SHALL still be said.

#### Scenario: a part week owes its quota times the days held over seven, rounded to the nearest whole number

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule of 1 time a week, kept
  from Tuesday 3 March 2026, whose days take a tick, kept on no day at all, as of Sunday 8 March 2026
- **THEN** its one line is the week "2–8 Mar 2026", saying "0/1"
- **AND** alike on a schedule of 3 times a week, one kept from Saturday 7 March 2026 says "0/1" and
  one kept from Sunday 8 March 2026 says "0/0"

#### Scenario: a part week that owes nothing is still said, and a day kept in it counts

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule of 3 times a week,
  kept from Sunday 8 March 2026, whose days take a tick, kept on 8 March 2026, as of 8 March 2026
- **THEN** its one line is the week "2–8 Mar 2026", saying "1/0"
- **AND** its whole says "1/0"

#### Scenario: a week a gap cuts owes the days its eras hold, days to come included, and counts a day kept before the stop

- **WHEN** a look-back is asked for at a commitment named "Gym" whose days take a tick, whose
  earlier era ran on a schedule of three times a week from 1 January 2026 until Monday 2 March 2026
  and whose newest runs on that schedule from Thursday 5 March 2026, kept on 2 March 2026 and on
  5 March 2026, as of Thursday 5 March 2026
- **THEN** its newest line is the week "2–8 Mar 2026", saying "2/2"

#### Scenario: a week days away cover owes its quota in proportion to the days they leave

- **WHEN** a commitment named "Yuno" on a schedule of 5 times a week, kept from 1 January 2026, whose
  days take a tick, is taken on at a roster place; ticks for "Yuno" on Monday 12 and Tuesday 13 October
  2026 are kept at a record place; days away from Friday 16 through Sunday 18 October 2026 are said
  over it through a commitments screen opened at those places as of Monday 12 October 2026; and a
  commitments screen opened at those places as of Sunday 18 October 2026 is asked for a look-back at
  "Yuno"
- **THEN** its newest line is the week "12–18 Oct 2026", saying "2/3"
