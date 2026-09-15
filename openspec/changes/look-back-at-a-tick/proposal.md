## Why

Someone who has kept a commitment for months has nowhere to see how it has gone. The commitments
screen manages what is kept and the day screen asks one day's question; neither looks back. This
Story establishes the page, and the four Stories behind it fill in the kinds it leaves empty.

## What Changes

- A commitments screen answers a **look-back** at any commitment on either of its lists, whatever
  kind its days take.
- A look-back says the commitment's name, its rhythm in words, the day it is kept from and, where
  it has been stopped, the day it was kept until.
- A tick commitment's look-back lists every calendar month from the day it is kept from, newest
  first, as the days kept out of the days due, counted through today or the day it was kept until.
- A look-back says one whole beside the months, across everything since the day it is kept from.
- A look-back reads a commitment's earlier **eras** — the spans a rhythm change or an interval
  restart cut — off the roster by resemblance, and counts every one of them.
- A look-back says a line in words wherever one era gives way to the next.
- A look-back of a commitment whose days take a number, a note or a total lists nothing yet, and
  neither a weekly quota's months nor a chain holding one says a fraction.
- A look-back says its months, its days and its fractions in the app's own English, and never says
  a percentage.
- The entry's tap on the commitments screen opens the page; the swipes stay the doors for acting.

## Capabilities

### New Capabilities

- `look-back`: one commitment seen on its own, over everything since the day it was kept from —
  what the page says, what it counts, and how it reads a commitment's earlier eras.

### Modified Capabilities

None. Nothing already specified changes its answer.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/LookBack.swift` and `LookBackWords.swift`, both new.
- `src/DayByDayKit/Sources/DayByDayKit/CommitmentsScreen.swift`, which gains the one member that
  answers a look-back and changes nothing else.
- `src/DayByDayKit/Tests/DayByDayKitTests/LookBackTests.swift`, new.
- `src/DayByDay/DayByDay/CommitmentsView.swift` and `LookBackView.swift`, the shell that draws it.
- `docs/adr/`: one new record for reading eras by resemblance, and an amendment to the record that
  draws the line under a fraction.
- `CONTEXT.md`: one new term and two amended.
- Nothing persisted changes shape, so no store, no document and no record on a phone moves.
