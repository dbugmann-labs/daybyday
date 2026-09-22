## ADDED Requirements


### Requirement: A look-back reads a commitment's eras off the roster by its identity

A look-back SHALL read a commitment's chain of eras off the roster as the eras carrying that
commitment's identity, newest first, and SHALL reach no era of any other commitment however alike it
is in name, kind, rhythm or day. It SHALL count each day it counts against the era that holds that
day, SHALL say the newest era's rhythm in words, and SHALL say the earliest era's day kept from as
the day the commitment is kept from. A commitment of one era SHALL be counted exactly as one of
many, and what a chain says SHALL depend on nothing else the roster holds.

#### Scenario: a look-back counts the era behind the one it was asked about

- **WHEN** a look-back is asked for at a commitment named "Gym" whose days take a tick, whose
  earlier era ran on a schedule listing Monday, Wednesday and Saturday from 1 January 2026 until
  3 March 2026 and whose newest runs on a schedule listing Tuesday and Thursday from 4 March 2026,
  kept on no day at all, as of 31 March 2026
- **THEN** its lines are the months March 2026, February 2026 and January 2026
- **AND** the line for March 2026 says the fraction "0/9", the one day the older era was due
  through 3 March 2026 and the eight days the newer era was due from 4 March 2026

#### Scenario: a look-back says the newest era's rhythm and the earliest era's day kept from

- **WHEN** a look-back is asked for at a commitment named "Gym" whose days take a tick, whose
  earlier era ran on a schedule listing Monday, Wednesday and Saturday from 1 January 2026 until
  3 March 2026 and whose newest runs on a schedule listing Tuesday and Thursday from 4 March 2026,
  as of 31 March 2026
- **THEN** it says the rhythm "Tue, Thu" and the day kept from "1 January 2026"

#### Scenario: a look-back chains every era of the commitment it was asked about

- **WHEN** a look-back is asked for at a commitment named "Gym" whose days take a tick, with three
  eras — the first from 1 January 2026 until 31 January 2026, the second from 1 February 2026 until
  28 February 2026, and the newest from 1 March 2026 — as of 31 March 2026
- **THEN** it says the day kept from "1 January 2026"
- **AND** its lines are the months March 2026, February 2026 and January 2026

#### Scenario: a look-back reaches no era of another commitment however alike it is

- **WHEN** a look-back is asked for at a commitment named "Gym" of one era, on a schedule listing
  all seven weekdays, kept from 4 March 2026, whose days take a tick, on a roster also keeping a
  commitment named "Gym 2" whose earlier era ran on that same schedule from 1 January 2026 until
  3 March 2026, as of 31 March 2026
- **THEN** it says the day kept from "4 March 2026" and its one line is the month March 2026
- **AND** a look-back at a commitment the roster has stopped, alike in every way to the earlier era
  of "Gym 2", says the day kept from its own era is kept from

#### Scenario: a look-back chains an era whose range or target differs behind the one it was asked about

- **WHEN** a look-back is asked for at a commitment named "Mood" whose days take a number, whose
  earlier era carried a range of 1 to 10 from 1 January 2026 until 3 March 2026 and whose newest
  carries a range of 1 to 5 from 4 March 2026, as of 31 March 2026
- **THEN** it says the day kept from "1 January 2026"
- **AND** a look-back at a commitment named "Protein" whose days take a total, whose earlier era
  carried a target of 120 from 1 January 2026 until 3 March 2026 and whose newest carries a target
  of 100 from 4 March 2026, says the day kept from "1 January 2026" too
- **AND** a look-back at one named "Weight" whose days take a number, whose earlier era carried a
  range of 40 to 150 and whose newest carries none, says the same

## MODIFIED Requirements

### Requirement: A look-back says one whole across everything since the day the commitment is kept from

A look-back SHALL say a **whole**: one fraction across everything it counts, from the day the
commitment is kept from through the last day it counts. The whole SHALL be counted by the rule its
lines are counted by, so it SHALL say the sum of its lines' kept days out of the sum of the due
days and the quotas those lines say, month lines and week lines alike, and it SHALL never be a
percentage. A look-back that says no line at all, and one whose lines say no due day and no quota,
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
- **THEN** its whole says "7/11", its month line's five due days and its two week lines' quotas of
  three summed alike

#### Scenario: a look-back that counts no due day at all says a whole of nothing out of nothing

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 April 2026, whose days take a tick, as of 15 March 2026
- **THEN** its whole says "0/0"

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

- **WHEN** a look-back is asked for at a commitment named "Gym" whose days take a tick, whose
  earlier era ran on a schedule of three times a week from 23 February 2026 until 3 March 2026 and
  whose newest runs on a schedule listing Monday, Wednesday and Saturday from 4 March 2026, kept on
  23, 25 and 27 February 2026, on 2 March 2026 and on 4, 7 and 9 March 2026, as of 15 March 2026
- **THEN** its lines are, in order, the month "March 2026" saying "3/5", the week "2–8 Mar 2026"
  saying "1/3" and the week "23 Feb – 1 Mar 2026" saying "3/3"

#### Scenario: a week two quota eras share says its kept days out of the newer era's quota

- **WHEN** a look-back is asked for at a commitment named "Gym" whose days take a tick, whose
  earlier era ran on a schedule of three times a week from 23 February 2026 until 3 March 2026 and
  whose newest runs on a schedule of five times a week from 4 March 2026, kept on 2 March 2026 and
  5 March 2026, as of 8 March 2026
- **THEN** the week "2–8 Mar 2026" is said once and says the fraction "2/5"
- **AND** the week "23 Feb – 1 Mar 2026" says the fraction "0/3"

### Requirement: A number commitment's look-back says a graph of the numbers its days hold

A look-back at a commitment whose days take a number SHALL say a **graph**, and SHALL say no line
and no whole. The graph SHALL say one **point** for each day the look-back counts that holds a
number: that number, as a value and said in words, and the day it was kept on. The number a day
holds SHALL be the one the record holds for the era that holds that day. The graph SHALL say its
points oldest first and SHALL say nothing at all about a day that holds no number. Where no day it
counts holds a number, the look-back SHALL say no graph at all, and SHALL still say the
commitment's name, the rhythm it runs on in words, the day it is kept from and, where the roster has
stopped keeping it, the day it was kept until.

#### Scenario: a number commitment's look-back says a point for each day that holds a number

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number, holding 72.5 on 1 March 2026, 71 on 3 March
  2026 and 70.8 on 4 March 2026 and no number on any other day, as of 5 March 2026
- **THEN** its graph says three points, the first saying "72.5" on 1 March 2026, the second "71" on
  3 March 2026 and the third "70.8" on 4 March 2026
- **AND** its graph says nothing at all about 2 March 2026 and 5 March 2026
- **AND** the look-back says no line at all and no whole

#### Scenario: a number commitment's look-back says no graph where no day holds a number

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number, holding no number at all, as of 5 March 2026
- **THEN** it says no graph, no line at all and no whole
- **AND** it says the name "Weight", the rhythm and the day kept from "1 March 2026" as any other
  look-back does
- **AND** a look-back at such a commitment kept from 1 April 2026 says no graph either

#### Scenario: a number commitment's look-back says one point where one day holds a number

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number, holding 72.5 on 3 March 2026 and no number on
  any other day, as of 5 March 2026
- **THEN** its graph says one point, saying "72.5" on 3 March 2026

#### Scenario: a number commitment's look-back says the number the era holding a day kept

- **WHEN** a look-back is asked for at a commitment named "Weight" whose days take a number, whose
  earlier era ran on a schedule listing Monday from 2 March 2026 until 3 March 2026 and whose newest
  runs on a schedule listing every day from 4 March 2026, the older era holding 80 on 2 March 2026
  and the newer holding 70 on 4 March 2026, as of 4 March 2026
- **THEN** its graph says two points, the first saying "80" on 2 March 2026 and the second "70" on 4
  March 2026

### Requirement: A number commitment's graph says the lowest and the highest its values run between

A graph SHALL say a lowest and a highest value, each as a value and said in words, and SHALL say no
value between them. Where the newest era of the chain declares a range, the lowest SHALL be that
range's lowest and the highest SHALL be its highest; where it declares none, the lowest SHALL be the
least value any point says and the highest SHALL be the greatest. Where a point says a value below
the lowest so taken, the lowest SHALL be that value instead, and where one says a value above the
highest so taken, the highest SHALL be that value instead.

#### Scenario: a number commitment's graph runs between the range its newest era declares

- **WHEN** a look-back is asked for at a commitment named "Mood" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number between 1 and 10, holding 6 on 1 March 2026 and 7
  on 2 March 2026, as of 2 March 2026
- **THEN** its graph says the lowest "1" and the highest "10"

#### Scenario: a number commitment's graph with no range runs between the values its points say

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number and declare no range, holding 72.5 on 1 March
  2026, 70.8 on 2 March 2026 and 71 on 3 March 2026, as of 3 March 2026
- **THEN** its graph says the lowest "70.8" and the highest "72.5"

#### Scenario: a number commitment's graph with one point says that value as its lowest and its highest

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number and declare no range, holding 72.5 on 2 March
  2026, as of 3 March 2026
- **THEN** its graph says the lowest "72.5" and the highest "72.5"

#### Scenario: a number commitment's graph widens to hold a value outside its newest era's range

- **WHEN** a look-back is asked for at a commitment named "Mood" on a schedule listing every day,
  kept from 4 March 2026, whose days take a number between 1 and 5, whose earlier era ran on a schedule listing every day from 1 March 2026 until
  3 March 2026 taking a number between 1 and 10, the older era holding 8 on 2 March 2026 and
  the newer holding 4 on 4 March 2026, as of 4 March 2026
- **THEN** its graph says the lowest "1" and the highest "8"

### Requirement: A look-back says nothing where one era gives way to the next

A look-back SHALL say nothing at all wherever one era of its chain gives way to the next. Its lines
SHALL be month lines and week lines only, running in their one newest-first order unbroken across
every boundary, with no line and no mark of any kind between the line above a boundary and the line
below it. A number commitment's graph SHALL say no rule and no mark at a boundary, and SHALL say the
same days, the same months and the same points across one that it says where no era gives way. A
boundary SHALL go unmarked whatever ended the older era, a rhythm changed, an interval's count begun
again or a range or a target changed alike.

#### Scenario: a look-back says nothing between the lines either side of a boundary

- **WHEN** a look-back is asked for at a commitment named "Gym" whose days take a tick, whose
  earlier era ran on a schedule listing Monday, Wednesday and Saturday from 1 January 2026 until
  3 March 2026 and whose newest runs on a schedule listing Tuesday and Thursday from 4 March 2026,
  as of 31 March 2026
- **THEN** its lines are exactly the months March 2026, February 2026 and January 2026, in that
  order, and it says no other line
- **AND** a look-back at a commitment named "Gym" whose days take a tick, whose earlier era ran on a
  schedule listing Monday, Wednesday and Saturday from 1 January 2026 until 3 March 2026 and whose
  newest runs on a schedule of three times a week from 4 March 2026, kept on no day at all, as of
  15 March 2026, says exactly the weeks "9–15 Mar 2026" and "2–8 Mar 2026" and the months March
  2026, February 2026 and January 2026, in that order

#### Scenario: a number commitment's graph says nothing where one era gives way to the next

- **WHEN** a look-back is asked for at a commitment named "Weight" whose days take a number, whose
  earlier era ran on a schedule listing every day from 1 March 2026 until 3 March 2026 and whose
  newest runs on a schedule listing Tuesday and Thursday from 4 March 2026, the older era holding
  72.5 on 2 March 2026 and the newer holding 71 on 5 March 2026, as of 8 March 2026
- **THEN** its graph says eight days, "1 March 2026" first and "8 March 2026" last, one month
  "March 2026" naming the first of them, and two points, "72.5" naming the second of those days and
  "71" naming the fifth
- **AND** it says nothing else naming a day, and nothing at all about 4 March 2026, the day the
  newer era is kept from

## REMOVED Requirements

### Requirement: A look-back reads a commitment's earlier eras off the roster by resemblance

**Reason:** an era is no longer a removed commitment that resembles the one in front of it; it is an
entry carrying the same identity, so the chain is read rather than reconstructed. Replaced in full
by *A look-back reads a commitment's eras off the roster by its identity*.

**Migration:** the scenarios that turn on resemblance — a removed commitment of another name or kind
not chaining, a removed commitment kept until any day but the day before not chaining, the nearest
of two that answer, and an era taken up again ending a chain — go with it, along with their tests.
Under an identity none of those questions can be asked: what chains is what carries the identity,
and the fold is what decides that once, at the upgrade.
