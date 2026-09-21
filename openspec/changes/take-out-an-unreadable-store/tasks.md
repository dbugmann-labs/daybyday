## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5). That covers a rebase conflict in this folder or in `openspec/specs/`, a scenario that
cannot be written as a test without changing its title, a new test that passes before the code it
names exists, a fix reaching outside the files `proposal.md` § *Impact* names, and any other test in
the suite turning red.

Rule 3 governs §§ 3–8: take the next unticked box, write the one test named for it, watch it fail,
make it pass, then take the next. §§ 3–6 go in a new `TakeOutTests.swift`, § 7 in
`DayScreenTests.swift`, § 8.1 in `CopyTests.swift` and § 8.2 in `CopyPlaceTests.swift`. Nothing in
`openspec/specs/` is edited here (rule 2).

## 2. The seam

- [ ] 2.1 Every member in `design.md` § *The seam* exists with that signature, `readStores` answers the cause per store, and 3.1 is red before `takeOut` hands out anything

## 3. `restore`: what a take-out is — one test each

- [ ] 3.1 a take-out hands out the three files byte-for-byte under the names they lie under — catches a store read as a value and written out again
- [ ] 3.2 a take-out where nothing has been kept at a place hands out only the files that stand — catches an empty place refusing the take-out
- [ ] 3.3 a take-out hands out a save in progress and a restore in progress that could not be undone — catches the two in-progress files left behind
- [ ] 3.4 a take-out does not hand out the copy place — catches every file in the directory swept up

## 4. `restore`: when a take-out is offered, and what it says — one test each

- [ ] 4.1 a commitments screen whose three places all read offers no take-out — catches a permanent raw-file export
- [ ] 4.2 a commitments screen offers a take-out naming every place that cannot be read, in the order record, roster, one-offs — catches only the first store named
- [ ] 4.3 a commitments screen offers a take-out over a store written by a later version, and says so rather than that it could not be read — catches the two causes answered alike
- [ ] 4.4 a commitments screen shown again says what the three places then hold — catches the places read once at opening, or read on being drawn
- [ ] 4.5 a commitments screen that confirmed a restore offers no take-out — catches the offer left standing over readable places
- [ ] 4.6 a commitments screen holding a save in progress it could not undo offers a take-out naming all three — catches the one-off place never opened

## 5. `restore`: taking the files out — one test each

- [ ] 5.1 a commitments screen asked for a take-out answers where every file was written, in the order record, roster, one-offs — catches an unordered answer or a fourth file written
- [ ] 5.2 a take-out made leaves a commitments screen's lists and what it is awaiting exactly as they were — catches the screen re-read by the take-out
- [ ] 5.3 a take-out made leaves a refused change standing and says nothing of its own — catches a refused copy cleared, or a date held afterwards
- [ ] 5.4 a take-out asked for where a commitments screen offers none hands out nothing and writes nothing — catches the files handed out on a working phone
- [ ] 5.5 a take-out asked for twice leaves the files of the first standing — catches one fixed directory per take-out

## 6. `restore`: a take-out that cannot be made — one test each

- [ ] 6.1 a take-out refused names the store that could not be taken out and hands out none of the others — catches a part take-out
- [ ] 6.2 a take-out that cannot be written where it is to be written is refused as a place that could not be written — catches both causes answered alike
- [ ] 6.3 a take-out refused replaces the refused change a commitments screen held — catches the refusal held beside `refusedChange` instead of in it

## 7. `restore`: the day screen's line — one test each

- [ ] 7.1 a day screen that cannot read its record says a copy can be restored and where — catches the line missing for the roster or the one-offs
- [ ] 7.2 a day screen not keeping any of its three stores says a copy can be restored once — catches a line per store
- [ ] 7.3 a day screen whose only store not kept was written by a later version says nothing about restoring a copy — catches a restore invited next to *must not be deleted*
- [ ] 7.4 a day screen keeping all three of its stores says nothing about restoring a copy — catches a flag set once and never cleared

## 8. `restore`: the later-version cause where a store is named — one test each

- [ ] 8.1 a copy refused over a store written by a later version says so rather than that it could not be read — catches the cause taken from the first unreadable store rather than the one named
- [ ] 8.2 a change kept where a store was written by a later version stops with that cause rather than a store that could not be read — catches the stop left on one cause
- [ ] 8.3 the two MODIFIED requirements carry every other scenario unchanged, and their shipped acceptance tests stand as they are — no test is added or renamed here

## 9. The shell (ADR-1019: no behaviour the kit does not specify)

- [ ] 9.1 `CommitmentsView.swift` draws *Take out the files* between the refused copy and *Restore from a copy*, only while `offersATakeOut`, with a caption naming each store in `storesNotRead` and its cause, per `design.md` § *What the shell draws*
- [ ] 9.2 `CommitmentsView.swift` presents the share sheet with every URL the take-out answers, and draws a refused take-out in the caption red the section's refusals use
- [ ] 9.3 `CommitmentsView.swift` says *written by a newer version of DayByDay* for the refused copy and for the copy place's stop, keeping the shipped words for the other causes
- [ ] 9.4 `ContentView.swift` draws the day screen's line in the secondary grey, once, under the causes, while `saysACopyCanBeRestored`
- [ ] 9.5 `pnpm run verify` passes and the app target builds

## 10. The records

- [ ] 10.1 `CONTEXT.md` § *Take-out* still describes what shipped; a sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in
- [ ] 10.2 `docs/open-questions.md` no longer carries *A roster from a later version is given two causes at once when a copy is asked for* as open and records it settled — written on this branch by the session, which is the only writer that file has; the **`implementer` ticks this** on the file as it then stands, and a file still listing it open is a stop and a report
- [ ] 10.3 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 11. The walk (ADR-1053; `docs/running-the-app.md` § *The walk* has the commands)

- [ ] 11.1 the day screen with the record at its place swapped for a run of bytes: the red *could not be read* line and the grey restore line under it
- [ ] 11.2 the commitments screen's *Copy* section in that state, after *Make a copy* is tapped: the refused copy in red and *Take out the files* under it with its caption
- [ ] 11.3 the share sheet open from that row: the files listed under the names they lie under
- [ ] 11.4 the *Copy* section with the roster swapped for one written in a later form, after *Make a copy* is tapped: the refusal and the caption each saying *a newer version* rather than *could not be read*
- [ ] 11.5 **The walk handover** — the implementer posts the pictures to the PR as one comment with `gh pr comment --attach`, one per box, before hand-back, and ticks this box on that comment's URL; the throwaway test is deleted, and `src/DayByDay/DayByDayUITests/` merges unchanged

## 12. The gates

- [ ] 12.1 `openspec validate take-out-an-unreadable-store --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [ ] 12.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, `docs/open-questions.md`, the kit sources and tests, `CommitmentsView.swift` and `ContentView.swift`
- [ ] 12.3 `pnpm run check:budgets` reports no warning about this folder
- [ ] 12.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is twenty-four more than a run on `main` reports, both read off runs
- [ ] 12.5 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–12.4 are ticked and that this instruction is written here for the janitor. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints. It then reads the spec diff that produced: `openspec/specs/restore/spec.md` gains five requirements and changes two, each by one sentence and one scenario. Nothing else in any spec may move. `pnpm run checks` runs after the archive commit exists. **Any other drift is a stop and a report, never a hand-edit**: rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.
