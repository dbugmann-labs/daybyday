## Why

The Birthdays screen is for looking at whose birthday is coming, but its only way in sits on the
commitments screen, which is for keeping commitments. And it lists a whole year of every contact,
uncapped, so finding one person to add an idea to means scrolling for them. This Story puts the way
in on the day screen and lets a person find someone by typing.

## What Changes

- The way to the Birthdays screen leaves the commitments screen and is offered on the day screen,
  on whichever day it shows, exactly while birthdays are on.
- The Birthdays screen reached from the day screen lists from today, whichever day it was opened
  from.
- The Birthdays screen offers a search while it lists at least one line, and lists only the lines
  whose words hold what is typed, anywhere in them and whatever the capitals and accents.
- Spaces before and after a search are ignored, and a search of spaces only lists every line.
- A search that matches nobody says so, quoting it.
- A search lasts while the Birthdays screen is open, across the app being shown again and an idea
  being added, and the next opening starts on the whole list.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `birthday`: ADDED — the day screen's way to the Birthdays screen and the screen it opens; the
  search, what it matches, and what it says of matching nobody. MODIFIED — what a Birthdays screen
  lists. REMOVED — the commitments screen's way to the Birthdays screen.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `DayScreen.swift`, `BirthdaysScreen.swift` and
  `CommitmentsScreen.swift`.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — `BirthdaysScreenTests.swift` and
  `DayScreenBirthdayTests.swift` gain the new scenarios; the commitments screen's two way-in tests
  go with their requirement.
- `src/DayByDay/DayByDay/` — `ContentView.swift`, `CommitmentsView.swift` and `BirthdaysView.swift`.
