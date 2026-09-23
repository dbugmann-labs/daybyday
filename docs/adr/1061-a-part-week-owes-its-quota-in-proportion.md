# 1061. A part week owes its quota in proportion to the days held

- Status: accepted
- Date: 2026-09-23
- Deciders: Diego Bugmann

## Context

A weekly quota is owed in a **week**, Monday through Sunday (ADR-1050). Some weeks a commitment
holds only in part: the week it is kept from, the week it was kept until, a week its rhythm changes
in, and — once `stop-and-resume-as-eras` (#306) makes a pause a **gap** between two eras — a week a
gap begins or ends in.

`look-back-at-a-quota` (#273) answered the part week at its grill: a part week owed the **whole
quota**, "1/3" for a commitment kept from a Thursday and ticked once, and a week two quota eras
shared was judged by the newer era's quota alone. The argument was that the week is the unit the
quota is owed in, and two quotas do not sum. It was a real decision, taken knowingly, and it lived
in that change's design and in `CONTEXT.md` rather than in a record — which is why it is recorded
here now that it is reversed.

What reversed it is the gap. Under the whole-quota rule, a commitment paused on a Tuesday and taken
up again on the Friday owes the whole week, so the pause itself reads as a week missed — the one
thing a pause exists not to cost. And the day screen says the week's standing on every quota row, so
whatever the look-back owes, the row has to owe too, or one of the two screens is wrong.

## Decision

**A week owes, for each weekly quota era holding a day of it, that quota times the days it holds,
over seven — the parts summed and rounded once to the nearest whole number.** One shape, one rule:
the week a commitment is kept from, the week it was kept until, a week a gap cuts and a week two
quota eras share all owe this way.

Four things are part of the decision rather than incidental to it:

- **Nearest, not floor or ceiling.** Floor lets a once-a-week commitment kept six days of a week owe
  nothing; ceiling makes one day of a three-a-week commitment owe one. Nearest never meets a tie:
  a whole number over seven is never a half.
- **Days held include days still to come.** The week in progress is not a part week for being in
  progress; only a day kept from, a day kept until, a
  rhythm change or a gap makes one. So a row on a Monday of an
  ordinary week still says "0/3x a week", not "0/0x a week".
- **A part week owing nothing is still said.** Its line says "0/0", or "1/0" where a day was kept,
  and a row says "0/0x a week". A missing line would read as a gap where the commitment was kept.
- **Both screens owe the same number, and count the same days.** A look-back's week line and a quota
  row's words owe one number, and both count the days of the week a quota era holds that a record
  keeps, a day kept before a stop in that week included.

## Consequences

- **Five shipped look-back fractions change**, and a part week no longer reads as a shortfall the
  person did not have. The week-line requirement moves under a new heading, because two of its
  scenario titles named the old rule.
- **The day screen's quota words gain a number.** `schedule` says a quota given a count and what its
  week owes, "1/2x a week", beside the count-only form ADR-1050's amendment added.
- **The sum across two quota eras is back**, which #273 ruled out on the ground that two quotas do not
  sum. They still do not: what sums is each era's share of its own week, which is a count of days
  owed, not a quota.

## Alternatives considered

**Keep the whole quota** (#273's rule, and the grill's recommendation). Rejected by the owner at the
grill of #306: it makes every pause cost a week.

**Pro-rate only a week a gap cuts**, leaving the kept-from and kept-until weeks whole. Rejected as two
rules for one shape; a week a commitment holds in part is the same fact whatever cut it.

**Round each era's part separately.** Rejected: a week shared three-and-five-a-week would owe one more
than its days hold.
