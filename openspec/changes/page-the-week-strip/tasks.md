Anything that fails or surprises is a stop and a report, never a workaround (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a new test that passes before the code it names is written, a carried
test turning red, or a change to `scripts/walk.ts`. Rule 3 throughout: take the next unticked
scenario box, write the one test named for it, watch it fail, make it pass.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` names this change's uncovered scenarios; they are exactly the eighteen titles boxed in §§ 3–5. Any other uncovered title is a stop.

## 2. The seam

- [x] 2.1 `showPreviousWeek()`, `showNextWeek()`, `previousWeekStrip` and `nextWeekStrip` exist on `DayScreen` with the signatures in `design.md` § *The seam*, both strips computed at each read, and no other public signature in the Kit changes

## 3. A page

- [x] 3.1 a day screen paged to the week after lands on that week's Monday — catches a page landing on the same weekday
- [x] 3.2 a day screen paged to the week before lands on that week's Monday — catches a page that moves the today
- [x] 3.3 a day screen paged into the week holding its today lands on the today from either side — catches the today honoured in one direction only
- [x] 3.4 a day screen paged to the week after from the last week of the calendar is left exactly as it was — catches a page clamped to 31 December 9999
- [x] 3.5 paging a day screen does not read its roster or its record again — catches a page that re-reads a place
- [x] 3.6 a day screen paged to another week draws the commitments its roster had not stopped keeping on the day it lands on — catches rows carried from the day it left
- [x] 3.7 a day screen stops telling what it was telling when a page moves the day it is showing — catches a page that clears neither notice nor name refusal

## 4. How far back a page reaches

- [x] 4.1 a day screen paged back into the week holding the earliest day its picker reaches lands on that day — catches a page refused where the Monday is below the reach
- [x] 4.2 a day screen paged back from the week holding the earliest day its picker reaches is left exactly as it was — catches a dead page, or a notice cleared by a page that went nowhere
- [x] 4.3 a day screen moved below the earliest day its roster keeps pages back no further than the week it is showing — catches a bound read off the roster's floor rather than the reach
- [x] 4.4 a day screen paged back into the week holding its today lands on the today however late its roster's earliest day — catches a page landed through `showDay(_:)`
- [x] 4.5 a day screen whose roster keeps nothing until more than a week after its today pages back no further than that week — catches a page that jumps to the today's week
- [x] 4.6 a day screen paged back into the week of the first supported date lands on that date — catches a page refused on an undated Monday

## 5. The week strip either side

- [x] 5.1 a day screen says as the week strip either side the strip a page there would leave it saying — catches a neighbour strip marking no day as shown
- [x] 5.2 a day screen's week strip of the week before offers from the today it would land on however late its roster's earliest day — catches a neighbour strip read off the current reach
- [x] 5.3 a day screen says no week strip either side where a page there would leave it as it was — catches a dead week offered to the shell
- [x] 5.4 saying the week strip either side leaves a day screen exactly as it was — catches a preview that moves the day or clears a notice
- [x] 5.5 a day screen's week strip either side follows its reach once it is returned to — catches a neighbour stored at a move

## 6. The shell (ADR-1019: no rule the Kit does not state)

- [x] 6.1 `ContentView` draws the strip as `design.md` § *The shell* says: three strips clipped to one, tracking a horizontal drag and resisting on a `nil` neighbour, the page called only after the strip has settled, the rows not sliding
- [x] 6.2 A carried page commits a focused one-off field for departure before it moves the day; a drag begun on a cell never taps it; the day swipe, the strip tap and `settle(to:then:)`'s rows untouched
- [x] 6.3 The app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 7. The records

- [x] 7.1 Confirm `CONTEXT.md` § *Week strip* and ADR-1042's 2026-09-28 page amendment describe what shipped; a sentence that turns out wrong is a stop and a G4 question, never an edit
- [x] 7.2 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 8. Gates and the archive handover

- [x] 8.1 `openspec validate page-the-week-strip --strict` exits 0, and `pnpm run checks` is clean
- [x] 8.2 `pnpm run verify` green, and `swift test` from `src/DayByDayKit` passing, its count read off the run
- [ ] 8.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 8.4 **The implementer ticks this box in its last commit before the archive**, on the evidence that every other box is ticked — W.4 by the conductor — and the walk comment's URL is in W.5. The janitor then runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, and checks afterwards that `openspec/specs/day-screen/spec.md` gained this delta's three requirements whole and that no other spec file moved. **Any drift is a stop and a report, never a hand-edit.**

## The walk

A fresh install, so every commitment is kept from Friday 4 September 2026.

- [ ] W.1 From today, the strip swiped left — the next week's Monday in the text-colour capsule, the strip saying that week, its rows, the Today button in the toolbar.
- [ ] W.2 From there, the strip swiped right — back on today, today in the blue capsule, no Today button.
- [ ] W.3 The strip swiped right until the week of 31 August 2026 — Friday 4 September 2026 in the capsule, 31 to 3 faded, the date row "4 September 2026".
- [ ] W.4 phone: the strip follows the finger to the other week and the rows are replaced where they stand once it lands; a swipe that starts on a day's number does not tap that day; one more swipe right in W.3's state does nothing and the strip springs back.
- [ ] W.5 **The handover** — W.1–W.3, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL. W.4 is the human's at G7; the conductor ticks it on the G7 approval.
