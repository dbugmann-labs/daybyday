## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be
written as a test without changing its title, a new test that passes before the code it names is
written, a fix that reaches outside `LookBack.swift`, `LookBackWords.swift`, `LookBackTests.swift`
and `LookBackView.swift`, or any other test in the suite turning red. A change to any other file,
a comment in one included, is booked as a finding and left alone.

Rule 3 governs §§ 3–8: take the next unticked box, write the one test named for it, watch it fail,
make it pass, then the next. Every test in §§ 3–8 goes in
`src/DayByDayKit/Tests/DayByDayKitTests/LookBackTests.swift`, beside the ones already there.

## 2. The seam

- [x] 2.1 `LookBack.graph` and `LookBack.Graph` with its days, months, points, rules and bounds exist as `design.md` § *The seam* writes them, and 3.1 is red before anything fills them
- [x] 2.2 `Roster`, `Commitment`, `CalendarDate`, `History` and `Schedule` are unchanged, and `openspec/specs/` is untouched (rule 2)
- [x] 2.3 `LookBackWords.number(_:)` is the one place a number is said, and `LookBack` says one nowhere else

## 3. The points — one test each

- [x] 3.1 a number commitment's look-back says a point for each day that holds a number — catches a point per day walked rather than per day holding a number
- [x] 3.2 a number commitment's look-back says no graph where no day holds a number — catches an empty graph answered in place of none, which the shell would draw as an empty card
- [x] 3.3 a number commitment's look-back says one point where one day holds a number — catches a graph refused below two points
- [x] 3.4 a number commitment's look-back says the number the era holding a day kept — catches every day's number read against the newest era's commitment value, which finds none behind a boundary

## 4. The days and the months — one test each

- [x] 4.1 a number commitment's graph says a day for every day from the day it is kept from through today — catches a span fitted to the days holding a number
- [x] 4.2 a number commitment's graph says a month for each calendar month its days run through — catches a month named at the wrong place, or one per day walked
- [x] 4.3 a stopped number commitment's graph runs through the day it was kept until — catches a span run through today for a commitment no longer kept
- [x] 4.4 a number commitment's graph says no point for a number kept after the day it was kept until — catches a point read off the record rather than off the days walked

## 5. The lowest and the highest — one test each

- [x] 5.1 a number commitment's graph runs between the range its newest era declares — catches an axis fitted to the numbers where a range is declared, which draws a flat week as a mountain range
- [x] 5.2 a number commitment's graph with no range runs between the values its points say — catches a bound left at zero, or taken from the first point rather than the least
- [x] 5.3 a number commitment's graph with one point says that value as its lowest and its highest — catches a crash or a widened guess where the two bounds are equal
- [x] 5.4 a number commitment's graph widens to hold a value outside its newest era's range — catches a point clamped to the range, or drawn off the top of the axis

## 6. The rules — one test each

- [x] 6.1 a number commitment's graph says a rule where the rhythm changed — catches a rule at the older era's last day rather than the newer era's first
- [x] 6.2 a number commitment's graph of one era says no rule — catches a rule said for the chain's own head
- [x] 6.3 a number commitment's graph of three eras says one rule for each boundary — catches one boundary said for a chain of three, or the rules in oldest-first order

## 7. The words a number is said in — one test each

- [x] 7.1 a look-back says a number with a fraction as its digits either side of a full stop — catches a device decimal separator, or a fraction rounded away
- [x] 7.2 a look-back says a whole number with no separator between thousands — catches a grouped "100,000"
- [x] 7.3 a look-back says a number below zero with a leading minus — catches a minus sign the locale chose, or an absolute value

## 8. What the other kinds still say

- [x] 8.1 a look-back at a commitment whose days take a note or a total says no line, no whole and no graph — written here, and the test named for the scenario this delta removes, "a look-back at a commitment whose days take a number, a note or a total says no line and no whole", is deleted; no other test is
- [x] 8.2 `LookBack.chain` is untouched: it already resembles eras by the kind's sort (#262), so the test named "a look-back chains an era whose range or target differs behind the one it was asked about" passes unchanged

## 9. The shell (ADR-1019: this Story's immediate consumer, no behaviour the kit does not specify)

- [x] 9.1 `LookBackView` draws the graph card from `lookBack.graph` — the trace through its points in the label colour, the two bounds on a pinned values axis, the dates axis off `days` and `months`, and the era labels in one lane — and the app target builds
- [x] 9.2 The picker above the card offers the four spans of `design.md` § *The shell rides this Story*, "Month" selected on opening, and the plot opens at the newest end and scrolls sideways under every span
- [x] 9.3 A page whose look-back says no graph draws neither the graph card nor the picker and says "No number yet." in place of "Nothing is counted here yet.", and the tick and quota pages keep the sentence they have

## 10. The records

**The ADR amendment and the `CONTEXT.md` edits are written by this Story's proposal commit, not by
the implementation.** These boxes confirm rather than write.

- [x] 10.1 Confirm `CONTEXT.md` § *Graph* and § *Look-back*'s newest amendment still describe what shipped; a sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in
- [x] 10.2 Confirm ADR-1045's newest amendment still describes what shipped, and that `git diff --stat origin/main... -- openspec/specs/` reports nothing

## 11. The gates

- [x] 11.1 `openspec validate look-back-at-a-number --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [x] 11.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, `docs/adr/`, `docs/open-questions.md` (the conductor's Stage-4 edit, commit de9ae92, not the implementer's), the two kit sources, the kit test file and `LookBackView.swift`
- [x] 11.3 `pnpm run check:budgets` warns about nothing in this folder, or each warning is named here with why it stands
- [x] 11.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is eighteen more than a run on `main` reports — the nineteen written in §§ 3–8 less the one deleted in 8.1, each count read off a run and neither derived
- [x] 11.5 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–11.4 and the walk below are ticked and that the instruction here is written for the janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff it produced: `openspec/specs/look-back/spec.md` holds fourteen requirements, the one this delta removes gone and the six it adds in their place, every other requirement including the resemblance one byte for byte as it was, and no other spec moved. `pnpm run checks` runs after the archive commit exists, and the archive commit is pushed. **Any other drift is a stop and a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.

## The walk

- [x] W.1 The day-one *Weight* commitment with about ten numbers typed into the day screen's entry over about three weeks of past days, its look-back opened from the commitments screen — the picture shows the graph at the month span, the picker with "Month" selected, the two bounds on the values axis and no figure beside the graph
- [x] W.2 The same page in the dark appearance (`xcrun simctl ui booted appearance dark` before the run) — the picture shows the graph card legible against the page, as the dates card is
- [x] W.3 The same page after tapping "All" — the picture shows the whole span in the width, its dates axis saying months rather than days
- [x] W.4 A number commitment whose rhythm was changed through the edit sheet, with a number either side of the change — the picture shows the rule on the graph at the newer era's first day, its label under the dates axis, and the trace unbroken across it
- [x] W.5 A number commitment holding no number yet — the picture shows the head, the dates card and "No number yet." with no graph and no picker
- [x] W.6 A number commitment holding exactly one number — the picture shows its single point mark on the graph and both values-axis labels readable, not stacked on each other
- [ ] W.7 phone: scroll the graph sideways under the month span and confirm the trace and the dates axis move together while the values axis stays put
- [x] W.8 **The handover** — the six pictures are posted to the PR with `gh pr comment --attach` before hand-back, and this box is ticked on that comment's URL — https://github.com/dbugmann-labs/daybyday/pull/296#issuecomment-5756243696
