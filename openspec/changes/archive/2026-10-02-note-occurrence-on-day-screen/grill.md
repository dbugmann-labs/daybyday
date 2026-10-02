# Grill — note-occurrence-on-day-screen

*25 questions over 6 rounds, 2026-10-02, and two fact agents. Q7's answer removed the day-list group
the second round had assumed; the future-day question asked about it is settled again as 11 below,
and two group questions were never asked.*

## Settled

1. **The time on a past day.** It starts blank and can be set. *Nothing on a past day says when it
   came; a guessed time is one nobody chose.*
2. **Clearing the time on today.** Allowed: the time is optional everywhere, so an occurrence noted
   on today may hold its date alone. *A bad night has no minute.*
3. **A time later than now on today.** Refused. *"Never on a day that has not arrived", carried down
   to the minute.*
4. **The note's shape.** Multi-line text — the owner's call against the recommendation of one line.
   *Recommended: blank space around it trimmed, and a note of blank space alone is no note; no cap.*
5. **Noting before the happening was made.** Allowed. *A happening has no day it is kept from, and
   back-filling is the first thing done after making one.*
6. **What came, as one row.** The happening's name with that day's times inline — "Kopfweh · 09:10,
   18:40" — the owner's call against one line per occurrence; notes are not shown on it.
7. **No group in the day list.** The owner, against a placement in the list: "they don't sit
   anywhere really — but it should be possible to open the list via button or similar to then record
   one from the day screen." A button on the day screen opens the list of happenings; one is picked
   there to note an occurrence on the day shown. Where the button sits is the layout round's.
   `CONTEXT.md` § *Happening* amended.
8. **Picking a happening from the list.** Opens a sheet holding the time — the current one on today,
   blank on a past day, clearable either way — and the multi-line note; Save notes one more
   occurrence. *A stray tap costs nothing, which matters while nothing can be taken back before
   #377.*
9. **What came, and the "nothing is due" line.** A happening is not due, so the line still shows on
   a day where nothing else is drawn, beside a row of what came. *Answered for a group before Q7
   removed it; the half that survives is the line.*
10. **What came, where and when.** A row only on a day something came, at the foot of the list.
    Nothing is drawn for a happening on a day it did not come. *It also gives #377 a thing to tap
    for change and take-back.*
11. **When the button is drawn.** Not on a future day, and not while no happening exists — a
    happening is made on the commitments screen. *A screen draws only what it offers.*
12. **A happening store that cannot be read.** A line in the day screen's red store card, as the
    one-offs have — that the happenings could not be read, or were written by a later version — and
    no button.
13. **The list's order.** The order made, as on the commitments screen. *A name's place never moves
    under the thumb.*
14. **An untimed occurrence in the row.** Said as "no time", after the timed ones, which run earliest
    first: "Kopfweh · 09:10, 18:40, no time". *Every occurrence stays visible as itself.*
15. **Tapping the row of what came.** Does nothing in this Story; #377 decides. *A tap given now is
    one #377 would have to take away.*
16. **The list marks nothing.** Names only, with no mark for what already came that day. *The row
    already says it.*
17. **After Save.** A kept note closes the sheet and the list, and the row is drawn on the day. A
    note that cannot be kept is refused as not kept, said in the sheet, which stays open with what was
    typed.
18. **The same happening twice at one minute.** Two occurrences, both counted. *Each occurrence
    counts on its own, and untimed ones on one day already repeat by design.*
19. **The walk.** Seven screens: today with the button; the list opened; the note sheet on today,
    its time pre-filled; today after two notes, "Kopfweh · 09:10, no time"; the note sheet on a past
    day, its time blank; a future day with no button; a happening store that cannot be read, its
    card line and no button.
20. **What the phone proves.** Setting and clearing a time with the time picker, and typing a
    multi-line note with the keyboard up — two `phone:` lines.
21. **Facts the round stood on** (the fact agent, not the owner): no time-of-day picker exists in
    the app yet; the note-commitment sheet already has a multi-line note field; the happening store
    writes form 1 and `add-happening`'s design planned occurrences keyed to the identity with no
    change of form; the day screen knows nothing of happenings today.
22. **The note sheet's time row.** Labelled "Time"; a time set shows as a time with a clear button,
    and a blank one reads "No time" and is tapped to set one. *It matches "no time" in the row.*
23. **The note sheet's words.** Titled with the happening's name, as the note-commitment sheet takes
    its row's; a note that cannot be kept says the app's existing "Not saved. Try again."
24. **The button.** A bolt, spoken as "Note a happening". *Something that came to you, and unlike
    the `+` and the list icon already on screen.*

## Terms landed in CONTEXT.md

- **Happening** — amended: the day view draws no group; a button opens the list of happenings, and
  what came is a row only on a day something came.

## Layout

Option B, the foot menu, chosen from three at https://claude.ai/artifact/UbQtkwXn4LAMc2nfoqew7n —
*a menu is the lightest list, it sits at the foot beside the other place things are entered, in reach
of the thumb, and it leaves the toolbar and the date row doing what they do now.* Its cost, accepted:
the "New one-off" field narrows on today and past days and runs full width on a future day. The head
of the wireframe was checked against `origin/main`'s day screen (90ae2da) and matches it on today.
The wireframe follows, verbatim from the designer; the bolt is the glyph settled in 24, not a stand-in.

```
B · Foot menu   (recommended)
              [☰ ⚙]
Friday
Today, 2 October 2026
‹ M28 T29 W30 T1 (F2) S3 S4 ›
┌ Creatine - Every day
│ …
└ Protein - Every day  35 of 120 ›
┌ Kopfweh · 09:10, 18:40, no time
└
( New one-off              ) (⚡)   ⚡ beside the field, at the foot

⚡ → menu rising from the button, order made, top to bottom
              ┌ Augenmigräne
              │ Kopfweh
              └ Schlecht geschlafen
                               (⚡)
name → sheet of its own over the day
[Cancel]   Kopfweh    [Save]
┌ Time          [18:52] ⓧ
┌ note, multi-line|
[keyboard]
Future day: no ⚡, the field runs full width
```

The row of what came is its own card with no heading, at the foot of the list.

## Left open

None for the owner. Every question the frontier raised was answered. Three things the drawing turned
up are facts or the delta's, not preferences, and go to `spec-author`: whether SwiftUI's default menu
order puts the first item nearest a button at the foot — which would draw the list upside down against
13 and need a fixed order (the app uses one `Menu`, `CommitmentsView.swift:963`, and sets no
`.menuOrder` anywhere); whether a menu cuts a long happening name short; and whether the seam hands the
row of what came over as one string or as a name and its times.
