## Why

`schedule` (#6) has one rule shape of the four `CONTEXT.md` records as needed. This Story adds the
second: a day of the month. It is on the owner's day-one list as "finances every 25th", and it is
the only shape on that list that a weekday set cannot approximate — the 25th lands on a different
weekday every month, so nothing already in the spec expresses it.

It is also the shape that forces a question the weekday set never raised: **what does a commitment
on the 31st do in a month that has no 31st?** Five months of the year are too short for it, and
February is too short for the 29th and 30th as well. The rule shape is not implementable without
answering that, so this proposal answers it, and that answer is the substance of what G4 is
approving.

## What Changes

- Adds the day-of-month rule shape to the `schedule` capability: a commitment is due on a calendar
  date exactly when that date's day of the month is the scheduled day. Monthly, unbounded, anchored
  to no start month, and indifferent to the weekday.
- **Decides that a month too short for the scheduled day is due on its last day**, rather than
  skipping the month. A schedule on the 31st is due on 28 February in a common year, 29 February in
  a leap year and 30 September. The rejected alternative — skip the month entirely — is argued in
  `design.md`; it is the one decision here that a reviewer should push back on if they disagree,
  because everything else follows from it.
- Makes an out-of-range day of the month unrepresentable rather than silently never due: 1 through
  31 form a value, 0, −1 and 32 form nothing. This is the same refusal-not-adjustment stance
  `CalendarDate` already takes, extended to the other argument of the rule.
- Adds one case to the existing `Schedule` enum and one small public type beside it. The seam does
  not move: `Schedule.isDue(on:)` is unchanged, as `add-weekday-set-schedule`'s `design.md` said it
  would be for exactly this Story.
- **Not in this change:** "every N days" (#10) and the weekly quota (#11); a rule that runs every
  *other* month or on a fixed quarter; "the last day of the month" as a rule shape of its own,
  which the decision above makes expressible as the 31st; counting backwards from the end of a
  month; ticking; anything on screen.

## Capabilities

### Modified Capabilities

- `schedule`: gains the second of the four rule shapes. Three requirements are added; no existing
  requirement is modified or removed, and the weekday-set rule, the Gregorian weekday derivation
  and the calendar-date validity rules all stand as written.

## Impact

- **Code:** `src/DayByDayKit/Sources/DayByDayKit/` only. One new file for the day-of-month value,
  one new case and one new branch in `Schedule.isDue(on:)`. No new dependency, no change to
  `Package.swift`, no change to `CalendarDate`'s public surface.
- **Specs:** `openspec/specs/schedule/spec.md` at archive time, and nothing else — CI check 2 has
  exactly one claimed capability.
- **Tests:** twelve acceptance tests in the existing `Tests/DayByDayKitTests/`, one per scenario,
  taken one at a time.
- **Repository configuration:** none. Unlike #8, the package, the CI job and the `@Test("...")`
  reader all exist and have all run green once.
- **No ADR.** The short-month decision is reversible at the cost of one requirement, five scenarios
  and a few lines below the seam, and its durable home is the capability spec, which states it
  normatively and says why. `design.md` records the rejected alternative. If the owner reads it as
  a decision that should outlive this change folder, say so at G4 and it is written up as an ADR
  taking the next free number in `docs/adr/` — 1008 when this was written, so check the directory
  rather than trusting that figure.
