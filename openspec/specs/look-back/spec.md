# look-back Specification

## Purpose
One commitment seen on its own, over everything since the day it was kept from: the page reached
from a commitment on the commitments screen, kept or stopped alike, which shows and enters nothing.
It is where a person reads how a commitment has gone, month by month, rather than what today asks.

## Requirements

### Requirement: A commitments screen answers a look-back at a commitment on either of its lists

A commitments screen SHALL answer a **look-back** at any commitment on its kept list or its stopped
list, whatever kind that commitment's days take. A look-back SHALL say the commitment's name, the
rhythm it runs on in words, the day it is kept from and, where the roster has stopped keeping that
commitment, the day it was kept until; where the roster is keeping it, the look-back SHALL say no
day kept until. The screen SHALL answer no look-back at a commitment on neither list, and none at
all while it cannot read its roster or cannot read its record. A look-back SHALL be a value: asking
for the same commitment twice SHALL answer the same look-back, and asking SHALL change nothing the
screen holds and SHALL write nothing at either place it keeps.

#### Scenario: a commitments screen answers a look-back at a commitment it keeps

- **WHEN** a commitments screen keeping a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, whose days take a tick, as of 15 March 2026, is
  asked for a look-back at it
- **THEN** it answers one, saying the name "Gym", the rhythm "Mon, Wed, Sat" and the day kept from
  "1 January 2026"
- **AND** the look-back says no day kept until

#### Scenario: a commitments screen answers a look-back at a commitment it has stopped, saying the day it was kept until

- **WHEN** a commitments screen that has stopped keeping a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026 and kept until 28 February 2026,
  whose days take a tick, as of 15 March 2026, is asked for a look-back at it
- **THEN** it answers one, saying the name "Gym", the rhythm "Mon, Wed, Sat", the day kept from
  "1 January 2026" and the day kept until "28 February 2026"

#### Scenario: a commitments screen answers no look-back at a commitment on neither of its lists

- **WHEN** a commitments screen keeping a commitment named "Gym" is asked for a look-back at a
  commitment named "Journaling" that its roster does not hold
- **THEN** it answers no look-back
- **AND** asked for a look-back at a commitment its roster holds removed, it answers none either

#### Scenario: a commitments screen that cannot read its roster or its record answers no look-back

- **WHEN** a commitments screen whose roster place holds a run of bytes that is not a roster is
  asked for a look-back at any commitment
- **THEN** it answers no look-back
- **AND** a commitments screen that reads its roster but whose record place holds a run of bytes
  that is not a record answers no look-back either

#### Scenario: asking a commitments screen for a look-back changes nothing and writes nothing

- **WHEN** a commitments screen keeping a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, whose days take a tick, as of 15 March 2026, is
  asked for a look-back at it twice
- **THEN** both answers are the same look-back
- **AND** the lists it draws, the change it last refused and the bytes at its roster place and at
  its record place are exactly what they were before the first ask

### Requirement: A tick commitment's look-back counts each calendar month's kept days out of its due days

A tick commitment's look-back SHALL say one line for each calendar month holding a day it counts
against an era not running on a weekly quota, newest month first, leaving no such month between the
newest and the oldest out — a month the commitment is due on no day included. Each month's line
SHALL say that month in words and a **fraction**: the days of that month it counts kept, out of the
days of that month it counts due, and never a percentage. A look-back SHALL count only the days from the day the
commitment is kept from through the last day it counts, which SHALL be the day the commitment was
kept until where the roster has stopped keeping it and today otherwise. A look-back at a commitment
kept from a day after today SHALL say no line at all.

#### Scenario: a look-back says a month's kept days out of the days that month was due

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, whose days take a tick, kept on eleven of the
  twelve days of February 2026 it was due, as of 15 March 2026
- **THEN** the line for February 2026 says "February 2026" and the fraction "11/12"

#### Scenario: a look-back says its months newest first, and leaves none between out

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, whose days take a tick, as of 15 March 2026
- **THEN** its lines are the months March 2026, February 2026 and January 2026, in that order

#### Scenario: a look-back says a month the commitment was due on no day with nothing due

- **WHEN** a look-back is asked for at a commitment named "Sharpen knives" on a schedule of every
  40 days from 1 January 2026, kept from 1 January 2026, whose days take a tick, as of 31 May 2026
- **THEN** its lines are the months May 2026 through January 2026, April 2026 among them
- **AND** the line for April 2026 says the fraction "0/0"

#### Scenario: a look-back counts the month in progress through today and no further

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, whose days take a tick, kept on no day at all,
  as of 15 March 2026
- **THEN** the line for March 2026 says the fraction "0/6", counting the six days through 15 March
  2026 it was due and none of the days after it

#### Scenario: a stopped commitment's look-back counts through the day it was kept until

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026 and kept until 28 February 2026, whose days take
  a tick, kept on no day at all, as of 15 March 2026
- **THEN** its lines are the months February 2026 and January 2026, and no line for March 2026
- **AND** the line for February 2026 says the fraction "0/12"

#### Scenario: a look-back counts no day after the day a commitment was kept until

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026 and kept until 28 February 2026, whose days take
  a tick, kept on 4 March 2026 and on no other day, as of 15 March 2026
- **THEN** the line for February 2026 says the fraction "0/12" and no line names March 2026

#### Scenario: a look-back counts no day before the day a commitment is kept from

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 16 February 2026, whose days take a tick, kept on no day at
  all, as of 28 February 2026
- **THEN** its one line is February 2026, saying the fraction "0/6", counting the six days from 16
  February 2026 onwards it was due and none of the six before it its schedule also names

#### Scenario: a look-back at a commitment kept from a day after today says no month at all

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 April 2026, whose days take a tick, as of 15 March 2026
- **THEN** it says no line at all
- **AND** it says the name, the rhythm and the day kept from as any other look-back does

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

### Requirement: A look-back says its months, its days and its fractions in the app's own words

A look-back SHALL say a month as that month's name and its year, and a day as the day of the month,
that month's name and the year, each part separated by a single space. The twelve month names SHALL
be this package's own English — January through December — and SHALL NOT follow the device's
language, region, locale or calendar preferences. A look-back SHALL say a fraction as the count of
days kept, a slash with no space on either side, and the count of days due.

#### Scenario: a look-back says a month as that month's name and its year

- **WHEN** a look-back is asked for at a commitment kept from 1 January 2026 whose days take a
  tick, as of 31 December 2026
- **THEN** its twelve month lines say "December 2026", "November 2026", "October 2026", "September
  2026", "August 2026", "July 2026", "June 2026", "May 2026", "April 2026", "March 2026", "February
  2026" and "January 2026", in that order

#### Scenario: a look-back says a day as the day of the month, that month's name and the year

- **WHEN** a look-back is asked for at a commitment kept from 1 January 2026 and kept until 9 March
  2026, whose days take a tick, as of 31 March 2026
- **THEN** it says the day kept from "1 January 2026" and the day kept until "9 March 2026"

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

### Requirement: A look-back says a week as the span of its days, in short month names

A look-back SHALL say a week as the span of its seven days. Where both ends fall in one calendar
month it SHALL say the two days separated by an en dash with no space either side, then that
month's name and the year. Where they fall in different months it SHALL say each end as its day and
that month's name, separated by an en dash with a single space either side, and the year once after
the second end — or, where the two ends fall in different years, each end's own year after its own
month. The month names on a week SHALL be the three-letter ones, "Jan" through "Dec", and a week
SHALL be the only place a look-back says a month short. They SHALL be this package's own English
and SHALL NOT follow the device's language, region, locale or calendar preferences.

#### Scenario: a look-back says a week inside one month as its two days, that month's short name and the year

- **WHEN** a look-back is asked for at a commitment on a schedule of three times a week, kept from
  1 September 2026, whose days take a tick, as of 13 September 2026
- **THEN** its newest line says the week "7–13 Sep 2026"

#### Scenario: a look-back says a week across two months as each end's day and short month, and the year once

- **WHEN** a look-back is asked for at a commitment on a schedule of three times a week, kept from
  1 September 2026, whose days take a tick, as of 13 September 2026
- **THEN** its oldest line says the week "31 Aug – 6 Sep 2026"

#### Scenario: a look-back says a week across two years as each end's day, short month and year

- **WHEN** a look-back is asked for at a commitment on a schedule of three times a week, kept from
  29 December 2025, whose days take a tick, as of 4 January 2026
- **THEN** its one line says the week "29 Dec 2025 – 4 Jan 2026"

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

### Requirement: A look-back says a number as its digits, in the app's own words

A look-back SHALL say a number as its digits and nothing else: the digits of its whole part, with no
separator between thousands, then — where it has a fraction — a full stop and the digits of that
fraction. A number below zero SHALL be said with a leading minus and no space after it. The digits
SHALL be the Western Arabic ones, 0 through 9, and a look-back SHALL NOT follow the device's
language, region, locale or calendar preferences in saying a number.

#### Scenario: a look-back says a number with a fraction as its digits either side of a full stop

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number and declare no range, holding 72.5 on 1 March
  2026 and 0.08 on 2 March 2026, as of 2 March 2026
- **THEN** its points say "72.5" and "0.08", and its graph says the lowest "0.08" and the highest
  "72.5"

#### Scenario: a look-back says a whole number with no separator between thousands

- **WHEN** a look-back is asked for at a commitment named "Steps" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number and declare no range, holding 100000 on 1 March
  2026, as of 1 March 2026
- **THEN** its one point says "100000"

#### Scenario: a look-back says a number below zero with a leading minus

- **WHEN** a look-back is asked for at a commitment named "Balance" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number between -10 and 10, holding -3 on 1 March 2026,
  as of 1 March 2026
- **THEN** its one point says "-3", and its graph says the lowest "-10" and the highest "10"

### Requirement: A look-back at a commitment whose days take a note or a total says no line

A look-back at a commitment whose days take a note or a total SHALL say no line at all, SHALL say no
whole and SHALL say no graph. It SHALL still say the commitment's name, the rhythm it runs on in
words, the day it is kept from and, where the roster has stopped keeping it, the day it was kept
until, as any other look-back does.

#### Scenario: a look-back at a commitment whose days take a note or a total says no line, no whole and no graph

- **WHEN** a look-back is asked for at a commitment named "Journal" kept from 1 January 2026 whose
  days take a note, as of 15 March 2026
- **THEN** it says the name, the rhythm and the day kept from, says no line at all, says no whole and
  says no graph
- **AND** a look-back at a commitment whose days take a total says the same

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

- **WHEN** a look-back is asked, as of 31 March 2026, at a commitment named "Gym" of one era, on a
  schedule listing all seven weekdays, kept from 4 March 2026, whose days take a tick, on a roster
  folded from one written in the form used before a commitment had an identity, whose entries are
  that "Gym"; "Gym 2" on that same schedule, kept from 4 March 2026 and kept; "Gym 2" on that same
  schedule, kept from 1 January 2026, removed and kept until 3 March 2026; and "Gym 2" on that same
  schedule, kept from 1 January 2026 and stopped as of 3 March 2026
- **THEN** it says the day kept from "4 March 2026" and its one line is the month March 2026
- **AND** a look-back at the commitment the fold left stopped, alike in every way to the earlier era
  of "Gym 2", says the day kept from "1 January 2026"

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
