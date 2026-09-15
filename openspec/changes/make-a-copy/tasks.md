## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written
as a test without changing its title, a new test that passes before the code it names is written, a
fix that reaches outside the files `proposal.md` § *Impact* names, or any other test in the suite
turning red.

Rule 3 governs §§ 3–5: take the next unticked box, write the one test named for it, watch it fail,
make it pass, then the next. §§ 3 and 4 go in a new `CopyTests.swift`; § 5 in
`CommitmentsScreenTests.swift`. Nothing in `openspec/specs/` is edited here (rule 2).

## 2. The seam

- [x] 2.1 Every member in `design.md` § *The seam* exists with that signature, and 3.1 is red before they do anything but compile

## 3. `restore`: what a copy is — one test each

- [x] 3.1 a copy holds the history, the roster and the one-offs the three places hold — catches a copy of two stores
- [x] 3.2 a copy of three places where nothing has been kept is made and holds nothing — catches an empty place refusing the copy
- [x] 3.3 a copy is formed from what the places hold when it is asked for, not from what a screen read — catches the screen's own roster copied
- [x] 3.4 a copy taken where a save was torn holds what undoing the torn save leaves — catches the places read without `undoTornSave`
- [x] 3.5 a copy is refused whole where one of the three places cannot be read — catches an unreadable store copied as nothing kept
- [x] 3.6 a copy refused with more than one place unreadable names the record before the roster and the roster before the one-offs — catches whichever failure is noticed first being named
- [x] 3.7 a copy carries the moment it was handed, and the places it was read from carry none — catches a clock read in the kit
- [x] 3.8 a moment is refused where its hour or its minute is not one the clock has — catches an unchecked hour
- [x] 3.9 what is written for a copy holds its own form, its moment and the three stores as they are written now — catches the copy's form left out of the file
- [x] 3.10 a copy of a place kept in an earlier form is written in the form that store writes now — catches the file's bytes copied

## 4. `restore`: the screen, the file and the refusal — one test each

- [x] 4.1 a commitments screen asked for a copy writes one file and answers where it wrote it — catches a second file left beside it
- [x] 4.2 a copy made leaves a commitments screen's lists and what it is awaiting exactly as they were — catches the lists refreshed by the copy's read
- [x] 4.3 a commitments screen that cannot read its roster is still asked for a copy — catches the ask withheld where the roster is not kept
- [x] 4.4 a copy's name says the day and the minute it was made, each part padded — catches an unpadded month or hour
- [x] 4.5 a copy written where a copy of that name already stands replaces it — catches a second file or a refusal
- [x] 4.6 a copy that cannot be written is refused as a place that could not be written — catches the write failure told as a store that could not be read
- [x] 4.7 a copy refused because a store could not be read leaves the three places as they were — catches a place written on the way to a refusal

## 5. `commitment`: the refused change — one test each

- [x] 5.1 a commitments screen holds a refused copy against making a copy, naming the store that could not be read — catches a store named where the copy could not be written
- [x] 5.2 a copy made does not end what a commitments screen holds about a refused change — catches the refused change cleared by a successful copy

## 6. The shell (ADR-1019: this Story's immediate consumer, no behaviour the kit does not specify)

- [x] 6.1 `CommitmentsView.swift` draws the copy section below *Stopped* with its one row, forms a `Moment` beside `today()`, and presents the share sheet over the URL `makeACopy` answers, as `design.md` § *The shell* says
- [x] 6.2 The copy section draws the held refused change through `refusalText`, naming the store for a store that could not be read, as `design.md` § *The shell* says
- [x] 6.3 `src/DayByDay/Info.plist` declares the exported type and the app target's two configurations carry `INFOPLIST_FILE = Info.plist` with `GENERATE_INFOPLIST_FILE` kept; the built app's `Info.plist` holds both the generated keys and the declaration, read off a build
- [x] 6.4 `pnpm run verify` passes and the app target builds

## 7. The records

- [x] 7.1 `docs/adr/1054-*.md` is written as `design.md` § *A copy is the values, not the files* cites it, and `docs/adr/README.md` gains its row
- [x] 7.2 `CONTEXT.md` gains **Moment** as a term of its own and its § *Copy* still describes what shipped; a sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in
- [x] 7.3 Confirm `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 8. The walk (ADR-1053; `docs/running-the-app.md` § *The walk* has the commands)

- [ ] 8.1 the commitments screen scrolled to its foot on the day-one roster: the copy section below *Stopped*, its one row drawn
- [ ] 8.2 the share sheet up over the commitments screen after that row is tapped: the copy's file name readable on the sheet
- [ ] 8.3 the copy refused: the app run with the record file at its container replaced by bytes that are not a record, the row tapped, the refusal drawn in the copy section naming the record
- [ ] 8.4 phone: save the copy to Files from the share sheet and open it there
- [ ] 8.5 **The walk handover** — the implementer posts the pictures to the PR as one comment with `gh pr comment --attach`, one per box, before hand-back, and ticks this on that comment's URL; the throwaway test is deleted and `src/DayByDay/DayByDayUITests/` merges unchanged

## 9. The gates

- [ ] 9.1 `openspec validate make-a-copy --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [ ] 9.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, `docs/adr/`, the kit sources and tests, `CommitmentsView.swift`, `src/DayByDay/Info.plist` and the project file
- [ ] 9.3 `pnpm run check:budgets` warns about this folder only for *A commitments screen holds the change it refused and why it was refused, one at a time* and *What a commitments screen holds about a refused change lasts until the app is shown again or a change is kept*, both carried whole from `main` over budget and grown by the sentences `design.md` § *Two `commitment` requirements MODIFIED* names
- [ ] 9.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is nineteen more than a run on `main` reports — both read off runs
- [ ] 9.5 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–9.4 are ticked and that the instruction below is written here for the janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff it produced: `openspec/specs/restore/spec.md` is created with five requirements and seventeen scenarios; `openspec/specs/commitment/spec.md` changes two requirements — one by two sentences and one new scenario, one by one sentence and one new scenario — and nothing else in any spec moves. `pnpm run checks` runs after the archive commit exists. **Any other drift is a stop and a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.
