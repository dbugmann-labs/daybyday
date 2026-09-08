## Why

`add-commitment-kind` (#137) let a person declare that a commitment's days take a **total**, and in
the same breath closed every one of those days: a total commitment can be ticked by nothing, so a
protein count is a row that offers nothing and a day that holds nothing. `add-number-record` (#138)
and `add-number-entry` (#139) opened the number kind, record and row; `add-note-record` (#140) did
the note in one folder. This does the total, in one folder for the same reason — settled at the
grill, against the recommendation to split it.

It is the fourth and last of the four kinds, so after it every kind is recordable and the deferral
#138's grill took on a general record reader has run out. It is also the only kind that changes how
*kept* is answered: a total is kept when its day's additions have reached the commitment's
**target**, rather than by a record being there at all.

## What Changes

- **An addition is a record: a total commitment, a calendar date it is due on, and one decimal
  above zero.** It is formed the way a number is and refused the same two ways — a date the
  commitment is not due on takes none, and a commitment whose kind is not a total takes none on any
  date. One refusal is its own: **zero and below are not additions**, because a negative addition
  would be a second way back competing with the take-back that already exists.
- **A day holds many additions, in the order they were made, and its total is their sum.** That is
  the first record in this system a day holds more than one of, and the reason `CONTEXT.md` says the
  record is the additions and the total is derived. **A history gives out the sum and not the
  list** — nothing has asked for the list, since a take-back is named by commitment and date.
- **A history answers a total of zero for every commitment on every date**, rather than *nothing*
  the way the number and note readers answer. The sum of no additions really is zero whatever the
  commitment, and it keeps an optional off the surface. It also makes take-back readable off the
  sum: additions are above zero, so a sum above zero means the day holds one.
- **A total keeps its day when its sum has reached its target**, and additions past the target are
  allowed and change nothing. So *A history answers whether a commitment was kept…* changes for the
  last time: it has said since #137 that a total commitment is *not kept* on every date, and that
  stops being true.
- **The last addition of a day can be taken back, and only the last.** Taking back names the
  commitment and the day, as every record's does (ADR-1033), but removes one addition rather than
  the record — the fourth kind that record's own reversal trigger named. There is no way to clear a
  whole day in one act.
- **A total commitment's row offers a total entry in a tick's place, and offers take-back-last
  besides.** That second affordance is the only one in this system that appears and disappears with
  what the day holds: a row offers it exactly where the day holds an addition to take back. Every
  other kind's take-back is the same gesture as its record; a total's cannot be, because a blank
  commit would delete the last addition silently.
- **A total entry says the day's sum and the commitment's target, in this package's own words —
  "150 of 120" — and its field opens empty.** It says the **true** sum once it has passed the
  target, because showing "120 of 120" would be the app editing a person's record down to look
  tidy. The field opens empty because a commit is an addition rather than a replacement, and a field
  opening on 90 committed unread would make the day 180.
- **A commit in a total entry is always an addition, and a blank one keeps nothing and takes
  nothing back.** That is where a total entry parts from the other two, whose blank commit is the
  take-back.
- **A day's sum is capped at thirty-eight significant digits, and the cap is `day-screen`'s — the
  same rule, in the same place, that `add-number-entry` already applies to one typed number.** An
  addition that would take the day's sum past what this system can keep exactly is refused, the
  day's additions stand, and the row is told why.
- **`day-screen`'s closed set of named causes goes from two to four**, on that requirement's own
  stated test: name a cause only where a person can act on that cause differently. "Must be more
  than 0" and "Too large to add" both pass it, and both are the value a person gave rather than the
  place refusing.
- **The store's form moves to 5.** A store goes on reading every form this app has written — now
  five of them — and a history kept before a day could hold an addition reads back with no addition
  on any day. A day's additions are persisted as one record holding them in order, so the file stays
  byte-stable without a sixth sort key.
- **`RecordStore.write` and `RecordDocument.init` take labelled parameters.** A known gap recorded
  at #140's close-out: `(ticks, numbers, notes)` travels unlabelled and positional, and this change
  makes it four. No behaviour changes and no requirement moves; it is named here because the debt
  was recorded against this Story by name.

## Capabilities

### New Capabilities

None. Both capabilities this change touches already exist.

### Modified Capabilities

- `record`: adds what an addition is, what a history answers about a day's additions, and how the
  last one is taken back; modifies what a tick, a number and a note refuse, what a history answers
  *kept* for, what a store persists and reads, and what a store refuses.
- `day-screen`: adds the total entry a row offers, what that entry says, the take-back a total row
  offers, what a day screen does with what is committed in a total entry, how it reads one, and how
  it takes the last addition back; modifies what a row is, what a row offers at most one of, which
  causes a notice names, how long a notice lasts, and where a commit is told nothing at all.

## Impact

- **`DayByDayKit`.** A new `Addition` type beside `Number` and `Note`; `History` gains a fourth
  record, its first ordered one, a sum reader and a take-back-last; `RecordDocument` gains
  `additions` and moves to form 5; `DayView.Row` gains `totalEntry(asOf:)`, `totalRecord(_:asOf:)`
  and `offersTakeBackLast(asOf:)`; `DayView.TotalEntry` and `DayView.TotalRecord` are new;
  `DayScreen.enter(_:on:)` widens a third time and `DayScreen.takeBackLast(on:)` joins it.
- **The app shell.** `ContentView.swift` gains a decimal field and a *Take back last* button on a
  total row's sheet, and draws the entry's "150 of 120" on the row. The shell decides nothing, and
  none of it is tested (`docs/open-questions.md` § *No UI smoke layer*).
- **`docs/adr/1040`** is new: the day's sum is capped at thirty-eight significant digits, and the
  cap lives where `add-number-entry` already put the same number. **`docs/adr/1041`** is new: a
  total entry's blank commit means nothing, where the other two entries' blank commit is the
  take-back. **`docs/adr/1033`** is amended in place — its stated reversal trigger was the fourth
  kind, this is it, and what it records is that the trigger fired and the general take-back was
  still not taken.
- **`CONTEXT.md`** already carries **Addition** and **Total entry** and the amendments to **Total**
  and **Row**, landed by the grill. This change adds no term of its own.
- **Nothing on any phone moves.** A record written at form 4 reads back unchanged and is rewritten
  at form 5 only when the next change is kept there.
- **A known gap closes and another is recorded.** The data clump `docs/open-questions.md` recorded
  against this Story is closed here by labelling the parameters; the public-surface gap gains its
  thirteenth and fourteenth faces, and the general record reader — the one thing `grill.md` left
  open — is recorded there rather than built here.
