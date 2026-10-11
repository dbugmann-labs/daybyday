**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5):
a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a test that passes before the code it names is written, a carried test
that has to be edited or turns red but for § 2.4's form sweep, a crash in a carried path, or a Kit
signature that has to differ from `design.md` § *The seam*.

Rule 3 governs §§ 3–6: take the next unticked box, write the one test named for it — the scenario
title verbatim, which `pnpm run check:scenarios` checks — watch it fail, make it pass, then the next.

## 1. Before a line is written

- [ ] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly this change's 40 new scenarios uncovered and no other

## 2. The seam and the form

- [ ] 2.1 The members in `design.md` § *The seam* exist with those signatures, and 3.1 is red before any does more than compile
- [ ] 2.2 Every hand enumeration of the four kinds takes declines — `History.holdsRecords`, `hasRecords`, `datesRecorded`, `commitmentsWithRecords`, `settle`, `erase`, `move`, `recordDocumentParts`; `DayView.Row.holdsARecord`; `RecordStore.formed`; `CopyDocument.init` and `formCopy` — each named in the PR body with the scenario that reaches it, or "none reaches it" where none does
- [ ] 2.3 The record form is 9, `declines` judged shape-against-form at 9 as `design.md` § *Migration* says, and every `RecordStore` change writes its next history's parts as § *The store writes what its history holds* says
- [ ] 2.4 The form sweep, the one sanctioned edit of carried tests: the lines naming record form 9 as the later form are made to name form 10 and assert what they asserted before — `RecordStoreTests.swift` 261, 264; `DayScreenTests.swift` 348, 432, 612, 3624, 4295, 7786 — each listed with its before and after in the PR body; any other carried edit is a stop

## 3. `record` — `Decline`, `History`, `RecordStore`

- [ ] 3.1 a decline is formed for a commitment of every kind on a date it is due on, with a reason or none
- [ ] 3.2 a commitment takes no decline on a date it is not due on — catches the kept-from floor skipped
- [ ] 3.3 a commitment on a weekly quota takes no decline on any date — catches the quota let through as due every day
- [ ] 3.4 a reason that says nothing forms no decline — catches a blank reason taken as none
- [ ] 3.5 a reason is kept exactly as given, whatever it holds — catches a trim in the record
- [ ] 3.6 two declines are the same exactly when their commitment, date and reason all are
- [ ] 3.7 a declined day is answered declined, with its reason, and not kept — catches `isKept` or `standing` reading a decline
- [ ] 3.8 a decline added on a declined day replaces it
- [ ] 3.9 a decline added on a day holding any other record leaves the history as it was — catches a short total let through
- [ ] 3.10 a record added on a declined day replaces the decline — catches a decline left beside an addition
- [ ] 3.11 two histories given the same declines in either order are the same history
- [ ] 3.12 a decline taken back leaves its day holding nothing
- [ ] 3.13 taking back a decline where the history holds none leaves it unchanged — catches a take-back that removes a tick
- [ ] 3.14 declines kept in a store are read back by a store opened afterwards, each with its reason
- [ ] 3.15 a record added on a declined day is read back alone by a store opened afterwards — catches a mirror left holding the decline
- [ ] 3.16 a decline that cannot be kept is refused and not held
- [ ] 3.17 a decline on a day a shift put a due day on is read back after the app is closed and opened again — catches the shift left out beside a decline
- [ ] 3.18 a history kept before a day could hold a decline is read with none, and its place left as it was
- [ ] 3.19 a store holding what could not be a decline is refused — catches a decline re-formed without its rules
- [ ] 3.20 a store whose shape and declared form disagree about declines is refused
- [ ] 3.21 a decline is carried over with its reason, character for character — catches `move` left at four kinds

## 4. `day-screen` — `DayView` and `DayScreen`

- [ ] 4.1 a day screen offers declining a row of every kind but a weekly quota's whose day holds nothing
- [ ] 4.2 a day screen offers no decline for a row whose day holds a record — catches `isKept` used in place of any record
- [ ] 4.3 a day screen offers no decline where it is not keeping its record, for a row of a day either side, or for a row a shift took its due day from
- [ ] 4.4 a declined row offers its tick or entry, and a record made through it replaces the decline — catches a blank commit taking the decline back
- [ ] 4.5 a row declined with a reason is kept at the record place, and its row says it is declined with that reason
- [ ] 4.6 a row declined with a blank reason is declined with none
- [ ] 4.7 a declined row's reason is changed or cleared, and the decline stands — catches a cleared reason taking the decline back
- [ ] 4.8 declining a row whose decline is not offered changes nothing and tells nothing — catches `decline` trusting its caller
- [ ] 4.9 a decline the record place cannot keep is refused and told on its row — catches `notice` left standing after a kept decline
- [ ] 4.10 a declined row's decline taken back leaves its day holding nothing
- [ ] 4.11 taking back the decline of a row that is not declined changes nothing and tells nothing
- [ ] 4.12 a decline's take-back or new reason the record place cannot keep is refused and told on its row
- [ ] 4.13 two rows alike but for whether their day is declined, or for its reason, are different rows — catches the reason left out of row equality
- [ ] 4.14 a declined row gives back that it is declined and its whole reason, and says its rhythm — catches a reason cut in the Kit
- [ ] 4.15 a day screen offers no day to shift a declined row — catches `holdsARecord` left at four kinds

## 5. `commitment` — `CommitmentsScreen`

- [ ] 5.1 a deletion erases every decline of its commitment — catches `erase` left at four kinds
- [ ] 5.2 a commitment stopped through a commitments screen on a day it was declined is kept until that day — catches `datesRecorded` left at four kinds

## 6. `restore`

- [ ] 6.1 a decline made, its reason changed and its take-back on a day screen each write a copy at the copy place — catches `copyPlace?.keptAChange()` left out
- [ ] 6.2 a copy holding a decline, restored, puts the decline and its reason back at the record place — catches `formCopy` left at four kinds

## 7. The shell (ADR-1019: no rule the Kit does not state)

- [ ] 7.1 `rowView` and `rowContent` draw the menu, the dash and the reason line exactly as `design.md` § *The shell* says, the menu attached only where `shiftDays(for:)` is non-empty or `offersDecline(for:)` is true, its words exactly the grill's: "Decline", "Reason", "Take back", "Save", "Reason (optional)" and "Cancel"
- [ ] 7.2 The reason sheet opens empty from "Decline" and on the row's reason from "Reason", says "Decline" or "Save" by `isDeclined`, and calls `decline(_:reason:)` alone
- [ ] 7.3 `git diff --stat origin/main... -- src/DayByDay/` lists `ContentView.swift` alone; the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 8. The records

- [ ] 8.1 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2); `CONTEXT.md` and ADR-1068 are as this folder's PR left them, and not edited since G4

## 9. The gates and the archive handover

- [ ] 9.1 `openspec validate decline-a-due-day --strict` exits 0, and `pnpm run checks` is clean but for `check:budgets` warnings on the carried requirements
- [ ] 9.2 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing with 40 more tests than a run on `origin/main` reports, both read off runs
- [ ] 9.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 9.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked, W.10 included, and the walk comment's URL is in W.11. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `record`, `day-screen`, `commitment` and `restore` move, gaining this delta's 40 new scenarios, and no other spec file does. **Any other drift is a stop and a report, never a hand-edit** — the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

A fresh install, walked on the simulator on any day, light only; the day-one week, nothing recorded.

- [ ] W.1 Today's "Magnesium" row long-pressed — the menu holding "Decline" alone, Magnesium being due every day.
- [ ] W.2 "Decline" chosen — the short sheet titled "Magnesium", "Cancel" and "Decline", the field saying "Reason (optional)", keyboard up.
- [ ] W.3 "Ran out" typed and "Decline" tapped — "Magnesium - Every day" with a plain name, a grey dash in the check's place, "Ran out" in grey under it.
- [ ] W.4 That row tapped — the name struck through and grey, the green check, no reason line.
- [ ] W.5 Its tick taken back, the row declined again with "Ran out" and long-pressed — the menu with "Ran out" in grey at its head, "Reason", and "Take back" in red.
- [ ] W.6 "Take back" chosen — "Magnesium - Every day" with nothing in the check's place and no reason line.
- [ ] W.7 "Creatine" ticked and its row long-pressed — no menu opens, Decline nowhere.
- [ ] W.8 The "Yuno" row long-pressed — no menu, Decline nowhere.
- [ ] W.9 Paged back to yesterday, its "Magnesium" row declined with "Away" and its "Weight" row declined with no reason — the dash and "Away" on the one, the dash before the chevron and no line on the other.
- [ ] W.10 phone: a declined row with its reason, in dark — the dash and the reason legible.
- [ ] W.11 **The handover** — W.1–W.9, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL.
