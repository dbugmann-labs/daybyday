# 1051. A month too short for a day-of-month schedule is due on its last day

- Status: accepted — proposed by `add-day-of-month-schedule` (#9) and approved at its G4; this record
  is written by `condense-schedule-spec` (#208), the Story that deletes the requirement prose which
  had been carrying the reasoning
- Date: 2026-09-11
- Deciders: Diego Bugmann

## Context

A day-of-month schedule names a day from the 1st to the 31st. Five months have no 31st, and February
has no 30th and, in a common year, no 29th. What such a schedule does in those months is a product
decision with no technical answer, and until now nothing in `docs/adr/` recorded it: the argument
lived in `schedule`'s requirement prose and in an archived `design.md`, and ADR-1006 cites the clamp
only as an example of a decision an agent once took without asking.

ADR-1004 decides something near this and different from it: **a calendar date that names no day is
refused rather than adjusted**, so 30 February never quietly becomes 2 March. That decision is about
forming a date. This one is about which dates that already exist a schedule is due on.

## Decision

**When a month has fewer days than the scheduled day, the schedule is due on that month's last day**
— the true last day of that particular month: 28 or 29 February by the leap-year rule, and the 30th
of the four thirty-day months. It is not skipped in that month and it does not roll into the next,
so a schedule on the 31st is due on 28 February 2027 and not on 3 March. A month long enough to hold
the scheduled day is untouched, and every month therefore holds exactly one due date.

**This is what keeps a monthly commitment monthly.** A schedule on the 31st that simply went absent
from February, April, June, September and November would come due in seven months of the year and
pass the other five in silence, and a commitment that quietly never comes due is the failure this
product exists to remove. `CONTEXT.md` says a commitment is defined once and recurs indefinitely; a
rule that vanishes for five months does neither, and a person would find out in March, having not
done the thing in February.

**It does not contradict ADR-1004's refuse-rather-than-adjust.** The date the clamp lands on always
exists, so nothing is formed and then adjusted: the scheduled day stays the day it was offered, the
date asked about stays the date it is, and the only thing answered is whether that date is due. A
day of the month outside the 1st to the 31st is still refused as a number, exactly as ADR-1004 would
have it.

**The consequence is accepted rather than hidden.** In a common February, schedules on the 28th, the
29th, the 30th and the 31st are all due on the same date. That is the correct reading of "the end of
every month" for all four and not a collision to be resolved, because nothing in the capability asks
two schedules about each other.

## Consequences

- **The clamp is a fact about due-ness and is never said.** A schedule on the 31st says "The 31st" in
  every month (ADR-1034): what a short month does is true of the schedule and is not part of the
  rhythm a person chose.
- **The clamp cannot be computed by forming a date from the scheduled day and the asked date's month
  and year.** 31 February is not a calendar date, so that construction fails in exactly the months the
  clamp exists for, and a failed construction is not an answer of "not due".
- **"The last day of the month" is not a fifth rule shape.** Under the clamp it is the 31st.
- **Reversing this is a behaviour Story against three requirements, not one**: the short-month
  requirement and its scenarios; the day-of-month requirement, whose exactly one due date in every
  month, never none, holds only under the clamp; and the ordinal wording, whose rule and scenario that
  the clamp is never said would have nothing left to refer to.

## Alternatives considered

**Skip the month.** Due only on a date whose day equals the scheduled day, so a schedule on the 31st
is due in seven months and never in the other five. It is one comparison, needs no month length, and
is defensible as the literal reading. Rejected on the product's terms above: a commitment that
silently stops coming due is the failure being removed.

**Roll into the next month**, as Foundation does when asked for 31 February. Rejected because it
moves a monthly commitment into the wrong month, and it is the silent adjustment ADR-1004 exists to
keep out of the engine.

**Allow only the 1st to the 28th.** The cheapest of all. Rejected because it refuses "rent on the
30th" and "salary on the last day", which are ordinary monthly commitments, and puts an
arbitrary-looking limit on a choice a person reads as a calendar.

**Clamp or skip as an option on the schedule.** Rejected as a requirement nobody asked for; adding
skipping later is a delta, which is the cheap direction.
