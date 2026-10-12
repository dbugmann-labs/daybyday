## Why

The day screen draws a birthday on its day and no sooner, so a birthday is seen only when it is too
late to plan for it. This Story gives birthdays a screen of their own, reached from the commitments
screen, listing everyone the phone's birthday calendars hand over the coming year, soonest first. It
is the screen the present ideas of `present-idea` will later be kept on.

## What Changes

- A Birthdays screen lists every birthday the calendar hands from today through the day before the
  same date a year later, soonest first, and a day's birthdays in the order their words collate in.
- Each line says the calendar's words verbatim and its day as "Sat 14 November", or "Today".
- The screen offers no tick and says nothing of one.
- It reads the calendar, and takes its today, when it is opened and when the app is shown again.
- While birthdays are off it lists nothing, says they are off and asks the calendar nothing; with
  birthdays on and nobody handed it says so; a calendar that cannot be read is said too.
- The commitments screen offers the way in exactly while birthdays are on, as a toolbar symbol.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `birthday`: ADDED — the Birthdays screen, its lines, their order and words, what it says while
  birthdays are off or unreadable, and the commitments screen's way into it.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — a new `BirthdaysScreen.swift`; `CommitmentsScreen.swift`
  takes the birthday switch and offers the way in; `DayTitle.swift` says a birthday's day.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — a new `BirthdaysScreenTests.swift`; no carried test
  moves.
- `src/DayByDay/DayByDay/ContentView.swift` — holds one calendar for both screens, builds and shows
  the Birthdays screen.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — the toolbar's gift symbol.
- `src/DayByDay/DayByDay/` — a new `BirthdaysView.swift`.
