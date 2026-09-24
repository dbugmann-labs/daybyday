## Why

Birthdays are read from the phone's calendar, and nothing is read until the person has turned them
on and the phone has said yes. This Story is that switch, on the commitments screen: off until
turned on, asking the phone when it is, and saying so when the phone refuses. It reads no birthday;
the day screen's group, which does, is the next Story and is blocked on this one.

## What Changes

- A birthday switch, off until turned on, kept at a place of its own across the app being closed.
- It is the app's second setting: never in a copy, never replaced by a restore; a new phone starts off.
- Turned on without full calendar access, it asks the phone, and is on only if full access is given.
- Turned on and refused, it turns itself back off.
- It is on only while the phone gives full access: withdrawn, restricted or write-only turns it off.
- Access given back later turns nothing on; only the person turning it on again does.
- Whenever the phone refuses, whether or not the switch was ever turned on, it says so.
- The commitments screen draws the switch in a section of its own just above *Copy*, with a line
  saying what it does, the refused line when the phone refuses, and a way to Settings.
- The prompt's sentence says what the app does with the calendars it is given.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `birthday`: ADDED — the switch, the place it is kept at, what turning it on asks of the phone,
  and the refused line.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — one new file: the switch and the phone's calendar access.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — one new test file for the switch.
- `src/DayByDay/DayByDay/` — the commitments screen's new section, the view that holds the switch
  and shows it again, and the adapter that reads and asks the phone's calendar access.
- `src/DayByDay/Info.plist` — the calendar usage sentence.
