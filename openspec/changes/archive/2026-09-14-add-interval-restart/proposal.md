## Why

An every-N-days commitment kept a day late has no honest way to run on from the day it was done.
The only lever a phone offers is the day it is kept from, which corrects the whole history rather
than starting the count again partway through it, and refuses once anything is recorded. Restarting
(`CONTEXT.md` § *Restarting*) is that way, reached from the change sheet.

## What Changes

- A commitments screen restarts an every-N-days commitment it keeps from a day it is given: the
  commitment is superseded as of the day before, and one alike in name, interval, kind and category
  runs from that day, kept from it.
- Every record on or after that day is carried onto the restarted commitment; every record before it
  stays where it is.
- The restart is its own act, asked with a commitment and a day and nothing else.
- Four new refusals: a day after today, a day before the day kept from, a day the rhythm is already
  due on, and a restart only a stopped, removed or non-interval commitment would need, which does
  nothing and says nothing.
- The existing refusals carry over: a recorded day left not due, records already kept under the
  result, a commitment already held, and a place that could not be written.
- A commitments screen says whether a commitment can be restarted, and offers the day it was handed
  as the day to restart from.
- The change sheet draws a restart control for a commitment that can be restarted, and the shell
  says the three new refusals in words.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: ADDED — a commitments screen restarts an interval commitment it keeps, from a day.
- `commitment`: ADDED — a commitments screen refuses a restart it cannot make.
- `commitment`: ADDED — a commitments screen says whether a commitment can be restarted.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/CommitmentsScreen.swift` — the restart act, its refusals,
  and what a commitment is made of.
- `src/DayByDayKit/Sources/DayByDayKit/History.swift` and `RecordStore.swift` — a package-internal
  carry-over of the records on or after a day.
- `src/DayByDayKit/Tests/DayByDayKitTests/CommitmentsScreenTests.swift` — the acceptance tests.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — the restart control and its refusals' words.
- `CONTEXT.md` § *Restarting* and § *Commitments screen* — what the delta settles about the day a
  restarted commitment is kept from, and the eighth kind of refused change.
