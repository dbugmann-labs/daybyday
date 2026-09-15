## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written
as a test without changing its title, a new test that passes before the code it names is written, a
fix that reaches outside `CommitmentsScreen.swift` and `CommitmentsView.swift`, or any other test in
the suite turning red.

Rule 3 governs § 3: take the next unticked box, write the one test named for it, watch it fail, make
it pass, then the next. Every test goes in `CommitmentsScreenTests.swift`, named for its scenario
title verbatim. No requirement in `openspec/specs/` changes on this branch, so no shipped test
should need editing; one that does is a stop.

## 2. The seam

- [x] 2.1 Every member in `design.md` § *The seam* exists with that signature, and 3.1 is red before they do anything but compile

## 3. `commitment` — one test each

- [x] 3.1 a refusal that a name says nothing is about the name field — catches the field left unset while `refusedChange` is set
- [x] 3.2 a refusal that a rhythm is due on no day is about the rhythm field — catches empty chips placed at the foot
- [x] 3.3 a refusal that the calendar will not take a rhythm's number is about the rhythm field — catches a day-of-the-month number placed elsewhere than an interval's
- [x] 3.4 a refusal that a range is not a range is about the range field — catches the range and the target sharing one field
- [x] 3.5 a refusal that a target is not a target is about the target field — catches the range and the target sharing one field
- [x] 3.6 a refusal that a commitment is already kept is about the whole change and no field — catches a field guessed from the ask rather than from the refusal
- [x] 3.7 a refusal that a roster could not be written is about the whole change and no field — catches a place failure placed under the last field touched
- [x] 3.8 a refusal that records are already kept under the commitment a change would produce is about the whole change — catches it read as the not-due cause and placed under a field
- [x] 3.9 a restart refused for the day it was asked from is about the restart day field — catches a restart's refusal placed by the same rule as a save's
- [x] 3.10 a restart refused as a commitment already kept is about the restart day field — catches already-kept placed at the foot whichever ask it answers
- [x] 3.11 a restart refused for records already kept or a day recorded on is about the restart day field — catches the two causes placed at the foot whichever ask they answer
- [x] 3.12 a restart refused by a place that could not be written is about the whole change — catches every restart refusal placed under the restart day
- [x] 3.13 a day recorded on that a change would leave not due is about the day-kept-from field — catches it placed under the rhythm because a schedule is what changed
- [x] 3.14 a change a stopped commitment does not take is about the rhythm field where only the rhythm differs — catches the comparison made against the ask rather than against the commitment
- [x] 3.15 a change a stopped commitment does not take is about the day-kept-from field where only that day differs — catches both causes placed under the rhythm
- [x] 3.16 a refusal is about the whole change where both the rhythm and the day kept from differ — catches the first difference found deciding the field
- [x] 3.17 what a commitments screen tells on its sheet ends when the field it is about is edited — catches an edit that clears nothing
- [x] 3.18 what a commitments screen tells on its sheet stands when another field is edited — catches any edit clearing it
- [x] 3.19 what a commitments screen tells at the foot of its sheet stands when a field is edited — catches a `nil` field matching the field edited
- [x] 3.20 what a commitments screen tells on its sheet ends when the sheet is closed — catches the sheet's close doing nothing
- [x] 3.21 a refused restart replaces what a refused save told on a commitments screen's sheet — catches a second value held for a restart
- [x] 3.22 what a commitments screen tells on its sheet ends when an ask is kept — catches only the refused paths writing the value
- [x] 3.23 what a commitments screen tells on its sheet ends when the app is shown again — catches `shown(asOf:)` clearing `refusedChange` alone
- [x] 3.24 what a commitments screen tells on its sheet stands when a call asks for no change at all — catches an early return clearing it
- [x] 3.25 a commitments screen offers all seven weekdays for a form's weekday chips — catches the seven read from what the roster holds

## 4. The shell (ADR-1019: this Story's immediate consumer, no behaviour the kit does not specify)

- [x] 4.1 `CommitmentsView.swift`'s sheet drops its two `@State` refusal copies and draws `screen.sheetRefusal` under the control its field names — the name field, the rhythm control whichever rhythm is chosen, the kept-from picker, the range row, the target field, the restart day picker — and at the foot of the first section where the field is `nil`
- [x] 4.2 That sheet calls `screen.sheetFieldEdited(_:)` from every one of those controls' edits and `screen.sheetClosed()` on every dismiss, cancel included, read in the diff line by line
- [x] 4.3 That sheet starts its weekday chips from `screen.weekdaysToOffer` where it has no weekday set behind them — a new commitment, and a rhythm switched onto weekdays — and keeps whatever was chosen when the rhythm is switched away and back
- [x] 4.4 `pnpm run verify` passes and the app target builds; the UI test bundle is run only as `## The walk` below says

## 5. The records

- [x] 5.1 Confirm `CONTEXT.md` § *Refused change* still describes what shipped, its 2026-09-15 amendment included; a sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in
- [x] 5.2 Confirm `git diff --stat origin/main... -- openspec/specs/ docs/adr/` reports nothing (rule 2; no ADR is written)

## 6. The gates

- [ ] 6.1 `openspec validate place-sheet-refusals --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [ ] 6.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, `CommitmentsScreen.swift`, `CommitmentsScreenTests.swift` and `CommitmentsView.swift`
- [ ] 6.3 `pnpm run check:budgets` warns about this folder for nothing at all
- [ ] 6.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is twenty-five more than a run on `main` reports — both read off runs
- [ ] 6.5 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–6.4 are ticked and that the instruction below is written here for the janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff it produced: `openspec/specs/commitment/spec.md` gains four requirements with twenty-five scenarios between them and nothing else in it moves; no other spec changes at all. `pnpm run checks` runs after the archive commit exists. **Any other drift is a stop and a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.

## The walk

- [ ] W1 The define sheet freshly opened from the commitments screen's `+`: all seven weekday chips lit
- [ ] W2 That sheet with the name left empty and *Add* tapped: the refusal under the Name field
- [ ] W3 That sheet with a name typed and every weekday chip tapped off, *Add* tapped: the refusal under the chips
- [ ] W4 That sheet on the *Every N days* rhythm with 0 in the interval field, *Add* tapped: the refusal under the interval row
- [ ] W5 That sheet on the *Number* kind with a lowest of 10 and a highest of 1, *Add* tapped: the refusal under the range row
- [ ] W6 That sheet on the *Total* kind with a target of 0, *Add* tapped: the refusal under the Target field
- [ ] W7 *Creatine* opened to change, its name typed over as "Magnesium" and *Save* tapped: the refusal at the foot of the form, below the category control
- [ ] W8 *Nails* opened to change, the *Restart from* picker moved to a day its every-4-days grid is already due on and *Restart* tapped: the refusal under the restart day picker
- [ ] W9 The eight pictures posted to the PR with `gh pr comment --attach` before hand-back, ticked on the comment's URL
