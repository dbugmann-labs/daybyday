## Context

`add-weekday-set-schedule` (#8) built the package, the seam and the date model; `add-day-of-month-schedule`
(#9) added the second case and made good on #8's claim that the seam would not move for #9, #10 or
#11. This is the third of those, and the first with a shape that is genuinely different: a weekday
set and a day of the month are functions of the calendar alone, and an interval is not. It carries a
date of its own, and it is the first thing in the engine that has to be *told* something before it
can answer.

ADR-1004 fixed what the seam takes — a `CalendarDate`: year, month, day, no clock and no time zone —
and fixed the supported year range at 1583 through 9999, which this shape inherits without
restating. Motivation is in `proposal.md`; the behaviour contract is in `specs/schedule/spec.md` and
is not restated here.

**Measured on this machine on 2026-08-31, on Apple Swift 6.3.3, rather than recalled** — the whole
shape rests on a day count, and #9's precedent is to measure the Foundation call rather than trust
it. Asking `Calendar.dateComponents([.day], from:to:)` on the same hybrid-Gregorian calendar in UTC
that `CalendarDate` already configures returned:

| from | to | days |
|---|---|---|
| 31 Aug 2026 | 3 Sep 2026 | 3 |
| 28 Feb 2028 | 1 Mar 2028 | 2 — the leap day counted |
| 28 Feb 2027 | 1 Mar 2027 | 1 |
| 31 Dec 2026 | 1 Jan 2027 | 1 |
| 1 Jan 1583 | 31 Dec 9999 | 3,074,245 |
| 3 Sep 2026 | 31 Aug 2026 | −3 — the count is signed |

Three things follow, and they are facts rather than choices. The **whole supported range is 3,074,245
days**, so every day count this engine can ever produce fits in a machine word with twenty-one bits
to spare, and a remainder taken against any interval — up to and including `Int.max` — cannot
overflow. The count is **signed**, so "earlier than the start date" is readable from the count itself
and needs no separate comparison. And the count is **inclusive of the leap day**, so no month-length
arithmetic is needed anywhere in this shape. The implementer may compute the count from a day number
instead; the point of measuring was to know the requirement is satisfiable without leaving the
calendar the rest of the type already uses.

One more thing was compiled rather than assumed: an enum case with a labelled second associated
value, `case everyNDays(DayInterval, from: CalendarDate)`, and its pattern binding
`case .everyNDays(let interval, from: let start)`, both build under Swift 6.3.3 in language mode 6.

## Goals / Non-Goals

**Goals:**

- The second rule shape, on the seam that already exists, with no change to it.
- An anchor decided once, in the open, with the alternative the parking lot has been holding since
  2026-08-28 written down beside it rather than quietly dropped.
- An interval that cannot be zero, negative, or arithmetically dangerous at its extreme.

**Non-Goals:**

- Moving, widening or wrapping `Schedule.isDue(on:)`. If this Story needs the seam to change, #8's
  claim was wrong and that is a finding, not a refactor.
- Giving the weekday-set or day-of-month shapes a start date. This change deliberately does not
  generalise the start date into the other two: nothing asks for it, and doing it here would make
  three requirements out of one.
- An end date, a pause, a skipped occurrence, or a rule that resumes on a different phase after a
  gap. Nothing asks for any of them.
- Reading a tick. Nothing in this capability may, and Question 1 below is exactly about the boundary
  that keeps it that way.

## Decisions

### The seam

**Unchanged: `Schedule.isDue(on:) -> Bool`**, the public instance method on `Schedule` exported from
`DayByDayKit`. Every acceptance test in this change attaches there, exactly as #8's and #9's do. The
enum gains one case:

```swift
public enum Schedule: Hashable, Sendable {
    case weekdays(Set<Weekday>)
    case dayOfMonth(DayOfMonth)
    case everyNDays(DayInterval, from: CalendarDate)

    public func isDue(on date: CalendarDate) -> Bool
}
```

The new case's payload is a new public type, and — as with `CalendarDate` in #8 and `DayOfMonth` in
#9 — its failable initializer is part of the same seam rather than a second one, because there is no
way to build an `.everyNDays` schedule without going through it:

```swift
public struct DayInterval: Hashable, Sendable {
    public init?(days: Int)
}
```

The three validity scenarios in the delta observe that initializer; the other eleven construct a
`Schedule` and a `CalendarDate` and assert on the `Bool` that comes back. No process is spawned, no
global stream is captured, and the day count itself stays internal — no test can read it directly, so
it is observed only through the predicate, which is how the product will consume it.

Two smaller choices inside that shape. The start date is a **second associated value with the label
`from:`**, not a field of a struct wrapping both: the start date is already a first-class type, a
wrapper would be a type with no rule of its own, and `.everyNDays(DayInterval(days: 3)!, from: date)`
reads at the call site as the sentence the product uses. And the payload is `DayInterval` rather than
a bare `Int` for the reason `DayOfMonth` is not one: an interval of 0 is either a division by zero or
a confident "due every day" depending on how a remainder is read, and a negative interval is a rule
running backwards. Refusing at construction costs one guard and three scenarios.

`DayInterval.days` stays internal, matching `DayOfMonth.day`. That is a known asymmetry with
`.weekdays(Set<Weekday>)`, which reads back fine — `docs/parking-lot.md` recorded it at #9's review
on 2026-08-31. Nothing renders a rule yet, so widening it here would be surface added on
speculation; the first Story that draws a schedule on screen widens both shapes in one delta.

### The anchor is a fixed start date carried by the schedule

This is the decision the Story turns on and the one the parking lot has been holding open, so both
readings are written out. It is also **Question 1** below, because it is a product preference rather
than a fact.

**Chosen: a fixed start date.** "Every 14 days from 25 August" is a rule about the calendar, and it
answers for any date without knowing anything else.

*Alternative — count from the last tick.* "Every 3 days *since you last did it*", so a late tick
shifts every date after it. This is a real reading, and for watering plants it is arguably the more
truthful one: the plant does not care what the schedule said, it cares when it was last watered.
It is not chosen, and — this matters more than preference — **it does not fit here**. Due-ness would
stop being a function of a date and become a function of a date plus the entire tick history, which
is not what ADR-1004 put at the seam and not what the other three shapes take. It would also make a
past day's answer change after the fact: tick today, and yesterday's page reads differently than it
did yesterday, which contradicts `CONTEXT.md`'s "whether a commitment is due is a question asked *of
a date*, not of the present moment", and undermines the writable past the whole product is built on.
If the owner wants it, it is a fifth rule shape arriving after ticks exist — a Story of its own with
a seam question of its own — and not a different setting of this one. Question 1 says so plainly.

*Alternative — a fixed epoch, so the interval is pure parity.* "Due when the day number is divisible
by N", with no anchor at all. Rejected twice over: ADR-1004 already rejected day numbers on the
public surface as unreadable, and the shape cannot express "starting today", which is how every one
of these commitments is actually created.

### The rule does not reach back before its start date

**Chosen: not due before the start date.** The reasoning is in the delta's requirement prose and is
not repeated. It is **Question 2** below for the same reason as Question 1: it is a preference about
what the product should show, not a fact.

*Alternative — symmetric parity around the start date*, so the start date is only a phase reference
and the rule is due every N days in both directions. It is arguably simpler to explain ("every third
day, forever, and here is which third day"), and it removes a boundary that no other rule shape has.
Rejected because it manufactures history: a commitment created today would show as due — and, being
unticked, as missed — on days before its owner had decided anything, and `docs/parking-lot.md` has
*"unticked items stay visible into the evening rather than being silently missed"* as the behaviour
that makes an unticked due day read as a miss. A product whose point is an honest record cannot open
with a fabricated one.

It is worth being honest that the chosen answer also makes the arithmetic simpler — a negative day
count is a `false` and no floor-remainder question arises. That is a consequence and not the reason;
if the reason had been the arithmetic, the mitigation would have been to write the floor-remainder
correctly.

### The start date is an ordinary calendar date, and gains nothing new

It is a `CalendarDate`, so it already cannot be 30 February and already cannot fall outside 1583
through 9999. That is why the delta adds **no** validity requirement for it — a schedule whose start
date could not be formed cannot be built, which is the same refusal the rest of the engine makes.
The delta says so in as many words rather than leaving a reader to wonder whether an omission was an
oversight.

### The day count lives below the seam

`CalendarDate` may grow an internal way to count days to another date, alongside the internal
`weekday` and `daysInMonth` that #8 and #9 added, or the implementer may compute it arithmetically.
Either satisfies the requirement, which is about the answer. What it must not become is public API:
ADR-1004 warned that a date type growing convenience arithmetic is the signal that something
belonging at the edge has leaked into the engine, and one internal helper used by one rule shape is
not that, while an exported one would be the start of it.

## Risks / Trade-offs

- **The anchor is a product decision an agent is proposing, and the parking lot says it was never
  settled.** → It is not buried in this section: it is Question 1 in a round the conductor relays
  before G4, with the delta already written on the recommended answer so the cost of the other answer
  is visible. If the answer is "from the last tick", this Story stops rather than being rewritten —
  see the round.
- **The backwards question could be answered either way without anyone noticing for months.** →
  Question 2, for the same reason. If it goes the other way the cost is one requirement and two
  scenarios, and the first requirement's prose loses one clause.
- **Foundation again, and #8's review found it quiet about things it should have been loud about.**
  → Measured above at both ends of the supported range and across a leap day and a year boundary,
  and the seam's input contract guarantees both dates already exist. The implementer may compute the
  count without Foundation; the requirement is about the answer, not the mechanism.
- **Fourteen scenarios for what is, underneath, a subtraction and a remainder.** → Four are the
  plain rhythm, four are the boundaries where a naive implementation breaks (a month end, a leap day,
  a year turn, an interval so large it invites overflow), two are the backwards rule, three are the
  validity of the number, and one — the fortnight sweep — is the regression pin that catches a rule
  that is right about single dates and wrong about the sequence.
- **`DayInterval` carries the same read-back asymmetry `DayOfMonth` does**, so the parking-lot entry
  of 2026-08-31 now describes two shapes rather than one. → Left as is, deliberately, and recorded
  here so the eventual widening delta covers both.
- **#11 may still not fit this seam.** Unchanged from #8 and #9, but this Story sharpens it: a weekly
  quota needs tick history, and so would a last-tick interval. If Question 1 comes back as "last
  tick", the two arrive together and the seam question is one question rather than two.

## Migration Plan

None. Nothing is stored yet, no `Schedule` value exists outside a test, and the delta adds
requirements without touching one. `Schedule` gaining a case is source-breaking only for an
exhaustive `switch` outside the module, and there is none.

## Questions for you

1. **The anchor: a fixed start date, or the last tick?** `docs/parking-lot.md` has held this open
   since 2026-08-28, and the shape cannot be specified without answering it. A fixed start date makes
   "every 14 days" a calendar rule that answers for any date on its own; counting from the last tick
   makes it a rule about what you did, so a late tick moves every date after it.
   - *Recommended:* **a fixed start date.** Beyond preference, it is the only one of the two that
     fits what ADR-1004 put at the seam, and the only one that keeps a past day's answer from
     changing after you have already looked at that day.
   - *If you say last tick:* **this Story stops** rather than being rewritten. Due-ness would need
     the tick history, which nothing has built, and the seam would take more than a date — which is
     #8's claim failing and an ADR-1004 question, not a delta edit. The honest sequence is: ticks
     first, then this shape re-cut against them. Say so and the change folder is withdrawn.
   - *If you want both:* also a different answer from this one. The fixed-start rule shipped here
     stands unchanged and a last-tick shape is added later as its own rule shape, after ticks exist.
     Nothing in this delta blocks that.

2. **Before the start date: silent, or due?** A schedule of every 3 days starting 3 September — is it
   due on 31 August, which is exactly one interval earlier?
   - *Recommended:* **not due.** The start date is where the commitment begins. Reaching backwards
     would mark days due before you had committed to anything, and an unticked due day reads as a
     miss, so the product would open by showing you a history of failures you never had.
   - *If you say due:* the second requirement and its two scenarios are deleted, the first
     requirement's prose drops "or falls a whole number of intervals after it" in favour of a
     symmetric statement, and one scenario is added asserting the symmetric case. Nothing else in the
     delta moves, and no other rule shape is affected.

## Open Questions

None left open by the grill. The two above are not open questions — they are questions an agent may
not close at all, and they are recorded in the section that exists to say so. Everything else the
grill turned up is closed, here or in the delta: the anchor's shape, the backwards boundary, whether
the seam moves (it does not), whether the start date needs validity rules of its own (it does not),
and whether an interval has an upper bound (it does not, and the measurement above shows why one is
not needed for safety).

Three questions this shape deliberately does not answer, with the reason:

- *Is "every day" a set of seven weekdays, or an interval of one?* Both, and that is fine. The
  parking lot has carried this since 2026-08-28 as though it needed resolving; it does not. Two rules
  having the same extension is not a contradiction, no requirement here forbids it, and choosing one
  would mean forbidding a value of the other for no behavioural gain. It becomes a real question only
  when a screen has to *name* a rule back to the user, which is where it should be answered.
- *Where does a week begin?* Still #11's, untouched here. An interval cannot need it.
- *How far back does the past stay writable, and what happens to days before a thing existed?* The
  parking lot's phrasing of the second half is answered for this one shape by the second requirement
  — before its start date, an interval is simply not due. The general question, which is about ticks
  and storage rather than rules, is not this Story's and is not answered by it.
