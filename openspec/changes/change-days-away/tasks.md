**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5):
a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a test that passes before the code it names is written, a carried test
edited or turning red but for § 1.2's or § 1.5's list, a branch test edited but as § 1.3 or § 1.5
says, a crash in a carried path, or a Kit signature that has to differ from `design.md` § *The seam*.

This round is the ninth review's fix round on the rebuild: settled 24 takes the take-out away,
settled 25 adds a refusal, and every unticked box is its work. Rule 3 governs §§ 3–10, and 2.7 is
made through them, by the red tests of 7.3, 7.9, 7.31 and 7.32 and never before them; 2.2's
consolidation changes no outcome and turns no test red. Take the next unticked box, write or edit the
one test named for it — the scenario title verbatim, which `pnpm run check:scenarios` checks — watch
it fail, make it pass, then the next. A box marked *pins a survivor* names a rule the code already
keeps: its test passes on the code and is seen red under its § 2 mutation instead, which is its
evidence and not a stop. Every other new or rewritten test is seen red before its code, its red run
named in the PR body. A ticked box of §§ 3–10 is a scenario this round leaves as it was: its test
stays as it is and must end green.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` reports uncovered exactly the scenarios of 3.1–3.5, 5.4–5.7, 7.2, 7.12, 7.13, 7.18, 7.25, 7.26, 7.28–7.30, 9.2 and 10.2–10.6, and no other
- [x] 1.2 The carried edits — tests on `origin/main` — are the only sanctioned ones, each with its before and after in the PR body. Deleted: the tests of "days away from a day already gone, ending before they begin, or over nothing are refused and keep nothing", "days away leave the list once their last day has passed and stay at the roster place" and "days away already begun offer no removal, and asking to remove them does nothing". Gaining a clause: "a refusal of days away is told until the sheet is edited or closed, days away are kept, or the app is shown again" (the change clause); "a commitments screen lists days away by name or Away, with their days in words and their commitments, earliest first" and "a commitments screen that cannot read its roster lists no days away" ("none as past"); "a roster store holding days away no roster could hold is refused" (a seventh refused place, two days away with one identity; its fixtures declare form 11, before form 10, the shape unchanged). Renamed and reasserted: "a commitment stopped while its days away are under way is kept until the day before them" becomes 7.12 — before, "Mallorca" over "Run" alone and "Gym" not stopped on Monday 12 only; after, over both, "Gym" not stopped on Wednesday 14 and stopped on Thursday 15, due on none of 13–19, and the removal clause; "a rhythm changed while days away are under way holds from the day after them" becomes 5.5, gaining its removal clause; "days away from today keep a commitment that holds a record today until today, and the others until the day before" becomes 3.2 — before, once the tick is taken back, one row "Creatine" not kept on Monday 12; after, no row. Cut: in the test of "days away removed after a change of rhythm leave that change standing from the day it was made", the second half, a hand-cut roster given to `removeDaysAway` and expecting two eras, is deleted; the first half stays. Raised by one for form 11 and nothing else, in `RosterStoreTests.swift`: `aRosterStoreWrittenInALaterFormThanThisAppKnowsIsRefused` and `aRosterStoreDeclaringALaterFormWhoseBodyThisAppCannotReadIsRefusedAsALaterForm` (11→12), `aRosterWrittenWithUsualAmountsIsReadBackWithThemInForm7EachAmountExactly` (10→11); in `DayScreenTests.swift`, `aDayScreenThatIsNotKeepingARosterMovesAndGoesOnSayingWhy`, `goingBackToTodayDoesNotReadTheRosterAgain`, `aRosterWrittenInALaterFormThanThisAppKnowsMakesADayScreenThatSaysTheRosterIsFromALaterVersion`, `aDayScreenThatWasKeepingARosterStopsWhenItIsShownAgainAndTheRosterCannotBeRead` and `aDayScreenShownAgainCarriesOverNoReasonItGaveForNotKeepingItsRecordOrItsRoster` (roster 11→12, the record's `"version": 10` untouched); in `CommitmentsScreenTests.swift`, `aRosterWrittenInALaterFormThanThisAppKnowsMakesACommitmentsScreenThatSaysTheRosterIsFromALaterVersion` (11→12). `CommitmentsView`'s `.firstDayHasPassed` case goes. Every other carried test stays unedited and green, the shift, day-screen, restore and look-back tests included
- [x] 1.3 The branch's own tests, which are not on `origin/main`: one whose scenario keeps its title and its words stays as it is; one whose title changed is renamed to it; one whose words changed is rewritten to them and seen red before the code; the tests of the three retired scenarios — "a roster kept before days away remembered a stop is read as remembering the later of their last day and the last day kept", "a roster store whose days away remember what no roster could is refused", "a copy holding days away that remember a stop, restored, gives the stopped commitment back no day after it" — and `RosterStoreRemembersWriteTests.swift` are deleted; `RosterDaysAwayTests.swift`'s fixture helper writes no `remembers`; `DaysAwayRosterPropertyTests.swift` is replaced by 2.5's test. The PR body lists each with the box it serves
- [x] 1.4 From the repo root, `pnpm run check:scenarios` reports uncovered exactly the scenarios of 3.8, 6.6–6.9, 7.3, 7.9, 7.31, 7.32 and 10.7–10.10, and no other
- [x] 1.5 This round's test edits, each in the PR body with its before and after: 6.1's test picks "Run" then "Gym"; 7.3's and 7.9's tests are renamed to their titles and rewritten to their words; every test asserting a take-out — a stopped pick dropped by a move, or a change refused as over no commitment for one — is deleted or rewritten to settled 24, each named; `DaysAwayRosterPropertyTests.swift` changes as 2.5 says. Every other test, carried or the branch's, stays unedited and green

## 2. The rebuild

- [x] 2.1 The memory and the cut go first, as `design.md` § *Order of work* steps 1 and 2 name them, and nothing reads a span's stops or cuts an era for days away; saying, changing, removing and unticking edit spans alone, and a stop, a take-up and a change of a commitment are `main`'s own. The tests then red are listed in the PR body by box
- [x] 2.2 The read exists once — hidden, and the every-N count begun again, as `design.md` § *The model* says — behind `Roster.groups(on:recordedIn:)`, and every reader § *Context* names reads through it; none reads `entries` for what is due, held or free without it. `WeekQuota.Link.holds` and `WeekQuota.commitment(on:)` read through it rather than repeat it, and no reader takes days away by a default that reads none: `LookBack.form`'s `daysAway: DaysAwayMask = .none` goes
- [x] 2.3 The members in `design.md` § *The seam* exist with those signatures, `recordedDayLeftNotDue` among them, and `firstDayHasPassed` is gone
- [x] 2.4 `RosterDocument` writes form 11 in form 10's shape and reads form 10 as written, as `design.md` § *Migration* says, refusing two days away with one identity
- [x] 2.5 One unscenarioed property test at the screen seam, `CommitmentsScreen` and `RosterStore` alone, with no exclusion of any kind — no act, check, sequence or refusal skipped, filtered or excused, a take-out or a rename refusal included: Gym and Run every weekday, Nails every 3 days; random sequences of say, change (days, picks, or the name alone), remove, untick, stop, take up again, rhythm change and delete, the name typed back before `confirmDeleting()`, every change and removal picking from all of `daysAway + pastDaysAway`; screens opened as of days moving forward, and as of days in any order. After every act, on copies of the place, each commitment's due days, stopped ones included, compared over a window holding every act's days: **(a)** a roster store reads back what was written, and no act is refused as a roster that could not be written; **(b)** each listed days away renamed, its days and picks as they are, is kept and changes no day — a rename refused for any reason fails; **(c)** a change and its move back restore every day; **(d)** the same days reached in one change, or through a free intermediate change whose first and last days are both drawn at random over the window, give the same days — an intermediate refused is drawn again, at most 20 times; **(e)** a removal gives back exactly the days it hid — each day of it in no other days away over that commitment and due on its eras, worked out from the eras and never from the read under test — and changes no other day. 400 sequences of 12 acts in each clock mode, passing on the committed seed and on one set through an environment variable; a failure on any seed names its sequence and acts and is a stop and a report. Each mode asserts at least 50 take-ups and 50 rhythm changes inside days away, 50 changes moving days away wholly past a stopped pick's stop, 150 kept changes and 150 confirmed removals of days away other than the first listed, each of (b)–(e) unskipped 400 times, and (d) run 400 times with both ends of its intermediate moved; the PR body gives the counts for the committed seed and five others
- [x] 2.6 Mutations of the read, each applied to a copy built from `git archive HEAD` on the final code, never the worktree and never committed, and each killed by a test of §§ 3–10 or by 2.5: a recorded day hidden; the every-N count begun from the earliest day after days away; begun from a day the era does not hold; a quota share for a hidden day; a hidden day free for a shift; a hidden day counted by a look-back. The PR body gives one line each: the test that kills it, red under the mutation and green on the code. The ninth review's M13, M23 and M24 are equivalent and are not run
- [x] 2.7 The take-out goes (settled 24): `Roster.commitmentsStayingOver` and the `.overNoCommitment` of `changeDaysAway` that follows it are deleted, and a change keeps every stopped commitment picked wherever it moves them; the ninth review's finding 4, a rename refused or dropping a pick, goes with it, and 2.5's (b) is the evidence
- [x] 2.8 Survivor M01–M04, `History.holdsRecord` ignoring declines, numbers, notes or additions — each applied as 2.6 says and killed by 3.8's test
- [x] 2.9 Survivor M10, the record refusal walking picks in the order given rather than the roster's — applied as 2.6 says and killed by 6.1's test
- [x] 2.10 Survivor M11, the look-back ignoring the every-N count begun again — applied as 2.6 says and killed by 10.8's test
- [x] 2.11 Survivors M12 and M15, a weekly quota's days left and standing hiding a recorded day under days away — each applied as 2.6 says and killed by 10.7's test
- [x] 2.12 Survivor M17, a day a shift put a due day on shifted again onto a hidden day — applied as 2.6 says and killed by 10.10's test
- [x] 2.13 Survivor M19, a count begun again bounded back by its era's day kept from rather than the day after days away — the delta now settles that bound (`design.md` § *Shift bounds around days away*); applied as 2.6 says and killed by 10.9's test
- [x] 2.14 `SaveInProgress.carryBackOrphanedRecords` judges a candidate's due days through the read (finding 5), with one unscenarioed regression test at `CommitmentsScreen` — "Nails" every 3 days from Thursday 1 October 2026, days away on Thursday 8 October, an orphan tick on Monday 12 October carried back to it — red before the fix

## 3. `commitment` — days away hide, and saying them

- [x] 3.1 days away said, changed and removed leave the eras of the commitments they are over as they were — catches a cut left in any of the three
- [x] 3.2 days away from today hide no day holding a record of a commitment picked, and hide it once the record is taken back — the carried test of § 1.2; catches the record stored as a first day kept through
- [x] 3.3 a day holding a record under days away keeps its row through every later change of them — catches the record spared only on the first day
- [x] 3.4 an every-N-days count begins again on the day after each days away over it, and runs on unbroken once those days away are removed — catches the count begun again after the first days away alone
- [x] 3.5 days away said over days already gone hide those days, however far back — catches the first-day guard left in
- [x] 3.6 days away ending before they begin, or over nothing, are refused and keep nothing
- [x] 3.7 a refusal of days away is told until the sheet is edited or closed, days away are kept, or the app is shown again — the carried test gains the change clause
- [x] 3.8 a day under days away holding a number, a note, an addition or a decline keeps its row — pins a survivor, 2.8

## 4. `commitment` — changing days away

- [x] 4.1 days away renamed keep their days and commitments and stay the same days away — catches a change minting a new identity
- [x] 4.2 a change ending before it begins, or over nothing, is refused and keeps nothing
- [x] 4.3 a change is judged against other days away and never against the days away changed — catches the overlap test run over every span
- [x] 4.4 a commitment picked by a change is refused where it is kept from their first day or later or has a shift on one of their days, naming it
- [x] 4.5 a change asked of days away it does not list, or over a stopped commitment they are not over, does nothing
- [x] 4.6 a change a commitments screen cannot keep at its roster place is refused and the days away stay as they were

## 5. `commitment` — what a change does

- [x] 5.1 a last day moved later keeps commitments away through it and takes them up again the day after, an every-N-days count beginning there
- [x] 5.2 a last day moved earlier gives its days back, owed again, and takes commitments up again the day after
- [x] 5.3 a first day moved earlier takes days already gone, and moved later gives days back on the rhythm held before
- [x] 5.4 a commitment ticked onto days away has their days hidden, and one unticked is left as though it had never been picked — catches the unticked count begun again
- [x] 5.5 a rhythm changed while days away are under way holds from the day it was changed, hidden until the day after them — the carried test of § 1.2; catches the era put on from the day after them
- [x] 5.6 a commitment changed while away keeps its new rhythm from the day it was changed wherever the days away move, and once they are removed — catches the rhythm moved with the day back
- [x] 5.7 a change of rhythm made before days away that a change then covers holds from its own day again when they move back — catches an era a move swallows

## 6. `commitment` — a recorded day

- [x] 6.1 days away said over a day holding any record of a commitment picked are refused, naming it and the day — its picks now "Run" then "Gym"; pins a survivor, 2.9
- [x] 6.2 a commitment ticked onto days away over a day holding its record is refused, naming it and the day
- [x] 6.3 days away moved over a recorded day are refused, and days they give back or already hold are not judged — catches a recorded day handed judged again once the first day moves off it
- [x] 6.4 a first day moved onto the day handed keeps through it a commitment holding a record there
- [x] 6.5 a commitments screen that cannot read its record refuses no days away for a record
- [x] 6.6 days away said over past days are refused where the every-N-days count begun again after them leaves a recorded day not due, naming it and the day — the review's repro A
- [x] 6.7 days away whose removal would leave a recorded day not due on the count running on through them are refused and stay listed, naming it and the day — the review's repro B
- [x] 6.8 days away changed, or a commitment unticked from them, are refused where the every-N-days count begun again on another day leaves a recorded day not due
- [x] 6.9 days away that would put one recorded day under them and leave another not due are refused naming the day put under them — catches settled 25 judged before settled 6

## 7. `commitment` — stops and take-ups under days away

- [x] 7.1 a stopped commitment in days away already past stays picked through a change, and unticked has their days back up to its stop
- [x] 7.2 days away moved past the last day a stopped commitment was kept leave it stopped on the day it was — catches the stop moved to the day before them
- [x] 7.3 days away moved wholly past the last day a stopped commitment was kept keep it picked, and are not refused where it was all they were over — settled 24, renamed and rewritten
- [x] 7.4 a stopped commitment kept until the day before days away stays picked through a later change of them, owing no day after its stop — catches a pick dropped by a later change
- [x] 7.5 days away over nothing but a commitment stopped the day after them are renamed, and moved earlier, still over it — catches the stop moved by a move earlier
- [x] 7.6 days away over a commitment stopped the day after them, removed, give it back every day of them
- [x] 7.7 days away moved past a stop and then removed give the stopped commitment back its days up to its stop and none after
- [x] 7.8 a stopped commitment unticked from days away moved past its stop has their days back up to its stop and none after
- [x] 7.9 days away moved past a stop and then wholly past it keep the stopped commitment picked and give it back its days up to its stop — settled 24, renamed and rewritten
- [x] 7.10 days away moved past a stop and back again give the stopped commitment back its days up to its stop
- [x] 7.11 a stopped commitment taken up again after days away moved past its stop owes, once they are removed, its days up to its stop and none before it was taken up again — now read as due days
- [x] 7.12 a commitment stopped while its days away are under way stays in them, stopped on the day it was made — the carried test of § 1.2; catches `leaveDaysAway` run on begun days away
- [x] 7.13 a commitment taken up again inside days away over it is taken up on the day it is handed, its days hidden until the day after them — catches the take-up moved to the day back
- [x] 7.14 a commitment taken up again inside days away stays picked through a later change moving their first day past its stop — catches a pick dropped by a move
- [x] 7.15 a commitment taken up again after days away whose first day then moves past its stop and back owes, once they are removed, no day between its stop and its take-up — now read as due days
- [x] 7.16 days away whose first day moved past the stop of a commitment taken up again inside them, removed, leave it owing no day between its stop and its take-up
- [x] 7.17 days away whose first day moved past the stop of a commitment taken up again inside them, moved back over it and removed, leave it owing no day between its stop and its take-up
- [x] 7.18 days away moved to end before a take-up made inside them leave the days between its stop and its take-up owing nothing — catches the take-up following their last day
- [x] 7.19 days away said over the days of a stop and take-up already made give the commitment back, once removed, no day between them
- [x] 7.20 days away moved to end before a stop made inside them, then removed, give the commitment back its days up to its stop and none after
- [x] 7.21 days away moved past a later stop of a commitment taken up again inside them, and back again, give it back the days between its take-up and that stop
- [x] 7.22 a take-up after days away that a change then covers comes back to its own day when they move back
- [x] 7.23 days away renamed leave the take-up of a commitment taken up again inside them where it was
- [x] 7.24 a commitment taken up again inside days away and then unticked from them owes its days up to its stop and from its take-up
- [x] 7.25 days away moved to end before the stop of a commitment taken up again inside them leave its take-up on the day it was made — catches the take-up kept at a day back
- [x] 7.26 days away moved off a stop and take-up made inside them, and back over them, leave both where they were made — catches either moved with the days away
- [x] 7.27 days away moved past the take-up of a commitment taken up again inside them leave it owing the same days whether moved in one change or two — the two-step move
- [x] 7.28 days away said, moved and removed over the days of a stop leave the commitment owing none of them — the first known gap
- [x] 7.29 a stop undone through a screen opened as of an earlier day leaves the days away over the commitment hiding their days — the second known gap
- [x] 7.30 a stop made through a screen opened as of a day before the commitment's take-up leaves days away giving back only its days before the stop — the second known gap's other shape
- [x] 7.31 days away moved wholly past a stop and back again hide the stopped commitment's days again — the review's (c)
- [x] 7.32 days away moved over a stopped commitment's days in one change or through days wholly past its stop leave it owing the same days — the review's (d)

## 8. `commitment` — listing and removing

- [x] 8.1 a commitments screen lists days away by name or Away, with their days in words and their commitments, earliest first — the carried test gains "none as past"
- [x] 8.2 days away move to the past list once their last day has passed, latest first, and stay at the roster place — catches the past list in the upcoming order
- [x] 8.3 a commitments screen that cannot read its roster lists no days away — the carried test gains "none as past"
- [x] 8.4 days away under way or past are offered for removal, and removed leave their days owed again and open to a record
- [x] 8.5 days away begun on a first day a commitment was kept through are removed whole

## 9. `commitment` — the roster store

- [x] 9.1 a roster store holding days away no roster could hold is refused — the carried test gains the place of two days away with one identity, its fixtures declaring form 11 with no `remembers`
- [x] 9.2 a roster kept while days away cut gaps into eras is read with those eras as written, and removing those days away gives back none of their days — catches a form-10 read that fills a gap or writes the place
- [x] 9.3 a commitment stopped, taken up again and stopped again around days away over it leaves a roster a roster store reads, and stays over them through a later change

## 10. `restore`, the look-back and shifts

- [x] 10.1 days away changed on a commitments screen write a copy at the copy place — catches `copyPlace?.keptAChange()` left out of the change
- [x] 10.2 a copy made before days away moved, restored, gives a commitment taken up again inside them back the days it held then — the stale take-up copy
- [x] 10.3 a tick commitment's look-back counts no day days away hide, and counts a day under them holding a record — catches the look-back left on the eras
- [x] 10.4 a week days away cover owes its quota in proportion to the days they leave — catches `WeekQuota.daysHeld` left on the eras
- [x] 10.5 a roster refuses to shift a weekday-set due day onto, or from, a day days away hide — catches `isFree` left on `holds`
- [x] 10.6 a roster shifts an every-N-days due day after days away on the count begun again the day after them — catches the shift reading the stored schedule's count
- [x] 10.7 a weekly-quota row on a day under days away holding a record counts that day among the days its week holds — pins a survivor, 2.11
- [x] 10.8 an every-N-days commitment's look-back counts its due days on the count begun again after days away — pins a survivor, 2.10
- [x] 10.9 a roster refuses to shift an every-N-days due day across days away, or onto the first due day of the count begun again after them — the review's finding 1, and 2.13
- [x] 10.10 a roster refuses to shift a weekday-set day a shift put a due day on onto a day days away hide — pins a survivor, 2.12

## 11. The shell (ADR-1019: no rule the Kit does not state)

- [ ] 11.1 `CommitmentsView` draws the past card, the Edit swipe, the change sheet, its Stopped section, its discard dialog and both record refusals — `recordOnDaysAway` and `recordedDayLeftNotDue` under their row, the second in the Days away card's footer for a removal — exactly as `design.md` § *The shell* says, in the words there, the sheet calling `changeDaysAway` alone to change
- [ ] 11.2 On the final build, `git diff --stat origin/main... -- src/DayByDay/` lists `CommitmentsView.swift` alone; the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 12. The records

- [ ] 12.1 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2); `CONTEXT.md` and ADR-1069 are as this folder's PR left them, and not edited since G4
- [x] 12.2 The known gap "A roster holding two days away with one identity is read without complaint" is gone from `docs/open-questions.md`, removed on this branch by the conductor, which owns that file; the `implementer` ticks this on seeing it gone and never edits the file itself
- [x] 12.3 **The conductor's, once 2.1–10.6 are ticked:** the conductor removes from `docs/open-questions.md`, on this branch, the known gaps *Days away can make a stopped commitment owe a day inside its stop* and *A stop or take-up made through a screen opened as of an earlier day can leave days away giving back or owing the wrong days*, and the open technical decision *Whether days away are laid over a commitment's life rather than cut into it*; the `implementer` ticks this on seeing all three gone and never edits that file
- [x] 12.4 The PR body says this round's rebuild: § 1.2's and § 1.3's lists, 2.5's counts and 2.6's lines, and one line per probe — the two known gaps, the stale take-up copy, the rhythm-change move-and-back, the two-step move, a change made at home then covered and moved back — naming the box that pins it
- [ ] 12.5 The PR body says this round's fix: § 1.5's list, 2.5's counts for the committed seed and five others, 2.6's and 2.8–2.13's lines, the red run of every new or rewritten test — of its mutation, for a box that pins a survivor — and one line per finding of the ninth review naming the box that answers it, finding 4 as gone with 2.7

## 13. The gates and the archive handover

- [ ] 13.1 `openspec validate change-days-away --strict` exits 0, and `pnpm run checks` is clean but for one `check:budgets` warning, on the carried *A commitments screen changes a commitment by renaming it, moving the day it is kept from, putting a new era on it, or declaring its usual amounts* — 597 words here, already over at 588 on `origin/main`; any other budget warning is a stop
- [ ] 13.2 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing, its count and one on `origin/main` both read off runs and given in the PR body
- [ ] 13.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 13.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked, W.7 included, and the walk comment's URL is in W.8. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `commitment`, `day-screen`, `look-back` and `restore` move, gaining this delta's 76 new scenarios and losing the six § 1.2 retires or retitles, and no other spec file does. **Any other drift is a stop and a report, never a hand-edit** — the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

A fresh install, walked on the simulator on any day from Monday 14 September 2026 on, light only,
nothing recorded. "Gym", "Run" and "Creatine" are not defined through the sheet: the fresh install
takes on the day-one roster (`ContentView.swift`, `dayOneCommitments`), which holds all three kept
from Friday 4 September 2026, so every day the walk visits, a week back included, is on or after it;
defining them again would be refused as names already in use. Before W.1: "Mallorca" said from
tomorrow through six days on over "Gym" and "Run", and "Sick" said over the three days ending a week
ago over "Creatine" — both through the sheet, since the first day may now be any day. No W line's
screen changes this round, but the Kit under every picture and `CommitmentsView`'s refusal words do,
so W.1–W.7 are all taken again on the final build and none is carried from an earlier round.

- [ ] W.1 The commitments screen scrolled to Days away — "Mallorca" over "Gym, Run" and "New days away" in the first card, "Sick" alone in a second card below it with no header.
- [ ] W.2 "Mallorca" swiped from the leading edge, the pencil tapped — the sheet titled "Change Mallorca" with "Save", the name and both days filled, "Gym" and "Run" with filled circles.
- [ ] W.3 The last day moved one day earlier and "Save" tapped — the list's "Mallorca" ending on its new last day.
- [ ] W.4 The day screen paged forward to Mallorca's old last day — no "Mallorca" line and no dot under that day, and the row of "Gym" or "Run" due that day, where either is, back.
- [ ] W.5 "Creatine" ticked on the day screen moved back to yesterday; "Mallorca" opened by Edit, its first day set to yesterday, "Creatine" picked, "Save" tapped — the sheet still open, the red refusal under the "Creatine" row naming it and yesterday.
- [ ] W.6 The sheet cancelled and "Discard" chosen, then the day screen moved back to the middle day of "Sick" — the "Sick" line above the rows, no "Creatine" row.
- [ ] W.7 "Sick" swiped, the trash and "Remove" in the alert tapped, the day screen moved back to that same day — no line, and the "Creatine" row back, not ticked.
- [ ] W.8 **The handover** — W.1–W.7, all retaken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL
