# Grill — change-days-away

*15 questions over 5 rounds, 2026-10-13, with one fact agent and the designer. Every answer was as recommended
except one: a span's picks can be changed, not only its ends and name. The intent's "no day it gives
back holds a record" is worded both ways in the sources (`CONTEXT.md` and the B-080 Decided line);
answers 2 and 6 settle it as the days a span newly takes, never the days it returns.*

## Settled

1. **Everything on a span can be changed**: its first and last day, its name, and the commitments
   picked. *Against the recommendation of ends and name only; #401's grill had left picks to
   remove-and-say-again.*
2. **Removing a span already begun erases it whole**, as though it had never been said: its past
   days are owed again, empty, and open to a record after the fact. *Coming home early is moving the
   last day; remove is for "I never went".*
3. **Every span is listed**, not only until its last day passes: those not over earliest first, then
   past ones latest first. *A span said wholly in the past would otherwise vanish the moment it was
   added, and the list is the only place to fix one.*
4. **No limit on how far back** days away may be said or moved. *The guards are records, kept-from
   dates and shifts, not a window.* #401's refusal of a first day before today goes.
5. **Remove is offered on every listed span**, past ones included, with #401's alert first.
6. **The record condition.** Saying or changing a span is refused while it would put under days
   away a day already holding a record — tick, number, note, entry or decline — of a commitment
   picked; nothing is kept, and the refusal names the commitment and the day. *A record under a gap
   is shown nowhere, so this is the one change that would lose something.* #401's answer 4 stands:
   a first day that is today, holding a record, keeps that commitment through it instead. Days a
   change gives back are never refused: past ones come back owed and empty, as in answer 2.
7. **Ticking a commitment onto a span runs every check saying runs** — not stopped, no record under
   it (answer 6), kept from no later than the first day, no shift with a day inside, no overlap with
   other days away it is in. **Unticking one gives its days back**, as answer 2 does.
8. **A stopped commitment already in a span is shown ticked and can be unticked**, giving back its
   days up to its stop. A stopped commitment not in the span is still not offered.
9. **A listed span is opened for change by a leading swipe, Edit**, as commitment and happening rows
   are; the sheet opens filled. Tap stays inert. The trailing Remove stays.
10. **The known gap is folded in.** A roster holding two days away with one identity is refused, as
    `happening` refuses two happenings with one; the entry in `docs/open-questions.md` § *Known gaps*
    goes. *Changing a span by its identity would hit the same duplicate that removing does.*
11. **A commitment changed while away keeps its new rhythm from the day back it had.** Erasing the
    span closes the gap and moves nothing else; moving the last day moves the day back, and the new
    rhythm, range or target moves with it. *The day the change was made is not remembered.*
12. **A stopped commitment in a span whose days move past its stop is allowed**: its part of the span
    ends at its stop, since it owes nothing after it either way, and a span moved wholly past the
    stop takes it out, as a stop does today.
13. **The walk**, with spans said over past days so a span under way can be shown:
    1. the commitments screen listing an upcoming span and a past one;
    2. Edit on a span, and the filled sheet;
    3. the last day moved — the list and the day screen showing it;
    4. a commitment ticked on over a recorded day, refused naming the commitment and the day;
    5. a span said over past days, and the day screen on one of them;
    6. a begun span removed, its past day back with its rows owed and empty.

    No `phone:` lines: nothing here is a gesture a simulator cannot drive.
14. **Cancelling the sheet after an edit asks first**, "Discard changes?" in the commitment change
    sheet's own words, only once something has been edited. Saying new days away still asks nothing.
    *Asked in the layout round; the designer found the two sheets differ.*
15. **The sheet opened by Edit is titled "Change <name>"**, and "Change Away" for a span with no
    name, the word the day screen and the list already use for one. Its button reads "Save".

Carried from #401 and the G1 grill, not re-asked: an every-N-days count begins again on the day back,
wherever it moves, and runs on unbroken when the span is erased and the eras either side are alike;
overlap, kept-from and shift refusals apply to a span as changed, never against itself; a span over
nothing cannot be saved; a change or removal writes the copy as saying does; the day screen's away
line and the week strip's dots follow the span's days.

Facts `spec-author` will need, from the fact agent: the shipped first-day bound is
`CommitmentsScreen.swift:119-124` and spec requirement at `commitment/spec.md:8310`; the span keeps no
record of answer 4's "kept through the first day", which lives only in the eras, and `fillGap`
(`Roster.swift:1112`) returns early when an era holds the first or last day, so removing such a span
today would leave the gap standing.

## Terms landed in CONTEXT.md

- **Days away** — amended: said over past days without limit; every span listed; days, name and
  picks changeable; any span removable, erasing it whole; refused while it would put a recorded day
  under it; a change made while away keeps its rhythm from the day back.

## Layout

Option C, *Past set apart*, chosen from three at https://claude.ai/artifact/Vy9hwfRDwuhsAuHphkDUJz —
*every span is now listed for good, so past ones pile up; C keeps what is not over and "New days
away" in the first card, and puts past spans in a second card below with no header, so no new words
on the screen.* On the sheet: "Change Mallorca" and Save; a stopped pick under a "Stopped" header, the
screen's own word for that list; the record refusal under the commitment it names, other refusals at
the foot. Past spans are not faded: they still offer Edit and Remove (ADR-1045 fades only what offers
nothing). The refusal's words in the mockup are example wording; the grill settled what it names.
A stopped commitment unticked while the sheet is open stays on the sheet, unticked, until Save — the
designer's reading of answer 8, for `spec-author` to state. The wireframe follows, verbatim from the
designer.

```
C · Past set apart  (recommended)
Commitments screen                     Sheet (Edit on a span)
│ Days away                       │    │ Cancel  Change Mallorca    Save │
│ ┌─────────────────────────────┐ │    │ ┌ Mallorca / First / Last ────┐ │
│ │ Mallorca - Sat 10 Oct – Sun │ │    │ Commitments to pause            │
│ │   18 Oct / Gym, Run         │ │    │ ┌─────────────────────────────┐ │
│ │ Away - Sat 31 Oct/Creatine  │ │    │ │ ○ Creatine - Every day      │ │
│ │ New days away               │ │    │ │ ● Gym - Mon, Wed, Sat       │ │
│ └─────────────────────────────┘ │    │ │ ● Yuno - 5x a week          │ │
│ ┌─────────────────────────────┐ │    │ │   <refusal naming Yuno, red>│ │
│ │ Sick - Mon 5 Oct – Wed 7 Oct│ │    │ │ ○ Weight - Every day        │ │
│ │ Lisbon - Fri 28 Aug – Mon.. │ │    │ └─────────────────────────────┘ │
│ └─────────────────────────────┘ │    │ Stopped                         │
│   (no header; latest first)     │    │ ┌─────────────────────────────┐ │
│ Happenings ...                  │    │ │ ● Run - Tue, Thu, Sun       │ │
                                       │ └─────────────────────────────┘ │
                                       │ <other refusals at the foot>    │
title for an unnamed span: "Change Away"
leading swipe on a span: Edit (pencil, accent) · trailing: Remove (trash) · tap: inert
```

## Left open

None. Every question the frontier raised was answered, the layout round and its two follow-ups
included.
