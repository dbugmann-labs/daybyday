## Why

A present idea can be typed and read back, but not fixed, thrown away, or kept as a record of what
was given. This Story lets a person change or delete an idea on someone's page, mark it given, and
take the mark back, so the top of the page is what is still to give and its foot what was given.

## What Changes

- An idea is changed through a sheet opened with its text and link filled in, under the same rules
  an idea is added under; a change that leaves both blank is refused, and a given idea stays given.
- An idea is deleted only once the deletion is confirmed; a cancel changes nothing.
- An idea is marked given and the mark taken back; the mark lasts until it is taken back or the idea
  deleted, and touches no birthday tick.
- A person's page lists the ideas not given in the order added, then those given in the order added;
  a given idea is drawn struck through and its link still opens.
- A Birthdays line counts only the ideas not given, and says nothing where every one is given.
- The present-idea file gains a second form holding the mark; a first-form file reads as none given.
- A change, deletion or mark that cannot be written keeps nothing and says "Not saved. Try again."

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `present-idea`: ADDED — the store's change, deletion and mark; the screen's change, confirmed
  deletion and mark, and their refusals. MODIFIED — the idea, the store's holding, the count on a
  line, the order a line's ideas are given back in, and how long a refusal is told.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `PresentIdea.swift`, `PresentIdeaStore.swift`,
  `PresentIdeaDocument.swift` and `BirthdaysScreen.swift`.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — `PresentIdeaStoreTests.swift` and
  `BirthdaysScreenTests.swift` gain the new scenarios; two carried later-form fixtures move one form
  on.
- `src/DayByDay/DayByDay/PresentIdeasView.swift` — the swipes, the change sheet, the confirmation,
  the given look and the page's own refusal line.
