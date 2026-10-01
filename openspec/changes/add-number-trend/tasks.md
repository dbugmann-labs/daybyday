Anything that fails or surprises is a stop and a report, never a workaround (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a new test that passes before the code it names is written, a carried
test turning red, a seeding hook added to the app for the walk, or a change to `scripts/walk.ts`.
Rule 3 throughout: take the next unticked scenario box, write the one test named for it, watch it
fail, make it pass.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` names this change's uncovered scenarios; they are exactly the eight titles boxed in §§ 3–4. Any other uncovered title is a stop.

## 2. The seam

- [x] 2.1 Every member in `design.md` § *The seam* exists with that signature, the trend formed inside `LookBack.graph(from:through:eras:history:)` from its points, and no other public signature in the Kit changes.

## 3. A trend point on each day the graph says a point

- [x] 3.1 a number commitment's graph says a trend point on each day it says a point, and on no other day — catches a trend carried on to today
- [x] 3.2 a number commitment's graph with one point says one trend point of that point's value
- [x] 3.3 a total commitment's graph says no trend — catches a trend formed for every graph

## 4. The average

- [x] 4.1 a trend point averages the points its window holds however few, the first being its own point's value — catches a sum divided by seven
- [x] 4.2 a trend point averages only the points held in the seven calendar days ending on its day — catches a window of six or eight days
- [x] 4.3 a trend point averages the points either side of a boundary between eras — catches a window cut at the era
- [x] 4.4 a trend point takes in no number the record holds for a day of a gap — catches a window read off the record
- [x] 4.5 a trend point's average is carried unrounded — catches a value rounded to the inputs' digits

## 5. The shell (ADR-1019: no rule the Kit does not state)

- [x] 5.1 `LookBackView` draws as `design.md` § *The shell* says: a "Trend" toggle in button style beside the narrowed span picker only where `graph.trend` is not empty, off on every visit, untouched by a change of span, and when on a trace through `graph.trend` in the label colour under its own `series:`, over the unchanged trace; the tap and its callout read `graph.points` only
- [x] 5.2 The app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 6. The records

- [x] 6.1 Confirm `CONTEXT.md` § *Trend*'s 2026-10-01 amendment describes what shipped; a sentence that turns out wrong is a stop and a G4 question, never an edit
- [x] 6.2 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 7. Gates and the archive handover

- [x] 7.1 `openspec validate add-number-trend --strict` exits 0, and `pnpm run checks` is clean
- [x] 7.2 `pnpm run verify` green, and `swift test` from `src/DayByDayKit` passing, its count read off the run
- [ ] 7.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 7.4 **The implementer ticks this box in its last commit before the archive**, on the evidence that every other box is ticked and the walk comment's URL is in W.4. The janitor then runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, and checks afterwards that `look-back/spec.md` gained the two ADDED requirements whole and that no other spec file moved. **Any drift is a stop and a report, never a hand-edit.**

## The walk

A fresh install — `pnpm run walk` uninstalls the app, so the history is typed through the day
screen, never seeded — with a number commitment "Weight" on every day, kept from about four months
back, holding numbers on three or four days of each week since, drifting down several units and
back up with a day-to-day wobble of about one.

- [x] W.1 Weight's look-back at Month, "Trend" off beside the narrowed span picker: the grey trace and its dots alone.
- [x] W.2 The same page after tapping "Trend": the button tinted, and a heavier trace in the label colour, without dots, over the grey one and not joined to it.
- [x] W.3 The same visit after tapping "Year": "Trend" still on, and the trend bending away from the day-to-day trace across the months.
- [x] W.4 **The handover** — W.1–W.3, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL. https://github.com/dbugmann-labs/daybyday/pull/370#issuecomment-5926109932
