## Why

A one-off can be drawn and ticked on the day screen, but nothing there makes one, renames one or
removes one, so the one-off store only ever holds what something other than a person put in it.
This change makes the day screen the place a one-off is written down, on whatever day is shown.

## What Changes

- One-offs rename a one-off in place, keeping its date, whether it is done and its place in the order.
- A day view's One-offs group is drawn on every day wherever one-offs are kept, rows or none.
- A day screen adds the one-off committed in its one-off entry on the day shown, trimmed.
- An add on a past day is made already done there; on today or a later day it is made not done.
- A day screen renames and removes a row's one-off on any day; a blank rename removes, its own name does nothing.
- A refused add or rename is told under the field it was typed in, never as the row notice.
- What is told there ends on an edit, a kept commit from that field, a day change or being shown.
- A removal that cannot be kept is told on its row, as a refused tick is.
- A day screen not keeping one-offs offers no entry and adds nothing.
- The app shell draws the entry, a toolbar `+`, a green checkmark and a long-press menu.
- The shell commits a typed name before the day changes or the app leaves the screen.
- Shipped screen scenarios comparing with a day view formed directly form it of one-offs holding none.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `one-off`: ADDED one requirement.
- `day-screen`: ADDED four requirements; MODIFIED thirteen.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/OneOffs.swift`, `OneOffStore.swift`
- `src/DayByDayKit/Sources/DayByDayKit/DayView.swift`, `DayScreen.swift`
- `src/DayByDayKit/Tests/DayByDayKitTests/OneOffTests.swift`, `OneOffStoreTests.swift`
- `src/DayByDayKit/Tests/DayByDayKitTests/DayViewTests.swift`, `DayScreenTests.swift`
- `src/DayByDay/DayByDay/ContentView.swift`
- `CONTEXT.md`
