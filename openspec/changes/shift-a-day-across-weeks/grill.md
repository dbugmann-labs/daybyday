# Grill — shift-a-day-across-weeks

*9 questions over 3 rounds and one residual question, 2026-10-23: seven at B-087's Feature grill (two rounds, one fact agent),
two at this Story grill (one round). Every answer as recommended.*

## Settled upstream, and not re-asked

From B-087's Feature grill (`docs/backlog.md` § *Decided*, 2026-10-23; `CONTEXT.md` § *Shift*). The
owner's case: "Pool", due on Fridays only, could not be shifted to the Monday after.

1. **A weekday-set due day is shifted onto a free day of its own Mon–Sun week *or* between its own
   due days either side** — the two together, not the every-N-days bound alone. *Nothing shiftable
   today is lost: "Gym" Mon/Wed/Sat keeps Monday → Thu and Fri, which "between neighbours" alone
   would take away, while "Pool"'s Friday reaches from the Saturday before to the Thursday after.*
2. **A day of the month takes the same rule.** Its window is then about a month either side
   ("Finances" on the 31st, due Mon 31 Aug 2026: 1–30 Aug and 1–29 Sep). *One rule for the two shapes
   that share today's week bound.*
3. **A day shifted again is judged from the day it came from** — offered what that day would be
   offered without the shift, its own date included. *As every N days already judges it; the way back
   is always offered.*
4. **The neighbours are the schedule's own due days, never where another shift landed.** Days a
   shift put a due day on stay not free. *A weekday shift moves nothing after it, so two shifted days
   may swap order harmlessly, and one shift never narrows another's window.*
5. **A weekday-set or day-of-month shift may cross days away but never lands on or leaves one**, as
   today inside its week ("Gym" Mon → Thu over a Tuesday away); only every N days refuses the
   crossing. *Asked first as "no shift crosses days away, as every N days already does not" — a
   wrong premise: crossing is refused only for every N days, whose count restarts after days away.
   Re-asked as `spec-author`'s residual question on 2026-10-23 and answered "allow": a weekday set
   has no count, so refusing the crossing would buy nothing and take away a shipped behaviour.*
6. **Offered days and the row's words are said with their date for every shape** — "Mon 7 Sep" in
   "Shift to", "from Fri 4 Sep" and "to Mon 7 Sep" on the rows — as every N days already says them.
   *Once the offer spans two weeks a weekday alone no longer names one day; one form, not two.*
7. **The rule refusing a rhythm, range or target change, or a stop, while a shift has a day after the
   day the screen was handed stays as it is**, though its wait is now longer (up to about 13 days on
   one weekday, about a month on a day of the month). *Shift it back first, as today.*

## Settled

8. **The walk is five states, light only, on a fresh install.** "Pool" is made on Friday and "Gym" on
   Monday, Wednesday and Saturday, both kept from a day before last week, nothing ticked:
   (1) last Friday's "Pool" row long-pressed, "Shift to" open on dated days from the Saturday before
   it through the Thursday after; (2) the Monday after, once shifted there — "Pool - from Fri
   <date>"; (3) that Friday paged back to — "Pool - to Mon <date>", faded; (4) "Gym"'s Monday row
   long-pressed, its menu still offering that week's Thursday and Friday, now dated; (5) "Pool"
   shifted back to Friday from the Monday's menu, both rows as they were. *It shows the new reach,
   both row words, that the in-week choices survive under answer 1, and the way back answer 3
   promises.*
9. **No `phone:` line.** *As #392: the long press is driven in the simulator and nothing here needs a
   phone to prove.*

## Facts the answers rest on

Found by a dispatched agent on `origin/main` at c6faa46, not asked:

- The one-week bound is enforced in four places — where a shift is made (`Roster.shift` via
  `Shift.couldBe(from:to:)`, `commitment/spec.md` § *A roster shifts a weekday-set or day-of-month due
  day onto a free day of its week*), the roster store read (§ *A roster store keeps every shift at its
  place…*), the record store read (`record/spec.md:23-25`), and the day-screen offer
  (`DayScreen.shiftDays(for:)`, the seven days of the landing's week). Answer 1 keeps every shift
  stored today valid; the every-N-days bound alone would have made stores holding Mon → Thu shifts
  unreadable.
- `Roster.shift` checks the week before its reshift branch and against the landing, not the origin,
  so a landing in another week from its origin could not be shifted back as the code stands.
- #393 moved the roster form with no change of shape so an older app refuses an interval shift as a
  later form (`archive/2026-10-08-shift-an-interval-day/design.md:117-121`); without a move, today's
  app would read a cross-week shift as "not a roster store". No record-form precedent was found.
- A weekday set and a day of the month have month lines only in a look-back; week lines are
  weekly-quota eras alone. A shift across a month end moves one due day between two months, as an
  in-week shift across a month end already does.
- Under answer 1 no shift can both cross a week and pass one of its own due days.
- The every-N-days menu already costs time in proportion to N on every redraw
  (`docs/open-questions.md`, the shift menu entry); a weekday or day-of-month offer grows from 7
  candidates to up to about 59.

## Terms landed in CONTEXT.md

None in this grill. **Shift** was amended at B-087's Feature grill on 2026-10-23: a weekday set or a
day of the month reaches past its week, and no shift crosses days away.

## Layout

**No layout question here** — `designer`'s answer for this Story, so no mockup was drawn or asked
(ADR-1057). Nothing new is drawn: the Story builds to #392's option A and its shared long-press
wireframe (`archive/2026-10-08-shift-a-due-day/grill.md` § *Layout*), in the dated form #393 already
ships for every N days. The two differences are settled 1, 2 and 6 above: the submenu's days carry
their date and there are more of them (about 12 on one weekday, up to about 59 on a day of the
month), and the row words are "from Fri 4 Sep" / "to Mon 7 Sep" in the rhythm's place, the length of
#393's "from Tue 13 Oct", so no row changes shape. The submenu stays one ungrouped list in date order;
grouping it by week was declined at #393's layout round. The wireframes, verbatim from #392:

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

None for the owner. Three things are `spec-author`'s, carried into `design.md`: whether and how far
the roster form (and the record form) moves so an older app refuses a cross-week shift as a later
form; the order of `Roster.shift`'s week check and reshift branch; and whether the longer offer's
redraw cost needs anything beyond what the every-N-days entry in `docs/open-questions.md` already
records.
