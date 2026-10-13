# 1048. A day picker reaches every day the calendar holds, and the week strip marks the earliest day kept from

- Status: accepted. The first shape was the owner's at the Story grill of `add-day-picker` (#176) on
  2026-09-09, and this record was written by `condense-day-screen-spec` (#201). The present shape
  is the owner's from the B-082 grooming pass and the grill of `reach-any-past-day` (#419).
- Date: 2026-09-10
- Deciders: Diego Bugmann
- Amended: 2026-10-13. The floor is gone. The picker and the week strip reach back to the
  calendar's first date, as the day swipe does, and the earliest day kept from survives only as a
  mark on the week strip. By `reach-any-past-day` (#419).
- Amended: 2026-09-23. The removed state is retired (ADR-1060), so a deleted commitment no longer
  counts toward the earliest day, and deleting the earliest one raises it.
- Amended: 2026-09-10. Why the aggregate question belongs to the roster rather than to any
  commitment is added, by `condense-commitment-spec` (#204).

## Context

`add-day-picker` (#176) gave the day screen a control that reaches a day without stepping through
every day between, and bounded it below at the earliest day anything on the roster was kept from.
Its one reason was that below that day nobody had kept anything, so a picker reaching further would
offer "a run of empty years". `add-week-strip` (#346) and `page-the-week-strip` (#347) bounded the
strip's taps and its backward page at the same floor.

The reason was wrong. A one-off of something already done, and an older happening, can both be
entered on any past day, and the day screen draws them there. Those days are where such entries go.
The day swipe had never been bounded, so the floor only stopped the two controls that reach a day
fastest from reaching days the screen already draws and accepts.

## Decision

**The day picker and the week strip reach every day the calendar holds, back to 1 January 1583.**
A pick is never refused. Every day on the strip that holds a date takes a tap, except the day being
shown. A page back keeps its weekday as far as the calendar goes, landing on the first date where
that weekday would fall before it, just as a page forward lands on the last date. There is no floor
and no horizon:
- *A horizon*, such as a few years back, was rejected. It re-creates the mismatch with the swipe
  further back.
- *A floor at the earliest entry of any kind* was rejected as circular, because the entry it waits
  for is the one the floor stops a person making.

**The earliest day anything on the roster is kept from is marked on the week strip**, so that a
person can tell they have gone back before tracking began. The owner chose this against the
recommendation of no mark. It is the roster's answer, as it was for the floor: every commitment the
roster holds counts, a stopped one included, because its days still hold records. A deleted one
does not count, because its records are erased and the mark would point at nothing. The day is
marked wherever it falls, a future day included, so it always reads as where tracking begins. It is
marked on the weeks a page either way would give as well as the one shown, so that it does not pop
in when a page lands. Where the roster answers no day, because it is empty or cannot be read,
nothing is marked. Falling back to the today, as the floor did, would mark a day on which nothing
began.

**The day picker stays the stock graphical `DatePicker`, and carries no mark.** That control cannot
mark a day, and replacing it with a `UICalendarView` to do so was declined.

**The picker is always offered, and nothing is answered about whether it is.** It opens on the day
being shown, and it gives out that day and never the today, which is what keeps the way back to today
from being derived from it (ADR-1045, decision 12).

**Why the roster owns the question, and not any commitment.** A commitment reads back its name, its
kind and its rhythm in words, and never the day it is kept from. One aggregate answer from the
roster is therefore the only way anything outside `commitment` can learn where a person's history
begins. That answer says which day and nothing about whose commitment it came from, and it is asked
of the roster even where a screen already holds every commitment it shows.

## Consequences

- The picker's earliest day is a constant. The day screen still says it, so that the shell computes
  no bound of its own (ADR-1019), and in code the answer keeps the name `Reach`. *Reach* is retired
  as a domain term in `CONTEXT.md`.
- The mark moves only when the roster is read again or changed. It never moves the day being shown,
  and it changes nothing a day offers.
- The mark and the days-away dot never fall on the same day. Days away are refused over a commitment
  kept from their first day or later, so every day away lies after the earliest day kept from, and
  the mark can take the dot's slot.
- `CONTEXT.md` § *Day picker* and § *Week strip* are the definitions, and this record is the
  reasoning behind them.
