**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5):
a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a test that passes before the code it names is written, a carried test
that has to be edited or turns red but for § 2.4's form sweep, a crash in a carried path, or a Kit signature that has to differ
from `design.md` § *The seam*.

Rule 3 governs §§ 3–7: take the next unticked box, write the one test named for it — the scenario
title verbatim, which `pnpm run check:scenarios` checks — watch it fail, make it pass, then the next.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly this change's 39 new scenarios uncovered and no other

## 2. The seam and the forms

- [x] 2.1 The six new members exist with the signatures in `design.md` § *The seam*, and 3.1 is red before any does more than compile
- [x] 2.2 Every `Commitment` initialiser forming an era or a rename carries the shifts; `CommitmentRecord.bare` drops them
- [x] 2.3 The roster form is 8 and the record form 7, each judged shape-against-form at the form its part was first written at, as `design.md` § *Migration* says
- [x] 2.4 The form sweep, the one sanctioned edit of carried tests: the lines naming record form 7 or roster form 8 as the later form, or roster form 7 as the current one, are made to name the later or current form again and assert what they asserted before — `DayScreenTests.swift` 348, 432, 612, 995, 1205, 3433, 3610, 3624, 3627, 4295, 7786; `RecordStoreTests.swift` 261, 264; `RosterStoreTests.swift` 1980, 1983, 3270, 3303, 3366, 4254, 4303–4315, 4345; `CommitmentsScreenTests.swift` 2271 — each listed with its before and after in the PR body; any other carried edit is a stop

## 3. `commitment` — `Roster`, `RosterStore`, `CommitmentsScreen`

- [x] 3.1 a commitment is not due on the day a shift took its due day from, and is due on the day it put it on — catches `isDue` answering the schedule alone
- [x] 3.2 a roster shifts a weekday-set due day onto a free day and leaves the rest of its rhythm as it was — catches a shift written as a new era
- [x] 3.3 a roster shifts a day-of-month due day across the end of its month, inside its week — catches the month taken as the bound
- [x] 3.4 a roster refuses to shift a due day onto one of its own days, a day another shift put a due day on, or a day of another week — catches a landing read as free
- [x] 3.5 a roster refuses to shift a due day onto a day the era holding it does not hold — catches a gap or another era's day offered
- [x] 3.6 a roster refuses to shift a day the commitment is not due on, and an every-N-days due day — catches an origin shifted again
- [x] 3.7 a roster shifts a day of a commitment it has stopped, and refuses one it does not hold
- [x] 3.8 a day a shift put a due day on, shifted again, keeps the day it came from — catches a chain of two shifts
- [x] 3.9 a day a shift put a due day on, shifted to the day it came from, leaves no shift — catches a shift kept from a day to itself
- [x] 3.10 a rhythm change is refused while a shift has a day after the day handed — catches the landing alone checked
- [x] 3.11 a range or a target change is refused while a shift has a day after the day handed
- [x] 3.12 a move of the day kept from is refused while a shift has a day after the day handed
- [x] 3.13 a stop is refused while a shift has a day after the day handed — catches `confirmStopKeeping` bypassing the check
- [x] 3.14 a stop confirmed on the day a shift put a due day on ends that due day unless the day holds a record of it — catches `>=` for `>` in the stop's check
- [x] 3.15 a rename and a category are not refused while a shift has a day after the day handed — catches every change refused
- [x] 3.16 a shift with no day after the day handed refuses no change and stands through it — catches `>=` for `>`, and an era dropping the shifts
- [x] 3.17 a shift kept at a roster place is held by a roster store opened afterwards at the same place
- [x] 3.18 a roster kept in the form before shifts is read as holding none, and its place is left as it was
- [x] 3.19 a roster store whose shape and declared form disagree about shifts is refused — catches shifts judged at the newest form only
- [x] 3.20 a roster store holding a shift no roster could hold is refused — catches eras read without agreeing
- [x] 3.21 a roster refuses to shift a due day back to the day it came from once no era is due on that day — catches the day a shift came from taken as free wherever it falls; `pnpm run check:scenarios` reports it alone uncovered before its test is written, and that test is seen red on the code as G7 found it

## 4. `record` — `RecordStore`

- [x] 4.1 records on a day a shift put a due day on are read back after the app is closed and opened again — catches the shift dropped from the record form
- [x] 4.2 a store holding a record beside a shift that could not be one is refused — catches the week left unchecked
- [x] 4.3 a store whose shape and declared form disagree about shifts is refused

## 5. `day-screen` — `DayView` and `DayScreen`

- [x] 5.1 a row of a day a shift took a due day from offers nothing, whatever its kind — catches an entry offered off the date alone
- [x] 5.2 a group holding only a row a shift took a due day from is still drawn — catches the group dropped as having nothing due
- [x] 5.3 a row of a day a shift took its due day from is a different row from the one that day held before — catches the shift left out of row equality
- [x] 5.4 a row says where a shifted due day came from, and the row of the day it left says where it went
- [x] 5.5 a day screen offers a row the free days of its week, Monday first, each said as its weekday
- [x] 5.6 a day screen offers a row a shift put its due day on the free days of its week and the day it came from
- [x] 5.7 a day screen offers no day to shift a row whose day holds a record — catches `isKept` used in place of any record
- [x] 5.8 a day screen offers no day to shift a row where it is not keeping its record, nor a row of a day either side
- [x] 5.9 a row's due day shifted to a day offered is kept at the roster place, and the day view says where it went
- [x] 5.10 a day shifted back to the day it came from leaves both days as they were
- [x] 5.11 shifting a row to a day not offered changes nothing — catches `shift` trusting its caller
- [x] 5.12 a shift the roster place cannot keep is refused and told on its row

## 6. `look-back`

- [x] 6.1 a weekday-set day shifted into the next month is counted due and kept there
- [x] 6.2 a day-of-month day shifted into the month before leaves that month owing two days and its own none

## 7. `restore`

- [x] 7.1 a shift kept on a day screen writes a copy at the copy place holding that shift — catches `copyPlace?.keptAChange()` left out
- [x] 7.2 a shift refused, or asked of a day not offered, writes no copy at the copy place

## 8. The shell (ADR-1019: no rule the Kit does not state)

- [x] 8.1 `rowView` draws the long-press menu exactly as `design.md` § *The shell* says, attached only where `shiftDays(for:)` is non-empty, composing no words of its own
- [x] 8.2 `refusalText` says "Shift its day back first." for `.shiftedDayAhead`, and a refused stop draws it where a refused stop already draws
- [x] 8.3 `git diff --stat origin/main... -- src/DayByDay/` lists `ContentView.swift` and `CommitmentsView.swift` alone; the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 9. The records

- [ ] 9.1 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2); `CONTEXT.md` and ADR-1066 are as this folder's PR left them, and not edited since G4

## The G7 fixes

Worked after 3.21 and before § 10, whose gates they reopen.

- [x] F.1 `notice = nil` is deleted from `DayScreen.shift(_:to:)`, after the test of 5.9 gains an assertion that what a day screen tells on another row still stands once the shift is kept, seen red with the line still there; no other line of `shift(_:to:)` changes
- [x] F.2 The test "a row the screen offers no day is shifted nowhere, though its roster would take the shift" is deleted from `DayScreenShiftTests.swift`: it names no scenario and attaches below the seam, and 10.2 counts one test per new scenario
- [x] F.3 W.6 carries the walk comment's URL, https://github.com/dbugmann-labs/daybyday/pull/396#issuecomment-6047637146; 3.21, F.1 and F.2 change no state W.1–W.5 drive to, so those pictures stand for the final build, and a fix that does change one is a stop

## 10. The gates and the archive handover

- [ ] 10.1 `openspec validate shift-a-due-day --strict` exits 0, and `pnpm run checks` is clean but for `check:budgets` warnings on the carried requirements
- [ ] 10.2 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing with 40 more tests than a run on `origin/main` reports, both read off runs
- [ ] 10.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 10.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked and the walk comment's URL is in W.6. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `commitment`, `day-screen`, `record`, `look-back` and `restore` move, gaining this delta's 40 new scenarios, and no other spec file does. **Any other drift is a stop and a report, never a hand-edit** — the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

A fresh install, walked on any day but a Sunday, light only. "Gym" is made on the commitments screen
on Monday, Wednesday and Saturday, kept from a day before this week, and nothing is ticked.

- [x] W.1 Monday's "Gym" row, paged back to where today is later, long-pressed — the menu open on "Shift to", its submenu "Tue", "Thu", "Fri", "Sun".
- [x] W.2 Tuesday, once Monday's row is shifted there — "Gym - from Mon", unticked, not faded.
- [x] W.3 Monday, paged back — "Gym - to Tue", the whole row faded.
- [x] W.4 Saturday's row shifted to Sunday through its own menu, then "Gym"'s change sheet asked for Tuesday and Thursday — refused, "Shift its day back first." under the rhythm field.
- [x] W.5 Tuesday's row shifted back to Monday, then Monday paged to — "Gym - Mon, Wed, Sat", not faded, and Tuesday holds no "Gym" row.
- [x] W.6 **The handover** — W.1–W.5, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL.
