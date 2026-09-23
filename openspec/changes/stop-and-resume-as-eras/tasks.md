A command that fails or does something unexplained is a stop and a report, not a thing to work
around (`AGENTS.md` rule 5). Rule 3 throughout: one scenario, one acceptance test named identically
to it, one red-green cycle.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` names this change's uncovered scenarios; they
  are exactly the new titles boxed in §§ 2–5. Any other uncovered title is a stop.
- [x] 1.2 Carried tests this delta edits, each only as its scenario now says: *a look-back counts the
  week a commitment is kept from against the whole quota* and *a week two quota eras share says its
  kept days out of the newer era's quota* are renamed to §§ 4.9 and 4.10's titles; §§ 4.11–4.13
  change a fraction; § 2.11 changes its stop day from 30 to 31 August. Tick when all six assert
  their new text.
- [x] 1.3 Sweep every carried test holding a weekly quota kept from a day that is not a Monday, a
  quota era chain, a stop, or two alike eras with days between them. Any red beyond § 1.2's six is a
  stop and a report before G7, never a quiet fixture edit.

## 2. `Roster` and `RosterStore` — take up again from a day, stop, mend

- [x] 2.1 a commitment taken up again days after it was stopped begins a new era on the day of the resume — catches the mend joining alike eras over the gap
- [x] 2.2 a commitment taken up again from the day after it was stopped is one era, as though it had never been stopped — catches a zero-day gap left as two eras
- [x] 2.3 an interval commitment taken up again begins its count on the day of the resume — catches the old start date carried
- [x] 2.4 a commitment whose only era holds no day, taken up again, is kept from the day of the resume — catches the kept-from day moved before a future start
- [x] 2.5 a commitment taken up again from a day keeps its place and its category
- [x] 2.6 taking up again from a day a commitment a roster keeps, does not hold or has deleted is refused
- [x] 2.7 taking up again from a day is refused where a commitment the roster keeps already has its name
- [x] 2.8 stopping a commitment as of a day before its newest era began stops the era behind it — catches `retire` not mending
- [x] 2.9 a stopped newest era holding no day is read back without it, the era behind it stopped — catches the later of the two days kept until carried
- [x] 2.10 alike eras with days between them are read back as two
- [x] 2.11 the newest era of a commitment stopped on the day it began is read back as it is — the carried test, its stop now on 31 August

## 3. `CommitmentsScreen` — stop and take up again

- [x] 3.1 a commitment stopped through a commitments screen on a day holding a record of it is kept until that day — catches a total short of its target not counted
- [x] 3.2 a record taken back on the day its commitment was stopped leaves the row and the day kept until as they were — catches the day kept until re-derived
- [x] 3.3 a commitment stopped through a commitments screen on the day its newest era began is stopped at the era before it
- [x] 3.4 a commitment stopped through a commitments screen on the day its newest era began keeps that era where the day holds a record of it
- [x] 3.5 a commitment taken up again through a commitments screen days after its stop begins a new era on the day the screen was handed — catches the screen still calling `add`
- [x] 3.6 a commitment stopped and taken up again on one day through a commitments screen is one era, as though it had never been stopped
- [x] 3.7 an interval commitment taken up again through a commitments screen begins its count on the day the screen was handed
- [x] 3.8 a commitment defined and stopped on one day and taken up again on a later day is kept from that later day

## 4. `LookBack` — the gap and the part week

- [x] 4.1 a tick commitment's look-back says a month in a gap as nothing out of nothing and counts no tick a gap day holds — catches a month left out
- [x] 4.2 a quota commitment's look-back says a week in a gap as nothing out of nothing
- [x] 4.3 a gap between a weekly quota era and one that is not is said in the unit of the era before it
- [x] 4.4 a number commitment's graph says the days of a gap and no number a gap day holds
- [x] 4.5 a total commitment's target rule runs through a gap at the target of the era before it
- [x] 4.6 a note commitment's look-back says no note a gap day holds
- [x] 4.7 a part week owes its quota times the days held over seven, rounded to the nearest whole number — catches floor and ceiling
- [x] 4.8 a part week that owes nothing is still said, and a day kept in it counts
- [x] 4.9 a look-back counts the week a commitment is kept from against its part of the quota
- [x] 4.10 a week two quota eras share says its kept days out of both eras' parts of their quotas — catches rounding each era's part apart
- [x] 4.11 a stopped quota commitment's look-back counts its last week through the day it was kept until
- [x] 4.12 a look-back says a weekday era's months and a quota era's weeks, each in its own unit
- [x] 4.13 a mixed chain's whole sums its months' due days and its weeks' quotas alike
- [x] 4.14 a week a gap cuts owes the days its eras hold, days to come included, and counts a day kept before the stop — catches days held counted only through today

## 5. `DayView`, `DayScreen` and `Schedule`

- [ ] 5.1 a weekly quota said given a count and what its week owes says that number in place of its own
- [ ] 5.2 a weekly-quota row in a part week says what its week owes
- [ ] 5.3 a weekly-quota row counts a day kept before a stop in the week it was taken up again — catches `History.standing` still read
- [ ] 5.4 two weekly-quota rows alike but for what their week owes are different rows
- [ ] 5.5 a day screen draws no row for a commitment on a day of a gap

## 6. Tidy

- [ ] 6.1 The doc comments on `Roster.retire`, `Roster.mended`, `CommitmentsScreen.keepAgain`,
  `CommitmentsScreen.confirmStopKeeping`, `LookBack.WeekTally` and `DayView.Row.standing` say what
  the code now does; `grep -rn "judged by the newer" src/DayByDayKit/Sources` finds none.

## 7. Gates and the archive handover

- [ ] 7.1 `pnpm run verify` green, and `swift test` from `src/DayByDayKit` reporting every test
  passing, the count read off the run.
- [ ] 7.2 `openspec validate stop-and-resume-as-eras --strict` exits 0 and `pnpm run checks` is clean
  but for what it is expected to warn.
- [ ] 7.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`.
- [ ] 7.4 The **implementer** ticks this box in its last commit before the archive, on the evidence
  that the change folder is committed and `tasks.md` has no other unticked box. The janitor then
  runs `/opsx:archive` and checks afterwards that `look-back/spec.md` carries the new week-line
  heading and not the removed one, that `schedule/spec.md` carries its new requirement, and that the
  eleven MODIFIED requirements are whole. **Any drift there is a stop and a report, never a
  hand-edit.**
