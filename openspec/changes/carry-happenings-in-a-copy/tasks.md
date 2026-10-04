Anything that fails or surprises is a stop and a report, never a workaround (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a new test that passes before the code it names is written, any carried
test turning red or needing an edit § 9 does not name, or a fix reaching outside the files
`proposal.md` § *Impact* names. Rule 3 throughout: take the next unticked scenario box, write the one
test named for it, watch it fail, make it pass, then the next. The four boxes in § 8 are the one
exception: each renames a carried test, and is green before and after.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` names this change's uncovered scenarios; they are exactly the twenty-five titles boxed in §§ 3–8. Any other uncovered title is a stop.
- [x] 1.2 New tests go in a new `src/DayByDayKit/Tests/DayByDayKitTests/HappeningCopyTests.swift`; every place is a fresh directory, and a happening place a test does not name is left to the default beside its record place.

## 2. The seam

- [x] 2.1 The members in `design.md` § *The seam* exist with those signatures, and 3.1 is red before `Copy` holds any happening
- [x] 2.2 `CopyDocument.currentVersion` is 3, and every hand-built form-1 and form-2 fixture in the carried tests still reads
- [x] 2.3 `HappeningStore.init(at:)` and `CopyDocument.read` refuse through the one `HappeningStore.formed(from:)`

## 3. `restore`: a copy's happenings

- [x] 3.1 a copy holds the happenings and occurrences the happening place holds, and none where nothing has been kept there — catches a copy that drops stopped happenings
- [x] 3.2 a copy is refused whole where the happenings cannot be read, naming them only where the other four stores read — catches the happenings named before the birthday ticks
- [x] 3.3 a change kept where the happenings cannot be read is kept, and the stop names the happenings — catches the stop naming the record by default
- [x] 3.4 a copy place given no happening place copies the happenings a commitments screen given none keeps — catches a copy place defaulting to the real file

## 4. `restore`: reading a copy

- [x] 4.1 a copy made before copies held happenings is read as holding none, and restoring it leaves the happening place holding none — catches a form-2 copy read as damaged
- [x] 4.2 a copy whose happenings do not fit together is refused as a damaged copy, and one whose happenings are of a later form as a copy from a later version — catches the happenings left out of the envelope pre-check

## 5. `restore`: a restore

- [x] 5.1 a commitments screen asked to restore says how many happenings the copy and the phone hold and have stopped, and counts no occurrence — catches stopped happenings counted twice
- [x] 5.2 a commitments screen asked to restore where the happening place cannot be read says the happenings cannot be read in place of their counts
- [x] 5.3 a restore confirmed makes the happening place hold the copy's happenings, and the happenings there are gone — catches a merge
- [x] 5.4 a commitments screen that restored a copy lists the copy's happenings, and no happening is awaiting a stop or a deletion — catches a stale happening list
- [x] 5.5 a restore refused where the happening place cannot be written leaves the five places as they were — catches a rollback of four
- [x] 5.6 a restore stopped before it was whole is undone at the happening place when the places are next opened — catches `returnedTo` reading before the undo

## 6. `restore`: a happening change's copy

- [x] 6.1 a happening made, renamed, stopped, resumed and deleted through a commitments screen each write a copy at the copy place
- [x] 6.2 an occurrence noted, changed and taken back on a day screen each write a copy at the copy place
- [x] 6.3 a happening change refused, or one that asks for no change, writes no copy at the copy place — catches `keptAChange()` before a guard
- [x] 6.4 an occurrence noted where the copy place cannot be written is kept and is not refused

## 7. `restore`: the take-out and the day screen's restore line

- [x] 7.1 a take-out hands out the file at the happening place byte-for-byte under the name it lies under
- [x] 7.2 a commitments screen offers a take-out over happenings that cannot be read, naming them after the birthday ticks — catches `Copy.Store.allCases` in the undo guard
- [x] 7.3 a commitments screen asked for a take-out answers the happenings' file after the birthday ticks' and before a save in progress
- [x] 7.4 a take-out refused over the happening place names the happenings and hands out none of the others
- [x] 7.5 a day screen that cannot read its happenings says a copy can be restored, and says nothing of it where they were written by a later version — and, in the same commit, `DayScreenHappeningTests.swift`'s carried test for *a day screen that cannot read its happening place lists none and leaves the place as it was* drops its `!saysACopyCanBeRestored` assertion and nothing else

## 8. The retitled scenarios (a rename, not a red-green cycle)

- [x] 8.1 making and renaming a happening leaves the other places as they were — `CommitmentsScreenHappeningTests.swift`'s test renamed to it, its two `lastCopy` assertions dropped
- [x] 8.2 stopping, resuming and deleting a happening leaves the other places as they were — `CommitmentsScreenHappeningStopTests.swift`'s test likewise
- [x] 8.3 noting an occurrence leaves the other places as they were and ends a notice — `DayScreenHappeningTests.swift`'s test likewise
- [x] 8.4 changing or taking back an occurrence leaves the other places as they were and ends a notice — `DayScreenOccurrenceChangeTests.swift`'s test likewise

## 9. The carried scenarios

- [x] 9.1 Every scenario the five MODIFIED `restore` requirements, the two MODIFIED and two re-added `day-screen` requirements and the re-added `happening` requirement carry passes with its test unedited, and so does every other test in the suite, but these seven places: the four tests § 8 renames, the one assertion 7.5 drops, and the `laterFormBytes` helpers in `CopyTests.swift` and `TakeOutTests.swift`, which each gain the `case .happenings:` arm the enum now needs

## 10. The shell (ADR-1019: no rule the Kit does not state)

- [x] 10.1 `SettingsView.swift` says the happenings' lines and the restore sheet's count as `design.md` § *The shell's words* gives them, words verbatim, laid out as § *What the shell draws*
- [x] 10.2 The app target builds for the simulator, and `ContentView.swift` and `CommitmentsView.swift` are unchanged

## 11. The records

- [x] 11.1 Confirm `CONTEXT.md` § *Happening place*, *Happening store*, *Copy*, *Restore* and *Take-out* still describe what shipped; a sentence that turns out wrong is a stop and a G4 question, never an edit
- [x] 11.2 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## The walk

- [x] W.1 Settings' restore sheet for a copy made holding "Kopfweh" and "Augenmigräne", "Augenmigräne" stopped, after "Kopfweh" was deleted — *The copy* ends *1 happening(s), has stopped 1*, *Your phone* ends *0 happening(s), has stopped 1*.
- [x] W.2 The commitments screen opened right after that restore is confirmed — its happening list holds "Kopfweh" and "Augenmigräne", "Augenmigräne" said to be stopped.
- [x] W.3 The day screen with `happenings.json` replaced by a run of bytes — *The happenings could not be read.* with *A copy can be restored from Settings* under it.
- [x] W.4 Settings in that state — *Take out the files*, its caption saying *Your happenings could not be read.*
- [x] W.5 **The handover** — W.1–W.4, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL: https://github.com/dbugmann-labs/daybyday/pull/389#issuecomment-5981717895

## 12. Gates and the archive handover

- [x] 12.1 `openspec validate carry-happenings-in-a-copy --strict` exits 0, and `pnpm run checks` is clean
- [x] 12.2 `pnpm run verify` green, and `swift test` from `src/DayByDayKit` passing, its count read off the run
- [ ] 12.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 12.4 **The implementer ticks this box in its last commit before the archive**, on the evidence that every other box is ticked and the walk comment's URL is in W.5. The janitor then runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, and checks afterwards that `openspec/specs/restore/spec.md` gained seven requirements, renamed one, and holds its five MODIFIED ones whole; that `openspec/specs/happening/spec.md` lost one requirement and gained it back under its new name; that `openspec/specs/day-screen/spec.md` did the same for two and changed two more; and that no other spec file moved. **Any drift is a stop and a report, never a hand-edit.**
