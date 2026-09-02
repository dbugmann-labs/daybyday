## 1. The public surface

- [x] 1.1 Add `Sources/DayByDayKit/WeeklyQuota.swift` declaring `public struct WeeklyQuota: Hashable,
  Sendable` with `public init?(timesPerWeek: Int)` exactly as `design.md` § *The seam* gives it, its
  body `fatalError("not implemented")`. Nothing else public; the stored `timesPerWeek` stays
  internal, matching `DayOfMonth.day` and `DayInterval.days`. Verify with
  `cd src/DayByDayKit && swift build` exiting 0.
- [x] 1.2 Add `case weeklyQuota(WeeklyQuota)` to `Schedule` and a branch for it in `isDue(on:)` whose
  body is `fatalError("not implemented")`. The seam's signature does not change. Verify with
  `cd src/DayByDayKit && swift build` exiting 0 and `swift test` still reporting the 64 tests from
  #8, #9, #10 and #42 passing.
- [x] 1.3 Confirm the starting point before writing a test: `pnpm run check:scenarios` reports
  `0/10 covered` for this change and names `"a weekly quota is due on every date of a week"` as
  next.

## 2. Scenarios — one acceptance test each, in delta order

Each task takes exactly one `#### Scenario:` from `specs/schedule/spec.md` and writes one acceptance
test whose `@Test("...")` display name is that scenario title verbatim, then makes it pass with the
smallest change that does. Never write two before the first is green (`AGENTS.md` rule 3). Put them
in a new `Tests/DayByDayKitTests/WeeklyQuotaScheduleTests.swift` rather than appending to an existing
file, following the precedent #9 and #10 set.  Verify each with `cd src/DayByDayKit && swift test`:
the named test green, every earlier test still green.

**Expect two of the ten to run red, and eight to pass the moment they are written.** This is
predicted here rather than discovered later, because #9's task list made the opposite prediction and
had to record that it was wrong. The smallest change that turns 2.1 green is `return true`, which
answers every other due-ness scenario at once; the smallest change that turns 2.7 green is the
`1...7` guard, which refuses 8 and admits 1 and 7 at the same time. The remaining eight are
regression pins — four of them on calendar boundaries where a future implementation that starts
consulting the calendar would break — and not proofs that a requirement was unmet. If one of the
eight does run red, that is a finding worth reporting, not a task that went well.

- [x] 2.1 `a weekly quota is due on every date of a week` — expected to run red.
- [x] 2.2 `a weekly quota of one is due on every date of a week`
- [x] 2.3 `a weekly quota is due on the dates either side of a week boundary`
- [x] 2.4 `a weekly quota is due on a leap day`
- [x] 2.5 `a weekly quota is due across the turn of a year`
- [x] 2.6 `a weekly quota is due on the first and last dates the system forms`
- [x] 2.7 `a quota below one time a week is not a weekly quota` — expected to run red.
- [x] 2.8 `a quota of more times a week than the week has days is not a weekly quota`
- [x] 2.9 `one time a week is a weekly quota`
- [x] 2.10 `seven times a week is a weekly quota`

## 3. Gates

- [ ] 3.1 `cd src/DayByDayKit && swift test` reports 74 tests passing and no failures — the ten here
  plus the 64 from #8, #9, #10 and #42, none of which may change — and `pnpm run verify` exits 0.
- [ ] 3.2 `pnpm exec openspec validate add-weekly-quota-schedule --strict` exits 0 and
  `pnpm run checks` reports scenario coverage as 10 of 10.
- [ ] 3.3 `/code-review` reports nothing unresolved on either axis (**G7**).

`docs/adr/1014-a-weekly-quota-is-due-every-day.md` is **not** a task here. It was written at Stage 4
with the rest of this folder and needs no further edit — `docs/adr/**` is the spec-author's to write
and not the implementer's, and the ADR is accepted by the same G4 signature that approves this
change folder.

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7, and
`openspec validate --archived` requires every box above to be ticked before it.
