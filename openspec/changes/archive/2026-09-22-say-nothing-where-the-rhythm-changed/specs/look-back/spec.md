## ADDED Requirements

### Requirement: A look-back says nothing where one era gives way to the next

A look-back SHALL say nothing at all wherever one era of its chain gives way to the next. Its lines
SHALL be month lines and week lines only, running in their one newest-first order unbroken across
every boundary, with no line and no mark of any kind between the line above a boundary and the line
below it. A number commitment's graph SHALL say no rule and no mark at a boundary, and SHALL say the
same days, the same months and the same points across one that it says where no era gives way. A
boundary SHALL go unmarked whatever ended the older era, a rhythm changed, an interval's count begun
again or a range or a target changed alike.

#### Scenario: a look-back says nothing between the lines either side of a boundary

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Tuesday and
  Thursday, kept from 4 March 2026, whose days take a tick, on a roster also holding removed a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026 and kept until 3 March 2026, whose days take a tick, as of 31 March 2026
- **THEN** its lines are exactly the months March 2026, February 2026 and January 2026, in that
  order, and it says no other line
- **AND** a look-back at a commitment named "Gym" on a schedule of three times a week, kept from 4
  March 2026, whose days take a tick, on a roster also holding removed a commitment named "Gym" on
  a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026 and kept until 3
  March 2026, whose days take a tick, kept on no day at all, as of 15 March 2026, says exactly the
  weeks "9–15 Mar 2026" and "2–8 Mar 2026" and the months March 2026, February 2026 and January
  2026, in that order

#### Scenario: a number commitment's graph says nothing where one era gives way to the next

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing Tuesday and
  Thursday, kept from 4 March 2026, whose days take a number, on a roster also holding removed a
  commitment named "Weight" on a schedule listing every day, kept from 1 March 2026 and kept until 3
  March 2026, whose days take a number, the older era holding 72.5 on 2 March 2026 and the newer
  holding 71 on 5 March 2026, as of 8 March 2026
- **THEN** its graph says eight days, "1 March 2026" first and "8 March 2026" last, one month
  "March 2026" naming the first of them, and two points, "72.5" naming the second of those days and
  "71" naming the fifth
- **AND** it says nothing else naming a day, and nothing at all about 4 March 2026, the day the
  newer era is kept from

## MODIFIED Requirements

### Requirement: A weekly quota era's look-back counts each week's kept days out of its quota

A tick commitment's look-back SHALL say one line for each week holding a day it counts against an
era running on a weekly quota, newest week first, leaving no such week between the newest and the
oldest out. A week SHALL be a Monday through the following Sunday, and its line SHALL say that
whole span whatever days are counted. Each week's line SHALL say a **fraction**: the days of that
week it counts kept, out of the quota of the newest weekly quota era it counts a day of that week
against. That quota SHALL be the whole quota however few of the week's days are counted, and SHALL
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

#### Scenario: a look-back counts the week a commitment is kept from against the whole quota

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule of three times a
  week, kept from 1 January 2026, whose days take a tick, kept on 2 January 2026 and on no other
  day, as of 15 March 2026
- **THEN** its oldest line is the week "29 Dec 2025 – 4 Jan 2026", saying the fraction "1/3"
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
- **THEN** its newest line is the week "2–8 Mar 2026", saying the fraction "1/3"
- **AND** it says no line for the week after it

#### Scenario: a look-back says a weekday era's months and a quota era's weeks, each in its own unit

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 4 March 2026, whose days take a tick, on a roster also holding
  removed a commitment named "Gym" on a schedule of three times a week, kept from 23 February 2026
  and kept until 3 March 2026, whose days take a tick, kept on 23, 25 and 27 February 2026, on 2
  March 2026 and on 4, 7 and 9 March 2026, as of 15 March 2026
- **THEN** its lines are, in order, the month "March 2026" saying "3/5", the week "2–8 Mar 2026"
  saying "1/3" and the week "23 Feb – 1 Mar 2026" saying "3/3"

#### Scenario: a week two quota eras share says its kept days out of the newer era's quota

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule of five times a week,
  kept from 4 March 2026, whose days take a tick, on a roster also holding removed a commitment
  named "Gym" on a schedule of three times a week, kept from 23 February 2026 and kept until 3
  March 2026, whose days take a tick, kept on 2 March 2026 and 5 March 2026, as of 8 March 2026
- **THEN** the week "2–8 Mar 2026" is said once and says the fraction "2/5"
- **AND** the week "23 Feb – 1 Mar 2026" says the fraction "0/3"

### Requirement: A number commitment's graph runs from the day it is kept from through the last day it counts

A graph SHALL say one day for each calendar day from the earliest era of the chain's day kept from
through the last day the look-back counts, oldest first, each said as a day; the last day it counts
SHALL be the day the commitment was kept until where the roster has stopped keeping it and today
otherwise. A graph SHALL also say one month for each calendar month holding one of those days,
oldest first, each saying that month and the place among those days of the first of its days. Every
point a graph says SHALL name the place of its own day among those days. A graph SHALL say no point
for a number the record holds on a day after the last day the look-back counts.

#### Scenario: a number commitment's graph says a day for every day from the day it is kept from through today

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number, holding 72.5 on 1 March 2026, as of 5 March 2026
- **THEN** its graph says five days, "1 March 2026" first and "5 March 2026" last
- **AND** its one point names the first of those days

#### Scenario: a number commitment's graph says a month for each calendar month its days run through

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 20 February 2026, whose days take a number, holding 72.5 on 20 February 2026, as of 3
  March 2026
- **THEN** its graph says two months, "February 2026" naming the first of its days and "March 2026"
  naming the tenth

#### Scenario: a stopped number commitment's graph runs through the day it was kept until

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 25 February 2026 and kept until 28 February 2026, whose days take a number, holding 72.5
  on 25 February 2026, as of 5 March 2026
- **THEN** its graph says four days, "25 February 2026" first and "28 February 2026" last

#### Scenario: a number commitment's graph says no point for a number kept after the day it was kept until

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 25 February 2026 and kept until 28 February 2026, whose days take a number, holding 72.5
  on 27 February 2026 and 71 on 4 March 2026, as of 5 March 2026
- **THEN** its graph says one point, saying "72.5" on 27 February 2026

## REMOVED Requirements

### Requirement: A look-back says where the rhythm changed, between its lines

**Reason**: A look-back's head already says the newest era's rhythm and the earliest era's day kept
from, so the line said nothing the page did not, and it broke the run of months and weeks it stood
in. Replaced by *A look-back says nothing where one era gives way to the next*.

**Migration**: None. Nothing outside this capability reads it, and nothing stands in its place.

### Requirement: A number commitment's graph says a rule where one era gives way to the next

**Reason**: The rule said the same thing across the plot that the line said between the lines, and
broke the graph's trace the same way. Replaced by *A look-back says nothing where one era gives way
to the next*.

**Migration**: None. Nothing outside this capability reads it, and nothing stands in its place.
