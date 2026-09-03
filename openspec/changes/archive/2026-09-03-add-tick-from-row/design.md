## Context

`DayByDayKit` exports five seams today: `Schedule.isDue(on:)` (#8, #9, #10, #11), `Commitment`
(#42), the pair `Tick`/`History` (#55), `RecordStore` (#56) and `DayView` (#70), the newest and the
only one that speaks for a whole day. Since #81 it also has a caller: `src/DayByDay`, the app shell
ADR-1019 built on a chore branch, which draws `DayView.rows` in the iOS Simulator and decides
nothing. Everything in the package is a pure value over
`CalendarDate` with no clock, no time zone and no locale (ADR-1004). Motivation is in `proposal.md`;
the behaviour contract is in `specs/day-screen/spec.md` and is not repeated here.

What is new is that this is the first thing in the package that has to know *when* it is. Every
question so far has been asked of a date and answered for all time. "Can this be ticked?" is not:
tomorrow's answer is different from today's, not because the rule changed but because the day did.
That makes the interesting questions three — where the day enters, what comes back out, and what
that does to a value that was closed a Story ago.

**Measured on this machine on 2026-09-03 rather than recalled.** `cd src/DayByDayKit && swift test`
reports 135 tests passing at `b26914a`, on Apple Swift 6.3.3 (swiftlang-6.3.3.1.3), target
`arm64-apple-macosx26.0`; `openspec` is 1.10.0 and `node --version` is v24.19.0. Every weekday this
delta pins was checked twice — once in Python's proleptic Gregorian calendar and once in
Foundation's own `.gregorian` calendar under UTC, which is the calendar `CalendarDate` uses — and
both agree: in 2026, 31 August is a Monday, 1 September a Tuesday, 2 September a Wednesday, 5
September a Saturday and 6 September a Sunday; 1 January 2026 is a Thursday, deliberately not a day
any schedule here is due on, since a commitment need not be kept from a due day (ADR-1013). 3
January 1583 and 27 December 9999 are both Mondays, which is what lets one scenario pin both ends of
the supported range against the same weekday set.

Six facts about the shipped code that this design stands on, read out of the sources rather than
assumed. The last two arrived with #81, after this design was first written, and are the reason it
was revisited before G4:

- `Tick.init?(_:on:)` refuses exactly when the commitment is not due on the date, and consults
  nothing else — no clock. So a tick for a future date is formable today, and `RecordStore` will
  read one back without complaint.
- `History.add(_:)` and `History.remove(_:)` are public, as are `RecordStore.add(_:)` and
  `RecordStore.remove(_:)`. Everything this Story needs to *apply* a tick already exists and is
  reachable.
- `RecordStore.history` is `public private(set)`. A store cannot be handed a replacement history, so
  any seam here that produced *a new history* would be unusable by the screen that actually holds
  the record. A seam that produces *a tick* composes with both `History` and `RecordStore`
  unchanged.
- `CalendarDate` is `Hashable, Sendable` and nothing more: it is not `Comparable`, `days(until:)` is
  internal, and `year`, `month` and `day` are internal. **An app target cannot compare two dates at
  all.** Whatever else is true, the "has this day arrived?" judgement cannot be made outside this
  module today — and now that there is an app target to check, that is a fact about a real caller
  rather than a prediction about a future one.
- **The day this seam asks for is already computed, and correctly.** `ContentView.today()`, landed
  by #81, reads `Calendar.current.dateComponents([.year, .month, .day], from: Date())` and rebuilds
  a `CalendarDate` from those three numbers. That is the right conversion rather than merely a
  present one: it takes the day the *device's own* calendar and time zone are on and then treats
  those parts as a bare date, so nothing is pushed through a UTC instant and nothing is a day out
  near midnight. It is the edge conversion ADR-1004 reserves for the app, and this Story is its
  first consumer — the argument `tick(asOf:)` wants already exists and is already right.
- **The shell keys a SwiftUI list on `Row`'s equality:** `List(dayView.rows, id: \.self)`. This
  delta changes that equality (§ *Row equality gains the date*), so it was checked rather than
  assumed: every row of one day view carries that day view's date, so any two rows *within a list*
  compare exactly as they did before, and the shell's behaviour is unchanged. The change is only
  observable between day views on different dates, which nothing draws in one list.

## Goals / Non-Goals

**Goals:**

- One place a tap can be made from, which is the row, and which needs nothing given to it but the
  day it is being asked on.
- A refusal that lives where `record` said it would — *"a screen that wants to withhold days that
  have not arrived does so itself, with the day it asked the device for"* — expressed as a value
  rather than as a comment in a view.
- The clock still outside the package. The day arrives as an argument, so every acceptance test
  gives the same answer in every time zone and for ever.
- Purely additive. #70's three requirements were signed on 2026-09-02 and none of them moves; the
  delta is two ADDED requirements and no MODIFIED one.
- The smallest public surface that makes the delta observable, and not one member more.

**Non-Goals:**

- Anything drawn, and any gesture. Whether one tap both ticks and unticks, whether a refused row is
  greyed, and what a failed store write shows a person are the app target's. It exists as of #81,
  and it draws a plain `List` of names with no tap in it at all — so none of those choices has been
  made yet, and the seam serves any of them.
- Reading the device's day. Nothing here asks Foundation what today is. The conversion from a
  device-local day to the `CalendarDate` this seam takes is the app target's, it is written, and
  #81 put it where ADR-1004 says it belongs — `ContentView.today()`. This Story consumes it and
  does not move, wrap or duplicate it.
- Applying the tick. `History` and `RecordStore` already do that and neither is widened, wrapped or
  mentioned by the new member's signature.
- Moving between days. That is #72, and it is the Story that will want `DayView`'s date exposed.
- Deciding whether a week's quota has been met, or hiding a quota commitment once it is. ADR-1015's
  cost, deferred by #27's G2, and a scenario here pins that this Story does *not* fix it.
- Widening `CalendarDate`, `Commitment`, `Schedule`, `Tick`, `History` or `RecordStore`. The known
  gap in `docs/open-questions.md` about a schedule's payload not reading back is untouched: a row
  hands out a tick, never a schedule.
- Bounding how far back a row may be ticked. Settled already — a tick exists exactly where the
  commitment is due, and ADR-1013 floors that at the kept-from day — and how far back a person can
  *navigate* is #72's.

## Decisions

### The seam

**Existing: `DayView`, widened by exactly one public member on its nested `Row`.** No new seam,
nothing moved, nothing else exported.

```swift
public struct DayView: Hashable, Sendable {
    public struct Row: Hashable, Sendable {
        public var name: String { get }
        public let isKept: Bool

        /// The tick this row makes, or `nil` when the row's date is later than `today`.
        public func tick(asOf today: CalendarDate) -> Tick?
    }

    public let rows: [Row]

    public init(of commitments: [Commitment], on date: CalendarDate, in history: History)
}
```

Internally `Row` gains a stored `date: CalendarDate`, which `DayView.init` passes down from its own;
`commitment` stays stored and internal. Fourteen scenarios in the delta observe that one member and
row equality. No process is spawned and no global stream is captured. `AGENTS.md` prefers an
existing seam over a new one and this is as close as that preference gets: the tap is made on the
thing the screen already draws.

The screen's whole use of it is two lines, and there is no third:

```swift
guard let tick = row.tick(asOf: today) else { return }   // the day has not arrived
try row.isKept ? store.remove(tick) : store.add(tick)
```

### Where the day enters: at the question, not at the day view

**Chosen: `Row.tick(asOf:)` takes the day. `DayView.init` is unchanged.**

*Alternative — `DayView.init(of:on:in:asOf:)`, a fourth thing a day view is formed from, with the
row then carrying a plain `tick: Tick?`.* Rejected on three grounds, the first two of which are the
ones that decide it.

It would MODIFY the requirement *"A day view is the commitments due on a date, each with whether it
is kept"*, which the owner signed on 2026-09-02 and re-signed after #74's G7. A MODIFIED requirement
restates the whole block, so twelve scenarios would be copied forward and re-approved to add an
argument that changes none of them. Purely additive is worth a lot here.

It also puts a *time-varying* answer inside a value whose whole point is that it does not vary. A
day view is an answer as the history stood (#70's third requirement); making the day part of its
formation gives it a second thing it is a snapshot of, and that one goes stale on a boundary nobody
controls. An app left open overnight would hold a day view that refuses today's tick because it was
formed yesterday, and the bug would appear once a night at midnight — the hardest kind to see and
the easiest to ship. Asking at the tap makes the staleness window exactly the length of the tap.

Third and smallest: it would force the question *is the day part of what a day view is?* Under
`tick(asOf:)` the question never arises, because the day is never kept.

*Alternative — `DayView.tick(rowAt: Int, asOf:)`, keeping `Row` as it is.* Rejected: an index is a
second way to say which row, it needs a bounds check, and `nil` would then mean either "no such row"
or "not yet" — two refusals in one `Optional`. Handing the whole `Row` instead is worse still: rows
are `Hashable` values with no provenance, so a row from another day view would be accepted and
answered on *this* view's date.

### What comes back: a tick, not an applied change

**Chosen: `Tick?`.** The row hands out the tick and applies nothing.

This is settled by a fact rather than a preference. The screen holds a `RecordStore`, whose
`history` is `public private(set)`: it can be given a tick to add or take back and nothing else. A
seam returning a new `History`, or one mutating an `inout History`, would compose with `History`
alone and be useless to the only caller there will ever be — unless `record` were widened to accept
a whole history, which would put a `day-screen` Story's convenience inside the capability that
guarantees durability. `Tick?` is the one shape that composes with what is already public.

*Alternative — an enum saying which of the two a tap means, `case make(Tick)` / `case
takeBack(Tick)` / nothing.* Attractive against `docs/open-questions.md` § *No UI smoke layer*,
because it would move the add-versus-remove decision into a tested seam. Rejected because it moves
nothing: its content is exactly `(isKept, tick)`, both of which the row already gives back, so the
view writes a two-case `switch` where it would have written a two-branch `if` — the same untested
line count, one more public type, and `isKept` said twice. The delta pins the behaviour that matters
without it: two scenarios add the offered tick and take it back through `History` and read the
result off a day view formed again, so "this is the tick that keeps it, and the same one takes it
back" is asserted at the seam rather than asserted about SwiftUI.

*Alternative — expose the row's `Commitment` and let the caller form the tick.* Rejected: it exports
a shape nobody has signed, hands every caller the schedule and the kept-from day it has no use for,
and puts the `Tick.init?` optional — which can never be `nil` here — in front of every call site.

**`nil` is the whole of the refusal, and it needs no reason attached.** There is exactly one, so
there is nothing to distinguish. A row exists only for a commitment that is due on the day view's
date, and being due is precisely what `Tick.init?` requires, so `return Tick(commitment, on: date)`
after the day guard can be written with no `!` and no second failure path: the type is already
`Tick?` and the only branch that yields `nil` is the guard. That is worth having — a force-unwrap
here would be a claim about another type's internals.

### The comparison, and which way it points

**Chosen: refuse when `today.days(until: date) > 0`; offer otherwise.** Strictly later refuses; the
row's own date and every earlier one offer. `days(until:)` is internal and this code is in the same
module, so no new API is needed and no date arithmetic is reinvented — it is the same function
`Commitment.isDue(on:)` uses for the kept-from floor, which is worth keeping to one implementation.

Two scenarios sit either side of the boundary — a row asked as of its own date offers, one asked as
of the day before does not — because an off-by-one here silently costs a person today's tick, which
is the single interaction the product exists for.

### A future row that says it is kept refuses too

**Chosen: a row whose date has not arrived offers nothing, whether or not it says the commitment is
kept.** The refusal is about the day, not about the record.

This can only be reached by a store that already holds a tick for a future date, and nothing in the
app can write one: this Story is the only path to a tick and it refuses. `Tick.init?` never consults
the clock, though, so a future tick is *formable*, and `RecordStore` reads one back without
complaint — so the state is reachable if a device's clock is set forward, a tick made, and the clock
then corrected.

Refusing whole keeps one rule instead of two, keeps the row's answer independent of the history, and
avoids an affordance that responds on some future rows and not others. Its cost is that a record
made under a wrong clock cannot be taken back until its day arrives, which it does. Because that
cost falls on the record rather than on the mechanism, it was put to the owner rather than settled
here. **He answered on 2026-09-03: refuse whole** — the recommendation, and the delta was already
written on it, so nothing moved. `## Open Questions` carries the settlement.

### Row equality gains the date

**Chosen: `Row` counts its date towards what it is, and one requirement plus three scenarios say
so.** Two rows for the same commitment saying the same thing on different dates stop being equal.

This is an observable change to a public `Hashable` type, so it is stated rather than smuggled in as
an implementation detail — but it is an ADDED requirement, not a MODIFIED one. #70's third
requirement enumerates when two *day views* differ and never defines row equality; nothing in it
says two rows on different dates are the same row, and nothing about day-view equality changes
either way, since day views already differ by date. No existing test compares rows across dates, so
all 135 stay green.

It is also the honest answer rather than a consequence tolerated: after this change a row is a thing
you can act on, and two rows that would tick different days are not interchangeable.

*Alternative — store the fully formed `Tick` on the row instead of the date.* Identical in
behaviour, since a tick is a commitment and a date, and it would make `tick(asOf:)` a return rather
than a construction. Rejected as slightly worse to read: the row would then hold its commitment
twice, once directly for the name and once inside the tick.

### No ADR

The decision that would have earned one — that the engine never reads a clock, and every "now"
arrives as an argument — is ADR-1004's already, and this delta applies it rather than deciding it
again. Nothing else here clears all three bars. Where the day enters is a one-line seam change to
reverse and is argued above where a reader will look for it; what comes back is settled by a fact
about `RecordStore` rather than by a trade-off; and row equality follows from what a row now does.

## Risks / Trade-offs

- **The caller can pass any day as `today`, including a wrong one or a hostile one.** → Deliberate,
  and the same trade `record` already took: the package cannot both stay clock-free and police the
  clock. The one caller is the app target, in the same repository, and the mitigation is that there
  is exactly one line to get right and this design names it. A wrong day cannot corrupt the record —
  the worst it does is offer or refuse a tick a person can see is wrong.
- **The device-local day and a UTC `CalendarDate` are not the same thing.** → Real, and already
  handled where it belongs rather than left owing: `CalendarDate` is UTC by ADR-1004, and an app
  target that pushed `Date()` through the wrong time zone would be a day out near midnight.
  `ContentView.today()` does not — it reads `Calendar.current`'s year, month and day and rebuilds
  the date from those parts. This design was first written expecting to *flag* that conversion as
  an owed gap; #81 wrote it first, so what is left is only that a second caller could get it wrong,
  and the mitigation is that there is one caller and this design names the line.
- **Nothing proves a button is wired to `tick(asOf:)`.** → `docs/open-questions.md` § *No UI smoke
  layer*, unchanged and still open. This design mitigates rather than closes it by keeping the
  decision inside the seam and leaving the view two lines with no judgement in them.
- **A screen that holds a day view across midnight still shows yesterday's rows.** → Out of scope
  and correct: the day view is of a date, and which date a screen shows is #72's. Only the *tick*
  refusal follows the clock here, and it follows it exactly.
- **`Row` is public and `Hashable`, so its equality is API — and a live caller uses it.** → Changed
  knowingly, pinned by three scenarios, and argued above. The one caller, `src/DayByDay`, keys a
  SwiftUI `List` on it with `id: \.self`; that was checked against the source rather than assumed
  safe, and it is unaffected, because every row in one list shares that list's date. What the change
  *could* break is something relying on two rows for different days being interchangeable, which is
  exactly the thing this Story makes false.

## Open Questions

**None.** Everything the grill raised was either a fact that was measured or read out of the shipped
sources, or a decision made above with its alternatives:

- *Where does the day come from?* — read: `CalendarDate` is not `Comparable` and its parts are
  internal, so the judgement cannot be made outside the module at all. The row makes it, from a day
  the caller supplies.
- *Can the seam apply the tick instead of offering one?* — read: `RecordStore.history` is `public
  private(set)`, so a seam producing a history is unusable by the real caller. Settled by that fact,
  not by taste.
- *Can `Tick.init?` fail for a row?* — read: it refuses exactly when the commitment is not due, and
  a row exists only where it is due. It cannot, and the code needs no force unwrap to say so.
- *How far back may a row be ticked?* — already settled: `docs/open-questions.md` § *Settled*,
  2026-09-02, the past is writable back to the kept-from day and no further, which is where a row
  stops existing anyway.
- *Does this force the week-turnover product question?* — no. Nothing here reads a week; the quota
  scenario deliberately says "three ticks in the seven days up to it" rather than naming a week,
  because where a week begins is still undecided (`CONTEXT.md` § *Weekly quota*) and nothing in this
  delta needs it.
- *Does a future row that says it is kept refuse the take-back too?* — the one thing here that was a
  preference rather than a fact, so it was not settled by an agent. Raised as a question round on
  2026-09-03 and **answered the same day: refuse whole.** A row whose day has not arrived does
  nothing at all, whether or not something already says the commitment is kept; the refusal is about
  the day and not about the record. The delta had been written on that recommendation, so folding
  the answer in changed no requirement and no scenario — the round is closed and `## Questions
  for you` is gone. Argued at § *A future row that says it is kept refuses too*, and pinned by the
  scenario *"a row for a date later than the day it is asked as of offers no tick even where it
  says the commitment is kept"*.
