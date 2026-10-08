**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5):
a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a test that passes before the code it names is written, a carried test
that has to be edited or turns red but for § 2.3's form sweep and 3.10's rename, a crash in a
carried path, a Kit signature that has to differ from `design.md` § *The seam*, or a diff that
reaches `src/DayByDay/`.

Rule 3 governs §§ 3–7: take the next unticked box, write the one test named for it — the scenario
title verbatim, which `pnpm run check:scenarios` checks — watch it fail, make it pass, then the next.

## 1. Before a line is written

- [ ] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly this change's 22 new scenarios uncovered and no other

## 2. The forms

- [ ] 2.1 The record form is 8 and the roster form 9, each judged shape-against-form at the form its part was first written at, as `design.md` § *Migration* says
- [ ] 2.2 `CommitmentRecord` writes and reads the day a shift put a due day on beside a record on a later day of a shifted count; `bare` drops it as it drops the rest
- [ ] 2.3 The form sweep, the one sanctioned edit of carried tests: the lines naming record form 8 or roster form 9 as the later form, or record form 7 or roster form 8 as the current one, are made to name the later or current form again and assert what they asserted before — in `DayScreenTests.swift`, `RecordStoreTests.swift`, `RosterStoreTests.swift`, `CommitmentsScreenTests.swift`, `RecordShiftTests.swift` and `RosterShiftTests.swift` — each listed with its before and after in the PR body; any other carried edit is a stop

## 3. `commitment` — `Commitment`, `Roster`, `RosterStore`, `CommitmentsScreen`

- [ ] 3.1 an every-N-days commitment is due counting on from the day a shift put its due day on — catches the landing alone made due
- [ ] 3.2 an every-N-days count runs on from a shift only where the shift took a due day on or after its start date — catches an older count's shift carried into a new interval
- [ ] 3.3 a roster shifts an every-N-days due day onto any day between the due days either side of it, a week crossed or not — catches the week rule left on intervals
- [ ] 3.4 a roster refuses to shift an every-N-days due day onto a due day either side of it, a day beyond them, or itself
- [ ] 3.5 an era's first every-N-days due day is shifted back no further than the day that era is kept from — catches the previous due day taken as the bound
- [ ] 3.6 a roster refuses to shift an every-N-days due day while a later shift or a later era of it stands
- [ ] 3.7 an every-N-days day a shift put a due day on, shifted again, keeps the day it came from and that day's bounds — catches the landing's own neighbours taken as bounds
- [ ] 3.8 a roster refuses to shift an every-N-days due day onto a day another shift took a due day from
- [ ] 3.9 a roster shifts an every-N-days day of a commitment it has stopped only onto a day it held — catches a stop read as a later change
- [ ] 3.10 a roster refuses to shift a day the commitment is not due on, and a weekly-quota day — the carried test of the scenario it replaces is renamed to this title and its every-N-days assertion rewritten as the weekly-quota one, its before and after in the PR body
- [ ] 3.11 an every-N-days shift across a week is held by a roster store opened afterwards — catches the week rule left on the roster store's read
- [ ] 3.12 a range or a target change keeps an every-N-days count running from its start date — catches `Rhythm.schedule(keptFrom:)` used for every change
- [ ] 3.13 a range change keeps an every-N-days count running from the day a shift put a due day on

## 4. `record` — `RecordStore`

- [ ] 4.1 records on every-N-days days a shifted count runs on to are read back after the app is closed and opened again — catches only a landing's shift written beside a record
- [ ] 4.2 a store holding a record beside an every-N-days shift that could not be one is refused — catches `isDue` taken as the whole check
- [ ] 4.3 a store whose shape and declared form disagree about the day a shift put a due day on is refused

## 5. `day-screen` — `DayView` and `DayScreen`

- [ ] 5.1 a day screen offers an every-N-days row the days between its due days either side, each said with its date — catches the seven days of the week walked
- [ ] 5.2 a day screen offers an every-N-days row a shift put its due day on the days of the day it came from, that day included
- [ ] 5.3 a day screen offers no day to shift an every-N-days row while a later day holds a record of it — catches the rule applied to every shape
- [ ] 5.4 an every-N-days row shifted through a day screen runs its count on from the day it landed
- [ ] 5.5 an every-N-days row says where its shifted due day came from, and the row of the day it left where it went, each by weekday and date

## 6. `look-back`

- [ ] 6.1 an every-N-days day shifted back into the month before moves every later due day with it — catches the weekday rule's "one fewer" applied to intervals

## 7. The records

- [ ] 7.1 `git diff --stat origin/main... -- openspec/specs/ src/DayByDay/` reports nothing (rule 2, and the shell composes no words); `CONTEXT.md` and ADR-1066 are as this folder's PR left them, and not edited since G4

## 8. The gates and the archive handover

- [ ] 8.1 `openspec validate shift-an-interval-day --strict` exits 0, and `pnpm run checks` is clean but for `check:budgets` warnings on the carried requirements
- [ ] 8.2 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing with 21 more tests than a run on `origin/main` reports, 3.10's being a rename, both read off runs
- [ ] 8.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 8.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked and the walk comment's URL is in W.9. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `commitment`, `day-screen`, `record` and `look-back` move, and no other spec file does. **Any other drift is a stop and a report, never a hand-edit** — the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

A fresh install, light only, on the real date. Nothing is made: the day-one "Nails", every 4 days,
and "Contact lenses", every 14 days, are walked as they stand, and nothing is ticked. "Nails' due
day" is its latest due day on or before today.

- [ ] W.1 Nails' due day, paged back to where needed, its row long-pressed — "Shift to" open, its submenu the six days either side, each said as "Thu 27 Aug" is, its own day not among them.
- [ ] W.2 The day after Nails' due day, once the row is shifted there — "Nails - from" and the due day's weekday and date, unticked, not faded.
- [ ] W.3 The due day, paged back — "Nails - to" and the landing's weekday and date, the whole row faded.
- [ ] W.4 Four days after the landing — a "Nails" row saying "Every 4 days".
- [ ] W.5 Four days after the due day — no "Nails" row.
- [ ] W.6 Nails' due day before that one, its row long-pressed — no menu opens.
- [ ] W.7 The landing's row shifted back to the due day, then the due day paged to — "Nails - Every 4 days", not faded, and the landing holds no "Nails" row.
- [ ] W.8 Contact lenses' latest due day on or before today, its row long-pressed — the submenu of 26 days, each said with its date.
- [ ] W.9 **The handover** — W.1–W.8, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL.
