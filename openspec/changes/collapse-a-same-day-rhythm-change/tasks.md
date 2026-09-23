A command that fails or does something unexplained is a stop and a report, not a thing to work
around (`AGENTS.md` rule 5). Rule 3 throughout: one scenario, one acceptance test named identically
to it, one red-green cycle.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` names this change's uncovered scenarios; they
  are exactly the titles boxed in §§ 2–4. Any other uncovered title is a stop.
- [x] 1.2 Carried tests this delta edits, each only as its scenario now says, are §§ 2.2, 3.7 and
  4.9. The test of *an era put on as of a day before the day the era it gives way to is kept from leaves it
  holding no day* becomes § 2.1's and the one of *a roster kept before a commitment had an identity
  holding one era twice is refused* becomes § 3.5's, each renamed and rewritten with it. *A roster
  store holding a commitment again after holding it stopped or removed is refused* changes wording
  only; its form-4 test is untouched.
- [x] 1.3 *A look-back chains every era of the commitment it was asked about* puts three eras alike in
  schedule and kind, which the roster now joins into one: give them three different weekday sets, and
  its assertions stand unchanged. Tick when it passes with them.
- [x] 1.4 Sweep every carried test that puts an era on, restarts, or writes a roster by hand for one
  that now holds an era holding no day, two eras holding one day, or two alike side by side. Any other
  than those in 1.2 and 1.3 is a stop and a report before G7, never a quiet fixture edit.

## 2. `Roster.put` — no era holding no day

- [x] 2.1 an era put on as of a day before the day the era it gives way to is kept from drops that era — catches ending it and keeping it
- [x] 2.2 an era put on as of the first supported date and one as of the last are both accepted — catches an overlap left where the date is after the new era's day kept from
- [x] 2.3 an era put on as of a day before a later era began replaces every era begun after that day — catches ending only the newest
- [x] 2.4 an era put on alike the one it would give way to leaves that one the newest, as it was — catches joining only across a dropped era

## 3. The reader — mended on every read

- [x] 3.1 a stored roster holding eras that hold no day is read back without them — catches the duplicate guard still running before the mend
- [x] 3.2 alike eras standing side by side are read back as one — catches joining under the newer's day kept from
- [x] 3.3 eras holding the same days are read back with the newer keeping them — catches an older era carrying no day kept until left open
- [x] 3.4 the newest era of a commitment stopped on the day it began is read back as it is — catches the mend deciding #306
- [x] 3.5 a roster kept before a commitment had an identity holding an era that holds no day is read back without it — catches `folded()` left unmended
- [x] 3.6 a copy holding eras that hold no day is restored with them mended — catches `CopyDocument` reading around the mend
- [x] 3.7 a roster store holding what could not be a roster is refused — the carried test with its one-era-twice fixture gone, still green

## 4. `CommitmentsScreen` — change and restart

- [x] 4.1 a rhythm changed and changed back on one day leaves the commitment as it was that morning — catches a new era alike the old one left standing
- [x] 4.2 a rhythm changed three times on one day leaves one era for that day and a roster that can be read — catches the lock-out itself
- [x] 4.3 a commitment defined and changed on one day keeps one era, kept from that day
- [x] 4.4 an interval rhythm changed away and back on one day keeps the start date it had — catches the change back restarting the count
- [x] 4.5 a change back on one day is refused where a record made that day would be left not due — catches the refusal skipped for a same-day change
- [x] 4.6 a restart reaches behind a change made days ago and replaces it — catches the already-due check asked of the era holding the day
- [x] 4.7 a commitment kept from a day after today, changed before that day, keeps the day it is kept from — catches the new era kept from today
- [x] 4.8 a restart reaching behind a change is refused where a record the change's era holds would be left not due
- [x] 4.9 a rhythm changed on the first date the calendar supports puts the new era on as of that day itself — the carried `aRhythmChangedOnTheFirstDateTheCalendarSupportsPutsTheNewEraOnAsOfThatDayItself`, rewritten to one era: the era it gives way to began that day

## 5. Tidy

- [x] 5.1 `restart`'s special case for a restart on the day kept from goes, the put now covering it;
  the comment at `CommitmentsScreen.swift` that says `formRoster` guards one identity kept from one
  day twice, and the doc comments on `Roster.put`, `formRoster()` and `folded()` that describe the
  old guards or an era left holding no day, say what the code now does. `grep -rn "holding no day at
  all\|kept from one day twice" src/DayByDayKit/Sources` finds none of the old wording.

## 6. Gates and the archive handover

- [x] 6.1 `pnpm run verify` green, and `swift test` from `src/DayByDayKit` reporting every test
  passing, the count read off the run.
- [x] 6.2 `openspec validate collapse-a-same-day-rhythm-change --strict` exits 0 and `pnpm run checks`
  is clean but for what it is expected to warn.
- [ ] 6.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`.
- [ ] 6.4 The **implementer** ticks this box in its last commit before the archive, on the evidence
  that the change folder is committed and `tasks.md` has no other unticked box. The janitor then
  runs `/opsx:archive` and checks afterwards that `commitment/spec.md` carries both new-heading
  requirements and both ADDED ones, neither REMOVED heading, and the two MODIFIED ones whole. **Any
  drift there is a stop and a report, never a hand-edit.**
