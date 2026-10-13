## Why

A birthday seen coming on the Birthdays screen is only half of planning for it: the idea of what to
give is still kept somewhere else, or nowhere. This Story lets a person type a present idea — a
short text, a link, or both — against someone the phone's birthday calendars hand, read it back on
that person's page, and find it still there after the app is closed.

## What Changes

- A present idea is a text, a link or both, each trimmed; both blank is refused with one line.
- A link must read as a web address; one typed without a scheme is kept with `https://` in front,
  and a kept link opens in Safari. Anything else is refused whole, the fields kept as typed.
- Ideas are held against the birthday's contact, as a tick is, in the order added; two alike are
  both kept, and a contact the calendar no longer hands keeps its ideas unseen.
- A store of its own keeps them at a place of its own, refused whole rather than emptied when it
  cannot be read, and a save that cannot be written keeps nothing.
- Every Birthdays screen line opens the person's page, and says "1 idea", "2 ideas" or nothing.
- The page lists the person's ideas and offers "New idea", a sheet with a text and a link field.
- A present-idea file that cannot be read leaves every birthday listed with no count, says so in
  one line, and refuses every addition.

## Capabilities

### New Capabilities

- `present-idea`: ADDED — the idea and its link, the store and its place, the count on a Birthdays
  screen line, the ideas a line opens, adding one, and the file that cannot be read.

### Modified Capabilities

- `birthday`: MODIFIED — a Birthdays screen line now gives back its contact and says its count, so
  two contacts' lines alike in words and day are two lines.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — new `PresentIdea.swift`, `PresentIdeaStore.swift` and
  `PresentIdeaDocument.swift`; `BirthdaysScreen.swift` takes the place, reads it and adds.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — new `PresentIdeaTests.swift` and
  `PresentIdeaStoreTests.swift`; `BirthdaysScreenTests.swift` gains the screen's scenarios and its
  carried tests hand in a place and build lines with a contact.
- `src/DayByDay/DayByDay/ContentView.swift` — hands the present-idea place to the Birthdays screen.
- `src/DayByDay/DayByDay/BirthdaysView.swift` — the count, the chevron, the line that cannot read.
- `src/DayByDay/DayByDay/` — a new `PresentIdeasView.swift`: the person's page and the sheet.
