## Context

See `proposal.md` and `grill.md`, whose twenty-three settled answers and layout this delta is written
on; settled 19–23 replace 11, 17 and 18 and the cut of ADR-1069. Facts on `origin/main` (form 10):

- **A gap is eras today.** Saying cuts each picked commitment's eras (`Roster.cutGap`), removal
  re-joins them (`fillGap`), and the every-N restart is a stored era (`Roster.restarted`).
- **Readers that rely on the cut:** `Roster.groups(on:)` (`Roster.swift:119`) and
  `DayView.makeGroups`; `WeekQuota.standing`/`daysHeld`; `LookBack`'s `chain`, `walkDays` and
  `graph`; `CommitmentsScreen.refusalLeavingARecordedDayNotDue` (`:1355`); shifts' `holds`/`isFree`
  and the every-N day-back exemption (`Roster.swift:831-927`); a change's re-cut of days ahead
  (`CommitmentsScreen.swift:1523-1583`); a stop's drop of the day-back era (`Roster.swift:561-614`).
  `Roster.commitments(on:)` reads stops alone, which days away no longer touch.
- **A cut and a stop with a later take-up are byte-identical in form-10 eras.**
- **`History.datesRecorded`** answers ticks, numbers, notes, additions and declines alike.
- This branch's form 11, with remembered stops, reached no phone.

## Goals / Non-Goals

**Goals:** the delta, drivable through `CommitmentsScreen`, `RosterStore`, a day screen and a
look-back; one read rule every reader goes through; the shell drawing option C, unchanged.
**Non-Goals:** rebuilding cut gaps from a form-10 roster; a look-back mark for days away; a sheet
date bound; changing the day-screen line or the strip's dot.

## Decisions

### The model: days away are a mask (settled 19, ADR-1069 amended)

The roster holds each commitment's life whole — eras, stops, take-ups, as made — and each days away
as a span: identity, name, first and last day, commitments; nothing else. A day is **hidden** from a
commitment when a span over it covers the day and the record holds nothing of it there (settled 22);
with no record read, every covered day is hidden. A hidden day is due on no rhythm, holds no quota
share and is a gap day to a look-back; an every-N-days era is counted from the latest day after a span
over the commitment that the era holds, on or before the day read; a shift reads days the same way.
- *Remember what a cut destroys (settled 18):* rejected — eight reviews each found a corner it missed.

### Every operation

| Operation, state | Eras | Spans | What a reader sees |
|---|---|---|---|
| Say; tick a commitment on | untouched | span or pick added | covered days hidden, recorded ones shown |
| Change days, name or picks | untouched | replaced in place, identity and order kept | old days back as the eras have them, new hidden |
| Remove; untick | untouched | span or pick gone | exactly the days it hid, back |
| Change: first day past a stop's day after | untouched | stopped pick taken out | nothing: it owed none of them |
| Stop, span not begun | stopped on the day made | it leaves; a span over none goes | — |
| Stop, span begun (under way or past) | stopped on the day made | it stays | days after the stop owe nothing either way |
| Take-up, inside a span or not | era from the day made, or stop undone | untouched | hidden through the last day, owed after |
| Rhythm, range, target change | era from the day handed | untouched | hidden through the last day, restart after |
| Deletion | gone | out of every span; a span over none goes | — |
| Record kept or taken back under a span | untouched | untouched | shown while recorded, hidden after |
| Restore | the copy's | the copy's | read as a store reads the copy's form |
| Read form 11 / form 10 | as written | as written | form 10's cut gaps stay a stop and take-up |
| Any act, screen opened as of any day | as that act alone | as that act alone | no order dependence, by construction |

Saying and changing are judged on the span as asked, never against itself; a record only where a
change newly puts it within the span, so a recorded first day handed stays unjudged after a move.

### The seam

```swift
public func Roster.groups(on date: CalendarDate, recordedIn history: History? = nil) -> [Roster.Group]
public func CommitmentsScreen.changeDaysAway(_ daysAway: DaysAway, named name: String, from firstDay: CalendarDate, through lastDay: CalendarDate, over commitments: [Commitment]) -> Refusal?
public private(set) var CommitmentsScreen.pastDaysAway: [DaysAway]
case Refusal.recordOnDaysAway(Commitment, CalendarDate)
public static func DaysAway.dayInWords(_ day: CalendarDate) -> String
```

Removed: `case Refusal.firstDayHasPassed`; every other days-away member keeps its signature. "Holds X
due on D" reads `groups(on: D)`, no record, and `Commitment.isDue`; "had not stopped keeping on D"
reads `Roster.commitments(on:)`. Six shipped requirements that drop or retitle a scenario are REMOVED
and carried under new titles, since `openspec` 1.10.0 refuses such a MODIFIED block.

### Migration

Roster form 11 has form 10's shape — each days away its identity, name, days and commitments — over
eras that days away never cut. Form 10 is read as written: its eras, cut gaps included, untouched and
its days away laid over them, so removing one gives back none of its gap; the next write is form 11.
No phone holds days away (settled 23). Earlier forms read as holding none; a copy nests the form.

### Order of work: replace, never layer

1. Delete the memory: the span's stops, own life, the four invariants, `stopDaysAway`'s remembering,
   the take-up day rules, `newlyHiddenDays`, `freeStretches`, form 11's `remembers`.
2. Delete the cut: `cutGap`, `cutDaysAwayGap`, `fillGap`, the stored restart, a change's re-cut and
   era from the day after days away, a stop's day-back drop. Days away become span edits alone, and a
   stop, a take-up or a change forms the eras it would with no days away.
3. Add the read once, behind `groups(on:recordedIn:)`; route every reader § *Context* names through it.

### The shell

Unchanged by settled 19–23. `CommitmentsView`'s Days away card keeps `screen.daysAway` and "New days
away"; a headerless Section below holds `screen.pastDaysAway` when not empty. Every span row gains a
leading "Edit" swipe, `pencil`, accent, opening `DaysAwaySheet` on it; the trailing Remove stays.
Changing one, the sheet is titled "Change \(title)" with "Save", opens filled, and lists under a
"Stopped" header the stopped commitments it is over, an unticked one drawn until Save; Save calls
`changeDaysAway`, disabled while nothing is picked. Cancel once anything is edited asks "Discard
changes?" with "Discard" (destructive); saying asks nothing. `.recordOnDaysAway(c, d)` is drawn under
`c`'s row, red `.caption`: "\(c.name) has a record on \(DaysAway.dayInWords(d))."; other refusals
stay at the foot. The list rebuilds on dismiss through `listRevision`.

### What the shell draws

Option C, *Past set apart*, from https://claude.ai/artifact/Vy9hwfRDwuhsAuHphkDUJz.

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

## Risks / Trade-offs

- [A reader left on the eras alone owes hidden days] → § *Order of work* step 3 before any scenario;
  the day-screen, look-back, quota and shift scenarios; `tasks.md` 2.6's mutations.
- [Hiding depends on the record, which a roster store alone cannot read] → stated in the delta: with
  no record every covered day is hidden; every reader holding the record passes it.
- [A form-10 roster with days away keeps its cut gaps] → settled 23: none is on a phone.
- [Carried tests change] → `tasks.md` § 1.2, before and after for each.

## Open Questions

None. `grill.md` § *Left open* is "None.", and settled 19–23 are folded in. The one call settled 23
left here, how a form-10 roster holding days away is read, is § *Migration*; reading settled 6's
"newly" under the mask, so a recorded day already within days away is not judged again, is
§ *Every operation*.
