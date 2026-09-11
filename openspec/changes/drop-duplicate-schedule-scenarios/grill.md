# Grill — drop-duplicate-schedule-scenarios

*13 questions over 2 rounds, 2026-09-11. Line numbers are `openspec/specs/schedule/spec.md` at
`633d031`; re-anchor by title.*

## Settled

1. **The lane is recorded by amending ADR-1047**, not by a new ADR. *A new ADR-1050 was
   recommended; the human chose one record for all spec reduction. ADR-1047 today says scenario
   pruning is not authorised by it, and the amendment is what authorises it.*
2. **The kind of Story is a new term, *pruning Story*;** no existing *editorial Story* sentence
   changes. *Every definition of that term says no test changes and no seam, and both are false
   here; widening it would reword AGENTS.md, `docs/process.md` §5/§9, the Story template and two
   agent files.*
3. **What is droppable**, for this Story and for ADR-1047 to state. A scenario may be dropped only
   if all four hold: (1) a kept scenario **under the same requirement** asserts everything it
   asserts, literally or through the same code path shown in source; (2) it is not the only test
   whose name states a prohibition; (3) it is not the only scenario varying a clause of its
   requirement's rule; (4) it does not pin a date, week or year boundary. *Chosen so the next
   pruning Story works from a rule, not a re-grill; each clause is one answer below.*
4. **Each dropped scenario's test is deleted in this PR, and no test is added.** The test count
   falls by exactly six. *`check:scenarios` checks scenario → test only, so a test left behind
   would pass unflagged for ever; G7 compares this list against the diff.*
5. **Six scenarios are dropped.** Each with its keeper and the test that goes:
   - `a date before the Gregorian calendar's adoption is not a calendar date` (:128,
     `ScheduleTests.swift:224`) → kept `the last day before the first full Gregorian year is not a
     calendar date` (:133). Both are refused by the one comparison `(1583...9999).contains(year)`,
     `CalendarDate.swift:31`; no path refuses one and not the other.
   - `a weekday-set schedule says its weekdays as three-letter names` (:521,
     `ScheduleTests.swift:4`) → kept `a weekday-set schedule says its weekdays in week order from
     Monday` (:526), which asserts the same "Mon, Wed, Sat". The survey named `every weekday is
     said by its own three-letter name` as keeper; that one never asserts a joined string.
   - `a day-of-month schedule says its day as an ordinal` (:591, `DayOfMonthScheduleTests.swift:4`)
     → kept `every day of the month from the first to the thirty-first is said as its own ordinal`
     (:603), whose exact 31-element list holds "The 25th".
   - `the eleventh, twelfth and thirteenth are said with th and not with st, nd and rd` (:596,
     `DayOfMonthScheduleTests.swift:11`) → the same keeper, which holds all six strings it asserts.
   - `a weekly-quota schedule says its number of times a week` (:625,
     `WeeklyQuotaScheduleTests.swift:4`) → kept `every number of times a week from one to seven is
     said in its own words` (:636), which holds "3x a week".
   - `an every-N-days schedule says its interval in days` (:559, `EveryNDaysScheduleTests.swift:4`)
     → kept `an every-N-days schedule says the same words whatever its start date` (:564), whose
     first case is the same fixture saying "Every 14 days".
6. **Seven candidates are kept.**
   - `a weekly quota of one is due on every date of a week` — the only scenario varying the quota
     number for due-ness, so "MUST NOT consider … how many times the quota asks for" would lose
     its variation (clause 3). Folding it into its keeper was declined: this Story edits no kept
     scenario.
   - `a weekly quota is due on the dates either side of a week boundary`, `… on a leap day`,
     `… across the turn of a year` — each covered by rule, and kept (clause 4). *Recommended was to
     drop the last two; the human kept all three.* *A weekly-quota schedule is due on every date*
     is therefore untouched and keeps its heading.
   - `a weekday set listing every weekday is said as every day` and `an interval of one day is
     said as every day` — their only cover is one compound scenario under a third requirement,
     *A schedule says the rhythm it runs on in words* (clause 1).
   - `a day-of-month schedule does not say the clamp onto a short month` — the only test named for
     that MUST NOT (clause 2).
7. **Five requirements take new headings, reworded as little as keeps them true and distinct**,
   old → new listed side by side in `design.md`: *A calendar date lies within the years the system
   supports*; *A weekday-set schedule is said as its weekdays, in week order from Monday*; *An
   every-N-days schedule is said as its interval, and never as its start date*; *A day-of-month
   schedule is said as the ordinal of its day*; *A weekly-quota schedule is said as a number of
   times a week*. The two in-spec references to them (:69, inside *A calendar date names a day
   that exists*; :623, inside the last of the five) follow in the same delta. *OpenSpec 1.10.0
   refuses a dropped scenario under a kept heading; REMOVED plus ADDED under a new one is the only
   route, and the requirement lands at the end of the spec.*
8. **A reverse coverage check is a backlog want, not this Story's.** Captured with `/atlas idea`
   after G4. It names the two `CommitmentsScreenTests.swift` tests that match no scenario and have
   no spec history ("has never held", "name ends in a newline"). *119 of 1,176 tests match no
   scenario today; 117 of them are orphans on purpose and would need an allowlist.*
9. **B-025's quote of the weekly-quota "said as" heading** (`docs/backlog.md:212`) is updated on
   `chore/backlog` after the archive, in the same pass as the want above. This Story's PR does not
   touch `docs/backlog.md`.
10. **The survey's "nine candidates" are ten.** Its own list names ten titles; the archived
    `condense-schedule-spec` records repeated "nine". This file counts from the list.

## Terms landed in CONTEXT.md

- **Pruning Story** — a Story that drops scenarios another scenario already asserts and deletes
  exactly their tests.

## Left open

None. Every question the frontier raised was answered; items 8 and 9 are scheduled follow-ups
with a place and a time, not undecided questions.
