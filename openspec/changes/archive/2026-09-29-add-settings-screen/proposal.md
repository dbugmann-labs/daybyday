## Why

The commitments screen holds two things: the roster a person manages, and everything the app keeps
for itself — the copy place, making, taking out and restoring a copy, and the birthday switch. The
second half sits below the roster, far from reach, and makes Commitments read as a settings page. A
screen of its own, Settings, lets Commitments be the roster alone.

## What Changes

- A day screen that is not keeping a store names Settings, not the commitments screen, as where a
  copy can be restored. When it says so is unchanged.
- The shell draws a Settings screen, opened as a sheet from the day screen's toolbar beside
  Commitments, holding the copy place and its last-copy line, the birthday switch and its refused
  line, making a copy, the take-out, restoring a copy, and a line naming the app's version.
- The commitments screen draws its two lists and what is done to them, and nothing else.
- The day screen's toolbar carries Commitments and Settings as two symbols in one group.
- The birthday refused line's button says "Open iPhone Settings", and the switch takes the app's
  tint.
- Nothing any screen does changes: Settings draws the same acts the commitments screen answered.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `restore`: MODIFIED — *A day screen that is not keeping a store says a copy can be restored and
  where* names Settings as where.

## Impact

- `src/DayByDay/DayByDay/ContentView.swift` — the toolbar, the Settings sheet, the restore line.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — loses the copy and birthday sections.
- `src/DayByDay/DayByDay/` — a new Settings view holding them.
- `src/DayByDayKit/Sources/DayByDayKit/DayScreen.swift` — one doc comment; no signature moves.
