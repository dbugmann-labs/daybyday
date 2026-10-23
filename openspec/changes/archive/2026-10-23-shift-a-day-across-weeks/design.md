## Context

See `proposal.md` § *Why*, and `grill.md`, whose nine settled answers this delta is written on.
The facts it turns on, read off `origin/main` at 0d014b6:

- **The week bound is one function asked in three places.** `Shift.couldBe(from:to:)` is asked by
  `Roster.shift` before its reshift branch, against the landing rather than the day it came from,
  and by `CommitmentRecord`'s read beside a record; `Shift.couldBe(from:to:in:)` by
  `RosterDocument`'s read, sparing a shift where an era holding either day runs every N days.
- **`DayScreen.shiftDays(for:)` asks `Roster.shift` on a copy for each candidate**: the seven days
  of the row's week on a weekday set or a day of the month, ±2 intervals on every N days.
- **Words**: `DayView.Row.shiftedDayInWords` and `shiftDays` say a weekday alone but on every N
  days, where `DayTitle.shiftedDayInWords` says "Thu 27 Aug". The shell draws `ShiftDay.words` and
  `rhythmInWords` as given, so nothing here needs `src/DayByDay/` to change.
- **Days away**: a weekday-set shift today refuses only a landing on a hidden day, so one inside
  its week may cross days away; an every-N-days shift may not.
- **Forms**: the roster store writes form 11, the record store form 9, each on every save.
- **The offer's cost**: `docs/open-questions.md` measured 1.0 ms a call at N = 14, 57 candidates,
  in a release build, asked on every redraw of every row.
- **A look-back** has no week lines for these shapes, and already counts a due day moved between
  months.

## Goals / Non-Goals

**Goals:** the delta, every rule drivable through the members in § *The seam*, every shift kept on
a phone today read as it was, and the walk.

**Non-Goals:** days away said later between a shift's two days stay allowed, as on every N days;
the shell asking for the offer on every redraw (the open-questions entry); the shifted-day-ahead
refusal (settled 7); weekly quotas; any word in a look-back.

## Decisions

### The seam

No signature changes; every rule is driven through members that exist.

```swift
public mutating func Roster.shift(_ commitment: Commitment, from day: CalendarDate, to other: CalendarDate) -> Bool
public func RosterStore.shift(_ commitment: Commitment, from day: CalendarDate, to other: CalendarDate) throws -> Bool
public init RosterStore(at place: URL) throws
public init RecordStore(at place: URL) throws
public func DayScreen.shiftDays(for row: DayView.Row) -> [DayScreen.ShiftDay]
public func DayScreen.shift(_ row: DayView.Row, to date: CalendarDate) throws
public var DayView.Row.rhythmInWords: String
```

### A shift is judged from the day it came from

`Roster.shift` on a weekday set or a day of the month first finds the day the due day came from —
the origin of the shift that put it on `day`, or `day` itself — and lifts that shift; then judges
`other` against the era holding the origin: held by it, due by neither its schedule nor another
shift, in the origin's week or after the schedule's due day before the origin and before the one
after it, and the origin itself only where an era holding it is due on it by its schedule (settled
3, grill § *Left open*). Days away refuse only a landing on or a shift from a day they hide, never a
crossing (settled 5); the every-N-days crossing rule stays on every N days alone. The neighbours are
found by asking the schedule alone back and forward from the origin — at most 6 days on a weekday
set, 30 on a day of the month — so neither an era nor a shift moves them (settled 4).
- *The week check kept ahead of the reshift branch:* rejected — it judges a landing in another week
  against its own week, so Pool's Monday could never go back to its Friday.
- *The every-N-days crossing rule on every shape:* rejected at the residual round — a weekday set
  has no count for days away to restart, and it would take away the in-week crossing that ships.

### The stores judge a shift's shape, never its reach

Both reads drop the week rule: the roster store refuses one day twice, two shifts from or onto one
day, and eras carrying different shifts; the record store, beside a record not every N days, a
shift from its own date or carrying a landing. `Shift.couldBe` goes. Every reach is judged where
the shift is made, and one judged again at read is one a later change of era or of the day kept
from can turn into a refused store, which loses every commitment at once.
- *The new reach re-judged at read:* rejected — the failure ADR-1066's every-N-days rule already
  guards against, now over month-long reaches.
- *A distance cap, 31 days:* rejected — a number with no rule behind it, refusing nothing real.

### Migration

The roster form moves from 11 to 12 and the record form from 9 to 10, neither with a change of
shape, so an older app refuses a store holding a shift across weeks as a later form rather than as
content that is not a store. Every store on a phone today reads as it was: each weekday-set or
day-of-month shift in it lies in one week, which the new free days include (settled 1). The copy's
form stays 4; it nests both stores as written.

### The offer walks the origin's reach, and every day is said with its date

`shiftDays(for:)` on a weekday set or a day of the month asks `Roster.shift` for each day from 6
before the origin to 6 after it on a weekday set, 30 either side on a day of the month — the
widest a free day can lie — and every N days keeps its ±2 intervals. Words come from
`DayTitle.shiftedDayInWords` for every shape, in the offer and in `Row.shiftedDayInWords` alike.
On the measured rate that is about 0.2 ms a weekday-set row and 1.1 ms a day-of-month row per
redraw, an estimate; the open-questions entry's cure, asking only when the menu opens, covers both
and nothing more is done here (grill § *Left open*).
- *±2 intervals around the row's day, as every N days:* rejected — a fixed window for shapes whose
  reach the schedule already bounds, twice as wide as needed.

### Where the rules sit

That days away lying between refuse nothing is written into the weekday-set free day, not into
the days-away shift requirement, whose prose is at its budget. OpenSpec refuses a scenario renamed inside a MODIFIED
block, so that requirement and the day screen's offer are each REMOVED and ADDED under a new title,
carrying every scenario. Settled 8 asks for a walk though the diff stays out of `src/DayByDay/`, as
#393 walked one, so § *What the shell draws* is carried for the reviewer to read it against.

### What the shell draws

No layout question at this grill: #392's option A, `archive/2026-10-08-shift-a-due-day/grill.md` §
*Layout*, in #393's dated form. The wireframes, verbatim from `grill.md` § *Layout*:

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

## Risks / Trade-offs

- [Carried tests asserting undated words, a week's days offered or the old forms turn red] →
  `tasks.md` names each scenario whose test is edited; any other carried edit is a stop.
- [An older app on a downgrade refuses both stores] → as a later form, as after #393.
- [A landing up to a month ahead holds the shifted-day-ahead refusal that long] → settled 7.
- [Two shifts of one commitment fall out of order] → settled 4; nothing reads their order.
- [Carried requirements were already over the prose budget on `main`] → `check:budgets` warnings
  on them are expected.

## Open Questions

None. The residual round's one question — whether a weekday-set shift may cross days away — is
settled as "allow" (`grill.md` settled 5) and written into the delta; the three items `grill.md` §
*Left open* gave this delta — the forms, the order of the week check, the offer's cost — are
decided above.
