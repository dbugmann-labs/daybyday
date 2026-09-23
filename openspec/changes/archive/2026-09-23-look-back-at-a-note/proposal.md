## Why

A note commitment's look-back says its head and nothing else, so the one page meant for reading how
a commitment has gone cannot show what was written. What a person wants from a note is the notes
themselves, dated and newest first, as a journal reads — not a count of days out of days due.

## What Changes

- A look-back at a commitment whose days take a note says its **notes**: one for each day it counts
  that holds one, newest first, each with its day and its text exactly as written, line breaks kept.
- A day that holds no note is nothing on the page, due or not.
- The look-back says a **count** of its notes, "38 notes" or "1 note", never a fraction, and none
  where it says no note.
- It still says no line, no whole and no graph.
- The page draws a card per note under a heading saying the count, each note **folded** to two
  lines; a note cut there **opens** in place on a tap and folds on another.
- A note page with no note yet draws its head and says "No note yet.".

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `look-back`: ADDED — a note's look-back says its notes, and counts them. REMOVED — what a note's
  look-back said, which was no line.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/LookBack.swift`, which forms a note's notes and its count.
- `src/DayByDayKit/Sources/DayByDayKit/LookBackWords.swift`, which gains the words a count is said in.
- `src/DayByDayKit/Tests/DayByDayKitTests/LookBackTests.swift`, which gains the note's tests and loses
  the one that said a note says nothing.
- `src/DayByDay/DayByDay/LookBackView.swift`, which draws the cards, the heading, the fold and the
  empty page's sentence.
- `docs/adr/`: an amendment to the record the count stands on the right side of.
- `CONTEXT.md`: § *Look-back* amended.
- Nothing persisted changes shape, so no store, no document and no record on a phone moves.
