## Why

A mood of one to ten is typed today, through a keypad, digit by digit, though it can only ever be one
of ten whole numbers. A range that short is a handful of values, and picking one is less interaction
than typing it, which is what *Entered where you stand* asks of every daily entry.

## What Changes

- A number entry is **chosen** where its commitment's range is short — both bounds whole, eleven
  values or fewer — and **typed** otherwise; the range of the era holding the row's day decides.
- A chosen entry says the day's number and its values, lowest first, and no hint.
- A day screen records a value chosen on a row, replacing the day's number, and takes the number back
  through a clear of its own. Choosing the value already held changes nothing and writes nothing.
- A value that is not among the entry's values, and a choice on a typed row, change nothing.
- Text committed in a chosen entry changes nothing: a short range is chosen and never typed.
- Six carried scenarios that read or typed a one-to-ten mood keep their rule on a typed commitment.
- The row at rest shows neither the number nor the values; a tap opens the values in a popover
  anchored to the row, a value marked where the day holds it, the clear beside them.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `day-screen`: ADDED — a number entry is chosen from a short range and typed otherwise; a day screen
  records a chosen value and takes it back through the clear. MODIFIED — what a number entry says; a
  commit in a chosen entry changes nothing; carried scenarios moved off a short range.
- `restore`: MODIFIED — one carried scenario's refused number moves off a short range.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/DayView.swift` — the number entry says its values.
- `src/DayByDayKit/Sources/DayByDayKit/DayScreen.swift` — the choice, and the typed commit's guard.
- `src/DayByDayKit/Tests/DayByDayKitTests/DayViewTests.swift`, `DayScreenTests.swift` — new tests,
  and six carried tests edited as their scenarios now say.
- `src/DayByDay/DayByDay/ContentView.swift` — the popover a chosen row opens.
- `CONTEXT.md` — § *Short range* as the grill amended it, and the *clear* named under it.
- Nothing persisted changes shape; no record on a phone moves.
