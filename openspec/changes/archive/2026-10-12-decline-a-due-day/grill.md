# Grill — decline-a-due-day

*12 questions over 3 rounds, the last the layout round, 2026-10-11, after the twenty-sixth grooming pass's Feature grill (B-079),
whose 17 answers are in `docs/backlog.md` § Decided and `CONTEXT.md` § Declined. One fact agent.*

## Settled at the Feature grill, carried here

- A **declined** day is still owed and not kept, with an optional typed reason; it is a record of its
  own, never keeping, at most one per commitment per day (`CONTEXT.md` § Declined, § Record amended).
- Kept or declined, never both: keeping a declined day replaces the decline, reason and all; a decline
  taken back leaves the day holding nothing.
- Every kind can be declined except a weekly quota's; a decline is offered wherever a tick is — a past
  day included, a day that has not arrived never.
- This Story is the row and the record. A look-back still counts a declined day as unkept; saying how
  many were declined is #403. Days away are #401 and #402.

## Settled

1. **A day that already holds something cannot be declined.** Offered only where the day holds
   nothing — not a tick, a number, a note, nor a total's additions short of its target. *A decline
   never overwrites a typed value; to decline a ticked day, take the tick back first.*
2. **The reason can be added, changed or cleared after declining**, the way a note is. Clearing it
   leaves the decline standing; taking the decline back is its own act. *Decline in the moment, add
   the why later if it was skipped.*
3. **A declined day cannot be shifted**, as a ticked day cannot. *A declined day is a decided day;
   moving it means taking the decline back first.*
4. **A decline on the day a stop is made counts as a record standing there**, so the stop is made as
   of that day and the decline stays shown in the last era, as a tick would. *Otherwise the decline
   just made disappears into the gap.*
5. **Decline is reached from the row's long-press menu, beside "Shift to".** ADR-1042 keeps day rows
   swipe-free. A row with no free day to shift to gets a menu holding Decline alone; a weekly
   quota's row and a row holding a record get none, as today. On a declined row the same menu holds
   the reason and taking the decline back. Nothing new shows at rest on an undeclined row.
6. **The reason is asked at the moment of declining, and is optional:** a small sheet with the reason
   field and a Decline button that works with the field empty. *The why is freshest then; one tap
   more than declining outright.*
7. **A declined row shows, at rest, a declined mark in the check's place and its reason under the
   name, cut to one line.** *The why is what tells the day from a forgotten one.* The owner chose this
   over the number and note rows' rule of drawing nothing of the value at rest, knowingly.
8. **The walk**, every line on the simulator except the last:
   1. an unticked row's long-press menu, showing Decline;
   2. the reason sheet;
   3. the declined row at rest, mark and reason;
   4. the declined row tapped — now kept;
   5. a decline taken back — the row empty again;
   6. a ticked row's and a weekly quota row's long press, neither offering Decline;
   7. yesterday, reached by paging back, declined;
   8. `phone:` a declined row in dark — this machine's simulator cannot draw dark
      (`docs/open-questions.md` § Known gaps).

9. **The declined row's long-press menu says "Reason" and "Take back".** *"Take back" is the app's
   word for undoing a record.*
10. **The reason sheet, opened later to change a reason, confirms with "Save";** "Decline" is the
    word only at the moment of declining. *Pressing Decline on a day already declined says something
    that is not happening.* The placeholder is "Reason (optional)", as the app says "Category
    (optional)".
11. **"Take back" is red**, as every Take back in the app is. *Red marks an act that removes a record,
    not a bad day; ADR-1045's colours for the row are untouched.*

## Facts the delta turns on, for spec-author

The fact agent counted 33 shipped requirements that enumerate record kinds or rely on "any record":
15 need a decline added, 6 need it excluded by name, 12 inherit it through "record". The code
enumerates the four kinds by hand in `holdsARecord`, `datesRecorded` and `formCopy`, so a generic
"record" in the spec does not reach them. The record form is 8 and the copy form 3. A note has no
length limit. A copy carries the whole history, so a decline travels in it.

## Terms landed in CONTEXT.md

None in this grill. **Declined** landed at the Feature grill and **Record** was amended there.

## Layout

Option A, *Dash*, chosen from three at https://claude.ai/artifact/JKBXJW6iRm73GNygGfJ2G6 — *a declined
day is still owed, so its name stays plain like a day nobody recorded and only the mark and the reason
set it apart; a grey dash judges the day least, where B's grey name already means kept (ADR-1045
decision 5) and C's ring recalls the circle ADR-1045 took back.* The wireframe follows, verbatim from
the designer; its "Reason" and "Take back" are settled above (9).

```
A · Dash                                   (recommended)
  │ ~~Creatine~~ - Every day             ✓ │  kept: grey struck name, green check (as today)
  │ Magnesium - Every day                — │  declined: plain name, grey dash
  │   Ran out                              │  reason: grey caption, one line
  │ Nails - Every 4 days                   │  unrecorded: nothing
  │ Run - Tue, Thu, Sun                  — │
  │   Knee still sore after Tuesday's r…   │  cut to one line
  │ Yuno - 2/5x a week                     │  weekly quota: never declined
  │ Weight - Every day                 — › │  entry row: dash, then chevron; no reason, no line

  Reason sheet (short, keyboard up)
  ┌──────────────────────────────────────┐
  │ (Cancel)        Run        (Decline) │  Decline works with the field empty
  │ ┌──────────────────────────────────┐ │
  │ │ Reason (optional)                │ │
  │ └──────────────────────────────────┘ │
  └──────────────────────────────────────┘

  Long press on a declined row
  │ Run - Tue, Thu, Sun                  — │  ← row lifted
  │   Knee still sore after Tuesday's r…   │
     ┌──────────────────────────────┐
     │ Knee still sore after        │  whole reason, grey, uncut
     │ Tuesday's run, resting it…   │
     ├──────────────────────────────┤
     │ Reason                       │
     │ Take back                    │  red, as the app's other Take back
     └──────────────────────────────┘
```

The menu on an undeclined row, shared by all three options:

```
  │ Nails - Every 4 days                   │  ← row lifted
  ┌──────────────────────┐
  │ Shift to           › │  as today
  │ Decline              │  added below; alone where no free day exists
  └──────────────────────┘
```

## Left open

None. Every question the frontier raised was answered, the layout round included.
