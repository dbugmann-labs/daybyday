## Context

See `proposal.md` § *Why*, and `grill.md`, whose twenty-two settled answers, layout and carried
Feature-grill decisions this delta is written on. The facts it turns on, read off `origin/main` at
50d7625:

- **A gap is two eras.** `Roster` holds a commitment's eras newest first; a gap is the days between
  one era's `keptUntil` and the next era's `keptFrom`. `Roster.mended` drops an era holding no day,
  and a gap day draws no row, `DayView` asking `isDue`, false before `keptFrom`.
- **A stop already lands right.** `retire` on a newest era kept from a later day drops it onto the
  era behind with the earlier `keptUntil` — the day before days away, or the stop day.
- **A change erases a future gap.** `CommitmentsScreen.change` puts its era through `put(era:on:
  keptUntil:under:)`, whose mend drops an era kept from after the day handed.
- **An interval shift refuses any later era** (`Roster.shiftEveryNDays`, `laterEra`).
- **Slack counts calendar days.** `DayView.Row.hasNoSlack` takes 7 less the date's place in its week;
  `WeekQuota.standing`'s `owed` already counts only days an era holds, days to come included.
- **The roster form is 9**, the copy's 3 nesting it as written. **Carried tests naming roster form
  10 as later**: `DayScreenTests.swift` 995, 1205, 3433, 3610, 3627; `RosterStoreTests.swift` 324,
  327, 1980, 1983; `CommitmentsScreenTests.swift` 2271; `RosterStoreTests.swift` 4257 asserts form 9.

## Goals / Non-Goals

**Goals:** the delta, every rule drivable through `CommitmentsScreen`, `RosterStore`, `DayScreen`
and a copy, and the shell drawing option A.

**Non-Goals:** moving an end, removing days away under way, saying them over past days (#402); any
look-back mark for days away (settled 21); counting days away in a restore's counts; condensing the
carried MODIFIED requirements, an editorial Story's (ADR-1047).

## Decisions

### The seam

```swift
public struct DaysAway: Hashable, Sendable
public let DaysAway.name: String?, firstDay: CalendarDate, lastDay: CalendarDate
public let DaysAway.commitments: [Commitment]
public var DaysAway.title: String, daysInWords: String
public var Roster.daysAway: [DaysAway]
public private(set) var CommitmentsScreen.daysAway: [DaysAway]
public func CommitmentsScreen.sayDaysAway(named name: String, from firstDay: CalendarDate, through lastDay: CalendarDate, over commitments: [Commitment]) -> Refusal?
public private(set) var CommitmentsScreen.daysAwayRefusal: Refusal?
public func CommitmentsScreen.daysAwaySheetEdited()
public func CommitmentsScreen.daysAwaySheetClosed()
public func CommitmentsScreen.offersRemoving(_ daysAway: DaysAway) -> Bool
public private(set) var CommitmentsScreen.daysAwayAwaitingRemoval: DaysAway?
public func CommitmentsScreen.askToRemove(_ daysAway: DaysAway)
public func CommitmentsScreen.cancelRemovingDaysAway()
public func CommitmentsScreen.confirmRemovingDaysAway() -> Refusal?
case Refusal.firstDayHasPassed, lastDayBeforeFirstDay, overNoCommitment, shiftOnDaysAway(String)
case Refusal.overlapsDaysAway(DaysAway), keptFromMovedIntoDaysAway(DaysAway), keptFromFirstDayOrLater(String)
public private(set) var DayView.daysAwayInWords: [String]
public let DayScreen.WeekStripDay.isAway: Bool
```

All are new. `DaysAway` is equal by an identity of its own, as a happening is (ADR-1065), so #402
can move its ends; `commitments` is the roster's newest era of each, read when asked. A scenario's
"holds X due on D" reads a `DayView` formed of that roster's groups on D.

### Days away are a span the roster holds, and their gaps are eras — ADR-1069

The roster holds each days away beside its entries and puts its gap on each commitment as eras, so
every reader that already reads a gap — rows, standing, part weeks, look-backs — reads days away
unchanged. Saying, removing, a change, a stop and a deletion each form the next roster whole and
write it once. Removing re-forms each commitment's eras as though those days away were never said:
the era in force before them runs through, and the era begun the day after goes unless other days
away begin it, as the removal beside other days away tests.
- *Days away read at every reader from the span alone:* rejected — every reader learns a second gap.
- *Their own store:* rejected — not written with the eras, and a sixth place for a copy.

### Readings the delta makes of the settled answers

- **Settled 8's "after" is "on or after"**: kept from the first day, a commitment would hold no day
  before its gap and its day kept from would move, which settled 8 forbids.
- **Settled 10 reaches the day kept from**: moving it onto or past its days away is refused.
- **Settled 17 needs no copy form**: the roster form moves, and the copy nests it at form 3.
- **Order and words**: by first day, then the order said; "Thu 27 Aug" as shipped, no year.

The change, the interval shift, the strip's "mark nothing else" and slack's days left each carry a
falsified sentence and are MODIFIED whole; the stop, the deletion and the forms gain ADDED rules.

### The shell

`CommitmentsView` gains a Section "Days away" between Stopped and Happenings: each listed one as
`commitmentLine(Text(title), rhythmInWords: daysInWords)` over its commitments' names joined by ", "
in `.caption` `.secondary`; a trailing trash swipe labelled "Remove" only where `offersRemoving`;
then `Button("New days away")`. The alert: "Remove days away?", its message `title` and
`daysInWords`, "Remove" (destructive) and "Cancel". The sheet "Days away": `TextField("Name
(optional)")`, `DatePicker`s "First day" and "Last day" from `dayToKeepFrom`, opening on it; a
Section "Commitments" of `kept`, each with a `circle` or `checkmark.circle.fill`, none picked; the
refusal at the foot in red `.caption`; "Cancel", and "Add" disabled while nothing is picked. The day
screen draws each `daysAwayInWords` line first in its list, a bare `.subheadline` `.secondary` row;
a strip day where `isAway` draws a 4pt dot under its number, `.secondary`, or the text colour where
shown. Refusals in `refusalText`: "These days overlap \(title), \(daysInWords).", "\(name) is kept
from their first day or later.", "\(name) has a day shifted into these days.", "The first day has
passed.", "The last day is before the first.", "Pick a commitment.", "That day falls in \(title)."

### What the shell draws

Option A, *Beside Happenings*, from https://claude.ai/artifact/EhYXPjJa7Gv83Aetz2n6vd.

```
A — Beside Happenings
Commitments (scrolled to foot)        Sheet                              Day screen, Thu 15 Oct
[<] Commitments          [⇅][+]       [Cancel]  Days away  [Save]        [Today]              [≡][⚙]
 | Yuno - 5x a week          > |      | Mallorca                 |      Thursday
 | Weight - Every day        > |      | First day    [13 Oct 2026] |    15 October 2026
 Stopped                              | Last day     [18 Oct 2026] |    < 12 13 14 (15) 16 17 18 >
 | Nothing has been stopped.   |      Commitments                        Mallorca            ← bare line
 Days away                            | ○ Creatine - Every day      |    | Creatine - Every day    | (faded)
 | Mallorca - Tue 13 Oct – Sun 18 Oct | ○ Magnesium - Every day   |      | Magnesium - Every day   |
 |   Gym, Run                  |      | ● Gym - Mon, Wed, Sat       |    | Yuno - 0/5x a week      |
 | New days away               |      | ● Run - Tue, Thu, Sun       |    | Weight - Every day    > |
 Happenings                           | ○ …                         |    ( New one-off )
 | Augenmigräne …              |
 (no span: the card holds only "New days away"; swipe a span → trash → "Remove days away …?")
```

### Migration

The roster form moves from 9 to 10, adding one top-level `daysAway` list: each an identity, a name
or `null`, a first and a last date, and the identities of its commitments. An earlier form reads as
holding none and stays byte-for-byte until the next kept change. The copy's form stays 3. Records,
one-offs, birthdays and happenings do not move.

## Risks / Trade-offs

- [A newest era kept from a later day is new to every reader] → `Roster.stopped`, `whatItIsMadeOf`,
  a change back's alike-era test and a look-back each meet one; the change scenarios, and a unit test
  that a look-back at a commitment with days away ahead equals the one before they were said.
- [Adjacent days away leave no era between them] → a removal scenario removes one beside the other.
- [`DaysAway` is equal by identity, so a rename alone leaves it equal] → the list rebuilds on the
  sheet's dismiss through `listRevision`, as the kept list already does.
- [The carried change requirement is over the prose budget, as it was] → one `check:budgets` warning.

## Open Questions

`grill.md` § *Left open* is "None." Writing the delta raised one question, below, written on the
recommended answer; the readings above follow from settled answers and are recorded, not asked.

## Questions for you

1. **An every-N-days due day before days away said over it.** A shipped rule refuses shifting an
   every-N-days due day while any later era of it stands, and days away put one on — the era from
   the day after them. So once days away are said over "Nails", none of its due days before them
   can be shifted until they are over. Shift as though they were not there, or keep refusing?
   - *Recommended:* shift — that era begins its own count whatever a shift before did, so the shift
     undoes nothing, which is all the rule guards; and removing the days away then leaves the shift
     exactly as if they had never been said (settled 13).
   - *If you say keep refusing:* the MODIFIED interval-shift requirement and its new scenario come
     out, replaced by one scenario saying the shift is refused; nothing else in the delta moves.
