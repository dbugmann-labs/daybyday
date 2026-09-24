## ADDED Requirements

### Requirement: A look-back counts nothing in a gap, and says its lines unbroken through it

A look-back SHALL count no day of a **gap**, the days between one era's day kept until and the next
era's day kept from, and SHALL say nothing a record holds for a gap day: no kept day, no point and
no note. It SHALL run its month lines and its week lines unbroken through a gap, saying each gap day
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

### Requirement: A week a weekly quota era holds owes its quota in proportion to the days held

A week SHALL owe, for each era of a commitment running on a weekly quota that holds a day of it,
that era's quota times the number of the week's days it holds, over seven; the parts SHALL be summed
and rounded once to the nearest whole number. An era SHALL hold every day from its day kept from
through the day it was kept until, and every day from its day kept from on where it carries no day
kept until, days after today included. No era SHALL hold a day of a gap. What a week owes SHALL be
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

### Requirement: A weekly quota era's look-back counts each week's kept days out of what the week owes

A tick commitment's look-back SHALL say one line for each week holding a day it counts against an
era running on a weekly quota, newest week first, leaving no such week between the newest and the
oldest out. A week SHALL be a Monday through the following Sunday, and its line SHALL say that
whole span whatever days are counted. Each week's line SHALL say a **fraction**: the days of that
week it counts kept against any era running on a weekly quota, out of what that week owes, as *A
week a weekly quota era holds owes its quota in proportion to the days held* says, which SHALL
neither cap the days kept nor be a percentage. A look-back saying both month lines and week lines
SHALL say them in one order, newest first, a line standing above another whose last counted day is
earlier.

#### Scenario: a look-back says a week's kept days out of its quota

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule of three times a
  week, kept from 23 February 2026, whose days take a tick, kept on 9 March 2026 and 11 March 2026
  and on no other day, as of 15 March 2026
- **THEN** the line for the week of 9 March 2026 says "9–15 Mar 2026" and the fraction "2/3"

#### Scenario: a look-back says its weeks newest first, and leaves none between out

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule of three times a
  week, kept from 23 February 2026, whose days take a tick, kept on no day at all, as of 15 March
  2026
- **THEN** its lines are the weeks "9–15 Mar 2026", "2–8 Mar 2026" and "23 Feb – 1 Mar 2026", in
  that order
- **AND** each of them says the fraction "0/3"

#### Scenario: a look-back counts the week in progress against the whole quota

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule of three times a
  week, kept from 1 January 2026, whose days take a tick, kept on 9 March 2026 and on no other day,
  as of 11 March 2026
- **THEN** its newest line is the week "9–15 Mar 2026", saying the fraction "1/3"
- **AND** it says no line for the week after it

#### Scenario: a look-back counts the week a commitment is kept from against its part of the quota

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule of three times a
  week, kept from 1 January 2026, whose days take a tick, kept on 2 January 2026 and on no other
  day, as of 15 March 2026
- **THEN** its oldest line is the week "29 Dec 2025 – 4 Jan 2026", saying the fraction "1/2"
- **AND** it says no line for the week before it

#### Scenario: a look-back says a week kept past its quota as the days kept, uncapped

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule of three times a
  week, kept from 23 February 2026, whose days take a tick, kept on 9, 10, 11 and 12 March 2026 and
  on no other day, as of 15 March 2026
- **THEN** the line for the week "9–15 Mar 2026" says the fraction "4/3"

#### Scenario: a stopped quota commitment's look-back counts its last week through the day it was kept until

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule of three times a
  week, kept from 1 January 2026 and kept until 3 March 2026, whose days take a tick, kept on 2
  March 2026 and on 4 March 2026 and on no other day, as of 15 March 2026
- **THEN** its newest line is the week "2–8 Mar 2026", saying the fraction "1/1"
- **AND** it says no line for the week after it

#### Scenario: a look-back says a weekday era's months and a quota era's weeks, each in its own unit

- **WHEN** a look-back is asked for at a commitment named "Gym" whose days take a tick, whose
  earlier era ran on a schedule of three times a week from 23 February 2026 until 3 March 2026 and
  whose newest runs on a schedule listing Monday, Wednesday and Saturday from 4 March 2026, kept on
  23, 25 and 27 February 2026, on 2 March 2026 and on 4, 7 and 9 March 2026, as of 15 March 2026
- **THEN** its lines are, in order, the month "March 2026" saying "3/5", the week "2–8 Mar 2026"
  saying "1/1" and the week "23 Feb – 1 Mar 2026" saying "3/3"

#### Scenario: a week two quota eras share says its kept days out of both eras' parts of their quotas

- **WHEN** a look-back is asked for at a commitment named "Gym" whose days take a tick, whose
  earlier era ran on a schedule of three times a week from 23 February 2026 until 3 March 2026 and
  whose newest runs on a schedule of five times a week from 4 March 2026, kept on 2 March 2026 and
  5 March 2026, as of 8 March 2026
- **THEN** the week "2–8 Mar 2026" is said once and says the fraction "2/4"
- **AND** the week "23 Feb – 1 Mar 2026" says the fraction "0/3"

## MODIFIED Requirements

### Requirement: A look-back says one whole across everything since the day the commitment is kept from

A look-back SHALL say a **whole**: one fraction across everything it counts, from the day the
commitment is kept from through the last day it counts. The whole SHALL be counted by the rule its
lines are counted by, so it SHALL say the sum of its lines' kept days out of the sum of the due
days those lines say and what they owe, month lines and week lines alike, and it SHALL never be a
percentage. A look-back that says no line at all, and one whose lines say no due day and owe nothing,
SHALL say a whole of nothing out of nothing.

#### Scenario: a look-back's whole counts every kept day out of every due day since the day it is kept from

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, whose days take a tick, kept on eleven days of
  February 2026 and on no other day, as of 15 March 2026
- **THEN** its whole says "11/31", the eleven days kept out of the thirty-one days due across
  January, February and March 2026 through 15 March 2026

#### Scenario: a look-back's whole is the sum of the months it says

- **WHEN** a look-back is asked for at a commitment named "Sharpen knives" on a schedule of every
  40 days from 1 January 2026, kept from 1 January 2026, whose days take a tick, kept on 10
  February 2026 and on no other day, as of 31 May 2026
- **THEN** its whole says the sum of its months' kept days out of the sum of their due days, "1/4"

#### Scenario: a look-back's whole is the sum of the weeks it says

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule of three times a
  week, kept from 23 February 2026, whose days take a tick, kept on 23 and 25 February 2026 and on
  2 March 2026 and on no other day, as of 15 March 2026
- **THEN** its whole says the sum of its weeks' kept days out of the sum of their quotas, "3/9"

#### Scenario: a mixed chain's whole sums its months' due days and its weeks' quotas alike

- **WHEN** a look-back is asked for at a commitment named "Gym" whose days take a tick, whose
  earlier era ran on a schedule of three times a week from 23 February 2026 until 3 March 2026 and
  whose newest runs on a schedule listing Monday, Wednesday and Saturday from 4 March 2026, kept on
  23, 25 and 27 February 2026, on 2 March 2026 and on 4, 7 and 9 March 2026, as of 15 March 2026
- **THEN** its whole says "7/9", its month line's five due days and what its two week lines owe,
  three and one, summed alike

#### Scenario: a look-back that counts no due day at all says a whole of nothing out of nothing

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 April 2026, whose days take a tick, as of 15 March 2026
- **THEN** its whole says "0/0"

## REMOVED Requirements

### Requirement: A weekly quota era's look-back counts each week's kept days out of its quota

**Reason:** a week no longer owes the whole quota of the newest quota era counting a day of it; it
owes each quota era's part, as *A week a weekly quota era holds owes its quota in proportion to the
days held* says. Replaced by *A weekly quota era's look-back counts each week's kept days out of what
the week owes*.

**Migration:** every scenario is carried under the new heading with its test. *A look-back counts
the week a commitment is kept from against the whole quota* is renamed *a look-back counts the week
a commitment is kept from against its part of the quota*, and *a week two quota eras share says its
kept days out of the newer era's quota* is renamed *a week two quota eras share says its kept days
out of both eras' parts of their quotas*; each test is renamed with it and asserts the new fraction.
Two scenarios keep their titles and change their fraction to "1/1": *a stopped quota commitment's
look-back counts its last week through the day it was kept until* and *a look-back says a weekday
era's months and a quota era's weeks, each in its own unit*.
