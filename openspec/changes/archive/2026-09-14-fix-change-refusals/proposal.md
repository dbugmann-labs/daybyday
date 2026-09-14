## Why

A commitments screen gives the wrong answer about two changes. An every-N-days commitment whose
interval starts on a day other than the day it is kept from refuses a rename, a category change and
a save with nothing changed, once it has a record: the change moves the interval's start to the
day it is kept from. And a change that would carry records onto a commitment the record place
already holds records of is refused as leaving a recorded day not due, a cause it does not have.

## What Changes

- A change that leaves the day kept from alone leaves an every-N-days schedule's own start date
  where it was, on the changed commitment and on the one a save supersedes.
- A change that names a different day kept from moves an every-N-days schedule's start to that day,
  even where the start and the day kept from had differed.
- A new refusal: a change that would carry records onto a commitment the record place already holds
  records of is refused for that cause, whether or not the commitment changed holds any.
- Where a change meets both causes, the refusal for a day already recorded on that the change would
  leave not due is the one given.
- The shell reads the new refusal as "Records already exist under that."
- The floor a commitment is kept from is stated as leaving an interval's start alone by itself,
  without contradicting what a change does to it.
- Nothing repairs records that exist under no commitment, and no refusal already specified moves.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: ADDED — a change that leaves the day kept from alone leaves an interval's start date
  where it was.
- `commitment`: ADDED — a commitments screen refuses a change that would carry records onto records
  already kept.
- `commitment`: MODIFIED — *A commitment is not due before the day it is kept from*.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/CommitmentsScreen.swift` — the change path and its refusals.
- `src/DayByDayKit/Sources/DayByDayKit/History.swift` — a package-internal check for held records.
- `src/DayByDayKit/Tests/DayByDayKitTests/CommitmentsScreenTests.swift` — the acceptance tests.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — the words for the new refusal.
- `CONTEXT.md` § *Kept from* — one sentence on what a change does to an interval's start.
