## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5):
a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a new test that passes before the code it names is written, a fix that
reaches outside `History.swift`, `DayView.swift`, `DayViewTests.swift`, `DayScreenTests.swift` and
`ContentView.swift` (the walk's throwaway test aside), or any carried test turning red. A change to
any other file, a comment included, is booked as a finding and left alone — `CONTEXT.md` is this
Story's proposal commit's, not the implementation's.

Rule 3 governs §§ 3–4: take the next unticked box, write the one test named for it, watch it fail,
make it pass, then the next.

## 2. The seam

- [x] 2.1 `DayView.NumberEntry.startingNumber`, `DayView.Row.startingNumber` and `History.latestNumber(for:before:)` exist as `design.md` § *The seam* writes them, and 3.1 is red before the row forms one
- [x] 2.2 `DayScreen`, `Number`, `Commitment`, `Roster`, `TypedNumber` and `CommitmentsScreen` are unchanged, and `openspec/specs/` is untouched (rule 2)

## 3. What the entry says — `DayViewTests.swift`

- [x] 3.1 a typed number entry on a day holding no number says the latest number held before that day as its starting number — catches the hint cleared beside it
- [x] 3.2 a number held on the entry's day or on a later day is not its starting number — catches the latest number ever, rather than the latest before
- [x] 3.3 a starting number is the latest number held however far back it lies — catches a look-back window
- [x] 3.4 a number taken back is not a starting number, and the latest one still held is
- [x] 3.5 a starting number is its own commitment's number and never another's — catches a match by name or by kind
- [x] 3.6 a number entry on a day holding a number says that number and no starting number
- [x] 3.7 a chosen entry says no starting number
- [x] 3.8 a commitment declaring no range takes any number held before its day as its starting number
- [x] 3.9 two rows for the same number commitment and date holding no number but differing in starting number are different rows — catches a custom equality leaving it out

## 4. The day screen — `DayScreenTests.swift`

- [x] 4.1 a starting number is read across every era of its commitment — catches a lookup by the era's own entry rather than its identity
- [x] 4.2 a latest number outside the range of the era holding the day is no starting number, and none earlier is said instead — catches a walk back to one that fits, or bounds read exclusive
- [x] 4.3 a starting number keeps nothing until it is committed, and committed as it is said is entered on the day being entered
- [x] 4.4 a number entered on a day is the starting number of the day after it, and taking it back takes that away — catches a starting number cached across a move

## 5. The carried scenarios

- [x] 5.1 Every scenario the two MODIFIED requirements carry passes with its test unedited, and so does every other carried test — the row-equality ones in `DayScreenTests.swift` and `DayViewTests.swift` included (`design.md` § Context)

## 6. The shell (ADR-1019: this Story's immediate consumer, no rule the kit does not state)

- [x] 6.1 A typed row's tap opens its alert holding `entry.number`, or else `entry.startingNumber`, as the text it writes for a held number, with the hint still its placeholder; Save and Cancel unchanged, chosen rows untouched, and the app target builds

## 7. The records

- [x] 7.1 Confirm `CONTEXT.md` § *Starting number* and its amendment still describe what shipped; a sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in

## 8. The gates

- [x] 8.1 `openspec validate start-a-number-from-the-last-one --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [x] 8.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, the two kit sources, the two kit test files and `ContentView.swift`
- [x] 8.3 `pnpm run check:budgets` warns about nothing in this folder
- [x] 8.4 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing, its count read off the run
- [x] 8.5 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–8.4 and the walk below are ticked and that this instruction is written for the janitor. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `day-screen/spec.md` gains the two added requirements and its two MODIFIED ones are whole, and no other spec moved. `pnpm run checks` runs after the archive commit exists, and that commit is pushed. **Any drift is a stop and a report, never a hand-edit.**

## The walk

- [x] W.1 A *Weight* (40–150) kept every day, yesterday holding 72.4 and today nothing, tapped on today: the alert's field reads "72.4" and no "40–150" shows
- [x] W.2 Today holding 73, yesterday nothing and the day before 71.8; moved to yesterday and *Weight* tapped: the field reads "71.8", not "73"
- [x] W.3 *Weight*'s range changed to 50–100 today, yesterday holding 45 and the day before 72.4, tapped on today: the field empty, its placeholder reading "50–100"
- [ ] W.4 phone: a starting number saved unchanged, and another with its last digit changed from the cursor at the end — the keyboard feel no simulator shows
- [x] W.5 **The handover** — W.1–W.3, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL
