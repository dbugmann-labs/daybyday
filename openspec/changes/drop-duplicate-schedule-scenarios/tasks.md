## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): the archiver refusing a block, a keeper test that does not assert what `design.md` says it
does, a carried scenario that is not byte-for-byte what it is today, or a rebase conflict in this
folder, in `docs/adr/` or in `openspec/specs/`.

This is a pruning Story: no test is written, and the one edit to a kept test is 2.7's comment, so
rule 3's loop has no red. Each of 2.1–2.6 is one deletion, ticked only once the keeper `design.md`
names for it has been read and its own `#expect` holds every value the deleted test asserted. § 3 is one box per carried requirement rather
than per scenario, because no carried scenario has work of its own: each is ticked when that
requirement's prose and scenarios are byte-for-byte the current spec's, except the one cross-reference
its line names, and no test under it is touched.

## 2. The six deletions — one box per dropped scenario, and the comment they make false

- [ ] 2.1 Delete `a date before the Gregorian calendar's adoption is not a calendar date` from `ScheduleTests.swift` — its keeper refuses 1582 through the same year guard
- [ ] 2.2 Delete `a weekday-set schedule says its weekdays as three-letter names` from `ScheduleTests.swift` — the keeper is the week-order test, not the one-name-each test
- [ ] 2.3 Delete `a day-of-month schedule says its day as an ordinal` from `DayOfMonthScheduleTests.swift`
- [ ] 2.4 Delete `the eleventh, twelfth and thirteenth are said with th and not with st, nd and rd` from `DayOfMonthScheduleTests.swift` — the 1st-to-31st list holds all six strings
- [ ] 2.5 Delete `a weekly-quota schedule says its number of times a week` from `WeeklyQuotaScheduleTests.swift`
- [ ] 2.6 Delete `an every-N-days schedule says its interval in days` from `EveryNDaysScheduleTests.swift` — the keeper's first case is the same fixture
- [ ] 2.7 Correct the comment on `the last day before the first full Gregorian year is not a calendar date` in `ScheduleTests.swift` so it no longer cites the 1500 case 2.1 deletes — comment only, no assertion changed

## 3. The carried requirements — one box per requirement in the delta

- [ ] 3.1 *A calendar date names a day that exists* — only its reference to the renamed year range differs
- [ ] 3.2 *A calendar date is formed only within the years the system supports* — no reference differs
- [ ] 3.3 *A weekday-set schedule is said as the weekdays it lists, in week order from Monday* — no reference differs
- [ ] 3.4 *An every-N-days schedule is said as its interval of days, and never as its start date* — no reference differs
- [ ] 3.5 *A day-of-month schedule is said as the ordinal of its day of the month* — the clamp MUST NOT test stays
- [ ] 3.6 *A weekly-quota schedule is said as its number of times a week* — only its reference to the renamed weekday-set heading differs

## 4. The gates

- [ ] 4.1 `openspec validate drop-duplicate-schedule-scenarios --strict` exits 0.
- [ ] 4.2 `pnpm run check:scenarios` exits 0 — every title the delta carries still names a test.
- [ ] 4.3 None of the six dropped titles is found under `src/`, `git diff --stat origin/main -- src/`
      lists only the four test files of § 2, and every line `git diff origin/main -- src/` adds is
      inside 2.7's comment.
- [ ] 4.4 `pnpm run check:budgets` warns about nothing in this folder, and `pnpm run verify` passes.
- [ ] 4.5 `swift test` in `src/DayByDayKit` passes and reports six fewer tests than on `main`, both
      counts read off a run and never derived.
- [ ] 4.6 **The archive handover — `implementer` ticks this in its last commit before the archive**,
      on the evidence that 2.1–4.5 are ticked and that the instruction below is written here for the
      janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of
      the sync it prints, then reads the spec diff it produced: in `openspec/specs/schedule/spec.md`
      the five requirements of 3.2–3.6 leave their places and reappear at the end of the file under
      their new headings, the six dropped scenarios are gone, the two cross-references name the new
      headings, and nothing else moves; `pnpm run checks` runs after the archive commit exists.
      **Any other drift is a stop and a report, never a hand-edit** — rule 2 denies
      `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a
      box left unticked here cannot be reached afterwards.
