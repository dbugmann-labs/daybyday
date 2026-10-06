**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a test that passes before the code it names is written, a carried test
that has to be edited or turns red, or a Kit signature that has to differ from `design.md` § *The
seam*.

Rule 3 governs § 3: take the next unticked box, write the one test named for it — the scenario title
verbatim, which `pnpm run check:scenarios` checks — watch it fail, make it pass, then the next. All
ten go in `src/DayByDayKit/Tests/DayByDayKitTests/DayScreenSlackMarkTests.swift`.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly this change's ten scenarios uncovered and no other

## 2. The seam

- [x] 2.1 `DayScreen.mark(on:)` and `DayView.Row.hasNoSlack(on:)` exist with the signatures in `design.md` § *The seam*, and 3.1 is red before either does more than compile
- [x] 2.2 `hasNoSlack(on:)` reads only the row's own date, `isKept` and `weekStanding` and the today handed to it; `DayView.Row`'s stored properties, equality and public members are unchanged, by `git diff origin/main... -- src/DayByDayKit/Sources/`

## 3. The ten scenarios of `day-screen` — one test each

- [x] 3.1 a weekly-quota row on today owing every day left in its week is marked Needed today — catches the days left counted without today, or Sunday as none
- [x] 3.2 a weekly-quota row on today with a day to spare carries no mark — catches "owes at least one" in place of the days left
- [x] 3.3 a weekly-quota row on today whose week owes nothing more carries no mark — catches a negative still-owed or a 0/0 week read as no slack
- [x] 3.4 a weekly-quota row on today whose week can no longer be met carries no mark — catches `>=` where `==` is meant
- [x] 3.5 a marked row loses its mark once ticked and has it back once the tick is taken back — catches the mark read off the standing alone
- [x] 3.6 a weekly-quota total row is marked while its day falls short of its target — catches "the day holds something" in place of `isKept`
- [x] 3.7 a week owing every day it holds is marked on today until a day of it is missed — catches a seven-times or part week special-cased
- [x] 3.8 a row on a schedule that is not a weekly quota carries no mark — catches a daily row read as owing every day
- [x] 3.9 a day screen marks no row of the day before or the day after its today — catches the comparison made with the day shown, or `<=` today
- [x] 3.10 a day screen marks by the today it was last handed, not by the day it is showing — catches the today taken once at `init`

## 4. The shell (ADR-1019: no rule the Kit does not state)

- [x] 4.1 `rowView` and `commitmentLine` draw the mark exactly as `design.md` § *The shell* and § *What the shell draws* say, labelled with the string `mark(on:)` returns and composing no words of their own
- [x] 4.2 `git diff --stat origin/main... -- src/DayByDay/` lists `ContentView.swift` and `CommitmentLine.swift` alone; the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 5. The records

- [x] 5.1 `git diff --stat origin/main... -- openspec/specs/ CONTEXT.md` reports nothing (rule 2; § *Slack* landed at the Feature grill)

## 6. The gates and the archive handover

- [x] 6.1 `openspec validate mark-a-quota-without-slack --strict` exits 0, and `pnpm run checks` is clean
- [x] 6.2 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing with ten more tests than a run on `origin/main` reports, both read off runs
- [ ] 6.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 6.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked and the walk comment's URL is in W.6. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `openspec/specs/day-screen/spec.md` gains this delta's two requirements and ten scenarios, and no other spec file moves. **Any other drift is a stop and a report, never a hand-edit** — the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

A fresh install, walked on any day but a Monday. "Yuno" and "Gym" are made on the commitments
screen, both kept from a date before this week: "Yuno" on a quota, with days of this week ticked, so
its week owes exactly the days left, today included (on a Thursday, 5x with Monday ticked); "Gym"
on 7x, nothing ticked this week.

- [x] W.1 Today, light — "Yuno"'s row unticked, the glyph after its count in the same run of text, nothing in its trailing slot.
- [ ] W.2 W.1's state in dark — the glyph in the dark label colour, not grey and not green.
- [x] W.3 "Yuno" ticked on today — its count one higher, name struck through, the green checkmark, no glyph.
- [x] W.4 The tick taken back, then the screen paged back a day — "Yuno"'s row on yesterday saying its standing, no glyph.
- [x] W.5 Back on today — "Gym" saying "0/7x a week" with no glyph, and "Yuno" above it marked again.
- [ ] W.6 **The handover** — W.1–W.5, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL.
