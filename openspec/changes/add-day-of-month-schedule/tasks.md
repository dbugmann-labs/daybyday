## 1. The public surface

- [ ] 1.1 Add `Sources/DayByDayKit/DayOfMonth.swift` declaring `public struct DayOfMonth: Hashable,
  Sendable` with `public init?(day: Int)` exactly as `design.md` § *The seam* gives it, its body
  `fatalError("not implemented")`. Nothing else public. Verify with
  `cd src/DayByDayKit && swift build` exiting 0.
- [ ] 1.2 Add `case dayOfMonth(DayOfMonth)` to `Schedule` and a branch for it in `isDue(on:)` whose
  body is `fatalError("not implemented")`. The seam's signature does not change. Verify with
  `cd src/DayByDayKit && swift build` exiting 0 and `swift test` still reporting the nineteen tests
  from #8 passing.
- [ ] 1.3 Confirm the starting point before writing a test: `pnpm run check:scenarios` reports
  `0/12 covered` for this change and names `"a date on the scheduled day of the month is due"` as
  next.

## 2. Scenarios — one acceptance test each, in delta order

Each task takes exactly one `#### Scenario:` from `specs/schedule/spec.md` and writes one
acceptance test whose `@Test("...")` display name is that scenario title verbatim, then makes it
pass with the smallest change that does. Never write two before the first is green (`AGENTS.md`
rule 3). Put them in a new `Tests/DayByDayKitTests/DayOfMonthScheduleTests.swift` rather than
appending to `ScheduleTests.swift`, which is already nineteen tests of a different rule shape.
Verify each with `cd src/DayByDayKit && swift test`: the named test green, every earlier test still
green.

Expect 2.1, 2.5 and 2.10 to run red and the rest to be pins on behaviour that has already
generalised — the smallest change that turns 2.1 green answers plain membership, the smallest that
turns 2.5 green answers every short month, and the smallest that turns 2.10 green refuses every
out-of-range number. Record honestly in this file which ones actually ran red rather than
describing all twelve as cycles; #8's `tasks.md` is the precedent.

- [ ] 2.1 `a date on the scheduled day of the month is due`
- [ ] 2.2 `a date on another day of the same month is not due`
- [ ] 2.3 `a day-of-month schedule is due on exactly one date across a whole month`
- [ ] 2.4 `a schedule on the first is due on the first of a month and not on the last day of the month before`
- [ ] 2.5 `a schedule on the thirty-first is due on the last day of a thirty-day month`
- [ ] 2.6 `a schedule on the thirty-first is due on the last day of a common February`
- [ ] 2.7 `a schedule on the thirty-first is due on the leap day of a leap February`
- [ ] 2.8 `a schedule on the twenty-ninth is due on the last day of a common February`
- [ ] 2.9 `a schedule on the thirty-first is not moved in a month that has a thirty-first`
- [ ] 2.10 `a day of the month past the thirty-first is not a day of the month`
- [ ] 2.11 `a day of the month below the first is not a day of the month`
- [ ] 2.12 `the thirty-first is a day of the month`

## 3. Gates

- [ ] 3.1 `cd src/DayByDayKit && swift test` reports 31 tests passing and no failures — the twelve
  here plus the nineteen from #8, none of which may change — and `pnpm run verify` exits 0.
- [ ] 3.2 `pnpm exec openspec validate add-day-of-month-schedule --strict` exits 0 and
  `pnpm run checks` reports scenario coverage as 12 of 12.
- [ ] 3.3 `/code-review` reports nothing unresolved on either axis (**G7**).

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7,
and `openspec validate --archived` requires every box above to be ticked before it.
