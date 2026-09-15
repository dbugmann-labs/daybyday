## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5). That covers a rebase conflict in this folder or in `openspec/specs/`, a scenario that
cannot be written as a test without changing its title, and a new test that passes before the code
it names exists. It also covers a fix that reaches outside the files `proposal.md` § *Impact* names,
and any other test in the suite turning red.

Rule 3 governs §§ 3–8: take the next unticked box, write the one test named for it, watch it fail,
make it pass, then take the next. §§ 3–6 go in a new `RestoreTests.swift`, § 7 in
`DayScreenTests.swift` and § 8 in `CommitmentsScreenTests.swift`. Nothing in `openspec/specs/` is
edited here (rule 2).

## 2. The seam

- [x] 2.1 Every member in `design.md` § *The seam* exists with that signature, and 3.1 is red before they do anything but compile

## 3. `restore`: reading a copy — one test each

- [x] 3.1 a file that does not read as a copy's form and moment is refused as not a copy — catches the extension trusted
- [x] 3.2 a copy whose own form is later than this app reads is refused as a copy from a later version — catches a nested store's form left unchecked
- [x] 3.3 a copy holding a store that does not read is refused as a damaged copy — catches `Codable` alone standing in for the form's shape checks
- [x] 3.4 a copy holding a store of a later form beside a store that does not read is refused as a copy from a later version — catches damage checked first
- [x] 3.5 a copy holding stores in the earliest forms they are read in is read as what those forms hold — catches only the current form read

## 4. `restore`: what is said first — one test each

- [x] 4.1 a commitments screen asked to restore says the copy's moment and what the copy and the phone keep, have stopped and hold as one-offs — catches a removed commitment counted
- [x] 4.2 a commitments screen asked to restore where a place cannot be read says that store cannot be read in place of its counts — catches an unreadable store counted as zero
- [x] 4.3 a restore asked for and cancelled leaves a commitments screen and its three places as they were — catches cancelling clearing what the screen awaited
- [x] 4.4 a restore awaiting confirmation stands when the app is shown again and is replaced by another ask — catches `shown` dropping it

## 5. `restore`: a restore confirmed — one test each

- [x] 5.1 a restore confirmed makes the three places hold what the copy holds, and what they held is gone — catches a merge
- [x] 5.2 a restore confirmed over places that cannot be read replaces what is there — catches a restore withheld where a store will not open
- [x] 5.3 a copy of nothing restored leaves the three places holding nothing — catches an empty store skipped rather than written
- [x] 5.4 a copy holding stores in earlier forms is restored in the forms each store writes now — catches the copy's nested bytes written as they lie
- [x] 5.5 a restore confirmed takes away a save in progress that could not be undone — catches a stale carry applied to the restored record
- [x] 5.6 a commitments screen that restored a copy lists what the copy holds and has nothing awaiting — catches the lists left as they were before
- [x] 5.7 a commitments screen that restored a copy holds that copy's moment until the app is shown again or a change is kept — catches a refusal ending it

## 6. `restore`: a restore that cannot be made whole — one test each

- [x] 6.1 a restore refused where the one-off place cannot be written leaves the record and the roster places as they were — catches no rollback
- [x] 6.2 a restore stopped before it was whole is undone when the places are next opened — catches a reader that skips `undoTornRestore`
- [x] 6.3 a restore in progress that cannot be undone leaves a screen reading nothing from the three places — catches day one written over a withheld roster

## 7. `restore`: the day screen after a restore — one test each

- [x] 7.1 a day screen returned to after a restore draws the copy's commitments, records and one-offs — catches the one-offs left unread
- [x] 7.2 a day screen that was keeping no record keeps the copy's record once returned to after a restore — catches the kept-only record read
- [x] 7.3 a day screen returned to after a restore tells nothing it was telling — catches `nameRefusal` left standing
- [x] 7.4 a day screen returned to after a restore keeps the today it was handed and the day it was showing — catches `shown` reused
- [x] 7.5 a day screen returned to from a commitments screen that restored no copy does not read its record again — catches every return reading everything
- [x] 7.6 a day screen returned to from a commitments screen that restored a copy and then kept a change opens all three places — catches `copyRestored` read in place of the flag
- [x] 7.7 a day screen returned to after a copy of nothing was restored takes on the commitments it was handed — catches day one suppressed

## 8. `commitment`: the refused change — one test each

- [x] 8.1 a commitments screen holds a refused restore against restoring a copy, naming no store — catches the refusal held as making a copy
- [x] 8.2 what a commitments screen holds about a refused change stands when a restore is confirmed with none awaiting confirmation — catches a no-op confirm clearing it
- [x] 8.3 what a commitments screen holds about a refused change ends when a copy is restored — catches the refused change surviving a restore
- [x] 8.4 what a commitments screen holds about a refused change stands when a restore is asked for and cancelled — catches the ask clearing it

## 9. The shell (ADR-1019: no behaviour the kit does not specify)

- [x] 9.1 `CommitmentsView.swift` draws *Restore from a copy* in the copy section, presents `.fileImporter` for the exported type, brackets `askToRestore` in security-scoped access, and draws the confirmation sheet, the refusals and `copyRestored` as `design.md` § *The shell* says
- [x] 9.2 `ContentView.swift` calls `returnedTo(from:)` with the commitments screen it holds
- [x] 9.3 `pnpm run verify` passes and the app target builds

## 10. The records

- [ ] 10.1 `docs/adr/1056-*.md` stands as `design.md` cites it, with its row in `docs/adr/README.md`; its status reads accepted once G4 is signed
- [ ] 10.2 `CONTEXT.md` § *Restore in progress* and § *Restore* still describe what shipped; a sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in
- [x] 10.3 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 11. The walk (ADR-1053; `docs/running-the-app.md` § *The walk* has the commands)

- [ ] 11.1 the commitments screen scrolled to its foot on the day-one roster: the copy section with *Make a copy* and *Restore from a copy*
- [ ] 11.2 the confirmation sheet, after a copy saved to On My iPhone earlier in the run is picked and one commitment stopped since: the moment and the counts on both sides
- [ ] 11.3 the commitments screen after *Restore* is tapped: the lists as the copy held them and the line naming the copy restored
- [ ] 11.4 the day screen returned to: the rows the copy holds, the stopped commitment drawn again
- [ ] 11.5 a damaged copy picked, one placed in On My iPhone by the run: the refusal drawn in the copy section
- [ ] 11.6 phone: make a copy and save it to Files, change something, pick that copy, check the counts, restore, and see both screens come back as they were
- [ ] 11.7 **The walk handover** — the implementer posts the pictures to the PR as one comment with `gh pr comment --attach`, one per box, before hand-back, and ticks this box on that comment's URL; the throwaway test is deleted, and `src/DayByDay/DayByDayUITests/` merges unchanged

## 12. The gates

- [x] 12.1 `openspec validate restore-from-a-copy --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [ ] 12.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, `docs/adr/`, the kit sources and tests, `CommitmentsView.swift` and `ContentView.swift`
- [ ] 12.3 `pnpm run check:budgets` warns about this folder only for the five MODIFIED requirements `design.md` § *Three capabilities, every block whole* names
- [ ] 12.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is thirty more than a run on `main` reports, both read off runs
- [ ] 12.5 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–12.4 are ticked, 11.6 included once the owner has walked it, and that this instruction is written here for the janitor. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints. It then reads the spec diff that produced: `openspec/specs/restore/spec.md` gains five requirements; `commitment/spec.md` changes two requirements and gains four scenarios; `day-screen/spec.md` changes four requirements by one clause each and gains no scenario. Nothing else in any spec may move. `pnpm run checks` runs after the archive commit exists. **Any other drift is a stop and a report, never a hand-edit**: rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.
