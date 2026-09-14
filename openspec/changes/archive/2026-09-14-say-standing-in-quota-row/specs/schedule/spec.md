## ADDED Requirements

### Requirement: A schedule said given a count says a weekly quota's count before its words, and ignores it on every other shape

A schedule SHALL be said in words given a count, a whole number, as well as plainly. A weekly quota
said given a count SHALL be said as the count in digits, a slash with no space on either side, and
then the words it says plainly, so a count of one against three times a week SHALL be said as
"1/3x a week".

The count SHALL be said exactly as given and MUST NOT be judged against the quota, the week or any
range: a count of zero SHALL be said, a count above the quota SHALL NOT be capped, and a count below
zero or above seven SHALL be said as given, a negative count with a hyphen-minus before its digits.
A weekday set, a day of the month and an interval of days said given any count SHALL say exactly
the words each says plainly.

#### Scenario: a weekly quota said given a count says the count before its words

- **WHEN** a schedule of 3 times a week is said in words given a count of 1, a schedule of 7 times a
  week given a count of 0, and a schedule of 1 time a week given a count of 1
- **THEN** they say "1/3x a week", "0/7x a week" and "1/1x a week"

#### Scenario: a weekly quota said given a count above its quota says that count and caps nothing

- **WHEN** a schedule of 3 times a week is said in words given a count of 4
- **THEN** it says "4/3x a week"

#### Scenario: a weekly quota said given a count no week can hold says the count as given

- **WHEN** a schedule of 3 times a week is said in words given a count of 9, and given a count of -1
- **THEN** the first says "9/3x a week"
- **AND** the second says "-1/3x a week"

#### Scenario: a schedule that is not a weekly quota said given a count says its plain words

- **WHEN** a schedule listing Monday, Wednesday and Saturday, a schedule on the 25th of the month
  and a schedule of every 14 days starting on 31 August 2026 are each said in words given a count
  of 2
- **THEN** they say "Mon, Wed, Sat", "The 25th" and "Every 14 days"
- **AND** a schedule listing all seven weekdays and a schedule of every 1 day starting on 31 August
  2026, each said given a count of 0, both say "Every day"
- **AND** a schedule listing no weekday, said given a count of 1, says "No day"

## MODIFIED Requirements

### Requirement: A schedule says the rhythm it runs on in words

A schedule SHALL say the rhythm it runs on in words, its **rhythm in words**. It SHALL be read off
the schedule alone, consulting no calendar date, and SHALL be the same whatever day it is asked on,
whatever day it is asked about, and whether or not any commitment carries it. Said plainly, it SHALL
say the shape and its number and nothing else.

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
