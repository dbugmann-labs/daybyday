## 1. The public surface

- [x] 1.1 Add `Sources/DayByDayKit/DayInterval.swift` declaring `public struct DayInterval: Hashable,
  Sendable` with `public init?(days: Int)` exactly as `design.md` § *The seam* gives it, its body
  `fatalError("not implemented")`. Nothing else public, and `days` internal, matching `DayOfMonth`.
  Verify with `cd src/DayByDayKit && swift build` exiting 0.
- [x] 1.2 Add `case everyNDays(DayInterval, from: CalendarDate)` to `Schedule` and a branch for it in
  `isDue(on:)` whose body is `fatalError("not implemented")`. The seam's signature does not change.
  Verify with `cd src/DayByDayKit && swift build` exiting 0 and `swift test` still reporting the
  thirty-one tests from #8 and #9 passing.
- [x] 1.3 Confirm the starting point before writing a test: `pnpm run check:scenarios` reports
  `0/14 covered` for this change and names `"a schedule is due on its start date"` as next.

## 2. Scenarios — one acceptance test each, in delta order

Each task takes exactly one `#### Scenario:` from `specs/schedule/spec.md` and writes one acceptance
test whose `@Test("...")` display name is that scenario title verbatim, then makes it pass with the
smallest change that does. Never write two before the first is green (`AGENTS.md` rule 3). Put them
in a new `Tests/DayByDayKitTests/EveryNDaysScheduleTests.swift` rather than appending to
`ScheduleTests.swift` or `DayOfMonthScheduleTests.swift`, both of which are a different rule shape.
Verify each with `cd src/DayByDayKit && swift test`: the named test green, every earlier test still
green.

Expect most of these to pin rather than drive, as on #8 and #9 — the smallest honest change that
turns 2.1 green already answers a good deal of the shape. Record which ones actually ran red as you
go, in this file, the way #9's `tasks.md` did; a prediction here is not evidence.

- [ ] 2.1 `a schedule is due on its start date`
- [ ] 2.2 `a date one interval after the start date is due`
- [ ] 2.3 `a date between two due dates is not due`
- [ ] 2.4 `an every-N-days schedule is due on exactly five dates across a fortnight`
- [ ] 2.5 `the interval counts across the end of a month`
- [ ] 2.6 `the interval counts a leap day as a day`
- [ ] 2.7 `the interval counts across the turn of a year`
- [ ] 2.8 `an interval of one day is due on every date`
- [ ] 2.9 `an interval longer than the supported years is due only on its start date` — the one place
  the arithmetic can go wrong catastrophically rather than subtly. `design.md` measures the whole
  supported span at 3,074,245 days, so a remainder against any `Int` interval is safe; an
  implementation that instead steps forward from the start date one interval at a time will hang here
  rather than fail, which is the point of the scenario.
- [ ] 2.10 `a date a whole interval before the start date is not due`
- [ ] 2.11 `an every-N-days schedule is due on none of the seven dates before its start date`
- [ ] 2.12 `an interval of no days is not an interval`
- [ ] 2.13 `an interval of a negative number of days is not an interval`
- [ ] 2.14 `an interval of one day is an interval`

## 3. Gates

- [ ] 3.1 `cd src/DayByDayKit && swift test` reports 45 tests passing and no failures — the fourteen
  here plus the thirty-one from #8 and #9, none of which may change — and `pnpm run verify` exits 0.
- [ ] 3.2 `pnpm exec openspec validate add-every-n-days-schedule --strict` exits 0 and
  `pnpm run checks` reports scenario coverage as 14 of 14.
- [ ] 3.3 `/code-review` reports nothing unresolved on either axis (**G7**).

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7, and
`openspec validate --archived` requires every box above to be ticked before it.
