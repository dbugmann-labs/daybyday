## 1. The package and the seam

- [ ] 1.1 Add `.build/` and `.swiftpm/` to `.gitignore`; verify with `git status --porcelain`
  after task 1.2 that no build product is listed. This is the one task here that writes outside
  `src/**` — if that scope is binding for you, stop and hand this line to the conductor rather
  than widening it yourself (`AGENTS.md` rule 6 and `design.md` § *Risks*).
- [x] 1.2 Create the package at `src/DayByDayKit/`: `Package.swift` with
  `// swift-tools-version: 6.3`, `swiftLanguageModes: [.v6]`, library target `DayByDayKit` and
  test target `DayByDayKitTests`, no platform requirement and no dependency. Verify with
  `cd src/DayByDayKit && swift build` exiting 0.
- [x] 1.3 Declare the public surface exactly as `design.md` § *The seam* gives it — `Weekday`,
  `CalendarDate` with its failable initializer, `Schedule` with its one case, and
  `isDue(on:)` whose body is `fatalError("not implemented")`. Nothing else public; `CalendarDate`'s
  weekday stays internal. Verify with `cd src/DayByDayKit && swift build` exiting 0. The seam
  exists before any test does.
- [x] 1.4 Add `Tests/DayByDayKitTests/ScheduleTests.swift` importing `Testing` and `DayByDayKit`,
  with no test in it yet. Verify with `cd src/DayByDayKit && swift test` running and reporting no
  failures, and with `pnpm run check:scenarios` reporting `0/11` covered and naming
  `"a date on a listed weekday is due"` as next.

## 2. Scenarios — one red-green cycle each, in delta order

Each task below takes exactly one `#### Scenario:` from `specs/schedule/spec.md`, writes one
acceptance test in `Tests/DayByDayKitTests/ScheduleTests.swift` whose `@Test("...")` display name
is that scenario title verbatim, watches it fail for the right reason, then makes it pass with the
smallest change that does. Never write two of these before the first is green (`AGENTS.md` rule 3).
Verify each with `cd src/DayByDayKit && swift test`: the named test red before the implementation,
green after, and every earlier test still green.

- [x] 2.1 `a date on a listed weekday is due`
- [x] 2.2 `a date on an unlisted weekday is not due`
- [x] 2.3 `a schedule listing every weekday is due on seven consecutive dates`
- [ ] 2.4 `a schedule listing no weekday is due on none of seven consecutive dates`
- [ ] 2.5 `a Sunday-only schedule is due on Sunday and not on Saturday`
- [ ] 2.6 `a leap day is placed on its Gregorian weekday`
- [ ] 2.7 `the first day of a year is placed on its Gregorian weekday`
- [ ] 2.8 `a day beyond the end of its month is not a calendar date` — the assertion that
  2 March 2026 was not formed in its place is part of the test, not decoration: it is the
  Foundation rolling behaviour recorded in `design.md` § *Context*.
- [ ] 2.9 `the twenty-ninth of February in a common year is not a calendar date`
- [ ] 2.10 `the twenty-ninth of February in a leap year is a calendar date`
- [ ] 2.11 `a month outside the twelve is not a calendar date` — likewise assert that
  1 January 2027 was not formed in its place.

## 3. Gates

- [ ] 3.1 `cd src/DayByDayKit && swift test` reports 11 tests passing and no failures, and
  `pnpm run verify` exits 0 (the TypeScript half is unaffected and must stay green).
- [ ] 3.2 `pnpm exec openspec validate add-weekday-set-schedule --strict` exits 0, and
  `pnpm run checks` reports scenario coverage as 11 of 11 with a matching title for each.
- [ ] 3.3 `/code-review` reports nothing unresolved on either axis (**G7**).

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7,
and `openspec validate --archived` requires every box above to be ticked before it.
