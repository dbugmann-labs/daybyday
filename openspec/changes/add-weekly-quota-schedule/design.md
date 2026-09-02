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

**This folder was written twice.** The first pass, on 2026-09-02, went out with a two-question round
and was overtaken before it was answered: `add-commitment-type` (#42) merged and archived the same
day, the parking lot was replaced by `docs/backlog.md` and `docs/open-questions.md` (ADR-1010), and
`FEAT: record` (#53) was cut with two Stories under it. The second pass re-measured everything below
against that `main`, and § *Open Questions* says what became of the round.

**What was measured on this machine on 2026-09-02, on the rebased branch, rather than recalled**,
because a design that claims a seam survives should show the ground it stands on:

- `swift test` in `src/DayByDayKit` reports **64 tests passing**, on Apple Swift 6.3.3
  (`swiftlang-6.3.3.1.3`): the 45 from #8, #9 and #10 and the 19 #42 added. That is the baseline
  this change may not disturb.
- `Schedule` today is three cases and `isDue(on:)` is a three-way switch over them, and that switch
  is **the only `switch` in the package**, sources and tests alike. `CalendarDate` exposes `year`,
  `month`, `day`, `weekday`, `daysInMonth` and `days(until:)`, and every one of those six is
  internal. Nothing outside the module can read a date's parts.
- **`Schedule` now has one consumer: `Commitment`**, inside the same module, which stores one as an
  internal property and answers `isDue(on:)` by applying its kept-from floor and then delegating to
  `schedule.isDue(on:)`. It does not switch over the enum, so a new case reaches it with no edit.
  That is not an accident of the implementation: `openspec/specs/commitment/spec.md` requires that
  delegation *"holds for every schedule shape the `schedule` capability defines and for every shape
  added to it later, without this requirement changing,"* and #42's own design lists *"does the
  fourth rule shape (#11) need anything from this delta? No."* This change therefore touches no
  file in `commitment` and claims no second capability.
- **A tick now has a Feature and two Stories, and still no spec and no code.** `FEAT: record` (#53)
  was accepted at G1 and G2 on 2026-09-02 with #55 `add-tick-record` — blocked only by #42, so it is
  unblocked today — and #56 `add-record-store` behind it. There is no `openspec/specs/record/`, no
  change folder for either, and nothing in `src/` that records anything. "After ticks exist" is now
  a named Story rather than an unscheduled future, and § *Open Questions* says why that does not
  change what this delta can say.
- `CONTEXT.md` now defines **Record** as *"at most one per commitment per day"*, agreed with the
  owner at the first grooming pass on 2026-09-02, and **Tick** as being *"of a due commitment: a day
  on which the commitment is not due takes no tick."* Both were written after this folder's first
  pass, and both bear on it directly — the first is what the `1...7` ceiling rests on, the second is
  why a quota must answer *due* on every day a tick might be recorded.

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
- Touching `Commitment` or the `commitment` capability. Delegation is already required to reach
  through to shapes that do not exist yet, and it does, so there is nothing to add there and a
  scenario placed there would claim a second capability for no behaviour of its own.
- Ticks, a tick store, counting completions, or any predicate taking a count. #55 is the Story that
  builds the first of those, and inventing an argument no caller can yet supply is speculation, not
  design.
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
and `DayInterval.days` — the read-back asymmetry `docs/open-questions.md` § *Known gaps* records now
covers three shapes rather than two (four things, counting `Commitment`'s two internal fields), and
the first Story that draws a rule on screen widens all of them in one delta.

`Commitment` is the package's other seam and this change does not attach to it. It does not need to:
a `Commitment` on a `.weeklyQuota` schedule answers *due* from its kept-from day onward and *not
due* before it, exactly as it does on the other three shapes, because it delegates and the
`commitment` spec requires it to. Nothing here can observe that without restating a requirement
that has already passed G4, so nothing here tries to.

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
and a date does not know what was done. Since the first pass it has drawn a second one that points
the same way: a tick is *of a due commitment*, and a day on which the commitment is not due takes no
tick. A quota that answered *not due* on any day would be a day on which reading could not be
recorded — which is the opposite of "any nights".

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
rejected a last-tick interval for exactly this reason and the owner confirmed it on 2026-08-31, and
#42 has since written it into a requirement: a commitment's due-ness *"MUST NOT consider … whether
the commitment has been ticked."* This is a line the product has now drawn twice.

*Alternative — widen the seam so it can take a completion count*, e.g.
`isDue(on: CalendarDate, completedThisWeek: Int)`. Rejected on two grounds. It makes every one of
the other three shapes carry a parameter they cannot use, which is the tax #10 refused to pay when
it declined to give the other shapes a start date, and it would now also break `Commitment`, the one
caller that exists. And no caller can supply the argument: no tick record exists in this repository,
so the parameter would be answered `0` by every test and every caller until #55 built one — and
when it does, the commitment spec forbids that count from reaching this predicate anyway. Designing
a signature around a value nothing can compute and nothing may pass is speculation with an API
attached.

*Alternative — take the quota out of `Schedule` and give it a type of its own*, so that no one can
ask `isDue` of a quota and be misled by the `true`. This is the most tempting of the three, and it
is the one a reviewer should push on. It is rejected because it contradicts vocabulary the owner has
already agreed: `CONTEXT.md` records four *schedule* shapes and names the quota as one of them, and
`docs/backlog.md` § *What day one looks like* has the owner's own framing of the four shapes as the
whole list. It also moves the problem rather than solving it, and now at a real cost: `Commitment`
holds exactly one `Schedule` by a requirement that has passed G4, so a commitment holding "a
schedule or a quota" would reopen the `commitment` spec — and every consumer would still switch over
the pair, which is the enum that already exists with one extra layer. The safety it buys is bought
more cheaply by the spec saying, normatively, what `true` does and does not mean.

*Alternative — do not ship this shape until ticks exist.* The first pass put this to the owner as a
question, on the ground that it was a preference. It is withdrawn in § *Open Questions*, because on
the rebased `main` it turns out to be settled by a fact: ticks cannot change what this delta says.

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

### One through seven, because a day holds one record

`case weeklyQuota(Int)` would let 0 and 8 through. Zero is a commitment with nothing to do — a rule
that is never satisfiable and never explains why. Eight or more is worse: it is a promise no week
can keep, because `CONTEXT.md` now defines a **Record** as *"at most one per commitment per day"*,
agreed with the owner on 2026-09-02, and `docs/backlog.md` B-002 keeps the one thing that
accumulates within a day — protein — as a want of a different kind, outside this Epic. Seven days,
at most one record each, so at most seven.

The first pass had to argue that bound from a tick's definition and a parking-lot contrast, and it
said so: it was the one place the change reasoned from something not yet written down. It no
longer is. The lower bound needs no such argument: zero is refused for the same reason `DayOfMonth`
refuses zero.

`Int.max` gets no scenario of its own, for the reason #9 gave: the `1...7` guard refuses it like any
other out-of-range number, and a `WeeklyQuota` never becomes a `DateComponents`, so Foundation's
"unspecified" sentinel cannot reach it.

### An ADR, because three design documents have already needed this answer

`docs/adr/1014-a-weekly-quota-is-due-every-day.md` records the first decision above. It meets all
three of `docs/adr/README.md`'s tests: reversing it means widening the seam for every shape or
moving the quota out of `Schedule`, and now reopening `commitment` either way;
`.weeklyQuota(3).isDue(on:)` answering `true` on a Thursday will surprise every future reader who
has not been through this reasoning; and the alternatives were real enough that the first pass put
one of them to the owner.

It was numbered 1010 when first written; ADR-1010 was taken on `main` by the backlog decision the
same day, so it is 1014 now, after #42's ADR-1013. It is written on the branch and merges with it,
which is the precedent ADR-1004 set — that file landed in #8's implementation commit, not in a pass
of its own. `Status: accepted` is therefore written now and the acceptance is the owner's G4
signature on this diff, which the ADR says in as many words. If G4 declines it, the file goes with
the branch rather than being superseded: `docs/adr/README.md`'s immutability rule binds accepted
records in `main`, and nothing here has reached it.

## Risks / Trade-offs

- **This change adds a case that carries data and almost no behaviour.** A reviewer at G7 will
  reasonably ask what it bought. → It is not disguised: `proposal.md` says it, this document says
  it, and § *Open Questions* says why deferring it was withdrawn as a question. What it buys is
  concrete and checkable: `Commitment` can then be formed for every one of the eight day-one
  commitments instead of seven, and `FEAT: schedule` (#6) closes.
- **A confident `true` is the failure mode #9 named**, and this shape produces one on four days out
  of seven for a three-times-a-week commitment. → Mitigated the only way it can be at this seam: by
  making the spec say so normatively, so the first consumer meets the limitation as a requirement
  rather than as a surprise. It is not mitigated away, and pretending otherwise would be worse than
  the risk.
- **`add-tick-record` (#55) is unblocked and may land first, or alongside.** → Neither order costs
  anything here. Nothing in this change reads a tick and nothing in #55 can switch over `Schedule`
  without contradicting the `commitment` spec's delegation rule, so the two touch different files
  and neither rebases into the other's delta. If #55's grill finds it needs the quota shape to state
  a scenario, that is a blocking edge for `orchestrator` to declare, not a change to this folder.
- **Six scenarios asserting the same `true`.** → Four of the six pin calendar boundaries — a week
  boundary, a leap day, a year turn, and both ends of the supported range — which is exactly where a
  later implementation that starts consulting the calendar would break. `tasks.md` says plainly that
  they are pins rather than drivers, and that only the first is expected to run red.
- **`WeeklyQuota` carries the same read-back asymmetry `DayOfMonth` and `DayInterval` do.** → Left
  as is, deliberately; the `docs/open-questions.md` § *Known gaps* entry now describes three shapes,
  and the eventual widening delta should cover all three.
- **The week boundary leaves this Story unanswered after three design documents said it would be
  answered here.** → Reported rather than papered over, in § *Open Questions*. Writing a normative
  "a week begins on Monday" that no scenario in this change could observe would be an idea
  pretending to be a requirement, which `AGENTS.md` forbids in its own words.

## Migration Plan

None. Nothing is stored, no `Schedule` or `Commitment` value exists outside a test, and the delta
adds requirements without modifying one. `Schedule` gaining a case is source-breaking only for an
exhaustive `switch` over it, and the only such switch in the repository is `isDue(on:)` itself —
measured on the rebased branch, sources and tests, rather than assumed. `Commitment`, the one
consumer, delegates rather than switches and compiles unchanged. The `commitment` spec is not
modified, so CI check 2 sees exactly one claimed capability.

## Open Questions

None. The first pass raised two as a question round; both were overtaken by what landed on `main`
on 2026-09-02, and both are withdrawn here, on facts rather than on a guess at the owner's
preference. If either withdrawal is wrong, G4 is where to say so, and § *Decisions* records what
moves in each case.

1. **Ship the fourth shape now, or wait until ticks exist?** — **withdrawn: waiting cannot change
   this delta, so there is nothing for the answer to decide.** The first pass recommended shipping
   on the ground that `add-commitment-type` (#42) needed this case to express "reading 3x a week";
   #42 shipped without it, on a delegation rule that reaches through to shapes added later, so that
   argument is gone and is not re-made. What replaces it is stronger and is not a preference. Ticks
   now have a Feature (#53) and an unblocked Story (#55), so "wait" has a date for the first time —
   and it would still buy nothing: `Schedule.isDue(on:)` takes a calendar date (ADR-1004), and the
   `commitment` spec now requires that due-ness *"MUST NOT consider … whether the commitment has
   been ticked."* A quota Story grilled after #55 lands would therefore be answering the same
   question at the same seam with the same two requirements. The only thing deferral changes is
   *when* the eighth day-one commitment can be formed as a `Commitment`, which is sequencing, and
   sequencing is what the owner exercised by cutting this Story at G2 and asking for Stage 4 on it
   twice. Declining G4 is still available and still means what the first pass said: the folder and
   ADR-1014 go, #11 is blocked behind the first Story that renders a quota's state, and #6 stays
   open with one Story outstanding.
2. **Is a quota capped at seven a week, or can it ask for more?** — **withdrawn: settled by
   `CONTEXT.md`.** The first pass raised it because the ceiling rested on "a day holds at most one
   tick", which was not written down anywhere. It now is — **Record** is *"at most one per
   commitment per day"*, agreed with the owner at the grooming pass that cut `FEAT: record` — so an
   eighth time in a week is unrecordable by definition, and refusing it is the same refusal that
   stops a 32nd day of the month. Lifting the cap would now contradict agreed vocabulary rather than
   express a preference, and if the owner wants a day to carry more than one record of a commitment,
   that is a change to **Record** and to #55's delta, which is where it should be said.

Settled by finding out rather than by asking: that the seam does not have to move (all four shapes
fit the signature #8 fixed); that `Commitment` is the only consumer of `Schedule` and reaches the new
case by delegation, with no switch anywhere in the package but `isDue(on:)`; that the `commitment`
spec promises exactly that for shapes added later, so this change claims one capability; that #42 is
merged and archived, so this Story blocks nothing and is blocked by nothing; and that a tick now has
a Feature and a Story but no spec and no code.

Deliberately not answered here, each with the reason:

- ***Where does a week begin?*** **This Story cannot answer it, and that is a correction to #8's,
  #9's and #10's design documents, all three of which assigned the question here.** Under the
  decision above a weekly quota is due on every date, so no week boundary is ever consulted, nothing
  in this change can observe one, and no scenario could assert one. A normative "a week begins on
  Monday" would therefore be a requirement no test could hold, which is precisely the "obvious idea
  that is not yet real" `AGENTS.md` keeps out of specs. The question belongs to the first Story that
  counts ticks within a week, which is where it becomes observable. `docs/open-questions.md`
  § *Open product questions* carries it inside *Week turnover* — "the answer changes what a week
  *is*" — without naming the boundary in so many words; this change does not write to that file.
- ***What happens to an unmet quota when the week turns over?*** `docs/open-questions.md` has
  carried it as *Week turnover* since the parking lot did, and it is untouched here. It is a
  question about what is recorded, not about which days a commitment runs on, so nothing in this
  capability can answer it.
- ***What does a quota mean in a partial first week?*** A commitment on 3 times a week, kept from a
  Friday, is due on Friday, Saturday and Sunday of its first week and on no earlier day, because the
  kept-from floor (ADR-1013) applies ahead of every shape. Whether three are still owed in a week
  with three days in it, or fewer, is a counting question for the Story that renders a quota's
  state, and it belongs with *Week turnover*. This capability's answer — due on each of those three
  days — is already required by `commitment` and is not restated here.
- ***May a fourth tick be recorded in a week whose quota is three?*** The schedule says yes: every
  day is due, and a tick is of a due commitment. Whether the record capability wants to refuse or
  merely count it is #55's or a later Story's to say; nothing in `schedule` can distinguish the
  fourth from the first, and the delta says so.
- ***Is "every day" a weekday set of seven, an interval of one, or a quota of seven?*** All three,
  now, and that remains fine for the reason #10 gave and `docs/open-questions.md` § *Settled*
  records: two rules having the same extension is not a contradiction, and it becomes a real
  question only when a screen has to name a rule back to the user — `docs/backlog.md` B-015 already
  lists it as that screen's open point. This change adds a third way to say it and no new problem.
