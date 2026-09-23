## Context

See `proposal.md` for the why and `grill.md` for the eighteen settled answers this delta is written
on. The facts it turns on:

- `Roster.add(_:)` takes a stopped commitment up again by setting its newest entry's `keptUntil` to
  `nil`; `CommitmentsScreen.keepAgain(_:)` calls it through `RosterStore.add(_:)` with no date.
- `CommitmentsScreen.confirmStopKeeping()` hands `retire` the day before `dayToKeepFrom`, and holds
  `recordStore`, `nil` where the record place cannot be read; a stop needs only the roster store.
- `Roster.mended(_:)` never touches the newest era, keeps an older era's earlier `keptUntil`, and
  joins two alike neighbours whatever lies between them, so a resumed era alike the stopped one
  would be joined back over the gap on the next read.
- `Roster.commitments(on:)` answers every era whose `keptUntil` is on or after the date, and a
  newest era on every date; the day view drops what is not due. A gap therefore already draws no
  row once the resumed era is kept from the resume day.
- `LookBack.walkDays` buckets a day only where an era holds it, so a month or week wholly in a gap
  says no line; a week line owes the quota of the last quota era walked.
- `DayView` forms a quota row's standing with `History.standing(for:through:)`, which forms a `Tick`
  against the row's era and so drops a tick made before that era's day kept from.
- No shipped view in `src/DayByDay/` composes a quota's words or takes a date for a stop or a resume.

## Goals / Non-Goals

- **Goals.** A pause costs nothing and draws nothing; a stop keeps what was entered that day; one
  number for what a week owes, on both screens.
- **Non-Goals.** Picking a resume day (settled 1). Any shell change, walk or layout round. Recovering
  a gap a resume already cleared before this ships (grill fact). Condensing the carried
  requirements already over the prose budget, an editorial Story's (ADR-1047).

## Decisions

### The seam

```swift
public mutating func Roster.keepAgain(_ commitment: Commitment, from date: CalendarDate) -> Bool
@discardableResult public func RosterStore.keepAgain(_ commitment: Commitment, from date: CalendarDate) throws -> Bool
public mutating func Roster.retire(_ commitment: Commitment, keptUntil date: CalendarDate) -> Bool
public init(at place: URL) throws
@discardableResult public func CommitmentsScreen.confirmStopKeeping() -> Refusal?
@discardableResult public func CommitmentsScreen.keepAgain(_ commitment: Commitment) -> Refusal?
public func CommitmentsScreen.lookBack(at commitment: Commitment) -> LookBack?
public func Schedule.inWords(given count: Int, owing owed: Int) -> String
public var DayView.Row.rhythmInWords: String { get }
```

The first two and the eighth are new; the rest keep their signatures and move behaviour. The fourth
is `RosterStore`'s. Day-screen scenarios drive `DayScreen` at its places, as they already do.

### A resume is a dated take-up-again, and `add` stays the undo

`keepAgain(_:from:)` puts the new era on and mends, or clears `keptUntil` where the new era would
begin no later than the day after it. `add(_:)` offered a stopped commitment keeps doing what it
does, which is that same undo, so every carried roster scenario that takes up again through it
stands. The screen's one tap calls `keepAgain(_:from: dayToKeepFrom)`. The two shipped requirements
that describe that path are MODIFIED to scope it: offered again as itself, a stopped commitment is
taken up as though never stopped, and a take-up-again leaving a gap is made only from a day.
- *`add` refuses a stopped commitment:* rejected — every carried test taking up again through it
  is rewritten, for no behaviour a person sees.
- *`add` takes a date:* rejected — every caller changes to pass a day most of them never need.

### A resumed era is kept from the later of the resume day and the stopped era's day

This is the rule a rhythm change already follows, so a commitment kept from a future day and
stopped before it can never be resumed into an earlier start. For a past day kept from, which is
every screen-reachable case but that one, it is the resume day, as settled 1 and 13 say.

### One mend carries the gap and the stop's collapse

`mended(_:)` joins alike neighbours only with no day between them, and drops a stopped newest era
holding no day while an older one stands, the older taking its state, category and the earlier
`keptUntil`. `retire` runs it after recording the day, so settled 7 is the roster's and the reader's
alike, and a stopped empty era an earlier build wrote reads the same way.
- *Collapse in the screen only:* rejected — the reader would still hold what the screen avoids.

### The stop day's record is any record the history holds

`confirmStopKeeping` asks the history for any record of the commitment on `dayToKeepFrom`, the four
kinds alike; an addition short of its target counts (settled 9: something the person did that day).
A screen whose record cannot be read hands the day before, as it ships: nothing is known to keep.

### One week rule, in one place

A package-internal helper takes a commitment's chain of eras, each with the last day it holds or
none, a history and a week, and answers the days kept against a quota era and what the week owes.
`LookBack.walkDays` and `DayView`'s row both call it; `DayScreen` hands the day view the roster so a
row can read its chain, and a day view formed from bare commitments reads each as its only era.
Gap days are bucketed in the unit of the era before the gap and owe nothing.
- *Keep `History.standing` for the row:* rejected — it drops a tick before the era (settled 15).

### Three answers the grill did not reach, taken from its reasons

A week's standing and its line count only days a weekly-quota era holds, so a row and a line agree
in a week a weekday era shares (settled 12). A gap between a quota era and one that is not is said in
the era before it; nothing is owed either way, and the stop is what the gap belongs to. A row in a
week owing nothing says "0/0x a week", settled 16 read through settled 12.

### ADRs

`docs/adr/1061-a-part-week-owes-its-quota-in-proportion.md` records the reversal of the whole-quota
rule. ADR-1023 (the take-up-again consequence and the stop-day price), ADR-1050 (what a row's
standing counts) and ADR-1059 (a gap between eras) are amended in place.

### Migration

None — the form does not change. A gap is an older era whose `keptUntil` is earlier than the day
before the next era; every build since identities reads it. A stored stopped newest era holding no
day behind an older one is read with it dropped, the place untouched until the next change. A
commitment resumed before this ships already lost its gap, and nothing recovers it.

## Risks / Trade-offs

- [Five carried look-back scenarios and one mend scenario change a fraction, a fixture or a title,
  and their tests with them] → tasks.md § 1 names them; any other carried test gone red is a stop.
- [`History.standing(for:through:)` keeps its `record` requirement but no row reads it] → left for a
  later Story; its own tests stay green.
- [Nine carried MODIFIED requirements stay over the prose budget, and `check:budgets` reads the
  REMOVED block's reason as prose] → condensing is an editorial Story's; the warnings are expected.

## Open Questions

None. `grill.md` left nothing open. Writing the delta raised three edges — a mixed week's standing,
a gap between units, a row owing nothing — and each is answered by a settled reason, recorded above,
rather than by a preference only the owner holds.
