## Why

A weekly quota is due every day, so counting its days the way a tick's months are counted answers
the wrong question and the page says nothing at all where one is in the chain. The unit a quota is
owed in is the week, and the week is what this Story puts on the page.

## What Changes

- A look-back at a commitment on a weekly quota lists its weeks, newest first, as the days of that
  week it was kept out of the quota.
- A week says its span, and that span is the one place in the app a month's name is short.
- A part week — the week kept from, the week in progress, the week a stopped commitment was kept
  until — counts against the whole quota, and a week kept past its quota says so.
- A chain that mixes kinds of era says each era in its own unit, a weekday set's months beside a
  quota's weeks, with the line where the rhythm changed between them.
- A week two quota eras share is said once, against the newer era's quota.
- The whole is every line's kept days out of every line's due days and quotas, so a chain holding a
  quota says one again.
- Only a number's, a note's and a total's look-back still lists nothing.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `look-back`: MODIFIED — the months, and the whole. ADDED — a quota era's weeks, the words a week
  is said in, where the rhythm changed between two lines, and what a number, a note and a total
  still say. REMOVED — where the rhythm changed between two months, and what said no fraction for
  a weekly quota.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/LookBack.swift`, which gains the week and counts it.
- `src/DayByDayKit/Sources/DayByDayKit/LookBackWords.swift`, which gains the short month names and
  the span they are said in.
- `src/DayByDayKit/Tests/DayByDayKitTests/LookBackTests.swift`, which gains the week's tests and
  loses the two that said a quota counts nothing.
- `src/DayByDay/DayByDay/LookBackView.swift`, which draws the week rows, names the unit above them
  and takes the background its cards need to be visible in the dark.
- `docs/adr/`: an amendment to the record that draws the line under a fraction.
- `CONTEXT.md`: two amended terms, and no new one.
- Nothing persisted changes shape, so no store, no document and no record on a phone moves.
