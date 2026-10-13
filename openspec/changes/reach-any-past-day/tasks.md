**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5):
a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a test that passes before the code it names is written, a carried test
that has to be edited or turns red other than those § 2.2 deletes and the five boxes marked
*rewritten* below, or a Kit signature that has to differ from `design.md` § *The seam*.

Rule 3 governs §§ 3–5: take the next unticked box, write the one test named for it, which is the
scenario title verbatim and is what `pnpm run check:scenarios` checks. Watch it fail, make it pass,
then take the next. A *rewritten* box edits the carried test of that title to the delta's body,
and that edit is red before the code it needs.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly this change's 13 new scenarios uncovered and no other

## 2. The seam and the sweep

- [x] 2.1 `WeekStripDay.isEarliestKeptFrom` exists with the signature in `design.md` § *The seam*, and 5.1 is red before it does more than compile
- [x] 2.2 The tests named for the scenarios this delta withdraws are deleted and listed by title in the PR body: two from *A day screen shows a day picked on its day picker*, three from *A day screen's reach bounds its day picker*, one from the one-offs requirement, seven from *says the day its day picker opens on*, three from *offers every day it can show*, four from *A page to the week before lands on no day earlier*, and two from *the week strip a page either way would give*. That is 22 in all, and any other deletion is a stop

## 3. The day picker

- [x] 3.1 a day screen's day picker reaches back to the first supported date whatever its roster holds (catches the roster's answer or the today left as a floor)
- [x] 3.2 *Rewritten:* a day screen's day picker reaches back to the first supported date and opens on the last
- [x] 3.3 a day screen shows a day picked earlier than anything on its roster is kept from (catches `showDay` keeping its guard)
- [x] 3.4 *Rewritten:* a day screen shows the earliest day its day picker reaches when that day is picked
- [x] 3.5 *Rewritten:* a day screen offers the way back to today once a day other than that today is picked (its last AND is gone)

## 4. The week strip's offers and pages

- [x] 4.1 a day screen's week strip offers the days of its week before anything on its roster is kept from (catches `isOffered` keeping the floor)
- [x] 4.2 a day screen's week strip offers no day outside the calendar (catches the floor's removal dropping the date check)
- [x] 4.3 a day screen paged to the week before passes the earliest day anything on its roster is kept from, keeping the weekday (catches a page landing on the kept-from day)
- [x] 4.4 *Rewritten:* a day screen's week strip either side holds the week a page there would land in and marks no day as shown
- [x] 4.5 *Rewritten:* a day screen says no week strip either side where a page there would leave it as it was

## 5. The mark

- [x] 5.1 a day screen's week strip marks the earliest day anything on its roster is kept from, though nothing is due on it (catches a due day read for a kept-from day)
- [x] 5.2 a day screen's week strip marks the earliest day kept from where it lies after the today
- [x] 5.3 a day screen's week strip marks the earliest day kept from where it is the day shown and the today (catches the mark suppressed under the capsule)
- [x] 5.4 a day screen's week strip marks the earliest day kept from on the week strip a page either way would give (catches the neighbour strips left unmarked)
- [x] 5.5 a day screen's week strip marks the earliest day kept from of a commitment its roster has stopped keeping, and not of one it has deleted
- [x] 5.6 a day screen whose roster holds nothing or cannot be read marks no day as the earliest kept from (catches the today as a stand-in)
- [x] 5.7 a day screen's week strip follows the earliest day kept from once its roster is read again (catches a mark stored at opening)
- [x] 5.8 a day screen's week strip marks the earliest day kept from whatever its record and its one-offs hold

## 6. The shell (ADR-1019: no rule the Kit does not state)

- [ ] 6.1 `ContentView` draws the dash where `isEarliestKeptFrom`, exactly as `design.md` § *The shell* says; the accessibility label and the picker sheet are unchanged
- [ ] 6.2 `git diff --stat origin/main... -- src/DayByDay/` lists `ContentView.swift` alone; the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 7. The records

- [ ] 7.1 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2). `CONTEXT.md` and ADR-1048 are as this folder's PR left them, and neither has been edited since G4

## 8. The gates and the archive handover

- [ ] 8.1 `openspec validate reach-any-past-day --strict` exits 0, and `pnpm run checks` is clean but for any `check:budgets` warning on a carried requirement
- [ ] 8.2 `pnpm run verify` is green, and `swift test` in `src/DayByDayKit` passes. Its count and a run on `origin/main` are both read off runs and given in the PR body, and the difference is the 13 tests added less the 22 deleted
- [ ] 8.3 **G7**: the reviewer's findings are answered, and the PR is rebased onto current `main`
- [ ] 8.4 **The archive handover. `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked, W.5 included with the walk comment's URL. The janitor then runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, and reads the spec diff: `day-screen` moves and no other spec file does. It gains the 13 new scenarios, loses the 22 withdrawn ones, and has four requirements re-headed at its foot. **Any other drift is a stop and a report, never a hand-edit.** The archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

The walk runs on a fresh install, on the simulator, in light mode only, on any day. The day-one roster is kept from Friday 4 September 2026, so the walk pages the strip back to that week from today.

- [ ] W.1 The strip paged back to the week before the one holding Friday 4 September 2026. Every day is drawn plainly with its number, none is faded, and there is no dash.
- [ ] W.2 The strip paged forward to the week holding Friday 4 September 2026, with a day other than the 4th shown (tap one if the page landed on the 4th). A short grey dash sits under the 4, in the dot's slot.
- [ ] W.3 The date row tapped and the picker turned back to July 2026. Every day of that month is drawn in full and can be picked; none is greyed.
- [ ] W.4 Wednesday 15 July 2026 picked, and "Renew passport" entered as a one-off. The day screen of that day shows a One-offs group holding "Renew passport", done.
- [ ] W.5 **The handover.** W.1–W.4, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>` before hand-back, never with `gh pr comment --attach`, and this box is ticked on that comment's URL.
