## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written
as a test without changing its title, a new test that passes before the code it names is written, a
fix that reaches outside `OneOffs.swift`, `OneOffStore.swift`, `DayView.swift`, `DayScreen.swift` and
`ContentView.swift`, or any other test in the suite turning red.

Rule 3 governs §§ 3–5: take the next unticked box, write or edit the one test named for it, watch it
fail, make it pass, then the next. `one-off` tests go in `OneOffTests.swift` and `OneOffStoreTests.swift`;
day-view tests in `DayViewTests.swift`; day-screen tests in `DayScreenTests.swift`. A box marked
*edited* names a shipped test whose asserts change under its unchanged title. § 6's tests were
already edited on this branch: tick each only once its asserts read as its scenario, clause by clause.

## 2. The seam

- [x] 2.1 Every member in `design.md` § *The seam* exists with that signature, and 3.1 is red before they do anything but compile

## 3. `one-off` — one test each

- [x] 3.1 a one-off renamed keeps its date, whether it is done and its place among one-offs owed on its date — catches remove-then-add moving it last
- [x] 3.2 renaming a one-off onto a one-off already held on its date is refused and changes nothing — catches the one-off itself not counted as held
- [x] 3.3 renaming a one-off to a name that says nothing, or renaming one not held, is refused — catches a blank name trimmed into a valid one
- [x] 3.4 a rename is kept at a one-off store before the store reports it, and one that cannot be kept is refused — catches the held value changed before the write

## 4. `day-screen`: the day view — one test each

- [x] 4.1 *edited* two day views differing only in a one-off standing on another day are the same day view — catches no one-offs and none standing drawn alike
- [x] 4.2 *edited* a day view of a past day draws no undone one-off owed on that day — catches the group still dropped where no row stands

## 5. `day-screen`: the screen — one test each

- [x] 5.1 *edited* a day screen moved off today draws no undone late one-off and draws one owed ahead on its date — catches an unreadable place's `nil` used for every day
- [x] 5.2 *edited* a day screen opened where no one-offs have been kept writes nothing at its one-off place — catches an empty group written as a file
- [x] 5.3 *edited* a day screen reads its one-off place again when shown and not when returned to — catches a read in `returnedTo`
- [x] 5.4 *edited* a one-off tick taken back on a past day leaves that day and stands on today again — catches a day view not formed again
- [x] 5.5 a one-off committed in the one-off entry on today is added not done on today — catches an add done on today
- [x] 5.6 a one-off committed on a later day is added not done on that day and offers no tick — catches the add dated today
- [x] 5.7 a one-off committed on a past day is added already done on that day and stays on it — catches an undone add leaving for today
- [x] 5.8 blank space around a name committed in the one-off entry is not part of the one-off added — catches `Blank.trimmed` not called
- [x] 5.9 a commit saying nothing in the one-off entry adds nothing and tells nothing — catches a blank commit clearing the notice
- [x] 5.10 a day screen not keeping one-offs adds nothing whatever is committed in its one-off entry — catches an add opening a fresh store
- [x] 5.11 a one-off added ends what a day screen tells on a row — catches `notice` left set after an add
- [x] 5.12 an add of a name already held on the day shown is refused and told under the one-off entry — catches the refusal set as `notice`
- [x] 5.13 an add is refused on a past day where a one-off of that name owed there now stands on today — catches the duplicate checked against drawn rows
- [x] 5.14 an add that cannot be kept is refused with an error and told under the one-off entry beside what is told on a row — catches the refusal replacing `notice`
- [x] 5.15 a rename onto a one-off already held is refused and told under its row, which keeps its name — catches `row` left `nil`
- [x] 5.16 a rename that cannot be kept is refused with an error and told under its row — catches a blank rename's failure told as `notice`
- [x] 5.17 what is told under the one-off entry stands when a change is kept on a row or from another field and when returned to — catches every kept write clearing it
- [x] 5.18 what is told under a one-off name field ends when its text is edited or a commit from it is kept — catches a kept add leaving it set
- [x] 5.19 what is told under a one-off name field ends when the day being shown changes and stands when today is sent back to today — catches `showToday` clearing it unconditionally
- [x] 5.20 what is told under a one-off name field ends when the app is shown again — catches `shown(asOf:)` not clearing it
- [x] 5.21 a refusal under one one-off name field replaces what is told under another, and ends when its row is no longer held — catches a stale row kept after a tick
- [x] 5.22 a one-off renamed from its row on a past day keeps its date and stays done there — catches a rename dated the shown day or undone
- [x] 5.23 a rename committed with its row's own name changes nothing and writes nothing — catches the self-rename told as a duplicate
- [x] 5.24 a rename committed saying nothing removes the one-off — catches a blank rename refused
- [x] 5.25 a one-off removed from its row is held no longer, done or not and whether or not it offers its tick — catches an `offersTick` guard copied from `tick`
- [x] 5.26 renaming or removing a one-off row a day screen's day view does not hold changes nothing — catches a missing `contains` guard
- [x] 5.27 a one-off removal that cannot be kept is refused with an error and told on its row — catches the failure told under the entry
- [x] 5.28 a rename committed with its row's own name leaves a refusal already told under that row standing — rename `aRenameCommittedWithItsRowsOwnNameDoesNotEndARefusalAlreadyToldUnderIt` to this title; catches the self-rename clearing `nameRefusal`
- [x] 5.29 what a day screen tells on a row ends when a one-off rename is kept, a blank one included — rename `aKeptRenameEndsWhatADayScreenTellsOnACommitmentRow` to this title and add the blank rename's asserts; catches `notice` left set after a rename

## 6. `day-screen`: shipped scenarios comparing with a day view formed directly — one test each

- [x] 6.1 *edited* a day screen moved to the day before shows the previous day — catches the empty One-offs group dropped
- [x] 6.2 *edited* a day screen moved to the day after shows the next day — catches the empty One-offs group dropped
- [x] 6.3 *edited* a day screen moves onto a day that has not arrived and shows it — catches the empty One-offs group dropped
- [x] 6.4 *edited* a day screen that is not keeping a record moves and goes on saying it is keeping none — catches the empty One-offs group dropped
- [x] 6.5 *edited* a day screen that is not keeping a roster moves and goes on saying why — catches the empty One-offs group dropped
- [x] 6.6 *edited* a day screen showing the first supported date is unchanged when it is moved to the day before — catches the empty One-offs group dropped
- [x] 6.7 *edited* a day screen showing the last supported date is unchanged when it is moved to the day after — catches the empty One-offs group dropped
- [x] 6.8 *edited* a day screen holds the day it was handed rather than the day it really is — catches the empty One-offs group dropped
- [x] 6.9 *edited* a day screen holds the same day view as one formed directly from the same commitments, day and history — catches the empty One-offs group dropped
- [x] 6.10 *edited* a day screen shows a day picked between the earliest day its picker reaches and the day it was showing — catches the empty One-offs group dropped
- [x] 6.11 *edited* a day screen showing the first supported date says no day view before it and says the day after — catches the empty One-offs group dropped
- [x] 6.12 *edited* a day screen showing the last supported date says no day view after it and says the day before — catches the empty One-offs group dropped
- [x] 6.13 *edited* a day screen moved off an end of the calendar says a day view either side of it — catches the empty One-offs group dropped
- [x] 6.14 *edited* a day screen showing the first supported date says no day view before it whatever its places, its rows and its today — catches the empty One-offs group dropped
- [x] 6.15 *edited* ticking a row a day screen says of the day before changes nothing — scenario unchanged; its asserts drop the comparison with a day view formed directly, which the scenario never names
- [x] 6.16 *edited* a day screen says the day view of the day before the one it is showing — catches the empty One-offs group dropped
- [x] 6.17 *edited* a day screen says the day view of the day after the one it is showing — catches the empty One-offs group dropped
- [x] 6.18 *edited* a day screen says the day one calendar day either side and no day further — catches the empty One-offs group dropped
- [x] 6.19 *edited* a tick made on the day a day screen is showing leaves the day either side of it as it was — scenario unchanged; each side is compared with the day view said before the tick, not one formed directly
- [x] 6.20 *edited* a day screen moved to another day says the day either side of that day — catches the empty One-offs group dropped
- [x] 6.21 *edited* a day screen sent back to today says the day either side of that today — catches the empty One-offs group dropped
- [x] 6.22 *edited* a day screen showing a day picked on its day picker says the day either side of that day — catches the empty One-offs group dropped
- [x] 6.23 *edited* a day screen shown again on a new day says the day either side of that day — catches the empty One-offs group dropped
- [x] 6.24 *edited* a day screen that cannot read its record says the day either side of it with nothing kept — catches the empty One-offs group dropped
- [x] 6.25 *edited* a day screen does not change day when a tick is made on it — catches the empty One-offs group dropped
- [x] 6.26 *edited* a day screen moved off today keeps the day it is showing when the app is shown again — catches the empty One-offs group dropped
- [x] 6.27 *edited* a day screen moved away and back onto today moves onto the new day when the app is shown again — catches the empty One-offs group dropped

## 7. The shell (ADR-1019: this Story's immediate consumer, no behaviour the kit does not specify)

- [x] 7.1 `ContentView.swift` draws the one-off entry, the toolbar `+` and the green checkmark as `design.md` § *The shell* says, shows `nameRefusal` under its field with its `text`, and keys one-off rows by value
- [x] 7.2 Every day change and `scenePhase` leaving `.active` commits a focused one-off field before it calls the move, read in the diff line by line
- [x] 7.3 `pnpm run verify` passes and the app target builds; the UI test bundle is not run (ADR-1029)
- [x] 7.4 `ContentView.swift` puts a one-off row into rename on a tap on its drawn name alone, on every one-off row; the rest of the row, lateness words included, stays its tick or take-back and does nothing on a later day's row; its long-press `contextMenu` holds a destructive *Remove* alone — all as `design.md` § *The shell* says — and `pnpm run verify` passes and the app target builds again after it
- [x] 7.5 `ContentView.swift`'s Return on the one-off entry drops focus and closes the keyboard once the add is kept, as the checkmark does, and keeps focus with the typed text on a refused add — as `design.md` § *The shell* says (grill answer 25) — and `pnpm run verify` passes and the app target builds again after it

## 8. The records

- [x] 8.1 Confirm `CONTEXT.md` § *Day view*, § *One-off* and § *One-off entry* still describe what shipped; a sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in
- [x] 8.2 Confirm `git diff --stat origin/main... -- openspec/specs/ docs/adr/` reports nothing (rule 2; no ADR is written)

## 9. The gates

- [x] 9.1 `openspec validate make-one-off-on-day-screen --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [x] 9.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, the four kit sources, the four test files and `ContentView.swift`
- [x] 9.3 `pnpm run check:budgets` warns about this folder only for *A day view is a value and nothing else*, *What a day screen tells on a row lasts only until the app is shown again, a change is kept, or the day it is showing changes*, *A day screen moves the day it is showing one calendar day either way*, *A move with nowhere to go leaves a day screen exactly as it was*, *A day screen holds the day view of the day it was handed, formed from the record kept at its place* and *A day screen re-reads its day and its places when the app is shown again*: the last five are carried whole at their length on `main`, and *A day view is a value and nothing else* grows from 217 words on `main` to 240 with its new SHALL NOT sentence, as `design.md` explains
- [x] 9.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is twenty-nine more than a run on `main` reports — both read off runs
- [x] 9.5 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–9.4 are ticked and that the instruction below is written here for the janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff it produced: `openspec/specs/one-off/spec.md` gains one requirement with four scenarios; `openspec/specs/day-screen/spec.md` gains four requirements with twenty-three scenarios, and fourteen others change — two by a sentence, one by a sentence and a new scenario, one by a new scenario alone, and thirty-one scenarios' asserts across twelve of them, with ragged lines re-wrapped and no other word moved; nothing else in any spec moves. `pnpm run checks` runs after the archive commit exists. **Any other drift is a stop and a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.
