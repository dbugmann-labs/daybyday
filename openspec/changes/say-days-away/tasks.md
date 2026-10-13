**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5):
a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a test that passes before the code it names is written, a carried test
that has to be edited or turns red but for § 2.3's form sweep, a crash in a carried path, or a Kit
signature that has to differ from `design.md` § *The seam*.

Rule 3 governs §§ 3–7: take the next unticked box, write the one test named for it — the scenario
title verbatim, which `pnpm run check:scenarios` checks — watch it fail, make it pass, then the next.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly this change's 43 new scenarios uncovered and no other

## 2. The seam and the form

- [x] 2.1 The members in `design.md` § *The seam* exist with those signatures, and 3.1 is red before any does more than compile
- [x] 2.2 The roster form is 10, `daysAway` said once of the whole roster and judged shape-against-form at 10 as `design.md` § *Migration* says, and saying, removing, a change, a stop and a deletion each write the next roster's eras and days away in one write, as ADR-1069 says
- [x] 2.3 The form sweep, the one sanctioned edit of carried tests: the lines naming roster form 10 as the later form are made to name form 11, and the write asserted at form 9 to assert form 10, each asserting what it asserted before — `DayScreenTests.swift` 995, 1205, 3433, 3610, 3627; `RosterStoreTests.swift` 324, 327, 1980, 1983, 4257; `CommitmentsScreenTests.swift` 2271 — each listed with its before and after in the PR body; any other carried edit is a stop
- [x] 2.4 A unit test beside the scenarios: a look-back at a commitment with days away ahead is the same look-back as one taken before they were said

## 3. `commitment` — saying days away

- [x] 3.1 days away said over two commitments leave them no row on their days and rows again from the day after
- [x] 3.2 days away keep their name trimmed, and a name that says nothing is none — catches a blank name stored as a name
- [x] 3.3 days away of one day are said, and so are days away of any length however far ahead — catches a maximum or a last day after the first required
- [x] 3.4 a commitment is taken up again after days away on the rhythm, range and target it had, an every-N-days count beginning again — catches the old start date carried
- [x] 3.5 days away from today keep a commitment that holds a record today until today, and the others until the day before — catches the record read after the day is fixed
- [x] 3.6 days away from a day already gone, ending before they begin, or over nothing are refused and keep nothing
- [x] 3.7 days away over a commitment other days away are over on a shared day are refused, naming those days away — catches overlap judged on dates alone
- [x] 3.8 days away over a commitment kept from their first day or later are refused, naming it — catches "after" read strictly
- [x] 3.9 days away over a commitment with a shift on one of their days are refused, naming it
- [x] 3.10 days away a commitments screen cannot keep at its roster place are refused
- [x] 3.11 a commitments screen asked to say days away over a commitment it does not keep does nothing
- [x] 3.12 a refusal of days away is told until the sheet is edited or closed, days away are kept, or the app is shown again — catches `endedByAChangeOrByBeingShown` ending it on a stop

## 4. `commitment` — listing and removing

- [x] 4.1 a commitments screen lists days away by name or Away, with their days in words and their commitments, earliest first — catches names stored rather than read
- [x] 4.2 days away leave the list once their last day has passed and stay at the roster place — catches a past span deleted
- [x] 4.3 a commitments screen that cannot read its roster lists no days away
- [x] 4.4 asking to remove days away changes nothing until it is confirmed, and a cancel changes nothing
- [x] 4.5 days away removed before they begin leave their commitments as though never said — catches an interval count restarted on the day after
- [x] 4.6 days away already begun offer no removal, and asking to remove them does nothing
- [x] 4.7 a commitments screen awaits one removal, stop or deletion at a time — catches `awaitNothing` left without the removal
- [x] 4.8 days away removed beside other days away over the same commitment leave the other's gap where it was
- [x] 4.9 days away removed after a change of rhythm leave that change standing from the day it was made
- [x] 4.10 a removal a commitments screen cannot keep at its roster place is refused and the days away stay listed

## 5. `commitment` — a stop, a deletion, a change, the store and the shift

- [x] 5.1 a commitment stopped before its days away begin leaves them, and they stay over the others
- [x] 5.2 a commitment stopped while its days away are under way is kept until the day before them
- [x] 5.3 days away a stop leaves over no commitment go from the roster
- [x] 5.4 a deletion takes a commitment out of its days away, past ones included, and days away left over none go
- [x] 5.5 a stopped commitment stays in days away already past — catches a stop reaching every span
- [x] 5.6 a rhythm changed before days away begin holds before them and after them, and not on their days — catches the mend erasing the gap
- [x] 5.7 a rhythm changed while days away are under way holds from the day after them
- [x] 5.8 an every-N-days count changed before days away begins again on the day after them
- [x] 5.9 the day kept from moved onto or past days away is refused, naming them
- [x] 5.10 days away kept at a roster place are read back after the app is closed and opened again
- [x] 5.11 a roster kept before days away could be said is read with none, and its place left as it was
- [x] 5.12 a roster store holding days away no roster could hold is refused
- [x] 5.13 a roster store whose shape and declared form disagree about days away is refused
- [x] 5.14 a roster shifts an every-N-days due day before days away said over it — catches `laterEra` left unchanged

## 6. `day-screen`

- [x] 6.1 a day screen says the name of days away on each of their days, and nothing either side — catches the neighbour views formed without the lines
- [x] 6.2 days away with no name are said as Away, and two on one day in the order of their first days
- [x] 6.3 days away are said on days already gone, and on a first day a commitment is kept through — catches lines read off the gaps
- [x] 6.4 a day screen's week strip marks each day of days away as away, whatever is recorded — catches a neighbour strip left unmarked
- [x] 6.5 a weekly-quota row on today owing every day left before days away later in its week is marked Needed today — catches `hasNoSlack` left on calendar days

## 7. `restore`

- [x] 7.1 days away said and removed on a commitments screen each write a copy at the copy place — catches `copyPlace?.keptAChange()` left out
- [x] 7.2 a copy holding days away, restored, puts them and their gaps back at the roster place

## 8. The shell (ADR-1019: no rule the Kit does not state)

- [x] 8.1 `CommitmentsView` draws the Days away card, its swipe, its alert and its sheet exactly as `design.md` § *The shell* says, its words exactly those there, "Add" disabled while nothing is picked, the sheet calling `sayDaysAway` alone
- [x] 8.2 `ContentView` draws the away lines first in the day list and the strip's dot where `isAway`, as § *The shell* says; nothing else on the day screen moves
- [x] 8.3 `git diff --stat origin/main... -- src/DayByDay/` lists `CommitmentsView.swift` and `ContentView.swift` alone; the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 9. The records

- [x] 9.1 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2); `CONTEXT.md` and ADR-1069 are as this folder's PR left them, and not edited since G4

## 10. The gates and the archive handover

- [x] 10.1 `openspec validate say-days-away --strict` exits 0, and `pnpm run checks` is clean but for the one `check:budgets` warning on the carried change requirement
- [x] 10.2 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing with 44 more tests than a run on `origin/main` reports — one for each of the 43 new scenarios and 2.4's — both read off runs
- [x] 10.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [x] 10.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked, W.6 included, and the walk comment's URL is in W.7. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `commitment`, `day-screen` and `restore` move, gaining this delta's 43 new scenarios, and no other spec file does. **Any other drift is a stop and a report, never a hand-edit** — the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

A fresh install, walked on the simulator on any day, light only, the day-one week, nothing recorded;
the days away are said from tomorrow, so the walk pages forward rather than moving the clock.

- [x] W.1 Commitments screen, "New days away" tapped — the empty sheet titled "Days away": "Name (optional)", "First day" and "Last day" on today, every kept commitment with an empty circle, "Add" greyed out.
- [x] W.2 "Mallorca" typed, the first day tomorrow and the last day six days on, "Gym" and "Run" picked — two filled circles, "Add" enabled.
- [x] W.3 "Add" tapped — the commitments screen scrolled to its foot, the Days away card between Stopped and Happenings holding "Mallorca - <first> – <last>" over "Gym, Run".
- [x] W.4 The day screen paged forward to the first day of "Mallorca" on which "Gym" or "Run" is due — "Mallorca" as a bare line above the rows, a dot under each of its days on the strip, neither "Gym" nor "Run" among the rows, "Creatine" and "Magnesium" there.
- [x] W.5 The sheet opened again, "Gym" picked over the last two days of "Mallorca" and the day after, "Add" tapped — the sheet still open over its red refusal naming "Mallorca".
- [x] W.6 "Mallorca" swiped, the trash and "Remove" in the alert tapped, the day screen paged forward again to that same day — no line, no dots, and the row of "Gym" or "Run" due that day back.
- [x] W.7 **The handover** — W.1–W.6, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL. Posted: https://github.com/dbugmann-labs/daybyday/pull/414#issuecomment-6139660419
