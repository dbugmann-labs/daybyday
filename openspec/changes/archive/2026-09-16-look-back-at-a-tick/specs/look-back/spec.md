## Purpose

One commitment seen on its own, over everything since the day it was kept from: the page reached
from a commitment on the commitments screen, kept or stopped alike, which shows and enters nothing.
It is where a person reads how a commitment has gone, month by month, rather than what today asks.

## ADDED Requirements

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

A look-back at a commitment whose days take a tick SHALL say one line for each calendar month from
the month the commitment is kept from through the month of the last day it counts, newest month
first, leaving no month between the two out — a month the commitment is due on no day included.
Each month's line SHALL say that month in words and a **fraction**: the days of that month the
commitment was kept, out of the days of that month it was due, and never a percentage. A look-back
SHALL count only the days from the day the commitment is kept from through the last day it counts,
which SHALL be the day the commitment was kept until where the roster has stopped keeping it and
today otherwise. A look-back at a commitment kept from a day after today SHALL say no month line at
all.

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

A look-back SHALL say a **whole**: one fraction across every day it counts, the days kept out of the
days due, from the day the commitment is kept from through the last day it counts. The whole SHALL
be counted by the rule each month is counted by, so it SHALL say the sum of its months' kept days
out of the sum of their due days, and it SHALL never be a percentage. A look-back that counts no due
day at all SHALL say a whole of nothing out of nothing.

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

#### Scenario: a look-back that counts no due day at all says a whole of nothing out of nothing

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 April 2026, whose days take a tick, as of 15 March 2026
- **THEN** its whole says "0/0"

### Requirement: A look-back reads a commitment's earlier eras off the roster by resemblance

A look-back SHALL read a commitment's **chain** of **eras**. Behind a commitment stands the removed
commitment of the same name and the same kind whose day kept until is the day before that
commitment's day kept from; behind that one stands the same again, until none answers. Where more
than one removed commitment answers, the look-back SHALL take the one the roster holds nearest after
the era in front of it. A commitment the roster has not removed SHALL NOT be an earlier era, and a
look-back SHALL never reach one. A look-back SHALL count each day it counts against the era that
holds that day, SHALL say the newest era's rhythm in words, and SHALL say the earliest era's day
kept from as the day the commitment is kept from.

#### Scenario: a look-back counts the era behind the one it was asked about

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Tuesday and
  Thursday, kept from 4 March 2026, whose days take a tick, on a roster also holding removed a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026 and kept until 3 March 2026, whose days take a tick, kept on no day at all, as of 31 March
  2026
- **THEN** its lines are the months March 2026, February 2026 and January 2026
- **AND** the line for March 2026 says the fraction "0/9", the one day the older era was due
  through 3 March 2026 and the eight days the newer era was due from 4 March 2026

#### Scenario: a look-back says the newest era's rhythm and the earliest era's day kept from

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Tuesday and
  Thursday, kept from 4 March 2026, whose days take a tick, on a roster also holding removed a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026 and kept until 3 March 2026, whose days take a tick, as of 31 March 2026
- **THEN** it says the rhythm "Tue, Thu" and the day kept from "1 January 2026"

#### Scenario: a look-back chains every era behind the one it was asked about

- **WHEN** a look-back is asked for at the newest of three commitments named "Gym" whose days take
  a tick, the first kept from 1 January 2026 and kept until 31 January 2026, the second kept from 1
  February 2026 and kept until 28 February 2026, both held removed, and the third kept from 1 March
  2026, as of 31 March 2026
- **THEN** it says the day kept from "1 January 2026"
- **AND** its lines are the months March 2026, February 2026 and January 2026

#### Scenario: a removed commitment of another name or another kind is not an earlier era

- **WHEN** a look-back is asked for at a commitment named "Gym" kept from 4 March 2026 whose days
  take a tick, on a roster also holding removed a commitment named "Running" kept until 3 March
  2026 whose days take a tick, and one named "Gym" kept until 3 March 2026 whose days take a number
- **THEN** it says the day kept from "4 March 2026" and its one line is the month March 2026

#### Scenario: a removed commitment kept until any day but the day before is not an earlier era

- **WHEN** a look-back is asked for at a commitment named "Gym" kept from 4 March 2026 whose days
  take a tick, on a roster also holding removed a commitment named "Gym" whose days take a tick,
  kept from 1 January 2026 and kept until 2 March 2026
- **THEN** it says the day kept from "4 March 2026" and its one line is the month March 2026
- **AND** a removed commitment of that name and kind kept until 4 March 2026 is not an earlier era
  either

#### Scenario: a look-back takes the nearest of two removed commitments that both answer

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Tuesday and
  Thursday, kept from 4 March 2026, whose days take a tick, on a roster holding, immediately after
  it, a removed commitment named "Gym" kept from 1 February 2026 and kept until 3 March 2026, and
  after that one a removed commitment named "Gym" kept from 1 January 2026 and kept until 3 March
  2026, all three taking a tick
- **THEN** it says the day kept from "1 February 2026"
- **AND** its lines are the months March 2026 and February 2026

#### Scenario: an era the roster has taken up again is kept rather than removed and ends a chain

- **WHEN** a look-back is asked for at a commitment named "Gym" kept from 4 March 2026 whose days
  take a tick, on a roster keeping a commitment named "Gym" kept from 1 January 2026 whose days
  take a tick, which it had held removed and kept until 3 March 2026 before it was offered again
- **THEN** it says the day kept from "4 March 2026" and its one line is the month March 2026

### Requirement: A look-back says where the rhythm changed, between its months

A look-back SHALL say one line wherever one era of its chain gives way to the next: immediately
above the line of the month the newer era is kept from, saying the newer era's rhythm in words and
the day that era is kept from. It SHALL say one such line for each boundary between two eras, in the
same newest-first order its months are in, and SHALL say none at all for a chain of one era. Such a
line SHALL say nothing about the older era and SHALL say no fraction.

#### Scenario: a look-back says where the rhythm changed, above the month the newer era is kept from

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Tuesday and
  Thursday, kept from 4 March 2026, whose days take a tick, on a roster also holding removed a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026 and kept until 3 March 2026, whose days take a tick, as of 31 March 2026
- **THEN** its lines are, in order, a line where the rhythm changed saying "Tue, Thu" and "4 March
  2026", then the month March 2026, then February 2026, then January 2026

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

### Requirement: A look-back says no fraction for a kind other than a tick, or for a weekly quota

A look-back at a commitment whose days take a number, a note or a total SHALL say no line at all and
SHALL say no whole. A look-back at a commitment whose days take a tick SHALL say no fraction on the
line of any month an era of its chain running on a weekly quota counts a day of, and SHALL say no
whole where any era of its chain runs on a weekly quota. It SHALL still say those months' lines in
words, in their place and their order, and SHALL still say every line where the rhythm changed.

#### Scenario: a look-back at a commitment whose days take a number, a note or a total says no line and no whole

- **WHEN** a look-back is asked for at a commitment named "Weight" kept from 1 January 2026 whose
  days take a number, as of 15 March 2026
- **THEN** it says the name, the rhythm and the day kept from, says no line at all and says no whole
- **AND** a look-back at a commitment whose days take a note, and one at a commitment whose days
  take a total, each say the same

#### Scenario: a look-back at a weekly quota says its months with no fraction and no whole

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule of three times a
  week, kept from 1 January 2026, whose days take a tick, as of 15 March 2026
- **THEN** its lines are the months March 2026, February 2026 and January 2026, each saying no
  fraction
- **AND** it says no whole

#### Scenario: a look-back says no fraction on a month a weekly-quota era counts a day of

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Tuesday and
  Thursday, kept from 4 March 2026, whose days take a tick, on a roster also holding removed a
  commitment named "Gym" on a schedule of three times a week, kept from 1 January 2026 and kept
  until 3 March 2026, whose days take a tick, as of 30 April 2026
- **THEN** the lines for March 2026, February 2026 and January 2026 each say no fraction, and the
  line for April 2026 says its own
- **AND** it says no whole

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
