## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): a carried scenario that is not byte-for-byte what it is today, a rebase conflict in this
folder, in `docs/adr/` or in `openspec/specs/`, or a red test whose fix would reach beyond the one
scenario that failed.

This is a covering Story. Each box in § 3 is one red-green cycle: write the one test named for the
scenario, run it. Green on arrival is accepted. Red is the red: make the least change in
`src/DayByDayKit/Sources/` that turns that one test green, and name it in the PR body
(`design.md` § *A red test is fixed here, and only that*).

## 2. The carried requirements

- [ ] 2.1 `git diff --no-index` of each of the four MODIFIED blocks against the current spec shows only its one appended scenario

## 3. The four scenarios — one test each

- [ ] 3.1 schedules on the twenty-eighth through the thirty-first are all due on the last day of a common February — in `DayOfMonthScheduleTests.swift`; catches a clamp skipping the 28th or 30th
- [ ] 3.2 an every-N-days schedule is still due near the last date the system forms — in `EveryNDaysScheduleTests.swift`; catches a final occurrence
- [ ] 3.3 the first and last dates the system forms are placed on their Gregorian weekdays — in `ScheduleTests.swift`; catches a Julian reading at either end
- [ ] 3.4 a weekday-set and a day-of-month schedule are due on the dates they match at both ends of the supported years — in `EveryNDaysScheduleTests.swift`, beside its requirement's tests; catches an implicit start anchor

## 4. The record

- [ ] 4.1 `docs/open-questions.md` § *Known gaps* gains one new bullet for `schedule` holding every rule in `design.md` § *The unprovable rules*, none dropped and none added, and the payload bullet is untouched

## 5. The gates

- [ ] 5.1 `openspec validate cover-schedule-rules --strict` exits 0, and `pnpm run check:scenarios` exits 0.
- [ ] 5.2 `git diff --stat origin/main -- src/` lists only the three test files named in § 3, or also
      the one source file a red arrival fixed, and that fix is named in the PR body.
- [ ] 5.3 `pnpm run check:budgets` warns about nothing in this folder, and `pnpm run verify` passes.
- [ ] 5.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is four more than a run
      on `main` reports, both read off runs and never derived.
- [ ] 5.5 **The archive handover — `implementer` ticks this in its last commit before the archive**,
      on the evidence that 2.1–5.4 are ticked and that the instruction below is written here for the
      janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of
      the sync it prints, then reads the spec diff it produced: in `openspec/specs/schedule/spec.md`
      exactly four scenarios are added, one at the end of each of the four carried requirements, and
      nothing else moves; `pnpm run checks` runs after the archive commit exists. **Any other drift is
      a stop and a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and
      `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here
      cannot be reached afterwards.
