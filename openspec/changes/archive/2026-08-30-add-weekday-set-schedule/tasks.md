## 1. The package and the seam

- [x] 1.1 Add `.build/` and `.swiftpm/` to `.gitignore`; verify with `git status --porcelain`
  after task 1.2 that no build product is listed. This is the one task here that writes outside
  `src/**` — if that scope is binding for you, stop and hand this line to the conductor rather
  than widening it yourself (`AGENTS.md` rule 6 and `design.md` § *Risks*).
- [x] 1.2 Create the package at `src/DayByDayKit/`: `Package.swift` with
  `// swift-tools-version: 6.3`, library target `DayByDayKit`, test target `DayByDayKitTests`,
  `swiftLanguageModes: [.v6]`, no platform requirement and no dependency. That is the order
  `Package(...)` requires as well as the order they are listed in here — see `design.md`
  § *Context*. Verify with `cd src/DayByDayKit && swift build` exiting 0.
- [x] 1.3 Declare the public surface exactly as `design.md` § *The seam* gives it — `Weekday`,
  `CalendarDate` with its failable initializer, `Schedule` with its one case, and
  `isDue(on:)` whose body is `fatalError("not implemented")`. Nothing else public; `CalendarDate`'s
  weekday stays internal. Verify with `cd src/DayByDayKit && swift build` exiting 0. The seam
  exists before any test does.
- [x] 1.4 Add `Tests/DayByDayKitTests/ScheduleTests.swift` importing `Testing` and `DayByDayKit`,
  with no test in it yet. Verify with `cd src/DayByDayKit && swift test` running and reporting no
  failures, and with `pnpm run check:scenarios` reporting `0/11` covered and naming
  `"a date on a listed weekday is due"` as next. Eleven was the whole delta when this box was
  ticked; the G7 amendment took it to nineteen, so the same command run from a clean start today
  reads `0/19`.

## 2. Scenarios — one acceptance test each, in delta order

Each task below takes exactly one `#### Scenario:` from `specs/schedule/spec.md` and writes one
acceptance test in `Tests/DayByDayKitTests/ScheduleTests.swift` whose `@Test("...")` display name
is that scenario title verbatim, then makes it pass with the smallest change that does. Never write
two of these before the first is green (`AGENTS.md` rule 3). Verify each with
`cd src/DayByDayKit && swift test`: the named test green, and every earlier test still green.

**Two of the eleven ran red before their implementation, and nine did not.** The record says so
because it is true and because the branch shows it: only 2.1 and 2.8 are followed by a commit that
changes anything under `Sources/`, and the other nine commits touch the test file alone. Those nine
tests passed the moment they were written. That is not a shortcut taken — the smallest change that
turns 2.1 green already answers every question about weekday membership, and the smallest change
that turns 2.8 green already refuses every combination that names no day; neither could have been
made smaller without being fake. It does mean the nine are regression pins on behaviour that had
already generalised rather than proofs that a requirement was unmet, and describing them as
red-green cycles would put a claim in the archive that the commits contradict.

- [x] 2.1 `a date on a listed weekday is due` — one of the two that ran red.
- [x] 2.2 `a date on an unlisted weekday is not due`
- [x] 2.3 `a schedule listing every weekday is due on seven consecutive dates`
- [x] 2.4 `a schedule listing no weekday is due on none of seven consecutive dates`
- [x] 2.5 `a Sunday-only schedule is due on Sunday and not on Saturday`
- [x] 2.6 `a leap day is placed on its Gregorian weekday`
- [x] 2.7 `the first day of a year is placed on its Gregorian weekday`
- [x] 2.8 `a day beyond the end of its month is not a calendar date` — the other of the two that
  ran red. Its second assertion, that 2 March 2026 was not formed in its place, is strictly
  subsumed by the `== nil` assertion on the line above and cannot fail on its own: once the date is
  nil it is unequal to every date that is not. It documents the Foundation rolling behaviour
  recorded in `design.md` § *Context*; it does not check it.
- [x] 2.9 `the twenty-ninth of February in a common year is not a calendar date`
- [x] 2.10 `the twenty-ninth of February in a leap year is a calendar date`
- [x] 2.11 `a month outside the twelve is not a calendar date` — its 1 January 2027 assertion is
  subsumed the same way, and is documentation for the same reason.

**Tasks 2.12 to 2.19 are the G7 amendment, and none of them is a red-green cycle.** The bounds
guard that closed the two G7 findings already ships; what was missing was the delta authorising it,
which is now the third requirement's last three scenarios and the whole of the fourth. Six tests
covering that ground already exist in `Tests/DayByDayKitTests/ScheduleTests.swift` under
descriptive names, below a comment calling them hardening tests. Each task below gives one of them
its scenario title — the `@Test("...")` display name only, since every body already asserts exactly
what its scenario says — except 2.16 and 2.18, which need tests that do not exist yet and which
will be green the moment they are written. Delete that hardening-test comment as the last name
changes: there is no hardening block left underneath it.

- [x] 2.12 `a month of the largest representable integer is not a calendar date` — rename
  `"a month of Int.max is refused rather than read back as unset"`.
- [x] 2.13 `a year of the largest representable integer is not a calendar date` — rename
  `"a year of Int.max is refused rather than read back as unset"`.
- [x] 2.14 `a day of the largest representable integer is not a calendar date` — rename
  `"a day of Int.max is refused rather than read back as unset"`.
- [x] 2.15 `a date before the Gregorian calendar's adoption is not a calendar date` — the existing
  test already carries this title verbatim. Confirm the whole set with `pnpm run check:scenarios`
  rather than by eye; nothing to edit here.
- [x] 2.16 `the last day before the first full Gregorian year is not a calendar date` — a new test:
  `CalendarDate(year: 1582, month: 12, day: 31)` is nil. The shipped guard refuses it, so expect
  green on the first run; this is a pin, not a cycle. Write it anyway: without it the pinned pair
  either side of the lower bound is 1500 refused and 1583 accepted, and a guard mistyped as
  `1581...` would satisfy both. **The scenario was retitled after this box was ticked** and the
  test still carries the old title — see 2.20.
- [x] 2.17 `the first day of the first full Gregorian year is a calendar date` — the existing test
  already carries this title verbatim. Nothing to edit.
- [x] 2.18 `the last day of the last supported year is a calendar date` — a new test:
  `CalendarDate(year: 9999, month: 12, day: 31)` is not nil. The shipped guard accepts it, so
  expect green on the first run. Write it anyway: the upper bound has no test that accepts, so a
  guard tightened by mistake would refuse a supported year and no test would notice.
- [x] 2.19 `a year past the last supported year is not a calendar date` — rename
  `"a year past the upper bound is not a calendar date"`.
- [x] 2.20 `the last day before the first full Gregorian year is not a calendar date` — rename
  `"the last year before the Gregorian reform is not a calendar date"` at
  `ScheduleTests.swift:150`, and rename its function to match. The assertion and the comment above
  it are already right and do not change. The old title was factually wrong: the Gregorian reform
  fell on 15 October 1582, so 1582 is not a year before the reform, and the date the test uses —
  31 December 1582 — is seventy-eight days after it. The corrected title says what the date is,
  the last day before the first year that is Gregorian throughout. Verify with
  `pnpm run check:scenarios` reporting 19 of 19.

## 3. Gates

- [x] 3.1 `cd src/DayByDayKit && swift test` reports 11 tests passing and no failures, and
  `pnpm run verify` exits 0 (the TypeScript half is unaffected and must stay green). Both counts
  are as this box was ticked, before G7; 3.4 re-verifies them against the amended delta.
- [x] 3.2 `pnpm exec openspec validate add-weekday-set-schedule --strict` exits 0, and
  `pnpm run checks` reports scenario coverage as 11 of 11 with a matching title for each. Eleven
  was the whole delta at that point; 3.5 is the same check against nineteen.
- [x] 3.3 `/code-review` reports nothing unresolved on either axis (**G7**).
- [x] 3.4 After tasks 2.12 to 2.19: `cd src/DayByDayKit && swift test` reports 19 tests passing and
  no failures, and `pnpm run verify` exits 0.
- [x] 3.5 `pnpm exec openspec validate add-weekday-set-schedule --strict` exits 0, and
  `pnpm run checks` reports scenario coverage as 19 of 19 with a matching title for each. True when
  this box was ticked. The re-review then corrected one scenario title, so coverage reads 18 of 19
  until task 2.20 lands; 3.6 is the same check afterwards.
- [x] 3.6 After task 2.20: `pnpm run checks` reports scenario coverage as 19 of 19 again, and
  `cd src/DayByDayKit && swift test` still reports 19 tests passing and no failures.

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7,
and `openspec validate --archived` requires every box above to be ticked before it.
