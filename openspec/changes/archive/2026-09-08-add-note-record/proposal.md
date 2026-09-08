## Why

`add-commitment-kind` (#137) let a person declare that a commitment's days take a **note**, and in
the same breath closed every one of those days: a note commitment can be ticked by nothing, so a
journal has a row that offers nothing and a day that holds nothing. `add-number-record` (#138) and
`add-number-entry` (#139) between them opened the number kind, record and row together. This Story
does the same for the note, in one change folder rather than two — settled at the grill, because the
note's row half is thinner than the number's: a note commitment declares no bound, so its entry has
no hint to say and no parse table to write.

It is the third of the six Stories under `FEAT: record` (#53). When it and #141 have landed, all
four kinds are recordable and the deferral #138's grill took on a general record reader has run out.

## What Changes

- **A note is a record: a note commitment, a calendar date it is due on, and one text.** It is
  formed the way a number is and refused the same way — a date the commitment is not due on takes
  none, and a commitment whose kind is not a note takes none on any date. One refusal is its own: a
  text that is empty or holds nothing but blank space is not a note.
- **A note has no other rule.** No length limit, no restricted script, no reserved word — it is
  judged exactly as a **commitment name** is, because it is the owner's own words. "Short" in
  `CONTEXT.md` describes what a row's field invites, not what `record` refuses. It may hold a line
  break.
- **A history answers what note a commitment has on a day**, and a note keeps its day by being
  there. So *A history answers whether a commitment was kept…* changes again: it has said since #137
  that a commitment of the note kind is *not kept* on every date, and that stops being true. A total
  commitment stays not kept until #141.
- **A note entered again on the same day replaces the one before it**, and it can be **taken back**
  by naming the commitment and the day — the shape ADR-1033 fixed for the number, which this change
  amends in place to be about a record rather than about a number.
- **A note commitment's row offers a note entry in a tick's place**, on the same two conditions a
  number entry is offered on, and the row says nothing about the note itself: it says its name, its
  rhythm and whether the day is kept exactly as a number row's does. The note is reachable only
  through the entry.
- **A day screen enters what is committed in a note entry**, taking the note back where what is
  committed is blank. `DayScreen.enter(_:on:)` is widened rather than twinned: its name was already
  kind-neutral, the row it is handed says which entry it offers, and one way in is what stops a
  caller committing a note through the number's door and getting silence.
- **The store's form moves to 4.** A store goes on reading every form this app has written — now
  four of them — and a history kept before a day could hold a note reads back with no note on any
  day.
- **A number entry disregards the same blank space a note entry does.** Writing the delta measured a
  live defect in `add-number-entry`: `read(_:)` trims with `CharacterSet.whitespaces`, which contains
  a zero-width space, so a paste of that one invisible character over a day holding 70.5 silently
  took the number back. The owner settled the residual round on **fix it**, so that trim moves onto
  the same test the note uses. One expression changes, no archived scenario changes answer, and the
  package ends with one definition of blank rather than two.

## Capabilities

### New Capabilities

None. Both capabilities this change touches already exist.

### Modified Capabilities

- `record`: adds what a note is, what a history answers about one, and how one is taken back;
  modifies what a tick and a number refuse, what a history answers *kept* for, what a store persists
  and reads, and what a store refuses.
- `day-screen`: adds the note entry a row offers, what that entry says, and what a day screen does
  with what is committed in one; modifies what a row is, what a row offers at most one of, what a
  notice names, how long a notice lasts, where a commit is told nothing at all, and what blank space
  means when a number entry is read.

## Impact

- **`DayByDayKit`.** A new `Note` type beside `Number`; `History` gains a third one-off reader and a
  third store of its own; `RecordDocument` gains `notes` and moves to form 4; `DayView.Row` gains
  `noteEntry(asOf:)` and `noteRecord(_:asOf:)`; `DayScreen.enter(_:on:)` widens to read a note; a new
  internal `Blank` holds the one whitespace test, and `Commitment.init?` and `DayScreen.read(_:)`
  move onto it.
- **The app shell.** `ContentView.swift` gains a multi-line field for a note row's entry — the shell
  decides nothing, and none of it is tested (`docs/open-questions.md` § *No UI smoke layer*).
- **`docs/adr/1033`** is amended in place to be about a record taken back by naming the day.
  **`docs/adr/1039`** is new: blank is Swift's own whitespace test, asked in one place, with no
  exception anywhere in the package.
- **`CONTEXT.md`** gains **Note entry** and amends **Note**, **Row** and **Number entry**.
- **Nothing on any phone moves.** A record written at form 3 reads back unchanged and is rewritten
  at form 4 only when the next change is kept there.
- **A measured defect in #139's number reading, found while writing this delta and fixed here** — a
  lone U+200B committed in a number entry silently took the day's number back. `design.md` § *Context*
  measurements 2 and 2a carry the evidence and the proof that no archived scenario changes answer;
  the owner settled the residual round on fixing it, and `grill.md` answer 5 records the reversal.
