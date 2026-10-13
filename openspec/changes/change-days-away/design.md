## Context

See `proposal.md` § *Why*, and `grill.md`, whose fifteen settled answers and layout this delta is
written on. The facts it turns on, read off `origin/main`:

- **A gap is eras** (ADR-1069): a commitment's eras, newest first, with days between one era's
  `keptUntil` and the next one's `keptFrom`. A span keeps only its identity, name, two days and its
  commitments' identities; a first day kept through and a stop live only in the eras.
- **The first-day bound is the Kit's alone**: `CommitmentsScreen.sayDaysAway` refuses a first day
  before `dayToKeepFrom`; the sheet's date pickers have no bound.
- **`Roster.fillGap` returns early when an era holds the first or the last day**, so removing a span
  whose first day a commitment was kept through leaves its gap standing today.
- **The screen lists from `refreshLists`**, which drops spans whose last day has passed.
- **The record a screen reads is opened with it**, and the shell opens a fresh `CommitmentsScreen`
  each time the list is shown, so a record kept on the day screen is read. `History.datesRecorded`
  already answers ticks, numbers, notes, additions and declines alike.
- **A stop under way already moves the stop** to the day before the span (`Roster.retire`).

## Goals / Non-Goals

**Goals:** the delta, every rule drivable through `CommitmentsScreen`, `RosterStore` and a day
screen, and the shell drawing option C.

**Non-Goals:** remembering a stop day a span comes to cover; a look-back mark for days away; a
date bound on the sheet; changing the day-screen line or the strip's dot, which read the roster.

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
`RosterStore.init(at:)`. `daysAway` keeps its meaning, the spans not over. A scenario's "lists X as
past" reads `pastDaysAway`; "refused as over a recorded day, naming C and D" is
`.recordOnDaysAway(C, D)`; "holds X due on D", as #401's did, a `DayView` of the roster's groups.

### A change is one roster formed whole, ends moved rather than erase-and-say

`Roster` gains an internal change that, per commitment in the old picks or the new, gives back the
days the span no longer covers and cuts the days it newly covers, and replaces the span in place,
keeping its identity and its place in the order said; one write, as ADR-1069 requires. Given-back
days before the new first day extend the era held the day before the old first day; the era taken
up after the new last day is the one held on the later of the two days back, restarted there.
ADR-1069 is amended for this and for what a span cannot remember.
- *Remove, then say again:* rejected — a change made while away would stand from the old day back,
  against settled 11, and a first day kept through could not survive a rename.
- *Ends moved, every other era re-derived:* rejected — a change of rhythm made after the span
  ended would be swallowed by lengthening it.

`fillGap` learns a first day kept through: it fills from the day after, so removal erases whole.

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
- **Settled 12, read in eras**: a stopped commitment the span reaches past is kept until the day
  before its first day — its stop moves there, as a stop under way already does; one moved wholly
  past leaves the span, and a span left over nothing is refused as over nothing.
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

None — the roster form stays 10 and its encoding is unchanged. A roster holding two days away with
one identity, which only a hand-edited or damaged file can, is now refused on reading; the known
gap in `docs/open-questions.md` that names it closes.

## Risks / Trade-offs

- [A stop day a span comes to cover is not remembered] → moving the span back does not restore it;
  the owing is identical either way, a scenario asserts the stop's new day, and ADR-1069 says so.
- [Answer 11 needs the era at the old day back, which a span does not record] → it is read as the
  era beginning the day after the old last day; three moves of one span, then a removal, test it.
- [Carried tests change] → four carried scenarios gain a clause, three titles are retired with
  their tests, and `CommitmentsView`'s refusal switch loses a case; `tasks.md` § 1 lists them.
- [Settled 6 widens #401's saying] → a span said ahead over a day already recorded is now refused.

## Open Questions

None. `grill.md` § *Left open* is "None.", and writing the delta raised no question whose answer is
a preference: each edge it reached is recorded above as a reading of a settled answer.
