# Grill — shift-a-due-day

*16 questions over 5 rounds and three fact agents, 2026-10-07, on top of what the twenty-fifth
grooming pass's Feature grill settled for B-054 on 2026-10-06. One question drafted for round 1 —
whether a look-back marks a shifted day — was dropped unasked: a look-back has no per-day grid,
only month fractions, week lines and graphs, so there is nothing to mark.*

## Settled upstream, and not re-asked

From the Feature grill (`docs/backlog.md` § *Decided*, B-054; `CONTEXT.md` § *Shift*). This Story
is the weekday-set and day-of-month half; every-N-days and the retirement of restarting are #393
and #394.

- A **shift** puts one due day of a commitment on another day that is not due. The day it came
  from stops being due; the day it lands on is due.
- A weekday set or a day of the month is shifted to a free day of the **same Mon–Sun week** —
  earlier or later, never onto one of its own days — and the rest of its rhythm is unchanged.
- It is made **from the row of the day being shifted**; a day already past is reached by paging
  back to it.
- **Refused while ticked.** No tick travels between dates.
- The day it came from keeps **a row saying where the day went**, offering no tick.
- A shifted day **may be shifted again**, its own original date included — which is how a shift
  is undone.
- In a look-back it is **counted due where it landed**, and the day it came from is not due.

## Settled

1. **Every kind can be shifted** — tick, number, note and total alike. *A slip is the same whatever
   the day records; no kind-specific rule.*
2. **The day a shift lands on says where it came from** — "from Mon", in words; the look is the
   layout round's. *A Tuesday gym row unexplained reads as a rhythm never set.*
3. **The row of the day a shift came from offers nothing.** Everything is done from the due day,
   shifting back included. *One place to act.*
4. **A day-of-month shift may cross into the next month**, as long as it stays in its week — the
   owner's call against the recommendation to bound it by the month as well. A month's look-back
   line can then count two due days and its neighbour none. *The week is the only bound.*
5. **A day holding any record cannot be shifted**, ticked or not — a total with additions short of
   its target included. Take the record back first. *No record ever changes its date; the same
   idiom as #303's untick-then-change.*
6. **A gap day is not free.** A day is shifted only onto a day the commitment is running.
   *A gap owes nothing and shows nothing; a day shifted into one would vanish.*
7. **A rhythm, range or target change, and a stop, are refused while any shift has either end on a
   day after today** — its origin or its landing. Shift it back first. *Changes and stops take
   effect from today and must not inherit a half-applied exception; nothing is dropped silently.*
8. **The refusal says "Shift its day back first."** *Short, imperative, like the other refusals;
   the day is visible on the day screen.*
9. **A shift is reached by a long press on the row**, a context menu as one-off rows already have.
   *The tap keeps ticking and nothing new shows at rest.*
10. **The menu offers "Shift to" with a submenu of the free days** — this week's days that are not
    one of its days and not in a gap, its own original date included where the day was shifted
    away. *A day that is not free is never offered, so there is nothing to refuse.*
11. **A row that cannot be shifted has no Shift in its menu** — not a greyed item. *A screen draws
    as a target only what it offers.*
12. **The walk is five states, light, no `phone:` line**, for gym on Mon/Wed/Sat walked mid-week:
    (1) the long-press menu on Monday's row with its submenu of free days; (2) Tuesday's row saying
    it is from Monday; (3) Monday paged back, saying where the day went and offering nothing;
    (4) the change sheet refusing a rhythm change while a shift lands ahead; (5) the day shifted
    back to Monday, both rows as they were.

## Facts the answers rest on

Found by dispatched agents on `origin/main` at fb25f8b, not asked:

- Four kinds: tick, number, note, total. A tick, a number and a note keep their day by being there;
  a total keeps it at its target or more — so the only unkept day that can hold a record is a total
  short of its target. A record stands only on a day the commitment is due (`record` spec).
- A rhythm, range or target change puts a new era on as of the day the screen was handed; a change
  leaving a recorded day not due is refused (#303). A stop and a resume both take effect on the day
  they are made, and can fall mid-week. A gap day owes nothing and has no row.
- A copy holds the history, the roster, the one-offs, the birthday ticks and the happenings, and a
  restore replaces those places. **A shift must be carried by a copy and replaced by a restore like
  any other part of what those places hold** — this follows from a copy holding the history, and is
  not a question.
- A commitment row offers one tap today; the only context menu on the day screen is the one-off
  row's *Remove*. A row that offers nothing is drawn faded.
- A day screen pages to days after today as well as before, by swipe, chevron and week strip, so a
  due day ahead can be shifted from its own row. The week strip draws nothing that depends on what
  is due or kept, so a shift does not touch it.
- A one-off row says its lateness in the place a commitment row says its rhythm — the precedent for
  "from Mon" and for where the day went.

## Terms landed in CONTEXT.md

None in this grill. **Shift** landed at the Feature grill on 2026-10-06.

## Layout

Option A, the words in the rhythm's place, chosen from three at
https://claude.ai/artifact/CXzkYmYUjNUXZGbiBRs3P8 — *the slot a one-off's lateness already uses; the
row stays one line and only its string changes. The rhythm is not shown on the two days a shift
touches, and every other day of the week still shows it.* Asked in the same round:

- **The day a shift came from says "to Tue"**, mirroring "from Mon". *Short, and the pair reads as
  one move.*
- **The "Shift to" submenu labels its days "Tue", "Thu"** — the weekday alone, in the style the
  rhythm already uses. *Every choice is in one week, so the weekday names the day exactly.*

The wireframes follow, verbatim from the designer: option A, and the long-press menu every option
shared.

```
A · In the rhythm's place            (recommended)
  Tuesday — landing day
  │ Gym  - from Mon                          │   unticked: no mark
  │ ~~Gym~~ - from Mon                     ✓ │   ticked: grey struck name, green check
  Monday — origin day, paged back
  │ Gym  - to Tue                            │   whole row faded (0.5), no tap
```

```
Shared · long press on Monday's Gym row (walk state 1)
  │ Gym  - Mon, Wed, Sat                     │  ← row lifted
  ┌──────────────────────┐
  │ Shift to           › │ → ┌──────────┐
  └──────────────────────┘   │ Tue      │   free days of this week only:
                             │ Thu      │   not Mon/Wed/Sat, not in a gap
                             │ Fri      │
                             │ Sun      │
                             └──────────┘
```

## Left open

None. Every question the frontier raised was answered, the layout round's three included.
