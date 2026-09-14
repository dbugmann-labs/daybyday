## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written
as a test without changing its title, a new test that passes before the code it names is written, a
fix that reaches outside `OneOffs.swift`, `OneOffStore.swift`, `DayView.swift`, `DayScreen.swift` and
`ContentView.swift`, or any other test in the suite turning red.

Rule 3 governs §§ 3–5: take the next unticked box, write or edit the one test named for it, watch it
fail, make it pass, then the next. `one-off` tests go in `OneOffTests.swift` and `OneOffStoreTests.swift`;
day-view tests in `DayViewTests.swift`; day-screen tests in `DayScreenTests.swift`. A box marked
*edited* names a shipped test whose asserts change under its unchanged title.

## 2. The seam

- [ ] 2.1 Every member in `design.md` § *The seam* exists with that signature, and 3.1 is red before they do anything but compile

## 3. `one-off` — one test each

- [ ] 3.1 a one-off renamed keeps its date, whether it is done and its place among one-offs owed on its date — catches remove-then-add moving it last
- [ ] 3.2 renaming a one-off onto a one-off already held on its date is refused and changes nothing — catches the one-off itself not counted as held
- [ ] 3.3 renaming a one-off to a name that says nothing, or renaming one not held, is refused — catches a blank name trimmed into a valid one
- [ ] 3.4 a rename is kept at a one-off store before the store reports it, and one that cannot be kept is refused — catches the held value changed before the write

## 4. `day-screen`: the day view — one test each

- [ ] 4.1 *edited* two day views differing only in a one-off standing on another day are the same day view — catches no one-offs and none standing drawn alike
- [ ] 4.2 *edited* a day view of a past day draws no undone one-off owed on that day — catches the group still dropped where no row stands

## 5. `day-screen`: the screen — one test each

- [ ] 5.1 *edited* a day screen moved off today draws no undone late one-off and draws one owed ahead on its date — catches an unreadable place's `nil` used for every day
- [ ] 5.2 *edited* a day screen opened where no one-offs have been kept writes nothing at its one-off place — catches an empty group written as a file
- [ ] 5.3 *edited* a day screen reads its one-off place again when shown and not when returned to — catches a read in `returnedTo`
- [ ] 5.4 *edited* a one-off tick taken back on a past day leaves that day and stands on today again — catches a day view not formed again
- [ ] 5.5 a one-off committed in the one-off entry on today is added not done on today — catches an add done on today
- [ ] 5.6 a one-off committed on a later day is added not done on that day and offers no tick — catches the add dated today
- [ ] 5.7 a one-off committed on a past day is added already done on that day and stays on it — catches an undone add leaving for today
- [ ] 5.8 blank space around a name committed in the one-off entry is not part of the one-off added — catches `Blank.trimmed` not called
- [ ] 5.9 a commit saying nothing in the one-off entry adds nothing and tells nothing — catches a blank commit clearing the notice
- [ ] 5.10 a day screen not keeping one-offs adds nothing whatever is committed in its one-off entry — catches an add opening a fresh store
- [ ] 5.11 a one-off added ends what a day screen tells on a row — catches `notice` left set after an add
- [ ] 5.12 an add of a name already held on the day shown is refused and told under the one-off entry — catches the refusal set as `notice`
- [ ] 5.13 an add is refused on a past day where a one-off of that name owed there now stands on today — catches the duplicate checked against drawn rows
- [ ] 5.14 an add that cannot be kept is refused with an error and told under the one-off entry beside what is told on a row — catches the refusal replacing `notice`
- [ ] 5.15 a rename onto a one-off already held is refused and told under its row, which keeps its name — catches `row` left `nil`
- [ ] 5.16 a rename that cannot be kept is refused with an error and told under its row — catches a blank rename's failure told as `notice`
- [ ] 5.17 what is told under the one-off entry stands when a change is kept on a row or from another field and when returned to — catches every kept write clearing it
- [ ] 5.18 what is told under a one-off name field ends when its text is edited or a commit from it is kept — catches a kept add leaving it set
- [ ] 5.19 what is told under a one-off name field ends when the day being shown changes and stands when today is sent back to today — catches `showToday` clearing it unconditionally
- [ ] 5.20 what is told under a one-off name field ends when the app is shown again — catches `shown(asOf:)` not clearing it
- [ ] 5.21 a refusal under one one-off name field replaces what is told under another, and ends when its row is no longer held — catches a stale row kept after a tick
- [ ] 5.22 a one-off renamed from its row on a past day keeps its date and stays done there — catches a rename dated the shown day or undone
- [ ] 5.23 a rename committed with its row's own name changes nothing and writes nothing — catches the self-rename told as a duplicate
- [ ] 5.24 a rename committed saying nothing removes the one-off — catches a blank rename refused
- [ ] 5.25 a one-off removed from its row is held no longer, done or not and whether or not it offers its tick — catches an `offersTick` guard copied from `tick`
- [ ] 5.26 renaming or removing a one-off row a day screen's day view does not hold changes nothing — catches a missing `contains` guard
- [ ] 5.27 a one-off removal that cannot be kept is refused with an error and told on its row — catches the failure told under the entry

## 6. The shell (ADR-1019: this Story's immediate consumer, no behaviour the kit does not specify)

- [ ] 6.1 `ContentView.swift` draws the one-off entry, the toolbar `+`, the green checkmark and the long-press *Rename* / *Remove* menu as `design.md` § *The shell* says, shows `nameRefusal` under its field with its `text`, and keys one-off rows by value
- [ ] 6.2 Every day change and `scenePhase` leaving `.active` commits a focused one-off field before it calls the move, read in the diff line by line
- [ ] 6.3 `pnpm run verify` passes and the app target builds; the UI test bundle is not run (ADR-1029)

## 7. The records

- [ ] 7.1 Confirm `CONTEXT.md` § *Day view*, § *One-off* and § *One-off entry* still describe what shipped; a sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in
- [ ] 7.2 Confirm `git diff --stat origin/main... -- openspec/specs/ docs/adr/` reports nothing (rule 2; no ADR is written)

## 8. The gates

- [ ] 8.1 `openspec validate make-one-off-on-day-screen --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [ ] 8.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, the four kit sources, the four test files and `ContentView.swift`
- [ ] 8.3 `pnpm run check:budgets` warns about this folder only for *A day view is a value and nothing else*, already over budget on `main`
- [ ] 8.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is twenty-seven more than a run on `main` reports — both read off runs
- [ ] 8.5 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–8.4 are ticked and that the instruction below is written here for the janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff it produced: `openspec/specs/one-off/spec.md` gains one requirement with four scenarios; `openspec/specs/day-screen/spec.md` gains four requirements with twenty-two scenarios, and five others change — two by a sentence, one by a sentence and a new scenario, and six scenarios' asserts across four of them; nothing else in any spec moves. `pnpm run checks` runs after the archive commit exists. **Any other drift is a stop and a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.
