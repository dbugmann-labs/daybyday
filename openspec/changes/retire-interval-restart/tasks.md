**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5):
a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a carried test that has to be edited or turns red but for 2.3 and 3.1,
a test that stops compiling other than those 2.2 deletes and 2.3 edits, a Kit signature that has to
differ from `design.md` § *The seam*, or a crash in a carried path.

Rule 3 governs § 3: take the next unticked box, write the one test named for it — the scenario title
verbatim, which `pnpm run check:scenarios` checks — then the next. **3.2 and 3.3 pass on arrival by
design**: each guards a shipped rule whose only scenario this delta removes. Passing is not the stop
here; a test that cannot be made to fail is. Each is proven by the mutation its box names, run once,
reverted, and named in the PR body.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` reports 67 of this change's 70 scenarios covered, the three uncovered being 3.1's, 3.2's and 3.3's

## 2. Restart taken out — `CommitmentsScreen`, `History`, `RecordStore`, the shell

- [x] 2.1 The members `design.md` § *The seam* lists as removed are deleted, with every line only they reach; the doc comments in `CommitmentsScreen`, `DayScreen` and `SaveInProgress` that cite a renamed or removed heading cite the new heading or go
- [x] 2.2 The fifteen tests in `CommitmentsScreenTests.swift` whose scenarios this delta removes are deleted, each listed by title in the PR body; no other test is deleted
- [x] 2.3 *what a commitments screen tells on its sheet stands when another field is edited* no longer tells a restart day field edited and asserts what it asserted before — the one sanctioned edit of a carried test, its before and after in the PR body
- [x] 2.4 `CommitmentsView` draws no *Restart* section and holds no restart state, bounds or words, and the app target builds

## 3. `commitment` — `CommitmentsScreen`, `RosterStore`, `DayScreen`

- [x] 3.1 a torn save is undone when a day screen is opened — the carried test renamed to this title, its body unchanged but for the local `restartedNails` renamed `changedNails`, which 4.1's grep forces, its before and after in the PR body
- [x] 3.2 a refused change replaces what a refused definition told on a commitments screen's sheet — mutation: a refused change leaves the sheet refusal it found standing
- [x] 3.3 neighbouring every-N-days eras of one interval counting from different days are read back as two — mutation: the mend compares an every-N-days schedule without its start date

## 4. The records

- [x] 4.1 `grep -rni "restart" src/DayByDayKit src/DayByDay` prints nothing; `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2); `CONTEXT.md` and ADR-1067 are as this folder's PR left them, and not edited since G4

## 5. The gates and the archive handover

- [x] 5.1 `openspec validate retire-interval-restart --strict` exits 0, and `pnpm run checks` is clean but for `check:budgets` warnings on the two carried requirements `design.md` § *Risks* names
- [x] 5.2 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing with 13 fewer tests than a run on `origin/main` reports, both read off runs
- [ ] 5.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [x] 5.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked and the walk comment's URL is in W.2. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `commitment` and `restore` move, and no other spec file does. **Any other drift is a stop and a report, never a hand-edit** — the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

A fresh install, light only, on the real date. Nothing is made: the day-one "Nails", every 4 days,
is walked as it stands.

- [x] W.1 The commitments screen, "Nails" opened by its Edit swipe and its sheet scrolled to the foot — "Every 4 day(s)" and "Kept from" the last rows of the form, no "Restart" section and no "Restart from" picker below them.
- [x] W.2 **The handover** — W.1, taken on the final build, is posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL.
