## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5). That covers a rebase conflict in this folder or in `openspec/specs/`, a scenario that
cannot be written as a test without changing its title, a test that passes before the code it names
is written, and any other test in the suite turning red. It also covers any shipped scenario's test
that asserts the old behaviour.

Rule 3 governs § 3: take the next unticked box and write the one test named for it in
`src/DayByDayKit/Tests/DayByDayKitTests/CommitmentsScreenTests.swift`. Watch it fail, make it pass,
then take the next. The test's name is the scenario title verbatim, and `pnpm run check:scenarios`
checks it. The MODIFIED floor requirement keeps its six scenario titles and their shipped tests, so
it adds no box.

## 2. The seam

- [ ] 2.1 `CommitmentsScreen.Refusal.recordsAlreadyExist` and the two internal `History` reads exist as in `design.md` § *The seam*, and `change`'s signature is unchanged in `git diff`
- [ ] 2.2 `refusalText` in `src/DayByDay/DayByDay/CommitmentsView.swift` reads the new case as "Records already exist under that.", and the app target builds

## 3. The nine scenarios — one test each

- [ ] 3.1 an interval commitment whose start differs from the day it is kept from is renamed and every day recorded on stays due — catches a rebuild of the interval from the day kept from
- [ ] 3.2 an interval commitment whose start differs from the day it is kept from is put under a category without touching the record place — catches a category change that carries records over
- [ ] 3.3 an interval commitment whose start differs from the day it is kept from saved unchanged changes nothing — catches a no-op check that compares against the rebuilt schedule
- [ ] 3.4 an interval commitment whose start differs from the day it is kept from is renamed on a new rhythm and the superseded one keeps its start — catches a fix to the same-rhythm path only
- [ ] 3.5 moving the day an interval commitment is kept from moves its start to that day even where the two had differed — catches keeping the old start whenever the two had differed
- [ ] 3.6 moving the day a commitment is kept from onto a commitment whose records are already kept is refused for that cause — catches the not-due refusal given for this cause
- [ ] 3.7 renaming a commitment with no records onto a commitment whose records are already kept is refused — catches a check made only where `carryOver` fails
- [ ] 3.8 a name and a rhythm changed in one save onto a commitment whose records are already kept are refused for that cause — catches the superseding path left on the old mapping
- [ ] 3.9 a change that would leave a recorded day not due and meets records already kept is refused as leaving a recorded day not due — catches the records-already-kept check made first

## 4. The records

- [ ] 4.1 Confirm `CONTEXT.md` § *Kept from* still describes what shipped. A sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in
- [ ] 4.2 Confirm neither `openspec/specs/` nor `docs/adr/` was touched by this branch: `git diff --stat origin/main... -- openspec/specs/ docs/adr/` reports nothing

## 5. The gates

- [ ] 5.1 `openspec validate fix-change-refusals --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [ ] 5.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, `CommitmentsScreen.swift`, `History.swift`, `CommitmentsScreenTests.swift` and `CommitmentsView.swift`
- [ ] 5.3 `pnpm run check:budgets` warns about nothing new in this folder, and `pnpm run verify` passes
- [ ] 5.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is nine more than a run on `main` reports — both read off runs, never derived by arithmetic
- [ ] 5.5 **The archive handover. `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–5.4 are ticked and that the instruction below is written here for the janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints. It then reads the spec diff that produced. `openspec/specs/commitment/spec.md` should gain exactly two requirements, *A change leaves an interval commitment's start date where it was unless it names a different day kept from* (five scenarios) and *A commitments screen refuses a change that would carry records onto records already kept* (four scenarios). One clause should change in *A commitment is not due before the day it is kept from*, and nothing else in any spec should move. `pnpm run checks` runs after the archive commit exists. **Any other drift is a stop and a report, never a hand-edit**: rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.
