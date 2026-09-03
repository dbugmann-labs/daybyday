## ADDED Requirements

### Requirement: A day view says its day as a weekday and a date, and says Today on the day it is asked as of

A day view SHALL say the day it is of, in words, when it is asked as of a day. That answer is its
**day title**, and it is read off the day view's date and off the day it is asked as of, and off
nothing else: it MUST NOT depend on the rows the day view holds, on whether any of them says its
commitment is kept, or on how many there are, so a day view holding no rows at all says its day
exactly as one holding seven does.

The date SHALL be said as four things in this order, separated by single spaces: the name of the
weekday, the day of the month as a number with no leading zero, the name of the month, and the year
as four digits — "Monday 31 August 2026". On the day it is asked as of, and on no other day, the
word "Today" SHALL be said in front of that date, separated from it by a space, a middle dot and a
space — "Today · Thursday 3 September 2026". The day it is asked as of SHALL decide that and nothing
else: no other day is named in words, so the day before is said as its date exactly as the day after
is, and the date itself is said the same way whatever day the question is asked as of.

The names of the weekdays and of the months SHALL be this capability's own — the English names,
fixed here — and MUST NOT be taken from the device's language, region, locale or calendar
preferences. The same day is said in the same words on every device, which is what makes a day title
something a test can state at all. As throughout this capability, the question is asked *of a date*:
this capability MUST NOT read a clock and MUST NOT consult the present moment or the device's time
zone, so a day title is answered for every date the system supports and a past day's title reads
tomorrow exactly as it does now.

#### Scenario: a day view says its day as a weekday, a day of the month, a month and a year

- **WHEN** a day view of Monday 31 August 2026 is asked what its day is as of Thursday 3 September
  2026
- **THEN** it says "Monday 31 August 2026"

#### Scenario: a day view of the day it is asked as of says Today before the date

- **WHEN** a day view of Thursday 3 September 2026 is asked what its day is as of Thursday
  3 September 2026
- **THEN** it says "Today · Thursday 3 September 2026"

#### Scenario: a day view of a day before the one it is asked as of says the date and not Today

- **WHEN** a day view of Wednesday 2 September 2026 is asked what its day is as of Thursday
  3 September 2026
- **THEN** it says "Wednesday 2 September 2026"

#### Scenario: a day view of a day after the one it is asked as of says the date and not Today

- **WHEN** a day view of Friday 4 September 2026 is asked what its day is as of Thursday 3 September
  2026
- **THEN** it says "Friday 4 September 2026"

#### Scenario: a day of the month below ten is said without a leading zero

- **WHEN** a day view of Tuesday 1 September 2026 is asked what its day is as of Thursday
  3 September 2026
- **THEN** it says "Tuesday 1 September 2026"

#### Scenario: every weekday is said by its own name

- **WHEN** the day views of the seven days from Monday 31 August 2026 to Sunday 6 September 2026 are
  each asked what their day is as of Thursday 1 January 2026
- **THEN** they say "Monday 31 August 2026", "Tuesday 1 September 2026", "Wednesday 2 September
  2026", "Thursday 3 September 2026", "Friday 4 September 2026", "Saturday 5 September 2026" and
  "Sunday 6 September 2026"

#### Scenario: every month is said by its own name

- **WHEN** the day views of the fifteenth day of each of the twelve months of 2026 are each asked
  what their day is as of Thursday 1 January 2026
- **THEN** they say "Thursday 15 January 2026", "Sunday 15 February 2026", "Sunday 15 March 2026",
  "Wednesday 15 April 2026", "Friday 15 May 2026", "Monday 15 June 2026", "Wednesday 15 July 2026",
  "Saturday 15 August 2026", "Tuesday 15 September 2026", "Thursday 15 October 2026", "Sunday
  15 November 2026" and "Tuesday 15 December 2026"

#### Scenario: a day view says its day in the first supported year and in the last

- **WHEN** a day view of Saturday 1 January 1583 is asked what its day is as of Monday 3 January
  1583
- **THEN** it says "Saturday 1 January 1583"
- **AND** a day view of Friday 31 December 9999 asked as of Monday 27 December 9999 says "Friday
  31 December 9999"

#### Scenario: a day view says the leap day of a leap year

- **WHEN** a day view of Tuesday 29 February 2028 is asked what its day is as of Monday 28 February
  2028
- **THEN** it says "Tuesday 29 February 2028"

#### Scenario: a day view holding no rows says its day just the same

- **WHEN** a day view of no commitments at all on Wednesday 2 September 2026 is asked what its day
  is as of Thursday 3 September 2026
- **THEN** it holds no rows
- **AND** it says "Wednesday 2 September 2026"

### Requirement: A day screen says the day it is showing, as of the day it was handed

A day screen SHALL say the day it is showing, and that SHALL be its day view's day title asked as of
the day the screen was handed. It adds nothing to that answer and takes nothing away: the words are
the requirement above, and the only thing a day screen contributes is the day the question is asked
as of, which is the one it holds and is the one thing here that is not on the screen already.

That day SHALL be the one the screen was handed and never one it went looking for. A day screen MUST
NOT read a clock to say its day, so a screen handed a day says that day whatever day it really is,
and it says the same day until the app is shown again — a tick made on it MUST NOT change what it
says the day is, and neither MUST time passing.

A day screen SHALL say its day whether or not it is keeping a record. What a date asks of a person
needs no record to answer, so a screen that could not read one says its day exactly as a screen that
did.

#### Scenario: a day screen says the day it is showing

- **WHEN** a day screen is opened as of Thursday 3 September 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026
- **THEN** it says the day is "Today · Thursday 3 September 2026"

#### Scenario: a day screen says the day it was handed rather than the day it really is

- **WHEN** a day screen is opened as of Monday 3 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583
- **THEN** it says the day is "Today · Monday 3 January 1583"
- **AND** a day screen opened the same way as of Monday 27 December 9999 says the day is "Today ·
  Monday 27 December 9999"

#### Scenario: a day screen says the day its own day view says, asked as of the day it was handed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026
- **THEN** what it says the day is is what its day view says when that day view is asked as of Monday
  31 August 2026

#### Scenario: a day screen shown again on a later day says that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the app is then shown again as of Tuesday 1 September 2026
- **THEN** it says the day is "Today · Tuesday 1 September 2026"

#### Scenario: a day screen that cannot read its record still says the day

- **WHEN** a day screen is opened as of Monday 31 August 2026, of a commitment named "Journaling" on
  a schedule listing all seven weekdays, kept from 1 January 2026, at a place holding a run of bytes
  that is not a record
- **THEN** it says it is not keeping a record
- **AND** it says the day is "Today · Monday 31 August 2026"

#### Scenario: a day screen says the same day after a tick is made on it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and its one row is ticked
- **THEN** it says the day is "Today · Monday 31 August 2026", exactly as it did before the tick
