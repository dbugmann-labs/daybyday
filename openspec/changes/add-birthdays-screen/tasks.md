**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a test that passes before the code it names is written, a carried test
that has to be edited or turns red, or a Kit signature that has to differ from `design.md` § *The
seam*.

Rule 3 governs § 3: take the next unticked box, write the one test named for it — the scenario title
verbatim, which `pnpm run check:scenarios` checks — watch it fail, make it pass, then the next. Every
test goes in `src/DayByDayKit/Tests/DayByDayKitTests/BirthdaysScreenTests.swift`, with a fake
calendar, a fake phone and a switch place of its own, as `DayScreenBirthdayTests.swift` builds them.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly this change's fourteen scenarios uncovered and no other

## 2. The seam

- [x] 2.1 `BirthdaysScreen`, its `Line` and `BirthdayState`, `CommitmentsScreen`'s `whileOn` parameter and `offersGoingToBirthdays`, and `DayTitle.birthdayDayInWords` exist with the signatures in `design.md` § *The seam*, and 3.1 is red before any of them does more than compile
- [ ] 2.2 Every existing `CommitmentsScreen(...)` call site compiles unchanged, and every carried `CommitmentsScreen`, `DayScreen` and `BirthdaySwitch` test passes unedited
- [ ] 2.3 `BirthdaysScreen` takes no place, opens no store and writes nothing, and asks its calendar only from `init` and `shown(asOf:)`

## 3. The fourteen scenarios of `birthday` — one test each

- [x] 3.1 a Birthdays screen asks the calendar once, for the days from its today through the day before the same date a year later — catches a 365-day span, or an ask on every read of the lines
- [x] 3.2 a Birthdays screen lists each birthday handed in its span as often as it is handed, and none handed outside it — catches the calendar's answer listed unfiltered, or duplicates merged
- [ ] 3.3 a Birthdays screen takes a new today only when it is shown again — catches a today read off a clock, or "Today" kept from the opening day
- [ ] 3.4 a Birthdays screen lists the soonest birthday first, whatever order the calendar hands them in — catches the handed order kept, or a month-and-day sort that puts January before November
- [ ] 3.5 a Birthdays screen lists one day's birthdays in the order their words are collated in — catches collation outranking the day
- [ ] 3.6 a Birthdays screen line says the calendar's words exactly, and its day as weekday, day and month — catches trimmed words, a leading zero or a year
- [ ] 3.7 a Birthdays screen line says Today for a birthday falling on its today, and the date for any other — catches "Tomorrow", or a year said for a date in the next one
- [ ] 3.8 a Birthdays screen says each month by its own name — catches a month table of its own with a typo
- [ ] 3.9 a Birthdays screen opened with birthdays off lists nothing, says they are off and asks the calendar nothing — catches an ask made before the switch is read
- [ ] 3.10 a Birthdays screen shown again after the phone withdraws calendar access lists nothing and says birthdays are off — catches `shown(asOf:)` asking the calendar before showing the switch
- [ ] 3.11 a Birthdays screen with birthdays on and nobody handed in its span lists nothing and says birthdays are on — catches an empty list read as off
- [ ] 3.12 a Birthdays screen whose calendar cannot be read lists nothing and says birthdays could not be read — catches a failure that sticks after the calendar answers
- [ ] 3.13 a commitments screen offers the way to the Birthdays screen while birthdays are on, and none while they are off — catches the switch read once at `init`
- [ ] 3.14 a commitments screen shown again after the phone withdraws calendar access offers no way to the Birthdays screen — catches `shown(asOf:)` leaving the switch unshown

## 4. The shell (ADR-1019: no rule the Kit does not state)

- [ ] 4.1 `ContentView` holds one `BirthdayCalendar` for the `DayScreen` and every `BirthdaysScreen`, hands the switch to the Commitments tap's `CommitmentsScreen` alone, and shows the open `BirthdaysScreen` when the app is shown, as `design.md` § *The shell* says
- [ ] 4.2 `CommitmentsView` draws the gift item, labelled "Birthdays", in its own circle while `screen.offersGoingToBirthdays`, with the push's `navigationDestination` on the list and not on the item
- [ ] 4.3 `BirthdaysView` draws `lines` and the one sentence for an empty list exactly as `design.md` § *The shell* and § *What the shell draws* say, composing no string but "Birthdays" and those three sentences
- [ ] 4.4 `git diff --stat origin/main... -- src/DayByDay/` lists `ContentView.swift`, `CommitmentsView.swift` and `BirthdaysView.swift` alone; the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 5. The records

- [ ] 5.1 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 6. The gates and the archive handover

- [ ] 6.1 `openspec validate add-birthdays-screen --strict` exits 0, and `pnpm run checks` is clean
- [ ] 6.2 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing with fourteen more tests than a run on `origin/main` reports, both read off runs
- [ ] 6.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 6.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked — W.2–W.4 by the conductor at G7 — and the walk comment's URL is in W.5. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `openspec/specs/birthday/spec.md` gains this delta's six requirements and fourteen scenarios, and no other spec file moves. **Any other drift is a stop and a report, never a hand-edit** — the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

A fresh install, so birthdays are off. Every step with birthdays on is the phone's (`docs/open-questions.md`: no simulator here gets calendar access).

- [ ] W.1 The commitments screen with birthdays off — its toolbar the ⇅ + capsule alone, no gift symbol.
- [ ] W.2 phone: birthdays turned on in Settings, then the commitments screen — the gift symbol in its own circle, left of the ⇅ + capsule.
- [ ] W.3 phone: the gift tapped — the large title "Birthdays" over one card, today's birthdays (if any) first saying "Today", then soonest first, each line the calendar's words beside its date as "Sat 14 November", dimmed and right-aligned, with no chevron, tick or 🎂.
- [ ] W.4 phone: back to the day screen, birthdays turned off in Settings, then the commitments screen — no gift symbol.
- [ ] W.5 **The handover** — W.1, taken on the final build, is posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL. W.2–W.4 are the human's at G7; the conductor ticks them on the G7 approval.
