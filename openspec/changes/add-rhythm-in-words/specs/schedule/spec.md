## ADDED Requirements

### Requirement: A schedule says the rhythm it runs on in words

A schedule SHALL say, in words, the rhythm it runs on. That answer is its **rhythm in words**, and
it is read off the schedule and off nothing else: no calendar date is asked for and none is
consulted, so a schedule says the same words whatever day it is asked on, whatever day it is asked
about, and whether or not any commitment carries it.

It SHALL say the shape and its number and nothing else. In particular an every-N-days schedule
MUST NOT say its start date, and a day-of-month schedule MUST NOT say that a month too short for
its day is due on that month's last day — both are true of the schedule and neither is part of the
rhythm a person reads beside a name. The four requirements below fix the words for each shape.

The words SHALL be this capability's own — the English fixed here — and MUST NOT be taken from the
device's language, region, locale or calendar preferences, exactly as a day title's words are not
(ADR-1022). The same schedule is said in the same words on every device, which is what makes a
rhythm in words something a scenario can state at all. Every number SHALL be said in digits, with
no grouping separator and no leading zero, which is the same rule stated of the part a formatter
would otherwise decide.

Two schedules that name the same rhythm SHALL say the same words: a weekday set of all seven and
an interval of one day are both said as "Every day", because they are one rhythm written two ways.
This is a rule about the *rhythm* and not about which dates the schedule is due on. A weekly quota
of seven times a week is due on exactly the same dates as those two and is a different rhythm — it
asks for seven days in any week rather than for every day — so it is said in its own words and not
as "Every day".

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

A schedule that is a set of weekdays SHALL be said as the three-letter English names of the
weekdays it lists — "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" — separated by a comma and a
single space: "Mon, Wed, Sat". The names SHALL be in week order beginning at Monday, whatever order
the set was built in and whichever days it holds; a weekday set is a set and carries no order of
its own, so the order is this capability's and Monday is where it starts.

A set listing every weekday SHALL be said as "Every day" rather than as seven names, which is what
a person means by it. A set listing no weekday SHALL be said as "No day". The empty set is a
schedule the system forms and a roster can hold — it is due on no date, and this capability accepts
it rather than treating it as an error — so it has words like every other schedule, even though a
commitments screen refuses to define a commitment on one (ADR-1028). Saying nothing at all for it
would leave an entry that reads as though its rhythm were missing rather than empty.

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
days in digits, a space, and the word "days" — "Every 14 days". An interval of one day SHALL be
said as "Every day", with no number and no plural, which is the same rhythm a weekday set of all
seven names and therefore the same words.

The start date MUST NOT be said, in any form. Two schedules of the same interval and different
start dates SHALL say the same words. This is the rule rather than an omission: on every commitment
a commitments screen makes, the start date is the day the commitment is kept from, so a start date
said beside a name would repeat a day the person already chose. A commitment formed some other way
may carry a start date that disagrees with the day it is kept from, and its rhythm in words says
neither — what the words say is the interval.

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
digits, and that number's English ordinal suffix — "The 25th". The suffix SHALL be "st" for 1, 21
and 31, "nd" for 2 and 22, "rd" for 3 and 23, and "th" for every other day from 1 through 31. The
eleventh, twelfth and thirteenth take "th" although they end in 1, 2 and 3, which is the one place
a rule written from the last digit alone gets English wrong.

The rule that a month too short for the scheduled day is due on that month's last day MUST NOT be
said. "The 31st" is said as "The 31st" in every month of every year, and the words say nothing
about February. The clamp is a fact about which dates the schedule is due on, and a rhythm in words
says the rhythm a person chose.

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
with no space before it, a space, and the words "a week" — "3x a week". Every number from one
through seven SHALL be said that way, with no special case at either end: one time a week is said
as "1x a week" and not as "Once a week", and seven times a week is said as "7x a week".

Seven times a week is deliberately not said as "Every day". A quota of seven is due on every date,
as a weekday set of all seven is (ADR-1015), but it asks for seven completions in a week on any
days of it rather than for one on each day, and a person reading "Every day" beside a name would
read an obligation the schedule does not carry.

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
