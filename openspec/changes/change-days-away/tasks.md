**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5):
a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a test that passes before the code it names is written, a carried test
that has to be edited or turns red but for § 1.2's list, a crash in a carried path, or a Kit
signature that has to differ from `design.md` § *The seam*.

Rule 3 governs §§ 3–10: take the next unticked box, write or edit the one test named for it — the
scenario title verbatim, which `pnpm run check:scenarios` checks — watch it fail, make it pass, then
the next.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly the ten scenarios the settled-18 redesign added uncovered — 7.19–7.27 and 9.4 — and no other
- [x] 1.2 The carried edits, the only sanctioned ones, each listed with its before and after in the PR body: the tests of "days away from a day already gone, ending before they begin, or over nothing are refused and keep nothing", "days away leave the list once their last day has passed and stay at the roster place" and "days away already begun offer no removal, and asking to remove them does nothing" are deleted; the four tests of § 3.3, § 8.1, § 8.3 and § 9.1 gain the clause their scenario gained; `CommitmentsView`'s `.firstDayHasPassed` case goes. The G7 respec adds: the unscenarioed test "a commitment stopped before days away that is unpicked from them owes no day of them" (`CommitmentsScreenChangeDaysAwayTests.swift`) is deleted, its last assertions reversed by 7.8; the test of 7.12 (`CommitmentsScreenDaysAwayTests.swift`) asserts "over Gym and Run" and gains the removal clause; 9.1's fixtures move to form 11. The tests of 7.1–7.5 stay as they are and green. The form-11 bump raises, by one, the roster form each of nine carried tests writes as "a later form" or reads as "the form written now", and nothing else in them: in `RosterStoreTests.swift`, `aRosterStoreWrittenInALaterFormThanThisAppKnowsIsRefused` and `aRosterStoreDeclaringALaterFormWhoseBodyThisAppCannotReadIsRefusedAsALaterForm` (11→12, written and expected), and `aRosterWrittenWithUsualAmountsIsReadBackWithThemInForm7EachAmountExactly` (10→11); in `DayScreenTests.swift`, `aDayScreenThatIsNotKeepingARosterMovesAndGoesOnSayingWhy`, `goingBackToTodayDoesNotReadTheRosterAgain`, `aRosterWrittenInALaterFormThanThisAppKnowsMakesADayScreenThatSaysTheRosterIsFromALaterVersion`, `aDayScreenThatWasKeepingARosterStopsWhenItIsShownAgainAndTheRosterCannotBeRead` and `aDayScreenShownAgainCarriesOverNoReasonItGaveForNotKeepingItsRecordOrItsRoster` (roster 11→12, the record's `"version": 10` untouched); in `CommitmentsScreenTests.swift`, `aRosterWrittenInALaterFormThanThisAppKnowsMakesACommitmentsScreenThatSaysTheRosterIsFromALaterVersion` (11→12). The unscenarioed test "a form 10 days away over a stopped commitment owe it no day after the later of their last day and its last day kept" (`RosterDaysAwayTests.swift`) is deleted: 9.2 now carries its assertions. The settled-18 redesign adds: 9.3's test is rewritten to its nine places, and the form-11 fixture helper in `RosterDaysAwayTests.swift` writes each remembered stop with its take-up, its default of remembering nothing unchanged; the tests of 7.1–7.18, 9.1, 9.2 and 10.2 stay as they are and green, and no other carried test is edited

## 2. The seam and the roster

- [x] 2.1 The members in `design.md` § *The seam* exist with those signatures, `firstDayHasPassed` is gone, and 4.1 is red before any does more than compile
- [x] 2.2 A change forms the next roster whole — spans and eras — and writes it once, the span keeping its identity and its place in the order said, as `design.md` § *A change is one roster formed whole* says
- [x] 2.3 `Roster.fillGap` fills from the day after a first day an era holds, so 8.5 passes without a second path
- [x] 2.4 `Roster.Span` remembers stops as `design.md` § *What days away remember* says, a span built without any remembering none, written only where § *Every operation* says, and `RosterStore` refuses I1–I4 and nothing else it remembers: the last design's one remembered day, its first-day bound and its stopped-commitment check go. Reopened by G7's sixth review, finding 1: a change adds only stops newly hidden (§ *Every operation*), each a stop *of own life* at the old day back (`design.md` line 75) and never one of the eras, so a rename, which hides nothing, adds none; re-ticked once 2.6–2.8 are
- [x] 2.5 One function forms a commitment's own life beside days away, as `design.md` § *Own life* says, and removal, an untick, a take-out and every change set the eras from it alone: `giveBackAfter` and every `fillGap` guard reading a remembered day go, and `commitmentsStayingOver` reads the last stop's day. Reopened by the sixth review: a removal gives back the span's days whatever lies either side of them — other days away, a stop's gap, no era (finding 2) — and own life cuts a remembered stop's gap on the span's days alone, old and new (`design.md` line 73, finding 3); re-ticked once 2.8 is
- [x] 2.6 Every roster write checks I1–I4 before the place is touched, as `design.md` line 57 says ("Every write keeps four invariants"): `RosterStore`'s one write refuses a roster breaching any, the act refused as a roster that could not be written. One unscenarioed test, "a roster breaching what days away may remember is refused before it is written", writes four rosters, each breaching one of I1–I4, and finds each refused and the place byte-for-byte as it was — red on 3465f69, where the write lands and only the next read refuses (finding 1)
- [x] 2.7 `Roster.stopDaysAway` (finding 6). Dropping every remembered stop later than the new one stays, and its comment cites why: a stop confirmed is added "not taken up" (delta § *Days away remember every stop…*), a store refuses stops out of order and a stop not taken up before another (§ *A roster store keeps what days away remember…*; I2, I3 at `design.md` lines 58–59), and none is refused (§ *Every roster a commitments screen keeps…*) — so no later stop can stay, as no later era does (`design.md` line 6). The branch dropping a last stop not taken up goes: a commitment is stopped only while kept, and a take-up again takes up or forgets each days away's last stop not taken up (§ *Days away remember every stop…*), so it is unreachable; with it gone, 2.6 refuses that state and 2.8(a) fails on it, which is a stop and a report
- [x] 2.8 One unscenarioed property test at the screen seam, `CommitmentsScreen` and `RosterStore` alone, replaces `DaysAwayRosterReadBackTests.swift`, which is deleted. Gym and Run every weekday, Nails every 3 days; acts say, change (days, picks, or the name alone), remove, stop, take up again and delete, every change and removal picking from all of `daysAway + pastDaysAway`, never only the first; days away said to begin the day after others end; stops and take-ups while two days away are over one commitment; screens opened as of days moving forward, and as of days in any order. After every act, on copies of the place, each commitment's due days compared over a window holding every act's days: **(a)** a roster store opened there reads what was written, and no act is refused as a roster that could not be written (§ *Every roster a commitments screen keeps is one a roster store reads*); **(b)** renaming each listed days away, same days and picks, changes no day of any commitment (§ *A change of days away gives back…*, "leaving every day neither given back nor newly taken as it was"; `design.md` line 73); **(c)** a change followed by its move back restores every commitment's days (§ *No removal, untick or change…*, "a change moved back SHALL give back what it took"; `design.md` lines 79–80); **(d)** the same days reached in one change or two leave the same days (same requirement, "in one change or several"; `design.md` line 79). A step refused for a reason the delta gives is skipped, and the PR body gives how many of (b)–(d) ran unskipped. Fixed seed, 400 sequences of 12 acts in each clock mode, a failure naming its sequence and acts; red on 3465f69. The PR body shows each of the reviewer's probes N1, N1d, N1f, N1g, N2, N2b, N3, N4, N5, N6 and U, written as assertions and not committed, failing on 3465f69 and passing after the fix: N1, N1f and N1g leave every Gym day outside "Flu" as it was; N1d changes no day; N2 has Gym owe 23–30 October after the removal, Lisbon or not; N2b gives Gym the same days in one change or two, Lisbon or not; N3 leaves Gym as 7.12's and 7.13's removal clauses say, Lisbon or not; N4 and U read back after every act, nothing refused; N5 and N6 restore Nails's and Run's days on the move back. A test of §§ 3–10 turning red under the fix is a stop and a report

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
- [x] 7.7 days away moved past a stop and then removed give the stopped commitment back its days up to its stop and none after — catches the guard taken out with nothing in its place
- [x] 7.8 a stopped commitment unticked from days away moved past its stop has their days back up to its stop and none after
- [x] 7.9 days away moved past a stop and then wholly past it give the stopped commitment back its days up to its stop — catches "wholly past" read off the eras
- [x] 7.10 days away moved past a stop and back again give the stopped commitment back its days up to its stop
- [x] 7.11 a stopped commitment taken up again after days away moved past its stop owes, once they are removed, its days up to its stop and none before it was taken up again — catches the day dropped at a take-up-again
- [x] 7.12 a commitment stopped while its days away are under way is kept until the day before them — the carried test of § 1.2; catches `leaveDaysAway` still run on begun days away
- [x] 7.13 a commitment taken up again inside days away over it is taken up on the day after their last day, and stays remembered by them
- [x] 7.14 a commitment taken up again inside days away stays picked through a later change moving their first day past its stop — catches the change's take-out filter reading any day remembered as a stop, which drops a kept pick or refuses the only one as over no commitment
- [x] 7.15 a commitment taken up again after days away whose first day then moves past its stop and back owes, once they are removed, no day between its stop and its take-up — catches the day remembered dropped when the first day moves past it
- [x] 7.16 days away whose first day moved past the stop of a commitment taken up again inside them, removed, leave it owing no day between its stop and its take-up — catches the stop forgotten once their first day moves past it
- [x] 7.17 days away whose first day moved past the stop of a commitment taken up again inside them, moved back over it and removed, leave it owing no day between its stop and its take-up — catches the day remembered moved up to the day before the new first day
- [x] 7.18 days away moved to end earlier move the take-up of a commitment taken up again inside them to the day after their new last day — catches `giveBackAfter`'s cap at the day remembered
- [x] 7.19 days away said over the days of a stop and take-up already made give the commitment back, once removed, no day between them — catches a stop the saying's cut hides left unremembered
- [x] 7.20 days away moved to end before a stop made inside them, then removed, give the commitment back its days up to its stop and none after — catches the give-back reading their last day as the stop
- [x] 7.21 days away moved past a later stop of a commitment taken up again inside them, and back again, give it back the days between its take-up and that stop — catches one remembered stop per commitment
- [x] 7.22 a take-up after days away that a change then covers comes back to its own day when they move back — catches a covered take-up left at the day back
- [x] 7.23 days away renamed leave the take-up of a commitment taken up again inside them where it was — catches a rename re-forming the eras
- [x] 7.24 a commitment taken up again inside days away and then unticked from them owes its days up to its stop and from its take-up — catches an untick reading the take-up at the day back as none
- [x] 7.25 days away moved to end before the stop of a commitment taken up again inside them keep its take-up on the day back it was taken up for — catches the take-up following the day back to its stop, undoing it
- [x] 7.26 days away moved wholly before the stop of a commitment taken up again inside them keep its take-up on the day back it was taken up for, and moved back over it move it with their day back again — catches the take-up turned into a fixed day once it falls back. Reopened by the sixth review, which found the test did not: it gains, after the third change, "Mallorca" removed through the Friday screen, the removal confirmed, and a roster store then holding "Gym" due on Tuesday 13, Wednesday 14 and Wednesday 21 October 2026 and on none of Thursday 15 through Tuesday 20 (§ *A commitments screen takes a commitment up again…*: "a removal SHALL leave it where it is"); the PR body shows it red under that mutation, owing from Monday 19, and green on the code
- [x] 7.27 days away moved past the take-up of a commitment taken up again inside them leave it owing the same days whether moved in one change or two — catches the ends given back one at a time

## 8. `commitment` — listing and removing

- [x] 8.1 a commitments screen lists days away by name or Away, with their days in words and their commitments, earliest first — the carried test gains "none as past"
- [x] 8.2 days away move to the past list once their last day has passed, latest first, and stay at the roster place — catches the past list in the upcoming order
- [x] 8.3 a commitments screen that cannot read its roster lists no days away — the carried test gains "none as past"
- [x] 8.4 days away under way or past are offered for removal, and removed leave their days owed again and open to a record
- [x] 8.5 days away begun on a first day a commitment was kept through are removed whole — catches `fillGap`'s early return

## 9. `commitment` — the roster store

- [x] 9.1 a roster store holding days away no roster could hold is refused — the carried test gains the place of two days away with one identity, and its fixtures are written in form 11, each days away remembering nothing
- [x] 9.2 a roster kept before days away remembered a stop is read as remembering the later of their last day and the last day kept — the test gains the first place's change before its removal; catches the form-10 read left out, which the removal alone did not
- [x] 9.3 a roster store whose days away remember what no roster could is refused — catches a check of a remembered stop against the eras left in, which refuses the first control
- [x] 9.4 a commitment stopped, taken up again and stopped again around days away over it leaves a roster a roster store reads, and stays over them through a later change — catches finding 1's bound, a stop added twice on one day, or a rename reading the first stop. Reopened by the sixth review, whose probes N4 and U write a roster the store refuses; re-ticked once 2.8 is, its own test unchanged

## 10. `restore`

- [x] 10.1 days away changed on a commitments screen write a copy at the copy place — catches `copyPlace?.keptAChange()` left out of the change
- [x] 10.2 a copy holding days away that remember a stop, restored, gives the stopped commitment back no day after it

## 11. The shell (ADR-1019: no rule the Kit does not state)

- [x] 11.1 `CommitmentsView` draws the past card, the Edit swipe, the change sheet, its Stopped section, its discard dialog and the record refusal under its row exactly as `design.md` § *The shell* says, in the words there, the sheet calling `changeDaysAway` alone to change
- [x] 11.2 `git diff --stat origin/main... -- src/DayByDay/` lists `CommitmentsView.swift` alone; the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 12. The records

- [x] 12.1 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2); `CONTEXT.md` and ADR-1069 are as this folder's PR left them, and not edited since G4
- [x] 12.2 The known gap "A roster holding two days away with one identity is read without complaint" is gone from `docs/open-questions.md`, removed on this branch by the conductor, which owns that file; the `implementer` ticks this on seeing it gone and never edits the file itself

## 13. The gates and the archive handover

- [ ] 13.1 `openspec validate change-days-away --strict` exits 0, and `pnpm run checks` is clean but for any `check:budgets` warning the carried requirements already drew
- [ ] 13.2 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing, its count and one on `origin/main` both read off runs and given in the PR body
- [ ] 13.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 13.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked, W.7 included, and the walk comment's URL is in W.8. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `commitment` and `restore` move, gaining this delta's 53 new scenarios and losing the three retired in § 1.2, and no other spec file does. **Any other drift is a stop and a report, never a hand-edit** — the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

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
