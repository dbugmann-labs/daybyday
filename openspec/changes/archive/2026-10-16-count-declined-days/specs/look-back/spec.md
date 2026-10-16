## ADDED Requirements

### Requirement: A look-back counts the days declined since the day the commitment is kept from

A look-back at a commitment of any kind SHALL say a **declined count**: how many of the days it
counts, from the day the commitment is kept from through the last day it counts, hold a decline of
that commitment on a day the era holding it is due on and does not run on a weekly quota. It SHALL
count no other decline, one on a day of a gap or after the last day it counts included. It SHALL
say the count as a look-back says a number, and SHALL say no declined count where it counts none. A
declined day SHALL stay among the due days of every fraction and out of its kept days. A graph SHALL
say a declined day as it says a day holding nothing, and a look-back SHALL say no decline's reason.

#### Scenario: a look-back counts every day declined since the day it is kept from, and its whole still counts them due and unkept

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, whose days take a tick, kept on eleven days of
  February 2026 and declined on 7 January, 4 March, 7 March and 9 March 2026, holding no other
  record, as of 15 March 2026
- **THEN** its declined count says "4"
- **AND** its whole says "11/31"

#### Scenario: a number commitment's look-back counts a day declined however long ago, and its graph says no point on one

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 January 2026, whose days take a number, holding 72.5 on 1 March 2026 and declined on
  2 January 2026 and 10 March 2026, holding no other record, as of 15 March 2026
- **THEN** its declined count says "2"
- **AND** its graph says one point, "72.5" on 1 March 2026, and its average over a month says "72.5"
- **AND** a look-back at a commitment named "Protein" on a schedule listing every day, kept from 1
  March 2026, whose days take a total with a target of 120, holding an addition of 150 on 1 March
  2026 and declined on 3 March 2026, as of 5 March 2026, says the declined count "1" and one point
- **AND** a look-back at a commitment named "Journal" on a schedule listing every day, kept from 1
  March 2026, whose days take a note, holding "Quiet day." on 1 March 2026 and declined on 3 March
  2026, as of 5 March 2026, says the declined count "1", one note and the count "1 note"

#### Scenario: a look-back that says no graph or no note still counts its declined days

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number, holding no number and declined on 3 March 2026,
  as of 5 March 2026
- **THEN** it says no graph, and its declined count says "1"
- **AND** a look-back at a commitment named "Journal" on a schedule listing every day, kept from 1
  March 2026, whose days take a note, holding no note and declined on 3 March 2026, as of 5 March
  2026, says no note and no count of notes, and its declined count says "1"

#### Scenario: a look-back counts no decline on a day it does not count due

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026 and kept until 28 February 2026, whose days take
  a tick, declined on 4 March 2026 and on no other day, as of 15 March 2026
- **THEN** it says no declined count, and no line says one
- **AND** a look-back at a commitment named "Gym" whose days take a tick, whose earlier era ran on
  a schedule listing Monday, Wednesday and Saturday from 1 January 2026 until 31 January 2026 and
  whose newest runs on that schedule from 1 April 2026, holding a decline of its earlier era on
  4 February 2026, as of 15 April 2026, says no declined count
- **AND** so does one whose earlier era ran on that schedule from 1 January 2026 until 3 March 2026
  and whose newest runs on a schedule listing Tuesday and Thursday from 4 March 2026, holding a
  decline of its earlier era on 4 March 2026, as of 31 March 2026
- **AND** so does one whose earlier era ran on that schedule from 1 January 2026 until 3 March 2026
  and whose newest runs on a schedule of three times a week from 4 March 2026, holding a decline of
  its earlier era on 7 March 2026, as of 15 March 2026

#### Scenario: a look-back that counts no declined day says no declined count

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, whose days take a tick, kept on eleven days of
  February 2026 and on no other day, holding no decline, as of 15 March 2026
- **THEN** it says no declined count, and no line says one
- **AND** alike, one declined on 4 March 2026 and then given a tick on that day says no declined
  count, and its line for March 2026 says the fraction "1/6"
- **AND** a look-back at such a commitment kept from 1 April 2026 says no declined count

### Requirement: A tick commitment's month line says how many of its days were declined

A tick commitment's look-back SHALL say a declined count on each month line whose days hold a day
it counts declined, as *A look-back counts the days declined since the day the commitment is kept
from* counts one: that number, said as a look-back says a number, a single space and the word
"declined", which SHALL take no plural. A month line whose days hold no such day SHALL say no
declined count, and a week line SHALL say no declined count at all. The declined counts a
look-back's month lines say SHALL sum to its declined count.

#### Scenario: a month line says how many of its days were declined beside its fraction

- **WHEN** a look-back is asked for at a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, whose days take a tick, kept on eleven days of
  February 2026 and declined on 7 January, 4 March, 7 March and 9 March 2026, holding no other
  record, as of 15 March 2026
- **THEN** its line for March 2026 says the fraction "0/6" and the declined count "3 declined"
- **AND** its line for January 2026 says the fraction "0/13" and the declined count "1 declined"
- **AND** its line for February 2026 says the fraction "11/12" and no declined count

#### Scenario: a declined day in a week a week line says is counted on its month line, and no week line says a declined count

- **WHEN** a look-back is asked for at a commitment named "Gym" whose days take a tick, whose
  earlier era ran on a schedule of three times a week from 23 February 2026 until 3 March 2026 and
  whose newest runs on a schedule listing Monday, Wednesday and Saturday from 4 March 2026, kept on
  23, 25 and 27 February 2026, on 2 March 2026 and on 7 and 9 March 2026, and declined on 4 March
  2026, as of 15 March 2026
- **THEN** its lines are, in order, the month "March 2026" saying "2/5" and the declined count "1
  declined", the week "2–8 Mar 2026" saying "1/1" and the week "23 Feb – 1 Mar 2026" saying "3/3"
- **AND** neither week says a declined count, and the look-back's declined count says "1"
