**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5):
a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a test that passes before the code it names is written, a carried test
that has to be edited or turns red but for § 1.2's list, a crash in a carried path, or a Kit
signature that has to differ from `design.md` § *The seam*.

Rule 3 governs §§ 3–10: take the next unticked box, write or edit the one test named for it — the
scenario title verbatim, which `pnpm run check:scenarios` checks — watch it fail, make it pass, then
the next.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly the ten scenarios the G7 respec (settled 16) added uncovered — 7.6–7.11, 7.13, 9.2, 9.3, 10.2 — and no other
- [ ] 1.2 The carried edits, the only sanctioned ones, each listed with its before and after in the PR body: the tests of "days away from a day already gone, ending before they begin, or over nothing are refused and keep nothing", "days away leave the list once their last day has passed and stay at the roster place" and "days away already begun offer no removal, and asking to remove them does nothing" are deleted; the four tests of § 3.3, § 8.1, § 8.3 and § 9.1 gain the clause their scenario gained; `CommitmentsView`'s `.firstDayHasPassed` case goes. The G7 respec adds: the unscenarioed test "a commitment stopped before days away that is unpicked from them owes no day of them" (`CommitmentsScreenChangeDaysAwayTests.swift`) is deleted, its last assertions reversed by 7.8; the test of 7.12 (`CommitmentsScreenDaysAwayTests.swift`) asserts "over Gym and Run" and gains the removal clause; 9.1's fixtures move to form 11. The tests of 7.1–7.5 stay as they are and green

## 2. The seam and the roster

- [x] 2.1 The members in `design.md` § *The seam* exist with those signatures, `firstDayHasPassed` is gone, and 4.1 is red before any does more than compile
- [x] 2.2 A change forms the next roster whole — spans and eras — and writes it once, the span keeping its identity and its place in the order said, as `design.md` § *A change is one roster formed whole* says
- [x] 2.3 `Roster.fillGap` fills from the day after a first day an era holds, so 8.5 passes without a second path
- [x] 2.4 `Roster.Span` remembers the day a stop kept each commitment until, set by `confirmStopKeeping` on every begun span keeping it, as `design.md` § *Days away remember a stop* says; the fix round's guard in `fillGap`'s `(behind, nil)` branch goes, every give-back reading the day remembered instead

## 3. `commitment` — saying days away

- [x] 3.1 days away said over days already gone take their gap there, however far back — catches the first-day guard left in
- [x] 3.2 days away ending before they begin, or over nothing, are refused and keep nothing
- [x] 3.3 a refusal of days away is told until the sheet is edited or closed, days away are kept, or the app is shown again — the carried test gains the change clause; catches `changeDaysAway` leaving `daysAwayRefusal` standing

## 4. `commitment` — changing days away

- [x] 4.1 days away renamed keep their days and commitments and stay the same days away — catches a change minting a new identity
- [x] 4.2 a change ending before it begins, or over nothing, is refused and keeps nothing
- [x] 4.3 a change is judged against other days away and never against the days away changed — catches the overlap test run over every span
- [x] 4.4 a commitment picked by a change is refused where it is kept from their first day or later or has a shift on one of their days, naming it
- [x] 4.5 a change asked of days away it does not list, or over a stopped commitment they are not over, does nothing
- [x] 4.6 a change a commitments screen cannot keep at its roster place is refused and the days away stay as they were

## 5. `commitment` — what a change does to each commitment

- [x] 5.1 a last day moved later keeps commitments away through it and takes them up again the day after, an every-N-days count beginning there — catches the old count start carried
- [x] 5.2 a last day moved earlier gives its days back, owed again, and takes commitments up again the day after
- [x] 5.3 a first day moved earlier takes days already gone, and moved later gives days back on the rhythm held before
- [x] 5.4 a commitment changed while away is taken up on its new rhythm wherever the day back moves, and keeps it once the days away are removed — catches a change built as remove-then-say
- [x] 5.5 a commitment ticked onto days away takes its gap, and one unticked is left as though it had never been picked — catches the unticked count restarted
- [x] 5.6 a commitment kept through a first day it holds a record on stays kept through it while the first day does not move — catches the gap re-cut from the day before

## 6. `commitment` — a recorded day

- [x] 6.1 days away said over a day holding any record of a commitment picked are refused, naming it and the day — catches a kind left out of the read, or the commitment named in the screen's category order rather than the roster's
- [x] 6.2 a commitment ticked onto days away over a day holding its record is refused, naming it and the day
- [x] 6.3 days away moved over a recorded day are refused, and days they give back or already hold are not judged — catches the whole span judged again
- [x] 6.4 a first day moved onto the day handed keeps through it a commitment holding a record there
- [x] 6.5 a commitments screen that cannot read its record refuses no days away for a record

## 7. `commitment` — a stopped commitment

- [x] 7.1 a stopped commitment in days away already past stays picked through a change, and unticked has their days back up to its stop
- [x] 7.2 days away moved past the last day a stopped commitment was kept keep it until the day before them
- [x] 7.3 days away moved wholly past the last day a stopped commitment was kept leave it out, and are refused where it was all they were over
- [x] 7.4 a stopped commitment kept until the day before days away stays picked through a later change of them, owing no day after its stop — catches a stop moved by 7.2 read as wholly past on the next change
- [x] 7.5 days away over nothing but a commitment stopped the day after them are renamed, and moved earlier, still over it — catches a rename refused as over no commitment
- [x] 7.6 days away over a commitment stopped the day after them, removed, give it back every day of them — catches the fix round's guard left in
- [ ] 7.7 days away moved past a stop and then removed give the stopped commitment back its days up to its stop and none after — catches the guard taken out with nothing in its place
- [ ] 7.8 a stopped commitment unticked from days away moved past its stop has their days back up to its stop and none after
- [ ] 7.9 days away moved past a stop and then wholly past it give the stopped commitment back its days up to its stop — catches "wholly past" read off the eras
- [ ] 7.10 days away moved past a stop and back again give the stopped commitment back its days up to its stop
- [ ] 7.11 a stopped commitment taken up again after days away moved past its stop owes, once they are removed, its days up to its stop and none before it was taken up again — catches the day dropped at a take-up-again
- [x] 7.12 a commitment stopped while its days away are under way is kept until the day before them — the carried test of § 1.2; catches `leaveDaysAway` still run on begun days away
- [ ] 7.13 a commitment taken up again inside days away over it is taken up on the day after their last day, and stays remembered by them

## 8. `commitment` — listing and removing

- [x] 8.1 a commitments screen lists days away by name or Away, with their days in words and their commitments, earliest first — the carried test gains "none as past"
- [x] 8.2 days away move to the past list once their last day has passed, latest first, and stay at the roster place — catches the past list in the upcoming order
- [x] 8.3 a commitments screen that cannot read its roster lists no days away — the carried test gains "none as past"
- [x] 8.4 days away under way or past are offered for removal, and removed leave their days owed again and open to a record
- [x] 8.5 days away begun on a first day a commitment was kept through are removed whole — catches `fillGap`'s early return

## 9. `commitment` — the roster store

- [ ] 9.1 a roster store holding days away no roster could hold is refused — the carried test gains the place of two days away with one identity, and its fixtures are written in form 11, each days away remembering nothing
- [ ] 9.2 a roster kept before days away remembered a stop is read as remembering the later of their last day and the last day kept
- [ ] 9.3 a roster store whose days away remember what no roster could is refused

## 10. `restore`

- [x] 10.1 days away changed on a commitments screen write a copy at the copy place — catches `copyPlace?.keptAChange()` left out of the change
- [ ] 10.2 a copy holding days away that remember a stop, restored, gives the stopped commitment back no day after it

## 11. The shell (ADR-1019: no rule the Kit does not state)

- [x] 11.1 `CommitmentsView` draws the past card, the Edit swipe, the change sheet, its Stopped section, its discard dialog and the record refusal under its row exactly as `design.md` § *The shell* says, in the words there, the sheet calling `changeDaysAway` alone to change
- [x] 11.2 `git diff --stat origin/main... -- src/DayByDay/` lists `CommitmentsView.swift` alone; the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 12. The records

- [ ] 12.1 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2); `CONTEXT.md` and ADR-1069 are as this folder's PR left them, and not edited since G4
- [x] 12.2 The known gap "A roster holding two days away with one identity is read without complaint" is gone from `docs/open-questions.md`, removed on this branch by the conductor, which owns that file; the `implementer` ticks this on seeing it gone and never edits the file itself

## 13. The gates and the archive handover

- [ ] 13.1 `openspec validate change-days-away --strict` exits 0, and `pnpm run checks` is clean but for any `check:budgets` warning the carried requirements already drew
- [ ] 13.2 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing, its count and one on `origin/main` both read off runs and given in the PR body
- [ ] 13.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 13.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked, W.7 included, and the walk comment's URL is in W.8. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `commitment` and `restore` move, gaining this delta's 38 new scenarios and losing the three retired in § 1.2, and no other spec file does. **Any other drift is a stop and a report, never a hand-edit** — the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

A fresh install, walked on the simulator on any day from Monday 14 September 2026 on, light only,
nothing recorded. "Gym", "Run" and "Creatine" are not defined through the sheet: the fresh install
takes on the day-one roster (`ContentView.swift`, `dayOneCommitments`), which holds all three kept
from Friday 4 September 2026, so every day the walk visits, a week back included, is on or after it;
defining them again would be refused as names already in use. Before W.1: "Mallorca" said from
tomorrow through six days on over "Gym" and "Run", and "Sick" said over the three days ending a week
ago over "Creatine" — both through the sheet, since the first day may now be any day.

- [x] W.1 The commitments screen scrolled to Days away — "Mallorca" over "Gym, Run" and "New days away" in the first card, "Sick" alone in a second card below it with no header.
- [x] W.2 "Mallorca" swiped from the leading edge, the pencil tapped — the sheet titled "Change Mallorca" with "Save", the name and both days filled, "Gym" and "Run" with filled circles.
- [x] W.3 The last day moved one day earlier and "Save" tapped — the list's "Mallorca" ending on its new last day.
- [x] W.4 The day screen paged forward to Mallorca's old last day — no "Mallorca" line and no dot under that day, and the row of "Gym" or "Run" due that day, where either is, back.
- [x] W.5 "Creatine" ticked on the day screen moved back to yesterday; "Mallorca" opened by Edit, its first day set to yesterday, "Creatine" picked, "Save" tapped — the sheet still open, the red refusal under the "Creatine" row naming it and yesterday.
- [x] W.6 The sheet cancelled and "Discard" chosen, then the day screen moved back to the middle day of "Sick" — the "Sick" line above the rows, no "Creatine" row.
- [x] W.7 "Sick" swiped, the trash and "Remove" in the alert tapped, the day screen moved back to that same day — no line, and the "Creatine" row back, not ticked.
- [ ] W.8 **The handover** — W.1–W.7, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL.
