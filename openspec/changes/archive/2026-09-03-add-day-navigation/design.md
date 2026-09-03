## Context

`DayByDayKit` exports five seams: `Schedule.isDue(on:)` (#8–#11), `Commitment` (#42), the pair
`Tick`/`History` (#55), `RecordStore` (#56) and `DayView` (#70, widened by #71). Since #81 it has a
caller, `src/DayByDay`, the app shell ADR-1019 built on a chore branch, which draws one day view's
rows in the iOS Simulator and decides nothing. Everything in the package is a pure value over
`CalendarDate` with no clock, no time zone and no locale (ADR-1004). Motivation is in `proposal.md`;
the behaviour contract is `specs/day-screen/spec.md` and is not repeated here.

This is the third Story on `day-screen` and the first that moves rather than answers. #70 made a day
view of a date; #71 let its rows be tapped. Neither gets you off that date, and this Story is what
the shell needs before either is usable for the thing the product exists for — reaching a day you
missed.

**Measured on this machine on 2026-09-03 rather than recalled.** `cd src/DayByDayKit && swift test`
reports **149 tests passing at `12f768d`**, on Apple Swift 6.3.3 (swiftlang-6.3.3.1.3), target
`arm64-apple-macosx26.0`; `openspec` is 1.10.0 and `node --version` is v24.19.0. Every weekday this
delta pins was checked twice — once in Python's proleptic Gregorian calendar and once in
Foundation's `.gregorian` calendar under UTC, the one `CalendarDate` itself uses — and both agree:
in 2026, 31 August is a Monday, 1 September a Tuesday, 2 September a Wednesday, 30 September a
Wednesday, 1 October a Thursday and 31 December a Thursday; 1 January 2027 is a Friday; 28 February
2028 is a Monday, 29 February 2028 a Tuesday and 1 March 2028 a Wednesday; 28 February 2100 is a
Sunday and 1 March 2100 a Monday, 2100 being a century year that is not a leap year; 1 January 1583
is a Saturday and 2 January 1583 a Sunday; 30 December 9999 is a Thursday and 31 December 9999 a
Friday. 1 January 2026 is a Thursday, deliberately not a day any schedule here is due on, since a
commitment need not be kept from a due day (ADR-1013).

Five facts about the shipped code that this design stands on, read out of the sources rather than
assumed:

- **`DayView` holds only its rows and its date.** `date` and `Row.commitment` are internal, `rows`
  is public. It keeps neither the commitments it was handed nor the history it read — #70 settled
  that as *"it is what it holds"*, and #74's G7 corrected the requirement to say so. So a day view
  **cannot** re-form itself for another date. Anything that moves must be handed the commitments and
  the history again; that is not a design preference, it is the shape of the value.
- **`CalendarDate` cannot step a day, publicly or internally.** It has `weekday`, `daysInMonth` and
  `days(until:)`, all internal, and `days(until:)` measures a distance rather than producing a
  date. There is nothing today that answers "the day after this one".
- **`CalendarDate` gives nothing back.** `year`, `month` and `day` are internal and it is not
  `Comparable`; the only public members are `init?(year:month:day:)` and the `Hashable` conformance.
  An app target holding one can compare it for equality and nothing else.
- **`CalendarDate.init?` already refuses both ends.** Its guard is
  `(1583...9999).contains(year)`. Measured against Foundation: adding one day to 31 December 9999
  gives 10000-01-01 and subtracting one from 1 January 1583 gives 1582-12-31, and both are refused
  by that guard. The bound this Story needs therefore falls out of a check that already exists and
  is already tested (`openspec/specs/schedule/spec.md`), rather than being a second copy of the
  years 1583 and 9999 written somewhere new.
- **The shell holds exactly one day view and no date.** `ContentView` has
  `private let dayView = DayView(of: dayOneCommitments, on: today(), in: History())` and a `List`
  over `dayView.rows`. It keeps no `CalendarDate` and no `Foundation.Date` of its own, so today it
  could not even name the date it is showing, let alone the next one.

## Goals / Non-Goals

**Goals:**

- One way to get from a day view to its neighbour, taking nothing the caller does not already hold.
- The bound expressed as a value the caller can act on, not a crash, a wrap or a silent clamp.
- The clock still outside the package. Moving takes no "today" at all, so every acceptance test
  gives the same answer in every time zone and for ever.
- Purely additive. #70's and #71's five requirements were signed on 2026-09-02 and 2026-09-03 and
  none of them moves; the delta is three ADDED requirements and no MODIFIED one.
- Nothing new made public that the delta does not observe.

**Non-Goals:**

- **Drawing the date.** A screen that can move between days should say which day it is on, and it
  still cannot: rendering "Tuesday 1 September" needs `CalendarDate`'s year, month and day, which
  are internal, and widening them is a delta against `openspec/specs/schedule/spec.md`, which owns
  what a calendar date is. That is a second capability and so a second Story (rule 5). See
  § *Risks*; it is the one thing this Story knowingly leaves the shell unable to do.
- **A gesture.** Whether a day changes by a swipe, two arrows or a date picker is the app shell's,
  and nothing here constrains it.
- **Jumping.** Moving to a named date, back to today, or forward by a week are not this Story's.
  Each is a want for `docs/backlog.md` if it is wanted at all, and none is needed to reach a day
  that was missed.
- **Reading the device's day.** Moving is never asked what day it is. The one place a device day
  enters the package is `Row.tick(asOf:)`, unchanged by this Story, and the conversion that produces
  it is `ContentView.today()`, where ADR-1004 puts it.
- **Holding a day view in something that changes.** What the shell stores its current day view in —
  `@State`, an observable object — is the shell's, and it is a choice about SwiftUI rather than
  about a requirement.
- **Widening `CalendarDate`, `Commitment`, `Schedule`, `Tick`, `History` or `RecordStore`.** The
  known gap in `docs/open-questions.md` about a schedule's payload not reading back is untouched and
  is not made any smaller.

## Decisions

### The seam

**Existing: `DayView`, widened by exactly two public methods.** No new seam, no new type, nothing
moved and nothing else exported.

```swift
public struct DayView: Hashable, Sendable {
    public struct Row: Hashable, Sendable { /* unchanged by this Story */ }

    public let rows: [Row]

    public init(of commitments: [Commitment], on date: CalendarDate, in history: History)

    /// The day view of the calendar date one day before this one's, or `nil` when this day view
    /// is of 1 January 1583.
    public func previousDay(of commitments: [Commitment], in history: History) -> DayView?

    /// The day view of the calendar date one day after this one's, or `nil` when this day view
    /// is of 31 December 9999.
    public func nextDay(of commitments: [Commitment], in history: History) -> DayView?
}
```

Internally `CalendarDate` gains a way to step one day, kept **internal** so that no `schedule`
requirement is touched: the natural form is `func adding(days: Int) -> CalendarDate?`, built on the
same private `Calendar` the type already uses and returning `nil` through the existing
`init?(year:month:day:)` guard. Fifteen scenarios in the delta observe the two new methods and day
view equality. No process is spawned and no global stream is captured. `AGENTS.md` prefers an
existing seam over a new one, and this is the same seam #71 widened.

The shell's whole use of it is one line per direction, and there is no third:

```swift
dayView = dayView.nextDay(of: commitments, in: store.history) ?? dayView
```

### The move gives a day view, not a date

**Chosen: `previousDay`/`nextDay` return `DayView?`.**

*Alternative — expose the date instead: `public var date: CalendarDate` plus
`func previousDate() -> CalendarDate?`, and let the caller call `DayView(of:on:in:)` itself.* This
is the tempting one, because moving really is a question about a date, and it would let a screen ask
"is there a day before this?" without forming a whole day view to find out. Rejected on two counts.
It is two calls and a temporary where one call does, and the temporary is a `CalendarDate` the
caller can do nothing with but hand straight back — it cannot read it, print it or compare it
(§ *Context*), so the only correct use of the value is the one the method would have made itself.
And it puts the sequence *step the date, then form the day view on it* in the caller, which is a
rule that can be wrong — the caller could form on the old date, or step twice — and so is exactly
what `CONTEXT.md` § *App shell* says must not live in the shell. The cost of the choice is that
finding out whether a day exists means forming a day view of it; that is a filter and a map over a
handful of commitments, and no screen needs the answer before the tap anyway.

*Alternative — `func moved(by days: Int, of:in:) -> DayView?`.* Rejected as generality nobody asked
for. It would immediately owe an answer for a step that crosses the bound — clamp to 31 December
9999, or refuse the whole move? — which nothing decides, and it would let a screen invent "jump a
week" without a Story. Two named methods have one obvious meaning each.

*Alternative — a mutating `mutating func moveToNextDay(...)`.* Rejected: a day view is a value that
is compared and handed on, and #70's fifth requirement leans on that. A mutating move would also
have nothing to say when there is no next day.

### The commitments and the history are handed in again

**Chosen: both are parameters of the move.** This is forced rather than preferred: a day view holds
neither (§ *Context*), so there is nothing to reuse. The delta says so out loud — a move *may* be
handed different commitments and a different history and gives the day view of those — because the
alternative reading, that a move quietly re-forms from what the first day view saw, is the one a
reader will assume and it is the one that would require a day view to hold a list of its own.

It also happens to be what the shell wants. The commitments will change as they are added and
edited, and the history is `store.history`, a `public private(set)` property read fresh at every
use; a move that had captured either at formation time would hand back a stale answer, which is the
same staleness trap § *Where the day enters* rejected in #71.

*Alternative — a day view keeps its commitments and history so a move needs no arguments.* Rejected:
it would MODIFY #70's requirement *"A day view is a value"*, restating and re-approving twelve
scenarios to make a day view into a window onto a history — precisely the thing that requirement
was written to prevent.

### The bound is `nil`, not a clamp

**Chosen: give nothing at 1 January 1583 moving back and at 31 December 9999 moving forward.**

`nil` carries strictly more than a clamp does. A caller that wants clamping writes `?? self` and has
it; a caller given the same day view back cannot tell "there is no next day" from "the next day
happens to look identical", and after this delta it could not even be sure of that much, since a day
view's date is part of its identity and two day views on two dates are never equal. So the clamp is
recoverable from `nil` and `nil` is not recoverable from the clamp. That is a fact about information
rather than a preference, which is why it was settled here.

Trapping was never a candidate: reaching the end of the calendar is a thing a caller can be told
about, not a programming error.

**Which dates the bound falls on is not this capability's to choose.** 1583 and 9999 are
`openspec/specs/schedule/spec.md`'s, settled by ADR-1004 and by `CalendarDate.init?`'s own guard.
This delta names them in prose because a requirement that said "the first supported date" without
saying which would not be readable, but nothing here re-decides them and no new copy of those two
numbers is written: the refusal comes back through the existing initialiser.

### Moving never asks what day it is

**Chosen: no `asOf:` parameter, and no bound at today.**

Every other question in the package is asked of a date rather than of the present moment, and this
one is too. A person navigating forward past today is looking at what is coming, which is worth
seeing; the one thing that must not happen there — recording a day as kept before it has arrived —
is already refused by `Row.tick(asOf:)`, signed on 2026-09-03, and a scenario in this delta pins
that the two compose. A bound at today would need a clock argument on a navigation method and would
buy nothing that #71 does not already guarantee.

This also matches the Story's own intent, accepted at #27's G2 on 2026-09-02: *"stopping at the
first and last supported dates."* Were the owner to want forward movement to stop at today instead,
the third requirement's first paragraph and its four scenarios would be rewritten and both new
methods would take a day — see § *Open Questions*, where it is recorded as settled rather than
assumed.

### A move never skips a day with nothing due

**Chosen: one calendar day, whatever is on it.** A second requirement says so and two of its
scenarios pin it.

Skipping is a real temptation — a week where nothing is due is several taps of nothing — but it
contradicts something already settled: #70's first requirement says a day view with no rows is *an
answer rather than a refusal*, and `CONTEXT.md` § *Day view* repeats it. A move that skipped would
also have to consult the commitments to decide where it lands, which makes "where am I now" depend
on which list was handed over, and would jump across a month when a person edits a schedule. If
skipping is ever wanted it is a want in `docs/backlog.md` and a different method.

### No ADR

Nothing here clears all three of `docs/adr/README.md`'s bars. The decision that would have earned
one — that the engine never reads a clock — is ADR-1004's, and this delta applies it. The seam shape
is two methods to reverse and is argued above where a reader will look; the bound follows from
`CalendarDate.init?`; and the refusal being `nil` is settled by what a caller can recover from what.

## Risks / Trade-offs

- **A screen can now move between days and still cannot say which day it is on.** → Real, known, and
  deliberately not fixed here. `CalendarDate`'s `year`, `month` and `day` are internal, so nothing
  outside the module can render a date, and widening them is a delta against
  `openspec/specs/schedule/spec.md` — a second capability, which rule 5 says is a second Story
  rather than a wider scope for this one. It is the fourth face of the known gap
  `docs/open-questions.md` records as *"a schedule's payload cannot be read back out"*, and the
  handback for this Story names it so the conductor can cut the follow-up. Nothing in this delta
  becomes wrong when that Story lands; the shell simply cannot draw a usable navigation until it
  does.
- **Two public methods that differ by one word are easy to transpose.** → A `nextDay` wired to a
  back-arrow is a bug no type can catch. Mitigated by the delta rather than by the seam: separate
  scenarios assert each direction against a directly-formed day view on a *named* date, so a
  transposition fails a test rather than shipping.
- **The move re-forms the whole day view every time.** → Accepted. It is a filter and a map over the
  commitments a person actually has, and the alternative — caching neighbouring day views — would
  put staleness back into a value whose whole point is that it has none.
- **The internal `adding(days:)` is date arithmetic written a second time in `CalendarDate`.** →
  Small and contained: it uses the same private UTC `Calendar` as `weekday`, `daysInMonth` and
  `days(until:)`, and it returns through `init?`, so the year bound is not restated. It stays
  internal, so it adds no requirement to `schedule` and no public surface to review.
- **Nothing proves a swipe is wired to `nextDay(of:in:)`.** → `docs/open-questions.md` § *No UI
  smoke layer*, unchanged and still open. Mitigated the same way #71 mitigated it: the judgement
  lives in the seam, and the view is left one line with nothing in it to get wrong but which method
  it names.
- **A caller could move a day view formed from one set of commitments while handing a different
  set.** → Not a risk but the specified behaviour, pinned by a scenario. A day view is what it
  holds; the caller owns the list.

## Open Questions

**None.** Every question the grill raised was either a fact read out of the shipped sources or
measured on this machine, or a decision made above with its alternatives:

- *Can the app shell work out the next date itself, without a seam here?* — read: `CalendarDate` is
  not `Comparable`, its `year`, `month` and `day` are internal, and nothing in it steps a day. The
  shell could only do it by keeping a parallel `Foundation.Date`, which is a rule that can be wrong
  in a way a test would catch and so is what `CONTEXT.md` § *App shell* excludes. The seam belongs
  in the kit.
- *Can a day view move without being handed its commitments and history again?* — read: it holds
  neither, by #70's requirement and by the source. It cannot, and the delta says so rather than
  leaving a reader to assume otherwise.
- *Where does the bound at 1583 and 9999 come from, and does this Story restate it?* — read and
  measured: `CalendarDate.init?` guards `(1583...9999).contains(year)`, and Foundation's own
  arithmetic hands it 10000-01-01 and 1582-12-31 at the two ends, both refused. The bound is
  `schedule`'s, already tested, and is consumed rather than copied.
- *Should reaching the end give nothing or the same day view back?* — settled on information rather
  than taste: a clamp is recoverable from `nil` and `nil` is not recoverable from a clamp.
  § *The bound is `nil`, not a clamp*.
- *Should moving forward stop at today rather than at the last supported date?* — the one question
  in this grill that is a preference rather than a fact, and it was answered before the grill began:
  the Story's intent sentence, accepted at #27's G2 on 2026-09-02, says *"stopping at the first and
  last supported dates"*, and the product reason agrees — seeing what is coming is worth having, and
  the only harm, recording a day as kept before it arrives, is already refused by `Row.tick(asOf:)`.
  It is therefore not re-asked. What would change if the owner reversed it is written down in
  § *Moving never asks what day it is* so that the cost is visible rather than buried.
- *Should moving skip a day on which nothing is due?* — no, and settled against something already
  signed: #70 says a day with no rows is an answer. § *A move never skips a day with nothing due*.
- *Does moving need `DayView.date` to become public?* — no. Nothing in the delta observes it, day
  view equality already distinguishes two dates, and the smallest surface is the one that leaves the
  next Story free. The consequence — the shell still cannot draw the date — is in § *Risks* as an
  owed Story rather than left silent.
- *Does anything already signed have to change?* — no. Checked requirement by requirement against
  `openspec/specs/day-screen/spec.md`: none of the five constrains what a day view may be asked for,
  and adding a method changes neither day view equality nor row equality. The delta is ADDED
  throughout.
- *Does this force the week-turnover product question?* — no. Nothing here reads a week; moving
  steps a calendar day, and where a week begins is still undecided (`CONTEXT.md` § *Weekly quota*).
