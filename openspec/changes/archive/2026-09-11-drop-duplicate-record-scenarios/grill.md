# Grill — drop-duplicate-record-scenarios

*10 questions over 3 rounds, 2026-09-11. Line numbers are `openspec/specs/record/spec.md` and the
tests at `cd08895`; re-anchor by title. RT is `src/DayByDayKit/Tests/DayByDayKitTests/RecordTests.swift`,
RST is `RecordStoreTests.swift` beside it. Every verdict below was found by one read-only pass over
the current spec, tests and source, and confirmed pair by pair by a second, independent one.*

## Settled

1. **Sixteen scenarios are dropped, 170 → 154.** Each against one keeper under the same
   requirement, and each passes ADR-1047 decision 6's four conditions. The test named for each is
   deleted; the test count falls by exactly sixteen.
   - *A tick is of a commitment on a calendar date it is due on* (R1):
     - `a tick is formed for a commitment on a date it is due on` (RT:5-16) → `a commitment whose kind is not a tick takes no tick on a date it is due on`, whose AND forms a tick for a commitment alike but of the tick kind (RT:392); `Tick.init?` never reads the name (Tick.swift:5-16).
   - *A history answers whether a commitment was kept on a day from the ticks it holds* (R2):
     - `a commitment ticked on a date was kept on that date` (RT:156-169) → `a tick of one commitment does not keep another on the same date`, AND at RT:198. Literal.
     - `a commitment ticked on one date was not kept on another date it is due on` (RT:170-184) → `a history answers each date on its own across a week` (RT:238-240).
     - `a commitment was not kept on a date it is not due on` (RT:201-215) → the same keeper, whose week holds Tuesday 1 September.
     - `a number commitment with a number recorded on a date was kept on that date` (RT:872-886) → `every number a commitment accepts keeps its day, whatever the number is` (RT:930-933); `isKept` never reads the value (History.swift:53).
     - `a note commitment with a note recorded on a date was kept on that date` (RT:1411-1423) → `every note a commitment accepts keeps its day, whatever it says` (RT:1459-1462).
   - *A tick can be taken back* (R3):
     - `a tick taken back leaves the commitment not kept on that date` (RT:282-296) → `taking back a tick leaves the same commitment's ticks on other dates standing` (RT:313). Literal. R3's MUST NOT is named by the kept `a history ticked and then unticked is the same as one never ticked`.
   - *A history answers what number a commitment has on a day from the numbers it holds* (R6):
     - `a number added to a history is the number that commitment has on that day` (RT:608-623) → `a number the commitment refuses leaves the number already on that day standing` (RT:702). Literal.
   - *A note is of a note commitment on a calendar date it is due on* (R8):
     - `a note is recorded for a note commitment on a date it is due on` (RT:973-984) → `a note takes any length, any script and a line break`, whose first text is the same (RT:1091).
   - *A history answers what note a commitment has on a day from the notes it holds* (R9):
     - `a note added to a history is the note that commitment has on that day` (RT:1146-1160) → `a text the system refuses leaves the note already on that day standing` (RT:1251); one member, only the text differs.
   - *An addition is of a total commitment on a calendar date it is due on* (R11):
     - `an addition is recorded for a total commitment on a date it is due on` (RT:1479-1490) → `a commitment whose kind is not a total takes no addition on a date it is due on`, AND at RT:1547; the name is unread (Addition.swift:14-30).
   - *A history answers what a commitment has added on a day from the additions it holds* (R12):
     - `an addition added to a history is the total that commitment has on that day` (RT:1637-1650) → `the additions of one day are not counted in another day's total` (RT:1681). Literal.
   - *A store keeps what it is given before it reports it kept* (R18):
     - `a tick added to a store is held by a second store opened at the same place while the first is still open` (RST:23-38) → `stores at different places hold different histories` (RST:213, 219). See item 3.
     - `a tick taken back is not held by a store opened afterwards at the same place` (RST:39-56) → `a store opened again holds exactly the ticks added and not taken back`, whose last write is that `remove` (RST:75, 83).
     - `a number taken back is not held by a store opened afterwards at the same place` (RST:391-410) → `a store opened again holds exactly the ticks and numbers added and not taken back`, last write `removeNumber` (RST:483, 494).
     - `a note taken back is not held by a store opened afterwards at the same place` (RST:858-875) → `a store opened again holds exactly the ticks, numbers and notes added and not taken back`, last write `removeNote` (RST:953, 963).

   *The last two keepers are not the surveys': they named the tick scenario, which drives a different
   `RecordStore` member. The three "store opened again holds exactly" keepers are therefore kept.*
2. **Cover split across two kept scenarios is not cover.** Condition 1 reads singular. Three stay:
   `a commitment of the note kind and one of the total kind were not kept on a date they are due on`,
   `a total commitment whose day's additions reach its target was kept on that date`, and `a number is
   recorded for a number commitment on a date it is due on`. *Yes would have amended ADR-1047 for
   #215 and #216 too.*
3. **"While the first is still open" names no code path**, so the tick scenario goes. `RecordStore`
   has no close and holds no handle: it reads once at init and writes atomically per change. Its
   number, note and addition siblings stay, each driving its own member.
4. **The eleven drops no survey named are all taken, base cases included.** Six of the sixteen
   are their requirement's simplest positive case, whose rule then shows only in another scenario's
   AND. *The four conditions do not spare a base case, and sparing one would be a new rule. One
   Story is cheaper than a second pipeline run on this spec.*
5. **Nine requirements are renamed, in one Story, with no cap and no split.** They are R1, R2, R3,
   R6, R8, R9, R11, R12 and R18. The archiver (1.10.0) appends ADDED requirements after every
   survivor, in delta order. The spec then reads R4, R5, R7, R10, R13–R17, R19, then the nine,
   so the tick definition moves from first to eleventh. *Accepted with item 4.*
6. **The thirty other surveyed candidates are kept.** Each fails condition 1, and several also
   fail 3. The three "added over a history kept in an earlier form" scenarios, both "shape and
   declared form disagree" siblings, and the number and note "still takes no tick" kind refusals
   stay. So do the number, note and addition "held by a second store … still open" and "cannot be
   kept is refused" families, whose sibling members order their own writes. Also kept: the
   three "store opened again holds exactly", the six date and commitment isolation titles, "a note
   written again" and "an amount is read back exactly", "a total commitment is kept on one day and
   not on another", and "a carry-over with nothing to carry keeps nothing at a store's place".
7. **Condition 2 does not reach `a commitment was not kept on a date it is not due on`.** It is the
   only title naming "SHALL be answered not kept rather than refused" (spec:145-146). That is not a
   MUST NOT, and the schedule grill's item 11 limits condition 2 to one. *Not asked, and settled by
   that answer.*
8. **Two source doc comments that cite a renamed heading are corrected here, comment only.** They
   are `Note.swift:2` (R8) and `Addition.swift:4` (R11). `Number.swift:4` cites R5, which is not
   renamed. *The Story that makes them false fixes them; G7 checks no code line moves.*
9. **Seven kept tests are brought to their unchanged scenarios**, and no assertion is weakened.
   The source predicts every one green:
   - `a note added to a store is held by a second store opened at the same place while the first is still open` — the text becomes "Ran 8k before work. Knee held up." (RST:848, 854).
   - `a day's last addition taken back is not held by a store opened afterwards at the same place` (RST:1309-1326) — the scenario adds 30 then 90, takes the last back, and gets 30, the same as 30 alone, and nothing after a second take-back. The test adds 30 alone and asserts 0 and empty.
   - `a day's additions are read back in the order they were made` (RST:1294-1306) — the scenario adds 30, 45, 50 and gets 125, a history equal to those three in order, and 75 after a take-back. The test uses 45, 30.
   - `a store whose shape and declared form disagree about numbers is refused` (RST:619) and `… about notes is refused` (RST:1236) — version 4 becomes the current form 5, and each fixture carries `"additions": []`. *Without it the shape check no longer isolates numbers or notes.*
   - `two histories holding the same numbers are the same history` (RT:711) and `two histories holding the same notes are the same history` (RT:1260) — Saturday 5 September becomes Wednesday 2 September 2026.

   *Asked because the pruning lane says nothing of editing a kept test. The five found while
   comparing pairs joined, and so did two that a literal scan of all 170 scenarios found. No full
   audit.*
10. **This permission is this Story's, not the lane's.** `grill.md` and `design.md` name the seven
    tests and the two lines in item 12. `tasks.md` permits exactly those, and ADR-1047 and
    `CONTEXT.md` are not edited. *#215 and #216 decide their own at their grills.*
11. **A corrected test that goes red stops the implementer**, which reports. That correction is
    withdrawn from this Story and the defect becomes a Story of its own; the rest proceeds.
12. **Two scenario lines are false and are reworded here, titles unchanged.** `carrying over the
    records of a commitment that has none refuses nothing and changes nothing` (spec:1286) and `a
    carry-over with nothing to carry keeps nothing at a store's place` (spec:1341) say the report
    is "carried nothing over", which is the prose's word for a refusal (spec:1236). The same prose
    says that case SHALL NOT refuse (spec:1237-1238). The code reports `true` there
    (History.swift:110-115, RecordStore.swift:189-191), `CommitmentsScreen.swift:424` treats
    `false` as refusal, and the repair path in the archived `add-commitment-editing` relies on it.
    *A history carries every record of one commitment over to another* (R14) and *A store carries
    every record of one commitment over to another, at its place* (R15) are MODIFIED, carried whole
    and staying in place, with those two lines only changed. Their tests are right and untouched.
13. **No renamed heading is quoted outside the spec** — not in another spec, `docs/adr/`,
    `CONTEXT.md`, or `docs/backlog.md` on `main` or `origin/chore/backlog`. Only item 8's comments
    and the research surveys quote one. There are no in-spec cross-references, so no backlog quote
    is owed after the archive.
14. **The surveys were wrong in five places**, recorded so nobody re-trusts them:
    - the "strictly cumulative" store-reopened family;
    - both taken-back keepers;
    - the "L550" day-isolation keeper;
    - `… kind is not a tick …` as keeper for the note-and-total pair, which asserts only a number
      commitment;
    - "identical assertions" for the cannot-be-kept family.

## Terms landed in CONTEXT.md

None. *Pruning Story* already stands; items 9–12 are this Story's and name no new thing.

## Left open

None. Every question the frontier raised was answered, and every survey candidate and unsurveyed
pair has a verdict. The only follow-ups are #199's box 13 and its outcome comment, after the merge.
