## Why

A weight moves by a few tenths a day, yet a typed number entry on an empty day opens blank, so every
entry is typed in full from nothing. Opening on the last number kept turns most entries into one
digit changed, or none, which is what *Entered where you stand* asks of every daily entry.

## What Changes

- A typed number entry on a day holding no number says a **starting number**: the number its
  commitment holds on the latest date before that day, from any era, however far back.
- A number held on the day itself or a later day is never the starting number, so a day filled in
  after the fact starts from the day before it and not from today.
- An entry says no starting number where its day holds a number, where it is chosen, or where that
  latest number lies outside the range of the era holding the day; it never reaches further back.
- A starting number keeps nothing until it is committed, and is then entered as any typed number is.
- A starting number leaves the entry's hint as it was; a row holding one is a different row.
- The typed entry's field opens holding the starting number, cursor at the end, the range hint
  shown again once the field is emptied.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `day-screen`: ADDED — what a typed number entry's starting number is, and where an entry says
  none. MODIFIED — what a number entry says; what a row is.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/History.swift` — the latest number before a date.
- `src/DayByDayKit/Sources/DayByDayKit/DayView.swift` — a row holds, and its entry says, the
  starting number.
- `src/DayByDayKit/Tests/DayByDayKitTests/DayViewTests.swift`, `DayScreenTests.swift` — new tests.
- `src/DayByDay/DayByDay/ContentView.swift` — the typed entry's field opens on the starting number.
- `CONTEXT.md` — § *Starting number* as the grill amended it.
- Nothing persisted changes shape; no record on a phone moves.
