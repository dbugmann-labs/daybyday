Anything that fails or surprises is a stop and a report, never a workaround (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a new test that passes before the code it names is written, any carried
test turning red, or a change to `scripts/walk.ts`. Rule 3 throughout: take the next unticked
scenario box, write the one test named for it, watch it fail, make it pass, then the next.

## 1. Before a line is written

- [ ] 1.1 From the repo root, `pnpm run check:scenarios` names this change's uncovered scenarios; they are exactly the twenty-three titles boxed in §§ 3–6. Any other uncovered title is a stop.
- [ ] 1.2 The new tests go in a new `src/DayByDayKit/Tests/DayByDayKitTests/DayScreenBirthdayTests.swift`, with a fake calendar a test fills, fails and counts the asks of, and the fake phone `BirthdaySwitchTests` already drives; every place is a fresh directory.

## 2. The seam

- [ ] 2.1 `BirthdayCalendar`, and the `DayScreen`, `DayScreen.Notice` and `DayView` members, exist with the signatures in `design.md` § *The seam*, and 3.1 is red before any of them does more than compile
- [ ] 2.2 No Kit file imports `EventKit` or reads a locale; the order is the handed collation, then the contact by `<`
- [ ] 2.3 `DayScreen.birthdayPlace` is `ApplicationSupport/DayByDay/birthday-ticks.json`, and `Birthday`, `BirthdayTicks`, `BirthdayStore` and `BirthdaySwitch` are unchanged

## 3. The group and its rows

- [ ] 3.1 a day screen with birthdays on draws the birthdays falling on its day in a group headed Birthdays — catches birthday rows put among the commitment rows
- [ ] 3.2 a birthday row says the calendar's words exactly, and empty words make a row that says nothing and still ticks — catches trimmed words, or a name made up
- [ ] 3.3 a birthday row offers its tick on its day and on any day after it, and none before — catches a tick offered only on today
- [ ] 3.4 two birthday rows are the same row exactly when their birthdays and their ticks agree — catches equality over the words alone
- [ ] 3.5 a day's birthdays are drawn in the order their words are collated in, whatever order the calendar hands them — catches the calendar's order kept

## 4. When birthdays are read

- [ ] 4.1 a day screen with birthdays off asks the calendar nothing and draws no Birthdays group — catches an ask made before the switch is read
- [ ] 4.2 a birthday switch turned on while a day screen is left is followed when it is returned to — catches the switch read only at opening
- [ ] 4.3 a day screen shown again after the phone withdraws calendar access says birthdays are off and asks the calendar nothing — catches the switch shown after the ask
- [ ] 4.4 a day screen asks the calendar once for the day it shows and the day either side, and never to say either — catches a neighbour that asks, or a span that overflows at 9999
- [ ] 4.5 a day screen whose calendar cannot be read draws no Birthdays group and says birthdays could not be read — catches a failure read as a day with no birthdays

## 5. The birthday place and its ticks

- [ ] 5.1 the place a day screen keeps its birthday ticks is a file of the app's own under Application Support, the same every time
- [ ] 5.2 the place a day screen keeps its birthday ticks is none of its other places — catches the switch's file reused
- [ ] 5.3 a day screen reads its birthday place again when shown and not when returned to or moved — catches a place reopened on every forming
- [ ] 5.4 a day screen whose birthday place cannot be read draws its birthdays unticked and keeps no tick — catches a group dropped, or a tick held in memory
- [ ] 5.5 birthday ticks written in a later form make a day screen that says they are from a later version
- [ ] 5.6 ticking a birthday row keeps its tick, and ticking it again takes the tick back — catches a take-back that ticks again
- [ ] 5.7 a birthday row on a past day is ticked against its own day, not the today — catches the today recorded
- [ ] 5.8 a birthday tick that cannot be kept is refused and leaves the day view as it was
- [ ] 5.9 ticking a birthday row that the day view does not hold or that offers no tick changes nothing — catches a neighbour's row ticked

## 6. What is told

- [ ] 6.1 a refused birthday tick is told on its row and ends what was told on a commitment row
- [ ] 6.2 a refused commitment or one-off tick ends what was told on a birthday row — catches two notices at once
- [ ] 6.3 what a day screen tells on a row ends when a birthday tick is kept — catches a birthday tick that leaves the notice standing
- [ ] 6.4 what a day screen tells on a birthday row ends when a commitment tick is kept

## 7. The carried scenarios

- [ ] 7.1 Every scenario the three MODIFIED requirements carry passes with its test unedited, and so does every other test in the suite

## 8. The shell (ADR-1019: no rule the Kit does not state)

- [ ] 8.1 The adapter in `BirthdayCalendarAccess.swift` reads as `design.md` § *The shell* says, through an `EKEventStore` made or reset after access is given, and the collation is `localizedStandardCompare`
- [ ] 8.2 `ContentView` hands the switch and the adapter to the day screen and drops its own scene-phase `birthdaySwitch.shown()`; the three lines, the section and the row are as `design.md` § *The shell* and § *What the shell draws* say, words verbatim
- [ ] 8.3 The app target builds for the simulator

## 9. The records

- [ ] 9.1 Confirm `CONTEXT.md` § *Birthday place* still describes what shipped; a sentence that turns out wrong is a stop and a G4 question, never an edit
- [ ] 9.2 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## The walk

The throwaway test grants calendar access with `xcrun simctl privacy <udid> grant calendar <bundle-id>` or answers the system prompt itself.

- [ ] W.1 The commitments screen with *Birthdays* just turned on — the switch on, the explaining line under it, no refused line.
- [ ] W.2 Tuesday 20 January 2026, reached by paging back — the *Birthdays* group first, holding "Kate Bell’s 48th Birthday" unticked, the *One-offs* group under it.
- [ ] W.3 The same row tapped — grey, struck through, with the green check.
- [ ] W.4 Sent back to today — no *Birthdays* group.
- [ ] W.5 Tuesday 22 June 2027, picked — John Appleseed's row first, faded, above the commitment groups.
- [ ] W.6 phone: birthdays turned on and a day known to be someone's birthday paged to — their row first, in the phone's own words, ticking and unticking with one tap each.
- [ ] W.7 **The handover** — W.1–W.5, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL. W.6 is the human's at G7; the conductor ticks it on the G7 approval.

## 10. Gates and the archive handover

- [ ] 10.1 `openspec validate draw-birthdays-on-day-screen --strict` exits 0, and `pnpm run checks` is clean but for the three carried-requirement word-count warnings `design.md` names
- [ ] 10.2 `pnpm run verify` green, and `swift test` from `src/DayByDayKit` passing, its count read off the run
- [ ] 10.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 10.4 **The implementer ticks this box in its last commit before the archive**, on the evidence that every other box is ticked — W.6 by the conductor at G7 — and the walk comment's URL is in W.7. The janitor then runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, and checks afterwards that `openspec/specs/day-screen/spec.md` gained this delta's ten added requirements, that its three MODIFIED ones are whole, and that no other spec file moved. **Any drift is a stop and a report, never a hand-edit.**
