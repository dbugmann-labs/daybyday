## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): a carried scenario that is not byte-for-byte what it is today, a rebase conflict in this
folder or in `openspec/specs/`, a new test other than 3.8 arriving red, 3.8 arriving green, a fix
that would reach beyond § 4, or a test failing after § 4 other than the two 4.2 names.

This is a covering Story. Each box in § 3 is one red-green cycle: write the one test named for the
scenario and run it. Green on arrival is accepted. 3.8 is expected red, and its red is fixed by § 4
alone (`design.md` § *The one red, and its fix*).

## 2. The carried requirements

- [x] 2.1 `git diff --no-index` of each of the ten MODIFIED blocks against the current spec shows only its appended scenarios
- [ ] 2.2 `git diff --no-index` of the one `day-screen` MODIFIED block against the current spec shows only the two removed "committing nothing at all on that row" AND lines, two lines each

## 3. The twelve scenarios — one test each

- [x] 3.1 a store holding a tick against a commitment of another kind, or a note of other blank space, is refused — `RecordStoreTests.swift`; catches an ASCII-only blank test on read
- [x] 3.2 a store holding a day whose later addition is not above zero is refused — `RecordStoreTests.swift`; catches a first-amount or sum check
- [x] 3.3 taking back a note leaves another commitment's number on the same day standing — `RecordTests.swift`; catches a take-back clearing the day
- [x] 3.4 taking back the last addition leaves every other kind of record on the same day standing — `RecordTests.swift`; catches the same for an addition
- [x] 3.5 carrying over is refused whole where only some of the records could be the other commitment's — `RecordTests.swift`; catches a partial move
- [x] 3.6 a number, a note and a day's additions carried over through a store are read back under the other commitment by a store opened afterwards — `RecordStoreTests.swift`; catches a store carrying ticks alone
- [x] 3.7 a carry-over through a store leaves at its place what a store given those records under the other commitment holds — `RecordStoreTests.swift`; catches a moved form on disk
- [x] 3.8 a change that leaves a store's history as it was writes nothing at its place — `RecordStoreTests.swift`; expected red, fixed by § 4
- [x] 3.9 a store keeps a day's additions at its place and never their sum — `RecordStoreTests.swift`; catches a persisted sum
- [x] 3.10 a tick does not keep a commitment alike in name and kind but on another schedule or kept from another day — `RecordTests.swift`; catches a widened question
- [x] 3.11 a text of one zero-width space is a note — `RecordTests.swift`; catches a `CharacterSet` blank test
- [x] 3.12 a take-back that cannot be kept is refused and the record stays held — `RecordStoreTests.swift`; catches a history changed before the write

## 4. The one fix

- [x] 4.1 3.8 was run red first; `RecordStore.swift`'s diff is only a return before writing in each change method whose next state equals the current one, 3.8 is green, and the PR body names the fix
- [ ] 4.2 In `DayScreenTests.swift`, *a number refused by the place is told on the row and names no cause* and *a note refused by the place is told on the row and names no cause* each lose only their blank-commit block (the second screen, committing `""`) and nothing else, and both pass

## 5. The gates

- [ ] 5.1 `openspec validate cover-record-rules --strict` exits 0, and `pnpm run check:scenarios` exits 0.
- [ ] 5.2 `git diff --stat origin/main -- src/` lists only `RecordStore.swift`, `RecordStoreTests.swift`,
      `RecordTests.swift` and `DayScreenTests.swift`.
- [ ] 5.3 `pnpm run check:budgets` warns about the six carried requirements `design.md` § *No rule is
      reworded* names and nothing else in this folder, and `pnpm run verify` passes.
- [ ] 5.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is twelve more than a run
      on `main` reports, both read off runs and never derived.
- [ ] 5.5 **The archive handover — `implementer` ticks this in its last commit before the archive**,
      on the evidence that 2.1–5.4 are ticked and that the instruction below is written here for the
      janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of
      the sync it prints, then reads the spec diff it produced: in `openspec/specs/record/spec.md`
      exactly twelve scenarios are added, each at the end of one of the ten carried requirements, and
      nothing else moves; in `openspec/specs/day-screen/spec.md` exactly the two AND lines 2.2 names
      are removed, and nothing else moves; `pnpm run checks` runs after the archive commit exists. **Any other drift is
      a stop and a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and
      `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here
      cannot be reached afterwards.
