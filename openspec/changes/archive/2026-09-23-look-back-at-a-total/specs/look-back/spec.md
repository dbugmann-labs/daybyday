## ADDED Requirements

### Requirement: A total commitment's look-back says a graph of the sums its days hold

A look-back at a commitment whose days take a total SHALL say a **graph**, and SHALL say no line
and no whole. The graph SHALL say one **point** for each day the look-back counts that holds an
addition: that day's sum, as a value, and the day it was kept on. The sum a day holds SHALL be the
one the record holds for the era that holds that day. The graph SHALL say its points oldest first,
SHALL say nothing at all about a day that holds no addition, and SHALL say its days and its months
by the rule a number commitment's graph says them by. Where no day it counts holds an addition, the
look-back SHALL say no graph at all, and SHALL still say the commitment's name, its rhythm in
words, the day it is kept from and any day it was kept until.

#### Scenario: a total commitment's look-back says a point for each day that holds an addition

- **WHEN** a look-back is asked for at a commitment named "Protein" on a schedule listing every
  day, kept from 1 March 2026, whose days take a total with a target of 120, holding additions of
  100 and 50 on 1 March 2026, 87.5 on 3 March 2026 and 120 on 4 March 2026 and no addition on any
  other day, as of 5 March 2026
- **THEN** its graph says three points, the first at the sum 150 on 1 March 2026, the second at
  87.5 on 3 March 2026 and the third at 120 on 4 March 2026
- **AND** its graph says nothing at all about 2 March 2026 and 5 March 2026
- **AND** its graph says five days, "1 March 2026" first and "5 March 2026" last
- **AND** the look-back says no line at all and no whole

#### Scenario: a total commitment's look-back says no graph where no day holds an addition

- **WHEN** a look-back is asked for at a commitment named "Protein" on a schedule listing every
  day, kept from 1 March 2026, whose days take a total with a target of 120, holding no addition at
  all, as of 5 March 2026
- **THEN** it says no graph, no line at all and no whole
- **AND** it says the name "Protein", the rhythm and the day kept from "1 March 2026" as any other
  look-back does
- **AND** a look-back at such a commitment whose one addition, of 50 on 3 March 2026, was taken
  back says no graph either

#### Scenario: a total commitment's look-back says the sum the era holding a day kept

- **WHEN** a look-back is asked for at a commitment named "Protein" whose days take a total, whose
  earlier era ran on a schedule listing every day with a target of 120 from 1 March 2026 until 3
  March 2026 and whose newest runs on a schedule listing every day with a target of 100 from 4 March
  2026, the older era holding an addition of 90 on 2 March 2026 and the newer one of 110 on 5 March
  2026, as of 5 March 2026
- **THEN** its graph says two points, the first at the sum 90 on 2 March 2026 and the second at 110
  on 5 March 2026

### Requirement: A total commitment's graph marks each point kept or not, and says it as its sum of its target

Each point of a total commitment's graph SHALL say whether it is **kept**. A point SHALL be kept
where its sum reaches the **target** of the era holding its day, exactly or past it, and SHALL NOT
be kept where its sum falls short of that target. The target a point is judged against SHALL be
that era's and never the newest era's where the two differ. Each point SHALL be said in words as
its sum, a single space, the word "of", a single space and that target, the sum and the target
each said as a look-back says a number.

#### Scenario: a total commitment's graph marks a point kept where its sum passes its target, and not where it falls short

- **WHEN** a look-back is asked for at a commitment named "Protein" on a schedule listing every
  day, kept from 1 March 2026, whose days take a total with a target of 120, holding 150 on 1 March
  2026 and 87.5 on 3 March 2026 and no addition on any other day, as of 5 March 2026
- **THEN** its point on 1 March 2026 says "150 of 120" and is kept
- **AND** its point on 3 March 2026 says "87.5 of 120" and is not kept

#### Scenario: a total commitment's graph marks a point kept where its sum reaches its target exactly

- **WHEN** a look-back is asked for at a commitment named "Protein" on a schedule listing every
  day, kept from 1 March 2026, whose days take a total with a target of 120, holding additions of
  100 and 20 on 4 March 2026 and no addition on any other day, as of 5 March 2026
- **THEN** its one point says "120 of 120" and is kept

#### Scenario: a total commitment's graph judges each point against the target the era holding its day declared

- **WHEN** a look-back is asked for at a commitment named "Protein" whose days take a total, whose
  earlier era ran on a schedule listing every day with a target of 120 from 1 March 2026 until 3
  March 2026 and whose newest runs on a schedule listing every day with a target of 100 from 4 March
  2026, the older era holding an addition of 110 on 2 March 2026 and the newer one of 110 on 5 March
  2026, as of 5 March 2026
- **THEN** its point on 2 March 2026 says "110 of 120" and is not kept
- **AND** its point on 5 March 2026 says "110 of 100" and is kept

### Requirement: A total commitment's graph says a target rule across the whole of its days

A total commitment's graph SHALL say a **target rule**: the target each of its days was owed,
which SHALL be the target of the era holding that day. The rule SHALL say one stretch for each run
of consecutive days owed one target, oldest first, and its stretches together SHALL cover every day
the graph says, from the first through the last, a day holding no addition included. Each stretch
SHALL say the place among the graph's days of its first day and of its last, and its target as a
value and in words, said as a look-back says a number. A number commitment's graph SHALL say no
target rule.

#### Scenario: a total commitment's target rule runs across every day of its graph, a day holding no addition included

- **WHEN** a look-back is asked for at a commitment named "Protein" on a schedule listing every
  day, kept from 1 March 2026, whose days take a total with a target of 120, holding 150 on 3 March
  2026 and no addition on any other day, as of 5 March 2026
- **THEN** its target rule says one stretch, from the first of its five days through the fifth,
  saying "120"
- **AND** a look-back at a commitment named "Weight" on a schedule listing every day, kept from 1
  March 2026, whose days take a number, holding 72.5 on 1 March 2026, as of 5 March 2026, says a
  graph with no target rule

#### Scenario: a total commitment's target rule steps where the target changed

- **WHEN** a look-back is asked for at a commitment named "Protein" whose days take a total, whose
  earlier era ran on a schedule listing every day with a target of 120 from 1 March 2026 until 3
  March 2026 and whose newest runs on a schedule listing every day with a target of 100 from 4 March
  2026, the older era holding an addition of 90 on 2 March 2026 and the newer one of 110 on 5 March
  2026, as of 8 March 2026
- **THEN** its target rule says two stretches, the first from the first of its eight days through
  the third saying "120", and the second from the fourth through the eighth saying "100"

### Requirement: A total commitment's graph runs its values from zero to its greatest sum or target

A total commitment's graph SHALL say a lowest value of zero, and a highest value that is the
greatest of every sum its points say and every target its target rule says, each bound as a value
and said in words as a look-back says a number. It SHALL say no value between them. Neither bound
SHALL be taken from the least sum its points say, and the highest SHALL NOT be taken from the
newest era's target alone where an older era's target is greater.

#### Scenario: a total commitment's graph runs from zero to its greatest sum where a sum passes every target

- **WHEN** a look-back is asked for at a commitment named "Protein" on a schedule listing every
  day, kept from 1 March 2026, whose days take a total with a target of 120, holding 150 on 1 March
  2026 and 87.5 on 3 March 2026 and no addition on any other day, as of 5 March 2026
- **THEN** its graph says the lowest "0" and the highest "150"

#### Scenario: a total commitment's graph runs from zero to its greatest target where every sum falls short

- **WHEN** a look-back is asked for at a commitment named "Protein" whose days take a total, whose
  earlier era ran on a schedule listing every day with a target of 120 from 1 March 2026 until 3
  March 2026 and whose newest runs on a schedule listing every day with a target of 100 from 4 March
  2026, the older era holding an addition of 30 on 2 March 2026 and the newer one of 40 on 5 March
  2026, as of 5 March 2026
- **THEN** its graph says the lowest "0" and the highest "120"

### Requirement: A look-back at a commitment whose days take a note says no line

A look-back at a commitment whose days take a note SHALL say no line at all, SHALL say no whole and
SHALL say no graph. It SHALL still say the commitment's name, the rhythm it runs on in words, the
day it is kept from and, where the roster has stopped keeping it, the day it was kept until, as any
other look-back does.

#### Scenario: a look-back at a commitment whose days take a note says no line, no whole and no graph

- **WHEN** a look-back is asked for at a commitment named "Journal" kept from 1 January 2026 whose
  days take a note, as of 15 March 2026
- **THEN** it says the name, the rhythm and the day kept from, says no line at all, says no whole and
  says no graph

## MODIFIED Requirements

### Requirement: A look-back says nothing where one era gives way to the next

A look-back SHALL say nothing at all wherever one era of its chain gives way to the next. Its lines
SHALL be month lines and week lines only, running in their one newest-first order unbroken across
every boundary, with no line and no mark of any kind between the line above a boundary and the line
below it. A number commitment's graph SHALL say no rule and no mark at a boundary, and SHALL say the
same days, the same months and the same points across one that it says where no era gives way. A
total commitment's graph SHALL say no mark at a boundary and the same across one, and its target
rule SHALL step there only where the target itself changed. A boundary SHALL go unmarked whatever ended the older era, a rhythm changed, an interval's count begun
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

#### Scenario: a total commitment's graph says nothing where only the rhythm changed

- **WHEN** a look-back is asked for at a commitment named "Protein" whose days take a total, whose
  earlier era ran on a schedule listing every day with a target of 120 from 1 March 2026 until 3
  March 2026 and whose newest runs on a schedule listing Tuesday and Thursday with a target of 120
  from 4 March 2026, the older era holding an addition of 150 on 2 March 2026 and the newer one of
  90 on 5 March 2026, as of 8 March 2026
- **THEN** its graph says eight days, "1 March 2026" first and "8 March 2026" last, one month
  "March 2026" naming the first of them, two points, "150 of 120" naming the second of those days
  and "90 of 120" naming the fifth, and a target rule of one stretch from the first of those days
  through the eighth, saying "120"
- **AND** it says nothing else naming a day, and nothing at all about 4 March 2026, the day the
  newer era is kept from

## REMOVED Requirements

### Requirement: A look-back at a commitment whose days take a note or a total says no line

**Reason**: A total's look-back now says a graph of its days' sums with its target rule across;
only a note's still says nothing but its head, which the ADDED requirement for a note says alone.

**Migration**: None. The test named for its one scenario is deleted, and the test named for the
note's scenario replaces it.
