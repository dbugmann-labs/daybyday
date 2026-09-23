## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be
written as a test without changing its title, a new test that passes before the code it names is
written, a fix that reaches outside `LookBack.swift`, `LookBackWords.swift`, `LookBackTests.swift`
and `LookBackView.swift` (the walk's throwaway test aside), or any other test in the suite turning
red. A change to any other file, a comment in one included, is booked as a finding and left alone —
`CONTEXT.md` and `docs/adr/` are this Story's proposal commit's, not the implementation's.

Rule 3 governs §§ 3–4: take the next unticked box, write the one test named for it, watch it fail,
make it pass, then the next. Every test goes in
`src/DayByDayKit/Tests/DayByDayKitTests/LookBackTests.swift`, beside the ones already there.

## 2. The seam

- [x] 2.1 `LookBack.notes`, `LookBack.noteCountInWords` and `LookBack.DatedNote` exist as `design.md` § *The seam* writes them, and 3.1 is red before a note's notes are formed
- [x] 2.2 `History`, `Note`, `Roster`, `Commitment`, `CalendarDate` and `DayScreen` are unchanged, and `openspec/specs/` is untouched (rule 2)
- [x] 2.3 `LookBackWords.notes(_:)` is the one place a count is said, built on `LookBackWords.number(_:)`

## 3. The notes — one test each

- [x] 3.1 a note commitment's look-back says each day's note under its day, newest first — catches the notes said oldest first, a day with no note said as an empty note, or a day said in a form other than the look-back's
- [x] 3.2 a note commitment's look-back says a note's text exactly as the record holds it, line breaks included — catches the text cut, trimmed again, or its line breaks folded into spaces in the kit
- [x] 3.3 a note commitment's look-back says no note where no day holds one — catches a taken-back note still said, a future kept-from walked backwards, or notes said on a tick's look-back
- [x] 3.4 a stopped note commitment's look-back says no note after the day it was kept until — catches notes read off the record unbounded rather than off the days counted
- [x] 3.5 a note commitment's look-back says the notes of every era of its chain — catches the walk reading the newest era alone, or a mark said where one era gives way

## 4. The count — one test each

- [x] 4.1 a note commitment's look-back counts the notes it says — catches a fraction out of the due days, or the count said without its word
- [x] 4.2 a note commitment's look-back that says one note counts it in the singular — catches "1 notes", or a count of the record's notes rather than the ones said
- [x] 4.3 a look-back that says no note says no count — catches "0 notes", or a count said on a tick's look-back

## 5. The removed test and the carried ones

- [x] 5.1 The test named for the scenario this delta removes, "a look-back at a commitment whose days take a note says no line, no whole and no graph", is deleted; no other test is
- [x] 5.2 Every other test in `LookBackTests.swift` passes unchanged, the boundary and identity-chain tests among them

## 6. The shell (ADR-1019: this Story's immediate consumer, no behaviour the kit does not specify)

- [x] 6.1 `LookBackView` draws a note page as `design.md` § *The shell rides this Story* says — `noteCountInWords` as a headline in the "Months" heading's place, one card per note in `notes` order, the day in caption semibold not uppercased — and the app target builds
- [x] 6.2 A folded note is two lines with a tail ellipsis, its line breaks as written; only a card the shell measures as cut is a button, the whole card toggles it, several may be open at once, and every visit opens with all folded
- [x] 6.3 A note page whose look-back says no note says "No note yet." and draws no heading and no card, and the tick, quota, number and total pages keep the sentences they have

## 7. The records

**The ADR amendment and the `CONTEXT.md` edit are written by this Story's proposal commit, not by
the implementation.** This box confirms rather than writes.

- [x] 7.1 Confirm `CONTEXT.md` § *Look-back*'s newest amendment and ADR-1045's newest amendment still describe what shipped; a sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in

## 8. The gates

- [x] 8.1 `openspec validate look-back-at-a-note --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [x] 8.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, `docs/adr/1045-*`, the two kit sources, the kit test file and `LookBackView.swift`
- [x] 8.3 `pnpm run check:budgets` warns about nothing in this folder, or each warning is named here with why it stands
- [x] 8.4 `swift test` in `src/DayByDayKit` passes, and the count it reports against a run on `main` differs by exactly the tests §§ 3–4 write less the one 5.1 deletes, each count read off a run
- [x] 8.5 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–8.4 and the walk below are ticked and that the instruction here is written for the janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff it produced: `openspec/specs/look-back/spec.md` holds eighteen requirements, the one this delta removes gone and the two it adds in its place, every other requirement byte for byte as it was, and no other spec moved. `pnpm run checks` runs after the archive commit exists, and the archive commit is pushed. **Any other drift is a stop and a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.

## The walk

- [x] W.1 A *Journal* note commitment kept every day, notes entered on the day screen on about eight past days — short ones, and ones running past two lines — its look-back opened from the commitments screen: the count heading over one card per note, newest first, each under its day said in full, as "21 September 2026" is, short notes whole and long ones cut at two lines with an ellipsis
- [x] W.2 The W.1 page after tapping one cut note: its card grown to the whole text, the cards below moved down under it, and the cut note beneath it still folded
- [x] W.3 A note written with line breaks, opened, in the dark appearance (`xcrun simctl ui booted appearance dark` before the run): its lines as written, and the cards legible against the page
- [x] W.4 A note commitment with no note: the head, the dates card and "No note yet.", with no count and no card
- [x] W.5 A stopped *Journal* holding one note: the dates card's "KEPT UNTIL" row and "1 note" over its one card
- [x] W.6 **The handover** — all five pictures, W.1–W.5, retaken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL — https://github.com/dbugmann-labs/daybyday/pull/316#issuecomment-5797632380
