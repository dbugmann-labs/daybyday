## Context

`proposal.md` § *Why* says what this is for, and `grill.md`'s settled answers are what the delta is
written on. `openspec/specs/schedule/spec.md` holds 18 requirements and 78 scenarios today; the delta
carries 6 requirements and 22 scenarios, and drops 6.

ADR-1047 decision 2 records what `openspec` 1.10.0's archiver accepts: a MODIFIED block omitting a
current scenario is refused, the same heading under REMOVED and ADDED is refused, and so is a RENAMED
plus MODIFIED pair omitting one. REMOVED plus ADDED under a new heading is accepted, and the added
requirement lands at the end of the spec file. `pnpm run check:scenarios` reads scenario → test only,
so a test whose scenario is gone passes every check.

## Goals / Non-Goals

**Goals:** the six scenarios grill answer 5 names and their six tests gone, with everything each
asserted still asserted by its keeper; the rule for what may be dropped stated in ADR-1047.

**Non-Goals:** no prose change beyond the two cross-references; no kept scenario edited, folded or
renamed; no test added, and no kept test edited but for the one comment the deletions make false
(grill answer 13); no other capability. The reverse coverage want (grill answer 8) and
B-025's quote of a renamed heading (grill answer 9) go to `chore/backlog` after the archive.

## Decisions

### The seam

No member is new or changed, which is what makes this a *pruning Story* and not a behaviour Story.
Every scenario the delta carries is already driven at one of two shipped members by a test carrying
its title verbatim, and each goes on passing there. Rule 3's loop has no red: the work is deletion,
and one comment on a kept test.

```swift
CalendarDate.init?(year: Int, month: Int, day: Int)
Schedule.inWords: String
```

### Six scenarios are dropped, each against a keeper under the same requirement

Grill answers 4 and 5. Each test named for a dropped scenario is deleted in this change; none is added.

| Dropped | Keeper, which asserts the same | Test file |
|---|---|---|
| a date before the Gregorian calendar's adoption is not a calendar date | the last day before the first full Gregorian year is not a calendar date | `ScheduleTests.swift` |
| a weekday-set schedule says its weekdays as three-letter names | a weekday-set schedule says its weekdays in week order from Monday | `ScheduleTests.swift` |
| a day-of-month schedule says its day as an ordinal | every day of the month from the first to the thirty-first is said as its own ordinal | `DayOfMonthScheduleTests.swift` |
| the eleventh, twelfth and thirteenth are said with th and not with st, nd and rd | the same keeper | `DayOfMonthScheduleTests.swift` |
| a weekly-quota schedule says its number of times a week | every number of times a week from one to seven is said in its own words | `WeeklyQuotaScheduleTests.swift` |
| an every-N-days schedule says its interval in days | an every-N-days schedule says the same words whatever its start date | `EveryNDaysScheduleTests.swift` |

1500 and 1582 are refused by the one guard `(1583...9999).contains(year)` in `CalendarDate.swift`,
with no path refusing one and not the other. The weekday keeper asserts "Mon, Wed, Sat" of the same
three days; the ordinal keeper's 31-element list holds "The 25th" and all six strings the second
day-of-month test asserts; the quota keeper's list holds "3x a week"; the interval keeper's first
case is the same fixture saying "Every 14 days". Rejected: the survey's weekday keeper, *every weekday
is said by its own three-letter name*, which never asserts a joined string; leaving the tests in place,
which no check would ever flag.

Conditions 2–4 hold for all six. Two titles contain "not", and neither is named for a MUST NOT:
refusing a year before 1583 is a SHALL its keeper is named for too, and *the eleventh, twelfth and
thirteenth are said with th and not with st, nd and rd* sits under a requirement whose only MUST NOT
is the clamp, whose test is kept (grill answer 11). None is the only scenario varying a clause, and
none pins a boundary: 1582, not 1500, is the pin below the year range. The keeper's test comment,
which cites the 1500 case, is corrected with no assertion changed (grill answer 13).

### What may be dropped is ADR-1047 decision 6

Grill answers 1–3 and 11. A scenario may be dropped only if all four hold: a kept scenario under the
same requirement asserts everything it asserts, literally or through the same code path shown in
source; it is not the only test named for a prohibition its requirement states as a MUST NOT; it is
not the only scenario varying a clause of its requirement's rule; and it does not pin a date, week or
year boundary. The amendment also names the lane, the test deletion and the heading mechanism, brings
decision 5 into line, and has decision 1 owe the budget review to the first behaviour Story rather
than to this Story's G7 (grill answer 12). Rejected: a new ADR; widening *editorial
Story*, every definition of which says no test changes.

### Seven candidates are kept

Grill answer 6. *A weekly quota of one is due on every date of a week* is the only scenario varying
the quota number for due-ness (condition 3). *… either side of a week boundary*, *… on a leap day* and
*… across the turn of a year* each pin a boundary (condition 4), so *A weekly-quota schedule is due on
every date* is untouched. *A weekday set listing every weekday is said as every day* and *an interval
of one day is said as every day* are covered only under a third requirement (condition 1). *A
day-of-month schedule does not say the clamp onto a short month* is the only test named for that MUST
NOT (condition 2). Rejected: folding the quota of one into its keeper, since no kept scenario is edited.

### Five headings are reworded, and the two references to them follow

Grill answer 7. Each heading is changed as little as keeps it true and distinct from the one removed:

| Removed | Added |
|---|---|
| A calendar date lies within the years the system supports | A calendar date is formed only within the years the system supports |
| A weekday-set schedule is said as its weekdays, in week order from Monday | A weekday-set schedule is said as the weekdays it lists, in week order from Monday |
| An every-N-days schedule is said as its interval, and never as its start date | An every-N-days schedule is said as its interval of days, and never as its start date |
| A day-of-month schedule is said as the ordinal of its day | A day-of-month schedule is said as the ordinal of its day of the month |
| A weekly-quota schedule is said as a number of times a week | A weekly-quota schedule is said as its number of times a week |

The reference in *A calendar date names a day that exists* makes that requirement MODIFIED, carried
whole with one clause changed; the other sits inside the added weekly-quota block. Searched with line
breaks ignored, no tracked file outside the archive quotes a removed heading but `docs/backlog.md`,
which grill answer 9 leaves out of this change. Rejected: RENAMED, refused as ADR-1047 decision 2 says.

## Risks / Trade-offs

- **A keeper that does not assert what it is said to** loses a rule no check sees. → A `tasks.md` § 2
  box is ticked only once its keeper's own `#expect` has been read for the dropped value, and `reviewer`
  compares the table above against the diff at G7.
- **A test left behind, or the wrong one deleted**, passes `check:scenarios`. → The gates search for
  all six titles under `src/` and read the test count off a run on this branch and on `main`.
- **Five requirements move to the end of the spec file**, so the year range no longer sits beside the
  requirement it defers to. → Accepted at the grill; the cross-reference names it either way.

## Open Questions

None. `grill.md` § *Left open* is "None.", every survey candidate has a settled answer, and the new
headings were the only choice left to this change, made to the rule grill answer 7 set. The residual
round of three raised after a verifier read this folder is settled in grill answers 11–13 and folded
in above: condition 2's reading, which Story's G7 owes the budget review, and the stale comment.
