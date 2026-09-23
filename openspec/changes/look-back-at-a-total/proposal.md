## Why

A total commitment's look-back says nothing at all but its head, because a day's sum is an amount
reached against a target rather than a day kept out of days due. What a person wants from a total
is how each day's sum stood against what it was owed, so the page draws the sums as a graph with
the target drawn across it, and counts nothing.

## What Changes

- A look-back at a commitment whose days take a total draws a **graph**: one **point** for each day
  holding an addition, at that day's sum, and no line and no whole.
- A day holding no addition is nothing on the graph, and the trace joins across it.
- Each point is marked **kept** where its sum reaches its day's target or passes it, and is said as
  its sum of that target — "150 of 120".
- The graph draws a **target rule** across its whole dates axis, at the target each day was owed,
  stepping where the target changed and labelled with its value.
- Its values run from zero to the greater of the highest sum and the highest target.
- The graph is read as a number's is: the same days, months, picker and sideways scroll.
- A total with nothing added yet draws its head and says "Nothing added yet.".
- Only a note's look-back still says nothing at all.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `look-back`: ADDED — a total's graph and its points, its kept mark and its words, its target rule,
  its values from zero, and what a note still says. MODIFIED — a boundary goes unmarked on a
  total's graph too. REMOVED — what a note and a total said.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/LookBack.swift`, whose graph walk forms a total's points,
  their kept mark and the target rule.
- `src/DayByDayKit/Sources/DayByDayKit/LookBackWords.swift`, which gains the words a sum of its
  target is said in.
- `src/DayByDayKit/Tests/DayByDayKitTests/LookBackTests.swift`, which gains the total's tests and
  loses the one that said a total says nothing.
- `src/DayByDay/DayByDay/LookBackView.swift`, which draws the rule, its labels, the ringed kept
  points and the sentence a total with nothing added says.
- `docs/adr/`: an amendment to the record a graph's kept mark is judged against.
- `CONTEXT.md`: one new term and two amended.
- Nothing persisted changes shape, so no store, no document and no record on a phone moves.
