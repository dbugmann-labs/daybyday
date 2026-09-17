## Why

A number commitment's look-back lists nothing at all, because a weight or a mood has no kept days
to count out of due days. What a person wants from a weight is the shape it has made over time, so
the page draws the numbers themselves and drops the counting.

## What Changes

- A look-back at a commitment whose days take a number draws a **graph**: one **point** for each day
  that holds a number, and no line and no whole.
- The graph runs over every day from the day the commitment is kept from through today, or through
  the day it was kept until, whatever days hold a number.
- A day holding no number is nothing on the graph — no point, no gap, no mark of kept or missed.
- The graph says the day each of its days is, and the month each of its calendar months is, so its
  dates axis invents no words.
- The graph says the lowest and the highest its values run between: the newest era's range where it
  declares one, the numbers themselves where it declares none, widened to hold a number outside.
- The graph says a **rule** wherever one era gives way to the next, saying what the line where the
  rhythm changed says.
- A look-back says a number as its digits, in the app's own words and in no device locale.
- Only a note's and a total's look-back still says nothing at all.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `look-back`: ADDED — the graph and its points, the days and months its axes are said over, its
  lowest and highest, its rules where the rhythm changed, how a number is said, and what a note and
  a total still say. REMOVED — what a number, a note and a total said.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/LookBack.swift`, which gains the graph and the walk that
  forms it.
- `src/DayByDayKit/Sources/DayByDayKit/LookBackWords.swift`, which gains the words a number is said
  in.
- `src/DayByDayKit/Tests/DayByDayKitTests/LookBackTests.swift`, which gains the graph's tests and
  loses the one that said a number lists nothing.
- `src/DayByDay/DayByDay/LookBackView.swift`, which draws the graph card, the picker of spans and
  the sentence a page with no number says.
- `docs/adr/`: an amendment to the record that draws the line under a fraction.
- `CONTEXT.md`: one new term and one amended.
- Nothing persisted changes shape, so no store, no document and no record on a phone moves.
