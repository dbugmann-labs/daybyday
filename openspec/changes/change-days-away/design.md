## Context

See `proposal.md` § *Why*, and `grill.md`, whose sixteen settled answers and layout this delta is
written on. The facts it turns on, read off `origin/main`:

- **A gap is eras** (ADR-1069): days between one era's `keptUntil` and the next one's `keptFrom`. A
  span keeps only its identity, name, days and commitments; a first day kept through and a stop live
  in the eras alone, so a stop the day after a span and a span moved past a stop store alike.
- **The first-day bound is the Kit's alone**: `CommitmentsScreen.sayDaysAway` refuses a first day
  before `dayToKeepFrom`; the sheet's date pickers have no bound.
- **`Roster.fillGap` returns early when an era holds the first or the last day**, so removing a span
  whose first day a commitment was kept through leaves its gap standing today.
- **The screen lists from `refreshLists`**, which drops spans whose last day has passed.
- **The record a screen reads is opened with it**, and the shell opens a fresh `CommitmentsScreen`
  each time the list is shown, so a record kept on the day screen is read. `History.datesRecorded`
  already answers ticks, numbers, notes, additions and declines alike.
- **A stop under way already moves the stop** to the day before the span (`Roster.retire`), and
  takes the commitment out of the span (`leaveDaysAway`); a span already past keeps it.

## Goals / Non-Goals

**Goals:** the delta, every rule drivable through `CommitmentsScreen`, `RosterStore` and a day
screen, and the shell drawing option C.

**Non-Goals:** a look-back mark for days away; a date bound on the sheet; changing the day-screen
line or the strip's dot, which read the roster; remembering the day a take-up-again was made.

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
`confirmStopKeeping`, `keepAgain`, `RosterStore.init(at:)`. `daysAway` keeps its meaning, the spans
not over. "Lists X as past" reads `pastDaysAway`; "refused as over a recorded day, naming C and D"
is `.recordOnDaysAway(C, D)`; "holds X due on D", as #401's did, a `DayView` of the roster's groups.

### A change is one roster formed whole, ends moved rather than erase-and-say

`Roster` gains an internal change that, per commitment in the old picks or the new, gives back the
days the span no longer covers and cuts the days it newly covers, and replaces the span in place,
keeping its identity and its place in the order said; one write, as ADR-1069 requires. Given-back
days before the new first day extend the era held the day before the old first day; the era taken
up after the new last day is the one held on the later of the two days back, restarted there.
ADR-1069 is amended for this and for settled 16.
- *Remove, then say again:* rejected — a change made while away would stand from the old day back,
  against settled 11, and a first day kept through could not survive a rename.
- *Ends moved, every other era re-derived:* rejected — a change of rhythm made after the span
  ended would be swallowed by lengthening it.

`fillGap` learns a first day kept through: it fills from the day after, so removal erases whole.

### Days away remember a stop

Settled 16. `Roster.Span` gains, per commitment, the day a stop kept it until, in roster form 11.
`confirmStopKeeping` sets it on every begun span keeping the commitment, never over a day already
there; a change and a take-up-again keep it; a deletion drops it. Every give-back — removal, untick,
either end moved, a move wholly past — gives back no day after it, so the fix round's guard in
`fillGap`'s `(behind, nil)` branch goes. The eras still carry a stop a span reaches past as the day
before it (settled 12), so a roster's answer for a day stays the eras'.
- *Guard (the fix round):* rejected — a stop the day after a span then lost its days on removal.
- *No guard, no memory:* rejected — the eras store that case and a span moved past a stop alike.

### Readings the delta makes of the settled answers

- **"Entry" in settled 6 is an addition**, the record a total holds.
- **Which commitment and day a record refusal names**: the first picked the roster holds, then its
  earliest recorded day newly put under. One refusal, as every refusal here.
- **"Newly" (the grill's preamble)**: days already under the span are not judged again, so a rename
  is never refused for a record; records can lie on days to come, so saying judges those too.
- **A screen that cannot read its record judges no day as recorded**, as a stop and #401's
  kept-through-first-day read it. *Refusing instead* was weighed: it would also refuse what #401
  shipped, for a state the take-out already reports, and a removal brings any hidden record back.
- **Kept through the first day survives only while the first day stays**; moved, settled 6 judges
  the old first day like any other.
- **Settled 12, read in eras and memory**: "wholly past" reads the day remembered, and a span moved
  back gives the days up to it back — settled 16 reverses the first G4's reading that it does not.
  A span left over nothing is refused as over nothing.
- **Settled 16's "every stopped commitment they are over" takes in a stop under way**: the span
  keeps it, remembered, rather than #401's take-out. *Open Questions*, settled.
- **A take-up-again inside a span over the commitment holds from the day after it**, as settled 11
  has a change made while away do; the day it was made is not remembered either.
- **Past spans**: by first day, latest first; sharing one, the last said first — the reverse of the
  upcoming order.
- **The three requirements that lose a scenario are REMOVED and re-ADDED** under new or carried
  titles: `openspec` 1.10.0 refuses a MODIFIED block that drops one.

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

The roster form moves to 11: each days away record carries a list of commitment and day, empty
where it remembers nothing. Form 10 reads each stopped commitment a span is over as remembered at
the later of the span's last day and its own last day kept — exact, since `main` cannot change a
span, so one holding a stopped commitment was past when it stopped. A copy nests the roster form. A roster holding two days away with one identity,
which only a hand-edited or damaged file can, is now refused on reading; the known gap in
`docs/open-questions.md` that names it closes.

## Risks / Trade-offs

- [A form-10 roster this branch's builds wrote after moving a span past a stop reads as a stop the
  day after] → only a phone that ran this branch holds one; assumed none.
- [Answer 11 needs the era at the old day back, which a span does not record] → it is read as the
  era beginning the day after the old last day; three moves of one span, then a removal, test it.
- [Carried tests change] → five carried scenarios gain a clause, three titles are retired with
  their tests, the fix round's unscenarioed test goes, 9.1's fixtures move to form 11, and
  `CommitmentsView`'s refusal switch loses a case; `tasks.md` § 1 lists them.
- [Settled 6 widens #401's saying] → a span said ahead over a day already recorded is now refused.

## Open Questions

`grill.md` § *Left open* is "None."; settled 16 is folded in above. **Settled**, the one residual
question: a stop made while days away are under way keeps the commitment in them, remembered,
rather than #401's take-out — the owner's answer, 2026-10-13. Every other edge the delta reached is
recorded as a reading of a settled answer.
