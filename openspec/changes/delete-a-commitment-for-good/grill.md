# Grill — delete-a-commitment-for-good

*11 questions over 4 rounds, the last the layout round, 2026-09-23, on the G1 answers of 2026-09-21 (`docs/backlog.md`
§ *Decided*, B-057). One fact agent; no fact sent to the owner.*

## Settled

1. **Commitments removed after #303 shipped.** At the upgrade they are erased with every record
   against them, silently, as deleted ones are. *Each was already confirmed by typing its name
   back, and it is the call the fold made for removed entries nothing live resembled.*
2. **Typing the name back.** The same rule removal ships: trimmed at both ends, case and inner
   blank space both count. *Delete guards the one loss the phone cannot undo; it is not looser.*
3. **Dated copies made on request.** Delete leaves them alone. The sheet says the copy in Files
   follows and promises nothing about any other copy. *They are files the person made on
   purpose, and "gone for good" would be untrue whenever one predates the delete.*
4. **A store that cannot be written.** All or nothing: if the roster or the record cannot be
   written, both are left as they were and the refusal shows where a refused removal shows today.
   *The guarantee a change that carries records already gives.*
5. **Restoring a copy of an emptied roster.** It stays empty: the mark that the roster was
   emptied on purpose travels in the copy. Only a fresh install gets day one. *A restore gives back
   exactly what was there.*
6. **What the sheet says is lost.** The name only; no count of days. *Typing the name is the
   confirmation, and a count raises what a day counts as.*
7. **An emptied roster on screen.** As shipped: the day screen draws only its One-offs group, the
   commitments screen "Nothing is being kept." No new strings. *An empty day is an honest picture.*
8. **An upgrade that erases every commitment** (all of them removed). The roster stays empty and
   carries the mark, as a delete would. *Every removal was deliberate.*
9. **The walk.** Four pictures, no `phone:` line — a swipe drives in the simulator:
   - the sheet with the name typed wrong (Delete disabled), then typed right;
   - the commitments screen with the deleted commitment gone, from the kept list and the stopped;
   - a past day it had a tick on, drawn without it;
   - the last commitment deleted, the app relaunched, and the day screen still holding none.
10. **No copy place picked, or forgotten.** The sheet drops the Files sentence and only asks for
    the name. *Without a copy place nothing follows, and the sheet says only what is true.
    Asked in the layout round: the designer found it drawing the sheet, a question the grill
    should have asked.*

## Terms landed in CONTEXT.md

- **Deleted** — amended: the emptied mark travels in the copy, and dated copies are untouched.
- **Removed** — amended: what the state still holds at the upgrade is erased, not kept.

## Layout

Option B, *Field alone*, chosen from three at https://claude.ai/artifact/YAQkQVSBLRLZfP6q6m3du5,
against the designer's recommendation of A. Both strings on the mockup are example wording; the
wording is `spec-author`'s. The wireframe follows, verbatim from the designer.

```
B · Field alone
┌────────────────────────────────┐
│ (Cancel)              (Delete)③│
│ Delete Gym                     │
│ ① Type "Gym" to delete it for  │  section header, secondary grey
│   good.                        │
│ ╭────────────────────────────╮ │
│ │  Gym|                      │ │
│ ╰────────────────────────────╯ │
│ ② The copy in Files follows,   │  section footer
│   so it will not hold Gym      │
│   either.                      │
│ [ keyboard ]                   │
└────────────────────────────────┘
```

## Left open

None. Every question the frontier raised was answered; how the emptied mark is stored and how
the two writes are made all-or-nothing are `spec-author`'s, not preferences.
