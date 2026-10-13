## Context

See `proposal.md` § *Why*, and `grill.md`, whose eighteen settled answers and layout this delta is
written on. The facts it turns on, read off `origin/main`:

- **A gap is eras** (ADR-1069). `retire` drops an era a stop leaves holding no day, so a stop inside a
  span, or on its last day, looks like its gap; `keepAgain` undoes a stop it would follow at once.
- **`CommitmentsScreen.sayDaysAway` alone bounds the first day**; the sheet's pickers have none.
- **`fillGap` returns early when an era holds the first or last day; `refreshLists` drops past spans.**
- **`History.datesRecorded`** answers ticks, numbers, notes, additions and declines alike, and the
  shell opens a fresh `CommitmentsScreen`, record included, each time the list is shown.
- **A stop under way** moves to the day before the span and takes the commitment out of it.

## Goals / Non-Goals

**Goals:** the delta, drivable through `CommitmentsScreen`, `RosterStore` and a day screen; the shell
drawing option C. **Non-Goals:** a look-back mark; a sheet date bound; changing the day-screen line or
the strip's dot; remembering the day a take-up was made; checking what spans remember against eras.

## Decisions

### The seam

```swift
public func CommitmentsScreen.changeDaysAway(_ daysAway: DaysAway, named name: String, from firstDay: CalendarDate, through lastDay: CalendarDate, over commitments: [Commitment]) -> Refusal?
public private(set) var CommitmentsScreen.pastDaysAway: [DaysAway]
case Refusal.recordOnDaysAway(Commitment, CalendarDate)
public static func DaysAway.dayInWords(_ day: CalendarDate) -> String
```

Removed: `case Refusal.firstDayHasPassed`. Same signature, new behaviour: `sayDaysAway`,
`offersRemoving` and `askToRemove` (every span in either list), `confirmRemovingDaysAway`,
`confirmStopKeeping`, `keepAgain`, `confirmDeleting`, `RosterStore.init(at:)`. "Lists X as past" reads
`pastDaysAway`; "refused as over a recorded day, naming C and D" is `.recordOnDaysAway(C, D)`; "holds
X due on D", as #401's did, the roster's groups on D and `Commitment.isDue`. "Entry" in settled 6 is
an addition. The three requirements that lose a scenario are REMOVED and re-ADDED under new or carried
titles: `openspec` 1.10.0 refuses a MODIFIED block that drops one.

### A change is one roster formed whole

`Roster` gains an internal change that forms each commitment in the old picks or the new from its
own life (below), replaces the span in place, keeping its identity and place in the order said, and
writes once (ADR-1069, amended). Days given back before the new first day are on the era held the day
before the old one; the era after the new last day is the one held on the later of the two days back,
restarted there (settled 11). `fillGap` fills from the day after a first day kept through.
- *Remove, then say again:* rejected — breaks settled 11; a first day kept through dies on a rename.
- *Ends moved, every other era re-derived:* rejected — it swallows a later change of rhythm.

### What days away remember (settled 18)

A span holds, per commitment it is over, its **stops** in day order: the day kept until and a
**take-up** — none, **the day back** (the day after the span's last day, wherever it moves), or a
fixed day. A stop is the person's act and no change moves it; the eras say what the acts come to now.

Every write keeps four invariants, and the store refuses exactly their breach: **I1** a stop is of a
commitment the span is over; **I2** a commitment's stops fall on strictly later days (one on the last
stop's day undoes its take-up instead); **I3** only the last lacks a take-up; **I4** a fixed take-up
falls after its stop's day (one that undoes the stop forgets it). A day-back take-up has no bound:
moved to the day after its stop or before, it undoes it, and moved back it stands (*Questions for
you* 1). Nothing is checked against the eras: the last design's bound on a stopped commitment's day
was such a check, and it wrote the roster finding 1 could not read.
- *One remembered day per stopped commitment:* rejected — a stop after a take-up had nowhere to go;
  *gaps derived at read time* is ADR-1069's rejected alternative.

### Own life: one give-back for every operation

A commitment's **own life** beside a span, at a day back, is its eras with the span's gap given back
as removal gives it, the era before running through and the one begun on the day back joining where
alike — except each remembered stop's gap, from the day after its day kept until to the day before
its take-up (the given day back for one taken up there), endless where none; a take-up on a given-back
day begins an era on the rhythm held on its stop's day. It touches only the span's days, old and new.
Removal, untick and take-out set the eras to own life at the span's day back. A change keeping the
commitment adds each stop of own life at the old day back — a day kept until that no era and no other
span over it holds the day after — whose gap holds a day newly covered or the new day back, then sets
the eras to own life at the new day back, new gap cut. A stopped commitment is taken out where the new
first day is past the day after its last stop's day. Every move reads the same acts, never what the
last move left in the eras: one change or several reach the same eras (finding 2), and a move back
restores (settled 16).
- *Each end patched on its own (`giveBackAfter`, `fillGap`'s guards):* rejected — order-dependent.

### Every operation

| Operation | Reads | The commitment's eras | What the span remembers of it |
|---|---|---|---|
| Say, or tick it on | eras | gap cut | each stop whose gap holds a day of it or the day back |
| Change keeping it | own life, both days back | own life at the new day back, cut | kept; stops newly hidden added |
| Removal, untick, take-out | own life | own life | dropped |
| Stop, span not begun | — | stopped, as now | it leaves the span |
| Stop, span begun | — | stopped, as now | added; on its last stop's day, that take-up undone |
| Take-up inside the span | — | era from its day back, as now | last stop: the day back |
| Take-up elsewhere | — | era from that day, or stop undone | last stop: that day; forgotten where undone |
| Deletion | — | gone | dropped from every span |
| Restore | copy | the copy's | the copy's |
| Read, form 10 | eras | — | per stopped commitment, a stop on the later of the last day and its last day kept |
| Read, form 11 | file | — | as written; refused only for I1–I4 |
| Anything else, any reader of days | eras | as now | untouched, never read |

### The shell

`CommitmentsView`'s Days away card keeps `screen.daysAway` and "New days away"; below it a Section
with no header holds `screen.pastDaysAway`, drawn only when not empty, rows as in the first. Every
span row gains a leading swipe, `pencil`, accent, labelled "Edit", opening the sheet on it; the
trailing Remove stays. `DaysAwaySheet` takes an optional span: changing one, it is titled "Change
\(title)" with "Save", opens filled — name or empty, both days, its commitments picked — and lists
under a "Stopped" header the stopped commitments it is over, toggled as the kept ones are, an
unticked one staying drawn until Save. Save calls `changeDaysAway`, disabled while nothing is
picked. Cancel on a changed sheet once anything is edited asks "Discard changes?" with "Discard"
(destructive), the commitment change sheet's dialog; saying asks nothing, as now.
`.recordOnDaysAway(c, d)` is drawn under the row of `c`, red `.caption`: "\(c.name) has a record
on \(DaysAway.dayInWords(d))."; every other refusal stays at the foot. The
`.firstDayHasPassed` text goes. A changed span is equal to its old self, so the list rebuilds on the
sheet's dismiss through `listRevision`, as after a rename.

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

### Migration

Roster form 11: each days away record carries its stops — commitment, day kept until, take-up,
absent for none — empty where none. Form 10 reads as the table says, exactly: `main` can neither
change a span nor keep a stopped commitment in one under way. A copy nests the roster form. Two days
away with one identity are refused; the known gap in `docs/open-questions.md` naming it closes.

## Risks / Trade-offs

- [A form-11 roster an earlier build of this branch wrote holds no take-ups] → assumed on no phone.
- [A fixed take-up another span's day back gave goes stale when that span moves] → harmless: own life
  reads only this span's days, and two spans over one commitment never share one.
- [Carried tests change; settled 6 refuses a span said ahead over a recorded day] → `tasks.md` § 1.

## Questions for you

1. **Days away moved to end before a stop made inside them.** Gym, stopped as of the 14th inside
   Mallorca, 13–18 October, is taken up again for the day back; Mallorca moves to 5–10 October. Does
   the take-up follow to the 11th, undoing the stop so Gym owes every day from it, 15–18 included —
   or stay on the 19th, so Gym owes up to the 14th and from the 19th?
   - *Recommended:* follow — settled 17 as written, "in both directions"; moved back, the stop and
     the 19th return. The fifth review's P4, only the last day moved to the 13th, already follows.
   - *If you say stay:* the take-up requirement's last-day sentence gains "never to a day no later
     than the day after its stop"; 7.25 (P4) and 7.26 are rewritten; nothing else moves.

## Open Questions

`grill.md` § *Left open* is "None."; settled 16–18 are folded in. **Settled**: a stop made while days
away are under way keeps the commitment in them, remembered, not #401's take-out — the owner's answer,
2026-10-13. *Questions for you* 1 is outstanding.
