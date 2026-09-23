## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be
written as a test without changing its title, a new test that passes before the code it names is
written, a fix that reaches outside `LookBack.swift`, `LookBackWords.swift`, `LookBackTests.swift`
and `LookBackView.swift`, or any other test in the suite turning red. A change to any other file,
a comment in one included, is booked as a finding and left alone — `CONTEXT.md` and `docs/adr/`
are this Story's proposal commit's, not the implementation's.

Rule 3 governs §§ 3–7: take the next unticked box, write the one test named for it, watch it fail,
make it pass, then the next. Every test goes in
`src/DayByDayKit/Tests/DayByDayKitTests/LookBackTests.swift`, beside the ones already there.

## 2. The seam

- [x] 2.1 `LookBack.Graph.targetRule`, `LookBack.Graph.Stretch` and `LookBack.Graph.Point.isKept` exist as `design.md` § *The seam* writes them, and 3.1 is red before a total's graph is formed
- [x] 2.2 `Roster`, `Commitment`, `CalendarDate`, `History`, `Schedule` and `DayView` are unchanged, and `openspec/specs/` is untouched (rule 2)
- [x] 2.3 `LookBackWords.sum(_:of:)` is the one place a sum of its target is said, built on `LookBackWords.number(_:)`

## 3. The points — one test each

- [x] 3.1 a total commitment's look-back says a point for each day that holds an addition — catches a point per day walked, a zero point on a day with nothing added, or the last addition read in place of the sum
- [x] 3.2 a total commitment's look-back says no graph where no day holds an addition — catches an empty graph answered in place of none, or a taken-back day left as a zero point
- [x] 3.3 a total commitment's look-back says the sum the era holding a day kept — catches every day's sum read against the newest era's commitment, which finds none behind a boundary

## 4. Kept and its words — one test each

- [x] 4.1 a total commitment's graph marks a point kept where its sum passes its target, and not where it falls short — catches the comparison reversed, or a number's words where the sum of its target belongs
- [x] 4.2 a total commitment's graph marks a point kept where its sum reaches its target exactly — catches `>` where `>=` belongs
- [x] 4.3 a total commitment's graph judges each point against the target the era holding its day declared — catches every point judged and said against the newest era's target

## 5. The target rule — one test each

- [x] 5.1 a total commitment's target rule runs across every day of its graph, a day holding no addition included — catches a rule fitted to the first and last point, or a rule on a number's graph
- [x] 5.2 a total commitment's target rule steps where the target changed — catches one stretch per era regardless of target, a step a day early or late, or stretches newest first

## 6. The values axis — one test each

- [x] 6.1 a total commitment's graph runs from zero to its greatest sum where a sum passes every target — catches the number's bounds taken from the points' least value
- [x] 6.2 a total commitment's graph runs from zero to its greatest target where every sum falls short — catches the highest taken from the points alone, or from the newest era's target alone

## 7. The boundary and what a note still says

- [x] 7.1 a total commitment's graph says nothing where only the rhythm changed — catches a stretch split at a boundary whose target did not change, or a day, month or point shifted by it
- [x] 7.2 a look-back at a commitment whose days take a note says no line, no whole and no graph — written here, and the test named for the scenario this delta removes, "a look-back at a commitment whose days take a note or a total says no line, no whole and no graph", is deleted; no other test is
- [x] 7.3 The two carried boundary tests, "a look-back says nothing between the lines either side of a boundary" and "a number commitment's graph says nothing where one era gives way to the next", pass unchanged

## 8. The shell (ADR-1019: this Story's immediate consumer, no behaviour the kit does not specify)

- [x] 8.1 `LookBackView` draws a total's target rule as `design.md` § *The shell rides this Story* says — a dashed secondary segment per stretch, no riser, each labelled with its `inWords` at its last day — and the app target builds
- [x] 8.2 A total's kept point is ringed and one not kept is the shipped dot in the secondary colour, and a number's graph draws exactly as it did
- [x] 8.3 A total page whose look-back says no graph draws neither the graph card nor the picker and says "Nothing added yet.", and the number, tick, quota and note pages keep the sentences they have

## 9. The records

**The ADR amendment and the `CONTEXT.md` edits are written by this Story's proposal commit, not by
the implementation.** This box confirms rather than writes.

- [x] 9.1 Confirm `CONTEXT.md` § *Target rule*, § *Look-back* and § *Graph*, and ADR-1045's newest amendment, still describe what shipped; a sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in

## 10. The gates

- [x] 10.1 `openspec validate look-back-at-a-total --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [x] 10.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, `docs/adr/1045-*`, the two kit sources, the kit test file and `LookBackView.swift`
- [x] 10.3 `pnpm run check:budgets` warns about nothing in this folder, or each warning is named here with why it stands
- [x] 10.4 `swift test` in `src/DayByDayKit` passes, and the count it reports against a run on `main` differs by exactly the tests §§ 3–7 write less the one 7.2 deletes, each count read off a run
- [ ] 10.5 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–10.4 and the walk below are ticked and that the instruction here is written for the janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff it produced: `openspec/specs/look-back/spec.md` holds seventeen requirements, the one this delta removes gone and the five it adds in its place, the one it modifies differing only in the sentence and the scenario the delta adds, every other requirement byte for byte as it was, and no other spec moved. `pnpm run checks` runs after the archive commit exists, and the archive commit is pushed. **Any other drift is a stop and a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.

## The walk

- [ ] W.1 A *Protein* total with a target of 120, sums added on about ten past days of the last three weeks — some above 120, one exactly 120, some below — its look-back opened from the commitments screen: the month span shows the above and exact points ringed, the below points unringed, the dashed rule labelled "120" at its newest end, and the values axis from "0"
- [ ] W.2 A total with sums on past days whose target was then changed from 120 to 100 through the edit sheet, and a sum added today: the rule stands at 120 then 100 with no riser, "120" labelled where it steps and "100" at its newest end, today's point judged against 100
- [ ] W.3 The W.1 page after tapping "All": the whole run in the width, the rule across all of it, and the values axis from "0"
- [ ] W.4 A total commitment with nothing added: the head, the dates card and "Nothing added yet.", with no graph and no picker
- [ ] W.5 **The handover** — the four pictures are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL
