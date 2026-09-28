Anything that fails or surprises is a stop and a report, never a workaround (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a new test that passes before the code it names is written, a carried
test turning red, or a change to `scripts/walk.ts`. Rule 3 throughout: take the next unticked
scenario box, write the one test named for it, watch it fail, make it pass.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` names this change's uncovered scenarios; they are exactly the eighteen titles boxed in §§ 3–5. Any other uncovered title is a stop.
- [x] 1.2 Reopened at G7: the tests named for the titles the delta no longer carries are renamed to the unticked titles in §§ 3–5 or deleted with them, and `pnpm run check:scenarios` then names exactly the seven titles new at this reopen, 3.1–3.3, 3.5, 4.4, 5.1 and 5.2, as uncovered. Any other is a stop.

## 2. The seam

- [x] 2.1 `showPreviousWeek()`, `showNextWeek()`, `previousWeekStrip` and `nextWeekStrip` exist on `DayScreen` with the signatures in `design.md` § *The seam*, both strips computed at each read, and no other public signature in the Kit changes

## 3. A page

- [x] 3.1 a day screen paged to the week after lands on the same weekday of that week — catches a page landing on the Monday
- [x] 3.2 a day screen paged to the week before lands on the same weekday of that week — catches a page that moves the today
- [x] 3.3 a day screen paged into the week holding its today lands on the same weekday and not on the today — catches the today's exception kept
- [x] 3.4 a day screen paged to the week after from the last week of the calendar is left exactly as it was — catches a page into a week holding no date; its test is edited for the Wednesday
- [x] 3.5 a day screen paged to the week after onto a day past the calendar lands on its last date — catches a page refused where the weekday is past 31 December 9999
- [x] 3.6 paging a day screen does not read its roster or its record again — catches a page that re-reads a place; its test is edited for the Wednesday
- [x] 3.7 a day screen paged to another week draws the commitments its roster had not stopped keeping on the day it lands on — catches rows carried from the day it left
- [x] 3.8 a day screen stops telling what it was telling when a page moves the day it is showing — catches a page that clears neither notice nor name refusal

## 4. How far back a page reaches

- [x] 4.1 a day screen paged back into the week holding the earliest day its picker reaches lands on that day — catches a page refused where the weekday is below the reach
- [x] 4.2 a day screen paged back from the week holding the earliest day its picker reaches is left exactly as it was — catches a dead page, or a notice cleared by a page that went nowhere
- [x] 4.3 a day screen moved below the earliest day its roster keeps pages back no further than the week it is showing — catches a bound read off the roster's floor rather than the reach
- [x] 4.4 a day screen paged back into the week holding its today lands on no day earlier than its picker reaches, the today included — catches the today let below the reach
- [x] 4.5 a day screen paged back into the week of the first supported date lands on that date — catches a page refused on an undated weekday

## 5. The week strip either side

- [x] 5.1 a day screen's week strip either side holds the week a page there would land in and marks no day as shown — catches a second filled capsule mid-slide
- [x] 5.2 a day screen's week strip either side offers what the reach a page there would give reaches — catches a neighbour strip read off the current reach
- [x] 5.3 a day screen says no week strip either side where a page there would leave it as it was — catches a dead week offered to the shell
- [x] 5.4 saying the week strip either side leaves a day screen exactly as it was — catches a preview that moves the day or clears a notice
- [x] 5.5 a day screen's week strip either side follows its reach once it is returned to — catches a neighbour stored at a move; its test is edited for the unmarked strip

## 6. The shell (ADR-1019: no rule the Kit does not state)

- [x] 6.1 `ContentView` draws the strip as `design.md` § *The shell* says: three strips clipped to one, tracking a horizontal drag and resisting on a `nil` neighbour, the page called only after the strip has settled, the rows not sliding
- [x] 6.2 A carried page commits a focused one-off field for departure before it moves the day; a drag begun on a cell never taps it; the day swipe, the strip tap and `settle(to:then:)`'s rows untouched
- [x] 6.3 The app target builds for the simulator, and `WalkthroughUITests` passes unedited
- [x] 6.4 The chevrons as `design.md` § *The shell* and § *What the shell draws* say: either side of the strip and fixed while it slides, faded and taking no tap on a `nil` neighbour, a tap committing a focused field, sliding the strip a week and then paging
- [x] 6.5 The strip follows the finger from the drag's first sample with no jump; the neighbour weeks take no tap, and a tap beside the strip at either screen edge moves nothing, its cause confirmed before it is fixed
- [x] 6.6 The app target builds for the simulator, and `WalkthroughUITests` passes unedited, on the reopened build

## 7. The records

- [x] 7.1 Confirm `CONTEXT.md` § *Week strip* and ADR-1042's 2026-09-28 page amendment, chevrons included, describe what shipped; a sentence that turns out wrong is a stop and a G4 question, never an edit
- [x] 7.2 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 8. Gates and the archive handover

- [x] 8.1 `openspec validate page-the-week-strip --strict` exits 0, and `pnpm run checks` is clean
- [x] 8.2 `pnpm run verify` green, and `swift test` from `src/DayByDayKit` passing, its count read off the run
- [ ] 8.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 8.4 **The implementer ticks this box in its last commit before the archive**, on the evidence that every other box is ticked — W.5 by the conductor — and the walk comment's URL is in W.6. The janitor then runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, and checks afterwards that `openspec/specs/day-screen/spec.md` gained this delta's three requirements whole and that no other spec file moved. **Any drift is a stop and a report, never a hand-edit.**

## The walk

A fresh install, so every commitment is kept from Friday 4 September 2026.

- [x] W.1 Today, with `‹` and `›` either side of the strip and today in the blue capsule.
- [x] W.2 `›` tapped — the same weekday of the next week in the text-colour capsule, the strip saying that week, the Today button in the toolbar.
- [x] W.3 From there, the strip swiped right — back on today, today in the blue capsule, no Today button.
- [x] W.4 `‹` tapped until the week of 31 August 2026 — Friday 4 September 2026 in the capsule, 31 to 3 faded, `‹` faded.
- [ ] W.5 phone: a swipe follows the finger from its first movement with no hop, and the week sliding in has no filled capsule; a chevron tap slides the strip; a tap at either screen edge beside the strip does not page; `‹` in W.4's state does nothing.
- [x] W.6 **The handover** — W.1–W.4, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL. W.5 is the human's at G7; the conductor ticks it on the G7 approval. https://github.com/dbugmann-labs/daybyday/pull/349#issuecomment-5875746106
