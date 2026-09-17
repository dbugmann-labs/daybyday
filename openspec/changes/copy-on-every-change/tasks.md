## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5). That covers a rebase conflict in this folder or in `openspec/specs/`, a scenario that
cannot be written as a test without changing its title, a new test that passes before the code it
names exists, a fix reaching outside the files `proposal.md` § *Impact* names, and any other test in
the suite turning red.

Rule 3 governs §§ 3–11: take the next unticked box, write the one test named for it, watch it fail,
make it pass, then take the next. §§ 3–6 and §§ 9–10 go in a new `CopyPlaceTests.swift`, § 7 and § 8
split between it and `DayScreenTests.swift` where the box names a day screen, and § 11 goes in
`CopyPlaceTests.swift` too. Nothing in `openspec/specs/` is edited here (rule 2).

## 2. The seam

- [x] 2.1 Every member in `design.md` § *The seam* exists with that signature, `CopyPlace` reads and writes its file, and 3.1 is red before any of them does anything but compile

## 3. `restore`: what a copy place is — one test each

- [x] 3.1 a copy place is read back as it was left by one opened again at the same place — catches state held only in memory
- [x] 3.2 a copy place where nothing has been kept holds no folder, no last copy and no stop — catches a missing file throwing
- [x] 3.3 a restore confirmed leaves the folder that is the copy place as it was — catches the copy place written by a restore

## 4. `restore`: a folder given as the copy place — one test each

- [x] 4.1 a folder given as the copy place holds a copy of the three places at once — catches the place set and the copy left to the next change
- [x] 4.2 a copy written at the copy place replaces the file of that name already standing there — catches a dated name or a second file
- [x] 4.3 a folder given as the copy place that cannot be written becomes the copy place with a stop and no last copy — catches the pick refused instead
- [x] 4.4 a folder given in another's stead leaves the file at the folder it replaces as it was — catches the old folder's file deleted

## 5. `restore`: a folder that already holds a copy — one test each

- [x] 5.1 a folder holding a copy asks to restore that copy and sets no copy place — catches the old phone's copy overwritten on one tap
- [x] 5.2 a restore confirmed from a folder given as the copy place makes that folder the copy place — catches the place left unset after the restore
- [x] 5.3 a copy at a folder given as the copy place replaced with this phone's makes that folder the copy place — catches replace restoring first
- [x] 5.4 a folder given as the copy place whose restore is cancelled becomes no copy place and is left as it was — catches cancel setting the place anyway

## 6. `restore`: a folder whose copy cannot be read — one test each

- [x] 6.1 a folder holding a file of a copy's name that is not a copy is refused, and no copy place is set — catches an unreadable file overwritten
- [x] 6.2 a folder holding a damaged copy and one holding a copy from a later version are each refused for their own reason — catches all three told alike
- [x] 6.3 a folder refused leaves the copy place already set, its last copy and its stop as they were — catches a refused pick clearing the place
- [x] 6.4 a folder refused is held apart from a refused change, and ends when the app is shown again — catches `refusedChange` overwritten by it

## 7. `restore`: the copy after a kept change — one test each

- [x] 7.1 a tick kept on a day screen writes a copy at the copy place holding that tick — catches the day screen left out
- [x] 7.2 a one-off added, renamed and removed on a day screen each write a copy at the copy place — catches the one-off place left out
- [x] 7.3 a number, a note and a total entered on a day screen each write a copy at the copy place — catches only the tick path carrying the call
- [x] 7.4 a commitment defined, stopped, taken up again and removed through a commitments screen each write a copy at the copy place — catches one of the four sites missed
- [x] 7.5 a change reaching the record place and the roster place writes exactly one copy holding both — catches a copy per place written
- [x] 7.6 a restore confirmed writes a copy at the copy place holding what was restored — catches the restore path bypassing the copy
- [x] 7.7 a call that keeps nothing writes no copy at the copy place — catches the call made before the write is known to have happened

## 8. `restore`: a copy that cannot be made — one test each

- [x] 8.1 a tick kept where the copy place cannot be written is kept and is not refused — catches the copy made a condition of the change
- [x] 8.2 a folder that cannot be reached is told apart from one that cannot be written — catches both answered as one cause
- [x] 8.3 a change kept where a store cannot be read is kept, and the stop names that store — catches the store unnamed
- [x] 8.4 a stop keeps the moment it began over later changes that also fail — catches the moment reset on every attempt
- [x] 8.5 a change kept after a stop, where the folder can be written again, ends the stop and becomes the last copy — catches a stop that never clears
- [x] 8.6 a copy that could not be made is not held as a refused change — catches the failure pushed into `refusedChange`

## 9. `restore`: what the commitments screen says — one test each

- [x] 9.1 a commitments screen says the name of the folder that is its copy place and the last copy made there — catches a path drawn instead of a name
- [x] 9.2 a commitments screen says the stop and the moment it began beside the last copy made — catches the last copy dropped when a stop stands
- [x] 9.3 a commitments screen with no copy place says no folder, no last copy and no stop — catches a screen that needs a place to open
- [x] 9.4 a copy asked for and made is not the last copy a commitments screen says — catches the share-sheet copy counted
- [x] 9.5 a commitments screen shown again with its folder gone says what the last attempt left — catches the folder probed on being drawn

## 10. `restore`: forgetting the copy place — one test each

- [x] 10.1 a copy place forgotten leaves no folder, no last copy and no stop — catches the stop kept after the place is gone
- [x] 10.2 a copy place forgotten leaves the file at the folder it forgot as it was — catches the file deleted
- [x] 10.3 a change kept after the copy place is forgotten writes no copy and is not refused — catches a stale folder still written to
- [x] 10.4 forgetting where no copy place is set changes nothing — catches a no-op forget writing the file

## 11. `restore`: the writes the app makes on its own — one test each

- [x] 11.1 a torn save undone when a screen is opened writes no copy at the copy place — catches the copy hung off the store's writer
- [x] 11.2 a torn restore undone when a screen is opened writes no copy at the copy place — catches the undo counted as a restore
- [x] 11.3 an orphaned record carried back writes no copy at the copy place — catches a repair mirrored
- [x] 11.4 the commitments a day screen takes on where its roster place holds nothing write no copy — catches day one counted as a change

## 12. `day-screen`: the take-back requirement

- [x] 12.1 the take-back requirement's prose reaches the copy place as well as the record place, and its nine acceptance tests stand unchanged — no scenario of it changes, so no test is added here

## 13. The shell (ADR-1019: no behaviour the kit does not specify)

- [x] 13.1 `ContentView.swift` holds one `CopyPlace`, built with the `momentNow` conversion already beside `today()`, and hands the same instance to both screens
- [x] 13.2 `CommitmentsView.swift` draws the copy place row at the top of the *Copy* section with the folder's name or *Pick a folder*, presents `UIDocumentPickerViewController(forOpeningContentTypes: [.folder])` wrapped as `ShareSheet` wraps its controller, and offers forgetting as a swipe on that row
- [x] 13.3 `CommitmentsView.swift` draws the line as the section's footer — the last copy, and the stop with its reason and since when in the caption red the refusals use — and draws `refusedCopyPlace` in the section
- [x] 13.4 the restore sheet gains *Replace it with this phone's* as a row, under a footer saying what it does, drawn only where the ask came from a folder given as the copy place
- [x] 13.5 `pnpm run verify` passes and the app target builds

## 14. The records

- [x] 14.1 `docs/adr/1058-*.md` stands as `design.md` cites it, with its row in `docs/adr/README.md`; its status reads accepted once G4 is signed
- [x] 14.2 `CONTEXT.md` §§ *Copy place* and *Copy* still describe what shipped; a sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in
- [x] 14.3 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 15. The walk (ADR-1053; `docs/running-the-app.md` § *The walk* has the commands)

- [x] 15.1 the commitments screen scrolled to its foot with no copy place picked: the *Copy place* row reading *Pick a folder*, and the footer offering one
- [x] 15.2 the same screen just after a folder in On My iPhone is picked: the row naming that folder and the footer reading the last copy at this minute
- [x] 15.3 the commitments screen after a tick on the day screen: the footer's last copy moved to the tick's minute
- [x] 15.4 the restore-first sheet, after a folder holding a copy placed there earlier in the run is picked: the moment, both sides' counts, and *Replace it with this phone's*
- [x] 15.5 the commitments screen after the picked folder is deleted and a commitment is defined: the footer's stopped half in red, naming the folder that cannot be reached
- [ ] 15.6 phone: pick a folder in iCloud Drive, tick on the day screen, and see the file change on another device
- [ ] 15.7 phone: delete the picked folder in Files, tick, see the stop and its reason, then forget the copy place and see the row offer picking one again
- [x] 15.8 **The walk handover** — the implementer posts the pictures to the PR as one comment with `gh pr comment --attach`, one per box, before hand-back, and ticks this box on that comment's URL; the throwaway test is deleted, and `src/DayByDay/DayByDayUITests/` merges unchanged — https://github.com/dbugmann-labs/daybyday/pull/291#issuecomment-5710496120 (15.2 and 15.3 re-shot together at G7 round 3, item 4, so the footer's minute moving is visible on the PR; superseding the 15.3-only picture posted at https://github.com/dbugmann-labs/daybyday/pull/291#issuecomment-5710161459, which itself superseded https://github.com/dbugmann-labs/daybyday/pull/291#issuecomment-5704394854)

## 16. The gates

- [x] 16.1 `openspec validate copy-on-every-change --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [x] 16.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, `docs/adr/`, `docs/open-questions.md`, the kit sources and tests, `CommitmentsView.swift` and `ContentView.swift`
- [x] 16.3 `pnpm run check:budgets` warns about this folder only for the one MODIFIED requirement `day-screen` carries whole
- [x] 16.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is forty-two more than a run on `main` reports, both read off runs — one of the forty-two, `aCopyPlaceResolvesItsFolderFromTheBookmarkOnceThePlainPathNoLongerPointsThere`, has no scenario behind it because it is a G7 regression test below the seam, seeding the state file to reach the bookmark branch of `resolvedFolder()` that no scenario's wording tells apart from the plain path
- [ ] 16.5 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–16.4 are ticked, 15.6 and 15.7 included once the owner has walked them, and that this instruction is written here for the janitor. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints. It then reads the spec diff that produced: `openspec/specs/restore/spec.md` gains nine requirements; `day-screen/spec.md` changes one requirement by one clause and gains no scenario. Nothing else in any spec may move. `pnpm run checks` runs after the archive commit exists. **Any other drift is a stop and a report, never a hand-edit**: rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.
