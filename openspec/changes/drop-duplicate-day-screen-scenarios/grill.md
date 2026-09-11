# Grill — drop-duplicate-day-screen-scenarios

*6 questions over 2 rounds, 2026-09-11. Line numbers are `openspec/specs/day-screen/spec.md`, the tests
and the source at `9bb4327`; re-anchor by title. DVT is
`src/DayByDayKit/Tests/DayByDayKitTests/DayViewTests.swift`, DST is `DayScreenTests.swift` beside it,
and bare `file:line` is under `src/DayByDayKit/Sources/`. Every verdict below was found by one
read-only pass over all 399 scenarios, the tests and the source, and confirmed pair by pair by a
second, independent one: 29 of 29 confirmed, none refuted.*

## Settled

1. **Settled before the grill, by the Story's brief, and recorded here so this folder carries it.**
   The four conditions of ADR-1047 decision 6 decide what is droppable. Each dropped scenario's test
   is deleted in this PR, and no test is added. Every requirement that loses a scenario is REMOVED
   and ADDED under a new heading, reworded as little as keeps it true, with **old → new listed side
   by side in `design.md`**. In-spec cross-references follow in the delta. `docs/backlog.md` quotes
   of a renamed heading are updated on `chore/backlog` after the archive, not in this PR.
2. **Twenty-nine scenarios are dropped, 399 → 370**, each against one keeper under the same
   requirement. The test named for each is deleted, and the `@Test` count in `DayByDayKitTests`,
   the target `swift test` runs, falls 1036 → 1007. No dropped test is a UI test.
   - *A day view is the commitments due on a date, each with whether it is kept*:
     - `a commitment ticked on the date has a row that says it is kept` (DVT:68-82) → `a tick on another date does not make the row say it is kept`. The tick and view dates shift together (History.swift:44). The keeper's test never asserts the name "Gym"; a row's name is its commitment's (DayView.swift:57).
     - `a commitment not ticked on the date has a row that says it is not kept` (DVT:84-97) → `a tick for a commitment the day view was not handed adds no row`. Literal; the keeper's WHEN adds a tick for another commitment.
   - *A row offers the tick that keeps its commitment, and refuses one for a day that has not arrived*:
     - `a row offers the tick for its commitment on the date the day view is of` (DVT:433-447) → `a row's answer follows the day it is asked as of rather than the day the day view was formed`. One path (DayView.swift:64-70); only the date shifts. See item 4.
   - *A day view is in the order it was handed its commitments*:
     - `rows are in the order the commitments were handed over` (DVT:232-250) → `a kept commitment keeps its place among the ones that are not kept`. Same THEN, same fixture, plus one tick.
   - *A day view is a value*:
     - `two day views of the same commitments, date and history are the same day view` (DVT:326-341) → `two day views differing only in a tick for a commitment neither was handed are the same day view`. One synthesised `==` (DayView.swift:3, 37); only the values differ.
   - *A day screen makes and takes back the tick a row offers, and keeps it before the day view says so*:
     - `ticking a row that says its commitment is not kept makes the day screen say it is kept` (DST:145-160) → `ticking one row leaves the other rows of the day as they were`. The add branch of `tick` (DayScreen.swift:234-238).
     - `a tick made on a day screen is held by a day screen opened afterwards at the same place` (DST:180-195) → `ticking a row on a day a day screen has moved back to keeps the tick on that day`. The same `add` through `tick` (:237) and the same read at init (:64-77).
   - *A day screen re-reads its day and its record when the app is shown again*:
     - `a day screen shown again reads the record again` (DST:504-520) → `a day screen that could not read its record starts keeping one when it is shown again and the record can be read`. `shown(asOf:)` reopens (:469-471) without reading the prior store or state.
   - *A day screen tells on the row that was tapped that a change could not be kept*:
     - `a refused tick is told on the row that was tapped` (DST:2139-2156) → `a refused tick is told on the row that was tapped and on no other row`. A notice is set only inside a catch that rethrows (:239-242), so being told implies the error the keeper's test asserts.
     - `a value that is not a number is told on the row, saying so` (DST:3465-3493) → `a value that is not a number committed in a total entry is told the same thing a number entry tells`. The not-a-number branch never reads the range (:273, :284), so its unranged half, which the keeper never runs, takes the same statement.
   - *What a day screen tells on a row lasts until the app is shown again, a change is kept, or the day it is showing changes*:
     - `what a day screen tells on a row ends when the same change is made again and is kept` (DST:2320-2349) → `what a day screen tells on a row ends when a change is kept on another row`. The same add (:237) and clear (:243), neither reading which row was refused.
   - *A day screen tells nothing on a row where there was no tick to refuse*:
     - `a commit on a day screen that is not keeping a record is told nothing on the row` (DST:3549-3576) and `a commit on a note row on a day screen that is not keeping a record is told nothing on the row` (DST:4374-4398) → `a commit on a total row on a day screen that is not keeping a record is told nothing on the row`. `enter` returns at :258-260 before it reads the kind or the text.
     - `a commit on a row for a day that has not arrived is told nothing on the row` (DST:3578-3598) and `a commit on a note row for a day that has not arrived is told nothing on the row` (DST:5432-5450) → `a commit on a total row for a day that has not arrived is told nothing on the row`. Every entry getter returns nil at its date guard (DayView.swift:75-77, 108-110, 132-134), and `enter` returns at :339-340.
     - `a tap on a row a day screen's day view does not hold is told nothing on the row` (DST:2635-2655) → `a tap on a row a day screen's day view does not hold does not end what is already told`. The keeper's WHEN is a superset; `tick` returns at :223-225.
     - `a commit on a row that offers no number entry is told nothing on the row` (DST:3600-3615) → `a commit on a row that offers no entry at all is told nothing on the row`. Every getter returns nil by kind, so `enter` reaches :339-340.
   - *A day screen reads its roster again when it is returned to*:
     - `what a day screen tells on a row stands when the screen is returned to and reads its record again` (DST:2030-2054) → `a day screen returned to goes on telling what it was telling on a row`. Both run at blocker places, which keep a record, so `returnedTo` re-reads in both (:493-497) and never writes the notice (:488-502).
   - *A day screen enters the number a row's entry takes, and keeps it before the day view says so*:
     - `entering a number on a row makes the day screen say the commitment is kept` (DST:2801-2819), `a number entered on a day screen is held by a day screen opened afterwards at the same place` (DST:2821-2843) and `the number entry a row offers says the number just entered on it` (DST:2845-2861) → `a number the commitment refuses keeps nothing and leaves the day as it was`. Its WHEN is a superset, as in the record Story's number precedent.
   - *A note entry says the note the day already holds, and says nothing else*:
     - `a note entry says the note the history holds for that commitment on that date` (DVT:1659-1674) → `a note entry says a note of many lines and many characters whole`. One getter (DayView.swift:107-117); only the text differs.
   - *A day screen enters the note a row's entry takes, and keeps it before the day view says so*:
     - `entering a note on a row makes the day screen say the commitment is kept` (DST:3765-3782) → `entering a note on one row leaves the other rows of the day as they were`.
     - `the note entry a row offers says the note just entered on it` (DST:3805-3821) → `a note entered on a day that already holds one replaces it`. See item 5.
   - *A day screen adds what is committed in a row's total entry, and keeps it before the day view says so*:
     - `reaching the target makes the day screen say the commitment is kept` (DST:4440-4457) and `an addition entered on a day screen is held by a day screen opened afterwards at the same place` (DST:4478-4500) → `committing nothing at all in a total entry keeps nothing and takes nothing back`. Its WHEN is a superset. See item 4.
   - *A day screen says whether it offers the way back to today*:
     - `a day screen showing the today it was handed offers no way back to today` (DST:5513-5529) → `going back to today on a day screen that offers no way back leaves it showing that today`. Its WHEN is a superset, and its test asserts the before-state.
   - *A day view says its day as a weekday*:
     - `a day view says its day as the three-letter name of its weekday` (DVT:1100-1106) → `every weekday is said by its own name`. Its WHEN is a superset.
   - *A day screen says the day it is showing*:
     - `a day screen says the day it is showing` (DST:593-608) → `a day screen says the day it was handed rather than the day it really is`. Init and title (DayScreen.swift:164-166, DayView.swift:179-181); only the date shifts.

   *Eight drops were surveyed; twenty-one were not. Six are their requirement's base case, spared by
   no condition, as on #214.*
3. **Five pairs whose lines match their keeper's but whose WHEN drives a different member are kept.**
   Condition 1's cover means the same members, the WHEN included:
   - `what a day screen tells about a refused value ends when the app is shown again`
   - `what a day screen tells about a refused value ends when the day screen is moved to the day before`
   - `a day screen sent back to today moves onto the new day when the app is shown again`
   - `a day screen moved into the future goes back to today in one step`
   - `a day screen sent back to today says the day either side of that today`

   *Dropping all five was the alternative (34 drops, 19 renames). The route is what each title is
   about, and #214 kept every sibling that drove its own member. The confirmation pass found that
   several differ by more than the member, too.*
4. **Two kept tests are brought up to their unchanged scenarios, and no assertion is weakened.**
   `a row's answer follows the day it is asked as of rather than the day the day view was formed`
   (DVT:554-568) gains the check that the tick exists; today its equality passes if both are nil.
   `committing nothing at all in a total entry keeps nothing and takes nothing back` (DST:4526-4552)
   gains the asserts its scenario already states: kept after the blank commits, and kept on the
   screen opened afterwards. *Each is the keeper of a drop whose test asserted the missing value.
   This permission is this Story's, as on #214; no other kept test is edited.* **A strengthened
   test that goes red stops the implementer**, which reports; that correction is withdrawn, the
   defect becomes a Story of its own, and the rest proceeds.
5. **The line-break note is dropped** on the code path. `Blank.trimmed` strips only the ends
   (Blank.swift:9-15), so interior line breaks take the same statements, and line breaks are no
   clause of that requirement's rule. *Keeping it was the alternative; the confirmation pass called
   it the thinnest of the 29.*
6. **Seventeen requirements take new headings, in one Story, with no cap and no split.** OpenSpec
   1.10.0 appends ADDED requirements after every survivor, in delta order. The seventeen move from
   their places to positions 35–51, and *A day view is the commitments due on a date…* moves from
   first to thirty-fifth. *Splitting does not avoid the reordering, since every rename appends
   whichever Story makes it; it buys a second pipeline run. Sparing the first four requirements was
   the alternative.*
7. **Cross-references follow the renames.**
   - *A day screen draws the commitments its roster had not stopped keeping on the day it is
     showing* cites *A day view is a value* by heading. It becomes MODIFIED, carried whole, stays in
     place, and changes that reference only.
   - *A day screen says the day it is showing* cites *A day screen says whether it offers the way
     back to today*. Both are renamed, so the reference changes inside the ADDED block.
   - Four references point by position or description rather than by heading: "the four causes
     named above", "ends on exactly three things", and two cite "the requirement on entering a
     number". **The ADDED blocks keep spec order**, so the first stays true. *Facts, not a question.*
8. **ADR-1026:72, a live reference to *A day view is a value*, names the new heading in this PR.**
   ADR-1037:25 and ADR-1038:59 quote *A day view is in the order it was handed its commitments*
   inside dated decisions, and stay as they are, 1038's inexact quote included. *Updating all three
   and touching none were the alternatives.*
9. **One false sentence is fixed in this PR.** *A day screen holds the day view of the day it was
   handed, formed from the record kept at its place* says the screen is moved onto another day "by
   nothing else" but a move or the app being shown again. *A day screen shows a day picked on its
   day picker* changes the day by a pick, and *A day screen says the day it is showing* lists the
   three apart. That requirement is MODIFIED, carried whole, and stays in place, with one clause
   adding the pick. Going back to today is already a move ("SHALL move the day being shown"), so
   nothing else changes. *Recording it for a later editorial Story was the alternative; #214 item 12
   is the precedent.*
10. **Not asked, and settled by a rule or a fact:**
    - **Condition 4** reads "pin": a boundary the scenario is about. The default fixture day,
      Monday 31 August 2026, is a month end, so many moves cross a boundary incidentally. #214
      dropped `a commitment was not kept on a date it is not due on`, which runs from 31 August to
      1 September.
    - **Condition 2** reaches none of the 29. Every prohibition any of them names is stated as a
      SHALL NOT, not a MUST NOT.
    - **ADR-1047 decision 5's day-screen title**, `a day screen returned to does not read its record
      again`, is not droppable. It is the only scenario for its SHALL NOT clause, which fails
      condition 3, and no other scenario asserts what it does, which fails condition 1. Decision 5
      is untouched.
    - **ADR-1047 and `CONTEXT.md` are not edited, and no ADR is written.** Items 3–5 read the
      rule; they do not change it.
11. **The surveyed titles not dropped are kept, 49 of them**, for these reasons:
    - Most fail condition 1: the cover is split across two scenarios, or it sits under another
      requirement. Survey B's four-kind, later-or-earlier and note-clone families all sit across
      requirements.
    - Others fail condition 3: `a row says its rhythm whether or not its commitment is kept`,
      `a day screen showing a day picked on its day picker says that day`, and the stopped and
      removed pair of the day picker.
    - The R21 "ends when a number/note/addition … is kept" family each drives its own member.
    - One surveyed pair, the "says the date and not Today" titles, no longer exists.
12. **`docs/backlog.md` quotes *A day screen tells nothing on a row where there was no tick to
    refuse*** at `main`:424-425 and `origin/chore/backlog`:596-597. That quote is updated on
    `chore/backlog` after the archive (item 1). No source doc comment and no other spec quotes a
    renamed heading.
13. **The surveys were wrong in these places**, recorded so nobody re-trusts them:
    - The R22 keepers they named drive `tick`, not `enter`.
    - The R21 "ends when … kept" family was called droppable against tick scenarios.
    - Survey B counted nine and left six.
    - `a value that is not a number is told on the row, saying so` was kept for a reason that
      protects only its keeper.
    - The four-kind version survey B would keep does not exist under any one requirement.
    - Survey C proposed merges, and a merge edits a kept scenario.
    - Survey C kept one refused-value scenario while dropping its twin.
    - All three surveys missed twenty-one drops.

*Residual round, 2026-09-11: two questions asked before G4, after a verifier read the folder.*

14. **The seven headings that added a clause of four to seven words are cut back** to the smallest
    change that keeps them true and distinct. That is the one-to-three-word size of the other ten,
    and of #211's and #214's headings. ADR-1026:72 and the in-spec references follow the shorter
    headings. The new heading of *A day screen tells on the row that was tapped that a change could
    not be kept* still opens with the words `docs/open-questions.md:304` quotes. *Asked because grill
    item 1 says "as little as keeps it true", and the delta's changes ranged from one word to seven.
    One of the seven, quoted inside* A day screen says the day it is showing, *took that requirement
    from 150 words to 154.*
15. **Both kept-test strengthenings of item 4 run before any deletion.** If either one goes red, the
    implementer stops before deleting anything. The folder then returns to G4 with that
    strengthening, and the drops that rest on it, withdrawn. The correction becomes a Story of its
    own. This replaces item 4's "the rest proceeds", which could only ever have meant "after a
    second approval". *Asked because the signed folder left a dependent deletion that could be
    neither ticked nor skipped. It could have been asked at the grill, and was missed there.*
16. **`docs/open-questions.md` quotes renamed headings, and the grill's search missed it.** It
    quotes one prefix under *Known gaps*, which item 14 keeps true. It also quotes full headings in
    a dated *Settled* entry, which stay under item 8's rule. *Found by `spec-author`. Item 12's
    search covered `docs/backlog.md` and `docs/adr/`, but not the rest of `docs/`.*

## Terms landed in CONTEXT.md

None. *Pruning Story* already stands, and nothing settled here names a new thing.

## Left open

None. Every question the frontier raised was answered, and every surveyed candidate and every
unsurveyed pair has a verdict. The only follow-ups are the backlog quote in item 12, and #199's box
14 with its outcome comment, both after the merge.
