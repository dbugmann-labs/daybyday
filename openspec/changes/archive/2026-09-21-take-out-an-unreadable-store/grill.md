# Grill — take-out-an-unreadable-store

*13 questions over 4 rounds, the last the layout round, 2026-09-21. Every answer was the
recommendation. Facts came from one
dispatched read of the tracker, `docs/backlog.md`, `docs/open-questions.md`, `CONTEXT.md`, the
restore, day-screen and commitment specs, the archived #266/#267/#268 folders and the shell.*

Already settled before this grill, and not re-asked: take-out is the bytes as they lie (ADR-1054);
the day screen's line says a copy can be restored and where, "and no more", and says nothing on a
fresh install (CONTEXT.md § *Day screen without its record*, amended 2026-09-15); a refused change is
held one at a time and its words are the shell's.

## Settled

1. **What leaves the phone.** All three store files — `record.json`, `roster.json`,
   `one-offs.json` — whenever any one of them cannot be read, not only the one that refused.
   *A copy is refused whole when one place cannot be read, so the readable two have no way off the
   phone before a restore overwrites them; "only the broken file" would leave them trapped.*
2. **When it is offered.** Only while a store cannot be read, on the commitments screen, where the
   copy is refused; absent on a working phone. *A permanent raw-file export beside Make a copy would
   hand out torn saves and old forms that ADR-1054 deliberately keeps off the phone.*
3. **A store written by a newer version.** Take-out is offered for it too. *It reads and changes
   nothing, so it cannot harm the file the day screen says must not be deleted, and it is the only
   safeguard if the update never comes.*
4. **A copy refused over a newer-version store says so.** The refused copy tells a later-form
   store apart — "from a newer version" rather than "could not be read" — as the roster line and
   the restore refusal already do. *This closes the open question at `docs/open-questions.md`
   § "A roster from a later version is given two causes at once when a copy is asked for", which
   was left to this grill; the same file no longer carries two causes on one screen.* The delta
   should retire that entry.
5. **The day screen's line.** One line, whatever the number of stores not kept, naming the
   commitments screen as where a copy can be restored — words the shell's, along the lines of
   "A copy can be restored from Commitments". It is drawn for a record or one-offs that cannot be
   read and for a roster that is not kept for either of its two causes (could not be read, could
   not be written). It is **not** drawn when the only cause is a newer version. *A restore
   invitation next to "must not be deleted" invites overwriting the file; and the roster's two
   causes are not told apart today, which is #91's work and not this Story's — a restore over an
   unwritable place fails with restore's own refusal.* The line is text, not a control: the
   toolbar's Commitments button already goes there ungated.
6. **The restore confirmation.** Unchanged. It does not point at take-out when the store it
   replaces cannot be read. *The notice already says the store cannot be read, take-out sits in the
   section the person just tapped Restore in, and a second sentence in a destructive sheet would
   modify #267's shipped requirement.*
7. **A torn save or torn restore that cannot be undone.** Take-out hands out whatever lies at the
   places: the three stores plus any `save-in-progress.json` or `restore-in-progress.json` present.
   *The day screen reports the stores unreadable in that state while the store files may be
   intact; the half-written file is what a person recovering needs, and leaving it behind hands out
   a puzzle with a piece missing.* `copy-place.json` is a setting, not a place, and does not go.
8. **The shape.** One share sheet carrying several files, each under the name it lies under.
   *Which file is broken stays visible, and there is no archive format to invent; the Files app
   cannot see Application Support, so the sheet is the only door.* How the files reach the sheet
   without leaving a trace on the phone is `spec-author`'s to design, as the copy's temporary
   directory was.
9. **When take-out itself fails** — a file the phone will not hand over as bytes. One refused
   change naming the store that could not be taken out, held like a refused copy, and no new case.
   *The locked-before-first-unlock distinction stays the known gap at `docs/open-questions.md`
   § "RecordStore.init can throw raw Foundation errors"; this Story is the way out, not the
   diagnosis.*
10. **Afterwards.** Nothing on the screen: no line, no date. *The screen cannot know whether the
    share sheet kept anything — the copy's reasoning, unchanged.*
11. **The walk.** Four pictures, no `phone:` line: the day screen under an unreadable record with
    the restore line; the commitments screen's Copy section with take-out beside the refused
    copy; the share sheet open with the files listed; the Copy section over a newer-version store
    saying the copy is refused because of a newer version. *Save to Files works in the simulator;
    #266's walk staged an unreadable record by swapping the file in the simulator container.*
12. **The roster's "not kept".** Covered in 5: the line is drawn for it, both causes.
13. **The take-out row says why.** *Asked in the layout round, because drawing it showed the gap:
    the row appears from the store's state, but the commitments screen says nothing about an
    unreadable record or one-offs until Make a copy is tapped, so the row could stand with no cause
    near it.* Whenever the row is drawn, a caption with it names the store or stores that cannot be
    read, or that are from a newer version; a refused copy after a tap repeats the cause, which is
    bearable. Words the shell's. This is a finding about the grill — it was askable in round 2.

## Terms landed in CONTEXT.md

- **Take-out** — the files of the three places leaving the phone exactly as they lie, through the
  share sheet, offered only while a store cannot be read or is from a later version; not a copy.

No ADR. The decision that take-out is bytes rather than values is already ADR-1054's, and nothing
here is hard to reverse.

## Left open

None. Every question the frontier raised was answered; the one question `docs/open-questions.md`
left to this grill is settled as 4 above.

## Layout

Option B, take-out under the refused copy, chosen from three at
https://claude.ai/artifact/EMBZufLbQ6PCKkq1dVWRVg — *the way out sits with the line that names the
cause, which is this screen's own rule since #261; it costs Restore from a copy one row of movement
while a store cannot be read.* The day screen's restore line takes the grey (secondary) treatment,
not red: the red lines are the trouble, and the way out should not read as a third thing wrong.
The strings drawn are examples and the delta settles them; per 13 above, the take-out row carries a
caption naming the cause, which the mockup did not draw. The wireframe follows, verbatim from the
designer.

```
OPTION B - take-out under the refused copy  (recommended)
+-----------------------------------+
| <                     up/dn    +  |
| Commitments                       |
+-----------------------------------+
|  STOPPED                          |
|  +-----------------------------+  |
|  | Nothing has been stopped.   |  |
|  +-----------------------------+  |
|                                   |
|  COPY                             |
|  +-----------------------------+  |
|  | Copy place   Pick a folder >|  |
|  | Make a copy                 |  |
|  | Your record could not be    |  |  <- red, after Make a copy
|  |   read.                     |  |
|  | Take out the files          |  |  <- drawn only while a store
|  | Restore from a copy         |  |     cannot be read or is from
|  +-----------------------------+  |     a newer version
|  Pick a folder to keep a copy      |
|  there.                           |
+-----------------------------------+
   take-out refused : a red caption row between Take out the files
                      and Restore from a copy
   day screen line  : secondary grey, one line under the causes


THE DAY SCREEN - with a record that cannot be read
+-----------------------------------+
|                  Commitments   +  |
|                                   |
|  <         Wed  16 Sep 2026    >  |
|  The record could not be read.    |  <- red, shipped
|  A copy can be restored from      |  <- secondary grey
|    Commitments                    |
|                                   |
|  +-----------------------------+  |
|  | Creatine  - Every day       |  |
|  | Magnesium - Every day       |  |
|  | Gym       - Mon, Wed, Sat   |  |
|  +-----------------------------+  |
+-----------------------------------+
   one line whatever the number of stores not kept; text, not a control
```

Two more things the designer noted, for `spec-author`: the newer-version copy refusal (4) is a
string in the same row, not a layout, so the walk's fourth picture is the second picture's layout
with different words; and with a copy place set, the Copy section's footer also carries a red
"Stopped since …: your record could not be read", so the busiest real state has two red runs plus
take-out — worth a glance at the walk, not a layout question.
