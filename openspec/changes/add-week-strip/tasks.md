Anything that fails or surprises is a stop and a report, never a workaround (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a new test that passes before the code it names is written, a carried
test turning red, or a change to `scripts/walk.ts`. Rule 3 throughout: take the next unticked
scenario box, write the one test named for it, watch it fail, make it pass.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` names this change's uncovered scenarios; they are exactly the twelve titles boxed in §§ 3–4. Any other uncovered title is a stop.

## 2. The seam

- [x] 2.1 `DayScreen.WeekStripDay` and `DayScreen.weekStrip` exist with the signatures in `design.md` § *The seam*, `weekStrip` computed at each read and never stored, and no other public signature in the Kit changes

## 3. The week strip

- [x] 3.1 a day screen says the seven days of its week, Monday first, each by its letter — catches a Sunday-first week or the three-letter day titles
- [x] 3.2 a day screen's week strip marks the today apart from the day it is showing — catches one mark doing for both
- [x] 3.3 a day screen moved into another week holds that week in its strip and marks no day as the today — catches the strip held on the today's week
- [x] 3.4 a day screen's week strip runs across the turn of a month and a year — catches dates built from the day of the month
- [x] 3.5 a day screen's week strip holds no date for a day outside the calendar — catches a strip shortened at the ends, or one clamped to 1 January 1583
- [x] 3.6 a day screen shown again on a later day follows it in its week strip only where it was showing its today — catches a strip stored at a move
- [x] 3.7 a day screen's week strip is the same whatever its record holds and whatever is ticked — catches a strip reading the day's rows

## 4. What the strip offers

- [x] 4.1 a day screen's week strip offers every day of its week but the one it is showing — catches the shown day offered, or days after the today refused
- [x] 4.2 a day screen's week strip offers no day earlier than its day picker reaches — catches every dated day offered
- [x] 4.3 a day screen moved below the earliest day its roster keeps offers the days between in its strip — catches offers read off the roster's floor rather than the reach
- [x] 4.4 a day screen's week strip offers the days its roster reaches once it is returned to — catches a reach read once at opening
- [x] 4.5 a day screen shows a day tapped on its week strip — catches a strip whose date and `showDay` disagree

## 5. The shell (ADR-1019: no rule the Kit does not state)

- [x] 5.1 `ContentView` draws the head as `design.md` § *The shell* and § *What the shell draws* say: the date row leading, the strip under it, the chevrons and `playSettle(towards:)` gone, the swipe and `settle(to:then:)` untouched
- [x] 5.2 A strip tap commits a focused one-off field for departure, then calls `showDay`, and animates nothing
- [x] 5.3 The app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 6. The records

- [x] 6.1 Confirm `CONTEXT.md` § *Week strip* and ADR-1042's and ADR-1045's 2026-09-28 amendments describe what shipped; a sentence that turns out wrong is a stop and a G4 question, never an edit
- [x] 6.2 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 7. Gates and the archive handover

- [x] 7.1 `openspec validate add-week-strip --strict` exits 0, and `pnpm run checks` is clean
- [x] 7.2 `pnpm run verify` green, and `swift test` from `src/DayByDayKit` passing, its count read off the run
- [ ] 7.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 7.4 **The implementer ticks this box in its last commit before the archive**, on the evidence that every other box is ticked — W.6 by the conductor — and the walk comment's URL is in W.7. The janitor then runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, and checks afterwards that `openspec/specs/day-screen/spec.md` gained this delta's two requirements whole and that no other spec file moved. **Any drift is a stop and a report, never a hand-edit.**

## The walk

A fresh install, so every commitment is kept from Friday 4 September 2026.

- [x] W.1 Today — the date row at the leading edge saying "Today, …", the strip under it with today in a blue capsule, no chevrons and no Today button.
- [x] W.2 The strip's Monday tapped from today, or its Sunday where today is a Monday — that day in the text-colour capsule, today's letter and number blue, the Today button in the toolbar.
- [x] W.3 Sunday 6 September 2026 picked on the calendar, then one swipe left — Monday 7 September 2026 in the capsule and the strip saying 7 to 13.
- [x] W.4 Wednesday 16 September 2026 picked on the calendar — the strip saying 14 to 20, Wednesday in the capsule, the date row "16 September 2026".
- [x] W.5 Friday 4 September 2026 picked on the calendar — 31, 1, 2 and 3 faded, 4 in the capsule, 5 and 6 at full strength.
- [ ] W.6 phone: swipe from a Sunday onto the Monday after and back — the head stays still under the finger, the strip redraws as the other week once the day lands, and it reads as what the swipe moves now that the chevrons are gone.
- [x] W.7 **The handover** — W.1–W.5, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL. W.6 is the human's at G7; the conductor ticks it on the G7 approval. Posted: https://github.com/dbugmann-labs/daybyday/pull/348#issuecomment-5869094025
