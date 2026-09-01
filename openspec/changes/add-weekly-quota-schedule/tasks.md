## 1. The public surface

- [ ] 1.1 Add `Sources/DayByDayKit/WeeklyQuota.swift` declaring `public struct WeeklyQuota: Hashable,
  Sendable` with `public init?(times: Int)` exactly as `design.md` § *The seam* gives it, its body
  `fatalError("not implemented")`. Nothing else public, and the stored count internal, matching
  `DayOfMonth` and `DayInterval`. Verify with `cd src/DayByDayKit && swift build` exiting 0.
- [ ] 1.2 Add `case timesPerWeek(WeeklyQuota)` to `Schedule` and a branch for it in `isDue(on:)`
  whose body is `fatalError("not implemented")`. The seam's signature does not change. Verify with
  `cd src/DayByDayKit && swift build` exiting 0 and `swift test` still reporting the forty-five
  tests from #8, #9 and #10 passing.
- [ ] 1.3 Confirm the starting point before writing a test: `pnpm run check:scenarios` reports
  `0/9 covered` for this change and names `"a weekly quota is due on every one of seven consecutive
  dates"` as next.

## 2. Scenarios — one acceptance test each, in delta order

Each task takes exactly one `#### Scenario:` from `specs/schedule/spec.md` and writes one acceptance
test whose `@Test("...")` display name is that scenario title verbatim, then makes it pass with the
smallest change that does. Never write two before the first is green (`AGENTS.md` rule 3). Put them
in a new `Tests/DayByDayKitTests/WeeklyQuotaScheduleTests.swift` rather than appending to any of the
three existing files, each of which is a different rule shape.

Expect nearly all of these to pin rather than drive — more so than on #8, #9 or #10, because the
branch under test returns a constant. The one that can genuinely run red is 2.1, and the validity
tasks in 2.6 through 2.9 drive the guard. Record which ones actually ran red as you go, in this
file, the way #9's and #10's `tasks.md` did; a prediction here is not evidence. Verify each with
`cd src/DayByDayKit && swift test`: the named test green, every earlier test still green.

- [ ] 2.1 `a weekly quota is due on every one of seven consecutive dates`
- [ ] 2.2 `a quota of one and a quota of seven are due on the same seven dates` — the regression pin
  on `design.md` § *The count does not reach the predicate*. It is the test that fails first if a
  later change lets the count into the answer, so write it as two schedules compared date by date,
  not as two separate assertions that happen to agree.
- [ ] 2.3 `a weekly quota is due on a date that a weekday set of the same size would miss` — the
  only test in this change that constructs a schedule of another shape. That is deliberate: it
  states the difference between the two shapes at the seam rather than in prose.
- [ ] 2.4 `a weekly quota is due on the leap day of a leap year`
- [ ] 2.5 `a weekly quota is due on the first and the last date the system forms` — 1 January 1583
  and 31 December 9999. Catches an implementation that grows a bound of its own.
- [ ] 2.6 `a quota of three completions a week is a weekly quota`
- [ ] 2.7 `a quota of seven completions a week is a weekly quota` — the top of the range, so the
  guard must be inclusive.
- [ ] 2.8 `a quota above seven completions a week is not a weekly quota`
- [ ] 2.9 `a quota of no completions a week is not a weekly quota`

## 3. Gates

- [ ] 3.1 `cd src/DayByDayKit && swift test` reports 54 tests passing and no failures — the nine here
  plus the forty-five from #8, #9 and #10, none of which may change — and `pnpm run verify` exits 0.
- [ ] 3.2 `pnpm exec openspec validate add-weekly-quota-schedule --strict` exits 0 and
  `pnpm run checks` reports scenario coverage as 9 of 9.
- [ ] 3.3 `/code-review` reports nothing unresolved on either axis (**G7**).

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7, and
`openspec validate --archived` requires every box above to be ticked before it.
