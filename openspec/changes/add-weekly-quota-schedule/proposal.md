## Why

`schedule` (#6) has three of the four rule shapes `CONTEXT.md` records as needed: a set of weekdays
(#8), a day of the month (#9) and every N days (#10). This Story adds the fourth and last, the
weekly quota — *"reading 3x a week"* on the owner's day-one list, described in `docs/parking-lot.md`
in his own words as **"an obligation of three times a week, any nights, open until the week turns
over"**. No existing shape expresses it: a weekday set would pick the nights for him, which is the
one thing this commitment is defined by not doing.

It is also the shape ADR-1004 and every design document since #8 has been pointing at as the one
that might not fit. It does not fit whole, and this proposal says so plainly rather than
discovering it at review. **The count cannot reach `isDue(on:)`.** Due-ness at that seam is a
function of a calendar date and nothing else, and no date knows how many of its week's three
readings have been done — that is a fact about ticks, and ticks do not exist in this repository. So
the shape splits in two:

- **Which days may the commitment be done on?** Any of them. That is a question about a date, it is
  answerable now, and it is what this change specifies.
- **Has this week's quota already been met, so the row can go quiet?** That is a question about the
  week's ticks. It is not answerable at this seam, by this capability, in this Story.

Shipping the first half now is a judgement call with a visible cost — a reading commitment would
appear on all seven days of the week with no sense of progress until ticks land — so it is **not
made here**. It goes to the owner as a one-question round in `design.md` § *Questions for you*, with
this delta already written on the recommended answer so the cost is a diff rather than an argument.

## What Changes

- Adds the weekly-quota rule shape to the `schedule` capability: a commitment owing N completions
  within a week is due on **every** calendar date. The quota fixes *how many times* a week the
  commitment is owed, never *which days*, so the system must not derive days from the count — three
  times a week is emphatically not Monday, Wednesday and Friday.
- **Decides that the count does not reach the due-ness rule, and says so normatively.** Two quotas
  differing only in their number are due on exactly the same dates. This is the surprising part of
  the change and the part a reviewer should push on; `design.md` argues it, and the delta pins it
  with a scenario rather than leaving it as an implementation accident.
- **Decides that quota satisfaction lives above this seam.** Answering "has the week's third reading
  been recorded?" from `isDue(on:)` would mean handing the rule engine tick history, which ADR-1004
  did not put there and which would make a past date's answer change after the fact — the same
  defect #10's round rejected when it refused a last-tick anchor. `design.md` argues the rejected
  alternative in full.
- Makes an out-of-range quota unrepresentable rather than silently meaningless: 1 through 7 form a
  value, 0, negative numbers and 8 and above form nothing. Seven is the ceiling because a tick is
  one per commitment per day, so a week cannot hold more than seven of them.
- Adds one case to the existing `Schedule` enum and one small public type beside it. The seam does
  not move: `Schedule.isDue(on:)` is unchanged, for the fourth Story running, which is what #8's
  `design.md` claimed for #9, #10 and #11 and is now claimed for the last of them.
- **Not in this change:** any reading of a tick; the definition of where a week begins, which
  nothing in this delta consumes and which stays parked; carrying an unmet quota into the next week;
  recording an unmet quota as a miss; a start date, an end date or a pause for any shape; anything
  on screen.

## Capabilities

### Modified Capabilities

- `schedule`: gains the fourth and last of the four rule shapes. Two requirements are added; no
  existing requirement is modified or removed. The weekday-set rule, the day-of-month rule and its
  short-month clamp, the every-N-days rule and its backward bound, the Gregorian weekday derivation
  and the calendar-date validity rules all stand exactly as written, and the new shape inherits the
  supported year range from them rather than restating it.

## Impact

- **Code:** `src/DayByDayKit/Sources/DayByDayKit/` only. One new file for the quota value, one new
  case and one new branch in `Schedule.isDue(on:)`. No new dependency, no change to `Package.swift`,
  no change to `CalendarDate`'s public surface, and — unlike #10 — no new arithmetic below the seam.
- **Specs:** `openspec/specs/schedule/spec.md` at archive time, and nothing else — CI check 2 has
  exactly one claimed capability.
- **Tests:** nine acceptance tests in the existing `Tests/DayByDayKitTests/`, one per scenario, taken
  one at a time.
- **`docs/parking-lot.md`:** two entries are touched by this change and neither is written here —
  `spec-author` does not write that file, so both are flagged for whoever does. *"week turnover is
  undefined: does an unfinished two-of-three vanish, or get recorded as a miss?"* stays exactly as
  it is; this change deliberately does not answer it, because nothing in the delta consumes a week
  boundary. The read-back asymmetry entry of 2026-08-31 now covers three shapes rather than two:
  `WeeklyQuota`'s count is internal, as `DayOfMonth.day` and `DayInterval.days` are.
- **The Story issue's intent sentence overreaches.** #11 reads *"Decide whether a commitment owing N
  completions within a week **still** asks for one on a given date."* The "still" is the half this
  change cannot deliver, and issue text is the orchestrator's to correct, not this agent's. If the
  round comes back on the recommended answer, that sentence should lose its "still" and the
  remainder should become a Story under `commitment` (#26) or `day-screen` (#27), once ticks exist.
- **No ADR, and one is arguably owed.** "Quota satisfaction lives above the rule engine" is a
  boundary that `commitment` and `day-screen` will both have to respect, which is more than a rule
  shape's private business. Against that: ADR-1004 already fixed the pure-calendar seam this
  conclusion falls out of, and #9 and #10 both took the same view — state it normatively in the
  capability spec, and offer the ADR at the gate rather than writing one nobody asked for. The
  precedent is followed here. If the owner reads it as a decision that should outlive this change
  folder, say so at G4 and it is written up taking the next free number in `docs/adr/` — 1009 when
  this was written, so check the directory rather than trusting that figure.
