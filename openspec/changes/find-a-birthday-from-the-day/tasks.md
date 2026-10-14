**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a test that passes before the code it names is written, a carried test
that turns red or has to be edited beyond what 2.2 allows, or a Kit signature that has to differ from
`design.md` § *The seam*.

Rule 3 governs § 3: take the next unticked box, write the one test named for it — the scenario title
verbatim, which `pnpm run check:scenarios` checks — watch it fail, make it pass, then the next. Day
screen tests go in `DayScreenBirthdayTests.swift` and Birthdays screen tests in
`BirthdaysScreenTests.swift`, every place a temporary one of the test's own.

## 1. Before a line is written

- [ ] 1.1 From the repo root, `pnpm run check:scenarios` reports three of this change's fifteen scenarios covered — the modified requirement's, carried — and names 3.1 as the next

## 2. The seam

- [ ] 2.1 The `DayScreen` and `BirthdaysScreen` members exist with the signatures in `design.md` § *The seam*, and 3.1 is red before any of them does more than compile
- [ ] 2.2 `CommitmentsScreen.offersGoingToBirthdays` is deleted with the two tests of the removed requirement, its `whileOn:` parameter stays, and every other carried test passes unedited — the three scenarios of the modified requirement included

## 3. The twelve new scenarios of `birthday` — one test each

- [ ] 3.1 a day screen offers the way to the Birthdays screen on whichever day it shows while birthdays are on, and none while they are off — catches the way read off the day shown being today, or on with no calendar
- [ ] 3.2 a day screen whose calendar or birthday ticks cannot be read still offers the way to the Birthdays screen — catches `birthdayState == .on` as the test
- [ ] 3.3 a day screen shown again after the phone withdraws calendar access offers no way to the Birthdays screen — catches the switch not shown again before forming
- [ ] 3.4 a day screen opens the Birthdays screen as of its today whichever day it is showing, and none while birthdays are off — catches the day shown handed as the today
- [ ] 3.5 a Birthdays screen a day screen opens keeps its ideas beside the day screen's record place, and copies to the day screen's copy place — catches `BirthdaysScreen.presentIdeaPlace` or no copy place handed through
- [ ] 3.6 a Birthdays screen with a search lists only the lines whose words hold it, whatever the capitals and accents — catches a prefix match, or the calendar asked again on each edit
- [ ] 3.7 a Birthdays screen's search looks only in a line's words, never in its day, its count of ideas or its ideas — catches a match on what the line draws rather than its words
- [ ] 3.8 a Birthdays screen disregards the spaces before and after its search, and a search of spaces only lists every line — catches the stored search trimmed, or inner spaces collapsed
- [ ] 3.9 a Birthdays screen whose search matches nobody says so, quoting the search without the spaces around it — catches the sentence quoting the raw text, or said for a blank search
- [ ] 3.10 a Birthdays screen offers a search only while it lists a line, and holds none while it offers none — catches a search offered over "No birthdays in the coming year."
- [ ] 3.11 a Birthdays screen keeps its search when an idea is added and when it is shown again, and one opened afresh holds none — catches `keptIdea()` rebuilding `lines` unfiltered
- [ ] 3.12 a Birthdays screen shown again listing nobody ends its search — catches a search held unseen and coming back unasked

## 4. The shell (ADR-1019: no rule the Kit does not state)

- [ ] 4.1 `ContentView` draws the gift first in the trailing capsule exactly while `screen.offersGoingToBirthdays`, opens `screen.birthdaysScreen()` and holds its destination on the day stack, as `design.md` § *The shell* says
- [ ] 4.2 `CommitmentsView` draws no gift, and carries no Birthdays destination or parameter
- [ ] 4.3 `BirthdaysView` draws the field at the foot while `screen.offersSearch` and `nobodyMatches` in the lines card, as § *The shell* and § *What the shell draws* say, with no `.searchable`, composing no string but "Search"
- [ ] 4.4 `git diff --stat origin/main... -- src/DayByDay/` lists those three files alone; the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 5. The records

- [ ] 5.1 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 6. The gates and the archive handover

- [ ] 6.1 `openspec validate find-a-birthday-from-the-day --strict` exits 0, and `pnpm run checks` is clean
- [ ] 6.2 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing with ten more tests than a run on `origin/main` reports, both read off runs
- [ ] 6.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 6.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked — W.3–W.6 by the conductor on the G7 approval — and W.7 holds the walk comment's URL and the commit to install. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `openspec/specs/birthday/spec.md` gains five requirements and twelve scenarios, changes one requirement in place and loses the commitments screen's way-in requirement with its two scenarios, and no other spec file moves. **Any other drift is a stop and a report, never a hand-edit** — the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

W.1 and W.2 run on the simulator on a fresh install, where birthdays are off. Every step with
birthdays on is the phone's (`docs/open-questions.md`: no simulator here gets calendar access); turn
them on in Settings first.

- [ ] W.1 The day screen on today, birthdays off — the trailing capsule holds Commitments and Settings and no gift.
- [ ] W.2 The commitments screen, birthdays off — no gift left of its ⇅ + capsule.
- [ ] W.3 phone: the day screen paged a few days back — the gift leads the trailing capsule; tapped, the Birthdays screen lists from today, soonest first, the search field at its foot.
- [ ] W.4 phone: a few letters of a surname typed, then the same name without its accent where one has one — the list narrows to the lines holding them, each line drawn as before.
- [ ] W.5 phone: letters nobody's name holds typed — "Nobody matches “…”." in a card, quoting them, the field still at the foot.
- [ ] W.6 phone: a search typed, a person's line opened and backed out of — the search and the narrowed list still there; the screen left and opened again — the field empty and the whole list.
- [ ] W.7 **The handover** — W.1 and W.2, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back; the implementer ticks this on that comment's URL and names here the commit the human installs with `pnpm run phone` from this worktree to walk W.3–W.6 at G7.
