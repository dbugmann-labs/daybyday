## Context

`add-weekday-set-schedule` (#8) built the package, the seam and the date model. `add-day-of-month-schedule`
(#9) and `add-every-n-days-schedule` (#10) added the second and third cases and made good on #8's
claim that the seam would not move. This is the fourth and last of the four rule shapes `CONTEXT.md`
names, and the one every design document since #8 has flagged as possibly not fitting. Motivation is
in `proposal.md`; the behaviour contract is in `specs/schedule/spec.md` and is not restated here.

The constraint that shapes everything below is ADR-1004: the seam is
`Schedule.isDue(on: CalendarDate) -> Bool`, a pure function of a year, a month and a day, with no
clock, no time zone, no locale and no access to anything the caller has recorded. Three shapes fit
that comfortably because they are functions of the calendar alone. This one is not: "three times a
week, any nights, open until the week turns over" has a part that is about the calendar — *any
nights* — and a part that is about what has been done — *open until*. The first part is what this
change specifies. The second is unanswerable at this seam, and that is a fact rather than a
preference, so it is argued out below rather than put to the owner.

Two things were checked rather than recalled, on this machine on 2026-09-01:

- **The proposed public surface compiles under Apple Swift 6.3.3 in language mode 6** — a
  `public struct WeeklyQuota: Hashable, Sendable` with a failable `init?(times:)` guarded on
  `(1...7)`, a fourth `Schedule` case carrying it, and a `switch` arm binding nothing
  (`case .timesPerWeek:`) returning `true`. Built in a scratch package, not in `src/`; nothing in
  this change writes code.
- **Every calendar fact the delta cites is already asserted by the current
  `openspec/specs/schedule/spec.md`**, and none is new. 31 August 2026 is a Monday and 6 September
  2026 a Sunday (weekday-set scenarios), 1 September 2026 a Tuesday (weekday-set scenarios),
  29 February 2028 exists and is a Tuesday (Gregorian-weekday scenarios), and 1 January 1583 and
  31 December 9999 are the first and last dates the system forms (supported-year scenarios). This
  shape needs no calendar fact of its own, which is itself the point.

## Goals / Non-Goals

**Goals:**

- The fourth rule shape, on the seam that already exists, with no change to it — closing #8's claim
  for the last of the four Stories it covered.
- A boundary written down where a reader will look for it: the delta states normatively that quota
  satisfaction is not this capability's question, so the next Story does not have to rediscover it
  from an absence.
- A quota that cannot be zero, negative, or larger than the week can hold.

**Non-Goals:**

- Moving, widening, overloading or adding a default parameter to `Schedule.isDue(on:)`. A second
  signature taking the week's ticks is the rejected alternative below, not a fallback.
- Defining where a week begins. Nothing in this delta consumes a week boundary — a quota is due on
  every date, so no scenario can observe one — and deciding it here would be a requirement written
  on speculation. It stays in `docs/parking-lot.md`, where it has been since 2026-08-28.
- Carrying an unmet quota into the following week, or recording it as a miss. Both are questions
  about ticks and history, both are parked, and neither is answered here.
- Reading, storing or naming a tick. Nothing in this capability may.
- Making the quota count readable back out. `WeeklyQuota`'s count stays internal, matching
  `DayOfMonth.day` and `DayInterval.days`; see § *Risks* .

## Decisions

### The seam

**Unchanged: `Schedule.isDue(on:) -> Bool`**, the public instance method on `Schedule` exported from
`DayByDayKit`. Every acceptance test in this change attaches there, exactly as #8's, #9's and #10's
do. The enum gains its fourth and final case:

```swift
public enum Schedule: Hashable, Sendable {
    case weekdays(Set<Weekday>)
    case dayOfMonth(DayOfMonth)
    case everyNDays(DayInterval, from: CalendarDate)
    case timesPerWeek(WeeklyQuota)

    public func isDue(on date: CalendarDate) -> Bool
}
```

As with `CalendarDate` in #8, `DayOfMonth` in #9 and `DayInterval` in #10, the payload's failable
initializer is part of the same seam rather than a second one, because there is no way to build a
`.timesPerWeek` schedule without going through it:

```swift
public struct WeeklyQuota: Hashable, Sendable {
    public init?(times: Int)
}
```

The four validity scenarios in the delta observe that initializer; the other five construct a
`Schedule` and a `CalendarDate` and assert on the `Bool` that comes back. No process is spawned and
no global stream is captured.

`case timesPerWeek(WeeklyQuota)` rather than `case weeklyQuota(WeeklyQuota)`: the case name is what
the call site reads — `.timesPerWeek(WeeklyQuota(times: 3)!)` — and "times per week" is the rhythm,
while "weekly quota" is the type of the number. Naming both the same way would say the word twice
and the sentence not at all.

### The count does not reach the predicate, and the predicate does not consult ticks

This is the substance of the change and the one thing a reviewer should attack.

**Chosen: `isDue(on:)` answers `true` for every date on this shape, and the count is validated,
carried, and not consulted.** A quota's number is a property of the *week's obligation*, not of any
date in it. The seam asks a question about one date, so there is no honest way for the number to
change the answer: nothing about 2 September 2026 alone is different for a quota of three than for
a quota of one. The delta says this in as many words and pins it with a scenario, so that an
implementation which later starts consulting the count fails a test rather than passing quietly.

*Alternative — widen the seam to take the week's ticks*, as `isDue(on: CalendarDate, tickedOn:
Set<CalendarDate>) -> Bool`, or with a default argument so the other three shapes and their
forty-five existing tests keep compiling. This is the version that delivers the Story's intent
sentence whole, and it is genuinely tempting because it stays a pure function — no storage, no
clock, just a bigger argument. It is rejected on three grounds, in increasing order of weight.
First, it reverses part of ADR-1004, which fixed the argument list at one calendar date before any
shape was written precisely so that the fourth shape could not quietly widen it. Second, it would
define what a tick *is* inside `schedule`, when ticks belong to `commitment` (#26), which has no
Stories yet — a requirement landing in the wrong Feature is what `AGENTS.md` rule 5 says to stop
for. Third and decisively, **it makes a past date's answer change after the fact.** Tick Monday,
Tuesday and Wednesday of a three-a-week reading, then ask on Thursday whether Monday was due: a
satisfaction-aware rule answers no, about a day it answered yes about at the time, and every one of
those days is a day the screen can be scrolled back to. `CONTEXT.md` fixes due-ness as a question
asked of a date rather than of the present moment, and #10's round rejected a last-tick anchor for
exactly this defect. Taking it here would be taking it twice as loudly.

*Alternative — expose a second pure query beside the predicate*, something like
`timesDue(inWeekOf: CalendarDate) -> Int`, answering 3 for a quota, the number of matching weekdays
for a weekday set, 0 or 1 for a day of the month. This would make the count live without any tick,
and it is the shape the day screen will most likely want. It is rejected as premature rather than
wrong: it is a second seam, it forces a week boundary nothing has yet asked for, and it needs
MODIFIED requirements and scenarios for all three existing shapes to answer for them — a delta
several times this one, written for a screen that has not been decomposed into a single Story. When
`day-screen` (#27) reaches Stage 2 and something actually renders "2 of 3 this week", that Story can
add it, with the requirement in hand.

*Alternative — do not build this shape at all; tell the owner to schedule reading Mon/Wed/Fri.* Worth
stating because it is the cheapest thing that could work, and `AGENTS.md` asks for the challenge
before the build. It is rejected on the owner's own words in `docs/parking-lot.md` — *"any nights"* —
and on the market check of 2026-08-29 recorded in the same file: the weekly quota is precisely what
Apple Reminders lacks and what the habit-tracker category only offers wrapped in streaks. A weekday
set that picks the nights for him is the product he already abandoned.

### Seven is the ceiling, and it is a fact about ticks rather than a preference

`CONTEXT.md` defines a tick as recording that a due commitment was done, keyed to a day; nothing in
this system records a commitment twice on one day, and the Epic (#1) explicitly puts the things that
*do* accumulate within a day — weight, protein, mood — out of scope. Seven days therefore hold at
most seven completions, and a quota of eight would be an obligation that could never be met. That
makes the bound derivable rather than chosen, which is why it is settled here and not in the
question round: it is a fact about the model, and finding facts is this agent's job. If the model
ever grows a commitment tickable twice in a day, this bound is one requirement and one scenario to
revisit.

### The quota carries no start date and no first week

Like `.weekdays` and `.dayOfMonth`, and unlike `.everyNDays`, this shape is a function of the
calendar alone, so it needs no anchor and gets none. The delta says so explicitly rather than
leaving a reader to wonder whether the omission was an oversight — #10's practice, kept. A
consequence worth naming: the shape is due in both directions without bound, including on dates
before the commitment was created. That is the same behaviour the weekday-set and day-of-month
shapes already have, and #10's second requirement deliberately did not generalise its start-date
bound to them. This change does not generalise it either.

## Risks / Trade-offs

- **This change ships a payload the predicate ignores**, which is exactly the kind of thing a
  reviewer should flag, and it is not hidden: the delta states it normatively and a scenario pins
  it. → The count is not dead, it is early: it is the size of the week's obligation, and the first
  screen that draws progress subtracts completions from it. The alternative to shipping it early is
  not shipping it differently, it is not shipping it yet — which is the question the owner is being
  asked below.
- **The Story's intent sentence promises more than this delta delivers.** "*Still* asks for one" is
  the satisfaction half, and it is not here. → Raised as a question round rather than absorbed
  silently, and flagged in `proposal.md` § *Impact* as issue text the orchestrator should correct if
  the round lands on the recommendation.
- **A reading commitment appears on all seven days with no sense of progress** until ticks exist. It
  is the visible cost of the recommended answer and the reason the round exists at all. → Mitigated
  only by sequencing: the Story that adds ticks closes it, and nothing in this delta blocks that
  Story or has to be undone by it.
- **Nine scenarios for a branch that returns `true`.** → Five are the shape (a full week, the count
  not mattering, a day a weekday set would miss, a leap day, both ends of the supported range) and
  four are the validity of the number. Two of them are doing real work rather than decorating: *a
  quota of one and a quota of seven are due on the same seven dates* is the regression pin on the
  decision above, and *a weekly quota is due on the first and the last date the system forms*
  catches an implementation that grows a hidden bound.
- **`WeeklyQuota` carries the same read-back asymmetry `DayOfMonth` and `DayInterval` do**, so the
  parking-lot entry of 2026-08-31 now describes three shapes rather than two. → Left as is,
  deliberately, and recorded so the eventual widening delta covers all three. Widening it here for
  one shape would deepen the inconsistency rather than fix it.
- **`Schedule` is now exhaustive over the four shapes `CONTEXT.md` names**, so the next rule shape —
  a last-tick interval, a rule bounded to a stretch of weeks — is a fifth case and a new decision.
  → Nothing here forecloses one; the Epic already lists bounded rules as out of scope.

## Migration Plan

None. Nothing is stored yet, no `Schedule` value exists outside a test, and the delta adds
requirements without touching one. `Schedule` gaining a case is source-breaking only for an
exhaustive `switch` outside the module, and there is none.

## Questions for you

One question, and it decides whether this change lands now or waits. The delta above is written on
the recommended answer, so what follows describes what would change if you answer the other way.

1. **Half of this Story cannot be built yet. Land the half that can, or hold the Story until ticks
   exist?** A weekly quota is two behaviours: *any day of the week may be the day* (a question about
   a date, buildable now) and *stop asking once the week's three are done* (a question about ticks,
   which do not exist in this repository and belong to `commitment` (#26), a Feature with no Stories
   yet). The seam ADR-1004 fixed cannot express the second, and the design above argues at length
   why widening it to try would be a mistake rather than a shortcut.
   - *Recommended:* **land the half that can be built.** The four rule shapes are then complete and
     `schedule` is finished as a capability, the boundary is written down normatively where the next
     Story will find it, and nothing here has to be undone later — the satisfaction Story adds
     behaviour above this seam rather than changing anything below it. The cost is visible and real:
     until ticks land, a reading commitment shows on all seven days of the week with no sense of
     progress, and the app carries a number it does not yet use.
   - *If you say hold:* this PR closes unmerged and the change folder is deleted rather than
     archived. #11 goes back to blocked, behind a new Story under `commitment` (#26) that defines a
     tick, and is re-proposed afterwards as one delta covering both halves — which would also force
     the week-boundary question `docs/parking-lot.md` has been holding since 2026-08-28, because a
     quota that closes needs to know which days count toward it. `schedule` (#6) then stays open
     with three of four shapes for as long as that takes.

## Open Questions

None outstanding that are this agent's, and one round outstanding that is not — question 1 above,
which the conductor relays before G4. `AGENTS.md` requires this section filled in rather than empty,
so here is what the grill settled and on what grounds.

Settled here or in the delta:

- **Does the seam move?** No, for the fourth Story running. The temptation to widen it was real and
  is argued out in § *Decisions* on three grounds, the decisive one being that a satisfaction-aware
  predicate changes a past date's answer — the same defect #10's round rejected.
- **Where does quota satisfaction live?** Above this seam, in whatever capability owns ticks. That is
  a consequence of ADR-1004 rather than a fresh decision, and the delta states it normatively so the
  next Story inherits it instead of rediscovering it.
- **Is the quota bounded above, and where?** 1 through 7. Derived from the tick model and the Epic's
  exclusions, not chosen by taste — see § *Decisions*. A fact, so not the owner's.
- **Does the quota need a start date?** No, for the same reason `.weekdays` and `.dayOfMonth` do not.
- **Does an unmet quota carry into the next week, or become a miss?** Neither is answerable without
  ticks and neither is in this delta. `docs/parking-lot.md` keeps the question, unchanged.

Deliberately not answered, with the reason:

- **Where does a week begin?** Still open, still parked, and still nobody's to close yet. Nothing in
  this delta consumes a week boundary — a quota is due on every date, so no scenario can observe one
  — and answering it here would be a requirement written for a consumer that does not exist. It
  becomes real, and answerable, in the Story that makes a quota close.
- **Is "every day" a weekday set of seven, or an interval of one, or a quota of seven?** Now three
  rules with the same extension rather than two. Still not a contradiction, still not a question for
  this capability, and still answered where a screen has to *name* a rule back to the user.
