## Why

`schedule` (#6) has two of the four rule shapes `CONTEXT.md` records as needed: a set of weekdays
(#8) and a day of the month (#9). This Story adds the second of the four, every N days. Two items
on the owner's day-one list need it — *"contact lenses every 14 days"* and *"water plants every 3rd
day"* — and neither existing shape can approximate either: fourteen days walks around the weekday
wheel twice a year out of step, and three days lands on a different day of the month every month.

It also forces the question the first two shapes never had to answer: **an interval needs an
anchor.** A weekday set and a day of the month are anchored to the calendar itself — Wednesday and
the 25th mean the same thing to everyone, forever, with no reference point. "Every 3 days" means
nothing until you say *from when*. `docs/parking-lot.md` has carried that question, unresolved on
purpose, since the first product-definition conversation on 2026-08-28:

> "every N days" needs an anchor: N days from a fixed start, or N days from the last tick? the
> second makes a late tick shift everything after it, which is a different mechanism from the
> calendar rules.

This proposal answers it — a fixed start date — and that answer is the substance of what G4 approves.
It was not the agent's to answer: it went to the owner as **question 1 of a question round**, with a
second question beside it on whether the rule reaches back to dates before its start date. **Both
came back on 2026-08-31 on the recommended answers** — a fixed start date, and not due before it —
so the delta below is unchanged from the one the round was read against. `design.md` § *Open
Questions* records them as settled, with what the other answers would have cost.

## What Changes

- Adds the every-N-days rule shape to the `schedule` capability: a commitment is due on a calendar
  date exactly when that date is the schedule's start date, or a whole number of intervals after it.
  The interval counts calendar days and nothing else — it is indifferent to weekday, to month
  length, to the turn of a year, and it counts a leap day as a day like any other.
- **Decides the anchor is a fixed start date carried by the schedule, not the last tick.** The
  rejected alternative — counting from the last tick, so a late tick shifts every date after it — is
  argued in `design.md`, and it is not merely unchosen: it cannot be answered from a date alone, so
  it does not fit the seam ADR-1004 fixed and would need tick history that nothing has built yet.
- **Decides the rule does not reach back before its start date.** A schedule of every 3 days
  starting on 3 September is not due on 31 August, even though the arithmetic would land there.
  The alternative — a pure parity rule, unbounded in both directions — is argued in `design.md`.
- Makes an interval below one day unrepresentable rather than silently never due or crashing: 1 and
  up form a value, 0 and negative numbers form nothing. There is no upper bound, because a number
  larger than the days the supported years hold still names a schedule that comes due once, on its
  start date, and never again — which is a defined answer and not an error.
- Adds one case to the existing `Schedule` enum and one small public type beside it. The seam does
  not move: `Schedule.isDue(on:)` is unchanged, for the third Story running, as
  `add-weekday-set-schedule`'s `design.md` said it would be.
- **Not in this change:** the weekly quota (#11); a start date, an end date or a pause for the other
  two rule shapes, none of which has a requirement; skipping an occurrence; anything that reads a
  tick; anything on screen.

## Capabilities

### Modified Capabilities

- `schedule`: gains the second of the four rule shapes. Three requirements are added; no existing
  requirement is modified or removed. The weekday-set rule, the day-of-month rule and its
  short-month clamp, the Gregorian weekday derivation and the calendar-date validity rules all
  stand exactly as written, and the new rule inherits the supported year range from them rather
  than restating it.

## Impact

- **Code:** `src/DayByDayKit/Sources/DayByDayKit/` only. One new file for the interval value, one new
  case and one new branch in `Schedule.isDue(on:)`, and — for the first time in this capability —
  one new piece of arithmetic below the seam: the number of days between two calendar dates. No new
  dependency, no change to `Package.swift`, no change to `CalendarDate`'s public surface.
- **Specs:** `openspec/specs/schedule/spec.md` at archive time, and nothing else — CI check 2 has
  exactly one claimed capability.
- **Tests:** fourteen acceptance tests in the existing `Tests/DayByDayKitTests/`, one per scenario,
  taken one at a time.
- **`docs/parking-lot.md`:** the anchor entry quoted above is answered by this change and should be
  deleted from that file once the requirement lands. This change does not touch it — `spec-author`
  does not write there — so it is flagged here for whoever does.
- **No ADR.** The anchor decision is expensive to reverse in the sense that ticks would have to
  exist first, but the thing that makes it expensive is already an ADR: 1004 put a pure
  `CalendarDate -> Bool` at the seam, and a tick-driven interval is a different mechanism rather
  than a different value of this decision. What is left is one requirement, two scenarios and a few
  lines below the seam, whose durable home is the capability spec, which states it normatively and
  says why. If the owner reads the start date as a model decision that should outlive this change
  folder — it is the first thing in the engine that is not pure calendar — say so at G4 and it is
  written up as an ADR taking the next free number in `docs/adr/` (1009 when this was written, so
  check the directory rather than trusting that figure).
