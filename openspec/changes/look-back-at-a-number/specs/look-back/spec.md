## ADDED Requirements

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

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 4 March 2026, whose days take a number, on a roster also holding removed a commitment
  named "Weight" on a schedule listing Monday, kept from 2 March 2026 and kept until 3 March 2026,
  whose days take a number, the older era holding 80 on 2 March 2026 and the newer holding 70 on 4
  March 2026, as of 4 March 2026
- **THEN** its graph says two points, the first saying "80" on 2 March 2026 and the second "70" on 4
  March 2026

### Requirement: A number commitment's graph runs from the day it is kept from through the last day it counts

A graph SHALL say one day for each calendar day from the earliest era of the chain's day kept from
through the last day the look-back counts, oldest first, each said as a day; the last day it counts
SHALL be the day the commitment was kept until where the roster has stopped keeping it and today
otherwise. A graph SHALL also say one month for each calendar month holding one of those days,
oldest first, each saying that month and the place among those days of the first of its days. Every
point and every rule a graph says SHALL name the place of its own day among those days. A graph
SHALL say no point for a number the record holds on a day after the last day the look-back counts.

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
  kept from 4 March 2026, whose days take a number between 1 and 5, on a roster also holding removed
  a commitment named "Mood" on a schedule listing every day, kept from 1 March 2026 and kept until 3
  March 2026, whose days take a number between 1 and 10, the older era holding 8 on 2 March 2026 and
  the newer holding 4 on 4 March 2026, as of 4 March 2026
- **THEN** its graph says the lowest "1" and the highest "8"

### Requirement: A number commitment's graph says a rule where one era gives way to the next

A graph SHALL say one **rule** for each boundary between two eras of the look-back's chain, in the
same newest-first order the look-back's chain is read in, and SHALL say none at all for a chain of
one era. Each rule SHALL name the place among the graph's days of the newer era's day kept from, and
SHALL say the newer era's rhythm in words and the day that era is kept from. A rule SHALL say
nothing about the older era and no value.

#### Scenario: a number commitment's graph says a rule where the rhythm changed

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing Tuesday and
  Thursday, kept from 4 March 2026, whose days take a number, on a roster also holding removed a
  commitment named "Weight" on a schedule listing every day, kept from 1 March 2026 and kept until 3
  March 2026, whose days take a number, holding 72.5 on 2 March 2026, as of 8 March 2026
- **THEN** its graph says one rule, saying "Tue, Thu" and "4 March 2026" and naming the fourth of
  its days

#### Scenario: a number commitment's graph of one era says no rule

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number, holding 72.5 on 2 March 2026, on a roster
  holding no removed commitment at all, as of 5 March 2026
- **THEN** its graph says no rule at all

#### Scenario: a number commitment's graph of three eras says one rule for each boundary

- **WHEN** a look-back is asked for at the newest of three commitments named "Weight" whose days take
  a number, the first on a schedule listing every day kept from 1 March 2026 and kept until 2 March
  2026, the second on a schedule listing Tuesday kept from 3 March 2026 and kept until 4 March 2026,
  both held removed, and the third on a schedule listing Wednesday kept from 5 March 2026, holding
  72.5 on 1 March 2026, as of 8 March 2026
- **THEN** its graph says two rules, the first saying "Wed" and "5 March 2026" and naming the fifth
  of its days, the second saying "Tue" and "3 March 2026" and naming the third

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

## REMOVED Requirements

### Requirement: A look-back at a commitment whose days take a number, a note or a total says no line

**Reason**: A number's page now says a graph of the numbers its days hold, so the three kinds no
longer answer alike. Replaced by *A look-back at a commitment whose days take a note or a total says
no line*, which says of those two kinds everything this one said, and adds that they say no graph.

**Migration**: None. Nothing outside this capability reads it.
