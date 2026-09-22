## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be
written as a test without changing its title, a new test that passes before the code it names is
written, a deletion that reaches outside `LookBack.swift`, `LookBackTests.swift` and
`LookBackView.swift`, or any other test in the suite turning red. A change to any other file, a
comment in one included, is booked as a finding and left alone — `CONTEXT.md` is this Story's
proposal commit's, not the implementation's.

Rule 3 governs § 3: take the next unticked box, write the one test named for it, watch it fail,
make it pass, then the next. Both tests go in
`src/DayByDayKit/Tests/DayByDayKitTests/LookBackTests.swift`, beside the ones already there.

## 2. The seam

- [x] 2.1 `LookBack.Line` loses `.rhythmChanged` and `LookBack.Graph` loses `rules` and `Rule`, exactly as `design.md` § *The seam* writes them, and no other member of either is added, renamed or reshaped
- [x] 2.2 `Roster`, `Commitment`, `CalendarDate`, `History`, `Schedule` and `LookBackWords` are unchanged, and `openspec/specs/` is untouched (rule 2)

## 3. The silence — one test each

- [x] 3.1 a look-back says nothing between the lines either side of a boundary — catches a blank row, a spacer or a heading left where the line was, and a mixed chain that still parts its months from its weeks
- [x] 3.2 a number commitment's graph says nothing where one era gives way to the next — catches a boundary kept as a day, a month or a point of its own, and a graph whose days or points shift because a chain has two eras

## 4. What goes with the mark

- [x] 4.1 The nine tests named for the nine scenarios this delta removes are deleted, and so is the one named for no scenario — "a look-back says two lines where the rhythm changed inside the same month, newest first", added at #272's G7 and reaching the placement directly
- [x] 4.2 The test named "a look-back says a weekday era's months and a quota era's weeks, each in its own unit" keeps its title and expects the delta's lines, the marker entry gone from its expected list; no other test's title changes and no other test is deleted
- [x] 4.3 `walkDays` loses the placement pass, the two key-to-last-day dictionaries, the `Unit` key and the `WeekKey` only that key needed, and keeps the day walk, the nil-line filter, the sort by last counted day and the totals — the split `docs/open-questions.md` wants is not attempted here
- [x] 4.4 The graph loses the map that formed its rules, and forms its days, its months, its points and its two bounds exactly as it does now

## 5. The shell (ADR-1019: this Story's immediate consumer, no behaviour the kit does not specify)

- [x] 5.1 `LookBackView` draws nothing at a boundary — the `.rhythmChanged` case, `doubleRule` and both passes over the graph's rules are gone — and the app target builds
- [x] 5.2 The graph card's bottom padding is what the dates lane alone needs, read off walk picture three rather than guessed, so no blank band stands under the axis
- [x] 5.3 The four doc comments that describe the mark — the view's own header, `linesSection`, `heading(for:)`'s unreachable case and `graphCard` — say what is drawn now, and none cites a requirement this delta removes

## 6. The records

**The `CONTEXT.md` amendments are written by this Story's proposal commit, not by the
implementation.** This box confirms rather than writes.

- [x] 6.1 Confirm `CONTEXT.md` § *Look-back*'s and § *Graph*'s newest amendments still describe what shipped; a sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in

## 7. The gates

- [x] 7.1 `openspec validate say-nothing-where-the-rhythm-changed --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [x] 7.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, the kit source, the kit test file and `LookBackView.swift`
- [x] 7.3 `pnpm run check:budgets` warns about nothing in this folder, or each warning is named here with why it stands
- [x] 7.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is eight fewer than a run on `main` reports — the ten deleted in § 4 less the two written in § 3 — each count read off a run and neither derived
- [x] 7.5 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–7.4 and the walk below are ticked and that the instruction here is written for the janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff it produced: `openspec/specs/look-back/spec.md` holds thirteen requirements, the two this delta removes gone and the one it adds in their place, the two it modifies differing only in the sentence and the scenario line the delta changes, every other requirement byte for byte as it was, and no other spec moved. `pnpm run checks` runs after the archive commit exists, and the archive commit is pushed. **Any other drift is a stop and a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.

## The walk

- [x] W.1 A tick commitment kept from a day in the previous month whose rhythm was then changed through the edit sheet, ticked on days of both eras, its look-back opened from the commitments screen — the picture shows the month lines running one under the next with nothing between them, and the head saying the newest era's rhythm and the earliest era's day kept from
- [x] W.2 A commitment kept from a day in the previous month on a weekly quota, whose rhythm was then changed to a weekday set through the edit sheet — the picture shows the heading "Months and weeks", the month line above the week lines, and nothing standing between the two units
- [x] W.3 A number commitment kept from a day in the previous month with numbers entered either side of a rhythm change — the picture shows the trace crossing the boundary with no rule and no label under the dates axis, and no blank band between the dates and the bottom of the card
- [x] W.4 **The handover** — the three pictures are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL: https://github.com/dbugmann-labs/daybyday/pull/302#issuecomment-5766252798
