## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written
as a test without changing its title, a new test that passes before the code it names is written,
a fix that reaches outside `OneOffs.swift`, `DayView.swift`, `DayScreen.swift` and `ContentView.swift`,
or any other test in the suite turning red.

Rule 3 governs §§ 3–5: take the next unticked box, write the one test named for it, watch it fail,
make it pass, then the next. `one-off` tests go in `OneOffTests.swift`; day-view tests in
`DayViewTests.swift`; day-screen tests in `DayScreenTests.swift`.

## 2. The seam

- [ ] 2.1 Every member in `design.md` § *The seam* exists with that signature, and 3.1 is red before they do anything but compile
- [ ] 2.2 Every shipped `DayScreen(` opening in the tests passes a temporary one-off place of its own, no assertion changes, and the suite is green before § 3 begins

## 3. `one-off` — one test each

- [ ] 3.1 one-offs standing on a day are answered earliest owed first — catches held order, or late ones answered on a past day
- [ ] 3.2 one-offs owed on one date keep the order they were added in — catches a sort by name or an unstable sort
- [ ] 3.3 done and undone one-offs standing on one day are ordered by the date owed alone — catches done ones sorted first or last

## 4. `day-screen`: the day view — one test each

- [ ] 4.1 a day view holds a One-offs group of the one-offs standing on its date — catches one-off rows counted among `rows`
- [ ] 4.2 a day view of a past day draws no undone one-off owed on that day — catches drawing by the date owed
- [ ] 4.3 a day view's one-off rows are in the order one-offs answer them — catches the day view sorting by name
- [ ] 4.4 an undone one-off row on a day after its date says how many days late it is — catches "1 days late"
- [ ] 4.5 a one-off row late by more than a year still says days — catches a switch to weeks or a date
- [ ] 4.6 a one-off row on its own date says nothing in the rhythm's place — catches "0 days late"
- [ ] 4.7 a one-off ticked late says nothing in the rhythm's place on the day it was ticked — catches lateness said while done
- [ ] 4.8 a one-off row offers its tick where its day has arrived, done or not — catches a done row offering no take-back
- [ ] 4.9 two one-off rows alike in one-off, date and whether done are the same row — catches equality ignoring done
- [ ] 4.10 two one-off rows of one one-off on different dates are different rows — catches equality ignoring the date
- [ ] 4.11 two day views differing only in a one-off standing on another day are the same day view — catches the today or all one-offs held on the view

## 5. `day-screen`: the screen — one test each

- [ ] 5.1 the place a day screen keeps its one-offs is a file of the app's own under Application Support — catches caches or tmp
- [ ] 5.2 the place a day screen keeps its one-offs is the same place every time it is asked — catches a per-call unique path
- [ ] 5.3 the place a day screen keeps its one-offs is neither its record place nor its roster place — catches a shared file
- [ ] 5.4 a day screen draws the one-offs kept at its one-off place on the today it was handed — catches the place never opened
- [ ] 5.5 a day screen moved off today draws no undone late one-off and draws one owed ahead on its date — catches one-offs asked as of the shown day
- [ ] 5.6 a day screen opened where no one-offs have been kept writes nothing at its one-off place — catches an empty store written on open
- [ ] 5.7 a day screen reads its one-off place again when shown and not when returned to — catches a read in `returnedTo`
- [ ] 5.8 a day screen shown again on a later day draws a one-off that has followed today — catches a day view formed with the old today
- [ ] 5.9 a day screen's one-offs do not move the reach of its day picker — catches one-off dates in the floor
- [ ] 5.10 a day screen whose one-off place cannot be read draws its commitments and no One-offs group — catches a thrown init or a written-over file
- [ ] 5.11 one-offs written in a later form make a day screen that says they are from a later version — catches every refusal said alike
- [ ] 5.12 a day screen that cannot read its record still draws and ticks its one-offs — catches the one-off state read off the record's
- [ ] 5.13 a day screen that could not read its one-offs starts keeping them when shown again and they can be read — catches the state carried over
- [ ] 5.14 ticking a late one-off row keeps it done on the today and it says nothing late — catches a tick on the date owed
- [ ] 5.15 a one-off tick taken back on a past day leaves that day and stands on today again — catches a day view not formed again
- [ ] 5.16 a one-off tick that cannot be kept is refused and leaves the day view as it was — catches the held value changed before the write
- [ ] 5.17 ticking a one-off row that the day view does not hold or that offers no tick changes nothing — catches a missing `contains` guard
- [ ] 5.18 a refused one-off tick is told on its row and ends what was told on a commitment row — catches two notices at once
- [ ] 5.19 a refused commitment tick ends what was told on a one-off row — catches `oneOffRow` left set
- [ ] 5.20 what a day screen tells on a row ends when a one-off tick is kept — catches only record writes clearing the notice
- [ ] 5.21 what a day screen tells on a one-off row ends when a commitment tick is kept — catches a notice cleared by kind
- [ ] 5.22 what a day screen tells on a one-off row stands when returned to and ends when the app is shown again — catches `returnedTo` clearing it
- [ ] 5.23 a tick on a one-off row a day screen's day view does not hold does not end what is already told — catches the clear placed before the guard

## 6. The shell (ADR-1019: this Story's immediate consumer, no behaviour the kit does not specify)

- [ ] 6.1 `ContentView.swift` draws `oneOffGroup` as a section headed by its `heading` after every group, on the shown page and on both adjacent pages, each row its name, its `lateInWords` where there is one, a checkmark where done, a tap calling `tick` where `offersTick`, and the notice matched on `oneOffRow`
- [ ] 6.2 `ContentView.swift` says one line for `oneOffState` beside the record and roster lines, naming a later version for `.writtenByALaterVersion`; `pnpm run verify` passes and the app target builds, the UI test bundle not run (ADR-1029)

## 7. The records

- [ ] 7.1 Confirm the 2026-09-14 amendment to ADR-1052 and `CONTEXT.md` § *One-off* and § *One-off place* still describe what shipped; a sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in
- [ ] 7.2 Confirm `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2) and `-- docs/adr/` reports only `1052-…`

## 8. The gates

- [ ] 8.1 `openspec validate draw-one-offs-on-day-screen --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [ ] 8.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, the ADR, the three kit sources, the three test files and `ContentView.swift`
- [ ] 8.3 `pnpm run check:budgets` warns about nothing new in this folder, and `pnpm run verify` passes
- [ ] 8.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is thirty-seven more than a run on `main` reports — both read off runs, never derived by arithmetic
- [ ] 8.5 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–8.4 are ticked and that the instruction below is written here for the janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff it produced: `openspec/specs/one-off/spec.md` gains one requirement with three scenarios; `openspec/specs/day-screen/spec.md` gains eight requirements, changes sentences in five others and gains six scenarios under those five; nothing else in any spec moves. `pnpm run checks` runs after the archive commit exists. **Any other drift is a stop and a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.
