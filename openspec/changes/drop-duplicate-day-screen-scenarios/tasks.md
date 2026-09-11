## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): the archiver refusing a block, a keeper test that does not assert what `design.md` says it
does, a carried requirement that is not byte-for-byte what it is today but for the sentences § 4
names, or a rebase conflict in this folder or in `openspec/specs/`.

This is a pruning Story: no test is written, and rule 3's loop has no red. **§ 2 is finished before
any § 3 box is started.** Each § 3 deletion box is ticked only once the keeper `design.md` names for
it has been read and its own `#expect` holds every value the deleted test asserted. The only other
edits to `src/` are § 2's two kept tests and § 3's three restorations. § 4 is one box per carried
requirement rather than per scenario, because no carried scenario has work of its own.

## 2. The two kept tests — both run before any deletion

Each box brings a kept test to its unchanged scenario, title and every assertion kept, and is ticked
when that test passes. **A red on either is a stop before any deletion** (grill item 15): put the test
back as it is on `main`, delete nothing, and report. The folder then returns to G4 with that
strengthening and the drops resting on it withdrawn — 3.3 rests on 2.1, and 3.25 and 3.26 on 2.2 —
and the correction becomes a Story of its own.

- [x] 2.1 Bring `a row's answer follows the day it is asked as of rather than the day the day view was formed` to check the second asking offers a tick, not only that it equals one
- [x] 2.2 Bring `committing nothing at all in a total entry keeps nothing and takes nothing back` to check kept after the spaces and line breaks, and on the screen opened afterwards

## 3. The twenty-six deletions and three restorations — one box per scenario

- [ ] 3.1 Restore `a commitment ticked on the date has a row that says it is kept` in `DayViewTests.swift` from `origin/main`, unchanged — withdrawn by grill item 20
- [x] 3.2 Delete `a commitment not ticked on the date has a row that says it is not kept` from `DayViewTests.swift`
- [x] 3.3 Delete `a row offers the tick for its commitment on the date the day view is of` from `DayViewTests.swift` — rests on 2.1
- [x] 3.4 Delete `rows are in the order the commitments were handed over` from `DayViewTests.swift`
- [x] 3.5 Delete `two day views of the same commitments, date and history are the same day view` from `DayViewTests.swift`
- [x] 3.6 Delete `ticking a row that says its commitment is not kept makes the day screen say it is kept` from `DayScreenTests.swift`
- [x] 3.7 Delete `a tick made on a day screen is held by a day screen opened afterwards at the same place` from `DayScreenTests.swift` — its note sibling stays; its number and addition siblings are 3.20 and 3.26
- [x] 3.8 Delete `a day screen shown again reads the record again` from `DayScreenTests.swift`
- [x] 3.9 Delete `a refused tick is told on the row that was tapped` from `DayScreenTests.swift` — its title is a prefix of its keeper's; delete only the exact name
- [x] 3.10 Delete `a value that is not a number is told on the row, saying so` from `DayScreenTests.swift`
- [x] 3.11 Delete `what a day screen tells on a row ends when the same change is made again and is kept` from `DayScreenTests.swift` — every other "ends when … kept" test stays
- [x] 3.12 Delete `a commit on a day screen that is not keeping a record is told nothing on the row` from `DayScreenTests.swift`
- [x] 3.13 Delete `a commit on a note row on a day screen that is not keeping a record is told nothing on the row` from `DayScreenTests.swift`
- [ ] 3.14 Restore `a commit on a row for a day that has not arrived is told nothing on the row` in `DayScreenTests.swift` from `origin/main`, unchanged — withdrawn by grill item 17
- [ ] 3.15 Restore `a commit on a note row for a day that has not arrived is told nothing on the row` in `DayScreenTests.swift` from `origin/main`, unchanged — withdrawn by grill item 17
- [x] 3.16 Delete `a tap on a row a day screen's day view does not hold is told nothing on the row` from `DayScreenTests.swift`
- [x] 3.17 Delete `a commit on a row that offers no number entry is told nothing on the row` from `DayScreenTests.swift` — its take-back sibling, told nothing on a row offering no take-back, stays
- [x] 3.18 Delete `what a day screen tells on a row stands when the screen is returned to and reads its record again` from `DayScreenTests.swift`
- [x] 3.19 Delete `entering a number on a row makes the day screen say the commitment is kept` from `DayScreenTests.swift`
- [x] 3.20 Delete `a number entered on a day screen is held by a day screen opened afterwards at the same place` from `DayScreenTests.swift`
- [x] 3.21 Delete `the number entry a row offers says the number just entered on it` from `DayScreenTests.swift`
- [x] 3.22 Delete `a note entry says the note the history holds for that commitment on that date` from `DayViewTests.swift`
- [x] 3.23 Delete `entering a note on a row makes the day screen say the commitment is kept` from `DayScreenTests.swift`
- [x] 3.24 Delete `the note entry a row offers says the note just entered on it` from `DayScreenTests.swift`
- [x] 3.25 Delete `reaching the target makes the day screen say the commitment is kept` from `DayScreenTests.swift` — rests on 2.2
- [x] 3.26 Delete `an addition entered on a day screen is held by a day screen opened afterwards at the same place` from `DayScreenTests.swift` — rests on 2.2
- [x] 3.27 Delete `a day screen showing the today it was handed offers no way back to today` from `DayScreenTests.swift`
- [x] 3.28 Delete `a day view says its day as the three-letter name of its weekday` from `DayViewTests.swift`
- [x] 3.29 Delete `a day screen says the day it is showing` from `DayScreenTests.swift`

## 4. The carried requirements — one box per requirement in the delta

Each is ticked when its prose and scenarios are byte-for-byte the current spec's but for what its line
names, and every test under it passes.

- [x] 4.1 *A day screen holds the day view of the day it was handed, formed from the record kept at its place* — only the sentence adding a picked day differs
- [x] 4.2 *A day screen draws the commitments its roster had not stopped keeping on the day it is showing* — only the cited heading of 4.6 differs
- [ ] 4.3 *A day view holds the commitments due on a date, each with whether it is kept* — the scenario of 3.1 is carried in place
- [x] 4.4 *A row offers the tick that keeps its commitment, and offers none for a day that has not arrived*
- [x] 4.5 *A day view's rows are in the order it was handed its commitments*
- [x] 4.6 *A day view is a value and nothing else*
- [x] 4.7 *A day screen makes and takes back the tick a row offers, and keeps the change before the day view says so*
- [x] 4.8 *A day screen re-reads its day and its places when the app is shown again*
- [x] 4.9 *A day screen tells on the row that was tapped that its change could not be kept*
- [x] 4.10 *What a day screen tells on a row lasts only until the app is shown again, a change is kept, or the day it is showing changes*
- [ ] 4.11 *A day screen tells nothing on a row where there was no change to refuse* — the two scenarios of 3.14 and 3.15 are carried in place
- [x] 4.12 *A day screen reads its roster again whenever it is returned to*
- [x] 4.13 *A day screen enters the number a row's entry takes, and keeps the change before the day view says so*
- [x] 4.14 *A note entry says the whole note the day already holds, and says nothing else*
- [x] 4.15 *A day screen enters the note a row's entry takes, and keeps the change before the day view says so*
- [x] 4.16 *A day screen adds what is committed in a row's total entry, and keeps the change before the day view says so*
- [x] 4.17 *A day screen answers whether it offers the way back to today*
- [x] 4.18 *A day view says its day as its weekday*
- [x] 4.19 *A day screen says which day it is showing* — only the cited heading of 4.17 differs, its paragraph rewrapped

## 5. The gates

- [ ] 5.1 `openspec validate drop-duplicate-day-screen-scenarios --strict` exits 0.
- [ ] 5.2 `pnpm run check:scenarios` exits 0 — every title the delta carries still names a test.
- [ ] 5.3 None of the twenty-six dropped titles is found as an exact test name under `src/`, each
      title of 3.1, 3.14 and 3.15 is found exactly once and byte-identical to `origin/main`, and
      `git diff --stat origin/main -- src/` lists only `DayViewTests.swift` and `DayScreenTests.swift`.
- [ ] 5.4 `pnpm run check:budgets` warns about nothing in this folder but the ten requirements
      `design.md` § Context names, and `pnpm run verify` passes.
- [ ] 5.5 `swift test` in `src/DayByDayKit` passes and reports twenty-six fewer tests than on `main`,
      both counts read off a run and never derived.
- [ ] 5.6 **The archive handover — `implementer` ticks this in its last commit before the archive**,
      on the evidence that 2.1–5.5 are ticked and that the instruction below is written here for the
      janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of
      the sync it prints, then reads the spec diff it produced: in `openspec/specs/day-screen/spec.md`
      the seventeen requirements of 4.3–4.19 leave their places and reappear after every other
      requirement, in that order, under their new headings; the twenty-six dropped scenarios are gone;
      the sentences 4.1 and 4.2 name are the delta's; and nothing else moves. After the archive commit,
      `git status` is clean and `openspec/changes/drop-duplicate-day-screen-scenarios/` no longer
      exists, its deletion committed with the archive, and `pnpm run checks` runs after that commit
      exists. **Any other drift is a stop and a report, never a hand-edit** — rule 2 denies
      `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a
      box left unticked here cannot be reached afterwards.
