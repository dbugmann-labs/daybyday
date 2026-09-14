## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): a carried scenario that is not byte-for-byte what it is today, a rebase conflict in this
folder or in `openspec/specs/`, or a red test whose fix would reach beyond the one scenario that
failed.

This is a covering Story. Each box in § 3 is one red-green cycle: write the one test named for the
scenario in `DayScreenTests.swift`, run it. Green on arrival is accepted. Red is the red: make the
least change in `src/DayByDayKit/Sources/` that turns that one test green, and name it in the PR body
(`design.md` § *A red test is fixed here, and only that*). Never run the `DayByDayUITests` bundle.

## 2. The carried requirements

- [x] 2.1 A script shows each of the sixteen MODIFIED blocks byte-identical to the current spec but for its appended scenarios and, in *A day screen enters the number…*, the one sentence `design.md` § *Reworded after `cover-record-rules`* names

## 3. The scenarios — one test each

- [x] 3.1 a day screen that is not keeping a roster moves and goes on saying why — catches a screen that does not move, or a move resetting the roster's state or reason
- [x] 3.2 a tick kept on a day screen is still shown after it moves away and back, goes back to today or has that day picked — catches a record read once and cached
- [x] 3.3 going back to today does not read the roster again — catches a return to today reading the roster, or resetting what it says of a roster it is not keeping
- [x] 3.4 a day screen sent back to today draws the commitments its roster had not stopped keeping on that today — catches a return formed on the day left
- [x] 3.5 a tick made on a day screen that cannot read its record is not kept once the record can be read — catches a queued tick written once the record reads or with the next kept tick
- [x] 3.6 a day screen whose record place cannot be opened for another reason answers as one that cannot read its record — catches a read error answered apart
- [x] 3.7 a day screen draws a removed commitment under a category exactly as it draws a stopped one — catches a removed commitment lifted out of its group
- [x] 3.8 a day screen whose roster place cannot be opened for another reason does not say the roster is from a later version — catches a read error named a later version
- [x] 3.9 a number whose zeros lie outside its significant digits is entered exactly — catches zeros counted as significant
- [x] 3.10 a number too large to hold keeps nothing and takes nothing back — catches a magnitude fitted to what can be held
- [x] 3.11 a number with spaces among its digits keeps nothing and takes nothing back — catches spaces stripped inside the text
- [x] 3.12 a day screen showing the first supported date says no day view before it whatever its places, its rows and its today — catches an absence keyed to anything but the calendar
- [x] 3.13 every change asked of a row a day screen says of the day before changes nothing and leaves what it is telling — catches any gesture reaching a neighbour row
- [x] 3.14 a day screen's day picker reaches back to the day a commitment is kept from though nothing is due on that day — catches a reach narrowed to due commitments
- [x] 3.15 a day screen shown again reads the reach of its day picker off the roster it then reads — catches a reach read again only on a return
- [x] 3.16 saying the day either side of a day screen keeps nothing at either place — catches a neighbour read that writes
- [x] 3.17 a tick made on a day screen does not change what it says about its roster — catches a tick reading the roster again
- [x] 3.18 a day screen shown again carries over no reason it gave for not keeping its record or its roster — catches a later-version reason carried over
- [x] 3.19 a commit on a day screen holding a record from a later version is told nothing whatever was committed — catches a value checked before the record's state
- [x] 3.20 a day screen returned to where its roster cannot be read says so and draws no rows — catches a return keeping the old state or rows
- [ ] 3.21 committing an empty entry at a place that cannot be written is refused only on a row whose day holds a number — catches a take-back written where the day holds none, or skipped where it holds one; the test under the replaced title goes

## 4. The record

- [x] 4.1 `docs/open-questions.md` § *Known gaps* gains one new bullet for `day-screen` holding every rule in `grill.md` answers 8, 9 and 11 and `design.md`'s reclassified 1717, in those groups, with C3 as unreachable at the seam — none dropped, none added

## 5. The gates

- [x] 5.1 `openspec validate cover-day-screen-rules --strict` exits 0, and `pnpm run check:scenarios` exits 0.
- [x] 5.2 `git diff --stat origin/main -- src/` lists only `DayScreenTests.swift`, or also the one source
      file a red arrival fixed, and that fix is named in the PR body.
- [x] 5.3 `pnpm run check:budgets` warns about nothing in this folder but the seven carried requirements
      `design.md` names, and `pnpm run verify` passes.
- [x] 5.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is the added scenarios more
      than a run on `main` reports, both read off runs and never derived.
- [ ] 5.5 **The archive handover — `implementer` ticks this in its last commit before the archive**,
      on the evidence that 2.1–5.4 are ticked and that the instruction below is written here for the
      janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of
      the sync it prints, then reads the spec diff it produced: in `openspec/specs/day-screen/spec.md`
      only scenarios are added, each at the end of one of the sixteen carried requirements, the one
      sentence `design.md` § *Reworded after `cover-record-rules`* names is reworded, and nothing else
      moves; `pnpm run checks` runs after the archive commit exists. **Any other drift is
      a stop and a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and
      `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here
      cannot be reached afterwards.
