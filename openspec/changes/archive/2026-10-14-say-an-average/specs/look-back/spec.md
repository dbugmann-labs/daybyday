## ADDED Requirements

### Requirement: A number or a total commitment's graph says an average over each span of its newest days

A number or a total commitment's graph SHALL say an **average** over each of four **spans** of its
days: a month, the newest 31 days the graph says; three months, the newest 92; a year, the newest
366; and all, every day the graph says. A span longer than the days the graph says SHALL take in
every one of them. The average over a span SHALL be the values of the points whose days fall within
that span, a total's points at their sums, summed and divided by how many they are. It SHALL take
in no day the graph says no point on, a day of a gap among them, and SHALL take in points either
side of a boundary between eras alike. Where a span holds no point, the graph SHALL say no average
over it. A look-back that says no graph SHALL say no average.

#### Scenario: a graph averages the points among each span's newest days

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 January 2025, whose days take a number, holding 60 on 30 March 2025, 70 on 31 March
  2025, 74 on 29 December 2025, 80 on 30 December 2025, 79 on 28 February 2026, 82 on 1 March 2026
  and 85 on 31 March 2026 and no number on any other day, as of 31 March 2026
- **THEN** its average over a month says "83.5"
- **AND** its average over three months says "81.5", over a year "78.3" and over all "75.7"

#### Scenario: a span longer than its graph's days averages every point the graph says

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number, holding 70 on 1 March 2026 and 73 on 5 March
  2026 and no number on any other day, as of 10 March 2026
- **THEN** its averages over a month, over three months, over a year and over all each say "71.5"

#### Scenario: a stopped commitment's spans end on the day it was kept until

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 January 2026 and kept until 31 January 2026, whose days take a number, holding 80 on
  15 January 2026 and 90 on 4 March 2026, as of 31 March 2026
- **THEN** its average over a month says "80"

#### Scenario: a graph says no average over a span holding no point

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 January 2026, whose days take a number, holding 80 on 15 January 2026 and no number on
  any other day, as of 31 March 2026
- **THEN** its graph says no average over a month
- **AND** its averages over three months, over a year and over all each say "80"

#### Scenario: a total commitment's average takes in each day's sum across a change of target, and says no target

- **WHEN** a look-back is asked for at a commitment named "Protein" whose days take a total, whose
  earlier era ran on a schedule listing every day with a target of 120 from 1 March 2026 until 3
  March 2026 and whose newest runs on a schedule listing every day with a target of 100 from 4 March
  2026, the older era holding additions of 100 and 50 on 2 March 2026 and the newer one of 85 on 5
  March 2026, as of 8 March 2026
- **THEN** its average over a month says "117.5"

#### Scenario: a graph's average takes in no number the record holds for a day of a gap

- **WHEN** a look-back is asked for at a commitment named "Weight" whose days take a number, whose
  earlier era ran on a schedule listing every day from 1 March 2026 until 3 March 2026 and whose
  newest runs on that schedule from 6 March 2026, the record holding 72 on 2 March 2026, 90 on
  4 March 2026 and 70 on 7 March 2026, as of 8 March 2026
- **THEN** its average over a month says "71"

### Requirement: A look-back says an average to one decimal place, in the app's own words

A look-back SHALL say an average rounded to one decimal place: to the nearest tenth, a value lying
exactly halfway between two tenths rounding away from zero. It SHALL round only once, the average
itself, carried until then as exactly as a number is held. It SHALL then say the rounded value as
a look-back says a number, so a rounded value with no tenths SHALL be said with no full stop and no
fraction, and no average SHALL be said with more than one digit after its full stop. An average
that rounds to zero SHALL be said "0", with no minus. An average SHALL be said as its digits alone,
with no target, no unit and no word beside them.

#### Scenario: a look-back says an average to one decimal place

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number, holding 80 on 1 March 2026, 81 on 2 March 2026
  and 83 on 3 March 2026, as of 3 March 2026
- **THEN** its average over a month says "81.3"
- **AND** alike holding 100, 101 and 101, it says "100.7"
- **AND** alike holding 72.2 on 1 March 2026 and 72.3 on 2 March 2026 and no other number, it says
  "72.3"

#### Scenario: a look-back says an average rounding to a whole number with no fraction and no separator between thousands

- **WHEN** a look-back is asked for at a commitment named "Weight" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number, holding 74.9 on 1 March 2026 and 75.02 on 2 March
  2026, as of 2 March 2026
- **THEN** its average over a month says "75"
- **AND** a look-back at a commitment named "Steps" alike, holding 12000 on 1 March 2026 and 12002
  on 2 March 2026, says its average over a month "12001"

#### Scenario: a look-back rounds a halfway average below zero away from zero, and says one rounding to zero as 0

- **WHEN** a look-back is asked for at a commitment named "Balance" on a schedule listing every day,
  kept from 1 March 2026, whose days take a number between -10 and 10, holding -1 on 1 March 2026
  and -2.5 on 2 March 2026, as of 2 March 2026
- **THEN** its average over a month says "-1.8"
- **AND** alike holding 0.02 on 1 March 2026 and -0.1 on 2 March 2026, it says "0"
