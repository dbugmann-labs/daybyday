## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): `openspec validate` or the archiver refusing a block, a scenario that is not byte-for-byte
what it is today, or a rebase conflict in this folder, in `docs/adr/` or in `openspec/specs/`.

**Every box in § 2 asks the same three things of one requirement**, and is ticked only when all three
hold: every rule `grill-frontier.md` § B and § C lists for it is a SHALL/MUST sentence in the rewrite,
read against the current sentence beside it rather than found by keyword; every scenario under it is
byte-for-byte what it is today, title and body, under the same heading; and its prose is 40–150
words, or is named in `design.md` § *Overruns the budget*. A clause after a heading is the trap that
requirement carries and nothing more — the three things are still what the tick means.

**The *Rules at risk* lists** are `docs/research/2026-09-09-concise-specs/survey-schedule-cli.md`
§ 1 as `grill-frontier.md` § C corrects it, together with frontier § B; the frontier wins wherever
the two disagree.

## 2. `schedule` — one box per requirement, in spec order

- [ ] 2.1 *A weekday-set schedule is due on the weekdays it lists* — keep its exclusion clause, the week's first day included
- [ ] 2.2 *The weekday of a calendar date follows the Gregorian calendar* — keep the time-zone and locale MUST NOT
- [ ] 2.3 *A calendar date names a day that exists* — the extreme-component MUST NOT is the only rule three scenarios rest on
- [ ] 2.4 *A calendar date lies within the years the system supports* — the 1582 history is ADR-1004's; keep that month and day are bounded by 2.3, not here
- [ ] 2.5 *A day-of-month schedule is due on that day of the month* — defers to 2.6 for the clamp in one clause, and keeps its own exclusion clause
- [ ] 2.6 *A month too short for the scheduled day is due on its last day* — the argument is ADR-1051's; keep that the 28th to the 31st share a common February's last day
- [ ] 2.7 *A day of the month is a number from the first to the thirty-first* — keep both refusals: nothing past 31 reduced, nothing below 1 counted backwards
- [ ] 2.8 *An every-N-days schedule is due on its start date and every interval after it* — refers to 2.10's no-upper-bound rule in one clause and does not restate it
- [ ] 2.9 *An every-N-days schedule is not due before its start date* — the argument is ADR-1013's; keep that the calendar-anchored shapes match in either direction
- [ ] 2.10 *An interval is a whole number of days, at least one* — states the no-upper-bound rule in full, because a scenario under 2.8 tests it
- [ ] 2.11 *A weekly-quota schedule is due on every date* — the bold paragraph goes to ADR-1015; keep the tick-records MUST and every item of the exclusion clause
- [ ] 2.12 *A weekly quota is a number of times from one to seven* — the ceiling's argument is ADR-1015's; keep both bounds and that eight is not reduced to seven
- [ ] 2.13 *A calendar date gives back the year, the month and the day it names* — readable and not writable stays a SHALL; its argument is ADR-1004's
- [ ] 2.14 *A schedule says the rhythm it runs on in words* — keep the same words whatever day it is asked on, and no leading zero
- [ ] 2.15 *A weekday-set schedule is said as its weekdays, in week order from Monday* — the empty set's argument is ADR-1034's; "No day" stays a SHALL
- [ ] 2.16 *An every-N-days schedule is said as its interval, and never as its start date* — the argument is ADR-1034's; keep same words whatever the start date
- [ ] 2.17 *A day-of-month schedule is said as the ordinal of its day* — keep every suffix in the table and the MUST NOT on saying the clamp
- [ ] 2.18 *A weekly-quota schedule is said as a number of times a week* — the argument is ADR-1034's; seven a week not said as "Every day" stays a rule

## 3. The gates

- [ ] 3.1 `openspec validate condense-schedule-spec --strict` exits 0.
- [ ] 3.2 `pnpm run check:scenarios` exits 0 — every scenario title in the delta still names a test
      that exists, which is what "byte-for-byte" means mechanically.
- [ ] 3.3 `pnpm run check:budgets` reports exactly the requirements `design.md` § *Overruns the
      budget* lists, and no artifact over its own budget.
- [ ] 3.4 `swift test` in `src/DayByDayKit` passes and reports the same number of tests as on `main`,
      read off both runs and never derived, and `git diff --stat origin/main -- src/ tests/` prints
      nothing — this Story touches no test file.
- [ ] 3.5 **The archive handover — `implementer` ticks this in its last commit before the archive**,
      on the evidence that 3.1–3.4 are ticked and that the instruction below is written here for the
      janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of
      the sync it prints, then reads the spec diff it produced: `openspec/specs/schedule/spec.md` must
      differ in requirement prose only, every requirement in its current place and every
      `#### Scenario:` title and body unchanged, and `pnpm run checks` runs after the archive commit
      exists. **Any other drift is a stop and a report, never a hand-edit** — rule 2 denies
      `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so
      a box left unticked here cannot be reached afterwards.
