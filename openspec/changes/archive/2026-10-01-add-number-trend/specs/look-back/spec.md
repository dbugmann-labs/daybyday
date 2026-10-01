## ADDED Requirements

### Requirement: A number commitment's graph says a trend point on each day it says a point

A number commitment's graph SHALL say a **trend**: one trend point for each point the graph says,
naming the place of that point's own day among the graph's days, and saying a value. The graph SHALL
say its trend points oldest first, and SHALL say no trend point naming a day it says no point on,
whichever day the look-back counts last. A total commitment's graph SHALL say no trend point at all,
and a look-back that says no graph SHALL say no trend.

#### Scenario: a number commitment's graph says a trend point on each day it says a point, and on no other day

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number, holding 70 on 1 March 2026, 72 on 3 March 2026
  and 74 on 4 March 2026 and no number on any other day, as of 6 March 2026
- **THEN** its graph says three trend points, naming the first, the third and the fourth of its six
  days, in that order
- **AND** it says no trend point naming the second, the fifth or the sixth of those days

#### Scenario: a number commitment's graph with one point says one trend point of that point's value

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number, holding 72.5 on 3 March 2026 and no number on
  any other day, as of 5 March 2026
- **THEN** its graph says one trend point, naming the third of its days and valued 72.5

#### Scenario: a total commitment's graph says no trend

- **WHEN** a look-back is asked for at a commitment named "Protein" on a schedule listing every day
  with a target of 120, kept from 1 March 2026, whose days take a total, holding an addition of 150
  on 1 March 2026 and one of 90 on 2 March 2026, as of 2 March 2026
- **THEN** its graph says two points and no trend point at all

### Requirement: A trend point averages the points its graph says in the seven calendar days ending on its day

A trend point's value SHALL be the average of the values of every point the graph says whose day
falls within the seven calendar days ending on the trend point's own day, that day included: their
sum divided by how many they are, however few, so the earliest trend point's value SHALL be its own
point's. The average SHALL take in the points either side of a boundary between eras alike, and
SHALL take in no number the record holds for a day the graph says no point on, a day of a gap among
them. The value SHALL be carried as exactly as a number is held, and rounded by no rule of the
look-back's own.

#### Scenario: a trend point averages the points its window holds however few, the first being its own point's value

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number, holding 70 on 1 March 2026, 72 on 3 March 2026
  and 74 on 4 March 2026 and no number on any other day, as of 4 March 2026
- **THEN** its graph says three trend points, valued 70, 71 and 72, in that order

#### Scenario: a trend point averages only the points held in the seven calendar days ending on its day

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number, holding 80 on 1 March 2026, 74 on 7 March 2026
  and 70 on 8 March 2026 and no number on any other day, as of 8 March 2026
- **THEN** its graph says three trend points, valued 80, 77 and 72, in that order

#### Scenario: a trend point averages the points either side of a boundary between eras

- **WHEN** a look-back is asked for at a commitment named "Weight" whose days take a number, whose
  earlier era ran on a schedule listing every day from 1 March 2026 until 3 March 2026 and whose
  newest runs on a schedule listing Tuesday and Thursday from 4 March 2026, the older era holding
  80 on 2 March 2026 and the newer holding 70 on 5 March 2026, as of 8 March 2026
- **THEN** its graph says two trend points, valued 80 and 75, in that order

#### Scenario: a trend point takes in no number the record holds for a day of a gap

- **WHEN** a look-back is asked for at a commitment named "Weight" whose days take a number, whose
  earlier era ran on a schedule listing every day from 1 March 2026 until 3 March 2026 and whose
  newest runs on that schedule from 6 March 2026, the record holding 72 on 2 March 2026, 90 on
  4 March 2026 and 70 on 7 March 2026, as of 8 March 2026
- **THEN** its graph says two trend points, naming the second and the seventh of its days and valued
  72 and 71, in that order

#### Scenario: a trend point's average is carried unrounded

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number, holding 80 on 1 March 2026, 81 on 2 March 2026
  and 83 on 3 March 2026, as of 3 March 2026
- **THEN** its third trend point is valued 244 divided by 3, to every digit a number is held to and
  rounded to no fewer
