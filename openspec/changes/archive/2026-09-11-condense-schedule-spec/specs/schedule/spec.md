## MODIFIED Requirements

### Requirement: A weekday-set schedule is due on the weekdays it lists

A commitment whose schedule is a set of weekdays SHALL be due on a calendar date exactly when the
weekday of that date is a member of the set, and SHALL NOT be due on any other date. The system MUST
NOT consider the current time, the device's time zone, the locale, or which day the user considers
the week to begin on. A set that lists every weekday SHALL be due on every date, and a set that
lists no weekday SHALL be due on none; the system MUST answer both rather than treat either as an
error.

#### Scenario: a date on a listed weekday is due

- **WHEN** a schedule listing Monday, Wednesday and Saturday is asked about Monday 31 August 2026
- **THEN** the commitment is due on that date

#### Scenario: a date on an unlisted weekday is not due

- **WHEN** a schedule listing Monday, Wednesday and Saturday is asked about Tuesday 1 September 2026
- **THEN** the commitment is not due on that date

#### Scenario: a schedule listing every weekday is due on seven consecutive dates

- **WHEN** a schedule listing all seven weekdays is asked about each date from Monday 31 August
  2026 through Sunday 6 September 2026
- **THEN** the commitment is due on every one of those seven dates

#### Scenario: a schedule listing no weekday is due on none of seven consecutive dates

- **WHEN** a schedule listing no weekday at all is asked about each date from Monday 31 August
  2026 through Sunday 6 September 2026
- **THEN** the commitment is due on none of those seven dates

#### Scenario: a Sunday-only schedule is due on Sunday and not on Saturday

- **WHEN** a schedule listing only Sunday is asked about Sunday 6 September 2026
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about Saturday 5 September 2026 answers that it is not due

### Requirement: The weekday of a calendar date follows the Gregorian calendar

The system SHALL determine which weekday a calendar date falls on from the Gregorian calendar and
from nothing else, for every calendar date it accepts. This MUST hold on the leap day of a leap year
and across the turn of a year. The answer MUST NOT vary with the host's time zone or locale.

#### Scenario: a leap day is placed on its Gregorian weekday

- **WHEN** a schedule listing only Tuesday is asked about Tuesday 29 February 2028
- **THEN** the commitment is due on that date
- **AND** a schedule listing only Monday asked about the same date answers that it is not due

#### Scenario: the first day of a year is placed on its Gregorian weekday

- **WHEN** a schedule listing only Friday is asked about Friday 1 January 2027
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about Thursday 31 December 2026 answers that it is not due

### Requirement: A calendar date names a day that exists

A calendar date SHALL be a year, a month of that year and a day of that month. The system SHALL form
one from a combination of the three naming a day, in a year *A calendar date lies within the years
the system supports* accepts, and SHALL refuse to form one naming no day. It MUST refuse rather than
adjust: a day past the end of its month MUST NOT become a day of the following month, and a month
past the twelfth MUST NOT become a month of the following year. No schedule SHALL be asked about a
date that does not exist.

It SHALL also judge each component as the number it was offered, and MUST NOT accept a date in which
a component was treated as absent or unspecified because its value was extreme. It MUST NOT form a
date with a component missing.

#### Scenario: a day beyond the end of its month is not a calendar date

- **WHEN** the year 2026, the month February and the day 30 are offered as a calendar date
- **THEN** no calendar date is formed
- **AND** in particular 2 March 2026 is not formed in its place

#### Scenario: the twenty-ninth of February in a common year is not a calendar date

- **WHEN** the year 2027, the month February and the day 29 are offered as a calendar date
- **THEN** no calendar date is formed

#### Scenario: the twenty-ninth of February in a leap year is a calendar date

- **WHEN** the year 2028, the month February and the day 29 are offered as a calendar date
- **THEN** a calendar date is formed for 29 February 2028

#### Scenario: a month outside the twelve is not a calendar date

- **WHEN** the year 2026, the month 13 and the day 1 are offered as a calendar date
- **THEN** no calendar date is formed
- **AND** in particular 1 January 2027 is not formed in its place

#### Scenario: a month of the largest representable integer is not a calendar date

- **WHEN** the year 2026, the largest integer the platform can represent offered as a month, and
  the day 1 are offered as a calendar date
- **THEN** no calendar date is formed

#### Scenario: a year of the largest representable integer is not a calendar date

- **WHEN** the largest integer the platform can represent offered as a year, the month January and
  the day 1 are offered as a calendar date
- **THEN** no calendar date is formed

#### Scenario: a day of the largest representable integer is not a calendar date

- **WHEN** the year 2026, the month January and the largest integer the platform can represent
  offered as a day are offered as a calendar date
- **THEN** no calendar date is formed

### Requirement: A calendar date lies within the years the system supports

The system SHALL form a calendar date only for a year from 1583 through 9999 inclusive, and SHALL
refuse every year outside that range even when the three components name a day that plainly exists.
It MUST refuse such a year rather than adjust it: a year outside the range MUST NOT be clamped to
the nearest supported year, and no schedule SHALL be asked about a date the system declines to form.
This requirement SHALL bound the year alone, and the month and the day SHALL be bounded as *A
calendar date names a day that exists* says.

#### Scenario: a date before the Gregorian calendar's adoption is not a calendar date

- **WHEN** the year 1500, the month January and the day 1 are offered as a calendar date
- **THEN** no calendar date is formed

#### Scenario: the last day before the first full Gregorian year is not a calendar date

- **WHEN** the year 1582, the month December and the day 31 are offered as a calendar date
- **THEN** no calendar date is formed

#### Scenario: the first day of the first full Gregorian year is a calendar date

- **WHEN** the year 1583, the month January and the day 1 are offered as a calendar date
- **THEN** a calendar date is formed for 1 January 1583

#### Scenario: the last day of the last supported year is a calendar date

- **WHEN** the year 9999, the month December and the day 31 are offered as a calendar date
- **THEN** a calendar date is formed for 31 December 9999

#### Scenario: a year past the last supported year is not a calendar date

- **WHEN** the year 10000, the month January and the day 1 are offered as a calendar date
- **THEN** no calendar date is formed

### Requirement: A day-of-month schedule is due on that day of the month

A commitment whose schedule is a day of the month SHALL be due on a calendar date exactly when the
day of the month that date falls on is the scheduled day, and SHALL NOT be due on any other date,
save as *A month too short for the scheduled day is due on its last day* says. The rule SHALL repeat
in every month of every year the system supports and SHALL be anchored to no start month. The system
MUST NOT consider the weekday the date falls on, the current time, the device's time zone or the
locale. Exactly one date in every month SHALL satisfy a day-of-month schedule, never none and never
two.

#### Scenario: a date on the scheduled day of the month is due

- **WHEN** a schedule on the 25th of the month is asked about 25 September 2026
- **THEN** the commitment is due on that date

#### Scenario: a date on another day of the same month is not due

- **WHEN** a schedule on the 25th of the month is asked about 24 September 2026
- **THEN** the commitment is not due on that date
- **AND** the same schedule asked about 26 September 2026 answers that it is not due

#### Scenario: a day-of-month schedule is due on exactly one date across a whole month

- **WHEN** a schedule on the 25th of the month is asked about each date from 1 through 30 September
  2026
- **THEN** the commitment is due on exactly one of those thirty dates, 25 September 2026

#### Scenario: a schedule on the first is due on the first of a month and not on the last day of the month before

- **WHEN** a schedule on the 1st of the month is asked about 1 September 2026
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 31 August 2026 answers that it is not due

### Requirement: A month too short for the scheduled day is due on its last day

When a month has fewer days than the scheduled day of the month, the commitment SHALL be due on the
last day of that month, MUST NOT be skipped in that month, and MUST NOT roll into the month after.
The last day SHALL be taken from that particular month's true length, 28 or 29 days of February by
whether the year is a leap year and 30 of a thirty-day month, and MUST NOT be taken from a fixed
shortest month. A month long enough to hold the scheduled day SHALL be untouched by this rule: the
commitment SHALL be due on the scheduled day itself and on no other date in that month.

In a common February, schedules on the 28th, 29th, 30th and 31st SHALL all be due on the same date,
and the system MUST NOT treat that as a collision to be resolved.

#### Scenario: a schedule on the thirty-first is due on the last day of a thirty-day month

- **WHEN** a schedule on the 31st of the month is asked about 30 September 2026
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 29 September 2026 answers that it is not due

#### Scenario: a schedule on the thirty-first is due on the last day of a common February

- **WHEN** a schedule on the 31st of the month is asked about 28 February 2027
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 1 March 2027 answers that it is not due

#### Scenario: a schedule on the thirty-first is due on the leap day of a leap February

- **WHEN** a schedule on the 31st of the month is asked about 29 February 2028
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 28 February 2028 answers that it is not due

#### Scenario: a schedule on the twenty-ninth is due on the last day of a common February

- **WHEN** a schedule on the 29th of the month is asked about 28 February 2027
- **THEN** the commitment is due on that date

#### Scenario: a schedule on the thirty-first is not moved in a month that has a thirty-first

- **WHEN** a schedule on the 31st of the month is asked about 31 August 2026
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 30 August 2026 answers that it is not due

### Requirement: A day of the month is a number from the first to the thirty-first

The system SHALL form a day of the month only from a number from 1 through 31 inclusive, and MUST
refuse every other number rather than adjust it: a number past 31 MUST NOT be reduced to the end of
a month, and a number below 1 MUST NOT be read as counting backwards from the end of one. No
schedule SHALL be built on a number outside that range.

#### Scenario: a day of the month past the thirty-first is not a day of the month

- **WHEN** the number 32 is offered as a day of the month
- **THEN** no day of the month is formed

#### Scenario: a day of the month below the first is not a day of the month

- **WHEN** the number 0 is offered as a day of the month
- **THEN** no day of the month is formed
- **AND** the number −1 offered as a day of the month forms none either

#### Scenario: the thirty-first is a day of the month

- **WHEN** the number 31 is offered as a day of the month
- **THEN** a day of the month is formed for the 31st

### Requirement: An every-N-days schedule is due on its start date and every interval after it

A commitment whose schedule is an interval of days SHALL be due on a calendar date exactly when that
date is the schedule's start date or falls a whole number of intervals after it, and SHALL NOT be
due on any other date.

The count SHALL be of calendar days, every day counting once and the leap day of a leap year
included, and MUST NOT vary by the length of the months the two dates fall in, the weekday either
falls on, the turn of a year, the current time, the device's time zone or the locale. The rule SHALL
repeat forward without end while the supported years allow a date to be formed, with no month, week
or year resetting it and no final occurrence. An interval longer than the supported years SHALL be
answered as *An interval is a whole number of days, at least one* says.

#### Scenario: a schedule is due on its start date

- **WHEN** a schedule of every 3 days starting on 31 August 2026 is asked about 31 August 2026
- **THEN** the commitment is due on that date

#### Scenario: a date one interval after the start date is due

- **WHEN** a schedule of every 3 days starting on 31 August 2026 is asked about 3 September 2026
- **THEN** the commitment is due on that date

#### Scenario: a date between two due dates is not due

- **WHEN** a schedule of every 3 days starting on 31 August 2026 is asked about 1 September 2026
- **THEN** the commitment is not due on that date
- **AND** the same schedule asked about 2 September 2026 answers that it is not due

#### Scenario: an every-N-days schedule is due on exactly five dates across a fortnight

- **WHEN** a schedule of every 3 days starting on 31 August 2026 is asked about each date from
  31 August through 13 September 2026
- **THEN** the commitment is due on exactly five of those fourteen dates — 31 August, 3, 6, 9 and
  12 September 2026

#### Scenario: the interval counts across the end of a month

- **WHEN** a schedule of every 14 days starting on 25 August 2026 is asked about 8 September 2026
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 25 September 2026 answers that it is not due

#### Scenario: the interval counts a leap day as a day

- **WHEN** a schedule of every 3 days starting on 26 February 2028 is asked about 29 February 2028
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 1 March 2028 answers that it is not due

#### Scenario: the interval counts across the turn of a year

- **WHEN** a schedule of every 7 days starting on 28 December 2026 is asked about 4 January 2027
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 1 January 2027 answers that it is not due

#### Scenario: an interval of one day is due on every date

- **WHEN** a schedule of every 1 day starting on 31 August 2026 is asked about each date from
  31 August through 6 September 2026
- **THEN** the commitment is due on every one of those seven dates

#### Scenario: an interval longer than the supported years is due only on its start date

- **WHEN** a schedule of every 4,000,000 days starting on 1 January 1583 is asked about 1 January
  1583
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 2 January 1583 answers that it is not due
- **AND** the same schedule asked about 31 December 9999, the last date the system forms, answers
  that it is not due

### Requirement: An every-N-days schedule is not due before its start date

A commitment whose schedule is an interval of days SHALL NOT be due on any calendar date earlier
than its start date. The system MUST NOT project the interval backwards: a date a whole number of
intervals before the start date SHALL NOT be due, and neither SHALL any other earlier date. The
weekday-set and day-of-month shapes SHALL be anchored to the calendar rather than to a start, and
SHALL remain due on every date they match in either direction.

#### Scenario: a date a whole interval before the start date is not due

- **WHEN** a schedule of every 3 days starting on 3 September 2026 is asked about 31 August 2026
- **THEN** the commitment is not due on that date
- **AND** the same schedule asked about 22 August 2026, four intervals earlier still, answers that
  it is not due

#### Scenario: an every-N-days schedule is due on none of the seven dates before its start date

- **WHEN** a schedule of every 3 days starting on 31 August 2026 is asked about each date from
  24 through 30 August 2026
- **THEN** the commitment is due on none of those seven dates

### Requirement: An interval is a whole number of days, at least one

The system SHALL form an interval only from a whole number of days of one or more, and MUST refuse
zero and every negative number rather than adjust them: zero MUST NOT be read as "every day", and a
negative number MUST NOT be read as an interval running backwards. No schedule SHALL be built on a
number outside that range. An interval of one day SHALL be valid, and a schedule on it SHALL be due
on every date from its start date onwards.

An interval SHALL have no upper bound. A number of days larger than the entire supported range of
years SHALL name a schedule that comes due on its start date and never again, and the system MUST
give that answer rather than refusing the interval or losing the arithmetic to overflow.

#### Scenario: an interval of no days is not an interval

- **WHEN** the number 0 is offered as an interval of days
- **THEN** no interval is formed

#### Scenario: an interval of a negative number of days is not an interval

- **WHEN** the number −3 is offered as an interval of days
- **THEN** no interval is formed
- **AND** the number −1 offered as an interval of days forms none either

#### Scenario: an interval of one day is an interval

- **WHEN** the number 1 is offered as an interval of days
- **THEN** an interval of 1 day is formed

### Requirement: A weekly-quota schedule is due on every date

A commitment whose schedule is a weekly quota, a number of times to be done within a week on any
days, SHALL be due on every calendar date the system forms. The system MUST NOT consider the weekday
the date falls on, which week the date belongs to, where a week begins, how many times the quota
asks for, the current time, the device's time zone or the locale.

Being due SHALL mean that the day is one on which the commitment may be done, and MUST NOT mean that
the commitment is still outstanding. The system SHALL keep the question of whether a week's quota
has been met outside this capability: a surface that stops showing a weekly quota once its week is
complete MUST decide that from tick records, not from this predicate.

#### Scenario: a weekly quota is due on every date of a week

- **WHEN** a schedule of 3 times a week is asked about each date from Monday 31 August 2026 through
  Sunday 6 September 2026
- **THEN** the commitment is due on every one of those seven dates

#### Scenario: a weekly quota of one is due on every date of a week

- **WHEN** a schedule of 1 time a week is asked about each date from Monday 31 August 2026 through
  Sunday 6 September 2026
- **THEN** the commitment is due on every one of those seven dates

#### Scenario: a weekly quota is due on the dates either side of a week boundary

- **WHEN** a schedule of 3 times a week is asked about Sunday 6 September 2026
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about Monday 7 September 2026 answers that it is due

#### Scenario: a weekly quota is due on a leap day

- **WHEN** a schedule of 3 times a week is asked about 29 February 2028
- **THEN** the commitment is due on that date

#### Scenario: a weekly quota is due across the turn of a year

- **WHEN** a schedule of 3 times a week is asked about 31 December 2026
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 1 January 2027 answers that it is due

#### Scenario: a weekly quota is due on the first and last dates the system forms

- **WHEN** a schedule of 3 times a week is asked about 1 January 1583
- **THEN** the commitment is due on that date
- **AND** the same schedule asked about 31 December 9999 answers that it is due

### Requirement: A weekly quota is a number of times from one to seven

The system SHALL form a weekly quota only from a whole number of times from 1 through 7 inclusive,
and MUST refuse every other number rather than adjust it: zero MUST NOT be read as a commitment with
nothing to do, a negative number MUST NOT be read as any obligation, and a number above seven MUST
NOT be reduced to seven. No schedule SHALL be built on a number outside that range. A quota of
exactly seven SHALL be valid and SHALL mean one completion on each day of the week.

#### Scenario: a quota below one time a week is not a weekly quota

- **WHEN** the number 0 is offered as a number of times a week
- **THEN** no weekly quota is formed
- **AND** the number −1 offered as a number of times a week forms none either

#### Scenario: a quota of more times a week than the week has days is not a weekly quota

- **WHEN** the number 8 is offered as a number of times a week
- **THEN** no weekly quota is formed

#### Scenario: one time a week is a weekly quota

- **WHEN** the number 1 is offered as a number of times a week
- **THEN** a weekly quota of 1 time a week is formed

#### Scenario: seven times a week is a weekly quota

- **WHEN** the number 7 is offered as a number of times a week
- **THEN** a weekly quota of 7 times a week is formed

### Requirement: A calendar date gives back the year, the month and the day it names

A calendar date SHALL give back the three numbers it names, the year, the month and the day, and
SHALL give each back exactly as it was offered, unadjusted. The read-back SHALL be the inverse of
forming and SHALL lose nothing: a calendar date formed from the three numbers a formed one gives
back SHALL be formed and SHALL equal the one that gave them back. The three numbers SHALL be
readable and SHALL NOT be writable, and a different calendar date SHALL be had only by forming a new
one, judged the same way the first was.

#### Scenario: a calendar date gives back the three numbers it was formed from

- **WHEN** a calendar date is formed from the year 2026, the month August and the day 31
- **THEN** the year it gives back is 2026, the month it gives back is 8, and the day it gives back
  is 31

#### Scenario: a calendar date gives back its month and its day the way round they were offered

- **WHEN** a calendar date is formed from the year 2026, the month December and the day 1, and a
  second from the year 2026, the month January and the day 12
- **THEN** the first gives back the month 12 and the day 1
- **AND** the second gives back the month 1 and the day 12

#### Scenario: a calendar date at each end of the supported years gives back that year

- **WHEN** a calendar date is formed from the year 1583, the month January and the day 1, and a
  second from the year 9999, the month December and the day 31
- **THEN** the first gives back the year 1583, the month 1 and the day 1
- **AND** the second gives back the year 9999, the month 12 and the day 31

#### Scenario: a calendar date formed again from what it gives back is the same date

- **WHEN** a calendar date is formed for 29 February 2028, and a second calendar date is formed
  from the three numbers the first gives back
- **THEN** the second calendar date is formed
- **AND** the two are equal

### Requirement: A schedule says the rhythm it runs on in words

A schedule SHALL say the rhythm it runs on in words, its **rhythm in words**. It SHALL be read off
the schedule alone, consulting no calendar date, and SHALL be the same whatever day it is asked on,
whatever day it is asked about, and whether or not any commitment carries it. It SHALL say the shape
and its number and nothing else.

The words SHALL be this capability's own English and MUST NOT be taken from the device's language,
region, locale or calendar preferences. Every number SHALL be said in digits, with no grouping
separator and no leading zero. Two schedules that name the same rhythm SHALL say the same words, and
a weekday set of all seven and an interval of one day SHALL name the same rhythm. The system MUST
NOT decide whether two schedules name one rhythm from the dates they are due on.

#### Scenario: each of the four schedule shapes says the rhythm it runs on in words

- **WHEN** a schedule listing Monday, Wednesday and Saturday, a schedule on the 25th of the month, a
  schedule of every 14 days starting on 31 August 2026, and a schedule of 3 times a week are each
  said in words
- **THEN** they say "Mon, Wed, Sat", "The 25th", "Every 14 days" and "3x a week"

#### Scenario: two schedules that name the same rhythm say the same words

- **WHEN** a schedule listing all seven weekdays and a schedule of every 1 day starting on 31 August
  2026 are each said in words
- **THEN** both say "Every day"

#### Scenario: a number is said in digits with no grouping separator

- **WHEN** a schedule of every 1000 days starting on 31 August 2026 is said in words
- **THEN** it says "Every 1000 days"

### Requirement: A weekday-set schedule is said as its weekdays, in week order from Monday

A schedule that is a set of weekdays SHALL be said as the three-letter English names of the weekdays
it lists, "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" and "Sun", separated by a comma and a single
space. The names SHALL be in week order beginning at Monday, whatever order the set was built in and
whichever days it holds.

A set listing every weekday SHALL be said as "Every day" rather than as seven names. A set listing
no weekday SHALL have words like every other schedule, and SHALL be said as "No day".

#### Scenario: a weekday-set schedule says its weekdays as three-letter names

- **WHEN** a schedule listing Monday, Wednesday and Saturday is said in words
- **THEN** it says "Mon, Wed, Sat"

#### Scenario: a weekday-set schedule says its weekdays in week order from Monday

- **WHEN** a schedule listing Saturday, Monday and Wednesday is said in words, and a schedule
  listing Sunday and Monday is said in words
- **THEN** the first says "Mon, Wed, Sat"
- **AND** the second says "Mon, Sun", with Sunday last rather than first

#### Scenario: every weekday is said by its own three-letter name

- **WHEN** the seven schedules each listing exactly one weekday, from Monday through Sunday, are
  each said in words
- **THEN** they say "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" and "Sun"

#### Scenario: a weekday set listing every weekday is said as every day

- **WHEN** a schedule listing all seven weekdays is said in words
- **THEN** it says "Every day"

#### Scenario: a weekday set listing no weekday is said as no day

- **WHEN** a schedule listing no weekday at all is said in words
- **THEN** it says "No day"

### Requirement: An every-N-days schedule is said as its interval, and never as its start date

A schedule that is an interval of days SHALL be said as the word "Every", a space, the number of
days in digits, a space, and the word "days". An interval of one day SHALL be said as "Every day",
with no number and no plural, as *A schedule says the rhythm it runs on in words* says of two
schedules that name the same rhythm.

The start date MUST NOT be said in any form. Two schedules of the same interval and different start
dates SHALL say the same words.

#### Scenario: an every-N-days schedule says its interval in days

- **WHEN** a schedule of every 14 days starting on 31 August 2026 is said in words
- **THEN** it says "Every 14 days"

#### Scenario: an every-N-days schedule says the same words whatever its start date

- **WHEN** a schedule of every 14 days starting on 31 August 2026 and a schedule of every 14 days
  starting on 1 January 1583 are each said in words
- **THEN** both say "Every 14 days"
- **AND** neither says anything about the day it starts from

#### Scenario: an interval of one day is said as every day

- **WHEN** a schedule of every 1 day starting on 31 August 2026 is said in words
- **THEN** it says "Every day"

#### Scenario: an interval of two days says its number

- **WHEN** a schedule of every 2 days starting on 31 August 2026 is said in words
- **THEN** it says "Every 2 days"

### Requirement: A day-of-month schedule is said as the ordinal of its day

A schedule that is a day of the month SHALL be said as the word "The", a space, the day number in
digits, and that number's English ordinal suffix. The suffix SHALL be "st" for 1, 21 and 31, "nd"
for 2 and 22, "rd" for 3 and 23, and "th" for every other day from 1 through 31, the 11th, 12th and
13th included.

The words MUST NOT say the clamp onto a short month that *A month too short for the scheduled day is
due on its last day* describes, and SHALL be the same in every month of every year.

#### Scenario: a day-of-month schedule says its day as an ordinal

- **WHEN** a schedule on the 25th of the month is said in words
- **THEN** it says "The 25th"

#### Scenario: the eleventh, twelfth and thirteenth are said with th and not with st, nd and rd

- **WHEN** the schedules on the 11th, the 12th and the 13th of the month are each said in words
- **THEN** they say "The 11th", "The 12th" and "The 13th"
- **AND** the schedules on the 21st, the 22nd and the 23rd, said in words, say "The 21st", "The
  22nd" and "The 23rd"

#### Scenario: every day of the month from the first to the thirty-first is said as its own ordinal

- **WHEN** the thirty-one schedules on each day of the month from the 1st through the 31st are each
  said in words
- **THEN** they say "The 1st", "The 2nd", "The 3rd", "The 4th", "The 5th", "The 6th", "The 7th",
  "The 8th", "The 9th", "The 10th", "The 11th", "The 12th", "The 13th", "The 14th", "The 15th",
  "The 16th", "The 17th", "The 18th", "The 19th", "The 20th", "The 21st", "The 22nd", "The 23rd",
  "The 24th", "The 25th", "The 26th", "The 27th", "The 28th", "The 29th", "The 30th" and "The 31st"

#### Scenario: a day-of-month schedule does not say the clamp onto a short month

- **WHEN** a schedule on the 31st of the month is said in words
- **THEN** it says "The 31st"

### Requirement: A weekly-quota schedule is said as a number of times a week

A schedule that is a weekly quota SHALL be said as the number of times in digits, the letter "x"
with no space before it, a space, and the words "a week". Every number from one through seven SHALL
be said that way, with no special case at either end: one time a week MUST NOT be said as "Once a
week", and seven times a week MUST NOT be said as "Every day". A weekday set of all seven SHALL be
said as *A weekday-set schedule is said as its weekdays, in week order from Monday* says.

#### Scenario: a weekly-quota schedule says its number of times a week

- **WHEN** a schedule of 3 times a week is said in words
- **THEN** it says "3x a week"

#### Scenario: a weekly quota of seven times a week is not said as every day

- **WHEN** a schedule of 7 times a week is said in words
- **THEN** it says "7x a week"
- **AND** a schedule listing all seven weekdays, said in words, says "Every day" instead

#### Scenario: every number of times a week from one to seven is said in its own words

- **WHEN** the seven schedules of 1 through 7 times a week are each said in words
- **THEN** they say "1x a week", "2x a week", "3x a week", "4x a week", "5x a week", "6x a week"
  and "7x a week"
