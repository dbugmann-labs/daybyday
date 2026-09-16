## ADDED Requirements

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
- **THEN** its lines are, in order, the month "March 2026" saying "3/5", a line where the rhythm
  changed, the week "2–8 Mar 2026" saying "1/3" and the week "23 Feb – 1 Mar 2026" saying "3/3"

#### Scenario: a week two quota eras share says its kept days out of the newer era's quota

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule of five times a week,
  kept from 4 March 2026, whose days take a tick, on a roster also holding removed a commitment
  named "Gym" on a schedule of three times a week, kept from 23 February 2026 and kept until 3
  March 2026, whose days take a tick, kept on 2 March 2026 and 5 March 2026, as of 8 March 2026
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

### Requirement: A look-back says where the rhythm changed, between its lines

A look-back SHALL say one line wherever one era of its chain gives way to the next: immediately
above the line of the month or the week the newer era is kept from, and where both a month line and
a week line hold that day, immediately above the lower of those two. It SHALL say one such line for
each boundary between two eras, in the same newest-first order its lines are in, and SHALL say none
at all for a chain of one era. Such a line SHALL say the newer era's rhythm in words and the day
that era is kept from, SHALL say nothing about the older era and SHALL say no fraction.

#### Scenario: a look-back says where the rhythm changed, above the month the newer era is kept from

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Tuesday and
  Thursday, kept from 4 March 2026, whose days take a tick, on a roster also holding removed a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026 and kept until 3 March 2026, whose days take a tick, as of 31 March 2026
- **THEN** its lines are, in order, a line where the rhythm changed saying "Tue, Thu" and "4 March
  2026", then the month March 2026, then February 2026, then January 2026

#### Scenario: a look-back says where the rhythm changed, above the week the newer era is kept from

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule of five times a week,
  kept from 4 March 2026, whose days take a tick, on a roster also holding removed a commitment
  named "Gym" on a schedule of three times a week, kept from 23 February 2026 and kept until 3
  March 2026, whose days take a tick, as of 8 March 2026
- **THEN** its lines are, in order, a line where the rhythm changed saying "5x a week" and "4 March
  2026", then the week "2–8 Mar 2026", then the week "23 Feb – 1 Mar 2026"

#### Scenario: a look-back says where the rhythm changed between a quota era's weeks and a weekday era's months

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule of three times a
  week, kept from 4 March 2026, whose days take a tick, on a roster also holding removed a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026 and kept until 3 March 2026, whose days take a tick, kept on no day at all, as of 15 March
  2026
- **THEN** its lines are, in order, the week "9–15 Mar 2026", the week "2–8 Mar 2026", a line where
  the rhythm changed saying "3x a week" and "4 March 2026", then the month March 2026, then
  February 2026, then January 2026
- **AND** the line for March 2026 says the fraction "0/1", counting only the one day through 3
  March 2026 the older era was due

#### Scenario: a look-back of one era says no line where the rhythm changed

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, whose days take a tick, on a roster holding no
  removed commitment at all, as of 15 March 2026
- **THEN** every line it says is a month

#### Scenario: a look-back of three eras says one line where the rhythm changed for each boundary

- **WHEN** a look-back is asked for at the newest of three commitments named "Gym" whose days take
  a tick, the first on a schedule listing Monday kept from 1 January 2026 and kept until 31 January
  2026, the second on a schedule listing Tuesday kept from 1 February 2026 and kept until 28
  February 2026, both held removed, and the third on a schedule listing Wednesday kept from 1 March
  2026, as of 31 March 2026
- **THEN** it says two lines where the rhythm changed, the one saying "Wed" and "1 March 2026"
  above the month March 2026 and the one saying "Tue" and "1 February 2026" above the month
  February 2026

#### Scenario: a look-back says where an interval commitment's count began again

- **WHEN** a look-back is asked for at a commitment named "Sharpen knives" on a schedule of every 5
  days from 10 March 2026, kept from 10 March 2026, whose days take a tick, on a roster also
  holding removed a commitment named "Sharpen knives" on a schedule of every 5 days from 1 January
  2026, kept from 1 January 2026 and kept until 9 March 2026, whose days take a tick, as of 31
  March 2026
- **THEN** it says one line where the rhythm changed, saying "Every 5 days" and "10 March 2026",
  above the month March 2026

### Requirement: A look-back at a commitment whose days take a number, a note or a total says no line

A look-back at a commitment whose days take a number, a note or a total SHALL say no line at all
and SHALL say no whole. It SHALL still say the commitment's name, the rhythm it runs on in words,
the day it is kept from and, where the roster has stopped keeping it, the day it was kept until, as
any other look-back does.

#### Scenario: a look-back at a commitment whose days take a number, a note or a total says no line and no whole

- **WHEN** a look-back is asked for at a commitment named "Weight" kept from 1 January 2026 whose
  days take a number, as of 15 March 2026
- **THEN** it says the name, the rhythm and the day kept from, says no line at all and says no whole
- **AND** a look-back at a commitment whose days take a note, and one at a commitment whose days
  take a total, each say the same

## MODIFIED Requirements

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

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 4 March 2026, whose days take a tick, on a roster also holding
  removed a commitment named "Gym" on a schedule of three times a week, kept from 23 February 2026
  and kept until 3 March 2026, whose days take a tick, kept on 23, 25 and 27 February 2026, on 2
  March 2026 and on 4, 7 and 9 March 2026, as of 15 March 2026
- **THEN** its whole says "7/11", its month line's five due days and its two week lines' quotas of
  three summed alike

#### Scenario: a look-back that counts no due day at all says a whole of nothing out of nothing

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 April 2026, whose days take a tick, as of 15 March 2026
- **THEN** its whole says "0/0"

## REMOVED Requirements

### Requirement: A look-back says where the rhythm changed, between its months

**Reason**: A chain can now give way between two weeks, or between a week and a month, so the line
is no longer said between months alone. Replaced by *A look-back says where the rhythm changed,
between its lines*, which carries every scenario this one had, unchanged.

**Migration**: None. Nothing outside this capability reads it.

### Requirement: A look-back says no fraction for a kind other than a tick, or for a weekly quota

**Reason**: A weekly quota's line now says a fraction of its own and a chain holding one says a
whole, so the only kinds that say nothing are a number, a note and a total. Replaced by *A look-back
at a commitment whose days take a number, a note or a total says no line*.

**Migration**: None. Nothing outside this capability reads it.
