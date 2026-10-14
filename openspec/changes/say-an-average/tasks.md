**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5).
That includes a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be
written as a test without changing its title, a test that passes before the code it names is
written, a carried test that has to be edited or turns red, and a Kit signature that has to differ
from `design.md` § *The seam*.

Rule 3 governs § 2: take the next unticked box and write the one test named for it, its title the
scenario's verbatim, which `pnpm run check:scenarios` checks. Watch it fail, make it pass, then take
the next.

## 1. Before a line is written

- [ ] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly this change's 9 new scenarios uncovered and no other, and `openspec validate say-an-average --strict` exits 0 on a branch rebased onto current `main`

## 2. `LookBack` — the spans and the average

- [ ] 2.1 The members in `design.md` § *The seam* exist with those signatures, `averageInWords(over:)` answering `nil`, and 2.2 is red before any does more than compile
- [ ] 2.2 a graph averages the points among each span's newest days — catches a span one day too long or too short at any of its three edges
- [ ] 2.3 a span longer than its graph's days averages every point the graph says — catches dividing by the days rather than the points
- [ ] 2.4 a stopped commitment's spans end on the day it was kept until — catches a span ending on today
- [ ] 2.5 a graph says no average over a span holding no point — catches "0" or "NaN" in place of `nil`
- [ ] 2.6 a total commitment's average takes in each day's sum across a change of target, and says no target — catches additions averaged in place of sums, or the newest target said
- [ ] 2.7 a graph's average takes in no number the record holds for a day of a gap — catches reading the record rather than the graph's points
- [ ] 2.8 a look-back says an average to one decimal place — catches truncation, or the sum rounded before it is divided
- [ ] 2.9 a look-back says an average rounding to a whole number with no fraction and no separator between thousands — catches a trailing ".0", or a formatter in place of `LookBackWords.number`
- [ ] 2.10 a look-back rounds a halfway average below zero away from zero, and says one rounding to zero as 0 — catches rounding toward the greater value, and "-0"

## 3. The shell (ADR-1019: no rule the Kit does not state)

- [ ] 3.1 `LookBackView` holds no span enum of its own: the picker offers `LookBack.Span.allCases` under the titles "Month", "3 months", "Year" and "All", and the plot's visible length reads `lengthInDays`, opening and scrolling as shipped
- [ ] 3.2 Under the graph card, a card of one `LookBackDateRow` labelled "Average" draws `averageInWords(over: span)` in monospaced digits, as § *What the shell draws* has it, and is drawn exactly where that is not `nil`, nothing above it moving
- [ ] 3.3 `git diff --stat origin/main... -- src/DayByDay/` lists `LookBackView.swift` alone; the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 4. The records

- [ ] 4.1 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2), and `CONTEXT.md` is as this folder's PR left it and has not been edited since G4

## 5. The gates and the archive handover

- [ ] 5.1 `openspec validate say-an-average --strict` exits 0, and `pnpm run checks` is clean but for `check:budgets` warnings on carried requirements
- [ ] 5.2 `pnpm run verify` is green, and `swift test` in `src/DayByDayKit` passes with 9 more tests than a run on `origin/main` reports, both counts read off runs
- [ ] 5.3 **G7** — the reviewer's findings are answered, and the PR is rebased onto current `main`
- [ ] 5.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, once every other box is ticked and the walk comment's URL is in W.4. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `look-back` alone moves, gaining this delta's two requirements and 9 scenarios. **Any other drift is a stop and a report, never a hand-edit**: the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

A fresh install, walked on the simulator on any day, light only; `pnpm run walk` uninstalls the app,
so the history is typed through the day screen, never seeded. A number commitment "Weight" on every
day, kept from about four months back, holds numbers on two or three days of each week, the older
months several units above the last one. A total "Protein", target 120, kept from a month back, holds
additions on a few days of the last two weeks.

- [ ] W.1 Weight's look-back at Month: under the graph card, one card saying "AVERAGE" left and a figure of at most one decimal place right.
- [ ] W.2 The same visit after tapping "Year": the average card saying a higher figure than W.1's, the older months now taken in.
- [ ] W.3 Protein's look-back at Month: no "Trend" button, the picker across the full row, and the average card saying a figure with no "of" and no target.
- [ ] W.4 **The handover**: W.1–W.3, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>` before hand-back, never with `gh pr comment --attach`, and this box is ticked on that comment's URL.
