## Context

`add-weekday-set-schedule` (#8) built the package, the seam and the date model, and its `design.md`
said in as many words that `Schedule` ships as a one-case enum so that #9, #10 and #11 each add a
case without moving the seam. This is the first of those three, and it is the first test of that
claim. ADR 1004 fixed what the seam takes — a `CalendarDate`, year, month and day, no clock and no
time zone — and said #9 inherits the supported year range. So the plumbing questions are all
answered, and one product question is not: what a schedule on a day that a given month does not
have should do.

Motivation is in `proposal.md`; the behaviour contract is in `specs/schedule/spec.md` and is not
restated here.

One fact was measured on this machine on 2026-08-30 rather than recalled, because the whole
short-month requirement rests on it: **`Calendar.range(of: .day, in: .month, for:)` reports the true
length of the month a date is in**, on the same hybrid Gregorian calendar in UTC that
`CalendarDate` already configures. It returned 28 for February 2027, 29 for February 2028, 30 for
September 2026, 31 for August 2026, and — at both ends of the supported range — 28 for February 1583
and 31 for December 9999. It also gets the century rule right: 28 for February 1900, 29 for February
2000. The implementer may derive the length arithmetically instead; the point of measuring was to
know the requirement is satisfiable without leaving the calendar the rest of the type already uses.

## Goals / Non-Goals

**Goals:**

- The third rule shape, on the seam that already exists, with no change to it.
- A day-of-month value that cannot be out of range, so that "never due because the number was 32" is
  not a state the product can reach.
- One decision, taken explicitly and reviewable in isolation: what a short month does.

**Non-Goals:**

- Moving, widening or wrapping `Schedule.isDue(on:)`. If this Story needs the seam to change, the
  claim #8 made was wrong and that is a finding, not a refactor.
- A rule that runs every other month, or in named months, or between two dates. Nothing asks for it.
- Counting backwards from the end of a month ("the last day", "the second-to-last"). The decision
  below makes the common half of that expressible without new API; the rest has no requirement.
- Any opinion on what the editing screen offers. Whether a picker shows 1–31 or 1–28 plus "the last
  day" is a UI question, and the engine answers either.

## Decisions

### The seam

**Unchanged: `Schedule.isDue(on:) -> Bool`**, the public instance method on `Schedule` exported from
`DayByDayKit`. Every acceptance test in this change attaches there, exactly as #8's do. The enum
gains one case:

```swift
public enum Schedule: Hashable, Sendable {
    case weekdays(Set<Weekday>)
    case dayOfMonth(DayOfMonth)

    public func isDue(on date: CalendarDate) -> Bool
}
```

The new case's payload is a new public type, and — as with `CalendarDate` in #8 — its failable
initializer is part of the same seam rather than a second one, because there is no way to build a
`.dayOfMonth` schedule without going through it:

```swift
public struct DayOfMonth: Hashable, Sendable {
    public init?(day: Int)
}
```

The three validity scenarios in the delta observe that initializer; the other nine construct a
`Schedule` and a `CalendarDate` and assert on the `Bool` that comes back. No process is spawned, no
global stream is captured, and nothing internal is exposed: `CalendarDate`'s day and month stay
internal, so no test can read the clamp's arithmetic directly — it is observed only through the
predicate, which is how the product will consume it.

`init?(day: Int)` carries the `day:` label to match `CalendarDate(year:month:day:)`, and the type is
a struct rather than a 31-case enum because the number is a number: the UI will hand it an `Int`
from a picker and wants a nil back for a bad one, not a lookup table.

### A month too short for the scheduled day is due on its last day

This is the decision the Story turns on, and the alternative is real, so both are written down.

**Chosen: clamp.** A schedule on the 31st is due on 30 September, on 28 February in a common year
and on 29 February in a leap one. Every month therefore has exactly one due date, which is what
"monthly" means to the person who set it.

*Alternative — skip.* Due only when the date's day equals the number exactly, so a schedule on the
31st is due in seven months of the year and never in the other five. It is one comparison, it needs
no month length, and it is defensible as the literal reading of the rule. Rejected on the product's
own terms: `CONTEXT.md` says a commitment is *"defined once and recurs indefinitely"*, and
`docs/parking-lot.md` records that unticked items stay visible rather than being silently missed.
A rule that vanishes for five months of the year is neither. The owner would not discover it at the
picker; he would discover it in March, having not done the thing in February.

*Alternative — refuse the problem: allow only 1 through 28.* Cheapest of the three and genuinely
tempting, since the day-one list only needs the 25th. Rejected because it makes the engine refuse
"rent on the 30th" and "salary on the last day", which are ordinary monthly commitments, and it
pushes an arbitrary-looking limit into a picker the user reads as a calendar.

*Alternative — clamp, but make it an option on the case*
(`case dayOfMonth(DayOfMonth, whenShort: ShortMonthBehaviour)`). Rejected as inventing a
requirement: nobody has asked for skipping, and a parameter with one used value is a parameter
that gets copied into #10 and #11 by symmetry. If skipping is ever wanted, adding it then is a
delta, which is the cheap direction.

**What the choice costs, stated rather than buried:** in a common February, schedules on the 28th,
29th, 30th and 31st all fire on 28 February, so four distinct rules become indistinguishable for one
month. The delta says so in the requirement prose. It is the correct behaviour for all four and not
a collision needing a tie-break, because nothing in this capability asks two schedules about each
other.

### An out-of-range day of the month is unrepresentable, not never-due

`case dayOfMonth(Int)` would let 32 through, and 32 under the clamp rule is due on the last day of
every month — a wrong answer delivered confidently — while under a bare comparison it would be a
schedule that is never due and never explains why. `DayOfMonth` refuses instead, which is the stance
`CalendarDate` already takes on 30 February and the one ADR 1004 records as part of what this engine
is. It costs one guard and three scenarios.

No `Int.max` scenario is written here, unlike #8's three. That trio exists because
`DateComponents` reads `Int.max` back as its own "unspecified" sentinel, and a `DayOfMonth` never
becomes a `DateComponent` — it is compared against a month length as a plain integer, and `Int.max`
is refused by the same `1...31` check that refuses 32. Copying the scenario across would be
cargo-culting a Foundation quirk into a place it cannot occur.

### `DayOfMonth` is not a `CalendarDate` component and does not become one

The clamp compares the scheduled day against the length of the month the *date* is in. It must not
be implemented by constructing a second `CalendarDate` from the schedule's day and the date's
year and month — that construction fails for exactly the cases the clamp exists to handle (31
February is not a calendar date), and a failed construction is not a "not due". The delta's short-
month scenarios are what hold that line.

## Risks / Trade-offs

- **The clamp is a product decision an agent is proposing, not a fact.** → It is called out in
  `proposal.md` as the thing G4 approves, with the rejected alternative named, so a "no" at the gate
  costs one requirement and five scenarios rather than a rewrite. Nothing else in the change depends
  on which way it goes.
- **`Calendar.range(of:in:for:)` is Foundation, and #8's review found Foundation quiet about two
  things it should have been loud about.** → Measured above at both ends of the supported year range
  and across the century leap rule rather than assumed, and the seam's input contract guarantees the
  date handed in already exists. The implementer may still compute the length arithmetically; the
  requirement is about the answer, not the mechanism.
- **Twelve scenarios for one rule shape**, where the rule itself is one comparison. → Only four of
  the twelve are the happy path. Five are the short-month rule and its boundaries, which is where
  every bug in this shape will live: a fixed 28, a clamp that misfires in a 31-day month, a roll
  into 1 March. The remaining three are the validity of the day number itself.
- **#11 may still not fit this seam** — unchanged from #8, and this Story does not make it better or
  worse. A weekly quota needs tick history; this shape does not.

## Migration Plan

None. Nothing is stored yet, no `Schedule` value exists outside a test, and the delta adds
requirements without touching one. `Schedule` gaining a case is source-breaking only for an
exhaustive `switch` outside the module, and there is none.

## Open Questions

None. Three that could have been left open are closed above: what a short month does, what an
out-of-range number does, and whether the seam moves (it does not). Two questions this shape
deliberately does not answer, with the reason:

- *Should "the last day of the month" be its own rule shape?* Not now. Under the clamp it is the
  31st, which is one of the four shapes rather than a fifth. If it ever needs to be distinguishable
  in the UI — a label rather than a number — that is a display concern first, and a delta if it
  turns out not to be.
- *Where does a week begin?* Still #11's, untouched here. A day-of-month rule cannot need it.
