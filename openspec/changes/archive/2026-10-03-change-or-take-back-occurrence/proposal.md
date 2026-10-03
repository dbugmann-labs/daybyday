## Why

An occurrence can be noted from the day screen, but once noted it is fixed: a wrong time or a
mistyped note stays, and one noted by mistake cannot go. This Story lets a person change an
occurrence's time and note, clear either, and take the occurrence back, from the row that says it
came. Moving one to another happening or another day is taking it back and noting it again.

## What Changes

- Happenings change an occurrence's time and note in place, keeping its happening, its day and its
  place in the order noted; of two alike, the earliest noted is the one changed.
- Happenings take an occurrence back, one at a time, the rest left in their order.
- The happening store keeps both under the rules every change it keeps is under.
- A day screen answers a happening row's occurrences on the day shown, in the row's order, each with
  its time in the row's words and its note.
- A day screen changes an occurrence, bounded at now on today as noting is, and takes one back.
- Either is refused as not kept where the happening place cannot be written or is not being kept,
  or where no such occurrence is held; a change to what is held already asks for no change.
- A kept change or take-back redraws the day, ends a notice, writes no copy and touches no other store.
- The shell opens a tapped happening row's occurrences in a popover, or the one alone directly, in
  the noting sheet filled in, with a *Take back* that asks before acting.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `happening`: ADDED — changing and taking back an occurrence, and the store keeping both.
- `day-screen`: ADDED — a happening row's occurrences, changing and taking one back, and their
  refusals.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `Occurrence.swift` says its time in words;
  `Happenings.swift` and `HappeningStore.swift` change and take back; `DayView.swift` reads the
  time words; `DayScreen.swift` answers a row's occurrences, changes and takes back.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — new tests beside `OccurrenceTests.swift` and
  `DayScreenHappeningTests.swift`; no carried test moves.
- `src/DayByDay/DayByDay/ContentView.swift` — the row's tap, its popover, the filled-in sheet, its
  *Take back* and the confirmation.
- `CONTEXT.md` — **Occurrence** amended.
