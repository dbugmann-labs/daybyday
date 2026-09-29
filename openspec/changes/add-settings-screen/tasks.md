Anything that fails or surprises is a stop and a report, never a workaround (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a carried test that has to be edited or turns
red, a Kit signature that has to move, a word on a moved line that has to change beyond the two
`design.md` § *The shell* names, or a change to `scripts/walk.ts`. There is no red in this Story
(`design.md` § *The seam*): the scenario boxes are ticked on the carried tests passing unedited.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` reports none of this change's five scenarios uncovered; any uncovered title is a stop.

## 2. The modified requirement, carried

- [x] 2.1 a day screen that cannot read its record says a copy can be restored and where — carried unedited; catches the flag moved or renamed along with the words
- [x] 2.2 a day screen not keeping any of its three stores says a copy can be restored once — carried unedited
- [x] 2.3 a day screen whose only store not kept was written by a later version says nothing about restoring a copy — carried unedited
- [x] 2.4 a day screen keeping all three of its stores says nothing about restoring a copy — carried unedited
- [x] 2.5 a day screen that says its birthday ticks could not be read says a copy can be restored, and says nothing of it while birthdays are off — carried unedited

## 3. The shell (ADR-1019: no rule the Kit does not state)

- [x] 3.1 `SettingsView` draws what `design.md` § *The shell* and § *What the shell draws* say, every section, sheet and picker moved from `CommitmentsView` with its words unchanged but "Open iPhone Settings", and the switch in `.tint(.accentColor)`
- [x] 3.2 `CommitmentsView` draws its two lists, what is done to them, the roster-state lines ("The roster could not be read or could not be written.", "The roster was written by a newer version of DayByDay and must not be deleted.") and "Some records belong to no commitment.", nothing of copies or birthdays, and no longer takes the birthday switch
- [x] 3.3 `ContentView`'s toolbar carries `list.bullet` labelled "Commitments" and `gearshape` labelled "Settings" in one trailing group; the Settings sheet builds its own `CommitmentsScreen`, calls `birthdaySwitch.shown()` on opening, `returnedTo(from:)` on every dismissal and `shown(asOf:)` when the app is shown again, as § *Settings builds a Kit screen of its own* says
- [x] 3.4 The day screen's restore line reads "A copy can be restored from Settings", and `saysACopyCanBeRestored`'s doc comment names Settings as where
- [x] 3.5 `git diff --stat origin/main... -- src/DayByDayKit/` lists `DayScreen.swift` alone, its doc comment the only change, and no test file
- [x] 3.6 The app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 4. The records

- [x] 4.1 Confirm `CONTEXT.md` § *Settings* and the 2026-09-29 amendments to *Commitments screen*, *Copy place*, *Restore*, *Take-out* and *Birthday* describe what shipped; a sentence that turns out wrong is a stop and a question, never an edit
- [x] 4.2 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 5. Gates and the archive handover

- [x] 5.1 `openspec validate add-settings-screen --strict` exits 0, and `pnpm run checks` is clean
- [x] 5.2 `pnpm run verify` green, and `swift test` from `src/DayByDayKit` passing with the same count a run on `origin/main` reports, both read off runs
- [ ] 5.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 5.4 **The implementer ticks this box in its last commit before the archive**, on the evidence that every other box is ticked — W.7 to W.9 by the conductor on the G7 approval — and the walk comment's URL is in W.10. The janitor then runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, and checks afterwards that `openspec/specs/restore/spec.md` changed in this one requirement's three sentences and nowhere else, and that no other spec file moved. **Any drift is a stop and a report, never a hand-edit.**

## The walk

A fresh install, calendar access reset, and the simulator's On My iPhone holding an empty folder.

- [x] W.1 The day screen a day back — Today at the leading edge, and the list and gear symbols in one capsule at the trailing edge.
- [x] W.2 Commitments tapped — the Kept and Stopped lists alone, no Birthdays switch and no Copy section below them.
- [x] W.3 Settings tapped — a full-height sheet titled Settings with Done; *Copy place* reading "Pick a folder" over "Pick a folder to keep a copy there."; the switch off; *Copy* with *Make a copy* and *Restore from a copy*; "Version 1.0 (1)" centred at the foot.
- [x] W.4 A folder in On My iPhone picked as the copy place — the row naming it, and "Last copy …" directly under it.
- [x] W.5 The switch turned on and the calendar prompt allowed — the switch on in the app's tint, not green.
- [x] W.6 Only if the walk can swap the record at its place for a run of bytes, as `take-out-an-unreadable-store`'s did: the day screen's red cause and "A copy can be restored from Settings" under it. If it cannot, say so in the walk comment and tick this; it is never a `phone:` line.
- [ ] W.7 phone: a copy restored from Settings, the sheet closed with Done — the day screen drawing what the copy holds.
- [ ] W.8 phone: birthdays turned on in Settings with calendar access given, the sheet swiped down — the Birthdays group on a day a birthday falls.
- [ ] W.9 phone: calendar access turned off for DayByDay — Settings shows the refused line, and "Open iPhone Settings" opens DayByDay's page in the phone's Settings.
- [ ] W.10 **The handover** — W.1–W.6, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL. W.7–W.9 are the human's at G7; the conductor ticks them on the G7 approval.
