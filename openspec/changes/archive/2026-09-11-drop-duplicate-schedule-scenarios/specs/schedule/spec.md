## MODIFIED Requirements

### Requirement: A calendar date names a day that exists

A calendar date SHALL be a year, a month of that year and a day of that month. The system SHALL form
one from a combination of the three naming a day, in a year *A calendar date is formed only within
the years the system supports* accepts, and SHALL refuse to form one naming no day. It MUST refuse
rather than adjust: a day past the end of its month MUST NOT become a day of the following month,
and a month past the twelfth MUST NOT become a month of the following year. No schedule SHALL be
asked about a date that does not exist.

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

## REMOVED Requirements

### Requirement: A calendar date lies within the years the system supports

**Reason**: Added back below as *A calendar date is formed only within the years the system
supports*, without a scenario another under it already asserts; no behaviour changes.
**Migration**: `a date before the Gregorian calendar's adoption is not a calendar date` is dropped
and its test deleted; every other scenario is carried verbatim.

### Requirement: A weekday-set schedule is said as its weekdays, in week order from Monday

**Reason**: Added back below as *A weekday-set schedule is said as the weekdays it lists, in week
order from Monday*, without a scenario another under it already asserts; no behaviour changes.
**Migration**: `a weekday-set schedule says its weekdays as three-letter names` is dropped and its
test deleted; every other scenario is carried verbatim.

### Requirement: An every-N-days schedule is said as its interval, and never as its start date

**Reason**: Added back below as *An every-N-days schedule is said as its interval of days, and never
as its start date*, without a scenario another under it already asserts; no behaviour changes.
**Migration**: `an every-N-days schedule says its interval in days` is dropped and its test deleted;
every other scenario is carried verbatim.

### Requirement: A day-of-month schedule is said as the ordinal of its day

**Reason**: Added back below as *A day-of-month schedule is said as the ordinal of its day of the
month*, without scenarios another under it already asserts; no behaviour changes.
**Migration**: `a day-of-month schedule says its day as an ordinal` and `the eleventh, twelfth and
thirteenth are said with th and not with st, nd and rd` are dropped and their tests deleted; every
other scenario is carried verbatim.

### Requirement: A weekly-quota schedule is said as a number of times a week

**Reason**: Added back below as *A weekly-quota schedule is said as its number of times a week*,
without a scenario another under it already asserts; no behaviour changes.
**Migration**: `a weekly-quota schedule says its number of times a week` is dropped and its test
deleted; every other scenario is carried verbatim.

## ADDED Requirements

### Requirement: A calendar date is formed only within the years the system supports

The system SHALL form a calendar date only for a year from 1583 through 9999 inclusive, and SHALL
refuse every year outside that range even when the three components name a day that plainly exists.
It MUST refuse such a year rather than adjust it: a year outside the range MUST NOT be clamped to
the nearest supported year, and no schedule SHALL be asked about a date the system declines to form.
This requirement SHALL bound the year alone, and the month and the day SHALL be bounded as *A
calendar date names a day that exists* says.

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

### Requirement: A weekday-set schedule is said as the weekdays it lists, in week order from Monday

A schedule that is a set of weekdays SHALL be said as the three-letter English names of the weekdays
it lists, "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" and "Sun", separated by a comma and a single
space. The names SHALL be in week order beginning at Monday, whatever order the set was built in and
whichever days it holds.

A set listing every weekday SHALL be said as "Every day" rather than as seven names. A set listing
no weekday SHALL have words like every other schedule, and SHALL be said as "No day".

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

### Requirement: An every-N-days schedule is said as its interval of days, and never as its start date

A schedule that is an interval of days SHALL be said as the word "Every", a space, the number of
days in digits, a space, and the word "days". An interval of one day SHALL be said as "Every day",
with no number and no plural, as *A schedule says the rhythm it runs on in words* says of two
schedules that name the same rhythm.

The start date MUST NOT be said in any form. Two schedules of the same interval and different start
dates SHALL say the same words.

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

### Requirement: A day-of-month schedule is said as the ordinal of its day of the month

A schedule that is a day of the month SHALL be said as the word "The", a space, the day number in
digits, and that number's English ordinal suffix. The suffix SHALL be "st" for 1, 21 and 31, "nd"
for 2 and 22, "rd" for 3 and 23, and "th" for every other day from 1 through 31, the 11th, 12th and
13th included.

The words MUST NOT say the clamp onto a short month that *A month too short for the scheduled day is
due on its last day* describes, and SHALL be the same in every month of every year.

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

### Requirement: A weekly-quota schedule is said as its number of times a week

A schedule that is a weekly quota SHALL be said as the number of times in digits, the letter "x"
with no space before it, a space, and the words "a week". Every number from one through seven SHALL
be said that way, with no special case at either end: one time a week MUST NOT be said as "Once a
week", and seven times a week MUST NOT be said as "Every day". A weekday set of all seven SHALL be
said as *A weekday-set schedule is said as the weekdays it lists, in week order from Monday* says.

#### Scenario: a weekly quota of seven times a week is not said as every day

- **WHEN** a schedule of 7 times a week is said in words
- **THEN** it says "7x a week"
- **AND** a schedule listing all seven weekdays, said in words, says "Every day" instead

#### Scenario: every number of times a week from one to seven is said in its own words

- **WHEN** the seven schedules of 1 through 7 times a week are each said in words
- **THEN** they say "1x a week", "2x a week", "3x a week", "4x a week", "5x a week", "6x a week"
  and "7x a week"
