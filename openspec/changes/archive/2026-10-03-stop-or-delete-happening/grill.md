# Grill — stop-or-delete-happening

*15 questions over 4 rounds, 2026-10-03 — the last two the layout round and its follow-up.*

The Feature grill of B-076 settled what stopping and deleting are: stopping one takes it off the day
screen and keeps every occurrence; deleting one removes it with them (`CONTEXT.md` § *Happening*).
This grill settled the edges.

## Settled

1. **Resume.** A stopped happening can be resumed, with every occurrence it held. *The same verb a
   commitment has; nothing is owed, so resuming only puts it back on offer.*
2. **Past rows.** A stopped happening's happening rows still draw on the days it came. *Stopping
   withdraws it from noting, not from the record.*
3. **Name.** A stopped happening keeps its name: a second happening of that name is refused, judged
   as adding judges names. *It is still a happening, as a stopped commitment is still a commitment,
   and a resume can then never collide.*
4. **Deletion is confirmed by typing the name back**, as a commitment's deletion is. *Equally
   unrecoverable, and no copy holds happenings until #380.*
5. **History stays editable.** A tap on a stopped happening's row still changes or takes back its
   occurrences. *Only noting a new one is withdrawn.*
6. **A stop has no day.** A stopped happening is offered for noting on no day, past days included;
   backfilling is resume, note, stop. *A stopped-from date would be a second thing stored and shown
   for a rare case.*
7. **Stopping is confirmed**, as a commitment's stop is — an ask with a stop and a cancel. *The owner
   chose this over the recommended no confirmation: it matches the commitment it sits beside.*
8. **Resume returns it to its place** in the order made, in the commitments screen's list and the day
   screen's menu alike. *As a rename keeps its place.*
9. **A stopped happening can be renamed.** *That is how its held name is freed.*
10. **The delete sheet says how many occurrences go with it**, and says so when there are none.
    *Typing the name confirms which happening; the count says what is lost.*
11. **The walk** — six pictures, no `phone:` line: the stop confirmation; the commitments screen
    with one happening stopped; the day screen's note-a-happening menu without it; a past day still
    drawing its row; the delete sheet with the name typed back; that day after the deletion, the row
    gone. *Every step is a swipe or typing, which the simulator drives.*
12. **The stop confirmation's words** — title "Stop noting this happening?", buttons "Stop noting
    Kopfweh" and "Cancel". *"Keeping" is a commitment's word; noting is what a stop withdraws.*
13. **The delete sheet's occurrence line** — "Its 12 occurrences go with it.", "Its 1 occurrence goes
    with it.", and "It has no occurrences." where there are none.

Taken from the commitment as precedent, not asked: resume asks for no confirmation; a happening is
deletable stopped or not; the name typed back is matched exactly as a commitment's is.

## Terms landed in CONTEXT.md

- **Happening** — amended: what a **stopped** happening still does and what it no longer does, how
  stopping, resuming and deleting are confirmed.

## Left open

None. Where a stopped happening sits was the layout round's, below; how the store records a stop is
`spec-author`'s.

## Layout

Option B, **in place**, chosen from three at https://claude.ai/artifact/1PukkaV1NRwFXQdzvnr95s over
the designer's recommended A (a section of its own). A stopped happening keeps its row in the
Happenings card, in the order made, and never moves; the row says "- Stopped" in the slot where a
commitment's row says its rhythm, in the same small secondary type — chosen over a greyed name with
no word. Resume removes the word. Settled 8 therefore moves nothing in the list; it is the day
screen's menu that a resumed happening returns to, in its place.

The wireframe, verbatim from the designer (column B of three):

```
B · In place
┌──────────────────────────────────┐
│ (<) Commitments        [⇅  +]    │
│  … kept groups, as on main …     │
│ Stopped                          │
│ │ Nothing has been stopped.    │ │
│ Happenings                       │
│ │ Augenmigräne               > │ │
│ │ Kopfweh - Stopped (ex)     > │ │
│ │ Schlecht geschlafen        > │ │
│ │ New happening                │ │
└──────────────────────────────────┘
 "- Stopped" sits in the rhythm's
 slot, caption size, secondary
 colour; resume removes the word.
```

Rows, as the designer drew them for every option: a happening not stopped swipes leading to Edit
(rename) and trailing to Stop (orange `stop.circle`) and Delete (red `trash`); a stopped one swipes
leading to Edit and trailing to Resume (accent `play.circle`, one tap, no confirmation) and Delete;
a tap on either opens its look-back.

```
Stop confirmation (.alert, as a commitment's)     Delete sheet (as a commitment's)
┌──────────────────────────────────┐              ┌──────────────────────────────────┐
│   <title> (ex)                   │              │ Cancel   Delete Kopfweh   Delete │  ← Delete disabled until
│   [ <stop button> (ex) ]  red    │              │ TYPE "KOPFWEH" TO DELETE IT FOR  │    the name matches
│   [ Cancel ]                     │              │ GOOD.                            │
└──────────────────────────────────┘              │ │ Name                         │ │
                                                  │ <occurrence count line> (ex)     │  ← footer: e.g. "Its 12
                                                  └──────────────────────────────────┘    occurrences go with it." /
                                                                                          none-case sentence
```

The `(ex)` words are settled now — the marker above, the confirmation at Settled 12, the count line
at Settled 13. The commitment sheet's "The copy in Files follows…" line is not drawn for a
happening: no copy holds one until #380.
