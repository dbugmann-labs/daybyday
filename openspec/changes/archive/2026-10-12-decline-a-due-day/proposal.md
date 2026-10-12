## Why

A due day a person chose not to keep reads today exactly as one nobody recorded: the row is blank,
and the why is lost. A **declined** day is a record of its own, still owed and never kept, with an
optional reason (`CONTEXT.md` § *Declined*). This Story is the record and the row; how many days
were declined is counted in a look-back by #403, and days away are #401 and #402.

## What Changes

- A history holds a decline beside its other records: a commitment, a due date, a reason or none.
  A weekly quota's day takes none; a decline never keeps its day and counts toward no standing.
- A day holds a decline or other records, never both: a decline is refused on a day holding any
  record, and any record made on a declined day replaces the decline, reason and all.
- A decline can be taken back, leaving the day holding nothing; its reason can be changed or
  cleared, the decline standing.
- The record store keeps declines and reads them back exactly; an earlier store reads as holding
  none. A copy carries them, and a restore puts them back.
- A day screen offers declining a row whose day holds nothing, from the row's long-press menu,
  beside "Shift to"; a declined row offers "Reason" and "Take back" there instead.
- A declined row draws a grey dash in the check's place and its reason under its name, cut to one
  line; it still offers its tick or entry, and tapping it keeps the day.
- A declined day cannot be shifted. A stop made on a declined day keeps the commitment until that
  day, as a tick does. A deletion erases declines with every other record.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `record`: four ADDED, three MODIFIED.
- `day-screen`: three ADDED, three MODIFIED.
- `commitment`: two MODIFIED.
- `restore`: one ADDED.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — a new `Decline.swift`; `History`, `RecordStore`,
  `RecordDocument`, `CopyDocument`, `DayView`, `DayScreen`.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — new tests for the decline, beside the carried ones,
  and the carried lines that fix the record form as current or later.
- `src/DayByDay/DayByDay/ContentView.swift` — the row's mark and reason, its long-press menu, and
  the reason sheet.
- `docs/adr/1068-a-decline-holds-its-days-place.md` — new.
