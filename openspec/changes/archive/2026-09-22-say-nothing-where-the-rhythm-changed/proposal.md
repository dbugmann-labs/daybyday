## Why

A look-back draws a line between two eras, and a number commitment's graph draws a rule at the
same boundary, each saying the newer era's rhythm and the day it is kept from. The page's head
already says both, so the mark says nothing new while breaking the run of months and weeks, and
the graph, that the page exists to be read down. It is clutter, and it goes.

## What Changes

- A look-back says nothing at all wherever one era of its chain gives way to the next.
- Its month lines and its week lines run unbroken across every boundary — no line, no mark, no gap.
- A number commitment's graph says no rule at a boundary, and its trace crosses one as it joins
  any two points.
- Every boundary goes unmarked whatever ended the older era: a rhythm change, an interval restart,
  a range or a target changed on the sheet.
- A chain of mixed eras still lists a weekday era's months above a quota era's weeks, each in its
  own unit, with nothing standing between them.
- The head still says the newest era's rhythm in words and the earliest era's day kept from, which
  becomes the only place a look-back says a rhythm at all.
- Nothing is offered in the mark's place, and no setting keeps it reachable.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `look-back`: ADDED — that a look-back says nothing where one era gives way to the next, in its
  lines and on its graph alike. MODIFIED — the weekly quota requirement, whose mixed-chain scenario
  said the line, and the requirement for the span a graph runs over, whose prose said the rule.
  REMOVED — the line between the lines, and the graph's rule.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/LookBack.swift`, which loses the line, the graph's rules and
  the placement that decided which line a boundary's mark stood above.
- `src/DayByDayKit/Tests/DayByDayKitTests/LookBackTests.swift`, which loses the tests named for the
  removed scenarios and the assertions inside two that stay.
- `src/DayByDay/DayByDay/LookBackView.swift`, which loses the rules it drew between rows and across
  the plot, the lane of labels under the dates axis, and the space that lane took.
- `CONTEXT.md`, whose *Look-back* and *Graph* prose describes the mark.
- Nothing persisted changes shape, so no store, no document and no record on a phone moves.
