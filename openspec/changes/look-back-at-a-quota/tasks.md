## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be
written as a test without changing its title, a new test that passes before the code it names is
written, a fix that reaches outside `LookBack.swift`, `LookBackWords.swift`, `LookBackTests.swift`
and `LookBackView.swift`, or any other test in the suite turning red.

Rule 3 governs §§ 3–6: take the next unticked box, write the one test named for it, watch it fail,
make it pass, then the next. Every test in §§ 3–6 goes in
`src/DayByDayKit/Tests/DayByDayKitTests/LookBackTests.swift`, beside the ones already there.

## 2. The seam

- [x] 2.1 `LookBack.Line` gains the week case and `.month`'s fraction stops being optional, both as `design.md` § *The seam* writes them, and 3.1 is red before either counts anything
- [x] 2.2 `Roster`, `Commitment`, `CalendarDate`, `History` and `Schedule` are unchanged, and `openspec/specs/` is untouched (rule 2)
- [x] 2.3 The tidy `docs/open-questions.md` names: `LookBack`'s month tally holds one `YearMonth` rather than a loose year and month, and no test changes

## 3. The weeks — one test each

- [x] 3.1 a look-back says a week's kept days out of its quota — catches a week counted from the day kept from rather than from its Monday
- [x] 3.2 a look-back says its weeks newest first, and leaves none between out — catches oldest first, or a week emitted only where a day was kept
- [x] 3.3 a look-back counts the week in progress against the whole quota — catches a quota scaled to the days of the week counted
- [x] 3.4 a look-back counts the week a commitment is kept from against the whole quota — catches a part week dropped, or its quota scaled
- [x] 3.5 a look-back says a week kept past its quota as the days kept, uncapped — catches a numerator capped at the quota
- [x] 3.6 a stopped quota commitment's look-back counts its last week through the day it was kept until — catches a record after the day kept until counted into the week that holds it
- [x] 3.7 a look-back says a weekday era's months and a quota era's weeks, each in its own unit — catches a month line counting a quota era's days, or one unit chosen for the whole chain
- [x] 3.8 a week two quota eras share says its kept days out of the newer era's quota — catches two quotas summed, or the week said twice

## 4. The whole — one test each

- [x] 4.1 a look-back's whole is the sum of the weeks it says — catches a whole still saying nothing where an era runs on a quota
- [x] 4.2 a mixed chain's whole sums its months' due days and its weeks' quotas alike — catches a whole counted over the days walked rather than over the lines said

## 5. Where the rhythm changed — one test each

- [x] 5.1 a look-back says where the rhythm changed, above the week the newer era is kept from — catches a line placed by the month a week falls in
- [x] 5.2 a look-back says where the rhythm changed between a quota era's weeks and a weekday era's months — catches the higher of the two lines holding that day, which puts the line above everything

## 6. The words — one test each

- [x] 6.1 a look-back says a week inside one month as its two days, that month's short name and the year — catches a full month name, or the month said at both ends
- [x] 6.2 a look-back says a week across two months as each end's day and short month, and the year once — catches the year said twice, or the one-month form used across two
- [x] 6.3 a look-back says a week across two years as each end's day, short month and year — catches the later year said for both ends

## 7. What the delta carries unchanged

- [x] 7.1 The sixteen scenarios this delta carries verbatim under the month, the whole, the rhythm-changed and the number-note-total requirements still pass, with their tests untouched
- [x] 7.2 The two tests named for the scenarios this delta removes — "a look-back at a weekly quota says its months with no fraction and no whole" and "a look-back says no fraction on a month a weekly-quota era counts a day of" — are deleted, and no other test is

## 8. The shell (ADR-1019: this Story's immediate consumer, no behaviour the kit does not specify)

- [x] 8.1 `LookBackView` draws a week line as the row it draws a month as, and names the heading over them "Weeks", "Months" or "Months and weeks" from the cases its lines hold, deciding nothing else; the app target builds
- [x] 8.2 Both cards on the page take the secondary grouped background, so they are visible against the page in the dark; the app target builds again after it

## 9. The records

**The ADR amendment and the `CONTEXT.md` edits are written by this Story's proposal commit, not by
the implementation.** These boxes confirm rather than write.

- [x] 9.1 Confirm `CONTEXT.md` § *Look-back* and § *Week* still describe what shipped; a sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in
- [x] 9.2 Confirm ADR-1045's newest amendment still describes what shipped, and that `git diff --stat origin/main... -- openspec/specs/` reports nothing

## 10. The gates

- [x] 10.1 `openspec validate look-back-at-a-quota --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [x] 10.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, `docs/adr/`, `docs/open-questions.md`, the two kit sources, the kit test file and `LookBackView.swift`
- [x] 10.3 `pnpm run check:budgets` warns about nothing in this folder, or each warning is named here with why it stands
- [x] 10.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is thirteen more than a run on `main` reports — the fifteen written in §§ 3–6 less the two deleted in 7.2, both read off runs and neither derived
- [ ] 10.5 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–10.4 and the walk below are ticked and that the instruction here is written for the janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff it produced: `openspec/specs/look-back/spec.md` holds nine requirements, the two this delta removes gone and the four it adds in their place, and no other spec moves. `pnpm run checks` runs after the archive commit exists, and the archive commit is pushed. **Any other drift is a stop and a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.

## The walk

- [ ] W.1 A kept quota commitment's look-back, opened from the commitments screen — the picture shows the "Weeks" heading, the whole, and several week spans newest first with the week in progress on top, both cards legible against the page; run it in the dark appearance (`xcrun simctl ui booted appearance dark` before the run), where they were invisible on PR #289
- [ ] W.2 A stopped quota commitment's look-back — the picture shows the day kept until in the head and its last part week as the newest span, with no week after it
- [ ] W.3 A quota commitment whose roster holds a weekday era removed behind it — the picture shows the "Months and weeks" heading, the weeks above the line where the rhythm changed and the months below it
- [ ] W.4 **The handover** — the three pictures are posted to the PR with `gh pr comment --attach` before hand-back, and this box is ticked on that comment's URL
