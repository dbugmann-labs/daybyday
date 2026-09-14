## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5). That covers a rebase conflict in this folder or in `openspec/specs/`, a scenario that
cannot be written as a test without changing its title, a test that passes before the code it names
is written, and any other test in the suite turning red.

Rule 3 governs § 3: take the next unticked box and write the one test named for it in
`src/DayByDayKit/Tests/DayByDayKitTests/CommitmentsScreenTests.swift`. Watch it fail, make it pass,
then take the next. The test's name is the scenario title verbatim, and `pnpm run check:scenarios`
checks it. Never run the `DayByDayUITests` bundle.

## 2. The seam

- [x] 2.1 The public members and the two internal `carryOver(_:to:onOrAfter:)` members exist as in `design.md` § *The seam*, and `change`'s signature is unchanged in `git diff`

## 3. The twelve scenarios — one test each

- [x] 3.1 an interval commitment restarted from today is kept until yesterday and runs on from today under its name, interval and category — catches a whole-history carry-over and a lost category
- [x] 3.2 restarting an interval commitment carries every record on or after the day it restarts from onto the restarted commitment — catches a restart that carries nothing
- [x] 3.3 an interval commitment restarted from the day it is kept from is kept on no date before the restart — catches the original kept-from day kept on the restarted commitment
- [x] 3.4 an interval commitment restarted through a commitments screen draws one row on a day screen on either side of the restart — catches a supersede as of the picked day rather than the day before
- [x] 3.5 a restart from a day after today, a day before the day kept from, or a day the rhythm is already due on is refused, each told apart — catches one refusal for all three
- [x] 3.6 a restart that would leave a day recorded on after it not due is refused — catches records after the day silently left behind
- [x] 3.7 a restart onto a commitment whose records are already kept is refused for that cause — catches stray records adopted by the restart
- [x] 3.8 a restart whose result the roster already holds is refused as a commitment already kept — catches a removed duplicate taken up again
- [x] 3.9 a restart refused at the roster place after its records were carried over leaves the record place as it was — catches a carry-over not undone
- [x] 3.10 a restart a commitments screen could not carry over at the record place leaves the roster place as it was — catches the roster written first
- [x] 3.11 a commitments screen says only a kept interval commitment can be restarted — catches `canRestart` true on a stopped or weekday commitment
- [x] 3.12 a restart asked of a commitment that cannot be restarted does nothing and says nothing — catches a refusal held for an act never offered

## 4. The shell

- [x] 4.1 `CommitmentsView.swift`'s change sheet draws a *Restart* section only where `canRestart` is true, with a date picker bounded by the kept-from day and `dayToKeepFrom` and opening on `dayToKeepFrom`, and a button that calls `restart` and closes the sheet on `nil`
- [x] 4.2 `refusalText` reads the three new cases in words of the shell's own, and the app target builds

## 5. The records

- [x] 5.1 Confirm `CONTEXT.md` § *Restarting* and § *Commitments screen* still describe what shipped. A sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in
- [x] 5.2 Confirm neither `openspec/specs/` nor `docs/adr/` was touched by this branch: `git diff --stat origin/main... -- openspec/specs/ docs/adr/` reports nothing

## 6. The gates

- [x] 6.1 `openspec validate add-interval-restart --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [x] 6.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, `CommitmentsScreen.swift`, `History.swift`, `RecordStore.swift`, `CommitmentsScreenTests.swift` and `CommitmentsView.swift`
- [x] 6.3 `pnpm run check:budgets` warns about nothing new in this folder, and `pnpm run verify` passes
- [x] 6.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is twelve more than a run on `main` reports — both read off runs, never derived by arithmetic
- [x] 6.5 **The archive handover. `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–6.4 are ticked and that the instruction below is written here for the janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints. It then reads the spec diff that produced. `openspec/specs/commitment/spec.md` should gain exactly three requirements: *A commitments screen restarts an interval commitment it keeps, from a day it is given* (four scenarios), *A commitments screen refuses a restart it cannot make* (six), and *A commitments screen says whether a commitment can be restarted, and offers the day it was handed to restart from* (two). Nothing else in any spec should move. `pnpm run checks` runs after the archive commit exists. **Any other drift is a stop and a report, never a hand-edit**: rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.
