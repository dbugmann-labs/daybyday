## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5). That covers a rebase conflict in this folder or in `openspec/specs/`, a scenario that
cannot be written as a test without changing its title, a test that passes before the code it names
is written, and any other test in the suite turning red — including one whose fixture seeds a stray
record that carrying back now moves.

Rule 3 governs § 3 and § 4: take the next unticked box and write, or refixture, the one test named
for it in `CommitmentsScreenTests.swift` or `DayScreenTests.swift`. Watch it fail, make it pass, then
take the next. The test's name is the scenario title verbatim, and `pnpm run check:scenarios` checks
it. Never run the `DayByDayUITests` bundle.

## 2. The seam

- [x] 2.1 The public member and the internal members exist as in `design.md` § *The seam*, and neither screen's initializer signature moves in `git diff`

## 3. The nineteen new scenarios — one test each

- [x] 3.1 a change that carries records leaves no save in progress once it is kept — catches a save in progress never taken away
- [x] 3.2 a change that carries no record is kept where nothing beside the record place can be written — catches a save in progress written for every change
- [x] 3.3 a change refused at the roster place after carrying its records leaves no save in progress and a roster still kept — catches the undo left to `try?`
- [x] 3.4 a rename torn between its two places is undone when a commitments screen is opened — catches a commitments screen that never reads the save in progress
- [x] 3.5 a restart torn between its two places is undone when a day screen is opened — catches the dated inverse that refuses
- [x] 3.6 a save in progress for a save its roster took is taken away and nothing else is written — catches a finished save told by `kept` alone
- [x] 3.7 a torn save is undone when a day screen is shown again — catches an undo run only at `init`
- [x] 3.8 a torn save is undone when a day screen is returned to — catches `returnedTo` skipped
- [x] 3.9 a day screen opened on a torn save it cannot undo draws its rows and keeps no tick — catches a tick written over a torn record
- [x] 3.10 a commitments screen opened on a save in progress it cannot read lists nothing and defines nothing — catches an unreadable save in progress ignored
- [x] 3.11 a torn save a day screen could not undo is undone once it is shown again and its places can be written — catches a torn state that never retries
- [x] 3.12 an orphaned record with one possible source is carried back to it when a commitments screen is opened — catches matching on name
- [x] 3.13 an orphaned record is carried back to a removed commitment beside the records it already holds when a day screen is opened — catches `carryOver` reused and removed entries skipped
- [x] 3.14 an orphaned record with two possible sources stays where it is and is said — catches the first match taken
- [x] 3.15 an orphaned record with no possible source stays where it is and is said — catches a rhythm ignored in matching
- [x] 3.16 an orphaned record that would land on a day its source already holds moves none of its records — catches a partial carry back
- [x] 3.17 two orphaned commitments with the same one possible source both stay where they are — catches orphans judged one at a time
- [x] 3.18 a commitments screen stops saying records belong to no commitment once their commitment is taken on — catches the statement read only at `init`
- [x] 3.19 a commitments screen that cannot read its record does not say records belong to no commitment — catches every record called orphaned

## 4. The three refixtured scenarios

- [x] 4.1 renaming a commitment with no records onto a commitment whose records are already kept is refused — refixtured with "Run" as a second possible source
- [x] 4.2 a name and a rhythm changed in one save onto a commitment whose records are already kept are refused for that cause — refixtured so the stray tick shares a day with "Gym"
- [x] 4.3 a change that would leave a recorded day not due and meets records already kept is refused as leaving a recorded day not due — refixtured so the stray tick shares a day with "Gym"

## 5. The shell

- [x] 5.1 `CommitmentsView.swift` says, in the shell's own words beside the roster messages, that some records belong to no commitment wherever `recordsBelongToNoCommitment` is true, and the app target builds

## 6. The records

- [x] 6.1 Confirm `CONTEXT.md` § *Torn save*, § *Orphaned record* and § *Save in progress* still describe what shipped. A sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in
- [x] 6.2 Confirm `openspec/specs/` was not touched by this branch: `git diff --stat origin/main... -- openspec/specs/` reports nothing

## 7. The gates

- [x] 7.1 `openspec validate save-change-whole --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [ ] 7.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, `docs/adr/`, `CommitmentsScreen.swift`, `DayScreen.swift`, `SaveInProgress.swift`, `History.swift`, `RecordStore.swift`, `CommitmentsScreenTests.swift`, `DayScreenTests.swift` and `CommitmentsView.swift`
- [x] 7.3 `pnpm run check:budgets` warns about nothing new in this folder, and `pnpm run verify` passes
- [x] 7.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is nineteen more than a run on `main` reports — both read off runs, never derived by arithmetic
- [ ] 7.5 **The archive handover. `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–7.4 are ticked and that the instruction below is written here for the janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints. It then reads the spec diff that produced. `openspec/specs/commitment/spec.md` should gain exactly five requirements — *A change that carries records leaves a save in progress until its roster place is written* (three scenarios), *Reading the places undoes a torn save as it was* (five), *A torn save that cannot be undone keeps nothing from the record place* (three), *Reading the places carries an orphaned record back to its one possible source* (six) and *A commitments screen says whether any record belongs to no commitment* (two) — and *A commitments screen refuses a change that would carry records onto records already kept* should change only in the fixtures of three of its scenarios. Nothing else in any spec should move. `pnpm run checks` runs after the archive commit exists. **Any other drift is a stop and a report, never a hand-edit**: rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.
