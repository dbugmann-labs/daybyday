## Context

See `proposal.md` § *Why*, and `grill.md`, whose twelve settled answers, three layout answers and
seven upstream decisions this delta is written on. The facts it turns on, read off `origin/main` at
fb25f8b:

- **`Commitment.isDue(on:)` is the one dueness answer.** `Tick`, `Number`, `Note` and `Addition`
  refuse to form off it; `History.isKept` re-forms a tick through it; `DayView`'s formation filters
  by it; `LookBack.walkDays` and `CommitmentsScreen`'s recorded-day refusal ask it of each era.
- **The record form writes each record beside its whole `CommitmentRecord`** and re-forms it through
  those same initialisers; a record that does not form refuses the whole store. `CommitmentRecord`
  is shared with the roster form; a copy nests both forms as written and checks each one's form.
- **Equality is the identity alone** on `Commitment`, and through it on `Roster.Entry`, `Roster` and
  `Tick`. `DayView.Row` synthesises equality over its stored properties.
- **`DayScreen` holds a `Roster` value** read from its roster place, and `DayView` already takes the
  roster to read a chain; `DayTitle.weekdayNames` holds the three-letter names a day title says.
- **`CommitmentsScreen.change` composes the next roster, runs the recorded-day refusal, then
  writes**; `confirmStopKeeping` calls `retire` directly. Refusal words live in the shell's
  `refusalText`, one case each.
- **The day screen's one context menu** is a one-off row's *Remove*, a plain `Button`.

## Goals / Non-Goals

**Goals:** the delta, every rule drivable through `Roster`, `RosterStore`, `RecordStore`,
`DayScreen`, `CommitmentsScreen` and a look-back, and the shell drawing option A.

**Non-Goals:** every N days (#393) and retiring restart (#394); any mark of a shift in a look-back
or on the week strip; ending what a day screen tells when a shift is kept, which the shipped
lifetime rule does not list — the row such a notice names is never in view after a kept shift;
condensing the carried MODIFIED requirements, an editorial Story's (ADR-1047).

## Decisions

### The seam

```swift
public mutating func Roster.shift(_ commitment: Commitment, from day: CalendarDate, to other: CalendarDate) -> Bool
@discardableResult public func RosterStore.shift(_ commitment: Commitment, from day: CalendarDate, to other: CalendarDate) throws -> Bool
public struct DayScreen.ShiftDay: Hashable, Sendable { public let date: CalendarDate; public let words: String }
public func DayScreen.shiftDays(for row: DayView.Row) -> [DayScreen.ShiftDay]
public func DayScreen.shift(_ row: DayView.Row, to date: CalendarDate) throws
case CommitmentsScreen.Refusal.shiftedDayAhead
public func Commitment.isDue(on date: CalendarDate) -> Bool
public var DayView.Row.rhythmInWords: String { get }
```

The first six are new; the last two keep their signatures and answer shifts. Commitments-screen,
record and look-back scenarios drive the members they drive today.

### A shift is part of the commitment, every era alike — ADR-1066

`Commitment` gains a package-internal map from each day a shift took a due day from to the day it is
on; `isDue(on:)` answers it before the schedule. Every initialiser that forms an era of a commitment
or renames one carries the map, and `Roster.shift` writes it on every era of the identity.
- *Held by the roster beside the commitment:* rejected — the record store has no roster and could
  not re-form a record on a landing day.
- *Held by the era the shift was made in:* rejected — a landing on today would vanish under a
  rhythm change made today, which settled 7 lets through.

### A free day is held by the era holding the shifted day

Settled 6 bounds a free day by the days the commitment runs on. The delta bounds it by the one era,
which says the same of a gap and of the day kept from, and adds only the week a rhythm change
splits — so no shift straddles two rhythms and no landing falls in an era it was not judged by.
- *Any running day, judged by the era holding it:* rejected — a landing could fall in an
  every-N-days era, whose shift is #393's and runs its count on.

### Settled 7 is read as written: an end on today refuses nothing

A shift whose later day is today does not refuse a change made today, and stands through it: its
landing stays due in the new era. A stop made today ends today's due day, shifted there or not,
exactly as it ends any due day. A stopped commitment's days shift within their own era; nothing a
stop protects is reachable that way.

### The screen offers, the roster judges

`shiftDays(for:)` asks `Roster.shift` on a copy for each other day of the row's week and keeps the
ones it accepts, then applies the day screen's own two rules: no record on the row's day — read off
the row, a tick, a number, a note or a sum above zero — and a record and a roster both kept.
`shift(_:to:)` acts only on a day `shiftDays` offers, so the two cannot disagree. The words are
`DayTitle.weekdayNames`, and "from Mon"/"to Tue" are composed in `DayView.Row`.

### The row stores its shift

`DayView.Row` stores the day its due day came from or went to, so a row before and after a shift
are different rows; without it the origin row equals the row it replaced and SwiftUI keeps its old
words. A row of a day a shift took a due day from is formed with `isKept` false, and its four offers
answer `nil` off that stored day.

### The shell

`rowView` attaches a `.contextMenu` only where `shiftDays(for:)` is non-empty (settled 11), holding a
`Menu("Shift to")` of one `Button` per day, labelled with its `words`, calling `keeping { try
screen.shift(row, to: day.date) }`. The fade and the words are `offersAnything` and `rhythmInWords`,
unchanged. `refusalText` says "Shift its day back first." for `.shiftedDayAhead`. The walk is light
only and has no `phone:` line, as settled 12 says; XCUITest drives a long press and a menu.

### What the shell draws

Option A, *In the rhythm's place*, from https://claude.ai/artifact/CXzkYmYUjNUXZGbiBRs3P8.

```
A · In the rhythm's place            (recommended)
  Tuesday — landing day
  │ Gym  - from Mon                          │   unticked: no mark
  │ ~~Gym~~ - from Mon                     ✓ │   ticked: grey struck name, green check
  Monday — origin day, paged back
  │ Gym  - to Tue                            │   whole row faded (0.5), no tap

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

### Migration

The roster form moves from 7 to 8, carrying each entry's shifts, an empty list where none. The record
form moves from 6 to 7, carrying beside a record on a day a shift put due the day that shift took it
from, and nothing beside any other. An earlier form of either reads as holding no shift and stays
byte-for-byte until the next kept change. The copy's form stays 3: it nests both as written, and its
later-form check already refuses a copy an older app cannot read.

## Risks / Trade-offs

- [Identity equality hides a shift from `==` on `Commitment`, `Roster.Entry` and `Roster`] → nothing
  may skip a write, a redraw or a carry by comparing them; the row-equality scenario guards the view.
- [An era or rename initialiser that drops the map strands a record on a landing day] → the scenario
  renaming and re-rhythming over a ticked landing; `RecordStore.carryOver` force-unwraps a re-formed
  tick, so a crash there is a stop, never a guard added.
- [A record written without its shift refuses the whole record store on the next open] → the record
  scenario reads one back after a later shift, and one written without it is refused.
- [`CommitmentRecord` is compared whole by `bare` in the fold and in record ordering] → `bare` drops
  shifts; no pre-identity form holds one.
- [Ten carried day-screen requirements and two commitment ones gain a clause or a sentence each] →
  some were over the prose budget on `main`; the `check:budgets` warnings are expected.

## Open Questions

`grill.md` § *Left open* is "None." Writing the delta raised one question that is the owner's,
below; the edges answered from settled reasons are recorded under Decisions.

## Questions for you

1. **Moving the day kept from while a shift lies ahead.** Settled 7 refuses a rhythm, range or
   target change and a stop while a shift has a day after today; the day kept from was not asked.
   Refuse its move too, with the same words?
   - *Recommended:* refuse it — one rule for every edit that decides due days, and settled 7's own
     reason: a day kept from moved past a shift ahead would leave its landing outside the days the
     commitment runs on, dropped without a word.
   - *If you say no:* the commitments-screen refusal drops "a different day kept from", and its
     scenario *a move of the day kept from is refused while a shift has a day after the day handed*
     becomes one where the move is kept and the shift stands; nothing else in the delta moves.
