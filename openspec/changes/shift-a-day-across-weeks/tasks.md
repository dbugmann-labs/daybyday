**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5):
a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a test that passes before the code it names is written, a carried test
that has to be edited or turns red but for § 2.2's form sweep and the boxes below that name an edit,
a crash in a carried path, a Kit signature that has to differ from `design.md` § *The seam*, or a
diff that reaches `src/DayByDay/`.

Rule 3 governs §§ 3–5: take the next unticked box, write the one test named for it — the scenario
title verbatim, which `pnpm run check:scenarios` checks — watch it fail, make it pass, then the next.
A box that names a carried test edits that test instead, its before and after listed in the PR body.

## 1. Before a line is written

- [ ] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly this change's 12 new titles uncovered — 9 new scenarios and 3 renamed — and no other

## 2. The forms

- [ ] 2.1 The roster form is 12 and the record form 10, neither with a change of shape, each part still judged shape-against-form at the form it was first written at, as `design.md` § *Migration* says
- [ ] 2.2 The form sweep: the carried lines naming roster form 12 or record form 10 as the later form, or roster form 11 or record form 9 as the current one, are made to name the later or current form again and assert what they asserted before, each listed with its before and after in the PR body

## 3. `commitment` — `Roster`, `RosterStore`

- [ ] 3.1 a roster shifts a one-weekday due day onto any day between its due days either side, a week crossed or not — catches the week rule left in `Roster.shift`
- [ ] 3.2 a roster refuses to shift a one-weekday due day onto its due day either side or a day beyond them — catches a fixed ±7-day window
- [ ] 3.3 a weekday-set due day is shifted past its own due days inside its week, and outside it only up to them — catches "between neighbours" alone
- [ ] 3.4 a roster shifts a day-of-month due day onto any day between its due days either side, about a month each way — catches a neighbour search that stops at seven days
- [ ] 3.5 a day a shift put into another week, shifted again, is judged from the day it came from — catches the landing's week judged
- [ ] 3.6 the due days either side of a day are its schedule's, never where another shift put one — catches due days read through shifts
- [ ] 3.7 a roster shifts a weekday-set or day-of-month due day across days away, inside its week or past it, and onto none of their days — catches the every-N-days crossing rule applied to every shape
- [ ] 3.8 a weekday-set or day-of-month shift across a week is held by a roster store opened afterwards — catches the week rule left on the roster store's read
- [ ] 3.9 a roster refuses to shift a due day onto one of its own days, a day another shift put a due day on, or a day past both its week and its due days either side — the carried test renamed from "…or a day of another week", its body unchanged
- [ ] 3.10 a roster store holding a shift no roster could hold is refused — the carried test's Sunday-to-Monday case is dropped and its same-day case made the first, as the delta now reads
- [ ] 3.11 a stop confirmed on the day a shift put a due day on ends that due day unless the day holds a record of it — the carried test's row words dated
- [ ] 3.12 a shift with no day after the day handed refuses no change and stands through it — the carried test's row words dated

## 4. `day-screen` — `DayView` and `DayScreen`

- [ ] 4.1 a day screen offers a one-weekday row the days between its due days either side, and a day-of-month row about a month each way, each said with its date — catches the week's seven days walked
- [ ] 4.2 a day screen offers a weekday-set row the free days of its week and of its due days either side, each said with its date — the carried test renamed from "…of its week, Monday first, each said as its weekday", its days and words rewritten
- [ ] 4.3 a day screen offers a row a shift put its due day on the free days of the day it came from, and that day — the carried test renamed from "…of its week and the day it came from", its days rewritten and Pool's assertion added
- [ ] 4.4 a day screen offers no day to shift a row whose day holds a record — the carried test's offered days gain Sunday 30 August
- [ ] 4.5 a day screen offers no day to shift an every-N-days row while a later day holds a record of it — the carried test's "Gym" days gain Sunday 30 August
- [ ] 4.6 a day screen offers no day to shift a declined row — the carried test's offered days gain Sunday 30 August
- [ ] 4.7 a row says where a shifted due day came from, and the row of the day it left says where it went — the carried test's words dated and Pool's assertion added; catches the every-N-days branch left in the row's words
- [ ] 4.8 a group holding only a row a shift took a due day from is still drawn — the carried test's row words dated
- [ ] 4.9 a row's due day shifted to a day offered is kept at the roster place, and the day view says where it went — the carried test's words dated and Pool's assertion added; catches `shift(_:to:)` refusing a day across a week
- [ ] 4.10 a day shifted back to the day it came from leaves both days as they were — Pool's assertion added to the carried test; catches a landing in another week that cannot go back
- [ ] 4.11 a day screen offers no decline where it is not keeping its record, for a row of a day either side, or for a row a shift took its due day from — the carried test's row words dated

## 5. `record` — `RecordStore`

- [ ] 5.1 a store holding a record beside a shift that could not be one is refused — the carried test's week-before case is replaced by its own-date case, and Pool's read added; catches the week rule left on the record store's read

## 6. The records

- [ ] 6.1 `git diff --stat origin/main... -- openspec/specs/ src/DayByDay/` reports nothing (rule 2, and the shell composes no words); `CONTEXT.md` and ADR-1066 are as this folder's PR left them, and not edited since G4

## 7. The gates and the archive handover

- [ ] 7.1 `openspec validate shift-a-day-across-weeks --strict` exits 0, and `pnpm run checks` is clean but for `check:budgets` warnings on the carried requirements
- [ ] 7.2 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing with 9 more tests than a run on `origin/main` reports, the three renames being renames, both read off runs
- [ ] 7.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 7.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked and the walk comment's URL is in W.6. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `commitment`, `day-screen` and `record` move, and no other spec file does. **Any other drift is a stop and a report, never a hand-edit** — the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

A fresh install, light only, on the real date. "Pool", on Friday, and "Gym", on Monday, Wednesday and
Saturday, are made kept from a day more than a week before the Friday, and nothing is ticked. "The Friday" is the
latest Friday before today; "its Monday" the Monday of that week; "the Monday after" the one after it.

- [ ] W.1 The Friday, Pool's row long-pressed — "Shift to" open, its submenu every day from the Saturday before through the Thursday after but the Friday, twelve in all, each said as "Sat 29 Aug" is.
- [ ] W.2 The Monday after, once Pool's row is shifted there — "Pool - from Fri" and the Friday's date, unticked, faded only where that Monday is after today.
- [ ] W.3 The Friday, paged back to — "Pool - to Mon" and the Monday after's date, the whole row faded.
- [ ] W.4 Its Monday, Gym's row long-pressed — the submenu the Sunday before, Tuesday, Thursday, Friday and Sunday of that week, each said with its date.
- [ ] W.5 The Friday, paged to once Pool's row on the Monday after is shifted back to it from its menu — "Pool - Fri", not faded.
- [ ] W.6 **The handover** — W.1–W.5, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL.
