## Why

A person can stop keeping a commitment, and that is all they can do with one they no longer want.
A mistyped name, a rhythm that was never right, one of day one's eight the owner has never once
kept — each of those lands on the stopped list and stays there for ever, beside the things they
genuinely stopped and might take up again. The one list that exists so a stop costs one tap to undo
is also the list nothing ever leaves, and it grows.

**B-031** is the want — *"get rid of a commitment for good, not just stop keeping it"* —
`FEAT: commitment` (#26) is the Feature this Story hangs off, and #144 (`add-rhythm-in-words`,
B-021) is the blocker that closed first, because a person about to type a name back to confirm a
removal needs to be able to tell two commitments called "Vitamins" apart.

**Getting rid of something for good is not the same as forgetting it**, and the whole of this change
turns on that sentence. The owner settled it at the grill in one line — *"Past days should not lose
their rows, they should still be there even after a commitment was stopped or removed."* A removal
that dropped the commitment out of the roster would take every past day's row with it and would
erase, on the day a person tidies their list, the record the product exists to keep. So the roster
gains a third state rather than losing an entry, and `record` is not touched at all.

## What Changes

- **A roster removes a commitment, and never lets one go.** *Removed* is a third state a roster
  holds a commitment in, beside kept and stopped: still there, in the place it was taken on in, with
  the day it was **kept until**, and answered about a date exactly as a stopped commitment is.
  Removing is a last state, not a departure. **ADR-1035** records the decision and the two
  alternatives it was chosen over.
- **A commitments screen removes a commitment from either list**, and it is the one change the
  screen makes only after the person has typed the commitment's name back. The screen answers
  whether what has been typed matches — trimmed of surrounding blank space, otherwise exact —
  and confirming on a name that does not match changes nothing and says nothing. There is no
  refusal to word: the button is simply not one you can press yet.
- **A removed commitment is in neither list.** The one way back is to define the identical
  commitment again, which the roster already takes as taking it up again, in its old place and with
  its history.
- **BREAKING (behaviour, not data): stopping now keeps a commitment until the day *before* the one
  the commitments screen was handed**, and so does removing a kept one. Today a stopped row lingers
  on the day's screen it was stopped on, which reads as a stop that failed. Decided against the
  recommendation and reaffirmed after its cost was stated: a tick made this morning on a commitment
  stopped this afternoon is not drawn today, though the record stands and the row returns if the
  commitment is taken up again. **ADR-1023 is amended in place.**
- **The roster's file moves to a third form.** One more field per entry, written at that form and
  at no earlier one — and a document whose declared form and whose shape disagree is refused, in
  both directions. That is ADR-1031 as it has read since `add-number-record` (#138) amended it on
  2026-09-06; the roster copies what the record already does, and the record needs no further
  amendment.
- **The commitments screen's rows become swipe actions**, all three of them: a kept row swipes to
  stop or remove, a stopped row to resume or remove, and the row's own tap does nothing. Shell work,
  riding this Story under ADR-1019's 2026-09-04 exception and named as its own `tasks.md` section.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: the roster gains removal and a third state; the roster store keeps it and reads the
  two forms before it; the commitments screen removes on a typed-back name, stops a day earlier, and
  lists a removed commitment nowhere.
- `day-screen`: a removed commitment has a row on every day up to the day it was kept until, exactly
  as a stopped one does, and a roster whose commitments have all been removed is still not a roster
  holding nothing — so day one is not written over it.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `Roster`, `RosterDocument`, `RosterStore`,
  `CommitmentsScreen`. No new file behind the seam except what `tasks.md` names.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — the swipe actions and the typed-name
  confirmation, under ADR-1019's exception.
- `docs/adr/` — ADR-1035 written; ADR-1023 amended in place and stamped. ADR-1031 is **not**
  amended: its own trigger now names a fourth form, and this is a third differing by one field.
- **Not touched:** the `record` and `schedule` capabilities, `RecordStore`, `History`, `Tick`, and
  every tick already recorded. That is the point of the change rather than an omission.
