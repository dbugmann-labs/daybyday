**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5).
That includes a rebase conflict in this folder or in `openspec/specs/`, and a scenario that cannot
be written as a test without changing its title. It includes a test that passes before the code it
names is written, and a carried test that has to be edited or turns red, except as 2.2 says. It
includes a Kit signature that has to differ from `design.md` § *The seam*.

Rule 3 governs §§ 2–3: take the next unticked box and write the one test named for it, its title the
scenario's verbatim, which `pnpm run check:scenarios` checks. Watch it fail, make it pass, then take
the next.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly this change's 6 new scenarios uncovered and no other, and `openspec validate say-the-last-addition --strict` exits 0 on a branch rebased onto current `main`

## 2. `DayView.Row` — the words and what a row is

- [x] 2.1 The members in `design.md` § *The seam* exist with those signatures, `takeBackLastInWords` answering `nil`, and 2.3 is red before any does more than compile
- [x] 2.2 two rows whose days hold different additions summing alike are the same row — the one sanctioned edit of a carried test: its fixture becomes 30 and 30 against 10, 20 and 30, and it asserts the take-back words, its before and after listed in the PR body
- [x] 2.3 two rows whose days hold additions summing alike but ending in different amounts are different rows — catches `lastAddition` left out of the row
- [x] 2.4 a row says the amount of its day's last addition in its take-back — catches the first addition said in place of the last
- [x] 2.5 a row that offers no take-back says no take-back words — catches words read off `lastAddition` without `offersTakeBackLast`

## 3. `DayScreen` — the words after a change

- [x] 3.1 a take-back on a day screen leaves its row saying the addition made before it — catches a row not formed again, or equal amounts collapsed
- [x] 3.2 a take-back says a decimal amount as the day's sum says it — catches a formatter or a `Double` in place of the sum's own description
- [x] 3.3 a take-back says a usual amount by its amount and never by its name — catches a usual amount's name looked up by its amount

## 4. The shell (ADR-1019: no rule the Kit does not state)

- [x] 4.1 The total entry sheet's take-back button draws `takeBackLastInWords(asOf:)` as its label and is drawn exactly where that is not `nil`, keeping its section, its destructive role and what a tap does
- [x] 4.2 `git diff --stat origin/main... -- src/DayByDay/` lists `ContentView.swift` alone; the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 5. The records

- [x] 5.1 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2), and `CONTEXT.md` is as this folder's PR left it and has not been edited since G4

## 6. The gates and the archive handover

- [x] 6.1 `openspec validate say-the-last-addition --strict` exits 0, and `pnpm run checks` is clean but for `check:budgets` warnings on the carried requirements
- [x] 6.2 `pnpm run verify` is green, and `swift test` in `src/DayByDayKit` passes with 6 more tests than a run on `origin/main` reports, both counts read off runs
- [x] 6.3 **G7** — the reviewer's findings are answered, and the PR is rebased onto current `main`
- [x] 6.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, once every other box is ticked and the walk comment's URL is in W.3. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff. `record` and `day-screen` move, `day-screen` gaining this delta's 6 new scenarios, and no other spec file moves. **Any other drift is a stop and a report, never a hand-edit**: the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

A fresh install, walked on the simulator on any day, light only. A total named "Protein", target
120, is defined through the commitments screen, and its amounts are typed through the day screen.

- [x] W.1 "35" and then "20" saved in today's "Protein" sheet, and the sheet opened again: "55 of 120" under the name, and "Take back last (20)" in its own section under the field. Dismiss the keyboard first if it covers that section.
- [x] W.2 That button tapped, the sheet closed, and the sheet opened again: "35 of 120" under the name, and "Take back last (35)" in its own section. Dismiss the keyboard as in W.1.
- [x] W.3 **The handover**: W.1–W.2, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>` before hand-back, never with `gh pr comment --attach`, and this box is ticked on that comment's URL.
