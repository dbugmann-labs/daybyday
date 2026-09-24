Anything that fails or surprises is a stop and a report, never a workaround (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a new test that passes before the code it names is written, any carried
test turning red or needing an edit, or a fix reaching outside the files `proposal.md` § *Impact*
names. Rule 3 throughout: take the next unticked scenario box, write the one test named for it,
watch it fail, make it pass, then the next.

## 1. Before a line is written

- [ ] 1.1 From the repo root, `pnpm run check:scenarios` names this change's uncovered scenarios; they are exactly the nineteen titles boxed in §§ 3–8. Any other uncovered title is a stop.
- [ ] 1.2 New tests go in a new `src/DayByDayKit/Tests/DayByDayKitTests/BirthdayCopyTests.swift`, but 8.2, which goes in `DayScreenBirthdayTests.swift`; every place is a fresh directory, and a birthday place a test does not name is left to the default beside its record place.

## 2. The seam

- [ ] 2.1 The members in `design.md` § *The seam* exist with those signatures, and 3.1 is red before `Copy` holds any tick
- [ ] 2.2 A screen or copy place given no birthday place keeps its ticks at `birthday-ticks.json` beside its record place; `DayScreen.birthdayPlace` is unchanged
- [ ] 2.3 `CopyDocument.currentVersion` is 2, and every hand-built form-1 fixture in the carried tests still reads

## 3. `restore`: a copy's birthday ticks

- [ ] 3.1 a copy holds the birthday ticks the birthday place holds, and none where nothing has been kept there — catches a copy formed from the three places alone
- [ ] 3.2 a copy is refused whole where the birthday ticks cannot be read, naming them only where the other three stores read — catches the ticks named before the one-offs
- [ ] 3.3 a change kept where the birthday ticks cannot be read is kept, and the stop names the birthday ticks — catches the stop naming the record by default
- [ ] 3.4 a day screen, a commitments screen and a copy place given no birthday place keep their birthday ticks at the same place — catches a default at the real file

## 4. `restore`: reading a copy

- [ ] 4.1 a copy made before copies held birthday ticks is read as holding none, and restoring it leaves the birthday place holding none — catches a form-1 copy read as damaged
- [ ] 4.2 a copy whose birthday ticks do not read is refused as a damaged copy, and one whose birthday ticks are of a later form as a copy from a later version — catches the ticks left out of the envelope pre-check

## 5. `restore`: a restore

- [ ] 5.1 a commitments screen asked to restore counts no birthday tick, and says the phone's birthday ticks cannot be read only where they cannot
- [ ] 5.2 a restore confirmed makes the birthday place hold the copy's birthday ticks, and the ticks there are gone — catches a merge
- [ ] 5.3 a restore refused where the birthday place cannot be written leaves the four places as they were — catches a rollback of three
- [ ] 5.4 a restore stopped before it was whole is undone at the birthday place when the places are next opened — catches an old restore in progress deleting the ticks

## 6. `restore`: a birthday tick's copy

- [ ] 6.1 a birthday tick kept on a day screen writes a copy at the copy place holding that tick
- [ ] 6.2 a birthday tick refused, or asked of a row that offers none, writes no copy at the copy place — catches `keptAChange()` before the guard or the throw

## 7. `restore`: the take-out

- [ ] 7.1 a take-out hands out the file at the birthday place byte-for-byte under the name it lies under
- [ ] 7.2 a commitments screen offers a take-out over birthday ticks that cannot be read, naming them after the one-offs
- [ ] 7.3 a commitments screen holding a restore in progress it could not undo names the birthday ticks only where they cannot be read — catches `Copy.Store.allCases` in the undo guard
- [ ] 7.4 a commitments screen asked for a take-out answers the birthday ticks' file after the one-offs' and before a save in progress
- [ ] 7.5 a take-out refused over the birthday place names the birthday ticks and hands out none of the others — catches the ticks named as the record

## 8. The day screen

- [ ] 8.1 a day screen that says its birthday ticks could not be read says a copy can be restored, and says nothing of it while birthdays are off — catches the line read off the ticks' state alone
- [ ] 8.2 a day screen returned to after a restore draws the birthday ticks the copy holds — catches a stale birthday store

## 9. The carried scenarios

- [ ] 9.1 Every scenario the five MODIFIED `restore` requirements and the MODIFIED `day-screen` requirement carry passes with its test unedited, and so does every other test in the suite

## 10. The shell (ADR-1019: no rule the Kit does not state)

- [ ] 10.1 `CommitmentsView.swift` says the birthday ticks' lines as `design.md` § *The shell* gives them, words verbatim, each after the one-offs' line
- [ ] 10.2 The app target builds for the simulator, and `ContentView.swift` is unchanged

## 11. The records

- [ ] 11.1 Confirm `CONTEXT.md` § *Birthday place*, *Copy*, *Restore* and *Take-out* still describe what shipped; a sentence that turns out wrong is a stop and a G4 question, never an edit
- [ ] 11.2 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## The walk

- [ ] W.1 The commitments screen with birthdays off and `birthday-ticks.json` replaced by a run of bytes, after *Make a copy* is tapped — the refused copy saying *Your birthday ticks could not be read.*, and *Take out the files* with its caption naming the birthday ticks.
- [ ] W.2 In that state, the restore sheet for a copy made before the ticks were damaged — under *Your phone*, *Your birthday ticks could not be read.* after the one-offs line.
- [ ] W.3 phone: tick a birthday, make a copy, take the tick back, restore that copy — the tick is back on the day screen.
- [ ] W.4 phone: tick a birthday — the commitments screen's copy-place line shows a new last copy.
- [ ] W.5 **The handover** — W.1–W.2, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL. W.3 and W.4 are the human's at G7; the conductor ticks them on the G7 approval.

## 12. Gates and the archive handover

- [ ] 12.1 `openspec validate carry-birthdays-in-a-copy --strict` exits 0, and `pnpm run checks` is clean
- [ ] 12.2 `pnpm run verify` green, and `swift test` from `src/DayByDayKit` passing, its count read off the run
- [ ] 12.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 12.4 **The implementer ticks this box in its last commit before the archive**, on the evidence that every other box is ticked — W.3 and W.4 by the conductor at G7 — and the walk comment's URL is in W.5. The janitor then runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, and checks afterwards that `openspec/specs/restore/spec.md` gained six requirements, renamed one, and holds its five MODIFIED ones whole; that `openspec/specs/day-screen/spec.md` changed one requirement by one sentence and one scenario; and that no other spec file moved. **Any drift is a stop and a report, never a hand-edit.**
