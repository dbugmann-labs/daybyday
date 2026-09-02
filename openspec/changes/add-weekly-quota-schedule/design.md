## Context

`add-weekday-set-schedule` (#8) built the package, the seam and the date model and claimed the seam
would not move for #9, #10 or #11. `add-day-of-month-schedule` (#9) and `add-every-n-days-schedule`
(#10) made good on that claim for the first two. This is the third and last of them, and all three
of those design documents ended with the same unresolved line: *"#11 may still not fit this seam — a
weekly quota needs tick history."* This Story is where that is settled.

ADR-1004 fixed what the seam takes — a `CalendarDate`: year, month, day, no clock, no time zone —
and `CONTEXT.md` fixes what due-ness is: *"whether a commitment is due is a question asked of a
date, not of the present moment."* Motivation is in `proposal.md`; the behaviour contract is in
`specs/schedule/spec.md` and is not restated here.

**What was measured on this machine on 2026-09-02 rather than recalled**, because a design that
claims a seam survives should show the ground it stands on:

- `swift test` in `src/DayByDayKit` reports **45 tests passing**, on Apple Swift 6.3.3
  (`swiftlang-6.3.3.1.3`). That is the baseline this change may not disturb.
- `Schedule` today is three cases and `isDue(on:)` is a three-way switch over them; `CalendarDate`
  exposes `year`, `month`, `day`, `weekday`, `daysInMonth` and `days(until:)`, and every one of
  those six is **internal**. Nothing outside the module can read a date's parts.
- Nothing in this repository consumes `Schedule`. There is no app target, no commitment type — that
  is #42, not started — and no exhaustive `switch` over the enum outside the module.
- No tick exists anywhere: not in `src/`, not in `openspec/specs/`, not as a Feature or Story on the
  tracker. `FEAT: day-screen` (#27) has not been decomposed. **"After ticks exist" is not a date;
  it is an unscheduled future.** That fact is load-bearing for the question below.
- `add-commitment-type` (#42) declares no blocking edge, so it can be worked whether or not this
  Story lands. What it cannot do without this Story is express "reading 3x a week", which is one of
  the eight items on the owner's day-one list in `docs/parking-lot.md`.

Nothing else needed measuring. This is the first rule shape in the capability that performs **no
calendar arithmetic at all**, so there is no Foundation call to pin down, which is why this design
has no table of measurements where #9's and #10's did.

## Goals / Non-Goals

**Goals:**

- The fourth and last rule shape, on the seam that already exists, with no change to it.
- An honest answer to what a quota means at a date-only seam — one that is either right or visibly
  wrong, rather than plausible and quietly incomplete.
- The limitation written where it survives: normatively, in the capability spec, so that the Story
  which draws a day screen cannot read `isDue` as sufficient without contradicting a requirement.
- A quota number that cannot be zero, negative, or larger than a week can hold.

**Non-Goals:**

- Moving, widening or wrapping `Schedule.isDue(on:)`. If this Story needed the seam to change, #8's
  claim was wrong and that is a finding, not a refactor. It did not; the finding is recorded in
  § *Decisions* either way.
- Ticks, a tick store, counting completions, or any predicate taking a count. Nothing has built one
  and inventing an argument no caller can supply is speculation, not design.
- Deciding where a week begins. It cannot be observed anywhere in this change, so it cannot be
  specified here — see § *Open Questions*, which corrects three earlier design documents that
  assigned the question to this Story.
- A quota over any span other than a week, a quota with a start date, an end date, or a carry-over
  of an unmet week into the next one.
- Any opinion on what a screen draws. The spec says what this capability does not answer; it does
  not say what the day screen should do about it.

## Decisions

### The seam

**Unchanged: `Schedule.isDue(on:) -> Bool`**, the public instance method on `Schedule` exported from
`DayByDayKit`. Every acceptance test in this change attaches there, exactly as #8's, #9's and #10's
do. The enum gains one case, and this is the last one the four shapes call for:

```swift
public enum Schedule: Hashable, Sendable {
    case weekdays(Set<Weekday>)
    case dayOfMonth(DayOfMonth)
    case everyNDays(DayInterval, from: CalendarDate)
    case weeklyQuota(WeeklyQuota)

    public func isDue(on date: CalendarDate) -> Bool
}
```

The new case's payload is a new public type, and — as with `CalendarDate` in #8, `DayOfMonth` in #9
and `DayInterval` in #10 — its failable initializer is part of the same seam rather than a second
one, because there is no way to build a `.weeklyQuota` schedule without going through it:

```swift
public struct WeeklyQuota: Hashable, Sendable {
    public init?(timesPerWeek: Int)
}
```

The four validity scenarios in the delta observe that initializer; the other six construct a
`Schedule` and a `CalendarDate` and assert on the `Bool` that comes back. No process is spawned, no
global stream is captured, and `WeeklyQuota.timesPerWeek` stays internal, matching `DayOfMonth.day`
and `DayInterval.days` — the read-back asymmetry `docs/parking-lot.md` recorded on 2026-08-31 now
covers three shapes rather than two, and the first Story that draws a rule on screen widens all
three in one delta.

`case weeklyQuota(WeeklyQuota)` repeats the type's name for the same reason
`case dayOfMonth(DayOfMonth)` does: the case is the shape and the payload is its one number. The
label `timesPerWeek:` rather than `times:` is what makes `WeeklyQuota(timesPerWeek: 3)` read as the
sentence the product uses, in the same way `DayInterval(days: 14)` does.

**#8's claim holds, and this is the last chance it had to fail.** All four shapes fit
`isDue(on: CalendarDate) -> Bool` without the signature moving. That is worth stating plainly
because three design documents in a row hedged on it.

### A weekly quota is due on every date, and completion is not this capability's question

This is the decision the Story turns on, and the one earlier design documents suspected would break
the seam. All the alternatives are real, so all of them are written down.

**Chosen: due on every date; the quota's count is not consulted; whether the week is finished is
answered elsewhere.** The reasoning is that a schedule answers *which days a commitment runs on*,
and the honest answer for "3 times a week, any nights" is *all of them*. The quota's number is a
second, different fact about the commitment — how many of those days must end in a tick — and it is
not a fact about a date at all. `CONTEXT.md` already draws that line: due-ness is asked of a date,
and a date does not know what was done.

The cost is precise and worth saying out loud: `.weeklyQuota(3)` and `.weeklyQuota(7)` and
`.weekdays(all seven)` are indistinguishable through the seam. This change therefore adds a case
that carries data and almost no behaviour. That is a fair criticism and the delta does not disguise
it — six of the ten scenarios assert the same `true`, and their value is as regression pins against
a future implementation that starts consulting the calendar, not as drivers of code that does not
exist yet.

*Alternative — make due-ness depend on what has been ticked.* The literal product behaviour: due
until three are done, then quiet until the week turns. **It does not fit, on a fact rather than a
preference.** `isDue(on:)` takes one calendar date; a quota answered this way is a function of a
date *and* a commitment's entire history, which is not what ADR-1004 put at the seam and not what
the other three shapes take. It also breaks the writable past outright: ticking today would change
what yesterday's screen says about yesterday, which `CONTEXT.md` forbids in as many words. #10
rejected a last-tick interval for exactly this reason and the owner confirmed it on 2026-08-31, so
this is a line the product has already drawn once.

*Alternative — widen the seam so it can take a completion count*, e.g.
`isDue(on: CalendarDate, completedThisWeek: Int)`. Rejected on two grounds. It makes every one of
the other three shapes carry a parameter they cannot use, which is the tax #10 refused to pay when
it declined to give the other shapes a start date. And no caller can supply the argument: no tick
record exists in this repository, so the parameter would be answered `0` by every test and every
future caller until something built one. Designing a signature around a value nothing can compute is
speculation with an API attached.

*Alternative — take the quota out of `Schedule` and give it a type of its own*, so that no one can
ask `isDue` of a quota and be misled by the `true`. This is the most tempting of the three, and it
is the one a reviewer should push on. It is rejected because it contradicts vocabulary the owner has
already agreed: `CONTEXT.md` records four *schedule* shapes and names the quota as one of them, and
`docs/parking-lot.md` has "four rule shapes cover all of it" in the owner's own framing. It also
moves the problem rather than solving it: a commitment would then hold either a schedule or a quota,
and every consumer would have to switch over the pair — which is the enum that already exists, with
one extra layer. The safety it buys is bought more cheaply by the spec saying, normatively, what
`true` does and does not mean.

*Alternative — do not ship this shape until ticks exist.* Genuinely defensible, and it is the one
thing here that is a preference rather than a fact, so it is question 1 of the round below rather
than a decision taken in this section.

### The limitation is a requirement, not a design note

Everything in this folder except the delta is archived out of the way once the Story lands.
`openspec/specs/schedule/spec.md` is what the next agent reads. So the sentence that matters most —
*this capability does not tell you whether the week's quota has been met* — is written into the
requirement prose in the delta, normatively, rather than left here where the day-screen Story would
never see it. A consumer that hid a met quota by reading `isDue` alone would then be contradicting a
spec rather than merely misunderstanding a design document.

This is also why the requirement states the unhelpful consequence — a three-times-a-week commitment
showing on all seven days — instead of describing only the part that works. #9 set the precedent
when it wrote the four-schedules-collide-in-February consequence into the spec rather than hiding
it.

### One through seven, because a day holds one tick

`case weeklyQuota(Int)` would let 0 and 8 through. Zero is a commitment with nothing to do — a rule
that is never satisfiable and never explains why. Eight or more is worse: it is a promise no week
can keep, because `CONTEXT.md` defines a tick as recording *that* a due commitment was done, one
record against one day, and `docs/parking-lot.md` draws the contrast explicitly by listing protein —
*"a number entered several times a day that accumulates rather than overwrites"* — as a different
kind of thing, and one outside this Epic. Seven days, at most one tick each, so at most seven.

That upper bound is the one place this change reasons from something not yet built. It is a
deliberate, small bet, and § *Open Questions* records what would move it. The lower bound needs no
such argument: zero is refused for the same reason `DayOfMonth` refuses zero.

`Int.max` gets no scenario of its own, for the reason #9 gave: the `1...7` guard refuses it like any
other out-of-range number, and a `WeeklyQuota` never becomes a `DateComponents`, so Foundation's
"unspecified" sentinel cannot reach it.

### An ADR, because three design documents have already needed this answer

`docs/adr/1010-a-weekly-quota-is-due-every-day.md` records the first decision above. It meets all
three of `docs/adr/README.md`'s tests: reversing it means widening the seam for every shape or
moving the quota out of `Schedule`; `.weeklyQuota(3).isDue(on:)` answering `true` on a Thursday will
surprise every future reader who has not been through this reasoning; and the alternatives were real
enough that one of them goes to the owner as a question.

It is written on the branch and merges with it, which is the precedent ADR-1004 set — that file
landed in #8's implementation commit, not in a pass of its own. `Status: accepted` is therefore
written now and the acceptance is the owner's G4 signature on this diff, which the ADR says in as
many words. If question 1 comes back as *wait*, the file is deleted with the branch rather than
superseded: `docs/adr/README.md`'s immutability rule binds accepted records in `main`, and nothing
here has reached it.

## Risks / Trade-offs

- **This change adds a case that carries data and almost no behaviour.** A reviewer at G7 will
  reasonably ask what it bought. → It is not disguised: `proposal.md` says it, this document says
  it, and the alternative — deferring the whole Story — is question 1 of the round rather than a
  choice made quietly. What it buys is concrete and checkable: `add-commitment-type` (#42) can then
  express every one of the eight day-one commitments instead of seven.
- **A confident `true` is the failure mode #9 named**, and this shape produces one on four days out
  of seven for a three-times-a-week commitment. → Mitigated the only way it can be at this seam: by
  making the spec say so normatively, so the first consumer meets the limitation as a requirement
  rather than as a surprise. It is not mitigated away, and pretending otherwise would be worse than
  the risk.
- **The `1...7` ceiling rests on "a day holds at most one tick", which is not yet specified
  anywhere.** → Argued above from `CONTEXT.md` and `docs/parking-lot.md` rather than assumed, and
  recorded in § *Open Questions* with what it would cost to move: one requirement, one scenario and
  one guard. It is the cheapest thing in the change to be wrong about.
- **Six scenarios asserting the same `true`.** → Four of the six pin calendar boundaries — a week
  boundary, a leap day, a year turn, and both ends of the supported range — which is exactly where a
  later implementation that starts consulting the calendar would break. `tasks.md` says plainly that
  they are pins rather than drivers, and that only the first is expected to run red.
- **`WeeklyQuota` carries the same read-back asymmetry `DayOfMonth` and `DayInterval` do.** → Left
  as is, deliberately; the parking-lot entry of 2026-08-31 now describes three shapes, and the
  eventual widening delta should cover all three.
- **The week boundary leaves this Story unanswered after three design documents said it would be
  answered here.** → Reported rather than papered over, in § *Open Questions*. Writing a normative
  "a week begins on Monday" that no scenario in this change could observe would be an idea
  pretending to be a requirement, which `AGENTS.md` forbids in its own words.

## Migration Plan

None. Nothing is stored yet, no `Schedule` value exists outside a test, and the delta adds
requirements without touching one. `Schedule` gaining a case is source-breaking only for an
exhaustive `switch` outside the module, and there is none — verified above rather than assumed.

## Questions for you

1. **Ship the fourth shape now, or wait until ticks exist?** As written, this change gives
   `Schedule` a `.weeklyQuota` case that is due on every date and whose number nothing yet reads.
   The alternative is to close or park #11 until a tick capability exists, and let the Story be
   re-grilled then, when the quota can be given its full meaning in one piece.
   - *Recommended:* **ship it now.** Three things decide it. `add-commitment-type` (#42) is the next
     Story on the tracker and, without this case, ships a commitment type that cannot express
     "reading 3x a week" — one of your eight day-one items. Waiting is not waiting for a scheduled
     event: no tick Feature, Story or spec exists, and `FEAT: day-screen` (#27) has not been
     decomposed, so "later" has no date attached to it. And the thing that makes shipping safe is in
     the delta rather than in a design note — the spec states normatively that this capability does
     not answer whether a week's quota has been met, so the day screen inherits an explicit
     obligation rather than a trap.
   - *If you say wait:* the whole change folder goes. There is no smaller version of it — a quota
     case with no due-ness answer is not a thing `Schedule` can hold, since the enum must be total.
     #11 would be marked blocked behind a tick Story that does not exist yet, `FEAT: schedule` (#6)
     stays open with one Story outstanding, and ADR-1010 is deleted rather than written. Nothing
     else in the repository changes, and nothing already merged depends on this.

2. **Is a quota capped at seven a week, or can it ask for more?** The delta refuses 8 and above,
   reasoning that a day records at most one tick of a commitment, so a week holds at most seven and
   an eighth could never be met.
   - *Recommended:* **cap it at seven.** A commitment that can never be kept is the same failure as
     one that never comes due, which this capability already refuses in #9's short-month rule. Seven
     also gives the ceiling a meaning a picker can show — "every day".
   - *If you say uncapped:* the second requirement loses its upper bound and its 8-is-refused
     scenario, becoming "one or more times a week"; the guard in the implementation drops to
     `>= 1`, matching `DayInterval`. One requirement and one scenario move, the first requirement
     and all six of its scenarios are untouched, and it implies a day can carry more than one tick
     of the same commitment — which is a bigger statement about the product than about this Story,
     so say it deliberately if you say it.

## Open Questions

None left open by the grill. Two went to you as the round above, because both are preferences whose
answers change the delta; the rest were settled here or in the delta, and the ones this shape
deliberately does not answer are listed with their reasons.

Settled by finding out rather than by asking: that the seam does not have to move (all four shapes
fit the signature #8 fixed); that no exhaustive `switch` outside the module breaks when the enum
grows; that `add-commitment-type` declares no blocking edge on this Story; and that no tick exists
anywhere in the repository or on the tracker, which is what turns "wait for ticks" from a schedule
into an open-ended deferral.

Deliberately not answered here, each with the reason:

- ***Where does a week begin?*** **This Story cannot answer it, and that is a correction to #8's,
  #9's and #10's design documents, all three of which assigned the question here.** Under the
  decision above a weekly quota is due on every date, so no week boundary is ever consulted, nothing
  in this change can observe one, and no scenario could assert one. A normative "a week begins on
  Monday" would therefore be a requirement no test could hold, which is precisely the "obvious idea
  that is not yet real" `AGENTS.md` keeps in `docs/parking-lot.md` instead. The question belongs to
  the first Story that counts ticks within a week, which is where it becomes observable. The
  parking-lot entry stays where it is; this change does not write to that file.
- ***Can a day carry more than one tick of the same commitment?*** Argued above as no, from
  `CONTEXT.md`'s definition of a tick and the parking lot's explicit contrast with protein, and that
  is what the `1...7` ceiling rests on. It is question 2's real subject and it is not settled by
  this Story beyond that bound — a tick capability will have to state it properly.
- ***What happens to an unmet quota when the week turns over?*** `docs/parking-lot.md` has carried
  this since 2026-08-28 and it is untouched here. It is a question about what is recorded, not about
  which days a commitment runs on, so nothing in this capability can answer it.
- ***Is "every day" a weekday set of seven, an interval of one, or a quota of seven?*** All three,
  now, and that remains fine for the reason #10 gave: two rules having the same extension is not a
  contradiction, and it becomes a real question only when a screen has to name a rule back to the
  user. This change adds a third way to say it and no new problem.
