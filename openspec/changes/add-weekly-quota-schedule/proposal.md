## Why

`schedule` (#6) has three of the four rule shapes `CONTEXT.md` records as needed. This Story adds
the fourth and last: **N times within a week, on any days**. It is on the owner's day-one list as
"reading 3x a week", and it is the only item on that list no existing shape can express — a weekday
set names the days and a quota deliberately does not.

It is also the shape three previous design documents flagged as the one that might not fit the seam,
because a quota sounds like it needs to know what has already been done. That question is the
substance of what G4 approves here, and the answer is not the obvious one: **`schedule` answers
which days a commitment runs on, and a weekly quota runs on all of them.** How many of the week's
completions are still owed is a question about ticks, and a tick has a Feature and a Story on the
tracker but is neither built nor specified anywhere in this repository.

## What Changes

- Adds the weekly-quota rule shape to the `schedule` capability. A commitment on one is due on
  **every** calendar date, because every day of the week is a day on which the quota may be
  discharged, and the schedule constrains how many times rather than which days.
- **States, normatively and in the spec rather than only in a design document, what this capability
  does not answer for a quota:** whether the week's count has been met, and therefore whether the
  commitment should still be shown. A consumer that hides a met quota must do it from tick records,
  outside `schedule`. This is the limitation that makes the shape safe to ship before ticks exist,
  and burying it in a design file that gets archived is how it would be missed.
- Makes an unachievable or empty quota unrepresentable rather than silently broken: one through
  seven form a value, and 0, −1 and 8 form nothing. Seven is the ceiling because a day carries at
  most one tick of a commitment, so an eighth would be a promise no week could ever keep.
- Adds one case to the existing `Schedule` enum and one small public type beside it. **The seam does
  not move**, so `add-weekday-set-schedule`'s claim that it would survive all four shapes holds for
  the fourth and last time.
- **An ADR**, `docs/adr/1014-*`, recording that a weekly quota's due-ness is opportunity rather than
  obligation and that completion lives outside this capability. It qualifies on all three of
  `docs/adr/README.md`'s tests: reversing it means widening the seam for every shape or moving the
  quota out of `Schedule`; `.weeklyQuota(3).isDue(on:)` answering `true` on a Thursday is surprising
  to anyone who has not read the reasoning; and the alternatives were real.
- **Not in this change:** ticks, counting them, or any notion of a quota being met; where a week
  begins, which this change cannot observe and therefore cannot settle (see `design.md`
  § *Open Questions*); a quota over a month or a fortnight; a start date for the quota; anything on
  screen.

## Capabilities

### Modified Capabilities

- `schedule`: gains the fourth and last rule shape. Two requirements are added; no existing
  requirement is modified or removed, and the weekday-set, day-of-month and every-N-days rules, the
  Gregorian weekday derivation and the calendar-date validity rules all stand exactly as written.

## Impact

- **Code:** `src/DayByDayKit/Sources/DayByDayKit/` only. One new file for the quota value, one new
  case and one new branch in `Schedule.isDue(on:)`. No new dependency, no change to `Package.swift`,
  and — for the first time in this capability — **no calendar arithmetic at all**: the branch is a
  `return true`, and nothing in the shape consults `CalendarDate`'s internals. `Commitment`, the one
  consumer of `Schedule`, delegates rather than switches and compiles unchanged.
- **Specs:** `openspec/specs/schedule/spec.md` at archive time, and nothing else — CI check 2 has
  exactly one claimed capability.
- **Docs:** `docs/adr/1014-*.md` and two `CONTEXT.md` entries, both written at Stage 4 rather than
  at archive.
- **Tests:** ten acceptance tests in the existing `Tests/DayByDayKitTests/`, one per scenario, taken
  one at a time. The sixty-four that pass today — forty-five from #8, #9 and #10 and nineteen from
  #42 — must all still pass; none may change.
- **Repository configuration:** none. The package, the CI job and the `@Test("...")` reader all
  exist and have run green through three Stories.
- **What this leaves undone, said plainly:** after this change a `Commitment` can be formed for
  every one of the owner's day-one commitments, and the engine can still not tell him that reading
  is finished for the week.
  That is the day screen's work and it needs a tick store; this change does not pretend otherwise
  and the spec says so.
