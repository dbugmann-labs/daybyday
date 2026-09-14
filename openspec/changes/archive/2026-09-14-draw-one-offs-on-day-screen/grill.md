# Grill — draw-one-offs-on-day-screen

*10 questions over 2 rounds, 2026-09-14. One fact agent; no fact sent to the owner. The Feature grill
of B-049 (`docs/backlog.md`, the 2026-09-14 cluster C pass) had already settled the group's place
(last), its heading (*One-offs*), that a one-off takes a tick only, and that its row speaks in the
rhythm's place — none of that was asked again.*

## Settled

1. **Order inside the One-offs group.** By the date owed, earliest first; two owed on one date keep
   the order they were added in. *A one-off has no person-set place, so the order is a rule — and a
   rule about dates, never names.*
2. **What a row says in the rhythm's place.** How late it is, in days: "3 days late". *The owner's
   call against the recommended "Owed Fri 25 Sep", told it sits near the counting* Nothing
   congratulates you *refuses.* The Feature grill's "says the date it was owed" is withdrawn in
   `CONTEXT.md`.
3. **A long lateness.** Always days — "400 days late" — with no switch to weeks or a date. *One rule,
   no threshold.* "1 day late" in the singular was assumed and not asked.
4. **A one-off ticked late, on the day it was ticked.** Its row says nothing in the rhythm's place.
   *The owner's call against the recommended "same words": lateness is said only while the debt is
   open.* So the count is only ever said on the **today**, and is that today less the date owed; a
   one-off not late, or on its own date, says nothing there either.
5. **Taking back a tick on a past day.** Offered, exactly as on any row, and the row then leaves that
   day, because the one-off stands on today again. *That is what standing on one day at a time means.*
6. **A one-off done on a day the app was not opened.** Its tick records the today it was ticked on.
   Backdating is not built here and would be a want. *The shipped `one-off` spec draws an undone late
   one-off on today alone, so there is no earlier row to tick.*
7. **The one-off store cannot be read.** As the record: commitments draw as ever, no One-offs group,
   the screen says it is keeping no one-offs, the file is left untouched, and a file written by a
   later version is named (ADR-1021). *Silence would make lost one-offs look like none.*
8. **The day picker's reach.** Unchanged, the roster's alone. *One-offs are made on days already
   reachable, and chevrons and swipe go anywhere.*
9. **The notice.** One-off rows share the screen's one notice: a refused one-off change replaces a
   notice on any row, and a one-off change that lands ends one on any row. *One event, one notice,
   one lifetime rule.*
10. **Row identity by position** (`docs/open-questions.md` § *The shell identifies rows by
    position*), which Settled 5 triggers inside the group. Left to #244, which must solve it for
    adding and removing. *The group is last, the notice matches by value, and a day change replaces
    rather than animates.*

**Assumed from precedent, not asked:** the one-off store is opened at a **one-off place** of its own,
beside the record and roster places and chosen the same way; it is read again when the app is shown,
not when the screen is returned to from the commitments screen, which never writes it; adjacent day
views carry the One-offs group formed exactly as the shown day's; a one-off row on a day that has not
arrived offers no tick and stays drawn, as a commitment row does; day one seeds no one-offs.

**Facts the delta has to meet** (fact agent, 2026-09-14): `OneOffs` has no public reader listing what
it holds or whether one is done, and `add-one-off`'s `design.md` leaves that reader and its order to
this Story; `OneOffStore` has no static place; the shell never names a one-off.

## Terms landed in CONTEXT.md

- **One-off** — amended: the row's lateness count, said only while undone; the group's order; the tick
  records today; take-back from a past day.
- **One-off place** — new: the third place a day screen keeps, its unreadable case, the shared notice,
  and that it moves no reach.

## Left open

None. Every question the frontier raised was answered; the one gap it touched (row identity) was
deliberately assigned to #244 rather than left undecided.
