## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5):
a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a new test that passes before the code it names is written, a popover
that will not anchor to a row (§ 6.1), a fix that reaches outside `DayView.swift`, `DayScreen.swift`,
`DayViewTests.swift`, `DayScreenTests.swift` and `ContentView.swift` (the walk's throwaway test
aside), or any carried test turning red beyond the six § 5 names. A change to any other file, a
comment included, is booked as a finding and left alone — `CONTEXT.md` is this Story's proposal
commit's, not the implementation's.

Rule 3 governs §§ 3–5: take the next unticked box, write or edit the one test named for it, watch it
fail, make it pass, then the next.

## 2. The seam

- [x] 2.1 `DayView.NumberEntry.values` and `DayScreen.choose(_:on:)` exist as `design.md` § *The seam* writes them, and 3.1 is red before `values` is formed
- [x] 2.2 `History`, `Number`, `Commitment`, `Roster`, `TypedNumber` and `CommitmentsScreen` are unchanged, and `openspec/specs/` is untouched (rule 2)

## 3. Chosen or typed — `DayViewTests.swift`, the era one and the inert commit in `DayScreenTests.swift`

- [x] 3.1 a number entry of a range of one to ten is chosen from the ten whole numbers in it — catches eleven counted exclusive of a bound, or a hint still said
- [x] 3.2 a number entry of a range holding more than eleven whole numbers, or a bound that is not whole, is typed — catches a bound's fraction truncated
- [x] 3.3 a chosen entry on a day holding a number not among its values says that number, and its values as they are — catches 5.5 inserted into the values
- [x] 3.4 a number entry is chosen or typed by the range of the era holding its day — catches the newest era's range read for every day
- [x] 3.5 text committed in a chosen entry changes nothing, whatever it holds — catches a blank commit still taking the number back

## 4. The choice — `DayScreenTests.swift`

- [x] 4.1 a value chosen in a chosen entry is kept, and the entry then says it
- [x] 4.2 a value chosen on a day holding another number replaces it, one not among the values included
- [x] 4.3 choosing the value the day already holds writes nothing and is not refused — catches a same-value write refused by the place
- [x] 4.4 the clear takes the day's number back
- [x] 4.5 the clear on a day holding no number writes nothing and is not refused
- [x] 4.6 a choice that cannot be kept is refused, told on its row naming no cause, and leaves the day view as it was
- [x] 4.7 a value that is not among the entry's values changes nothing — catches `Number.init`'s range check standing in for the values
- [x] 4.8 a choice on a row that offers no chosen entry changes nothing — catches the entry asked as of the day shown
- [x] 4.9 choosing on a row the day screen's day view does not hold changes nothing
- [x] 4.10 choosing on a day screen that is not keeping a record changes nothing and keeps nothing

## 5. The carried scenarios — each test edited only as its scenario now says, its title unchanged

- [x] 5.1 a number entry says the range its commitment declares as a hint — "Sleep", "0–24"
- [x] 5.2 an entry committed empty takes the number back, and one holding nothing but space does the same — "Sleep"
- [x] 5.3 a number outside the commitment's range is told on the row, naming the bounds it broke — "25", between 0 and 24
- [x] 5.4 a second refused commit is told on the row committed on last and no longer on the first — "Sleep"
- [x] 5.5 committing an empty entry at a place that cannot be written is refused only on a row whose day holds a number — "Sleep"
- [x] 5.6 a day screen returned to after a restore tells nothing it was telling — "Sleep", "25"

## 6. The shell (ADR-1019: this Story's immediate consumer, no rule the kit does not state)

- [x] 6.1 **First, before 6.2:** a popover presented from one row of the day screen's list, inside its paged days, with `.presentationCompactAdaptation(.popover)`, anchors to that row on the simulator. If it presents as a sheet, from another frame or not at all, stop and report — never switch presentation
- [x] 6.2 A chosen row draws as `design.md` § *The shell rides this Story* says — chevron at rest and no value; a tap opens the popover; a value tap chooses and closes; the clear, drawn only where `number` is set, clears and closes; a tap elsewhere closes and calls nothing — and the app target builds
- [x] 6.3 A typed row still opens its alert with the hint as placeholder, and no chosen row opens one

## 7. The records

- [x] 7.1 Confirm `CONTEXT.md` § *Short range* and its two amendments still describe what shipped; a sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in

## 8. The gates

- [x] 8.1 `openspec validate choose-a-number-from-a-short-range --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [x] 8.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, the two kit sources, the two kit test files and `ContentView.swift`
- [x] 8.3 `pnpm run check:budgets` warns in this folder only about the three carried `day-screen` requirements over 150 words, which this Story carries whole and does not condense (`design.md` § Non-Goals)
- [x] 8.4 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing, its count read off the run
- [x] 8.5 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–8.4 and the walk below are ticked and that this instruction is written for the janitor. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `day-screen/spec.md` gains the two added requirements and its four MODIFIED ones are whole, `restore/spec.md`'s one MODIFIED requirement is whole, and no other spec moved. `pnpm run checks` runs after the archive commit exists, and that commit is pushed. **Any drift is a stop and a report, never a hand-edit.**

## The walk

- [x] W.1 A *Mood* (1–10) and a *Weight* (40–150) kept every day, today holding nothing: both rows at rest with name, rhythm and chevron, no number and no values anywhere
- [x] W.2 *Mood* tapped: the popover anchored under its row, the ten values 1–10 in one line, none marked, no clear, nothing dimmed
- [x] W.3 7 tapped: the popover closed, *Mood* struck through with its check, no number on the row
- [x] W.4 *Mood* tapped again: 7 a filled circle with the digit inverted, the clear drawn beside the values
- [x] W.5 The clear tapped: the popover closed, *Mood* not struck through and no check
- [x] W.6 A *Mood* day holding 5.5, tapped: "5.5" above the values, none marked, the clear drawn
- [ ] W.7 phone: hitting the value meant, among ten in the popover, with a thumb
- [x] W.8 **The handover** — W.1–W.6, retaken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL: https://github.com/dbugmann-labs/daybyday/pull/333#issuecomment-5812828076
