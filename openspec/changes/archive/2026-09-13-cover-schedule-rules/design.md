## Context

`proposal.md` § *Why* says what this is for, and `grill.md`'s settled answers are what the delta is
written on. `openspec/specs/schedule/spec.md` holds 18 requirements; the delta carries 4 of them
whole, with their 18 existing scenarios verbatim and 4 new ones.

`Schedule.isDue(on:)` answers every due question from `CalendarDate`'s private Gregorian calendar
pinned to UTC; the short-month clamp is `min(day, daysInMonth)`, and an interval is a signed day
count taken modulo the interval, refused below zero. Read in source, all four new scenarios are
expected green on arrival.

A **covering Story** is the lane `CONTEXT.md` defines and ADR-1047 decision 7 records, written by
this change.

## Goals / Non-Goals

**Goals:** each of grill answer 9's four rules gets exactly one scenario that would fail were the
rule broken, plus the test named for it; the lane is stated in ADR-1047; the rules nothing can prove
are recorded under *Known gaps*.

**Non-Goals:** no rule reworded, no scenario dropped or edited, no heading changed, no other
capability. No mutation run (grill preamble). No change to `src/` unless a new test is red on
arrival.

## Decisions

### The seam

No member is new or changed. Every new scenario is driven at shipped members:

```swift
Schedule.isDue(on date: CalendarDate) -> Bool
CalendarDate.init?(year: Int, month: Int, day: Int)
DayOfMonth.init?(day: Int)
DayInterval.init?(days: Int)
```

### One scenario per rule, each built to fail against a named wrong implementation

Grill answers 5, 6 and 9. Each scenario carries a negative AND, so an answer of "always due" fails it.

| Rule (requirement) | New scenario catches |
|---|---|
| 28th–31st share a common February's last day (*A month too short…*) | a clamp applied only past the 28th, or only to the 29th and 31st |
| no final occurrence (*…due on its start date and every interval after it*) | a cap on occurrences or years, or a day count that overflows far forward |
| Gregorian for every accepted date (*The weekday… Gregorian*) | a Julian or hybrid reading at either end: each negative AND is the Julian weekday |
| calendar-anchored shapes match either way (*…not due before its start date*) | an implicit start anchor, which 1583 or 9999 falls outside |

The dates were computed in the proleptic Gregorian calendar: 30 December 9999 is 2,912,199 days
(a multiple of 3) after 31 August 2026; 1 January 1583 is a Saturday and a Julian Tuesday;
31 December 9999 a Friday and a Julian Monday; 3 January 1583 and 27 December 9999 are Mondays.
The implementer re-reads each off the test run, not off this table.

*Not a collision to be resolved* (grill answer 10) is covered by the 28th–31st scenario and gets
none of its own. Rejected: one scenario per shape for the last rule, which grill answer 9 names as
one rule.

### No rule is reworded

Grill answers 3–4 allow a minimal rewording and none is needed: each of the four rules is true as it
stands and a scenario asserts it. *In either direction* is read as earlier or later than any date,
shown at both ends of the supported years. Every MODIFIED block is byte-identical to the current spec
but for the one scenario appended at its end.

### A red test is fixed here, and only that

Grill answers 1–2. Should a new test fail on arrival, that run is rule 3's red, and the fix is the
least code in `src/DayByDayKit/Sources/` that makes that one scenario pass. It is named in the PR
body, and G7 checks nothing else moved. The Story stays a covering Story.

### Pointer sentences skipped

Grill answers 7 and 11. *This requirement SHALL bound the year alone, and the month and the day
SHALL be bounded as …* (*A calendar date is formed only within the years the system supports*)
assigns scope and gets no scenario. Every other sentence deferring to a requirement already sits in
a clause some shipped scenario exercises.

### The unprovable rules, for the *Known gaps* entry

Grill answers 12–15, recorded as one new bullet (not appended to the payload bullet):

- time, time zone, locale and week start: the exclusion clause in each of the five due requirements,
  and rhythm in words "not taken from the device's language, region, locale" — no seam accepts them;
- compiler-enforced: the five "no schedule SHALL be built on / asked about" an out-of-range value,
  "MUST NOT form a date with a component missing", a calendar date's numbers "not writable" and "only
  by forming a new one", and words "the same whatever day asked on / about" and "in every month";
- meaning or consumer: quota "due MUST NOT mean still outstanding", "week complete MUST be decided
  from tick records", "seven SHALL mean one completion each day", words "whether or not any
  commitment carries it";
- an interval at `Int.max` not lost to overflow: shown only at 4,000,000.

### The lane is ADR-1047 decision 7

Grill answer 8. Amended in place: the covering Story is defined with answers 1–7, and decision 1's
owed budget review stays with the first Story that is neither editorial, pruning nor covering.
Rejected: a new ADR, since ADR-1047 holds every rule for reshaping a spec's scenarios.

## Risks / Trade-offs

- **A scenario that only visits its case** passes as cover. → Each table row names the wrong
  implementation it catches, and `reviewer` reads each test against that row at G7.
- **A far-date fixture that is wrong by a day** makes a test red for the wrong reason. → A red
  arrival is diagnosed against the dates above before any `src/` edit.
- **A carried block drifting from the current spec** changes a rule silently. → `tasks.md` § 2 is
  ticked only after a diff shows the four added scenarios are the only lines that differ.

## Open Questions

None. `grill.md` § *Left open* is "None.", the four rules and every exclusion are settled, and no
residual round was raised: writing the delta turned up no question the grill did not answer.
